page 14021375 "NS_Employee Wage Rates"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    AutoSplitKey = true;
    Caption = 'Employee Wage Rates';
    PageType = List;
    SaveValues = true;
    SourceTable = "NS_Employee Wage Rate";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No."; Rec."NS_Employee No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Employee No.';
                    Visible = false;
                }
                field("Line No."; Rec."NS_Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Line No.';
                    Visible = false;
                }
                field("Skill Class"; '')//PE-68 DK.1.0 10April2023
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Skill Class';
                    Visible = false;//PE-68 DK.1.0 10April2023
                }
                //PE-68 Dk.1.0 10April2023 Start
                field("Skill Class New"; Rec."NS_Skill Class New")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Skill Class';
                }
                //PE-68 Dk.1.0 10April2023 End
                field("Work Type Code"; Rec."NS_Work Type Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Type Code';
                }
                field("Wage Rate"; Rec."NS_Wage Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Wage Rate';
                }
                field("Unit of Measure Code"; Rec."NS_Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit of Measure Code';
                }
                field("Fringe - Insurance"; Rec."NS_Fringe - Insurance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Fringe - Insurance';
                }
                field("Fringe - Vacation Time"; Rec."NS_Fringe - Vacation Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Fringe - Vacation Time';
                }
                field("Fringe - Education"; Rec."NS_Fringe - Education")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Fringe - Education';
                }
                field("Fringe - Misc. 1"; Rec."NS_Fringe - Misc. 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Fringe - Misc. 1';
                    Visible = false;
                }
                field("Fringe - Misc. 2"; Rec."NS_Fringe - Misc. 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Fringe - Misc. 2';
                    Visible = false;
                }
                field("Fringe - Misc. 3"; Rec."NS_Fringe - Misc. 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Fringe - Misc. 3';
                    Visible = false;
                }
                field("Fringe Total"; Rec."NS_Fringe Total")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Fringe Total';
                }
                field("Effective Date"; Rec."NS_Effective Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Effective Date';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1100773017; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}

