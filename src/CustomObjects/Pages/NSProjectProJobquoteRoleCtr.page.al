page 14021349 "NS_Proj Pro Job Quote Role Ctr"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'ProjectPro Manager Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1903710908; NS_ProjectProManagerActivities)
                {
                    ApplicationArea = All;
                }
                part(Control1904926908; "NS_ProjectPro KPIs")
                {
                    ApplicationArea = All;
                }
                systempart(Control1901420308; Outlook)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
            group(Control1900724708)
            {
                part(Control1903602108; "NS_ProjectPro My Jobs")
                {
                    ApplicationArea = All;
                }
                part(Control1904818108; "NS_ProjectPro My Subcontracts")
                {
                    ApplicationArea = All;
                }
                part(Control1901304508; "NS_ProjectPro My Job Resources")
                {
                    ApplicationArea = All;
                }
                systempart(Control1901377608; MyNotes)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            group(Job)
            {
                Caption = 'Job';
                action("Job Materials List")
                {
                    ApplicationArea = All;
                    Caption = 'Job Materials List';
                    Image = "Report";
                    RunObject = Report "NS_Job Materials List";
                }
                action("Job Status")
                {
                    ApplicationArea = All;
                    Caption = 'Job Status';
                    Image = "Report";
                    RunObject = Report "NS_Job Status";
                }
                action("Job WIP Report")
                {
                    ApplicationArea = All;
                    Caption = 'Job WIP Report';
                    Image = "Report";
                    RunObject = Report "NS_Job WIP Report";
                }
                action("Percentage of Completion")
                {
                    ApplicationArea = All;
                    Caption = 'Percentage of Completion';
                    Image = "Report";
                    RunObject = Report "NS_Percentage of Completion";
                }
                action("Job Ledger")
                {
                    ApplicationArea = All;
                    Caption = 'Job Ledger';
                    Image = "Report";
                    RunObject = Report "NS_Job Ledger";
                }
                action("APO List")
                {
                    ApplicationArea = All;
                    Caption = 'APO List';
                    Image = "Report";
                    RunObject = Report "NS_APO List";
                }
            }
            group("Profit - Cost")
            {
                Caption = 'Profit - Cost';
                action("Jobs Gross Profit")
                {
                    ApplicationArea = All;
                    Caption = 'Jobs Gross Profit';
                    Image = "Report";
                    RunObject = Report "NS_Jobs Gross Profit";
                }
                action("Jobs Gross Profit by APO")
                {
                    ApplicationArea = All;
                    Caption = 'Jobs Gross Profit by APO';
                    Image = "Report";
                    RunObject = Report "NS_Gross Profit by APO";
                }
                action("Job Cost Category Summary")
                {
                    ApplicationArea = All;
                    Caption = 'Job Cost Category Summary';
                    Image = "Report";
                    RunObject = Report "NS_Job Cost Category Summary";
                }
                action("Committed Cost Detail Report")
                {
                    ApplicationArea = All;
                    Caption = 'Committed Cost Detail Report';
                    Image = "Report";
                    RunObject = Report "NS_Committed Cost DetailReport";
                }
                action(Bonding)
                {
                    ApplicationArea = All;
                    Caption = 'Bonding';
                    Image = "Report";
                    RunObject = Report NS_Bonding;
                }
                action("<Report Job Detail By Gross Margin>")
                {
                    ApplicationArea = All;
                    Caption = 'Job Detail by Gross Margin';
                    Image = "Report";
                    RunObject = Report "NS_Job Detail By Gross Margin";
                }
            }
            group(Purchasing)
            {
                Caption = 'Purchasing';
                action("Job Purchase Order Status")
                {
                    ApplicationArea = All;
                    Caption = 'Job Purchase Order Status';
                    Image = "Report";
                    RunObject = Report "NS_Job Purchase Order Status";
                }
                action("Purch Order Status by Job")
                {
                    ApplicationArea = All;
                    Caption = 'Purch Order Status by Job';
                    Image = "Report";
                    RunObject = Report "NS_Purch Order Status by Job";
                }
                action("Vendor Insurance List")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Insurance List';
                    Image = "Report";
                    RunObject = Report "NS_Vendor Insurance List";
                }
            }
            group("Actual vs. Budget")
            {
                Caption = 'Actual vs. Budget';
                action("Actual vs Budget Cost by APO")
                {
                    ApplicationArea = All;
                    Caption = 'Actual vs Budget Cost by APO';
                    Image = "Report";
                    RunObject = Report "NS_ActualvsBudget Cost by APO";
                }
                action("Actual vs Budget Price by APO")
                {
                    ApplicationArea = All;
                    Caption = 'Actual vs Budget Price by APO';
                    Image = "Report";
                    RunObject = Report "NS_Actual vs Budget PricebyAPO";
                }
                // action("Actual vs Budget Price by RAPO")//PRJ-811.AS.1.0 Commented Action as report not needed anymore
                // {
                //     ApplicationArea = All;
                //     Caption = 'Actual vs Budget Price by RAPO';
                //     Image = "Report";
                //     RunObject = Report "NS_Actual vs BudgetPricebyRAPO";
                // }
                action("Actual vs Budget Qty by APO")
                {
                    ApplicationArea = All;
                    Caption = 'Actual vs Budget Qty by APO';
                    Image = "Report";
                    RunObject = Report "NS_Actual vs Budget Qty by APO";
                }
                action("Actual vs Budget C/WU by APO")
                {
                    ApplicationArea = All;
                    Caption = 'Actual vs Budget C/WU by APO';
                    Image = "Report";
                    RunObject = Report "NS_ActualvsBudget C/WU by APO";
                }
                // action("Actual vs Budget Mat by APO")//PRJ-813.AS.1.0 Action commented as report not needed anymore
                // {
                //     ApplicationArea = All;
                //     Caption = 'Actual vs Budget Mat by APO';
                //     Image = "Report";
                //     RunObject = Report "NS_ActualvsBudget Mat by APO";
                // }

                action("Actual vs Budget Job Hour")
                {
                    ApplicationArea = All;
                    Caption = 'Actual vs Budget Job Hour';
                    Image = "Report";
                    RunObject = Report "NS_Actual vs Budget Job Hour";
                }
            }
            group(Aging)
            {
                Caption = 'Aging';
                action("Aged A/R with Retention")
                {
                    ApplicationArea = All;
                    Caption = 'Aged A/R with Retention';
                    Image = "Report";
                    RunObject = Report "NS_Aged Accounts ReceivableRet";
                }
                action("Aged A/P with Retention")
                {
                    ApplicationArea = All;
                    Caption = 'Aged A/P with Retention';
                    Image = "Report";
                    RunObject = Report "NS_Aged Accounts Payable Ret";
                }
            }
            group(NS_Subcontracts)
            {

                Caption = 'Subcontracts';
                action("NS_Subcontract Status by Vendor")
                {
                    ApplicationArea = All;
                    Caption = 'Subcontract Status by Vendor';

                    ToolTip = 'Subcontract Status by Vendor';
                    Image = "Report";
                    RunObject = Report "NS_Subcontract Status byVendor";
                }
                action("NS_Subcontract Status by Job")
                {
                    ApplicationArea = All;
                    Caption = 'Subcontract Status by Job';
                    Image = "Report";
                    RunObject = Report "NS_Subcontract Status by Job";
                }
            }
            group("NS_ProjectPro Reports")
            {
                Caption = 'ProjectPro Reports';

                ToolTip = 'ProjectPro Reports';
                action("NS_Variance Report")
                {
                    ApplicationArea = All;
                    Caption = 'Variance Report';
                    Image = "Report";
                    RunObject = Report "NS_Act vs Bud Cost by APOwQty";
                }
                action("Job Billing History")
                {
                    ApplicationArea = All;
                    Caption = 'Job Billing History';
                    Image = "Report";
                    RunObject = Report "NS_Job Cost Budget withSorting";
                }
                action("Aged AP Retention by Job")
                {
                    ApplicationArea = All;
                    Caption = 'Aged AP Retention by Job';
                    Image = "Report";
                    RunObject = Report "NS_Aged AP Retention by Job";
                }
            }
        }
        area(embedding)
        {
            action(Jobs)
            {
                ApplicationArea = All;
                Caption = 'Jobs';
                RunObject = Page "Job List";
            }
            action("On Order")
            {
                ApplicationArea = All;
                Caption = 'On Order';
                RunObject = Page "Job List";
                RunPageView = WHERE(Status = FILTER(Open));
            }
            action("Planned and Quoted")
            {
                ApplicationArea = All;
                Caption = 'Planned and Quoted';
                RunObject = Page "Job List";
                RunPageView = WHERE(Status = FILTER(Quote | Planning));
            }
            action(Completed)
            {
                ApplicationArea = All;
                Caption = 'Completed';
                RunObject = Page "Job List";
                RunPageView = WHERE(Status = FILTER(Completed));
            }
            action(Unassigned)
            {
                ApplicationArea = All;
                Caption = 'Unassigned';
                RunObject = Page "Job List";
                RunPageView = WHERE("Person Responsible" = FILTER(''));
            }
            action(Quotes)
            {
                ApplicationArea = All;
                Caption = 'Quotes';
                RunObject = Page "NS_Job Quote List";
            }
            action(Action1100773000)
            {
                ApplicationArea = All;
                Caption = 'Subcontracts';
                Image = CalculateRemainingUsage;
                RunObject = Page "NS_Subcontract List";
            }
            action("Progress Billings")
            {
                ApplicationArea = All;
                Caption = 'Progress Billings';
                Image = CalculateInvoiceDiscount;
                RunObject = Page "NS_Progress Billing List";
            }
            action(Active)
            {
                ApplicationArea = All;
                Caption = 'Active';
                RunObject = Page "NS_Progress Billing List";
                RunPageView = WHERE(NS_Final = CONST(false));
            }
            action("Sales Orders")
            {
                ApplicationArea = All;
                Caption = 'Sales Orders';
                RunObject = Page "Sales Order List";
            }
            action("Sales Invoices")
            {
                ApplicationArea = All;
                Caption = 'Sales Invoices';
                RunObject = Page "Sales Invoice List";
            }
            action("Sales Credit Memos")
            {
                ApplicationArea = All;
                Caption = 'Sales Credit Memos';
                RunObject = Page "Sales Credit Memos";
            }
            action("Purchase Orders")
            {
                ApplicationArea = All;
                Caption = 'Purchase Orders';
                RunObject = Page "Purchase Order List";
            }
            action("Purchase Invoices")
            {
                ApplicationArea = All;
                Caption = 'Purchase Invoices';
                RunObject = Page "Purchase Invoices";
            }
            action("Purchase Credit Memos")
            {
                ApplicationArea = All;
                Caption = 'Purchase Credit Memos';
                RunObject = Page "Purchase Credit Memos";
            }
            action(Resources)
            {
                ApplicationArea = All;
                Caption = 'Resources';
                RunObject = Page "Resource List";
            }
            action("Resource Groups")
            {
                ApplicationArea = All;
                Caption = 'Resource Groups';
                RunObject = Page "Resource Groups";
            }
            action(Items)
            {
                ApplicationArea = All;
                Caption = 'Items';
                RunObject = Page "Item List";
            }
            action(Customers)
            {
                ApplicationArea = All;
                Caption = 'Customers';
                RunObject = Page "Customer List";
            }
            action(Vendors)
            {
                ApplicationArea = All;
                Caption = 'Vendors';
                RunObject = Page "Vendor List";
            }
        }
        area(sections)
        {
            group(Journals)
            {
                Caption = 'Journals';
                action("Job Journals")
                {
                    ApplicationArea = All;
                    Caption = 'Job Journals';
                    RunObject = Page "Job Journal Batches";
                    RunPageView = WHERE(Recurring = CONST(false));
                }
                action("Job G/L Journals")
                {
                    ApplicationArea = All;
                    Caption = 'Job G/L Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Jobs),
                                        Recurring = CONST(false));
                }
                action("Resource Journals")
                {
                    ApplicationArea = All;
                    Caption = 'Resource Journals';
                    RunObject = Page "Resource Jnl. Batches";
                    RunPageView = WHERE(Recurring = CONST(false));
                }
                action("Item Journals")
                {
                    ApplicationArea = All;
                    Caption = 'Item Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Item),
                                        Recurring = CONST(false));
                }
                action("Recurring Job Journals")
                {
                    ApplicationArea = All;
                    Caption = 'Recurring Job Journals';
                    RunObject = Page "Job Journal Batches";
                    RunPageView = WHERE(Recurring = CONST(true));
                }
                action("Recurring Resource Journals")
                {
                    ApplicationArea = All;
                    Caption = 'Recurring Resource Journals';
                    RunObject = Page "Resource Jnl. Batches";
                    RunPageView = WHERE(Recurring = CONST(true));
                }
                action("Recurring Item Journals")
                {
                    ApplicationArea = All;
                    Caption = 'Recurring Item Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Item),
                                        Recurring = CONST(true));
                }
            }
            group("Cash Management")
            {
                Caption = 'Cash Management';
                action("Cash Receipt Journals")
                {
                    ApplicationArea = All;
                    Caption = 'Cash Receipt Journals';
                    Image = Journals;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST("Cash Receipts"),
                                        Recurring = CONST(false));
                }

                //PPDA.1.0.TBA Start
                // action(Deposit)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Deposit';
                //     Image = Document;
                //     RunObject = Page Deposits;
                // }
                //PPDA.1.0.TBA End
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                action("Posted Shipments")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Shipments';
                    RunObject = Page "Posted Sales Shipments";
                }
                action("Posted Sales Invoices")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Sales Invoices';
                    RunObject = Page 143;
                }
                action("Posted Sales Credit Memos")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Sales Credit Memos';
                    RunObject = Page "Posted Sales Credit Memos";
                }
                action("Posted Purchase Receipts")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                }
                action("Posted Purchase Invoices")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                }
                action("Posted Purchase Credit Memos")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page "Posted Purchase Credit Memos";
                }
                action("G/L Registers")
                {
                    ApplicationArea = All;
                    Caption = 'G/L Registers';
                    RunObject = Page "G/L Registers";
                }
                action("Job Registers")
                {
                    ApplicationArea = All;
                    Caption = 'Job Registers';
                    RunObject = Page "Job Registers";
                }
                action("Item Registers")
                {
                    ApplicationArea = All;
                    Caption = 'Item Registers';
                    RunObject = Page "Item Registers";
                }
                action("Resource Registers")
                {
                    ApplicationArea = All;
                    Caption = 'Resource Registers';
                    RunObject = Page "Resource Registers";
                }
            }
        }
        area(processing)
        {
            separator(Tasks)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action("Job J&ournal")
            {
                ApplicationArea = All;
                Caption = 'Job J&ournal';
                Image = JobJournal;
                RunObject = Page "Job Journal";
            }
            action("Job G/L &Journal")
            {
                ApplicationArea = All;
                Caption = 'Job G/L &Journal';
                Image = GLJournal;
                RunObject = Page "Job G/L Journal";
            }
            action("R&esource Journal")
            {
                ApplicationArea = All;
                Caption = 'R&esource Journal';
                Image = ResourceJournal;
                RunObject = Page "Resource Journal";
            }
            action("C&hange Job Planning Line Date")
            {
                ApplicationArea = All;
                Caption = 'C&hange Job Planning Line Date';
                Image = ChangeDate;
                RunObject = Report "Change Job Dates";
            }
            action("Split Pla&nning Lines")
            {
                ApplicationArea = All;
                Caption = 'Split Pla&nning Lines';
                Image = Splitlines;
                RunObject = Report "Job Split Planning Line";
            }
            separator(Separator5)
            {
            }
            action("Job &Create Sales Invoice")
            {
                ApplicationArea = All;
                Caption = 'Job &Create Sales Invoice';
                Image = CreateJobSalesInvoice;
                RunObject = Report "Job Create Sales Invoice";
            }
            separator(Separator7)
            {
            }
            action("Update Job I&tem Cost")
            {
                ApplicationArea = All;
                Caption = 'Update Job I&tem Cost';
                Image = CostAccountingSetup;
                RunObject = Report "Update Job Item Cost";
            }
            action("Job Calculate &WIP")
            {
                ApplicationArea = All;
                Caption = 'Job Calculate &WIP';
                Image = CalculateWIP;
                RunObject = Report "Job Calculate WIP";
            }
            action("Jo&b Post WIP to G/L")
            {
                ApplicationArea = All;
                Caption = 'Jo&b Post WIP to G/L';
                Image = PostedTimeSheet;
                RunObject = Report "Job Post WIP to G/L";
            }
            separator(History)
            {
                Caption = 'History';
                IsHeader = true;
            }
            action("Navi&gate")
            {
                ApplicationArea = All;
                Caption = 'Navi&gate';
                Image = Navigate;
                RunObject = Page Navigate;
            }
        }
    }
}

