table 14021408 "NS_Job Quote Attribute"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Attribute';
    DrillDownPageID = "NS_Job Quote Attributes";
    LookupPageID = "NS_Job Quote Attributes";

    fields
    {
        field(21; "NS_Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(31; "NS_Value Type"; Option)
        {
            Caption = 'Value Type';
            OptionCaption = 'Text,Boolean,Code,Date,Decimal,Integer';
            OptionMembers = Text,Boolean,"Code",Date,Decimal,"Integer";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                AttributeMgt.NS_OnValidateValueTypeAttribute(Rec);
            end;
        }
        field(101; NS_Description; Text[80])
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

    var
        AttributeMgt: Codeunit "NS_Job Quote Mgt.";
}

