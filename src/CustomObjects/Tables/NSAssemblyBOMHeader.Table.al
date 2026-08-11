table 14021435 "NS_Assembly BOM Header"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Assembly BOM Header';
    LookupPageID = "NS_Assembly BOM List";

    fields
    {
        field(1; "NS_No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(2; NS_Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;

        }
        field(3; "NS_Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor;
        }
    }

    keys
    {
        key(Key1; "NS_No.")
        {
        }
    }

    fieldgroups
    {
    }
}

