//PE-115.DK.1.0 5july2023 START
controladdin NSmyGeneric
{
    Scripts = 'NSProjectProChart.js', 'NSProjectProJobScript.js';
    StartupScript = 'addin/src/NSProjectProStartup.js';
    //StyleSheets = 'Progress1.css';
    RequestedHeight = 300;
    RequestedWidth = 400;
    RefreshScript = 'addin/src/NSProjectProChart.js';
    event IAddInReady();
    procedure NSbar(NSjobNo: code[20]; NS_Discription: Text[100]; NSBudgetedCost: Decimal; NSBudgetedCostText: Text; NSBudgetedPrice: Decimal; NSBudgetedPriceText: Text; NSInvoicePrice: Decimal; NSInvoicePriceText: Text; NSUsagecost: Decimal; NSUsagecostText: Text);
    procedure NSPie(NSjobNo: code[20]; NS_Discription: Text[100]; NSBudgetedCost: Decimal; NSBudgetedCostText: Text; NSBudgetedPrice: Decimal; NSBudgetedPriceText: Text; NSInvoicePrice: Decimal; NSInvoicePriceText: Text; NSUsagecost: Decimal; NSUsagecostText: Text);
    procedure NSDoughnut(NSjobNo: code[20]; NS_Discription: Text[100]; NSBudgetedCost: Decimal; NSBudgetedCostText: Text; NSBudgetedPrice: Decimal; NSBudgetedPriceText: Text; NSInvoicePrice: Decimal; NSInvoicePriceText: Text; NSUsagecost: Decimal; NSUsagecostText: Text);
}
controladdin NSJobCostCatogary
{
    Scripts = 'NSProjectProChart.js', 'NSProjectProJobScript.js';
    StartupScript = 'addin/src/NSProjectProStartup.js';
    //StyleSheets = 'Progress1.css';
    RequestedHeight = 300;
    RequestedWidth = 400;
    RefreshScript = 'addin/src/NSProjectProChart.js';
    event IAddInReady();
    procedure NSCOSTCATEGORYBar(NSjobNo: code[20]; NS_Discription: Text[100]; NSBudgetedCost: Decimal; NSBudgetedCostText: Text; NSBudgetedPrice: Decimal; NSBudgetedPriceText: Text; NSUsagecost: Decimal; NSUsagecostText: Text; NSUsageprice: Decimal; NSUsagepriceText: Text);
    procedure NSCOSTCATEGORYPIE(NSjobNo: code[20]; NS_Discription: Text[100]; NSBudgetedCost: Decimal; NSBudgetedCostText: Text; NSBudgetedPrice: Decimal; NSBudgetedPriceText: Text; NSUsagecost: Decimal; NSUsagecostText: Text; NSUsageprice: Decimal; NSUsagepriceText: Text);
    procedure NSCOSTCATEGORYPIEoughnut(NSjobNo: code[20]; NS_Discription: Text[100]; NSBudgetedCost: Decimal; NSBudgetedCostText: Text; NSBudgetedPrice: Decimal; NSBudgetedPriceText: Text; NSUsagecost: Decimal; NSUsagecostText: Text; NSUsageprice: Decimal; NSUsagepriceText: Text);
}
controladdin NSGenericTpye4
{
    Scripts = 'NSProjectProChart.js', 'NSProjectProJobScript.js';
    StartupScript = 'addin/src/NSProjectProStartup.js';
    //StyleSheets = 'Progress1.css';
    RequestedHeight = 300;
    RequestedWidth = 400;
    RefreshScript = 'addin/src/NSProjectProChart.js';
    event IAddInReady();
    procedure NSBudgetedHourbar(NSjobNo: code[20]; NS_Discription: Text[100]; NSBudgetedCost: Decimal; NSBudgetedCostText: Text; NSUsagecost: Decimal; NSUsagecostText: Text);
    procedure NSBudgetedHourPie(NSjobNo: code[20]; NS_Discription: Text[100]; NSBudgetedCost: Decimal; NSBudgetedCostText: Text; NSUsagecost: Decimal; NSUsagecostText: Text);
    procedure NSBudgetedHourDoughnut(NSjobNo: code[20]; NS_Discription: Text[100]; NSBudgetedCost: Decimal; NSBudgetedCostText: Text; NSUsagecost: Decimal; NSUsagecostText: Text);
}
controladdin NSCalculateRevenueRecognition
{
    Scripts = 'NSProjectProChart.js', 'NSProjectProJobScript.js';
    StartupScript = 'addin/src/NSProjectProStartup.js';
    //StyleSheets = 'Style2.css';
    RequestedHeight = 300;
    RequestedWidth = 400;
    RefreshScript = 'addin/src/NSProjectProChart.js';
    event IAddInReady();
    procedure NSRevrecBar(NSjobNo: code[20]; NS_Discription: Text[100]; NSCurrentEst: Decimal; NSCurrentEstText: Text; NSActualCosttoDate: Decimal; NSActualCosttoDateText: Text; NSCurrentContract: Decimal; NSCurrentContractText: Text; NSBillingtoDate: Decimal; NSBillingtoDateText: Text);
    procedure NSRevrecBar2(NSjobNo: code[20]; NS_Discription: Text[100]; NSCurrentEst: Decimal; NSCurrentEstText: Text; NSActualCosttoDate: Decimal; NSActualCosttoDateText: Text; NSCurrentContract: Decimal; NSCurrentContractText: Text; NSBillingtoDate: Decimal; NSBillingtoDateText: Text; NSGrossProfit: Decimal; NSGrossProfitText: Text);
    procedure NSRevrecPie(NSjobNo: code[20]; NS_Discription: Text[100]; NSCurrentEst: Decimal; NSCurrentEstText: Text; NSActualCosttoDate: Decimal; NSActualCosttoDateText: Text; NSCurrentContract: Decimal; NSCurrentContractText: Text; NSBillingtoDate: Decimal; NSBillingtoDateText: Text);
    procedure NSRevrecDoughnut(NSjobNo: code[20]; NS_Discription: Text[100]; NSCurrentEst: Decimal; NSCurrentEstText: Text; NSActualCosttoDate: Decimal; NSActualCosttoDateText: Text; NSCurrentContract: Decimal; NSCurrentContractText: Text; NSBillingtoDate: Decimal; NSBillingtoDateText: Text);
}
page 14021371 NSProjectProJobChart
{
    Caption = 'ProjectPro Analytics Chart';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    layout
    {
        area(Content)
        {
            grid(NS)
            {
                group(Chart1)
                {
                    Caption = ' ';
                    field(NSChartType; NSChartType)
                    {
                        Caption = 'Chart Type';
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Chart Type field.';
                        trigger OnValidate()
                        var
                            myInt: Integer;

                        begin
                            if NS_GeneralLedgerSetup.get() then begin
                                NSBudgetedCostText := 'Budgeted Cost' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
                                NSBudgetedPriceText := 'Budgeted Price' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
                                NSInvoicePriceText := 'Invoiced Price' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
                                NSUsagecostText := 'Usage (Cost)' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
                            end;
                            if NSChartType = NSChartType::Column then begin
                                NSJob.SetRange("No.", NS_JobNo);
                                if NSJob.FindSet(false, false) then;
                                if NSJob."NS_Budgeted Cost (LCY)" <> 0 then;
                                NSJob.CalcFields(NSJob."NS_Budgeted Cost (LCY)", NSJob."NS_Budgeted Price (LCY)", NSJob."NS_Invoiced Price (LCY)", NSJob."NS_Usage (Cost) (LCY)", NSJob."NS_Usage (Price) (LCY)");
                                NSBudgetedCost := NSJob."NS_Budgeted Cost (LCY)";
                                NSBudgetedPrice := NSJob."NS_Budgeted Price (LCY)";
                                NSInvoicePrice := NSJob."NS_Invoiced Price (LCY)";
                                NSUsagecost := NSJob."NS_Usage (Cost) (LCY)";
                                CurrPage.NSbar.NSbar(NS_JobNo, NS_Discription, NSBudgetedCost, NSBudgetedCostText, NSBudgetedPrice, NSBudgetedPriceText, NSInvoicePrice, NSInvoicePriceText, NSUsagecost, NSUsagecostText);
                            end;
                            if NSChartType = NSChartType::Pie then begin
                                NSJob.SetRange("No.", NS_JobNo);
                                if NSJob.FindSet(false, false) then;
                                if NSJob."NS_Budgeted Cost (LCY)" <> 0 then;
                                NSJob.CalcFields(NSJob."NS_Budgeted Cost (LCY)", NSJob."NS_Budgeted Price (LCY)", NSJob."NS_Invoiced Price (LCY)", NSJob."NS_Usage (Cost) (LCY)", NSJob."NS_Usage (Price) (LCY)");
                                NSBudgetedCost := NSJob."NS_Budgeted Cost (LCY)";
                                NSBudgetedPrice := NSJob."NS_Budgeted Price (LCY)";
                                NSInvoicePrice := NSJob."NS_Invoiced Price (LCY)";
                                NSUsagecost := NSJob."NS_Usage (Cost) (LCY)";
                                NSUsageprice := NSJob."NS_Usage (Price) (LCY)";
                                CurrPage.NSbar.NSPie(NS_JobNo, NS_Discription, NSBudgetedCost, NSBudgetedCostText, NSBudgetedPrice, NSBudgetedPriceText, NSInvoicePrice, NSInvoicePriceText, NSUsagecost, NSUsagecostText);
                            end;
                            if NSChartType = NSChartType::Doughnut then begin
                                NSJob.SetRange("No.", NS_JobNo);
                                if NSJob.FindSet(false, false) then;
                                if NSJob."NS_Budgeted Cost (LCY)" <> 0 then;
                                NSJob.CalcFields(NSJob."NS_Budgeted Cost (LCY)", NSJob."NS_Budgeted Price (LCY)", NSJob."NS_Invoiced Price (LCY)", NSJob."NS_Usage (Cost) (LCY)", NSJob."NS_Usage (Price) (LCY)");
                                NSBudgetedCost := NSJob."NS_Budgeted Cost (LCY)";
                                NSBudgetedPrice := NSJob."NS_Budgeted Price (LCY)";
                                NSInvoicePrice := NSJob."NS_Invoiced Price (LCY)";
                                NSUsagecost := NSJob."NS_Usage (Cost) (LCY)";
                                NSUsageprice := NSJob."NS_Usage (Price) (LCY)";
                                CurrPage.NSbar.NSdoughnut(NS_JobNo, NS_Discription, NSBudgetedCost, NSBudgetedCostText, NSBudgetedPrice, NSBudgetedPriceText, NSInvoicePrice, NSInvoicePriceText, NSUsagecost, NSUsagecostText);
                            end;

                        end;
                    }
                    group(Test)
                    {
                        Caption = '';
                        usercontrol(NSbar; NSmyGeneric)
                        {
                            ApplicationArea = all;
                            trigger IAddInReady()
                            var
                            begin

                            end;
                        }
                    }

                }
                group(Chart2)
                {
                    Caption = '';
                    grid(Type2)
                    {
                        grid(ccc)
                        {
                            field(NSjobCostCat2; NSjobCostCat2)
                            {
                                Caption = 'Job Cost Category';
                                ApplicationArea = all;
                                TableRelation = NSNumberFilter."No." where(Type = filter("NS_Job Cost Category"));
                                trigger OnValidate()
                                var
                                    myInt: Integer;
                                begin
                                    if NS_GeneralLedgerSetup.get() then begin
                                        NSBudgetedCostText := 'Budgeted Cost' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
                                        NSBudgetedPriceText := 'Budgeted Price' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
                                        NSUsagepriceText := 'Invoiced Price' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
                                        NSUsagecostText := 'Usage (Cost)' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
                                    end;
                                    NSUsagecost1 := 0;
                                    NSUsageprice1 := 0;
                                    NSBudgetedCost1 := 0;
                                    NSBudgetedPrice1 := 0;
                                    if NSCostCatgoryChart = NSCostCatgoryChart::Column then begin
                                        NSJobPlanningLine.Reset();
                                        NSJobPlanningLine.SetRange("Job No.", NS_JobNo);
                                        NSJobPlanningLine.SetRange("NS_Cost Category", NSjobCostCat2);
                                        NSJobLedgerEnt.Reset();
                                        NSJobLedgerEnt.SetRange("Job No.", NS_JobNo);
                                        NSJobLedgerEnt.SetRange("NS_Job Cost Category", NSjobCostCat2);
                                        NSJobLedgerEnt.SetRange("Entry Type", NSJobLedgerEnt."Entry Type"::Usage);
                                        if NSJobLedgerEnt.FindSet() then;
                                        repeat
                                            NSUsagecost1 += NSJobLedgerEnt."Line Amount (LCY)";
                                            NSUsageprice1 += NSJobLedgerEnt."Total Price (LCY)";
                                        until NSJobLedgerEnt.Next() = 0;
                                        if NSJobPlanningLine.FindSet(false, false) then;
                                        repeat
                                            NSBudgetedCost1 += NSJobPlanningLine."Total Cost (LCY)";
                                            NSBudgetedPrice1 += NSJobPlanningLine."Total Price (LCY)";
                                        until NSJobPlanningLine.Next() = 0;
                                        CurrPage.NSCOST.NSCOSTCATEGORYBar(NS_JobNo, NS_Discription, NSBudgetedCost1, NSBudgetedCostText, NSBudgetedPrice1, NSBudgetedPriceText, NSUsagecost1, NSUsagecostText, NSUsageprice1, NSUsagepriceText);
                                    end;
                                    if NSCostCatgoryChart = NSCostCatgoryChart::Pie then begin
                                        NSJobPlanningLine.Reset();
                                        NSJobPlanningLine.SetRange("Job No.", NS_JobNo);
                                        NSJobPlanningLine.SetRange("NS_Cost Category", NSjobCostCat2);
                                        NSJobLedgerEnt.Reset();
                                        NSJobLedgerEnt.SetRange("Job No.", NS_JobNo);
                                        NSJobLedgerEnt.SetRange("NS_Job Cost Category", NSjobCostCat2);
                                        NSJobLedgerEnt.SetRange("Entry Type", NSJobLedgerEnt."Entry Type"::Usage);
                                        if NSJobLedgerEnt.FindSet() then;
                                        repeat
                                            NSUsagecost1 += NSJobLedgerEnt."Total Cost (LCY)";
                                            NSUsageprice1 += NSJobLedgerEnt."Total Price (LCY)";
                                        until NSJobLedgerEnt.Next() = 0;
                                        if NSJobPlanningLine.FindSet(false, false) then;
                                        repeat
                                            NSBudgetedCost1 += NSJobPlanningLine."Total Cost (LCY)";
                                            NSBudgetedPrice1 += NSJobPlanningLine."Total Price (LCY)";
                                        until NSJobPlanningLine.Next() = 0;
                                        CurrPage.NSCOST.NSCOSTCATEGORYPIE(NS_JobNo, NS_Discription, NSBudgetedCost1, NSBudgetedCostText, NSBudgetedPrice1, NSBudgetedPriceText, NSUsagecost1, NSUsagecostText, NSUsageprice1, NSUsagepriceText);
                                    end;
                                    if NSCostCatgoryChart = NSCostCatgoryChart::Doughnut then begin
                                        if NSJob.FindSet(false, false) then;
                                        NSJobPlanningLine.Reset();
                                        NSJobPlanningLine.SetRange("Job No.", NS_JobNo);
                                        NSJobPlanningLine.SetRange("NS_Cost Category", NSjobCostCat2);
                                        NSJobLedgerEnt.Reset();
                                        NSJobLedgerEnt.SetRange("Job No.", NS_JobNo);
                                        NSJobLedgerEnt.SetRange("NS_Job Cost Category", NSjobCostCat2);
                                        // NSJobLedgerEnt.SetRange("Entry Type", NSJobLedgerEnt."Entry Type"::Usage);
                                        if NSJobLedgerEnt.FindSet() then;
                                        repeat
                                            NSUsagecost1 += NSJobLedgerEnt."Total Cost (LCY)";
                                            NSUsageprice1 += NSJobLedgerEnt."Total Price (LCY)";
                                        until NSJobLedgerEnt.Next() = 0;
                                        if NSJobPlanningLine.FindSet(false, false) then;
                                        repeat
                                            NSBudgetedCost1 += NSJobPlanningLine."Total Cost (LCY)";
                                            NSBudgetedPrice1 += NSJobPlanningLine."Total Price (LCY)";
                                        until NSJobPlanningLine.Next() = 0;
                                        CurrPage.NSCOST.NSCOSTCATEGORYPIEoughnut(NS_JobNo, NS_Discription, NSBudgetedCost1, NSBudgetedCostText, NSBudgetedPrice1, NSBudgetedPriceText, NSUsagecost1, NSUsagecostText, NSUsageprice1, NSUsagepriceText);
                                    end;
                                end;
                            }
                            field(NSCostCatgoryChart; NSCostCatgoryChart)
                            {
                                Caption = 'Chart Type';
                                ApplicationArea = all;
                                ToolTip = 'Specifies the value of the Chart Type field.';
                                trigger OnValidate()
                                var
                                    myInt: Integer;
                                begin
                                    if NS_GeneralLedgerSetup.get() then begin
                                        NSBudgetedCostText := 'Budgeted Cost' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
                                        NSBudgetedPriceText := 'Budgeted Price' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
                                        NSUsagepriceText := 'Invoiced Price' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
                                        NSUsagecostText := 'Usage (Cost)' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
                                    end;
                                    NSUsagecost1 := 0;
                                    NSUsageprice1 := 0;
                                    NSBudgetedCost1 := 0;
                                    NSBudgetedPrice1 := 0;
                                    if NSCostCatgoryChart = NSCostCatgoryChart::Column then begin
                                        NSJobPlanningLine.Reset();
                                        NSJobPlanningLine.SetRange("Job No.", NS_JobNo);
                                        NSJobPlanningLine.SetRange("NS_Cost Category", NSjobCostCat2);
                                        NSJobLedgerEnt.Reset();
                                        NSJobLedgerEnt.SetRange("Job No.", NS_JobNo);
                                        //  NSJobLedgerEnt.SetRange("NS_Job Cost Category", NSjobCostCat2);
                                        NSJobLedgerEnt.SetRange("Entry Type", NSJobLedgerEnt."Entry Type"::Usage);
                                        if NSJobLedgerEnt.FindSet() then;
                                        repeat
                                            NSUsagecost1 += NSJobLedgerEnt."Line Amount (LCY)";
                                            NSUsageprice1 += NSJobLedgerEnt."Total Price (LCY)";
                                        until NSJobLedgerEnt.Next() = 0;
                                        if NSJobPlanningLine.FindSet(false, false) then;
                                        repeat
                                            NSBudgetedCost1 += NSJobPlanningLine."Total Cost (LCY)";
                                            NSBudgetedPrice1 += NSJobPlanningLine."Total Price (LCY)";
                                        until NSJobPlanningLine.Next() = 0;
                                        CurrPage.NSCOST.NSCOSTCATEGORYBar(NS_JobNo, NS_Discription, NSBudgetedCost1, NSBudgetedCostText, NSBudgetedPrice1, NSBudgetedPriceText, NSUsagecost1, NSUsagecostText, NSUsageprice1, NSUsagepriceText);
                                    end;
                                    if NSCostCatgoryChart = NSCostCatgoryChart::Pie then begin
                                        NSJobPlanningLine.Reset();
                                        NSJobPlanningLine.SetRange("Job No.", NS_JobNo);
                                        NSJobPlanningLine.SetRange("NS_Cost Category", NSjobCostCat2);
                                        NSJobLedgerEnt.Reset();
                                        NSJobLedgerEnt.SetRange("Job No.", NS_JobNo);
                                        //NSJobLedgerEnt.SetRange("NS_Job Cost Category", NSjobCostCat2);
                                        NSJobLedgerEnt.SetRange("Entry Type", NSJobLedgerEnt."Entry Type"::Usage);
                                        if NSJobLedgerEnt.FindSet() then;
                                        repeat
                                            NSUsagecost1 += NSJobLedgerEnt."Line Amount (LCY)";
                                            NSUsageprice1 += NSJobLedgerEnt."Total Price (LCY)";
                                        until NSJobLedgerEnt.Next() = 0;
                                        if NSJobPlanningLine.FindSet(false, false) then;
                                        repeat
                                            NSBudgetedCost1 += NSJobPlanningLine."Total Cost (LCY)";
                                            NSBudgetedPrice1 += NSJobPlanningLine."Total Price (LCY)";
                                        until NSJobPlanningLine.Next() = 0;
                                        CurrPage.NSCOST.NSCOSTCATEGORYPIE(NS_JobNo, NS_Discription, NSBudgetedCost1, NSBudgetedCostText, NSBudgetedPrice1, NSBudgetedPriceText, NSUsagecost1, NSUsagecostText, NSUsageprice1, NSUsagepriceText);
                                    end;
                                    if NSCostCatgoryChart = NSCostCatgoryChart::Doughnut then begin
                                        NSJobPlanningLine.Reset();
                                        NSJobPlanningLine.SetRange("Job No.", NS_JobNo);
                                        NSJobPlanningLine.SetRange("NS_Cost Category", NSjobCostCat2);
                                        NSJobLedgerEnt.Reset();
                                        NSJobLedgerEnt.SetRange("Job No.", NS_JobNo);
                                        //  NSJobLedgerEnt.SetRange("NS_Job Cost Category", NSjobCostCat2);
                                        NSJobLedgerEnt.SetRange("Entry Type", NSJobLedgerEnt."Entry Type"::Usage);
                                        if NSJobLedgerEnt.FindSet() then;
                                        repeat
                                            NSUsagecost1 += NSJobLedgerEnt."Line Amount (LCY)";
                                            NSUsageprice1 += NSJobLedgerEnt."Total Price (LCY)";
                                        until NSJobLedgerEnt.Next() = 0;
                                        if NSJobPlanningLine.FindSet(false, false) then;
                                        repeat
                                            NSBudgetedCost1 += NSJobPlanningLine."Total Cost (LCY)";
                                            NSBudgetedPrice1 += NSJobPlanningLine."Total Price (LCY)";
                                        until NSJobPlanningLine.Next() = 0;
                                        CurrPage.NSCOST.NSCOSTCATEGORYPIEoughnut(NS_JobNo, NS_Discription, NSBudgetedCost1, NSBudgetedCostText, NSBudgetedPrice1, NSBudgetedPriceText, NSUsagecost1, NSUsagecostText, NSUsageprice1, NSUsagepriceText);
                                    end;
                                end;
                            }
                        }

                    }
                    usercontrol(NSCOST; NSJobCostCatogary)
                    {
                        ApplicationArea = all;
                        trigger IAddInReady()
                        var
                        begin
                        end;
                    }
                }
            }


            grid(Chart3)
            {
                group(ssss)
                {
                    Caption = '';



                    usercontrol(NSRevrec; NSCalculateRevenueRecognition)
                    {
                        ApplicationArea = all;
                        trigger IAddInReady()
                        var
                        begin

                        end;
                    }
                }
                group(Type4)
                {
                    Caption = '';
                    field(NSChartType3; NSChartType3)
                    {
                        Caption = 'Chart Type';
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Chart Type field.';
                        trigger OnValidate()
                        var
                            myInt: Page "Generic Chart Setup";
                        begin
                            NSBudgetedHourText := 'Bud-Hour';
                            NSUsageHourText := 'Act-Hour';
                            NSBudgetedHour := 0;
                            NSUsageHour := 0;
                            if NSChartType3 = NSChartType3::Column then begin
                                NSJobPlanningLine.SetRange("Job No.", NS_JobNo);
                                NSJobPlanningLine.SetFilter("Line Type", '%1|%2', NSJobPlanningLine."Line Type"::Budget, NSJobPlanningLine."Line Type"::"Both Budget and Billable");
                                NSJobPlanningLine.SetRange("Unit of Measure Code", 'HR');
                                NSJobPlanningLine.SetRange(Type, NSJobPlanningLine.Type::Resource);
                                NSJobLedgerEnt.SetRange("Job No.", NS_JobNo);
                                NSJobLedgerEnt.SetRange(Type, NSJobLedgerEnt.Type::Resource);
                                NSJobLedgerEnt.SetRange("Entry Type", NSJobLedgerEnt."Entry Type"::Usage);
                                NSJobLedgerEnt.SetRange("Unit of Measure Code", 'HR');
                                if NSJobLedgerEnt.Findfirst() then begin
                                    repeat
                                        NSUsageHour += NSJobLedgerEnt.Quantity;
                                        NSUsageCost += NSJobLedgerEnt."Total Cost (LCY)";
                                    until NSJobLedgerEnt.Next() = 0;
                                end;
                                if NSJobPlanningLine.FindFirst() then begin
                                    repeat
                                        NSBudgetedHour += NSJobPlanningLine.Quantity;
                                        NSBudCostHr += NSJobPlanningLine."Total Cost (LCY)";
                                    until NSJobPlanningLine.Next() = 0;
                                end;

                                CurrPage.NSbar4.NSBudgetedHourbar(NS_JobNo, NS_Discription, NSBudgetedHour, NSBudgetedHourText, NSUsageHour, NSUsageHourText);
                            end;
                            if NSChartType3 = NSChartType3::Pie then begin
                                NSJobPlanningLine.SetRange("Job No.", NS_JobNo);
                                NSJobPlanningLine.SetFilter("Line Type", '%1|%2', NSJobPlanningLine."Line Type"::Budget, NSJobPlanningLine."Line Type"::"Both Budget and Billable");
                                NSJobPlanningLine.SetRange(Type, NSJobPlanningLine.Type::Resource);
                                NSJobPlanningLine.SetRange("Unit of Measure Code", 'HR');
                                NSJobLedgerEnt.SetRange("Job No.", NS_JobNo);
                                NSJobLedgerEnt.SetRange(Type, NSJobLedgerEnt.Type::Resource);
                                NSJobLedgerEnt.SetRange("Entry Type", NSJobLedgerEnt."Entry Type"::Usage);
                                NSJobLedgerEnt.SetRange("Unit of Measure Code", 'HR');
                                if NSJobLedgerEnt.FindSet() then;
                                repeat
                                    NSUsageHour += NSJobLedgerEnt.Quantity;
                                    NSUsageCost += NSJobLedgerEnt."Total Cost (LCY)";
                                until NSJobLedgerEnt.Next() = 0;
                                if NSJobPlanningLine.FindSet(false, false) then;
                                repeat
                                    NSBudgetedHour += NSJobPlanningLine.Quantity;
                                    NSBudCostHr += NSJobPlanningLine."Total Cost (LCY)";
                                until NSJobPlanningLine.Next() = 0;
                                CurrPage.NSbar4.NSBudgetedHourPie(NS_JobNo, NS_Discription, NSBudgetedHour, NSBudgetedHourText, NSUsageHour, NSUsageHourText);

                            end;
                            if NSChartType3 = NSChartType3::Doughnut then begin
                                NSJobPlanningLine.SetRange("Job No.", NS_JobNo);
                                NSJobPlanningLine.SetFilter("Line Type", '%1|%2', NSJobPlanningLine."Line Type"::Budget, NSJobPlanningLine."Line Type"::"Both Budget and Billable");
                                NSJobPlanningLine.SetRange(Type, NSJobPlanningLine.Type::Resource);
                                NSJobPlanningLine.SetRange("Unit of Measure Code", 'HR');
                                NSJobLedgerEnt.SetRange("Job No.", NS_JobNo);
                                NSJobLedgerEnt.SetRange(Type, NSJobLedgerEnt.Type::Resource);
                                NSJobLedgerEnt.SetRange("Entry Type", NSJobLedgerEnt."Entry Type"::Usage);
                                NSJobLedgerEnt.SetRange("Unit of Measure Code", 'HR');
                                if NSJobLedgerEnt.FindSet() then;
                                repeat
                                    NSUsageHour += NSJobLedgerEnt.Quantity;
                                    NSUsageCost += NSJobLedgerEnt."Total Cost (LCY)";
                                until NSJobLedgerEnt.Next() = 0;
                                if NSJobPlanningLine.FindSet(false, false) then;
                                repeat
                                    NSBudgetedHour += NSJobPlanningLine.Quantity;
                                    NSBudCostHr += NSJobPlanningLine."Total Cost (LCY)";
                                until NSJobPlanningLine.Next() = 0;
                                CurrPage.NSbar4.NSBudgetedHourDoughnut(NS_JobNo, NS_Discription, NSBudgetedHour, NSBudgetedHourText, NSUsageHour, NSUsageHourText);

                            end;

                        end;
                    }
                    usercontrol(NSbar4; NSGenericTpye4)
                    {
                        ApplicationArea = all;
                        trigger IAddInReady()
                        var
                        begin

                        end;
                    }
                }
            }
        }

    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        //This Code is used to Budget Vs Actual Start
        if NS_GeneralLedgerSetup.get() then begin
            NSBudgetedCostText := 'Budgeted Cost' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
            NSBudgetedPriceText := 'Budgeted Price' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
            NSInvoicePriceText := 'Invoiced Price' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
            NSUsagecostText := 'Usage (Cost)' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
        end;
        if NSChartType = NSChartType::" " then begin
            NSJob.SetRange("No.", NS_JobNo);
            if NSJob.FindSet(false, false) then;
            if NSJob."NS_Budgeted Cost (LCY)" <> 0 then;
            NSJob.CalcFields(NSJob."NS_Budgeted Cost (LCY)", NSJob."NS_Budgeted Price (LCY)", NSJob."NS_Invoiced Price (LCY)", NSJob."NS_Usage (Cost) (LCY)", NSJob."NS_Usage (Price) (LCY)");
            NSBudgetedCost := NSJob."NS_Budgeted Cost (LCY)";
            NSBudgetedPrice := NSJob."NS_Budgeted Price (LCY)";
            NSInvoicePrice := NSJob."NS_Invoiced Price (LCY)";
            NSUsagecost := NSJob."NS_Usage (Cost) (LCY)";
            NSUsageprice := NSJob."NS_Usage (Price) (LCY)";
            CurrPage.NSbar.NSbar(NS_JobNo, NS_Discription, NSBudgetedCost, NSBudgetedCostText, NSBudgetedPrice, NSBudgetedPriceText, NSInvoicePrice, NSInvoicePriceText, NSUsagecost, NSUsagecostText);
        end;
        //This Code is used to Budget Vs Actual End

        //This Code is used to Cost Categories Start
        if NS_GeneralLedgerSetup.get() then begin
            NSBudgetedCostText := 'Budgeted Cost' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
            NSBudgetedPriceText := 'Budgeted Price' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
            NSUsagepriceText := 'Invoiced Price' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
            NSUsagecostText := 'Usage (Cost)' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
        end;
        if NSChartType = NSChartType::" " then begin
            NSJobPlanningLine.SetRange("Job No.", NS_JobNo);
            NSJobPlanningLine.SetRange("NS_Cost Category", 'LAB');
            NSJobLedgerEnt.SetRange("Job No.", NS_JobNo);
            NSJobLedgerEnt.SetRange("NS_Job Cost Category", 'LAB');
            NSJobLedgerEnt.SetRange("Entry Type", NSJobLedgerEnt."Entry Type"::Usage);
            if NSJobLedgerEnt.FindSet() then;
            repeat
                NSUsagecost1 += NSJobLedgerEnt."Total Cost (LCY)";
                NSUsageprice1 += NSJobLedgerEnt."Total Price (LCY)";
            until NSJobLedgerEnt.Next() = 0;
            if NSJobPlanningLine.FindSet(false, false) then;
            repeat
                NSBudgetedCost1 += NSJobPlanningLine."Total Cost (LCY)";
                NSBudgetedPrice1 += NSJobPlanningLine."Total Price (LCY)";
            until NSJobPlanningLine.Next() = 0;
            CurrPage.NSCOST.NSCOSTCATEGORYBar(NS_JobNo, NS_Discription, NSBudgetedCost1, NSBudgetedCostText, NSBudgetedPrice1, NSBudgetedPriceText, NSUsagecost1, NSUsagecostText, NSUsageprice1, NSUsagepriceText);
        end;
        //This Code is used to Cost Categories End

        //This Code used to ForeCasted Vs Actual Cost and Forcasted Vs Revenue Recoginize Start
        if NS_GeneralLedgerSetup.get() then begin
            NSCurrentEstText := 'Forcasted Cost' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
            NSActualCosttoDateText := 'Usage Cost' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
            NSCurrentContractText := 'Budgeted Price' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
            NSBillingtoDateText := 'Invoice Price' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
            NSInvoiceAmt := 'Invoice Amount' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
        end;
        NSCurrentEst := 0;
        NSActualCosttoDate := 0;
        NSCurrentContract := 0;
        NSBillingtoDate := 0;
        if NSCostCatgoryChart = NSCostCatgoryChart::" " then begin
            NSJob.Reset();
            NSJob.SetRange("No.", NS_JobNo);
            NS_RevRecSummaryTab.SetRange("NS_Job No.", NS_JobNo);
            if NS_RevRecSummaryTab.FindLast() then;
            if NSJob.FindSet(false, false) then;
            if NS_RevRecSummaryTab."NS_Current(TCE) Est. Cost at Completion" <> 0 then begin
                repeat
                    NSCurrentEst := NS_RevRecSummaryTab."NS_Current(TCE) Est. Cost at Completion";
                    NSActualCosttoDate := NS_RevRecSummaryTab."NS_Actual Costs To Date";
                    NSCurrentContract := NS_RevRecSummaryTab."NS_Current Contract";
                    NSBillingtoDate := NS_RevRecSummaryTab."NS_Billings to Date";
                until NSJobLedgerEnt.Next() = 0;
                CurrPage.NSRevrec.NSRevrecBar(NS_JobNo, NS_Discription, NSCurrentEst, NSCurrentEstText, NSActualCosttoDate, NSActualCosttoDateText, NSCurrentContract, NSCurrentContractText, NSBillingtoDate, NSBillingtoDateText);
            end
            else begin
                if NS_GeneralLedgerSetup.get() then begin
                    NSForCastedText := 'Forcasted Cost' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
                    NSActualCostText := 'Usage Cost' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
                    NSBudgetedPrText := 'Budgeted Price' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
                    NSRecognizedRevenueText := 'Recognized Revenue' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
                    NSGrossProfitText := 'Gross Profit' + ' ' + NS_GeneralLedgerSetup."Local Currency Symbol";
                end;
                NSBudgetedCost := 0;
                NSBudgetedPrice := 0;
                NSUsagecost := 0;
                NSRecognizedRevenue := 0;
                NSGrossProfit := 0;
                if NSChartType = NSChartType::" " then begin
                    NSJob.SetRange("No.", NS_JobNo);
                    if NSJob.FindSet(false, false) then;
                    if NSJob."NS_Budgeted Cost (LCY)" <> 0 then;
                    NSJob.CalcFields(NSJob."NS_Budgeted Cost (LCY)", NSJob."NS_Budgeted Price (LCY)", NSJob."NS_Invoiced Price (LCY)", NSJob."NS_Usage (Cost) (LCY)", NSJob."NS_Usage (Price) (LCY)");
                    NSBudgetedCost := NSJob."NS_Budgeted Cost (LCY)";
                    NSBudgetedPrice := NSJob."NS_Budgeted Price (LCY)";
                    NSUsagecost := NSJob."NS_Usage (Cost) (LCY)";
                    // NSInvoicePrice := NSJob."NS_Invoiced Price (LCY)";
                    NSRecognizedRevenue := ((NSUsagecost / NSBudgetedCost) * NSBudgetedPrice);
                    NSGrossProfit := NSRecognizedRevenue - NSUsagecost;
                end;
                CurrPage.NSRevrec.NSRevrecBar2(NS_JobNo, NS_Discription, NSBudgetedCost, NSForCastedText, NSBudgetedPrice, NSBudgetedPrText, NSUsagecost, NSActualCostText, NSRecognizedRevenue, NSRecognizedRevenueText, NSGrossProfit, NSGrossProfitText);
            end;
        end;
        //This Code used to ForeCasted Vs Actual Cost and Forcasted Vs Revenue Recoginize End

        //This Code is used to Job Hours Analysis (Lab) Start
        NSBudgetedHourText := 'Budgeted Hour';
        NSUsageHourText := 'Usage Hour';
        NSBudgetedHour := 0;
        NSUsageHour := 0;
        if NSChartType3 = NSChartType3::" " then begin
            NSJobPlanningLine.SetRange("Job No.", NS_JobNo);
            NSJobPlanningLine.SetFilter("Line Type", '%1|%2', NSJobPlanningLine."Line Type"::Budget, NSJobPlanningLine."Line Type"::"Both Budget and Billable");
            NSJobPlanningLine.SetRange(Type, NSJobPlanningLine.Type::Resource);
            NSJobPlanningLine.SetRange("Unit of Measure Code", 'HR');
            NSJobLedgerEnt.SetRange("Job No.", NS_JobNo);
            NSJobLedgerEnt.SetRange(Type, NSJobLedgerEnt.Type::Resource);
            NSJobLedgerEnt.SetRange("Entry Type", NSJobLedgerEnt."Entry Type"::Usage);
            NSJobLedgerEnt.SetRange("Unit of Measure Code", 'HR');
            if NSJobLedgerEnt.FindFirst() then begin
                repeat
                    NSUsageHour += NSJobLedgerEnt.Quantity;
                until NSJobLedgerEnt.Next() = 0;
            end;
            if NSJobPlanningLine.FindFirst() then begin
                repeat
                    NSBudgetedHour += NSJobPlanningLine.Quantity;
                    
                until NSJobPlanningLine.Next() = 0;
            end;
            CurrPage.NSbar4.NSBudgetedHourDoughnut(NS_JobNo, NS_Discription, NSBudgetedHour, NSBudgetedHourText, NSUsageHour, NSUsageHourText);
        end;
        //This Code is used to Job Hours Analysis (Lab) End
    end;


    var
        NSJob: Record Job;
        NSJobPlanningLine: Record "Job Planning Line";
        NSJobLedgerEnt: Record "Job Ledger Entry";
        NSjobCostCat1: Record "NS_Job Cost Category" temporary;
        NS_GeneralLedgerSetup: Record "General Ledger Setup";
        NS_JobNo: Code[20];
        NSBudgetedCost: Decimal;
        NSBudgetedCost1: Decimal;
        NSBudgetedPrice: Decimal;
        NSBudgetedPrice1: Decimal;
        NSInvoicePrice: Decimal;
        NSUsagecost: Decimal;
        NSRecognizedRevenue: Decimal;
        NSUsagecost1: Decimal;
        NSUsageprice: Decimal;
        NSUsageprice1: Decimal;
        NSUsagecost2: Decimal;
        NSGrossProfit: Decimal;
        NSUsageprice2: Decimal;
        NSBudgetedCost2: Decimal;
        NSBudgetedPrice2: Decimal;
        NSCurrentEst: Decimal;
        NSCurrentEstText: Text;
        NSActualCosttoDate: Decimal;
        NSActualCosttoDateText: Text;
        NSCurrentContract: Decimal;
        NSCurrentContractText: Text;
        NSBillingtoDate: Decimal;
        NSBillingtoDateText: Text;
        NSChartType: Enum "NS Chart Type";
        NSCostCatgoryChart: Enum "NS Chart Type";
        NSSegmentChartType: Enum "NS Chart Type";
        NSChartType3: Enum "NS Chart Type";
        NSForCastedText: Text;
        NSBudgetedCostText: Text;
        NSRecognizedRevenueText: Text;

        NSBudgetedPrText: Text;
        NSActualCostText: Text;
        NSBudgetedPriceText: Text;
        NSInvoicePriceText: Text;
        NSUsagecostText: Text;
        NSUsagepriceText: Text;
        NS_Discription: Text[100];
        NSjobCostCat2: Text[100];
        NSInvoiceAmt: Text[100];
        NSSegmentCod: Code[20];
        JobTask: Boolean;
        NSBudgetedHourText: Text[100];
        NSBudCostHrText: Text[100];
        NSUsageHourText: Text[100];
        NSUsageCostHrText: Text[100];
        NSGrossProfitText: Text;
        NSUsageHour: Decimal;
        NSUsageCostHr: Decimal;
        NSBudgetedHour: Decimal;
        NSBudCostHr: Decimal;
        NSBudgeted: Label 'Budgeted vs Invoice';
        NSNumberFilter: Record NSNumberFilter;
        NS_RevRecSummaryTab: Record NS_RevenueRecSummaryTab;
    //"NS_JobChartManagement": Codeunit "NS_Job Chart Management";
    procedure NSSetJobNo(NSJobNo: Code[20]; NSDiscription: Text[100])
    begin
        NS_JobNo := NSJobNo;
        NS_Discription := NSDiscription;
    end;
}

//PE-115.DK.1.0 5july2023 END