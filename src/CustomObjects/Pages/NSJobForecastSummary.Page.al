page 14021197 "NS_Job Forecast Summary"
{
    // version PPNA9.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    //CTSI-129 remove extra control
    //PRJ-433.MS.1.0 added new changes for different fields
    // +------------------------------------------------------------
    //PRJ-353.GK.1.0 08Sep2021 | Add new changes with new array column.
    //PRJ-1454.NK.1.0 17Oct2022 | Change Code
    //PE-170.HS.1.0 6Oct2023 | Added Tooltips
    //PE-170.HS.1.0 10Oct2023 |Added Tooltips
    Caption = 'JobForecast';
    Editable = false;
    LinksAllowed = false;
    PageType = CardPart;
    ShowFilter = false;
    SourceTable = Job;


    layout
    {
        area(content)
        {
            group(Statistics)//old was group(Control1100773000)
            {
                fixed(" ")//CTSI-129 //old was fixed(Control1100773011)
                {
                    group("") //CTSI-129 //old was group(Control1100773305)
                    {
                        //CTSI-129-comment start
                        //field("''"; '')
                        //{
                        //    ApplicationArea = All;
                        //    Caption = ' ';
                        //    ToolTip = ' ';
                        //}
                        //field(Control1100773025; '')
                        //{
                        //    ApplicationArea = All;
                        //    Caption = ' ';
                        //    ToolTip = ' ';
                        //}
                        //CTSI-129-comment end
                        field("Column1[1]"; Column1[1])
                        {
                            ApplicationArea = All;
                            Caption = 'Budget Costs';
                            //ToolTip = 'Specifies the Budget Costs.'; //PE-170.HS.1.0 6Oct2023 Commented
                            ToolTip = 'Specifies the total of Budgeted Costs defined in a forecast based on the date filter applied.'; //PE-170.HS.1.0 6Oct2023 

                        }
                        field("Column1[2]"; Column1[2])
                        {
                            ApplicationArea = All;
                            Caption = 'Forecasted Cost To Complete';
                            //ToolTip = 'Specifies the Forecasted Cost To Complete'; //PE-170.HS.1.0 6Oct2023 Commented
                            ToolTip = 'Specifies the total of Forecasted Completed Cost defined in a forecast based on the date filter applied.'; //PE-170.HS.1.0 6Oct2023 
                        }
                        field("Estimated Cost To Complete"; '')
                        {
                            ApplicationArea = All;
                            Caption = 'Estimated Cost To Complete';
                            //ToolTip = 'Estimated Cost To Complete'; //PE-170.HS.1.0 6Oct2023 Commented
                            ToolTip = 'Specifies the total of Estimated Cost to Complete defined in a forecast based on the date filter applied.'; //PE-170.HS.1.0 6Oct2023 
                        }
                        field("Column1[3]"; Column1[3])
                        {
                            ApplicationArea = All;
                            Caption = 'Actual Costs';
                            //ToolTip = 'Actual Cost'; //PE-170.HS.1.0 6Oct2023 Commented
                            ToolTip = 'Specifies the total of Total Cost Used defined in a forecast based on the date filter applied.'; //PE-170.HS.1.0 6Oct2023 
                        }
                        field("Column1[4]"; Column1[4])
                        {
                            ApplicationArea = All;
                            Caption = 'Contract';
                            // ToolTip = 'Contract'; //PE-170.HS.1.0 6Oct2023 Commented
                            ToolTip = 'Specifies the total of Budgeted Price for a job till the date defined on the "As of Date Filter".';//PE-170.HS.1.0 6Oct2023 
                        }
                        field("Column1[5]"; Column1[5])
                        {
                            ApplicationArea = All;
                            Caption = 'Billings To Date';
                            // ToolTip = 'Billings To Date'; //PE-170.HS.1.0 6Oct2023 Commented
                            ToolTip = 'Specifies the total of Invoiced Price for a job till the date defined on the "As of Date Filter".'; //PE-170.HS.1.0 6Oct2023 
                        }
                        field("Column1[6]"; Column1[6])
                        {
                            ApplicationArea = All;
                            Caption = 'Job % Complete';
                            //ToolTip = 'Job % Complete'; //PE-170.HS.1.0 6Oct2023 Commented
                            //ToolTip = 'Specifies at what percentge the job is completed. This gets calculated by (Actual Costs / Forecasted Completed Cost) * 100'; //PE-170.HS.1.0 6Oct2023 //PE-170.HS.1.0 10Oct2023 Commented
                            ToolTip = 'Specifies at what percentage the job is completed. This gets calculated by (Actual Costs / Forecasted Completed Cost) * 100'; //PE-170.HS.1.0 10Oct2023 
                        }
                        field("Column1[7]"; Column1[7])
                        {
                            ApplicationArea = All;
                            Caption = 'Gross Profit To Date';
                            // ToolTip = 'Gross Profit To Date'; //PE-170.HS.1.0 6Oct2023 Commented
                            ToolTip = 'Specifies the gross profit of the job based on date filter applied. This gets calculated by "((Job % Complete * Contract) / 100) - Actual Costs"'; //PE-170.HS.1.0 6Oct2023 
                        }
                    }
                    // group(Control1100773012)
                    // {
                    //     Visible = false;
                    //     field("ColumnHeading1[1]"; ColumnHeading1[1])
                    //     {
                    //         ApplicationArea = All;
                    //         ToolTip = ' ';
                    //         Caption = ' ';
                    //     }
                    //     field("ColumnHeading2[1]"; ColumnHeading2[1])
                    //     {
                    //         ApplicationArea = All;
                    //         ToolTip = ' ';
                    //         Caption = ' ';
                    //     }
                    //     field("Column2[1]"; Column2[1])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = '<Control1100773020>';
                    //         Width = 15;
                    //         ToolTip = ' ';
                    //     }
                    //     field("Column2[2]"; Column2[2])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = '<Control1100773001>';
                    //         Width = 15;
                    //         ToolTip = ' ';
                    //     }
                    //     field(Control1100773036; '')
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }
                    //     field("Column2[3]"; Column2[3])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = '<Control1100773021>';
                    //         Width = 15;
                    //         ToolTip = ' ';
                    //     }
                    //     field("Column2[4]"; Column2[4])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = '<Control1100773022>';
                    //         Width = 15;
                    //         ToolTip = ' ';
                    //     }
                    //     field("Column2[5]"; Column2[5])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = '<Control1100773023>';
                    //         Width = 15;
                    //         ToolTip = ' ';
                    //     }
                    //     field("Column2[6]"; Column2[6])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = '<Control1100773024>';
                    //         ToolTip = ' ';
                    //     }
                    //     field("Column2[7]"; Column2[7])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = '<Control1100773002>';
                    //         ToolTip = ' ';
                    //     }
                    // }
                    group("  ")//CTSI-129 //Old was group(Control1100773026)
                    {
                        //field("ColumnHeading1[2]"; ColumnHeading1[2])
                        //{
                        //    ApplicationArea = All;
                        //    ToolTip = ' ';
                        //    Caption = ' ';
                        //}
                        //field("ColumnHeading2[2]"; ColumnHeading2[2])
                        //{
                        //    ApplicationArea = All;
                        //    Caption = ' ';
                        //    ToolTip = ' ';
                        //} //CTSI-129 comment
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
                        field("Column3[6]"; Column6[1]) //PRJ-433 changes from 2 to 3 //PRJ-596.GK.1.0 //PRJ-353.GK.1.0 08Sep2021
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
                    // group(Control1100773033)
                    // {
                    //     Visible = false;
                    //     field("ColumnHeading1[3]"; ColumnHeading1[3])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }
                    //     field("ColumnHeading2[3]"; ColumnHeading2[3])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }
                    //     field(Control1100773034; Column3[1])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }
                    //     field(Control1100773035; Column3[2])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }
                    //     field(Control1100773046; '')
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }
                    //     field(Control1100773336; Column3[3])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }
                    //     field(Control1100773037; Column3[4])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }
                    //     field("'        ' + FORMAT(ROUND(Column3[5],1)) + '%'"; '        ' + FORMAT(ROUND(Column3[5], 1)) + '%')
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }
                    //     field(Control1100773005; Column3[6])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }
                    // }
                    // group(Control1100773040)
                    // {
                    //     Visible = false;
                    //     field("ColumnHeading1[4]"; ColumnHeading1[4])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }
                    //     field("ColumnHeading2[4]"; ColumnHeading2[4])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }
                    //     field("Column4[1]"; Column4[1])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }
                    //     field("Column4[2]"; Column4[2])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }
                    //     field(Control1100773053; '')
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }

                    //     field("Column4[3]"; Column4[3])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }
                    //     field("Column4[4]"; Column4[4])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }
                    //     field("Column4[5]"; Column4[5])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }
                    //     field("Column4[6]"; Column4[6])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }
                    // }
                    // group(Control1100773047)
                    // {
                    //     Visible = false;
                    //     field("ColumnHeading1[5]"; ColumnHeading1[5])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }
                    //     field("ColumnHeading2[5]"; ColumnHeading2[5])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }
                    //     field("Column5[1]"; Column5[1])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }
                    //     field("Column5[2]"; Column5[2])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }
                    //     field(Control1100773054; '')
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }
                    //     field("Column5[3]"; Column5[3])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }
                    //     field("Column5[4]"; Column5[4])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }
                    //     field("Column5[5]"; Column5[5])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }
                    //     field("Column5[6]"; Column5[6])
                    //     {
                    //         ApplicationArea = All;
                    //         Caption = ' ';
                    //         ToolTip = ' ';
                    //     }
                    // }
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
        JobForecast: Record "NS_Job Forecast";
        PreviousJobForecast: Record "NS_Job Forecast";
        JobPlanningLine: Record "Job Planning Line";
        JobPlanningLineBudget: Record "Job Planning Line";
        GLSetup: Record "General Ledger Setup";
        JobSetup: record "Jobs Setup"; //PRJ-1454.NK.1.0 17Oct2022
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

    procedure NS_FillInTable();
    begin

        if JobNoSentIn = '' then
            exit;
        TotalCostToComplete := 0;
        TotalCostsUsed := 0;
        TotalContractValue := 0;
        TotalBillings := 0;

        GLSetup.GET();

        with JobForecast do begin
            RESET();
            SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date");
            SETRANGE("NS_Job No.", JobNoSentIn);
            SETRANGE(NS_Posted, false);
            /*
            IF FINDSET THEN
                REPEAT
                  GetJobPlanningLineAndBudget(JobNoSentIn,"Job Task No.",JobPlanningLineBudget,TotalBudget);
                  BudgetedCosts := BudgetedCosts + TotalBudget;
                UNTIL NEXT = 0;
            */

            //SETFILTER("NS_Status Date", '<=%1', NewStatusDateSentIn);//prj-596 COMMENT
            if FINDSET() then
                repeat

                    Job.RESET();
                    Job.SETRANGE("No.", JobNoSentIn);
                    Job.SETRANGE("NS_Job Task No. Filter", "NS_Job Task No.");
                    if NewStatusDateSentIn <> 0D then
                        Job.SETFILTER("NS_Date Filter", '..%1', NewStatusDateSentIn)
                    else
                        Job.SETRANGE("NS_Date Filter");
                    if Job.FINDFIRST() then;

                    Job.CALCFIELDS("NS_Budgeted Price (LCY)", "NS_Invoiced Price (LCY)", "NS_Usage (Cost) (LCY)");
                    TotalCostsUsed := TotalCostsUsed + Job."NS_Usage (Cost) (LCY)"; //PRJ-433 
                   //TotalContractValue := TotalContractValue + Job."NS_Budgeted Price (LCY)"; //PRJ-433  PRJ-1454.NK.1.0 17Oct2022 Block
                TotalContractValue := GetPlanningLineIncludeSubLevels(0D, NewStatusDateSentIn, JobNoSentIn); //PRJ-1454.NK.1.0 17Oct2022     
                    TotalBillings := TotalBillings + Job."NS_Invoiced Price (LCY)";  //PRJ-433 

                    NS_GetLastPostedStatus("NS_Job No.", "NS_Job Task No.", NewStatusDateSentIn, PreviousJobForecast);
                    if ("NS_Job No." > '') and ("NS_Status Date" <= NewStatusDateSentIn) then begin
                        //  NS_GetJobPlanningLineAndBudget(JobNoSentIn, "NS_Job Task No.", JobPlanningLineBudget, TotalBudget);
                        NS_GetJobSumofTotalBudget(JobNoSentIn, "NS_Job Task No.", JobPlanningLineBudget, TotalBudget, NewStatusDateSentIn);//PRJ-596
                        BudgetedCosts := TotalBudget;//prj-596
                        //  TotalForecastedCompletedCost := TotalForecastedCompletedCost + "NS_Forecasted Completed Cost";
                        CalcFields("NS_Total Est. cost to Complete", "NS_Total Forecast Completed Cost");//prj-596
                        TotalForecastedCompletedCost := "NS_Total Forecast Completed Cost";//prj-596
                        if "NS_Entry Type" = "NS_Entry Type"::Price then begin
                            PlanningLineTotal := 0;
                            JobPlanningLine.RESET();
                            JobPlanningLine.SETRANGE("Job No.", "NS_Job No.");
                            JobPlanningLine.SETRANGE("Job Task No.", "NS_Job Task No.");
                            if JobPlanningLine.FINDSET() then
                                repeat
                                    PlanningLineTotal := PlanningLineTotal + JobPlanningLine."Total Price";
                                until JobPlanningLine.NEXT() = 0;
                            TotalPortions := TotalPortions + ROUND(PlanningLineTotal * ("NS_Bill Percent" / 100), GLSetup."Amount Rounding Precision");
                        end;
                        //PRJ-596 
                        TotalCostToComplete := "NS_Total Est. cost to Complete";
                        //if "NS_Hours To Finish" = 0 then //prj-596-comment
                        //    TotalCostToComplete += NS_CalcCostToComplete("NS_Status Date", "NS_Percent Complete", TotalBudget, TotalCostsUsed,
                        //      PreviousJobForecast."NS_Status Date", PreviousJobForecast."NS_Forecasted Completed Cost");
                        //PRJ-596 
                    end;
                until NEXT() = 0;

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

        end;

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

    procedure NS_Set(JobNoIn: Code[20]; NewStatusDateIn: Date);
    begin
        JobNoSentIn := JobNoIn;
        NewStatusDateSentIn := NewStatusDateIn;
    end;
    //PRJ-1454.NK.1.0 18Oct2022 Start
    procedure GetPlanningLineIncludeSubLevels(StartDate: Date; var Enddate: Date; var ParaJob: Code[20]) Answer: Decimal;
    var
        PlanningLine: Record "Job Planning Line";
        PlanningLine2: Record "Job Planning Line";
        NSJob: Record Job;   
        JobNoFilter: Code[20];
        IsHandle: Boolean;//FGH-163.SM.20022024 PE-269.JS.1.0 05MAR2024
    begin
        //FGH-163.SM.29022024 PE-269.JS.1.0 05MAR2024 START
        OnBeforeGetPlanningLineIncludeSubLevels(StartDate, Enddate, ParaJob, IsHandle, Answer);//FGH-163.SMAdded Parameter  //PE-269.JS.1.0
        if IsHandle then
            exit(Answer);
        //FGH-163.SM.29022024 PE-269.JS.1.0 05MAR2024 END
        JobNoFilter := '';
        JobNoFilter := '@*' + format(ParaJob) + '*';
        if jobSetup.Get() then;
        Answer := 0;
        PlanningLine.Reset();
        PlanningLine.SetRange("Job No.", ParaJob);     
        PlanningLine.SetFilter("Line Type", '<>%1', PlanningLine."Line Type"::Budget);
        if jobSetup."NS_Enab. Budg.on Contract Date" then
            PlanningLine.SetRange("NS_Contract Forecast Date", StartDate, Enddate)
        else 
            PlanningLine.SetRange("Planning Date", StartDate, Enddate);
        if PlanningLine.FindSet() then
            repeat
                    Answer := Answer + PlanningLine."Total Price (LCY)";
            until PlanningLine.Next() = 0;

        NSJob.Reset();
        NSJob.SetCurrentKey("NS_Sub-Level to Job No.");
        NSJob.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        if NSJob.FindSet() then
            repeat
                PlanningLine2.Reset();
                PlanningLine2.SetRange("Job No.", NSJob."No.");               
                PlanningLine2.SetFilter("Line Type", '<>%1', PlanningLine2."Line Type"::Budget);
                if jobSetup."NS_Enab. Budg.on Contract Date" then
                    PlanningLine2.SetRange("NS_Contract Forecast Date", StartDate, Enddate)
                else 
                    PlanningLine2.SetRange("Planning Date", StartDate, Enddate);
                if PlanningLine2.FindSet() then
                    repeat
                            Answer := Answer + PlanningLine2."Total Price (LCY)";
                    until PlanningLine2.Next() = 0;
            until NSJob.Next() = 0;
        exit(Answer);
    end;
    //PRJ-1454.NK.1.0 18Oct2022 End

    //FGH-163.SM.29022024 PE-269.JS.1.0 05MAR2024 START
    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetPlanningLineIncludeSubLevels(StartDate: Date; var Enddate: Date; var ParaJob: Code[20]; var Ishandled: Boolean; var FGHAnswer: Decimal)//FGH-163.SMAdded Parameter //PE-269.JS.1.0
    begin

    end;
    //FGH-163.SM.29022024 PE-269.JS.1.0 05MAR2024 END
}

