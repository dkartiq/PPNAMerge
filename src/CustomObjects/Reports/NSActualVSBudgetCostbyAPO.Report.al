report 14021152 "NS_ActualvsBudget Cost by APO"
{
    // ProjectPro - developed and licensed by GEMKO Information Group Inc.   www.dynamicsnavconstruction.com   www.gemko.com
    // 
    // Generates Actual vs Budget quantities and values by APO codes with the ablity to display only those APO code that are required and the choice of showing detail lines
    //   Sub-jobs can be included in the main job and/or shown on seperate pages
    // 
    // Percentage calculations are performed in the following mannor for both values and quantitys
    //               Actual      Budget      % Used             Actual      Budget      % Used
    //                    0           0        0.0%              1,200      10,000       12.0%
    //                    0      10,000        0.0%              2,500      10,000       25.0%
    //                1,200           0     -100.0%             10,000      10,000      100.0%
    //                2,500           0     -100.0%             11,200      10.000     -112.0%
    //                                                          12,500      10,000     -125.0%
    //PRJ-84.SK.1.0 Added report to search
    //PRJ-184.VT.1.0 23-03-20 -- Change made to print Description from Job Task Lines
    //PPAL-76.AS.1.0 14AUG2020 Corrected Type filter, as it was previously applied "NS_Type"
    //PRJ-528.AS.1.0 08DEC2021 Added condition to run for different task codes in different jobs
    //PRJ-810.AS.1.0 Added section code functionality
    //PRJ-1210.AS.1.0 Pick task description from job task lines table. Also done changes to layout to achieve this
    //PRJ-1348.NK.1.0 08Jun2022 | Add Caption
    //PRJ-1555.NK.1.0 03Aug2022 | Add Code
    //PE-80.AS.1.0 Done layout correction for a simple code, as it was giving error
    //PE-97.NC.1.0 31May2023 | Change in Layout & Code
    //PE-134.DK.1.0 26July2023| Add ToolTip
    //PE-222.DK.1.0 20FEB2024 | Change only in Layout
    DefaultLayout = RDLC;
    //Caption = 'Actual Vs Budget Cost by APO'; //PRJ-1348.NK.1.0 08Jun2022 Block
    Caption = 'Actual Vs Budget Cost by Task'; //PRJ-1348.NK.1.0 08Jun2022
    RDLCLayout = './Layouts/NSAvBCostbyAPO.rdl';
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
                    SendJobBudgetsToBuffer("Job Planning Line", JobReportBuffer1."NS_Record Source"::Job);
                end;

                trigger OnPreDataItem()
                begin
                    //Get the master Job Planning Lines into the buffer
                    SETFILTER("Job No.", Job."No.");
                    SETFILTER("NS_Entry Type", '%1|%2', "NS_Entry Type"::Cost, "NS_Entry Type"::Both);
                    SETFILTER("Job Task No.", Job.GETFILTER("NS_Job Task No. Filter"));
                    //PE-308.DK.1.0 13JUNE2024 Start
                    // SETFILTER(Type, Job.GETFILTER("NS_Type Filter"));
                    SETFILTER(Type, Job.GETFILTER("NS_TypeEnumFilter"));
                    //PE-308.DK.1.0 13JUNE2024 End
                    SETFILTER("Planning Date", Job.GETFILTER("NS_Date Filter"));
                end;
            }
            dataitem("Locked Job Planning Line"; "NS_Locked Job Planning Line")
            {
                DataItemLink = "NS_Job No." = FIELD("No.");
                DataItemTableView = SORTING("NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Cost Category", NS_Type, "NS_No.", "NS_Variant Code");

                trigger OnAfterGetRecord()
                begin
                    SendLockedJobBudgetsToBuffer("Locked Job Planning Line", JobReportBuffer1."NS_Record Source"::Job);
                end;

                trigger OnPreDataItem()
                begin
                    //Get the master Locked Job Planning Lines into the buffer
                    SETFILTER("NS_Job No.", Job."No.");
                    SETFILTER("NS_Entry Type", '%1|%2', "NS_Entry Type"::Cost, "NS_Entry Type"::Both);
                    SETFILTER("NS_Job Task No.", Job.GETFILTER("NS_Job Task No. Filter"));
                    //PE-308.DK.1.0 13JUNE2024 Start
                    //SETFILTER("NS_Type", Job.GETFILTER("NS_Type Filter"));//PPAL-76.AS.1.0 14AUG2020 //PPAL-76.AS.1.0 17AUG2020
                    SETFILTER("NS_Type", Job.GETFILTER("NS_TypeEnumFilter"));
                    //PE-308.DK.1.0 13JUNE2024 End
                    SETFILTER("NS_Planning Date", Job.GETFILTER("NS_Date Filter"));
                end;
            }
            dataitem("Job Ledger Entry"; "Job Ledger Entry")
            {
                DataItemLink = "Job No." = FIELD("No.");
                DataItemTableView = SORTING("Job No.", "Job Task No.", "Entry Type", "Posting Date");

                trigger OnAfterGetRecord()
                begin
                    SendJobLedgerToBuffer("Job Ledger Entry", JobReportBuffer1."NS_Record Source"::Job);
                end;

                trigger OnPreDataItem()
                begin
                    //Get the master Job Ledger Entries into the buffer
                    SETFILTER("Job No.", Job."No.");
                    SETFILTER("Job Task No.", Job.GETFILTER("NS_Job Task No. Filter"));
                    SETFILTER("Entry Type", FORMAT("Entry Type"::Usage));
                    SETFILTER("Posting Date", Job.GETFILTER("NS_Date Filter"));
                    //PE-308.DK.1.0 13JUNE2024 Start
                    //SETFILTER("Type", Job.GETFILTER("NS_Type Filter"));//PPAL-76.AS.1.0 18AUG2020 change filter from NS_Type to Type comited
                    SETFILTER("Type", Job.GETFILTER("NS_TypeEnumFilter"));
                    //PE-308.DK.1.0 13JUNE2024 End
                end;
            }
            dataitem("Sub-Levels"; Job)
            {
                DataItemLink = "NS_Sub-Level to Job No." = FIELD("No.");
                DataItemTableView = SORTING("No.");
                dataitem("Job Planning Line Sub-Levels"; "Job Planning Line")
                {
                    DataItemLink = "Job No." = FIELD("No.");
                    DataItemTableView = SORTING("Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Cost Category", Type, "No.", "Variant Code");

                    trigger OnAfterGetRecord()
                    begin
                        SendJobBudgetsToBuffer("Job Planning Line Sub-Levels", JobReportBuffer1."NS_Record Source"::SubJob);
                    end;

                    trigger OnPreDataItem()
                    begin
                        //Get sub-level Job Planning Lines into the buffer
                        SETFILTER("Type", '%1|%2', "NS_Entry Type"::Cost, "NS_Entry Type"::Both);
                        //PE-308.DK.1.0 13JUNE2024 Start
                        //SETFILTER(Type, Job.GETFILTER("NS_Type Filter"));
                        SETFILTER(Type, Job.GETFILTER("NS_TypeEnumFilter"));
                        //PE-308.DK.1.0 13JUNE2024 End
                        SETFILTER("Planning Date", Job.GETFILTER("NS_Date Filter"));
                        SETFILTER("Job Task No.", Job.GETFILTER("NS_Job Task No. Filter"));
                    end;
                }
                dataitem("Locked Job Planning Line SLs"; "NS_Locked Job Planning Line")
                {
                    DataItemLink = "NS_Job No." = FIELD("No.");
                    DataItemTableView = SORTING("NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Cost Category", NS_Type, "NS_No.", "NS_Variant Code");

                    trigger OnAfterGetRecord()
                    begin
                        SendLockedJobBudgetsToBuffer("Locked Job Planning Line SLs", JobReportBuffer1."NS_Record Source"::SubJob);
                    end;

                    trigger OnPreDataItem()
                    begin
                        //Get sub-level Locked Job Planning Lines into the buffer
                        SETFILTER("NS_Entry Type", '%1|%2', "NS_Entry Type"::Cost, "NS_Entry Type"::Both);
                        SETFILTER("NS_Job Task No.", Job.GETFILTER("NS_Job Task No. Filter"));
                        //PE-308.DK.1.0 13JUNE2024 Start
                        //SETFILTER("NS_Type", Job.GETFILTER("NS_Type Filter"));//PPAL-76.AS.1.0 14AUG2020 //PPAL-76.AS.1.0 17AUG2020
                        SETFILTER("NS_Type", Job.GETFILTER("NS_TypeEnumFilter"));
                        //PE-308.DK.1.0 13JUNE2024 End
                        SETFILTER("NS_Planning Date", Job.GETFILTER("NS_Date Filter"));
                    end;
                }
                dataitem("Job Ledger Entry Sub-Levels"; "Job Ledger Entry")
                {
                    DataItemLink = "Job No." = FIELD("No.");
                    DataItemTableView = SORTING("Job No.", "Job Task No.", "Entry Type", "Posting Date");

                    trigger OnAfterGetRecord()
                    begin
                        SendJobLedgerToBuffer("Job Ledger Entry Sub-Levels", JobReportBuffer1."NS_Record Source"::SubJob);
                    end;

                    trigger OnPreDataItem()
                    begin
                        //Get sub-job Job Ledger Entries into the buffer
                        SETFILTER("Job Task No.", Job.GETFILTER("NS_Job Task No. Filter"));
                        SETFILTER("Entry Type", FORMAT("Entry Type"::Usage));
                        SETFILTER("Posting Date", Job.GETFILTER("NS_Date Filter"));
                        //PE-308.DK.1.0 13JUNE2024 Start
                        //SETFILTER(Type, Job.GETFILTER("NS_Type Filter"));
                        SETFILTER(Type, Job.GETFILTER("NS_TypeEnumFilter"));
                        //PE-308.DK.1.0 13JUNE2024 End
                    end;
                }

                trigger OnPreDataItem()
                begin
                    IF (NOT "IncludeSub-Levels") AND (NOT "ShowSub-Levels") THEN
                        CurrReport.BREAK;
                end;
            }
            dataitem("Page Header"; Integer)
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
                //PE-141.NK.1.0 start 11Aug2023
                column(CompanyInformationPic; CompanyInformation.Picture) { }
                column(CompanyInformationAdd; CompanyInformation.Address) { }
                column(CompanyInformationadd2; CompanyInformation."Address 2") { }
                column(CompanyInformationcity; CompanyInformation.City) { }
                column(CompanyInformationRegion; CompanyInformation."Country/Region Code") { }
                column(CompanyInformationpost; CompanyInformation."Post Code") { }
                column(CompanyInformationCountry; CompanyInformation.County) { }
                column(CompanyInformationPhone; CompanyInformation."Phone No.") { }
                column(NS_CompanyFullAddress; NS_CompanyFullAddress) { }
                //PE-141.NK.1.0 end 11Aug2023
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
                column(ActualCostCaption; ActualCostLbl)
                {
                }
                column(BudgetedCostCaption; BudgetedCostLbl)
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
                            //PE-97.NC.1.0 31May2023 Start
                            column(ActivityProcess; ActivityProcess)
                            { }
                            //PE-97.NC.1.0 31May2023 End
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
                            //PRJ-1348.NK.1.0 13Jul2022 Start
                            column(Process_Description; ProcessDesc)
                            {
                            }
                            column(Operation_Description; OperationsDesc)
                            {
                            }
                            column(Show_Operations; ShowOperations)
                            {
                            }

                            //PRJ-1348.NK.1.0 08Jun2022 End
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
                            column(DetailActualCost; JobReportBuffer1."NS_Actual Cost")
                            {
                            }
                            column(DetailBudgetedCost; JobReportBuffer1."NS_Budgeted Cost")
                            {
                            }
                            column(LockedBudgetedCost; JobReportBuffer1."NS_Locked Budgeted Cost")
                            {
                            }
                            //column(ActivityTotalCaption; STRSUBSTNO(Total) + STRSUBSTNO(ActivityHeading, JobActivity.NS_Description))
                            column(ActivityTotalCaption; STRSUBSTNO(Total) + STRSUBSTNO(' ' + JobActivity.NS_Description))//PRJ-754.AS.1.0 21JUN2021 Add
                            {
                            }
                            //column(ProcessTotalCaption; STRSUBSTNO(Total) + STRSUBSTNO(ProcessHeading, ProcessDesc))
                            column(ProcessTotalCaption; STRSUBSTNO(Total) + STRSUBSTNO(' ' + JobProcess.NS_Description))//PRJ-754.AS.1.0 21JUN2021 ADD
                            {
                            }
                            //column(OperationTotalCaption; STRSUBSTNO(Total) + STRSUBSTNO(OperationHeading, OperationsDesc))
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
                            column(JobTaskRecDesc; JobTaskRecDesc)//PRJ-1210.AS.1.0 Added column
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                WITH JobReportBuffer1 DO BEGIN

                                    IF JobDetail.Number > 1 THEN
                                        JobReportBuffer1.NEXT;
                                    Clear(JobTaskRecDesc);//PRJ-1210.AS.1.0

                                    //Get Contact Name
                                    JobRec.GET(JobReportBuffer1."NS_Job No.");
                                    IF NOT Contact.GET(COPYSTR(JobRec."NS_Customer Account", 1, 20)) THEN
                                        //PE-222.DK.1.0 05Feb2024 Start
                                    //Contact.Name := '';
                                    Contact.Name := JobRec."Sell-to Customer Name";
                                //PE-222.DK.1.0 05Feb2024 End

                                    //Clear the current Activity, Process and Operation headers since the report format depends on their values
                                    CLEAR(JobProcess);
                                    CLEAR(JobOperation);
                                    Clear(JobSection);//PRJ-688.AM.1.0

                                    CheckForJobOrAPOBreak();
                                    //PRJ-184.VT.1.0 23-03-20 Begin
                                    if JobTask.GET(JobReportBuffer1."NS_Job No.", JobReportBuffer1."NS_Job Task No.") then; //PRJ-528.AS.1.0 08DEC2021 Added if...then

                                    JobTaskRecDesc := JobTask.Description;//PRJ-1210.AS.1.0

                                    FindActivityOrProcessExists(JobReportBuffer1."NS_Job Task No.");
                                    CLEAR(ProcessDesc);
                                    CLEAR(OperationsDesc);
                                    Clear(Sectiondesc);//PRJ-688.AM.1.0

                                    //PRJ-1555.NK.1.0 03Aug2022 Start
                                    // IF JobProcess.NS_Code <> '' THEN BEGIN
                                    //     IF JobOperation.NS_Code <> '' THEN BEGIN
                                    //         ProcessDesc := JobProcess.NS_Description
                                    //     END
                                    //     ELSE BEGIN
                                    //         ProcessDesc := JobTask.Description
                                    //     END;


                                    // END;
                                    ProcessDesc := JobProcess.NS_Description;
                                    //PRJ-1555.NK.1.0 03Aug2022 End

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
                        MergeSubJobsIntoJobs;

                    CopyReportBuffer(JobReportBuffer1, JobReportBuffer2);
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
                field("Include Sub-Levels"; "IncludeSub-Levels")
                {
                    Caption = 'Include Change Orders';
                    ApplicationArea = all;
                    ToolTip = 'Enabling this will include the Sub Level Jobs with the master Job.'; //PE-134.DK.1.0 26July2023
                }
                field("Show Sub-Levels"; "ShowSub-Levels")
                {
                    Caption = 'Show Change Orders';
                    ApplicationArea = all;
                }
                field("Show Processes"; ShowProcesses)
                {
                    Caption = 'Show Processes';
                    ApplicationArea = all;
                    CaptionClass = '50995,1,0'; //PRJ-1348.NK.1.0 08Jun2022

                    trigger OnValidate()
                    begin
                        IF NOT ShowProcesses THEN
                            ShowOperations := FALSE;
                    end;
                }
                field("Show Operations"; ShowOperations)
                {
                    Caption = 'Show Operations';
                    ApplicationArea = all;
                    CaptionClass = '50995,2,0'; //PRJ-1348.NK.1.0 08Jun2022
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
                    CaptionClass = '50995,3,0'; //PRJ-1348.NK.1.0 08Jun2022
                    trigger OnValidate();
                    begin
                        if ShowSections then begin
                            ShowOperations := true;
                            ShowProcesses := TRUE; //PRJ-1555.NK.1.0 04Aug2022
                        end; //PRJ-1555.NK.1.0 04Aug2022
                    end;
                }
                //PRJ-688.AM.1.0
                field("Show Details"; ShowDetails)
                {
                    Caption = 'Show Details';
                    ApplicationArea = all;
                }
                field("Show Locked"; ShowLocked)
                {
                    Caption = 'Show Locked';
                    ApplicationArea = all;
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
        CompanyInformation.CalcFields(Picture);//PE-141.NK.1.0 start 11Aug2023
        JobsSetup.GET;
        //PE-141.NK.1.0 start 11Aug2023
        if CompanyInformation.Address = '' then
            NS_CompanyInformationAdd := ''
        else
            NS_CompanyInformationAdd := CompanyInformation.Address;
        if CompanyInformation."Address 2" = '' then
            NS_CompanyInformationadd2 := ''
        else
            NS_CompanyInformationadd2 := CompanyInformation."Address 2";

        if CompanyInformation.City = '' then
            NS_CompanyInformationcity := ''
        else
            NS_CompanyInformationcity := CompanyInformation.City + ',' + ' ';
        if CompanyInformation.County = '' then
            NS_CompanyInformationCountry := ''
        else
            NS_CompanyInformationCountry := CompanyInformation.County + ' ';
        if CompanyInformation."Post Code" = '' then
            NS_CompanyInformationpost := ''
        else
            NS_CompanyInformationpost := CompanyInformation."Post Code";
        NS_CompanyFullAddress := NS_CompanyInformationcity + NS_CompanyInformationCountry + NS_CompanyInformationpost;

        //PE-141.NK.1.0 start 11Aug2023

    end;

    trigger OnPreReport()
    var
        ApoSetup: Record NS_APOSetup; //PRJ-1348.NK.1.0 12Jul2022
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
        //PRJ-1348.NK.1.0 12Jul2022 Start
        ActivityProcessOperationLbl := '';
        if JobsSetup.Get() then; //PRJ-1348.NK.1.0 08Sep2022
        if ApoSetup.Get() then; //PRJ-1348.NK.1.0 08Sep2022
        if JobsSetup."NS_Activate Task Pick List" then
            ActivityProcessOperationLbl := ApoSetup."Activity Code" + ' / ' + ApoSetup."Process Code" + ' / ' + ApoSetup."Operation Code" + ' / ' + ApoSetup."Section Code"
        else
            ActivityProcessOperationLbl := 'Activity / Process / Operation / Sections';
        //PRJ-1348.NK.1.0 12Jul2022 End
    end;

    var
        JobHold: Record Job;
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
        Contact: Record Contact;
        ActivityProcess: Code[40]; //PE-97.NC.1.0 31May2023
        ProcessCodeToUse: Code[10];
        OperationCodeToUse: Code[10];
        SectionCodeToUse: Code[10];//PRJ-688.AM.1.0
        JobNo: Code[20];
        ActivityCode: Code[10];
        ProcessCode: Code[10];
        OperationCode: Code[10];
        SectionCode: Code[10];//PRJ-688.AM.1.0
        JobNoHold: Code[20];
        //PE-141.NK.1.0 start 23Aug2023 
        NS_CompanyInformationAdd: Text[250];
        NS_CompanyInformationadd2: Text[250];
        NS_CompanyInformationcity: Text;
        NS_CompanyInformationRegion: Code[20];
        NS_CompanyInformationpost: Code[20];
        NS_CompanyInformationCountry: Text[250];
        NS_CompanyFullAddress: Text[250];
        //PE-141.NK.1.0 end 23Aug2023 
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
        ReportTitle: Label 'Actual vs Budget Cost by APO';
        PageLbl: Label 'Page';
        JobFiltersLbl: Label 'Job Filters:';
        DescriptionLbl: Label 'Description';
        NoLbl: Label 'No.';
        UOMLbl: Label 'UOM';
        TypeHeading: Label 'Type';
        BudgetRemainingLbl: Label 'Budget Remaining';
        BudgetedCostLbl: Label 'Budgeted Cost';
        ActualCostLbl: Label 'Actual Cost';
        LockedBudgetLbl: Label 'Locked Budget';
        //ActivityProcessOperationLbl: Label 'Activity / Process / Operation / Sections';//PRJ-688.AM.1.0 //PRJ-1348.NK.1.0 12Jul2022 Block
        ActivityProcessOperationLbl: text; //PRJ-1348.NK.1.0 12Jul2022
        PctOfBudUsedLbl: Label '% of Bud Used';
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
        "--VT--": Integer;
        JobTask: Record "Job Task";
        JobTaskDesc: Text[250];
        ProcessExists: Boolean;
        OperationsExists: Boolean;
        ProcessDesc: Text;
        OperationsDesc: Text;
        Sectiondesc: Text;//PRJ-688.AM.1.0
        JobTaskRecDesc: Text;//PRJ-1210.AS.1.0

    // [Scope('Onprem')]
    procedure SendJobBudgetsToBuffer(JobPlanningLine: Record "Job Planning Line"; RecordSource: Option Job,SubJob)
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
            JobReportBuffer1.SETRANGE("NS_Entry Type", "NS_Entry Type"::Cost);
            JobReportBuffer1.SETRANGE("NS_Activity Code", "NS_Activity Code");
            JobReportBuffer1.SETRANGE("NS_Process Code", ProcessCodeToUse);
            JobReportBuffer1.SETRANGE("NS_Operation Code", OperationCodeToUse);
            JobReportBuffer1.SetRange("NS_Section Code", SectionCodeToUse);//PRJ-688.AM.1.0
            JobReportBuffer1.SETRANGE(NS_Category, "NS_Cost Category");
            JobReportBuffer1.SETRANGE(NS_Type, Type);
            JobReportBuffer1.SETRANGE("NS_No.", "No.");
            JobReportBuffer1.SETRANGE("NS_Variant Code", "Variant Code");
            JobReportBuffer1.SETRANGE(NS_Adjustment, NS_Adjustment);
            JobReportBuffer1.SETRANGE("NS_Record Source", RecordSource);
            IF JobReportBuffer1.FINDSET THEN BEGIN
                IF JobReportBuffer1."NS_Job Description" = '' THEN
                    JobReportBuffer1."NS_Job Description" := Description;
                JobReportBuffer1."NS_Budgeted Cost" := JobReportBuffer1."NS_Budgeted Cost" + "Total Cost";
                JobReportBuffer1.MODIFY;
            END ELSE BEGIN
                JobReportBuffer1.INIT;
                LastEntryNo := LastEntryNo + 1;
                JobReportBuffer1."NS_Entry No." := LastEntryNo;
                JobReportBuffer1."NS_Job No." := "Job No.";
                JobReportBuffer1."NS_Entry Type" := JobReportBuffer1."NS_Entry Type"::Cost;
                JobReportBuffer1."NS_Job Task No." := "Job Task No.";
                JobReportBuffer1."NS_Activity Code" := "NS_Activity Code";
                JobReportBuffer1."NS_Process Code" := ProcessCodeToUse;
                JobReportBuffer1."NS_Operation Code" := OperationCodeToUse;
                JobReportBuffer1."NS_Section Code" := SectionCodeToUse; //PRJ-688.AM.1.0
                JobReportBuffer1.NS_Category := "NS_Cost Category";
                IF Type = Type::"NS_Resource (Group)" THEN
                    JobReportBuffer1.NS_Type := JobReportBuffer1.NS_Type::"Group (Resource)"
                ELSE
                    JobReportBuffer1.NS_Type := Type;
                JobReportBuffer1."NS_No." := "No.";
                JobReportBuffer1.NS_Description := Description;
                JobReportBuffer1."NS_Job Description" := Description;
                JobReportBuffer1."NS_Variant Code" := "Variant Code";
                JobReportBuffer1."NS_Budgeted Cost" := "Total Cost";
                JobReportBuffer1.NS_Adjustment := NS_Adjustment;
                JobReportBuffer1."NS_Record Source" := RecordSource;
                JobReportBuffer1."NS_Locked Budget Record" := FALSE;
                JobReportBuffer1.INSERT;
            END;
        END;
    end;

    // [Scope('Onprem')]
    procedure SendLockedJobBudgetsToBuffer(LockedJobPlanningLine: Record "NS_Locked Job Planning Line"; RecordSource: Option Job,SubJob)
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
            JobReportBuffer1.SETRANGE("NS_Entry Type", "NS_Entry Type"::Cost);
            JobReportBuffer1.SETRANGE("NS_Activity Code", "NS_Activity Code");
            JobReportBuffer1.SETRANGE("NS_Process Code", ProcessCodeToUse);
            JobReportBuffer1.SETRANGE("NS_Operation Code", OperationCodeToUse);
            JobReportBuffer1.SetRange("NS_Section Code", SectionCodeToUse);//PRJ-688.AM.1.0
            JobReportBuffer1.SETRANGE(NS_Category, "NS_Cost Category");
            JobReportBuffer1.SETRANGE(NS_Type, NS_Type);
            JobReportBuffer1.SETRANGE("NS_No.", "NS_No.");
            JobReportBuffer1.SETRANGE("NS_Variant Code", "NS_Variant Code");
            JobReportBuffer1.SETRANGE(NS_Adjustment, NS_Adjustment);
            JobReportBuffer1.SETRANGE("NS_Record Source", RecordSource);
            IF JobReportBuffer1.FINDSET THEN BEGIN
                IF JobReportBuffer1."NS_Job Description" = '' THEN
                    JobReportBuffer1."NS_Job Description" := NS_Description;
                JobReportBuffer1."NS_Locked Budgeted Cost" := JobReportBuffer1."NS_Locked Budgeted Cost" + "NS_Total Cost";
                JobReportBuffer1.MODIFY;
            END ELSE BEGIN
                JobReportBuffer1.INIT;
                LastEntryNo := LastEntryNo + 1;
                JobReportBuffer1."NS_Entry No." := LastEntryNo;
                JobReportBuffer1."NS_Job No." := "NS_Job No.";
                JobReportBuffer1."NS_Entry Type" := JobReportBuffer1."NS_Entry Type"::Cost;
                JobReportBuffer1."NS_Job Task No." := "NS_Job Task No.";
                JobReportBuffer1."NS_Activity Code" := "NS_Activity Code";
                JobReportBuffer1."NS_Process Code" := ProcessCodeToUse;
                JobReportBuffer1."NS_Operation Code" := OperationCodeToUse;
                JobReportBuffer1."NS_Section Code" := SectionCodeToUse; //PRJ-688.AM.1.0
                JobReportBuffer1.NS_Category := "NS_Cost Category";
                IF NS_Type = NS_Type::"Resource (Group)" THEN
                    JobReportBuffer1.NS_Type := JobReportBuffer1.NS_Type::"Group (Resource)"
                ELSE
                    JobReportBuffer1.NS_Type := NS_Type;
                JobReportBuffer1."NS_No." := "NS_No.";
                JobReportBuffer1.NS_Description := NS_Description;
                JobReportBuffer1."NS_Job Description" := NS_Description;
                JobReportBuffer1."NS_Variant Code" := "NS_Variant Code";
                JobReportBuffer1."NS_Locked Budgeted Cost" := "NS_Total Cost";
                JobReportBuffer1.NS_Adjustment := NS_Adjustment;
                JobReportBuffer1."NS_Record Source" := RecordSource;
                JobReportBuffer1."NS_Locked Budget Record" := TRUE;
                JobReportBuffer1.INSERT;
            END;
        END;
    end;

    //[Scope('ONprem')]
    procedure SendJobLedgerToBuffer(JobLedgerEntry: Record "Job Ledger Entry"; RecordSource: Option Job,SubJob)
    begin
        //Add Job Ledger Entry to the Job Analysis Buffer

        WITH JobLedgerEntry DO BEGIN

            //Add Job ledger data from JobLedgerEntry to the Job Analysis Buffer
            NS_GetActualPOCodesToUse("NS_Process Code", "NS_Operation Code", "NS_Section Code", ProcessCodeToUse, OperationCodeToUse, SectionCodeToUse);//PRJ-688.AM.1.0

            JobReportBuffer1.RESET;
            JobReportBuffer1.SETCURRENTKEY("NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code", NS_Category, NS_Type, "NS_No.", "NS_Variant Code", NS_Adjustment);
            JobReportBuffer1.SETRANGE("NS_Job No.", "Job No.");
            JobReportBuffer1.SETRANGE("NS_Entry Type", JobReportBuffer1."NS_Entry Type"::Cost);
            JobReportBuffer1.SETRANGE("NS_Activity Code", "NS_Activity Code");
            JobReportBuffer1.SETRANGE("NS_Process Code", ProcessCodeToUse);
            JobReportBuffer1.SETRANGE("NS_Operation Code", OperationCodeToUse);
            JobReportBuffer1.SetRange("NS_Section Code", SectionCodeToUse); //PRJ-688.AM.1.0
            JobReportBuffer1.SETRANGE(NS_Category, "NS_Job Cost Category");
            JobReportBuffer1.SETRANGE(NS_Type, Type);
            JobReportBuffer1.SETRANGE("NS_No.", "No.");
            JobReportBuffer1.SETRANGE("NS_Variant Code", "Variant Code");
            JobReportBuffer1.SETRANGE(NS_Adjustment, '');
            JobReportBuffer1.SETRANGE("NS_Record Source", RecordSource);
            IF JobReportBuffer1.FINDSET THEN BEGIN
                IF JobReportBuffer1."NS_Job Description" = '' THEN
                    JobReportBuffer1."NS_Job Description" := Description;
                JobReportBuffer1."NS_Actual Cost" := JobReportBuffer1."NS_Actual Cost" + "Total Cost (LCY)";
                JobReportBuffer1.MODIFY;
            END ELSE BEGIN
                JobReportBuffer1.INIT;
                LastEntryNo := LastEntryNo + 1;
                JobReportBuffer1."NS_Entry No." := LastEntryNo;
                JobReportBuffer1."NS_Job No." := "Job No.";
                JobReportBuffer1."NS_Entry Type" := JobReportBuffer1."NS_Entry Type"::Cost;
                JobReportBuffer1."NS_Job Task No." := "Job Task No.";
                JobReportBuffer1."NS_Activity Code" := "NS_Activity Code";
                JobReportBuffer1."NS_Process Code" := ProcessCodeToUse;
                JobReportBuffer1."NS_Operation Code" := OperationCodeToUse;
                JobReportBuffer1."NS_Section Code" := SectionCodeToUse;//PRJ-688.AM.1.0
                JobReportBuffer1.NS_Category := "NS_Job Cost Category";
                JobReportBuffer1.NS_Type := Type;
                JobReportBuffer1."NS_No." := "No.";
                JobReportBuffer1."NS_Actual Cost" := "Total Cost (LCY)";
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

    //[Scope('onprem')]
    procedure MergeSubJobsIntoJobs()
    begin
        //Add the sub-job values into the base job records
        WITH JobReportBuffer2 DO BEGIN
            CopyReportBuffer(JobReportBuffer1, JobReportBuffer2);
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
                    JobReportBuffer1.SETRANGE("NS_Entry Type", "NS_Entry Type"::Cost);
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
                        JobReportBuffer1."NS_Budgeted Cost" := JobReportBuffer1."NS_Budgeted Cost" + "NS_Budgeted Cost";
                        JobReportBuffer1."NS_Actual Cost" := JobReportBuffer1."NS_Actual Cost" + "NS_Actual Cost";
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

    //[Scope('onprem')]
    procedure CopyReportBuffer(var FromBuffer: Record "NS_Job Report Buffer"; var ToBuffer: Record "NS_Job Report Buffer")
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

    // [Scope('onprem')]
    procedure CheckForJobOrAPOBreak()
    begin
        WITH JobReportBuffer1 DO BEGIN
            //
            //If Activity break
            //
            IF ("NS_Activity Code" <> ActivityCodeHold) OR
               ("NS_Job No." <> JobNoHold) THEN BEGIN
                IF NOT JobActivity.GET(JobActivity.NS_Type::Cost, "NS_Activity Code") THEN
                    //JobActivity.NS_Description := Unknown;
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
                IF NOT JobProcess.GET(JobProcess.NS_Type::Cost, "NS_Activity Code", "NS_Process Code") THEN
                    // JobProcess.NS_Description := Unknown;//PRJ-437.AS.1.0 Comment
                    JobProcess.NS_Description := JobActivity.NS_Description;//PRJ-437.AS.1.0 Added

                //Set current code and hold codes
                ProcessCode := "NS_Process Code";
                ProcessCodeHold := "NS_Process Code";
                OperationCodeHold := '';  //Force an Operation Code break
            END;
            ActivityProcess := ActivityCode;//PE-97.NC.1.0 31May2023
            //
            //If Operation break
            //
            IF "NS_Operation Code" <> OperationCodeHold THEN BEGIN
                //TEMP//  IF NOT JobOperation.GET(JobOperation.NS_Type::Cost, "NS_Activity Code", "NS_Process Code", "NS_Operation Code") THEN
                //TEMP//    JobOperation.NS_Description := Unknown;

                IF NOT JobOperation.GET(JobOperation.NS_Type::Cost, "NS_Activity Code", "NS_Process Code", "NS_Operation Code") THEN
                    if "NS_Process Code" <> '' then
                        JobOperation.NS_Description := JobProcess.NS_Description
                    else
                        JobOperation.NS_Description := JobActivity.NS_Description;

                //Set current code and hold code
                OperationCode := "NS_Operation Code";
                OperationCodeHold := "NS_Operation Code";
                SectionCodeHold := '';//PRJ-688.AM.1.0
            END;
            //PRJ-688.AM.1.0
            //If Section break
            //
            if "NS_Section Code" <> SectionCodeHold then begin
                //Add to Actual and Budget Operation Quantity and Costs
                // AccumulateAPOTotals(JobReportBuffer2, 0, "NS_Job No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code", APOTotals);//PRJ-688.AM.1.0

                //if not JobSection.GET(JobSection.NS_Type::Revenue, JobReportBuffer1."NS_Activity Code", JobReportBuffer1."NS_Process Code", JobReportBuffer1."NS_Operation Code", JobReportBuffer1."NS_Section Code") then //PRJ-1555.NK.1.0 Block
                if not JobSection.GET(JobSection.NS_Type::Cost, JobReportBuffer1."NS_Activity Code", JobReportBuffer1."NS_Process Code", JobReportBuffer1."NS_Operation Code", JobReportBuffer1."NS_Section Code") then //PRJ-1555.NK.1.0 
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

    //[Scope('onprem')]
    [Obsolete('This function will be removed in next release')]
    procedure GetActualPOCodesToUse(ProcessCodeIn: Code[10]; OperationCodeIn: Code[10]; var ProcessCodeOut: Code[10]; var OperationCodeOut: Code[10])
    begin
        //This routine either passes incoming Process and Operation codes back out or returns empty strings
        //     depending on if the processes or operations are to be shown.

        Message('This function will be removed in next release');
        IF ShowProcesses THEN
            ProcessCodeOut := ProcessCodeIn
        ELSE
            ProcessCodeOut := '';

        IF ShowOperations THEN
            OperationCodeOut := OperationCodeIn
        ELSE
            OperationCodeOut := '';
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

    // [Scope('onprem')]
    procedure SetJobNoFilter(PassJobNum: Code[20])
    begin
        JobNumFilter := PassJobNum
    end;

    // [Scope('onprem')]
    procedure SetDetailLevel(PassCompleteJob: Boolean; PassSubDetail: Boolean; PassAllDetail: Boolean)
    begin
        CompleteJob := PassCompleteJob;
        SubLevelDetail := PassSubDetail;
        AllDetail := PassAllDetail;
    end;

    local procedure "---VT--"()
    begin
    end;

    local procedure FindActivityOrProcessExists(JobTaskNoParam: Code[20])
    var
        i: Integer;
        j: Integer;
    begin
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
    end;
}

