pageextension 14021126 NS_AppliedCustomerEntries extends "Applied Customer Entries"
{
    // version NAVW111.00.00.24232,PPNA11.00
    //PRJ-252 AS1.0 04-05-20 Added some code & created FindApplnEntriesDtldtLedgEntry_Customized()
    //       + code commented on OnOpen page
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Applied Customer Entries'; //PRJ-1330.NK.1.0 25Apr2022
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
                Caption = 'Navigate';
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
                ApplicationArea = Basic, Suite;
                Promoted = true;
                Image = Navigate;
                PromotedCategory = Process;
                trigger OnAction();
                begin
                    //ProjectPro - start
                    //Navigate.SetDoc("Posting Date","Document No.");
                    Navigate.SetDocLedger("NS_Retention Ledger Code", "Posting Date", "Document No.");
                    //ProjectPro - end
                end;
            }
        }
    }

    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
        NS_PurchSetup: Record "Purchases & Payables Setup";
        Navigate: Page 344;
        CreateCustLedgEntry: Record 21;

    trigger OnOpenPage();
    var
        NS_SalesSetup: Record 311;
        NS_PurchSetup: Record 312;
    begin //          !!! !!! !!! !!! !!! Needs testing !!! !!! !!! !!! !!!

        //     if FindFirst then;
        //     repeat
        //         Mark(false);
        //     until (Next = 0);
        //     RESET;

        //     //ProjectPro - start
        //     PP_SalesSetup.GET;
        //     PP_PurchSetup.GET;
        //     //ProjectPro - end

        //     IF "Entry No." <> 0 THEN BEGIN
        //         CreateCustLedgEntry := Rec; //PRJ-252 AS1.0 04-05-20
        //         FindApplnEntriesDtldtLedgEntry_Customized();//PRJ-252 AS1.0 04-05-20
        //         SETCURRENTKEY("Entry No.");
        //         SETRANGE("Entry No.");

        //         IF CreateCustLedgEntry."Closed by Entry No." <> 0 THEN BEGIN
        //             "Entry No." := CreateCustLedgEntry."Closed by Entry No.";
        //             MARK(TRUE);
        //         END;

        //         SETCURRENTKEY("Closed by Entry No.");
        //         SETRANGE("Closed by Entry No.", CreateCustLedgEntry."Entry No.");
        //         //ProjectPro - start
        //         IF (NOT PP_SalesSetup."Sales Retention Inactive") OR (NOT PP_PurchSetup."Purchase Retention Inactive") THEN
        //             SETRANGE("Retention Ledger Code", CreateCustLedgEntry."Retention Ledger Code");
        //         //ProjectPro - end
        //         IF FIND('-') THEN
        //             REPEAT
        //                 MARK(TRUE);
        //             UNTIL NEXT = 0;

        //         SETCURRENTKEY("Entry No.");
        //         SETRANGE("Closed by Entry No.");
        //         //ProjectPro - start
        //         IF (NOT PP_SalesSetup."Sales Retention Inactive") OR (NOT PP_PurchSetup."Purchase Retention Inactive") THEN
        //             SETRANGE("Retention Ledger Code");
        //         //ProjectPro - end
        //     END;
        //     MARKEDONLY(TRUE);
    end;

    //PRJ-252 AS1.0 04-05-20 start
    procedure FindApplnEntriesDtldtLedgEntry_Customized()
    var
        DtldCustLedgEntry11: Record "Detailed Cust. Ledg. Entry";
        DtldCustLedgEntry12: Record "Detailed Cust. Ledg. Entry";
    begin
        DtldCustLedgEntry11.SETCURRENTKEY("Cust. Ledger Entry No.");
        DtldCustLedgEntry11.SETRANGE("Cust. Ledger Entry No.", CreateCustLedgEntry."Entry No.");
        DtldCustLedgEntry11.SETRANGE(Unapplied, FALSE);
        IF DtldCustLedgEntry11.FIND('-') THEN
            REPEAT
                IF DtldCustLedgEntry11."Cust. Ledger Entry No." =
                   DtldCustLedgEntry11."Applied Cust. Ledger Entry No."
                THEN BEGIN
                    DtldCustLedgEntry12.INIT;
                    DtldCustLedgEntry12.SETCURRENTKEY("Applied Cust. Ledger Entry No.", "Entry Type");
                    DtldCustLedgEntry12.SETRANGE(
                      "Applied Cust. Ledger Entry No.", DtldCustLedgEntry11."Applied Cust. Ledger Entry No.");
                    DtldCustLedgEntry12.SETRANGE("Entry Type", DtldCustLedgEntry12."Entry Type"::Application);
                    DtldCustLedgEntry12.SETRANGE(Unapplied, FALSE);
                    IF DtldCustLedgEntry12.FIND('-') THEN
                        REPEAT
                            IF DtldCustLedgEntry12."Cust. Ledger Entry No." <>
                               DtldCustLedgEntry12."Applied Cust. Ledger Entry No."
                            THEN BEGIN
                                SETCURRENTKEY("Entry No.");
                                SETRANGE("Entry No.", DtldCustLedgEntry12."Cust. Ledger Entry No.");
                                IF FIND('-') THEN
                                    MARK(TRUE);
                            END;
                        UNTIL DtldCustLedgEntry12.NEXT = 0;
                END ELSE BEGIN
                    SETCURRENTKEY("Entry No.");
                    SETRANGE("Entry No.", DtldCustLedgEntry11."Applied Cust. Ledger Entry No.");
                    IF FIND('-') THEN
                        MARK(TRUE);
                END;
            UNTIL DtldCustLedgEntry11.NEXT = 0;
    end;
    //PRJ-252 AS1.0 04-05-20 end
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
      +     - OnOpenPage - Read setup records
      +                       PP_SalesSetup
      +                       PP_PurchSetup
      +                  - When retention is active set filter on Retention Ledger Code
      +     - Modify action list:
      +         Modifyied call to Navigate.SetDocLedger for Retention
      + 
      + -SMP
      +  -Rewriten Actions
      +   -Navigate
      +-----------------------------------------------------------------------------------------------
    */

}

