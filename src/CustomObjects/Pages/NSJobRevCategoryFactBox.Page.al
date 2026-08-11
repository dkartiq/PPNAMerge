/// <summary>
/// Page NS_RevCategoryStatistics (ID 14021109).
/// </summary>
// PRJCTPR-346.JS.1.0 27MAR2024 New Page
page 14021109 NS_RevCategoryStatistics
{
    //PRJCTPR-346.JS.1.0
    PageType = ListPart;
    caption = 'Rev. Category Statistics';
    SourceTable = Job;

    layout
    {
        area(Content)
        {
            group("NS_Rev Categories $")
            {
                Caption = 'Rev Categories $';
                fixed(NS_Control1100773275)
                {
                    Caption = '';
                    group("NS_PROJECTPRO REVENUE")
                    {
                        Caption = 'PROJECTPRO REVENUE';
                        field(NS_LaborRevLbl; NS_LaborRevLbl)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the Budgeted Labor Revenue Amount Total';
                            Caption = '';
                        }
                        field(NS_MaterialRevLbl; NS_MaterialRevLbl)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the Budgeted Material Revenue Amount Total';
                            Caption = '';
                        }
                        field(NS_EquipmentRevLbl; NS_EquipmentRevLbl)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the Budgeted Equipment Revenue Amount Total';
                            Caption = '';
                        }
                        field(NS_SubcontractRevLbl; NS_SubcontractRevLbl)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the Budgeted Subcontract Revenue Amount Total';
                            Caption = '';
                        }
                        field(NS_MfgRevLbl; NS_MfgRevLbl)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the Budgeted Manufacturing Revenue Amount Total';
                            Caption = '';
                        }
                        field(NS_OverheadRevLbl; NS_OverheadRevLbl)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the Budgeted Overhead Revenue Amount Total';
                            Caption = '';
                        }
                        field(NS_MiscellaneousRevLbl; NS_MiscellaneousRevLbl)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the Budgeted Miscellaneous Revenue Amount';
                            Caption = '';
                        }
                        field(NS_UncategorizedRevLbl; NS_UncategorizedRevLbl)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the Budgeted Uncategorized Revenue Amount Total';
                            Caption = '';
                        }
                        field(NS_RevenueTotalsLbl; NS_RevenueTotalsLbl)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the Total Budgeted Revenue Amount';
                            Caption = '';
                        }
                    }
                    group("NS_Budget Revenue")
                    {
                        Caption = 'Budget Revenue';
                        field("NS_CalcValues[5,1]"; NSCalcValues[5, 1])
                        {
                            ApplicationArea = All;
                            Caption = 'Labor Budget Revenue';
                            Editable = false;
                            ToolTip = 'Budgeted Labor Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,5]"; NSCalcValues[5, 5])
                        {
                            ApplicationArea = All;
                            Caption = 'Material Budget Revenue';
                            Editable = false;
                            ToolTip = 'Budgeted Material Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,9]"; NSCalcValues[5, 9])
                        {
                            ApplicationArea = All;
                            Caption = 'Equipment Budget Revenue';
                            Editable = false;
                            ToolTip = 'Budgeted Equipment Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,13]"; NSCalcValues[5, 13])
                        {
                            ApplicationArea = All;
                            Caption = 'Subcontract Budget Revenue';
                            Editable = false;
                            ToolTip = 'Budgeted Subcontract Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,17]"; NSCalcValues[5, 17])
                        {
                            ApplicationArea = All;
                            Caption = 'Manufacturing Budget Revenue';
                            Editable = false;
                            ToolTip = 'Budgeted Manufacturing Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,21]"; NSCalcValues[5, 21])
                        {
                            ApplicationArea = All;
                            Caption = 'Overhead Budget Revenue';
                            Editable = false;
                            ToolTip = 'Budgeted Overhead Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,25]"; NSCalcValues[5, 25])
                        {
                            ApplicationArea = All;
                            Caption = 'Miscellaneous Budget Revenue';
                            Editable = false;
                            ToolTip = 'Budgeted Miscellaneous Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,29]"; NSCalcValues[5, 29])
                        {
                            ApplicationArea = All;
                            Caption = 'Uncategorized Budget Revenue';
                            Editable = false;
                            ToolTip = 'Budgeted Uncategorized Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,33]"; NSCalcValues[5, 33])
                        {
                            ApplicationArea = All;
                            Caption = 'Revenue Budget Totals';
                            Editable = false;
                            ToolTip = 'Total Budgeted Revenue Amount';
                        }
                    }
                    group("NS_Actual Revenue")
                    {
                        Caption = 'Actual Revenue';
                        field("NS_CalcValues[5,2]"; NSCalcValues[5, 2])
                        {
                            ApplicationArea = All;
                            Caption = 'Labor Actual Revenue';
                            Editable = false;
                            ToolTip = 'Actual Labor Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,6]"; NSCalcValues[5, 6])
                        {
                            ApplicationArea = All;
                            Caption = 'Material Actual Revenue';
                            Editable = false;
                            ToolTip = 'Actual Material Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,10]"; NSCalcValues[5, 10])
                        {
                            ApplicationArea = All;
                            Caption = 'Equipmentl Actual Revenue';
                            Editable = false;
                            ToolTip = 'Actual Equipment Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,14]"; NSCalcValues[5, 14])
                        {
                            ApplicationArea = All;
                            Caption = 'Subcontractl Actual Revenue';
                            Editable = false;
                            ToolTip = 'Actual Subcontract Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,18]"; NSCalcValues[5, 18])
                        {
                            ApplicationArea = All;
                            Caption = 'Manufacturing Actual Revenue';
                            Editable = false;
                            ToolTip = 'Actual Manufacturing Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,22]"; NSCalcValues[5, 22])
                        {
                            ApplicationArea = All;
                            Caption = 'Overhead Actual Revenue';
                            Editable = false;
                            ToolTip = 'Actual Overhead Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,26]"; NSCalcValues[5, 26])
                        {
                            ApplicationArea = All;
                            Caption = 'Miscellaneous Actual Revenue';
                            Editable = false;
                            ToolTip = 'Actual Miscellaneous Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,30]"; NSCalcValues[5, 30])
                        {
                            ApplicationArea = All;
                            Caption = 'Uncategorized Actual Revenue';
                            Editable = false;
                            ToolTip = 'Actual Uncategorized Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,34]"; NSCalcValues[5, 34])
                        {
                            ApplicationArea = All;
                            Caption = 'Revenue Actual Revenue';
                            Editable = false;
                            ToolTip = 'Actual Revenue Amount Total';
                        }
                    }
                    group("NS_Revenue Variance")
                    {
                        Caption = 'Revenue Variance';
                        field("NS_CalcValues[5,3]"; NSCalcValues[5, 3])
                        {
                            ApplicationArea = All;
                            Caption = 'Labor Revenue Variance';
                            Editable = false;
                            ToolTip = 'Labor Budget - Labor Actual';
                        }
                        field("NS_CalcValues[5,7]"; NSCalcValues[5, 7])
                        {
                            ApplicationArea = All;
                            Caption = 'Material Revenue Variance';
                            Editable = false;
                            ToolTip = 'Material Budget - Material Actual';
                        }
                        field("NS_CalcValues[5,11]"; NSCalcValues[5, 11])
                        {
                            ApplicationArea = All;
                            Caption = 'Equipment Revenue Variance';
                            Editable = false;
                            ToolTip = 'Equipment Budget - Equipment Actual';
                        }
                        field("NS_CalcValues[5,15]"; NSCalcValues[5, 15])
                        {
                            ApplicationArea = All;
                            Caption = 'Subcontract Revenue Variance';
                            Editable = false;
                            ToolTip = 'Subcontract Budget - Subcontract Actual';
                        }
                        field("NS_CalcValues[5,19]"; NSCalcValues[5, 19])
                        {
                            ApplicationArea = All;
                            Caption = 'Manufacturing Revenue Variance';
                            Editable = false;
                            ToolTip = 'Manufacturing Budget - Manufacturing Actual';
                        }
                        field("NS_CalcValues[5,23]"; NSCalcValues[5, 23])
                        {
                            ApplicationArea = All;
                            Caption = 'Overhead Revenue Variance';
                            Editable = false;
                            ToolTip = 'Overhead Budget - Overhead Actual';
                        }
                        field("NS_CalcValues[5,27]"; NSCalcValues[5, 27])
                        {
                            ApplicationArea = All;
                            Caption = 'Miscellaneous Revenue Variance';
                            Editable = false;
                            ToolTip = 'Miscellaneous Budget - Miscellaneous Actual';
                        }
                        field("NS_CalcValues[5,31]"; NSCalcValues[5, 31])
                        {
                            ApplicationArea = All;
                            Caption = 'Uncategorized Revenue Variance';
                            Editable = false;
                            ToolTip = 'Uncategorized Budget - Uncategorized Actual';
                        }
                        field("NS_CalcValues[5,35]"; NSCalcValues[5, 35])
                        {
                            ApplicationArea = All;
                            Caption = 'Total Revenue Variance';
                            Editable = false;
                            ToolTip = 'Total Budgeted - Total Actual';
                        }
                    }
                    group("NS_Revenue Variance %")
                    {
                        Caption = 'Revenue Variance %';
                        field("NS_CalcValues[5,4]"; NSCalcValues[5, 4])
                        {
                            ApplicationArea = All;
                            Caption = 'Labor Revenue Variance Pct';
                            Editable = false;
                            ToolTip = 'Percent of Labor Variance / Labor Budget';
                        }
                        field("NS_CalcValues[5,8]"; NSCalcValues[5, 8])
                        {
                            ApplicationArea = All;
                            Caption = 'Material Revenue Variance Pct';
                            Editable = false;
                            ToolTip = 'Percent of Material Variance / Material Budget';
                        }
                        field("NS_CalcValues[5,12]"; NSCalcValues[5, 12])
                        {
                            ApplicationArea = All;
                            Caption = 'Equipment Revenue Variance Pct';
                            Editable = false;
                            ToolTip = 'Percent of Equipment Variance / Equipment Budget';
                        }
                        field("NS_CalcValues[5,16]"; NSCalcValues[5, 16])
                        {
                            ApplicationArea = All;
                            Caption = 'Subcontract Revenue Variance Pct';
                            Editable = false;
                            ToolTip = 'Percent of Subcontract Variance / Subcontract Budget';
                        }
                        field("NS_CalcValues[5,20]"; NSCalcValues[5, 20])
                        {
                            ApplicationArea = All;
                            Caption = 'Manufacturing Revenue Variance Pct';
                            Editable = false;
                            ToolTip = 'Percent of Manufacturing Variance / Manufacturing Budget';
                        }
                        field("NS_CalcValues[5,24]"; NSCalcValues[5, 24])
                        {
                            ApplicationArea = All;
                            Caption = 'Overhead Revenue Variance Pct';
                            Editable = false;
                            ToolTip = 'Percent of Overhead Variance / Overhead Budget';
                        }
                        field("NS_CalcValues[5,28]"; NSCalcValues[5, 28])
                        {
                            ApplicationArea = All;
                            Caption = 'Miscellaneous Revenue Variance Pct';
                            Editable = false;
                            ToolTip = 'Percent of Miscellaneous Variance / Miscellaneous Budget';
                        }
                        field("NS_CalcValues[5,32]"; NSCalcValues[5, 32])
                        {
                            ApplicationArea = All;
                            Caption = 'Miscellaneous Revenue Variance Pct';
                            Editable = false;
                            ToolTip = 'Percent of Uncategorized Variance / Uncategorized Budget';
                        }
                        field("NS_CalcValues[5,36]"; NSCalcValues[5, 36])
                        {
                            ApplicationArea = All;
                            Caption = 'Total Revenue Variance Pct';
                            Editable = false;
                            ToolTip = 'Percent of Total Variance / Total Budget';
                        }
                    }
                    group(NS_Control1100773288)
                    {
                        Caption = '';
                        field(NS_Spacer5; '')
                        {
                            ApplicationArea = All;
                            Caption = '.';
                        }
                    }
                }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        JobCalc: Record Job;
        JobLedgEntry: Record "Job Ledger Entry";
        JobsSetup: Record "Jobs Setup";
        ShowJobRec: Record Job;
        "Sub-LevelJob": Record Job;
        NS_LaborRevLbl: Label 'Labor Rev';
        NS_MaterialRevLbl: Label 'Material Rev';
        NS_EquipmentRevLbl: Label 'Equipment Rev';
        NS_SubcontractRevLbl: Label 'Subcontract Rev';
        NS_MfgRevLbl: Label 'Mfg. Rev';
        NS_OverheadRevLbl: Label 'Overhead Rev';
        NS_MiscellaneousRevLbl: Label 'Miscellaneous Rev';
        NS_UncategorizedRevLbl: Label 'Uncategorized Rev';
        NS_RevenueTotalsLbl: Label 'Revenue Totals';
        NSCalcValues: array[8, 40] of Decimal;
        NSActualCostToDate: array[3] of Decimal;
        NSInvoiceBilled: array[3] of Decimal;
        "NSSub-LevelsCost": Decimal;
        "NSSub-LevelsPrice": Decimal;
        NSCommittedCost: Decimal;
        NSPaymentReceived: array[3] of Decimal;
        "NSSub-Levels": Boolean;

    trigger OnOpenPage()
    begin

    end;

    trigger OnAfterGetRecord();
    begin
        NS_OnAfterGetCurrRecord;
    end;

    /// <summary>
    /// NS_OnAfterGetCurrRecord.
    /// </summary>
    procedure NS_OnAfterGetCurrRecord();
    var
        Resource: Record Resource;
    begin
        Rec.SETRANGE("No.");
        CLEAR(NSCalcValues);
        if Rec."No." <> '' then
            NS_CalcStatistics;
    end;


    /// <summary>
    /// NS_CalcStatistics.
    /// </summary>
    procedure NS_CalcStatistics();
    begin

        JobCalc := Rec;
        JobCalc.RESET;
        Rec.NS_CalculateJobFinancials(JobCalc, NSActualCostToDate, NSInvoiceBilled, NSPaymentReceived, NSCommittedCost, "NSSub-Levels"); //PRJ-1135.RM.1.0


        CLEAR("NSSub-LevelsCost");
        CLEAR("NSSub-LevelsPrice");
        "NSSub-LevelsCost" := Rec.NS_SLsBudgetedCost(JobCalc);
        "NSSub-LevelsPrice" := Rec.NS_SLsBudgetedPrice(JobCalc);

        //Rec.NS_CalculateJobStatistics(JobCalc, NSActualCostToDate, NSInvoiceBilled, "NSSub-LevelsCost", "NSSub-LevelsPrice", NSCommittedCost, "NSSub-Levels", //PRJ-1135.RM.1.0
        //                        NSCalcValues);

        NS_CalculateJobStatisticsRecCategory(JobCalc, NSActualCostToDate, NSInvoiceBilled, "NSSub-LevelsCost", "NSSub-LevelsPrice", NSCommittedCost, "NSSub-Levels", //PRJ-1135.RM.1.0
                                NSCalcValues);

    end;


    PROCEDURE NS_CalculateJobStatisticsRecCategory(PassedJob: Record 167; ActualCostToDate: ARRAY[3] OF Decimal; InvoiceBilled: ARRAY[3] OF Decimal; "Sub-LevelsCost": Decimal; "Sub-LevelsPrice": Decimal; CommittedCost: Decimal; PassedSubLevels: Boolean; VAR CalcValues: ARRAY[8, 40] OF Decimal);
    VAR
        NS_TotalBudgetedCost: Decimal;
        NS_TotalContract: Decimal;
        NS_CalcPctComplete: Decimal;
        NS_ActualPctComplete: Decimal;
        NS_Qty: Integer;
        NS_TypedTotal: Decimal;
        NS_Amount: Decimal;
        NS_CustLedgEntryRetention: Record 21;
        NS_SalesSetup: Record 311;
        NS_SalesInvoiceLine: Record 113;
        NS_SalesCrMemoLine: Record 115;
        NS_VendLedgEntryRetention: Record 25;
        NS_PurchSetup: Record 312;
        NS_PurchInvLine: Record 123;
        NS_PurchCrMemoLine: Record 125;
        NS_JobLedgEntry2: Record 169;
        NS_JobCostCategory: Record "NS_Job Cost Category";
        NS_JobCostCategory2: Record "NS_Job Cost Category";
        NS_JobRevenueCategory: Record "NS_Job Revenue Category";
        NS_JobRevenueCategory2: Record "NS_Job Revenue Category";
        NS_JobCalc: Record 167;
    BEGIN
        NS_SalesSetup.GET;
        NS_PurchSetup.GET;
        JobsSetup.GET;
        NS_JobCalc := PassedJob;
        NS_JobCalc.RESET;
        NS_JobCalc.CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");
        NS_TotalBudgetedCost := NS_JobCalc."NS_Budgeted Cost (LCY)" + "Sub-LevelsCost";
        NS_TotalContract := NS_JobCalc."NS_Budgeted Price (LCY)" + "Sub-LevelsPrice";

        //Calculate Percent Completed
        IF NS_JobCalc."NS_Budgeted Cost (LCY)" + "Sub-LevelsCost" <> 0 THEN
            NS_CalcPctComplete := ROUND((ActualCostToDate[3] / (NS_JobCalc."NS_Budgeted Cost (LCY)" + "Sub-LevelsCost")), 0.0001)
        ELSE
            NS_CalcPctComplete := 0;

        //Find Actual Percent Complete
        IF (NS_JobCalc."NS_Actual Percent Complete" > 0) AND
           //(NS_JobCalc."NS_Manager Job Status".AsInteger() < NS_JobCalc."NS_Manager Job Status"::Completed) THEN
           (NS_JobCalc."NS_Manager Job Status".AsInteger() < NS_JobCalc."NS_Manager Job Status".AsInteger()) THEN
            NS_ActualPctComplete := NS_JobCalc."NS_Actual Percent Complete"
        ELSE
            //IF NS_JobCalc."NS_Manager Job Status".AsInteger() >= NS_JobCalc."NS_Manager Job Status"::Completed THEN
            IF NS_JobCalc."NS_Manager Job Status".AsInteger() >= NS_JobCalc."NS_Manager Job Status".AsInteger() THEN
                NS_ActualPctComplete := 100
            ELSE
                NS_ActualPctComplete := NS_CalcPctComplete * 100;

        // NS_TypedTotal := 0;
        // NS_JobRevenueCategory.RESET();
        // IF NS_JobRevenueCategory.FINDSET() THEN
        //     REPEAT
        //         NS_JobCalc.SETFILTER("NS_Revenue Category Filter", NS_JobRevenueCategory.NS_Code);
        //         NS_JobCalc.CALCFIELDS("NS_Budgeted Price (LCY)");
        //         NS_Amount := NS_JobCalc."NS_Budgeted Price (LCY)";
        //         CASE NS_JobRevenueCategory.NS_Type OF
        //             NS_JobRevenueCategory.NS_Type::Labor:
        //                 NSCalcValues[5, 1] := NSCalcValues[5, 1] + NS_Amount;
        //             NS_JobRevenueCategory.NS_Type::Material:
        //                 NSCalcValues[5, 5] := NSCalcValues[5, 5] + NS_Amount;
        //             NS_JobRevenueCategory.NS_Type::Equipment:
        //                 NSCalcValues[5, 9] := NSCalcValues[5, 9] + NS_Amount;
        //             NS_JobRevenueCategory.NS_Type::Subcontract:
        //                 NSCalcValues[5, 13] := NSCalcValues[5, 13] + NS_Amount;
        //             NS_JobRevenueCategory.NS_Type::Manufacturing:
        //                 NSCalcValues[5, 17] := NSCalcValues[5, 17] + NS_Amount;
        //             NS_JobRevenueCategory.NS_Type::Overhead:
        //                 NSCalcValues[5, 21] := NSCalcValues[5, 21] + NS_Amount;
        //             NS_JobRevenueCategory.NS_Type::Miscellaneous:
        //                 NSCalcValues[5, 25] := NSCalcValues[5, 25] + NS_Amount;
        //         END;
        //         NS_TypedTotal := NS_TypedTotal + NS_Amount;
        //     UNTIL NS_JobRevenueCategory.NEXT() = 0;
        // NS_JobCalc.SETRANGE("NS_Revenue Category Filter");
        // NS_JobCalc.CALCFIELDS("NS_Budgeted Price (LCY)");
        // NSCalcValues[5, 29] := NS_JobCalc."NS_Budgeted Price (LCY)" - NS_TypedTotal;


        //New Calculation Values for Revenue Category - Phase-1 start
        NS_TypedTotal := 0;
        NS_JobRevenueCategory.RESET();
        NS_JobRevenueCategory.setfilter(NS_Type, '%1', NS_JobRevenueCategory.NS_Type::Labor);
        IF NS_JobRevenueCategory.FINDSET() THEN begin
            NS_JobCalc.SETFILTER("NS_Revenue Category Filter", NS_JobRevenueCategory.NS_Code);
            NS_JobCalc.CALCFIELDS("NS_Budgeted Price (LCY)");
            NS_Amount := NS_JobCalc."NS_Budgeted Price (LCY)";
            NSCalcValues[5, 1] := NSCalcValues[5, 1] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory.RESET();
        NS_JobRevenueCategory.setfilter(NS_Type, '%1', NS_JobRevenueCategory.NS_Type::Material);
        IF NS_JobRevenueCategory.FINDSET() THEN begin
            NS_JobCalc.SETFILTER("NS_Revenue Category Filter", NS_JobRevenueCategory.NS_Code);
            NS_JobCalc.CALCFIELDS("NS_Budgeted Price (LCY)");
            NS_Amount := NS_JobCalc."NS_Budgeted Price (LCY)";
            NSCalcValues[5, 5] := NSCalcValues[5, 5] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory.RESET();
        NS_JobRevenueCategory.setfilter(NS_Type, '%1', NS_JobRevenueCategory.NS_Type::Equipment);
        IF NS_JobRevenueCategory.FINDSET() THEN begin
            NS_JobCalc.SETFILTER("NS_Revenue Category Filter", NS_JobRevenueCategory.NS_Code);
            NS_JobCalc.CALCFIELDS("NS_Budgeted Price (LCY)");
            NS_Amount := NS_JobCalc."NS_Budgeted Price (LCY)";
            NSCalcValues[5, 9] := NSCalcValues[5, 9] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory.RESET();
        NS_JobRevenueCategory.setfilter(NS_Type, '%1', NS_JobRevenueCategory.NS_Type::Subcontract);
        IF NS_JobRevenueCategory.FINDSET() THEN begin
            NS_JobCalc.SETFILTER("NS_Revenue Category Filter", NS_JobRevenueCategory.NS_Code);
            NS_JobCalc.CALCFIELDS("NS_Budgeted Price (LCY)");
            NS_Amount := NS_JobCalc."NS_Budgeted Price (LCY)";
            NSCalcValues[5, 13] := NSCalcValues[5, 13] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory.RESET();
        NS_JobRevenueCategory.setfilter(NS_Type, '%1', NS_JobRevenueCategory.NS_Type::Manufacturing);
        IF NS_JobRevenueCategory.FINDSET() THEN begin
            NS_JobCalc.SETFILTER("NS_Revenue Category Filter", NS_JobRevenueCategory.NS_Code);
            NS_JobCalc.CALCFIELDS("NS_Budgeted Price (LCY)");
            NS_Amount := NS_JobCalc."NS_Budgeted Price (LCY)";
            NSCalcValues[5, 17] := NSCalcValues[5, 17] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory.RESET();
        NS_JobRevenueCategory.setfilter(NS_Type, '%1', NS_JobRevenueCategory.NS_Type::Overhead);
        IF NS_JobRevenueCategory.FINDSET() THEN begin
            NS_JobCalc.SETFILTER("NS_Revenue Category Filter", NS_JobRevenueCategory.NS_Code);
            NS_JobCalc.CALCFIELDS("NS_Budgeted Price (LCY)");
            NS_Amount := NS_JobCalc."NS_Budgeted Price (LCY)";
            NSCalcValues[5, 21] := NSCalcValues[5, 21] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory.RESET();
        NS_JobRevenueCategory.setfilter(NS_Type, '%1', NS_JobRevenueCategory.NS_Type::Miscellaneous);
        IF NS_JobRevenueCategory.FINDSET() THEN begin
            NS_JobCalc.SETFILTER("NS_Revenue Category Filter", NS_JobRevenueCategory.NS_Code);
            NS_JobCalc.CALCFIELDS("NS_Budgeted Price (LCY)");
            NS_Amount := NS_JobCalc."NS_Budgeted Price (LCY)";
            NSCalcValues[5, 25] := NSCalcValues[5, 25] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory.RESET();
        NS_JobCalc.SETRANGE("NS_Revenue Category Filter");
        NS_JobCalc.CALCFIELDS("NS_Budgeted Price (LCY)");
        NSCalcValues[5, 29] := NS_JobCalc."NS_Budgeted Price (LCY)" - NS_TypedTotal;

        //New Calculation Values for Revenue Category - Phase-1 end

        IF PassedSubLevels THEN
            NS_TypedTotal := 0;
        // NS_JobRevenueCategory2.RESET();
        // IF NS_JobRevenueCategory2.FINDSET() THEN
        //     REPEAT
        //         NS_JobCalc.SETRANGE("NS_Revenue Category Filter", NS_JobRevenueCategory2.NS_Code);
        //         NS_Amount := rec.NS_SLsBudgetedPrice(NS_JobCalc);
        //         CASE NS_JobRevenueCategory2.NS_Type OF
        //             NS_JobRevenueCategory2.NS_Type::Labor:
        //                 NSCalcValues[5, 1] := NSCalcValues[5, 1] + NS_Amount;
        //             NS_JobRevenueCategory2.NS_Type::Material:
        //                 NSCalcValues[5, 5] := NSCalcValues[5, 5] + NS_Amount;
        //             NS_JobRevenueCategory2.NS_Type::Equipment:
        //                 NSCalcValues[5, 9] := NSCalcValues[5, 9] + NS_Amount;
        //             NS_JobRevenueCategory2.NS_Type::Subcontract:
        //                 NSCalcValues[5, 13] := NSCalcValues[5, 13] + NS_Amount;
        //             NS_JobRevenueCategory2.NS_Type::Manufacturing:
        //                 NSCalcValues[5, 17] := NSCalcValues[5, 17] + NS_Amount;
        //             NS_JobRevenueCategory2.NS_Type::Overhead:
        //                 NSCalcValues[5, 21] := NSCalcValues[5, 21] + NS_Amount;
        //             NS_JobRevenueCategory2.NS_Type::Miscellaneous:
        //                 NSCalcValues[5, 25] := NSCalcValues[5, 25] + NS_Amount;
        //         END;
        //         NS_TypedTotal := NS_TypedTotal + NS_Amount;
        //     UNTIL NS_JobRevenueCategory2.NEXT() = 0;
        // NS_JobCalc.SETRANGE("NS_Revenue Category Filter");
        // NS_Amount := rec.NS_SLsBudgetedPrice(NS_JobCalc);
        // NSCalcValues[5, 29] := NSCalcValues[5, 29] + NS_Amount - NS_TypedTotal;


        //New Calculation Values for Revenue Category - Phase-2 start
        NS_JobRevenueCategory2.RESET();
        NS_JobRevenueCategory2.setfilter(NS_Type, '%1', NS_JobRevenueCategory2.NS_Type::Labor);
        IF NS_JobRevenueCategory2.FINDSET() THEN begin
            NS_JobCalc.SETFILTER("NS_Revenue Category Filter", NS_JobRevenueCategory2.NS_Code);
            NS_Amount := rec.NS_SLsBudgetedPrice(NS_JobCalc);
            NSCalcValues[5, 1] := NSCalcValues[5, 1] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory2.RESET();
        NS_JobRevenueCategory2.setfilter(NS_Type, '%1', NS_JobRevenueCategory2.NS_Type::Material);
        IF NS_JobRevenueCategory2.FINDSET() THEN begin
            NS_JobCalc.SETFILTER("NS_Revenue Category Filter", NS_JobRevenueCategory2.NS_Code);
            NS_Amount := rec.NS_SLsBudgetedPrice(NS_JobCalc);
            NSCalcValues[5, 5] := NSCalcValues[5, 5] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory2.RESET();
        NS_JobRevenueCategory2.setfilter(NS_Type, '%1', NS_JobRevenueCategory2.NS_Type::Equipment);
        IF NS_JobRevenueCategory2.FINDSET() THEN begin
            NS_JobCalc.SETFILTER("NS_Revenue Category Filter", NS_JobRevenueCategory2.NS_Code);
            NS_Amount := rec.NS_SLsBudgetedPrice(NS_JobCalc);
            NSCalcValues[5, 9] := NSCalcValues[5, 9] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory2.RESET();
        NS_JobRevenueCategory2.setfilter(NS_Type, '%1', NS_JobRevenueCategory2.NS_Type::Subcontract);
        IF NS_JobRevenueCategory2.FINDSET() THEN begin
            NS_JobCalc.SETFILTER("NS_Revenue Category Filter", NS_JobRevenueCategory2.NS_Code);
            NS_Amount := rec.NS_SLsBudgetedPrice(NS_JobCalc);
            NSCalcValues[5, 13] := NSCalcValues[5, 13] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory2.RESET();
        NS_JobRevenueCategory2.setfilter(NS_Type, '%1', NS_JobRevenueCategory2.NS_Type::Manufacturing);
        IF NS_JobRevenueCategory2.FINDSET() THEN begin
            NS_JobCalc.SETFILTER("NS_Revenue Category Filter", NS_JobRevenueCategory2.NS_Code);
            NS_Amount := rec.NS_SLsBudgetedPrice(NS_JobCalc);
            NSCalcValues[5, 17] := NSCalcValues[5, 17] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory2.RESET();
        NS_JobRevenueCategory2.setfilter(NS_Type, '%1', NS_JobRevenueCategory2.NS_Type::Overhead);
        IF NS_JobRevenueCategory2.FINDSET() THEN begin
            NS_JobCalc.SETFILTER("NS_Revenue Category Filter", NS_JobRevenueCategory2.NS_Code);
            NS_Amount := rec.NS_SLsBudgetedPrice(NS_JobCalc);
            NSCalcValues[5, 21] := NSCalcValues[5, 21] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory2.RESET();
        NS_JobRevenueCategory2.setfilter(NS_Type, '%1', NS_JobRevenueCategory2.NS_Type::Miscellaneous);
        IF NS_JobRevenueCategory2.FINDSET() THEN begin
            NS_JobCalc.SETFILTER("NS_Revenue Category Filter", NS_JobRevenueCategory2.NS_Code);
            NS_Amount := rec.NS_SLsBudgetedPrice(NS_JobCalc);
            NSCalcValues[5, 25] := NSCalcValues[5, 25] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory2.RESET();
        NS_JobCalc.SETRANGE("NS_Revenue Category Filter");
        NS_JobCalc.CALCFIELDS("NS_Budgeted Price (LCY)");
        NSCalcValues[5, 29] := NS_JobCalc."NS_Budgeted Price (LCY)" - NS_TypedTotal;

        //New Calculation Values for Revenue Category - Phase-2 end

        // NS_TypedTotal := 0;
        // NS_JobRevenueCategory.RESET();
        // IF NS_JobRevenueCategory.FINDSET() THEN
        //     REPEAT
        //         NS_JobCalc.SETFILTER("NS_Revenue Category Filter", NS_JobRevenueCategory.NS_Code);
        //         NS_JobCalc.CALCFIELDS("NS_Invoiced Price (LCY)");
        //         NS_Amount := NS_JobCalc."NS_Invoiced Price (LCY)";
        //         CASE NS_JobRevenueCategory.NS_Type OF
        //             NS_JobRevenueCategory.NS_Type::Labor:
        //                 NSCalcValues[5, 2] := NSCalcValues[5, 2] + NS_Amount;
        //             NS_JobRevenueCategory.NS_Type::Material:
        //                 NSCalcValues[5, 6] := NSCalcValues[5, 6] + NS_Amount;
        //             NS_JobRevenueCategory.NS_Type::Equipment:
        //                 NSCalcValues[5, 10] := NSCalcValues[5, 10] + NS_Amount;
        //             NS_JobRevenueCategory.NS_Type::Subcontract:
        //                 NSCalcValues[5, 14] := NSCalcValues[5, 14] + NS_Amount;
        //             NS_JobRevenueCategory.NS_Type::Manufacturing:
        //                 NSCalcValues[5, 18] := NSCalcValues[5, 18] + NS_Amount;
        //             NS_JobRevenueCategory.NS_Type::Overhead:
        //                 NSCalcValues[5, 22] := NSCalcValues[5, 22] + NS_Amount;
        //             NS_JobRevenueCategory.NS_Type::Miscellaneous:
        //                 NSCalcValues[5, 26] := NSCalcValues[5, 26] + NS_Amount;
        //         END;
        //         NS_TypedTotal := NS_TypedTotal + NS_Amount;
        //     UNTIL NS_JobRevenueCategory.NEXT() = 0;
        // NS_JobCalc.SETRANGE("NS_Revenue Category Filter");
        // NS_JobCalc.CALCFIELDS("NS_Invoiced Price (LCY)");
        // NSCalcValues[5, 30] := NS_JobCalc."NS_Invoiced Price (LCY)" - NS_TypedTotal;


        //New Calculation Values for Revenue Category - Phase-3 start
        NS_TypedTotal := 0;
        NS_JobRevenueCategory.RESET();
        NS_JobRevenueCategory.setfilter(NS_Type, '%1', NS_JobRevenueCategory.NS_Type::Labor);
        IF NS_JobRevenueCategory.FINDSET() THEN begin
            NS_JobCalc.SETFILTER("NS_Revenue Category Filter", NS_JobRevenueCategory.NS_Code);
            NS_JobCalc.CALCFIELDS("NS_Invoiced Price (LCY)");
            NS_Amount := NS_JobCalc."NS_Invoiced Price (LCY)";
            NSCalcValues[5, 2] := NSCalcValues[5, 2] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory.RESET();
        NS_JobRevenueCategory.setfilter(NS_Type, '%1', NS_JobRevenueCategory.NS_Type::Material);
        IF NS_JobRevenueCategory.FINDSET() THEN begin
            NS_JobCalc.SETFILTER("NS_Revenue Category Filter", NS_JobRevenueCategory.NS_Code);
            NS_JobCalc.CALCFIELDS("NS_Invoiced Price (LCY)");
            NS_Amount := NS_JobCalc."NS_Invoiced Price (LCY)";
            NSCalcValues[5, 6] := NSCalcValues[5, 6] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory.RESET();
        NS_JobRevenueCategory.setfilter(NS_Type, '%1', NS_JobRevenueCategory.NS_Type::Equipment);
        IF NS_JobRevenueCategory.FINDSET() THEN begin
            NS_JobCalc.SETFILTER("NS_Revenue Category Filter", NS_JobRevenueCategory.NS_Code);
            NS_JobCalc.CALCFIELDS("NS_Invoiced Price (LCY)");
            NS_Amount := NS_JobCalc."NS_Invoiced Price (LCY)";
            NSCalcValues[5, 10] := NSCalcValues[5, 10] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory.RESET();
        NS_JobRevenueCategory.setfilter(NS_Type, '%1', NS_JobRevenueCategory.NS_Type::Subcontract);
        IF NS_JobRevenueCategory.FINDSET() THEN begin
            NS_JobCalc.SETFILTER("NS_Revenue Category Filter", NS_JobRevenueCategory.NS_Code);
            NS_JobCalc.CALCFIELDS("NS_Invoiced Price (LCY)");
            NS_Amount := NS_JobCalc."NS_Invoiced Price (LCY)";
            NSCalcValues[5, 14] := NSCalcValues[5, 14] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory.RESET();
        NS_JobRevenueCategory.setfilter(NS_Type, '%1', NS_JobRevenueCategory.NS_Type::Manufacturing);
        IF NS_JobRevenueCategory.FINDSET() THEN begin
            NS_JobCalc.SETFILTER("NS_Revenue Category Filter", NS_JobRevenueCategory.NS_Code);
            NS_JobCalc.CALCFIELDS("NS_Invoiced Price (LCY)");
            NS_Amount := NS_JobCalc."NS_Invoiced Price (LCY)";
            NSCalcValues[5, 18] := NSCalcValues[5, 18] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory.RESET();
        NS_JobRevenueCategory.setfilter(NS_Type, '%1', NS_JobRevenueCategory.NS_Type::Overhead);
        IF NS_JobRevenueCategory.FINDSET() THEN begin
            NS_JobCalc.SETFILTER("NS_Revenue Category Filter", NS_JobRevenueCategory.NS_Code);
            NS_JobCalc.CALCFIELDS("NS_Invoiced Price (LCY)");
            NS_Amount := NS_JobCalc."NS_Invoiced Price (LCY)";
            NSCalcValues[5, 22] := NSCalcValues[5, 22] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory.RESET();
        NS_JobRevenueCategory.setfilter(NS_Type, '%1', NS_JobRevenueCategory.NS_Type::Miscellaneous);
        IF NS_JobRevenueCategory.FINDSET() THEN begin
            NS_JobCalc.SETFILTER("NS_Revenue Category Filter", NS_JobRevenueCategory.NS_Code);
            NS_JobCalc.CALCFIELDS("NS_Invoiced Price (LCY)");
            NS_Amount := NS_JobCalc."NS_Invoiced Price (LCY)";
            NSCalcValues[5, 26] := NSCalcValues[5, 26] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory.RESET();
        NS_JobCalc.SETRANGE("NS_Revenue Category Filter");
        NS_JobCalc.CALCFIELDS("NS_Invoiced Price (LCY)");
        NSCalcValues[5, 30] := NS_JobCalc."NS_Invoiced Price (LCY)" - NS_TypedTotal;

        //New Calculation Values for Revenue Category - Phase-3 end



        IF PassedSubLevels THEN
            NS_TypedTotal := 0;
        // NS_JobRevenueCategory2.RESET();
        // IF NS_JobRevenueCategory2.FINDSET() THEN
        //     REPEAT
        //         NS_JobCalc.SETRANGE("NS_Revenue Category Filter", NS_JobRevenueCategory2.NS_Code);
        //         NS_Amount := rec.SLsInvoicedPrice(NS_JobCalc);
        //         CASE NS_JobRevenueCategory2.NS_Type OF
        //             NS_JobRevenueCategory2.NS_Type::Labor:
        //                 NSCalcValues[5, 2] := NSCalcValues[5, 2] + NS_Amount;
        //             NS_JobRevenueCategory2.NS_Type::Material:
        //                 NSCalcValues[5, 6] := NSCalcValues[5, 6] + NS_Amount;
        //             NS_JobRevenueCategory2.NS_Type::Equipment:
        //                 NSCalcValues[5, 10] := NSCalcValues[5, 10] + NS_Amount;
        //             NS_JobRevenueCategory2.NS_Type::Subcontract:
        //                 NSCalcValues[5, 14] := NSCalcValues[5, 14] + NS_Amount;
        //             NS_JobRevenueCategory2.NS_Type::Manufacturing:
        //                 NSCalcValues[5, 18] := NSCalcValues[5, 18] + NS_Amount;
        //             NS_JobRevenueCategory2.NS_Type::Overhead:
        //                 NSCalcValues[5, 22] := NSCalcValues[5, 22] + NS_Amount;
        //             NS_JobRevenueCategory2.NS_Type::Miscellaneous:
        //                 NSCalcValues[5, 26] := NSCalcValues[5, 26] + NS_Amount;
        //         END;
        //         NS_TypedTotal := NS_TypedTotal + NS_Amount;
        //     UNTIL NS_JobRevenueCategory2.NEXT = 0;
        // NS_JobCalc.SETRANGE("NS_Revenue Category Filter");
        // NS_Amount := rec.SLsInvoicedPrice(NS_JobCalc);
        // NSCalcValues[5, 30] := NSCalcValues[5, 30] + NS_Amount - NS_TypedTotal;


        //New Calculation Values for Revenue Category - Phase-4 start        
        NS_JobRevenueCategory2.RESET();
        NS_JobRevenueCategory2.setfilter(NS_Type, '%1', NS_JobRevenueCategory2.NS_Type::Labor);
        IF NS_JobRevenueCategory.FINDSET() THEN begin
            NS_JobCalc.SETRANGE("NS_Revenue Category Filter", NS_JobRevenueCategory2.NS_Code);
            NS_Amount := rec.SLsInvoicedPrice(NS_JobCalc);
            NSCalcValues[5, 2] := NSCalcValues[5, 2] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory2.RESET();
        NS_JobRevenueCategory2.setfilter(NS_Type, '%1', NS_JobRevenueCategory2.NS_Type::Material);
        IF NS_JobRevenueCategory2.FINDSET() THEN begin
            NS_JobCalc.SETRANGE("NS_Revenue Category Filter", NS_JobRevenueCategory2.NS_Code);
            NS_Amount := rec.SLsInvoicedPrice(NS_JobCalc);
            NSCalcValues[5, 6] := NSCalcValues[5, 6] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory2.RESET();
        NS_JobRevenueCategory2.setfilter(NS_Type, '%1', NS_JobRevenueCategory2.NS_Type::Equipment);
        IF NS_JobRevenueCategory2.FINDSET() THEN begin
            NS_JobCalc.SETRANGE("NS_Revenue Category Filter", NS_JobRevenueCategory2.NS_Code);
            NS_Amount := rec.SLsInvoicedPrice(NS_JobCalc);
            NSCalcValues[5, 10] := NSCalcValues[5, 10] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory2.RESET();
        NS_JobRevenueCategory2.setfilter(NS_Type, '%1', NS_JobRevenueCategory2.NS_Type::Subcontract);
        IF NS_JobRevenueCategory2.FINDSET() THEN begin
            NS_JobCalc.SETRANGE("NS_Revenue Category Filter", NS_JobRevenueCategory2.NS_Code);
            NS_Amount := rec.SLsInvoicedPrice(NS_JobCalc);
            NSCalcValues[5, 14] := NSCalcValues[5, 14] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory2.RESET();
        NS_JobRevenueCategory2.setfilter(NS_Type, '%1', NS_JobRevenueCategory2.NS_Type::Manufacturing);
        IF NS_JobRevenueCategory2.FINDSET() THEN begin
            NS_JobCalc.SETRANGE("NS_Revenue Category Filter", NS_JobRevenueCategory2.NS_Code);
            NS_Amount := rec.SLsInvoicedPrice(NS_JobCalc);
            NSCalcValues[5, 18] := NSCalcValues[5, 18] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory2.RESET();
        NS_JobRevenueCategory2.setfilter(NS_Type, '%1', NS_JobRevenueCategory2.NS_Type::Overhead);
        IF NS_JobRevenueCategory2.FINDSET() THEN begin
            NS_JobCalc.SETRANGE("NS_Revenue Category Filter", NS_JobRevenueCategory2.NS_Code);
            NS_Amount := rec.SLsInvoicedPrice(NS_JobCalc);
            NSCalcValues[5, 22] := NSCalcValues[5, 22] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory2.RESET();
        NS_JobRevenueCategory2.setfilter(NS_Type, '%1', NS_JobRevenueCategory2.NS_Type::Miscellaneous);
        IF NS_JobRevenueCategory2.FINDSET() THEN begin
            NS_JobCalc.SETRANGE("NS_Revenue Category Filter", NS_JobRevenueCategory2.NS_Code);
            NS_Amount := rec.SLsInvoicedPrice(NS_JobCalc);
            NSCalcValues[5, 26] := NSCalcValues[5, 26] + NS_Amount;
            NS_TypedTotal := NS_TypedTotal + NS_Amount;
        end;

        NS_JobRevenueCategory2.RESET();
        NS_JobCalc.SETRANGE("NS_Revenue Category Filter");
        NS_Amount := rec.SLsInvoicedPrice(NS_JobCalc);
        NSCalcValues[5, 30] := NS_JobCalc."NS_Invoiced Price (LCY)" - NS_TypedTotal;

        //New Calculation Values for Revenue Category - Phase-4 end


        //Fill in Variance & Variance %
        FOR NS_Qty := 0 TO 7 DO BEGIN
            NSCalcValues[5, (NS_Qty * 4) + 3] := NSCalcValues[5, (NS_Qty * 4) + 1] - NSCalcValues[5, (NS_Qty * 4) + 2];
            NSCalcValues[5, (NS_Qty * 4) + 4] := rec.VariancePercent(NSCalcValues[5, (NS_Qty * 4) + 3], NSCalcValues[5, (NS_Qty * 4) + 1]);
        END;

        //Fill in total line
        FOR NS_Qty := 0 TO 7 DO BEGIN
            NSCalcValues[5, 33] := NSCalcValues[5, 33] + NSCalcValues[5, (NS_Qty * 4) + 1];
            NSCalcValues[5, 34] := NSCalcValues[5, 34] + NSCalcValues[5, (NS_Qty * 4) + 2];
            NSCalcValues[5, 35] := NSCalcValues[5, 35] + NSCalcValues[5, (NS_Qty * 4) + 3];
            NSCalcValues[5, 36] := rec.VariancePercent(NSCalcValues[5, 35], NSCalcValues[5, 33]);
        END;

    END;

}