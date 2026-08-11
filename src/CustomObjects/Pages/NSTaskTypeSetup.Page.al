page 14021393 NS_TaskTypeSetup
//PRJ-1348.NK.1.0 24May2022 New Page Create
//PE-92.RM.1.0 27May2023 | Added some code
//PE-168.HS.1.0 6Dec2023 |Add Code
///  //PRJCTPR-316.HS.1.0 14Feb2024 | Added New Action and tooltips
{
    PageType = Card;
    caption = 'Field Management Setup'; //PE-168.HS.1.0 6Dec2023
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = NS_APOSetup;
    DeleteAllowed = false;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Activity Code"; Rec."Activity Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Activity Code';
                }
                field("Process Code"; Rec."Process Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Process Code';
                }
                field("Operation Code"; Rec."Operation Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Operation Code';
                }
                field("Section Code"; Rec."Section Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Section Code';
                }
            }
            //PE-92.RM.1.0 23May2023 Start
            group("User Task Setup")
            {
                field("User task Alert No. of Days"; Rec."NS_User task Alert No. of Days")
                {
                    ApplicationArea = all;
                    // ToolTip = 'User task Alert No. of Days'; //PE-92.RM.1.0 20June2023
                    ToolTip = 'The no. of days within the date range of the "Current Date" and the "Due Date" to trigger an alert Cue on role center to take action.For Example If we enter 7D the task will trigger a notification if task is falling in the "Due Date" of 7 days.'; //PE-92.RM.1.0 20JJune2023
                }
                //PE-185.NC.1.0 10Oct2023 Start
                field(NS_EnableUserTaskCategory; Rec.NS_EnableUserTaskCategory)
                {
                    ApplicationArea = All;
                    // ToolTip = 'Specifies the value of the Enable User Task Category field.';  //PRJCTPR-316.HS.1.0 14Feb2024 Commented
                    ToolTip = 'Enable it to use User Task cues on the Role Center. To set the cues sequence and names, click on "User Task Category" under the Action button.';  //PRJCTPR-316.HS.1.0 14Feb2024
                }
                ////PE-185.NC.1.0 10Oct2023 End

            }
            //PE-92.RM.1.0 23May2023 End
            //PE-168.JS.1.0 04DEC2023 - start
            group("Job Daily Log")
            {
                field("NS_Temperature Measuring Scale"; Rec."NS_Temperature Measuring Scale")
                {
                    ApplicationArea = All;
                    caption = 'Temperature Measuring Scale';
                    ToolTip = 'Specifies the value of the Temperature Measuring Scale field.';
                }
                // PRJCTPR-275.PS.1.0 22Dec2023 Start
                field("NS_Job Daliy Log Doc. No."; Rec."NS_Job Daliy Log Doc. No.")
                {
                    ApplicationArea = All;
                    caption = 'Job Daily Log Doc. No.';  //PRJCTPR-235.JS.1.0 23JAN2024
                }
                // PRJCTPR-275.PS.1.0 22Dec2023 End 
            }
            //PE-168.JS.1.0 04DEC2023 - end
            //PE-288.JS.1.0 06MAY2024-Start
            group(NSPPJobPunchList)
            {
                caption = 'Job Punch List';
                field("NS_PunchList No."; Rec."NS_PunchList No.")
                {
                    caption = 'Punch List No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Punch List No.';
                }
            }
            //PE-288.JS.1.0 06MAY2024-end
        }
    }
    //PRJCTPR-316.HS.1.0 14Feb2024 Start
    actions
    {
        area(Processing)
        {
            action("NS_UserTask Category")
            {
                ApplicationArea = all;
                Caption = 'User Task Category';
                ToolTip = 'Specifies cue sequence for User Task Category list on the role center. You need to enable the Boolean "Enable User Task Category" below to make this field editable.';
                Enabled = Rec.NS_EnableUserTaskCategory;
                RunObject = page NSUserTaskCategory;
                Image = List;
            }

            //PE-288.JS.1.0 09MAY2024-Start
            action("NS Punch List")
            {
                ApplicationArea = all;
                Caption = 'Punch List Code';
                RunObject = page "NS_Punch List Codes";
                Image = Worksheet;
                Promoted = true;
                PromotedCategory = Process;
            }
            //PE-288.JS.1.0 09MAY2024-end
        }

    }
    //PRJCTPR-316.HS.1.0 14Feb2024  End
    var
        jj: page "Jobs Setup";
}