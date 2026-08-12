page 14021437 "NS_QuoteBudget/BillableFactBox"
{
    //a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-217:AS:21APRIL2020 : Cleared the Caption as it was repeating in PROJECTPRO group & control name was wrong.

    Caption = 'Quote Budget/Billable';
    PageType = CardPart;
    UsageCategory = Documents;
    ApplicationArea = Jobs;
    SourceTable = Job;

    layout
    {
        area(content)
        {
            fixed(Control1100773000)
            {
                Caption = '';//PRJ-217:AS:21APRIL2020
                group(PROJECTPRO)
                {
                    Caption = 'PROJECTPRO';
                    field("'Original'"; 'Original')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';//PRJ-217:AS:21APRIL2020
                    }
                    field("'Adjustments'"; 'Adjustments')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';//PRJ-217:AS:21APRIL2020
                    }
                    field("'Job-Level'"; 'Job-Level')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';//PRJ-217:AS:21APRIL2020
                    }
                    field("'Sub-Level'"; 'Sub-Level')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';//PRJ-217:AS:21APRIL2020
                    }
                    field("'Total'"; 'Total')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';//PRJ-217:AS:21APRIL2020
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
                        ToolTip = 'Specifies the original budget amount.';

                        trigger OnDrillDown();
                        begin
                            JobPlanningList.SetFilters("No.", 0);
                            // >> Upgrade
                            //>>FDD108.01
                            DrilldownReset(JobPlanningList);
                            //<<FDD108.01
                            // << Upgrade
                            JobPlanningList.SetShowAdjustmentLines(Text14021401Lbl);
                            JobPlanningList.RUNMODAL;
                            CLEAR(JobPlanningList);
                        end;
                    }
                    field(AdjustmentBudget; FORMAT(AdjustmentBudget, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Budget Adjustments';
                        Editable = false;
                        ToolTip = 'Specifies the budget adjustment amount.';

                        trigger OnDrillDown();
                        begin
                            JobPlanningList.SetFilters("No.", 0);
                            // >> Upgrade
                            // #146 Start
                            DrilldownResetAndSetApproved(JobPlanningList);
                            DrilldownReset(JobPlanningList);
                            // #146 End
                            // << Upgrade
                            JobPlanningList.SetShowAdjustmentLines(Text14021400Lbl);
                            JobPlanningList.RUNMODAL;
                            CLEAR(JobPlanningList);
                        end;
                    }
                    field(BudgetedCostLCY; FORMAT(JobLevelBudget, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Job-Level';
                        Editable = false;
                        ToolTip = 'Specifies the job level amount.';

                        trigger OnDrillDown();
                        begin
                            JobPlanningList.SetFilters("No.", 0);
                            // >> Upgrade
                            //>>FDD108.01
                            DrilldownReset(JobPlanningList);
                            //<<FDD108.01
                            // << Upgrade
                            JobPlanningList.RUNMODAL;
                            CLEAR(JobPlanningList);
                        end;
                    }
                    field(SubLevelsCost; FORMAT("Sub-LevelsCost", 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Sub-Levels';
                        Editable = false;
                        ToolTip = 'Specifies the sub level amount.';

                        trigger OnDrillDown();
                        begin
                            "Sub-LevelJob".COPY(Rec);
                            "Sub-LevelJob".RESET();
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
                        ToolTip = 'Specifies the total amount.';
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
                        ToolTip = 'Specifies the original contract price.';

                        trigger OnDrillDown();
                        begin
                            JobPlanningList.SetFilters("No.", 1);
                            // >> Upgrade
                            //>>FDD108.01
                            DrilldownReset(JobPlanningList);
                            //<<FDD108.01
                            // << Upgrade
                            JobPlanningList.SetShowAdjustmentLines(Text14021401Lbl);
                            JobPlanningList.RUNMODAL;
                            CLEAR(JobPlanningList);
                        end;
                    }
                    field(AdjustmentContract; FORMAT(AdjustmentContract, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Contract Adjustments';
                        Editable = false;
                        ToolTip = 'Specifies the contract adjustment amount.';

                        trigger OnDrillDown();
                        begin
                            JobPlanningList.SetFilters("No.", 1);
                            // >> Upgrade
                            // #146 Start
                            DrilldownResetAndSetApproved(JobPlanningList);
                            DrilldownReset(JobPlanningList);
                            // #146 End
                            // << Upgrade
                            JobPlanningList.SetShowAdjustmentLines(Text14021400Lbl);
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
                        ToolTip = 'Specifies the contract amount.';

                        trigger OnDrillDown();
                        begin
                            JobPlanningList.SetFilters("No.", 1);
                            // >> Upgrade
                            //>>FDD108.01
                            DrilldownReset(JobPlanningList);
                            //<<FDD108.01
                            // << Upgrade
                            JobPlanningList.RUNMODAL;
                            CLEAR(JobPlanningList);
                        end;
                    }
                    field(SubLevelsPrice; FORMAT("Sub-LevelsPrice", 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Contract Sub-Levels';
                        Editable = false;
                        ToolTip = 'Specifies the contract sub level amount.';

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
                        ToolTip = 'Specifies the total contract amount.';
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
        JobPlanningList: Page "Job Planning Lines";

        OriginalBudget: Decimal;
        OriginalContract: Decimal;
        AdjustmentBudget: Decimal;
        AdjustmentContract: Decimal;
        JobLevelBudget: Decimal;
        JobLevelContract: Decimal;
        "Sub-LevelsCost": Decimal;
        "Sub-LevelsPrice": Decimal;
        Text14021400Lbl: Label 'YES';
        Text14021401Lbl: Label 'NO';
        Text19065341Lbl: Label 'PROJECTPRO';
        Text19073417Lbl: Label '"        Budget (Cost)"';
        Text19055672Lbl: Label '"        Contract (Price)"';
        // >> Upgrade
        "QuotedGP$": Decimal;
        "QuotedGP%": Decimal;
    // << Upgrade

    procedure NS_CalcStatistics();
    // >> Upgrade
    var
        IsHandled: Boolean;
    // << Upgrade
    begin
        JobCalc := Rec;
        JobCalc.RESET();
        // >> Upgrade
        OnBeforeNS_CalcStatistics(Rec, JobCalc, OriginalBudget, OriginalContract, AdjustmentBudget, AdjustmentContract, IsHandled);
        if not IsHandled then begin
            // << Upgrade
            //Calculate original amounts
            JobCalc.SETFILTER("NS_Adjustment Filter", '=%1', '');
            JobCalc.CALCFIELDS("NS_Budgeted Cost (LCY)");
            OriginalBudget := JobCalc."NS_Budgeted Cost (LCY)";

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
            JobLevelBudget := OriginalBudget + AdjustmentBudget;
            JobLevelContract := OriginalContract + AdjustmentContract;

            JobCalc.RESET;

            //Find Revisions Cost and Price
            CLEAR("Sub-LevelsCost");
            CLEAR("Sub-LevelsPrice");
            "Sub-LevelsCost" := NS_SLsBudgetedCost(JobCalc);
            "Sub-LevelsPrice" := NS_SLsBudgetedPrice(JobCalc);

            CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");
            // >> Upgrade
            OnAfterNS_CalcStatistics(Rec, "QuotedGP$", "QuotedGP%");
            // << Upgrade
        end;
        // >> Upgrade
    end;

    [IntegrationEvent(false, false)]
    local procedure DrilldownResetAndSetApproved(var JobPlanningList: Page "Job Planning Lines")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure DrilldownReset(var JobPlanningList: Page "Job Planning Lines")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeNS_CalcStatistics(var Job: Record Job; var JobCalc: Record Job; var OriginalBudget: Decimal; var OriginalContract: Decimal; var AdjustmentBudget: Decimal;
    var AdjustmentContract: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]

    local procedure OnAfterNS_CalcStatistics(var Job: Record Job; var "QuotedGP$": Decimal; var "QuotedGP%": Decimal);
    begin

    end;
    // << Upgrade
}

