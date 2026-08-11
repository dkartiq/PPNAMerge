page 14021434 "NS_Excel Import List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Editable = false;
    Caption = 'Excel Import List';
    PageType = List;
    SourceTable = "NS_Export/Import Excel Header";
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            group(Control1100773004)
            {
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Job No.';
                }
            }
            repeater(Group)
            {
                field("Code"; Rec.NS_Code)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the code.';
                }
            }
        }
    }

    actions
    {
    }
}

