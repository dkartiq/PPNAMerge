page 14021159 "NS_Activities List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-881.JS.1.0 25Aug2021 | Add field

    Caption = 'Activities List';
    PageType = List;
    SourceTable = "NS_Job Activity";
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
                field("NS_Job Setup Job Quote"; Rec."NS_Job Setup Job Quote")   //PRJ-881.JS.1.0 25Aug2021
                {
                    ToolTip = 'Specifies the value of the Billing and Totaling field on Job Setup for Job Quote';
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }

    trigger OnInit();
    begin
        CurrPage.LOOKUPMODE := true;
    end;
}

