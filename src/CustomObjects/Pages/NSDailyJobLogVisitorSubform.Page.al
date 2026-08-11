/// <summary>
/// Page NS_Daily Job task Subfrom (ID 14021462).
/// </summary>
/// //PE-168.PS.1.0 18Sep2023 New page create
//PE-168.HS.1.0 10Nov2023| Removed Doc job no. and Entry Date field 
page 14021464 "NS_Daily Job Visitors Subfrom"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    Caption = 'Visitors';
    SourceTable = "NS_Daily JOb Log Sub.";
    SourceTableView = sorting("Document Type", "Documnet No.", "Line No.") WHERE("Document Type" = FILTER(Visitors));
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Contacts No."; Rec."Contacts No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contacts No. field.';
                }
                field("Contacts Name"; Rec."Contacts Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contacts Name field.';
                }
                //PE-168.DK.1.0 01NOV2023 Start
                field(NS_VisitTime; Rec.NS_VisitTime)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Visit Time field.';
                }
                //PE-168.DK.1.0 01NOV2023 End
                field(Remark; Rec.Remark)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remark field.';
                    Caption = 'Comment';  //PE-168.HS.1.0 16Nov2023

                }
                field("Remark 2"; Rec."Remark 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remark 2 field.';
                    Caption = 'Comment 2';  //PE-168.HS.1.0 16Nov2023

                }


            }
        }
    }
}