pageextension 14021256 NS_FinChargeMemoStats extends "Finance Charge Memo Statistics"
{
    // version NAVW111.00,PPNA11.00

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

        addafter(Customer)
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
            field("NS_Retention Balance LCY"; NS_RetentionBalanceLCY)
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
        Cust_Copy: Record Customer;

        NS_SalesSetup: Record "Sales & Receivables Setup";
        NS_JobsSetup: Record "Jobs Setup";
        NS_RetentionBalanceLCY: Decimal;
        CreditLimitLCYExpendedPct_Copy: Decimal;

    trigger OnOpenPage()
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
            Cust_Copy.CALCFIELDS("Balance (LCY)")
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
    //   +     "PP Retention Balance LCY"
    //   +
    //   +  - Added global variable(s):
    //   +     PP_SalesSetup
    //   +     PP_JobsSetup
    //   +     PP_RetentionBalanceLCY
    //   +
    //   +  - Modification(s):
    //   +     - OnOpenPage: get Jobs Setup and Sales & Receivables Setup records
    //   +     - OnAfterGetRecord: calculate Retention Balance (LCY)
    //   +------------------------------------------------------------
}

