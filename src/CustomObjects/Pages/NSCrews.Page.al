page 14021163 NS_Crews
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-949.GK.1.0 01Oct2021 | Added new fields

    PageType = List;
    Caption = 'Crews';
    SourceTable = NS_Crew;
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; NS_Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Code';
                }
                field(Description; NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                //PRJ-949.GK.1.0 01Oct2021 start
                field(NS_Active; Rec.NS_Active)
                {
                    ToolTip = 'Specifies the value of the Active field';
                    ApplicationArea = All;
                }
                field("NS_Active Crew Member"; Rec."NS_Active Crew Member")
                {
                    ToolTip = 'Specifies the value of the Total Crew Member field';
                    ApplicationArea = All;
                }
                field("NS_Inactive Crew Member"; Rec."NS_Inactive Crew Member")
                {
                    ToolTip = 'Specifies the value of the Total Crew Member field';
                    ApplicationArea = All;
                }
                field("NS_Total Crew Member"; Rec."NS_Total Crew Member")
                {
                    ToolTip = 'Specifies the value of the Total Crew Member field';
                    ApplicationArea = All;
                }
                //PRJ-949.GK.1.0 01Oct2021 end
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Crew)
            {
                Caption = 'Crew';
                Image = SerialNo;
                ToolTip = 'View Crew Lines';
                action(Lines)
                {
                    ApplicationArea = All;
                    Caption = 'Lines';
                    Image = AllLines;
                    RunObject = Page "NS_Crew Lines";
                    RunPageLink = NS_Code = FIELD(NS_Code);
                    ToolTip = 'View Crew Lines';
                }
            }
        }
    }
}

