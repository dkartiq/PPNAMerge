table 14021410 "NS_Job Quote Attribute Set Ent"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Attribute Set Entry';
    DrillDownPageID = "NS_Job Quote Attribute Set Ent";
    LookupPageID = "NS_Job Quote Attribute Set Ent";

    fields
    {
        field(1; "NS_Attribute Set ID"; Integer)
        {
            Caption = 'Attribute Set ID';
            DataClassification = CustomerContent;
        }
        field(21; "NS_Attribute Code"; Code[20])
        {
            Caption = 'Attribute Code';
            DataClassification = CustomerContent;
            TableRelation = "NS_Job Quote Attribute";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(31; "NS_Value Type"; Option)
        {
            Caption = 'Value Type';
            Editable = false;
            DataClassification = CustomerContent;
            OptionCaption = 'Text,Boolean,Code,Date,Decimal,Integer';
            OptionMembers = Text,Boolean,"Code",Date,Decimal,"Integer";
        }
        field(41; "NS_Text Value"; Text[50])
        {
            Caption = 'Text Value';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                AttributeMgt.NS_OnValidateTextValueAttributeSetEntry(Rec);
            end;
        }
        field(51; "NS_Boolean Value"; Boolean)
        {
            Caption = 'Boolean Value';
            DataClassification = CustomerContent;
        }
        field(61; "NS_Code Value"; Code[20])
        {
            Caption = 'Code Value';
            DataClassification = CustomerContent;
        }
        field(71; "NS_Date Value"; Date)
        {
            Caption = 'Date Value';
            DataClassification = CustomerContent;
        }
        field(81; "NS_Decimal Value"; Decimal)
        {
            Caption = 'Decimal Value';
            DataClassification = CustomerContent;
        }
        field(91; "NS_Integer Value"; Integer)
        {
            Caption = 'Integer Value';
            DataClassification = CustomerContent;
        }
        field(101; NS_Description; Text[80])
        {
            CalcFormula = Lookup("NS_Job Quote Attribute".NS_Description WHERE(NS_Code = FIELD("NS_Attribute Code")));
            Caption = 'Description';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "NS_Attribute Set ID", "NS_Attribute Code")
        {
        }
        key(Key2; "NS_Attribute Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        AttributeMgt.NS_OnInsertAttributeSetEntry(Rec);
    end;

    var
        AttributeMgt: Codeunit "NS_Job Quote Mgt.";
}

