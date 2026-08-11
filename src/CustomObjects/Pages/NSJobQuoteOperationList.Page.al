page 14021424 "NS_Job Quote Operation List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    PageType = List;
    Caption = 'Job Quote Operation List';
    SourceTable = "NS_Job Operation";
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.NS_Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Type';
                }
                field("Activity Code"; Rec."NS_Activity Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Activity Code';
                }
                field("Process Code"; Rec."NS_Process Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Process Code';
                }
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
            }
        }
    }

    actions
    {
    }
}

