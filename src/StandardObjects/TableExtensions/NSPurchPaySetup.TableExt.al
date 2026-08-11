tableextension 14021203 NS_PurchPaySetup extends "Purchases & Payables Setup"
{
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,PPNA11.00
    //PRJ-1416.JS.1.0 24MAY2022 | Add one field

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
        //PRJ-1416.JS.1.0 24MAY2022
        field(14021152; "NS_Block Line Dele. Subcon PO"; Boolean)
        {
            Caption = 'Block Line Dele. Subcon PO';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        //PRJ-1696.GK.1.0 15Dec2022 start
        field(14021153; "NS_Enab. Rcpt Int. Ent. in JLE"; Boolean)
        {
            Caption = 'Enable Rcpt Interim Entry in JLE.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            //PE-36.GK.1.0 start
            trigger OnValidate()
            var
                ConfirmLbl: Label 'Existing Open Purchase Receipt shall not have Job Ledger Entry as cost, these entries shall be handled with care while considering for Purchase Invoice.';
            begin
                if xRec."NS_Enab. Rcpt Int. Ent. in JLE" = false then begin
                    if not Confirm(ConfirmLbl, false) then
                        "NS_Enab. Rcpt Int. Ent. in JLE" := false
                    else
                        "NS_Enab. Rcpt Int. Ent. in JLE" := true;
                end;
            end;
            //PE-36.GK.1.0 end
        }
        //PRJ-1696.GK.1.0 15Dec2022 end

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
