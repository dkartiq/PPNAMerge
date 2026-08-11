page 14021377 "NS_Employee Burden Details"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    AutoSplitKey = true;
    Caption = 'Employee Burden Details';
    PageType = List;
    SaveValues = true;
    SourceTable = "NS_Employee Burden Detail";

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
                field("Burden Type"; Rec."NS_Burden Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Burden Type';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field("Burden Rate Type"; Rec."NS_Burden Rate Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Burden Rate Type';
                }
                field("Burden Rate per Hour"; Rec."NS_Burden Rate per Hour")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Burden Rate per Hour';
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
            systempart(Control1100773008; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}

