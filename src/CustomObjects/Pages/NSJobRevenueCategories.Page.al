page 14021202 "NS_Job Revenue Categories"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job Revenue Categories';
    PageType = Card;
    SourceTable = "NS_Job Revenue Category";
    UsageCategory = Administration;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code"; Rec.NS_Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Code';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field(Type; Rec.NS_Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Type';
                }
                field("Exclude From Pct of Completion"; Rec."NS_ExcludeFromPctofCompletion")
                {
                    ApplicationArea = All;
                    Caption = 'Exclude From Percent of Completion';
                    ToolTip = 'Specifies whether to Exclude From Percent of Completion';
                }
                field("Summarize on G703"; Rec."NS_Summarize on G703")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether to Summarize on G703';
                }
            }
        }
    }

    actions
    {
    }
}

