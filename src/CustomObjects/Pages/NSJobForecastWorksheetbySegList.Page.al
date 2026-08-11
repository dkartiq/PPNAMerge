page 14021457 "NS_Job Forecast Work bySeglist"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-144 VT 11-03-20 -- Group Caption set to Blank as it was taking caption as Name
    //PRJ-144 VT 17-03-20 -- Caption Added
    //PRJ-285.MS.1.0 added new field amount rec. not inv.
    //PRJ-301.AS.1.0 - Increased length
    //JD-48.AS.1.0 31OCT2020 Created new Page By taking reference from PAG14021187

    Caption = 'Job Forecast by Segment List';
    PageType = List;
    SourceTable = "NS_Job Forecast by Seg code";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    Caption = 'Job No.';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Job No.';
                }
                field("NS_Segment Code"; Rec."NS_Segment Code")
                {
                    Caption = 'Segment Code';
                    ApplicationArea = All;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = true;
                    ToolTip = 'Specifies the Segment Code';
                }

                field("NS_Segment Name"; Rec."NS_Segment Name")
                {
                    ApplicationArea = All;
                    Caption = 'Segment Name';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Segment Name';
                }
                field("Job Task No."; Rec."NS_Job Task No.")
                {
                    ApplicationArea = All;
                    Caption = 'Job Task No.';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Job Task No.';
                }
                field(Description; JobTask.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Description';
                }
                //CTSI-121.N.S.1.0 18Aug2020 Comment code
                //field(DetailManager; JobTask.PP_Manager)
                //  {
                //      ApplicationArea = All;
                //      Caption = 'Manager';
                //      Editable = false;
                //      Style = Strong;
                //      StyleExpr = TRUE;
                //      ToolTip = 'Specifies the Manager';
                //  }
                //CTSI-121.N.S.1.0 18Aug2020 Comment code
                //CTSI-121.N.S.1.0 18Aug2020 start
                field(ManagerValue; ManagerValue)
                {
                    ApplicationArea = All;
                    Caption = 'Manager';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Manager';
                }
                field(PersonResponsible; PersonResponsible)
                {
                    ApplicationArea = All;
                    Caption = 'Person Responsible';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Person Responsible';
                }
                //CTSI-121.N.S.1.0 18Aug2020 end
                field("Work Units"; JobPlanningLineBudget."NS_Work Units")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Work Units';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Work Units';
                }
                field("Work Unit of Measure"; JobPlanningLineBudget."NS_Work Unit of Measure")
                {
                    ApplicationArea = All;
                    Caption = 'Work Unit of Measure';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Work Unit of Measure';
                }
                field("Previous Status Date"; PreviousJobForecast."NS_Status Date")
                {
                    ApplicationArea = All;
                    Caption = 'Previous Status Date';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Previous Status Date';
                }
                field("Previous Units Complete"; PreviousJobForecast."NS_Units Complete")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Previous Units Complete';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Previous Units Complete';
                }
                field(PreviousPercentComplete; PreviousJobForecast."NS_Percent Complete")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Previous Percent Complete';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Previous Percent Complete';
                }
                field("Prev Forecast Completed Cost"; PreviousJobForecast."NS_Forecasted Completed Cost")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Previous Forecasted Completed Cost';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Previous Forecasted Completed Cost';
                }
                field("Previous Hours to Finish"; PreviousJobForecast."NS_Hours To Finish")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Previous Hours to Finish';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Previous Hours to Finish';
                }
                field("Budgeted Costs"; TotalBudget)
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Budgeted Costs';
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Budgeted Costs';
                }
                field("Total Costs Used"; TotalCostsUsed)
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Total Costs Used';
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Total Costs Used';
                }
                field("Budget Remaining"; BudgetRemaining)
                {
                    ApplicationArea = All;
                    Caption = 'Budget Remaining';
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Budget Remaining';
                }
                field("Budget Percentage Used"; BudgetPercentageUsed)
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Budget Percentage Used';
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Budget Percentage Used';
                }
                field("NS_Status Date"; Rec."NS_Status Date")
                {
                    ApplicationArea = All;
                    Caption = 'New Status Date';
                    Editable = false;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the New Status Date';
                }
                field("NS_Units Complete"; Rec."NS_Units Complete")
                {
                    ApplicationArea = All;
                    Caption = 'New Total Units Complete';
                    Editable = false;
                    ToolTip = 'Specifies the New Total Units Complete';
                }
                field("NS_Percent Complete"; Rec."NS_Percent Complete")
                {
                    ApplicationArea = All;
                    Caption = 'New Total Percent Complete';
                    Editable = false;
                    MaxValue = 100;
                    MinValue = 0;
                    ToolTip = 'Specifies the New Total Percent Complete';
                }
                field("NS_Cost To Complete"; Rec."NS_Cost To Complete")
                {
                    ApplicationArea = All;
                    Caption = 'Estimated Cost To Complete';
                    Editable = false;
                    ToolTip = 'Specifies the Estimated Cost To Complete';
                }
                field("NS_Forecasted Completed Cost"; Rec."NS_Forecasted Completed Cost")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Forecasted Completed Cost';
                }
                field("NS_Hours To Finish"; Rec."NS_Hours To Finish")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Hours To Finish';
                }
                field(ForecastedVariance; ForecastedVariance)
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Forecasted Variance';
                    Editable = false;
                    ToolTip = 'Specifies the Forecasted Variance';
                }
                field("NS_Calc Expected Receipt Costs"; Rec."NS_Calc Expected Receipt Costs")
                {
                    ApplicationArea = All;
                    Caption = 'Calc Expected Receipt Costs';
                    ToolTip = 'Specifies the Calc Expected Receipt Costs';
                    Visible = false;
                    Editable = false;
                }
                field(POExpectedReceiptCost; Rec."NS_PO Expected Receipt Cost")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'PO Expected Receipt Cost';
                    Editable = false;
                    Style = Favorable;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the PO Expected Receipt Cost';
                }
                field("Outstanding Orders"; JobTask."Outstanding Orders")
                {
                    ApplicationArea = All;
                    Caption = 'Outstanding Orders';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the number of outstanding orders for the job task';
                }
                field(AmtRcdNotInv; AmtRcdNotInv)
                {
                    ApplicationArea = ALL;
                    Caption = 'Amt. Rcd. Not Invoiced';
                    Editable = false;
                    Description = 'PRJ-285.MS.1.0';
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the amount received but not invoiced for the job task';
                }
                field("NS_Bill Date"; Rec."NS_Bill Date")
                {
                    ApplicationArea = All;
                    Caption = 'Bill Date';
                    Editable = false;
                    Style = Favorable;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Bill Date';
                }
                field("NS_Bill Percent"; Rec."NS_Bill Percent")
                {
                    ApplicationArea = All;
                    Caption = 'Bill Percent';
                    Editable = false;
                    BlankZero = true;
                    Style = Favorable;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Bill Percent';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    var
        glsetup: Record "General Ledger Setup";
    begin
        if NS_Posted = false then
            NS_FillInTable;
        if JobTask.GET(Rec."NS_Job No.", "NS_Job Task No.") then;
        JobTask.CALCFIELDS("Outstanding Orders", "Amt. Rcd. Not Invoiced");
        //CTSI-21.MS.1.0 start
        JobLedEntry.Reset();
        JobLedEntry.SetCurrentKey("Job No.", "Job Task No.", Type, "Entry Type", "Unit of Measure Code");
        JobLedEntry.SetRange("Job No.", "NS_Job No.");
        JobLedEntry.SetRange("NS_Segment Code", "NS_Segment Code");
        JobLedEntry.SetRange("Job Task No.", "NS_Job Task No.");
        JobLedEntry.SetFilter(Type, '%1', JobLedEntry.Type::Resource);
        JobLedEntry.SetFilter("Entry Type", '%1', JobLedEntry."Entry Type"::Usage);
        JobLedEntry.SetFilter("Unit of Measure Code", '%1', 'HR');
        if AsOfDateFilter <> 0D then
            JobLedEntry.SetFilter("Posting Date", '%1..%2', 0D, AsOfDateFilter);
        JobLedEntry.CalcSums(Quantity);
        //CTSI-21.MS.1.0 end 
        //CTSI-21.MS.1.001 start
        if glsetup.Get() then;
        "NS_Remaining Hours" := "NS_Budgeted Hours" - jobledEntry.Quantity;//"Actual Hours";
        if "NS_Budgeted Hours" <> 0 then
            "NS_Budgeted Hrs Percent Compelete" := round(jobledEntry.Quantity * 100 / "NS_Budgeted Hours", glsetup."Amount Rounding Precision");
        //round("Actual Hours" * 100 / "Budgeted Hours", glsetup."Amount Rounding Precision");
        //CTSI-21.MS.1.001 end  
        //PRJ-285.MS.1.0 start
        AmtRcdNotInv := 0;
        AmtRcdNotInv1 := 0;
        AmtRcdNotInv2 := 0;
        PurRecpLine.reset;
        PurRecpLine.setrange("Job No.", "NS_Job No.");
        PurRecpLine.SetRange("NS_Segment Code", "NS_Segment Code");
        PurRecpLine.SetRange("Job Task No.", "NS_Job Task No.");
        if AsOfDateFilter <> 0D then
            PurRecpLine.SetRange("Posting Date", 0D, AsOfDateFilter);
        if PurRecpLine.FindFirst() then
            repeat
                AmtRcdNotInv1 := AmtRcdNotInv1 + PurRecpLine."Qty. Rcd. Not Invoiced" * PurRecpLine."Direct Unit Cost";
                AmtRcdNotInv2 := AmtRcdNotInv2 + PurRecpLine."Quantity Invoiced" * PurRecpLine."Direct Unit Cost";
            until PurRecpLine.Next() = 0;
        InvAmt := 0;
        PurcInvLine.Reset();
        PurcInvLine.SetRange("Job No.", "NS_Job No.");
        PurcInvLine.SetRange("NS_Segment Code", "NS_Segment Code");
        PurcInvLine.SetRange("Job Task No.", "NS_Job Task No.");
        if AsOfDateFilter <> 0D then
            PurcInvLine.SetRange("Posting Date", 0D, AsOfDateFilter);
        if PurcInvLine.FindFirst() then
            repeat
                InvAmt := InvAmt + PurcInvLine.Quantity * PurcInvLine."Direct Unit Cost";
            until PurcInvLine.Next() = 0;
        AmtRcdNotInv := AmtRcdNotInv1 + AmtRcdNotInv2 - InvAmt;
        //PRJ-285.MS.1.0 end 

    end;

    trigger OnInit();
    begin
        GLSetup.GET();
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        CLEAR(Rec);
        CLEAR(JobPlanningLineBudget);
        CLEAR(PreviousJobForecast);
        CLEAR(Job);
        CLEAR(JobTask);
        TotalBudget := 0;
        TotalCostsUsed := 0;
        BudgetRemaining := 0;
        BudgetPercentageUsed := 0;
        "NS_Cost To Complete" := 0;
        "NS_Forecasted Completed Cost" := 0;
        ForecastedVariance := 0;
    end;

    trigger OnOpenPage();
    var
        SegmentHeader_L: Record "NS_Job Takeoff Segments";
    begin
        SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date");
        CurrentJobNo := JobNoSentIn;
        JobDescription := '';
        if CurrentJobNo > '' then
            if Job.GET(CurrentJobNo) then begin
                JobDescription := Job.Description;
                CurrPage.SAVERECORD;
            end;
        //CTSI-121.N.S.1.0 18Aug2020 Start
        if JobsRec.get(CurrentJobNo) then
            PersonResponsible := JobsRec."Person Responsible"
        else
            PersonResponsible := '';
        if JobsRec.get(CurrentJobNo) then
            ManagerValue := JobsRec.NS_Manager
        Else
            ManagerValue := '';
        //CTSI-121.N.S.1.0 18Aug2020 Start

        CurrentTaskManager := TaskManagerSentIn;
        TaskManagerName := '';
        if CurrentTaskManager > '' then
            if Resource.GET(CurrentTaskManager) then begin
                TaskManagerName := Resource.Name;
                CurrPage.SAVERECORD;
            end;

        CurrSegCode := SegCode;
        SegName := '';
        if CurrSegCode > '' then begin
            SegmentHeader_L.Reset;
            SegmentHeader_L.SetRange("NS_Job No.", CurrentJobNo);
            SegmentHeader_L.SetRange("NS_Segment Code", CurrSegCode);
            if SegmentHeader_L.FindFirst then begin
                CurrSegCode := SegmentHeader_L."NS_Segment Code";
                SegName := SegmentHeader_L."NS_Segment Name";
                CurrPage.SAVERECORD;
            end;
        end;

        AsOfDateFilter := AsOfDateSentIn;
        NextBillDate := 0D;
        if AsOfDateFilter > 0D then begin
            FilterMonth := DATE2DMY(AsOfDateFilter, 2);
            case true of
                FilterMonth <= 10:
                    NextBillDate := DMY2DATE(1, DATE2DMY(AsOfDateFilter, 2) + 2, DATE2DMY(AsOfDateFilter, 3)) - 1;
                FilterMonth = 11:
                    NextBillDate := DMY2DATE(31, 12, DATE2DMY(AsOfDateFilter, 3));
                else
                    NextBillDate := DMY2DATE(31, 1, DATE2DMY(AsOfDateFilter, 3) + 1);
            end;
        end;

        NS_ListUpdate;

        FILTERGROUP := 2;
        if CurrentJobNo > '' then
            SETRANGE("NS_Job No.", CurrentJobNo);
        if CurrSegCode > '' then
            SETRANGE("NS_Segment Code", CurrSegCode);
        SETRANGE(NS_Posted, false);
        FILTERGROUP := 1;

        NS_ListUpdate;
    end;

    trigger OnAfterGetCurrRecord()

    begin
        //CTSI-21.MS.1.0 start
        if AsOfDateFilter <> 0D then begin
            JobLedEntry.Reset();
            JobLedEntry.SetCurrentKey("Job No.", "Job Task No.", Type, "Entry Type", "Unit of Measure Code", "Posting Date");
            JobLedEntry.SetRange("Job No.", "NS_Job No.");
            JobLedEntry.SetRange("NS_Segment Code", "NS_Segment Code");
            JobLedEntry.SetRange("Job Task No.", "NS_Job Task No.");
            JobLedEntry.SetFilter(Type, '%1', JobLedEntry.Type::Resource);
            JobLedEntry.SetFilter("Entry Type", '%1', JobLedEntry."Entry Type"::Usage);
            JobLedEntry.SetFilter("Unit of Measure Code", '%1', 'HR');
            JobLedEntry.SetFilter("Posting Date", '%1..%2', 0D, AsOfDateFilter);
            JobLedEntry.CalcSums(Quantity);
        end else begin
            JobLedEntry.Reset();
            JobLedEntry.SetCurrentKey("Job No.", "Job Task No.", Type, "Entry Type", "Unit of Measure Code");
            JobLedEntry.SetRange("Job No.", "NS_Job No.");
            JobLedEntry.SetRange("NS_Segment Code", "NS_Segment Code");
            JobLedEntry.SetRange("Job Task No.", "NS_Job Task No.");
            JobLedEntry.SetFilter(Type, '%1', JobLedEntry.Type::Resource);
            JobLedEntry.SetFilter("Entry Type", '%1', JobLedEntry."Entry Type"::Usage);
            JobLedEntry.SetFilter("Unit of Measure Code", '%1', 'HR');
            JobLedEntry.CalcSums(Quantity);
        end;
        //CTSI-21.MS.1.0 end   
    end;

    var
        JobNoShow: Code[20];
        Job: Record Job;
        JobTask: Record "Job Task";
        JobPlanningLineBudget: Record "Job Planning Line";
        PreviousJobForecast: Record "NS_Job Forecast by Seg code";//JD-48.AS.1.0 31OCT2020
        Resource: Record Resource;
        SegmentHeader: Record "NS_Job Takeoff Segments";//JD-48.AS.1.0 31OCT2020
        JobForecastWorksheetReport: Report "NS_Job Forecast Worksheet";
        JobForecastSummary: Page "NS_Job Forecast Summary";
        GetJobForecastRevenueTotal: Report "NS_Get JobForecastRevenueTotal";
        GLSetup: Record "General Ledger Setup";
        CurrentJobNo: Code[20];
        JobDescription: Text;//PRJ-301.AS.1.0 Changed description length from 50 to Blank
        SegCode: code[20];//JD-48.AS.1.0 31OCT2020
        CurrSegCode: code[20];//JD-48.AS.1.0 31OCT2020
        SegName: Text[50];//JD-48.AS.1.0 31OCT2020
        CurrentTaskManager: Code[100];//PRJ-301.AS.1.0
        TaskManagerName: Text;//PRJ-301.AS.1.0 Changed description length from 50 to Blank
        TotalBudget: Decimal;
        TotalTaskBudget: Decimal;
        TotalCostsUsed: Decimal;
        JobCostsUsed: Decimal;
        BudgetRemaining: Decimal;
        BudgetPercentageUsed: Decimal;
        ForecastedVariance: Decimal;
        LoadProjections: Report "NS_LoadProjectionsIntoForecast";
        JobNoSentIn: Code[20];
        AsOfDateSentIn: Date;
        TaskManagerSentIn: Code[20];
        AsOfDateFilter: Date;
        JobTaskNo: Label '02-02400-02441';
        Text001: Label 'The value of the new percent complete can not be less than %1 which was the previous value posted for this line.';
        NextBillDate: Date;
        MonthEndDate: Date;
        Text002: Label 'There must be a specific job being shown and a value for the Next Bill Date.';
        FilterMonth: Integer;
        Text003: Label 'There must be a value in As of Date Filter.';
        JobLedEntry: Record "Job Ledger Entry";
        AmtRcdNotInv: Decimal; //PRJ-285.MS.1.0
        AmtRcdNotInv1: Decimal; //PRJ-285.MS.1.0
        AmtRcdNotInv2: Decimal; //PRJ-285.MS.1.0
        PurRecpLine: Record "Purch. Rcpt. Line";//PRJ-285.MS.1.0
        PurcInvLine: Record "Purch. Inv. Line"; //PRJ-285.MS.1.0
        InvAmt: Decimal;//PRJ-285.MS.1.0
        SegmentHeader_L1: Record "NS_Job Takeoff Segments";
        ManagerValue: Code[20];//CTSI-121.N.S.1.0 18Aug2020
        JobsRec: Record Job;//CTSI-121.N.S.1.0 18Aug2020
        PersonResponsible: Code[20];//CTSI-121.N.S.1.0 18Aug2020

    procedure NS_FillInTable();
    var
        UseRecord: Boolean;
    begin
        BudgetRemaining := 0;
        if Rec."NS_Job No." > '' then begin

            //Fill in JobTask information on the Page if available
            if JobTask.GET(Rec."NS_Job No.", "NS_Job Task No.") then;

            //Get previous completion status for the task
            NS_GetLastPostedStatus(Rec."NS_Job No.", Rec."NS_Job Task No.", 0D, PreviousJobForecast, Rec."NS_Segment Code");
            NS_GetJobPlanningLineAndBudget(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, TotalBudget, Rec."NS_Segment Code");

            //Total Costs Used
            TotalCostsUsed := 0;
            if Job.GET(Rec."NS_Job No.") then begin
                Job.SETRANGE("NS_Job Task No. Filter", "NS_Job Task No.");
                Job.SetRange("NS_Segment Code Filter", "NS_Segment Code");//JD-48.AS.2.0
                if NextBillDate > 0D then begin
                    if DATE2DMY(NextBillDate, 2) < 12 then
                        MonthEndDate := DMY2DATE(1, DATE2DMY(NextBillDate, 2) + 1, DATE2DMY(NextBillDate, 3)) - 1
                    else
                        MonthEndDate := DMY2DATE(31, 12, DATE2DMY(NextBillDate, 3));
                end;
                if AsOfDateFilter <> 0D then
                    Job.SETFILTER("NS_Date Filter", '..%1', AsOfDateFilter)
                else
                    Job.SETRANGE("NS_Date Filter");
                Job.CALCFIELDS("NS_Usage (Cost) (LCY)");
                TotalCostsUsed := Job."NS_Usage (Cost) (LCY)";
            end;

            //Budget Remaining
            if "NS_Percent Complete" < 100 then begin
                BudgetRemaining := TotalBudget - TotalCostsUsed;
                if BudgetRemaining <= 0 then
                    BudgetRemaining := 0;

                BudgetPercentageUsed := NS_CalcPercentFrom0To100(TotalBudget, TotalCostsUsed);
                if "NS_Hours To Finish" = 0 then
                    "NS_Cost To Complete" := NS_CalcCostToComplete("NS_Status Date", "NS_Percent Complete", TotalBudget, TotalCostsUsed,
                                                             PreviousJobForecast."NS_Status Date",
                                                             PreviousJobForecast."NS_Forecasted Completed Cost");
                "NS_Forecasted Completed Cost" := TotalCostsUsed + "NS_Cost To Complete";
            end;
            if "NS_Percent Complete" <> 100 then
                ForecastedVariance := TotalBudget - "NS_Forecasted Completed Cost"
            else
                ForecastedVariance := TotalBudget - TotalCostsUsed;

        end;
    end;

    local procedure NS_StatusDateOnAfterValidate();
    begin
        if "NS_Status Date" = 0D then begin
            "NS_Percent Complete" := 0;
            "NS_Units Complete" := 0;
            NS_FillInTable;
            CLEAR(JobTask);
            JobTask.CALCFIELDS("Outstanding Orders", "Amt. Rcd. Not Invoiced");
        end;
    end;

    local procedure NS_UnitsCompleteOnAfterValidate();
    begin
        if ("NS_Units Complete" > 0) and (JobPlanningLineBudget."NS_Work Units" > 0) then
            "NS_Percent Complete" := ROUND(("NS_Units Complete" / JobPlanningLineBudget."NS_Work Units") * 100, GLSetup."Amount Rounding Precision")
        else
            //"PP_Percent Complete" := 0; //PRJ-350 comment
        NS_CheckPercentComplete;

        "NS_Cost To Complete" := NS_CalcCostToComplete("NS_Status Date", "NS_Percent Complete", TotalBudget, TotalCostsUsed,
                                                 PreviousJobForecast."NS_Status Date",
                                                 PreviousJobForecast."NS_Forecasted Completed Cost");
        "NS_Forecasted Completed Cost" := TotalCostsUsed + "NS_Cost To Complete";
        ForecastedVariance := TotalBudget - "NS_Forecasted Completed Cost";
    end;

    local procedure NS_PercentCompleteOnAfterValidate();
    var
        ProjectedCost: Decimal;
        CalcDate: Date;
    begin
        NS_CheckPercentComplete;
        if "NS_Status Date" <> 0D then
            CalcDate := "NS_Status Date"
        else
            CalcDate := AsOfDateFilter;
        if JobPlanningLineBudget."NS_Work Units" <> 0 then
            "NS_Units Complete" := ROUND(JobPlanningLineBudget."NS_Work Units" * ("NS_Percent Complete" / 100), GLSetup."Amount Rounding Precision")
        else
            "NS_Units Complete" := 0;
        if "NS_Percent Complete" < 100 then begin
            "NS_Cost To Complete" := NS_CalcCostToComplete(CalcDate, "NS_Percent Complete", TotalBudget, TotalCostsUsed,
                                                     PreviousJobForecast."NS_Status Date",
                                                     PreviousJobForecast."NS_Forecasted Completed Cost");
            "NS_Forecasted Completed Cost" := TotalCostsUsed + "NS_Cost To Complete";
        end else begin
            if "NS_Percent Complete" = 100 then begin
                "NS_Cost To Complete" := 0;
                "NS_Forecasted Completed Cost" := TotalCostsUsed;
            end else begin
                "NS_Cost To Complete" := 0;
                "NS_Forecasted Completed Cost" := PreviousJobForecast."NS_Forecasted Completed Cost";
            end;
        end;
        ForecastedVariance := TotalBudget - "NS_Forecasted Completed Cost";
    end;

    local procedure NS_CostToCompleteOnAfterValidate();
    begin
        "NS_Forecasted Completed Cost" := TotalCostsUsed + "NS_Cost To Complete";
        ForecastedVariance := TotalBudget - "NS_Forecasted Completed Cost";
        if "NS_Forecasted Completed Cost" <> 0 then
            //"Percent Complete" := 100 - ROUND(("Cost To Complete" / "Forecasted Completed Cost") * 100,GLSetup."Amount Rounding Precision")
            "NS_Percent Complete" := 100 - ("NS_Cost To Complete" / "NS_Forecasted Completed Cost") * 100
        else
            "NS_Percent Complete" := 0;
        NS_CheckPercentComplete;
        if JobPlanningLineBudget."NS_Work Units" <> 0 then
            "NS_Units Complete" := ROUND(JobPlanningLineBudget."NS_Work Units" * ("NS_Percent Complete" / 100), GLSetup."Amount Rounding Precision")
        else
            "NS_Units Complete" := 0;
    end;

    local procedure NS_HoursToFinishOnAfterValidate();
    var
        GLsetep: Record "General Ledger Setup";
    begin
        If GLsetep.Get() then;
        //"NS_Cost To Complete" := ROUND("NS_Hours To Finish" * JobPlanningLineBudget."Unit Cost", GLSetup."Amount Rounding Precision");//CTSI-21.MS.1.0
        if (jobledEntry.Quantity + "NS_Hours To Finish") <> 0 then //CTSI-21.MS.1.0
            "NS_Percent Complete" := Round(jobledEntry.Quantity * 100 / (jobledEntry.Quantity + "NS_Hours To Finish"), GLsetep."Amount Rounding Precision"); //CTSI-21.MS.1.0
                                                                                                                                                             //Round("NS_Actual Hours" * 100 / ("Actual Hours" + "NS_Hours To Finish"), GLsetep."Amount Rounding Precision"); //CTSI-21.MS.1.0
    end;

    procedure NS_ForecastedCompletedCostOnAfter();
    begin
        if "NS_Percent Complete" < 100 then begin
            "NS_Cost To Complete" := "NS_Forecasted Completed Cost" - TotalCostsUsed;
            ForecastedVariance := TotalBudget - "NS_Forecasted Completed Cost";
            if "NS_Forecasted Completed Cost" <> 0 then
                "NS_Percent Complete" := 100 - ROUND(("NS_Cost To Complete" / "NS_Forecasted Completed Cost") * 100, GLSetup."Amount Rounding Precision")
            else
                "NS_Percent Complete" := 0;
        end;

        NS_CheckPercentComplete;
        if JobPlanningLineBudget."NS_Work Units" <> 0 then
            "NS_Units Complete" := ROUND(JobPlanningLineBudget."NS_Work Units" * ("NS_Percent Complete" / 100), GLSetup."Amount Rounding Precision")
        else
            "NS_Units Complete" := 0;
    end;

    procedure NS_ListUpdate();
    var
        StartBillingPeriod: Date;
        EndBillingPeriod: Date;
    begin
        RESET();
        FILTERGROUP := 2;
        SETRANGE("NS_Job No.");
        SETRANGE("NS_Task Manager");
        if CurrentJobNo > '' then
            SETRANGE("NS_Job No.", CurrentJobNo);
        if CurrentTaskManager > '' then
            SETRANGE("NS_Task Manager", CurrentTaskManager);
        if CurrSegCode > '' then
            SetRange("NS_Segment Code", CurrSegCode);
        SETRANGE(NS_Posted, false);
        FILTERGROUP := 0;
        if FINDSET then;
        NS_GetNewTasks(CurrentJobNo, CurrentTaskManager);
        CurrPage.UPDATE(false);
    end;

    procedure NS_SetBillDate();
    begin
        if ("NS_Bill Date" = 0D) and (NextBillDate > 0D) then
            VALIDATE("NS_Bill Date", NextBillDate);
    end;

    procedure NS_SetStatusDate();
    begin
        if AsOfDateFilter > 0D then
            "NS_Status Date" := AsOfDateFilter;
    end;

    local procedure NS_CheckPercentComplete();
    begin
        //IF "Percent Complete" < PreviousJobForecast."Percent Complete" THEN
        //ERROR(Text001,PreviousJobForecast."Percent Complete");
    end;

    procedure NS_Set(JobNoIn: Code[20]; SegmentCodeP: Code[20]; AsOfDateIn: Date);
    begin
        JobNoSentIn := JobNoIn;
        SegCode := SegmentCodeP;
        AsOfDateSentIn := AsOfDateIn;
    end;

    procedure NS_SetJobNo(JobNoInsert: Code[20]);
    begin
        JobNoShow := JobNoInsert;
    end;


    procedure NS_SetPurchLineFilters(var PurchLine: Record "Purchase Line");
    begin
        PurchLine.SETCURRENTKEY("Document Type", "Job No.", "Job Task No.");
        PurchLine.SETRANGE("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SETRANGE("Job No.", "NS_Job No.");
        PurchLine.SETRANGE("Job Task No.", "NS_Job Task No.");
    end;
}

