page 14021188 "NS_Job Calendar Card"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job Calendar Card';
    PageType = ListPlus;
    SourceTable = "NS_Job Calendar";
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
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
                    Caption = 'Custom Changes Exist';
                    ToolTip = 'Specifies whether Custom Changes Exist';
                }
            }
            part(JobCalendarEntries; "NS_Job CalendarEntriesSubform")
            {
                ApplicationArea = All;
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
                action("&Where-Used List")
                {
                    ApplicationArea = All;
                    Caption = '&Where-Used List';
                    Image = Track;
                    ToolTip = 'View the where used list.';

                    trigger OnAction();
                    var
                        JobCalendarMgt: Codeunit "NS_Job Calendar Management";
                        WhereUsedListJob: Page "NS_Where-Used Job Calendar";
                    begin
                        JobCalendarMgt.NS_CreateWhereUsedEntries(NS_Code);
                        WhereUsedListJob.RUNMODAL;
                        CLEAR(WhereUsedListJob);
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("&Maintain Job Calendar Changes")
                {
                    ApplicationArea = All;
                    Caption = '&Maintain Job Calendar Changes';
                    Image = Edit;
                    RunObject = Page "NS_Job Calendar Changes";
                    RunPageLink = "NS_Job Calendar Code" = FIELD(NS_Code);
                    ToolTip = 'Maintain Job Calendar Changes';
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        CurrPage.JobCalendarEntries.PAGE.NS_SetJobCalendarCode(NS_Code);
    end;
}

