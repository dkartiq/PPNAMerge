page 14021400 "NS_Drawing Segment"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-374.AS.1.0 10Sept2020 Added Caption Job Segment
    //TM-10.AM.1.0 24NOV2020 | Created new action for Importing Excel Files .
    //TM-10.AM.1.0 24NOV2020 | Added Fields in Layout and added New action to import Segment codes.
    //PE-75.RM.1.0 17May2023 | Added dome tooltips.
    PageType = List;
    SourceTable = "NS_Job Takeoff Segments";
    SourceTableView = WHERE(NS_Type = FILTER(Drawing));
    Caption = 'Job Segment';//PRJ-374.AS.1.0 10Sept2020		
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(PP_Type; Rec.NS_Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the  Type';
                    Visible = false;
                }
                field("PP_Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';
                    Visible = true;//TM-10.AM.1.0 
                }
                field("PP_Segment Code"; Rec."NS_Segment Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Segment Code';
                }
                field("PP_Segment Name"; Rec."NS_Segment Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Segment Name';
                }
                //TM-10.AM.1.0 24NOV2020 Start
                field("NS_Segment Description"; "NS_Segment Description")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies Segment Description';  //PE-75.RM.1.0 17May2023
                }
                field("NS_Billing Type"; "NS_Billing Type")
                {
                    ApplicationArea = all;
                }
                field("NS_Unit of Measure Code"; "NS_Unit of Measure Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Unit of Measure Code ';  //PE-75.RM.1.0 17May2023
                }
                field("NS_Estimated Quantity"; "NS_Estimated Quantity")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Estimated Quantity entered manually against the activity.'; //PE-75.RM.1.0 17May2023
                }
                field("NS_Unit Rate"; "NS_Unit Rate")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Unit Rate'; //PE-75.RM.1.0 17May2023
                }
                field("NS_Total Cost"; "NS_Total Cost")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specfies the Total Cost on the basis of Quanty*Unit Cost.'; //PE-75.RM.1.0 17May2023
                }
                //TM-10.AM.1.0 24NOV2020 End
            }
        }
    }

    actions
    {
        area(Processing)
        {
            //TM-10.AM.1.0 24NOV2020 start
            action(ImportWBSCode)
            {
                ApplicationArea = All;
                Caption = 'Import WBS Codes';
                Promoted = true;
                PromotedIsBig = true;
                Image = Planning;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Xmlport.Run(14021378, false, true, Rec);
                end;
            }
            //TM-10.AM.1.0 24NOV2020 End
        }

    }
}

