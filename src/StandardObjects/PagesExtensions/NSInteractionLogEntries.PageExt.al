pageextension 14021283 NS_InteractionLogEntries extends "Interaction Log Entries"
{
    // version NAVW111.00.00.19846,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Interaction Log Entries'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        addafter("To-do No.")
        {
            field("NS_Job Quote No."; "NS_Job Quote No.")
            {
                ApplicationArea = All;
                Caption = 'Job Quote No.';
                ToolTip = 'Specifies the Job Quote No.';
            }
        }
    }

    /*
      +------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     "NS_Job Quote No."
      +------------------------------------------------------------
    */

}

