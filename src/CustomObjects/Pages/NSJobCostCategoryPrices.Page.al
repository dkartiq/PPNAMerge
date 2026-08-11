page 14021169 "NS_Job Cost Category Prices"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    PageType = List;
    Caption = 'Job Cost Category Prices';
    SourceTable = "NS_Job Cost Category Price";
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';
                }
                field("Cost Category Code"; Rec."NS_Cost Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Cost Category Code';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field("Markup %"; Rec."NS_Markup %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Markup %';
                }
            }
        }
    }
}

