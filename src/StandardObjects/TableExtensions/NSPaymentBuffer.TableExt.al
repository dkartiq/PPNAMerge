tableextension 14021205 NS_PaymentBuffer extends "Payment Buffer"
{
    // version NAVW111.00.00.24232,PPNA11.00

    fields
    {

        //Unsupported feature: Change TableRelation on ""Vendor Ledg. Entry No."(Field 3)". Please convert manually.

        field(14021100; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            Description = 'ProjectPro';
            TableRelation = Job;
            DataClassification = CustomerContent;
        }
        field(14021104; "NS_Draw No."; Code[25])
        {
            Caption = 'Draw No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021300; "NS_Subcontract No."; Code[20])
        {
            Caption = 'Subcontract No.';
            Description = 'ProjectPro';
            TableRelation = NS_Subcontract;
            DataClassification = CustomerContent;
        }
        field(14021301; "NS_Retention Ledger Code"; Code[20])
        {
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            Caption = 'Retention Ledger Code';
            DataClassification = CustomerContent;
        }

    }
}

