table 14021178 "NS_Job Cost Category Price"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    //PRJ-295.MS.1.0 changes flow field value
    // +------------------------------------------------------------

    Caption = 'Job Cost Category Price';

    fields
    {
        field(1; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job."No.";
            DataClassification = CustomerContent;
        }
        field(2; "NS_Cost Category Code"; Code[10])
        {
            Caption = 'Cost Category Code';
            TableRelation = "NS_Job Cost Category".NS_Code;
            DataClassification = CustomerContent;
        }
        field(3; NS_Description; Text[30])
        {
            //CalcFormula = Lookup ("NS_Job Cost Category".NS_Code WHERE(NS_Code = FIELD("NS_Cost Category Code")));//PRJ-295.MS.1.0 comment
            CalcFormula = Lookup("NS_Job Cost Category".NS_Description WHERE(NS_Code = FIELD("NS_Cost Category Code")));//PRJ-295.MS.1.0
            Caption = 'Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "NS_Unit Cost Factor"; Decimal)
        {
            Caption = 'Unit Cost Factor';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                "NS_Markup %" := (1 - "NS_Unit Cost Factor") * 100;
            end;
        }
        field(5; "NS_Markup %"; Decimal)
        {
            Caption = 'Markup %';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                "NS_Unit Cost Factor" := 1 + "NS_Markup %" / 100;
            end;
        }
    }

    keys
    {
        key(Key1; "NS_Job No.", "NS_Cost Category Code")
        {
        }
    }

    fieldgroups
    {
    }
}

