page 14021157 NS_Processes
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-192:AS:09APRIL2020 : Changed page type to list page as scrolling feature was not enabled on webclient due to wrong page type card.
    //PPAL-122.N.S.1.0 27Aug2020 change caption
    //PRJ-1042.JS.1.0 15Dec2021 | Add fields

    Caption = 'Processes';
    DataCaptionFields = "NS_Activity Code";
    PageType = List;//PRJ-192:AS:09APRIL2020
    SourceTable = "NS_Job Process";
    UsageCategory = Documents;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Activity Code"; Rec."NS_Activity Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Activity Code';
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
                field("Default Project Burden Percent"; Rec."NS_DefaultProjectBurdenPercent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Default Project Burden Percent';
                }
                field("Default Service Burden Percent"; Rec."NS_DefaultServiceBurdenPercent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Default Service Burden Percent';
                }
                field("Default Task for Job Type"; Rec."NS_DefaultTaskforJobType")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Default Task for Job Type';
                }

                //PRJ-1042.JS.1.0  15Dec2021-Start
                field("NS_Job Task Type"; Rec."NS_Job Task Type")
                {
                    ToolTip = 'Specifies the value of the Job Task Type field.';
                    ApplicationArea = All;
                }
                field(NS_Totaling; Rec.NS_Totaling)
                {
                    ToolTip = 'Specifies the value of the Totaling field.';
                    ApplicationArea = All;
                }

                //PRJ-1042.JS.1.0  15Dec2021-end

            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Processes")
            {
                ApplicationArea = All;
                //Caption = '&Processes';//PPAL-122.N.S.1.0 27Aug2020 Comment
                Caption = 'Operations'; //PPAL-122.N.S.1.0 27Aug2020
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page NS_Operations;
                RunPageLink = NS_Type = FIELD(NS_Type),
                              "NS_Activity Code" = FIELD("NS_Activity Code"),
                              "NS_Process Code" = FIELD(NS_Code);
                //ToolTip = 'Specifies the &Processes';//PPAL-122.N.S.1.0 27Aug2020 Comment
                ToolTip = 'Specifies the &Operations';//PPAL-122.N.S.1.0 27Aug2020
            }
        }
    }
}

