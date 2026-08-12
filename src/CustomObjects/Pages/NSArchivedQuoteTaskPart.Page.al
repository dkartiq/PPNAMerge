page 14021449 "NS_Archived Quote Task Part"
{
    // "a3b03edf-3f59-46a5-9644-a1f4a6b1d289"
    //SPLN1.00 2019-02-12 DMT Created to mach BC365 requarements. Copy of page 14021441, changed type to ListPart
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-872.JS.1.0  13Sep2021
    //PRJ-1102.RM.1.0 29Dec2021 | Removed  statement

    Caption = 'Archived Quote Task Lines';
    DataCaptionFields = "NS_Job No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SaveValues = true;
    SourceTable = "NS_Archived Quote Task";
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    Editable = false;     //PRJ-872.JS.1.0  13Sep2021

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                IndentationColumn = DescriptionIndent;
                IndentationControls = Description;
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = Jobs;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'Specifies the number of the job that the job task is related to.';
                    Visible = false;
                }
                field("Job Task No."; Rec."NS_Job Task No.")
                {
                    ApplicationArea = Jobs;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'Specifies the number of the job task you are setting up. You can enter a maximum of 20 characters, both numbers and letters.';

                    trigger OnLookup(VAR Text: Text): Boolean;
                    var
                        PP_PickAPOCode: Page "NS_Pick APO Code";
                        PP_Description2: Text[50];
                        // >> Upgrade
                        JobAct: Code[20];
                    // << Upgrade
                    begin
                        CLEAR(PP_PickAPOCode);
                        PP_PickAPOCode.LOOKUPMODE(true);
                        // >> Upgrade
                        // PP_PickAPOCode.NS_SetInput("NS_Job No.", "NS_Job Task No.", 0);
                        PP_PickAPOCode.NS_SetInput("NS_Job No.", "NS_Job Task No.", JobAct, 0);
                        // << Upgrade
                        if PP_PickAPOCode.RUNMODAL() = ACTION::LookupOK then begin
                            // >> Upgrade
                            // PP_PickAPOCode.NS_GetResult("NS_Job Task No.", PP_Description2);
                            PP_PickAPOCode.NS_GetResult("NS_Job Task No.", PP_Description2, JobAct);
                            // << Upgrade
                            Rec.NS_Description := PP_JobTask.NS_GetJobTaskDescription(Rec."NS_Job No.", Rec."NS_Job Task No.");
                            if Rec.NS_Description = '' then
                                Rec.NS_Description := PP_Description2;
                        end;
                    end;
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = Jobs;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'Specifies a description of the job task. You can enter anything that is meaningful in describing the task. The description is copied and used in descriptions on the job planning line.';
                }
                field("Job Task Type"; Rec."NS_Job Task Type")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the purpose of the account. Newly created accounts are automatically assigned the Posting account type, but you can change this. Choose the field to select one of the following five options:';
                }
                field("PP Burden Percent"; Rec."NS_Burden Percent")
                {
                    ToolTip = 'Specifies the Burden Percent';
                    ApplicationArea = All;
                }
                field("PP Task Before"; Rec."NS_Task Before")
                {
                    ToolTip = 'Specifies the Task Before';
                    ApplicationArea = All;
                }
                field("PP Start Date Fixed"; Rec."NS_Start Date Fixed")
                {
                    ToolTip = 'Specifies the Start Date Fixed';
                    ApplicationArea = All;
                }
                field("PP Task Start Date"; Rec."NS_Task Start Date")
                {
                    ToolTip = 'Specifies the Task Start Date';
                    ApplicationArea = All;
                }
                field("PP Task End Date"; Rec."NS_Task End Date")
                {
                    ToolTip = 'Specifies the Task End Date';
                    ApplicationArea = All;
                }
                field("PP Task Days"; Rec."NS_Task Days")
                {
                    ToolTip = 'Specifies the Task Days';
                    ApplicationArea = All;
                }
                field("PP Task Lag Days"; Rec."NS_Task Lag Days")
                {
                    ToolTip = 'Specifies the Task Lag Days';
                    ApplicationArea = All;
                }
                field("PP Resource No."; Rec."NS_Resource No.")
                {
                    ToolTip = 'Specifies the Resource No.';
                    ApplicationArea = All;
                }
                field(Totaling; Rec.NS_Totaling)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies an interval or a list of job task numbers.';
                }
                field("Job Posting Group"; Rec."NS_Job Posting Group")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the job posting group of the task.';
                }
                field("Total Percent Complete"; Rec."NS_Total Percent Complete")
                {
                    ToolTip = 'Specifies the Total Percent Complete';
                    ApplicationArea = All;
                }
                field("Total Percent Complete Date"; Rec."NS_Total Percent Complete Date")
                {
                    ToolTip = 'Specifies the Total Percent Complete Date';
                    ApplicationArea = All;
                }
                field("Billing Percent"; Rec."NS_Billing Percent")
                {
                    ToolTip = 'Specifies the Billing Percent';
                    ApplicationArea = All;
                }
                field("Billing Percent Date"; Rec."NS_Billing Percent Date")
                {
                    ToolTip = 'Specifies the Billing Percent Date';
                    ApplicationArea = All;
                }
                field("WIP-Total"; Rec."NS_WIP-Total")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the job tasks you want to group together when calculating Work In Process (WIP) and Recognition.';
                }
                field("WIP Method"; Rec."NS_WIP Method")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the name of the Work in Process calculation method that is associated with a job. The value in this field comes from the WIP method specified on the job card.';
                }
                field("Start Date"; Rec."NS_Start Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the start date for the job task. The date is based on the date on the related job planning line.';
                }
                field("End Date"; Rec."NS_End Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the end date for the job task. The date is based on the date on the related job planning line.';
                }
                field("Schedule (Total Cost)"; Rec."NS_Schedule (Total Cost)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies, in the local currency, the total budgeted cost for the job task during the time period in the Planning Date Filter field.';
                }
                field("Schedule (Total Price)"; Rec."NS_Schedule (Total Price)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies, in local currency, the total budgeted price for the job task during the time period in the Planning Date Filter field.';
                }
                field("Usage (Total Cost)"; Rec."NS_Usage (Total Cost)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies, in local currency, the total cost of the usage of items, resources and general ledger expenses posted on the job task during the time period in the Posting Date Filter field.';
                }
                field("Usage (Total Price)"; Rec."NS_Usage (Total Price)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies, in the local currency, the total price of the usage of items, resources and general ledger expenses posted on the job task during the time period in the Posting Date Filter field.';
                }
                field("Contract (Total Cost)"; Rec."NS_Contract (Total Cost)")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Billable (Total Cost)';
                    ToolTip = 'Specifies, in local currency, the total billable cost for the job task during the time period in the Planning Date Filter field.';
                }
                field("Contract (Total Price)"; Rec."NS_Contract (Total Price)")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Billable (Total Price)';
                    ToolTip = 'Specifies, in the local currency, the total billable price for the job task during the time period in the Planning Date Filter field.';
                }
                field("Contract (Invoiced Cost)"; Rec."NS_Contract (Invoiced Cost)")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Billable (Invoiced Cost)';
                    ToolTip = 'Specifies, in the local currency, the total billable cost for the job task that has been invoiced during the time period in the Posting Date Filter field.';
                }
                field("Contract (Invoiced Price)"; Rec."NS_Contract (Invoiced Price)")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Billable (Invoiced Price)';
                    ToolTip = 'Specifies, in the local currency, the total billable price for the job task that has been invoiced during the time period in the Posting Date Filter field.';
                }
                field("Remaining (Total Cost)"; Rec."NS_Remaining (Total Cost)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the remaining total cost ($) as the sum of costs from job planning lines associated with the job task. The calculation occurs when you have specified that there is a usage link between the job ledger and the job planning lines.';
                }
                field("Remaining (Total Price)"; Rec."NS_Remaining (Total Price)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the remaining total price ($) as the sum of prices from job planning lines associated with the job task. The calculation occurs when you have specified that there is a usage link between the job ledger and the job planning lines.';
                }
                field("EAC (Total Cost)"; Rec.NS_CalcEACTotalCost())
                {
                    ApplicationArea = Jobs;
                    Caption = 'EAC (Total Cost)';
                    ToolTip = 'Specifies the estimate at completion (EAC) total cost for a job task line. If the Apply Usage Link check box on the job is selected, then the EAC (Total Cost) field is calculated as follows:';
                }
                field("EAC (Total Price)"; Rec.NS_CalcEACTotalPrice())
                {
                    ApplicationArea = Jobs;
                    Caption = 'EAC (Total Price)';
                    ToolTip = 'Specifies the estimate at completion (EAC) total price for a job task line. If the Apply Usage Link check box on the job is selected, then the EAC (Total Price) field is calculated as follows:';
                }
                field("Global Dimension 1 Code"; Rec."NS_Global Dimension 1 Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the dimension value code that the job task is linked to. You cannot change the code because the entry has been posted.';
                    Visible = false;
                }
                field("Global Dimension 2 Code"; Rec."NS_Global Dimension 2 Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the dimension value code that the job task is linked to. You cannot change the code because the entry has been posted.';
                    Visible = false;
                }
                field("Outstanding Orders"; Rec."NS_Outstanding Orders")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies the sum of outstanding orders, in local currency, for this job task. The value of the Outstanding Amount ($) field is used for entries in the Purchase Line table of document type Order to calculate and update the contents of this field.';
                    Visible = false;

                    trigger OnDrillDown();
                    var
                        PurchLine: Record "Purchase Line";
                    begin
                        NS_SetPurchLineFilters(PurchLine);
                        PurchLine.SETFILTER("Outstanding Amount (LCY)", '<> 0');
                        PAGE.RUNMODAL(PAGE::"Purchase Lines", PurchLine);
                    end;
                }
                field("Amt. Rcd. Not Invoiced"; Rec."NS_Amt. Rcd. Not Invoiced")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies the sum, in the local currency, for items that you have received but have not yet been invoiced. The value in the Amt. Rcd. Not Invoiced ($) field is used for entries in the Purchase Line table of document type Order to calculate and update the contents of this field.';
                    Visible = false;

                    trigger OnDrillDown();
                    var
                        PurchLine: Record "Purchase Line";
                    begin
                        NS_SetPurchLineFilters(PurchLine);
                        PurchLine.SETFILTER("Amt. Rcd. Not Invoiced (LCY)", '<> 0');
                        PAGE.RUNMODAL(PAGE::"Purchase Lines", PurchLine);
                    end;
                }
                field("Percent Complete"; Rec."NS_Percent Complete")
                {
                    ToolTip = 'Specifies the Percent Complete';
                    ApplicationArea = All;
                }
                field("Estimated Hours"; Rec."NS_Estimated Hours")
                {
                    ToolTip = 'Specifies the Estimated Hours';
                    ApplicationArea = All;
                }
                field("Percent Materials"; Rec."NS_Percent Materials")
                {
                    ToolTip = 'Specifies the Percent Materials';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group("&Job Task")
            {
                Caption = '&Job Task';
                Image = Task;
                action(NS_JobPlanningLines)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Job &Planning Lines';
                    Image = JobLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+Ctrl+P';
                    ToolTip = 'View all planning lines for the job. You use this window to plan what items, resources, and general ledger expenses that you expect to use on a job (budget) or you can specify what you actually agreed with your customer that they should pay for the job (billable).';

                    trigger OnAction();
                    var
                        JobPlanningLine: Record "NS_Archived QuotePlanningLine";
                        JobPlanningLines: Page "NS_Archived QuotePlanningLines";
                    begin
                        Rec.TESTFIELD("NS_Job Task Type", Rec."NS_Job Task Type"::Posting);
                        Rec.TESTFIELD("NS_Job No.");
                        Rec.TESTFIELD("NS_Job Task No.");
                        JobPlanningLine.FILTERGROUP(2);
                        JobPlanningLine.SETRANGE("NS_Job No.", Rec."NS_Job No.");
                        JobPlanningLine.SETRANGE("NS_Job Task No.", Rec."NS_Job Task No.");
                        JobPlanningLine.SETRANGE(NS_Revision, Rec.NS_Revision);
                        JobPlanningLine.FILTERGROUP(0);
                        JobPlanningLines.NS_SetJobTaskNoVisible(false);
                        JobPlanningLines.NS_SetJobNo(Rec."NS_Job No.");
                        JobPlanningLines.SETTABLEVIEW(JobPlanningLine);
                        JobPlanningLines.RUN();
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        DescriptionIndent := Rec.NS_Indentation;
        StyleIsStrong := Rec."NS_Job Task Type" <> REC."NS_Job Task Type"::Posting;

        if PP_Job.GET(Rec."NS_Job No.") then
            PP_JobOSFileName := PP_Job."NS_OS File Name"
        else
            PP_JobOSFileName := '';
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        if (Rec."NS_Quote No." = '') and (QuoteNo <> '') then
            Rec."NS_Quote No." := QuoteNo;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        Rec.NS_ClearTempDim();
    end;

    trigger OnOpenPage();
    begin
        if PP_CurrentJobNo <> '' then begin
            Rec.FILTERGROUP := 2;
            Rec.SETRANGE("NS_Job No.", PP_CurrentJobNo);
            Rec.FILTERGROUP := 0;
        end;
    end;

    var
        [InDataSet]
        DescriptionIndent: Integer;
        [InDataSet]
        StyleIsStrong: Boolean;
        PP_CurrentJobNo: Code[20];
        PP_Job: Record Job;
        PP_JobOSFileName: Text[150];
        //Text14021101: TextConst ENU = 'Current process @1@@@@@@@@@@@@@@@\', ENC = 'Current process @1@@@@@@@@@@@@@@@\';
        Text14021102Lbl: Label 'Task Before %1  is not a valid task in the job.';
        Text14021103Lbl: Label 'There must be an initial start date to calculate dates for the  rest of the job.';
        Text14021104Lbl: Label 'There is no file name defined.';
        Text14021105Lbl: Label 'The calendar named for the job does not exist.';
        Text14021106Lbl: Label 'The calendar named in the job setup does not exist.';
        Text14021107Lbl: Label 'A calendar could not be found to use for date calculations.\\There must be one defined in the Jobs setup area.';
        PP_JobTask: Record "Job Task";
        PP_JobsSetup: Record "Jobs Setup";
        PP_ProjLinkBuf: Record "NS_Project Link Buffer";
        PP_TempProjectLinkBuffer: Record "NS_Project Link Buffer" temporary;
        Text14021108Lbl: Label 'JOB TYPE';
        Text14021109Lbl: Label 'PHASE';
        // PP_Window: Dialog;
        // Text14021110Lbl: Label 'Text1';
        // Text14021111Lbl: Label 'Text2';
        // Text14021112Lbl: Label 'Text3';
        // Text14021113Lbl: Label 'Outline Level';
        // Text14021114: Label 'Name';
        // Text14021115: Label 'Start';
        // Text14021116: Label 'Finish';
        // Text14021117: Label 'Resource Names';
        // Text14021118: Label 'Duration';
        // Text14021119: Label 'Work';
        // Text14021120: Label 'Actual Work';
        // Text14021121: Label 'Cost';
        // Text14021122: Label 'Cost1';
        // Text14021123: Label 'Predecessors';
        // Text14021124: Label 'Successors';
        // Text14021125: TextConst ENU = 'Current process @1@@@@@@@@@@@@@@@\', ENC = 'Current process @1@@@@@@@@@@@@@@@\';
        // Text14021126: TextConst ENU = 'There is no file name defined.', ENC = 'There is no file name defined.';
        QuoteNo: Code[20];

    procedure NS_SetPurchLineFilters(var PurchLine: Record "Purchase Line");
    begin
        PurchLine.SETCURRENTKEY("Document Type", "Job No.", "Job Task No.");
        PurchLine.SETRANGE("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SETRANGE("Job No.", Rec."NS_Job No.");
        if Rec."NS_Job Task Type" in [Rec."NS_Job Task Type"::Total, Rec."NS_Job Task Type"::"End-Total"] then
            PurchLine.SETFILTER("Job Task No.", Rec.NS_Totaling)
        else
            PurchLine.SETRANGE("Job Task No.", Rec."NS_Job Task No.");
    end;

    procedure NS_SetJobNo(CurrentJobNo2: Code[20]);
    begin
        PP_CurrentJobNo := CurrentJobNo2;
    end;

    procedure NS_GetTask(): Code[35];
    begin
        exit(Rec."NS_Job Task No.");
    end;

    procedure NS_ClearJobStartDates();
    var
        JobTask: Record "Job Task";
    begin
        //Clear all start dates in Job Task for the job unless a particular task has a fixed start date.
        //PRJ-1102.RM.1.0.001 29Dec2021 Start
        // PP_JobTask do begin
        PP_JobTask.RESET();
        PP_JobTask.SETRANGE("Job No.", PP_CurrentJobNo);
        if PP_JobTask.FINDSET() then
            repeat
                if not PP_JobTask."NS_Start Date Fixed" then
                    PP_JobTask."NS_Task Start Date" := 0D;
                PP_JobTask."NS_Task End Date" := 0D;
                PP_JobTask.MODIFY();
            until PP_JobTask.NEXT() = 0;
        //end;
        //PRJ-1102.RM.1.0.001 29Dec2021 End
    end;

    procedure NS_PrepareTasksForExport();
    begin
        //Populate a job's task records with Start and End dates, to prep forexport.
        //This separate step allows the user to modify dates as desired before the export
        NS_BuildProjectLinkBuffer();
        NS_CalcStartDates();

        //Update table  new calculated dates
        //PRJ-1102.RM.1.0.002 29Dec2021 Start
        // PP_TempProjectLinkBuffer do begin
        PP_TempProjectLinkBuffer.RESET();
        if PP_TempProjectLinkBuffer.FINDSET() then
            repeat
                if PP_JobTask.GET(Rec."NS_Job No.", PP_TempProjectLinkBuffer."NS_Task No.") then begin
                    PP_JobTask."NS_Task Start Date" := Rec."NS_Start Date";
                    PP_JobTask."NS_Task End Date" := PP_TempProjectLinkBuffer."NS_Finish Date";
                    PP_JobTask.MODIFY();
                end;
            until PP_TempProjectLinkBuffer.NEXT() = 0;
        //end;
        //PRJ-1102.RM.1.0.002 29Dec2021 End
    end;

    procedure NS_BuildProjectLinkBuffer();
    var
        PP_Separator: Text[1];
        PP_SeparatorCount: Integer;
        PP_LineNo: Integer;
        PP_JobNo: Code[20];
        PP_JobTaskNo: Code[20];
        PP_APOPosition: Integer;
        PP_Duration: Decimal;
    begin
        //Build the temporary Project Link Buffer table from the Job Tasks
        PP_JobsSetup.GET();
        PP_Separator := PP_JobsSetup."NS_APO Separators";
        PP_TempProjectLinkBuffer.RESET();
        PP_TempProjectLinkBuffer.DELETEALL();
        PP_LineNo := 0;
        NS_SetJobNo(Rec."NS_Job No.");
        //PRJ-1102.RM.1.0.003 29Dec2021 Start
        // PP_JobTask do begin
        PP_JobTask.RESET();
        PP_JobTask.SETRANGE("Job No.", PP_CurrentJobNo);
        if PP_JobTask.FINDSET() then begin
            if (PP_JobTask."Job Task Type" <> PP_JobTask."Job Task Type"::Total) and (PP_JobTask."Job Task Type" <> PP_JobTask."Job Task Type"::"End-Total") then begin
                //Create the first line for the job itself
                PP_TempProjectLinkBuffer.INIT();
                PP_TempProjectLinkBuffer."NS_Job No." := PP_JobTask."Job No.";
                PP_LineNo += 1;
                PP_TempProjectLinkBuffer."NS_Line No." := PP_LineNo;
                PP_TempProjectLinkBuffer."NS_Master Job No." := PP_JobTask."Job No.";
                PP_TempProjectLinkBuffer."NS_Job Type" := Text14021108Lbl;
                PP_TempProjectLinkBuffer."NS_Task Name" := FORMAT(PP_Job.Description, 30);
                PP_TempProjectLinkBuffer."NS_Outline Level" := 1;
                PP_TempProjectLinkBuffer."NS_Start Date" := PP_JobTask."NS_Task Start Date";
                PP_TempProjectLinkBuffer."NS_Finish Date" := PP_JobTask."NS_Task End Date";
                PP_TempProjectLinkBuffer.INSERT();
            end;

            //Now do the rest of the job
            repeat
                if (PP_JobTask."Job Task Type" <> PP_JobTask."Job Task Type"::Total) and (PP_JobTask."Job Task Type" <> PP_JobTask."Job Task Type"::"End-Total") then begin
                    PP_SeparatorCount := 0;
                    PP_JobTaskNo := PP_JobTask."Job Task No.";
                    PP_APOPosition := STRPOS(PP_JobTaskNo, PP_Separator);
                    while PP_APOPosition > 0 do begin
                        PP_SeparatorCount += 1;
                        PP_JobTaskNo := COPYSTR(PP_JobTaskNo, PP_APOPosition + 1);
                        PP_APOPosition := STRPOS(PP_JobTaskNo, PP_Separator);
                    end;

                    //Add a record for the task line
                    PP_TempProjectLinkBuffer.INIT();
                    PP_TempProjectLinkBuffer."NS_Job No." := PP_JobTask."Job No.";
                    PP_LineNo += 1;
                    PP_TempProjectLinkBuffer."NS_Line No." := PP_LineNo;
                    PP_TempProjectLinkBuffer."NS_Master Job No." := PP_JobTask."Job No.";
                    PP_TempProjectLinkBuffer."NS_Job Type" := Text14021108Lbl;
                    PP_TempProjectLinkBuffer."NS_Task No." := PP_JobTask."Job Task No.";
                    PP_TempProjectLinkBuffer."NS_Task Name" := FORMAT(PP_JobTask."Job Task No." + ' ' + PP_JobTask.Description, 30);
                    PP_TempProjectLinkBuffer."NS_Job Task Type" := PP_JobTask."Job Task Type";
                    PP_TempProjectLinkBuffer."NS_Task Before" := PP_JobTask."NS_Task Before";
                    case PP_SeparatorCount of
                        0:
                            PP_TempProjectLinkBuffer."NS_Outline Level" := 2;
                        1:
                            PP_TempProjectLinkBuffer."NS_Outline Level" := 3;
                        2:
                            PP_TempProjectLinkBuffer."NS_Outline Level" := 4;
                    end;
                    PP_TempProjectLinkBuffer.NS_Level := Text14021109Lbl;
                    PP_TempProjectLinkBuffer."NS_Start Date" := PP_JobTask."NS_Task Start Date";
                    PP_TempProjectLinkBuffer."NS_Finish Date" := PP_JobTask."NS_Task End Date";
                    PP_TempProjectLinkBuffer."NS_Resource No." := PP_JobTask."NS_Resource No.";
                    PP_TempProjectLinkBuffer.NS_Duration := PP_JobTask."NS_Task Days";
                    PP_TempProjectLinkBuffer.NS_Lag := PP_JobTask."NS_Task Lag Days";
                    PP_TempProjectLinkBuffer.INSERT();
                end;
            until PP_JobTask.NEXT() = 0;
        end;
        // end;
        //PRJ-1102.RM.1.0.003 29Dec2021 End
    end;

    procedure NS_CopyProjectLinkBuffer();
    begin
        //Copy the temporary Project Link Buffer table into another table for use by other routines
        PP_ProjLinkBuf.RESET();
        PP_ProjLinkBuf.DELETEALL();
        //PRJ-1102.RM.1.0.004 29Dec2021 Start
        // PP_TempProjectLinkBuffer do begin
        PP_TempProjectLinkBuffer.RESET();
        if PP_TempProjectLinkBuffer.FINDSET() then begin
            repeat
                PP_ProjLinkBuf.INIT();
                PP_ProjLinkBuf.COPY(PP_TempProjectLinkBuffer);
                PP_ProjLinkBuf.INSERT()
        until PP_TempProjectLinkBuffer.NEXT() = 0;
        end;
        //end;
        //PRJ-1102.RM.1.0.004 29Dec2021 End
    end;

    procedure NS_CalcStartDates();
    var
        PP_TaskBeforeHold: Code[20];
        PP_LineNo: Integer;
        PP_NextStartDate: Date;
    begin
        //Calculate the start dates of the tasks in the temporary table  ability for a project calendar override value
        NS_SetPredecessorValues();
        NS_CopyProjectLinkBuffer();

        //Fill in the start dates  previous date plus days of duration
        //  However if the task has its own start date then leave it alone and start over from there.
        //PRJ-1102.RM.1.0.005 29Dec2021 Start
        // PP_TempProjectLinkBuffer do begin
        PP_TaskBeforeHold := '';
        PP_TempProjectLinkBuffer.RESET();
        if PP_TempProjectLinkBuffer.FINDSET() then begin
            if PP_TempProjectLinkBuffer."NS_Start Date" <> 0D then
                PP_NextStartDate := PP_TempProjectLinkBuffer."NS_Start Date"
            else
                ERROR(Text14021103Lbl);
            repeat
                if (PP_TempProjectLinkBuffer."NS_Job Task Type" = PP_TempProjectLinkBuffer."NS_Job Task Type"::Posting) and (PP_LineNo > 1) then begin
                    //Get the predecessor record
                    PP_ProjLinkBuf.RESET();
                    PP_ProjLinkBuf.SETCURRENTKEY("NS_Job No.", "NS_Task No.", "NS_Line No.");
                    PP_ProjLinkBuf.SETRANGE("NS_Job No.", PP_TempProjectLinkBuffer."NS_Job No.");
                    PP_ProjLinkBuf.SETRANGE("NS_Task No.", PP_TempProjectLinkBuffer."NS_Task Before");
                    PP_ProjLinkBuf.FINDFIRST();

                    if Rec."NS_Start Date" = 0D then begin
                        //Calculate a new start date
                        if (PP_ProjLinkBuf.NS_Lag > 0) and (PP_ProjLinkBuf."NS_Finish Date" > 0D) then begin
                            PP_TempProjectLinkBuffer."NS_Start Date" := CALCDATE('+' + FORMAT(PP_ProjLinkBuf.NS_Lag + 1) + 'D', PP_ProjLinkBuf."NS_Finish Date");
                            Rec."NS_Start Date" := NS_AddWorkingDays(PP_ProjLinkBuf."NS_Job No.", Rec."NS_Start Date", 0);
                        end else
                            if PP_ProjLinkBuf."NS_Finish Date" > 0D then
                                PP_TempProjectLinkBuffer."NS_Start Date" := NS_AddWorkingDays(PP_ProjLinkBuf."NS_Job No.", PP_ProjLinkBuf."NS_Finish Date", 1)
                            else
                                PP_TempProjectLinkBuffer."NS_Start Date" := PP_NextStartDate;
                    end;

                    //Calculate a finish date
                    if PP_TempProjectLinkBuffer."NS_Start Date" > 0D then
                        Rec."NS_End Date" := NS_AddWorkingDays(PP_ProjLinkBuf."NS_Job No.", PP_TempProjectLinkBuffer."NS_Start Date", PP_TempProjectLinkBuffer.NS_Duration - 1);

                    //Update ProjectLinkBuffer
                    PP_TempProjectLinkBuffer.MODIFY();

                    //Update ProjLinkBuf with new values
                    PP_ProjLinkBuf.RESET();
                    PP_ProjLinkBuf.SETCURRENTKEY("NS_Job No.", "NS_Task No.", "NS_Line No.");
                    PP_ProjLinkBuf.SETRANGE("NS_Job No.", PP_TempProjectLinkBuffer."NS_Job No.");
                    PP_ProjLinkBuf.SETRANGE("NS_Task No.", Rec."NS_Job Task No.");
                    if PP_ProjLinkBuf.FINDFIRST() then begin
                        PP_ProjLinkBuf."NS_Start Date" := Rec."NS_Start Date";
                        PP_ProjLinkBuf."NS_Finish Date" := Rec."NS_End Date";
                        PP_ProjLinkBuf.MODIFY()
                    end;

                    //Set the next start date
                    if Rec."NS_End Date" > 0D then
                        PP_NextStartDate := NS_AddWorkingDays(PP_ProjLinkBuf."NS_Job No.", Rec."NS_End Date", 1);
                end;
            until PP_TempProjectLinkBuffer.NEXT() = 0;
        end;
        //end;
        //PRJ-1102.RM.1.0.005 29Dec2021 End
    end;

    procedure NS_AddWorkingDays(JobNo: Code[20]; WorkDate: Date; Days: Integer): Date;
    var
        PP_BaseCalendar: Record "Base Calendar";
        PP_JobCalendar: Record "NS_Job Calendar";
        PP_CalendarManagement: Codeunit "Calendar Management";
        PP_JobCalendarManagement: Codeunit "NS_Job Calendar Management";
        PP_CalendarCode: Code[10];
        PP_Description: Text[50];
        PP_NonWorkingDate: Boolean;
        PP_NewDate: Date;
        PP_DayCount: Integer;
    begin
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
        if PP_JobsSetup."NS_Job Calendars Not Used" then begin
            //Calendars not being used, so just add days one-by-one.
            PP_NewDate := WorkDate;
            if Days > 0 then
                for PP_DayCount := 1 to Days do
                    PP_NewDate := CALCDATE('+1D', PP_NewDate);
            exit(PP_NewDate);
        end;

        //Find a Calendar to use
        PP_CalendarCode := '';
        if JobNo > '' then
            if PP_Job.GET(JobNo) then
                if PP_Job."NS_Job Calendar Code" > '' then
                    //PRJCTPR-308.DK.1.0 11June2024 Start
                    // if PP_JobsSetup."NS_Job Calendar Source" = PP_JobsSetup."NS_Job Calendar Source"::"Business Central Calendar" then begin //PRJ-1070.RM.1.0 08Dec2021
                    if PP_JobsSetup."NS_JobCalendarSource" = PP_JobsSetup."NS_JobCalendarSource"::"Business Central Calendar" then begin
                        //PRJCTPR-308.DK.1.0 11June2024 End
                        if PP_BaseCalendar.GET(PP_Job."NS_Job Calendar Code") then
                            PP_CalendarCode := PP_Job."NS_Job Calendar Code"
                        else
                            ERROR(Text14021105Lbl);
                    end else begin
                        if PP_JobCalendar.GET(PP_Job."NS_Job Calendar Code") then
                            PP_CalendarCode := PP_Job."NS_Job Calendar Code"
                        else
                            ERROR(Text14021105Lbl);
                    end;

        if PP_CalendarCode = '' then
            //PRJCTPR-308.DK.1.0 11June2024 Start
            // if PP_JobsSetup."NS_Job Calendar Source" = PP_JobsSetup."NS_Job Calendar Source"::"Business Central Calendar" then begin //PRJ-1070.RM.1.0 08Dec2021
            if PP_JobsSetup."NS_JobCalendarSource" = PP_JobsSetup."NS_JobCalendarSource"::"Business Central Calendar" then begin
                //PRJCTPR-308.DK.1.0 11June2024 End
                if PP_BaseCalendar.GET(PP_JobsSetup."NS_Job Calendar Code") then
                    PP_CalendarCode := PP_JobsSetup."NS_Job Calendar Code"
                else
                    ERROR(Text14021106Lbl);
            end else begin
                if PP_JobCalendar.GET(PP_JobsSetup."NS_Job Calendar Code") then
                    PP_CalendarCode := PP_JobsSetup."NS_Job Calendar Code"
                else
                    ERROR(Text14021106Lbl);
            end;

        if PP_CalendarCode = '' then
            ERROR(Text14021107Lbl);

        PP_NewDate := WorkDate;
        if Days > 0 then
            for PP_DayCount := 1 to Days do begin
                repeat
                    PP_NewDate := CALCDATE('+1D', PP_NewDate);
                    //PRJCTPR-308.DK.1.0 11June2024 Start
                    // if PP_JobsSetup."NS_Job Calendar Source" = PP_JobsSetup."NS_Job Calendar Source"::"Business Central Calendar" then //PRJ-1070.RM.1.0 08Dec2021
                    if PP_JobsSetup."NS_JobCalendarSource" = PP_JobsSetup."NS_JobCalendarSource"::"Business Central Calendar" then
                        //PRJCTPR-308.DK.1.0 11June2024 End
                        // PP_NonWorkingDate := PP_CalendarManagement.CheckDateStatus(PP_CalendarCode, PP_NewDate, PP_Description)//PPNA16.0 Blocked
                        PP_NonWorkingDate := true //PPNA16.0 Added
                    else
                        //PP_NonWorkingDate := PP_JobCalendarManagement.CheckDateStatus(PP_CalendarCode, PP_NewDate, PP_Description) //PPNA16.0 Blocked
                        PP_NonWorkingDate := true; //PPNA16.0 Added
                until PP_NonWorkingDate = false;
            end
        else begin
            //PRJCTPR-308.DK.1.0 11June2024 Start
            //if PP_JobsSetup."NS_Job Calendar Source" = PP_JobsSetup."NS_Job Calendar Source"::"Business Central Calendar" then //PRJ-1070.RM.1.0 08Dec2021
            if PP_JobsSetup."NS_JobCalendarSource" = PP_JobsSetup."NS_JobCalendarSource"::"Business Central Calendar" then
                //PRJCTPR-308.DK.1.0 11June2024 End
                //PP_NonWorkingDate := PP_CalendarManagement.CheckDateStatus(PP_CalendarCode, PP_NewDate, PP_Description)//PPNA16.0 Blocked
                PP_NonWorkingDate := true //PPNA16.0 Added
            else
                //PP_NonWorkingDate := PP_JobCalendarManagement.CheckDateStatus(PP_CalendarCode, PP_NewDate, PP_Description); //PPNA16.0 Blocked
                PP_NonWorkingDate := true; //PPNA16.0 Added
            if PP_NonWorkingDate then
                repeat
                    PP_NewDate := CALCDATE('+1D', PP_NewDate);
                    //PRJCTPR-308.DK.1.0 11June2024 Start
                    // if PP_JobsSetup."NS_Job Calendar Source" = PP_JobsSetup."NS_Job Calendar Source"::"Business Central Calendar" then //PRJ-1070.RM.1.0 08Dec2021
                    if PP_JobsSetup."NS_JobCalendarSource" = PP_JobsSetup."NS_JobCalendarSource"::"Business Central Calendar" then
                        //PRJCTPR-308.DK.1.0 11June2024 End
                        //PP_NonWorkingDate := PP_CalendarManagement.CheckDateStatus(PP_CalendarCode, PP_NewDate, PP_Description)//PPNA16.0 Blocked
                        PP_NonWorkingDate := true //PPNA16.0 Added
                    else
                        //PP_NonWorkingDate := PP_JobCalendarManagement.CheckDateStatus(PP_CalendarCode, PP_NewDate, PP_Description); //PPNA16.0 Blocked
                        PP_NonWorkingDate := true; //PPNA16.0 Added
                until PP_NonWorkingDate = false;
        end;

        exit(PP_NewDate);
    end;

    procedure NS_SetPredecessorValues();
    var
        PP_TaskBeforeHold: Code[20];
    begin
        //Set the "Task Before" fields for the job based on sequence and any "Task Before" values.  Also sets the predecessor values.
        //PRJ-1102.RM.1.0.006 29Dec2021 Start
        // PP_TempProjectLinkBuffer do begin
        //Fill in the blank "Task Before" values  the preceeding task.
        //  However if the task has its own start date then leave it alone and start over from there.
        PP_TaskBeforeHold := '';
        PP_TempProjectLinkBuffer.RESET();
        if PP_TempProjectLinkBuffer.FINDSET() then
            repeat
                if (PP_TempProjectLinkBuffer."NS_Job Task Type" = PP_TempProjectLinkBuffer."NS_Job Task Type"::Posting) and (PP_TempProjectLinkBuffer."NS_Line No." > 1) then begin
                    if PP_TaskBeforeHold <> '' then
                        if PP_TempProjectLinkBuffer."NS_Task Before" = '' then begin
                            PP_TempProjectLinkBuffer."NS_Task Before" := PP_TaskBeforeHold;
                            PP_TempProjectLinkBuffer.MODIFY();
                        end;
                    PP_TaskBeforeHold := Rec."NS_Job Task No.";
                end;
            until PP_TempProjectLinkBuffer.NEXT() = 0;

        NS_CopyProjectLinkBuffer();
        PP_TempProjectLinkBuffer.RESET();
        if PP_TempProjectLinkBuffer.FINDSET() then
            repeat
                if PP_TempProjectLinkBuffer."NS_Task Before" > '' then begin
                    PP_ProjLinkBuf.RESET();
                    PP_ProjLinkBuf.SETCURRENTKEY("NS_Job No.", "NS_Task No.", "NS_Line No.");
                    PP_ProjLinkBuf.SETRANGE("NS_Job No.", PP_TempProjectLinkBuffer."NS_Job No.");
                    PP_ProjLinkBuf.SETRANGE("NS_Task No.", PP_TempProjectLinkBuffer."NS_Task Before");
                    if PP_ProjLinkBuf.FINDFIRST() then begin
                        PP_TempProjectLinkBuffer.NS_Predecessor := FORMAT(PP_ProjLinkBuf."NS_Line No.");
                        PP_TempProjectLinkBuffer.MODIFY();
                    end else
                        MESSAGE(Text14021102Lbl, PP_TempProjectLinkBuffer."NS_Task Before");
                end;
            until PP_TempProjectLinkBuffer.NEXT() = 0;
        //end;
        //PRJ-1102.RM.1.0.006 29Dec2021 End
    end;

    procedure NS_SetQuoteNo(PassQuoteNo: Code[20]);
    begin
        QuoteNo := PassQuoteNo;
    end;
}

