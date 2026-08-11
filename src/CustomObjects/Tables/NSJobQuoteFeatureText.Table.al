table 14021412 "NS_Job Quote Feature Text"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Feature Text';
    DrillDownPageID = "NS_Job Quote Feature Text";
    LookupPageID = "NS_Job Quote Feature Text";

    fields
    {
        field(11; "NS_Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            DataClassification = CustomerContent;
        }
        field(12; "NS_Quote Line No."; Integer)
        {
            Caption = 'Quote Line No.';
            DataClassification = CustomerContent;
        }
        field(13; "NS_Line No."; Integer)
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
        key(Key1; "NS_Quote No.", "NS_Quote Line No.", "NS_Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

