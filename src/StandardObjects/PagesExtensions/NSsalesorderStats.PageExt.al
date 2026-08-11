pageextension 14021252 NS_SalesOrderStats extends "Sales Order Statistics"
{
    // version NAVW111.00,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Sales Order Statistics'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        addafter("TotalAmount2[1]")
        {
            field("NS_Retention Amount LCY"; NS_RetentionAmountLCY)
            {
                ApplicationArea = All;
                AutoFormatType = 1;
                Caption = 'Retention Amount ($)';

                ToolTip = 'Retention Amount ($)';
                Editable = false;
            }
            field("NS_Final Total"; NS_FinalTotal)
            {
                ApplicationArea = All;
                AutoFormatType = 1;
                Caption = 'Final Total';

                ToolTip = 'Final Total';
                Editable = false;
            }
        }
        addafter("TotalExclVAT_Invoicing")
        {
            field("NS_Retention Amount-LCY"; NS_RetentionAmountLCY)
            {
                ApplicationArea = All;
                AutoFormatType = 1;
                Caption = 'Retention Amount ($)';

                ToolTip = 'Retention Amount ($)';
                Editable = false;
            }
            //PRJCTPR-212.PS.1.0 20Oct2023 Start
            field("NS_Final Total Inv"; NS_FinalTotal)
            {
                ApplicationArea = All;
                AutoFormatType = 1;
                Caption = 'Final Total';
                ToolTip = 'Final Total';
                Editable = false;
            }
            //PRJCTPR-212.PS.1.0 20Oct2023 End
        }
        addafter("TotalAmount2[3]")
        {
            field("NS_Retention Amount_LCY"; NS_RetentionAmountLCY)
            {
                ApplicationArea = All;
                AutoFormatType = 1;
                Caption = 'Retention Amount ($)';
                Editable = false;
            }
        }
        addafter("Cust.""Balance (LCY)""")
        {
            field("NS_Retention Balance LCY"; NS_RetentionBalanceLCY)
            {
                ApplicationArea = All;
                AutoFormatType = 1;
                Caption = 'Retention Balance ($)';
                Editable = false;
            }
        }
    }

    var
        NS_Cust: Record Customer;
        NS_SalesSetup: Record "Sales & Receivables Setup";


        NS_JobsSetup: Record "Jobs Setup";
        NS_RetentionAmountLCY: Decimal;
        NS_RetentionBalanceLCY: Decimal;
        NS_FinalTotal: Decimal;
        NS_CreditLimitLCYExpendedPct: Decimal;
    //NS_TotalAmount2: ARRAY[3] OF Decimal;


    trigger OnOpenPage()
    begin
        NS_SalesSetup.GET;

        //ProjectPro - start
        NS_JobsSetup.GET;
        //ProjectPro - end
    end;

    trigger OnAfterGetRecord()
    begin
        NS_RefreshOnAfterGetRecord();
    end;


    procedure NS_RefreshOnAfterGetRecord()
    begin
        //ProjectPro - start
        //IF Cust.GET("Bill-to Customer No.") THEN
        //  Cust.CALCFIELDS("Balance (LCY)");
        //ELSE
        IF NS_Cust.GET("Bill-to Customer No.") THEN BEGIN
            IF "NS_Retention Document" THEN BEGIN
                "NS_Retention Percent" := 0;
                "NS_Retention Amount (LCY)" := 0;
                "NS_Retention Amount" := 0;
                "NS_Retention Date" := 0D;
            END ELSE
                IF "NS_Retention Percent" <> 0 THEN BEGIN
                    VALIDATE("NS_Retention Percent");
                    VALIDATE("NS_Retention Date");
                END;
            NS_RetentionAmountLCY := "NS_Retention Amount (LCY)";
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


        //ProjectPro - start
        //NS_FinalTotal := GetTotalAmount2 - "Retention Amount (LCY)";
        //ProjectPro - end

        END;
    end;
}

