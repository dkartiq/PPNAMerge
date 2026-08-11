page 14021446 "NS_Assembly BOM Card"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Assembly BOM Card';
    PageType = Card;
    SourceTable = "NS_Assembly BOM Header";
    UsageCategory = Documents;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field("Vendor No."; Rec."NS_Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Vendor No.';
                }
            }
            part(Lines; "NS_Assembly BOM Lines")
            {
                ApplicationArea = All;
                Caption = 'Lines';
                SubPageLink = "NS_Assemby BOM No." = FIELD("NS_No.");
            }
        }
        area(factboxes)
        {
            systempart(Control1100773006; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}

