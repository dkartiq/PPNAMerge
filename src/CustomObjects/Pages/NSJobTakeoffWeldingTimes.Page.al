page 14021403 "NS_Job Takeoff Welding Times"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    PageType = List;
    Caption = 'Job Takeoff Welding Times';
    SourceTable = "NS_Job Takeoff Segments";
    SourceTableView = WHERE(NS_Type = FILTER(Welding));
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Size of Weld"; Rec."NS_Size of Weld")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Size of Weld';
                }
                field("Weld Time (Hours)"; Rec."NS_Weld Time (Hours)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Weld Time (Hours)';
                }
            }
        }
    }

    actions
    {
    }
}

