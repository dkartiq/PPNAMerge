page 14021156 NS_Activities
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-192:AS:09APRIL2020 : Changed page type to list page as scrolling feature was not enabled on webclient due to wrong page type card.
    //PRJ-1085.RM.1.0 16Dec2021 | Added Page url
    //PRJ-917.NK.1.0 09Mar2022 | Add One Field
    //ContextSensitiveHelpPage = 'user-guide/role-center/activities/'; //PRJ-1085.RM.1.0 16Dec2021

    Caption = 'Job Activities'; //PRJ-917.NK.1.0
    PageType = List;//PRJ-192:AS:09APRIL2020
    SourceTable = "NS_Job Activity";
    UsageCategory = Administration;
    ApplicationArea = all;


    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type; Rec.NS_Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Type';
                }
                field("Code"; Rec.NS_Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Code';
                }
                field("Search Code"; Rec."NS_Search Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Search Code';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field("Default onto each Job"; Rec."NS_Default onto each Job")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Default onto each Job';
                }
                field("Job Task Type"; Rec."NS_Job Task Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Task Type';
                }
                field(Totaling; Rec.NS_Totaling)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Totaling';
                }
                field("New Page"; Rec."NS_New Page")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the New Page';
                }
                field("No. of Blank Lines"; Rec."NS_No. of Blank Lines")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No. of Blank Lines';
                }
                field(Indentation; Rec.NS_Indentation)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Indentation';
                }
                field("Default Project Burden Percent"; Rec.NS_DefaultProjectBurdenPerc)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Default Project Burden Percent';
                }
                field("Default Service Burden Percent"; Rec."NS_DefaultServiceBurdenPerc")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Default Service Burden Percent';
                }
                field("Default Task for Job Type"; Rec."NS_DefaultTaskforJobType")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Default Task for Job Type';
                }
                //PRJ-917.NK.1.0 09Mar2022 Start
                field(NS_Blocked; Rec.NS_Blocked)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Blocked';
                }
                //PRJ-917.NK.1.0 09Mar2022 End
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Process")
            {
                ApplicationArea = All;
                Caption = '&Process';
                Image = RoutingVersions;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page NS_Processes;
                RunPageLink = NS_Type = FIELD(NS_Type),
                              "NS_Activity Code" = FIELD(NS_Code);
                ToolTip = 'View the process';
            }
        }
    }
}

