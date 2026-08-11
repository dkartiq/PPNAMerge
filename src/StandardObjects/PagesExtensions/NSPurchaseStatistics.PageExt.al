pageextension 14021227 NS_PurchaseStatistics extends "Purchase Statistics"
{
    // version NAVW111.00,PPNA11.00

    layout
    {
        addafter(TotalAmount2)
        {
            field("NS Retention Amount (LCY)"; Rec."NS_Retention Amount (LCY)")
            {
                ApplicationArea = All;
                AutoFormatType = 1;
                Editable = false;
                ToolTip = 'Specifies the Retention Amount (LCY)';
            }
            field("NS Final Total"; NS_FinalTotal)
            {
                ApplicationArea = All;
                AutoFormatType = 1;
                Caption = 'Final Total';

                ToolTip = 'Final Total';
                Editable = false;
            }
        }
        addafter("Vend.""Balance (LCY)""")
        {
            field("NS Retention Balance LCY"; NS_RetentionBalanceLCY)
            {
                ApplicationArea = All;
                AutoFormatType = 1;
                Caption = 'Retention Balance ($)';

                ToolTip = 'Retention Balance ($)';
                Editable = false;
            }
        }
    }

    var
        NS_JobsSetup: Record "Jobs Setup";
        NS_RetentionBalanceLCY: Decimal;
        NS_FinalTotal: Decimal;

    trigger OnAfterGetRecord();
    var
        p: Codeunit "NS_Parameters for Events";
        Vend: Record Vendor;
        PurchSetup: Record "Purchases & Payables Setup";
    begin
        IF Vend.GET("Pay-to Vendor No.") THEN BEGIN
            NS_RetentionBalanceLCY := 0;
            PurchSetup.Get();
            IF NOT PurchSetup."NS_Purchase Retention Inactive" THEN BEGIN
                Vend.SETRANGE("NS_Retention Ledger CodeFilter", NS_JobsSetup."NS_Retention Payable Ledger");
                Vend.CALCFIELDS("Balance (LCY)");
                NS_RetentionBalanceLCY := Vend."Balance (LCY)";
            END;
        end;
        NS_FinalTotal := p.NS_P161GetTotalAmount2() - "NS_Retention Amount (LCY)";
    end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.
    //Unsupported feature: PropertyChange. Please convert manually.
}

