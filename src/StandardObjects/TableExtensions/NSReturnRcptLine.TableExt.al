tableextension 14021233 NS_ReturnRcptLine extends "Return Receipt Line"
{
    // version NAVW111.00,NAVNA11.00,PPNA11.00

    fields
    {
        field(14021104; "NS_Job Task No."; Code[35])
        {
            Caption = 'Job Task No.';
            Description = 'ProjectPro';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
            DataClassification = CustomerContent;
        }
    }
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021104 Job Task No.
//   +
//   +-----------------------------------------------------------------------------------------------