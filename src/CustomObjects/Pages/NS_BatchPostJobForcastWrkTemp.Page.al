page 14021494 "NS_BatchPostJobForcastWrkTemp"
//PRJ-1098.NK.0.0 11Feb2022 New Report
//PE-93.RM.1.0 17May2023 | Caption Changed
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = NS_BatchPostJobForcastWrkTemp;
    // Caption = 'Batch Post Job Forcast Wrk Temp'; //PE-93.RM.1.0 17May2023 commented
    Caption = 'Job Forecasting Batch Posting Entries'; //PE-93.RM.1.0 17May2023 
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Job No.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Document No.';
                }
                field("As on Date"; Rec."As of Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'As of Date';
                }
                field("POC Method"; Rec."POC Method")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'POC Method';
                }
                field("Dept Code"; Rec."Dept Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Dept Code';
                }
                field("Div Code"; Rec."Div Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Div Code';
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}