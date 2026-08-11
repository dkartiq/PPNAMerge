page 14021451 "NS_Labor rate by task list"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    //CTSI-95.MS.1.0 create new page
    // +------------------------------------------------------------

    Caption = 'Labor Rates by Task';
    //Editable = false;
    PageType = List;
    SourceTable = "NS_Labor rate by task list";
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Dimension code"; "NS_Dimension code")
                {
                    ApplicationArea = all;
                }
                field("Dimension Value code"; "NS_Dimension Value code")
                {
                    ApplicationArea = all;
                }
                field("Task Code"; "NS_Task Code")
                {
                    ApplicationArea = all;
                }
                field("Task Description"; "NS_Task Description")
                {
                    ApplicationArea = all;
                }
                field("Labor Rate"; "NS_Labor Rate")
                {
                    ApplicationArea = all;
                }

            }
        }
        area(factboxes)
        {
            systempart(Control1100773024; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1100773005; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
    }
}

