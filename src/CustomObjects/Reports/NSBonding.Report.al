report 14021181 NS_Bonding
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
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSBonding.rdl';
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Bonding';
    ApplicationArea = all;

    dataset
    {
        dataitem(Job; Job)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Bill-to Customer No.", "NS_Date Filter", Status, "NS_Adjustment Filter";
            column(Bonding_ReportCaption; Bonding_ReportCaptionLbl)
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(MarkedCostEntriesExcluded; MarkedCostEntriesExcluded)
            {
            }
            column(MarkedPriceEntriesExcluded; MarkedPriceEntriesExcluded)
            {
            }
            column(Sub_LevelsText_; "Sub-LevelsText")
            {
            }
            column(CompletePercentText; CompletePercentText)
            {
            }
            column(Job_TABLECAPTION_____Filters______JobFilter; Job.TABLECAPTION + ' Filters: ' + JobFilter)
            {
            }
            column(Job__No__; "No.")
            {
            }
            column(Job__No__Caption; Job__No__CaptionLbl)
            {
            }
            column(Completion__Caption; Completion__CaptionLbl)
            {
            }
            column(Contract_AmountCaption; Contract_AmountCaptionLbl)
            {
            }
            column(Estim__Profit__Loss_Caption; Estim__Profit__Loss_CaptionLbl)
            {
            }
            column(Revenues_EarnedCaption; Revenues_EarnedCaptionLbl)
            {
            }
            column(Total_Costs_IncurredCaption; Total_Costs_IncurredCaptionLbl)
            {
            }
            column(Gross_ProfitCaption; Gross_ProfitCaptionLbl)
            {
            }
            column(Billed_to_DateCaption; Billed_to_DateCaptionLbl)
            {
            }
            column(Estimated_Cost_to_CompleteCaption; Estimated_Cost_to_CompleteCaptionLbl)
            {
            }
            column(Costs_in_Excess_of_BillingsCaption; Costs_in_Excess_of_BillingsCaptionLbl)
            {
            }
            column(Billings_in_Excess_of_EarningsCaption; Billings_in_Excess_of_EarningsCaptionLbl)
            {
            }
            column(ACaption; ACaptionLbl)
            {
            }
            column(BCaption; BCaptionLbl)
            {
            }
            column(CCaption; CCaptionLbl)
            {
            }
            column(DCaption; DCaptionLbl)
            {
            }
            column(ECaption; ECaptionLbl)
            {
            }
            column(FCaption; FCaptionLbl)
            {
            }
            column(GCaption; GCaptionLbl)
            {
            }
            column(HCaption; HCaptionLbl)
            {
            }
            column(ICaption; ICaptionLbl)
            {
            }
            column(JCaption; JCaptionLbl)
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
            column(J; J)
            {
            }
            column(K; K)
            {
            }
            column(TotalsCaption; TotalsCaptionLbl)
            {
            }
            column(CALCULATION_METHODSCaption; CALCULATION_METHODSCaptionLbl)
            {
            }
            column(A_DescriptionCaption; A_CaptionLbl)
            {
            }
            column(B_DescriptionCaption; B_CaptionLbl)
            {
            }
            column(C_DescriptionCaption; C_CaptionLbl)
            {
            }
            column(D_DescriptionCaption; D_CaptionLbl)
            {
            }
            column(E_DescriptionCaption; E_CaptionLbl)
            {
            }
            column(F_DescriptionCaption; F_CaptionLbl)
            {
            }
            column(G_DescriptionCaption; G_CaptionLbl)
            {
            }
            column(H_DescriptionCaption; H_CaptionLbl)
            {
            }
            column(I_DescriptionCaption; I_CaptionLbl)
            {
            }
            column(J_DescriptionCaption; J_CaptionLbl)
            {
            }

            trigger OnAfterGetRecord();
            begin
                if not "ShowSub-Levels" and ("NS_Sub-Level to Job No." > '') then
                    CurrReport.SKIP;

                CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");
                CALCFIELDS("NS_Usage (Cost) (LCY)", "NS_Invoiced Price (LCY)");

                ForecastedCompletedCost(Job, UseJobForecastWorksheet, UseEnteredPercentComplete,
                                        ToPrintBudgetPrice,
                                        ToPrintCost,
                                        ToPrintPrice,
                                        ToPrintCostEstimate,
                                        PercentType);

                if "IncludeSub-Levels" then begin
                    SLsForecastedCompletedCost(Job, UseJobForecastWorksheet, UseEnteredPercentComplete,
                                               SLsTotalToPrintBudgetPrice,
                                               SLsTotalToPrintCost,
                                               SLsTotalToPrintPrice,
                                               SLsTotalToPrintCostEstimate,
                                               SLsPercentType);
                    ToPrintBudgetPrice := ToPrintBudgetPrice + SLsTotalToPrintBudgetPrice;
                    ToPrintCost := ToPrintCost + SLsTotalToPrintCost;
                    ToPrintPrice := ToPrintPrice + SLsTotalToPrintPrice;
                    ToPrintCostEstimate := ToPrintCostEstimate + SLsTotalToPrintCostEstimate;
                end;

                CALCFIELDS("NS_Locked Planning Lines Exist");
                if "NS_Locked Planning Lines Exist" then begin
                    CALCFIELDS("NS_Locked Budget Cost (LCY)");
                    ToPrintCostEstimate := "NS_Locked Budget Cost (LCY)";
                    ToPrintCostEstimate := ToPrintCostEstimate + Job.NS_SLsBudgetedCost(Job);
                end;

                //Get A either from Job card or from pre-calculated values
                if UseJobForecastWorksheet then
                    if ToPrintCostEstimate <> 0 then
                        A := 100 - ((ToPrintCostEstimate - ToPrintCost) / ToPrintCostEstimate) * 100;

                if (A = 0) and UseEnteredPercentComplete then
                    if Job."NS_Actual Percent Complete" > 0 then
                        A := Job."NS_Actual Percent Complete";

                if (A = 0) or ((UseJobForecastWorksheet = false) and (UseEnteredPercentComplete = false)) then
                    if ToPrintCostEstimate <> 0 then
                        A := 100 - ((ToPrintCostEstimate - ToPrintCost) / ToPrintCostEstimate) * 100;

                A := ROUND(A, 0.01);
                if A > 100 then
                    A := 100;

                B := ToPrintBudgetPrice;
                C := ToPrintBudgetPrice - ToPrintCostEstimate;
                D := (A / 100) * B;
                E := ToPrintCost;
                F := D - E;
                G := ToPrintPrice;
                H := ToPrintCostEstimate - E;

                I := 0;
                if D > G then
                    I := D - G;

                J := 0;
                if D < G then
                    J := G - D;
            end;

            trigger OnPreDataItem();
            begin
                JobFilters := Job;
                JobFilters.COPYFILTERS(Job);
                "MarkSub-Levels"(Job, "IncludeSub-Levels");
                COPYFILTERS(JobFilters);
                CurrReport.CREATETOTALS(A, B, C, D, E, F, G, H, I, J);
                CurrReport.CREATETOTALS(K);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                //SMPL - Caption = 'RequestPage';
                group(Options)
                {
                    field("Include Sub-Levels"; "IncludeSub-Levels")
                    {
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            if not "IncludeSub-Levels" then
                                "ShowSub-Levels" := false;
                        end;
                    }
                    field("Show Sub-Levels"; "ShowSub-Levels")
                    {
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            if "ShowSub-Levels" then
                                "IncludeSub-Levels" := true;
                        end;
                    }
                    field("Use Entered % Complete"; UseEnteredPercentComplete)
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
                    field("Exclude Marked Cost Entries"; ExcludeMarkedCostEntries)
                    {
                        Caption = 'Exclude Marked Cost Entries';
                        Enabled = ExcludeMarkedCostEntriesEdit;
                        ApplicationArea = All;
                    }
                    field("Exclude Marked Price Entries"; ExcludeMarkedPriceEntries)
                    {
                        Caption = 'Exlude Marked Price Entries';
                        Enabled = ExcludeMarkedPriceEntriesEdit;
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport();
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

    trigger OnPreReport();
    begin
        CompanyInformation.GET;
        JobFilter := Job.GETFILTERS;

        if "IncludeSub-Levels" then
            "Sub-LevelsText" := Text001
        else
            "Sub-LevelsText" := Text002;

        if not UseEnteredPercentComplete then
            CompletePercentText := Text003
        else
            CompletePercentText := Text004;

        if ExcludeMarkedCostEntries then
            MarkedCostEntriesExcluded := Text005;

        if ExcludeMarkedPriceEntries then
            MarkedPriceEntriesExcluded := Text006;
    end;

    var
        CompanyInformation: Record "Company Information";
        TempJobPlanningLine: Record "Job Planning Line" temporary;
        JobLedgEntry: Record "Job Ledger Entry";
        JobPlanningLine: Record "Job Planning Line";
        JobFilters: Record Job;
        JobForecast: Record "NS_Job Forecast";
        JobFilter: Text[250];
        TotalEstimateProfitPrice: Decimal;
        TotalEstimateProfitCost: Decimal;
        ToPrintBudgetPrice: Decimal;
        ToPrintCost: Decimal;
        ToPrintPrice: Decimal;
        ToPrintCostEstimate: Decimal;
        PercentType: Text[1];
        SLsTotalToPrintBudgetPrice: Decimal;
        SLsTotalToPrintCost: Decimal;
        SLsTotalToPrintPrice: Decimal;
        SLsTotalToPrintCostEstimate: Decimal;
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
        J: Decimal;
        K: Decimal;
        "IncludeSub-Levels": Boolean;
        "ShowSub-Levels": Boolean;
        "Sub-LevelsText": Text[50];
        UseEnteredPercentComplete: Boolean;
        UseJobForecastWorksheet: Boolean;
        ExcludeMarkedCostEntries: Boolean;
        ExcludeMarkedPriceEntries: Boolean;
        [InDataSet]
        ExcludeMarkedCostEntriesEdit: Boolean;
        [InDataSet]
        ExcludeMarkedPriceEntriesEdit: Boolean;
        IncludeBudgetAdjustments: Boolean;
        CompletePercentText: Text[50];
        MarkedCostEntriesExcluded: Text[50];
        MarkedPriceEntriesExcluded: Text[50];
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Bonding_ReportCaptionLbl: Label 'Bonding Report';
        Estimated_Cost_to_CompleteCaptionLbl: Label 'Estimated Cost to Complete';
        Billed_to_DateCaptionLbl: Label 'Billed to Date';
        Gross_ProfitCaptionLbl: Label 'Gross Profit';
        Cost_of_RevenuesCaptionLbl: Label 'Cost of Revenues';
        Job__No__CaptionLbl: Label 'Job No.';
        Contract_AmountCaptionLbl: Label 'Contract Amount';
        Completion__CaptionLbl: Label 'Completion %';
        Estim__Profit__Loss_CaptionLbl: Label 'Estim. Profit (Loss)';
        Revenues_EarnedCaptionLbl: Label 'Revenues Earned';
        Total_Costs_IncurredCaptionLbl: Label 'Total Costs Incurred';
        Costs_in_Excess_of_BillingsCaptionLbl: Label 'Costs in Excess of Billings';
        Billings_in_Excess_of_EarningsCaptionLbl: Label 'Billings in Excess of Earnings';
        ACaptionLbl: Label 'A';
        BCaptionLbl: Label 'B';
        CCaptionLbl: Label 'C';
        DCaptionLbl: Label 'D';
        ECaptionLbl: Label 'E';
        FCaptionLbl: Label 'F';
        GCaptionLbl: Label 'G';
        HCaptionLbl: Label 'H';
        ICaptionLbl: Label 'I';
        JCaptionLbl: Label 'J';
        TotalsCaptionLbl: Label 'Totals';
        CALCULATION_METHODSCaptionLbl: Label 'CALCULATION METHODS';
        A_CaptionLbl: Label 'A = % Complete (Cost-to-date / Total Budgeted Cost)';
        B_CaptionLbl: Label 'B = Contract Amount';
        C_CaptionLbl: Label 'C = Contract Amount - Total Budgeted Cost';
        D_CaptionLbl: Label 'D = Revenues Earned';
        E_CaptionLbl: Label 'E = Total Costs Incurred';
        F_CaptionLbl: Label 'F = D - E';
        G_CaptionLbl: Label 'G = Billings-to-Date';
        H_CaptionLbl: Label 'H = Total Budgeted Cost - F (Gross Profit)';
        I_CaptionLbl: Label 'I = D - G when D > G';
        J_CaptionLbl: Label 'J = G - D when D < G';
        WorksheetCode: Label 'W';
        ManualCode: Label 'M';
        CalculatedCode: Label 'C';
        Text001: Label 'Sub-Levels are included in Jobs';
        Text002: Label 'Sub-Levels are not included in Jobs';
        Text003: Label 'Percent Completion Calculated';
        Text004: Label 'Percent Completion Entered';
        Text005: Label 'Marked Cost entries are excluded from the report';
        Text006: Label 'Marked Price entries are excluded from the report';

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
                until JobLedgEntry.NEXT = 0;
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
    begin
        with Job do begin
            Job.COPYFILTERS(JobFilters);

            //Get budget values
            COPYFILTER("NS_Date Filter", Job."Posting Date Filter");
            CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");
            BudgetedPrice := "NS_Budgeted Price (LCY)";

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
                        if CostEstimate = 0 then begin             // If the Worksheet and the Manual percent did not yield a value
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

    procedure SLsForecastedCompletedCost(ParentJob: Record Job; Worksheet: Boolean; Manual: Boolean; var BudgetedPrice: Decimal; var ActualCost: Decimal; var ActualBillings: Decimal; var TotalCostEstimate: Decimal; var PercentType: Text[1]);
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
        TotalCostEstimate := 0;
        with JobSearch do begin
            JobSearch.COPYFILTERS(JobFilters);
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
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
                    TotalCostEstimate := TotalCostEstimate + ProjectedToPrintTotalCostEst + SLsProjectedToPrintTotalCostEs;
                until NEXT = 0;
        end;
    end;
}