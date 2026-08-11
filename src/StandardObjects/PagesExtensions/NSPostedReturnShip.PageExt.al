pageextension 14021181 NS_PostedReturnShip extends "Posted Return Shipment"
{
    // version NAVW111.00.00.19846,NAVNA11.00.00.19846,PPNA11.00

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
            field("NS_Draw No."; Rec."NS_Draw No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the Draw No.';
            }
        }
    }

    /*
      +------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     "PP Job No."
      +     "PP Draw No."
      +------------------------------------------------------------
    */

}

