page 14021354 "NS_ProjectProManagerActivities"
{
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-476.AS.1.0 15JAN 2021 Done code to show Subcontracts with statue order and their correct numbering
    //PRJ-477.AS.1.0 18JAN 2021 Done code to show Expired Vendor Insaurances and their correct numbering
    //PRJ-1710.RM.1.0 23Nov2022 | Added a tooltip
    //PRJ-1711.RP.1.0 24Nov2022 | Added a tooltip
    //PE-168.HS.1.0 18Nov2023| Added New CueGroup
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = "NS_ProjectPro Job Cue";

    layout
    {
        area(content)
        {
            cuegroup(Due)
            {
                Caption = 'Due';
                field("Jobs To Complete This Month"; Rec."NS_Jobs To Complete This Month")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Job List";
                    ToolTip = 'Jobs To Complete This Month';
                }
                field(Backlog; Backlog)
                {
                    ApplicationArea = All;
                    Caption = 'Open Job Backlog';
                    ToolTip = 'Open Job Backlog';
                    DrillDown = true;
                    DrillDownPageID = "Job List";
                    visible = false;//PRJ-1262.GK.1.0 03June2022
                }
                //PRJ-1262.GK.1.0 03June2022 start
                field("NS_Open Job Backlog"; Rec."NS_Open Job Backlog")
                {
                    // ToolTip = 'Specifies the value of the Open Job Backlog field.'; //PRJ-1710.RM.1.0 commented
                    //ToolTip = 'Open Job Backlog specifies the value which is the difference between the �Total Contract Price including Master & Sub Levels Jobs� minus �Total Invoiced Price including Master & the Sub Levels Jobs�. Open Job Backlog Batch can be run from the Job card & on the ProjectPro Manager Role Center. Note: Open Job Backlog calculation includes Jobs only with status �Open or Planning�, in addition to this �Manager Job Status� should be "Planning".'; //PRJ-1710.RM.1.0  //PRJ-1711.RP.1.0 01Dec2022 commented
                    // ToolTip = 'Open Job backlog Specifies the Value which is the difference between the "Total Contract Price including Master & Sub Levels Jobs" minus "Total Invoiced Price including Master & the Sub Levels Jobs". Open Job Backlog Batch can be run from the Job card & on the ProjectPro Manager Role Center. Note: Open Job Backlog calculation includes Jobs only with status "Open or Planning", in addition to this "Manager Job Status" should be "Running."';//PRJ-1711.RP.1.0 01Dec2022 //PRJ-1710.RM.1.0 06dec//PRJCTPR-122.PS.1.0 20Jun2023  //PRJCTPR-163.PS.1.0 20Jul2023 Commented 
                    ToolTip = ' Specifies the difference between the "Total Contract Price” and the "Total Invoiced Price” including Master & the Sub Levels Jobs. The value under this field will get updated only when the “Open Job Backlog Batch” is run.  Note: Open Job Backlog calculation includes Jobs only with the status "Open” or “Planning", and in addition to this the "Manager Job Status" should also be set to "Planning."'; //PRJCTPR-163.PS.1.0 20Jul2023
                    ApplicationArea = All;
                    DrillDown = true;
                }
                //PRJ-1262.GK.1.0 03June2022 end
                field("PP_Retention Invoices Due"; Rec."NS_Retention Invoices Due")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Job List";
                    ToolTip = 'Retention Invoices Due';

                    trigger OnDrillDown();
                    var
                        CLE: Record "Cust. Ledger Entry";
                    begin
                        CLE.RESET();
                        CLE.CLEARMARKS();
                        CLE.SETCURRENTKEY("Document Type", "Customer No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date", "Currency Code", "NS_Retention Ledger Code");
                        CLE.SETRANGE("NS_Retention Ledger Code", JobsSetup."NS_Retention Receivable Ledger");
                        if CLE.FINDSET() then
                            repeat
                                if CLE."NS_Retention Date" <= WORKDATE() then
                                    if CLE."NS_Retention Amount" <> 0 then begin
                                        CLE.CALCFIELDS("Remaining Amount");
                                        if CLE."Remaining Amount" <> 0 then
                                            CLE.MARK(true);
                                    end;
                            until CLE.NEXT() = 0;
                        CLE.MARKEDONLY(true);
                        PAGE.RUN(PAGE::"Customer Ledger Entries", CLE);
                    end;
                }
                //PRJCTPR-147.NK.1.0 Start 09Aug2023
                //  addafter("PP_Retention Invoices Due")

                field("OpenChangeRequest"; Rec."OpenChangeRequest")
                {
                    ApplicationArea = All;
                    ToolTip = 'Open Change Request';
                    DrillDownPageID = "Job List";
                    Visible = true;

                    trigger OnDrillDown();
                    var
                        NS_Jobs: Record Job;
                    begin
                        NS_Jobs.RESET();
                        NS_Jobs.SETRANGE(Status, NS_Jobs.Status::Open);
                        NS_Jobs.SETRANGE("NS_Job Class", NS_Jobs."NS_Job Class"::"Change Request");
                        PAGE.RUN(PAGE::"Job List", NS_Jobs);
                    end;
                }

                //PRJCTPR-147.NK.1.0 End 09Aug2023

                actions
                {
                    action("NS_Job Create Sales Invoice")
                    {
                        ApplicationArea = All;
                        Caption = 'Job Create Sales Invoice';

                        ToolTip = 'Job Create Sales Invoice';
                        //SPLN Image = CreateJobSalesInvoice;
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
            cuegroup(Profit)
            {
                Caption = 'Profit';
                field("Job Profit below Estimate"; "NS_Job Profit below Estimate")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Job List";

                    trigger OnDrillDown();
                    begin
                        JobRec.RESET();
                        JobRec.CLEARMARKS();
                        JobRec.SETRANGE("NS_Manager Job Status", JobRec."NS_Manager Job Status"::Running);
                        if JobRec.FINDSET() then
                            repeat
                                JobRec.NS_CalculateActualCostToDate(JobRec, ActualCostToDate, true);
                                JobRec.CalculateInvoiceBilled(JobRec, InvoiceBilled, true);
                                JobRec.CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");
                                CLEAR("Sub-LevelsCost");
                                CLEAR("Sub-LevelsPrice");
                                "Sub-LevelsCost" := JobRec.NS_SLsBudgetedLaborHours(JobRec);
                                "Sub-LevelsPrice" := JobRec."SLsUsage(Price)"(JobRec);
                                TotalContract := JobRec."NS_Budgeted Price (LCY)" + "Sub-LevelsPrice";
                                TotalBudgetedCost := JobRec."NS_Budgeted Cost (LCY)" + "Sub-LevelsCost";
                                if JobRec."NS_Actual Percent Complete" > 0 then
                                    ProjectedCost := JobRec."NS_Actual Percent Complete"
                                else begin
                                    if JobRec."NS_Budgeted Cost (LCY)" + "Sub-LevelsCost" <> 0 then
                                        CalcPctComplete := ROUND((ActualCostToDate[3] / (JobRec."NS_Budgeted Cost (LCY)" + "Sub-LevelsCost")), 0.0001)
                                    else
                                        CalcPctComplete := 0;
                                    ProjectedCost := CalcPctComplete * 100;
                                end;
                                if ProjectedCost <> 0 then
                                    ProjectedCost := ActualCostToDate[3] / (ProjectedCost / 100);
                                if (TotalContract - TotalBudgetedCost) > (TotalContract - ProjectedCost) then
                                    JobRec.MARK(true);
                            until JobRec.NEXT() = 0;
                        JobRec.MARKEDONLY(true);
                        PAGE.RUN(PAGE::"Job List", JobRec);
                    end;
                }
                field("Job Cost Exceeds Cont Billings"; Rec."NS_Job CostExceedsContBillings")
                {
                    ApplicationArea = All;
                    Caption = 'Job Cost Exceeds Contract Billings';
                    DrillDownPageID = "Job List";

                    trigger OnDrillDown();
                    begin
                        JobRec.RESET();
                        JobRec.CLEARMARKS();
                        JobRec.SETRANGE("NS_Manager Job Status", JobRec."NS_Manager Job Status"::Running);
                        if JobRec.FINDSET() then
                            repeat
                                JobCalc.NS_CalculateActualCostToDate(JobRec, ActualCostToDate, true);
                                JobCalc.CalculateInvoiceBilled(JobRec, InvoiceBilled, true);
                                if ActualCostToDate[3] > InvoiceBilled[3] then
                                    JobRec.MARK(true);
                            until JobRec.NEXT() = 0;
                        JobRec.MARKEDONLY(true);
                        PAGE.RUN(PAGE::"Job List", JobRec);
                    end;
                }

                actions
                {
                    action("Gross Profit by APO")
                    {
                        ApplicationArea = All;
                        Caption = 'Gross Profit by APO';
                        RunObject = Report "NS_Gross Profit by APO";
                    }
                    action("Actual vs Budget Cost by APO")
                    {
                        ApplicationArea = All;
                        Caption = 'Actual vs Budget Cost by APO';
                        RunObject = Report "NS_ActualvsBudget Cost by APO";
                    }
                    action("Actual vs Budget Price by APO")
                    {
                        ApplicationArea = All;
                        Caption = 'Actual vs Budget Price by APO';
                        RunObject = Report "NS_Actual vs Budget PricebyAPO";
                    }
                }
            }
            cuegroup("Subcontract/Supply")
            {
                Caption = 'Subcontract/Supply';
                Visible = true;
                field(OpenSubcontracts; OpenSubcontracts)
                {
                    ApplicationArea = All;
                    Caption = 'Open Subcontracts';
                    DrillDown = true;
                    // DrillDownPageID = "NS_Subcontract List";//PRJ-476.AS.1.0 15JAN 2021 Comment

                    trigger OnDrillDown();
                    VAR//PRJ-476.AS.1.0 15JAN 2021 Added
                        SubContRec: Record NS_Subcontract;//PRJ-476.AS.1.0 15JAN 2021 Added
                    begin
                        //PAGE.RUN(PAGE::"NS_Subcontract List");//PRJ-476.AS.1.0 15JAN 2021 Comment
                        //PRJ-476.AS.1.0 15JAN 2021 - start
                        SubContRec.Reset();
                        SubContRec.SetRange(NS_Status, SubContRec.NS_Status::Order);
                        PAGE.RUN(PAGE::"NS_Subcontract List", SubContRec);
                        //PRJ-476.AS.1.0 15JAN 2021 - end
                    end;
                }
                field(ExpiringInsurance; ExpiringInsurance)
                {
                    ApplicationArea = All;
                    Caption = 'Expiring Insurance - 30 Day';
                    DrillDown = true;
                    //   DrillDownPageID = "NS_Vendor Insurances";//PRJ-477.AS.1.0 18JAN 2021 Comment

                    trigger OnDrillDown();
                    var//PRJ-477.AS.1.0 18JAN 2021 Added
                        VendInsurRec: Record "NS_Vendor Insurance";//PRJ-477.AS.1.0 18JAN 2021 Added
                    begin
                        //PAGE.RUN(PAGE::"NS_Vendor Insurances");//PRJ-477.AS.1.0 18JAN 2021 Comment
                        //PRJ-477.AS.1.0 18JAN 2021 -start
                        VendInsurRec.Reset;
                        //VendInsurRec.SetFilter("NS_Expiration Date", '%1..%2', Today, TODAY + 30);//PRJ-477.AS.1.0 08DEC2021 Comment
                        VendInsurRec.SetFilter("NS_Expiration Date", '<=%1', TODAY + 30);//PRJ-477.AS.1.0 08DEC2021
                        PAGE.RUN(PAGE::"NS_Vendor Insurances", VendInsurRec);
                        //PRJ-477.AS.1.0 18JAN 2021 -end
                    end;
                }
                field("Open Job Purchase Orders"; Rec."NS_Open Job Purchase Orders")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Job List";
                    Visible = true;

                    trigger OnDrillDown();
                    begin
                        PurchaseHeader.RESET();
                        PurchaseHeader.SETRANGE(Status, PurchaseHeader.Status::Open);
                        PurchaseHeader.SETFILTER("NS_Job No.", '<>%1', '');
                        PAGE.RUN(PAGE::"Purchase List", PurchaseHeader);
                    end;
                }

                actions
                {
                    action("Purchase Order Status by Job")
                    {
                        ApplicationArea = All;
                        Caption = 'Purchase Order Status by Job';
                        RunObject = Report "NS_Purch Order Status by Job";
                    }
                    action("<Report Aged Accounts Payable")
                    {
                        ApplicationArea = All;
                        Caption = 'Aged A/P with Retention';
                        RunObject = Report "NS_Aged Accounts Payable Ret";
                    }
                }
            }
            //PE-168.HS.1.0 18Nov2023 Start
            cuegroup("NS_DailyJobLog")
            {
                Caption = 'Job Daily Log';
                Visible = true;
                field(NS_DailyJobLogs; NS_DailyJobLogs)
                {
                    ApplicationArea = all;
                    Caption = 'Job Daily Log List';
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        NS_DailyJobLg: Record "NS_Daily Job Log";
                    begin
                        NS_DailyJobLg.Reset();
                        NS_DailyJobLg.SetRange(Status, NS_DailyJobLg.Status::Open);
                        page.Run(page::"NS_Daily Job Log List", NS_DailyJobLg);
                    end;
                }
            }
            //PE-168.HS.1.0 18Nov2023 End
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        "NS_Job CostExceedsContBillings" := 0;
        "NS_Job Profit below Estimate" := 0;
        "NS_Retention Invoices Due" := 0;

        JobCalc.RESET();
        JobCalc.SETCURRENTKEY("NS_Manager Job Status");
        JobCalc.SETRANGE("NS_Manager Job Status", JobCalc."NS_Manager Job Status"::Running);
        if JobCalc.FINDSET() then
            repeat
                //Calulate Job Cost Exceeds Contract Billings
                JobCalc.NS_CalculateActualCostToDate(JobCalc, ActualCostToDate, true);
                JobCalc.CalculateInvoiceBilled(JobCalc, InvoiceBilled, true);
                if ActualCostToDate[3] > InvoiceBilled[3] then
                    "NS_Job CostExceedsContBillings" += 1;

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
                    "NS_Job Profit below Estimate" += 1;
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
                            "NS_Retention Invoices Due" += 1;
                    end;
            until CustLedgEntry.NEXT() = 0;

        //Calculate open subcontract
        OpenSubcontracts := 0;
        Subcontract.RESET();
        if Subcontract.FIND('-') then
            repeat
                //if Subcontract.NS_Status <> 3 then //PRJ-476.AS.1.0 15JAN 2021 Comment
                if Subcontract.NS_Status = Subcontract.NS_Status::Order then//PRJ-476.AS.1.0 15JAN 2021 Added
                    OpenSubcontracts += 1;
            until Subcontract.NEXT() = 0;

        //Calculate Expired Vendor Insurance        
        ExpiringInsurance := 0;
        VendorInsurance.RESET();
        //VendorInsurance.SetFilter("NS_Expiration Date", '%1..%2', Today, TODAY + 30);//PRJ-477.AS.1.0 08DEC2021 Comment
        VendorInsurance.SetFilter("NS_Expiration Date", '<=%1', TODAY + 30);//PRJ-477.AS.1.0 08DEC2021
        if VendorInsurance.FIND('-') then
            repeat
                // if VendorInsurance."NS_Expiration Date" < (TODAY + 30) then PRJ-477.AS.1.0
                ExpiringInsurance += 1;
            until VendorInsurance.NEXT() = 0;

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
        //PRJCTPR-147.NK.1.0 start 09Aug2023
        NS_Jobs.RESET();
        NS_Jobs.SETRANGE(Status, NS_Jobs.Status::Open);
        NS_Jobs.SETRANGE("NS_Job Class", NS_Jobs."NS_Job Class"::"Change Request");
        if NS_Jobs.FindSet() then begin
            Rec.OpenChangeRequest := NS_Jobs.Count;
        end;
        //PRJCTPR-147.NK.1.0  end 09aug2023

        //PE-168.HS.1.0 18Nov2023 Start
        NS_DailyJobLogs := 0;
        NS_DailyJobLog.Reset();
        NS_DailyJobLog.SetRange(Status, NS_DailyJobLog.Status::Open);
        if NS_DailyJobLog.FindSet() then
            NS_DailyJobLogs := NS_DailyJobLog.Count;
        //PE-168.HS.1.0 18Nov2023 End
    end;

    trigger OnOpenPage();
    var
        NSConfPersonalizationMgt: Codeunit "Conf./Personalization Mgt.";//PRJ-1686.GK.4.0 18Dec2022
    begin
        NSConfPersonalizationMgt.RaiseOnOpenRoleCenterEvent();//PRJ-1686.GK.4.0 18Dec2022
        RESET();
        if not GET() then begin
            INIT();
            INSERT();
        end;

        //Rec.SETFILTER("NS_Date Filter", '%1..%2', 19000101D, CALCDATE('CM')); //PRJ-1131.NK.1.0  //PRJCTPR-36.SD.1.0 line commented
        Rec.SETFILTER("NS_Date Filter", '%1..%2', 19000101D, CALCDATE('<CM>')); //PRJ-1131.NK.1.0  //PRJCTPR-36.SD.1.0 line addeds
        Rec.SETFILTER("NS_Date Filter2", '<%1', WORKDATE); //PRJ-1131.NK.1.0
        JobsSetup.GET();
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
        NS_Jobs: Record Job;//PRJCTPR-147.NK.1.0 09Aug2023
        OpenSubcontracts: Integer;

        ExpiringInsurance: Integer;

        Backlog: Decimal;
        NS_DailyJobLogs: Integer;  //PE-168.HS.1.0 18Nov2023
        NS_DailyJobLog: Record "NS_Daily Job Log";  //PE-168.HS.1.0 18Nov2023
}

