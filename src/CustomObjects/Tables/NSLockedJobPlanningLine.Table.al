table 14021165 "NS_Locked Job Planning Line"
{
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-1420.NK.1.0 30May2022 | Add Field
    Caption = 'Locked Job Planning Line';

    fields
    {
        field(1; "NS_Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(2; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            Editable = true;
            NotBlank = true;
            TableRelation = Job;
            DataClassification = CustomerContent;
        }
        field(3; "NS_Planning Date"; Date)
        {
            Caption = 'Planning Date';
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
            OptionCaption = 'Resource,Item,G/L Account,Text,Resource (Group)';
            OptionMembers = Resource,Item,"G/L Account",Text,"Resource (Group)";
            DataClassification = CustomerContent;
        }
        field(7; "NS_No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (NS_Type = CONST(Resource)) Resource
            ELSE
            IF (NS_Type = CONST(Item)) Item
            ELSE
            IF (NS_Type = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (NS_Type = CONST(Text)) "Standard Text"
            ELSE
            IF (NS_Type = CONST("Resource (Group)")) "Resource Group";
            DataClassification = CustomerContent;
        }
        // >> Upgrade
        //field(8; NS_Description; Text[50])
        field(8; NS_Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        // << Upgrade
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
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(13; "NS_Total Cost (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Cost ($)';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(14; "NS_Unit Price (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price ($)';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(15; "NS_Total Price (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Price ($)';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(16; "NS_Resource Group No."; Code[20])
        {
            Caption = 'Resource Group No.';
            Editable = true;
            TableRelation = "Resource Group";
            DataClassification = CustomerContent;
        }
        field(17; "NS_Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (NS_Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("NS_No."))
            ELSE
            IF (NS_Type = CONST(Resource)) "Resource Unit of Measure".Code WHERE("Resource No." = FIELD("NS_No."))
            ELSE
            "Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(20; "NS_Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
            DataClassification = CustomerContent;
        }
        field(29; "NS_Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(30; "NS_User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = true;
            TableRelation = User."User Name";
            DataClassification = CustomerContent;
        }
        field(32; "NS_Work Type Code"; Code[10])
        {
            Caption = 'Work Type Code';
            TableRelation = "Work Type";
            DataClassification = CustomerContent;
        }
        field(33; "NS_Customer Price Group"; Code[10])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
            DataClassification = CustomerContent;
        }
        field(79; "NS_Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            Editable = true;
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;
        }
        field(80; "NS_Gen. Bus. Posting Group"; Code[10])
        {
            ObsoleteState = Pending;//PRJ-831.AS.2.0 13OCT2021 Obselete
            ObsoleteReason = 'Will be removed in next build';//PRJ-831.AS.2.0 13OCT2021 Obselete
            Caption = 'Gen. Bus. Posting Group';
            Editable = true;
            //TableRelation = "Gen. Business Posting Group";//PRJ-1684.AS.1.0 TABLE RELATION REMOVED
            DataClassification = CustomerContent;
        }
        field(81; "NS_Gen. Prod. Posting Group"; Code[10])
        {
            ObsoleteState = Pending;//PRJ-831.AS.2.0 13OCT2021 Obselete
            ObsoleteReason = 'Will be removed in next build';//PRJ-831.AS.2.0 13OCT2021 Obselete
            Caption = 'Gen. Prod. Posting Group';
            Editable = true;
            //TableRelation = "Gen. Product Posting Group";//PRJ-1684.AS.1.0 TABLE RELATION REMOVED
            DataClassification = CustomerContent;
        }
        field(83; "NS_Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }

        field(84; "NS_Gen. Bus. Posting Group New"; Code[20])//PRJ-831.AS.2.0 13OCT2021
        {
            Caption = 'Gen. Bus. Posting Group';
            Editable = true;
            TableRelation = "Gen. Business Posting Group";
            DataClassification = CustomerContent;
        }
        field(85; "NS_Gen. Prod. Posting Group New"; Code[20])//PRJ-831.AS.2.0 13OCT2021
        {
            Caption = 'Gen. Prod. Posting Group';
            Editable = true;
            TableRelation = "Gen. Product Posting Group";
            DataClassification = CustomerContent;
        }
        field(1000; "NS_Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            NotBlank = false;
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("NS_Job No."));
            DataClassification = CustomerContent;
        }
        field(1001; "NS_Line Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Amount ($)';
            Editable = true;
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
            Editable = true;
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
            Editable = true;
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
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(1015; "NS_Cost Factor"; Decimal)
        {
            Caption = 'Cost Factor';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(1019; "NS_Serial No."; Code[20])
        {
            Caption = 'Serial No.';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(1020; "NS_Lot No."; Code[20])
        {
            Caption = 'Lot No.';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(1021; "NS_Line Discount %"; Decimal)
        {
            BlankZero = true;
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(1022; "NS_Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionCaption = 'Budget,Billable,Both Budget and Billable';
            OptionMembers = Budget,Billable,"Both Budget and Billable";
            DataClassification = CustomerContent;
        }
        field(1023; "NS_Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = true;
            TableRelation = Currency;
            DataClassification = CustomerContent;
        }
        field(1024; "NS_Currency Date"; Date)
        {
            AccessByPermission = TableData Currency = R;
            Caption = 'Currency Date';
            DataClassification = CustomerContent;
        }
        field(1025; "NS_Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = true;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(1026; "NS_Schedule Line"; Boolean)
        {
            Caption = 'Schedule Line';
            Editable = true;
            InitValue = true;
            DataClassification = CustomerContent;
        }
        field(1027; "NS_Contract Line"; Boolean)
        {
            Caption = 'Contract Line';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(1030; "NS_Job Contract Entry No."; Integer)
        {
            Caption = 'Job Contract Entry No.';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(1035; "NS_Invoiced Amount (LCY)"; Decimal)
        {
            Caption = 'Invoiced Amount ($)';
            FieldClass = Normal;
            DataClassification = CustomerContent;
        }
        field(1036; "NS_Invoiced Cost Amount (LCY)"; Decimal)
        {
            Caption = 'Invoiced Cost Amount ($)';
            DataClassification = CustomerContent;
        }
        field(1037; "NS_VAT Unit Price"; Decimal)
        {
            Caption = 'Tax Unit Price';
            DataClassification = CustomerContent;
        }
        field(1038; "NS_VAT Line Discount Amount"; Decimal)
        {
            Caption = 'Tax Line Discount Amount';
            DataClassification = CustomerContent;
        }
        field(1039; "NS_VAT Line Amount"; Decimal)
        {
            Caption = 'Tax Line Amount';
            DataClassification = CustomerContent;
        }
        field(1041; "NS_VAT %"; Decimal)
        {
            Caption = 'Tax %';
            DataClassification = CustomerContent;
        }
        field(1042; "NS_Description 2"; Text[50])
        {
            Caption = 'Description 2';
            DataClassification = CustomerContent;
        }
        field(1043; "NS_Job Ledger Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Job Ledger Entry No.';
            Editable = true;
            TableRelation = "Job Ledger Entry";
            DataClassification = CustomerContent;
        }
        field(1048; NS_Status; Option)
        {
            Caption = 'Status';
            Editable = true;
            InitValue = "Order";
            OptionCaption = 'Planning,Quote,Order,Completed';
            OptionMembers = Planning,Quote,"Order",Completed;
            DataClassification = CustomerContent;
        }
        field(1050; "NS_Ledger Entry Type"; Option)
        {
            Caption = 'Ledger Entry Type';
            OptionCaption = ' ,Resource,Item,G/L Account';
            OptionMembers = " ",Resource,Item,"G/L Account";
            DataClassification = CustomerContent;
        }
        field(1051; "NS_Ledger Entry No."; Integer)
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
        field(1052; "NS_System-Created Entry"; Boolean)
        {
            Caption = 'System-Created Entry';
            DataClassification = CustomerContent;
        }
        field(1053; "NS_Usage Link"; Boolean)
        {
            Caption = 'Usage Link';
            DataClassification = CustomerContent;
        }
        field(1060; "NS_Remaining Qty."; Decimal)
        {
            Caption = 'Remaining Qty.';
            DecimalPlaces = 0 : 5;
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(1061; "NS_Remaining Qty. (Base)"; Decimal)
        {
            Caption = 'Remaining Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(1062; "NS_Remaining Total Cost"; Decimal)
        {
            AutoFormatExpression = "NS_Currency Code";
            AutoFormatType = 1;
            Caption = 'Remaining Total Cost';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(1063; "NS_Remaining Total Cost (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Remaining Total Cost ($)';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(1064; "NS_Remaining Line Amount"; Decimal)
        {
            AutoFormatExpression = "NS_Currency Code";
            AutoFormatType = 1;
            Caption = 'Remaining Line Amount';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(1065; "NS_Remaining Line Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Remaining Line Amount ($)';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(1070; "NS_Qty. Posted"; Decimal)
        {
            Caption = 'Qty. Posted';
            DecimalPlaces = 0 : 5;
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(1071; "NS_Qty. to Transfer to Journal"; Decimal)
        {
            Caption = 'Qty. to Transfer to Journal';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(1072; "NS_Posted Total Cost"; Decimal)
        {
            AutoFormatExpression = "NS_Currency Code";
            AutoFormatType = 1;
            Caption = 'Posted Total Cost';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(1073; "NS_Posted Total Cost (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Posted Total Cost ($)';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(1074; "NS_Posted Line Amount"; Decimal)
        {
            AutoFormatExpression = "NS_Currency Code";
            AutoFormatType = 1;
            Caption = 'Posted Line Amount';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(1075; "NS_Posted Line Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Posted Line Amount ($)';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(1080; "NS_Qty. Transferred to Invoice"; Decimal)
        {
            Caption = 'Qty. Transferred to Invoice';
            DecimalPlaces = 0 : 5;
            FieldClass = Normal;
            DataClassification = CustomerContent;
        }
        field(1081; "NS_Qty. to Transfer to Invoice"; Decimal)
        {
            Caption = 'Qty. to Transfer to Invoice';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(1090; "NS_Qty. Invoiced"; Decimal)
        {
            Caption = 'Qty. Invoiced';
            DecimalPlaces = 0 : 5;
            Editable = true;
            FieldClass = Normal;
            DataClassification = CustomerContent;
        }
        field(1091; "NS_Qty. to Invoice"; Decimal)
        {
            Caption = 'Qty. to Invoice';
            DecimalPlaces = 0 : 5;
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(1100; "NS_Reserved Quantity"; Decimal)
        {
            AccessByPermission = TableData Item = R;
            Caption = 'Reserved Quantity';
            DecimalPlaces = 0 : 5;
            Editable = true;
            FieldClass = Normal;
            DataClassification = CustomerContent;
        }
        field(1101; "NS_Reserved Qty. (Base)"; Decimal)
        {
            AccessByPermission = TableData Item = R;
            Caption = 'Reserved Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(1102; NS_Reserve; Option)
        {
            AccessByPermission = TableData Item = R;
            Caption = 'Reserve';
            OptionCaption = 'Never,Optional,Always';
            OptionMembers = Never,Optional,Always;
            DataClassification = CustomerContent;
        }
        field(1103; NS_Planned; Boolean)
        {
            Caption = 'Planned';
            Editable = true;
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
            Editable = true;
            InitValue = 1;
            DataClassification = CustomerContent;
        }
        field(5410; "NS_Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(5790; "NS_Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';
            DataClassification = CustomerContent;
        }
        field(5791; "NS_Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';
            DataClassification = CustomerContent;
        }
        field(5794; "NS_Planned Delivery Date"; Date)
        {
            Caption = 'Planned Delivery Date';
            DataClassification = CustomerContent;
        }
        field(5900; "NS_Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
            DataClassification = CustomerContent;
        }
        field(14021101; "NS_Cost Category"; Code[10])
        {
            Caption = 'Cost Category';
            TableRelation = "NS_Job Cost Category";
            DataClassification = CustomerContent;
        }
        field(14021102; "NS_Revenue Category"; Code[10])
        {
            Caption = 'Revenue Category';
            TableRelation = "NS_Job Revenue Category";
            DataClassification = CustomerContent;
        }
        field(14021103; "NS_Cost Factor Set By Category"; Boolean)
        {
            Caption = 'Cost Factor Set By Category';
            DataClassification = CustomerContent;
        }
        field(14021105; "NS_Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(14021106; "NS_Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(14021107; "NS_Activity Code"; Code[10])
        {
            Caption = 'Activity Code';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(14021108; "NS_Process Code"; Code[10])
        {
            Caption = 'Process Code';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(14021109; "NS_Operation Code"; Code[10])
        {
            Caption = 'Operation Code';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(14021111; "NS_Section Code"; Code[10])//PRJ-749.AS.1.0
        {
            Caption = 'Section Code';
            Description = 'ProjectPro - Not for data entry!';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021115; "NS_Work Units"; Decimal)
        {
            Caption = 'Work Units';
            DecimalPlaces = 2 : 2;
            DataClassification = CustomerContent;
        }
        field(14021116; "NS_Work Unit of Measure"; Code[10])
        {
            Caption = 'Work Unit of Measure';
            TableRelation = "Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(14021118; "NS_Skill Class"; Code[10])
        {
            Caption = 'Skill Class';
            TableRelation = "NS_Skill Class";
            DataClassification = CustomerContent;
        }
        field(14021150; "NS_Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Cost,Both,Price';
            OptionMembers = Cost,Both,Price;
            DataClassification = CustomerContent;
        }
        field(14021151; NS_Adjustment; Code[10])
        {
            Caption = 'Adjustment';
            TableRelation = "NS_Adjustment Type".NS_Code;
            DataClassification = CustomerContent;
        }
        field(14021152; "NS_Rate Type"; Option)
        {
            Caption = 'Rate Type';
            OptionCaption = '" ,Fixed,Time and Material,Cost Plus %,Cost Plus $"';
            OptionMembers = " ","Fixed","Time and Material","Cost Plus %","Cost Plus $";
            DataClassification = CustomerContent;
        }
        field(14021153; "NS_Rate Type Value"; Decimal)
        {
            Caption = 'Rate Type Value';
            DataClassification = CustomerContent;
        }
        field(14021154; "NS_Not To Exceed"; Decimal)
        {
            Caption = 'Not To Exceed';
            DataClassification = CustomerContent;
        }
        field(14021300; "NS_Subcontract No."; Code[20])
        {
            Caption = 'Subcontract No.';
            TableRelation = NS_Subcontract."NS_No.";
            DataClassification = CustomerContent;
        }
        field(14021325; "NS_Subcontract Line No."; Integer)
        {
            Caption = 'Subcontract Line No.';
            DataClassification = CustomerContent;
        }
        field(14021326; "NS_Progress Billing Method"; Option)
        {
            Caption = 'Progress Billing Method';
            OptionCaption = ' ,%,Unit,L/S';
            OptionMembers = " ","%",Unit,"L/S";
            DataClassification = CustomerContent;
        }
        field(14021327; "NS_Progress Payment Method"; Option)
        {
            Caption = 'Progress Payment Method';
            OptionCaption = ' ,%,Unit,L/S';
            OptionMembers = " ","%",Unit,"L/S";
            DataClassification = CustomerContent;
        }
        field(14021350; NS_TempNo; Code[20])
        {
            Caption = 'TempNo';
            DataClassification = CustomerContent;
        }
        field(14021351; NS_TempLocation; Code[10])
        {
            Caption = 'TempLocation';
            DataClassification = CustomerContent;
        }
        field(14021352; NS_TempVariant; Code[10])
        {
            Caption = 'TempVariant';
            DataClassification = CustomerContent;
        }
        field(14021353; NS_TempUM; Code[10])
        {
            Caption = 'TempUM';
            DataClassification = CustomerContent;
        }
        field(14021354; NS_TempWorkType; Code[10])
        {
            Caption = 'TempWorkType';
            DataClassification = CustomerContent;
        }
        field(14021355; NS_TempSkillClass; Code[10])
        {
            Caption = 'TempSkillClass';
            DataClassification = CustomerContent;
        }
        field(14021400; NS_Welding; Boolean)
        {
            Caption = 'Welding';
            DataClassification = CustomerContent;
        }
        field(14021401; "NS_Size of Weld"; Decimal)
        {
            Caption = 'Size of Weld';
            DataClassification = CustomerContent;
        }
        field(14021402; "NS_Weld Time (Hours)"; Decimal)
        {
            Caption = 'Weld Time (Hours)';
            DataClassification = CustomerContent;
        }
        field(14021403; "NS_No. 2"; Code[30])
        {
            Caption = 'Mfg. Item No.';
            DataClassification = CustomerContent;
        }
        field(14021404; "NS_Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            DataClassification = CustomerContent;
        }
        field(14021405; "NS_Quote Line No."; Integer)
        {
            Caption = 'Quote Line No.';
            DataClassification = CustomerContent;
        }
        field(14021406; "NS_Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
            DataClassification = CustomerContent;
        }
        field(14021407; "NS_Use Tax SKU"; Code[20])
        {
            Caption = 'Use Tax SKU';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(14021408; "NS_Use Tax Amount"; Decimal)
        {
            Caption = 'Use Tax Amount';
            DataClassification = CustomerContent;
        }
        field(14021409; "NS_Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            DataClassification = CustomerContent;
        }
        field(14021410; "NS_Vendor Quote No."; Text[30])
        {
            Caption = 'Vendor Quote No.';
            DataClassification = CustomerContent;
        }
        field(14021411; "NS_Manufacturer Code"; Code[10])
        {
            Caption = 'Manufacturer Code';
            TableRelation = Manufacturer;
            DataClassification = CustomerContent;
        }
        field(14021412; "NS_Defaulted Entry"; Boolean)
        {
            Caption = 'Defaulted Entry';
            DataClassification = CustomerContent;
        }
        field(14021413; "NS_Total Number of Welds"; Integer)
        {
            Caption = 'Total Number of Welds';
            DataClassification = CustomerContent;
        }
        field(14021414; "NS_Gross Profit"; Decimal)
        {
            Caption = 'Gross Profit';
            DataClassification = CustomerContent;
        }
        field(14021415; "NS_Gross Profit Percentage"; Decimal)
        {
            Caption = 'Gross Profit Percentage';
            DataClassification = CustomerContent;
        }
        field(14021416; "NS_Original Total Price"; Decimal)
        {
            Caption = 'Original Total Price';
            DataClassification = CustomerContent;
        }
        field(14021417; "NS_Original Total Price (LCY)"; Decimal)
        {
            Caption = 'Original Total Price (LCY)';
            DataClassification = CustomerContent;
        }
        field(14021418; "NS_Original Quantity"; Decimal)
        {
            Caption = 'Original Quantity';
            DataClassification = CustomerContent;
        }
        field(14021419; "NS_Item Not Found"; Boolean)
        {
            Caption = 'Item Not Found';
            DataClassification = CustomerContent;
        }
        field(14021420; "NS_Segment Type"; Option)
        {
            Caption = 'Segment Type';
            OptionCaption = '" ,Drawing,Welding"';
            OptionMembers = " ",Drawing,Welding;
            TableRelation = "NS_Job Takeoff Segments".NS_Type;
            DataClassification = CustomerContent;
        }
        field(14021421; "NS_Segment Code"; Code[20])
        {
            Caption = 'Segment Code';
            TableRelation = "NS_Job Takeoff Segments"."NS_Segment Code" WHERE("NS_Job No." = FIELD("NS_Job No."));
            DataClassification = CustomerContent;
        }
        field(14021422; "NS_Segment Name"; Text[50])
        {
            Caption = 'Segment Name';
            Editable = true;
            TableRelation = "NS_Job Takeoff Segments"."NS_Segment Name";
            DataClassification = CustomerContent;
        }
        field(14021423; "NS_Matrix Updated"; Boolean)
        {
            Caption = 'Matrix Updated';
            DataClassification = CustomerContent;
        }
        field(14021425; "NS_Progress Billing Line"; Boolean)
        {
            Caption = 'Progress Billing Line';
            DataClassification = CustomerContent;
        }
        field(14021480; "NS_Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = true;
            TableRelation = "Dimension Set Entry";
            DataClassification = CustomerContent;
        }
        field(14021481; "NS_Retention Ledger Code"; Code[20])
        {
            Caption = 'Retention Ledger Code';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            DataClassification = CustomerContent;
        }
        field(14021482; "NS_Line Amount Incl. Tax"; Decimal)
        {
            Caption = 'Line Amount Incl. Tax';
            DataClassification = CustomerContent;
        }
        field(14021483; "NS_Template No."; Code[20])
        {
            Caption = 'Template No.';
            DataClassification = CustomerContent;
        }
        //PRJ-1420.NK.1.0 30May2022 Start
        field(14021484; NS_DescriptionNew; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        //PRJ-1420.NK.1.0 30May2022 End
    }

    keys
    {
        key(Key1; "NS_Job No.", "NS_Job Task No.", "NS_Line No.")
        {
            SumIndexFields = NS_Quantity, "NS_Quantity (Base)", "NS_Unit Cost", "NS_Unit Price", "NS_Total Cost (LCY)", "NS_Line Amount (LCY)", "NS_Total Cost";
        }
        key(Key2; "NS_Job No.", "NS_Job Task No.", "NS_Schedule Line", "NS_Planning Date")
        {
            SumIndexFields = "NS_Total Price (LCY)", "NS_Total Cost (LCY)", "NS_Line Amount (LCY)", "NS_Remaining Total Cost (LCY)", "NS_Remaining Line Amount (LCY)";
        }
        key(Key3; "NS_Job No.", "NS_Job Task No.", "NS_Contract Line", "NS_Planning Date")
        {
            SumIndexFields = "NS_Line Amount (LCY)", "NS_Total Price (LCY)", "NS_Total Cost (LCY)";
        }
        key(Key4; "NS_Job No.", "NS_Job Task No.", "NS_Schedule Line", "NS_Currency Date")
        {
        }
        key(Key5; "NS_Job No.", "NS_Job Task No.", "NS_Contract Line", "NS_Currency Date")
        {
        }
        key(Key6; "NS_Job No.", "NS_Schedule Line", NS_Type, "NS_No.", "NS_Planning Date")
        {
            SumIndexFields = "NS_Quantity (Base)";
        }
        key(Key7; "NS_Job No.", "NS_Schedule Line", NS_Type, "NS_Resource Group No.", "NS_Planning Date")
        {
            SumIndexFields = "NS_Quantity (Base)";
        }
        key(Key8; NS_Status, "NS_Schedule Line", NS_Type, "NS_No.", "NS_Planning Date")
        {
            SumIndexFields = "NS_Quantity (Base)";
        }
        key(Key9; NS_Status, "NS_Schedule Line", NS_Type, "NS_Resource Group No.", "NS_Planning Date")
        {
            SumIndexFields = "NS_Quantity (Base)";
        }
        key(Key10; "NS_Job No.", "NS_Contract Line")
        {
        }
        key(Key11; "NS_Job Contract Entry No.")
        {
        }
        key(Key12; NS_Type, "NS_No.", "NS_Job No.", "NS_Job Task No.", "NS_Usage Link", "NS_System-Created Entry")
        {
        }
        key(Key13; NS_Status, NS_Type, "NS_No.", "NS_Variant Code", "NS_Location Code", "NS_Planning Date")
        {
            SumIndexFields = "NS_Remaining Qty. (Base)";
        }
        key(Key14; "NS_Job No.", "NS_Subcontract No.", "NS_Entry Type", "NS_Job Task No.", "NS_Cost Category", NS_Type, "NS_No.", "NS_Variant Code", "NS_Planning Date", NS_Adjustment, "NS_Line No.")
        {
            SumIndexFields = "NS_Quantity (Base)", "NS_Total Cost (LCY)", "NS_Total Cost", "NS_Total Price (LCY)", "NS_Total Price", "NS_Work Units";
        }
        key(Key15; "NS_Job No.", "NS_Cost Category", "NS_Revenue Category", "NS_Line Type", "NS_Shortcut Dimension 1 Code", "NS_Shortcut Dimension 2 Code")
        {
            SumIndexFields = "NS_Quantity (Base)", "NS_Total Cost (LCY)", "NS_Total Cost", "NS_Total Price (LCY)", "NS_Total Price", "NS_Work Units";
        }
        key(Key16; "NS_Job No.", "NS_Subcontract No.", "NS_Job Task No.", "NS_Cost Category", NS_Type, "NS_No.", "NS_Variant Code")
        {
        }
        key(Key17; "NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Cost Category", NS_Type, "NS_No.", "NS_Variant Code")
        {
            SumIndexFields = "NS_Quantity (Base)", "NS_Total Cost (LCY)", "NS_Total Cost", "NS_Total Price (LCY)", "NS_Total Price", "NS_Work Units";
        }
        key(Key18; "NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Revenue Category", NS_Type, "NS_No.", "NS_Variant Code")
        {
            SumIndexFields = "NS_Quantity (Base)", "NS_Total Cost (LCY)", "NS_Total Cost", "NS_Total Price (LCY)", "NS_Total Price", "NS_Work Units";
        }
        key(Key19; "NS_Job No.", "NS_Entry Type", "NS_Job Task No.", "NS_Cost Category", "NS_Revenue Category", NS_Type, "NS_No.", "NS_Variant Code")
        {
        }
        key(Key20; "NS_Job No.", "NS_Subcontract No.", "NS_Line Type", "NS_Planning Date", NS_Type)
        {
            SumIndexFields = "NS_Quantity (Base)", "NS_Total Cost (LCY)", "NS_Total Cost", "NS_Total Price (LCY)", "NS_Total Price", "NS_Work Units";
        }
        key(Key21; "NS_Subcontract No.")
        {
        }
        key(Key22; "NS_Job No.", NS_Adjustment, "NS_Line Type")
        {
            SumIndexFields = "NS_Quantity (Base)", "NS_Total Cost (LCY)", "NS_Total Cost", "NS_Total Price (LCY)", "NS_Total Price", "NS_Work Units";
        }
        key(Key23; "NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Subcontract No.", "NS_Cost Category", NS_Type, "NS_No.", "NS_Variant Code", "NS_Rate Type", NS_Adjustment)
        {
            SumIndexFields = "NS_Quantity (Base)", "NS_Total Cost (LCY)", "NS_Total Cost", "NS_Total Price (LCY)", "NS_Total Price", "NS_Work Units";
        }
        key(Key24; "NS_Job No.", "NS_Subcontract No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Cost Category", NS_Type, "NS_No.", "NS_Planning Date", NS_Adjustment)
        {
        }
        key(Key25; "NS_Job No.", "NS_Job Task No.", "NS_Entry Type", "NS_Line Type", NS_Type, "NS_No.")
        {
        }
    }

    fieldgroups
    {
    }
}

