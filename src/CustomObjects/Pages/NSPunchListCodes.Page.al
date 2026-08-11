/// <summary>
/// Page NSPP1_Punch List Codes (ID 14021111).
/// </summary>
page 14021111 "NS_Punch List Codes"
{
    //PE-288.JS.1.0  06MAT2024 | Created new Page
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "NS_Punch List Code";
    Caption = 'Punch List Codes';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("NS_Punch List Code"; Rec."NS_Punch List Code")
                {
                    Caption = 'Punch List Code';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Punch List Code field.';
                }
                field(NS_Description; Rec.NS_Description)
                {
                    Caption = 'Description';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
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