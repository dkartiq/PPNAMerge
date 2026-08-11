tableextension 14021135 NS_ResourceCost extends "Resource Cost"
{
    // version NAVW16.00,PPNA11.00

    fields
    {
        field(14021100; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            Description = 'ProjectPro';
            TableRelation = Job."No.";
            DataClassification = CustomerContent;
        }
        field(14021101; "NS_Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("NS_Job No."));
        }
        field(14021102; "NS_Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Description = 'ProjectPro';
            TableRelation = Currency.Code;
            DataClassification = CustomerContent;
        }
    }
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021100 Job No.
//   +     14021101 Job Task No.
//   +     14021102 Currency Code
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