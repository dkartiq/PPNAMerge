pageextension 14021276 NS_JobTaskLines extends "Job Task Lines"
{
    // "a3b03edf-3f59-46a5-9644-a1f4a6b1d289"
    // version NAVW111.00.00.22292,NAVNA11.00.00.22292,PPNA11.00
    //PRJ-431.AM.1.0 11NOV2020 | Added style property to JobtaskNo. .
    //PRJ-492.RS.1.0 10May2021 | Hide/Unhide Fields
    //PRJ-807.RS.1.0 9July21 | Ability to Assign Work Units and Work Units Of Measure at Job Task Line
    layout
    {
        //PRJ-492.N.S.1.0 Start
        modify("Start Date")
        {
            Visible = false;
        }
        modify("Job Posting Group")
        {
            Visible = false;
        }
        modify("WIP-Total")
        {
            Visible = false;
        }
        modify("WIP Method")
        {
            Visible = false;
        }
        //PRJ-492.N.S.1.0 End
        //PRJ-492.RS.1.0 10May2021 Start
        modify("Schedule (Total Price)")
        {
            Visible = false;//PRJ-492.RS.1.0 10May2021
        }
        modify("Usage (Total Price)")
        {
            Visible = false;//PRJ-492.RS.1.0 10May2021
        }
        modify("Contract (Total Cost)")
        {
            Visible = false;//PRJ-492.RS.1.0 10May2021
        }
        modify("Contract (Invoiced Cost)")
        {
            Visible = false;//PRJ-492.RS.1.0 10May2021
        }
        modify("EAC (Total Price)")
        {
            Visible = false;//PRJ-492.RS.1.0 10May2021
        }
        modify("EAC (Total Cost)")
        {
            Visible = false;//PRJ-492.RS.1.0 10May2021
        }
        modify("Job Task No.")
        {
            Visible = false;//PRJ-492.RS.1.0 10May2021
        }
        modify("End Date")
        {
            Visible = false;//PRJ-492.RS.1.0 10May2021
        }
        //PRJ-492.RS.1.0 10May2021 End
        addafter("Job No.")
        {
            field(NS_JobTaskNo; Rec."Job Task No.")
            {

                ToolTip = 'Specifies the number of the related job task.';
                ApplicationArea = Jobs;
                Style = Strong;//PRJ-431.AM.1.0 Added
                StyleExpr = SMP_StyleIsStrong;

                trigger OnValidate()
                begin
                    //ProjectPro - start
                    IF Description = '' THEN
                        Description := NS_GetJobTaskDescription("Job No.", "Job Task No.");
                    //ProjectPro - end
                end;

                trigger OnLookup(VAR Text: Text): Boolean;
                var
                    NS_PickAPOCode: Page "NS_Pick APO Code";
                    NS_Description2: Text[100];//PRJ-449.AM.1.0
                                               // >> Upgrade
                    JobAct: Code[20];
                // << Upgrade
                begin
                    //ProjectPro - start
                    CLEAR(NS_PickAPOCode);
                    NS_PickAPOCode.LOOKUPMODE(TRUE);
                    // >> Upgrade
                    // NS_PickAPOCode.NS_SetInput("Job No.", "Job Task No.", 0);
                    NS_PickAPOCode.NS_SetInput("Job No.", "Job Task No.", JobAct, 0);
                    // << Upgrade
                    IF NS_PickAPOCode.RUNMODAL = ACTION::LookupOK THEN BEGIN
                        if (Rec."Job Task No.") <> '' then//PRJ-604.AS.1.0
                            Validate("Job Task No.", Rec."Job Task No.");//PRJ-604.AS.1.0
                        // NS_PickAPOCode.NS_GetResult("Job Task No.", NS_Description2);
                        NS_PickAPOCode.NS_GetResult("Job Task No.", NS_Description2, JobAct);
                        Description := NS_JobTask.NS_GetJobTaskDescription("Job No.", "Job Task No.");
                        IF Description = '' THEN
                            Description := NS_Description2;
                    END;
                    //ProjectPro - end
                end;
            }
        }

        addafter("Job Task Type")
        {
            //PRJ-807.RS.1.0 9July21 Start
            field("NS_Work Units"; Rec."NS_Work Units")
            {
                ApplicationArea = All;
            }
            field("NS_Work Unit of Measure"; Rec."NS_Work Unit of Measure")
            {
                ApplicationArea = All;
            }
            //PRJ-807.RS.1.0 9July21 End
            field("NS_Burden Percent"; Rec."NS_Burden Percent")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Burden Percent';
                Visible = false; //PRJ-492.AS.1.0
            }
            field("NS_Task Before"; Rec."NS_Task Before")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Task Before';
                Visible = false; //PRJ-492.AS.1.0
            }
            field("NS_Start Date Fixed"; Rec."NS_Start Date Fixed")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Start Date Fixed';
                Visible = false;//PRJ-492.N.S.1.0
            }
            field("NS_Task Start Date"; Rec."NS_Task Start Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Task Start Date';
                Visible = false;//PRJ-492.N.S.1.0
            }
            field("NS_Task End Date"; Rec."NS_Task End Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Task End Date';
                Visible = false;//PRJ-492.N.S.1.0
            }
            field("NS_Task Days"; Rec."NS_Task Days")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Task Days';
                Visible = false; //PRJ-492.AS.1.0
            }
            field("NS_Task Lag Days"; Rec."NS_Task Lag Days")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Task Lag Days';
                Visible = false; //PRJ-492.AS.1.0
            }
            field("NS_Resource No."; Rec."NS_Resource No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Resource No.';
                Visible = false; //PRJ-492.AS.1.0
            }
        }
        addafter("Job Posting Group")
        {
            field("NS_Total Percent Complete"; Rec."NS_Total Percent Complete")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Total Percent Complete';
                Visible = false; //PRJ-492.AS.1.0
            }
            field("NS_Total Percent Complete Date"; Rec."NS_Total Percent Complete Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Total Percent Complete Date';
                Visible = false; //PRJ-492.AS.1.0
            }
            field("NS_Billing Percent"; Rec."NS_Billing Percent")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Billing Percent';
                Visible = false; //PRJ-492.AS.1.0
            }
            field("NS_Billing Percent Date"; Rec."NS_Billing Percent Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Billing Percent Date';
                Visible = false; //PRJ-492.AS.1.0
            }
        }
        addafter("Amt. Rcd. Not Invoiced")
        {
            field("NS_Percent Complete"; Rec."NS_Percent Complete")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Percent Complete';
                Visible = false; //PRJ-492.AS.1.0
            }
            field("NS_Estimated Hours"; Rec."NS_Estimated Hours")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Estimated Hours';
                Visible = false; //PRJ-492.AS.1.0
            }
            field("NS_Percent Materials"; Rec."NS_Percent Materials")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Percent Materials';
                Visible = false; //PRJ-492.AS.1.0
            }
        }
    }
    actions
    {
        modify("Job - Suggested Billing")
        {
            Caption = 'Job Cost Suggested Billing';
        }
        modify("Jobs - Transaction Detail")
        {
            Caption = 'Jobs Cost Transaction Detail';
        }

        modify("<Action49>")
        {
            trigger OnAfterAction()
            begin
                NS_SetJobNo("Job No.");
            end;
        }

        addbefore("&Job Task")
        {
            group("NS_Project Link")
            {
                Caption = '&Project Link';
                action("NS_Calculate &Start Dates")
                {
                    ApplicationArea = All;
                    Caption = 'Calculate &Start Dates';
                    Image = CalculateCalendar;

                    trigger OnAction();
                    begin
                        //ProjectPro - start
                        NS_PrepareTasksForExport;
                        //ProjectPro - end
                    end;
                }
                action("NS_&Clear Start Dates")
                {
                    ApplicationArea = All;
                    Caption = '&Clear Start Dates';
                    Image = ClearLog;

                    trigger OnAction();
                    begin
                        //ProjectPro - start
                        NS_ClearJobStartDates;
                        //ProjectPro - end
                    end;
                }
                separator(NS_Separator1100773004)
                {
                }
                action("NS_E&xport to Project")
                {
                    ApplicationArea = All;
                    Caption = 'E&xport to Project';
                    Image = ExportFile;

                    trigger OnAction();
                    begin
                        //ProjectPro - start
                        NS_PrepareTasksForExport;
                        NS_ExportTasksToMSProject;
                        //ProjectPro - end
                    end;
                }
                action("NS_Open &Project with File")
                {
                    ApplicationArea = All;
                    Caption = 'Open &Project with File';
                    Image = Planning;
                }
                separator(NS_Separator1100773001)
                {
                }
                action("NS_Set Project File Name")
                {
                    ApplicationArea = All;
                    Caption = 'Set Project File Name';
                    Image = Card;

                    trigger OnAction();
                    var
                        NS_JobLocal: Record Job;
                    begin
                        //ProjectPro - start
                        NS_JobLocal.RESET;
                        NS_JobLocal.GET("Job No.");
                        PAGE.RUN(PAGE::"NS_Project File Name", NS_JobLocal);
                        //ProjectPro - end
                    end;
                }
            }
        }
        addafter("Change &Dates")
        {
            action(NS_XMLImport)
            {
                ApplicationArea = All;
                Caption = 'XML Import';
                Image = XMLFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    FileMgt: Codeunit 419;
                    FileName: Text;
                    XMLImport: Codeunit "NS_Job Quote XML Import";
                begin
                    if "Job Task Type" <> "Job Task Type"::Posting then
                        ERROR(Text14021127);
                    FileName := FileMgt.OpenFileDialog('', '', '');
                    XMLImport.NS_ImportXML(FileName, "Job No.", "Job Task No.");
                    CurrPage.UPDATE;
                end;
            }
            action(NS_XMLImporttest)
            {
                ApplicationArea = All;
                Caption = 'XML Import Test';
                Enabled = false;
                Image = XMLFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction();
                var
                    FileMgt: Codeunit 419;
                    FileName: Text;
                    XMLImport: Codeunit "NS_Job Quote XML Import";
                    DriveDesignation: Text;
                    FileName2: Text;
                    Text1: Text;
                    Text2: Text;
                begin
                    if "Job Task Type" <> "Job Task Type"::Posting then
                        ERROR(Text14021127);
                    FileName := FileMgt.OpenFileDialog(NS_OpenFileDialogWindowTitle, '', '');
                    //Text1 := FileMgt.BrowseForFolderDialog('Test','',TRUE);
                    Text2 := FileMgt.GetDirectoryName(FileName);
                    if STRPOS(Text2, NS_FolderLocation) > 0 then begin
                        FileName := DELSTR(FileName, STRPOS(Text2, NS_FolderLocation), 3);
                        FileName := NS_SharedFolderLocation + FileName;
                    end;
                    FileName2 := FileMgt.GetFileName(FileName);
                    FileName2 := NS_TempFolderLocation + FileName2;
                    //FileMgt.CopyClientFile(FileName,FileName2,TRUE);
                    XMLImport.NS_ImportXML(FileName, "Job No.", "Job Task No.");
                    CLEAR(FileMgt);
                    CLEAR(XMLImport);

                    //SMP start DeleteClientFile not supported in extension development
                    //FileMgt.DeleteClientFile(FileName2);
                    //SMP end

                    CurrPage.UPDATE;
                end;
            }
        }
        addafter("F&unctions")
        {
            group("NS_Take-Off")
            {
                Caption = 'Take-Off';
                Enabled = false;
                Visible = false;
                action(NS_GetJobSegments)
                {
                    ApplicationArea = All;
                    Caption = 'Get Job Segments';
                    Enabled = false;
                    Image = Job;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    Visible = false;

                    trigger OnAction();
                    var
                        JobSegment: Page "NS_Job Takeoff Worksheet";
                    begin
                        JobSegment.NS_InitPage("Job No.", '');
                        JobSegment.RUNMODAL;
                    end;
                }
                action(NS_GetJobTaskSegments)
                {
                    ApplicationArea = All;
                    Caption = 'Get Job Task Segments';
                    Enabled = false;
                    Image = JobListSetup;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = false;

                    trigger OnAction();
                    var
                        JobSegment: Page "NS_Job Takeoff Worksheet";
                    begin
                        JobSegment.NS_InitPage("Job No.", "Job Task No.");
                        JobSegment.RUNMODAL;
                    end;
                }
            }
        }
        addafter("Jobs - Transaction Detail")
        {
            action("NS_Job Rcvd Not Invoiced")
            {
                ApplicationArea = All;
                Caption = 'Job Rcvd Not Invoiced';

                trigger OnAction();
                var
                    RcvdNotInvoiced: Report "NS_ProjectPro Rcvd NotInvoiced";
                begin
                    //ProjectPro - start
                    RcvdNotInvoiced.SetFilter(Rec."Job No.", Rec."Job Task No.");
                    RcvdNotInvoiced.RUNMODAL;
                    //ProjectPro - end
                end;
            }
        }
    }

    var
        NS_CurrentJobNo: Code[20];
        NS_Job: Record Job;
        NS_JobOSFileName: Text[150];
        NS_OpenFileDialogWindowTitle: Label 'XML Import';
        NS_FolderLocation: Label 'I:\';
        NS_SharedFolderLocation: Label '\\BONADIO.COM\share\';
        NS_TempFolderLocation: Label 'C:\Temp\';
        Text14021101: Label 'Current process @1@@@@@@@@@@@@@@@\';
        Text14021102: Label 'Task Before %1  is not a valid task in the job.';
        Text14021103: Label 'There must be an initial start date to calculate dates for the rest of the job.';
        Text14021104: Label 'There is no file name defined.';
        Text14021105: Label 'The calendar named for the job does not exist.';
        Text14021106: Label 'The calendar named in the job setup does not exist.';
        Text14021107: Label 'A calendar could not be found to use for date calculations.\\There must be one defined in the Jobs setup area.';
        NS_JobTask: Record "Job Task";
        NS_JobsSetup: Record "Jobs Setup";
        NS_ProjLinkBuf: Record "NS_Project Link Buffer";
        NS_TempProjectLinkBuffer: Record "NS_Project Link Buffer" temporary;
        Text14021108: Label 'JOB TYPE';
        Text14021109: Label 'PHASE';
        NS_Window: Dialog;
        Text14021110: Label 'Text1';
        Text14021111: Label 'Text2';
        Text14021112: Label 'Text3';
        Text14021113: Label 'Outline Level';
        Text14021114: Label 'Name';
        Text14021115: Label 'Start';
        Text14021116: Label 'Finish';
        Text14021117: Label 'Resource Names';
        Text14021118: Label 'Duration';
        Text14021119: Label 'Work';
        Text14021120: Label 'Actual Work';
        Text14021121: Label 'Cost';
        Text14021122: Label 'Cost1';
        Text14021123: Label 'Predecessors';
        Text14021124: Label 'Successors';
        Text14021125: Label 'Current process @1@@@@@@@@@@@@@@@\';
        Text14021126: Label 'There is no file name defined.';
        QuoteNo: Code[20];
        Text14021127: Label 'The Task Line must be of Type Posting';
        SMP_StyleIsStrong: Boolean;

    //Unsupported feature: CodeModification on "OnAfterGetRecord". Please convert manually.

    trigger OnAfterGetRecord();
    begin

        //SMP - start
        SMP_StyleIsStrong := "Job Task Type" <> "Job Task Type"::Posting;
        //SMP - end
        //ProjectPro - start
        if NS_Job.GET("Job No.") then
            NS_JobOSFileName := NS_Job."NS_OS File Name"
        else
            NS_JobOSFileName := '';
        //ProjectPro - end      
    end;


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        //ProjectPro - start
        if ("NS_Quote No." = '') and (QuoteNo <> '') then
            "NS_Quote No." := QuoteNo;
        //ProjectPro - end    
    end;

    trigger OnOpenPage();
    begin
        //ProjectPro - start
        if NS_CurrentJobNo <> '' then begin
            FILTERGROUP := 2;
            SETRANGE("Job No.", NS_CurrentJobNo);
            FILTERGROUP := 0;
        end;
        //ProjectPro - end    
    end;


    procedure NS_SetJobNo(CurrentJobNo2: Code[20]);
    begin
        //ProjectPro - start
        NS_CurrentJobNo := CurrentJobNo2;
        //ProjectPro - end
    end;

    procedure NS_GetTask(): Code[35];
    begin
        //ProjectPro - start
        exit("Job Task No.");
        //ProjectPro - end
    end;

    procedure NS_ClearJobStartDates();
    var
        JobTask: Record "Job Task";
    begin
        //ProjectPro - start
        //Clear all start dates in Job Task for the job unless a particular task has a fixed start date.
        with NS_JobTask do begin
            RESET;
            SETRANGE("Job No.", NS_CurrentJobNo);
            if FINDSET then
                repeat
                    if not "NS_Start Date Fixed" then
                        "NS_Task Start Date" := 0D;
                    "NS_Task End Date" := 0D;
                    MODIFY;
                until NEXT = 0;
        end;
        //ProjectPro - end
    end;

    procedure NS_PrepareTasksForExport();
    begin
        //ProjectPro - start
        //Populate a job's task records with Start and End dates, to prep forexport.
        //This separate step allows the user to modify dates as desired before the export
        NS_BuildProjectLinkBuffer;
        NS_CalcStartDates;

        //Update table with new calculated dates
        with NS_TempProjectLinkBuffer do begin
            RESET;
            if FINDSET then
                repeat
                    if NS_JobTask.GET("Job No.", "NS_Task No.") then begin
                        NS_JobTask."NS_Task Start Date" := "Start Date";
                        NS_JobTask."NS_Task End Date" := "NS_Finish Date";
                        NS_JobTask.MODIFY;
                    end;
                until NEXT = 0;
        end;
        //ProjectPro - end
    end;

    procedure NS_BuildProjectLinkBuffer();
    var
        NS_Separator: Text[1];
        NS_SeparatorCount: Integer;
        NS_LineNo: Integer;
        NS_JobNo: Code[20];
        NS_JobTaskNo: Code[20];
        NS_APOPosition: Integer;
        NS_Duration: Decimal;
    begin
        //ProjectPro - start
        //Build the temporary Project Link Buffer table from the Job Tasks
        NS_JobsSetup.GET;
        NS_Separator := NS_JobsSetup."NS_APO Separators";
        NS_TempProjectLinkBuffer.RESET;
        NS_TempProjectLinkBuffer.DELETEALL;
        NS_LineNo := 0;
        NS_SetJobNo("Job No.");
        with NS_JobTask do begin
            RESET;
            SETRANGE("Job No.", NS_CurrentJobNo);
            if FINDSET then begin
                if ("Job Task Type" <> "Job Task Type"::Total) and ("Job Task Type" <> "Job Task Type"::"End-Total") then begin
                    //Create the first line for the job itself
                    NS_TempProjectLinkBuffer.INIT;
                    NS_TempProjectLinkBuffer."NS_Job No." := "Job No.";
                    NS_LineNo += 1;
                    NS_TempProjectLinkBuffer."NS_Line No." := NS_LineNo;
                    NS_TempProjectLinkBuffer."NS_Master Job No." := "Job No.";
                    NS_TempProjectLinkBuffer."NS_Job Type" := Text14021108;
                    NS_TempProjectLinkBuffer."NS_Task Name" := FORMAT(NS_Job.Description, 30);
                    NS_TempProjectLinkBuffer."NS_Outline Level" := 1;
                    NS_TempProjectLinkBuffer."NS_Start Date" := "NS_Task Start Date";
                    NS_TempProjectLinkBuffer."NS_Finish Date" := "NS_Task End Date";
                    NS_TempProjectLinkBuffer.INSERT;
                end;

                //Now do the rest of the job
                repeat
                    if ("Job Task Type" <> "Job Task Type"::Total) and ("Job Task Type" <> "Job Task Type"::"End-Total") then begin
                        NS_SeparatorCount := 0;
                        NS_JobTaskNo := "Job Task No.";
                        NS_APOPosition := STRPOS(NS_JobTaskNo, NS_Separator);
                        while NS_APOPosition > 0 do begin
                            NS_SeparatorCount += 1;
                            NS_JobTaskNo := COPYSTR(NS_JobTaskNo, NS_APOPosition + 1);
                            NS_APOPosition := STRPOS(NS_JobTaskNo, NS_Separator);
                        end;

                        //Add a record for the task line
                        NS_TempProjectLinkBuffer.INIT;
                        NS_TempProjectLinkBuffer."NS_Job No." := "Job No.";
                        NS_LineNo += 1;
                        NS_TempProjectLinkBuffer."NS_Line No." := NS_LineNo;
                        NS_TempProjectLinkBuffer."NS_Master Job No." := "Job No.";
                        NS_TempProjectLinkBuffer."NS_Job Type" := Text14021108;
                        NS_TempProjectLinkBuffer."NS_Task No." := "Job Task No.";
                        NS_TempProjectLinkBuffer."NS_Task Name" := FORMAT("Job Task No." + ' ' + Description, 30);
                        NS_TempProjectLinkBuffer."NS_Job Task Type" := "Job Task Type";
                        NS_TempProjectLinkBuffer."NS_Task Before" := "NS_Task Before";
                        case NS_SeparatorCount of
                            0:
                                NS_TempProjectLinkBuffer."NS_Outline Level" := 2;
                            1:
                                NS_TempProjectLinkBuffer."NS_Outline Level" := 3;
                            2:
                                NS_TempProjectLinkBuffer."NS_Outline Level" := 4;
                        end;
                        NS_TempProjectLinkBuffer.NS_Level := Text14021109;
                        NS_TempProjectLinkBuffer."NS_Start Date" := "NS_Task Start Date";
                        NS_TempProjectLinkBuffer."NS_Finish Date" := "NS_Task End Date";
                        NS_TempProjectLinkBuffer."NS_Resource No." := "NS_Resource No.";
                        NS_TempProjectLinkBuffer.NS_Duration := "NS_Task Days";
                        NS_TempProjectLinkBuffer.NS_Lag := "NS_Task Lag Days";
                        NS_TempProjectLinkBuffer.INSERT;
                    end;
                until NEXT = 0;
            end;
        end;
        //ProjectPro - end
    end;

    procedure NS_CopyProjectLinkBuffer();
    begin
        //ProjectPro - start
        //Copy the temporary Project Link Buffer table into another table for use by other routines
        NS_ProjLinkBuf.RESET;
        NS_ProjLinkBuf.DELETEALL;
        with NS_TempProjectLinkBuffer do begin
            RESET;
            if FINDSET then begin
                repeat
                    NS_ProjLinkBuf.INIT;
                    NS_ProjLinkBuf.COPY(NS_TempProjectLinkBuffer);
                    NS_ProjLinkBuf.INSERT
              until NEXT = 0;
            end;
        end;
        //ProjectPro - end
    end;

    procedure NS_CalcStartDates();
    var
        NS_TaskBeforeHold: Code[20];
        NS_LineNo: Integer;
        NS_NextStartDate: Date;
    begin
        //ProjectPro - start
        //Calculate the start dates of the tasks in the temporary table with ability for a project calendar override value
        NS_SetPredecessorValues;
        NS_CopyProjectLinkBuffer;

        //Fill in the start dates with previous date plus days of duration
        //  However if the task has its own start date then leave it alone and start over from there.
        with NS_TempProjectLinkBuffer do begin
            NS_TaskBeforeHold := '';
            RESET;
            if FINDSET then begin
                if "Start Date" <> 0D then
                    NS_NextStartDate := "Start Date"
                else
                    ERROR(Text14021103);
                repeat
                    if ("Job Task Type" = "Job Task Type"::Posting) and ("NS_Line No." > 1) then begin
                        //Get the predecessor record
                        NS_ProjLinkBuf.RESET;
                        NS_ProjLinkBuf.SETCURRENTKEY("NS_Job No.", "NS_Task No.", "NS_Line No.");
                        NS_ProjLinkBuf.SETRANGE("NS_Job No.", "Job No.");
                        NS_ProjLinkBuf.SETRANGE("NS_Task No.", "NS_Task Before");
                        NS_ProjLinkBuf.FINDFIRST;

                        if "Start Date" = 0D then begin
                            //Calculate a new start date
                            if (NS_ProjLinkBuf.NS_Lag > 0) and (NS_ProjLinkBuf."NS_Finish Date" > 0D) then begin
                                "Start Date" := CALCDATE('+' + FORMAT(NS_ProjLinkBuf.NS_Lag + 1) + 'D', NS_ProjLinkBuf."NS_Finish Date");
                                "Start Date" := NS_AddWorkingDays(NS_ProjLinkBuf."NS_Job No.", "Start Date", 0);
                            end else
                                if NS_ProjLinkBuf."NS_Finish Date" > 0D then
                                    "Start Date" := NS_AddWorkingDays(NS_ProjLinkBuf."NS_Job No.", NS_ProjLinkBuf."NS_Finish Date", 1)
                                else
                                    "Start Date" := NS_NextStartDate;
                        end;

                        //Calculate a finish date
                        if "Start Date" > 0D then
                            "NS_Finish Date" := NS_AddWorkingDays(NS_ProjLinkBuf."NS_Job No.", "Start Date", NS_Duration - 1);

                        //Update ProjectLinkBuffer
                        MODIFY;

                        //Update ProjLinkBuf with new values
                        NS_ProjLinkBuf.RESET;
                        NS_ProjLinkBuf.SETCURRENTKEY("NS_Job No.", "NS_Task No.", "NS_Line No.");
                        NS_ProjLinkBuf.SETRANGE("NS_Job No.", "Job No.");
                        NS_ProjLinkBuf.SETRANGE("NS_Task No.", "NS_Task No.");
                        if NS_ProjLinkBuf.FINDFIRST then begin
                            NS_ProjLinkBuf."NS_Start Date" := "Start Date";
                            NS_ProjLinkBuf."NS_Finish Date" := "NS_Finish Date";
                            NS_ProjLinkBuf.MODIFY
                        end;

                        //Set the next start date
                        if "NS_Finish Date" > 0D then
                            NS_NextStartDate := NS_AddWorkingDays(NS_ProjLinkBuf."NS_Job No.", "NS_Finish Date", 1);
                    end;
                until NEXT = 0;
            end;
        end;
        //ProjectPro - end
    end;

    procedure NS_AddWorkingDays(JobNo: Code[20]; WorkDate: Date; Days: Integer): Date;
    var
        NS_BaseCalendar: Record "Base Calendar";
        NS_JobCalendar: Record "NS_Job Calendar";
        NS_CalendarManagement: Codeunit "Calendar Management";
        NS_JobCalendarManagement: Codeunit "NS_Job Calendar Management";
        NS_CalendarCode: Code[10];
        NS_Description: Text[50];
        NS_NonWorkingDate: Boolean;
        NS_NewDate: Date;
        NS_DayCount: Integer;
    begin
        //ProjectPro - start
        //Add "Days" to "WorkDate" and returns a new Date
        //  This routine uses a job calendar in the JobsSetup record tocskip over nonworking days
        //
        //  Zero can be passed in as a "Days" value and the next WorkDate will be returned.
        //  If the passed in WorkDate is already a working day then that date is simply returned.
        //
        //  If a negative Days value is passed in, it is processed as a zero.
        if Days < 0 then
            Days := 0;

        //Check to see that a valid calendar code is being used
        if NS_JobsSetup."NS_Job Calendars Not Used" then begin
            //Calendars not being used, so just add days one-by-one.
            NS_NewDate := WorkDate;
            if Days > 0 then
                for NS_DayCount := 1 to Days do
                    NS_NewDate := CALCDATE('+1D', NS_NewDate);
            exit(NS_NewDate);
        end;

        //Find a Calendar to use
        NS_CalendarCode := '';
        if JobNo > '' then
            if NS_Job.GET(JobNo) then
                if NS_Job."NS_Job Calendar Code" > '' then
                    if NS_JobsSetup."NS_Job Calendar Source" = NS_JobsSetup."NS_Job Calendar Source"::"Base Navision Calendar" then begin
                        if NS_BaseCalendar.GET(NS_Job."NS_Job Calendar Code") then
                            NS_CalendarCode := NS_Job."NS_Job Calendar Code"
                        else
                            ERROR(Text14021105);
                    end else begin
                        if NS_JobCalendar.GET(NS_Job."NS_Job Calendar Code") then
                            NS_CalendarCode := NS_Job."NS_Job Calendar Code"
                        else
                            ERROR(Text14021105);
                    end;

        if NS_CalendarCode = '' then
            if NS_JobsSetup."NS_Job Calendar Source" = NS_JobsSetup."NS_Job Calendar Source"::"Base Navision Calendar" then begin
                if NS_BaseCalendar.GET(NS_JobsSetup."NS_Job Calendar Code") then
                    NS_CalendarCode := NS_JobsSetup."NS_Job Calendar Code"
                else
                    ERROR(Text14021106);
            end else begin
                if NS_JobCalendar.GET(NS_JobsSetup."NS_Job Calendar Code") then
                    NS_CalendarCode := NS_JobsSetup."NS_Job Calendar Code"
                else
                    ERROR(Text14021106);
            end;

        if NS_CalendarCode = '' then
            ERROR(Text14021107);

        NS_NewDate := WorkDate;
        if Days > 0 then
            for NS_DayCount := 1 to Days do begin
                repeat
                    NS_NewDate := CALCDATE('+1D', NS_NewDate);
                    if NS_JobsSetup."NS_Job Calendar Source" = NS_JobsSetup."NS_Job Calendar Source"::"Base Navision Calendar" then
                        //NS_NonWorkingDate := NS_CalendarManagement.CheckDateStatus(NS_CalendarCode, NS_NewDate, NS_Description)//PPNA16.0 Blocked
                        NS_NonWorkingDate := true //PPNA16.0 Added
                    else
                        //NS_NonWorkingDate := NS_JobCalendarManagement.CheckDateStatus(NS_CalendarCode, NS_NewDate, NS_Description)//PPNA16.0 Blocked
                        NS_NonWorkingDate := true; //PPNA16.0 Added
                until NS_NonWorkingDate = false;
            end
        else begin
            if NS_JobsSetup."NS_Job Calendar Source" = NS_JobsSetup."NS_Job Calendar Source"::"Base Navision Calendar" then
                //NS_NonWorkingDate := NS_CalendarManagement.CheckDateStatus(NS_CalendarCode, NS_NewDate, NS_Description) //PPNA16.0 Blocked
                NS_NonWorkingDate := true //PPNA16.0 Added
            else
                //NS_NonWorkingDate := NS_JobCalendarManagement.CheckDateStatus(NS_CalendarCode, NS_NewDate, NS_Description); //PPNA16.0 Blocked
                NS_NonWorkingDate := true;//PPNA16.0 Added
            if NS_NonWorkingDate then
                repeat
                    NS_NewDate := CALCDATE('+1D', NS_NewDate);
                    if NS_JobsSetup."NS_Job Calendar Source" = NS_JobsSetup."NS_Job Calendar Source"::"Base Navision Calendar" then
                        //NS_NonWorkingDate := NS_CalendarManagement.CheckDateStatus(NS_CalendarCode, NS_NewDate, NS_Description) //PPNA16.0 Blocked
                        NS_NonWorkingDate := true //PPNA16.0 Added
                    else
                        NS_NonWorkingDate := NS_JobCalendarManagement.NS_CheckDateStatus(NS_CalendarCode, NS_NewDate, NS_Description);
                until NS_NonWorkingDate = false;
        end;

        exit(NS_NewDate);
        //ProjectPro - end
    end;

    procedure NS_SetPredecessorValues();
    var
        NS_TaskBeforeHold: Code[20];
    begin
        //ProjectPro - start
        //Set the "Task Before" fields for the job based on sequence and any "Task Before" values.  Also sets the predecessor values.
        with NS_TempProjectLinkBuffer do begin
            //Fill in the blank "Task Before" values with the preceeding task.
            //  However if the task has its own start date then leave it alone and start over from there.
            NS_TaskBeforeHold := '';
            RESET;
            if FINDSET then
                repeat
                    if ("Job Task Type" = "Job Task Type"::Posting) and ("NS_Line No." > 1) then begin
                        if NS_TaskBeforeHold <> '' then
                            if "NS_Task Before" = '' then begin
                                "NS_Task Before" := NS_TaskBeforeHold;
                                MODIFY;
                            end;
                        NS_TaskBeforeHold := "NS_Task No.";
                    end;
                until NEXT = 0;

            NS_CopyProjectLinkBuffer;
            RESET;
            if FINDSET then
                repeat
                    if "NS_Task Before" > '' then begin
                        NS_ProjLinkBuf.RESET;
                        NS_ProjLinkBuf.SETCURRENTKEY("NS_Job No.", "NS_Task No.", "NS_Line No.");
                        NS_ProjLinkBuf.SETRANGE("NS_Job No.", "Job No.");
                        NS_ProjLinkBuf.SETRANGE("NS_Task No.", "NS_Task Before");
                        if NS_ProjLinkBuf.FINDFIRST then begin
                            NS_Predecessor := FORMAT(NS_ProjLinkBuf."NS_Line No.");
                            MODIFY;
                        end else
                            MESSAGE(Text14021102, "NS_Task Before");
                    end;
                until NEXT = 0;
        end;
        //ProjectPro - end
    end;

    procedure NS_ExportTasksToMSProject();
    var
        NS_Counter: Integer;
        NS_Line: Integer;
        P1002: Integer;
    begin
        //ProjectPro - start
        //Exports a job's task list to Microsoft Project

        /*NS_BuildProjectLinkBuffer;
        NS_SetPredecessorValues;
        
        WITH NS_ProjLinkBuf DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
        
            //Show a status window;
            NS_Window.OPEN(Text14021125);
            NS_Counter := 0;
        
            //Create a Microsoft Project file
            CREATE(MicrosoftPrjApp,FALSE,TRUE);
            MicrosoftPrjApp.FileNew;
            MicrosoftPrjApp.Visible(FALSE);
            MicrosoftPrjProject := MicrosoftPrjApp.ActiveProject;
            MicrosoftPrjTasks := MicrosoftPrjProject.Tasks;
            NS_Line := 0;
        
            REPEAT
              NS_Counter := NS_Counter + 1;
              NS_Line := NS_Line + 1;
              //Add a task
              MicrosoftPrjTasks.Add(FORMAT(NS_Line),'');
              MicrosoftPrjTask := MicrosoftPrjTasks.Item(NS_Line);
              MicrosoftPrjTask.SetField(MicrosoftPrjApp.FieldNameToFieldConstant(Text14021110,0),"Job No.");
              MicrosoftPrjTask.SetField(MicrosoftPrjApp.FieldNameToFieldConstant(Text14021111,0),"Master Job No.");
              MicrosoftPrjTask.SetField(MicrosoftPrjApp.FieldNameToFieldConstant(Text14021112,0),"Job Task No.");
              IF FORMAT("Outline Level") > ' ' THEN
                MicrosoftPrjTask.SetField(MicrosoftPrjApp.FieldNameToFieldConstant(Text14021113,0),FORMAT("Outline Level"));
              MicrosoftPrjTask.SetField(MicrosoftPrjApp.FieldNameToFieldConstant(Text14021114,0),"Task Name");
              MicrosoftPrjTask.SetField(MicrosoftPrjApp.FieldNameToFieldConstant(Text14021115,0),FORMAT("Start Date"));
              MicrosoftPrjTask.SetField(MicrosoftPrjApp.FieldNameToFieldConstant(Text14021116,0),FORMAT("Finish Date"));
              MicrosoftPrjTask.SetField(MicrosoftPrjApp.FieldNameToFieldConstant(Text14021117,0),"Resource No.");
              MicrosoftPrjTask.SetField(MicrosoftPrjApp.FieldNameToFieldConstant(Text14021118,0),FORMAT(Duration));
              IF "Est Hours" > 0 THEN
                MicrosoftPrjTask.SetField(MicrosoftPrjApp.FieldNameToFieldConstant(Text14021119,0),FORMAT("Est Hours"));
              MicrosoftPrjTask.SetField(MicrosoftPrjApp.FieldNameToFieldConstant(Text14021120,0),FORMAT("Act Hours"));
              MicrosoftPrjTask.SetField(MicrosoftPrjApp.FieldNameToFieldConstant(Text14021121,0),FORMAT("Budgeted Cost"));
              MicrosoftPrjTask.SetField(MicrosoftPrjApp.FieldNameToFieldConstant(Text14021122,0),FORMAT("Usage Cost"));
              MicrosoftPrjTask.SetField(MicrosoftPrjApp.FieldNameToFieldConstant(Text14021123,0),FORMAT(Predecessor));
              MicrosoftPrjTask.SetField(MicrosoftPrjApp.FieldNameToFieldConstant(Text14021124,0),FORMAT(Successors));
              NS_Window.UPDATE(1,ROUND(NS_Counter / COUNT * 10000,1));
        
            UNTIL NS_ProjLinkBuf.NEXT = 0;
        
            //Delete lines from the buffer
            RESET;
            DELETEALL;
        
            NS_Window.CLOSE;
        
            MicrosoftPrjApp.Visible(TRUE);
        
          END;
        END;*/
        //ProjectPro - end

    end;

    procedure SetQuoteNo(PassQuoteNo: Code[20]);
    begin
        QuoteNo := PassQuoteNo;
    end;

    //   +------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +     "PP Burden Percent"
    //   +     "PP Task Before"
    //   +     "PP Start Date Fixed"
    //   +     "PP Task Start Date"
    //   +     "PP Task End Date"
    //   +     "PP Task Days"
    //   +     "PP Task Lag Days"
    //   +     "PP Resource No."
    //   +     "Total Percent Complete"
    //   +     "Total Percent Complete Date"
    //   +     "Billing Percent"
    //   +     "Billing Percent Date"
    //   +
    //   +  - Added function(s):
    //   +     NS_GetTask()
    //   +     NS_SetJobNo()
    //   +     NS_ClearJobStartDates()
    //   +     NS_PrepareTasksForExport()
    //   +     NS_BuildProjectLinkBuffer()
    //   +     NS_CopyProjectLinkBuffer()
    //   +     NS_CalcStartDates()
    //   +     NS_AddWorkingDays()
    //   +     NS_SetPredecessorValues()
    //   +     NS_ExportTasksToMSProject()
    //   +     SetQuoteNo()
    //   +     NS_ExportTasksToMSProject()
    //   +
    //   +  - Added global variable(s):
    //   +     NS_CurrentJobNo
    //   +     NS_Job
    //   +     NS_JobOSFileName
    //   +     NS_JobTask
    //   +     NS_JobSetup
    //   +     NS_ProjLinkBuf
    //   +     NS_TempProjectLinkBuffer
    //   +     NS_Window
    //   +
    //   +  - Added Text Constants:
    //   +     Text14021101
    //   +     Text14021102
    //   +     Text14021103
    //   +     Text14021104
    //   +     Text14021105
    //   +     Text14021106
    //   +     Text14021107
    //   +     Text14021108
    //   +     Text14021109
    //   +     Text14021110
    //   +     Text14021111
    //   +     Text14021112
    //   +     Text14021113
    //   +     Text14021114
    //   +     Text14021115
    //   +     Text14021116
    //   +     Text14021117
    //   +     Text14021118
    //   +     Text14021119
    //   +     Text14021120
    //   +     Text14021121
    //   +     Text14021122
    //   +     Text14021123
    //   +     Text14021124
    //   +     Text14021125
    //   +     Text14021126
    //   +     Text14021127
    //   +
    //   +  - Modification(s):
    //   +     - OnOpenPage: Set filter to current Job No.
    //   +     - OnAfterGetRecord: assign variable containing file name to use for Project Link
    //   +     - Added OnLookup code for Job Task No.
    //   +     - Changed fields PE % Complete to % Complete, DE Estimated Hours to Estimated Hours
    //   +     - Removed fields that were deleted from the table
    //   +     - Added Project Link functions menu
    //   +     - Added Action Item 'XMLImport'
    //   +     - Added Action Item 'Job Rcvd Not Invoiced'
    //   +     - Added code to OnInsert to set Quote No. appropriately
    //   +     - Show the Descrition of the task if the 'Job Task No.' is entered manually
    //   +------------------------------------------------------------
}

