
page 14021367 "NSJobTaskNoFilter List"
{
    //PRJ-1545.AS.1.0 26July2022 New Page create
    PageType = List;
    //PE-108.Dk.1.0 7may2023 Start
    // ApplicationArea = All;
    //UsageCategory = Lists;
    //PE-108.Dk.1.0 7may2023 End
    SourceTable = "NSNumberFilter";
    Caption = 'Job Task No.';
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    Caption = 'Job Task No.';
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