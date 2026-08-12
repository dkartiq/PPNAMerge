pageextension 14021259 NS_PurchPaySetup extends "Purchases & Payables Setup"
{
    //ContextSensitiveHelpPage = 'user-guide/';   //PRJ-1556.JS.1.0 24AUG2022
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,NAVMX11.00.00.23572,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    //PRJ-1416.JS.1.0 24MAY2022 | Add one field
    //PRJ-1579.RM.1.0 22Aug2022 | Added some code
    Caption = 'Purchases & Payables Setup'; //PRJ-1330.NK.1.0 25Apr2022
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
                // ToolTip = 'Specifies the Normal Vendor Ledger No.'; //PRJ-1579.RM.1.0 commented
                ToolTip = 'Vendor Retention Ledger code for standard Accounts Payable transactions. Recommend "Normal" or "Main"'; //PRJ-1579.RM.1.0 
            }
        }
        //PRJ-1416.JS.1.0 24MAY2022 - start
        addafter("Document Default Line Type")
        {
            field("NS_Block Line Dele. Subcon PO"; Rec."NS_Block Line Dele. Subcon PO")
            {
                ToolTip = 'Make this True, if there is no Subcontract PO link on the lines which would disable the deletion of PO lines.';
                ApplicationArea = All;
            }
        }
        //PRJ-1416.JS.1.0 24MAY2022 - end
        //PRJ-1696.GK.1.0 15Dec2022 start
        addafter("NS_Block Line Dele. Subcon PO")
        {
            field("NS_Enab. Rcpt Int. Ent. in JLE"; Rec."NS_Enab. Rcpt Int. Ent. in JLE")
            {
                ApplicationArea = All;
                // ToolTip = 'When Enabled, Interim Entry is created in "Job Ledger Entry" while posting Purchase Receipt against Purchase Order with Job for Type "Item" only.       Note: When enable, existing Open Purchase Receipt do not have �Job Ledger Entry�. Job Ledger Entries shall be created only for upcoming Purchase Receipt.'; //PE-36.GK.1.0 //PE-45.RM.1.0 14Feb2023 commented
                ToolTip = 'When Enabled, Interim Entry is created in "Job Ledger Entry" while posting Purchase Receipt against Purchase Order with Job for Type "Item" only,'; //PE-45.RM.1.0 14Feb2023
            }
        }
        //PRJ-1696.GK.1.0 15Dec2022 end

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

