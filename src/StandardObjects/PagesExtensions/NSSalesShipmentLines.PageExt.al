pageextension 14021298 NS_SalesShipmentLines extends "Sales Shipment Lines"
{
    // version NAVW111.00.00.19846,PPNA11.00

    layout
    {
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
        addafter("Appl.-to Item Entry")
        {
            field("NS_Job Task No."; REC."Job Task No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Task No.';
            }
            field("NS_Job Cost Category"; Rec."NS_Job Cost Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Cost Category';
                Visible = false;
            }
            field("NS_Job Revenue Category"; Rec."NS_Job Revenue Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Revenue Category';
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
      +     "PP Job Cost Category"
      +     "PP Job Revenue Category"
      +
      +  - Modification(s):
      +  - Set Job No. column as Visible=TRUE
      +------------------------------------------------------------
    */

}

