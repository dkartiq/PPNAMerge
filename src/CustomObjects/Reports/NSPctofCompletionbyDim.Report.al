report 14021173 "NS_Pct of Completion by Dim"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //SMPL - Caption = 'RequestPage' not supported on area
    //PRJ-84.SK.1.0 Added report to search
    //PRJ-902.JS.1.0  10Sep2021 | Correct key parameters in get function to run report
    //PRJ-1065.JS.1.0 | 10Dec2021 | Correction Regaridng Dimensions

    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSPct of Completion by Dim.rdl';
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Percentage of Completion by Dimension';
    ApplicationArea = all;
    EnableHyperlinks = true;

    dataset
    {
        dataitem(Job; Job)
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            RequestFilterFields = "No.", "Bill-to Customer No.", "NS_Date Filter", Status, "NS_Activity Filter", "NS_Process Filter", "NS_Operation Filter";

            dataitem(JobTaskBuilding; "Job Task")
            {
                DataItemLink = "Job No." = FIELD("No.");
                DataItemTableView = SORTING("Job No.", "Job Task No.") ORDER(Ascending);

                trigger OnAfterGetRecord();
                begin
                    with JobAnalysisBuffer do begin

                        //PRJ-902.JS.1.0  10Sep2021-Start
                        JobAnaBuffEntryNo := 0;
                        JobAnalysisBufferNew.Reset();
                        If JobAnalysisBufferNew.FindLast() then
                            JobAnaBuffEntryNo := JobAnalysisBufferNew."NS_Entry No.";

                        If JobAnaBuffEntryNo = 0 then
                            JobAnaBuffEntryNo := 1
                        else
                            JobAnaBuffEntryNo := JobAnaBuffEntryNo + 1;
                        //PRJ-902.JS.1.0  10Sep2021-end 

                        case true of
                            DimCode = GLSetup."Global Dimension 1 Code":
                                ProcessDimensionCode := 1;
                            DimCode = GLSetup."Global Dimension 2 Code":
                                ProcessDimensionCode := 2;
                        end;

                        if ProcessDimensionCode = 1 then
                            GlobalDimensionCode := JobTaskBuilding."Global Dimension 1 Code"
                        else
                            GlobalDimensionCode := JobTaskBuilding."Global Dimension 2 Code";

                        if "Job Task Type" = "Job Task Type"::Posting then begin
                            ForecastedCompletedCost(Job, JobTaskBuilding."Job Task No.", ProcessDimensionCode, GlobalDimensionCode, UseJobForecastWorksheet, UseEnteredPercentComplete,
                                                    ToPrintContract,
                                                    ToPrintToDateCost,
                                                    ToPrintBillings,
                                                    ToPrintCostEstimate,
                                                    PercentType);
                            //if not GET(Job."No.", "NS_Entry Type"::Cost, '', '', '', '', NS_Type::Resource, Job."NS_Sub-Level to Job No.", '', '', GlobalDimensionCode, '') then begin  //PRJ-902.JS.1.0 line commented
                            if not JobAnalysisBuffer.GET(Job."No.", JobAnalysisBuffer."NS_Entry Type"::Cost, '', '', '', '', JobAnalysisBuffer.NS_Type::Resource, Job."NS_Sub-Level to Job No.", '', '', true, JobAnaBuffEntryNo) then begin  //PRJ-902.JS.1.0 line added    
                                INIT;
                                //PRJ-902.JS.1.0 10Sep2021 Start
                                "NS_Job No." := Job."No.";
                                "NS_Entry Type" := JobAnalysisBuffer."NS_Entry Type"::Cost;
                                NS_Type := JobAnalysisBuffer.NS_Type::Resource;
                                "NS_No." := Job."NS_Sub-Level to Job No.";
                                "NS_Is Locked" := true;
                                "NS_Entry No." := JobAnaBuffEntryNo;
                                "NS_Global Dimension 1 Code" := GlobalDimensionCode;   //PRJ-1065.JS.1.0  08Dec2021
                                //PRJ-902.JS.1.0 10Sep2021 end
                                "NS_Posting Date" := WORKDATE;
                                Description := Job.Description;
                                "NS_Budgeted Price" := ToPrintContract;
                                "NS_Actual Cost" := ToPrintToDateCost;
                                "NS_Actual Price" := ToPrintBillings;
                                "NS_Budgeted Cost" := ToPrintCostEstimate;
                                "NS_Calculation Source Code" := PercentType;
                                INSERT;
                            end else begin
                                "NS_Budgeted Price" := "NS_Budgeted Price" + ToPrintContract;
                                "NS_Actual Cost" := "NS_Actual Cost" + ToPrintToDateCost;
                                "NS_Actual Price" := "NS_Actual Price" + ToPrintBillings;
                                "NS_Budgeted Cost" := "NS_Budgeted Cost" + ToPrintCostEstimate;
                                MODIFY;
                            end;

                        end;
                    end;
                end;
            }

            trigger OnPreDataItem();
            begin
                DateFilter := Job.GETFILTER("NS_Date Filter");
                ActivityFilter := Job.GETFILTER("NS_Activity Filter");
                ProcessFilter := Job.GETFILTER("NS_Process Filter");
                OperationFilter := Job.GETFILTER("NS_Operation Filter");

                JobAnalysisBuffer.RESET;
                JobAnalysisBuffer.DELETEALL;
            end;
        }
        dataitem(BuildJobAnalysisBuffer2; "Integer")
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending);

            trigger OnAfterGetRecord();
            begin
                with JobAnalysisBuffer do begin
                    RESET;
                    if FINDSET then
                        repeat
                            JobAnalysisBuffer2.INIT;
                            JobAnalysisBuffer2."NS_Posting Date" := "NS_Posting Date";
                            JobAnalysisBuffer2."NS_Job No." := "NS_Job No.";
                            JobAnalysisBuffer2.NS_Description := NS_Description;
                            JobAnalysisBuffer2."NS_No." := "NS_No.";
                            JobAnalysisBuffer2."NS_Budgeted Price" := "NS_Budgeted Price";
                            JobAnalysisBuffer2."NS_Actual Cost" := "NS_Actual Cost";
                            JobAnalysisBuffer2."NS_Actual Price" := "NS_Actual Price";
                            JobAnalysisBuffer2."NS_Budgeted Cost" := "NS_Budgeted Cost";
                            JobAnalysisBuffer2."NS_Calculation Source Code" := "NS_Calculation Source Code";
                            JobAnalysisBuffer2.INSERT;
                        until NEXT = 0;
                end;
            end;

            trigger OnPostDataItem();
            begin
                JobAnalysisBuffer2.RESET;
            end;

            trigger OnPreDataItem();
            begin
                //CurrReport.BREAK;

                JobAnalysisBuffer2.RESET;
                JobAnalysisBuffer2.DELETEALL;
                if "IncludeSub-Levels" then
                    SETRANGE(Number, 1)
                else
                    CurrReport.BREAK;
            end;
        }
        dataitem(AddInSubLevels; "Integer")
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending);

            trigger OnAfterGetRecord();
            begin
                with JobAnalysisBuffer2 do begin
                    //Filter through the records that are for sub-jobs
                    //  Either create a new master job record based on the master job or add to the existing master job record
                    RESET;
                    SETFILTER("NS_No.", '>%1', '');
                    if FINDSET then
                        repeat

                            JobAnalysisBuffer.RESET;
                            JobAnalysisBuffer.SETRANGE("NS_Job No.", "NS_No.");
                            //JobAnalysisBuffer.SETRANGE("NS_Posting Date", "NS_Posting Date");   //PRJ-1065.JS.1.0  08Dec2021 line commented
                            JobAnalysisBuffer.Setrange("NS_Global Dimension 1 Code", "NS_Global Dimension 1 Code");    //PRJ-1065.JS.1.0  08Dec2021 line added
                            if not JobAnalysisBuffer.FINDSET then begin
                                JobAnalysisBuffer.INIT;
                                JobAnalysisBuffer."NS_Posting Date" := "NS_Posting Date";
                                JobAnalysisBuffer."NS_Job No." := "NS_Job No.";
                                JobAnalysisBuffer.NS_Description := NS_Description;
                                JobAnalysisBuffer."NS_Budgeted Price" := "NS_Budgeted Price";
                                JobAnalysisBuffer."NS_Actual Cost" := "NS_Actual Cost";
                                JobAnalysisBuffer."NS_Actual Price" := "NS_Actual Price";
                                JobAnalysisBuffer."NS_Budgeted Cost" := "NS_Budgeted Cost";
                                JobAnalysisBuffer."NS_Calculation Source Code" := "NS_Calculation Source Code";
                                JobAnalysisBuffer."NS_Global Dimension 1 Code" := "NS_Global Dimension 1 Code";    //PRJ-1065.JS.1.0  08Dec2021 line added
                                if JobAnalysisBuffer.INSERT then;
                            end else begin
                                JobAnalysisBuffer."NS_Budgeted Price" := JobAnalysisBuffer."NS_Budgeted Price" + "NS_Budgeted Price";
                                JobAnalysisBuffer."NS_Actual Cost" := JobAnalysisBuffer."NS_Actual Cost" + "NS_Actual Cost";
                                JobAnalysisBuffer."NS_Actual Price" := JobAnalysisBuffer."NS_Actual Price" + "NS_Actual Price";
                                JobAnalysisBuffer."NS_Budgeted Cost" := JobAnalysisBuffer."NS_Budgeted Cost" + "NS_Budgeted Cost";
                                JobAnalysisBuffer.MODIFY;
                            end;

                        until NEXT = 0;

                    if "ShowSub-Levels" then
                        //Filter through the records that are for sub-jobs
                        //  Either create a new master job record based on the master job or add to the existing master job record
                        RESET;
                    SETFILTER("NS_No.", '>%1', '');
                    if FINDSET then
                        repeat
                            JobAnalysisBuffer.RESET;
                            JobAnalysisBuffer.SETRANGE("NS_No.", "NS_No.");
                            if not JobAnalysisBuffer.FINDSET then begin
                                JobAnalysisBuffer.INIT;
                                JobAnalysisBuffer."NS_Posting Date" := "NS_Posting Date";
                                JobAnalysisBuffer."NS_Job No." := "NS_Job No.";
                                JobAnalysisBuffer."NS_No." := "NS_No.";
                                JobAnalysisBuffer.NS_Description := NS_Description;
                                JobAnalysisBuffer."NS_Budgeted Price" := "NS_Budgeted Price";
                                JobAnalysisBuffer."NS_Actual Cost" := "NS_Actual Cost";
                                JobAnalysisBuffer."NS_Actual Price" := "NS_Actual Price";
                                JobAnalysisBuffer."NS_Budgeted Cost" := "NS_Budgeted Cost";
                                JobAnalysisBuffer."NS_Calculation Source Code" := "NS_Calculation Source Code";
                                if JobAnalysisBuffer.INSERT then;
                            end;
                        until NEXT = 0;

                end;
            end;

            trigger OnPreDataItem();
            begin
                if "IncludeSub-Levels" and not "ShowSub-Levels" then
                    SETRANGE(Number, 1)
                else
                    CurrReport.BREAK;
            end;
        }
        dataitem(ReportHeadings; "Integer")
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending);
            MaxIteration = 1;
            column(ReportTitle; ReportTitle)
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
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
            column(Global_Dimension_Code_Header; GlobalDimensionCodeHeader)
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
            column(TotalsCaption; TotalsCaptionLbl)
            {
            }
            dataitem(JobAnalysisBufferArea; "Integer")
            {
                DataItemTableView = SORTING(Number) ORDER(Ascending);
                column(Global_Dimension_Code; GlobalDimensionCode)
                {
                }
                column(Global_Dimension_Selected; DimensionCodeLbl + ': ' + GlobalDimensionCode)
                {
                }
                column(Job__No__; JobNo)
                {
                }
                column(Job_Description; JobDescription)
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
                column(SubLevel_Budgeted_Price; SubLevelBudgetedPrice)
                {
                }
                column(SubLevel_Actual_Price; SubLevelActualPrice)
                {
                }
                column(SubLevel_Actual_Cost; SubLevelActualCost)
                {
                }
                column(SubLevel_Budgeted_Cost; SubLevelBudgetedCost)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    with JobAnalysisBuffer do begin

                        //Calculate Percent Complete either from Job card or from pre-calculated values
                        "NS_Percent Value" := 0;
                        if UseJobForecastWorksheet then
                            if "NS_Budgeted Cost" <> 0 then
                                "NS_Percent Value" := 100 - (("NS_Budgeted Cost" - "NS_Actual Cost") / "NS_Budgeted Cost") * 100;

                        if ("NS_Percent Value" = 0) and UseEnteredPercentComplete then begin
                            Job.GET("NS_Job No.");
                            if Job."NS_Actual Percent Complete" > 0 then
                                "NS_Percent Value" := Job."NS_Actual Percent Complete";
                        end;

                        if ("NS_Percent Value" = 0) or ((UseJobForecastWorksheet = false) and (UseEnteredPercentComplete = false)) then
                            if "NS_Budgeted Cost" <> 0 then
                                "NS_Percent Value" := 100 - (("NS_Budgeted Cost" - "NS_Actual Cost") / "NS_Budgeted Cost") * 100;

                        "NS_Percent Value" := ROUND("NS_Percent Value", 0.01);
                        if "NS_Percent Value" > 100 then
                            "NS_Percent Value" := 100;

                        //Fill in columns on the report
                        GlobalDimensionCode := "NS_Global Dimension 1 Code"; //prj-1065.JS.1.0 08Dec2021
                        JobNo := "NS_Job No.";
                        JobDescription := NS_Description;
                        A := "NS_Budgeted Price";
                        B := "NS_Actual Price";
                        C := "NS_Actual Cost";
                        D := "NS_Budgeted Cost";
                        E := "NS_Percent Value";
                        F := ROUND((E / 100) * A, GLSetup."Amount Rounding Precision");
                        G := F - C;
                        H := 0;
                        I := 0;
                        if B - F > 0 then
                            H := B - F
                        else
                            I := -(B - F);

                        NEXT;

                    end;
                end;

                trigger OnPreDataItem();
                begin
                    JobAnalysisBuffer.RESET;
                    JobAnalysisBuffer.SETCURRENTKEY("NS_Posting Date");
                    if not JobAnalysisBuffer.FINDSET then
                        ERROR(Text011);

                    SETRANGE(Number, 1, JobAnalysisBuffer.COUNT)
                end;
            }

            trigger OnAfterGetRecord();
            begin
                if not "ShowSub-Levels" then
                    //Filter through the records that are for sub-jobs
                    //  Clear them from the JobAnalysisBuffer
                    with JobAnalysisBuffer do begin
                        RESET;
                        SETFILTER("NS_No.", '>%1', '');
                        DELETEALL;
                        RESET;
                    end;
            end;

            trigger OnPreDataItem();
            begin
                CurrReport.CREATETOTALS(A, B, C, D, E, F, G, H, I);
                JobAnalysisBuffer.RESET;
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
                group("Report Order")
                {
                    Caption = 'Report Order';
                    field(DimCode; DimCode)
                    {
                        Caption = 'Select Global Dimension';
                        ApplicationArea = All;

                        trigger OnLookup(VAR Text: Text): Boolean;
                        begin
                            if PAGE.RUNMODAL(0, Dimension) = ACTION::LookupOK then begin
                                Text := Dimension.Code;
                                exit(true);
                            end;
                            exit(false);
                        end;

                        trigger OnValidate();
                        begin
                            Dimension.GET(DimCode);
                            case true of
                                DimCode = GLSetup."Global Dimension 1 Code":
                                    ProcessDimensionCode := 1;
                                DimCode = GLSetup."Global Dimension 2 Code":
                                    ProcessDimensionCode := 2;
                                else
                                    ERROR(Text001, GLSetup."Global Dimension 1 Code", GLSetup."Global Dimension 2 Code");
                            end;
                        end;
                    }
                }
                group(Options)
                {
                    field("IncludeSub-Levels"; "IncludeSub-Levels")
                    {
                        Caption = 'Include Sub-Levels';
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            if not "IncludeSub-Levels" then
                                "ShowSub-Levels" := false;
                        end;
                    }
                    field("ShowSub-Levels"; "ShowSub-Levels")
                    {
                        Caption = 'Show Sub-Levels';
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            if "ShowSub-Levels" then
                                "IncludeSub-Levels" := true;
                        end;
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
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit();
        begin
            GLSetup.GET;
        end;

        trigger OnOpenPage();
        begin
            Dimension.RESET;
            if DimCode <> '' then
                if not Dimension.GET(DimCode) then;
            Dimension.FILTERGROUP(8);
            if (GLSetup."Global Dimension 1 Code" <> '') and
               (GLSetup."Global Dimension 2 Code" <> '')
            then
                Dimension.SETFILTER(Code, '%1|%2', GLSetup."Global Dimension 1 Code", GLSetup."Global Dimension 2 Code")
            else
                if GLSetup."Global Dimension 1 Code" <> '' then
                    Dimension.SETRANGE(Code, GLSetup."Global Dimension 1 Code")
                else
                    if GLSetup."Global Dimension 2 Code" <> '' then
                        Dimension.SETRANGE(Code, GLSetup."Global Dimension 2 Code")
                    else
                        ERROR(Text010);
            Dimension.FILTERGROUP(0);
        end;
    }

    labels
    {
    }

    trigger OnPreReport();
    var
        JobsSetup: Record "Jobs Setup"; //PRJ-1571.NK.1.0 25Aug2022
        ApoSetup: Record NS_APOSetup; //PRJ-1571.NK.1.0 25Aug2022
    begin
        CompanyInformation.GET;
        GLSetup.GET;
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
        if "ShowSub-Levels" then
            "Sub-LevelsText" := Text002
        else
            if "IncludeSub-Levels" then
                "Sub-LevelsText" := Text003
            else
                "Sub-LevelsText" := Text002;

        if UseEnteredPercentComplete then
            CompletePercentText := Text004
        else
            CompletePercentText := Text005;

        if UseJobForecastWorksheet then
            WorksheetText := Text008
        else
            WorksheetText := Text009;
    end;

    var
        CompanyInformation: Record "Company Information";
        JobFilters: Record Job;
        JobLedgEntry: Record "Job Ledger Entry";
        JobForecast: Record "NS_Job Forecast";
        JobAnalysisBuffer: Record "NS_Job Analysis Buffer" temporary;
        JobAnalysisBuffer2: Record "NS_Job Analysis Buffer" temporary;
        JobAnalysisBufferNew: Record "NS_Job Analysis Buffer";   //PRJ-902.JS.1.0 10Sep2021
        Dimension: Record Dimension;
        GLSetup: Record "General Ledger Setup";
        DimCode: Text[20];
        JobAnaBuffEntryNo: Integer;  //PRJ-902.JS.1.0 10Sep2021
        ProcessDimensionCode: Integer;
        JobFilter: Text[250];
        JobFilterNew: Text[250]; //PRJ-1571
        GlobalDimensionCodeHeader: Text[25];
        GlobalDimensionCode: Code[20];
        ToPrintContract: Decimal;
        ToPrintToDateCost: Decimal;
        ToPrintBillings: Decimal;
        ToPrintCostEstimate: Decimal;
        PercentType: Text[1];
        SubLevelBudgetedPrice: Decimal;
        SubLevelActualPrice: Decimal;
        SubLevelBudgetedCost: Decimal;
        SubLevelActualCost: Decimal;
        JobNo: Code[20];
        JobDescription: Text[50];
        A: Decimal;
        B: Decimal;
        C: Decimal;
        D: Decimal;
        E: Decimal;
        F: Decimal;
        G: Decimal;
        H: Decimal;
        I: Decimal;
        "IncludeSub-Levels": Boolean;
        "ShowSub-Levels": Boolean;
        UseEnteredPercentComplete: Boolean;
        UseJobForecastWorksheet: Boolean;
        "Sub-LevelsText": Text[50];
        CompletePercentText: Text[50];
        WorksheetText: Text[50];
        Text001: Label '[Blank]';
        Text002: Label 'Sub-Levels are not included in jobs';
        Text003: Label 'Sub-Levels are included in jobs';
        Text004: Label 'Percent Completion used';
        Text005: Label 'Percent Completion not used';
        Text008: Label 'Forecast Worksheet used';
        Text009: Label 'Forecast Worksheet not used';
        Text010: Label 'There are no Global Dimensions set up in General Ledger Setup. This report can only be used with Global Dimensions.';
        Text011: Label 'Nothing was found to be shown on the report.';
        WorksheetCode: Label 'W';
        ManualCode: Label 'M';
        CalculatedCode: Label 'C';
        PageCaptionLbl: Label 'Page';
        ReportTitle: Label 'Percentage of Completion by Dimension';
        DimensionCodeLbl: Label 'Dimension Code';
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
        TotalsCaptionLbl: Label 'Totals';
        DateFilter: Text[50];
        ActivityFilter: Text[50];
        ProcessFilter: Text[50];
        OperationFilter: Text[50];
        xAddCount: Integer;
        xModifyCount: Integer;
        TextActivity: Text; //PRJ-1571.NK.1.0 25Aug2022 
        TextProcess: Text; //PRJ-1571.NK.1.0 25Aug2022 
        TextOperation: Text; //PRJ-1571.NK.1.0 25Aug2022

    procedure FindUsageCost(Job: Record Job; TaskNo: Code[20]) Usage: Decimal;
    begin
        Usage := 0;
        with Job do begin
            if DateFilter > '' then
                SETFILTER("NS_Date Filter", DateFilter);
            if ActivityFilter > '' then
                SETFILTER("NS_Activity Filter", ActivityFilter);
            if ProcessFilter > '' then
                SETFILTER("NS_Process Filter", ProcessFilter);
            if OperationFilter > '' then
                SETFILTER("NS_Operation Filter", OperationFilter);

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
            JobLedgEntry.SETFILTER("Job Task No.", TaskNo);
            if JobLedgEntry.FINDSET then
                repeat
                    Usage := Usage + JobLedgEntry."Total Cost (LCY)";
                until JobLedgEntry.NEXT = 0;
        end;
    end;

    procedure FindInvoicedPrice(Job: Record Job; TaskNo: Code[20]) Price: Decimal;
    begin
        Price := 0;
        with Job do begin
            if DateFilter > '' then
                SETFILTER("NS_Date Filter", DateFilter);
            if ActivityFilter > '' then
                SETFILTER("NS_Activity Filter", ActivityFilter);
            if ProcessFilter > '' then
                SETFILTER("NS_Process Filter", ProcessFilter);
            if OperationFilter > '' then
                SETFILTER("NS_Operation Filter", OperationFilter);

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
            JobLedgEntry.SETFILTER("Job Task No.", TaskNo);
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

    procedure ForecastedCompletedCost(JobRec: Record Job; TaskNo: Code[20]; GlobalDimFilter: Integer; GlobalDimFilterCode: Code[20]; Worksheet: Boolean; Manual: Boolean; var BudgetedPrice: Decimal; var ActualCost: Decimal; var ActualBillings: Decimal; var CostEstimate: Decimal; var Source: Text[1]);
    var
        JobTask: Record "Job Task";
    begin
        with JobRec do begin

            case GlobalDimFilter of
                1:
                    SETFILTER("NS_Global Dimension 1 Filter", GlobalDimFilterCode);
                2:
                    SETFILTER("NS_Global Dimension 2 Filter", GlobalDimFilterCode);
            end;
            if DateFilter > '' then
                SETFILTER("NS_Date Filter", DateFilter);
            if ActivityFilter > '' then
                SETFILTER("NS_Activity Filter", ActivityFilter);
            if ProcessFilter > '' then
                SETFILTER("NS_Process Filter", ProcessFilter);
            if OperationFilter > '' then
                SETFILTER("NS_Operation Filter", OperationFilter);

            //Get budget values
            if JobTask.GET("No.", TaskNo) then begin
                if DateFilter > '' then
                    JobTask.SETFILTER("Planning Date Filter", DateFilter);
                JobTask.SETRANGE("Job Task No.", TaskNo);
                JobTask.CALCFIELDS("Schedule (Total Cost)", "Contract (Total Price)");
                BudgetedPrice := JobTask."Contract (Total Price)";
            end else
                BudgetedPrice := 0;

            //Get actual values
            //ActualCost := FindUsageCost(Job,TaskNo);
            ActualCost := FindUsageCost(JobRec, TaskNo);
            ActualBillings := FindInvoicedPrice(JobRec, TaskNo);

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
                    begin                                        // Using the Cost To Complete Worksheet
                                                                 //      CostEstimate := CompletionStatus.ForeCostAtCompFromWorksheet(JobRec."No.",TaskNo,JobRec.GETFILTER("Date Filter"));
                        CostEstimate := JobForecast.ForecastedCompletedAmt(2, JobRec."No.", TaskNo, JobRec.GETFILTER("NS_Date Filter"));
                        Source := WorksheetCode;
                        if Manual and          // If Manual percent is available AND
                           (CostEstimate = 0) and          // the Cost To Complete Worksheet did not yield a value AND
                           (JobRec."NS_Actual Percent Complete" > 0) and          // there is an "Actual Percent Complete" entered on the Job Card AND
                           (ActualCost > 0) and          // there is a "To Date Cost" to work with
                           DateInRange(JobRec."NS_Actual PercentCompleteDate",  // the "Actual Percent Complete Date" is within any entered date filter
                                       GETFILTER("NS_Date Filter"))
                           then begin
                            CostEstimate := ROUND((ActualCost * 100) / JobRec."NS_Actual Percent Complete", 0.01);
                            Source := ManualCode;
                        end;
                        if CostEstimate = 0 then begin                         // If the Worksheet and the Manual percent did not yield a value
                            CostEstimate := JobTask."Schedule (Total Cost)";
                            Source := CalculatedCode;
                        end;
                    end;

                Manual and             // Using the Manual percent AND
                  (JobRec."NS_Actual Percent Complete" > 0) and             // there is an "Actual Percent Complete" entered on the Job Card AND
                  (ActualCost > 0) and             // there is a "To Date Cost" to work with
                  DateInRange(JobRec."NS_Actual PercentCompleteDate",     // the "Actual Percent Complete Date" is within any entered date filter
                              GETFILTER("NS_Date Filter")):
                    begin
                        CostEstimate := ROUND((ActualCost * 100) / JobRec."NS_Actual Percent Complete", 0.01);
                        Source := ManualCode;
                        if CostEstimate = 0 then begin                         // The Manual percent did not yield a value
                            CostEstimate := JobTask."Schedule (Total Cost)";
                            Source := CalculatedCode;
                        end;
                    end;

                else begin                                               // Neither the Worksheet nor the Manual percent is being used
                        CostEstimate := JobTask."Schedule (Total Cost)";
                        Source := CalculatedCode;
                    end;
            end;
        end;
    end;

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

