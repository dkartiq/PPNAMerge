table 14021425 "NS_Export / Import Excel Line"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Export / Import Excel Lines';

    fields
    {
        field(1; "NS_Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; "NS_Table no."; Integer)
        {
            Caption = 'Table no.';
            DataClassification = CustomerContent;
        }
        field(3; "NS_Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(4; "NS_Field No."; Integer)
        {
            Caption = 'Field No.';
            DataClassification = CustomerContent;
            TableRelation = Field."No." WHERE(TableNo = FIELD("NS_Table no."));
        }
        field(5; "NS_Field Name"; Text[30])
        {
            CalcFormula = Lookup(Field.FieldName WHERE(TableNo = FIELD("NS_Table no."),
                                                        "No." = FIELD("NS_Field No.")));
            Caption = 'Field Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "NS_Field Caption"; Text[50])
        {
            CalcFormula = Lookup(Field."Field Caption" WHERE(TableNo = FIELD("NS_Table no."),
                                                              "No." = FIELD("NS_Field No.")));
            Caption = 'Field Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; NS_Type; Option)
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Column,Constant,Auto';
            OptionMembers = Column,Constant,Auto;

            trigger OnValidate();
            begin
                if (NS_Type = NS_Type::Auto) and (NS_Type <> xRec.NS_Type) then
                    NS_Source := '10000';
            end;
        }
        field(8; NS_Source; Text[30])
        {
            Caption = 'Source';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if (NS_Type = NS_Type::Auto) and (NS_Source = '') then
                    ERROR('Source Must Have a Numeric Value When Type is Auto');
            end;
        }
        field(9; NS_Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(10; NS_KeyIndex; Integer)
        {
            BlankZero = true;
            DataClassification = CustomerContent;
            Caption = 'Key index';
            Editable = false;
        }
        field(11; "NS_Field Validate"; Boolean)
        {
            Caption = 'Field Validate';
            DataClassification = CustomerContent;
        }
        field(12; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Code", "NS_Table no.", "NS_Line No.", "NS_Job No.")
        {
        }
        key(Key2; NS_Type, NS_KeyIndex)
        {
        }
    }

    fieldgroups
    {
    }
}

