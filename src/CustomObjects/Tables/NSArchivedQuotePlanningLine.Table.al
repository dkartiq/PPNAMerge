table 14021431 "NS_Archived QuotePlanningLine"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    //PRJ-301.MS.1.0 change length from 50 to 100
    // +------------------------------------------------------------
    //PRJ-933.JS.1.0 05OCT2021 | change table caption

    Caption = 'Archived Quote Planning Line';     //PRJ-933.JS.1.0 05OCT2021

    fields
    {
        field(1; "NS_Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(2; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = CustomerContent;
            Editable = true;
            NotBlank = true;
            TableRelation = Job;
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
            DataClassification = CustomerContent;
            TableRelation = IF (NS_Type = CONST(Resource)) Resource
            ELSE
            IF (NS_Type = CONST(Item)) Item
            ELSE
            IF (NS_Type = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (NS_Type = CONST(Text)) "Standard Text"
            ELSE
            IF (NS_Type = CONST("Resource (Group)")) "Resource Group";
        }
        field(8; NS_Description; Text[100])//PRJ-301.MS.1.0
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(9; NS_Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
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
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(13; "NS_Total Cost (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Cost ($)';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14; "NS_Unit Price (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price ($)';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(15; "NS_Total Price (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Price ($)';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(16; "NS_Resource Group No."; Code[20])
        {
            Caption = 'Resource Group No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Resource Group";
        }
        field(17; "NS_Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = CustomerContent;
            TableRelation = IF (NS_Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("NS_No."))
            ELSE
            IF (NS_Type = CONST(Resource)) "Resource Unit of Measure".Code WHERE("Resource No." = FIELD("NS_No."))
            ELSE
            "Unit of Measure";
        }
        field(20; "NS_Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(29; "NS_Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(30; "NS_User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(32; "NS_Work Type Code"; Code[10])
        {
            Caption = 'Work Type Code';
            DataClassification = CustomerContent;
            TableRelation = "Work Type";
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
            Editable = false;
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;
        }
        field(80; "NS_Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            Editable = false;
            DataClassification = CustomerContent;
            TableRelation = "Gen. Business Posting Group";
        }
        field(81; "NS_Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            Editable = false;
            TableRelation = "Gen. Product Posting Group";
            DataClassification = CustomerContent;
        }
        field(83; "NS_Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(1000; "NS_Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            NotBlank = true;
            DataClassification = CustomerContent;
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("NS_Job No."));
        }
        field(1001; "NS_Line Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Amount ($)';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(1002; "NS_Unit Cost"; Decimal)
        {
            AutoFormatExpression = "NS_Currency Code";
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            Caption = 'Unit Cost';
        }
        field(1003; "NS_Total Cost"; Decimal)
        {
            AutoFormatExpression = "NS_Currency Code";
            DataClassification = CustomerContent;
            AutoFormatType = 1;
            Caption = 'Total Cost';
            Editable = false;
        }
        field(1004; "NS_Unit Price"; Decimal)
        {
            AutoFormatExpression = "NS_Currency Code";
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            Caption = 'Unit Price';
        }
        field(1005; "NS_Total Price"; Decimal)
        {
            AutoFormatExpression = "NS_Currency Code";
            DataClassification = CustomerContent;
            AutoFormatType = 1;
            Caption = 'Total Price';
            Editable = false;
        }
        field(1006; "NS_Line Amount"; Decimal)
        {
            AutoFormatExpression = "NS_Currency Code";
            DataClassification = CustomerContent;
            AutoFormatType = 1;
            Caption = 'Line Amount';
        }
        field(1007; "NS_Line Discount Amount"; Decimal)
        {
            AutoFormatExpression = "NS_Currency Code";
            DataClassification = CustomerContent;
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';
        }
        field(1008; "NS_Line Discount Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Discount Amount ($)';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(1015; "NS_Cost Factor"; Decimal)
        {
            Caption = 'Cost Factor';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(1019; "NS_Serial No."; Code[20])
        {
            Caption = 'Serial No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(1020; "NS_Lot No."; Code[20])
        {
            Caption = 'Lot No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(1021; "NS_Line Discount %"; Decimal)
        {
            BlankZero = true;
            DataClassification = CustomerContent;
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
        }
        field(1022; "NS_Line Type"; Option)
        {
            Caption = 'Line Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Budget,Billable,Both Budget and Billable';
            OptionMembers = Budget,Billable,"Both Budget and Billable";
        }
        field(1023; "NS_Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Currency;
        }
        field(1024; "NS_Currency Date"; Date)
        {
            AccessByPermission = TableData Currency = R;
            DataClassification = CustomerContent;
            Caption = 'Currency Date';
        }
        field(1025; "NS_Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(1026; "NS_Schedule Line"; Boolean)
        {
            Caption = 'Schedule Line';
            DataClassification = CustomerContent;
            Editable = false;
            InitValue = true;
        }
        field(1027; "NS_Contract Line"; Boolean)
        {
            Caption = '<Billable Line>';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(1030; "NS_Job Contract Entry No."; Integer)
        {
            Caption = 'Job Contract Entry No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(1035; "NS_Invoiced Amount (LCY)"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line Invoice"."Invoiced Amount (LCY)" WHERE("Job No." = FIELD("NS_Job No."),
                                                                                         "Job Task No." = FIELD("NS_Job Task No."),
                                                                                         "Job Planning Line No." = FIELD("NS_Line No.")));
            Caption = 'Invoiced Amount ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1036; "NS_Invoiced Cost Amount (LCY)"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line Invoice"."Invoiced Cost Amount (LCY)" WHERE("Job No." = FIELD("NS_Job No."),
                                                                                              "Job Task No." = FIELD("NS_Job Task No."),
                                                                                              "Job Planning Line No." = FIELD("NS_Line No.")));
            Caption = 'Invoiced Cost Amount ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1037; "NS_VAT Unit Price"; Decimal)
        {
            Caption = 'Tax Unit Price';
            DataClassification = CustomerContent;
        }
        field(1038; "NS_VAT Line Discount Amount"; Decimal)
        {
            Caption = 'VAT Line Discount Amount';
            DataClassification = CustomerContent;
        }
        field(1039; "NS_VAT Line Amount"; Decimal)
        {
            Caption = 'VAT Line Amount';
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
            DataClassification = CustomerContent;
            Caption = 'Job Ledger Entry No.';
            Editable = false;
            TableRelation = "Job Ledger Entry";
        }
        field(1048; NS_Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            InitValue = "Order";
            DataClassification = CustomerContent;
            OptionCaption = 'Planning,Quote,Order,Completed';
            OptionMembers = Planning,Quote,"Order",Completed;
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
            DataClassification = CustomerContent;
            TableRelation = IF ("NS_Ledger Entry Type" = CONST(Resource)) "Res. Ledger Entry"
            ELSE
            IF ("NS_Ledger Entry Type" = CONST(Item)) "Item Ledger Entry"
            ELSE
            IF ("NS_Ledger Entry Type" = CONST("G/L Account")) "G/L Entry";
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
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(1061; "NS_Remaining Qty. (Base)"; Decimal)
        {
            Caption = 'Remaining Qty. (Base)';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(1062; "NS_Remaining Total Cost"; Decimal)
        {
            AutoFormatExpression = "NS_Currency Code";
            DataClassification = CustomerContent;
            AutoFormatType = 1;
            Caption = 'Remaining Total Cost';
            Editable = false;
        }
        field(1063; "NS_Remaining Total Cost (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            DataClassification = CustomerContent;
            Caption = 'Remaining Total Cost ($)';
            Editable = false;
        }
        field(1064; "NS_Remaining Line Amount"; Decimal)
        {
            AutoFormatExpression = "NS_Currency Code";
            DataClassification = CustomerContent;
            AutoFormatType = 1;
            Caption = 'Remaining Line Amount';
            Editable = false;
        }
        field(1065; "NS_Remaining Line Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            DataClassification = CustomerContent;
            Caption = 'Remaining Line Amount ($)';
            Editable = false;
        }
        field(1070; "NS_Qty. Posted"; Decimal)
        {
            Caption = 'Qty. Posted';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(1071; "NS_Qty. to Transfer to Journal"; Decimal)
        {
            Caption = 'Qty. to Transfer to Journal';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(1072; "NS_Posted Total Cost"; Decimal)
        {
            AutoFormatExpression = "NS_Currency Code";
            DataClassification = CustomerContent;
            AutoFormatType = 1;
            Caption = 'Posted Total Cost';
            Editable = false;
        }
        field(1073; "NS_Posted Total Cost (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Posted Total Cost ($)';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(1074; "NS_Posted Line Amount"; Decimal)
        {
            AutoFormatExpression = "NS_Currency Code";
            DataClassification = CustomerContent;
            AutoFormatType = 1;
            Caption = 'Posted Line Amount';
            Editable = false;
        }
        field(1075; "NS_Posted Line Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Posted Line Amount ($)';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(1080; "NS_Qty. Transferred to Invoice"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line Invoice"."Quantity Transferred" WHERE("Job No." = FIELD("NS_Job No."),
                                                                                        "Job Task No." = FIELD("NS_Job Task No."),
                                                                                        "Job Planning Line No." = FIELD("NS_Line No.")));
            Caption = 'Qty. Transferred to Invoice';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(1081; "NS_Qty. to Transfer to Invoice"; Decimal)
        {
            Caption = 'Qty. to Transfer to Invoice';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(1090; "NS_Qty. Invoiced"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line Invoice"."Quantity Transferred" WHERE("Job No." = FIELD("NS_Job No."),
                                                                                        "Job Task No." = FIELD("NS_Job Task No."),
                                                                                        "Job Planning Line No." = FIELD("NS_Line No."),
                                                                                        "Document Type" = FILTER("Posted Invoice" | "Posted Credit Memo")));
            Caption = 'Qty. Invoiced';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(1091; "NS_Qty. to Invoice"; Decimal)
        {
            Caption = 'Qty. to Invoice';
            DecimalPlaces = 0 : 5;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(1100; "NS_Reserved Quantity"; Decimal)
        {
            AccessByPermission = TableData Item = R;
            CalcFormula = - Sum("Reservation Entry".Quantity WHERE("Source Type" = CONST(1003),
                                                                   "Source Subtype" = FIELD(NS_Status),
                                                                   "Source ID" = FIELD("NS_Job No."),
                                                                   "Source Ref. No." = FIELD("NS_Job Contract Entry No."),
                                                                   "Reservation Status" = CONST(Reservation)));
            Caption = 'Reserved Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(1101; "NS_Reserved Qty. (Base)"; Decimal)
        {
            AccessByPermission = TableData Item = R;
            CalcFormula = - Sum("Reservation Entry"."Quantity (Base)" WHERE("Source Type" = CONST(1003),
                                                                            "Source Subtype" = FIELD(NS_Status),
                                                                            "Source ID" = FIELD("NS_Job No."),
                                                                            "Source Ref. No." = FIELD("NS_Job Contract Entry No."),
                                                                            "Reservation Status" = CONST(Reservation)));
            Caption = 'Reserved Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(1102; NS_Reserve; Option)
        {
            AccessByPermission = TableData Item = R;
            DataClassification = CustomerContent;
            Caption = 'Reserve';
            OptionCaption = 'Never,Optional,Always';
            OptionMembers = Never,Optional,Always;
        }
        field(1103; NS_Planned; Boolean)
        {
            Caption = 'Planned';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(5402; "NS_Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            DataClassification = CustomerContent;
            TableRelation = IF (NS_Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("NS_No."));
        }
        field(5403; "NS_Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            DataClassification = CustomerContent;
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("NS_Location Code"));
        }
        field(5404; "NS_Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(5410; "NS_Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
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
            DataClassification = CustomerContent;
            TableRelation = "NS_Job Cost Category";
        }
        field(14021102; "NS_Revenue Category"; Code[10])
        {
            Caption = 'Revenue Category';
            DataClassification = CustomerContent;
            TableRelation = "NS_Job Revenue Category";
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
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(14021107; "NS_Activity Code"; Code[10])
        {
            Caption = 'Activity Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14021108; "NS_Process Code"; Code[10])
        {
            Caption = 'Process Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14021109; "NS_Operation Code"; Code[10])
        {
            Caption = 'Operation Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14021110; "NS_Section Code"; Code[10])//PRJ-774.AS.1.0 RollBAck old id 1402110 "NS_Section Code"
        {
            Caption = 'Section Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        //PRJ-688.AM.1.0
        field(14021115; "NS_Work Units"; Decimal)
        {
            Caption = 'Work Units';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
        }
        field(14021116; "NS_Work Unit of Measure"; Code[10])
        {
            Caption = 'Work Unit of Measure';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure";
        }
        field(14021118; "NS_Skill Class"; Code[10])
        {
            Caption = 'Skill Class';
            DataClassification = CustomerContent;
            TableRelation = "NS_Skill Class";
        }
        field(14021150; "NS_Entry Type"; Option)
        {
            Caption = 'Entry Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Cost,Both,Price';
            OptionMembers = Cost,Both,Price;
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
            DataClassification = CustomerContent;
            OptionCaption = '" ,Fixed,Time and Material,Cost Plus %,Cost Plus $"';
            OptionMembers = " ","Fixed","Time and Material","Cost Plus %","Cost Plus $";
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
            DataClassification = CustomerContent;
            TableRelation = NS_Subcontract."NS_No.";
        }
        field(14021325; "NS_Subcontract Line No."; Integer)
        {
            Caption = 'Subcontract Line No.';
            DataClassification = CustomerContent;
        }
        field(14021326; "NS_Progress Billing Method"; Option)
        {
            Caption = 'Progress Billing Method';
            DataClassification = CustomerContent;
            OptionCaption = ' ,%,Unit,L/S';
            OptionMembers = " ","%",Unit,"L/S";
        }
        field(14021327; "NS_Progress Payment Method"; Option)
        {
            Caption = 'Progress Payment Method';
            DataClassification = CustomerContent;
            OptionCaption = ' ,%,Unit,L/S';
            OptionMembers = " ","%",Unit,"L/S";
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
            Editable = false;
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
            DataClassification = CustomerContent;
            TableRelation = Vendor;
        }
        field(14021410; "NS_Vendor Quote No."; Text[30])
        {
            Caption = 'Vendor Quote No.';
            DataClassification = CustomerContent;
        }
        field(14021411; "NS_Manufacturer Code"; Code[10])
        {
            Caption = 'Manufacturer Code';
            DataClassification = CustomerContent;
            TableRelation = Manufacturer;
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
            DataClassification = CustomerContent;
            TableRelation = "NS_Job Takeoff Segments"."NS_Segment Code" WHERE("NS_Job No." = FIELD("NS_Job No."));
        }
        field(14021422; "NS_Segment Name"; Text[50])
        {
            CalcFormula = Lookup("NS_Job Takeoff Segments"."NS_Segment Name" WHERE("NS_Job No." = FIELD("NS_Job No."),
                                                                              "NS_Segment Code" = FIELD("NS_Segment Code")));
            Caption = 'Segment Name';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "NS_Job Takeoff Segments"."NS_Segment Name";
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
            Editable = false;
            TableRelation = "Dimension Set Entry";
            DataClassification = CustomerContent;
        }
        field(14021481; "NS_Retention Ledger Code"; Code[20])
        {
            Caption = 'Retention Ledger Code';
            DataClassification = CustomerContent;
            TableRelation = "NS_Retention Ledger Code".NS_Code;
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
        field(14021484; NS_Revision; Integer)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Job No.", "NS_Job Task No.", "NS_Line No.", NS_Revision)
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
        key(Key14; "NS_Job No.", "NS_Planning Date", "NS_Document No.")
        {
        }
    }

    fieldgroups
    {
    }

    procedure NS_AutoReserve();
    var
    // ReservMgt: Codeunit "Reservation Management";
    // FullAutoReservation: Boolean;
    // QtyToReserve: Decimal;
    // QtyToReserveBase: Decimal;
    begin
    end;

    procedure NS_Caption(): Text[250];
    var
        Job: Record Job;
        JobTask: Record "Job Task";
    begin
        if not Job.GET("NS_Job No.") then
            exit('');
        if not JobTask.GET("NS_Job No.", "NS_Job Task No.") then
            exit('');
        exit(STRSUBSTNO('%1 %2 %3 %4',
            Job."No.",
            Job.Description,
            JobTask."Job Task No.",
            JobTask.Description));
    end;

    procedure NS_DrillDownJobInvoices();
    var
    //JobInvoices: Page "Job Invoices";
    begin
    end;

    procedure NS_Overdue(): Boolean;
    begin
        if ("NS_Planning Date" < WORKDATE()) and ("NS_Remaining Qty." > 0) then
            exit(true);
        exit(false);
    end;
}

