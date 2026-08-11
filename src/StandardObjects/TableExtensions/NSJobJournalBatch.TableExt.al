tableextension 14021142 NS_JobJournalBatch extends "Job Journal Batch"
{
    // version NAVW111.00,PPNA11.00

    fields
    {
        field(14021100; "NS_Auto-F8 Job No."; Boolean)
        {
            Caption = 'Auto-F8 Job No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021101; "NS_Auto-F8 Job Task No."; Boolean)
        {
            Caption = 'Auto-F8 Job Task No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
    }
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021100 Auto-F8 Job No.
//   +     14021101 Auto-F8 Job Task No.
//   +
//   +  - Added function(s):
//   +
//   +  - Added global variable(s):
//   +
//   +  - Added global text constant(s):
//   +
//   +  - Modification(s):
//   +
//   +-----------------------------------------------------------------------------------------------