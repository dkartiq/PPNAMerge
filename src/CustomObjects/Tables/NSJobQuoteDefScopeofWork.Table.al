table 14021413 "NS_Job Quote Def Scope of Work"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Default Scope of Work';
    DrillDownPageID = "NS_Job Quote Default SOW";
    LookupPageID = "NS_Job Quote Default SOW";

    fields
    {
        field(10; "NS_Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(20; "NS_Code"; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(30; NS_Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(40; "NS_Description 2"; Text[250])
        {
            Caption = 'Description 2';
            DataClassification = CustomerContent;
        }
        field(50; NS_Selected; Boolean)
        {
            Caption = 'Selected';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Entry No.", "NS_Code")
        {
        }
    }

    fieldgroups
    {
    }
}

