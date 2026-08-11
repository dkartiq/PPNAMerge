/// <summary>
/// Page NS_Accidents And SafetyIssue  (ID 14021461).
/// </summary>
/// //PE-168.PS.1.0 18Sep2023 New page create
 //PE-168.HS.1.0 10Nov2023| Removed Doc job no. and Entry Date field 

page 14021461 "NS_Accidents SafetyIssue"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    Caption = 'Safety Issues/Accidents';
    SourceTable = "NS_Daily JOb Log Sub.";
    SourceTableView = sorting("Document Type", "Documnet No.", "Line No.") WHERE("Document Type" = FILTER(Accidents));
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Accidents / Safety Issues"; Rec."Accidents / Safety Issues")
                {
                    ApplicationArea = All;
                    Caption = 'Safety Issues/Accidents';
                }
                field(Remark; Rec.Remark)
                {
                    ApplicationArea = All;
                    Caption = 'Comment';  //PE-168.HS.1.0 16Nov2023
                }
                field("Remark 2"; Rec."Remark 2")
                {
                    ApplicationArea = All;
                    Caption = 'Comment 2';  //PE-168.HS.1.0 16Nov2023
                }
            }
        }
    }
}