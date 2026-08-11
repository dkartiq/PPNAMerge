pageextension 14021232 NS_JobPostingGrps extends "Job Posting Groups"
{
    // version NAVW111.00,PPNA11.00

    layout
    {
        addafter("Recognized Sales Account")
        {
            field("NS_G/L Labor Expense Account"; Rec."NS_G/L Labor Expense Account")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the G/L Labor Expense Account';
            }
            field("NS_Allocated Job Burden"; REC."NS_Allocated Job Burden")//CTSI-254.AS.1.0 25MARCH2021
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Allocated Job Burden G/L Account - Debit';
            }
            field("NS_Job Burden Off-Set"; REC."NS_Job Burden Off-Set")//CTSI-254.AS.1.0 25MARCH2021
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Burden Off-Set G/L Account - Credit';
            }
            field("NS_Over Billing Account"; Rec."NS_Over Billing Account")
            {
                ApplicationArea = all;
                Caption = 'Over Billing Account';
                Description = 'PRJ-830.MS.1.0';
                ToolTip = 'Specifies the Allocated Rec.Rev. G/L Account - Credit';
            }
            field("NS_Under Billing Account"; Rec."NS_Under Billing Account")
            {
                ApplicationArea = all;
                Description = 'PRJ-830.MS.1.0';
                Caption = 'Under Billing Account';
                ToolTip = 'Specifies the Allocated Rec.Rev. G/L Account - Debit';
            }
        }
    }

    //   +---------------------------------------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +     G/L Labor Expense Account
    //   +
    //   +  - Added function(s):
    //   +
    //   +  - Added global variable(s):
    //   +
    //   +  - Added global text constant(s):
    //   +
    //   +  - Modification(s):
    //   +-----------------------------------------------------------------------------------------------

}

