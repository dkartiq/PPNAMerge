page 14021187 "NS_Job Forecast Worksheet"
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
    //PRJ-436.AS.1.0 15JAN2021 Taken code reference from //GLEI-33 VT 01-04-20 -- Field Added 
    //PRJ-285.MS.1.0 added new field amount rec. not inv.
    //PRJ-301.AS.1.0 - Increased length
    //JD-48.AS.1.0 Added code
    //CTSI-94.ms.1.0 added new action
    //CTSI-95.ms.1.0 added new action and code
    //CTSI-94.AS.1.0 10AUG2020 Changed caption of Completion list page and Added code
    //CTSI-121.N.S.1.0 Add field manager & person responsible  
    //CTSI-115.AS.1.0 Changed action name
    //CTSI-152.AS.1.0 14Sept2020 Added validation in Post button 
    //PRJ-350.MS.1.0 added code for update estimated code when open forecast and action
    //PRJ-457.MS.1.0 add permission for posting forecast
    //CTSI-192.MS.1.0 new changes for view open task only
    //CTSI-198.MS.1.0 editable fields
    //PRJ-457.MS.1.0 add permission for posting forecast
    //CTSI-228.MS.1.0 New percent completed field change to editable
    //CTSI.231.MS.1.0  New changes for est. cost field cal. on the basis of Hr. to Fins.
    //CTSI.232.MS.1.0  New changes for skip complete task when post.
    //TM-21.MS.1.0 addedd new functionality of 100% completed view
    //PRJ-527.MS.1.0  new changes for issue of become clear est. cost field when no values  
    //PRJ-565/ctsi-239.MS.1.0 new changes for hourse to finish when open forecast page //revert
    Caption = 'Job Forecast Worksheet';
    DataCaptionFields = "NS_Job No.";
    PageType = Worksheet;
    SourceTable = "NS_Job Forecast";
    SourceTableView = SORTING("NS_Job No.", "NS_Job Task No.", "NS_Status Date", NS_Posted)
                      ORDER(Ascending)
                      WHERE(NS_Posted = CONST(false));
    Permissions = tabledata 167 = rimd; //PRJ-457.MS.1.0   

    layout
    {
        area(content)
        {
            group(Control1100773004)
            {
                Caption = '';//PRJ-144 VT 11-03-20
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
                            JobDescription := '';
                            if Job."No." > '' then begin
                                if Job.GET(Job."No.") then begin
                                    CurrentJobNo := Job."No.";
                                    JobDescription := Job.Description;
                                end;
                            end;
                        end;
                        NS_ListUpdate;
                    end;

                    trigger OnValidate();
                    begin
                        JobDescription := '';
                        if Job.GET(CurrentJobNo) then begin
                            JobDescription := Job.Description;
                            CurrPage.SAVERECORD;
                        end;
                        NS_ListUpdate;
                    end;
                }
                field(JobDescription; JobDescription)
                {
                    Caption = 'Job Description';//PRJ-144 VT 17-03-20
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Job description';
                }
            }
            group(Control1100773006)
            {
                Caption = ''; //PRJ-144 VT 11-03-20
                field(Manager; CurrentTaskManager)
                {
                    ApplicationArea = All;
                    Caption = 'Manager:';
                    TableRelation = Resource."No." WHERE(Type = CONST(Person));

                    trigger OnLookup(VAR Text: Text): Boolean;
                    begin
                        CurrPage.SAVERECORD;
                        COMMIT;
                        Resource.SETRANGE(Type, Resource.Type::Person);
                        Resource."No." := CurrentTaskManager;
                        if PAGE.RUNMODAL(0, Resource) = ACTION::LookupOK then begin
                            TaskManagerName := '';
                            if Resource."No." > '' then begin
                                if Resource.GET(Resource."No.") then begin
                                    CurrentTaskManager := Resource."No.";
                                    TaskManagerName := Resource.Name;
                                end;
                            end;
                        end;
                        NS_ListUpdate;
                    end;

                    trigger OnValidate();
                    begin
                        TaskManagerName := '';
                        if Resource.GET(CurrentTaskManager) then begin
                            TaskManagerName := Resource.Name;
                            CurrPage.SAVERECORD;
                        end;
                        NS_ListUpdate;
                    end;
                }
                field(TaskManagerName; TaskManagerName)
                {
                    ApplicationArea = All;
                    Caption = 'Task Manager Name';//PRJ-144 VT 17-03-20
                    Editable = false;
                    ToolTip = 'Specifies the task manager name';
                }
            }
            group(Control1100773039)
            {
                Caption = '';//PRJ-144 VT 11-03-20
                field(AsOfDateFilter; AsOfDateFilter)
                {
                    ApplicationArea = All;
                    Caption = 'As of Date Filter:';
                    ToolTip = 'Specifies the As of Date Filter:';

                    trigger OnValidate();
                    var
                        Jobsetup: Record "Jobs Setup";//CTSI-268 
                        UserSeup: Record "User Setup";//CTSI-268
                    begin
                        //CTSI-268 start
                        if UserSeup.get(UserId) then;
                        if Jobsetup.get then;
                        if not UserSeup."NS_Overwrite JFW Date Setup" then begin
                            if Jobsetup."NS_Allow Posting Date on JFW As of Date Filter" <> 0D then
                                if AsOfDateFilter <> 0D then
                                    if AsOfDateFilter <> Jobsetup."NS_Allow Posting Date on JFW As of Date Filter" then
                                        Error('The As of Date is not within your range of allowed dates. You can only enter date %1 as per jobs setup', Jobsetup."NS_Allow Posting Date on JFW As of Date Filter");
                        end;
                        //CTSI-268 end
                        if AsOfDateFilter <> 0D then begin
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
                        //PRJ-565 start
                        //CalCulateHoursToFinish;
                        //ForecastedCompletedCostOnAfter;
                        //SetBillDate;
                        // SetStatusDate;
                        //PRJ-565
                    end;
                }
                field(NextBilliDate; NextBillDate)
                {
                    ApplicationArea = All;
                    Caption = 'Next Bill Date:';
                    ToolTip = 'Specifies the Next Bill Date:';

                    trigger OnValidate();
                    begin
                        NS_ListUpdate;
                    end;
                }
                field(ViewOpenTaskonly; ViewOpenTaskonly)
                {
                    ApplicationArea = All;
                    Caption = 'View Open Task Only';
                    Description = 'CTSI-192.MS.1.0';
                    ToolTip = 'Specifies the ViewOpenTaskonly';
                    trigger OnValidate()
                    begin
                        NS_ListUpdate;
                    end;
                }
                field(View100Pctcompltdonly; View100Pctcompltdonly)
                {
                    ApplicationArea = All;
                    Caption = 'Hide 100% Completed Tasks';
                    Description = 'TM-21.MS.1.0';
                    ToolTip = 'Specifies the View100Pctcompltdonly';
                    trigger OnValidate()
                    begin
                        NS_ListUpdate();
                    end;
                }
            }
            repeater(CSWorkSheet)
            {
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Job No.';
                }
                field("Job Task No."; Rec."NS_Job Task No.")
                {
                    ApplicationArea = All;
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
                field(Complete; NS_Complete)
                {
                    ApplicationArea = all;
                    Description = 'CTSI.232.MS.1.0';
                    //CTSI-232 New changes  //PRJ-565
                    trigger OnValidate()
                    begin
                        if AsOfDateFilter = 0D then
                            Error('Please enter "As of Date Filter".');//PRJ-565
                        if NS_Complete = true then begin
                            validate("NS_Hours To Finish", 0);
                            validate("NS_Cost To Complete", 0);
                            Validate("NS_Percent Complete", 100);
                            NS_PercentCompleteOnAfterValidate;//PRJ-565
                            NS_SetBillDate;
                            NS_SetStatusDate;
                        end;
                    end;
                    //CTSI-232 New changes
                }
                field(ManagerValue; ManagerValue)
                {
                    ApplicationArea = All;
                    Caption = 'Manager';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Manager';
                    Visible = false;
                }
                field(PersonResponsible; PersonResponsible)
                {
                    ApplicationArea = All;
                    Caption = 'Person Responsible';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Person Responsible';
                    Visible = false;
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

                //PRJ-436.AS.1.0 15JAN2021 begin
                field("Previous Manager Comment"; PreviousJobForecast."NS_Manager Comments")
                {
                    ApplicationArea = All;
                    Caption = 'Previous Manager Comment';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    //Style = Favorable;
                    //StyleExpr = TRUE;
                    ToolTip = 'Specifies the Previous Manager Comments';

                    trigger OnValidate();
                    begin
                        //NS_SetBillDate;
                    end;
                }
                //PRJ-436.AS.1.0 15JAN2021 end
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
                field("Status Date"; Rec."NS_Status Date")
                {
                    ApplicationArea = All;
                    Caption = 'New Status Date';
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the New Status Date';
                    Editable = false;//CTSI-198

                    trigger OnValidate();
                    begin
                        NS_StatusDateOnAfterValidate;
                        NS_SetBillDate;
                    end;
                }
                field("Units Complete"; Rec."NS_Units Complete")
                {
                    ApplicationArea = All;
                    Caption = 'New Total Units Complete';
                    ToolTip = 'Specifies the New Total Units Complete';
                    Editable = false;//CTSI-198

                    trigger OnValidate();
                    begin
                        // NS_UnitsCompleteOnAfterValidate;//PRJ-527
                        NS_SetBillDate;
                        NS_SetStatusDate;
                    end;
                }
                field("Percent Complete"; Rec."NS_Percent Complete")
                {
                    ApplicationArea = All;
                    Caption = 'New Total Percent Complete';
                    MaxValue = 100;
                    MinValue = 0;
                    ToolTip = 'Specifies the New Total Percent Complete';
                    Editable = true;//CTSI-198//CTSI-228 changes false to true

                    trigger OnValidate();
                    begin
                        TestField(NS_Complete, false);//PRj-565
                        if AsOfDateFilter = 0D then
                            Error('Please enter "As of Date Filter".');//PRJ-565
                        NS_PercentCompleteOnAfterValidate;
                        NS_SetBillDate;
                        NS_SetStatusDate;
                    end;
                }
                field("Cost To Complete"; Rec."NS_Cost To Complete")
                {
                    ApplicationArea = All;
                    Caption = 'Estimated Cost To Complete';
                    ToolTip = 'Specifies the Estimated Cost To Complete';

                    trigger OnValidate();
                    begin
                        TestField(NS_Complete, false);//PRj-565
                        if AsOfDateFilter = 0D then
                            Error('Please enter "As of Date Filter".');//PRJ-565
                        NS_CostToCompleteOnAfterValidate;
                        NS_SetBillDate;
                        NS_SetStatusDate;
                    end;
                }
                field("Forecasted Completed Cost"; Rec."NS_Forecasted Completed Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Forecasted Completed Cost';
                    Editable = false;//CTSI-198  

                    trigger OnValidate();
                    begin
                        NS_ForecastedCompletedCostOnAfter;
                        NS_SetBillDate;
                        NS_SetStatusDate;
                    end;
                }
                field("Hours To Finish"; Rec."NS_Hours To Finish")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Hours To Finish';

                    trigger OnValidate();
                    begin
                        TestField(NS_Complete, false);//PRj-565
                        if AsOfDateFilter = 0D then
                            Error('Please enter "As of Date Filter".');//PRJ-565

                        NS_HoursToFinishOnAfterValidate;
                        NS_SetBillDate;
                        NS_SetStatusDate;
                        NS_PercentCompleteOnAfterValidate; //CTSI-21.MS.1.0
                        NS_CostToCompleteOnAfterValidate;//prj-565

                    end;
                }
                field(ForecastedVariance; ForecastedVariance)
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Forecasted Variance';
                    Editable = false;
                    ToolTip = 'Specifies the Forecasted Variance';
                }
                field("Calc Expected Receipt Costs"; Rec."NS_Calc Expected Receipt Costs")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Calc Expected Receipt Costs';
                    Visible = false;
                    Editable = false;//CTSI-198
                }
                field(POExpectedReceiptCost; Rec."NS_PO Expected Receipt Cost")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'PO Expected Receipt Cost';
                    Style = Favorable;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the PO Expected Receipt Cost';
                    Editable = false;//CTSI-198

                    trigger OnValidate();
                    begin
                        NS_SetBillDate;
                        if TotalBudget <> 0 then begin
                            "NS_Bill Percent" := ROUND(((TotalCostsUsed + "NS_PO Expected Receipt Cost") / TotalBudget) * 100, GLSetup."Amount Rounding Precision");
                            if "NS_Bill Percent" > 100 then
                                "NS_Bill Percent" := 100;
                        end else
                            "NS_Bill Percent" := 100;
                    end;
                }
                field("Outstanding Orders"; JobTask."Outstanding Orders")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the number of outstanding orders for the job task';

                    trigger OnDrillDown();
                    var
                        PurchLine: Record "Purchase Line";
                    begin
                        NS_SetPurchLineFilters(PurchLine);
                        PurchLine.SETFILTER("Outstanding Amount (LCY)", '<> 0');
                        PAGE.RUNMODAL(PAGE::"Purchase Lines", PurchLine);
                    end;
                }
                //PRJ-285.MS.1.0 start comment
                // field("Amt. Rcd. Not Invoiced"; JobTask."Amt. Rcd. Not Invoiced")
                // {
                //     ApplicationArea = All;
                //     Visible = False; //PRJ-285.MS.1.0 
                //     Editable = false;
                //     Style = StandardAccent;
                //     StyleExpr = TRUE;
                //     ToolTip = 'Specifies the amount received but not invoiced for the job task';

                //    trigger OnDrillDown();
                //    var
                //        PurchLine: Record "Purchase Line";
                //    begin
                //        SetPurchLineFilters(PurchLine);
                //        PurchLine.SETFILTER("Amt. Rcd. Not Invoiced (LCY)", '<> 0');
                //        PAGE.RUNMODAL(PAGE::"Purchase Lines", PurchLine);
                //    end;
                //}
                //PRJ-285.MS.1.0 end comment
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
                field("Bill Date"; Rec."NS_Bill Date")
                {
                    ApplicationArea = All;
                    Style = Favorable;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Bill Date';
                    Editable = false;//CTSI-198
                }
                field("Bill Percent"; Rec."NS_Bill Percent")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Style = Favorable;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Bill Percent';
                    Editable = false;//CTSI-198

                    trigger OnValidate();
                    begin
                        NS_SetBillDate;
                    end;
                }
                field("Budgeted Hours"; "Budgeted Hours")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    trigger
                    OnValidate()
                    begin
                        if AsOfDateFilter > 0D then
                            "NS_date filter" := AsOfDateFilter;
                    end;

                }
                field("Actual Hours"; jobledEntry.Quantity)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    Description = 'CTSI.21.MS.1.0';
                }
                field("Remaining Hours"; "NS_Remaining Hours")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    Description = 'CTSI.21.MS.1.0';
                }
                field("Budgeted Hrs Percent Compelete"; "NS_Budgeted Hrs Percent Compelete")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    Description = 'CTSI.21.MS.1.0';
                }
                field(LaborRate; LaborRate)
                {
                    Caption = 'Labor Rate';
                    ApplicationArea = all;
                    Editable = false;
                    Description = 'CTSI-95.MS.1.0';
                    Visible = true;
                }

            }
            // part(JobCalendarEntries; "Job Forecast Summary")
            // {
            //     ApplicationArea = All;
            // }
            group(Total)
            {
                Caption = '';
                Editable = false;
                Description = 'PRJ-537.MS.1.0';
                field(BugdCostTotal; SumofTotalBudget)
                {
                    Caption = 'Budgeted Costs';
                    Visible = true;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;//additional
                }
                field(CostUsedTotal; SumOfTotalCostsUsed)
                {
                    Caption = 'Total Cost Used';
                    Visible = true;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;//additional
                }
                field(BugdRemaTotal; SumofBudgetRemaining)
                {
                    Caption = 'Budget Remaining';
                    Visible = true;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;//additional
                }
                field(EstCosttocompTotal; "NS_Total Est. cost to Complete")
                {
                    Caption = 'Estimated Cost to Complete';
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;//additional
                }
                field(ForeCompcostTotal; "NS_Total Forecast Completed Cost")
                {
                    Caption = 'Forecasted Completed Cost';
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;//additional
                }
                field(ForeVariTotal; SumofForecastedVariance)
                {
                    Caption = 'Forecasted Variance';
                    Visible = true;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;//additional
                }
                //PRJ-436.AS.1.0 15JAN2021 begin
                field("Manager Comment"; Rec."NS_Manager Comments")
                {
                    ApplicationArea = All;
                    //Style = Favorable;
                    //StyleExpr = TRUE;
                    ToolTip = 'Specifies the Manager Comments';

                    trigger OnValidate();
                    begin
                        NS_SetBillDate();
                        NS_SetStatusDate();
                    end;
                }
                //PRJ-436.AS.1.0 15JAN2021 end
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ShowStatistics)
            {
                ApplicationArea = All;
                Caption = 'Statistics';
                Image = Statistics;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'F11';
                ToolTip = 'Show statistics';

                trigger OnAction();
                begin
                    if CurrentJobNo > '' then begin
                        if AsOfDateFilter > 0D then begin
                            JobForecastSummary.NS_Set(CurrentJobNo, AsOfDateFilter);
                            JobForecastSummary.SETRECORD(Job);
                            JobForecastSummary.RUNMODAL;
                            CLEAR(JobForecastSummary);
                        end else
                            ERROR(Text003);
                    end;
                end;
            }
            //CTSI-269 start
            action(NS_PMStatistics)
            {
                ApplicationArea = All;
                Caption = 'PM Statistics';
                Image = Statistics;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'F10';
                ToolTip = 'PM Statistics';

                trigger OnAction();
                begin
                    if CurrentJobNo > '' then begin
                        if AsOfDateFilter > 0D then begin
                            PMStatistic.Set(CurrentJobNo, AsOfDateFilter, NextBillDate);
                            PMStatistic.SETRECORD(Job);
                            PMStatistic.RUNMODAL;
                            CLEAR(PMStatistic);
                        end else
                            ERROR(Text003);
                    end;
                end;
            }
            // //CTSI-269 end
            // //CTSI-270 start
            action(NS_PMComments)
            {
                ApplicationArea = All;
                Caption = 'PM Comments';
                Image = Comment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                // RunObject = page "Comment Sheet";
                // RunPageLink = "Table Name" = const(Job),
                //                 "No." = field("Job No.");
                trigger OnAction()
                var
                    CommentLine: Record "Comment Line";
                    PageCommentSheet: Page "Comment Sheet";
                    ParatemeterForEvents14021100: Codeunit "NS_Parameters for Events";
                    CommentLine2: Record "Comment Line";
                begin
                    if CurrentJobNo > '' then begin
                        if AsOfDateFilter > 0D then begin
                            PageCommentSheet.NS_SetAsofDate(AsOfDateFilter, "NS_Job No.");
                            CommentLine.Reset();
                            CommentLine.setfilter("Table Name", '%1', CommentLine."Table Name"::Job);
                            CommentLine.SetRange("No.", "NS_Job No.");
                            CommentLine.SetRange(Date, AsOfDateFilter);
                            if CommentLine.Findset() then begin
                                PageCommentSheet.SetTableView(CommentLine);
                                PageCommentSheet.SetRecord(CommentLine);
                                PageCommentSheet.RunModal();
                            end else begin
                                CommentLine2.Reset();
                                CommentLine2.setfilter("Table Name", '%1', CommentLine2."Table Name"::Job);
                                CommentLine2.SetRange("No.", "NS_Job No.");
                                if CommentLine2.FindLast() then;
                                CommentLine.Init();
                                CommentLine."Table Name" := CommentLine."Table Name"::Job;
                                CommentLine."No." := "NS_Job No.";
                                CommentLine."Line No." := CommentLine2."Line No." + 10000;
                                CommentLine.Date := AsOfDateFilter;
                                CommentLine.Insert();
                                Commit();
                                CommentLine2.Reset();
                                CommentLine2.setfilter("Table Name", '%1', CommentLine2."Table Name"::Job);
                                CommentLine2.SetRange("No.", "NS_Job No.");
                                CommentLine2.SetRange(Date, AsOfDateFilter);
                                if CommentLine2.FindSet() then begin
                                    PageCommentSheet.SetTableView(CommentLine2);
                                    PageCommentSheet.SetRecord(CommentLine2);
                                    PageCommentSheet.RunModal();
                                end;
                            end;
                            Clear(PageCommentSheet);

                        end else
                            ERROR(Text003);
                    end;
                end;

            }
            //CTSI- 270 end

            action(Print)
            {
                ApplicationArea = All;
                Caption = 'Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Print the job forecast worksheet.';

                trigger OnAction();
                var
                    ReportJobForecast: Record "NS_Job Forecast";
                begin
                    if CurrentJobNo > '' then begin
                        if AsOfDateFilter > 0D then begin
                            JobForecastWorksheetReport.Set(CurrentJobNo, AsOfDateFilter);
                            JobForecastWorksheetReport.RUNMODAL();
                            CLEAR(JobForecastWorksheetReport);
                        end else
                            //AsOfDateFilter := WORKDATE;
                            ERROR(Text003);
                    end;
                end;
            }
            action(TestPrint)
            {
                ApplicationArea = All;
                Caption = '% Test Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                Description = 'CTSI-94.ms.1.0';
                Visible = false;
                trigger OnAction();
                var
                    ReportJobForecast: Record "NS_Job Forecast";
                    JobForecastWorksheetReport: Report "NS_Percentage of Compl.";
                begin
                    if CurrentJobNo > '' then begin
                        if AsOfDateFilter > 0D then begin
                            JobForecastWorksheetReport.Set(CurrentJobNo, AsOfDateFilter);
                            JobForecastWorksheetReport.RUNMODAL();
                            CLEAR(JobForecastWorksheetReport);
                        end else
                            //AsOfDateFilter := WORKDATE;
                            ERROR(Text003);
                    end;
                end;
            }
            action(Pertageofcomp)
            {
                ApplicationArea = All;
                Caption = 'Project Summary Details';//CTSI-94.AS.1.0 10AUG2020 //CTSI-115.AS.1.0
                Image = ListPage;
                Promoted = true;
                Visible = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Description = 'CTSI-94.ms.1.0';
                //RunObject = Page "Percentage of Completion;
                //RunPageLink = "Job No." = FIELD(job n)
                trigger OnAction()
                var
                    PrctOfComp: Record "NS_Percentage of Completion";
                    JobText: Text;
                    FindPoint: Integer;
                begin
                    JobText := '';
                    FindPoint := 0;
                    FindPoint := StrPos(Rec."NS_Job No.", '.');
                    if FindPoint > 1 then
                        JobText := CopyStr(Rec."NS_Job No.", 1, FindPoint - 1)
                    else
                        JobText := Rec."NS_Job No.";
                    PrctOfComp.Reset();
                    PrctOfComp.SetFilter("NS_Job No.", '%1', Rec."NS_Job No." + '*');
                    Page.RunModal(Page::"NS_Percentage of Completion", PrctOfComp); //PRJ-350
                    //Page.Run(14021458);
                end;

            }
            action(PerofcomReport)
            {
                ApplicationArea = All;
                Caption = 'Project Profit Analysis Report';//CTSI-94.AS.1.0 10AUG2020
                Image = Print;
                Promoted = true;
                Visible = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Description = 'CTSI-94.ms.1.0';

                //CTSI-94.AS.1.0 10AUG2020 - start
                trigger OnAction();
                var
                    JobTable: Record Job;
                begin
                    JobTable.reset;
                    JobTable.SETRANGE("No.", rec."NS_Job No.");
                    REPORT.RUNMODAL(REPORT::"NS_Percentage of CompletionNew", true, false, JobTable);
                end;
                //CTSI-94.AS.1.0 10AUG2020 - end
            }
            action(Post)
            {
                ApplicationArea = All;
                Caption = 'Post';
                Ellipsis = true;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Post the job forecast worksheet.';

                trigger OnAction();
                var//CTSI-152.AS.1.0 14Sept2020 Added code
                    jobtable: Record Job;//CTSI-152.AS.1.0 14Sept2020 Added code
                    JobRecSub: Record Job;
                    JobsetupRec: Record "Jobs Setup";
                    ForecastPage: page "NS_Job Forecast Worksheet";
                    UpdateSummDetJFW: Report "NS_UpdateRecRevSummDetailJFW";
                    JobRec: Record job;
                    MasterJob: Record Job;
                begin
                    JobsetupRec.get;
                    if JobRec.get(CurrentJobNo) then;
                    //CTSI-285.MS.1.0 start
                    if JobRec."NS_Sub-Level to Job No." = '' then begin
                        if JobRec."NS_Revenue Recognized" then
                            Error('Revenue has already been recognized for this job. No further forecasting can be done for it.');
                    end else begin
                        if MasterJob.get(JobRec."NS_Sub-Level to Job No.") then;
                        if MasterJob."NS_Revenue Recognized" then begin
                            Error('Revenue has already been recognized for its master job %1. No further forecasting can be done for it.', MasterJob."No.");
                        end;
                    end;
                    //CTSI-285.MS.1.0 end
                    //CTSI-284.MS.1.0 start
                    if (JobRec."NS_Actual Percent Complete" = 100) and (JobRec."NS_Actual PercentCompleteDate" <> 0D) then
                        Error('The job has already been set to 100%, so you are not allowed to post the forecast for this job.');
                    //CTSI-284.MS.1.0 end
                    //CTSI-152.AS.1.0 14Sept2020 - start
                    if jobtable.get(CurrentJobNo) then begin
                        if jobtable."NS_Exclude from Job Forecast" = true then
                            Error('This Job has been excluded from Job Forecast.To post, remove the checkmark from Job Forecast');
                    end;
                    //CTSI-152.AS.1.0 14Sept2020 - end
                    if CONFIRM(Text005, true) then begin //CTSI-274/PRJ-658 
                        NS_PostLines(CurrentJobNo, AsOfDateFilter, NextBillDate);
                        //CTSI-274
                        UpdateSummDetJFW.SetJobNo(CurrentJobNo, AsOfDateFilter);
                        UpdateSummDetJFW.Run();
                        // //CTSI-274
                    END else begin  //CTSI-274/PRJ-658 
                        exit;
                    end;
                end;
            }
            action(ProjectionList)
            {
                ApplicationArea = All;
                Caption = 'Projection List';
                Image = ListPage;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "NS_Job Forecast Projections";
                RunPageLink = "NS_Job No." = FIELD("NS_Job No."),
                              "NS_Job Task No." = FIELD("NS_Job Task No.");
                ToolTip = 'View the projection list.';
            }
            action(GetProjections)
            {
                ApplicationArea = All;
                Caption = 'Get Projections';
                Image = Suggest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    ForecastRecs: Record "NS_Job Forecast";
                begin
                    ForecastRecs.RESET();
                    if CurrentJobNo > '' then
                        ForecastRecs.SETRANGE("NS_Job No.", CurrentJobNo);
                    if CurrentTaskManager > '' then
                        ForecastRecs.SETRANGE("NS_Task Manager", CurrentTaskManager);
                    LoadProjections.SETTABLEVIEW(ForecastRecs);
                    LoadProjections.Set(NextBillDate);
                    LoadProjections.RUNMODAL();
                    CLEAR(LoadProjections);
                end;
            }
            action(CalcExpectedReceiptCosts)
            {
                ApplicationArea = All;
                Caption = 'Calc Expected Receipt Costs';
                Image = CalculateLines;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Calculate the Expected Receipt Costs';

                trigger OnAction();
                var
                    JobForecastLines: Record "NS_Job Forecast";
                begin
                    if (CurrentJobNo > '') and (NextBillDate > 0D) then begin
                        with JobForecastLines do begin
                            RESET;
                            SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", NS_Posted);
                            SETRANGE("NS_Job No.", CurrentJobNo);
                            SETRANGE(NS_Posted, false);
                            if FINDSET(true, false) then
                                repeat
                                    if "NS_Calc Expected Receipt Costs" then begin
                                        "NS_Bill Date" := 0D;
                                        "NS_Bill Percent" := 0;
                                        "NS_PO Expected Receipt Cost" := JobTask.NS_POsRecdAndOtstndngByExptRcptDate("NS_Job No.", "NS_Job Task No.", NextBillDate);
                                        if "NS_PO Expected Receipt Cost" > 0 then begin
                                            "NS_Bill Date" := NextBillDate;
                                            NS_GetJobPlanningLineAndBudget("NS_Job No.", "NS_Job Task No.", JobPlanningLineBudget, TotalTaskBudget, AsOfDateFilter);
                                            if TotalTaskBudget <> 0 then begin
                                                JobCostsUsed := 0;
                                                if Job.GET(Rec."NS_Job No.") then begin
                                                    Job.SETRANGE("NS_Job Task No. Filter", "NS_Job Task No.");
                                                    Job.SETFILTER("NS_Date Filter", '..%1', AsOfDateFilter);
                                                    Job.CALCFIELDS("NS_Usage (Cost) (LCY)");
                                                    JobCostsUsed := Job."NS_Usage (Cost) (LCY)";
                                                end;
                                                "NS_Bill Percent" := ROUND(((JobCostsUsed + "NS_PO Expected Receipt Cost") / TotalTaskBudget) * 100, 0.01);
                                                if "NS_Bill Percent" > 100 then
                                                    "NS_Bill Percent" := 100;
                                            end else
                                                "NS_Bill Percent" := 100;
                                        end else begin
                                            NS_GetJobPlanningLineAndBudget(Rec."NS_Job No.", "NS_Job Task No.", JobPlanningLineBudget, TotalBudget, AsOfDateFilter);
                                            TotalCostsUsed := 0;
                                            if Job.GET(Rec."NS_Job No.") then begin
                                                Job.SETRANGE("NS_Job Task No. Filter", "NS_Job Task No.");
                                                if NextBillDate > 0D then begin
                                                    if DATE2DMY(NextBillDate, 2) < 12 then
                                                        MonthEndDate := DMY2DATE(1, DATE2DMY(NextBillDate, 2) + 1, DATE2DMY(NextBillDate, 3)) - 1
                                                    else
                                                        MonthEndDate := DMY2DATE(31, 12, DATE2DMY(NextBillDate, 3));
                                                end;
                                                Job.SETFILTER("NS_Date Filter", '..%1', MonthEndDate);
                                                Job.CALCFIELDS("NS_Usage (Cost) (LCY)");
                                                TotalCostsUsed := Job."NS_Usage (Cost) (LCY)";
                                            end;
                                            BudgetRemaining := TotalBudget - TotalCostsUsed;
                                            // if BudgetRemaining <= 0 then
                                            //    BudgetRemaining := 0;
                                            BudgetPercentageUsed := NS_CalcPercentFrom0To100(TotalBudget, TotalCostsUsed);
                                            if BudgetPercentageUsed > 100 then
                                                BudgetPercentageUsed := 100;
                                            "NS_Bill Percent" := BudgetPercentageUsed;
                                            if "NS_Bill Percent" > 0 then
                                                "NS_Bill Date" := NextBillDate;
                                        end;
                                        MODIFY();
                                    end;
                                until NEXT() = 0;
                        end;
                    end else
                        ERROR(Text002);
                end;
            }
            action(CalcBillingAmount)
            {
                ApplicationArea = All;
                Caption = 'Calc Billing Amount';
                Image = CalculateLines;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Calculate the billing amount';

                trigger OnAction();
                begin
                    if (CurrentJobNo > '') and (NextBillDate > 0D) then begin
                        GetJobForecastRevenueTotal.NS_SetJobNo(CurrentJobNo, NextBillDate, MonthEndDate, AsOfDateFilter);
                        GetJobForecastRevenueTotal.RUNMODAL();
                        CLEAR(GetJobForecastRevenueTotal);
                    end else
                        ERROR(Text002);
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    var
        glsetup: Record "General Ledger Setup";
        FlagHrs: Integer;
        PoNo: Code[20];
        PPH: Record "Purch. Inv. Header";
    begin
        if NS_Posted = false then
            NS_FillInTable;
        if JobTask.GET(Rec."NS_Job No.", "NS_Job Task No.") then;
        JobTask.CALCFIELDS("Outstanding Orders", "Amt. Rcd. Not Invoiced");
        //CTSI-21.MS.1.0 start
        JobLedEntry.Reset();
        JobLedEntry.SetCurrentKey("Job No.", "Job Task No.", Type, "Entry Type", "Unit of Measure Code");
        JobLedEntry.SetRange("Job No.", "NS_Job No.");
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
        "NS_Remaining Hours" := "Budgeted Hours" - jobledEntry.Quantity;//"Actual Hours";
        if "NS_Remaining Hours" < 0 then //PRJ-565
            "NS_Remaining Hours" := 0;
        if "Budgeted Hours" <> 0 then
            "NS_Budgeted Hrs Percent Compelete" := round(jobledEntry.Quantity * 100 / "Budgeted Hours", glsetup."Amount Rounding Precision");
        //round("Actual Hours" * 100 / "Budgeted Hours", glsetup."Amount Rounding Precision");
        //CTSI-21.MS.1.001 end  
        //PRJ-285.MS.1.0 start
        if NS_Posted = false then begin
            AmtRcdNotInv := 0;
            AmtRcdNotInv1 := 0;
            AmtRcdNotInv2 := 0;
            PurRecpLine.reset;
            PurRecpLine.setrange("Job No.", "NS_Job No.");
            PurRecpLine.SetRange("Job Task No.", "NS_Job Task No.");
            //PurRecpLine.SetFilter(Type, '%1', PurRecpLine.Type::Item);//PRJ-MS
            if AsOfDateFilter <> 0D then
                PurRecpLine.SetRange("Posting Date", 0D, AsOfDateFilter);
            if PurRecpLine.FindFirst() then begin
                repeat
                    //AmtRcdNotInv1 := AmtRcdNotInv1 + PurRecpLine."Qty. Rcd. Not Invoiced" * PurRecpLine."Direct Unit Cost";
                    //AmtRcdNotInv2 := AmtRcdNotInv2 + PurRecpLine."Quantity Invoiced" * PurRecpLine."Direct Unit Cost";
                    AmtRcdNotInv1 := AmtRcdNotInv1 + (PurRecpLine.Quantity * PurRecpLine."Direct Unit Cost");//PRJ-MS
                until PurRecpLine.Next() = 0;
            end;
            InvAmt := 0;
            PurcInvLine.Reset();
            PurcInvLine.SetRange("Job No.", "NS_Job No.");
            PurcInvLine.SetRange("Job Task No.", "NS_Job Task No.");
            //PurcInvLine.SetFilter(Type, '%1', PurcInvLine.Type::Item);//PRJ-MS
            if AsOfDateFilter <> 0D then
                PurcInvLine.SetRange("Posting Date", 0D, AsOfDateFilter);
            if PurcInvLine.FindFirst() then
                repeat
                    if PPH.get(PurcInvLine."Document No.") then;
                    if PPH."Order No." <> '' then
                        InvAmt := InvAmt + (PurcInvLine.Quantity * PurcInvLine."Direct Unit Cost");//PRJ-MS
                until PurcInvLine.Next() = 0;

            AmtRcdNotInv := AmtRcdNotInv1 - InvAmt;//PRJ-MS    
                                                   //AmtRcdNotInv := AmtRcdNotInv1 + AmtRcdNotInv2 - InvAmt;

        end;
        //PRJ-285.MS.1.0 end 
        //CTSI-95.MS.1.0 start
        LaborRate := 0;
        if job.get("NS_Job No.") then;
        if jobsetup.Get() then;
        if DefDim.get('167', Job."No.", Jobsetup."NS_Dimension for Labor Rates") then begin
            LabrrateBytask.Reset();
            LabrrateBytask.SetRange("NS_Dimension code", DefDim."Dimension Code");
            LabrrateBytask.SetRange("NS_Dimension Value code", DefDim."Dimension Value Code");
            LabrrateBytask.SetRange("NS_Task Code", Rec."NS_Job Task No.");
            if LabrrateBytask.FindFirst() then
                LaborRate := LabrrateBytask."NS_Labor Rate";
        end;

        //CTSI.95.MS.1.0 end
        //NS_UnitsCompleteOnAfterValidate;//PRJ-350.MS.1.0//PRJ-527.MS.1.0
        //CTSI-192.MS.1.0 start
        if (TotalBudget <> 0) or (TotalCostsUsed <> 0) or ("NS_Cost To Complete" <> 0) then //CTSI-MS.1.0
            "NS_View Open Tasks Only" := true;

        //TM-21.MS.1.0 start
        if BudgetPercentageUsed = 100 then
            "NS_View 100% Completed Only" := true;
        //TM-21.MS.1.0 end

        //PRJ-565.AS.1.0 12MARCH2021- COMMENT START
        // if (Complete = false) and (PreviousJobForecast."Hours To Finish" > 0) and (Rec."Hours To Finish" = 0) then
        //     CalCulateHoursToFinish(rec, JobLedEntry);//PRJ-565
        //PRJ-565.AS.1.0 12MARCH2021- COMMENT END
        Modify();
        Commit();
        //CTSI-192.MS.1.0 end
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
        SumofTotalBudget := 0;//prj-537
        SumofBudgetRemaining := 0;//prj-537
        SumOfTotalCostsUsed := 0;//prj-537
        SumofForecastedVariance := 0;//prj-537

    end;

    trigger OnOpenPage();
    var
        PreviousJobForecastNew: Record "NS_Job Forecast";
        PreviousJobForecastNew2: Record "NS_Job Forecast";
    begin
        View100Pctcompltdonly := false; //TM-21.MS.1.0 
        ViewOpenTaskonly := false; //CTSI-192.MS.1.0
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
        if CurrentTaskManager > '' then
            SETRANGE("NS_Task Manager", CurrentTaskManager);
        SETRANGE(NS_Posted, false);
        FILTERGROUP := 1;
        NS_ListUpdate;
        Message('Please enter "As of Date Filter".');//PRJ-565
        //if calculated then
        CurrPage.Close();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        //CTSI-21.MS.1.0 start
        if AsOfDateFilter <> 0D then begin
            JobLedEntry.Reset();
            JobLedEntry.SetCurrentKey("Job No.", "Job Task No.", Type, "Entry Type", "Unit of Measure Code", "Posting Date");
            JobLedEntry.SetRange("Job No.", "NS_Job No.");
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
            JobLedEntry.SetRange("Job Task No.", "NS_Job Task No.");
            JobLedEntry.SetFilter(Type, '%1', JobLedEntry.Type::Resource);
            JobLedEntry.SetFilter("Entry Type", '%1', JobLedEntry."Entry Type"::Usage);
            JobLedEntry.SetFilter("Unit of Measure Code", '%1', 'HR');
            JobLedEntry.CalcSums(Quantity);
        end;
        //CTSI-21.MS.1.0 end 


    end;


    var
        Job: Record Job;
        JobTask: Record "Job Task";
        JobPlanningLineBudget: Record "Job Planning Line";
        PreviousJobForecast: Record "NS_Job Forecast";
        Resource: Record Resource;
        JobForecastWorksheetReport: Report "NS_Job Forecast Worksheet";
        JobForecastSummary: Page "NS_Job Forecast Summary";
        GetJobForecastRevenueTotal: Report "NS_Get JobForecastRevenueTotal";
        GLSetup: Record "General Ledger Setup";
        CurrentJobNo: Code[20];
        JobDescription: Text;//PRJ-301.AS.1.0 Changed description length from 50 to Blank
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
        Text005: Label 'Do you want to post this status to the job?';
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
        LaborRate: Decimal;//CTSI-95.MS.1.0
        LabrrateBytask: Record "NS_Labor rate by task list";//CTSI-95.MS.1.0
        Jobsetup: Record "Jobs Setup";//CTSI-95.MS.1.0
        DefDim: Record "Default Dimension";//CTSI-95.MS.1.0
        PersonResponsible: Code[20];//CTSI-121.N.S.1.0 18Aug2020
        ManagerValue: Code[20];//CTSI-121.N.S.1.0 18Aug2020
        JobsRec: Record Job;//CTSI-121.N.S.1.0 18Aug2020
        ViewOpenTaskonly: Boolean;
        View100Pctcompltdonly: boolean;//TM-21.MS.1.0	   
        SumofTotalBudget: Decimal;//PRJ-537.MS.1.0;1
        SumOfTotalCostsUsed: Decimal;//PRJ-537.MS.1.0;2
        SumofBudgetRemaining: Decimal;//PRJ-537.MS.1.0;3
        SumofForecastedVariance: Decimal;//PRJ-537.MS.1.0;4
        PMStatistic: page "NS_PM Statistics";//CTSI-269
        calculated: Boolean;

    procedure NS_FillInTable();
    var
        UseRecord: Boolean;
    begin
        BudgetRemaining := 0;
        if Rec."NS_Job No." > '' then begin

            //Fill in JobTask information on the Page if available
            if JobTask.GET(Rec."NS_Job No.", "NS_Job Task No.") then;

            //Get previous completion status for the task
            NS_GetLastPostedStatus(Rec."NS_Job No.", Rec."NS_Job Task No.", 0D, PreviousJobForecast);
            NS_GetJobPlanningLineAndBudget(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, TotalBudget, AsOfDateFilter);
            NS_GetBudgetHours(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, "Budgeted Hours", AsOfDateFilter);
            NS_GetJobSumofTotalBudget(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, SumofTotalBudget, AsOfDateFilter);//PRJ-537
            NS_GetSumOfTotalCostsUsed(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, SumOfTotalCostsUsed, AsOfDateFilter);//PRJ-537
            //Total Costs Used
            TotalCostsUsed := 0;
            if Job.GET(Rec."NS_Job No.") then begin
                Job.SETRANGE("NS_Job Task No. Filter", "NS_Job Task No.");
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
            if "NS_Percent Complete" <= 100 then begin//prj-611 add  =
                BudgetRemaining := TotalBudget - TotalCostsUsed;
                // if BudgetRemaining <= 0 then			//PRJ-611 comment
                //     BudgetRemaining := 0;

                BudgetPercentageUsed := NS_CalcPercentFrom0To100(TotalBudget, TotalCostsUsed);

                //PRJ-545.MS.1.0 open this start  

                if ("NS_Hours To Finish" = 0) then begin
                    if Rec."NS_Cost To Complete" = 0 then //PRJ-565
                        "NS_Cost To Complete" := NS_CalcCostToComplete("NS_Status Date", "NS_Percent Complete", TotalBudget, TotalCostsUsed,
                                                                 PreviousJobForecast."NS_Status Date",
                                                                 PreviousJobForecast."NS_Forecasted Completed Cost")
                    else
                        "NS_Cost To Complete" := Rec."NS_Cost To Complete";
                end;

                "NS_Forecasted Completed Cost" := TotalCostsUsed + "NS_Cost To Complete";

            end;

            if "NS_Percent Complete" <> 100 then
                ForecastedVariance := TotalBudget - "NS_Forecasted Completed Cost"
            else
                ForecastedVariance := TotalBudget - TotalCostsUsed;
            NS_GetSumofBudgetRemaining(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, SumofBudgetRemaining, AsOfDateFilter, SumofForecastedVariance);//PRJ-537
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
            "NS_Percent Complete" := ROUND(("NS_Units Complete" / JobPlanningLineBudget."NS_Work Units") * 100, GLSetup."Amount Rounding Precision");
        //else
        //"PP_Percent Complete" := 0; //PRJ-350 comment
        NS_CheckPercentComplete;
        //CTSI-95.MS.1.0 start
        if ("NS_Hours To Finish" <> 0) and (LaborRate <> 0) then //if TotalBudget = 0 then //CTSI-231
            "NS_Cost To Complete" := LaborRate * "NS_Hours To Finish"
        else //CTSI-95.MS.1.0 end 

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
            //CTSI-95.MS.1.0 start

            if ("NS_Hours To Finish" <> 0) and (LaborRate <> 0) then// if TotalBudget = 0 then //CTSI-231
                "NS_Cost To Complete" := LaborRate * "NS_Hours To Finish"
            else //CTSI-95.MS.1.0 end 

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
        //"Cost To Complete" := ROUND("Hours To Finish" * JobPlanningLineBudget."Unit Cost", GLSetup."Amount Rounding Precision"); //CTSI-21.MS.1.0
        //if jobledEntry.Quantity <> 0 then begin //CTSI-231on hold
        if ((jobledEntry.Quantity + "NS_Hours To Finish") <> 0) and (LaborRate <> 0) then //CTSI-21.MS.1.0
            "NS_Percent Complete" := Round(jobledEntry.Quantity * 100 / (jobledEntry.Quantity + "NS_Hours To Finish"), GLsetep."Amount Rounding Precision"); //CTSI-21.MS.1.0
                                                                                                                                                             //Round("Actual Hours" * 100 / ("Actual Hours" + "Hours To Finish"), GLsetep."Amount Rounding Precision"); //CTSI-21.MS.1.0
                                                                                                                                                             //end else
                                                                                                                                                             // if "Budgeted Hours" <> 0 then
                                                                                                                                                             //  "Percent Complete" := ("Budgeted Hours" - "Hours To Finish") * 100 / "Budgeted Hours" //CTSI-231 on hold
    end;

    procedure NS_ForecastedCompletedCostOnAfter();
    begin
        if "NS_Percent Complete" < 100 then begin
            //CTSI-95.MS.1.0 start
            if ("NS_Hours To Finish" <> 0) and (LaborRate <> 0) then//if TotalBudget = 0 then //CTSI-231
                "NS_Cost To Complete" := LaborRate * "NS_Hours To Finish"
            else //CTSI-95.MS.1.0 end 
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
        if ViewOpenTaskonly = true then//CTSI-192.MS.1.0
            SetFilter("NS_View Open Tasks Only", '%1', true); //CTSI-192.MS.1.0

        if View100Pctcompltdonly = true then //TM-21.MS.1.0
            SetFilter("NS_View 100% Completed Only", '<>%1', true)//TM-21.MS.1.0
        else
            SetFilter("NS_View 100% Completed Only", '%1|%2', true, false);//TM-21.MS.1.0 
        SETRANGE("NS_Job No.");
        SETRANGE("NS_Task Manager");
        if CurrentJobNo > '' then
            SETRANGE("NS_Job No.", CurrentJobNo);
        if CurrentTaskManager > '' then
            SETRANGE("NS_Task Manager", CurrentTaskManager);
        SETRANGE(NS_Posted, false);
        FILTERGROUP := 0;
        if FINDSET then;
        GetNewTasks(CurrentJobNo, CurrentTaskManager);
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

    procedure NS_Set(JobNoIn: Code[20]; TaskManagerIn: Code[20]; AsOfDateIn: Date);
    begin
        JobNoSentIn := JobNoIn;
        TaskManagerIn := TaskManagerIn;
        AsOfDateSentIn := AsOfDateIn;
    end;

    procedure NS_SetPurchLineFilters(var PurchLine: Record "Purchase Line");
    begin
        PurchLine.SETCURRENTKEY("Document Type", "Job No.", "Job Task No.");
        PurchLine.SETRANGE("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SETRANGE("Job No.", "NS_Job No.");
        PurchLine.SETRANGE("Job Task No.", "NS_Job Task No.");
    end;

    procedure NS_CalCulateHoursToFinish(var Rec: Record "NS_Job Forecast"; JLE: Record "Job Ledger Entry")
    var
        PreviousJobForecastNew2: Record "NS_Job Forecast";
        PreviousJobForecastNew: Record "NS_Job Forecast";
    begin
        Rec."NS_Hours To Finish" := rec."NS_Remaining Hours" + PreviousJobForecast."NS_Hours To Finish" - JLE.Quantity;

        if rec."NS_Hours To Finish" < 0 then
            rec."NS_Hours To Finish" := 0;
        NS_HoursToFinishOnAfterValidate;
        NS_SetBillDate;
        NS_SetStatusDate;
        NS_PercentCompleteOnAfterValidate;
        NS_CostToCompleteOnAfterValidate;
        // PreviousJobForecastNew.Reset();
        // PreviousJobForecastNew.SetRange("Job No.", CurrentJobNo);
        // PreviousJobForecastNew.SetFilter(Posted, '%1', true);
        // if PreviousJobForecastNew.FindFirst() then
        //     repeat
        //         PreviousJobForecastNew2.Reset();
        //         PreviousJobForecastNew2.SetRange("Job No.", CurrentJobNo);
        //         PreviousJobForecastNew2.SetRange("Job Task No.", PreviousJobForecastNew."Job Task No.");
        //         PreviousJobForecastNew2.SetFilter(Posted, '%1', false);
        //         if PreviousJobForecastNew2.FindSet() then begin
        //             Message('%1..%2', PreviousJobForecastNew2."Remaining Hours", JobLedEntry.Quantity);
        //             PreviousJobForecastNew2."Hours To Finish" := PreviousJobForecastNew2."Remaining Hours" + PreviousJobForecast."Hours To Finish" - JobLedEntry.Quantity;
        //         end;
        //     until PreviousJobForecastNew.next = 0;

        // with Rec do begin
        //     RESET;
        //     SETCURRENTKEY(Posted);
        //     SETRANGE(Posted, true);
        //     SETRANGE("Job No.", JobNo);
        //     SETRANGE("Job Task No.", JobTaskNo);
        //     //SetFilter(Complete, '%1', false);//CTSI-232  roll back
        //     if AsOfDateFilter > 0D then
        //         SETFILTER("Status Date", '<=%1', AsOfDateFilter);
        //     if not FINDLAST then
        //         CLEAR(JobForecast);
        // end; 

    end;
}

