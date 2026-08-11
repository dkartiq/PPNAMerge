page 14021498 NS_SectionsList
{
    //PRJ-688.AM.1.0 Created New Page .
    Caption = 'Sections List';
    PageType = List;
    SourceTable = NS_Sections;
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(Content)
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

