table 14021376 "NS_Burden Type"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Burden Type';

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
        field(18; "NS_Default Rate Type"; Option)
        {
            Caption = 'Default Rate Type';
            OptionCaption = 'Percentage,Flat Rate';
            OptionMembers = Percentage,"Flat Rate";
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

