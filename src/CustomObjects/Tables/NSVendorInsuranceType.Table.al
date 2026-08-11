table 14021179 "NS_Vendor Insurance Type"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Vendor Insurance Type';
    DataCaptionFields = "NS_Code", NS_Description;
    DrillDownPageID = "NS_Vendor Insurance Types";
    LookupPageID = "NS_Vendor Insurance Types";

    fields
    {
        field(1; "NS_Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(2; NS_Description; Text[50])
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

