pageextension 14021149 NS_PostedPurchaseInvoice extends "Posted Purchase Invoice"
{
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,NAVMX11.00.00.23572,PPNA11.00
    //PRJ-889.GK.1.0 13Sep2021 |Add one field

    Editable = false;
    layout
    {
        addafter(Corrective)
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
            field("NS_Subcontract No."; Rec."NS_Subcontract No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Subcontract No.';
            }
            field("NS_Draw No."; Rec."NS_Draw No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Draw No.';
            }
            //PRJ-889.GK.1.0 13Sep2021 start
            field("NS_Progress Payment Enable"; Rec."NS_Progress Payment Enable")
            {
                ToolTip = 'Specifies the value of the Progress Payment Enable field';
                ApplicationArea = All;
            }

            //PRJ-889.GK.1.0 13Sep2021 end
        }
        addafter("Shipping and Payment")
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
    //   +     PP Job No.
    //   +     PP Retention Document
    //   +     PP Subcontract No.
    //   +     PP Draw No.
    //   +     Retention group
    //   +       PP Retention Base Amount
    //   +       PP Retention Percent
    //   +       PP Retention Amount (LCY)
    //   +       PP Retention Amount
    //   +       PP Retention Date
    //   +
    //   +  - Modification(s):
    //   +     - Set page's Editable = No
    //   +-----------------------------------------------------------------------------------------------

}

