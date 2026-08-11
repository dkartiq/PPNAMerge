report 14021151 NS_RevenueRecognitionRep
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Revenue Recognition Report/Batch';
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSRevenueRecognition.rdl';
    //ctsi-274
    //PRJ-658.AS.1.0 03MAY2021 Roll up Sub level job values
    //PRJ-658.AS.1.0 04MAY2021 Done for values greater than 100 changes, also column values interchanges in layout
    //PRJ-830.GK.1.0 06Sep2021 | Changes in code.
    //PRJ-831.AS.1.0 12OCT2021 Replaced Job Table field Gen Bus Posting Grp with Gen Bus Posting Grp New

    dataset
    {
        dataitem(Job; Job)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Job Posting Group", "NS_Gen. Bus. Posting Group New", "NS_Date Filter", Status, "NS_Contract Date";//PRJ-658 added status, contract date //PRJ-831.AS.1.0 12OCT2021
            column(Date_Filter; "NS_Date Filter") { }
            column(Jobfilter; Job.TABLECAPTION + ' Filters: ' + JobFilter) { }
            // column(PostingDate; Format(PostingDate, 0, '<Day,2>/<Month,2>/<Year4>')) { }//PRJ-658 COMMENTED
            column(PostingDate; FORMAT(PostingDate)) { }//PRJ-658 ADDED
            column(No_; MasterJob) { }
            column(Description; Description) { }

            column(EntryTypeLbl; EntryTypeLbl) { }
            column(CurrContractlbl; CurrContractlbl) { }
            column(CurrCostCompletionLbl; CurrCostCompletionLbl) { }
            column(ActualCostsTodateLbl; ActualCostsTodateLbl) { }
            column(PeriodCostsLbl; PeriodCostsLbl) { }
            column(POCLbl; POCLbl) { }
            column(CurrentGMLbl; CurrentGMLbl) { }
            column(GrossProfitLbl; GrossProfitLbl) { }
            column(GrossRevLbl; GrossRevLbl) { }
            column(NetProfitLbl; NetProfitLbl) { }
            column(NetRevenueLbl; NetRevenueLbl) { }
            column(PDate; PDate) { }
            column(EntryType; EntryType) { }
            column(CurrContract; CurrContract) { }
            column(CurrCostCompletion; CurrEstCostCompletion) { }
            column(NetProfit; NetProfit) { }
            column(NetRevenue; NetRevenue) { }
            column(GrossProfit; GrossProfit) { }
            column(GrossRev; GrossRev) { }
            column(POC; POC) { }
            column(CurrentGM; CurrentGM) { }
            column(PeriodCosts; PeriodCosts) { }
            column(ActualCostsTodate; ActualCostsTodate) { }
            column(BillingToDate; BillingToDate) { }
            column(Overbilling; Overbilling) { }
            column(Underbilling; Underbilling) { }


            trigger OnPreDataItem() //job
            var
                StrPost: Integer;
            begin
                Clear(NewDate);
                Clear(FirstDayDate);
                Clear(LastDayDate);
                Clear(StrPost);
                Clear(startdate);

                SetFilter("NS_Exclude from Job Forecast", '%1', false);
                SetFilter("NS_Revenue Recognized", '%1', false);//CTSI-285.MS.1.0
                PostingdateFilter := GetFilter("NS_Date Filter");
                StrPost := StrPos(PostingdateFilter, '.');

                if Jobsetup.get then;
                NewDate := GetRangeMax("NS_Date Filter");
                if StrPost > 1 then
                    startdate := GetRangeMin("NS_Date Filter");

                asofdate := NewDate;
                FirstDayDate := CALCDATE('<-CM>', NewDate);
                LastDayDate := CALCDATE('<CM>', NewDate);
                premonthFirstDayDate := CALCDATE('<-1M>', NewDate);
                //PremonthLastDayDate := CALCDATE('<-1M>', NewDate);
                PremonthLastDayDate := CALCDATE('<CM>', premonthFirstDayDate);//PRJ-658

            end;

            trigger OnAfterGetRecord() //job
            var
                MasterCurrContract: Decimal;
                SLCurrContract: Decimal;
                SLJob: Record Job;
                MasterActualCostsTodate: Decimal;
                SLActualCostsTodate: Decimal;
                MasterPeriodCosts: Decimal;
                SLPeriodCosts: Decimal;
                MasterCurrEstCostCompletion: Decimal;
                SLCurrEstCostCompletion: Decimal;
                //t: Report "Get Forecast completed Cost";
                RevenueRecSummaryVoid: Record NS_RevenueRecSummaryTab;
                RevenueRecSummaryCurrEst: Record NS_RevenueRecSummaryTab;
                RevenueRecSummaryTab2: Record NS_RevenueRecSummaryTab;
                RevenueRecSummaryTab_N: Record NS_RevenueRecSummaryTab;//PRJ-658.AS.1.0 04MAY2021
                MasterCurrBugCost: Decimal;
                SLCurrBugCost: Decimal;

            begin
                clear(SLCurrContract);
                Clear(MasterCurrContract);
                Clear(CurrContract);

                Clear(MasterCurrEstCostCompletion);
                Clear(SLCurrEstCostCompletion);
                Clear(CurrEstCostCompletion);

                Clear(MasterActualCostsTodate);
                Clear(SLActualCostsTodate);
                Clear(ActualCostsTodate);

                Clear(MasterPeriodCosts);
                Clear(SLPeriodCosts);
                Clear(PeriodCosts);
                Clear(CurrentGM);//PRJ-658.AS.1.0 04MAY2021
                CLEAR(GrossRev);//PRJ-658.AS.1.0 04MAY2021
                CLEAR(GrossProfit);//PRJ-658.AS.1.0 04MAY2021
                CLEAR(NetRevenue);//PRJ-658.AS.1.0 04MAY2021
                CLEAR(NetProfit);//PRJ-658.AS.1.0 04MAY2021
                CLEAR(POC);//PRJ-658.AS.1.0 04MAY2021
                Clear(MasterCurrBugCost);
                Clear(SLCurrBugCost);

                Clear(BillingToDate);//PRJ-830
                Clear(MasterBillingToDate);//PRJ-830
                Clear(SLBillingToDate);//PRJ-830
                clear(Overbilling);//PRJ-830
                Clear(Underbilling);//PRJ-830



                //PRJ-658.AS.1.0 03MAY2021 - start
                if Job."NS_Sub-Level to Job No." <> '' then
                    CurrReport.Skip();
                //PRJ-658.AS.1.0 03MAY2021 - end

                PDate := PostingDate;
                EntryType := EntryType::Finance;
                MasterJob := "No.";
                //Description
                //Master
                MasterCurrContract := GetPlanningLine(PostingdateFilter, Job."No.");
                MasterActualCostsTodate := GetJobLedgerEntry(Job."No.", PostingdateFilter);
                if startdate = 0D then
                    MasterPeriodCosts := GetJobLedgerEntryNew(job."No.", FirstDayDate, NewDate)
                else
                    MasterPeriodCosts := GetJobLedgerEntryNew(job."No.", startdate, NewDate);

                RevenueRecSummaryCurrEst.Reset();
                RevenueRecSummaryCurrEst.SetRange("NS_Job No.", Job."No.");
                RevenueRecSummaryCurrEst.SetFilter(NS_Voided, '%1', false);
                RevenueRecSummaryCurrEst.SetFilter("NS_Entry Type", '%1', RevenueRecSummaryCurrEst."NS_Entry Type"::JFW);
                RevenueRecSummaryCurrEst.SetRange("NS_Posting Date", 0D, PremonthLastDayDate);
                if RevenueRecSummaryCurrEst.findlast then begin
                    CurrEstCostCompletion := RevenueRecSummaryCurrEst."NS_Current(TCE) Est. Cost at Completion";
                    if CurrEstCostCompletion <> 0 then begin
                        MasterCurrBugCost := GetCurrEstCostNew(calcdate('1D', RevenueRecSummaryCurrEst."NS_Posting Date"), asofdate, job."No.");
                    end;
                end;

                if CurrEstCostCompletion = 0 then begin
                    MasterCurrEstCostCompletion := GetCurrEstCost(asofdate, job."No.");
                end;
                MasterBillingToDate := GetBillingtodate(Job."No.", PostingdateFilter);//PRJ-830
                //sublevel
                SLJob.Reset();
                SLJob.SetRange("NS_Sub-Level to Job No.", job."No.");
                SLJob.SetRange("NS_Exclude from Job Forecast", false);
                if Jobsetup."NS_GBPG for Job Forecast" <> '' then
                    //SLJob.SetFilter("NS_Gen. Bus. Posting Group", Jobsetup."NS_GBPG for Job Forecast");//PRJ-831.AS.1.0 12OCT2021 Comment old
                     SLJob.SetFilter("NS_Gen. Bus. Posting Group New", Jobsetup."NS_GBPG for Job Forecast");//PRJ-831.AS.1.0 12OCT2021 Add New
                if SLJob.FindSet() then
                    repeat
                        SLCurrContract := SLCurrContract + GetPlanningLine(PostingdateFilter, SLJob."No.");
                        SLActualCostsTodate := SLActualCostsTodate + GetJobLedgerEntry(SLJob."No.", PostingdateFilter);
                        if startdate = 0D then
                            SLPeriodCosts := SLPeriodCosts + GetJobLedgerEntryNew(SLjob."No.", FirstDayDate, NewDate)
                        else
                            SLPeriodCosts := SLPeriodCosts + GetJobLedgerEntryNew(SLjob."No.", startdate, NewDate);
                        if CurrEstCostCompletion = 0 then
                            SLCurrEstCostCompletion := SLCurrEstCostCompletion + GetCurrEstCost(asofdate, SLJob."No.")
                        else
                            SLCurrBugCost := SLCurrBugCost + GetCurrEstCostNew(calcdate('1D', RevenueRecSummaryCurrEst."NS_Posting Date"), asofdate, SLjob."No.");
                        SLBillingToDate := SLBillingToDate + GetBillingtodate(SLJob."No.", PostingdateFilter);//PRJ-830
                    until SLJob.next = 0;

                BillingToDate := -(MasterBillingToDate + SLBillingToDate);//PRJ-830.MS.1.0

                CurrContract := MasterCurrContract + SLCurrContract;
                if CurrEstCostCompletion = 0 then
                    CurrEstCostCompletion := MasterCurrEstCostCompletion + SLCurrEstCostCompletion
                else
                    CurrEstCostCompletion := CurrEstCostCompletion + MasterCurrBugCost + SLCurrBugCost;

                ActualCostsTodate := MasterActualCostsTodate + SLActualCostsTodate;
                PeriodCosts := MasterPeriodCosts + SLPeriodCosts;
                if CurrEstCostCompletion <> 0 then
                    POC := Round((ActualCostsTodate / CurrEstCostCompletion) * 100, Jobsetup."NS_Forecast Amount Rounding");
                //PRJ-658.AS.1.0 04MAY2021 - START 
                //CTSI-284.MS.1.0 start
                DateFilter := GetFilter("NS_Date Filter");
                if DateFilter > '' then
                    MaxDate := GetRangeMax("NS_Date Filter");
                if (Job."NS_Actual PercentCompleteDate" <= MaxDate) or (DateFilter = '') then
                    if (Job."NS_Actual Percent Complete" = 100) and (Job."NS_Actual PercentCompleteDate" <> 0D) then begin
                        POC := 100;
                        CurrEstCostCompletion := (ActualCostsTodate / POC) * 100;
                    end else begin

                    end;
                //CTSI-284.MS.1.0 end
                IF POC > 100 THEN
                    POC := 100;
                IF POC < 0 THEN
                    POC := 0;
                //PRJ-658.AS.1.0 04MAY2021 - END
                GrossRev := round(CurrContract * POC / 100, Jobsetup."NS_Forecast Amount Rounding");
                GrossProfit := GrossRev - ActualCostsTodate;
                if GrossRev <> 0 then
                    CurrentGM := round((GrossProfit / GrossRev) * 100, Jobsetup."NS_Forecast Amount Rounding");

                //PRJ-658.AS.1.0 04MAY2021 - START
                IF CurrentGM > 100 then
                    CurrentGM := 100;
                IF CurrentGM < 0 then
                    CurrentGM := 0;
                //PRJ-658.AS.1.0 04MAY2021 - END
                //PRJ-830 start
                if BillingToDate > GrossRev then
                    Overbilling := BillingToDate - GrossRev;
                if BillingToDate < GrossRev then
                    Underbilling := GrossRev - BillingToDate;
                //PRJ-830 end
                RevenueRecSummaryTab.Reset();
                RevenueRecSummaryTab.SetRange("NS_Job No.", "No.");
                RevenueRecSummaryTab.setrange("NS_Posting Date", 0D, premonthLastDayDate);
                RevenueRecSummaryTab.SetFilter(NS_voided, '%1', false);
                RevenueRecSummaryTab.SetFilter("NS_Entry Type", '%1', RevenueRecSummaryTab."NS_Entry Type"::JFW);
                if RevenueRecSummaryTab.FindLast() then begin
                    NetRevenue := GrossRev - RevenueRecSummaryTab."NS_Gross Revenue";
                end Else
                    if RevenueRecSummaryTab."NS_Gross Revenue" = 0 then begin
                        RevenueRecSummaryTab2.Reset();
                        RevenueRecSummaryTab2.SetRange("NS_Job No.", "No.");
                        RevenueRecSummaryTab2.setrange("NS_Posting Date", 0D, premonthLastDayDate);
                        RevenueRecSummaryTab2.SetFilter(NS_voided, '%1', false);
                        RevenueRecSummaryTab2.SetFilter("NS_Entry Type", '%1', RevenueRecSummaryTab2."NS_Entry Type"::Finance);
                        if RevenueRecSummaryTab2.FindLast() then
                            NetRevenue := GrossRev - RevenueRecSummaryTab2."NS_Gross Revenue"
                        else//PRJ-658.AS.1.0 04MAY2021 Adjusted code here
                            NetRevenue := GrossRev;//PRJ-658.AS.1.0 04MAY2021 Adjusted code here
                    end;


                //NetProfit := NetRevenue - ActualCostsTodate;//PRJ-658.AS.1.0 12MAY20 COMMENT
                NetProfit := NetRevenue - PeriodCosts;//PRJ-658.AS.1.0 12MAY20 ADD

                if UpdateRecogSummaryDetails then begin
                    //do voided
                    RevenueRecSummaryVoid.Reset();
                    RevenueRecSummaryVoid.SetCurrentKey("NS_Entry No.");
                    RevenueRecSummaryVoid.SetRange("NS_Job No.", job."No.");
                    //  RevenueRecSummaryVoid.setfilter(NS_Posted, '%1', false); //PE-136.JS.1.0 29MAY2024
                    //RevenueRecSummaryVoid.SetFilter("True-Up Posted", '%1', false);//CTSI-286 rollback
                    RevenueRecSummaryVoid.setrange("NS_Posting Date", PostingDate);
                    RevenueRecSummaryVoid.SetFilter(NS_Voided, '%1', false);
                    RevenueRecSummaryVoid.SetFilter("NS_Entry Type", '%1', RevenueRecSummaryVoid."NS_Entry Type"::Finance);
                    if RevenueRecSummaryVoid.FindSet() then
                        repeat
                            RevenueRecSummaryVoid.NS_Voided := true;
                            RevenueRecSummaryVoid.Modify();
                        until RevenueRecSummaryVoid.next = 0;

                    //PRJ-658.AS.1.0 04MAY2021 changed variables to RevenueRecSummaryTab_N = RevenueRecSummaryTab - START
                    RevenueRecSummaryTab_N.Init();
                    RevenueRecSummaryTab_N."NS_Posting Date" := PDate;
                    RevenueRecSummaryTab_N."NS_Entry Type" := RevenueRecSummaryTab_N."NS_Entry Type"::Finance;
                    RevenueRecSummaryTab_N."NS_Job No." := job."No.";
                    RevenueRecSummaryTab_N."NS_Job Description" := job.Description;
                    RevenueRecSummaryTab_N."NS_Current Contract" := CurrContract;
                    RevenueRecSummaryTab_N."NS_Current(TCE) Est. Cost at Completion" := CurrEstCostCompletion;
                    RevenueRecSummaryTab_N."NS_Actual Costs To Date" := ActualCostsTodate;
                    RevenueRecSummaryTab_N."NS_Period Costs" := PeriodCosts;
                    RevenueRecSummaryTab_N."NS_POC %" := POC;
                    RevenueRecSummaryTab_N."NS_Current GM %" := CurrentGM;
                    RevenueRecSummaryTab_N."NS_Gross Revenue" := GrossRev;
                    RevenueRecSummaryTab_N."NS_Gross Profit" := GrossProfit;
                    RevenueRecSummaryTab_N."NS_Net Revenue" := NetRevenue;
                    RevenueRecSummaryTab_N."NS_Net Profit" := NetProfit;
                    RevenueRecSummaryTab_N."NS_Billings to Date" := BillingToDate;//PRJ-830
                    RevenueRecSummaryTab_N."NS_Over Billings" := Overbilling;//PRJ-830
                    RevenueRecSummaryTab_N."NS_Under Billings" := Underbilling;//PRJ-830
                    //PRJCTPR-297.NC.1.0 18Jan2024 Start
                    RevenueRecSummaryTab_N."NS_Global Dimension 1 Code" := job."Global Dimension 1 Code";
                    RevenueRecSummaryTab_N."NS_Global Dimension 2 Code" := job."Global Dimension 2 Code";
                    RevenueRecSummaryTab_N."NS_Dimension Set ID" := RevenueRecSummaryTab_N.GetDimensionNoFromJob(Job."No.");
                    //PRJCTPR-297.NC.1.0 18Jan2024 End
                    //FGH-163.SM.29022024 //PE-269.JS.1.0 START
                    NS_OnAfterGetRecordRevRec(RevenueRecSummaryTab_N, Job);
                    //FGH-163.SM.29022024 //PE-269.JS.1.0 END
                    RevenueRecSummaryTab_N.Insert();
                    //PRJ-658.AS.1.0 04MAY2021 changed variables from RevenueRecSummaryTab_N = RevenueRecSummaryTab - END
                end;

            end;
        }

    }


    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    Caption = ' ';
                    field(UpdateRecogSummaryDetails; UpdateRecogSummaryDetails)
                    {
                        Caption = 'Update Rev. Recog. Summary Details';
                        ApplicationArea = All;
                        //     trigger OnValidate()
                        //     begin
                        //         if UpdateRecogSummaryDetails = true then
                        //             PostingDateFlag := true
                        //         else
                        //             PostingDateFlag := false;
                        //     end;
                    }
                    field(PostingDate; PostingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting Date';
                        trigger OnValidate()
                        var
                        begin
                            if NOT UpdateRecogSummaryDetails then
                                if PostingDate <> 0D then
                                    Error('You cannot define Posting date if Update Rev. Recog. Summary Details boolean is false.');
                        end;
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    trigger OnPreReport()
    var
    begin
        if UserSetup.Get(UserId) then
            if NOT UserSetup."NS_AccessTo Rev.RecognitionReport" then
                Error('You are not authorized to run this Report.');

        Jobfilter := Job.GetFilters;
    end;

    var


        EntryTypeLbl: Label 'Entry Type';
        CurrContractlbl: Label 'Current Contract';
        CurrCostCompletionLbl: Label 'Current(TCE) Est. Cost at Completion ';
        ActualCostsTodateLbl: Label 'Actual Costs To Date';
        PeriodCostsLbl: Label 'Period Costs';
        POCLbl: Label 'POC %';
        CurrentGMLbl: Label 'Current GM %';
        GrossRevLbl: Label 'Gross Revenue ';
        GrossProfitLbl: Label 'Gross Profit';
        NetProfitLbl: Label 'Net Profit';
        NetRevenueLbl: Label 'Net Revenue';
        PostingDate: Date;
        EntryType: Option JFW,Finance;

        CurrContract: Decimal;
        CurrEstCostCompletion: Decimal;
        ActualCostsTodate: Decimal;
        PeriodCosts: Decimal;
        POC: Decimal;
        CurrentGM: Decimal;
        GrossRev: Decimal;
        GrossProfit: Decimal;
        NetProfit: Decimal;
        NetRevenue: Decimal;
        userSetup: Record "User Setup";
        UpdateRecogSummaryDetails: boolean;
        PostingDateFlag: Boolean;
        RevenueRecSummaryTab: Record NS_RevenueRecSummaryTab;
        PDate: Date;
        MasterJob: Code[20];
        PostingdateFilter: Text;
        Jobsetup: Record "Jobs Setup";
        FirstDayDate: date;
        LastDayDate: date;
        premonthFirstDayDate: Date;
        premonthLastDayDate: date;
        asofdate: date;
        Jobfilter: Text[250];
        startdate: Date;
        NewDate: Date;
        DateFilter: text;//CTSI-284;
        MaxDate: Date;//CTSI-284;
        BillingToDate: Decimal;//PRJ-830
        MasterBillingToDate: Decimal;//PRJ-830
        SLBillingToDate: Decimal;//PRJ-830

        Overbilling: Decimal;//PRJ-830
        Underbilling: Decimal;//PRJ-830

    local procedure GetPlanningLine(DateFilter: Text; var ParaJob: Code[20]) Answer: Decimal;
    var
        PlanningLine: Record "Job Planning Line";
    begin
        Answer := 0;
        PlanningLine.Reset();
        PlanningLine.SetRange("Job No.", ParaJob);       //for asofdate and current month
        PlanningLine.SetFilter("Line Type", '<>%1', PlanningLine."Line Type"::Budget);
        PlanningLine.setfilter("Planning Date", DateFilter);
        if PlanningLine.FindSet() then
            repeat
                Answer := round(Answer + PlanningLine."Line Amount (LCY)", Jobsetup."NS_Forecast Amount Rounding");
            until PlanningLine.Next() = 0;
        exit(Answer);
    end;

    local procedure GetJobLedgerEntry(JobNo: Code[20]; Var Datefilter: Text) SumOfTotalCostsUsed: Decimal;
    var
        JobLedEntry: Record "Job Ledger Entry";
    begin
        SumOfTotalCostsUsed := 0;
        JobLedEntry.Reset();
        JobLedEntry.SetCurrentKey("Job No.", "Posting Date");
        JobLedEntry.SetRange("Job No.", JobNo);
        JobLedEntry.Setfilter("Posting Date", Datefilter);
        JobLedEntry.SetFilter("Entry Type", '%1', JobLedEntry."Entry Type"::Usage);
        if JobLedEntry.FindSet() then
            repeat
                SumOfTotalCostsUsed := round(SumOfTotalCostsUsed + JobLedEntry."Total Cost (LCY)", Jobsetup."NS_Forecast Amount Rounding");
            until JobLedEntry.Next() = 0;
        exit(SumOfTotalCostsUsed);

    end;

    local procedure GetJobLedgerEntryNew(JobNo: Code[20]; Var StartDate: date; var EndDate: date) SumOfTotalCostsUsed: Decimal;
    var
        JobLedEntry: Record "Job Ledger Entry";
    begin
        SumOfTotalCostsUsed := 0;
        JobLedEntry.Reset();
        JobLedEntry.SetCurrentKey("Job No.", "Posting Date");
        JobLedEntry.SetRange("Job No.", JobNo);
        JobLedEntry.SetRange("Posting Date", StartDate, EndDate);
        JobLedEntry.SetFilter("Entry Type", '%1', JobLedEntry."Entry Type"::Usage);
        if JobLedEntry.FindSet() then
            repeat
                SumOfTotalCostsUsed := round(SumOfTotalCostsUsed + JobLedEntry."Total Cost (LCY)", Jobsetup."NS_Forecast Amount Rounding");
            until JobLedEntry.Next() = 0;
        exit(SumOfTotalCostsUsed);

    end;

    local procedure GetCurrEstCost(asofdate: Date; var ParaJob: Code[20]) Answer: Decimal;
    var
        PlanningLine: Record "Job Planning Line";
    begin
        Answer := 0;
        PlanningLine.Reset();
        PlanningLine.SetRange("Job No.", ParaJob);
        PlanningLine.SetFilter("Line Type", '<>%1', PlanningLine."Line Type"::Billable);
        PlanningLine.SetRange("Planning Date", 0D, asofdate);
        if PlanningLine.FindSet() then
            repeat
                Answer := round(Answer + PlanningLine."Total Cost (LCY)", Jobsetup."NS_Forecast Amount Rounding");
            until PlanningLine.Next() = 0;
        exit(Answer);
    end;

    local procedure GetCurrEstCostNew(Startdate: date; asofdate: Date; var ParaJob: Code[20]) Answer: Decimal;
    var
        PlanningLine: Record "Job Planning Line";
    begin
        Answer := 0;
        PlanningLine.Reset();
        PlanningLine.SetRange("Job No.", ParaJob);
        PlanningLine.SetFilter("Line Type", '<>%1', PlanningLine."Line Type"::Billable);
        PlanningLine.SetRange("Planning Date", Startdate, asofdate);
        if PlanningLine.FindSet() then
            repeat
                Answer := round(Answer + PlanningLine."Total Cost (LCY)", Jobsetup."NS_Forecast Amount Rounding");
            until PlanningLine.Next() = 0;
        exit(Answer);
    end;
    //PRJ-830.MS.1.0 start
    local procedure GetBillingtodate(JobNo: Code[20]; Var Datefilter: Text) SumOfTotalCostsUsed: Decimal;
    var
        JobLedEntry: Record "Job Ledger Entry";
    begin
        SumOfTotalCostsUsed := 0;
        JobLedEntry.Reset();
        JobLedEntry.SetCurrentKey("Job No.", "Posting Date");
        JobLedEntry.SetRange("Job No.", JobNo);
        JobLedEntry.Setfilter("Posting Date", Datefilter);
        JobLedEntry.SetFilter("Entry Type", '%1', JobLedEntry."Entry Type"::Sale);
        if JobLedEntry.FindSet() then
            repeat
                //PRJ-830.GK.1.0 06Sep2021 start
                //SumOfTotalCostsUsed := round(SumOfTotalCostsUsed + JobLedEntry."Line Amount (LCY)", Jobsetup."NS_Forecast Amount Rounding"); //Line Comment
                SumOfTotalCostsUsed := round(SumOfTotalCostsUsed + JobLedEntry."Total Price (LCY)", Jobsetup."NS_Forecast Amount Rounding"); //Line Added
                                                                                                                                             //PRJ-830.GK.1.0 06Sep2021 end
            until JobLedEntry.Next() = 0;
        exit(SumOfTotalCostsUsed);

    end;
    //PRJ-830.MS.1.0 end

    //FGH-163.SM.29022024 //PE-269.JS.1.0 START
    [IntegrationEvent(False, false)]
    local procedure NS_OnAfterGetRecordRevRec(var RevRec: record NS_RevenueRecSummaryTab; JobVar: Record Job)
    begin
    end;
    //FGH-163.SM.29022024 //PE-269.JS.1.0 END

}