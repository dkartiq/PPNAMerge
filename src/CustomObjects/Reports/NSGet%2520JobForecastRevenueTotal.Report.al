report 14021189 "NS_Get JobForecastRevenueTotal"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    Caption = 'Get Job Forecast Revenue Total';
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem(JobForecastClearCurrentValue; "NS_Job Forecast")
        {

            trigger OnAfterGetRecord();
            begin
                //PE-192.NC.1.0 11Apr2024 Start Block
                // "NS_Bill Percent" := 0;
                // "NS_Bill Date" := 0D;
                // MODIFY();
                //PE-192.NC.1.0 11Apr2024 End Block
            end;

            trigger OnPreDataItem();
            begin
                RESET();
                SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date");
                SETRANGE("NS_Job No.", JobNo);
                SETRANGE(NS_Posted, false);
                SETRANGE("NS_Entry Type", "NS_Entry Type"::Price);
            end;
        }
        dataitem(JobForecastSetup; "NS_Job Forecast")
        {

            trigger OnAfterGetRecord();
            begin
                //PRJ-1133.NK.1.0 Start
                //with JobForecastWork do begin
                JobForecastWork := JobForecastSetup;

                //Add a new cost line to the temporary table
                JobForecastTemp.INIT();
                JobForecastTemp."NS_Job No." := JobForecastWork."NS_Job No.";
                JobForecastTemp."NS_Job Task No." := JobForecastWork."NS_Job Task No.";
                NS_GetJobPlanningLineAndBudget(JobForecastWork."NS_Job No.", JobForecastWork."NS_Job Task No.", JobPlanningLine, TaskBudget, AsOfDate);//PRJ-565
                JobForecastTemp."NS_Task Budget" := TaskBudget;
                if not JobForecastTemp.INSERT() then begin
                    JobForecastTemp.GET(JobForecastWork."NS_Job No.", JobForecastWork."NS_Job Task No.", 0);
                    JobForecastTemp."NS_Task Budget" := JobForecastTemp."NS_Task Budget" + TaskBudget;
                    JobForecastTemp.MODIFY();
                end;

                //Update the Task Budget in the temporary table's related sales task
                //Look up the cost's sales link
                Category := '';
                Job.NS_JobTaskNoToAPO(JobForecastWork."NS_Job Task No.", ActivityCode, ProcessCode, OperationCode, SectionCode);//PRJ-688.AM.1.0
                APOLinksHeader.NS_Translate(JobForecastWork."NS_Job No.", 1, ActivityCode, ProcessCode, OperationCode, Category);
                if COPYSTR(ActivityCode, 1, 1) <> ' ' then
                    JobForecastWork."NS_Job Task No." := COPYSTR(Job.APOToJobTaskNo(ActivityCode, ProcessCode, OperationCode, SectionCode), 1, 20)//PRJ-688.AM.1.0
                else
                    JobForecastWork."NS_Job Task No." := '';
                JobForecastTemp.RESET();
                JobForecastTemp.SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date");
                JobForecastTemp.SETRANGE("NS_Job No.", JobForecastWork."NS_Job No.");
                JobForecastTemp.SETRANGE("NS_Job Task No.", JobForecastWork."NS_Job Task No.");
                if not JobForecastTemp.FINDSET(true) then begin
                    //Create a new sales record
                    JobForecastTemp.INIT();
                    JobForecastTemp."NS_Job No." := JobForecastWork."NS_Job No.";
                    JobForecastTemp."NS_Job Task No." := JobForecastWork."NS_Job Task No.";
                    JobForecastTemp.INSERT();
                end;
                JobForecastTemp."NS_Task Budget" := JobForecastTemp."NS_Task Budget" + TaskBudget;
                JobForecastTemp.MODIFY();
                JobForecastTaskHold := JobForecastWork."NS_Job Task No.";


                //Update base code record with the Task ID for the revenue side
                JobForecastTemp.RESET();
                JobForecastTemp.SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date");
                JobForecastTemp.SETRANGE("NS_Job No.", JobForecastSetup."NS_Job No.");
                JobForecastTemp.SETRANGE("NS_Job Task No.", JobForecastSetup."NS_Job Task No.");
                JobForecastTemp.FINDFIRST();
                JobForecastTemp."NS_Sales Task No." := JobForecastTaskHold;
                JobForecastTemp.MODIFY();

                //Accumulate all the budgets for the whole job
                TotalBudget := TotalBudget + TaskBudget;
                //end;
                //PRJ-1133.NK.1.0 End
            end;

            trigger OnPostDataItem();
            var
                i: Integer;
            begin
                //Duplicate JobForecastTemp to JobForcastTemp2
                JobForecastTemp2.RESET();
                JobForecastTemp2.DELETEALL();

                JobForecastTemp.RESET();
                if JobForecastTemp.FINDSET() then
                    repeat
                        JobForecastTemp2 := JobForecastTemp;
                        JobForecastTemp2.INSERT();
                    until JobForecastTemp.NEXT() = 0;


                JobForecastTemp.RESET();
                if JobForecastTemp.FINDSET() then
                    repeat
                        if JobForecastTemp."NS_Sales Task No." <> '' then begin
                            //Read the sales task in JobForcastTemp2
                            JobForecastTemp2.RESET();
                            JobForecastTemp2.SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date");
                            JobForecastTemp2.SETRANGE("NS_Job No.", JobForecastTemp."NS_Job No.");
                            JobForecastTemp2.SETRANGE("NS_Job Task No.", JobForecastTemp."NS_Sales Task No.");
                            JobForecastTemp2.FINDFIRST();

                            if JobForecastTemp2."NS_Task Budget" <> 0 then
                                JobForecastTemp."NS_Task Budget Percent" := JobForecastTemp."NS_Task Budget" / JobForecastTemp2."NS_Task Budget"
                            else
                                JobForecastTemp."NS_Task Budget Percent" := 0;
                            JobForecastTemp.MODIFY();
                        end;
                    until JobForecastTemp.NEXT() = 0;


                JobForecastTemp2.RESET();
                JobForecastTemp2.DELETEALL();
            end;

            trigger OnPreDataItem();
            begin
                RESET();
                SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date");
                SETRANGE("NS_Job No.", JobNo);
                SETRANGE(NS_Posted, false);
                SETFILTER("NS_Status Date", '<=%1', PeriodEndDate);
                SETRANGE("NS_Entry Type", "NS_Entry Type"::Cost);
            end;
        }
        dataitem(JobForecastCalculate; "NS_Job Forecast")
        {
            DataItemTableView = SORTING("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date") ORDER(Ascending);

            trigger OnAfterGetRecord();
            begin
                //PRJ-1133.NK.1.0 Start
                //with JobForecastWork do begin

                JobForecastWork := JobForecastCalculate;
                //PE-192.NC.1.0 11Apr2024 Start 
                // if JobForecastWork."NS_Bill Percent" > 0 then begin
                // JobForecastTemp.GET(JobForecastWork."NS_Job No.", JobForecastWork."NS_Job Task No.", 0);
                // JobForecastTemp."NS_Average Percent Complete" := (JobForecastWork."NS_Bill Percent" / 100) * JobForecastTemp."NS_Task Budget Percent";
                // JobForecastTemp."NS_Earned Billing" := JobForecastTemp."NS_Average Percent Complete" * TotalBudget;
                // JobForecastTemp.MODIFY();
                // AmountToForward := JobForecastTemp."NS_Earned Billing";
                // PercentToForward := JobForecastTemp."NS_Average Percent Complete";

                // //Update temporary table
                // JobForecastTemp.RESET();
                // JobForecastTemp.SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date");
                // JobForecastTemp.SETRANGE("NS_Job No.", JobForecastWork."NS_Job No.");
                // JobForecastTemp.SETRANGE("NS_Job Task No.", JobForecastTemp."NS_Sales Task No.");
                // JobForecastTemp.FINDFIRST();
                // JobForecastTemp."NS_Earned Billing" := JobForecastTemp."NS_Earned Billing" + AmountToForward;
                // JobForecastTemp."NS_Average Percent Complete" := JobForecastTemp."NS_Average Percent Complete" + PercentToForward;

                // JobForecastTemp.MODIFY();

                // end;

                JobForecastWork.Reset();
                JobForecastWork.SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date");
                JobForecastWork.SETRANGE("NS_Job No.", "NS_Job No.");
                JobForecastWork.SETRANGE("NS_Job Task No.", "NS_Job Task No.");
                if JobForecastWork.FINDSET(true) then begin
                    if JobForecastWork."NS_Forecasted Completed Cost" <> 0 then begin
                        JobForecastWork."NS_Earned Billing" := (((NS_GetSumOfTotalCostsUse(JobForecastWork."NS_Job No.", JobForecastWork."NS_Job Task No.", AsOfDate)) / JobForecastWork."NS_Forecasted Completed Cost") * 100 * NS_CalcContractPrice(JobForecastWork."NS_Job Task No."));
                        JobForecastWork.Modify();
                    end;
                end;
                //PE-192.NC.1.0 11Apr2024 End 
                //end;
                //PRJ-1133.NK.1.0 End
            end;

            trigger OnPreDataItem();
            begin
                RESET;
                SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date");
                SETRANGE("NS_Job No.", JobNo);
                SETRANGE(NS_Posted, false);
                SETFILTER("NS_Status Date", '<=%1', PeriodEndDate);
                SETRANGE("NS_Entry Type", "NS_Entry Type"::Cost);
            end;
        }
        dataitem(JobForecastUpdate; "NS_Job Forecast")
        {
            DataItemTableView = SORTING("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date") ORDER(Ascending);

            trigger OnAfterGetRecord();
            begin
                JobForecastTemp.RESET();
                JobForecastTemp.SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date");
                JobForecastTemp.SETRANGE("NS_Job No.", "NS_Job No.");
                JobForecastTemp.SETRANGE("NS_Job Task No.", "NS_Job Task No.");
                if JobForecastTemp.FINDSET() then begin
                    //PE-192.NC.1.0 11Apr2024 Start 
                    //"NS_Bill Percent" := ROUND(JobForecastTemp."NS_Average Percent Complete" * 100, 0.01);
                    // if "NS_Bill Percent" > 100 then
                    //     "NS_Bill Percent" := 100;
                    // "NS_Bill Date" := NextBillDate;
                    //PE-192.NC.1.0 11Apr2024 End 
                    "NS_Status Date" := AsOfDate;
                    MODIFY();
                end;
                //PE-192.NC.1.0 11Apr2024 Start
                JobForecastWork.Reset();
                JobForecastWork.SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date");
                JobForecastWork.SETRANGE("NS_Job No.", "NS_Job No.");
                JobForecastWork.SETRANGE("NS_Job Task No.", "NS_Job Task No.");
                if JobForecastWork.FINDSET(true) then begin
                    if JobForecastWork."NS_Forecasted Completed Cost" <> 0 then begin
                        JobForecastWork."NS_Earned Billing" := (((NS_GetSumOfTotalCostsUse(JobForecastWork."NS_Job No.", JobForecastWork."NS_Job Task No.", AsOfDate)) / JobForecastWork."NS_Forecasted Completed Cost") * 100 * NS_CalcContractPrice(JobForecastWork."NS_Job Task No."));
                        JobForecastWork.Modify();
                    end;
                end;
                //PE-192.NC.1.0 11Apr2024 End 
            end;

            trigger OnPreDataItem();
            begin
                RESET();
                SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date");
                SETRANGE("NS_Job No.", JobNo);
                SETRANGE("NS_Entry Type", "NS_Entry Type"::Price);
                SETRANGE(NS_Posted, false);
                SETFILTER("NS_Status Date", '<=%1', PeriodEndDate);
            end;
        }
    }

    requestpage
    {

        layout
        {
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
        GLSetup.GET;
    end;

    var
        JobLedgEntry: Record "Job Ledger Entry";
        JobForecastWork: Record "NS_Job Forecast";
        JobForecastTemp: Record "NS_Job Forecast" temporary;
        JobForecastTemp2: Record "NS_Job Forecast" temporary;
        JobPlanningLine: Record "Job Planning Line";
        JobTask: Record "Job Task"; //PE-192.NC.1.0 11Apr2024
        Job: Record Job;
        GLSetup: Record "General Ledger Setup";
        APOLinksHeader: Record "NS_APO Links Header";
        JobNo: Code[20];
        NextBillDate: Date;
        PeriodEndDate: Date;
        AsOfDate: Date;
        ActivityCode: Code[10];
        ProcessCode: Code[10];
        OperationCode: Code[10];
        SectionCode: Code[10];//PRJ-688.AM.1.0
        Category: Code[10];
        JobForecastTaskHold: Code[20];
        TaskBudget: Decimal;
        TotalBudget: Decimal;
        AmountToForward: Decimal;
        PercentToForward: Decimal;

    procedure NS_SetJobNo(JobNoIn: Code[20]; NextBillDateIn: Date; PeriodEndDateIn: Date; AsOfDateIn: Date);
    begin
        JobNo := JobNoIn;
        NextBillDate := NextBillDateIn;
        PeriodEndDate := PeriodEndDateIn;
        AsOfDate := AsOfDateIn;
    end;
    //PE-192.NC.1.0 16Apr2024 Start 
    procedure NS_CalcContractPrice(JobTask: Code[20]): Decimal
    var
        PlanningLine: Record "Job Planning Line";
        jobSetup: Record "Jobs Setup";
        Answer: Decimal;
    begin
        Answer := 0;
        if jobSetup.Get() then;
        PlanningLine.Reset();
        PlanningLine.SetRange("Job No.", JobNo);
        PlanningLine.SetRange("Job Task No.", JobTask);
        PlanningLine.SetRange("Contract Line", true);
        PlanningLine.SetFilter("Line Type", '<>%1', PlanningLine."Line Type"::Billable);
        if jobSetup."NS_Enab. Budg.on Contract Date" then
            PlanningLine.SetFilter("NS_Contract Forecast Date", '%1..%2', 0D, AsOfDate)
        else
            PlanningLine.SetFilter("Planning Date", '%1..%2', 0D, AsOfDate);
        if PlanningLine.FindSet() then
            repeat
                Answer += PlanningLine."Line Amount (LCY)";
            until PlanningLine.Next() = 0;
        exit(Answer);
    end;

    procedure NS_GetSumOfTotalCostsUse(JobNo: Code[20]; JobTaskNo: Code[20]; Var ASofDateFilter: date): Decimal;
    var
        JobForcastWork: Record "NS_Job Forecast";
        JobLocal: Record Job;
        SumOfTotalCostsUsed: Decimal;
    begin
        SumOfTotalCostsUsed := 0;
        JobForcastWork.RESET();
        JobForcastWork.SETRANGE("NS_Job No.", JobNo);
        JobForcastWork.SetFilter(NS_Posted, '%1', false);
        if JobForcastWork.FINDSET() then
            repeat
                JobLocal.Reset();
                JobLocal.SetRange("No.", JobNo);
                JobLocal.SetRange("NS_Job Task No. Filter", JobForcastWork."NS_Job Task No.");
                if ASofDateFilter <> 0D then
                    JobLocal.SETFILTER("NS_Date Filter", '..%1', AsOfDateFilter)
                else
                    JobLocal.SETRANGE("NS_Date Filter");
                if JobLocal.FindFirst() then;
                JobLocal.CALCFIELDS("NS_Usage (Cost) (LCY)");
                SumOfTotalCostsUsed := SumOfTotalCostsUsed + JobLocal."NS_Usage (Cost) (LCY)";
            until JobForcastWork.NEXT() = 0;
        exit(SumOfTotalCostsUsed);
    end;
    //PE-192.NC.1.0 16Apr2024 End
}

