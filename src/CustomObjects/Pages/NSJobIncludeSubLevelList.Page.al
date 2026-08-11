page 14021173 "NS_Job Include Sub Level List"
{

    //PRJ-1015.JS.1.0  05Oct2021

    Caption = 'Job Include Sub Level List';
    //Editable = false;
    PageType = List;
    SourceTable = "NS_Job Include Sub Levels";
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("NS_Job No."; Rec."NS_Job No.")
                {
                    ToolTip = 'Specifies the value of the Job No.';
                    ApplicationArea = All;
                    Editable = false;
                    TableRelation = Job;
                }
                field("NS_Job Task No."; Rec."NS_Job Task No.")
                {
                    ToolTip = 'Specifies the value of the Task No.';
                    ApplicationArea = All;
                    Editable = false;
                    TableRelation = "Job Task";
                }
                field("NS_Sub Level Job No."; Rec."NS_Sub Level Job No.")
                {
                    ToolTip = 'Specifies the value of the Sub Level Job No.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NS_Budgeted Cost"; Rec."NS_Budgeted Cost")
                {
                    ToolTip = 'Specifies the value of the Budgeted Cost';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NS_Job Class"; Rec."NS_Job Class")
                {
                    ToolTip = 'Specifies the value of for Job Class Type';
                    ApplicationArea = All;
                    Editable = false;
                }

            }
        }
    }

    actions
    {
    }
}

