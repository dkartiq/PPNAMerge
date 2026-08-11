
page 14021366 "NSNumberFilter List"
{
    //PRJ-1474.NK.1.0 26July2022 New Page create
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "NSNumberFilter";
    Caption = 'Drop Down List';
    layout
    {
        area(Content)
        {

            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("No."; Rec."No.")
                {

                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
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
                ToolTip = 'Executes the ActionName action.';

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}