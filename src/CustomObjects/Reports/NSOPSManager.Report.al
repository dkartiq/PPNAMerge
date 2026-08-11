report 14021194 NS_OPSManagerRep
{
    //CTSI-281.AM.1.0
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'OPS Manager Report';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Job; Job)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "NS_Gen. Bus. Posting Group New", "Bill-to Customer No.", Status, "NS_Activity Filter", "NS_Process Filter", "NS_Operation Filter", "Global Dimension 2 Code";//PRJ-831.AS.1.0 12OCT2021 Replaced Job Table field Gen Bus Posting Grp with Gen Bus Posting Grp New

            trigger OnAfterGetRecord()
            var
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
                CurrContractPriceMaster := GetPlanningLine(0D, NewStatusDateSentIn, Job."No.", Flag);

                //Curr Contract Budget Master
                Flag := true;
                CurrContractBudgetMaster := GetPlanningLine(0D, NewStatusDateSentIn, Job."No.", Flag);

                //Current To date Billings Master
                CurrToDateBillingsMaster := CurrentToDateBillingsCalc(Job);

                //Current To Date Cost Master
                CurrentToDateCostMaster := FindUsageCost(job);

                //Current total cost estimate
                RecProjSummDtl.Reset();
                RecProjSummDtl.SetCurrentKey("NS_Job No.", "NS_Posting Date");
                RecProjSummDtl.SetRange("NS_Job No.", Job."No.");
                RecProjSummDtl.SetRange("NS_Posting Date", NewStatusDateSentIn);
                if RecProjSummDtl.FindLast() then
                    CurrentTotalCostEstimateMaster := RecProjSummDtl.NS_TotalForecastCompletedCost;

                //Total Contract Revenue Master
                Flag := false;
                FlagTotCostTodate := false;
                PreviousForecastContractPriceMaster := GetPrevSummaryDetailPrev(premonthFirstDayDate, PremonthLastDayDate, Job."No.", Flag, FlagTotCostTodate);

                //Total Forecasted Completed Costs Master
                Flag := true;
                FlagTotCostTodate := false;
                TotalForecastedCompletedCostsMaster := GetPrevSummaryDetailPrev(premonthFirstDayDate, PremonthLastDayDate, Job."No.", Flag, FlagTotCostTodate);
                FlagTotCostTodate := false;
                PrevCostToCompleteMaster := PreviousCosttoCompCalculations(premonthFirstDayDate, PremonthLastDayDate, Job."No.", Flag, FlagTotCostTodate);

                //Orignal Contract Price Master
                if Job."NS_Contract Date" <> 0D then begin
                    JobPLLineRec.Reset();
                    JobPLLineRec.SetRange("Job No.", Job."No.");
                    JobPLLineRec.SetFilter("Line Type", '<>%1', JobPLLineRec."Line Type"::Budget);
                    JobPLLineRec.SetFilter("Planning Date", '%1', Job."NS_Contract Date");
                    if JobPLLineRec.FindSet() then
                        repeat
                            OrignalContractPriceMaster += JobPLLineRec."Line Amount (LCY)";
                        until JobPLLineRec.Next() = 0;
                end;
                //Orignal Budgeted Cost Master 
                if Job."NS_Contract Date" <> 0D then begin
                    JobPLLineRec.Reset();
                    JobPLLineRec.SetRange("Job No.", Job."No.");
                    JobPLLineRec.SetFilter("Line Type", '<>%1', JobPLLineRec."Line Type"::Billable);
                    JobPLLineRec.SetFilter("Planning Date", '=%1', Job."NS_Contract Date");
                    JobPLLineRec.SetFilter(NS_Adjustment, '=%1', '');
                    if JobPLLineRec.FindSet() then
                        repeat
                            OrignaBudgetedCostMaster += JobPLLineRec."Total Cost (LCY)";
                        until JobPLLineRec.Next() = 0;
                end;

                //Comments

                CommentLineRec.Reset();
                CommentLineRec.SetRange("Table Name", CommentLineRec."Table Name"::Job);
                CommentLineRec.SetRange("No.", Job."No.");
                CommentLineRec.SetRange(Date, NewStatusDateSentIn);
                if CommentLineRec.FindSet() then
                    repeat
                        CommentMaxVar += CommentLineRec.Comment + ',';
                    until CommentLineRec.Next() = 0;
                CommentsMaster1 := CopyStr(CommentMaxVar, 1, 250);
                CommentMaster2 := CopyStr(CommentMaxVar, 251, 250);

                //SUB LEVEL CALCULATIONS

                SLJob.Reset();
                SLJob.SetRange("NS_Sub-Level to Job No.", Job."No.");
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

            trigger OnPostDataItem()
            var
            begin

            end;

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                Job.SetFilter("NS_Sub-Level to Job No.", '=%1', '');
                job.SetRange("NS_Exclude from Job Forecast", false);


                IF NewStatusDateSentIn = 0D then
                    Error('You must select As of Date');

                FirstDayDate := CALCDATE('<-CM>', NewStatusDateSentIn);
                LastDayDate := CALCDATE('<CM>', FirstDayDate);

                premonthFirstDayDate := CALCDATE('<-1M>', FirstDayDate);
                PremonthLastDayDate := CALCDATE('<CM>', premonthFirstDayDate);


            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(NewStatusDateSentIn; NewStatusDateSentIn)
                    {
                        ApplicationArea = All;
                        Caption = 'As of Date';

                    }
                    field(PrintComments; PrintComments)
                    {
                        ApplicationArea = all;
                        Caption = 'Print Comments';
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

        ExcelBuf.DELETEALL;
        CompanyInformation.GET();
        Jobsetup.Get();
        MakeExcelHeader;
    end;

    trigger OnPostReport()
    begin
        //OnPostReport


        ExcelBuf.CreateNewBook(Text001);
        ExcelBuf.WriteSheet(Text002, CompanyName, UserID);
        ExcelBuf.CloseBook;
        ExcelBuf.OpenExcel;
    end;

    procedure MakeExcelHeader()
    var
    begin
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn('OPS Manager Report', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn(CompanyInformation.Name, FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('As of Date :', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(NewStatusDateSentIn, FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();
        ExcelBuf.NewRow();
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn('Job No.', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Description', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Current Contract Price', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Current Contract Cost', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Current Booked GM%', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Current To Date Billings', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Current To Date Cost', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Current Forecasted Total Cost Estimate', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Current TCE Forecast Variance from Prior Month', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Current TCE To Current Contract Cost Variance', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::text);
        ExcelBuf.AddColumn('Current Forecasted Cost To Complete', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::text);
        ExcelBuf.AddColumn('Previous Forecasted Cost To Complete', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::text);
        ExcelBuf.AddColumn('Current Forecasted GM%', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Current GM% Forecast Variance From Prior Month', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Current GM% To Original GM% Variance', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Current Percent Complete ', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Current Recognized Revenue', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Current Recognized Profit (Loss) ', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Current Over Billings', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Current Under Billings', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Previous Forecasted Contract Price', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Previous Forecasted Total Cost Estimate', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Previous Forecasted GM%', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Original Contract Price', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Current Contract Price Variance', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Original Budgeted Cost', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Current Budget Cost Variance', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Original GM%', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        if PrintComments then begin
            ExcelBuf.AddColumn('Forecast Worksheet Notes', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('Forecast Worksheet Notes', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        end;
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('C', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('D', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('E', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('F', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('G', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('H', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('I', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::text);
        ExcelBuf.AddColumn('J', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::text);
        ExcelBuf.AddColumn('K', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::text);
        ExcelBuf.AddColumn('L', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('M', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('N', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('O', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('P', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Q', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('R', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('S', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('T', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('U', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('V', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('W', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('X', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Y', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Z', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('AA', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('AB', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        if PrintComments then
            ExcelBuf.AddColumn('AC', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('((C-D)/C)*100', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('H-V', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::text);
        ExcelBuf.AddColumn('H-D', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::text);
        ExcelBuf.AddColumn('H-G', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('((C-H)/C)*100', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('M-W', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('M-AB', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('(G/H)*100', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('(P*C)/100', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Q-G', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('F-Q', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Q-F', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('((U-V)/U)*100', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('C-X', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('D-Z', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('((X-Z)/X)*100', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, false, '', ExcelBuf."Cell Type"::Text);

    end;

    procedure MakeExcelBody()
    var
    begin
        ExcelBuf.NewRow;
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn(Job."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Job.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CurrentContractPrice, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CurrentContractBudget, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CurrentBookedGM, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CurrentToDateBillings, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CurrentTodateCost, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CurrentTotalCostEstimate, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CurrentTCEForecastVariance, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CurrentTCEBudgetVariance, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CurrentCostToComplete, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(PrevCostToComplete, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CurrentGM, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CurrentGMForecastVariance, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CurrentGMBudgetVariance, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CurrentPctDone, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CurrentRecognizedRevenue, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CurrentRecognizedProfitloss, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CurrentOverBillings, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CurrentUnderBillings, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(PreviousForecastContractPrice, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(TotalForecastedCompletedCosts, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);

        ExcelBuf.AddColumn(PreviousForecastGM, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(OrignalContractPrice, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CurrentContractPriceVariance, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(OrignalBudgetedCost, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(CurrentBudgetVariance, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(OrignalGM, FALSE, '', FALSE, FALSE, FALSE, '#,##0.00', ExcelBuf."Cell Type"::Number);
        if PrintComments then begin
            ExcelBuf.AddColumn(CommentsMaster1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(CommentMaster2, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        end;
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
        with Job do begin

            JobLedgEntry.RESET;
            JobLedgEntry.SETCURRENTKEY("Job No.", "Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                       "NS_Job Cost Category", "NS_Job Revenue Category", Type, "No.", "Resource Group No.", "Posting Date");
            JobLedgEntry.SETRANGE("Job No.", "No.");
            JobLedgEntry.SETRANGE("Entry Type", JobLedgEntry."Entry Type"::Usage);
            JobLedgEntry.SETFILTER("NS_Activity Code", GETFILTER("NS_Activity Filter"));
            JobLedgEntry.SETFILTER("NS_Process Code", GETFILTER("NS_Process Filter"));
            JobLedgEntry.SETFILTER("NS_Operation Code", GETFILTER("NS_Operation Filter"));
            JobLedgEntry.SETFILTER("NS_Job Cost Category", GETFILTER("NS_Cost Category Filter"));
            JobLedgEntry.SetFilter("Posting Date", '%1..%2', 0D, NewStatusDateSentIn);
            if JobLedgEntry.FINDSET then
                repeat
                    Usage := Usage + JobLedgEntry."Total Cost (LCY)";

                until JobLedgEntry.NEXT = 0;
        end;
    end;


    procedure CurrentToDateBillingsCalc(Job: Record Job) Price: Decimal;
    begin
        Price := 0;
        with Job do begin

            JobLedgEntry.RESET;
            JobLedgEntry.SETCURRENTKEY("Job No.", "Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                       "NS_Job Cost Category", "NS_Job Revenue Category", Type, "No.", "Resource Group No.", "Posting Date");
            JobLedgEntry.SETRANGE("Job No.", "No.");
            JobLedgEntry.SETRANGE("Entry Type", JobLedgEntry."Entry Type"::Sale);
            JobLedgEntry.SETFILTER("NS_Activity Code", GETFILTER("NS_Activity Filter"));
            JobLedgEntry.SETFILTER("NS_Process Code", GETFILTER("NS_Process Filter"));
            JobLedgEntry.SETFILTER("NS_Operation Code", GETFILTER("NS_Operation Filter"));
            JobLedgEntry.SETFILTER("NS_Job Revenue Category", GETFILTER("NS_Revenue Category Filter"));
            JobLedgEntry.SetFilter("Posting Date", '%1..%2', 0D, NewStatusDateSentIn);

            if JobLedgEntry.FINDSET then
                repeat
                    Price := Price - JobLedgEntry."Total Price (LCY)";
                until JobLedgEntry.NEXT = 0;

        end;
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
                //     else
                //         Answer := ProjSummDetail."Total Contract Revenue";
                // end else
                //     Answer := ProjSummDetail."Total Cost to Date";
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

        //Message('%1..Post', Job."No.");
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

        // if CurrentGMForecastVariance < 0 then
        //     CurrentGMForecastVariance := 0
        // else
        //     if CurrentGMForecastVariance > 100 then
        //         CurrentGMForecastVariance := 100;

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

        // if CurrentGMBudgetVariance < 0 then
        //     CurrentGMBudgetVariance := 0
        // else
        //     if CurrentGMBudgetVariance > 100 then
        //         CurrentGMBudgetVariance := 100;
        MakeExcelBody();

    end;


    var
        ExcelBuf: Record "Excel Buffer";
        CompanyInformation: Record "Company Information";
        AsOfDate: Text;
        Text002: Label 'Data';
        Text001: Label 'OPS Manager Report';
        // MasterJob: Record Job;
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


        // JobNoSentIn: Code[20];
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
