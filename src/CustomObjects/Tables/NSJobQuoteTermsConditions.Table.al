table 14021416 NS_JobQuoteTermsConditions
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Terms and Conditions';

    fields
    {
        field(1; "NS_Table ID"; Integer)
        {
            Caption = 'Table ID';
            DataClassification = CustomerContent;
        }
        field(12; "NS_Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(41; "NS_Text Value"; Text[250])
        {
            Caption = 'Text Value';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Table ID", "NS_Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

