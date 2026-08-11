pageextension 14021106 NS_VendorList extends "Vendor List"
{
    // version NAVW111.00.00.24742,NAVNA11.00.00.24742,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Vendors'; //PRJ-1330.NK.1.0 25Apr2022
    //PRJ-1537.JS.1.0 25JULY2022 | Reverce Balance Due ($) Sinage condition
    layout
    {

        modify("Balance Due (LCY)")//PRJ-713.AS.1.0
        {
            Visible = false;
        }

        //PRJ-713.AS.1.0 -START
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
        }
        //PRJ-713.AS.1.0 - END
    }
    actions
    {
        addafter("Ledger E&ntries")
        {
            action("NS_Retention Ledger Entries")
            {
                Caption = '&Retention Ledger Entries';
                Image = CustomerLedger;
                Promoted = true;
                PromotedCategory = Process;
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
        //PE-23.NC.1.0 16May2023 Start
        addafter("Purchase Statistics")
        {
            action("NS_Commitment Report")
            {
                ApplicationArea = All;
                Caption = 'Commitment Report';
                ToolTip = 'Run Commitment Report.';
                Image = "Report";
                RunObject = report NS_CommitmentReport;
            }
        }
        //PE-23.NC.1.0 16May2023 End
    }

    var
        NS_PurchSetup: Record "Purchases & Payables Setup";
        NS_JobsSetup: Record "Jobs Setup";
        NS_VendLedgEntry: Record "Vendor Ledger Entry";
        NS_VendorLedgerEntries: Page "Vendor Ledger Entries";
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

    trigger OnAfterGetRecord()
    begin
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
    end;
    /*
    +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +     NS_PurchSetup
      +     NS_JobsSetup
      +     NS_VendLedgEntry
      +     NS_VendorLedgerEntries
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +     - OnOpenPage - Read setup records
      +                         Purchases & Payables Setup
      +                         Jobs Setup
      +     - Added action list:
      +         PP Retention Ledger Entries
      +
      + -SMP
      +  -Modified Page Trigger
      +   -OnOpenPage
      +-----------------------------------------------------------------------------------------------
      */

}

