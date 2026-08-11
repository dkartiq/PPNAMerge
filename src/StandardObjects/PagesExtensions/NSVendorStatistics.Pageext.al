pageextension 14021225 NS_VendorStatistics extends "Vendor Statistics"
{
    // version NAVW111.00,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Vendor Statistics'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        addafter("Balance (LCY)")
        {
            field("NS_Retention Balance LCY"; NS_RetentionBalanceLCY)
            {
                ApplicationArea = All;
                Caption = 'Retention Balance ($)';

                ToolTip = 'Retention Balance ($)';
                Editable = false;

                trigger OnDrillDown();
                var
                    NS_VendLedgEntry: Record "Vendor Ledger Entry";
                    NS_DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
                begin
                    //ProjectPro - start
                    if not NS_PurchSetup."NS_Purchase Retention Inactive" then begin
                        NS_DtldVendLedgEntry.SETFILTER("Vendor No.", Rec."No.");
                        Rec.COPYFILTER("Global Dimension 1 Filter", NS_DtldVendLedgEntry."Initial Entry Global Dim. 1");
                        Rec.COPYFILTER("Global Dimension 2 Filter", NS_DtldVendLedgEntry."Initial Entry Global Dim. 2");
                        NS_DtldVendLedgEntry.SETFILTER("NS_Retention Ledger Code", NS_JobsSetup."NS_Retention Payable Ledger");
                        Rec.COPYFILTER("Currency Filter", NS_DtldVendLedgEntry."Currency Code");
                        NS_VendLedgEntry.DrillDownOnEntries(NS_DtldVendLedgEntry);
                    end;
                    //ProjectPro - end
                end;
            }
        }
    }

    var
        NS_JobsSetup: Record "Jobs Setup";
        NS_PurchSetup: Record "Purchases & Payables Setup";
        NS_RetentionBalanceLCY: Decimal;

    trigger OnOpenPage()
    begin
        NS_PurchSetup.GET();
        NS_JobsSetup.GET();
    end;

    trigger OnAfterGetRecord();
    begin
        NS_RetentionBalanceLCY := 0;
        IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN BEGIN
            Rec.SETRANGE("NS_Retention Ledger CodeFilter", NS_JobsSetup."NS_Retention Payable Ledger");
            Rec.CALCFIELDS("Balance (LCY)");
            NS_RetentionBalanceLCY := rec."Balance (LCY)";
        END;
    end;
}

