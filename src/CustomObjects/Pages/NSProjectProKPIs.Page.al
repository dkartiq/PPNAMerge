page 14021355 "NS_ProjectPro KPIs"
{
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-1262.RM.2.0 04April2022 | Changed Status
    //PRJCTPR-36.SD.1.0 17Jan2023 | '<>' Added in date formula so its not gets translated.

    Caption = 'ProjectPro KPIs';
    PageType = CardPart;
    SaveValues = true;

    layout
    {
        area(content)
        {
            group("Key Performance Indicators")
            {
                field("FORMAT(KPI[1],14,'<Precision,0:2><Sign><Integer Thousand><Decimals>')+'%'"; FORMAT(KPI[1], 14, '<Precision,0:2><Sign><Integer Thousand><Decimals>') + '%')
                {
                    ApplicationArea = All;
                    Caption = '% of Completed Jobs finished on time';
                    Editable = false;

                    trigger OnDrillDown();
                    begin
                        Job2.RESET;
                        Job2.CLEARMARKS;
                        if Job2.FINDSET then
                            repeat
                                //Find jobs which were estimated to be completed in the time horizon and are Running or Completed.
                                //If job is 100% complete, compare "Actual Percent Complete Date" to "Estimated Completion Date" to determine if it was on-time
                                if (Job2."NS_Estimated Completion Date" >= StartingDate) and
                                   (Job2."NS_Estimated Completion Date" <= EndingDate) then
                                    if (Job2."NS_Manager Job Status" = Job2."NS_Manager Job Status"::Handover) or
                                       (Job2."NS_Manager Job Status" >= Job2."NS_Manager Job Status"::Completed) then
                                        Job2.MARK(true);
                                //Add in jobs which are estimated to be completed after the time horizon and were completed within the time horizon.
                                if (Job2."NS_Estimated Completion Date" > EndingDate) then
                                    if Job2."NS_Actual Percent Complete" >= 100 then
                                        if (Job2."NS_Actual PercentCompleteDate" >= StartingDate) and
                                           (Job2."NS_Actual PercentCompleteDate" <= EndingDate) then
                                            if Job2."NS_Actual PercentCompleteDate" <= Job2."NS_Estimated Completion Date" then
                                                Job2.MARK(true);
                            until Job2.NEXT() = 0;
                        Job2.MARKEDONLY(true);
                        PAGE.RUN(PAGE::"NS_KPI Job List", Job2);
                    end;
                }
                field("FORMAT(KPI[2],14,'<Precision,0:2><Sign><Integer Thousand><Decimals>')+'%'"; FORMAT(KPI[2], 14, '<Precision,0:2><Sign><Integer Thousand><Decimals>') + '%')
                {
                    ApplicationArea = All;
                    Caption = '% of Running Jobs that are Cash Positive';
                    Editable = false;

                    trigger OnDrillDown();
                    begin
                        Job2.RESET();
                        Job2.CLEARMARKS();
                        if Job2.FINDSET() then
                            repeat
                                //Find "Running" top-level jobs
                                if Job2."Starting Date" <> 0D then
                                    if Job2."Starting Date" <= EndingDate then
                                        if Job2."NS_Sub-Level to Job No." = '' then
                                            if Job2."NS_Manager Job Status" = Job2."NS_Manager Job Status"::Handover then
                                                Job2.MARK(true);
                            until Job2.NEXT() = 0;
                        Job2.MARKEDONLY(true);
                        PAGE.RUN(PAGE::"NS_KPI Job List", Job2);
                    end;
                }
                field("FORMAT(KPI[3],16,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(KPI[3], 16, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                {
                    ApplicationArea = All;
                    Caption = 'Job Backlog for Planning to Running';
                    Editable = false;
                }
                field("FORMAT(KPI[4],14,'<Precision,0:2><Sign><Integer Thousand><Decimals>')+'%'"; FORMAT(KPI[4], 14, '<Precision,0:2><Sign><Integer Thousand><Decimals>') + '%')
                {
                    ApplicationArea = All;
                    Caption = 'Avg. % of Margin Variance to Business Plan';
                    Editable = false;

                    trigger OnDrillDown();
                    begin
                        Job2.RESET();
                        Job2.CLEARMARKS();
                        if Job2.FINDSET() then
                            repeat
                                //Find "Running" top-level jobs which have Started or will Start in the time horizon
                                //Calculate Actual Margin Variance % and Projected Margin Variance %
                                //Add-up the difference of Projected - Actual, then divide it by the number of jobs added-up
                                if Job2."Starting Date" <> 0D then
                                    if Job2."Starting Date" <= EndingDate then
                                        if Job2."NS_Sub-Level to Job No." = '' then
                                            if Job2."NS_Manager Job Status" = Job2."NS_Manager Job Status"::Handover then begin
                                                Job2.CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");
                                                TotalBudgetedCost := Job2."NS_Budgeted Cost (LCY)" + Job2.NS_SLsBudgetedLaborHours(Job);
                                                TotalContract := Job2."NS_Budgeted Price (LCY)" + Job2."SLsUsage(Price)"(Job);
                                                if TotalContract = 0 then
                                                    ActualProfitPct := 0
                                                else
                                                    ActualProfitPct := ((TotalContract - TotalBudgetedCost) / TotalContract) * 100;
                                                Job2.NS_CalculateActualCostToDate(Job2, ActualCostToDate, true);
                                                if Job2."NS_Actual Percent Complete" > 0 then
                                                    ActualPctComplete := Job2."NS_Actual Percent Complete"
                                                else begin
                                                    if TotalBudgetedCost <> 0 then
                                                        CalcPctComplete := ROUND((ActualCostToDate[3] / TotalBudgetedCost), 0.0001)
                                                    else
                                                        CalcPctComplete := 0;
                                                    ActualPctComplete := CalcPctComplete * 100;
                                                end;
                                                if ActualPctComplete <> 0 then
                                                    ActualPctComplete := ActualCostToDate[3] / (ActualPctComplete / 100);
                                                if TotalContract = 0 then
                                                    ProjectedProfitPct := 0
                                                else
                                                    ProjectedProfitPct := ((TotalContract - ActualPctComplete) / TotalContract) * 100;
                                                if TotalContract <> 0 then
                                                    Job2.MARK(true);
                                            end;
                            until Job2.NEXT() = 0;
                        Job2.MARKEDONLY(true);
                        PAGE.RUN(PAGE::"NS_KPI Job List", Job2);
                    end;
                }
                field("FORMAT(KPI[5],14,'<Precision,0:2><Sign><Integer Thousand><Decimals>')+'%'"; FORMAT(KPI[5], 14, '<Precision,0:2><Sign><Integer Thousand><Decimals>') + '%')
                {
                    ApplicationArea = All;
                    Caption = 'Avg. % of Gross Profit';
                    Editable = false;

                    trigger OnDrillDown();
                    begin
                        Job2.RESET();
                        Job2.CLEARMARKS();
                        if Job2.FINDSET() then
                            repeat
                                //Find "Running" top-level jobs which have Started or will Start in the time horizon
                                //Calculate Actual Margin Variance % and Projected Margin Variance %
                                //Add-up the difference of Projected - Actual, then divide it by the number of jobs added-up
                                if Job2."Starting Date" <> 0D then
                                    if Job2."Starting Date" <= EndingDate then
                                        if Job2."NS_Sub-Level to Job No." = '' then
                                            if Job2."NS_Manager Job Status" = Job2."NS_Manager Job Status"::Handover then begin
                                                Job2.CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");
                                                TotalBudgetedCost := Job2."NS_Budgeted Cost (LCY)" + Job2.NS_SLsBudgetedLaborHours(Job);
                                                TotalContract := Job2."NS_Budgeted Price (LCY)" + Job2."SLsUsage(Price)"(Job);
                                                if TotalContract = 0 then
                                                    ActualProfitPct := 0
                                                else
                                                    ActualProfitPct := ((TotalContract - TotalBudgetedCost) / TotalContract) * 100;
                                                Job2.NS_CalculateActualCostToDate(Job2, ActualCostToDate, true);
                                                if Job2."NS_Actual Percent Complete" > 0 then
                                                    ActualPctComplete := Job2."NS_Actual Percent Complete"
                                                else begin
                                                    if TotalBudgetedCost <> 0 then
                                                        CalcPctComplete := ROUND((ActualCostToDate[3] / TotalBudgetedCost), 0.0001)
                                                    else
                                                        CalcPctComplete := 0;
                                                    ActualPctComplete := CalcPctComplete * 100;
                                                end;
                                                if ActualPctComplete <> 0 then
                                                    ActualPctComplete := ActualCostToDate[3] / (ActualPctComplete / 100);
                                                if TotalContract = 0 then
                                                    ProjectedProfitPct := 0
                                                else
                                                    ProjectedProfitPct := ((TotalContract - ActualPctComplete) / TotalContract) * 100;
                                                if TotalContract <> 0 then
                                                    Job2.MARK(true);
                                            end;
                            until Job2.NEXT() = 0;
                        Job2.MARKEDONLY(true);
                        PAGE.RUN(PAGE::"NS_KPI Job List", Job2);
                    end;
                }
            }
            group("Calculation Time Horizon")
            {
                Caption = 'Calculation Time Horizon';
                field(StartingDate; StartingDate)
                {
                    ApplicationArea = All;
                    Caption = 'Starting Date';
                }
                field(EndingDate; EndingDate)
                {
                    ApplicationArea = All;
                    Caption = 'Ending Date';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        CLEAR(KPI);
        JobsSetup.GET();
        if (JobsSetup."NS_KPI CalculationStartingDate" = 0D) or (JobsSetup."NS_KPI Calculation Ending Date" = 0D) then begin
            EndingDate := WORKDATE;
            //StartingDate := CALCDATE('+1D-1Y', EndingDate);//PRJCTPR-36.SD.1.0 17Jan2023 - Commented
            StartingDate := CALCDATE('<+1D-1Y>', EndingDate);//PRJCTPR-36.SD.1.0 17Jan2023 - Added
        end else begin
            StartingDate := JobsSetup."NS_KPI CalculationStartingDate";
            EndingDate := JobsSetup."NS_KPI Calculation Ending Date";
        end;

        //Calculate % of Jobs finished on time
        W1 := 0;
        W2 := 0;
        Job.RESET();
        if Job.FINDSET() then
            repeat
                //Find jobs which were estimated to be completed in the time horizon and are Running or Completed.
                //If job is 100% complete, compare "Actual Percent Complete Date" to "Estimated Completion Date" to determine if it was on-time
                if (Job."NS_Estimated Completion Date" >= StartingDate) and
                   (Job."NS_Estimated Completion Date" <= EndingDate) then
                    if (Job."NS_Manager Job Status" = Job."NS_Manager Job Status"::Handover) or
                       (Job."NS_Manager Job Status" >= Job."NS_Manager Job Status"::Completed) then begin
                        W1 += 1;
                        if Job."NS_Actual Percent Complete" >= 100 then
                            if Job."NS_Actual PercentCompleteDate" <= Job."NS_Estimated Completion Date" then
                                W2 += 1;
                    end;
                //Add in jobs which are estimated to be completed after the time horizon and were completed within the time horizon.
                if (Job."NS_Estimated Completion Date" > EndingDate) then
                    if Job."NS_Actual Percent Complete" >= 100 then
                        if (Job."NS_Actual PercentCompleteDate" >= StartingDate) and
                           (Job."NS_Actual PercentCompleteDate" <= EndingDate) then
                            if Job."NS_Actual PercentCompleteDate" <= Job."NS_Estimated Completion Date" then begin
                                W1 += 1;
                                W2 += 1;
                            end;
            until Job.NEXT() = 0;
        if W1 = 0 then
            KPI[1] := 0
        else
            KPI[1] := W2 / W1 * 100;

        //Calculate % of Running Jobs that are Cash Positive
        W1 := 0;
        W2 := 0;
        Job.RESET();
        if Job.FINDSET() then
            repeat
                //Find "Running" top-level jobs which have Started or will Start in the time horizon and
                //have Invoice Billings Job To Date greater than Actual Costs Job To Date.
                if Job."Starting Date" <> 0D then
                    if Job."Starting Date" <= EndingDate then
                        if Job."NS_Sub-Level to Job No." = '' then
                            if Job."NS_Manager Job Status" = Job."NS_Manager Job Status"::Handover then begin
                                W1 += 1;
                                Job.NS_CalculateActualCostToDate(Job, ActualCostToDate, true);
                                Job.CalculateInvoiceBilled(Job, InvoiceBilled, true);
                                if InvoiceBilled[3] > ActualCostToDate[3] then
                                    W2 += 1;
                            end;
            until Job.NEXT() = 0;
        if W1 = 0 then
            KPI[2] := 0
        else
            KPI[2] := W2 / W1 * 100;

        //Calculate Job Backlog from Planning to Running
        Job.RESET();
        //JobsSetup.Reset();//PRJ-1262.RM.2.0 commented
        if Job.FINDSET() then
            repeat
                //Find "Running" top-level jobs, calculate Backlog as Contract Total Value less Total Invoice Billed
                if Job."NS_Sub-Level to Job No." = '' then
                    //  if JobsSetup."NS_Project Pro KPI" = true then begin ;//PRJ-1262.RM.2.0 commented
                    //   |  if Job."NS_Manager Job Status" = Job."NS_Manager Job Status"::Handover then begin //PRJ-1262.RM.1.0 

                    if (Job.Status = Job.Status::Open) or (Job.Status = Job.Status::Planning) then begin//PRJ-1262.RM.2.0 start.
                        Job.CALCFIELDS("NS_Budgeted Price (LCY)");
                        KPI[3] += Job."NS_Budgeted Price (LCY)";
                        KPI[3] += Job."SLsUsage(Price)"(Job);
                        Job.CalculateInvoiceBilled(Job, InvoiceBilled, true);
                        KPI[3] -= InvoiceBilled[3];
                    end;
            //PRJ-1262.RM.2.0 start commented
            //         end else begin
            // if Job."NS_Manager Job Status" = Job."NS_Manager Job Status"::Handover then begin //PRJ-1262.RM.1.0 
            //     Job.CALCFIELDS("NS_Budgeted Price (LCY)");
            //     KPI[3] += Job."NS_Budgeted Price (LCY)";
            //     KPI[3] += Job."SLsUsage(Price)"(Job);
            //     Job.CalculateInvoiceBilled(Job, InvoiceBilled, true);
            //     KPI[3] -= InvoiceBilled[3];
            // end;
            //PRJ-1262.RM.2.0 end commented
            //PRJ-1262.RM.1.0 end
            // end;
            until Job.NEXT() = 0;

        //Calculate Average % Margin Variance to Business Plan and Average % of Gross Profit
        W1 := 0;
        W2 := 0;
        W3 := 0;
        Job.RESET();
        if Job.FINDSET() then
            repeat
                //Find "Running" top-level jobs which have Started before or in the time horizon
                //Calculate Actual Margin Variance % and Projected Margin Variance %
                //For Margin Variance: add-up the difference of Projected - Actual, then divide it by the number of jobs added-up
                //For Gross Profit: add-up Projected, then divide it by the number of jobs added-up
                if Job."Starting Date" <> 0D then
                    if Job."Starting Date" <= EndingDate then
                        if Job."NS_Sub-Level to Job No." = '' then
                            if Job."NS_Manager Job Status" = Job."NS_Manager Job Status"::Handover then begin
                                Job.CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");
                                TotalBudgetedCost := Job."NS_Budgeted Cost (LCY)" + Job.NS_SLsBudgetedLaborHours(Job);
                                TotalContract := Job."NS_Budgeted Price (LCY)" + Job."SLsUsage(Price)"(Job);
                                if TotalContract = 0 then
                                    ActualProfitPct := 0
                                else
                                    ActualProfitPct := ((TotalContract - TotalBudgetedCost) / TotalContract) * 100;
                                Job.NS_CalculateActualCostToDate(Job, ActualCostToDate, true);
                                if Job."NS_Actual Percent Complete" > 0 then
                                    ActualPctComplete := Job."NS_Actual Percent Complete"
                                else begin
                                    if TotalBudgetedCost <> 0 then
                                        CalcPctComplete := ROUND((ActualCostToDate[3] / TotalBudgetedCost), 0.0001)
                                    else
                                        CalcPctComplete := 0;
                                    ActualPctComplete := CalcPctComplete * 100;
                                end;
                                if ActualPctComplete <> 0 then
                                    ActualPctComplete := ActualCostToDate[3] / (ActualPctComplete / 100);
                                if TotalContract = 0 then
                                    ProjectedProfitPct := 0
                                else begin
                                    ProjectedProfitPct := ((TotalContract - ActualPctComplete) / TotalContract) * 100;
                                    W3 += ProjectedProfitPct;
                                end;
                                if TotalContract <> 0 then begin
                                    W1 += 1;
                                    W2 += (ProjectedProfitPct - ActualProfitPct);
                                end;
                            end;
            until Job.NEXT() = 0;
        if W1 = 0 then begin
            KPI[4] := 0;
            KPI[5] := 0;
        end else begin
            KPI[4] := W2 / W1;
            KPI[5] := W3 / W1;
        end;
    end;

    var
        JobsSetup: Record "Jobs Setup";
        Job: Record Job;
        Job2: Record Job;
        KPI: array[5] of Decimal;
        W1: Decimal;
        W2: Decimal;
        W3: Decimal;
        StartingDate: Date;
        EndingDate: Date;
        InvoiceBilled: array[3] of Decimal;
        ActualCostToDate: array[3] of Decimal;
        TotalContract: Decimal;
        TotalBudgetedCost: Decimal;
        ActualPctComplete: Decimal;
        CalcPctComplete: Decimal;
        ProjectedProfitPct: Decimal;
        ActualProfitPct: Decimal;


}

