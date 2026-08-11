page 14021339 NS_JobQuoteList
{
    //PRJ-1250.RM.1.0 Created a New List Page
    //PRJ-1357.AS.1.0 Changed Usage category
    PageType = List;
    Editable = false;
    CardPageId = "Job Card";
    //ApplicationArea = All;//PRJ-1357.AS.1.0
    UsageCategory = None;//PRJ-1357.AS.1.0
    SourceTable = Job;
    Caption = 'Job Quote List';

    layout
    {
        area(Content)
        {
            repeater(group)
            {

                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("NS_Job Class"; Rec."NS_Job Class")
                {
                    ApplicationArea = all;
                    Caption = 'Job Class';
                }
                field("NS_Sub-Level to Job No."; Rec."NS_Sub-Level to Job No.")
                {
                    ApplicationArea = all;
                    Caption = 'Sub-Level to Job No.';
                }
                field("NS_Budgeted Cost (LCY)"; Rec."NS_Budgeted Cost (LCY)")
                {
                    ApplicationArea = all;
                    Caption = 'Budgeted Cost (LCY)';
                }
                field("NS_Budgeted Price (LCY)"; Rec."NS_Budgeted Price (LCY)")
                {
                    ApplicationArea = all;
                    Caption = 'Budgeted Price (LCY)';
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Search Description"; Rec."Search Description")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Caption = 'Dept Code';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = all;
                    Caption = 'Div Code';
                }
                field("NS_Last Forecast Posted Date"; Rec."NS_Last Forecast Posted Date")
                {
                    ApplicationArea = all;
                    Caption = 'Last Forecast Posted Date';

                }
                field("NS_Sell-to Customer No."; Rec."NS_Sell-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("NS_Sell-to Customer Name"; Rec."NS_Sell-to Customer Name")
                {
                    ApplicationArea = All;
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

    trigger OnOpenPage()
    var
        NoFilterCheck: Code[20];
        JobSetup: Record "Jobs Setup";
        NoSeriesLine: Record "No. Series Line";
    begin
        JobSetup.Get();
        NoSeriesLine.SetRange("Series Code", JobSetup."NS_Job Quote No. Series");
        NoSeriesLine.SetFilter("Starting No.", '<>%1', '');
        if NoSeriesLine.FindLast() then
            NoFilterCheck := CopyStr(NoSeriesLine."Starting No.", 1, 2) + '*';
        Rec.SetFilter("No.", '%1', NoFilterCheck);
    end;

    trigger OnAfterGetRecord()
    var
        NoFilterCheck: Code[20];
        JobSetup: Record "Jobs Setup";
        NoSeriesLine: Record "No. Series Line";
    begin
        JobSetup.Get();
        NoSeriesLine.SetRange("Series Code", JobSetup."NS_Job Quote No. Series");
        NoSeriesLine.SetFilter("Starting No.", '<>%1', '');
        if NoSeriesLine.FindLast() then
            NoFilterCheck := CopyStr(NoSeriesLine."Starting No.", 1, 2) + '*';
        Rec.SetFilter("No.", '%1', NoFilterCheck);
    end;
}