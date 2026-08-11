pageextension 14021151 NS_PostedPurchaseCreditMemo extends "Posted Purchase Credit Memo"
{
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,NAVMX11.00.00.23572,PPNA11.00
    //PRJ-1418.NK.1.0 08Jun2022 | Added Property
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Posted Purchase Credit Memo'; //PRJ-1330.NK.1.0 25Apr2022
   //Editable = false; //PRJ-1418.NK.1.0 08Jun2022 Block

    layout
    {
        addafter("No. Printed")
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
                Editable = false; //PRJ-1418.NK.1.0 08Jun2022
            }
            field("NS_Draw No."; Rec."NS_Draw No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Draw No.';
            }
        }

        addbefore(IncomingDocAttachFactBox)
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
    //   +
    //   +     PP Job No.
    //   +     PP Retention Document
    //   +     PP Subcontract No.
    //   +     PP Draw No.
    //   +     PP Retention - Group
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

