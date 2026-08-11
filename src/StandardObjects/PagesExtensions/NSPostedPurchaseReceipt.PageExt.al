pageextension 14021147 NS_PostedPurchaseReceipt extends "Posted Purchase Receipt"
{
    // version NAVW111.00.00.19846,NAVNA11.00.00.19846,PPNA11.00

    Editable = false;

    layout
    {
        addafter("Responsibility Center")
        {
            field("NS Job No."; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the Job No.';
            }
            field("NS_Subcontract No."; Rec."NS_Subcontract No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Subcontract No.';
            }
        }
    }

    //   +---------------------------------------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +     PP Job No.
    //   +     PP Subcontract No.
    //   +
    //   +  - Added function(s):
    //   +
    //   +  - Added global variable(s):
    //   +
    //   +  - Added global text constant(s):
    //   +
    //   +  - Modification(s):
    //   +     - Set page's Editable = No
    //   +-----------------------------------------------------------------------------------------------

}

