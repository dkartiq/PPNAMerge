tableextension 14021136 NS_ResLedgerEntry extends "Res. Ledger Entry"
{
    // version NAVW111.00.00.20783,PPNA11.00

    fields
    {
        field(14021110; "NS_Work Units"; Decimal)
        {
            Caption = 'Work Units';
            DecimalPlaces = 2 : 2;
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
        }
        field(14021111; "NS_Work Unit of Measure"; Code[10])
        {
            Caption = 'Work Unit of Measure';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            TableRelation = "Unit of Measure";
        }
        field(14021112; "NS_Retention Ledger Code"; Code[20])
        {
            Caption = 'Retention Ledger Code';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
        }
    }
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +      14021110 Work Units
//   +      14021111 Work Unit of Measure
//   +      14021112 Retention Ledger Code
//   +
//   +  - Added function(s):
//   +
//   +  - Added global variable(s):
//   +
//   +  - Added global text constant(s):
//   +
//   +  - Modification(s):
//   +
//   +-----------------------------------------------------------------------------------------------