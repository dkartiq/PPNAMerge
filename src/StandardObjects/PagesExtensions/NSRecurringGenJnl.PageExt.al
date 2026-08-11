pageextension 14021239 NS_RecurringGenJnlExt extends "Recurring General Journal"
{
    // version NAVW111.00.00.24232,NAVNA11.00.00.24232,PPNA11.00

    layout
    {
        addafter("VAT Amount")
        {
            field("NS_Retention Ledger Code"; Rec."NS_Retention Ledger Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Retention Ledger Code';
            }
        }
    }

    //   +---------------------------------------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +     Retention Ledger Code
    //   +
    //   +  - Added function(s):
    //   +
    //   +  - Added global variable(s):
    //   +
    //   +  - Added global text constant(s):
    //   +
    //   +  - Modification(s):
    //   +-----------------------------------------------------------------------------------------------

}

