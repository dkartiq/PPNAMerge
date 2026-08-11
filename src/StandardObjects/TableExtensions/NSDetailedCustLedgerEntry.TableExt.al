tableextension 14021206 NS_DetailedCustLedgerEntry extends "Detailed Cust. Ledg. Entry"
{
    // version NAVW111.00.00.20783,PPNA11.00

    fields
    {
        field(14021100; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021301; "NS_Retention Ledger Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Retention Ledger Code';
            Description = 'ProjectPro';
        }
    }
    keys
    {
        //Unsupported feature: Deletion on ""Cust. Ledger Entry No.","Entry Type","Posting Date"(Key)". Please convert manually.
    }

    var
        NS_SalesSetup: Record "Sales & Receivables Setup";

    [Scope('Cloud')]
    procedure NS_GetUnrealizedGainLossAmount(EntryNo: Integer; RetentionLedgerCode: Code[20]): Decimal
    begin
        SETCURRENTKEY("Cust. Ledger Entry No.", "Entry Type");
        SETRANGE("Cust. Ledger Entry No.", EntryNo);
        SETRANGE("Entry Type", "Entry Type"::"Unrealized Loss", "Entry Type"::"Unrealized Gain");
        //ProjectPro - start done
        NS_SalesSetup.GET;
        IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
            SETRANGE("NS_Retention Ledger Code", RetentionLedgerCode);
        //ProjectPro - end

        CALCSUMS("Amount (LCY)");
        EXIT("Amount (LCY)");
    end;

}

