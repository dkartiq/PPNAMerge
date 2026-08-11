page 14021499 "NS_Work Type"
{
    //PRJ-464.AM.1.0 1DEC2020 | Added New Page.
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "NS_Work Type Info";
    Caption = 'Work Completed';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                ShowCaption = false;
                field("NS_Job No."; "NS_Job No.")
                {
                    ApplicationArea = All;
                }
                field(NS_Date; NS_Date)
                {
                    ApplicationArea = all;
                }
                field("NS_Work Type"; "NS_Work Type")
                {
                    ApplicationArea = all;
                }
                field("NS_Work Description"; "NS_Work Description")
                {
                    ApplicationArea = all;
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