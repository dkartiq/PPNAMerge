tableextension 14021438 NS_InventoryProfile extends "Inventory Profile"
{
    // version NAVW111.00,PPNA11.00

    fields
    {
        field(14021375; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            Description = 'ProjectPro';
            TableRelation = Job."No.";
            Dataclassification = CustomerContent;
        }
        field(14021376; "NS_Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            Description = 'ProjectPro';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("NS_Job No."));
            Dataclassification = CustomerContent;
        }
    }

    //   +---------------------------------------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +     14021375 Job No.
    //   +     14021376 Job Task No.
    //   +
    //   +  - Added function(s):
    //   +
    //   +  - Added global variable(s):
    //   +
    //   +  - Added global text constant(s):
    //   +
    //   +  - Modification(s):
    //   +     - TransferFromJobPlanningLine: Assign fields from Job Planning Line
    //   +                                              Job No.
    //   +                                              Job Task No.
    //   +-----------------------------------------------------------------------------------------------

}

