table 14021409 "NS_Job Quote Default Attribute"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job Quote Default Attribute';
    DrillDownPageID = "NS_Job QuoteDefaultAttributes";
    LookupPageID = "NS_Job QuoteDefaultAttributes";

    fields
    {
        field(1; "NS_Table ID"; Integer)
        {
            Caption = 'Table ID';
            DataClassification = CustomerContent;
        }
        field(11; "NS_No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(21; "NS_Attribute Code"; Code[20])
        {
            Caption = 'Attribute Code';
            TableRelation = "NS_Job Quote Attribute";
            DataClassification = CustomerContent;
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(31; "NS_Value Type"; Option)
        {
            Caption = 'Value Type';
            OptionCaption = 'Text,Boolean,Code,Date,Decimal,Integer';
            OptionMembers = Text,Boolean,"Code",Date,Decimal,"Integer";
            DataClassification = CustomerContent;
        }
        field(41; "NS_Text Value"; Text[50])
        {
            Caption = 'Text Value';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                AttributeMgt.NS_OnValidateTextValueDefaultAttribute(Rec);
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
        field(111; "NS_Table Name"; Text[50])
        {
            CalcFormula = Lookup(AllObj."Object Name" WHERE("Object Type" = CONST(Table),
                                                    "Object ID" = FIELD("NS_Table ID")));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "NS_Table ID", "NS_No.", "NS_Attribute Code")
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
        AttributeMgt.NS_OnInsertDefaultAttribute(Rec);
    end;

    var
        AttributeMgt: Codeunit "NS_Job Quote Mgt.";
}

