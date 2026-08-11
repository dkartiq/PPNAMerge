/// <summary>
/// Page NS_OPS Manager (ID 14021287).
/// </summary>
page 14021287 "NS_OPS Manager"
{
    //PE-184.AT.1.0 Created New Query object for OPS Manager fields in Power Bi
    Caption = 'OPS Manager BI';
    //Caption = 'NS_OPS Manager List ';
    Editable = false;
    PageType = List;
    SourceTable = "job";
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("NS_No."; Rec."No.") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Current Contract Price"; CurrentContractPrice) { ApplicationArea = All; }
                field("Current Contract Cost"; CurrentContractBudget) { ApplicationArea = All; }
                field("Current Booked GM%"; CurrentBookedGM) { ApplicationArea = All; }
                field("Current To Date Billings"; CurrentToDateBillings) { ApplicationArea = All; }
                field("Current To Date Cost"; CurrentTodateCost) { ApplicationArea = All; }
                field("Current Forecasted Total Cost Estimate"; CurrentTotalCostEstimate) { ApplicationArea = All; }
                field("Current TCE Forecast Variance from Prior Month"; CurrentTCEForecastVariance) { ApplicationArea = All; }
                field("Current TCE To Current Contract Cost Variance"; CurrentTCEBudgetVariance) { ApplicationArea = All; }
                field("Current Forecasted Cost To Complete"; CurrentCostToComplete) { ApplicationArea = All; }
                field("Current Percent Complete"; CurrentPctDone) { ApplicationArea = All; }
                field("Current Recognized Revenue"; CurrentRecognizedRevenue) { ApplicationArea = All; }
                field("Current Recognized Profit (Loss)"; CurrentRecognizedProfitloss) { ApplicationArea = All; }
                field("Current Over Billings"; CurrentOverBillings) { ApplicationArea = All; }
                field("Current Under Billings"; CurrentUnderBillings) { ApplicationArea = All; }
                field("Original Contract Price"; OrignalContractPrice) { ApplicationArea = All; }
                field("Current Contract Price Variance"; CurrentContractPriceVariance) { ApplicationArea = All; }
                field("Original Budgeted Cost"; OrignalBudgetedCost) { ApplicationArea = All; }
                field("Current Budget Cost Variance"; CurrentBudgetVariance) { ApplicationArea = All; }
                field("Original GM%"; OrignalGM) { ApplicationArea = All; }
                field("State"; Rec."NS_Job County") { ApplicationArea = All; }
                field("PM"; Rec.NS_Manager) { ApplicationArea = All; }
                field("Name"; ManagerName) { ApplicationArea = All; }

            }
        }

    }
    trigger OnOpenPage()
    begin
        Rec.SetFilter("NS_Sub-Level to Job No.", '=%1', '');
        Rec.SetRange("NS_Exclude from Job Forecast", false);


        // IF NewStatusDateSentIn = 0D then
        //     Error('You must select As of Date');

        NewStatusDateSentIn := Today;

        FirstDayDate := CALCDATE('<-CM>', NewStatusDateSentIn);
        LastDayDate := CALCDATE('<CM>', FirstDayDate);

        premonthFirstDayDate := CALCDATE('<-1M>', FirstDayDate);
        PremonthLastDayDate := CALCDATE('<CM>', premonthFirstDayDate);
    end;

    trigger OnAfterGetRecord()
    var
        NS_RecJob: Record Job;
    begin

        Clear(CurrContractPriceMaster);
        Clear(CurrContractBudgetMaster);
        Clear(CurrToDateBillingsMaster);
        Clear(CurrentToDateCostMaster);
        PreviousForecastContractPriceMaster := 0;
        CurrentTotalCostEstimateMaster := 0;
        TotalForecastedCompletedCostsMaster := 0;
        Clear(PrevCostToCompleteMaster);
        OrignalContractPriceMaster := 0;
        Clear(OrignaBudgetedCostMaster);
        Clear(CommentMaster2);
        Clear(CommentMaster2);
        Clear(CommentMaxVar);
        Clear(CurrContractPriceSL);
        Clear(CurrContractBudgetSL);
        Clear(CurrTodateBillingsSL);
        CurrentToDateCostSL := 0;
        CurrentTotalCostEstimateSL := 0;
        PreviousForecastContractPriceSL := 0;
        TotalForecastedCompletedCostsSL := 0;
        Clear(PrevCostToCompleteSL);
        OrignalContractPriceSL := 0;
        Clear(OrignalBudgetedCostSL);

        //Curr Contract Price Master
        flag := false;
        CurrContractPriceMaster := GetPlanningLine(0D, NewStatusDateSentIn, Rec."No.", Flag);

        //Curr Contract Budget Master
        Flag := true;
        CurrContractBudgetMaster := GetPlanningLine(0D, NewStatusDateSentIn, Rec."No.", Flag);

        //Current To date Billings Master
        CurrToDateBillingsMaster := CurrentToDateBillingsCalc(Rec);

        //Current To Date Cost Master
        CurrentToDateCostMaster := FindUsageCost(Rec);

        //Current total cost estimate
        RecProjSummDtl.Reset();
        RecProjSummDtl.SetCurrentKey("NS_Job No.", "NS_Posting Date");
        RecProjSummDtl.SetRange("NS_Job No.", Rec."No.");
        RecProjSummDtl.SetRange("NS_Posting Date", NewStatusDateSentIn);
        if RecProjSummDtl.FindLast() then
            CurrentTotalCostEstimateMaster := RecProjSummDtl.NS_TotalForecastCompletedCost;

        //Total Contract Revenue Master
        Flag := false;
        FlagTotCostTodate := false;
        PreviousForecastContractPriceMaster := GetPrevSummaryDetailPrev(premonthFirstDayDate, PremonthLastDayDate, REC."No.", Flag, FlagTotCostTodate);

        //Total Forecasted Completed Costs Master
        Flag := true;
        FlagTotCostTodate := false;
        TotalForecastedCompletedCostsMaster := GetPrevSummaryDetailPrev(premonthFirstDayDate, PremonthLastDayDate, REC."No.", Flag, FlagTotCostTodate);
        FlagTotCostTodate := false;
        PrevCostToCompleteMaster := PreviousCosttoCompCalculations(premonthFirstDayDate, PremonthLastDayDate, REC."No.", Flag, FlagTotCostTodate);

        //Orignal Contract Price Master
        if REC."NS_Contract Date" <> 0D then begin
            JobPLLineRec.Reset();
            JobPLLineRec.SetRange("Job No.", REC."No.");
            JobPLLineRec.SetFilter("Line Type", '<>%1', JobPLLineRec."Line Type"::Budget);
            JobPLLineRec.SetFilter("Planning Date", '%1', REC."NS_Contract Date");
            if JobPLLineRec.FindSet() then
                repeat
                    OrignalContractPriceMaster += JobPLLineRec."Line Amount (LCY)";
                until JobPLLineRec.Next() = 0;
        end;
        //Orignal Budgeted Cost Master 
        if REC."NS_Contract Date" <> 0D then begin
            JobPLLineRec.Reset();
            JobPLLineRec.SetRange("Job No.", REC."No.");
            JobPLLineRec.SetFilter("Line Type", '<>%1', JobPLLineRec."Line Type"::Billable);
            JobPLLineRec.SetFilter("Planning Date", '=%1', REC."NS_Contract Date");
            JobPLLineRec.SetFilter(NS_Adjustment, '=%1', '');
            if JobPLLineRec.FindSet() then
                repeat
                    OrignaBudgetedCostMaster += JobPLLineRec."Total Cost (LCY)";
                until JobPLLineRec.Next() = 0;
        end;

        //Comments

        CommentLineRec.Reset();
        CommentLineRec.SetRange("Table Name", CommentLineRec."Table Name"::Job);
        CommentLineRec.SetRange("No.", REC."No.");
        CommentLineRec.SetRange(Date, NewStatusDateSentIn);
        if CommentLineRec.FindSet() then
            repeat
                CommentMaxVar += CommentLineRec.Comment + ',';
            until CommentLineRec.Next() = 0;
        CommentsMaster1 := CopyStr(CommentMaxVar, 1, 250);
        CommentMaster2 := CopyStr(CommentMaxVar, 251, 250);

        //SUB LEVEL CALCULATIONS

        SLJob.Reset();
        SLJob.SetRange("NS_Sub-Level to Job No.", REC."No.");
        SLJob.SetRange("NS_Exclude from Job Forecast", false);
        if Jobsetup."NS_GBPG for Job Forecast" <> '' then
            // SLJob.SetFilter("NS_Gen. Bus. Posting Group", Jobsetup."NS_GBPG for Job Forecast");//PRJ-831.AS.1.0 12OCT2021 Comment old
            SLJob.SetFilter("NS_Gen. Bus. Posting Group New", Jobsetup."NS_GBPG for Job Forecast");//PRJ-831.AS.1.0 12OCT2021 Add New
        if SLJob.FindSet() then
            repeat
                //Curr Contract Price Sub Level
                Flag := false;
                CurrContractPriceSL := CurrContractPriceSL + GetPlanningLine(0D, NewStatusDateSentIn, SLJob."No.", Flag);

                //Curr Contract Budget Sub Level
                Flag := true;
                CurrContractBudgetSL := CurrContractBudgetSL + GetPlanningLine(0D, NewStatusDateSentIn, SLJob."No.", Flag);

                //Current To date Billings SL
                CurrTodateBillingsSL := CurrTodateBillingsSL + CurrentToDateBillingsCalc(SLJob);

                //Current To date Cost Sub Level
                CurrentToDateCostSL := CurrentToDateCostSL + FindUsageCost(SLJob);

                //Current Total Cost Estimate sub level

                RecProjSummDtl.Reset();
                RecProjSummDtl.SetCurrentKey("NS_Job No.", "NS_Posting Date");
                RecProjSummDtl.SetRange("NS_Job No.", SLJob."No.");
                RecProjSummDtl.SetRange("NS_Posting Date", NewStatusDateSentIn);
                if RecProjSummDtl.FindLast() then
                    CurrentTotalCostEstimateSL := CurrentTotalCostEstimateSL + RecProjSummDtl.NS_TotalForecastCompletedCost;

                //Total Contract Revenue Sub Level

                Flag := false;
                FlagTotCostTodate := false;
                PreviousForecastContractPriceSL := PreviousForecastContractPriceSL + GetPrevSummaryDetailPrev(premonthFirstDayDate, PremonthLastDayDate, SLJob."No.", Flag, FlagTotCostTodate);

                //Total Forecasted Completed Costs sub level

                Flag := true;
                FlagTotCostTodate := false;
                TotalForecastedCompletedCostsSL := TotalForecastedCompletedCostsSL + GetPrevSummaryDetailPrev(premonthFirstDayDate, PremonthLastDayDate, SLJob."No.", Flag, FlagTotCostTodate);
                FlagTotCostTodate := false;
                PrevCostToCompleteSL := PrevCostToCompleteSL + PreviousCosttoCompCalculations(premonthFirstDayDate, PremonthLastDayDate, SLJob."No.", Flag, FlagTotCostTodate);

                //Orignal Contract Price Sub Level
                if SLJob."NS_Contract Date" <> 0D then begin
                    JobPLLineRec.Reset();
                    JobPLLineRec.SetRange("Job No.", SLJob."No.");
                    JobPLLineRec.SetFilter("Line Type", '<>%1', JobPLLineRec."Line Type"::Budget);
                    JobPLLineRec.SetFilter("Planning Date", '%1', SLJob."NS_Contract Date");
                    if JobPLLineRec.FindSet() then
                        repeat
                            OrignalContractPriceSL += JobPLLineRec."Line Amount (LCY)";
                        until JobPLLineRec.Next() = 0;
                end;

                //Orignal Budgeted Cost Sub Level
                if SLJob."NS_Contract Date" <> 0D then begin
                    JobPLLineRec.Reset();
                    JobPLLineRec.SetRange("Job No.", SLJob."No.");
                    JobPLLineRec.SetFilter("Line Type", '<>%1', JobPLLineRec."Line Type"::Billable);
                    JobPLLineRec.SetFilter("Planning Date", '=%1', SLJob."NS_Contract Date");
                    JobPLLineRec.SetFilter(NS_Adjustment, '=%1', '');
                    if JobPLLineRec.FindSet() then
                        repeat
                            OrignalBudgetedCostSL += JobPLLineRec."Total Cost (LCY)";
                        until JobPLLineRec.Next() = 0;
                end;
            until SLJob.next = 0;
        Calculations;
    end;

    procedure GetPlanningLine(StartDate: Date; var Enddate: Date; var ParaJob: Code[20]; var Flag: Boolean) Answer: Decimal;
    var
        PlanningLine: Record "Job Planning Line";
    begin
        Answer := 0;
        PlanningLine.Reset();
        PlanningLine.SetRange("Job No.", ParaJob);       //for asofdate and current month
        if not Flag then
            PlanningLine.SetFilter("Line Type", '<>%1', PlanningLine."Line Type"::Budget)
        else
            PlanningLine.SetFilter("Line Type", '<>%1', PlanningLine."Line Type"::Billable);
        PlanningLine.SetRange("Planning Date", StartDate, Enddate);
        if PlanningLine.FindSet() then
            repeat
                if Flag then
                    Answer := Answer + PlanningLine."Total Cost (LCY)"
                else
                    Answer := Answer + PlanningLine."Line Amount (LCY)";

            until PlanningLine.Next() = 0;
        exit(Answer);
    end;

    procedure FindUsageCost(Job: Record Job) Usage: Decimal;
    begin
        Usage := 0;
        //PRJ-1133.NK.1.0 Start
        //with Job do begin

        JobLedgEntry.RESET();
        JobLedgEntry.SETCURRENTKEY("Job No.", "Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                   "NS_Job Cost Category", "NS_Job Revenue Category", Type, "No.", "Resource Group No.", "Posting Date");
        JobLedgEntry.SETRANGE("Job No.", Job."No.");
        JobLedgEntry.SETRANGE("Entry Type", JobLedgEntry."Entry Type"::Usage);
        JobLedgEntry.SETFILTER("NS_Activity Code", Job.GETFILTER("NS_Activity Filter"));
        JobLedgEntry.SETFILTER("NS_Process Code", Job.GETFILTER("NS_Process Filter"));
        JobLedgEntry.SETFILTER("NS_Operation Code", Job.GETFILTER("NS_Operation Filter"));
        JobLedgEntry.SETFILTER("NS_Job Cost Category", Job.GETFILTER("NS_Cost Category Filter"));
        JobLedgEntry.SetFilter("Posting Date", '%1..%2', 0D, NewStatusDateSentIn);
        if JobLedgEntry.FINDSET() then
            repeat
                Usage := Usage + JobLedgEntry."Total Cost (LCY)";

            until JobLedgEntry.NEXT() = 0;
        //end;
        //PRJ-1133.NK.1.0 End
    end;


    procedure CurrentToDateBillingsCalc(Job: Record Job) Price: Decimal;
    begin
        Price := 0;
        //PRJ-1133.NK.1.0 Start
        //with Job do begin

        JobLedgEntry.RESET();
        JobLedgEntry.SETCURRENTKEY("Job No.", "Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                   "NS_Job Cost Category", "NS_Job Revenue Category", Type, "No.", "Resource Group No.", "Posting Date");
        JobLedgEntry.SETRANGE("Job No.", Job."No.");
        JobLedgEntry.SETRANGE("Entry Type", JobLedgEntry."Entry Type"::Sale);
        JobLedgEntry.SETFILTER("NS_Activity Code", Job.GETFILTER("NS_Activity Filter"));
        JobLedgEntry.SETFILTER("NS_Process Code", Job.GETFILTER("NS_Process Filter"));
        JobLedgEntry.SETFILTER("NS_Operation Code", Job.GETFILTER("NS_Operation Filter"));
        JobLedgEntry.SETFILTER("NS_Job Revenue Category", Job.GETFILTER("NS_Revenue Category Filter"));
        JobLedgEntry.SetFilter("Posting Date", '%1..%2', 0D, NewStatusDateSentIn);

        if JobLedgEntry.FINDSET() then
            repeat
                Price := Price - JobLedgEntry."Total Price (LCY)";
            until JobLedgEntry.NEXT() = 0;

        //end;
        //PRJ-1133.NK.1.0 End
    end;

    procedure GetPrevSummaryDetailPrev(PreStartDate: Date; var PreEnddate: Date; var ParaJob: Code[20]; var Flag: Boolean; var FlagTotCostTodate: boolean) Answer: Decimal
    var
        ProjSummDetail: Record "NS_Percentage of Completion";
    begin
        Answer := 0;
        ProjSummDetail.Reset();
        ProjSummDetail.SetCurrentKey("NS_Job No.", "NS_Posting Date");
        ProjSummDetail.SetRange("NS_Job No.", ParaJob);                    //for prev. month
        ProjSummDetail.SetRange("NS_Posting Date", PreStartDate, PreEndDate);
        if ProjSummDetail.FindLast() then begin
            if not FlagTotCostTodate then begin
                if Flag then
                    Answer := ProjSummDetail.NS_TotalForecastCompletedCost
                else
                    Answer := ProjSummDetail."NS_Total Contract Revenue";
            end else
                Answer := ProjSummDetail."NS_Total Cost to Date";
        end;
        exit(Answer);

    end;

    procedure GetPrevSummaryDetail(PreStartDate: Date; var PreEnddate: Date; var ParaJob: Code[20]; var Flag: Boolean; var FlagTotCostTodate: boolean) Answer: Decimal
    var
        ProjSummDetail: Record "NS_Percentage of Completion";
    begin
        Answer := 0;
        ProjSummDetail.Reset();
        ProjSummDetail.SetCurrentKey("NS_Job No.", "NS_Posting Date");
        ProjSummDetail.SetRange("NS_Job No.", ParaJob);                    //for prev. month
        ProjSummDetail.SetRange("NS_Posting Date", PreStartDate, PreEndDate);
        if ProjSummDetail.FindLast() then begin
            if not FlagTotCostTodate then begin
                if Flag then
                    Answer := ProjSummDetail.NS_TotalForecastCompletedCost
                else
                    Answer := ProjSummDetail."NS_Total Contract Revenue";
            end else
                Answer := ProjSummDetail."NS_Total Cost to Date";
        end;
        exit(Answer);

    end;

    procedure PreviousCosttoCompCalculations(PreStartDate: Date; var PreEnddate: Date; var ParaJob: Code[20]; var Flag: Boolean; var FlagTotCostTodate: boolean) Answer: Decimal
    var
        ProjSummDetail: Record "NS_Percentage of Completion";
    begin
        Answer := 0;
        ProjSummDetail.Reset();
        ProjSummDetail.SetCurrentKey("NS_Job No.", "NS_Posting Date");
        ProjSummDetail.SetRange("NS_Job No.", ParaJob);                    //for prev. month
        ProjSummDetail.SetRange("NS_Posting Date", PreStartDate, PreEndDate);
        if ProjSummDetail.FindLast() then begin
            if not FlagTotCostTodate then begin
                if Flag then
                    Answer := ProjSummDetail."NS_Forecasted Cost Remaining"
            end;
        end;
        exit(Answer);

    end;

    procedure Calculations()
    var

    begin
        CurrentContractPrice := 0;
        CurrentContractBudget := 0;
        CurrentBookedGM := 0;
        Clear(CurrentToDateBillings);
        Clear(CurrentTodateCost);
        CurrentTotalCostEstimate := 0;
        Clear(CurrentCostToComplete);
        Clear(PrevCostToComplete);
        CurrentGM := 0;
        Clear(CurrentPctDone);
        Clear(CurrentRecognizedRevenue);
        Clear(CurrentRecognizedProfitloss);
        Clear(CurrentOverBillings);
        Clear(CurrentUnderBillings);
        PreviousForecastContractPrice := 0;
        TotalForecastedCompletedCosts := 0;
        PreviousForecastGM := 0;
        CurrentGMForecastVariance := 0;
        CurrentTCEForecastVariance := 0;
        CurrentTCEBudgetVariance := 0;
        OrignalContractPrice := 0;
        Clear(CurrentContractPriceVariance);
        Clear(OrignalBudgetedCost);
        Clear(CurrentBudgetVariance);
        OrignalGM := 0;
        Clear(CurrentGMBudgetVariance);
        if JobSetup.Get() then;
        if JobSetup."NS_Enab. Budg.on Contract Date" then
            CurrentContractPrice := FindContDaseBaseAmt(REC)
        else
            CurrentContractPrice := CurrContractPriceMaster + CurrContractPriceSL;
        CurrentContractBudget := CurrContractBudgetMaster + CurrContractBudgetSL;

        if CurrentContractPrice <> 0 then
            CurrentBookedGM := Round((CurrentContractPrice - CurrentContractBudget) * 100 / CurrentContractPrice, Jobsetup."NS_Forecast Amount Rounding");

        CurrentToDateBillings := CurrToDateBillingsMaster + CurrTodateBillingsSL;
        CurrentTodateCost := CurrentToDateCostMaster + CurrentToDateCostSL;

        if (CurrentTotalCostEstimateMaster <> 0) or (CurrentTotalCostEstimateSL <> 0) then
            CurrentTotalCostEstimate := CurrentTotalCostEstimateMaster + CurrentTotalCostEstimateSL
        else
            CurrentTotalCostEstimate := CurrentContractBudget;
        CurrentCostToComplete := CurrentTotalCostEstimate - CurrentTodateCost;
        PrevCostToComplete := PrevCostToCompleteMaster + PrevCostToCompleteSL;

        if CurrentContractPrice <> 0 then
            CurrentGM := round((CurrentContractPrice - CurrentTotalCostEstimate) * 100 / CurrentContractPrice, Jobsetup."NS_Forecast Amount Rounding");

        if CurrentTotalCostEstimate <> 0 then
            CurrentPctDone := Round((CurrentTodateCost / CurrentTotalCostEstimate) * 100, Jobsetup."NS_Forecast Amount Rounding");

        CurrentRecognizedRevenue := Round((CurrentPctDone * CurrentContractPrice) / 100, Jobsetup."NS_Forecast Amount Rounding");
        CurrentRecognizedProfitloss := CurrentRecognizedRevenue - CurrentTodateCost;

        if CurrentToDateBillings > CurrentRecognizedRevenue then
            CurrentOverBillings := CurrentToDateBillings - CurrentRecognizedRevenue;

        if CurrentRecognizedRevenue > CurrentToDateBillings then
            CurrentUnderBillings := CurrentRecognizedRevenue - CurrentToDateBillings;

        PreviousForecastContractPrice := PreviousForecastContractPriceMaster + PreviousForecastContractPriceSL;
        TotalForecastedCompletedCosts := TotalForecastedCompletedCostsMaster + TotalForecastedCompletedCostsSL;

        if PreviousForecastContractPrice <> 0 then
            PreviousForecastGM := Round((PreviousForecastContractPrice - TotalForecastedCompletedCosts) * 100 / PreviousForecastContractPrice, Jobsetup."NS_Forecast Amount Rounding");

        CurrentGMForecastVariance := CurrentGM - PreviousForecastGM;


        CurrentTCEForecastVariance := CurrentTotalCostEstimate - TotalForecastedCompletedCosts;
        CurrentTCEBudgetVariance := CurrentTotalCostEstimate - CurrentContractBudget;
        OrignalContractPrice := OrignalContractPriceMaster + OrignalContractPriceSL;

        CurrentContractPriceVariance := CurrentContractPrice - OrignalContractPrice;
        OrignalBudgetedCost := OrignaBudgetedCostMaster + OrignalBudgetedCostSL;
        CurrentBudgetVariance := CurrentContractBudget - OrignalBudgetedCost;

        if OrignalContractPrice <> 0 then
            OrignalGM := Round((OrignalContractPrice - OrignalBudgetedCost) * 100 / OrignalContractPrice, Jobsetup."NS_Forecast Amount Rounding");

        CurrentGMBudgetVariance := CurrentGM - OrignalGM;

        if CurrentGM < 0 then
            CurrentGM := 0
        else
            if CurrentGM > 100 then
                CurrentGM := 100;

        if OrignalGM < 0 then
            OrignalGM := 0
        else
            if OrignalGM > 100 then
                OrignalGM := 100;

        if PreviousForecastGM < 0 then
            PreviousForecastGM := 0
        else
            if PreviousForecastGM > 100 then
                PreviousForecastGM := 100;

        if CurrentPctDone < 0 then
            CurrentPctDone := 0
        else
            if CurrentPctDone > 100 then
                CurrentPctDone := 100;
    end;


    procedure FindContDaseBaseAmt(Job: Record Job) ContAmt: Decimal;
    var
        JobPlannLine: Record "Job Planning Line";
        NSJob: record job;
        JobNoFilter: Code[100];
    begin
        ContAmt := 0;
        JobNoFilter := '@*' + format(Job."No.") + '*';
        JobPlannLine.RESET();
        JobPlannLine.SetRange("Job No.", Job."No.");
        JobPlannLine.SetFilter("Line Type", '%1|%2', JobPlannLine."Line Type"::Billable, JobPlannLine."Line Type"::"Both Budget and Billable");
        JobPlannLine.SETFILTER("Job Task No.", Job.GetFilter("NS_Job Task No. Filter"));
        JobPlannLine.SetFilter("NS_Revenue Category", Job.GetFilter("NS_Revenue Category Filter"));
        //PE-306.JS.1.0 06JUN2024-Start
        //JobPlannLine.SETFILTER(Type, Job.GetFilter("NS_Type Filter"));
        JobPlannLine.SETFILTER(Type, Job.GetFilter("NS_TypeEnumFilter"));
        //PE-306.JS.1.0 06JUN2024-end
        if NewStatusDateSentIn <> 0D then
            JobPlannLine.SetFilter("NS_Contract Forecast Date", '..%1', NewStatusDateSentIn);
        JobPlannLine.SETFILTER(NS_Adjustment, Job.GetFilter("NS_Adjustment Filter"));
        JobPlannLine.SETFILTER("NS_Shortcut Dimension 1 Code", Job.GetFilter("NS_Global Dimension 1 Filter"));
        JobPlannLine.SETFILTER("NS_Shortcut Dimension 2 Code", Job.GetFilter("NS_Global Dimension 2 Filter"));
        JobPlannLine.SETFILTER("NS_Retention Ledger Code", Job.getfilter("NS_Retention Ledger Filter"));
        if JobPlannLine.FINDSET() then
            repeat
                ContAmt := ContAmt + JobPlannLine."Total Price (LCY)";
            until JobPlannLine.NEXT() = 0;
        NSJob.Reset();
        NSJob.SetCurrentKey("NS_Sub-Level to Job No.");
        NSJob.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        if NSJob.FindSet() then
            repeat
                JobPlannLine.RESET();
                JobPlannLine.SetRange("Job No.", NSJob."No.");
                JobPlannLine.SetFilter("Line Type", '%1|%2', JobPlannLine."Line Type"::Billable, JobPlannLine."Line Type"::"Both Budget and Billable");
                JobPlannLine.SETFILTER("Job Task No.", Job.GetFilter("NS_Job Task No. Filter"));
                JobPlannLine.SetFilter("NS_Revenue Category", Job.GetFilter("NS_Revenue Category Filter"));
                //PE-306.JS.1.0 06JUN2024-Start
                //JobPlannLine.SETFILTER(Type, Job.GetFilter("NS_Type Filter"));
                JobPlannLine.SETFILTER(Type, Job.GetFilter("NS_TypeEnumFilter"));
                //PE-306.JS.1.0 06JUN2024-end
                if NewStatusDateSentIn <> 0D then
                    JobPlannLine.SetFilter("NS_Contract Forecast Date", '..%1', NewStatusDateSentIn);
                JobPlannLine.SETFILTER(NS_Adjustment, Job.GetFilter("NS_Adjustment Filter"));
                JobPlannLine.SETFILTER("NS_Shortcut Dimension 1 Code", Job.GetFilter("NS_Global Dimension 1 Filter"));
                JobPlannLine.SETFILTER("NS_Shortcut Dimension 2 Code", Job.GetFilter("NS_Global Dimension 2 Filter"));
                JobPlannLine.SETFILTER("NS_Retention Ledger Code", Job.getfilter("NS_Retention Ledger Filter"));
                if JobPlannLine.FINDSET() then
                    repeat
                        ContAmt := ContAmt + JobPlannLine."Total Price (LCY)";
                    until JobPlannLine.NEXT() = 0;
            until NSJob.Next() = 0;
        exit(ContAmt);
    end;

    procedure NS_UpdateManagerName()
    Resource: Record Resource;
    begin
        //ProjectPro - start
        if Rec.NS_Manager > '' then begin //PRJ-1135.RM.1.0
            Resource.GET(Rec.NS_Manager); //PRJ-1135.RM.1.0
            ManagerName := Resource.Name;
        end else
            ManagerName := '';
        //ProjectPro - end
    end;

    var
        ManagerName: Text[100];
        AsOfDate: Text;
        Text002: Label 'Data';
        Text001: Label 'OPS Manager Report';
        SLJob: Record Job;
        Jobsetup: Record "Jobs Setup";
        JobForeccast: Record "NS_Job Forecast";
        CurrContractPriceMaster: Decimal;
        CurrContractPriceSL: Decimal;
        CurrentContractPrice: Decimal;
        CurrContractBudgetMaster: Decimal;
        CurrContractBudgetSL: Decimal;
        CurrentContractBudget: Decimal;
        CurrToDateBillingsMaster: Decimal;
        CurrTodateBillingsSL: Decimal;
        CurrentToDateBillings: Decimal;
        CurrentToDateCostMaster: Decimal;
        CurrentToDateCostSL: Decimal;
        CurrentTodateCost: Decimal;
        CurrentTotalCostEstimate: Decimal;
        CurrentTotalCostEstimateMaster: Decimal;
        CurrentTotalCostEstimateSL: Decimal;
        CurrentTCEForecastVariance: Decimal;
        CurrentTCEBudgetVariance: Decimal;
        CurrentCostToComplete: Decimal;
        PrevCostToComplete: Decimal;
        PrevCostToCompleteMaster: Decimal;
        PrevCostToCompleteSL: Decimal;
        CurrentGM: Decimal;
        CurrentGMForecastVariance: Decimal;
        CurrentGMBudgetVariance: Decimal;
        CurrentPctDone: Decimal;
        CurrentRecognizedRevenue: Decimal;
        CurrentRecognizedProfitloss: Decimal;
        CurrentOverBillings: Decimal;
        CurrentUnderBillings: Decimal;
        PreviousForecastContractPrice: Decimal;
        PreviousForecastContractPriceMaster: Decimal;
        PreviousForecastContractPriceSL: Decimal;
        TotalForecastedCompletedCosts: Decimal;
        TotalForecastedCompletedCostsMaster: Decimal;
        TotalForecastedCompletedCostsSL: Decimal;
        PreviousForecastGM: Decimal;
        OrignalContractPrice: Decimal;
        OrignalContractPriceMaster: Decimal;
        OrignalContractPriceSL: Decimal;
        OrignalBudgetedCost: Decimal;
        OrignaBudgetedCostMaster: Decimal;
        OrignalBudgetedCostSL: Decimal;
        NewStatusDateSentIn: Date;
        NextBillDate: Date;
        Flag: Boolean;
        RecProjSummDtl: Record "NS_Percentage of Completion";
        PreMonthFirstDayDate: Date;
        PreMonthLastDayDate: Date;
        FirstDayDate: Date;
        LastDayDate: Date;
        FlagTotCostTodate: Boolean;
        JobPLLineRec: Record "Job Planning Line";
        CurrentContractPriceVariance: Decimal;
        CurrentBudgetVariance: Decimal;
        OrignalGM: Decimal;
        CommentsMaster1: Text[250];
        CommentMaster2: Text[250];
        CommentLineRec: Record "Comment Line";
        JobLedgEntry: Record "Job Ledger Entry";
        CurrentBookedGM: Decimal;
        PrintComments: Boolean;
        CommentMaxVar: Text[1024];
        IntStr: Integer;
}

