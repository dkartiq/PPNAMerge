pageextension 14021105 NS_VendorCard extends "Vendor Card"
{
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,NAVMX11.00.00.23572,PPNA11.00
    //PRJ-197:AS:08APRIL2020 :Creted new variables NS_DtldVendLedgEntry1,NS_RetentionBalanceToshow
    //PRJ-197:AS:08APRIL2020 : Commented old code for NS_RetentionBalance.
    //PRJ-197:AS:08APRIL2020 : Calculated NS_RetentionBalance
    //PRJ-197:AS:10APRIL2020 :Creted new variables - BalanceWTRetention,BalanceWTRetentionToshow.
    //PRJ-197:AS:10APRIL2020 : Calculated BalanceWTRetention & Added on page after "PP Retention Balance".
    //PRJ-197:AS:17APRIL2020 :Hide the "Balance (LCY)" field & Added Balance "BalanceWTFilters" field before "Balance Due (LCY)" field.
    //PRJ-251 AS1.0 29-04-20 Code Commented
    //PRJ-250:AS:10JUNE2020 Added & Commented code
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Vendor Card'; //PRJ-1330.NK.1.0 25Apr2022
    //PRJ-1537.JS.1.0 25JULY2022 | Reverce Balance Due ($) Sinage condition
    //PRJ-1579.RM.1.0 22Aug2022 | Added some code
    //ZEL-12.RM.1.0 19Apr2023 | Changed the caption.
    layout
    {

        //Unsupported feature: Change SubPageLink on "VendorStatisticsFactBox(Control 1904651607)". Please convert manually.

        //PRJ-197:AS:17APRIL2020 - start
        //PRJ-472.MS.1.0 resolve the issue of blank record when click on Bal fields
        modify("Balance (LCY)")
        {
            Visible = false;
        }

        modify("Balance Due (LCY)")//PRJ-713.AS.1.0
        {
            Visible = false;
        }

        addbefore("Balance Due (LCY)")
        {
            field(NS_BalanceWTFilters; BalanceWTFilters)
            {
                Caption = 'Balance ($)';
                Description = 'Field used to show balance without using ';
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the Balance ($)'; //PRJ-1579.RM.1.0 

                trigger OnDrillDown();
                begin
                    NS_DtldVendLedgEntry.Reset();//PRJ-713.AS.1.0 Added
                    NS_DtldVendLedgEntry.SETRANGE("Vendor No.", Rec."No.");
                    Rec.COPYFILTER("Global Dimension 1 Filter", NS_DtldVendLedgEntry."Initial Entry Global Dim. 1");
                    Rec.COPYFILTER("Global Dimension 2 Filter", NS_DtldVendLedgEntry."Initial Entry Global Dim. 2");
                    Rec.COPYFILTER("Currency Filter", NS_DtldVendLedgEntry."Currency Code");
                    NS_VendLedgEntry.DrillDownOnEntries(NS_DtldVendLedgEntry);
                    // rec.Reset();//PRJ-472.MS.1.0//PRJ-713.AS.1.0 Commented
                end;
            }

            //PRJ-713.AS.1.0 -START
            field(NS_BalanceDueLcy_NToshow; BalanceDueLcy_NToshow)
            {
                Caption = 'Balance Due ($)';
                Description = 'Field used to show Balance wdue LCY';
                Editable = false;
                ApplicationArea = All;
                // ToolTip = 'Specifies the Balance Due($)'; //PRJ-1579.RM.1.0 //PRJ-1579.RM.2.0 'commented
                ToolTip = 'Specifies the Balance Due ($)'; //PRJ-1579.RM.2.0 '
                trigger OnDrillDown();
                var
                    VendLegEnt: Record "Vendor Ledger Entry";
                begin
                    VendLegEnt.reset;
                    VendLegEnt.SETCURRENTKEY("Vendor No.", "Posting Date");
                    VendLegEnt.SetRange("Vendor No.", "No.");
                    VendLegEnt.SETRANGE(Open, TRUE);
                    if (GETFILTER("Date Filter") <> '') then
                        CopyFilter("Date Filter", VendLegEnt."Due Date");
                    PAGE.RUN(0, VendLegEnt);

                end;
            }
            //PRJ-713.AS.1.0 - END
        }
        //PRJ-197:AS:17APRIL2020 - end

        addafter("Balance Due (LCY)")
        {
            field("NS_Retention Balance"; NS_RetentionBalance)
            {
                Caption = 'Retention Balance ($)';
                ToolTip = 'Specifies the Retention Balance ($)'; //PRJ-1579.RM.1.0 
                Editable = false;
                ApplicationArea = All;

                trigger OnDrillDown();
                begin
                    //ProjectPro - start
                    if not NS_PurchSetup."NS_Purchase Retention Inactive" then begin
                        NS_DtldVendLedgEntry.Reset();//PRJ-713.AS.1.0 Added
                        NS_DtldVendLedgEntry.SETRANGE("Vendor No.", Rec."No.");
                        Rec.COPYFILTER("Global Dimension 1 Filter", NS_DtldVendLedgEntry."Initial Entry Global Dim. 1");
                        Rec.COPYFILTER("Global Dimension 2 Filter", NS_DtldVendLedgEntry."Initial Entry Global Dim. 2");
                        NS_DtldVendLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_JobsSetup."NS_Retention Payable Ledger");
                        Rec.COPYFILTER("Currency Filter", NS_DtldVendLedgEntry."Currency Code");
                        NS_VendLedgEntry.DrillDownOnEntries(NS_DtldVendLedgEntry);
                        // rec.Reset();//PRJ-472.MS.1.0//PRJ-713.AS.1.0 Commented
                    end;
                    //ProjectPro - end
                end;
            }
            //PRJ-197:AS:10APRIL2020  - START
            field(NS_BalanceWTRetention; BalanceWTRetention)
            {
                // Caption = 'Balance Without Retention($)'; //PRJ-1579.RM.2.0 commented
                Caption = 'Balance Without Retention ($)'; //PRJ-1579.RM.2.0
                ToolTip = 'Specifies the balance without retention ($)'; //PRJ-1579.RM.1.0 
                Editable = false;
                ApplicationArea = All;

                trigger OnDrillDown();
                begin
                    NS_DtldVendLedgEntry.Reset();//PRJ-713.AS.1.0 Added
                    NS_DtldVendLedgEntry.SETRANGE("Vendor No.", Rec."No.");
                    Rec.COPYFILTER("Global Dimension 1 Filter", NS_DtldVendLedgEntry."Initial Entry Global Dim. 1");
                    Rec.COPYFILTER("Global Dimension 2 Filter", NS_DtldVendLedgEntry."Initial Entry Global Dim. 2");
                    NS_DtldVendLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_PurchSetup."NS_Normal Vendor Ledger No.");
                    Rec.COPYFILTER("Currency Filter", NS_DtldVendLedgEntry."Currency Code");
                    NS_VendLedgEntry.DrillDownOnEntries(NS_DtldVendLedgEntry);
                    // rec.Reset();//PRJ-472.MS.1.0//PRJ-713.AS.1.0 Commented
                end;
            }
            //PRJ-197:AS:10APRIL2020 - END
        }
    }
    actions
    {
        modify(Statistics)
        {
            Visible = false;
        }
        addafter("Ledger E&ntries")
        {
            action(NS_StatisticsExtention)
            {
                Caption = 'Statistics';
                ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
                ApplicationArea = Advanced;
                RunObject = page 152;
                RunPageLink = "No." = FIELD("No."),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                  "NS_Retention Ledger CodeFilter" = FIELD("NS_Retention Ledger CodeFilter");
                Promoted = true;
                Image = Statistics;
                PromotedCategory = Process;
            }
        }

        modify(Purchases)
        {
            Visible = false;
        }
        addafter(NS_StatisticsExtention)
        {
            action(NS_PurchasesExtention)
            {
                Caption = 'Purchases';
                ToolTip = 'Shows a summary of vendor ledger entries. You select the time interval in the View by field. The Period column on the left contains a series of dates that are determined by the time interval you have selected.';
                ApplicationArea = Advanced;
                RunObject = Page 156;
                RunPageLink = "No." = FIELD("No."),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                  "NS_Retention Ledger CodeFilter" = FIELD("NS_Retention Ledger CodeFilter");
                Image = Purchase;
            }
        }

        modify("Entry Statistics")
        {
            Visible = false;
        }

        addafter(NS_PurchasesExtention)
        {
            action(NS_EntryStatistics1)
            {
                Caption = 'Entry Statistics';
                ToolTip = 'View entry statistics for the record.';
                ApplicationArea = Advanced;
                RunObject = Page 303;
                RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                  "NS_Retention Ledger CodeFilter" = FIELD("NS_Retention Ledger CodeFilter");
                Image = EntryStatistics;
            }
            //SPLN1.00 Start
            action(NS_EntryStatistics2)
            {
                Caption = 'PP Entry Statistics';
                ToolTip = 'View PP entry statistics for the record.';
                ApplicationArea = Advanced;
                RunObject = Page "NS_Vendor Entry Statistics";
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
        addafter(NS_EntryStatistics2)
        {
            action(NS_StatisticsByCurrencies)
            {
                Caption = 'Statistics by Currencies';
                ToolTip = 'View entry statistics for the record.';
                ApplicationArea = Advanced;
                RunObject = Page 303;
                RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                  "NS_Retention Ledger CodeFilter" = FIELD("NS_Retention Ledger CodeFilter");
                Image = EntryStatistics;
            }
        }

        modify("Ledger E&ntries")
        {
            trigger OnBeforeAction();
            begin
                //ProjectPro - start
                //PRJ-251 AS1.0 29-04-20 Commented START
                // NS_VendLedgEntry.RESET;
                // NS_VendLedgEntry.SETCURRENTKEY("Document Type", "Vendor No.", "Global Dimension 1 Code", "Global Dimension 2 Code",
                //                                "Posting Date", "Currency Code");
                // NS_VendLedgEntry.SETRANGE("Vendor No.", "No.");
                // NS_VendorLedgerEntries.SETTABLEVIEW(NS_VendLedgEntry);
                // NS_VendorLedgerEntries.RUNMODAL;
                // CLEAR(NS_VendorLedgerEntries);
                //PRJ-251 AS1.0 29-04-20 Commented END
                //ProjectPro - end
            end;
        }

        //PPDA.1.0.TBA Start
        // addafter("&Locations")
        // {
        //     action("NS_Insurance")
        //     {
        //         Caption = '&Insurance';
        //         Image = ServiceAgreement;
        //         RunObject = Page "NS_Vendor Insurances";
        //         RunPageLink = "NS_Vendor No." = FIELD("No.");
        //         RunPageView = SORTING("NS_Vendor No.", "NS_Insurance Type", "NS_Policy No.");
        //         ApplicationArea = All;
        //     }
        // }
        //PPDA.1.0.TBA End
        addafter("Ledger E&ntries")
        {
            action("NS_Retention Ledger Entries")
            {
                Caption = 'Retention Ledger Entries';
                Image = VendorLedger;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    //ProjectPro - start
                    if not NS_PurchSetup."NS_Purchase Retention Inactive" then begin
                        NS_VendLedgEntry.RESET;
                        NS_VendLedgEntry.SETCURRENTKEY("Document Type", "Vendor No.", "Global Dimension 1 Code", "Global Dimension 2 Code",
                                                       "Posting Date", "Currency Code");
                        NS_VendLedgEntry.SETRANGE("Vendor No.", Rec."No.");
                        NS_VendLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_JobsSetup."NS_Retention Payable Ledger");
                        NS_VendorLedgerEntries.SETTABLEVIEW(NS_VendLedgEntry);
                        NS_VendorLedgerEntries.RUNMODAL;
                        CLEAR(NS_VendorLedgerEntries);
                    end;
                    //ProjectPro - end
                end;
            }
        }
    }

    var
        NS_PurchSetup: Record "Purchases & Payables Setup";
        NS_JobsSetup: Record "Jobs Setup";
        NS_RetentionBalance: Decimal;
        NS_RetentionBalanceToshow: Decimal;//PRJ-197:AS:10APRIL2020
        BalanceWTRetention: Decimal;//PRJ-197:AS:10APRIL2020
        BalanceWTRetentionToshow: Decimal;//PRJ-197:AS:10APRIL2020
        BalanceWTFilters: Decimal;//PRJ-197:AS:17APRIL2020
        BalanceWTFiltersToshow: Decimal;//PRJ-197:AS:17APRIL2020
        NS_DtldVendLedgEntry1: Record "Detailed Vendor Ledg. Entry";//PRJ-197:AS:10APRIL2020
        NS_VendLedgEntry: Record "Vendor Ledger Entry";
        NS_VendorLedgerEntries: Page "Vendor Ledger Entries";
        NS_DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        BalanceDueLcy_N: Decimal;//PRJ-713
        BalanceDueLcy_NToshow: Decimal;//PRJ-713
        VendLegEnt_G: Record "Vendor Ledger Entry";//PRJ-713


    trigger OnOpenPage();
    begin
        //ProjectPro - start
        NS_PurchSetup.GET;
        NS_JobsSetup.GET;
        //ProjectPro - end
    end;

    trigger OnAfterGetRecord();
    begin
        ClearAll();//PRJ-713.AS.1.0 Added
        NS_PurchSetup.GET;//PRJ-713.AS.1.0 Added
        NS_JobsSetup.GET;//PRJ-713.AS.1.0 Added
        //ProjectPro - start
        NS_RetentionBalance := 0;
        NS_RetentionBalanceToshow := 0;//PRJ-197:AS:10APRIL2020
        if not NS_PurchSetup."NS_Purchase Retention Inactive" then begin
            //Rec.SETFILTER("NS_Retention Ledger CodeFilter", NS_JobsSetup."NS_Retention Payable Ledger");//PRJ-713.AS.1.0 Commented
            //Rec.CALCFIELDS("Balance (LCY)");//PRJ-713.AS.1.0 Commented
            // NS_RetentionBalance := "Balance (LCY)"; //PRJ-197:AS:10APRIL2020 old commented
            //PRJ-197:AS:10APRIL2020 - start
            //PRJCTPR-166.NC.1.0 24July2023 Start Block
            /* NS_DtldVendLedgEntry1.Reset;
            NS_DtldVendLedgEntry1.SetRange("Vendor No.", Rec."No.");
            //NS_DtldVendLedgEntry1.SetRange("Initial Entry Global Dim. 1", "Global Dimension 1 Code");//PRJ-250:AS:10JUNE2020 Commented
            //NS_DtldVendLedgEntry1.SetRange("Initial Entry Global Dim. 2", "Global Dimension 2 Code");//PRJ-250:AS:10JUNE2020 Commented
            Rec.COPYFILTER("Global Dimension 1 Filter", NS_DtldVendLedgEntry1."Initial Entry Global Dim. 1");//PRJ-250:AS:10JUNE2020 Added
            Rec.COPYFILTER("Global Dimension 2 Filter", NS_DtldVendLedgEntry1."Initial Entry Global Dim. 2");//PRJ-250:AS:10JUNE2020 Added
            NS_DtldVendLedgEntry1.SetRange("NS_Retention Ledger Code", NS_JobsSetup."NS_Retention Payable Ledger");//PRJ-250:AS:10JUNE2020 Added
            //NS_DtldVendLedgEntry1.SetRange("Currency Code", "Currency Filter");//PRJ-250:AS:10JUNE2020 Added
            Rec.COPYFILTER("Currency Filter", NS_DtldVendLedgEntry1."Currency Code");//PRJ-250:AS:10JUNE2020 Added
            //PRJ-860.JS.1.0 30Aug2021-Start
            if NS_DtldVendLedgEntry1.FindSet() then begin
                NS_DtldVendLedgEntry1.CalcSums(NS_DtldVendLedgEntry1."Amount (LCY)");
                NS_RetentionBalanceToshow := NS_DtldVendLedgEntry1."Amount (LCY)";
                // repeat
                //     NS_RetentionBalanceToshow += NS_DtldVendLedgEntry1."Amount (LCY)";
                // until NS_DtldVendLedgEntry1.Next = 0;

                NS_RetentionBalance := -(NS_RetentionBalanceToshow);
            end;
            */
            //PRJCTPR-166.NC.1.0 24July2023 End Block
            //PRJCTPR-166.NC.1.0 24July2023 Start 
            NS_VendLedgEntry.RESET;
            NS_VendLedgEntry.SETRANGE("Vendor No.", Rec."No.");
            NS_VendLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_JobsSetup."NS_Retention Payable Ledger");
            NS_VendLedgEntry.SETRANGE(Open, true);
            if NS_VendLedgEntry.FindSet() then begin
                NS_VendLedgEntry.CalcSums("NS_Retention Amount (LCY)");
                NS_RetentionBalanceToshow += NS_VendLedgEntry."NS_Retention Amount (LCY)";
                NS_RetentionBalance := -(NS_RetentionBalanceToshow);

            end;
            //PRJCTPR-166.NC.1.0 24July2023 End
            //PRJ-860.JS.1.0 30Aug2021-end
            //PRJ-197:AS:10APRIL2020 - end
            //Rec.SETFILTER("NS_Retention Ledger CodeFilter", NS_PurchSetup."NS_Normal Vendor Ledger No.");//PRJ-713.AS.1.0 Commented
        end;
        Rec.CALCFIELDS("Balance (LCY)");
        //ProjectPro - end

        //PRJ-197:AS:10APRIL2020 - START
        BalanceWTRetention := 0;
        BalanceWTRetentionToshow := 0;

        NS_DtldVendLedgEntry1.Reset;
        NS_DtldVendLedgEntry1.SetRange("Vendor No.", Rec."No.");
        //NS_DtldVendLedgEntry1.SetRange("Initial Entry Global Dim. 1", "Global Dimension 1 Code");//PRJ-250:AS:10JUNE2020 Commented
        //NS_DtldVendLedgEntry1.SetRange("Initial Entry Global Dim. 2", "Global Dimension 2 Code");//PRJ-250:AS:10JUNE2020 Commented
        Rec.COPYFILTER("Global Dimension 1 Filter", NS_DtldVendLedgEntry1."Initial Entry Global Dim. 1");//PRJ-250:AS:10JUNE2020 Added
        Rec.COPYFILTER("Global Dimension 2 Filter", NS_DtldVendLedgEntry1."Initial Entry Global Dim. 2");//PRJ-250:AS:10JUNE2020 Added
        NS_DtldVendLedgEntry1.SetRange("NS_Retention Ledger Code", NS_PurchSetup."NS_Normal Vendor Ledger No.");
        //NS_DtldVendLedgEntry1.SetRange("Currency Code", "Currency Filter");  //PRJ-250:AS:10JUNE2020 Commented
        Rec.COPYFILTER("Currency Filter", NS_DtldVendLedgEntry1."Currency Code");//PRJ-250:AS:10JUNE2020 Added
        if NS_DtldVendLedgEntry1.FindSet then
            repeat
                BalanceWTRetentionToshow += NS_DtldVendLedgEntry1."Amount (LCY)";
            until NS_DtldVendLedgEntry1.Next = 0;

        BalanceWTRetention := -(BalanceWTRetentionToshow);
        //PRJ-197:AS:10APRIL2020 - END

        //PRJ-197:AS:17APRIL2020 - START
        BalanceWTFilters := 0;
        BalanceWTFiltersToshow := 0;

        NS_DtldVendLedgEntry1.Reset;
        NS_DtldVendLedgEntry1.SetRange("Vendor No.", Rec."No.");
        //NS_DtldVendLedgEntry1.SetRange("Initial Entry Global Dim. 1", "Global Dimension 1 Code");//PRJ-250:AS:10JUNE2020 Commented
        //NS_DtldVendLedgEntry1.SetRange("Initial Entry Global Dim. 2", "Global Dimension 2 Code");//PRJ-250:AS:10JUNE2020 Commented
        Rec.COPYFILTER("Global Dimension 1 Filter", NS_DtldVendLedgEntry1."Initial Entry Global Dim. 1");//PRJ-250:AS:10JUNE2020 Added
        Rec.COPYFILTER("Global Dimension 2 Filter", NS_DtldVendLedgEntry1."Initial Entry Global Dim. 2");//PRJ-250:AS:10JUNE2020 Added
        //NS_DtldVendLedgEntry1.SetRange("Currency Code", "Currency Filter"); //PRJ-250:AS:10JUNE2020 Commented
        Rec.COPYFILTER("Currency Filter", NS_DtldVendLedgEntry1."Currency Code");//PRJ-250:AS:10JUNE2020 Added
        if NS_DtldVendLedgEntry1.FindSet then
            repeat
                BalanceWTFiltersToshow += NS_DtldVendLedgEntry1."Amount (LCY)";
            until NS_DtldVendLedgEntry1.Next = 0;

        BalanceWTFilters := -(BalanceWTFiltersToshow);

        //PRJ-713.AS.1.0 - START 
        BalanceDueLcy_NToshow := 0;
        BalanceDueLcy_N := 0;

        VendLegEnt_G.reset;
        VendLegEnt_G.SETCURRENTKEY("Vendor No.", "Posting Date");
        VendLegEnt_G.SetRange("Vendor No.", "No.");
        VendLegEnt_G.SETRANGE(Open, TRUE);
        if (GETFILTER("Date Filter") <> '') then
            CopyFilter("Date Filter", VendLegEnt_G."Due Date");
        if VendLegEnt_G.FindSet then
            repeat
                // VendLegEnt_G.CalcFields("Amount (LCY)");
                // BalanceDueLcy_N += VendLegEnt_G."Amount (LCY)";
                VendLegEnt_G.CalcFields("Remaining Amt. (LCY)");//PRJ-713
                BalanceDueLcy_N += VendLegEnt_G."Remaining Amt. (LCY)";//PRJ-713
            until VendLegEnt_G.Next = 0;

        BalanceDueLcy_NToshow := Abs(BalanceDueLcy_N);
        //PRJ-1537.JS.1.0 25JULY2022 - Start
        Rec.calcfields("Balance (LCY)");
        If rec."Balance (LCY)" < 0 then
            BalanceDueLcy_NToshow := BalanceDueLcy_NToshow * -1;
        //PRJ-1537.JS.1.0 25JULY2022 - Start    
        //PRJ-713.AS.1.0 - END

        //PRJ-197:AS:17APRIL2020 - END
        //rec.Reset();//PRJ-472.MS.1.0//PRJ-713.AS.1.0 Commented
    end;

    /*
     +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     PP Retention Balance
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +     NS_PurchSetup
      +     NS_JobsSetup
      +     NS_RetentionBalance
      +     NS_VendLedgEntry
      +     NS_VendorLedgerEntries
      +     NS_DtldVendLedgEntry
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +     - OnOpenPage - Read setup records
      +                       Purchases & Payables Setup
      +                       Jobs Setup
      +
      +     - OnAfterGetRecord - Field Calculations
      +                             Retention Balance
      +                             Balance LCY
      +
      +     - Added action list:
      +         PP Insurance
      +         PP Retention Ledger Entires
      +
      +     - Modify action list:
      +         Statistics                - RunPageLink - Added Retention Ledger Code Filter
      +         Purchases                 - RunPageLink - Added Retention Ledger Code Filter
      +         Entry Statistics          - RunPageLink - Added Retention Ledger Code Filter
      +         Statistics by Currencies  - RunPageLink - Added Retention Ledger Code Filter
      +         VendorStatisticsFactBox   - RunPageLink - Added Retention Ledger Code Filter
      +
      + -SMP
      +  -Modified Page Triggers
      +   -OnOpenPage
      +   -OnAfterGetRecord
      +  -Rewritten Actions
      +   -Ledger E&ntries
      +   -Statistics by C&urrencies
      +   -Entry Statistics
      +   -Purchases
      +   -Statistics
      +-----------------------------------------------------------------------------------------------
      */

}

