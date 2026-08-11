table 14021418 "NS_Job Quote Price Entry"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    //SMPL - Replaced DimensionManagement named reference to ID (symbols bug)

    Caption = 'Price Entry';

    fields
    {
        field(1; "NS_Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(40; "NS_Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate();
            begin
                NS_ValidateShortcutDimCode(1, "NS_Shortcut Dimension 1 Code");
            end;
        }
        field(41; "NS_Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate();
            begin
                NS_ValidateShortcutDimCode(2, "NS_Shortcut Dimension 2 Code");
            end;
        }
        field(91; "NS_Post Code"; Code[20])
        {
            Caption = 'ZIP Code';
            TableRelation = "Post Code";
            DataClassification = CustomerContent;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(100; "NS_Entity Type"; Option)
        {
            Caption = 'Entity Type';
            Description = 'JFA0003';
            DataClassification = CustomerContent;
            OptionCaption = 'Customer,Customer Price Group,Customer Posting Group,Service Contract No.';
            OptionMembers = Customer,"Customer Price Group","Customer Posting Group","Service Contract No.";

            trigger OnValidate();
            begin
                if "NS_Entity Type" <> xRec."NS_Entity Type" then begin
                    PriceMgt.NS_InitializeEntityFields(Rec);
                    "NS_Entity No." := '';
                end;
            end;
        }
        field(106; "NS_Entity No."; Code[20])
        {
            Caption = 'Entity No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("NS_Entity Type" = CONST(Customer)) Customer."No."
            ELSE
            IF ("NS_Entity Type" = CONST("Customer Price Group")) "Customer Price Group".Code
            ELSE
            IF ("NS_Entity Type" = CONST("Customer Posting Group")) "Customer Posting Group".Code
            ELSE
            IF ("NS_Entity Type" = CONST("Service Contract No.")) "Service Contract Header"."Contract No." WHERE("Contract Type" = CONST(Contract));

            trigger OnValidate();
            begin
                PriceMgt.NS_OnValidateEntityNo(Rec);
            end;
        }
        field(480; "NS_Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            DataClassification = CustomerContent;
        }
        field(1001; "NS_Entity Name"; Text[50])
        {
            Caption = 'Entity Name';
            DataClassification = CustomerContent;
        }
        field(3001; NS_Type; Option)
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
            OptionCaption = ' ,,Item,Resource,Cost,,,,,,,,,,,,,Item Discount Group,Resource Group';
            OptionMembers = " ",,Item,Resource,Cost,,,,,,,,,,,,,"Item Discount Group","Resource Group";

            trigger OnValidate();
            begin
                if NS_Type <> xRec.NS_Type then begin
                    PriceMgt.NS_InitializeNoFields(Rec);
                    "NS_No." := '';
                end;
            end;
        }
        field(3006; "NS_No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            TableRelation = IF (NS_Type = CONST(Item)) Item
            ELSE
            IF (NS_Type = CONST(Resource)) Resource
            ELSE
            IF (NS_Type = CONST(Cost)) "Service Cost"
            ELSE
            IF (NS_Type = CONST("Item Discount Group")) "Item Discount Group"
            ELSE
            IF (NS_Type = CONST("Resource Group")) "Resource Group";

            trigger OnValidate();
            begin
                PriceMgt.NS_OnValidateNo(Rec);
            end;
        }
        field(3007; "NS_No. 2"; Code[30])
        {
            Caption = 'No. 2';
            DataClassification = CustomerContent;
        }
        field(3008; "NS_Work Type"; Code[10])
        {
            Caption = 'Work Type';
            Description = 'JFA0003';
            TableRelation = "Work Type".Code;
            ValidateTableRelation = true;
            DataClassification = CustomerContent;
        }
        field(3011; NS_Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3021; "NS_Minimum Quantity"; Decimal)
        {
            Caption = 'Minimum Quantity';
            DataClassification = CustomerContent;
        }
        field(3026; "NS_Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = CustomerContent;
            TableRelation = IF (NS_Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("NS_No."))
            ELSE
            IF (NS_Type = CONST(Resource)) "Resource Unit of Measure".Code WHERE("Resource No." = FIELD("NS_No."))
            ELSE
            IF (NS_Type = CONST(Cost)) "Unit of Measure".Code
            ELSE
            IF (NS_Type = CONST("Resource Group")) "Resource Unit of Measure".Code;
        }
        field(3151; "NS_Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            DataClassification = CustomerContent;
            TableRelation = IF (NS_Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("NS_No."));
        }
        field(3301; NS_Method; Option)
        {
            Caption = 'Method';
            DataClassification = CustomerContent;
            OptionCaption = 'Markup,Discount,Fixed';
            OptionMembers = Markup,Discount,"Fixed";
        }
        field(3306; "NS_Method Value"; Decimal)
        {
            Caption = 'Method Value';
            DataClassification = CustomerContent;
        }
        field(3311; "NS_Vendor Discount"; Decimal)
        {
            Caption = 'Vendor Discount';
            DataClassification = CustomerContent;
        }
        field(3351; "NS_Effective Date"; Date)
        {
            Caption = 'Effective Date';
            DataClassification = CustomerContent;
        }
        field(3356; "NS_Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
            DataClassification = CustomerContent;
        }
        field(3381; NS_Comment; Text[250])
        {
            Caption = 'Comment';
            DataClassification = CustomerContent;
        }
        field(5001; "NS_Created by"; Code[50])
        {
            Caption = 'Created by';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(5002; "NS_Created at Date"; Date)
        {
            Caption = 'Created at Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(5003; "NS_Created at Time"; Time)
        {
            Caption = 'Created at Time';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(5011; "NS_Modified by"; Code[50])
        {
            Caption = 'Modified by';
            Editable = false;
            TableRelation = User;
            DataClassification = CustomerContent;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(5012; "NS_Modified at Date"; Date)
        {
            Caption = 'Modified at Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(5013; "NS_Modified at Time"; Time)
        {
            Caption = 'Modified at Time';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(5701; "NS_Manufacturer Code"; Code[10])
        {
            Caption = 'Manufacturer Code';
            TableRelation = Manufacturer;
            DataClassification = CustomerContent;
        }
        field(5709; "NS_Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
            DataClassification = CustomerContent;
        }
        field(5712; "NS_Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            DataClassification = CustomerContent;
            //TableRelation = "Product Group".Code WHERE("Item Category Code" = FIELD("NS_Item Category Code"));  //PRJCTPR-155.JS.1.0 09SEP2023 line commented
            TableRelation = "Item Category".Code WHERE(Code = FIELD("NS_Item Category Code")); //PRJCTPR-155.JS.1.0 09SEP2023 line added
        }
        field(5903; "NS_Service Order Type Code"; Code[10])
        {
            Caption = 'Service Order Type Code';
            TableRelation = "Service Order Type";
            DataClassification = CustomerContent;
        }
        field(5957; "NS_Service Zone Code"; Code[10])
        {
            Caption = 'Service Zone Code';
            TableRelation = "Service Zone";
            DataClassification = CustomerContent;
        }
        field(6080; "NS_Service Price Group Code"; Code[10])
        {
            Caption = 'Service Price Group Code';
            TableRelation = "Service Price Group";
            DataClassification = CustomerContent;
        }
        field(7000; "NS_County Name"; Code[30])
        {
            Caption = 'County Name';
            Description = 'JFA0004';
            TableRelation = "Ship-to Address".County;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Entry No.")
        {
        }
        key(Key2; "NS_Entity Type", "NS_Entity No.", NS_Type, "NS_No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        "NS_Created by" := USERID[50];
        "NS_Created at Date" := TODAY;
        "NS_Created at Time" := TIME;
    end;

    trigger OnModify();
    begin
        "NS_Modified by" := USERID[50];
        "NS_Modified at Date" := TODAY;
        "NS_Modified at Time" := TIME;
    end;

    var
        PriceMgt: Codeunit "NS_Job Quote Price Mgt.";

    procedure NS_ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    var
        _DimMgt: Codeunit 408;
    // _DimSetEntryID: Integer;
    begin
        _DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "NS_Dimension Set ID");
    end;
}

