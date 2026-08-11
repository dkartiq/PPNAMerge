tableextension 14021222 NS_SalesLineArchive extends "Sales Line Archive"
{
    // version NAVW111.00.00.22292,NAVNA11.00.00.22292,PPNA11.00

    fields
    {
        field(14021101; "NS_Job Cost Category"; Code[10])
        {
            Caption = 'Job Cost Category';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Cost Category";
            DataClassification = CustomerContent;
        }
        field(14021102; "NS_Job Revenue Category"; Code[10])
        {
            Caption = 'Job Revenue Category';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Revenue Category";
            DataClassification = CustomerContent;
        }
        field(14021104; "NS_Job Task No."; Code[35])
        {
            Caption = 'Job Task No.';
            Description = 'ProjectPro';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
            DataClassification = CustomerContent;
        }
        field(14021135; "NS_Retention Applies"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Retention Applies';
        }
    }

    keys
    {
        key(Key6; "NS_Retention Applies")
        {

        }
    }
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021101 Job Cost Category
//   +     14021102 Job Revenue Category
//   +     14021104 Job Task No.
//   +     14021135 Retention Applies
//   +
//   +  - Modification(s):
//   +     Add Keys:
//   +       Retention Applies
//   +     Fields:
//   +       Type - Added Ledger to the end of OptionString
//   +-----------------------------------------------------------------------------------------------