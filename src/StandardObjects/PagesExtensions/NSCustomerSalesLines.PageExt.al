pageextension 14021246 NS_CustomerSalesLines extends "Customer Sales Lines"
{
    // version NAVW111.00,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Lines'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        modify(BalanceDueLCY)
        {
            Visible = false;
        }
        modify("Cust.""Sales (LCY)""")
        {
            Visible = false;
        }
        modify("Cust.""Profit (LCY)""")
        {
            Visible = false;
        }

        addafter(BalanceDueLCY)
        {
            field(NS_BalanceDueLCY; Cust."Balance Due (LCY)")
            {
                Caption = 'Balance Due ($)';
                ToolTip = 'Specifies the balance due, in local currency.';
                ApplicationArea = All;
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ShowCustEntriesDue();
                end;
            }
            field(NS_Control8; Cust."Sales (LCY)")
            {
                Caption = 'Sales ($)';
                ToolTip = 'Specifies the sales related to the customer, in local currency.';
                ApplicationArea = All;
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ShowCustEntries();
                end;
            }
            field(NS_Control10; Cust."Sales (LCY)")
            {
                Caption = 'Profit ($)';
                ToolTip = 'Specifies the profit related to the customer, in local currency.';
                ApplicationArea = All;
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ShowCustEntries();
                end;
            }
        }
    }

    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
        BalanceDueLCY: Decimal;
        Cust: Record Customer;
        PeriodType: Integer; //'Day,Week,Month,Quarter,Year,Accounting Period'
        AmountType: Integer; //'Net Change,Balance at Date'
        p: Codeunit "NS_Parameters for Events";

    trigger OnOpenPage()
    begin
        NS_SalesSetup.Get();
        p.NS_P351GetParam(Cust, PeriodType, AmountType);
    end;

    trigger OnAfterGetRecord()
    begin
        SetDateFilter;
        Cust.CALCFIELDS("Balance Due (LCY)", "Sales (LCY)", "Profit (LCY)");
    end;

    local procedure SetDateFilter()
    begin
        IF AmountType = 0 then //AmountType::"Net Change"
            Cust.SETRANGE("Date Filter", "Period Start", "Period End")
        ELSE
            Cust.SETRANGE("Date Filter", 0D, "Period End");
    end;

    LOCAL procedure ShowCustEntries()
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        SetDateFilter;
        CustLedgEntry.RESET;
        CustLedgEntry.SETCURRENTKEY("Customer No.", "Posting Date");
        CustLedgEntry.SETRANGE("Customer No.", Cust."No.");
        CustLedgEntry.SETFILTER("Posting Date", Cust.GETFILTER("Date Filter"));
        CustLedgEntry.SETFILTER("Global Dimension 1 Code", Cust.GETFILTER("Global Dimension 1 Filter"));
        CustLedgEntry.SETFILTER("Global Dimension 2 Code", Cust.GETFILTER("Global Dimension 2 Filter"));
        //ProjectPro - start
        IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
            CustLedgEntry.SETFILTER("NS_Retention Ledger Code", Cust.GETFILTER("NS_Retention Ledger CodeFilter"))
        ELSE
            CustLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_SalesSetup."NS_Normal Customer Ledger No.");
        //ProjectPro - end
        PAGE.RUN(0, CustLedgEntry);
    end;

    LOCAL procedure ShowCustEntriesDue()
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        SetDateFilter;
        DtldCustLedgEntry.RESET;
        DtldCustLedgEntry.SETCURRENTKEY("Customer No.", "Initial Entry Due Date", "Posting Date", "Currency Code");
        DtldCustLedgEntry.SETRANGE("Customer No.", Cust."No.");
        DtldCustLedgEntry.SETFILTER("Initial Entry Due Date", Cust.GETFILTER("Date Filter"));
        DtldCustLedgEntry.SETFILTER("Posting Date", '..%1', Cust.GETRANGEMAX("Date Filter"));
        DtldCustLedgEntry.SETFILTER("Initial Entry Global Dim. 1", Cust.GETFILTER("Global Dimension 1 Filter"));
        DtldCustLedgEntry.SETFILTER("Initial Entry Global Dim. 2", Cust.GETFILTER("Global Dimension 2 Filter"));
        //ProjectPro - start
        DtldCustLedgEntry.SETFILTER("NS_Retention Ledger Code", Cust.GETFILTER("NS_Retention Ledger CodeFilter"));
        //ProjectPro - end
        PAGE.RUN(0, DtldCustLedgEntry)
    end;


}

