page 14021236 "NS_TimesheetCustomizeCard"
{
    //PRJ-772.AS.1.0 12July2021 New page
    Caption = 'Crew Time Sheet';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = NS_TimesheetHdrCustom;


    layout
    {
        area(Content)
        {
            group(NS_General)
            {
                Caption = 'General';
                field("NS_No."; Rec."NS_No.")
                {
                    Caption = 'Timesheet No.';
                    ApplicationArea = All;


                    trigger OnAssistEdit();
                    begin
                        if AssistEdit(xRec) then
                            CurrPage.UPDATE();
                    end;
                }
                field(NS_Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                }
                field("NS_Created By"; Rec."NS_Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field';
                    ApplicationArea = All;
                }
                field("NS_Creation Date"; Rec."NS_Creation Date")
                {
                    ToolTip = 'Specifies the value of the Creation Date field';
                    ApplicationArea = All;
                }

                field("NS_Work Period Start Date "; Rec."NS_Work Period Start Date ")
                {
                    ApplicationArea = All;
                    Visible = false;
                    trigger OnValidate()
                    var
                        Text010: Label 'Starting Date must be %1.';
                        HumanResSetup: Record "Human Resources Setup";
                        ResourcesSetup: record "Resources Setup";
                    begin
                        HumanResSetup.Get();
                        if Date2DWY("NS_Work Period Start Date ", 1) <> ResourcesSetup."Time Sheet First Weekday" + 1 then
                            Error(Text010, ResourcesSetup."Time Sheet First Weekday");

                        if NS_TimeSheetCrewWorkDays = 1 then
                            "NS_Work Period End Date " := "NS_Work Period Start Date "
                        else
                            "NS_Work Period End Date " := CalcDate('+' + Format(NS_TimeSheetCrewWorkDays - 1) + 'D', "NS_Work Period Start Date ")
                    end;
                }
                field("NS_Work Period End Date "; Rec."NS_Work Period End Date ")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("NS_Working Hours"; Rec."NS_Working Hours")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(NS_TimeSheetCrewWorkDays; Rec.NS_TimeSheetCrewWorkDays)
                {
                    ApplicationArea = All;
                    Visible = false;

                    trigger OnValidate()
                    var
                        Text010: Label 'Starting Date must be %1.';
                        HumanResSetup: Record "Human Resources Setup";
                        ResourcesSetup: record "Resources Setup";
                    begin
                        HumanResSetup.Get();

                        if NS_TimeSheetCrewWorkDays = 1 then
                            "NS_Work Period End Date " := "NS_Work Period Start Date "
                        else
                            "NS_Work Period End Date " := CalcDate('+' + Format(NS_TimeSheetCrewWorkDays - 1) + 'D', "NS_Work Period Start Date ")
                    end;
                }
            }
            part(DetailLines; NS_TimesheetCustomizedSubform)
            {
                ApplicationArea = all;
                SubPageLink = "NS_TimeSheetNo." = FIELD("NS_No.");
                UpdatePropagation = Both;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(NS_CopyCrew)
            {
                ApplicationArea = Jobs;
                Caption = 'Generate Time Entry';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Copy Crew';

                trigger OnAction()
                var
                    CopyCrewTSReport: Report "NS_CopyCrew to CustomTimesheet";

                    TimesheetCustHeader: Record NS_TimesheetHdrCustom;
                begin
                    TimesheetCustHeader.Reset();
                    TimesheetCustHeader.SetRange("NS_No.", Rec."NS_No.");
                    if TimesheetCustHeader.FindFirst() then
                        Report.RunModal(14021390, true, false, TimesheetCustHeader);
                end;
            }

            action(NS_CreateTimeSheetEntry)
            {
                ApplicationArea = Jobs;
                Caption = 'Submit TimeSheet';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Submit TimeSheet';

                trigger OnAction()
                var
                begin
                    if not Confirm('Do you want to submit the Crew Time Sheet Entries') then
                        exit
                    else begin
                        Rec.NS_MakeTimesheetEntry(Rec."NS_No.");
                        CurrPage.Update(true);
                    end;

                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

        HRSetup.Get();

        "NS_Working Hours" := HRSetup.NS_CustomTimesheetCrewWorkingHrs;
        NS_TimeSheetCrewWorkDays := 1;
    end;

    trigger OnOpenPage()
    begin

    end;

    trigger OnAfterGetRecord()
    begin
        CurrPage.DetailLines.Page.Editable := Rec.NS_Status IN [Rec.NS_Status::Open, Rec.NS_Status::Rejected];

    end;

    var
        HRSetup: Record "Human Resources Setup";
        [InDataSet]
        AllowEdit: Boolean;

}