page 14021445 "NS_Assembly BOM List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Assembly BOM List';
    CardPageID = "NS_Assembly BOM Card";
    PageType = List;
    SourceTable = "NS_Assembly BOM Header";
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            repeater(Group)
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
                    ToolTip = '"Specifies the Vendor No.Specifies the "';
                }
            }
        }
    }

    actions
    {
    }
}

