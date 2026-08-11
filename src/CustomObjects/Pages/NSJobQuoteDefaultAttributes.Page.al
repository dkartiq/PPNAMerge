page 14021415 "NS_Job QuoteDefaultAttributes"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Default Attributes';
    PageType = List;
    SourceTable = "NS_Job Quote Default Attribute";
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Attribute Code"; Rec."NS_Attribute Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Attribute Code';
                }
                field("Text Value"; Rec."NS_Text Value")
                {
                    ApplicationArea = All;
                    Caption = 'Value';
                    ToolTip = 'Value';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field("Table Name"; Rec."NS_Table Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Table Name';
                }
            }
        }
    }

    actions
    {
    }
}

