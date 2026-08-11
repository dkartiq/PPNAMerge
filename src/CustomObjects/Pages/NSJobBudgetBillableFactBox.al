page 14021356 "NS_Job Budget/Billable FactBox"
{
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-187.AS.1.0 - 2APRIL2020 - Removed Locked (Price) coloumn, commented for now.
    //PPAL-12.AM.1.0 - 2JUNE2020 - Changed the property of page
    //PRJ-340.SK.1.0 - 12AUG2020 - Addedd condition for skipping calculation of fields on new record.
    //PRJ-421.MS.1.0 new changes for job card factbox
    //PRJ-659.RM.1.0 20Oct2021 | Alligned Rows from center to right
    Caption = 'Job Budget/Billable';
    //PageType = Cardpart;//PPAL-12.AM Commented
    PageType = ListPart;//PPAL-12.AM Added
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

                    field("'Original'"; 'Original')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';
                    }
                    field("'Adjustments'"; 'Adjustments')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';
                    }
                    field("'Job-Level'"; 'Job-Level')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';
                    }
                    field("'Sub-Level'"; 'Sub-Level')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';
                    }
                    field("'Total'"; 'Total')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';
                    }
                }
                group("Locked (Cost)")
                {
                    Caption = '                                        Locked (Cost)'; //PRJ-659.RM.1.0 20Oct2021

                    // field(LockedCost; FORMAT(LockedCost, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>')) //PRJ-659.RM.1.0 20Oct2021
                    field(LockedCost; Round(LockedCost, 0.01)) //PRJ-659.RM.1.0 20Oct2021
                    {
                        ApplicationArea = All;
                        Caption = 'Locked Cost';

                        trigger OnDrillDown();
                        begin
                            LockedJobPlanningList.NS_SetFilters("No.", 0);
                            LockedJobPlanningList.NS_SetShowAdjustmentLines(Text14021101);
                            LockedJobPlanningList.RUNMODAL;
                            CLEAR(LockedJobPlanningList);
                        end;
                    }
                    // field(LockedAdjustmentCost; FORMAT(LockedAdjustCost, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))//PRJ-659.RM.1.0 20Oct2021
                    field(LockedAdjustCost; Round(LockedAdjustCost, 0.01))//PRJ-659.RM.1.0 20Oct2021
                    {
                        ApplicationArea = All;
                        Caption = 'Locked Adjustment Cost';

                        trigger OnDrillDown();
                        begin
                            LockedJobPlanningList.NS_SetFilters("No.", 0);
                            LockedJobPlanningList.NS_SetShowAdjustmentLines(Text14021100);
                            LockedJobPlanningList.RUNMODAL;
                            CLEAR(LockedJobPlanningList);
                        end;
                    }
                    // field("LockedJob-LevelCost"; FORMAT(LockedJobLevelCost, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>')) //PRJ-659.RM.1.0 20Oct2021
                    field(LockedJobLevelCost; Round(LockedJobLevelCost, 0.01))//PRJ-659.RM.1.0 20Oct2021
                    {
                        ApplicationArea = All;
                        Caption = 'Locked Job-Level Cost';

                        trigger OnDrillDown();
                        begin
                            LockedJobPlanningList.NS_SetFilters("No.", 0);
                            LockedJobPlanningList.RUNMODAL;
                            CLEAR(LockedJobPlanningList);
                        end;
                    }
                    // field("LockedSub-LevelCost"; FORMAT(LockedSubLevelCost, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>')) //PRJ-659.RM.1.0 20Oct2021
                    field(LockedSubLevelCost; Round(LockedSubLevelCost, 0.01)) //PRJ-659.RM.1.0 20Oct2021
                    {
                        ApplicationArea = All;
                        Caption = 'Locked Sub-Level Cost';

                        trigger OnDrillDown();
                        begin
                            "Sub-LevelJob".COPY(Rec);
                            "Sub-LevelJob".RESET;
                            "Sub-LevelJob".SETRANGE("NS_Sub-Level to Job No.", "No.");
                            "Sub-LevelJob".SETFILTER(Status, '>%1', "Sub-LevelJob".Status::Planning);
                            PAGE.RUN(PAGE::"Job List", "Sub-LevelJob");
                        end;
                    }
                    // field(LockedCostTotal; FORMAT(LockedJobLevelCost + LockedSubLevelCost, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>')) //PRJ-659.RM.1.0 20Oct2021
                    field(LockedJobSubLevel; Round(LockedJobSubLevel, 0.01)) //PRJ-659.RM.1.0 20Oct2021
                    {
                        ApplicationArea = All;
                        Caption = 'Locked Cost Total';
                    }
                }
                group("Budget (Cost)")
                {
                    Caption = '                                         Budget (Cost)'; //PRJ-659.RM.1.0 20Oct2021
                    // field(OriginalBudget; FORMAT(OriginalBudget, 10, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))//PRJ-659.RM.1.0 20Oct2021
                    field(OriginalBudget; Round(OriginalBudget, 0.01)) //PRJ-659.RM.1.0 20Oct2021
                    {
                        ApplicationArea = All;
                        Caption = 'Original Budget';
                        Editable = false;

                        trigger OnDrillDown();
                        begin
                            JobPlanningList.SetFilters("No.", 0);
                            JobPlanningList.SetShowAdjustmentLines(Text14021101);
                            JobPlanningList.RUNMODAL;
                            CLEAR(JobPlanningList);
                        end;
                    }

                    // field(AdjustmentBudget; FORMAT(AdjustmentBudget, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))//PRJ-659.RM.1.0 20Oct2021
                    field(AdjustmentBudget; Round(AdjustmentBudget, 0.01)) //PRJ-659.RM.1.0 20Oct2021
                    {
                        ApplicationArea = All;
                        Caption = 'Budget Adjustments';
                        Editable = false;

                        trigger OnDrillDown();
                        begin
                            JobPlanningList.SetFilters("No.", 0);
                            JobPlanningList.SetShowAdjustmentLines(Text14021100);
                            JobPlanningList.RUNMODAL;
                            CLEAR(JobPlanningList);
                        end;
                    }
                    // field(BudgetedCostLCY; FORMAT(JobLevelBudget, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>')) //PRJ-659.RM.1.0 20Oct2021
                    field(BudgetedCostLCY; Round("NS_Budgeted Cost (LCY)", 0.01)) //PRJ-659.RM.1.0 20Oct2021
                    {
                        ApplicationArea = All;
                        Caption = 'Job-Level';
                        Editable = false;

                        trigger OnDrillDown();
                        begin
                            JobPlanningList.SetFilters("No.", 0);
                            JobPlanningList.RUNMODAL;
                            CLEAR(JobPlanningList);
                        end;
                    }
                    // field(SubLevelsCost; FORMAT("Sub-LevelsCost", 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>')) //PRJ-659.RM.1.0 20Oct2021
                    field("Sub-LevelsCost"; Round("Sub-LevelsCost", 0.01)) //PRJ-659.RM.1.0 20Oct2021
                    {
                        ApplicationArea = All;
                        Caption = 'Sub-Levels';
                        Editable = false;

                        trigger OnDrillDown();
                        begin
                            "Sub-LevelJob".COPY(Rec);
                            "Sub-LevelJob".RESET();
                            "Sub-LevelJob".SETRANGE("NS_Sub-Level to Job No.", "No.");
                            "Sub-LevelJob".SETFILTER(Status, '>%1', "Sub-LevelJob".Status::Planning);
                            PAGE.RUN(PAGE::"Job List", "Sub-LevelJob");
                        end;
                    }
                    // field("FORMAT(JobLevelBudget+""Sub-LevelsCost"",20,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(JobLevelBudget + "Sub-LevelsCost", 20, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))//PRJ-659.RM.1.0 20Oct2021

                    field(JobSubTotal; Round(JobSubTotal, 0.01)) //PRJ-659.RM.1.0 20Oct2021


                    {
                        ApplicationArea = All;
                        Caption = 'Total';
                        Editable = false;
                    }
                }

                group("Billable (Price)")
                {
                    Caption = '                                      Billable (Price)'; //PRJ-659.RM.1.0 20Oct2021
                    // field(OriginalContract; FORMAT(OriginalContract, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>')) //PRJ-659.RM.1.0 20Oct2021
                    field(OriginalContract; Round(OriginalContract, 0.01)) //PRJ-659.RM.1.0 20Oct2021
                    {
                        ApplicationArea = All;
                        Caption = 'Original Contract';
                        DrillDownPageID = "Job Planning Lines";
                        Editable = false;

                        trigger OnDrillDown();
                        begin
                            JobPlanningList.SetFilters("No.", 1);
                            JobPlanningList.SetShowAdjustmentLines(Text14021101);
                            JobPlanningList.RUNMODAL;
                            CLEAR(JobPlanningList);
                        end;
                    }
                    // field(AdjustmentContract; FORMAT(AdjustmentContract, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>')) //PRJ-659.RM.1.0 20Oct2021
                    field(AdjustmentContract; Round(AdjustmentContract, 0.01)) //PRJ-659.RM.1.0 20Oct2021
                    {
                        ApplicationArea = All;
                        Caption = 'Contract Adjustments';
                        Editable = false;

                        trigger OnDrillDown();
                        begin
                            JobPlanningList.SetFilters("No.", 1);
                            JobPlanningList.SetShowAdjustmentLines(Text14021100);
                            JobPlanningList.RUNMODAL;
                            CLEAR(JobPlanningList);
                        end;
                    }
                    // field(BudgetedPriceLCY; FORMAT(JobLevelContract, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>')) //PRJ-659.RM.1.0 20Oct2021
                    field("NS_Budgeted Price (LCY)"; Round("NS_Budgeted Price (LCY)", 0.01)) //PRJ-659.RM.1.0 20Oct2021
                    {
                        ApplicationArea = All;
                        Caption = 'Contract Amount';
                        DrillDownPageID = "Job Planning Lines";
                        Editable = false;

                        trigger OnDrillDown();
                        begin
                            JobPlanningList.SetFilters("No.", 1);
                            JobPlanningList.RUNMODAL;
                            CLEAR(JobPlanningList);
                        end;
                    }
                    // field(SubLevelsPrice; FORMAT("Sub-LevelsPrice", 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>')) //PRJ-659.RM.1.0 20Oct2021
                    field("Sub-LevelsPrice"; Round("Sub-LevelsPrice", 0.01)) //PRJ-659.RM.1.0 20Oct2021
                    {
                        ApplicationArea = All;
                        Caption = 'Contract Sub-Levels';
                        Editable = false;

                        trigger OnDrillDown();
                        begin
                            "Sub-LevelJob".COPY(Rec);
                            "Sub-LevelJob".RESET;
                            "Sub-LevelJob".SETRANGE("NS_Sub-Level to Job No.", "No.");
                            "Sub-LevelJob".SETFILTER(Status, '>%1', "Sub-LevelJob".Status::Planning);
                            PAGE.RUN(PAGE::"Job List", "Sub-LevelJob");
                        end;
                    }
                    // field("FORMAT(JobLevelContract+""Sub-LevelsPrice"",14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(JobLevelContract + "Sub-LevelsPrice", 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>')) //PRJ-659.RM.1.0 20Oct2021
                    field(ContractTotal; Round(ContractTotal, 0.01)) //PRJ-659.RM.1.0 20Oct2021
                    {
                        ApplicationArea = All;
                        Caption = 'Total Contract';
                        Editable = false;
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
    // >> Upgrade
    protected var
        [InDataSet]
        OriginalBudget: Decimal;
        JobPlanningList: Page "Job Planning Lines";
        Text14021101: Label 'NO';
        AdjustmentBudget: Decimal;
        Text14021100: Label 'YES';
        AdjustmentContract: Decimal;

        AdjustmentBudgetNC: Decimal;
        AdjustmentContractNC: Decimal;
        OriginalContract: Decimal;
    // << Upgrade
    var
        "Sub-LevelJob": Record Job;
        JobCalc: Record Job;
        // OriginalBudget: Decimal;
        // OriginalContract: Decimal;
        // AdjustmentBudget: Decimal;
        // AdjustmentContract: Decimal;
        JobLevelBudget: Decimal;
        AllJobLevel: Decimal; //PRJ-659.RM.1.0 20Oct2021
        JobSubTotal: Decimal; //PRJ-659.RM.1.0 20Oct2021
        JobLevelContract: Decimal;
        ContractTotal: Decimal; //PRJ-659.RM.1.0 20Oct2021
        "Sub-LevelsCost": Decimal;
        AllTotalBudget: Decimal; //PRJ-659.RM.1.0 20Oct2021
        "Sub-LevelsPrice": Decimal;
        // Text14021100: Label 'YES';
        // Text14021101: Label 'NO';
        Text19065341: Label 'PROJECTPRO';
        Text19073417: Label '"        Budget (Cost)"';
        Text19055672: Label '"        Contract (Price)"';
        // JobPlanningList: Page "Job Planning Lines";
        LockedCost: Decimal;
        LockedPrice: Decimal;
        LockedAdjustCost: Decimal;
        LockedAdjustPrice: Decimal;
        LockedJobLevelCost: Decimal;
        LockedJobSubLevel: Decimal; //PRJ-659.RM.1.0 20Oct2021
        LockedJobLevelPrice: Decimal;
        LockedSubLevelCost: Decimal;
        LockedSubLevelPrice: Decimal;
        LockedTotalPrice: Decimal;
        LockedTotalCost: Decimal;
        LockedJobPlanningList: Page "NS_Job Planning List (Locked)";

    procedure NS_CalcStatistics();
    var
        IsHandled: Boolean;
        OrigJobPlanLine: Record "NS_Locked Job Planning Line";
        l_JPL: Record "Job Planning Line";
        l_JPL2: Record "Job Planning Line";
        TotalCostLCYAdj: Decimal;
        TotalCostLCYNCAdj: Decimal;
        TotalCostLCYOrig: Decimal;
        TotalPriceLCYOrig: Decimal;
        TotalPriceAdj: Decimal;
        TotalPriceAdjNC: Decimal;
    begin
        //FDD108 Start
        if "NS_Sub-Level to Job No." = "No." then
            exit;
        //FDD108 End
        //PRJ-340.SK.1.0 Start
        IF "No." = '' Then
            Exit;
        //PRJ-340.SK.1.0 End
        JobCalc := Rec;
        JobCalc.RESET;

        //Calculate original amounts
        // >> Upgrade
        Calculateoriginalamounts(Rec, JobCalc, OriginalBudget, OriginalContract, AdjustmentBudget, AdjustmentBudgetNC, AdjustmentContract, AdjustmentContractNC, IsHandled);
        if not IsHandled then begin
            JobCalc.SETFILTER("NS_Adjustment Filter", '=%1', '');

            JobCalc.CALCFIELDS("NS_Budgeted Cost (LCY)");
            OriginalBudget := JobCalc."NS_Budgeted Cost (LCY)";

            JobCalc.CALCFIELDS("NS_Budgeted Price (LCY)");
            OriginalContract := JobCalc."NS_Budgeted Price (LCY)";

            //Calculate adjusted amounts
            JobCalc.SETFILTER("NS_Adjustment Filter", '>%1', '');
            JobCalc.CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");
            AdjustmentBudget := JobCalc."NS_Budgeted Cost (LCY)";
            //AdjustmentBudget := AdjustmentBudget + NS_SLsBudgetedCost(JobCalc);//PRJ-421.MS.1.0
            AdjustmentContract := JobCalc."NS_Budgeted Price (LCY)";
            //AdjustmentContract := AdjustmentContract + NS_SLsBudgetedPrice(JobCalc);//PRJ-421.MS.1.0
        end;
        AdjustmentBudget := AdjustmentBudget + NS_SLsBudgetedCost(JobCalc);
        AdjustmentContract := AdjustmentContract + NS_SLsBudgetedPrice(JobCalc);
        // << Upgrade
        //Calculate total Job Level values
        JobLevelBudget := OriginalBudget + AdjustmentBudget;
        JobLevelContract := OriginalContract + AdjustmentContract;
        AllJobLevel := JobLevelBudget; //PRJ-659.RM.1.0 20Oct2021
        JobCalc.RESET;

        //Find Revisions Cost and Price
        CLEAR("Sub-LevelsCost");
        CLEAR("Sub-LevelsPrice");
        //PRJ-659.RM.1.0 20Oct2021 start
        Clear(AllTotalBudget);
        Clear(ContractTotal);
        Clear(JobSubTotal);
        //PRJ-659.RM.1.0 20Oct2021 end
        "Sub-LevelsCost" := NS_SLsBudgetedCost(JobCalc);
        "Sub-LevelsPrice" := NS_SLsBudgetedPrice(JobCalc);
        //PRJ-659.RM.1.0 20Oct2021 start
        AllTotalBudget := "Sub-LevelsCost";
        ContractTotal := JobLevelContract + "Sub-LevelsPrice";
        JobSubTotal := AllJobLevel + AllTotalBudget;
        //PRJ-659.RM.1.0 20Oct2021 end

        CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");

        JobCalc.CALCFIELDS("NS_Locked Budget Cost (LCY)");
        LockedCost := JobCalc."NS_Locked Budget Cost (LCY)";

        JobCalc.CALCFIELDS("NS_Locked Budget Price (LCY)");
        LockedPrice := JobCalc."NS_Locked Budget Price (LCY)";

        JobCalc.SETFILTER("NS_Adjustment Filter", '>%1', '');
        JobCalc.CALCFIELDS("NS_Locked Budget Cost (LCY)", "NS_Locked Budget Price (LCY)");
        LockedAdjustCost := JobCalc."NS_Locked Budget Cost (LCY)" + NS_LockedSLsBudgetedCost(JobCalc);
        LockedAdjustPrice := JobCalc."NS_Locked Budget Price (LCY)" + NS_LockedSLsBudgetedPrice(JobCalc);

        LockedJobLevelCost := LockedCost + LockedAdjustCost;
        LockedJobLevelPrice := LockedPrice + LockedAdjustPrice;

        JobCalc.RESET();
        CLEAR(LockedSubLevelCost);
        CLEAR(LockedSubLevelPrice);
        Clear(LockedJobSubLevel); //PRJ-659.RM.1.0 20Oct2021
        LockedSubLevelCost := NS_LockedSLsBudgetedCost(JobCalc);
        LockedSubLevelPrice := NS_LockedSLsBudgetedPrice(JobCalc);
        LockedJobSubLevel := LockedJobLevelCost + LockedSubLevelCost; //PRJ-659.RM.1.0 20Oct2021
    end;
    // >> Upgrade
    [IntegrationEvent(false, false)]
    local procedure Calculateoriginalamounts(var Job: Record Job; var JobCalc: Record Job; var OriginalBudget: Decimal; var OriginalContract: Decimal; var AdjustmentBudget: Decimal; var AdjustmentBudgetNC: Decimal;
    var AdjustmentContract: Decimal; var AdjustmentContractNC: Decimal; var IsHandled: Boolean)
    begin
    end;
    // << Upgrade

}

