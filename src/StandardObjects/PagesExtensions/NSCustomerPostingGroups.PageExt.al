pageextension 14021138 NS_CustomerPostingGroups extends "Customer Posting Groups"
{
    // version NAVW111.00.00.20783,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Customer Posting Groups'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        addafter("Receivables Account")
        {
            field("NS_Retention Receivables Acct"; Rec.NS_RetentionReceivablesAccount)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Retention Receivables Account';
            }
        }
    }

    //   +---------------------------------------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +     PP Retention Receivables Acct
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

