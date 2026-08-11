tableextension 14021232 NS_ReturnShipmentHeader extends "Return Shipment Header"
{
    // version NAVW111.00.00.20783,PPNA11.00

    fields
    {
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
            TableRelation = NS_Draw."NS_No.";
            DataClassification = CustomerContent;
        }
        field(14021105; "NS_Retention Ledger Code"; Code[20])
        {
            Caption = 'Retention Ledger Code';
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            DataClassification = CustomerContent;
        }
    }
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021100 Job No.
//   +     14021104 Draw No.
//   +     14021105 Retention Ledger Code
//   +
//   +-----------------------------------------------------------------------------------------------