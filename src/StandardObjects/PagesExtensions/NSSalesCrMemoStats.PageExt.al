pageextension 14021249 NS_SalesCrMemoStatsExt extends "Sales Credit Memo Statistics"
{
    // version NAVW111.00,PPNA11.00

    layout
    {

        modify("Cust.""Balance (LCY)""")
        {
            Visible = false;
            Enabled = false;
        }

        addafter("Cust.""Balance (LCY)""")
        {
            field(NS_CustBalanceLCY; NS_Cust."Balance (LCY)")
            {
                Caption = 'Balance ($)';
                ToolTip = 'Specifies the balance in $ on the customer''s account.';
                ApplicationArea = "#Basic,#Suite";
                AutoFormatType = 1;
            }
        }

        modify("Cust.""Credit Limit (LCY)""")
        {
            Visible = false;
            Enabled = false;
        }

        addafter("Cust.""Credit Limit (LCY)""")
        {
            field(NS_CustCreditLimitLCY; NS_Cust."Credit Limit (LCY)")
            {
                Caption = 'Credit Limit ($)';
                ToolTip = 'Specifies the credit limit in $ of the customer who you created and posted this sales credit memo for.';
                ApplicationArea = "#Basic,#Suite";
                AutoFormatType = 1;
            }
        }

        modify(CreditLimitLCYExpendedPct)
        {
            Visible = false;
            Enabled = false;
        }

        addafter(CreditLimitLCYExpendedPct)
        {
            field(NS_CreditLimitLCYExpendedPct; NS_CreditLimitLCYExpendedPct)
            {
                Caption = 'Expended % of Credit Limit ($)';
                ToolTip = 'Specifies the expended percentage of the credit limit in ($).';
                ApplicationArea = "#Basic,#Suite";
            }
        }

        addafter(AmountInclVAT)
        {
            field("NS Retention Amount (LCY)"; "NS_Retention Amount (LCY)")
            {
                ApplicationArea = All;
                AutoFormatExpression = "Currency Code";
                AutoFormatType = 1;
                ToolTip = 'Specifies the Retention Amount (LCY)';
            }
            field("NS Final Total"; NS_FinalTotal)
            {
                ApplicationArea = All;
                AutoFormatExpression = "Currency Code";
                AutoFormatType = 1;
                Caption = 'Final Total';
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
        }
    }

    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
        NS_JobsSetup: Record "Jobs Setup";
        NS_RetentionBalanceLCY: Decimal;
        NS_FinalTotal: Decimal;
        NS_Cust: Record Customer;
        NS_CreditLimitLCYExpendedPct: Decimal;
        NS_SalesCrMemoLine: Record "Sales Cr.Memo Line";
        NS_AmountInclVAT: Decimal;


    trigger OnOpenPage()
    begin
        //ProjectPro - start
        NS_SalesSetup.GET;
        NS_JobsSetup.GET;
        //ProjectPro - end
    end;

    trigger OnAfterGetRecord()
    begin

        NS_SalesCrMemoLine.SETRANGE("Document No.", "No.");
        IF NS_SalesCrMemoLine.FIND('-') THEN
            REPEAT
                NS_AmountInclVAT := NS_AmountInclVAT + NS_SalesCrMemoLine."Amount Including VAT";
            UNTIL NS_SalesCrMemoLine.NEXT = 0;

        //ProjectPro - start
        //IF Cust.GET("Bill-to Customer No.") THEN
        //  Cust.CALCFIELDS("Balance (LCY)")
        //ELSE
        IF NS_Cust.GET("Bill-to Customer No.") THEN BEGIN
            NS_RetentionBalanceLCY := 0;
            IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN BEGIN
                NS_Cust.SETRANGE("NS_Retention Ledger CodeFilter", NS_JobsSetup."NS_Retention Receivable Ledger");
                NS_Cust.CALCFIELDS("Balance (LCY)");
                NS_RetentionBalanceLCY := NS_Cust."Balance (LCY)";
                NS_Cust.SETRANGE("NS_Retention Ledger CodeFilter", NS_SalesSetup."NS_Normal Customer Ledger No.");
            END;
            NS_Cust.CALCFIELDS("Balance (LCY)")
        END ELSE
            //ProjectPro - end
            CLEAR(NS_Cust);

        CASE TRUE OF
            NS_Cust."Credit Limit (LCY)" = 0:
                NS_CreditLimitLCYExpendedPct := 0;
            NS_Cust."Balance (LCY)" / NS_Cust."Credit Limit (LCY)" < 0:
                NS_CreditLimitLCYExpendedPct := 0;
            NS_Cust."Balance (LCY)" / NS_Cust."Credit Limit (LCY)" > 1:
                NS_CreditLimitLCYExpendedPct := 10000;
            ELSE
                NS_CreditLimitLCYExpendedPct := ROUND(NS_Cust."Balance (LCY)" / NS_Cust."Credit Limit (LCY)" * 10000, 1);
        END;

        //ProjectPro - start
        NS_FinalTotal := NS_AmountInclVAT - "NS_Retention Amount (LCY)";
        //ProjectPro - end

    end;
}

// +---------------------------------------------------------------------------------------------
// +ProjectPro
// +  - Added field(s):
// +     - General - Group
// +         Retention (LCY)
// +         Final Total
// +     - Customer - Group
// +         Retention Balance (LCY)
// +
// +  - Added function(s):
// +
// +  - Added global variable(s):
// +     PP_SalesSetup
// +     PP_JobsSetup
// +     PP_RetentionBalanceLCY
// +     PP_FinalTotal
// +
// +  - Added global text constant(s):
// +
// +  - Modification(s):
// +     - OnOpenPage - Read setup records
// +                       PP_SalesSetup
// +                       PP_JobsSetup
// +
// +     - OnAfterGetRecord - When Sales Retention is active set values for
// +                             Retention Ledger Code Filter
// +                             PP_RetentionBalanceLCY
// +                             PP_FinalTotal
// +-----------------------------------------------------------------------------------------------
