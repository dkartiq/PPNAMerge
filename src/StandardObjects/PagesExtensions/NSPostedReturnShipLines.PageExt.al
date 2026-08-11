pageextension 14021183 NS_PostedReturnShipLinesExt extends "Posted Return Shipment Lines"
{
    // version NAVW111.00.00.19846,PPNA11.00

    layout
    {
        modify("Job No.")
        {
            Visible = true;
        }

        addafter("Variant Code")
        {
            field("NS Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Gen. Bus. Posting Group';
            }
            field("NS Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Gen. Prod. Posting Group';
            }
        }
    }

    /*
      +------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     "PP Gen. Bus. Posting Group"
      +     "PP Gen. Prod. Posting Group"
      +
      +  - Modification(s):
      +     - Set Job No. column as Visible=TRUE
      +------------------------------------------------------------
    */

}

