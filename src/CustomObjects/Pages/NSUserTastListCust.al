page 14021370 "NSUserTaskList"
//PE-185.NC.1.0 10Oct2023 New Page create
{
    ApplicationArea = Basic, Suite;
    Caption = 'User Tasks';
    CardPageID = "User Task Card";
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "User Task";
    DelayedInsert = true;
    DeleteAllowed = true;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DataCaptionFields = "NS_User Task Category";
    layout
    {
        area(content)
        {
            repeater(Group)

            {
                field(Title; Rec.Title)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the title of the task.';
                }
                field("Due DateTime"; Rec."Due DateTime")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies when the task must be completed.';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the priority of the task.';
                }
                field("Percent Complete"; Rec."Percent Complete")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the progress of the task.';
                }
                field("Assigned To User Name"; Rec."Assigned To User Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies who the task is assigned to.';
                }
                field("NS_User Task Category"; Rec."NS_User Task Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User Task Category field.';
                }
                field("User Task Group Assigned To"; Rec."User Task Group Assigned To")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'User Task Group';
                    ToolTip = 'Specifies the group if the task has been assigned to a group of people.';
                }
                field("Created DateTime"; Rec."Created DateTime")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies when the task was created.';
                    Visible = false;
                }
                field("Completed DateTime"; Rec."Completed DateTime")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies when the task was completed.';
                    Visible = false;
                }
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
    }


    actions
    {
        area(creation)
        {
            action("User Task Groups")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'User Task Groups';
                Image = Users;
                RunObject = Page "User Task Groups";
                ToolTip = 'Add or modify groups of users that you can assign user tasks to in this company.';
            }
            action("Mark Complete")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Mark as Completed';
                Image = CheckList;
                ToolTip = 'Indicate that the task is completed. The % Complete field is set to 100.';

                trigger OnAction()
                var
                    UserTask: Record "User Task";
                begin
                    CurrPage.SetSelectionFilter(UserTask);
                    if UserTask.FindSet(true) then
                        repeat
                            UserTask.SetCompleted();
                            UserTask.Modify();
                        until UserTask.Next() = 0;
                end;
            }
            action("Go To Task Item")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Go To Task Item';
                Image = Navigate;
                ToolTip = 'Open the page or report that is associated with this task.';

                trigger OnAction()
                begin
                    Rec.RunReportOrPageLink();
                end;
            }
        }
        area(processing)
        {
            action("Delete User Tasks")
            {
                ApplicationArea = All;
                Caption = 'Delete User Tasks';
                Image = Delete;
                RunObject = Report "User Task Utility";
                ToolTip = 'Find and delete user tasks.';
            }
        }
    }

    var
        StyleTxt: Text;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := Rec.SetStyle();
    end;
}