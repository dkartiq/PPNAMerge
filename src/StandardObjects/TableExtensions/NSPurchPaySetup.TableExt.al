tableextension 14021203 NS_PurchPaySetup extends "Purchases & Payables Setup"
{
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,PPNA11.00

    fields
    {
        field(14021150; "NS_Normal Vendor Ledger No."; Code[20])
        {
            Caption = 'Normal Vendor Ledger No.';
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            DataClassification = CustomerContent;
        }
        field(14021151; "NS_Purchase Retention Inactive"; Boolean)
        {
            Caption = 'Purchase Retention Inactive';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
    }
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021150 Normal Vendor Ledger No.
//   +     14021151 Purchase Retention Inactive
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
