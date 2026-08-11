page 14021164 "NS_Crew Lines"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    AutoSplitKey = true;
    Caption = 'Crew Lines';
    PageType = List;
    SourceTable = "NS_Crew Line";
    UsageCategory = Lists;
    ApplicationArea = Jobs;

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
                    Visible = false;
                }
                field("Resource No."; Rec."NS_Resource No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Resource No.';
                }
                field("Resource Name"; Rec."NS_Resource Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Resource Name';
                }
                field("Lead Person"; Rec."NS_Lead Person")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Lead Person';
                }
                field(NS_Active; Rec.NS_Active)
                {
                    Caption = 'Active';//PRJ-772.JS
                    ToolTip = 'Specifies the value of the Active field';
                    ApplicationArea = All;
                }

            }
        }
    }
}

