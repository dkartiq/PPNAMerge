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
    //PRJ-1015.JS.1.0  14Oct2021 | Add code to include sub level jobs
    //PRJ-1039.JS.1.0  10Nov2021 | Add Code
    //PRJ-1039.JS.1.0  13Dec2021 | Update Code
    //PRJ-1039.JS.1.0  14Dec2021 | New Units complete editable
    //PRJ-1083.JS.1.0 03Jan2022 | change for work unit and works unit of measure
    //PRJ-1039.JS.2.0 12JAN2022 | change in Job no. filter length and correct statistics
    //PRJ-1328.NK.1.0 20ARP2022 | Code Change
    //PRJ-1355.JS.1.0 23MAY2022 | Change Code
    //PRJ-1454.NK.1.0 12Jan2022 | Added Code
    //PRJCTPR-55.NK.1.0 01feb2022 |added code on Budget percentage used
    //PRJCTPR-56.AS.1.0 Done code to correct Actual hour value disappear issue
    //PE-90.AS.1.0 Added Field
    //PE-134.RM.1.0 07Sept2023 | Added tooltip
    //PE-170.HS.1.0 6Oct2023 | Added Tooltip and Caption
    //PE-170.HS.1.0 10Oct2023  | Added Tooltips 
    Caption = 'Job Forecast Worksheet';
    DataCaptionFields = "NS_Job No.";
    PageType = Worksheet;
    RefreshOnActivate = true;//PE-160.AS.2.0
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
                    // ToolTip = 'Specifies the Job No.:';  //PE-134.RM.1.0 07Sept2023 commented
                    ToolTip = 'Specifies the no. of the job for which job forecast to display.';  //PE-134.RM.1.0 08Sept2023

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
                    // ToolTip = 'Specifies the Job description';  //PE-134.RM.1.0 07Sept2023 commented
                    ToolTip = 'Specifies the Description of the Job based on value defined in Job No. filter.';  //PE-134.RM.1.0 07Sept2023
                }
            }
            group(Control1100773006)
            {
                Caption = ''; //PRJ-144 VT 11-03-20
                field(Manager; CurrentTaskManager)
                {
                    ApplicationArea = All;
                    Caption = 'Manager:';
                    ToolTip = 'Specifies the filter for which job forecast to display.'; //PE-134.RM.1.0 08Sept2023
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
                    // ToolTip = 'Specifies the task manager name';  //PE-134.RM.1.0 07Sept2023 commented
                    ToolTip = 'Specifies the Name of the Manager based on value defined in Manager filter.';  //PE-134.RM.1.0 07Sept2023
                }
            }
            group(Control1100773039)
            {
                Caption = '';//PRJ-144 VT 11-03-20
                field(AsOfDateFilter; AsOfDateFilter)
                {
                    ApplicationArea = All;
                    Caption = 'As of Date Filter:';
                    // ToolTip = 'Specifies the As of Date Filter:';  //PE-134.RM.1.0 07Sept2023 commented
                    ToolTip = 'Specifies the date to which the job forecast to display. Enter the value manually as a mandatory filter.';  //PE-134.RM.1.0 07Sept2023

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
                    // ToolTip = 'Specifies the Next Bill Date:';  //PE-134.RM.1.0 07Sept2023
                    ToolTip = 'Specify the next billing date for the forecast. This field gets auto updated with next month''s end date based on the date defined in "As of Date Filter".';  //PE-134.RM.1.0 07Sept2023

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
                    // ToolTip = 'Specifies the ViewOpenTaskonly';  //PE-134.RM.1.0 07Sept2023 commented
                    //ToolTip = 'Specifies if you want to only see job forecast  for tasks that has value in either of the three columns: Budgeted Costs, Total Costs Used, Estimated Cost to Complete';  //PE-134.RM.1.0 07Sept2023 //PE-262.NC.1.0 05Mar2024 Block
                    ToolTip = 'Specifies if you want to see job forecast only for tasks that have value in the 5 columns: Total Costs Used, Estimated Cost to Complete, Amt Rcd Not Invoiced, and Outstanding Orders.'; //PE-262.NC.1.0 05Mar2024
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
                    // ToolTip = 'Specifies the View100Pctcompltdonly';  //PE-134.RM.1.0 07Sept2023 commented
                    ToolTip = 'Specifies if the tasks that 100 percent complete or marked as "Completed" should be filtered out from the Job Forecast Worksheet.';  //PE-134.RM.1.0 07Sept2023
                    trigger OnValidate()
                    begin
                        NS_ListUpdate();
                    end;
                }

                //PE-47.PS.1.0 21Feb2023 Start 
                field(NS_Complete; Rec.NS_Complete)
                {
                    Caption = 'Set Task To Completed';
                    // ToolTip = 'Setting enabled this field to make all the �Job Task� to completed and will freeze the values on �Job Forecast lines'; //PE-134.RM.1.0 07Sept2023 commented
                    ToolTip = 'Specifies if all the tasks on the Job Forecast should be set to "Completed".';  //PE-134.RM.1.0 07Sept2023
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                        NSJobForecast: Record "NS_Job Forecast";
                        Jobsetup: Record "Jobs Setup";
                    begin
                        Jobsetup.get();
                        //  if Jobsetup."NS_Enable Job Backlog Feature." = true then begin
                        Clear(NSCompletd);
                        NSJobForecast.Reset();
                        NSJobForecast.SetRange("NS_Job No.", Rec."NS_Job No.");
                        if NSJobForecast.FindSet() then begin
                            repeat
                                if Rec.NS_Complete = true then
                                    NSCompletd := true;
                                NSJobForecast.NS_Complete := NSCompletd;
                                NSJobForecast.Modify();
                            until NSJobForecast.Next() = 0;
                        end;
                        CurrPage.Update();

                        // end;
                    end;
                }
                //PE-47.PS.1.0 21Feb2023 End 
            }
            repeater(CSWorkSheet)
            {
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                    // ToolTip = 'Specifies the Job No.'; //PE-134.RM.1.0 07Sept2023 commented
                    ToolTip = 'Specifies the no. of the job for which the job forecast line belongs to.'; //PE-134.RM.1.0 08Sept2023 
                }
                field("Job Task No."; Rec."NS_Job Task No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                    //ToolTip = 'Specifies the Job Task No.';//PE-170.HS.1.0 6Oct2023 commented
                    ToolTip = 'Specifies the number of the job task for which the forecast line belongs to.';//PE-170.HS.1.0 6Oct2023
                }
                field(Description; JobTask.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                    //ToolTip = 'Specifies the Description'; //PE-170.HS.1.0 6Oct2023 commented
                    ToolTip = 'Specifies the description of the Job Task No.'; //PE-170.HS.1.0 6Oct2023 
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
                field(Complete; Rec.NS_Complete) //PRJ-1131.RM.1.0 10Jan2022
                {
                    ApplicationArea = all;
                    Description = 'CTSI.232.MS.1.0';
                    //CTSI-232 New changes  //PRJ-565
                    ToolTip = 'Specifies the forecast line as Completed or not. If set to True, it will update the New Total Percent Complete field as 100%, Estimated Cost to Complete as 0 or blank, and Forecast Completed Cost will be equal to Total Cost Used.';//PE-170.HS.1.0 6Oct2023 
                    trigger OnValidate()
                    begin
                        if AsOfDateFilter = 0D then
                            Error('Please enter "As of Date Filter".');//PRJ-565
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
                    // ToolTip = 'Specifies the Manager'; //PE-134.RM.1.0 07Sept2023 commented
                    ToolTip = 'Specifies the filter for which job forecast to display.';  //PE-134.RM.1.0 07Sept2023
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
                    //ToolTip = 'Specifies the Work Units';//PE-170.HS.1.0 6Oct2023 commented
                    ToolTip = 'Specifies the "Work Units" defined on the Job Task Lines for the corresponding Job Task No.';//PE-170.HS.1.0 6Oct2023 
                }
                field("Work Unit of Measure"; NSWorkUnitofMeasure)    //PRJ-1083.JS.1.0 03Jan2022 change JobPlanningLineBudget."NS_Work Unit of Measure" to NSWorkUnitofMeasure
                {
                    ApplicationArea = All;
                    Caption = 'Work Unit of Measure';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    // ToolTip = 'Specifies the Work Unit of Measure';//PE-170.HS.1.0 6Oct2023 commented
                    Tooltip = 'Specifies the "Work Unit of Measure" assigned at the Work Unit for the corresponding Job Task No. on the Job Task Lines.';//PE-170.HS.1.0 6Oct2023
                }
                field("Previous Status Date"; PreviousJobForecast."NS_Status Date")
                {
                    ApplicationArea = All;
                    Caption = 'Previous Status Date';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    // ToolTip = 'Specifies the Previous Status Date';  //PE-134.RM.1.0 07Sept2023 commented
                    ToolTip = 'Specifies previous posting date of forecast worksheet, which gets updated after you post the job forecast worksheet based on New Status Date entered at that moment. Note: This will be replaced every time a forecast is posted';  //PE-134.RM.1.0 07Sept2023 

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
                    // ToolTip = 'Specifies the Previous Percent Complete';  //PE-134.RM.1.0 07Sept2023 commented
                    ToolTip = 'Specifies previous task Total Percent Complete posted to worksheet. Note: This will be replaced every time a forecast is posted.'; //PE-134.RM.1.0 07Sept2023
                }
                field("Prev Forecast Completed Cost"; PreviousJobForecast."NS_Forecasted Completed Cost")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Previous Forecasted Completed Cost';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    // ToolTip = 'Specifies the Previous Forecasted Completed Cost';  //PE-134.RM.1.0 07Sept2023 commented
                    ToolTip = 'Specifies previous Forecasted Completed Cost posted to worksheet. Note: This will be replaced every time a forecast is posted.';   //PE-134.RM.1.0 07Sept2023
                }
                field("Previous Hours to Finish"; PreviousJobForecast."NS_Hours To Finish")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Previous Hours to Finish';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    //ToolTip = 'Specifies the Previous Hours to Finish';//PE-170.HS.1.0 6Oct2023 commented
                    ToolTip = 'Specifies the previous Hours to Finish value posted to the worksheet.Note: This will be replaced every time a forecast is posted.'; //PE-170.HS.1.0 6Oct2023
                }
                //PE-191.NC.1.0 06Mar2024 Start
                field("NS_Task Manager Comments"; Rec."NS_Task Manager Comments")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the task-wise PM Comments, if any, based on the As of Date Filter defined.';
                }
                //PE-191.NC.1.0 06Mar2024 End

                //PRJ-436.AS.1.0 15JAN2021 begin
                //field("Previous Manager Comment"; PreviousJobForecast."NS_Manager Comments") //PE-191.NC.1.0 06Mar2024 Block
                field("Previous Manager Comment"; PreviousJobForecast."NS_Task Manager Comments") //PE-191.NC.1.0 06Mar2024
                {
                    ApplicationArea = All;
                    Caption = 'Previous Manager Comment';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    //Style = Favorable;
                    //StyleExpr = TRUE;
                    //ToolTip = 'Specifies the Previous Manager Comments'; //PE-191.NC.1.0 11Mar2024 Block
                    ToolTip = 'Specifies the task-wise PM Comments last posted, if any.'; //PE-191.NC.1.0 11Mar2024

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
                    // ToolTip = 'Specifies the Budgeted Costs';  //PE-134.RM.1.0 07Sept2023 commented
                    ToolTip = 'Specifies sum of all "Total Costs" for a Task on job planning lines having Line Type as "Budget" or "Both Budget and Billable"';  //PE-134.RM.1.0 07Sept2023
                }
                field("Total Costs Used"; TotalCostsUsed)
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Total Costs Used';
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    // ToolTip = 'Specifies the Total Costs Used'; //PE-134.RM.1.0 07Sept2023 commented
                    ToolTip = 'Specifies sum of all Total Cost ($) for a Task on job ledger entries having Entry Type as "Usage". This is also referred as Actual Costs.'; //PE-134.RM.1.0 07Sept2023
                }
                field("Budget Remaining"; BudgetRemaining)
                {
                    ApplicationArea = All;
                    Caption = 'Budget Remaining';
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    // ToolTip = 'Specifies the Budget Remaining';  //PE-134.RM.1.0 07Sept2023 commented
                    //ToolTip = 'Specifies the value calculated as "Budgeted Costs - Total Costs Used". This implies that how much budget is left after the actual cost is acquired.';  //PE-134.RM.1.0 07Sept2023 //PE-170.HS.1.0 6Oct2023 commented
                    ToolTip = 'Specifies the budget left after the actual cost gets acquired. The value is calculated as �Budgeted Costs - Total Costs Used�.'; //PE-170.HS.1.0 6Oct2023
                }
                field("Budget Percentage Used"; BudgetPercentageUsed)
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Budget Percentage Used';
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    // ToolTip = 'Specifies the Budget Percentage Used'; //PE-134.RM.1.0 07Sept2023 commented
                    // ToolTip = 'Specifies the value calculated as (Total Cost Used / Budgeted Cost) * 100. This implies that how much budget percentage is left after the actual cost is acquired.';  //PE-134.RM.1.0 07Sept2023 //PE-170.HS.1.0 6Oct2023 commented
                    ToolTip = 'Specifies the budget percentage left after the actual cost gets acquired. The value is calculated as (Total Cost Used / Budgeted Cost) * 100.'; //PE-170.HS.1.0 6Oct2023
                }

                //PE-90.AS.1.0 START
                field(NS_ForecastedCompCostOverride; Rec.NS_ForecastedCompCostOverride)
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    // Editable = false;//PE-270.AS.1.0 comment
                    Editable = GetOverrideEditable;//PE-270.AS.1.0 Add
                    //Style = StrongAccent; //PE-270.JS.1.0 07MAY2024 comment
                    StyleExpr = TRUE;
                    Caption = 'Override Forecasted Completed Cost'; //PE-170.HS.1.0 6Oct2023

                    //ToolTip = 'If defined, then it will override the existing value in Forecasted Completed Cost column on the forecast lines for corresponding job task no. Please note that, this is non-editable here if the �Enable Override Forecast on JFW� on the job card is False and the value will come over from the "Forecast Completed Cost Override" defined on Job Task Lines for the related job task no. including the sub-levels based on their Contract Dates and As of Date Filter defined here on JFW.';//PE-270.AS.1.0 Add
                    ToolTip = 'If defined, it overrides the existing �Forecasted Completed Cost� value for corresponding job task no. Please note that, this is non-editable here if the setup �Enable Override Forecast on JFW� on the job card is False and the value will come over from the "Override Forecast Completed Cost" defined on Job Task Lines for the related job task no. including the sub-levels based on their jobs Contract Dates and As of Date Filter on JFW.'; //PE-270.JS.1.0 06MAY2024
                    trigger OnValidate()
                    var
                    begin
                        //PE-270.AS.3.0 Start 
                        if AsOfDateFilter = 0D then
                            Error('Please enter "As of Date Filter".');

                        NS_ForecastOverrideOnafterValidate();
                        //PE-270.AS.3.0 end
                    end;
                }
                //PE-90.AS.1.0 END
                //PE-282.JS.1.0 22APR2024 - Start
                field("NS_Prev. Forecasted Variance"; Rec."NS_Prev. Forecasted Variance")
                {
                    caption = 'Previous Forecasted Variance';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the variance between the current and the previous forecasted completed costs for a period. The value is calculated as �Forecasted Completed Cost - Previous Forecasted Completed Cost�.';
                }
                //PE-282.JS.1.0 22APR2024 - end
                field("Status Date"; Rec."NS_Status Date")
                {
                    ApplicationArea = All;
                    Caption = 'New Status Date';
                    StyleExpr = TRUE;
                    // ToolTip = 'Specifies the New Status Date';  //PE-134.RM.1.0 07Sept2023 commented
                    ToolTip = 'This gets updated based on the "As of Date Filter”, when either "New Total Percent Complete" entered or "Estimated Cost to Complete" is modified.';  //PE-134.RM.1.0 07Sept2023
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
                    // ToolTip = 'Specifies the New Total Units Complete';  //PE-134.RM.1.0 07Sept2023 commented
                    // ToolTip = 'This is a manual entry field which is defined when no actual work units are posted but no. of units complete for a task is entered.';  //PE-134.RM.1.0 07Sept2023 //PE-170.HS.1.0 6Oct2023 Commented
                    // ToolTip = 'This is a manual entry field which is defined when no actual work units are posted but no. of units complete for a task is entered. It calculates the "New Total Percent Complete" value.'; //PE-170.HS.1.0 6Oct2023 //PE-170.HS.1.0 10Oct2023 Commented
                    ToolTip = 'This is a manual entry field which defines when no actual work units are posted but no. of units complete for a task are entered. It calculates the "New Total Percent Complete" value.'; //PE-170.HS.1.0 10Oct2023 
                    //Editable = false;//CTSI-198  //PRJ-1126.JS.1.0 28JAN2022 line commented
                    Editable = true; //PRJ-1126.JS.1.0 28JAN2022 line added

                    trigger OnValidate();
                    begin
                        // NS_UnitsCompleteOnAfterValidate;//PRJ-527
                        NS_SetBillDate;
                        NS_SetStatusDate;
                        NS_PercentCompleteOnAfterValidate(); //PE-191.NC.1.0 06Mar2024
                    end;
                }
                field("Percent Complete"; Rec."NS_Percent Complete")
                {
                    ApplicationArea = All;
                    Caption = 'New Total Percent Complete';
                    MaxValue = 100;
                    MinValue = 0;
                    // ToolTip = 'Specifies the New Total Percent Complete';  //PE-134.RM.1.0 07Sept2023 commented
                    //ToolTip = 'Specify the new total percentage of a task completion if you disagree with the value coming under "Budget Percent Used" column for the said date period. This field is inter-related with the "Estimated Cost Complete" as well, so if you modify the value for that, then the percentage in this field will get relatively updated as well.';  //PE-134.RM.1.0 07Sept2023 //PE-170.HS.1.0 6Oct2023 Commented
                    ToolTip = 'Specify the new total percentage of a task completion if you disagree with the value coming under �Budget Percent Used� column for the said date period. This field is inter-related with the �Estimated Cost to Complete� as well, so if you modify the value for that, then the percentage in this field will get relatively updated.';//PE-170.HS.1.0 6Oct2023
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
                    // ToolTip = 'Specifies the Estimated Cost To Complete';  //PE-134.RM.1.0 07Sept2023 commented
                    ToolTip = 'This field gets calculated differently under different conditions as defined below: (1) If Previous Status Date = 0D, then "Budgeted Cost - Total Costs Used" If above value comes out to be as negative then, it will be set to 0 instead. (2) If Previous Status Date <> 0D, then "Previous Forecasted Completed Cost - Total Costs" (3) If Previous Status Date <> 0D, and New Total Percent Complete > 0, then "[ (Total Costs Used / New Total Percent Complete) * 100] - Total Cost Used" (4) If above value is 0 and Budgeted Costs > 0, then "(Budgeted Costs / Total New Percent Complete) * Percent Remaining" where, "Percent Remaining = 100 - Total New Percent Complete" => If Total New Percent Complete <>100 (5) If Hours to Finish value is entered, then "Hours to Finish * Labor Rate" Note: that user can modify this field if they disagree with the resulted estimate value for that period. If modified, it will also update the "New Total Percentage" and "New Status Date" accordingly."';  //PE-134.RM.1.0 07Sept2023 

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
                    // ToolTip = 'Specifies the Forecasted Completed Cost';  //PE-134.RM.1.0 07Sept2023 commented
                    ToolTip = 'Specifies the value calculated as "Total Cost Used + Estimated Cost to Complete". This implies that based on the actual cost acquired and the estimated costs, how much cost you expect to be completed as forecast.';  //PE-134.RM.1.0 07Sept2023
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
                    //ToolTip = 'Specifies the Hours To Finish'; //PE-170.HS.1.0 6Oct2023 Commented
                    ToolTip = 'This is a manual entry field which defines the hours required to finish the task and hence, validates the Estimate Cost Complete based on the Labor Rate available for the forecast line.'; //PE-170.HS.1.0 6Oct2023

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
                    //Caption = 'Forecasted Variance';  //PE-282.JS.1.0 21APR2024 line commented
                    Caption = 'Budgeted Forecasted Variance';  //PE-282.JS.1.0 21APR2024 line added
                    Editable = false;
                    // ToolTip = 'Specifies the Forecasted Variance'; //PE-170.HS.1.0 6Oct2023 Commented
                    ToolTip = 'Specifies the variance between the budget and forecast values for a period. The value is calculated as �Budgeted Cost - Forecasted Completed Cost�.'; //PE-170.HS.1.0 6Oct2023 
                }
                //PE-192.NC.1.0 10Apr2024 Start
                field("NS_Earned Billing"; Rec."NS_Earned Billing")
                {
                    ApplicationArea = All;
                    Caption = 'Earned Billing';
                    BlankZero = true;
                    Editable = false;
                    ToolTip = 'Specifies the billing earned based on the percentage of actual and forecasted cost computed with the billable amount for a task. The value gets updated for forecast task lines when using “Calc. Earned Billing” from the ribbon and is calculated as “(Total Costs Used / Forecasted Completed Cost) * 100 * Billable (Total Price)”.';
                }
                //PE-192.NC.1.0 10Apr2024 End
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
                    //Caption = 'PO Expected Receipt Cost'; //PE-191.NC.1.0 06Mar2024 Block
                    Style = Favorable;
                    StyleExpr = TRUE;
                    // ToolTip = 'Specifies the PO Expected Receipt Cost';  //PE-134.RM.1.0 07Sept2023 commented
                    //ToolTip = 'The value of Expected Purchase Receipt of items within the "As of Date" of the forecast';  //PE-134.RM.1.0 07Sept2023 //PE-191.NC.1.0 06Mar2024 Block
                    Editable = false;//CTSI-198
                                     //PE-191.NC.1.0 06Mar2024 Start
                    Caption = 'PO Expected Receipt Cost (Obsolete)';
                    ToolTip = 'This has been obsolete and not in use.';
                    ObsoleteState = Pending;
                    ObsoleteReason = 'Will be removed in next build';
                    ObsoleteTag = 'ProjectPro upcoming release 23.0.XXX.00';
                    Visible = false;
                    //PE-191.NC.1.0 06Mar2024 End
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
                    // ToolTip = 'Specifies the number of outstanding orders for the job task'; //PE-170.HS.1.0 6Oct2023 Commented
                    //ToolTip = 'Specifies the the amount of purchase orders yet to be received based on As of Date Filter applied'; //PE-170.HS.1.0 6Oct2023 //PE-170.HS.1.0 10Oct2023 Commented
                    ToolTip = 'Specifies the amount of purchase orders yet to be received based on As of Date Filter applied'; //PE-170.HS.1.0 10Oct2023 

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
                    //ToolTip = 'Specifies the amount received but not invoiced for the job task'; //PE-170.HS.1.0 6Oct2023 Commented
                    ToolTip = 'Specifies the amount of purchase order items that are received but not invoiced yet based on the As of Date Filter applied'; //PE-170.HS.1.0 6Oct2023

                }
                field("Bill Date"; Rec."NS_Bill Date")
                {
                    ApplicationArea = All;
                    Style = Favorable;
                    StyleExpr = TRUE;
                    //ToolTip = 'Specifies the Bill Date'; //PE-170.HS.1.0 6Oct2023 Commented
                    ToolTip = 'Specifies the Next Bill Date for projected percent to bill. This gets updated when Bill Percent is updated for a forecast line.'; //PE-170.HS.1.0 6Oct2023
                    Editable = false;//CTSI-198
                    //PE-191.NC.1.0 11Mar2024 Start
                    Caption = 'Bill Date (Obsolete)';
                    ObsoleteState = Pending;
                    ObsoleteReason = 'Will be removed in next build';
                    ObsoleteTag = 'ProjectPro upcoming release 23.0.XXX.00';
                    Visible = false;
                    //PE-191.NC.1.0 11Mar2024 End
                }
                field("Bill Percent"; Rec."NS_Bill Percent")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Style = Favorable;
                    StyleExpr = TRUE;
                    // ToolTip = 'Specifies the Bill Percent'; //PE-170.HS.1.0 6Oct2023 Commented
                    ToolTip = 'This is manual entry of the forecasted next billing percentage for this task.'; //PE-170.HS.1.0 6Oct2023
                    Editable = false;//CTSI-198 
                    //PE-191.NC.1.0 11Mar2024 Start
                    Caption = 'Bill Percent (Obsolete)';
                    ObsoleteState = Pending;
                    ObsoleteReason = 'Will be removed in next build';
                    ObsoleteTag = 'ProjectPro upcoming release 23.0.XXX.00';
                    Visible = false;
                    //PE-191.NC.1.0 11Mar2024 End
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
                    // ToolTip = 'Total of all Quanitites for a Task on Budget planning lines for Resources with UOM as HOURS/HR';  //PE-134.RM.1.0 07Sept2023 //PE-170.HS.1.0 6Oct2023 Commented
                    // ToolTip = 'Species the total of all Quanitites for a Task defined with Budget or Both Budget and Billable on job planning lines for Resources with UOM as HOURS/HR.'; //PE-170.HS.1.0 6Oct2023 //PE-170.HS.1.0 10Oct2023 Commented
                    ToolTip = 'Species the total of all Quantities for a Task defined with Budget or Both Budget and Billable on job planning lines for Resources with UOM as HOURS/HR.'; //PE-170.HS.1.0 10Oct2023 
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
                    ToolTip = 'Total Usage of all Quantities posted to job ledger entries for Resources with UOM as HOURS/HR';  //PE-134.RM.1.0 07Sept2023
                    Description = 'CTSI.21.MS.1.0';
                }
                field("Remaining Hours"; "NS_Remaining Hours")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    // ToolTip = 'Specifies the value calculated as "Budgeted Hours - Actual Hours".';  //PE-134.RM.1.0 07Sept2023 //PE-170.HS.1.0 6Oct2023 Commented
                    ToolTip = 'Specifies the variance between budgeted and actual hours. The value is calculated as "Budgeted Hours - Actual Hours".'; //PE-170.HS.1.0 6Oct2023
                    Description = 'CTSI.21.MS.1.0';
                }
                field("Budgeted Hrs Percent Compelete"; "NS_Budgeted Hrs Percent Compelete")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value calculated as "(Actual Hours / Budgeted Hours) *100"';  //PE-134.RM.1.0 07Sept2023
                    Description = 'CTSI.21.MS.1.0';
                }
                field(LaborRate; LaborRate)
                {
                    Caption = 'Labor Rate';
                    ApplicationArea = all;
                    Editable = false;
                    Description = 'CTSI-95.MS.1.0';
                    ToolTip = 'Auto updated from "Labor Rate by Task" List';  //PE-134.RM.1.0 07Sept2023
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
                    ToolTip = 'Specifies the total of Budgeted Costs defined in a forecast based on the date filter applied.'; //PE-170.HS.1.0 6Oct2023
                }
                field(CostUsedTotal; SumOfTotalCostsUsed)
                {
                    Caption = 'Total Cost Used';
                    Visible = true;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;//additional
                    ToolTip = 'Specifies the total of Total Cost Used defined in a forecast based on the date filter applied.';//PE-170.HS.1.0 6Oct2023
                }
                field(BugdRemaTotal; SumofBudgetRemaining)
                {
                    Caption = 'Budget Remaining';
                    Visible = true;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;//additional
                    ToolTip = 'Specifies the total of Budget Remaining defined in a forecast based on the date filter applied.'; //PE-170.HS.1.0 6Oct2023
                }
                field(EstCosttocompTotal; "NS_Total Est. cost to Complete")
                {
                    Caption = 'Estimated Cost to Complete';
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;//additional
                    ToolTip = 'Specifies the total of Estimated Cost to Complete defined in a forecast based on the date filter applied.'; //PE-170.HS.1.0 6Oct2023
                }
                field(ForeCompcostTotal; "NS_Total Forecast Completed Cost")
                {
                    Caption = 'Forecasted Completed Cost';
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;//additional
                                          // ToolTip = 'Specifies the value calculated as "Total Cost Used + Estimated Cost to Complete". This implies that based on the actual cost acquired and the estimated costs, how much cost you expect to be completed as forecast.';  //PE-134.RM.1.0 07Sept2023 //PE-170.HS.1.0 6Oct2023 Commented
                                          //ToolTip = 'Specifies the total of Forecasted Completed Cost defined in a forecast based on the date filter applied.'; //PE-170.HS.1.0 6Oct2023 //PE-170.HS.1.0 10Oct2023 Commented
                    ToolTip = 'Specifies the cost you expect or foresee to be completed based on the actual cost acquired and the estimated costs. The value is calculated as �Total Cost Used + Estimated Cost to Complete�.Note: The value in this column will get overridden if any value is defined in "Override Forecasted Completed Cost" field.'; //PE-170.HS.1.0 10Oct2023 
                }
                field(ForeVariTotal; SumofForecastedVariance)
                {
                    Caption = 'Forecasted Variance';
                    Visible = true;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;//additional
                                          // ToolTip = 'Specifies the value calculated as "Budgeted Cost - Forecasted Completed Cost". This implies that the variance based on the budget you had set and the forecast you have set for the period to be completed.';  //PE-134.RM.1.0 07Sept2023 //PE-170.HS.1.0 6Oct2023 Commented
                    ToolTip = 'Specifies the total of Forecasted Variance defined in a forecast based on the date filter applied.'; //PE-170.HS.1.0 6Oct2023
                }
                //PRJ-436.AS.1.0 15JAN2021 begin
                field("Manager Comment"; Rec."NS_Manager Comments")
                {
                    ApplicationArea = All;
                    Style = Favorable; //PE-191.NC.1.0 06Mar2024
                    StyleExpr = TRUE;  //PE-191.NC.1.0 06Mar2024
                    //ToolTip = 'Specifies the Manager Comments'; //PE-170.HS.1.0 6Oct2023 Commented
                    ToolTip = 'Specifies the last PM Comments added based on the date filter applied.'; //PE-170.HS.1.0 6Oct2023

                    trigger OnValidate();
                    begin
                        NS_SetBillDate();
                        NS_SetStatusDate();
                    end;
                }
                //PRJ-436.AS.1.0 15JAN2021 end
                //PRJ-1454.NK.1.0 13Jan2023 Start
                field(TotalContractValue; TotalContractValue)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    Caption = 'Contract Revenue';
                    // ToolTip = 'Specifies the Contract Revenue'; //PE-170.HS.1.0 6Oct2023 Commented
                    //ToolTip = 'Specfies the total Budgeted Price defined for a job based on the date filter applied.'; //PE-170.HS.1.0 6Oct2023 //PE-170.HS.1.0 10Oct2023 Commented
                    ToolTip = 'Specifies the total Budgeted Price defined for a job based on the date filter applied.'; //PE-170.HS.1.0 10Oct2023 
                }
                //PRJ-1454.NK.1.0 13Jan2023 End
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
                //ToolTip = 'Show statistics'; //PE-170.HS.1.0 6Oct2023 Commented
                ToolTip = 'View statistical information of a forecast for a job.'; //PE-170.HS.1.0 6Oct2023
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
                //ToolTip = 'PM Statistics'; //PE-170.HS.1.0 6Oct2023 Commented
                ToolTip = 'View statistical information for different periods such as: As of Contracted, Previous Month, Current Forecast.'; //PE-170.HS.1.0 6Oct2023

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
            action(NS_PMComments)
            {
                ApplicationArea = All;
                Caption = 'PM Comments';
                Image = Comment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'View or add comments for the record.'; //PE-170.HS.1.0 6Oct2023
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
                //ToolTip = 'Print the job forecast worksheet.'; //PE-170.HS.1.0 6Oct2023 Commented
                ToolTip = 'Prepare the worksheet to print the forecast. This report can be used as Test Report or as Preview Posting, to verify the forecast details task wise as well as forecast summary like Net Cost Variance, Percent of Completion, Revenue Earned and Gross Margin (%)'; //PE-170.HS.1.0 6Oct2023 

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
                //ToolTip = 'View detailed summary of the forecast for a complete job. The details in this view gets updated whenever the forecast is posted. This page includes the percent of completion, revenue earned, recognized profit and percentage as additional information.'; //PE-170.HS.1.0 6Oct2023 //PE-170.HS.1.0 10Oct2023 Commented
                ToolTip = 'View detailed summary of the forecast for a complete job. The detail in this view gets updated whenever the forecast is posted. This page includes the percent of completion, revenue earned, recognized profit and percentage as additional information.'; //PE-170.HS.1.0 10Oct2023 
                //RunObject = Page "Percentage of Completion;
                //RunPageLink = "Job No." = FIELD(job n)
                trigger OnAction()
                var
                    PrctOfComp: Record "NS_Percentage of Completion";
                    JobText: Text;
                    FindPoint: Integer;
                    JobRec: Record Job;     //PRJ-1015.JS.1.0   14Oct2021
                    NSJobNoLen: integer;   //PE-133.JS.1.0 18July2023
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
                            //PE-133.JS.1.0 18July2023 - Start
                            Clear(NSJobNoLen);
                            //PrctOfComp.SetFilter("NS_Job No.", '%1', Rec."NS_Job No.");
                            NSJobNoLen := StrLen(Rec."NS_Job No.");
                            if NSJobNoLen < 17 then
                                PrctOfComp.SetFilter("NS_Job No.", '%1', Rec."NS_Job No." + '*')
                            else
                                PrctOfComp.SetFilter("NS_Job No.", '%1', Rec."NS_Job No.");
                            //PE-133.JS.1.0 18July2023 - Start    
                            Page.RunModal(Page::"NS_Percentage of Completion", PrctOfComp); //PRJ-350
                                                                                            //Page.Run(14021458);
                        end else begin    //PRJ-1015.JS.1.0  14Oct2021
                            Clear(NSJobNoLen);
                            JobText := '';
                            FindPoint := 0;
                            FindPoint := StrPos(Rec."NS_Job No.", '.');
                            if FindPoint > 1 then
                                JobText := CopyStr(Rec."NS_Job No.", 1, FindPoint - 1)
                            else
                                JobText := Rec."NS_Job No.";
                            PrctOfComp.Reset();
                            //PE-133.JS.1.0 18July2023 - Start
                            //PrctOfComp.SetFilter("NS_Job No.", '%1', Rec."NS_Job No.");
                            Clear(NSJobNoLen);
                            NSJobNoLen := StrLen(Rec."NS_Job No.");
                            if NSJobNoLen < 17 then
                                PrctOfComp.SetFilter("NS_Job No.", '%1', Rec."NS_Job No." + '*')
                            else
                                PrctOfComp.SetFilter("NS_Job No.", '%1', Rec."NS_Job No.");
                            //PE-133.JS.1.0 18July2023 - Start                                
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
                ToolTip = 'View the profit analysis of the job, based on job forecast worksheet details. This includes the change in profitability as per the date period defined on the request window.'; //PE-170.HS.1.0 6Oct2023

                //CTSI-94.AS.1.0 10AUG2020 - start
                trigger OnAction();
                var
                    JobTable: Record Job;
                    ReportPerofComp: report "NS_Percentage of CompletionNew";//PRJ-1454.NK.1.0 20Sep2022 Start
                begin
                    //PRJ-1454.NK.1.0 20Sep2022 Start
                    Clear(ReportPerofComp);
                    ReportPerofComp.SetPar(rec."NS_Job No.", AsOfDateFilter, NextBillDate);
                    ReportPerofComp.RunModal();
                    //JobTable.reset;
                    //JobTable.SETRANGE("No.", rec."NS_Job No.");
                    //REPORT.RUNMODAL(REPORT::"NS_Percentage of CompletionNew", true, false, JobTable);
                    //PRJ-1454.NK.1.0 20Sep2022 End
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
                //ToolTip = 'Post the job forecast worksheet.'; //PE-170.HS.1.0 6Oct2023 Commented
                ToolTip = 'Finalize the forecast by posting the amounts for a period.'; //PE-170.HS.1.0 6Oct2023

                trigger OnAction();
                var//CTSI-152.AS.1.0 14Sept2020 Added code
                    jobtable: Record Job;//CTSI-152.AS.1.0 14Sept2020 Added code
                    JobRecSub: Record Job;
                    JobsetupRec: Record "Jobs Setup";
                    ForecastPage: page "NS_Job Forecast Worksheet";
                    UpdateSummDetJFW: Report "NS_UpdateRecRevSummDetailJFW";
                    UpdateSummDetJFW1: Report "NS_UPDRevRecJFW IncludeSubLev";    //PRJ-1015.JS.1.0
                    JobRec: Record job;
                    MasterJob: Record Job;
                    NSSubJobRec: Record job;  //PE-282.JS.1.0 26APR2024
                    NSCheckForSubJobNo: boolean;  //PE-282.JS.1.0 26APR2024
                    NSFilterJobNoForSubLevel: Code[20]; //PE-290.JS.1.0 08July2024
                begin
                    JobsetupRec.get;
                    if JobRec.get(CurrentJobNo) then;
                    clear(NSFilterJobNoForSubLevel); //PE-290.JS.1.0 08July2024
                    NSFilterJobNoForSubLevel := '@*' + CurrentJobNo + '*';  //PE-290.JS.1.0 08July2024 
                    If JobRec."NS_Include Sub Levels" = false then begin     //PRJ-1015.JS.1.0  14Oct2021 add line 
                        //CTSI-285.MS.1.0 start
                        //PE-282.JS.1.0 26APR2024 - Start
                        NSSubJobRec.Reset();
                        //NSSubJobRec.SetRange("No.", JobRec."No.");  //PE-290.JS.1.0 08July2024 line commented 
                        //NSSubJobRec.SetFilter("NS_Sub-Level to Job No.", '<>%1', ''); //PE-290.JS.1.0 08July2024 line commented
                        NSSubJobRec.SetFilter("NS_Sub-Level to Job No.", '%1', NSFilterJobNoForSubLevel); //PE-290.JS.1.0 08July2024 line added
                        if NSSubJobRec.FindFirst() then
                            NSCheckForSubJobNo := true
                        else
                            NSCheckForSubJobNo := false;
                        //PE-282.JS.1.0 26APR2024 - end
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
                            //Rec.NS_PostLines(CurrentJobNo, AsOfDateFilter, NextBillDate); //PRJ-1131.RM.1.0 10Jan2022  //PE-282.JS.1.0 26APR2024 line commented
                            //PE-282.JS.1.0 26APR2024-Start
                            if NSCheckForSubJobNo = true then
                                Rec.NS_PostLines(CurrentJobNo, AsOfDateFilter, NextBillDate)
                            else
                                Rec.NS_PostLinesWithoutConfirmationIncSubLevel(CurrentJobNo, AsOfDateFilter, NextBillDate);
                            //PE-282.JS.1.0 26APR2024-end
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
                            Rec.NS_PostLinesIncludeSubLevels(CurrentJobNo, AsOfDateFilter, NextBillDate); //PRJ-1131.RM.1.0 10Jan2022
                            UpdateSummDetJFW1.SetJobNo(CurrentJobNo, AsOfDateFilter);
                            UpdateSummDetJFW1.Run();
                        END else begin
                            exit;
                        end;
                    end;
                    //PRJ-1015.JS.1.0  14Oct2021 - end
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
                //  ToolTip = 'View the projection list.'; //PE-170.HS.1.0 6Oct2023 Commented
                //ToolTip = 'View or add the projected percentage of a task for the current or future months.'; //PE-170.HS.1.0 6Oct2023 //PE-266.AS.1.0 COMMENTED
                ToolTip = 'View or add the projected percentage of a task for the current or future months based on the PM''s best expectations.';//PE-266.AS.1.0 ADD
            }
            action(GetProjections)
            {
                ApplicationArea = All;
                Caption = 'Get Projections';
                Image = Suggest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                //ToolTip = 'This will update the "New Total Percent Complete" value for a selected task based on the date filter applied and percent defined in the Projection List. This ultimately updated the "Estimated Cost to Complete" and "Forecasted Completed Cost" values as well.'; //PE-170.HS.1.0 6Oct2023  //PE-266.AS.1.0 COMMENTED
                ToolTip = 'This will update the "New Total Percent Complete" value for a selected task based on the date filter applied and the percent defined in the Projection List. This does not complete the calculation but is only suggested values that requires to be updated manually to have the required values calculated.';//PE-266.AS.1.0 ADD

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
                    // LoadProjections.Set(NextBillDate);//PE-266.AS.1.0 COMMENTED
                    LoadProjections.Set(AsOfDateFilter);//PE-266.AS.1.0 ADDED
                    LoadProjections.RUNMODAL();
                    CLEAR(LoadProjections);
                end;
            }

            //PE-73.AS.1.0 START
            action(NS_UpdateEstCost2Compl)
            {
                ApplicationArea = All;
                Caption = 'Update Est. Cost. to Compl.';
                Image = Suggest;
                Promoted = true;
                PromotedCategory = Process;
                //ToolTip = 'The field Estimated Cost to Complete gets equivalent to the value of "Budget Remaining" for all the open task lines';   //PE-133.JS.1.0 18July2023 line commented
                //ToolTip = 'The field "Estimated Cost to Complete" becomes the value of "Budget Remaining" for all the open task lines';  //PE-133.JS.1.0 18July2023 line added //PE-170.HS.1.0 6Oct2023 Commented
                ToolTip = 'This will update the "Estimated Cost to Complete" field with the value of "Budget Remaining" for all open forecast lines.'; //PE-170.HS.1.0 6Oct2023 
                PromotedIsBig = true;

                trigger OnAction();
                var
                    JobForecastLines: Record "NS_Job Forecast";
                    NSPrevJobForecastLines: Record "NS_Job Forecast";
                begin
                    if (CurrentJobNo = '') then
                        Error('Please position the cursor on the correct line');

                    //if CONFIRM('The field Estimated Cost to Complete gets equivalent to the value of "Budget Remaining" for all the open task lines.\Would you like to proceed?') then begin  //PE-133.JS.1.0 18July2023 line commented
                    if CONFIRM('The field "Estimated Cost to Complete" becomes the value of "Budget Remaining" for all the open task lines.\Would you like to proceed?') then begin   //PE-133.JS.1.0 18July2023 line added
                        JobForecastLines.RESET;
                        JobForecastLines.SETRANGE("NS_Job No.", CurrentJobNo);
                        JobForecastLines.SETRANGE(NS_Complete, false);
                        JobForecastLines.SetRange(NS_ForecastedCompCostOverride, 0);//PE-90.AS.1.0
                        IF JobForecastLines.FindSet() THEN
                            repeat
                                //PRJCTPR-345.JS.1.0 22APR2024 - Start
                                if JobForecastLines.NS_BudgetRem > 0 then
                                    JobForecastLines."NS_Cost To Complete" := JobForecastLines.NS_BudgetRem
                                else
                                    JobForecastLines."NS_Cost To Complete" := 0;
                                //PRJCTPR-345.JS.1.0 22APR2024 - end        
                                JobForecastLines.Modify();
                            until JobForecastLines.Next() = 0;
                        CurrPage.Update();
                    end;
                    //PE-282.JS.1.0 30APR2024-Start
                    JobForecastLines.Reset();
                    JobForecastLines.SetRange("NS_Job No.", CurrentJobNo);
                    JobForecastLines.SetRange(NS_Complete, false);
                    IF JobForecastLines.FindSet() then
                        repeat
                            NSPrevJobForecastLines.Reset();
                            NSPrevJobForecastLines.SetRange("NS_Job No.", JobForecastLines."NS_Job No.");
                            NSPrevJobForecastLines.SetRange("NS_Job Task No.", JobForecastLines."NS_Job Task No.");
                            NSPrevJobForecastLines.SetRange("NS_Line No.", JobForecastLines."NS_Line No." - 1);
                            if NSPrevJobForecastLines.FindFirst() then
                                if NSPrevJobForecastLines."NS_Forecasted Completed Cost" <> 0 then
                                    JobForecastLines."NS_Prev. Forecasted Variance" :=
                                     JobForecastLines."NS_Forecasted Completed Cost" - NSPrevJobForecastLines."NS_Forecasted Completed Cost";
                            JobForecastLines.Modify();
                        until JobForecastLines.next() = 0;
                    //PE-282.JS.1.0 30APR2024-End
                end;
            }
            //PE-73.AS.1.0 END
            action(CalcExpectedReceiptCosts)
            {
                ApplicationArea = All;
                //Caption = 'Calc Expected Receipt Costs'; //PE-191.NC.1.0 06Mar2024 Block
                Image = CalculateLines;
                Promoted = true;
                PromotedCategory = Process;
                //PE-191.NC.1.0 06Mar2024 Start
                //ToolTip = 'Calculate the Expected Receipt Costs';
                Caption = 'Calc Expected Receipt Costs (Obsolete)';
                ToolTip = 'This has been obsolete and not in use.';
                ObsoleteState = Pending;
                ObsoleteReason = 'Will be removed in next build';
                ObsoleteTag = 'ProjectPro upcoming release 23.0.XXX.00';
                Visible = false;
                //PE-191.NC.1.0 06Mar2024 End
                trigger OnAction();
                var
                    JobForecastLines: Record "NS_Job Forecast";
                    NS_Jobs: Record Job;    //PRJ-1015.JS.1.0   19Oct2021
                begin
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
                                            JobForecastLines."NS_PO Expected Receipt Cost" := JobTask.NS_POsRecdAndOtstndngByExptRcptDate(JobForecastLines."NS_Job No.", JobForecastLines."NS_Job Task No.", NextBillDate);
                                            if JobForecastLines."NS_PO Expected Receipt Cost" > 0 then begin
                                                JobForecastLines."NS_Bill Date" := NextBillDate;
                                                JobForecastLines.NS_GetJobPlanningLineAndBudget(JobForecastLines."NS_Job No.", JobForecastLines."NS_Job Task No.", JobPlanningLineBudget, TotalTaskBudget, AsOfDateFilter);
                                                if TotalTaskBudget <> 0 then begin
                                                    JobCostsUsed := 0;
                                                    if Job.GET(Rec."NS_Job No.") then begin
                                                        Job.SETRANGE("NS_Job Task No. Filter", JobForecastLines."NS_Job Task No.");
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
                                                JobForecastLines.NS_GetJobPlanningLineAndBudget(Rec."NS_Job No.", JobForecastLines."NS_Job Task No.", JobPlanningLineBudget, TotalBudget, AsOfDateFilter);
                                                TotalCostsUsed := 0;
                                                if Job.GET(Rec."NS_Job No.") then begin
                                                    Job.SETRANGE("NS_Job Task No. Filter", JobForecastLines."NS_Job Task No.");
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
                                                BudgetPercentageUsed := JobForecastLines.NS_CalcPercentFrom0To100(TotalBudget, TotalCostsUsed);
                                                if BudgetPercentageUsed > 100 then
                                                    // BudgetPercentageUsed := 100; //PRJCTPR-55.NK.1.0 Start 01feb2022 comment by nitesh
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
                                                        Job.SETRANGE("NS_Job Task No. Filter", JobForecastLines."NS_Job Task No.");
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
                                                    Job.SETRANGE("NS_Job Task No. Filter", JobForecastLines."NS_Job Task No.");
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
                                                    //  BudgetPercentageUsed := 100; //PRJCTPR-55.NK.1.0 Start 01feb2022 comment by nitesh
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
                //Caption = 'Calc Billing Amount'; //PE-192.NC.1.0 10Apr2024 Block
                Caption = 'Calc. Earned Billing'; //PE-192.NC.1.0 10Apr2024
                Image = CalculateLines;
                Promoted = true;
                PromotedCategory = Process;
                //ToolTip = 'Calculate the billing amount'; //PE-192.NC.1.0 10Apr2024 Block
                ToolTip = 'This will update the “Earned Billing” value for all forecast lines.'; //PE-192.NC.1.0 10Apr2024
                trigger OnAction();
                begin
                    //if (CurrentJobNo > '') and (NextBillDate > 0D) then begin //PE-192.NC.1.0 10Apr2024 Block
                    if (CurrentJobNo > '') and (AsOfDateFilter > 0D) then begin //PE-192.NC.1.0 10Apr2024 
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
        NSJobNoLen: integer;   //PE-133.JS.1.0 17July2023 line added
        CommentLine: Record "Comment Line"; //PE-191.NC.1.0 06Mar2024
    begin
        //PE-270.AS.1.0 start
        if Job_G.get(Rec."NS_Job No.") then;
        if Job_G.NS_EnableOverrideForecastonJFW = true then
            GetOverrideEditable := true;
        if Job_G.NS_EnableOverrideForecastonJFW = false then
            GetOverrideEditable := false;
        //PE-270.AS.1.0 end;

        if rec."NS_Job No." <> '' then Begin     //PE-133.JS.1.0 17July2023 line added
            NSJobNofilter := '';
            //PE-133.JS.1.0 17July2023 - Start
            clear(NSJobNoLen);
            //NSJobNofilter := '@*' + format(Rec."NS_Job No.") + '*';
            NSJobNoLen := StrLen(Rec."NS_Job No.");
            if NSJobNoLen < 17 then
                NSJobNofilter := '@*' + format(Rec."NS_Job No.") + '*'
            else
                if (NSJobNoLen > 17) and (NSJobNoLen <= 20) then
                    NSJobNofilter := Rec."NS_Job No.";
            //PE-133.JS.1.0 17July2023 - end 
            NSWorkUnit := 0;    //PRJ-1083.JS.1.0 03Jan2022
            NSWorkUnitofMeasure := ''; //PRJ-1083.JS.1.0 03Jan2022
            //PE-282.JS.1.0 12APR2024 - Start
            if AsOfDateFilter > 0D then
                rec."NS_Status Date" := AsOfDateFilter;
            //PE-282.JS.1.0 12APR2024 - end               
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
            //if (TotalBudget <> 0) or (TotalCostsUsed <> 0) or (Rec."NS_Cost To Complete" <> 0) then //CTSI-MS.1.0 //PRJ-1131.RM.1.0 10Jan2022  //PE-262.NC.1.0 05Mar2024 Block
            if (TotalBudget <> 0) or (TotalCostsUsed <> 0) or (Rec."NS_Cost To Complete" <> 0) or (JobTask."Outstanding Orders" <> 0) or (JobTask."Amt. Rcd. Not Invoiced" <> 0) then //PE-262.NC.1.0 05Mar2024
                Rec."NS_View Open Tasks Only" := true;//PRJ-1131.RM.1.0 10Jan2022

            //TM-21.MS.1.0 start
            //if BudgetPercentageUsed = 100 then //PRJCTPR-55.NK.1.0 Start 01feb2022 comment by nitesh
            if BudgetPercentageUsed >= 100 then //PRJCTPR-55.NK.1.0 Start 01feb2022
                Rec."NS_View 100% Completed Only" := true;//PRJ-1131.RM.1.0 10Jan2022
                                                          //TM-21.MS.1.0 end
                                                          //PE-191.NC.1.0 06Mar2024 Start
            CommentLine.Reset();
            CommentLine.setfilter("Table Name", '%1', CommentLine."Table Name"::Job);
            CommentLine.SetRange("No.", Rec."NS_Job No.");
            if AsOfDateFilter <> 0D then
                CommentLine.SetRange(Date, AsOfDateFilter);
            if CommentLine.FindLast() then
                Rec."NS_Manager Comments" := CommentLine.Comment;
            //PE-191.NC.1.0 06Mar2024 End
            //PRJ-565.AS.1.0 12MARCH2021- COMMENT START
            // if (Complete = false) and (PreviousJobForecast."Hours To Finish" > 0) and (Rec."Hours To Finish" = 0) then
            //     CalCulateHoursToFinish(rec, JobLedEntry);//PRJ-565
            //PRJ-565.AS.1.0 12MARCH2021- COMMENT END

            //PE-160.AS.3.0 START
            if ((NSJobs."NS_Include Sub Levels" = false) and (NSJobs."NS_Job Class" = NSJobs."NS_Job Class"::SubJob)) then begin
                if Rec."NS_Status Date" = 0D then
                    Rec."NS_Cost To Complete" := Rec.NS_BudgetRem;
                Rec."NS_Forecasted Completed Cost" := Rec."NS_Cost To Complete" + TotalCostsUsed;
            end;
            //PE-160.AS.3.0 END
            Rec.CalcFields("NS_Total Forecast Completed Cost");//PE-160.AS.1.0
            //PE-282.JS.1.0 22APR2024 - Start
            if PreviousJobForecast."NS_Forecasted Completed Cost" <> 0 then
                rec."NS_Prev. Forecasted Variance" := rec."NS_Forecasted Completed Cost" - PreviousJobForecast."NS_Forecasted Completed Cost";
            //PE-282.JS.1.0 22APR2024 - end
            Rec.Modify();//PRJ-1131.RM.1.0 10Jan2022
            Commit();
            //CTSI-192.MS.1.0 end
        end;   //PE-133.JS.1.0 17July2023 
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
        NSWorkUnit := 0;            //PRJ-1083.JS.1.0  03Jan2022
        NSWorkUnitofMeasure := '';  //PRJ-1083.JS.1.0  03Jan2022

    end;

    trigger OnOpenPage();
    var
        PreviousJobForecastNew: Record "NS_Job Forecast";
        PreviousJobForecastNew2: Record "NS_Job Forecast";
    begin
        GetOverrideEditable := true;//PE-270.AS.1.0
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
    var
        NS_JobNoFilter: Code[30];   //PRJ-1015.JS.1.0  19Oct2021  //PRJ-1039.JS.2.0 12JAN2022
        NS_Jobs: Record Job;  //PRJ-1015.JS.1.0  19Oct2021
        JobLedEntry11: Record "Job Ledger Entry";//PRJCTPR-56.AS.1.0
    begin
        //PE-270.AS.1.0 start
        if Job_G.get(Rec."NS_Job No.") then;
        if Job_G.NS_EnableOverrideForecastonJFW = true then
            GetOverrideEditable := true;
        if Job_G.NS_EnableOverrideForecastonJFW = false then
            GetOverrideEditable := false;
        //PE-270.AS.1.0 end;
        //PE-282.JS.1.0 12APR2024 - Start
        if AsOfDateFilter > 0D then
            rec."NS_Status Date" := AsOfDateFilter;
        //PE-282.JS.1.0 12APR2024 - end    
        //Note : - Never use modify for any JobLedEntry variable, as it will manipulate page level date
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
                    //PRJCTPR-56.AS.1.0 START Added
                    JobLedEntry11.Reset();
                    JobLedEntry11.SetCurrentKey("Job No.", "Job Task No.", Type, "Entry Type", "Unit of Measure Code", "Posting Date");
                    JobLedEntry11.SetRange("Job No.", Rec."NS_Job No.");
                    JobLedEntry11.SetRange("Job Task No.", Rec."NS_Job Task No.");
                    JobLedEntry11.SetFilter(Type, '%1', JobLedEntry.Type::Resource);
                    JobLedEntry11.SetFilter("Entry Type", '%1', JobLedEntry."Entry Type"::Usage);
                    JobLedEntry11.SetFilter("Unit of Measure Code", '%1|%2', 'HR', 'HOUR');
                    JobLedEntry11.SetFilter("Posting Date", '%1..%2', 0D, AsOfDateFilter);
                    JobLedEntry11.CalcSums(Quantity);
                    //PRJCTPR-56.AS.1.0 END Added

                    JobLedEntry.Reset();
                    JobLedEntry.SetCurrentKey("Job No.", "Job Task No.", Type, "Entry Type", "Unit of Measure Code", "Posting Date");
                    //PRJCTPR-56.AS.1.0 START Commented
                    // //JobLedEntry.Setfilter("Job No.", '%1', NS_JobNoFilter);    //PRJ-1039.JS.1.0 13Dec2021 line commented
                    //JobLedEntry.SetFilter("NS_Sub-Level to Job No.", '%1', NS_JobNoFilter);   //PRJ-1039.JS.1.0 13Dec2021 line added
                    //JobLedEntry.SetRange("Job Task No.", Rec."NS_Job Task No.");
                    //PRJCTPR-56.AS.1.0 END Commented

                    //PRJCTPR-56.AS.1.0 START Added
                    JobLedEntry.SetRange("NS_Sub-Level to Job No.", Rec."NS_Job No.");
                    JobLedEntry.SetRange("Job Task No.", Rec."NS_Job Task No.");
                    //PRJCTPR-56.AS.1.0 END Added
                    JobLedEntry.SetFilter(Type, '%1', JobLedEntry.Type::Resource);
                    JobLedEntry.SetFilter("Entry Type", '%1', JobLedEntry."Entry Type"::Usage);
                    //JobLedEntry.SetFilter("Unit of Measure Code", '%1', 'HR');//PRJ-1524.GK.1.0 25July2022
                    JobLedEntry.SetFilter("Unit of Measure Code", '%1|%2', 'HR', 'HOUR');//PRJ-1524.GK.1.0 25July2022
                    JobLedEntry.SetFilter("Posting Date", '%1..%2', 0D, AsOfDateFilter);
                    JobLedEntry.CalcSums(Quantity);
                    JobLedEntry.Quantity := JobLedEntry.Quantity + JobLedEntry11.Quantity;//PRJCTPR-56.AS.1.0 Added
                end else begin
                    //PRJCTPR-56.AS.1.0 START Added
                    JobLedEntry11.Reset();
                    JobLedEntry11.SetCurrentKey("Job No.", "Job Task No.", Type, "Entry Type", "Unit of Measure Code");
                    JobLedEntry11.SetRange("Job No.", Rec."NS_Job No.");
                    JobLedEntry11.SetRange("Job Task No.", Rec."NS_Job Task No.");
                    JobLedEntry11.SetFilter(Type, '%1', JobLedEntry.Type::Resource);
                    JobLedEntry11.SetFilter("Entry Type", '%1', JobLedEntry."Entry Type"::Usage);
                    JobLedEntry11.SetFilter("Unit of Measure Code", '%1|%2', 'HR', 'HOUR');
                    JobLedEntry11.CalcSums(Quantity);
                    //PRJCTPR-56.AS.1.0 END Added

                    JobLedEntry.Reset();
                    JobLedEntry.SetCurrentKey("Job No.", "Job Task No.", Type, "Entry Type", "Unit of Measure Code");
                    //PRJCTPR-56.AS.1.0 START Commented
                    // //JobLedEntry.Setfilter("Job No.", '%1', NS_JobNoFilter);     //PRJ-1039.JS.1.0 13Dec2021 line commented
                    //JobLedEntry.SetFilter("NS_Sub-Level to Job No.", '%1', NS_JobNoFilter);   //PRJ-1039.JS.1.0 13Dec2021 line added
                    //PRJCTPR-56.AS.1.0 END Commented

                    JobLedEntry.SetRange("NS_Sub-Level to Job No.", Rec."NS_Job No.");//PRJCTPR-56.AS.1.0 Added
                    JobLedEntry.SetRange("Job Task No.", Rec."NS_Job Task No.");
                    JobLedEntry.SetFilter(Type, '%1', JobLedEntry.Type::Resource);
                    JobLedEntry.SetFilter("Entry Type", '%1', JobLedEntry."Entry Type"::Usage);
                    //JobLedEntry.SetFilter("Unit of Measure Code", '%1', 'HR');//PRJ-1524.GK.1.0 25July2022
                    JobLedEntry.SetFilter("Unit of Measure Code", '%1|%2', 'HR', 'HOUR');//PRJ-1524.GK.1.0 25July2022
                    JobLedEntry.CalcSums(Quantity);
                    JobLedEntry.Quantity := JobLedEntry.Quantity + JobLedEntry11.Quantity;//PRJCTPR-56.AS.1.0 Added
                end;
                //PRJ-1015.JS.1.0  19Oct2021  end
            end;
        //CTSI-21.MS.1.0 end

        Rec.CalcFields("NS_Total Forecast Completed Cost");//PE-160.AS.1.0
    end;

    //PE-287.JS.1.0 28APR2024-Start
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if (CloseAction in [ACTION::OK, ACTION::LookupOK]) then begin
            if rec."NS_Status Date" <> 0D then
                NS_JFWUpdForecastCompletedCostonJobTask(Rec);
        end;
    end;
    //PE-287.JS.1.0 28APR2024-End

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
        UpdEstCost2Compl: Boolean;//PE-73.AS.1.0	   
        SumofTotalBudget: Decimal;//PRJ-537.MS.1.0;1
        SumOfTotalCostsUsed: Decimal;//PRJ-537.MS.1.0;2
        SumofBudgetRemaining: Decimal;//PRJ-537.MS.1.0;3
        SumofForecastedVariance: Decimal;//PRJ-537.MS.1.0;4
        PMStatistic: page "NS_PM Statistics";//CTSI-269
        calculated: Boolean;

        SubLevelTotalBudget: Decimal;   //PRJ-1015.JS.1.0 06Oct2021
        SumOfSubLevelTotalCostUsed: Decimal;  //PRJ-1015.JS.1.0 07Oct2021
        SumOfSubLevelTotalBudgetHours: Decimal;   //PRJ-1015.JS.1.0 21Oct2021
        NSWorkUnit: Decimal;            //PRJ-1083.JS.1.0  03Jan2022
        NSWorkUnitofMeasure: Code[20];  //PRJ-1083.JS.1.0  03Jan2022
        TotalContractValue: Decimal; //PRJ-1454.NK.1.0 12Jan2023

        NSCompletd: Boolean;//PE-47.PS.1.0 21Feb2023

        GetOverrideEditable: Boolean;//PE-270.AS.1.0
        Job_G: Record Job;//PE-270.AS.1.0

    procedure NS_FillInTable();
    var
        UseRecord: Boolean;
        NS_Jobs: Record Job;     //PRJ-914.1.0  06Oct2021
        NS_JobsLocal: Record Job;    //PRJ-1039.JS.1.0  16Dec2021
        NS_JobNoFilter: Code[30];   //PRJ-1039.JS.1.0  16Dec2021  //PRJ-1039.JS.2.0 12JAN2022      
    begin
        clear(TotalContractValue);   //PE-287.JS.1.0 13MAY2024
        BudgetRemaining := 0;
        NSWorkUnit := 0;      //PRJ-1083.JS.1.0 03Jan2022
        NSWorkUnitofMeasure := '';   //PRJ-1083.JS.1.0 03Jan2022        
        if Rec."NS_Job No." > '' then begin

            //Fill in JobTask information on the Page if available
            if JobTask.GET(Rec."NS_Job No.", Rec."NS_Job Task No.") then;   //PRJ-1083.JS.1.0 03Jan2022 add rec
            NSWorkUnit := JobTask."NS_Work Units";       //PRJ-1083.JS.1.0 03Jan2022
            NSWorkUnitofMeasure := JobTask."NS_Work Unit of Measure";   //PRJ-1083.JS.1.0 03Jan2022

            //Get previous completion status for the task
            //PRJ-1131.RM.1.0 10Jan2022 start
            Rec.NS_GetLastPostedStatus(Rec."NS_Job No.", Rec."NS_Job Task No.", 0D, PreviousJobForecast);
            Rec.NS_GetJobPlanningLineAndBudget(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, TotalBudget, AsOfDateFilter);
            Rec.NS_GetBudgetHours(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, Rec."Budgeted Hours", AsOfDateFilter);//PRJ-1131.RM.1.0 10Jan2022
            Rec.NS_GetJobSumofTotalBudget(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, SumofTotalBudget, AsOfDateFilter);//PRJ-537
            Rec.NS_GetSumOfTotalCostsUsed(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, SumOfTotalCostsUsed, AsOfDateFilter);//PRJ-537
            //PRJ-1131.RM.1.0 10Jan2022 end
            //Total Costs Used

            //PRJ-1015.JS.1.0 06Oct2021 Start
            if NS_Jobs.get(Rec."NS_Job No.") then
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
            //PRJ-1015.JS.1.0  06Oct2021 end

            //TotalCostsUsed := 0;   //PRJ-1039.JS.1.0 16Dec2021 line commented
            if Job.GET(Rec."NS_Job No.") then begin
                Job.SETRANGE("NS_Job Task No. Filter", Rec."NS_Job Task No.");//PRJ-1131.RM.1.0 10Jan2022
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
                    NS_JobsLocal.Setfilter("NS_Job Task No. Filter", '%1', Rec."NS_Job Task No.");
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
                        //PRJ-1355.JS.1.0 23MAY2022-Start
                        //PRJCTPR-44.AS.1.O START COMMENT
                        // IF NS_Jobs."NS_Include Sub Levels" = false then
                        //     Rec."NS_Cost To Complete" := Rec."NS_Cost To Complete" //PRJ-1039.JS.1.0  13Dec2021 Line commented  //PRJ-1328.NK.1.0 20ARP2022 Unblock
                        // else
                        //     Rec."NS_Cost To Complete" := Rec.NS_CalcCostToComplete(Rec."NS_Status Date", Rec."NS_Percent Complete", TotalBudget, TotalCostsUsed,
                        //                                              PreviousJobForecast."NS_Status Date",
                        //                                              PreviousJobForecast."NS_Forecasted Completed Cost"); //PRJ-1328.NK.1.0 20ARP2022 Block
                        //                                                                                                   //PRJ-1039.JS.1.0  13Dec2021-end
                        //                                                                                                   //PRJ-1454.NK.1.0 12Jan2022 Start

                        //PRJCTPR-44.AS.1.O END COMMENT

                        //PRJCTPR-44.AS.1.O START Added
                        Rec."NS_Cost To Complete" := Rec."NS_Cost To Complete";
                    //PRJCTPR-44.AS.1.O END Added
                    if Jobsetup.Get() then;
                    //PE-133.JS.1.0 17July2023 - Start
                    if Jobsetup."NS_Enab. Budg.on Contract Date" then begin
                        //if PreviousJobForecast."NS_Forecasted Completed Cost" = 0 then
                        //    Rec."NS_Cost To Complete" := TotalBudget;
                        Rec."NS_Cost To Complete" := Rec."NS_Cost To Complete";
                    end;
                    //PE-133.JS.1.0 17July2023 - end                                                                                                         //PRJ-1355.JS.1.0 23MAY2022-end                                                                                                                                                                       
                    //PRJ-1454.NK.1.0 12Jan2022 End
                end;
                //PRJCTPR-329.NC.1.0 04Mar2024 Start
                if Rec.NS_ForecastedCompCostOverride <> 0 then
                    Rec."NS_Forecasted Completed Cost" := TotalCostsUsed + Rec.NS_ForecastedCompCostOverride
                else
                    //PRJCTPR-329.NC.1.0 04Mar2024 End
                    Rec."NS_Forecasted Completed Cost" := TotalCostsUsed + Rec."NS_Cost To Complete";//PRJ-1131.RM.1.0 10Jan2022
                TotalContractValue := GetPlanningLineIncludeSubLevels(0D, AsOfDateFilter, Rec."NS_Job No."); //PRJ-1454.NK.1.0 13Jan2023  

                //PE-282.JS.1.0 22APR2024 - Start
                if PreviousJobForecast."NS_Forecasted Completed Cost" <> 0 then
                    rec."NS_Prev. Forecasted Variance" := rec."NS_Forecasted Completed Cost" - PreviousJobForecast."NS_Forecasted Completed Cost";
                //PE-282.JS.1.0 22APR2024 - end

            end;

            //PRJCTPR-325.AS.1.0 START COMMENT
            // //PE-90.AS.1.0 START
            // IF Rec.NS_ForecastedCompCostOverride <> 0 then begin
            //     IF ((Job."NS_Job Class" = Job."NS_Job Class"::"Master Job")) then begin
            //         Clear(Rec.NS_ForecastedCompCostOverride);
            //         Rec.NS_ForecastedCompCostOverride := Rec.NS_GetForecastOverrideTotalsWithoutContractDate(Rec."NS_Job No.", Rec."NS_Job Task No.") + Rec.NS_GetForecastOverrideTotalsWithContractDate(0D, AsOfDateFilter, Rec."NS_Job No.", Rec."NS_Job Task No.");

            //         Rec."NS_Cost To Complete" := Rec.NS_ForecastedCompCostOverride - TotalCostsUsed;
            //         Rec."NS_Forecasted Completed Cost" := Rec."NS_Cost To Complete" + TotalCostsUsed;
            //     end;
            // end;
            // //PE-90.AS.1.0 END
            //PRJCTPR-325.AS.1.0 END COMMENT

            //PRJCTPR-325.AS.1.0 START ADD
            IF ((Job."NS_Job Class" = Job."NS_Job Class"::"Master Job")) then begin
                //PE-270.AS.3.0 START Add
                if Job.NS_EnableOverrideForecastonJFW = true then begin
                    if Rec.NS_ForecastedCompCostOverride <> 0 then begin
                        Rec.NS_ForecastedCompCostOverride := Rec.NS_ForecastedCompCostOverride;

                        if Rec."NS_Percent Complete" <> 100 then begin
                            if TotalCostsUsed > 0 then begin  //PRJCTPR-345.JS.1.0 22APR2024 line commented
                                Rec."NS_Cost To Complete" := Rec.NS_ForecastedCompCostOverride - TotalCostsUsed;
                                Rec."NS_Forecasted Completed Cost" := Rec."NS_Cost To Complete" + TotalCostsUsed;
                            end;  //PRJCTPR-345.JS.1.0 22APR2024 line added
                        end;

                        if Rec."NS_Percent Complete" = 100 then begin
                            Rec."NS_Cost To Complete" := 0;
                            Rec."NS_Forecasted Completed Cost" := Rec.NS_ForecastedCompCostOverride;
                        end
                    end;
                end;

                if Job.NS_EnableOverrideForecastonJFW = false then begin
                    if Rec.NS_ForecastedCompCostOverride <> 0 then begin
                        Rec.NS_ForecastedCompCostOverride := Rec.NS_ForecastedCompCostOverride;

                        if Rec."NS_Percent Complete" <> 100 then begin
                            Rec."NS_Cost To Complete" := Rec.NS_ForecastedCompCostOverride - TotalCostsUsed;
                            Rec."NS_Forecasted Completed Cost" := Rec."NS_Cost To Complete" + TotalCostsUsed;

                        end;

                        if Rec."NS_Percent Complete" = 100 then begin
                            Rec."NS_Cost To Complete" := 0;
                            Rec."NS_Forecasted Completed Cost" := Rec.NS_ForecastedCompCostOverride;
                        end
                    end;

                    if Rec.NS_ForecastedCompCostOverride = 0 then begin
                        Clear(Rec.NS_ForecastedCompCostOverride);
                        Rec.NS_ForecastedCompCostOverride := Rec.NS_GetForecastOverrideTotalsWithoutContractDate(Rec."NS_Job No.", Rec."NS_Job Task No.") + Rec.NS_GetForecastOverrideTotalsWithContractDate(0D, AsOfDateFilter, Rec."NS_Job No.", Rec."NS_Job Task No.");

                        if Rec.NS_ForecastedCompCostOverride <> 0 then begin
                            if Rec."NS_Percent Complete" <> 100 then begin
                                Rec."NS_Cost To Complete" := Rec.NS_ForecastedCompCostOverride - TotalCostsUsed;
                                Rec."NS_Forecasted Completed Cost" := Rec."NS_Cost To Complete" + TotalCostsUsed;

                            end;

                            if Rec."NS_Percent Complete" = 100 then begin
                                Rec."NS_Cost To Complete" := 0;
                                Rec."NS_Forecasted Completed Cost" := Rec.NS_ForecastedCompCostOverride;
                            end
                        end;
                    end;
                end;
                //PE-270.AS.3.0 END Add

                //PE-270.AS.3.0 START Comment
                // Clear(Rec.NS_ForecastedCompCostOverride);
                // Rec.NS_ForecastedCompCostOverride := Rec.NS_GetForecastOverrideTotalsWithoutContractDate(Rec."NS_Job No.", Rec."NS_Job Task No.") + Rec.NS_GetForecastOverrideTotalsWithContractDate(0D, AsOfDateFilter, Rec."NS_Job No.", Rec."NS_Job Task No.");

                // if Rec.NS_ForecastedCompCostOverride <> 0 then begin
                //     if Rec."NS_Percent Complete" <> 100 then begin
                //         Rec."NS_Cost To Complete" := Rec.NS_ForecastedCompCostOverride - TotalCostsUsed;
                //         Rec."NS_Forecasted Completed Cost" := Rec."NS_Cost To Complete" + TotalCostsUsed;

                //     end;

                //     if Rec."NS_Percent Complete" = 100 then begin
                //         Rec."NS_Cost To Complete" := 0;
                //         Rec."NS_Forecasted Completed Cost" := Rec.NS_ForecastedCompCostOverride;
                //     end
                // end;
                //PE-270.AS.3.0 END Comment
            end;
            //PRJCTPR-325.AS.1.0 END ADD

            if Rec."NS_Percent Complete" <> 100 then begin//PRJ-1131.RM.1.0 10Jan2022
                ForecastedVariance := TotalBudget - Rec."NS_Forecasted Completed Cost"//PRJ-1131.RM.1.0 10Jan2022
            end else
                ForecastedVariance := TotalBudget - TotalCostsUsed;
            //NS_GetSumofBudgetRemaining(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, SumofBudgetRemaining, AsOfDateFilter, SumofForecastedVariance);//PRJ-537 //PRJ-1015.JS.1.0 commented
            //PE-160.AS.1.0 START
            if NS_Jobs.get(Rec."NS_Job No.") then
                if ((NS_Jobs."NS_Include Sub Levels" = false) and (NS_Jobs."NS_Job Class" = NS_Jobs."NS_Job Class"::SubJob)) then begin
                    if Rec."NS_Status Date" = 0D then
                        Rec."NS_Cost To Complete" := Rec.NS_BudgetRem;
                    ForecastedVariance := Rec.NS_BudgetRem - Rec."NS_Cost To Complete";
                end;
            //PE-160.AS.1.0 END

            //PRJ-1015.JS.1.0  11Oct2021-Start
            if NS_Jobs.get(Rec."NS_Job No.") then
                //if NS_Jobs."NS_Include Sub Levels" = true then   //PRJ-1039.JS.1.0  12Nov2021 line commented
                if ((NS_Jobs."NS_Include Sub Levels" = true) and (NS_Jobs."NS_Job Class" = NS_Jobs."NS_Job Class"::"Master Job")) then
                    //NS_GetSumofBudgetRemainingSubLevels(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, SumofBudgetRemaining, AsOfDateFilter, SumofForecastedVariance)  //PRJ-1039.JS.1.0  12Nov2021 line commented
                    Rec.NS_GetSumofBudgetRemainingIncludeSubLevelsNew(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, SumofBudgetRemaining, AsOfDateFilter, SumofForecastedVariance)
                else
                    Rec.NS_GetSumofBudgetRemaining(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, SumofBudgetRemaining, AsOfDateFilter, SumofForecastedVariance);//PRJ-537 //PRJ-1131.RM.1.0 10Jan2022
            //PRJ-1015.JS.1.0  11Oct2021-end              
            Rec.NS_BudgetRem := BudgetRemaining; //PE-73.AS.1.0
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
        //PE-282.JS.1.0 22APR2024 - Start            
        if PreviousJobForecast."NS_Forecasted Completed Cost" <> 0 then
            rec."NS_Prev. Forecasted Variance" := rec."NS_Forecasted Completed Cost" - rec."NS_Forecasted Completed Cost";
        //PE-282.JS.1.0 22APR2024 - end  
    end;

    //PE-270.AS.3.0 START
    local procedure NS_ForecastOverrideOnafterValidate();
    var
    begin
        if Rec.NS_ForecastedCompCostOverride <> 0 then begin
            // Rec.NS_ForecastedCompCostOverride := Rec.NS_ForecastedCompCostOverride;
            if Rec."NS_Percent Complete" <> 100 then begin
                Rec."NS_Cost To Complete" := Rec.NS_ForecastedCompCostOverride - TotalCostsUsed;
                Rec."NS_Forecasted Completed Cost" := Rec."NS_Cost To Complete" + TotalCostsUsed;
            end;

            if Rec."NS_Percent Complete" = 100 then begin
                Rec."NS_Cost To Complete" := 0;
                Rec."NS_Forecasted Completed Cost" := Rec.NS_ForecastedCompCostOverride;
            end
        end;
        if Rec."NS_Percent Complete" <> 100 then begin
            ForecastedVariance := TotalBudget - Rec."NS_Forecasted Completed Cost"
        end else
            ForecastedVariance := TotalBudget - TotalCostsUsed;
    end;
    //PE-270.AS.3.0 END
    local procedure NS_PercentCompleteOnAfterValidate();
    var
        ProjectedCost: Decimal;
        CalcDate: Date;
        NSJobSetup: Record "Jobs Setup";//PRJCTPR-62.JS.1.0 16FEB2023
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

        //PE-282.JS.1.0 28APR2024-Start below code blocked to hold data
        // if JobPlanningLineBudget."NS_Work Units" <> 0 then
        //     Rec."NS_Units Complete" := ROUND(JobPlanningLineBudget."NS_Work Units" * (Rec."NS_Percent Complete" / 100), GLSetup."Amount Rounding Precision")//PRJ-1131.RM.1.0 10Jan2022
        // else
        //     Rec."NS_Units Complete" := 0;//PRJ-1131.RM.1.0 10Jan2022
        //PE-282.JS.1.0 28APR2024-end

        If rec.NS_ForecastedCompCostOverride = 0 then begin//PRJCTPR-325 CONDITION ADD start
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
                //PE-282.JS.1.0 30APR2024-Start
                if PreviousJobForecast."NS_Forecasted Completed Cost" <> 0 then
                    rec."NS_Prev. Forecasted Variance" := Rec."NS_Forecasted Completed Cost" - PreviousJobForecast."NS_Forecasted Completed Cost";
                //PE-282.JS.1.0 30APR2024-end
            end else begin
                if Rec."NS_Percent Complete" = 100 then begin
                    Rec."NS_Cost To Complete" := 0;
                    Rec."NS_Forecasted Completed Cost" := TotalCostsUsed;
                    //PE-282.JS.1.0 30APR2024-Start
                    if PreviousJobForecast."NS_Forecasted Completed Cost" <> 0 then
                        rec."NS_Prev. Forecasted Variance" := Rec."NS_Forecasted Completed Cost" - PreviousJobForecast."NS_Forecasted Completed Cost";
                    //PE-282.JS.1.0 30APR2024-Start
                end else begin
                    Rec."NS_Cost To Complete" := 0;
                    Rec."NS_Forecasted Completed Cost" := PreviousJobForecast."NS_Forecasted Completed Cost";
                    //PRJ-1131.RM.1.0 10Jan2022 end
                    //PE-282.JS.1.0 30APR2024-Start
                    if PreviousJobForecast."NS_Forecasted Completed Cost" <> 0 then
                        rec."NS_Prev. Forecasted Variance" := Rec."NS_Forecasted Completed Cost" - PreviousJobForecast."NS_Forecasted Completed Cost";
                    //PE-282.JS.1.0 30APR2024-Start                    
                    //PRJCTPR-62.JS.1.0 16FEB2023 - Start
                    if NSJobSetup.get() then;
                    if NSJobSetup."NS_Forecast Force Completed" = true then
                        Rec."NS_Forecasted Completed Cost" := TotalCostsUsed;
                    //PRJCTPR-62.JS.1.0 16FEB2023 - end
                end;
            end;
        end;//PRJCTPR-325 CONDITION ADD end

        //PRJCTPR-325 start ADD 
        if Rec.NS_ForecastedCompCostOverride <> 0 then begin
            if Rec."NS_Percent Complete" <> 100 then begin
                Rec."NS_Cost To Complete" := Rec.NS_ForecastedCompCostOverride - TotalCostsUsed;
                Rec."NS_Forecasted Completed Cost" := Rec."NS_Cost To Complete" + TotalCostsUsed;

            end;

            if Rec."NS_Percent Complete" = 100 then begin
                Rec."NS_Cost To Complete" := 0;
                Rec."NS_Forecasted Completed Cost" := Rec.NS_ForecastedCompCostOverride;
            end
        end;
        //PRJCTPR-325 end ADD 
        ForecastedVariance := TotalBudget - Rec."NS_Forecasted Completed Cost";//PRJ-1131.RM.1.0 10Jan2022
    end;

    local procedure NS_CostToCompleteOnAfterValidate();
    begin
        //PRJ-1131.RM.1.0 10Jan2022 start
        If rec.NS_ForecastedCompCostOverride = 0 then begin//PRJCTPR-325 CONDITION ADD start
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
        end;//PRJCTPR-325 CONDITION ADD end

        //PRJCTPR-325 start ADD 
        if Rec.NS_ForecastedCompCostOverride <> 0 then begin
            if Rec."NS_Percent Complete" <> 100 then begin
                //Rec."NS_Cost To Complete" := Rec.NS_ForecastedCompCostOverride - TotalCostsUsed; //PRJCTPR-329.NC.1.0 01Mar2024 Block
                //Rec."NS_Forecasted Completed Cost" := Rec."NS_Cost To Complete" + TotalCostsUsed; //PRJCTPR-329.NC.1.0 01Mar2024 Block
                //PRJCTPR-329.NC.1.0 01Mar2024 Start
                Rec."NS_Forecasted Completed Cost" := TotalCostsUsed + Rec.NS_ForecastedCompCostOverride;
                if Rec."NS_Cost To Complete" <> 0 then
                    Rec."NS_Percent Complete" := 100 - (Rec."NS_Cost To Complete" / Rec."NS_Forecasted Completed Cost") * 100
                else
                    Rec."NS_Percent Complete" := 100;
                //PRJCTPR-329.NC.1.0 01Mar2024 End
            end;

            if Rec."NS_Percent Complete" = 100 then begin
                Rec."NS_Cost To Complete" := 0;
                Rec."NS_Forecasted Completed Cost" := Rec.NS_ForecastedCompCostOverride;
            end;
            ForecastedVariance := TotalBudget - Rec."NS_Forecasted Completed Cost";

            if JobPlanningLineBudget."NS_Work Units" <> 0 then
                Rec."NS_Units Complete" := ROUND(JobPlanningLineBudget."NS_Work Units" * (Rec."NS_Percent Complete" / 100), GLSetup."Amount Rounding Precision")//PRJ-1131.RM.1.0 10Jan2022
            else
                Rec."NS_Units Complete" := 0;
        end;
        //PRJCTPR-325 end ADD 
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
    //PRJ-1454.NK.1.0 13Jan2023 Start
    procedure GetPlanningLineIncludeSubLevels(StartDate: Date; var Enddate: Date; var ParaJob: Code[20]) Answer: Decimal;
    var
        PlanningLine: Record "Job Planning Line";
        PlanningLine2: Record "Job Planning Line";
        NSJob: Record Job;
        JobNoFilter: Code[20];
    begin
        JobNoFilter := '';
        JobNoFilter := '@*' + format(ParaJob) + '*';
        if jobSetup.Get() then;
        Answer := 0;
        PlanningLine.Reset();
        PlanningLine.SetRange("Job No.", ParaJob);
        PlanningLine.SetFilter("Line Type", '<>%1', PlanningLine."Line Type"::Budget);
        if jobSetup."NS_Enab. Budg.on Contract Date" then
            PlanningLine.SetRange("NS_Contract Forecast Date", StartDate, Enddate)
        else
            PlanningLine.SetRange("Planning Date", StartDate, Enddate);
        if PlanningLine.FindSet() then
            repeat
                //Answer := Answer + PlanningLine."Total Price (LCY)";  //PE-287.JS.1.0 08MAY2024 line commented
                Answer := Answer + PlanningLine."Line Amount (LCY)";  //PE-287.JS.1.0 08MAY2024 line added
            until PlanningLine.Next() = 0;

        NSJob.Reset();
        NSJob.SetCurrentKey("NS_Sub-Level to Job No.");
        NSJob.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        if NSJob.FindSet() then
            repeat
                PlanningLine2.Reset();
                PlanningLine2.SetRange("Job No.", NSJob."No.");
                PlanningLine2.SetFilter("Line Type", '<>%1', PlanningLine2."Line Type"::Budget);
                if jobSetup."NS_Enab. Budg.on Contract Date" then
                    PlanningLine2.SetRange("NS_Contract Forecast Date", StartDate, Enddate)
                else
                    PlanningLine2.SetRange("Planning Date", StartDate, Enddate);
                if PlanningLine2.FindSet() then
                    repeat
                        //Answer := Answer + PlanningLine2."Total Price (LCY)";  //PE-287.JS.1.0 08MAY2024 line commented
                        Answer := Answer + PlanningLine2."Line Amount (LCY)";  //PE-287.JS.1.0 08MAY2024 line added
                    until PlanningLine2.Next() = 0;
            until NSJob.Next() = 0;
        exit(Answer);
    end;
    //PRJ-1454.NK.1.0 13Jan2023 End

    //PE-287.JS.1.0 29APR2024-Start
    local procedure NS_JFWUpdForecastCompletedCostonJobTask(var NSJWFRec: Record "NS_Job Forecast");
    var
        NSJFWWorkSheetRec: Record "NS_Job Forecast";
        NSJobTaskRec: Record "Job Task";
        NSJobRec: Record Job;
    begin
        if NSJWFRec."NS_Status Date" <> 0D then begin
            if NSJobRec.get(NSJWFRec."NS_Job No.") then begin
                if NSJobRec.NS_UpdJFWForecastCompCostOnJT = true then begin
                    NSJFWWorkSheetRec.Reset();
                    NSJFWWorkSheetRec.SetRange("NS_Job No.", NSJWFRec."NS_Job No.");
                    if NSJFWWorkSheetRec.FindSet() then begin
                        repeat
                            if NSJobTaskRec.get(NSJFWWorkSheetRec."NS_Job No.", NSJFWWorkSheetRec."NS_Job Task No.") then
                                if NSJobTaskRec."Job Task Type" = NSJobTaskRec."Job Task Type"::Posting then begin
                                    NSJobTaskRec."NS_JFW Forecast Completed Cost" := NSJFWWorkSheetRec."NS_Forecasted Completed Cost";
                                    NSJobTaskRec.Modify();
                                end;
                        until NSJFWWorkSheetRec.Next() = 0;
                    end;
                end;
            end;
        end;
    end;
    //PE-287.JS.1.0 29APR2024-end
}

