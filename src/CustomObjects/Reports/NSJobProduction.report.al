report 14021159 "NS_Job Production"
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
    Caption = 'Job Production';
    RDLCLayout = './Layouts/NSJob Production.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;


    dataset
    {
        dataitem(Job; Job)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "NS_Date Filter", "NS_Activity Filter";
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(USERID; USERID)
            {
            }
            column(Job__No__; "No.")
            {
            }
            column(Job_Description; Description)
            {
            }
            column(EndDate; EndDate)
            {
            }
            column(ChangesText; ChangesText)
            {
            }
            column(Job_ProductionCaption; Job_ProductionCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Job__Caption; Job__CaptionLbl)
            {
            }
            column(Job_NameCaption; Job_NameCaptionLbl)
            {
            }
            column(Week_EndingCaption; Week_EndingCaptionLbl)
            {
            }
            column(Job_CodeCaption; Job_CodeCaptionLbl)
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(QuantityCaption; QuantityCaptionLbl)
            {
            }
            column(Work_Unit_of_MeasureCaption; Work_Unit_of_MeasureCaptionLbl)
            {
            }
            column(Est_MDCaption; Est_MDCaptionLbl)
            {
            }
            column(Est___Caption; Est___CaptionLbl)
            {
            }
            column(Quantity_Job_to_DateCaption; Quantity_Job_to_DateCaptionLbl)
            {
            }
            column(Weekly_ProductionCaption; Weekly_ProductionCaptionLbl)
            {
            }
            column(Est____In_PlaceCaption; Est____In_PlaceCaptionLbl)
            {
            }
            column(Payroll_CostCaption; Payroll_CostCaptionLbl)
            {
            }
            column(Est__Unit_CostCaption; Est__Unit_CostCaptionLbl)
            {
            }
            column(Actual_CostCaption; Actual_CostCaptionLbl)
            {
            }
            column(Average_Unit_MDCaption; Average_Unit_MDCaptionLbl)
            {
            }
            dataitem("Job Planning Line"; "Job Planning Line")
            {
                DataItemLink = "Job No." = FIELD("No."), "NS_Activity Code" = FIELD("NS_Activity Filter");
                DataItemTableView = SORTING("Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Cost Category", Type, "No.", "Variant Code") WHERE("NS_Entry Type" = CONST(Cost));
                PrintOnlyIfDetail = true;
                dataitem(JobPlanningLines; "Job Planning Line")
                {
                    DataItemLink = "Job No." = FIELD("Job No."), "NS_Activity Code" = FIELD("NS_Activity Code");
                    DataItemTableView = SORTING("Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Cost Category", Type, "No.", "Variant Code") WHERE(Type = CONST(Resource), "NS_Entry Type" = CONST(Cost));

                    trigger OnAfterGetRecord();
                    begin
                        TempJobBudgetLine.RESET;
                        TempJobBudgetLine.SETRANGE("Job No.", "Job No.");
                        TempJobBudgetLine.SETRANGE("Job Task No.", "Job Task No.");
                        if not TempJobBudgetLine.FINDFIRST then begin
                            TempJobBudgetLine.INIT;
                            TempJobBudgetLine."Job No." := "Job No.";
                            TempJobBudgetLine."Job Task No." := "Job Task No.";
                            TempJobBudgetLine."NS_Entry Type" := "NS_Entry Type";
                            TempJobBudgetLine."NS_Activity Code" := "NS_Activity Code";
                            TempJobBudgetLine."NS_Process Code" := "NS_Process Code";
                            TempJobBudgetLine.Description := Description;
                            TempJobBudgetLine.INSERT;
                            TempJobBudgetLine2.COPY(TempJobBudgetLine);
                            if TempJobBudgetLine2.INSERT then;
                        end;
                    end;

                    trigger OnPreDataItem();
                    begin
                        //Set the filter so only gets records where Type=Lab.
                        DisplayLine := true;
                        if FilterString = '' then begin
                            JobCostCategories.RESET;
                            JobCostCategories.SETFILTER(NS_Type, 'Labor');
                            if JobCostCategories.FINDSET then
                                repeat
                                    //See if there is text in FilterString so we can add the '|' to the end
                                    if FilterString <> '' then
                                        FilterString := FilterString + '|';
                                    FilterString := FilterString + JobCostCategories.NS_Code;
                                until JobCostCategories.NEXT = 0;
                        end;
                        SETFILTER("NS_Cost Category", FilterString);
                    end;
                }
                dataitem("Job Ledger Entry"; "Job Ledger Entry")
                {
                    DataItemLink = "Job No." = FIELD("Job No."), "NS_Activity Code" = FIELD("NS_Activity Code");
                    DataItemTableView = SORTING("Job No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Job Cost Category", "Entry Type", "Posting Date")
                     WHERE(Type = CONST(Resource), "Entry Type" = CONST(Usage), "Work Type Code" = FILTER(<> 'RESOVH'));

                    trigger OnAfterGetRecord();
                    begin
                        TempJobBudgetLine.RESET;
                        TempJobBudgetLine.SETRANGE("Job No.", "Job No.");
                        TempJobBudgetLine.SETRANGE("Job Task No.", "Job Task No.");
                        if not TempJobBudgetLine.FINDFIRST then begin
                            TempJobBudgetLine.INIT;
                            TempJobBudgetLine."Job No." := "Job No.";
                            TempJobBudgetLine."Job Task No." := "Job Task No.";
                            TempJobBudgetLine."NS_Entry Type" := "Entry Type";
                            TempJobBudgetLine."NS_Activity Code" := "NS_Activity Code";
                            TempJobBudgetLine."NS_Process Code" := "NS_Process Code";
                            TempJobBudgetLine.Description := Description;
                            TempJobBudgetLine.INSERT;
                            TempJobBudgetLine2.COPY(TempJobBudgetLine);
                            TempJobBudgetLine2.INSERT;
                        end else begin
                            TempJobBudgetLine."Total Cost" := TempJobBudgetLine."Total Cost" + "Total Cost";
                            TempJobBudgetLine.MODIFY;
                        end;
                    end;

                    trigger OnPreDataItem();
                    begin
                        SETFILTER("Posting Date", Job.GETFILTER("NS_Date Filter"));
                        DisplayLine := true;

                        if FilterString = '' then begin
                            JobCostCategories.RESET;
                            JobCostCategories.SETFILTER(NS_Type, 'Labor');
                            if JobCostCategories.FINDSET then
                                repeat
                                    //See if there is text in FilterString so we can add the '|' to the end
                                    if FilterString <> '' then
                                        FilterString := FilterString + '|';
                                    FilterString := FilterString + JobCostCategories.NS_Code;
                                until JobCostCategories.NEXT = 0;
                        end;
                        SETFILTER("NS_Activity Code", Job.GETFILTER("NS_Activity Filter"));
                        SETFILTER("NS_Job Cost Category", FilterString);
                        SETRANGE("Entry Type", "Entry Type"::Usage);
                    end;
                }
                dataitem(Changes; Job)
                {
                    DataItemLink = "NS_Sub-Level to Job No." = FIELD("Job No.");
                    DataItemLinkReference = "Job Planning Line";
                    DataItemTableView = SORTING("No.");
                    dataitem("Project Budget Line Changes"; "Job Planning Line")
                    {
                        DataItemLink = "Job No." = FIELD("No.");
                        DataItemLinkReference = Changes;
                        DataItemTableView = SORTING("Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Cost Category", Type, "No.", "Variant Code") WHERE(Type = CONST(Resource), "NS_Entry Type" = CONST(Cost));

                        trigger OnAfterGetRecord();
                        begin
                            if ShowChanges then
                                CurrReport.SKIP;

                            TempJobBudgetLine.RESET;
                            TempJobBudgetLine.SETRANGE("Job No.", "Job No.");
                            TempJobBudgetLine.SETRANGE("Job Task No.", "Job Task No.");
                            if not TempJobBudgetLine.FINDFIRST then begin
                                TempJobBudgetLine.INIT;
                                TempJobBudgetLine."Job No." := "Job No.";
                                TempJobBudgetLine."Job Task No." := "Job Task No.";
                                TempJobBudgetLine."NS_Entry Type" := "NS_Entry Type";
                                TempJobBudgetLine."NS_Activity Code" := "NS_Activity Code";
                                TempJobBudgetLine."NS_Process Code" := "NS_Process Code";
                                TempJobBudgetLine.Description := Description;
                                TempJobBudgetLine.INSERT;
                                TempJobBudgetLine2.COPY(TempJobBudgetLine);
                                TempJobBudgetLine2.INSERT;
                            end;
                        end;

                        trigger OnPreDataItem();
                        begin
                            DisplayLine := true;
                            if FilterString = '' then begin
                                JobCostCategories.RESET;
                                JobCostCategories.SETFILTER(NS_Type, 'Labor');
                                if JobCostCategories.FINDSET then
                                    repeat
                                        //See if there is text in FilterString so we can add the '|' to the end
                                        if FilterString <> '' then
                                            FilterString := FilterString + '|';
                                        FilterString := FilterString + JobCostCategories.NS_Code;
                                    until JobCostCategories.NEXT = 0;
                            end;
                            SETFILTER("NS_Activity Code", Job.GETFILTER("NS_Activity Filter"));
                            SETFILTER("NS_Cost Category", FilterString);
                        end;
                    }
                    dataitem("Project Ledger Entry Changes"; "Job Ledger Entry")
                    {
                        DataItemLink = "Job No." = FIELD("No.");
                        DataItemLinkReference = Changes;
                        DataItemTableView = SORTING("Job No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Job Cost Category", "Entry Type", "Posting Date") WHERE(Type = CONST(Resource), "Entry Type" = CONST(Usage));

                        trigger OnAfterGetRecord();
                        begin
                            if IncludeChanges then
                                TempJobBudgetLine.RESET;
                            TempJobBudgetLine.SETRANGE("Job No.", "Job No.");
                            TempJobBudgetLine.SETRANGE("Job Task No.", "Job Task No.");
                            if not TempJobBudgetLine.FINDFIRST then begin
                                TempJobBudgetLine.INIT;
                                TempJobBudgetLine."Job No." := "Job No.";
                                TempJobBudgetLine."Job Task No." := "Job Task No.";
                                TempJobBudgetLine."NS_Entry Type" := "Entry Type";
                                TempJobBudgetLine."NS_Activity Code" := "NS_Activity Code";
                                TempJobBudgetLine."NS_Process Code" := "NS_Process Code";
                                TempJobBudgetLine.Description := Description;
                                TempJobBudgetLine.INSERT;
                                TempJobBudgetLine2.COPY(TempJobBudgetLine);
                                TempJobBudgetLine2.INSERT;
                            end else begin
                                TempJobBudgetLine."Total Cost" := TempJobBudgetLine."Total Cost" + "Total Cost";
                                TempJobBudgetLine.MODIFY;
                            end;
                            CurrReport.SKIP;
                        end;

                        trigger OnPreDataItem();
                        begin
                            SETFILTER("Posting Date", Job.GETFILTER("NS_Date Filter"));

                            DisplayLine := true;

                            if FilterString = '' then begin
                                JobCostCategories.RESET;
                                JobCostCategories.SETFILTER(NS_Type, 'Labor');
                                if JobCostCategories.FINDSET then
                                    repeat
                                        //See if there is text in FilterString so we can add the '|' to the end
                                        if FilterString <> '' then
                                            FilterString := FilterString + '|';
                                        FilterString := FilterString + JobCostCategories.NS_Code;
                                    until JobCostCategories.NEXT = 0;
                            end;
                            SETFILTER("NS_Activity Code", Job.GETFILTER("NS_Activity Filter"));
                            SETFILTER("NS_Job Cost Category", FilterString);
                            SETRANGE("Entry Type", "Entry Type"::Usage);
                        end;
                    }

                    trigger OnPreDataItem();
                    begin
                        if not IncludeChanges then
                            CurrReport.BREAK;
                    end;
                }
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) ORDER(Ascending);
                column(TotalWorkUnits_TotalWorkUnitsForWeek; TotalWorkUnits + TotalWorkUnitsForWeek)
                {
                }
                column(EstTotalCost; EstTotalCost)
                {
                }
                column(EstManDays; EstManDays)
                {
                }
                column(WorkUnitofMeasure; WorkUnitofMeasure)
                {
                }
                column(WorkUnits; WorkUnits)
                {
                }
                column(Description1; Description1)
                {
                }
                column(JobBudgetLine__Activity_Code_________JobBudgetLine__Process_Code_; JobBudgetLine."NS_Activity Code" + '-' + JobBudgetLine."NS_Process Code")
                {
                }
                column(TotalWorkUnitsForWeek; TotalWorkUnitsForWeek)
                {
                }
                column(EstUnitCost; EstUnitCost)
                {
                }
                column(EstInPlace; EstInPlace)
                {
                }
                column(TotalCost; TotalCost)
                {
                }
                column(ActualCost; ActualCost)
                {
                }
                column(AverageUnitPerMD; AverageUnitPerMD)
                {
                }
                column(TotalEstManDays; TotalEstManDays)
                {
                }
                column(TotalEstTotalCost; TotalEstTotalCost)
                {
                }
                column(TotalEstInPlace; TotalEstInPlace)
                {
                }
                column(TotalTotalCost; TotalTotalCost)
                {
                }
                column(PriorTotalCost; PriorTotalCost)
                {
                }
                column(PriorEst; PriorEst)
                {
                }
                column(PriorEst_PriorTotalCost; PriorEst - PriorTotalCost)
                {
                }
                column(TotalTotalCost_Control1000000047; TotalTotalCost)
                {
                }
                column(TotalEstInPlaceSummary; TotalEstInPlaceSummary)
                {
                }
                column(TotalEstInPlaceSummary_TotalTotalCost; TotalEstInPlaceSummary - TotalTotalCost)
                {
                }
                column(PriorTotalCost_TotalTotalCost; PriorTotalCost + TotalTotalCost)
                {
                }
                column(EstCostJobTotal; EstCostJobTotal)
                {
                }
                column(PriorEst_PriorTotalCost___TotalEstInPlaceSummary_TotalTotalCost_; (PriorEst - PriorTotalCost) + (TotalEstInPlaceSummary - TotalTotalCost))
                {
                }
                column(TotalCaption; TotalCaptionLbl)
                {
                }
                column(SummaryCaption; SummaryCaptionLbl)
                {
                }
                column(Payroll_CostCaption_Control1000000041; Payroll_CostCaption_Control1000000041Lbl)
                {
                }
                column(Estimated_CostCaption; Estimated_CostCaptionLbl)
                {
                }
                column(Ahead__Behind_Caption; Ahead__Behind_CaptionLbl)
                {
                }
                column(Previous_TotalsCaption; Previous_TotalsCaptionLbl)
                {
                }
                column(This_WeekCaption; This_WeekCaptionLbl)
                {
                }
                column(Job_TotalsCaption; Job_TotalsCaptionLbl)
                {
                }
                column(Integer_Number; Number)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    WorkUnits := 0;
                    EstManDays := 0;
                    EstTotalCost := 0;
                    EstUnitCost := 0;
                    WorkUnitofMeasure := '';
                    JourneyManRate := 0;
                    TotalWorkUnits := 0;  //Work Units to Start Date-1  of Range
                    ItemPriorTotalCost := 0;
                    EstTotalCostPerManDays := 0;
                    CostVal := 0;
                    AverageUnitPerMD := 0;
                    Description1 := TempJobBudgetLine.Description;

                    JobBudgetLine.RESET;
                    JobBudgetLine.SETCURRENTKEY("Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                                "NS_Cost Category", Type, "No.", "Variant Code");
                    JobBudgetLine.SETFILTER("Job No.", TempJobBudgetLine."Job No.");
                    JobBudgetLine.SETFILTER("NS_Activity Code", TempJobBudgetLine."NS_Activity Code");
                    JobBudgetLine.SETFILTER("NS_Process Code", TempJobBudgetLine."NS_Process Code");
                    JobBudgetLine.SETFILTER("NS_Cost Category", FilterString);
                    JobBudgetLine.SETRANGE("NS_Entry Type", JobBudgetLine."NS_Entry Type"::Cost);
                    if JobBudgetLine.FINDSET then
                        repeat
                            if WorkUnitofMeasure = '' then  //if there are multiple lines and they have different Work UOMs, just grab the first one.
                                WorkUnitofMeasure := JobBudgetLine."NS_Work Unit of Measure";
                            if JourneyManRate = 0 then //if there are multiple lines and they have different Unit Costs, just grab the first one.
                                JourneyManRate := JobBudgetLine."Unit Cost";
                            WorkUnits := WorkUnits + JobBudgetLine."NS_Work Units";
                            EstManDays := EstManDays + JobBudgetLine.Quantity;
                            EstTotalCost := EstTotalCost + JobBudgetLine."Total Cost";
                        until JobBudgetLine.NEXT = 0;
                    //Now see if there are any Change Order records to add to the budget side
                    if IncludeChanges then begin
                        SubJob.RESET;
                        SubJob.SETRANGE("NS_Sub-Level to Job No.", TempJobBudgetLine."Job No.");
                        if SubJob.FINDSET then
                            repeat
                                JobBudgetLine.RESET;
                                JobBudgetLine.SETFILTER("Job No.", SubJob."No.");
                                JobBudgetLine.SETFILTER("NS_Activity Code", TempJobBudgetLine."NS_Activity Code");
                                JobBudgetLine.SETFILTER("NS_Process Code", TempJobBudgetLine."NS_Process Code");
                                JobBudgetLine.SETFILTER("NS_Cost Category", FilterString);
                                JobBudgetLine.SETRANGE("NS_Entry Type", JobBudgetLine."NS_Entry Type"::Cost);
                                if JobBudgetLine.FINDSET then
                                    repeat
                                        //if there are multiple lines and they have different Work UOMs, just grab the first one.
                                        if WorkUnitofMeasure = '' then
                                            WorkUnitofMeasure := JobBudgetLine."NS_Work Unit of Measure";
                                        //if there are multiple lines and they have different Unit Costs, just grab the first one.
                                        if JourneyManRate = 0 then
                                            JourneyManRate := JobBudgetLine."Unit Cost";
                                        WorkUnits := WorkUnits + JobBudgetLine."NS_Work Units";
                                        EstManDays := EstManDays + JobBudgetLine.Quantity;
                                        EstTotalCost := EstTotalCost + JobBudgetLine."Total Cost";
                                    until JobBudgetLine.NEXT = 0;
                            until SubJob.NEXT = 0;
                    end;

                    TotalEstManDays := TotalEstManDays + EstManDays;
                    TotalEstTotalCost := TotalEstTotalCost + EstTotalCost;

                    if WorkUnits > 0 then
                        EstUnitCost := EstTotalCost / WorkUnits
                    else
                        EstUnitCost := 0;
                    TotalEstUnitCost := TotalEstUnitCost + EstUnitCost;
                    TotalWorkUnitsForWeek := 0; //Work Units for Date Range
                    YTDWorkUnits := 0;          //Work Units YTD
                    TotalCost := 0;             //Payroll for Date Range
                    YTDTotalCost := 0;          //Total Cost YTD

                    JobLedgerEntry.RESET;
                    JobLedgerEntry.SETCURRENTKEY("Job No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                                        "NS_Job Cost Category", "Entry Type", "Posting Date");
                    JobLedgerEntry.SETFILTER("Job No.", TempJobBudgetLine."Job No.");
                    JobLedgerEntry.SETFILTER("NS_Activity Code", TempJobBudgetLine."NS_Activity Code");
                    JobLedgerEntry.SETFILTER("NS_Process Code", TempJobBudgetLine."NS_Process Code");
                    JobLedgerEntry.SETFILTER("NS_Job Cost Category", FilterString);
                    JobLedgerEntry.SETRANGE("Entry Type", JobLedgerEntry."Entry Type"::Usage);
                    JobLedgerEntry.SETFILTER("Posting Date", Job.GETFILTER("NS_Date Filter"));
                    if JobLedgerEntry.FINDSET then
                        repeat
                            TotalWorkUnitsForWeek := TotalWorkUnitsForWeek + JobLedgerEntry."NS_Work Units";
                            TotalCost := TotalCost + JobLedgerEntry."Total Cost";
                        until JobLedgerEntry.NEXT = 0;

                    //Now see if there are any Change Order records to add to the ledger side
                    if IncludeChanges then begin
                        SubJob.RESET;
                        SubJob.SETRANGE("NS_Sub-Level to Job No.", TempJobBudgetLine."Job No.");
                        if SubJob.FINDSET then
                            repeat
                                JobLedgerEntry.RESET;
                                JobLedgerEntry.SETCURRENTKEY("Job No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                                                       "NS_Job Cost Category", "Entry Type", "Posting Date");
                                JobLedgerEntry.SETFILTER("Job No.", SubJob."No.");
                                JobLedgerEntry.SETFILTER("NS_Activity Code", TempJobBudgetLine."NS_Activity Code");
                                JobLedgerEntry.SETFILTER("NS_Process Code", TempJobBudgetLine."NS_Process Code");
                                JobLedgerEntry.SETFILTER("NS_Job Cost Category", FilterString);
                                JobLedgerEntry.SETRANGE("Entry Type", JobLedgerEntry."Entry Type"::Usage);
                                JobLedgerEntry.SETFILTER("Posting Date", Job.GETFILTER("NS_Date Filter"));
                                if JobLedgerEntry.FINDSET then
                                    repeat
                                        TotalWorkUnitsForWeek := TotalWorkUnitsForWeek + JobLedgerEntry."NS_Work Units";
                                        TotalCost := TotalCost + JobLedgerEntry."Total Cost";
                                    until JobLedgerEntry.NEXT = 0;
                            until SubJob.NEXT = 0;
                    end;

                    TotalTotalWorkUnitsForWeek := TotalTotalWorkUnitsForWeek + TotalWorkUnitsForWeek;
                    TotalTotalCost := TotalTotalCost + TotalCost;
                    EstInPlace := TotalWorkUnitsForWeek * EstUnitCost;
                    TotalEstInPlace := TotalEstInPlace + EstInPlace;
                    TotalEstInPlaceSummary := TotalEstInPlace;
                    //Get Totals for YTD
                    //Prior Payroll needs to be calced by getting the TotalCost for the week prior to the week entered by the user
                    JobLedgerEntryYTD.RESET;
                    JobLedgerEntryYTD.SETCURRENTKEY("Job No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                                        "NS_Job Cost Category", "Entry Type", "Posting Date");
                    JobLedgerEntryYTD.SETFILTER("Job No.", TempJobBudgetLine."Job No.");
                    JobLedgerEntryYTD.SETFILTER("NS_Activity Code", TempJobBudgetLine."NS_Activity Code");
                    JobLedgerEntryYTD.SETFILTER("NS_Process Code", TempJobBudgetLine."NS_Process Code");
                    JobLedgerEntryYTD.SETFILTER("NS_Job Cost Category", FilterString);
                    JobLedgerEntryYTD.SETRANGE("Entry Type", JobLedgerEntryYTD."Entry Type"::Usage);
                    JobLedgerEntryYTD.SETFILTER("Posting Date", '..%1', YTDDate - 1);
                    if JobLedgerEntryYTD.FINDSET then
                        repeat
                            PriorTotalCost := PriorTotalCost + JobLedgerEntryYTD."Total Cost";
                            TotalWorkUnits := TotalWorkUnits + JobLedgerEntryYTD."NS_Work Units";
                            ItemPriorTotalCost := ItemPriorTotalCost + JobLedgerEntryYTD."Total Cost";
                        until JobLedgerEntryYTD.NEXT = 0;

                    //Now see if there are any Change Order records to add to the ledgerYTD side
                    if IncludeChanges then begin
                        SubJob.RESET;
                        SubJob.SETRANGE("NS_Sub-Level to Job No.", TempJobBudgetLine."Job No.");
                        if SubJob.FINDSET then
                            repeat
                                JobLedgerEntryYTD.RESET;
                                JobLedgerEntryYTD.SETCURRENTKEY("Job No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                                                "NS_Job Cost Category", "Entry Type", "Posting Date");
                                JobLedgerEntryYTD.SETFILTER("Job No.", SubJob."No.");
                                JobLedgerEntryYTD.SETFILTER("NS_Activity Code", TempJobBudgetLine."NS_Activity Code");
                                JobLedgerEntryYTD.SETFILTER("NS_Process Code", TempJobBudgetLine."NS_Process Code");
                                JobLedgerEntryYTD.SETFILTER("NS_Job Cost Category", FilterString);
                                JobLedgerEntryYTD.SETRANGE("Entry Type", JobLedgerEntryYTD."Entry Type"::Usage);
                                JobLedgerEntryYTD.SETFILTER("Posting Date", '..%1', YTDDate - 1);
                                if JobLedgerEntryYTD.FINDSET then
                                    repeat
                                        PriorEst := PriorEst + (EstUnitCost * JobLedgerEntryYTD."NS_Work Units");
                                        TotalWorkUnits := TotalWorkUnits + JobLedgerEntryYTD."NS_Work Units";
                                        PriorTotalCost := PriorTotalCost + JobLedgerEntryYTD."Total Cost";
                                    until JobLedgerEntryYTD.NEXT = 0;
                            until SubJob.NEXT = 0;
                    end;
                    TotalTotalWorkUnits := TotalTotalWorkUnits + TotalWorkUnits;
                    YTDWorkUnits := TotalWorkUnitsForWeek + TotalWorkUnits;
                    YTDTotalCost := TotalCost + PriorTotalCost;

                    //Calc payroll cost to date for all up to date
                    if (TotalWorkUnits + TotalWorkUnitsForWeek) > 0 then
                        ActualCost := (ItemPriorTotalCost + TotalCost) / (TotalWorkUnits + TotalWorkUnitsForWeek)
                    else
                        ActualCost := 0;

                    if EstManDays > 0 then
                        EstTotalCostPerManDays := EstTotalCost / EstManDays
                    else
                        EstTotalCostPerManDays := 0;
                    if EstTotalCostPerManDays > 0 then
                        CostVal := (ItemPriorTotalCost + TotalCost) / EstTotalCostPerManDays
                    else
                        CostVal := 0;
                    if CostVal > 0 then
                        AverageUnitPerMD := (TotalWorkUnits + TotalWorkUnitsForWeek) / CostVal
                    else
                        AverageUnitPerMD := 0;
                    TempJobBudgetLine.NEXT;
                end;

                trigger OnPreDataItem();
                begin
                    TempJobBudgetLine.RESET;
                    NumBudgetLines := TempJobBudgetLine.COUNT;
                    if NumBudgetLines = 0 then
                        CurrReport.BREAK;
                    SETRANGE(Number, 1, NumBudgetLines);
                    TempJobBudgetLine.RESET;
                    TempJobBudgetLine.FINDSET;
                    JobNo := TempJobBudgetLine."Job No.";
                    ActivityCode := TempJobBudgetLine."NS_Activity Code";
                end;
            }

            trigger OnAfterGetRecord();
            begin
                RecCount += 1;
                TempJobBudgetLine.DELETEALL;
                TempJobBudgetLine2.DELETEALL;
            end;

            trigger OnPreDataItem();
            begin
                LastFieldNo := FIELDNO("No.");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                //SMPL
                //Caption = 'RequestPage';
                group(Options)
                {
                    field("Include Changes"; IncludeChanges)
                    {
                        Caption = 'Include Changes';
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
        IncludeChanges := true;
    end;

    trigger OnPreReport();
    begin
        if Job.GETFILTER("NS_Date Filter") = '' then
            ERROR(Text10);

        Pos := STRPOS(Job.GETFILTER("NS_Date Filter"), '..');
        if Pos = 0 then
            ERROR(Text10);
        datestr := COPYSTR(Job.GETFILTER("NS_Date Filter"), 1, Pos - 1);
        EndDate := COPYSTR(Job.GETFILTER("NS_Date Filter"), Pos + 2);

        //break up datestr to use in DMY2Date function
        MonthPos := STRPOS(datestr, '/');
        MonthStr := COPYSTR(datestr, 1, MonthPos - 1);
        EVALUATE(MonthInt, MonthStr);
        ResultStr1 := COPYSTR(datestr, MonthPos + 1);

        DayPos := STRPOS(ResultStr1, '/');
        DayStr := COPYSTR(ResultStr1, 1, DayPos - 1);
        EVALUATE(DayInt, DayStr);
        ResultStr2 := COPYSTR(ResultStr1, DayPos + 1);

        YearStr := COPYSTR(ResultStr2, 1);
        EVALUATE(YearInt, YearStr);
        if YearInt >= 80 then //assume date is in 1900's
            YearInt := YearInt + 1900
        else //Assume date is in the 2000's
            YearInt := YearInt + 2000;

        //use DMY2Date
        YTDDate := DMY2DATE(DayInt, MonthInt, YearInt);

        MonthPos := STRPOS(EndDate, '/');
        MonthStr := COPYSTR(EndDate, 1, MonthPos - 1);
        EVALUATE(MonthInt, MonthStr);
        ResultStr1 := COPYSTR(EndDate, MonthPos + 1);

        DayPos := STRPOS(ResultStr1, '/');
        DayStr := COPYSTR(ResultStr1, 1, DayPos - 1);
        EVALUATE(DayInt, DayStr);
        ResultStr2 := COPYSTR(ResultStr1, DayPos + 1);

        YearStr := COPYSTR(ResultStr2, 1);
        EVALUATE(YearInt, YearStr);
        if YearInt >= 80 then //assume date is in 1900's
            YearInt := YearInt + 1900
        else //Assume date is in the 2000's
            YearInt := YearInt + 2000;

        //use DMY2Date
        YTDEndDate := DMY2DATE(DayInt, MonthInt, YearInt);
    end;

    var
        JobCostCategories: Record "NS_Job Cost Category";
        ActivityCode: Code[10];
        ProcessCode: Code[10];
        JobCode: Code[20];
        WorkUnits: Decimal;
        LastFieldNo: Integer;
        FilterString: Text[50];
        Description1: Text[40];
        Description2: Text[25];
        DisplayLine: Boolean;
        IncludeChanges: Boolean;
        ShowChanges: Boolean;
        EstManDays: Decimal;
        EstTotalCost: Decimal;
        TotalCost: Decimal;
        TotalWorkUnits: Decimal;
        TotalWorkUnitsForWeek: Decimal;
        EstUnitCost: Decimal;
        EstInPlace: Decimal;
        PriorEst: Decimal;
        ActualCost: Decimal;
        PayrollCostToDate: Decimal;
        AverageUnitPerMD: Decimal;
        JourneyManRate: Decimal;
        ChangesText: Text[50];
        YTDEndDate: Date;
        YTDDate: Date;
        JobLedgerEntryYTD: Record "Job Ledger Entry";
        PriorTotalCost: Decimal;
        YTDWorkUnits: Decimal;
        YTDTotalCost: Decimal;
        JobNo: Code[20];
        ActivityCode2: Code[10];
        TempJobBudgetLine: Record "Job Planning Line" temporary;
        NumBudgetLines: Integer;
        TempJobBudgetLine2: Record "Job Planning Line" temporary;
        Pos: Integer;
        datestr: Text[30];
        EndDate: Text[30];
        DayPos: Integer;
        DayStr: Text[3];
        ResultStr1: Text[5];
        MonthPos: Integer;
        MonthStr: Text[3];
        ResultStr2: Text[5];
        YearStr: Text[3];
        DayInt: Integer;
        MonthInt: Integer;
        YearInt: Integer;
        JobHold: Record Job;
        RecCount: Integer;
        JobBudgetLine: Record "Job Planning Line";
        JobLedgerEntry: Record "Job Ledger Entry";
        WorkUnitofMeasure: Code[10];
        TotalEstManDays: Decimal;
        TotalEstInPlace: Decimal;
        TotalEstInPlaceSummary: Decimal;
        TotalTotalCost: Decimal;
        TotalEstTotalCost: Decimal;
        TotalTotalWorkUnits: Decimal;
        TotalTotalWorkUnitsForWeek: Decimal;
        TotalEstUnitCost: Decimal;
        SubJob: Record Job;
        ChangeOrder: Code[20];
        EstCostJobTotal: Decimal;
        ItemPriorTotalCost: Decimal;
        EstTotalCostPerManDays: Decimal;
        CostVal: Decimal;
        Text10: Label 'You must enter a date range in the Date Filter on the Job tab.';
        Job_ProductionCaptionLbl: Label 'Job Production';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Job__CaptionLbl: Label 'Job #';
        Job_NameCaptionLbl: Label 'Job Name';
        Week_EndingCaptionLbl: Label 'Week Ending';
        Job_CodeCaptionLbl: Label 'Job Code';
        DescriptionCaptionLbl: Label 'Description';
        QuantityCaptionLbl: Label 'Quantity';
        Work_Unit_of_MeasureCaptionLbl: Label 'Work Unit of Measure';
        Est_MDCaptionLbl: Label 'Est.MD';
        Est___CaptionLbl: Label 'Est. $';
        Quantity_Job_to_DateCaptionLbl: Label 'Quantity Job to Date';
        Weekly_ProductionCaptionLbl: Label 'Weekly Production';
        Est____In_PlaceCaptionLbl: Label 'Est. $ In Place';
        Payroll_CostCaptionLbl: Label 'Payroll Cost';
        Est__Unit_CostCaptionLbl: Label 'Est. Unit Cost';
        Actual_CostCaptionLbl: Label 'Actual Cost';
        Average_Unit_MDCaptionLbl: Label 'Average Unit/MD';
        TotalCaptionLbl: Label 'Total';
        SummaryCaptionLbl: Label 'Summary';
        Payroll_CostCaption_Control1000000041Lbl: Label 'Payroll Cost';
        Estimated_CostCaptionLbl: Label 'Estimated Cost';
        Ahead__Behind_CaptionLbl: Label 'Ahead (Behind)';
        Previous_TotalsCaptionLbl: Label 'Previous Totals';
        This_WeekCaptionLbl: Label 'This Week';
        Job_TotalsCaptionLbl: Label 'Job Totals';
}

