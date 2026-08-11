table 14021162 "NS_Retention Ledger Code"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Retention Ledger Code';
    DrillDownPageID = "NS_Retention Ledger Code List";
    LookupPageID = "NS_Retention Ledger Code List";

    fields
    {
        field(1; "NS_Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; NS_Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Code")
        {
        }
    }

    fieldgroups
    {
    }
}

