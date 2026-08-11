table 14021436 "NS_Assembly BOM Line"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Assembly BOM Line';

    fields
    {
        field(1; NS_Type; Option)
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Item,Resource,BOM';
            OptionMembers = Item,Resource,BOM;
        }
        field(2; "NS_Assemby BOM No."; Code[20])
        {
            Caption = 'Assemby BOM No.';
            DataClassification = CustomerContent;
            TableRelation = "NS_Assembly BOM Header"."NS_No.";
        }
        field(3; "NS_Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(4; "NS_No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            TableRelation = IF (NS_Type = CONST(Item)) Item WHERE(Type = CONST(Inventory))
            ELSE
            IF (NS_Type = CONST(Resource)) Resource
            ELSE
            IF (NS_Type = CONST(BOM)) "NS_Assembly BOM Header";
            ValidateTableRelation = false;

            trigger OnValidate();
            var
                Item: Record Item;
                Res: Record Resource;
                BOMHeader: Record "NS_Assembly BOM Header";
            begin
                if "NS_No." = '' then
                    exit;

                case NS_Type of
                    NS_Type::Item:
                        begin
                            Item.GET("NS_No.");
                            NS_Description := Item.Description;
                            "NS_Unit of Measure Code" := Item."Base Unit of Measure";
                        end;
                    NS_Type::Resource:
                        begin
                            Res.GET("NS_No.");
                            NS_Description := Res.Name;
                            "NS_Unit of Measure Code" := Res."Base Unit of Measure";
                        end;
                    NS_Type::BOM:
                        begin
                            NS_ValidateAgainstRecursion("NS_No.");
                            BOMHeader.GET("NS_No.");
                            NS_Description := BOMHeader.NS_Description;
                        end;
                end;
            end;
        }
        field(5; NS_Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(6; "NS_Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = CustomerContent;
            TableRelation = IF (NS_Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("NS_No."))
            ELSE
            IF (NS_Type = CONST(Resource)) "Resource Unit of Measure".Code WHERE("Resource No." = FIELD("NS_No."));
        }
        field(7; "NS_Quantity per"; Decimal)
        {
            Caption = 'Quantity per';
            DataClassification = CustomerContent;
        }
        field(8; "NS_Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; NS_Type, "NS_Assemby BOM No.", "NS_Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        if NS_Type = NS_Type::BOM then
            NS_ValidateAgainstRecursion("NS_No.");
    end;

    trigger OnModify();
    begin
        if NS_Type = NS_Type::BOM then
            NS_ValidateAgainstRecursion("NS_No.");
    end;

    trigger OnRename();
    begin
        if NS_Type = NS_Type::BOM then
            NS_ValidateAgainstRecursion("NS_No.");
    end;

    var
        Text001Lbl: Label 'You cannot insert BOM %1 as an assembly component of itself.', Comment = '%1=No';

    [Scope('Cloud')]
    procedure NS_ValidateAgainstRecursion(No: Code[20]);
    var
        BOMHeader: Record "NS_Assembly BOM Header";
    begin
        if "NS_Assemby BOM No." = No then
            ERROR(Text001Lbl, No);

        if NS_Type = NS_Type::BOM then begin
            BOMHeader.SETRANGE("NS_No.", "NS_Assemby BOM No.");
            if BOMHeader.FINDSET() then
                repeat

                until BOMHeader.NEXT() = 0;
        end
    end;
}

