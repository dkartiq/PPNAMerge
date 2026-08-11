pageextension 14021254 NS_ReminderStats extends "Reminder Statistics"
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
            field(NS_Cust_Copy_BalanceLCY; Cust_Copy."Balance (LCY)")
            {
                Caption = 'Balance ($)';
                ToolTip = 'Specifies the balance in $ on the customer''s account.';
                ApplicationArea = All;
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

            field(NS_CustCopyCreditLimitLCY; Cust_Copy."Credit Limit (LCY)")
            {
                Caption = 'Credit Limit ($)';
                ToolTip = 'Specifies the maximum credit in $ that can be extended to the customer for whom you created and posted this service credit memo. ';
                ApplicationArea = All;
                AutoFormatType = 1;
            }

            field(NS_CreditLimitLCYExpendedPct_Copy; CreditLimitLCYExpendedPct_Copy)
            {
                ExtendedDatatype = Ratio;
                Caption = 'Expended % of Credit Limit ($)';
                ToolTip = 'Specifies the expended percentage of the credit limit in ($).';
                ApplicationArea = All;
            }
        }
    }

    var
        NS_JobsSetup: Record "Jobs Setup";
        NS_SalesSetup: Record "Sales & Receivables Setup";
        NS_RetentionBalanceLCY: Decimal;
        CreditLimitLCYExpendedPct_Copy: Decimal;
        Cust_Copy: Record Customer;

    trigger OnOpenPage();
    begin

        //ProjectPro - start
        NS_JobsSetup.GET;
        NS_SalesSetup.GET;
        //ProjectPro - end

    end;

    trigger OnAfterGetRecord();
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
    //   +     PP_JobsSetup
    //   +     PP_SalesSetup
    //   +     PP_RetentionBalanceLCY
    //   +
    //   +  - Modification(s):
    //   +     - OnOpenPage: get Jobs Setup and Sales & Receivables Setup records
    //   +     - OnAfterGetRecord: calculate Retention Balance (LCY)
    //   +------------------------------------------------------------

}

