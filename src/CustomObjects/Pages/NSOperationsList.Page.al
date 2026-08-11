page 14021161 "NS_Operations List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-917.NK.1.0 09Mar2022 | Add One Field
    Caption = 'Operations List';
    PageType = List;
    SourceTable = "NS_Job Operation";
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
                //PRJ-917.NK.1.0 09Mar2022 Start
                field(NS_Blocked; Rec.NS_Blocked)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Blocked';
                }
                //PRJ-917.NK.1.0 09Mar2022 End
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

