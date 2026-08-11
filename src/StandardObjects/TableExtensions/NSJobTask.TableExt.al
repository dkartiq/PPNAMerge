tableextension 14021213 NS_JobTask extends "Job Task"
{
    // version NAVW111.00.00.22292,PPNA11.00
    //PRJ-1.0.SK    18JUNE2019  Added code in CreateFakeCustomer function
    //CTSI-22.MS-1.001 24 March 2020 added three new fields of hours
    //PRJ-419.MS.1.0 code comment
    //PRJ-807.RS.1.0 9July21 | Ability to Assign Work Units and Work Units Of Measure at Job Task Line
    //PRJ-1015.JS.1.0 05Oct2021 | Add one field and code
    //PRJ-999.JS.1.0 12Nov2021 | Add code for dimension
    //PRJ-1042.JS.1.0  15Dec2021 | Add procedure
    //PRJ-1083.JS.1.0  17Dec2021 | Add code to total work units
    //PRJ-1136.NK.1.0 21Jan2022 | Removed with statement
    //PRJ-1127.JS.1.0 28JAN2022 | Write code to Validate work unit
    //PRJ-1184.JS.1.0 10FEB2022 | Add fields
    //PRJ-1299.JS.1.0 18APR2022 | Add one field
    //PRJ-689.DK.1.0 14Dec2022 | Added a Field
    //PE-90.AS.1.0 Added Field
    //PE-210.HS.1.0 23Nov2023| Add Code
    fields
    {

        modify("Job Task No.")
        {
            trigger OnBeforeValidate()
            begin
                NS_IsFakeCustomer := CreateFakeCustomer();
            end;

            trigger OnAfterValidate()
            var
                NS_JobSubLevels: Record "NS_Job Include Sub Levels";
                NS_Jobs: Record Job;
            begin
                DeleteFakeCustomer(NS_IsFakeCustomer);
                //PRJ-1015.JS.1.0  05Oct2021 Start
                if (("Job Task No." <> '') and ("Job Task Type" = "Job Task Type"::Posting)) then begin
                    if NS_Jobs1.Get("Job No.") then begin   //PRJ-999.JS.1.0 modify line
                        "NS_Sub-Level to Job No." := NS_Jobs1."NS_Sub-Level to Job No.";
                        //PRJ-999.JS.1.0 12Nov2021 Start
                        "Global Dimension 1 Code" := NS_Jobs1."Global Dimension 1 Code";
                        "Global Dimension 2 Code" := NS_Jobs1."Global Dimension 2 Code";
                        //PRJ-999.JS.1.0 12Nov2021 End                            
                    end;
                    If not NS_JobSubLevels.get("Job No.", "Job Task No.") then
                        If NS_Jobs.Get("Job No.") then begin
                            NS_JobSubLevels.Init();
                            NS_JobSubLevels."NS_Job No." := Rec."Job No.";
                            NS_JobSubLevels."NS_Job Task No." := Rec."Job Task No.";
                            NS_JobSubLevels."NS_Sub Level Job No." := NS_Jobs."NS_Sub-Level to Job No.";
                            NS_JobSubLevels."NS_Job Class" := NS_Jobs."NS_Job Class";
                            NS_JobSubLevels.Insert();
                        end;
                end;
                //PRJ-1015.JS.1.0  05Oct2021 end                  
            end;
        }

        //PRJ-999.JS.1.0  19Nov2021 Start
        modify("Global Dimension 1 Code")
        {
            trigger OnAfterValidate()
            var
                NS_JobPlanninLine: Record "Job Planning Line";
            begin
                if Rec."Global Dimension 1 Code" <> xRec."Global Dimension 1 Code" then begin
                    NS_JobPlanninLine.Reset();
                    NS_JobPlanninLine.SetRange("Job No.", Rec."Job No.");
                    NS_JobPlanninLine.SetRange("Job Task No.", Rec."Job Task No.");
                    if NS_JobPlanninLine.FindSet() then
                        //NS_JobPlanninLine."NS_Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
                        NS_JobPlanninLine.ModifyAll("NS_Shortcut Dimension 1 Code", Rec."Global Dimension 1 Code");
                end;
            end;
        }

        modify("Global Dimension 2 Code")
        {
            trigger OnAfterValidate()
            var
                NS_JobPlanninLine: Record "Job Planning Line";
            begin
                if Rec."Global Dimension 2 Code" <> xRec."Global Dimension 2 Code" then begin
                    NS_JobPlanninLine.Reset();
                    NS_JobPlanninLine.SetRange("Job No.", Rec."Job No.");
                    NS_JobPlanninLine.SetRange("Job Task No.", Rec."Job Task No.");
                    if NS_JobPlanninLine.FindSet() then
                        //NS_JobPlanninLine."NS_Shortcut Dimension 2 Code" := Rec."Global Dimension 2 Code";
                        NS_JobPlanninLine.ModifyAll("NS_Shortcut Dimension 2 Code", Rec."Global Dimension 2 Code");
                end;
            end;
        }

        //PRJ-999.JS.1.0  19Nov2021 Start

        field(14021100; "NS_Percent Complete"; Decimal)
        {
            Caption = 'Percent Complete';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'ProjectPro';
        }
        field(14021101; "NS_Estimated Hours"; Decimal)
        {
            Caption = 'Estimated Hours';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'ProjectPro';
        }
        field(14021102; "NS_Total Hours Applied"; Decimal)
        {
            CalcFormula = Sum("Job Ledger Entry".Quantity WHERE("Job No." = FIELD("Job No."),
                                                                 "Job Task No." = FIELD("Job Task No.")));
            Caption = 'Total Hours Applied';
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        field(14021103; "NS_Percent Materials"; Decimal)
        {
            Caption = 'Percent Materials';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'ProjectPro';
        }
        field(14021104; "NS_Invoice Due Date"; Date)
        {
            Caption = 'Invoice Due Date';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';

        }
        field(14021120; "NS_Burden Percent"; Decimal)
        {
            Caption = 'Burden Percent';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021140; "NS_Total Percent Complete"; Decimal)
        {
            Caption = 'Total Percent Complete';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021141; "NS_Total Percent Complete Date"; Date)
        {
            Caption = 'Total Percent Complete Date';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021142; "NS_Billing Percent"; Decimal)
        {
            Caption = 'Billing Percent';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021143; "NS_Billing Percent Date"; Date)
        {
            Caption = 'Billing Percent Date';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                Job: Record job;
            begin
                //ProjectPro - start
                Job.get("Job No.");
                "NS_Billing Percent Date" := Job.GetBillDate("NS_Billing Percent Date", "Job No.");
                //ProjectPro - end
            end;
        }
        field(14021190; "NS_Task Before"; Code[20])
        {
            Caption = 'Task Before';
            Description = 'ProjectPro';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
            DataClassification = CustomerContent;
        }
        field(14021191; "NS_Task After"; Code[20])
        {
            Caption = 'Task After';
            Description = 'ProjectPro';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
            DataClassification = CustomerContent;
        }
        field(14021192; "NS_Task Start Date"; Date)
        {
            Caption = 'Task Start Date';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021193; "NS_Task End Date"; Date)
        {
            Caption = 'Task End Date';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021194; "NS_Task Lag Days"; Decimal)
        {
            Caption = 'Task Lag Days';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021195; "NS_Task Days"; Decimal)
        {
            Caption = 'Task Days';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021196; "NS_Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            Description = 'ProjectPro';
            TableRelation = Resource;
            DataClassification = CustomerContent;
        }
        field(14021197; "NS_Start Date Fixed"; Boolean)
        {
            Caption = 'Start Date Fixed';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021198; NS_Manager; Code[20])
        {
            Caption = 'Manager';
            Description = 'ProjectPro';
            TableRelation = Resource WHERE(Type = CONST(Person));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                NS_JobForecast.RESET;
                NS_JobForecast.SETRANGE("NS_Job No.", "Job No.");
                NS_JobForecast.SETRANGE("NS_Job Task No.", "Job Task No.");
                if NS_JobForecast.FINDSET then
                    repeat
                        NS_JobForecast."NS_Task Manager" := NS_Manager;
                        NS_JobForecast.MODIFY;
                    until NS_JobForecast.NEXT = 0;
                //ProjectPro - end
            end;
        }
        field(14021400; "NS_Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021401; "NS_Mark-up"; Decimal)
        {
            Caption = 'Mark-up';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Mark-up" <> xRec."NS_Mark-up" then begin
                    QuoteMgt.NS_CalcAmounts(Rec, xRec, 0);
                    CalcSalesTax("Job No.", "Job Task No.");
                end;
            end;
        }
        field(14021402; "NS_Gross Profit Percentage"; Decimal)
        {
            Caption = 'Gross Profit Percentage';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Gross Profit Percentage" <> xRec."NS_Gross Profit Percentage" then begin
                    QuoteMgt.NS_CalcAmounts(Rec, xRec, 2);
                    CalcSalesTax("Job No.", "Job Task No.");
                end;
            end;
        }
        field(14021403; "NS_Gross Profit"; Decimal)
        {
            Caption = 'Gross Profit';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Gross Profit" <> xRec."NS_Gross Profit" then begin
                    QuoteMgt.NS_CalcAmounts(Rec, xRec, 1);
                    CalcSalesTax("Job No.", "Job Task No.");
                end;
            end;
        }
        field(14021404; "NS_Quantity Weighted"; Boolean)
        {
            Caption = 'Quantity Weighted';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Quantity Weighted" then
                    "NS_Cost Weighted" := false;
            end;
        }
        field(14021405; "NS_Cost Weighted"; Boolean)
        {
            Caption = 'Cost Weighted';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Cost Weighted" then
                    "NS_Quantity Weighted" := false;
            end;
        }
        field(14021408; "NS_Line Amount Incl. Tax"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."NS_Line Amount Incl. Tax" WHERE("Job No." = FIELD("Job No."),
                                                                                 "Job Task No." = FIELD("Job Task No."),
                                                                                 "Job Task No." = FIELD(FILTER(Totaling)),
                                                                                 "Schedule Line" = CONST(true),
                                                                                 "Planning Date" = FIELD("Planning Date Filter")));
            Caption = 'Line Amount Incl. Tax';
            Description = 'ProjectPro';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14021409; "NS_Template No."; Code[20])
        {
            Caption = 'Template No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021410; "NS_Budgeted Hours"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line".Quantity WHERE("Job No." = FIELD("Job No."),
                                                                                 "Job Task No." = FIELD("Job Task No."),
                                                                                 "Job Task No." = FIELD(FILTER(Totaling)),
                                                                                 "Schedule Line" = CONST(true),
                                                                                 "Planning Date" = FIELD("Planning Date Filter"),
                                                                                 "line type" = filter(Budget),
                                                                                 "Type" = filter(Resource),
                                                                                 "Unit of Measure Code" = filter('HR' | 'HOUR')));//PRJ-1524.GK.1.0 25July2022
            Caption = 'Budgeted Hours';
            Description = 'CTSI-22';
            Editable = false;
            FieldClass = FlowField;
        }

        field(14021411; "NS_Actual Hours"; Decimal)
        {
            CalcFormula = Sum("Job Ledger Entry".Quantity WHERE("Job No." = FIELD("Job No."),
                                                                                 "Job Task No." = FIELD("Job Task No."),
                                                                                 "Job Task No." = FIELD(FILTER(Totaling)),
                                                                                 "Entry Type" = filter(Usage),
                                                                                 "Posting Date" = FIELD("Planning Date Filter"),
                                                                                 "Type" = filter(Resource),
                                                                                 "Unit of Measure Code" = filter('HR' | 'HOUR')));//PRJ-1524.GK.1.0 25July2022
            Caption = 'Actual Hours';
            Description = 'CTSI-22';
            Editable = false;
            FieldClass = FlowField;

        }

        field(14021412; "NS_Remaining Hours"; Decimal)
        {
            Caption = 'Remaining Hours';
            Description = 'CTSI-22';
            DataClassification = CustomerContent;
        }
        //PRJ-807.RS.1.0 9July21 Start
        field(14021413; "NS_Work Units"; Decimal)
        {
            Caption = 'Work Units';
            DataClassification = CustomerContent;

        }
        field(14021414; "NS_Work Unit of Measure"; Code[10])
        {
            Caption = 'Work Unit of Measure';
            TableRelation = "Unit of Measure".Code;
            DataClassification = CustomerContent;

            //PRJ-1083.JS.1.0 17Dec2021 -Start
            trigger OnValidate()
            var
                NS_JobPlanLine: Record "Job Planning Line";
                NS_JobLedgerEntry: Record "Job Ledger Entry";  //PRJ-1127.JS.1.0 28JAN2022
                NS_SalesLine: Record "Sales Line";  //PRJ-1127.JS.1.0 28JAN2022
                NS_PurchaseLine: Record "Purchase Line";  //PRJ-1127.JS.1.0 28JAN2022
                UserStp: Record "User Setup";//PRJ-1405.AS.1.0 02MAY2022
                JobStp: Record "Jobs Setup";//PRJ-1405.AS.1.0 02MAY2022
                JLEnt: Record "Job Ledger Entry";//PRJ-1405.AS.1.0 02MAY2022
            begin
                //PRJ-1405.AS.1.0 02MAY2022 START
                if UserStp.get(UserId) then;
                if JobStp.get then;

                if (JobStp."NS_Force change Work UOM" = true) and (UserStp."NS_Force change work UOM" = true) then begin
                    JLEnt.Reset();
                    JLEnt.SetRange("Job No.", Rec."Job No.");
                    JLEnt.SetRange("Job Task No.", Rec."Job Task No.");
                    JLEnt.CalcSums(Quantity);
                    JLEnt.CalcSums("NS_Work Units");

                    // if (JLEnt.Quantity = 0) and (JLEnt."NS_Work Units" = 0) then begin //PE-173.JS.1.0 110Ct2023 Commented
                    if (JLEnt.Quantity <> 0) and (JLEnt."NS_Work Units" = 0) then begin   ////PE-173.JS.1.0 110Ct2023 line added 
                        if "NS_Work Unit of Measure" <> '' then begin
                            NS_JobPlanLine.Reset();
                            NS_JobPlanLine.SetRange("Job No.", Rec."Job No.");
                            NS_JobPlanLine.SetRange("Job Task No.", Rec."Job Task No.");
                            NS_JobPlanLine.SetFilter("Line Type", '<>%1', NS_JobPlanLine."Line Type"::Billable);
                            NS_JobPlanLine.SetFilter(Quantity, '<>%1', 0);
                            NS_JobPlanLine.SetRange("NS_Work Unit of Measure", Rec."NS_Work Unit of Measure");
                            If NS_JobPlanLine.FindSet() then begin
                                NS_JobPlanLine.CalcSums("NS_Work Units");
                                if NS_JobPlanLine."NS_Work Units" <> 0 then begin
                                    Rec."NS_Work Units" := 0;
                                    Rec."NS_Work Units" := NS_JobPlanLine."NS_Work Units";
                                    Rec.Modify()
                                end;
                            end;
                        end;
                    end ELSE begin
                        //PRJ-1127.JS.1.0 28JAN2022-Start
                        NS_JobLedgerEntry.Reset();
                        NS_JobLedgerEntry.SetRange("Job No.", Rec."Job No.");
                        NS_JobLedgerEntry.SetRange("Job Task No.", Rec."Job Task No.");
                        If NS_JobLedgerEntry.FindFirst() then
                            Error('Job Ledger Entry Already Exist Against this task');

                        NS_SalesLine.Reset();
                        NS_SalesLine.SetRange("Job No.", Rec."Job No.");
                        NS_SalesLine.SetRange("Job Task No.", Rec."Job Task No.");
                        if NS_SalesLine.FindFirst() then
                            Error('This task is already used on sales document no. %1 on line no. %2', NS_SalesLine."Document No.", NS_SalesLine."Line No.");

                        NS_PurchaseLine.Reset();
                        NS_PurchaseLine.SetRange("Job No.", Rec."Job No.");
                        NS_PurchaseLine.SetRange("Job Task No.", Rec."Job Task No.");
                        if NS_PurchaseLine.FindFirst() then
                            Error('This task is already used on purchase document no. %1 on line no. %2', NS_PurchaseLine."Document No.", NS_PurchaseLine."Line No.");

                        if "NS_Work Unit of Measure" <> '' then begin
                            NS_JobPlanLine.Reset();
                            NS_JobPlanLine.SetRange("Job No.", Rec."Job No.");
                            NS_JobPlanLine.SetRange("Job Task No.", Rec."Job Task No.");
                            NS_JobPlanLine.SetFilter("Line Type", '<>%1', NS_JobPlanLine."Line Type"::Billable);
                            NS_JobPlanLine.SetFilter(Quantity, '<>%1', 0);
                            NS_JobPlanLine.SetRange("NS_Work Unit of Measure", Rec."NS_Work Unit of Measure");
                            If NS_JobPlanLine.FindSet() then begin
                                NS_JobPlanLine.CalcSums("NS_Work Units");
                                if NS_JobPlanLine."NS_Work Units" <> 0 then begin
                                    Rec."NS_Work Units" := 0;
                                    Rec."NS_Work Units" := NS_JobPlanLine."NS_Work Units";
                                    Rec.Modify();
                                end;
                            end;
                        end;
                        //PRJ-1127.JS.1.0 28JAN2022-end                            
                    end;

                end else begin // Applied Old PRJ-1127 conditions in begin..end START
                               //PRJ-1405.AS.1.0 02MAY2022 END

                    //PRJ-1127.JS.1.0 28JAN2022-Start
                    NS_JobLedgerEntry.Reset();
                    NS_JobLedgerEntry.SetRange("Job No.", Rec."Job No.");
                    NS_JobLedgerEntry.SetRange("Job Task No.", Rec."Job Task No.");
                    If NS_JobLedgerEntry.FindFirst() then
                        Error('Job Ledger Entry Already Exist Against this task');

                    NS_SalesLine.Reset();
                    NS_SalesLine.SetRange("Job No.", Rec."Job No.");
                    NS_SalesLine.SetRange("Job Task No.", Rec."Job Task No.");
                    if NS_SalesLine.FindFirst() then
                        Error('This task is already used on sales document no. %1 on line no. %2', NS_SalesLine."Document No.", NS_SalesLine."Line No.");

                    NS_PurchaseLine.Reset();
                    NS_PurchaseLine.SetRange("Job No.", Rec."Job No.");
                    NS_PurchaseLine.SetRange("Job Task No.", Rec."Job Task No.");
                    if NS_PurchaseLine.FindFirst() then
                        Error('This task is already used on purchase document no. %1 on line no. %2', NS_PurchaseLine."Document No.", NS_PurchaseLine."Line No.");

                    if "NS_Work Unit of Measure" <> '' then begin
                        NS_JobPlanLine.Reset();
                        NS_JobPlanLine.SetRange("Job No.", Rec."Job No.");
                        NS_JobPlanLine.SetRange("Job Task No.", Rec."Job Task No.");
                        NS_JobPlanLine.SetFilter("Line Type", '<>%1', NS_JobPlanLine."Line Type"::Billable);
                        NS_JobPlanLine.SetFilter(Quantity, '<>%1', 0);
                        NS_JobPlanLine.SetRange("NS_Work Unit of Measure", Rec."NS_Work Unit of Measure");
                        If NS_JobPlanLine.FindSet() then begin
                            NS_JobPlanLine.CalcSums("NS_Work Units");
                            if NS_JobPlanLine."NS_Work Units" <> 0 then begin
                                Rec."NS_Work Units" := 0;
                                Rec."NS_Work Units" := NS_JobPlanLine."NS_Work Units";
                                Rec.Modify()
                            end;
                        end;
                    end;
                    //PRJ-1127.JS.1.0 28JAN2022-end
                end;// Applied Old PRJ-1127 conditions in begin..end END

            end;
            //PRJ-1083.JS.1.0 17Dec2021 -end            

        }
        //PRJ-807.RS.1.0 9July21 End
        field(14021415; "NS_Sub-Level to Job No."; Code[20])   //PRJ-1015.JS.1.0  //19Oct2021
        {
            Caption = 'Sub-Level to Job No.';
            DataClassification = CustomerContent;
            Editable = false;

        }
        //PRJ-1184.JS.1.0 10FEB2022 - Start
        field(14021420; "NS_Change Orders"; Decimal)
        {

            DataClassification = CustomerContent;
            Caption = 'Change Orders';
            Editable = false;

        }
        field(14021421; NS_Reallocations; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Reallocations';
            Editable = false;
        }
        field(14021422; "NS_Net Budget"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Net Budget';
            Editable = false;
        }
        field(14021423; "NS_Usage (Total Cost) New"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Usage (Total Cost)';
            Editable = false;
        }

        field(14021424; "NS_Contract (Total Cost) New"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Billable (Total Cost)';
        }
        field(14021425; "NS_Contract (Inv. Price) New"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Billable (Invoiced Price)';
        }
        field(14021426; "NS_Remaining (Total Cost) New"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Remaining (Total Cost)';
        }
        field(14021427; "NS_Remaining (Total Price) New"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Remaining (Total Price)';
        }
        field(14021428; "NS_Contract (Total Price) New"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Job Planning Line"."Line Amount (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                             "Job Task No." = FIELD("Job Task No."),
                                                                             "Job Task No." = FIELD(FILTER(Totaling)),
                                                                             "Contract Line" = CONST(true),
                                                                             "Line Type" = filter(<> Billable),
                                                                             "Planning Date" = FIELD("Planning Date Filter")));
            Caption = 'Billable (Total Price)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14021429; "NS_Unbilled Revenue"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Job Planning Line"."Line Amount (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                             "Job Task No." = FIELD("Job Task No."),
                                                                             "Job Task No." = FIELD(FILTER(Totaling)),
                                                                             "Contract Line" = CONST(true),
                                                                             "Line Type" = filter(Billable),
                                                                             "Qty. Invoiced" = filter(= 0),
                                                                             "Planning Date" = FIELD("Planning Date Filter")));
            Caption = 'Unbilled Revenue';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14021430; "NS_Committed Costs"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Committed Costs';

        }
        field(14021431; "NS_Subcontract Value"; Decimal)
        {
            Caption = 'Subcontract Value';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(14021432; "NS_Usage TotCost Change Order"; Decimal)
        {
            Caption = 'Usage Total Sub Levels';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(14021433; "NS_Usage Total Actual Cost"; Decimal)
        {
            Caption = 'Net (Actual Cost)';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(14021435; "NS_Net Total Contract Price"; Decimal)
        {
            Caption = 'Net (Contract Price)';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(14021436; "NS_Contract Price Sub Levels"; Decimal)
        {
            Caption = 'Sub Level (Contract Price)';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021437; "NS_Invoiced Price Sub Levels"; Decimal)
        {
            Caption = 'Sub Level (Invoiced Price)';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021438; "NS_Net Invoiced Price"; Decimal)
        {
            Caption = 'Net Invoiced Price';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021439; "NS_Committed Costs Sub levels"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Sub Levels (Committed Costs)';
        }
        field(14021440; "NS_Net Committed Costs"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Net Committed Costs';

        }
        field(14021441; "NS_Committed Costs Master Job"; Decimal)
        {

            Editable = false;
            Caption = 'Committed Costs';
            DataClassification = CustomerContent;

        }
        field(14021442; "NS_Unbilled Revenue New"; Decimal)
        {
            Caption = 'Unbilled Revenue';
            DataClassification = CustomerContent;
            AutoFormatType = 1;
            BlankZero = true;
            Editable = false;
        }

        field(14021443; "NS_Subcon. Value Sub Levels"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Sub Level Subcon. Value';
            Editable = false;
        }
        field(14021444; "NS_Net Subcontract Value"; Decimal)
        {
            Caption = 'Net Subcontract Value';
            Editable = false;
            DataClassification = CustomerContent;
        }
        //PRJ-1184.JS.1.0 11FEB2022 - end

        field(14021445; "NS_Revision No."; Integer)//PRJ-1163.AS.3.0 ADD FIELD
        {
            Caption = 'Revision No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        //PRJ-1189.GK.1.0 06apr2022 start
        field(14021446; "NS_Contract Forecast Date"; Date)
        {
            Caption = 'Contract Forecast Date';
            FieldClass = FlowFilter;
        }
        //PRJ-1189.GK.1.0 06apr2022 end

        //PRJ-1264.AS.1.0 START
        field(14021447; "NS_Act"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(14021448; "NS_Proc"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(14021449; "NS_Opr"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(14021450; "NS_Sec"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        //PRJ-1264.AS.1.0 END

        //PRJ-1299.JS.1.0 18APR2022 - start
        field(14021451; "NS_Forecast By Task Totals"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Forecast By Task Totals';

            trigger OnValidate()
            var
                NSJobs: Record Job;
            begin
                if "NS_Forecast By Task Totals" = true then begin
                    if NSJobs.Get(rec."Job No.") then
                        NSJobs.Testfield("NS_Forecast Method", NSJobs."NS_Forecast Method"::"Job Forecast by Task Totals");
                    if ((Rec."Job Task Type" <> Rec."Job Task Type"::Total) and
                        (rec."Job Task Type" <> Rec."Job Task Type"::"End-Total")) then
                        Error('Job Task Type should be Total or End-Total only');
                end;
            end;
        }
        //PRJ-1299.JS.1.0 18APR2022 - end

        //PRJ-689.DK.1.0 14Dec2022 start
        field(14021452; "NS_JobNo_JobTaskLine"; code[40])
        {
            DataClassification = CustomerContent;
            Caption = 'Job ExpandColl Key';
        }
        //PRJ-689.DK.1.0 14Dec2022 end

        //PE-90.AS.1.0 START
        field(14021453; "NS_ForecastedCompCostOverride"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Forecasted Completed Cost Over-ride';
            //BlankZero = true; //PE-282.JS.1.0 06MAY2024
            Editable = true;
            MinValue = 0;  //PRJCTPR-345.JS.1.0 21APR2024

            //PRJCTPR-345.JS.1.0 21APR2024 - Start
            trigger OnValidate()
            var
                NS1JobsRec: Record job; //PE-299.JS.1.0 17MAY024
            begin
                if NS1JobsRec.get(rec."Job No.") then;   //PE-299.JS.1.0 17MAY024
                rec.CalcFields("Usage (Total Cost)");
                //PE-282.JS.1.0 06MAY2024-Start
                if NS_ForecastedCompCostOverride > 0 then
                    if (rec."Job Task Type" <> rec."Job Task Type"::Posting) then
                        error('"Job Task Type" should be Posting only.');
                //if "NS_ForecastedCompCostOverride" < rec."Usage (Total Cost)" then
                case "NS_ForecastedCompCostOverride" of
                    1 .. rec."Usage (Total Cost)" - 1:
                        error('The "Forecast Completed Cost Override" can either be 0 or equal to "Actual (Total Cost).". It cannot be less than the "Actual (Total Cost)".');
                end;
                //PE-282.JS.1.0 06MAY2024-end
                //PE-299.JS.1.0 17MAY024-Start
                if NS1JobsRec."NS_Push-OrV2JFWForecastedonJTL" = true then
                    "NS_JFW Forecast Completed Cost" := "NS_ForecastedCompCostOverride";
                //PE-299.JS.1.0 17MAY024-true    
            end;
            //PRJCTPR-345.JS.1.0 21APR2024 - end
        }
        //PE-90.AS.1.0 END
        //PE-210.HS.1.0 23Nov2023 Start
        field(14021454; "NS_JobTaskStatus"; Enum NS_JobTaskLineStatus)
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
        }
        //PE-210.HS.1.0 23Nov2023 End
        //PE-193.PS.3.0 27Dec2023 Start
        field(14021455; "NS_Change Request Budget"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Change Request Budget';
        }
        field(14021456; "NS_Change Request Billable"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Change Request Billable.';
        }
        //PE-193.PS.3.0 27Dec2023 

        //PE-287.JS.1.0 28APR2024 - Start
        field(14021458; "NS_JFW Forecast Completed Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'JFW Forecasted Completed Cost';
            Editable = false;
            trigger OnValidate()
            begin
                if (rec."Job Task Type" = rec."Job Task Type"::Heading) or
                    (rec."Job Task Type" = rec."Job Task Type"::"Begin-Total") then
                    error('"Job Task Type" should not be "Heading" or "Begin-Total"');
            end;
        }
        //PE-287.JS.1.0 28APR2024 - end

        //PE-288.JS.1.0 06MAY2024 - Start
        field(14021459; NSJobTaskStatus; Enum NSJobTaskLineStatusNew)
        {
            Caption = 'Job Task Status';
            DataClassification = CustomerContent;
        }
        //PE-288.JS.1.0 06MAY2024 - end 
    }

    //PRJ-1264.AS.1.0 START ADDED KEY
    keys
    {
        key(Key3; NS_Act, NS_Proc)
        {
        }
    }
    //PRJ-1264.AS.1.0 END


    fieldgroups
    {
        addlast(DropDown; "Job No.") { }
    }

    trigger OnBeforeInsert()
    begin
        NS_IsFakeCustomer := CreateFakeCustomer();
    end;

    trigger OnInsert()
    var
        QuoteHeader: Record "NS_Job Quote Header";
        NS_JobSubLevels: Record "NS_Job Include Sub Levels";    //PRJ-1015.JS.1.0   05Oct2021
        NS_Jobs: Record Job;  //PRJ-1015.JS.1.0   06Oct2021          
    begin

        DeleteFakeCustomer(NS_IsFakeCustomer);

        //ProjectPro - start
        "NS_Burden Percent" := NS_GetDefaultAPOBurdenPercent(NS_FakeJob, "Job Task No.");
        NS_UpdateForecastWorksheet("Job No.", "Job Task No.", "NS_Total Percent Complete Date", "NS_Total Percent Complete", "NS_Billing Percent Date", "NS_Billing Percent");
        IF (QuoteHeader.GET("Job No.")) AND ("NS_Quote No." = '') THEN
            "NS_Quote No." := "Job No.";
        //ProjectPro - end
        //PRJ-1015.JS.1.0  05Oct2021 Start

        If (("Job Task Type" = "Job Task Type"::Posting) and ("Job Task No." <> '')) then begin
            if NS_Jobs1.Get("Job No.") then begin   //PRJ-999.JS.1.0 modify line
                "NS_Sub-Level to Job No." := NS_Jobs1."NS_Sub-Level to Job No.";
                //PRJ-999.JS.1.0 12Nov2021 Start
                "Global Dimension 1 Code" := NS_Jobs1."Global Dimension 1 Code";
                "Global Dimension 2 Code" := NS_Jobs1."Global Dimension 2 Code";
                //PRJ-999.JS.1.0 12Nov2021 End
            end;

            If not NS_JobSubLevels.get("Job No.", "Job Task No.") then
                If NS_Jobs.Get("Job No.") then begin
                    NS_JobSubLevels.Init();
                    NS_JobSubLevels."NS_Job No." := Rec."Job No.";
                    NS_JobSubLevels."NS_Job Task No." := Rec."Job Task No.";
                    NS_JobSubLevels."NS_Sub Level Job No." := NS_Jobs."NS_Sub-Level to Job No.";
                    NS_JobSubLevels."NS_Job Class" := NS_Jobs."NS_Job Class";
                    NS_JobSubLevels.Insert();
                end;
        end;

        //PRJ-1015.JS.1.0  05Oct2021 end        
    end;

    trigger OnModify()
    begin
        //ProjectPro - start
        NS_UpdateForecastWorksheet("Job No.", "Job Task No.", "NS_Total Percent Complete Date", "NS_Total Percent Complete", "NS_Billing Percent Date", "NS_Billing Percent");
        //ProjectPro - end
    end;

    PROCEDURE JobLedgEntriesExist(): Boolean
    VAR
        JobLedgEntry: Record 169;
    BEGIN
        JobLedgEntry.SETCURRENTKEY("Job No.", "Job Task No.");
        JobLedgEntry.SETRANGE("Job No.", "Job No.");
        JobLedgEntry.SETRANGE("Job Task No.", "Job Task No.");
        EXIT(JobLedgEntry.FINDFIRST)
    END;

    PROCEDURE JobPlanningLinesExist(): Boolean;
    VAR
        JobPlanningLine: Record 1003;
    BEGIN
        JobPlanningLine.SETCURRENTKEY("Job No.", "Job Task No.");
        JobPlanningLine.SETRANGE("Job No.", "Job No.");
        JobPlanningLine.SETRANGE("Job Task No.", "Job Task No.");
        EXIT(JobPlanningLine.FINDFIRST)
    END;

    PROCEDURE NS_GetJobTaskDescription(JobNo: Code[20]; JobTaskNo: Code[35]): Text[100];//PRJ-449.AM.1.0
    VAR
        NS_Job: Record 167;
        NS_ActivityCode: Code[10];
        NS_ProcessCode: Code[10];
        NS_OperationCode: Code[10];
        NS_SectionCode: Code[10];//PRJ-688.AM.1.0
        NS_JobActivityRec: Record "NS_Job Activity";
        NS_JobProcessRec: Record "NS_Job Process";
        NS_JobOperationRec: Record "NS_Job Operation";
    BEGIN
        //ProjectPro - start
        Description := '';
        IF (JobNo > '') AND (JobTaskNo > '') THEN BEGIN
            NS_Job.NS_JobTaskNoToAPO(JobTaskNo, NS_ActivityCode, NS_ProcessCode, NS_OperationCode, NS_SectionCode);//PRJ-688.AM.1.0

            IF NS_OperationCode > '' THEN BEGIN
                IF NS_JobOperationRec.GET(0, NS_ActivityCode, NS_ProcessCode, NS_OperationCode) THEN
                    Description := NS_JobOperationRec.NS_Description
                ELSE
                    IF NS_JobOperationRec.GET(1, NS_ActivityCode, NS_ProcessCode, NS_OperationCode) THEN
                        Description := NS_JobOperationRec.NS_Description
                    ELSE
                        Description := Text14021100;
            END ELSE BEGIN
                IF NS_ProcessCode > '' THEN BEGIN
                    IF NS_JobProcessRec.GET(0, NS_ActivityCode, NS_ProcessCode) THEN
                        Description := NS_JobProcessRec.NS_Description
                    ELSE
                        IF NS_JobProcessRec.GET(1, NS_ActivityCode, NS_ProcessCode) THEN
                            Description := NS_JobProcessRec.NS_Description
                        ELSE
                            Description := Text14021100;
                END ELSE
                    IF NS_ActivityCode > '' THEN
                        IF NS_JobActivityRec.GET(0, NS_ActivityCode) THEN
                            Description := NS_JobActivityRec.NS_Description
                        ELSE
                            IF NS_JobActivityRec.GET(1, NS_ActivityCode) THEN
                                Description := NS_JobActivityRec.NS_Description
                            ELSE
                                Description := Text14021100;
            END;
        END;

        EXIT(Description);
        //ProjectPro - end
    END;

    PROCEDURE NS_GetDefaultAPOBurdenPercent(Job: Record 167; JobTaskNo: Code[35]): Decimal;
    VAR
        JobWork: Record 167;
        JobTaskWork: Record 1001;
        JobActivity: Record "NS_Job Activity";
        JobProcess: Record "NS_Job Process";
        JobOperation: Record "NS_Job Operation";
        Activity: Code[10];
        Process: Code[10];
        Operation: Code[10];
        Section: Code[10];//PRJ-688.AM.1.0
        BurdenPercent: Decimal;
    BEGIN
        //ProjectPro - start

        //This routine reads the master APO tables to fill in a Burden Percent on a Job Task.  By looking at a Job's Indirect Burden Type and
        //  the JobTaskNo passed in, this routine will look at the master APO tables to return the correct Burden Percent for the JobTaskNo.

        BurdenPercent := 0;

        IF JobWork.GET(Job."No.") THEN
            IF JobTaskWork.GET(JobWork."No.", JobTaskNo) THEN BEGIN
                JobWork.NS_JobTaskNoToAPO(JobTaskNo, Activity, Process, Operation, Section);//PRJ-688.AM.1.0
                CASE TRUE OF
                    Operation > '':
                        IF JobOperation.GET(JobOperation.NS_Type::Cost, Activity, Process, Operation) THEN
                            CASE Job."NS_Indirect Burden Type" OF
                                Job."NS_Indirect Burden Type"::Project:
                                    BurdenPercent := JobOperation."NS_DefaultProjectBurdenPercent";
                                Job."NS_Indirect Burden Type"::Service:
                                    BurdenPercent := JobOperation."NS_DefaultServiceBurdenPercent";
                            END;
                    Process > '':
                        IF JobProcess.GET(JobProcess.NS_Type::Cost, Activity, Process) THEN
                            CASE Job."NS_Indirect Burden Type" OF
                                Job."NS_Indirect Burden Type"::Project:
                                    BurdenPercent := JobProcess."NS_DefaultProjectBurdenPercent";
                                Job."NS_Indirect Burden Type"::Service:
                                    BurdenPercent := JobProcess."NS_DefaultServiceBurdenPercent";
                            END;
                    Activity > '':
                        IF JobActivity.GET(JobActivity.NS_Type::Cost, Activity) THEN
                            CASE Job."NS_Indirect Burden Type" OF
                                Job."NS_Indirect Burden Type"::Project:
                                    BurdenPercent := JobActivity."NS_DefaultProjectBurdenPerc";
                                Job."NS_Indirect Burden Type"::Service:
                                    BurdenPercent := JobActivity."NS_DefaultServiceBurdenPerc";
                            END;
                END;
            END;

        EXIT(BurdenPercent);
        //ProjectPro - end
    END;

    PROCEDURE NS_GetTaskBurdenPercent(Job: Record 167; JobTaskNo: Code[35]): Decimal;
    VAR
        JobWork: Record 167;
        JobTaskWork: Record 1001;
        BurdenPercent: Decimal;
    BEGIN
        //ProjectPro - start

        //This routine returns the correct Burden Percent for a Job's Task.

        BurdenPercent := 0;

        IF JobWork.GET(Job."No.") THEN
            IF JobTaskWork.GET(JobWork."No.", JobTaskNo) THEN BEGIN
                BurdenPercent := JobTaskWork."NS_Burden Percent";
            END;

        EXIT(BurdenPercent);
        //ProjectPro - end
    END;
    //PRJ-419 comment start
    PROCEDURE NS_UpdateForecastWorksheet(JobNo: Code[20]; JobTaskNo: Code[20]; StatusDate: Date; TotalPct: Decimal; BillDate: Date; BillPct: Decimal);
    VAR
        JobForecast: Record "NS_Job Forecast";
        Found: Boolean;
    BEGIN
        //ProjectPro - start
        //WITH JobForecast DO BEGIN
        //    Found := FALSE;
        //    RESET;
        //    SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date");
        //    SETRANGE("NS_Job No.", JobNo);
        //    SETRANGE("NS_Job Task No.", JobTaskNo);
        //    SETRANGE(NS_Posted, FALSE);
        //    IF FINDSET(TRUE) THEN
        //        Found := TRUE;
        //    IF NOT Found THEN BEGIN
        //        VALIDATE("NS_Job No.", JobNo);
        //        VALIDATE("NS_Job Task No.", JobTaskNo);
        //        "NS_Line No." := 100;
        //        INSERT;
        //        Found := TRUE;
        //    END;

        //    "NS_Status Date" := StatusDate;
        //    "NS_Percent Complete" := TotalPct;
        //    "NS_Bill Date" := BillDate;
        //    "NS_Bill Percent" := BillPct;

        //    MODIFY;
        //END;
        //ProjectPro - end
    END;
    //PRJ-419 comment end

    PROCEDURE NS_POsRecdAndOtstndngByExptRcptDate(JobNo: Code[20]; JobTask: Code[20]; ThroughDate: Date) Total: Decimal;
    VAR
        PurchaseLine: Record 39;
        ItemLedgEntry: Record 32;
        PeriodPurchase: Decimal;
        MonthStartDate: Date;
        MonthEndDate: Date;
    BEGIN
        //ProjectPro - start

        //POs Received and Outstanding by Expected Receipt Date
        //
        //Reviews Purchase Order Lines for the Job where the Expected Receipt Date is in the same month as the ThroughDate.
        //The amount returned is the value of any received amount this month plus any amount yet to be received for these lines.

        Total := 0;

        IF (JobNo > '') AND (ThroughDate > 0D) THEN BEGIN
            MonthStartDate := DMY2DATE(1, DATE2DMY(ThroughDate, 2), DATE2DMY(ThroughDate, 3));
            IF DATE2DMY(ThroughDate, 2) < 12 THEN
                MonthEndDate := DMY2DATE(1, DATE2DMY(ThroughDate, 2) + 1, DATE2DMY(ThroughDate, 3)) - 1
            ELSE
                MonthEndDate := DMY2DATE(31, 12, DATE2DMY(ThroughDate, 3));

            WITH PurchaseLine DO BEGIN
                RESET;
                SETCURRENTKEY("Job No.");
                SETRANGE("Job No.", JobNo);
                SETRANGE("Job Task No.", JobTask);
                SETFILTER("Expected Receipt Date", '%1..%2', MonthStartDate, MonthEndDate);
                IF FINDSET THEN
                    REPEAT
                        Total := Total + "Outstanding Amount";
                        ItemLedgEntry.RESET;
                        ItemLedgEntry.SETCURRENTKEY("Job No.", "Job Task No.", "Entry Type", "Document Date");
                        ItemLedgEntry.SETRANGE("Job No.", JobNo);
                        ItemLedgEntry.SETRANGE("Job Task No.", JobTask);
                        ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Purchase);
                        ItemLedgEntry.SETFILTER("Document Date", '%1..%2', MonthStartDate, MonthEndDate);
                        IF ItemLedgEntry.FINDSET THEN
                            REPEAT
                                ItemLedgEntry.CALCFIELDS("Cost Amount (Actual)");
                                Total := Total + ItemLedgEntry."Cost Amount (Actual)"
                            UNTIL ItemLedgEntry.NEXT = 0;

                    UNTIL NEXT = 0;
            END;
        END;

        EXIT(Total);
        //ProjectPro - end
    END;

    LOCAL PROCEDURE CalcSalesTax(JobNo: Code[20]; JobTaskNo: Code[20]);
    VAR
        lJobPlanLine: Record 1003;
    BEGIN
        lJobPlanLine.RESET;
        lJobPlanLine.SETRANGE("Job No.", JobNo);
        lJobPlanLine.SETRANGE("Job Task No.", JobTaskNo);
        IF lJobPlanLine.FINDSET(TRUE, FALSE) THEN
            REPEAT
                lJobPlanLine.VALIDATE(Quantity);
            UNTIL lJobPlanLine.NEXT = 0;
    END;

    //SPLN 1.0 Start
    local procedure CreateFakeCustomer() IsFakeCustCreate: Boolean
    begin
        //NS_FakeCust.Get("Job No.") //PRJ-1.0.SK Commented
        IF NS_FakeJob.Get("Job No.") Then; //PRJ-1.0.SK Added
        IF NS_FakeCust.Get("Job No.") Then; //PRJ-1.0.SK Added
        NS_BillToCustNo := NS_FakeJob."Bill-to Customer No.";

        if NS_FakeCust."Bill-to Customer No." = '' then begin
            NS_FakeCust."Bill-to Customer No." := '1';
            NS_FakeJob.Modify();
        end;

        if not NS_FakeCust.Get(NS_FakeJob."Bill-to Customer No.") then begin
            NS_FakeCust."Bill-to Customer No." := NS_FakeJob."Bill-to Customer No.";
            NS_FakeCust.Insert();
            exit(true);
        end;

        exit(false);

    end;

    local procedure DeleteFakeCustomer(IsFakeCustCreated: Boolean)
    begin
        NS_FakeJob."Bill-to Customer No." := NS_BillToCustNo;
        NS_FakeJob.Modify();

        if IsFakeCustCreated then begin
            NS_FakeCust.Delete();
        end;
    end;
    //SPLN 1.0 End
    //PRJ-1015.JS.1.0 19Oct2021 Start
    PROCEDURE NS_POsRecdAndOtstndngByExptRcptDateIncludeSubLevels(JobNo: Code[20]; JobTask: Code[20]; ThroughDate: Date) Total: Decimal;
    VAR
        PurchaseLine: Record 39;
        ItemLedgEntry: Record 32;
        PeriodPurchase: Decimal;
        MonthStartDate: Date;
        MonthEndDate: Date;
        JobNoFilter: Code[20];
    BEGIN
        //ProjectPro - start

        //POs Received and Outstanding by Expected Receipt Date
        //
        //Reviews Purchase Order Lines for the Job where the Expected Receipt Date is in the same month as the ThroughDate.
        //The amount returned is the value of any received amount this month plus any amount yet to be received for these lines.

        Total := 0;
        JobNoFilter := '';
        JobNoFilter := '@*' + format(JobNo) + '*';

        IF (JobNo > '') AND (ThroughDate > 0D) THEN BEGIN
            MonthStartDate := DMY2DATE(1, DATE2DMY(ThroughDate, 2), DATE2DMY(ThroughDate, 3));
            IF DATE2DMY(ThroughDate, 2) < 12 THEN
                MonthEndDate := DMY2DATE(1, DATE2DMY(ThroughDate, 2) + 1, DATE2DMY(ThroughDate, 3)) - 1
            ELSE
                MonthEndDate := DMY2DATE(31, 12, DATE2DMY(ThroughDate, 3));
            //PRJ-1136.NK.1.0 Start
            //WITH PurchaseLine DO BEGIN
            PurchaseLine.RESET();
            PurchaseLine.SETCURRENTKEY("Job No.");
            //SETRANGE("Job No.", JobNo);
            PurchaseLine.setfilter("Job No.", '%1', JobNoFilter);
            PurchaseLine.SETRANGE("Job Task No.", JobTask);
            PurchaseLine.SETFILTER("Expected Receipt Date", '%1..%2', MonthStartDate, MonthEndDate);
            IF PurchaseLine.FINDSET() THEN
                REPEAT
                    Total := Total + PurchaseLine."Outstanding Amount";
                    ItemLedgEntry.RESET();
                    ItemLedgEntry.SETCURRENTKEY("Job No.", "Job Task No.", "Entry Type", "Document Date");
                    ItemLedgEntry.SETRANGE("Job No.", JobNo);
                    ItemLedgEntry.SETRANGE("Job Task No.", JobTask);
                    ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Purchase);
                    ItemLedgEntry.SETFILTER("Document Date", '%1..%2', MonthStartDate, MonthEndDate);
                    IF ItemLedgEntry.FINDSET() THEN
                        REPEAT
                            ItemLedgEntry.CALCFIELDS("Cost Amount (Actual)");
                            Total := Total + ItemLedgEntry."Cost Amount (Actual)"
                        UNTIL ItemLedgEntry.NEXT() = 0;

                UNTIL PurchaseLine.NEXT() = 0;
            //END;
            //PRJ-1136.NK.1.0 End
        END;

        EXIT(Total);
        //PRJ-1015.JS.1.0 19Oct2021 end
    END;

    //PRJ-1042.JS.1.0  15Dec2021-Start    
    procedure NS_IndentJobTask(JobNo: Code[20])
    var
        SelectionFilterManagement: Codeunit "SelectionFilterManagement";
        JobTaskNo: array[10] of Text;
        ArrayExceededErr: Label 'You can only indent %1 levels for job tasks of the type Begin-Total.', Comment = '%1 = A number bigger than 1';
        NS_Text005: Label 'End-Total %1 is missing a matching Begin-Total.';
        JobTask: Record "Job Task";
        Window: Dialog;
        i: Integer;
    begin
        JobTask.SetRange("Job No.", JobNo);
        with JobTask do
            if Find('-') then
                repeat

                    if "Job Task Type" = "Job Task Type"::"End-Total" then begin
                        if i < 1 then
                            Error(
                              NS_Text005,
                              "Job Task No.");

                        Totaling := JobTaskNo[i] + '..' + SelectionFilterManagement.AddQuotes("Job Task No.");
                        i := i - 1;
                    end;

                    Indentation := i;
                    Modify;

                    if "Job Task Type" = "Job Task Type"::"Begin-Total" then begin
                        i := i + 1;
                        if i > ArrayLen(JobTaskNo) then
                            Error(ArrayExceededErr, ArrayLen(JobTaskNo));
                        JobTaskNo[i] := SelectionFilterManagement.AddQuotes("Job Task No.");
                    end;
                until Next() = 0;
    end;
    //PRJ-1042.JS.1.0  15Dec2021-Start


    //PRJ-1299.JS.1.0 25APR2022 - Start
    PROCEDURE NS_POsRecdAndOtstndngByExptRcptDateFBTT(JobNo: Code[20]; JobTask: Code[20]; ThroughDate: Date) Total: Decimal;
    VAR
        PurchaseLine: Record 39;
        ItemLedgEntry: Record 32;
        PeriodPurchase: Decimal;
        MonthStartDate: Date;
        MonthEndDate: Date;
    BEGIN
        //ProjectPro - start

        //POs Received and Outstanding by Expected Receipt Date
        //
        //Reviews Purchase Order Lines for the Job where the Expected Receipt Date is in the same month as the ThroughDate.
        //The amount returned is the value of any received amount this month plus any amount yet to be received for these lines.

        Total := 0;

        IF (JobNo > '') AND (ThroughDate > 0D) THEN BEGIN
            MonthStartDate := DMY2DATE(1, DATE2DMY(ThroughDate, 2), DATE2DMY(ThroughDate, 3));
            IF DATE2DMY(ThroughDate, 2) < 12 THEN
                MonthEndDate := DMY2DATE(1, DATE2DMY(ThroughDate, 2) + 1, DATE2DMY(ThroughDate, 3)) - 1
            ELSE
                MonthEndDate := DMY2DATE(31, 12, DATE2DMY(ThroughDate, 3));

            PurchaseLine.RESET();
            PurchaseLine.SETCURRENTKEY("Job No.");
            PurchaseLine.SETRANGE("Job No.", JobNo);
            PurchaseLine.SETRANGE("Job Task No.", JobTask);
            PurchaseLine.SETFILTER("Expected Receipt Date", '%1..%2', MonthStartDate, MonthEndDate);
            IF PurchaseLine.FINDSET() THEN
                REPEAT
                    Total := Total + PurchaseLine."Outstanding Amount";
                    ItemLedgEntry.RESET();
                    ItemLedgEntry.SETCURRENTKEY("Job No.", "Job Task No.", "Entry Type", "Document Date");
                    ItemLedgEntry.SETRANGE("Job No.", JobNo);
                    ItemLedgEntry.SETRANGE("Job Task No.", JobTask);
                    ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Purchase);
                    ItemLedgEntry.SETFILTER("Document Date", '%1..%2', MonthStartDate, MonthEndDate);
                    IF ItemLedgEntry.FINDSET() THEN
                        REPEAT
                            ItemLedgEntry.CALCFIELDS("Cost Amount (Actual)");
                            Total := Total + ItemLedgEntry."Cost Amount (Actual)"
                        UNTIL ItemLedgEntry.NEXT() = 0;

                UNTIL PurchaseLine.NEXT() = 0;
        END;
        EXIT(Total);
    END;
    //PRJ-1299.JS.1.0 25APR2022 - Start

    //PE-299.JS.1.0 17MAY024-Start
    procedure NS_UpdJobForecastOverrideCostToJFWForecastedCostonJTL(var NSPassTaskLine: Record "Job Task");
    var
        NS1JobTask: Record "Job Task";
        NS1Jobs: Record Job;
    begin
        if NS1Jobs.Get(NSPassTaskLine."Job No.") then
            if NS1Jobs."NS_Push-OrV2JFWForecastedonJTL" = true then begin
                if Confirm(Text14021101, true) then begin
                    NS1JobTask.Reset();
                    NS1JobTask.SetRange("Job No.", NSPassTaskLine."Job No.");
                    NS1JobTask.SetRange("Job Task Type", "Job Task Type"::Posting);
                    NS1JobTask.SetFilter(NS_ForecastedCompCostOverride, '<>%1', 0);
                    if NS1JobTask.FindSet() then
                        repeat
                            NS1JobTask."NS_JFW Forecast Completed Cost" := NS1JobTask.NS_ForecastedCompCostOverride;
                            NS1JobTask.Modify();
                        until NS1JobTask.Next() = 0;
                    Message('Done.');
                end else
                    exit;
            end else
                Message('Please ensure that "Push Override Values to JFW Forecasted on JTL" setup is enabled on Job %1.', NSPassTaskLine."Job No.");
    end;
    //PE-299.JS.1.0 17MAY024-end

    var
        Text14021101: Label 'Do you want to update "Override Forecasted Completed Cost" values to the "JFW Forecasted Completed Cost" column in all job task lines?';
        Text14021100: Label 'Unknown';
        NS_JobForecast: Record "NS_Job Forecast";
        QuoteMgt: Codeunit "NS_Job Quote Mgt.";
        NS_FakeJob: Record job;
        NS_FakeCust: Record Customer;
        NS_BillToCustNo: code[20];
        NS_IsFakeCustomer: boolean;
        NS_Jobs1: Record Job;     //PRJ-1015.JS.1.0   10Oct2021//PRJ-999
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021100 Percent Complete
//   +     14021101 Estimated Hours
//   +     14021102 Total Hours Applied
//   +     14021103 Percent Materials
//   +     14021104 Invoice Due Date
//   +     14021120 Burden Percent
//   +     14021140 Total Percent Complete
//   +     14021141 Total Percent Complete Date
//   +     14021142 Billing Percent
//   +     14021143 Billing Percent Date
//   +     14021190 Task Before
//   +     14021191 Task After
//   +     14021192 Task Start Date
//   +     14021193 Task End Date
//   +     14021194 Task Lag Days
//   +     14021195 Task Days
//   +     14021196 Resource No.
//   +     14021197 Start Date Fixed
//   +     14021198 Manager
//   +     14021400 Quote No.
//   +     14021401 Mark-up
//   +     14021402 Gross Profit %
//   +     14021403 Gross Profit
//   +     14021404 Quantity Weighted
//   +     14021405 Cost Weighted
//   +     14021408 Line Amount Incl. Tax
//   +     14021409 Template No.
//   +
//   +  - Added function(s):
//   +     PP_GetJobTaskDescription
//   +     PP_GetDefaultAPOBurdenPercent
//   +     PP_GetTaskBurdenPercent
//   +     PP_UpdateForecastWorksheet
//   +     PP_POsRecdAndOtstndngByExptRcptDate
//   +     CalcSalesTax
//   +
//   +  - Added global variable(s):
//   +      QuoteMgt
//   +      PP_JobForecast
//   +
//   +  - Added global text constant(s):
//   +     Text14021100
//   +
//   +  - Modification(s):
//   +     - Field Groups -
//   +         Original: Job Task No.,Description,Job Task Type
//   +         Modified: Job No.,Job Task No.,Description,Job Task Type
//   +     - OnInsert: - Remove code for Bill-to Customer No.
//   +                 - Added setting of
//   +                     Burden Percent
//   +                     Quote No.
//   +                 - Added call to PP_UpdateForecastWorksheet
//   +     - On Modify: - Added call to PP_UpdateForecastWorksheet
//   +     - Fields
//   +       - Job Task No. - OnValidate() - Remove code for Bill-to Customer No.
//   +     - Procedures set for global access
//   +         JobLedgEntriesExist
//   +         JobPlanningLinesExist
//   +-----------------------------------------------------------------------------------------------