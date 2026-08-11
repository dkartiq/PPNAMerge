pageextension 14021155 NS_CustomerStatistics extends "Customer Statistics"
{
    // version NAVW111.00,,PPNA11.00,PPNA11.00
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
                    NS_DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                    NS_CustLedgEntry: Record "Cust. Ledger Entry";
                begin
                    //ProjectPro - start
                    if not NS_SalesSetup."NS_Sales Retention Inactive" then begin
                        NS_DtldCustLedgEntry.SETFILTER("Customer No.", "No.");
                        COPYFILTER("Global Dimension 1 Filter", NS_DtldCustLedgEntry."Initial Entry Global Dim. 1");
                        NS_DtldCustLedgEntry.SETFILTER("NS_Retention Ledger Code", NS_SalesSetup."NS_Normal Customer Ledger No.");
                        COPYFILTER("Currency Filter", NS_DtldCustLedgEntry."Currency Code");
                        NS_CustLedgEntry.DrillDownOnEntries(NS_DtldCustLedgEntry);
                    end;
                    //ProjectPro - end
                end;
            }
        }
    }

    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
        NS_JobsSetup: Record "Jobs Setup";
        NS_RetentionBalanceLCY: Decimal;

    trigger OnOpenPage()
    begin
        NS_SalesSetup.GET;
        NS_JobsSetup.GET;
    end;

    trigger OnAfterGetRecord();
    begin
        NS_RetentionBalanceLCY := 0;
        NS_SalesSetup.GET;
        IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN BEGIN
            NS_JobsSetup.GET;
            SETFILTER("NS_Retention Ledger CodeFilter", NS_JobsSetup."NS_Retention Receivable Ledger");
            CALCFIELDS("Balance (LCY)");
            NS_RetentionBalanceLCY := "Balance (LCY)";
        END;
    end;

}

