page 14021409 "NS_Job Quote Attribute Set Ent"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Attribute Set Entries';
    PageType = List;
    SourceTable = "NS_Job Quote Attribute Set Ent";
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
                    ToolTip = 'Text Value';
                    Caption = 'Value';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies theDescription';
                }
            }
        }
    }

    actions
    {
    }
}

