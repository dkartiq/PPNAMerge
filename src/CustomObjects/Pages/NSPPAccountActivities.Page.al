page 14021316 "NS_PPAccountActivities"
{
    Caption = 'Activities ProjectPro';
    PageType = CardPart;
    SourceTable = "NS_ProjectPro Job Cue";
    //PRJ-1743.NK.1.0 31jan2023 | Create New Page
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
                    ToolTip = 'Jobs To Complete This Month';
                }
                field(Backlog; Backlog)
                {
                    ApplicationArea = All;
                    Caption = 'Open Job Backlog';
                    ToolTip = 'Open Job Backlog';
                    DrillDown = true;
                    DrillDownPageID = "Job List";
                    visible = false;
                }
                field("NS_Open Job Backlog"; Rec."NS_Open Job Backlog")
                {
                    //  ToolTip = 'Open Job backlog Specifies the Value which is the difference between the "Total Contract Price including Master & Sub Levels Jobs" minus “Total Invoiced Price including Master & the Sub Levels Jobs". Open Job Backlog Batch can be run from the Job card & on the ProjectPro Manager Role Center. Note: Open Job Backlog calculation includes Jobs only with status “Open or Planning", in addition to this "Manager Job Status" should be "Planning."'; //PRJCTPR-163.PS.1.0 20Jul2023
                    ToolTip = 'Specifies the difference between the "Total Contract Price” and the "Total Invoiced Price” including Master & the Sub Levels Jobs. The value under this field will get updated only when the “Open Job Backlog Batch” is run. Note: Open Job Backlog calculation includes Jobs only with the status "Open” or “Planning", and in addition to this the "Manager Job Status" should also be set to "Planning."';
                    ApplicationArea = All;
                    DrillDown = true;
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





            cuegroup(Profit)
            {
                Caption = 'Profit';
                field("Job Profit below Estimate"; Rec."NS_Job Profit below Estimate")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Job List";

                    trigger OnDrillDown();
                    begin
                        JobRec.RESET();
                        JobRec.CLEARMARKS();
                        JobRec.SETRANGE("NS_Manager Job Status", JobRec."NS_Manager Job Status"::Handover);
                        if JobRec.FINDSET() then
                            repeat
                                JobRec.NS_CalculateActualCostToDate(JobRec, ActualCostToDate, true);
                                JobRec.CalculateInvoiceBilled(JobRec, InvoiceBilled, true);
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

                    trigger OnDrillDown();
                    begin
                        JobRec.RESET();
                        JobRec.CLEARMARKS();
                        JobRec.SETRANGE("NS_Manager Job Status", JobRec."NS_Manager Job Status"::Handover);
                        if JobRec.FINDSET() then
                            repeat
                                JobCalc.NS_CalculateActualCostToDate(JobRec, ActualCostToDate, true);
                                JobCalc.CalculateInvoiceBilled(JobRec, InvoiceBilled, true);
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
                    }
                }
            }
            cuegroup("Subcontract/Supply")
            {
                Caption = 'Subcontract/Supply';
                Visible = true;
                field(OpenSubcontracts; OpenSubcontracts)
                {
                    ApplicationArea = All;
                    Caption = 'Open Subcontracts';
                    DrillDown = true;
                    trigger OnDrillDown();
                    VAR
                        SubContRec: Record NS_Subcontract;
                    begin
                        SubContRec.Reset();
                        SubContRec.SetRange(NS_Status, SubContRec.NS_Status::Order);
                        PAGE.RUN(PAGE::"NS_Subcontract List", SubContRec);
                    end;
                }
                field(ExpiringInsurance; ExpiringInsurance)
                {
                    ApplicationArea = All;
                    Caption = 'Expiring Insurance - 30 Day';
                    DrillDown = true;
                    trigger OnDrillDown();
                    var
                        VendInsurRec: Record "NS_Vendor Insurance";
                    begin
                        VendInsurRec.Reset;
                        VendInsurRec.SetFilter("NS_Expiration Date", '<=%1', TODAY + 30);
                        PAGE.RUN(PAGE::"NS_Vendor Insurances", VendInsurRec);
                    end;
                }
                field("Open Job Purchase Orders"; Rec."NS_Open Job Purchase Orders")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Job List";
                    Visible = true;

                    trigger OnDrillDown();
                    begin
                        PurchaseHeader.RESET();
                        PurchaseHeader.SETRANGE(Status, PurchaseHeader.Status::Open);
                        PurchaseHeader.SETFILTER("NS_Job No.", '<>%1', '');
                        PAGE.RUN(PAGE::"Purchase List", PurchaseHeader);
                    end;
                }

                actions
                {
                    action("Purchase Order Status by Job")
                    {
                        ApplicationArea = All;
                        Caption = 'Purchase Order Status by Job';
                        RunObject = Report "NS_Purch Order Status by Job";
                    }
                    action("<Report Aged Accounts Payable")
                    {
                        ApplicationArea = All;
                        Caption = 'Aged A/P with Retention';
                        RunObject = Report "NS_Aged Accounts Payable Ret";
                    }
                }
            }
            // cuegroup("Product Videos")
            // {
            //     Caption = 'Product Videos';
            //     actions
            //     {
            //         action(Action32)
            //         {
            //             ApplicationArea = Basic, Suite;
            //             Caption = 'Product Videos';
            //             Image = TileVideo;
            //             RunObject = Page "Product Videos";
            //             ToolTip = 'Open a list of videos that showcase some of the product capabilities.';
            //         }
            //     }
            // }

        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        Rec."NS_Job CostExceedsContBillings" := 0;
        Rec."NS_Job Profit below Estimate" := 0;
        Rec."NS_Retention Invoices Due" := 0;

        JobCalc.RESET();
        JobCalc.SETCURRENTKEY("NS_Manager Job Status");
        JobCalc.SETRANGE("NS_Manager Job Status", JobCalc."NS_Manager Job Status"::Handover);
        if JobCalc.FINDSET() then
            repeat
                JobCalc.NS_CalculateActualCostToDate(JobCalc, ActualCostToDate, true);
                JobCalc.CalculateInvoiceBilled(JobCalc, InvoiceBilled, true);
                if ActualCostToDate[3] > InvoiceBilled[3] then
                    Rec."NS_Job CostExceedsContBillings" += 1;
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
                    Rec."NS_Job Profit below Estimate" += 1;
            until JobCalc.NEXT() = 0;


        CustLedgEntry.RESET();
        CustLedgEntry.SETCURRENTKEY("Document Type", "Customer No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date", "Currency Code", "NS_Retention Ledger Code");
        CustLedgEntry.SETRANGE("NS_Retention Ledger Code", JobsSetup."NS_Retention Receivable Ledger");
        if CustLedgEntry.FINDSET() then
            repeat
                if CustLedgEntry."NS_Retention Date" <= WORKDATE then
                    if CustLedgEntry."NS_Retention Amount" <> 0 then begin
                        CustLedgEntry.CALCFIELDS("Remaining Amount");
                        if CustLedgEntry."Remaining Amount" <> 0 then
                            Rec."NS_Retention Invoices Due" += 1;
                    end;
            until CustLedgEntry.NEXT() = 0;

        //Calculate open subcontract
        OpenSubcontracts := 0;
        Subcontract.RESET();
        if Subcontract.FIND('-') then
            repeat
                if Subcontract.NS_Status = Subcontract.NS_Status::Order then
                    OpenSubcontracts += 1;
            until Subcontract.NEXT() = 0;

        //Calculate Expired Vendor Insurance        
        ExpiringInsurance := 0;
        VendorInsurance.RESET();
        VendorInsurance.SetFilter("NS_Expiration Date", '<=%1', TODAY + 30);
        if VendorInsurance.FIND('-') then
            repeat
                ExpiringInsurance += 1;
            until VendorInsurance.NEXT() = 0;

        //Calculate Job Backlog from Planning to Running
        Backlog := 0;
        Job.RESET();
        if Job.FINDSET() then
            repeat
                //Find "Running" top-level jobs, calculate Backlog as Contract Total Value less Total Invoice Billed
                if Job."NS_Sub-Level to Job No." = '' then
                    if Job."NS_Manager Job Status" = Job."NS_Manager Job Status"::Handover then begin
                        Job.CALCFIELDS("NS_Budgeted Price (LCY)");
                        Backlog += Job."NS_Budgeted Price (LCY)";
                        Backlog += Job."SLsUsage(Price)"(Job);
                        Job.CalculateInvoiceBilled(Job, InvoiceBilled, true);
                        Backlog -= InvoiceBilled[3];
                    end;
            until Job.NEXT() = 0;
    end;

    trigger OnOpenPage();
    begin
        Rec.RESET();
        if not Rec.GET() then begin
            Rec.INIT();
            Rec.INSERT();
        end;

        Rec.SETFILTER("NS_Date Filter", '%1..%2', 19000101D, CALCDATE('CM'));
        Rec.SETFILTER("NS_Date Filter2", '<=%1', WORKDATE);
        Rec.SetFilter("NS_Due Next Week Filter", '%1..%2', CalcDate('<1D>', WorkDate), CalcDate('<1W>', WorkDate));
        JobsSetup.GET();
    end;

    var
        JobCalc: Record Job;
        VendorInsurance: Record "NS_Vendor Insurance";
        Job: Record Job;
        JobRec: Record Job;
        Subcontract: Record NS_Subcontract;
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
        OpenSubcontracts: Integer;

        ExpiringInsurance: Integer;

        Backlog: Decimal;

}

