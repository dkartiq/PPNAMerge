tableextension 14021219 NS_InteractionLogEntry extends "Interaction Log Entry"
{
    // version NAVW111.00.00.24232,PPNA11.00

    fields
    {
        field(14021100; "NS_Job Quote No."; Code[20])
        {
            Description = 'ProjectPro';
            Caption = 'Job Quote No.';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(Key1; "NS_Job Quote No.")
        {
        }
    }
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021100 PP_Job Quote No.
//   +
//   +  - Modification(s):
//   +     - Added Keys:
//   +         PP_Job Quote No.
//   +     - CopyFromSegment: Added set for PP_Job Quote No.
//   +-----------------------------------------------------------------------------------------------