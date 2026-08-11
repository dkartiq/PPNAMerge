page 14021410 "NS_Job Quote Feature Text"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    AutoSplitKey = true;
    Caption = 'Feature Text';
    DelayedInsert = true;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    SourceTable = "NS_Job Quote Feature Text";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Text Value"; Rec."NS_Text Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies theText Value';
                }
            }
        }
    }

    actions
    {
    }
}

