page 14021359 "NS_KPI Job List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job List';
    Editable = false;
    PageType = Card;
    SourceTable = Job;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field("Manager Job Status"; Rec."NS_Manager Job Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Manager Job Status';
                }
                field("Estimated Completion Date"; Rec."NS_Estimated Completion Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Estimated Completion Date';
                }
                field("Actual Percent Complete"; Rec."NS_Actual Percent Complete")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Actual Percent Complete';
                }
                field("Actual Percent Complete Date"; Rec."NS_Actual PercentCompleteDate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Actual Percent Complete Date';
                }
                field("InvoiceBilled[3]"; InvoiceBilled[3])
                {
                    ApplicationArea = All;
                    Caption = 'Invoice Billed To Date';
                    ToolTip = 'Specifies the Invoice Billed To Date';
                }
                field("ActualCostToDate[3]"; ActualCostToDate[3])
                {
                    ApplicationArea = All;
                    Caption = 'Actual Cost To Date';
                    ToolTip = 'Specifies the Actual Cost To Date';
                }
                field("Budgeted Cost (LCY)"; Rec."NS_Budgeted Cost (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Budgeted Cost (LCY)';
                }
                field("Budgeted Price (LCY)"; Rec."NS_Budgeted Price (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Budgeted Price (LCY)';
                }
                field(ActualProfitPct; ActualProfitPct)
                {
                    ApplicationArea = All;
                    Caption = 'Actual Profit %';
                }
                field(ProjectedProfitPct; ProjectedProfitPct)
                {
                    ApplicationArea = All;
                    Caption = 'Projected Profit %';
                }
                field(MarginVariancePct; MarginVariancePct)
                {
                    ApplicationArea = All;
                    Caption = '% of Margin Variance to Plan';
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Bill-to Customer No.';
                }
                field("Next Invoice Date"; Rec."Next Invoice Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Next Invoice Date';
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Status';
                    Visible = false;
                }
                field("Person Responsible"; Rec."Person Responsible")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Person Responsible';
                    Visible = false;
                }
                field("Job Posting Group"; Rec."Job Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Posting Group';
                    Visible = false;
                }
                field("Search Description"; Rec."Search Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Search Description';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Job")
            {
                Caption = '&Job';
                action(Card)
                {
                    ApplicationArea = All;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Job Card";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Job),
                                  "No." = FIELD("No.");
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    action("Dimensions-Single")
                    {
                        ApplicationArea = All;
                        Caption = 'Dimensions-Single';
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = CONST(167),
                                      "No." = FIELD("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                    }
                    action("Dimensions-&Multiple")
                    {
                        ApplicationArea = All;
                        Caption = 'Dimensions-&Multiple';

                        trigger OnAction();
                        var
                            Job: Record Job;
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SETSELECTIONFILTER(Job);
                            DefaultDimMultiple.SetMultiRecord(Job, FieldNo("No."));
                            DefaultDimMultiple.RUNMODAL;
                        end;
                    }
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = All;
                    Caption = 'Ledger E&ntries';
                    Image = JobLedger;
                    RunObject = Page "Job Ledger Entries";
                    RunPageLink = "Job No." = FIELD("No.");
                    RunPageView = SORTING("Job No.", "Job Task No.", "Entry Type", "Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("Job Task Lines")
                {
                    ApplicationArea = All;
                    Caption = 'Job Task Lines';
                    Image = TaskList;

                    trigger OnAction();
                    var
                        JTLines: Page "Job Task Lines";
                    begin
                        JTLines.NS_SetJobNo("No.");
                        JTLines.RUN;
                    end;
                }
                action(Statistics)
                {
                    ApplicationArea = All;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Job Statistics";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'F7';
                }
            }
            group("W&IP")
            {

                Caption = 'W&IP';
                action("Calculate WIP")
                {
                    ApplicationArea = All;
                    Caption = 'Calculate WIP';
                    Ellipsis = true;
                    Image = CalculateWIP;

                    trigger OnAction();
                    var
                        Job: Record Job;
                    begin
                        TESTFIELD("No.");
                        Job.COPY(Rec);
                        Job.SETRANGE("No.", "No.");
                        REPORT.RUNMODAL(REPORT::"Job Calculate WIP", true, false, Job);
                    end;
                }
                action("Post WIP to G/L")
                {
                    ApplicationArea = All;
                    Caption = 'Post WIP to G/L';
                    Ellipsis = true;
                    Image = Post;

                    trigger OnAction();
                    var
                        Job: Record Job;
                    begin
                        TESTFIELD("No.");
                        Job.COPY(Rec);
                        Job.SETRANGE("No.", "No.");
                        REPORT.RUNMODAL(REPORT::"Job Post WIP to G/L", true, false, Job);
                    end;
                }
                action("WIP Entries")
                {
                    ApplicationArea = All;
                    Caption = 'WIP Entries';
                    RunObject = Page "Job WIP Entries";
                    RunPageLink = "Job No." = FIELD("No.");
                    RunPageView = SORTING("Job No.", "Job Posting Group", "WIP Posting Date");
                }
                action("WIP G/L Entries")
                {
                    ApplicationArea = All;
                    Caption = 'WIP G/L Entries';
                    RunObject = Page "Job WIP G/L Entries";
                    RunPageLink = "Job No." = FIELD("No.");
                    RunPageView = SORTING("Job No.");
                }
            }
            group("Cost/&Price")
            {
                Caption = 'Cost/&Price';
                action(Resource)
                {
                    ApplicationArea = All;
                    Caption = 'Resource';
                    RunObject = Page "Job Resource Prices";
                    RunPageLink = "Job No." = FIELD("No.");
                }
                action(Item)
                {
                    ApplicationArea = All;
                    Caption = 'Item';
                    RunObject = Page "Job Item Prices";
                    RunPageLink = "Job No." = FIELD("No.");
                }
                action("G/L Account")
                {
                    ApplicationArea = All;
                    Caption = 'G/L Account';
                    Image = ValueLedger;
                    RunObject = Page "Job G/L Account Prices";
                    RunPageLink = "Job No." = FIELD("No.");
                }
            }
            group("Plan&ning")
            {
                Caption = 'Plan&ning';
                action("Resource &Allocated per Job")
                {
                    ApplicationArea = All;
                    Caption = 'Resource &Allocated per Job';
                    RunObject = Page "Resource Allocated per Job";
                }
                separator(Separator26)
                {
                }
                action("Res. Group All&ocated per Job")
                {
                    ApplicationArea = All;
                    Caption = 'Res. Group All&ocated per Job';
                    RunObject = Page "Res. Gr. Allocated per Job";
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        NS_CalculateActualCostToDate(Rec, ActualCostToDate, true, WorkDate());
        CalculateInvoiceBilled(Rec, InvoiceBilled, true, WorkDate());
        CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");
        TotalBudgetedCost := "NS_Budgeted Cost (LCY)" + NS_SLsBudgetedLaborHours(Rec);
        TotalContract := "NS_Budgeted Price (LCY)" + "SLsUsage(Price)"(Rec);
        if TotalContract = 0 then
            ActualProfitPct := 0
        else
            ActualProfitPct := ((TotalContract - TotalBudgetedCost) / TotalContract) * 100;
        if "NS_Actual Percent Complete" > 0 then
            ActualPctComplete := "NS_Actual Percent Complete"
        else begin
            if TotalBudgetedCost <> 0 then
                CalcPctComplete := ROUND((ActualCostToDate[3] / TotalBudgetedCost), 0.0001)
            else
                CalcPctComplete := 0;
            ActualPctComplete := CalcPctComplete * 100;
        end;
        if ActualPctComplete <> 0 then
            ActualPctComplete := ActualCostToDate[3] / (ActualPctComplete / 100);
        if TotalContract = 0 then
            ProjectedProfitPct := 0
        else
            ProjectedProfitPct := ((TotalContract - ActualPctComplete) / TotalContract) * 100;
        MarginVariancePct := ProjectedProfitPct - ActualProfitPct;
    end;

    var
        InvoiceBilled: array[3] of Decimal;
        ActualCostToDate: array[3] of Decimal;
        MarginVariancePct: Decimal;
        TotalBudgetedCost: Decimal;
        TotalContract: Decimal;
        ActualPctComplete: Decimal;
        CalcPctComplete: Decimal;
        ProjectedProfitPct: Decimal;
        ActualProfitPct: Decimal;
}

