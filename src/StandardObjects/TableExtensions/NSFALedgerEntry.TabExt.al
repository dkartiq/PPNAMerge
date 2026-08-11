tableextension 14021245 NS_FAledger extends "FA Ledger Entry"
{
    //PRJ-490.AM.1.0 Added New Fields.
    fields
    {
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
        field(14021100; "NS_FA Res. No."; Code[20])
        {
            Caption = 'FA Res. No.';
            Description = 'PRJ-490';
            DataClassification = CustomerContent;
        }
    }

    var
        myInt: Integer;
}