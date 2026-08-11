page 14021194 "NS_Job Custom Calendar Entries"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job Custom Calendar Entries';
    DataCaptionExpression = GetCaption();
    PageType = ListPlus;
    SourceTable = "NS_Job Custom Calendar Entry";
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Source Type"; Rec."NS_Source Type")
                {
                    ApplicationArea = All;
                    Caption = 'Source Type';
                    DrillDown = false;
                    ToolTip = 'Specifies the Source Type';
                }
                field("Job Calendar Code"; Rec."NS_Job Calendar Code")
                {
                    ApplicationArea = All;
                    Caption = 'Job Calendar Code';
                    Lookup = true;
                    ToolTip = 'Specifies the Job Calendar Code';
                }
            }
            part(JobCalendarEntries; "NS_Job Custom CalEntriesSubfm")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Custom Calendar")
            {
                Caption = '&Custom Calendar';
                action("&Job Monthly Calendar")
                {
                    ApplicationArea = All;
                    Caption = '&Job Monthly Calendar';
                    ToolTip = 'View the Job Monthly Calendar';

                    trigger OnAction();
                    var
                        GraphicCalendar: Page "Monthly Calendar";
                    begin
                        //ProjectPro - Start
                        // GraphicCalendar.SetCalendarCode(
                        //  2,"Source Type","Source Code","Additional Source Code","Job Calendar Code",
                        //  CurrPage.JobCalendarEntries.PAGE.GetCurrentDate);
                        // GraphicCalendar.RUN;
                        //ProjectPro - End
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("&Maintain Job Custom Calendar Changes")
                {
                    ApplicationArea = All;
                    Caption = '&Maintain Job Custom Calendar Changes';
                    RunObject = Page "NS_Job Custom Calendar Changes";
                    RunPageLink = "NS_Source Type" = FIELD("NS_Source Type"),
                                  "NS_Source Code" = FIELD(FILTER("NS_Source Code")),
                                  "NS_Additional Source Code" = FIELD("NS_Additional Source Code"),
                                  "NS_Job Calendar Code" = FIELD("NS_Job Calendar Code");
                    ToolTip = 'Maintain Job Custom Calendar Changes';
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        CurrPage.JobCalendarEntries.PAGE.NS_SetJobCalendarCode("NS_Source Type", "NS_Source Code", "NS_Additional Source Code", "NS_Job Calendar Code");
    end;
}

