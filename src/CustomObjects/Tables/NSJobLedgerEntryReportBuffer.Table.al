table 14021191 "NS_Job LedgerEntryReportBuffer"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-831.AS.2.0 Obsele the fields "NS_Gen. Prod. Posting Group",  "NS_Gen. Bus. Posting Group" and Added "NS_Gen. Prod. Posting Group New",  "NS_Gen. Bus. Posting Group New" for replacement of these


    Caption = 'Job Ledger Entry Report Buffer';
    DrillDownPageID = "Job Ledger Entries";
    LookupPageID = "Job Ledger Entries";

    fields
    {
        field(1; "NS_Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(2; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
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
        field(8; NS_Description; Text[50])
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
            AutoFormatExpression = "NS_Currency Code";
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
            Editable = false;
            TableRelation = "Resource Group";
            DataClassification = CustomerContent;
        }
        field(17; "NS_Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (NS_Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("NS_No."))
            ELSE
            IF (NS_Type = CONST(Resource)) "Resource Unit of Measure".Code WHERE("Resource No." = FIELD("NS_No."));
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
            TableRelation = "Inventory Posting Group";
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
        field(33; "NS_Customer Price Group"; Code[10])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
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
        field(60; "NS_Amt. to Post to G/L"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amt. to Post to G/L';
            DataClassification = CustomerContent;
        }
        field(61; "NS_Amt. Posted to G/L"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amt. Posted to G/L';
            DataClassification = CustomerContent;
        }
        field(64; "NS_Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Usage,Sale,Release,Earn,Payment';
            OptionMembers = Usage,Sale,Release,Earn,Payment;
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
        field(80; "NS_Gen. Bus. Posting Group"; Code[10])
        {
            ObsoleteState = Pending;//PRJ-831.AS.2.0 13OCT2021 Obselete
            ObsoleteReason = 'Will be removed in next build';//PRJ-831.AS.2.0 13OCT2021 Obselete
            Caption = 'Gen. Bus. Posting Group';
            //TableRelation = "Gen. Business Posting Group";//PRJ-1684.AS.1.0 TABLE RELATION REMOVED
            DataClassification = CustomerContent;
        }
        field(81; "NS_Gen. Prod. Posting Group"; Code[10])
        {
            ObsoleteState = Pending;//PRJ-831.AS.2.0 13OCT2021 Obselete
            ObsoleteReason = 'Will be removed in next build';//PRJ-831.AS.2.0 13OCT2021 Obselete
            Caption = 'Gen. Prod. Posting Group';
            //TableRelation = "Gen. Product Posting Group";//PRJ-1684.AS.1.0 TABLE RELATION REMOVED
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

        field(95; "NS_Gen. Bus. Posting Group New"; Code[20])//PRJ-831.AS.2.0 13OCT2021 New Field
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
            DataClassification = CustomerContent;
        }
        field(96; "NS_Gen. Prod. Posting Group New"; Code[20])//PRJ-831.AS.2.0 13OCT2021 New Field
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
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
        field(1000; "NS_Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("NS_Job No."));
            DataClassification = CustomerContent;
        }
        field(1001; "NS_Line Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Amount ($)';
            Editable = false;
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
            Editable = false;
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
        field(1016; "NS_Description 2"; Text[50])
        {
            Caption = 'Description 2';
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
        field(1023; "NS_Original Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Original Unit Cost ($)';
            Editable = false;
            DataClassification = CustomerContent;

        }
        field(1024; "NS_Original Total Cost (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Original Total Cost ($)';
            Editable = false;
            DataClassification = CustomerContent;

        }
        field(1025; "NS_Original Unit Cost"; Decimal)
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
        field(1028; NS_Adjusted; Boolean)
        {
            Caption = 'Adjusted';
            DataClassification = CustomerContent;

        }
        field(1029; "NS_DateTime Adjusted"; DateTime)
        {
            Caption = 'DateTime Adjusted';
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
        field(5900; "NS_Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
            DataClassification = CustomerContent;

        }
        field(5901; "NS_Posted Service Shipment No."; Code[20])
        {
            Caption = 'Posted Service Shipment No.';
            DataClassification = CustomerContent;

        }
        field(14021101; "NS_Job Cost Category"; Code[10])
        {
            Caption = 'Job Cost Category';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Cost Category";
            DataClassification = CustomerContent;

        }
        field(14021102; "NS_Job Revenue Category"; Code[10])
        {
            Caption = 'Job Revenue Category';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Revenue Category";
            DataClassification = CustomerContent;

        }
        //PRJ-688.AM.1.0
        field(14021106; "NS_Section Code"; Code[10])
        {
            Caption = 'Section Code';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;

        }
        //PRJ-688.AM.1.0
        field(14021107; "NS_Activity Code"; Code[10])
        {
            Caption = 'Activity Code';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;

        }
        field(14021108; "NS_Process Code"; Code[10])
        {
            Caption = 'Process Code';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;

        }
        field(14021109; "NS_Operation Code"; Code[10])
        {
            Caption = 'Operation Code';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;

        }
        field(14021110; "NS_Work Units"; Decimal)
        {
            Caption = 'Work Units';
            DecimalPlaces = 2 : 2;
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

        }
        field(14021111; "NS_Work Unit of Measure"; Code[10])
        {
            Caption = 'Work Unit of Measure';
            Description = 'ProjectPro';
            TableRelation = "Unit of Measure";
            DataClassification = CustomerContent;

        }
        field(14021112; "NS_Burden Amount"; Decimal)
        {
            Caption = 'Burden Amount';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

        }
        field(14021113; "NS_Burden Type"; Option)
        {
            Caption = 'Burden Type';
            Description = 'ProjectPro';
            OptionCaption = ' ,Project,Service';
            OptionMembers = " ",Project,Service;
            DataClassification = CustomerContent;

        }
        field(14021114; "NS_Burden Amount Posted to G/L"; Decimal)
        {
            Caption = 'Burden Amount Posted to G/L';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

        }
        field(14021115; "NS_Burden Posting Document No."; Code[20])
        {
            Caption = 'Burden Posting Document No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

        }
        field(14021116; "NS_Burden Job Cost Category"; Code[10])
        {
            Caption = 'Burden Job Cost Category';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Cost Category".NS_Code WHERE(NS_Type = CONST(Labor));
            DataClassification = CustomerContent;

        }
        field(14021120; "NS_External Relationship Type"; Option)
        {
            Caption = 'External Relationship Type';
            Description = 'ProjectPro';
            OptionCaption = ' ,Customer,Vendor';
            OptionMembers = " ",Customer,Vendor;
            DataClassification = CustomerContent;

        }
        field(14021121; "NS_External Relationship No."; Code[20])
        {
            Caption = 'External Relationship No.';
            Description = 'ProjectPro';
            TableRelation = IF ("NS_External Relationship Type" = CONST(Customer)) Customer."No."
            ELSE
            IF ("NS_External Relationship Type" = CONST(Vendor)) Vendor."No.";
            DataClassification = CustomerContent;

        }
        field(14021122; "NS_External Relationship Name"; Text[50])
        {
            Caption = 'External Relationship Name';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

        }
        field(14021130; "NS_Payroll Burden Amount"; Decimal)
        {
            Caption = 'Payroll Burden Amount';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

        }
        field(14021134; "NS_Payroll Burden Job Cost Cat"; Code[10])
        {
            Caption = 'Payroll Burden Job Cost Cat';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Cost Category".NS_Code WHERE(NS_Type = CONST(Labor));
            DataClassification = CustomerContent;

        }
        field(14021135; "NS_Employee Wage Rate"; Decimal)
        {
            Caption = 'Employee Wage Rate';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

        }
        field(14021136; "NS_Employee Fringe - Insurance"; Decimal)
        {
            Caption = 'Employee Fringe - Insurance';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

        }
        field(14021137; "NS_Employee Fringe - Vacation"; Decimal)
        {
            Caption = 'Employee Fringe - Vacation';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

        }
        field(14021138; "NS_Employee Fringe - Education"; Decimal)
        {
            Caption = 'Employee Fringe - Education';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

        }
        field(14021139; "NS_Employee Fringe - Misc. 1"; Decimal)
        {
            Caption = 'Employee Fringe - Misc. 1';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

        }
        field(14021140; "NS_Employee Fringe - Misc. 2"; Decimal)
        {
            Caption = 'Employee Fringe - Misc. 2';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

        }
        field(14021141; "NS_Employee Fringe - Misc. 3"; Decimal)
        {
            Caption = 'Employee Fringe - Misc. 3';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

        }
        field(14021142; "NS_Employee Fringe Total"; Decimal)
        {
            Caption = 'Employee Fringe Total';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

        }
        field(14021143; "NS_Prevailing Wage Rate"; Decimal)
        {
            Caption = 'Prevailing Wage Rate';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

        }
        field(14021144; "NS_Prevailing Fringe Rate"; Decimal)
        {
            Caption = 'Prevailing Fringe Rate';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

        }
        field(14021145; "NS_Wage Calculation Basis"; Text[80])
        {
            Caption = 'Wage Calculation Basis';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

        }
        field(14021150; "NS_Exclude Entry"; Boolean)
        {
            Caption = 'Exclude Entry';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

        }
        field(14021186; "NS_Skill Class"; Code[10])
        {
            Caption = 'Skill Class';
            Description = 'ProjectPro';
            TableRelation = "NS_Skill Class";
            DataClassification = CustomerContent;

        }
        field(14021200; "NS_Sale Or Usage Flag"; Integer)
        {
            Caption = 'Sale Or Usage Flag';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

        }
        field(14021201; "NS_Sale Or Cost Flag"; Integer)
        {
            Caption = 'Sale Or Cost Flag';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

        }
        field(14021300; "NS_Subcontract No."; Code[20])
        {
            Caption = 'Subcontract No.';
            Description = 'ProjectPro';
            TableRelation = NS_Subcontract;
            DataClassification = CustomerContent;

        }
        field(14021301; "NS_Retention Ledger Code"; Code[20])
        {
            Caption = 'Retention Ledger Code';
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            DataClassification = CustomerContent;

        }
        field(14021375; "NS_Payroll Work State"; Text[30])
        {
            Caption = 'Payroll Work State';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

        }
        field(14021376; "NS_Jobsite Work"; Boolean)
        {
            Caption = 'Jobsite Work';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

        }
    }

    keys
    {
        key(Key1; "NS_Entry No.")
        {
        }
        key(Key2; "NS_Job No.", "NS_Activity Code", "NS_Sale Or Usage Flag", "NS_Job Revenue Category", "NS_Job Cost Category", NS_Type, "NS_Posting Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(NS_DropDown; "NS_Entry No.", "NS_Job No.", "NS_Posting Date", "NS_Document No.")
        {
        }
    }

    trigger OnInsert();
    begin
        NS_Job.NS_JobTaskNoToAPO("NS_Job Task No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code");//PRJ-688.AM.1.0
        NS_BurdenSettings();
    end;

    trigger OnModify();
    begin
        NS_Job.NS_JobTaskNoToAPO("NS_Job Task No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code");//PRJ-688.AM.1.0
        NS_BurdenSettings();
    end;

    var
        NS_Job: Record Job;
        DimMgt: Codeunit DimensionManagement;

        Text14021100_Txt: Label '%1 in Job Setup can not be blank when using labor burdens.', Comment = '%1 = Payroll Burden Job Cost Cat';

    procedure NS_ShowDimensions();
    begin
        DimMgt.ShowDimensionSet("NS_Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "NS_Entry No."));
    end;

    procedure NS_BurdenSettings();
    var
        NS_GLSetup: Record "General Ledger Setup";
        NS_JobsSetup: Record "Jobs Setup";
    begin
        NS_GLSetup.GET();
        NS_JobsSetup.GET();
        if "NS_Burden Amount" <> 0 then
            if "NS_Burden Job Cost Category" = '' then
                if NS_JobsSetup."NS_Burden Job Cost Category" <> '' then
                    "NS_Burden Job Cost Category" := NS_JobsSetup."NS_Burden Job Cost Category"
                else
                    ERROR(Text14021100_Txt, NS_JobsSetup.FIELDCAPTION("NS_Burden Job Cost Category"));
        if "NS_Payroll Burden Amount" <> 0 then
            if "NS_Payroll Burden Job Cost Cat" = '' then
                if NS_JobsSetup."NS_Payroll Burden Job Cost Cat" <> '' then
                    "NS_Payroll Burden Job Cost Cat" := NS_JobsSetup."NS_Payroll Burden Job Cost Cat"
                else
                    ERROR(Text14021100_Txt, NS_JobsSetup.FIELDCAPTION("NS_Payroll Burden Job Cost Cat"));
        "NS_Total Cost" := ROUND("NS_Unit Cost" * NS_Quantity, NS_GLSetup."Appln. Rounding Precision") + "NS_Payroll Burden Amount" + "NS_Burden Amount";
    end;

    //SMPL Replaced DimensionManagement named reference to ID (symbols bug)
}

