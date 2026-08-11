/// <summary>
/// Page NSPP1 Punch list (ID 14021338).
/// </summary>
page 14021338 "NS_Punch list"
{
    //PE-288.JS.1.0 06MAY2024 | Created new Page
    PageType = List;
    Editable = false;
    ApplicationArea = All;
    CardPageId = "NS Punch List Card";
    UsageCategory = Lists;
    SourceTable = "NS_Punch List Header";
    Caption = 'Punch List';

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("NS_PunchListNo."; Rec."NS_PunchListNo.")
                {
                    Caption = 'Punch List No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the NS_PunchListNo. field.';
                }
                field("NS_Job No."; Rec."NS_Job No.")
                {
                    Caption = 'Job No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the NS_Job No. field.';
                }

                field(NS_Description; Rec.NS_Description)
                {
                    Caption = 'Description';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the NS_Description field.';
                }
                field(NS_Status; Rec.NS_Status)
                {
                    Caption = 'Status';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the NS_Status field.';
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