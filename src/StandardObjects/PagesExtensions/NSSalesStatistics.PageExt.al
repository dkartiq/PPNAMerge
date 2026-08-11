pageextension 14021226 NS_SalesStatistics extends "Sales Statistics"
{
    // version NAVW111.00,PPNA11.00

    layout
    {
        addafter(TotalAmount2)
        {
            field("NS_Retention Amount (LCY)"; Rec."NS_Retention Amount (LCY)")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the Retention Amount (LCY)';
            }
            field("NS_Final Total"; NS_FinalTotal)
            {
                ApplicationArea = All;
                Caption = 'Final Total';

                ToolTip = 'Final Total';
                Editable = false;
            }
        }
        addafter("Cust.""Balance (LCY)""")
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
        Cust: Record Customer;
        SalesSetup: Record "Sales & Receivables Setup";
        p: Codeunit "NS_Parameters for Events";
    begin
        IF Cust.GET(Rec."Bill-to Customer No.") THEN BEGIN
            NS_RetentionBalanceLCY := 0;
            SalesSetup.Get();
            IF NOT SalesSetup."NS_Sales Retention Inactive" THEN BEGIN
                NS_JobsSetup.Get();
                Cust.SETRANGE("NS_Retention Ledger CodeFilter", NS_JobsSetup."NS_Retention Receivable Ledger");
                Cust.CALCFIELDS("Balance (LCY)");
                NS_RetentionBalanceLCY := Cust."Balance (LCY)";
            END;
        end;
        NS_FinalTotal := p.NS_P160GetTotalAmount2() - "NS_Retention Amount (LCY)";
    end;
    //Unsupported feature: CodeModification on "OnOpenPage". Please convert manually.
    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.
    //Unsupported feature: PropertyChange. Please convert manually.

}

