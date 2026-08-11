page 14021365 "NS_Job AdjtdBudBillableFactBox"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-340.SK.1.0 - 12AUG2020 - Addedd condition for skipping calculation of fields on new record.
    Caption = 'Job Adjusted Budget/Billable';
    DataCaptionExpression = Caption + "No.";
    PageType = CardPart;
    SourceTable = Job;

    layout
    {
        area(content)
        {
            fixed(Control1100773000)
            {
                Caption = '';
                group(PROJECTPRO)
                {
                    Caption = 'PROJECTPRO';
                    field(OriginalTitle; OriginalTitle)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';
                        ToolTip = 'Original Title'; //PE-75.RM.1.0 23May2023
                    }
                    field(OriginalAdjTitle; OriginalAdjTitle)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Enabled = OriginalBudAdj <> 0;
                        HideValue = OriginalBudAdj = 0;
                        Visible = OriginalBudAdj <> 0;
                        Caption = '';
                        ToolTip = 'Original Adj Title'; //PE-75.RM.1.0 23May2023
                    }
                    field(TotalOriginalTitle; TotalOriginalTitle)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Visible = OriginalBudAdj <> 0;
                        Caption = '';
                        ToolTip = 'Total Original Title'; //PE-75.RM.1.0 23May2023
                    }
                    field(AdjustmentsTitle; AdjustmentsTitle)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';
                        ToolTip = 'Adjustments Title'; //PE-75.RM.1.0 23May2023
                    }
                    field(JobLevelTitle; JobLevelTitle)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';
                        ToolTip = 'Job Level Title'; //PE-75.RM.1.0 23May2023
                    }
                    field(SubLevelTitle; SubLevelTitle)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';
                        ToolTip = 'Sub Level Title'; //PE-75.RM.1.0 23May2023
                    }
                    field(TotalTitle; TotalTitle)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';
                        ToolTip = 'Total Title'; //PE-75.RM.1.0 23May2023
                    }
                }
                group("Budget (Cost)")
                {
                    Caption = 'Budget (Cost)';
                    field(OriginalBudget; FORMAT(OriginalBudget, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Original Budget';
                        Editable = false;
                        ToolTip = 'Original Budget'; //PE-75.RM.1.0 23May2023

                        trigger OnDrillDown();
                        begin
                            OriginalJobPlanningLine.RESET;
                            OriginalJobPlanningLine.SETRANGE("NS_Job No.", "No.");
                            JobPlanningListOriginal.SETTABLEVIEW(OriginalJobPlanningLine);
                            JobPlanningListOriginal.RUN;
                        end;
                    }
                    field(OriginalBudAdj; OriginalBudAdj)
                    {
                        ApplicationArea = All;
                        AutoFormatType = 11;
                        AutoFormatExpression = '<Precision,2:2><Sign><Integer Thousand><Decimals>';
                        BlankNumbers = BlankZero;
                        BlankZero = true;
                        Caption = 'Original Budget Adjustments';
                        Editable = false;
                        Enabled = OriginalBudAdj <> 0;
                        HideValue = OriginalBudAdj = 0;
                        Visible = OriginalBudAdj <> 0;
                        ToolTip = 'Original Bud Adj'; //PE-75.RM.1.0 23May2023
                    }
                    field(OriginalBudTotal; FORMAT(OriginalBudTotal, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Original Budget Total';
                        Editable = false;
                        Visible = OriginalBudAdj <> 0;
                        ToolTip = 'Original Bud Total'; //PE-75.RM.1.0 23May2023
                        trigger OnDrillDown();
                        begin
                            JobPlanningList.SetFilters("No.", 0);
                            JobPlanningList.SetShowAdjustmentLines(Text14021401);
                            JobPlanningList.RUNMODAL;
                            CLEAR(JobPlanningList);
                        end;
                    }
                    field(AdjustmentBudget; FORMAT(AdjustmentBudget, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Budget Adjustments';
                        Editable = false;
                        ToolTip = 'Adjustment Budget'; //PE-75.RM.1.0 23May2023

                        trigger OnDrillDown();
                        begin
                            JobPlanningList.SetFilters("No.", 0);
                            JobPlanningList.SetShowAdjustmentLines(Text14021400);
                            JobPlanningList.RUNMODAL;
                            CLEAR(JobPlanningList);
                        end;
                    }
                    field(BudgetedCostLCY; FORMAT(JobLevelBudget, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Job-Level';
                        Editable = false;
                        ToolTip = 'Budgeted Cost LCY'; //PE-75.RM.1.0 23May2023

                        trigger OnDrillDown();
                        begin
                            JobPlanningList.SetFilters("No.", 0);
                            JobPlanningList.RUNMODAL;
                            CLEAR(JobPlanningList);
                        end;
                    }
                    field(SubLevelsCost; FORMAT("Sub-LevelsCost", 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Sub-Levels';
                        Editable = false;
                        ToolTip = 'Sub Level Cost'; //PE-75.RM.1.0 23May2023

                        trigger OnDrillDown();
                        begin
                            "Sub-LevelJob".COPY(Rec);
                            "Sub-LevelJob".RESET;
                            "Sub-LevelJob".SETRANGE("NS_Sub-Level to Job No.", "No.");
                            "Sub-LevelJob".SETFILTER(Status, '>%1', "Sub-LevelJob".Status::Planning);
                            PAGE.RUN(PAGE::"Job List", "Sub-LevelJob");
                        end;
                    }
                    field("FORMAT(JobLevelBudget+""Sub-LevelsCost"",14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(JobLevelBudget + "Sub-LevelsCost", 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Total';
                        Editable = false;
                        ToolTip = 'Job Level Budget'; //PE-75.RM.1.0 23May2023
                    }
                }
                group("Billable (Price)")
                {
                    Caption = 'Billable (Price)';
                    field(OriginalContract; FORMAT(OriginalContract, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Original Contract';
                        DrillDownPageID = "Job Planning Lines";
                        Editable = false;
                        ToolTip = 'Original Contract'; //PE-75.RM.1.0 23May2023

                        trigger OnDrillDown();
                        begin
                            JobPlanningList.SetFilters("No.", 1);
                            JobPlanningList.SetShowAdjustmentLines(Text14021401);
                            JobPlanningList.RUNMODAL;
                            CLEAR(JobPlanningList);
                        end;
                    }
                    field(OriginalContractAdj; OriginalContAdj)
                    {
                        ApplicationArea = All;
                        AutoFormatType = 11;
                        AutoFormatExpression = '<Precision,2:2><Sign><Integer Thousand><Decimals>';
                        BlankZero = true;
                        Caption = 'Original Contract Adjustments';
                        Editable = false;
                        Enabled = OriginalContAdj <> 0;
                        HideValue = OriginalBudAdj = 0;
                        Visible = OriginalContAdj <> 0;
                        ToolTip = 'Original Contract Adj'; //PE-75.RM.1.0 23May2023
                    }
                    field(OriginalContractTotal; FORMAT(OriginalContTotal, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Original Contract Total';
                        Editable = false;
                        Visible = OriginalContAdj <> 0;
                        ToolTip = 'Original Contract Total'; //PE-75.RM.1.0 23May2023
                    }
                    field(AdjustmentContract; FORMAT(AdjustmentContract, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Contract Adjustments';
                        Editable = false;
                        ToolTip = 'Adjustment Contract'; //PE-75.RM.1.0 23May2023

                        trigger OnDrillDown();
                        begin
                            JobPlanningList.SetFilters("No.", 1);
                            JobPlanningList.SetShowAdjustmentLines(Text14021400);
                            JobPlanningList.RUNMODAL;
                            CLEAR(JobPlanningList);
                        end;
                    }
                    field(BudgetedPriceLCY; FORMAT(JobLevelContract, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Contract Amount';
                        DrillDownPageID = "Job Planning Lines";
                        Editable = false;
                        ToolTip = 'Budgeted Price LCY'; //PE-75.RM.1.0 23May2023

                        trigger OnDrillDown();
                        begin
                            JobPlanningList.SetFilters("No.", 1);
                            JobPlanningList.RUNMODAL;
                            CLEAR(JobPlanningList);
                        end;
                    }
                    field(SubLevelsPrice; FORMAT("Sub-LevelsPrice", 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Contract Sub-Levels';
                        Editable = false;
                        ToolTip = 'Sub Levels Price'; //PE-75.RM.1.0 23May2023

                        trigger OnDrillDown();
                        begin
                            "Sub-LevelJob".COPY(Rec);
                            "Sub-LevelJob".RESET;
                            "Sub-LevelJob".SETRANGE("NS_Sub-Level to Job No.", "No.");
                            "Sub-LevelJob".SETFILTER(Status, '>%1', "Sub-LevelJob".Status::Planning);
                            PAGE.RUN(PAGE::"Job List", "Sub-LevelJob");
                        end;
                    }
                    field("FORMAT(JobLevelContract+""Sub-LevelsPrice"",14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(JobLevelContract + "Sub-LevelsPrice", 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Total Contract';
                        Editable = false;
                        ToolTip = 'Job Level Contract'; //PE-75.RM.1.0 23May2023
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        NS_CalcStatistics;
    end;

    var
        "Sub-LevelJob": Record Job;
        JobCalc: Record Job;
        OriginalJobPlanningLine: Record "NS_Locked Job Planning Line";
        OriginalBudget: Decimal;
        OriginalContract: Decimal;
        OriginalBudAdj: Decimal;
        OriginalContAdj: Decimal;
        OriginalBudTotal: Decimal;
        OriginalContTotal: Decimal;
        AdjustmentBudget: Decimal;
        AdjustmentContract: Decimal;
        JobLevelBudget: Decimal;
        JobLevelContract: Decimal;
        "Sub-LevelsCost": Decimal;
        "Sub-LevelsPrice": Decimal;
        Text14021400: Label 'YES';
        Text14021401: Label 'NO';
        Text19065341: Label 'PROJECTPRO';
        Text19073417: Label '"        Budget (Cost)"';
        Text19055672: Label '"        Contract (Price)"';
        JobPlanningList: Page "Job Planning Lines";
        OriginalTitle: Label 'Original';
        OriginalAdjTitle: Label 'Original Adj';
        TotalOriginalTitle: Label 'Original Total';
        AdjustmentsTitle: Label 'Adjustments';
        JobLevelTitle: Label 'Job-Level';
        SubLevelTitle: Label 'Sub-Level';
        TotalTitle: Label 'Total';
        JobPlanningListOriginal: Page "NS_Job Planning List (Locked)";
        Caption: Label 'Original Budget';

    procedure NS_CalcStatistics();
    begin
        //PRJ-340.SK.1.0 Start
        IF "No." = '' Then
            Exit;
        //PRJ-340.SK.1.0 End
        JobCalc := Rec;
        JobCalc.RESET();

        //Calculate original amounts
        JobCalc.SETFILTER("NS_Adjustment Filter", '=%1', '');

        //Find the original budget, current budget and the difference
        JobCalc.CALCFIELDS("NS_Locked Budget Cost (LCY)");
        OriginalBudget := JobCalc."NS_Locked Budget Cost (LCY)";
        JobCalc.CALCFIELDS("NS_Budgeted Cost (LCY)");
        OriginalBudTotal := JobCalc."NS_Budgeted Cost (LCY)";
        OriginalBudAdj := OriginalBudTotal - OriginalBudget;

        //Find current Contract
        JobCalc.CALCFIELDS("NS_Budgeted Price (LCY)");
        OriginalContract := JobCalc."NS_Budgeted Price (LCY)";

        //Calculate adjusted amounts
        JobCalc.SETFILTER("NS_Adjustment Filter", '>%1', '');
        JobCalc.CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");
        AdjustmentBudget := JobCalc."NS_Budgeted Cost (LCY)";
        AdjustmentBudget := AdjustmentBudget + NS_SLsBudgetedCost(JobCalc);
        AdjustmentContract := JobCalc."NS_Budgeted Price (LCY)";
        AdjustmentContract := AdjustmentContract + NS_SLsBudgetedPrice(JobCalc);

        //Calculate total Job Level values
        JobLevelBudget := OriginalBudTotal + AdjustmentBudget;
        JobLevelContract := OriginalContract + AdjustmentContract;

        JobCalc.RESET();

        //Find Revisions Cost and Price
        CLEAR("Sub-LevelsCost");
        CLEAR("Sub-LevelsPrice");
        "Sub-LevelsCost" := NS_SLsBudgetedCost(JobCalc);
        "Sub-LevelsPrice" := NS_SLsBudgetedPrice(JobCalc);

        CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");
    end;

    //SMPL - OriginalBudAdj replaced source expression with format to AutoFormatType + AutoFormatExpr
    //SMPL - OriginalContractAdj replaced source expression with format to AutoFormatType + AutoFormatExpr
}

