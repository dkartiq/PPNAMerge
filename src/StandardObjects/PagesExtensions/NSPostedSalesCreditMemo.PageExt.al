pageextension 14021145 NS_PostedSalesCreditMemo extends "Posted Sales Credit Memo"
{
    // version NAVW111.00.00.24232,NAVNA11.00.00.24232,PPNA11.00

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

