report 14021291 "NS_UpdateRecRevSummDetailJFW"
{
    //CTSI-274.MS.1.0
    //PRJ-830.GK.1.0 06Sep2021|Changes in code.

    ProcessingOnly = true;
    Caption = 'Update Rec.Rev.Summ.Detail JFW';
    UseRequestPage = false;
    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending);
            MaxIteration = 1;
            dataitem(ForecastSummDetail; "NS_Percentage of Completion")
            {
                trigger OnPreDataItem()
                var
                    SLJob: Record Job;
                    RecForecastSummDetail: Record "NS_Percentage of Completion";
                    PagePMStatistics: Page "NS_PM Statistics";
                    StsFlag: Boolean;
                begin
                    if JobSetup.Get() then;
                    SetFilter(NS_RecRevFlag, '%1', true);
                    SetFilter("NS_Job No.", '%1', MasterJobno);
                    if RecJob.get(MasterJobno) then;
                    if RecJob."NS_Exclude from Job Forecast" = true then
                        CurrReport.Skip();
                    FirstDayDate := CALCDATE('<-CM>', AsofDateForecast);
                    LastDayDate := CALCDATE('<CM>', AsofDateForecast);
                    premonthFirstDayDate := CALCDATE('<-1M>', AsofDateForecast);
                    // PremonthLastDayDate := CALCDATE('<-1M>', AsofDateForecast);//PRJ-658 Comment
                    PremonthLastDayDate := CALCDATE('<CM>', premonthFirstDayDate);//PRJ-658 Add

                    SLCurrContract := 0;
                    SLCurrEstCostCompletion := 0;
                    SLActualCostsTodate := 0;
                    PeriodCosts := 0;
                    MasterPeriodCosts := 0;
                    SLPeriodCosts := 0;
                    POCPct := 0;
                    //Statistics page calculations
                    MasterStsContractPrice := 0;
                    SLStsContractPrice := 0;
                    MasterStsTotalCostEst := 0;
                    SLStsTotalCostEst := 0;
                    //Statistics page calculations
                    Clear(BillingToDate);//PRJ-830
                    Clear(MasterBillingToDate);//PRJ-830
                    Clear(SLBillingToDate);//PRJ-830
                    clear(Overbilling);//PRJ-830
                    Clear(Underbilling);//PRJ-830

                    MasterPeriodCosts := GetJobLedgerEntry(MasterJobno, FirstDayDate, LastDayDate);
                    //Statistics page calculations
                    StsFlag := false;
                    MasterStsContractPrice := PagePMStatistics.GetPlanningLine(0D, AsofDateForecast, MasterJobno, StsFlag);
                    StsFlag := true;
                    MasterStsTotalCostEst := PagePMStatistics.GetPlanningLine(0D, AsofDateForecast, MasterJobno, StsFlag);
                    //Statistics page calculations
                    MasterBillingToDate := GetBillingtodate(MasterJobno, AsofDateForecast);//PRJ-830
                    SLJob.Reset();
                    SLJob.SetRange("NS_Sub-Level to Job No.", Recjob."No.");
                    SLJob.SetRange("NS_Exclude from Job Forecast", false);
                    if Jobsetup."NS_GBPG for Job Forecast" <> '' then
                        // SLJob.SetFilter("NS_Gen. Bus. Posting Group", Jobsetup."NS_GBPG for Job Forecast");//PRJ-831.AS.1.0 12OCT2021 Comment old
                         SLJob.SetFilter("NS_Gen. Bus. Posting Group New", Jobsetup."NS_GBPG for Job Forecast");//PRJ-831.AS.1.0 12OCT2021 Add New
                    if SLJob.FindSet() then
                        repeat
                            RecForecastSummDetail.Reset();
                            RecForecastSummDetail.SetRange("NS_Job No.", SLJob."No.");
                            RecForecastSummDetail.SetFilter(NS_RecRevFlag, '%1', true);
                            if RecForecastSummDetail.FindLast() then begin
                                SLCurrContract := SLCurrContract + RecForecastSummDetail."NS_Total Contract Revenue";
                                SLCurrEstCostCompletion := SLCurrEstCostCompletion + RecForecastSummDetail.NS_TotalForecastCompletedCost;
                                SLActualCostsTodate := SLActualCostsTodate + RecForecastSummDetail."NS_Total Cost to Date";
                                SLPeriodCosts := SLPeriodCosts + GetJobLedgerEntry(SLJob."No.", FirstDayDate, LastDayDate);
                                SLBillingToDate := SLBillingToDate + GetBillingtodate(SLJob."No.", AsofDateForecast);//PRJ-830
                                RecForecastSummDetail.NS_RecRevFlag := false;
                                RecForecastSummDetail.Modify();
                            end;
                            //Statistics page calculations
                            StsFlag := false;
                            SLStsContractPrice := SLStsContractPrice + PagePMStatistics.GetPlanningLine(0D, AsofDateForecast, SLJob."No.", StsFlag);
                            StsFlag := true;
                            SLStsTotalCostEst := SLStsTotalCostEst + PagePMStatistics.GetPlanningLine(0D, AsofDateForecast, SLJob."No.", StsFlag);
                        //Statistics page calculations    
                        until SLJob.next = 0;
                    //RecRevFlag := false;
                    //Modify();
                end;

                trigger OnAfterGetRecord()
                var
                begin

                    CurrContract := SLCurrContract + ForecastSummDetail."NS_Total Contract Revenue";
                    CurrEstCostCompletion := SLCurrEstCostCompletion + ForecastSummDetail.NS_TotalForecastCompletedCost;
                    ActualCostsTodate := SLActualCostsTodate + ForecastSummDetail."NS_Total Cost to Date";
                    PeriodCosts := MasterPeriodCosts + SLPeriodCosts;
                    //Statistics page calculations
                    StsContractPrice := MasterStsContractPrice + SLStsContractPrice;
                    StsTotalCostEst := MasterStsTotalCostEst + SLStsTotalCostEst;
                    //Statistics page calculations  
                    BillingToDate := MasterBillingToDate + SLBillingToDate;//PRJ-830.MS.1.0


                end;



            }
            trigger OnPostDataItem() //integer
            var
                RevenueRecSummaryTab: Record NS_RevenueRecSummaryTab;
                RevenueRecSummaryVoid: Record NS_RevenueRecSummaryTab;
                RevenueRecSummaryTab_N: Record NS_RevenueRecSummaryTab;//PRJ-658
                GrosRevVar: Decimal;
                GrossProfitVar: Decimal;
                RevenueRecSummaryTab2: Record NS_RevenueRecSummaryTab;
            begin
                GrosRevVar := 0;
                GrossProfitVar := 0;
                //do voided
                RevenueRecSummaryVoid.Reset();
                RevenueRecSummaryVoid.SetCurrentKey("NS_Entry No.");
                RevenueRecSummaryVoid.SetRange("NS_Job No.", MasterJobno);
                RevenueRecSummaryVoid.setfilter(NS_Posted, '%1', false);
                //RevenueRecSummaryVoid.SetFilter("True-Up Posted", '%1', false);//CTSI-286 rollback
                RevenueRecSummaryVoid.SetFilter(NS_Voided, '%1', false);
                RevenueRecSummaryVoid.Setrange("NS_Posting Date", AsofDateForecast);
                RevenueRecSummaryVoid.SetFilter("NS_Entry Type", '%1', RevenueRecSummaryVoid."NS_Entry Type"::JFW);
                if RevenueRecSummaryVoid.FindSet() then
                    repeat
                        RevenueRecSummaryVoid.NS_Voided := true;
                        RevenueRecSummaryVoid.Modify();
                    until RevenueRecSummaryVoid.next = 0;

                //PRJ-658.AS.1.0 04MAY2021 changed variables to RevenueRecSummaryTab_N = RevenueRecSummaryTab - START
                RevenueRecSummaryTab_N.Init();
                RevenueRecSummaryTab_N."NS_Posting Date" := ForecastSummDetail."NS_Posting Date";
                RevenueRecSummaryTab_N."NS_Entry Type" := RevenueRecSummaryTab."NS_Entry Type"::JFW;
                RevenueRecSummaryTab_N."NS_Job No." := recjob."No.";
                RevenueRecSummaryTab_N."NS_Job Description" := recjob.Description;

                //PRJ-950.AS.1.0 - start
                if jobTable.get(RevenueRecSummaryTab_N."NS_Job No.") then begin
                    RevenueRecSummaryTab_N."NS_Global Dimension 1 Code" := jobTable."Global Dimension 1 Code";
                    RevenueRecSummaryTab_N."NS_Global Dimension 2 Code" := jobTable."Global Dimension 2 Code";
                end;
                //PRJ-950.AS.1.0 - end

                RevenueRecSummaryTab_N."NS_Current Contract" := CurrContract;
                RevenueRecSummaryTab_N."NS_Current(TCE) Est. Cost at Completion" := CurrEstCostCompletion;
                RevenueRecSummaryTab_N."NS_Actual Costs To Date" := ActualCostsTodate;
                RevenueRecSummaryTab_N."NS_Period Costs" := PeriodCosts;
                if CurrEstCostCompletion <> 0 then
                    POCPct := round((ActualCostsTodate / CurrEstCostCompletion) * 100, JobSetup."NS_Forecast Amount Rounding");
                RevenueRecSummaryTab_N."NS_POC %" := POCPct;
                //PRJ-658.AS.1.0 04MAY2021 - START
                IF POCPct > 100 THEN
                    POCPct := 100;
                IF POCPct < 0 THEN
                    POCPct := 0;
                //PRJ-658.AS.1.0 04MAY2021 - END
                RevenueRecSummaryTab_N."NS_Gross Revenue" := round((CurrContract * POCPct) / 100, JobSetup."NS_Forecast Amount Rounding");
                GrosRevVar := round(CurrContract * POCPct / 100, JobSetup."NS_Forecast Amount Rounding");
                RevenueRecSummaryTab_N."NS_Gross Profit" := GrosRevVar - ActualCostsTodate;
                GrossProfitVar := GrosRevVar - ActualCostsTodate;
                if GrosRevVar <> 0 then
                    RevenueRecSummaryTab_N."NS_Current GM %" := Round((GrossProfitVar / GrosRevVar) * 100, JobSetup."NS_Forecast Amount Rounding");
                //PRJ-658.AS.1.0 04MAY2021 - START
                IF RevenueRecSummaryTab_N."NS_Current GM %" > 100 then
                    RevenueRecSummaryTab_N."NS_Current GM %" := 100;
                IF RevenueRecSummaryTab_N."NS_Current GM %" < 0 then
                    RevenueRecSummaryTab_N."NS_Current GM %" := 0;
                //PRJ-658.AS.1.0 04MAY2021 - END
                //PRJ-830 start
                if BillingToDate > GrosRevVar then
                    Overbilling := BillingToDate - GrosRevVar;
                if BillingToDate < GrosRevVar then
                    Underbilling := GrosRevVar - BillingToDate;
                //PRJ-830 end

                RevenueRecSummaryTab.Reset();
                RevenueRecSummaryTab.SetRange("NS_Job No.", MasterJobno);
                RevenueRecSummaryTab.setrange("NS_Posting Date", 0D, premonthLastDayDate);
                RevenueRecSummaryTab.SetFilter(NS_voided, '%1', false);
                RevenueRecSummaryTab.SetFilter("NS_Entry Type", '%1', RevenueRecSummaryTab."NS_Entry Type"::JFW);
                if RevenueRecSummaryTab.FindLast() then begin
                    NetRevenue := GrosRevVar - RevenueRecSummaryTab."NS_Gross Revenue";
                end Else
                    // if (CurrContract * POCPct) = 0 then begin//PRJ-658 COMMENT
                    if RevenueRecSummaryTab."NS_Gross Revenue" = 0 then begin//PRJ-658 ADD
                        RevenueRecSummaryTab2.Reset();
                        RevenueRecSummaryTab2.SetRange("NS_Job No.", MasterJobno);
                        RevenueRecSummaryTab2.setrange("NS_Posting Date", 0D, premonthLastDayDate);
                        RevenueRecSummaryTab2.SetFilter(NS_voided, '%1', false);
                        RevenueRecSummaryTab2.SetFilter("NS_Entry Type", '%1', RevenueRecSummaryTab2."NS_Entry Type"::Finance);
                        if RevenueRecSummaryTab2.FindLast() then
                            NetRevenue := GrosRevVar - RevenueRecSummaryTab2."NS_Gross Revenue"
                        else//PRJ-658 ADD
                            NetRevenue := GrosRevVar;//PRJ-658 ADD
                        // end else//PRJ-658 CMNT
                        //     NetRevenue := GrosRevVar;//PRJ-658 CMNT
                    end;

                //NetProfit := NetRevenue - ActualCostsTodate;//PRJ-658.AS.1.0 12MAY20 COMMENT
                NetProfit := NetRevenue - PeriodCosts;//PRJ-658.AS.1.0 12MAY20 ADD

                RevenueRecSummaryTab_N."NS_Net Revenue" := NetRevenue;
                RevenueRecSummaryTab_N."NS_Net Profit" := NetProfit;
                //Statistics page calculations
                RevenueRecSummaryTab_N."NS_Stat. Cont. GM (As of)" := StsContractPrice - StsTotalCostEst;
                if (StsContractPrice) <> 0 then
                    RevenueRecSummaryTab_N."NS_Stat. GM% (As of)" := Round(((StsContractPrice - StsTotalCostEst) / StsContractPrice) * 100, JobSetup."NS_Forecast Amount Rounding");
                //Statistics page calculations
                RevenueRecSummaryTab_N."NS_Billings to Date" := BillingToDate;//PRJ-830
                RevenueRecSummaryTab_N."NS_Over Billings" := Overbilling;//PRJ-830
                RevenueRecSummaryTab_N."NS_Under Billings" := Underbilling;//PRJ-830
                RevenueRecSummaryTab_N.Insert();
                //PRJ-658.AS.1.0 04MAY2021 changed variables to RevenueRecSummaryTab_N = RevenueRecSummaryTab - END
            end;
        }
    }
    var
        MasterJobno: Code[20];
        jobTable: record Job;//PRJ-950.AS.1.0
        JobSetup: Record "Jobs Setup";
        RecJob: Record Job;
        CurrContract: Decimal;
        SLCurrContract: Decimal;
        CurrEstCostCompletion: Decimal;
        SLCurrEstCostCompletion: Decimal;
        ActualCostsTodate: Decimal;
        SLActualCostsTodate: Decimal;
        AsofDateForecast: Date;
        FirstDayDate: date;
        LastDayDate: date;
        PeriodCosts: Decimal;
        MasterPeriodCosts: Decimal;
        SLPeriodCosts: Decimal;
        POCPct: Decimal;
        premonthFirstDayDate: Date;
        premonthLastDayDate: date;
        NetRevenue: Decimal;
        NetProfit: Decimal;
        StsContGMAsofDate: Decimal; //use in statistics page
        StsContractPrice: Decimal;//use in statistics page
        MasterStsContractPrice: Decimal;//use in statistics page
        SLStsContractPrice: Decimal;//use in statistics page
        StsTotalCostEst: Decimal;//use in statistics page
        MasterStsTotalCostEst: Decimal;//use in statistics page
        SLStsTotalCostEst: Decimal;//use in statistics page
        BillingToDate: Decimal;//PRJ-830
        MasterBillingToDate: Decimal;//PRJ-830
        SLBillingToDate: Decimal;//PRJ-830

        Overbilling: Decimal;//PRJ-830
        Underbilling: Decimal;//PRJ-830

    procedure SetJobNo(var JobNo: Code[20]; var Asofdate: Date)
    begin
        MasterJobno := JobNo;
        AsofDateForecast := Asofdate;
    end;

    local procedure GetJobLedgerEntry(JobNo: Code[20]; Var StartDate: date; var EndDate: date) Answer: Decimal;
    var
        JobLedEntry: Record "Job Ledger Entry";
    begin
        Answer := 0;
        JobLedEntry.Reset();
        JobLedEntry.SetCurrentKey("Job No.", "Posting Date");
        JobLedEntry.SetRange("Job No.", JobNo);
        JobLedEntry.SetRange("Posting Date", StartDate, EndDate);
        JobLedEntry.SetFilter("Entry Type", '%1', JobLedEntry."Entry Type"::Usage);
        if JobLedEntry.FindSet() then
            repeat
                Answer := round(Answer + JobLedEntry."Total Cost (LCY)", JobSetup."NS_Forecast Amount Rounding");
            until JobLedEntry.Next() = 0;
        exit(Answer);

    end;
    //PRJ-830.MS.1.0 start
    local procedure GetBillingtodate(JobNo: Code[20]; Var Datefilter: Date) SumOfTotalCostsUsed: Decimal;
    var
        JobLedEntry: Record "Job Ledger Entry";
    begin
        SumOfTotalCostsUsed := 0;
        JobLedEntry.Reset();
        JobLedEntry.SetCurrentKey("Job No.", "Posting Date");
        JobLedEntry.SetRange("Job No.", JobNo);
        //JobLedEntry.setrange("Posting Date", Datefilter);//PRJ-830.GK.1.0 07Sep2021Line Comment 
        JobLedEntry.SetFilter("Posting Date", '%1..%2', 0D, Datefilter);//PRJ-830.GK.1.0 07Sep2021
        JobLedEntry.SetFilter("Entry Type", '%1', JobLedEntry."Entry Type"::Sale);
        if JobLedEntry.FindSet() then
            repeat
                //PRJ-830.GK.1.0 06Sep2021 start
                //SumOfTotalCostsUsed := round(SumOfTotalCostsUsed + JobLedEntry."Total Cost (LCY)", Jobsetup."NS_Forecast Amount Rounding"); // Line Comment
                SumOfTotalCostsUsed := round(SumOfTotalCostsUsed + ABS(JobLedEntry."Total Price (LCY)"), Jobsetup."NS_Forecast Amount Rounding"); //New line Added
            //PRJ-830.GK.1.0 06Sep2021 end
            until JobLedEntry.Next() = 0;
        exit(SumOfTotalCostsUsed);

    end;
    //PRJ-830.MS.1.0 end

}

