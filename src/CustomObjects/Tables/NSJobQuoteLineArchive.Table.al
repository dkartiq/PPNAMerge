table 14021423 "NS_Job Quote Line Archive"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    //PRJ-301.MS.1.0 change length from 50 to 100
    // +------------------------------------------------------------

    Caption = 'Quote Line';

    fields
    {
        field(11; "NS_Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            DataClassification = CustomerContent;
        }
        field(12; "NS_Quote Line No."; Integer)
        {
            Caption = 'Quote Line No.';
            DataClassification = CustomerContent;
        }
        field(18; "NS_Attached to Line No."; Integer)
        {
            Caption = 'Attached to Line No.';
            DataClassification = CustomerContent;
        }
        field(21; NS_Revision; Integer)
        {
            Caption = 'Revision';
            DataClassification = CustomerContent;
        }
        field(40; "NS_Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(41; "NS_Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(108; "NS_Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
            DataClassification = CustomerContent;
        }
        field(109; "NS_Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
            DataClassification = CustomerContent;
        }
        field(111; "NS_Address No."; Code[20])
        {
            Caption = 'Address No.';
            TableRelation = "Ship-to Address".Code;
            DataClassification = CustomerContent;
        }
        field(112; "NS_Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
            DataClassification = CustomerContent;
        }
        field(301; "NS_Sales Quote No."; Code[20])
        {
            Caption = 'Sales Quote No.';
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST(Quote));
            DataClassification = CustomerContent;
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(302; "NS_Sales Quote Line No."; Integer)
        {
            Caption = 'Sales Quote Line No.';
            DataClassification = CustomerContent;
        }
        field(480; "NS_Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
            DataClassification = CustomerContent;
        }
        field(1000; "NS_Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(3001; NS_Type; Option)
        {
            Caption = 'Type';
            InitValue = Item;
            OptionCaption = '" ,G/L Account,Item,Resource,Task,Package"';
            OptionMembers = " ","G/L Account",Item,Resource,Task,Template;
            DataClassification = CustomerContent;
        }
        field(3006; "NS_No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            TableRelation = IF (NS_Type = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (NS_Type = CONST(Item)) Item
            ELSE
            IF (NS_Type = CONST(Resource)) Resource;

            trigger OnLookup();
            var
            // ItemList: Page "Item List";
            // FixedAsset: Record "Fixed Asset";
            // StdText: Record "Standard Text";
            // ChargeItem: Record "Item Charge";
            // GLList: Page "G/L Account List";
            // ResourceList: Page "Resource List";
            // AssetList: Page "Fixed Asset List";
            // StdList: Page "Standard Text Codes";
            // ChargeList: Page "Item Charges";
            // SalesLine: Record "Sales Line";
            // JobSegment: Record "Job Takeoff Segments";
            // JobSegList: Page "Job Takeoff Seg. Tmpl. List";
            // JobList: Page "Job List";
            // JobTaskList: Page "Job Quote Operation List";
            begin
            end;

            trigger OnValidate();
            var
            // lJobPlanLine: Record "Job Planning Line";
            // MFGCode: Code[10];
            // ItemUoM: Code[10];
            // VendorNo: Code[20];
            // UnitCost: Decimal;
            // UnitPrice: Decimal;
            // QtyUoM: Decimal;
            // ResUoM: Code[10];
            // TaskCode: Code[20];
            begin
            end;
        }
        field(3007; "NS_No. 2"; Code[30])
        {
            Caption = 'No. 2';
            DataClassification = CustomerContent;
        }
        field(3011; NS_Description; Text[100])//PRJ-301.MS.1.0
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3021; NS_Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }
        field(3022; "NS_Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DataClassification = CustomerContent;
        }
        field(3026; "NS_Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = CustomerContent;
            TableRelation = IF (NS_Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("NS_No."))
            ELSE
            IF (NS_Type = CONST(Resource)) "Resource Unit of Measure".Code WHERE("Resource No." = FIELD("NS_No."));
        }
        field(3027; "NS_Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DataClassification = CustomerContent;
        }
        field(3041; "NS_Category Code"; Code[10])
        {
            Caption = 'Category Code';
            DataClassification = CustomerContent;
            TableRelation = "Item Category";
        }
        field(3051; "NS_Attribute Set Entry No."; Integer)
        {
            Caption = 'Attribute Set Entry No.';
            DataClassification = CustomerContent;
        }
        field(3091; "NS_Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            DataClassification = CustomerContent;
        }
        field(3092; "NS_Total Cost"; Decimal)
        {
            Caption = 'Total Cost';
            DataClassification = CustomerContent;
        }
        field(3094; "NS_Use Tax SKU"; Code[20])
        {
            Caption = 'Use Tax SKU';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(3096; "NS_Use Tax Amount"; Decimal)
        {
            Caption = 'Use Tax Amount';
            DataClassification = CustomerContent;
        }
        field(3097; "NS_Sales Tax Amount"; Decimal)
        {
            Caption = 'Sales Tax Amount';
            DataClassification = CustomerContent;
        }
        field(3101; "NS_Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = CustomerContent;
        }
        field(3103; "NS_Item List Price"; Decimal)
        {
            CalcFormula = Lookup(Item."Unit Price" WHERE("No." = FIELD("NS_No.")));
            Caption = 'Item List Price';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3104; "NS_Contract Price Found"; Boolean)
        {
            Caption = 'Contract Price Found';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(3106; "NS_Total Price"; Decimal)
        {
            Caption = 'Total Price';
            DataClassification = CustomerContent;
        }
        field(3121; NS_Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(3122; "NS_Amount Including VAT"; Decimal)
        {
            Caption = 'Amount Including Tax';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(3131; NS_Markup; Decimal)
        {
            Caption = 'Markup';
            DataClassification = CustomerContent;
        }
        field(3136; "NS_Line Discount Amount"; Decimal)
        {
            Caption = 'Line Discount Amount';
            DataClassification = CustomerContent;
        }
        field(3137; "NS_Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DataClassification = CustomerContent;
        }
        field(3138; "NS_Gross Margin %"; Decimal)
        {
            Caption = 'Gross Margin %';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(3139; "NS_Gross Margin"; Decimal)
        {
            Caption = 'Gross Margin';
            DataClassification = CustomerContent;
        }
        field(3151; "NS_Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            DataClassification = CustomerContent;
            TableRelation = IF (NS_Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("NS_No."));
        }
        field(3201; "NS_Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            DataClassification = CustomerContent;
        }
        field(3202; "NS_Vendor Name"; Text[100])//PRJ-301.MS.1.0
        {
            Caption = 'Vendor Name';
            DataClassification = CustomerContent;
        }
        field(3203; "NS_Vendor Contact"; Text[100])//PRJ-301.MS.1.0
        {
            Caption = 'Vendor Contact';
            DataClassification = CustomerContent;
        }
        field(3204; "NS_Vendor Contact No."; Code[20])
        {
            Caption = 'Vendor Contact No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Contact;
        }
        field(3211; "NS_Vendor Quote No."; Text[30])
        {
            Caption = 'Vendor Quote No.';
            DataClassification = CustomerContent;
        }
        field(3221; "NS_Vendor Cost"; Decimal)
        {
            Caption = 'Vendor Cost';
            DataClassification = CustomerContent;
        }
        field(3231; "NS_Attached Lines Exist"; Boolean)
        {
            CalcFormula = Exist("NS_Job Quote Line" WHERE("NS_Quote No." = FIELD("NS_Quote No."),
                                                        "NS_Attached to Line No." = FIELD("NS_Quote Line No.")));
            Caption = 'Attached Lines Exist';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5001; "NS_Created by"; Code[50])
        {
            Caption = 'Created by';
            TableRelation = User;
            DataClassification = CustomerContent;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(5002; "NS_Created at Date"; Date)
        {
            Caption = 'Created at Date';
            DataClassification = CustomerContent;
        }
        field(5003; "NS_Created at Time"; Time)
        {
            Caption = 'Created at Time';
            DataClassification = CustomerContent;
        }
        field(5011; "NS_Modified by"; Code[50])
        {
            Caption = 'Modified by';
            TableRelation = User;
            DataClassification = CustomerContent;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(5012; "NS_Modified at Date"; Date)
        {
            Caption = 'Modified at Date';
            DataClassification = CustomerContent;
        }
        field(5013; "NS_Modified at Time"; Time)
        {
            Caption = 'Modified at Time';
            DataClassification = CustomerContent;
        }
        field(5701; "NS_Manufacturer Code"; Code[10])
        {
            Caption = 'Manufacturer Code';
            TableRelation = Manufacturer;
            DataClassification = CustomerContent;
        }
        field(14021101; "NS_Cost Category"; Code[10])
        {
            Caption = 'Cost Category';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            TableRelation = "NS_Job Cost Category";
        }
        field(14021102; "NS_Revenue Category"; Code[10])
        {
            Caption = 'Revenue Category';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            TableRelation = "NS_Job Revenue Category";
        }
    }

    keys
    {
        key(Key1; "NS_Quote No.", "NS_Quote Line No.", NS_Revision)
        {
        }
        key(Key2; "NS_Category Code", "NS_No.")
        {
        }
        key(Key3; "NS_Category Code", "NS_Quote Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

