tableextension 14021231 NS_ServiceLedgerEntry extends "Service Ledger Entry"
{
    // version NAVW111.00.00.20783,PPNA11.00

    //PPNA16.0 JobTask No. field length is 35 in PP but it cannot be possible in AL

    fields
    {
        field(14021300; "NS_Subcontract No."; Code[20])
        {
            Caption = 'Subcontract No.';
            Description = 'ProjectPro';
            TableRelation = "NS_Subcontract Lines"."NS_Subcontract No." WHERE("NS_Job No." = FIELD("Job No."));
            DataClassification = CustomerContent;
        }
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
//   +     14021300 Subcontract No.
//   +     14021301 Retention Ledger Code
//   +
//   +  - Modification(s):
//   +     - Fields:
//   +         Job Task No. - Set field length 35 characters
//   +-----------------------------------------------------------------------------------------------