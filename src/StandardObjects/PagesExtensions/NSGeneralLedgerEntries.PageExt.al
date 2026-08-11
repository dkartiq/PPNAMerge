pageextension 14021101 NS_GeneralLedgerEntries extends "General Ledger Entries"
{
    // version NAVW111.00.00.24232,PPNA11.00
    //PRJ-490.AM.1.0 Added Fields.

    layout
    {
        addafter("FA Entry No.")
        {
            field("NS_Bal. Ledger No."; Rec."NS_Bal. Ledger No.")
            {
                ToolTip = 'Specifies the  Bal. Ledger No.';
                ApplicationArea = All;
            }
            //PRJ-490.AM.1.0 Start
            field("NS_FA Job No."; "NS_FA Job No.")
            {
                ApplicationArea = all;
                Caption = 'FA Job No.';
                Editable = false;
            }
            field("NS_FA Job Task No."; "NS_FA Job Task No.")
            {
                ApplicationArea = all;
                Caption = ' FA Job Task No.';
                Editable = false;
            }
            field("NS_FA Segment Code"; "NS_FA Segment Code")
            {
                ApplicationArea = all;
                Caption = 'FA Segment Code';
                Editable = false;
            }
            //PRJ-490.AM.1.0 End
        }
    }
    /*
    +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +     - Added controls:
      +         PP Bal. Ledger No.
      +-----------------------------------------------------------------------------------------------
      */

}

