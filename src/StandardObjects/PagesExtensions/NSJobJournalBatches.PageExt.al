pageextension 14021238 NS_JobJournalBatches extends "Job Journal Batches"
{
    // version NAVW111.00.00.19846,PPNA11.00

    layout
    {
        addafter("Reason Code")
        {
            field("NS_Auto-F8 Job No."; Rec."NS_Auto-F8 Job No.")
            {
                ApplicationArea = All;
                Caption = 'Auto-F8 Job No.';

                ToolTip = 'Auto-F8 Job No.';
            }
            field("NS_Auto-F8 Job Task No."; Rec."NS_Auto-F8 Job Task No.")
            {
                ApplicationArea = All;
                Caption = 'Auto-F8 Job Task No.';

                ToolTip = 'Auto-F8 Job Task No.';
            }
        }
    }

    //   +---------------------------------------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +     Auto-F8 Job No.
    //   +     Auto-F8 Job Task No.
    //   +
    //   +  - Added function(s):
    //   +
    //   +  - Added global variable(s):
    //   +
    //   +  - Added global text constant(s):
    //   +
    //   +  - Modification(s):
    //   +-----------------------------------------------------------------------------------------------

}

