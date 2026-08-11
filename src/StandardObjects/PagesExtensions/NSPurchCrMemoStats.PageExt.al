pageextension 14021251 NS_PurchCrMemoStatsExt extends "Purch. Credit Memo Statistics"
{
    // version NAVW111.00,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Purch. Credit Memo Statistics'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {

        modify(VATAmount)
        {
            Visible = false;
            Enabled = false;
        }

        addafter(VATAmount)
        {
            field(NS_VATAmount; NS_VATAmount)
            {
                Caption = 'Tax Amount';
                ToolTip = 'Specifies the total tax amount that has been calculated for all the lines in the purchase document.';
                ApplicationArea = "#Basic,#Suite";
                AutoFormatType = 1;
                AutoFormatExpression = "Currency Code";
                CaptionClass = Format(NS_VATAmountText);
            }
        }

        modify("Vend.""Balance (LCY)""")
        {
            Visible = false;
            Enabled = false;
        }

        addafter("Vend.""Balance (LCY)""")
        {
            field(NS_Vend_BalanceLCY; NS_Vend."Balance (LCY)")
            {
                Caption = 'Balance ($)';
                ToolTip = 'Specifies the balance in $ on the vendor''s account.';
                ApplicationArea = "#Basic,#Suite";
                AutoFormatType = 1;
            }
        }

        addafter(AmountInclVAT)
        {
            field("NS Retention LCY"; NS_RetentionLCY)
            {
                ApplicationArea = All;
                AutoFormatExpression = "Currency Code";
                AutoFormatType = 1;
                Caption = 'Retention Amount';
            }
            field("NS Final Total"; NS_FinalTotal)
            {
                ApplicationArea = All;
                AutoFormatExpression = "Currency Code";
                AutoFormatType = 1;
                Caption = 'Final Total';
            }
        }
        addafter("Vend.""Balance (LCY)""")
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
        NS_JobsSetup: Record "Jobs Setup";
        NS_PurchSetup: Record "Purchases & Payables Setup";
        NS_RetentionLCY: Decimal;
        NS_RetentionBalanceLCY: Decimal;
        NS_FinalTotal: Decimal;
        NS_PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        NS_VendAmount: Decimal;
        NS_AmountInclVAT: Decimal;
        NS_VATAmount: Decimal;
        NS_VATPercentage: Decimal;
        NS_Vend: Record Vendor;
        NS_VATAmountText: text;
        Text000: Label 'Tax Amount';
        Text001: Label '%1% Tax';


    trigger OnOpenPage()
    begin
        //ProjectPro - start
        NS_JobsSetup.GET;
        NS_PurchSetup.GET;
        //ProjectPro - end
    end;


    trigger OnAfterGetRecord()
    begin
        NS_PurchCrMemoLine.SETRANGE("Document No.", "No.");

        IF NS_PurchCrMemoLine.FIND('-') THEN
            REPEAT
                NS_VendAmount := NS_VendAmount + NS_PurchCrMemoLine.Amount;
                NS_AmountInclVAT := NS_AmountInclVAT + NS_PurchCrMemoLine."Amount Including VAT";

                IF NS_PurchCrMemoLine."VAT %" <> NS_VATPercentage THEN
                    IF NS_VATPercentage = 0 THEN
                        NS_VATPercentage := NS_PurchCrMemoLine."VAT %"
                    ELSE
                        NS_VATPercentage := -1;
            UNTIL NS_PurchCrMemoLine.NEXT = 0;

        //ProjectPro - start
        IF NS_JobsSetup."NS_Calc Payable Ret Before Tax" THEN
            NS_VATAmount := NS_VATAmount + "NS_Retention Amount (LCY)";
        //ProjectPro - end
        NS_VATAmount := NS_AmountInclVAT - NS_VendAmount;


        IF NS_VATPercentage <= 0 THEN
            NS_VATAmountText := Text000
        ELSE
            NS_VATAmountText := STRSUBSTNO(Text001, NS_VATPercentage);

        //ProjectPro - start
        IF "NS_Retention Percent" <> 0 THEN BEGIN
            VALIDATE("NS_Retention Percent");
            VALIDATE("NS_Retention Date");
        END ELSE
            IF "NS_Retention Amount (LCY)" <> 0 THEN BEGIN
                VALIDATE("NS_Retention Amount (LCY)");
                VALIDATE("NS_Retention Date");
            END;
        NS_RetentionLCY := "NS_Retention Amount (LCY)";
        //ProjectPro - end


        IF NOT NS_Vend.GET("Pay-to Vendor No.") THEN
            CLEAR(NS_Vend);
        //ProjectPro - start
        //Vend.CALCFIELDS("Balance (LCY)");
        NS_RetentionBalanceLCY := 0;
        IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN BEGIN
            NS_Vend.SETRANGE("NS_Retention Ledger CodeFilter", NS_JobsSetup."NS_Retention Payable Ledger");
            NS_Vend.CALCFIELDS("Balance (LCY)");
            NS_RetentionBalanceLCY := NS_Vend."Balance (LCY)";
            NS_Vend.SETRANGE("NS_Retention Ledger CodeFilter", NS_PurchSetup."NS_Normal Vendor Ledger No.");
        END;
        //ProjectPro - end
        NS_Vend.CALCFIELDS("Balance (LCY)");

        //ProjectPro - start
        NS_FinalTotal := NS_AmountInclVAT - "NS_Retention Amount (LCY)";
        //ProjectPro - end
    end;
}

