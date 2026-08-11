report 14021390 "NS_CopyCrew to CustomTimesheet"
{
    // +------------------------------------------------------------
    //PRJ-772.AS.1.0 12July2021 New Report
    // +------------------------------------------------------------
    //PRJ-841.JS.1.0 20Aug2021 | added code to add resource skills
    //PRJ-842.JS.1.0 20Aug2021 | added code to add Job Segment
    //PRJ-924.JS.1.0 17Sep2021
    /// PRJ-949.GK.1.0 01Oct2021| Added Code and Changes in code.

    Caption = 'Generate Time Entries';
    ProcessingOnly = true;

    dataset
    {
        dataitem(NS_TimesheetHdrCustom; NS_TimesheetHdrCustom)
        {
            DataItemTableView = SORTING("NS_No.");

            trigger OnAfterGetRecord();
            var
                resourceRec: Record Resource;
            begin
                Clear(NoOfDays);
                Clear(NoOfPeriods);
                Clear(j);

                //if "NS_Work Period Start Date " = 0D then
                //    Error('Please select Work Period Start Date');

                if WorkDateFilter = 0D then
                    Error('Please select Work Date');
                if WorkDaysFilter = 0 then
                    Error('Please select Work Days');
                if WorkHourFilter = 0 then
                    Error('Please Select Work Hours');

                NoOfDays := "NS_Work Period End Date " - "NS_Work Period Start Date ";
                "NS_Work Period Start Date " := WorkDateFilter;
                "NS_Work Period End Date " := WorkDateFilter;
                IF WorkDaysFilter = 1 Then
                    "NS_Work Period End Date " := WorkDateFilter
                else
                    "NS_Work Period End Date " := CalcDate('+' + format(WorkDaysFilter - 1) + 'D', WorkDateFilter);

                //TotalPeriodDays := NoOfDays + 1;
                TotalPeriodDays := WorkDaysFilter;

                FOR i := 1 TO TotalPeriodDays DO begin
                    j := i - 1;

                    //if i = 1 then
                    //    InitializeDate := "NS_Work Period Start Date ";
                    if i = 1 then
                        InitializeDate := WorkDateFilter;

                    //if i > 1 then
                    //    InitializeDate := CalcDate('+' + Format(j) + 'D', "NS_Work Period Start Date ");
                    if i > 1 then
                        InitializeDate := CalcDate('+' + Format(j) + 'D', WorkDateFilter);
                    CrewLine.RESET();
                    CrewLine.SETRANGE(NS_Code, CrewNo);
                    CrewLine.SetRange(NS_Active, true);
                    if CrewLine.FINDSET() then
                        repeat
                            TimesSheetCustLine2.init;
                            TimesSheetCustLine2."NS_TimeSheetNo." := NS_TimesheetHdrCustom."NS_No.";

                            TimesSheetCustLine3.RESET();
                            TimesSheetCustLine3.SETRANGE("NS_TimeSheetNo.", NS_TimesheetHdrCustom."NS_No.");
                            if TimesSheetCustLine3.FindLast then
                                NextLineNo := TimesSheetCustLine3."NS_LineNo." + 10000
                            else
                                NextLineNo := 10000;

                            TimesSheetCustLine2."NS_LineNo." := NextLineNo;
                            TimesSheetCustLine2.NS_Description := NS_Description;
                            if jobNoFilter <> '' then
                                TimesSheetCustLine2."NS_Job No." := jobNoFilter;
                            if jobtaskNofilter <> '' then
                                TimesSheetCustLine2."NS_Job Task No." := jobtaskNofilter;
                            TimesSheetCustLine2."NS_Crew code" := CrewNo;
                            CrewLine2.RESET();
                            CrewLine2.SETRANGE(NS_Code, CrewNo);
                            CrewLine2.SetRange("NS_Lead Person", true);
                            IF CrewLine2.FindFirst() then
                                TimesSheetCustLine2."NS_Lead Person" := CrewLine2."NS_Resource No.";
                            TimesSheetCustLine2.VALIDATE("NS_Resource No.", CrewLine."NS_Resource No.");

                            if resourceRec.Get(TimesSheetCustLine2."NS_Resource No.") then
                                TimesSheetCustLine2."NS_Resource Name" := resourceRec.Name;

                            //TimesSheetCustLine2.VALIDATE("NS_Working Hours", "NS_Working Hours");
                            //TimesSheetCustLine2."NS_Working Date" := InitializeDate;
                            //PRJ-924.JS.1.0 17Sep2021-Start
                            //TimesSheetCustLine2.VALIDATE("NS_Working Hours", WorkHourFilter);
                            TimesSheetCustLine2.VALIDATE("NS_Resource Working Hours", WorkHourFilter);
                            //PRJ-924.JS.1.0 17Sep2021-end
                            IF i = 1 then
                                TimesSheetCustLine2."NS_Working Date" := WorkDateFilter
                            ELSE
                                TimesSheetCustLine2."NS_Working Date" :=
                                   CalcDate('+' + format(i - 1) + 'D', WorkDateFilter);

                            TimesSheetCustLine2."NS_Unique Line ID" :=
                                 NoSeriesMgt.GetNextNo(HRSetup."NS_Timesheet Unique Line Nos.", Today, true);

                            TimesSheetCustLine2.NS_TimeSheetCrewWorkDays := WorkDaysFilter;
                            TimesSheetCustLine2."NS_Work Type Code" := WorkTypeFilter;
                            //PRJ-841|842.JS.1.0 20Aug2021-Start
                            TimesSheetCustLine2."NS_Segment Code" := JobSegment;
                            JobResourcePrice.Reset();
                            JobResourcePrice.SetRange(Type, JobResourcePrice.Type::Resource);
                            JobResourcePrice.Setfilter("Job No.", '%1', jobNoFilter);
                            //JobResourcePrice.SetFilter("Job Task No.", '%1', jobtaskNofilter);  //PRJ-924.JS.1.0 17Sep2021 line commented
                            JobResourcePrice.SetFilter(code, '%1', TimesSheetCustLine2."NS_Resource No.");
                            if JobResourcePrice.FindFirst() then
                                TimesSheetCustLine2."NS_Skill Code" := JobResourcePrice."NS_Skill Class Code";
                            // ResourceSkils.Reset();
                            // ResourceSkils.SetRange("No.", resourceRec."No.");
                            // IF ResourceSkils.FindFirst() then
                            //     TimesSheetCustLine2."NS_Skill Code" := ResourceSkils."Skill Code";
                            //PRJ-841|842.JS.1.0 20Aug2021-End
                            TimesSheetCustLine2.INSERT(true);
                            InsertCount += 1;
                        until CrewLine.NEXT() = 0;

                    Commit();

                    NS_TimesheetHdrCustom."NS_Crew code" := CrewNo;
                    NS_TimesheetHdrCustom."NS_Job No." := jobNoFilter;
                    NS_TimesheetHdrCustom."NS_Job Task No." := jobtaskNofilter;
                    NS_TimesheetHdrCustom.NS_TimeSheetCrewWorkDays := WorkDaysFilter;
                    NS_TimesheetHdrCustom.Modify();
                end;
            end;

            trigger OnPostDataItem();
            begin
                MESSAGE(Text002, InsertCount);
            end;

            trigger OnPreDataItem();
            begin
                InsertCount := 0;
                if TSNOSentIn <> '' then
                    NS_TimesheetHdrCustom.setrange("NS_No.", TSNOSentIn);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field(jobNoFilter; jobNoFilter)
                {
                    Caption = 'Job No.';
                    TableRelation = Job."No.";
                    ApplicationArea = All;
                }
                /// PRJ-949.GK.1.0 01Oct2021 start
                field(CrewNo; CrewNo)
                {

                    Caption = 'Crew No.';
                    //TableRelation = NS_Crew;  //PRJ-949.GK.1.0 01Oct2021 comment
                    ApplicationArea = All;
                    trigger OnLookup(var tst: Text): Boolean
                    var
                        NS_JobCrewPage: Page "NS_ Job Crew List";
                        NS_JobCrew: Record "NS_Job Crews";
                    begin
                        NS_JobCrew.Reset();
                        NS_JobCrew.SetRange("NS_Job No.", jobNoFilter);
                        NS_JobCrew.SetRange(NS_Active, true);
                        if Page.RunModal(Page::"NS_ Job Crew List", NS_JobCrew) = Action::LookupOK then
                            CrewNo := NS_JobCrew."NS_Crew Code";

                    end;
                    /// PRJ-949.GK.1.0 01Oct2021 end
                }

                field(jobtaskNofilter; jobtaskNofilter)
                {
                    Caption = 'Job Task No.';
                    ApplicationArea = All;
                    Lookup = true;
                    LookupPageID = "Job task lines";

                    trigger OnLookup(VAR Text: Text): Boolean;
                    var
                        JobTAskLinesRec: Record "Job Task";
                    begin
                        JobTAskLinesRec.Reset();
                        JobTAskLinesRec.SetRange("Job No.", jobNoFilter);
                        JobTAskLinesRec.SetRange("Job Task Type", JobTAskLinesRec."Job Task Type"::Posting);
                        if PAGE.RUNMODAL(0, JobTAskLinesRec) = ACTION::LookupOK then begin
                            jobtaskNofilter := '';
                            if JobTAskLinesRec."Job Task No." > '' then
                                jobtaskNofilter := JobTAskLinesRec."Job Task No.";
                        end;
                    end;
                }
                field(WorkDateFilter; WorkDateFilter)
                {
                    Caption = 'Work Date';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the  work date for crew time';
                }

                //PRJ-924.JS.1.0 17Sep2021-Start
                field(WorkHourFilter; WorkHourFilter)
                {
                    Caption = 'Work Hour';
                    ApplicationArea = All;
                    MinValue = 0;
                    MaxValue = 8;
                    DecimalPlaces = 2 : 2;
                    ToolTip = 'Specifies the  work hours for crew time';
                }
                //PRJ-924.JS.1.0 17Sep2021-Start
                field(WorkDaysFilter; WorkDaysFilter)
                {
                    Caption = 'Work Days';
                    ApplicationArea = All;
                    MinValue = 1;
                    MaxValue = 7;
                    ToolTip = 'Specifies the  work days for crew time';
                }
                field(WorkTypeFilter; WorkTypeFilter)
                {
                    Caption = 'Work Type';
                    ApplicationArea = All;
                    TableRelation = "Work Type";
                    ToolTip = 'Specifies the  work days for crew time';
                }
                field(JobSegment; JobSegment)//PRJ-842.JS.1.0 20Aug2021
                {
                    Caption = 'Job Segment';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the  job segemnt for crew time';

                    trigger OnLookup(VAR Text: Text): Boolean;
                    var
                        NSJobSegment: Record "NS_Job Takeoff Segments";
                    begin
                        NSJobSegment.Reset();
                        NSJobSegment.SetFilter("NS_Job No.", '%1', jobNoFilter);
                        if PAGE.RUNMODAL(14021400, NSJobSegment) = ACTION::LookupOK then
                            JobSegment := NSJobSegment."NS_Segment Code";
                    end;
                }

            }
        }

        actions
        {
        }
    }

    labels
    {
    }



    trigger OnPreReport();
    begin
        /// PRJ-949.GK.1.0 01Oct2021 start
        if jobNoFilter = '' then
            Error(NS_JobNoError);
        /// PRJ-949.GK.1.0 01Oct2021 end
        HRSetup.Get();
        if CrewNo = '' then
            ERROR(Text001);
    end;

    var
        CrewNo: Code[10];
        Text001: Label 'A Crew No. must be specified for TimeSheet Line copying.';
        NS_JobNoError: Label 'Please select Job No.'; /// PRJ-949.GK.1.0 01Oct2021
        CrewLine: Record "NS_Crew Line";
        CrewLine2: Record "NS_Crew Line";
        Resource: Record Resource;
        JobRec: Record Job;
        ResourceSkils: Record "Resource Skill";  //PRJ-841.JS.1.0 16Aug2021

        TimesSheetCustLine1: Record NS_TimeSheetLineCustom;
        TimesSheetCustLine2: Record NS_TimeSheetLineCustom;
        TimesSheetCustLine3: Record NS_TimeSheetLineCustom;
        NoOfPeriods: Integer;
        NextLineNo: Integer;
        InsertCount: Integer;
        Text002: Label '%1 lines have been inserted into the end of Crew TimeSheet Line.';
        TSNO: Code[20];
        TSNOSentIn: Code[20];
        TempDate: Record Date temporary;
        i: Integer;
        j: Integer;
        jobNoFilter: Code[20];
        jobtaskNofilter: Code[20];
        NoOfDays: Integer;
        TotalPeriodDays: Integer;
        InitializeDate: Date;
        IntegerTable: Record Integer;
        TemporaryTSHPostingEntry: Record "Time Sheet Posting Entry" temporary;
        TemporaryTSHPostingEntry1: Record "Time Sheet Posting Entry" temporary;
        TSHdrCustomRec: Record NS_TimesheetHdrCustom;
        JobResourcePrice: Record "Job Resource Price";  //PRJ-841.JS.1.0 20Aug2021
        WorkDateFilter: Date;
        WorkDaysFilter: Integer;
        WorkHourFilter: Decimal;
        WorkTypeFilter: Code[10];
        HRSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        JobSegment: Code[20];    //PRJ-841.JS.1.0 20Aug2021


    procedure Set(TimesheetNo: Code[20]);
    begin
        TSNOSentIn := TSNO;
    end;

}

