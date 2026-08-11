pageextension 14021180 NS_GetReturnShipLines extends "Get Return Shipment Lines"
{
    // version NAVW111.00.00.19846,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Get Return Shipment Lines'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        modify("Job No.")
        {
            Visible = true;
        }

        addafter("Variant Code")
        {
            field("NS_Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Gen. Bus. Posting Group';
            }
            field("NS_Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Gen. Prod. Posting Group';
            }
        }
        addafter("Job No.")
        {
            field("NS_Job Task No."; Rec."Job Task No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Task No.';
            }
        }
    }

    /*
      +------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     "PP Gen. Bus. Posting Group"
      +     "PP Gen. Prod. Posting Group"
      +     "PP Job Task No."
      +
      +  - Modification(s):
      +  - Set Job No. column as Visible=TRUE
      +------------------------------------------------------------
    */

}

