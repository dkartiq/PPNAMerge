report 14021170 "NS_POC Gross Margin"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-84.SK.1.0 Added report to search
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSPOC Gross Margin.rdl';

    Caption = 'Percentage of Completion With Gross Margin';
    EnableHyperlinks = true;
    UsageCategory = ReportsAndAnalysis;
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
            column(JobLocationLbl; JobLocationLbl)
            {
            }
            column(CustomerAccountNameLbl; CustomerAccountNameLbl)
            {
            }
            column(JobDescriptionLbl; JobDescriptionLbl)
            {
            }
            dataitem(Job; Job)
            {
                DataItemTableView = SORTING("No.");
                RequestFilterFields = "No.", "Bill-to Customer No.", "NS_Date Filter", Status, "NS_Activity Filter", "NS_Process Filter", "NS_Operation Filter";
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
                    JobRecRef.SETPOSITION(Job.GETPOSITION);

                    if DoNotShowSubLevels and ("NS_Sub-Level to Job No." > '') then
                        CurrReport.SKIP;

                    JobFilters := Job;
                    JobFilters.COPYFILTERS(Job);

                    ForecastedCompletedCost(Job,
                                            ToPrintContract,
                                            ToPrintToDateCost,
                                            ToPrintBillings,
                                            ToPrintCostEstimate);

                    if IncludeSubLevelsInMasterJobValues then begin
                        SLsForecastedCompletedCost(Job,
                                                   SLsToPrintContract,
                                                   SLsToPrintToDateCost,
                                                   SLsToPrintBillings,
                                                   SLsToPrintCostEstimate,
                                                   SLsPercentType);

                        ToPrintContract := ToPrintContract + SLsToPrintContract;
                        ToPrintToDateCost := ToPrintToDateCost + SLsToPrintToDateCost;
                        ToPrintBillings := ToPrintBillings + SLsToPrintBillings;
                        ToPrintCostEstimate := ToPrintCostEstimate + SLsToPrintCostEstimate;
                    end;

                    //Calculate ToPrintPercentComplete
                    ToPrintPercentComplete := 0;
                    if ToPrintCostEstimate <> 0 then
                        ToPrintPercentComplete := ROUND(100 - ((ToPrintCostEstimate - ToPrintToDateCost) / ToPrintCostEstimate) * 100, 0.01);
                    if ToPrintPercentComplete > 100 then
                        ToPrintPercentComplete := 100;

                    //Calculate ToPrintRecognizedRevenue
                    ToPrintRecognizedRevenue := ROUND((ToPrintContract * (ToPrintPercentComplete / 100)), 0.01);

                    //Calculate PreviousGrossMarginToDate
                    PreviousToDateCost := 0;
                    PreviousForecastedCompletedCost(Job, PreviousToDateCost, PreviousPeriod);

                    if IncludeSubLevelsInMasterJobValues then begin
                        PreviousSLsForecastedCompletedCost(Job,
                                                           SLsToPrintToDateCost,
                                                           PreviousPeriod);
                        PreviousToDateCost := PreviousToDateCost + SLsToPrintToDateCost;
                    end;

                    PreviousRecognizedRevenueToDate := 0;
                    PreviousGrossMarginToDate := 0;
                    if PreviousToDateCost <> 0 then begin
                        if ToPrintCostEstimate <> 0 then
                            PreviousPctDone := ROUND(100 - ((ToPrintCostEstimate - ToPrintRecognizedRevenuePrev) / ToPrintCostEstimate) * 100, 0.01);
                        PreviousRecognizedRevenueToDate := ROUND(ToPrintContract * PreviousPctDone / 100, 0.01);
                        PreviousGrossMarginToDate := PreviousRecognizedRevenueToDate - PreviousToDateCost;
                    end;

                    //Fill in columns on the report
                    A := ToPrintContract;
                    B := ToPrintBillings;
                    C := ToPrintToDateCost;
                    D := ToPrintCostEstimate;
                    E := ToPrintPercentComplete;
                    F := ToPrintRecognizedRevenue;
                    G := F - C;
                    H := 0;
                    if F <> 0 then
                        H := 100 * G / F;
                    I := G - PreviousGrossMarginToDate;
                end;

                trigger OnPreDataItem();
                begin
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
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            //ExcludeMarkedCostEntries := FALSE;
            //ExcludeMarkedPriceEntries := FALSE;
            //ExcludeMarkedCostEntriesEdit := FALSE;
            //ExcludeMarkedPriceEntriesEdit := FALSE;
        end;
    }

    labels
    {
    }

    trigger OnPreReport();
    var
        Pos: Integer;
    begin
        CompanyInformation.GET;
        JobFilter := Job.GETFILTERS;

        DateFilter := Job.GETFILTER("NS_Date Filter");
        Pos := STRPOS(DateFilter, '..');
        if DateFilter = '' then
            ReportDate := TODAY
        else
            if (Pos < 2) then
                ReportDate := Job.GETRANGEMAX("NS_Date Filter")
            else
                if Pos = STRLEN(DateFilter) - 1 then
                    ReportDate := Job.GETRANGEMIN("NS_Date Filter")
                else
                    ReportDate := Job.GETRANGEMAX("NS_Date Filter");
        PreviousPeriod := '..' + FORMAT(CALCDATE('CM-1M', ReportDate));

        if IncludeSubLevelsInMasterJobValues then
            "Sub-LevelsText" := Text003
        else
            "Sub-LevelsText" := Text002;

        CompletePercentText := Text005;

        WorksheetText := Text008
    end;

    var
        CompanyInformation: Record "Company Information";
        JobFilters: Record Job;
        JobLedgEntry: Record "Job Ledger Entry";
        CompletionStatus: Record "NS_Job Forecast";
        JobRecRef: RecordRef;
        JobFilter: Text[250];
        ToPrintPercentComplete: Decimal;
        ToPrintRecognizedRevenue: Decimal;
        ToPrintContract: Decimal;
        ToPrintToDateCost: Decimal;
        ToPrintBillings: Decimal;
        ToPrintCostEstimate: Decimal;
        PreviousToDateCost: Decimal;
        PreviousPctDone: Decimal;
        PreviousRecognizedRevenueToDate: Decimal;
        PreviousGrossMarginToDate: Decimal;
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
        ShowJobSummaries: Boolean;
        ShowReportSummary: Boolean;
        "Sub-LevelsText": Text[60];
        CompletePercentText: Text[50];
        IncludeAdjustmentsText: Text[50];
        WorksheetText: Text[50];
        ReportDate: Date;
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
        TempSummaryB: Decimal;
        TempSummaryC: Decimal;
        Text001: Label '[Blank]';
        Text002: Label 'Sub-Level values are not included in master job values';
        Text003: Label 'Sub-Level values are included in master job values';
        Text005: Label 'Percent Completion not used';
        Text008: Label 'Forecast Worksheet used';
        WorksheetCode: Label 'W';
        ManualCode: Label 'M';
        CalculatedCode: Label 'C';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Report_NameLbl: Label 'Percent of Completion with Gross Margin';
        Job_No_CaptionLbl: Label 'Job No.';
        Contract_PriceCaptionLbl: Label 'Contract Price';
        To_Date_BillingsCaptionLbl: Label 'To Date Billings';
        To_Date_CostCaptionLbl: Label 'To Date Cost';
        Total_Cost_EstimateCaptionLbl: Label 'Total Cost Estimate';
        Percent_CompletionCaptionLbl: Label 'Pct Done';
        Recognized_RevenueCaptionLbl: Label 'Recognized Revenue To Date';
        Recognized_Profit_LossCaptionLbl: Label 'Gross Margin To Date';
        Over_BillingsCaptionLbl: Label 'Gross Margin Pct';
        Under_BillingsCaptionLbl: Label 'Gross Margin Current Period';
        TotalsCaptionLbl: Label 'Totals';
        Report_SummaryCaptionLbl: Label 'Report Summary';
        [InDataSet]
        CustomerAccountName: Text[50];
        Contact: Record Contact;
        JobLocationLbl: Label 'Job Location';
        CustomerAccountNameLbl: Label 'Customer Account Name';
        JobDescriptionLbl: Label 'Description';
        NS_JobLedgerEntry: Record "Job Ledger Entry";
        DateFilter: Text;
        PreviousPeriod: Text;
        ToPrintRecognizedRevenuePrev: Decimal;

    procedure FindUsageCost(Job: Record Job; PostingDateFilter: Text[30]) Usage: Decimal;
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
            JobLedgEntry.SETFILTER("Posting Date", PostingDateFilter);
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
            //  IF ExcludeMarkedPriceEntries THEN
            //    JobLedgEntry.SETRANGE("Exclude Entry",NOT ExcludeMarkedPriceEntries);
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

    procedure "SLsUsage(Cost)"(var ParentJob: Record Job) Answer: Decimal;
    var
        JobSearch: Record Job;
    begin
        Answer := 0;
        with JobSearch do begin
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            if FINDSET then
                repeat
                    SETFILTER("NS_Date Filter", ParentJob.GETFILTER("NS_Date Filter"));
                    SETFILTER("NS_Cost Category Filter", ParentJob.GETFILTER("NS_Cost Category Filter"));
                    CALCFIELDS("NS_Usage (Cost) (LCY)");
                    Answer := Answer + "NS_Usage (Cost) (LCY)" + "SLsUsage(Cost)"(JobSearch);
                until NEXT = 0;
        end;
    end;

    procedure SLsInvoicedPrice(var ParentJob: Record Job) Answer: Decimal;
    var
        JobSearch: Record Job;
    begin
        Answer := 0;
        with JobSearch do begin
            RESET();
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            SETFILTER("NS_Type Filter", '<>%1', NS_JobLedgerEntry.Type::NS_Ledger);
            SETFILTER("NS_Date Filter", ParentJob.GETFILTER("NS_Date Filter"));
            SETFILTER("NS_Revenue Category Filter", ParentJob.GETFILTER("NS_Revenue Category Filter"));
            if FINDSET() then
                repeat
                    CALCFIELDS("NS_Invoiced Price (LCY)");
                    Answer := Answer + "NS_Invoiced Price (LCY)" + SLsInvoicedPrice(JobSearch);
                until NEXT() = 0;
        end;
    end;

    procedure ForecastedCompletedCost(Job: Record Job; var BudgetedPrice: Decimal; var ActualCost: Decimal; var ActualBillings: Decimal; var CostEstimate: Decimal);
    begin
        with Job do begin
            Job.COPYFILTERS(JobFilters);

            //Get budget values
            CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");
            BudgetedPrice := "NS_Budgeted Price (LCY)";

            //Get actual values
            ActualCost := FindUsageCost(Job, GETFILTER("NS_Date Filter"));
            ActualBillings := FindInvoicedPrice(Job);

            //Get the percent complete from the Cost to Complete Worksheet
            //  CostEstimate := CompletionStatus.ForeCostAtCompFromWorksheet(Job."No.",'',GETFILTER("Date Filter"));
            CostEstimate := CompletionStatus.ForecastedCompletedAmt(2, Job."No.", '', GETFILTER("NS_Date Filter"));
        end;
    end;

    procedure SLsForecastedCompletedCost(ParentJob: Record Job; var BudgetedPrice: Decimal; var ActualCost: Decimal; var ActualBillings: Decimal; var CostEstimate: Decimal; var PercentType: Text[1]);
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
            if FINDSET then
                repeat
                    PercentTypeHold := PercentType;
                    ForecastedCompletedCost(JobSearch,
                                            ProjectedToPrintContract,
                                            ProjectedToPrintToDateCost,
                                            ProjectedToPrintBillings,
                                            ProjectedToPrintTotalCostEst);
                    PercentType := PercentTypeOverride(PercentTypeHold, PercentType);
                    PercentTypeHold := PercentType;
                    SLsForecastedCompletedCost(JobSearch,
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

    procedure PreviousForecastedCompletedCost(Job: Record Job; var ActualCost: Decimal; PreviousDate: Text);
    begin
        with Job do begin
            Job.COPYFILTERS(JobFilters);

            //Get budget values
            SETFILTER("NS_Date Filter", PreviousDate);

            //Get actual values
            ActualCost := FindUsageCost(Job, PreviousDate);
            ToPrintRecognizedRevenuePrev := ActualCost;
        end;

        exit;
    end;

    procedure PreviousSLsForecastedCompletedCost(ParentJob: Record Job; var ActualCost: Decimal; PreviousDate: Text);
    var
        JobSearch: Record Job;
        PreviousActualCost: Decimal;
        SLsPreviousActualCost: Decimal;
        xProjectedToPrintContract: Decimal;
        xProjectedToPrintToDateCost: Decimal;
        xProjectedToPrintBillings: Decimal;
        xProjectedToPrintTotalCostEst: Decimal;
        xSLsProjectedToPrintContract: Decimal;
        xSLsProjectedToPrintToDateCost: Decimal;
        xSLsProjectedToPrintBillings: Decimal;
        xSLsProjectedToPrintTotalCostEs: Decimal;
        xPercentTypeHold: Text[1];
    begin
        //Find the Project Cost at Completion using the Completion Status Worksheet going down all
        //  sublevels from the ParentJob passed in.

        ActualCost := 0;
        with JobSearch do begin
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            SETFILTER("NS_Date Filter", PreviousDate);
            if FINDSET then
                repeat
                    PreviousForecastedCompletedCost(JobSearch,
                                                    PreviousActualCost,
                                                    PreviousDate);
                    PreviousSLsForecastedCompletedCost(JobSearch,
                                                       SLsPreviousActualCost,
                                                       PreviousDate);
                    ActualCost := ActualCost + PreviousActualCost + SLsPreviousActualCost;
                until NEXT = 0;
        end;
    end;
}

