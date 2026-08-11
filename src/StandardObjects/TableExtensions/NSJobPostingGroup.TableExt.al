tableextension 14021138 NS_jobPostingGroup extends "Job Posting Group"
{
    // version NAVW111.00.00.20783,PPNA11.00

    fields
    {
        field(14021153; "NS_G/L Labor Expense Account"; Code[20])
        {
            Caption = 'G/L Labor Expense Account';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(14021154; "NS_Allocated Job Burden"; Code[20])//CTSI-254.AS.1.0 25MARCH2021
        {
            CaptionML = ENU = 'Allocated Job Burden',
                        ENC = 'Allocated Job Burden';
            Description = '//CTSI-254.AS.1.0 25MARCH2021';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(14021155; "NS_Job Burden Off-Set"; Code[20])//CTSI-254.AS.1.0 25MARCH2021
        {
            CaptionML = ENU = 'Job Burden Off-Set',
                        ENC = 'Job Burden Off-Set';
            Description = '//CTSI-254.AS.1.0 25MARCH2021';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(14021156; "NS_Over Billing Account"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'PRJ-830.MS.1.0';
            TableRelation = "g/l account";
            Caption = 'Over Billing Account';
        }
        field(14021157; "NS_Under Billing Account"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'PRJ-830.MS.1.0';
            TableRelation = "g/l account";
            Caption = 'Under Billing Account';
        }
    }
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021153 G/L Labor Expense Account
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