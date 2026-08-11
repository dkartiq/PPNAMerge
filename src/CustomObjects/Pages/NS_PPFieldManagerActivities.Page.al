/// <summary>
/// Page NS_FieldManagerActivities (ID 14021254).
/// </summary>
page 14021254 "NS_PPFieldManagerActivities"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = "NS_ProjectPro Job Cue";
    //PE-211.AS.1.0 18DEC2023 Created New Page
    layout
    {
        area(content)
        {
            cuegroup(Due)
            {
                Caption = 'Due';
                field(Job2CompleteThisMonCalc; Job2CompleteThisMonCalc)
                {
                    Caption = 'Jobs To Complete This Month';
                    ToolTip = 'Jobs To Complete This Month';
                    ApplicationArea = All;
                    DrillDown = true;
                    //PE-211.AS.4.0 START ADD
                    trigger OnDrillDown()
                    var
                        JobsRec1: Record Job;
                    begin
                        JobsRec1.Reset();
                        JobsRec1.SetRange("NS_Field Manager", USERID());
                        JobsRec1.SetRange("NS_Manager Job Status", JobsRec1."NS_Manager Job Status"::Running);
                        JobsRec1.SetRange("NS_Estimated Completion Date", Rec."NS_Date Filter");
                        PAGE.RUN(PAGE::"job list", JobsRec1);
                    end;
                    //PE-211.AS.4.0 END ADD
                }

                field(OpenJobBackLogCalc; OpenJobBackLogCalc)
                {
                    Caption = 'Open Job Backlog';
                    ToolTip = ' Specifies the difference between the "Total Contract Price” and the "Total Invoiced Price” including Master & the Sub Levels Jobs. The value under this field will get updated only when the “Open Job Backlog Batch” is run.  Note: Open Job Backlog calculation includes Jobs only with the status "Open” or “Planning", and in addition to this the "Manager Job Status" should also be set to "Planning."';
                    ApplicationArea = All;
                    DrillDown = true;

                    //PE-211.AS.4.0 START ADD
                    trigger OnDrillDown()
                    var
                        JobsRec2: Record Job;
                    begin
                        JobsRec2.Reset();
                        JobsRec2.SetRange("NS_Field Manager", USERID());
                        JobsRec2.SetFilter(Status, '%1|%2', JobsRec2.Status::Open, JobsRec2.Status::Planning);
                        JobsRec2.SetFilter("NS_Open Job Backlog", '<>%1', 0);
                        PAGE.RUN(PAGE::"job list", JobsRec2);
                    end;
                    //PE-211.AS.4.0 END ADD
                }

                field(OpenChanReq; OpenChanReq)
                {
                    ApplicationArea = All;
                    Caption = 'Open Change Request';
                    ToolTip = 'Open Change Request';
                    DrillDown = true;

                    trigger OnDrillDown();
                    var
                        JobsRec3: Record Job;
                    begin
                        JobsRec3.RESET();
                        JobsRec3.SetRange("NS_Field Manager", USERID());
                        JobsRec3.SETRANGE(Status, NS_Jobs.Status::Open);
                        JobsRec3.SETRANGE("NS_Job Class", JobsRec3."NS_Job Class"::"Change Request");
                        PAGE.RUN(PAGE::"Job List", JobsRec3);
                    end;
                }

                actions
                {
                    action("NS_Job Create Sales Invoice")
                    {
                        ApplicationArea = All;
                        Caption = 'Job Create Sales Invoice';

                        ToolTip = 'Job Create Sales Invoice';
                        RunObject = Report "Job Create Sales Invoice";
                    }
                    action("NS_Aged A/R with Retention")
                    {
                        ApplicationArea = All;
                        Caption = 'Aged A/R with Retention';

                        ToolTip = 'Aged A/R with Retention';
                        RunObject = Report "NS_Aged Accounts ReceivableRet";
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
        Rec."NS_Job CostExceedsContBillings" := 0;
        Rec."NS_Job Profit below Estimate" := 0;
        Rec."NS_Retention Invoices Due" := 0;

        JobCalc.RESET();
        JobCalc.SETCURRENTKEY("NS_Manager Job Status");
        JobCalc.SETRANGE("NS_Manager Job Status", JobCalc."NS_Manager Job Status"::Running);
        if JobCalc.FINDSET() then
            repeat
                //Calulate Job Cost Exceeds Contract Billings
                JobCalc.NS_CalculateActualCostToDate(JobCalc, ActualCostToDate, true);
                JobCalc.CalculateInvoiceBilled(JobCalc, InvoiceBilled, true);
                if ActualCostToDate[3] > InvoiceBilled[3] then
                    Rec."NS_Job CostExceedsContBillings" += 1;

                //Calulate Job Projected Profit below Estimated
                JobCalc.CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");
                CLEAR("Sub-LevelsCost");
                CLEAR("Sub-LevelsPrice");
                "Sub-LevelsCost" := JobCalc.NS_SLsBudgetedLaborHours(JobCalc);
                "Sub-LevelsPrice" := JobCalc."SLsUsage(Price)"(JobCalc);
                TotalContract := JobCalc."NS_Budgeted Price (LCY)" + "Sub-LevelsPrice";
                TotalBudgetedCost := JobCalc."NS_Budgeted Cost (LCY)" + "Sub-LevelsCost";
                if JobCalc."NS_Actual Percent Complete" > 0 then
                    ProjectedCost := JobCalc."NS_Actual Percent Complete"
                else begin
                    if JobCalc."NS_Budgeted Cost (LCY)" + "Sub-LevelsCost" <> 0 then
                        CalcPctComplete := ROUND((ActualCostToDate[3] / (JobCalc."NS_Budgeted Cost (LCY)" + "Sub-LevelsCost")), 0.0001)
                    else
                        CalcPctComplete := 0;
                    ProjectedCost := CalcPctComplete * 100;
                end;
                if ProjectedCost <> 0 then
                    ProjectedCost := ActualCostToDate[3] / (ProjectedCost / 100);
                if (TotalContract - TotalBudgetedCost) > (TotalContract - ProjectedCost) then
                    Rec."NS_Job Profit below Estimate" += 1;
            until JobCalc.NEXT() = 0;

        //Calculate Retention Invoices Due
        CustLedgEntry.RESET();
        CustLedgEntry.SETCURRENTKEY("Document Type", "Customer No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date", "Currency Code", "NS_Retention Ledger Code");
        CustLedgEntry.SETRANGE("NS_Retention Ledger Code", JobsSetup."NS_Retention Receivable Ledger");
        if CustLedgEntry.FINDSET() then
            repeat
                if CustLedgEntry."NS_Retention Date" <= WORKDATE then
                    if CustLedgEntry."NS_Retention Amount" <> 0 then begin
                        CustLedgEntry.CALCFIELDS("Remaining Amount");
                        if CustLedgEntry."Remaining Amount" <> 0 then
                            Rec."NS_Retention Invoices Due" += 1;
                    end;
            until CustLedgEntry.NEXT() = 0;

        //Calculate open subcontract
        OpenSubcontracts := 0;
        Subcontract.RESET();
        if Subcontract.FIND('-') then
            repeat
                if Subcontract.NS_Status = Subcontract.NS_Status::Order then
                    OpenSubcontracts += 1;
            until Subcontract.NEXT() = 0;


        //Calculate Job Backlog from Planning to Running
        Backlog := 0;
        Job.RESET();
        if Job.FINDSET() then
            repeat
                //Find "Running" top-level jobs, calculate Backlog as Contract Total Value less Total Invoice Billed
                if Job."NS_Sub-Level to Job No." = '' then
                    if Job."NS_Manager Job Status" = Job."NS_Manager Job Status"::Running then begin
                        Job.CALCFIELDS("NS_Budgeted Price (LCY)");
                        Backlog += Job."NS_Budgeted Price (LCY)";
                        Backlog += Job."SLsUsage(Price)"(Job);
                        Job.CalculateInvoiceBilled(Job, InvoiceBilled, true);
                        Backlog -= InvoiceBilled[3];
                    end;
            until Job.NEXT() = 0;

        NS_DailyJobLogs := 0;
        NS_DailyJobLog.Reset();
        NS_DailyJobLog.SetRange(Status, NS_DailyJobLog.Status::Open);
        if NS_DailyJobLog.FindSet() then
            NS_DailyJobLogs := NS_DailyJobLog.Count;

        //Calculate Open Job Back Logs
        //PE-211.AS.4.0 start
        OpenJobBackLogCalc := 0;
        JobCal6.RESET();
        JobCal6.SetRange("NS_Field Manager", UserId());
        JobCal6.SetFilter(Status, '%1|%2', JobCal6.Status::Open, JobCal6.Status::Planning);
        JobCal6.SetFilter("NS_Open Job Backlog", '<>%1', 0);
        if JobCal6.FindSet() then
            repeat
                if JobCal6."NS_Field Manager" <> '' then
                    OpenJobBackLogCalc += 1;
            until JobCal6.Next() = 0;
        //PE-211.AS.4.0 end

        //Calculate JobsToComplete this Month
        //PE-211.AS.4.0 start

        JobCal5.RESET();
        JobCal5.SetRange("NS_Field Manager", UserId());
        JobCal5.SetRange("NS_Manager Job Status", JobCal5."NS_Manager Job Status"::Running);
        JobCal5.Setfilter("NS_Estimated Completion Date", '%1', Rec."NS_Date Filter");
        if JobCal5.FindSet() then
            Job2CompleteThisMonCalc := JobCal5.Count();
        //PE-211.AS.4.0 end

        //Calculate Open Change Requests
        //PE-211.AS.4.0 start
        OpenChanReq := 0;
        JobCal7.RESET();
        JobCal7.SetRange("NS_Field Manager", UserId());
        JobCal7.SETRANGE(Status, NS_Jobs.Status::Open);
        JobCal7.SETRANGE("NS_Job Class", JobCal7."NS_Job Class"::"Change Request");
        if JobCal7.FindSet() then
            repeat
                if JobCal7."NS_Field Manager" <> '' then
                    OpenChanReq += 1;
            until JobCal7.Next() = 0;
        //PE-211.AS.4.0 end

    end;

    trigger OnOpenPage();
    var
        NSConfPersonalizationMgt: Codeunit "Conf./Personalization Mgt.";
    begin
        NSConfPersonalizationMgt.RaiseOnOpenRoleCenterEvent();
        Rec.RESET();
        if not Rec.GET() then begin
            Rec.INIT();
            Rec.INSERT();
        end;
        Rec.SETFILTER("NS_Date Filter", '%1..%2', 19000101D, CALCDATE('<CM>'));
        Rec.SETFILTER("NS_Date Filter2", '<%1', WORKDATE);
        JobsSetup.GET();

        Job2CompleteThisMonCalc := 0;
    end;

    var

        JobCalc: Record Job;
        VendorInsurance: Record "NS_Vendor Insurance";
        Job: Record Job;
        JobRec: Record Job;
        Subcontract: Record NS_Subcontract;
        PurchaseHeader: Record "Purchase Header";
        JobsSetup: Record "Jobs Setup";
        CustLedgEntry: Record "Cust. Ledger Entry";
        ActualCostToDate: array[3] of Decimal;
        InvoiceBilled: array[3] of Decimal;
        "Sub-LevelsCost": Decimal;
        "Sub-LevelsPrice": Decimal;
        TotalContract: Decimal;
        TotalBudgetedCost: Decimal;
        CalcPctComplete: Decimal;
        ProjectedCost: Decimal;
        NS_Jobs: Record Job;
        OpenSubcontracts: Integer;
        // ExpiringInsurance: Integer;//PE-211.AS.3.0 COMMENT
        Backlog: Decimal;
        NS_DailyJobLogs: Integer;
        OpenJobBackLogCalc: Integer; //PE-211.AS.4.0 
        Job2CompleteThisMonCalc: Integer; //PE-211.AS.4.0 
        OpenChanReq: Integer;
        JobCal6: Record Job; //PE-211.AS.4.0 
        JobCal7: Record Job; //PE-211.AS.4.0 

        JobCal5: Record Job; //PE-211.AS.4.0 
        JobCal3: Record Job; //PE-211.AS.4.0 
        NS_DailyJobLog: Record "NS_Daily Job Log";
}

