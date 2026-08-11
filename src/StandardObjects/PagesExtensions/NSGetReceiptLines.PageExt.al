pageextension 14021297 NS_GetReceiptLines extends "Get Receipt Lines"
{
    // version NAVW111.00.00.19846,PPNA11.00
    //TM-10.AM.1.0 | Added Field.

    layout
    {
        modify("Job No.")
        {
            Visible = true;
        }

        addafter(Description)
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
            field("NS_Segment Code"; "NS_Segment Code")
            {
                ApplicationArea = all;
                Editable = false;
                Description = 'TM-10.AM.1.0';
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

