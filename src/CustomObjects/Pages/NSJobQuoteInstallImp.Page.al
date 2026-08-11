page 14021418 "NS_Job Quote Install Imp. "
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Quote Install Import Lines';
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    SourceTable = "NS_Job Quote Import Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."NS_Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line No.';
                }
                field("Column 1 Value"; Rec."NS_Column 1 Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Column 1 Value';
                }
                field("Column 2 Value"; Rec."NS_Column 2 Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Column 2 Value';
                }
                field("Column 3 Value"; Rec."NS_Column 3 Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Column 3 Value';
                }
                field("Column 4 Value"; Rec."NS_Column 4 Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Column 4 Value';
                }
                field("Column 5 Value"; Rec."NS_Column 5 Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Column 5 Value';
                }
                field("Column 6 Value"; Rec."NS_Column 6 Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the "Column 6 Value';
                }
                field("Column 7 Value"; Rec."NS_Column 7 Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Column 7 Value';
                }
                field("Column 8 Value"; Rec."NS_Column 8 Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Column 8 Value';
                }
                field("Column 9 Value"; Rec."NS_Column 9 Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Column 9 Value';
                }
            }
        }
    }

    actions
    {
    }
}

