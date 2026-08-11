pageextension 14021455 NS_CustomerStatsFactBoxExt extends "Customer Statistics FactBox"
{
    // version NAVW111.00.00.22292,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Customer Statistics'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        modify("Balance (LCY)")
        {
            Visible = false;
            Enabled = false;
        }
        addafter("No.")
        {
            field("NS_Balance (LCY)2"; Rec."Balance (LCY)")
            {
                Caption = 'Balance (LCY)';
                ToolTip = 'Specifies the payment amount that the customer owes for completed sales. This value is also known as the customers balance.';
                ApplicationArea = Basic, Suite;
                trigger OnDrillDown();
                var
                    DtldCustLedgEntry: Record 379;
                    CustLedgEntry: Record 21;
                begin
                    DtldCustLedgEntry.SETRANGE("Customer No.", "No.");
                    COPYFILTER("Global Dimension 1 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 1");
                    COPYFILTER("Global Dimension 2 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 2");
                    //ProjectPro - start
                    COPYFILTER("NS_Retention Ledger CodeFilter", DtldCustLedgEntry."NS_Retention Ledger Code");
                    //ProjectPro - end
                    COPYFILTER("Currency Filter", DtldCustLedgEntry."Currency Code");
                    CustLedgEntry.DrillDownOnEntries(DtldCustLedgEntry);
                end;
            }
        }
        modify("Balance Due (LCY)")
        {
            Visible = false;
            Enabled = false;
        }
        addafter("Credit Limit (LCY)")
        {
            field(NS_CalcOverdueBalance; CalcOverdueBalance)
            {
                Caption = 'Balance Due ($)';

                ToolTip = 'Balance Due ($)';
                ApplicationArea = Basic, Suite;
                CaptionClass = FORMAT(STRSUBSTNO(Text000, FORMAT(WORKDATE)));
                trigger OnDrillDown();
                VAR
                    DtldCustLedgEntry: Record 379;
                    CustLedgEntry: Record 21;
                BEGIN
                    DtldCustLedgEntry.SETFILTER("Customer No.", "No.");
                    COPYFILTER("Global Dimension 1 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 1");
                    COPYFILTER("Global Dimension 2 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 2");
                    //ProjectPro - start
                    COPYFILTER("NS_Retention Ledger CodeFilter", DtldCustLedgEntry."NS_Retention Ledger Code");
                    //ProjectPro - end
                    COPYFILTER("Currency Filter", DtldCustLedgEntry."Currency Code");
                    CustLedgEntry.DrillDownOnOverdueEntries(DtldCustLedgEntry);
                END;
            }
        }
    }
    var
        Text000: Label 'Overdue Amounts ($) as of %1';

    /*
     +------------------------------------------------------------
     +ProjectPro
     +  - Modification(s):
     +     - Balance (LCY)     - OnDrillDown() - Added "Retention Ledger Code" filtering
     +     - Balance Due (LCY) - OnDrillDown() - Added "Retention Ledger Code" filtering
     + -SMP
     +  -Rewritten Fields
     +   -Balance Due (LCY) 
     +   -Balance (LCY)
     +------------------------------------------------------------
   */

}

