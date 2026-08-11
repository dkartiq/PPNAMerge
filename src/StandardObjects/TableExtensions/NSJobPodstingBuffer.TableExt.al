tableextension 14021140 NS_JobPostingBufferExt extends "Job Posting Buffer"
{
    // version NAVW111.00.00.20783,PPNA11.00
    //PRJCTPR-197 Dk.1.0 31March2023  | Job No. Rewrite Issue.

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
        field(14021107; "NS_Activity Code"; Code[10])
        {
            Caption = 'Activity Code';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021108; "NS_Process Code"; Code[10])
        {
            Caption = 'Process Code';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021109; "NS_Operation Code"; Code[10])
        {
            Caption = 'Operation Code';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021150; "NS_Job Type"; Code[10])
        {
            Caption = 'Job Type';
            Description = 'ProjectPro';
            //TableRelation = Job; //PRJCTPR-197 Dk.1.0 31March2023 
            DataClassification = CustomerContent;
            //PRJCTPR-197 Dk.1.0 31March2023 Start
            ObsoleteState = Pending;
            ObsoleteReason = 'This field is marked for removal and replaced by new field "NS_Job Type New" because of length mismatch with';
            ObsoleteTag = 'This field will remove in ProjectPro Upcoming App build no 21.0.xx.49984';
            //PRJCTPR-197 Dk.1.0 31March2023 End
        }
        //PRJCTPR-197 Dk.1.0 31March2023  Start
        field(14021152; "NS_Job Type New"; Code[20])
        {
            Caption = 'Job Type';
            Description = 'ProjectPro';
            TableRelation = Job; //PRJCTPR-197 Dk.1.0 31March2023 
            DataClassification = CustomerContent;
        }
        //PRJCTPR-197 Dk.1.0 31March2023 End
        //PRJ-603.AS.1.0 13APRIL2021 - START
        field(14021151; "NS_Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            DataClassification = CustomerContent;
        }
        //PRJ-603.AS.1.0 13APRIL2021 - END
    }
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021101 Job Cost Category
//   +     14021102 Job Revenue Category
//   +     14021107 Activity Code
//   +     14021108 Process Code
//   +     14021109 Operation Code
//   +     14021150 Job Type
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