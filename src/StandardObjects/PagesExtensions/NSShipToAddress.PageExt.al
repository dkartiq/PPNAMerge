pageextension 14021242 NS_ShipToAddress extends "Ship-to Address"
{
    // version NAVW111.00.00.19846,NAVNA11.00.00.19846,PPNA11.00

    layout
    {
        addafter(General)
        {
            group("NS_Job Quoting")
            {
                Caption = 'Job Quoting';
                field("NS_Table ID"; Rec."NS_Table ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the "Table ID';
                }
                field("NS_Address Type"; Rec."NS_Address Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Address Type';
                }
                field("NS_Contact No."; Rec."NS_Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Contact No.';
                }
                field("NS_No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';
                }
            }
        }
    }

    //   +---------------------------------------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +     Job Quoting - Group
    //   +       Table ID
    //   +       Address Type
    //   +       Contact No.
    //   +       No.
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

