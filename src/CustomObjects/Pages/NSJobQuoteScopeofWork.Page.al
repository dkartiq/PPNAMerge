page 14021411 "NS_Job Quote Scope of Work"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Scope of Work';
    DelayedInsert = true;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    SourceTable = "NS_Job Quote Scope of Work";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.NS_Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Code';
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
                field("Line No."; Rec."NS_Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Line No.';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field("Description 2"; Rec."NS_Description 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description 2';
                }
                field(Details; Rec.NS_Details)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Details';
                }
            }
        }
    }

    actions
    {
    }
}

