pageextension 14021127 NS_AppliedVendorEntries extends "Applied Vendor Entries"
{
    // version NAVW111.00.00.24232,PPNA11.00
    //PRJ-252 AS1.0 04-05-20 Added some code & created FindApplnEntriesDtldtLedgEntry_Customized()
    //       + code commented on OnOpen page
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Applied Vendor Entries'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        addafter("Global Dimension 2 Code")
        {
            field("NS_Retention Ledger Code"; Rec."NS_Retention Ledger Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Retention Ledger Code';
            }
        }
    }
    actions
    {
        modify("&Navigate")
        {
            Visible = false;
            Enabled = false;
        }
        addafter("&Navigate")
        {
            action(NS_Navigate)
            {
                Caption = '&Navigate';
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
                ApplicationArea = Basic, Suite;
                Promoted = true;
                Image = Navigate;
                PromotedCategory = Process;
                trigger OnAction();
                begin
                    //ProjectPro - start
                    //Navigate.SetDoc("Posting Date","Document No.");
                    Navigate.SetDocLedger("Global Dimension 2 Code", "Posting Date", "Document No.");
                    //ProjectPro - end
                    Navigate.RUN;
                end;
            }
        }
    }

    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
        NS_PurchSetup: Record "Purchases & Payables Setup";
        CreateVendLedgEntry: Record 25;
        Navigate: Page 344;


    trigger OnOpenPage();
    var
        NS_SalesSetup: Record 311;
        NS_PurchSetup: Record 312;
    begin //          !!! !!! !!! !!! !!! Needs testing !!! !!! !!! !!! !!!

        // if FindFirst then;
        // repeat
        //     Mark(false);
        // until (Next = 0);
        // RESET;

        // //ProjectPro - start
        // PP_SalesSetup.GET;
        // PP_PurchSetup.GET;
        // //ProjectPro - end

        // IF "Entry No." <> 0 THEN BEGIN
        //     CreateVendLedgEntry := Rec;//PRJ-252 AS1.0 04-05-20
        //     FindApplnEntriesDtldtLedgEntry_Customized();//PRJ-252 AS1.0 04-05-20
        //     SETCURRENTKEY("Entry No.");
        //     SETRANGE("Entry No.");

        //     IF CreateVendLedgEntry."Closed by Entry No." <> 0 THEN BEGIN
        //         "Entry No." := CreateVendLedgEntry."Closed by Entry No.";
        //         MARK(TRUE);
        //     END;

        //     SETCURRENTKEY("Closed by Entry No.");
        //     SETRANGE("Closed by Entry No.", CreateVendLedgEntry."Entry No.");
        //     //ProjectPro - start
        //     IF (NOT PP_SalesSetup."Sales Retention Inactive") OR (NOT PP_PurchSetup."Purchase Retention Inactive") THEN
        //         SETRANGE("Retention Ledger Code", CreateVendLedgEntry."Retention Ledger Code");
        //     //ProjectPro - end
        //     IF FIND('-') THEN
        //         REPEAT
        //             MARK(TRUE);
        //         UNTIL NEXT = 0;

        //     SETCURRENTKEY("Entry No.");
        //     SETRANGE("Closed by Entry No.");
        //     //ProjectPro - start
        //     IF (NOT PP_SalesSetup."Sales Retention Inactive") OR (NOT PP_PurchSetup."Purchase Retention Inactive") THEN
        //         SETRANGE("Retention Ledger Code");
        //     //ProjectPro - end
        // END;

        // MARKEDONLY(TRUE);
    END;

    //PRJ-252 AS1.0 04-05-20 START
    procedure FindApplnEntriesDtldtLedgEntry_Customized();
    var
        DtldVendLedgEntry11: Record "Detailed Vendor Ledg. Entry";
        DtldVendLedgEntry12: Record "Detailed Vendor Ledg. Entry";
    begin
        DtldVendLedgEntry11.SETCURRENTKEY("Vendor Ledger Entry No.");
        DtldVendLedgEntry11.SETRANGE("Vendor Ledger Entry No.", CreateVendLedgEntry."Entry No.");
        DtldVendLedgEntry11.SETRANGE(Unapplied, FALSE);
        IF DtldVendLedgEntry11.FIND('-') THEN
            REPEAT
                IF DtldVendLedgEntry11."Vendor Ledger Entry No." =
                   DtldVendLedgEntry11."Applied Vend. Ledger Entry No."
                THEN BEGIN
                    DtldVendLedgEntry12.INIT;
                    DtldVendLedgEntry12.SETCURRENTKEY("Applied Vend. Ledger Entry No.", "Entry Type");
                    DtldVendLedgEntry12.SETRANGE(
                      "Applied Vend. Ledger Entry No.", DtldVendLedgEntry11."Applied Vend. Ledger Entry No.");
                    DtldVendLedgEntry12.SETRANGE("Entry Type", DtldVendLedgEntry12."Entry Type"::Application);
                    DtldVendLedgEntry12.SETRANGE(Unapplied, FALSE);
                    IF DtldVendLedgEntry12.FIND('-') THEN
                        REPEAT
                            IF DtldVendLedgEntry12."Vendor Ledger Entry No." <>
                               DtldVendLedgEntry12."Applied Vend. Ledger Entry No."
                            THEN BEGIN
                                SETCURRENTKEY("Entry No.");
                                SETRANGE("Entry No.", DtldVendLedgEntry12."Vendor Ledger Entry No.");
                                IF FIND('-') THEN
                                    MARK(TRUE);
                            END;
                        UNTIL DtldVendLedgEntry12.NEXT = 0;
                END ELSE BEGIN
                    SETCURRENTKEY("Entry No.");
                    SETRANGE("Entry No.", DtldVendLedgEntry11."Applied Vend. Ledger Entry No.");
                    IF FIND('-') THEN
                        MARK(TRUE);
                END;
            UNTIL DtldVendLedgEntry11.NEXT = 0;
    end;
    //PRJ-252 AS1.0 04-05-20 END
    /* Documentation 
      +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     Retention Ledger Code
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +     - OnOpenPage  - Read setup records
      +                       PP_SalesSetup
      +                       PP_PurchSetup
      +                   - When retention is active set filter on Retention Ledger Code
      +     - Modify action list:
      +         Modifyied call to Navigate.SetDocLedger for Retention
      +
      + -SMP
      +  -Rewritten Action
      +   -Navigate
      +-----------------------------------------------------------------------------------------------
    */

}

