pageextension 14021145 NS_PostedSalesCreditMemo extends "Posted Sales Credit Memo"
{
    // version NAVW111.00.00.24232,NAVNA11.00.00.24232,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Posted Sales Credit Memo'; //PRJ-1330.NK.1.0 25Apr2022
    Editable = false;

    layout
    {
        addafter("Work Description")
        {
            field("NS_Job No."; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the Job No.';
            }
            field("NS_Retention Document"; Rec."NS_Retention Document")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies whether this is a Retention Document';
            }
        }
        addafter("Shipping and Billing")
        {
            group("NS_Retention")
            {
                Caption = 'Retention';
                field("NS_Retention Base Amount"; Rec."NS_Retention Base Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Retention Base Amount';
                }
                field("NS_Retention Percent"; Rec."NS_Retention Percent")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Retention Percent';
                }
                field("NS_Retention Amount (LCY)"; Rec."NS_Retention Amount (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Retention Amount (LCY)';
                }
                field("NS_Retention Amount"; Rec."NS_Retention Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Retention Amount';
                }
                field("NS_Retention Date"; Rec."NS_Retention Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Retention Date';
                }
            }
        }
    }

    //PE-302.JS.1.0 30MAY24-Start
    var
        NSSalesInvHeader: Record "Sales Invoice Header";
        NSSalesCreditMemoHdr: Record "Sales Cr.Memo Header";
        NS_SalesSetup: Record "Sales & Receivables Setup";
        NSCorrectPostedSalInv: Codeunit "Correct Posted Sales Invoice";
        NSSalesHeaderApplyCud: Codeunit "NS_Sales Header Apply";


    trigger OnAfterGetCurrRecord()
    begin
        if NS_SalesSetup.get() then;
        if NS_SalesSetup."NS_AutoApplySCM After Posting" = true then begin
            if ((rec."NS_From Progress Billing No." <> '') and (rec."NS_Retention Percent" <> 0)
                and (rec."NS_AppliesToDocument No." <> '') and (rec."NS_Retention Document" = false)) then begin
                NSSalesHeaderApplyCud.NSFlowNSAppliesDocTypeAndNSAppliesDocNoInRetentionCLE(Rec);
                NSSalesHeaderApplyCud.NSApplyNormalSCMFromNormalInvoice(Rec);
                NSSalesHeaderApplyCud.NSApplyRetentionSCMFromRetentionInvoice(Rec);
            end;
        end;
    end;
    //PE-302.JS.1.0 29MAY24-end


    //   +---------------------------------------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +     PP Job No
    //   +     PP Retention Document
    //   +     PP Retention - Group
    //   +     PP Retention Base Amount
    //   +     PP Retention Percent
    //   +     PP Retention Amount (LCY)
    //   +     PP Retention Amount
    //   +     PP Retention Date
    //   +
    //   +  - Modification(s):
    //   +     - Added action list:
    //   +        Save and Send
    //   +     - Set Page Editable to No
    //   +-----------------------------------------------------------------------------------------------

}

