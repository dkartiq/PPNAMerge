pageextension 14021147 NS_PostedPurchaseReceipt extends "Posted Purchase Receipt"
{
    // version NAVW111.00.00.19846,NAVNA11.00.00.19846,PPNA11.00
    //PRJ-1380.NK.1.0 13May2022 | Added Fields
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Posted Purchase Receipt'; //PRJ-1330.NK.1.0 25Apr2022
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
            //PRJ-1380.NK.1.0 13May2022 Start
            field("NS_Job Purchaser"; Rec."NS_Job Purchaser")
            {
                ApplicationArea = All;
                ToolTip = 'Job Purchaser';
                Description = 'PRJ-1380.NK.1.0';
            }
            field("NS_Job Manager"; Rec."NS_Job Manager")
            {
                ApplicationArea = All;
                ToolTip = 'Job Manager';
                Description = 'PRJ-1380.NK.1.0';
            }
            //PRJ-1380.NK.1.0 13May2022 End
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

