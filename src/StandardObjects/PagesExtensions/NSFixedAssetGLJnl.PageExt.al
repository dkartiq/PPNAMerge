pageextension 14021295 NS_FixedAssetGLJnl extends "Fixed Asset G/L Journal"
{
    // version NAVW111.00.00.23572,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Fixed Asset G/L Journals'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        modify("VAT Bus. Posting Group")
        {
            Visible = true;
        }

        addafter("Bal. Account No.")
        {
            field("NS_Bal. Ledger No."; Rec."NS_Bal. Ledger No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Bal. Ledger No.';
            }
        }
    }

    /*
     +------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     "PP Bal. Ledger No."
      +
      +  - Modification(s):
      +     - set VAT Prod. Posting Group column as Visible=TRUE
      +------------------------------------------------------------
    */
}

