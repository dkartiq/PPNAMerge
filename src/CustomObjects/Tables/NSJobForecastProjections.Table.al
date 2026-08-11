table 14021188 "NS_Job Forecast Projections"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job Forecast Projections';

    fields
    {
        field(1; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job."No.";
            DataClassification = CustomerContent;
        }
        field(2; "NS_Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            DataClassification = CustomerContent;
        }
        field(6; "NS_Task Manager"; Code[20])
        {
            Caption = 'Task Manager';
            TableRelation = Resource."No." WHERE(Type = CONST(Person));
            DataClassification = CustomerContent;
        }
        field(7; "NS_Projection Date"; Date)
        {
            Caption = 'Projection Date';
            DataClassification = CustomerContent;
        }
        field(10; "NS_Percent Complete"; Decimal)
        {
            Caption = 'Percent Complete';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Job No.", "NS_Job Task No.", "NS_Task Manager", "NS_Projection Date")
        {
        }
        key(Key2; "NS_Task Manager", "NS_Job No.", "NS_Job Task No.", "NS_Projection Date")
        {
        }
    }

    fieldgroups
    {
    }
}

