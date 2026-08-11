page 14021114 "NS_BudgAnalysProfitFactBoxNew"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------        
    //PE-190.VC.1.0 16Oct2023 | New page for Current Earned Revenue and Profits Analysis
    Caption = 'Budget Analysis/Profits';
    PageType = ListPart;
    SourceTable = Job;

    layout
    {
        area(content)
        {
            fixed(Control1900723401)
            {
                Caption = '';
                group(PROJECTPRO)
                {
                    Caption = 'Current Earned Revenue and Profits Analysis';
                    //PRJCTPR-323.PS.1.0 28Feb2024 Start
                    field(Method; 'POC Method')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'POC Method';
                        Caption = '';
                    }
                    field("Last Posting Date"; 'Last Posting Date')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Last Posting Date';
                        Caption = '';
                    }

                    //PRJCTPR-323.PS.1.0 28Feb2024 End 
                    field("FORMAT('NS_Contract Price')"; FORMAT('Contract Price'))
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Contract Price';
                        Caption = '';
                    }
                    field("FORMAT('NS_ETC (Est. Cost at Completion)')"; FORMAT('ETC (Est. Cost at Completion)'))
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'ETC (Est. Cost at Completion)';
                        Caption = '';
                    }
                    field("Format('NS_Actual Cost to Date')"; Format('Actual Cost to Date'))
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Actual Cost to Date';
                        Caption = '';
                    }
                    field("Format('NS_% Complete')"; Format('% Complete'))
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Percentage Complete';
                        Caption = '';
                    }
                    field("Format('NS_Earned Revenue')"; Format('Earned Revenue'))
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Earned Revenue';
                        Caption = '';
                    }
                    field("Format('NS_Gross Profit')"; Format('Gross Profit'))
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Percentage Complete';
                        Caption = '';
                    }
                    field("Format('NS_Profit %')"; Format('Profit %'))
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Earned Revenue';
                        Caption = '';
                    }
                }

                group(Estimated)
                {
                    //Caption = 'Amount'; //PE-190.VC.1.1
                    Caption = 'Original (Locked)';//PRJCTPR-323.PS.1.0 28Feb2024
                    //field(A; Round(A, JobSetup."NS_Forecast Amount Rounding", '>'))//
                    //PRJCTPR-323.PS.1.0 28Feb2024 Start
                    field(AA; 'POC Method')
                    {
                        ApplicationArea = All;
                        Caption = '';
                        Visible = false;
                    }
                    field(DD; 'Last Posting Date')
                    {
                        ApplicationArea = All;
                        Caption = '';
                        Visible = false;
                    }

                    // field(A; NS_ContractPrice)
                    // {
                    //     ApplicationArea = All;
                    //     Editable = false;
                    //     ToolTip = 'Contract Price';
                    //     Caption = 'Contract Price';
                    // }
                    // //field(C; Round(C, JobSetup."NS_Forecast Amount Rounding", '>'))
                    // field(D; NS_ETC)
                    // {
                    //     ApplicationArea = All;
                    //     Editable = false;
                    //     ToolTip = 'ETC (Est. Cost at Completion)';
                    //     Caption = 'ETC (Est. Cost at Completion)';
                    // }
                    // //field(D; Round(D, JobSetup."NS_Forecast Amount Rounding", '>'))//
                    field(A; NS_LockedContractPrice)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Contract Price';
                        Caption = '';
                    }
                    field(D; NS_LockedContractCost)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'ETC (Est. Cost at Completion)';
                        Caption = '';
                    }
                    //PRJCTPR-323.PS.1.0 28Feb2024 End
                    field(C; 0)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Actual Cost to Date';
                        Caption = 'Actual Cost to Date';
                    }
                    //field(E; Round(E, JobSetup."NS_Forecast Amount Rounding", '>'))//VC
                    field(E; 0)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Percentage Complete';
                        Caption = '% Complete';
                    }
                    //field(F; Round(F, JobSetup."NS_Forecast Amount Rounding", '>'))//VC
                    field(F; 0)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Earned Revenue';
                        Caption = 'Earned Revenue';
                    }
                    //PRJCTPR-323.PS.1.0 28Feb2024 Start
                    // field(GrossProfit; NS_GrossProfit)
                    // {
                    //     ApplicationArea = All;
                    //     Editable = false;
                    //     ToolTip = 'Gross Profit';
                    //     Caption = 'Gross Profit';
                    // }
                    // field(ProfitPerc; NS_ProfitPerc)
                    // {
                    //     ApplicationArea = All;
                    //     Editable = false;
                    //     ToolTip = 'Profit %';
                    //     Caption = 'Profit %';
                    // }
                    field(GrossProfit; NS_LockedGrossProfit)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Gross Profit';
                        Caption = 'Gross Profit';
                    }
                    field(ProfitPerc; NS_LockedProfitPers)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Profit %';
                        Caption = 'Profit %';
                    }
                    //PRJCTPR-323.PS.1.0 28Feb2024 End
                }
                group(Projected)
                {
                    Caption = 'Posted Revenue Recognition';
                    // field(AAA; Rec."NS_POC Method") // PRJCTPR-323.PS.4.0 17April2024 Commented
                    field(AAA; NS_PostedPOCMethod) // PRJCTPR-323.PS.4.0 17April2024
                    {
                        ApplicationArea = All;
                        Caption = '';

                    }
                    field(DDD; NS_PostedDatePostingdate)
                    {
                        ApplicationArea = All;
                        Caption = '';

                    }
                    // field(A1; NS_ContractPrice)
                    // {
                    //     ApplicationArea = All;
                    //     Editable = false;
                    //     Visible = true;
                    // }
                    field(A1; NS_PostedContractPrice)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Visible = true;
                    }
                    // field(C1; NS_ETC)
                    // {
                    //     ApplicationArea = All;
                    //     Editable = false;

                    // }
                    field(C1; NS_PostedContractCost)
                    {
                        ApplicationArea = All;
                        Editable = false;

                    }
                    // field(D1; NS_ActualCostToDate)
                    // {
                    //     ApplicationArea = All;
                    //     Editable = false;
                    //     Visible = true;
                    // }


                    field(D1; NS_PostedActualCosttodate)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Visible = true;
                    }
                    // field(E1; NS_PercentageCompleted)
                    // {
                    //     ApplicationArea = All;
                    //     Editable = false;
                    //     Visible = true;
                    // }
                    field(E1; NS_PostedCompletePers)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Visible = true;
                    }
                    // field(F1; NS_EarnedRevenue)
                    // {
                    //     ApplicationArea = All;
                    //     Editable = false;
                    //     Visible = true;
                    // }
                    field(F1; NS_PostedEarnedRevenue)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Visible = true;
                    }
                    // field(G1; NS_GrossProfit)
                    // {
                    //     ApplicationArea = All;
                    //     Editable = false;
                    //     Visible = true;
                    // }
                    field(G1; NS_PostedGrossprofit)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Visible = true;
                    }
                    // field(GG3; NS_ProfitPerc)
                    // {
                    //     ApplicationArea = All;
                    //     Editable = false;
                    // }
                    field(GG3; NS_PostedProfitPers)
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                }
                group("Unposted Revenue Recognition")
                {
                    Caption = 'Unposted Revenue Recognition';
                    // field(M; Rec."NS_POC Method")// PRJCTPR-323.PS.4.0 17April2024 Commented
                    field(M; NS_UnpostedPOCMethod) // PRJCTPR-323.PS.4.0 17April2024
                    {
                        ApplicationArea = All;
                        Caption = ' ';
                    }
                    field(LPD; NS_UnpostedPostingdate)
                    {
                        ApplicationArea = All;
                        Caption = '';
                    }
                    field(AA1; NS_UnpostedContractPrice)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Visible = true;
                    }
                    field(CC1; NS_UnpostedContractCost)
                    {
                        ApplicationArea = All;
                        Editable = false;

                    }
                    field(DD1; NS_UnpostedActualCosttodate)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Visible = true;
                    }
                    field(EE1; NS_UnPostedCompletePers)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Visible = true;
                    }
                    field(FF1; NS_UnPostedEarnedRevenue)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Visible = true;
                    }
                    field(GG1; NS_UnPostedGrossprofit)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Visible = true;
                    }
                    field(GG2; NS_UnPostedProfitPers)
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }


                }
            }
        }
    }

    actions
    {
    }
    trigger OnOpenPage()
    begin
        PercentageOfCompletion.OnAfterGetRecordofReport(Rec);
        NS_ContractPrice := PercentageOfCompletion.GetContractPrice();
        NS_ActualCostToDate := PercentageOfCompletion.GetActualCostToDate();
        //PRJCTPR-323.PS.1.0 01March2024 Start
        NS_LockedContractCost := PercentageOfCompletion.NS_JobPlaningLineLockedCostAmt(Rec);
        NS_LockedContractPrice := PercentageOfCompletion.NS_JobPlaningLineLockedPriceAmt(Rec);
        NS_LockedGrossProfit := NS_LockedContractPrice - NS_LockedContractCost;
        // if NS_LockedGrossProfit <> 0 then//PRJCTPR-323.AS COMMENT
        if NS_LockedContractPrice <> 0 then //PRJCTPR-323.AS ADD
            NS_LockedProfitPers := (NS_LockedGrossProfit / NS_LockedContractPrice) * 100;

        NS_UnpostedContractPrice := PercentageOfCompletion.NS_UnpostedRevenueRecognitionConPrice(Rec);
        NS_UnpostedContractCost := PercentageOfCompletion.NS_UnpostedRevenueRecognitionConETC(Rec);
        NS_UnpostedActualCosttodate := PercentageOfCompletion.NS_UnpostedRevenueRecognitionConActualCosttodate(Rec);
        NS_UnpostedPostingdate := PercentageOfCompletion.NS_UnpostedRevenueRecognitionPostingdate(Rec);
        NS_UnPostedCompletePers := PercentageOfCompletion.NSUnPostedCompletedPer(Rec);
        NS_UnPostedEarnedRevenue := PercentageOfCompletion.NSUnPostedEarnedRevenue(Rec);
        NS_UnPostedGrossprofit := PercentageOfCompletion.NSUnPostedGrossProfit(Rec);
        NS_UnPostedProfitPers := PercentageOfCompletion.NSUNPostedProfitPer(Rec);
        NS_UnpostedPOCMethod := PercentageOfCompletion.NS_UnpostedRevenueRecognitionPOCMethod(Rec); // PRJCTPR-323.PS.4.0 17April2024

        // if NS_UnpostedContractCost <> 0 then //PRJCTPR-323.AS
        //     NS_UnPostedCompletePers := (NS_UnpostedActualCosttodate / NS_UnpostedContractCost) * 100;
        // NS_UnPostedEarnedRevenue := (NS_UnpostedContractPrice * NS_UnPostedCompletePers) / 100;
        // NS_UnPostedGrossprofit := NS_UnPostedEarnedRevenue - NS_UnpostedActualCosttodate;

        // // if NS_UnPostedGrossprofit <> 0 then//PRJCTPR-323.AS COMMENT
        // if NS_UnPostedEarnedRevenue <> 0 then
        //     NS_UnPostedProfitPers := (NS_UnPostedGrossprofit / NS_UnPostedEarnedRevenue) * 100;

        ///For Psoted Data ++
        NS_PostedDatePostingdate := PercentageOfCompletion.NS_postedRevenueRecognitionPostingdate(Rec);

        /// for Posted Data --
        //PRJCTPR-323.PS.1.0 01March2024 End


        NS_ETC := PercentageOfCompletion.GetETC();
        NS_PercentageCompleted := PercentageOfCompletion.GetPctCompleted();
        NS_EarnedRevenue := PercentageOfCompletion.GetEarnRevenue();
        NS_GrossProfit := NS_EarnedRevenue - NS_ActualCostToDate;
        If NS_EarnedRevenue <> 0 then
            NS_ProfitPerc := (NS_GrossProfit / NS_EarnedRevenue) * 100;

        ///For New Posted Data ++ 

        NS_PostedContractPrice := PercentageOfCompletion.NS_PostedRevenueRecognitionConPrice(Rec);
        NS_PostedContractCost := PercentageOfCompletion.NS_PostedRevenueRecognitionConETC(Rec);
        NS_PostedActualCosttodate := PercentageOfCompletion.NS_PostedRevenueRecognitionConActualCosttodate(Rec);
        NS_PostedCompletePers := PercentageOfCompletion.NSPostedCompletedPer(Rec);
        NS_PostedEarnedRevenue := PercentageOfCompletion.NSPostedEarnedRevenue(Rec);
        NS_PostedGrossprofit := PercentageOfCompletion.NSPostedGrossProfit(Rec);
        NS_PostedProfitPers := PercentageOfCompletion.NSPostedGrossProfitPer(Rec);
        NS_PostedPOCMethod := PercentageOfCompletion.NS_PostedRevenueRecognitionPOCmethod(Rec); // PRJCTPR-323.PS.4.0 17April2024

        // if NS_PostedContractCost <> 0 then //PRJCTPR-323.AS
        //     NS_PostedCompletePers := (NS_PostedActualCosttodate / NS_PostedContractCost) * 100;
        // NS_PostedEarnedRevenue := (NS_PostedContractPrice * NS_PostedCompletePers) / 100;
        // NS_PostedGrossprofit := NS_PostedEarnedRevenue - NS_PostedActualCosttodate;
        // // if NS_PostedGrossprofit <> 0 then//PRJCTPR-323.AS COMMENT
        // if NS_PostedEarnedRevenue <> 0 then//PRJCTPR-323.AS ADD
        //     NS_PostedProfitPers := (NS_PostedGrossprofit / NS_PostedEarnedRevenue) * 100;
        /// For New Posted Data --


    end;

    trigger OnAfterGetRecord();
    begin
        //NS_OnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        //NS_OnAfterGetCurrRecord;
    end;

    var
        ActualCostToDate: array[3] of Decimal;
        InvoiceBilled: array[3] of Decimal;
        PaymentReceived: array[3] of Decimal;
        CommittedCost: Decimal;
        CalcValues: array[8, 40] of Decimal;
        "Sub-LevelsCost": Decimal;
        "Sub-LevelsPrice": Decimal;
        PercentageOfCompletion: Codeunit "NS_Percentage of Completion";
        JobSetup: Record "Jobs Setup";
        //JObNo: Record Job;
        NS_ContractPrice: Decimal;
        NS_ETC: Decimal;
        NS_ActualCostToDate: Decimal;
        NS_PercentageCompleted: Decimal;
        NS_EarnedRevenue: Decimal;
        NS_GrossProfit: Decimal;
        NS_ProfitPerc: Decimal;
        //PRJCTPR-323.PS.1.0 01March24 Start
        //For Posted Data ++
        NS_PostedDatePostingdate: Date;
        NS_PostedContractPrice: Decimal;
        NS_PostedContractCost: Decimal;
        NS_PostedActualCosttodate: Decimal;
        NS_PostedCompletePers: Decimal;
        NS_PostedEarnedRevenue: Decimal;
        NS_PostedGrossprofit: Decimal;
        NS_PostedProfitPers: Decimal;
        NS_PostedPOCMethod: Text[50];// PRJCTPR-323.PS.4.0 17April2024
        //For Posted Data --
        NS_UnpostedPostingdate: Date;
        NS_UnPostedCompletePers: Decimal;
        NS_UnPostedGrossprofit: Decimal;
        NS_UnPostedProfitPers: Decimal;
        NS_UnPostedEarnedRevenue: Decimal;
        NS_LockedContractPrice: Decimal;
        NS_LockedContractCost: Decimal;
        NS_LockedGrossProfit: Decimal;
        NS_LockedProfitPers: Decimal;
        NS_UnpostedContractPrice: Decimal;
        NS_UnpostedContractCost: Decimal;
        NS_UnpostedActualCosttodate: Decimal;
        NS_UnpostedPOCMethod: Text[50]; // PRJCTPR-323.PS.4.0 17April2024
    //PRJCTPR-323.PS.1.0 01March24 End
    // procedure CalcStatistics();
    // begin
    //     IF Rec."No." = '' then
    //         Exit;
    //     Rec.NS_CalculateJobFinancials(Rec, ActualCostToDate, InvoiceBilled, PaymentReceived, CommittedCost, true);

    //     //Calculate Common Values
    //     CLEAR("Sub-LevelsCost");
    //     CLEAR("Sub-LevelsPrice");
    //     "Sub-LevelsCost" := Rec.NS_SLsBudgetedLaborHours(Rec);
    //     "Sub-LevelsPrice" := Rec."SLsUsage(Price)"(Rec);

    //     Rec.NS_CalculateJobStatistics(Rec, ActualCostToDate, InvoiceBilled, "Sub-LevelsCost", "Sub-LevelsPrice", CommittedCost, true, CalcValues);
    // end;

    // local procedure NS_OnAfterGetCurrRecord();
    // begin
    //     xRec := Rec;
    //     CalcStatistics;
    // end;

}

