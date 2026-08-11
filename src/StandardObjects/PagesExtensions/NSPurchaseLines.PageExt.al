pageextension 14021264 NS_PurchaseLines extends "Purchase Lines"
{
    // version NAVW111.00.00.19846,PPNA11.00

    layout
    {
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
        addafter("Shortcut Dimension 2 Code")
        {
            field("NS Job Cost Category"; Rec."NS_Job Cost Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Cost Category';
            }
            field("NS Job Revenue Category"; Rec."NS_Job Revenue Category")
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
      +     "PP Job Cost Category"
      +     "PP Job Revenue Category"
      +
      +  - Modification(s):
      +     - Set Job No. and Job Task No. columns as Visible=TRUE
      +------------------------------------------------------------
    */

}

