tableextension 14021137 NS_ResJnlLine extends "Res. Journal Line"
{
    // version NAVW111.00.00.23019,PPNA11.00

    fields
    {
        field(14021110; "NS_Work Units"; Decimal)
        {
            Caption = 'Work Units';
            DecimalPlaces = 2 : 2;
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021111; "NS_Work Unit of Measure"; Code[10])
        {
            Caption = 'Work Unit of Measure';
            Description = 'ProjectPro';
            TableRelation = "Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(14021112; "NS_Retention Ledger Code"; Code[20])
        {
            Caption = 'Retention Ledger Code';
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            DataClassification = CustomerContent;
        }
        field(14021300; "NS_Subcontract No."; Code[20])
        {
            Caption = 'Subcontract No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
    }
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021110 Work Units
//   +     14021111 Work Unit of Measure
//   +     14021112 Retention Ledger Code
//   +     14021300 Subcontract No.
//   +
//   +  - Added function(s):
//   +
//   +  - Added global variable(s):
//   +
//   +  - Added global text constant(s):
//   +
//   +  - Modification(s):
//   +     - CopyFromJobJnlLine()
//   +         Retention Ledger Code
//   +-----------------------------------------------------------------------------------------------