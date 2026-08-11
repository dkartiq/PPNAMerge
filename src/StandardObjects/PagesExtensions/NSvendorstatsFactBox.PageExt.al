pageextension 14021456 NS_VendorStatsFactBox extends "Vendor Statistics FactBox"
{
    // version NAVW111.00.00.20348,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Vendor Statistics'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        modify("Balance (LCY)")
        {
            Visible = false;
            Enabled = false;
        }
        addafter("No.")
        {
            field("NS_Balance (LCY)2"; rec."Balance (LCY)")
            {
                Caption = 'Balance (LCY)';
                ToolTip = 'Specifies the total value of your completed purchases from the vendor in the current fiscal year. It is calculated from amounts excluding tax on all completed purchase invoices and credit memos.';
                ApplicationArea = Basic, Suite;
                trigger OnDrillDown();
                VAR
                    VendLedgEntry: Record 25;
                    DtldVendLedgEntry: Record 380;
                BEGIN
                    DtldVendLedgEntry.SETRANGE("Vendor No.", Rec."No.");
                    Rec.COPYFILTER("Global Dimension 1 Filter", DtldVendLedgEntry."Initial Entry Global Dim. 1");
                    Rec.COPYFILTER("Global Dimension 2 Filter", DtldVendLedgEntry."Initial Entry Global Dim. 2");
                    //ProjectPro - start
                    Rec.COPYFILTER("NS_Retention Ledger CodeFilter", DtldVendLedgEntry."NS_Retention Ledger Code");
                    //ProjectPro - end
                    Rec.COPYFILTER("Currency Filter", DtldVendLedgEntry."Currency Code");
                    VendLedgEntry.DrillDownOnEntries(DtldVendLedgEntry);
                END;
            }
        }
        modify("Balance Due (LCY)")
        {
            Visible = false;
            Enabled = false;
        }
        addafter(TotalAmountLCY)
        {
            field(NS_CalcOverDueBalance; rec.CalcOverDueBalance())
            {
                Caption = 'Balance Due ($)';

                ToolTip = 'Balance Due ($)';
                ApplicationArea = Advanced;
                CaptionClass = FORMAT(STRSUBSTNO(Text000, FORMAT(WORKDATE())));
                trigger OnDrillDown();
                VAR
                    VendLedgEntry: Record 25;
                    DtldVendLedgEntry: Record 380;
                BEGIN
                    DtldVendLedgEntry.SETFILTER("Vendor No.", Rec."No.");
                    Rec.COPYFILTER("Global Dimension 1 Filter", DtldVendLedgEntry."Initial Entry Global Dim. 1");
                    Rec.COPYFILTER("Global Dimension 2 Filter", DtldVendLedgEntry."Initial Entry Global Dim. 2");
                    //ProjectPro - start
                    Rec.COPYFILTER("NS_Retention Ledger CodeFilter", DtldVendLedgEntry."NS_Retention Ledger Code");
                    //ProjectPro - end
                    Rec.COPYFILTER("Currency Filter", DtldVendLedgEntry."Currency Code");
                    VendLedgEntry.DrillDownOnOverdueEntries(DtldVendLedgEntry);
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
    +     -Balance (LCY) - OnDrillDown() Added filter on new Retention Ledger Code field
    +     -Balance Due (LCY) - OnDrillDown() Added filter on new Retention Ledger Code field
    + -SMP
    +  -Rewritten Fields
    +   -Balance Due (LCY) 
    +   -Balance (LCY)
    +------------------------------------------------------------
    */

}

