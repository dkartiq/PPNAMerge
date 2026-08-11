page 14021499 "NS_Work Type"
{
    //PRJ-464.AM.1.0 1DEC2020 | Added New Page.
    //PE-311.PP.1.0 11JUN2024 | Added "NS_Include Line" & "NS_Work Instructions" Field to print the instructions on work order report
    //PE-311.PP.1.0 11JUN2024 | Remove the Blank Action button
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
                //PE-311.PP.1.0 11JUN2024 start
                field("NS_Include Line"; Rec."NS_Include Line")
                {
                    ApplicationArea = All;
                }
                field("NS_Work Instructions"; Rec."NS_Work Instructions")
                {
                    ApplicationArea = All;
                }
                field("NS_Work Requested Date"; Rec."NS_Work Requested Date")
                {
                    ApplicationArea = All;
                }

                field("NS_Work Task No."; Rec."NS_Work Task No.")
                {
                    ApplicationArea = All;
                }
                field("NS_Work Task Description"; Rec."NS_Work Task Description")
                {
                    ApplicationArea = All;
                }
                //PE-311.PP.1.0 11JUN2024 end
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
                //PE-311.PP.1.0 11JUN2024 Start
                ObsoleteState = Pending;
                ObsoleteReason = 'Will be removed in next build';
                ObsoleteTag = 'ProjectPro upcoming release 24.0.XXX.00';
                //PE-311.PP.1.0 11JUN2024 End
                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}