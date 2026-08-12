pageextension 14021158 NS_SalesRecSetup extends "Sales & Receivables Setup"
{
    //ContextSensitiveHelpPage = 'user-guide/';   //PRJ-1556.JS.1.0 24AUG2022
    // version NAVW111.00.00.23572,PPNA11.00
    //PRJ-931.JS.1.0�23Sep2021 | Add one field
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    //PRJ-1579.RM.1.0 22Aug2022 | Added some code
    //PRJ-1624.NK.1.0 21Sep2022 | Add one Field
    Caption = 'Sales & Receivables Setup'; //PRJ-1330.NK.1.0 25Apr2022
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
                ToolTip = 'Customer Retention Ledger code for standard Accounts Receivable transactions. Recommend "Normal" or "Main"'; //PRJ-1579.RM.1.0 
                // ToolTip = 'Normal Ledger No.'; //PRJ-1579.RM.1.0 commented
                Enabled = NS_NormalCustomerLedgerNoEnable;
            }

            field("NS_Disable Sales Price"; Rec."NS_Disable Sales Price")    //PRJ-931.JS.1.0�23Sep2021
            {
                caption = 'Disable Sales Price';
                ToolTip = 'Use to disable sales price functionality on sales line';
                ApplicationArea = All;
            }
            //PRJ-1543.GK.1.0 28July2022 start
            field("NS_Allow Description excl. Nos."; Rec."NS_Allow Description excl Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Allow Description excluding Nos. field.';
            }
            //PRJ-1543.GK.1.0 28July2022 end
            //PRJ-1624.NK.1.0 21Sep2022 Start
            field("NS_Allow diff Ret. On PB Line"; Rec."NS_Allow diff Ret. On PB Line")
            {
                ApplicationArea = all;
                ToolTip = 'This field is use to allow for different Retention % on Progress Billings & Direct Sales Invoice';
            }
            //PRJ-1624.NK.1.0 21Sep2022 End
            //PE-302.JS.1.0 30MAY2024-Start
            field("NS_AutoApplySCM After Posting"; Rec."NS_AutoApplySCM After Posting")
            {
                Caption = 'Auto Apply Sales Credit Memo After Posting';
                ApplicationArea = All;
                ToolTip = 'Enable to Allow Auto Apply Sales Credit Memo After Posting if ProjectPro using with another (ISV)';
            }
            //PE-302.JS.1.0 30MAY2024-end
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

