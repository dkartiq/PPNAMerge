table 14021495 "NS_Assembley BOM Components"
{
    //PRJ-563.AS.1.0 19MARCH2021 New Table created
    //PRJ-563.AS.4.0 23JUN2021 Unit cost field added
    Caption = 'Assembley BOM Components';

    fields
    {
        field(1; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            Editable = false;
            NotBlank = TRUE;
            TableRelation = Job."No.";
            DataClassification = CustomerContent;

        }
        field(2; "NS_Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            Editable = false;
            NotBlank = TRUE;
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("NS_Job No."));
            DataClassification = CustomerContent;
        }
        field(3; "NS_Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(4; NS_Type; Option)
        {
            Caption = 'Type';
            Editable = true;
            OptionCaption = 'Resource,Item,G/L Account,Text,Resource (Group)';
            OptionMembers = Resource,Item,"G/L Account",Text,"Resource (Group)";
            DataClassification = CustomerContent;

        }
        field(5; "NS_No."; Code[20])
        {
            Caption = 'No.';
            Editable = true;
            DataClassification = CustomerContent;
            TableRelation = IF ("NS_Type" = CONST(Resource)) Resource
            ELSE
            IF ("NS_Type" = CONST(Item)) Item
            ELSE
            IF ("NS_Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("NS_Type" = const(Text)) "Standard Text"
            else
            if ("NS_Type" = CONST("Resource (Group)")) "Resource Group";

            trigger OnValidate();
            var
                ResourceRec: Record Resource;
                ItemRec: Record Item;
                GLAccRec: Record "G/L Account";
                StandardtextRec: Record "Standard Text";
                ResourceGrpRec: Record "Resource Group";
                JPL: Record "Job Planning Line";
            begin
                if ResourceRec.get(rec."NS_No.") then
                    // NS_Description := ResourceRec.Name;//PRJ-838 COMMENT
                     "NS_Description New" := ResourceRec.Name;//PRJ-838 ADD
                if ItemRec.get(Rec."NS_No.") then
                    // NS_Description := ItemRec.Description;//PRJ-838 COMMENT
                     "NS_Description New" := ItemRec.Description;//PRJ-838 ADD
                if GLAccRec.get(Rec."NS_No.") then
                    // NS_Description := GLAccRec.Name;//PRJ-838 COMMENT
                    "NS_Description New" := GLAccRec.Name;//PRJ-838 ADD
                if StandardtextRec.get(Rec."NS_No.") then
                    // NS_Description := StandardtextRec.Description;//PRJ-838 COMMENT
                    "NS_Description New" := StandardtextRec.Description;//PRJ-838 ADD
                if ResourceGrpRec.get(Rec."NS_No.") then
                    // NS_Description := ResourceGrpRec.Name;
                    "NS_Description New" := ResourceGrpRec.Name;

                if ItemRec.get(Rec."NS_No.") then begin
                    ItemRec.CalcFields("Assembly BOM");
                    "NS_Assembly BOM" := ItemRec."Assembly BOM";
                    "NS_Unit Cost" := ItemRec."Unit Cost";//PRJ-563.AS.4.0 23JUN2021
                end;

                if ResourceRec.get(rec."NS_No.") then begin
                    "NS_Unit of Measure Code" := ResourceRec."Base Unit of Measure";
                    "NS_Unit Cost" := ResourceRec."Unit Cost";//PRJ-563.AS.4.0 23JUN2021
                end;
            end;
        }
        field(6; NS_Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            Editable = false;


            trigger OnValidate();
            begin
            end;

        }
        field(7; "NS_Quantity Per"; Decimal)
        {
            Caption = 'Quantity Per';
            DataClassification = CustomerContent;
            trigger OnValidate();
            begin
                "NS_Expected Quantity" := "NS_Quantity Per" * "NS_Quantity of Assembly Item on Job";
            end;
        }
        field(8; "NS_Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = CustomerContent;
            Editable = FALSE;
            TableRelation = IF ("NS_Type" = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("NS_No."))
            ELSE
            IF ("NS_Type" = CONST(Resource)) "Resource Unit of Measure".Code WHERE("Resource No." = FIELD("NS_No."))
            ELSE
            "Unit of Measure";
        }
        field(9; "NS_Quantity of Assembly Item on Job"; Decimal)
        {
            Caption = 'Parent Item';
            Editable = false;//PRJ-563.AS.2.0
            DataClassification = CustomerContent;

            trigger OnValidate();
            Var //PRJ-563.AS.2.0
                AssemBOMRec: Record "NS_Assembley BOM Components";//PRJ-563.AS.2.0
            begin
                "NS_Expected Quantity" := "NS_Quantity Per" * "NS_Quantity of Assembly Item on Job";
            end;
        }
        field(10; "NS_Expected Quantity"; Decimal)
        {
            Caption = 'Expected Quantity';
            Editable = FALSE;
            DataClassification = CustomerContent;
        }
        field(12; "NS_Ref. JPL Line No."; integer)
        {
            Caption = 'Ref. JPL Line No.';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(13; "NS_Ref. ASMBOM Line No."; integer)
        {
            Caption = 'Ref. AMBOM Line No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14; "NS_Ref. JPL Parent Item No."; Code[20])
        {
            Caption = 'Ref. ASMBOM Parent Item No.';
            TableRelation = Item."No.";
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(15; "NS_Assembly BOM"; Boolean)
        {
            Caption = 'Assembly BOM';
            // FieldClass = FlowField;
            // CalcFormula = Exist("BOM Component" WHERE("Parent Item No." = FIELD("NS_No.")));
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(16; "NS_JPL DocNo"; code[20])
        {
            Caption = 'JPL DocNo';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(17; "NS_Level"; Integer)//PRJ-563.AS.1.0 24MAY2020 
        {
            Caption = 'Level';
            DataClassification = CustomerContent;
            trigger OnValidate();
            begin
            end;
        }
        field(18; "NS_Main Item"; Code[20])//PRJ-563.AS.1.0 24MAY2020
        {
            Caption = 'Main Item';
            DataClassification = CustomerContent;
            TableRelation = IF ("NS_Type" = CONST(Resource)) Resource
            ELSE
            IF ("NS_Type" = CONST(Item)) Item
            ELSE
            IF ("NS_Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("NS_Type" = const(Text)) "Standard Text"
            else
            if ("NS_Type" = CONST("Resource (Group)")) "Resource Group";

            trigger OnValidate();
            var
            begin

            end;
        }
        field(19; "NS_Item Type"; Option)//PRJ-563.AS.1.0 24MAY2020
        {
            Caption = 'Item Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Normal,Assembly';
            OptionMembers = Normal,Assembly;
        }

        field(20; "NS_Unit Cost"; Decimal)//PRJ-563.AS.4.0 23JUN2021
        {
            Caption = 'Unit Cost';
            DataClassification = CustomerContent;
        }
        field(21; "NS_Description New"; Text[100])//PRJ-838
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            Editable = false;

            trigger OnValidate();
            begin
            end;

        }
        field(22; "NS_SourceASMBOMLineNo."; Integer)//prj-1616
        {
            Caption = 'NS_SourceASMBOMLineNo';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "NS_Job No.", "NS_Job Task No.", "NS_Line No.")
        {
        }
        // key(key2; "NS_Job No.", "NS_Job Task No.", "NS_Ref. JPL Line No.", "NS_Ref. JPL Parent Item No.")//PRJ-1224.AS.1.0 Addded key
        // {
        // }
    }

    trigger OnModify()
    var
        JPL: Record "Job Planning Line";
    begin
        if (Rec.NS_Type = Rec.NS_Type::Item) and (Rec."NS_No." <> '') then begin
            JPL.reset;
            JPL.setrange("Job No.", rec."NS_Job No.");
            JPL.SetRange("Job Task No.", Rec."NS_Job Task No.");
            JPL.SetRange("Line No.", Rec."NS_Ref. JPL Line No.");
            JPL.SetRange(Type, JPL.Type::Item);
            JPL.SetRange("No.", Rec."NS_Ref. JPL Parent Item No.");
            if JPL.FindFirst then begin
                Rec."NS_Quantity of Assembly Item on Job" := JPL.Quantity;
            end;
        end;
    end;

    trigger OnInsert()
    var
        JPL: Record "Job Planning Line";
    begin
        if (Rec.NS_Type = Rec.NS_Type::Item) and (Rec."NS_No." <> '') then begin
            JPL.reset;
            JPL.setrange("Job No.", rec."NS_Job No.");
            JPL.SetRange("Job Task No.", Rec."NS_Job Task No.");
            JPL.SetRange("Line No.", Rec."NS_Ref. JPL Line No.");
            JPL.SetRange(Type, JPL.Type::Item);
            JPL.SetRange("No.", Rec."NS_Ref. JPL Parent Item No.");
            if JPL.FindFirst then begin
                Rec."NS_Quantity of Assembly Item on Job" := JPL.Quantity;
                Rec.Modify();
            end;
        end;
    end;


}