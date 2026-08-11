report 14021337 "NS_JFW POC By TaskToatls"
{
    // PRJ-1299.JS.1.0 New Report for Job forecast by Task Totals
    //PRJ-1454.NK.1.0 22Jun2022 | Add Code
    ProcessingOnly = true;
    Caption = 'JFW POC By Task Totals';
    UseRequestPage = false;
    Permissions = tabledata 167 = rimd;


    dataset
    {
        dataitem(ReportHeadings; "Integer")
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending);
            MaxIteration = 1;

            dataitem("Job Forecast"; "NS_Job Forecast")
            {
                DataItemTableView = SORTING("NS_Job No.", "NS_Job Task No.", "NS_Line No.");

                trigger OnAfterGetRecord();
                begin
                    JobTask2.Reset();
                    if JobTask2.Get("Job Forecast"."NS_Job No.", "Job Forecast"."NS_Job Task No.") then;
                    NS_GetLastPostedStatus("NS_Job No.", "NS_Job Task No.", AsOfDate, PreviousJobForecast);

                    if (PreviousJobForecast."NS_Status Date" <> 0D) and
                       ((PreviousJobForecast."NS_Job No." = '') or (PreviousJobForecast."NS_Status Date" > AsOfDate)) then
                        CurrReport.SKIP;

                    if not JobTask.GET("NS_Job No.", "NS_Job Task No.") then
                        if "NS_Job No." = '' then
                            ERROR(Text1001)
                        else
                            ERROR(Text1000, "NS_Job No.", "NS_Job Task No.");

                    JobTask.CALCFIELDS("Schedule (Total Cost)", "Schedule (Total Price)", "Usage (Total Cost)", "Usage (Total Price)",
                                       "Contract (Total Cost)", "Contract (Total Price)", "Contract (Invoiced Price)", "Contract (Invoiced Cost)",
                                       "Remaining (Total Cost)", "Remaining (Total Price)", "NS_Total Hours Applied");

                    NS_GetJobPlanningLineAndBudgetFBTT("NS_Job No.", "NS_Job Task No.", JobPlanningLineBudget, LineTotalBudget, AsOfDate);

                    Job.RESET;
                    Job.SETFILTER("No.", "NS_Job No.");
                    //Job.SETFILTER("NS_Job Task No. Filter", "NS_Job Task No.");
                    Job.SETFILTER("NS_Job Task No. Filter", JobTask2.Totaling);
                    Job.SETFILTER("NS_Date Filter", '<=%1', AsOfDate);
                    Job.CALCFIELDS("NS_Usage (Cost) (LCY)");
                    TotalCostsUsed := Job."NS_Usage (Cost) (LCY)";
                    Job.FINDSET;
                    JobName := Job."No." + ' - ' + Job.Description;

                    if "NS_Entry Type" = "NS_Entry Type"::Cost then begin
                        BudgetRemaining := LineTotalBudget - TotalCostsUsed;
                        if BudgetRemaining > 0 then
                            BudgetPercentageUsed := 100 - NS_CalcPercentFrom0To100FBTT(LineTotalBudget, BudgetRemaining)
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

                        BudgetPercentageUsed := NS_CalcPercentFrom0To100FBTT(LineTotalBudget, TotalCostsUsed);
                        // if "Hours To Finish" <> 0 then //PRJ-565 comment start
                        //     "Cost To Complete" := "Cost To Complete" //ctsi-231
                        // else
                        //     "Cost To Complete" := CalcCostToComplete("Status Date", "Percent Complete", LineTotalBudget, TotalCostsUsed,
                        //                                          PreviousJobForecast."Status Date",
                        //                                          PreviousJobForecast."Forecasted Completed Cost");
                        // "Forecasted Completed Cost" := TotalCostsUsed + "Cost To Complete";
                        //PRJ-565 comment start
                    end;
                    JobForecastUnposted."NS_Forecasted Completed Cost" := "NS_Forecasted Completed Cost";
                    JobForecastUnposted."NS_Cost To Complete" := "NS_Cost To Complete";
                    ForecastedVariance := LineTotalBudget - "NS_Forecasted Completed Cost";
                    TotalForecastedCompletedCost += "NS_Forecasted Completed Cost"; //1
                    TotalCostUsedJob += TotalCostsUsed;  //5
                    ForecastedCompletedCostJob += "NS_Forecasted Completed Cost";
                    BudgetedCosts := BudgetedCosts + LineTotalBudget; //2
                    JobForecastUnposted.NS_Complete := NS_Complete;//ctsi-232

                end;

                trigger OnPostDataItem();
                var
                    JobLocal: Record Job;
                    PertaofCompLocal: Record "NS_Percentage of Completion";
                begin
                    if ForecastedCompletedCostJob <> 0 then //PRJ-339.AS.2.0 16SEPT2020
                        JobPctComplete := ROUND((TotalCostUsedJob / ForecastedCompletedCostJob) * 100);
                end;

                trigger OnPreDataItem();
                begin
                    if JobNo > '' then
                        SETRANGE("NS_Job No.", JobNo);
                    if AsOfDate > 0D then
                        SETFILTER("NS_Status Date", '<=%1', AsOfDate);
                    SETRANGE(NS_Posted, false);
                    //Setrange(NS_Complete, false);//CTSI-232 roll back
                    Job.GET(JobNo);
                    Job.CALCFIELDS("NS_Budgeted Price (LCY)");
                    Contract := Job."NS_Budgeted Price (LCY)";
                end;
            }

            trigger OnAfterGetRecord();
            var
                JobPlanLineRevenue: Record "Job Planning Line";
                jobSetup: Record "Jobs Setup"; //PRJ-1454.NK.1.0 22Jun2022
            begin
                JobPlanLineRevenue.SETRANGE("Job No.", JobNo);
                JobPlanLineRevenue.SetFilter("Line Type", '%1|%2', JobPlanLineRevenue."Line Type"::Billable, JobPlanLineRevenue."Line Type"::"Both Budget and Billable");//PRJ-339.AS.2.0 16SEPT2020
                //PRJ-588.AS.1.0 03MAY2021 - START
                if AsOfDate > 0D then begin
                    //PRJ-1454.NK.1.0 22Jun2022 Start
                    jobSetup.Get();
                    if jobSetup."NS_Enab. Budg.on Contract Date" then
                        JobPlanLineRevenue.SETFILTER("NS_Contract Forecast Date", '<=%1', AsOfDate)
                    else //PRJ-1454.NK.1.0 22Jun2022 End
                        JobPlanLineRevenue.SETFILTER("Planning Date", '<=%1', AsOfDate);
                end; //PRJ-1454.NK.1.0 22Jun2022 add
                //PRJ-588.AS.1.0 03MAY2021 - END
                JobPlanLineRevenue.CALCSUMS("Line Amount (LCY)", "Line Amount");
                TotalRevenue := JobPlanLineRevenue."Line Amount (LCY)"; //4
            end;

            trigger OnPostDataItem()
            var
                JobLocal: Record Job;
                PertaofCompLocal: Record "NS_Percentage of Completion";
            begin
                jobsetup.Get();//PRJ-543.AS.1.0 18FEB2021

                PertaofComp.Init();
                PertaofComp.NS_TotalForecastCompletedCost := TotalForecastedCompletedCost;
                PertaofComp."NS_Total Budgeted Costs" := BudgetedCosts;
                PertaofComp."NS_Total Forecasted Variance" := BudgetedCosts - TotalForecastedCompletedCost;//3
                PertaofComp."NS_Total Contract Revenue" := TotalRevenue;
                PertaofComp."NS_Total Cost to Date" := TotalCostUsedJob;
                PertaofComp."NS_Total Budget Remaining" := BudgetedCosts - TotalCostUsedJob; //6
                PertaofComp."NS_Forecasted Cost Remaining" := TotalForecastedCompletedCost - TotalCostUsedJob;//7
                PertaofComp."NS_Net Cost Variance" := (BudgetedCosts - TotalForecastedCompletedCost);//8
                if TotalForecastedCompletedCost <> 0 then
                    //PertaofComp."Job Percent Complete" := Round(((TotalCostUsedJob / TotalForecastedCompletedCost) * 100), 0.01, '>');//9
                PertaofComp."NS_Job Percent Complete" := Round(((TotalCostUsedJob / TotalForecastedCompletedCost) * 100), jobsetup."NS_Forecast Amount Rounding");//PRJ-543.AS.1.0 18FEB2021
                if TotalForecastedCompletedCost <> 0 then
                    //PertaofComp."Revenue Earned" := Round(((Contract * TotalCostUsedJob) / TotalForecastedCompletedCost), 0.01, '>'); //10 
                    //PertaofComp."NS_Revenue Earned" := Round(((Contract * TotalCostUsedJob) / TotalForecastedCompletedCost), jobsetup."NS_Forecast Amount Rounding");//PRJ-543.AS.1.0 18FEB2021 //PRJ-830.GK.1.0 20Sep2021|Code Comment
                    PertaofComp."NS_Revenue Earned" := Round(((Contract * PertaofComp."NS_Job Percent Complete") / 100), jobsetup."NS_Forecast Amount Rounding"); //PRJ-830.GK.1.0 20Sep2021 |New line added
                PertaofComp."NS_Gross Margin" := PertaofComp."NS_Revenue Earned" - TotalCostUsedJob; //11
                if PertaofComp."NS_Revenue Earned" <> 0 then
                    //PertaofComp."Gross Margin Percent" := round((PertaofComp."Gross Margin" / PertaofComp."Revenue Earned" * 100), 0.01, '>'); //12    
                    PertaofComp."NS_Gross Margin Percent" := round((PertaofComp."NS_Gross Margin" / PertaofComp."NS_Revenue Earned" * 100), jobsetup."NS_Forecast Amount Rounding");//PRJ-543.AS.1.0 18FEB2021
                PertaofComp."NS_Posting Date" := AsOfDate;
                //PertaofComp."Job No." := "Job Forecast"."Job No.";//PRJ-339.AS.2.0 16SEPT2020 Commented
                PertaofComp."NS_Job No." := JobNo;//PRJ-339.AS.2.0 16SEPT2020 Added Code
                                                  //CTSI-94.AS.1.0 10AUG2020 - start
                                                  // PertaofComp."Recognized Profit" := Round((((PertaofComp."Job Percent Complete" * PertaofComp."Total Contract Revenue") / 100) - PertaofComp."Total Cost to Date"), 0.01, '>');//not in use
                                                  //PertaofComp."NS_Recognized Profit" := Round((((PertaofComp."NS_Job Percent Complete" * PertaofComp."NS_Total Contract Revenue") / 100) - PertaofComp."NS_Total Cost to Date"), jobsetup."NS_Forecast Amount Rounding");//PRJ-543.AS.1.0 18FEB2021
                                                  //if (PertaofComp."NS_Job Percent Complete" * Contract) <> 0 then
                                                  // PertaofComp."Recognized Profit Percent" := ROUND((PertaofComp."Recognized Profit" / ((PertaofComp."Job Percent Complete" * Contract) / 100) * 100), 0.01, '>');//Change
                                                  //    PertaofComp."NS_Recognized Profit Percent" := ROUND((PertaofComp."NS_Recognized Profit" / ((PertaofComp."NS_Job Percent Complete" * Contract) / 100) * 100), jobsetup."NS_Forecast Amount Rounding");//PRJ-543.AS.1.0 18FEB2021
                                                  //CTSI-94.AS.1.0 10AUG2020 - end 
                PertaofComp.NS_RecRevFlag := true;//CTSI-274
                PertaofComp.Insert();
                //CTSI-196 start
                if JobLocal.get(JobNo) then begin
                    PertaofCompLocal.Reset();
                    PertaofCompLocal.SetCurrentKey("NS_Posting Date", "NS_Entry No");
                    PertaofCompLocal.SetRange("NS_Job No.", JobLocal."No.");
                    if PertaofCompLocal.FindLast() then begin
                        JobLocal."NS_Last Forecast Posted Date" := PertaofCompLocal."NS_Posting Date";
                        JobLocal.Modify();
                    end;
                end;
                //CTSI-196 end

                //
            end;
        }
    }



    trigger OnInitReport();
    begin
        GLSetup.GET();
        FullWorksheet := true;
    end;

    var
        BudgetedCosts: Decimal;
        Job: Record Job;
        JobTask: Record "Job Task";
        JobTask2: Record "Job Task";
        jobsetup: Record "Jobs Setup";
        JobPlanningLineBudget: Record "Job Planning Line";
        PreviousJobForecast: Record "NS_Job Forecast";
        JobForecastUnposted: Record "NS_Job Forecast";
        GLSetup: Record "General Ledger Setup";
        JobNo: Code[20];
        AsOfDate: Date;
        JobName: Text[100];
        LineTotalBudget: Decimal;
        BudgetRemaining: Decimal;
        BudgetPercentageUsed: Decimal;
        ForecastedCompletedCost: Decimal;
        ForecastedVariance: Decimal;
        TotalForecastedCompletedCost: Decimal;
        TotalCostsUsed: Decimal;
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
        PertaofComp: Record "NS_Percentage of Completion";

    /// <summary>
    /// Set.
    /// </summary>
    /// <param name="JobNoIn">Code[20].</param>
    /// <param name="AsOfDateIn">Date.</param>
    procedure Set(JobNoIn: Code[20]; AsOfDateIn: Date);
    begin
        JobNo := JobNoIn;
        AsOfDate := AsOfDateIn;
        "Job Forecast".SETRANGE("NS_Job No.", JobNo);
    end;

}

