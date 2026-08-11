table 14021180 "NS_Vendor Insurance"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Vendor Insurance';
    DrillDownPageID = "NS_Vendor Insurance Types";
    LookupPageID = "NS_Vendor Insurance Types";

    fields
    {
        field(1; "NS_Insurance Type"; Code[10])
        {
            Caption = 'Insurance Type';
            NotBlank = true;
            TableRelation = "NS_Vendor Insurance Type";
            DataClassification = CustomerContent;
        }
        field(2; "NS_Carrier Name"; Text[50])
        {
            Caption = 'Carrier Name';
            DataClassification = CustomerContent;
        }
        field(3; "NS_Policy No."; Text[30])
        {
            Caption = 'Policy No.';
            DataClassification = CustomerContent;
        }
        field(4; NS_Value; Decimal)
        {
            Caption = 'Value';
            DataClassification = CustomerContent;
        }
        field(5; "NS_Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
            DataClassification = CustomerContent;
        }
        field(6; "NS_Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            NotBlank = true;
            TableRelation = Vendor;
            DataClassification = CustomerContent;
        }
        field(7; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Vendor No.", "NS_Insurance Type", "NS_Policy No.")
        {
        }
        key(Key2; "NS_Job No.", "NS_Expiration Date")
        {
        }
    }

    fieldgroups
    {
    }
}

