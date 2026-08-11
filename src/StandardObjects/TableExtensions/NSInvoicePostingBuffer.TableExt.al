/// <summary>
/// TableExtension NS_InvPostingBuffer (ID 14021374) extends Record Invoice Posting Buffer.
/// </summary>
tableextension 14021374 NS_InvPostingBuffer extends "Invoice Posting Buffer"
{
    // version NAVW111.00.00.23019,NAVNA11.00.00.23019,PPNA11.00
    //PRJ-490.AM.1.0 Added New Fields
    //PE-129.AS.1.0 Created New Table by taking reference of object tableextension 14021112 NS_InvPostBuffer going to Obselete

    fields
    {

        field(14021300; "NS_Subcontract No."; Code[20])
        {
            Caption = 'Subcontract No.';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            TableRelation = NS_Subcontract;
        }
        field(14021301; "Ns_Retention Ledger Code"; Code[20])
        {
            Caption = 'Retention Ledger Code';
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            DataClassification = CustomerContent;
        }
        field(14021100; "NS_Job Task No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Job Task No.';
            Description = 'ProjectPro';
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

    //SPLN1.00
    // In C/AL - JobTask No. and PK 

    /*+---------------------------------------------------------------------------------------------
    +ProjectPro
    +  - Added field(s):
    +     14021100 JobTask No.
    +     14021300 Subcontract No.
    +     14021301 Retention Ledger Code
    +
    +  - Added function(s):
    +
    +  - Added global variable(s):
    +
    +  - Added global text constant(s):
    +
    +  - Modification(s):
    +     - Added JobTask No. to master key after Job No.
    +-----------------------------------------------------------------------------------------------
    */
}
