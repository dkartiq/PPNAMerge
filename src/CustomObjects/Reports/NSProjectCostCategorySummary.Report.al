//PRJCTPR-399.PP.1.0 09JUL2024 | Newly Created this report. 
report 14021426 "NS_ProjectCostCategorySummary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSJob Cost Category Summary1.rdl';
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Project Cost Category Summary';
    ApplicationArea = All;

    dataset
    {
        dataitem(Job; Job)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Bill-to Customer No.", "NS_Date Filter", Status;
            column(Master_Job_No; "No.") { }
            column(WorkOrderDate; Workdate)
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name) { }
            column(Sub_LevelsText; "Sub-LevelsText") { }
            column(JobFilters; JobFilters) { }

            dataitem("Job Planning Line"; "Job Planning Line")
            {
                DataItemLink = "Job No." = FIELD("No.");
                DataItemTableView = SORTING("Job No.", "Job Task No.", "Line No.") order(Ascending);
                trigger OnPreDataItem()  //Job Planning Line
                begin
                    SETFILTER("Job No.", Job."No.");
                    SETFILTER("NS_Entry Type", '%1|%2', "NS_Entry Type"::Cost, "NS_Entry Type"::Both);
                    SETFILTER("Job Task No.", Job.GETFILTER("NS_Job Task No. Filter"));
                    SETFILTER(Type, Job.GETFILTER("NS_TypeEnumFilter"));
                    SETFILTER("Planning Date", Job.GETFILTER("NS_Date Filter"));
                End;

                trigger OnAfterGetRecord() //Job Planning Line
                begin
                    SendJobBudgetsToBuffer("Job Planning Line", JobReportBuffer1."NS_Record Source"::Job);
                end;
            }

            dataitem("Job Ledger Entry"; "Job Ledger Entry")
            {
                DataItemLink = "Job No." = FIELD("No.");
                DataItemTableView = SORTING("Job No.", "Job Task No.", "Entry Type", "Posting Date") order(Ascending);
                trigger OnPreDataItem() //Job Ledger Entry
                begin
                    SETFILTER("Job No.", Job."No.");
                    SETFILTER("Entry Type", FORMAT("Entry Type"::Usage));
                    SETFILTER("Job Task No.", Job.GETFILTER("NS_Job Task No. Filter"));
                    SETFILTER("Posting Date", Job.GETFILTER("NS_Date Filter"));
                    SETFILTER(Type, Job.GETFILTER("NS_TypeEnumFilter"));
                end;

                trigger OnAfterGetRecord()  //Job Ledger Entry
                begin
                    SendJobLedgerToBuffer("Job Ledger Entry", JobReportBuffer1."NS_Record Source"::Job);
                end;
            }
            dataitem("Sub-Levels"; Job)
            {
                DataItemLink = "NS_Sub-Level to Job No." = FIELD("No.");
                DataItemTableView = SORTING("No.");
                dataitem("Job Planning Line Sub-Levels"; "Job Planning Line")
                {
                    DataItemLink = "Job No." = FIELD("No.");
                    DataItemTableView = SORTING("Job No.", "Job Task No.", "Line No.") order(Ascending);
                    trigger OnPreDataItem(); //JPL Sub-Level - Job
                    begin
                        SETFILTER("NS_Entry Type", '%1|%2', "NS_Entry Type"::Cost, "NS_Entry Type"::Both);
                        SETFILTER(Type, Job.GETFILTER("NS_TypeEnumFilter"));
                        SETFILTER("Planning Date", Job.GETFILTER("NS_Date Filter"));
                        SETFILTER("Job Task No.", Job.GETFILTER("NS_Job Task No. Filter"));
                    end;

                    trigger OnAfterGetRecord(); //JPL Sub-Level - Job
                    begin
                        SendJobBudgetsToBuffer("Job Planning Line Sub-Levels", JobReportBuffer1."NS_Record Source"::SubJob);
                    end;
                }
                dataitem("Job Ledger Entry Sub-Levels"; "Job Ledger Entry")
                {
                    DataItemLink = "Job No." = FIELD("No.");
                    DataItemTableView = SORTING("Job No.", "Job Task No.", "Entry Type", "Posting Date");
                    trigger OnAfterGetRecord(); //JLE Sub-Level - Job
                    begin
                        SendJobLedgerToBuffer("Job Ledger Entry Sub-Levels", JobReportBuffer1."NS_Record Source"::SubJob);
                    end;

                    trigger OnPreDataItem(); //JLE Sub-Level - Job
                    begin
                        //Get sub-job Job Ledger Entries into the buffer
                        SETFILTER("Job Task No.", Job.GETFILTER("NS_Job Task No. Filter"));
                        SETFILTER("Entry Type", FORMAT("Entry Type"::Usage));
                        SETFILTER("Posting Date", Job.GETFILTER("NS_Date Filter"));
                        SETFILTER(Type, Job.GETFILTER("NS_TypeEnumFilter"));
                    end;
                }

                trigger OnPreDataItem(); // job - Sub level
                begin
                    if (not "IncludeSubLevels") and (not "ShowSubLevels") then
                        CurrReport.BREAK;
                end;
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemTableView = SORTING("Job No.") ORDER(Ascending);
                trigger OnAfterGetRecord()
                begin
                    SendPurchaseLinesIntoBuffer("Purchase Line");
                end;

                trigger OnPreDataItem();
                begin
                    RESET;
                    SETCURRENTKEY("Job No.");
                    SETRANGE("Job No.", Job."No.");
                end;
            }

            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number);
                MaxIteration = 1;
                column(JobNoLbl; 'Job No.')
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
                            column(Job_No; JobReportBuffer1."NS_Job No.")
                            {
                            }
                            column(EntryType; JobReportBuffer1."NS_Entry Type")
                            {
                            }
                            column(Category; JobReportBuffer1."NS_Category")
                            {
                            }
                            column(Budgeted_Cost; JobReportBuffer1."NS_Budgeted Cost")
                            {
                            }
                            column(VariantCode; JobReportBuffer1."NS_Variant Code")
                            {
                            }
                            column(RecordSource; JobReportBuffer1."NS_Record Source")
                            {
                            }
                            column(Actual_Cost; JobReportBuffer1."NS_Actual Cost")
                            {
                            }
                            column(Job_Name; JobRec.Description)
                            {
                            }
                            column(Committed_Amount; JobReportBuffer1."NS_Committed Amount") { }
                            trigger OnPreDataItem();
                            begin
                                if NumBudgetLines = 0 then
                                    CurrReport.BREAK;

                                JobDetail.SETRANGE(Number, 1, NumBudgetLines);

                            end;

                            trigger OnAfterGetRecord();
                            begin

                                if JobDetail.Number > 1 then
                                    JobReportBuffer1.NEXT();
                                if JobRec.GET(JobReportBuffer1."NS_Job No.") then;
                            end;
                        }
                        trigger OnPreDataItem();
                        begin
                            JobReportBuffer1.RESET();
                            JobReportBuffer1.SETCURRENTKEY("NS_Record Source");
                            JobReportBuffer1.SETRANGE("NS_Record Source", RecordSource);
                            NumBudgetLines := JobReportBuffer1.COUNT;
                            if NumBudgetLines > 0 then begin
                                JobReportBuffer1.FINDSET();
                                JobAndSubJob.SETRANGE(Number, 1);
                            end else
                                CurrReport.BREAK();
                        end;
                    }

                    trigger OnPreDataItem();
                    begin
                        SETRANGE(Number, 1, 2);
                    end;

                    trigger OnAfterGetRecord();
                    begin
                        case Number of
                            1:
                                RecordSource := RecordSource::Job;
                            2:
                                if "ShowSubLevels" then
                                    RecordSource := RecordSource::SubJob
                                else
                                    CurrReport.SKIP;
                        end;
                    end;
                }

                trigger OnPreDataItem();  //JobAnalysisBuffer1Loop - Integer
                begin
                    JobReportBuffer1.RESET;

                    if JobReportBuffer1.COUNT = 0 then
                        ERROR(NoDataErrorMessage);

                    if "IncludeSubLevels" then
                        MergeSubJobsIntoJobs;

                    CopyReportBuffer(JobReportBuffer1, JobReportBuffer2);
                end;
            }

            trigger OnPreDataItem();  //Job
            begin
                if CompanyInformation.GET then;

                if job.GetFilter("No.") = '' then
                    Error('Job No. should not be blank.');

                if COUNT = 0 then
                    Error(NoDataErrorMessage);

                JobFilters := Job.GETFILTERS;

                if "IncludeSubLevels" then
                    "Sub-LevelsText" := 'Sub-Levels are included in Projects'
                else
                    "Sub-LevelsText" := 'Sub-Levels are not included in Projects';

                JobHold := Job;
                JobHold.CopyFilters(Job);
                "MarkSub-Levels"(Job, IncludeSubLevels);
                FilterGroup(10);
                CopyFilters(JobHold);
                SetRange("No.");
                FilterGroup(0);

                if JobsSetup.Get() then;
            end;

            trigger OnAfterGetRecord();  //Job
            var
                Position: Integer;
            begin
                Position := STRPOS(Job."No.", JobsSetup."NS_Job No. Separators");
                if Position > 0 then begin
                    if Job."No." <> JobHold.GETFILTER("No.") then
                        CurrReport.SKIP;
                end;

                JobReportBuffer1.RESET;
                JobReportBuffer1.DELETEALL;
                JobReportBuffer2.RESET;
                JobReportBuffer2.DELETEALL;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field("Include Sub-Levels"; "IncludeSubLevels")
                    {
                        Caption = 'Include Change Orders';
                        ApplicationArea = All;
                    }
                    field("Show Sub-Levels"; "ShowSubLevels")
                    {
                        Caption = 'Show Change Orders';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    var
        JobHold: Record Job;
        IncludeSubLevels: Boolean;
        ShowSubLevels: Boolean;
        NoDataErrorMessage: Label 'There is no information to show as requested.';
        JobReportBuffer1: Record "NS_Job Report Buffer" temporary;
        JobReportBuffer2: Record "NS_Job Report Buffer" temporary;
        LastEntryNo: Integer;
        NumBudgetLines: Integer;
        JobNoHold: Code[20];
        JobNo: Code[20];
        RecordSource: Option Job,SubJob;
        JobsSetup: Record "Jobs Setup";
        JobRec: Record job;
        CompanyInformation: Record "Company Information";
        "Sub-LevelsText": Text[100];
        JobFilters: Text[250];

    procedure SendJobBudgetsToBuffer(JobPlanningLine: Record "Job Planning Line"; RecordSource: Option Job,SubJob)
    begin
        if (JobPlanningLine.Type = JobPlanningLine.Type::Text) then
            exit;

        JobReportBuffer1.RESET();
        JobReportBuffer1.SETCURRENTKEY("NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", NS_Category, NS_Type, "NS_No.", "NS_Variant Code", NS_Adjustment);
        JobReportBuffer1.SETRANGE("NS_Job No.", JobPlanningLine."Job No.");
        JobReportBuffer1.SETRANGE("NS_Entry Type", JobReportBuffer1."NS_Entry Type"::Cost);
        JobReportBuffer1.SETRANGE(NS_Category, JobPlanningLine."NS_Cost Category");
        if JobReportBuffer1.FINDSET() then begin
            JobReportBuffer1."NS_Budgeted Cost" := JobReportBuffer1."NS_Budgeted Cost" + JobPlanningLine."Total Cost";
            JobReportBuffer1.MODIFY();
        end else begin
            JobReportBuffer1.INIT();
            LastEntryNo := LastEntryNo + 1;
            JobReportBuffer1."NS_Entry No." := LastEntryNo;
            JobReportBuffer1."NS_Job No." := JobPlanningLine."Job No.";
            JobReportBuffer1."NS_Entry Type" := JobReportBuffer1."NS_Entry Type"::Cost;
            JobReportBuffer1.NS_Category := JobPlanningLine."NS_Cost Category";
            JobReportBuffer1."NS_Budgeted Cost" := JobPlanningLine."Total Cost";
            JobReportBuffer1."NS_Variant Code" := JobPlanningLine."Variant Code"; //NS_Operation Code
            JobReportBuffer1."NS_Record Source" := RecordSource;
            JobReportBuffer1.INSERT();
        end;
    end;

    procedure SendJobLedgerToBuffer(JobLedgerEntry: Record "Job Ledger Entry"; RecordSource: Option Job,SubJob)
    begin

        if JobLedgerEntry."Entry Type" <> JobLedgerEntry."Entry Type"::Usage then
            exit;

        JobReportBuffer1.RESET();
        JobReportBuffer1.SETCURRENTKEY("NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", NS_Category, NS_Type, "NS_No.", "NS_Variant Code", NS_Adjustment);
        JobReportBuffer1.SETRANGE("NS_Job No.", JobLedgerEntry."Job No.");
        JobReportBuffer1.SETRANGE("NS_Entry Type", JobReportBuffer1."NS_Entry Type"::Cost);
        JobReportBuffer1.SETRANGE(NS_Category, JobLedgerEntry."NS_Job Cost Category");
        if JobReportBuffer1.FINDSET() then begin
            JobReportBuffer1."NS_Actual Cost" := JobReportBuffer1."NS_Actual Cost" + JobLedgerEntry."Total Cost (LCY)";
            JobReportBuffer1.MODIFY();
        end else begin
            JobReportBuffer1.INIT();
            LastEntryNo := LastEntryNo + 1;
            JobReportBuffer1."NS_Entry No." := LastEntryNo;
            JobReportBuffer1."NS_Job No." := JobLedgerEntry."Job No.";
            JobReportBuffer1."NS_Entry Type" := JobReportBuffer1."NS_Entry Type"::Cost;
            JobReportBuffer1.NS_Category := JobLedgerEntry."NS_Job Cost Category";
            JobReportBuffer1."NS_Actual Cost" := JobLedgerEntry."Total Cost (LCY)";
            JobReportBuffer1."NS_Variant Code" := JobLedgerEntry."Variant Code"; //NS_Operation Code
            JobReportBuffer1."NS_Record Source" := RecordSource;
            JobReportBuffer1.INSERT();
        end;
    end;

    procedure SendPurchaseLinesIntoBuffer(PurchaseLine: Record "Purchase Line")
    begin
        JobReportBuffer1.RESET;
        JobReportBuffer1.SETCURRENTKEY("NS_Job No.", "NS_Entry Type", NS_Type, "NS_No.", "NS_Variant Code", "NS_Job Task No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", NS_Category, NS_Adjustment);
        JobReportBuffer1.SETRANGE("NS_Job No.", Job."No.");
        JobReportBuffer1.SETRANGE("NS_Entry Type", JobReportBuffer1."NS_Entry Type"::Cost);
        JobReportBuffer1.SETRANGE(NS_Category, PurchaseLine."NS_Job Cost Category");
        if JobReportBuffer1.FINDSET then begin
            JobReportBuffer1."NS_Committed Amount" := JobReportBuffer1."NS_Committed Amount" + PurchaseLine."NS_Committed Amount";
            JobReportBuffer1.MODIFY;
        end else begin
            JobReportBuffer1.INIT;
            LastEntryNo := LastEntryNo + 1;
            JobReportBuffer1."NS_Entry No." := LastEntryNo;
            JobReportBuffer1."NS_Job No." := Job."No.";
            JobReportBuffer1."NS_Entry Type" := JobReportBuffer1."NS_Entry Type"::Cost;
            JobReportBuffer1.NS_Category := PurchaseLine."NS_Job Cost Category";
            JobReportBuffer1."NS_Committed Amount" := PurchaseLine."NS_Committed Amount";
            JobReportBuffer1."NS_Variant Code" := PurchaseLine."Variant Code";
            JobReportBuffer1.INSERT;
        end;
    end;

    procedure MergeSubJobsIntoJobs();
    begin
        CopyReportBuffer(JobReportBuffer1, JobReportBuffer2);
        JobReportBuffer1.RESET();
        LastEntryNo := 0;
        if JobReportBuffer1.FINDLAST() then
            LastEntryNo := JobReportBuffer1."NS_Entry No.";

        JobReportBuffer2.RESET();
        JobReportBuffer2.SETCURRENTKEY("NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", NS_Category, NS_Type, "NS_No.", "NS_Variant Code", NS_Adjustment);
        JobReportBuffer2.SETRANGE("NS_Record Source", JobReportBuffer2."NS_Record Source"::SubJob);
        if JobReportBuffer2.FINDSET() then
            repeat
                JobReportBuffer1.RESET();
                JobReportBuffer1.SETCURRENTKEY("NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", NS_Category, NS_Type, "NS_No.", "NS_Variant Code", NS_Adjustment);
                JobRec.GET(JobReportBuffer2."NS_Job No.");
                JobReportBuffer1.SETRANGE("NS_Job No.", JobRec."NS_Sub-Level to Job No.");
                JobReportBuffer1.SETRANGE("NS_Entry Type", JobReportBuffer2."NS_Entry Type"::Cost);
                JobReportBuffer1.SETRANGE(NS_Category, JobReportBuffer2.NS_Category);
                JobReportBuffer1.SETRANGE("NS_Record Source", JobReportBuffer1."NS_Record Source"::Job);
                if JobReportBuffer1.FINDSET() then begin
                    JobReportBuffer1."NS_Budgeted Cost" := JobReportBuffer1."NS_Budgeted Cost" + JobReportBuffer2."NS_Budgeted Cost";
                    JobReportBuffer1."NS_Actual Cost" := JobReportBuffer1."NS_Actual Cost" + JobReportBuffer2."NS_Actual Cost";
                    JobReportBuffer1."NS_Actual Price" := JobReportBuffer1."NS_Actual Price" + JobReportBuffer2."NS_Actual Price";
                    JobReportBuffer1.MODIFY();
                end else begin
                    CopyBufferRecord(JobReportBuffer2, JobReportBuffer1);
                    LastEntryNo := LastEntryNo + 1;
                    JobReportBuffer1."NS_Entry No." := LastEntryNo;
                    JobReportBuffer1."NS_Record Source" := JobReportBuffer1."NS_Record Source"::Job;
                    JobReportBuffer1."NS_Job No." := JobRec."NS_Sub-Level to Job No.";
                    JobReportBuffer1.INSERT();
                end;
            until JobReportBuffer2.NEXT() = 0;
    end;

    procedure CopyReportBuffer(var FromBuffer: Record "NS_Job Report Buffer"; var ToBuffer: Record "NS_Job Report Buffer");
    begin
        ToBuffer.RESET();
        ToBuffer.DELETEALL();

        FromBuffer.RESET();
        if FromBuffer.FINDSET() then
            repeat
                CopyBufferRecord(FromBuffer, ToBuffer);
                ToBuffer.INSERT();
            until FromBuffer.NEXT() = 0;
    end;

    procedure CopyBufferRecord(RecordIn: Record "NS_Job Report Buffer"; var RecordOut: Record "NS_Job Report Buffer");
    begin
        RecordOut.INIT();
        RecordOut."NS_Entry No." := RecordIn."NS_Entry No.";
        RecordOut."NS_Job No." := RecordIn."NS_Job No.";
        RecordOut."NS_Entry Type" := RecordIn."NS_Entry Type";
        RecordOut.NS_Category := RecordIn.NS_Category;
        RecordOut."NS_Actual Cost" := RecordIn."NS_Actual Cost";
        RecordOut."NS_Budgeted Cost" := RecordIn."NS_Budgeted Cost";
        RecordOut."NS_Record Source" := RecordIn."NS_Record Source";
    end;

}
