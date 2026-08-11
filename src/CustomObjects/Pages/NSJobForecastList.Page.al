page 14021335 "NS_Job Forecast List"
{
    //CTSI-207 create new page 

    Caption = 'Job Forecast List';
    Editable = true;
    PageType = List;
    SourceTable = "NS_Job Forecast";
    UsageCategory = Administration;
    ApplicationArea = all;
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job No."; REC."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Code';
                }
                field("Job Task No."; REC."NS_Job Task No.")
                {
                    ApplicationArea = All;
                }
                field("Line No."; REC."NS_Line No.")
                {
                    ApplicationArea = All;
                }
                field("User ID"; REC."NS_User ID")
                {
                    ApplicationArea = All;
                }
                field(Complete; REC.NS_Complete)//PRJ-565.AS.1.0 13MARCH2021
                {
                    ApplicationArea = all;
                }
                field("Actual Hours"; REC."NS_Actual Hours")
                {
                    ApplicationArea = All;
                }
                field("Bill Date"; REC."NS_Bill Date")
                {
                    ApplicationArea = All;
                }
                field("Bill Percent"; REC."NS_Bill Percent")
                {
                    ApplicationArea = All;
                }
                field("Budgeted Hours"; REC."Budgeted Hours")
                {
                    ApplicationArea = All;
                }
                field("Cost To Complete"; REC."NS_Cost To Complete")
                {
                    ApplicationArea = All;
                }
                field("Forecasted Completed Cost"; REC."NS_Forecasted Completed Cost")
                {
                    ApplicationArea = All;
                }
                field("Status Date"; REC."NS_Status Date")
                {
                    ApplicationArea = All;
                }
                field(Posted; REC.NS_Posted)
                {
                    ApplicationArea = all;
                }
                //PRJ-585.AS.1.0 16MARCH2021 start
                field("Percent Complete"; REC."NS_Percent Complete")
                {
                    ApplicationArea = all;
                }
                field("PO Expected Receipt Cost"; REC."NS_PO Expected Receipt Cost")
                {
                    ApplicationArea = all;
                }
                field("View Open Tasks Only"; REC."NS_View Open Tasks Only")
                {
                    ApplicationArea = all;
                }
                field("Units Complete"; REC."NS_Units Complete")
                {
                    ApplicationArea = all;
                }
                field("Forecasted Completed Price"; REC."NS_Forecasted Completed Price")
                {
                    ApplicationArea = all;

                }
                field("Hours To Finish"; REC."NS_Hours To Finish")
                {
                    ApplicationArea = all;
                }
                // field("User ID"; "User ID")
                // {
                //     ApplicationArea = all;
                // }
                field("Calc Expected Receipt Costs"; REC."NS_Calc Expected Receipt Costs")
                {
                    ApplicationArea = all;
                }
                field("Entry Type"; REC."NS_Entry Type")
                {
                    ApplicationArea = all;
                }
                field("Task Manager"; REC."NS_Task Manager")
                {
                    ApplicationArea = all;
                }
                field("Average Percent Complete"; REC."NS_Average Percent Complete")
                {
                    ApplicationArea = all;
                }
                field("Task Budget"; REC."NS_Task Budget")
                {
                    ApplicationArea = all;
                }
                field("Task Budget Percent"; REC."NS_Task Budget Percent")
                {
                    ApplicationArea = all;
                }
                field("Earned Billing"; REC."NS_Earned Billing")
                {
                    ApplicationArea = all;
                }
                field("Remaining Hours"; REC."NS_Remaining Hours")
                {
                    ApplicationArea = all;
                }
                field("Budgeted Hrs Percent Compelete"; REC."NS_Budgeted Hrs Percent Compelete")
                {
                    ApplicationArea = all;
                }
                // field("NS Date Filter"; Rec."NS_Date Filter")
                // {
                //     ApplicationArea = all;
                // }
                field("Total Est. cost to Complete"; REC."NS_Total Est. cost to Complete")
                {
                    ApplicationArea = all;
                }
                field("Total Forecast Completed Cost"; REC."NS_Total Forecast Completed Cost")
                {
                    ApplicationArea = all;
                }
                //PRJ-585.AS.1.0 16MARCH2021 - end

            }
        }
    }

    trigger OnOpenPage()
    var
        Usersetup: Record "User Setup";
    begin
        if Usersetup.Get(UserId) then;
        if not Usersetup."NS_Allow Forecast Deletion" then
            Error('You do not have permission of this page');

    end;


}

