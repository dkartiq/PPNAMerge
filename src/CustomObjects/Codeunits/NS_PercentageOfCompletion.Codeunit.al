// version PPNA11.00

// +------------------------------------------------------------
// +ProjectPro
// +  - Developed and licensed by GEMKO Information Group Inc.
// +  - www.dynamicsnavconstruction.com
// +  - www.gemko.com
// +------------------------------------------------------------    
//PE-190.VC.1.0 16Oct2023 | New page for Current Earned Revenue and Profits Analysis
codeunit 14021130 "NS_Percentage of Completion"
{
    TableNo = Job;
    trigger OnRun()
    begin

    end;

    procedure OnAfterGetRecordofReport(Job: Record Job)
    begin
        JobSetupRecord.Get();
        Clear(ToPrintRecognizedRevenue);
        /*
                JobRecRef.SETPOSITION(Job.GETPOSITION);
                if ManagerValue <> '' then
                    Job.SetRange(NS_Manager, ManagerValue);
                if ResponsiblePerson <> '' then
                    Job.SetRange("Person Responsible", ResponsiblePerson);
        */
        JobFilters := Job;
        //JobFilters.COPYFILTERS(Job);

        ForecastedCompletedCost(Job, UseJobForecastWorksheet, UseEnteredPercentComplete,
                                ToPrintContract,
                                ToPrintToDateCost,
                                ToPrintBillings,
                                ToPrintCostEstimate,
                                PercentType);
        /*
                if (UseJobForecastWorksheet = true) then begin
                    clear(PrintCostEstimateSummDetails);
                    Clear(DateGetted);
                    Clear(DateVarStore);

                    JobTable.Reset();
                    JobTable.SetRange("No.", Job."No.");
                    JobTable.SetRange("NS_Sub-Level to Job No.", '');
                    JobTable.SetRange("NS_Exclude from Job Forecast", false);
                    if JobTable.FindFirst() then begin

                        RecProjSummDtl.Reset();
                        RecProjSummDtl.SetCurrentKey("NS_Job No.", "NS_Posting Date");

                        RecProjSummDtl.SetRange("NS_Job No.", JobTable."No.");

                        RecProjSummDtl.SetFilter("NS_Posting Date", Job.GetFilter("NS_Date Filter"));
                        if RecProjSummDtl.FindLast() then
                            PrintCostEstimateSummDetails := RecProjSummDtl."NS_TotalForecastCompletedCost";
                    end
                    ELSE
                        PrintCostEstimateSummDetails := 0;
                end;
        
        if IncludeSubLevelsInMasterJobValues then begin
            SLsForecastedCompletedCost(Job, UseJobForecastWorksheet, UseEnteredPercentComplete,
                                       SLsToPrintContract,
                                       SLsToPrintToDateCost,
                                       SLsToPrintBillings,
                                       SLsToPrintCostEstimate,
                                       SLsPercentType);

            if (UseJobForecastWorksheet = true) then begin
                clear(SLPrintCostEstimateSummDetails);

                SLJobs.RESET;
                SLJobs.SETRANGE("NS_Sub-Level to Job No.", Job."No.");
                SLJobs.SetFilter(Status, Job.GetFilter(Status));
                if JobSetupRecord."NS_GBPG for Job Forecast" > '' then
                    SLJobs.SetFilter("NS_Gen. Bus. Posting Group New", JobsetupRec."NS_GBPG for Job Forecast");
                SLJobs.SetRange("NS_Exclude from Job Forecast", false);
                IF SLJobs.FINDSET THEN
                    REPEAT
                        RecProjSummDtl.Reset();
                        RecProjSummDtl.SetCurrentKey("NS_Job No.", "NS_Posting Date");
                        RecProjSummDtl.SetRange("NS_Job No.", SLJobs."No.");

                        RecProjSummDtl.SetFilter("NS_Posting Date", Job.GetFilter("NS_Date Filter"));
                        if RecProjSummDtl.FindLast() then
                            SLPrintCostEstimateSummDetails += RecProjSummDtl.NS_TotalForecastCompletedCost;
                    UNTIL SLJobs.NEXT = 0;

            END;

            ToPrintContract := ToPrintContract + SLsToPrintContract;
            ToPrintToDateCost := ToPrintToDateCost + SLsToPrintToDateCost;
            ToPrintBillings := ToPrintBillings + SLsToPrintBillings;
            ToPrintCostEstimate := ToPrintCostEstimate;
            if (PrintCostEstimateSummDetails <> 0) or (SLPrintCostEstimateSummDetails <> 0) then
                ToPrintCostEstimate := PrintCostEstimateSummDetails + SLPrintCostEstimateSummDetails
            else
                ToPrintCostEstimate := ToPrintCostEstimate + SLsToPrintCostEstimate;

        end;
*/
        //Get ToPrintPercentComplete either from Job card or from pre-calculated values
        ToPrintPercentComplete := 0;
        if UseJobForecastWorksheet then
            if ToPrintCostEstimate <> 0 then
                ToPrintPercentComplete := 100 - ((ToPrintCostEstimate - ToPrintToDateCost) / ToPrintCostEstimate) * 100;

        if (ToPrintPercentComplete = 0) and UseEnteredPercentComplete then
            if Job."NS_Actual Percent Complete" > 0 then
                ToPrintPercentComplete := Job."NS_Actual Percent Complete";

        if (ToPrintPercentComplete = 0) and UseJobForecastWorksheet then
            //Get from Job Forecast Worksheet
            if ToPrintCostEstimate <> 0 then
                ToPrintPercentComplete := 100 - ((ToPrintCostEstimate - ToPrintToDateCost) / ToPrintCostEstimate) * 100;
        if (ToPrintPercentComplete = 0) or ((UseJobForecastWorksheet = false) and (UseEnteredPercentComplete = false)) then
            //Calculate based on Cost Estimate calculated above
            if ToPrintCostEstimate <> 0 then
                ToPrintPercentComplete := 100 - ((ToPrintCostEstimate - ToPrintToDateCost) / ToPrintCostEstimate) * 100;

        // ToPrintPercentComplete := ROUND(ToPrintPercentComplete, 0.01);//PRJ-543.AS.1.0 Comment
        //ToPrintPercentComplete := ROUND(ToPrintPercentComplete, JobsetupRec."NS_Forecast Amount Rounding");//VC
        ToPrintPercentComplete := ToPrintPercentComplete;//VC
        if ToPrintPercentComplete > 100 then
            ToPrintPercentComplete := 100;

        //ToPrintRecognizedRevenue := ROUND((ToprintContract * (ToPrintPercentComplete / 100)), JobsetupRec."NS_Forecast Amount Rounding");//VC
        ToPrintRecognizedRevenue := (ToprintContract * (ToPrintPercentComplete / 100));//VC
        //Fill in columns on the report
        A := ToPrintContract;
        B := ToPrintBillings;
        C := ToPrintToDateCost;
        D := ToPrintCostEstimate;
        E := ToPrintPercentComplete;
        F := ToPrintRecognizedRevenue;

        DateFilter := Job.GetFilter("NS_Date Filter");
        if DateFilter > '' then
            MaxDate := Job.GetRangeMax("NS_Date Filter");
        if (Job."NS_Actual PercentCompleteDate" <= MaxDate) or (DateFilter = '') then
            if (UseJobForecastWorksheet = true) and (Job."NS_Actual Percent Complete" = 100) and (Job."NS_Actual PercentCompleteDate" <> 0D) then begin
                E := 100;
                D := (C / E) * 100;
            end else begin

            end;

        G := F - C;
        H := 0;
        if B > F then
            H := B - F;

        I := 0;
        if B < F then
            I := F - B;
    end;

    procedure ForecastedCompletedCost(Job: Record Job; Worksheet: Boolean; Manual: Boolean; var BudgetedPrice: Decimal; var ActualCost: Decimal; var ActualBillings: Decimal; var CostEstimate: Decimal; var Source: Text[1]);
    var
        JobSetup: Record "Jobs Setup";
    begin
        //with Job do begin
        Job.COPYFILTERS(JobFilters);

        //Get budget values
        Job.COPYFILTER("NS_Date Filter", Job."Posting Date Filter");
        Job.CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");

        JobSetup.Get();
        if JobSetup."NS_Enab. Budg.on Contract Date" then
            BudgetedPrice := FindContDaseBaseAmt(Job)
        else
            BudgetedPrice := Job."NS_Budgeted Price (LCY)";

        //Get actual values
        ActualCost := FindUsageCost(Job);
        ActualBillings := FindInvoicedPrice(Job);

        //The percent complete can come from one of three places.
        //  1.  The Cost to Complete Worksheet
        //  2.  The Percent Complete entered on the job cards
        //  3.  A calculation based on the cost budget and the current costs used
        //
        //  Options one and two will only be used if the options have been checked in the option tab
        //    when the report is run.
        //  The values will attempt to get a value at the lowest numbered choice available and move higher
        //    until a value is found.  There will always be a value at number three, even if zero is to be used.

        CostEstimate := 0;
        Source := '';
        case true of
            Worksheet:
                begin                             // Using the Cost To Complete Worksheet
                                                  //CostEstimate := JobForecast.NS_ForecastedCompletedAmt(2, Job."No.", '', Job.GETFILTER("NS_Date Filter")); //PRJ-1056.JS.1.0 24Nov2021
                    CostEstimate := JobForecast.NS_ForecastedCompletedAmtPOC(2, Job."No.", '', Job.GETFILTER("NS_Date Filter"));//PRJ-1056
                                                                                                                                //CostEstimate := JobForecast.ForeCostAtCompFromWorksheet(Job."No.",'',Job.GETFILTER("Date Filter"));
                    Source := WorksheetCode;
                    if Manual and  // If Manual percent is available AND
                       (CostEstimate = 0) and  // the Cost To Complete Worksheet did not yield a value AND
                       (Job."NS_Actual Percent Complete" > 0) and  // there is an "Actual Percent Complete" entered on the Job Card AND
                       (ActualCost > 0) and  // there is a "To Date Cost" to work with
                       DateInRange(Job."NS_Actual PercentCompleteDate",
                                   Job.GETFILTER("NS_Date Filter"))    // the "Actual Percent Complete Date" is within any entered date filter
                       then begin
                        //CostEstimate := ROUND((ActualCost * 100) / Job."NS_Actual Percent Complete", 0.01);//VC
                        CostEstimate := (ActualCost * 100) / Job."NS_Actual Percent Complete";//VC
                        Source := ManualCode;
                    end;
                    if CostEstimate = 0 then begin              // If the Worksheet and the Manual percent did not yield a value
                        CostEstimate := Job."NS_Budgeted Cost (LCY)";
                        Source := CalculatedCode;
                    end;
                end;

            Manual and          // Using the Manual percent AND
              (Job."NS_Actual Percent Complete" > 0) and          // there is an "Actual Percent Complete" entered on the Job Card AND
              (ActualCost > 0) and          // there is a "To Date Cost" to work with
              DateInRange(Job."NS_Actual PercentCompleteDate",  // the "Actual Percent Complete Date" is within any entered date filter
                          Job.GETFILTER("NS_Date Filter")):
                begin
                    //CostEstimate := ROUND((ActualCost * 100) / Job."NS_Actual Percent Complete", 0.01);//
                    CostEstimate := (ActualCost * 100) / Job."NS_Actual Percent Complete";//VC
                    Source := ManualCode;
                    if CostEstimate = 0 then begin                   // The Manual percent did not yield a value
                        CostEstimate := Job."NS_Budgeted Cost (LCY)";
                        Source := CalculatedCode;
                    end;
                end;

            else begin                                         // Neither the Worksheet nor the Manual percent is being used
                CostEstimate := Job."NS_Budgeted Cost (LCY)";
                Source := CalculatedCode;
            end;
        end;
    end;

    procedure FindContDaseBaseAmt(Job: Record Job) ContAmt: Decimal;
    var
        JobPlannLine: Record "Job Planning Line";
    begin
        ContAmt := 0;
        Job.COPYFILTERS(JobFilters);
        JobPlannLine.RESET();
        JobPlannLine.SETRANGE("Job No.", Job."No.");
        JobPlannLine.SetFilter("Line Type", '%1|%2', JobPlannLine."Line Type"::Billable, JobPlannLine."Line Type"::"Both Budget and Billable");
        JobPlannLine.SETFILTER("Job Task No.", job.GetFilter("NS_Job Task No. Filter"));
        JobPlannLine.SetFilter("NS_Revenue Category", Job.GetFilter("NS_Revenue Category Filter"));
        //PE-306.JS.1.0 06JUN2024-Start
        //JobPlannLine.SETFILTER(Type, Job.GetFilter("NS_Type Filter"));
        JobPlannLine.SETFILTER(Type, Job.GetFilter("NS_TypeEnumFilter"));
        //PE-306.JS.1.0 06JUN2024-end
        if Job.GetFilter("Posting Date Filter") <> '' then //PRJ-1554.NK.1.0 20Sep2022 
            JobPlannLine.SETFILTER("NS_Contract Forecast Date", Job.GetFilter("Posting Date Filter"));
        if Job.GetFilter("NS_Date Filter") <> '' then //PRJ-1554.NK.1.0 20Sep2022 
            JobPlannLine.SETFILTER("NS_Contract Forecast Date", Job.GetFilter("NS_Date Filter")); //PRJ-1554.NK.1.0 20Sep2022 
        JobPlannLine.SETFILTER(NS_Adjustment, Job.GetFilter("NS_Adjustment Filter"));
        JobPlannLine.SETFILTER("NS_Shortcut Dimension 1 Code", Job.GetFilter("NS_Global Dimension 1 Filter"));
        JobPlannLine.SETFILTER("NS_Shortcut Dimension 2 Code", Job.GetFilter("NS_Global Dimension 2 Filter"));
        JobPlannLine.SETFILTER("NS_Retention Ledger Code", Job.getfilter("NS_Retention Ledger Filter"));
        if JobPlannLine.FINDSET() then
            repeat
                ContAmt := ContAmt + JobPlannLine."Total Price (LCY)";
            until JobPlannLine.NEXT() = 0;
        exit(ContAmt);
    end;

    procedure FindUsageCost(Job: Record Job) Usage: Decimal;
    begin
        Usage := 0;
        Job.COPYFILTERS(JobFilters);
        JobLedgEntry.RESET();
        JobLedgEntry.SETCURRENTKEY("Job No.", "Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                   "NS_Job Cost Category", "NS_Job Revenue Category", Type, "No.", "Resource Group No.", "Posting Date");
        JobLedgEntry.SETRANGE("Job No.", Job."No.");
        JobLedgEntry.SETRANGE("Entry Type", JobLedgEntry."Entry Type"::Usage);
        JobLedgEntry.SETFILTER("NS_Activity Code", Job.GETFILTER("NS_Activity Filter"));
        JobLedgEntry.SETFILTER("NS_Process Code", Job.GETFILTER("NS_Process Filter"));
        JobLedgEntry.SETFILTER("NS_Operation Code", Job.GETFILTER("NS_Operation Filter"));
        JobLedgEntry.SETFILTER("NS_Job Cost Category", Job.GETFILTER("NS_Cost Category Filter"));
        JobLedgEntry.SETFILTER("Posting Date", Job.GETFILTER("NS_Date Filter"));
        if ExcludeMarkedCostEntries then
            JobLedgEntry.SETRANGE("NS_Exclude Entry", not ExcludeMarkedCostEntries);
        if JobLedgEntry.FINDSET() then
            repeat
                Usage := Usage + JobLedgEntry."Total Cost (LCY)";
                if ShowJobSummaries then
                    SortIntoJob(0, JobLedgEntry."Total Cost");
                if ShowReportSummary then
                    SortIntoFinal(0, JobLedgEntry."Total Cost");
            until JobLedgEntry.NEXT() = 0;
    end;

    procedure FindInvoicedPrice(Job: Record Job) Price: Decimal;
    begin
        Price := 0;
        Job.COPYFILTERS(JobFilters);
        JobLedgEntry.RESET();
        JobLedgEntry.SETCURRENTKEY("Job No.", "Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                   "NS_Job Cost Category", "NS_Job Revenue Category", Type, "No.", "Resource Group No.", "Posting Date");
        JobLedgEntry.SETRANGE("Job No.", Job."No.");
        JobLedgEntry.SETRANGE("Entry Type", JobLedgEntry."Entry Type"::Sale);
        JobLedgEntry.SETFILTER("NS_Activity Code", Job.GETFILTER("NS_Activity Filter"));
        JobLedgEntry.SETFILTER("NS_Process Code", Job.GETFILTER("NS_Process Filter"));
        JobLedgEntry.SETFILTER("NS_Operation Code", Job.GETFILTER("NS_Operation Filter"));
        JobLedgEntry.SETFILTER("NS_Job Revenue Category", Job.GETFILTER("NS_Revenue Category Filter"));
        JobLedgEntry.SETFILTER("Posting Date", Job.GETFILTER("NS_Date Filter"));
        if ExcludeMarkedPriceEntries then
            JobLedgEntry.SETRANGE("NS_Exclude Entry", not ExcludeMarkedPriceEntries);
        if JobLedgEntry.FINDSET() then
            repeat
                Price := Price - JobLedgEntry."Total Price (LCY)";
                if ShowJobSummaries then
                    SortIntoJob(-JobLedgEntry."Total Price", 0);
                if ShowReportSummary then
                    SortIntoFinal(-JobLedgEntry."Total Price", 0);
            until JobLedgEntry.NEXT() = 0;
    end;

    procedure DateInRange(TestDate: Date; Range: Text[30]) InRange: Boolean;
    var
        DateFrom: Date;
        DateTo: Date;
        RangeStart: Decimal;
    begin
        InRange := true;
        if (TestDate <> 0D) and (Range > '') then begin
            RangeStart := STRPOS(Range, '..');
            case true of
                RangeStart = 0:
                    begin
                        EVALUATE(DateFrom, Range);
                        EVALUATE(DateTo, Range);
                    end;
                RangeStart = 1:
                    DateFrom := 00010103D;
                RangeStart = STRLEN(Range) - 2:
                    DateTo := 99991231D;
            end;
            if DateFrom = 0D then begin
                EVALUATE(DateFrom, COPYSTR(Range, 1, RangeStart - 1));
            end;
            if DateTo = 0D then begin
                EVALUATE(DateTo, COPYSTR(Range, RangeStart + 2));
            end;
            if (DateFrom > 0D) and (DateTo > 0D) then
                InRange := (TestDate >= DateFrom) and (TestDate <= DateTo);
        end;
    end;

    procedure SortIntoJob(Billings: Decimal; Cost: Decimal);
    var
        Found: Boolean;
    begin
        //This routine adds the Job Ledger Entry into a Job summary array for printing later by
        //     Global Dimension 1 Code
        //Look to see if there is a Global Dimension 1 code in the table already that we can just add to

        Found := false;
        if TopPointer > 0 then begin
            CurrentPointer := 1;
            repeat
                if SummaryGlobalDim1[CurrentPointer] = JobLedgEntry."Global Dimension 1 Code" then begin
                    SummaryB[CurrentPointer] := SummaryB[CurrentPointer] + Billings;
                    SummaryC[CurrentPointer] := SummaryC[CurrentPointer] + Cost;
                    Found := true;
                end;
                CurrentPointer := CurrentPointer + 1;
            until (CurrentPointer > TopPointer) or
                  (SummaryGlobalDim1[CurrentPointer] > JobLedgEntry."Global Dimension 1 Code") or
                  Found;
        end;

        if not Found then begin
            TopPointer := TopPointer + 1;
            SummaryGlobalDim1[TopPointer] := JobLedgEntry."Global Dimension 1 Code";
            SummaryB[TopPointer] := Billings;
            SummaryC[TopPointer] := Cost;
            CurrentPointer := TopPointer;
            while CurrentPointer > 1 do begin
                CurrentPointer := CurrentPointer - 1;
                if (SummaryGlobalDim1[CurrentPointer + 1] < SummaryGlobalDim1[CurrentPointer]) then begin
                    TempGlobalDim1 := SummaryGlobalDim1[CurrentPointer];
                    TempSummaryB := SummaryB[CurrentPointer];
                    TempSummaryC := SummaryC[CurrentPointer];
                    SummaryGlobalDim1[CurrentPointer] := SummaryGlobalDim1[CurrentPointer + 1];
                    SummaryB[CurrentPointer] := SummaryB[CurrentPointer + 1];
                    SummaryC[CurrentPointer] := SummaryC[CurrentPointer + 1];
                    SummaryGlobalDim1[CurrentPointer + 1] := TempGlobalDim1;
                    SummaryB[CurrentPointer + 1] := TempSummaryB;
                    SummaryC[CurrentPointer + 1] := TempSummaryC;
                end;
            end;
        end;
    end;

    procedure SortIntoFinal(Billings: Decimal; Cost: Decimal);
    var
        Found: Boolean;
    begin
        //This routine adds the Job Ledger Entry into a Report summary array for printing later by
        //     Global Dimension 1 Code
        //Look to see if there is a Global Dimension 1 code in the table already that we can just add to

        Found := false;
        if FinalTopPointer > 0 then begin
            FinalCurrentPointer := 1;
            repeat
                if FinalSummaryGlobalDim1[FinalCurrentPointer] = JobLedgEntry."Global Dimension 1 Code" then begin
                    FinalSummaryB[FinalCurrentPointer] := FinalSummaryB[FinalCurrentPointer] + Billings;
                    FinalSummaryC[FinalCurrentPointer] := FinalSummaryC[FinalCurrentPointer] + Cost;
                    Found := true;
                end;
                FinalCurrentPointer := FinalCurrentPointer + 1;
            until (FinalCurrentPointer > FinalTopPointer) or
                  (FinalSummaryGlobalDim1[FinalCurrentPointer] > JobLedgEntry."Global Dimension 1 Code") or
                  Found;
        end;

        if not Found then begin
            FinalTopPointer := FinalTopPointer + 1;
            FinalSummaryGlobalDim1[FinalTopPointer] := JobLedgEntry."Global Dimension 1 Code";
            FinalSummaryB[FinalTopPointer] := Billings;
            FinalSummaryC[FinalTopPointer] := Cost;
            FinalCurrentPointer := FinalTopPointer;
            while FinalCurrentPointer > 1 do begin
                FinalCurrentPointer := FinalCurrentPointer - 1;
                if (FinalSummaryGlobalDim1[FinalCurrentPointer + 1] < FinalSummaryGlobalDim1[FinalCurrentPointer]) then begin
                    TempGlobalDim1 := FinalSummaryGlobalDim1[FinalCurrentPointer];
                    TempSummaryB := FinalSummaryB[FinalCurrentPointer];
                    TempSummaryC := FinalSummaryC[FinalCurrentPointer];
                    FinalSummaryGlobalDim1[FinalCurrentPointer] := FinalSummaryGlobalDim1[FinalCurrentPointer + 1];
                    FinalSummaryB[FinalCurrentPointer] := FinalSummaryB[FinalCurrentPointer + 1];
                    FinalSummaryC[FinalCurrentPointer] := FinalSummaryC[FinalCurrentPointer + 1];
                    FinalSummaryGlobalDim1[FinalCurrentPointer + 1] := TempGlobalDim1;
                    FinalSummaryB[FinalCurrentPointer + 1] := TempSummaryB;
                    FinalSummaryC[FinalCurrentPointer + 1] := TempSummaryC;
                end;
            end;
        end;
    end;
    /*
        procedure SLsForecastedCompletedCost(ParentJob: Record Job; Worksheet: Boolean; Manual: Boolean; var BudgetedPrice: Decimal; var ActualCost: Decimal; var ActualBillings: Decimal; var CostEstimate: Decimal; var PercentType: Text[1]);
        var
            JobSearch: Record Job;
            ProjectedToPrintContract: Decimal;
            ProjectedToPrintToDateCost: Decimal;
            ProjectedToPrintBillings: Decimal;
            ProjectedToPrintTotalCostEst: Decimal;
            SLsProjectedToPrintContract: Decimal;
            SLsProjectedToPrintToDateCost: Decimal;
            SLsProjectedToPrintBillings: Decimal;
            SLsProjectedToPrintTotalCostEs: Decimal;
            PercentTypeHold: Text[1];
        begin
            //Find the Project Cost at Completion using the Completion Status Worksheet going down all
            //  sublevels from the ParentJob passed in.

            BudgetedPrice := 0;
            ActualCost := 0;
            ActualBillings := 0;
            CostEstimate := 0;
            SLsProjectedToPrintTotalCostEs := 0;
            ProjectedToPrintTotalCostEst := 0;

            //with JobSearch do begin
            JobSearch.COPYFILTERS(JobFilters);
            JobSearch.RESET();
            JobSearch.SETCURRENTKEY("NS_Sub-Level to Job No.");
            JobSearch.SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            //JobSearch.SetFilter(Status, Job.GetFilter(Status));//VC

            JobSearch.SetRange("NS_Exclude from Job Forecast", false);
            if GBPGValTxt > '' then
                JobSearch.SetFilter("NS_Gen. Bus. Posting Group New", GBPGValTxt);
            if JobSearch.FINDSET() then
                repeat
                    PercentTypeHold := PercentType;
                    ForecastedCompletedCost(JobSearch, Worksheet, Manual,
                                            ProjectedToPrintContract,
                                            ProjectedToPrintToDateCost,
                                            ProjectedToPrintBillings,
                                            ProjectedToPrintTotalCostEst,
                                            PercentType);
                    PercentType := PercentTypeOverride(PercentTypeHold, PercentType);
                    PercentTypeHold := PercentType;
                    SLsForecastedCompletedCost(JobSearch, Worksheet, Manual,
                                               SLsProjectedToPrintContract,
                                               SLsProjectedToPrintToDateCost,
                                               SLsProjectedToPrintBillings,
                                               SLsProjectedToPrintTotalCostEs,
                                               SLsPercentType);
                    PercentType := PercentTypeOverride(PercentTypeHold, SLsPercentType);
                    PercentTypeHold := PercentType;
                    BudgetedPrice := BudgetedPrice + ProjectedToPrintContract + SLsProjectedToPrintContract;
                    ActualCost := ActualCost + ProjectedToPrintToDateCost + SLsProjectedToPrintToDateCost;
                    ActualBillings := ActualBillings + ProjectedToPrintBillings + SLsProjectedToPrintBillings;
                    CostEstimate := CostEstimate + ProjectedToPrintTotalCostEst + SLsProjectedToPrintTotalCostEs;
                until JobSearch.NEXT() = 0;
        end;
    
    procedure PercentTypeOverride(OrigType: Text[1]; NewType: Text[1]): Text[1];
    begin
        //Compare the OriginalType to the NewType and return the higher level
        //  From high to low the order is Worksheet, Manual, NewType to be returned
        if (OrigType = '') or
           (OrigType = NewType) then
            exit(NewType);

        if (OrigType = ManualCode) and (NewType = WorksheetCode) then
            exit(NewType);

        if (OrigType = CalculatedCode) and
           ((NewType = WorksheetCode) or (NewType = ManualCode)) then
            exit(NewType);

        exit(OrigType);
    end;
*/
    procedure GetContractPrice(): Decimal
    begin
        exit(A);
    end;

    procedure GetActualCostToDate(): Decimal
    begin
        exit(C);
    end;

    procedure GetETC(): Decimal
    begin
        exit(D);
    end;

    procedure GetPctCompleted(): Decimal
    begin
        exit(E);
    end;

    procedure GetEarnRevenue(): Decimal
    begin
        exit(F);
    end;
    //PRJCTPR-323.PS.1.0 01March2024 Start
    procedure NS_JobPlaningLineLockedCostAmt(Var NS_Job: Record Job): Decimal
    var
        NS_LockedJobPlaningLine: Record "NS_Locked Job Planning Line";
        NS_LockedCost: Decimal;
    Begin
        NS_LockedCost := 0;
        NS_LockedJobPlaningLine.SetRange("NS_Job No.", NS_Job."No.");
        NS_LockedJobPlaningLine.SetFilter("NS_Line Type", '%1|%2', NS_LockedJobPlaningLine."NS_Line Type"::Budget, NS_LockedJobPlaningLine."NS_Line Type"::"Both Budget and Billable");
        if NS_LockedJobPlaningLine.FindSet() then begin
            repeat
                NS_LockedCost += NS_LockedJobPlaningLine."NS_Total Cost (LCY)";
            until NS_LockedJobPlaningLine.Next = 0;
            exit(NS_LockedCost);

        End;
    End;

    procedure NS_JobPlaningLineLockedPriceAmt(Var NS_Job: Record Job): Decimal
    var
        NS_LockedJobPlaningLine: Record "NS_Locked Job Planning Line";
        NS_LockedPrice: Decimal;

    Begin
        NS_LockedPrice := 0;
        NS_LockedJobPlaningLine.SetRange("NS_Job No.", NS_Job."No.");
        NS_LockedJobPlaningLine.SetFilter("NS_Line Type", '%1|%2', NS_LockedJobPlaningLine."NS_Line Type"::Billable, NS_LockedJobPlaningLine."NS_Line Type"::"Both Budget and Billable");
        if NS_LockedJobPlaningLine.FindSet() then begin
            repeat
                NS_LockedPrice += NS_LockedJobPlaningLine."NS_Line Amount (LCY)";
            until NS_LockedJobPlaningLine.Next = 0;
            exit(NS_LockedPrice);

        end;
    End;

    procedure NS_UnpostedRevenueRecognitionConPrice(var NSJob: Record Job): Decimal
    var
        NS_LocalRevenueRecSummaryTab: Record NS_RevenueRecSummaryTab;
    begin
        NS_LocalRevenueRecSummaryTab.Reset();
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Job No.", NSJob."No.");
        NS_LocalRevenueRecSummaryTab.SetRange(NS_Posted, false);
        NS_LocalRevenueRecSummaryTab.SetRange(NS_Voided, false);
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Over/Under Billings Posted", false);
        if NS_LocalRevenueRecSummaryTab.FindLast() then begin
            NS_UnpostedContractPrice := NS_LocalRevenueRecSummaryTab."NS_Current Contract";
        end;
        exit(NS_UnpostedContractPrice);
    end;

    procedure NS_UnpostedRevenueRecognitionConETC(var NSJob: Record Job): Decimal
    var
        NS_LocalRevenueRecSummaryTab: Record NS_RevenueRecSummaryTab;
    begin
        NS_LocalRevenueRecSummaryTab.Reset();
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Job No.", NSJob."No.");
        NS_LocalRevenueRecSummaryTab.SetRange(NS_Posted, false);
        NS_LocalRevenueRecSummaryTab.SetRange(NS_Voided, false);
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Over/Under Billings Posted", false);
        if NS_LocalRevenueRecSummaryTab.FindLast() then begin
            NS_UnpostedETC := NS_LocalRevenueRecSummaryTab."NS_Current(TCE) Est. Cost at Completion";
        end;
        exit(NS_UnpostedETC);
    end;

    procedure NS_UnpostedRevenueRecognitionConActualCosttodate(var NSJob: Record Job): Decimal
    var
        NS_LocalRevenueRecSummaryTab: Record NS_RevenueRecSummaryTab;
    begin
        NS_LocalRevenueRecSummaryTab.Reset();
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Job No.", NSJob."No.");
        NS_LocalRevenueRecSummaryTab.SetRange(NS_Posted, false);
        NS_LocalRevenueRecSummaryTab.SetRange(NS_Voided, false);
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Over/Under Billings Posted", false);
        if NS_LocalRevenueRecSummaryTab.FindLast() then begin
            NS_UnpostedActualCosttodate := NS_LocalRevenueRecSummaryTab."NS_Actual Costs To Date";
        end;
        exit(NS_UnpostedActualCosttodate);
    end;

    procedure NS_UnpostedRevenueRecognitionPostingdate(var NSJob: Record Job): Date
    var
        NS_LocalRevenueRecSummaryTab: Record NS_RevenueRecSummaryTab;
    begin
        NS_LocalRevenueRecSummaryTab.Reset();
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Job No.", NSJob."No.");
        NS_LocalRevenueRecSummaryTab.SetRange(NS_Posted, false);
        NS_LocalRevenueRecSummaryTab.SetRange(NS_Voided, false);
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Over/Under Billings Posted", false);
        if NS_LocalRevenueRecSummaryTab.FindLast() then begin
            NS_UnpostedPostingdate := NS_LocalRevenueRecSummaryTab."NS_Posting Date";
        end;
        exit(NS_UnpostedPostingdate);
    end;

    procedure NSUnPostedCompletedPer(var NSJob: Record Job): Decimal
    var
        NS_LocalRevenueRecSummaryTab: Record NS_RevenueRecSummaryTab;
    begin
        NS_LocalRevenueRecSummaryTab.Reset();
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Job No.", NSJob."No.");
        NS_LocalRevenueRecSummaryTab.SetRange(NS_Posted, false);
        NS_LocalRevenueRecSummaryTab.SetRange(NS_Voided, false);
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Over/Under Billings Posted", false);
        if NS_LocalRevenueRecSummaryTab.FindLast() then begin
            NS_UnPostedCompletedPer := NS_LocalRevenueRecSummaryTab."NS_POC %";
        end;
        exit(NS_UnPostedCompletedPer);
    end;

    procedure NSUnPostedEarnedRevenue(var NSJob: Record Job): Decimal
    var
        NS_LocalRevenueRecSummaryTab: Record NS_RevenueRecSummaryTab;
    begin
        NS_LocalRevenueRecSummaryTab.Reset();
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Job No.", NSJob."No.");
        NS_LocalRevenueRecSummaryTab.SetRange(NS_Posted, false);
        NS_LocalRevenueRecSummaryTab.SetRange(NS_Voided, false);
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Over/Under Billings Posted", false);
        if NS_LocalRevenueRecSummaryTab.FindLast() then begin
            NS_UnPostedEarnedRevenue := NS_LocalRevenueRecSummaryTab."NS_Gross Revenue";
        end;
        exit(NS_UnPostedEarnedRevenue);
    end;

    procedure NSUnPostedGrossProfit(var NSJob: Record Job): Decimal
    var
        NS_LocalRevenueRecSummaryTab: Record NS_RevenueRecSummaryTab;
    begin
        NS_LocalRevenueRecSummaryTab.Reset();
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Job No.", NSJob."No.");
        NS_LocalRevenueRecSummaryTab.SetRange(NS_Posted, false);
        NS_LocalRevenueRecSummaryTab.SetRange(NS_Voided, false);
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Over/Under Billings Posted", false);
        if NS_LocalRevenueRecSummaryTab.FindLast() then begin
            NS_UnPostedGrossProfit := NS_LocalRevenueRecSummaryTab."NS_Gross Profit";
        end;
        exit(NS_UnPostedGrossProfit);
    end;

    procedure NSUNPostedProfitPer(var NSJob: Record Job): Decimal
    var
        NS_LocalRevenueRecSummaryTab: Record NS_RevenueRecSummaryTab;
    begin
        NS_LocalRevenueRecSummaryTab.Reset();
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Job No.", NSJob."No.");
        NS_LocalRevenueRecSummaryTab.SetRange(NS_Posted, false);
        NS_LocalRevenueRecSummaryTab.SetRange(NS_Voided, false);
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Over/Under Billings Posted", false);
        if NS_LocalRevenueRecSummaryTab.FindLast() then begin
            NS_UNPostedProfitPer := NS_LocalRevenueRecSummaryTab."NS_Current GM %";
        end;
        exit(NS_UNPostedProfitPer);
    end;

    procedure NS_UnpostedRevenueRecognitionPOCMethod(var NSJob: Record Job): text[50]
    var
        NS_LocalRevenueRecSummaryTab: Record NS_RevenueRecSummaryTab;
    begin
        NS_LocalRevenueRecSummaryTab.Reset();
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Job No.", NSJob."No.");
        NS_LocalRevenueRecSummaryTab.SetRange(NS_Posted, false);
        NS_LocalRevenueRecSummaryTab.SetRange(NS_Voided, false);
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Over/Under Billings Posted", false);
        if NS_LocalRevenueRecSummaryTab.FindLast() then begin
            NS_UnpostedPOCMethod := Format(NS_LocalRevenueRecSummaryTab."NS_POC Method");
        end;
        exit(NS_UnpostedPOCMethod);
    end;

    ///Posted data ...Code ++



    procedure NS_PostedRevenueRecognitionConActualCosttodate(var NSJob: Record Job): Decimal
    var
        NS_LocalRevenueRecSummaryTab: Record NS_RevenueRecSummaryTab;
    begin
        NS_LocalRevenueRecSummaryTab.Reset();
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Job No.", NSJob."No.");
        NS_LocalRevenueRecSummaryTab.SetRange(NS_Voided, false);
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Over/Under Billings Posted", true);
        if NS_LocalRevenueRecSummaryTab.FindLast() then begin
            NS_PostedActualCosttodate := NS_LocalRevenueRecSummaryTab."NS_Actual Costs To Date";
        end
        else begin
            NS_LocalRevenueRecSummaryTab.Reset();
            NS_LocalRevenueRecSummaryTab.SetRange("NS_Job No.", NSJob."No.");
            NS_LocalRevenueRecSummaryTab.SetRange(NS_Voided, false);
            NS_LocalRevenueRecSummaryTab.SetRange("NS_Posted", true);
            if NS_LocalRevenueRecSummaryTab.FindLast() then begin
                NS_PostedActualCosttodate := NS_LocalRevenueRecSummaryTab."NS_Actual Costs To Date";
            end
        end;
        exit(NS_PostedActualCosttodate);
    end;

    procedure NS_PostedRevenueRecognitionPostingdate(var NSJob: Record Job): Date
    var
        NS_LocalRevenueRecSummaryTab: Record NS_RevenueRecSummaryTab;
    begin
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Job No.", NSJob."No.");
        NS_LocalRevenueRecSummaryTab.SetRange(NS_Voided, false);
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Over/Under Billings Posted", true);
        if NS_LocalRevenueRecSummaryTab.FindLast() then begin
            NS_PostedDatePostingdate := NS_LocalRevenueRecSummaryTab."NS_Posting Date";
        end
        else begin
            NS_LocalRevenueRecSummaryTab.Reset();
            NS_LocalRevenueRecSummaryTab.SetRange("NS_Job No.", NSJob."No.");
            NS_LocalRevenueRecSummaryTab.SetRange(NS_Voided, false);
            NS_LocalRevenueRecSummaryTab.SetRange("NS_Posted", true);
            if NS_LocalRevenueRecSummaryTab.FindLast() then begin
                NS_PostedDatePostingdate := NS_LocalRevenueRecSummaryTab."NS_Posting Date";
            end;
        end;
        exit(NS_PostedDatePostingdate);
    end;

    procedure NS_PostedRevenueRecognitionConETC(var NSJob: Record Job): Decimal
    var
        NS_LocalRevenueRecSummaryTab: Record NS_RevenueRecSummaryTab;
    begin
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Job No.", NSJob."No.");
        NS_LocalRevenueRecSummaryTab.SetRange(NS_Voided, false);
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Over/Under Billings Posted", true);
        if NS_LocalRevenueRecSummaryTab.FindLast() then begin
            NS_PostedETC := NS_LocalRevenueRecSummaryTab."NS_Current(TCE) Est. Cost at Completion";
        end
        else begin
            NS_LocalRevenueRecSummaryTab.Reset();
            NS_LocalRevenueRecSummaryTab.SetRange("NS_Job No.", NSJob."No.");
            NS_LocalRevenueRecSummaryTab.SetRange(NS_Voided, false);
            NS_LocalRevenueRecSummaryTab.SetRange("NS_Posted", true);
            if NS_LocalRevenueRecSummaryTab.FindLast() then begin
                NS_PostedETC := NS_LocalRevenueRecSummaryTab."NS_Current(TCE) Est. Cost at Completion";
            end;
        end;
        exit(NS_PostedETC);
    end;


    procedure NS_PostedRevenueRecognitionConPrice(var NSJob: Record Job): Decimal
    var
        NS_LocalRevenueRecSummaryTab: Record NS_RevenueRecSummaryTab;
    begin
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Job No.", NSJob."No.");
        NS_LocalRevenueRecSummaryTab.SetRange(NS_Voided, false);
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Over/Under Billings Posted", true);
        if NS_LocalRevenueRecSummaryTab.FindLast() then begin
            NS_PostedContractPrice := NS_LocalRevenueRecSummaryTab."NS_Current Contract";
        end
        else begin
            NS_LocalRevenueRecSummaryTab.Reset();
            NS_LocalRevenueRecSummaryTab.SetRange("NS_Job No.", NSJob."No.");
            NS_LocalRevenueRecSummaryTab.SetRange(NS_Voided, false);
            NS_LocalRevenueRecSummaryTab.SetRange("NS_Posted", true);
            if NS_LocalRevenueRecSummaryTab.FindLast() then begin
                NS_PostedContractPrice := NS_LocalRevenueRecSummaryTab."NS_Current Contract";
            end;
        End;
        exit(NS_PostedContractPrice);
    End;
    //PRJCTPR-323.PS.1.0 01March2024 End
    //PRJCTPR-323.PS.2.0 27March2024 Start

    procedure NSPostedCompletedPer(var NSJob: Record Job): Decimal
    var
        NS_LocalRevenueRecSummaryTab: Record NS_RevenueRecSummaryTab;
    begin
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Job No.", NSJob."No.");
        NS_LocalRevenueRecSummaryTab.SetRange(NS_Voided, false);
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Over/Under Billings Posted", true);
        if NS_LocalRevenueRecSummaryTab.FindLast() then begin
            NS_PostedCompletedPer := NS_LocalRevenueRecSummaryTab."NS_POC %";
        end
        else begin
            NS_LocalRevenueRecSummaryTab.Reset();
            NS_LocalRevenueRecSummaryTab.SetRange("NS_Job No.", NSJob."No.");
            NS_LocalRevenueRecSummaryTab.SetRange(NS_Voided, false);
            NS_LocalRevenueRecSummaryTab.SetRange("NS_Posted", true);
            if NS_LocalRevenueRecSummaryTab.FindLast() then begin
                NS_PostedCompletedPer := NS_LocalRevenueRecSummaryTab."NS_POC %";
            end;
        End;
        exit(NS_PostedCompletedPer);
    End;

    procedure NSPostedEarnedRevenue(var NSJob: Record Job): Decimal
    var
        NS_LocalRevenueRecSummaryTab: Record NS_RevenueRecSummaryTab;
    begin
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Job No.", NSJob."No.");
        NS_LocalRevenueRecSummaryTab.SetRange(NS_Voided, false);
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Over/Under Billings Posted", true);
        if NS_LocalRevenueRecSummaryTab.FindLast() then begin
            NS_PostedEarnedRevenue := NS_LocalRevenueRecSummaryTab."NS_Gross Revenue";
        end
        else begin
            NS_LocalRevenueRecSummaryTab.Reset();
            NS_LocalRevenueRecSummaryTab.SetRange("NS_Job No.", NSJob."No.");
            NS_LocalRevenueRecSummaryTab.SetRange(NS_Voided, false);
            NS_LocalRevenueRecSummaryTab.SetRange("NS_Posted", true);
            if NS_LocalRevenueRecSummaryTab.FindLast() then begin
                NS_PostedEarnedRevenue := NS_LocalRevenueRecSummaryTab."NS_Gross Revenue";
            end;
        End;
        exit(NS_PostedEarnedRevenue);
    End;

    procedure NSPostedGrossProfit(var NSJob: Record Job): Decimal
    var
        NS_LocalRevenueRecSummaryTab: Record NS_RevenueRecSummaryTab;
    begin
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Job No.", NSJob."No.");
        NS_LocalRevenueRecSummaryTab.SetRange(NS_Voided, false);
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Over/Under Billings Posted", true);
        if NS_LocalRevenueRecSummaryTab.FindLast() then begin
            NS_PostedGrossProfit := NS_LocalRevenueRecSummaryTab."NS_Gross Profit";
        end
        else begin
            NS_LocalRevenueRecSummaryTab.Reset();
            NS_LocalRevenueRecSummaryTab.SetRange("NS_Job No.", NSJob."No.");
            NS_LocalRevenueRecSummaryTab.SetRange(NS_Voided, false);
            NS_LocalRevenueRecSummaryTab.SetRange("NS_Posted", true);
            if NS_LocalRevenueRecSummaryTab.FindLast() then begin
                NS_PostedGrossProfit := NS_LocalRevenueRecSummaryTab."NS_Gross Profit";
            end;
        End;
        exit(NS_PostedGrossProfit);
    End;

    procedure NSPostedGrossProfitPer(var NSJob: Record Job): Decimal
    var
        NS_LocalRevenueRecSummaryTab: Record NS_RevenueRecSummaryTab;
    begin
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Job No.", NSJob."No.");
        NS_LocalRevenueRecSummaryTab.SetRange(NS_Voided, false);
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Over/Under Billings Posted", true);
        if NS_LocalRevenueRecSummaryTab.FindLast() then begin
            NS_PostedProfitPer := NS_LocalRevenueRecSummaryTab."NS_Current GM %";
        end
        else begin
            NS_LocalRevenueRecSummaryTab.Reset();
            NS_LocalRevenueRecSummaryTab.SetRange("NS_Job No.", NSJob."No.");
            NS_LocalRevenueRecSummaryTab.SetRange(NS_Voided, false);
            NS_LocalRevenueRecSummaryTab.SetRange("NS_Posted", true);
            if NS_LocalRevenueRecSummaryTab.FindLast() then begin
                NS_PostedProfitPer := NS_LocalRevenueRecSummaryTab."NS_Current GM %";
            end;
        End;
        exit(NS_PostedProfitPer);
    End;

    procedure NS_PostedRevenueRecognitionPOCmethod(var NSJob: Record Job): Text[50]
    var
        NS_LocalRevenueRecSummaryTab: Record NS_RevenueRecSummaryTab;
    begin
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Job No.", NSJob."No.");
        NS_LocalRevenueRecSummaryTab.SetRange(NS_Voided, false);
        NS_LocalRevenueRecSummaryTab.SetRange("NS_Over/Under Billings Posted", true);
        if NS_LocalRevenueRecSummaryTab.FindLast() then begin
            NS_PostedPOCMethod := Format(NS_LocalRevenueRecSummaryTab."NS_POC Method");
        end
        else begin
            NS_LocalRevenueRecSummaryTab.Reset();
            NS_LocalRevenueRecSummaryTab.SetRange("NS_Job No.", NSJob."No.");
            NS_LocalRevenueRecSummaryTab.SetRange(NS_Voided, false);
            NS_LocalRevenueRecSummaryTab.SetRange("NS_Posted", true);
            if NS_LocalRevenueRecSummaryTab.FindLast() then begin
                NS_PostedPOCMethod := Format(NS_LocalRevenueRecSummaryTab."NS_POC Method");
            end;
        end;
        exit(NS_PostedPOCMethod);
    end;

    //PRJCTPR-323.PS.2.0 27March2024 End 
    ///Posted data ...Code --


    var
        //PRJCTPR-323.PS.1.0 04March2024 Start
        NS_PostedPOCMethod: Text[50];
        NS_UnpostedPOCMethod: Text[50];
        NS_PostedBool: Boolean;
        NS_PostedDatePostingdate: Date;
        NS_PostedContractPrice: Decimal;
        NS_PostedETC: Decimal;
        NS_PostedActualCosttodate: Decimal;
        //27March
        NS_PostedCompletedPer: Decimal;
        NS_PostedEarnedRevenue: Decimal;
        NS_PostedGrossProfit: Decimal;
        NS_PostedProfitPer: Decimal;
        NS_UnPostedCompletedPer: Decimal;
        NS_UnPostedEarnedRevenue: Decimal;
        NS_UnPostedGrossProfit: Decimal;
        NS_UNPostedProfitPer: Decimal;
        //27March 
        NS_UnpostedContractPrice: Decimal;
        NS_UnpostedETC: Decimal;
        NS_UnpostedActualCosttodate: Decimal;
        NS_UnpostedPostingdate: Date;
        //PRJCTPR-323.PS.1.0 04March2024 End
        JobSetupRecord: Record "Jobs Setup";
        JobFilters: Record Job;
        JobLedgEntry: Record "Job Ledger Entry";
        JobForecast: Record "NS_Job Forecast";

        ToPrintPercentComplete: Decimal;
        ToPrintRecognizedRevenue: Decimal;
        ToPrintContract: Decimal;
        ToPrintToDateCost: Decimal;
        ToPrintBillings: Decimal;
        ToPrintCostEstimate: Decimal;
        PercentType: Text[1];
        A: Decimal;
        B: Decimal;
        C: Decimal;
        D: Decimal;
        E: Decimal;
        F: Decimal;
        G: Decimal;
        H: Decimal;
        I: Decimal;
        IncludeSubLevelsInMasterJobValues: Boolean;
        DoNotShowSubLevels: Boolean;
        UseEnteredPercentComplete: Boolean;
        UseJobForecastWorksheet: Boolean;
        ExcludeMarkedCostEntries: Boolean;
        ExcludeMarkedPriceEntries: Boolean;
        [InDataSet]
        ExcludeMarkedCostEntriesEdit: Boolean;
        [InDataSet]
        ExcludeMarkedPriceEntriesEdit: Boolean;
        ShowJobSummaries: Boolean;
        ShowReportSummary: Boolean;
        "Sub-LevelsText": Text[60];
        CompletePercentText: Text[50];
        IncludeAdjustmentsText: Text[50];
        WorksheetText: Text[50];
        MarkedCostEntriesExcluded: Text[50];
        MarkedPriceEntriesExcluded: Text[50];
        "SummaryTable------------------": Integer;
        CurrentPointer: Integer;
        TopPointer: Integer;
        SummaryGlobalDim1: array[100] of Code[20];
        SummaryA: array[100] of Decimal;
        SummaryB: array[100] of Decimal;
        SummaryC: array[100] of Decimal;
        SummaryD: array[100] of Decimal;
        SummaryE: array[100] of Decimal;
        SummaryF: array[100] of Decimal;
        SummaryG: array[100] of Decimal;
        SummaryH: array[100] of Decimal;
        SummaryI: array[100] of Decimal;
        "FinalSummaryTable-------------": Integer;
        FinalCurrentPointer: Integer;
        FinalTopPointer: Integer;
        FinalSummaryGlobalDim1: array[10000] of Code[20];
        FinalSummaryJob: array[10000] of Code[20];
        FinalSummaryA: array[10000] of Decimal;
        FinalSummaryB: array[10000] of Decimal;
        FinalSummaryC: array[10000] of Decimal;
        FinalSummaryD: array[10000] of Decimal;
        FinalSummaryE: array[10000] of Decimal;
        FinalSummaryF: array[10000] of Decimal;
        FinalSummaryG: array[10000] of Decimal;
        FinalSummaryH: array[10000] of Decimal;
        FinalSummaryI: array[10000] of Decimal;
        "TempSortArea-------------": Integer;
        TempGlobalDim1: Code[20];
        TempSummaryJob: Code[20];
        TempSummaryA: Decimal;
        TempSummaryB: Decimal;
        TempSummaryC: Decimal;
        TempSummaryD: Decimal;
        TempSummaryE: Decimal;
        TempSummaryF: Decimal;
        TempSummaryG: Decimal;
        TempSummaryH: Decimal;
        TempSummaryI: Decimal;
        WorksheetCode: Label 'W';
        ManualCode: Label 'M';
        CalculatedCode: Label 'C';
        DateFilter: text;
        MaxDate: Date;
}