/// <summary>
/// Page NS_Job Forecast SummIncSubLevl (ID 14021174).
/// </summary>
page 14021174 "NS_Job Forecast SummIncSubLevl"
{

    //PRJ-1039.JS.1.0 29JAN2022 new object

    Caption = 'Job Forecast Summ. Incude SubLevels';
    Editable = false;
    LinksAllowed = false;
    PageType = CardPart;
    ShowFilter = false;
    SourceTable = Job;


    layout
    {
        area(content)
        {
            group(Statistics)
            {
                fixed(" ")
                {
                    group("")
                    {
                        field("Column1[1]"; Column1[1])
                        {
                            ApplicationArea = All;
                            Caption = 'Budget Costs';
                            ToolTip = 'Specifies the Budget Costs.';
                        }
                        field("Column1[2]"; Column1[2])
                        {
                            ApplicationArea = All;
                            Caption = 'Forecasted Cost To Complete';
                            ToolTip = 'Specifies the Forecasted Cost To Complete';
                        }
                        field("Estimated Cost To Complete"; '')
                        {
                            ApplicationArea = All;
                            Caption = 'Estimated Cost To Complete';
                            ToolTip = 'Estimated Cost To Complete';
                        }
                        field("Column1[3]"; Column1[3])
                        {
                            ApplicationArea = All;
                            Caption = 'Actual Costs';
                            ToolTip = 'Actual Cost';
                        }
                        field("Column1[4]"; Column1[4])
                        {
                            ApplicationArea = All;
                            Caption = 'Contract';
                            ToolTip = 'Contract';
                        }
                        field("Column1[5]"; Column1[5])
                        {
                            ApplicationArea = All;
                            Caption = 'Billings To Date';
                            ToolTip = 'Billings To Date';
                        }
                        field("Column1[6]"; Column1[6])
                        {
                            ApplicationArea = All;
                            Caption = 'Job % Complete';
                            ToolTip = 'Job % Complete';
                        }
                        field("Column1[7]"; Column1[7])
                        {
                            ApplicationArea = All;
                            Caption = 'Gross Profit To Date';
                            ToolTip = 'Gross Profit To Date';
                        }
                    }
                    group("  ")
                    {
                        field("Column3[1]"; Column3[1])
                        {
                            ApplicationArea = All;
                            Caption = ' ';
                            ToolTip = ' ';
                        }

                        field("Column3[2]"; Column3[2])
                        {
                            ApplicationArea = All;
                            Caption = ' ';
                            ToolTip = ' ';
                        }
                        field(TotalCostToComplete; TotalCostToComplete)
                        {
                            ApplicationArea = All;
                            Caption = ' ';
                            ToolTip = ' ';
                        }
                        field("Column3[3]"; Column3[3])
                        {
                            ApplicationArea = All;
                            Caption = ' ';
                            ToolTip = ' ';
                        }
                        field("Column3[4]"; Column3[4])
                        {
                            ApplicationArea = All;

                            Caption = ' ';
                            ToolTip = ' ';
                        }
                        field("Column3[5]"; Column3[5])
                        {
                            ApplicationArea = All;
                            Caption = ' ';
                            ToolTip = ' ';
                        }
                        field("Column3[6]"; Column6[1])
                        {
                            ApplicationArea = All;
                            Caption = ' ';
                            ToolTip = ' ';
                        }
                        field("Column3[7]"; Column3[7])
                        {
                            ApplicationArea = All;
                            Caption = ' ';
                            ToolTip = ' ';
                        }
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        NS_FillInTable();
    end;

    var
        Job: Record Job;
        NS_Job2: Record Job;
        NS_Job3: Record Job;
        JobForecast: Record "NS_Job Forecast";
        PreviousJobForecast: Record "NS_Job Forecast";
        JobPlanningLine: Record "Job Planning Line";
        JobPlanningLineBudget: Record "Job Planning Line";
        JobPlanningLinePrice: Record "Job Planning Line";
        GLSetup: Record "General Ledger Setup";
        NS_JobLedgerEntry: Record "Job Ledger Entry";
        JobNoSentIn: Code[20];
        NewStatusDateSentIn: Date;
        PlanningLineTotal: Decimal;
        TotalForecastedCompletedCost: Decimal;
        TotalBudget: Decimal;
        TotalCostsUsed: Decimal;
        TotalContractValue: Decimal;
        TotalBillings: Decimal;
        TotalPortions: Decimal;
        ColumnHeading1: array[7] of Text[30];
        ColumnHeading2: array[7] of Text[30];
        Column1: array[7] of Text[30];
        Column2: array[7] of Text;
        Column3: array[7] of Decimal;
        Column4: array[7] of Decimal;
        Column5: array[7] of Decimal;
        Column6: array[7] of Decimal; //PRJ-353.GK.1.0 08Sep2021
        ColumnHeading04_1_Lbl: Label 'Proposed';
        ColumnHeading04_2_Lbl: Label 'Total';
        ColumnHeading05_1_Lbl: Label 'Proposed';
        ColumnHeading05_2_Lbl: Label 'Net Billing';
        BudgetedCosts: Decimal;
        JobPercentComplete: Decimal;
        JobAmountComplete: Decimal;
        ProposedTotalPercent: Decimal;
        ProposedTotalAmount: Decimal;
        ProposedNetBilling: Decimal;
        GrossProfitToDatePercent: Decimal;
        GrossProfitToDateAmount: Decimal;
        TotalCostToComplete: Decimal;
        NS_JobNoFilter: Code[30];
        TotalContractValue2: Decimal;
        TotalBillings2: Decimal;
        jobSetup: Record "Jobs Setup"; //PRJ-1454.NK.1.0 05Sep2022

    procedure NS_FillInTable();
    var
        IsHandle: Boolean;//FGH-163.SM.29022024 //PE-269.JS.1.0 05MAR2024
    begin
        //FGH-163.SM.29022024 //PE-269.JS.1.0 START
        OnBeforeFillInTable(JobNoSentIn, NewStatusDateSentIn, IsHandle);//FGH-163.SMADDED Added Parameter  //PE-269.JS.1.0
        if IsHandle then
            exit;
        //FGH-163.SM.29022024 //PE-269.JS.1.0 END
        if JobNoSentIn = '' then
            exit;
        TotalCostToComplete := 0;
        TotalCostsUsed := 0;
        TotalContractValue := 0;
        TotalContractValue2 := 0;
        TotalBillings := 0;
        NS_JobNoFilter := '';
        NS_JobNoFilter := '@*' + Format(JobNoSentIn) + '*';

        GLSetup.GET();
        JobForecast.RESET();
        JobForecast.SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date");
        JobForecast.SETRANGE("NS_Job No.", JobNoSentIn);
        JobForecast.SETRANGE(NS_Posted, false);
        if JobForecast.FINDSET() then
            repeat
                //Calculate the data for master job-start
                BudgetedCosts := 0;
                Job.RESET();
                Job.SETRANGE("No.", JobNoSentIn);
                Job.SETRANGE("NS_Job Task No. Filter", JobForecast."NS_Job Task No.");
                if NewStatusDateSentIn <> 0D then
                    Job.SETFILTER("NS_Date Filter", '..%1', NewStatusDateSentIn)
                else
                    Job.SETRANGE("NS_Date Filter");
                if Job.FINDFIRST() then;

                Job.CALCFIELDS("NS_Budgeted Price (LCY)", "NS_Invoiced Price (LCY)", "NS_Usage (Cost) (LCY)");
                TotalCostsUsed := TotalCostsUsed + Job."NS_Usage (Cost) (LCY)";
                if Job."NS_Budgeted Price (LCY)" <> 0 then begin
                    //TotalContractValue := TotalContractValue + Job."NS_Budgeted Price (LCY)";  //PRJ-1454.NK.1.0 09Jan2023 Block
                end;
                TotalContractValue := GetPlanningLineIncludeSubLevels(0D, NewStatusDateSentIn, JobNoSentIn, false); //PRJ-1454.NK.1.0 09Jan2023

                TotalBillings := TotalBillings + Job."NS_Invoiced Price (LCY)";

                JobForecast.NS_GetLastPostedStatus(JobForecast."NS_Job No.", JobForecast."NS_Job Task No.", NewStatusDateSentIn, PreviousJobForecast);
                if (JobForecast."NS_Job No." > '') and (JobForecast."NS_Status Date" <= NewStatusDateSentIn) then begin

                    JobForecast.NS_GetJobSumofTotalBudget(JobNoSentIn, JobForecast."NS_Job Task No.", JobPlanningLineBudget, TotalBudget, NewStatusDateSentIn);//PRJ-596
                    BudgetedCosts := TotalBudget;


                    JobForecast.CalcFields(JobForecast."NS_Total Est. cost to Complete", "NS_Total Forecast Completed Cost");
                    TotalForecastedCompletedCost := JobForecast."NS_Total Forecast Completed Cost";
                    if JobForecast."NS_Entry Type" = JobForecast."NS_Entry Type"::Price then begin
                        PlanningLineTotal := 0;
                        JobPlanningLine.RESET();
                        JobPlanningLine.SETRANGE("Job No.", JobForecast."NS_Job No.");
                        JobPlanningLine.SETRANGE("Job Task No.", JobForecast."NS_Job Task No.");
                        if JobPlanningLine.FINDSET() then
                            repeat
                                PlanningLineTotal := PlanningLineTotal + JobPlanningLine."Total Price";
                            until JobPlanningLine.NEXT() = 0;
                        TotalPortions := TotalPortions + ROUND(PlanningLineTotal * (JobForecast."NS_Bill Percent" / 100), GLSetup."Amount Rounding Precision");
                    end;

                    TotalCostToComplete := JobForecast."NS_Total Est. cost to Complete";
                    //Calculate the data for master job-start

                    //Calculation for sub level jobs-start                    
                    NS_Job2.Reset();
                    NS_Job2.SetFilter("NS_Sub-Level to Job No.", '%1', NS_JobNoFilter);
                    NS_Job2.Setrange("NS_Job Task No. Filter", JobForecast."NS_Job Task No.");
                    if NewStatusDateSentIn <> 0D then
                        NS_Job2.SETFILTER("NS_Date Filter", '..%1', NewStatusDateSentIn)
                    else
                        NS_Job2.SETRANGE("NS_Date Filter");
                    if NS_Job2.FindSet() then
                        repeat
                            TotalBudget := 0;
                            TotalContractValue2 := 0;
                            TotalBillings2 := 0;
                            NS_Job2.CALCFIELDS("NS_Budgeted Price (LCY)", "NS_Invoiced Price (LCY)", "NS_Usage (Cost) (LCY)");
                            TotalCostsUsed := TotalCostsUsed + NS_Job2."NS_Usage (Cost) (LCY)";
                            JobPlanningLinePrice.Reset();
                            JobPlanningLinePrice.SetRange("Job No.", NS_Job2."No.");
                            JobPlanningLinePrice.SetRange("Job Task No.", JobForecast."NS_Job Task No.");
                            if NewStatusDateSentIn <> 0D then
                                JobPlanningLinePrice.SetFilter("Planning Date", '..%1', NewStatusDateSentIn);
                            JobPlanningLinePrice.SetFilter("Line Type", '<>%1', JobPlanningLinePrice."Line Type"::Budget);
                            if JobPlanningLinePrice.FindSet() then begin
                                JobPlanningLinePrice.CalcSums("Line Amount (LCY)");
                                if JobPlanningLinePrice."Line Amount (LCY)" <> 0 then
                                    TotalContractValue2 := TotalContractValue2 + JobPlanningLinePrice."Line Amount (LCY)";                                // repeat
                                //     if JobPlanningLinePrice."Line Amount (LCY)" <> 0 then
                                //         TotalContractValue2 := TotalContractValue2 + JobPlanningLinePrice."Line Amount (LCY)";
                                // until JobPlanningLinePrice.Next() = 0;
                            end;
                            //Get total billings
                            NS_JobLedgerEntry.Reset();
                            NS_JobLedgerEntry.SetRange("Job No.", NS_Job2."No.");
                            NS_JobLedgerEntry.SetRange("Job Task No.", JobForecast."NS_Job Task No.");
                            NS_JobLedgerEntry.SetRange("Entry Type", NS_JobLedgerEntry."Entry Type"::Sale);
                            if NewStatusDateSentIn <> 0D then
                                NS_JobLedgerEntry.SetFilter("Posting Date", '..%1', NewStatusDateSentIn);
                            if NS_JobLedgerEntry.FindSet() then begin
                                NS_JobLedgerEntry.CalcSums("Total Price (LCY)");
                                if NS_JobLedgerEntry."Total Price (LCY)" <> 0 then
                                    //PRJCTPR-344.JS.1.0 - Start
                                    //TotalBillings2 := TotalBillings2 + NS_JobLedgerEntry."Total Price (LCY)";   
                                    if NS_JobLedgerEntry."Total Price (LCY)" < 0 then
                                        TotalBillings2 := TotalBillings2 + abs(NS_JobLedgerEntry."Total Price (LCY)")
                                    else
                                        TotalBillings2 := TotalBillings2 - NS_JobLedgerEntry."Total Price (LCY)";
                                //PRJCTPR-344.JS.1.0 - end    
                            end;

                            // if TotalContractValue2 <> 0 then //PRJ-1454.NK.1.0 09Jan2023 Block
                            //     TotalContractValue := TotalContractValue + TotalContractValue2; //PRJ-1454.NK.1.0 09Jan2023 Block
                            if TotalBillings2 <> 0 then
                                TotalBillings := TotalBillings + TotalBillings2;
                            if (JobForecast."NS_Job No." > '') and (JobForecast."NS_Status Date" <= NewStatusDateSentIn) then
                                JobForecast.NS_GetJobSumofTotalBudgetIncludeSubLevels(JobNoSentIn, JobForecast."NS_Job Task No.", JobPlanningLineBudget, TotalBudget, NewStatusDateSentIn);
                        until NS_Job2.Next() = 0;
                    BudgetedCosts := BudgetedCosts + TotalBudget;
                end;
            until JobForecast.NEXT() = 0;


        //Final Calculations
        if TotalForecastedCompletedCost > 0 then
            JobPercentComplete := ROUND((TotalCostsUsed / TotalForecastedCompletedCost) * 100, GLSetup."Amount Rounding Precision")
        else
            JobPercentComplete := 0;
        JobAmountComplete := ROUND(TotalContractValue * (JobPercentComplete / 100), GLSetup."Amount Rounding Precision");
        if TotalContractValue > 0 then
            ProposedTotalPercent := ROUND((TotalPortions / TotalContractValue) * 100, GLSetup."Amount Rounding Precision")
        else
            ProposedTotalPercent := 0;
        ProposedTotalAmount := ROUND((TotalContractValue * (ProposedTotalPercent / 100)), GLSetup."Amount Rounding Precision");
        if TotalBillings >= 0 then
            ProposedNetBilling := ProposedTotalAmount - TotalBillings
        else
            ProposedNetBilling := 0;
        GrossProfitToDateAmount := JobAmountComplete - TotalCostsUsed;
        if JobAmountComplete <> 0 then
            GrossProfitToDatePercent := ROUND((GrossProfitToDateAmount / JobAmountComplete) * 100, GLSetup."Amount Rounding Precision")
        else
            GrossProfitToDatePercent := 0;



        //Column Headings
        ColumnHeading1[4] := ColumnHeading04_1_Lbl;
        ColumnHeading2[4] := ColumnHeading04_2_Lbl;
        ColumnHeading1[5] := ColumnHeading05_1_Lbl;
        ColumnHeading2[5] := ColumnHeading05_2_Lbl;

        //Budget Costs
        Column3[1] := BudgetedCosts;

        //Forecast To Complete
        Column3[2] := TotalForecastedCompletedCost;

        //Actual Costs
        Column3[3] := TotalCostsUsed;

        //Contract
        Column3[4] := TotalContractValue;

        //Billings To Date
        Column3[5] := TotalBillings;

        //Job % Complete
        //Column2[6] := FORMAT(ROUND(JobPercentComplete, 0.01)) + '%';//PRJ-433 comment
        //Column2[6] := FORMAT(JobPercentComplete, 24, '<Precision,2:2><Sign><Integer Thousand><Decimals>') + '%'; //PRJ-433  //PRJ-353.GK.1.0 08Sep2021|comment code
        Column6[1] := JobPercentComplete; //PRJ-353.GK.1.0 08Sep2021
        Column3[6] := JobAmountComplete;
        //Column3[6] := ProposedTotalPercent;//PRJ-433 comment
        Column4[6] := ProposedTotalAmount;
        Column5[6] := ProposedNetBilling;

        //Gross Profit To Date
        Column2[7] := FORMAT(ROUND(GrossProfitToDatePercent, 0.01)) + '%';
        Column3[7] := GrossProfitToDateAmount;

    end;

    /// <summary>
    /// NS_Set.
    /// </summary>
    /// <param name="JobNoIn">Code[20].</param>
    /// <param name="NewStatusDateIn">Date.</param>
    procedure NS_Set(JobNoIn: Code[20];
        NewStatusDateIn: Date);
    begin
        JobNoSentIn := JobNoIn;
        NewStatusDateSentIn := NewStatusDateIn;
    end;
    //PRJ-1454.NK.1.0 09Jan2023 Start
    procedure GetPlanningLineIncludeSubLevels(StartDate: Date; var Enddate: Date; var ParaJob: Code[20]; flag: Boolean) Answer: Decimal;
    var
        PlanningLine: Record "Job Planning Line";
        PlanningLine2: Record "Job Planning Line";
        NSJob: Record Job;
        JobNoFilter: Code[20];
        IsHandled: Boolean;//FGH-163.SM.290229 //PE-269.JS.1.0 05MAR2024
    begin
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
        //FGH-163.SM.29022024 //PE-269.JS.1.0 START
        OnBeforeJFSGetPlanningLineIncludeSubLevels(StartDate, Enddate, ParaJob, flag, IsHandled, Answer);
        //FGH-163.SM.29022024 //PE-269.JS.1.0 END
        exit(Answer);
    end;
    //PRJ-1454.NK.1.0 09Jan2023 End

    //FGH-163.SM.29022024 //PE-269.JS.1.0 START

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFillInTable(var JobNoSentIn: code[20]; var NewStatusDateSentIn: Date; var IsHandled: Boolean)//FGH-163.SMADDED Added Parameter  //PE-269.JS.1.0
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeJFSGetPlanningLineIncludeSubLevels(StartDate: Date; var Enddate: Date; var ParaJob: Code[20]; flag: Boolean; var IsHandle: Boolean; var FGH_Answer: Decimal)
    begin
    end;

    //FGH-163.SM.29022024 //PE-269.JS.1.0 END
}

