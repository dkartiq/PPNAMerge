/// <summary>
/// Page NS_JobForecastWrks Task Total (ID 14021151).
/// </summary>
/// //PRJ-1299.JS.1.0 18APR2022 New Worksheet Page for Forecast by Task Totals
/// PRJ-1299.JS.2.0 23MAY2022 correct caption

page 14021151 "NS_JobForecastWrks Task Total"
{

    Caption = 'Job Forecast Wrks By Task Totals';
    DataCaptionFields = "NS_Job No.";
    PageType = Worksheet;
    SourceTable = "NS_Job Forecast";
    SourceTableView = SORTING("NS_Job No.", "NS_Job Task No.", "NS_Status Date", NS_Posted)
                      ORDER(Ascending)
                      WHERE(NS_Posted = CONST(false));
    Permissions = tabledata 167 = rimd;
    UsageCategory = Tasks;
    RefreshOnActivate = true;   //PRJCTPR-365.JS.1.0 08MAY2024


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
                    Editable = false;
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
                        NS_ListUpdateByTaskTotals();
                    end;

                    trigger OnValidate();
                    begin
                        JobDescription := '';
                        if Job.GET(CurrentJobNo) then begin
                            JobDescription := Job.Description;
                            CurrPage.SAVERECORD;
                        end;
                        NS_ListUpdateByTaskTotals();
                    end;
                }
                field(JobDescription; JobDescription)
                {
                    Caption = 'Job Description';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Job description';
                }
            }
            group(Control1100773006)
            {
                Caption = '';
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
                        NS_ListUpdateByTaskTotals();
                    end;

                    trigger OnValidate();
                    begin
                        TaskManagerName := '';
                        if Resource.GET(CurrentTaskManager) then begin
                            TaskManagerName := Resource.Name;
                            CurrPage.SAVERECORD;
                        end;
                        NS_ListUpdateByTaskTotals();
                    end;
                }
                field(TaskManagerName; TaskManagerName)
                {
                    ApplicationArea = All;
                    Caption = 'Task Manager Name';
                    Editable = false;
                    ToolTip = 'Specifies the task manager name';
                }
            }
            group(Control1100773039)
            {
                Caption = '';
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
                        NS_ListUpdateByTaskTotals();

                    end;
                }
                field(NextBilliDate; NextBillDate)
                {
                    ApplicationArea = All;
                    Caption = 'Next Bill Date:';
                    ToolTip = 'Specifies the Next Bill Date:';

                    trigger OnValidate();
                    begin
                        NS_ListUpdateByTaskTotals();
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
                        NS_ListUpdateByTaskTotals();
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
                        NS_ListUpdateByTaskTotals();
                    end;
                }
                field("NS_Forecast Method"; Rec."NS_Forecast Method")
                {
                    ToolTip = 'Specifies the value of the Forecast Method field.';
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Forecast Method';
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

                //CTSI-121.N.S.1.0 18Aug2020 start
                field(Complete; Rec.NS_Complete)
                {
                    ApplicationArea = all;
                    Description = 'CTSI.232.MS.1.0';

                    trigger OnValidate()
                    begin
                        if AsOfDateFilter = 0D then
                            Error('Please enter "As of Date Filter".');
                        //PRJ-1131.RM.1.0 10Jan2022 start
                        if Rec.NS_Complete = true then begin
                            Rec.validate("NS_Hours To Finish", 0);
                            Rec.validate("NS_Cost To Complete", 0);
                            Rec.Validate("NS_Percent Complete", 100);
                            //PRJ-1131.RM.1.0 10Jan2022 end
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
                field("Work Units"; NSWorkUnit)    //PRJ-1083.JS.1.0 03Jan2022 change JobPlanningLineBudget."NS_Work Units" to NSWorkUnit
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Work Units';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Work Units';
                }
                field("Work Unit of Measure"; NSWorkUnitofMeasure)    //PRJ-1083.JS.1.0 03Jan2022 change JobPlanningLineBudget."NS_Work Unit of Measure" to NSWorkUnitofMeasure
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
                    //Editable = false;//CTSI-198  //PRJ-1126.JS.1.0 28JAN2022 line commented
                    Editable = true; //PRJ-1126.JS.1.0 28JAN2022 line added

                    trigger OnValidate();
                    begin
                        // NS_UnitsCompleteOnAfterValidate;//PRJ-527
                        NS_SetBillDate;
                        NS_SetStatusDate;
                        NS_SetBillDate;
                        NS_SetStatusDate;
                        //PRJ-1126.JS.1.0 28JAN2022-Start
                        if NSWorkUnit <> 0 then
                            if Rec."NS_Units Complete" <> 0 then
                                Rec.Validate("NS_Percent Complete", Round(((Rec."NS_Units Complete" / NSWorkUnit) * 100), 0.01, '='));
                        //PRJ-1126.JS.1.0 28JAN2022-end
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
                        Rec.TestField(NS_Complete, false);//PRj-565  //PRJ-1131.RM.1.0 10Jan2022
                        if AsOfDateFilter = 0D then
                            Error('Please enter "As of Date Filter".');//PRJ-565

                        //PRJ-1126.JS.1.0 04FEB2022-start
                        NS_PercentCompleteOnAfterValidate();
                        NS_SetBillDate();
                        NS_SetStatusDate();
                        // if NSWorkUnit <> 0 then
                        //     if Rec."NS_Percent Complete" <> 0 then
                        //         Rec.Validate("NS_Units Complete", Round(((Rec."NS_Percent Complete" * NSWorkUnit) / 100), 0.01, '='));
                        //PRJ-1126.JS.1.0 04FEB2022-end
                    end;
                }
                field("Cost To Complete"; Rec."NS_Cost To Complete")
                {
                    ApplicationArea = All;
                    Caption = 'Estimated Cost To Complete';
                    ToolTip = 'Specifies the Estimated Cost To Complete';

                    trigger OnValidate();
                    begin
                        Rec.TestField(NS_Complete, false);//PRj-565  //PRJ-1131.RM.1.0 10Jan2022
                        if AsOfDateFilter = 0D then
                            Error('Please enter "As of Date Filter".');//PRJ-565
                        NS_CostToCompleteOnAfterValidate;
                        NS_SetBillDate;
                        NS_SetStatusDate;
                        CurrPage.Update();
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
                        CurrPage.Update();
                    end;
                }
                field("Hours To Finish"; Rec."NS_Hours To Finish")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Hours To Finish';

                    trigger OnValidate();
                    begin
                        Rec.TestField(NS_Complete, false);//PRj-565  //PRJ-1131.RM.1.0 10Jan2022
                        if AsOfDateFilter = 0D then
                            Error('Please enter "As of Date Filter".');//PRJ-565

                        NS_HoursToFinishOnAfterValidate;
                        NS_SetBillDate;
                        NS_SetStatusDate;
                        NS_PercentCompleteOnAfterValidate; //CTSI-21.MS.1.0
                        NS_CostToCompleteOnAfterValidate;//prj-565
                        CurrPage.Update();

                    end;
                }
                field(ForecastedVariance; ForecastedVariance)
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Forecasted Variance';    //PRJ-1299.JS.2.0 Line Level 23MAY2022
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
                            //PRJ-1131.RM.1.0 10Jan2022 start
                            Rec."NS_Bill Percent" := ROUND(((TotalCostsUsed + Rec."NS_PO Expected Receipt Cost") / TotalBudget) * 100, GLSetup."Amount Rounding Precision");
                            if Rec."NS_Bill Percent" > 100 then
                                Rec."NS_Bill Percent" := 100;
                        end else
                            Rec."NS_Bill Percent" := 100;
                        //PRJ-1131.RM.1.0 10Jan2022 end
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
                field("Budgeted Hours"; Rec."Budgeted Hours") //PRJ-1131.RM.1.0 10Jan2022
                {
                    ApplicationArea = all;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    trigger
                    OnValidate()
                    begin
                        if AsOfDateFilter > 0D then
                            Rec."NS_date filter" := AsOfDateFilter; //PRJ-1131.RM.1.0 10Jan2022
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
                field("Remaining Hours"; Rec."NS_Remaining Hours") //PRJ-1131.RM.1.0 10Jan2022
                {
                    ApplicationArea = all;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    Description = 'CTSI.21.MS.1.0';
                }
                field("Budgeted Hrs Percent Compelete"; Rec."NS_Budgeted Hrs Percent Compelete") //PRJ-1131.RM.1.0 10Jan2022
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
                    Caption = 'Budget Remaining';    //PRJ-1299.JS.2.0 23MAY2022
                    Visible = true;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;//additional
                }
                field(EstCosttocompTotal; Rec."NS_Total Est. cost to Complete") //PRJ-1131.RM.1.0 10Jan2022
                {
                    Caption = 'Estimated Cost to Complete';
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;//additional
                }
                field(ForeCompcostTotal; Rec."NS_Total Forecast Completed Cost") //PRJ-1131.RM.1.0 10Jan2022
                {
                    Caption = 'Forecasted Completed Cost';
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Forecasted Completed Cost';  //PRJ-1299.JS.1.0 25APR2022
                }
                field(ForeVariTotal; SumofForecastedVariance)
                {
                    Caption = 'Forecasted Variance';   //PRJ-1299.JS.2.0 24MAY2022 Card level
                    Visible = true;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Forecasted Variance';  //PRJ-1299.JS.1.0 25APR2022
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
                var
                    NS_Job: Record Job;   //PRJ-1039.JS.1.0 29JAN2022
                begin
                    //PRJ-1039.JS.1.0 29JAN2022-start
                    if CurrentJobNo > '' then begin
                        if NS_Job.Get(CurrentJobNo) then
                            if ((NS_Job."NS_Include Sub Levels" = true) and (NS_Job."NS_Job Class" = NS_Job."NS_Job Class"::"Master Job")) then begin
                                if AsOfDateFilter > 0D then begin
                                    JobForecastSummaryIncSubLevel.NS_Set(CurrentJobNo, AsOfDateFilter);
                                    JobForecastSummaryIncSubLevel.SETRECORD(Job);
                                    JobForecastSummaryIncSubLevel.RUNMODAL;
                                    CLEAR(JobForecastSummaryIncSubLevel);
                                end else
                                    ERROR(Text003);
                            end else begin
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
                    end;
                    //PRJ-1039.JS.1.0 29JAN2022-end
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
                var
                    NS_Job: Record Job;   //PRJ-1039.JS.1.0 30JAN2022
                begin
                    //PRJ-1039.JS.1.0 30JAN2022-start
                    if CurrentJobNo > '' then begin
                        if NS_Job.Get(CurrentJobNo) then
                            if ((NS_Job."NS_Include Sub Levels" = true) and (NS_Job."NS_Job Class" = NS_Job."NS_Job Class"::"Master Job")) then begin
                                if AsOfDateFilter > 0D then begin
                                    PMStatisticsIncSubLevels.Set(CurrentJobNo, AsOfDateFilter, NextBillDate);
                                    PMStatisticsIncSubLevels.SETRECORD(Job);
                                    PMStatisticsIncSubLevels.RUNMODAL;
                                    CLEAR(PMStatisticsIncSubLevels);
                                end else
                                    ERROR(Text003);
                            end else begin
                                if AsOfDateFilter > 0D then begin
                                    PMStatistic.Set(CurrentJobNo, AsOfDateFilter, NextBillDate);
                                    PMStatistic.SETRECORD(Job);
                                    PMStatistic.RUNMODAL;
                                    CLEAR(PMStatistic);
                                end else
                                    ERROR(Text003);
                            end;
                    end;
                    //PRJ-1039.JS.1.0 30JAN2022-end
                end;
            }
            // //CTSI-269 end
            // //CTSI-270 start

            //PRJ-1299.JS.1.0 02MAY2022 - Start
            action(NS_TaskTotalDetails)
            {
                ApplicationArea = All;
                Caption = 'Task Details';
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Ctrl+F10';
                ToolTip = 'Specify the Task Details for jobs Forecast by Task totals only';

                trigger OnAction();
                var
                    NS_Job: Record Job;
                    NSJobTask2: Record "Job Task";
                    NSJobTask3: Record "Job Task";
                    NSJobTaskLinesPage: Page "Job Task Lines";
                begin
                    if CurrentJobNo > '' then begin
                        if NS_Job.Get(CurrentJobNo) then begin
                            if NS_Job."NS_Forecast Method" = NS_Job."NS_Forecast Method"::"Job Forecast by Task Totals" then begin
                                NSJobTask2.Reset();
                                if NSJobTask2.get(Rec."NS_Job No.", Rec."NS_Job Task No.") then begin
                                    Clear(NSJobTaskLinesPage);
                                    NSJobTask3.Reset();
                                    NSJobTask3.SetRange("Job No.", NSJobTask2."Job No.");
                                    NSJobTask3.SetFilter("Job Task No.", NSJobTask2.Totaling);
                                    NSJobTaskLinesPage.SetTableView(NSJobTask3);
                                    NSJobTaskLinesPage.Run;
                                end;
                            end else
                                error('Applicable only for job Forecast by Task Totals');
                        end;
                    end;
                end;
            }
            //PRJ-1299.JS.1.0 02MAY2022 - Start
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
                            PageCommentSheet.NS_SetAsofDate(AsOfDateFilter, Rec."NS_Job No."); //PRJ-1131.RM.1.0 10Jan2022
                            CommentLine.Reset();
                            CommentLine.setfilter("Table Name", '%1', CommentLine."Table Name"::Job);
                            CommentLine.SetRange("No.", Rec."NS_Job No."); //PRJ-1131.RM.1.0 10Jan2022
                            CommentLine.SetRange(Date, AsOfDateFilter);
                            if CommentLine.Findset() then begin
                                PageCommentSheet.SetTableView(CommentLine);
                                PageCommentSheet.SetRecord(CommentLine);
                                PageCommentSheet.RunModal();
                            end else begin
                                CommentLine2.Reset();
                                CommentLine2.setfilter("Table Name", '%1', CommentLine2."Table Name"::Job);
                                CommentLine2.SetRange("No.", Rec."NS_Job No."); //PRJ-1131.RM.1.0 10Jan2022
                                if CommentLine2.FindLast() then;
                                CommentLine.Init();
                                CommentLine."Table Name" := CommentLine."Table Name"::Job;
                                CommentLine."No." := Rec."NS_Job No."; //PRJ-1131.RM.1.0 10Jan2022
                                CommentLine."Line No." := CommentLine2."Line No." + 10000;
                                CommentLine.Date := AsOfDateFilter;
                                CommentLine.Insert();
                                Commit();
                                CommentLine2.Reset();
                                CommentLine2.setfilter("Table Name", '%1', CommentLine2."Table Name"::Job);
                                CommentLine2.SetRange("No.", Rec."NS_Job No."); //PRJ-1131.RM.1.0 10Jan2022
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
                    NS_Job: Record Job;  //PRJ-1039.JS.1.0 30JAN2022 
                begin
                    //PRJ-1039.JS.1.0 30JAN2022-start
                    if CurrentJobNo > '' then begin
                        if NS_Job.Get(CurrentJobNo) then
                            if ((NS_Job."NS_Include Sub Levels" = true) and (NS_Job."NS_Job Class" = NS_Job."NS_Job Class"::"Master Job")) then begin
                                if AsOfDateFilter > 0D then begin
                                    JobForecastWhksIncSubLevelReport.Set(CurrentJobNo, AsOfDateFilter);
                                    JobForecastWhksIncSubLevelReport.RUNMODAL();
                                    CLEAR(JobForecastWhksIncSubLevelReport);
                                end else
                                    //AsOfDateFilter := WORKDATE;
                                    ERROR(Text003);
                            end else begin
                                if AsOfDateFilter > 0D then begin
                                    JobForecastWorksheetReport.Set(CurrentJobNo, AsOfDateFilter);
                                    JobForecastWorksheetReport.RUNMODAL();
                                    CLEAR(JobForecastWorksheetReport);
                                end else
                                    ERROR(Text003);
                            end;
                    end;
                end;
                //PRJ-1039.JS.1.0 30JAN2022-end
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
                    JobRec: Record Job;     //PRJ-1015.JS.1.0   14Oct2021
                begin
                    If JobRec.Get(Rec."NS_Job No.") then begin  //PRJ-1015.JS.1.0  14Oct2021
                        if ((JobRec."NS_Include Sub Levels" = false) and (JobRec."NS_Sub-Level to Job No." = '')) then begin    //PRJ-1015.JS.1.0  14Oct2021                    
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
                        end else begin    //PRJ-1015.JS.1.0  14Oct2021
                            JobText := '';
                            FindPoint := 0;
                            FindPoint := StrPos(Rec."NS_Job No.", '.');
                            if FindPoint > 1 then
                                JobText := CopyStr(Rec."NS_Job No.", 1, FindPoint - 1)
                            else
                                JobText := Rec."NS_Job No.";
                            PrctOfComp.Reset();
                            PrctOfComp.SetFilter("NS_Job No.", '%1', Rec."NS_Job No.");
                            Page.RunModal(Page::"NS_Percentage of Completion", PrctOfComp);
                        end;
                        //PRJ-1015.JS.1.0  14Oct2021
                    end;
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
                    UpdateSummDetJFW1: Report "NS_UPDRevRecJFW IncludeSubLev";
                    UpdateSummDetJFWFBTT: Report "NS_UPD RRSumDtls By TaskTotals";
                    JobRec: Record job;
                    MasterJob: Record Job;
                begin
                    JobsetupRec.get;
                    if JobRec.get(CurrentJobNo) then;
                    if JobRec."NS_Forecast Method" <> JobRec."NS_Forecast Method"::"Job Forecast by Task Totals" then begin
                        If JobRec."NS_Include Sub Levels" = false then begin     //PRJ-1015.JS.1.0  14Oct2021 add line 
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
                                Rec.NS_PostLines(CurrentJobNo, AsOfDateFilter, NextBillDate); //PRJ-1131.RM.1.0 10Jan2022
                                                                                              //CTSI-274
                                UpdateSummDetJFW.SetJobNo(CurrentJobNo, AsOfDateFilter);
                                UpdateSummDetJFW.Run();
                                // //CTSI-274
                            END else begin  //CTSI-274/PRJ-658 
                                exit;
                            end;
                            //PRJ-1015.JS.1.0  14Oct2021 - Start   
                        end else begin
                            //Message('AAAAA');  //OK

                            if JobRec."NS_Sub-Level to Job No." = '' then begin
                                if JobRec."NS_Revenue Recognized" then
                                    Error('Revenue has already been recognized for this job. No further forecasting can be done for it.');
                            end else begin
                                if MasterJob.get(JobRec."NS_Sub-Level to Job No.") then;
                                if MasterJob."NS_Revenue Recognized" then begin
                                    Error('Revenue has already been recognized for its master job %1. No further forecasting can be done for it.', MasterJob."No.");
                                end;
                            end;

                            if (JobRec."NS_Actual Percent Complete" = 100) and (JobRec."NS_Actual PercentCompleteDate" <> 0D) then
                                Error('The job has already been set to 100%, so you are not allowed to post the forecast for this job.');


                            // if jobtable.get(CurrentJobNo) then begin
                            //     if jobtable."NS_Exclude from Job Forecast" = true then
                            //         Error('This Job has been excluded from Job Forecast.To post, remove the checkmark from Job Forecast');
                            // end;

                            if CONFIRM(Text006, true) then begin
                                Rec.NS_PostLinesIncludeSubLevelsFBTT(CurrentJobNo, AsOfDateFilter, NextBillDate); //PRJ-1131.RM.1.0 10Jan2022
                                UpdateSummDetJFW1.SetJobNo(CurrentJobNo, AsOfDateFilter);
                                UpdateSummDetJFW1.Run();
                            END else begin
                                exit;
                            end;
                        end;
                        //PRJ-1299.JS.1.0 27APR2022 - Start    
                    end else begin
                        If JobRec."NS_Include Sub Levels" = false then begin
                            if JobRec."NS_Sub-Level to Job No." = '' then begin
                                if JobRec."NS_Revenue Recognized" then
                                    Error('Revenue has already been recognized for this job. No further forecasting can be done for it.');
                            end else begin
                                if MasterJob.get(JobRec."NS_Sub-Level to Job No.") then;
                                if MasterJob."NS_Revenue Recognized" then begin
                                    Error('Revenue has already been recognized for its master job %1. No further forecasting can be done for it.', MasterJob."No.");
                                end;
                            end;
                            if (JobRec."NS_Actual Percent Complete" = 100) and (JobRec."NS_Actual PercentCompleteDate" <> 0D) then
                                Error('The job has already been set to 100%, so you are not allowed to post the forecast for this job.');

                            if jobtable.get(CurrentJobNo) then begin
                                if jobtable."NS_Exclude from Job Forecast" = true then
                                    Error('This Job has been excluded from Job Forecast.To post, remove the checkmark from Job Forecast');
                            end;

                            if CONFIRM(Text005, true) then begin
                                Rec.NS_PostLinesFBTT(CurrentJobNo, AsOfDateFilter, NextBillDate);
                                UpdateSummDetJFWFBTT.SetJobNo(CurrentJobNo, AsOfDateFilter);
                                UpdateSummDetJFWFBTT.Run();
                            END else begin
                                exit;
                            end;
                        end else begin
                            if JobRec."NS_Sub-Level to Job No." = '' then begin
                                if JobRec."NS_Revenue Recognized" then
                                    Error('Revenue has already been recognized for this job. No further forecasting can be done for it.');
                            end else begin
                                if MasterJob.get(JobRec."NS_Sub-Level to Job No.") then;
                                if MasterJob."NS_Revenue Recognized" then begin
                                    Error('Revenue has already been recognized for its master job %1. No further forecasting can be done for it.', MasterJob."No.");
                                end;
                            end;

                            if (JobRec."NS_Actual Percent Complete" = 100) and (JobRec."NS_Actual PercentCompleteDate" <> 0D) then
                                Error('The job has already been set to 100%, so you are not allowed to post the forecast for this job.');

                            if CONFIRM(Text006, true) then begin
                                Rec.NS_PostLinesIncludeSubLevelsFBTT(CurrentJobNo, AsOfDateFilter, NextBillDate); //PRJ-1131.RM.1.0 10Jan2022
                                UpdateSummDetJFWFBTT.SetJobNo(CurrentJobNo, AsOfDateFilter);
                                UpdateSummDetJFWFBTT.Run();
                            END else begin
                                exit;
                            end;
                        end;
                    end;
                    //PRJ-1299.JS.1.0 27APR2022 - end
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
                    NS_Jobs: Record Job;    //PRJ-1015.JS.1.0   19Oct2021
                    NS_JobTask2: Record "Job Task";  //PRJ-1299.JS.1.0 21APR2022
                begin
                    NS_JobTask2.Reset();
                    if NS_JobTask2.get(Rec."NS_Job No.", rec."NS_Job Task No.") then;
                    if NS_Jobs.Get(CurrentJobNo) then begin   //PRJ-1015.JS.1.0   19Oct2021 add line
                        if NS_Jobs."NS_Include Sub Levels" = false then begin  //PRJ-1015.JS.1.0   19Oct2021 add line
                            if (CurrentJobNo > '') and (NextBillDate > 0D) then begin
                                //PRJ-1131.RM.1.0.001 10Jan2022 start
                                //with JobForecastLines do begin
                                JobForecastLines.RESET;
                                JobForecastLines.SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", NS_Posted);
                                JobForecastLines.SETRANGE("NS_Job No.", CurrentJobNo);
                                JobForecastLines.SETRANGE(NS_Posted, false);
                                if JobForecastLines.FINDSET(true, false) then
                                    repeat
                                        if JobForecastLines."NS_Calc Expected Receipt Costs" then begin
                                            JobForecastLines."NS_Bill Date" := 0D;
                                            JobForecastLines."NS_Bill Percent" := 0;
                                            JobForecastLines."NS_PO Expected Receipt Cost" := JobTask.NS_POsRecdAndOtstndngByExptRcptDateFBTT(JobForecastLines."NS_Job No.", JobForecastLines."NS_Job Task No.", NextBillDate);
                                            if JobForecastLines."NS_PO Expected Receipt Cost" > 0 then begin
                                                JobForecastLines."NS_Bill Date" := NextBillDate;
                                                JobForecastLines.NS_GetJobPlanningLineAndBudgetFBTT(JobForecastLines."NS_Job No.", JobForecastLines."NS_Job Task No.", JobPlanningLineBudget, TotalTaskBudget, AsOfDateFilter);
                                                if TotalTaskBudget <> 0 then begin
                                                    JobCostsUsed := 0;
                                                    if Job.GET(Rec."NS_Job No.") then begin
                                                        //Job.SETRANGE("NS_Job Task No. Filter", JobForecastLines."NS_Job Task No.");
                                                        Job.SetFilter("NS_Job Task No. Filter", NS_JobTask2.Totaling);  //PRJ-1299.JS.1.0 21APR2022

                                                        Job.SETFILTER("NS_Date Filter", '..%1', AsOfDateFilter);
                                                        Job.CALCFIELDS("NS_Usage (Cost) (LCY)");
                                                        JobCostsUsed := Job."NS_Usage (Cost) (LCY)";
                                                    end;
                                                    JobForecastLines."NS_Bill Percent" := ROUND(((JobCostsUsed + JobForecastLines."NS_PO Expected Receipt Cost") / TotalTaskBudget) * 100, 0.01);
                                                    if JobForecastLines."NS_Bill Percent" > 100 then
                                                        JobForecastLines."NS_Bill Percent" := 100;
                                                end else
                                                    JobForecastLines."NS_Bill Percent" := 100;
                                            end else begin
                                                JobForecastLines.NS_GetJobPlanningLineAndBudgetFBTT(Rec."NS_Job No.", JobForecastLines."NS_Job Task No.", JobPlanningLineBudget, TotalBudget, AsOfDateFilter);
                                                TotalCostsUsed := 0;
                                                if Job.GET(Rec."NS_Job No.") then begin
                                                    //Job.SETRANGE("NS_Job Task No. Filter", JobForecastLines."NS_Job Task No.");
                                                    Job.SetFilter("NS_Job Task No. Filter", NS_JobTask2.Totaling);  //PRJ-1299.JS.1.0 21APR2022

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
                                                BudgetPercentageUsed := JobForecastLines.NS_CalcPercentFrom0To100FBTT(TotalBudget, TotalCostsUsed);
                                                if BudgetPercentageUsed > 100 then
                                                    BudgetPercentageUsed := 100;
                                                JobForecastLines."NS_Bill Percent" := BudgetPercentageUsed;
                                                if JobForecastLines."NS_Bill Percent" > 0 then
                                                    JobForecastLines."NS_Bill Date" := NextBillDate;
                                            end;
                                            JobForecastLines.MODIFY();
                                        end;
                                    until JobForecastLines.NEXT() = 0;
                                //end;
                                //PRJ-1131.RM.1.0.001 10Jan2022 end
                            end else
                                ERROR(Text002);
                            //PRJ-1015.JS.1.0  19Oct2021 Start        
                        end else begin
                            if (CurrentJobNo > '') and (NextBillDate > 0D) then begin
                                //PRJ-1131.RM.1.0.002 10Jan2022 start
                                //with JobForecastLines do begin
                                JobForecastLines.RESET;
                                JobForecastLines.SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", NS_Posted);
                                JobForecastLines.SETRANGE("NS_Job No.", CurrentJobNo);
                                JobForecastLines.SETRANGE(NS_Posted, false);
                                if JobForecastLines.FINDSET(true, false) then
                                    repeat
                                        if JobForecastLines."NS_Calc Expected Receipt Costs" then begin
                                            JobForecastLines."NS_Bill Date" := 0D;
                                            JobForecastLines."NS_Bill Percent" := 0;
                                            JobForecastLines."NS_PO Expected Receipt Cost" := JobTask.NS_POsRecdAndOtstndngByExptRcptDateIncludeSubLevels(JobForecastLines."NS_Job No.", JobForecastLines."NS_Job Task No.", NextBillDate);
                                            if JobForecastLines."NS_PO Expected Receipt Cost" > 0 then begin
                                                JobForecastLines."NS_Bill Date" := NextBillDate;
                                                JobForecastLines.NS_GetJobPlanningLineAndBudgetIncludeSubLevels(JobForecastLines."NS_Job No.", JobForecastLines."NS_Job Task No.", JobPlanningLineBudget, TotalTaskBudget, AsOfDateFilter);
                                                if TotalTaskBudget <> 0 then begin
                                                    JobCostsUsed := 0;
                                                    if Job.GET(Rec."NS_Job No.") then begin
                                                        //Job.SETRANGE("NS_Job Task No. Filter", JobForecastLines."NS_Job Task No.");
                                                        Job.SetFilter("NS_Job Task No. Filter", NS_JobTask2.Totaling);  //PRJ-1299.JS.1.0 21APR2022
                                                        Job.SETFILTER("NS_Date Filter", '..%1', AsOfDateFilter);
                                                        Job.CALCFIELDS("NS_Usage (Cost) (LCY)");
                                                        JobCostsUsed := Job."NS_Usage (Cost) (LCY)";
                                                    end;
                                                    JobForecastLines."NS_Bill Percent" := ROUND(((JobCostsUsed + JobForecastLines."NS_PO Expected Receipt Cost") / TotalTaskBudget) * 100, 0.01);
                                                    if JobForecastLines."NS_Bill Percent" > 100 then
                                                        JobForecastLines."NS_Bill Percent" := 100;
                                                end else
                                                    JobForecastLines."NS_Bill Percent" := 100;
                                            end else begin
                                                JobForecastLines.NS_GetJobPlanningLineAndBudgetIncludeSubLevels(Rec."NS_Job No.", JobForecastLines."NS_Job Task No.", JobPlanningLineBudget, TotalBudget, AsOfDateFilter);
                                                TotalCostsUsed := 0;
                                                if Job.GET(Rec."NS_Job No.") then begin
                                                    //Job.SETRANGE("NS_Job Task No. Filter", JobForecastLines."NS_Job Task No.");
                                                    Job.SetFilter("NS_Job Task No. Filter", NS_JobTask2.Totaling);  //PRJ-1299.JS.1.0 21APR2022

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
                                                BudgetPercentageUsed := JobForecastLines.NS_CalcPercentFrom0To100IncludeSubLevels(TotalBudget, TotalCostsUsed);
                                                if BudgetPercentageUsed > 100 then
                                                    BudgetPercentageUsed := 100;
                                                JobForecastLines."NS_Bill Percent" := BudgetPercentageUsed;
                                                if JobForecastLines."NS_Bill Percent" > 0 then
                                                    JobForecastLines."NS_Bill Date" := NextBillDate;
                                            end;
                                            JobForecastLines.MODIFY();
                                        end;
                                    until JobForecastLines.NEXT() = 0;
                                // end;
                                //PRJ-1131.RM.1.0.002 10Jan2022 end
                            end;
                        end;
                        //PRJ-1015.JS.1.0  19Oct2021 Start
                    end;   //PRJ-1015.JS.1.0  19Oct2021 add line
                end; //PRJ-1015.JS.1.0  19Oct2021 add line
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
        NSJobs: Record Job;   //PRJ-1015.JS.1.0  20Oct2021
        NSJobNofilter: Code[30];  //PRJ-1015.JS.1.0  20Oct2021  //PRJ-1039.JS.2.0  12JAN2022
    begin
        NSJobNofilter := '';
        NSJobNofilter := '@*' + format(Rec."NS_Job No.") + '*';
        NSWorkUnit := 0;    //PRJ-1083.JS.1.0 03Jan2022
        NSWorkUnitofMeasure := ''; //PRJ-1083.JS.1.0 03Jan2022
        If NSJobs.Get(Rec."NS_Job No.") then;   //PRJ-1015.JS.1.0  20Oct2021        
        if Rec.NS_Posted = false then //PRJ-1131.RM.1.0 10Jan2022
            NS_FillInTable;
        if JobTask.GET(Rec."NS_Job No.", rec."NS_Job Task No.") then;   //PRJ-1083.JS.1.0 03Jan2022 add rec
        NSWorkUnit := JobTask."NS_Work Units";    //PRJ-1083.JS.1.0 03Jan2022
        NSWorkUnitofMeasure := JobTask."NS_Work Unit of Measure";  //PRJ-1083.JS.1.0 03Jan2022

        JobTask.CALCFIELDS("Outstanding Orders", "Amt. Rcd. Not Invoiced");
        //CTSI-21.MS.1.0 start
        if NSJobs."NS_Include Sub Levels" = false then begin    //PRJ-1015.JS.1.0  20Oct2021
            JobLedEntry.Reset();
            JobLedEntry.SetCurrentKey("Job No.", "Job Task No.", Type, "Entry Type", "Unit of Measure Code");
            JobLedEntry.SetRange("Job No.", Rec."NS_Job No.");//PRJ-1131.RM.1.0 10Jan2022
            //PRJ-1475.GK.1.0 22July2022 start
            if (JobTask."NS_Forecast By Task Totals") and (JobTask.Totaling <> '') then
                JobLedEntry.SetFilter("Job Task No.", JobTask.Totaling)
            else //PRJ-1475.GK.1.0 22July2022 end
                JobLedEntry.SetRange("Job Task No.", Rec."NS_Job Task No.");//PRJ-1131.RM.1.0 10Jan2022
            JobLedEntry.SetFilter(Type, '%1', JobLedEntry.Type::Resource);
            JobLedEntry.SetFilter("Entry Type", '%1', JobLedEntry."Entry Type"::Usage);
            //JobLedEntry.SetFilter("Unit of Measure Code", '%1', 'HR');//PRJ-1524.GK.1.0 25July2022
            JobLedEntry.SetFilter("Unit of Measure Code", '%1|%2', 'HR', 'HOUR');//PRJ-1524.GK.1.0 25July2022
            if AsOfDateFilter <> 0D then
                JobLedEntry.SetFilter("Posting Date", '%1..%2', 0D, AsOfDateFilter);
            JobLedEntry.CalcSums(Quantity);
            //PRJ-1015.JS.1.0  20Oct2021
        end else begin
            JobLedEntry.Reset();
            JobLedEntry.SetCurrentKey("Job No.", "Job Task No.", Type, "Entry Type", "Unit of Measure Code");
            //JobLedEntry.SetRange("Job No.", "NS_Job No.");
            JobLedEntry.Setfilter("Job No.", '%1', NSJobNofilter);
            //PRJ-1475.GK.1.0 22July2022 start
            if (JobTask."NS_Forecast By Task Totals") and (JobTask.Totaling <> '') then
                JobLedEntry.SetFilter("Job Task No.", JobTask.Totaling)
            else //PRJ-1475.GK.1.0 22July2022 end
                JobLedEntry.SetRange("Job Task No.", rec."NS_Job Task No.");
            JobLedEntry.SetFilter(Type, '%1', JobLedEntry.Type::Resource);
            JobLedEntry.SetFilter("Entry Type", '%1', JobLedEntry."Entry Type"::Usage);
            //JobLedEntry.SetFilter("Unit of Measure Code", '%1', 'HR');//PRJ-1524.GK.1.0 25July2022
            JobLedEntry.SetFilter("Unit of Measure Code", '%1|%2', 'HR', 'HOUR');//PRJ-1524.GK.1.0 25July2022
            if AsOfDateFilter <> 0D then
                JobLedEntry.SetFilter("Posting Date", '%1..%2', 0D, AsOfDateFilter);
            JobLedEntry.CalcSums(Quantity);
        end;
        //CTSI-21.MS.1.0 end 
        //CTSI-21.MS.1.001 start
        if glsetup.Get() then;
        Rec."NS_Remaining Hours" := Rec."Budgeted Hours" - jobledEntry.Quantity;//"Actual Hours"; //PRJ-1131.RM.1.0 10Jan2022  start
        if Rec."NS_Remaining Hours" < 0 then //PRJ-565
            Rec."NS_Remaining Hours" := 0;
        if Rec."Budgeted Hours" <> 0 then
            Rec."NS_Budgeted Hrs Percent Compelete" := round(jobledEntry.Quantity * 100 / Rec."Budgeted Hours", glsetup."Amount Rounding Precision");
        //round("Actual Hours" * 100 / "Budgeted Hours", glsetup."Amount Rounding Precision");
        //CTSI-21.MS.1.001 end  
        //PRJ-285.MS.1.0 start
        if Rec.NS_Posted = false then begin //PRJ-1131.RM.1.0 10Jan2022
            AmtRcdNotInv := 0;
            AmtRcdNotInv1 := 0;
            AmtRcdNotInv2 := 0;
            PurRecpLine.reset;
            PurRecpLine.setrange("Job No.", Rec."NS_Job No.");//PRJ-1131.RM.1.0 10Jan2022
            PurRecpLine.SetRange("Job Task No.", Rec."NS_Job Task No.");//PRJ-1131.RM.1.0 10Jan2022
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
            PurcInvLine.SetRange("Job No.", Rec."NS_Job No.");//PRJ-1131.RM.1.0 10Jan2022
            PurcInvLine.SetRange("Job Task No.", Rec."NS_Job Task No.");//PRJ-1131.RM.1.0 10Jan2022
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
        if job.get(Rec."NS_Job No.") then;//PRJ-1131.RM.1.0 10Jan2022
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
        if (TotalBudget <> 0) or (TotalCostsUsed <> 0) or (Rec."NS_Cost To Complete" <> 0) then //CTSI-MS.1.0 //PRJ-1131.RM.1.0 10Jan2022
            Rec."NS_View Open Tasks Only" := true;//PRJ-1131.RM.1.0 10Jan2022

        //TM-21.MS.1.0 start
        if BudgetPercentageUsed = 100 then
            Rec."NS_View 100% Completed Only" := true;//PRJ-1131.RM.1.0 10Jan2022
        //TM-21.MS.1.0 end

        //PRJ-565.AS.1.0 12MARCH2021- COMMENT START
        // if (Complete = false) and (PreviousJobForecast."Hours To Finish" > 0) and (Rec."Hours To Finish" = 0) then
        //     CalCulateHoursToFinish(rec, JobLedEntry);//PRJ-565
        //PRJ-565.AS.1.0 12MARCH2021- COMMENT END
        Rec.Modify();//PRJ-1131.RM.1.0 10Jan2022
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
        Rec."NS_Cost To Complete" := 0;//PRJ-1131.RM.1.0 10Jan2022
        Rec."NS_Forecasted Completed Cost" := 0;//PRJ-1131.RM.1.0 10Jan2022
        ForecastedVariance := 0;
        SumofTotalBudget := 0;//prj-537
        SumofBudgetRemaining := 0;//prj-537
        SumOfTotalCostsUsed := 0;//prj-537
        SumofForecastedVariance := 0;//prj-537
        NSWorkUnit := 0;            //PRJ-1083.JS.1.0  03Jan2022
        NSWorkUnitofMeasure := '';  //PRJ-1083.JS.1.0  03Jan2022

    end;

    trigger OnOpenPage();
    var
        PreviousJobForecastNew: Record "NS_Job Forecast";
        PreviousJobForecastNew2: Record "NS_Job Forecast";
    begin
        View100Pctcompltdonly := false; //TM-21.MS.1.0 
        ViewOpenTaskonly := false; //CTSI-192.MS.1.0
        Rec.SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date");//PRJ-1131.RM.1.0 10Jan2022
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

        NS_ListUpdateByTaskTotals();
        //PRJ-1131.RM.1.0 10Jan2022 start
        Rec.FILTERGROUP := 2;
        if CurrentJobNo > '' then
            Rec.SETRANGE("NS_Job No.", CurrentJobNo);
        if CurrentTaskManager > '' then
            Rec.SETRANGE("NS_Task Manager", CurrentTaskManager);
        Rec.SETRANGE(NS_Posted, false);
        Rec.FILTERGROUP := 1;
        //PRJ-1131.RM.1.0 10Jan2022 end        
        NS_ListUpdateByTaskTotals();
        Message('Please enter "As of Date Filter".');//PRJ-565
        //if calculated then
        CurrPage.Close();
    end;

    trigger OnAfterGetCurrRecord()
    var
        NS_JobNoFilter: Code[30];   //PRJ-1015.JS.1.0  19Oct2021  //PRJ-1039.JS.2.0 12JAN2022
        NS_Jobs: Record Job;  //PRJ-1015.JS.1.0  19Oct2021
    begin
        //PRJ-1015.JS.1.0  19Oct2021 Start
        if Job.Get(Rec."NS_Job No.") then;
        NS_JobNoFilter := '';
        NS_JobNoFilter := '@*' + FORMAT(Rec."NS_Job No.") + '*';
        //PRJ-1015.JS.1.0  19Oct2021 end 
        if NS_Jobs.get(Rec."NS_Job No.") then    //PRJ-1015.JS.1.0  19Oct2021
            if NS_Jobs."NS_Include Sub Levels" = false then begin   //PRJ-1015.JS.1.0  19Oct2021
                //CTSI-21.MS.1.0 start
                if AsOfDateFilter <> 0D then begin
                    JobLedEntry.Reset();
                    JobLedEntry.SetCurrentKey("Job No.", "Job Task No.", Type, "Entry Type", "Unit of Measure Code", "Posting Date");
                    JobLedEntry.SetRange("Job No.", Rec."NS_Job No.");//PRJ-1131.RM.1.0 10Jan2022
                                                                      //PRJ-1475.GK.1.0 22July2022 start
                    if (JobTask."NS_Forecast By Task Totals") and (JobTask.Totaling <> '') then
                        JobLedEntry.SetFilter("Job Task No.", JobTask.Totaling)
                    else //PRJ-1475.GK.1.0 22July2022 end
                        JobLedEntry.SetRange("Job Task No.", Rec."NS_Job Task No.");//PRJ-1131.RM.1.0 10Jan2022
                    JobLedEntry.SetFilter(Type, '%1', JobLedEntry.Type::Resource);
                    JobLedEntry.SetFilter("Entry Type", '%1', JobLedEntry."Entry Type"::Usage);
                    //JobLedEntry.SetFilter("Unit of Measure Code", '%1', 'HR');//PRJ-1524.GK.1.0 25July2022
                    JobLedEntry.SetFilter("Unit of Measure Code", '%1|%2', 'HR', 'HOUR');//PRJ-1524.GK.1.0 25July2022
                    JobLedEntry.SetFilter("Posting Date", '%1..%2', 0D, AsOfDateFilter);
                    JobLedEntry.CalcSums(Quantity);
                end else begin
                    JobLedEntry.Reset();
                    JobLedEntry.SetCurrentKey("Job No.", "Job Task No.", Type, "Entry Type", "Unit of Measure Code");
                    JobLedEntry.SetRange("Job No.", Rec."NS_Job No.");//PRJ-1131.RM.1.0 10Jan2022
                    //PRJ-1475.GK.1.0 22July2022 start
                    if (JobTask."NS_Forecast By Task Totals") and (JobTask.Totaling <> '') then
                        JobLedEntry.SetFilter("Job Task No.", JobTask.Totaling)
                    else //PRJ-1475.GK.1.0 22July2022 end
                        JobLedEntry.SetRange("Job Task No.", Rec."NS_Job Task No.");//PRJ-1131.RM.1.0 10Jan2022
                    JobLedEntry.SetFilter(Type, '%1', JobLedEntry.Type::Resource);
                    JobLedEntry.SetFilter("Entry Type", '%1', JobLedEntry."Entry Type"::Usage);
                    //JobLedEntry.SetFilter("Unit of Measure Code", '%1', 'HR');//PRJ-1524.GK.1.0 25July2022
                    JobLedEntry.SetFilter("Unit of Measure Code", '%1|%2', 'HR', 'HOUR');//PRJ-1524.GK.1.0 25July2022
                    JobLedEntry.CalcSums(Quantity);
                end;
                //PRJ-1015.JS.1.0  19Oct2021  start
            end else begin
                if AsOfDateFilter <> 0D then begin
                    JobLedEntry.Reset();
                    JobLedEntry.SetCurrentKey("Job No.", "Job Task No.", Type, "Entry Type", "Unit of Measure Code", "Posting Date");
                    //JobLedEntry.Setfilter("Job No.", '%1', NS_JobNoFilter);    //PRJ-1039.JS.1.0 13Dec2021 line commented
                    JobLedEntry.SetFilter("NS_Sub-Level to Job No.", '%1', NS_JobNoFilter);   //PRJ-1039.JS.1.0 13Dec2021 line added
                    JobLedEntry.SetRange("Job Task No.", Rec."NS_Job Task No.");
                    JobLedEntry.SetFilter(Type, '%1', JobLedEntry.Type::Resource);
                    JobLedEntry.SetFilter("Entry Type", '%1', JobLedEntry."Entry Type"::Usage);
                    //JobLedEntry.SetFilter("Unit of Measure Code", '%1', 'HR');//PRJ-1524.GK.1.0 25July2022
                    JobLedEntry.SetFilter("Unit of Measure Code", '%1|%2', 'HR', 'HOUR');//PRJ-1524.GK.1.0 25July2022
                    JobLedEntry.SetFilter("Posting Date", '%1..%2', 0D, AsOfDateFilter);
                    JobLedEntry.CalcSums(Quantity);
                end else begin
                    JobLedEntry.Reset();
                    JobLedEntry.SetCurrentKey("Job No.", "Job Task No.", Type, "Entry Type", "Unit of Measure Code");
                    //JobLedEntry.Setfilter("Job No.", '%1', NS_JobNoFilter);     //PRJ-1039.JS.1.0 13Dec2021 line commented
                    JobLedEntry.SetFilter("NS_Sub-Level to Job No.", '%1', NS_JobNoFilter);   //PRJ-1039.JS.1.0 13Dec2021 line added
                    JobLedEntry.SetRange("Job Task No.", Rec."NS_Job Task No.");
                    JobLedEntry.SetFilter(Type, '%1', JobLedEntry.Type::Resource);
                    JobLedEntry.SetFilter("Entry Type", '%1', JobLedEntry."Entry Type"::Usage);
                    //JobLedEntry.SetFilter("Unit of Measure Code", '%1', 'HR');//PRJ-1524.GK.1.0 25July2022
                    JobLedEntry.SetFilter("Unit of Measure Code", '%1|%2', 'HR', 'HOUR');//PRJ-1524.GK.1.0 25July2022
                    JobLedEntry.CalcSums(Quantity);
                end;
                //PRJ-1015.JS.1.0  19Oct2021  end
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

        JobForecastWhksIncSubLevelReport: Report "NS_JobForecast WhksIncSubLevel";   //PRJ-1039.JS.1.0 30JAN2022
        JobForecastSummary: Page "NS_Job Forecast Summary";
        JobForecastSummaryIncSubLevel: page "NS_Job Forecast SummIncSubLevl";   //PRJ-1039.JS.1.0 29JAN2022
        PMStatisticsIncSubLevels: Page "NS_PM Statistics IncSub Levels";  //PRJ-1039.JS.1.0 30JAN2022
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
        Text006: Label 'Do you want to post forecast status?';   //PRJ-1015.JS.1.0  10Oct2021
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
        ForecastByTaskTotals: Boolean;    //PRJ-1299.JS.1.0 19APR2022

        SubLevelTotalBudget: Decimal;   //PRJ-1015.JS.1.0 06Oct2021
        SumOfSubLevelTotalCostUsed: Decimal;  //PRJ-1015.JS.1.0 07Oct2021
        SumOfSubLevelTotalBudgetHours: Decimal;   //PRJ-1015.JS.1.0 21Oct2021
        NSWorkUnit: Decimal;            //PRJ-1083.JS.1.0  03Jan2022
        NSWorkUnitofMeasure: Code[20];  //PRJ-1083.JS.1.0  03Jan2022

    procedure NS_FillInTable();
    var
        UseRecord: Boolean;
        NS_Jobs: Record Job;     //PRJ-914.1.0  06Oct2021
        NS_JobsLocal: Record Job;    //PRJ-1039.JS.1.0  16Dec2021
        NS_JobNoFilter: Code[30];   //PRJ-1039.JS.1.0  16Dec2021  //PRJ-1039.JS.2.0 12JAN2022
        NS_Jobs2: Record Job;  //PRJ-1299.JS.1.0 20APR2022
        NS_JobTask2: Record "Job Task";  //PRJ-1299.JS.1.0 20APR2022
        NSJobTaskTotalingFilter: Code[35];  //PRJ-1299.JS.1.0 21APR2022  
        NSJobSetup1: Record "Jobs Setup";  //PRJCTPR-365.JS.1.0 08MAY2024  
    begin
        BudgetRemaining := 0;
        NSWorkUnit := 0;      //PRJ-1083.JS.1.0 03Jan2022
        NSWorkUnitofMeasure := '';   //PRJ-1083.JS.1.0 03Jan2022
        clear(NSJobTaskTotalingFilter);
        if Rec."NS_Job No." > '' then begin

            //Fill in JobTask information on the Page if available
            if JobTask.GET(Rec."NS_Job No.", Rec."NS_Job Task No.") then;   //PRJ-1083.JS.1.0 03Jan2022 add rec
            NSWorkUnit := JobTask."NS_Work Units";       //PRJ-1083.JS.1.0 03Jan2022
            NSWorkUnitofMeasure := JobTask."NS_Work Unit of Measure";   //PRJ-1083.JS.1.0 03Jan2022

            //Get previous completion status for the task
            //PRJ-1131.RM.1.0 10Jan2022 start
            if NS_Jobs2.get(Rec."NS_Job No.") then
                if NS_Jobs2."NS_Forecast Method" <> NS_Jobs2."NS_Forecast Method"::"Job Forecast by Task Totals" then begin
                    Rec.NS_GetLastPostedStatus(Rec."NS_Job No.", Rec."NS_Job Task No.", 0D, PreviousJobForecast);
                    Rec.NS_GetJobPlanningLineAndBudget(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, TotalBudget, AsOfDateFilter);
                    Rec.NS_GetBudgetHours(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, Rec."Budgeted Hours", AsOfDateFilter);//PRJ-1131.RM.1.0 10Jan2022
                    Rec.NS_GetJobSumofTotalBudget(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, SumofTotalBudget, AsOfDateFilter);//PRJ-537
                    Rec.NS_GetSumOfTotalCostsUsed(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, SumOfTotalCostsUsed, AsOfDateFilter);//PRJ-537
                end else begin
                    Rec.NS_GetLastPostedStatusFBTT(Rec."NS_Job No.", Rec."NS_Job Task No.", 0D, PreviousJobForecast);
                    Rec.NS_GetJobPlanningLineAndBudgetFBTT(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, TotalBudget, AsOfDateFilter);
                    Rec.NS_GetBudgetHoursFBTT(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, Rec."Budgeted Hours", AsOfDateFilter);
                    Rec.NS_GetJobSumofTotalBudgetFBTT(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, SumofTotalBudget, AsOfDateFilter);
                    Rec.NS_GetSumOfTotalCostsUsedFBTT(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, SumOfTotalCostsUsed, AsOfDateFilter);
                end;
            //PRJ-1131.RM.1.0 10Jan2022 end
            //Total Costs Used

            //PRJ-1015.JS.1.0 06Oct2021 Start
            if NS_Jobs.get(Rec."NS_Job No.") then
                //PRJ-1299.JS.1.0 20APR2022 - Start
                if NS_Jobs."NS_Forecast Method" <> NS_Jobs."NS_Forecast Method"::"Job Forecast by Task Totals" then begin
                    //if NS_Jobs."NS_Include Sub Levels" then begin   //PRJ-1039.JS.1.0 10Nov2021 line commented
                    if ((NS_Jobs."NS_Include Sub Levels") and (NS_Jobs."NS_Job Class" = NS_Jobs."NS_Job Class"::"Master Job")) then begin   //PRJ-1039.JS.1.0 10Nov2021
                        SubLevelTotalBudget := 0;
                        SumOfSubLevelTotalCostUsed := 0;
                        SumOfSubLevelTotalBudgetHours := 0;
                        //PRJ-1131.RM.1.0 10Jan2022 start
                        Rec.NS_GetJobPlanningLineAndBudgetIncludeSubLevels(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, TotalBudget, AsOfDateFilter);
                        Rec.NS_GetBudgetHoursIncludeSubLevels(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, Rec."Budgeted Hours", AsOfDateFilter);
                        Rec.NS_GetJobSubLevelBudgetAmount(Rec."NS_Job No.", Rec."NS_Job Task No.", SubLevelTotalBudget, AsOfDateFilter);
                        //TotalBudget += SubLevelTotalBudget;
                        Rec.NS_GetSumOfJobSubLevelCostUsed(Rec."NS_Job No.", Rec."NS_Job Task No.", SumOfSubLevelTotalCostUsed, AsOfDateFilter);
                        //PRJ-1039.JS.1.0  10Nov2021 Start
                        Rec.NS_GetJobSumofTotalBudgetIncludeSubLevels(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, SumofTotalBudget, AsOfDateFilter);
                        Rec.NS_GetSumOfTotalCostsUsedIncludeSubLevels(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, SumOfTotalCostsUsed, AsOfDateFilter);
                        //PRJ-1039.JS.1.0  10Nov2021 End                   
                    end;
                end else begin
                    if ((NS_Jobs."NS_Include Sub Levels") and (NS_Jobs."NS_Job Class" = NS_Jobs."NS_Job Class"::"Master Job")) then begin   //PRJ-1039.JS.1.0 10Nov2021
                        SubLevelTotalBudget := 0;
                        SumOfSubLevelTotalCostUsed := 0;
                        SumOfSubLevelTotalBudgetHours := 0;
                        //PRJ-1131.RM.1.0 10Jan2022 start
                        Rec.NS_GetJobPlanningLineAndBudgetIncludeSubLevels(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, TotalBudget, AsOfDateFilter);
                        Rec.NS_GetBudgetHoursIncludeSubLevels(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, Rec."Budgeted Hours", AsOfDateFilter);
                        Rec.NS_GetJobSubLevelBudgetAmount(Rec."NS_Job No.", Rec."NS_Job Task No.", SubLevelTotalBudget, AsOfDateFilter);
                        //TotalBudget += SubLevelTotalBudget;
                        Rec.NS_GetSumOfJobSubLevelCostUsed(Rec."NS_Job No.", Rec."NS_Job Task No.", SumOfSubLevelTotalCostUsed, AsOfDateFilter);
                        //PRJ-1039.JS.1.0  10Nov2021 Start
                        Rec.NS_GetJobSumofTotalBudgetIncludeSubLevels(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, SumofTotalBudget, AsOfDateFilter);
                        Rec.NS_GetSumOfTotalCostsUsedIncludeSubLevels(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, SumOfTotalCostsUsed, AsOfDateFilter);
                        //PRJ-1039.JS.1.0  10Nov2021 End                   
                    end;
                end;
            //PRJ-1299.JS.1.0 20APR2022 - Start
            //PRJ-1015.JS.1.0  06Oct2021 end

            //TotalCostsUsed := 0;   //PRJ-1039.JS.1.0 16Dec2021 line commented
            NS_JobTask2.Reset();
            if NS_JobTask2.get(Rec."NS_Job No.", rec."NS_Job Task No.") then;
            if Job.GET(Rec."NS_Job No.") then begin
                //Job.SETRANGE("NS_Job Task No. Filter", Rec."NS_Job Task No.");//PRJ-1131.RM.1.0 10Jan2022
                Job.SETfilter("NS_Job Task No. Filter", NS_JobTask2.Totaling);   //PRJ-1299.JS.1.0 21APR2022

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
                //PRJ-1039.JS.1.0  16Dec2021 Start
                if ((Job."NS_Include Sub Levels" = true) and (Job."NS_Job Class" = Job."NS_Job Class"::"Master Job")) then begin
                    NS_JobNoFilter := '';
                    NS_JobNoFilter := '@*' + Format(Job."No.") + '*';
                    NS_JobsLocal.Reset();
                    NS_JobsLocal.Setfilter("NS_Sub-Level to Job No.", '%1', NS_JobNoFilter);
                    //NS_JobsLocal.Setfilter("NS_Job Task No. Filter", '%1', Rec."NS_Job Task No.");
                    NS_JobsLocal.Setfilter("NS_Job Task No. Filter", NS_JobTask2.Totaling);    //PRJ-1299.JS.1.0 21APR2022
                    if NextBillDate > 0D then begin
                        if DATE2DMY(NextBillDate, 2) < 12 then
                            MonthEndDate := DMY2DATE(1, DATE2DMY(NextBillDate, 2) + 1, DATE2DMY(NextBillDate, 3)) - 1
                        else
                            MonthEndDate := DMY2DATE(31, 12, DATE2DMY(NextBillDate, 3));
                    end;
                    if AsOfDateFilter <> 0D then
                        NS_JobsLocal.SETFILTER("NS_Date Filter", '..%1', AsOfDateFilter)
                    else
                        NS_JobsLocal.SETRANGE("NS_Date Filter");
                    If NS_JobsLocal.FindSet() then
                        repeat
                            NS_JobsLocal.CALCFIELDS("NS_Usage (Cost) (LCY)");
                            TotalCostsUsed := TotalCostsUsed + NS_JobsLocal."NS_Usage (Cost) (LCY)";
                        until NS_JobsLocal.Next() = 0;
                end;
                //PRJ-1039.JS.1.0  16Dec2021 end                
                //TotalCostsUsed += SumOfSubLevelTotalCostUsed;   //PRJ-914.1.0  07Oct2021 PRJ-1039.JS.1.0 15Nov2021
            end;

            //Budget Remaining
            if Rec."NS_Percent Complete" <= 100 then begin//prj-611 add  = //PRJ-1131.RM.1.0 10Jan2022
                BudgetRemaining := TotalBudget - TotalCostsUsed;
                // if BudgetRemaining <= 0 then			//PRJ-611 comment
                //     BudgetRemaining := 0;

                //PRJ-1039.JS.1.0 13Dec2021-Start
                if NS_Jobs.get(Rec."NS_Job No.") then
                    if ((NS_Jobs."NS_Include Sub Levels" = true) and (NS_Jobs."NS_Job Class" = NS_Jobs."NS_Job Class"::"Master Job")) then
                        BudgetPercentageUsed := Rec.NS_CalcPercentFrom0To100IncludeSubLevels(TotalBudget, TotalCostsUsed)
                    else
                        //PRJ-1039.JS.1.0 13Dec2021-end  
                        BudgetPercentageUsed := Rec.NS_CalcPercentFrom0To100(TotalBudget, TotalCostsUsed);//PRJ-1131.RM.1.0 10Jan2022

                //PRJ-545.MS.1.0 open this start  

                if (Rec."NS_Hours To Finish" = 0) then begin//PRJ-1131.RM.1.0 10Jan2022
                    if Rec."NS_Cost To Complete" = 0 then //PRJ-565
                        Rec."NS_Cost To Complete" := Rec.NS_CalcCostToComplete(Rec."NS_Status Date", Rec."NS_Percent Complete", TotalBudget, TotalCostsUsed,
                                                                 PreviousJobForecast."NS_Status Date",
                                                                 PreviousJobForecast."NS_Forecasted Completed Cost")//PRJ-1131.RM.1.0 10Jan2022
                    else
                        //PRJ-1039.JS.1.0  13Dec2021-Start
                        //"NS_Cost To Complete" := Rec."NS_Cost To Complete";    //PRJ-1039.JS.1.0  13Dec2021 Line commented  
                        //PRJCTPR-365.JS.1.0 08MAY2024-Start belwo code commented
                        // Rec."NS_Cost To Complete" := Rec.NS_CalcCostToComplete(Rec."NS_Status Date", Rec."NS_Percent Complete", TotalBudget, TotalCostsUsed,
                        //                                          PreviousJobForecast."NS_Status Date",
                        //                                          PreviousJobForecast."NS_Forecasted Completed Cost");
                        Rec."NS_Cost To Complete" := Rec."NS_Cost To Complete";
                    if NSJobSetup1.Get() then;
                    if NSJobSetup1."NS_Enab. Budg.on Contract Date" then begin
                        Rec."NS_Cost To Complete" := Rec."NS_Cost To Complete";
                    end;
                    //PRJCTPR-365.JS.1.0 08MAY2024-end 
                    //PRJ-1039.JS.1.0  13Dec2021-end                                                                     
                end;

                Rec."NS_Forecasted Completed Cost" := TotalCostsUsed + Rec."NS_Cost To Complete";//PRJ-1131.RM.1.0 10Jan2022

            end;

            if Rec."NS_Percent Complete" <> 100 then begin    //PRJ-1131.RM.1.0 10Jan2022
                ForecastedVariance := TotalBudget - Rec."NS_Forecasted Completed Cost"; //PRJ-1131.RM.1.0 10Jan2022
                //message('DDDD111...%1', TotalBudget - Rec."NS_Forecasted Completed Cost");
            end else begin
                ForecastedVariance := TotalBudget - TotalCostsUsed;
                //message('DDDD222...%1', TotalBudget - TotalCostsUsed);
            end;
            //NS_GetSumofBudgetRemaining(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, SumofBudgetRemaining, AsOfDateFilter, SumofForecastedVariance);//PRJ-537 //PRJ-1015.JS.1.0 commented
            //PRJ-1015.JS.1.0  11Oct2021-Start
            if NS_Jobs.get(Rec."NS_Job No.") then
                //if NS_Jobs."NS_Include Sub Levels" = true then   //PRJ-1039.JS.1.0  12Nov2021 line commented
                if ((NS_Jobs."NS_Include Sub Levels" = true) and (NS_Jobs."NS_Job Class" = NS_Jobs."NS_Job Class"::"Master Job")) then
                    //NS_GetSumofBudgetRemainingSubLevels(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, SumofBudgetRemaining, AsOfDateFilter, SumofForecastedVariance)  //PRJ-1039.JS.1.0  12Nov2021 line commented
                    Rec.NS_GetSumofBudgetRemainingIncludeSubLevelsNew(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, SumofBudgetRemaining, AsOfDateFilter, SumofForecastedVariance)
                else
                    Rec.NS_GetSumofBudgetRemainingFBTT(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, SumofBudgetRemaining, AsOfDateFilter, SumofForecastedVariance);//PRJ-537 //PRJ-1131.RM.1.0 10Jan2022
            //PRJ-1015.JS.1.0  11Oct2021-end              
        end;
    end;

    local procedure NS_StatusDateOnAfterValidate();
    begin
        //PRJ-1131.RM.1.0 10Jan2022 start
        if Rec."NS_Status Date" = 0D then begin
            Rec."NS_Percent Complete" := 0;
            Rec."NS_Units Complete" := 0;
            //PRJ-1131.RM.1.0 10Jan2022 end
            NS_FillInTable;
            CLEAR(JobTask);
            JobTask.CALCFIELDS("Outstanding Orders", "Amt. Rcd. Not Invoiced");
        end;
    end;

    local procedure NS_UnitsCompleteOnAfterValidate();
    begin
        //PRJ-1131.RM.1.0 10Jan2022 start
        if (Rec."NS_Units Complete" > 0) and (JobPlanningLineBudget."NS_Work Units" > 0) then
            Rec."NS_Percent Complete" := ROUND((Rec."NS_Units Complete" / JobPlanningLineBudget."NS_Work Units") * 100, GLSetup."Amount Rounding Precision");
        //else
        //"PP_Percent Complete" := 0; //PRJ-350 comment
        NS_CheckPercentComplete;
        //CTSI-95.MS.1.0 start
        if (Rec."NS_Hours To Finish" <> 0) and (LaborRate <> 0) then //if TotalBudget = 0 then //CTSI-231
            Rec."NS_Cost To Complete" := LaborRate * Rec."NS_Hours To Finish"
        else //CTSI-95.MS.1.0 end 

        Rec."NS_Cost To Complete" := Rec.NS_CalcCostToComplete(Rec."NS_Status Date", Rec."NS_Percent Complete", TotalBudget, TotalCostsUsed,
                                                 PreviousJobForecast."NS_Status Date",
                                                 PreviousJobForecast."NS_Forecasted Completed Cost");
        Rec."NS_Forecasted Completed Cost" := TotalCostsUsed + Rec."NS_Cost To Complete";
        ForecastedVariance := TotalBudget - Rec."NS_Forecasted Completed Cost";
        //PRJ-1131.RM.1.0 10Jan2022
    end;

    local procedure NS_PercentCompleteOnAfterValidate();
    var
        ProjectedCost: Decimal;
        CalcDate: Date;
    begin
        NS_CheckPercentComplete;
        //PRJ-1131.RM.1.0 10Jan2022 start
        if Rec."NS_Status Date" <> 0D then
            CalcDate := Rec."NS_Status Date"
        //PRJ-1131.RM.1.0 10Jan2022 end
        else
            CalcDate := AsOfDateFilter;
        if JobPlanningLineBudget."NS_Work Units" <> 0 then
            Rec."NS_Units Complete" := ROUND(JobPlanningLineBudget."NS_Work Units" * (Rec."NS_Percent Complete" / 100), GLSetup."Amount Rounding Precision")//PRJ-1131.RM.1.0 10Jan2022
        else
            Rec."NS_Units Complete" := 0;//PRJ-1131.RM.1.0 10Jan2022
        if Rec."NS_Percent Complete" < 100 then begin//PRJ-1131.RM.1.0 10Jan2022
                                                     //CTSI-95.MS.1.0 start
                                                     //PRJ-1131.RM.1.0 10Jan2022
            if (Rec."NS_Hours To Finish" <> 0) and (LaborRate <> 0) then// if TotalBudget = 0 then //CTSI-231
                Rec."NS_Cost To Complete" := LaborRate * Rec."NS_Hours To Finish"//PRJ-1131.RM.1.0 10Jan2022
            else //CTSI-95.MS.1.0 end 
                 //PRJ-1131.RM.1.0 10Jan2022 start
                Rec."NS_Cost To Complete" := Rec.NS_CalcCostToComplete(CalcDate, Rec."NS_Percent Complete", TotalBudget, TotalCostsUsed,
                                                     PreviousJobForecast."NS_Status Date",
                                                     PreviousJobForecast."NS_Forecasted Completed Cost");
            Rec."NS_Forecasted Completed Cost" := TotalCostsUsed + Rec."NS_Cost To Complete";
        end else begin
            if Rec."NS_Percent Complete" = 100 then begin
                Rec."NS_Cost To Complete" := 0;
                Rec."NS_Forecasted Completed Cost" := TotalCostsUsed;
            end else begin
                Rec."NS_Cost To Complete" := 0;
                Rec."NS_Forecasted Completed Cost" := PreviousJobForecast."NS_Forecasted Completed Cost";
                //PRJ-1131.RM.1.0 10Jan2022 end
            end;
        end;
        ForecastedVariance := TotalBudget - Rec."NS_Forecasted Completed Cost";//PRJ-1131.RM.1.0 10Jan2022
    end;

    local procedure NS_CostToCompleteOnAfterValidate();
    begin
        //PRJ-1131.RM.1.0 10Jan2022 start
        Rec."NS_Forecasted Completed Cost" := TotalCostsUsed + Rec."NS_Cost To Complete";
        ForecastedVariance := TotalBudget - Rec."NS_Forecasted Completed Cost";
        if Rec."NS_Forecasted Completed Cost" <> 0 then
            //"Percent Complete" := 100 - ROUND(("Cost To Complete" / "Forecasted Completed Cost") * 100,GLSetup."Amount Rounding Precision")
            Rec."NS_Percent Complete" := 100 - (Rec."NS_Cost To Complete" / Rec."NS_Forecasted Completed Cost") * 100
        else
            Rec."NS_Percent Complete" := 0;//PRJ-1131.RM.1.0 10Jan2022 end
        NS_CheckPercentComplete;
        if JobPlanningLineBudget."NS_Work Units" <> 0 then
            Rec."NS_Units Complete" := ROUND(JobPlanningLineBudget."NS_Work Units" * (Rec."NS_Percent Complete" / 100), GLSetup."Amount Rounding Precision")//PRJ-1131.RM.1.0 10Jan2022
        else
            Rec."NS_Units Complete" := 0;//PRJ-1131.RM.1.0 10Jan2022
    end;

    local procedure NS_HoursToFinishOnAfterValidate();
    var
        GLsetep: Record "General Ledger Setup";
    begin
        If GLsetep.Get() then;
        //"Cost To Complete" := ROUND("Hours To Finish" * JobPlanningLineBudget."Unit Cost", GLSetup."Amount Rounding Precision"); //CTSI-21.MS.1.0
        //if jobledEntry.Quantity <> 0 then begin //CTSI-231on hold
        //PRJ-1131.RM.1.0 10Jan2022 start
        if ((jobledEntry.Quantity + Rec."NS_Hours To Finish") <> 0) and (LaborRate <> 0) then //CTSI-21.MS.1.0
            Rec."NS_Percent Complete" := Round(jobledEntry.Quantity * 100 / (jobledEntry.Quantity + Rec."NS_Hours To Finish"), GLsetep."Amount Rounding Precision"); //CTSI-21.MS.1.0
                                                                                                                                                                     //Round("Actual Hours" * 100 / ("Actual Hours" + "Hours To Finish"), GLsetep."Amount Rounding Precision"); //CTSI-21.MS.1.0
                                                                                                                                                                     //PRJ-1131.RM.1.0 10Jan2022 end                                                                                                                        //end else
                                                                                                                                                                     // if "Budgeted Hours" <> 0 then
                                                                                                                                                                     //  "Percent Complete" := ("Budgeted Hours" - "Hours To Finish") * 100 / "Budgeted Hours" //CTSI-231 on hold
    end;

    procedure NS_ForecastedCompletedCostOnAfter();
    begin
        //PRJ-1131.RM.1.0 10Jan2022 start
        if Rec."NS_Percent Complete" < 100 then begin
            //CTSI-95.MS.1.0 start
            if (Rec."NS_Hours To Finish" <> 0) and (LaborRate <> 0) then//if TotalBudget = 0 then //CTSI-231
                Rec."NS_Cost To Complete" := LaborRate * Rec."NS_Hours To Finish"
            else //CTSI-95.MS.1.0 end 
                Rec."NS_Cost To Complete" := Rec."NS_Forecasted Completed Cost" - TotalCostsUsed;
            ForecastedVariance := TotalBudget - Rec."NS_Forecasted Completed Cost";
            if Rec."NS_Forecasted Completed Cost" <> 0 then
                Rec."NS_Percent Complete" := 100 - ROUND((Rec."NS_Cost To Complete" / Rec."NS_Forecasted Completed Cost") * 100, GLSetup."Amount Rounding Precision")
            else
                Rec."NS_Percent Complete" := 0;
            //PRJ-1131.RM.1.0 10Jan2022 end
        end;

        NS_CheckPercentComplete;
        if JobPlanningLineBudget."NS_Work Units" <> 0 then
            Rec."NS_Units Complete" := ROUND(JobPlanningLineBudget."NS_Work Units" * (Rec."NS_Percent Complete" / 100), GLSetup."Amount Rounding Precision")//PRJ-1131.RM.1.0 10Jan2022
        else
            Rec."NS_Units Complete" := 0;//PRJ-1131.RM.1.0 10Jan2022
    end;

    /// <summary>
    /// NS_ListUpdateByTaskTotals.
    /// </summary>
    procedure NS_ListUpdateByTaskTotals();
    var
        StartBillingPeriod: Date;
        EndBillingPeriod: Date;
    begin
        //PRJ-1131.RM.1.0 10Jan2022 start
        Rec.RESET();
        Rec.FILTERGROUP := 2;
        if ViewOpenTaskonly = true then
            Rec.SetFilter("NS_View Open Tasks Only", '%1', true);

        if View100Pctcompltdonly = true then //TM-21.MS.1.0
            Rec.SetFilter("NS_View 100% Completed Only", '<>%1', true)//TM-21.MS.1.0
        else
            Rec.SetFilter("NS_View 100% Completed Only", '%1|%2', true, false);//TM-21.MS.1.0 
        Rec.SETRANGE("NS_Job No.");
        Rec.SETRANGE("NS_Task Manager");
        if CurrentJobNo > '' then
            Rec.SETRANGE("NS_Job No.", CurrentJobNo);
        if CurrentTaskManager > '' then
            Rec.SETRANGE("NS_Task Manager", CurrentTaskManager);
        Rec.SETRANGE(NS_Posted, false);
        Rec.FILTERGROUP := 0;
        if Rec.FINDSET then;
        //Rec.NS_GetNewTasks(CurrentJobNo, CurrentTaskManager);
        Rec.NS_GetNewTasksByTaskTotalsFBTT(CurrentJobNo, CurrentTaskManager);
        Rec."NS_Forecast Method" := Rec."NS_Forecast Method"::"Job Forecast by Task Totals";
        CurrPage.UPDATE(false);
        //PRJ-1131.RM.1.0.001 10Jan2022 end
    end;

    procedure NS_SetBillDate();
    begin
        if (Rec."NS_Bill Date" = 0D) and (NextBillDate > 0D) then//PRJ-1131.RM.1.0 10Jan2022
            Rec.VALIDATE("NS_Bill Date", NextBillDate);//PRJ-1131.RM.1.0 10Jan2022
    end;

    procedure NS_SetStatusDate();
    begin
        if AsOfDateFilter > 0D then
            Rec."NS_Status Date" := AsOfDateFilter;//PRJ-1131.RM.1.0 10Jan2022
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
        PurchLine.SETRANGE("Job No.", Rec."NS_Job No.");//PRJ-1131.RM.1.0 10Jan2022
        PurchLine.SETRANGE("Job Task No.", Rec."NS_Job Task No.");//PRJ-1131.RM.1.0 10Jan2022
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

    /// <summary>
    /// NS_SetTaskTotals.
    /// </summary>
    /// <param name="JobNoIn">Code[20].</param>
    /// <param name="TaskManagerIn">Code[20].</param>
    /// <param name="AsOfDateIn">Date.</param>
    /// <param name="ByTaskTotals">Boolean.</param>
    /// //PRJ-1299.JS.1.0 19APR2022 - Start
    procedure NS_SetTaskTotals(JobNoIn: Code[20]; TaskManagerIn: Code[20]; AsOfDateIn: Date; ByTaskTotals: Boolean);
    begin
        JobNoSentIn := JobNoIn;
        TaskManagerIn := TaskManagerIn;
        AsOfDateSentIn := AsOfDateIn;
        ForecastByTaskTotals := ByTaskTotals;
    end;
    /// //PRJ-1299.JS.1.0 19APR2022 - end

}

