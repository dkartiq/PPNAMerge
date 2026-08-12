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
    //MHNA-6.RM.1.0 29March2023 | Rectified caption
    //PE-75.RM.1.0 17May2023 | Added some tooltips
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
                        ToolTip = 'Specifies the values of Locked Cost, Budgeted(Cost), Locked Revenue and Billable(Price) for Master Job'; //PE-75.RM.1.0 17May2023
                    }
                    field("'Sub-Level'"; 'Sub-Level')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';
                        ToolTip = 'Specifies the values of Locked Cost, Budgeted(Cost), Locked Revenue and Billable(Price) for Sub-Level Job'; //PE-75.RM.1.0 17May2023
                    }
                    field("'Total'"; 'Total')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';
                    }
                    //PE-193.PS.1.0 27Dec2023 Start
                    field("'Change Request'"; 'Change Request')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';
                    }
                    //PE-193.PS.1.0 27Dec2023 End
                }
                group("Locked (Cost)")
                {
                    // Caption = '                                        Locked (Cost)'; //PRJ-659.RM.1.0 20Oct2021 //MHNA-6.RM.1.0 29March2023 commented
                    Caption = '                             Locked (Cost)'; //MHNA-6.RM.1.0 29March2023
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
                    field(LockedAdjustmentCost; FORMAT(LockedAdjustCost, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
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
                    field("LockedJob-LevelCost"; FORMAT(LockedJobLevelCost, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Locked Job-Level Cost';
                        ToolTip = 'Specifies the cost which has been locked in the Job Planning Lines for Master Job'; //PE-75.RM.1.0 17May2023

                        trigger OnDrillDown();
                        begin
                            LockedJobPlanningList.NS_SetFilters("No.", 0);
                            LockedJobPlanningList.RUNMODAL;
                            CLEAR(LockedJobPlanningList);
                        end;
                    }
                    field("LockedSub-LevelCost"; FORMAT(LockedSubLevelCost, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Locked Sub-Level Cost';
                        ToolTip = 'Specifies the cost which has been locked in the Job Planning Lines for Sub-Level Job'; //PE-75.RM.1.0 17May2023
                        trigger OnDrillDown();
                        begin
                            //PE-133.NC.1.0 21July2023 Start
                            if StrLen(format(Rec."No.")) < 18 then
                                JobNoFilter := '@*' + format(Rec."No.") + '*'
                            else
                                JobNoFilter := format(Rec."No.");
                            //PE-133.NC.1.0 21July2023 End
                            "Sub-LevelJob".COPY(Rec);
                            "Sub-LevelJob".RESET;
                            //"Sub-LevelJob".SETRANGE("NS_Sub-Level to Job No.", Rec."No.");//PRJ-1131.RM.1.0 10Jan2022 //PE-133.NC.1.0 21July2023 Block
                            "Sub-LevelJob".SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter); //PE-133.NC.1.0 21July2023
                            "Sub-LevelJob".SETFILTER(Status, '>%1', "Sub-LevelJob".Status::Planning);
                            PAGE.RUN(PAGE::"Job List", "Sub-LevelJob");
                        end;
                    }
                    field(LockedCostTotal; FORMAT(LockedJobLevelCost + LockedSubLevelCost, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Locked Cost Total';
                        ToolTip = 'Specifies Total Cost which has been locked as part of initial budget in Job Planning Lines.'; //PE-75.RM.1.0 17May2023
                    }
                    // PE-193.PS.3.0 04Jan2024 Start
                    field(ChangeRequst1; Round(ChangeRequst, 0.01))
                    {
                        ApplicationArea = All;
                        Caption = 'Change Request value Locked';
                    }
                    // PE-193.PS.3.0 04Jan2024 End 
                }
                group("Budget (Cost)")
                {
                    // Caption = '                                         Budget (Cost)'; //PRJ-659.RM.1.0 20Oct2021 //MHNA-6.RM.1.0 29March2023 commented
                    Caption = '                           Budget (Cost)'; //MHNA-6.RM.1.0 29March2023
                    // field(OriginalBudget; FORMAT(OriginalBudget, 10, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))//PRJ-659.RM.1.0 20Oct2021
                    field(OriginalBudget; Round(OriginalBudget, 0.01)) //PRJ-659.RM.1.0 20Oct2021
                    {
                        ApplicationArea = All;
                        Caption = 'Original Budget';
                        ToolTip = 'Specifies the value of all the Budgeted Lines which have been defined as primary budget on locked Job Planning Lines.';//PE-75.RM.1.0 17May2023
                        Editable = false;

                        trigger OnDrillDown();
                        begin
                            JobPlanningList.SetFilters("No.", 0);
                            JobPlanningList.SetShowAdjustmentLines(Text14021101);
                            JobPlanningList.RUNMODAL;
                            CLEAR(JobPlanningList);
                        end;
                    }
                    field(AdjustmentBudget; FORMAT(AdjustmentBudget, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
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
                    field(BudgetedCostLCY; FORMAT(JobLevelBudget, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Job-Level';
                        ToolTip = 'Specifies the value of all the Budgeted Lines of the Master Job'; //PE-75.RM.1.0 17May2023
                        Editable = false;

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
                        ToolTip = 'Specifies the value of all the Budgeted Lines of the Sub-level Job'; //PE-75.RM.1.0 17May2023
                        Editable = false;

                        trigger OnDrillDown();
                        begin
                            //PE-133.NC.1.0 21July2023 Start
                            if StrLen(format(Rec."No.")) < 18 then
                                JobNoFilter := '@*' + format(Rec."No.") + '*'
                            else
                                JobNoFilter := format(Rec."No.");
                            //PE-133.NC.1.0 21July2023 End
                            "Sub-LevelJob".COPY(Rec);
                            "Sub-LevelJob".RESET();
                            //"Sub-LevelJob".SETRANGE("NS_Sub-Level to Job No.", rec."No.");//PRJ-1131.RM.1.0 10Jan2022 //PE-133.NC.1.0 21July2023 Block
                            "Sub-LevelJob".SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter); //PE-133.NC.1.0 21July2023
                            "Sub-LevelJob".SETFILTER(Status, '>%1', "Sub-LevelJob".Status::Planning);
                            PAGE.RUN(PAGE::"Job List", "Sub-LevelJob");
                        end;
                    }
                    field("FORMAT(JobLevelBudget+""Sub-LevelsCost"",14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(JobLevelBudget + "Sub-LevelsCost", 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Total';
                        ToolTip = 'Specifies the Total value of Budgeted lines'; //PE-75.RM.1.0 17May2023
                        Editable = false;
                    }


                    // PE-193.PS.3.0 27Dec2023 Start
                    field(NS_ChangeRequestCost; Round(NS_ChangeRequestCost, 0.01))
                    {
                        ApplicationArea = All;
                        Caption = 'Change Request';
                        Editable = false;
                        trigger OnDrillDown()
                        var

                        begin
                            ChangeRequest_Job.SetRange("NS_Change Request to Job No.", Rec."No.");
                            ChangeRequest_Job.SetRange("NS_Job Class", Rec."NS_Job Class"::"Change Order");
                            Page.Run(PAGE::"Job List", ChangeRequest_Job);
                        end;
                    }
                    // PE-193.PS.3.0 04Jan2024 End


                }
                //MHNA-6.NK.1.0 start 21feb2023
                group("Locked(Revenue)")
                {
                    // Caption = '                         Locked(Revenue)'; //MHNA-6.RM.1.0 29March2023 commented
                    Caption = '                     Locked(Revenue)';//MHNA-6.RM.1.0 29March2023
                    field(LockedCostBill; Round(LockedCostBill, 0.01))
                    {
                        ApplicationArea = all;
                        Caption = 'Original Contract Rev';
                        DrillDownPageID = "Job Planning Lines";
                        Editable = false;

                        trigger OnDrillDown();
                        begin
                            LockedJobPlanningList.SetFilters(Rec."No.", 1);
                            LockedJobPlanningList.Rev_SetShowAdjustmentLines(Text14021101);
                            LockedJobPlanningList.RUNMODAL;
                            CLEAR(LockedJobPlanningList);
                        end;
                    }
                    field(AdjustmentRevenueCont; Round(AdjustmentRevenueCont, 0.01))
                    {
                        ApplicationArea = All;
                        Caption = 'Contract Adjustments Rev';
                        Editable = false;


                        trigger OnDrillDown();
                        begin
                            LockedJobPlanningList.NS_SetFilters(Rec."No.", 1);
                            LockedJobPlanningList.NS_SetShowAdjustmentLines(Text14021100);
                            LockedJobPlanningList.RUNMODAL;
                            CLEAR(LockedJobPlanningList);
                        end;
                    }
                    field("NS_ Locked Budgeted Rev "; Round(Rec."NS_ Locked Budgeted Rev ", 0.01))
                    {
                        ApplicationArea = All;
                        Caption = 'Contract Amount Rev';
                        DrillDownPageID = "NS_Job Planning List (Locked)";
                        Editable = false;

                        trigger OnDrillDown();
                        begin
                            LockedJobPlanningList.NS_SetFilters(Rec."No.", 1);
                            LockedJobPlanningList.RUNMODAL;
                            CLEAR(LockedJobPlanningList);

                        end;
                    }
                    field(LockedSubLevelRevCost; Round(LockedSubLevelRevCost, 0.01)) //PRJ-659.RM.1.0 20Oct2021
                    {
                        ApplicationArea = All;
                        Caption = 'Contract Sub-Levels Rev';
                        Editable = false;

                        trigger OnDrillDown();
                        begin
                            //PE-133.NC.1.0 21July2023 Start
                            if StrLen(format(Rec."No.")) < 18 then
                                JobNoFilter := '@*' + format(Rec."No.") + '*'
                            else
                                JobNoFilter := format(Rec."No.");
                            //PE-133.NC.1.0 21July2023 End
                            "Sub-LevelJob".COPY(Rec);
                            "Sub-LevelJob".RESET();
                            //"Sub-LevelJob".SETRANGE("NS_Sub-Level to Job No.", Rec."No.");//PRJ-1131.RM.1.0 10Jan2022 //PE-133.NC.1.0 21July2023 Block
                            "Sub-LevelJob".SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter); //PE-133.NC.1.0 21July2023
                            "Sub-LevelJob".SETFILTER(Status, '>%1', "Sub-LevelJob".Status::Planning);
                            PAGE.RUN(PAGE::"Job List", "Sub-LevelJob");
                        end;
                    }
                    field(ContractTotalRev; Round(ContractTotalRev, 0.01)) //PRJ-659.RM.1.0 20Oct2021
                    {
                        ApplicationArea = All;
                        Caption = 'Total Contract Rev';
                        Editable = false;
                    }
                    // PE-193.PS.3.0 04Jan2024 Start
                    field(ChangeRequst; Round(ChangeRequst, 0.01))
                    {
                        ApplicationArea = All;
                        Caption = 'Change Request Value';
                        Editable = false;
                    }
                    // PE-193.PS.3.0 04Jan2024 End
                }
                //MHNA-6.NK.1.0 end 21feb2023

                group("Billable (Price)")
                {
                    // Caption = '                                      Billable (Price)'; //PRJ-659.RM.1.0 20Oct2021 //MHNA-6.RM.1.0 29March2023 commented
                    Caption = '                          Billable (Price)'; //MHNA-6.RM.1.0 29March2023
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
                    field(AdjustmentContract; FORMAT(AdjustmentContract, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
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
                    field(BudgetedPriceLCY; FORMAT(JobLevelContract, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
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
                    field(SubLevelsPrice; FORMAT("Sub-LevelsPrice", 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Contract Sub-Levels';
                        Editable = false;

                        trigger OnDrillDown();
                        begin
                            //PE-133.NC.1.0 21July2023 Start
                            if StrLen(format(Rec."No.")) < 18 then
                                JobNoFilter := '@*' + format(Rec."No.") + '*'
                            else
                                JobNoFilter := format(Rec."No.");
                            //PE-133.NC.1.0 21July2023 End
                            "Sub-LevelJob".COPY(Rec);
                            "Sub-LevelJob".RESET();
                            //"Sub-LevelJob".SETRANGE("NS_Sub-Level to Job No.", Rec."No.");//PRJ-1131.RM.1.0 10Jan2022 //PE-133.NC.1.0 21July2023 Block
                            "Sub-LevelJob".SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter); //PE-133.NC.1.0 21July2023
                            "Sub-LevelJob".SETFILTER(Status, '>%1', "Sub-LevelJob".Status::Planning);
                            PAGE.RUN(PAGE::"Job List", "Sub-LevelJob");
                        end;
                    }
                    field("FORMAT(JobLevelContract+""Sub-LevelsPrice"",14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(JobLevelContract + "Sub-LevelsPrice", 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Total Contract';
                        Editable = false;
                    }
                    //PE-193.PS.3.0 27Dec2023 Start
                    field(NS_ChangeRequestPrices; Round(NS_ChangeRequestPrices, 0.01)) //PRJ-659.RM.1.0 20Oct2021
                    {
                        ApplicationArea = All;
                        Caption = 'Change Request';
                        Editable = false;
                        // trigger OnDrillDown()
                        // var
                        //     myInt: Integer;
                        // begin
                        //     // ChangeRequest_Job.SetRange("NS_Change Request to Job No.", Rec."No.");
                        //     // ChangeRequest_Job.SetRange("NS_Job Class", Rec."NS_Job Class"::"Change Order");
                        //     // Page.Run(PAGE::"Job List", ChangeRequest_Job);
                        //     JobPlanningList.SetFilters(rec."No.", 1);//PRJ-1131.RM.1.0 10Jan2022
                        //     JobPlanningList.SetShowAdjustmentLines(Text14021101);
                        //     JobPlanningList.RUNMODAL;
                        //     CLEAR(JobPlanningList);
                        // end;
                    }
                    //PE-193.PS.3.0 27Dec2023 End 

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
        ChangeRequest_Job: Record Job; //PE-193.PS.3.0 27Dec2023
        ChangeRequest: Decimal;//PE-193.PS.3.0 27Dec2023
        "Sub-LevelJob": Record Job;
        JobCalc: Record Job;
        OriginalBudget: Decimal;
        OriginalContract: Decimal;

        LockedCostBill: Decimal; //MHNA-6.NK.1.0 21feb2023
        AdjustmentRevenueCont: Decimal; //MHNA-6.NK.1.0 21feb2023
        AdjustmentBudget: Decimal;
        AdjustmentContract: Decimal;
        JobLevelBudget: Decimal;
        JobLevelContract: Decimal;
        ContractTotalRev: Decimal;//MHNA-6.NK.1.0 07March2023
        "Sub-LevelsCost": Decimal;
        "Sub-LevelsPrice": Decimal;
        NS_ChangeRequestCost: Decimal;//PE-193.PS.3.0 28Dec2023
        NS_ChangeRequestPrices: Decimal; //PE-193.PS.3.0 28Dec2023
        Text14021100: Label 'YES';
        Text14021101: Label 'NO';
        Text19065341: Label 'PROJECTPRO';
        Text19073417: Label '"        Budget (Cost)"';
        Text19055672: Label '"        Contract (Price)"';
        JobPlanningList: Page "Job Planning Lines";
        LockedCost: Decimal;
        LockedPrice: Decimal;
        LockedAdjustCost: Decimal;
        LockedAdjustPrice: Decimal;
        LockedJobLevelCost: Decimal;
        lockedJobLevelRevCost: Decimal;//MHNA-6.NK.1.0 21feb2023

        LockedJobSublevelRev: Decimal;//MHNA-6.NK.1.0 21feb2023
        LockedJobLevelPrice: Decimal;
        LockedSubLevelCost: Decimal;
        LockedSubLevelRevCost: Decimal; //MHNA-6.NK.1.0 21feb2023
        LockedSubLevelPrice: Decimal;
        LockedTotalPrice: Decimal;
        LockedTotalCost: Decimal;
        LockedJobPlanningList: Page "NS_Job Planning List (Locked)";//MHNA-6.NK.1.0 21feb2023
        JobLevelContractRev: Decimal;//MHNA-6.NK.1.0 21feb2023
        JobNoFilter: Code[30]; //PE-133.NC.1.0 21July2023
        ChangeRequst: Decimal; //PE-193.PS.3.0 04Jan2024 

        AdjustmentBudgetNC: Decimal;
        AdjustmentContractNC: Decimal;
        IsHandled: Boolean;

    procedure NS_CalcStatistics();
    begin
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

            JobCalc.CALCFIELDS("NS_Budgeted Price (LCY)", "NS_Locked Bill Rev Cost (LCY)", "NS_ Locked Budgeted Rev ");//MHNA-6.NK.1.0 start 06Jan2023
            OriginalContract := JobCalc."NS_Budgeted Price (LCY)";
            LockedCostBill := JobCalc."NS_Locked Bill Rev Cost (LCY)"; //MHNA-6.NK.1.0 start 06Jan2023



            //Calculate adjusted amounts
            JobCalc.SETFILTER("NS_Adjustment Filter", '>%1', '');
            JobCalc.CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)", "NS_ Locked Budgeted Rev ");//MHNA-6.NK.1.0 start 06Jan2023
            AdjustmentBudget := JobCalc."NS_Budgeted Cost (LCY)";
            //AdjustmentBudget := AdjustmentBudget + NS_SLsBudgetedCost(JobCalc);//PRJ-421.MS.1.0
            AdjustmentContract := JobCalc."NS_Budgeted Price (LCY)";
            AdjustmentRevenueCont := JobCalc."NS_ Locked Budgeted Rev ";//MHNA-6.NK.1.0 start 06march2023
                                                                        //AdjustmentContract := AdjustmentContract + NS_SLsBudgetedPrice(JobCalc);//PRJ-421.MS.1.0
        end;
        AdjustmentBudget := AdjustmentBudget + NS_SLsBudgetedCost(JobCalc);
        AdjustmentContract := AdjustmentContract + NS_SLsBudgetedPrice(JobCalc);
        // << Upgrade
        //Calculate total Job Level values
        JobLevelBudget := OriginalBudget + AdjustmentBudget;
        JobLevelContract := OriginalContract + AdjustmentContract;
        JobLevelContractRev := LockedCostBill + AdjustmentRevenueCont;//MHNA-6.NK.1.0 07March2023

        JobCalc.RESET;

        //Find Revisions Cost and Price
        CLEAR("Sub-LevelsCost");
        CLEAR("Sub-LevelsPrice");
        Clear(ContractTotalRev); //MHNA-6.NK.1.0 07March2023
        "Sub-LevelsCost" := NS_SLsBudgetedCost(JobCalc);
        "Sub-LevelsPrice" := NS_SLsBudgetedPrice(JobCalc);
        //PE-193.PS.3.0 28Dec2023 Start
        NS_ChangeRequestPrices := Rec.NS_ChangeRequestBillingprice(JobCalc);
        NS_ChangeRequestCost := Rec.NS_ChangeRequestBillingCost(JobCalc);
        //PE-193.PS.3.0 28Dec2023 End
        LockedSubLevelRevCost := Rec.NS_LockedSubLevelRevCost(JobCalc); //PE-133.NC.1.0 21July2023
        //ContractTotalRev := JobLevelContractRev + LockedSubLevelCost; //MHNA-6.NK.1.0 07March2023 //PE-133.NC.1.0 21July2023 Block
        ContractTotalRev := JobLevelContractRev + LockedSubLevelRevCost; //PE-133.NC.1.0 21July2023

        CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)", "NS_ Locked Budgeted Rev ");//PRJ-1131.RM.1.0 10Jan2022 //MHNA-6.NK.1.0 07March2023

        JobCalc.SETFILTER("NS_Adjustment Filter", '%1', ''); //PE-133.NC.1.0 21July2023
        JobCalc.CALCFIELDS("NS_Locked Budget Cost (LCY)");
        LockedCost := JobCalc."NS_Locked Budget Cost (LCY)";

        JobCalc.CALCFIELDS("NS_Locked Budget Price (LCY)");
        LockedPrice := JobCalc."NS_Locked Budget Price (LCY)";

        JobCalc.SETFILTER("NS_Adjustment Filter", '>%1', '');
        JobCalc.CALCFIELDS("NS_Locked Budget Cost (LCY)", "NS_Locked Budget Price (LCY)");
        //LockedAdjustCost := JobCalc."NS_Locked Budget Cost (LCY)" + Rec.NS_LockedSLsBudgetedCost(JobCalc);//PRJ-1131.RM.1.0 10Jan2022 //PE-133.NC.1.0 21July2023 Block
        LockedAdjustCost := JobCalc."NS_Locked Budget Cost (LCY)"; //PE-133.NC.1.0 21July2023
        LockedAdjustPrice := JobCalc."NS_Locked Budget Price (LCY)" + Rec.NS_LockedSLsBudgetedPrice(JobCalc);//PRJ-1131.RM.1.0 10Jan2022

        LockedJobLevelCost := LockedCost + LockedAdjustCost;
        LockedJobLevelPrice := LockedPrice + LockedAdjustPrice;

        JobCalc.RESET();
        CLEAR(LockedSubLevelCost);
        CLEAR(LockedSubLevelPrice);
        LockedSubLevelCost := NS_LockedSLsBudgetedCost(JobCalc);
        LockedSubLevelPrice := NS_LockedSLsBudgetedPrice(JobCalc);
    end;
    // >> Upgrade
    [IntegrationEvent(false, false)]
    local procedure Calculateoriginalamounts(var Job: Record Job; var JobCalc: Record Job; var OriginalBudget: Decimal; var OriginalContract: Decimal; var AdjustmentBudget: Decimal; var AdjustmentBudgetNC: Decimal;
    var AdjustmentContract: Decimal; var AdjustmentContractNC: Decimal; var IsHandled: Boolean)
    begin
    end;
    // << Upgrade
}

