/// <summary>
/// Page NSProjectProAccountLite (ID 14021138).
/// </summary>
page 14021138 "NSProjectProAccountLite"
{
    //PE-65.GK.1.0 27Mar2023|Create New Page
    Caption = 'ProjectPro Account Lite';
    PageType = RoleCenter;
    //ContextSensitiveHelpPage = 'user-guide/role-center/projectpro-role-center/';
    layout
    {
        area(rolecenter)
        {
            part(Control1903710908; NS_ProjectProAccountActivities)
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control1903710909; NS_PPAccountActivities)
            {
                ApplicationArea = Basic, Suite;
            }
            group(Control000001)
            {
                part(Control1907692008; "My Accounts")
                {
                    ApplicationArea = Basic, Suite;
                }
                group(Control1900724708)
                {
                    ShowCaption = false;
                }
                part(Control1020027; "Finance Performance")
                {
                    ApplicationArea = Basic, Suite;
                }
                part(Control100; "Cash Flow Forecast Chart")
                {
                    ApplicationArea = Basic, Suite;
                }
                part(Control108; "Report Inbox Part")
                {
                    AccessByPermission = TableData "Report Inbox" = IMD;
                    ApplicationArea = all;
                }
                //PRJCTPR-168.JS.1.0 26Sep2023 - Start
                part(Control1903710906; "Power BI Report Spinner Part")
                {
                    ApplicationArea = All;
                    ObsoleteState = Pending;
                    ObsoleteReason = 'Replaced by PowerBIEmbeddedReportPart';
                    Visible = false;
                    ObsoleteTag = '21.0';

                }
                //PE-267.JS.1.0 05MAR2024 - Start below control is removed by Base BC in Version 2024
                // part(Control1903710907; "Power BI Report FactBox")
                // {
                //     ApplicationArea = All;
                //     ObsoleteState = Pending;
                //     ObsoleteReason = 'Replaced by PowerBIEmbeddedReportPart';
                //     Visible = false;
                //     ObsoleteTag = '21.0';
                // }
                //PE-267.JS.1.0 05MAR2024 - end
                part(PowerBIEmbeddedReportPart; "Power BI Embedded Report Part")
                {
                    ApplicationArea = Basic, Suite;
                }
                //PRJCTPR-168.JS.1.0 26Sep2023 - end
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

                    ToolTip = 'Job Cost Category Summary';
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

                    ToolTip = 'Job Detail by Gross Margin';
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

                    ToolTip = 'Job Purchase Order Status';
                    Image = "Report";
                    RunObject = Report "NS_Job Purchase Order Status";
                }
                action("Purch Order Status by Job")
                {
                    ApplicationArea = All;
                    Caption = 'Purch Order Status by Job';

                    ToolTip = 'Purch Order Status by Job';
                    Image = "Report";
                    RunObject = Report "NS_Purch Order Status by Job";
                }
                action("Vendor Insurance List")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Insurance List';

                    ToolTip = 'Vendor Insurance List';
                    Image = "Report";
                    RunObject = Report "NS_Vendor Insurance List";
                }
            }

            group("PP_Actual vs. Budget")
            {
                Caption = 'Actual vs. Budget';

                tooltip = 'Actual vs. Budget';
                action("NS_Actual vs Budget Cost by APO")
                {
                    ApplicationArea = All;
                    Caption = 'Actual vs Budget Cost by Task';
                    ToolTip = 'Actual vs Budget Cost by Task';
                    Image = "Report";
                    RunObject = Report "NS_ActualvsBudget Cost by APO";
                }
                action("Actual vs Budget Price by APO")
                {
                    ApplicationArea = All;
                    Caption = 'Actual vs Budget Price by Task';
                    Image = "Report";
                    RunObject = Report "NS_Actual vs Budget PricebyAPO";
                }
                action("Actual vs Budget Qty by APO")
                {
                    ApplicationArea = All;
                    Caption = 'Actual vs Budget Qty by Task';
                    Image = "Report";
                    RunObject = Report "NS_Actual vs Budget Qty by APO";
                }
                action("Actual vs Budget C/WU by APO")
                {
                    ApplicationArea = All;
                    Caption = 'Actual vs Budget C/WU by Task';
                    ToolTip = 'Actual vs Budget C/WU by Task';
                    Image = "Report";
                    RunObject = Report "NS_ActualvsBudget C/WU by APO";
                }

                action("Actual vs Budget Job Hour")
                {
                    ApplicationArea = All;
                    Caption = 'Actual vs Budget Job Hour';
                    ToolTip = 'Actual vs Budget Job Hour';
                    Image = "Report";
                    RunObject = Report "NS_Actual vs Budget Job Hour";
                }
                action("NS_VarianceReport")
                {
                    ApplicationArea = All;
                    Caption = 'Variance Report';
                    ToolTip = 'Variance Report';
                    Image = "Report";
                    RunObject = Report "NS_Act vs Bud Cost by APOwQty";
                }
            }
            group(Aging)
            {
                Caption = 'Aging';
                action("Aged A/R with Retention")
                {
                    ApplicationArea = All;
                    Caption = 'Aged A/R with Retention';
                    ToolTip = 'Aged A/R with Retention';
                    Image = "Report";
                    RunObject = Report "NS_Aged Accounts ReceivableRet";
                }
                action("Aged A/P with Retention")
                {
                    ApplicationArea = All;
                    Caption = 'Aged A/P with Retention';

                    ToolTip = 'Aged A/P with Retention';
                    Image = "Report";
                    RunObject = Report "NS_Aged Accounts Payable Ret";
                }
            }
            group(NS_Subcontracts)
            {
                Caption = 'Subcontracts';

                ToolTip = 'Subcontracts';
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

                    ToolTip = 'Subcontract Status by Job';
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

                    ToolTip = 'Variance Report';
                    Image = "Report";
                    RunObject = Report "NS_Act vs Bud Cost by APOwQty";
                }
                action("NS_Job Billing History")
                {
                    ApplicationArea = All;
                    Caption = 'Job Billing History';

                    ToolTip = 'Job Billing History';
                    Image = "Report";
                    RunObject = Report "NS_Job Cost Budget withSorting";
                }
                action("NS_Aged AP Retention by Job")
                {
                    ApplicationArea = All;
                    Caption = 'Aged AP Retention by Job';

                    ToolTip = 'Aged AP Retention by Job';
                    Image = "Report";
                    RunObject = Report "NS_Aged AP Retention by Job";
                }
            }

        }
        area(embedding)
        {
            action(Jobs)
            {
                Caption = 'Jobs';
                RunObject = Page "Job List";
                ApplicationArea = All;
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
            action("Progress Billings")
            {
                ApplicationArea = All;
                Caption = 'Progress Billings';
                Image = CalculateInvoiceDiscount;
                RunObject = Page "NS_Progress Billing List";
            }

            action(Action1100773000)
            {
                ApplicationArea = All;
                Caption = 'Subcontracts';
                Image = CalculateRemainingUsage;
                RunObject = Page "NS_Subcontract List";
            }
            action("Sales Credit Memos")
            {
                ApplicationArea = All;
                Caption = 'Sales Credit Memos';
                RunObject = Page "Sales Credit Memos";
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

            action("Purchase Credit Memos")
            {
                ApplicationArea = All;
                Caption = 'Purchase Credit Memos';
                RunObject = Page "Purchase Credit Memos";
            }
            action("Purchase Orders")
            {
                ApplicationArea = All;
                Caption = 'Purchase Orders';
                RunObject = Page "Purchase Order List";
            }
            action(Customers)
            {
                ApplicationArea = All;
                Caption = 'Customers';
                RunObject = Page "Customer List";
            }
            action(ChartofAccounts)
            {
                ApplicationArea = All;
                Caption = 'Chart of Accounts';
                RunObject = Page "Chart of Accounts";
            }
            action(Vendors)
            {
                ApplicationArea = All;
                Caption = 'Vendors';
                RunObject = Page "Vendor List";
            }
            action(BankAccount)
            {
                ApplicationArea = All;
                Caption = 'Bank Account';
                RunObject = Page "Bank Account List";
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
                // action(Deposit)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Deposit';
                //     Image = Document;
                //     RunObject = Page Deposits;
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
            group("NS_ProjectProReports")
            {
                Caption = 'ProjectPro Reports';
                group("NS_Actual vs Budget")
                {
                    Caption = 'Actual Vs Budget';
                    action("NS_Act vs Bud Cost by Task")
                    {
                        ApplicationArea = All;
                        Caption = 'Actual vs Budget Cost by Task';
                        Image = "Report";
                        RunObject = Report "NS_ActualvsBudget Cost by APO";
                        ToolTip = 'Actual vs Budget Cost by Task';
                    }
                    action("NS_Actual vs Budget Price by Task")
                    {
                        ApplicationArea = All;
                        Caption = 'Actual vs Budget Price by Task';
                        Image = "Report";
                        RunObject = Report "NS_Actual vs Budget PricebyAPO";
                        ToolTip = 'Actual vs Budget Price by Task';
                    }
                    action("NS_Actual vs Budget CWU by Task")
                    {
                        ApplicationArea = All;
                        Caption = 'Actual vs Budget C/WU by APO';
                        Image = "Report";
                        RunObject = Report "NS_ActualvsBudget C/WU by APO";
                        ToolTip = 'Actual vs Budget C/WU by APO';
                    }
                    action("NS_Actual vs Budget Job Hour")
                    {
                        ApplicationArea = All;
                        Caption = 'Actual vs Budget Job Hour';
                        Image = "Report";
                        RunObject = Report "NS_Actual vs Budget Job Hour";
                        ToolTip = 'Actual vs Budget Job Hour';
                    }
                    action("NS_VarianceRept")
                    {
                        ApplicationArea = All;
                        Caption = 'Variance Report';
                        Image = "Report";
                        RunObject = Report "NS_Act vs Bud Cost by APOwQty";
                        ToolTip = 'Variance Report';
                    }
                    action("NS_ActualvsBudget Cost by APO")
                    {
                        ApplicationArea = All;
                        Caption = 'Actual vs Budget Cost by APO';
                        ToolTip = 'Actual vs Budget Cost by APO';
                        Image = "Report";
                        RunObject = Report "NS_ActualvsBudget Cost by APO";
                    }
                    action("NS_Actual vs Budget PricebyAPO")
                    {
                        ApplicationArea = All;
                        Caption = 'Actual vs Budget Price by APO';
                        ToolTip = 'Actual vs Budget Price by APO';
                        Image = "Report";
                        RunObject = Report "NS_Actual vs Budget PricebyAPO";
                    }
                    action("NS_Actual vs BudgetPricebyRAPO")
                    {
                        ApplicationArea = All;
                        Caption = 'Actual vs Budget Price by RAPO';
                        Tooltip = 'Actual vs Budget Price by RAPO';
                        Image = "Report";
                        RunObject = Report "NS_Actual vs BudgetPricebyRAPO";

                    }
                    action("NS_Actual vs Budget Qty by APO")
                    {
                        ApplicationArea = All;
                        Caption = 'Actual vs Budget Qty by APO';
                        Tooltip = 'Actual vs Budget Qty by APO';
                        Image = "Report";
                        RunObject = Report "NS_Actual vs Budget Qty by APO";
                    }

                    action("NS_ActualvsBudget Mat by APO")
                    {
                        ApplicationArea = All;
                        Caption = 'Actual vs Budget Material by APO';
                        Tooltip = 'Actual vs Budget Material by APO';
                        Image = "Report";
                        RunObject = Report "NS_ActualvsBudget Mat by APO";

                    }
                    action("NS_Act vs Bud Cost by APOwQty")
                    {
                        ApplicationArea = All;
                        Caption = 'Act vs Bud Cost by APO w Qty';
                        Tooltip = 'Act vs Bud Cost by APO w Qty';
                        Image = "Report";
                        RunObject = Report "NS_Act vs Bud Cost by APOwQty";
                    }

                }

                group("NS_Finance")
                {
                    Caption = 'Finance';
                    action("NS_Aged Accounts Payable")
                    {
                        ApplicationArea = All;
                        Caption = 'Aged Accounts Payable';
                        Tooltip = 'Aged Accounts Payable';
                        Image = "Report";
                        RunObject = Report "NS_Aged Accounts Payable";
                    }
                    action("NS_Aged Acc. Receivable By Job")
                    {
                        ApplicationArea = All;
                        Caption = 'Aged Acc. Receivable By Job';
                        Tooltip = 'Aged Acc. Receivable By Job';
                        Image = "Report";
                        RunObject = Report "NS_Aged Acc. Receivable By Job";
                    }

                }
                group("NS_Job Activities")
                {
                    Caption = 'Job Activities';
                    action("NS_Revenue Recognition Rep")
                    {
                        ApplicationArea = All;
                        Caption = 'Revenue Recognition Report';
                        Tooltip = 'Revenue Recognition Report';
                        Image = "Report";
                        RunObject = Report "NS_RevenueRecognitionRep";
                    }
                    action("NS_Update Open Job Backlog batch")
                    {
                        ApplicationArea = All;
                        Caption = 'Update Open Job Backlog Batch';
                        ToolTip = 'Specifies the Update Open Job Backlog Batch';
                        Image = UpdateUnitCost;
                        //RunObject = Report "NS_UpdateOpenJobBacklogBatch"; //PE-173.PS.1.0 03Oct2023 Commneted
                        RunObject = Report "NS_Open Job Backlog Batch New"; //PE-173.PS.1.0 03Oct2023
                    }

                }
                group("NS_Job Forecast")
                {
                    Caption = 'Job Forecast';
                    action("NS_Job Forecast Worksheet")
                    {
                        ApplicationArea = All;
                        Caption = 'Job Forecast Worksheet';
                        Tooltip = 'Job Forecast';
                        Image = "Report";
                        RunObject = Report "NS_Job Forecast Worksheet";
                    }
                    action("NS_Job Forecast WhksIncSubLevel")
                    {
                        ApplicationArea = All;
                        Caption = 'Job Forecast Worksheet Inc. Sub. Levels';
                        Tooltip = 'Job Forecast Worksheet Inc. Sub. Levels';
                        Image = "Report";
                        RunObject = Report "NS_JobForecast WhksIncSubLevel";
                    }
                    action("NS_Percentage of CompletionNew")
                    {
                        ApplicationArea = All;
                        Image = "Report";
                        Caption = 'Project Profit Analysis Report';
                        Tooltip = 'Project Profit Analysis Report';
                        RunObject = Report "NS_Percentage of CompletionNew";
                    }
                }
                group("NS_Job Quote")
                {
                    Caption = 'Job Quote';
                    action("NS_JobQuote")
                    {
                        ApplicationArea = All;
                        Image = "Report";
                        Caption = 'Job Quote Report';
                        Tooltip = 'Job Quote Report';
                        RunObject = Report "NS_JobQuote";
                    }
                    action("NS_Job Quote/Proposal")
                    {
                        ApplicationArea = All;
                        Image = "Report";
                        Caption = 'Job Quote/Proposal';
                        Tooltip = 'Job Quote/Proposal';
                        RunObject = Report "NS_Job Quote/Proposal";
                    }
                    action("NS_Quote Pipeline Report")
                    {
                        ApplicationArea = all;
                        Image = "Report";
                        Caption = 'Quote Pipeline Report';
                        Tooltip = 'Quote Pipeline Report';
                        RunObject = Report "NS_Quote Pipeline Report";
                    }
                    action("NS_Job Quote with SegmentScope")
                    {
                        ApplicationArea = all;
                        Image = "Report";
                        Caption = 'Job Quote with Segment Scope';
                        Tooltip = 'Job Quote with Segment Scope';
                        RunObject = Report "NS_Job Quote with SegmentScope";
                    }
                    action("NS_Job Quote Segment SOW")
                    {
                        ApplicationArea = all;
                        Image = "Report";
                        Caption = 'Job Quote Segment SOW';
                        Tooltip = 'Job Quote Segment SOW';
                        RunObject = Report "NS_Job Quote Segment SOW";
                    }
                    action("NS_Job Task Tot Quote Proposal")
                    {
                        ApplicationArea = all;
                        Image = "Report";
                        Caption = 'Job Task Quote/Proposal';
                        Tooltip = 'Job Task Quote/Proposal';
                        RunObject = Report "NS_Job Task Tot Quote Proposal";
                    }

                }
                group("NS_Job Reporting & Analysis")
                {
                    Caption = 'Job Reporting & Analysis';
                    action("NS_APO List")
                    {
                        ApplicationArea = All;
                        Caption = 'APO List';
                        Image = "Report";
                        RunObject = Report "NS_APO List";
                        ToolTip = 'APO List';
                    }
                    action("NS_Job Cost Budget withSorting")
                    {
                        ApplicationArea = all;
                        Image = "Report";
                        Caption = 'Job Cost Budget with Sorting';
                        Tooltip = 'Job Cost Budget with Sorting';
                        RunObject = Report "NS_Job Cost Budget withSorting";
                    }
                    // action("NS_Word Export - Job Data")
                    // {
                    //     ApplicationArea = all;
                    //     Image = "Report";
                    //     Caption = 'Word Export - Job Data';
                    //     Tooltip = 'Word Export - Job Data';
                    //     RunObject = Report "NS_Word Export - Job Data";
                    // }
                    action("NS_Job Detail by Task")
                    {
                        ApplicationArea = all;
                        Image = "Report";
                        Caption = 'Job Detail by Task';
                        Tooltip = 'Job Detail by Task';
                        RunObject = Report "NS_Job Detail by Task";
                    }

                    action("NS_Job Ledger")
                    {
                        ApplicationArea = All;
                        Caption = 'Job Ledger';
                        Image = "Report";
                        RunObject = Report "NS_Job Ledger";
                        ToolTip = 'Job Ledger';
                    }
                    action("NS_Committed Cost Detail Report")
                    {
                        ApplicationArea = All;
                        Caption = 'Committed Cost Detail Report';
                        Tooltip = 'Committed Cost Detail Report';
                        Image = "Report";
                        RunObject = Report "NS_Committed Cost DetailReport";
                    }
                    action("NS_Job Materials List")
                    {
                        ApplicationArea = All;
                        Caption = 'Job Materials List';
                        Tooltip = 'Job Materials List';
                        Image = "Report";
                        RunObject = Report "NS_Job Materials List";
                    }
                    action("NS_Work Order (Job LedgerSumm)")
                    {
                        ApplicationArea = All;
                        Caption = 'Work Order (Job LedgerSumm)';
                        Tooltip = 'Work Order (Job LedgerSumm)';
                        Image = "Report";
                        RunObject = Report "NS_Work Order (Job LedgerSumm)";
                    }
                    action("NS_Job Rcvd Not Invoiced")
                    {
                        ApplicationArea = All;
                        Caption = 'Job Rcvd Not Invoiced';
                        ToolTip = 'Job Rcvd Not Invoiced';
                        RunObject = Report "NS_ProjectPro Rcvd NotInvoiced";
                    }
                    action("NS_Job Quote Estimation Report")
                    {
                        ApplicationArea = All;
                        Caption = 'Job Quote Estimation Report';
                        Tooltip = 'Job Quote Estimation Report';
                        RunObject = Report "NS_JobEstimationJob";
                    }
                    action("NS_Job Change Order")
                    {
                        ApplicationArea = All;
                        Caption = 'Job Change Order';
                        Tooltip = 'Job Change Order';
                        RunObject = Report "NS_Job Change Order";
                    }
                    action("NS_JobEstimationJob")
                    {
                        ApplicationArea = All;
                        Caption = 'Job Estimation Report';
                        Tooltip = 'Job Estimation Report';
                        RunObject = Report "NS_JobEstimationJob";
                    }
                    action("NS_Job Estimate Markup")
                    {
                        ApplicationArea = All;
                        Caption = 'Job Estimate Markup';
                        Tooltip = 'Job Estimate Markup';
                        RunObject = Report "NS_Job Estimate Markup";
                    }
                    action("NS_Job Material PlanningReport")
                    {
                        ApplicationArea = All;
                        Caption = 'Job Material Planning Report';
                        Tooltip = 'Job Material Planning Report';
                        RunObject = Report "NS_Job Material PlanningReport";
                    }
                    action("NS_Job Journal Labor - Test")
                    {
                        ApplicationArea = All;
                        Caption = 'Job Job Journal - Test';//PE-141.NK.1.0 03Aug2023 updated name
                        Tooltip = 'Job Job Journal - Test';//PE-141.NK.1.0 03Aug2023 updated name
                        RunObject = Report "NS_Job Journal Labor - Test";
                    }
                    action("NS_Delivery Ticket JMP")
                    {
                        ApplicationArea = All;
                        Caption = 'Delivery Ticket JMP';
                        Tooltip = 'Delivery Ticket JMP';
                        RunObject = Report "NS_Delivery Ticket JMP";
                    }
                    action("NS_Cost & BillingReportDetail")
                    {
                        ApplicationArea = All;
                        Caption = 'Cost & Billing Report Detailed';
                        Tooltip = 'Cost & Billing Report Detailed';
                        RunObject = Report "NS_Cost & BillingReportDetail";
                    }
                }
                group("NS_LienRelease")
                {
                    Caption = 'Lien Release';
                    action("NS_Lien Release")
                    {
                        ApplicationArea = All;
                        Caption = 'Lien Release 01';
                        Tooltip = 'Lien Release 01';
                        RunObject = Report "NS_Lien Release 01";
                    }
                }
                group("NS_Manufacturing")
                {
                    Caption = 'Manufacturing';
                    action("NS_Job Production")
                    {
                        ApplicationArea = All;
                        Caption = 'Job Production';
                        Tooltip = 'Job Production';
                        RunObject = Report "NS_Job Production";
                    }
                }
                group("NS_Payroll")
                {
                    Caption = 'Payroll';
                    action("NS_Payroll Interf. Test - PAYCHEX")
                    {
                        ApplicationArea = All;
                        Caption = 'Payroll Interf. Test - PAYCHEX';
                        Tooltip = 'Payroll Interf. Test - PAYCHEX';
                        RunObject = Report "NS_Payroll Interf. TestPAYCHEX";
                    }
                    action("NS_CertifiedPayrollExcelReport")
                    {
                        ApplicationArea = All;
                        Caption = 'Certified Payroll Excel Report';
                        Tooltip = 'Certified Payroll Excel Report';
                        RunObject = Report "NS_CertifiedPayrollExcelReport";
                    }
                    action("NS_Payroll Interf. TestPayloci")
                    {
                        ApplicationArea = All;
                        Caption = 'Payroll Interf. Test - Paylocity';
                        Tooltip = 'Payroll Interf. Test - Paylocity';
                        RunObject = Report "NS_Payroll Interf. TestPayloci";
                    }
                    action("NS_Payroll Interf. Prooflist")
                    {
                        ApplicationArea = All;
                        Caption = 'Payroll Interf. Prooflist';
                        Tooltip = 'Payroll Interf. Prooflist';
                        RunObject = Report "NS_Payroll Interf. Prooflist";
                    }
                }
                group("NS_Progress Billing")
                {
                    Caption = 'Progress Billing';
                    action("NS_Per BillingRev CatSumm.")
                    {
                        ApplicationArea = All;
                        Caption = 'Percent Billing - Rev. Cat. Summ.';
                        Tooltip = 'Percent Billing - Rev. Cat. Summ.';
                        RunObject = Report "NS_Per BillingRev CatSumm.";
                    }
                    action("NS_AIA G702")
                    {
                        ApplicationArea = All;
                        Caption = 'AIA G702';
                        Tooltip = 'AIA G702';
                        RunObject = Report "NS_AIA G702";
                    }
                    action("NS_AIA G703")
                    {
                        ApplicationArea = All;
                        Caption = 'AIA G703';
                        Tooltip = 'AIA G703';
                        RunObject = Report "NS_AIA G703";

                    }
                    action("NS_Progress Billing Invoice")
                    {
                        ApplicationArea = all;
                        Caption = 'Progress Billing Invoice';
                        Tooltip = 'Progress Billing Invoice';
                        RunObject = Report "NS_Progress Billing Invoice";
                    }
                    action("NS_Progress Billing with Units")
                    {
                        ApplicationArea = all;
                        Caption = 'Progress Billing with Units';
                        Tooltip = 'Progress Billing with Units';
                        RunObject = Report "NS_Progress Billing with Units";
                    }
                    action("NS_AIA G703 - Revenue Wise")
                    {
                        ApplicationArea = all;
                        Caption = 'AIA G703 - Revenue Wise';
                        Tooltip = 'AIA G703 - Revenue Wise';
                        RunObject = Report "NS_AIA G703 - Revenue Wise";
                    }
                    action("NS_Progress Bill InvRevCatSumm")
                    {
                        ApplicationArea = all;
                        Caption = 'Progress Invoice - Rev. Cat. Summ';
                        Tooltip = 'Progress Bill InvRevCatSumm';
                        RunObject = Report "NS_Progress Bill InvRevCatSumm";
                    }
                }
                group("NS_Progress Payment")
                {
                    caption = 'Progress Payment';
                    action("NS_Progress Payment AIA G702")
                    {
                        ApplicationArea = all;
                        Caption = 'Progress Payment AIA G702';
                        Tooltip = 'Progress Payment AIA G702';
                        RunObject = Report "NS_Progress Payment AIA G702";
                    }
                    action("NS_Progress Payment AIA G703")
                    {
                        ApplicationArea = all;
                        Caption = 'Progress Payment AIA G703';
                        Tooltip = 'Progress Payment AIA G703';
                        RunObject = Report "NS_Progress Payment AIA G703";
                    }
                    action("NS_Progress Payment Invoice")
                    {
                        ApplicationArea = all;
                        Caption = 'Progress Payment Invoice';
                        Tooltip = 'Progress Payment Invoice';
                        RunObject = Report "NS_Progress Payment Invoice";
                    }
                    action("NS_Combined_AIAG702andAIAG703")
                    {
                        ApplicationArea = all;
                        Caption = 'Combined_AIAG702andAIAG703';
                        Tooltip = 'Combined_AIAG702andAIAG703';
                        RunObject = Report "NS_Combined_AIAG702andAIAG703";
                    }
                }


                group("NS_Purchasing")
                {
                    Caption = 'Purchasing';
                    action("NS_Job Purchase Order Status")
                    {
                        ApplicationArea = All;
                        Caption = 'Job Purchase Order Status';
                        Image = "Report";
                        RunObject = Report "NS_Job Purchase Order Status";
                        ToolTip = 'Job Purchase Order Status';
                    }
                    action("NS_Purch Order Status by Job")
                    {
                        ApplicationArea = All;
                        Caption = 'Purch Order Status by Job';
                        Image = "Report";
                        RunObject = Report "NS_Purch Order Status by Job";
                        ToolTip = 'Purch Order Status by Job';
                    }
                    action("NS_Vendor Insurance List")
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor Insurance List';
                        Image = "Report";
                        RunObject = Report "NS_Vendor Insurance List";
                        ToolTip = 'Vendor Insurance List';
                    }

                    action("NS_Open Purch Invoices by Job")
                    {
                        ApplicationArea = All;
                        Caption = 'Job Open Purchase Invoices by Job';//PE-141.NK.1.0 03Aug2023 updated name
                        Tooltip = 'Job Open Purchase Invoices by Job';//PE-141.NK.1.0 03Aug2023 updated name
                        RunObject = Report "NS_Open Purch Invoices by Job";
                    }
                    action("NS_Open Vendor Entries")
                    {
                        ApplicationArea = All;
                        Caption = 'Job Open Vendor Entries';//PE-141.NK.1.0 03Aug2023 updated name
                        Tooltip = 'Job Open Vendor Entries';//PE-141.NK.1.0 03Aug2023 updated name
                        RunObject = Report "NS_Open Vendor Entries";
                    }
                    action("NS_Purchaser Stat. by Invoice")
                    {
                        ApplicationArea = All;
                        Caption = 'Job Purchaser Stat. by Invoice';//PE-141.NK.1.0 03Aug2023 updated name
                        Tooltip = 'Job Purchaser Stat. by Invoice';//PE-141.NK.1.0 03Aug2023 updated name
                        RunObject = Report "NS_Purchaser Stat. by Invoice";
                    }
                    action("NS_Vendor Account Detail")
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor Account Detail';
                        Tooltip = 'Vendor Account Detail';
                        RunObject = Report "NS_Vendor Account Detail";
                    }
                    action("NS_Vendor Purchase Statistics")
                    {
                        ApplicationArea = All;
                        Caption = 'Job Vendor Purchase Statistics';//PE-141.NK.1.0 03Aug2023 updated name
                        Tooltip = 'Job Vendor Purchase Statistics';//PE-141.NK.1.0 03Aug2023 updated name
                        RunObject = Report "NS_Vendor Purchase Statistics";
                    }
                    // action("NS_Purchase Invoice")
                    // {
                    //     ApplicationArea = All;
                    //     Caption = 'Purchase Invoice';
                    //     Tooltip = 'Purchase Invoice';
                    //     RunObject = Report "NS_Purchase Invoice";
                    // }
                    // action("NS_Purchase Order")
                    // {
                    //     ApplicationArea = All;
                    //     Caption = 'Job Purchase Order';//PE-141.NK.1.0 03Aug2023 updated name
                    //     Tooltip = 'Job Purchase Order';//PE-141.NK.1.0 03Aug2023 updated name
                    //     RunObject = Report "NS_Purchase Order";
                    // }
                    action("NS_JobrecNotInv1")
                    {
                        ApplicationArea = All;
                        Caption = 'Purchase Jobs - Received Not Invoiced';
                        Tooltip = 'Purchase Jobs - Received Not Invoiced';
                        RunObject = Report "NS_JobrecNotInv1";
                    }
                }

                group("NS_Revenue Recognition")
                {
                    Caption = 'Revenue Recognition';
                    action("NS_POC Gross Margin")
                    {
                        ApplicationArea = All;
                        Caption = 'Percentage of Completion With Gross Margin';
                        ToolTip = 'Percentage of Completion With Gross Margin';
                        RunObject = Report "NS_POC Gross Margin";
                    }
                    action("NS_Pct of Completion by Dim")
                    {
                        ApplicationArea = All;
                        Caption = 'Percentage of Completion by Dimension';
                        Tooltip = 'Percentage of Completion by Dimension';
                        RunObject = Report "NS_Pct of Completion by Dim";
                    }
                    action("NS_Job WIP Report")
                    {
                        ApplicationArea = All;
                        Caption = 'Job WIP Report';
                        Tooltip = 'Job WIP Report';
                        RunObject = Report "NS_Job WIP Report";
                    }
                }
                group("NS_Sales & Receivable ")
                {
                    Caption = 'Sales & Receivable ';
                    action("NS_Open Sales Invoices by Job")
                    {
                        ApplicationArea = All;
                        Caption = 'Job Open Sales Invoices by Job';//PE-141.NK.1.0 03Aug2023 updated name
                        Tooltip = 'Job Open Sales Invoices by Job';//PE-141.NK.1.0 03Aug2023 updated name
                        RunObject = Report "NS_Open Sales Invoices by Job";
                    }
                    // action("NS_Sales Order")
                    // {
                    //     ApplicationArea = All;
                    //     Caption = 'Sales Order';
                    //     Tooltip = 'Sales Order';
                    //     RunObject = Report "NS_Sales Order";
                    // }
                    // action("NS_Sales Shipment")
                    // {
                    //     ApplicationArea = All;
                    //     Caption = 'Job Sales Shipment';//PE-141.NK.1.0 03Aug2023 updated name
                    //     Tooltip = 'Job Sales Shipment';//PE-141.NK.1.0 03Aug2023 updated name
                    //     RunObject = Report "NS_Sales Shipment";
                    // }
                    // action("NS_Sales Invoice")
                    // {
                    //     ApplicationArea = All;
                    //     Caption = 'Posted Job Sales Invoice';//PE-141.NK.1.0 03Aug2023 updated name
                    //     Tooltip = 'Posted Job Sales Invoice';//PE-141.NK.1.0 03Aug2023 updated name
                    //     RunObject = Report "NS_Sales Invoice";
                    // }
                    // action("NS_Sales Invoice Customized")
                    // {
                    //     ApplicationArea = All;
                    //     Caption = 'Sales Invoice Customized';
                    //     Tooltip = 'Sales Invoice Customized';
                    //     RunObject = Report "NS_Sales Invoice Customized";
                    // }
                    action("NS_Sales Invoice CTSI")
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Invoice CTSI';
                        Tooltip = 'Sales Invoice CTSI';
                        RunObject = Report "NS_Sales Invoice CTSI";
                    }
                    action("NS_Sales Invoice CTSI B4 Post")
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Invoice - Rev. Cat. Summ.';
                        Tooltip = 'Sales Invoice - Rev. Cat. Summ.';
                        RunObject = Report "NS_Sales Invoice CTSI B4 Post";
                    }
                    action("NS_Sales Invoice by Work Order")
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Invoice by Work Order';
                        Tooltip = 'Sales Invoice by Work Order';
                        RunObject = Report "NS_Sales Invoice by Work Order";
                    }
                }
                group("NS_T&M")
                {
                    Caption = 'T&M';
                    action("NS_Daily Field Report")
                    {
                        ApplicationArea = All;
                        Caption = 'Daily Field Report';
                        Tooltip = 'Daily Field Report';
                        RunObject = Report "NS_Daily Field Report";
                    }
                }
            }

            group("NS_ProjectProReportsConst")
            {

                Caption = 'ProjectPro Reports (Cont.)';

                group("NS_JobProfitAndRevenue")
                {
                    Caption = 'Job Profit And Revenue';
                    action("NS_Percentage of Completion")
                    {
                        ApplicationArea = All;
                        Caption = 'Percentage of Completion';
                        Image = "Report";
                        RunObject = Report "NS_Percentage of Completion";
                        ToolTip = 'Percentage of Completion';
                    }
                    action("NS_Bonding")
                    {
                        ApplicationArea = All;
                        Caption = 'Bonding';
                        Image = "Report";
                        RunObject = Report "NS_Bonding";
                        ToolTip = 'Bonding';
                    }
                    action("NS_Job Cost Category Summary")
                    {
                        ApplicationArea = All;
                        Caption = 'Job Cost Category Summary';
                        Image = "Report";
                        RunObject = Report "NS_Job Cost Category Summary";
                        ToolTip = 'Job Cost Category Summary';
                    }
                    action("NS_Committed Cost DetailReport")
                    {
                        ApplicationArea = All;
                        Caption = 'Committed Cost Detailed Report';
                        Image = "Report";
                        RunObject = Report "NS_Committed Cost DetailReport";
                        ToolTip = 'Committed Cost Detailed Report';
                    }
                    action("NS_OPSManagerRep")
                    {
                        ApplicationArea = All;
                        Caption = 'OPS Manager Report';
                        Image = "Report";
                        RunObject = Report "NS_OPSManagerRep";
                        ToolTip = 'OPS Manager Report';
                    }
                    action("NS_Job Status")
                    {
                        ApplicationArea = All;
                        Caption = 'Job Status Report';
                        Image = "Report";
                        RunObject = Report "NS_Job Status";
                        ToolTip = 'Job Status Report';
                    }
                    action("NS_Jobs Gross Profit")
                    {
                        ApplicationArea = All;
                        Caption = 'Jobs Gross Profit';
                        Image = "Report";
                        RunObject = Report "NS_Jobs Gross Profit";
                        ToolTip = 'Jobs Gross Profit';
                    }
                    action("NS_Gross Profit by APO")
                    {
                        ApplicationArea = All;
                        Caption = 'Gross Profit by APO';
                        Image = "Report";
                        RunObject = Report "NS_Gross Profit by APO";
                        ToolTip = 'Gross Profit by APO';
                    }
                    action("NS_Job Detail By Gross Margin")
                    {
                        ApplicationArea = All;
                        Caption = 'Job Detail By Gross Margin';
                        Image = "Report";
                        RunObject = Report "NS_Job Detail By Gross Margin";
                        ToolTip = 'Job Detail By Gross Margin';
                    }
                }
                group("NS_Subcontract")
                {
                    Caption = 'Subcontract';
                    action("NS_Subcontract Status byVendor")
                    {
                        ApplicationArea = All;
                        Caption = 'Subcontract Status byVendor';
                        Image = "Report";
                        RunObject = Report "NS_Subcontract Status byVendor";
                        ToolTip = 'Subcontract Status byVendor';
                    }
                    action("NS_SubconStatus by Job")
                    {
                        ApplicationArea = All;
                        Caption = 'Subcontract Status by Job';
                        Image = "Report";
                        RunObject = Report "NS_Subcontract Status by Job";
                        ToolTip = 'Subcontract Status by Job';
                    }
                }

                group("NS_AgingReports")
                {
                    Caption = 'Aging Reports';
                    action("NS_Aged Accounts ReceivableRet")
                    {
                        ApplicationArea = All;
                        Caption = 'Aged A/R with Retention';
                        Image = "Report";
                        RunObject = Report "NS_Aged Accounts ReceivableRet";
                        ToolTip = 'Aged A/R with Retention';
                    }
                    action("NS_Aged Accounts Payable Ret")
                    {
                        ApplicationArea = All;
                        Caption = 'Aged A/P with Retention';
                        Image = "Report";
                        RunObject = Report "NS_Aged Accounts Payable Ret";
                        ToolTip = 'Aged A/P with Retention';
                    }
                    action("NS_AgedAPRetentionby Job")
                    {
                        ApplicationArea = All;
                        Caption = 'Aged AP Retention by Job';
                        Image = "Report";
                        RunObject = Report "NS_Aged AP Retention by Job";
                        ToolTip = 'Aged AP Retention by Job';
                    }
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
    var
        kkk: page "Accountant Role Center";
}
