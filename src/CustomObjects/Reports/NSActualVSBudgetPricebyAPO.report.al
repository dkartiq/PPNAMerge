report 14021153 "NS_Actual vs Budget PricebyAPO"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-84.SK.1.0 Added report to search
    //PRJ-749.AS.1.0 Migrated this report from NAV2017 concept. As previous on was full wrong - no detail , no proper layout & data. Changes in layout also with Sections adding
    //PRJ-849 Line Amt change for Actual, Budget price

    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSActual vs Budget Price by APO.rdl';

    Caption = 'Actual vs Budget Price by APO';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(Job; Job)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Bill-to Customer No.", "NS_Date Filter", Status;

            column(Master_Job_No; "No.")
            {
            }
            dataitem("Job Planning Line"; "Job Planning Line")
            {
                DataItemLink = "Job No." = FIELD("No.");
                DataItemTableView = SORTING("Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Cost Category", Type, "No.", "Variant Code");

                trigger OnAfterGetRecord()
                begin

                    NS_SendJobBudgetsToBuffer("Job Planning Line", JobReportBuffer1."NS_Record Source"::Job);

                end;

                trigger OnPreDataItem()
                begin
                    //Get the master Job Planning Lines into the buffer
                    SETFILTER("Job No.", Job."No.");
                    SETFILTER("NS_Entry Type", '%1|%2', "NS_Entry Type"::Price, "NS_Entry Type"::Both);
                    SETFILTER("Job Task No.", Job.GETFILTER("NS_Job Task No. Filter"));
                    SETFILTER(Type, Job.GETFILTER("NS_Type Filter"));
                    SETFILTER("Planning Date", Job.GETFILTER("NS_Date Filter"));
                end;
            }
            dataitem("NS_Locked Job Planning Line"; "NS_Locked Job Planning Line")
            {
                DataItemLink = "NS_Job No." = FIELD("No.");
                DataItemTableView = SORTING("NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Cost Category", "NS_Type", "NS_No.", "NS_Variant Code");

                trigger OnAfterGetRecord()
                begin
                    NS_SendLockedJobBudgetsToBuffer("NS_Locked Job Planning Line", JobReportBuffer1."NS_Record Source"::Job);
                end;

                trigger OnPreDataItem()
                begin
                    //Get the master Locked Job Planning Lines into the buffer
                    SETFILTER("NS_Job No.", Job."No.");
                    SETFILTER("NS_Entry Type", '%1|%2', "NS_Entry Type"::Price, "NS_Entry Type"::Both);
                    SETFILTER("NS_Job Task No.", Job.GETFILTER("NS_Job Task No. Filter"));
                    SETFILTER(NS_Type, Job.GETFILTER("NS_Type Filter"));
                    SETFILTER("NS_Planning Date", Job.GETFILTER("NS_Date Filter"));
                end;
            }
            dataitem("Job Ledger Entry"; "Job Ledger Entry")
            {
                DataItemLink = "Job No." = FIELD("No.");
                DataItemTableView = SORTING("Job No.", "Job Task No.", "Entry Type", "Posting Date");

                trigger OnAfterGetRecord()
                begin
                    NS_SendJobLedgerToBuffer("Job Ledger Entry", JobReportBuffer1."NS_Record Source"::Job);
                end;

                trigger OnPreDataItem()
                begin
                    //Get the master Job Ledger Entries into the buffer
                    SETFILTER("Job No.", Job."No.");
                    SETFILTER("Job Task No.", Job.GETFILTER("NS_Job Task No. Filter"));
                    SETFILTER("Entry Type", FORMAT("Entry Type"::Sale));
                    SETFILTER("Posting Date", Job.GETFILTER("NS_Date Filter"));
                    SETFILTER(Type, Job.GETFILTER("NS_Type Filter"));
                end;
            }
            dataitem("Sub-Levels"; Job)
            {
                DataItemLink = "NS_Sub-Level to Job No." = FIELD("No.");
                DataItemTableView = SORTING("No.");
                dataitem("Job Planning Line Sub-Levels"; "Job Planning Line")
                {
                    DataItemLink = "Job No." = FIELD("No.");
                    DataItemTableView = SORTING("Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code", "NS_Cost Category", Type, "No.", "Variant Code");//PRJ-750.AS.1.0 Added section

                    trigger OnAfterGetRecord()
                    begin
                        NS_SendJobBudgetsToBuffer("Job Planning Line Sub-Levels", JobReportBuffer1."NS_Record Source"::SubJob);
                    end;

                    trigger OnPreDataItem()
                    begin
                        //Get sub-level Job Planning Lines into the buffer
                        SETFILTER("NS_Entry Type", '%1|%2', "NS_Entry Type"::Price, "NS_Entry Type"::Both);
                        SETFILTER(Type, Job.GETFILTER("NS_Type Filter"));
                        SETFILTER("Planning Date", Job.GETFILTER("NS_Date Filter"));
                        SETFILTER("Job Task No.", Job.GETFILTER("NS_Job Task No. Filter"));
                    end;
                }
                dataitem("Locked Job Planning Line SLs"; "NS_Locked Job Planning Line")
                {
                    DataItemLink = "NS_Job No." = FIELD("No.");
                    DataItemTableView = SORTING("NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Cost Category", "NS_Type", "NS_No.", "NS_Variant Code");

                    trigger OnAfterGetRecord()
                    begin
                        NS_SendLockedJobBudgetsToBuffer("Locked Job Planning Line SLs", JobReportBuffer1."NS_Record Source"::SubJob);
                    end;

                    trigger OnPreDataItem()
                    begin
                        //Get sub-level Locked Job Planning Lines into the buffer
                        SETFILTER("NS_Entry Type", '%1|%2', "NS_Entry Type"::Price, "NS_Entry Type"::Both);
                        SETFILTER("NS_Job Task No.", Job.GETFILTER("NS_Job Task No. Filter"));
                        SETFILTER(NS_Type, Job.GETFILTER("NS_Type Filter"));
                        SETFILTER("NS_Planning Date", Job.GETFILTER("NS_Date Filter"));
                    end;
                }
                dataitem("Job Ledger Entry Sub-Levels"; "Job Ledger Entry")
                {
                    DataItemLink = "Job No." = FIELD("No.");
                    DataItemTableView = SORTING("Job No.", "Job Task No.", "Entry Type", "Posting Date");

                    trigger OnAfterGetRecord()
                    begin
                        NS_SendJobLedgerToBuffer("Job Ledger Entry Sub-Levels", JobReportBuffer1."NS_Record Source"::SubJob);
                    end;

                    trigger OnPreDataItem()
                    begin
                        //Get sub-job Job Ledger Entries into the buffer
                        SETFILTER("Job Task No.", Job.GETFILTER("NS_Job Task No. Filter"));
                        SETFILTER("Entry Type", FORMAT("Entry Type"::Sale));
                        SETFILTER("Posting Date", Job.GETFILTER("NS_Date Filter"));
                        SETFILTER(Type, Job.GETFILTER("NS_Type Filter"));
                    end;
                }

                trigger OnPreDataItem()
                begin
                    IF (NOT "IncludeSub-Levels") AND (NOT "ShowSub-Levels") THEN
                        CurrReport.BREAK;
                end;
            }
            dataitem("Page Header"; integer)
            {
                DataItemTableView = SORTING(Number)
                                    ORDER(Ascending);
                MaxIteration = 1;
                column(ReportTitle; ReportTitle)
                {
                }
                column(CompanyInformationName; CompanyInformation.Name)
                {
                }
                column(PageCaption; PageLbl)
                {
                }
                column(JobFiltersCaption; JobFiltersLbl)
                {
                }
                column(ActivityProcessOperationCaption; ActivityProcessOperationLbl)
                {
                }
                column(DescriptionCaption; DescriptionLbl)
                {
                }
                column(NoCaption; NoHeadingLbl)
                {
                }
                column(TypeCaption; TypeHeadingLbl)
                {
                }
                column(ActualPriceCaption; ActualPriceLbl)
                {
                }
                column(BudgetedPriceCaption; BudgetedPriceLbl)
                {
                }
                column(BudgetRemainingCaption; BudgetRemainingLbl)
                {
                }
                column(LockedBudgetCaption; LockedBudgetLbl)
                {
                }
                column(PctOfBudUsedCaption; PctOfBudUsedLbl)
                {
                }
                column(CustomerAccountNameCaption; CustomerAccountNameLbl)
                {
                }
                column(JobLocationCaption; JobLocationLbl)
                {
                }
                column(ShowProcesses; ShowProcesses)
                {
                }
                column(ShowOperations; ShowOperations)
                {
                }
                column(Show_Sections; Showsections)
                {

                }
                column(ShowDetails; ShowDetails)
                {
                }
                column(ShowLocked; ShowLocked)
                {
                }
                column(SubLevelsText; "Sub-LevelsText")
                {
                }
                dataitem(JobAnalysisBuffer1Loop; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        ORDER(Ascending);
                    dataitem(JobAndSubJob; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            ORDER(Ascending);
                        dataitem(JobDetail; Integer)
                        {
                            DataItemTableView = SORTING(Number)
                                                ORDER(Ascending);
                            column(JobFilters; JobFilters)
                            {
                            }
                            column(JobNo; STRSUBSTNO(JobHeading, JobReportBuffer1."NS_Job No."))
                            {
                            }
                            column(job_TaskNOBuffer; JobReportBuffer1."NS_Job Task No.")//PRJ-754.AS.1.0 21JUN2021
                            {
                            }
                            column(JobDescription; Job.Description)
                            {
                            }
                            column(StartingDate; STRSUBSTNO(StartingDateHeading, Job."Starting Date"))
                            {
                            }
                            column(EndingDate; STRSUBSTNO(EndingDateHeading, Job."Ending Date"))
                            {
                            }
                            column(ActivityCode; JobReportBuffer1."NS_Activity Code")
                            {
                            }
                            column(ProcessCode; JobReportBuffer1."NS_Process Code")
                            {
                            }
                            column(OperationCode; JobReportBuffer1."NS_Operation Code")
                            {
                            }
                            column(Section_code; JobReportBuffer1."NS_Section Code")//PRJ-688.AM.1.0
                            {
                            }
                            column(Sectiondesc; Sectiondesc) { }//PRJ-688.AM.1.0
                            column(ActivityDescription; JobActivity.NS_Description)
                            {
                            }
                            column(ProcessDescription; JobProcess.NS_Description)
                            {
                            }
                            column(OperationDescription; JobOperation.NS_Description)
                            {
                            }
                            column(DetailDescription; JobReportBuffer1.NS_Description)
                            {
                            }
                            column(DetailNo; JobReportBuffer1."NS_No.")
                            {
                            }
                            column(DetailType; JobReportBuffer1.NS_Type)
                            {
                            }
                            column(DetailActualPrice; JobReportBuffer1."NS_Actual Price")
                            {
                            }
                            column(DetailBudgetedPrice; JobReportBuffer1."NS_Budgeted Price")
                            {
                            }
                            column(LockedBudgetedPrice; JobReportBuffer1."NS_Locked Budgeted Price")
                            {
                            }
                            //column(ActivityTotalCaption; STRSUBSTNO(Total) + STRSUBSTNO(ActivityHeading, JobActivity.NS_Description))
                            column(ActivityTotalCaption; STRSUBSTNO(Total) + STRSUBSTNO(' ' + JobActivity.NS_Description))//PRJ-754.AS.1.0 21JUN2021 Add
                            {
                            }
                            //column(ProcessTotalCaption; STRSUBSTNO(Total) + STRSUBSTNO(ProcessHeading, JobProcess.NS_Description))
                            column(ProcessTotalCaption; STRSUBSTNO(Total) + STRSUBSTNO(' ' + JobProcess.NS_Description))//PRJ-754.AS.1.0 21JUN2021 ADD
                            {
                            }
                            //column(OperationTotalCaption; STRSUBSTNO(Total) + STRSUBSTNO(OperationHeading, JobOperation.NS_Description))
                            column(OperationTotalCaption; STRSUBSTNO(Total) + STRSUBSTNO(' ' + JobOperation.NS_Description))//PRJ-754.AS.1.0 21JUN2021
                            {
                            }
                            //  column(Section_TotalCaption; STRSUBSTNO(Total) + STRSUBSTNO(' ' + Sectiondesc))//PRJ-754.AS.1.0 21JUN2021 Add
                            column(Section_TotalCaption; STRSUBSTNO(Total) + STRSUBSTNO(' ' + Sectiondesc))//PRJ-754.AS.1.0 21JUN2021 Add
                            { }
                            column(TotalJobNo; STRSUBSTNO(TotalJobHeading, JobReportBuffer1."NS_Job No."))
                            {
                            }
                            column(CustomerAccountName; Contact.Name)
                            {
                            }
                            column(JobName; JobRec.Description)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                WITH JobReportBuffer1 DO BEGIN

                                    IF JobDetail.Number > 1 THEN
                                        JobReportBuffer1.NEXT;

                                    //Get Contact Name
                                    JobRec.GET(JobReportBuffer1."NS_Job No.");
                                    IF NOT Contact.GET(COPYSTR(JobRec."NS_Customer Account", 1, 20)) THEN
                                        Contact.Name := '';

                                    //Clear the current Activity, Process and Operation headers since the report format depends on their values
                                    CLEAR(JobProcess);
                                    CLEAR(JobOperation);
                                    Clear(JobSection);//PRJ-688.AM.1.0

                                    NS_CheckForJobOrAPOBreak;

                                    //PRJ-184.VT.1.0 BEGIN
                                    //PRJ-184.VT.1.0 24-03-20 Begin
                                    if JobTask.GET(JobReportBuffer1."NS_Job No.", JobReportBuffer1."NS_Job Task No.") then; //PRJ-437.MS.1.0 written "if get..then"

                                    FindActivityOrProcessExists(JobReportBuffer1."NS_Job Task No.");
                                    CLEAR(ProcessDesc);
                                    CLEAR(OperationsDesc);
                                    Clear(Sectiondesc);//PRJ-688.AM.1.0

                                    IF JobProcess.NS_Code <> '' THEN BEGIN
                                        IF JobOperation.NS_Code <> '' THEN BEGIN
                                            ProcessDesc := JobProcess.NS_Description
                                        END
                                        ELSE BEGIN
                                            ProcessDesc := JobTask.Description
                                        END;


                                    END;

                                    IF JobOperation.NS_Description <> '' THEN
                                        OperationsDesc := JobTask.Description
                                    ELSE
                                        OperationsDesc := '';
                                    //PRJ-688.AM.1.0
                                    // IF JobSection.NS_Description <> '' THEN
                                    //     Sectiondesc := JobTask.Description
                                    // ELSE
                                    //     Sectiondesc := '';
                                    IF JobSection.NS_Description <> '' THEN
                                        Sectiondesc := JobSection.NS_Description
                                    ELSE
                                        Sectiondesc := JobTask.Description;
                                    //PRJ-688.AM.1.0
                                    IF NOT ShowOperations THEN
                                        IF OperationsExists THEN
                                            ProcessDesc := JobProcess.NS_Description;

                                    //PRJ-184.VT.1.0 23-03-20 End
                                    //PRJ-184.VT.1.0 END    

                                    //Add to Actual and Budget costs for this detail line
                                    // AccumulateAPOTotals(JobReportBuffer2, "NS_Entry No.", '', '', '', '', '', APOTotals);//PRJ-688.AM.1.0

                                    //Add to Actual and Budget costs for this detail line for the whole job
                                    //  Needs to be done here to generate proper values for the end of the report
                                    //AccumulateAPOTotals(JobReportBuffer2, 0, "NS_Job No.", '', '', '', '', APOTotals);//PRJ-688.AM.1.0
                                END;
                            end;

                            trigger OnPreDataItem()
                            begin
                                IF NumBudgetLines = 0 THEN
                                    CurrReport.BREAK;

                                JobDetail.SETRANGE(Number, 1, NumBudgetLines);
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            JobNoHold := '';
                            ActivityCodeHold := '';
                            ProcessCodeHold := '';
                            OperationCodeHold := '';
                            SectionCodeHold := '';//PRJ-688.AM.1.0
                            JobNo := JobReportBuffer1."NS_Job No.";
                            ActivityCode := JobReportBuffer1."NS_Activity Code";
                            ProcessCode := JobReportBuffer1."NS_Process Code";
                            OperationCode := JobReportBuffer1."NS_Operation Code";
                            SectionCode := JobReportBuffer1."NS_Section Code";//PRJ-688.AM.1.0

                        end;

                        trigger OnPreDataItem()
                        begin
                            //Get a record count and skip out if it is zero

                            WITH JobReportBuffer1 DO BEGIN
                                RESET;
                                SETCURRENTKEY("NS_Record Source");
                                SETRANGE("NS_Record Source", RecordSource);
                                NumBudgetLines := COUNT;
                                IF NumBudgetLines > 0 THEN BEGIN
                                    FINDSET;
                                    JobAndSubJob.SETRANGE(Number, 1);
                                END ELSE
                                    CurrReport.BREAK;
                            END;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        CASE Number OF
                            1:
                                RecordSource := RecordSource::Job;
                            2:
                                IF "ShowSub-Levels" THEN
                                    RecordSource := RecordSource::SubJob
                                ELSE
                                    CurrReport.SKIP;
                        END;
                    end;

                    trigger OnPreDataItem()
                    begin
                        //Start processing JobReportBuffer1 to generate report
                        //  First set is the Job.  The second set contains any seperatly printed sub-jobs
                        SETRANGE(Number, 1, 2);
                    end;
                }

                trigger OnPreDataItem()
                begin
                    JobReportBuffer1.RESET;

                    IF JobReportBuffer1.COUNT = 0 THEN
                        ERROR(NoInformationError);

                    IF "IncludeSub-Levels" THEN
                        NS_MergeSubJobsIntoJobs;

                    NS_CopyReportBuffer(JobReportBuffer1, JobReportBuffer2);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                RecCount := RecCount + 1;

                //Skip jobs containing the Job No. Seperator in the No. unless that is the one that was actually requested
                //  This can only run one sub-job at a time, but does allow for a manager to get only a portion of the job that pertains to them
                //  Any others would have to be skipped.
                IF STRPOS("No.", JobsSetup."NS_Job No. Separators") > 0 THEN BEGIN
                    IF "No." <> JobHold.GETFILTER("No.") THEN
                        CurrReport.SKIP;
                END;

                JobReportBuffer1.RESET;
                JobReportBuffer1.DELETEALL;
                JobReportBuffer2.RESET;
                JobReportBuffer2.DELETEALL;
                LastEntryNo := 0;
                IF RecCount > 1 THEN
                    CurrReport.NEWPAGE;
            end;

            trigger OnPreDataItem()
            begin
                IF JobNumFilter <> '' THEN
                    SETRANGE("No.", JobNumFilter);
                IF COUNT = 0 THEN
                    ERROR(NoInformationError);

                JobHold := Job;
                JobHold.COPYFILTERS(Job);
                "MarkSub-Levels"(Job, "IncludeSub-Levels");
                FILTERGROUP(10);
                COPYFILTERS(JobHold);
                SETRANGE("No.");
                FILTERGROUP(0);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field("NS_Include Sub-Levels"; "IncludeSub-Levels")
                {
                    Caption = 'Include Change Orders';
                    ApplicationArea = All;
                }
                field("NS_Show Sub-Levels"; "ShowSub-Levels")
                {
                    Caption = 'Show Change Orders';
                    ApplicationArea = All;
                }
                field("NS_Show Processes"; ShowProcesses)
                {
                    Caption = 'Show Processes';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        IF NOT ShowProcesses THEN
                            ShowOperations := FALSE;
                    end;
                }
                field("NS_Show Operations"; ShowOperations)
                {
                    Caption = 'Show Operations';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        IF ShowOperations THEN
                            ShowProcesses := TRUE;
                    end;
                }
                //PRJ-688.AM.1.0
                field("Show Sections"; Showsections)
                {
                    Caption = 'Show Sections';
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        if ShowSections then
                            ShowOperations := true;
                    end;
                }
                //PRJ-688.AM.1.0
                field("NS_Show Details"; ShowDetails)
                {
                    Caption = 'Show Details';
                    ApplicationArea = All;
                }
                field("NS_Show Locked"; ShowLocked)
                {
                    Caption = 'Show Locked';
                    ApplicationArea = All;
                    Visible = False;//Not to open
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            IF CompleteJob THEN BEGIN
                "IncludeSub-Levels" := TRUE;
                ShowProcesses := TRUE;
                ShowOperations := TRUE;
                Showsections := true;//PRJ-688.AM.1.0
                "ShowSub-Levels" := FALSE;
                ShowDetails := FALSE;
            END;
            IF SubLevelDetail THEN BEGIN
                "IncludeSub-Levels" := FALSE;
                ShowProcesses := TRUE;
                ShowOperations := TRUE;
                Showsections := true;//PRJ-688.AM.1.0
                "ShowSub-Levels" := TRUE;
                ShowDetails := FALSE;
            END;
            IF AllDetail THEN BEGIN
                "IncludeSub-Levels" := FALSE;
                ShowProcesses := TRUE;
                ShowOperations := TRUE;
                Showsections := true;//PRJ-688.AM.1.0
                "ShowSub-Levels" := TRUE;
                ShowDetails := TRUE;
            END;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        CompanyInformation.GET;
        JobsSetup.GET;
    end;

    trigger OnPreReport()
    begin
        IF JobNumFilter <> '' THEN
            Job.SETRANGE("No.", JobNumFilter);
        JobFilters := Job.GETFILTERS;
        IF "IncludeSub-Levels" THEN
            "Sub-LevelsText" := STRSUBSTNO(SubLevelsHeading, ' ')
        ELSE
            "Sub-LevelsText" := STRSUBSTNO(SubLevelsHeading, ' ' + notLbl + ' ');

        IF ShowDetails THEN BEGIN
            NoHeadingLbl := NoLbl;
            TypeHeadingLbl := TypeHeading;
        END;
    end;

    var
        JobHold: Record Job;

        SubJob: Record Job;//obselete
        JobAnalysisBuffer: Record "NS_Job Analysis Buffer" temporary;//obselete
        JobAnalysisBuffer2: Record "NS_Job Analysis Buffer" temporary;//obselete
        SubJobPlanningLine: Record "Job Planning Line";//obselete
        TotaltoPrintBudgetProcessPrice: Decimal;//obselete
        TotaltoPrintBudgetOperatioPric: Decimal;//obselete
        TotaltoPrintActivityPrice: Decimal;//obselete
        TotaltoPrintBudgetActivityPric: Decimal;//obselete
        TotaltoPrintProcessPrice: Decimal;//obselete
        TotaltoPrintOperationPrice: Decimal;//obselete
        JobRec: Record Job;
        JobReportBuffer1: Record "NS_Job Report Buffer" temporary;
        JobReportBuffer2: Record "NS_Job Report Buffer" temporary;
        JobActivity: Record "NS_Job Activity";
        JobProcess: Record "NS_Job Process";
        JobOperation: Record "NS_Job Operation";
        JobSection: Record NS_Sections;//PRJ-688.AM.1.0
        CompanyInformation: Record "Company Information";
        JobsSetup: Record "Jobs Setup";
        APOTotals: array[10] of Decimal;//PRJ-688.AM.1.0
        Contact: Record "Contact";
        ProcessCodeToUse: Code[10];
        OperationCodeToUse: Code[10];
        SectionCodeToUse: Code[10];//PRJ-688.AM.1.0
        JobNo: Code[20];
        ActivityCode: Code[10];
        ProcessCode: Code[10];
        OperationCode: Code[10];
        SectionCode: Code[10];//PRJ-688.AM.1.0
        JobNoHold: Code[20];
        ActivityCodeHold: Code[10];
        ProcessCodeHold: Code[10];
        OperationCodeHold: Code[10];
        SectionCodeHold: Code[10];//PRJ-688.AM.1.0
        JobNumFilter: Code[20];
        LastEntryNo: Integer;
        RecCount: Integer;
        NumBudgetLines: Integer;
        RecordSource: Option Job,SubJob;
        NoHeadingLbl: Text[3];
        TypeHeadingLbl: Text[4];
        "Sub-LevelsText": Text[50];
        JobFilters: Text[250];
        "IncludeSub-Levels": Boolean;
        "ShowSub-Levels": Boolean;
        ShowProcesses: Boolean;
        ShowOperations: Boolean;
        Showsections: Boolean;//PRJ-688.AM.1.0
        ShowDetails: Boolean;
        JobHeading: Label 'Job: %1';
        ActivityHeading: Label 'Activity  %1';
        ProcessHeading: Label 'Process %1';
        OperationHeading: Label 'Operation %1';
        SecLbl: Label 'Section %1';//PRJ-688.AM.1.0
        TotalJobHeading: Label 'Total Job %1';
        SubLevelsHeading: Label 'Sub-Levels are%1included in jobs';
        StartingDateHeading: Label 'Starting Date: %1';
        EndingDateHeading: Label 'Ending Date: %1';
        NoInformationError: Label 'There is no information to show as requested.\\One of the filters including the required Job No. filter may be limiting the information to show.';
        ReportTitle: Label 'Actual vs Budget Price by APO';
        PageLbl: Label 'Page';
        JobFiltersLbl: Label 'Job Filters:';
        DescriptionLbl: Label 'Description';
        NoLbl: Label 'No.';
        UOMLbl: Label 'UOM';
        TypeHeading: Label 'Type';
        BudgetRemainingLbl: Label 'Balance to be Billed';
        BudgetedPriceLbl: Label 'Itemized';
        CU11: Codeunit "Gen. Jnl.-Check Line";
        Genjourpg: Page "General Journal";
        ActualPriceLbl: Label 'Billings';
        LockedBudgetLbl: Label 'Locked Budget';
        ActivityProcessOperationLbl: Label 'Activity / Process / Operation / Sections';//PRJ-688.AM.1.0
        PctOfBudUsedLbl: Label 'Percent Billings';
        JobDescription: Label 'Job Description:';
        CustomerAccountNameLbl: Label 'Customer Account Name:';
        JobLocationLbl: Label 'Job Location:';
        Unknown: Label 'UNKNOWN';
        notLbl: Label 'not ';
        Total: Label 'Total ';
        ShowLocked: Boolean;
        CompleteJob: Boolean;
        SubLevelDetail: Boolean;
        AllDetail: Boolean;
        JobTask: Record 1001;
        JobTaskDesc: Text[250];
        ProcessExists: Boolean;
        OperationsExists: Boolean;
        ProcessDesc: Text;
        OperationsDesc: Text;
        Sectiondesc: Text;//PRJ-688.AM.1.0

    procedure NS_SendJobBudgetsToBuffer(JobPlanningLine: Record "Job Planning Line"; RecordSource: Option Job,SubJob)
    begin
        //Add Job budget data from LockedJobPlanningLine to the Job Analysis Buffer
        // NOTE: Consider any changes here for the similar routine SendLockedJobBudgetsToBuffer()

        WITH JobPlanningLine DO BEGIN
            IF Type = Type::Text THEN
                EXIT;

            NS_GetActualPOCodesToUse("NS_Process Code", "NS_Operation Code", "NS_Section Code", ProcessCodeToUse, OperationCodeToUse, SectionCodeToUse);//PRJ-688.AM.1.0

            JobReportBuffer1.RESET;
            JobReportBuffer1.SETCURRENTKEY("NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code", NS_Category, NS_Type, "NS_No.", "NS_Variant Code", NS_Adjustment);
            JobReportBuffer1.SETRANGE("NS_Job No.", "Job No.");
            JobReportBuffer1.SETRANGE("NS_Entry Type", "NS_Entry Type"::Price);
            JobReportBuffer1.SETRANGE("NS_Activity Code", "NS_Activity Code");
            JobReportBuffer1.SETRANGE("NS_Process Code", ProcessCodeToUse);
            JobReportBuffer1.SETRANGE("NS_Operation Code", OperationCodeToUse);
            JobReportBuffer1.SetRange("NS_Section Code", SectionCodeToUse);//PRJ-688.AM.1.0
            JobReportBuffer1.SETRANGE(NS_Category, "NS_Revenue Category");
            JobReportBuffer1.SETRANGE(NS_Type, Type);
            JobReportBuffer1.SETRANGE("NS_No.", "No.");
            JobReportBuffer1.SETRANGE("NS_Variant Code", "Variant Code");
            JobReportBuffer1.SETRANGE(NS_Adjustment, NS_Adjustment);
            JobReportBuffer1.SETRANGE("NS_Record Source", RecordSource);
            IF JobReportBuffer1.FINDSET THEN BEGIN
                IF JobReportBuffer1."NS_Job Description" = '' THEN
                    JobReportBuffer1."NS_Job Description" := Description;
                //JobReportBuffer1."NS_Budgeted Price" := JobReportBuffer1."NS_Budgeted Price" + "Total Price";//PRJ-849.AS.1.0 Comment
                JobReportBuffer1."NS_Budgeted Price" := JobReportBuffer1."NS_Budgeted Price" + "Line Amount";//PRJ-849.AS.1.0 Add
                JobReportBuffer1.MODIFY;
            END ELSE BEGIN
                JobReportBuffer1.INIT;
                LastEntryNo := LastEntryNo + 1;
                JobReportBuffer1."NS_Entry No." := LastEntryNo;
                JobReportBuffer1."NS_Job No." := "Job No.";
                JobReportBuffer1."NS_Entry Type" := JobReportBuffer1."NS_Entry Type"::Price;
                JobReportBuffer1."NS_Job Task No." := "Job Task No.";
                JobReportBuffer1."NS_Activity Code" := "NS_Activity Code";
                JobReportBuffer1."NS_Process Code" := ProcessCodeToUse;
                JobReportBuffer1."NS_Operation Code" := OperationCodeToUse;
                JobReportBuffer1."NS_Section Code" := SectionCodeToUse; //PRJ-688.AM.1.0
                JobReportBuffer1.NS_Category := "NS_Revenue Category";
                IF Type = Type::"NS_Resource (Group)" THEN
                    JobReportBuffer1.NS_Type := JobReportBuffer1.NS_Type::"Group (Resource)"
                ELSE
                    JobReportBuffer1.NS_Type := Type;
                JobReportBuffer1."NS_No." := "No.";
                JobReportBuffer1.NS_Description := Description;
                JobReportBuffer1."NS_Job Description" := Description;
                JobReportBuffer1."NS_Variant Code" := "Variant Code";
                //JobReportBuffer1."NS_Budgeted Price" := "Total Price";//PRJ-849.AS.1.0 Comment
                JobReportBuffer1."NS_Budgeted Price" := "Line Amount";//PRJ-849.AS.1.0 Add
                JobReportBuffer1.NS_Adjustment := NS_Adjustment;
                JobReportBuffer1."NS_Record Source" := RecordSource;
                JobReportBuffer1."NS_Locked Budget Record" := FALSE;
                JobReportBuffer1.INSERT;
            END;
        END;
    end;

    procedure NS_SendLockedJobBudgetsToBuffer(LockedJobPlanningLine: Record "NS_Locked Job Planning Line"; RecordSource: Option Job,SubJob)
    begin
        //Add Job budget data from LockedJobPlanningLine to the Job Analysis Buffer
        // NOTE: Consider any changes here for the similar routine SendJobBudgetsToBuffer()

        WITH LockedJobPlanningLine DO BEGIN
            IF NS_Type = NS_Type::Text THEN
                EXIT;

            NS_GetActualPOCodesToUse("NS_Process Code", "NS_Operation Code", "NS_Section Code", ProcessCodeToUse, OperationCodeToUse, SectionCodeToUse);//PRJ-688.AM.1.0

            JobReportBuffer1.RESET;
            JobReportBuffer1.SETCURRENTKEY("NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code", NS_Category, NS_Type, "NS_No.", "NS_Variant Code", NS_Adjustment);
            JobReportBuffer1.SETRANGE("NS_Job No.", "NS_Job No.");
            JobReportBuffer1.SETRANGE("NS_Entry Type", "NS_Entry Type"::Price);
            JobReportBuffer1.SETRANGE("NS_Activity Code", "NS_Activity Code");
            JobReportBuffer1.SETRANGE("NS_Process Code", ProcessCodeToUse);
            JobReportBuffer1.SETRANGE("NS_Operation Code", OperationCodeToUse);
            JobReportBuffer1.SetRange("NS_Section Code", SectionCodeToUse);//PRJ-688.AM.1.0
            JobReportBuffer1.SETRANGE(NS_Category, "NS_Revenue Category");
            JobReportBuffer1.SETRANGE(NS_Type, NS_Type);
            JobReportBuffer1.SETRANGE("NS_No.", "NS_No.");
            JobReportBuffer1.SETRANGE("NS_Variant Code", "NS_Variant Code");
            JobReportBuffer1.SETRANGE(NS_Adjustment, NS_Adjustment);
            JobReportBuffer1.SETRANGE("NS_Record Source", RecordSource);
            IF JobReportBuffer1.FINDSET THEN BEGIN
                IF JobReportBuffer1."NS_Job Description" = '' THEN
                    JobReportBuffer1."NS_Job Description" := NS_Description;
                JobReportBuffer1."NS_Locked Budgeted Cost" := JobReportBuffer1."NS_Locked Budgeted Price" + "NS_Total Price";
                JobReportBuffer1.MODIFY;
            END ELSE BEGIN
                JobReportBuffer1.INIT;
                LastEntryNo := LastEntryNo + 1;
                JobReportBuffer1."NS_Entry No." := LastEntryNo;
                JobReportBuffer1."NS_Job No." := "NS_Job No.";
                JobReportBuffer1."NS_Entry Type" := JobReportBuffer1."NS_Entry Type"::Price;
                JobReportBuffer1."NS_Job Task No." := "NS_Job Task No.";
                JobReportBuffer1."NS_Activity Code" := "NS_Activity Code";
                JobReportBuffer1."NS_Process Code" := ProcessCodeToUse;
                JobReportBuffer1."NS_Operation Code" := OperationCodeToUse;
                JobReportBuffer1."NS_Section Code" := SectionCodeToUse; //PRJ-688.AM.1.0
                JobReportBuffer1.NS_Category := "NS_Revenue Category";
                IF NS_Type = NS_Type::"Resource (Group)" THEN
                    JobReportBuffer1.NS_Type := JobReportBuffer1.NS_Type::"Group (Resource)"
                ELSE
                    JobReportBuffer1.NS_Type := NS_Type;
                JobReportBuffer1."NS_No." := "NS_No.";
                JobReportBuffer1.NS_Description := NS_Description;
                JobReportBuffer1."NS_Job Description" := NS_Description;
                JobReportBuffer1."NS_Variant Code" := "NS_Variant Code";
                JobReportBuffer1."NS_Locked Budgeted Price" := "NS_Total Price";
                JobReportBuffer1.NS_Adjustment := NS_Adjustment;
                JobReportBuffer1."NS_Record Source" := RecordSource;
                JobReportBuffer1."NS_Locked Budget Record" := TRUE;
                JobReportBuffer1.INSERT;
            END;
        END;
    end;

    procedure NS_SendJobLedgerToBuffer(JobLedgerEntry: Record "Job Ledger Entry"; RecordSource: Option Job,SubJob)
    begin
        //Add Job Ledger Entry to the Job Analysis Buffer

        WITH JobLedgerEntry DO BEGIN

            //Add Job ledger data from JobLedgerEntry to the Job Analysis Buffer
            NS_GetActualPOCodesToUse("NS_Process Code", "NS_Operation Code", "NS_Section Code", ProcessCodeToUse, OperationCodeToUse, SectionCodeToUse);//PRJ-688.AM.1.0

            JobReportBuffer1.RESET;
            JobReportBuffer1.SETCURRENTKEY("NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code", NS_Category, NS_Type, "NS_No.", "NS_Variant Code", NS_Adjustment);
            JobReportBuffer1.SETRANGE("NS_Job No.", "Job No.");
            JobReportBuffer1.SETRANGE("NS_Entry Type", JobReportBuffer1."NS_Entry Type"::Price);
            JobReportBuffer1.SETRANGE("NS_Activity Code", "NS_Activity Code");
            JobReportBuffer1.SETRANGE("NS_Process Code", ProcessCodeToUse);
            JobReportBuffer1.SETRANGE("NS_Operation Code", OperationCodeToUse);
            JobReportBuffer1.SetRange("NS_Section Code", SectionCodeToUse); //PRJ-688.AM.1.0
            JobReportBuffer1.SETRANGE(NS_Category, "NS_Job Revenue Category");
            JobReportBuffer1.SETRANGE(NS_Type, Type);
            JobReportBuffer1.SETRANGE("NS_No.", "No.");
            JobReportBuffer1.SETRANGE("NS_Variant Code", "Variant Code");
            JobReportBuffer1.SETRANGE(NS_Adjustment, '');
            JobReportBuffer1.SETRANGE("NS_Record Source", RecordSource);
            IF JobReportBuffer1.FINDSET THEN BEGIN
                IF JobReportBuffer1."NS_Job Description" = '' THEN
                    JobReportBuffer1."NS_Job Description" := Description;
                // JobReportBuffer1."NS_Actual Price" := JobReportBuffer1."NS_Actual Price" + "Total Price (LCY)";//PRJ-849.AS.1.0 Comment
                JobReportBuffer1."NS_Actual Price" := JobReportBuffer1."NS_Actual Price" + "Line Amount (LCY)";//PRJ-849.AS.1.0 Add
                JobReportBuffer1.MODIFY;
            END ELSE BEGIN
                JobReportBuffer1.INIT;
                LastEntryNo := LastEntryNo + 1;
                JobReportBuffer1."NS_Entry No." := LastEntryNo;
                JobReportBuffer1."NS_Job No." := "Job No.";
                JobReportBuffer1."NS_Entry Type" := JobReportBuffer1."NS_Entry Type"::Price;
                JobReportBuffer1."NS_Job Task No." := "Job Task No.";
                JobReportBuffer1."NS_Activity Code" := "NS_Activity Code";
                JobReportBuffer1."NS_Process Code" := ProcessCodeToUse;
                JobReportBuffer1."NS_Operation Code" := OperationCodeToUse;
                JobReportBuffer1."NS_Section Code" := SectionCodeToUse;//PRJ-688.AM.1.0
                JobReportBuffer1.NS_Category := "NS_Job Revenue Category";
                JobReportBuffer1.NS_Type := Type;
                JobReportBuffer1."NS_No." := "No.";
                //JobReportBuffer1."NS_Actual Price" := "Total Price (LCY)";//PRJ-849.AS.1.0 Comment
                JobReportBuffer1."NS_Actual Price" := "Line Amount (LCY)";//PRJ-849.AS.1.0 Add
                JobReportBuffer1.NS_Description := Description;
                JobReportBuffer1."NS_Job Description" := Description;
                JobReportBuffer1."NS_Variant Code" := "Variant Code";
                JobReportBuffer1.NS_Adjustment := '';
                JobReportBuffer1."NS_Record Source" := RecordSource;
                JobReportBuffer1."NS_Locked Budget Record" := FALSE;
                JobReportBuffer1.INSERT;
            END;
        END;
    end;

    procedure NS_MergeSubJobsIntoJobs()
    begin
        //Add the sub-job values into the base job records
        WITH JobReportBuffer2 DO BEGIN
            NS_CopyReportBuffer(JobReportBuffer1, JobReportBuffer2);
            JobReportBuffer1.RESET;
            LastEntryNo := 0;
            IF JobReportBuffer1.FINDLAST THEN
                LastEntryNo := JobReportBuffer1."NS_Entry No.";

            RESET;
            SETCURRENTKEY("NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", NS_Category, NS_Type, "NS_No.", "NS_Variant Code", NS_Adjustment);
            SETRANGE("NS_Record Source", "NS_Record Source"::SubJob);
            IF FINDSET THEN
                REPEAT
                    JobReportBuffer1.RESET;
                    JobReportBuffer1.SETCURRENTKEY("NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code", NS_Category, NS_Type, "NS_No.", "NS_Variant Code", NS_Adjustment);
                    JobRec.GET("NS_Job No.");
                    JobReportBuffer1.SETRANGE("NS_Job No.", JobRec."NS_Sub-Level to Job No.");  //Change the Job No. to the main no.
                    JobReportBuffer1.SETRANGE("NS_Entry Type", "NS_Entry Type"::Price);
                    JobReportBuffer1.SETRANGE("NS_Activity Code", "NS_Activity Code");
                    JobReportBuffer1.SETRANGE("NS_Process Code", "NS_Process Code");
                    JobReportBuffer1.SETRANGE("NS_Operation Code", "NS_Operation Code");
                    JobReportBuffer1.SetRange("NS_Section Code", "NS_Section Code");//PRJ-688.AM.1.0
                    JobReportBuffer1.SETRANGE(NS_Category, NS_Category);
                    JobReportBuffer1.SETRANGE(NS_Type, NS_Type);
                    JobReportBuffer1.SETRANGE("NS_No.", "NS_No.");
                    JobReportBuffer1.SETRANGE("NS_Variant Code", "NS_Variant Code");
                    JobReportBuffer1.SETRANGE(NS_Adjustment, NS_Adjustment);
                    JobReportBuffer1.SETRANGE("NS_Record Source", JobReportBuffer1."NS_Record Source"::Job);
                    IF JobReportBuffer1.FINDSET THEN BEGIN
                        JobReportBuffer1."NS_Budgeted Price" := JobReportBuffer1."NS_Budgeted Price" + "NS_Budgeted Price";
                        JobReportBuffer1."NS_Actual Price" := JobReportBuffer1."NS_Actual Price" + "NS_Actual Price";
                        JobReportBuffer1.MODIFY;
                    END ELSE BEGIN
                        JobReportBuffer1 := JobReportBuffer2;
                        LastEntryNo := LastEntryNo + 1;
                        JobReportBuffer1."NS_Entry No." := LastEntryNo;
                        JobReportBuffer1."NS_Record Source" := JobReportBuffer1."NS_Record Source"::Job;
                        JobReportBuffer1."NS_Job No." := JobRec."NS_Sub-Level to Job No.";  //Change the Job No. to the main no.
                        JobReportBuffer1.INSERT;
                    END;
                UNTIL NEXT = 0;
        END;
    end;

    procedure NS_CopyReportBuffer(var FromBuffer: Record "NS_Job Report Buffer"; var ToBuffer: Record "NS_Job Report Buffer")
    begin
        //Duplicate the JobReportBuffer
        WITH FromBuffer DO BEGIN
            ToBuffer.RESET;
            ToBuffer.DELETEALL;

            RESET;
            IF FINDSET THEN
                REPEAT
                    ToBuffer := FromBuffer;
                    ToBuffer.INSERT;
                UNTIL NEXT = 0;
        END;
    end;

    procedure NS_CheckForJobOrAPOBreak()
    begin
        WITH JobReportBuffer1 DO BEGIN
            //
            //If Activity break
            //
            IF ("NS_Activity Code" <> ActivityCodeHold) OR
               ("NS_Job No." <> JobNoHold) THEN BEGIN
                IF NOT JobActivity.GET(JobActivity.NS_Type::Revenue, "NS_Activity Code") THEN
                    //TEMP// JobActivity.NS_Description := Unknown;
                    JobActivity.NS_Description := "NS_Description";//PRJ-437.AS.1.0 Added

                //Set current code and hold codes
                JobNoHold := "NS_Job No.";
                ActivityCode := "NS_Activity Code";
                ActivityCodeHold := "NS_Activity Code";
                ProcessCodeHold := '';  //Force a Process Code break
            END;

            //
            //If Process break
            //
            IF "NS_Process Code" <> ProcessCodeHold THEN BEGIN
                IF NOT JobProcess.GET(JobProcess.NS_Type::Revenue, "NS_Activity Code", "NS_Process Code") THEN
                    //JobProcess.NS_Description := Unknown;//PRJ-437.AS.1.0 Comment
                    JobProcess.NS_Description := JobActivity.NS_Description;//PRJ-437.AS.1.0 Added

                //Set current code and hold codes
                ProcessCode := "NS_Process Code";
                ProcessCodeHold := "NS_Process Code";
                OperationCodeHold := '';  //Force an Operation Code break
            END;

            //
            //If Operation break
            //
            IF "NS_Operation Code" <> OperationCodeHold THEN BEGIN
                //TEMP//  IF NOT JobOperation.GET(JobOperation.NS_Type::Revenue, "NS_Activity Code", "NS_Process Code", "NS_Operation Code") THEN
                //TEMP//        JobOperation.NS_Description := Unknown;

                if not JobOperation.GET(JobOperation.NS_Type::Revenue, "NS_Activity Code", "NS_Process Code", "NS_Operation Code") then
                    if "NS_Process Code" <> '' then
                        JobOperation.NS_Description := JobProcess.NS_Description
                    else
                        JobOperation.NS_Description := JobActivity.NS_Description;

                //Set current code and hold code
                OperationCode := "NS_Operation Code";
                OperationCodeHold := "NS_Operation Code";
                SectionCodeHold := '';//PRJ-688.AM.1.0
            end;
            //PRJ-688.AM.1.0
            //If Section break
            //
            if "NS_Section Code" <> SectionCodeHold then begin
                //Add to Actual and Budget Operation Quantity and Costs
                // AccumulateAPOTotals(JobReportBuffer2, 0, "NS_Job No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code", APOTotals);//PRJ-688.AM.1.0

                if not JobSection.GET(JobSection.NS_Type::Revenue, "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code") then
                    if "NS_Section Code" <> '' then
                        JobSection.NS_Description := JobOperation.NS_Description
                    else
                        JobSection.NS_Description := JobProcess.NS_Description;

                //Set current code and hold code
                SectionCode := "NS_Section Code";
                SectionCodeHold := "NS_Section Code";
            end;
            //PRJ-688.AM.1.0

        END;
    end;

    procedure NS_GetActualPOCodesToUse(ProcessCodeIn: Code[10]; OperationCodeIn: Code[10]; SectionCodeIn: Code[10]; var ProcessCodeOut: Code[10]; var OperationCodeOut: Code[10]; var
        SectionCodeOut: Code[10]
    );//PRJ-688.AM.1.0
    begin
        //This routine either passes incoming Process and Operation codes back out or returns empty strings
        //     depending on if the processes or operations are to be shown.

        IF ShowProcesses THEN
            ProcessCodeOut := ProcessCodeIn
        ELSE
            ProcessCodeOut := '';

        IF ShowOperations THEN
            OperationCodeOut := OperationCodeIn
        ELSE
            OperationCodeOut := '';

        //PRJ-688.AM.1.0
        if Showsections then
            SectionCodeOut := SectionCodeIn
        else
            SectionCodeOut := '';
        //PRJ-688.AM.1.0
    end;


    procedure NS_SetJobNoFilter(PassJobNum: Code[20])
    begin
        JobNumFilter := PassJobNum
    end;

    procedure NS_SetDetailLevel(PassCompleteJob: Boolean; PassSubDetail: Boolean; PassAllDetail: Boolean)
    begin
        CompleteJob := PassCompleteJob;
        SubLevelDetail := PassSubDetail;
        AllDetail := PassAllDetail;
    end;

    LOCAL PROCEDURE FindActivityOrProcessExists(JobTaskNoParam: Code[20]);
    VAR
        i: Integer;
        j: Integer;
    BEGIN
        //PRJ-184.VT.1.0 23-03-20

        i := STRLEN(JobTaskNoParam);
        j := STRLEN(DELCHR(JobTaskNoParam, '=', '-'));
        IF j = i - 1 THEN
            ProcessExists := TRUE;
        IF j = i - 2 THEN
            OperationsExists := TRUE;
        //IF STRPOS(JobTaskNoParam,'-') <> 0 THEN BEGIN
        //  i :=1;
        //  IF STRPOS()
        //END;
    END;


    [Obsolete('This function will be removed in next release')]
    procedure GetSubBudgetProcPrice();
    begin
        MESSAGE('This function will be removed in next release');
        SubJob.RESET;
        SubJob.SETRANGE("NS_Sub-Level to Job No.", JobAnalysisBuffer."NS_Job No.");
        if SubJob.FINDSET then
            repeat
                SubJobPlanningLine.RESET;
                SubJobPlanningLine.SETRANGE("Job No.", SubJob."No.");
                SubJobPlanningLine.SETFILTER("NS_Entry Type", '%1|%2',
                                                          SubJobPlanningLine."NS_Entry Type"::Price,
                                                          SubJobPlanningLine."NS_Entry Type"::Both);
                SubJobPlanningLine.SETRANGE("NS_Activity Code", JobAnalysisBuffer."NS_Activity Code");
                SubJobPlanningLine.SETRANGE("NS_Process Code", JobAnalysisBuffer."NS_Process Code");
                SubJobPlanningLine.SETFILTER("Planning Date", Job.GETFILTER("NS_Date Filter"));
                if SubJobPlanningLine.FINDSET then
                    repeat
                        TotaltoPrintBudgetProcessPrice := TotaltoPrintBudgetProcessPrice + SubJobPlanningLine."Total Price (LCY)";
                    until SubJobPlanningLine.NEXT = 0;
            until SubJob.NEXT = 0;
    end;


    [Obsolete('This function will be removed in next release')]
    procedure GetSubBudgetOperPrice();
    begin
        MESSAGE('This function will be removed in next release');
        SubJob.RESET;
        SubJob.SETRANGE("NS_Sub-Level to Job No.", JobAnalysisBuffer."NS_Job No.");
        if SubJob.FINDSET then
            repeat
                SubJobPlanningLine.RESET;
                SubJobPlanningLine.SETRANGE("Job No.", SubJob."No.");
                SubJobPlanningLine.SETFILTER("NS_Entry Type", '%1|%2',
                                                          SubJobPlanningLine."NS_Entry Type"::Price,
                                                          SubJobPlanningLine."NS_Entry Type"::Both);
                SubJobPlanningLine.SETRANGE("NS_Activity Code", JobAnalysisBuffer."NS_Activity Code");
                SubJobPlanningLine.SETRANGE("NS_Process Code", JobAnalysisBuffer."NS_Process Code");
                SubJobPlanningLine.SETRANGE("NS_Operation Code", JobAnalysisBuffer."NS_Operation Code");
                SubJobPlanningLine.SETFILTER("Planning Date", Job.GETFILTER("NS_Date Filter"));
                if SubJobPlanningLine.FINDSET then
                    repeat
                        TotaltoPrintBudgetOperatioPric := TotaltoPrintBudgetOperatioPric + SubJobPlanningLine."Total Price (LCY)";
                    until SubJobPlanningLine.NEXT = 0;
            until SubJob.NEXT = 0;
    end;

    [Obsolete('This function will be removed in next release')]
    procedure BudgetCalcs(Budget: Decimal; Actual: Decimal; var Remaining: Decimal; var PercentUsed: Decimal);
    begin
        MESSAGE('This function will be removed in next release');
        Remaining := Budget - Actual;

        if Remaining = 0 then
            case true of
                Budget > 0:
                    PercentUsed := 100;
                Budget < 0:
                    PercentUsed := -100;
                Budget = 0:
                    PercentUsed := 0;
            end
        else
            case true of
                Budget > 0:
                    PercentUsed := 100 - ROUND(Remaining / Budget * 100, 0.1);
                Budget < 0:
                    PercentUsed := 100 - ROUND(Remaining / Budget * 100, 0.1);
                Budget = 0:
                    PercentUsed := -100;
            end;
    end;


    [Obsolete('This function will be removed in next release')]
    procedure SetProcessOperation(ProcessCodeIn: Code[10]; OperationCodeIn: Code[10]; var ProcessCodeOut: Code[10]; var OperationCodeOut: Code[10]);
    begin
    end;

    [Obsolete('This function will be removed in next release')]
    procedure GetActivityTotals();
    begin
        MESSAGE('This function will be removed in next release');
        //Get Budget and Actual Activity Prices from JobAnalysisBuffer2
        TotaltoPrintActivityPrice := 0;
        TotaltoPrintBudgetActivityPric := 0;
        JobAnalysisBuffer2.RESET;
        JobAnalysisBuffer2.SETRANGE("NS_Job No.", JobAnalysisBuffer."NS_Job No.");
        JobAnalysisBuffer2.SETRANGE("NS_Activity Code", JobAnalysisBuffer."NS_Activity Code");
        JobAnalysisBuffer2.SETFILTER("NS_Date Filter", Job.GETFILTER("NS_Date Filter"));
        if JobAnalysisBuffer2.FINDSET then
            repeat
                JobAnalysisBuffer2.CALCFIELDS("NS_Total Price");
                TotaltoPrintBudgetActivityPric := TotaltoPrintBudgetActivityPric + JobAnalysisBuffer2."NS_Total Price";
                TotaltoPrintActivityPrice := TotaltoPrintActivityPrice + JobAnalysisBuffer2."NS_Actual Price";
            until JobAnalysisBuffer2.NEXT = 0;
    end;


    [Obsolete('This function will be removed in next release')]
    procedure GetProcessTotals();
    begin
        MESSAGE('This function will be removed in next release');
        //Get Budget and Actual Process Prices from JobAnalysisBuffer2
        TotaltoPrintProcessPrice := 0;
        TotaltoPrintBudgetProcessPrice := 0;
        JobAnalysisBuffer2.RESET;
        JobAnalysisBuffer2.SETRANGE("NS_Job No.", JobAnalysisBuffer."NS_Job No.");
        JobAnalysisBuffer2.SETRANGE("NS_Activity Code", JobAnalysisBuffer."NS_Activity Code");
        JobAnalysisBuffer2.SETRANGE("NS_Process Code", JobAnalysisBuffer."NS_Process Code");
        if JobAnalysisBuffer2.FINDSET then
            repeat
                JobAnalysisBuffer2.CALCFIELDS("NS_Total Price");
                TotaltoPrintBudgetProcessPrice := TotaltoPrintBudgetProcessPrice + JobAnalysisBuffer2."NS_Total Price";
                TotaltoPrintProcessPrice := TotaltoPrintProcessPrice + JobAnalysisBuffer2."NS_Actual Price";
            until JobAnalysisBuffer2.NEXT = 0;
    end;


    [Obsolete('This function will be removed in next release')]
    procedure GetOperationTotals();
    begin
        MESSAGE('This function will be removed in next release');
        //Get Budget and Actual Operation Prices from JobAnalysisBuffer2
        TotaltoPrintOperationPrice := 0;
        TotaltoPrintBudgetOperatioPric := 0;
        JobAnalysisBuffer2.RESET;
        JobAnalysisBuffer2.SETRANGE("NS_Job No.", JobAnalysisBuffer."NS_Job No.");
        JobAnalysisBuffer2.SETRANGE("NS_Activity Code", JobAnalysisBuffer."NS_Activity Code");
        JobAnalysisBuffer2.SETRANGE("NS_Process Code", JobAnalysisBuffer."NS_Process Code");
        JobAnalysisBuffer2.SETRANGE("NS_Operation Code", JobAnalysisBuffer."NS_Operation Code");
        if JobAnalysisBuffer2.FINDSET then
            repeat
                JobAnalysisBuffer2.CALCFIELDS("NS_Total Price");
                TotaltoPrintBudgetOperatioPric := TotaltoPrintBudgetOperatioPric + JobAnalysisBuffer2."NS_Total Price";
                TotaltoPrintOperationPrice := TotaltoPrintOperationPrice + JobAnalysisBuffer2."NS_Actual Price";
            until JobAnalysisBuffer2.NEXT = 0;
    end;


    [Obsolete('This function will be removed in next release')]
    procedure GetSubBudgetActPrice();
    begin
        MESSAGE('This function will be removed in next release');
        SubJob.RESET;
        SubJob.SETRANGE("NS_Sub-Level to Job No.", JobAnalysisBuffer."NS_Job No.");
        if SubJob.FINDSET then
            repeat
                SubJobPlanningLine.RESET;
                SubJobPlanningLine.SETRANGE("Job No.", SubJob."No.");
                SubJobPlanningLine.SETFILTER("NS_Entry Type", '%1|%2',
                                                          SubJobPlanningLine."NS_Entry Type"::Price,
                                                          SubJobPlanningLine."NS_Entry Type"::Both);
                SubJobPlanningLine.SETRANGE("NS_Activity Code", JobAnalysisBuffer."NS_Activity Code");
                SubJobPlanningLine.SETFILTER("Planning Date", Job.GETFILTER("NS_Date Filter"));
                if SubJobPlanningLine.FINDSET then
                    repeat
                        TotaltoPrintBudgetActivityPric := TotaltoPrintBudgetActivityPric + SubJobPlanningLine."Total Price (LCY)";
                    until SubJobPlanningLine.NEXT = 0;
            until SubJob.NEXT = 0;
    end;

}

