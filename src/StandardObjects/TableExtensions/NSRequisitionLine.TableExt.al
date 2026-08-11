tableextension 14021143 NS_RequisitionLine extends "Requisition Line"
{
    // version NAVW111.00.00.25466,PPNA11.00
    //TM-10.AM.1.0 | Added Field.
    //PRJ-999.JS.1.0 10Nov2021 | Add Procedure
    //PRJ-1380.NK.1.0 12May2022 | Add Fields
    //PRJ-1411.RM.1.0 08June2022 | Added some code 
    fields
    {

        //SPLN: Not in use: Unsupported feature: Change TableRelation on ""No."(Field 5)". Please convert manually.
        //PRJ-999.JS.1.0 19Nov2021 - Start
        modify("Vendor No.")
        {
            trigger OnAfterValidate()
            var
                NS_jobs: Record Job;
                NS_jobTasks: Record "Job Task";
                BillingHeader: Record "NS_Progress Billing Header";
            begin
                if Rec."NS_Job No." <> '' then
                    if NS_jobs.Get(Rec."NS_Job No.") then begin
                        Rec."Shortcut Dimension 1 Code" := NS_jobs."Global Dimension 1 Code";
                        Rec."Shortcut Dimension 2 Code" := NS_jobs."Global Dimension 2 Code";
                        Rec."Dimension Set ID" := rec.GetDimensionNoFromJob(rec."NS_Job No.");
                    end;
                if rec."NS_Job Task No." <> '' then
                    if NS_jobTasks.Get(Rec."NS_Job No.", Rec."NS_Job Task No.") then begin
                        if NS_jobTasks."Global Dimension 1 Code" <> '' then
                            Rec."Shortcut Dimension 1 Code" := NS_jobTasks."Global Dimension 1 Code";
                        if NS_jobTasks."Global Dimension 2 Code" <> '' then
                            Rec."Shortcut Dimension 2 Code" := NS_jobTasks."Global Dimension 2 Code";
                        Rec."Dimension Set ID" := BillingHeader.NS_GetDimensionNoFromJobTask(Rec."NS_Job No.", Rec."NS_Job Task No.");
                    end;
            end;
        }
        //PRJ-999.JS.1.0 19Nov2021 - Start

        field(14021400; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            Description = 'Project Pro';
            DataClassification = CustomerContent;
            //PRJ-999.JS.1.0 10Nov2021 Start
            trigger OnValidate();
            var
                NS_Jobs: Record Job;
            begin
                If "NS_Job No." <> '' then
                    if NS_Jobs.Get(Rec."NS_Job No.") then begin
                        Rec."Shortcut Dimension 1 Code" := NS_Jobs."Global Dimension 1 Code";
                        Rec."Shortcut Dimension 2 Code" := NS_Jobs."Global Dimension 2 Code";
                        Rec."Dimension Set ID" := GetDimensionNoFromJob(Rec."NS_Job No.");
                    end;
            end;
            //PRJ-999.JS.1.0 10Nov2021 end             
        }
        field(14021401; "NS_Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            Description = 'Project Pro';
            DataClassification = CustomerContent;
            //PRJ-999.JS.1.0 12Nov201 Start
            trigger OnValidate();
            var
                JobTask1: Record "Job Task";
            begin
                //PRJ-913.JS.1.0�14Sep2021-Start                        
                if JobTask1.GET(Rec."NS_Job No.", Rec."NS_Job Task No.") then
                    IF ((JobTask1."Global Dimension 1 Code" <> '') and (JobTask1."Global Dimension 2 Code" <> '')) then begin
                        Rec."Shortcut Dimension 1 Code" := JobTask1."Global Dimension 1 Code";
                        Rec."Shortcut Dimension 2 Code" := JobTask1."Global Dimension 2 Code";
                        Rec."Dimension Set ID" := Rec.NS_GetDimensionNoFromJobTask(JobTask1."Job No.", JobTask1."Job Task No.");
                    end;
            end;
            //PRJ-999.JS.1.0 12Nov201 End
        }
        field(14021402; "NS_JMP Document No."; Code[20])
        {
            Caption = 'JMP Document No.';
            Description = 'Project Pro';
            DataClassification = CustomerContent;
        }
        field(14021403; "NS_Job Planning Line No."; Integer)
        {
            Caption = 'Job Planning Line No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021404; "NS_Segment Code"; Code[20])
        {
            Caption = 'Segment Code';
            Description = 'TM-10.AM.1.0';
            TableRelation = "NS_Job Takeoff Segments"."NS_Segment Code" WHERE("NS_Job No." = FIELD("NS_Job No."));
            DataClassification = CustomerContent;
        }
        //PRJ-1380.NK.1.0 12May2022 Start
        field(14021405; "NS_Job Purchaser"; code[20])
        {
            Caption = 'Job Purchaser';
            TableRelation = Resource;
            DataClassification = CustomerContent;
            Description = 'PRJ-1380.NK.1.0';
        }
        field(14021406; "NS_Job Manager"; code[20])
        {
            Caption = 'Job Manager';
            DataClassification = CustomerContent;
            TableRelation = Resource;
            Description = 'PRJ-1380.NK.1.0';
        }
        //PRJ-1380.NK.1.0 12May2022 End
        //PRJ-1411.RM.1.0 start
        field(14021407; "NS_JMP Line No."; Integer)
        {
            caption = 'JMP Line No.';
            description = 'ProjectPro';
            DataClassification = CustomerContent;
            Editable = false;

        }
        //PRJ-1411.RM.1.0 end

        //PRJCTPR-256.JS.1.0 - Start
        field(14021322; "NS_JMP Details"; Text[100])
        {
            Caption = 'JMP Details';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        //PRJCTPR-256.JS.1.0 - end
    }

    //PRJ-999.JS.1.0  10Nov2021 Start
    procedure GetDimensionNoFromJob(JobNo: Code[20]) DimensionNo: Integer;
    var
        DefaultDimension: Record "Default Dimension";
        DimensionSetEntryTemp: Record "Dimension Set Entry" temporary;
        DimensionValue: Record "Dimension Value";
        DimMgt: Codeunit DimensionManagement;
    begin
        DimensionNo := 0;
        with DefaultDimension do begin
            DefaultDimension.RESET();
            DefaultDimension.SETRANGE("Table ID", DATABASE::Job);
            DefaultDimension.SETRANGE("No.", JobNo);
            if DefaultDimension.FINDSET() then
                repeat
                    DimensionValue.RESET();
                    DimensionValue.SETRANGE("Dimension Code", "Dimension Code");
                    DimensionValue.SETRANGE(Code, "Dimension Value Code");
                    if DimensionValue.FINDFIRST() then begin
                        DimensionSetEntryTemp.INIT();
                        DimensionSetEntryTemp."Dimension Code" := DimensionValue."Dimension Code";
                        DimensionSetEntryTemp."Dimension Value ID" := DimensionValue."Dimension Value ID";
                        DimensionSetEntryTemp."Dimension Value Code" := DimensionValue.Code;
                        DimensionSetEntryTemp.INSERT();
                    end;
                until DefaultDimension.NEXT() = 0;
            DimensionNo := DimMgt.GetDimensionSetID(DimensionSetEntryTemp);
        end;
    end;

    procedure NS_GetDimensionNoFromJobTask(JobNo: Code[20]; JobTaskNo: Code[20]) DimensionNo: Integer;
    var
        DimensionSetEntryTemp: Record "Dimension Set Entry" temporary;
        DimensionValue: Record "Dimension Value";
        JobTaskDimension: Record "Job Task Dimension";
        DimMgt: Codeunit DimensionManagement;

    begin
        DimensionNo := 0;
        JobTaskDimension.Reset();
        JobTaskDimension.SetRange("Job No.", JobNo);
        JobTaskDimension.SetRange("Job Task No.", JobTaskNo);
        if JobTaskDimension.FindSet() then
            repeat
                DimensionValue.RESET();
                DimensionValue.SETRANGE("Dimension Code", JobTaskDimension."Dimension Code");
                DimensionValue.SETRANGE(Code, JobTaskDimension."Dimension Value Code");
                if DimensionValue.FINDFIRST() then begin
                    DimensionSetEntryTemp.INIT();
                    DimensionSetEntryTemp."Dimension Code" := DimensionValue."Dimension Code";
                    DimensionSetEntryTemp."Dimension Value ID" := DimensionValue."Dimension Value ID";
                    DimensionSetEntryTemp."Dimension Value Code" := DimensionValue.Code;
                    DimensionSetEntryTemp.INSERT();
                end;
            until JobTaskDimension.NEXT() = 0;
        DimensionNo := DimMgt.GetDimensionSetID(DimensionSetEntryTemp);
    end;

    //PRJ-999.JS.1.0  10Nov2021 end        

}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021400 Job No.
//   +     14021401 Job Task No.
//   +     14021402 JMP Document No.
//   +     14021403 Job Planning Line No.
//   +
//   +  - Added function(s):
//   +
//   +  - Added global variable(s):
//   +
//   +  - Added global text constant(s):
//   +
//   +  - Modification(s):
//   +     - TableRelation
//   +         No.   - Add Type of Resource to TableRelation
//   +     - Fields
//   +         Replenishment System: Test ProdBOMHeader
//   +-----------------------------------------------------------------------------------------------