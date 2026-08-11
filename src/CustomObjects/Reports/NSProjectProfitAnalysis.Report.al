report 14021386 "NS_Percentage of CompletionNew"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //SMPL - Caption = 'RequestPage' can't be used on area
    //PRJ-84.SK.1.0 Added report to search
    //CTSI-94.AS.1.0 10AUG2020 New fields added & done modification of JobPercent Value
    //CTSI-94.AS.1.0 10AUG2020 Changed caption & also done other customizations to add new data in layout of report including sublevel jobs
    //CTSI-121.N.S.1.0 18aug2020 Add filter manager & person Responsible
    //CTSI-152.AS.1.0 14Sept2020 Added condition to excluded Master level excluded jobs
    //PRJ-422.AM.1.0 22OCT2020 | Modifications in Manager and Person Responsible table Relations .
    //PRJ-422.AM.2.0 28OCT2020 | Added Manager & Person Responsible Fields in RequestFilterFields and set visibility of Manager & person responsible variable on request page false.
    //CTSI-202.AM.1.0 16NOV2020 | Added 1 Filter field Gen. Bus posting Group.
    //PRJ-831.AS.1.0 12OCT2021 Replaced Job Table field Gen Bus Posting Grp with Gen Bus Posting Grp New
    //PRJ-1454.NK.1.0 27Jun2022 | Added Code
    //PE-141.AS.1.0 16AUG2023 Done change in layout to Add comp logo, user id, timedate, page
    //PRJCTPR-282.DK.1.0 02April2024 | change in Layout
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSProjectProfitAnalysisReport.rdl';
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Project Profit Analysis Report';//CTSI-94.AS.1.0 10AUG2020
    EnableHyperlinks = true;
    ApplicationArea = all;

    dataset
    {
        dataitem(ReportHeadings; "Integer")
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending);
            MaxIteration = 1;
            column(Report_Name; Report_NameLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            //PE-141.AS.1.0 16AUG2023 start
            column(CompanyInformationPic; CompanyInformation.Picture) { }
            column(CompanyInformationAdd; CompanyInformation.Address) { }
            column(CompanyInformationadd2; CompanyInformation."Address 2") { }
            column(CompanyInformationcity; CompanyInformation.City) { }
            column(CompanyInformationRegion; CompanyInformation."Country/Region Code") { }
            column(CompanyInformationpost; CompanyInformation."Post Code") { }
            column(CompanyInformationCountry; CompanyInformation.County) { }
            column(CompanyInformationPhone; CompanyInformation."Phone No.") { }
            column(NS_CompanyFullAddress; NS_CompanyFullAddress) { }//PE-141.AS.1.0 24AUG2023
            //PE-141.AS.1.0 16AUG2023 end
            column(ShowJobSummaries; ShowJobSummaries)
            {
            }
            column(ShowReportSummary; ShowReportSummary)
            {
            }
            column(IncludeAdjustmentsText; IncludeAdjustmentsText)
            {
            }
            column(CompletePercentText; CompletePercentText)
            {
            }
            column(Sub_LevelsText_; "Sub-LevelsText")
            {
            }
            column(WorksheetText; WorksheetText)
            {
            }
            column(MarkedCostEntriesExcluded; MarkedCostEntriesExcluded)
            {
            }
            column(MarkedPriceEntriesExcluded; MarkedPriceEntriesExcluded)
            {
            }
            column(Job_TABLECAPTION_____Filters______JobFilter; Job.TABLECAPTION + ' Filters: ' + JobFilter)
            {
            }
            column(ReportHeadings_Number; Number)
            {
            }
            column(Job_No_Caption; Job_No_CaptionLbl)
            {
            }
            column(Job_DescriptionCaption; Job.FIELDCAPTION(Description))
            {
            }
            //PRJ-422.AM.1.0 start
            column(Job_Manager; Job.NS_Manager)
            {
            }
            //PRJ-422.AM.1.0 End
            column(Contract_PriceCaption; Contract_PriceCaptionLbl)
            {
            }
            column(To_Date_BillingsCaption; To_Date_BillingsCaptionLbl)
            {
            }
            column(To_Date_CostCaption; To_Date_CostCaptionLbl)
            {
            }
            column(Total_Cost_EstimateCaption; Total_Cost_EstimateCaptionLbl)
            {
            }
            column(Percent_CompletionCaption; Percent_CompletionCaptionLbl)
            {
            }
            column(Recognized_RevenueCaption; Recognized_RevenueCaptionLbl)
            {
            }
            column(Recognized_Profit_LossCaption; Recognized_Profit_LossCaptionLbl)
            {
            }
            column(Over_BillingsCaption; Over_BillingsCaptionLbl)
            {
            }
            column(Under_BillingsCaption; Under_BillingsCaptionLbl)
            {
            }
            column(ChginperCompl; ChginperCompl) { } //PRJCTPR-282.DK.1.0 4April2024
            dataitem(Job; Job)
            {
                DataItemTableView = SORTING("No.");
                RequestFilterFields = "No.", NS_Manager, "Person Responsible", "NS_Gen. Bus. Posting Group New", "Bill-to Customer No.", "NS_Date Filter", Status, "NS_Activity Filter", "NS_Process Filter", "NS_Operation Filter";//PRJ-422.AM.2.0 //CTSI-202.AM.1.0 //PRJ-831.AS.1.0 12OCT2021
                column(Job__No__; "No.")
                {
                }
                column(A; A)
                {
                }
                column(B; B)
                {
                }
                column(C; C)
                {
                }
                column(D; D)
                {
                }
                column(E; E)
                {
                }
                column(F; F)
                {
                }
                column(G; G)
                {
                }
                column(H; H)
                {
                }
                column(I; I)
                {
                }
                column(Job_Description; Description)
                {
                }
                column(FORMAT_JobRecRef_0_10_; FORMAT(JobRecRef.RECORDID, 0, 10))
                {
                }
                column(PercentType; PercentType)
                {
                }
                column(A_Total; A)
                {
                }
                column(B_Total; B)
                {
                }
                column(C_Total; C)
                {
                }
                column(D_Total; D)
                {
                }
                column(F_Total; F)
                {
                }
                column(G_Total; G)
                {
                }
                column(H_Total; H)
                {
                }
                column(I_Total; I)
                {
                }
                column(TotalsCaption; TotalsCaptionLbl)
                {
                }

                column(JobPctCompleteVal; JobPctCompleteVal)//CTSI-94.AS.1.0 10AUG2020
                {

                }
                column(ChangePercCompValToShow; ChangePercCompValToShow)//CTSI-94.AS.1.0 10AUG2020
                {

                }
                column(ChangeinPercRecProfVal; ChangeinPercRecProfVal)//CTSI-94.AS.1.0 10AUG2020
                {

                }
                column(changeRecProftPercentage; changeRecProftPercentage)//CTSI-94.AS.1.0 10AUG2020
                {

                }
                dataitem(JobSummary; "Integer")
                {
                    DataItemTableView = SORTING(Number) ORDER(Ascending);
                    column(SummaryA_Number_; SummaryA[Number])
                    {
                    }
                    column(SummaryB_Number_; SummaryB[Number])
                    {
                    }
                    column(SummaryC_Number_; SummaryC[Number])
                    {
                    }
                    column(SummaryD_Number_; SummaryD[Number])
                    {
                    }
                    column(SummaryE_Number_; SummaryE[Number])
                    {
                    }
                    column(SummaryF_Number_; SummaryF[Number])
                    {
                    }
                    column(SummaryG_Number_; SummaryG[Number])
                    {
                    }
                    column(SummaryGlobalDim1_Number_; SummaryGlobalDim1[Number])
                    {
                    }
                    column(SummaryH_Number_; SummaryH[Number])
                    {
                    }
                    column(SummaryI_Number_; SummaryI[Number])
                    {
                    }
                    column(JobSummary_Number; Number)
                    {
                    }

                    trigger OnAfterGetRecord();
                    begin
                        if CurrentPointer = -1 then begin
                            CurrReport.BREAK;
                        end;

                        if SummaryGlobalDim1[Number] = '' then
                            SummaryGlobalDim1[Number] := Text001;
                    end;

                    trigger OnPostDataItem();
                    begin
                        CLEAR(SummaryGlobalDim1);
                        CLEAR(SummaryA);
                        CLEAR(SummaryB);
                        CLEAR(SummaryC);
                        CLEAR(SummaryD);
                        CLEAR(SummaryE);
                        CLEAR(SummaryF);
                        CLEAR(SummaryG);
                        CLEAR(SummaryH);
                        CLEAR(SummaryI);
                        CurrentPointer := 0;
                        TopPointer := 0;
                    end;

                    trigger OnPreDataItem();
                    begin
                        CurrentPointer := -1;
                        if not ShowJobSummaries then
                            CurrReport.SKIP;

                        if TopPointer > 0 then begin
                            SETRANGE(Number, 1, TopPointer);
                            CurrentPointer := 1;
                        end else
                            CurrReport.SKIP;
                    end;
                }

                trigger OnAfterGetRecord();
                begin
                    Clear(ToPrintRecognizedRevenue);//TEST

                    Clear(ChangeinPercRecProfValFinalSubJobAded);
                    Clear(ChangeinPercRecProfValInitialSubJobAdded);
                    Clear(changeRecProftPercentageFinalSubJobAdded);
                    Clear(changeRecProftPercentageInitialSubJobAdded);
                    Clear(StoreJobNoPercentCompletion);
                    Clear(StoreJobNo);//CTSI-115.AS.1.0
                    clear(StoreJobNo2);//CTSI-115.AS.1.0
                    Clear(JobPctCompleteVal);//CTSI-94.AS.1.0 10AUG2020
                    Clear(ChangePercCompValFinalSubJobAdded);
                    Clear(ChangePercCompValInitialSubJobAdded);
                    Clear(ChangePercCompValInitial);//CTSI-94.AS.1.0 10AUG2020
                    Clear(ChangePercCompValFinal);//CTSI-94.AS.1.0 10AUG2020
                    Clear(ChangePercCompValToShow);//CTSI-94.AS.1.0 10AUG2020
                    Clear(ChangeRecProfVal);//CTSI-94.AS.1.0 10AUG2020
                    Clear(ChangeinPercRecProfVal);//CTSI-94.AS.1.0 10AUG2020
                    Clear(StrorePipelineSubJobs);//CTSI-94.AS.1.0 10AUG2020
                    Clear(changeRecProftPercentage);//CTSI-94.AS.1.0 10AUG2020
                    Clear(ChangeinPercRecProfValFinal);//CTSI-94.AS.1.0 10AUG2020
                    Clear(ChangeinPercRecProfValInitial);//CTSI-94.AS.1.0 10AUG2020
                    Clear(changeRecProftPercentageFinal);//CTSI-94.AS.1.0 10AUG2020
                    Clear(changeRecProftPercentageInitial);//CTSI-94.AS.1.0 10AUG2020
                    Clear(JobPctCount);//CTSI-115.AS.1.0
                    clear(AvgCalcJobPctCompleteVal);//CTSI-115.AS.1.0
                    Clear(AvgCalcRevenueProfitPercent); //CTSI-115.AS.1.0
                    Clear(ChangePercentCompletionCountFinal);//CTSI-115.AS.1.0
                    Clear(ChangePercentCompletionCountInitial);//CTSI-115.AS.1.0
                    Clear(FinalPercentval);//CTSI-115.AS.1.0
                    Clear(InitialPercentVal);//CTSI-115.AS.1.0
                    Clear(Totalcount);
                    clear(TotalchangePerCentCompleteCountFinal);
                    Clear(TotalchangePerCentCompleteCountInitial);



                    //CTSI-115.AS.1.0 - start
                    if JobRec.Get(Job."No.") then begin
                        if JobRec."NS_Exclude from Job Forecast" = true then//CTSI-152.AS.1.0 14Sept2020
                            CurrReport.Skip;//CTSI-152.AS.1.0 14Sept2020

                        if (IncludeSubLevelsInMasterJobValues = true) and (JobRec."NS_Sub-Level to Job No." > '') then
                            CurrReport.skip;
                    end;
                    //CTSI-115.AS.1.0 - end

                    JobRecRef.SETPOSITION(Job.GETPOSITION);

                    if DoNotShowSubLevels and ("NS_Sub-Level to Job No." > '') then
                        CurrReport.SKIP;
                    //CTSI-121.N.S.1.0 18Aug2020 Start
                    if ManagerValue <> '' then
                        Job.SetRange(NS_Manager, ManagerValue);
                    if ResponsiblePerson <> '' then
                        Job.SetRange("Person Responsible", ResponsiblePerson);
                    //CTSI-121.N.S.1.0 18Aug2020 end;


                    JobFilters := Job;
                    JobFilters.COPYFILTERS(Job);

                    ForecastedCompletedCost(Job, UseJobForecastWorksheet, UseEnteredPercentComplete,
                                            ToPrintContract,
                                            ToPrintToDateCost,
                                            ToPrintBillings,
                                            ToPrintCostEstimate,
                                            PercentType);

                    //PRJ-585.AS.1.0 - start
                    if (UseJobForecastWorksheet = true) then begin
                        clear(PrintCostEstimateSummDetails);//PRJ-585.AS.1.0
                        Clear(DateGetted);//PRJ-585.AS.1.0
                        Clear(DateVarStore);//PRJ-585.AS.1.0

                        RecProjSummDtl.Reset();
                        RecProjSummDtl.SetCurrentKey("NS_Job No.", "NS_Posting Date");
                        RecProjSummDtl.SetRange("NS_Job No.", Job."No.");
                        if DateVarStore <> 0D then
                            RecProjSummDtl.SetFilter("NS_Posting Date", GetFilter("NS_Date Filter"));
                        if RecProjSummDtl.FindLast() then
                            PrintCostEstimateSummDetails := RecProjSummDtl."NS_TotalForecastCompletedCost";
                    end;

                    if (UseJobForecastWorksheet = true) and (PrintCostEstimateSummDetails <> 0) then begin
                        ToPrintCostEstimate := PrintCostEstimateSummDetails;
                    end;
                    if (UseJobForecastWorksheet = true) and (PrintCostEstimateSummDetails = 0) then begin
                        ToPrintCostEstimate := ToPrintCostEstimate;
                    end;
                    //PRJ-585.AS.1.0 - end

                    if IncludeSubLevelsInMasterJobValues then begin
                        SLsForecastedCompletedCost(Job, UseJobForecastWorksheet, UseEnteredPercentComplete,
                                                   SLsToPrintContract,
                                                   SLsToPrintToDateCost,
                                                   SLsToPrintBillings,
                                                   SLsToPrintCostEstimate,
                                                   SLsPercentType);

                        //PRJ-585.AS.1.0 - start
                        if (UseJobForecastWorksheet = true) then begin
                            clear(SLPrintCostEstimateSummDetails);//PRJ-585.AS.1.0

                            SLJobs.RESET;
                            SLJobs.SETRANGE("NS_Sub-Level to Job No.", Job."No.");
                            IF SLJobs.FINDSET THEN
                                REPEAT

                                    RecProjSummDtl.Reset();
                                    RecProjSummDtl.SetCurrentKey("NS_Job No.", "NS_Posting Date");
                                    RecProjSummDtl.SetRange("NS_Job No.", SLJobs."No.");
                                    if DateVarStore <> 0D then
                                        RecProjSummDtl.SetFilter("NS_Posting Date", GetFilter("NS_Date Filter"));
                                    if RecProjSummDtl.FindLast() then
                                        SLPrintCostEstimateSummDetails += RecProjSummDtl.NS_TotalForecastCompletedCost;
                                UNTIL SLJobs.NEXT = 0;

                            if (UseJobForecastWorksheet = true) and (SLPrintCostEstimateSummDetails <> 0) then begin
                                SLsToPrintCostEstimate := SLPrintCostEstimateSummDetails;
                            end;
                            if (UseJobForecastWorksheet = true) and (SLPrintCostEstimateSummDetails = 0) then begin
                                SLsToPrintCostEstimate := SLsToPrintCostEstimate
                            end;

                        END;
                        //PRJ-585.AS.1.0 - end

                        ToPrintContract := ToPrintContract + SLsToPrintContract;
                        ToPrintToDateCost := ToPrintToDateCost + SLsToPrintToDateCost;
                        ToPrintBillings := ToPrintBillings + SLsToPrintBillings;
                        ToPrintCostEstimate := ToPrintCostEstimate + SLsToPrintCostEstimate;
                    end;

                    //Get ToPrintPercentComplete either from Job card or from pre-calculated values
                    ToPrintPercentComplete := 0;
                    if UseJobForecastWorksheet then
                        if ToPrintCostEstimate <> 0 then
                            ToPrintPercentComplete := 100 - ((ToPrintCostEstimate - ToPrintToDateCost) / ToPrintCostEstimate) * 100;

                    if (ToPrintPercentComplete = 0) and UseEnteredPercentComplete then
                        if "NS_Actual Percent Complete" > 0 then
                            ToPrintPercentComplete := "NS_Actual Percent Complete";

                    if (ToPrintPercentComplete = 0) and UseJobForecastWorksheet then
                        //Get from Job Forecast Worksheet
                        if ToPrintCostEstimate <> 0 then
                            ToPrintPercentComplete := 100 - ((ToPrintCostEstimate - ToPrintToDateCost) / ToPrintCostEstimate) * 100;
                    if (ToPrintPercentComplete = 0) or ((UseJobForecastWorksheet = false) and (UseEnteredPercentComplete = false)) then
                        //Calculate based on Cost Estimate calculated above
                        if ToPrintCostEstimate <> 0 then
                            ToPrintPercentComplete := 100 - ((ToPrintCostEstimate - ToPrintToDateCost) / ToPrintCostEstimate) * 100;

                    // ToPrintPercentComplete := ROUND(ToPrintPercentComplete, 0.01);
                    ToPrintPercentComplete := ROUND(ToPrintPercentComplete, JobsetupRec."NS_Forecast Amount Rounding");//PRJ-543
                    if ToPrintPercentComplete > 100 then
                        ToPrintPercentComplete := 100;
                    /// Job Percent Value : In case of Main Job //CTSI-115.AS.1.0 - start
                    //PRJ-585.AS.1.0 12MAR2021 - COMMENT START 
                    /* if IncludeSubLevelsInMasterJobValues = false then begin
                         PercCompRec.Reset;
                         PercCompRec.SetCurrentKey("Entry No");
                         PercCompRec.SetRange("Job No.", Job."No.");
                         if GETFILTER("Date Filter") <> '' then
                             PercCompRec.setfilter("Posting Date", GETFILTER("Date Filter"));//MS
                         if PercCompRec.FindLast then begin
                             JobPctCompleteVal := PercCompRec."Job Percent Complete";
                         end;
                     end;*/
                    //PRJ-585.AS.1.0 12MAR2021 - COMMENT END
                    /// Job Percent value : In case of Main Job //CTSI-115.AS.1.0 - end

                    //*** Job Percent New Modified - start ***//


                    /// Job Percent value : In case of Main Job + Sub Job //CTSI-115.AS.1.0 - start         
                    //PRJ-585.AS.1.0 12MAR2021 - COMMENT START
                    /*if IncludeSubLevelsInMasterJobValues = true then begin
                        PercCompRecOuter.reset;
                        PercCompRecOuter.SetCurrentKey("Job No.");
                        if GETFILTER("Date Filter") <> '' then
                            PercCompRecOuter.SetFilter("Posting Date", GETFILTER("Date Filter"));//ms
                        JobRec2.RESET;// Used to store Main Job + Sub Job - start
                        JobRec.SetCurrentKey("No.");
                        JobRec2.SetFilter("Sub-Level to Job No.", Job."No.");
                        JobRec2.SetRange("Exclude from Job Forecast", false);
                        if GBPGValTxt > '' then
                            JobRec2.SetFilter("Gen. Bus. Posting Group", GBPGValTxt);
                        IF JobRec2.FINDSET THEN begin
                            REPEAT
                                IF JobRec2."No." <> '' THEN
                                    StrorePipelineSubJobs += '|' + JobRec2."No.";
                            UNTIL JobRec2.NEXT = 0;
                        end; // Used to store Main Job + Sub Job - end
                        PercCompRecOuter.SetFilter("Job No.", Job."No." + StrorePipelineSubJobs);
                        if PercCompRecOuter.FindSet then begin
                            repeat
                                if (StoreJobNo <> PercCompRecOuter."Job No.") then begin
                                    PercCompRecInner.reset;
                                    PercCompRecInner.SetCurrentKey("Entry No");
                                    PercCompRecInner.SetRange("Job No.", PercCompRecOuter."Job No.");
                                    if GETFILTER("Date Filter") <> '' then
                                        PercCompRecInner.SetFilter("Posting Date", GETFILTER("Date Filter"));//MS
                                    PercCompRecInner.SetFilter("Gross Margin Percent", '<>%1', 0); //MS
                                    if PercCompRecInner.FindLast then begin
                                        AvgCalcJobPctCompleteVal += PercCompRecInner."Job Percent Complete";
                                        JobPctCount += 1;
                                    end;
                                end;
                                StoreJobNo := PercCompRecOuter."Job No.";
                            until PercCompRecOuter.Next = 0;
                        end;
                        if JobPctCount <> 0 then
                            // JobPctCompleteVal := Round(AvgCalcJobPctCompleteVal / JobPctCount, 0.01, '>');
                            JobPctCompleteVal := Round(AvgCalcJobPctCompleteVal / JobPctCount, JobsetupRec."Forecast Amount Rounding");//PRJ-543.AS.1.0 18FEB2021
                    end; */
                    //PRJ-585.AS.1.0 12MAR2021 - COMMENT END
                    /// Job Percent value : In case of Main Job + Sub Job //CTSI-115.AS.1.0 - end
                    //*** Job Percent New Modified - end ***//

                    //*** Change % in completion, Recognized Profit, Recognized Profit Percent New Modified - start ***//
                    /// Change % in completion, Recognized Profit, Recognized Profit Percent : In case of Main Job //CTSI-115.AS.1.0 - start
                    if IncludeSubLevelsInMasterJobValues = false then begin
                        PercCompRecOuter.Reset;
                        PercCompRecOuter.SetCurrentKey("NS_Entry No");
                        PercCompRecOuter.SetRange("NS_Job No.", Job."No.");
                        if GETFILTER("NS_Date Filter") <> '' then
                            PercCompRecOuter.SetFilter("NS_Posting Date", GETFILTER("NS_Date Filter"));//MS
                        Totalcount := PercCompRecOuter.Count;

                        if Totalcount > 1 then begin

                            if PercCompRecOuter.FindLast then begin
                                ChangePercCompValFinal := PercCompRecOuter."NS_Job Percent Complete";
                                //PRJCTPR-282.DK.1.0 Start
                                // ChangeinPercRecProfValFinal := PercCompRecOuter."NS_Recognized Profit";
                                ChangeinPercRecProfValFinal := PercCompRecOuter."NS_Gross Margin";
                                // changeRecProftPercentageFinal := PercCompRecOuter."NS_Recognized Profit Percent";
                                changeRecProftPercentageFinal := PercCompRecOuter."NS_Gross Margin Percent";
                                //PRJCTPR-282.DK.1.0 End
                                PercCompRecInner.Reset;
                                PercCompRecInner.SetCurrentKey("NS_Entry No");
                                PercCompRecInner.SetFilter("NS_Job No.", PercCompRecOuter."NS_Job No.");
                                PercCompRecInner.SetFilter("NS_Posting Date", '< %1', PercCompRecOuter."NS_Posting Date");
                                if PercCompRecInner.FindLast then begin
                                    ChangePercCompValInitial := PercCompRecInner."NS_Job Percent Complete";
                                    //PRJCTPR-282.DK.1.0 Start
                                    //ChangeinPercRecProfValInitial := PercCompRecInner."NS_Recognized Profit";
                                    ChangeinPercRecProfValInitial := PercCompRecInner."NS_Gross Margin";
                                    //changeRecProftPercentageInitial := PercCompRecInner."NS_Recognized Profit Percent";
                                    changeRecProftPercentageInitial := PercCompRecInner."NS_Gross Margin Percent";
                                    //PRJCTPR-282.DK.1.0 End
                                end;
                            end;

                            // ChangePercCompValToShow := round(ChangePercCompValFinal - ChangePercCompValInitial, 0.01, '>');
                            ChangePercCompValToShow := round(ChangePercCompValFinal - ChangePercCompValInitial, JobsetupRec."NS_Forecast Amount Rounding");//PRJ-543.AS.1.0 18FEB2021
                                                                                                                                                           // ChangeinPercRecProfVal := Round(ChangeinPercRecProfValFinal - ChangeinPercRecProfValInitial, 0.01, '>');
                            ChangeinPercRecProfVal := Round(ChangeinPercRecProfValFinal - ChangeinPercRecProfValInitial, JobsetupRec."NS_Forecast Amount Rounding");//PRJ-543.AS.1.0 18FEB2021
                                                                                                                                                                    // changeRecProftPercentage := Round(changeRecProftPercentageFinal - changeRecProftPercentageInitial, 0.01, '>');
                            changeRecProftPercentage := Round(changeRecProftPercentageFinal - changeRecProftPercentageInitial, JobsetupRec."NS_Forecast Amount Rounding");//PRJ-543.AS.1.0 18FEB2021
                        end;

                        if Totalcount = 1 then begin
                            ChangePercCompValToShow := 0;
                            ChangeinPercRecProfVal := 0;
                            changeRecProftPercentage := 0;
                        end;

                    end;
                    /// Change % in completion, Recognized Profit, Recognized Profit Percent : In case of Main Job //CTSI-115.AS.1.0 - end

                    /// Change % in completion, Recognized Profit, Recognized Profit Percent : In case of Main Job + SubJob //CTSI-115.AS.1.0 - start
                    if IncludeSubLevelsInMasterJobValues = true then begin
                        PercCompRecOuter.reset;
                        PercCompRecOuter.SetCurrentKey("NS_Job No.");

                        JobRec2.RESET;// Used to store Main Job + Sub Job - start
                        JobRec.SetCurrentKey("No.");
                        JobRec2.SetFilter("NS_Sub-Level to Job No.", Job."No.");
                        JobRec2.SetRange("NS_Exclude from Job Forecast", false);
                        if GBPGValTxt > '' then
                            //JobRec2.SetFilter("NS_Gen. Bus. Posting Group", GBPGValTxt);//PRJ-831.AS.1.0 12OCT2021 Comment old
                             JobRec2.SetFilter("NS_Gen. Bus. Posting Group New", GBPGValTxt);//PRJ-831.AS.1.0 12OCT2021 Add New
                        IF JobRec2.FINDSET THEN begin
                            REPEAT
                                IF JobRec2."No." <> '' THEN
                                    StoreJobNoPercentCompletion += '|' + JobRec2."No.";
                            UNTIL JobRec2.NEXT = 0;
                        end; // Used to store Main Job + Sub Job - end
                        if GETFILTER("NS_Date Filter") <> '' then
                            PercCompRecOuter.SetFilter("NS_Posting Date", GETFILTER("NS_Date Filter"));//ms
                        PercCompRecOuter.SetFilter("NS_Job No.", Job."No." + StoreJobNoPercentCompletion);
                        if PercCompRecOuter.FindSet then begin
                            repeat
                                if (StoreJobNo2 <> PercCompRecOuter."NS_Job No.") then begin
                                    PercCompRecInner.reset;
                                    PercCompRecInner.SetCurrentKey("NS_Entry No");
                                    if GETFILTER("NS_Date Filter") <> '' then
                                        PercCompRecInner.SetFilter("NS_Posting Date", GETFILTER("NS_Date Filter"));//ms
                                    PercCompRecInner.SetRange("NS_Job No.", PercCompRecOuter."NS_Job No.");
                                    if PercCompRecInner.FindLast then begin
                                        ChangePercCompValFinalSubJobAdded += PercCompRecInner."NS_Job Percent Complete";
                                        //PRJCTPR-282.DK.1.0 9April2024 start
                                        //ChangeinPercRecProfValFinalSubJobAded += PercCompRecInner."NS_Recognized Profit";
                                        ChangeinPercRecProfValFinalSubJobAded += PercCompRecInner."NS_Gross Margin";
                                        //changeRecProftPercentageFinalSubJobAdded += PercCompRecInner."NS_Recognized Profit Percent";
                                        changeRecProftPercentageFinalSubJobAdded += PercCompRecInner."NS_Gross Margin Percent";
                                        //PRJCTPR-282.DK.1.0 9April2024 End
                                        if PercCompRecInner."NS_Job Percent Complete" <> 0 then//MS
                                            TotalchangePerCentCompleteCountFinal += 1;


                                        PercCompRec2.Reset;
                                        PercCompRec2.SetCurrentKey("NS_Entry No");
                                        PercCompRec2.SetFilter("NS_Job No.", PercCompRecInner."NS_Job No.");
                                        PercCompRec2.SetFilter("NS_Posting Date", '< %1', PercCompRecInner."NS_Posting Date");
                                        if PercCompRec2.FindLast then begin
                                            ChangePercCompValInitialSubJobAdded += PercCompRec2."NS_Job Percent Complete";
                                            //PRJCTPR-282.DK.1.0 Start
                                            //ChangeinPercRecProfValInitialSubJobAdded += PercCompRec2."NS_Recognized Profit";
                                            ChangeinPercRecProfValInitialSubJobAdded += PercCompRec2."NS_Gross Margin";
                                            //changeRecProftPercentageInitialSubJobAdded += PercCompRec2."NS_Recognized Profit Percent";
                                            changeRecProftPercentageInitialSubJobAdded += PercCompRec2."NS_Gross Margin Percent";
                                            //PRJCTPR-282.DK.1.0 End
                                            if PercCompRec2."NS_Job Percent Complete" <> 0 then//MS
                                                TotalchangePerCentCompleteCountInitial += 1;


                                        end;
                                    end;
                                end;
                                StoreJobNo2 := PercCompRecOuter."NS_Job No.";
                            until PercCompRecOuter.Next = 0;

                            if TotalchangePerCentCompleteCountFinal <> 0 then begin
                                ChangePercCompValFinal := ChangePercCompValFinalSubJobAdded / TotalchangePerCentCompleteCountFinal;
                                changeRecProftPercentageFinal := changeRecProftPercentageFinalSubJobAdded / TotalchangePerCentCompleteCountFinal;
                            end;

                            if TotalchangePerCentCompleteCountInitial <> 0 then begin
                                ChangePercCompValInitial := ChangePercCompValInitialSubJobAdded / TotalchangePerCentCompleteCountInitial;
                                changeRecProftPercentageInitial := changeRecProftPercentageInitialSubJobAdded / TotalchangePerCentCompleteCountInitial;
                            end;

                            // ChangePercCompValToShow := Round(ChangePercCompValFinal - ChangePercCompValInitial, 0.01, '>');
                            ChangePercCompValToShow := Round(ChangePercCompValFinal - ChangePercCompValInitial, JobsetupRec."NS_Forecast Amount Rounding");//PRJ-543.AS.1.0 18FEB2021
                            // ChangeinPercRecProfVal := Round(ChangeinPercRecProfValFinalSubJobAded - ChangeinPercRecProfValInitialSubJobAdded, 0.01, '>');
                            ChangeinPercRecProfVal := Round(ChangeinPercRecProfValFinalSubJobAded - ChangeinPercRecProfValInitialSubJobAdded, JobsetupRec."NS_Forecast Amount Rounding");//PRJ-543.AS.1.0 18FEB2021
                            // changeRecProftPercentage := Round(changeRecProftPercentageFinal - changeRecProftPercentageInitial, 0.01, '>');
                            changeRecProftPercentage := Round(changeRecProftPercentageFinal - changeRecProftPercentageInitial, JobsetupRec."NS_Forecast Amount Rounding");

                        end;

                    end;
                    /// Change % in completion, Recognized Profit, Recognized Profit Percent : In case of Main Job + Subjob //CTSI-115.AS.1.0 - end
                    //*** Change % in completion, Recognized Profit, Recognized Profit Percent New Modified - end ***//
                    //ToPrintRecognizedRevenue := ROUND((ToPrintContract * (ToPrintPercentComplete / 100)), 0.01);//MS
                    // ToPrintRecognizedRevenue := ROUND((ToPrintContract * (JobPctCompleteVal / 100)), 0.01);//MS
                    if ToPrintCostEstimate <> 0 then //PRJ-565
                        ToPrintRecognizedRevenue := Round(((ToPrintContract * ToPrintToDateCost) / ToPrintCostEstimate), JobsetupRec."NS_Forecast Amount Rounding");//PRJ-543.AS.1.0 18FEB2021
                    //Fill in columns on the report
                    A := ToPrintContract;
                    B := ToPrintBillings;
                    C := ToPrintToDateCost;
                    D := ToPrintCostEstimate;
                    E := ToPrintPercentComplete;
                    F := ToPrintRecognizedRevenue;
                    G := F - C;
                    H := 0;
                    if B > F then
                        H := B - F;

                    I := 0;
                    if B < F then
                        I := F - B;


                    //*** Job Percent New Modified - start ***//
                    /// Job Percent Value : In case of Main Job //CTSI-115.AS.1.0 - start
                    if IncludeSubLevelsInMasterJobValues = false then begin
                        PercCompRec.Reset;
                        PercCompRec.SetCurrentKey("NS_Entry No");
                        PercCompRec.SetRange("NS_Job No.", Job."No.");
                        if GETFILTER("NS_Date Filter") <> '' then
                            PercCompRec.setfilter("NS_Posting Date", GETFILTER("NS_Date Filter"));//MS
                        if PercCompRec.FindLast then begin
                            JobPctCompleteVal := PercCompRec."NS_Job Percent Complete";
                        end;
                    end;
                    /// Job Percent value : In case of Main Job //CTSI-115.AS.1.0 - end

                    //*** Job Percent New Modified - start ***//


                    /// Job Percent value : In case of Main Job + Sub Job //CTSI-115.AS.1.0 - start         
                    if IncludeSubLevelsInMasterJobValues = true then begin
                        PercCompRecOuter.reset;
                        PercCompRecOuter.SetCurrentKey("NS_Job No.");
                        if GETFILTER("NS_Date Filter") <> '' then
                            PercCompRecOuter.SetFilter("NS_Posting Date", GETFILTER("NS_Date Filter"));//ms
                        JobRec2.RESET;// Used to store Main Job + Sub Job - start
                        JobRec.SetCurrentKey("No.");
                        JobRec2.SetFilter("NS_Sub-Level to Job No.", Job."No.");
                        JobRec2.SetRange("NS_Exclude from Job Forecast", false);
                        if GBPGValTxt > '' then
                            //JobRec2.SetFilter("NS_Gen. Bus. Posting Group", GBPGValTxt);//PRJ-831.AS.1.0 12OCT2021 Comment old
                            JobRec2.SetFilter("NS_Gen. Bus. Posting Group New", GBPGValTxt);//PRJ-831.AS.1.0 12OCT2021 Add New
                        IF JobRec2.FINDSET THEN begin
                            REPEAT
                                IF JobRec2."No." <> '' THEN
                                    StrorePipelineSubJobs += '|' + JobRec2."No.";
                            UNTIL JobRec2.NEXT = 0;
                        end; // Used to store Main Job + Sub Job - end
                        PercCompRecOuter.SetFilter("NS_Job No.", Job."No." + StrorePipelineSubJobs);
                        if PercCompRecOuter.FindSet then begin
                            repeat
                                if (StoreJobNo <> PercCompRecOuter."NS_Job No.") then begin
                                    PercCompRecInner.reset;
                                    PercCompRecInner.SetCurrentKey("NS_Entry No");
                                    PercCompRecInner.SetRange("NS_Job No.", PercCompRecOuter."NS_Job No.");
                                    if GETFILTER("NS_Date Filter") <> '' then
                                        PercCompRecInner.SetFilter("NS_Posting Date", GETFILTER("NS_Date Filter"));//MS
                                    PercCompRecInner.SetFilter("NS_Gross Margin Percent", '<>%1', 0); //MS
                                    if PercCompRecInner.FindLast then begin
                                        AvgCalcJobPctCompleteVal += PercCompRecInner."NS_Job Percent Complete";
                                        JobPctCount += 1;
                                    end;
                                end;
                                StoreJobNo := PercCompRecOuter."NS_Job No.";
                            until PercCompRecOuter.Next = 0;
                        end;
                        if JobPctCount <> 0 then
                            JobPctCompleteVal := Round(AvgCalcJobPctCompleteVal / JobPctCount, 0.01, '>');
                    end;
                    /// Job Percent value : In case of Main Job + Sub Job //CTSI-115.AS.1.0 - end
                    //*** Job Percent New Modified - end ***//

                    //*** Change % in completion, Recognized Profit, Recognized Profit Percent New Modified - start ***//
                    /// Change % in completion, Recognized Profit, Recognized Profit Percent : In case of Main Job //CTSI-115.AS.1.0 - start
                    if IncludeSubLevelsInMasterJobValues = false then begin
                        PercCompRecOuter.Reset;
                        PercCompRecOuter.SetCurrentKey("NS_Entry No");
                        PercCompRecOuter.SetRange("NS_Job No.", Job."No.");
                        if GETFILTER("NS_Date Filter") <> '' then
                            PercCompRecOuter.SetFilter("NS_Posting Date", GETFILTER("NS_Date Filter"));//MS
                        Totalcount := PercCompRecOuter.Count;

                        if Totalcount > 1 then begin

                            if PercCompRecOuter.FindLast then begin
                                ChangePercCompValFinal := PercCompRecOuter."NS_Job Percent Complete";
                                //PRJCTPR-282.DK.1.0 Start
                                //ChangeinPercRecProfValFinal := PercCompRecOuter."NS_Recognized Profit";
                                ChangeinPercRecProfValFinal := PercCompRecOuter."NS_Gross Margin";
                                // changeRecProftPercentageFinal := PercCompRecOuter."NS_Recognized Profit Percent";
                                changeRecProftPercentageFinal := PercCompRecOuter."NS_Gross Margin Percent";
                                //PRJCTPR-282.DK.1.0 End
                                PercCompRecInner.Reset;
                                PercCompRecInner.SetCurrentKey("NS_Entry No");
                                PercCompRecInner.SetFilter("NS_Job No.", PercCompRecOuter."NS_Job No.");
                                PercCompRecInner.SetFilter("NS_Posting Date", '< %1', PercCompRecOuter."NS_Posting Date");
                                if PercCompRecInner.FindLast then begin
                                    ChangePercCompValInitial := PercCompRecInner."NS_Job Percent Complete";
                                    //PRJCTPR-282.DK.1.0 Start
                                    //ChangeinPercRecProfValInitial := PercCompRecInner."NS_Recognized Profit";
                                    ChangeinPercRecProfValInitial := PercCompRecInner."NS_Gross Margin";
                                    //changeRecProftPercentageInitial := PercCompRecInner."NS_Recognized Profit Percent";
                                    changeRecProftPercentageInitial := PercCompRecInner."NS_Gross Margin Percent";
                                    //PRJCTPR-282.DK.1.0 End
                                end;
                            end;
                            ChangePercCompValToShow := round(ChangePercCompValFinal - ChangePercCompValInitial, 0.01, '>');
                            ChangeinPercRecProfVal := Round(ChangeinPercRecProfValFinal - ChangeinPercRecProfValInitial, 0.01, '>');
                            changeRecProftPercentage := Round(changeRecProftPercentageFinal - changeRecProftPercentageInitial, 0.01, '>');
                        end;

                        if Totalcount = 1 then begin
                            ChangePercCompValToShow := 0;
                            ChangeinPercRecProfVal := 0;
                            changeRecProftPercentage := 0;
                        end;

                    end;
                    /// Change % in completion, Recognized Profit, Recognized Profit Percent : In case of Main Job //CTSI-115.AS.1.0 - end

                    /// Change % in completion, Recognized Profit, Recognized Profit Percent : In case of Main Job + SubJob //CTSI-115.AS.1.0 - start
                    if IncludeSubLevelsInMasterJobValues = true then begin
                        PercCompRecOuter.reset;
                        PercCompRecOuter.SetCurrentKey("NS_Job No.");

                        JobRec2.RESET;// Used to store Main Job + Sub Job - start
                        JobRec.SetCurrentKey("No.");
                        JobRec2.SetFilter("NS_Sub-Level to Job No.", Job."No.");
                        JobRec2.SetRange("NS_Exclude from Job Forecast", false);
                        if GBPGValTxt > '' then
                            //JobRec2.SetFilter("NS_Gen. Bus. Posting Group", GBPGValTxt);//PRJ-831.AS.1.0 12OCT2021 Comment old
                              JobRec2.SetFilter("NS_Gen. Bus. Posting Group New", GBPGValTxt);//PRJ-831.AS.1.0 12OCT2021 Add New
                        IF JobRec2.FINDSET THEN begin
                            REPEAT
                                IF JobRec2."No." <> '' THEN
                                    StoreJobNoPercentCompletion += '|' + JobRec2."No.";
                            UNTIL JobRec2.NEXT = 0;
                        end; // Used to store Main Job + Sub Job - end
                        if GETFILTER("NS_Date Filter") <> '' then
                            PercCompRecOuter.SetFilter("NS_Posting Date", GETFILTER("NS_Date Filter"));//ms
                        PercCompRecOuter.SetFilter("NS_Job No.", Job."No." + StoreJobNoPercentCompletion);
                        if PercCompRecOuter.FindSet then begin
                            repeat
                                if (StoreJobNo2 <> PercCompRecOuter."NS_Job No.") then begin
                                    PercCompRecInner.reset;
                                    PercCompRecInner.SetCurrentKey("NS_Entry No");
                                    if GETFILTER("NS_Date Filter") <> '' then
                                        PercCompRecInner.SetFilter("NS_Posting Date", GETFILTER("NS_Date Filter"));//ms
                                    PercCompRecInner.SetRange("NS_Job No.", PercCompRecOuter."NS_Job No.");
                                    if PercCompRecInner.FindLast then begin
                                        ChangePercCompValFinalSubJobAdded += PercCompRecInner."NS_Job Percent Complete";
                                        //PRJCTPR-282.DK.1.0 Start
                                        //ChangeinPercRecProfValFinalSubJobAded += PercCompRecInner."NS_Recognized Profit";
                                        ChangeinPercRecProfValFinalSubJobAded += PercCompRecInner."NS_Gross Margin";
                                        //changeRecProftPercentageFinalSubJobAdded += PercCompRecInner."NS_Recognized Profit Percent";
                                        changeRecProftPercentageFinalSubJobAdded += PercCompRecInner."NS_Gross Margin Percent";
                                        //PRJCTPR-282.DK.1.0 End
                                        if PercCompRecInner."NS_Job Percent Complete" <> 0 then//MS
                                            TotalchangePerCentCompleteCountFinal += 1;


                                        PercCompRec2.Reset;
                                        PercCompRec2.SetCurrentKey("NS_Entry No");
                                        PercCompRec2.SetFilter("NS_Job No.", PercCompRecInner."NS_Job No.");
                                        PercCompRec2.SetFilter("NS_Posting Date", '< %1', PercCompRecInner."NS_Posting Date");
                                        if PercCompRec2.FindLast then begin
                                            ChangePercCompValInitialSubJobAdded += PercCompRec2."NS_Job Percent Complete";
                                            //PRJCTPR-282.DK.1.0 Start
                                            //ChangeinPercRecProfValInitialSubJobAdded += PercCompRec2."NS_Recognized Profit";
                                            ChangeinPercRecProfValInitialSubJobAdded += PercCompRec2."NS_Gross Margin";
                                            //changeRecProftPercentageInitialSubJobAdded += PercCompRec2."NS_Recognized Profit Percent";
                                            changeRecProftPercentageInitialSubJobAdded += PercCompRec2."NS_Gross Margin Percent";
                                            //PRJCTPR-282.DK.1.0 End
                                            if PercCompRec2."NS_Job Percent Complete" <> 0 then//MS
                                                TotalchangePerCentCompleteCountInitial += 1;

                                        end;
                                    end;
                                end;
                                StoreJobNo2 := PercCompRecOuter."NS_Job No.";
                            until PercCompRecOuter.Next = 0;

                            if TotalchangePerCentCompleteCountFinal <> 0 then begin
                                ChangePercCompValFinal := ChangePercCompValFinalSubJobAdded / TotalchangePerCentCompleteCountFinal;
                                changeRecProftPercentageFinal := changeRecProftPercentageFinalSubJobAdded / TotalchangePerCentCompleteCountFinal;
                            end;

                            if TotalchangePerCentCompleteCountInitial <> 0 then begin
                                ChangePercCompValInitial := ChangePercCompValInitialSubJobAdded / TotalchangePerCentCompleteCountInitial;
                                changeRecProftPercentageInitial := changeRecProftPercentageInitialSubJobAdded / TotalchangePerCentCompleteCountInitial;
                            end;

                            ChangePercCompValToShow := Round(ChangePercCompValFinal - ChangePercCompValInitial, 0.01, '>');
                            ChangeinPercRecProfVal := Round(ChangeinPercRecProfValFinalSubJobAded - ChangeinPercRecProfValInitialSubJobAdded, 0.01, '>');
                            changeRecProftPercentage := Round(changeRecProftPercentageFinal - changeRecProftPercentageInitial, 0.01, '>');

                        end;

                    end;
                    /// Change % in completion, Recognized Profit, Recognized Profit Percent : In case of Main Job + Subjob //CTSI-115.AS.1.0 - end
                    //*** Change % in completion, Recognized Profit, Recognized Profit Percent New Modified - end ***//

                end;

                trigger OnPreDataItem();
                begin
                    //PRJ-1454.NK.1.0 20Sep2022 Start
                    if JobNo <> '' then
                        Job.SetRange("No.", JobNo);
                    if ((StartDate <> 0D) and (EndDate <> 0D)) then
                        Job.SetFilter("NS_Date Filter", '%1..%2', StartDate, EndDate);
                    //PRJ-1454.NK.1.0 20Sep2022 End
                    //CTSI-121.N.S.1.0 18Aug2020 Start
                    if ManagerValue <> '' then
                        Job.SetRange(NS_Manager, ManagerValue);
                    if ResponsiblePerson <> '' then
                        Job.SetRange("Person Responsible", ResponsiblePerson);
                    //CTSI-121.N.S.1.0 18Aug2020 end;
                    JobFilters := Job;
                    JobFilters.COPYFILTERS(Job);
                    "MarkSub-Levels"(Job, IncludeSubLevelsInMasterJobValues);
                    COPYFILTERS(JobFilters);

                    // CurrReport.CREATETOTALS(A, B, C, D, E, F, G, H, I);//PRJCTPR-101.NC.1.0 25Apr2023 Block

                    JobRecRef.OPEN(167);        //Job
                end;
            }
            dataitem(ReportSummary; "Integer")
            {
                DataItemLinkReference = Job;
                DataItemTableView = SORTING(Number) ORDER(Ascending);
                column(FinalSummaryA_Number_; FinalSummaryA[Number])
                {
                }
                column(FinalSummaryB_Number_; FinalSummaryB[Number])
                {
                }
                column(FinalSummaryC_Number_; FinalSummaryC[Number])
                {
                }
                column(FinalSummaryD_Number_; FinalSummaryD[Number])
                {
                }
                column(FinalSummaryF_Number_; FinalSummaryF[Number])
                {
                }
                column(FinalSummaryG_Number_; FinalSummaryG[Number])
                {
                }
                column(FinalSummaryGlobalDim1_Number_; FinalSummaryGlobalDim1[Number])
                {
                }
                column(FinalSummaryH_Number_; FinalSummaryH[Number])
                {
                }
                column(FinalSummaryI_Number_; FinalSummaryI[Number])
                {
                }
                column(Report_SummaryCaption; Report_SummaryCaptionLbl)
                {
                }
                column(ReportSummary_Number; Number)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    if FinalCurrentPointer = -1 then begin
                        CurrReport.BREAK;
                    end;

                    if FinalSummaryGlobalDim1[Number] = '' then
                        FinalSummaryGlobalDim1[Number] := Text001;
                end;

                trigger OnPreDataItem();
                begin
                    FinalCurrentPointer := -1;

                    if not ShowReportSummary then
                        CurrReport.SKIP;

                    if FinalTopPointer > 0 then begin
                        SETRANGE(Number, 1, FinalTopPointer);
                        FinalCurrentPointer := 1;
                    end else
                        CurrReport.SKIP;
                end;
            }
        }
    }

    requestpage
    {
        //SaveValues = true;//CTSI-115.AS.1.0 
        layout
        {
            area(content)
            {
                //SMPL - Caption = 'RequestPage';
                group(Options)
                {
                    field(IncludeSubLevelsInMasterJobValues; IncludeSubLevelsInMasterJobValues)
                    {
                        Caption = 'Include Sub-Level Values In Master Job Values';
                        ApplicationArea = All;
                    }
                    field(DoNotShowSubLevels; DoNotShowSubLevels)
                    {
                        Caption = 'Do Not Show Sub-Levels';
                        ApplicationArea = All;
                        Visible = false;
                    }
                    field(UseEnteredPercentComplete; UseEnteredPercentComplete)
                    {
                        Caption = 'Use Entered % Complete';
                        ApplicationArea = All;
                    }
                    field(UseJobForecastWorksheet; UseJobForecastWorksheet)
                    {
                        Caption = 'Use Job Forecast Worksheet';
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            if UseJobForecastWorksheet then begin
                                ExcludeMarkedCostEntries := false;
                                ExcludeMarkedPriceEntries := false;
                                ExcludeMarkedCostEntriesEdit := false;
                                ExcludeMarkedPriceEntriesEdit := false;
                            end else begin
                                ExcludeMarkedCostEntriesEdit := true;
                                ExcludeMarkedPriceEntriesEdit := true;
                            end;
                        end;
                    }
                    field(ExcludeMarkedCostEntries; ExcludeMarkedCostEntries)
                    {
                        Caption = 'Exclude Marked Cost Entries';
                        Enabled = ExcludeMarkedCostEntriesEdit;
                        Importance = Standard;
                        ApplicationArea = All;
                    }
                    field(ExcludeMarkedPriceEntries; ExcludeMarkedPriceEntries)
                    {
                        Caption = 'Exclude Marked Price Entries';
                        Enabled = ExcludeMarkedPriceEntriesEdit;
                        ApplicationArea = All;
                    }
                    field(ShowJobSummaries; ShowJobSummaries)
                    {
                        Caption = 'Show Job Summaries';
                        ApplicationArea = All;
                    }
                    field(ShowReportSummary; ShowReportSummary)
                    {
                        Caption = 'Show Report Summary';
                        ApplicationArea = All;
                    }
                    //CTSI-121.N.S.1.0 18Aug2020 Start
                    field(ManagerValue; ManagerValue)
                    {
                        Caption = 'Manager';
                        ApplicationArea = all;
                        TableRelation = Resource WHERE(Type = FILTER(Person));//PRJ-422.AM.1.0 
                        Visible = false;//PRJ-422.AM.2.0 

                    }
                    field(ResponsiblePerson; ResponsiblePerson)
                    {
                        Caption = 'Person Responsible';
                        ApplicationArea = all;
                        TableRelation = Resource WHERE(Type = FILTER(Person));//PRJ-422.AM.1.0
                        Visible = false;//PRJ-422.AM.2.0 

                    }
                    //CTSI-121.N.S.1.0 18Aug2020 Start
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            if UseJobForecastWorksheet then begin
                ExcludeMarkedCostEntries := false;
                ExcludeMarkedPriceEntries := false;
                ExcludeMarkedCostEntriesEdit := false;
                ExcludeMarkedPriceEntriesEdit := false;
            end else begin
                ExcludeMarkedCostEntriesEdit := true;
                ExcludeMarkedPriceEntriesEdit := true;
            end;


        end;
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        UseJobForecastWorksheet := true;
        IncludeSubLevelsInMasterJobValues := true;//CTSI-115.AS.1.0
    end;

    trigger OnPreReport();
    var
        JobsSetup: Record "Jobs Setup"; //PRJ-1571.NK.1.0 25Aug2022
        ApoSetup: Record NS_APOSetup; //PRJ-1571.NK.1.0 25Aug2022
    begin
        CompanyInformation.GET;
        CompanyInformation.CalcFields(Picture);//PE-141.AS.1.0 16AUG2023

        //PE-141.AS.1.0 start 24Aug2023
        if CompanyInformation.Address = '' then
            NS_CompanyInformationAdd := ''
        else
            NS_CompanyInformationAdd := CompanyInformation.Address;
        if CompanyInformation."Address 2" = '' then
            NS_CompanyInformationadd2 := ''
        else
            NS_CompanyInformationadd2 := CompanyInformation."Address 2";

        if CompanyInformation.City = '' then
            NS_CompanyInformationcity := ''
        else
            NS_CompanyInformationcity := CompanyInformation.City + ',' + ' ';
        if CompanyInformation.County = '' then
            NS_CompanyInformationCountry := ''
        else
            NS_CompanyInformationCountry := CompanyInformation.County + ' ';
        if CompanyInformation."Post Code" = '' then
            NS_CompanyInformationpost := ''
        else
            NS_CompanyInformationpost := CompanyInformation."Post Code";
        NS_CompanyFullAddress := NS_CompanyInformationcity + NS_CompanyInformationCountry + NS_CompanyInformationpost;

        //PE-141.AS.1.0 start 24Aug2023

        DateFilter := Job.GetFilter("NS_Date Filter"); //PRJ-1554.NK.1.0 25Jan2023
        //CTSI-115.AS.1.0 25Aug2020 - start
        JobsetupRec.Get;
        Clear(GBPGValTxt);
        GBPGValTxt := JobsetupRec."NS_GBPG for Job Forecast";
        //CTSI-115.AS.1.0 25Aug2020 - end
        //CTSI-121.N.S.1.0 19Aug2020 start Filter value print
        if (ManagerValue <> '') and (ResponsiblePerson <> '') then
            JobFilter := 'Manager:' + ManagerValue + ':Person Responsible:' + ResponsiblePerson + ':' + Job.GETFILTERS
        else
            if (ManagerValue <> '') and (ResponsiblePerson = '') then
                JobFilter := 'Manager:' + ManagerValue + ':' + Job.GETFILTERS
            else
                if (ManagerValue = '') and (ResponsiblePerson <> '') then
                    JobFilter := 'Person Responsible:' + ResponsiblePerson + ':' + Job.GETFILTERS
                else
                    if (ManagerValue = '') and (ResponsiblePerson = '') then
                        JobFilter := Job.GETFILTERS;
        //CTSI-121.N.S.1.0 19Aug2020 start Filtervalue print
        // JobFilter := Job.GETFILTERS;CTSI-121.N.S.1.0 19Aug2020 comment
        //PRJ-1571.NK.1.0 25Aug2022 Start
        if JobsSetup.Get() then; //PRJ-1348.NK.1.0 08Sep2022
        if ApoSetup.Get() then; //PRJ-1348.NK.1.0 08Sep2022
        if JobsSetup."NS_Activate Task Pick List" then begin
            TextActivity := ApoSetup."Activity Code" + ' Filter';
            TextProcess := ApoSetup."Process Code" + ' Filter';
            TextOperation := ApoSetup."Operation Code" + ' Filter';
        end else begin
            TextActivity := 'Activity Filter';
            TextProcess := 'Process Filter';
            TextOperation := 'Operation Filter';
        end;
        JobFilter := ReplaceString(JobFilter, 'Activity Filter', TextActivity);
        JobFilter := ReplaceString(JobFilter, 'Process Filter', TextProcess);
        JobFilter := ReplaceString(JobFilter, 'Operation Filter', TextOperation);
        //PRJ-1571.NK.1.0 25Aug2022 End
        if IncludeSubLevelsInMasterJobValues then
            "Sub-LevelsText" := Text003
        else
            "Sub-LevelsText" := Text002;

        if UseEnteredPercentComplete then
            CompletePercentText := Text004
        else
            CompletePercentText := Text005;

        if ExcludeMarkedCostEntries then
            MarkedCostEntriesExcluded := Text006;

        if ExcludeMarkedPriceEntries then
            MarkedPriceEntriesExcluded := Text007;

        if UseJobForecastWorksheet then
            WorksheetText := Text008
        else
            WorksheetText := Text009;
    end;

    var
        CompanyInformation: Record "Company Information";
        //PE-141.AS.1.0 start 24Aug2023 
        NS_CompanyInformationAdd: Text[250];
        NS_CompanyInformationadd2: Text[250];
        NS_CompanyInformationcity: Text;
        NS_CompanyInformationRegion: Code[20];
        NS_CompanyInformationpost: Code[20];
        NS_CompanyInformationCountry: Text[250];
        NS_CompanyFullAddress: Text[250];
        //PE-141.AS.1.0 24Aug2023 
        StoreJobNoPercentCompletion: text;//CTSI-115.AS.1.0 25Aug2020
        StoreJobNo2: code[20]; //CTSI-115.AS.1.0 25Aug2020
        Totalcount: integer;//CTSI-115.AS.1.0 25Aug2020
        TotalchangePerCentCompleteCountFinal: integer;//CTSI-115.AS.1.0 25Aug2020
        TotalchangePerCentCompleteCountInitial: Decimal;//CTSI-115.AS.1.0 25Aug2020
        JobFilters: Record Job;
        PrintCostEstimateSummDetails: Decimal;//PRJ-585.AS.1.0
        RecProjSummDtl: Record "NS_Percentage of Completion";//PRJ-585.AS.1.0
        SLPrintCostEstimateSummDetails: Decimal;//PRJ-585.AS.1.0
        SLJobs: Record Job;//PRJ-585.AS.1.0
        DateGetted: text;//PRJ-585.AS.1.0
        DateVarStore: Date;//PRJ-585.AS.1.0
        GBPGValTxt: Text;//CTSI-115.AS.1.0 25Aug2020
        JobsetupRec: Record "Jobs Setup";//CTSI-115.AS.1.0 25Aug2020
        JobRec: Record Job;//CTSI-94.AS.1.0 10AUG2020
        JobRec2: Record job; //CTSI-94.AS.1.0 10AUG2020
        StrorePipelineSubJobs: Text;//CTSI-94.AS.1.0 10AUG2020
        changeRecProftPercentage: Decimal;//CTSI-94.AS.1.0 10AUG2020
        changeRecProftPercentageFinal: Decimal;//CTSI-94.AS.1.0 10AUG2020
        changeRecProftPercentageInitial: Decimal;//CTSI-94.AS.1.0 10AUG2020
        PercCompRecOuter: Record "NS_Percentage of Completion";//CTSI-115.AS.1.0
        PercCompRecInner: Record "NS_Percentage of Completion";//CTSI-115.AS.1.0
        StoreJobNo: Code[20];//CTSI-115.AS.1.0
        PercCompRec: Record "NS_Percentage of Completion";//CTSI-94.AS.1.0 10AUG2020
        PercCompRec2: Record "NS_Percentage of Completion";//CTSI-94.AS.1.0 10AUG2020
        JobPctCompleteVal: Decimal;//CTSI-94.AS.1.0 10AUG2020
        AvgCalcJobPctCompleteVal: Decimal;//CTSI-115.AS.1.0
        AvgCalcRevenueProfitPercent: Decimal;//CTSI-115.AS.1.0
        JobPctCount: Decimal;//CTSI-115.AS.1.0

        ChangePercentCompletionCountFinal: integer;//CTSI-115.AS.1.0   
        ChangePercentCompletionCountInitial: integer;//CTSI-115.AS.1.0
        FinalPercentval: Decimal;//CTSI-115.AS.1.0
        InitialPercentVal: Decimal;//CTSI-115.AS.1.0
        ChangePercCompValInitial: Decimal;//CTSI-94.AS.1.0 10AUG2020
        ChangePercCompValInitialSubJobAdded: Decimal;//CTSI-115.AS.1.0 
        ChangePercCompValFinalSubJobAdded: Decimal;//CTSI-115.AS.1.0

        ChangeinPercRecProfValFinalSubJobAded: Decimal;//CTSI-115.AS.1.0
        ChangeinPercRecProfValInitialSubJobAdded: Decimal;//CTSI-115.AS.1.0
        changeRecProftPercentageFinalSubJobAdded: Decimal;//CTSI-115.AS.1.0
        changeRecProftPercentageInitialSubJobAdded: Decimal;//CTSI-115.AS.1.0
        ChangeRecProfVal: Decimal;//CTSI-94.AS.1.0 10AUG2020
        ChangeinPercRecProfVal: Decimal;//CTSI-94.AS.1.0 10AUG2020
        ChangeinPercRecProfValFinal: Decimal;//CTSI-94.AS.1.0 10AUG2020
        ChangeinPercRecProfValInitial: Decimal;//CTSI-94.AS.1.0 10AUG2020
        ChangePercCompValFinal: Decimal; //CTSI-94.AS.1.0 10AUG2020
        ChangePercCompValToShow: Decimal;//CTSI-94.AS.1.0 10AUG2020
        JobLedgEntry: Record "Job Ledger Entry";
        JobForecast: Record "NS_Job Forecast";
        JobRecRef: RecordRef;
        JobFilter: Text[250];
        ToPrintPercentComplete: Decimal;
        ToPrintRecognizedRevenue: Decimal;
        ToPrintContract: Decimal;
        ToPrintToDateCost: Decimal;
        ToPrintBillings: Decimal;
        ToPrintCostEstimate: Decimal;
        PercentType: Text[1];
        SLsToPrintContract: Decimal;
        SLsToPrintToDateCost: Decimal;
        SLsToPrintBillings: Decimal;
        SLsToPrintCostEstimate: Decimal;
        SLsPercentType: Text[1];
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
        Text001: Label '[Blank]';
        Text002: Label 'Sub-Level values are not included in master job values';
        Text003: Label 'Sub-Level values are included in master job values';
        Text004: Label 'Percent Completion used';
        Text005: Label 'Percent Completion not used';
        Text006: Label 'Marked cost entries are excluded from the report';
        Text007: Label 'Marked price entries are excluded from the report';
        Text008: Label 'Forecast Worksheet used';
        Text009: Label 'Forecast Worksheet not used';
        WorksheetCode: Label 'W';
        ManualCode: Label 'M';
        CalculatedCode: Label 'C';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Report_NameLbl: Label 'Percentage of Completion Report';
        Job_No_CaptionLbl: Label 'Job No.';
        Contract_PriceCaptionLbl: Label 'Contract Price';
        To_Date_BillingsCaptionLbl: Label 'To Date Billings';
        To_Date_CostCaptionLbl: Label 'To Date Cost';
        Total_Cost_EstimateCaptionLbl: Label 'Total Cost Estimate';
        Percent_CompletionCaptionLbl: Label 'Pct Done';
        Recognized_RevenueCaptionLbl: Label 'Recognized Revenue';
        Recognized_Profit_LossCaptionLbl: Label 'Recognized Profit (Loss)';
        Over_BillingsCaptionLbl: Label 'Over Billings';
        Under_BillingsCaptionLbl: Label 'Under Billings';
        Job__No__CaptionLbl: Label 'Job No.';
        TotalsCaptionLbl: Label 'Totals';
        Report_SummaryCaptionLbl: Label 'Report Summary';
        ManagerValue: Code[20];//CTSI-121.N.S.1.0 18Aug2020;
        ResponsiblePerson: Code[20];//CTSI-121.N.S.1.0 18Aug2020;
        TextActivity: Text; //PRJ-1571.NK.1.0 25Aug2022 
        TextProcess: Text; //PRJ-1571.NK.1.0 25Aug2022 
        TextOperation: Text; //PRJ-1571.NK.1.0 25Aug2022   
        StartDate: date;//PRJ-1554.NK.1.0 20Sep2022 
        EndDate: Date;//PRJ-1554.NK.1.0 20Sep2022 
        JobNo: Code[20];//PRJ-1554.NK.1.0 20Sep2022     
        DateFilter: Text; //PRJ-1554.NK.1.0 25Jan2023
        ChginperCompl: Label 'Change % in Completion';//PRJCTPR-282.DK.1.0 4April2024

    procedure FindUsageCost(Job: Record Job) Usage: Decimal;
    begin
        Usage := 0;
        with Job do begin
            Job.COPYFILTERS(JobFilters);
            JobLedgEntry.RESET;
            JobLedgEntry.SETCURRENTKEY("Job No.", "Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                       "NS_Job Cost Category", "NS_Job Revenue Category", Type, "No.", "Resource Group No.", "Posting Date");
            JobLedgEntry.SETRANGE("Job No.", "No.");
            JobLedgEntry.SETRANGE("Entry Type", JobLedgEntry."Entry Type"::Usage);
            JobLedgEntry.SETFILTER("NS_Activity Code", GETFILTER("NS_Activity Filter"));
            JobLedgEntry.SETFILTER("NS_Process Code", GETFILTER("NS_Process Filter"));
            JobLedgEntry.SETFILTER("NS_Operation Code", GETFILTER("NS_Operation Filter"));
            JobLedgEntry.SETFILTER("NS_Job Cost Category", GETFILTER("NS_Cost Category Filter"));
            JobLedgEntry.SETFILTER("Posting Date", GETFILTER("NS_Date Filter"));
            if ExcludeMarkedCostEntries then
                JobLedgEntry.SETRANGE("NS_Exclude Entry", not ExcludeMarkedCostEntries);
            if JobLedgEntry.FINDSET then
                repeat
                    Usage := Usage + JobLedgEntry."Total Cost (LCY)";
                    if ShowJobSummaries then
                        SortIntoJob(0, JobLedgEntry."Total Cost");
                    if ShowReportSummary then
                        SortIntoFinal(0, JobLedgEntry."Total Cost");
                until JobLedgEntry.NEXT = 0;
        end;
    end;

    procedure FindInvoicedPrice(Job: Record Job) Price: Decimal;
    begin
        Price := 0;
        with Job do begin
            Job.COPYFILTERS(JobFilters);
            JobLedgEntry.RESET;
            JobLedgEntry.SETCURRENTKEY("Job No.", "Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                       "NS_Job Cost Category", "NS_Job Revenue Category", Type, "No.", "Resource Group No.", "Posting Date");
            JobLedgEntry.SETRANGE("Job No.", "No.");
            JobLedgEntry.SETRANGE("Entry Type", JobLedgEntry."Entry Type"::Sale);
            JobLedgEntry.SETFILTER("NS_Activity Code", GETFILTER("NS_Activity Filter"));
            JobLedgEntry.SETFILTER("NS_Process Code", GETFILTER("NS_Process Filter"));
            JobLedgEntry.SETFILTER("NS_Operation Code", GETFILTER("NS_Operation Filter"));
            JobLedgEntry.SETFILTER("NS_Job Revenue Category", GETFILTER("NS_Revenue Category Filter"));
            JobLedgEntry.SETFILTER("Posting Date", GETFILTER("NS_Date Filter"));
            if ExcludeMarkedPriceEntries then
                JobLedgEntry.SETRANGE("NS_Exclude Entry", not ExcludeMarkedPriceEntries);
            if JobLedgEntry.FINDSET then
                repeat
                    Price := Price - JobLedgEntry."Total Price (LCY)";
                    if ShowJobSummaries then
                        SortIntoJob(-JobLedgEntry."Total Price", 0);
                    if ShowReportSummary then
                        SortIntoFinal(-JobLedgEntry."Total Price", 0);
                until JobLedgEntry.NEXT = 0;
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

    procedure ForecastedCompletedCost(Job: Record Job; Worksheet: Boolean; Manual: Boolean; var BudgetedPrice: Decimal; var ActualCost: Decimal; var ActualBillings: Decimal; var CostEstimate: Decimal; var Source: Text[1]);
    var
        JobSetup: Record "Jobs Setup"; //PRJ-1454.NK.1.0 28Jun2022
    begin
        with Job do begin
            Job.COPYFILTERS(JobFilters);

            //Get budget values
            Job.COPYFILTER("NS_Date Filter", Job."Posting Date Filter");
            Job.CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");
            //PRJ-1454.NK.1.0 28Jun2022 Start
            JobSetup.Get();
            if JobSetup."NS_Enab. Budg.on Contract Date" then
                BudgetedPrice := FindContDaseBaseAmt(Job)
            else
                //PRJ-1454.NK.1.0 28Jun2022 End
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
                        CostEstimate := JobForecast.ForecastedCompletedAmt(2, Job."No.", '', Job.GETFILTER("NS_Date Filter"));
                        //CostEstimate := JobForecast.ForeCostAtCompFromWorksheet(Job."No.",'',Job.GETFILTER("Date Filter"));
                        Source := WorksheetCode;
                        if Manual and  // If Manual percent is available AND
                           (CostEstimate = 0) and  // the Cost To Complete Worksheet did not yield a value AND
                           (Job."NS_Actual Percent Complete" > 0) and  // there is an "Actual Percent Complete" entered on the Job Card AND
                           (ActualCost > 0) and  // there is a "To Date Cost" to work with
                           DateInRange(Job."NS_Actual PercentCompleteDate",
                                       GETFILTER("NS_Date Filter"))    // the "Actual Percent Complete Date" is within any entered date filter
                           then begin
                            CostEstimate := ROUND((ActualCost * 100) / Job."NS_Actual Percent Complete", 0.01);
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
                              GETFILTER("NS_Date Filter")):
                    begin
                        CostEstimate := ROUND((ActualCost * 100) / Job."NS_Actual Percent Complete", 0.01);
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
    end;

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
        with JobSearch do begin
            JobSearch.COPYFILTERS(JobFilters);
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            //CTSI-115.AS.1.0 25Aug2020 -start
            SetRange("NS_Exclude from Job Forecast", false);
            if GBPGValTxt > '' then
                //SetFilter("NS_Gen. Bus. Posting Group", GBPGValTxt);//PRJ-831.AS.1.0 12OCT2021 Comment old
            SetFilter("NS_Gen. Bus. Posting Group New", GBPGValTxt);//PRJ-831.AS.1.0 12OCT2021 Add New
            //CTSI-115.AS.1.0 25Aug2020 -end
            if FINDSET then
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
                until NEXT = 0;
        end;
    end;

    //PRJ-1454.NK.1.0 28Jun2022 Start
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
        //PE-308.DK.1.0 13JUNE2024 Start
        //JobPlannLine.SETFILTER(Type, Job.GetFilter("NS_Type Filter"));
        JobPlannLine.SETFILTER(Type, Job.GetFilter("NS_TypeEnumFilter"));
        //PE-308.DK.1.0 13JUNE2024 END
        if Job.GetFilter("Posting Date Filter") <> '' then //PRJ-1554.NK.1.0 20Sep2022 
            JobPlannLine.SETFILTER("NS_Contract Forecast Date", Job.GetFilter("Posting Date Filter"));
        if DateFilter <> '' then //PRJ-1554.NK.1.0 20Sep2022 
            JobPlannLine.SETFILTER("NS_Contract Forecast Date", DateFilter); //PRJ-1554.NK.1.0 20Sep2022 
        if ((StartDate <> 0D) And (EndDate <> 0D) and (DateFilter = '')) then //PRJ-1554.NK.1.0 20Sep2022 
            JobPlannLine.SETFILTER("NS_Contract Forecast Date", '%1..%2', StartDate, EndDate); //PRJ-1554.NK.1.0 20Sep2022 
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

    procedure SetPar(JobValue: code[20]; FromDate: date; ToDate: date);
    begin
        JobNo := JobValue;
        StartDate := FromDate;
        Enddate := todate;
    end;
    //PRJ-1454.NK.1.0 28Jun2022 End
    //PRJ-1571.NK.1.0 25Aug2022 Start
    procedure ReplaceString(OldString: Text; FindWhat: Text; ReplaceWith: Text) NewString: Text;
    var
        FindPos: Integer;
    begin
        FindPos := STRPOS(OldString, FindWhat);
        WHILE FindPos > 0 DO BEGIN
            NewString += DELSTR(OldString, FindPos) + ReplaceWith;
            OldString := COPYSTR(OldString, FindPos + STRLEN(FindWhat));
            FindPos := STRPOS(OldString, FindWhat);
        END;
        NewString += OldString;
    end;
    //PRJ-1571.NK.1.0 25Aug2022 End
}

