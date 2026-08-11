page 14021423 "NS_Job Quote Template Segments"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    PageType = List;
    Caption = 'Job Quote Template Segments';
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    SourceTable = "NS_Job Takeoff Segments";
    SourceTableView = WHERE(NS_Type = CONST(Template));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Type"; Rec."NS_Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Type';
                }
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';
                }
                field("Segment Code"; Rec."NS_Segment Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Segment Code';
                }
                field("Segment Name"; Rec."NS_Segment Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Segment Name';
                }
            }
        }
    }

    actions
    {
    }
}

