page 14021364 "NS_ProjPro Accounting RoleCent"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control99; "Finance Performance")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                part(Control1902304208; "Account Manager Activities")
                {
                    ApplicationArea = All;
                }
                part(Control1100773001; "NS_ProjectProManagerActivity2")
                {
                    ApplicationArea = All;
                }
                part(Control1907692008; "My Customers")
                {
                    ApplicationArea = All;
                }
            }
            group(Control1900724708)
            {
                part(Control103; "Trailing Sales Orders Chart")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                part(Control106; "My Job Queue")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                part(Control100; "Cash Flow Forecast Chart")
                {
                    ApplicationArea = All;
                }
                part(Control1902476008; "My Vendors")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                part("Report inbox"; "Report Inbox Part")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                systempart(Control1901377608; MyNotes)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("&G/L Trial Balance")
            {
                ApplicationArea = All;
                Caption = '&G/L Trial Balance';
                Image = "Report";
                RunObject = Report "Trial Balance";
                ToolTip = '&G/L Trial Balance';
            }
            action("Chart of Accounts")
            {
                ApplicationArea = All;
                Caption = 'Chart of Accounts';
                Image = "Report";
                RunObject = Report "Chart of Accounts";
                ToolTip = 'Chart of Accounts';
            }
            action("&Bank Detail Trial Balance")
            {
                ApplicationArea = All;
                Caption = '&Bank Detail Trial Balance';
                Image = "Report";
                RunObject = Report "Bank Acc. - Detail Trial Bal.";
                ToolTip = '&Bank Detail Trial Balance';
            }
            // PPDA.1.0.TBA Start
            // action("Account Schedule Layout")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Account Schedule Layout';
            //     Image = "Report";
            //     RunObject = Report "Account Schedule Layout";
            //     ToolTip = 'Account Schedule Layout';
            // }
            // PPDA.1.0.TBA End
            action("&Account Schedule")
            {
                ApplicationArea = All;
                Caption = '&Account Schedule';
                Image = "Report";
                RunObject = Report "Account Schedule";
                ToolTip = '&Account Schedule';
            }

            //PPDA.1.0.TBA Start
            // action("Account Balances by GIFI Code")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Account Balances by GIFI Code';
            //     Image = "Report";
            //     RunObject = Report "Account Balances by GIFI Code";
            //     ToolTip = 'Account Balances by GIFI Code';
            // }
            //PPDA.1.0.TBA End
            action(Budget)
            {
                ApplicationArea = All;
                Caption = 'Budget';
                Image = "Report";
                RunObject = Report Budget;
                ToolTip = 'Budget';
            }
            action("Trial Bala&nce/Budget")
            {
                ApplicationArea = All;
                Caption = 'Trial Bala&nce/Budget';
                Image = "Report";
                RunObject = Report "Trial Balance/Budget";
                ToolTip = 'Trial Bala&nce/Budget';
            }

            //PPDA.1.0.TBA Start
            // action("Trial Bala&nce, Spread Periods")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Trial Bala&nce, Spread Periods';
            //     Image = "Report";
            //     RunObject = Report "Trial Balance, Spread Periods";
            //     ToolTip = 'Trial Bala&nce, Spread Periods';
            // }

            // action("Trial Balance, per Global Dim.")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Trial Balance, per Global Dim.';
            //     Image = "Report";
            //     RunObject = Report "Trial Balance, per Global Dim.";
            //     ToolTip = 'Trial Balance, per Global Dim.';
            // }
            // action("Trial Balance, Spread G. Dim.")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Trial Balance, Spread G. Dim.';
            //     Image = "Report";
            //     RunObject = Report "Trial Balance, Spread G. Dim.";
            //     ToolTip = 'Trial Balance, Spread G. Dim.';
            // }
            // action("Trial Balance Detail/Summary")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Trial Balance Detail/Summary';
            //     Image = "Report";
            //     RunObject = Report "Trial Balance Detail/Summary";
            //     ToolTip = 'Trial Balance Detail/Summary';
            // }
            //PPDA.1.0.TBA End
            action("&Fiscal Year Balance")
            {
                ApplicationArea = All;
                Caption = '&Fiscal Year Balance';
                Image = "Report";
                RunObject = Report "Fiscal Year Balance";
            }
            action("Balance Comp. - Prev. Y&ear")
            {
                ApplicationArea = All;
                Caption = 'Balance Comp. - Prev. Y&ear';
                Image = "Report";
                RunObject = Report "Balance Comp. - Prev. Year";
            }
            action("&Closing Trial Balance")
            {
                ApplicationArea = All;
                Caption = '&Closing Trial Balance';
                Image = "Report";
                RunObject = Report "Closing Trial Balance";
            }
            action("Consol. Trial Balance")
            {
                ApplicationArea = All;
                Caption = 'Consol. Trial Balance';
                Image = "Report";
                RunObject = Report "Consolidated Trial Balance";
            }
            separator(Separator49)
            {
            }
            action("Cash Flow Date List")
            {
                ApplicationArea = All;
                Caption = 'Cash Flow Date List';
                Image = "Report";
                RunObject = Report "Cash Flow Date List";
            }
            separator(Separator115)
            {
            }
            action("Aged Accounts &Receivable")
            {
                ApplicationArea = All;
                Caption = 'Aged Accounts &Receivable';
                Image = "Report";
                RunObject = Report "Aged Accounts Receivable";
            }
            action("Aged Accounts Pa&yable")
            {
                ApplicationArea = All;
                Caption = 'Aged Accounts Pa&yable';
                Image = "Report";
                RunObject = Report "Aged Accounts Payable";
            }

            //PPDA.1.0.TBA Start
            // action("Projected Cash Receipts")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Projected Cash Receipts';
            //     Image = "Report";
            //     RunObject = Report "Projected Cash Receipts";
            // }
            // action("Cash Requirem. by Due Date")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Cash Requirem. by Due Date';
            //     Image = "Report";
            //     RunObject = Report "Cash Requirements by Due Date";
            // }
            // action("Projected Cash Payments")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Projected Cash Payments';
            //     Image = PaymentForecast;
            //     RunObject = Report "Projected Cash Payments";
            // }
            //PPDA.1.0.TBA End
            action("Reconcile Cust. and Vend. Accs")
            {
                ApplicationArea = All;
                Caption = 'Reconcile Cust. and Vend. Accs';
                Image = "Report";
                RunObject = Report "Reconcile Cust. and Vend. Accs";
            }

            //PPDA.1.0.TBA Start
            // action("Daily Invoicing Report")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Daily Invoicing Report';
            //     Image = "Report";
            //     RunObject = Report "Daily Invoicing Report";
            // }
            // action("Bank Account - Reconcile")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Bank Account - Reconcile';
            //     Image = "Report";
            //     RunObject = Report "Bank Account - Reconcile";
            // }
            //PPDA.1.0.TBA End
            separator(Separator53)
            {
            }
            separator("Sales Tax")
            {
                Caption = 'Sales Tax';
                IsHeader = true;
            }
            //PPDA.1.0.TBA Start
            // action("Sales Tax Details")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Sales Tax Details';
            //     Image = "Report";
            //     RunObject = Report "Sales Tax Detail List";
            // }
            // action("Sales Tax Groups")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Sales Tax Groups';
            //     Image = "Report";
            //     RunObject = Report "Sales Tax Group List";
            // }
            // action("Sales Tax Jurisdictions")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Sales Tax Jurisdictions';
            //     Image = "Report";
            //     RunObject = Report "Sales Tax Jurisdiction List";
            // }
            // action("Sales Tax Areas")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Sales Tax Areas';
            //     Image = "Report";
            //     RunObject = Report "Sales Tax Area List";
            // }
            // action("Sales Tax Detail by Area")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Sales Tax Detail by Area';
            //     Image = "Report";
            //     RunObject = Report "Sales Tax Detail by Area";
            // }
            //PPDA.1.0.TBA End
            action("Sales Taxes Collected")
            {
                ApplicationArea = All;
                Caption = 'Sales Taxes Collected';
                Image = "Report";
                RunObject = Report "Sales Taxes Collected";
            }
            action("Tax Statement")
            {
                ApplicationArea = All;
                Caption = 'Tax Statement';
                Image = "Report";
                RunObject = Report "VAT Statement";
            }
            action("VAT - VIES Declaration Tax Aut&h")
            {
                ApplicationArea = All;
                Caption = 'VAT - VIES Declaration Tax Aut&h';
                Image = "Report";
                RunObject = Report "VAT- VIES Declaration Tax Auth";
            }
            action("VAT - VIES Declaration Dis&k")
            {
                ApplicationArea = All;
                Caption = 'VAT - VIES Declaration Dis&k';
                Image = "Report";
                RunObject = Report "VAT- VIES Declaration Disk";
            }
            action("EC Sales &List")
            {
                ApplicationArea = All;
                Caption = 'EC Sales &List';
                Image = "Report";
                RunObject = Report "EC Sales List";
            }
            separator(Separator60)
            {
            }
            action("&Intrastat - Checklist")
            {
                ApplicationArea = All;
                Caption = '&Intrastat - Checklist';
                Image = "Report";
                RunObject = Report "Intrastat - Checklist";
            }
            action("Intrastat - For&m")
            {
                ApplicationArea = All;
                Caption = 'Intrastat - For&m';
                Image = "Report";
                RunObject = Report "Intrastat - Form";
            }
            separator(Separator4)
            {

            }
            action("Cost Accounting P/L Statement")
            {
                ApplicationArea = All;
                Caption = 'Cost Accounting P/L Statement';
                Image = "Report";
                RunObject = Report "Cost Acctg. Statement";
            }
            action("CA P/L Statement per Period")
            {
                ApplicationArea = All;
                Caption = 'CA P/L Statement per Period';
                Image = "Report";
                RunObject = Report "Cost Acctg. Stmt. per Period";
            }
            action("CA P/L Statement with Budget")
            {
                ApplicationArea = All;
                Caption = 'CA P/L Statement with Budget';
                Image = "Report";
                RunObject = Report "Cost Acctg. Statement/Budget";
            }
            action("Cost Accounting Analysis")
            {
                ApplicationArea = All;
                Caption = 'Cost Accounting Analysis';
                Image = "Report";
                RunObject = Report "Cost Acctg. Analysis";
            }
            separator(Separator1400022)
            {
            }

            //PPDA.1.0.TBA Start
            // action("Outstanding Purch. Order Aging")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Outstanding Purch. Order Aging';
            //     Image = "Report";
            //     RunObject = Report "Outstanding Purch. Order Aging";
            // }
            //PPDA.1.0.TBA End
            action("Inventory Valuation")
            {
                ApplicationArea = All;
                Caption = 'Inventory Valuation';
                Image = "Report";
                RunObject = Report "Inventory Valuation";
            }

            //PPDA.1.0.TBA Start
            // action("Item Turnover")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Item Turnover';
            //     Image = "Report";
            //     RunObject = Report "Item Turnover";
            // }
            //PPDA.1.0.TBA End
        }
        area(embedding)
        {
            action(Action2)
            {
                ApplicationArea = All;
                Caption = 'Chart of Accounts';
                RunObject = Page "Chart of Accounts";
            }
            action(Vendors)
            {
                ApplicationArea = All;
                Caption = 'Vendors';
                Image = Vendor;
                RunObject = Page "Vendor List";
            }
            action(VendorsBalance)
            {
                ApplicationArea = All;
                Caption = 'Balance';
                Image = Balance;
                RunObject = Page "Vendor List";
                RunPageView = WHERE("Balance (LCY)" = FILTER(<> 0));
            }
            action("Purchase Orders")
            {
                ApplicationArea = All;
                Caption = 'Purchase Orders';
                RunObject = Page "Purchase Order List";
            }
            action(Budgets)
            {
                ApplicationArea = All;
                Caption = 'Budgets';
                RunObject = Page "G/L Budget Names";
            }
            action("Bank Accounts")
            {
                ApplicationArea = All;
                Caption = 'Bank Accounts';
                Image = BankAccount;
                RunObject = Page "Bank Account List";
            }
            action("Tax Statements")
            {
                ApplicationArea = All;
                Caption = 'Tax Statements';
                RunObject = Page "VAT Statement Names";
            }
            action(Items)
            {
                ApplicationArea = All;
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
            }
            action(Customers)
            {
                ApplicationArea = All;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
            }
            action(CustomersBalance)
            {
                ApplicationArea = All;
                Caption = 'Balance';
                Image = Balance;
                RunObject = Page "Customer List";
                RunPageView = WHERE("Balance (LCY)" = FILTER(<> 0));
            }
            action("Sales Orders")
            {
                ApplicationArea = All;
                Caption = 'Sales Orders';
                Image = "Order";
                RunObject = Page "Sales Order List";
            }
            action(Reminders)
            {
                ApplicationArea = All;
                Caption = 'Reminders';
                Image = Reminder;
                RunObject = Page "Reminder List";
            }
            action("Finance Charge Memos")
            {
                ApplicationArea = All;
                Caption = 'Finance Charge Memos';
                Image = FinChargeMemo;
                RunObject = Page "Finance Charge Memo List";
            }
            action("Incoming Documents")
            {
                ApplicationArea = All;
                Caption = 'Incoming Documents';
                Image = Documents;
                RunObject = Page "Incoming Documents";
            }
        }
        area(sections)
        {
            group(Journals)
            {
                Caption = 'Journals';
                Image = Journals;
                action(PurchaseJournals)
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Purchases),
                                        Recurring = CONST(false));
                }
                action(SalesJournals)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Sales),
                                        Recurring = CONST(false));
                }
                action(CashReceiptJournals)
                {
                    ApplicationArea = All;
                    Caption = 'Cash Receipt Journals';
                    Image = Journals;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST("Cash Receipts"),
                                        Recurring = CONST(false));
                }
                action(PaymentJournals)
                {
                    ApplicationArea = All;
                    Caption = 'Payment Journals';
                    Image = Journals;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Payments),
                                        Recurring = CONST(false));
                }
                action(ICGeneralJournals)
                {
                    ApplicationArea = All;
                    Caption = 'IC General Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Intercompany),
                                        Recurring = CONST(false));
                }
                action(GeneralJournals)
                {
                    ApplicationArea = All;
                    Caption = 'General Journals';
                    Image = Journal;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(General),
                                        Recurring = CONST(false));
                }
                action("Intrastat Journals")
                {
                    ApplicationArea = All;
                    Caption = 'Intrastat Journals';
                    Image = "Report";
                    RunObject = Page "Intrastat Jnl. Batches";
                }
            }
            group("Fixed Assets")
            {
                Caption = 'Fixed Assets';
                Image = FixedAssets;
                action(Action17)
                {
                    ApplicationArea = All;
                    Caption = 'Fixed Assets';
                    RunObject = Page "Fixed Asset List";
                }
                action(Insurance)
                {
                    ApplicationArea = All;
                    Caption = 'Insurance';
                    RunObject = Page "Insurance List";
                }
                action("Fixed Assets G/L Journals")
                {
                    ApplicationArea = All;
                    Caption = 'Fixed Assets G/L Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Assets),
                                        Recurring = CONST(false));
                }
                action("Fixed Assets Journals")
                {
                    ApplicationArea = All;
                    Caption = 'Fixed Assets Journals';
                    RunObject = Page "FA Journal Batches";
                    RunPageView = WHERE(Recurring = CONST(false));
                }
                action("Fixed Assets Reclass. Journals")
                {
                    ApplicationArea = All;
                    Caption = 'Fixed Assets Reclass. Journals';
                    RunObject = Page "FA Reclass. Journal Batches";
                }
                action("Insurance Journals")
                {
                    ApplicationArea = All;
                    Caption = 'Insurance Journals';
                    RunObject = Page "Insurance Journal Batches";
                }
                action("<Action3>")
                {
                    ApplicationArea = All;
                    Caption = 'Recurring General Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(General),
                                        Recurring = CONST(true));
                }
                action("Recurring Fixed Asset Journals")
                {
                    ApplicationArea = All;
                    Caption = 'Recurring Fixed Asset Journals';
                    RunObject = Page "FA Journal Batches";
                    RunPageView = WHERE(Recurring = CONST(true));
                }
            }
            group("Cash Flow")
            {
                Caption = 'Cash Flow';
                action("Cash Flow Forecasts")
                {
                    ApplicationArea = All;
                    Caption = 'Cash Flow Forecasts';
                    RunObject = Page "Cash Flow Forecast List";
                }
                action("Chart of Cash Flow Accounts")
                {
                    ApplicationArea = All;
                    Caption = 'Chart of Cash Flow Accounts';
                    RunObject = Page "Chart of Cash Flow Accounts";
                }
                action("Cash Flow Manual Revenues")
                {
                    ApplicationArea = All;
                    Caption = 'Cash Flow Manual Revenues';
                    RunObject = Page "Cash Flow Manual Revenues";
                }
                action("Cash Flow Manual Expenses")
                {
                    ApplicationArea = All;
                    Caption = 'Cash Flow Manual Expenses';
                    RunObject = Page "Cash Flow Manual Expenses";
                }
            }
            group("Cost Accounting")
            {
                Caption = 'Cost Accounting';
                action("Cost Types")
                {
                    ApplicationArea = All;
                    Caption = 'Cost Types';
                    RunObject = Page "Chart of Cost Types";
                }
                action("Cost Centers")
                {
                    ApplicationArea = All;
                    Caption = 'Cost Centers';
                    RunObject = Page "Chart of Cost Centers";
                }
                action("Cost Objects")
                {
                    ApplicationArea = All;
                    Caption = 'Cost Objects';
                    RunObject = Page "Chart of Cost Objects";
                }
                action("Cost Allocations")
                {
                    ApplicationArea = All;
                    Caption = 'Cost Allocations';
                    RunObject = Page "Cost Allocation Sources";
                }
                action("Cost Budgets")
                {
                    ApplicationArea = All;
                    Caption = 'Cost Budgets';
                    RunObject = Page "Cost Budget Names";
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("Posted Sales Invoices")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Sales Invoices';
                    Image = PostedOrder;
                    RunObject = Page 143;
                }
                action("Posted Sales Credit Memos")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Credit Memos";
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
                action("Issued Reminders")
                {
                    ApplicationArea = All;
                    Caption = 'Issued Reminders';
                    Image = OrderReminder;
                    RunObject = Page "Issued Reminder List";
                }
                action("Issued Fin. Charge Memos")
                {
                    ApplicationArea = All;
                    Caption = 'Issued Fin. Charge Memos';
                    Image = PostedMemo;
                    RunObject = Page "Issued Fin. Charge Memo List";
                }
                action("G/L Registers")
                {
                    ApplicationArea = All;
                    Caption = 'G/L Registers';
                    Image = GLRegisters;
                    RunObject = Page "G/L Registers";
                }
                action("Cost Accounting Registers")
                {
                    ApplicationArea = All;
                    Caption = 'Cost Accounting Registers';
                    RunObject = Page "Cost Registers";
                }
                action("Cost Accounting Budget Registers")
                {
                    ApplicationArea = All;
                    Caption = 'Cost Accounting Budget Registers';
                    RunObject = Page "Cost Budget Registers";
                }

                //PPDA.1.0.TBA Start
                // action("Posted Deposits")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Posted Deposits';
                //     Image = PostedDeposit;
                //     RunObject = Page "Posted Deposit List";
                // }
                // action("Posted Bank Recs.")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Posted Bank Recs.';
                //     RunObject = Page "Posted Bank Rec. List";
                // }
                //PPDA.1.0.TBA End
                action("Bank Statements")
                {
                    ApplicationArea = All;
                    Caption = 'Bank Statements';
                    RunObject = Page "Bank Account Statement List";
                }
            }
            group(Administration)
            {
                Caption = 'Administration';
                Image = Administration;
                action(Currencies)
                {
                    ApplicationArea = All;
                    Caption = 'Currencies';
                    Image = Currency;
                    RunObject = Page Currencies;
                }
                action("Accounting Periods")
                {
                    ApplicationArea = All;
                    Caption = 'Accounting Periods';
                    Image = AccountingPeriods;
                    RunObject = Page "Accounting Periods";
                }
                action("Number Series")
                {
                    ApplicationArea = All;
                    Caption = 'Number Series';
                    RunObject = Page "No. Series";
                }
                action("Analysis Views")
                {
                    ApplicationArea = All;
                    Caption = 'Analysis Views';
                    RunObject = Page "Analysis View List";
                }
                action("Account Schedules")
                {
                    ApplicationArea = All;
                    Caption = 'Account Schedules';
                    RunObject = Page "Account Schedule Names";
                }
                action(Dimensions)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page Dimensions;
                }
                action("Bank Account Posting Groups")
                {
                    ApplicationArea = All;
                    Caption = 'Bank Account Posting Groups';
                    RunObject = Page "Bank Account Posting Groups";
                }

                //PPDA.1.0.TBA Start
                // action("IRS 1099 Form-Box")
                // {
                //     ApplicationArea = All;
                //     Caption = 'IRS 1099 Form-Box';
                //     Image = "1099Form";
                //     RunObject = Page "IRS 1099 Form-Box";
                // }
                // action("GIFI Codes")
                // {
                //     ApplicationArea = All;
                //     Caption = 'GIFI Codes';
                //     RunObject = Page "GIFI Codes";
                // }
                //PPDA.1.0.TBA End
                action("Tax Areas")
                {
                    ApplicationArea = All;
                    Caption = 'Tax Areas';
                    RunObject = Page "Tax Area List";
                }
                action("Tax Jurisdictions")
                {
                    ApplicationArea = All;
                    Caption = 'Tax Jurisdictions';
                    RunObject = Page "Tax Jurisdictions";
                }
                action("Tax Groups")
                {
                    ApplicationArea = All;
                    Caption = 'Tax Groups';
                    RunObject = Page "Tax Groups";
                }
                action("Tax Details")
                {
                    ApplicationArea = All;
                    Caption = 'Tax Details';
                    RunObject = Page "Tax Details";
                }
                action("Tax  Business Posting Groups")
                {
                    ApplicationArea = All;
                    Caption = 'Tax  Business Posting Groups';
                    RunObject = Page "VAT Business Posting Groups";
                }
                action("Tax Product Posting Groups")
                {
                    ApplicationArea = All;
                    Caption = 'Tax Product Posting Groups';
                    RunObject = Page "VAT Product Posting Groups";
                }
            }
            group("Cash Management")
            {
                Caption = 'Cash Management';
                action(Action1400017)
                {
                    ApplicationArea = All;
                    Caption = 'Bank Accounts';
                    Image = BankAccount;
                    RunObject = Page "Bank Account List";
                }

                //PPDA.1.0.TBA Start
                // action(Deposit)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Deposit';
                //     Image = DepositSlip;
                //     RunObject = Page Deposits;
                // }
                //PPDA.1.0.TBA End
                action("Bank Rec.")
                {
                    ApplicationArea = All;
                    Caption = 'Bank Rec.';
                    RunObject = Page "Bank Acc. Reconciliation List";
                }
            }
        }
        area(creation)
        {
            action("Sales &Credit Memo")
            {
                ApplicationArea = All;
                Caption = 'Sales &Credit Memo';
                Image = CreditMemo;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Sales Credit Memo";
                RunPageMode = Create;
            }
            action("P&urchase Credit Memo")
            {
                ApplicationArea = All;
                Caption = 'P&urchase Credit Memo';
                Image = CreditMemo;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Credit Memo";
                RunPageMode = Create;
            }
            action("Bank Account Reconciliation")
            {
                ApplicationArea = All;
                Caption = 'Bank Account Reconciliation';
                Image = BankAccountRec;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Bank Acc. Reconciliation List";
                RunPageMode = Create;
            }
        }
        area(processing)
        {
            separator(Tasks)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action("Cas&h Receipt Journal")
            {
                ApplicationArea = All;
                Caption = 'Cas&h Receipt Journal';
                Image = CashReceiptJournal;
                RunObject = Page "Cash Receipt Journal";
            }
            action("Pa&yment Journal")
            {
                ApplicationArea = All;
                Caption = 'Pa&yment Journal';
                Image = PaymentJournal;
                RunObject = Page "Payment Journal";
            }
            action("Purchase Journal")
            {
                ApplicationArea = All;
                Caption = 'Purchase Journal';
                Image = Journals;
                RunObject = Page "Purchase Journal";
            }

            //PPDA.1.0.TBA Start
            // action(Action1480100)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Deposit';
            //     Image = DepositSlip;
            //     RunObject = Page Deposit;
            // }
            //PPDA.1.0.TBA End
            separator(Separator67)
            {
            }
            action("Analysis &Views")
            {
                ApplicationArea = All;
                Caption = 'Analysis &Views';
                Image = AnalysisView;
                RunObject = Page "Analysis View List";
            }
            action("Analysis by &Dimensions")
            {
                ApplicationArea = All;
                Caption = 'Analysis by &Dimensions';
                Image = AnalysisViewDimension;
                RunObject = Page "Analysis by Dimensions";
            }
            action("Calculate Deprec&iation")
            {
                ApplicationArea = All;
                Caption = 'Calculate Deprec&iation';
                Ellipsis = true;
                Image = CalculateDepreciation;
                RunObject = Report "Calculate Depreciation";
            }
            action("Import Co&nsolidation from Database")
            {
                ApplicationArea = All;
                Caption = 'Import Co&nsolidation from Database';
                Ellipsis = true;
                Image = ImportDatabase;
                RunObject = Report "Import Consolidation from DB";
            }
            action("Bank Account R&econciliation")
            {
                ApplicationArea = All;
                Caption = 'Bank Account R&econciliation';
                Image = BankAccountRec;
                RunObject = Page "Bank Acc. Reconciliation List";
            }
            action("Adjust E&xchange Rates")
            {
                ApplicationArea = All;
                Caption = 'Adjust E&xchange Rates';
                Ellipsis = true;
                Image = AdjustExchangeRates;
                RunObject = Report "Adjust Exchange Rates";
            }
            action("P&ost Inventory Cost to G/L")
            {
                ApplicationArea = All;
                Caption = 'P&ost Inventory Cost to G/L';
                Image = PostInventoryToGL;
                RunObject = Report "Post Inventory Cost to G/L";
            }
            separator(Separator97)
            {

            }
            action("C&reate Reminders")
            {
                ApplicationArea = All;
                Caption = 'C&reate Reminders';
                Ellipsis = true;
                Image = CreateReminders;
                RunObject = Report "Create Reminders";
            }
            action("Create Finance Charge &Memos")
            {
                ApplicationArea = All;
                Caption = 'Create Finance Charge &Memos';
                Ellipsis = true;
                Image = CreateFinanceChargememo;
                RunObject = Report "Create Finance Charge Memos";
            }
            separator(Separator73)
            {
            }
            action("Intrastat &Journal")
            {
                ApplicationArea = All;
                Caption = 'Intrastat &Journal';
                Image = Journal;
                RunObject = Page "Intrastat Jnl. Batches";
            }
            action("Calc. and Pos&t Tax Settlement")
            {
                ApplicationArea = All;
                Caption = 'Calc. and Pos&t Tax Settlement';
                Image = SettleOpenTransactions;
                RunObject = Report "Calc. and Post VAT Settlement";
            }
            separator(Separator80)
            {
                Caption = 'Administration';
                IsHeader = true;
            }
            action("General &Ledger Setup")
            {
                ApplicationArea = All;
                Caption = 'General &Ledger Setup';
                Image = Setup;
                RunObject = Page "General Ledger Setup";
            }
            action("&Sales && Receivables Setup")
            {
                ApplicationArea = All;
                Caption = '&Sales && Receivables Setup';
                Image = Setup;
                RunObject = Page "Sales & Receivables Setup";
            }
            action("&Purchases && Payables Setup")
            {
                ApplicationArea = All;
                Caption = '&Purchases && Payables Setup';
                Image = Setup;
                RunObject = Page "Purchases & Payables Setup";
            }
            action("&Fixed Asset Setup")
            {
                ApplicationArea = All;
                Caption = '&Fixed Asset Setup';
                Image = Setup;
                RunObject = Page "Fixed Asset Setup";
            }
            action("Cash Flow Setup")
            {
                ApplicationArea = All;
                Caption = 'Cash Flow Setup';
                Image = CashFlowSetup;
                RunObject = Page "Cash Flow Setup";
            }
            action("Cost Accounting Setup")
            {
                ApplicationArea = All;
                Caption = 'Cost Accounting Setup';
                Image = CostAccountingSetup;
                RunObject = Page "Cost Accounting Setup";
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

            //PPDA.1.0.TBA Start
            // action("Export GIFI Info. to Excel")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Export GIFI Info. to Excel';
            //     Image = ExportToExcel;
            //     RunObject = Report "Export GIFI Info. to Excel";
            // }
            //PPDA.1.0.TBA End
        }
    }
}

