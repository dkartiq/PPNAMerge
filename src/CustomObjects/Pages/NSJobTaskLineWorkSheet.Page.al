page 14021314 "NS_Job Task Line Worksheet"
{
    //PRJ-1586.NK.1.0 09Sep2022 | Create New Page
    //PE-82.RM.1.0 26Apr2023 | Added field property.
    Caption = 'Job Task Line Worksheet';

    DataCaptionFields = "Job No.";
    PageType = Worksheet;
    SourceTable = "Job Task";
    SourceTableView = SORTING("Job No.", "Job Task No.")
                      ORDER(Ascending);
    Permissions = tabledata 167 = rimd;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(Control1100773004)
            {
                Caption = '';
                field(CurrentJobNo; CurrentJobNo)
                {
                    ApplicationArea = All;
                    Caption = 'Job No.:';
                    Lookup = true;
                    LookupPageID = "Job List";
                    ToolTip = 'Specifies the Job No.:';

                    trigger OnLookup(VAR Text: Text): Boolean;
                    begin
                        CurrPage.SAVERECORD;
                        COMMIT;
                        Job."No." := CurrentJobNo;
                        if PAGE.RUNMODAL(0, Job) = ACTION::LookupOK then begin
                            if Job."No." > '' then
                                if Job.GET(Job."No.") then
                                    CurrentJobNo := Job."No.";
                        end;
                        NS_ListUpdate();
                    end;
                }
                field(TaskStartDate; TaskStartDate)
                {
                    ApplicationArea = All;
                    Caption = 'Task Start Date:';
                    ToolTip = 'Specifies the Task Start Date:';

                    trigger OnValidate();
                    begin
                        TaskEndDate := WorkDate();
                        NS_ListUpdate();

                    end;
                }
                field(TaskEndDate; TaskEndDate)
                {
                    ApplicationArea = All;
                    Caption = 'Task End Date:';
                    ToolTip = 'Specifies the Task End Date:';

                    trigger OnValidate();
                    begin
                        NS_ListUpdate();
                    end;
                }
                field(JobTaskNo; JobTaskNo)
                {
                    ApplicationArea = All;
                    Caption = 'Job Task No';
                    ToolTip = 'Specifies the Job Task No.';
                    trigger OnValidate()
                    begin
                        NS_ListUpdate();
                        CurrPage.Update();
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        JobTask.Reset();
                        JobTask.SetRange("Job No.", CurrentJobNo);
                        if PAGE.RUNMODAL(0, JobTask) = ACTION::LookupOK then
                            JobTaskNo := JobTask."Job Task No.";
                        NS_ListUpdate();
                    end;
                }
                field(JobTaskType; JobTaskType)
                {
                    ApplicationArea = All;
                    Caption = 'Job Task Type';
                    OptionCaption = 'Posting,Heading,Total,Begin-Total,End-Total';
                    ToolTip = 'Specifies the Job Task Type';
                    trigger OnValidate()
                    begin
                        if JobTaskType = JobTaskType::Total then
                            JobTaskNo := '';
                        NS_ListUpdate();
                    end;
                }
                field(JobDimen1; JobDimen1)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,1,1';
                    Caption = 'Global Dimension 1 Code';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));
                    ToolTip = 'Specifies the Job Task Type';
                    trigger OnValidate()
                    begin
                        NS_ListUpdate();
                    end;
                }
                field(JobDimen2; JobDimen2)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,1,2';
                    Caption = 'Global Dimension 2 Code';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));
                    ToolTip = 'Specifies the Job Task Type';
                    trigger OnValidate()
                    begin
                        NS_ListUpdate();
                    end;
                }
            }
            repeater(CSWorkSheet)
            {

                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Job Task No.';
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Description';
                }
                field("Job Task Type"; rec."Job Task Type")
                {
                    ApplicationArea = All;
                    Caption = 'Job Task Type';
                    Editable = false;
                    ToolTip = 'Specifies the Job Task Type';
                }
                field(WorkUnits; rec."NS_Work Units")
                {
                    ApplicationArea = All;
                    Caption = 'Work Units';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Work Units';
                }
                field("Task Start Date"; Rec."NS_Task Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Task Start Date';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Task Start Date';
                }
                field("Task End Date"; Rec."NS_Task End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Task End Date';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Task End Date';
                }
                //TotalBudgetedCost
                field(TotalBudgetedCostNew; TotalBudgetedCostNew)//PE-82.RM.1.0 26Apr2023 //Removed Format()
                {
                    ApplicationArea = All;
                    BlankZero = true; //PE-82.RM.1.0 26Apr2023
                    Caption = 'Budget (Total Cost)';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Budget (Total Cost)';
                }
                // field("Schedule (Total Cost)"; rec."Schedule (Total Cost)")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Budget (Total Cost)';
                //     Editable = false;
                //     Style = StandardAccent;
                //     StyleExpr = TRUE;
                //     ToolTip = 'Specifies the Budget (Total Cost)';
                // }
                field(ActualTotalCostNew; ActualTotalCostNew)
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Actual (Total Cost)';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Previous Actual (Total Cost)';
                }
                // field("Usage (Total Cost)"; Rec."Usage (Total Cost)")
                // {
                //     ApplicationArea = All;
                //     BlankZero = true;
                //     Caption = 'Actual (Total Cost)';
                //     Editable = false;
                //     Style = StandardAccent;
                //     StyleExpr = TRUE;
                //     ToolTip = 'Specifies the Previous Actual (Total Cost)';
                // }
                //BillableTotalPriceNew
                field(BillableTotalPriceNew; BillableTotalPriceNew)
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Billable (Total Price)';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Billable (Total Price)';
                }
                // field("Contract (Total Cost)"; Rec."Contract (Total Price)")
                // {
                //     ApplicationArea = All;
                //     BlankZero = true;
                //     Caption = 'Billable (Total Price)';
                //     Editable = false;
                //     Style = StandardAccent;
                //     StyleExpr = TRUE;
                //     ToolTip = 'Specifies the Billable (Total Price)';
                // }
                //InvoicedTotalPriceNew
                field(InvoicedTotalPriceNew; InvoicedTotalPriceNew)
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Invoiced (Total Price)';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Invoiced (Total Price)';
                }
                // field("Contract (Invoiced Price)"; rec."Contract (Invoiced Price)")
                // {
                //     ApplicationArea = All;
                //     BlankZero = true;
                //     Caption = 'Invoiced (Total Price)';
                //     Editable = false;
                //     Style = StandardAccent;
                //     StyleExpr = TRUE;
                //     ToolTip = 'Invoiced (Total Price)';
                // }

            }

            group(Total)
            {
                Caption = '';
                Editable = false;
                field(TotalBudgetedCost; TotalBudgetedCost)
                {
                    Caption = 'Total Budgeted Costs';
                    ToolTip = 'Total Budgeted Costs';
                    Visible = true;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field(BillableTotalPrice; BillableTotalPrice)

                {
                    Caption = 'Billable (Total Price)';
                    ToolTip = 'Billable (Total Price)';
                    Visible = true;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field(ActualTotalCost; ActualTotalCost)
                {
                    Caption = 'Total Actual Cost';
                    ToolTip = 'Total Actual Cost';
                    Visible = true;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }

                field(InvoicedTotalPrice; InvoicedTotalPrice)
                {
                    Caption = 'Invoiced (Total Price)';
                    ToolTip = 'Invoiced (Total Price)';
                    Visible = true;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }


            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        NS_ListUpdate();
    end;

    trigger OnOpenPage();
    begin
        NS_ListUpdate();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        NS_ListUpdate();
    end;


    var
        Job: Record Job;
        JobTask: Record "Job Task";
        JobLedgerEntry: Record "Job Ledger Entry";
        TotalBudgetedCost: Decimal;
        ActualTotalCost: Decimal;
        BillableTotalPrice: decimal;
        InvoicedTotalPrice: Decimal;
        TotalBudgetedCostNew: Decimal;
        ActualTotalCostNew: Decimal;
        BillableTotalPriceNew: Decimal;
        InvoicedTotalPriceNew: Decimal;

        JobTaskType: Option Posting,Heading,Total,"Begin-Total","End-Total";
        JobDimen1: Code[20];
        JobDimen2: Code[20];

        CurrentJobNo: Code[20];
        TaskStartDate: Date;
        JobTaskNo: Code[20];
        TaskEndDate: Date;

    procedure NS_ListUpdate();
    var
        JobTask: Record "Job Task";
    begin
        Rec.RESET();
        Rec.FILTERGROUP := 2;
        Rec.SETRANGE("Job No.");
        Rec.SETRANGE("Job Task No.");
        Rec.SetRange("Global Dimension 1 Code");
        Rec.SetRange("Global Dimension 2 Code");
        Rec.SetRange("Job Task Type");
        Rec.SetRange("Posting Date Filter");
        Rec.SetRange("Planning Date Filter");
        if CurrentJobNo > '' then
            Rec.SETRANGE("Job No.", CurrentJobNo);
        if JobTaskNo > '' then
            rec.SetRange("Job Task No.", JobTaskNo);
        if JobDimen1 > '' then
            Rec.SetRange("Global Dimension 1 Code", JobDimen1);
        if JobDimen2 > '' then
            Rec.SetRange("Global Dimension 2 Code", JobDimen2);
        if ((TaskStartDate <> 0D) and (TaskEndDate <> 0D)) then
            Rec.SetFilter("Posting Date Filter", '%1..%2', TaskStartDate, TaskEndDate);
        if ((TaskStartDate <> 0D) and (TaskEndDate <> 0D)) then
            Rec.SetFilter("Planning Date Filter", '%1..%2', TaskStartDate, TaskEndDate);
        Rec.SetRange("Job Task Type", JobTaskType);
        Rec.FILTERGROUP := 0;

        TotalBudgetedCost := NS_TotalBudgetedCosts();
        TotalBudgetedCostNew := NS_TotalBudgetedCostsNew();
        ActualTotalCost := NS_ActualTotalCost();
        ActualTotalCostNew := NS_ActualTotalCostNew();
        BillableTotalPrice := NS_BillableTotalPrice();
        BillableTotalPriceNew := NS_BillableTotalPriceNew();
        InvoicedTotalPrice := NS_InvoicedTotalPrice();
        InvoicedTotalPriceNew := NS_InvoicedTotalPriceNew();
        CurrPage.UPDATE(false);
    end;

    procedure NS_TotalBudgetedCosts(): Decimal;
    var
        JobPlanningLine: Record "Job Planning Line";
        totalCost: Decimal;
    begin
        totalCost := 0;

        if ((JobTaskType = JobTaskType::Posting) or (JobTaskType = JobTaskType::Total)) then begin
            JobPlanningLine.Reset();
            if CurrentJobNo <> '' then
                JobPlanningLine.SetRange("Job No.", CurrentJobNo);
            JobPlanningLine.SetRange("Schedule Line", true);
            if JobTaskNo <> '' then
                JobPlanningLine.SetFilter("Job Task No.", JobTaskNo);
            if JobDimen1 <> '' then
                JobPlanningLine.SetRange("NS_Shortcut Dimension 1 Code", JobDimen1);
            if JobDimen2 <> '' then
                JobPlanningLine.SetRange("NS_Shortcut Dimension 2 Code", JobDimen2);
            if ((TaskStartDate <> 0D) and (TaskEndDate <> 0D)) then
                JobPlanningLine.SetFilter("Planning Date", '%1..%2', TaskStartDate, TaskEndDate);
            if JobPlanningLine.FindFirst() then begin
                JobPlanningLine.CalcSums("Total Cost (LCY)");
                totalCost += JobPlanningLine."Total Cost (LCY)";
            end;
        end;
        if JobTaskType = JobTaskType::"End-Total" then begin
            JobTask.Reset();
            if CurrentJobNo <> '' then
                JobTask.SetRange("Job No.", CurrentJobNo);
            JobTask.SetRange("Job Task Type", JobTask."Job Task Type"::"End-Total");
            if JobTaskNo <> '' then
                JobTask.SetFilter("Job Task No.", JobTaskNo);
            if JobTask.FindFirst() then
                repeat
                    JobPlanningLine.Reset();
                    if CurrentJobNo <> '' then
                        JobPlanningLine.SetRange("Job No.", CurrentJobNo);
                    JobPlanningLine.SetRange("Schedule Line", true);
                    JobPlanningLine.SetFilter("Job Task No.", JobTask.Totaling);
                    if JobDimen1 <> '' then
                        JobPlanningLine.SetRange("NS_Shortcut Dimension 1 Code", JobDimen1);
                    if JobDimen2 <> '' then
                        JobPlanningLine.SetRange("NS_Shortcut Dimension 2 Code", JobDimen2);
                    if ((TaskStartDate <> 0D) and (TaskEndDate <> 0D)) then
                        JobPlanningLine.SetFilter("Planning Date", '%1..%2', TaskStartDate, TaskEndDate);
                    if JobPlanningLine.FindFirst() then begin
                        JobPlanningLine.CalcSums("Total Cost (LCY)");
                        totalCost += JobPlanningLine."Total Cost (LCY)";
                    end;
                until JobTask.Next() = 0;
        end;

        // JobTask.Reset();
        // if CurrentJobNo <> '' then
        //     JobTask.SetRange("Job No.", CurrentJobNo);
        // if JobTaskNo <> '' then
        //     JobTask.SetRange("Job Task No.", JobTaskNo);
        // if ((TaskStartDate <> 0D) and (TaskEndDate <> 0D)) then
        //     JobTask.SetFilter("Planning Date Filter", '%1..%2', TaskStartDate, TaskEndDate);
        // if JobTask.FindFirst() then
        //     repeat
        //         JobTask.CalcFields("Schedule (Total Cost)");
        //         totalCost += JobTask."Schedule (Total Cost)";
        //     until JobTask.Next() = 0;
        exit(totalCost);
    end;

    procedure NS_TotalBudgetedCostsNew(): Decimal;
    var
        JobPlanningLine: Record "Job Planning Line";
        totalCostNew: Decimal;
    begin
        totalCostNew := 0;
        if Rec.Totaling <> 'posting' then
            if ((JobTaskType = JobTaskType::Posting) or (JobTaskType = JobTaskType::Total)) then begin
                JobPlanningLine.Reset();
                if CurrentJobNo <> '' then
                    JobPlanningLine.SetRange("Job No.", CurrentJobNo);
                JobPlanningLine.SetRange("Schedule Line", true);
                JobPlanningLine.SetFilter("Job Task No.", Rec."Job Task No.");
                if JobDimen1 <> '' then
                    JobPlanningLine.SetRange("NS_Shortcut Dimension 1 Code", JobDimen1);
                if JobDimen2 <> '' then
                    JobPlanningLine.SetRange("NS_Shortcut Dimension 2 Code", JobDimen2);
                if ((TaskStartDate <> 0D) and (TaskEndDate <> 0D)) then
                    JobPlanningLine.SetFilter("Planning Date", '%1..%2', TaskStartDate, TaskEndDate);
                if JobPlanningLine.FindFirst() then begin
                    JobPlanningLine.CalcSums("Total Cost (LCY)");
                    totalCostNew += JobPlanningLine."Total Cost (LCY)";
                end;
            end;
        if JobTaskType = JobTaskType::"End-Total" then begin
            JobTask.Reset();
            if CurrentJobNo <> '' then
                JobTask.SetRange("Job No.", CurrentJobNo);
            JobTask.SetRange("Job Task Type", JobTask."Job Task Type"::"End-Total");
            JobTask.SetFilter("Job Task No.", Rec."Job Task No.");
            if JobTask.FindFirst() then
                repeat
                    JobPlanningLine.Reset();
                    if CurrentJobNo <> '' then
                        JobPlanningLine.SetRange("Job No.", CurrentJobNo);
                    JobPlanningLine.SetRange("Schedule Line", true);
                    JobPlanningLine.SetFilter("Job Task No.", JobTask.Totaling);
                    if JobDimen1 <> '' then
                        JobPlanningLine.SetRange("NS_Shortcut Dimension 1 Code", JobDimen1);
                    if JobDimen2 <> '' then
                        JobPlanningLine.SetRange("NS_Shortcut Dimension 2 Code", JobDimen2);
                    if ((TaskStartDate <> 0D) and (TaskEndDate <> 0D)) then
                        JobPlanningLine.SetFilter("Planning Date", '%1..%2', TaskStartDate, TaskEndDate);
                    if JobPlanningLine.FindFirst() then begin
                        JobPlanningLine.CalcSums("Total Cost (LCY)");
                        totalCostNew += JobPlanningLine."Total Cost (LCY)";
                    end;
                until JobTask.Next() = 0;
        end;

        // JobTask.Reset();
        // if CurrentJobNo <> '' then
        //     JobTask.SetRange("Job No.", CurrentJobNo);
        // if JobTaskNo <> '' then
        //     JobTask.SetRange("Job Task No.", JobTaskNo);
        // if ((TaskStartDate <> 0D) and (TaskEndDate <> 0D)) then
        //     JobTask.SetFilter("Planning Date Filter", '%1..%2', TaskStartDate, TaskEndDate);
        // if JobTask.FindFirst() then
        //     repeat
        //         JobTask.CalcFields("Schedule (Total Cost)");
        //         totalCost += JobTask."Schedule (Total Cost)";
        //     until JobTask.Next() = 0;
        exit(totalCostNew);
    end;

    procedure NS_ActualTotalCost(): Decimal;
    var
        TotActualCost: Decimal;
    begin
        TotActualCost := 0;
        if ((JobTaskType = JobTaskType::Posting) or (JobTaskType = JobTaskType::Total)) then begin
            JobLedgerEntry.Reset();
            if CurrentJobNo <> '' then
                JobLedgerEntry.SetRange("Job No.", CurrentJobNo);
            JobLedgerEntry.SetRange("Entry Type", JobLedgerEntry."Entry Type"::Usage);
            if JobTaskNo <> '' then
                JobLedgerEntry.SetFilter("Job Task No.", JobTaskNo);
            if JobDimen1 <> '' then
                JobLedgerEntry.SetRange("Global Dimension 1 Code", JobDimen1);
            if JobDimen2 <> '' then
                JobLedgerEntry.SetRange("Global Dimension 2 Code", JobDimen2);
            if ((TaskStartDate <> 0D) and (TaskEndDate <> 0D)) then
                JobLedgerEntry.SetFilter("Posting Date", '%1..%2', TaskStartDate, TaskEndDate);
            if JobLedgerEntry.FindFirst() then begin
                JobLedgerEntry.CalcSums("Total Cost (LCY)");
                TotActualCost += JobLedgerEntry."Total Cost (LCY)";
            end;
        end;

        if JobTaskType = JobTaskType::"End-Total" then begin
            JobTask.Reset();
            if CurrentJobNo <> '' then
                JobTask.SetRange("Job No.", CurrentJobNo);
            JobTask.SetRange("Job Task Type", JobTask."Job Task Type"::"End-Total");
            if JobTaskNo <> '' then
                JobTask.SetFilter("Job Task No.", JobTaskNo);
            if JobTask.FindFirst() then
                repeat
                    JobLedgerEntry.Reset();
                    if CurrentJobNo <> '' then
                        JobLedgerEntry.SetRange("Job No.", CurrentJobNo);
                    JobLedgerEntry.SetRange("Entry Type", JobLedgerEntry."Entry Type"::Usage);
                    JobLedgerEntry.SetFilter("Job Task No.", JobTask.Totaling);
                    if JobDimen1 <> '' then
                        JobLedgerEntry.SetRange("Global Dimension 1 Code", JobDimen1);
                    if JobDimen2 <> '' then
                        JobLedgerEntry.SetRange("Global Dimension 2 Code", JobDimen2);
                    if ((TaskStartDate <> 0D) and (TaskEndDate <> 0D)) then
                        JobLedgerEntry.SetFilter("Posting Date", '%1..%2', TaskStartDate, TaskEndDate);
                    if JobLedgerEntry.FindFirst() then begin
                        JobLedgerEntry.CalcSums("Total Cost (LCY)");
                        TotActualCost += JobLedgerEntry."Total Cost (LCY)";
                    end;
                until JobTask.Next() = 0;
        end;
        // JobTask.Reset();
        // if CurrentJobNo <> '' then
        //     JobTask.SetRange("Job No.", CurrentJobNo);
        // if JobTaskNo <> '' then
        //     JobTask.SetRange("Job Task No.", JobTaskNo);
        // if ((TaskStartDate <> 0D) and (TaskEndDate <> 0D)) then
        //     JobTask.SetFilter("Posting Date Filter", '%1..%2', TaskStartDate, TaskEndDate);
        // if JobTask.FindFirst() then
        //     repeat
        //         JobTask.CalcFields("Usage (Total Cost)");
        //         TotActualCost += JobTask."Usage (Total Cost)";
        //     until JobTask.Next() = 0;
        exit(TotActualCost);
    end;

    procedure NS_ActualTotalCostNew(): Decimal;
    var
        TotActualCostNew: Decimal;
    begin
        TotActualCostNew := 0;
        if Rec.Totaling <> 'posting' then
            if ((JobTaskType = JobTaskType::Posting) or (JobTaskType = JobTaskType::Total)) then begin
                JobLedgerEntry.Reset();
                if CurrentJobNo <> '' then
                    JobLedgerEntry.SetRange("Job No.", CurrentJobNo);
                JobLedgerEntry.SetFilter("Job Task No.", Rec."Job Task No.");
                JobLedgerEntry.SetRange("Entry Type", JobLedgerEntry."Entry Type"::Usage);
                // if JobTaskNo <> '' then
                //     JobLedgerEntry.SetFilter("Job Task No.", JobTaskNo);
                if JobDimen1 <> '' then
                    JobLedgerEntry.SetRange("Global Dimension 1 Code", JobDimen1);
                if JobDimen2 <> '' then
                    JobLedgerEntry.SetRange("Global Dimension 2 Code", JobDimen2);
                if ((TaskStartDate <> 0D) and (TaskEndDate <> 0D)) then
                    JobLedgerEntry.SetFilter("Posting Date", '%1..%2', TaskStartDate, TaskEndDate);
                if JobLedgerEntry.FindFirst() then begin
                    JobLedgerEntry.CalcSums("Total Cost (LCY)");
                    TotActualCostNew += JobLedgerEntry."Total Cost (LCY)";
                end;
            end;
        if JobTaskType = JobTaskType::"End-Total" then begin
            JobTask.Reset();
            if CurrentJobNo <> '' then
                JobTask.SetRange("Job No.", CurrentJobNo);
            JobTask.SetRange("Job Task Type", JobTask."Job Task Type"::"End-Total");
            JobTask.SetFilter("Job Task No.", Rec."Job Task No.");
            if JobTask.FindFirst() then
                repeat
                    JobLedgerEntry.Reset();
                    if CurrentJobNo <> '' then
                        JobLedgerEntry.SetRange("Job No.", CurrentJobNo);
                    JobLedgerEntry.SetRange("Entry Type", JobLedgerEntry."Entry Type"::Usage);
                    JobLedgerEntry.SetFilter("Job Task No.", JobTask.Totaling);
                    if JobDimen1 <> '' then
                        JobLedgerEntry.SetRange("Global Dimension 1 Code", JobDimen1);
                    if JobDimen2 <> '' then
                        JobLedgerEntry.SetRange("Global Dimension 2 Code", JobDimen2);
                    if ((TaskStartDate <> 0D) and (TaskEndDate <> 0D)) then
                        JobLedgerEntry.SetFilter("Posting Date", '%1..%2', TaskStartDate, TaskEndDate);
                    if JobLedgerEntry.FindFirst() then begin
                        JobLedgerEntry.CalcSums("Total Cost (LCY)");
                        TotActualCostNew += JobLedgerEntry."Total Cost (LCY)";
                    end;
                until JobTask.Next() = 0;
        end;
        // JobTask.Reset();
        // if CurrentJobNo <> '' then
        //     JobTask.SetRange("Job No.", CurrentJobNo);
        // if JobTaskNo <> '' then
        //     JobTask.SetRange("Job Task No.", JobTaskNo);
        // if ((TaskStartDate <> 0D) and (TaskEndDate <> 0D)) then
        //     JobTask.SetFilter("Posting Date Filter", '%1..%2', TaskStartDate, TaskEndDate);
        // if JobTask.FindFirst() then
        //     repeat
        //         JobTask.CalcFields("Usage (Total Cost)");
        //         TotActualCost += JobTask."Usage (Total Cost)";
        //     until JobTask.Next() = 0;
        exit(TotActualCostNew);
    end;

    procedure NS_BillableTotalPrice(): Decimal;
    var
        JobPlanningLine: Record "Job Planning Line";
        TotBillPrice: Decimal;
    begin
        TotBillPrice := 0;
        if ((JobTaskType = JobTaskType::Posting) or (JobTaskType = JobTaskType::Total)) then begin
            JobPlanningLine.Reset();
            if CurrentJobNo <> '' then
                JobPlanningLine.SetRange("Job No.", CurrentJobNo);
            JobPlanningLine.SetRange("Contract Line", true);
            if JobTaskNo <> '' then
                JobPlanningLine.SetFilter("Job Task No.", JobTaskNo);
            if JobDimen1 <> '' then
                JobPlanningLine.SetRange("NS_Shortcut Dimension 1 Code", JobDimen1);
            if JobDimen2 <> '' then
                JobPlanningLine.SetRange("NS_Shortcut Dimension 2 Code", JobDimen2);
            if ((TaskStartDate <> 0D) and (TaskEndDate <> 0D)) then
                JobPlanningLine.SetFilter("Planning Date", '%1..%2', TaskStartDate, TaskEndDate);
            if JobPlanningLine.FindFirst() then begin
                JobPlanningLine.CalcSums("Line Amount (LCY)");
                TotBillPrice += JobPlanningLine."Line Amount (LCY)";
            end;
        end;
        if JobTaskType = JobTaskType::"End-Total" then begin
            JobTask.Reset();
            if CurrentJobNo <> '' then
                JobTask.SetRange("Job No.", CurrentJobNo);
            JobTask.SetRange("Job Task Type", JobTask."Job Task Type"::"End-Total");
            if JobTaskNo <> '' then
                JobTask.SetFilter("Job Task No.", JobTaskNo);
            if JobTask.FindFirst() then
                repeat
                    JobPlanningLine.Reset();
                    if CurrentJobNo <> '' then
                        JobPlanningLine.SetRange("Job No.", CurrentJobNo);
                    JobPlanningLine.SetRange("Contract Line", true);
                    JobPlanningLine.SetFilter("Job Task No.", JobTask.Totaling);
                    if JobDimen1 <> '' then
                        JobPlanningLine.SetRange("NS_Shortcut Dimension 1 Code", JobDimen1);
                    if JobDimen2 <> '' then
                        JobPlanningLine.SetRange("NS_Shortcut Dimension 2 Code", JobDimen2);
                    if ((TaskStartDate <> 0D) and (TaskEndDate <> 0D)) then
                        JobPlanningLine.SetFilter("Planning Date", '%1..%2', TaskStartDate, TaskEndDate);
                    if JobPlanningLine.FindFirst() then begin
                        JobPlanningLine.CalcSums("Line Amount (LCY)");
                        TotBillPrice += JobPlanningLine."Line Amount (LCY)";
                    end;
                until JobTask.Next() = 0;
        end;

        // JobTask.Reset();
        // if CurrentJobNo <> '' then
        //     JobTask.SetRange("Job No.", CurrentJobNo);
        // if JobTaskNo <> '' then
        //     JobTask.SetRange("Job Task No.", JobTaskNo);
        // if ((TaskStartDate <> 0D) and (TaskEndDate <> 0D)) then
        //     JobTask.SetFilter("Planning Date Filter", '%1..%2', TaskStartDate, TaskEndDate);
        // if JobTask.FindFirst() then
        //     repeat
        //         JobTask.CalcFields("Contract (Total Price)");
        //         TotBillPrice += JobTask."Contract (Total Price)";
        //     until JobTask.Next() = 0;
        exit(TotBillPrice);
    end;

    procedure NS_BillableTotalPriceNew(): Decimal;
    var
        JobPlanningLine: Record "Job Planning Line";
        TotBillPriceNew: Decimal;
    begin
        TotBillPriceNew := 0;
        if Rec.Totaling <> 'posting' then
            if ((JobTaskType = JobTaskType::Posting) or (JobTaskType = JobTaskType::Total)) then begin
                JobPlanningLine.Reset();
                if CurrentJobNo <> '' then
                    JobPlanningLine.SetRange("Job No.", CurrentJobNo);
                JobPlanningLine.SetRange("Contract Line", true);
                // if JobTaskNo <> '' then
                JobPlanningLine.SetFilter("Job Task No.", rec."Job Task No.");
                if JobDimen1 <> '' then
                    JobPlanningLine.SetRange("NS_Shortcut Dimension 1 Code", JobDimen1);
                if JobDimen2 <> '' then
                    JobPlanningLine.SetRange("NS_Shortcut Dimension 2 Code", JobDimen2);
                if ((TaskStartDate <> 0D) and (TaskEndDate <> 0D)) then
                    JobPlanningLine.SetFilter("Planning Date", '%1..%2', TaskStartDate, TaskEndDate);
                if JobPlanningLine.FindFirst() then begin
                    JobPlanningLine.CalcSums("Line Amount (LCY)");
                    TotBillPriceNew += JobPlanningLine."Line Amount (LCY)";
                end;
            end;
        if JobTaskType = JobTaskType::"End-Total" then begin
            JobTask.Reset();
            if CurrentJobNo <> '' then
                JobTask.SetRange("Job No.", CurrentJobNo);
            JobTask.SetRange("Job Task Type", JobTask."Job Task Type"::"End-Total");
            // if JobTaskNo <> '' then
            JobTask.SetFilter("Job Task No.", Rec."Job Task No.");
            if JobTask.FindFirst() then
                repeat
                    JobPlanningLine.Reset();
                    if CurrentJobNo <> '' then
                        JobPlanningLine.SetRange("Job No.", CurrentJobNo);
                    JobPlanningLine.SetRange("Contract Line", true);
                    JobPlanningLine.SetFilter("Job Task No.", JobTask.Totaling);
                    if JobDimen1 <> '' then
                        JobPlanningLine.SetRange("NS_Shortcut Dimension 1 Code", JobDimen1);
                    if JobDimen2 <> '' then
                        JobPlanningLine.SetRange("NS_Shortcut Dimension 2 Code", JobDimen2);
                    if ((TaskStartDate <> 0D) and (TaskEndDate <> 0D)) then
                        JobPlanningLine.SetFilter("Planning Date", '%1..%2', TaskStartDate, TaskEndDate);
                    if JobPlanningLine.FindFirst() then begin
                        JobPlanningLine.CalcSums("Line Amount (LCY)");
                        TotBillPriceNew += JobPlanningLine."Line Amount (LCY)";
                    end;
                until JobTask.Next() = 0;
        end;

        // JobTask.Reset();
        // if CurrentJobNo <> '' then
        //     JobTask.SetRange("Job No.", CurrentJobNo);
        // if JobTaskNo <> '' then
        //     JobTask.SetRange("Job Task No.", JobTaskNo);
        // if ((TaskStartDate <> 0D) and (TaskEndDate <> 0D)) then
        //     JobTask.SetFilter("Planning Date Filter", '%1..%2', TaskStartDate, TaskEndDate);
        // if JobTask.FindFirst() then
        //     repeat
        //         JobTask.CalcFields("Contract (Total Price)");
        //         TotBillPrice += JobTask."Contract (Total Price)";
        //     until JobTask.Next() = 0;
        exit(TotBillPriceNew);
    end;

    procedure NS_InvoicedTotalPrice(): Decimal;
    var
        TotInvPrice: Decimal;
    begin
        TotInvPrice := 0;
        // JobLedgerEntry.Reset();
        // JobLedgerEntry.SetRange("Job No.", CurrentJobNo);
        // if JobTaskNo <> '' then
        //     JobLedgerEntry.SetFilter("Job Task No.", JobTaskNo);
        // JobLedgerEntry.SetFilter("Job Task No.", Rec.Totaling);
        // JobLedgerEntry.SetRange("Entry Type", JobLedgerEntry."Entry Type"::Sale);
        // if ((TaskStartDate <> 0D) and (TaskEndDate <> 0D)) then
        //     JobLedgerEntry.SetFilter("Posting Date", '%1..%2', TaskStartDate, TaskEndDate);
        // if ((TaskStartDate = 0D) and (TaskEndDate <> 0D)) then
        //     JobLedgerEntry.SetFilter("Posting Date", '%1..%2', 0D, TaskEndDate);
        // if ((TaskStartDate <> 0D) and (TaskEndDate = 0D)) then
        //     JobLedgerEntry.SetFilter("Posting Date", '%1..%2', 0D, TaskEndDate);
        // if JobLedgerEntry.FindFirst() then begin
        //     JobLedgerEntry.CalcSums("Line Amount (LCY)");
        //     TotInvPrice += JobLedgerEntry."Line Amount (LCY)";
        // end;
        //exit(-1 * TotInvPrice);
        if ((JobTaskType = JobTaskType::Posting) or (JobTaskType = JobTaskType::Total)) then begin
            JobLedgerEntry.Reset();
            if CurrentJobNo <> '' then
                JobLedgerEntry.SetRange("Job No.", CurrentJobNo);
            JobLedgerEntry.SetRange("Entry Type", JobLedgerEntry."Entry Type"::Sale);
            if JobTaskNo <> '' then
                JobLedgerEntry.SetFilter("Job Task No.", JobTaskNo);
            if JobDimen1 <> '' then
                JobLedgerEntry.SetRange("Global Dimension 1 Code", JobDimen1);
            if JobDimen2 <> '' then
                JobLedgerEntry.SetRange("Global Dimension 2 Code", JobDimen2);
            if ((TaskStartDate <> 0D) and (TaskEndDate <> 0D)) then
                JobLedgerEntry.SetFilter("Posting Date", '%1..%2', TaskStartDate, TaskEndDate);
            if JobLedgerEntry.FindFirst() then begin
                JobLedgerEntry.CalcSums("Line Amount (LCY)");
                TotInvPrice += JobLedgerEntry."Line Amount (LCY)";
            end;
        end;
        if JobTaskType = JobTaskType::"End-Total" then begin
            JobTask.Reset();
            if CurrentJobNo <> '' then
                JobTask.SetRange("Job No.", CurrentJobNo);
            JobTask.SetRange("Job Task Type", JobTask."Job Task Type"::"End-Total");
            if JobTaskNo <> '' then
                JobTask.SetFilter("Job Task No.", JobTaskNo);
            if JobTask.FindFirst() then
                repeat
                    JobLedgerEntry.Reset();
                    if CurrentJobNo <> '' then
                        JobLedgerEntry.SetRange("Job No.", CurrentJobNo);
                    JobLedgerEntry.SetRange("Entry Type", JobLedgerEntry."Entry Type"::Sale);
                    JobLedgerEntry.SetFilter("Job Task No.", JobTask.Totaling);
                    if JobDimen1 <> '' then
                        JobLedgerEntry.SetRange("Global Dimension 1 Code", JobDimen1);
                    if JobDimen2 <> '' then
                        JobLedgerEntry.SetRange("Global Dimension 2 Code", JobDimen2);
                    if ((TaskStartDate <> 0D) and (TaskEndDate <> 0D)) then
                        JobLedgerEntry.SetFilter("Posting Date", '%1..%2', TaskStartDate, TaskEndDate);
                    if JobLedgerEntry.FindFirst() then begin
                        JobLedgerEntry.CalcSums("Line Amount (LCY)");
                        TotInvPrice += JobLedgerEntry."Line Amount (LCY)";
                    end;
                until JobTask.Next() = 0;
        end;
        // JobTask.Reset();
        // if CurrentJobNo <> '' then
        //     JobTask.SetRange("Job No.", CurrentJobNo);
        // if JobTaskNo <> '' then
        //     JobTask.SetRange("Job Task No.", JobTaskNo);
        // if ((TaskStartDate <> 0D) and (TaskEndDate <> 0D)) then
        //     JobTask.SetFilter("Posting Date Filter", '%1..%2', TaskStartDate, TaskEndDate);
        // if JobTask.FindFirst() then
        //     repeat
        //         JobTask.CalcFields("Contract (Invoiced Price)");
        //         TotInvPrice += JobTask."Contract (Invoiced Price)";
        //     until JobTask.Next() = 0;
        exit(-1 * TotInvPrice);
    end;

    procedure NS_InvoicedTotalPriceNew(): Decimal;
    var
        TotInvPriceNew: Decimal;
    begin
        TotInvPriceNew := 0;
        if Rec.Totaling <> 'posting' then
            if ((JobTaskType = JobTaskType::Posting) or (JobTaskType = JobTaskType::Total)) then begin
                JobLedgerEntry.Reset();
                if CurrentJobNo <> '' then
                    JobLedgerEntry.SetRange("Job No.", CurrentJobNo);
                JobLedgerEntry.SetRange("Entry Type", JobLedgerEntry."Entry Type"::Sale);
                // if JobTaskNo <> '' then
                JobLedgerEntry.SetFilter("Job Task No.", Rec."Job Task No.");
                if JobDimen1 <> '' then
                    JobLedgerEntry.SetRange("Global Dimension 1 Code", JobDimen1);
                if JobDimen2 <> '' then
                    JobLedgerEntry.SetRange("Global Dimension 2 Code", JobDimen2);
                if ((TaskStartDate <> 0D) and (TaskEndDate <> 0D)) then
                    JobLedgerEntry.SetFilter("Posting Date", '%1..%2', TaskStartDate, TaskEndDate);
                if JobLedgerEntry.FindFirst() then begin
                    JobLedgerEntry.CalcSums("Line Amount (LCY)");
                    TotInvPriceNew += JobLedgerEntry."Line Amount (LCY)";
                end;
            end;
        if JobTaskType = JobTaskType::"End-Total" then begin
            JobTask.Reset();
            if CurrentJobNo <> '' then
                JobTask.SetRange("Job No.", CurrentJobNo);
            JobTask.SetRange("Job Task Type", JobTask."Job Task Type"::"End-Total");
            // if JobTaskNo <> '' then
            JobTask.SetFilter("Job Task No.", Rec."Job Task No.");
            if JobTask.FindFirst() then
                repeat
                    JobLedgerEntry.Reset();
                    if CurrentJobNo <> '' then
                        JobLedgerEntry.SetRange("Job No.", CurrentJobNo);
                    JobLedgerEntry.SetRange("Entry Type", JobLedgerEntry."Entry Type"::Sale);
                    JobLedgerEntry.SetFilter("Job Task No.", JobTask.Totaling);
                    if JobDimen1 <> '' then
                        JobLedgerEntry.SetRange("Global Dimension 1 Code", JobDimen1);
                    if JobDimen2 <> '' then
                        JobLedgerEntry.SetRange("Global Dimension 2 Code", JobDimen2);
                    if ((TaskStartDate <> 0D) and (TaskEndDate <> 0D)) then
                        JobLedgerEntry.SetFilter("Posting Date", '%1..%2', TaskStartDate, TaskEndDate);
                    if JobLedgerEntry.FindFirst() then begin
                        JobLedgerEntry.CalcSums("Line Amount (LCY)");
                        TotInvPriceNew += JobLedgerEntry."Line Amount (LCY)";
                    end;
                until JobTask.Next() = 0;
        end;
        // JobTask.Reset();
        // if CurrentJobNo <> '' then
        //     JobTask.SetRange("Job No.", CurrentJobNo);
        // if JobTaskNo <> '' then
        //     JobTask.SetRange("Job Task No.", JobTaskNo);
        // if ((TaskStartDate <> 0D) and (TaskEndDate <> 0D)) then
        //     JobTask.SetFilter("Posting Date Filter", '%1..%2', TaskStartDate, TaskEndDate);
        // if JobTask.FindFirst() then
        //     repeat
        //         JobTask.CalcFields("Contract (Invoiced Price)");
        //         TotInvPrice += JobTask."Contract (Invoiced Price)";
        //     until JobTask.Next() = 0;
        exit(-1 * TotInvPriceNew);
    end;

    procedure NS_Set(JobNoIn: Code[20]);
    begin
        CurrentJobNo := JobNoIn;
    end;
}



