page 14021395 "NS_PM Statistics"
{
    //CTSI-269.MS.1.0 create new page
    Caption = 'PM Statistics';
    SourceTable = Job;
    Editable = false;
    DeleteAllowed = false;
    PageType = CardPart;
    //UsageCategory = Tasks;
    layout
    {
        area(Content)
        {
            group(PMStatistics)
            {
                Caption = 'PM Statistics';
                fixed(" ")
                {
                    group("")
                    {
                        field("Caption[1]"; Caption[1])
                        {
                            caption = '';
                            ApplicationArea = all;
                        }
                        field("Caption[2]"; Caption[1])
                        {
                            caption = 'Contract Price';
                            ApplicationArea = all;
                            Style = Strong;
                        }
                        field("Caption[3]"; caption[3])
                        {
                            Caption = 'Total Forecasted Completed Cost';
                            ApplicationArea = all;
                            Style = Strong;
                        }
                        field("Caption[4]"; Caption[4])
                        {
                            Caption = 'Total Cost Used';
                            ApplicationArea = all;
                            Style = Strong;
                        }
                        field("Caption[5]"; Caption[5])
                        {
                            caption = 'Budget Remaining';
                            ApplicationArea = all;
                            Style = Strong;
                        }
                        field("Caption[6]"; Caption[6])
                        {
                            caption = 'Contract Gross Margin';
                            ApplicationArea = all;
                            Style = Strong;
                        }
                        field("Caption[7]"; caption[7])
                        {
                            Caption = 'GM Var $';
                            ApplicationArea = all;
                            Style = Strong;
                        }
                        field("Caption[8]"; Caption[8])
                        {
                            Caption = 'GM%';
                            ApplicationArea = all;
                            Style = Strong;
                        }
                        field("Caption[9]"; Caption[9])
                        {
                            Caption = 'GM% Var';
                            ApplicationArea = all;
                            Style = Strong;
                        }
                    }
                    group("  ")
                    {
                        field("Caption[10]"; Caption[10])
                        {
                            caption = 'As of Contracted';
                            Style = Strong;
                            ApplicationArea = all;
                        }
                        field(ContractPrice; (AsofContracted))//1
                        {
                            ApplicationArea = all;
                        }
                        field(AsofTotalCostEsti; (AsofTotalCostEsti))//4
                        {
                            ApplicationArea = all;
                        }
                        field(Blank; Blank)//7
                        {
                            ApplicationArea = all;
                        }
                        field(BudgeRemaining; (AsofTotalCostEsti))//10  
                        {
                            ApplicationArea = all;
                        }
                        field(ContractGrossMargin; (AsofContracted - AsofTotalCostEsti))//13(1-4)  
                        {
                            ApplicationArea = all;
                        }
                        field(GMVar; format(Blank))//16  
                        {
                            ApplicationArea = all;
                        }

                        field(GMPct; (Column19))//19 (1*100/13) 
                        {
                            ApplicationArea = all;
                        }
                        field(GMPctVar; (Blank))//22  
                        {
                            ApplicationArea = all;
                        }

                    }
                    group("   ")
                    {
                        field("Caption[11]"; Caption[11])
                        {
                            caption = 'Previous Forecast';
                            Style = Strong;
                            ApplicationArea = all;
                        }
                        field(PreContractPrice; (PreContractPrice)) //2
                        {
                            ApplicationArea = all;
                        }
                        field(PreTotalCostEsti; (PreTotalCostEsti)) //5
                        {
                            ApplicationArea = all;
                        }
                        field(PreTotalCostused; (PreTotalCostused))//8
                        {
                            ApplicationArea = all;
                        }
                        field(PreBudgeRemaining; (PreTotalCostEsti - PreTotalCostused)) //11(5-8)
                        {
                            ApplicationArea = all;
                        }
                        field(PreContractGrossMargin; (PreContractPrice - PreTotalCostEsti))//14(2-5)  
                        {
                            ApplicationArea = all;
                        }
                        field(PreGMVar; (PreContractPrice - PreTotalCostEsti) - PreGMVar)//17   
                        {
                            ApplicationArea = all;
                        }
                        field(PreGMPct; (Column20))//20 (2*100/14) 
                        {
                            ApplicationArea = all;
                        }
                        field(PreGMPctVar; Column20 - (PreGMPct))//23   
                        {
                            ApplicationArea = all;
                        }

                    }
                    group("    ")
                    {
                        field("Caption[12]"; Caption[12])
                        {
                            caption = 'Current Forecast';
                            Style = Strong;
                            ApplicationArea = all;
                        }
                        field(CurrContractPrice; (CurrContractPrice))//3
                        {
                            ApplicationArea = all;
                        }
                        field(CurrTotalCostEsti; (CurrTotalCostEsti))//6
                        {
                            ApplicationArea = all;
                        }
                        field(CurrTotalCostused; (CurrTotalCostused))//9
                        {
                            ApplicationArea = all;
                        }
                        field(CurrBudgeRemaining; (CurrTotalCostEsti - CurrTotalCostused))//12(6-9)
                        {
                            ApplicationArea = all;
                        }
                        field(CurrContractGrossMargin; (CurrContractPrice - CurrTotalCostEsti))//15(3-6)  
                        {
                            ApplicationArea = all;
                        }
                        field(CurrGMVar; ((CurrContractPrice - CurrTotalCostEsti) - (AsofContracted - AsofTotalCostEsti)))//18(15-13)  
                        {
                            ApplicationArea = all;
                        }
                        field(CurrGMPct; (Column21))//21  (3*100/15)
                        {
                            ApplicationArea = all;
                        }
                        field(CurrGMPctVar; ((Column21) - (Column19)))//24 (21-19) 
                        {
                            ApplicationArea = all;
                        }

                    }
                }
            }

        }
    }
    trigger OnOpenPage()
    var
        PreMonthFirstDayDate: Date;
        PreMonthLastDayDate: Date;
        FirstDayDate: Date;
        LastDayDate: Date;
        Flag: Boolean;
        Flag2: Boolean;
        FlagTotCostTodate: Boolean;
        MasterAsofContracted: Decimal;
        SLAsofContracted: Decimal;
        MasterCurrContractPrice: Decimal;
        SLCurrContractPrice: Decimal;
        MasterPreContractPrice: Decimal;
        SLPreContractPrice: Decimal;
        MasterAsofTotalCostEsti: Decimal;
        SLAsofTotalCostEsti: Decimal;
        MasterCurrTotalCostEsti: Decimal;
        SLCurrTotalCostEsti: Decimal;
        MasterPreTotalCostEsti: Decimal;
        SLPreTotalCostEsti: Decimal;
        MasterCurrTotalCostused: Decimal;
        SLCurrTotalCostused: Decimal;
        MasterPreTotalCostused: Decimal;
        SLPreTotalCostused: Decimal;
        JobForecastTable: Record "NS_Job Forecast";
        JobForecast: Record "NS_Job Forecast";
        CEventSubTable: Codeunit "NS_Event Subscr. Tables";
        RevenueRecSummaryTab: Record NS_RevenueRecSummaryTab;
    begin
        AsofContracted := 0;
        MasterAsofContracted := 0;
        SLAsofContracted := 0;
        CurrContractPrice := 0;
        MasterCurrContractPrice := 0;
        SLCurrContractPrice := 0;
        PreContractPrice := 0;
        MasterPreContractPrice := 0;
        SLPreContractPrice := 0;
        //2
        AsofTotalCostEsti := 0;
        MasterAsofTotalCostEsti := 0;
        SLAsofTotalCostEsti := 0;
        CurrTotalCostEsti := 0;
        MasterCurrTotalCostEsti := 0;
        SLCurrTotalCostEsti := 0;
        PreTotalCostEsti := 0;
        MasterPreTotalCostEsti := 0;
        SLPreTotalCostEsti := 0;
        Flag2 := true;
        PreGMVar := 0;
        PreGMPct := 0;
        //3
        PreTotalCostused := 0;
        CurrTotalCostused := 0;
        MasterCurrTotalCostused := 0;
        SLCurrTotalCostused := 0;
        MasterPreTotalCostused := 0;
        SLPreTotalCostused := 0;

        Column19 := 0;
        column20 := 0;
        Column21 := 0;


        FirstDayDate := CALCDATE('<-CM>', NewStatusDateSentIn);
        LastDayDate := CALCDATE('<CM>', FirstDayDate);//NewStatusDateSentIn);

        premonthFirstDayDate := CALCDATE('<-1M>', FirstDayDate);
        //PremonthLastDayDate := CALCDATE('<-1M>', LastDayDate);
        PremonthLastDayDate := CALCDATE('<CM>', premonthFirstDayDate);

        if Jobsetup.get then;

        Caption[10] := 'As of Contracted';
        Caption[11] := 'Previous Forecast';
        Caption[12] := 'Current Forecast';

        MasterJob.Reset();
        MasterJob.SetRange("No.", JobNoSentIn);
        MasterJob.SetRange("NS_Exclude from Job Forecast", false);
        if MasterJob.FindFirst() then begin
            //Contract Price
            MasterAsofContracted := GetPlanningLine(0D, NewStatusDateSentIn, JobNoSentIn, Flag);
            MasterCurrContractPrice := GetPlanningLine(0D, NewStatusDateSentIn, JobNoSentIn, Flag);
            MasterPreContractPrice := GetPrevSummaryDetail(premonthFirstDayDate, PremonthLastDayDate, JobNoSentIn, Flag, FlagTotCostTodate);
            //total cost to est.
            MasterAsofTotalCostEsti := GetPlanningLine(0D, NewStatusDateSentIn, JobNoSentIn, Flag2);
            MasterCurrTotalCostEsti := GetForecastLine(JobNoSentIn);
            MasterPreTotalCostEsti := GetPrevSummaryDetail(premonthFirstDayDate, PremonthLastDayDate, JobNoSentIn, Flag2, FlagTotCostTodate);
            //Total cost used
            MasterCurrTotalCostused := GetSumOfTotalCostsUsed(JobNoSentIn, 0D, NewStatusDateSentIn);
            FlagTotCostTodate := true;
            MasterPreTotalCostused := GetPrevSummaryDetail(premonthFirstDayDate, PremonthLastDayDate, JobNoSentIn, Flag, FlagTotCostTodate);
            FlagTotCostTodate := false;
        end;
        SLJob.Reset();
        SLJob.SetRange("NS_Sub-Level to Job No.", JobNoSentIn);
        SLJob.SetRange("NS_Exclude from Job Forecast", false);
        if Jobsetup."NS_GBPG for Job Forecast" <> '' then
            SLJob.SetFilter("NS_Gen. Bus. Posting Group New", Jobsetup."NS_GBPG for Job Forecast");//PRJ-831.AS.1.0 12OCT2021 Add New
                                                                                                   // SLJob.SetFilter("NS_Gen. Bus. Posting Group", Jobsetup."NS_GBPG for Job Forecast");//PRJ-831.AS.1.0 12OCT2021 Comment old
        if SLJob.FindSet() then
            repeat
                //Contract Price 
                SLAsofContracted := SLAsofContracted + GetPlanningLine(0D, NewStatusDateSentIn, SLJob."No.", Flag);
                SLCurrContractPrice := SLCurrContractPrice + GetPlanningLine(0D, NewStatusDateSentIn, SLJob."No.", Flag);
                SLPreContractPrice := SLPreContractPrice + GetPrevSummaryDetail(premonthFirstDayDate, PremonthLastDayDate, SLJob."No.", Flag, FlagTotCostTodate);
                //total cost to est.
                SLAsofTotalCostEsti := SLAsofTotalCostEsti + GetPlanningLine(0D, NewStatusDateSentIn, SLJob."No.", Flag2);
                SLPreTotalCostEsti := SLPreTotalCostEsti + GetPrevSummaryDetail(premonthFirstDayDate, PremonthLastDayDate, SLJob."No.", Flag2, FlagTotCostTodate);

                //Current forecasted cost to estimate
                CEventSubTable.POpenForecastpage(SLJob."No.", NewStatusDateSentIn, NextBillDate, JobForecast);
                JobForecastTable.Reset();
                JobForecastTable.SetRange("NS_Job No.", SLJob."No.");
                if JobForecastTable.FindSet() then begin
                    repeat
                        CEventSubTable.POnAfterGetJobForecastPage(SLJob."No.", NewStatusDateSentIn, NextBillDate, JobForecastTable);
                        JobForecastTable.Modify();
                    until JobForecastTable.Next() = 0;
                    JobForecastTable.CalcFields("NS_Total Forecast Completed Cost");
                end;
                SLCurrTotalCostEsti := SLCurrTotalCostEsti + JobForecastTable."NS_Total Forecast Completed Cost";
                //Current forcasted cost to estimate

                SLCurrTotalCostused := SLCurrTotalCostused + GetSumOfTotalCostsUsed(SLJob."No.", 0D, NewStatusDateSentIn);
                FlagTotCostTodate := true;
                SLPreTotalCostused := SLPreTotalCostused + GetPrevSummaryDetail(premonthFirstDayDate, PremonthLastDayDate, SLJob."No.", Flag, FlagTotCostTodate);
                FlagTotCostTodate := false;
            until SLJob.next = 0;
        //pre GM Var $ and Pct
        RevenueRecSummaryTab.Reset();
        RevenueRecSummaryTab.SetCurrentKey("NS_Entry No.");
        RevenueRecSummaryTab.SetRange("NS_Job No.", JobNoSentIn);
        RevenueRecSummaryTab.SetFilter(NS_Voided, '%1', false);
        RevenueRecSummaryTab.setrange("NS_Posting Date", PreMonthFirstDayDate, PreMonthLastDayDate);
        if RevenueRecSummaryTab.FindLast() then;
        PreGMVar := RevenueRecSummaryTab."NS_Stat. Cont. GM (As of)";
        PreGMPct := RevenueRecSummaryTab."NS_Stat. GM% (As of)";
        //pre GM Var $ and Pct

        AsofContracted := MasterAsofContracted + SLAsofContracted;
        CurrContractPrice := MasterCurrContractPrice + SLCurrContractPrice;
        PreContractPrice := MasterPreContractPrice + SLPreContractPrice;
        CurrTotalCostEsti := MasterCurrTotalCostEsti + SLCurrTotalCostEsti;
        CurrTotalCostused := MasterCurrTotalCostused + SLCurrTotalCostused;
        PreTotalCostused := MasterPreTotalCostused + SLPreTotalCostused;
        PreTotalCostEsti := MasterPreTotalCostEsti + SLPreTotalCostEsti;
        AsofTotalCostEsti := MasterAsofTotalCostEsti + SLAsofTotalCostEsti;


        if (AsofContracted) = 0 then
            Column19 := 0
        else
            Column19 := round((AsofContracted - AsofTotalCostEsti) * 100 / AsofContracted, Jobsetup."NS_Forecast Amount Rounding");

        if (PreContractPrice) = 0 then
            Column20 := 0
        else
            column20 := round((PreContractPrice - PreTotalCostEsti) * 100 / PreContractPrice, Jobsetup."NS_Forecast Amount Rounding");
        if (CurrContractPrice) = 0 then
            Column21 := 0
        else
            Column21 := round((CurrContractPrice - CurrTotalCostEsti) * 100 / CurrContractPrice, Jobsetup."NS_Forecast Amount Rounding");
        if Jobsetup."NS_Required GM% Var for JFW Comments" <> 0 then begin
            if (Column21) - (Column19) <= Jobsetup."NS_Required GM% Var for JFW Comments" then
                Message('Please enter PM comments, as the GM% Var equals or less than %1%', Jobsetup."NS_Required GM% Var for JFW Comments");
        end;
    end;

    var

        Caption: array[30] of Text[30];
        JobNoSentIn: Code[20];
        NewStatusDateSentIn: Date;
        NextBillDate: Date;
        MasterJob: Record Job;
        SLJob: Record Job;
        Jobsetup: Record "Jobs Setup";
        JobForeccast: Record "NS_Job Forecast";
        Blank: Text;
        AsofContracted: Decimal;
        PreContractPrice: Decimal;
        CurrContractPrice: Decimal;
        AsofTotalCostEsti: Decimal;
        PreTotalCostEsti: Decimal;
        CurrTotalCostEsti: Decimal;
        PreTotalCostused: Decimal;
        CurrTotalCostused: Decimal;
        Column19: Decimal;
        Column20: Decimal;
        Column21: Decimal;
        PreGMVar: Decimal;
        PreGMPct: Decimal;



    procedure Set(JobNoIn: Code[20]; NewStatusDateIn: Date; ParaNextBillDate: date);
    begin
        JobNoSentIn := JobNoIn;
        NewStatusDateSentIn := NewStatusDateIn;
        NextBillDate := ParaNextBillDate;
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

    procedure GetForecastLine(var ParaJob: Code[20]) Answer: Decimal
    var
        ForecasteLine: Record "NS_Job Forecast";
    begin
        ForecasteLine.Reset();
        ForecasteLine.SetRange("NS_Job No.", ParaJob);
        ForecasteLine.SetFilter(NS_Posted, '%1', false);
        if ForecasteLine.FindFirst() then begin
            ForecasteLine.CalcFields("NS_Total Forecast Completed Cost");
            Answer := ForecasteLine."NS_Total Forecast Completed Cost";
            exit(Answer);
        end;
    end;

    procedure GetSumOfTotalCostsUsed(JobNo: Code[20]; StartDate: date; EndDate: date) SumOfTotalCostsUsed: Decimal;
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
                SumOfTotalCostsUsed := SumOfTotalCostsUsed + JobLedEntry."Total Cost (LCY)";
            until JobLedEntry.Next() = 0;
        exit(SumOfTotalCostsUsed);

    end;


}
