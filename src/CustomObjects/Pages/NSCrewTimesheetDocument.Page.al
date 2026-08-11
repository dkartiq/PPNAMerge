/// <summary>
/// Page NS_TimesheetCustomizeDocument (ID 14021236).
/// </summary>
page 14021147 "NS_TimesheetCustomizeDocument"
{
    //PRJCTPR-28.GK.1.0 16March2023|Add New Page
    //PE-75.RM.1.0 17May2023 | Added tootlips
    Caption = 'Crew Time Sheet Document';
    PageType = Document;
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
                    ToolTip = 'Specifies the Crew Time Sheet Number which is automatically generated on the header level through the Number Series.'; //PE-75.RM.1.0 17May2023
                    ApplicationArea = All;


                    trigger OnAssistEdit();
                    begin
                        if Rec.AssistEdit(xRec) then //PRJ-1131.NK.1.0
                            CurrPage.UPDATE();
                    end;
                }
                field(NS_Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Crew Time Sheet Description which can be filled manually.';  //PE-75.RM.1.0 17May2023
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
                    ToolTip = 'Specifies the Date when the Resource is Working. ';  //PE-75.RM.1.0 17May2023
                    Visible = false;
                    trigger OnValidate()
                    var
                        Text010: Label 'Starting Date must be %1.';
                        HumanResSetup: Record "Human Resources Setup";
                        ResourcesSetup: record "Resources Setup";
                    begin
                        HumanResSetup.Get();
                        if Date2DWY(Rec."NS_Work Period Start Date ", 1) <> ResourcesSetup."Time Sheet First Weekday" + 1 then //PRJ-1131.NK.1.0
                            Error(Text010, ResourcesSetup."Time Sheet First Weekday");

                        if Rec.NS_TimeSheetCrewWorkDays = 1 then //PRJ-1131.NK.1.0
                            Rec."NS_Work Period End Date " := Rec."NS_Work Period Start Date " //PRJ-1131.NK.1.0
                        else
                            Rec."NS_Work Period End Date " := CalcDate('+' + Format(Rec.NS_TimeSheetCrewWorkDays - 1) + 'D', Rec."NS_Work Period Start Date ") //PRJ-1131.NK.1.0
                    end;
                }
                field("NS_Work Period End Date "; Rec."NS_Work Period End Date ")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the End Date for the working of Resource.';  //PE-75.RM.1.0 17May2023
                }
                field("NS_Working Hours"; Rec."NS_Working Hours")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the hours the Resource is working in a day.'; //PE-75.RM.1.0 17May2023
                }
                //PRJ-1144.JS.1.0 06FEB2022
                field("NS_Total Line"; Rec."NS_Total Line")
                {
                    ToolTip = 'Specifies the value of the Total Crew Timesheet Lines';
                    ApplicationArea = All;
                    Editable = false;
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

                        if Rec.NS_TimeSheetCrewWorkDays = 1 then //PRJ-1131.NK.1.0
                            Rec."NS_Work Period End Date " := rec."NS_Work Period Start Date " //PRJ-1131.NK.1.0
                        else
                            Rec."NS_Work Period End Date " := CalcDate('+' + Format(Rec.NS_TimeSheetCrewWorkDays - 1) + 'D', Rec."NS_Work Period Start Date ") //PRJ-1131.NK.1.0
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

        Rec."NS_Working Hours" := HRSetup.NS_CustomTimesheetCrewWorkingHrs; //PRJ-1131.NK.1.0
        Rec.NS_TimeSheetCrewWorkDays := 1; //PRJ-1131.NK.1.0
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