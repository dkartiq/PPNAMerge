pageextension 14021287 NS_SalesQuoteArchiveSubForm extends "Sales Quote Archive Subform"
{
    // version NAVW111.00.00.19846,NAVNA11.00.00.19846,PPNA11.00

    layout
    {
        modify("Job No.")
        {
            Visible = true;
        }

        addafter("VAT Prod. Posting Group")
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

