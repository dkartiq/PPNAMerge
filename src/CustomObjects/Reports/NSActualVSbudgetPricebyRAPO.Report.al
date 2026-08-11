report 14021155 "NS_Actual vs BudgetPricebyRAPO"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-84.SK.1.0 Added report to search
    //PRJ-432.AM.1.0 11NOV2020 | Added RequestFilterfields property ,applied date range on report and layout changes
    //PRJ-811.AS.1.0 Action commented report not needed anymore
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSActual vs Budget Price by RAPO.rdl';
    ObsoleteReason = 'This report will not be release anymore';
    ObsoleteState = Pending;

    Caption = 'Actual vs Budget Price by RAPO';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(Job; Job)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Bill-to Customer No.", "NS_Date Filter", Status;
            column(Job_No_; "No.")
            {
            }
            //PRJ-432.AM.1.0 start
            column(ReportTitle; ReportTitle)
            {

            }
            column(JobDateFilter; Job.FIELDCAPTION("NS_Date Filter") + ': ' + job.GetFilter("NS_Date Filter"))
            {

            }
            //PRJ-432.AM.1.0 end
            dataitem("Job Planning Line"; "Job Planning Line")
            {
                DataItemLink = "Job No." = FIELD("No.");
                DataItemTableView = SORTING("Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Cost Category", Type, "No.", "Variant Code") ORDER(Ascending);

                RequestFilterFields = "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Cost Category";//PRJ-432.AM.1.0
                trigger OnAfterGetRecord();
                begin
                    if Type = Type::Text then
                        CurrReport.SKIP;
                    SetProcessOperation("NS_Process Code", "NS_Operation Code", IncomingProcessCode, IncomingOperationCode);

                    if not JobAnalysisBuffer.GET(Job."No.", JobAnalysisBuffer."NS_Entry Type"::Price,
                                                 "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                                 "NS_Cost Category", Type, "No.", "Variant Code", NS_Adjustment) then begin

                        JobAnalysisBuffer.INIT;
                        JobAnalysisBuffer."NS_Job No." := Job."No.";
                        JobAnalysisBuffer."NS_Entry Type" := JobAnalysisBuffer."NS_Entry Type"::Price;
                        JobAnalysisBuffer."NS_Activity Code" := "NS_Activity Code";
                        JobAnalysisBuffer."NS_Process Code" := "NS_Process Code";
                        JobAnalysisBuffer."NS_Operation Code" := "NS_Operation Code";
                        if Type = Type::"NS_Resource (Group)" then
                            JobAnalysisBuffer.NS_Type := JobAnalysisBuffer.NS_Type::"Group (Resource)"
                        else
                            JobAnalysisBuffer.NS_Type := Type;
                        JobAnalysisBuffer.NS_Category := "NS_Cost Category";
                        JobAnalysisBuffer."NS_No." := "No.";
                        JobAnalysisBuffer.NS_Description := Description;
                        JobAnalysisBuffer."NS_Variant Code" := "Variant Code";
                        JobAnalysisBuffer.NS_Adjustment := NS_Adjustment;
                        JobAnalysisBuffer."NS_Budgeted Price" := "Total Price";
                        JobAnalysisBuffer.INSERT
                    end else begin
                        JobAnalysisBuffer."NS_Budgeted Price" := JobAnalysisBuffer."NS_Budgeted Price" + "Total Price";
                        JobAnalysisBuffer.MODIFY;
                    end;
                end;

                trigger OnPreDataItem();
                begin
                    if (Job."NS_Sub-Level to Job No." > '') and "ShowSub-Levels" then
                        CurrReport.SKIP;

                    SETFILTER("NS_Entry Type", '%1|%2', "NS_Entry Type"::Price, "NS_Entry Type"::Both);
                    SETFILTER("NS_Activity Code", Job.GETFILTER("NS_Activity Filter"));
                    SETFILTER("NS_Process Code", Job.GETFILTER("NS_Process Filter"));
                    SETFILTER("NS_Operation Code", Job.GETFILTER("NS_Operation Filter"));
                    SETFILTER(Type, Job.GETFILTER("NS_Type Filter"));
                    SETFILTER("Planning Date", Job.GETFILTER("NS_Date Filter"));
                end;
            }
            dataitem("Job Ledger Entry"; "Job Ledger Entry")
            {
                DataItemLink = "Job No." = FIELD("No.");
                DataItemTableView = SORTING("Job No.", "Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Job Cost Category", "NS_Job Revenue Category", Type, "No.", "Resource Group No.", "Posting Date") ORDER(Ascending);

                trigger OnAfterGetRecord();
                begin
                    if not JobAnalysisBuffer.GET("Job No.", JobAnalysisBuffer."NS_Entry Type"::Price,
                                                 "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                                 "NS_Job Revenue Category", Type, "No.", "Variant Code", '') then begin
                        JobAnalysisBuffer.INIT;
                        JobAnalysisBuffer."NS_Job No." := "Job No.";
                        JobAnalysisBuffer."NS_Entry Type" := JobAnalysisBuffer."NS_Entry Type"::Price;
                        JobAnalysisBuffer."NS_Activity Code" := "NS_Activity Code";
                        JobAnalysisBuffer."NS_Process Code" := "NS_Process Code";
                        JobAnalysisBuffer."NS_Operation Code" := "NS_Operation Code";
                        JobAnalysisBuffer.NS_Category := "NS_Job Revenue Category";
                        JobAnalysisBuffer.NS_Type := Type;
                        JobAnalysisBuffer."NS_No." := "No.";
                        JobAnalysisBuffer."NS_Actual Price" := -"Total Price (LCY)";
                        JobAnalysisBuffer.NS_Description := Description;
                        JobAnalysisBuffer."NS_Variant Code" := "Variant Code";
                        JobAnalysisBuffer.NS_Adjustment := '';
                        JobAnalysisBuffer.INSERT;
                    end else begin
                        JobAnalysisBuffer."NS_Actual Price" := JobAnalysisBuffer."NS_Actual Price" - "Total Price (LCY)";
                        JobAnalysisBuffer.MODIFY;
                    end;
                end;

                trigger OnPreDataItem();
                begin
                    SETRANGE("Entry Type", "Entry Type"::Sale);
                    SETFILTER("NS_Activity Code", Job.GETFILTER("NS_Activity Filter"));
                    SETFILTER("NS_Process Code", Job.GETFILTER("NS_Process Filter"));
                    SETFILTER("NS_Operation Code", Job.GETFILTER("NS_Operation Filter"));

                    SETFILTER(Type, Job.GETFILTER("NS_Type Filter"));
                    SETFILTER("Posting Date", Job.GETFILTER("NS_Date Filter"));
                end;
            }
            dataitem("Sub-Levels"; Job)
            {
                DataItemLink = "NS_Sub-Level to Job No." = FIELD("No.");
                DataItemTableView = SORTING("No.");
                dataitem("Job Planning Line Sub-Levels"; "Job Planning Line")
                {
                    DataItemLink = "Job No." = FIELD("No.");
                    DataItemTableView = SORTING("Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Cost Category", Type, "No.", "Variant Code") ORDER(Ascending);

                    trigger OnAfterGetRecord();
                    begin
                        if Type = Type::Text then
                            CurrReport.SKIP;
                        SetProcessOperation("NS_Process Code", "NS_Operation Code", IncomingProcessCode, IncomingOperationCode);
                        if not JobAnalysisBuffer.GET(Job."No.", JobAnalysisBuffer."NS_Entry Type"::Price,
                                                     "NS_Activity Code", IncomingProcessCode, IncomingOperationCode,
                                                    "NS_Cost Category", Type, "No.", "Variant Code", NS_Adjustment) then begin
                            JobAnalysisBuffer.INIT;
                            JobAnalysisBuffer."NS_Job No." := Job."No.";
                            JobAnalysisBuffer."NS_Entry Type" := JobAnalysisBuffer."NS_Entry Type"::Price;
                            JobAnalysisBuffer."NS_Activity Code" := "NS_Activity Code";
                            JobAnalysisBuffer."NS_Process Code" := IncomingProcessCode;
                            JobAnalysisBuffer."NS_Operation Code" := IncomingOperationCode;
                            JobAnalysisBuffer.NS_Category := "NS_Cost Category";
                            if Type = Type::"NS_Resource (Group)" then
                                JobAnalysisBuffer.NS_Type := JobAnalysisBuffer.NS_Type::"Group (Resource)"
                            else
                                JobAnalysisBuffer.NS_Type := Type;
                            JobAnalysisBuffer."NS_No." := "No.";
                            JobAnalysisBuffer."NS_Budgeted Price" := "Total Price (LCY)";
                            JobAnalysisBuffer.NS_Description := Description;
                            JobAnalysisBuffer."NS_Variant Code" := "Variant Code";
                            JobAnalysisBuffer.NS_Adjustment := NS_Adjustment;
                            JobAnalysisBuffer.INSERT;
                        end else begin
                            JobAnalysisBuffer."NS_Budgeted Price" := JobAnalysisBuffer."NS_Budgeted Price" + "Total Price (LCY)";
                            JobAnalysisBuffer.MODIFY;
                        end;
                    end;

                    trigger OnPreDataItem();
                    begin
                        SETFILTER("NS_Entry Type", '%1|%2', "NS_Entry Type"::Price, "NS_Entry Type"::Both);
                        SETFILTER("NS_Activity Code", Job.GETFILTER("NS_Activity Filter"));
                        SETFILTER("NS_Process Code", Job.GETFILTER("NS_Process Filter"));
                        SETFILTER("NS_Operation Code", Job.GETFILTER("NS_Operation Filter"));
                        SETFILTER(Type, Job.GETFILTER("NS_Type Filter"));
                        SETFILTER("Planning Date", Job.GETFILTER("NS_Date Filter"));
                    end;
                }
                dataitem("Job Ledger Entry Sub-Levels"; "Job Ledger Entry")
                {
                    DataItemLink = "Job No." = FIELD("No.");
                    DataItemTableView = SORTING("Job No.", "Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Job Cost Category", "NS_Job Revenue Category", Type, "No.", "Resource Group No.", "Posting Date") ORDER(Ascending);

                    trigger OnAfterGetRecord();
                    begin
                        if "ShowSub-Levels" then
                            CurrReport.SKIP;
                        if not JobAnalysisBuffer.GET(Job."No.", JobAnalysisBuffer."NS_Entry Type"::Price,
                                                     "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                                    "NS_Job Revenue Category", Type, "No.", "Variant Code", '') then begin
                            JobAnalysisBuffer.INIT;
                            JobAnalysisBuffer."NS_Job No." := Job."No.";
                            JobAnalysisBuffer."NS_Entry Type" := JobAnalysisBuffer."NS_Entry Type"::Price;
                            JobAnalysisBuffer."NS_Activity Code" := "NS_Activity Code";
                            JobAnalysisBuffer."NS_Process Code" := "NS_Process Code";
                            JobAnalysisBuffer."NS_Operation Code" := "NS_Operation Code";
                            JobAnalysisBuffer.NS_Category := "NS_Job Revenue Category";
                            JobAnalysisBuffer.NS_Type := Type;
                            JobAnalysisBuffer."NS_No." := "No.";
                            JobAnalysisBuffer."NS_Actual Price" := "Total Price (LCY)";
                            JobAnalysisBuffer.NS_Description := Description;
                            JobAnalysisBuffer."NS_Variant Code" := "Variant Code";
                            JobAnalysisBuffer.NS_Adjustment := '';
                            JobAnalysisBuffer.INSERT;
                        end else begin
                            JobAnalysisBuffer."NS_Actual Price" := JobAnalysisBuffer."NS_Actual Price" + "Total Price (LCY)";
                            JobAnalysisBuffer.MODIFY;
                        end;
                    end;

                    trigger OnPreDataItem();
                    begin
                        SETRANGE("Entry Type", "Entry Type"::Sale);
                        SETFILTER("NS_Activity Code", Job.GETFILTER("NS_Activity Filter"));
                        SETFILTER("NS_Process Code", Job.GETFILTER("NS_Process Filter"));
                        SETFILTER("NS_Operation Code", Job.GETFILTER("NS_Operation Filter"));
                        SETFILTER(Type, Job.GETFILTER("NS_Type Filter"));
                        SETFILTER("Posting Date", Job.GETFILTER("NS_Date Filter"));
                    end;
                }

                trigger OnPreDataItem();
                begin
                    if not "IncludeSub-Levels" then
                        CurrReport.BREAK;
                end;
            }
            dataitem("Page Header"; "Integer")
            {
                DataItemTableView = SORTING(Number) ORDER(Ascending);
                PrintOnlyIfDetail = true;
                column(CompanyInformation_Name; CompanyInformation.Name)
                {
                }
                column(USERID; USERID)
                {
                }
                column(TIME; TIME)
                {
                }
                column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
                {
                }
                column(STRSUBSTNO_Text14021100_Job__No___; STRSUBSTNO(Text14021100, ' '))
                {
                }
                column(CurrReport_PAGENO; CurrReport.PAGENO)
                {
                }
                column(Sub_LevelsText_; "Sub-LevelsText")
                {
                }
                column(Job_TABLECAPTION_____Filters______JobFilter; Job.TABLECAPTION + ' Filters: ' + JobFilter)
                {
                }
                column(Job__Description_2_; Job."Description 2")
                {
                }
                column(Job_FIELDCAPTION__Ending_Date____________FORMAT_Job__Ending_Date__; Job.FIELDCAPTION("Ending Date") + ': ' + FORMAT(Job."Ending Date"))
                {
                }
                column(Job_Description; Job.Description)
                {
                }
                column(Job_FIELDCAPTION__Starting_Date____________FORMAT_Job__Starting_Date__; Job.FIELDCAPTION("Starting Date") + ': ' + FORMAT(Job."Starting Date"))
                {
                }
                column(Job__No__; Job."No.")
                {
                }
                column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                }
                column(JobCaption; JobCaptionLbl)
                {
                }
                column(DescriptionCaption; DescriptionCaptionLbl)
                {
                }
                column(Balance_to_be_BilledCaption; Balance_to_be_BilledCaptionLbl)
                {
                }
                column(ItemizedCaption; ItemizedCaptionLbl)
                {
                }
                column(BillingsCaption; BillingsCaptionLbl)
                {
                }
                column(Activity___Process___OperationCaption; Activity___Process___OperationCaptionLbl)
                {
                }
                column(Percent_of_BillingsCaption; Percent_of_BillingsCaptionLbl)
                {
                }
                column(Page_Header_Number; Number)
                {
                }
                column(ShowProcesses; ShowProcesses)
                {
                }
                column(ShowOperations; ShowOperations)
                {
                }
                dataitem("Integer"; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    column(STRSUBSTNO_Text14021101_JobActivity_Code_; STRSUBSTNO(Text14021101, JobAnalysisBuffer."NS_Activity Code"))
                    {
                    }
                    column(JobActivity_Description; JobActivity.NS_Description)
                    {
                    }
                    column(TotaltoPrintActivityPrice; TotaltoPrintActivityPrice)
                    {
                    }
                    column(TotaltoPrintBudgetActivityPric; TotaltoPrintBudgetActivityPric)
                    {
                    }
                    column(RemainingActivity; RemainingActivity)
                    {
                    }
                    column(Used_Activity_; UsedPctActivity)
                    {
                        DecimalPlaces = 1 : 1;
                    }
                    column(JobProcess_Description; JobProcess.NS_Description)
                    {
                    }
                    column(STRSUBSTNO_Text14021102_JobProcess_Code_; STRSUBSTNO(Text14021102, JobAnalysisBuffer."NS_Process Code"))
                    {
                    }
                    column(TotaltoPrintProcessPrice; TotaltoPrintProcessPrice)
                    {
                    }
                    column(TotaltoPrintBudgetProcessPrice; TotaltoPrintBudgetProcessPrice)
                    {
                    }
                    column(RemainingProcess; RemainingProcess)
                    {
                    }
                    column(Used_Process_; "Used%Process")
                    {
                        DecimalPlaces = 1 : 1;
                    }
                    column(JobOperation_Description; JobOperation.NS_Description)
                    {
                    }
                    column(STRSUBSTNO_Text14021103_JobOperation_Code_; STRSUBSTNO(Text14021103, JobAnalysisBuffer."NS_Operation Code"))
                    {
                    }
                    column(TotaltoPrintOperationPrice; TotaltoPrintOperationPrice)
                    {
                    }
                    column(TotaltoPrintBudgetOperatioPric; TotaltoPrintBudgetOperatioPric)
                    {
                    }
                    column(RemainingOperation; RemainingOperation)
                    {
                    }
                    column(Used_Operation_; "Used%Operation")
                    {
                        DecimalPlaces = 1 : 1;
                    }
                    column(TotaltoPrintActivityPrice_Control26; TotaltoPrintActivityPrice)
                    {
                    }
                    column(TotaltoPrintBudgetActivityPric_Control30; TotaltoPrintBudgetActivityPric)
                    {
                    }
                    column(Remaining; Remaining)
                    {
                        IncludeCaption = false;
                    }
                    column(Used__; "Used%")
                    {
                        DecimalPlaces = 1 : 1;
                    }
                    column(STRSUBSTNO_Text14021104_Job__No___; STRSUBSTNO(Text14021104, Job."No."))
                    {
                    }
                    column(Integer_Number; Number)
                    {
                    }
                    column(UsedPctCnt; UsedPctCnt)
                    {
                    }
                    dataitem(Detail; "Integer")
                    {
                        column(STRSUBSTNO_JobAnalysisBuffer2__No___; STRSUBSTNO(JobAnalysisBuffer2."NS_No."))
                        {
                        }
                        column(FORMAT_JobAnalysisBuffer2_Type_; FORMAT(JobAnalysisBuffer2.NS_Type))
                        {
                        }
                        column(JobAnalysisBuffer2__Actual_Price_; -JobAnalysisBuffer2."NS_Actual Price")
                        {
                        }
                        column(JobAnalysisBuffer2__Total_Price_; JobAnalysisBuffer2."NS_Total Price")
                        {
                        }
                        column(JobAnalysisBuffer2__Total_Price____JobAnalysisBuffer2__Actual_Price_; JobAnalysisBuffer2."NS_Total Price" + JobAnalysisBuffer2."NS_Actual Price")
                        {
                        }
                        column(Used_Detail_; "Used%Detail")
                        {
                            DecimalPlaces = 1 : 1;
                        }
                        column(Detail_Number; Number)
                        {
                        }

                        trigger OnAfterGetRecord();
                        begin
                            if Number = 1 then
                                JobAnalysisBuffer2.FINDSET
                            else
                                JobAnalysisBuffer2.NEXT;
                        end;

                        trigger OnPreDataItem();
                        begin
                            if (not DetailEnabled) or (not ShowDetail) then
                                CurrReport.BREAK;

                            JobAnalysisBuffer2.RESET;
                            JobAnalysisBuffer2.SETRANGE("NS_Job No.", JobAnalysisBuffer."NS_Job No.");
                            if DetailActivityCode > '' then
                                JobAnalysisBuffer2.SETRANGE("NS_Activity Code", DetailActivityCode);
                            if DetailProcessCode > '' then
                                JobAnalysisBuffer2.SETRANGE("NS_Process Code", DetailProcessCode);
                            if DetailOperationCode > '' then
                                JobAnalysisBuffer2.SETRANGE("NS_Operation Code", DetailOperationCode);
                            NumDetailLines := JobAnalysisBuffer2.COUNT;
                            if NumDetailLines = 0 then
                                CurrReport.BREAK;
                            SETRANGE(Number, 1, NumDetailLines);

                            DetailEnabled := false;
                            DetailActivityCode := '';
                            DetailProcessCode := '';
                            DetailOperationCode := '';
                        end;
                    }

                    trigger OnAfterGetRecord();
                    begin
                        if JobAnalysisBuffer.NEXT = 0 then
                            CurrReport.SKIP;

                        if (JobAnalysisBuffer."NS_Activity Code" <> OldActivityCode) and
                           (JobAnalysisBuffer."NS_Activity Code" > '') then begin
                            TotaltoPrintActivityPrice := 0;
                            TotaltoPrintBudgetActivityPric := 0;
                            RemainingActivity := 0;
                            JobAnalysisBuffer2.RESET;
                            JobAnalysisBuffer2.SETRANGE("NS_Job No.", JobAnalysisBuffer."NS_Job No.");
                            JobAnalysisBuffer2.SETRANGE("NS_Activity Code", JobAnalysisBuffer."NS_Activity Code");
                            JobAnalysisBuffer2.SETFILTER("NS_Date Filter", Job.GETFILTER("NS_Date Filter"));
                            if not JobAnalysisBuffer2.FINDSET then
                                CurrReport.SKIP;
                            repeat
                                TotaltoPrintBudgetActivityPric := TotaltoPrintBudgetActivityPric + JobAnalysisBuffer2."NS_Budgeted Price";
                                TotaltoPrintActivityPrice := TotaltoPrintActivityPrice + JobAnalysisBuffer2."NS_Actual Price";
                            until JobAnalysisBuffer2.NEXT = 0;

                            if "IncludeSub-Levels" and not "ShowSub-Levels" then begin
                                SubJob.RESET;
                                SubJob.SETRANGE("NS_Sub-Level to Job No.", JobAnalysisBuffer."NS_Job No.");
                                if SubJob.FINDSET then
                                    repeat
                                        SubJobPlanningLine.RESET;
                                        SubJobPlanningLine.SETRANGE("Job No.", SubJob."No.");
                                        SubJobPlanningLine.SETFILTER("NS_Entry Type", '%1|%2',
                                                                                  SubJobPlanningLine."NS_Entry Type"::Price,
                                                                                  SubJobPlanningLine."NS_Entry Type"::Both);
                                        SubJobPlanningLine.SETRANGE(Type, JobAnalysisBuffer.NS_Type::Contract);
                                        SubJobPlanningLine.SETRANGE("NS_Activity Code", JobAnalysisBuffer."NS_Activity Code");
                                        SubJobPlanningLine.SETFILTER("Planning Date", Job.GETFILTER("NS_Date Filter"));
                                        if SubJobPlanningLine.FINDSET then
                                            repeat
                                                TotaltoPrintBudgetActivityPric := TotaltoPrintBudgetActivityPric + SubJobPlanningLine."Total Price (LCY)";
                                            until SubJobPlanningLine.NEXT = 0;
                                    until SubJob.NEXT = 0;
                            end;

                            ActivityCodetoPrint := JobAnalysisBuffer."NS_Activity Code";
                            DetailActivityCode := JobAnalysisBuffer."NS_Activity Code";
                            OldActivityCode := JobAnalysisBuffer."NS_Activity Code";
                            CLEAR(OldProcessCode);
                            CLEAR(OldOperationCode);
                        end;

                        if (JobAnalysisBuffer."NS_Process Code" <> OldProcessCode) and
                           (JobAnalysisBuffer."NS_Process Code" > '') then begin
                            CLEAR(TotaltoPrintProcessPrice);
                            CLEAR(TotaltoPrintBudgetProcessPrice);
                            JobAnalysisBuffer2.RESET;
                            JobAnalysisBuffer2.SETRANGE("NS_Job No.", JobAnalysisBuffer."NS_Job No.");
                            JobAnalysisBuffer2.SETRANGE("NS_Activity Code", JobAnalysisBuffer."NS_Activity Code");
                            JobAnalysisBuffer2.SETRANGE("NS_Process Code", JobAnalysisBuffer."NS_Process Code");
                            JobAnalysisBuffer2.SETFILTER("NS_Date Filter", Job.GETFILTER("NS_Date Filter"));
                            if not JobAnalysisBuffer2.FINDSET then
                                CurrReport.SKIP;
                            repeat
                                TotaltoPrintBudgetProcessPrice := TotaltoPrintBudgetProcessPrice + JobAnalysisBuffer2."NS_Budgeted Price";
                                TotaltoPrintProcessPrice := TotaltoPrintProcessPrice + JobAnalysisBuffer2."NS_Actual Price";
                            until JobAnalysisBuffer2.NEXT = 0;
                            if "IncludeSub-Levels" and not "ShowSub-Levels" then begin
                                SubJob.RESET;
                                SubJob.SETRANGE("NS_Sub-Level to Job No.", JobAnalysisBuffer."NS_Job No.");
                                if SubJob.FINDSET then
                                    repeat
                                        SubJobPlanningLine.RESET;
                                        SubJobPlanningLine.SETRANGE("Job No.", SubJob."No.");
                                        SubJobPlanningLine.SETFILTER("NS_Entry Type", '%1|%2',
                                                                                  SubJobPlanningLine."NS_Entry Type"::Price,
                                                                                  SubJobPlanningLine."NS_Entry Type"::Both);
                                        SubJobPlanningLine.SETRANGE(Type, JobAnalysisBuffer.NS_Type::Contract);
                                        SubJobPlanningLine.SETRANGE("NS_Activity Code", JobAnalysisBuffer."NS_Activity Code");
                                        SubJobPlanningLine.SETRANGE("NS_Process Code", JobAnalysisBuffer."NS_Process Code");
                                        SubJobPlanningLine.SETFILTER("Planning Date", Job.GETFILTER("NS_Date Filter"));
                                        if SubJobPlanningLine.FINDSET then
                                            repeat
                                                TotaltoPrintBudgetProcessPrice := TotaltoPrintBudgetProcessPrice + SubJobPlanningLine."Total Price (LCY)";
                                            until SubJobPlanningLine.NEXT = 0;
                                    until SubJob.NEXT = 0;
                            end;
                            ProcessCodetoPrint := JobAnalysisBuffer."NS_Process Code";
                            DetailProcessCode := JobAnalysisBuffer."NS_Process Code";
                            OldProcessCode := JobAnalysisBuffer."NS_Process Code";
                            CLEAR(OldOperationCode);
                        end;

                        if (JobAnalysisBuffer."NS_Operation Code" <> OldOperationCode) and
                           (JobAnalysisBuffer."NS_Operation Code" > '') then begin
                            CLEAR(TotaltoPrintOperationPrice);
                            CLEAR(TotaltoPrintBudgetOperatioPric);
                            JobAnalysisBuffer2.RESET;
                            JobAnalysisBuffer2.SETRANGE("NS_Job No.", JobAnalysisBuffer."NS_Job No.");
                            JobAnalysisBuffer2.SETRANGE("NS_Activity Code", JobAnalysisBuffer."NS_Activity Code");
                            JobAnalysisBuffer2.SETRANGE("NS_Process Code", JobAnalysisBuffer."NS_Process Code");
                            JobAnalysisBuffer2.SETRANGE("NS_Operation Code", JobAnalysisBuffer."NS_Operation Code");
                            JobAnalysisBuffer2.SETFILTER("NS_Date Filter", Job.GETFILTER("NS_Date Filter"));
                            if not JobAnalysisBuffer2.FINDSET then
                                CurrReport.SKIP;
                            repeat
                                TotaltoPrintBudgetOperatioPric := TotaltoPrintBudgetOperatioPric + JobAnalysisBuffer2."NS_Budgeted Price";
                                TotaltoPrintOperationPrice := TotaltoPrintOperationPrice + JobAnalysisBuffer2."NS_Actual Price";
                            until JobAnalysisBuffer2.NEXT = 0;
                            if "IncludeSub-Levels" and not "ShowSub-Levels" then begin
                                SubJob.RESET;
                                SubJob.SETRANGE("NS_Sub-Level to Job No.", JobAnalysisBuffer."NS_Job No.");
                                if SubJob.FINDSET then
                                    repeat
                                        SubJobPlanningLine.RESET;
                                        SubJobPlanningLine.SETRANGE("Job No.", SubJob."No.");
                                        SubJobPlanningLine.SETFILTER("NS_Entry Type", '%1|%2',
                                                                                  SubJobPlanningLine."NS_Entry Type"::Price,
                                                                                  SubJobPlanningLine."NS_Entry Type"::Both);
                                        SubJobPlanningLine.SETRANGE(Type, JobAnalysisBuffer.NS_Type::Contract);
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
                            OperationCodetoPrint := JobAnalysisBuffer."NS_Operation Code";
                            DetailOperationCode := JobAnalysisBuffer."NS_Operation Code";
                            OldOperationCode := JobAnalysisBuffer."NS_Operation Code";
                        end;

                        JobAnalysisBuffer.NEXT;
                        if not JobActivity.GET(JobAnalysisBuffer."NS_Entry Type"::Cost, JobAnalysisBuffer."NS_Activity Code") then
                            JobActivity.GET(JobActivity.NS_Type::Revenue, JobAnalysisBuffer."NS_Activity Code")
                        else
                            JobActivity.GET(JobAnalysisBuffer."NS_Entry Type"::Cost, JobAnalysisBuffer."NS_Activity Code");
                        RemainingActivity := TotaltoPrintBudgetActivityPric - TotaltoPrintActivityPrice;
                        if TotaltoPrintBudgetActivityPric > 0 then begin
                            if TotaltoPrintActivityPrice > 0 then begin
                                UsedPctActivity := TotaltoPrintActivityPrice / TotaltoPrintBudgetActivityPric * 100;
                                UsedPctCnt := 1;
                            end else begin
                                UsedPctActivity := 0;
                                UsedPctCnt := 0;
                            end
                        end else begin
                            UsedPctActivity := 0;
                            UsedPctCnt := 0;
                        end;
                    end;

                    trigger OnPreDataItem();
                    begin
                        JobAnalysisBuffer.RESET;
                        NumBudgetLines := JobAnalysisBuffer.COUNT;
                        if NumBudgetLines = 0 then
                            CurrReport.BREAK;
                        SETRANGE(Number, 1, NumBudgetLines);

                        CurrReport.CREATETOTALS(TotaltoPrintActivityPrice, TotaltoPrintBudgetActivityPric);
                        JobAnalysisBuffer.RESET;
                        JobAnalysisBuffer.FINDSET;
                        UsedPctCnt := 0;
                    end;
                }

                trigger OnPreDataItem();
                begin
                    //Duplicate JobAnalysisBuffer to JobAnalysisBuffer2
                    with JobAnalysisBuffer do begin
                        RESET;
                        if FINDSET then
                            repeat
                                JobAnalysisBuffer2.COPY(JobAnalysisBuffer);
                                JobAnalysisBuffer2.INSERT;
                            until NEXT = 0;
                    end;

                    SETRANGE(Number, 1);
                end;
            }

            trigger OnAfterGetRecord();
            begin
                RecCount += 1;
                JobAnalysisBuffer.DELETEALL;
                JobAnalysisBuffer2.DELETEALL;
                if ("NS_Sub-Level to Job No." > '') and not "ShowSub-Levels" then
                    CurrReport.SKIP;
                if RecCount > 1 then
                    CurrReport.NEWPAGE;
            end;

            trigger OnPreDataItem();
            begin
                JobHold := Job;
                JobHold.COPYFILTERS(Job);
                "MarkSub-Levels"(Job, "IncludeSub-Levels");
                FILTERGROUP(10);
                COPYFILTERS(JobHold);
                SETRANGE("No.");
                FILTERGROUP(0);
                COPYFILTERS(JobHold);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Include Sub-Levels"; "IncludeSub-Levels")
                {
                    Caption = 'Include Sub-Levels';
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        if not "IncludeSub-Levels" then begin
                            "ShowSub-Levels" := false;
                        end;
                    end;
                }
                field("Show Sub-Levels"; "ShowSub-Levels")
                {
                    Caption = 'Show Sub-Levels';
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        if "ShowSub-Levels" then
                            "IncludeSub-Levels" := true;
                    end;
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
                field("Show Details"; ShowDetail)
                {
                    Caption = 'Show Details';
                    ApplicationArea = All;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        CompanyInformation.GET;
        JobFilter := Job.GETFILTERS;

        if not "ShowSub-Levels" then
            if "IncludeSub-Levels" then
                "Sub-LevelsText" := Text14021105
            else
                "Sub-LevelsText" := Text14021106
        else
            "Sub-LevelsText" := Text14021106;

        CLEAR(OldActivityCode);
    end;

    var
        CompanyInformation: Record "Company Information";
        JobActivity: Record "NS_Job Activity";
        JobProcess: Record "NS_Job Process";
        JobOperation: Record "NS_Job Operation";
        JobAnalysisBuffer: Record "NS_Job Analysis Buffer" temporary;
        JobAnalysisBuffer2: Record "NS_Job Analysis Buffer" temporary;
        SubJobPlanningLine: Record "Job Planning Line";
        SubJob: Record Job;
        JobHold: Record Job;
        NumBudgetLines: Integer;
        NumDetailLines: Integer;
        JobFilter: Text[250];
        Remaining: Decimal;
        RemainingDetail: Decimal;
        RemainingOperation: Decimal;
        RemainingProcess: Decimal;
        RemainingActivity: Decimal;
        "Used%": Decimal;
        "Used%Detail": Decimal;
        "Used%Operation": Decimal;
        "Used%Process": Decimal;
        "Used%Activity": Decimal;
        TotalOperationCost: Decimal;
        OperationCodetoPrint: Code[10];
        OldOperationCode: Code[10];
        DetailOperationCode: Code[10];
        TotaltoPrintOperationPrice: Decimal;
        TotalBudgetOperationPrice: Decimal;
        TotaltoPrintBudgetOperatioPric: Decimal;
        TotalProcessCost: Decimal;
        ProcessCodetoPrint: Code[10];
        OldProcessCode: Code[10];
        DetailProcessCode: Code[10];
        TotaltoPrintProcessPrice: Decimal;
        TotalBudgetProcessPrice: Decimal;
        TotaltoPrintBudgetProcessPrice: Decimal;
        TotalActivityPrice: Decimal;
        ActivityCodetoPrint: Code[10];
        OldActivityCode: Code[10];
        DetailActivityCode: Code[10];
        TotaltoPrintActivityPrice: Decimal;
        TotalBudgetActivityPrice: Decimal;
        TotaltoPrintBudgetActivityPric: Decimal;
        "IncludeSub-Levels": Boolean;
        "ShowSub-Levels": Boolean;
        "Sub-LevelsText": Text[50];
        ShowProcesses: Boolean;
        ShowOperations: Boolean;
        ShowDetail: Boolean;
        RecCount: Integer;
        Text14021100: Label 'Actual vs Budget Price by Revenue APO for Job %1';
        ReportTitle: Label 'Actual vs Budget Price by Revenue APO for Job'; //PRJ-432.AM.1.0

        Text14021101: Label 'Activity  %1';
        Text14021102: Label 'Process %1';
        Text14021103: Label 'Operation %1';
        Text14021104: Label 'Total Job %1';
        DetailEnabled: Boolean;
        NoHeading: Text[10];
        TypeHeading: Text[10];
        Text14021105: Label 'Sub-Levels are included in jobs';
        Text14021106: Label 'Sub-Levels are not included in jobs';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        JobCaptionLbl: Label 'Job';
        DescriptionCaptionLbl: Label 'Description';
        Balance_to_be_BilledCaptionLbl: Label 'Balance to be Billed';
        ItemizedCaptionLbl: Label 'Itemized';
        BillingsCaptionLbl: Label 'Billings';
        Activity___Process___OperationCaptionLbl: Label 'Activity / Process / Operation';
        Percent_of_BillingsCaptionLbl: Label 'Percent of Billings';
        IncomingProcessCode: Code[10];
        IncomingOperationCode: Code[10];
        UsedPctActivity: Decimal;
        UsedPctCnt: Decimal;

    procedure SetProcessOperation(ProcessCodeIn: Code[10]; OperationCodeIn: Code[10]; var ProcessCodeOut: Code[10]; var OperationCodeOut: Code[10]);
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
    end;
}

