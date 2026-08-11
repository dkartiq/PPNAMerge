page 14021166 "NS_APO Links Subform"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-1348.NK.1.0 26May2022 Caption Change
    PageType = ListPart;
    //Caption = 'APO Links Subform'; //PRJ-1348.NK.1.0 26May2022 Block
    Caption = 'APOS Links Subform';//PRJ-1348.NK.1.0 26May2022
    SourceTable = "NS_APO Links Line";


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Source Type"; Rec."NS_Source Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Source Type';
                }
                field("Source Activity Code"; Rec."NS_Source Activity Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Source Activity Code';
                }
                field("Source Process Code"; Rec."NS_Source Process Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Source Process Code';
                }
                field("Source Operation Code"; Rec."NS_Source Operation Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Source Operation Code';
                }

                field("NS_Source Section Code"; Rec."NS_Source Section Code")//PRJ-820
                {
                    ToolTip = 'Specifies the value of the Source Section Code';
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Source Category"; Rec."NS_Source Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Source Category';
                }

                field("Destination Type"; Rec."NS_Destination Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Destination Type';
                }
                field("Destination Activity Code"; Rec."NS_Destination Activity Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Destination Activity Code';
                }
                field("Destination Process Code"; Rec."NS_Destination Process Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Destination Process Code';
                }
                field("Destination Operation Code"; Rec."NS_Destination Operation Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Destination Operation Code';
                }
                field("NS_Destination Section Code"; Rec."NS_Destination Section Code")//PRJ-820
                {
                    ToolTip = 'Specifies the value of the Matching Section Code field';
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }

                field("Destination Category"; Rec."NS_Destination Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Destination Category';
                }

            }
        }
    }
}

