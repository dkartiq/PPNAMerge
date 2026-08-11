tableextension 14021150 NS_IssuedReminderHdr extends "Issued Reminder Header"
{
    // version NAVW111.00.00.20783,PPNA11.00

    fields
    {
        field(14021162; "NS_Retention Ledger Code"; Code[20])
        {
            Caption = 'Retention Ledger Code';
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            DataClassification = CustomerContent;
        }
    }
    var
        ff: page Navigate;
    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

