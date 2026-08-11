table 14021316 "NS_TimesheetHdrCustom"
{

    //PRJ-772.AS.1.0 12July2021 New table
    //PRJ-924.JS.1.0 17Sep2021 | Correct code as per change
    //PRJ-659.RM.1.0 06-OCT-2021  | Updated Table's caption
    Caption = 'Time Sheet Hdr Custom'; //PRJ-659.RM.1.0 06-OCT-2021
    fields
    {
        field(1; "NS_No."; Code[20])
        {
            Caption = 'Timesheet No.';
            Description = 'Specifies Timesheet No.';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                HRSetup: record "Human Resources Setup";
            begin
                if "NS_No." <> xRec."NS_No." then begin
                    HRSetup.GET();
                    NoSeriesMgt.TestManual(HRSetup."NS_Custom Timesheet No. Series");
                    "NS_No. Series" := '';
                end;
            end;

        }
        field(2; "NS_Description"; Text[100])
        {
            Caption = 'Description';
            Description = '';
            DataClassification = CustomerContent;
        }
        field(3; "NS_Work Period Start Date "; Date)
        {
            Caption = 'Work Period Start Date';
            Description = '';
            DataClassification = CustomerContent;
        }
        field(4; "NS_Work Period End Date "; Date)
        {
            Caption = 'Work Period End Date';
            Description = '';
            DataClassification = CustomerContent;
        }
        field(5; "NS_Work Date"; Date)
        {
            Caption = 'Work Date';
            Description = '';
            DataClassification = CustomerContent;
        }
        field(6; "NS_Crew code"; code[20])
        {
            Caption = 'Crew code';
            Description = '';
            TableRelation = NS_Crew.NS_Code;
            DataClassification = CustomerContent;
        }
        field(7; "NS_Lead crew"; code[20])
        {
            Caption = 'Lead crew';
            Description = '';
            //Editable = false;
            DataClassification = CustomerContent;
        }
        field(8; "NS_Working Hours"; Integer)
        {
            Caption = 'Working Hours';
            Description = '';
            DataClassification = CustomerContent;
        }
        field(9; "NS_Job No."; code[20])
        {
            Caption = 'Job No.';
            Description = 'Specifies Job No.';
            TableRelation = Job."No.";
            DataClassification = CustomerContent;
        }
        field(10; "NS_Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            Description = 'Specifies Job Task No.';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = field("NS_Job No."));
            DataClassification = CustomerContent;
        }
        field(12; "NS_No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(13; "NS_TimeSheetCrewWorkDays"; integer)
        {
            Caption = 'Time Sheet Work Days';
            Description = 'Specifies Time Sheet Work Days';
            MaxValue = 7;
            MinValue = 1;
            DataClassification = CustomerContent;
        }
        field(14; "NS_Created By"; Code[50])
        {
            Caption = 'Created By';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(15; "NS_Creation Date"; date)
        {
            Caption = 'Creation Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(16; "NS_Last Modified By"; code[50])
        {
            Caption = 'Last Modified By';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(17; "NS_Last Modified Date"; date)
        {
            Caption = 'Last Modified Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(18; NS_Status; Option)
        {
            Caption = 'Status';

            Description = 'Specifies Status';
            Editable = false;
            DataClassification = CustomerContent;
            OptionCaption = 'Open,Submitted,Approved,Rejected,Posted';
            OptionMembers = Open,Submitted,Approved,Rejected,Posted;
        }

    }

    keys
    {
        key(Key1; "NS_No.")
        {
            Clustered = true;
        }
    }

    var
        TimesheetCusHdrTable: Record NS_TimesheetHdrCustom;
        HRSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    trigger OnInsert()
    begin
        HRSetup.Get();
        if "NS_No." = '' then begin
            HRSetup.GET();
            NoSeriesMgt.InitSeries(HRSetup."NS_Custom Timesheet No. Series", xRec."NS_No. Series", 0D, "NS_No.", "NS_No. Series");
        end;
        "NS_Created By" := UserId;
        "NS_Creation Date" := Today;
    end;

    trigger OnModify()
    begin
        "NS_Last Modified By" := UserId;
        "NS_Last Modified Date" := Today;

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure AssistEdit(NS_TimesheetHdrCustomOld: Record NS_TimesheetHdrCustom): Boolean;
    begin
        with TimesheetCusHdrTable do begin
            TimesheetCusHdrTable := Rec;
            HRSetup.GET();
            if NoSeriesMgt.SelectSeries(HRSetup."NS_Custom Timesheet No. Series", NS_TimesheetHdrCustomOld."NS_No. Series", "NS_No. Series") then begin
                NoSeriesMgt.SetSeries("NS_No.");
                Rec := TimesheetCusHdrTable;
                exit(true);
            end;
        end;
    end;


    procedure NS_MakeTimesheetEntry(TSHHDRCustomize: Code[20]);
    var
        NoSeriesRelationship: Record "No. Series Relationship";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        TimeSheetLine: Record "Time Sheet Line";
        TimeSheetCustLine: Record NS_TimeSheetLineCustom;
        TimeSheetCustLine1: Record NS_TimeSheetLineCustom;
        TimeSheetCustLine2: Record NS_TimeSheetLineCustom;
        TimeSheetCustLine3: Record NS_TimeSheetLineCustom;
        TimeSheetLineIN: Record "Time Sheet Line";
        TimeSheetLine1: Record "Time Sheet Line";
        TimeSheetLine2: Record "Time Sheet Line";
        TsheetHdrCustom: record NS_TimesheetHdrCustom;
        TSHHDR: record "Time Sheet Header";
        TSHHDROuter: Record "Time Sheet Header";
        TimeShtCustLine2: Record NS_TimeSheetLineCustom;   //PRJ-841.JS.1.0 16Aug2021
        TSSHCustomizedDocumentNo: Code[20];
        ResourcesSetup: Record "Resources Setup";
        CrewCodeLine: Record "NS_Crew Line";
        JoBNoStore: Code[20];
        JoBTaskNoStore: Code[20];
        CreCodeStore: Code[20];
        resourceStore: Code[20];
        PostingDateStore: Code[20];
        NextLineNo: Integer;
        TSDetail: Record "Time Sheet Detail";
        TSDetail1: Record "Time Sheet Detail";
        ResourecRec: Record Resource;
        WorkDescription: Text;   //PRJ-841.JS.1.0 16Aug2021

    begin
        Clear(TSSHCustomizedDocumentNo);
        Clear(JoBNoStore);
        Clear(JoBTaskNoStore);
        Clear(CreCodeStore);
        Clear(resourceStore);
        Clear(PostingDateStore);

        if TsheetHdrCustom.Get(TSHHDRCustomize) then begin
            IF TsheetHdrCustom.NS_Status = TsheetHdrCustom.NS_Status::Open Then begin
                ResourcesSetup.get();

                // TSHHDR.Reset();
                // TSHHDR.SetRange("NS_Ref Customize TimesheetNo.", TSHHDRCustomize);
                // if TSHHDR.Findfirst then
                //     Error('Base Time Sheet Entry %1 already exists for Custom Timesheet %1', TSHHDR."No.", TSHHDRCustomize);

                TSHHDROuter.Init();
                TSHHDROuter."No." := NoSeriesMgt.GetNextNo(ResourcesSetup."Time Sheet Nos.", Today, true);
                //TSHHDROuter."No." := 'TSC0010';
                TSHHDROuter.validate("Job No. Filter", TsheetHdrCustom."NS_Job No.");
                TSHHDROuter.validate("Job Task No. Filter", TsheetHdrCustom."NS_Job Task No.");
                TSHHDROuter."Starting Date" := TsheetHdrCustom."NS_Work Period Start Date ";
                TSHHDROuter."Ending Date" := TsheetHdrCustom."NS_Work Period End Date ";
                TSHHDROuter.NS_TimeSheetCrewWorkDays := TsheetHdrCustom.NS_TimeSheetCrewWorkDays;
                TSHHDROuter."NS_Crew Time Sheet Ref. No." := TsheetHdrCustom."NS_No.";
                TSHHDROuter.NS_CrewTimeSheetLine := true;

                CrewCodeLine.RESET();
                CrewCodeLine.SETRANGE(NS_Code, TsheetHdrCustom."NS_Crew code");
                CrewCodeLine.SetRange("NS_Lead Person", true);
                if CrewCodeLine.FindFirst() then begin
                    TSHHDROuter."Resource No." := CrewCodeLine."NS_Resource No.";
                    TSHHDROuter."NS_Crew code" := CrewCodeLine.NS_Code;  //PRJ-472.JS.1.0 21JULY2021
                end;
                if ResourecRec.Get(TSHHDROuter."Resource No.") then
                    TSHHDROuter."NS_Resource Name" := ResourecRec.Name;
                TSHHDROuter."Approver User ID" := ResourecRec."Time Sheet Approver User ID";

                TSHHDROuter."NS_Ref Customize TimesheetNo." := TsheetHdrCustom."NS_No.";

                TSHHDROuter.Insert();

                TimeSheetCustLine.Reset();
                TimeSheetCustLine.SetRange("NS_TimeSheetNo.", TsheetHdrCustom."NS_No.");
                if TimeSheetCustLine.FindSet() then
                    repeat
                        TimeSheetLine1.Reset();
                        TimeSheetLine1.SetRange("Time Sheet No.", TSHHDROuter."No.");
                        TimeSheetLine1.SetRange("Job No.", TimeSheetCustLine."NS_Job No.");
                        TimeSheetLine1.SetRange("Job Task No.", TimeSheetCustLine."NS_Job Task No.");
                        TimeSheetLine1.SetRange("NS_Crew code", TimeSheetCustLine."NS_Crew code");
                        TimeSheetLine1.SetRange("NS_Resource No.", TimeSheetCustLine."NS_Resource No.");
                        TimeSheetLine1.SetFilter("Line No.", '<>%1', 0);
                        if NOT TimeSheetLine1.FindFirst() then begin
                            //Lines insert - start
                            //PRJ-841.JS.1.0 16Aug2021 Get work description-Start
                            WorkDescription := '';
                            TimeShtCustLine2.Reset();
                            TimeShtCustLine2.SetRange("NS_TimeSheetNo.", TimeSheetCustLine."NS_TimeSheetNo.");
                            TimeShtCustLine2.SetRange("NS_Job No.", TimeSheetCustLine."NS_Job No.");
                            TimeShtCustLine2.SetRange("NS_Job Task No.", TimeSheetCustLine."NS_Job Task No.");
                            TimeShtCustLine2.SetRange("NS_Crew code", TimeSheetCustLine."NS_Crew code");
                            TimeShtCustLine2.SetRange("NS_Resource No.", TimeSheetCustLine."NS_Resource No.");
                            TimeShtCustLine2.Setfilter("NS_LineNo.", '<>%1', 0);
                            IF TimeShtCustLine2.FindFirst() then
                                WorkDescription := TimeShtCustLine2.NS_Description;
                            //PRJ-841.JS.1.0 16Aug2021 Get work description-end
                            TimeSheetLine.Init();
                            TimeSheetLine."Time Sheet No." := TSHHDROuter."No.";

                            TimeSheetLineIN.RESET();
                            TimeSheetLineIN.SETRANGE("Time Sheet No.", TSHHDROuter."No.");
                            if TimeSheetLineIN.FindLast then
                                NextLineNo := TimeSheetLineIN."Line No." + 10000
                            else
                                NextLineNo := 10000;

                            TimeSheetLine."Line No." := NextLineNo;
                            TimeSheetLine."Time Sheet Starting Date" := TSHHDROuter."Starting Date";
                            // TimeSheetLine.Validate(Type, TimeSheetLine.Type::Job);
                            // TimeSheetLine.Validate("Job No.", TimeSheetCustLine."NS_Job No.");
                            // TimeSheetLine.Validate("Job Task No.", TimeSheetCustLine."NS_Job Task No.");
                            TimeSheetLine.Type := TimeSheetLine.Type::Job;
                            TimeSheetLine."Job No." := TimeSheetCustLine."NS_Job No.";
                            TimeSheetLine."Job Task No." := TimeSheetCustLine."NS_Job Task No.";
                            TimeSheetLine."NS_Crew code" := TimeSheetCustLine."NS_Crew code";
                            TimeSheetLine."NS_Resource No." := TimeSheetCustLine."NS_Resource No.";
                            TimeSheetLine."NS_Resource Name" := TimeSheetCustLine."NS_Resource Name";
                            TimeSheetLine.Status := TimeSheetLine.Status::Open;
                            TimeSheetLine."NS_Ref Customize TimesheetNo." := TSHHDROuter."NS_Ref Customize TimesheetNo.";
                            TimeSheetLine.NS_CrewTimeSheetLine := true;
                            TimeSheetLine."NS_Crew Time Unique Line ID" := TimeSheetCustLine."NS_Unique Line ID";
                            TimeSheetLine.NS_TimeSheetCrewWorkDays := TimeSheetCustLine.NS_TimeSheetCrewWorkDays;
                            TimeSheetLine."NS_Work Type Code" := TimeSheetCustLine."NS_Work Type Code";
                            TimeSheetLine."NS_Crew Time Sheet Ref. No." := TimeSheetCustLine."NS_TimeSheetNo.";
                            TimeSheetLine."NS_Crew Time Sheet Date" := TimeSheetCustLine."NS_Working Date";
                            //PRJ-841.JS.1.0 PRJ-841.JS.1.0 16Aug2021-Start                            
                            TimeSheetLine."NS_Skill Code" := TimeSheetCustLine."NS_Skill Code";
                            TimeSheetLine."NS_Segment Code" := TimeSheetCustLine."NS_Segment Code";
                            TimeSheetLine.Description := CopyStr(WorkDescription, 1, 99);
                            //PRJ-841.JS.1.0 PRJ-841.JS.1.0 16Aug2021-end                                                      
                            if not TimeSheetLine.Insert() then
                                TimeSheetLine.Modify();
                        end;
                    until TimeSheetCustLine.Next() = 0;

                Commit();

                TimeSheetCustLine3.Reset();
                TimeSheetCustLine3.SetRange("NS_TimeSheetNo.", TsheetHdrCustom."NS_No.");
                if TimeSheetCustLine3.FindSet() then
                    repeat

                        TimeSheetLine2.Reset();
                        TimeSheetLine2.SetRange("Time Sheet No.", TSHHDROuter."No.");
                        TimeSheetLine2.SetRange("Job No.", TimeSheetCustLine3."NS_Job No.");
                        TimeSheetLine2.SetRange("Job Task No.", TimeSheetCustLine3."NS_Job Task No.");
                        TimeSheetLine2.SetRange("NS_Crew code", TimeSheetCustLine3."NS_Crew code");
                        TimeSheetLine2.SetRange("NS_Resource No.", TimeSheetCustLine3."NS_Resource No.");
                        if TimeSheetLine2.FindSet() then
                            repeat
                                TSDetail.Reset();
                                TSDetail.SetRange("Time Sheet No.", TimeSheetLine2."Time Sheet No.");
                                TSDetail.SetRange("Time Sheet Line No.", TimeSheetLine2."Line No.");
                                TSDetail.SetRange("Job No.", TimeSheetLine2."Job No.");
                                TSDetail.SetRange("Job Task No.", TimeSheetLine2."Job Task No.");
                                TSDetail.SetRange("Resource No.", TimeSheetLine2."NS_Resource No.");
                                TSDetail.SetRange(Date, TimeSheetCustLine3."NS_Working Date");
                                // TSDetail.SetRange(NS_Description, TimeSheetCustLine3.NS_Description);
                                if NOT TSDetail.FindFirst() then begin
                                    //Message('...%1..%2', TimeSheetCustLine3."NS_Resource No.",
                                    //    TimeSheetLine2."NS_Resource No.");
                                    TSDetail1.Init();
                                    TSDetail1."Time Sheet No." := TimeSheetLine2."Time Sheet No.";
                                    TSDetail1."Time Sheet Line No." := TimeSheetLine2."Line No.";
                                    TSDetail1.date := TimeSheetCustLine3."NS_Working Date";
                                    TSDetail1.Type := TimeSheetLine2.Type;
                                    TSDetail1."Job No." := TimeSheetLine2."Job No.";
                                    TSDetail1."Job Id" := TimeSheetLine2."Job Id";
                                    TSDetail1."Job Task No." := TimeSheetLine2."Job Task No.";
                                    TSDetail1."Cause of Absence Code" := TimeSheetLine2."Cause of Absence Code";
                                    TSDetail1."Service Order No." := TimeSheetLine2."Service Order No.";
                                    TSDetail1."Service Order Line No." := TimeSheetLine2."Service Order Line No.";
                                    TSDetail1."Assembly Order No." := TimeSheetLine2."Assembly Order No.";
                                    TSDetail1."Assembly Order Line No." := TimeSheetLine2."Assembly Order Line No.";
                                    //TSDetail1.validate(Quantity, TimeSheetCustLine3."NS_Working Hours");    //PRJ-924.JS.1.0 17Sep2021-Line Commented
                                    TSDetail1.validate(Quantity, TimeSheetCustLine3."NS_Resource Working Hours");    //PRJ-924.JS.1.0 17Sep2021 Line Added
                                    //TSDetail1.validate(Quantity, TimeSheetCustLine3."NS_Working Hours");  //PRJ-924.JS.1.0 17Sep2021 Line Commented
                                    TSDetail1."Resource No." := TimeSheetCustLine3."NS_Resource No.";
                                    TSDetail1.Status := TimeSheetLine2.Status;
                                    TSDetail1.NS_Description := TimeSheetCustLine3.NS_Description;
                                    TSDetail1."NS_Crew Code" := TimeSheetCustLine3."NS_Crew code";
                                    TSDetail1."NS_Crew Time Unique Line ID" := TimeSheetCustLine3."NS_Unique Line ID";
                                    TSDetail1.NS_TimeSheetCrewWorkDays := TimeSheetCustLine3.NS_TimeSheetCrewWorkDays;
                                    TSDetail1."NS_Work Type Code" := TimeSheetCustLine3."NS_Work Type Code";
                                    TSDetail1."NS_Crew Time Sheet Ref. No." := TimeSheetCustLine3."NS_TimeSheetNo.";
                                    TSDetail1."NS_Crew Time Sheet Date" := TimeSheetCustLine3."NS_Working Date";
                                    //PRJ-841.JS.1.0 PRJ-841.JS.1.0 16Aug2021-Start                            
                                    TSDetail1."NS_Skill Code" := TimeSheetCustLine3."NS_Skill Code";
                                    TSDetail1."NS_Segment Code" := TimeSheetCustLine3."NS_Segment Code";
                                    TSDetail1."NS_Work Description" := TimeSheetCustLine3.NS_Description;
                                    //PRJ-841.JS.1.0 PRJ-841.JS.1.0 16Aug2021-end                                                                                  
                                    TSDetail1.NS_CrewTimeSheetLine := true;
                                    if not TSDetail1.Insert() then
                                        TSDetail1.Modify();
                                end;
                            until TimeSheetLine2.Next() = 0;
                    until TimeSheetCustLine3.Next() = 0;
                MESSAGE('Crew Time Sheet %1 has been submitted for approval ref. %2', TSHHDRCustomize, TimeSheetLine2."Time Sheet No.");

                NS_SubmitAllLinesToManagerTimeSheetpg(TimeSheetLine2."Time Sheet No.");
                TsheetHdrCustom.NS_Status := TsheetHdrCustom.NS_Status::Submitted;
                TsheetHdrCustom.Modify();
            end else
                Message('Time sheet no. %1 get already submitted', TsheetHdrCustom."NS_No.");
        end;
    end;

    //PRJ-772.2.0 -START
    local procedure NS_SubmitAllLinesToManagerTimeSheetpg(TimeSheetCode: Code[20])
    var
        TimeSheetLine_L: record "Time Sheet Line";
        CuTimesheetMgmt: Codeunit "Time Sheet Approval Management";
        TimeSheetCustLine_L: Record NS_TimeSheetLineCustom;
        MgrTimeSheet: Page "Manager Time Sheet";
        TimeSheetLineL1: record "Time Sheet Line";
    begin
        TimeSheetLine_L.Reset();
        TimeSheetLine_L.SetRange("Time Sheet No.", TimeSheetCode);
        TimeSheetLine_L.FilterGroup(2);
        TimeSheetLine_L.SetFilter(Type, '<>%1', TimeSheetLine_L.Type::" ");
        TimeSheetLine_L.FilterGroup(0);
        TimeSheetLine_L.SetFilter(Status, '%1|%2', TimeSheetLine_L.Status::Open, TimeSheetLine_L.Status::Rejected);
        IF TimeSheetLine_L.FINDSET THEN
            REPEAT
                CuTimesheetMgmt.Submit(TimeSheetLine_L);
            until TimeSheetLine_L.Next() = 0;

        TimeSheetCustLine_L.Reset();
        TimeSheetCustLine_L.SetRange("NS_TimeSheetNo.", TimeSheetLine_L."NS_Ref Customize TimesheetNo.");
        if TimeSheetCustLine_L.FindSet() then
            repeat
                TimeSheetCustLine_L.NS_Status := TimeSheetCustLine_L.NS_Status::Submitted;
                TimeSheetCustLine_L.Modify();
            until TimeSheetCustLine_L.Next() = 0;
    end;
    //PRJ-772.2.0 - END
}