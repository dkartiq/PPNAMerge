page 14021361 "NS_ProjectProManagerActivity2"
{
    //a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'ProjectPro Activities';
    PageType = CardPart;
    SourceTable = "NS_ProjectPro Job Cue";

    layout
    {
        area(content)
        {
            cuegroup(Due)
            {
                Caption = 'Due';
                field("Jobs To Complete This Month"; Rec."NS_Jobs To Complete This Month")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Job List";
                }
                field("Retention Invoices Due"; Rec."NS_Retention Invoices Due")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Job List";

                    trigger OnDrillDown();
                    var
                        CLE: Record "Cust. Ledger Entry";
                    begin
                        CLE.RESET();
                        CLE.CLEARMARKS;
                        CLE.SETCURRENTKEY("Document Type", "Customer No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date", "Currency Code", "NS_Retention Ledger Code");
                        CLE.SETRANGE("NS_Retention Ledger Code", JobsSetup."NS_Retention Receivable Ledger");
                        if CLE.FINDSET() then
                            repeat
                                if CLE."NS_Retention Date" <= WORKDATE then
                                    if CLE."NS_Retention Amount" <> 0 then begin
                                        CLE.CALCFIELDS("Remaining Amount");
                                        if CLE."Remaining Amount" <> 0 then
                                            CLE.MARK(true);
                                    end;
                            until CLE.NEXT() = 0;
                        CLE.MARKEDONLY(true);
                        PAGE.RUN(PAGE::"Customer Ledger Entries", CLE);
                    end;
                }

                actions
                {
                    action("NS_Job Create Sales Invoice")
                    {
                        ApplicationArea = All;
                        Caption = 'Job Create Sales Invoice';
                        //SPLN Image = CreateJobSalesInvoice;
                        RunObject = Report "NS_JobCreateSalesInvoice";
                        ToolTip = 'Job Create Sales Invoice';
                    }
                    action("NS_Aged A/R with Retention")
                    {
                        ApplicationArea = All;
                        Caption = 'Aged A/R with Retention';
                        RunObject = Report "NS_Aged Accounts ReceivableRet";
                        ToolTip = 'Aged A/R with Retention';
                    }
                }
            }
            cuegroup(Profit)
            {
                Caption = 'Profit';
                field("Job Profit below Estimate"; "NS_Job Profit below Estimate")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Job List";
                    ToolTip = 'Specifies the ob Profit below Estimate';

                    trigger OnDrillDown();
                    begin
                        JobRec.RESET();
                        JobRec.CLEARMARKS;
                        JobRec.SETRANGE("NS_Manager Job Status", JobRec."NS_Manager Job Status"::Handover);
                        if JobRec.FINDSET() then
                            repeat
                                JobRec.NS_CalculateActualCostToDate(JobRec, ActualCostToDate, true, WorkDate());
                                JobRec.CalculateInvoiceBilled(JobRec, InvoiceBilled, true, WorkDate());
                                JobRec.CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");
                                CLEAR("Sub-LevelsCost");
                                CLEAR("Sub-LevelsPrice");
                                "Sub-LevelsCost" := JobRec.NS_SLsBudgetedLaborHours(JobRec);
                                "Sub-LevelsPrice" := JobRec."SLsUsage(Price)"(JobRec);
                                TotalContract := JobRec."NS_Budgeted Price (LCY)" + "Sub-LevelsPrice";
                                TotalBudgetedCost := JobRec."NS_Budgeted Cost (LCY)" + "Sub-LevelsCost";
                                if JobRec."NS_Actual Percent Complete" > 0 then
                                    ProjectedCost := JobRec."NS_Actual Percent Complete"
                                else begin
                                    if JobRec."NS_Budgeted Cost (LCY)" + "Sub-LevelsCost" <> 0 then
                                        CalcPctComplete := ROUND((ActualCostToDate[3] / (JobRec."NS_Budgeted Cost (LCY)" + "Sub-LevelsCost")), 0.0001)
                                    else
                                        CalcPctComplete := 0;
                                    ProjectedCost := CalcPctComplete * 100;
                                end;
                                if ProjectedCost <> 0 then
                                    ProjectedCost := ActualCostToDate[3] / (ProjectedCost / 100);
                                if (TotalContract - TotalBudgetedCost) > (TotalContract - ProjectedCost) then
                                    JobRec.MARK(true);
                            until JobRec.NEXT() = 0;
                        JobRec.MARKEDONLY(true);
                        PAGE.RUN(PAGE::"Job List", JobRec);
                    end;
                }
                field("Job Cost Exceeds Cont Billings"; Rec."NS_Job CostExceedsContBillings")
                {
                    ApplicationArea = All;
                    Caption = 'Job Cost Exceeds Contract Billings';
                    DrillDownPageID = "Job List";
                    ToolTip = 'Job Cost Exceeds Contract Billings';

                    trigger OnDrillDown();
                    begin
                        JobRec.RESET();
                        JobRec.CLEARMARKS;
                        JobRec.SETRANGE("NS_Manager Job Status", JobRec."NS_Manager Job Status"::Handover);
                        if JobRec.FINDSET() then
                            repeat
                                JobCalc.NS_CalculateActualCostToDate(JobRec, ActualCostToDate, true, WorkDate());
                                JobCalc.CalculateInvoiceBilled(JobRec, InvoiceBilled, true, WorkDate());
                                if ActualCostToDate[3] > InvoiceBilled[3] then
                                    JobRec.MARK(true);
                            until JobRec.NEXT() = 0;
                        JobRec.MARKEDONLY(true);
                        PAGE.RUN(PAGE::"Job List", JobRec);
                    end;
                }

                actions
                {
                    action("Gross Profit by APO")
                    {
                        ApplicationArea = All;
                        Caption = 'Gross Profit by APO';
                        RunObject = Report "NS_Gross Profit by APO";
                        ToolTip = 'Gross Profit by APO';
                    }
                    action("Actual vs Budget Cost by APO")
                    {
                        ApplicationArea = All;
                        Caption = 'Actual vs Budget Cost by APO';
                        RunObject = Report "NS_ActualvsBudget Cost by APO";
                    }
                    action("Actual vs Budget Price by APO")
                    {
                        ApplicationArea = All;
                        Caption = 'Actual vs Budget Price by APO';
                        RunObject = Report "NS_Actual vs Budget PricebyAPO";
                        ToolTip = 'Actual vs Budget Price by APO';
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        "NS_Job CostExceedsContBillings" := 0;
        "NS_Job Profit below Estimate" := 0;
        "NS_Retention Invoices Due" := 0;

        JobCalc.RESET();
        JobCalc.SETCURRENTKEY("NS_Manager Job Status");
        JobCalc.SETRANGE("NS_Manager Job Status", JobCalc."NS_Manager Job Status"::Handover);
        if JobCalc.FINDSET() then
            repeat
                //Calulate Job Cost Exceeds Contract Billings
                JobCalc.NS_CalculateActualCostToDate(JobCalc, ActualCostToDate, true, WorkDate());
                JobCalc.CalculateInvoiceBilled(JobCalc, InvoiceBilled, true, WorkDate());
                if ActualCostToDate[3] > InvoiceBilled[3] then
                    "NS_Job CostExceedsContBillings" += 1;

                //Calulate Job Projected Profit below Estimated
                JobCalc.CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");
                CLEAR("Sub-LevelsCost");
                CLEAR("Sub-LevelsPrice");
                "Sub-LevelsCost" := JobCalc.NS_SLsBudgetedLaborHours(JobCalc);
                "Sub-LevelsPrice" := JobCalc."SLsUsage(Price)"(JobCalc);
                TotalContract := JobCalc."NS_Budgeted Price (LCY)" + "Sub-LevelsPrice";
                TotalBudgetedCost := JobCalc."NS_Budgeted Cost (LCY)" + "Sub-LevelsCost";
                if JobCalc."NS_Actual Percent Complete" > 0 then
                    ProjectedCost := JobCalc."NS_Actual Percent Complete"
                else begin
                    if JobCalc."NS_Budgeted Cost (LCY)" + "Sub-LevelsCost" <> 0 then
                        CalcPctComplete := ROUND((ActualCostToDate[3] / (JobCalc."NS_Budgeted Cost (LCY)" + "Sub-LevelsCost")), 0.0001)
                    else
                        CalcPctComplete := 0;
                    ProjectedCost := CalcPctComplete * 100;
                end;
                if ProjectedCost <> 0 then
                    ProjectedCost := ActualCostToDate[3] / (ProjectedCost / 100);
                if (TotalContract - TotalBudgetedCost) > (TotalContract - ProjectedCost) then
                    "NS_Job Profit below Estimate" += 1;
            until JobCalc.NEXT() = 0;

        //Calculate Retention Invoices Due
        CustLedgEntry.RESET();
        CustLedgEntry.SETCURRENTKEY("Document Type", "Customer No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date", "Currency Code", "NS_Retention Ledger Code");
        CustLedgEntry.SETRANGE("NS_Retention Ledger Code", JobsSetup."NS_Retention Receivable Ledger");
        if CustLedgEntry.FINDSET() then
            repeat
                if CustLedgEntry."NS_Retention Date" <= WORKDATE then
                    if CustLedgEntry."NS_Retention Amount" <> 0 then begin
                        CustLedgEntry.CALCFIELDS("Remaining Amount");
                        if CustLedgEntry."Remaining Amount" <> 0 then
                            "NS_Retention Invoices Due" += 1;
                    end;
            until CustLedgEntry.NEXT() = 0;
    end;

    trigger OnOpenPage();
    begin
        RESET;
        if not GET then begin
            INIT();
            INSERT();
        end;

        SETFILTER("NS_Date Filter", '%1..%2', 19000101D, CALCDATE('CM'));
        SETFILTER("NS_Date Filter2", '<%1', WORKDATE);
        JobsSetup.GET();
    end;

    var
        JobCalc: Record Job;
        JobRec: Record Job;
        PurchaseHeader: Record "Purchase Header";
        JobsSetup: Record "Jobs Setup";
        CustLedgEntry: Record "Cust. Ledger Entry";
        ActualCostToDate: array[3] of Decimal;
        InvoiceBilled: array[3] of Decimal;
        "Sub-LevelsCost": Decimal;
        "Sub-LevelsPrice": Decimal;
        TotalContract: Decimal;
        TotalBudgetedCost: Decimal;
        CalcPctComplete: Decimal;
        ProjectedCost: Decimal;
}

