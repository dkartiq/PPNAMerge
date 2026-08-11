/// <summary>
/// Page MyPage (ID 140).
/// </summary>
//PRJ-1557.GK.1.0 26Aug2022|Add New Page
page 14021489 "NS_ResourceSkillClass"
{
    Caption = 'Resource Skill Classes';
    PageType = List;
    SaveValues = true;
    SourceTable = NS_ResourceSkillClass;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("NS_Skill Class Code"; Rec."NS_Skill Class Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Skill Class Code field.';
                }
                field("NS_Skill Class Description"; Rec."NS_Skill Class Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Skill Class Description field.';
                }
                field(NS_Default; Rec.NS_Default)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Default field.';
                }
            }
        }

    }


}