page 14021376 "NS_Burden Types"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    //PRJ-402.MS.1.0 aaded property for showing in RTC
    // +------------------------------------------------------------

    Caption = 'Burden Types';
    PageType = List;
    SourceTable = "NS_Burden Type";
    UsageCategory = Lists; //PRJ-402
    ApplicationArea = All;//PRJ-402

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
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field("Default Rate Type"; Rec."NS_Default Rate Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Default Rate Type';
                }
            }
        }
    }

    actions
    {
    }
}

