pageextension 14021257 NS_IssuedFinChargeMemoStats extends "Issued Fin. Charge Memo Stat."
{
    // version NAVW111.00,,NSNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Issued Fin. Charge Memo Stat.'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        modify("Cust.""Balance (LCY)""")
        {
            Visible = false;
            Enabled = false;
        }

        modify("Cust.""Credit Limit (LCY)""")
        {
            Visible = false;
            Enabled = false;
        }

        modify(CreditLimitLCYExpendedPct)
        {
            Visible = false;
            Enabled = false;
        }

        addbefore("Cust.""Balance (LCY)""")
        {
            field(NS_CustBalanceLCY; Cust_Copy."Balance (LCY)")
            {
                Caption = 'Balance ($)';
                ToolTip = 'Specifies the balance in $ on the customer''s account.';
                ApplicationArea = all;
                AutoFormatType = 1;
            }
        }

        addafter("Cust.""Balance (LCY)""")
        {
            field("NS Retention Balance LCY"; NS_RetentionBalanceLCY)
            {
                ApplicationArea = All;
                AutoFormatType = 1;
                Caption = 'Retention Balance ($)';
            }

            field(NS_CustCreditLimitLCY; Cust_Copy."Credit Limit (LCY)")
            {
                Caption = 'Credit Limit ($)';
                ToolTip = 'Specifies the credit limit in $ on the customer''s account.';
                ApplicationArea = all;
                AutoFormatType = 1;
            }

            field(NS_CreditLimitLCYExpendedPct_Copy; CreditLimitLCYExpendedPct_Copy)
            {
                ExtendedDatatype = Ratio;
                Caption = 'Expended % of Credit Limit ($)';
                ToolTip = 'Specifies the expended percentage of the credit limit in ($).';
                ApplicationArea = all;
            }
        }
    }

    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
        NS_JobsSetup: Record "Jobs Setup";
        NS_RetentionBalanceLCY: Decimal;
        Cust_Copy: Record customer;
        CreditLimitLCYExpendedPct_Copy: Decimal;

    trigger OnOpenPage();
    begin
        //ProjectPro - start
        NS_SalesSetup.GET;
        NS_JobsSetup.GET;
        //ProjectPro - end
    end;

    trigger OnAfterGetRecord()
    begin
        IF Cust_Copy.GET("Customer No.") THEN
         //ProjectPro - start
         BEGIN
            NS_RetentionBalanceLCY := 0;
            IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN BEGIN
                Cust_Copy.SETRANGE("NS_Retention Ledger CodeFilter", NS_JobsSetup."NS_Retention Receivable Ledger");
                Cust_Copy.CALCFIELDS("Balance (LCY)");
                NS_RetentionBalanceLCY := Cust_Copy."Balance (LCY)";
                Cust_Copy.SETRANGE("NS_Retention Ledger CodeFilter", NS_SalesSetup."NS_Normal Customer Ledger No.");
            END;
            //ProjectPro - end
            Cust_Copy.CALCFIELDS("Balance (LCY)");
        END ELSE
            CLEAR(Cust_Copy);
        IF Cust_Copy."Credit Limit (LCY)" = 0 THEN
            CreditLimitLCYExpendedPct_Copy := 0
        ELSE
            CreditLimitLCYExpendedPct_Copy := ROUND(Cust_Copy."Balance (LCY)" / Cust_Copy."Credit Limit (LCY)" * 10000, 1);
    end;

    //   +------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +     "NS Retention Balance LCY"
    //   +
    //   +  - Added global variable(s):
    //   +     NS_SalesSetup
    //   +     NS_JobsSetup
    //   +     NS_RetentionBalanceLCY
    //   +
    //   +  - Modification(s):
    //   +     - OnOpenPage: get Jobs Setup and Sales & Receivables Setup records
    //   +     - OnAfterGetRecord: calculate Retention Balance (LCY)
    //   +------------------------------------------------------------

}

