/// <summary>
/// Report NS_Job Forecast WhksIncCubLevel (ID 14021292).
/// </summary>
//PRJ-1039.JS.1.0 31JAN2022 New report
//PRJ-1341.JS.1.0 17MAY2022 Create new layout 
//PRJ-1454.NK.1.0 09Jan2023 Change Code
//PRJCTPR-51 Dk.1.0.30jan 2023 | Worked on Description and Work Unit Of Measure
report 14021292 "NS_JobForecast WhksIncSubLevel"
{


    DefaultLayout = RDLC;
    Caption = 'Job Forecast Worksheet Inc. Sub. Levels';
    RDLCLayout = './Layouts/NSJob Forecast WhksIncSubLevels.rdl';
    UsageCategory = ReportsAndAnalysis;
    //ApplicationArea = all; //PE-191.NC.1.0 11Mar2024 Block


    dataset
    {
        dataitem(ReportHeadings; "Integer")
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending);
            MaxIteration = 1;
            column(Job_Forecast_Caption; JobForecastLbl)
            {
            }
            column(FinalRoundingDec; FinalRoundingDec)
            {
                //PRJ-543.AS.1.0
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO_Caption; CurrReportPAGENOLbl)
            {
            }
            column(Job_Name_Caption; JobNameLbl)
            {
            }
            column(Job_Task_No_Caption; JobTaskNoLbl)
            {
            }
            column(Job_Task_Description_Caption; JobTaskDescriptionLbl)
            {
            }
            column(Work_Units_Caption; WorkUnitsLbl)
            {
            }
            column(Work_Unit_Of_Measure_Caption; WorkUnitOfMeasureLbl)
            {
            }
            column(Status_Date_Caption; StatusDateLbl)
            {
            }
            column(Units_Complete_Caption; UnitsCompleteLbl)
            {
            }
            column(Percent_Complete_Caption; PercentCompleteLbl)
            {
            }
            column(Cost_To_Complete_Caption; CostToCompleteLbl)
            {
            }
            column(Forecasted_Completed_Cost_Caption; ForecastedCompletedCostLbl)
            {
            }
            column(Budgeted_Costs_Caption; BudgetedCostsLbl)
            {
            }
            column(Total_Budgeted_Cost_Caption; TotalBudgetedCostsLbl)
            {
            }
            column(Total_Costs_Used_Caption; TotalCostsUsedLbl)
            {
            }
            column(Budget_Remaining_Caption; BudgetRemainingLbl)
            {
            }
            column(Budget_Percentage_Used_Caption; BudgetPercentageUsedLbl)
            {
            }
            column(New_Status_Date_Caption; NewStatusDateLbl)
            {
            }
            column(New_Total_Units_Complete_Caption; NewTotalUnitsCompleteLbl)
            {
            }
            column(New_Total_Percent_Complete_Caption; NewTotalPercentCompleteLbl)
            {
            }
            column(Estimated_Cost_To_Complete_Caption; EstimatedCostToCompleteLbl)
            {
            }
            column(Forecasted_Variance_Caption; ForecastedVarianceLbl)
            {
            }
            column(Forecast_Summary_Caption; ForecastSummaryLbl)
            {
            }
            column(Total_Forecasted_Completed_Cost_Caption; TotalForecastedCompletedCostLbl)
            {
            }
            column(Total_Forecasted_Variance_Caption; TotalForecastedVarianceLbl)
            {
            }
            column(Total_Cost_To_Date_Caption; TotalCostToDateLbl)
            {
            }
            column(Total_Budget_Remaining_Caption; TotalBudgetRemainingLbl)
            {
            }
            column(Forecasted_Cost_Remaining_Caption; ForecastedCostRemainingLbl)
            {
            }
            column(Net_Cost_Variance_Caption; NetCostVarianceLbl)
            {
            }
            column(Job_Percent_Complete_Caption; JobPercentCompleteLbl)
            {
            }
            column(Revenue_Earned_Caption; RevenueEarnedLbl)
            {
            }
            column(Gross_Margins_Amount_Caption; GrossMarginsAmountLbl)
            {
            }
            column(Gross_Margins_Percent_Caption; GrossMarginsPercentLbl)
            {
            }
            column(Total_Contract_Revenue_Caption; TotalContractRevenueLbl)
            {
            }
            dataitem("Job Forecast"; "NS_Job Forecast")
            {
                DataItemTableView = SORTING("NS_Job No.", "NS_Job Task No.", "NS_Line No.");
                column(Job_Forecast_Job_No; "NS_Job No.")
                {
                }
                column(Job_Name; JobName)
                {
                }
                column(Job_Task_No; "NS_Job Task No.")
                {
                }
                column(Job_Task_Description; JobTask.Description)
                {
                }
                column(Work_Units; JobPlanningLineBudget."NS_Work Units")
                {
                    DecimalPlaces = 0 : 0;
                }
                // column(Work_Unit_of_Measure; JobPlanningLineBudget."NS_Work Unit of Measure")//PRJCTPR-51 Dk.1.0.30jan 2023
                // {
                // }
                column(Work_Unit_of_Measure; WorkUnitOfMeasure)//PRJCTPR-51 Dk.1.0.30jan 2023
                {
                }
                column(Status_Date; PreviousJobForecast."NS_Status Date")
                {
                }
                column(Units_Complete; PreviousJobForecast."NS_Units Complete")
                {
                }
                column(Percent_Complete; PreviousJobForecast."NS_Percent Complete")
                {
                }
                column(Cost_To_Complete; PreviousJobForecast."NS_Cost To Complete")
                {
                }
                column(Forecasted_Completed_Cost; PreviousJobForecast."NS_Forecasted Completed Cost")
                {
                }
                column(Budgeted_Costs; LineTotalBudget)
                {
                }
                column(Total_Budgeted_Costs; LineTotalBudget)
                {
                }
                column(Total_Costs_Used; TotalCostsUsed)
                {
                }
                column(Budget_Remaining; BudgetRemaining)
                {
                }
                column(Budget_Percentage_Used; BudgetPercentageUsed)
                {
                }
                column(New_Status_Date; JobForecastUnposted."NS_Status Date")
                {
                }
                column(New_Total_Units_Complete; JobForecastUnposted."NS_Units Complete")
                {
                }
                column(New_Total_Percent_Complete; JobForecastUnposted."NS_Percent Complete")
                {
                }
                column(Estimated_Cost_To_Complete; JobForecastUnposted."NS_Cost To Complete")
                {
                }
                column(New_Forecasted_Completed_Cost; JobForecastUnposted."NS_Forecasted Completed Cost")
                {
                }
                column(Forecasted_Variance; ForecastedVariance)
                {
                }
                column(Contracted_Amount; Contract)
                {
                }
                column(Total_Forecasted_Completed_Cost; TotalForecastedCompletedCost)
                {
                }
                column(Full_WorkSheet; FullWorksheet)
                {
                }
                column(Job_Pct_Complete; JobPctComplete)
                {
                }
                column(As_Of_Date; AsOfDate)
                {
                }
                column(Total_Revenue; TotalRevenue)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    NSJobNoFilter := '';
                    NSJobNoFilter := '@*' + format("NS_Job No.") + '*';

                    NS_GetLastPostedStatus("NS_Job No.", "NS_Job Task No.", AsOfDate, PreviousJobForecast);

                    if (PreviousJobForecast."NS_Status Date" <> 0D) and
                       ((PreviousJobForecast."NS_Job No." = '') or (PreviousJobForecast."NS_Status Date" > AsOfDate)) then
                        CurrReport.SKIP();

                    if not JobTask.GET("NS_Job No.", "NS_Job Task No.") then
                        if "NS_Job No." = '' then
                            ERROR(Text1001)
                        else
                            ERROR(Text1000, "NS_Job No.", "NS_Job Task No.");

                    JobTask.CALCFIELDS("Schedule (Total Cost)", "Schedule (Total Price)", "Usage (Total Cost)", "Usage (Total Price)",
                                       "Contract (Total Cost)", "Contract (Total Price)", "Contract (Invoiced Price)", "Contract (Invoiced Cost)",
                                       "Remaining (Total Cost)", "Remaining (Total Price)", "NS_Total Hours Applied");

                    //NS_GetJobPlanningLineAndBudget("NS_Job No.", "NS_Job Task No.", JobPlanningLineBudget, LineTotalBudget, AsOfDate);
                    NS_GetJobPlanningLineAndBudgetIncludeSubLevels("NS_Job No.", "NS_Job Task No.", JobPlanningLineBudget, LineTotalBudget, AsOfDate);

                    Job.RESET();
                    Job.SETFILTER("No.", "NS_Job No.");
                    Job.SETFILTER("NS_Job Task No. Filter", "NS_Job Task No.");
                    Job.SETFILTER("NS_Date Filter", '<=%1', AsOfDate);
                    Job.CALCFIELDS("NS_Usage (Cost) (LCY)");
                    TotalCostsUsed := Job."NS_Usage (Cost) (LCY)";
                    Job.FINDSET();
                    JobName := Job."No." + ' - ' + Job.Description;
                    WorkUnitOfMeasure := JobTask."NS_Work Unit of Measure";//PRJCTPR-51 Dk.1.0.30jan 2023

                    //Get Total cost used for Sub Level Jobs-Start
                    Job2.Reset();
                    Job2.SetFilter("NS_Sub-Level to Job No.", '%1', NSJobNoFilter);
                    //Job2.SETFILTER("NS_Job Task No. Filter", "NS_Job Task No.");
                    //Job2.SETFILTER("NS_Date Filter", '<=%1', AsOfDate);
                    if Job2.FindSet() then
                        repeat
                            Job3.Reset();
                            Job3.Setrange("No.", Job2."No.");
                            Job3.SETFILTER("NS_Job Task No. Filter", "NS_Job Task No.");
                            Job3.SETFILTER("NS_Date Filter", '<=%1', AsOfDate);
                            if Job3.FindSet() then
                                repeat
                                    Job3.CALCFIELDS("NS_Usage (Cost) (LCY)");
                                    If Job3."NS_Usage (Cost) (LCY)" <> 0 then
                                        TotalCostsUsed := TotalCostsUsed + Job3."NS_Usage (Cost) (LCY)";
                                until Job3.Next() = 0;

                        //Get total contract
                        // JobPlanningLinePrice.Reset();
                        // JobPlanningLinePrice.SetRange("Job No.", Job2."No.");
                        // JobPlanningLinePrice.SetRange("Job Task No.", "NS_Job Task No.");
                        // If AsOfDate <> 0D then
                        //     JobPlanningLinePrice.SetFilter("Planning Date", '<=%1', AsOfDate);
                        // JobPlanningLinePrice.SetFilter("Line Type", '<>%1', JobPlanningLinePrice."Line Type"::Budget);
                        // if JobPlanningLinePrice.FindSet() then begin
                        //     JobPlanningLinePrice.CalcSums("Line Amount (LCY)");
                        //     if JobPlanningLinePrice."Line Amount (LCY)" <> 0 then
                        //         TotalRevenue := TotalRevenue + JobPlanningLinePrice."Line Amount (LCY)";
                        //     //Message('...%1...', Contract);
                        // end;s
                        //Get Total cost used for Sub Level Jobs-end
                        until Job2.Next() = 0;

                    if "NS_Entry Type" = "NS_Entry Type"::Cost then begin
                        BudgetRemaining := LineTotalBudget - TotalCostsUsed;
                        if BudgetRemaining > 0 then
                            BudgetPercentageUsed := 100 - NS_CalcPercentFrom0To100IncludeSubLevels(LineTotalBudget, BudgetRemaining)
                        else begin
                            BudgetPercentageUsed := 100;
                            BudgetRemaining := 0;
                        end;
                    end else begin
                        BudgetPercentageUsed := 0;
                        BudgetRemaining := 0;
                    end;

                    NS_GetUnpostedRecord("NS_Job No.", "NS_Job Task No.", JobForecastUnposted);
                    if "NS_Percent Complete" < 100 then begin
                        BudgetRemaining := LineTotalBudget - TotalCostsUsed;
                        if BudgetRemaining <= 0 then
                            BudgetRemaining := 0;

                        BudgetPercentageUsed := NS_CalcPercentFrom0To100(LineTotalBudget, TotalCostsUsed);
                        // if "Hours To Finish" = 0 then //PRJ-565 comment start
                        //     "Cost To Complete" := CalcCostToComplete("Status Date", "Percent Complete", LineTotalBudget, TotalCostsUsed,
                        //                                              PreviousJobForecast."Status Date",
                        //                                              PreviousJobForecast."Forecasted Completed Cost");
                        // "Forecasted Completed Cost" := TotalCostsUsed + "Cost To Complete"; //PRJ-565 comment end
                    end;
                    JobForecastUnposted."NS_Forecasted Completed Cost" := "NS_Forecasted Completed Cost";
                    JobForecastUnposted."NS_Cost To Complete" := "NS_Cost To Complete";
                    ForecastedVariance := LineTotalBudget - "NS_Forecasted Completed Cost";
                    TotalForecastedCompletedCost += "NS_Forecasted Completed Cost";
                    TotalCostUsedJob += TotalCostsUsed;
                    ForecastedCompletedCostJob += "NS_Forecasted Completed Cost";
                    //ForecastedVariance := LineTotalBudget - JobForecastUnposted."Forecasted Completed Cost";
                    //TotalForecastedCompletedCost := TotalForecastedCompletedCost + ForecastedCompletedCost;
                end;

                trigger OnPostDataItem();
                begin
                    JobPctComplete := ROUND((TotalCostUsedJob / ForecastedCompletedCostJob) * 100);
                end;

                trigger OnPreDataItem();
                var
                    NSJobs: Record Job;
                    NSJobs2: Record Job;
                    NSJobNoFilter: Code[30];
                    NSJobPlanningLine: Record "Job Planning Line";
                begin
                    NSJobNoFilter := '';
                    NSJobNoFilter := '@*' + Format(JobNo) + '*';
                    if JobNo > '' then
                        SETRANGE("NS_Job No.", JobNo);
                    if AsOfDate > 0D then
                        SETFILTER("NS_Status Date", '<=%1', AsOfDate);
                    SETRANGE(NS_Posted, false);
                    Job.GET(JobNo);
                    Job.CALCFIELDS("NS_Budgeted Price (LCY)");
                    Contract := Job."NS_Budgeted Price (LCY)";

                    if NSJobs.Get(JobNo) then
                        if ((NSJobs."NS_Include Sub Levels" = true) and (NSJobs."NS_Job Class" = NSJobs."NS_Job Class"::"Master Job")) then begin
                            NSJobs2.Reset();
                            NSJobs2.SetFilter("NS_Sub-Level to Job No.", '%1', NSJobNoFilter);
                            if NSJobs2.FindSet() then
                                repeat
                                    NSJobPlanningLine.Reset();
                                    NSJobPlanningLine.Setrange("Job No.", NSJobs2."No.");
                                    NSJobPlanningLine.SetFilter("Line Type", '<>%1', NSJobPlanningLine."Line Type"::Budget);
                                    if AsOfDate > 0D then
                                        NSJobPlanningLine.SetFilter("Planning Date", '<=%1', AsOfDate);
                                    if NSJobPlanningLine.FindSet() then begin
                                        NSJobPlanningLine.CalcSums("Total Price (LCY)");
                                        if NSJobPlanningLine."Total Price (LCY)" <> 0 then
                                            Contract := Contract + NSJobPlanningLine."Total Price (LCY)";
                                    end;
                                until NSJobs2.Next() = 0;
                        end;
                end;
            }

            trigger OnAfterGetRecord();
            var
                JobPlanLineRevenue: Record "Job Planning Line";
            begin
                //PRJ-1454.NK.1.0 09Jan2023 Start Block
                // JobPlanLineRevenue.SETRANGE("Job No.", JobNo);
                // JobPlanLineRevenue.SETFILTER("Line Type", '%1|%2', JobPlanLineRevenue."Line Type"::Billable, JobPlanLineRevenue."Line Type"::"Both Budget and Billable");
                // if AsOfDate <> 0D then
                //     JobPlanLineRevenue.SetFilter("Planning Date", '<=%1', AsOfDate);
                // //JobPlanLineRevenue.CALCSUMS("Line Amount (LCY)", "Line Amount");
                // //TotalRevenue := JobPlanLineRevenue."Line Amount (LCY)";
                // JobPlanLineRevenue.CALCSUMS("Line Amount (LCY)", "Line Amount", "Total Price (LCY)");

                // TotalRevenue := JobPlanLineRevenue."Total Price (LCY)";

                // NSJobNoFilter := '';
                // NSJobNoFilter := '@*' + Format(JobNo) + '*';

                // Job2.Reset();
                // Job2.SetFilter("NS_Sub-Level to Job No.", '%1', NSJobNoFilter);
                // if Job2.FindSet() then
                //     repeat
                //         JobPlanningLinePrice.Reset();
                //         JobPlanningLinePrice.SetRange("Job No.", Job2."No.");
                //         If AsOfDate <> 0D then
                //             JobPlanningLinePrice.SetFilter("Planning Date", '<=%1', AsOfDate);
                //         JobPlanningLinePrice.SETFILTER("Line Type", '%1|%2', JobPlanningLinePrice."Line Type"::Billable, JobPlanningLinePrice."Line Type"::"Both Budget and Billable");
                //         if JobPlanningLinePrice.FindSet() then begin
                //             JobPlanningLinePrice.CalcSums("Line Amount (LCY)", "Total Price (LCY)");
                //             if JobPlanningLinePrice."Total Price (LCY)" <> 0 then
                //                 TotalRevenue := TotalRevenue + JobPlanningLinePrice."Total Price (LCY)";
                //         end;
                //     until Job2.Next() = 0;
                //PRJ-1454.NK.1.0 09Jan2023 End Block
                TotalRevenue := GetPlanningLineIncludeSubLevels(0D, AsOfDate, JobNo, false); //PRJ-1454.NK.1.0 09Jan2023
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
                    field(FullWorksheet; FullWorksheet)
                    {
                        Caption = 'Include Updates';
                        ApplicationArea = All;
                    }
                    field(JobNo; JobNo)
                    {
                        Editable = false;
                        ApplicationArea = All;
                    }
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

    trigger OnInitReport();
    begin
        GLSetup.GET;
        FullWorksheet := true;
    end;

    //PRJ-543.AS.1.0 - start
    trigger OnPreReport();
    begin
        Clear(FinalRoundingDec);
        jobsetupRec.Get();

        if jobsetupRec."NS_Forecast Amount Rounding" = 0.01 then
            FinalRoundingDec := 2
        else
            if jobsetupRec."NS_Forecast Amount Rounding" = 0.001 then
                FinalRoundingDec := 3
            else
                if jobsetupRec."NS_Forecast Amount Rounding" = 0.0001 then
                    FinalRoundingDec := 4
                else
                    if jobsetupRec."NS_Forecast Amount Rounding" = 0.00001 then
                        FinalRoundingDec := 5
                    else
                        if jobsetupRec."NS_Forecast Amount Rounding" = 0.000001 then
                            FinalRoundingDec := 6
                        else
                            if jobsetupRec."NS_Forecast Amount Rounding" = 0.0000001 then
                                FinalRoundingDec := 7
                            else
                                if jobsetupRec."NS_Forecast Amount Rounding" = 0.00000001 then
                                    FinalRoundingDec := 8
                                else
                                    if jobsetupRec."NS_Forecast Amount Rounding" = 0.000000001 then
                                        FinalRoundingDec := 9
                                    else
                                        if jobsetupRec."NS_Forecast Amount Rounding" = 0.0000000001 then
                                            FinalRoundingDec := 10;

    end;
    //PRJ-543.AS.1.0 - end

    var
        Job: Record Job;

        Job2: Record Job;
        Job3: Record Job;
        JobTask: Record "Job Task";
        jobsetupRec: Record "Jobs Setup";
        FinalRoundingDec: Integer;
        JobPlanningLineBudget: Record "Job Planning Line";
        JobPlanningLinePrice: Record "Job Planning Line";
        PreviousJobForecast: Record "NS_Job Forecast";
        JobForecastUnposted: Record "NS_Job Forecast";
        GLSetup: Record "General Ledger Setup";
        JobNo: Code[20];
        AsOfDate: Date;
        JobName: Text[150];
        LineTotalBudget: Decimal;
        BudgetRemaining: Decimal;
        BudgetPercentageUsed: Decimal;
        ForecastedCompletedCost: Decimal;
        ForecastedVariance: Decimal;
        TotalForecastedCompletedCost: Decimal;
        TotalCostsUsed: Decimal;

        NSJobNoFilter: Code[30];
        WorkUnitOfMeasure: Code[10];//PRJCTPR-51 Dk.1.0.30jan 2023
        Text1000: Label 'The Job and Task %1 %2 does not exist.';
        Text1001: Label 'A Job No. must be entered.';
        JobForecastLbl: Label 'Job Forecast';
        CurrReportPAGENOLbl: Label 'Page';
        JobNameLbl: Label 'Job:';
        JobTaskNoLbl: Label 'Job Task No';
        JobTaskDescriptionLbl: Label 'Description';
        WorkUnitsLbl: Label 'Work Units';
        WorkUnitOfMeasureLbl: Label 'Work Unit of Measure';
        StatusDateLbl: Label 'Status Date';
        UnitsCompleteLbl: Label 'Units Complete';
        PercentCompleteLbl: Label 'Percent Complete';
        CostToCompleteLbl: Label 'Cost To Complete';
        ForecastedCompletedCostLbl: Label 'Forecasted Completed Cost';
        BudgetedCostsLbl: Label 'Budgeted Costs';
        TotalBudgetedCostsLbl: Label 'Total Budgeted Costs';
        TotalCostsUsedLbl: Label 'Total Costs Used';
        BudgetRemainingLbl: Label 'Budget Remaining';
        BudgetPercentageUsedLbl: Label 'Budget Percentage Used';
        NewStatusDateLbl: Label 'New Status Date';
        NewTotalUnitsCompleteLbl: Label 'New Total Units Complete';
        NewTotalPercentCompleteLbl: Label 'New Total Percent Complete';
        EstimatedCostToCompleteLbl: Label 'Estimated Cost To Complete';
        ForecastedVarianceLbl: Label 'Forecasted Variance';
        ForecastSummaryLbl: Label 'Forecast Summary';
        TotalForecastedCompletedCostLbl: Label 'Total Forecasted Completed Cost';
        TotalForecastedVarianceLbl: Label 'Total Forecasted Variance';
        TotalCostToDateLbl: Label 'Total Cost to Date';
        TotalBudgetRemainingLbl: Label 'Total Budget Remaining';
        ForecastedCostRemainingLbl: Label 'Forecasted Cost Remaining';
        NetCostVarianceLbl: Label 'Net Cost Variance';
        JobPercentCompleteLbl: Label 'Job Percent Complete';
        RevenueEarnedLbl: Label 'Revenue Earned';
        GrossMarginsAmountLbl: Label 'Gross Margin';
        GrossMarginsPercentLbl: Label 'Gross Margin Percent';
        Contract: Decimal;
        FullWorksheet: Boolean;
        TotalCostUsedJob: Decimal;
        ForecastedCompletedCostJob: Decimal;
        JobPctComplete: Decimal;
        TotalRevenue: Decimal;
        TotalContractRevenueLbl: Label 'Total Contract Revenue';

    procedure Set(JobNoIn: Code[20]; AsOfDateIn: Date);
    begin
        JobNo := JobNoIn;
        AsOfDate := AsOfDateIn;
        "Job Forecast".SETRANGE("NS_Job No.", JobNo);
    end;
    //PRJ-1454.NK.1.0 09Jan2023 Start
    procedure GetPlanningLineIncludeSubLevels(StartDate: Date; var Enddate: Date; var ParaJob: Code[20]; flag: Boolean) Answer: Decimal;
    var
        PlanningLine: Record "Job Planning Line";
        PlanningLine2: Record "Job Planning Line";
        NSJob: Record Job;
        JobNoFilter: Code[20];
        jobSetup: Record "Jobs Setup";
        IsHandled: Boolean;//FGH-163.SM.29022024 //PE-269.JS.1.0
    begin
        //FGH-163.SM.29022024 //PE-269.JS.1.0 START
        OnBeforeGetPlanningLineIncludeSubLevelsReport(StartDate, Enddate, ParaJob, flag, IsHandled, JobNo);
        if IsHandled then
            exit;
        //FGH-163.SM.29022024 //PE-269.JS.1.0 END

        JobNoFilter := '';
        JobNoFilter := '@*' + format(ParaJob) + '*';
        Answer := 0;
        PlanningLine.Reset();
        PlanningLine.SetRange("Job No.", ParaJob);
        if not Flag then
            PlanningLine.SetFilter("Line Type", '<>%1', PlanningLine."Line Type"::Budget)
        else
            PlanningLine.SetFilter("Line Type", '<>%1', PlanningLine."Line Type"::Billable);

        if jobSetup.Get() then;
        if jobSetup."NS_Enab. Budg.on Contract Date" then
            PlanningLine.SetRange("NS_Contract Forecast Date", StartDate, Enddate)
        else
            PlanningLine.SetRange("Planning Date", StartDate, Enddate);
        if PlanningLine.FindSet() then
            repeat
                if Flag then
                    Answer := Answer + PlanningLine."Total Cost (LCY)"
                else
                    Answer := Answer + PlanningLine."Line Amount (LCY)";

            until PlanningLine.Next() = 0;

        NSJob.Reset();
        NSJob.SetCurrentKey("NS_Sub-Level to Job No.");
        NSJob.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        if NSJob.FindSet() then
            repeat
                PlanningLine2.Reset();
                PlanningLine2.SetRange("Job No.", NSJob."No.");
                if not Flag then
                    PlanningLine2.SetFilter("Line Type", '<>%1', PlanningLine2."Line Type"::Budget)
                else
                    PlanningLine2.SetFilter("Line Type", '<>%1', PlanningLine2."Line Type"::Billable);

                if jobSetup.Get() then;
                if jobSetup."NS_Enab. Budg.on Contract Date" then
                    PlanningLine2.SetRange("NS_Contract Forecast Date", StartDate, Enddate)
                else
                    PlanningLine2.SetRange("Planning Date", StartDate, Enddate);
                if PlanningLine2.FindSet() then
                    repeat
                        if Flag then
                            Answer := Answer + PlanningLine2."Total Cost (LCY)"
                        else
                            Answer := Answer + PlanningLine2."Line Amount (LCY)";

                    until PlanningLine2.Next() = 0;
            until NSJob.Next() = 0;
        exit(Answer);
    end;
    //PRJ-1454.NK.1.0 09Jan2023 End

    //FGH-163.SM.29022024 //PE-269.JS.1.0 START
    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetPlanningLineIncludeSubLevelsReport(StartDate: Date; var Enddate: Date; var ParaJob: Code[20]; flag: Boolean; var IsHandled: Boolean; JobNo: Code[20])
    begin
    end;
    //FGH-163.SM.29022024 //PE-269.JS.1.0 END
}

