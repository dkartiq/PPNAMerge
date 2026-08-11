page 14021235 NS_TimesheetCustomizedSubform
{
    //PRJ-772.AS.1.0 12July2021 New page
    //PRJ-841.JS.1.0 16Aug2021 | Add field
    //PRJ-842.JS.1.0 16Aug2021 | Add field
    //PRJ-924.JS.1.0 17Sep2021 | Add Field
    //PRJ-1131.NK.1.0 12Jan2022 | Removed with statement
    //PRJ-1144.JS.1.0 31JAN2022 | Add fields
    //PRJCTPR-2.RM.1.0 13Dec2022 | Added a new field

    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = NS_TimeSheetLineCustom;
    AutoSplitKey = true;
    // DelayedInsert = true; //PE-274.JS.1.0 12APR2024 line commented
    UsageCategory = Lists;
    // ApplicationArea = All; //PE-274.JS.1.0 12APR2024 line commented
    RefreshOnActivate = true;  //PE-152.JS.1.0 28Aug2023


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("NS_TimeSheetNo."; Rec."NS_TimeSheetNo.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field(NS_Description; Rec.NS_Description)
                {
                    Caption = 'Work Description';
                    ApplicationArea = All;

                }
                field("NS_Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;

                }
                field("NS_Job Task No."; Rec."NS_Job Task No.")
                {
                    ApplicationArea = All;

                }
                field("NS_Resource No."; Rec."NS_Resource No.")
                {
                    ApplicationArea = All;

                }
                // //PRJ-1074.AS.1.0 28DEC2021 Commented code for old field "NS_Resource Name" start
                //                 field("NS_Resource Name"; Rec."NS_Resource Name")
                // {
                //     ApplicationArea = All;

                // }
                //PRJ-1074.AS.1.0 28DEC2021 Commented code for old field "NS_Resource Name" end

                //PRJ-1074.AS.1.0 28DEC2021 Add New code for new field "NS_Resource Name New" Start
                field("NS_Resource Name"; Rec."NS_Resource Name New")
                {
                    ApplicationArea = All;

                }
                //PRJ-1074.AS.1.0 28DEC2021 Add New code for new field "NS_Resource Name New" End

                //PRJ-924.JS.1.0 17Sep2021-Start
                field("NS_Working Hours"; Rec."NS_Working Hours")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;

                }
                field("NS_Resource Working Hours"; Rec."NS_Resource Working Hours") //PRJ-1131.NK.1.0
                {
                    Caption = 'Working Hours';
                    ApplicationArea = All;
                    ToolTip = 'Specify Resource working hours';
                }
                //PRJ-924.JS.1.0 17Sep2021-end

                field("NS_Crew code"; Rec."NS_Crew code")
                {
                    ApplicationArea = All;

                }
                field("NS_Lead Person"; Rec."NS_Lead Person")
                {
                    ApplicationArea = All;

                }
                field("NS_LineNo."; Rec."NS_LineNo.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("NS_Working Date"; Rec."NS_Working Date")
                {
                    ApplicationArea = All;

                }
                field(NS_Status; Rec.NS_Status)
                {
                    ApplicationArea = All;
                }
                field("NS_Work Type Code"; Rec."NS_Work Type Code")
                {
                    ToolTip = 'Specifies the value of the Work Type field';
                    ApplicationArea = All;
                }

                //PRJ-841.JS.1.0 16Aug2021-Start
                field("NS_Skill Code"; '') //PE-68 Dk.1.0 10April2023
                {
                    ToolTip = 'Specifies the value of the Skill Code field';
                    ApplicationArea = All;
                    Visible = false;//PE-68 Dk.1.0 10April2023
                }
                //PRJ-841.JS.1.0 16Aug2021-end
                //PE-68 Dk.1.0 10April2023 Start
                field("NS_Skill Code New"; Rec."NS_Skill Code New")
                {
                    ToolTip = 'Specifies the value of the Skill Code field';
                    ApplicationArea = All;
                }
                //PE-68 Dk.1.0 10April2023 End

                //PRJ-842.JS.1.0 16Aug2021-start
                field("NS_Segment Code"; Rec."NS_Segment Code")
                {
                    ToolTip = 'Specifies the value of the Segment Code field';
                    ApplicationArea = All;
                }
                //PRJ-842.JS.1.0 16Aug2021-end

                //PRJ-1144.JS.1.0 31JAN2022 - Start               
                field("NS_Ready To Submit"; Rec."NS_Ready To Submit")
                {
                    Caption = 'Select';
                    ToolTip = 'Specifies the value of the Select the Crew Time Sheet Line for Submission';
                    ApplicationArea = All;
                }
                field("NS_Rejected Remark"; Rec."NS_Rejected Remark")
                {
                    ToolTip = 'Specifies the value of the Managers Rejected Remark for Time Sheet';
                    ApplicationArea = All;
                }
                //PRJ-1144.JS.1.0 31JAN2022 - ends
                //PRJ-1452.GK.1.0 13June2022 start
                field("NS_Time Sheet Owner User ID"; Rec."NS_Time Sheet Owner User ID")
                {
                    ToolTip = 'Specifies the value of the Time Sheet Owner User ID field.';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("NS_Time Sheet Approver User ID"; Rec."NS_Time Sheet Approver User ID")
                {
                    ToolTip = 'Specifies the value of the Time Sheet Approver User ID field.';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                //PRJ-1452.GK.1.0 13June2022 end

                //PRJCTPR-2.RM.1.0 13Dec2022 start
                field("NS_Union Code"; Rec."NS_Union Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Union Code';
                }
                //PRJCTPR-2.RM.1.0 13Dec2022 end

                //PE-274.JS.1.0 02APR2024 - Start
                field("NS_CTS Resource Group No."; Rec."NS_CTS Resource Group No.")
                {
                    Caption = 'Resource Group No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Resource Group No. field.';
                    editable = false;
                }
                //PE-274.JS.1.0 02APR2024 - end
            }
        }

    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';

                action("Add New Line")
                {
                    ApplicationArea = All;
                    ToolTip = 'Add New Line';
                    Image = OpenJournal;
                    trigger OnAction();
                    var
                        NSTimeSheetLineCust: Record "NS_TimeSheetLineCustom";
                        NSTimeSheetLineCust2: Record "NS_TimeSheetLineCustom";
                        NSJobRec: record Job;  //PE-152.JS.1.0 21Aug2021
                        NSCrewTimeSheetHeader: record "NS_TimesheetHdrCustom";  //PE-152.JS.1.0 21Aug2021
                        NSHRSetup: record "Human Resources Setup";  //PE-152.JS.1.0 23Aug2021
                        NSNoSeriesMgt: codeunit NoSeriesManagement; //PE-152.JS.1.0 23Aug2021
                        NextLineNo: Integer;
                    begin
                        if Confirm('Do you want Add new line', true) then begin
                            NextLineNo := 0;
                            if NSHRSetup.get() then;  //PE-152.JS.1.0 21Aug2021
                            NSTimeSheetLineCust.Reset();
                            NSTimeSheetLineCust.SetRange("NS_TimeSheetNo.", Rec."NS_TimeSheetNo.");
                            if NSTimeSheetLineCust.Findlast() then begin
                                NextLineNo := NSTimeSheetLineCust."NS_LineNo.";
                                If NextLineNo = 0 then
                                    NextLineNo := 10000
                                else
                                    NextLineNo := NextLineNo + 10000;

                                NSTimeSheetLineCust2.Init();
                                NSTimeSheetLineCust2."NS_TimeSheetNo." := Rec."NS_TimeSheetNo.";
                                NSTimeSheetLineCust2."NS_LineNo." := NextLineNo;
                                NSTimeSheetLineCust2."NS_Crew code" := NSTimeSheetLineCust."NS_Crew code";
                                NSTimeSheetLineCust2."NS_Lead Person" := NSTimeSheetLineCust."NS_Lead Person";
                                //PE-152.JS.1.0 21Aug2023 - Start
                                NSTimeSheetLineCust2.NS_Description := NSTimeSheetLineCust.NS_Description;
                                NSTimeSheetLineCust2."NS_Add New Line" := true;
                                NSTimeSheetLineCust2."NS_Time Sheet Owner User ID" := UserId;
                                NSTimeSheetLineCust2."NS_Time Sheet Approver User ID" := UserId;
                                NSTimeSheetLineCust2."NS_Unique Line ID" :=
                                    NSNoSeriesMgt.GetNextNo(NSHRSetup."NS_Timesheet Unique Line Nos.", Today, true);
                                NSTimeSheetLineCust2.Insert();
                                Message('Crew Time Sheet line added successfully.');
                            end else begin
                                if NSCrewTimeSheetHeader.get(Rec."NS_TimeSheetNo.") then begin
                                    NSTimeSheetLineCust2.Init();
                                    NSTimeSheetLineCust2."NS_TimeSheetNo." := Rec."NS_TimeSheetNo.";
                                    NSTimeSheetLineCust2."NS_LineNo." := 10000;
                                    NSTimeSheetLineCust2."NS_Crew code" := '';
                                    NSTimeSheetLineCust2."NS_Lead Person" := '';
                                    NSTimeSheetLineCust2.NS_Description := NSCrewTimeSheetHeader.NS_Description;
                                    NSTimeSheetLineCust2."NS_Add New Line" := true;
                                    NSTimeSheetLineCust2."NS_Time Sheet Owner User ID" := UserId;
                                    NSTimeSheetLineCust2."NS_Time Sheet Approver User ID" := UserId;
                                    NSTimeSheetLineCust2."NS_Unique Line ID" :=
                                        NSNoSeriesMgt.GetNextNo(NSHRSetup."NS_Timesheet Unique Line Nos.", Today, true);
                                    NSTimeSheetLineCust2.Insert();
                                    Message('Crew Time Sheet line added successfully.');
                                end;
                            end;
                            //PE-152.JS.1.0 21Aug2023 - end
                        end else
                            exit;
                    end;
                }
                action("Open Rejected Lines")
                {
                    ApplicationArea = All;
                    ToolTip = 'Open Rejected Lines';
                    Image = OpenJournal;
                    trigger OnAction();
                    var
                        NSTimeSheetLineCust: Record "NS_TimeSheetLineCustom";
                    begin
                        if Confirm('Do you want to open rejected time sheet lines', true) then begin
                            NSTimeSheetLineCust.Reset();
                            NSTimeSheetLineCust.SetRange("NS_TimeSheetNo.", Rec."NS_TimeSheetNo.");
                            //   NSTimeSheetLineCust.SetRange("NS_Ready To Submit", true);  //PRJ-1753.PS.0.0 22Dec2022
                            NSTimeSheetLineCust.SetRange(NS_Status, NSTimeSheetLineCust.NS_Status::Rejected);
                            if NSTimeSheetLineCust.FindSet() then begin
                                repeat
                                    NSTimeSheetLineCust.NS_Status := NSTimeSheetLineCust.NS_Status::Open;
                                    //   NSTimeSheetLineCust."NS_Ready To Submit" := false;  //PRJ-1753.PS.0.0 22Dec2022
                                    NSTimeSheetLineCust.Modify();
                                until NSTimeSheetLineCust.Next() = 0;
                                Message('Rejected time Sheet lines are open successfully for Crew Time Sheet no. %1', Rec."NS_TimeSheetNo.");
                            end else
                                Message('All Rejected lines are already open');
                        end else
                            exit;
                    end;
                }

                action("Open Submitted Lines")
                {
                    ApplicationArea = All;
                    ToolTip = 'Open Submitted Lines';
                    Image = OpenJournal;
                    trigger OnAction();
                    var
                        NSTimeSheetLineCust: Record "NS_TimeSheetLineCustom";
                    begin
                        if Confirm('Do you want to open submitted time sheet lines', true) then begin
                            NSTimeSheetLineCust.Reset();
                            NSTimeSheetLineCust.SetRange("NS_TimeSheetNo.", Rec."NS_TimeSheetNo.");
                            //   NSTimeSheetLineCust.SetRange("NS_Ready To Submit", true);  //PRJ-1753.PS.0.0 22Dec2022
                            NSTimeSheetLineCust.SetRange(NS_Status, NSTimeSheetLineCust.NS_Status::Submitted);
                            if NSTimeSheetLineCust.FindSet() then begin
                                repeat
                                    NSTimeSheetLineCust.NS_Status := NSTimeSheetLineCust.NS_Status::Open;
                                    //      NSTimeSheetLineCust."NS_Ready To Submit" := false; //PRJ-1753.PS.0.0 22Dec2022
                                    NSTimeSheetLineCust.Modify();
                                until NSTimeSheetLineCust.Next() = 0;
                                Message('Submitted time Sheet lines are open successfully for Crew Time Sheet no. %1', Rec."NS_TimeSheetNo.");
                            end else
                                Message('All submitted lines are already open');
                        end else
                            exit;
                    end;
                }

            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

    end;

    trigger OnOpenPage()
    begin

    end;

    trigger OnAfterGetRecord()
    begin
        //PRJ-1144.JS.1.0 03Feb2022 - Start
        // IF Rec."NS_Status" = Rec."NS_Status"::Submitted then
        //     CurrPage.editable(false)
        // ELSE
        //     CurrPage.editable(true);
        //PRJ-1144.JS.1.0 03Feb2022 - end
    end;

    trigger OnAfterGetCurrRecord()
    begin
        IF Rec."NS_Status" = Rec."NS_Status"::Submitted then
            CurrPage.editable(false)
        ELSE
            CurrPage.editable(true);
    end;

    //PRJ-1455.RM.1.0 start
    procedure GetRecords(VAR TSheet: Record NS_TimeSheetLineCustom)
    begin
        CurrPage.SetSelectionFilter(TSheet);
    end;

    //PRJ-1455.RM.1.0 End    

}
