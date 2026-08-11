report 14021161 "NS_Act vs Bud Cost by APOwQty"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-84.SK.1.0 Added report to search
    //PRJ-184.VT.1.0  24-03-20
    //PRJ-437.MS.1.0 new changes for report
    //PRJ-437.AS.1.0 Code comented, as UNKNOWN APOs are not needed
    //PRJ-754.AS.1.0 21JUN2021 Done changes in Layout for APOS naming, added & commented codes
    DefaultLayout = RDLC;
    Caption = 'Act vs Bud Cost by APO w Qty';
    RDLCLayout = './Layouts/NSAct vs Bud Cost by APO w Qty.rdl';
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

                trigger OnAfterGetRecord();
                begin
                    SendJobBudgetsToBuffer("Job Planning Line", JobReportBuffer1."NS_Record Source"::Job);
                end;

                trigger OnPreDataItem();
                begin
                    //Get the master Job Planning Lines into the buffer
                    SETFILTER("Job No.", Job."No.");
                    SETFILTER("NS_Entry Type", '%1|%2', "NS_Entry Type"::Cost, "NS_Entry Type"::Both);
                    SETFILTER("Job Task No.", Job.GETFILTER("NS_Job Task No. Filter"));
                    SETFILTER(Type, Job.GETFILTER("NS_Type Filter"));
                    SETFILTER("Planning Date", Job.GETFILTER("NS_Date Filter"));
                end;
            }
            dataitem("Job Ledger Entry"; "Job Ledger Entry")
            {
                DataItemLink = "Job No." = FIELD("No.");
                DataItemTableView = SORTING("Job No.", "Job Task No.", "Entry Type", "Posting Date");

                trigger OnAfterGetRecord();
                begin
                    SendJobLedgerToBuffer("Job Ledger Entry", JobReportBuffer1."NS_Record Source"::Job);
                end;

                trigger OnPreDataItem();
                begin
                    //Get the master Job Ledger Entries into the buffer
                    SETFILTER("Job No.", Job."No.");
                    SETFILTER("Job Task No.", Job.GETFILTER("NS_Job Task No. Filter"));
                    SETFILTER("Entry Type", FORMAT("Entry Type"::Usage));
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
                    DataItemTableView = SORTING("Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Cost Category", Type, "No.", "Variant Code");

                    trigger OnAfterGetRecord();
                    begin
                        SendJobBudgetsToBuffer("Job Planning Line Sub-Levels", JobReportBuffer1."NS_Record Source"::SubJob);
                    end;

                    trigger OnPreDataItem();
                    begin
                        //Get sub-level Job Planning Lines into the buffer
                        SETFILTER("NS_Entry Type", '%1|%2', "NS_Entry Type"::Cost, "NS_Entry Type"::Both);
                        SETFILTER(Type, Job.GETFILTER("NS_Type Filter"));
                        SETFILTER("Planning Date", Job.GETFILTER("NS_Date Filter"));
                        SETFILTER("Job Task No.", Job.GETFILTER("NS_Job Task No. Filter"));
                    end;
                }
                dataitem("Job Ledger Entry Sub-Levels"; "Job Ledger Entry")
                {
                    DataItemLink = "Job No." = FIELD("No.");
                    DataItemTableView = SORTING("Job No.", "Job Task No.", "Entry Type", "Posting Date");

                    trigger OnAfterGetRecord();
                    begin
                        SendJobLedgerToBuffer("Job Ledger Entry Sub-Levels", JobReportBuffer1."NS_Record Source"::SubJob);
                    end;

                    trigger OnPreDataItem();
                    begin
                        //Get sub-job Job Ledger Entries into the buffer
                        SETFILTER("Job Task No.", Job.GETFILTER("NS_Job Task No. Filter"));
                        SETFILTER("Entry Type", FORMAT("Entry Type"::Usage));
                        SETFILTER("Posting Date", Job.GETFILTER("NS_Date Filter"));
                        SETFILTER(Type, Job.GETFILTER("NS_Type Filter"));
                    end;
                }

                trigger OnPreDataItem();
                begin
                    if (not "IncludeSub-Levels") and (not "ShowSub-Levels") then
                        CurrReport.BREAK;
                end;
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemTableView = SORTING("Job No.") ORDER(Ascending);

                trigger OnAfterGetRecord();
                var
                    Activity: Code[10];
                    Process: Code[10];
                    Operation: Code[10];
                    Section: code[10];//PRJ-688.AM.1.0
                    BalReqQty: Decimal;
                    BalReqCost: Decimal;
                begin
                    //Breakup the Job Task in to APO
                    Job.NS_JobTaskNoToAPO("Job Task No.", Activity, Process, Operation, Section);//PRJ-688.AM.1.0
                    if not ShowProcesses then
                        Process := '';
                    if not ShowOperations then
                        Operation := '';
                    if not Showsections then //PRJ-688.AM.1.0
                        Section := '';

                    JobReportBuffer1.RESET;
                    JobReportBuffer1.SETCURRENTKEY("NS_Job No.", "NS_Entry Type", NS_Type, "NS_No.", "NS_Variant Code", "NS_Job Task No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", NS_Category, NS_Adjustment);
                    JobReportBuffer1.SETRANGE("NS_Job No.", Job."No.");
                    JobReportBuffer1.SETRANGE("NS_Entry Type", JobReportBuffer1."NS_Entry Type"::Cost);
                    case true of
                        Type = Type::"G/L Account":
                            JobReportBuffer1.SETRANGE(NS_Type, JobReportBuffer1.NS_Type::"G/L Account");
                        Type = Type::Item:
                            JobReportBuffer1.SETRANGE(NS_Type, JobReportBuffer1.NS_Type::Item);
                        Type = Type::Resource:
                            JobReportBuffer1.SETRANGE(NS_Type, JobReportBuffer1.NS_Type::Resource);
                    end;
                    JobReportBuffer1.SETRANGE("NS_No.", "No.");
                    JobReportBuffer1.SETRANGE("NS_Variant Code", "Variant Code");
                    JobReportBuffer1.SETRANGE("NS_Job Task No.", "Job Task No.");
                    JobReportBuffer1.SETRANGE("NS_Activity Code", Activity);
                    JobReportBuffer1.SETRANGE("NS_Process Code", Process);
                    JobReportBuffer1.SETRANGE("NS_Operation Code", Operation);
                    JobReportBuffer1.SETRANGE("NS_Section Code", Section);//PRJ-688.AM.1.0

                    if JobReportBuffer1.FINDSET then begin
                        JobReportBuffer1."NS_Committed Quantity" := JobReportBuffer1."NS_Committed Quantity" + "NS_Committed Quantity";
                        JobReportBuffer1."NS_Committed Amount" := JobReportBuffer1."NS_Committed Amount" + "NS_Committed Amount";
                        JobReportBuffer1.MODIFY;
                    end else begin

                        JobReportBuffer1.INIT;
                        LastEntryNo := LastEntryNo + 1;
                        JobReportBuffer1."NS_Entry No." := LastEntryNo;
                        JobReportBuffer1."NS_Job No." := Job."No.";
                        JobReportBuffer1."NS_Entry Type" := JobReportBuffer1."NS_Entry Type"::Cost;
                        case true of
                            Type = Type::"G/L Account":
                                JobReportBuffer1.NS_Type := JobReportBuffer1.NS_Type::"G/L Account";
                            Type = Type::Item:
                                JobReportBuffer1.NS_Type := JobReportBuffer1.NS_Type::Item;
                            Type = Type::Resource:
                                JobReportBuffer1.NS_Type := JobReportBuffer1.NS_Type::Resource;
                        end;
                        JobReportBuffer1."NS_No." := "No.";
                        JobReportBuffer1."NS_Variant Code" := "Variant Code";
                        JobReportBuffer1.NS_Description := Description;
                        JobReportBuffer1."NS_Unit Of Measure" := "Unit of Measure Code";
                        JobReportBuffer1."NS_Job Task No." := "Job Task No.";
                        JobReportBuffer1."NS_Activity Code" := Activity;
                        JobReportBuffer1."NS_Process Code" := Process;
                        JobReportBuffer1."NS_Operation Code" := Operation;
                        JobReportBuffer1."NS_Section Code" := Section;//PRJ-688.AM.1.0
                        JobReportBuffer1.NS_Category := "NS_Job Cost Category";
                        JobReportBuffer1."NS_Committed Quantity" := "NS_Committed Quantity";
                        JobReportBuffer1."NS_Committed Amount" := "NS_Committed Amount";
                        //Troubleshooting
                        //IF JobReportBuffer1."No." =  'BACK BLANK 5.25X5.25' THEN
                        //MESSAGE('TESt');
                        JobReportBuffer1.INSERT;
                    end;
                end;

                trigger OnPreDataItem();
                begin
                    RESET;
                    SETCURRENTKEY("Job No.");
                    SETRANGE("Job No.", Job."No.");
                end;
            }
            dataitem("Page Header"; "Integer")
            {
                DataItemTableView = SORTING(Number) ORDER(Ascending);
                MaxIteration = 1;
                column(Report_Title; ReportTitle)
                {
                }
                column(CompanyInformation_Name; CompanyInformation.Name)
                {
                }
                column(PageCaption; PageLbl)
                {
                }
                column(JobFiltersCaption; JobFiltersLbl)
                {
                }
                column(Activity_Process_OperationCaption; ActivityProcessOperationLbl)
                {
                }
                column(DescriptionCaption; DescriptionLbl)
                {
                }
                column(NoCaption; NoHeadingLbl)
                {
                }
                column(UOMCaption; UOMLbl)
                {
                }
                column(Actual_QtyCaption; ActualQtyLbl)
                {
                }
                column(Budgeted_QtyCaption; BudgetedQtyLbl)
                {
                }
                column(Qty_VarianceCaption; QtyVarianceLbl)
                {
                }
                column(TypeCaption; TypeHeadingLbl)
                {
                }
                column(Actual_CostCaption; ActualCostLbl)
                {
                }
                column(Budgeted_CostCaption; BudgetedCostLbl)
                {
                }
                column(Budget_RemainingCaption; BudgetRemainingLbl)
                {
                }
                column(Pct_of_Bud_UsedCaption; PctOfBudUsedLbl)
                {
                }
                column(CommittedQuantityCaption; CommittedQuantityLbl)
                {
                }
                column(CommittedCostCaption; CommittedCostLbl)
                {
                }
                column(CustomerAccountNameCaption; CustomerAccountNameLbl)
                {
                }
                column(JobLocationCaption; JobLocationLbl)
                {
                }
                column(Show_Processes; ShowProcesses)
                {
                }
                column(Show_Operations; ShowOperations)
                {
                }
                column(Show_Sections; Showsections)
                {

                }
                column(Show_Details; ShowDetails)
                {
                }
                column(Sub_LevelsText; "Sub-LevelsText")
                {
                }
                dataitem(JobAnalysisBuffer1Loop; "Integer")
                {
                    DataItemTableView = SORTING(Number) ORDER(Ascending);
                    dataitem(JobAndSubJob; "Integer")
                    {
                        DataItemTableView = SORTING(Number) ORDER(Ascending);
                        dataitem(JobDetail; "Integer")
                        {
                            DataItemTableView = SORTING(Number) ORDER(Ascending);
                            column(JobFilters; JobFilters)
                            {
                            }
                            column(Job_No; STRSUBSTNO(Text14021100, JobReportBuffer1."NS_Job No."))
                            {
                            }
                            column(Job_Description; Job.Description)
                            {
                            }
                            column(job_TaskNOBuffer; JobReportBuffer1."NS_Job Task No.")//PRJ-754.AS.1.0 21JUN2021
                            {
                            }
                            column(Starting_Date; STRSUBSTNO(Text14021106, Job."Starting Date"))
                            {
                            }
                            column(Ending_Date; STRSUBSTNO(Text14021107, Job."Ending Date"))
                            {
                            }
                            column(Activity_Code; JobReportBuffer1."NS_Activity Code")
                            {
                            }
                            column(Process_Code; JobReportBuffer1."NS_Process Code")
                            {
                            }
                            column(Operation_Code; JobReportBuffer1."NS_Operation Code")
                            {
                            }
                            column(Section_code; JobReportBuffer1."NS_Section Code")//PRJ-688.AM.1.0
                            {
                            }
                            column(Activity_Description; JobActivity.NS_Description)
                            {
                            }
                            //column(Process_Description; JobProcess.Description)//PRJ-184.VT.1.0 24-03-20
                            column(Process_Description; ProcessDesc) //PRJ-184.VT.1.0 24-03-20
                            {
                            }
                            //column(Operation_Description; JobOperation.Description)//PRJ-184.VT.1.0 24-03-20
                            column(Operation_Description; OperationsDesc)//PRJ-184.VT.1.0 24-03-20
                            {
                            }
                            column(Sectiondesc; Sectiondesc) { }//PRJ-688.AM.1.0
                            column(Detail_Description; JobReportBuffer1.NS_Description)
                            {
                            }
                            column(Detail_No; JobReportBuffer1."NS_No.")
                            {
                            }
                            column(Detail_Unit_Of_Measure; JobReportBuffer1."NS_Unit Of Measure")
                            {
                            }
                            column(Detail_Actual_Cost_Qty; JobReportBuffer1."NS_Actual Cost Qty.")
                            {
                            }
                            column(Detail_Budgeted_Cost_Qty; JobReportBuffer1."NS_Budgeted Cost Qty.")
                            {
                            }
                            column(Detail_Type; JobReportBuffer1.NS_Type)
                            {
                            }
                            column(Detail_Actual_Cost; JobReportBuffer1."NS_Actual Cost")
                            {
                            }
                            column(Detail_Budgeted_Cost; JobReportBuffer1."NS_Budgeted Cost")
                            {
                            }
                            column(Committed_Quantity; JobReportBuffer1."NS_Committed Quantity")
                            {
                            }
                            column(Committed_Amount; JobReportBuffer1."NS_Committed Amount")
                            {
                            }
                            // column(Activity_TotalCaption; STRSUBSTNO(Total) + STRSUBSTNO(Text14021101, JobActivity.NS_Description))//PRJ-754.AS.1.0 21JUN2021 Comment
                            column(Activity_TotalCaption; STRSUBSTNO(Total) + STRSUBSTNO(' ' + JobActivity.NS_Description))//PRJ-754.AS.1.0 21JUN2021 Add
                            {
                            }
                            //column(Process_TotalCaption; STRSUBSTNO(Total) + STRSUBSTNO(Text14021102, JobProcess.Description))//PRJ-184.VT.1.0 24-03-20
                            // column(Process_TotalCaption; STRSUBSTNO(Total) + STRSUBSTNO(Text14021102, ProcessDesc))//PRJ-184.VT.1.0 24-03-20//PRJ-754.AS.1.0 21JUN2021 Comment
                            column(Process_TotalCaption; STRSUBSTNO(Total) + STRSUBSTNO(' ' + ProcessDesc))//PRJ-754.AS.1.0 21JUN2021 ADD
                            {
                            }
                            //column(Operation_TotalCaption; STRSUBSTNO(Total) + STRSUBSTNO(Text14021103, JobOperation.Description)) //PRJ-184.VT.1.0 24-03-20
                            // column(Operation_TotalCaption; STRSUBSTNO(Total) + STRSUBSTNO(Text14021103, OperationsDesc))//PRJ-184.VT.1.0 24-03-20//PRJ-754.AS.1.0 21JUN2021 Comment
                            column(Operation_TotalCaption; STRSUBSTNO(Total) + STRSUBSTNO(' ' + OperationsDesc))//PRJ-754.AS.1.0 21JUN2021
                            {
                            }
                            // column(Section_TotalCaption; STRSUBSTNO(Total) + STRSUBSTNO(SecLbl, Sectiondesc))//PRJ-688.AM.1.0//PRJ-754.AS.1.0 21JUN2021 Comment
                            column(Section_TotalCaption; STRSUBSTNO(Total) + STRSUBSTNO(' ' + Sectiondesc))//PRJ-754.AS.1.0 21JUN2021 Add
                            {
                            }
                            column(Total_Job_No; STRSUBSTNO(Text14021104, JobReportBuffer1."NS_Job No."))
                            {
                            }
                            column(Customer_Account_Name; Contact.Name)
                            {
                            }
                            column(Job_Name; JobRec.Description)
                            {
                            }

                            trigger OnAfterGetRecord();
                            begin
                                with JobReportBuffer1 do begin


                                    if JobDetail.Number > 1 then
                                        JobReportBuffer1.NEXT;

                                    JobRec.GET(JobReportBuffer1."NS_Job No.");
                                    if not Contact.GET(COPYSTR(JobRec."NS_Customer Account", 1, 20)) then
                                        Contact.Name := '';

                                    //Clear the current Activity, Process and Operation headers since the report format depends on their values
                                    CLEAR(JobProcess);
                                    CLEAR(JobOperation);
                                    Clear(JobSection);//PRJ-688.AM.1.0

                                    CheckForJobOrAPOBreak;
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
                                    AccumulateAPOTotals(JobReportBuffer2, "NS_Entry No.", '', '', '', '', '', APOTotals);//PRJ-688.AM.1.0

                                    //Add to Actual and Budget costs for this detail line for the whole job
                                    //  Needs to be done here to generate proper values for the end of the report
                                    AccumulateAPOTotals(JobReportBuffer2, 0, "NS_Job No.", '', '', '', '', APOTotals);//PRJ-688.AM.1.0

                                end;
                            end;

                            trigger OnPreDataItem();
                            begin
                                if NumBudgetLines = 0 then
                                    CurrReport.BREAK;

                                JobDetail.SETRANGE(Number, 1, NumBudgetLines);
                                CLEAR(APOTotals);
                            end;
                        }

                        trigger OnAfterGetRecord();
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

                        trigger OnPreDataItem();
                        begin
                            //Get a record count and skip out if it is zero

                            with JobReportBuffer1 do begin
                                RESET;
                                SETCURRENTKEY("NS_Record Source");
                                SETRANGE("NS_Record Source", RecordSource);
                                NumBudgetLines := COUNT;
                                if NumBudgetLines > 0 then begin
                                    FINDSET;
                                    JobAndSubJob.SETRANGE(Number, 1);
                                end else
                                    CurrReport.BREAK;
                            end;
                        end;
                    }

                    trigger OnAfterGetRecord();
                    begin
                        case Number of
                            1:
                                RecordSource := RecordSource::Job;
                            2:
                                if "ShowSub-Levels" then
                                    RecordSource := RecordSource::SubJob
                                else
                                    CurrReport.SKIP;
                        end;
                    end;

                    trigger OnPreDataItem();
                    begin
                        //Start processing JobReportBuffer1 to generate report
                        //  First set is the Job.  The second set contains any seperatly printed sub-jobs
                        SETRANGE(Number, 1, 2);
                    end;
                }

                trigger OnPreDataItem();
                begin
                    JobReportBuffer1.RESET;

                    if JobReportBuffer1.COUNT = 0 then
                        ERROR(Text14021108);

                    if "IncludeSub-Levels" then
                        MergeSubJobsIntoJobs;

                    CopyReportBuffer(JobReportBuffer1, JobReportBuffer2);
                end;
            }

            trigger OnAfterGetRecord();
            begin
                RecCount := RecCount + 1;

                //Skip jobs containing the Job No. Seperator in the No. unless that is the one that was actually requested
                //  This can only run one sub-job at a time, but does allow for a manager to get only a portion of the job that pertains to them
                //  Any others would have to be skipped.
                if STRPOS("No.", JobsSetup."NS_Job No. Separators") > 0 then begin
                    if "No." <> JobHold.GETFILTER("No.") then
                        CurrReport.SKIP;
                end;

                JobReportBuffer1.RESET;
                JobReportBuffer1.DELETEALL;
                JobReportBuffer2.RESET;
                JobReportBuffer2.DELETEALL;
                LastEntryNo := 0;
                if RecCount > 1 then
                    CurrReport.NEWPAGE;
            end;

            trigger OnPreDataItem();
            begin
                if JobNumFilter <> '' then
                    SETRANGE("No.", JobNumFilter);
                if COUNT = 0 then
                    ERROR(Text14021108);

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
        SaveValues = false;

        layout
        {
            area(content)
            {
                field("Include Sub-Levels"; "IncludeSub-Levels")
                {
                    Caption = 'Include Change Orders';
                    ApplicationArea = All;
                }
                field("Show Sub-Levels"; "ShowSub-Levels")
                {
                    Caption = 'Show Change Orders';
                    ApplicationArea = All;
                }
                field("Show Processes"; ShowProcesses)
                {
                    Caption = 'Show Processes';
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        if not ShowProcesses then
                            ShowOperations := false;
                    end;
                }
                field("Show Operations"; ShowOperations)
                {
                    Caption = 'Show Operations';
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        if ShowOperations then
                            ShowProcesses := true;
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
                field("Show Details"; ShowDetails)
                {
                    Caption = 'Show Details';
                    ApplicationArea = All;
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            if CompleteJob then begin
                "IncludeSub-Levels" := true;
                ShowProcesses := true;
                ShowOperations := true;
                Showsections := true;//PRJ-688.AM.1.0
                "ShowSub-Levels" := false;
                ShowDetails := false;
            end;
            if SubLevelDetail then begin
                "IncludeSub-Levels" := false;
                ShowProcesses := true;
                ShowOperations := true;
                Showsections := true;//PRJ-688.AM.1.0
                "ShowSub-Levels" := true;
                ShowDetails := false;
            end;
            if AllDetail then begin
                "IncludeSub-Levels" := false;
                ShowProcesses := true;
                ShowOperations := true;
                Showsections := true;//PRJ-688.AM.1.0
                "ShowSub-Levels" := true;
                ShowDetails := true;
            end;
        end;
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        CompanyInformation.GET;
        JobsSetup.GET;
    end;

    trigger OnPreReport();
    begin
        if JobNumFilter <> '' then
            Job.SETRANGE("No.", JobNumFilter);
        JobFilters := Job.GETFILTERS;
        if "IncludeSub-Levels" then
            "Sub-LevelsText" := STRSUBSTNO(Text14021105, ' ')
        else
            "Sub-LevelsText" := STRSUBSTNO(Text14021105, ' ' + notLbl + ' ');

        if ShowDetails then begin
            NoHeadingLbl := NoLbl;
            TypeHeadingLbl := TypeHeading;
        end;
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
        Contact: Record Contact;
        RecordSource: Option Job,SubJob;
        APOTotals: array[10] of Decimal;//PRJ-688.AM.1.0
        LastEntryNo: Integer;
        RecCount: Integer;
        NumBudgetLines: Integer;
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
        Text14021100: Label 'Job: %1';
        Text14021101: Label 'Activity  %1';
        Text14021102: Label 'Process %1';
        Text14021103: Label 'Operation %1';
        SecLbl: Label 'Section %1';//PRJ-688.AM.1.0
        Text14021104: Label 'Total Job %1';
        Text14021105: Label 'Sub-Levels are%1included in jobs';
        Text14021106: Label 'Starting Date: %1';
        Text14021107: Label 'Ending Date: %1';
        Text14021108: Label 'There is no information to show as requested.';
        ReportTitle: Label 'Actual vs Budget Cost by APO with Qty';
        PageLbl: Label 'Page';
        JobFiltersLbl: Label 'Job Filters:';
        DescriptionLbl: Label 'Description';
        NoLbl: Label 'No.';
        UOMLbl: Label 'UOM';
        ActualQtyLbl: Label 'Actual Qty';
        BudgetedQtyLbl: Label 'Budgeted Qty';
        QtyVarianceLbl: Label 'Qty Variance';
        TypeHeading: Label 'Type';
        BudgetRemainingLbl: Label 'Budget Remaining';
        BudgetedCostLbl: Label 'Budgeted Cost';
        ActualCostLbl: Label 'Actual Cost';
        ActivityProcessOperationLbl: Label 'Activity / Process / Operation / Sections';//PRJ-688.AM.1.0
        PctOfBudUsedLbl: Label '% of Bud Used';
        CommittedQuantityLbl: Label 'Committed JMP Qty';
        CommittedCostLbl: Label 'Committed JMP Cost';
        JobDescription: Label 'Job Description:';
        CustomerAccountNameLbl: Label 'Customer Account Name:';
        JobLocationLbl: Label 'Job Location:';
        Unknown: Label 'UNKNOWN';
        notLbl: Label 'not ';
        Total: Label 'Total ';
        JobNumFilter: Code[20];
        CompleteJob: Boolean;
        SubLevelDetail: Boolean;
        AllDetail: Boolean;
        //GEI-10
        //PRJ-184.VT.1.0
        JobTask: Record 1001;
        JobTaskDesc: Text[250];
        ProcessExists: Boolean;
        OperationsExists: Boolean;
        ProcessDesc: Text;
        OperationsDesc: Text;
        Sectiondesc: Text;//PRJ-688.AM.1.0

    procedure SendJobBudgetsToBuffer(JobPlanningLine: Record "Job Planning Line"; RecordSource: Option Job,SubJob);
    begin
        with JobPlanningLine do begin
            if Type = Type::Text then
                exit;

            //Add Job budget data from JobPlanningLine to the Job Analysis Buffer
            GetActualPOCodesToUse("NS_Process Code", "NS_Operation Code", "NS_Section Code", ProcessCodeToUse, OperationCodeToUse, SectionCodeToUse);//PRJ-688.AM.1.0

            JobReportBuffer1.RESET;
            JobReportBuffer1.SETCURRENTKEY("NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", NS_Category, NS_Type, "NS_No.", "NS_Variant Code", NS_Adjustment);
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
            if JobReportBuffer1.FINDSET then begin
                if JobReportBuffer1."NS_Job Description" = '' then
                    JobReportBuffer1."NS_Job Description" := Description;
                if JobReportBuffer1."NS_Unit Of Measure" = '' then
                    JobReportBuffer1."NS_Unit Of Measure" := "Unit of Measure Code";
                JobReportBuffer1."NS_Budgeted Cost Qty." := JobReportBuffer1."NS_Budgeted Cost Qty." + Quantity;
                JobReportBuffer1."NS_Budgeted Cost" := JobReportBuffer1."NS_Budgeted Cost" + "Total Cost";
                JobReportBuffer1.MODIFY;
            end else begin
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
                if Type = Type::"NS_Resource (Group)" then
                    JobReportBuffer1.NS_Type := JobReportBuffer1.NS_Type::"Group (Resource)"
                else
                    JobReportBuffer1.NS_Type := Type;
                JobReportBuffer1."NS_No." := "No.";
                JobReportBuffer1.NS_Description := Description;
                JobReportBuffer1."NS_Job Description" := Description;
                JobReportBuffer1."NS_Variant Code" := "Variant Code";
                JobReportBuffer1."NS_Budgeted Cost Qty." := Quantity;
                JobReportBuffer1."NS_Unit Of Measure" := "Unit of Measure Code";
                JobReportBuffer1."NS_Budgeted Cost" := "Total Cost";
                JobReportBuffer1.NS_Adjustment := NS_Adjustment;
                JobReportBuffer1."NS_Record Source" := RecordSource;
                JobReportBuffer1.INSERT;
            end;
        end;
    end;

    procedure SendJobLedgerToBuffer(JobLedgerEntry: Record "Job Ledger Entry"; RecordSource: Option Job,SubJob);
    begin
        with JobLedgerEntry do begin

            //Add Job ledger data from JobLedgerEntry to the Job Analysis Buffer
            GetActualPOCodesToUse("NS_Process Code", "NS_Operation Code", "NS_Section Code", ProcessCodeToUse, OperationCodeToUse, SectionCodeToUse);//PRJ-688.AM.1.0

            JobReportBuffer1.RESET;
            JobReportBuffer1.SETCURRENTKEY("NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", NS_Category, NS_Type, "NS_No.", "NS_Variant Code", NS_Adjustment);
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
            if JobReportBuffer1.FINDSET then begin
                if JobReportBuffer1."NS_Job Description" = '' then
                    JobReportBuffer1."NS_Job Description" := Description;
                if JobReportBuffer1."NS_Unit Of Measure" = '' then
                    JobReportBuffer1."NS_Unit Of Measure" := "Unit of Measure Code";
                JobReportBuffer1."NS_Actual Cost Qty." := JobReportBuffer1."NS_Actual Cost Qty." + Quantity;
                JobReportBuffer1."NS_Actual Cost" := JobReportBuffer1."NS_Actual Cost" + "Total Cost (LCY)";
                JobReportBuffer1.MODIFY;
            end else begin
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
                JobReportBuffer1."NS_Actual Cost Qty." := Quantity;
                JobReportBuffer1."NS_Unit Of Measure" := "Unit of Measure Code";
                JobReportBuffer1."NS_Actual Cost" := "Total Cost (LCY)";
                JobReportBuffer1.NS_Description := Description;
                JobReportBuffer1."NS_Job Description" := Description;
                JobReportBuffer1."NS_Variant Code" := "Variant Code";
                JobReportBuffer1.NS_Adjustment := '';
                JobReportBuffer1."NS_Record Source" := RecordSource;
                JobReportBuffer1.INSERT;
            end;
        end;
    end;

    procedure MergeSubJobsIntoJobs();
    begin
        //Add the sub-job values into the base job records
        with JobReportBuffer2 do begin
            CopyReportBuffer(JobReportBuffer1, JobReportBuffer2);
            JobReportBuffer1.RESET;
            LastEntryNo := 0;
            if JobReportBuffer1.FINDLAST then
                LastEntryNo := JobReportBuffer1."NS_Entry No.";

            RESET;
            SETCURRENTKEY("NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", NS_Category, NS_Type, "NS_No.", "NS_Variant Code", NS_Adjustment);
            SETRANGE("NS_Record Source", "NS_Record Source"::SubJob);
            if FINDSET then
                repeat
                    JobReportBuffer1.RESET;
                    JobReportBuffer1.SETCURRENTKEY("NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", NS_Category, NS_Type, "NS_No.", "NS_Variant Code", NS_Adjustment);
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
                    if JobReportBuffer1.FINDSET then begin
                        JobReportBuffer1."NS_Budgeted Cost Qty." := JobReportBuffer1."NS_Budgeted Cost Qty." + "NS_Budgeted Cost Qty.";
                        JobReportBuffer1."NS_Actual Cost Qty." := JobReportBuffer1."NS_Actual Cost Qty." + "NS_Actual Cost Qty.";
                        JobReportBuffer1."NS_Budgeted Cost" := JobReportBuffer1."NS_Budgeted Cost" + "NS_Budgeted Cost";
                        JobReportBuffer1."NS_Actual Cost" := JobReportBuffer1."NS_Actual Cost" + "NS_Actual Cost";
                        JobReportBuffer1.MODIFY;
                    end else begin
                        CopyBufferRecord(JobReportBuffer2, JobReportBuffer1);
                        LastEntryNo := LastEntryNo + 1;
                        JobReportBuffer1."NS_Entry No." := LastEntryNo;
                        JobReportBuffer1."NS_Record Source" := JobReportBuffer1."NS_Record Source"::Job;
                        JobReportBuffer1."NS_Job No." := JobRec."NS_Sub-Level to Job No.";  //Change the Job No. to the main no.

                        JobReportBuffer1.INSERT;
                    end;
                until NEXT = 0;
        end;
    end;

    procedure CopyReportBuffer(var FromBuffer: Record "NS_Job Report Buffer"; var ToBuffer: Record "NS_Job Report Buffer");
    begin
        //Duplicate the JobReportBuffer
        with FromBuffer do begin
            ToBuffer.RESET;
            ToBuffer.DELETEALL;

            RESET;
            if FINDSET then
                repeat
                    CopyBufferRecord(FromBuffer, ToBuffer);
                    ToBuffer.INSERT;
                until NEXT = 0;
        end;
    end;

    procedure CopyBufferRecord(RecordIn: Record "NS_Job Report Buffer"; var RecordOut: Record "NS_Job Report Buffer");
    begin
        with RecordIn do begin
            RecordOut.INIT;
            RecordOut."NS_Entry No." := "NS_Entry No.";
            RecordOut."NS_Job No." := "NS_Job No.";
            RecordOut."NS_Entry Type" := "NS_Entry Type";
            RecordOut."NS_Job Task No." := "NS_Job Task No.";
            RecordOut."NS_Activity Code" := "NS_Activity Code";
            RecordOut."NS_Process Code" := "NS_Process Code";
            RecordOut."NS_Operation Code" := "NS_Operation Code";
            RecordOut."NS_Section Code" := "NS_Section Code";//PRJ-688.AM.1.0
            RecordOut.NS_Category := NS_Category;
            RecordOut.NS_Type := NS_Type;
            RecordOut."NS_No." := "NS_No.";
            RecordOut."NS_Actual Cost Qty." := "NS_Actual Cost Qty.";
            RecordOut."NS_Budgeted Cost Qty." := "NS_Budgeted Cost Qty.";
            RecordOut."NS_Unit Of Measure" := "NS_Unit Of Measure";
            RecordOut."NS_Actual Cost" := "NS_Actual Cost";
            RecordOut."NS_Budgeted Cost" := "NS_Budgeted Cost";
            RecordOut.NS_Description := NS_Description;
            RecordOut."NS_Job Description" := "NS_Job Description";
            RecordOut."NS_Variant Code" := "NS_Variant Code";
            RecordOut.NS_Adjustment := NS_Adjustment;
            RecordOut."NS_Record Source" := "NS_Record Source";
        end;
    end;

    procedure CheckForJobOrAPOBreak();
    begin
        with JobReportBuffer1 do begin
            //
            //If Activity break
            //
            if ("NS_Activity Code" <> ActivityCodeHold) or
               ("NS_Job No." <> JobNoHold) then begin
                //Add to Actual and Budget Process Quantity and Costs
                AccumulateAPOTotals(JobReportBuffer2, 0, "NS_Job No.", "NS_Activity Code", '', '', '', APOTotals);//PRJ-688.AM.1.0

                if not JobActivity.GET(JobActivity.NS_Type::Cost, "NS_Activity Code") then
                    //    JobActivity.NS_Description := Unknown;//PRJ-437.AS.1.0 Comment
                    JobActivity.NS_Description := "NS_Description";//PRJ-437.AS.1.0 Added

                //Set current code and hold codes
                JobNoHold := "NS_Job No.";
                ActivityCode := "NS_Activity Code";
                ActivityCodeHold := "NS_Activity Code";
                ProcessCodeHold := '';  //Force a Process Code break
            end;

            //
            //If Process break
            //
            if "NS_Process Code" <> ProcessCodeHold then begin
                //Add to Actual and Budget Process Quantity and Costs
                AccumulateAPOTotals(JobReportBuffer2, 0, "NS_Job No.", "NS_Activity Code", "NS_Process Code", '', '', APOTotals);//PRJ-688.AM.1.0

                if not JobProcess.GET(JobProcess.NS_Type::Cost, "NS_Activity Code", "NS_Process Code") then
                    //JobProcess.NS_Description := Unknown;//PRJ-437.AS.1.0 Comment
                JobProcess.NS_Description := JobActivity.NS_Description;//PRJ-437.AS.1.0 Added

                //Set current code and hold codes
                ProcessCode := "NS_Process Code";
                ProcessCodeHold := "NS_Process Code";
                OperationCodeHold := '';  //Force an Operation Code break
            end;

            //
            //If Operation break
            //
            if "NS_Operation Code" <> OperationCodeHold then begin
                //Add to Actual and Budget Operation Quantity and Costs
                AccumulateAPOTotals(JobReportBuffer2, 0, "NS_Job No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", '', APOTotals);//PRJ-688.AM.1.0

                if not JobOperation.GET(JobOperation.NS_Type::Cost, "NS_Activity Code", "NS_Process Code", "NS_Operation Code") then
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
                AccumulateAPOTotals(JobReportBuffer2, 0, "NS_Job No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code", APOTotals);//PRJ-688.AM.1.0

                if not JobSection.GET(JobSection.NS_Type::Cost, "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code") then
                    if "NS_Section Code" <> '' then
                        JobSection.NS_Description := JobOperation.NS_Description
                    else
                        JobSection.NS_Description := JobProcess.NS_Description;

                //Set current code and hold code
                SectionCode := "NS_Section Code";
                SectionCodeHold := "NS_Section Code";
            end;
            //PRJ-688.AM.1.0
        end;
    end;

    procedure AccumulateAPOTotals(var JobReportBufferIn: Record "NS_Job Report Buffer"; EntryNo: Integer; Job: Code[20]; Activity: Code[20]; Process: Code[20]; Operation: Code[20]; Section: code[20]; var APOTotals: array[12] of Decimal);//PRJ-688.AM.1.0
    begin
        //Accumulate a summary of totals for each Activity Process and Operation of Budgeted and Actual Quantitys and Costs from JobReportBufferIn

        //APOTotals is an arrays of 8 items.  Each set of two are Activity, Process and Operation.
        //  Within each set of two are totals of Budget Cost and Actual Cost
        //  i.e. item six is the Operation portion of Actual Cost
        //
        //If the EntryNo passed in is greater that zero, then only values in array 7 & 8 are returned with the values for that EntryNo
        //  This is used for the values in the detail lines

        CLEAR(APOTotals);

        with JobReportBufferIn do begin
            RESET;
            if EntryNo > 0 then
                SETRANGE("NS_Entry No.", EntryNo)
            else
                if Job > '' then begin
                    SETCURRENTKEY("NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", NS_Category, NS_Type, "NS_No.", "NS_Variant Code", NS_Adjustment);
                    SETRANGE("NS_Job No.", Job);
                    SETRANGE("NS_Activity Code", Activity);
                    SETRANGE("NS_Process Code", Process);
                    SETRANGE("NS_Operation Code", Operation);
                    SetRange("NS_Section Code", Section);//PRJ-688.AM.1.0
                end;
            if FINDSET then
                repeat
                    if EntryNo = 0 then begin
                        if "NS_Activity Code" > '' then begin
                            APOTotals[1] := APOTotals[1] + "NS_Budgeted Cost";
                            APOTotals[2] := APOTotals[2] + "NS_Actual Cost";
                            if "NS_Process Code" > '' then begin
                                APOTotals[3] := APOTotals[3] + "NS_Budgeted Cost";
                                APOTotals[4] := APOTotals[4] + "NS_Actual Cost";
                                if "NS_Operation Code" > '' then begin
                                    APOTotals[5] := APOTotals[5] + "NS_Budgeted Cost";
                                    APOTotals[6] := APOTotals[6] + "NS_Actual Cost";
                                    if "NS_Section Code" > '' then begin //PRJ-688.AM.1.0
                                        APOTotals[7] := APOTotals[7] + "NS_Budgeted Cost";
                                        APOTotals[8] := APOTotals[8] + "NS_Actual Cost";
                                    end//PRJ-688.AM.1.0
                                end;//PRJ-688.AM.1.0

                            end;
                        end;
                    end else begin
                        APOTotals[9] := APOTotals[9] + "NS_Budgeted Cost";//PRJ-688.AM.1.0
                        APOTotals[10] := APOTotals[10] + "NS_Actual Cost";//PRJ-688.AM.1.0
                    end;
                until NEXT = 0;
            RESET;
        end;
    end;

    procedure GetActualPOCodesToUse(ProcessCodeIn: Code[10];
            OperationCodeIn: Code[10];
            SectionCodeIn: Code[10]; var
                                         ProcessCodeOut: Code[10];

    var
        OperationCodeOut: Code[10];

    var
        SectionCodeOut: Code[10]);//PRJ-688.AM.1.0
    begin
        //This routine either passes incoming Process and Operation codes back out or returns empty strings
        //     depending on if the processes or operations are to be shown.

        if ShowProcesses then
            ProcessCodeOut := ProcessCodeIn
        else
            ProcessCodeOut := '';

        if ShowOperations then
            OperationCodeOut := OperationCodeIn
        else
            OperationCodeOut := '';
        //PRJ-688.AM.1.0
        if Showsections then
            SectionCodeOut := SectionCodeIn
        else
            SectionCodeOut := '';
        //PRJ-688.AM.1.0
    end;

    procedure GetBalReq(PassPurchLine: Record "Purchase Line"; var RetCommQty: Decimal; var RetCommCost: Decimal);
    var
        JMP: Record "NS_Job Material Planning";
        Item: Record Item;
    begin
        JMP.RESET;
        JMP.SETRANGE("NS_Part No.", PassPurchLine."No.");
        JMP.SETRANGE("NS_Worksheet Job No.", PassPurchLine."Job No.");
        JMP.SETRANGE("NS_Document No.", PassPurchLine."NS_JMP Document No.");
        JMP.SETRANGE("NS_Order Code", PassPurchLine."Job Task No.");
        if JMP.FINDFIRST then begin
            RetCommQty := JMP."NS_Bal. Req";
            Item.GET(JMP."NS_Part No.");
            RetCommCost := Item."Unit Cost" * RetCommQty;
        end else begin
            RetCommQty := 0;
            RetCommCost := 0;
        end;
    end;

    procedure SetJobNoFilter(PassJobNum: Code[20]);
    begin
        JobNumFilter := PassJobNum
    end;

    procedure SetDetailLevel(PassCompleteJob: Boolean; PassSubDetail: Boolean; PassAllDetail: Boolean);
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
}

