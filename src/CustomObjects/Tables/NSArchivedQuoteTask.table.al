table 14021432 "NS_Archived Quote Task"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    //PRJ-301.MS.1.0 chnage length from 50 to 100
    // +------------------------------------------------------------

    //SMPL - Replaced DimensionManagement named reference to ID (symbols bug)

    Caption = 'Job Task';

    fields
    {
        field(1; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = CustomerContent;
            Editable = false;
            NotBlank = true;
            TableRelation = Job;
        }
        field(2; "NS_Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            DataClassification = CustomerContent;
            NotBlank = true;

            trigger OnValidate();
            var
            // Job: Record Job;
            // Cust: Record Customer;
            begin
            end;
        }
        field(3; NS_Description; Text[100])//PRJ-301.MS.1.0
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(4; "NS_Job Task Type"; Option)
        {
            Caption = 'Job Task Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Posting,Heading,Total,Begin-Total,End-Total';
            OptionMembers = Posting,Heading,Total,"Begin-Total","End-Total";
        }
        field(6; "NS_WIP-Total"; Option)
        {
            Caption = 'WIP-Total';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Total,Excluded';
            OptionMembers = " ",Total,Excluded;

            trigger OnValidate();
            var
            //Job: Record Job;
            begin
            end;
        }
        field(7; "NS_Job Posting Group"; Code[20])
        {
            Caption = 'Job Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "Job Posting Group";
        }
        field(9; "NS_WIP Method"; Code[20])
        {
            Caption = 'WIP Method';
            DataClassification = CustomerContent;
            TableRelation = "Job WIP Method".Code WHERE(Valid = CONST(true));
        }
        field(10; "NS_Schedule (Total Cost)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Job Planning Line"."Total Cost (LCY)" WHERE("Job No." = FIELD("NS_Job No."),
                                                                            "Job Task No." = FIELD("NS_Job Task No."),
                                                                            "Job Task No." = FIELD(FILTER(NS_Totaling)),
                                                                            "Schedule Line" = CONST(true),
                                                                            "Planning Date" = FIELD("NS_Planning Date Filter")));
            Caption = 'Budget (Total Cost)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "NS_Schedule (Total Price)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Job Planning Line"."Line Amount (LCY)" WHERE("Job No." = FIELD("NS_Job No."),
                                                                             "Job Task No." = FIELD("NS_Job Task No."),
                                                                             "Job Task No." = FIELD(FILTER(NS_Totaling)),
                                                                             "Schedule Line" = CONST(true),
                                                                             "Planning Date" = FIELD("NS_Planning Date Filter")));
            Caption = 'Budget (Total Price)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "NS_Usage (Total Cost)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Job Ledger Entry"."Total Cost (LCY)" WHERE("Job No." = FIELD("NS_Job No."),
                                                                           "Job Task No." = FIELD("NS_Job Task No."),
                                                                           "Job Task No." = FIELD(FILTER(NS_Totaling)),
                                                                           "Entry Type" = CONST(Usage),
                                                                           "Posting Date" = FIELD("NS_Posting Date Filter")));
            Caption = 'Usage (Total Cost)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "NS_Usage (Total Price)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Job Ledger Entry"."Line Amount (LCY)" WHERE("Job No." = FIELD("NS_Job No."),
                                                                            "Job Task No." = FIELD("NS_Job Task No."),
                                                                            "Job Task No." = FIELD(FILTER(NS_Totaling)),
                                                                            "Entry Type" = CONST(Usage),
                                                                            "Posting Date" = FIELD("NS_Posting Date Filter")));
            Caption = 'Usage (Total Price)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "NS_Contract (Total Cost)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Job Planning Line"."Total Cost (LCY)" WHERE("Job No." = FIELD("NS_Job No."),
                                                                            "Job Task No." = FIELD("NS_Job Task No."),
                                                                            "Job Task No." = FIELD(FILTER(NS_Totaling)),
                                                                            "Contract Line" = CONST(true),
                                                                            "Planning Date" = FIELD("NS_Planning Date Filter")));
            Caption = 'Billable (Total Cost)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "NS_Contract (Total Price)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Job Planning Line"."Line Amount (LCY)" WHERE("Job No." = FIELD("NS_Job No."),
                                                                             "Job Task No." = FIELD("NS_Job Task No."),
                                                                             "Job Task No." = FIELD(FILTER(NS_Totaling)),
                                                                             "Contract Line" = CONST(true),
                                                                             "Planning Date" = FIELD("NS_Planning Date Filter")));
            Caption = 'Billable (Total Price)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "NS_Contract (Invoiced Price)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = - Sum("Job Ledger Entry"."Line Amount (LCY)" WHERE("Job No." = FIELD("NS_Job No."),
                                                                             "Job Task No." = FIELD("NS_Job Task No."),
                                                                             "Job Task No." = FIELD(FILTER(NS_Totaling)),
                                                                             "Entry Type" = CONST(Sale),
                                                                             "Posting Date" = FIELD("NS_Posting Date Filter")));
            Caption = 'Billable (Invoiced Price)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "NS_Contract (Invoiced Cost)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = - Sum("Job Ledger Entry"."Total Cost (LCY)" WHERE("Job No." = FIELD("NS_Job No."),
                                                                            "Job Task No." = FIELD("NS_Job Task No."),
                                                                            "Job Task No." = FIELD(FILTER(NS_Totaling)),
                                                                            "Entry Type" = CONST(Sale),
                                                                            "Posting Date" = FIELD("NS_Posting Date Filter")));
            Caption = 'Billable (Invoiced Cost)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "NS_Posting Date Filter"; Date)
        {
            Caption = 'Posting Date Filter';
            FieldClass = FlowFilter;
        }
        field(20; "NS_Planning Date Filter"; Date)
        {
            Caption = 'Planning Date Filter';
            FieldClass = FlowFilter;
        }
        field(21; NS_Totaling; Text[250])
        {
            Caption = 'Totaling';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("NS_Job No."));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
        field(22; "NS_New Page"; Boolean)
        {
            Caption = 'New Page';
            DataClassification = CustomerContent;
        }
        field(23; "NS_No. of Blank Lines"; Integer)
        {
            BlankZero = true;
            Caption = 'No. of Blank Lines';
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(24; NS_Indentation; Integer)
        {
            Caption = 'Indentation';
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(34; "NS_Recognized Sales Amount"; Decimal)
        {
            BlankZero = true;
            Caption = 'Recognized Sales Amount';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(37; "NS_Recognized Costs Amount"; Decimal)
        {
            BlankZero = true;
            DataClassification = CustomerContent;
            Caption = 'Recognized Costs Amount';
            Editable = false;
        }
        field(56; "NS_Recognized Sales G/L Amount"; Decimal)
        {
            BlankZero = true;
            Caption = 'Recognized Sales G/L Amount';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(57; "NS_Recognized Costs G/L Amount"; Decimal)
        {
            BlankZero = true;
            Caption = 'Recognized Costs G/L Amount';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(60; "NS_Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(61; "NS_Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(62; "NS_Outstanding Orders"; Decimal)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            CalcFormula = Sum("Purchase Line"."Outstanding Amt. Ex. VAT (LCY)" WHERE("Document Type" = CONST(Order),
                                                                                      "Job No." = FIELD("NS_Job No."),
                                                                                      "Job Task No." = FIELD("NS_Job Task No."),
                                                                                      "Job Task No." = FIELD(FILTER(NS_Totaling))));
            Caption = 'Outstanding Orders';
            FieldClass = FlowField;
        }
        field(63; "NS_Amt. Rcd. Not Invoiced"; Decimal)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            CalcFormula = Sum("Purchase Line"."A. Rcd. Not Inv. Ex. VAT (LCY)" WHERE("Document Type" = CONST(Order),
                                                                                      "Job No." = FIELD("NS_Job No."),
                                                                                      "Job Task No." = FIELD("NS_Job Task No."),
                                                                                      "Job Task No." = FIELD(FILTER(NS_Totaling))));
            Caption = 'Amt. Rcd. Not Invoiced';
            FieldClass = FlowField;
        }
        field(64; "NS_Remaining (Total Cost)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Job Planning Line"."Remaining Total Cost (LCY)" WHERE("Job No." = FIELD("NS_Job No."),
                                                                                      "Job Task No." = FIELD("NS_Job Task No."),
                                                                                      "Job Task No." = FIELD(FILTER(NS_Totaling)),
                                                                                      "Schedule Line" = CONST(true),
                                                                                      "Planning Date" = FIELD("NS_Planning Date Filter")));
            Caption = 'Remaining (Total Cost)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(65; "NS_Remaining (Total Price)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Job Planning Line"."Remaining Line Amount (LCY)" WHERE("Job No." = FIELD("NS_Job No."),
                                                                                       "Job Task No." = FIELD("NS_Job Task No."),
                                                                                       "Job Task No." = FIELD(FILTER(NS_Totaling)),
                                                                                       "Schedule Line" = CONST(true),
                                                                                       "Planning Date" = FIELD("NS_Planning Date Filter")));
            Caption = 'Remaining (Total Price)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(66; "NS_Start Date"; Date)
        {
            CalcFormula = Min("Job Planning Line"."Planning Date" WHERE("Job No." = FIELD("NS_Job No."),
                                                                         "Job Task No." = FIELD("NS_Job Task No.")));
            Caption = 'Start Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(67; "NS_End Date"; Date)
        {
            CalcFormula = Max("Job Planning Line"."Planning Date" WHERE("Job No." = FIELD("NS_Job No."),
                                                                         "Job Task No." = FIELD("NS_Job Task No.")));
            Caption = 'End Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14021100; "NS_Percent Complete"; Decimal)
        {
            Caption = 'Percent Complete';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(14021101; "NS_Estimated Hours"; Decimal)
        {
            Caption = 'Estimated Hours';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(14021102; "NS_Total Hours Applied"; Decimal)
        {
            CalcFormula = Sum("Job Ledger Entry".Quantity WHERE("Job No." = FIELD("NS_Job No."),
                                                                 "Job Task No." = FIELD("NS_Job Task No.")));
            Caption = 'Total Hours Applied';
            FieldClass = FlowField;
        }
        field(14021103; "NS_Percent Materials"; Decimal)
        {
            Caption = 'Percent Materials';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(14021104; "NS_Invoice Due Date"; Date)
        {
            Caption = 'Invoice Due Date';
            DataClassification = CustomerContent;
        }
        field(14021105; NS_Revision; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(14021120; "NS_Burden Percent"; Decimal)
        {
            Caption = 'Burden Percent';
            DataClassification = CustomerContent;
        }
        field(14021140; "NS_Total Percent Complete"; Decimal)
        {
            Caption = 'Total Percent Complete';
            DataClassification = CustomerContent;
        }
        field(14021141; "NS_Total Percent Complete Date"; Date)
        {
            Caption = 'Total Percent Complete Date';
            DataClassification = CustomerContent;
        }
        field(14021142; "NS_Billing Percent"; Decimal)
        {
            Caption = 'Billing Percent';
            DataClassification = CustomerContent;
        }
        field(14021143; "NS_Billing Percent Date"; Date)
        {
            Caption = 'Billing Percent Date';
            DataClassification = CustomerContent;
        }
        field(14021190; "NS_Task Before"; Code[20])
        {
            Caption = 'Task Before';
            DataClassification = CustomerContent;
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("NS_Job No."));
        }
        field(14021191; "NS_Task After"; Code[20])
        {
            Caption = 'Task After';
            DataClassification = CustomerContent;
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("NS_Job No."));
        }
        field(14021192; "NS_Task Start Date"; Date)
        {
            Caption = 'Task Start Date';
            DataClassification = CustomerContent;
        }
        field(14021193; "NS_Task End Date"; Date)
        {
            Caption = 'Task End Date';
            DataClassification = CustomerContent;
        }
        field(14021194; "NS_Task Lag Days"; Decimal)
        {
            Caption = 'Task Lag Days';
            DataClassification = CustomerContent;
        }
        field(14021195; "NS_Task Days"; Decimal)
        {
            Caption = 'Task Days';
            DataClassification = CustomerContent;
        }
        field(14021196; "NS_Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource;
            DataClassification = CustomerContent;
        }
        field(14021197; "NS_Start Date Fixed"; Boolean)
        {
            Caption = 'Start Date Fixed';
            DataClassification = CustomerContent;
        }
        field(14021198; NS_Manager; Code[20])
        {
            Caption = 'Manager';
            TableRelation = Resource WHERE(Type = CONST(Person));
            DataClassification = CustomerContent;
        }
        field(14021400; "NS_Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            DataClassification = CustomerContent;
        }
        field(14021401; "NS_Mark-up"; Decimal)
        {
            Caption = 'Mark-up';
            DataClassification = CustomerContent;
        }
        field(14021402; "NS_Gross Profit Percentage"; Decimal)
        {
            Caption = 'Gross Profit Percentage';
            DataClassification = CustomerContent;
        }
        field(14021403; "NS_Gross Profit"; Decimal)
        {
            Caption = 'Gross Profit';
            DataClassification = CustomerContent;
        }
        field(14021404; "NS_Quantity Weighted"; Boolean)
        {
            Caption = 'Quantity Weighted';
            DataClassification = CustomerContent;
        }
        field(14021405; "NS_Cost Weighted"; Boolean)
        {
            Caption = 'Cost Weighted';
            DataClassification = CustomerContent;
        }
        field(14021408; "NS_Line Amount Incl. Tax"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."NS_Line Amount Incl. Tax" WHERE("Job No." = FIELD("NS_Job No."),
                                                                                 "Job Task No." = FIELD("NS_Job Task No."),
                                                                                 "Job Task No." = FIELD(FILTER(NS_Totaling)),
                                                                                 "Schedule Line" = CONST(true),
                                                                                 "Planning Date" = FIELD("NS_Planning Date Filter")));
            Caption = 'Line Amount Incl. Tax';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14021409; "NS_Template No."; Code[20])
        {
            Caption = 'Template No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Job No.", "NS_Job Task No.", NS_Revision)
        {
            SumIndexFields = "NS_Recognized Sales Amount", "NS_Recognized Costs Amount", "NS_Recognized Sales G/L Amount", "NS_Recognized Costs G/L Amount";
        }
        key(Key2; "NS_Job Task No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(NS_DropDown; "NS_Job No.", "NS_Job Task No.", NS_Description, "NS_Job Task Type")
        {
        }
    }

    trigger OnInsert();
    begin
        Job.GET("NS_Job No.");
    end;

    var
        Job: Record Job;

    procedure NS_ClearTempDim();
    var
        DimMgt: Codeunit 408;
    begin
        DimMgt.DeleteJobTaskTempDim();
    end;

    procedure NS_CalcEACTotalCost(): Decimal;
    begin
        if "NS_Job No." <> Job."No." then
            if not Job.GET("NS_Job No.") then
                exit(0);

        if Job."Apply Usage Link" then
            exit("NS_Usage (Total Cost)" + "NS_Remaining (Total Cost)");

        exit(0);
    end;

    procedure NS_CalcEACTotalPrice(): Decimal;
    begin
        if "NS_Job No." <> Job."No." then
            if not Job.GET("NS_Job No.") then
                exit(0);

        if Job."Apply Usage Link" then
            exit("NS_Usage (Total Price)" + "NS_Remaining (Total Price)");

        exit(0);
    end;
}

