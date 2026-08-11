/// <summary>
/// Page NS_ Job Crew List (ID 14021267).
/// </summary>
/// //PRJ-949.GK.1.0 01Oct2021 | Add new Page
//PRJ-991.GK.1.0 14Oct2021 |Drildown page list
page 14021267 "NS_ Job Crew List"
{
    ApplicationArea = All;
    PageType = List;
    SourceTable = "NS_Job Crews";
    UsageCategory = Lists;
    Caption = 'Job Crews';
    DataCaptionFields = "NS_Job No."; //PRJ-991.GK.2.0 26Oct2021
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("NS_Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the _Job No. field';
                    Visible = false; //PRJ-991.GK.2.0 26Oct2021
                }
                field("NS_Crew Code"; Rec."NS_Crew Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the _Crew Code field';
                }
                field("NS_Lead Person"; Rec."NS_Lead Person")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the _Lead Person field';
                }
                field("NS_Lead Person Name"; Rec."NS_Lead Person Name")
                {
                    ToolTip = 'Specifies the value of the Lead Person Name field';
                    ApplicationArea = All;
                }
                field(NS_Active; Rec.NS_Active)
                {
                    ToolTip = 'Specifies the value of the Active field';
                    ApplicationArea = All;
                }

                field("NS_Active Crew Member"; Rec."NS_Active Crew Member")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Active Crew Member field';
                    //DrillDownPageId = 14021164; //PRJ-991.GK.1.0 14Oct2021 //PRJ-991.GK.2.0 22Oct2021 - comment
                    //PRJ-991.GK.2.0 22Oct2021 start
                    trigger OnDrillDown()
                    var
                        CrewLines: Record "NS_Crew Line";
                        CrewLinesPages: Page "NS_Crew Lines";
                    begin
                        CrewLines.Reset();
                        CrewLines.FilterGroup(2);
                        CrewLines.SetRange(NS_Code, Rec."NS_Crew Code");
                        CrewLines.SetRange(NS_Active, true);
                        CrewLines.FilterGroup(0);
                        CrewLinesPages.SetTableView(CrewLines);
                        CrewLinesPages.RunModal();
                    end;
                    //PRJ-991.GK.2.0 22Oct2021 end
                }
                field("NS_Inactive Crew Member"; Rec."NS_Inactive Crew Member")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Inactive Crew Member field';
                    //DrillDownPageId = 14021164; //PRJ-991.GK.1.0 14Oct2021 //PRJ-991.GK.2.0 22Oct2021 comment
                    //PRJ-991.GK.2.0 22Oct2021 start
                    trigger OnDrillDown()
                    var
                        CrewLines: Record "NS_Crew Line";
                        CrewLinesPages: Page "NS_Crew Lines";
                    begin
                        CrewLines.Reset();
                        CrewLines.FilterGroup(2);
                        CrewLines.SetRange(NS_Code, Rec."NS_Crew Code");
                        CrewLines.SetRange(NS_Active, false);
                        CrewLines.FilterGroup(0);
                        CrewLinesPages.SetTableView(CrewLines);
                        CrewLinesPages.RunModal();
                    end;
                    //PRJ-991.GK.2.0 22Oct2021 end
                }
                field("NS_Total Crew Member"; Rec."NS_Total Crew Member")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Crew Member field';
                    //DrillDownPageId = 14021164; //PRJ-991.GK.1.0 14Oct2021 //PRJ-991.GK.2.0 22Oct2021 comment
                    //PRJ-991.GK.2.0 22Oct2021 start
                    trigger OnDrillDown()
                    var
                        CrewLines: Record "NS_Crew Line";
                        CrewLinesPages: Page "NS_Crew Lines";
                    begin
                        CrewLines.Reset();
                        CrewLines.FilterGroup(2);
                        CrewLines.SetRange(NS_Code, Rec."NS_Crew Code");
                        CrewLines.FilterGroup(0);
                        CrewLinesPages.SetTableView(CrewLines);
                        CrewLinesPages.RunModal();
                    end;
                    //PRJ-991.GK.2.0 22Oct2021 end
                }
            }
        }
    }


}