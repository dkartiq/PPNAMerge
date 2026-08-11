table 14021302 "NS_Subcontract Ledger Entry"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-83.SK.1.0 Modified the field length from 10 to 20
    //PRJ-301.Ms.1.0 change length of description from 50 to 100
    Caption = 'Subcontract Ledger Entry';
    DrillDownPageID = "NS_Subcontract Ledger Entries";
    LookupPageID = "NS_Subcontract Ledger Entries";

    fields
    {
        field(1; "NS_Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(2; "NS_Subcontract No."; Code[20])
        {
            Caption = 'Subcontract No.';
            DataClassification = CustomerContent;
        }
        field(3; "NS_Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(4; "NS_Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(5; NS_Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Resource,Item,G/L Account,Ledger';
            OptionMembers = Resource,Item,"G/L Account",Ledger;
            DataClassification = CustomerContent;
        }
        field(7; "NS_No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (NS_Type = CONST(Resource)) Resource
            ELSE
            IF (NS_Type = CONST(Item)) Item
            ELSE
            IF (NS_Type = CONST("G/L Account")) "G/L Account";
            DataClassification = CustomerContent;
        }
        field(8; NS_Description; Text[100])	 //PRJ-301.MS.1.0
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(9; NS_Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(11; "NS_Direct Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost ($)';
            DataClassification = CustomerContent;
        }
        field(12; "NS_Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost ($)';
            DataClassification = CustomerContent;
        }
        field(13; "NS_Total Cost (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Cost ($)';
            DataClassification = CustomerContent;
        }
        field(17; "NS_Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (NS_Type = CONST(Item)) "Unit of Measure"
            ELSE
            IF (NS_Type = CONST(Resource)) "Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(20; "NS_Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
            DataClassification = CustomerContent;
        }
        field(29; "NS_Job Posting Group"; Code[20])
        {
            Caption = 'Job Posting Group';
            TableRelation = IF (NS_Type = CONST(Item)) "Inventory Posting Group";
            DataClassification = CustomerContent;
        }
        field(30; "NS_Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(31; "NS_Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(32; "NS_Work Type Code"; Code[10])
        {
            Caption = 'Work Type Code';
            TableRelation = "Work Type";
            DataClassification = CustomerContent;
        }
        field(33; "NS_Vendor Price Group"; Code[20]) //PRJ-83.SK.1.0 Modified the field length from 10 to 20
        {
            Caption = 'Vendor Price Group';
            TableRelation = Vendor;
            DataClassification = CustomerContent;
        }
        field(37; "NS_User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            DataClassification = CustomerContent;

            trigger OnLookup();
            var
                UserMgt: Codeunit "User Management";
            begin
                UserMgt.DisplayUserInformation("NS_User ID");
            end;
        }
        field(38; "NS_Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
            DataClassification = CustomerContent;
        }
        field(64; "NS_Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Usage,Purchase,Payment';
            OptionMembers = Usage,Purchase,Payment;
            DataClassification = CustomerContent;
        }
        field(65; NS_Positive; Boolean)
        {
            Caption = 'Positive';
            DataClassification = CustomerContent;
        }
        field(75; "NS_Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            DataClassification = CustomerContent;
        }
        field(76; "NS_Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
            DataClassification = CustomerContent;
        }
        field(77; "NS_Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";
            DataClassification = CustomerContent;
        }
        field(78; "NS_Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";
            DataClassification = CustomerContent;
        }
        field(79; "NS_Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;
        }
        field(82; "NS_Entry/Exit Point"; Code[10])
        {
            Caption = 'Entry/Exit Point';
            TableRelation = "Entry/Exit Point";
            DataClassification = CustomerContent;
        }
        field(83; "NS_Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(84; "NS_External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            DataClassification = CustomerContent;
        }
        field(85; "NS_Area"; Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;
            DataClassification = CustomerContent;
        }
        field(86; "NS_Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";
            DataClassification = CustomerContent;
        }
        field(87; "NS_No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(88; "NS_AdditionalCurrencyTotalCost"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Additional-Currency Total Cost';
            DataClassification = CustomerContent;
        }
        field(89; "NS_Add.-Currency Total Price"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Add.-Currency Total Price';
            DataClassification = CustomerContent;
        }
        field(94; "NS_Add.-Currency Line Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Add.-Currency Line Amount';
            DataClassification = CustomerContent;
        }
        field(480; "NS_Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
            DataClassification = CustomerContent;

            trigger OnLookup();
            begin
                NS_ShowDimensions();
            end;
        }
        field(1000; "NS_Job Task No."; Code[35])
        {
            Caption = 'Job Task No.';
            DataClassification = CustomerContent;
        }
        field(1001; "NS_Line Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Amount ($)';
            DataClassification = CustomerContent;
        }
        field(1002; "NS_Unit Cost"; Decimal)
        {
            AutoFormatExpression = "NS_Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            DataClassification = CustomerContent;
        }
        field(1003; "NS_Total Cost"; Decimal)
        {
            AutoFormatExpression = "NS_Currency Code";
            AutoFormatType = 1;
            Caption = 'Total Cost';
            DataClassification = CustomerContent;
        }
        field(1004; "NS_Unit Price"; Decimal)
        {
            AutoFormatExpression = "NS_Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Price';
            DataClassification = CustomerContent;
        }
        field(1005; "NS_Total Price"; Decimal)
        {
            AutoFormatExpression = "NS_Currency Code";
            AutoFormatType = 1;
            Caption = 'Total Price';
            DataClassification = CustomerContent;
        }
        field(1006; "NS_Line Amount"; Decimal)
        {
            AutoFormatExpression = "NS_Currency Code";
            AutoFormatType = 1;
            Caption = 'Line Amount';
            DataClassification = CustomerContent;
        }
        field(1007; "NS_Line Discount Amount"; Decimal)
        {
            AutoFormatExpression = "NS_Currency Code";
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';
            DataClassification = CustomerContent;
        }
        field(1008; "NS_Line Discount Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Discount Amount ($)';
            DataClassification = CustomerContent;
        }
        field(1009; "NS_Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
            DataClassification = CustomerContent;
        }
        field(1010; "NS_Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DataClassification = CustomerContent;
        }
        field(1017; "NS_Ledger Entry Type"; Option)
        {
            Caption = 'Ledger Entry Type';
            OptionCaption = ' ,Resource,Item,G/L Account';
            OptionMembers = " ",Resource,Item,"G/L Account";
            DataClassification = CustomerContent;
        }
        field(1018; "NS_Ledger Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Ledger Entry No.';
            TableRelation = IF ("NS_Ledger Entry Type" = CONST(Resource)) "Res. Ledger Entry"
            ELSE
            IF ("NS_Ledger Entry Type" = CONST(Item)) "Item Ledger Entry"
            ELSE
            IF ("NS_Ledger Entry Type" = CONST("G/L Account")) "G/L Entry";
            DataClassification = CustomerContent;
        }
        field(1019; "NS_Serial No."; Code[20])
        {
            Caption = 'Serial No.';
            DataClassification = CustomerContent;
        }
        field(1020; "NS_Lot No."; Code[20])
        {
            Caption = 'Lot No.';
            DataClassification = CustomerContent;
        }
        field(1021; "NS_Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(1022; "NS_Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionCaption = ' ,Schedule,Contract,Both Schedule and Contract';
            OptionMembers = " ",Schedule,Contract,"Both Schedule and Contract";
            DataClassification = CustomerContent;
        }
        field(1023; "NS_Orginal Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Original Unit Cost ($)';
            DataClassification = CustomerContent;
        }
        field(1024; "NS_Original Total Cost (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Original Total Cost ($)';
            DataClassification = CustomerContent;
        }
        field(1025; "NS_Orginal Unit Cost"; Decimal)
        {
            AutoFormatExpression = "NS_Currency Code";
            AutoFormatType = 2;
            Caption = 'Original Unit Cost';
            DataClassification = CustomerContent;
        }
        field(1026; "NS_Original Total Cost"; Decimal)
        {
            AutoFormatExpression = "NS_Currency Code";
            AutoFormatType = 1;
            Caption = 'Original Total Cost';
            DataClassification = CustomerContent;
        }
        field(1027; "NS_Original Total Cost (ACY)"; Decimal)
        {
            AutoFormatExpression = "NS_Currency Code";
            AutoFormatType = 1;
            Caption = 'Original Total Cost (ACY)';
            DataClassification = CustomerContent;
        }
        field(5402; "NS_Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = IF (NS_Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("NS_No."));
            DataClassification = CustomerContent;
        }
        field(5403; "NS_Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("NS_Location Code"));
            DataClassification = CustomerContent;
        }
        field(5404; "NS_Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(5405; "NS_Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DataClassification = CustomerContent;
        }
        field(14021100; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
            DataClassification = CustomerContent;
        }
        field(14021101; "NS_Job Cost Category"; Code[10])
        {
            Caption = 'Job Cost Category';
            TableRelation = "NS_Job Cost Category";
            DataClassification = CustomerContent;
        }
        field(14021107; "NS_Activity Code"; Code[10])
        {
            Caption = 'Activity Code';
            Description = 'Not for data entry!';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021108; "NS_Process Code"; Code[10])
        {
            Caption = 'Process Code';
            Description = 'Not for data entry!';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021109; "NS_Operation Code"; Code[10])
        {
            Caption = 'Operation Code';
            Description = 'Not for data entry!';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021110; "NS_Work Units"; Decimal)
        {
            Caption = 'Work Units';
            DecimalPlaces = 2 : 2;
            DataClassification = CustomerContent;
        }
        field(14021111; "NS_Work Unit of Measure"; Code[10])
        {
            Caption = 'Work Unit of Measure';
            TableRelation = "Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(14021150; "NS_Job Ledger Entry No."; Integer)
        {
            Caption = 'Job Ledger Entry No.';
            TableRelation = "Job Ledger Entry"."No.";
            DataClassification = CustomerContent;
        }
        field(14021151; "NS_Retention Ledger Code"; Code[20])
        {
            Caption = 'Retention Ledger Code';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Entry No.")
        {
        }
        key(Key2; "NS_Subcontract No.", "NS_Entry Type", "NS_Posting Date", NS_Type)
        {
            SumIndexFields = "NS_Total Cost (LCY)";
        }
        key(Key3; "NS_Subcontract No.", "NS_Posting Date")
        {
        }
        key(Key4; "NS_Subcontract No.", NS_Positive, "NS_Posting Date")
        {
        }
        key(Key5; "NS_Subcontract No.", "NS_Entry Type", NS_Type, "NS_Job Posting Group")
        {
        }
        key(Key6; "NS_Subcontract No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Job Cost Category", NS_Type, "NS_No.", "NS_Posting Date")
        {
            SumIndexFields = "NS_Total Cost (LCY)";
        }
        key(Key7; "NS_Subcontract No.", "NS_Entry Type", NS_Type, "NS_No.", "NS_Unit of Measure Code", "NS_Work Type Code")
        {
        }
        key(Key8; NS_Type, "NS_Country/Region Code", "NS_Source Code", "NS_Posting Date")
        {
        }
        key(Key9; "NS_Document No.", "NS_Posting Date")
        {
        }
        key(Key10; "NS_Posting Date")
        {
        }
        key(Key11; "NS_Subcontract No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Job Cost Category", "NS_Entry Type", NS_Type, "NS_Posting Date")
        {
            SumIndexFields = "NS_Total Cost (LCY)";
        }
        key(Key12; "NS_Subcontract No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Entry Type", NS_Type, "NS_Posting Date")
        {
            SumIndexFields = "NS_Total Cost (LCY)";
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        Subcontract.NS_JobTaskNoToAPO("NS_Job Task No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code");
    end;

    trigger OnModify();
    begin
        Subcontract.NS_JobTaskNoToAPO("NS_Job Task No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code");
    end;

    var
        Subcontract: Record NS_Subcontract;
        DimMgt: Codeunit DimensionManagement;

    procedure NS_ShowDimensions();
    begin
        DimMgt.ShowDimensionSet("NS_Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "NS_Entry No."));
    end;
}

