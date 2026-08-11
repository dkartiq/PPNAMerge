pageextension 14021247 NS_VendorPurchLines extends "Vendor Purchase Lines"
{
    // version NAVW111.00,PPNA11.00
    layout
    {
        modify(BalanceDueLCY)
        {
            Visible = false;
        }
        modify("Vend.""Purchases (LCY)""")
        {
            Visible = false;
        }


        addafter(BalanceDueLCY)
        {
            field(NS_BalanceDueLCY; Vend."Balance Due (LCY)")
            {
                Caption = 'Balance Due ($)';
                ToolTip = 'Specifies the balance due, in local currency.';
                ApplicationArea = All;
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ShowVendEntriesDue();
                end;
            }
            field(NS_Control8; Vend."Purchases (LCY)")
            {
                Caption = 'Purchases ($)';
                ToolTip = 'Specifies the purchases, in local currency.';
                ApplicationArea = All;
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ShowVendEntries();
                end;
            }
        }
    }


    var
        NS_PurchSetup: Record "Purchases & Payables Setup";
        Vend: Record Vendor;
        //BalanceDueLCY: Decimal;
        PeriodType: Integer; //'Day,Week,Month,Quarter,Year,Accounting Period'
        AmountType: Integer; //'Net Change,Balance at Date'
        p: Codeunit "NS_Parameters for Events";


    trigger OnOpenPage()
    begin
        NS_PurchSetup.Get();
        p.NS_P352GetParam(Vend, PeriodType, AmountType);
    end;

    LOCAL procedure ShowVendEntries()
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin
        SetDateFilter;
        VendLedgEntry.RESET;
        VendLedgEntry.SETCURRENTKEY("Vendor No.", "Posting Date");
        VendLedgEntry.SETRANGE("Vendor No.", Vend."No.");
        VendLedgEntry.SETFILTER("Posting Date", Vend.GETFILTER("Date Filter"));
        VendLedgEntry.SETFILTER("Global Dimension 1 Code", Vend.GETFILTER("Global Dimension 1 Filter"));
        VendLedgEntry.SETFILTER("Global Dimension 2 Code", Vend.GETFILTER("Global Dimension 2 Filter"));
        //ProjectPro - start
        IF NS_PurchSetup."NS_Purchase Retention Inactive" THEN
            VendLedgEntry.SETFILTER("NS_Retention Ledger Code", Vend.GETFILTER("NS_Retention Ledger CodeFilter"))
        ELSE
            VendLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_PurchSetup."NS_Normal Vendor Ledger No.");
        //ProjectPro - end
        PAGE.RUN(0, VendLedgEntry);
    end;

    LOCAL procedure ShowVendEntriesDue()
    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        SetDateFilter;
        DtldVendLedgEntry.RESET;
        DtldVendLedgEntry.SETCURRENTKEY("Vendor No.", "Initial Entry Due Date", "Posting Date", "Currency Code");
        DtldVendLedgEntry.SETRANGE("Vendor No.", Vend."No.");
        DtldVendLedgEntry.SETFILTER("Initial Entry Due Date", Vend.GETFILTER("Date Filter"));
        DtldVendLedgEntry.SETFILTER("Posting Date", '..%1', Vend.GETRANGEMAX("Date Filter"));
        DtldVendLedgEntry.SETFILTER("Initial Entry Global Dim. 1", Vend.GETFILTER("Global Dimension 1 Filter"));
        DtldVendLedgEntry.SETFILTER("Initial Entry Global Dim. 2", Vend.GETFILTER("Global Dimension 2 Filter"));
        //ProjectPro - start
        DtldVendLedgEntry.SETFILTER("NS_Retention Ledger Code", Vend.GETFILTER("NS_Retention Ledger CodeFilter"));
        //ProjectPro - end
        PAGE.RUN(0, DtldVendLedgEntry)
    end;

    LOCAL procedure SetDateFilter()
    begin
        IF AmountType = 0 then //AmountType::"Net Change"
            Vend.SETRANGE("Date Filter", Rec."Period Start", Rec."Period End")
        ELSE
            Vend.SETRANGE("Date Filter", 0D, Rec."Period End");
    end;
}
