pageextension 14021259 NS_PurchPaySetup extends "Purchases & Payables Setup"
{
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,NAVMX11.00.00.23572,PPNA11.00

    layout
    {
        addafter("Ignore Updated Addresses")
        {
            field("NS Purchase Retention Inactive"; Rec."NS_Purchase Retention Inactive")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether Purchase Retention is Inactive.';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    SetNormalVendorLedgerNoEnable;
                    //ProjectPro - end
                end;
            }
            field("NS Normal Vendor Ledger No."; Rec."NS_Normal Vendor Ledger No.")
            {
                ApplicationArea = All;
                Enabled = NormalVendorLedgerNoEnable;
                ToolTip = 'Specifies the Normal Vendor Ledger No.';
            }
        }
    }

    var
        NormalVendorLedgerNoEnable: Boolean;

    trigger OnAfterGetRecord();
    begin
        //ProjectPro - start
        SetNormalVendorLedgerNoEnable;
        //ProjectPro - end  
    end;

    procedure SetNormalVendorLedgerNoEnable();
    begin
        //ProjectPro - start
        if "NS_Purchase Retention Inactive" then begin
            NormalVendorLedgerNoEnable := false;
            "NS_Normal Vendor Ledger No." := '';
        end else
            NormalVendorLedgerNoEnable := true;
        //ProjectPro - end
    end;

    //   +------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +     "PP Purchase Retention Inactive"
    //   +     "PP Normal Vendor Ledger No."
    //   +
    //   +  - Added function(s):
    //   +     SetNormalVendorLedgerNoEnable() - function to control whether or not Normal Vendor Ledger No. is enabled
    //   +
    //   +  - Added global variable(s):
    //   +     NormalVendorLedgerNoEnable
    //   +
    //   +  - Modification(s):
    //   +     - PP Purchase Retention Inactive - OnValidate(): Call SetNormalVendorLedgerNoEnable();
    //   +     - OnAfterGetRecord: call SetNormalVendorLedgerNoEnable()
    //   +     - Removed 'Subcontract Payment UOM Code' and transfreed to Jobs Setup
    //   +------------------------------------------------------------
}

