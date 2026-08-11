pageextension 14021336 NS_UserTaskList extends "User Task List"
{
    //PE-74.NK.1.0 19Apr2023 | Create New Table Extensions   
    layout
    {
        // Add changes to page layout here
        addafter("Percent Complete")
        {

            field(NS_JobNo; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Job No. field.';
            }
            field("NS_Task No."; Rec."NS_Task No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Task No. field.';
            }
            field("NS_Task Category"; Rec."NS_Task Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Task Category field.';
            }
            field("NS_Task Item"; Rec."NS_Task Item")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Task Item field.';
            }

        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}