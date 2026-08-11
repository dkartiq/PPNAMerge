pageextension 14021250 NS_PurchInvStatsExt extends "Purchase Invoice Statistics"
{
    // version NAVW111.00,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Purchase Invoice Statistics'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        modify("Vend.""Balance (LCY)""")
        {
            Visible = false;
            Enabled = false;
        }

        addafter(Vendor)
        {
            field(NS_Balance; Vend."Balance (LCY)")
            {
                Caption = 'Balance ($)';
                ToolTip = 'Specifies the balance in $ on the vendor''s account.';
                ApplicationArea = all;
                AutoFormatType = 1;
            }
        }

        addafter(AmountInclVAT)
        {
            field("NS_Retention LCY"; NS_RetentionLCY)
            {
                ApplicationArea = All;
                AutoFormatExpression = "Currency Code";
                AutoFormatType = 1;
                Caption = 'Retention ($)';
            }
            field("NS_Final Total"; NS_FinalTotal)
            {
                ApplicationArea = All;
                AutoFormatExpression = "Currency Code";
                AutoFormatType = 1;
                Caption = 'Final Total';
            }
        }
        addafter("Vend.""Balance (LCY)""")
        {
            field("NS_Retention Balance LCY"; NS_RetentionBalanceLCY)
            {
                ApplicationArea = All;
                AutoFormatType = 1;
                Caption = 'Retention Balance ($)';
            }
        }
    }

    var
        NS_PurchSetup: Record "Purchases & Payables Setup";
        NS_JobsSetup: Record "Jobs Setup";
        PurchInvLine: Record "Purch. Inv. Line";
        NS_RetentionLCY: Decimal;
        NS_RetentionBalanceLCY: Decimal;
        NS_FinalTotal: Decimal;
        Vend: Record Vendor;
        AmountInclVAT: Decimal;


    trigger OnOpenPage();
    begin
        //ProjectPro - start
        NS_PurchSetup.GET;
        NS_JobsSetup.GET;
        //ProjectPro - end
    end;

    trigger OnAfterGetRecord();
    begin

        PurchInvLine.SETRANGE("Document No.", "No.");
        IF PurchInvLine.FIND('-') THEN
            REPEAT
                AmountInclVAT := AmountInclVAT + PurchInvLine."Amount Including VAT";
            UNTIL PurchInvLine.NEXT = 0;

        //ProjectPro - start
        if "NS_Retention Percent" <> 0 then begin
            VALIDATE("NS_Retention Percent");
            VALIDATE("NS_Retention Date");
        end else
            if "NS_Retention Amount (LCY)" <> 0 then begin
                VALIDATE("NS_Retention Amount (LCY)");
                VALIDATE("NS_Retention Date");
            end;
        NS_RetentionLCY := "NS_Retention Amount (LCY)";
        //ProjectPro - end

        IF NOT Vend.GET("Pay-to Vendor No.") THEN
            CLEAR(Vend);

        //ProjectPro - start
        //Vend.CALCFIELDS("Balance (LCY)");
        NS_RetentionBalanceLCY := 0;
        if not NS_PurchSetup."NS_Purchase Retention Inactive" then begin
            Vend.SETRANGE("NS_Retention Ledger CodeFilter", NS_JobsSetup."NS_Retention Payable Ledger");
            Vend.CALCFIELDS("Balance (LCY)");
            NS_RetentionBalanceLCY := Vend."Balance (LCY)";
            Vend.SETRANGE("NS_Retention Ledger CodeFilter", NS_PurchSetup."NS_Normal Vendor Ledger No.");
        end;
        Vend.CALCFIELDS("Balance (LCY)");
        //ProjectPro - end


        //ProjectPro - start
        NS_FinalTotal := AmountInclVAT - "NS_Retention Amount (LCY)";
        //ProjectPro - end

    end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

