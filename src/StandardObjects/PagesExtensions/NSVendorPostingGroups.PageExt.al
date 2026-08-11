pageextension 14021139 NS_VendorPostingGroups extends "Vendor Posting Groups"
{
    // version NAVW111.00.00.20783,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Vendor Posting Groups'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        addafter("Payables Account")
        {
            field("NS_Retention Payables Account"; Rec."NS_Retention Payables Account")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Retention Payables Account';
            }
        }
    }

    // +---------------------------------------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +     PP Retention Payable Acct
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

