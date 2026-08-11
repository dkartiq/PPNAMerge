tableextension 14021207 NS_DetailedvendLedgerEntry extends "Detailed Vendor Ledg. Entry"
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
        field(14021300; "NS_Subcontract No."; Code[20])
        {
            Caption = 'Subcontract No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021301; "NS_Retention Ledger Code"; Code[20])
        {
            Caption = 'Retention Ledger Code';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021416; "NS_FA Job No."; Code[20])
        {
            Caption = 'FA Job No.';
            Description = 'PRJ-490.AM.1.0';
            DataClassification = CustomerContent;

        }
        field(14021417; "NS_FA Job Task No."; Code[20])
        {
            Caption = ' FA Job Task No.';
            Description = 'PRJ-490.AM.1.0';
            DataClassification = CustomerContent;

        }
        field(14021418; "NS_FA Segment Code"; Code[20])
        {
            Caption = 'FA Segment Code';
            Description = 'PRJ-490.AM.1.0';
            DataClassification = CustomerContent;

        }


    }
    keys
    {
        //Unsupported feature: Deletion on ""Vendor Ledger Entry No.","Entry Type","Posting Date"(Key)". Please convert manually.

        key(Key5; "NS_Subcontract No.")
        {
        }
    }

    var
        NS_PurchSetup: Record "Purchases & Payables Setup";

    [Scope('Cloud')]
    procedure NS_GetUnrealizedGainLossAmount(EntryNo: Integer; RetentionLedgerCode: Code[20]): Decimal
    begin
        SETCURRENTKEY("Vendor Ledger Entry No.", "Entry Type");
        SETRANGE("Vendor Ledger Entry No.", EntryNo);
        SETRANGE("Entry Type", "Entry Type"::"Unrealized Loss", "Entry Type"::"Unrealized Gain");
        //ProjectPro - start 
        NS_PurchSetup.GET;
        IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN
            SETRANGE("NS_Retention Ledger Code", RetentionLedgerCode);
        //ProjectPro - end
        CALCSUMS("Amount (LCY)");
        EXIT("Amount (LCY)");
    end;

}

