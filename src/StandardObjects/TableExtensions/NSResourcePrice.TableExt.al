tableextension 14021134 NS_ResourcePrice extends "Resource Price"
{
    // version NAVW17.00,PPNA11.00

    fields
    {
        field(14021100; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';

            Description = 'ProjectPro';
            TableRelation = Job;
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(Key1; "NS_Job No.")
        {
        }
    }
}

