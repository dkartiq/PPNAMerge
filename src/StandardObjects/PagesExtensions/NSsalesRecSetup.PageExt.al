pageextension 14021158 NS_SalesRecSetup extends "Sales & Receivables Setup"
{
    // version NAVW111.00.00.23572,PPNA11.00
    //PRJ-931.JS.1.0�23Sep2021 | Add one field

    layout
    {
        addafter("Ignore Updated Addresses")
        {
            field("NS Sales Retention Inactive"; Rec."NS_Sales Retention Inactive")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether Sales Retention is Inactive.';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    if "NS_Sales Retention Inactive" then begin
                        NS_NormalCustomerLedgerNoEnable := false;
                        "NS_Normal Customer Ledger No." := '';
                    end else
                        NS_NormalCustomerLedgerNoEnable := true;
                    //ProjectPro - end
                end;
            }
            field("NS Normal Customer Ledger No."; Rec."NS_Normal Customer Ledger No.")
            {
                ApplicationArea = All;
                Caption = 'Normal Ledger No.';

                ToolTip = 'Normal Ledger No.';
                Enabled = NS_NormalCustomerLedgerNoEnable;
            }

            field("NS_Disable Sales Price"; Rec."NS_Disable Sales Price")    //PRJ-931.JS.1.0�23Sep2021
            {
                caption = 'Disable Sales Price';
                ToolTip = 'Use to disable sales price functionality on sales line';
                ApplicationArea = All;
            }
        }
    }

    var
        NS_NormalCustomerLedgerNoEnable: Boolean;

    trigger OnAfterGetRecord();
    begin
        //ProjectPro - start
        if not "NS_Sales Retention Inactive" then
            NS_NormalCustomerLedgerNoEnable := true
        else
            NS_NormalCustomerLedgerNoEnable := false;
        //ProjectPro - end     
    end;

    //   +------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +     "PP Sales Retention Inactive"
    //   +     "PP Normal Customer Ledger No."
    //   +
    //   +  - Added global variable(s):
    //   +     PP_NormalCustomerLedgerNoEnable
    //   +
    //   +  - Modification(s):
    //   +     - OnAfterGetRecord: initialize variable to control whether or not Normal Customer Ledger No is enabled
    //   +     - PP Sales Retention Inactive - OnValidate(): initialize variable to control whether or not Normal Customer Ledger No is enabled
    //   +------------------------------------------------------------
}

