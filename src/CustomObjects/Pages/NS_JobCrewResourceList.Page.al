/// <summary>
/// Page NS_ Job Crew Resource List (ID 14021268).
/// </summary>
//PRJ-991.GK.2.0 22Oct2021 | Add new page.

page 14021268 "NS_ Job Crew Resource List"
{
    ApplicationArea = All;
    PageType = List;
    SourceTable = "NS_Job Crew Resource";
    UsageCategory = Lists;
    Caption = 'Job Crew Resources';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DataCaptionFields = "NS_Resource No.";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("NS_Crew Code"; Rec."NS_Crew Code")
                {
                    ToolTip = 'Specifies the value of the Crew Code field.';
                    ApplicationArea = All;
                    Editable = false;//PRJ-991.GK.2.0 22Oct2021
                }
                field("NS_Job No."; Rec."NS_Job No.")
                {
                    ToolTip = 'Specifies the value of the Job No. field.';
                    ApplicationArea = All;
                    Editable = false; //PRJ-991.GK.2.0 22Oct2021
                }
                field("NS_Resource No."; Rec."NS_Resource No.")
                {
                    ToolTip = 'Specifies the value of the Resource No. field.';
                    ApplicationArea = All;
                    Visible = false;//PRJ-991.GK.2.0 22Oct2021
                    Editable = false;
                }
                //PRJ-991.GK.2.0 22Oct2021 start
                field("NS_Job Status"; Rec."NS_Job Status")
                {
                    ToolTip = 'Specifies the value of the _Job Status field.';
                    ApplicationArea = All;
                    Editable = false; //PRJ-991.GK.2.0 22Oct2021
                }
                //PRJ-991.GK.2.0 22Oct2021 end
            }
        }

    }


}