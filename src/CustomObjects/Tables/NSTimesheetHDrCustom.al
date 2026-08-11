table 14021316 "NS_TimesheetHdrCustom"
{

    //PRJ-772.AS.1.0 12July2021 New table
    //PRJ-924.JS.1.0 17Sep2021 | Correct code as per change
    //PRJ-659.RM.1.0 06-OCT-2021  | Updated Table's caption
    //PRJ-1132.RM.1.0 13Jan2022 | Removed with statement
    //PRJ-1144.JS.1.0 31JAN2022 | Add code and add fields   
    //PRJCTPR-2.RM.1.0 13Dec2022 | Adeed some code
    //PE-156.HS.1.0 8September2023| Changed caption
    //Caption = 'Time Sheet Hdr Custom'; //PRJ-659.RM.1.0 06-OCT-2021 //PE-156.HS.1.0 8September2023 Commneted
    Caption = 'Time Sheet Hdr'; //PE-156.HS.1.0 8September2023
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
        //PRJ-1144.JS.1.0 06Feb2022 - Start
        field(20; "NS_Total Line"; Integer)
        {
            Caption = 'Total Lines';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count(NS_TimeSheetLineCustom where("NS_TimeSheetNo." = field("NS_No.")));
        }

        field(21; "NS_Total Submitted Line"; Integer)
        {
            Caption = 'Total Submitted Line';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count(NS_TimeSheetLineCustom where("NS_TimeSheetNo." = field("NS_No."), "NS_Ready To Submit" = filter(true),
            NS_Status = filter(Submitted | Approved | Rejected | Posted)));

        }
        //PRJ-1144.JS.1.0 06Feb2022 - end
        //PRJ-1452.GK.1.0 13June2022 start
        field(23; "NS_Time Sheet Owner User ID"; Code[50])
        {
            Caption = 'Time Sheet Owner User ID';
            DataClassification = CustomerContent;
            TableRelation = "User Setup";
        }
        //PRJ-1452.GK.1.0 13June2022 end
        //PE-152.JS.1.0 23-Aug-2023-Start
        field(25; "NS_Blank Date on Lines"; integer)
        {
            Caption = 'Blank Date on Lines';
            Editable = false;
            FieldClass = flowfield;
            CalcFormula = count(NS_TimeSheetLineCustom where("NS_TimeSheetNo." = field("NS_No."),
            "NS_Working Date" = filter(0D)));
        }
        //PE-152.JS.1.0 23-Aug-2023-End

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
        //PRJ-1132.RM.1.0 start
        //with TimesheetCusHdrTable do begin
        TimesheetCusHdrTable := Rec;
        HRSetup.GET();
        if NoSeriesMgt.SelectSeries(HRSetup."NS_Custom Timesheet No. Series", NS_TimesheetHdrCustomOld."NS_No. Series", TimesheetCusHdrTable."NS_No. Series") then begin
            NoSeriesMgt.SetSeries(TimesheetCusHdrTable."NS_No.");
            Rec := TimesheetCusHdrTable;
            exit(true);
        end;
        //end;
        //PRJ-1132.RM.1.0 end
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
        TimeSheetLine3: Record "Time Sheet Line";
        TsheetHdrCustom: record NS_TimesheetHdrCustom;
        TSHHDR: record "Time Sheet Header";
        TSHHDROuter: Record "Time Sheet Header";
        TSHHDROuter2: Record "Time Sheet Header";   //PRJ-1144.JS.1.0 06Feb2022
        TSHHDROuter3: Record "Time Sheet Header";   //PRJ-1144.JS.3.0 09FEB2022
        TimeSheetHeadNo: Code[20];     //PRJ-1144.JS.3.0 09FEB2022
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
        //PRJ-1144.JS.3.0 09FEB2022 - Start
        Clear(TimeSheetHeadNo);
        TSHHDROuter3.Reset();
        TSHHDROuter3.SetRange("NS_Crew Time Sheet Ref. No.", TSHHDRCustomize);
        if TSHHDROuter3.FindFirst() then
            TimeSheetHeadNo := TSHHDROuter3."No.";
        //PRJ-1144.JS.3.0 09FEB2022 - End    

        if TsheetHdrCustom.Get(TSHHDRCustomize) then begin
            //PRJ-1144.JS.1.0 06FEB2022-Start
            TsheetHdrCustom.CalcFields("NS_Total Line", "NS_Total Submitted Line");
            if TsheetHdrCustom."NS_Total Line" <> TsheetHdrCustom."NS_Total Submitted Line" then begin
                //IF TsheetHdrCustom.NS_Status = TsheetHdrCustom.NS_Status::Open Then begin
                //PRJ-1144.JS.1.0 06FEB2022-end
                ResourcesSetup.get();

                // TSHHDR.Reset();
                // TSHHDR.SetRange("NS_Ref Customize TimesheetNo.", TSHHDRCustomize);
                // if TSHHDR.Findfirst then
                //     Error('Base Time Sheet Entry %1 already exists for Custom Timesheet %1', TSHHDR."No.", TSHHDRCustomize);

                TSHHDROuter2.Reset();
                TSHHDROuter2.SetRange("NS_Crew Time Sheet Ref. No.", TsheetHdrCustom."NS_No.");
                if not TSHHDROuter2.FindFirst() then begin
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
                    TSHHDROuter."Owner User ID" := TsheetHdrCustom."NS_Time Sheet Owner User ID"; //PRJ-1452.GK.1.0 13June2022
                    TimeSheetHeadNo := TSHHDROuter."No.";  //PRJ-1144.JS.3.0 09FEB2022

                    CrewCodeLine.RESET();
                    CrewCodeLine.SETRANGE(NS_Code, TsheetHdrCustom."NS_Crew code");
                    CrewCodeLine.SetRange("NS_Lead Person", true);
                    if CrewCodeLine.FindFirst() then begin
                        TSHHDROuter."Resource No." := CrewCodeLine."NS_Resource No.";
                        TSHHDROuter."NS_Crew code" := CrewCodeLine.NS_Code;  //PRJ-472.JS.1.0 21JULY2021
                    end;
                    if ResourecRec.Get(TSHHDROuter."Resource No.") then
                        // TSHHDROuter."NS_Resource Name" := ResourecRec.Name;//PRJ-1074.AS.1.0 28DEC2021 Commented code for old field "NS_Resource Name"
                        TSHHDROuter."NS_Resource Name New" := ResourecRec.Name;//PRJ-1074.AS.1.0 28DEC2021 Add New code for new field "NS_Resource Name New"
                    TSHHDROuter."Approver User ID" := ResourecRec."Time Sheet Approver User ID";

                    TSHHDROuter."NS_Ref Customize TimesheetNo." := TsheetHdrCustom."NS_No.";

                    TSHHDROuter.Insert();

                    TimeSheetCustLine.Reset();
                    TimeSheetCustLine.SetRange("NS_TimeSheetNo.", TsheetHdrCustom."NS_No.");
                    TimeSheetCustLine.SetRange("NS_Ready To Submit", true);  //PRJ-1144.JS.1.0 31JAN2022
                    TimeSheetCustLine.SetRange(NS_Status, TimeSheetCustLine.NS_Status::Open);  //PRJ-1144.JS.1.0 31JAN2022
                    if TimeSheetCustLine.FindSet() then
                        repeat
                            TimeSheetLine1.Reset();
                            TimeSheetLine1.SetRange("Time Sheet No.", TSHHDROuter."No.");
                            TimeSheetLine1.SetRange("Job No.", TimeSheetCustLine."NS_Job No.");
                            TimeSheetLine1.SetRange("Job Task No.", TimeSheetCustLine."NS_Job Task No.");
                            TimeSheetLine1.SetRange("NS_Crew code", TimeSheetCustLine."NS_Crew code");
                            TimeSheetLine1.SetRange("NS_Resource No.", TimeSheetCustLine."NS_Resource No.");
                            TimeSheetLine1.SetRange("NS_Crew Time Sheet Line No.", TimeSheetCustLine."NS_LineNo."); //PRJ-1144.JS.1.0 06FEB2022 
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
                                //PRJ-1144.JS.1.0 06FEB2022 - start
                                TimeShtCustLine2.SetRange(NS_Status, TimeShtCustLine2.NS_Status::Open);
                                TimeShtCustLine2.SetRange("NS_Ready To Submit", true);
                                //PRJ-1144.JS.1.0 06FEB2022 - end
                                IF TimeShtCustLine2.FindFirst() then
                                    WorkDescription := TimeShtCustLine2.NS_Description;
                                //PRJ-841.JS.1.0 16Aug2021 Get work description-end
                                TimeSheetLine.Init();
                                TimeSheetLine."Time Sheet No." := TSHHDROuter."No.";

                                TimeSheetLineIN.RESET();
                                TimeSheetLineIN.SETRANGE("Time Sheet No.", TSHHDROuter."No.");
                                if TimeSheetLineIN.FindLast() then                  //PRJ-1144.JS.1.0 06FEB2022
                                    NextLineNo := TimeSheetLineIN."Line No." + 10000
                                else
                                    NextLineNo := 10000;

                                TimeSheetLine."Line No." := NextLineNo;
                                //TimeSheetLine."Time Sheet Starting Date" := TSHHDROuter."Starting Date";  //PRJ-1144.JS.2.0 JS 08FEB2022
                                TimeSheetLine."Time Sheet Starting Date" := TimeSheetCustLine."NS_Working Date";  //PRJ-1144.JS.2.0 JS 08FEB2022
                                                                                                                  // TimeSheetLine.Validate(Type, TimeSheetLine.Type::Job);
                                                                                                                  // TimeSheetLine.Validate("Job No.", TimeSheetCustLine."NS_Job No.");
                                                                                                                  // TimeSheetLine.Validate("Job Task No.", TimeSheetCustLine."NS_Job Task No.");
                                TimeSheetLine.Type := TimeSheetLine.Type::Job;
                                TimeSheetLine."Job No." := TimeSheetCustLine."NS_Job No.";
                                TimeSheetLine."Job Task No." := TimeSheetCustLine."NS_Job Task No.";
                                TimeSheetLine."NS_Crew code" := TimeSheetCustLine."NS_Crew code";
                                TimeSheetLine."NS_Resource No." := TimeSheetCustLine."NS_Resource No.";
                                TimeSheetLine."NS_Crew Time Sheet Line No." := TimeSheetCustLine."NS_LineNo.";   //PRJ-1144.JS.1.0 06FEB2022
                                                                                                                 // TimeSheetLine."NS_Resource Name" := TimeSheetCustLine."NS_Resource Name";//PRJ-1074.AS.1.0 28DEC2021 Commented code for old field "NS_Resource Name"
                                TimeSheetLine."NS_Resource Name New" := TimeSheetCustLine."NS_Resource Name New";//PRJ-1074.AS.1.0 28DEC2021 Add New code for new field "NS_Resource Name New"
                                TimeSheetLine.Status := TimeSheetLine.Status::Submitted;
                                TimeSheetLine."NS_Ref Customize TimesheetNo." := TSHHDROuter."NS_Ref Customize TimesheetNo.";
                                TimeSheetLine.NS_CrewTimeSheetLine := true;
                                TimeSheetLine."NS_Crew Time Unique Line ID" := TimeSheetCustLine."NS_Unique Line ID";
                                TimeSheetLine."Total Quantity" := TimeSheetCustLine."NS_Resource Working Hours";
                                TimeSheetLine.NS_TimeSheetCrewWorkDays := TimeSheetCustLine.NS_TimeSheetCrewWorkDays;
                                TimeSheetLine."NS_Work Type Code" := TimeSheetCustLine."NS_Work Type Code";
                                TimeSheetLine."NS_Crew Time Sheet Ref. No." := TimeSheetCustLine."NS_TimeSheetNo.";
                                TimeSheetLine."NS_Crew Time Sheet Date" := TimeSheetCustLine."NS_Working Date";
                                TimeSheetLine."Approver ID" := UserId();  //PRJ-1144.JS.1.0 06FEB2022
                                                                          //PRJ-841.JS.1.0 PRJ-841.JS.1.0 16Aug2021-Start                            
                                TimeSheetLine."NS_Time Sheet Owner User ID" := TimeSheetCustLine."NS_Time Sheet Owner User ID"; //PRJ-1452.GK.1.0 13June2022
                                //PE-68 Dk.1.0 10April2023 Start
                                //TimeSheetLine."NS_Skill Code" := TimeSheetCustLine."NS_Skill Code";
                                TimeSheetLine."NS_Skill Code New" := TimeSheetCustLine."NS_Skill Code New";
                                //PE-68 Dk.1.0 10April2023 End
                                TimeSheetLine."NS_Segment Code" := TimeSheetCustLine."NS_Segment Code";
                                TimeSheetLine."NS_Union Code" := TimeSheetCustLine."NS_Union Code"; //PRJCTPR-2.RM.1.0 13Dec2022
                                TimeSheetLine.Description := CopyStr(WorkDescription, 1, 99);
                                //PRJ-841.JS.1.0 PRJ-841.JS.1.0 16Aug2021-end                                                      
                                if not TimeSheetLine.Insert() then
                                    TimeSheetLine.Modify();

                                //PRJ-1144.JS.1.0 Start enter time sheet Detail line-Start                                
                                TSDetail.Reset();
                                TSDetail.SetRange("Time Sheet No.", TimeSheetLine."Time Sheet No.");
                                TSDetail.SetRange("Time Sheet Line No.", TimeSheetLine."Line No.");
                                TSDetail.SetRange("Job No.", TimeSheetLine2."Job No.");
                                TSDetail.SetRange("Job Task No.", TimeSheetLine2."Job Task No.");
                                TSDetail.SetRange("Resource No.", TimeSheetLine2."NS_Resource No.");
                                TSDetail.SetRange(Date, TimeSheetCustLine."NS_Working Date");
                                if NOT TSDetail.FindFirst() then begin
                                    //Message('...%1..%2', TimeSheetCustLine3."NS_Resource No.",
                                    //    TimeSheetLine2."NS_Resource No.");
                                    TSDetail1.Init();
                                    TSDetail1."Time Sheet No." := TimeSheetLine."Time Sheet No.";
                                    TSDetail1."Time Sheet Line No." := TimeSheetLine."Line No.";
                                    TSDetail1.date := TimeSheetCustLine."NS_Working Date";
                                    TSDetail1.Type := TimeSheetLine.Type;
                                    TSDetail1."Job No." := TimeSheetLine."Job No.";
                                    TSDetail1."Job Id" := TimeSheetLine."Job Id";
                                    TSDetail1."Job Task No." := TimeSheetLine."Job Task No.";
                                    TSDetail1."Cause of Absence Code" := TimeSheetLine."Cause of Absence Code";
                                    TSDetail1."Service Order No." := TimeSheetLine."Service Order No.";
                                    TSDetail1."Service Order Line No." := TimeSheetLine."Service Order Line No.";
                                    TSDetail1."Assembly Order No." := TimeSheetLine."Assembly Order No.";
                                    TSDetail1."Assembly Order Line No." := TimeSheetLine."Assembly Order Line No.";
                                    TSDetail."NS_Crew Time Sheet Line No." := TimeSheetLine."NS_Crew Time Sheet Line No.";  //PRJ-1144.JS.1.0 06FEB2022
                                                                                                                            //TSDetail1.validate(Quantity, TimeSheetCustLine3."NS_Working Hours");    //PRJ-924.JS.1.0 17Sep2021-Line Commented
                                    TSDetail1.validate(Quantity, TimeSheetCustLine."NS_Resource Working Hours");    //PRJ-924.JS.1.0 17Sep2021 Line Added
                                                                                                                    //TSDetail1.validate(Quantity, TimeSheetCustLine3."NS_Working Hours");  //PRJ-924.JS.1.0 17Sep2021 Line Commented
                                    TSDetail1."Resource No." := TimeSheetCustLine."NS_Resource No.";
                                    TSDetail1.Status := TimeSheetLine2.Status;
                                    TSDetail1.NS_Description := TimeSheetCustLine.NS_Description;
                                    TSDetail1."NS_Crew Code" := TimeSheetCustLine."NS_Crew code";
                                    TSDetail1."NS_Crew Time Unique Line ID" := TimeSheetCustLine."NS_Unique Line ID";
                                    TSDetail1.NS_TimeSheetCrewWorkDays := TimeSheetCustLine.NS_TimeSheetCrewWorkDays;
                                    TSDetail1."NS_Work Type Code" := TimeSheetCustLine."NS_Work Type Code";
                                    TSDetail1."NS_Crew Time Sheet Ref. No." := TimeSheetCustLine."NS_TimeSheetNo.";
                                    TSDetail1."NS_Crew Time Sheet Date" := TimeSheetCustLine."NS_Working Date";
                                    //PRJ-841.JS.1.0 PRJ-841.JS.1.0 16Aug2021-Start 
                                    //PE-68 Dk.1.0 10April2023 Start                           
                                    //TSDetail1."NS_Skill Code" := TimeSheetCustLine."NS_Skill Code";
                                    TSDetail1."NS_Skill Code New" := TimeSheetCustLine."NS_Skill Code New";
                                    //PE-68 Dk.1.0 10April2023 End
                                    TSDetail1."NS_Segment Code" := TimeSheetCustLine."NS_Segment Code";
                                    TSDetail1."NS_Work Description" := TimeSheetCustLine.NS_Description;
                                    //PRJ-841.JS.1.0 PRJ-841.JS.1.0 16Aug2021-end                                                                                  
                                    TSDetail1.NS_CrewTimeSheetLine := true;
                                    if not TSDetail1.Insert() then
                                        TSDetail1.Modify();
                                    //PRJ-1144.JS.1.0 06FEB2022 - start
                                    //PRJ-1144.JS.1.0 end enter time sheet Detail line-Start
                                end;
                            end else begin
                                TimeSheetLine3.Reset();
                                TimeSheetLine3.SetRange("Time Sheet No.", TSHHDROuter."No.");
                                TimeSheetLine3.SetRange("Job No.", TimeSheetCustLine."NS_Job No.");
                                TimeSheetLine3.SetRange("Job Task No.", TimeSheetCustLine."NS_Job Task No.");
                                TimeSheetLine3.SetRange("NS_Crew code", TimeSheetCustLine."NS_Crew code");
                                TimeSheetLine3.SetRange("NS_Resource No.", TimeSheetCustLine."NS_Resource No.");
                                TimeSheetLine3.SetRange("NS_Crew Time Sheet Line No.", TimeSheetCustLine."NS_LineNo.");
                                If TimeSheetLine3.FindFirst() then begin
                                    //PRJ-1144.JS.1.0 06FEB2022-Start Update the existing lines in manager timesheet line
                                    //TimeSheetLine3."Time Sheet Starting Date" := TSHHDROuter2."Starting Date";   //PRJ-1144.JS.2.0 JS 08FEB2022
                                    TimeSheetLine3."Time Sheet Starting Date" := TimeSheetCustLine."NS_Working Date";  //PRJ-1144.JS.2.0 JS 08FEB2022
                                    TimeSheetLine3.Type := TimeSheetLine3.Type::Job;
                                    TimeSheetLine3."Job No." := TimeSheetCustLine."NS_Job No.";
                                    TimeSheetLine3."Job Task No." := TimeSheetCustLine."NS_Job Task No.";
                                    TimeSheetLine3."NS_Crew code" := TimeSheetCustLine."NS_Crew code";
                                    TimeSheetLine3."NS_Resource No." := TimeSheetCustLine."NS_Resource No.";
                                    TimeSheetLine3."NS_Resource Name New" := TimeSheetCustLine."NS_Resource Name New";
                                    TimeSheetLine3."Total Quantity" := TimeSheetCustLine."NS_Resource Working Hours";
                                    TimeSheetLine3.Status := TimeSheetLine3.Status::Submitted;
                                    TimeSheetLine3.NS_Correction := true;
                                    TimeSheetLine3.Description := TimeSheetLine3.Description;
                                    TimeSheetLine3."NS_Ref Customize TimesheetNo." := TimeSheetCustLine."NS_TimeSheetNo.";
                                    TimeSheetLine3.NS_CrewTimeSheetLine := true;
                                    TimeSheetLine3."NS_Crew Time Unique Line ID" := TimeSheetCustLine."NS_Unique Line ID";
                                    TimeSheetLine3.NS_TimeSheetCrewWorkDays := TimeSheetCustLine.NS_TimeSheetCrewWorkDays;
                                    TimeSheetLine3."NS_Work Type Code" := TimeSheetCustLine."NS_Work Type Code";
                                    TimeSheetLine3."NS_Crew Time Sheet Ref. No." := TimeSheetCustLine."NS_TimeSheetNo.";
                                    TimeSheetLine3."NS_Crew Time Sheet Date" := TimeSheetCustLine."NS_Working Date";
                                    //PE-68 Dk.1.0 10April2023 Start
                                    //TimeSheetLine3."NS_Skill Code" := TimeSheetCustLine."NS_Skill Code";
                                    TimeSheetLine3."NS_Skill Code New" := TimeSheetCustLine."NS_Skill Code New";
                                    //PE-68 Dk.1.0 10April2023 End
                                    TimeSheetLine3."NS_Segment Code" := TimeSheetCustLine."NS_Segment Code";
                                    TimeSheetLine3."NS_Union Code" := TimeSheetCustLine."NS_Union Code"; //PRJCTPR-2.RM.1.0 13Dec2022
                                    TimeSheetLine3.Description := CopyStr(WorkDescription, 1, 99);
                                    TimeSheetLine3.Modify();
                                    //PRJ-1144.JS.1.0 06FEB2022-end Update the existing lines in manager timesheet line                                
                                end;
                            end;
                            //PRJ-1144.JS.1.0 06FEB2022 -start
                            TimeSheetCustLine.NS_Status := TimeSheetCustLine.NS_Status::Submitted;
                            TimeSheetCustLine.Modify();
                        //PRJ-1144.JS.1.0 06FEB2022 -end
                        until TimeSheetCustLine.Next() = 0;

                    Commit();

                    TimeSheetCustLine3.Reset();
                    TimeSheetCustLine3.SetRange("NS_TimeSheetNo.", TsheetHdrCustom."NS_No.");
                    //PRJ-1144.JS.1.0 06FEB2022 - Start
                    TimeSheetCustLine3.SetRange(NS_Status, TimeSheetCustLine3.NS_Status::Open);
                    TimeSheetCustLine3.SetRange("NS_Ready To Submit", true);
                    //PRJ-1144.JS.1.0 06FEB2022 - end
                    if TimeSheetCustLine3.FindSet() then
                        repeat
                            TimeSheetLine2.Reset();
                            TimeSheetLine2.SetRange("Time Sheet No.", TSHHDROuter."No.");
                            TimeSheetLine2.SetRange("Job No.", TimeSheetCustLine3."NS_Job No.");
                            TimeSheetLine2.SetRange("Job Task No.", TimeSheetCustLine3."NS_Job Task No.");
                            TimeSheetLine2.SetRange("NS_Crew code", TimeSheetCustLine3."NS_Crew code");
                            TimeSheetLine2.SetRange("NS_Resource No.", TimeSheetCustLine3."NS_Resource No.");
                            TimeSheetLine2.SetRange("NS_Crew Time Sheet Line No.", TimeSheetCustLine3."NS_LineNo.");  //PRJ-1144.JS.1.0 06FEB2022
                            if TimeSheetLine2.FindSet() then
                                repeat
                                    TSDetail.Reset();
                                    TSDetail.SetRange("Time Sheet No.", TimeSheetLine2."Time Sheet No.");
                                    TSDetail.SetRange("Time Sheet Line No.", TimeSheetLine2."Line No.");
                                    TSDetail.SetRange("Job No.", TimeSheetLine2."Job No.");
                                    TSDetail.SetRange("Job Task No.", TimeSheetLine2."Job Task No.");
                                    TSDetail.SetRange("Resource No.", TimeSheetLine2."NS_Resource No.");
                                    TSDetail.SetRange(Date, TimeSheetCustLine3."NS_Working Date");
                                    TSDetail.SetRange("NS_Crew Time Sheet Line No.", TimeSheetLine2."NS_Crew Time Sheet Line No."); //PRJ-1144.JS.1.0 06FEB2022  
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
                                        TSDetail."NS_Crew Time Sheet Line No." := TimeSheetLine2."NS_Crew Time Sheet Line No.";  //PRJ-1144.JS.1.0 06FEB2022
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
                                        //PE-68 Dk.1.0 10April2023 Start                         
                                        // TSDetail1."NS_Skill Code" := TimeSheetCustLine3."NS_Skill Code";
                                        TSDetail1."NS_Skill Code New" := TimeSheetCustLine3."NS_Skill Code New";
                                        //PE-68 Dk.1.0 10April2023 End
                                        TSDetail1."NS_Segment Code" := TimeSheetCustLine3."NS_Segment Code";
                                        TSDetail1."NS_Work Description" := TimeSheetCustLine3.NS_Description;
                                        //PRJ-841.JS.1.0 PRJ-841.JS.1.0 16Aug2021-end                                                                                  
                                        TSDetail1.NS_CrewTimeSheetLine := true;
                                        if not TSDetail1.Insert() then
                                            TSDetail1.Modify();
                                        //PRJ-1144.JS.1.0 06FEB2022 - start
                                    end else begin
                                        TSDetail1."Job No." := TimeSheetLine2."Job No.";
                                        TSDetail1."Job Id" := TimeSheetLine2."Job Id";
                                        TSDetail1."Job Task No." := TimeSheetLine2."Job Task No.";
                                        TSDetail1."Cause of Absence Code" := TimeSheetLine2."Cause of Absence Code";
                                        TSDetail1."Service Order No." := TimeSheetLine2."Service Order No.";
                                        TSDetail1."Service Order Line No." := TimeSheetLine2."Service Order Line No.";
                                        TSDetail1."Assembly Order No." := TimeSheetLine2."Assembly Order No.";
                                        TSDetail1."Assembly Order Line No." := TimeSheetLine2."Assembly Order Line No.";
                                        TSDetail."NS_Crew Time Sheet Line No." := TimeSheetLine2."NS_Crew Time Sheet Line No.";  //PRJ-1144.JS.1.0 06FEB2022
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
                                        //PE-68 Dk.1.0 10April2023 Start                        
                                        // TSDetail1."NS_Skill Code" := TimeSheetCustLine3."NS_Skill Code";
                                        TSDetail1."NS_Skill Code New" := TimeSheetCustLine3."NS_Skill Code New";
                                        //PE-68 Dk.1.0 10April2023 End
                                        TSDetail1."NS_Segment Code" := TimeSheetCustLine3."NS_Segment Code";
                                        TSDetail1."NS_Work Description" := TimeSheetCustLine3.NS_Description;
                                        //PRJ-841.JS.1.0 PRJ-841.JS.1.0 16Aug2021-end                                                                                  
                                        TSDetail1.NS_CrewTimeSheetLine := true;
                                    end;
                                //PRJ-1144.JS.1.0 06FEB2022 - end                                    
                                until TimeSheetLine2.Next() = 0;
                        until TimeSheetCustLine3.Next() = 0;
                    MESSAGE('Crew Time Sheet %1 has been submitted for approval ref. %2', TSHHDRCustomize, TimeSheetHeadNo);  //PRJ-1144.JS.3.0 09FEB2022

                    NS_SubmitAllLinesToManagerTimeSheetpg(TimeSheetLine2."Time Sheet No.");
                    TsheetHdrCustom.NS_Status := TsheetHdrCustom.NS_Status::Submitted;
                    TsheetHdrCustom.Modify();
                    //PRJ-1144.JS.1.0 06Feb2022 - Start
                end else begin

                    TimeSheetCustLine.Reset();
                    TimeSheetCustLine.SetRange("NS_TimeSheetNo.", TSHHDROuter2."NS_Crew Time Sheet Ref. No.");
                    TimeSheetCustLine.SetRange("NS_Ready To Submit", true);  //PRJ-1144.JS.1.0 31JAN2022 all line
                    TimeSheetCustLine.SetRange(NS_Status, TimeSheetCustLine.NS_Status::Open);  //PRJ-1144.JS.1.0 31JAN2022 all line
                    if TimeSheetCustLine.FindSet() then
                        repeat

                            TimeSheetLine1.Reset();
                            TimeSheetLine1.SetRange("NS_Crew Time Sheet Ref. No.", TimeSheetCustLine."NS_TimeSheetNo.");
                            TimeSheetLine1.SetRange("Job No.", TimeSheetCustLine."NS_Job No.");
                            TimeSheetLine1.SetRange("Job Task No.", TimeSheetCustLine."NS_Job Task No.");
                            TimeSheetLine1.SetRange("NS_Crew code", TimeSheetCustLine."NS_Crew code");
                            TimeSheetLine1.SetRange("NS_Resource No.", TimeSheetCustLine."NS_Resource No.");
                            TimeSheetLine1.SetRange("NS_Crew Time Unique Line ID", TimeSheetCustLine."NS_Unique Line ID");
                            //TimeSheetLine1.SetRange("NS_Crew Time Sheet Line No.", TimeSheetCustLine."NS_LineNo.");  //PRJ-1144.JS.1.0 06FEB2022                            
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
                                //PRJ-1144.JS.1.0 06FEB2022 - start
                                TimeShtCustLine2.setrange(NS_Status, TimeShtCustLine2.NS_Status::Open);
                                TimeShtCustLine2.setrange("NS_Ready To Submit", true);
                                //PRJ-1144.JS.1.0 06FEB2022 - end
                                TimeShtCustLine2.Setfilter("NS_LineNo.", '<>%1', 0);
                                IF TimeShtCustLine2.FindFirst() then
                                    WorkDescription := TimeShtCustLine2.NS_Description;
                                //PRJ-841.JS.1.0 16Aug2021 Get work description-end
                                TimeSheetLine.Init();
                                TimeSheetLine."Time Sheet No." := TSHHDROuter2."No.";

                                TimeSheetLineIN.RESET();
                                TimeSheetLineIN.SETRANGE("Time Sheet No.", TSHHDROuter2."No.");
                                if TimeSheetLineIN.FindLast() then
                                    NextLineNo := TimeSheetLineIN."Line No." + 10000
                                else
                                    NextLineNo := 10000;

                                TimeSheetLine."Line No." := NextLineNo;
                                //TimeSheetLine."Time Sheet Starting Date" := TSHHDROuter2."Starting Date";  //PRJ-1144.JS.2.0 JS 08FEB2022
                                TimeSheetLine."Time Sheet Starting Date" := TimeSheetCustLine."NS_Working Date";  //PRJ-1144.JS.2.0 JS 08FEB2022
                                TimeSheetLine.Type := TimeSheetLine.Type::Job;
                                TimeSheetLine."Job No." := TimeSheetCustLine."NS_Job No.";
                                TimeSheetLine."Job Task No." := TimeSheetCustLine."NS_Job Task No.";
                                TimeSheetLine."NS_Crew code" := TimeSheetCustLine."NS_Crew code";
                                TimeSheetLine."NS_Resource No." := TimeSheetCustLine."NS_Resource No.";
                                TimeSheetLine."NS_Resource Name New" := TimeSheetCustLine."NS_Resource Name New";
                                TimeSheetLine.Status := TimeSheetLine.Status::Submitted;
                                TimeSheetLine."NS_Ref Customize TimesheetNo." := TimeSheetCustLine."NS_TimeSheetNo.";
                                TimeSheetLine.NS_CrewTimeSheetLine := true;
                                TimeSheetLine."NS_Crew Time Unique Line ID" := TimeSheetCustLine."NS_Unique Line ID";
                                TimeSheetLine."Total Quantity" := TimeSheetCustLine."NS_Resource Working Hours";
                                TimeSheetLine."Approver ID" := UserId();
                                TimeSheetLine.NS_TimeSheetCrewWorkDays := TimeSheetCustLine.NS_TimeSheetCrewWorkDays;
                                TimeSheetLine."NS_Work Type Code" := TimeSheetCustLine."NS_Work Type Code";
                                TimeSheetLine."NS_Crew Time Sheet Ref. No." := TimeSheetCustLine."NS_TimeSheetNo.";
                                TimeSheetLine."NS_Crew Time Sheet Date" := TimeSheetCustLine."NS_Working Date";
                                TimeSheetLine."NS_Crew Time Sheet Line No." := TimeSheetCustLine."NS_LineNo.";//PRJ-1144.JS.1.0 06FEB2022
                                //PE-68 Dk.1.0 10April2023 Start
                                //TimeSheetLine."NS_Skill Code" := TimeSheetCustLine."NS_Skill Code";
                                TimeSheetLine."NS_Skill Code New" := TimeSheetCustLine."NS_Skill Code New";
                                //PE-68 Dk.1.0 10April2023 End
                                TimeSheetLine."NS_Union Code" := TimeSheetCustLine."NS_Union Code"; //PRJCTPR-2.RM.1.0 13Dec2022
                                TimeSheetLine."NS_Segment Code" := TimeSheetCustLine."NS_Segment Code";
                                TimeSheetLine.Description := CopyStr(WorkDescription, 1, 99);

                                if not TimeSheetLine.Insert() then
                                    TimeSheetLine.Modify();

                                //PRJ-1144.JS.1.0 - Start enter Time Sheet Detail
                                TSDetail.Reset();
                                TSDetail.SetRange("Time Sheet No.", TimeSheetLine."Time Sheet No.");
                                TSDetail.SetRange("Time Sheet Line No.", TimeSheetLine."Line No.");
                                TSDetail.SetRange("Job No.", TimeSheetLine."Job No.");
                                TSDetail.SetRange("Job Task No.", TimeSheetLine."Job Task No.");
                                TSDetail.SetRange("Resource No.", TimeSheetLine."NS_Resource No.");
                                TSDetail.SetRange(Date, TimeSheetCustLine."NS_Working Date");
                                if NOT TSDetail.FindFirst() then begin
                                    TSDetail1.Init();
                                    TSDetail1."Time Sheet No." := TimeSheetLine."Time Sheet No.";
                                    TSDetail1."Time Sheet Line No." := TimeSheetLine."Line No.";
                                    TSDetail1.date := TimeSheetCustLine."NS_Working Date";
                                    TSDetail1.Type := TimeSheetLine.Type;
                                    TSDetail1."Job No." := TimeSheetLine."Job No.";
                                    TSDetail1."Job Id" := TimeSheetLine."Job Id";
                                    TSDetail1."Job Task No." := TimeSheetLine."Job Task No.";
                                    TSDetail1."Cause of Absence Code" := TimeSheetLine."Cause of Absence Code";
                                    TSDetail1."Service Order No." := TimeSheetLine."Service Order No.";
                                    TSDetail1."Service Order Line No." := TimeSheetLine."Service Order Line No.";
                                    TSDetail1."Assembly Order No." := TimeSheetLine."Assembly Order No.";
                                    TSDetail1."Assembly Order Line No." := TimeSheetLine."Assembly Order Line No.";
                                    TSDetail1.validate(Quantity, TimeSheetCustLine."NS_Resource Working Hours");
                                    TSDetail1."NS_Crew Time Sheet Line No." := TimeSheetCustLine."NS_LineNo.";

                                    TSDetail1."Resource No." := TimeSheetCustLine."NS_Resource No.";
                                    TSDetail1.Status := TimeSheetLine2.Status;
                                    TSDetail1.NS_Description := TimeSheetCustLine.NS_Description;
                                    TSDetail1."NS_Crew Code" := TimeSheetCustLine."NS_Crew code";
                                    TSDetail1."NS_Crew Time Unique Line ID" := TimeSheetCustLine."NS_Unique Line ID";
                                    TSDetail1.NS_TimeSheetCrewWorkDays := TimeSheetCustLine.NS_TimeSheetCrewWorkDays;
                                    TSDetail1."NS_Work Type Code" := TimeSheetCustLine."NS_Work Type Code";
                                    TSDetail1."NS_Crew Time Sheet Ref. No." := TimeSheetCustLine."NS_TimeSheetNo.";
                                    TSDetail1."NS_Crew Time Sheet Date" := TimeSheetCustLine."NS_Working Date";
                                    //PE-68 Dk.1.0 10April2023 Start
                                    // TSDetail1."NS_Skill Code" := TimeSheetCustLine."NS_Skill Code";
                                    TSDetail1."NS_Skill Code New" := TimeSheetCustLine."NS_Skill Code New";
                                    //PE-68.Dk.1.0 10April2023 End
                                    TSDetail1."NS_Segment Code" := TimeSheetCustLine."NS_Segment Code";
                                    TSDetail1."NS_Work Description" := TimeSheetCustLine.NS_Description;
                                    TSDetail1.NS_Description := TimeSheetCustLine.NS_Description;
                                    TSDetail1.NS_CrewTimeSheetLine := true;
                                    if not TSDetail1.Insert() then
                                        TSDetail1.Modify();
                                end;
                                //PRJ-1144.JS.1.0 - End enter Time Sheet Detail    
                            end else begin
                                //Message('DDDDDD');
                                TimeSheetLine3.Reset();
                                //TimeSheetLine3.SetRange("Time Sheet No.", TSHHDROuter2."No.");
                                //TimeSheetLine3.SetRange(, TSHHDROuter2."NS_Crew Time Sheet Ref. No.");                                 
                                TimeSheetLine3.SetRange("NS_Crew Time Sheet Ref. No.", TSHHDROuter2."NS_Crew Time Sheet Ref. No.");
                                TimeSheetLine3.SetRange("Job No.", TimeSheetCustLine."NS_Job No.");
                                TimeSheetLine3.SetRange("Job Task No.", TimeSheetCustLine."NS_Job Task No.");
                                TimeSheetLine3.SetRange("NS_Crew code", TimeSheetCustLine."NS_Crew code");
                                TimeSheetLine3.SetRange("NS_Resource No.", TimeSheetCustLine."NS_Resource No.");
                                TimeSheetLine3.setrange("NS_Crew Time Unique Line ID", TimeSheetCustLine."NS_Unique Line ID");
                                If TimeSheetLine3.FindFirst() then begin

                                    //TimeSheetLine3."Time Sheet Starting Date" := TSHHDROuter2."Starting Date";    //PRJ-1144.JS.2.0 JS 08FEB2022
                                    TimeSheetLine3."Time Sheet Starting Date" := TimeSheetCustLine."NS_Working Date";  //PRJ-1144.JS.2.0 JS 08FEB2022
                                    TimeSheetLine3.Type := TimeSheetLine3.Type::Job;
                                    TimeSheetLine3."Job No." := TimeSheetCustLine."NS_Job No.";
                                    TimeSheetLine3."Job Task No." := TimeSheetCustLine."NS_Job Task No.";
                                    TimeSheetLine3."NS_Crew code" := TimeSheetCustLine."NS_Crew code";
                                    TimeSheetLine3."NS_Resource No." := TimeSheetCustLine."NS_Resource No.";
                                    TimeSheetLine3."NS_Resource Name New" := TimeSheetCustLine."NS_Resource Name New";
                                    TimeSheetLine3."Total Quantity" := TimeSheetCustLine."NS_Resource Working Hours";
                                    TimeSheetLine3.Status := TimeSheetLine3.Status::Submitted;
                                    TimeSheetLine3.Description := TimeSheetCustLine.NS_Description;  //PRJ-1144.JS.2.0 JS 08FEB2022
                                    TimeSheetLine3.NS_Correction := true;
                                    TimeSheetLine3."NS_Ref Customize TimesheetNo." := TimeSheetCustLine."NS_TimeSheetNo.";
                                    TimeSheetLine3.NS_CrewTimeSheetLine := true;
                                    TimeSheetLine3."NS_Crew Time Unique Line ID" := TimeSheetCustLine."NS_Unique Line ID";
                                    TimeSheetLine3.NS_TimeSheetCrewWorkDays := TimeSheetCustLine.NS_TimeSheetCrewWorkDays;
                                    TimeSheetLine3."NS_Work Type Code" := TimeSheetCustLine."NS_Work Type Code";
                                    TimeSheetLine3."NS_Crew Time Sheet Ref. No." := TimeSheetCustLine."NS_TimeSheetNo.";
                                    TimeSheetLine3."NS_Crew Time Sheet Date" := TimeSheetCustLine."NS_Working Date";
                                    TimeSheetLine3."NS_Skill Code" := TimeSheetCustLine."NS_Skill Code";
                                    TimeSheetLine3."NS_Union Code" := TimeSheetCustLine."NS_Union Code"; //PRJCTPR-2.RM.1.0 13Dec2022
                                    TimeSheetLine3."NS_Segment Code" := TimeSheetCustLine."NS_Segment Code";
                                    //TimeSheetLine3.Description := CopyStr(WorkDescription, 1, 99);  //PRJ-1144.JS.2.0 JS 08FEB2022
                                    TimeSheetLine3.Modify();
                                    //PRJ-1144.JS.1.0 07Feb2022 Start-Update time sheet details
                                    TSDetail1.Reset();
                                    TSDetail1.SetRange("Time Sheet No.", TimeSheetLine3."Time Sheet No.");
                                    TSDetail1.SetRange("Time Sheet Line No.", TimeSheetLine3."Line No.");
                                    TSDetail1.SetRange("Job No.", TimeSheetLine3."Job No.");
                                    TSDetail1.SetRange("Job Task No.", TimeSheetLine3."Job Task No.");
                                    TSDetail1.SetRange("Resource No.", TimeSheetLine3."NS_Resource No.");
                                    TSDetail1.SetRange(Date, TimeSheetCustLine."NS_Working Date");
                                    if TSDetail1.FindFirst() then begin
                                        TSDetail1."Job No." := TimeSheetLine1."Job No.";
                                        TSDetail1."Job Id" := TimeSheetLine1."Job Id";
                                        TSDetail1."Job Task No." := TimeSheetLine1."Job Task No.";
                                        TSDetail1."Cause of Absence Code" := TimeSheetLine1."Cause of Absence Code";
                                        TSDetail1."Service Order No." := TimeSheetLine1."Service Order No.";
                                        TSDetail1."Service Order Line No." := TimeSheetLine1."Service Order Line No.";
                                        TSDetail1."Assembly Order No." := TimeSheetLine1."Assembly Order No.";
                                        TSDetail1."Assembly Order Line No." := TimeSheetLine1."Assembly Order Line No.";
                                        TSDetail."NS_Crew Time Sheet Line No." := TimeSheetLine1."NS_Crew Time Sheet Line No.";  //PRJ-1144.JS.1.0 06FEB2022
                                                                                                                                 //TSDetail1.validate(Quantity, TimeSheetCustLine3."NS_Working Hours");    //PRJ-924.JS.1.0 17Sep2021-Line Commented
                                        TSDetail1.validate(Quantity, TimeSheetCustLine."NS_Resource Working Hours");    //PRJ-924.JS.1.0 17Sep2021 Line Added
                                                                                                                        //TSDetail1.validate(Quantity, TimeSheetCustLine3."NS_Working Hours");  //PRJ-924.JS.1.0 17Sep2021 Line Commented
                                        TSDetail1."Resource No." := TimeSheetCustLine."NS_Resource No.";
                                        TSDetail1.Status := TimeSheetLine1.Status;
                                        TSDetail1.NS_Description := TimeSheetCustLine.NS_Description;
                                        TSDetail1."NS_Crew Code" := TimeSheetCustLine."NS_Crew code";
                                        TSDetail1."NS_Crew Time Unique Line ID" := TimeSheetCustLine."NS_Unique Line ID";
                                        TSDetail1.NS_TimeSheetCrewWorkDays := TimeSheetCustLine.NS_TimeSheetCrewWorkDays;
                                        TSDetail1."NS_Work Type Code" := TimeSheetCustLine."NS_Work Type Code";
                                        TSDetail1."NS_Crew Time Sheet Ref. No." := TimeSheetCustLine."NS_TimeSheetNo.";
                                        TSDetail1."NS_Crew Time Sheet Date" := TimeSheetCustLine."NS_Working Date";
                                        //PE-68 Dk.1.0 10April2023 Start
                                        // TSDetail1."NS_Skill Code" := TimeSheetCustLine."NS_Skill Code";
                                        TSDetail1."NS_Skill Code New" := TimeSheetCustLine."NS_Skill Code New";
                                        //PE-68 Dk.1.0 10April2023 End
                                        TSDetail1."NS_Segment Code" := TimeSheetCustLine."NS_Segment Code";

                                        TSDetail1."NS_Work Description" := CopyStr(WorkDescription, 1, 99);
                                        TSDetail1.NS_Description := TimeSheetCustLine.NS_Description;  //PRJ-1144.JS.2.0 JS 08FEB2022

                                        TSDetail1.NS_CrewTimeSheetLine := true;
                                        TSDetail1.Modify();
                                        //PRJ-1144.JS.1.0 07Feb2022 end-Update time sheet details
                                    end;
                                    TimeSheetCustLine.NS_Status := TimeSheetCustLine.NS_Status::Submitted;
                                    TimeSheetCustLine.Modify();
                                end;
                            end;
                            //PRJ-1144.JS.1.0 06FEB2022 -start
                            TimeSheetCustLine.NS_Status := TimeSheetCustLine.NS_Status::Submitted;
                            TimeSheetCustLine.Modify();
                        //PRJ-1144.JS.1.0 06FEB2022 -end;
                        until TimeSheetCustLine.Next() = 0;
                    Commit();

                    TimeSheetCustLine3.Reset();
                    TimeSheetCustLine3.SetRange("NS_TimeSheetNo.", TsheetHdrCustom."NS_No.");
                    TimeSheetCustLine3.SetRange(NS_Status, TimeSheetCustLine3.NS_Status::Open);
                    TimeSheetCustLine3.SetRange("NS_Ready To Submit", true);
                    if TimeSheetCustLine3.FindSet() then
                        repeat
                            TimeSheetLine2.Reset();
                            TimeSheetLine2.SetRange("Time Sheet No.", TSHHDROuter."No.");
                            TimeSheetLine2.SetRange("Job No.", TimeSheetCustLine3."NS_Job No.");
                            TimeSheetLine2.SetRange("Job Task No.", TimeSheetCustLine3."NS_Job Task No.");
                            TimeSheetLine2.SetRange("NS_Crew code", TimeSheetCustLine3."NS_Crew code");
                            TimeSheetLine2.SetRange("NS_Resource No.", TimeSheetCustLine3."NS_Resource No.");
                            TimeSheetLine2.SetRange("NS_Crew Time Sheet Line No.", TimeSheetCustLine3."NS_LineNo.");
                            if TimeSheetLine2.FindSet() then
                                repeat
                                    TSDetail.Reset();
                                    TSDetail.SetRange("Time Sheet No.", TimeSheetLine2."Time Sheet No.");
                                    TSDetail.SetRange("Time Sheet Line No.", TimeSheetLine2."Line No.");
                                    TSDetail.SetRange("Job No.", TimeSheetLine2."Job No.");
                                    TSDetail.SetRange("Job Task No.", TimeSheetLine2."Job Task No.");
                                    TSDetail.SetRange("Resource No.", TimeSheetLine2."NS_Resource No.");
                                    TSDetail.SetRange(Date, TimeSheetCustLine3."NS_Working Date");
                                    if NOT TSDetail.FindFirst() then begin
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
                                        TSDetail1.validate(Quantity, TimeSheetCustLine3."NS_Resource Working Hours");
                                        TSDetail1."NS_Crew Time Sheet Line No." := TimeSheetCustLine3."NS_LineNo.";

                                        TSDetail1."Resource No." := TimeSheetCustLine3."NS_Resource No.";
                                        TSDetail1.Status := TimeSheetLine2.Status;
                                        TSDetail1.NS_Description := TimeSheetCustLine3.NS_Description;
                                        TSDetail1."NS_Crew Code" := TimeSheetCustLine3."NS_Crew code";
                                        TSDetail1."NS_Crew Time Unique Line ID" := TimeSheetCustLine3."NS_Unique Line ID";
                                        TSDetail1.NS_TimeSheetCrewWorkDays := TimeSheetCustLine3.NS_TimeSheetCrewWorkDays;
                                        TSDetail1."NS_Work Type Code" := TimeSheetCustLine3."NS_Work Type Code";
                                        TSDetail1."NS_Crew Time Sheet Ref. No." := TimeSheetCustLine3."NS_TimeSheetNo.";
                                        TSDetail1."NS_Crew Time Sheet Date" := TimeSheetCustLine3."NS_Working Date";
                                        //PE-68 Dk.1.0 10April2023 Start
                                        //TSDetail1."NS_Skill Code" := TimeSheetCustLine3."NS_Skill Code";
                                        TSDetail1."NS_Skill Code New" := TimeSheetCustLine3."NS_Skill Code New";
                                        //PE-68 Dk.1.0 10April2023 End
                                        TSDetail1."NS_Segment Code" := TimeSheetCustLine3."NS_Segment Code";
                                        TSDetail1."NS_Work Description" := TimeSheetCustLine3.NS_Description;
                                        TSDetail1.NS_Description := TimeSheetCustLine3.NS_Description;
                                        TSDetail1.NS_CrewTimeSheetLine := true;
                                        if not TSDetail1.Insert() then
                                            TSDetail1.Modify();
                                    end;
                                until TimeSheetLine2.Next() = 0;
                        until TimeSheetCustLine3.Next() = 0;
                    //MESSAGE('Crew Time Sheet %1 has been submitted for approval ref. %2', TSHHDRCustomize, TimeSheetLine2."Time Sheet No.");
                    MESSAGE('Crew Time Sheet %1 has been submitted for approval ref. %2', TSHHDRCustomize, TimeSheetHeadNo);  //PRJ-1144.JS.3.0 09FEB2022
                    Commit();
                    NS_SubmitAllLinesToManagerTimeSheetpg(TimeSheetLine2."Time Sheet No.");
                    TsheetHdrCustom.NS_Status := TsheetHdrCustom.NS_Status::Submitted;
                    TsheetHdrCustom.Modify();
                end;
                //PRJ-1144.JS.1.0 06Feb2022 - end
            end else
                Message('Time sheet no. %1 get already submitted with all lines', TsheetHdrCustom."NS_No.");
        end;
    end;


    //PE-68.AS.1.0 30JUNE2023 START  //PRJ-1455.RM.1.0 ---- Just created another function to differentiate number of parameters
    procedure NS_MakeTimesheetEntry1(TSHHDRCustomize: Code[20]; TsheetLineNo: Integer; flag: Boolean);//PRJ-1455.RM.1.0

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
        TimeSheetLine3: Record "Time Sheet Line";
        TsheetHdrCustom: record NS_TimesheetHdrCustom;
        TSHHDR: record "Time Sheet Header";
        TSHHDROuter: Record "Time Sheet Header";
        TSHHDROuter2: Record "Time Sheet Header";   //PRJ-1144.JS.1.0 06Feb2022
        TSHHDROuter3: Record "Time Sheet Header";   //PRJ-1144.JS.3.0 09FEB2022
        TimeSheetHeadNo: Code[20];     //PRJ-1144.JS.3.0 09FEB2022
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
        Tflag: Boolean; //PRJ-1455.RM.1.0 

    begin
        Clear(TSSHCustomizedDocumentNo);
        Clear(JoBNoStore);
        Clear(JoBTaskNoStore);
        Clear(CreCodeStore);
        Clear(resourceStore);
        Clear(PostingDateStore);
        //PRJ-1144.JS.3.0 09FEB2022 - Start
        Clear(TimeSheetHeadNo);
        TSHHDROuter3.Reset();
        TSHHDROuter3.SetRange("NS_Crew Time Sheet Ref. No.", TSHHDRCustomize);
        if TSHHDROuter3.FindFirst() then
            TimeSheetHeadNo := TSHHDROuter3."No.";
        //PRJ-1144.JS.3.0 09FEB2022 - End    

        if TsheetHdrCustom.Get(TSHHDRCustomize) then begin
            //PRJ-1144.JS.1.0 06FEB2022-Start
            TsheetHdrCustom.CalcFields("NS_Total Line", "NS_Total Submitted Line");
            if TsheetHdrCustom."NS_Total Line" <> TsheetHdrCustom."NS_Total Submitted Line" then begin
                //IF TsheetHdrCustom.NS_Status = TsheetHdrCustom.NS_Status::Open Then begin
                //PRJ-1144.JS.1.0 06FEB2022-end
                ResourcesSetup.get();

                // TSHHDR.Reset();
                // TSHHDR.SetRange("NS_Ref Customize TimesheetNo.", TSHHDRCustomize);
                // if TSHHDR.Findfirst then
                //     Error('Base Time Sheet Entry %1 already exists for Custom Timesheet %1', TSHHDR."No.", TSHHDRCustomize);

                TSHHDROuter2.Reset();
                TSHHDROuter2.SetRange("NS_Crew Time Sheet Ref. No.", TsheetHdrCustom."NS_No.");
                if not TSHHDROuter2.FindFirst() then begin
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
                    TSHHDROuter."Owner User ID" := TsheetHdrCustom."NS_Time Sheet Owner User ID"; //PRJ-1452.GK.1.0 13June2022
                    TimeSheetHeadNo := TSHHDROuter."No.";  //PRJ-1144.JS.3.0 09FEB2022

                    CrewCodeLine.RESET();
                    CrewCodeLine.SETRANGE(NS_Code, TsheetHdrCustom."NS_Crew code");
                    CrewCodeLine.SetRange("NS_Lead Person", true);
                    if CrewCodeLine.FindFirst() then begin
                        TSHHDROuter."Resource No." := CrewCodeLine."NS_Resource No.";
                        TSHHDROuter."NS_Crew code" := CrewCodeLine.NS_Code;  //PRJ-472.JS.1.0 21JULY2021
                    end;

                    //PE-152.JS.1.0 24Aug2023 - Start
                    if ResourecRec.Get(TSHHDROuter."Resource No.") then begin
                        // TSHHDROuter."NS_Resource Name" := ResourecRec.Name;//PRJ-1074.AS.1.0 28DEC2021 Commented code for old field "NS_Resource Name"
                        TSHHDROuter."NS_Resource Name New" := ResourecRec.Name;//PRJ-1074.AS.1.0 28DEC2021 Add New code for new field "NS_Resource Name New"
                        TSHHDROuter."Approver User ID" := ResourecRec."Time Sheet Approver User ID";
                    end;
                    //PE-152.JS.1.0 24Aug2023 - end

                    TSHHDROuter."NS_Ref Customize TimesheetNo." := TsheetHdrCustom."NS_No.";

                    TSHHDROuter.Insert();

                    TimeSheetCustLine.Reset();
                    TimeSheetCustLine.SetRange("NS_TimeSheetNo.", TsheetHdrCustom."NS_No.");
                    TimeSheetCustLine.SetRange("NS_LineNo.", TsheetLineNo);//PRJ-1455.RM.1.0
                    //TimeSheetCustLine.SetRange("NS_Ready To Submit", true);  //PRJ-1144.JS.1.0 31JAN2022 //PRJ-1455.RM.1.0 commented
                    TimeSheetCustLine.SetRange(NS_Status, TimeSheetCustLine.NS_Status::Open);  //PRJ-1144.JS.1.0 31JAN2022
                    if TimeSheetCustLine.FindSet() then
                        repeat
                            TimeSheetLine1.Reset();
                            TimeSheetLine1.SetRange("Time Sheet No.", TSHHDROuter."No.");
                            TimeSheetLine1.SetRange("Job No.", TimeSheetCustLine."NS_Job No.");
                            TimeSheetLine1.SetRange("Job Task No.", TimeSheetCustLine."NS_Job Task No.");
                            TimeSheetLine1.SetRange("NS_Crew code", TimeSheetCustLine."NS_Crew code");
                            TimeSheetLine1.SetRange("NS_Resource No.", TimeSheetCustLine."NS_Resource No.");
                            TimeSheetLine1.SetRange("NS_Crew Time Sheet Line No.", TimeSheetCustLine."NS_LineNo."); //PRJ-1144.JS.1.0 06FEB2022 

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
                                //PRJ-1144.JS.1.0 06FEB2022 - start
                                TimeShtCustLine2.SetRange(NS_Status, TimeShtCustLine2.NS_Status::Open);
                                TimeShtCustLine2.SetRange("NS_LineNo.", TimeSheetCustLine."NS_LineNo.");//PRJ-1455.RM.1.0
                                //TimeShtCustLine2.SetRange("NS_Ready To Submit", true); //PRJ-1455.RM.1.0 commented
                                //PRJ-1144.JS.1.0 06FEB2022 - end
                                IF TimeShtCustLine2.FindFirst() then
                                    WorkDescription := TimeShtCustLine2.NS_Description;
                                //PRJ-841.JS.1.0 16Aug2021 Get work description-end
                                TimeSheetLine.Init();
                                TimeSheetLine."Time Sheet No." := TSHHDROuter."No.";

                                TimeSheetLineIN.RESET();
                                TimeSheetLineIN.SETRANGE("Time Sheet No.", TSHHDROuter."No.");
                                if TimeSheetLineIN.FindLast() then                  //PRJ-1144.JS.1.0 06FEB2022
                                    NextLineNo := TimeSheetLineIN."Line No." + 10000
                                else
                                    NextLineNo := 10000;

                                TimeSheetLine."Line No." := NextLineNo;
                                //TimeSheetLine."Time Sheet Starting Date" := TSHHDROuter."Starting Date";  //PRJ-1144.JS.2.0 JS 08FEB2022
                                TimeSheetLine."Time Sheet Starting Date" := TimeSheetCustLine."NS_Working Date";  //PRJ-1144.JS.2.0 JS 08FEB2022
                                                                                                                  // TimeSheetLine.Validate(Type, TimeSheetLine.Type::Job);
                                                                                                                  // TimeSheetLine.Validate("Job No.", TimeSheetCustLine."NS_Job No.");
                                                                                                                  // TimeSheetLine.Validate("Job Task No.", TimeSheetCustLine."NS_Job Task No.");
                                TimeSheetLine.Type := TimeSheetLine.Type::Job;
                                TimeSheetLine."Job No." := TimeSheetCustLine."NS_Job No.";
                                TimeSheetLine."Job Task No." := TimeSheetCustLine."NS_Job Task No.";
                                TimeSheetLine."NS_Crew code" := TimeSheetCustLine."NS_Crew code";
                                TimeSheetLine."NS_Resource No." := TimeSheetCustLine."NS_Resource No.";
                                TimeSheetLine."NS_Crew Time Sheet Line No." := TimeSheetCustLine."NS_LineNo.";   //PRJ-1144.JS.1.0 06FEB2022
                                                                                                                 // TimeSheetLine."NS_Resource Name" := TimeSheetCustLine."NS_Resource Name";//PRJ-1074.AS.1.0 28DEC2021 Commented code for old field "NS_Resource Name"
                                TimeSheetLine."NS_Resource Name New" := TimeSheetCustLine."NS_Resource Name New";//PRJ-1074.AS.1.0 28DEC2021 Add New code for new field "NS_Resource Name New"
                                TimeSheetLine.Status := TimeSheetLine.Status::Submitted;
                                TimeSheetLine."NS_Ref Customize TimesheetNo." := TSHHDROuter."NS_Ref Customize TimesheetNo.";
                                TimeSheetLine.NS_CrewTimeSheetLine := true;
                                TimeSheetLine."NS_Crew Time Unique Line ID" := TimeSheetCustLine."NS_Unique Line ID";
                                TimeSheetLine."Total Quantity" := TimeSheetCustLine."NS_Resource Working Hours";
                                TimeSheetLine.NS_TimeSheetCrewWorkDays := TimeSheetCustLine.NS_TimeSheetCrewWorkDays;
                                TimeSheetLine."NS_Work Type Code" := TimeSheetCustLine."NS_Work Type Code";
                                TimeSheetLine."Work Type Code" := TimeSheetCustLine."NS_Work Type Code"; //PE-68.DK.2.0 10july2023
                                TimeSheetLine."NS_Crew Time Sheet Ref. No." := TimeSheetCustLine."NS_TimeSheetNo.";
                                TimeSheetLine."NS_Crew Time Sheet Date" := TimeSheetCustLine."NS_Working Date";
                                TimeSheetLine."Approver ID" := UserId();  //PRJ-1144.JS.1.0 06FEB2022
                                                                          //PRJ-841.JS.1.0 PRJ-841.JS.1.0 16Aug2021-Start                            
                                TimeSheetLine."NS_Time Sheet Owner User ID" := TimeSheetCustLine."NS_Time Sheet Owner User ID"; //PRJ-1452.GK.1.0 13June2022
                                //PE-68 Dk.1.0 10April2023 Start
                                //TimeSheetLine."NS_Skill Code" := TimeSheetCustLine."NS_Skill Code";
                                TimeSheetLine."NS_Skill Code New" := TimeSheetCustLine."NS_Skill Code New";
                                //PE-68 Dk.1.0 10April2023 End
                                TimeSheetLine."NS_Segment Code" := TimeSheetCustLine."NS_Segment Code";
                                TimeSheetLine."NS_Union Code" := TimeSheetCustLine."NS_Union Code"; //PRJCTPR-2.RM.1.0 13Dec2022
                                TimeSheetLine.Description := CopyStr(WorkDescription, 1, 99);
                                //PRJ-841.JS.1.0 PRJ-841.JS.1.0 16Aug2021-end                                                      
                                if not TimeSheetLine.Insert() then
                                    TimeSheetLine.Modify();

                                //PRJ-1144.JS.1.0 Start enter time sheet Detail line-Start                                
                                TSDetail.Reset();
                                TSDetail.SetRange("Time Sheet No.", TimeSheetLine."Time Sheet No.");
                                TSDetail.SetRange("Time Sheet Line No.", TimeSheetLine."Line No.");
                                TSDetail.SetRange("Job No.", TimeSheetLine2."Job No.");
                                TSDetail.SetRange("Job Task No.", TimeSheetLine2."Job Task No.");
                                TSDetail.SetRange("Resource No.", TimeSheetLine2."NS_Resource No.");
                                TSDetail.SetRange(Date, TimeSheetCustLine."NS_Working Date");
                                if NOT TSDetail.FindFirst() then begin
                                    //Message('...%1..%2', TimeSheetCustLine3."NS_Resource No.",
                                    //    TimeSheetLine2."NS_Resource No.");
                                    TSDetail1.Init();
                                    TSDetail1."Time Sheet No." := TimeSheetLine."Time Sheet No.";
                                    TSDetail1."Time Sheet Line No." := TimeSheetLine."Line No.";
                                    TSDetail1.date := TimeSheetCustLine."NS_Working Date";
                                    TSDetail1.Type := TimeSheetLine.Type;
                                    TSDetail1."Job No." := TimeSheetLine."Job No.";
                                    TSDetail1."Job Id" := TimeSheetLine."Job Id";
                                    TSDetail1."Job Task No." := TimeSheetLine."Job Task No.";
                                    TSDetail1."Cause of Absence Code" := TimeSheetLine."Cause of Absence Code";
                                    TSDetail1."Service Order No." := TimeSheetLine."Service Order No.";
                                    TSDetail1."Service Order Line No." := TimeSheetLine."Service Order Line No.";
                                    TSDetail1."Assembly Order No." := TimeSheetLine."Assembly Order No.";
                                    TSDetail1."Assembly Order Line No." := TimeSheetLine."Assembly Order Line No.";
                                    TSDetail."NS_Crew Time Sheet Line No." := TimeSheetLine."NS_Crew Time Sheet Line No.";  //PRJ-1144.JS.1.0 06FEB2022
                                                                                                                            //TSDetail1.validate(Quantity, TimeSheetCustLine3."NS_Working Hours");    //PRJ-924.JS.1.0 17Sep2021-Line Commented
                                    TSDetail1.validate(Quantity, TimeSheetCustLine."NS_Resource Working Hours");    //PRJ-924.JS.1.0 17Sep2021 Line Added
                                                                                                                    //TSDetail1.validate(Quantity, TimeSheetCustLine3."NS_Working Hours");  //PRJ-924.JS.1.0 17Sep2021 Line Commented
                                    TSDetail1."Resource No." := TimeSheetCustLine."NS_Resource No.";
                                    TSDetail1.Status := TimeSheetLine2.Status;
                                    TSDetail1.NS_Description := TimeSheetCustLine.NS_Description;
                                    TSDetail1."NS_Crew Code" := TimeSheetCustLine."NS_Crew code";
                                    TSDetail1."NS_Crew Time Unique Line ID" := TimeSheetCustLine."NS_Unique Line ID";
                                    TSDetail1.NS_TimeSheetCrewWorkDays := TimeSheetCustLine.NS_TimeSheetCrewWorkDays;
                                    TSDetail1."NS_Work Type Code" := TimeSheetCustLine."NS_Work Type Code";
                                    TSDetail1."NS_Crew Time Sheet Ref. No." := TimeSheetCustLine."NS_TimeSheetNo.";
                                    TSDetail1."NS_Crew Time Sheet Date" := TimeSheetCustLine."NS_Working Date";
                                    //PRJ-841.JS.1.0 PRJ-841.JS.1.0 16Aug2021-Start 
                                    //PE-68 Dk.1.0 10April2023 Start                           
                                    //TSDetail1."NS_Skill Code" := TimeSheetCustLine."NS_Skill Code";
                                    TSDetail1."NS_Skill Code New" := TimeSheetCustLine."NS_Skill Code New";
                                    //PE-68 Dk.1.0 10April2023 End
                                    TSDetail1."NS_Segment Code" := TimeSheetCustLine."NS_Segment Code";
                                    TSDetail1."NS_Work Description" := TimeSheetCustLine.NS_Description;
                                    //PRJ-841.JS.1.0 PRJ-841.JS.1.0 16Aug2021-end                                                                                  
                                    TSDetail1.NS_CrewTimeSheetLine := true;
                                    if not TSDetail1.Insert() then
                                        TSDetail1.Modify();
                                    //PRJ-1144.JS.1.0 06FEB2022 - start
                                    //PRJ-1144.JS.1.0 end enter time sheet Detail line-Start
                                end;
                            end else begin
                                TimeSheetLine3.Reset();
                                TimeSheetLine3.SetRange("Time Sheet No.", TSHHDROuter."No.");
                                TimeSheetLine3.SetRange("Job No.", TimeSheetCustLine."NS_Job No.");
                                TimeSheetLine3.SetRange("Job Task No.", TimeSheetCustLine."NS_Job Task No.");
                                TimeSheetLine3.SetRange("NS_Crew code", TimeSheetCustLine."NS_Crew code");
                                TimeSheetLine3.SetRange("NS_Resource No.", TimeSheetCustLine."NS_Resource No.");
                                TimeSheetLine3.SetRange("NS_Crew Time Sheet Line No.", TimeSheetCustLine."NS_LineNo.");
                                TimeSheetLine3.SetRange("Line No.", TimeSheetCustLine."NS_LineNo.");//PRJ-1455.RM.1.0
                                If TimeSheetLine3.FindFirst() then begin
                                    //PRJ-1144.JS.1.0 06FEB2022-Start Update the existing lines in manager timesheet line
                                    //TimeSheetLine3."Time Sheet Starting Date" := TSHHDROuter2."Starting Date";   //PRJ-1144.JS.2.0 JS 08FEB2022
                                    TimeSheetLine3."Time Sheet Starting Date" := TimeSheetCustLine."NS_Working Date";  //PRJ-1144.JS.2.0 JS 08FEB2022
                                    TimeSheetLine3.Type := TimeSheetLine3.Type::Job;
                                    TimeSheetLine3."Job No." := TimeSheetCustLine."NS_Job No.";
                                    TimeSheetLine3."Job Task No." := TimeSheetCustLine."NS_Job Task No.";
                                    TimeSheetLine3."NS_Crew code" := TimeSheetCustLine."NS_Crew code";
                                    TimeSheetLine3."NS_Resource No." := TimeSheetCustLine."NS_Resource No.";
                                    TimeSheetLine3."NS_Resource Name New" := TimeSheetCustLine."NS_Resource Name New";
                                    TimeSheetLine3."Total Quantity" := TimeSheetCustLine."NS_Resource Working Hours";
                                    TimeSheetLine3.Status := TimeSheetLine3.Status::Submitted;
                                    TimeSheetLine3.NS_Correction := true;
                                    TimeSheetLine3.Description := TimeSheetLine3.Description;
                                    TimeSheetLine3."NS_Ref Customize TimesheetNo." := TimeSheetCustLine."NS_TimeSheetNo.";
                                    TimeSheetLine3.NS_CrewTimeSheetLine := true;
                                    TimeSheetLine3."NS_Crew Time Unique Line ID" := TimeSheetCustLine."NS_Unique Line ID";
                                    TimeSheetLine3.NS_TimeSheetCrewWorkDays := TimeSheetCustLine.NS_TimeSheetCrewWorkDays;
                                    TimeSheetLine3."NS_Work Type Code" := TimeSheetCustLine."NS_Work Type Code";
                                    TimeSheetLine3."Work Type Code" := TimeSheetCustLine."NS_Work Type Code"; //PE-68.DK.2.0 10july2023
                                    TimeSheetLine3."NS_Crew Time Sheet Ref. No." := TimeSheetCustLine."NS_TimeSheetNo.";
                                    TimeSheetLine3."NS_Crew Time Sheet Date" := TimeSheetCustLine."NS_Working Date";
                                    //PE-68 Dk.1.0 10April2023 Start
                                    //TimeSheetLine3."NS_Skill Code" := TimeSheetCustLine."NS_Skill Code";
                                    TimeSheetLine3."NS_Skill Code New" := TimeSheetCustLine."NS_Skill Code New";
                                    //PE-68 Dk.1.0 10April2023 End
                                    TimeSheetLine3."NS_Segment Code" := TimeSheetCustLine."NS_Segment Code";
                                    TimeSheetLine3."NS_Union Code" := TimeSheetCustLine."NS_Union Code"; //PRJCTPR-2.RM.1.0 13Dec2022
                                    TimeSheetLine3.Description := CopyStr(WorkDescription, 1, 99);
                                    TimeSheetLine3.Modify();
                                    //PRJ-1144.JS.1.0 06FEB2022-end Update the existing lines in manager timesheet line                                
                                end;
                            end;
                            //PRJ-1144.JS.1.0 06FEB2022 -start
                            TimeSheetCustLine.NS_Status := TimeSheetCustLine.NS_Status::Submitted;
                            TimeSheetCustLine.Modify();
                        //PRJ-1144.JS.1.0 06FEB2022 -end
                        until TimeSheetCustLine.Next() = 0;

                    Commit();

                    TimeSheetCustLine3.Reset();
                    TimeSheetCustLine3.SetRange("NS_TimeSheetNo.", TsheetHdrCustom."NS_No.");
                    //PRJ-1144.JS.1.0 06FEB2022 - Start
                    TimeSheetCustLine3.SetRange(NS_Status, TimeSheetCustLine3.NS_Status::Open);
                    TimeSheetCustLine3.SetRange("NS_LineNo.", TsheetLineNo);//PRJ-1455.RM.1.0
                    //TimeSheetCustLine3.SetRange("NS_Ready To Submit", true); //PRJ-1455.RM.1.0 commented
                    //PRJ-1144.JS.1.0 06FEB2022 - end
                    if TimeSheetCustLine3.FindSet() then
                        repeat
                            TimeSheetLine2.Reset();
                            TimeSheetLine2.SetRange("Time Sheet No.", TSHHDROuter."No.");
                            TimeSheetLine2.SetRange("Job No.", TimeSheetCustLine3."NS_Job No.");
                            TimeSheetLine2.SetRange("Job Task No.", TimeSheetCustLine3."NS_Job Task No.");
                            TimeSheetLine2.SetRange("NS_Crew code", TimeSheetCustLine3."NS_Crew code");
                            TimeSheetLine2.SetRange("NS_Resource No.", TimeSheetCustLine3."NS_Resource No.");
                            TimeSheetLine2.SetRange("NS_Crew Time Sheet Line No.", TimeSheetCustLine3."NS_LineNo.");  //PRJ-1144.JS.1.0 06FEB2022
                            if TimeSheetLine2.FindSet() then
                                repeat
                                    TSDetail.Reset();
                                    TSDetail.SetRange("Time Sheet No.", TimeSheetLine2."Time Sheet No.");
                                    TSDetail.SetRange("Time Sheet Line No.", TimeSheetLine2."Line No.");
                                    TSDetail.SetRange("Job No.", TimeSheetLine2."Job No.");
                                    TSDetail.SetRange("Job Task No.", TimeSheetLine2."Job Task No.");
                                    TSDetail.SetRange("Resource No.", TimeSheetLine2."NS_Resource No.");
                                    TSDetail.SetRange(Date, TimeSheetCustLine3."NS_Working Date");
                                    TSDetail.SetRange("NS_Crew Time Sheet Line No.", TimeSheetLine2."NS_Crew Time Sheet Line No."); //PRJ-1144.JS.1.0 06FEB2022  
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
                                        TSDetail."NS_Crew Time Sheet Line No." := TimeSheetLine2."NS_Crew Time Sheet Line No.";  //PRJ-1144.JS.1.0 06FEB2022
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
                                        //PE-68 Dk.1.0 10April2023 Start                         
                                        // TSDetail1."NS_Skill Code" := TimeSheetCustLine3."NS_Skill Code";
                                        TSDetail1."NS_Skill Code New" := TimeSheetCustLine3."NS_Skill Code New";
                                        //PE-68 Dk.1.0 10April2023 End
                                        TSDetail1."NS_Segment Code" := TimeSheetCustLine3."NS_Segment Code";
                                        TSDetail1."NS_Work Description" := TimeSheetCustLine3.NS_Description;
                                        //PRJ-841.JS.1.0 PRJ-841.JS.1.0 16Aug2021-end                                                                                  
                                        TSDetail1.NS_CrewTimeSheetLine := true;
                                        if not TSDetail1.Insert() then
                                            TSDetail1.Modify();
                                        //PRJ-1144.JS.1.0 06FEB2022 - start
                                    end else begin
                                        TSDetail1."Job No." := TimeSheetLine2."Job No.";
                                        TSDetail1."Job Id" := TimeSheetLine2."Job Id";
                                        TSDetail1."Job Task No." := TimeSheetLine2."Job Task No.";
                                        TSDetail1."Cause of Absence Code" := TimeSheetLine2."Cause of Absence Code";
                                        TSDetail1."Service Order No." := TimeSheetLine2."Service Order No.";
                                        TSDetail1."Service Order Line No." := TimeSheetLine2."Service Order Line No.";
                                        TSDetail1."Assembly Order No." := TimeSheetLine2."Assembly Order No.";
                                        TSDetail1."Assembly Order Line No." := TimeSheetLine2."Assembly Order Line No.";
                                        TSDetail."NS_Crew Time Sheet Line No." := TimeSheetLine2."NS_Crew Time Sheet Line No.";  //PRJ-1144.JS.1.0 06FEB2022
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
                                        //PE-68 Dk.1.0 10April2023 Start                        
                                        // TSDetail1."NS_Skill Code" := TimeSheetCustLine3."NS_Skill Code";
                                        TSDetail1."NS_Skill Code New" := TimeSheetCustLine3."NS_Skill Code New";
                                        //PE-68 Dk.1.0 10April2023 End
                                        TSDetail1."NS_Segment Code" := TimeSheetCustLine3."NS_Segment Code";
                                        TSDetail1."NS_Work Description" := TimeSheetCustLine3.NS_Description;
                                        //PRJ-841.JS.1.0 PRJ-841.JS.1.0 16Aug2021-end                                                                                  
                                        TSDetail1.NS_CrewTimeSheetLine := true;
                                    end;
                                //PRJ-1144.JS.1.0 06FEB2022 - end                                    
                                until TimeSheetLine2.Next() = 0;
                        until TimeSheetCustLine3.Next() = 0;
                    //PRJ-1455.RM.1.0 start
                    if flag then
                        MESSAGE('Crew Time Sheet %1 has been submitted for approval ref. %2', TSHHDRCustomize, TimeSheetHeadNo);  //PRJ-1144.JS.3.0 09FEB2022 
                                                                                                                                  //PRJ-1455.RM.1.0 end
                    NS_SubmitAllLinesToManagerTimeSheetpg(TimeSheetLine2."Time Sheet No.");
                    TsheetHdrCustom.NS_Status := TsheetHdrCustom.NS_Status::Submitted;
                    TsheetHdrCustom.Modify();

                    //PRJ-1144.JS.1.0 06Feb2022 - Start
                end else begin

                    TimeSheetCustLine.Reset();
                    TimeSheetCustLine.SetRange("NS_TimeSheetNo.", TSHHDROuter2."NS_Crew Time Sheet Ref. No.");
                    TimeSheetCustLine.SetRange("NS_LineNo.", TsheetLineNo);//PRJ-1455.RM.1.0
                    //TimeSheetCustLine.SetRange("NS_Ready To Submit", true);  //PRJ-1144.JS.1.0 31JAN2022 all  //PRJ-1455.RM.1.0 commented
                    TimeSheetCustLine.SetRange(NS_Status, TimeSheetCustLine.NS_Status::Open);  //PRJ-1144.JS.1.0 31JAN2022 all line
                    if TimeSheetCustLine.FindSet() then
                        repeat

                            TimeSheetLine1.Reset();
                            TimeSheetLine1.SetRange("NS_Crew Time Sheet Ref. No.", TimeSheetCustLine."NS_TimeSheetNo.");
                            TimeSheetLine1.SetRange("Job No.", TimeSheetCustLine."NS_Job No.");
                            TimeSheetLine1.SetRange("Job Task No.", TimeSheetCustLine."NS_Job Task No.");
                            TimeSheetLine1.SetRange("NS_Crew code", TimeSheetCustLine."NS_Crew code");
                            TimeSheetLine1.SetRange("NS_Resource No.", TimeSheetCustLine."NS_Resource No.");
                            TimeSheetLine1.SetRange("NS_Crew Time Unique Line ID", TimeSheetCustLine."NS_Unique Line ID");
                            //TimeSheetLine1.SetRange("NS_Crew Time Sheet Line No.", TimeSheetCustLine."NS_LineNo.");  //PRJ-1144.JS.1.0 06FEB2022                            
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
                                //PRJ-1144.JS.1.0 06FEB2022 - start
                                TimeShtCustLine2.setrange(NS_Status, TimeShtCustLine2.NS_Status::Open);
                                TimeShtCustLine2.setrange("NS_LineNo.", TsheetLineNo);//PRJ-1455.RM.1.0
                                //TimeShtCustLine2.setrange("NS_Ready To Submit", true); //PRJ-1455.RM.1.0 commented
                                //PRJ-1144.JS.1.0 06FEB2022 - end
                                TimeShtCustLine2.Setfilter("NS_LineNo.", '<>%1', 0);
                                IF TimeShtCustLine2.FindFirst() then
                                    WorkDescription := TimeShtCustLine2.NS_Description;
                                //PRJ-841.JS.1.0 16Aug2021 Get work description-end
                                TimeSheetLine.Init();
                                TimeSheetLine."Time Sheet No." := TSHHDROuter2."No.";

                                TimeSheetLineIN.RESET();
                                TimeSheetLineIN.SETRANGE("Time Sheet No.", TSHHDROuter2."No.");
                                if TimeSheetLineIN.FindLast() then
                                    NextLineNo := TimeSheetLineIN."Line No." + 10000
                                else
                                    NextLineNo := 10000;

                                TimeSheetLine."Line No." := NextLineNo;
                                //TimeSheetLine."Time Sheet Starting Date" := TSHHDROuter2."Starting Date";  //PRJ-1144.JS.2.0 JS 08FEB2022
                                TimeSheetLine."Time Sheet Starting Date" := TimeSheetCustLine."NS_Working Date";  //PRJ-1144.JS.2.0 JS 08FEB2022
                                TimeSheetLine.Type := TimeSheetLine.Type::Job;
                                TimeSheetLine."Job No." := TimeSheetCustLine."NS_Job No.";
                                TimeSheetLine."Job Task No." := TimeSheetCustLine."NS_Job Task No.";
                                TimeSheetLine."NS_Crew code" := TimeSheetCustLine."NS_Crew code";
                                TimeSheetLine."NS_Resource No." := TimeSheetCustLine."NS_Resource No.";
                                TimeSheetLine."NS_Resource Name New" := TimeSheetCustLine."NS_Resource Name New";
                                TimeSheetLine.Status := TimeSheetLine.Status::Submitted;
                                TimeSheetLine."NS_Ref Customize TimesheetNo." := TimeSheetCustLine."NS_TimeSheetNo.";
                                TimeSheetLine.NS_CrewTimeSheetLine := true;
                                TimeSheetLine."NS_Crew Time Unique Line ID" := TimeSheetCustLine."NS_Unique Line ID";
                                TimeSheetLine."Total Quantity" := TimeSheetCustLine."NS_Resource Working Hours";
                                TimeSheetLine."Approver ID" := UserId();
                                TimeSheetLine.NS_TimeSheetCrewWorkDays := TimeSheetCustLine.NS_TimeSheetCrewWorkDays;
                                TimeSheetLine."NS_Work Type Code" := TimeSheetCustLine."NS_Work Type Code";
                                TimeSheetLine."Work Type Code" := TimeSheetCustLine."NS_Work Type Code"; //PE-68.DK.2.0 10july2023
                                TimeSheetLine."NS_Crew Time Sheet Ref. No." := TimeSheetCustLine."NS_TimeSheetNo.";
                                TimeSheetLine."NS_Crew Time Sheet Date" := TimeSheetCustLine."NS_Working Date";
                                TimeSheetLine."NS_Crew Time Sheet Line No." := TimeSheetCustLine."NS_LineNo.";//PRJ-1144.JS.1.0 06FEB2022
                                //PE-68 Dk.1.0 10April2023 Start
                                //TimeSheetLine."NS_Skill Code" := TimeSheetCustLine."NS_Skill Code";
                                TimeSheetLine."NS_Skill Code New" := TimeSheetCustLine."NS_Skill Code New";
                                //PE-68 Dk.1.0 10April2023 End
                                TimeSheetLine."NS_Union Code" := TimeSheetCustLine."NS_Union Code"; //PRJCTPR-2.RM.1.0 13Dec2022
                                TimeSheetLine."NS_Segment Code" := TimeSheetCustLine."NS_Segment Code";
                                TimeSheetLine.Description := CopyStr(WorkDescription, 1, 99);

                                if not TimeSheetLine.Insert() then
                                    TimeSheetLine.Modify();

                                //PRJ-1144.JS.1.0 - Start enter Time Sheet Detail
                                TSDetail.Reset();
                                TSDetail.SetRange("Time Sheet No.", TimeSheetLine."Time Sheet No.");
                                TSDetail.SetRange("Time Sheet Line No.", TimeSheetLine."Line No.");
                                TSDetail.SetRange("Job No.", TimeSheetLine."Job No.");
                                TSDetail.SetRange("Job Task No.", TimeSheetLine."Job Task No.");
                                TSDetail.SetRange("Resource No.", TimeSheetLine."NS_Resource No.");
                                TSDetail.SetRange(Date, TimeSheetCustLine."NS_Working Date");
                                if NOT TSDetail.FindFirst() then begin
                                    TSDetail1.Init();
                                    TSDetail1."Time Sheet No." := TimeSheetLine."Time Sheet No.";
                                    TSDetail1."Time Sheet Line No." := TimeSheetLine."Line No.";
                                    TSDetail1.date := TimeSheetCustLine."NS_Working Date";
                                    TSDetail1.Type := TimeSheetLine.Type;
                                    TSDetail1."Job No." := TimeSheetLine."Job No.";
                                    TSDetail1."Job Id" := TimeSheetLine."Job Id";
                                    TSDetail1."Job Task No." := TimeSheetLine."Job Task No.";
                                    TSDetail1."Cause of Absence Code" := TimeSheetLine."Cause of Absence Code";
                                    TSDetail1."Service Order No." := TimeSheetLine."Service Order No.";
                                    TSDetail1."Service Order Line No." := TimeSheetLine."Service Order Line No.";
                                    TSDetail1."Assembly Order No." := TimeSheetLine."Assembly Order No.";
                                    TSDetail1."Assembly Order Line No." := TimeSheetLine."Assembly Order Line No.";
                                    TSDetail1.validate(Quantity, TimeSheetCustLine."NS_Resource Working Hours");
                                    TSDetail1."NS_Crew Time Sheet Line No." := TimeSheetCustLine."NS_LineNo.";

                                    TSDetail1."Resource No." := TimeSheetCustLine."NS_Resource No.";
                                    TSDetail1.Status := TimeSheetLine2.Status;
                                    TSDetail1.NS_Description := TimeSheetCustLine.NS_Description;
                                    TSDetail1."NS_Crew Code" := TimeSheetCustLine."NS_Crew code";
                                    TSDetail1."NS_Crew Time Unique Line ID" := TimeSheetCustLine."NS_Unique Line ID";
                                    TSDetail1.NS_TimeSheetCrewWorkDays := TimeSheetCustLine.NS_TimeSheetCrewWorkDays;
                                    TSDetail1."NS_Work Type Code" := TimeSheetCustLine."NS_Work Type Code";
                                    TSDetail1."NS_Crew Time Sheet Ref. No." := TimeSheetCustLine."NS_TimeSheetNo.";
                                    TSDetail1."NS_Crew Time Sheet Date" := TimeSheetCustLine."NS_Working Date";
                                    //PE-68 Dk.1.0 10April2023 Start
                                    // TSDetail1."NS_Skill Code" := TimeSheetCustLine."NS_Skill Code";
                                    TSDetail1."NS_Skill Code New" := TimeSheetCustLine."NS_Skill Code New";
                                    //PE-68.Dk.1.0 10April2023 End
                                    TSDetail1."NS_Segment Code" := TimeSheetCustLine."NS_Segment Code";
                                    TSDetail1."NS_Work Description" := TimeSheetCustLine.NS_Description;
                                    TSDetail1.NS_Description := TimeSheetCustLine.NS_Description;
                                    TSDetail1.NS_CrewTimeSheetLine := true;
                                    if not TSDetail1.Insert() then
                                        TSDetail1.Modify();
                                end;
                                //PRJ-1144.JS.1.0 - End enter Time Sheet Detail    
                            end else begin
                                //Message('DDDDDD');
                                TimeSheetLine3.Reset();
                                //TimeSheetLine3.SetRange("Time Sheet No.", TSHHDROuter2."No.");
                                //TimeSheetLine3.SetRange(, TSHHDROuter2."NS_Crew Time Sheet Ref. No.");                                 
                                TimeSheetLine3.SetRange("NS_Crew Time Sheet Ref. No.", TSHHDROuter2."NS_Crew Time Sheet Ref. No.");
                                TimeSheetLine3.SetRange("Job No.", TimeSheetCustLine."NS_Job No.");
                                TimeSheetLine3.SetRange("Job Task No.", TimeSheetCustLine."NS_Job Task No.");
                                TimeSheetLine3.SetRange("NS_Crew code", TimeSheetCustLine."NS_Crew code");
                                TimeSheetLine3.SetRange("NS_Resource No.", TimeSheetCustLine."NS_Resource No.");
                                TimeSheetLine3.setrange("NS_Crew Time Unique Line ID", TimeSheetCustLine."NS_Unique Line ID");
                                If TimeSheetLine3.FindFirst() then begin

                                    //TimeSheetLine3."Time Sheet Starting Date" := TSHHDROuter2."Starting Date";    //PRJ-1144.JS.2.0 JS 08FEB2022
                                    TimeSheetLine3."Time Sheet Starting Date" := TimeSheetCustLine."NS_Working Date";  //PRJ-1144.JS.2.0 JS 08FEB2022
                                    TimeSheetLine3.Type := TimeSheetLine3.Type::Job;
                                    TimeSheetLine3."Job No." := TimeSheetCustLine."NS_Job No.";
                                    TimeSheetLine3."Job Task No." := TimeSheetCustLine."NS_Job Task No.";
                                    TimeSheetLine3."NS_Crew code" := TimeSheetCustLine."NS_Crew code";
                                    TimeSheetLine3."NS_Resource No." := TimeSheetCustLine."NS_Resource No.";
                                    TimeSheetLine3."NS_Resource Name New" := TimeSheetCustLine."NS_Resource Name New";
                                    TimeSheetLine3."Total Quantity" := TimeSheetCustLine."NS_Resource Working Hours";
                                    TimeSheetLine3.Status := TimeSheetLine3.Status::Submitted;
                                    TimeSheetLine3.Description := TimeSheetCustLine.NS_Description;  //PRJ-1144.JS.2.0 JS 08FEB2022
                                    TimeSheetLine3.NS_Correction := true;
                                    TimeSheetLine3."NS_Ref Customize TimesheetNo." := TimeSheetCustLine."NS_TimeSheetNo.";
                                    TimeSheetLine3.NS_CrewTimeSheetLine := true;
                                    TimeSheetLine3."NS_Crew Time Unique Line ID" := TimeSheetCustLine."NS_Unique Line ID";
                                    TimeSheetLine3.NS_TimeSheetCrewWorkDays := TimeSheetCustLine.NS_TimeSheetCrewWorkDays;
                                    TimeSheetLine3."NS_Work Type Code" := TimeSheetCustLine."NS_Work Type Code";
                                    TimeSheetLine3."Work Type Code" := TimeSheetCustLine."NS_Work Type Code"; //PE-68.DK.2.0 10july2023
                                    TimeSheetLine3."NS_Crew Time Sheet Ref. No." := TimeSheetCustLine."NS_TimeSheetNo.";
                                    TimeSheetLine3."NS_Crew Time Sheet Date" := TimeSheetCustLine."NS_Working Date";
                                    //PE.68 Dk.1.0 10April2023 Start
                                    TimeSheetLine3."NS_Skill Code New" := TimeSheetCustLine."NS_Skill Code New";
                                    // TimeSheetLine3."NS_Skill Code" := TimeSheetCustLine."NS_Skill Code";
                                    //PE.68 Dk.1.0 10April2023 End
                                    TimeSheetLine3."NS_Union Code" := TimeSheetCustLine."NS_Union Code"; //PRJCTPR-2.RM.1.0 13Dec2022
                                    TimeSheetLine3."NS_Segment Code" := TimeSheetCustLine."NS_Segment Code";
                                    //TimeSheetLine3.Description := CopyStr(WorkDescription, 1, 99);  //PRJ-1144.JS.2.0 JS 08FEB2022
                                    TimeSheetLine3.Modify();
                                    //PRJ-1144.JS.1.0 07Feb2022 Start-Update time sheet details
                                    TSDetail1.Reset();
                                    TSDetail1.SetRange("Time Sheet No.", TimeSheetLine3."Time Sheet No.");
                                    TSDetail1.SetRange("Time Sheet Line No.", TimeSheetLine3."Line No.");
                                    TSDetail1.SetRange("Job No.", TimeSheetLine3."Job No.");
                                    TSDetail1.SetRange("Job Task No.", TimeSheetLine3."Job Task No.");
                                    TSDetail1.SetRange("Resource No.", TimeSheetLine3."NS_Resource No.");
                                    TSDetail1.SetRange(Date, TimeSheetCustLine."NS_Working Date");
                                    if TSDetail1.FindFirst() then begin
                                        TSDetail1."Job No." := TimeSheetLine1."Job No.";
                                        TSDetail1."Job Id" := TimeSheetLine1."Job Id";
                                        TSDetail1."Job Task No." := TimeSheetLine1."Job Task No.";
                                        TSDetail1."Cause of Absence Code" := TimeSheetLine1."Cause of Absence Code";
                                        TSDetail1."Service Order No." := TimeSheetLine1."Service Order No.";
                                        TSDetail1."Service Order Line No." := TimeSheetLine1."Service Order Line No.";
                                        TSDetail1."Assembly Order No." := TimeSheetLine1."Assembly Order No.";
                                        TSDetail1."Assembly Order Line No." := TimeSheetLine1."Assembly Order Line No.";
                                        TSDetail."NS_Crew Time Sheet Line No." := TimeSheetLine1."NS_Crew Time Sheet Line No.";  //PRJ-1144.JS.1.0 06FEB2022
                                                                                                                                 //TSDetail1.validate(Quantity, TimeSheetCustLine3."NS_Working Hours");    //PRJ-924.JS.1.0 17Sep2021-Line Commented
                                        TSDetail1.validate(Quantity, TimeSheetCustLine."NS_Resource Working Hours");    //PRJ-924.JS.1.0 17Sep2021 Line Added
                                                                                                                        //TSDetail1.validate(Quantity, TimeSheetCustLine3."NS_Working Hours");  //PRJ-924.JS.1.0 17Sep2021 Line Commented
                                        TSDetail1."Resource No." := TimeSheetCustLine."NS_Resource No.";
                                        TSDetail1.Status := TimeSheetLine1.Status;
                                        TSDetail1.NS_Description := TimeSheetCustLine.NS_Description;
                                        TSDetail1."NS_Crew Code" := TimeSheetCustLine."NS_Crew code";
                                        TSDetail1."NS_Crew Time Unique Line ID" := TimeSheetCustLine."NS_Unique Line ID";
                                        TSDetail1.NS_TimeSheetCrewWorkDays := TimeSheetCustLine.NS_TimeSheetCrewWorkDays;
                                        TSDetail1."NS_Work Type Code" := TimeSheetCustLine."NS_Work Type Code";
                                        TSDetail1."NS_Crew Time Sheet Ref. No." := TimeSheetCustLine."NS_TimeSheetNo.";
                                        TSDetail1."NS_Crew Time Sheet Date" := TimeSheetCustLine."NS_Working Date";
                                        //PE-68 Dk.1.0 10April2023 Start
                                        // TSDetail1."NS_Skill Code" := TimeSheetCustLine."NS_Skill Code";
                                        TSDetail1."NS_Skill Code New" := TimeSheetCustLine."NS_Skill Code New";
                                        //PE-68 Dk.1.0 10April2023 End
                                        TSDetail1."NS_Segment Code" := TimeSheetCustLine."NS_Segment Code";
                                        TSDetail1."NS_Work Description" := CopyStr(WorkDescription, 1, 99);
                                        TSDetail1.NS_Description := TimeSheetCustLine.NS_Description;  //PRJ-1144.JS.2.0 JS 08FEB2022

                                        TSDetail1.NS_CrewTimeSheetLine := true;
                                        TSDetail1.Modify();
                                        //PRJ-1144.JS.1.0 07Feb2022 end-Update time sheet details
                                    end;
                                    TimeSheetCustLine.NS_Status := TimeSheetCustLine.NS_Status::Submitted;
                                    TimeSheetCustLine.Modify();
                                end;
                            end;
                            //PRJ-1144.JS.1.0 06FEB2022 -start
                            TimeSheetCustLine.NS_Status := TimeSheetCustLine.NS_Status::Submitted;
                            TimeSheetCustLine.Modify();
                        //PRJ-1144.JS.1.0 06FEB2022 -end;
                        until TimeSheetCustLine.Next() = 0;
                    Commit();

                    TimeSheetCustLine3.Reset();
                    TimeSheetCustLine3.SetRange("NS_TimeSheetNo.", TsheetHdrCustom."NS_No.");
                    TimeSheetCustLine3.SetRange(NS_Status, TimeSheetCustLine3.NS_Status::Open);
                    TimeSheetCustLine3.SetRange("NS_LineNo.", TsheetLineNo);//PRJ-1455.RM.1.0
                    //TimeSheetCustLine3.SetRange("NS_Ready To Submit", true); //PRJ-1455.RM.1.0 commented
                    if TimeSheetCustLine3.FindSet() then
                        repeat
                            TimeSheetLine2.Reset();
                            TimeSheetLine2.SetRange("Time Sheet No.", TSHHDROuter."No.");
                            TimeSheetLine2.SetRange("Job No.", TimeSheetCustLine3."NS_Job No.");
                            TimeSheetLine2.SetRange("Job Task No.", TimeSheetCustLine3."NS_Job Task No.");
                            TimeSheetLine2.SetRange("NS_Crew code", TimeSheetCustLine3."NS_Crew code");
                            TimeSheetLine2.SetRange("NS_Resource No.", TimeSheetCustLine3."NS_Resource No.");
                            TimeSheetLine2.SetRange("NS_Crew Time Sheet Line No.", TimeSheetCustLine3."NS_LineNo.");
                            if TimeSheetLine2.FindSet() then
                                repeat
                                    TSDetail.Reset();
                                    TSDetail.SetRange("Time Sheet No.", TimeSheetLine2."Time Sheet No.");
                                    TSDetail.SetRange("Time Sheet Line No.", TimeSheetLine2."Line No.");
                                    TSDetail.SetRange("Job No.", TimeSheetLine2."Job No.");
                                    TSDetail.SetRange("Job Task No.", TimeSheetLine2."Job Task No.");
                                    TSDetail.SetRange("Resource No.", TimeSheetLine2."NS_Resource No.");
                                    TSDetail.SetRange(Date, TimeSheetCustLine3."NS_Working Date");
                                    if NOT TSDetail.FindFirst() then begin
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
                                        TSDetail1.validate(Quantity, TimeSheetCustLine3."NS_Resource Working Hours");
                                        TSDetail1."NS_Crew Time Sheet Line No." := TimeSheetCustLine3."NS_LineNo.";

                                        TSDetail1."Resource No." := TimeSheetCustLine3."NS_Resource No.";
                                        TSDetail1.Status := TimeSheetLine2.Status;
                                        TSDetail1.NS_Description := TimeSheetCustLine3.NS_Description;
                                        TSDetail1."NS_Crew Code" := TimeSheetCustLine3."NS_Crew code";
                                        TSDetail1."NS_Crew Time Unique Line ID" := TimeSheetCustLine3."NS_Unique Line ID";
                                        TSDetail1.NS_TimeSheetCrewWorkDays := TimeSheetCustLine3.NS_TimeSheetCrewWorkDays;
                                        TSDetail1."NS_Work Type Code" := TimeSheetCustLine3."NS_Work Type Code";
                                        TSDetail1."NS_Crew Time Sheet Ref. No." := TimeSheetCustLine3."NS_TimeSheetNo.";
                                        TSDetail1."NS_Crew Time Sheet Date" := TimeSheetCustLine3."NS_Working Date";
                                        //PE-68 Dk.1.0 10April2023 Start
                                        //TSDetail1."NS_Skill Code" := TimeSheetCustLine3."NS_Skill Code";
                                        TSDetail1."NS_Skill Code New" := TimeSheetCustLine3."NS_Skill Code New";
                                        //PE-68 Dk.1.0 10April2023 End
                                        TSDetail1."NS_Segment Code" := TimeSheetCustLine3."NS_Segment Code";
                                        TSDetail1."NS_Work Description" := TimeSheetCustLine3.NS_Description;
                                        TSDetail1.NS_Description := TimeSheetCustLine3.NS_Description;
                                        TSDetail1.NS_CrewTimeSheetLine := true;
                                        if not TSDetail1.Insert() then
                                            TSDetail1.Modify();
                                    end;

                                until TimeSheetLine2.Next() = 0;
                        until TimeSheetCustLine3.Next() = 0;
                    //PRJ-1455.RM.1.0 start
                    if flag then
                        MESSAGE('Crew Time Sheet %1 has been submitted for approval ref. %2', TSHHDRCustomize, TimeSheetHeadNo);  //PRJ-1144.JS.3.0 09FEB2022  
                                                                                                                                  //PRJ-1455.RM.1.0 end
                    Commit();
                    NS_SubmitAllLinesToManagerTimeSheetpg(TimeSheetLine2."Time Sheet No.");
                    TsheetHdrCustom.NS_Status := TsheetHdrCustom.NS_Status::Submitted;
                    TsheetHdrCustom.Modify();
                end;

                //PRJ-1144.JS.1.0 06Feb2022 - end
            end else
                Message('Time sheet no. %1 get already submitted with all lines', TsheetHdrCustom."NS_No.");
        end;

    end;

    //PE-68.AS.1.0 30JUNE2023 END //PRJ-1455.RM.1.0

    //PRJ-772.2.0 -START
    local procedure NS_SubmitAllLinesToManagerTimeSheetpg(TimeSheetCode: Code[20])
    var
        TimeSheetLine_L: record "Time Sheet Line";
        CuTimesheetMgmt: Codeunit "Time Sheet Approval Management";
        TimeSheetCustLine_L: Record NS_TimeSheetLineCustom;
        MgrTimeSheet: Page "Manager Time Sheet";
        TimeSheetLineL1: record "Time Sheet Line";
    begin
        if TimeSheetLine_L."Time Sheet No." <> '' then begin  //PRJ-1144.JS.1.0 06feb2022
            TimeSheetLine_L.Reset();
            TimeSheetLine_L.SetRange("Time Sheet No.", TimeSheetCode);
            TimeSheetLine_L.FilterGroup(2);
            TimeSheetLine_L.SetFilter(Type, '<>%1', TimeSheetLine_L.Type::" ");
            TimeSheetLine_L.FilterGroup(0);
            TimeSheetLine_L.SetFilter(Status, '%1|%2', TimeSheetLine_L.Status::Open, TimeSheetLine_L.Status::Rejected);
            IF TimeSheetLine_L.FINDSET() THEN   //PRJ-1144.JS.1.0 06feb2022
                REPEAT
                    TimeSheetLine_L.CalcFields("Total Quantity");  //PRJ-1144.JS.1.0 06feb2022
                    if TimeSheetLine_L."Total Quantity" <> 0 then  //PRJ-1144.JS.1.0 06feb2022
                        CuTimesheetMgmt.Submit(TimeSheetLine_L);
                until TimeSheetLine_L.Next() = 0;
        end;  //PRJ-1144.JS.1.0 06feb2022

        TimeSheetCustLine_L.Reset();
        //TimeSheetCustLine_L.SetRange("NS_TimeSheetNo.", TimeSheetLine_L."NS_Ref Customize TimesheetNo.");  //PRJ-1144.JS.1.0 06feb2022
        TimeSheetCustLine_L.SetRange("NS_TimeSheetNo.", TimeSheetLine_L."NS_Crew Time Sheet Ref. No.");  //PRJ-1144.JS.1.0 06feb2022
        //PRJ-1144.JS.1.0 06feb2022 - Start
        TimeSheetCustLine_L.SetRange(NS_Status, TimeSheetCustLine_L.NS_Status::Open);
        TimeSheetCustLine_L.SetRange("NS_Ready To Submit", true);
        //PRJ-1144.JS.1.0 06feb2022 - end
        if TimeSheetCustLine_L.FindSet() then
            repeat
                TimeSheetCustLine_L.NS_Status := TimeSheetCustLine_L.NS_Status::Submitted;
                TimeSheetCustLine_L.Modify();
            until TimeSheetCustLine_L.Next() = 0;
    end;
    //PRJ-772.2.0 - END

    //PE-152.JS.1.0 21Aug2023-Start
    /// <summary>
    /// NS_UpdateWorkStartandEndDate.
    /// </summary>
    /// <param name="TimeSheetCode">Code[20].</param>
    /// <param name="NSWorkingDate">date.</param>
    procedure NS_CTSUpdateWorkStartandEndDate(TimeSheetCode: Code[20]; NSWorkingDate: date)
    var
        NSCrewtimeSheetHdr: record NS_TimesheetHdrCustom;
        NSCrewtimeSheetHdr1: record NS_TimesheetHdrCustom;
        NSCrewtimeSheetHdr2: record NS_TimesheetHdrCustom;
        NSCrewTimeSheetLine1: record "NS_TimeSheetLineCustom";
        NSCrewTimeSheetLine2: record "NS_TimeSheetLineCustom";
        NSPeriodStartDate: date;
    begin
        Clear(NSPeriodStartDate);
        if NSWorkingDate <> 0D then begin
            NSCrewTimeSheetLine1.Reset();
            NSCrewTimeSheetLine1.SetCurrentKey("NS_Working Date");
            NSCrewTimeSheetLine1.Setrange("NS_TimeSheetNo.", TimeSheetCode);
            NSCrewTimeSheetLine1.Setfilter("NS_Working Date", '<>%1', 0D);
            if NSCrewTimeSheetLine1.FindFirst() then begin
                if NSCrewtimeSheetHdr.get(NSCrewTimeSheetLine1."NS_TimeSheetNo.") then begin
                    if NSWorkingDate < NSCrewTimeSheetLine1."NS_Working Date" then
                        NSCrewtimeSheetHdr."NS_Work Period Start Date " := NSWorkingDate
                    else
                        NSCrewtimeSheetHdr."NS_Work Period Start Date " := NSCrewTimeSheetLine1."NS_Working Date";
                    NSCrewtimeSheetHdr."NS_Time Sheet Owner User ID" := UserId;
                    NSCrewtimeSheetHdr.modify();
                    NSPeriodStartDate := NSCrewtimeSheetHdr."NS_Work Period Start Date ";
                end;
            end;
            NSCrewTimeSheetLine2.Reset();
            NSCrewTimeSheetLine2.SetCurrentKey("NS_Working Date");
            NSCrewTimeSheetLine2.Setrange("NS_TimeSheetNo.", TimeSheetCode);
            NSCrewTimeSheetLine1.Setfilter("NS_Working Date", '<>%1', 0D);
            if NSCrewTimeSheetLine2.FindLast() then begin
                if NSCrewtimeSheetHdr1.get(NSCrewTimeSheetLine2."NS_TimeSheetNo.") then begin
                    if NSWorkingDate > NSCrewtimeSheetHdr1."NS_Work Period end Date " then
                        NSCrewtimeSheetHdr1."NS_Work Period end Date " := NSWorkingDate
                    else
                        NSCrewtimeSheetHdr1."NS_Work Period end Date " := NSCrewTimeSheetLine2."NS_Working Date";
                    NSCrewtimeSheetHdr1."NS_Time Sheet Owner User ID" := UserId;
                    NSCrewtimeSheetHdr1.NS_TimeSheetCrewWorkDays := NS_CTSGetNumberofDays(NSPeriodStartDate, NSCrewtimeSheetHdr1."NS_Work Period end Date ");
                    NSCrewtimeSheetHdr1.modify();
                end;
            end;
            if NSCrewtimeSheetHdr2.get(TimeSheetCode) then begin
                if NSCrewtimeSheetHdr2.NS_TimeSheetCrewWorkDays = 1 then begin
                    NSCrewtimeSheetHdr2."NS_Work Period Start Date " := NSCrewtimeSheetHdr2."NS_Work Period end Date ";
                    NSCrewtimeSheetHdr2.Modify();
                end;
            end;
        end;
    end;

    local procedure NS_CTSGetNumberofDays(NSStartDate: date; NSEndDate: date) NSTotalDays: integer
    var
        NSStartDate1: date;
    begin
        Clear(NSTotalDays);
        Clear(NSStartDate1);
        NSStartDate1 := NSStartDate;
        if (NSStartDate1 <> 0D) and (NSStartDate <> NSEndDate) then begin
            repeat
                NSTotalDays := NSTotalDays + 1;
                NSStartDate1 := calcdate('+1D', NSStartDate1);
            until NSStartDate1 = NSEndDate;
            if NSTotalDays + 1 > 7 then
                error('Number of days must not be grater than 7 current value is %1', NSTotalDays + 1)
            else
                exit(NSTotalDays + 1);
        end else
            exit(NSTotalDays + 1);
    end;
    //PE-152.JS.1.0 21Aug2023-end  


}