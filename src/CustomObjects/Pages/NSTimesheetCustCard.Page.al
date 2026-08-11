page 14021236 "NS_TimesheetCustomizeCard"
{
    //PRJ-772.AS.1.0 12July2021 New page
    //PRJ-1131.NK.1.0 12Jan2022 | Removed with statement
    //PRJ-1055.RM.1.0 19Nov2021 | Created Action Button
    //PRJ-1144.JS.1.0 06FEB2022 | Add fields
    //PE-68.Dk.1.0 13june2023 | Added Some Code
    //PE-156.HS.1.0. 31August2023 | Added New Action 
    Caption = 'Crew Time Sheet';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = NS_TimesheetHdrCustom;
    RefreshOnActivate = true;   //PE-152.JS.1.0 28Aug2023

    layout
    {
        area(Content)
        {
            group(NS_General)
            {
                Caption = 'General';
                field("NS_No."; Rec."NS_No.")
                {
                    Caption = 'Time Sheet No.'; //PE-156.HS.1.0 12Sept2023
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
                    Visible = true;  //PE-260.JS.1.0 12MAR2024 make visible true previeus value is false
                    //Editable = true;  //PE-260.JS.1.0 12MAR2024 make editable true previeus value is false //PE-224.JS.1.0 21MAR2024 line commented //FGH-163 //PE-269.JS.1.0
                    trigger OnValidate()
                    var
                        Text010: Label 'Starting Date must be %1.';
                        HumanResSetup: Record "Human Resources Setup";
                        ResourcesSetup: record "Resources Setup";
                    begin
                        HumanResSetup.Get();
                        if ResourcesSetup.get() then; //FGH-163 //PE-269.JS.1.0
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
                    //Editable = false;  //FGH-163 //PE-269.JS.1.0
                    //Visible = false;  PRJCTPR-247.JS.1.0
                    Visible = true;  //PE-260.JS.1.0 12MAR2024 make visible true previeus value is false
                }
                field("NS_Working Hours"; Rec."NS_Working Hours")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                //PRJ-1144.JS.1.0 06FEB2022
                field("NS_Total Line"; Rec."NS_Total Line")
                {
                    ToolTip = 'Specifies the value of the Total Crew Timesheet Lines';
                    ApplicationArea = All;
                    Editable = false;
                }
                //PE-152.JS.1.0 23-Aug-2023 - Start
                field("NS_Blank Date on Lines"; Rec."NS_Blank Date on Lines")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Blank Date on Lines field.';
                    Visible = false;
                }
                //PE-152.JS.1.0 23-Aug-2023 - end

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
                Caption = 'Submit Time Sheet'; //PE-156.HS.1.0 12Sept2023
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Submit Time Sheet';  //PE-156.HS.1.0 12Sept2023

                trigger OnAction()
                var
                    //PRJ-1455.RM.1.0 start
                    TimeSheetPage: Page NS_TimesheetCustomizedSubform;
                    TimeSheetCusTab: Record NS_TimeSheetLineCustom;
                    TimeSheetCusTab2: Record NS_TimeSheetLineCustom;
                    HumanResSteup: Record "Human Resources Setup"; //PE-68.DK.1.0 Start
                    TFlag: Boolean;
                    CrewNo: Code[20];
                    I: Integer;
                //PRJ-1455.RM.1.0 end
                begin
                    if not Confirm('Do you want to submit the Crew Time Sheet Entries') then
                        exit;
                    //PE-152.JS.1.0 23-Aug-2023-Start
                    rec.CalcFields("NS_Blank Date on Lines");
                    if rec."NS_Blank Date on Lines" > 0 then
                        error('Please update working date on lines');
                    if rec."NS_Blank Date on Lines" = 0 then begin
                        rec.testfield("NS_Work Period Start Date ");
                        rec.testfield("NS_Work Period End Date ");
                    end;
                    //PE-152.JS.1.0 23-Aug-2023-end    
                    //else begin
                    //PRJ-1455.RM.1.0 start 
                    TFlag := true;
                    CrewNo := '';
                    CurrPage.DetailLines.Page.GetRecords(TimeSheetCusTab);
                    //PE-68.Dk.1.0 13june2023 Start
                    //   IF TimeSheetCusTab.FindSet() then
                    //         repeat
                    //             Rec.NS_MakeTimesheetEntry(TimeSheetCusTab."NS_TimeSheetNo.", TimeSheetCusTab."NS_LineNo.", TFlag);
                    //             TFlag := false;
                    //         until TimeSheetCusTab.Next() = 0;
                    if HumanResSteup.Get() then;
                    if (HumanResSteup."NS_Activate Skill Class") then begin
                        TimeSheetCusTab2.Reset();
                        TimeSheetCusTab2.SetFilter("NS_TimeSheetNo.", Rec."NS_No.");
                        TimeSheetCusTab2.SetFilter("NS_Skill Code New", '%1', '');
                        IF TimeSheetCusTab2.FindFirst() then
                            TimeSheetCusTab2.TestField("NS_Skill Code New");
                        IF TimeSheetCusTab.FindFirst() then begin
                            repeat
                                Rec.NS_MakeTimesheetEntry1(TimeSheetCusTab."NS_TimeSheetNo.", TimeSheetCusTab."NS_LineNo.", TFlag);
                                TFlag := false;
                            until TimeSheetCusTab.Next() = 0;
                        end;
                    end else
                        IF TimeSheetCusTab.FindFirst() then begin
                            repeat
                                Rec.NS_MakeTimesheetEntry1(TimeSheetCusTab."NS_TimeSheetNo.", TimeSheetCusTab."NS_LineNo.", TFlag);
                                TFlag := false;
                            until TimeSheetCusTab.Next() = 0;
                        end;
                end;
                //PE-68.DK.1.0 13june2023 End

                //       Rec.NS_MakeTimesheetEntry(TimeSheetCusTab."NS_TimeSheetNo.");
                //         CurrPage.Update(true);
                //PRJ-1455.RM.1.0 end
                //  end;


            }
        }

        //PRJ-1055.RM.1.0 19Nov2021 Start
        area(Reporting)
        {
            action(NS_Report)
            {
                ApplicationArea = Jobs;
                Caption = 'Crew Time Sheet List';
                Image = Report;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Crew Time Sheet List';
                trigger OnAction()
                var
                    CrewTimeSht: Record NS_TimeSheetLineCustom;
                    CrewHdr: Record NS_TimesheetHdrCustom;
                    CrewTimeReport: Report NS_CrewTimeSheetList;
                begin
                    CrewHdr.SetRange("NS_No.", Rec."NS_No.");
                    REPORT.RUNMODAL(REPORT::NS_CrewTimeSheetList, true, false, CrewHdr);
                end;
            }
            //PE-156.HS.1.0. 31 August 2023 Start 
            action(NS_CrewTimesheetReport)
            {
                ApplicationArea = all;
                Caption = 'Crew Time Sheet Report';
                Image = Report;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    NSTimePage: Report 14021479;
                begin
                    NSTimePage.NSSetDate(Rec."NS_No.", rec."NS_Work Period Start Date ", rec."NS_Work Period End Date ");
                    NSTimePage.RunModal();
                end;
            }
            //PE-156.HS.1.0. 31August2023 End
        }
        //PRJ-1055.RM.1.0 19Nov2021 End
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
        CurrPage.Update();   //PE-152.JS.1.0 28Aug2023
    end;

    var
        HRSetup: Record "Human Resources Setup";
        [InDataSet]
        AllowEdit: Boolean;

}