page 14021160 "NS_Processes List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Processes List';
    PageType = List;
    SourceTable = "NS_Job Process";
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
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

    trigger OnInit();
    begin
        CurrPage.LOOKUPMODE := true;
    end;
}

