/// <summary>
/// Page NS Job Balance Chart (ID 14021120).
/// </summary>
/// PE-115.JS.1.0 03July2023 New Pages
page 14021120 "NS Job Balance Chart"
{
    Caption = 'ProjectPro Job Graphics';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Business Chart Buffer";

    layout
    {
        area(Content)
        {
            usercontrol(BusinessChart; "Microsoft.Dynamics.Nav.Client.BusinessChart")
            {
                ApplicationArea = Basic;

                trigger AddInReady()
                begin
                    NSUpdateJobChart();
                end;

                trigger Refresh()
                begin
                    NSUpdateJobChart();
                end;
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(JobChartSetup)
            {
                ApplicationArea = All;
                Caption = 'Job Chart Setup';
                Promoted = true;
                PromotedCategory = Process;
                Image = BarChart;


                trigger OnAction()
                begin
                    Page.RunModal(Page::"NS_Job_Chart Setup");
                    NSUpdateJobChart();
                end;
            }
        }
    }

    var
        NSJobChartManagement: Codeunit "NS_Job Chart Management";

    local procedure NSUpdateJobChart()
    var
        NSJobRec: Record Job;
        NSJobChartIndex: Record "NS_Job Chart Index";
        NSJobChartSetup: Record "NS_Job_Chart Setup";
        NSTotalBudgetedCostMgr: Decimal;
        NSTotalBudgetedPriceMgr: Decimal;
        NSTotalUsegeCostMgr: Decimal;
        NSTotalInvPriceMgr: Decimal;
        NSTotalBudgetedCostGBPG: Decimal;
        NSTotalBudgetedPriceGBPG: Decimal;
        NSTotalUsegeCostGBPG: Decimal;
        NSTotalInvPriceGBPG: Decimal;
        NSTotalBudgetedHours: Decimal;
        NSTotalBudgetedCostHours: Decimal;
        NSTotalUsegeHours: Decimal;
        NSTotalUsegeCostHours: Decimal;
        NSRowIndexNo: Integer;
    begin
        Clear(NSTotalBudgetedCostMgr);
        Clear(NSTotalBudgetedPriceMgr);
        Clear(NSTotalUsegeCostMgr);
        Clear(NSTotalInvPriceMgr);
        Clear(NSTotalBudgetedCostGBPG);
        Clear(NSTotalBudgetedPriceGBPG);
        Clear(NSTotalUsegeCostGBPG);
        Clear(NSTotalInvPriceGBPG);
        Clear(NSTotalBudgetedHours);
        Clear(NSTotalBudgetedCostHours);
        Clear(NSTotalUsegeHours);
        Clear(NSTotalUsegeCostHours);
        NSRowIndexNo := 1;
        if NSJobChartIndex.FindFirst() then
            NSJobChartIndex.DeleteAll();
        if NSJobChartSetup.FindFirst() then begin
            if (NSJobChartSetup."NS_Project Manager No." = '') and (NSJobChartSetup."NS_Job No." <> '')
                and (NSJobChartSetup."NS_Gen. Bus. Posting Group" = '') and (NSJobChartSetup."NS_Hours Details" = false) then begin
                NSJobChartIndex.Init();
                if NSJobRec.Get(NSJobChartSetup."NS_Job No.") then begin
                    if NSJobRec."NS_Job Class" = NSJobRec."NS_Job Class"::"Master Job" then begin
                        repeat
                            //Message('MMMMM %1', NSRowIndexNo);
                            NSJobRec.CalcFields("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)", "NS_Usage (Cost) (LCY)", "NS_Invoiced Price (LCY)");
                            NSJobChartIndex.Init();
                            NSJobChartIndex."NS_Chart Index No." := NSRowIndexNo;
                            NSJobChartIndex."NS_Document No." := NSJobRec."No.";
                            NSJobChartIndex."NS_Job Description" := NSJobRec.Description;
                            if NSRowIndexNo = 1 then begin
                                NSJobChartIndex."NS_Index Value" := NSJobRec."NS_Budgeted Cost (LCY)";
                                NSJobChartIndex."NS_Value Description" := 'Budgeted Cost (LCY)';
                            end;
                            if NSRowIndexNo = 2 then begin
                                //NSJobChartIndex."NS_Index Value" := NSJobRec."NS_Budgeted Price (LCY)";
                                //NSJobChartIndex."NS_Value Description" := 'Budgeted Price (LCY)';
                                NSJobChartIndex."NS_Index Value" := NSJobRec."NS_Usage (Cost) (LCY)";
                                NSJobChartIndex."NS_Value Description" := 'Usage (Cost) (LCY)';
                            end;
                            if NSRowIndexNo = 3 then begin
                                //NSJobChartIndex."NS_Index Value" := NSJobRec."NS_Usage (Cost) (LCY)";
                                //NSJobChartIndex."NS_Value Description" := 'Usage (Cost) (LCY)';
                                NSJobChartIndex."NS_Index Value" := NSJobRec."NS_Budgeted Price (LCY)";
                                NSJobChartIndex."NS_Value Description" := 'Budgeted Price (LCY)';
                            end;
                            if NSRowIndexNo = 4 then begin
                                NSJobChartIndex."NS_Index Value" := NSJobRec."NS_Invoiced Price (LCY)";
                                NSJobChartIndex."NS_Value Description" := 'Invoiced Price (LCY)';
                            end;
                            NSJobChartIndex.Insert();
                            NSRowIndexNo := NSRowIndexNo + 1;
                        until NSRowIndexNo = 5;
                    end;
                end;
            end;
            if (NSJobChartSetup."NS_Project Manager No." <> '') and (NSJobChartSetup."NS_Job No." = '')
                and (NSJobChartSetup."NS_Gen. Bus. Posting Group" = '') and (NSJobChartSetup."NS_Hours Details" = false) then begin
                NSTotalBudgetedCostMgr := GetTotalBudgetedCostLCYManagerWise(NSJobChartSetup."NS_Project Manager No.");
                NSTotalBudgetedPriceMgr := GetTotalBudgetedPriceLCYManagerWise(NSJobChartSetup."NS_Project Manager No.");
                NSTotalUsegeCostMgr := GetTotalUsageCostLCYManagerWise(NSJobChartSetup."NS_Project Manager No.");
                NSTotalInvPriceMgr := GetTotalInvPriceLCYManagerWise(NSJobChartSetup."NS_Project Manager No.");
                repeat
                    NSJobChartIndex.Init();
                    NSJobChartIndex."NS_Chart Index No." := NSRowIndexNo;
                    NSJobChartIndex."NS_Document No." := NSJobRec."No.";
                    NSJobChartIndex."NS_Job Description" := NSJobRec.Description;
                    NSJobChartIndex."NS_Project Manager No." := NSJobChartSetup."NS_Project Manager No.";
                    NSJobChartIndex."NS_ChartProject Mgr. Name" := NSJobChartSetup."NS_ChartProject Mgr. Name";
                    if NSRowIndexNo = 1 then begin
                        NSJobChartIndex."NS_Index Value" := NSTotalBudgetedCostMgr;
                        NSJobChartIndex."NS_Value Description" := 'Budgeted Cost (LCY)';
                    end;
                    if NSRowIndexNo = 2 then begin
                        //NSJobChartIndex."NS_Index Value" := NSTotalBudgetedPriceMgr;
                        //NSJobChartIndex."NS_Value Description" := 'Budgeted Price (LCY)';
                        NSJobChartIndex."NS_Index Value" := NSTotalUsegeCostMgr;
                        NSJobChartIndex."NS_Value Description" := 'Usage (Cost) (LCY)';
                    end;
                    if NSRowIndexNo = 3 then begin
                        //NSJobChartIndex."NS_Index Value" := NSTotalUsegeCostMgr;
                        //NSJobChartIndex."NS_Value Description" := 'Usage (Cost) (LCY)';
                        NSJobChartIndex."NS_Index Value" := NSTotalBudgetedPriceMgr;
                        NSJobChartIndex."NS_Value Description" := 'Budgeted Price (LCY)';
                    end;
                    if NSRowIndexNo = 4 then begin
                        NSJobChartIndex."NS_Index Value" := NSTotalInvPriceMgr;
                        NSJobChartIndex."NS_Value Description" := 'Invoiced Price (LCY)';
                    end;
                    NSJobChartIndex.Insert();
                    NSRowIndexNo := NSRowIndexNo + 1;
                until NSRowIndexNo = 5;
            end;
            if (NSJobChartSetup."NS_Project Manager No." = '') and (NSJobChartSetup."NS_Job No." = '')
                and (NSJobChartSetup."NS_Gen. Bus. Posting Group" <> '') and (NSJobChartSetup."NS_Hours Details" = false) then begin
                NSTotalBudgetedCostGBPG := GetTotalBudgetedCostLCYGBPGWise(NSJobChartSetup."NS_Gen. Bus. Posting Group");
                NSTotalBudgetedPriceGBPG := GetTotalBudgetedPriceLCYGBPGWise(NSJobChartSetup."NS_Gen. Bus. Posting Group");
                NSTotalUsegeCostGBPG := GetTotalUsageCostLCYGBPGWise(NSJobChartSetup."NS_Gen. Bus. Posting Group");
                NSTotalInvPriceGBPG := GetTotalInvPriceLCYGBPGWise(NSJobChartSetup."NS_Gen. Bus. Posting Group");
                repeat
                    NSJobChartIndex.Init();
                    NSJobChartIndex."NS_Chart Index No." := NSRowIndexNo;
                    NSJobChartIndex."NS_Document No." := NSJobRec."No.";
                    NSJobChartIndex."NS_Job Description" := NSJobRec.Description;
                    NSJobChartIndex."NS_Gen. Bus. Posting Group" := NSJobChartSetup."NS_Gen. Bus. Posting Group";
                    //NSJobChartIndex."NS_Project Manager No." := NSJobChartSetup."NS_Project Manager No.";
                    //NSJobChartIndex."NS_ChartProject Mgr. Name" := NSJobChartSetup."NS_ChartProject Mgr. Name";
                    if NSRowIndexNo = 1 then begin
                        NSJobChartIndex."NS_Index Value" := NSTotalBudgetedCostGBPG;
                        NSJobChartIndex."NS_Value Description" := 'Budgeted Cost (LCY)';
                    end;
                    if NSRowIndexNo = 2 then begin
                        //NSJobChartIndex."NS_Index Value" := NSTotalBudgetedPriceGBPG;
                        //NSJobChartIndex."NS_Value Description" := 'Budgeted Price (LCY)';
                        NSJobChartIndex."NS_Index Value" := NSTotalUsegeCostGBPG;
                        NSJobChartIndex."NS_Value Description" := 'Usage (Cost) (LCY)';
                    end;
                    if NSRowIndexNo = 3 then begin
                        //NSJobChartIndex."NS_Index Value" := NSTotalUsegeCostGBPG;
                        //NSJobChartIndex."NS_Value Description" := 'Usage (Cost) (LCY)';
                        NSJobChartIndex."NS_Index Value" := NSTotalBudgetedPriceGBPG;
                        NSJobChartIndex."NS_Value Description" := 'Budgeted Price (LCY)';
                    end;
                    if NSRowIndexNo = 4 then begin
                        NSJobChartIndex."NS_Index Value" := NSTotalInvPriceGBPG;
                        NSJobChartIndex."NS_Value Description" := 'Invoiced Price (LCY)';
                    end;
                    NSJobChartIndex.Insert();
                    NSRowIndexNo := NSRowIndexNo + 1;
                until NSRowIndexNo = 5;
            end;
            //For Hours Detaisl only - Start
            if (NSJobChartSetup."NS_Project Manager No." = '') and (NSJobChartSetup."NS_Job No." <> '')
                and (NSJobChartSetup."NS_Gen. Bus. Posting Group" = '') and (NSJobChartSetup."NS_Hours Details" = True) then begin
                if NSJobRec.Get(NSJobChartSetup."NS_Job No.") then begin
                    if NSJobRec."NS_Job Class" = NSJobRec."NS_Job Class"::"Master Job" then begin
                        NSTotalBudgetedHours := GetTotalBudgetedHourJobWise(NSJobChartSetup."NS_Job No.");
                        NSTotalBudgetedCostHours := GetTotalBudgetedHourJobAmtWise(NSJobChartSetup."NS_Job No.");
                        NSTotalUsegeHours := GetTotalUsageHourJobWise(NSJobChartSetup."NS_Job No.");
                        NSTotalUsegeCostHours := GetTotalUsageAmtHourJobWise(NSJobChartSetup."NS_Job No.");
                        repeat
                            //Message('MMMMM');
                            NSJobChartIndex.Init();
                            NSJobChartIndex."NS_Chart Index No." := NSRowIndexNo;
                            NSJobChartIndex."NS_Document No." := NSJobRec."No.";
                            NSJobChartIndex."NS_Job Description" := NSJobRec.Description;
                            NSJobChartIndex."NS_Hours Details" := true;
                            if NSRowIndexNo = 1 then begin
                                NSJobChartIndex."NS_Index Value" := NSTotalBudgetedHours;
                                NSJobChartIndex."NS_Value Description" := 'Budgeted Hours';
                                NSJobChartIndex."NS_Value UOM" := 'Hours';

                            end;
                            if NSRowIndexNo = 2 then begin
                                NSJobChartIndex."NS_Index Value" := NSTotalBudgetedCostHours;
                                NSJobChartIndex."NS_Value Description" := 'Budgeted Cost (LCY)';
                                NSJobChartIndex."NS_Value UOM" := 'Value';
                            end;
                            if NSRowIndexNo = 3 then begin
                                NSJobChartIndex."NS_Index Value" := NSTotalUsegeHours;
                                NSJobChartIndex."NS_Value Description" := 'Usage Hours';
                                NSJobChartIndex."NS_Value UOM" := 'Hours';
                            end;
                            if NSRowIndexNo = 4 then begin
                                NSJobChartIndex."NS_Index Value" := NSTotalUsegeCostHours;
                                NSJobChartIndex."NS_Value Description" := 'Usage Cost (LCY)';
                                NSJobChartIndex."NS_Value UOM" := 'Value';
                            end;
                            NSJobChartIndex.Insert();
                            NSRowIndexNo := NSRowIndexNo + 1;
                        until NSRowIndexNo = 5;
                    end;
                end;
            end;
            //For Hours Detaisl only - end
        end;
        NSJobChartManagement.GeneratJobChartData(Rec);
        rec.Update(CurrPage.BusinessChart);
    end;


    //ProjectManager wise
    local procedure GetTotalBudgetedCostLCYManagerWise(Var PMNo: Code[20]) ToTBudgetCostMgr: Decimal
    var
        NSJobsMgr: Record Job;
    begin
        NSJobsMgr.Reset();
        NSJobsMgr.SetFilter("NS_Manager", '%1', PMNo);
        if NSJobsMgr.FindSet() then begin
            repeat
                if NSJobsMgr."NS_Job Class" = NSJobsMgr."NS_Job Class"::"Master Job" then begin
                    NSJobsMgr.CalcFields("NS_Budgeted Cost (LCY)");
                    ToTBudgetCostMgr := ToTBudgetCostMgr + NSJobsMgr."NS_Budgeted Cost (LCY)";
                end;
            until NSJobsMgr.Next() = 0;
        end;
        exit(ToTBudgetCostMgr);
    end;

    local procedure GetTotalBudgetedPriceLCYManagerWise(Var PMNo: Code[20]) ToTBudgetPriceMgr: Decimal
    var
        NSJobsMgr: Record Job;
    begin
        NSJobsMgr.Reset();
        NSJobsMgr.SetFilter("NS_Manager", '%1', PMNo);
        if NSJobsMgr.FindSet() then begin
            repeat
                if NSJobsMgr."NS_Job Class" = NSJobsMgr."NS_Job Class"::"Master Job" then begin
                    NSJobsMgr.CalcFields("NS_Budgeted Price (LCY)");
                    ToTBudgetPriceMgr := ToTBudgetPriceMgr + NSJobsMgr."NS_Budgeted Price (LCY)";
                end;
            until NSJobsMgr.Next() = 0;
        end;
        exit(ToTBudgetPriceMgr);
    end;

    //GetTotalUsageCostLCYManagerWise

    local procedure GetTotalUsageCostLCYManagerWise(Var PMNo: Code[20]) ToTUsageCostMgr: Decimal
    var
        NSJobsMgr: Record Job;
    begin
        NSJobsMgr.Reset();
        NSJobsMgr.SetFilter("NS_Manager", '%1', PMNo);
        if NSJobsMgr.FindSet() then begin
            repeat
                if NSJobsMgr."NS_Job Class" = NSJobsMgr."NS_Job Class"::"Master Job" then begin
                    NSJobsMgr.CalcFields("NS_Usage (Cost) (LCY)");
                    ToTUsageCostMgr := ToTUsageCostMgr + NSJobsMgr."NS_Usage (Cost) (LCY)";
                end;
            until NSJobsMgr.Next() = 0;
        end;
        exit(ToTUsageCostMgr);
    end;

    //GetTotalInvPriceLCYManagerWise
    local procedure GetTotalInvPriceLCYManagerWise(Var PMNo: Code[20]) ToTInvPriceMgr: Decimal
    var
        NSJobsMgr: Record Job;
    begin
        NSJobsMgr.Reset();
        NSJobsMgr.SetFilter("NS_Manager", '%1', PMNo);
        if NSJobsMgr.FindSet() then begin
            repeat
                if NSJobsMgr."NS_Job Class" = NSJobsMgr."NS_Job Class"::"Master Job" then begin
                    NSJobsMgr.CalcFields("NS_Invoiced Price (LCY)");
                    ToTInvPriceMgr := ToTInvPriceMgr + NSJobsMgr."NS_Invoiced Price (LCY)";
                end;
            until NSJobsMgr.Next() = 0;
        end;
        exit(ToTInvPriceMgr);
    end;

    // Gen. Business Posting Group Wise
    local procedure GetTotalBudgetedCostLCYGBPGWise(Var GBPGNo: Code[20]) ToTBudgetCostGBPG: Decimal
    var
        NSJobsMgr: Record Job;
    begin
        NSJobsMgr.Reset();
        NSJobsMgr.Setfilter("NS_Gen. Bus. Posting Group New", '%1', GBPGNo);
        if NSJobsMgr.FindSet() then begin
            repeat
                if NSJobsMgr."NS_Job Class" = NSJobsMgr."NS_Job Class"::"Master Job" then begin
                    NSJobsMgr.CalcFields("NS_Budgeted Cost (LCY)");
                    ToTBudgetCostGBPG := ToTBudgetCostGBPG + NSJobsMgr."NS_Budgeted Cost (LCY)";
                end;
            until NSJobsMgr.Next() = 0;
        end;
        exit(ToTBudgetCostGBPG);
    end;

    local procedure GetTotalBudgetedPriceLCYGBPGWise(Var GBPGNo: Code[20]) ToTBudgetPriceGBPG: Decimal
    var
        NSJobsMgr: Record Job;
    begin
        NSJobsMgr.Reset();
        NSJobsMgr.Setfilter("NS_Gen. Bus. Posting Group New", '%1', GBPGNo);
        if NSJobsMgr.FindSet() then begin
            repeat
                if NSJobsMgr."NS_Job Class" = NSJobsMgr."NS_Job Class"::"Master Job" then begin
                    NSJobsMgr.CalcFields("NS_Budgeted Price (LCY)");
                    ToTBudgetPriceGBPG := ToTBudgetPriceGBPG + NSJobsMgr."NS_Budgeted Price (LCY)";
                end;
            until NSJobsMgr.Next() = 0;
        end;
        exit(ToTBudgetPriceGBPG);
    end;

    //GetTotalUsageCostLCYManagerWise

    local procedure GetTotalUsageCostLCYGBPGWise(Var GBPGNo: Code[20]) ToTUsageCostGBPG: Decimal
    var
        NSJobsMgr: Record Job;
    begin
        NSJobsMgr.Reset();
        NSJobsMgr.Setfilter("NS_Gen. Bus. Posting Group New", '%1', GBPGNo);
        if NSJobsMgr.FindSet() then begin
            repeat
                if NSJobsMgr."NS_Job Class" = NSJobsMgr."NS_Job Class"::"Master Job" then begin
                    NSJobsMgr.CalcFields("NS_Usage (Cost) (LCY)");
                    ToTUsageCostGBPG := ToTUsageCostGBPG + NSJobsMgr."NS_Usage (Cost) (LCY)";
                end;
            until NSJobsMgr.Next() = 0;
        end;
        exit(ToTUsageCostGBPG);
    end;

    //GetTotalInvPriceLCYManagerWise
    local procedure GetTotalInvPriceLCYGBPGWise(Var GBPGNo: Code[20]) ToTInvPriceGBPG: Decimal
    var
        NSJobsMgr: Record Job;
    begin
        NSJobsMgr.Reset();
        NSJobsMgr.Setfilter("NS_Gen. Bus. Posting Group New", '%1', GBPGNo);
        if NSJobsMgr.FindSet() then begin
            repeat
                if NSJobsMgr."NS_Job Class" = NSJobsMgr."NS_Job Class"::"Master Job" then begin
                    NSJobsMgr.CalcFields("NS_Invoiced Price (LCY)");
                    ToTInvPriceGBPG := ToTInvPriceGBPG + NSJobsMgr."NS_Invoiced Price (LCY)";
                end;
            until NSJobsMgr.Next() = 0;
        end;
        exit(ToTInvPriceGBPG);
    end;

    //Get total Budget Hours-Start
    local procedure GetTotalBudgetedHourJobWise(Var JobNo: Code[20]) ToTBudgetHRJobWise: Decimal
    var
        NSJobHR: Record Job;
        NSJobPlanLines: record "Job Planning Line";
    begin
        ToTBudgetHRJobWise := 0;
        if NSJobHR.get(JobNo) then begin
            if NSJobHR."NS_Job Class" = NSJobHR."NS_Job Class"::"Master Job" then begin
                NSJobPlanLines.Reset();
                NSJobPlanLines.SetFilter("Job No.", '%1', JobNo);
                NSJobPlanLines.SetFilter("Line Type", '%1|%2', NSJobPlanLines."Line Type"::Budget, NSJobPlanLines."Line Type"::"Both Budget and Billable");
                NSJobPlanLines.SetFilter(type, '%1', NSJobPlanLines.Type::Resource);
                NSJobPlanLines.SetFilter(Quantity, '<>%1', 0);
                NSJobPlanLines.SetFilter("Unit of Measure Code", '%1', 'HR');
                if NSJobPlanLines.FindSet() then begin
                    NSJobPlanLines.CalcSums(Quantity);
                    ToTBudgetHRJobWise := NSJobPlanLines.Quantity;
                    //Message('AAAA');
                end;
            end;
        end;
        exit(ToTBudgetHRJobWise);
    end;

    local procedure GetTotalBudgetedHourJobAmtWise(Var JobNo: Code[20]) ToTBudgetHRJobAmtWise: Decimal
    var
        NSJobHR: Record Job;
        NSJobPlanLines: record "Job Planning Line";
    begin
        ToTBudgetHRJobAmtWise := 0;
        if NSJobHR.get(JobNo) then begin
            if NSJobHR."NS_Job Class" = NSJobHR."NS_Job Class"::"Master Job" then begin
                NSJobPlanLines.Reset();
                NSJobPlanLines.SetFilter("Job No.", '%1', JobNo);
                NSJobPlanLines.SetFilter("Line Type", '%1|%2', NSJobPlanLines."Line Type"::Budget, NSJobPlanLines."Line Type"::"Both Budget and Billable");
                NSJobPlanLines.SetFilter(type, '%1', NSJobPlanLines.Type::Resource);
                NSJobPlanLines.SetFilter(Quantity, '<>%1', 0);
                NSJobPlanLines.SetFilter("Unit of Measure Code", '%1', 'HR');
                if NSJobPlanLines.FindSet() then begin
                    NSJobPlanLines.CalcSums("Total Cost (LCY)");
                    ToTBudgetHRJobAmtWise := NSJobPlanLines."Total Cost (LCY)";
                    //Message('BBBB');
                end;
            end;
        end;
        exit(ToTBudgetHRJobAmtWise);
    end;

    local procedure GetTotalUsageHourJobWise(Var JobNo: Code[20]) ToTUsageHRJobWise: Decimal
    var
        NSJobLedgerEntry: record "Job Ledger Entry";
    begin
        ToTUsageHRJobWise := 0;
        NSJobLedgerEntry.Reset();
        NSJobLedgerEntry.SetFilter("Job No.", '%1', JobNo);
        NSJobLedgerEntry.SetFilter("Entry Type", '%1', NSJobLedgerEntry."Entry Type"::Usage);
        NSJobLedgerEntry.SetFilter(type, '%1', NSJobLedgerEntry.Type::Resource);
        NSJobLedgerEntry.SetFilter(Quantity, '<>%1', 0);
        NSJobLedgerEntry.SetFilter("Unit of Measure Code", '%1', 'HR');
        if NSJobLedgerEntry.FindSet() then begin
            NSJobLedgerEntry.CalcSums(Quantity);
            ToTUsageHRJobWise := NSJobLedgerEntry.Quantity;
            //Message('CCCCC');
        end;
        exit(ToTUsageHRJobWise);
    end;

    local procedure GetTotalUsageAmtHourJobWise(Var JobNo: Code[20]) ToTUsageAmtHRJobWise: Decimal
    var
        NSJobLedgerEntry: record "Job Ledger Entry";
    begin
        ToTUsageAmtHRJobWise := 0;
        NSJobLedgerEntry.Reset();
        NSJobLedgerEntry.SetFilter("Job No.", '%1', JobNo);
        NSJobLedgerEntry.SetFilter("Entry Type", '%1', NSJobLedgerEntry."Entry Type"::Usage);
        NSJobLedgerEntry.SetFilter(type, '%1', NSJobLedgerEntry.Type::Resource);
        NSJobLedgerEntry.SetFilter("Total Cost (LCY)", '<>%1', 0);
        NSJobLedgerEntry.SetFilter("Unit of Measure Code", '%1', 'HR');
        if NSJobLedgerEntry.FindSet() then begin
            NSJobLedgerEntry.CalcSums(Quantity);
            ToTUsageAmtHRJobWise := NSJobLedgerEntry."Total Cost (LCY)";
            //Message('DDDDD');
        end;
        exit(ToTUsageAmtHRJobWise);
    end;
    //Get total Budget Hours-end

}