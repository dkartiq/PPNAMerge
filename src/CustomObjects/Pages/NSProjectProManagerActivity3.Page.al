page 14021363 "NS_ProjectPro ManagerActivity3"
{
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
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
                field("PP_Jobs To Complete This Month"; Rec."NS_Jobs To Complete This Month")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Job List";
                    ToolTip = 'Jobs To Complete This Month';
                }
                field("PP_Retention Invoices Due"; Rec."NS_Retention Invoices Due")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Job List";
                    ToolTip = 'Retention Invoices Due';

                    trigger OnDrillDown();
                    var
                        CLE: Record "Cust. Ledger Entry";
                    begin
                        CLE.RESET();
                        CLE.CLEARMARKS();
                        CLE.SETCURRENTKEY("Document Type", "Customer No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date", "Currency Code", "NS_Retention Ledger Code");
                        CLE.SETRANGE("NS_Retention Ledger Code", JobsSetup."NS_Retention Receivable Ledger");
                        if CLE.FINDSET() then
                            repeat
                                if CLE."NS_Retention Date" <= WORKDATE() then
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

                        ToolTip = 'Job Create Sales Invoice';
                        //SPLN Image = CreateJobSalesInvoice;
                        RunObject = Report "Job Create Sales Invoice";
                    }
                    action("NS_Aged A/R with Retention")
                    {
                        ApplicationArea = All;
                        Caption = 'Aged A/R with Retention';

                        ToolTip = 'Aged A/R with Retention';
                        RunObject = Report "NS_Aged Accounts ReceivableRet";
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
        JobCalc.SETRANGE("NS_Manager Job Status", JobCalc."NS_Manager Job Status"::Running);
        if JobCalc.FINDSET() then
            repeat
                //Calulate Job Cost Exceeds Contract Billings
                JobCalc.NS_CalculateActualCostToDate(JobCalc, ActualCostToDate, true);
                JobCalc.CalculateInvoiceBilled(JobCalc, InvoiceBilled, true);
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
                if CustLedgEntry."NS_Retention Date" <= WORKDATE() then
                    if CustLedgEntry."NS_Retention Amount" <> 0 then begin
                        CustLedgEntry.CALCFIELDS("Remaining Amount");
                        if CustLedgEntry."Remaining Amount" <> 0 then
                            "NS_Retention Invoices Due" += 1;
                    end;
            until CustLedgEntry.NEXT() = 0;
    end;

    trigger OnOpenPage();
    var
        NSConfPersonalizationMgt: Codeunit "Conf./Personalization Mgt."; //PRJ-1686.GK.4.0 18Dec2022
    begin
        NSConfPersonalizationMgt.RaiseOnOpenRoleCenterEvent();//PRJ-1686.GK.4.0 18Dec2022
        RESET();
        if not GET() then begin
            INIT();
            INSERT();
        end;

        SETFILTER("NS_Date Filter", '%1..%2', 19000101D, CALCDATE('CM'));
        SETFILTER("NS_Date Filter2", '<%1', WORKDATE());
        JobsSetup.GET();
    end;

    var
        JobCalc: Record Job;
        // JobRec: Record Job;
        // PurchaseHeader: Record "Purchase Header";
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

