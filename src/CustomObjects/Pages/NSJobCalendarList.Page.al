page 14021189 "NS_Job Calendar List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job Calendar List';
    CardPageID = "NS_Job Calendar Card";
    Editable = false;
    PageType = List;
    SourceTable = "NS_Job Calendar";
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code"; Rec.NS_Code)
                {
                    ApplicationArea = All;
                    Caption = 'Code';
                    ToolTip = 'Specifies the Code';
                }
                field(Name; Rec.NS_Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Name';
                }
                field("Custom Changes Exist"; Rec."NS_Custom Changes Exist")
                {
                    ApplicationArea = All;
                    Caption = 'Job Custom Changes Exist';
                    ToolTip = 'Specifies whether Job Custom Changes Exist';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Job Calendar")
            {
                Caption = '&Job Calendar';
                action("&Card")
                {
                    ApplicationArea = All;
                    Caption = '&Card';
                    Image = EditLines;
                    RunObject = Page "NS_Job Calendar Card";
                    RunPageLink = NS_Code = FIELD(NS_Code);
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View the job calendar card.';
                }
                action("&Where-Used List")
                {
                    ApplicationArea = All;
                    Caption = '&Where-Used List';
                    Image = Track;
                    ToolTip = 'View the where used list.';

                    trigger OnAction();
                    var
                        CalendarMgmt: Codeunit "Calendar Management";
                        WhereUsedList: Page "Where-Used Base Calendar";
                    begin
                        CalendarMgmt.CreateWhereUsedEntries(NS_Code);
                        WhereUsedList.RUNMODAL;
                        CLEAR(WhereUsedList);
                    end;
                }
                separator("-")
                {
                    Caption = '-';
                }
                action("&Job Calendar Changes")
                {
                    ApplicationArea = All;
                    Caption = '&Job Calendar Changes';
                    Image = Change;
                    RunObject = Page "NS_Job Calendar Changes";
                    RunPageLink = "NS_Job Calendar Code" = FIELD(NS_Code);
                    ToolTip = 'View the Job Calendar Changes.';
                }
            }
        }
    }

    trigger OnInit();
    begin
        CurrPage.LOOKUPMODE := true;
    end;
}

