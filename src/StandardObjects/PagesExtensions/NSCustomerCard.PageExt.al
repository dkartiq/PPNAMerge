pageextension 14021102 NS_CustomerCard extends "Customer Card"
{
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,NAVMX11.00.00.23572,PPNA11.00
    //PRJ-197:AS:10APRIL2020 :Creted new variables PP_DtldCustLedgEntry1,PP_RetentionBalanceToshow,BalanceWTRetention,BalanceWTRetentionToshow.
    //PRJ-197:AS:10APRIL2020 : Commented old code for PP_RetentionBalanceLCY & Calculated PP_RetentionBalance
    //PRJ-197:AS:10APRIL2020 : Calculated BalanceWTRetention & Added on page after "PP Retention Balance (LCY)".
    //PRJ-197:AS:17APRIL2020 : Hide the "Balance (LCY)" field.
    //PRJ-197:AS:17APRIL2020 : Added "BalanceWTFilters" field before "Balance Due (LCY)" field.
    //PRJ-251 AS1.0 29-04-20 Code Commented
    //PRJ-250:AS:10JUNE2020 : Added & Commented code
    //PRJ-472.MS.1.0 resolve the issue of blank record when click on Bal fields
    //PRJ-827.JS.1.0�09Aug2021 | Optimize code while opening customer card in OnAfterGetRecord trigger
    //PRJ-882.JS.1.0 27Aug2021 | Add on new field for total Sales
    layout
    {

        //Unsupported feature: Change SubPageLink on "CustomerStatisticsFactBox(Control 1902018507)". Please convert manually.

        //PRJ-197:AS:17APRIL2020 - start
        modify("Balance (LCY)")
        {
            Visible = false;
        }

        modify("Balance Due (LCY)")
        {
            Visible = false;
        }

        modify(TotalSales2)   //PRJ-882.JS.1.0 27Aug2021
        {
            Visible = false;
        }

        addafter("Document Sending Profile")   //PRJ-882.JS.1.0 27Aug2021
        {

            field("NS_Total Sales"; Rec."NS_Total Sales")
            {
                ToolTip = 'Specifies the value of the Total Sales for customer';
                ApplicationArea = All;
            }
        }

        addbefore("Balance Due (LCY)")
        {
            field(NS_BalanceWTFilters; BalanceWTFilters)
            {
                Caption = 'Balance ($)';
                Description = 'Field used to show balance without retention ledger filters';
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Field used to show balance without retention ledger filters';

                trigger OnDrillDown();
                begin
                    NS_DtldCustLedgEntry.RESET;
                    NS_DtldCustLedgEntry.SETRANGE("Customer No.", "No.");
                    COPYFILTER("Global Dimension 1 Filter", NS_DtldCustLedgEntry."Initial Entry Global Dim. 1");
                    COPYFILTER("Global Dimension 2 Filter", NS_DtldCustLedgEntry."Initial Entry Global Dim. 2");
                    COPYFILTER("Currency Filter", NS_DtldCustLedgEntry."Currency Code");
                    NS_CustLedgEntry.DrillDownOnEntries(NS_DtldCustLedgEntry);
                    // rec.Reset();//PRJ-472.MS.1.0//PRJ-713.AS.1.0 Commented
                end;
            }
            //PRJ-250:AS:10JUNE2020 - Start
            field(NS_BalanceDueLcy_NToshow; BalanceDueLcy_NToshow)
            {
                Caption = 'Balance Due ($)';
                Description = 'Field used to show Balance wdue LCY';
                Editable = false;
                ApplicationArea = All;

                trigger OnDrillDown();
                var
                    CustLegEnt: Record "Cust. Ledger Entry";
                begin
                    CustLegEnt.Reset;
                    CustLegEnt.SETCURRENTKEY("Customer No.", "Posting Date");
                    CustLegEnt.SetRange("Customer No.", "No.");
                    CustLegEnt.SETRANGE(Open, TRUE);
                    if (GETFILTER("Date Filter") <> '') then
                        CopyFilter("Date Filter", CustLegEnt."Due Date");
                    PAGE.RUN(0, CustLegEnt);
                    // rec.Reset();//PRJ-472.MS.1.0//PRJ-713.AS.1.0 Commented

                end;
            }
            //PRJ-250:AS:10JUNE2020 - end
        }
        //PRJ-197:AS:17APRIL2020 - end

        addafter("Balance Due (LCY)")
        {
            field("NS_Retention Balance (LCY)"; NS_RetentionBalanceLCY)
            {
                Caption = 'Retention Balance ($)';
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Retention Balance';

                trigger OnDrillDown();
                begin
                    //ProjectPro - start
                    if not NS_SalesSetup."NS_Sales Retention Inactive" then begin
                        NS_DtldCustLedgEntry.RESET;
                        NS_DtldCustLedgEntry.SETRANGE("Customer No.", "No.");
                        COPYFILTER("Global Dimension 1 Filter", NS_DtldCustLedgEntry."Initial Entry Global Dim. 1");
                        COPYFILTER("Global Dimension 2 Filter", NS_DtldCustLedgEntry."Initial Entry Global Dim. 2");
                        NS_DtldCustLedgEntry.SETFILTER("NS_Retention Ledger Code", NS_JobsSetup."NS_Retention Receivable Ledger");
                        COPYFILTER("Currency Filter", NS_DtldCustLedgEntry."Currency Code");
                        NS_CustLedgEntry.DrillDownOnEntries(NS_DtldCustLedgEntry);
                        // rec.Reset();//PRJ-472.MS.1.0//PRJ-713.AS.1.0 Commented
                    end;
                    //ProjectPro - end
                end;
            }
            //PRJ-197:AS:10APRIL2020 - start
            field(NS_BalanceWTRetention; BalanceWTRetention)
            {
                Caption = 'Balance Without Retention($)';
                Editable = false;
                ApplicationArea = All;

                trigger OnDrillDown();
                begin
                    NS_DtldCustLedgEntry.RESET;
                    NS_DtldCustLedgEntry.SETRANGE("Customer No.", "No.");
                    COPYFILTER("Global Dimension 1 Filter", NS_DtldCustLedgEntry."Initial Entry Global Dim. 1");
                    COPYFILTER("Global Dimension 2 Filter", NS_DtldCustLedgEntry."Initial Entry Global Dim. 2");
                    NS_DtldCustLedgEntry.SETFILTER("NS_Retention Ledger Code", NS_SalesSetup."NS_Normal Customer Ledger No.");
                    COPYFILTER("Currency Filter", NS_DtldCustLedgEntry."Currency Code");
                    NS_CustLedgEntry.DrillDownOnEntries(NS_DtldCustLedgEntry);
                    // rec.Reset();//PRJ-472.MS.1.0 //PRJ-713.AS.1.0 Commented
                end;
            }
            //PRJ-197:AS:10APRIL2020 - end
        }

    }
    actions
    {
        modify("Ledger E&ntries")
        {
            trigger OnBeforeAction();
            begin
                //ProjectPro - start
                //PRJ-251 AS1.0 29-04-20 Commented START
                // PP_CustLedgEntry.RESET;
                // PP_CustLedgEntry.SETCURRENTKEY("Document Type", "Customer No.", "Global Dimension 1 Code", "Global Dimension 2 Code",
                //                         "Posting Date", "Currency Code");
                // PP_CustLedgEntry.SETRANGE("Customer No.", "No.");
                // PP_CustomerLedgerEntries.SETTABLEVIEW(PP_CustLedgEntry);
                // PP_CustomerLedgerEntries.RUNMODAL;
                // CLEAR(PP_CustomerLedgerEntries);
                //ProjectPro - end
                //PRJ-251 AS1.0 29-04-20 Code Commented END
            end;
        }

        modify("S&ales")
        {
            Visible = false;
        }

        //addafter("Statistics by Currencies")
        //addafter(Statistics)
        addbefore("Entry Statistics")
        {
            action("NS_Sales")
            {
                Caption = 'S&ales';
                ToolTip = 'View a summary of customer ledger entries. You select the time interval in the View by field. The Period column on the left contains a series of dates that are determined by the time interval you have selected.';
                ApplicationArea = Advanced;
                RunObject = page 155;
                RunPageLink = "No." = FIELD("No."),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                  "NS_Retention Ledger CodeFilter" = FIELD("NS_Retention Ledger CodeFilter");
                Image = Sales;
            }
        }


        modify("Entry Statistics")
        {
            Visible = false;
        }

        addafter("NS_Sales")
        {
            action("NS_EntryStatistics1")
            {
                Caption = 'Entry Statistics';
                ToolTip = 'View entry statistics for the record.';
                ApplicationArea = Advanced;
                RunObject = page 302;
                RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                  "NS_Retention Ledger CodeFilter" = FIELD("NS_Retention Ledger CodeFilter");
                Image = EntryStatistics;
            }
            //SPLN1.00 Start
            action("NS_EntryStatistics2")
            {
                Caption = 'PP Entry Statistics';
                ToolTip = 'View PP entry statistics for the record.';
                ApplicationArea = Advanced;
                RunObject = page "NS_Customer Entry Statistics";
                RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                  "NS_Retention Ledger CodeFilter" = FIELD("NS_Retention Ledger CodeFilter");
                Image = EntryStatistics;
            }
            //SPLN1.00 End
        }

        modify("Statistics by C&urrencies")
        {
            Visible = false;
        }

        addafter("NS_EntryStatistics2")
        {
            action("NS_Statistics by Currencies")
            {
                Caption = 'Statistics by Currencies';
                ToolTip = 'View statistics for customers that use multiple currencies.';
                ApplicationArea = Advanced;
                RunObject = page 486;
                RunPageLink = "Customer Filter" = FIELD("No."),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                  "Date Filter" = FIELD("Date Filter");
                Image = Currencies;
            }
        }

        addafter("Ledger E&ntries")
        {
            action("NS_Retention Entries")
            {
                Caption = '&Retention Entries';
                Image = CustomerLedger;
                ApplicationArea = All;
                ToolTip = 'Retention Entries';

                trigger OnAction();
                begin
                    //ProjectPro - start
                    if not NS_SalesSetup."NS_Sales Retention Inactive" then begin
                        NS_CustLedgEntry.RESET;
                        NS_CustLedgEntry.SETCURRENTKEY("Document Type", "Customer No.", "Global Dimension 1 Code", "Global Dimension 2 Code",
                                                       "Posting Date", "Currency Code");
                        NS_CustLedgEntry.SETRANGE("Customer No.", "No.");
                        NS_CustLedgEntry.SETRANGE(NS_CustLedgEntry."NS_Retention Ledger Code", NS_JobsSetup."NS_Retention Receivable Ledger");
                        NS_CustomerLedgerEntries.SETTABLEVIEW(NS_CustLedgEntry);
                        NS_CustomerLedgerEntries.RUNMODAL;
                        //                     CLEAR(NS_CustomerLedgerEntries);//PRJ-713.AS.1.0 Commented
                    end;
                    //ProjectPro - end
                end;
            }
        }
        addafter("Ledger E&ntries")
        {
            action("NS_Job Quotes")
            {
                Image = Quote;
                RunObject = Page "NS_Job Quote List";
                RunPageLink = "NS_Sell-to Customer No." = FIELD("No.");
                RunPageView = SORTING("NS_Quote No.");
                ApplicationArea = All;
                Caption = 'Job Quotes';
                ToolTip = 'Job Quotes';
            }
        }
    }

    var
        NS_DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        NS_DtldCustLedgEntry1: Record "Detailed Cust. Ledg. Entry";//PRJ-197:AS:10APRIL2020
        NS_SalesSetup: Record "Sales & Receivables Setup";
        NS_JobsSetup: Record "Jobs Setup";
        NS_CustLedgEntry: Record "Cust. Ledger Entry";
        CustLegEnt_G: Record "Cust. Ledger Entry";//PRJ-250:AS:10JUNE2020
        NS_CustomerLedgerEntries: Page "Customer Ledger Entries";

        AgedAccReceivable: Codeunit "Aged Acc. Receivable";
        BalanceExhausted: Boolean;
        NewRecordBoolean: Boolean;//PRJ-713.AS.1.0
        DaysPastDueDate: Decimal;
        AttentionToPaidDay: Boolean;
        NS_RetentionBalanceLCY: Decimal;
        NS_RetentionBalanceToshow: Decimal;//PRJ-197:AS:10APRIL2020
        BalanceWTRetention: Decimal;//PRJ-197:AS:10APRIL2020
        BalanceWTRetentionToshow: Decimal;//PRJ-197:AS:10APRIL2020
        BalanceWTFilters: Decimal;//PRJ-197:AS:17APRIL2020
        BalanceDueLcy_N: Decimal;//PRJ-250:AS:10JUNE2020
        BalanceDueLcy_NToshow: Decimal;//PRJ-250:AS:10JUNE2020
        BlockedCustomer: Boolean;

    trigger OnOpenPage();
    begin
        //ProjectPro - start
        NS_SalesSetup.GET;
        NS_JobsSetup.GET;
        //ProjectPro - end
    end;


    trigger OnAfterGetRecord();
    begin
        ClearAll();//PRJ-713.AS.1.0 Added
        NS_SalesSetup.GET;
        NS_JobsSetup.GET;
        //ProjectPro - start
        NS_RetentionBalanceLCY := 0;
        NS_RetentionBalanceToshow := 0;//PRJ-197:AS:10APRIL2020
        if not NS_SalesSetup."NS_Sales Retention Inactive" then begin
            //            SETFILTER("NS_Retention Ledger CodeFilter", NS_JobsSetup."NS_Retention Receivable Ledger");//PRJ-713.AS.1.0 Commented
            //            CALCFIELDS("Balance (LCY)");//PRJ-713.AS.1.0 Commented
            // NS_RetentionBalanceLCY := "Balance (LCY)";//PRJ-197:AS:10APRIL2020 old commented
            //PRJ-197:AS:10APRIL2020 - start
            NS_DtldCustLedgEntry1.Reset;
            NS_DtldCustLedgEntry1.SetRange("Customer No.", "No.");
            //PP_DtldCustLedgEntry1.SetRange("Initial Entry Global Dim. 1", "Global Dimension 1 Code");//PRJ-250:AS:10JUNE2020 Commented
            //PP_DtldCustLedgEntry1.SetRange("Initial Entry Global Dim. 2", "Global Dimension 2 Code");//PRJ-250:AS:10JUNE2020 Commented
            COPYFILTER("Global Dimension 1 Filter", NS_DtldCustLedgEntry1."Initial Entry Global Dim. 1");//PRJ-250:AS:10JUNE2020 Added
            COPYFILTER("Global Dimension 2 Filter", NS_DtldCustLedgEntry1."Initial Entry Global Dim. 2");//PRJ-250:AS:10JUNE2020 Added
            NS_DtldCustLedgEntry1.SetRange("NS_Retention Ledger Code", NS_JobsSetup."NS_Retention Receivable Ledger");
            //PP_DtldCustLedgEntry1.SetRange("Currency Code", "Currency Filter");//PRJ-250:AS:10JUNE2020 Commented
            COPYFILTER("Currency Filter", NS_DtldCustLedgEntry1."Currency Code");//PRJ-250:AS:10JUNE2020 Added
            //PRJ-827.JS.1.0�09Aug2021-Start
            if NS_DtldCustLedgEntry1.FindSet() then begin
                NS_DtldCustLedgEntry1.CalcSums(NS_DtldCustLedgEntry1."Amount (LCY)");
                NS_RetentionBalanceToshow := NS_DtldCustLedgEntry1."Amount (LCY)";
                // repeat
                //     NS_RetentionBalanceToshow += NS_DtldCustLedgEntry1."Amount (LCY)";
                // until NS_DtldCustLedgEntry1.Next = 0;

                NS_RetentionBalanceLCY := (NS_RetentionBalanceToshow);
            End;
            //PRJ-827.JS.1.0�09Aug2021-end

            //PRJ-197:AS:10APRIL2020 - end
            //SETFILTER("NS_Retention Ledger CodeFilter", NS_SalesSetup."NS_Normal Customer Ledger No.");//PRJ-713.AS.1.0 Commented
        end;
        CALCFIELDS("Balance (LCY)");
        BlockedCustomer := (Blocked = Blocked::All);
        BalanceExhausted := 10000 <= CalcCreditLimitLCYExpendedPct;
        DaysPastDueDate := AgedAccReceivable.InvoicePaymentDaysAverage("No.");
        AttentionToPaidDay := DaysPastDueDate > 0;
        //ProjectPro - end

        //PRJ-197:AS:10APRIL2020 - START
        BalanceWTRetention := 0;
        BalanceWTRetentionToshow := 0;

        NS_DtldCustLedgEntry1.Reset;
        NS_DtldCustLedgEntry1.SetRange("Customer No.", "No.");
        //PP_DtldCustLedgEntry1.SetRange("Initial Entry Global Dim. 1", "Global Dimension 1 Code");//PRJ-250:AS:10JUNE2020 Commented
        //PP_DtldCustLedgEntry1.SetRange("Initial Entry Global Dim. 2", "Global Dimension 2 Code");//PRJ-250:AS:10JUNE2020 Commented
        COPYFILTER("Global Dimension 1 Filter", NS_DtldCustLedgEntry1."Initial Entry Global Dim. 1");//PRJ-250:AS:10JUNE2020 Added
        COPYFILTER("Global Dimension 2 Filter", NS_DtldCustLedgEntry1."Initial Entry Global Dim. 2");//PRJ-250:AS:10JUNE2020 Added
        NS_DtldCustLedgEntry1.SetRange("NS_Retention Ledger Code", NS_SalesSetup."NS_Normal Customer Ledger No.");
        //PP_DtldCustLedgEntry1.SetRange("Currency Code", "Currency Filter");//PRJ-250:AS:10JUNE2020 Commented
        COPYFILTER("Currency Filter", NS_DtldCustLedgEntry1."Currency Code");//PRJ-250:AS:10JUNE2020 Added
        //PRJ-827.JS.1.0�09Aug2021-Start
        if NS_DtldCustLedgEntry1.FindSet() then begin
            NS_DtldCustLedgEntry1.CalcSums(NS_DtldCustLedgEntry1."Amount (LCY)");
            BalanceWTRetentionToshow := NS_DtldCustLedgEntry1."Amount (LCY)";
            // repeat
            //     BalanceWTRetentionToshow += NS_DtldCustLedgEntry1."Amount (LCY)";
            // until NS_DtldCustLedgEntry1.Next = 0;
            BalanceWTRetention := (BalanceWTRetentionToshow);
        end;
        //PRJ-827.JS.1.0�09Aug2021-End
        //PRJ-197:AS:10APRIL2020 - END


        //PRJ-197:AS:17APRIL2020 - START
        BalanceWTFilters := 0;

        NS_DtldCustLedgEntry1.Reset;
        NS_DtldCustLedgEntry1.SetRange("Customer No.", "No.");
        //PP_DtldCustLedgEntry1.SetRange("Initial Entry Global Dim. 1", "Global Dimension 1 Code");//PRJ-250:AS:10JUNE2020 Commented
        //PP_DtldCustLedgEntry1.SetRange("Initial Entry Global Dim. 2", "Global Dimension 2 Code");//PRJ-250:AS:10JUNE2020 Commented
        //PP_DtldCustLedgEntry1.SetRange("Currency Code", "Currency Filter");//PRJ-250:AS:10JUNE2020 Commented
        COPYFILTER("Global Dimension 1 Filter", NS_DtldCustLedgEntry1."Initial Entry Global Dim. 1");//PRJ-250:AS:10JUNE2020 Added
        COPYFILTER("Global Dimension 2 Filter", NS_DtldCustLedgEntry1."Initial Entry Global Dim. 2");//PRJ-250:AS:10JUNE2020 Added
        COPYFILTER("Currency Filter", NS_DtldCustLedgEntry1."Currency Code");//PRJ-250:AS:10JUNE2020 Added
        //PRJ-827.JS.1.0�09Aug2021-Start
        if NS_DtldCustLedgEntry1.FindSet() then begin
            NS_DtldCustLedgEntry1.CalcSums(NS_DtldCustLedgEntry1."Amount (LCY)");
            BalanceWTFilters := NS_DtldCustLedgEntry1."Amount (LCY)";
            // repeat
            //     BalanceWTFilters += NS_DtldCustLedgEntry1."Amount (LCY)";
            // until NS_DtldCustLedgEntry1.Next = 0;
        end;
        //PRJ-827.JS.1.0�09Aug2021-end    
        //PRJ-197:AS:17APRIL2020 - END

        //PRJ-250:AS:10JUNE2020 - START 
        BalanceDueLcy_NToshow := 0;
        BalanceDueLcy_N := 0;

        CustLegEnt_G.reset;
        CustLegEnt_G.SETCURRENTKEY("Customer No.", "Posting Date");
        CustLegEnt_G.SetRange("Customer No.", "No.");
        CustLegEnt_G.SETRANGE(Open, TRUE);
        if (GETFILTER("Date Filter") <> '') then
            CopyFilter("Date Filter", CustLegEnt_G."Due Date");
        if CustLegEnt_G.FindSet then
            repeat
                // CustLegEnt_G.CalcFields("Amount (LCY)");
                // BalanceDueLcy_N += CustLegEnt_G."Amount (LCY)";
                CustLegEnt_G.CalcFields("Remaining Amt. (LCY)");//PRJ-713
                BalanceDueLcy_N += CustLegEnt_G."Remaining Amt. (LCY)";//PRJ-713
            until CustLegEnt_G.Next = 0;

        BalanceDueLcy_NToshow := Abs(BalanceDueLcy_N);
        //PRJ-250:AS:10JUNE2020 - END
        //       rec.Reset();//PRJ-472.MS.1.0//PRJ-713.AS.1.0 Commented

    end;

    /*
     +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     Retention Balance (LCY) - General fasttab
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +     PP_SalesSetup
      +     PP_JobsSetup
      +     PP_CustLedgEntry
      +     PP_CustomerLedgerEntries
      +     PP_RetentionBalanceLCY
      +     PP_DtldCustLedgEntry
      +     BlockedCustomer
      +     AgedAccReceivable
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +     - OnOpenPage        -  Read setup records
      +                             Sales & Receivables Setup
      +                             Jobs Setup
      +     - OnAfterGetRecord  - Field calculations
      +                             Retention Balance LCY
      +                             Balance LCY
      +     - Added action list:
      +         Retention Entries         - OnAction - Call Customer Ledger Entries page filtered to retention when retention is active
      +     - Modified action list:
      +        Sales                      - RunPageLink - Added Retention Ledger Code
      +        Entry Statistics           - RunPageLink - Added Retention Ledger Code
      +        Statistics by Currencies   - RunPageLink - Added Retention Ledger Code
      +        Ledger Entries             - OnAction - Call ProjectPro Customer Ledger Entries page when sales retention is active
      +     - Modified Controls:
      +         CustomerStatisticsFactBox - SubPageLink - Added Retention Ledger Code Filter
      +     - Added Job Quotes Page Action to History ActionGroup.
      +     - Menus:
      +
      +-----------------------------------------------------------------------------------------------
      */

}