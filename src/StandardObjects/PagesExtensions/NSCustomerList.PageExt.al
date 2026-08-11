pageextension 14021103 NS_CustomerList extends "Customer List"
{
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,NAVMX11.00.00.23572,PPNA11.00
    //PRJ-250:AS:10JUNE2020 Added Code

    //PRJ-250:AS:10JUNE2020 - start
    layout
    {
        modify("Balance Due (LCY)")
        {
            Visible = false;
        }
        addafter("Balance (LCY)")
        {
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
                end;
            }
        }
    }
    //PRJ-250:AS:10JUNE2020 - end
    actions
    {
        modify(CustomerLedgerEntries)
        {
            trigger OnBeforeAction();
            begin
                //ProjectPro - start
                NS_CustLedgEntry.RESET;
                NS_CustLedgEntry.SETCURRENTKEY("Document Type", "Customer No.", "Global Dimension 1 Code", "Global Dimension 2 Code",
                                           "Posting Date", "Currency Code");
                NS_CustLedgEntry.SETRANGE("Customer No.", "No.");
                //IF NOT NS_SalesSetup."Sales Retention Inactive" THEN
                //NS_CustLedgEntry.SETRANGE("Retention Ledger Code",NS_SalesSetup."Normal Customer Ledger No.");
                NS_CustomerLedgerEntries.SETTABLEVIEW(NS_CustLedgEntry);
                NS_CustomerLedgerEntries.RUNMODAL;
                CLEAR(NS_CustomerLedgerEntries);
                //ProjectPro - end
            end;
        }

        addafter(CustomerLedgerEntries)
        {
            action("NS_Retention Entries")
            {
                Caption = '&Retention Ledger Entries';
                Image = CustomerLedger;
                ApplicationArea = All;
                ToolTip = 'Retention Ledger Entries';

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
                        CLEAR(NS_CustomerLedgerEntries);
                    end;
                    //ProjectPro - end
                end;
            }
        }
        addafter("Item &Tracking Entries")
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
        NS_SalesSetup: Record "Sales & Receivables Setup";
        NS_JobsSetup: Record "Jobs Setup";
        NS_CustLedgEntry: Record "Cust. Ledger Entry";
        NS_CustomerLedgerEntries: Page "Customer Ledger Entries";
        CustLegEnt_G: Record "Cust. Ledger Entry";//PRJ-250:AS:10JUNE2020
        BalanceDueLcy_N: Decimal;//PRJ-250:AS:10JUNE2020
        BalanceDueLcy_NToshow: Decimal;//PRJ-250:AS:10JUNE2020

    trigger OnOpenPage();
    begin
        //ProjectPro - start
        NS_SalesSetup.GET;
        NS_JobsSetup.GET;
        //ProjectPro - end
    end;
    //PRJ-250:AS:10JUNE2020 - START 
    trigger OnAfterGetRecord();
    begin

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
    end;
    //PRJ-250:AS:10JUNE2020 - end
    /*
    +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +     NS_SalesSetup
      +     NS_JobsSetup
      +     NS_CustLedgEntry
      +     NS_CustomerLedgerEntries
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +     - OpenPage - Read setup records
      +                   NS_SalesSetup
      +                   NS_JobsSetup
      +     - Added action list:
      +         PP Retention Entries - OnAction - Call to NS_CustomerLedgerEntries page
      +     - Modify action list:
      +         CutomerLedgerEntries - OnAction - Call to NS_CustomerLedgerEntries page
      +     - Added Job Quotes Page Action to History ActionGroup.
      +
      + -SMP
      +  -Modified Page Triggers
      +   -OnOpenPage
      +
      +-----------------------------------------------------------------------------------------------
      */
}

