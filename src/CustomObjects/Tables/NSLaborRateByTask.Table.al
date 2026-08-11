table 14021451 "NS_Labor rate by task list"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    //CTSI-95.MS.1.0 create new table

    // +------------------------------------------------------------
    //PRJ-1058.GK.1.0 26Nov2021  Twinoaks  Custmization 

    Caption = 'Labor Rate by task list';
    DrillDownPageId = "NS_Labor rate by task list";
    LookupPageId = "NS_Labor rate by task list";

    fields
    {
        field(1; "NS_Dimension code"; Code[50])
        {
            Caption = 'Dimension code';
            TableRelation = Dimension;
            Dataclassification = CustomerContent;
            trigger OnValidate()
            var
                JobSetup: Record "Jobs Setup";
            begin
                if JobSetup.Get() then;
                if "NS_Dimension code" = JobSetup."NS_Dimension for Labor Rates" then begin

                end else
                    Error('Please select the correct dimension which is defined in job setup');
            end;
        }
        field(2; "NS_Dimension Value code"; Code[50])
        {
            Caption = 'Dimension value code';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("NS_Dimension Code"));
            DataClassification = CustomerContent;
        }
        field(3; "NS_Task Code"; Code[50])
        {
            Caption = 'Task Code';
            TableRelation = "Job Task"."Job Task No.";
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                JobTak: Record "Job Task";
            begin
                JobTak.Reset();
                JobTak.SetRange("Job Task No.", "NS_Task Code");
                if JobTak.FindFirst() then
                    "NS_Task Description" := JobTak.Description;
            end;
        }
        field(4; "NS_Task Description"; Text[100])
        {
            Caption = 'Task Description';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(5; "NS_Labor Rate"; Decimal)
        {
            Caption = 'Labor Rate';
            DataClassification = CustomerContent;
        }
        //PRJ-1058.GK.1.0 26Nov2021 Twinoaks Start
        field(6; "NS_Job Type Code"; Code[10])
        {
            Caption = 'Job Type Code';
            TableRelation = "NS_Job Type";
            DataClassification = CustomerContent;
        }
        //PRJ-1058.GK.1.0 26Nov2021 Twinoaks End
    }

    keys
    {
        key(Key1; "NS_Dimension code", "NS_Dimension Value code", "NS_Task Code")
        {
        }
    }

    fieldgroups
    {
    }
    //CTSI-113-MS.1.0 start
    trigger OnInsert();
    var
        JobSetup: Record "Jobs Setup";
    begin
        if JobSetup.Get() then;
        if "NS_Dimension code" = JobSetup."NS_Dimension for Labor Rates" then begin

        end else
            Error('Please select the correct dimension which is defined in job setup');
    end;

    trigger OnModify()
    var
        JobSetup: Record "Jobs Setup";
    begin
        if JobSetup.Get() then;
        if "NS_Dimension code" = JobSetup."NS_Dimension for Labor Rates" then begin

        end else
            Error('Please select the correct dimension which is defined in job setup');
    end;
    //CTSI-113-MS.1.0 end
}

