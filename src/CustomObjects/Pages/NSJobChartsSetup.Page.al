
/// <summary>
/// Page NS_Job_Chart Setup (ID 14021119).
/// </summary>
/// PE-115.JS.1.0 03July2023 New Pages
page 14021119 "NS_Job_Chart Setup"
{
    Caption = 'Job Chart Setup';
    PageType = StandardDialog;
    UsageCategory = Administration;
    DeleteAllowed = false;
    InsertAllowed = false;
    SourceTable = "NS_Job_Chart Setup";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("NS_Chart Type"; Rec."NS_Chart Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Chart Type field.';
                }
                field("NS_Job Values"; Rec."NS_Job Values")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Job Values field.';
                    Editable = false;
                }
                field("NS_Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Job No. field.';
                    Caption = 'Job No.';
                }
                field("NS_Project Manager No."; Rec."NS_Project Manager No.")
                {
                    Caption = 'Project Manager No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Project Manager No. field.';
                }
                field("NS_ChartStatus"; Rec.NS_ChartStatus)
                {
                    Caption = 'Status';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("NS_Gen. Bus. Posting Group"; Rec."NS_Gen. Bus. Posting Group")
                {
                    Caption = 'Gen. Bus. Posting Group';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gen. Business Posting Group field.';
                }
                field("NS_Hours Details"; Rec."NS_Hours Details")
                {
                    caption = 'Budget Vs Usage Hours Details';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Budget Vs Usage Hours Details field.';
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
        NSJobChartSetup: Record "NS_Job_Chart Setup";
    begin
        if Rec.FindFirst() then
            Rec.DeleteAll();
        if not rec.get(UserId) then begin
            rec."NS_User ID" := UserId;
            rec."NS_Job Values" := rec."NS_Job Values"::"$ Value";
            rec.Insert();
        end;
        rec.FilterGroup(2);
        Rec.SetRange("NS_User ID", UserId);
        rec.FilterGroup(0);
    end;

}