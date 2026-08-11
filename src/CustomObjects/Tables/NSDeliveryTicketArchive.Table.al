table 14021222 "NS_Delivery ticket Archive"
{
    //PRJ-1361.AS.1.0 Created New Table

    Caption = 'Delivery ticket Archive';

    fields
    {
        field(1; "NS_Worksheet Job No."; Code[20])
        {
            Caption = 'Worksheet Job No.';
            TableRelation = Job."No.";
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(2; "NS_Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(3; "NS_Document No."; Code[20])
        {
            Caption = 'Document No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(4; "NS_Date Ordered By"; Date)
        {
            Caption = 'Date Ordered By';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(5; "NS_Date Required"; Date)
        {
            Caption = 'Date Required';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(6; "NS_Order Code"; Code[20])
        {
            Caption = 'Order Code';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("NS_Worksheet Job No."));
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(7; NS_Type; Option)
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
            Editable = false;
            OptionCaption = 'Resource,Item,G/L Account,Text,Resource (Group)';
            OptionMembers = Resource,Item,"G/L Account",Text,"Resource (Group)";
        }
        field(8; "NS_Part No."; Code[20])
        {
            Caption = 'Part No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = IF (NS_Type = CONST(Item)) Item."No."
            ELSE
            IF (NS_Type = CONST(Resource)) Resource where("NS_Resource is Purchasable" = const(true));
        }
        field(9; NS_Description; Text[100])
        {
            Caption = 'Description';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(10; NS_Details; Text[100])
        {
            Caption = 'Details';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(11; NS_Manufacturer; Text[50])
        {
            Caption = 'Manufacturer';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(12; NS_Vendor; Code[20])
        {
            Caption = 'Vendor';
            TableRelation = Vendor."No.";
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(13; "NS_Inv. Qty"; Decimal)
        {

            Caption = 'Inv. Qty';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(17; "NS_Bal. Req"; Decimal)
        {
            Caption = 'Bal. Req';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(18; NS_Quantity; Decimal)
        {
            Caption = 'Quantity';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(19; "NS_Job Name"; Text[100])
        {
            Caption = 'Job Name';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(21; "NS_Location Code"; Code[20])
        {
            Caption = 'Location Code';
            TableRelation = Location;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(23; "NS_PO Qty Staged"; Decimal)
        {
            Caption = 'PO Qty Staged';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(25; "NS_Job Description"; Text[100])
        {
            Caption = 'Job Description';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(26; "NS_Customer Account Name"; Text[100])
        {
            Caption = 'Customer Account Name';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(30; "NS_Total Qty. Ready to Ship"; Decimal)
        {
            Caption = 'Total Quantity Ready to Ship';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(31; "NS_Inventory Qty. Staged"; Decimal)
        {
            Caption = 'Inventory Qty. Staged';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(32; "NS_Box Text"; Text[30])
        {
            Caption = 'Box Text';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(33; "NS_PO Qty. to Ship"; Decimal)
        {
            Caption = 'PO Qty. to Ship';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(34; "NS_Invt. Qty. to Ship"; Decimal)
        {
            Caption = 'Invt. Qty. to Ship';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(35; "NS_Total Quantity Staged"; Decimal)
        {
            Caption = 'Total Quantity Staged';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(36; "NS_Posted Quantity"; Decimal)
        {
            Caption = 'Posted Quantity';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(37; "NS_Task Description"; Text[100])
        {
            Caption = 'Task Description';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(38; "NS_Purchase Res. G/L"; Boolean)
        {
            Caption = 'Purchase Res. G/L';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(39; "NS_Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(40; "NS_Total Cost"; Decimal)
        {
            Caption = 'Total Cost';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(41; "NS_Job Plannine Line No."; Integer)
        {
            Caption = 'Job Plannine Line No.';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(45; "NS_Job Purchaser"; Code[20])
        {
            Caption = 'Job Purchaser';
            TableRelation = Resource;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(46; "NS_Segment Code"; Code[20])
        {
            Caption = 'Segment Code';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(47; "NS_Assembly Item on Job."; Code[20])
        {
            Caption = 'Assembly Item on Job';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = IF ("NS_Type" = CONST(Resource)) Resource
            ELSE
            IF ("NS_Type" = CONST(Item)) Item
            ELSE
            IF ("NS_Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("NS_Type" = const(Text)) "Standard Text"
            else
            if ("NS_Type" = CONST("Resource (Group)")) "Resource Group";
        }

        field(48; "NS_Item Name"; Text[50])
        {
            Caption = 'Item Name';
            DataClassification = CustomerContent;
            Editable = false;

        }

        field(49; "NS_Quantity Per"; Decimal)
        {
            Caption = 'Quantity Per';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(50; "NS_Level"; Integer)
        {
            Caption = 'Level';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(51; "NS_Main Item"; Code[20])
        {
            Caption = 'Main Item';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = IF (NS_Type = CONST(Item)) Item."No."
            ELSE
            IF (NS_Type = CONST(Resource)) Resource;
        }
        field(52; "NS_Item Type"; Option)
        {
            Caption = 'Item Type';
            DataClassification = CustomerContent;
            Editable = false;
            OptionCaption = 'Normal,Assembly';
            OptionMembers = Normal,Assembly;
        }

        field(53; "NS_Item Name New"; Text[100])
        {
            Caption = 'Item Name';
            DataClassification = CustomerContent;
            Editable = false;

        }

        field(56; "NS_Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(57; "NS_Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }

        field(58; NS_Revision; Code[20])
        {
            Caption = 'Revision';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(480; "NS_Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
            DataClassification = CustomerContent;
        }

        field(485; "NS_Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Item Variant".Code where("Item No." = field("NS_Part No."));
        }
        field(487; "NS_Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            Editable = false;
            TableRelation = IF (NS_Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("NS_Part No."))
            ELSE
            IF (NS_Type = CONST(Resource)) "Resource Unit of Measure".Code WHERE("Resource No." = FIELD("NS_Part No."))
            ELSE
            "Unit of Measure";
            DataClassification = CustomerContent;
        }

        field(488; "NS_Base UOM"; Code[10])
        {
            Caption = 'Base UOM';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(489; "NS_Base UOM (Qty)"; Decimal)
        {
            Caption = 'Base UOM (Qty)';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "NS_Worksheet Job No.", "NS_Line No.", NS_Revision)
        {
        }

        key(Key2; "NS_Box Text")
        {
        }

        key(Key3; "NS_Worksheet Job No.", NS_Revision)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    var
    begin

    end;

    trigger OnModify();
    var
    begin
    end;

    trigger OnDelete()
    var
    begin
    end;


    var

}

