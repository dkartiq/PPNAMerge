tableextension 14021229 NS_ValueEntry extends "Value Entry"
{
    // version NAVW111.00.00.22292,NAVNA11.00.00.22292,PPNA11.00

    fields
    {
        field(14021301; "NS_Retention Ledger Code"; Code[20])
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
//   +     14021301 Retention Ledger Code
//   +
//   +  - Modification(s):
//   +     - Modify Key:
//   +         Capacity Ledger Entry No.,Entry Type - Set MaintainSIFTIndex=No
//   +-----------------------------------------------------------------------------------------------