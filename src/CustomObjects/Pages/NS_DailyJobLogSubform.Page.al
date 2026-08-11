/// <summary>
/// Page NS_DailyJobLogSubform  (ID 14021455).
/// </summary>
/// //PE-168.PS.1.0 18Sep2023 New page create
//PE-168.HS.1.0 10Nov2023| Removed Doc job no. and Entry Date field 
page 14021460 "NS_DailyJobLogSubform"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    Caption = 'Risks/Delay';
    SourceTable = "NS_Daily JOb Log Sub.";
    SourceTableView = sorting("Document Type", "Documnet No.", "Line No.") WHERE("Document Type" = FILTER(Risks));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Risk/ Delay"; Rec."Risk/ Delay")
                {
                    ApplicationArea = All;
                }
                field(Remark; Rec.Remark)
                {
                    ApplicationArea = All;
                    Caption = 'Comment';   //PE-168.HS.1.0 16Nov2023
                }
                field("Remark 2"; Rec."Remark 2")
                {
                    ApplicationArea = All;
                    Caption = 'Comment 2';   //PE-168.HS.1.0 16Nov2023
                }
            }
        }
    }
    var
        NSDailyJobLog: record "NS_Daily Job Log";

}