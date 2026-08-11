page 14021321 "NS_QuoteUnitAnalysis"
{
    //PE-221.NC.1.0 22May2024 | Create New Page
    Caption = 'Quote Unit Analysis';
    PageType = ListPart;
    SourceTable = "NS_Job Quote Header";

    layout
    {

        area(content)
        {
            // grid(Type4)
            // {
            //     group("")

            //     {

            // field("XXXX"; 'Quote ' + Format(Rec."NS_Total Units") + ' ' + Rec."NS_Unit of Measure")
            // {
            //     ApplicationArea = All;
            //     Editable = false;
            //     Caption = '';
            // }

            //     }
            // }
            fixed(Control1100773002)
            {
                grid(Type3)
                {
                    grid(" ")
                    {
                        field("XXXX"; 'Quote Units ' + Format(Rec."NS_Total Units") + ' ' + Rec."NS_Unit of Measure")
                        {
                            ApplicationArea = all;
                            Caption = '';
                            Style = Strong;
                            StyleExpr = true;

                        }
                    }
                }
            }
            fixed(Control1100773000)
            {

                group(PROJECTPRO2)
                {
                    Caption = 'Description';


                    field("'Labor'"; 'Labor')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';
                    }
                    field("'Material'"; 'Material')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';
                    }
                    field("'Equipment'"; 'Equipment')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';
                        ToolTip = 'Specifies the values of Locked Cost, Budgeted(Cost), Locked Revenue and Billable(Price) for Master Job'; //PE-75.RM.1.0 17May2023
                    }
                    field("'Subcontract'"; 'Subcontract')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';
                        ToolTip = 'Specifies the values of Locked Cost, Budgeted(Cost), Locked Revenue and Billable(Price) for Sub-Level Job'; //PE-75.RM.1.0 17May2023
                    }

                    field("'Manufacturing'"; 'Manufacturing')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';
                    }
                    field("'Overhead'"; 'Overhead')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';
                    }
                    field("'Miscellaneous'"; 'Miscellaneous')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';
                    }
                    field("Unrecognized"; 'Unrecognized')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';
                    }
                    field("Subtotal"; 'Subtotal')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';
                    }
                    field("Profit"; 'Profit')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';
                    }
                    field("Total"; 'Total')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';
                    }
                }
                group("Amount")
                {

                    Caption = '                             Amount';
                    field(LabarAmt; Round(StdEstAmount[1], 0.01))
                    {
                        ApplicationArea = All;
                        Caption = 'Labor';

                        trigger OnDrillDown();
                        begin
                            NSCostCategory := '';
                            NS_JobCostCategory.RESET();
                            NS_JobCostCategory.SetCurrentKey(NS_Type);
                            NS_JobCostCategory.SetRange(NS_Type, NS_JobCostCategory.NS_Type::Labor);
                            IF NS_JobCostCategory.FINDSET() THEN
                                REPEAT
                                    NSCostCategory := NSCostCategory + '|' + NS_JobCostCategory.NS_Code;
                                until NS_JobCostCategory.Next() = 0;
                            NSCostCategory := CopyStr(NSCostCategory, 2, 250);
                            JobPlanningLine.Reset();
                            //PE-300.Dk.1.0  29May2024 Start
                            // if Rec.NS_Status = Rec.NS_Status::Open then
                            if Rec."NS_Quote Status" = Rec."NS_Quote Status"::Open then
                                //PE-300.Dk.1.0  29May2024 End
                                JobPlanningLine.SetRange("Job No.", Rec."NS_Quote No.")
                            else
                                JobPlanningLine.SetRange("NS_Job Quote No.", Rec."NS_Quote No.");
                            if NSCostCategory = '' then
                                JobPlanningLine.SetFilter("NS_Cost Category", '<>%1&%2', '', NSCostCategory)
                            else
                                JobPlanningLine.SetFilter("NS_Cost Category", NSCostCategory);
                            PAGE.RUN(PAGE::"Job Planning Lines", JobPlanningLine);
                        end;
                    }
                    field(MaterialAmt; Round(StdEstAmount[2], 0.01))
                    {
                        ApplicationArea = All;
                        Caption = 'Material';

                        trigger OnDrillDown();
                        begin
                            NSCostCategory := '';
                            NS_JobCostCategory.RESET();
                            NS_JobCostCategory.SetCurrentKey(NS_Type);
                            NS_JobCostCategory.SetRange(NS_Type, NS_JobCostCategory.NS_Type::Material);
                            IF NS_JobCostCategory.FINDSET() THEN
                                REPEAT
                                    NSCostCategory := NSCostCategory + '|' + NS_JobCostCategory.NS_Code;
                                until NS_JobCostCategory.Next() = 0;
                            NSCostCategory := CopyStr(NSCostCategory, 2, 250);
                            JobPlanningLine.Reset();
                            //PE-300.Dk.1.0  29May2024 Start
                            //if Rec.NS_Status = Rec.NS_Status::Open then
                            if Rec."NS_Quote Status" = Rec."NS_Quote Status"::Open then
                                //PE-300.Dk.1.0  29May2024 End
                                JobPlanningLine.SetRange("Job No.", Rec."NS_Quote No.")
                            else
                                JobPlanningLine.SetRange("NS_Job Quote No.", Rec."NS_Quote No.");
                            if NSCostCategory = '' then
                                JobPlanningLine.SetFilter("NS_Cost Category", '<>%1&%2', '', NSCostCategory)
                            else
                                JobPlanningLine.SetFilter("NS_Cost Category", NSCostCategory);
                            PAGE.RUN(PAGE::"Job Planning Lines", JobPlanningLine);
                        end;
                    }
                    field(EquipmentAmt; Round(StdEstAmount[3], 0.01))
                    {
                        ApplicationArea = All;
                        Caption = 'Equipment';
                        trigger OnDrillDown();
                        begin
                            NSCostCategory := '';
                            NS_JobCostCategory.RESET();
                            NS_JobCostCategory.SetCurrentKey(NS_Type);
                            NS_JobCostCategory.SetRange(NS_Type, NS_JobCostCategory.NS_Type::Equipment);
                            IF NS_JobCostCategory.FINDSET() THEN
                                REPEAT
                                    NSCostCategory := NSCostCategory + '|' + NS_JobCostCategory.NS_Code;
                                until NS_JobCostCategory.Next() = 0;
                            NSCostCategory := CopyStr(NSCostCategory, 2, 250);
                            JobPlanningLine.Reset();
                            //PE-300.Dk.1.0  29May2024 Start
                            //if Rec.NS_Status = Rec.NS_Status::Open then
                            if Rec."NS_Quote Status" = Rec."NS_Quote Status"::Open then
                                //PE-300.Dk.1.0  29May2024 End
                                JobPlanningLine.SetRange("Job No.", Rec."NS_Quote No.")
                            else
                                JobPlanningLine.SetRange("NS_Job Quote No.", Rec."NS_Quote No.");
                            if NSCostCategory = '' then
                                JobPlanningLine.SetFilter("NS_Cost Category", '<>%1&%2', '', NSCostCategory)
                            else
                                JobPlanningLine.SetFilter("NS_Cost Category", NSCostCategory);
                            PAGE.RUN(PAGE::"Job Planning Lines", JobPlanningLine);
                        end;
                    }
                    field(SubcontractAmt; Round(StdEstAmount[4], 0.01))
                    {
                        ApplicationArea = All;
                        Caption = 'Subcontract';
                        trigger OnDrillDown();
                        begin
                            NSCostCategory := '';
                            NS_JobCostCategory.RESET();
                            NS_JobCostCategory.SetCurrentKey(NS_Type);
                            NS_JobCostCategory.SetRange(NS_Type, NS_JobCostCategory.NS_Type::Subcontract);
                            IF NS_JobCostCategory.FINDSET() THEN
                                REPEAT
                                    NSCostCategory := NSCostCategory + '|' + NS_JobCostCategory.NS_Code;
                                until NS_JobCostCategory.Next() = 0;
                            NSCostCategory := CopyStr(NSCostCategory, 2, 250);
                            JobPlanningLine.Reset();
                            //PE-300.Dk.1.0  29May2024 Start
                            //if Rec.NS_Status = Rec.NS_Status::Open then
                            if Rec."NS_Quote Status" = Rec."NS_Quote Status"::Open then
                                //PE-300.Dk.1.0  29May2024 End
                                JobPlanningLine.SetRange("Job No.", Rec."NS_Quote No.")
                            else
                                JobPlanningLine.SetRange("NS_Job Quote No.", Rec."NS_Quote No.");
                            if NSCostCategory = '' then
                                JobPlanningLine.SetFilter("NS_Cost Category", '<>%1&%2', '', NSCostCategory)
                            else
                                JobPlanningLine.SetFilter("NS_Cost Category", NSCostCategory);
                            PAGE.RUN(PAGE::"Job Planning Lines", JobPlanningLine);
                        end;
                    }
                    field(ManufacturingAmt; Round(StdEstAmount[5], 0.01))
                    {
                        ApplicationArea = All;
                        Caption = 'Manufacturing';
                        trigger OnDrillDown();
                        begin
                            NSCostCategory := '';
                            NS_JobCostCategory.RESET();
                            NS_JobCostCategory.SetCurrentKey(NS_Type);
                            NS_JobCostCategory.SetRange(NS_Type, NS_JobCostCategory.NS_Type::Manufacturing);
                            IF NS_JobCostCategory.FINDSET() THEN
                                REPEAT
                                    NSCostCategory := NSCostCategory + '|' + NS_JobCostCategory.NS_Code;
                                until NS_JobCostCategory.Next() = 0;
                            NSCostCategory := CopyStr(NSCostCategory, 2, 250);
                            JobPlanningLine.Reset();
                            //PE-300.Dk.1.0  29May2024 Start
                            // if Rec.NS_Status = Rec.NS_Status::Open then
                            if Rec."NS_Quote Status" = Rec."NS_Quote Status"::Open then
                                //PE-300.Dk.1.0  29May2024 End
                                JobPlanningLine.SetRange("Job No.", Rec."NS_Quote No.")
                            else
                                JobPlanningLine.SetRange("NS_Job Quote No.", Rec."NS_Quote No.");
                            if NSCostCategory = '' then
                                JobPlanningLine.SetFilter("NS_Cost Category", '<>%1&%2', '', NSCostCategory)
                            else
                                JobPlanningLine.SetFilter("NS_Cost Category", NSCostCategory);
                            PAGE.RUN(PAGE::"Job Planning Lines", JobPlanningLine);
                        end;
                    }
                    field(OverheadAmt; Round(StdEstAmount[6], 0.01))
                    {
                        ApplicationArea = All;
                        Caption = 'Overhead';
                        trigger OnDrillDown();
                        begin
                            NSCostCategory := '';
                            NS_JobCostCategory.RESET();
                            NS_JobCostCategory.SetCurrentKey(NS_Type);
                            NS_JobCostCategory.SetRange(NS_Type, NS_JobCostCategory.NS_Type::Overhead);
                            IF NS_JobCostCategory.FINDSET() THEN
                                REPEAT
                                    NSCostCategory := NSCostCategory + '|' + NS_JobCostCategory.NS_Code;
                                until NS_JobCostCategory.Next() = 0;
                            NSCostCategory := CopyStr(NSCostCategory, 2, 250);
                            JobPlanningLine.Reset();
                            //PE-300.Dk.1.0  29May2024 Start
                            //  if Rec.NS_Status = Rec.NS_Status::Open then
                            if Rec."NS_Quote Status" = Rec."NS_Quote Status"::Open then
                                //PE-300.Dk.1.0  29May2024 End
                                JobPlanningLine.SetRange("Job No.", Rec."NS_Quote No.")
                            else
                                JobPlanningLine.SetRange("NS_Job Quote No.", Rec."NS_Quote No.");
                            if NSCostCategory = '' then
                                JobPlanningLine.SetFilter("NS_Cost Category", '<>%1&%2', '', NSCostCategory)
                            else
                                JobPlanningLine.SetFilter("NS_Cost Category", NSCostCategory);
                            PAGE.RUN(PAGE::"Job Planning Lines", JobPlanningLine);
                        end;
                    }
                    field(MiscellaneousAmt; Round(StdEstAmount[7], 0.01))
                    {
                        ApplicationArea = All;
                        Caption = 'Miscellaneous';
                        trigger OnDrillDown();
                        begin
                            NSCostCategory := '';
                            NS_JobCostCategory.RESET();
                            NS_JobCostCategory.SetCurrentKey(NS_Type);
                            NS_JobCostCategory.SetRange(NS_Type, NS_JobCostCategory.NS_Type::Miscellaneous);
                            IF NS_JobCostCategory.FINDSET() THEN
                                REPEAT
                                    NSCostCategory := NSCostCategory + '|' + NS_JobCostCategory.NS_Code;
                                until NS_JobCostCategory.Next() = 0;
                            NSCostCategory := CopyStr(NSCostCategory, 2, 250);

                            JobPlanningLine.Reset();
                            //PE-300.Dk.1.0  29May2024 Start
                            //if Rec.NS_Status = Rec.NS_Status::Open then
                            if Rec."NS_Quote Status" = Rec."NS_Quote Status"::Open then
                                //PE-300.Dk.1.0  29May2024 End
                                JobPlanningLine.SetRange("Job No.", Rec."NS_Quote No.")
                            else
                                JobPlanningLine.SetRange("NS_Job Quote No.", Rec."NS_Quote No.");
                            if NSCostCategory = '' then
                                JobPlanningLine.SetFilter("NS_Cost Category", '<>%1&%2', '', NSCostCategory)
                            else
                                JobPlanningLine.SetFilter("NS_Cost Category", NSCostCategory);
                            PAGE.RUN(PAGE::"Job Planning Lines", JobPlanningLine);

                        end;
                    }
                    field(UnrecognizedAmt; Round(StdEstAmount[8], 0.01))
                    {
                        ApplicationArea = All;
                        Caption = 'Miscellaneous';
                        trigger OnDrillDown();
                        begin
                            JobPlanningLine.Reset();
                            //PE-300.Dk.1.0  29May2024 Start
                            //if Rec.NS_Status = Rec.NS_Status::Open then
                            if Rec."NS_Quote Status" = Rec."NS_Quote Status"::Open then
                                //PE-300.Dk.1.0  29May2024 End
                                JobPlanningLine.SetRange("Job No.", Rec."NS_Quote No.")
                            else
                                JobPlanningLine.SetRange("NS_Job Quote No.", Rec."NS_Quote No.");
                            JobPlanningLine.SetFilter("NS_Cost Category", '%1', '');
                            PAGE.RUN(PAGE::"Job Planning Lines", JobPlanningLine);

                        end;
                    }
                    field(SubTotal1; SubTotalAmt)
                    {
                        ApplicationArea = all;
                        Caption = 'Sub Total';
                        Style = Strong;
                        StyleExpr = true;
                    }
                    field(ProfitAmt; ProfitAmt)
                    {
                        ApplicationArea = all;
                        Caption = 'Profit';
                    }
                    field(TotalAmt1; SubTotalAmt + ProfitAmt)
                    {
                        ApplicationArea = all;
                        Caption = 'Total';
                        Style = Strong;
                        StyleExpr = true;
                    }
                }
                group("Hours")
                {

                    Caption = '                           Hours';
                    field(StdEstHours; Round(StdEstHours, 0.001))
                    {
                        ApplicationArea = All;
                        trigger OnDrillDown();
                        begin
                            NSCostCategory := '';
                            NS_JobCostCategory.RESET();
                            NS_JobCostCategory.SetCurrentKey(NS_Type);
                            NS_JobCostCategory.SetRange(NS_Type, NS_JobCostCategory.NS_Type::Labor);
                            IF NS_JobCostCategory.FINDSET() THEN
                                REPEAT
                                    NSCostCategory := NSCostCategory + '|' + NS_JobCostCategory.NS_Code;
                                until NS_JobCostCategory.Next() = 0;
                            NSCostCategory := CopyStr(NSCostCategory, 2, 250);
                            JobPlanningLine.Reset();
                            //PE-300.Dk.1.0  29May2024 Start
                            // if Rec.NS_Status = Rec.NS_Status::Open then
                            if Rec."NS_Quote Status" = Rec."NS_Quote Status"::Open then
                                //PE-300.Dk.1.0  29May2024 End
                                JobPlanningLine.SetRange("Job No.", Rec."NS_Quote No.")
                            else
                                JobPlanningLine.SetRange("NS_Job Quote No.", Rec."NS_Quote No.");
                            JobPlanningLine.SetFilter("NS_Cost Category", NSCostCategory);
                            PAGE.RUN(PAGE::"Job Planning Lines", JobPlanningLine);
                        end;
                    }

                }
                group("Markup%")
                {
                    Caption = '                     Markup %';
                    field(LockedCostBill; '')
                    {
                        ApplicationArea = all;
                    }
                    field(AdjustmentRevenueCont; '')
                    {
                        ApplicationArea = All;
                    }

                    field(ContractTotalRev; '')
                    {
                        ApplicationArea = All;
                    }
                    field(ChangeRequst; '')
                    {
                        ApplicationArea = All;
                    }
                    field(ChangeRequst2; '')
                    {
                        ApplicationArea = All;
                    }
                    field(ChangeRequst4; '')
                    {
                        ApplicationArea = All;
                    }
                    field(ChangeRequst5; '')
                    {
                        ApplicationArea = All;
                    }
                    field(ChangeRequst8; '')
                    {
                        ApplicationArea = All;
                    }
                    field(ChangeRequst9; '')
                    {
                        ApplicationArea = All;
                    }
                    field(MarkupPer; MarkupPer)
                    {
                        ApplicationArea = All;
                        DecimalPlaces = 0 : 4;
                    }
                }

                group("Cost Per Unit")
                {
                    Caption = '                          Cost Per Unit';
                    field(LabarCost; Format((Round(StdEstAmount[1] / TotalUnits, 0.001))) + ' /' + Rec."NS_Unit of Measure")
                    {
                        ApplicationArea = All;
                        Caption = 'Labor';

                    }
                    field(MaterialCost; Format((Round(StdEstAmount[2] / TotalUnits, 0.001))) + ' /' + Rec."NS_Unit of Measure")
                    {
                        ApplicationArea = All;
                        Caption = 'Material';


                    }
                    field(EquipmentCost; Format((Round(StdEstAmount[3] / TotalUnits, 0.001))) + ' /' + Rec."NS_Unit of Measure")
                    {
                        ApplicationArea = All;
                        Caption = 'Equipment';

                    }
                    field(SubcontractCost; Format((Round(StdEstAmount[4] / TotalUnits, 0.001))) + ' /' + Rec."NS_Unit of Measure")
                    {
                        ApplicationArea = All;
                        Caption = 'Subcontract';

                    }
                    field(ManufacturingCost; Format((Round(StdEstAmount[5] / TotalUnits, 0.001))) + ' /' + Rec."NS_Unit of Measure")
                    {
                        ApplicationArea = All;
                        Caption = 'Manufacturing';

                    }
                    field(OverheadCost; Format((Round(StdEstAmount[6] / TotalUnits, 0.001))) + ' /' + Rec."NS_Unit of Measure")
                    {
                        ApplicationArea = All;
                        Caption = 'Overhead';

                    }
                    field(MiscellaneousCost; Format((Round(StdEstAmount[7] / TotalUnits, 0.001))) + ' /' + Rec."NS_Unit of Measure")
                    {
                        ApplicationArea = All;
                        Caption = 'Miscellaneous';

                    }
                    field(UnrecognizedCost; Format((Round(StdEstAmount[8] / TotalUnits, 0.001))) + ' /' + Rec."NS_Unit of Measure")
                    {
                        ApplicationArea = All;
                        Caption = 'Unrecognized';

                    }
                    field(SubTotalCost; Format((Round(SubTotalAmt / TotalUnits, 0.001))) + ' /' + Rec."NS_Unit of Measure")
                    {
                        ApplicationArea = all;
                        Caption = 'Sub Total';
                        Style = Strong;
                        StyleExpr = true;
                    }
                    field(ProfitAmtCost; Format((Round(ProfitAmt / TotalUnits, 0.001))) + ' /' + Rec."NS_Unit of Measure")
                    {
                        ApplicationArea = all;
                        Caption = 'Profit';
                    }
                    field(TotalAmtCost; Format((Round((SubTotalAmt + ProfitAmt) / TotalUnits, 0.001))) + ' /' + Rec."NS_Unit of Measure")
                    {
                        ApplicationArea = all;
                        Caption = 'Total';
                        Style = Strong;
                        StyleExpr = true;
                    }
                }
                group("Percent of Total")
                {
                    Caption = '                          Percent of Total';
                    field(LabarPer; Format(Round((StdEstAmount[1] / TotalAmt) * 100, 0.01)) + '%')
                    {
                        ApplicationArea = All;
                        Caption = 'Labor';

                    }
                    field(MaterialPer; Format(Round((StdEstAmount[2] / TotalAmt) * 100, 0.01)) + '%')
                    {
                        ApplicationArea = All;
                        Caption = 'Material';

                    }
                    field(EquipmentPer; Format(Round((StdEstAmount[3] / TotalAmt) * 100, 0.01)) + '%')
                    {
                        ApplicationArea = All;
                        Caption = 'Equipment';

                    }
                    field(SubcontractPer; Format(Round((StdEstAmount[4] / TotalAmt) * 100, 0.01)) + '%')
                    {
                        ApplicationArea = All;
                        Caption = 'Subcontract';

                    }
                    field(ManufacturingPer; Format(Round((StdEstAmount[5] / TotalAmt) * 100, 0.01)) + '%')
                    {
                        ApplicationArea = All;
                        Caption = 'Manufacturing';

                    }
                    field(OverheadPer; Format(Round((StdEstAmount[6] / TotalAmt) * 100, 0.01)) + '%')
                    {
                        ApplicationArea = All;
                        Caption = 'Overhead';

                    }
                    field(MiscellaneousPer; Format(Round((StdEstAmount[7] / TotalAmt) * 100, 0.01)) + '%')
                    {
                        ApplicationArea = All;
                        Caption = 'Miscellaneous';

                    }
                    field(UnrecognizedPer; Format(Round((StdEstAmount[8] / TotalAmt) * 100, 0.01)) + '%')
                    {
                        ApplicationArea = All;
                        Caption = 'Miscellaneous';

                    }
                    field(SubTotalPer; Format(SubTotalPer) + '%')
                    {
                        ApplicationArea = all;
                        Caption = 'Sub Total';
                        Style = Strong;
                        StyleExpr = true;
                    }
                    field(ProfitAmtPer; Format(SubTotalPerProfit) + '%')
                    {
                        ApplicationArea = all;
                        Caption = 'Profit';
                    }
                    field(TotalAmtPer; Format(Round((TotalAmtPer), 0.01)) + '%')
                    {
                        ApplicationArea = all;
                        Caption = 'Total';
                        Style = Strong;
                        StyleExpr = true;
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
        Rec.NS_CalculateStandardEstimateReport(Rec."NS_Quote No.", StdEstAmount);
        Rec.NS_CalculateHours(Rec."NS_Quote No.", StdEstHours);
        SubTotalAmt := Round(StdEstAmount[1] + StdEstAmount[2] + StdEstAmount[3] + StdEstAmount[4] + StdEstAmount[5] + StdEstAmount[6] + StdEstAmount[7] + StdEstAmount[8], 0.01);
        MarkupPer := 0;
        JobTask.Reset();
        JobTask.SetRange("NS_Quote No.", Rec."NS_Quote No.");
        JobTask.SetRange("Job Task Type", JobTask."Job Task Type"::Total);
        if JobTask.FindFirst() then begin
            JobTask.CalcFields("Schedule (Total Price)", "Schedule (Total Cost)");
            if JobTask."Schedule (Total Cost)" <> 0 then
                MarkupPer := Round((((JobTask."Schedule (Total Price)" - JobTask."Schedule (Total Cost)") / JobTask."Schedule (Total Cost)") * 100), 0.0001);
        end;
        if SubTotalAmt <> 0 then
            ProfitAmt := Round(SubTotalAmt * MarkupPer / 100, 0.01);
        TotalAmt := SubTotalAmt + ProfitAmt;
        if TotalAmt <> 0 then
            SubTotalPer := Round((SubTotalAmt / TotalAmt) * 100, 0.01);
        if (SubTotalAmt + ProfitAmt) <> 0 then
            SubTotalPerProfit := Round(((ProfitAmt / (SubTotalAmt + ProfitAmt)) * 100), 0.01);
        if (SubTotalAmt + ProfitAmt) <> 0 then
            TotalAmtPer := Round((((SubTotalAmt + ProfitAmt) / (SubTotalAmt + ProfitAmt)) * 100), 0.01);
        if TotalAmt = 0 then
            TotalAmt := 1;
        if rec."NS_Total Units" = 0 then
            TotalUnits := 1
        else
            TotalUnits := Rec."NS_Total Units";
    end;

    var
        StdEstAmount: ARRAY[10] OF Decimal;
        NS_JobCostCategory: Record "NS_Job Cost Category";
        JobPlanningLine: Record "Job Planning Line";
        JobTask: Record "Job Task";
        NSCostCategory: Code[250];
        MarkupPer: Decimal;
        SubTotalAmt: Decimal;
        StdEstHours: Decimal;
        TotalAmt: Decimal;
        ProfitAmt: Decimal;
        SubTotalPer: Decimal;
        SubTotalPerProfit: Decimal;
        TotalUnits: Decimal;
        TotalAmtPer: Decimal;

}

