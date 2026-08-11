report 14021179 "NS_Percentage of Completion"
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
    //CTSI-121.N.S.1.0 18aug2020 Add filter manager & person Responsible
    //PRJ-422.AM.1.0 22OCT2020 | Added a new column and modified Table Relation of Manager & Person responsible.
    //PRJ-422.AM.2.0 28OCT2020 | Added Manager & Person Responsible Fields in RequestFilterFields and set visibility of Manager & person responsible variable on request page false.
    //CTSI-202.AM.1.0 16NOV2020 | Added 1 more filter Gen.bus posting Group in requestFilterfields.
    //CTSI-202.AM.1.0 16NOV2020 | Added code to display sub level jobs data in main line of Master Job & Added GBPG linking with Gen.Bus posting group.
    //CTSI-220.MS.1.0 added new req.filter of glob dim 2 and save value
    //PRJ-831.AS.1.0 12OCT2021 Replaced Job Table field Gen Bus Posting Grp with Gen Bus Posting Grp New
    //PRJ-1018.JS.1.0  26Oct2021  | Inilize Variable
    //PRJ-1056.JS.1.0 24Nov2021 | Change code for To Date Estimated value
    //PRJ-1454.NK.1.0 06Jul2022 | Added Code
    //PE-141.AS.1.0 16AUG2023 Done change in layout to Add comp logo, user id, timedate, page
    //PE-123.Nk.1.0 01Sep2023 | in layout added Backlog column
    //PE-317 AT.1.0 25June2024 | Change in layout
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSPercentage of Completion.rdl';
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Percentage of Completion';
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
            dataitem(Job; Job)
            {
                DataItemTableView = SORTING("No.");
                //RequestFilterFields = "No.", "Bill-to Customer No.", "NS_Date Filter", Status, "NS_Activity Filter", "NS_Process Filter", "NS_Operation Filter";
                RequestFilterFields = "No.", NS_Manager, "Person Responsible", "NS_Gen. Bus. Posting Group New", "Bill-to Customer No.", "NS_Date Filter", Status, "NS_Activity Filter", "NS_Process Filter", "NS_Operation Filter", "Global Dimension 2 Code";//PRJ-422.AM.2.0 //CTSI-202.AM.1.0 Added 1 more field //CTSI-220.MS.1.0//PRJ-831.AS.1.0 12OCT2021
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

                    JobSetupRecord.Get();//PRJ-585.AS.2.0 12APRIL2021
                    Clear(ToPrintRecognizedRevenue);//TEST                    
                    //CTSI-202.AM.1.0 - start
                    if JobRec.Get(Job."No.") then begin
                        if (IncludeSubLevelsInMasterJobValues = true) and (JobRec."NS_Sub-Level to Job No." > '') then //CTSI-285.MS.1.0 add rev rec 
                            CurrReport.skip;
                    end;
                    //CTSI-202.AM.1.0 - end

                    //PRJ-1544.AS.1.0 start Comment
                    // if ("NS_Revenue Recognized" = true) then
                    //     CurrReport.skip;
                    //PRJ-1544.AS.1.0 end Comment

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

                        //PRJ-585.AS.2.0 12APRIL2021 -start
                        JobTable.Reset();
                        JobTable.SetRange("No.", Job."No.");
                        JobTable.SetRange("NS_Sub-Level to Job No.", '');
                        JobTable.SetRange("NS_Exclude from Job Forecast", false);
                        if JobTable.FindFirst() then begin
                            //PRJ-585.AS.2.0 12APRIL2021 - end .. Putted these conditions in begin end
                            RecProjSummDtl.Reset();
                            RecProjSummDtl.SetCurrentKey("NS_Job No.", "NS_Posting Date");
                            //RecProjSummDtl.SetRange("NS_Job No.", Job."No.");//PRJ-585.AS.2.0 12APRIL2021 old codde comment
                            RecProjSummDtl.SetRange("NS_Job No.", JobTable."No.");
                            //if DateVarStore <> 0D then //PRJ-658.AS.1.0 10MAY2021
                            RecProjSummDtl.SetFilter("NS_Posting Date", GetFilter("NS_Date Filter"));
                            if RecProjSummDtl.FindLast() then
                                PrintCostEstimateSummDetails := RecProjSummDtl."NS_TotalForecastCompletedCost";
                        end
                        ELSE
                            PrintCostEstimateSummDetails := 0;//PRJ-585.AS.2.0 12APRIL2021
                        //PRJ-585.AS.2.0 12APRIL2021 ..end
                    end;

                    //if (UseJobForecastWorksheet = true) and (PrintCostEstimateSummDetails <> 0) then begin
                    //    ToPrintCostEstimate := PrintCostEstimateSummDetails;
                    //end;
                    //if (UseJobForecastWorksheet = true) and (PrintCostEstimateSummDetails = 0) then begin
                    //    ToPrintCostEstimate := ToPrintCostEstimate;
                    //     Message('Out');
                    //end;
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
                            SLJobs.SetFilter(Status, Job.GetFilter(Status));//PRJ-1544.AS.1.0 Add code 12AUG2022
                            if JobSetupRecord."NS_GBPG for Job Forecast" > '' then//PRJ-585.AS.2.0 12APRIL2021
                                                                                  //SLJobs.SetFilter("NS_Gen. Bus. Posting Group", JobsetupRec."NS_GBPG for Job Forecast");//PRJ-585.AS.2.0 12APRIL2021 //PRJ-831.AS.1.0 12OCT2021 Comment old
                                SLJobs.SetFilter("NS_Gen. Bus. Posting Group New", JobsetupRec."NS_GBPG for Job Forecast");//PRJ-585.AS.2.0 12APRIL2021 //PRJ-831.AS.1.0 12OCT2021 Add New
                            SLJobs.SetRange("NS_Exclude from Job Forecast", false);//PRJ-585.AS.2.0 12APRIL2021
                            IF SLJobs.FINDSET THEN
                                REPEAT
                                    RecProjSummDtl.Reset();
                                    RecProjSummDtl.SetCurrentKey("NS_Job No.", "NS_Posting Date");
                                    RecProjSummDtl.SetRange("NS_Job No.", SLJobs."No.");
                                    //if DateVarStore <> 0D then //PRJ-658.AS.1.0 10MAY2021
                                    RecProjSummDtl.SetFilter("NS_Posting Date", GetFilter("NS_Date Filter"));
                                    if RecProjSummDtl.FindLast() then
                                        SLPrintCostEstimateSummDetails += RecProjSummDtl.NS_TotalForecastCompletedCost;
                                UNTIL SLJobs.NEXT = 0;


                            // if (UseJobForecastWorksheet = true) and (SLPrintCostEstimateSummDetails <> 0) then begin
                            //     SLsToPrintCostEstimate := SLPrintCostEstimateSummDetails;
                            // end;
                            // if (UseJobForecastWorksheet = true) and (SLPrintCostEstimateSummDetails = 0) then begin
                            //     SLsToPrintCostEstimate := SLsToPrintCostEstimate
                            // end;
                        END;
                        //PRJ-585.AS.1.0 - end

                        ToPrintContract := ToPrintContract + SLsToPrintContract;
                        ToPrintToDateCost := ToPrintToDateCost + SLsToPrintToDateCost;
                        ToPrintBillings := ToPrintBillings + SLsToPrintBillings;
                        //ToPrintCostEstimate := ToPrintCostEstimate + SLsToPrintCostEstimate;   //PRJ-1018.JS.1.0 27Oct2021 line commented
                        ToPrintCostEstimate := ToPrintCostEstimate;      //PRJ-1018.JS.1.0 27Oct2021 new line added
                        if (PrintCostEstimateSummDetails <> 0) or (SLPrintCostEstimateSummDetails <> 0) then
                            ToPrintCostEstimate := PrintCostEstimateSummDetails + SLPrintCostEstimateSummDetails
                        else
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

                    // ToPrintPercentComplete := ROUND(ToPrintPercentComplete, 0.01);//PRJ-543.AS.1.0 Comment
                    ToPrintPercentComplete := ROUND(ToPrintPercentComplete, JobsetupRec."NS_Forecast Amount Rounding");//PRJ-543.AS.1.0 Add
                    if ToPrintPercentComplete > 100 then
                        ToPrintPercentComplete := 100;

                    //ToPrintRecognizedRevenue := ROUND((TomrintContract * (ToPrintPercentComplete / 100)), 0.01);//PRJ-543.AS.1.0 Comment

                    //PRJ-588.AS.1.0 03MAY2021 - START COMMENT
                    /* if ToPrintCostEstimate <> 0 then //PRJ-565
                         ToPrintRecognizedRevenue := Round(((ToPrintContract * ToPrintToDateCost) / ToPrintCostEstimate), JobsetupRec."Forecast Amount Rounding");//PRJ-543.AS.1.0 Add */
                    //PRJ-588.AS.1.0 03MAY2021 - END COMMENT

                    ToPrintRecognizedRevenue := ROUND((ToprintContract * (ToPrintPercentComplete / 100)), JobsetupRec."NS_Forecast Amount Rounding");//PRJ-543.AS.1.0 Comment

                    //Fill in columns on the report
                    A := ToPrintContract;
                    B := ToPrintBillings;
                    C := ToPrintToDateCost;
                    D := ToPrintCostEstimate;
                    E := ToPrintPercentComplete;
                    F := ToPrintRecognizedRevenue;
                    //CTSI-284.MS.1.0 start
                    DateFilter := GetFilter("NS_Date Filter");
                    if DateFilter > '' then
                        MaxDate := GetRangeMax("NS_Date Filter");
                    if (Job."NS_Actual PercentCompleteDate" <= MaxDate) or (DateFilter = '') then
                        if (UseJobForecastWorksheet = true) and (Job."NS_Actual Percent Complete" = 100) and (Job."NS_Actual PercentCompleteDate" <> 0D) then begin
                            E := 100;
                            D := (C / E) * 100;
                        end else begin

                        end;
                    //CTSI-284.MS.1.0 end
                    G := F - C;
                    H := 0;
                    if B > F then
                        H := B - F;

                    I := 0;
                    if B < F then
                        I := F - B;
                end;

                trigger OnPreDataItem();
                begin
                    //CTSI-121.N.S.1.0 18Aug2020 Start
                    if ManagerValue <> '' then
                        Job.SetRange(NS_Manager, ManagerValue);
                    if ResponsiblePerson <> '' then
                        Job.SetRange("Person Responsible", ResponsiblePerson);
                    Job.SetRange("NS_Exclude from Job Forecast", false);//PRJ-585.AS.2.0
                    //CTSI-121.N.S.1.0 18Aug2020 end;
                    JobFilters := Job;
                    JobFilters.COPYFILTERS(Job);
                    "MarkSub-Levels"(Job, IncludeSubLevelsInMasterJobValues);
                    COPYFILTERS(JobFilters);

                    CurrReport.CREATETOTALS(A, B, C, D, E, F, G, H, I);

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
        SaveValues = true;//CTSI-220.MS.1.0
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
                        Visible = false; //CTSI-202.AM.1.0
                    }
                    field(UseEnteredPercentComplete; UseEnteredPercentComplete)
                    {
                        Caption = 'Use Entered % Complete';
                        ApplicationArea = All;
                        Visible = false; //CTSI-284.MS.1.0
                    }
                    field(UseJobForecastWorksheet; UseJobForecastWorksheet)
                    {
                        Caption = 'Use Job Forecast Worksheet';
                        ToolTip = 'Check this boolean if you want to see the Job Forecast Worksheet calculations in the report'; //PRJCTPR-127.DK.1.0 24june2023
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
                        Visible = false; //CTSI-284.MS.1.0
                    }
                    field(ExcludeMarkedPriceEntries; ExcludeMarkedPriceEntries)
                    {
                        Caption = 'Exclude Marked Price Entries';
                        Enabled = ExcludeMarkedPriceEntriesEdit;
                        ApplicationArea = All;
                        Visible = false; //CTSI-284.MS.1.0
                    }
                    field(ShowJobSummaries; ShowJobSummaries)
                    {
                        Caption = 'Show Job Summaries';
                        ToolTip = 'If this boolean is checked then a summary of Job will be shown in the report';//PRJCTPR-127.DK.1.0 24june2023
                        ApplicationArea = All;
                    }
                    field(ShowReportSummary; ShowReportSummary)
                    {
                        Caption = 'Show Report Summary';
                        ToolTip = 'If this boolean is checked then a summary of Job will be shown on the basis of a Pie Chart'; //PRJCTPR-127.DK.1.0 24june2023
                        ApplicationArea = All;
                    }
                    //CTSI-121.N.S.1.0 18Aug2020 Start
                    field(ManagerValue; ManagerValue)
                    {
                        Caption = 'Manager';
                        ApplicationArea = all;
                        //TableRelation = Resource;//PRJ-422.AM.1.0  Comment
                        TableRelation = Resource WHERE(Type = FILTER(Person));//PRJ-422.AM.1.0 
                        Visible = false;//PRJ-422.AM.2.0 

                    }
                    field(ResponsiblePerson; ResponsiblePerson)
                    {
                        Caption = 'Person Responsible';
                        ApplicationArea = all;
                        //TableRelation = Resource;//PRJ-422.AM.1.0  Comment
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
        IncludeSubLevelsInMasterJobValues := true;//CTSI-202.AM.1.0 
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

        //CTSI-202.AM.1.0 Start
        JobsetupRec.Get;
        Clear(GBPGValTxt);
        GBPGValTxt := JobsetupRec."NS_GBPG for Job Forecast";
        //CTSI-202.AM.1.0 End
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
        //CTSI-121.N.S.1.0 19Aug2020 start Filtervalue print
        // JobFilter := Job.GETFILTERS;CTSI-121.N.S.1.0 19Aug2020 comment

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
        JobTable: Record Job;//PRJ-585.AS.2.0 12APRIL2021
        JobSetupRecord: Record "Jobs Setup";//PRJ-585.AS.2.0 12APRIL2021
        PrintCostEstimateSummDetails: Decimal;//PRJ-585.AS.1.0
        RecProjSummDtl: Record "NS_Percentage of Completion";//PRJ-585.AS.1.0
        DateGetted: text;//PRJ-585.AS.1.0
        DateVarStore: Date;//PRJ-585.AS.1.0
        SLPrintCostEstimateSummDetails: Decimal;//PRJ-585.AS.1.0
        SLJobs: Record Job;//PRJ-585.AS.1.0
        JobFilters: Record Job;
        Jobrec: Record Job;//CTSI-202.AM.1.0 
        JobLedgEntry: Record "Job Ledger Entry";
        JobForecast: Record "NS_Job Forecast";
        JobsetupRec: Record "Jobs Setup";//CTSI-202.AM.1.0 
        JobRecRef: RecordRef;
        GBPGValTxt: Text;//CTSI-202.AM.1.0 
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
        DateFilter: text;//CTSI-284;
        MaxDate: Date;//CTSI-284;
        TextActivity: Text; //PRJ-1571.NK.1.0 25Aug2022 
        TextProcess: Text; //PRJ-1571.NK.1.0 25Aug2022 
        TextOperation: Text; //PRJ-1571.NK.1.0 25Aug2022        

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
        JobSetup: Record "Jobs Setup"; //PRJ-1454.NK.1.0 06Jul2022
    begin
        with Job do begin
            Job.COPYFILTERS(JobFilters);

            //Get budget values
            Job.COPYFILTER("NS_Date Filter", Job."Posting Date Filter");
            Job.CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");
            //PRJ-1454.NK.1.0 06Jul2022 Start
            JobSetup.Get();
            if JobSetup."NS_Enab. Budg.on Contract Date" then
                BudgetedPrice := FindContDaseBaseAmt(Job)
            else
                //PRJ-1454.NK.1.0 06Jul2022 End
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
        SLsProjectedToPrintTotalCostEs := 0;  //PRJ-1018.JS.1.0  26Oct2021
        ProjectedToPrintTotalCostEst := 0; //PRJ-1018.JS.1.0  26Oct2021
        with JobSearch do begin
            JobSearch.COPYFILTERS(JobFilters);
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            SetFilter(Status, Job.GetFilter(Status));//PRJ-1544.AS.1.0 Add code 12AUG2022
            //CTSI-202.AM.1.0 start
            SetRange("NS_Exclude from Job Forecast", false);
            if GBPGValTxt > '' then
                //SetFilter("NS_Gen. Bus. Posting Group", GBPGValTxt);//PRJ-831.AS.1.0 12OCT2021 Comment old
                SetFilter("NS_Gen. Bus. Posting Group New", GBPGValTxt);//PRJ-831.AS.1.0 12OCT2021 Add New
            //CTSI-202.AM.1.0 end
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

    //PRJ-1454.NK.1.0 06Jul2022 Start
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
    //PRJ-1454.NK.1.0 06Jul2022 End

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