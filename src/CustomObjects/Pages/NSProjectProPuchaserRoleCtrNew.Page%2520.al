/// <summary>
/// Page NSProjectProPuchaserRole (ID 14021299).
/// </summary>
page 14021299 NSProjectProPuchaserRole
{
    //PE-124.DK.1.0 17july2023 | Creating New ProjectProPurchesing Role center
    // version PPNA11.00
    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    ////PE-109.DK.2.0 7june2023|Create New Role Center Page
    Caption = 'ProjectPro Purchaser Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {

            part(Control1903710909; "NS_ProjectProManagerActivities")
            {
                ApplicationArea = All;
            }
            group(Control1900724711)
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
                    ToolTip = 'Job Materials List';
                }
                action("Job Status")
                {
                    ApplicationArea = All;
                    Caption = 'Job Status';
                    Image = "Report";
                    RunObject = Report "NS_Job Status";
                    ToolTip = 'Job Status';
                }
                action("Job WIP Report")
                {
                    ApplicationArea = All;
                    Caption = 'Job WIP Report';
                    Image = "Report";
                    RunObject = Report "NS_Job WIP Report";
                    ToolTip = 'Job WIP Report';
                }
                action("Percentage of Completion")
                {
                    ApplicationArea = All;
                    Caption = 'Percentage of Completion';
                    Image = "Report";
                    RunObject = Report "NS_Percentage of Completion";
                    ToolTip = 'Percentage of Completion';
                }
                action("Job Ledger")
                {
                    ApplicationArea = All;
                    Caption = 'Job Ledger';
                    Image = "Report";
                    RunObject = Report "NS_Job Ledger";
                    ToolTip = 'Job Ledger';
                }
                action("APO List")
                {
                    ApplicationArea = All;
                    Caption = 'APO List';
                    Image = "Report";
                    RunObject = Report "NS_APO List";
                    ToolTip = 'APO List';
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
                    ToolTip = 'Jobs Gross Profit';
                }
                action("Jobs Gross Profit by APO")
                {
                    ApplicationArea = All;
                    Caption = 'Jobs Gross Profit by APO';
                    Image = "Report";
                    RunObject = Report "NS_Gross Profit by APO";
                    ToolTip = 'Jobs Gross Profit by APO';
                }
                action("Job Cost Category Summary")
                {
                    ApplicationArea = All;
                    Caption = 'Job Cost Category Summary';
                    Image = "Report";
                    RunObject = Report "NS_Job Cost Category Summary";
                    ToolTip = 'Job Cost Category Summary';
                }
                action("Committed Cost Detail Report")
                {
                    ApplicationArea = All;
                    Caption = 'Committed Cost Detail Report';
                    Image = "Report";
                    RunObject = Report "NS_Committed Cost DetailReport";
                    ToolTip = 'Committed Cost Detail Report';
                }
                action(Bonding)
                {
                    ApplicationArea = All;
                    Caption = 'Bonding';
                    Image = "Report";
                    RunObject = Report NS_Bonding;
                    Tooltip = 'Bonding';
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
                    tooltip = 'Job Purchase Order Status';
                }
                action("Purch Order Status by Job")
                {
                    ApplicationArea = All;
                    Caption = 'Purch Order Status by Job';
                    Image = "Report";
                    RunObject = Report "NS_Purch Order Status by Job";
                    tooltip = 'Purch Order Status by Job';
                }
                action("Vendor Insurance List")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Insurance List';
                    Image = "Report";
                    RunObject = Report "NS_Vendor Insurance List";
                    ToolTip = 'Vendor Insurance List';
                }
            }
            group("Actual vs. Budget")
            {
                Caption = 'Actual vs. Budget';
                action("Actual vs Budget Cost by APO")
                {
                    ApplicationArea = All;
                    Caption = 'Actual vs Budget Cost by APO';
                    ToolTip = 'Actual vs Budget Cost by APO';
                    Image = "Report";
                    RunObject = Report "NS_ActualvsBudget Cost by APO";
                }
                action("Actual vs Budget Price by APO")
                {
                    ApplicationArea = All;
                    Caption = 'Actual vs Budget Price by APO';
                    Image = "Report";
                    RunObject = Report "NS_Actual vs Budget PricebyAPO";
                    ToolTip = 'Actual vs Budget Price by APO';
                }
                // action("Actual vs Budget Price by RAPO")//PRJ-811.AS.1.0 Commented Action as report not needed anymore
                // {
                //     ApplicationArea = All;
                //     Caption = 'Actual vs Budget Price by RAPO';
                //     Image = "Report";
                //     RunObject = Report "NS_Actual vs BudgetPricebyRAPO";
                //     ToolTip = 'Actual vs Budget Price by RAPO';
                // }
                action("Actual vs Budget Qty by APO")
                {
                    ApplicationArea = All;
                    Caption = 'Actual vs Budget Qty by APO';
                    Image = "Report";
                    RunObject = Report "NS_Actual vs Budget Qty by APO";
                    ToolTip = 'Actual vs Budget Qty by APO';
                }
                action("Actual vs Budget C/WU by APO")
                {
                    ApplicationArea = All;
                    Caption = 'Actual vs Budget C/WU by APO';
                    Image = "Report";
                    RunObject = Report "NS_ActualvsBudget C/WU by APO";
                    tooltip = 'Actual vs Budget C/WU by APO';
                }
                // action("Actual vs Budget Mat by APO")//PRJ-813.AS.1.0 Action commented as report not needed anymore
                // {
                //     ApplicationArea = All;
                //     Caption = 'Actual vs Budget Mat by APO';
                //     Image = "Report";
                //     RunObject = Report "NS_ActualvsBudget Mat by APO";
                //     tooltip = 'Actual vs Budget Mat by APO';
                // }
                action("Actual vs Budget Job Hour")
                {
                    ApplicationArea = All;
                    Caption = 'Actual vs Budget Job Hour';
                    Image = "Report";
                    RunObject = Report "NS_Actual vs Budget Job Hour";
                    tooltip = 'Actual vs Budget Job Hour';
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
                    tooltip = 'Aged A/R with Retention';
                }
                action("Aged A/P with Retention")
                {
                    ApplicationArea = All;
                    Caption = 'Aged A/P with Retention';
                    Image = "Report";
                    RunObject = Report "NS_Aged Accounts Payable Ret";
                    tooltip = 'Aged A/P with Retention';
                }
            }
            group(Subcontracts)
            {
                Caption = 'Subcontracts';
                action("Subcontract Status by Vendor")
                {
                    ApplicationArea = All;
                    Caption = 'Subcontract Status by Vendor';
                    Image = "Report";
                    RunObject = Report "NS_Subcontract Status byVendor";
                    tooltip = 'Subcontract Status by Vendor';
                }
                action("Subcontract Status by Job")
                {
                    ApplicationArea = All;
                    Caption = 'Subcontract Status by Job';
                    Image = "Report";
                    RunObject = Report "NS_Subcontract Status by Job";
                    tooltip = 'Subcontract Status by Job';
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
                tooltip = 'Jobs';
            }
            action("On Order")
            {
                ApplicationArea = All;
                Caption = 'On Order';
                RunObject = Page "Job List";
                RunPageView = WHERE(Status = FILTER(Open));
                tooltip = 'On Order';
            }
            action("Planned and Quoted")
            {
                ApplicationArea = All;
                Caption = 'Planned and Quoted';
                RunObject = Page "Job List";
                RunPageView = WHERE(Status = FILTER(Quote | Planning));
                tooltip = 'Planned and Quoted';
            }
            action(Completed)
            {
                ApplicationArea = All;
                Caption = 'Completed';
                RunObject = Page "Job List";
                RunPageView = WHERE(Status = FILTER(Completed));
                ToolTip = 'Completed';
            }
            action(Unassigned)
            {
                ApplicationArea = All;
                Caption = 'Unassigned';
                RunObject = Page "Job List";
                RunPageView = WHERE("Person Responsible" = FILTER(''));
                tooltip = 'Unassigned';
            }
            action(Action1100773000)
            {
                ApplicationArea = All;
                Caption = 'Subcontracts';
                Image = CalculateRemainingUsage;
                RunObject = Page "NS_Subcontract List";
                tooltip = 'Subcontracts';
            }
            action("Progress Billings")
            {
                ApplicationArea = All;
                Caption = 'Progress Billings';
                Image = CalculateInvoiceDiscount;
                RunObject = Page "NS_Progress Billing List";
                tooltip = 'Progress Billings';
            }
            action(Active)
            {
                ApplicationArea = All;
                Caption = 'Active';
                RunObject = Page "NS_Progress Billing List";
                RunPageView = WHERE(NS_Final = CONST(false));
                tooltip = 'Active';
            }
            action("Sales Invoices")
            {
                ApplicationArea = All;
                Caption = 'Sales Invoices';
                RunObject = Page "Sales Invoice List";
                ToolTip = 'Sales Invoices';
            }
            action("Sales Credit Memos")
            {
                ApplicationArea = All;
                Caption = 'Sales Credit Memos';
                RunObject = Page "Sales Credit Memos";
                tooltip = 'Sales Credit Memos';
            }
            action("Purchase Orders")
            {
                ApplicationArea = All;
                Caption = 'Purchase Orders';
                RunObject = Page "Purchase Order List";
                tooltip = 'Purchase Orders';
            }
            action("Purchase Invoices")
            {
                ApplicationArea = All;
                Caption = 'Purchase Invoices';
                RunObject = Page "Purchase Invoices";
                tooltip = 'Purchase Invoices';
            }
            action("Purchase Credit Memos")
            {
                ApplicationArea = All;
                Caption = 'Purchase Credit Memos';
                RunObject = Page "Purchase Credit Memos";
                tooltip = 'Purchase Credit Memos';
            }
            action(Resources)
            {
                ApplicationArea = All;
                Caption = 'Resources';
                RunObject = Page "Resource List";
                ToolTip = 'Resources';
            }
            action("Resource Groups")
            {
                ApplicationArea = All;
                Caption = 'Resource Groups';
                RunObject = Page "Resource Groups";
                tooltip = 'Resource Groups';
            }
            action(Items)
            {
                ApplicationArea = All;
                Caption = 'Items';
                RunObject = Page "Item List";
                ToolTip = 'Items';
            }
            action(Customers)
            {
                ApplicationArea = All;
                Caption = 'Customers';
                RunObject = Page "Customer List";
                tooltip = 'Customers';
            }
            action(Vendors)
            {
                ApplicationArea = All;
                Caption = 'Vendors';
                RunObject = Page "Vendor List";
                tooltip = 'Vendors';
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
                    tooltip = 'Job Journals';
                }
                action("Job G/L Journals")
                {
                    ApplicationArea = All;
                    Caption = 'Job G/L Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Jobs),
                                        Recurring = CONST(false));
                    ToolTip = 'Job G/L Journals';
                }
                action("Resource Journals")
                {
                    ApplicationArea = All;
                    Caption = 'Resource Journals';
                    RunObject = Page "Resource Jnl. Batches";
                    RunPageView = WHERE(Recurring = CONST(false));
                    tooltip = 'Resource Journals';
                }
                action("Item Journals")
                {
                    ApplicationArea = All;
                    Caption = 'Item Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Item),
                                        Recurring = CONST(false));
                    tooltip = 'Item Journals';
                }
                action("Recurring Job Journals")
                {
                    ApplicationArea = All;
                    Caption = 'Recurring Job Journals';
                    RunObject = Page "Job Journal Batches";
                    RunPageView = WHERE(Recurring = CONST(true));
                    tooltip = 'Recurring Job Journals';
                }
                action("Recurring Resource Journals")
                {
                    ApplicationArea = All;
                    Caption = 'Recurring Resource Journals';
                    RunObject = Page "Resource Jnl. Batches";
                    RunPageView = WHERE(Recurring = CONST(true));
                    tooltip = 'Recurring Resource Journals';
                }
                action("Recurring Item Journals")
                {
                    ApplicationArea = All;
                    Caption = 'Recurring Item Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Item),
                                        Recurring = CONST(true));
                    ToolTip = 'Recurring Item Journals';
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
                    tooltip = 'Cash Receipt Journals';
                }
                // action(Deposit)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Deposit';
                //     Image = Document;
                //     RunObject = Page Deposits;
                //     tooltip = 'Deposit';
                // }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                action("Posted Shipments")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Shipments';
                    RunObject = Page "Posted Sales Shipments";
                    tooltip = 'Posted Shipments';
                }
                action("Posted Sales Invoices")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Sales Invoices';
                    RunObject = Page "Posted Sales Invoices";
                    tooltip = 'Posted Sales Invoices';
                }
                action("Posted Sales Credit Memos")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Sales Credit Memos';
                    RunObject = Page "Posted Sales Credit Memos";
                    ToolTip = 'Posted Sales Credit Memos';
                }
                action("Posted Purchase Receipts")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                    tooltip = 'Posted Purchase Receipts';
                }
                action("Posted Purchase Invoices")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                    ToolTip = 'Posted Purchase Invoices';
                }
                action("Posted Purchase Credit Memos")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page "Posted Purchase Credit Memos";
                    ToolTip = 'Posted Purchase Credit Memos';
                }
                action("G/L Registers")
                {
                    ApplicationArea = All;
                    Caption = 'G/L Registers';
                    RunObject = Page "G/L Registers";
                    ToolTip = 'G/L Registers';
                }
                action("Job Registers")
                {
                    ApplicationArea = All;
                    Caption = 'Job Registers';
                    RunObject = Page "Job Registers";
                    tooltip = 'Job Registers';
                }
                action("Item Registers")
                {
                    ApplicationArea = All;
                    Caption = 'Item Registers';
                    RunObject = Page "Item Registers";
                    ToolTip = 'Item Registers';
                }
                action("Resource Registers")
                {
                    ApplicationArea = All;
                    Caption = 'Resource Registers';
                    RunObject = Page "Resource Registers";
                    ToolTip = 'Resource Registers';
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
                tooltip = 'Job J&ournal';
            }
            action("Job G/L &Journal")
            {
                ApplicationArea = All;
                Caption = 'Job G/L &Journal';
                Image = GLJournal;
                RunObject = Page "Job G/L Journal";
                tooltip = 'Job G/L &Journal';
            }
            action("R&esource Journal")
            {
                ApplicationArea = All;
                Caption = 'R&esource Journal';
                Image = ResourceJournal;
                RunObject = Page "Resource Journal";
                ToolTip = 'R&esource Journal';
            }
            action("C&hange Job Planning Line Date")
            {
                ApplicationArea = All;
                Caption = 'C&hange Job Planning Line Date';
                Image = ChangeDate;
                RunObject = Report "Change Job Dates";
                ToolTip = 'C&hange Job Planning Line Date';
            }
            action("Split Pla&nning Lines")
            {
                ApplicationArea = All;
                Caption = 'Split Pla&nning Lines';
                Image = Splitlines;
                RunObject = Report "Job Split Planning Line";
                tooltip = 'Split Pla&nning Lines';
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
                ToolTip = 'Job &Create Sales Invoice';
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
                ToolTip = 'Update Job I&tem Cost';
            }
            action("Job Calculate &WIP")
            {
                ApplicationArea = All;
                Caption = 'Job Calculate &WIP';
                Image = CalculateWIP;
                RunObject = Report "Job Calculate WIP";
                tooltip = 'Job Calculate &WIP';
            }
            action("Jo&b Post WIP to G/L")
            {
                ApplicationArea = All;
                Caption = 'Jo&b Post WIP to G/L';
                Image = PostedTimeSheet;
                RunObject = Report "Job Post WIP to G/L";
                tooltip = 'Jo&b Post WIP to G/L';
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
                ToolTip = 'Navigate';
            }
        }
    }
}

