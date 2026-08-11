table 14021187 "NS_Job Forecast"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +  - CTSI-21.MS.1.1 aded 3 new fields for forecast worksheet
    // +------------------------------------------------------------
    //CTSI-115.AS.1.0 Added codes
    //CTSI-192.MS.1.0 new changes for view open task only
    //CTSI-203.MS.1.0 new changes for forecast entry creation
    //PRJ-441.AM.1.0 12NOV2020 | Modified Percentage value.
    //CTSI-192.MS.1.0 new changes for view open task only
    //JD-48.AS.1.0 Added code
    //TM-21.MS.1.0 addedd new field for 100% completed view
    //PRJ-436.AS.1.0 15JAN2021 Taken code reference GLEI-33 VT 01-04-20- Field Added for Manager's Comment
    //PRJ-650 Add project Pro in Error message or Warning message
    //CTSI.231.MS.1.0  New changes for est. cost field cal. on the basis of Hr. to Fins.
    //CTSI.232.MS.1.0  New changes for skip complete task when post.
    //PRJ-565.MS.1.0 new changes for not clear hours to finish
    //PRJ-1015.JS.1.0 11Oct2021 | Correct Caption
    //PRJ-1039.JS.1.0 12Nov2021 | Change Code
    //PRJ-1056.JS.1.0 23Nov2021 | Add/Change in code for Total cost estimated
    //PRJ-1039.JS.2.0 12JAN2022 | Increase Length
    //PRJ-1326.NK.1.0 27APR2022 | Code Change
    //PRJ-1299.JS.1.0 18APR2022 | Add one field
    //PRJ-1355.JS.1.0 23MAY2022 | Add Procedure for Forecast by Task totals
    //PRJ-1484.NK.1.0 30Jun302022 | Added Code
    //PRJCTPR-55.NK.10 01feb2022 |  added code and comment old code on Budget Percentage used
    //PE-90.AS.1.0 Added Field

    Caption = 'Job Forecast';

    fields
    {
        field(1; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job."No.";
            DataClassification = CustomerContent;
        }
        field(2; "NS_Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            DataClassification = CustomerContent;
        }
        field(5; "NS_Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(6; "NS_Posted Check Boolean"; boolean)//JD-48.AS.1.0
        {
            Caption = 'Posted Segment wise';
            DataClassification = CustomerContent;
        }
        field(10; "NS_Status Date"; Date)
        {
            Caption = 'Status Date';
            DataClassification = CustomerContent;
        }
        field(15; "NS_Percent Complete"; Decimal)
        {
            BlankZero = true;
            Caption = 'Percent Complete';
            DataClassification = CustomerContent;
        }
        field(16; "NS_Units Complete"; Decimal)
        {
            BlankZero = true;
            Caption = 'Units Complete';
            DataClassification = CustomerContent;
        }
        field(20; "NS_Cost To Complete"; Decimal)
        {
            BlankZero = true;
            Caption = 'Cost To Complete';
            DataClassification = CustomerContent;
            //MinValue = 0; //PRJCTPR-345.JS.1.0 21APR22024 //PE-312.JS.1.0 11JUN2024 line commented   

            //PRJCTPR-345.JS.1.0 21APR22024 - Start
            trigger OnValidate()
            var
                NSJobsSetup1: Record "Jobs Setup";
            begin
                //PE-312.JS.1.0 11JUN2024-Start
                if NSJobsSetup1.Get() then begin
                    if NSJobsSetup1."NS_AllowNegEst. Cost2Complete" = false then
                        if "NS_Cost To Complete" < 0 then
                            error('You are not allowed to enter negative values.');
                end;
                //PE-312.JS.1.0 11JUN2024-end
            end;
            //PRJCTPR-345.JS.1.0 21APR22024 - end           
        }
        field(21; "NS_Forecasted Completed Cost"; Decimal)
        {
            BlankZero = true;
            Caption = 'Forecasted Completed Cost';
            DataClassification = CustomerContent;
        }
        field(22; "NS_Forecasted Completed Price"; Decimal)
        {
            Caption = 'Forecasted Competed Price';
            DataClassification = CustomerContent;
        }
        field(23; "NS_Hours To Finish"; Decimal)
        {
            BlankZero = true;
            Caption = 'Hours To Finish';
            DataClassification = CustomerContent;
            MinValue = 0;  //PRJCTPR-345.JS.1.0 21APR2024
        }
        field(24; "NS_Bill Date"; Date)
        {
            Caption = 'Bill Date';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                Job: Record Job;
            begin
                "NS_Bill Date" := Job.GetBillDate("NS_Bill Date", "NS_Job No.");
            end;
        }
        field(25; "NS_Bill Percent"; Decimal)
        {
            Caption = 'Bill Percent';
            DataClassification = CustomerContent;
        }
        field(26; "NS_PO Expected Receipt Cost"; Decimal)
        {
            Caption = 'PO Expected Receipt Cost';
            DataClassification = CustomerContent;
        }
        field(45; NS_Posted; Boolean)
        {
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50; "NS_User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;

            trigger OnLookup();
            var
                UserMgt: Codeunit "User Management";
            begin
                UserMgt.DisplayUserInformation("NS_User ID");
            end;
        }
        field(60; "NS_Calc Expected Receipt Costs"; Boolean)
        {
            Caption = 'Calc Expected Receipt Costs';
            DataClassification = CustomerContent;
        }
        field(61; "NS_Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Cost,Both,Price';
            OptionMembers = Cost,Both,Price;
            DataClassification = CustomerContent;
        }
        field(100; "NS_Task Manager"; Code[20])
        {
            Caption = 'Task Manager';
            TableRelation = Resource."No." WHERE(Type = CONST(Person));
            DataClassification = CustomerContent;
        }
        field(101; "NS_View Open Tasks Only"; Boolean)
        {
            Caption = 'View Open Tasks Only';
            Description = 'CTSI-192.MS.1.0';
            DataClassification = CustomerContent;
        }
        field(102; "NS_View 100% Completed Only"; Boolean)
        {
            Caption = 'View 100% Completed Only';
            Description = 'TM-21.MS.1.0';
            DataClassification = CustomerContent;
        }
        field(501; "NS_Average Percent Complete"; Decimal)
        {
            Caption = 'Average Percent Complete';
            Description = 'Process temporary work field';
            DataClassification = CustomerContent;
        }
        field(502; "NS_Task Budget"; Decimal)
        {
            Caption = 'Task Budget';
            Description = 'Process temporary work field';
            DataClassification = CustomerContent;
        }
        field(503; "NS_Task Budget Percent"; Decimal)
        {
            Caption = 'Task Budget Percent';
            Description = 'Process temporary work field';
            DataClassification = CustomerContent;
        }
        field(504; "NS_Earned Billing"; Decimal)
        {
            Caption = 'Earned Billing';
            Description = 'Process temporary work field';
            DataClassification = CustomerContent;
        }
        field(505; "NS_Sales Task No."; Code[20])
        {
            Caption = 'Sales Task No.';
            Description = 'Process temporary work field';
            DataClassification = CustomerContent;
        }
        field(506; "Budgeted Hours"; Decimal) //PRJ-565 changes from flow field to normal
        {
            // CalcFormula = Sum("Job Planning Line".Quantity WHERE("Job No." = FIELD("NS_Job No."),
            //                                                                      "Job Task No." = FIELD("NS_Job Task No."),
            //                                                                      //"Job Task No." = FIELD(FILTER(Totaling)),
            //                                                                      "Schedule Line" = CONST(true),
            //                                                                      //"Planning Date" = FIELD("Date Filter"),
            //                                                                      "line type" = filter(Budget | "Both Budget and Billable"),//PRJ-441.MS.1.0 add filter of both
            //                                                                      "Type" = filter(Resource),
            //                                                                      "Unit of Measure Code" = const('HR')));
            Caption = 'Budgeted Hours';
            Description = 'CTSI-21';
            Editable = false;
            DataClassification = CustomerContent;
            //FieldClass = FlowField;
        }
        //PRJ-436.AS.1.0 15JAN2021 Begin
        field(507; "NS_Manager Comments"; text[250])
        {
            Caption = 'Manager Comments';
            Description = 'Specifies Manager Comments';
            DataClassification = CustomerContent;
        }
        //PRJ-436.AS.1.0 15JAN2021 End

        field(508; "NS_Remaining Hours"; Decimal)
        {
            Caption = 'Remaining Hours';
            Description = 'CTSI-21';
            DataClassification = CustomerContent;
        }
        field(509; "NS_Budgeted Hrs Percent Compelete"; Decimal)
        {
            Caption = 'Budgeted Hrs Percent Compelete';
            Description = 'CTSI-21';
            DataClassification = CustomerContent;
        }
        field(510; "NS_Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
            Description = 'CTSI-21';

        }
        field(511; NS_Complete; Boolean)
        {
            Caption = 'Complete';
            Description = 'CTSI-232';
            DataClassification = CustomerContent;
        }
        field(512; "NS_Total Est. cost to Complete"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("NS_Job Forecast"."NS_Cost To Complete" where(NS_Posted = filter(false),
                                                                        "NS_Job No." = field("NS_Job No.")));
            Caption = 'Total Est. Cost to Complete';        //PRJ-1015.JS.1.0  11Oct2021
            Description = 'PRJ-537.MS.1.0';
        }
        field(513; "NS_Total Forecast Completed Cost"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("NS_Job Forecast"."NS_Forecasted Completed Cost" where(NS_Posted = filter(false),
                                                                        "NS_Job No." = field("NS_Job No.")));
            Caption = 'Total Forecast Completed Cost';
            Description = 'PRJ-537.MS.1.0';
        }
        field(514; "NS_Actual Hours"; Decimal)
        {
            CalcFormula = Sum("Job Ledger Entry".Quantity WHERE("Job No." = FIELD("NS_Job No."),
                                                                                 "Job Task No." = FIELD("NS_Job Task No."),
                                                                                 //"Job Task No." = FIELD(FILTER(Totaling)),
                                                                                 "Entry Type" = filter(Usage),
                                                                                 "Posting Date" = FIELD("NS_Date Filter"),
                                                                                 "Type" = filter(Resource),
                                                                                 "Unit of Measure Code" = const('HR')));
            Caption = 'Actual Hours';
            Description = 'CTSI-21';
            Editable = false;
            FieldClass = FlowField;
        }
        //PRJ-1299.JS.1.0 18APR2022 - Start
        field(14021352; "NS_Forecast Method"; Option)
        {

            Description = 'Forecast Method';
            DataClassification = CustomerContent;
            Caption = 'Forecast Method';
            OptionMembers = "Job Forecast by Task Code","Job Forecast by Segment Code","Job Forecast by Task Totals";
            OptionCaption = 'Job Forecast by Task Code,Job Forecast by Segment Code,Job Forecast by Task Totals';
            Editable = false;
        }
        //PRJ-1299.JS.1.0 18APR2022 - end


        //PE-73.AS.1.0 start
        field(14021351; "NS_BudgetRem"; Decimal)
        {
            Description = 'Budeget Remaining';
            DataClassification = CustomerContent;
            Caption = 'Budget Remaining';
            Editable = false;
        }
        //PE-73.AS.1.0 end

        //PE-90.AS.1.0 START
        field(14021453; "NS_ForecastedCompCostOverride"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Forecasted Completed Cost Over-ride';
            Editable = false;
        }
        //PE-90.AS.1.0 END
        //PE-191.NC.1.0 06Mar2024 Start
        field(14021454; "NS_Task Manager Comments"; text[250])
        {
            Caption = 'Task Manager Comments';
            Description = 'Specifies Task Manager Comments';
            DataClassification = CustomerContent;
        }
        //PE-191.NC.1.0 06Mar2024 End
        //PE-282.JS.1.0 21APR2024 - Start
        field(14021455; "NS_Prev. Forecasted Variance"; Decimal)
        {
            BlankZero = true;
            Caption = 'Previous Forecasted Variance';
            Description = 'Previous Forecasted Variance';
            DataClassification = CustomerContent;
        }
        //PE-282.JS.1.0 21APR2024 - end        
    }

    keys
    {
        key(Key1; "NS_Job No.", "NS_Job Task No.", "NS_Line No.")
        {
            SumIndexFields = "NS_Forecasted Completed Cost", "NS_Forecasted Completed Price";
        }
        key(Key2; "NS_Job No.", "NS_Job Task No.", "NS_Status Date", NS_Posted)
        {
        }
        key(Key3; "NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date")
        {
            SumIndexFields = "NS_Forecasted Completed Cost", "NS_Forecasted Completed Price";
        }
        key(Key4; NS_Posted)
        {
        }
        key(Key5; "NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Bill Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    var
        Licdate: date;//PRJ-516
        NoOfDays: Text;//PRJ-516
        EnvInfoCU: Codeunit "Environment Information";//PRJ-516
    begin
        //PRJ-516.ms.1.0 start
        if EnvInfoCU.IsSaaS() then begin
            //Licdate := DMY2Date(31, 3, 2021);//PRJ-516.AS.1.0 16MARCH2021 Comment
            // Licdate := DMY2Date(31, 5, 2021);//PRJ-516.AS.1.0 16MARCH2021 Added Change date
            // EVALUATE(NoOfDays, FORMAT(Licdate - WorkDate));
            // if (WorkDate > (Licdate - 6)) and (WorkDate <= Licdate) then
            //     Message('Your free trial is going to expire in %1 days.Please contact your administrator.', NoOfDays);
            // if WorkDate > Licdate then
            //     Error('Your free trial has expired.Please contact your administrator.');
            //PRJ-1686.GK.1.0 26Oct2022 start
            //PRJ-1641.JS.1.0 23SEP2022 - Start		
            // Licdate := DMY2Date(30, 11, 2022);
            // Licdate := DMY2Date(31, 12, 2022);
            // Licdate := DMY2Date(31, 1, 2023);
            // EVALUATE(NoOfDays, FORMAT(Licdate - WorkDate));
            // if (WorkDate > (Licdate - 15)) and (WorkDate <= Licdate) then
            //     Message('Your ProjectPro license is going to expire in %1 days.Please contact your administrator.', NoOfDays);
            // if WorkDate > Licdate then
            //     Error('Your ProjectPro license has expired.Please contact your administrator.');
            OnCheckPPLicenseExpire();   //PRJ-1641.JS.1.0 23SEP2022 line commented
            //PRJ-1641.JS.1.0 23SEP2022 - end  
            //PRJ-1686.GK.1.0 26Oct2022 end          
        end;
        //PRJ-516.ms.1.0 end
        if "NS_Job No." = '' then
            exit;
    end;

    trigger OnModify();
    begin
        UpdateJobTask("NS_Job No.", "NS_Job Task No.", "NS_Status Date", "NS_Percent Complete", "NS_Bill Date", "NS_Bill Percent");
    end;

    var
        JobSetup: Record "Jobs Setup";
        Text001_Txt: Label 'Do you want to post this status to the job?';
        TxtIncludeSublevel: Label 'Do you want to post the sub-level jobs along with this job?';
        Text002_Txt: Label 'Job %1, Task %2 is over %3 complete and therefore requires a "Hours to Finish" value.', comment = '%1 = Job %2 = Job task %3 = Job Task';

        Text003_Txt: Label 'There is nothing to post.  Check that there are entries for Status Dates.';
        Text004: Label 'Posting complete.';
        Text005: Label 'Do you want to post the billing to the job?';
        Text006: Label 'There is nothing to post.  Check that there are entries for billing dates.';

    procedure GetNewTasks(JobNo: Code[20]; TaskManagerNo: Code[20]);
    var
        JobTask: Record "Job Task";
        JobPlanningLine: Record "Job Planning Line";
        JobForecast: Record "NS_Job Forecast";
    begin
        //Add any Job Task lines that are not yet in the Job Forecast table

        JobTask.RESET();
        JobTask.SETRANGE("Job No.", JobNo);
        JobTask.SETRANGE("Job Task Type", JobTask."Job Task Type"::Posting);
        if JobTask.FINDSET() then
            repeat
                //Check that the task is in the Job Forecast status table.  Add it if it is not.
                with JobForecast do begin
                    RESET();
                    SETRANGE("NS_Job No.", JobTask."Job No.");
                    SETRANGE("NS_Job Task No.", JobTask."Job Task No.");
                    if not FINDFIRST() then begin
                        //CTSI-203.MS.1.0 start comment
                        //JobPlanningLine.RESET();
                        //JobPlanningLine.SETRANGE("Job No.", JobTask."Job No.");
                        //JobPlanningLine.SETRANGE("Job Task No.", JobTask."Job Task No.");
                        //if JobPlanningLine.FINDFIRST() then begin
                        //CTSI-203.MS.1.0 end comment
                        INIT();
                        "NS_Job No." := JobTask."Job No.";
                        "NS_Job Task No." := JobTask."Job Task No.";
                        "NS_Entry Type" := JobPlanningLine."NS_Entry Type";
                        "NS_Task Manager" := JobTask.NS_Manager;
                        "NS_Line No." := 100;
                        //JobForecast.NS_ForecastedCompCostOverride := JobTask.NS_ForecastedCompCostOverride;//PE-90.AS.1.0//PE-270.AS.4.0 COMMENT
                        INSERT();
                        //end;//CTSI-203.MS.1.0 
                    end;
                end;
            until JobTask.NEXT() = 0;
    end;

    procedure NS_GetLastPostedStatus(JobNo: Code[20]; JobTaskNo: Code[20]; DateLimit: Date; var JobForecast: Record "NS_Job Forecast");
    begin
        //Return the last Job Forecast record for the Job and Task passed in with a status of Posted

        with JobForecast do begin
            RESET();
            SETCURRENTKEY(NS_Posted);
            SETRANGE(NS_Posted, true);
            SETRANGE("NS_Job No.", JobNo);
            SETRANGE("NS_Job Task No.", JobTaskNo);
            //SetFilter(NS_Complete, '%1', false);//CTSI-232  roll back
            if DateLimit > 0D then
                SETFILTER("NS_Status Date", '<=%1', DateLimit);
            if not FINDLAST() then
                CLEAR(JobForecast);
        end;
    end;

    procedure NS_GetUnpostedRecord(JobNo: Code[20]; JobTaskNo: Code[20]; var JobForecast: Record "NS_Job Forecast");
    begin
        //Return the Job Forecast record for the Job and Task passed in with a status of not Posted

        with JobForecast do begin
            RESET();
            SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date");
            SETRANGE("NS_Job No.", JobNo);
            SETRANGE("NS_Job Task No.", JobTaskNo);
            SETRANGE(NS_Posted, false);
            //SetFilter(NS_Complete, '%1', true);//CTSI-232//test
            if not FINDFIRST() then
                CLEAR(JobForecast);
        end;
    end;

    [Obsolete('Will be removed in next build')]
    procedure NS_GetJobPlanningLineAndBudget(JobNo: Code[20]; JobTaskNo: Code[20]; var JobPlanningLine: Record "Job Planning Line"; var TotalBudget: Decimal);
    var
        JobPlanningLineWork: Record "Job Planning Line";
        JobPlanningLineWorkUnit: Record "Job Planning Line";
        JobPlanningLineFirst: Record "Job Planning Line";
        FoundWorkUnitsRecord: Boolean;
    begin
        //Returns a Job Planning Line and the Total Budget for a Job No. and a Task No.
        //
        //The Job Planning Line returned depends on if work units are being used in the task.
        //    If work units are used then the last planning line with work units is returned.
        //    If no work units are found then the first planning line for the task is returned.

        TotalBudget := 0;
        CLEAR(JobPlanningLine);
        CLEAR(JobPlanningLineFirst);
        CLEAR(JobPlanningLineWorkUnit);
        with JobPlanningLineWork do begin
            RESET();
            SETRANGE("Job No.", JobNo);
            if JobTaskNo > '' then
                SETRANGE("Job Task No.", JobTaskNo);
            if FINDSET() then
                repeat
                    if "NS_Work Units" > 0 then begin
                        JobPlanningLineWorkUnit := JobPlanningLineWork;
                        FoundWorkUnitsRecord := true;
                    end else
                        if JobPlanningLineFirst."Job No." = '' then
                            JobPlanningLineFirst := JobPlanningLineWork;
                    TotalBudget := TotalBudget + "Total Cost"
                until NEXT() = 0;
            if FoundWorkUnitsRecord then
                JobPlanningLine := JobPlanningLineWorkUnit
            else
                JobPlanningLine := JobPlanningLineFirst;
        end;
    end;

    //Create below new procedure with same name NS_GetJobPlanningLineAndBudget but different signature with 5 parameters 
    //because of failure in AppSource Release 18.0.8.24945
    procedure NS_GetJobPlanningLineAndBudget(JobNo: Code[20]; JobTaskNo: Code[20]; var JobPlanningLine: Record "Job Planning Line"; var TotalBudget: Decimal; Var ASofDateFilter: date);
    var
        JobPlanningLineWork: Record "Job Planning Line";
        JobPlanningLineWorkUnit: Record "Job Planning Line";
        JobPlanningLineFirst: Record "Job Planning Line";
        FoundWorkUnitsRecord: Boolean;
        JobTask: Record "Job Task"; //PRJ-1475.GK.1.0 22July2022
    begin
        //Returns a Job Planning Line and the Total Budget for a Job No. and a Task No.
        //
        //The Job Planning Line returned depends on if work units are being used in the task.
        //    If work units are used then the last planning line with work units is returned.
        //    If no work units are found then the first planning line for the task is returned.

        TotalBudget := 0;
        CLEAR(JobPlanningLine);
        CLEAR(JobPlanningLineFirst);
        CLEAR(JobPlanningLineWorkUnit);
        with JobPlanningLineWork do begin
            RESET();
            SETRANGE("Job No.", JobNo);
            if JobTaskNo > '' then
                //PRJ-1475.GK.1.0 22July2022 start
                if JobTask.Get(JobNo, JobTaskNo) then
                    if (JobTask."NS_Forecast By Task Totals") and (JobTask.Totaling <> '') then
                        SetFilter("Job Task No.", JobTask.Totaling)
                    else //PRJ-1475.GK.1.0 22July2022 end
                        SETRANGE("Job Task No.", JobTaskNo);

            //PRJ-1189.GK.1.0 06apr2022 start
            If ASofDateFilter <> 0D then begin
                if JobSetup.Get() then;
                if (JobSetup."NS_Enab. Budg.on Contract Date" = false) then
                    JobPlanningLineWork.Setfilter("Planning Date", '..%1', ASofDateFilter)//Prj-565
                else
                    JobPlanningLineWork.Setfilter("NS_Contract Forecast Date", '..%1', ASofDateFilter)
            end;
            //PRJ-1189.GK.1.0 06apr2022 end
            SetFilter("Line Type", '<>%1', "Line Type"::Billable);  //Prj-565  
            if FINDSET then
                repeat
                    if "NS_Work Units" > 0 then begin
                        JobPlanningLineWorkUnit := JobPlanningLineWork;
                        FoundWorkUnitsRecord := true;
                    end else begin
                        if JobPlanningLineFirst."Job No." = '' then
                            JobPlanningLineFirst := JobPlanningLineWork;
                    end;
                    //TotalBudget := TotalBudget + "Total Cost" //PRJ-1326.NK.1.0 27APR2022 Block
                    TotalBudget := TotalBudget + "Total Cost (LCY)"; //PRJ-1326.NK.1.0 27APR2022
                until NEXT() = 0;
            if FoundWorkUnitsRecord then
                JobPlanningLine := JobPlanningLineWorkUnit
            else
                JobPlanningLine := JobPlanningLineFirst;
            //Message('%1..tb', TotalBudget);
        end;
    end;
    //PRJ-537 start
    procedure NS_GetJobSumofTotalBudget(JobNo: Code[20]; JobTaskNo: Code[20]; var JobPlanningLine: Record "Job Planning Line"; var SumofTotalBudget: Decimal; Var ASofDateFilter: date);
    var
        JobPlanningLineWork: Record "Job Planning Line";
        JobPlanningLineWorkUnit: Record "Job Planning Line";
        JobPlanningLineFirst: Record "Job Planning Line";
        FoundWorkUnitsRecord: Boolean;
    begin
        SumofTotalBudget := 0;
        CLEAR(JobPlanningLine);
        CLEAR(JobPlanningLineFirst);
        CLEAR(JobPlanningLineWorkUnit);
        with JobPlanningLineWork do begin
            RESET;
            SETRANGE("Job No.", JobNo);
            //PRJ-1189.GK.1.0 06apr2022 start
            If ASofDateFilter <> 0D then begin
                if JobSetup.Get() then;
                if (JobSetup."NS_Enab. Budg.on Contract Date" = false) then
                    JobPlanningLineWork.Setfilter("Planning Date", '..%1', ASofDateFilter)//Prj-565
                else
                    JobPlanningLineWork.Setfilter("NS_Contract Forecast Date", '..%1', ASofDateFilter)
            end;
            //PRJ-1189.GK.1.0 06apr2022 end
            SetFilter("Line Type", '<>%1', "Line Type"::Billable);  //Prj-565  
            if FINDSET then
                repeat
                    if "NS_Work Units" > 0 then begin
                        JobPlanningLineWorkUnit := JobPlanningLineWork;
                        FoundWorkUnitsRecord := true;
                    end else begin
                        if JobPlanningLineFirst."Job No." = '' then
                            JobPlanningLineFirst := JobPlanningLineWork;
                    end;
                    //SumofTotalBudget := SumofTotalBudget + JobPlanningLineWork."Total Cost" //PRJ-1326.NK.1.0 27APR2022 Block
                    SumofTotalBudget := SumofTotalBudget + JobPlanningLineWork."Total Cost (LCY)"; //PRJ-1326.NK.1.0 27APR2022
                until NEXT = 0;

            if FoundWorkUnitsRecord then
                JobPlanningLine := JobPlanningLineWorkUnit
            else
                JobPlanningLine := JobPlanningLineFirst;
        end;
    end;

    procedure NS_GetSumOfTotalCostsUsed(JobNo: Code[20]; JobTaskNo: Code[20]; var JobPlanningLine: Record "Job Planning Line"; var SumOfTotalCostsUsed: Decimal; Var ASofDateFilter: date);
    var
        JobForcastWork: Record "NS_Job Forecast";
        JobLocal: Record Job;
    begin
        SumOfTotalCostsUsed := 0;
        with JobForcastWork do begin
            RESET;
            SETRANGE("NS_Job No.", JobNo);
            JobForcastWork.SetFilter(NS_Posted, '%1', false);
            if FINDSET then
                repeat
                    JobLocal.Reset();
                    JobLocal.SetRange("No.", JobNo);
                    JobLocal.SetRange("NS_Job Task No. Filter", "NS_Job Task No.");
                    if ASofDateFilter <> 0D then
                        JobLocal.SETFILTER("NS_Date Filter", '..%1', AsOfDateFilter)
                    else
                        JobLocal.SETRANGE("NS_Date Filter");
                    if JobLocal.FindFirst() then;
                    JobLocal.CALCFIELDS("NS_Usage (Cost) (LCY)");
                    SumOfTotalCostsUsed := SumOfTotalCostsUsed + JobLocal."NS_Usage (Cost) (LCY)";
                until NEXT = 0;

        end;
    end;

    procedure NS_GetSumofBudgetRemaining(JobNo: Code[20]; JobTaskNo: Code[20]; var JobPlanningLine: Record "Job Planning Line"; var SumofBudgetRemaining: Decimal; Var ASofDateFilter: date; var SumofForecastedVariance: Decimal);
    var
        JobPlanningLineWork: Record "Job Planning Line";
        JobForcastWork: Record "NS_Job Forecast";
        JobLocal: Record Job;
        TotalBudg: Decimal;
    begin
        SumofBudgetRemaining := 0;
        SumofForecastedVariance := 0;
        with JobForcastWork do begin
            RESET;
            SETRANGE("NS_Job No.", JobNo);
            JobForcastWork.SetFilter(NS_Posted, '%1', false);
            if FINDSET then
                repeat
                    TotalBudg := 0;
                    JobPlanningLineWork.reset;
                    JobPlanningLineWork.SetRange("Job No.", JobNo);
                    JobPlanningLineWork.SetRange("Job Task No.", "NS_Job Task No.");
                    //PRJ-1189.GK.1.0 06apr2022 start
                    If ASofDateFilter <> 0D then begin
                        if JobSetup.Get() then;
                        if (JobSetup."NS_Enab. Budg.on Contract Date" = false) then
                            JobPlanningLineWork.Setfilter("Planning Date", '..%1', ASofDateFilter)//Prj-565
                        else
                            JobPlanningLineWork.Setfilter("NS_Contract Forecast Date", '..%1', ASofDateFilter)
                    end;
                    //PRJ-1189.GK.1.0 06apr2022 end 
                    JobPlanningLineWork.SetFilter("Line Type", '<>%1', JobPlanningLineWork."Line Type"::Billable);
                    if JobPlanningLineWork.FindSet() then
                        repeat
                            //TotalBudg := TotalBudg + JobPlanningLineWork."Total Cost"  //PRJ-1326.NK.1.0 27APR2022 Block
                            TotalBudg := TotalBudg + JobPlanningLineWork."Total Cost (LCY)"; //PRJ-1326.NK.1.0 27APR2022
                        until JobPlanningLineWork.next = 0;
                    JobLocal.Reset();
                    JobLocal.SetRange("No.", JobNo);
                    JobLocal.SetRange("NS_Job Task No. Filter", "NS_Job Task No.");
                    if ASofDateFilter <> 0D then
                        JobLocal.SETFILTER("NS_Date Filter", '..%1', AsOfDateFilter)
                    else
                        JobLocal.SETRANGE("NS_Date Filter");
                    if JobLocal.FindFirst() then;
                    JobLocal.CALCFIELDS("NS_Usage (Cost) (LCY)");
                    //if (TotalBudg - JobLocal."Usage (Cost) (LCY)") > 0 then //PRJ-611 comment
                    SumofBudgetRemaining := SumofBudgetRemaining + (TotalBudg - JobLocal."NS_Usage (Cost) (LCY)");
                    //PE-160.AS.1.0 START condition Added in old code if NOT begin..end
                    if NOT ((JobLocal."NS_Include Sub Levels" = false) and (JobLocal."NS_Job Class" = JobLocal."NS_Job Class"::SubJob)) then begin
                        if JobForcastWork."NS_Percent Complete" <> 100 then
                            SumofForecastedVariance := SumofForecastedVariance + (TotalBudg - JobForcastWork."NS_Forecasted Completed Cost")
                        else
                            SumofForecastedVariance := SumofForecastedVariance + (TotalBudg - JobLocal."NS_Usage (Cost) (LCY)");
                    end;
                    //PE-160.AS.1.0 END

                    //PE-160.AS.1.0 START
                    if ((JobLocal."NS_Include Sub Levels" = false) and (JobLocal."NS_Job Class" = JobLocal."NS_Job Class"::SubJob)) then begin
                        if JobForcastWork."NS_Status Date" = 0D then
                            SumofForecastedVariance := SumofForecastedVariance + 0
                        else
                            SumofForecastedVariance := SumofForecastedVariance + (TotalBudg - JobForcastWork."NS_Forecasted Completed Cost")
                    end;
                //PE-160.AS.1.0 END
                until NEXT = 0;

        end;
    end;
    //PRJ-537 end
    //PRJ-565 start
    procedure NS_GetBudgetHours(JobNo: Code[20]; JobTaskNo: Code[20]; var JobPlanningLine: Record "Job Planning Line"; var BudgetedHrs: Decimal; Var ASofDateFilter: date);
    var
        JobPlanningLineWork: Record "Job Planning Line";
        JobPlanningLineWorkUnit: Record "Job Planning Line";
        JobPlanningLineFirst: Record "Job Planning Line";
        FoundWorkUnitsRecord: Boolean;
    begin
        BudgetedHrs := 0;
        CLEAR(JobPlanningLine);
        CLEAR(JobPlanningLineFirst);
        CLEAR(JobPlanningLineWorkUnit);
        with JobPlanningLineWork do begin
            RESET;
            SETRANGE("Job No.", JobNo);
            if JobTaskNo > '' then
                SETRANGE("Job Task No.", JobTaskNo);
            //PRJ-1189.GK.1.0 06apr2022 start
            If ASofDateFilter <> 0D then begin
                if JobSetup.Get() then;
                if (JobSetup."NS_Enab. Budg.on Contract Date" = false) then
                    JobPlanningLineWork.Setfilter("Planning Date", '..%1', ASofDateFilter)//Prj-565
                else
                    JobPlanningLineWork.Setfilter("NS_Contract Forecast Date", '..%1', ASofDateFilter)
            end;
            //PRJ-1189.GK.1.0 06apr2022 end
            SetFilter("Line Type", '<>%1', "Line Type"::Billable);
            SetFilter("Schedule Line", '%1', true);
            SetFilter(Type, '%1', Type::Resource);
            //SetFilter("Unit of Measure Code", '%1', 'HR');//PRJ-1524.GK.1.0 25July2022
            SetFilter("Unit of Measure Code", '%1|%2', 'HR', 'HOUR');//PRJ-1524.GK.1.0 25July2022            
            if FINDSET then
                repeat
                    if "NS_Work Units" > 0 then begin
                        JobPlanningLineWorkUnit := JobPlanningLineWork;
                        FoundWorkUnitsRecord := true;
                    end else begin
                        if JobPlanningLineFirst."Job No." = '' then
                            JobPlanningLineFirst := JobPlanningLineWork;
                    end;
                    BudgetedHrs := BudgetedHrs + Quantity;
                until NEXT = 0;

            if FoundWorkUnitsRecord then
                JobPlanningLine := JobPlanningLineWorkUnit
            else
                JobPlanningLine := JobPlanningLineFirst;
        end;
    end;
    //PRJ-565 end


    procedure NS_CalcPercentFrom0To100(Value: Decimal; Base: Decimal): Decimal;
    var
        Answer: Decimal;
    begin
        //Calculate a percent value
        //Return values over 100 as 100.  Return values less than zero as zero.

        if Value <> 0 then begin
            Answer := ROUND((Base / Value) * 100, 0.01);
            if Answer > 100 then
                //Answer := 100 //PRJCTPR-55.NK.1.0 Start 01feb2022 comment by nitesh
                Answer := Answer //PRJCTPR-55.NK.1.0 Start 01feb2022 
            else
                if Answer < 0 then
                    Answer := 0; //PRJCTPR-55.NK.1.0 Start 01feb2022 
                                 //Answer := Answer;//PRJCTPR-55.NK.1.0 Start 01feb2022 comment by nitesh
        end else
            //IF Value <= 0 THEN
            if Base <= 0 then
                Answer := 0.0 //PRJCTPR-55.NK.1.0 Start 01feb2022 
                              // Answer := Answer //PRJCTPR-55.NK.1.0 Start 01feb2022 comment by nitesh
            else
                //Answer := 100.0;
                Answer := Answer;

        exit(Answer);
    end;

    procedure NS_CalcCostToComplete(StatusDate: Date; PercentComplete: Decimal; TotalBudget: Decimal; CurrentCost: Decimal; PrevStatusDate: Date; PrevForecastedCompletedCost: Decimal) Answer: Decimal;
    var
        PercentRemaining: Decimal;
    begin
        //Returns a calculated amount needed to complete based on values passed in

        Answer := 0;

        //Get a value based on previous data first
        if PrevStatusDate = 0D then begin         //Is there previous data to use?
            Answer := TotalBudget - CurrentCost;    //No, just do calculations based on the job's budget
            if Answer < 0 then
                Answer := 0;
        end else begin                            //Yes, do calculations based on the value previously calculated
            Answer := PrevForecastedCompletedCost - CurrentCost;
            if Answer < 0 then
                Answer := 0;
        end;

        //Check if user entry should override what was calculated
        if (StatusDate > 0D) and (PercentComplete > 0) then begin
            if PercentComplete <> 100 then
                PercentRemaining := 100 - PercentComplete
            else
                PercentRemaining := 0; //PRJ-441.AM.1.0 //Previous PercentRemaining := 1;
            //Answer := CurrentCost / PercentComplete * PercentRemaining;
            //Answer := TotalBudget * (100 - PercentComplete) / 100;
            Answer := (CurrentCost / (PercentComplete / 100)) - CurrentCost;
            if (Answer = 0) and (TotalBudget > 0) then
                Answer := TotalBudget / PercentComplete * PercentRemaining;
        end;

        exit(Answer);
    end;

    procedure ForecastedCompletedAmt(Mode: Option "Records Cost","Records Price","Worksheet Cost","Worksheet Price"; JobNo: Code[20]; JobTaskNo: Code[20]; JobDateFilter: Text[30]) Answer: Decimal;
    var
        JobForecast: Record "NS_Job Forecast";
        JobForecast2: Record "NS_Job Forecast";
        Job: Record Job;
        Amount: Decimal;
        JobTaskHold: Code[20];
        AmountFound: Boolean;
    begin
        //Returns a cost or price value from the Forecasted Job or Task completion.  This can be based on the last posting or the current unposted values
        //
        //Mode - Records Cost - returns a posted cost value
        //               Accumulates last "Forecasted Completed Cost" value if there has been one posted - even if it is zero
        //                   otherwise the "Budgeted Cost (LCY)" for the task is accumulated.
        //
        //     - Records Price - returns a posted price value
        //               Accumulates last "Forecasted Completed Price" value if there has been one posted - even if it is zero
        //                   otherwise the "Budgeted Price (LCY)" for the task is accumulated
        //
        //     - Worksheet Cost - returns the unposted cost value
        //              Accumulates last "Foecasted Completed Cost" value if there has been one posted - even if it is zero
        //
        //     - Worksheet Price - returns the posted price value
        //             Accumulates "Forecasted Completed Price" value if there has been one posted - even if it is zero
        //
        //JobNo and JobTaskNo used to filter the value.  Returns a full Job value if no JobTaskNo is passed in.
        //
        //JobDateFilter is used to filter the accumulated data for the Worksheet modes

        Answer := 0;

        with JobForecast do begin
            if JobNo > '' then begin
                RESET();
                SETRANGE("NS_Job No.", JobNo);
                //JobForecast.SETRANGE(NS_Posted, true);   //PRJ-1056.JS.1.0   23Nov2021
                if JobTaskNo > '' then
                    SETRANGE("NS_Job Task No.", JobTaskNo);
                if (JobDateFilter > '') and ((Mode = Mode::"Worksheet Cost") or (Mode = Mode::"Worksheet Price")) then
                    SETFILTER("NS_Status Date", JobDateFilter);
                if FINDSET() then begin
                    JobTaskHold := "NS_Job Task No.";
                    AmountFound := false;
                    repeat
                        if "NS_Job Task No." <> JobTaskHold then begin
                            if AmountFound then begin
                                Answer := Answer + Amount;
                                Amount := 0;
                                AmountFound := false;
                            end else
                                //Read Job Budget for the Task
                                case Mode of
                                    Mode::"Records Cost", Mode::"Records Price":
                                        begin
                                            if Job.GET(JobNo) then begin
                                                Job.SETRANGE("NS_Job Task No. Filter", JobTaskHold);
                                                case Mode of
                                                    Mode::"Records Cost":
                                                        begin
                                                            Job.CALCFIELDS("NS_Budgeted Cost (LCY)");
                                                            Answer := Answer + Job."NS_Budgeted Cost (LCY)";
                                                        end;
                                                    Mode::"Records Price":
                                                        begin
                                                            Job.CALCFIELDS("NS_Budgeted Price (LCY)");
                                                            Answer := Answer + Job."NS_Budgeted Price (LCY)";
                                                        end;
                                                end;
                                            end;
                                        end;
                                    Mode::"Worksheet Cost", Mode::"Worksheet Price":
                                        begin
                                            if JobForecast2.GET(JobNo) then begin
                                                JobForecast2.SETFILTER("NS_Job Task No.", JobTaskHold);
                                                case Mode of
                                                    Mode::"Worksheet Cost":
                                                        Answer := Answer + JobForecast2."NS_Forecasted Completed Cost";
                                                    Mode::"Worksheet Price":
                                                        begin
                                                            JobForecast2.CALCFIELDS("NS_Forecasted Completed Price");
                                                            Answer := Answer + JobForecast2."NS_Forecasted Completed Price";
                                                        end;

                                                end;
                                                //Message('%1...%2', Answer, JobForecast2."Forecasted Completed Cost");
                                            end;
                                        end;
                                end;
                            JobTaskHold := "NS_Job Task No.";
                        end;
                        if ("NS_Job Task No." = JobTaskHold) then begin //and Posted then begin //("Status Date" > 0D) and NS_Posted then begin //PRJ-441
                            case Mode of
                                Mode::"Records Cost", Mode::"Worksheet Cost":
                                    Amount := "NS_Forecasted Completed Cost";
                                Mode::"Records Price", Mode::"Worksheet Price":
                                    Amount := "NS_Forecasted Completed Price";
                            end;
                            AmountFound := true;
                        end;
                    until NEXT() = 0;

                    //Process the last record
                    if AmountFound then begin
                        Answer := Answer + Amount;
                        Amount := 0;
                    end else
                        //Read Job Budget for the Task
                        case Mode of
                            Mode::"Records Cost", Mode::"Records Price":
                                begin
                                    if Job.GET(JobNo) then begin
                                        Job.SETRANGE("NS_Job Task No. Filter", JobTaskHold);
                                        case Mode of
                                            Mode::"Records Cost":
                                                begin
                                                    Job.CALCFIELDS("NS_Budgeted Cost (LCY)");
                                                    Answer := Answer + Job."NS_Budgeted Cost (LCY)";
                                                end;
                                            Mode::"Records Price":
                                                begin
                                                    Job.CALCFIELDS("NS_Budgeted Price (LCY)");
                                                    Answer := Answer + Job."NS_Budgeted Price (LCY)";
                                                end;
                                        end;
                                    end;
                                end;
                            Mode::"Worksheet Cost", Mode::"Worksheet Price":
                                begin
                                    if JobForecast2.GET(JobNo) then begin
                                        JobForecast2.SETFILTER("NS_Job Task No.", JobTaskHold);
                                        case Mode of
                                            Mode::"Worksheet Cost":
                                                Answer := Answer + JobForecast2."NS_Forecasted Completed Cost";
                                            Mode::"Worksheet Price":
                                                begin
                                                    JobForecast2.CALCFIELDS("NS_Forecasted Completed Price");
                                                    Answer := Answer + JobForecast2."NS_Forecasted Completed Price";
                                                end;

                                        end;
                                        //Message('%1..#####.%2', Answer, JobForecast2."Forecasted Completed Cost");
                                    end;
                                end;
                        end;
                end;
            end;
        end;
        exit(Answer);
    end;

    procedure NS_PostLines(JobNo: Code[20]; DefaultStatusDate: Date; NextBillDate: Date);
    var
        JobForecast: Record "NS_Job Forecast";
        JobForecast2: Record "NS_Job Forecast";
        JobForecast3: Record "NS_Job Forecast";  //PE-282.JS.1.0 12APR2024        
        BillStartDate: Date;
        BillEndDate: Date;
        JobDateFilter: Text;//not present in V17
        TotalCostsUsed: Decimal;//not present in V17
        q: Integer;
        ReportJobForecast: Record "NS_Job Forecast"; //CTSI-94.ms.1.0
        JobForecastWorksheetReport: Report "NS_Percentage of Compl."; //CTSI-94.ms.1.0
        JobForecastWorksheetReport_C: Report "NS_Percentage of Compl."; //CTSI-115.AS.1.0
        IncludeSublevelBool: Boolean;//CTSI-115.AS.1.0
        JobsetupRec: Record "Jobs Setup";//CTSI-115.AS.1.0
        JobRecord: Record Job;//CTSI-115.AS.1.0
        JobRec2: Record Job;//CTSI-115.AS.1.0
        JobRec3: Record Job;//CTSI-115.AS.1.0
        JobTable: Record job; //CTSI-115.AS.1.0 25Aug2020
        GBPGValTxt: Text;//CTSI-115.AS.1.0
        JobForecastSubLevelValInsert: Record "NS_Job Forecast";//CTSI-115.AS.1.0
        JobForecastWkshtPg: Page "NS_Job Forecast Worksheet";//PRJ-658 test code
        JobForecastTable: Record "NS_Job Forecast";//PRJ-658.AS.1.0 13MAY2021
        JobTabl: Record Job; //PE-160.AS.1.0
        NSJobRec: record Job;   //PE-282.JS.1.0 26APR2024
        NSJobTaskRec: Record "Job Task"; //PE-287.JS.1.0 30APR2024
    begin
        if JobsetupRec.Get() then; //CTSI-115.AS.1.0  //PE-282.JS.1.0 26APR2024

        Clear(IncludeSublevelBool);//CTSI-115.AS.1.0

        Clear(GBPGValTxt);//CTSI-115.AS.1.0

        GBPGValTxt := JobsetupRec."NS_GBPG for Job Forecast";//CTSI-115.AS.1.0

        //CTSI-115.AS.1.0 - start
        //if CONFIRM(Text001_Txt, true) then begin//CTSI-274/PRJ-658 comment
        if JobNo <> '' then//CTSI-115.AS.1.0 25Aug2020 -start
            JobTable.get(JobNo);//CTSI-115.AS.1.0 25Aug2020 -start
        if JobTable."NS_Sub-Level to Job No." = '' then begin //CTSI-115.AS.1.0 25Aug2020 -start
            IF Confirm(TxtIncludeSublevel, true) then begin
                if JobRecord.Get(JobNo) then begin
                    if JobRecord."NS_Exclude from Job Forecast" = false then begin
                        IncludeSublevelBool := true;
                        //PRJ-1484.NK.1.0 30Jun302022 Start
                        if not JobTable."NS_Include Sub Levels" then
                            NS_ForecastedCompletedAmtNoDateIncSubLev(JobNo, DefaultStatusDate)
                        else
                            //PRJ-1484.NK.1.0 30Jun302022 end
                            NS_ForecastedCompletedAmtNoDate(JobNo, DefaultStatusDate);
                        JobRec2.RESET;
                        JobRec2.SETRANGE("NS_Sub-Level to Job No.", JobNo);
                        JobRec2.SetRange("NS_Exclude from Job Forecast", false);
                        if GBPGValTxt > '' then
                            // JobRec2.SetFilter("NS_Gen. Bus. Posting Group", GBPGValTxt);//PRJ-831.AS.1.0 12OCT2021 Comment old
                             JobRec2.SetFilter("NS_Gen. Bus. Posting Group New", GBPGValTxt);//PRJ-831.AS.1.0 12OCT2021 Add New
                        if JobRec2.FindSet then begin
                            REPEAT
                                NS_ForecastedCompletedAmtNoDate(JobRec2."No.", DefaultStatusDate);
                            UNTIL JobRec2.NEXT = 0;
                        end
                        else begin

                        end;
                    end;
                    if JobRecord."NS_Exclude from Job Forecast" = true then begin
                        IncludeSublevelBool := false;
                        NS_ForecastedCompletedAmtNoDate(JobNo, DefaultStatusDate);
                    end;
                end;
                //CTSI-115.AS.1.0 end
            end;
        end else begin
            IncludeSublevelBool := false;
            NS_ForecastedCompletedAmtNoDate(JobNo, DefaultStatusDate);
        end;
        //END else begin  //PRJ-141.AM.1.0
        //    exit;//PRJ-141.AM.1.0//CTSI-274/PRJ-658 comment
        //end;

        with JobForecast do begin
            //CTSI-94.ms.1.0.start
            if JobNo > '' then begin
                if DefaultStatusDate > 0D then begin
                    if IncludeSublevelBool = true then begin
                        JobForecastWorksheetReport_C.Set(JobNo, DefaultStatusDate);
                        JobForecastWorksheetReport_C.RunModal();
                        Clear(JobForecastWorksheetReport_C);

                        JobRec2.RESET;
                        JobRec2.SETRANGE("NS_Sub-Level to Job No.", JobNo);
                        if GBPGValTxt > '' then
                            //JobRec2.SetFilter("NS_Gen. Bus. Posting Group", GBPGValTxt);//PRJ-831.AS.1.0 12OCT2021 Comment old
                            JobRec2.SetFilter("NS_Gen. Bus. Posting Group New", GBPGValTxt);//PRJ-831.AS.1.0 12OCT2021 Add New
                        JobRec2.SetRange("NS_Exclude from Job Forecast", false);
                        if JobRec2.findset then begin
                            REPEAT
                                if JobRec2."No." > '' then begin
                                    //AS - START COMMENT

                                    //SK Start
                                    OnOpenJobForcastPage(JobForecast, JobRec2."No.", DefaultStatusDate, NextBillDate);

                                    JobForecastTable.Reset();
                                    JobForecastTable.SetRange("NS_Job No.", JobRec2."No.");
                                    if JobForecastTable.FindSet() then
                                        repeat
                                            OnAfterGetJobForcastPage(JobForecastTable, JobRec2."No.", DefaultStatusDate, NextBillDate);
                                            OnAfterGetCurrRecordJobForcastPage(JobForecastTable, JobRec2."No.", DefaultStatusDate, NextBillDate);
                                            JobForecastTable.Modify();
                                        until JobForecastTable.Next() = 0;
                                    //SK End

                                    //AS - END COMMENT

                                    JobForecastWorksheetReport_C.Set(JobRec2."No.", DefaultStatusDate);
                                    JobForecastWorksheetReport_C.RunModal();
                                    Clear(JobForecastWorksheetReport_C);
                                end;
                            UNTIL JobRec2.NEXT = 0;
                        end
                        else begin

                        end;
                    end;
                    if IncludeSublevelBool = false then begin
                        JobForecastWorksheetReport.Set(JobNo, DefaultStatusDate);
                        JobForecastWorksheetReport.RUNMODAL();
                        CLEAR(JobForecastWorksheetReport);
                    end
                end else
                    ERROR('Please check the As of date field');
            end;
            //CTSI-94.ms.1.0.end
            JobSetup.GET;
            RESET;
            MARKEDONLY(false);
            if JobNo > '' then
                SETRANGE("NS_Job No.", JobNo);
            SETRANGE(NS_Posted, false);
            //SetFilter(NS_Complete, '%1', false);//CTSI-232 roll back
            if (JobNo = '') and (NextBillDate > 0D) then begin
                BillStartDate := DMY2DATE(1, DATE2DMY(NextBillDate, 2), DATE2DMY(NextBillDate, 3));
                if DATE2DMY(BillStartDate, 2) < 12 then
                    BillEndDate := CALCDATE('<-1D>', DMY2DATE(1, DATE2DMY(NextBillDate, 2) + 1, DATE2DMY(NextBillDate, 3)))
                else
                    BillEndDate := DMY2DATE(12, 31, DATE2DMY(NextBillDate, 3));

                SETFILTER("NS_Bill Date", '%1..%2', BillStartDate, BillEndDate);
                if FINDSET() then
                    repeat
                        MARK := true;
                    until NEXT() = 0;
                SETRANGE("NS_Bill Date");
                SETFILTER("NS_Status Date", '%1..%2', CALCDATE('<-31D>', BillStartDate), BillEndDate);
                if FINDSET() then
                    repeat
                        MARK := true;
                    until NEXT() = 0;
                SETRANGE("NS_Status Date");
                MARKEDONLY(true);
            end;
            if COUNT = 0 then
                MESSAGE(Text002_Txt);
            if FINDSET() then begin
                repeat
                    //PE-282.JS.1.0 15APR2024 - below code commented Start
                    // if ((JobForecast."NS_Status Date" > 0D) or
                    //     (JobForecast."NS_Percent Complete" > 0))
                    //    and
                    //    ((JobForecast."NS_Percent Complete" = 100) or
                    //     (JobForecast."NS_Percent Complete" < JobSetup."NS_Forecast Percent For HrsReq") or
                    //     (JobSetup."NS_Forecast Percent For HrsReq" = 0) or
                    //     (JobForecast."NS_Hours To Finish" > 0) or
                    //     (JobForecast."NS_Entry Type" = JobForecast."NS_Entry Type"::Price)) then begin
                    //     if (JobForecast."NS_Entry Type" = JobForecast."NS_Entry Type"::Price) and (JobForecast."NS_Status Date" = 0D) then
                    //         JobForecast."NS_Status Date" := DefaultStatusDate;
                    //PE-282.JS.1.0 15APR2024 - below code commented end

                    //PE-282.JS.1.0 15APR2024 - Start
                    if ((JobForecast."NS_Status Date" > 0D) or
                        (JobForecast."NS_Percent Complete" > 0))
                        then begin
                        //PE-282.JS.1.0 15APR2024 - end        
                        JobForecast."NS_Status Date" := DefaultStatusDate;

                        JobForecast.NS_Posted := true;
                        JobForecast."NS_User ID" := USERID;

                        if JobForecast."NS_Job Task No." = '13-13200-13280' then
                            q := q;

                        if JobForecast."NS_Forecasted Completed Cost" = 0 then begin
                            JobForecast2.RESET();
                            JobForecast2.SETRANGE("NS_Job No.", JobForecast."NS_Job No.");
                            JobForecast2.SETRANGE("NS_Job Task No.", JobForecast."NS_Job Task No.");
                            JobForecast2.SETRANGE("NS_Line No.", JobForecast."NS_Line No." - 1);
                            //JobForecast2.SetFilter(NS_Complete, '%1', false); //CTSI-232 roll back
                            if (JobForecast2.FINDFIRST()) and (JobForecast2."NS_Forecasted Completed Cost" <> 0) then
                                JobForecast."NS_Forecasted Completed Cost" := JobForecast2."NS_Forecasted Completed Cost";
                        end;
                        //PE-282.JS.1.0 12APR2024- Start
                        JobForecast3.RESET();
                        JobForecast3.SETRANGE("NS_Job No.", JobForecast."NS_Job No.");
                        JobForecast3.SETRANGE("NS_Job Task No.", JobForecast."NS_Job Task No.");
                        JobForecast3.SETRANGE("NS_Line No.", JobForecast."NS_Line No.");
                        if JobForecast3.findfirst() then begin
                            JobForecast."NS_Job No." := JobForecast3."NS_Job No.";
                            JobForecast."NS_Job Task No." := JobForecast3."NS_Job Task No.";
                            JobForecast."NS_Forecasted Completed Cost" := JobForecast3."NS_Forecasted Completed Cost";
                            JobForecast."NS_Cost To Complete" := JobForecast3."NS_Cost To Complete";
                            JobForecast."NS_Percent Complete" := JobForecast3."NS_Percent Complete";
                            JobForecast."NS_Remaining Hours" := JobForecast3."NS_Remaining Hours";
                            JobForecast."Budgeted Hours" := JobForecast3."Budgeted Hours";
                            JobForecast."NS_Bill Percent" := JobForecast3."NS_Bill Percent";
                            JobForecast."NS_Budgeted Hrs Percent Compelete" := JobForecast3."NS_Budgeted Hrs Percent Compelete";
                            JobForecast."NS_Forecasted Completed Price" := JobForecast3."NS_Forecasted Completed Price";
                            JobForecast."NS_Units Complete" := JobForecast3."NS_Units Complete";
                        end;
                        //PE-282.JS.1.0 12APR2024- end

                        MODIFY();
                        //Build a new unposted line for display
                        "NS_Line No." := "NS_Line No." + 1;

                        //if "NS_Percent Complete" = 0 then //PRJ-565 comment
                        //    "NS_Status Date" := 0D;

                        //JobForecast."NS_Units Complete" := 0;  //PE-282.JS.1.0 17APR2024 line commenetd
                        //"NS_Cost To Complete" := 0;//ctsi-231
                        if JobForecast."NS_Percent Complete" = 100 then
                            JobForecast."NS_Forecasted Completed Cost" := NS_Get100PctCost(JobForecast."NS_Job No.", JobForecast."NS_Job Task No.");  //PE-282.JS.1.0 17APR2024 add ;
                                                                                                                                                      //else  //PE-282.JS.1.0 17APR2024 line commenetd
                                                                                                                                                      //    JobForecast."NS_Forecasted Completed Cost" := 0;  //PE-282.JS.1.0 17APR2024 line commenetd
                                                                                                                                                      //JobForecast."NS_Forecasted Completed Price" := 0;  //PE-282.JS.1.0 17APR2024 line commenetd
                                                                                                                                                      //"NS_Hours To Finish" := 0;//PRJ-565.MS.1.0 roll back //PRJ-565.AS.1.0 12MARCH2021- COMMENT
                        if JobTabl.get(JobForecast."NS_Job No.") then;//PE-160.AS.1.0
                                                                      //PE-160.AS.1.0 START Putted old code in condition begin..end
                        if NOT ((JobTabl."NS_Include Sub Levels" = false) and (JobTabl."NS_Job Class" = JobTabl."NS_Job Class"::SubJob)) then begin
                            JobForecast."NS_Bill Date" := 0D;
                            JobForecast."NS_Bill Percent" := 0;
                            JobForecast."NS_PO Expected Receipt Cost" := 0;
                            JobForecast."NS_Posted Check Boolean" := true;//JD-48.AS.1.0
                        end;
                        //PE-160.AS.1.0 END

                        //PE-287.JS.1.0 29APR2024-Start
                        if NSJobRec.get(JobForecast."NS_Job No.") then begin
                            if NSJobRec.NS_UpdJFWForecastCompCostOnJT = true then begin
                                if NSJobTaskRec.get(JobForecast."NS_Job No.", JobForecast."NS_Job Task No.") then begin
                                    if NSJobTaskRec."Job Task Type" = NSJobTaskRec."Job Task Type"::Posting then begin
                                        NSJobTaskRec."NS_JFW Forecast Completed Cost" := JobForecast."NS_Forecasted Completed Cost";
                                        NSJobTaskRec.Modify();
                                    end;
                                end;
                            end;
                        end;
                        //PE-287.JS.1.0 29APR2024-end

                        JobForecast.INSERT();
                    end;   //PE-282.JS.1.0 12APR2024 line commented
                until JobForecast.NEXT() = 0;
            end else
                MESSAGE(Text003_Txt);
            //CTSI-115.AS.1.0 - start
            ///// Job Forecast sublevel value insert - start
            if IncludeSublevelBool = true then begin
                JobRec3.RESET;
                JobRec3.SETRANGE("NS_Sub-Level to Job No.", JobNo);
                if GBPGValTxt > '' then
                    //JobRec3.SetFilter("NS_Gen. Bus. Posting Group", GBPGValTxt);//PRJ-831.AS.1.0 12OCT2021 Comment old
                    JobRec3.SetFilter("NS_Gen. Bus. Posting Group New", GBPGValTxt);//PRJ-831.AS.1.0 12OCT2021 Add New
                JobRec3.SetRange("NS_Exclude from Job Forecast", false);
                if JobRec3.FindSet then begin
                    REPEAT
                        //PRJ-1132.NK.1.0 Start
                        //with JobForecastSubLevelValInsert do begin
                        JobForecastSubLevelValInsert.RESET();
                        JobForecastSubLevelValInsert.MARKEDONLY(false);
                        if JobRec3."No." > '' then
                            JobForecastSubLevelValInsert.SETRANGE("NS_Job No.", JobRec3."No.");
                        JobForecastSubLevelValInsert.SETRANGE(NS_Posted, false);
                        //SetFilter(NS_Complete, '%1', false);//CTSI-232 roll back
                        if (JobRec3."No." = '') and (NextBillDate > 0D) then begin
                            BillStartDate := DMY2DATE(1, DATE2DMY(NextBillDate, 2), DATE2DMY(NextBillDate, 3));
                            if DATE2DMY(BillStartDate, 2) < 12 then
                                BillEndDate := CALCDATE('-1D', DMY2DATE(1, DATE2DMY(NextBillDate, 2) + 1, DATE2DMY(NextBillDate, 3)))
                            else
                                BillEndDate := DMY2DATE(12, 31, DATE2DMY(NextBillDate, 3));

                            JobForecastSubLevelValInsert.SETFILTER("NS_Bill Date", '%1..%2', BillStartDate, BillEndDate);
                            if JobForecastSubLevelValInsert.FINDSET() then
                                repeat
                                    JobForecastSubLevelValInsert.MARK := true;
                                until JobForecastSubLevelValInsert.NEXT = 0;
                            JobForecastSubLevelValInsert.SETRANGE("NS_Bill Date");
                            JobForecastSubLevelValInsert.SETFILTER("NS_Status Date", '%1..%2', CALCDATE('-31D', BillStartDate), BillEndDate);
                            if JobForecastSubLevelValInsert.FINDSET() then
                                repeat
                                    JobForecastSubLevelValInsert.MARK := true;
                                until JobForecastSubLevelValInsert.NEXT() = 0;
                            JobForecastSubLevelValInsert.SETRANGE("NS_Status Date");
                            JobForecastSubLevelValInsert.MARKEDONLY(true);
                        end;
                        //if COUNT = 0 then
                        //    MESSAGE(Text002_Txt);//PRJ-441.MS.1.0 comment
                        if JobForecastSubLevelValInsert.FINDSET() then begin
                            repeat
                                //PE-282.JS.1.0 15APR2024-Start
                                // if ((JobForecastSubLevelValInsert."NS_Status Date" > 0D) or
                                //     (JobForecastSubLevelValInsert."NS_Percent Complete" > 0))
                                //    and
                                //    ((JobForecastSubLevelValInsert."NS_Percent Complete" = 100) or
                                //     (JobForecastSubLevelValInsert."NS_Percent Complete" < JobSetup."NS_Forecast Percent For HrsReq") or
                                //     (JobSetup."NS_Forecast Percent For HrsReq" = 0) or
                                //     (JobForecastSubLevelValInsert."NS_Hours To Finish" > 0) or
                                //     (JobForecastSubLevelValInsert."NS_Entry Type" = JobForecastSubLevelValInsert."NS_Entry Type"::Price)) then begin
                                //     if (JobForecastSubLevelValInsert."NS_Entry Type" = JobForecastSubLevelValInsert."NS_Entry Type"::Price) and (JobForecastSubLevelValInsert."NS_Status Date" = 0D) then
                                //         JobForecastSubLevelValInsert."NS_Status Date" := DefaultStatusDate;

                                if ((JobForecastSubLevelValInsert."NS_Status Date" > 0D) or
                                (JobForecastSubLevelValInsert."NS_Percent Complete" > 0)) then begin
                                    JobForecastSubLevelValInsert."NS_Status Date" := DefaultStatusDate;
                                    //PE-282.JS.1.0 15APR2024-end        
                                    JobForecastSubLevelValInsert.NS_Posted := true;
                                    JobForecastSubLevelValInsert."NS_User ID" := USERID;
                                    if JobForecastSubLevelValInsert."NS_Job Task No." = '13-13200-13280' then
                                        q := q;
                                    if JobForecastSubLevelValInsert."NS_Forecasted Completed Cost" = 0 then begin
                                        JobForecast2.RESET;
                                        JobForecast2.SETRANGE("NS_Job No.", JobRec3."No.");
                                        JobForecast2.SETRANGE("NS_Job Task No.", JobForecastSubLevelValInsert."NS_Job Task No.");
                                        JobForecast2.SETRANGE("NS_Line No.", JobForecastSubLevelValInsert."NS_Line No." - 1);
                                        if (JobForecast2.FINDFIRST()) and (JobForecast2."NS_Forecasted Completed Cost" <> 0) then
                                            JobForecastSubLevelValInsert."NS_Forecasted Completed Cost" := JobForecast2."NS_Forecasted Completed Cost";
                                    end;

                                    //PE-282.JS.1.0 12APR2024- Start
                                    JobForecast3.RESET();
                                    JobForecast3.SETRANGE("NS_Job No.", JobForecastSubLevelValInsert."NS_Job No.");
                                    JobForecast3.SETRANGE("NS_Job Task No.", JobForecastSubLevelValInsert."NS_Job Task No.");
                                    JobForecast3.SETRANGE("NS_Line No.", JobForecastSubLevelValInsert."NS_Line No.");
                                    if JobForecast3.findfirst() then begin
                                        JobForecastSubLevelValInsert."NS_Job No." := JobForecast3."NS_Job No.";
                                        JobForecastSubLevelValInsert."NS_Job Task No." := JobForecast3."NS_Job Task No.";
                                        JobForecastSubLevelValInsert."NS_Forecasted Completed Cost" := JobForecast3."NS_Forecasted Completed Cost";
                                        JobForecastSubLevelValInsert."NS_Cost To Complete" := JobForecast3."NS_Cost To Complete";
                                        JobForecastSubLevelValInsert."NS_Percent Complete" := JobForecast3."NS_Percent Complete";
                                        JobForecastSubLevelValInsert."NS_Remaining Hours" := JobForecast3."NS_Remaining Hours";
                                        JobForecastSubLevelValInsert."Budgeted Hours" := JobForecast3."Budgeted Hours";
                                        JobForecastSubLevelValInsert."NS_Bill Percent" := JobForecast3."NS_Bill Percent";
                                        JobForecastSubLevelValInsert."NS_Budgeted Hrs Percent Compelete" := JobForecast3."NS_Budgeted Hrs Percent Compelete";
                                        JobForecastSubLevelValInsert."NS_Forecasted Completed Price" := JobForecast3."NS_Forecasted Completed Price";
                                        JobForecastSubLevelValInsert."NS_Units Complete" := JobForecast3."NS_Units Complete";
                                    end;
                                    //PE-282.JS.1.0 12APR2024- end                                
                                    JobForecastSubLevelValInsert.MODIFY();
                                    //Build a new unposted line for display
                                    JobForecastSubLevelValInsert."NS_Line No." := JobForecastSubLevelValInsert."NS_Line No." + 1;

                                    //PE-282.JS.1.0 29APR2024-Start below code commented
                                    //if JobForecastSubLevelValInsert."NS_Percent Complete" = 0 then
                                    //    JobForecastSubLevelValInsert."NS_Status Date" := 0D;

                                    //JobForecastSubLevelValInsert."NS_Units Complete" := 0;
                                    //PE-282.JS.1.0 29APR2024-end  
                                    //"NS_Cost To Complete" := 0;//ctsi-231
                                    if JobForecastSubLevelValInsert."NS_Percent Complete" = 100 then
                                        //JobForecastSubLevelValInsert."NS_Forecasted Completed Cost" := NS_Get100PctCost(JobRec3."No.", JobForecastSubLevelValInsert."NS_Job Task No.") //PE-282.JS.1.0 29APR2024 line commented
                                        JobForecastSubLevelValInsert."NS_Forecasted Completed Cost" := NS_Get100PctCost(JobRec3."No.", JobForecastSubLevelValInsert."NS_Job Task No."); //PE-282.JS.1.0 29APR2024 line added
                                                                                                                                                                                        //PE-282.JS.1.0 29APR2024-Start below code commented
                                                                                                                                                                                        //else
                                                                                                                                                                                        //    JobForecastSubLevelValInsert."NS_Forecasted Completed Cost" := 0;
                                                                                                                                                                                        //JobForecastSubLevelValInsert."NS_Forecasted Completed Price" := 0;
                                                                                                                                                                                        //JobForecastSubLevelValInsert."NS_Hours To Finish" := 0;
                                                                                                                                                                                        //JobForecastSubLevelValInsert."NS_Bill Date" := 0D;
                                                                                                                                                                                        //JobForecastSubLevelValInsert."NS_Bill Percent" := 0;
                                                                                                                                                                                        //JobForecastSubLevelValInsert."NS_PO Expected Receipt Cost" := 0;
                                                                                                                                                                                        //PE-282.JS.1.0 29APR2024-end
                                    JobForecastSubLevelValInsert.NS_Posted := false;
                                    JobForecastSubLevelValInsert."NS_User ID" := '';
                                    OnBeforeInsertJobForecastSubLevelValInsert(JobForecastSubLevelValInsert); //FGH-163.SM.29022024 PE-269.JS.1.0 05MAR2024

                                    //PE-287.JS.1.0 29APR2024-Start
                                    if NSJobRec.get(JobForecast."NS_Job No.") then begin
                                        if NSJobRec.NS_UpdJFWForecastCompCostOnJT = true then begin
                                            if NSJobTaskRec.get(JobForecastSubLevelValInsert."NS_Job No.", JobForecastSubLevelValInsert."NS_Job Task No.") then begin
                                                if NSJobTaskRec."Job Task Type" = NSJobTaskRec."Job Task Type"::Posting then begin
                                                    NSJobTaskRec."NS_JFW Forecast Completed Cost" := JobForecastSubLevelValInsert."NS_Forecasted Completed Cost";
                                                    NSJobTaskRec.Modify();
                                                end;
                                            end;
                                        end;
                                    end;
                                    //PE-287.JS.1.0 29APR2024-end                                

                                    JobForecastSubLevelValInsert.INSERT;
                                end;

                            until JobForecastSubLevelValInsert.NEXT = 0;
                        end //else
                            //MESSAGE(Text003_Txt);//PRJ-441.MS.1.0 comment
                            //end;
                            //PRJ-1132.NK.1.0 End
                    UNTIL JobRec3.NEXT = 0;
                end

                ///// Job Forecast sublevel value insert - end
                //CTSI-115.AS.1.0 - end
            end;
        End;
    end;

    procedure UpdateJobTask(JobNo: Code[20]; JobTaskNo: Code[20]; StatusDate: Date; TotalPct: Decimal; BillDate: Date; BillPct: Decimal);
    var
        JobTask: Record "Job Task";
        Found: Boolean;
    begin
        with JobTask do begin
            Found := false;
            RESET();
            SETCURRENTKEY("Job No.", "Job Task No.");
            SETRANGE("Job No.", JobNo);
            SETRANGE("Job Task No.", JobTaskNo);
            if FINDSET(true) then begin
                "NS_Total Percent Complete Date" := StatusDate;
                "NS_Total Percent Complete" := TotalPct;
                "NS_Billing Percent Date" := BillDate;
                "NS_Billing Percent" := BillPct;
                MODIFY();
            end;
        end;
    end;

    procedure ForeCostAtCompFromWorksheet(JobNo: Code[20]; JobTaskNo: Code[20]; JobDateFilter: Text[30]): Decimal;
    var
        CompletionStatus: Record "NS_Job Forecast";
        CompletionStatusJob: Record "NS_Job Forecast";
        Answer: Decimal;
        Amount: Decimal;
        JobTaskHold: Code[20];
        AmountFound: Boolean;
    begin
        //Returns the projected cost at job or task completion from the worksheet
        //
        //Returns Task value if job and task is passed in.  Returns Job value if just job is passed in
        //
        //Accumulates last "Foecasted Completed Cost" value if there has been one posted - even if it is zero
        Answer := 0;
        with CompletionStatus do
            if JobNo > '' then begin
                RESET();
                SETRANGE("NS_Job No.", JobNo);
                if JobTaskNo > '' then
                    SETRANGE("NS_Job Task No.", JobTaskNo);
                if JobDateFilter > '' then
                    SETFILTER("NS_Status Date", JobDateFilter);
                if FINDSET() then begin
                    JobTaskHold := "NS_Job Task No.";
                    AmountFound := false;
                    repeat
                        if "NS_Job Task No." <> JobTaskHold then begin
                            if AmountFound then begin
                                Answer := Answer + Amount;
                                Amount := 0;
                                AmountFound := false;
                            end else
                                //Read Job Budget for the Task
                                if CompletionStatusJob.GET(JobNo) then begin
                                    CompletionStatusJob.SETFILTER("NS_Job Task No.", JobTaskHold);
                                    Answer := Answer + CompletionStatusJob."NS_Forecasted Completed Cost";
                                end;
                            JobTaskHold := "NS_Job Task No.";
                        end;
                        if "NS_Job Task No." = JobTaskHold then
                            if ("NS_Status Date" > 0D) and NS_Posted then begin
                                Amount := "NS_Forecasted Completed Cost";
                                AmountFound := true;
                            end;
                    until NEXT() = 0;

                    //Process the last record
                    if AmountFound then begin
                        Answer := Answer + Amount;
                        Amount := 0;
                    end else
                        //Read Job Budget for the Task
                        if CompletionStatusJob.GET(JobNo) then begin
                            CompletionStatusJob.SETFILTER("NS_Job Task No.", JobTaskHold);
                            Answer := Answer + CompletionStatusJob."NS_Forecasted Completed Cost";
                        end;
                end;
            end;

        exit(Answer);
    end;

    procedure NS_ForecastedCompletedAmtNoDate(JobNo: Code[20]; DefaultStatusDate: Date);
    var
        JobForecast2: Record "NS_Job Forecast";
        Job: Record Job;
        Amount: Decimal;
        JobTaskHold: Code[20];
        AmountFound: Boolean;
        JobPlanningLineBudget: Record "Job Planning Line";
        ProjectedCost: Decimal;
        PreviousJobForecast: Record "NS_Job Forecast";
        JobForecast: Record "NS_Job Forecast";
        TotalBudget: Decimal;
        ForecastedVariance: Decimal;
        TotalCostsUsed: Decimal;
        q: Integer;
        jobTbl: Record Job;//PE-160.AS.1.0 
    begin
        with JobForecast do
            if JobNo > '' then begin
                RESET();
                SETRANGE("NS_Job No.", JobNo);
                SETRANGE("NS_Line No.", 100);
                SETRANGE("NS_Status Date", 0D);
                SETRANGE(NS_Posted, false);
                SETFILTER("NS_Forecasted Completed Cost", '%1', 0);
                //SetRange(NS_Complete, false);//CTSI-232 roll back
                if FINDSET() then
                    repeat
                        if "NS_Job Task No." = '13-13200-13280' then
                            q := q;
                        TotalBudget := 0;
                        "NS_Percent Complete" := 0;
                        TotalCostsUsed := NS_Get100PctCost("NS_Job No.", "NS_Job Task No.");
                        JobPlanningLineBudget.RESET();
                        JobPlanningLineBudget.SETRANGE("Job No.", "NS_Job No.");
                        JobPlanningLineBudget.SETRANGE("Job Task No.", "NS_Job Task No.");
                        JobPlanningLineBudget.CALCSUMS("Total Cost", "Total Cost (LCY)");
                        //TotalBudget := JobPlanningLineBudget."Total Cost"; //PRJ-1326.NK.1.0 27APR2022 Block
                        TotalBudget := JobPlanningLineBudget."Total Cost (LCY)"; //PRJ-1326.NK.1.0 27APR2022
                        if jobTbl.get(JobForecast."NS_Job No.") then;
                        //PE-160.AS.1.0 condition added in old code IF Not begin..end START
                        if NOT ((jobTbl."NS_Include Sub Levels" = false) and (jobTbl."NS_Job Class" = jobTbl."NS_Job Class"::SubJob)) then begin
                            if JobForecast."NS_Hours To Finish" <> 0 then//ctsi-231
                                JobForecast."NS_Cost To Complete" := JobForecast."NS_Cost To Complete" //ctsi-231
                            else//ctsi-231
                                JobForecast."NS_Cost To Complete" := NS_CalcCostToComplete(JobForecast."NS_Status Date", JobForecast."NS_Percent Complete", TotalBudget, TotalCostsUsed,
                                                                         PreviousJobForecast."NS_Status Date",
                                                                         PreviousJobForecast."NS_Forecasted Completed Cost");

                        end;
                        //PE-160.AS.1.0 END

                        //PE-160.AS.1.0 start
                        if ((jobTbl."NS_Include Sub Levels" = false) and (jobTbl."NS_Job Class" = jobTbl."NS_Job Class"::SubJob)) then begin
                            JobForecast."NS_Cost To Complete" := JobForecast."NS_Cost To Complete";
                        end;
                        //PE-160.AS.1.0 end

                        //PE-160.AS.1.0 condition added in old code IF Not begin..end START
                        if NOT ((jobTbl."NS_Include Sub Levels" = false) and (jobTbl."NS_Job Class" = jobTbl."NS_Job Class"::SubJob)) then begin
                            JobForecast."NS_Forecasted Completed Cost" := TotalCostsUsed + JobForecast."NS_Cost To Complete";
                        end;
                        //PE-160.AS.1.0 END
                        "NS_Status Date" := DefaultStatusDate;
                        ForecastedVariance := TotalBudget - "NS_Forecasted Completed Cost";
                        MODIFY();
                    until NEXT() = 0;
            end;
    end;
    //end;
    //PRJ-1484.NK.1.0 30Jun2022 Start
    procedure NS_ForecastedCompletedAmtNoDateIncSubLev(JobNo: Code[20]; DefaultStatusDate: Date);
    var
        JobForecast2: Record "NS_Job Forecast";
        Job: Record Job;
        Amount: Decimal;
        JobTaskHold: Code[20];
        AmountFound: Boolean;
        JobPlanningLineBudget: Record "Job Planning Line";
        ProjectedCost: Decimal;
        PreviousJobForecast: Record "NS_Job Forecast";
        JobForecast: Record "NS_Job Forecast";
        TotalBudget: Decimal;
        ForecastedVariance: Decimal;
        TotalCostsUsed: Decimal;
        q: Integer;
    begin
        if JobNo > '' then begin
            JobForecast.RESET();
            JobForecast.SETRANGE("NS_Job No.", JobNo);
            JobForecast.SETRANGE("NS_Line No.", 100);
            JobForecast.SETRANGE("NS_Status Date", 0D);
            JobForecast.SETRANGE(NS_Posted, false);
            JobForecast.SETFILTER("NS_Forecasted Completed Cost", '%1', 0);
            JobForecast.SetRange("NS_Job Task No.", Rec."NS_Job Task No.");
            if JobForecast.FINDSET() then
                repeat
                    if JobForecast."NS_Job Task No." = '13-13200-13280' then
                        q := q;
                    TotalBudget := 0;
                    JobForecast."NS_Percent Complete" := 0;
                    TotalCostsUsed := NS_Get100PctCost(JobForecast."NS_Job No.", JobForecast."NS_Job Task No.");
                    JobPlanningLineBudget.RESET();
                    JobPlanningLineBudget.SETRANGE("Job No.", JobForecast."NS_Job No.");
                    JobPlanningLineBudget.SETRANGE("Job Task No.", JobForecast."NS_Job Task No.");
                    JobPlanningLineBudget.CALCSUMS("Total Cost", "Total Cost (LCY)");
                    TotalBudget := JobPlanningLineBudget."Total Cost (LCY)";
                    if JobForecast."NS_Hours To Finish" <> 0 then
                        JobForecast."NS_Cost To Complete" := JobForecast."NS_Cost To Complete" //ctsi-231
                    else
                        JobForecast."NS_Cost To Complete" := NS_CalcCostToComplete(JobForecast."NS_Status Date", JobForecast."NS_Percent Complete", TotalBudget, TotalCostsUsed,
                                                                 PreviousJobForecast."NS_Status Date",
                                                                 PreviousJobForecast."NS_Forecasted Completed Cost");

                    JobForecast."NS_Forecasted Completed Cost" := TotalCostsUsed + JobForecast."NS_Cost To Complete";
                    JobForecast."NS_Status Date" := DefaultStatusDate;
                    ForecastedVariance := TotalBudget - JobForecast."NS_Forecasted Completed Cost";
                    JobForecast.MODIFY();
                until JobForecast.NEXT() = 0;
        end;
    end;
    //PRJ-1484.NK.1.0 30Jun302022 End

    procedure NS_Get100PctCost(JobNo: Code[20]; JobTaskNo: Code[20]) TotalCostUsed: Decimal;
    var
        JobTask: Record "Job Task";
    begin
        TotalCostUsed := 0;
        JobTask.GET("NS_Job No.", "NS_Job Task No.");
        JobTask.CALCFIELDS("Usage (Total Cost)");
        TotalCostUsed := JobTask."Usage (Total Cost)";
        exit(TotalCostUsed);
    end;

    //AS - START COMMENT

    //SK Start
    [IntegrationEvent(false, false)]
    local procedure OnOpenJobForcastPage(var JobForecast: Record "NS_Job Forecast"; JobNo: Code[20]; DefaultStatusDate: date; NextBillDate: Date)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetJobForcastPage(var JobForecast: Record "NS_Job Forecast"; JobNo: Code[20]; DefaultStatusDate: date; NextBillDate: Date)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetCurrRecordJobForcastPage(var JobForecast: Record "NS_Job Forecast"; JobNo: Code[20]; DefaultStatusDate: date; NextBillDate: Date)
    begin
    end;
    //SK End

    //AS - END COMMENT
    //PRJ-1015.JS.1.0 06Oct2021 Start
    procedure NS_GetJobSubLevelBudgetAmount(var JobNo: code[20]; var JobTaskNo: Code[20]; var SubLevelTotalBudget: decimal; Var ASofDateFilter: date)
    var
        NS_JobIncludeSubLevelRec: Record "NS_Job Include Sub Levels";
        NS_JobCodeLen: Integer;
        NS_JobPlnLines: Record "Job Planning Line";
        NS_FilterJobNo: Code[20];
        IsHandled: Boolean;//FGH-163.SM.29022024  //PE-269.JS.1.0
    begin
        //FGH-163.SM.29022024 START //PE-269.JS.1.0
        OnBeforeGetJobSubLevelBudgetAmount(JobNo, JobTaskNo, SubLevelTotalBudget, ASofDateFilter, IsHandled);
        If IsHandled then
            exit;
        //FGH-163.SM.29022024 END //PE-269.JS.1.0

        NS_JobCodeLen := 0;
        SubLevelTotalBudget := 0;
        NS_FilterJobNo := '';
        NS_JobCodeLen := StrLen(JobNo);
        NS_FilterJobNo := '@*' + format(JobNo) + '*';
        NS_JobPlnLines.Reset();
        NS_JobPlnLines.Setfilter("NS_Sub-Level to Job No.", '%1', NS_FilterJobNo);
        NS_JobPlnLines.SetFilter("Line Type", '<>%1', NS_JobPlnLines."Line Type"::Billable);
        NS_JobPlnLines.SetFilter("Job Task No.", JobTaskNo);
        //PRJ-1189.GK.1.0 06apr2022 start
        If ASofDateFilter <> 0D then begin
            if JobSetup.Get() then;
            if (JobSetup."NS_Enab. Budg.on Contract Date" = false) then
                NS_JobPlnLines.Setfilter("Planning Date", '..%1', ASofDateFilter)
            else
                NS_JobPlnLines.Setfilter("NS_Contract Forecast Date", '..%1', ASofDateFilter)
        end;
        //PRJ-1189.GK.1.0 06apr2022 end
        If NS_JobPlnLines.FindSet() then begin
            NS_JobPlnLines.CalcSums("Total Cost");
            //SubLevelTotalBudget += NS_JobPlnLines."Total Cost";  //PRJ-1326.NK.1.0 27APR2022 Block
            SubLevelTotalBudget += NS_JobPlnLines."Total Cost (LCY)"  //PRJ-1326.NK.1.0 27APR2022
        end;
    end;

    procedure NS_GetSumOfJobSubLevelCostUsed(var JobNo: code[20]; var JobTaskNo: Code[20]; var SumOfSubLevelTotalCostUsed: decimal; Var ASofDateFilter: date)
    var
        NS_JobIncludeSubLevelRec: Record "NS_Job Include Sub Levels";
        NS_JobCodeLen: Integer;
        NS_JobLedgerEntry: Record "Job Ledger Entry";
        NS_FilterJobNo: Code[20];
        IsHandled: Boolean;//FGH-163.SM.29022024 //PE-269.JS.1.0
    begin
        //FGH-163.SM.29022024 START //PE-269.JS.1.0
        OnBeforeGetSumOfJobSubLevelCostUsed(JobNo, JobTaskNo, SumOfSubLevelTotalCostUsed, ASofDateFilter, IsHandled);
        if IsHandled then
            exit;
        //FGH-163.SM.29022024 END //PE-269.JS.1.0
        NS_JobCodeLen := 0;
        NS_FilterJobNo := '';
        NS_JobCodeLen := StrLen(JobNo);
        NS_FilterJobNo := '@*' + format(JobNo) + '*';
        NS_JobLedgerEntry.Reset();
        NS_JobLedgerEntry.SetFilter("NS_Sub-Level to Job No.", '<>%1', '');  //PRJ-1039.JS.1.0  15Nov2021
        NS_JobLedgerEntry.Setfilter("NS_Sub-Level to Job No.", '%1', NS_FilterJobNo);
        NS_JobLedgerEntry.SetFilter("Entry Type", '%1', NS_JobLedgerEntry."Entry Type"::Usage);
        NS_JobLedgerEntry.SetFilter("Job Task No.", '%1', JobTaskNo);   //PRJ-1039.JS.1.0  15Nov2021
        If ASofDateFilter <> 0D then
            NS_JobLedgerEntry.Setfilter("Posting Date", '..%1', ASofDateFilter);
        if NS_JobLedgerEntry.FindSet() then begin
            NS_JobLedgerEntry.CalcSums("Total Cost (LCY)");
            SumOfSubLevelTotalCostUsed += NS_JobLedgerEntry."Total Cost (LCY)";
        end;
    end;


    procedure NS_ForecastedCompletedAmtNoDateIncSubLevels(JobNo: Code[20]; DefaultStatusDate: Date);
    var
        JobForecast2: Record "NS_Job Forecast";
        Job: Record Job;
        Amount: Decimal;
        JobTaskHold: Code[20];
        AmountFound: Boolean;
        JobPlanningLineBudget: Record "Job Planning Line";
        ProjectedCost: Decimal;
        PreviousJobForecast: Record "NS_Job Forecast";
        JobForecast: Record "NS_Job Forecast";
        TotalBudget: Decimal;
        ForecastedVariance: Decimal;
        TotalCostsUsed: Decimal;
        q: Integer;
        NS_JobLedgerEntry: Record "Job Ledger Entry";
        NS_FilterJobNo: Code[20];
        IsHandled: Boolean;//FGH-163.SM.29022024 //PE-269.JS.1.0
    begin
        //FGH-163.SM.29022024 START //PE-269.JS.1.0
        OnBeforeForecastedCompletedAmtNoDateIncSubLevels(JobNo, DefaultStatusDate, IsHandled);
        if IsHandled then
            exit;
        //FGH-163.SM.29022024 END  //PE-269.JS.1.0
        //error('CCCCCC');   //ok
        NS_FilterJobNo := '';
        NS_FilterJobNo := '@*' + JobNo + '*';
        //PRJ-1132.NK.1.0 Start
        //with JobForecast do
        if JobNo > '' then begin
            JobForecast.RESET();
            JobForecast.SETRANGE("NS_Job No.", JobNo);
            JobForecast.SETRANGE("NS_Line No.", 100);
            JobForecast.SETRANGE("NS_Status Date", 0D);
            JobForecast.SETRANGE(NS_Posted, false);
            JobForecast.SETFILTER("NS_Forecasted Completed Cost", '<>%1', 0);  //PRJ-1355.JS.1.0 23MAY2022
            //Error('DDDDDD');    //ok
            if JobForecast.FINDSET() then
                repeat
                    if JobForecast."NS_Job Task No." = '13-13200-13280' then
                        q := q;
                    TotalBudget := 0;
                    JobForecast."NS_Percent Complete" := 0;
                    //TotalCostsUsed := NS_Get100PctCostIncludeSubLevel(JobForecast."NS_Job No.", JobForecast."NS_Job Task No.");  //PRJ-1355.JS.2.0 27MAY2022 Revert Paremeter line commented
                    TotalCostsUsed := NS_Get100PctCostIncludeSubLevelNew(JobForecast."NS_Job No.", JobForecast."NS_Job Task No.", DefaultStatusDate);  //PRJ-1355.JS.2.0 27MAY2022 add new procedure

                    JobPlanningLineBudget.RESET();
                    //JobPlanningLineBudget.SETRANGE("Job No.", "NS_Job No.");
                    JobPlanningLineBudget.setfilter("Job No.", '%1', NS_FilterJobNo);
                    JobPlanningLineBudget.SETRANGE("Job Task No.", JobForecast."NS_Job Task No.");
                    JobPlanningLineBudget.SetFilter("Planning Date", '<=%1', DefaultStatusDate);     //PRJ-1355.JS.1.0 23MAY2022
                    JobPlanningLineBudget.CALCSUMS("Total Cost", "Total Cost (LCY)");
                    //TotalBudget := JobPlanningLineBudget."Total Cost"; //PRJ-1326.NK.1.0 27APR2022 Block
                    TotalBudget := JobPlanningLineBudget."Total Cost (LCY)";//PRJ-1326.NK.1.0 27APR2022
                                                                            //PE-104.AS.1.0 START ---- Putted old codes inside override condition
                                                                            // if JobForecast.NS_ForecastedCompCostOverride = 0 then begin
                                                                            //     if JobForecast."NS_Hours To Finish" <> 0 then
                                                                            //         JobForecast."NS_Cost To Complete" := JobForecast."NS_Cost To Complete"
                                                                            //     else
                                                                            //         JobForecast."NS_Cost To Complete" := NS_CalcCostToCompleteIncludeSubLevels(JobForecast."NS_Status Date", JobForecast."NS_Percent Complete", TotalBudget, TotalCostsUsed,
                                                                            //                                                  PreviousJobForecast."NS_Status Date",
                                                                            //                                                  PreviousJobForecast."NS_Forecasted Completed Cost");

                    //     JobForecast."NS_Cost To Complete" := JobForecast."NS_Cost To Complete";
                    //     JobForecast."NS_Forecasted Completed Cost" := TotalCostsUsed + JobForecast."NS_Cost To Complete";
                    // end;
                    //PE-104.AS.1.0 END
                    JobForecast."NS_Status Date" := DefaultStatusDate;
                    ForecastedVariance := TotalBudget - JobForecast."NS_Forecasted Completed Cost";
                    JobForecast.MODIFY();
                until JobForecast.NEXT() = 0;
        end;
        //PRJ-1132.NK.1.0 End   
    end;

    procedure NS_Get100PctCostIncludeSubLevel(JobNo: Code[20]; JobTaskNo: Code[20]) TotalCostUsed: Decimal;   //PRJ-1355.JS.2.0 27MAY2022 Revert Parameter
    var
        JobTask: Record "Job Task";
        JobTask2: Record "Job Task";
        NS_JobIncludeSubLevelRec: Record "NS_Job Include Sub Levels";
        NS_JobCodeLen: Integer;
        NS_JobLedgerEntry: Record "Job Ledger Entry";
        NS_FilterJobNo: Code[20];
    begin
        //PRJ-1355.JS.1.0 23MAY2022 - Start
        NS_JobCodeLen := 0;
        NS_FilterJobNo := '';
        NS_JobCodeLen := StrLen(JobNo);
        NS_FilterJobNo := '@*' + JobNo + '*';
        TotalCostUsed := 0;
        // JobTask.GET("NS_Job No.", "NS_Job Task No.");
        // JobTask.CALCFIELDS("Usage (Total Cost)");
        // TotalCostUsed := JobTask."Usage (Total Cost)";
        JobTask.Reset();
        JobTask.SetFilter("Job No.", '%1', NS_FilterJobNo);
        JobTask.SetRange("Job Task No.", JobTaskNo);
        //JobTask.SetFilter("Planning Date Filter", '%1', DefaultStatusDate);  //PRJ-1355.JS.2.0 27MAY2022 comment line
        JobTask.CALCFIELDS("Usage (Total Cost)");
        TotalCostUsed := JobTask."Usage (Total Cost)";

        // NS_JobIncludeSubLevelRec.Reset();
        // NS_JobIncludeSubLevelRec.SetFilter("NS_Sub Level Job No.", '<>%1', '');
        // NS_JobIncludeSubLevelRec.SetFilter("NS_Sub Level Job No.", '%1', NS_FilterJobNo);
        // If NS_JobIncludeSubLevelRec.FindSet() then begin
        //     repeat
        //         //PRJ-1355.JS.1.0 23MAY2022 - Start
        //         if JobTask2.GET(NS_JobIncludeSubLevelRec."NS_Job No.", NS_JobIncludeSubLevelRec."NS_Job Task No.") then begin
        //             JobTask2.CALCFIELDS("Usage (Total Cost)");
        //             TotalCostUsed += JobTask2."Usage (Total Cost)";
        //         end;
        //     //PRJ-1355.JS.1.0 23MAY2022 - end
        //     until NS_JobIncludeSubLevelRec.Next() = 0;
        // end;
        //FGH-163.SM.29022024 START  //PE-269.JS.1.0
        OnBeforeGet100PctCostIncludeSubLevel(JobNo, JobTaskNo, TotalCostUsed);
        //FGH-163.SM.29022024 END  //PE-269.JS.1.0
        exit(TotalCostUsed);
        //PRJ-1355.JS.1.0 23MAY2022 - end
    end;


    procedure NS_GetSumofBudgetRemainingIncludeSubLevels(JobNo: Code[20]; JobTaskNo: Code[20]; var JobPlanningLine: Record "Job Planning Line"; var SumofBudgetRemaining: Decimal; Var ASofDateFilter: date; var SumofForecastedVariance: Decimal);
    var
        JobPlanningLineWork: Record "Job Planning Line";
        JobPlanningLineWork2: Record "Job Planning Line";    //PRJ-1039.JS.1.0  12Nov2021
        JobForcastWork: Record "NS_Job Forecast";
        JobLocal: Record Job;
        TotalBudg: Decimal;
        JobTask: Record "Job Task";
        JobTask2: Record "Job Task";
        NS_JobIncludeSubLevelRec: Record "NS_Job Include Sub Levels";
        NS_JobCodeLen: Integer;
        NS_JobLedgerEntry: Record "Job Ledger Entry";
        NS_JobLedgerEntry2: Record "Job Ledger Entry";  //PRJ-1039.JS.1.0  15Nov2021
        NS_FilterJobNo: Code[20];
        TotalUsageCost: Decimal;        //PRJ-1039.JS.1.0  12Nov2021 
        SumOfforecastedCompletedCost: Decimal;   //PRJ-1039.JS.1.0  12Nov2021        
    begin
        //PRJ-1039.JS.1.0  12Nov2021 -Start
        TotalUsageCost := 0;
        SumofBudgetRemaining := 0;
        SumOfforecastedCompletedCost := 0;
        //PRJ-1039.JS.1.0  12Nov2021 -end        
        SumofBudgetRemaining := 0;
        SumofForecastedVariance := 0;
        NS_JobCodeLen := 0;
        NS_FilterJobNo := '';
        NS_JobCodeLen := StrLen(JobNo);
        NS_FilterJobNo := '@*' + format(JobNo) + '*';
        //with JobForcastWork do begin
        JobForcastWork.Reset();
        JobForcastWork.SETRANGE("NS_Job No.", JobNo);
        JobForcastWork.SetFilter(NS_Posted, '%1', false);
        if JobForcastWork.FindSet() then
            repeat
                JobPlanningLineWork.reset;
                JobPlanningLineWork.SetRange("Job No.", JobForcastWork."NS_Job No.");
                JobPlanningLineWork.SetRange("Job Task No.", JobForcastWork."NS_Job Task No.");
                //PRJ-1189.GK.1.0 06apr2022 start
                If ASofDateFilter <> 0D then begin
                    if JobSetup.Get() then;
                    if (JobSetup."NS_Enab. Budg.on Contract Date" = false) then
                        JobPlanningLineWork.Setfilter("Planning Date", '..%1', ASofDateFilter)
                    else
                        JobPlanningLineWork.Setfilter("NS_Contract Forecast Date", '..%1', ASofDateFilter)
                end;
                //PRJ-1189.GK.1.0 06apr2022 end
                JobPlanningLineWork.SetFilter("Line Type", '<>%1', JobPlanningLineWork."Line Type"::Billable);
                if JobPlanningLineWork.FindSet() then begin
                    JobPlanningLineWork.CalcSums("Total Cost");
                    //TotalBudg := TotalBudg + JobPlanningLineWork."Total Cost"; //PRJ-1326.NK.1.0 27APR2022
                    TotalBudg := TotalBudg + JobPlanningLineWork."Total Cost (LCY)"; //PRJ-1326.NK.1.0 27APR2022
                end;

                JobPlanningLineWork2.reset;
                JobPlanningLineWork2.setfilter("NS_Sub-Level to Job No.", '<>%1', '');
                JobPlanningLineWork2.setfilter("NS_Sub-Level to Job No.", '%1', NS_FilterJobNo);
                JobPlanningLineWork2.SetRange("Job Task No.", JobForcastWork."NS_Job Task No.");
                //PRJ-1189.GK.1.0 06apr2022 start
                If ASofDateFilter <> 0D then begin
                    if JobSetup.Get() then;
                    if (JobSetup."NS_Enab. Budg.on Contract Date" = false) then
                        JobPlanningLineWork2.Setfilter("Planning Date", '..%1', ASofDateFilter)
                    else
                        JobPlanningLineWork2.Setfilter("NS_Contract Forecast Date", '..%1', ASofDateFilter)
                end;
                //PRJ-1189.GK.1.0 06apr2022 end
                JobPlanningLineWork2.SetFilter("Line Type", '<>%1', JobPlanningLineWork2."Line Type"::Billable);
                if JobPlanningLineWork2.FindSet() then begin
                    JobPlanningLineWork2.CalcSums("Total Cost", "Total Cost (LCY)");
                    //TotalBudg := TotalBudg + JobPlanningLineWork2."Total Cost"; //PRJ-1326.NK.1.0 27APR2022 Block
                    TotalBudg := TotalBudg + JobPlanningLineWork2."Total Cost (LCY)"; //PRJ-1326.NK.1.0 27APR2022
                end;

                NS_JobLedgerEntry.Reset();
                NS_JobLedgerEntry.setrange("Entry Type", NS_JobLedgerEntry."Entry Type"::Usage);
                NS_JobLedgerEntry.SetRange("Job No.", JobForcastWork."NS_Job No.");
                NS_JobLedgerEntry.SetRange("Job Task No.", JobForcastWork."NS_Job Task No.");
                if ASofDateFilter <> 0D then
                    NS_JobLedgerEntry.SETFILTER("Posting Date", '..%1', AsOfDateFilter);
                if NS_JobLedgerEntry.FindSet() then begin
                    NS_JobLedgerEntry.CalcSums("Total Cost (LCY)");
                    TotalUsageCost := TotalUsageCost + NS_JobLedgerEntry."Total Cost (LCY)";
                end;

                NS_JobLedgerEntry2.Reset();
                NS_JobLedgerEntry2.setrange("Entry Type", NS_JobLedgerEntry2."Entry Type"::Usage);
                NS_JobLedgerEntry2.Setfilter("NS_Sub-Level to Job No.", '<>%1', '');
                NS_JobLedgerEntry2.Setfilter("NS_Sub-Level to Job No.", '%1', NS_FilterJobNo);
                NS_JobLedgerEntry2.SetRange("Job Task No.", JobForcastWork."NS_Job Task No.");
                if ASofDateFilter <> 0D then
                    NS_JobLedgerEntry2.SETFILTER("Posting Date", '..%1', AsOfDateFilter);
                if NS_JobLedgerEntry2.FindSet() then begin
                    NS_JobLedgerEntry2.CalcSums("Total Cost (LCY)");
                    TotalUsageCost := TotalUsageCost + NS_JobLedgerEntry2."Total Cost (LCY)";
                end;

                SumofBudgetRemaining := TotalBudg - TotalUsageCost;
                SumOfforecastedCompletedCost := SumOfforecastedCompletedCost + JobForcastWork."NS_Forecasted Completed Cost";
                //Message('AAAA TotalBudg........%1..TotalUsageCost.....%2......SumOfforecastedCompletedCost....%3', TotalBudg, TotalUsageCost, SumOfforecastedCompletedCost);

                if JobForcastWork."NS_Percent Complete" <> 100 then
                    SumofForecastedVariance := SumofForecastedVariance + (TotalBudg - JobForcastWork."NS_Forecasted Completed Cost")
                else
                    SumofForecastedVariance := SumofForecastedVariance + (TotalBudg - TotalUsageCost);

            //Message('BBB TotalBudg........%1..TotalUsageCost.....%2......SumOfforecastedCompletedCost....%3', TotalBudg, TotalUsageCost, SumOfforecastedCompletedCost);
            //PRJ-1039.JS.1.0  12Nov2021 - Code commented Start
            // RESET;
            // SETRANGE("NS_Job No.", JobNo);
            // JobForcastWork.SetFilter(NS_Posted, '%1', false);
            // if FINDSET then
            //     repeat
            //         TotalBudg := 0;
            //         JobPlanningLineWork.reset;
            //         JobPlanningLineWork.SetRange("Job No.", JobNo);
            //         //JobPlanningLineWork.SetFilter("Job No.", '%1', NS_FilterJobNo);
            //         JobPlanningLineWork.SetRange("Job Task No.", "NS_Job Task No.");
            //         if ASofDateFilter <> 0D then
            //             JobPlanningLineWork.setfilter("Planning Date", '..%1', ASofDateFilter);
            //         JobPlanningLineWork.SetFilter("Line Type", '<>%1', JobPlanningLineWork."Line Type"::Billable);
            //         if JobPlanningLineWork.FindSet() then begin
            //             JobPlanningLineWork.CalcSums("Total Cost");
            //             TotalBudg := TotalBudg + JobPlanningLineWork."Total Cost"
            //         end;
            //         // repeat
            //         //     TotalBudg := TotalBudg + JobPlanningLineWork."Total Cost"
            //         // until JobPlanningLineWork.next = 0;

            //         //Add Sub Levels-Start
            //         NS_JobIncludeSubLevelRec.Reset();
            //         NS_JobIncludeSubLevelRec.SetFilter("NS_Sub Level Job No.", '<>%1', '');
            //         NS_JobIncludeSubLevelRec.SetFilter("NS_Sub Level Job No.", '%1', NS_FilterJobNo);
            //         If NS_JobIncludeSubLevelRec.FindSet() then begin
            //             repeat
            //                 JobPlanningLineWork.Reset();
            //                 JobPlanningLineWork.SetRange("Job No.", NS_JobIncludeSubLevelRec."NS_Job No.");
            //                 JobPlanningLineWork.SetRange("Job Task No.", NS_JobIncludeSubLevelRec."NS_Job Task No.");
            //                 if ASofDateFilter <> 0D then
            //                     JobPlanningLineWork.setfilter("Planning Date", '..%1', ASofDateFilter);
            //                 JobPlanningLineWork.SetFilter("Line Type", '<>%1', JobPlanningLineWork."Line Type"::Billable);
            //                 if JobPlanningLineWork.FindSet() then begin
            //                     JobPlanningLineWork.CalcSums("Total Cost");
            //                     TotalBudg += JobPlanningLineWork."Total Cost";
            //                 end;
            //             until NS_JobIncludeSubLevelRec.Next() = 0;
            //         end;
            //         //Add Sub Levels-Start


            //         JobLocal.Reset();
            //         JobLocal.SetRange("No.", JobNo);
            //         JobLocal.SetRange("NS_Job Task No. Filter", "NS_Job Task No.");
            //         if ASofDateFilter <> 0D then
            //             JobLocal.SETFILTER("NS_Date Filter", '..%1', AsOfDateFilter)
            //         else
            //             JobLocal.SETRANGE("NS_Date Filter");
            //         if JobLocal.FindFirst() then;
            //         JobLocal.CALCFIELDS("NS_Usage (Cost) (LCY)");
            //         SumofBudgetRemaining := SumofBudgetRemaining + (TotalBudg - JobLocal."NS_Usage (Cost) (LCY)");
            // if "NS_Percent Complete" <> 100 then
            //     SumofForecastedVariance := TotalBudg - "NS_Forecasted Completed Cost"
            // else
            //     SumofForecastedVariance := TotalBudg - TotalUsageCost;
            //PRJ-1039.JS.1.0  12Nov2021 - Code commented End

            //Message('BBB TotalBudg........%1..TotalUsageCost.....%2......SumOfforecastedCompletedCost....%3', TotalBudg, TotalUsageCost, SumOfforecastedCompletedCost);
            until JobForcastWork.NEXT = 0;
        //SumofForecastedVariance := (TotalBudg - SumOfforecastedCompletedCost);
        //end;
    end;

    procedure NS_GetJobPlanningLineAndBudgetIncludeSubLevels(JobNo: Code[20]; JobTaskNo: Code[20]; var JobPlanningLine: Record "Job Planning Line"; var TotalBudget: Decimal; Var ASofDateFilter: date);
    var
        JobPlanningLineWork: Record "Job Planning Line";
        JobPlanningLineWorkUnit: Record "Job Planning Line";
        JobPlanningLineFirst: Record "Job Planning Line";
        NSJobs: Record Job;
        JobPlanningLineWork2: Record "Job Planning Line";
        FoundWorkUnitsRecord: Boolean;
        NS_JobIncludeSubLevelRec: Record "NS_Job Include Sub Levels";
        NS_JobCodeLen: Integer;
        NS_JobLedgerEntry: Record "Job Ledger Entry";
        NS_FilterJobNo: Code[20];
        IsHandled: Boolean;//FGH-163.SM.29022024  //PE-269.JS.1.0
    begin
        //FGH-163.SM.29022024 //PE-269.JS.1.0 START
        OnBeforeGetJobPlanningLineAndBudgetIncludeSubLevels(JobNo, JobTaskNo, JobPlanningLine, TotalBudget, AsOfDateFilter, IsHandled);
        if IsHandled then
            exit;
        //FGH-163.SM.29022024 END //PE-269.JS.1.0
        TotalBudget := 0;
        NS_JobCodeLen := 0;
        NS_FilterJobNo := '';
        NS_JobCodeLen := StrLen(JobNo);
        NS_FilterJobNo := '@*' + format(JobNo) + '*';
        CLEAR(JobPlanningLine);
        CLEAR(JobPlanningLineFirst);
        CLEAR(JobPlanningLineWorkUnit);
        //PRJ-1132.NK.1.0 Start
        //with JobPlanningLineWork do begin
        JobPlanningLineWork.RESET();
        JobPlanningLineWork.SETRANGE("Job No.", JobNo);
        //SetFilter("Job No.", '%1', NS_FilterJobNo);
        if JobTaskNo > '' then
            JobPlanningLineWork.SETRANGE("Job Task No.", JobTaskNo);
        //PRJ-1189.GK.1.0 06apr2022 start
        If ASofDateFilter <> 0D then begin
            if JobSetup.Get() then;
            if (JobSetup."NS_Enab. Budg.on Contract Date" = false) then
                JobPlanningLineWork.Setfilter("Planning Date", '..%1', ASofDateFilter)
            else
                JobPlanningLineWork.Setfilter("NS_Contract Forecast Date", '..%1', ASofDateFilter)
        end;
        //PRJ-1189.GK.1.0 06apr2022 end
        JobPlanningLineWork.SetFilter("Line Type", '<>%1', JobPlanningLineWork."Line Type"::Billable);
        if JobPlanningLineWork.FINDSET then
            repeat
                if JobPlanningLineWork."NS_Work Units" > 0 then begin
                    JobPlanningLineWorkUnit := JobPlanningLineWork;
                    FoundWorkUnitsRecord := true;
                end else begin
                    if JobPlanningLineFirst."Job No." = '' then
                        JobPlanningLineFirst := JobPlanningLineWork;
                end;
                //TotalBudget := TotalBudget + JobPlanningLineWork."Total Cost"; //PRJ-1326.NK.1.0 27APR2022 Block
                TotalBudget := TotalBudget + JobPlanningLineWork."Total Cost (LCY)"; //PRJ-1326.NK.1.0 27APR2022
            until JobPlanningLineWork.NEXT() = 0;

        // //Add Sub Levels-Start
        // NS_JobIncludeSubLevelRec.Reset();
        // NS_JobIncludeSubLevelRec.SetFilter("NS_Sub Level Job No.", '<>%1', '');
        // NS_JobIncludeSubLevelRec.SetFilter("NS_Sub Level Job No.", '%1', NS_FilterJobNo);
        // If NS_JobIncludeSubLevelRec.FindSet() then begin
        //     repeat
        //         JobPlanningLineWork.Reset();
        //         JobPlanningLineWork.SetRange("Job No.", NS_JobIncludeSubLevelRec."NS_Job No.");
        //         JobPlanningLineWork.SetRange("Job Task No.", NS_JobIncludeSubLevelRec."NS_Job Task No.");
        //         if ASofDateFilter <> 0D then
        //             JobPlanningLineWork.setfilter("Planning Date", '..%1', ASofDateFilter);
        //         JobPlanningLineWork.SetFilter("Line Type", '<>%1', JobPlanningLineWork."Line Type"::Billable);
        //         if JobPlanningLineWork.FindSet() then begin
        //             JobPlanningLineWork.CalcSums("Total Cost");
        //             TotalBudget += JobPlanningLineWork."Total Cost";
        //         end;
        //     until NS_JobIncludeSubLevelRec.Next() = 0;
        // end;
        // //Add Sub Levels-Start

        JobPlanningLineWork2.Reset();
        JobPlanningLineWork2.Setfilter("NS_Sub-Level to Job No.", '%1', NS_FilterJobNo);
        JobPlanningLineWork2.SetRange("Job Task No.", JobTaskNo);
        //PRJ-1189.GK.1.0 06apr2022 start
        If ASofDateFilter <> 0D then begin
            if JobSetup.Get() then;
            if (JobSetup."NS_Enab. Budg.on Contract Date" = false) then
                JobPlanningLineWork2.Setfilter("Planning Date", '..%1', ASofDateFilter)
            else
                JobPlanningLineWork2.Setfilter("NS_Contract Forecast Date", '..%1', ASofDateFilter)
        end;
        //PRJ-1189.GK.1.0 06apr2022 end
        JobPlanningLineWork2.SetFilter("Line Type", '<>%1', JobPlanningLineWork2."Line Type"::Billable);
        if JobPlanningLineWork2.FindSet() then begin
            JobPlanningLineWork2.CalcSums("Total Cost", "Total Cost (LCY)");
            //TotalBudget += JobPlanningLineWork2."Total Cost"; //PRJ-1326.NK.1.0 27APR2022 Block
            TotalBudget += JobPlanningLineWork2."Total Cost (LCY)"; //PRJ-1326.NK.1.0 27APR2022
        end;

        if FoundWorkUnitsRecord then
            JobPlanningLine := JobPlanningLineWorkUnit
        else
            JobPlanningLine := JobPlanningLineFirst;

        //end;
        //PRJ-1132.NK.1.0 End
    end;

    procedure NS_PostLinesIncludeSubLevels(JobNo: Code[20]; DefaultStatusDate: Date; NextBillDate: Date);
    var
        JobForecast: Record "NS_Job Forecast";
        JobForecast2: Record "NS_Job Forecast";
        BillStartDate: Date;
        BillEndDate: Date;
        JobDateFilter: Text;
        TotalCostsUsed: Decimal;
        q: Integer;
        ReportJobForecast: Record "NS_Job Forecast";
        JobForecastWorksheetReport: Report "NS_Percentage of Compl.";
        JobForecastWorksheetReport_C: Report "NS_Percentage of Compl.";
        JobForecastWorksheetReport_C1: Report "NS_POCompl Include Sub Levels";
        IncludeSublevelBool: Boolean;
        JobsetupRec: Record "Jobs Setup";
        JobRecord: Record Job;
        JobRec2: Record Job;
        JobRec3: Record Job;
        JobTable: Record job;
        GBPGValTxt: Text;
        JobForecastSubLevelValInsert: Record "NS_Job Forecast";
        JobForecastWkshtPg: Page "NS_Job Forecast Worksheet";
        JobForecastTable: Record "NS_Job Forecast";
        JobNoFilter: Code[20];
        IsHandled: Boolean;//FGH-163.SM.29022024 PE-269.JS.1.0 05MAR2024
    begin
        //FGH-163.SM.29022024 START //PE-269.JS.1.0
        OnBeforePostLinesIncludeSubLevels(JobNo, DefaultStatusDate, NextBillDate, IsHandled);
        if IsHandled then
            exit;
        //FGH-163.SM.29022024 END //PE-269.JS.1.0
        //Message('BBBBB');  //OK
        JobNoFilter := '';
        JobNoFilter := '@*' + JobNo + '*';
        JobsetupRec.Get;


        Clear(IncludeSublevelBool);

        Clear(GBPGValTxt);

        GBPGValTxt := JobsetupRec."NS_GBPG for Job Forecast";

        //PRJ-1355.JS.1.0 23MAY2022 Start
        if JobNo <> '' then begin
            if JobTable.get(JobNo) then
                if ((JobTable."NS_Sub-Level to Job No." = '') and (JobTable."NS_Include Sub Levels" = true)) then begin
                    if JobRecord.Get(JobTable."No.") then
                        NS_ForecastedCompletedAmtNoDateIncSubLevels(JobRecord."No.", DefaultStatusDate);
                end;
        end;
        //PRJ-1355.JS.1.0 23MAY2022 end
        //PRJ-1132.NK.1.0 Start
        //with JobForecast do begin
        if JobNo > '' then begin
            if DefaultStatusDate > 0D then begin
                //Error('EEEEEE');   //OK
                //FGH-163.SM.29022024 PE-269.JS.1.0 05MAR2024 START
                OnBeforeRunReportPOComplSubLevel(JobNo, DefaultStatusDate, IsHandled);
                If IsHandled = false then begin
                    //FGH-163.SM.29022024 PE-269.JS.1.0 05MAR2024 END
                    JobForecastWorksheetReport_C1.Set(JobNo, DefaultStatusDate);
                    JobForecastWorksheetReport_C1.RunModal();
                    Clear(JobForecastWorksheetReport_C1);
                end;
                // JobRec2.RESET;
                // //JobRec2.SETRANGE("NS_Sub-Level to Job No.", JobNo);
                // JobRec2.setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                // if GBPGValTxt > '' then
                //     JobRec2.SetFilter("NS_Gen. Bus. Posting Group", GBPGValTxt);
                // JobRec2.SetRange("NS_Exclude from Job Forecast", false);
                // if JobRec2.findset then begin
                //     REPEAT
                //         if JobRec2."No." > '' then begin
                //             //AS - START COMMENT

                //             //SK Start
                //             OnOpenJobForcastPage(JobForecast, JobRec2."No.", DefaultStatusDate, NextBillDate);

                //             JobForecastTable.Reset();
                //             JobForecastTable.SetRange("NS_Job No.", JobRec2."No.");
                //             if JobForecastTable.FindSet() then
                //                 repeat
                //                     OnAfterGetJobForcastPage(JobForecastTable, JobRec2."No.", DefaultStatusDate, NextBillDate);
                //                     OnAfterGetCurrRecordJobForcastPage(JobForecastTable, JobRec2."No.", DefaultStatusDate, NextBillDate);
                //                     JobForecastTable.Modify();
                //                 until JobForecastTable.Next() = 0;
                //             //SK End

                //             //AS - END COMMENT

                //             JobForecastWorksheetReport_C1.Set(JobRec2."No.", DefaultStatusDate);
                //             JobForecastWorksheetReport_C1.RunModal();
                //             Clear(JobForecastWorksheetReport_C1);
                //         end;
                //     UNTIL JobRec2.NEXT = 0;
                //end
                //else begin

                //end;

                // if IncludeSublevelBool = false then begin
                //     JobForecastWorksheetReport.Set(JobNo, DefaultStatusDate);
                //     JobForecastWorksheetReport.RUNMODAL();
                //     CLEAR(JobForecastWorksheetReport);
                // end
            end else
                ERROR('Please check the As of date field');
        end;
        //CTSI-94.ms.1.0.end
        JobSetup.GET();
        JobForecast.RESET();
        JobForecast.MARKEDONLY(false);
        if JobNo > '' then
            JobForecast.SETRANGE("NS_Job No.", JobNo);
        JobForecast.SETRANGE(NS_Posted, false);
        //SetFilter(NS_Complete, '%1', false);//CTSI-232 roll back
        if (JobNo = '') and (NextBillDate > 0D) then begin
            BillStartDate := DMY2DATE(1, DATE2DMY(NextBillDate, 2), DATE2DMY(NextBillDate, 3));
            if DATE2DMY(BillStartDate, 2) < 12 then
                BillEndDate := CALCDATE('<-1D>', DMY2DATE(1, DATE2DMY(NextBillDate, 2) + 1, DATE2DMY(NextBillDate, 3)))
            else
                BillEndDate := DMY2DATE(12, 31, DATE2DMY(NextBillDate, 3));

            JobForecast.SETFILTER("NS_Bill Date", '%1..%2', BillStartDate, BillEndDate);
            if JobForecast.FINDSET() then
                repeat
                    JobForecast.MARK := true;
                until JobForecast.NEXT() = 0;
            JobForecast.SETRANGE("NS_Bill Date");
            JobForecast.SETFILTER("NS_Status Date", '%1..%2', CALCDATE('<-31D>', BillStartDate), BillEndDate);
            if JobForecast.FINDSET() then
                repeat
                    JobForecast.MARK := true;
                until JobForecast.NEXT() = 0;
            JobForecast.SETRANGE("NS_Status Date");
            JobForecast.MARKEDONLY(true);
        end;
        if JobForecast.COUNT = 0 then
            MESSAGE(Text002_Txt);
        if JobForecast.FINDSET() then begin
            repeat
                if ((JobForecast."NS_Status Date" > 0D) or
                    (JobForecast."NS_Percent Complete" > 0))
                   and
                   ((JobForecast."NS_Percent Complete" = 100) or
                    (JobForecast."NS_Percent Complete" < JobSetup."NS_Forecast Percent For HrsReq") or
                    (JobSetup."NS_Forecast Percent For HrsReq" = 0) or
                    (JobForecast."NS_Hours To Finish" > 0) or
                    (JobForecast."NS_Entry Type" = JobForecast."NS_Entry Type"::Price)) then begin
                    if (JobForecast."NS_Entry Type" = JobForecast."NS_Entry Type"::Price) and (JobForecast."NS_Status Date" = 0D) then
                        JobForecast."NS_Status Date" := DefaultStatusDate;
                    JobForecast.NS_Posted := true;
                    JobForecast."NS_User ID" := USERID;
                    if JobForecast."NS_Job Task No." = '13-13200-13280' then
                        q := q;
                    if JobForecast."NS_Forecasted Completed Cost" = 0 then begin
                        JobForecast2.RESET();
                        JobForecast2.SETRANGE("NS_Job No.", JobForecast."NS_Job No.");
                        JobForecast2.SETRANGE("NS_Job Task No.", JobForecast."NS_Job Task No.");
                        JobForecast2.SETRANGE("NS_Line No.", JobForecast."NS_Line No." - 1);
                        //JobForecast2.SetFilter(NS_Complete, '%1', false); //CTSI-232 roll back
                        if (JobForecast2.FINDFIRST()) and (JobForecast2."NS_Forecasted Completed Cost" <> 0) then
                            JobForecast."NS_Forecasted Completed Cost" := JobForecast2."NS_Forecasted Completed Cost";
                    end;
                    JobForecast.MODIFY();
                    //Build a new unposted line for display
                    JobForecast."NS_Line No." := JobForecast."NS_Line No." + 1;

                    //if "NS_Percent Complete" = 0 then //PRJ-565 comment
                    //    "NS_Status Date" := 0D;

                    JobForecast."NS_Units Complete" := 0;
                    //"NS_Cost To Complete" := 0;//ctsi-231
                    if JobForecast."NS_Percent Complete" = 100 then
                        JobForecast."NS_Forecasted Completed Cost" := NS_Get100PctCost(JobForecast."NS_Job No.", JobForecast."NS_Job Task No.")
                    else
                        JobForecast."NS_Forecasted Completed Cost" := 0;
                    JobForecast."NS_Forecasted Completed Price" := 0;
                    //"NS_Hours To Finish" := 0;//PRJ-565.MS.1.0 roll back //PRJ-565.AS.1.0 12MARCH2021- COMMENT
                    JobForecast."NS_Bill Date" := 0D;
                    JobForecast."NS_Bill Percent" := 0;
                    JobForecast."NS_PO Expected Receipt Cost" := 0;
                    JobForecast."NS_Posted Check Boolean" := true;//JD-48.AS.1.0
                    JobForecast.NS_Posted := false;
                    JobForecast."NS_User ID" := '';
                    JobForecast.INSERT();
                end;
            until JobForecast.NEXT() = 0;
        end else
            MESSAGE(Text003_Txt);
        //CTSI-115.AS.1.0 - start
        ///// Job Forecast sublevel value insert - start
        if IncludeSublevelBool = true then begin
            JobRec3.RESET;
            JobRec3.SETRANGE("NS_Sub-Level to Job No.", JobNo);
            if GBPGValTxt > '' then
                //PRJ-1489.GK.1.0 start
                JobRec3.SetFilter("NS_Gen. Bus. Posting Group New", GBPGValTxt);
            //JobRec3.SetFilter("NS_Gen. Bus. Posting Group", GBPGValTxt);
            //PRJ-1489.GK.1.0 end
            JobRec3.SetRange("NS_Exclude from Job Forecast", false);
            if JobRec3.FindSet then begin
                REPEAT
                    //PRJ-1132.NK.1.0 Start
                    //with JobForecastSubLevelValInsert do begin
                    JobForecastSubLevelValInsert.RESET();
                    JobForecastSubLevelValInsert.MARKEDONLY(false);
                    if JobRec3."No." > '' then
                        SETRANGE("NS_Job No.", JobRec3."No.");
                    JobForecastSubLevelValInsert.SETRANGE(NS_Posted, false);
                    //SetFilter(NS_Complete, '%1', false);//CTSI-232 roll back
                    if (JobRec3."No." = '') and (NextBillDate > 0D) then begin
                        BillStartDate := DMY2DATE(1, DATE2DMY(NextBillDate, 2), DATE2DMY(NextBillDate, 3));
                        if DATE2DMY(BillStartDate, 2) < 12 then
                            BillEndDate := CALCDATE('-1D', DMY2DATE(1, DATE2DMY(NextBillDate, 2) + 1, DATE2DMY(NextBillDate, 3)))
                        else
                            BillEndDate := DMY2DATE(12, 31, DATE2DMY(NextBillDate, 3));

                        JobForecastSubLevelValInsert.SETFILTER("NS_Bill Date", '%1..%2', BillStartDate, BillEndDate);
                        if JobForecastSubLevelValInsert.FINDSET() then
                            repeat
                                JobForecastSubLevelValInsert.MARK := true;
                            until JobForecastSubLevelValInsert.NEXT = 0;
                        JobForecastSubLevelValInsert.SETRANGE("NS_Bill Date");
                        JobForecastSubLevelValInsert.SETFILTER("NS_Status Date", '%1..%2', CALCDATE('-31D', BillStartDate), BillEndDate);
                        if JobForecastSubLevelValInsert.FINDSET then
                            repeat
                                JobForecastSubLevelValInsert.MARK := true;
                            until JobForecastSubLevelValInsert.NEXT = 0;
                        JobForecastSubLevelValInsert.SETRANGE("NS_Status Date");
                        JobForecastSubLevelValInsert.MARKEDONLY(true);
                    end;
                    //if COUNT = 0 then
                    //    MESSAGE(Text002_Txt);//PRJ-441.MS.1.0 comment
                    if JobForecastSubLevelValInsert.FINDSET then begin
                        repeat
                            if ((JobForecastSubLevelValInsert."NS_Status Date" > 0D) or
                                (JobForecastSubLevelValInsert."NS_Percent Complete" > 0))
                               and
                               ((JobForecastSubLevelValInsert."NS_Percent Complete" = 100) or
                                (JobForecastSubLevelValInsert."NS_Percent Complete" < JobSetup."NS_Forecast Percent For HrsReq") or
                                (JobSetup."NS_Forecast Percent For HrsReq" = 0) or
                                (JobForecastSubLevelValInsert."NS_Hours To Finish" > 0) or
                                (JobForecastSubLevelValInsert."NS_Entry Type" = JobForecastSubLevelValInsert."NS_Entry Type"::Price)) then begin
                                if (JobForecastSubLevelValInsert."NS_Entry Type" = JobForecastSubLevelValInsert."NS_Entry Type"::Price) and (JobForecastSubLevelValInsert."NS_Status Date" = 0D) then
                                    JobForecastSubLevelValInsert."NS_Status Date" := DefaultStatusDate;
                                JobForecastSubLevelValInsert.NS_Posted := true;
                                JobForecastSubLevelValInsert."NS_User ID" := USERID;
                                if JobForecastSubLevelValInsert."NS_Job Task No." = '13-13200-13280' then
                                    q := q;
                                if JobForecastSubLevelValInsert."NS_Forecasted Completed Cost" = 0 then begin
                                    JobForecast2.RESET;
                                    JobForecast2.SETRANGE("NS_Job No.", JobRec3."No.");
                                    JobForecast2.SETRANGE("NS_Job Task No.", JobForecastSubLevelValInsert."NS_Job Task No.");
                                    JobForecast2.SETRANGE("NS_Line No.", JobForecastSubLevelValInsert."NS_Line No." - 1);
                                    if (JobForecast2.FINDFIRST) and (JobForecast2."NS_Forecasted Completed Cost" <> 0) then
                                        JobForecastSubLevelValInsert."NS_Forecasted Completed Cost" := JobForecast2."NS_Forecasted Completed Cost";
                                end;
                                JobForecastSubLevelValInsert.MODIFY;
                                //Build a new unposted line for display
                                JobForecastSubLevelValInsert."NS_Line No." := JobForecastSubLevelValInsert."NS_Line No." + 1;

                                if JobForecastSubLevelValInsert."NS_Percent Complete" = 0 then
                                    JobForecastSubLevelValInsert."NS_Status Date" := 0D;

                                JobForecastSubLevelValInsert."NS_Units Complete" := 0;
                                //"NS_Cost To Complete" := 0;//ctsi-231
                                if JobForecastSubLevelValInsert."NS_Percent Complete" = 100 then
                                    JobForecastSubLevelValInsert."NS_Forecasted Completed Cost" := NS_Get100PctCost(JobRec3."No.", JobForecastSubLevelValInsert."NS_Job Task No.")
                                else
                                    JobForecastSubLevelValInsert."NS_Forecasted Completed Cost" := 0;
                                JobForecastSubLevelValInsert."NS_Forecasted Completed Price" := 0;
                                JobForecastSubLevelValInsert."NS_Hours To Finish" := 0;
                                JobForecastSubLevelValInsert."NS_Bill Date" := 0D;
                                JobForecastSubLevelValInsert."NS_Bill Percent" := 0;
                                JobForecastSubLevelValInsert."NS_PO Expected Receipt Cost" := 0;
                                JobForecastSubLevelValInsert.NS_Posted := false;
                                JobForecastSubLevelValInsert."NS_User ID" := '';
                                JobForecastSubLevelValInsert.INSERT();
                            end;

                        until JobForecastSubLevelValInsert.NEXT = 0;
                    end //else
                        //MESSAGE(Text003_Txt);//PRJ-441.MS.1.0 comment
                        //end;
                        //PRJ-1132.NK.1.0
                UNTIL JobRec3.NEXT = 0;
            end
            else begin

            end;
        end;
        ///// Job Forecast sublevel value insert - end
        //CTSI-115.AS.1.0 - end
        //end;
        //PRJ-1132.NK.1.0 End
    end;

    procedure NS_GetLastPostedStatusIncludeSubLevels(JobNo: Code[20]; JobTaskNo: Code[20]; DateLimit: Date; var JobForecast: Record "NS_Job Forecast");
    begin
        JobForecast.Reset();
        JobForecast.SetCurrentKey(NS_Posted);
        JobForecast.SetRange(NS_Posted, true);
        JobForecast.SetRange("NS_Job No.", JobNo);
        JobForecast.SetRange("NS_Job Task No.", JobTaskNo);
        if DateLimit > 0D then
            JobForecast.setfilter("NS_Status Date", '<=%1', DateLimit);
        if not JobForecast.FindLast() then
            Clear(JobForecast);
    end;

    procedure NS_CalcPercentFrom0To100IncludeSubLevels(Value: Decimal; Base: Decimal): Decimal;
    var
        Answer: Decimal;
    begin
        if Value <> 0 then begin
            Answer := ROUND((Base / Value) * 100, 0.01);
            if Answer > 100 then
                //  Answer := 100 //PRJCTPR-55.NK.1.0 Start 01feb2022 
                Answer := Answer //PRJCTPR-55.NK.1.0 Start 01feb2022 comment by NK

            else
                if Answer < 0 then
                    // Answer := 0;//PRJCTPR-55.NK.1.0 Start 01feb2022 comment by nitesh
                    Answer := Answer;        //PRJCTPR-55.NK.1.0 Start 01feb2022 c
        end else
            if Base <= 0 then
                // Answer := 0.0 //PRJCTPR-55.NK.1.0 Start 01feb2022 comment by nitesh
                Answer := Answer //PRJCTPR-55.NK.1.0 Start 01feb2022 
            else
                //Answer := 100.0; //PRJCTPR-55.NK.1.0 Start 01feb2022 comment by nitesh
                Answer := Answer;

        exit(Answer);
    end;

    procedure NS_CalcCostToCompleteIncludeSubLevels(StatusDate: Date; PercentComplete: Decimal; TotalBudget: Decimal; CurrentCost: Decimal; PrevStatusDate: Date; PrevForecastedCompletedCost: Decimal) Answer: Decimal;
    var
        PercentRemaining: Decimal;
    begin
        //Returns a calculated amount needed to complete based on values passed in

        Answer := 0;

        //Get a value based on previous data first
        if PrevStatusDate = 0D then begin         //Is there previous data to use?
            Answer := TotalBudget - CurrentCost;    //No, just do calculations based on the job's budget
            if Answer < 0 then
                Answer := 0;
        end else begin                            //Yes, do calculations based on the value previously calculated
            Answer := PrevForecastedCompletedCost - CurrentCost;
            if Answer < 0 then
                Answer := 0;
        end;

        //Check if user entry should override what was calculated
        if (StatusDate > 0D) and (PercentComplete > 0) then begin
            if PercentComplete <> 100 then
                PercentRemaining := 100 - PercentComplete
            else
                PercentRemaining := 0;


            Answer := (CurrentCost / (PercentComplete / 100)) - CurrentCost;
            if (Answer = 0) and (TotalBudget > 0) then
                Answer := TotalBudget / PercentComplete * PercentRemaining;
        end;

        exit(Answer);
    end;

    procedure NS_GetUnpostedRecordIncludeSubLevels(JobNo: Code[20]; JobTaskNo: Code[20]; var JobForecast: Record "NS_Job Forecast");
    begin
        //Return the Job Forecast record for the Job and Task passed in with a status of not Posted
        //PRJ-1132.NK.1.0 Start
        //with JobForecast do begin
        JobForecast.RESET();
        JobForecast.SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date");
        JobForecast.SETRANGE("NS_Job No.", JobNo);
        JobForecast.SETRANGE("NS_Job Task No.", JobTaskNo);
        JobForecast.SETRANGE(NS_Posted, false);
        if not JobForecast.FINDFIRST() then
            CLEAR(JobForecast);
        //end;
        //PRJ-1132.NK.1.0 End
    end;

    procedure NS_GetBudgetHoursIncludeSubLevels(JobNo: Code[20]; JobTaskNo: Code[20]; var JobPlanningLine: Record "Job Planning Line"; var BudgetedHrs: Decimal; Var ASofDateFilter: date);
    var
        JobPlanningLineWork: Record "Job Planning Line";
        JobPlanningLineWorkUnit: Record "Job Planning Line";
        JobPlanningLineFirst: Record "Job Planning Line";
        JobPlanningLineWork2: Record "Job Planning Line";
        FoundWorkUnitsRecord: Boolean;
        JobNoFilter: Code[20];
        IsHandled: Boolean;//FGH-163.SM.29022024 //PE-269.JS.1.0
    begin
        //FGH-163.SM.29022024 START //PE-269.JS.1.0
        OnBeforeGetBudgetHoursIncludeSubLevels(JobNo, JobTaskNo, JobPlanningLine, BudgetedHrs, ASofDateFilter, IsHandled);
        if IsHandled then
            exit;
        //FGH-163.SM.29022024 END //PE-269.JS.1.0
        JobNoFilter := '';
        JobNoFilter := '@*' + format(JobNo) + '*';
        CLEAR(JobPlanningLine);
        CLEAR(JobPlanningLineFirst);
        CLEAR(JobPlanningLineWorkUnit);
        //PRJ-1132.NK.1.0 Start
        //with JobPlanningLineWork do begin
        JobPlanningLineWork.RESET;
        //SETRANGE("Job No.", JobNo);
        JobPlanningLineWork.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        if JobTaskNo > '' then
            JobPlanningLineWork.SETRANGE("Job Task No.", JobTaskNo);
        //PRJ-1189.GK.1.0 06apr2022 start
        If ASofDateFilter <> 0D then begin
            if JobSetup.Get() then;
            if (JobSetup."NS_Enab. Budg.on Contract Date" = false) then
                JobPlanningLineWork.Setfilter("Planning Date", '..%1', ASofDateFilter)
            else
                JobPlanningLineWork.Setfilter("NS_Contract Forecast Date", '..%1', ASofDateFilter)
        end;
        //PRJ-1189.GK.1.0 06apr2022 end
        JobPlanningLineWork.SetFilter("Line Type", '<>%1', JobPlanningLineWork."Line Type"::Billable);
        JobPlanningLineWork.SetFilter("Schedule Line", '%1', true);
        JobPlanningLineWork.SetFilter(Type, '%1', JobPlanningLineWork.Type::Resource);
        //JobPlanningLineWork.SetFilter("Unit of Measure Code", '%1', 'HR');//PRJ-1524.GK.1.0 25July2022
        JobPlanningLineWork.SetFilter("Unit of Measure Code", '%1|%2', 'HR', 'HOUR');//PRJ-1524.GK.1.0 25July2022
        if JobPlanningLineWork.FINDSET() then
            repeat
                if JobPlanningLineWork."NS_Work Units" > 0 then begin
                    JobPlanningLineWorkUnit := JobPlanningLineWork;
                    FoundWorkUnitsRecord := true;
                end else begin
                    if JobPlanningLineFirst."Job No." = '' then
                        JobPlanningLineFirst := JobPlanningLineWork;
                end;
                BudgetedHrs := BudgetedHrs + JobPlanningLineWork.Quantity;
            until JobPlanningLineWork.NEXT() = 0;

        // JobPlanningLineWork2.Reset();
        // JobPlanningLineWork2.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        // JobPlanningLineWork2.SetRange("Job Task No.", JobTaskNo);
        // if ASofDateFilter <> 0D then
        //     JobPlanningLineWork2.setfilter("Planning Date", '..%1', ASofDateFilter);
        // JobPlanningLineWork2.SetFilter("Line Type", '<>%1', JobPlanningLineWork2."Line Type"::Billable);
        // JobPlanningLineWork2.SetFilter("Schedule Line", '%1', true);
        // JobPlanningLineWork2.SetFilter(Type, '%1', JobPlanningLineWork2.Type::Resource);
        // JobPlanningLineWork2.SetFilter("Unit of Measure Code", '%1', 'HR');
        // if JobPlanningLineWork2.FindSet() then begin
        //     JobPlanningLineWork2.CalcSums(Quantity);
        //     BudgetedHrs += JobPlanningLineWork2.Quantity;
        // end;

        if FoundWorkUnitsRecord then
            JobPlanningLine := JobPlanningLineWorkUnit
        else
            JobPlanningLine := JobPlanningLineFirst;
        //end;
        //PRJ-1132.NK.1.0 End
    end;
    //PRJ-565 end      

    //PRJ-1015.JS.1.0    14Oct2021
    //PRJ-1039.JS.1.0  10Nov2021-Start

    procedure NS_GetJobSumofTotalBudgetIncludeSubLevels(JobNo: Code[20]; JobTaskNo: Code[20]; var JobPlanningLine: Record "Job Planning Line"; var SumofTotalBudget: Decimal; Var ASofDateFilter: date);
    var
        JobPlanningLineWork: Record "Job Planning Line";
        JobPlanningLineWorkUnit: Record "Job Planning Line";
        JobPlanningLineFirst: Record "Job Planning Line";
        FoundWorkUnitsRecord: Boolean;
        JobNoFilter: Code[20];
        IsHandled: Boolean;//FGH-163.SM29022024 //PE-269.JS.1.0
    begin
        //FGH-163.SM.29022024 START //PE-269.JS.1.0
        OnBeforeGetJobSumofTotalBudgetIncludeSubLevels(JobNo, JobTaskNo, JobPlanningLine, SumofTotalBudget, ASofDateFilter, IsHandled);
        if IsHandled then
            exit;
        //FGH-163.SM.29022024 END //PE-269.JS.1.0
        JobNoFilter := '';
        JobNoFilter := '@*' + format(JobNo) + '*';
        //SumofTotalBudget := 0;
        CLEAR(JobPlanningLine);
        CLEAR(JobPlanningLineFirst);
        CLEAR(JobPlanningLineWorkUnit);
        //PRJ-1132.NK.1.0 Start
        //with JobPlanningLineWork do begin
        JobPlanningLineWork.RESET();
        //SETRANGE("Job No.", JobNo);
        JobPlanningLineWork.setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        //PRJ-1189.GK.1.0 06apr2022 start
        If ASofDateFilter <> 0D then begin
            if JobSetup.Get() then;
            if (JobSetup."NS_Enab. Budg.on Contract Date" = false) then
                JobPlanningLineWork.Setfilter("Planning Date", '..%1', ASofDateFilter)
            else
                JobPlanningLineWork.Setfilter("NS_Contract Forecast Date", '..%1', ASofDateFilter)
        end;
        //PRJ-1189.GK.1.0 06apr2022 end
        JobPlanningLineWork.SetFilter("Line Type", '<>%1', JobPlanningLineWork."Line Type"::Billable);
        if JobPlanningLineWork.FINDSET then
            repeat
                if JobPlanningLineWork."NS_Work Units" > 0 then begin
                    JobPlanningLineWorkUnit := JobPlanningLineWork;
                    FoundWorkUnitsRecord := true;
                end else begin
                    if JobPlanningLineFirst."Job No." = '' then
                        JobPlanningLineFirst := JobPlanningLineWork;
                end;
                //SumofTotalBudget := SumofTotalBudget + JobPlanningLineWork."Total Cost"; //PRJ-1326.NK.1.0 27APR2022 Block
                SumofTotalBudget := SumofTotalBudget + JobPlanningLineWork."Total Cost (LCY)"; //PRJ-1326.NK.1.0 27APR2022
            until JobPlanningLineWork.NEXT() = 0;

        if FoundWorkUnitsRecord then
            JobPlanningLine := JobPlanningLineWorkUnit
        else
            JobPlanningLine := JobPlanningLineFirst;
        //end;
        //PRJ-1132.NK.1.0 End
    end;

    procedure NS_GetSumOfTotalCostsUsedIncludeSubLevels(JobNo: Code[20]; JobTaskNo: Code[20]; var JobPlanningLine: Record "Job Planning Line"; var SumOfTotalCostsUsed: Decimal; Var ASofDateFilter: date);
    var
        JobForcastWork: Record "NS_Job Forecast";
        JobLocal: Record Job;
        JobNoFilter: Code[20];
        NS_JobLedgerEntry: Record "Job Ledger Entry";
        SumOfTotalCostsUsedSubLevels: Decimal;   //PRJ-1039.JS.1.0  14Dec2021
        IsHandled: Boolean;//FGH-163.SM.29022024 //PE-269.JS.1.0
    begin
        //FGH-163.SM.29022024 START //PE-269.JS.1.0
        OnBeforeGetSumOfTotalCostsUsedIncludeSubLevels(JobNo, JobTaskNo, JobPlanningLine, SumOfTotalCostsUsed, ASofDateFilter, IsHandled);
        if IsHandled then
            exit;
        //FGH-163.SM.29022024 END //PE-269.JS.1.0
        JobNoFilter := '';
        JobNoFilter := '@*' + format(JobNo) + '*';
        SumOfTotalCostsUsedSubLevels := 0;
        //PRJ-1039.JS.1.0  14Dec2021-start
        // NS_JobLedgerEntry.Reset();        
        // NS_JobLedgerEntry.Setfilter("NS_Sub-Level to Job No.", '<>%1', '');  //PRJ-1039.JS.1.0  15Nov2021  line commented 14Dec2021
        // NS_JobLedgerEntry.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        // NS_JobLedgerEntry.SetFilter("Entry Type", '%1', NS_JobLedgerEntry."Entry Type"::Usage);
        // //NS_JobLedgerEntry.SetFilter("Job Task No.", JobTaskNo);
        // If ASofDateFilter <> 0D then
        //     NS_JobLedgerEntry.Setfilter("Posting Date", '..%1', ASofDateFilter);
        // if NS_JobLedgerEntry.FindSet() then begin
        //     NS_JobLedgerEntry.CalcSums("Total Cost (LCY)");
        //     SumOfTotalCostsUsed := SumOfTotalCostsUsed + NS_JobLedgerEntry."Total Cost (LCY)";
        // end;
        // SumOfTotalCostsUsed := SumOfTotalCostsUsed + SumOfTotalCostsUsedSubLevels;

        //SumOfTotalCostsUsed := 0;
        //PRJ-1132.NK.1.0 Start
        //with JobForcastWork do begin
        JobForcastWork.RESET();
        JobForcastWork.SETRANGE("NS_Job No.", JobNo);
        JobForcastWork.SetFilter(NS_Posted, '%1', false);
        if JobForcastWork.FINDSET() then
            repeat
                JobLocal.Reset();
                //JobLocal.SetRange("No.", JobNo);  //PRJ-1039.JS.1.0  14Dec2021  line commented
                JobLocal.setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);  //PRJ-1039.JS.1.0  14Dec2021  line addded
                JobLocal.SetRange("NS_Job Task No. Filter", JobForcastWork."NS_Job Task No.");
                if ASofDateFilter <> 0D then
                    JobLocal.SETFILTER("NS_Date Filter", '..%1', AsOfDateFilter)
                else
                    JobLocal.SETRANGE("NS_Date Filter");
                if JobLocal.Findset() then begin
                    repeat
                        JobLocal.CALCFIELDS("NS_Usage (Cost) (LCY)");
                        SumOfTotalCostsUsed := SumOfTotalCostsUsed + JobLocal."NS_Usage (Cost) (LCY)";

                    until JobLocal.Next() = 0;
                end;
            until JobForcastWork.NEXT = 0;
        //end;
        //PRJ-1132.NK.1.0 End
    end;
    //PRJ-1039.JS.1.0  14Dec2021-end
    //PRJ-1039.JS.1.0  10Nov2021-end  

    //PE-90.AS.2.0 START
    procedure NS_GetForecastOverrideTotalsWithoutContractDate(var JobNo: Code[20]; var JobTaskNo: Code[20]) Answer: Decimal;
    var
        JobTask: Record "Job Task";
        JobTask1: Record "Job Task";
        JobNoFilter: Code[20];
        SumOfForecastedCompCostOverride: Decimal;
        SumOfForecastedCompCostOverrideSubLevel: Decimal;
        FinalvalSubLevel: Decimal;
        NSJob: Record Job;
        NSJob1: Record Job;
    begin
        JobNoFilter := '';
        SumOfForecastedCompCostOverride := 0;
        SumOfForecastedCompCostOverrideSubLevel := 0;
        FinalvalSubLevel := 0;
        JobNoFilter := format(JobNo);

        NSJob1.Reset();
        NSJob1.SetCurrentKey("No.");
        NSJob1.SetFilter("No.", JobNo);
        if NSJob1.FindFirst() then begin
            JobTask1.Reset();
            JobTask1.SetFilter("Job No.", NSJob1."No.");
            JobTask1.SetRange("Job Task No.", JobTaskNo);
            if JobTask1.FindFirst() then
                SumOfForecastedCompCostOverride := JobTask1.NS_ForecastedCompCostOverride;
        end;

        NSJob.Reset();
        NSJob.SetCurrentKey("NS_Sub-Level to Job No.");
        NSJob.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        NSJob.SetRange("NS_Contract Date", 0D);
        if NSJob.FindSet() then
            repeat
                JobTask.Reset();
                JobTask.SetFilter("Job No.", NSJob."No.");
                JobTask.SetRange("Job Task No.", JobTaskNo);
                if JobTask.FindSet then
                    repeat
                        SumOfForecastedCompCostOverrideSubLevel += JobTask.NS_ForecastedCompCostOverride;
                    until JobTask.NEXT = 0;
            until NSJob.Next() = 0;

        FinalvalSubLevel := SumOfForecastedCompCostOverrideSubLevel;

        Answer := SumOfForecastedCompCostOverride + FinalvalSubLevel;
        exit(Answer);
    end;
    //PE-90.AS.2.0 END

    //PE-90.AS.3.0 START
    procedure NS_GetForecastOverrideTotalsWithContractDate(StartDate: Date; var Enddate: Date; var JobNo: Code[20]; var JobTaskNo: Code[20]) Answer: Decimal;
    var
        JobTask: Record "Job Task";
        JobNoFilter: Code[20];
        SumOfForecastedCompCostOverrideSubLevel: Decimal;
        FinalvalSubLevel: Decimal;
        NSJob: Record Job;
    begin
        JobNoFilter := '';
        SumOfForecastedCompCostOverrideSubLevel := 0;
        FinalvalSubLevel := 0;
        JobNoFilter := format(JobNo);

        if Enddate <> 0D then begin
            NSJob.Reset();
            NSJob.SetCurrentKey("NS_Sub-Level to Job No.", "NS_Contract Date");
            NSJob.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
            NSJob.SetFilter("NS_Contract Date", '..%1', Enddate);
            if NSJob.FindSet() then
                repeat
                    if NSJob."NS_Contract Date" <> 0D then begin
                        JobTask.Reset();
                        JobTask.SetFilter("Job No.", NSJob."No.");
                        JobTask.SetRange("Job Task No.", JobTaskNo);
                        if JobTask.FindSet then
                            repeat
                                SumOfForecastedCompCostOverrideSubLevel += JobTask.NS_ForecastedCompCostOverride;
                            until JobTask.NEXT = 0;
                    end;
                until NSJob.Next() = 0;

            FinalvalSubLevel := SumOfForecastedCompCostOverrideSubLevel;
            Answer := FinalvalSubLevel;
            exit(Answer);
        end;
    end;
    //PE-90.AS.3.0 END

    procedure NS_GetSumofBudgetRemainingIncludeSubLevelsNew(JobNo: Code[20]; JobTaskNo: Code[20]; var JobPlanningLine: Record "Job Planning Line"; var SumofBudgetRemaining: Decimal; Var ASofDateFilter: date; var SumofForecastedVariance: Decimal);
    var
        JobPlanningLineWork: Record "Job Planning Line";
        JobPlanningLineWork2: Record "Job Planning Line";
        JobForcastWork: Record "NS_Job Forecast";
        JobLocal: Record Job;
        JobLocal2: Record Job;
        TotalBudg: Decimal;
        NS_Jobs: Record Job;
        NS_JobNoFilter: Code[30];  //PRJ-1039.JS.2.0 12JAN2022
        NSTotalUsageCost: Decimal;
        IsHandled: Boolean;//FGH-163.SM.2902202429022024  //PE-269.JS.1.0
    begin
        //FGH-163.SM.29022024 START //PE-269.JS.1.0
        OnBeforeGetSumofBudgetRemainingIncludeSubLevelsNew(JobNo, JobTaskNo, JobPlanningLine, SumofBudgetRemaining, ASofDateFilter, SumofForecastedVariance, IsHandled);
        if IsHandled then
            exit;
        //FGH-163.SM.29022024 END //PE-269.JS.1.0
        SumofBudgetRemaining := 0;
        SumofForecastedVariance := 0;
        NS_JobNoFilter := '';
        NS_JobNoFilter := '@*' + Format(JobNo) + '*';
        //PRJ-1132.NK.1.0 Start
        //with JobForcastWork do begin
        JobForcastWork.RESET();
        JobForcastWork.SETRANGE("NS_Job No.", JobNo);
        JobForcastWork.SetFilter(NS_Posted, '%1', false);
        if JobForcastWork.FINDSET() then
            repeat
                TotalBudg := 0;
                NSTotalUsageCost := 0;
                JobPlanningLineWork.reset();
                JobPlanningLineWork.SetRange("Job No.", JobNo);
                JobPlanningLineWork.SetRange("Job Task No.", JobForcastWork."NS_Job Task No.");
                //PRJ-1189.GK.1.0 06apr2022 start
                If ASofDateFilter <> 0D then begin
                    if JobSetup.Get() then;
                    if (JobSetup."NS_Enab. Budg.on Contract Date" = false) then
                        JobPlanningLineWork.Setfilter("Planning Date", '..%1', ASofDateFilter)
                    else
                        JobPlanningLineWork.Setfilter("NS_Contract Forecast Date", '..%1', ASofDateFilter)
                end;
                //PRJ-1189.GK.1.0 06apr2022 end
                JobPlanningLineWork.SetFilter("Line Type", '<>%1', JobPlanningLineWork."Line Type"::Billable);
                if JobPlanningLineWork.FindSet() then
                    repeat
                        //TotalBudg := TotalBudg + JobPlanningLineWork."Total Cost" //PRJ-1326.NK.1.0 27APR2022
                        TotalBudg := TotalBudg + JobPlanningLineWork."Total Cost (LCY)"; //PRJ-1326.NK.1.0 27APR2022
                    until JobPlanningLineWork.next = 0;

                //For sub Jobs-PRJ-1039-Start    
                If NS_Jobs.get(JobForcastWork."NS_Job No.") then
                    if ((NS_Jobs."NS_Job Class" = NS_Jobs."NS_Job Class"::"Master Job") AND (NS_Jobs."NS_Include Sub Levels" = true)) then begin
                        JobPlanningLineWork2.reset;
                        JobPlanningLineWork2.setfilter("NS_Sub-Level to Job No.", '<>%1', '');
                        JobPlanningLineWork2.setfilter("NS_Sub-Level to Job No.", '%1', NS_JobNoFilter);
                        JobPlanningLineWork2.SetRange("Job Task No.", JobForcastWork."NS_Job Task No.");    //PRJ-1039.JS.2.0 12JAN2022
                        //PRJ-1189.GK.1.0 06apr2022 start
                        If ASofDateFilter <> 0D then begin
                            if JobSetup.Get() then;
                            if (JobSetup."NS_Enab. Budg.on Contract Date" = false) then
                                JobPlanningLineWork2.Setfilter("Planning Date", '..%1', ASofDateFilter)
                            else
                                JobPlanningLineWork2.Setfilter("NS_Contract Forecast Date", '..%1', ASofDateFilter)
                        end;
                        //PRJ-1189.GK.1.0 06apr2022 end
                        JobPlanningLineWork2.SetFilter("Line Type", '<>%1', JobPlanningLineWork2."Line Type"::Billable);
                        if JobPlanningLineWork2.FindSet() then
                            repeat
                                //TotalBudg := TotalBudg + JobPlanningLineWork2."Total Cost"  //PRJ-1326.NK.1.0 27APR2022 Block
                                TotalBudg := TotalBudg + JobPlanningLineWork2."Total Cost (LCY)"; //PRJ-1326.NK.1.0 27APR2022
                            until JobPlanningLineWork2.next = 0;
                    end;
                //For sub Jobs-PRJ-1039-Start

                JobLocal.Reset();
                JobLocal.SetRange("No.", JobNo);
                JobLocal.SetRange("NS_Job Task No. Filter", JobForcastWork."NS_Job Task No.");
                if ASofDateFilter <> 0D then
                    JobLocal.SETFILTER("NS_Date Filter", '..%1', AsOfDateFilter)
                else
                    JobLocal.SETRANGE("NS_Date Filter");
                if JobLocal.FindFirst() then begin
                    JobLocal.CALCFIELDS("NS_Usage (Cost) (LCY)");
                    NSTotalUsageCost := JobLocal."NS_Usage (Cost) (LCY)";
                end;
                //For sub Jobs-PRJ-1039-Start
                JobLocal2.Reset();
                JobLocal2.SetFilter("NS_Sub-Level to Job No.", '<>%1', '');
                JobLocal2.SetFilter("NS_Sub-Level to Job No.", '%1', NS_JobNoFilter);
                JobLocal2.SetRange("NS_Job Task No. Filter", JobForcastWork."NS_Job Task No.");
                if ASofDateFilter <> 0D then
                    JobLocal2.SETFILTER("NS_Date Filter", '..%1', AsOfDateFilter)
                else
                    JobLocal2.SETRANGE("NS_Date Filter");
                if JobLocal2.Findset() then
                    repeat
                        JobLocal2.CALCFIELDS("NS_Usage (Cost) (LCY)");
                        NSTotalUsageCost := NSTotalUsageCost + JobLocal2."NS_Usage (Cost) (LCY)";
                    until JobLocal2.Next() = 0;
                //For sub Jobs-PRJ-1039-Start
                //if (TotalBudg - JobLocal."Usage (Cost) (LCY)") > 0 then //PRJ-611 comment
                //SumofBudgetRemaining := SumofBudgetRemaining + (TotalBudg - JobLocal."NS_Usage (Cost) (LCY)");
                SumofBudgetRemaining := SumofBudgetRemaining + (TotalBudg - NSTotalUsageCost);
                if "NS_Percent Complete" <> 100 then
                    SumofForecastedVariance := SumofForecastedVariance + (TotalBudg - JobForcastWork."NS_Forecasted Completed Cost")
                else
                    SumofForecastedVariance := SumofForecastedVariance + (TotalBudg - NSTotalUsageCost);
            until JobForcastWork.NEXT() = 0;

        //end;
        //PRJ-1132.NK.1.0 Start
    end;
    //PRJ-1039.JS.1.0  10Nov2021-end                            

    [IntegrationEvent(false, false)]
    local procedure OnCheckPPLicenseExpire()
    begin
    end;

    //PRJ-1056.JS.1.0 24Nov2021-Start
    procedure NS_ForecastedCompletedAmtPOC(Mode: Option "Records Cost","Records Price","Worksheet Cost","Worksheet Price"; JobNo: Code[20]; JobTaskNo: Code[20]; JobDateFilter: Text[30]) Answer: Decimal;
    var
        JobForecast: Record "NS_Job Forecast";
        JobForecast2: Record "NS_Job Forecast";
        Job: Record Job;
        Amount: Decimal;
        JobTaskHold: Code[20];
        AmountFound: Boolean;
    begin
        //Returns a cost or price value from the Forecasted Job or Task completion.  This can be based on the last posting or the current unposted values
        //
        //Mode - Records Cost - returns a posted cost value
        //               Accumulates last "Forecasted Completed Cost" value if there has been one posted - even if it is zero
        //                   otherwise the "Budgeted Cost (LCY)" for the task is accumulated.
        //
        //     - Records Price - returns a posted price value
        //               Accumulates last "Forecasted Completed Price" value if there has been one posted - even if it is zero
        //                   otherwise the "Budgeted Price (LCY)" for the task is accumulated
        //
        //     - Worksheet Cost - returns the unposted cost value
        //              Accumulates last "Foecasted Completed Cost" value if there has been one posted - even if it is zero
        //
        //     - Worksheet Price - returns the posted price value
        //             Accumulates "Forecasted Completed Price" value if there has been one posted - even if it is zero
        //
        //JobNo and JobTaskNo used to filter the value.  Returns a full Job value if no JobTaskNo is passed in.
        //
        //JobDateFilter is used to filter the accumulated data for the Worksheet modes

        Answer := 0;

        with JobForecast do begin
            if JobNo > '' then begin
                RESET;
                SETRANGE("NS_Job No.", JobNo);
                JobForecast.SETRANGE(NS_Posted, true);   //PRJ-1056.JS.1.0   23Nov2021  roll back
                if JobTaskNo > '' then
                    SETRANGE("Ns_Job Task No.", JobTaskNo);
                if (JobDateFilter > '') and ((Mode = Mode::"Worksheet Cost") or (Mode = Mode::"Worksheet Price")) then
                    SETFILTER("NS_Status Date", JobDateFilter);
                if FINDSET then begin
                    JobTaskHold := "Ns_Job Task No.";
                    AmountFound := false;
                    repeat
                        if "NS_Job Task No." <> JobTaskHold then begin
                            if AmountFound then begin
                                Answer := Answer + Amount;
                                Amount := 0;
                                AmountFound := false;
                            end else
                                //Read Job Budget for the Task
                                case Mode of
                                    Mode::"Records Cost", Mode::"Records Price":
                                        begin
                                            if Job.GET(JobNo) then begin
                                                Job.SETRANGE("NS_Job Task No. Filter", JobTaskHold);
                                                case Mode of
                                                    Mode::"Records Cost":
                                                        begin
                                                            Job.CALCFIELDS("NS_Budgeted Cost (LCY)");
                                                            Answer := Answer + Job."NS_Budgeted Cost (LCY)";
                                                        end;
                                                    Mode::"Records Price":
                                                        begin
                                                            Job.CALCFIELDS("NS_Budgeted Price (LCY)");
                                                            Answer := Answer + Job."NS_Budgeted Price (LCY)";
                                                        end;
                                                end;
                                            end;
                                        end;
                                    Mode::"Worksheet Cost", Mode::"Worksheet Price":
                                        begin
                                            if JobForecast2.GET(JobNo) then begin
                                                JobForecast2.SETFILTER("NS_Job Task No.", JobTaskHold);
                                                case Mode of
                                                    Mode::"Worksheet Cost":
                                                        Answer := Answer + JobForecast2."NS_Forecasted Completed Cost";
                                                    Mode::"Worksheet Price":
                                                        begin
                                                            JobForecast2.CALCFIELDS("NS_Forecasted Completed Price");
                                                            Answer := Answer + JobForecast2."NS_Forecasted Completed Price";
                                                        end;
                                                end;
                                                //Message('%1...%2', Answer, JobForecast2."Forecasted Completed Cost");
                                            end;
                                        end;
                                end;
                            JobTaskHold := "NS_Job Task No.";
                        end;
                        if ("NS_Job Task No." = JobTaskHold) then begin //and Posted then begin //("Status Date" > 0D) and Posted then begin //PRJ-441
                            case Mode of
                                Mode::"Records Cost", Mode::"Worksheet Cost":
                                    Amount := "NS_Forecasted Completed Cost";
                                Mode::"Records Price", Mode::"Worksheet Price":
                                    Amount := "NS_Forecasted Completed Price";
                            end;
                            AmountFound := true;
                        end;
                    until NEXT = 0;

                    //Process the last record
                    if AmountFound then begin
                        Answer := Answer + Amount;
                        Amount := 0;
                    end else
                        //Read Job Budget for the Task
                        case Mode of
                            Mode::"Records Cost", Mode::"Records Price":
                                begin
                                    if Job.GET(JobNo) then begin
                                        Job.SETRANGE("NS_Job Task No. Filter", JobTaskHold);
                                        case Mode of
                                            Mode::"Records Cost":
                                                begin
                                                    Job.CALCFIELDS("Ns_Budgeted Cost (LCY)");
                                                    Answer := Answer + Job."NS_Budgeted Cost (LCY)";
                                                end;
                                            Mode::"Records Price":
                                                begin
                                                    Job.CALCFIELDS("NS_Budgeted Price (LCY)");
                                                    Answer := Answer + Job."NS_Budgeted Price (LCY)";
                                                end;
                                        end;
                                    end;
                                end;
                            Mode::"Worksheet Cost", Mode::"Worksheet Price":
                                begin
                                    if JobForecast2.GET(JobNo) then begin
                                        JobForecast2.SETFILTER("NS_Job Task No.", JobTaskHold);
                                        case Mode of
                                            Mode::"Worksheet Cost":
                                                Answer := Answer + JobForecast2."NS_Forecasted Completed Cost";
                                            Mode::"Worksheet Price":
                                                begin
                                                    JobForecast2.CALCFIELDS("NS_Forecasted Completed Price");
                                                    Answer := Answer + JobForecast2."NS_Forecasted Completed Price";
                                                end;

                                        end;
                                        //Message('%1..#####.%2', Answer, JobForecast2."Forecasted Completed Cost");
                                    end;
                                end;
                        end;
                end;
            end;
        end;
        exit(Answer);
    end;
    //PRJ-1056.JS.1.0 24Nov2021 end   

    /// //PRJ-1299.JS.1.0 19APR2022 - Start

    procedure NS_GetNewTasksByTaskTotalsFBTT(JobNo: Code[20]; TaskManagerNo: Code[20]);
    var
        JobTask: Record "Job Task";
        JobPlanningLine: Record "Job Planning Line";
        JobForecast: Record "NS_Job Forecast";
    begin
        //Add any Job Task lines that are not yet in the Job Forecast table

        JobTask.RESET();
        JobTask.SETRANGE("Job No.", JobNo);
        //JobTask.SETRANGE("Job Task Type", JobTask."Job Task Type"::Posting);        
        JobTask.SetFilter("Job Task Type", '%1|%2', JobTask."Job Task Type"::Total, JobTask."Job Task Type"::"End-Total");
        JobTask.SetRange("NS_Forecast By Task Totals", true);
        if JobTask.FINDSET() then begin
            repeat
                JobForecast.RESET();
                JobForecast.SETRANGE("NS_Job No.", JobTask."Job No.");
                JobForecast.SETRANGE("NS_Job Task No.", JobTask."Job Task No.");
                if not JobForecast.FINDFIRST() then begin
                    JobForecast.INIT();
                    JobForecast."NS_Job No." := JobTask."Job No.";
                    JobForecast."NS_Job Task No." := JobTask."Job Task No.";
                    JobForecast."NS_Entry Type" := JobPlanningLine."NS_Entry Type";
                    JobForecast."NS_Task Manager" := JobTask.NS_Manager;
                    JobForecast."NS_Line No." := 100;
                    JobForecast."NS_Forecast Method" := JobForecast."NS_Forecast Method"::"Job Forecast by Task Totals";
                    JobForecast.NS_ForecastedCompCostOverride := JobTask.NS_ForecastedCompCostOverride;//PE-90.AS.1.0
                    JobForecast.INSERT();

                end;

            until JobTask.NEXT() = 0;
        end else
            Error('Forecast By Task Totals must be true in Job Task lines')
    end;

    [IntegrationEvent(false, false)]
    local procedure OnOpenJobForcastPageTaskTotals(var JobForecast: Record "NS_Job Forecast"; JobNo: Code[20]; DefaultStatusDate: date; NextBillDate: Date)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetJobForcastPageTaskTotals(var JobForecast: Record "NS_Job Forecast"; JobNo: Code[20]; DefaultStatusDate: date; NextBillDate: Date)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetCurrRecordJobForcastPageTaskTotals(var JobForecast: Record "NS_Job Forecast"; JobNo: Code[20]; DefaultStatusDate: date; NextBillDate: Date)
    begin
    end;

    procedure NS_GetLastPostedStatusFBTT(JobNo: Code[20]; JobTaskNo: Code[20]; DateLimit: Date; var JobForecast: Record "NS_Job Forecast");
    begin
        //Return the last Job Forecast record for the Job and Task passed in with a status of Posted
        JobForecast.RESET();
        JobForecast.SETCURRENTKEY(NS_Posted);
        JobForecast.SETRANGE(NS_Posted, true);
        JobForecast.SETRANGE("NS_Job No.", JobNo);
        JobForecast.SETRANGE("NS_Job Task No.", JobTaskNo);
        if DateLimit > 0D then
            JobForecast.SETFILTER("NS_Status Date", '<=%1', DateLimit);
        if not JobForecast.FINDLAST() then
            CLEAR(JobForecast);
    end;

    procedure NS_GetJobPlanningLineAndBudgetFBTT(JobNo: Code[20]; JobTaskNo: Code[20]; var JobPlanningLine: Record "Job Planning Line"; var TotalBudget: Decimal; Var ASofDateFilter: date);
    var
        JobPlanningLineWork: Record "Job Planning Line";
        JobPlanningLineWorkUnit: Record "Job Planning Line";
        JobPlanningLineFirst: Record "Job Planning Line";
        FoundWorkUnitsRecord: Boolean;
        JobTask1: Record "Job Task";
        TaskTotalFilters: Text[250];
    begin
        Clear(TaskTotalFilters);
        //Returns a Job Planning Line and the Total Budget for a Job No. and a Task No.
        //
        //The Job Planning Line returned depends on if work units are being used in the task.
        //    If work units are used then the last planning line with work units is returned.
        //    If no work units are found then the first planning line for the task is returned.
        JobTask1.Reset();
        if JobTask1.get(JobNo, JobTaskNo) then;
        TotalBudget := 0;
        CLEAR(JobPlanningLine);
        CLEAR(JobPlanningLineFirst);
        CLEAR(JobPlanningLineWorkUnit);

        JobPlanningLineWork.RESET();
        JobPlanningLineWork.SETRANGE("Job No.", JobNo);
        if JobTaskNo > '' then
            if JobTask1."NS_Forecast By Task Totals" then
                JobPlanningLineWork.setfilter("Job Task No.", JobTask1.Totaling);
        if ASofDateFilter <> 0D then
            JobPlanningLineWork.setfilter("Planning Date", '..%1', ASofDateFilter);
        JobPlanningLineWork.SetFilter("Line Type", '<>%1', JobPlanningLineWork."Line Type"::Billable);  //Prj-565  
        if JobPlanningLineWork.FINDSET() then
            repeat
                if JobPlanningLineWork."NS_Work Units" > 0 then begin
                    JobPlanningLineWorkUnit := JobPlanningLineWork;
                    FoundWorkUnitsRecord := true;
                end else begin
                    if JobPlanningLineFirst."Job No." = '' then
                        JobPlanningLineFirst := JobPlanningLineWork;
                end;
                TotalBudget := TotalBudget + JobPlanningLineWork."Total Cost"
            until JobPlanningLineWork.NEXT() = 0;
        if FoundWorkUnitsRecord then
            JobPlanningLine := JobPlanningLineWorkUnit
        else
            JobPlanningLine := JobPlanningLineFirst;
    end;

    procedure NS_GetBudgetHoursFBTT(JobNo: Code[20]; JobTaskNo: Code[20]; var JobPlanningLine: Record "Job Planning Line"; var BudgetedHrs: Decimal; Var ASofDateFilter: date);
    var
        JobPlanningLineWork: Record "Job Planning Line";
        JobPlanningLineWorkUnit: Record "Job Planning Line";
        JobPlanningLineFirst: Record "Job Planning Line";
        FoundWorkUnitsRecord: Boolean;
        JobTask1: record "Job Task"; //PRJ-1475.GK.1.0 22July2022
    begin
        //PRJ-1475.GK.1.0 22July2022 start
        JobTask1.Reset();
        if JobTask1.get(JobNo, JobTaskNo) then;
        //PRJ-1475.GK.1.0 22July2022 end
        BudgetedHrs := 0;
        CLEAR(JobPlanningLine);
        CLEAR(JobPlanningLineFirst);
        CLEAR(JobPlanningLineWorkUnit);
        JobPlanningLineWork.RESET();
        JobPlanningLineWork.SETRANGE("Job No.", JobNo);
        if JobTaskNo > '' then
            //PRJ-1475.GK.1.0 22July2022 start
            if JobTask1."NS_Forecast By Task Totals" then
                JobPlanningLineWork.SetFilter("Job Task No.", JobTask1.Totaling)
            else
                JobPlanningLineWork.SETRANGE("Job Task No.", JobTaskNo);
        //PRJ-1475.GK.1.0 22July2022 end
        if ASofDateFilter <> 0D then
            JobPlanningLineWork.setfilter("Planning Date", '..%1', ASofDateFilter);
        JobPlanningLineWork.SetFilter("Line Type", '<>%1', JobPlanningLineWork."Line Type"::Billable);
        JobPlanningLineWork.SetFilter("Schedule Line", '%1', true);
        JobPlanningLineWork.SetFilter(Type, '%1', JobPlanningLineWork.Type::Resource);
        JobPlanningLineWork.SetFilter("Unit of Measure Code", '%1', 'HR');
        if JobPlanningLineWork.FINDSET() then
            repeat
                if JobPlanningLineWork."NS_Work Units" > 0 then begin
                    JobPlanningLineWorkUnit := JobPlanningLineWork;
                    FoundWorkUnitsRecord := true;
                end else begin
                    if JobPlanningLineFirst."Job No." = '' then
                        JobPlanningLineFirst := JobPlanningLineWork;
                end;
                BudgetedHrs := BudgetedHrs + JobPlanningLineWork.Quantity;
            until JobPlanningLineWork.NEXT() = 0;

        if FoundWorkUnitsRecord then
            JobPlanningLine := JobPlanningLineWorkUnit
        else
            JobPlanningLine := JobPlanningLineFirst;

    end;

    procedure NS_GetJobSumofTotalBudgetFBTT(JobNo: Code[20]; JobTaskNo: Code[20]; var JobPlanningLine: Record "Job Planning Line"; var SumofTotalBudget: Decimal; Var ASofDateFilter: date);
    var
        JobPlanningLineWork: Record "Job Planning Line";
        JobPlanningLineWorkUnit: Record "Job Planning Line";
        JobPlanningLineFirst: Record "Job Planning Line";
        FoundWorkUnitsRecord: Boolean;
    begin
        SumofTotalBudget := 0;
        CLEAR(JobPlanningLine);
        CLEAR(JobPlanningLineFirst);
        CLEAR(JobPlanningLineWorkUnit);

        JobPlanningLineWork.RESET();
        JobPlanningLineWork.SETRANGE("Job No.", JobNo);
        if ASofDateFilter <> 0D then
            JobPlanningLineWork.setfilter("Planning Date", '..%1', ASofDateFilter);
        JobPlanningLineWork.SetFilter("Line Type", '<>%1', JobPlanningLineWork."Line Type"::Billable);  //Prj-565  
        if JobPlanningLineWork.FINDSET() then
            repeat
                if JobPlanningLineWork."NS_Work Units" > 0 then begin
                    JobPlanningLineWorkUnit := JobPlanningLineWork;
                    FoundWorkUnitsRecord := true;
                end else begin
                    if JobPlanningLineFirst."Job No." = '' then
                        JobPlanningLineFirst := JobPlanningLineWork;
                end;
                SumofTotalBudget := SumofTotalBudget + JobPlanningLineWork."Total Cost"
            until JobPlanningLineWork.NEXT() = 0;

        if FoundWorkUnitsRecord then
            JobPlanningLine := JobPlanningLineWorkUnit
        else
            JobPlanningLine := JobPlanningLineFirst;

    end;

    procedure NS_GetSumOfTotalCostsUsedFBTT(JobNo: Code[20]; JobTaskNo: Code[20]; var JobPlanningLine: Record "Job Planning Line"; var SumOfTotalCostsUsed: Decimal; Var ASofDateFilter: date);
    var
        JobForcastWork: Record "NS_Job Forecast";
        JobLocal: Record Job;
        NSJobTask2: Record "Job Task";
    begin
        SumOfTotalCostsUsed := 0;
        JobForcastWork.RESET();
        JobForcastWork.SETRANGE("NS_Job No.", JobNo);
        JobForcastWork.SetFilter(NS_Posted, '%1', false);
        if JobForcastWork.FINDSET() then
            repeat
                NSJobTask2.Reset();
                if NSJobTask2.get(JobForcastWork."NS_Job No.", JobForcastWork."NS_Job Task No.") then;
                JobLocal.Reset();
                JobLocal.SetRange("No.", JobNo);
                JobLocal.Setfilter("NS_Job Task No. Filter", NSJobTask2.Totaling);

                if ASofDateFilter <> 0D then
                    JobLocal.SETFILTER("NS_Date Filter", '..%1', AsOfDateFilter)
                else
                    JobLocal.SETRANGE("NS_Date Filter");
                if JobLocal.FindFirst() then;
                JobLocal.CALCFIELDS("NS_Usage (Cost) (LCY)");
                SumOfTotalCostsUsed := SumOfTotalCostsUsed + JobLocal."NS_Usage (Cost) (LCY)";
            until JobForcastWork.NEXT() = 0;

    end;

    procedure NS_CalcPercentFrom0To100FBTT(Value: Decimal; Base: Decimal): Decimal;
    var
        Answer: Decimal;
    begin

        if Value <> 0 then begin
            Answer := ROUND((Base / Value) * 100, 0.01);
            if Answer > 100 then
                Answer := 100
            else
                if Answer < 0 then
                    Answer := 0;
        end else
            //IF Value <= 0 THEN
            if Base <= 0 then
                Answer := 0.0
            else
                Answer := 100.0;

        exit(Answer);
    end;

    procedure NS_GetSumofBudgetRemainingFBTT(JobNo: Code[20]; JobTaskNo: Code[20]; var JobPlanningLine: Record "Job Planning Line"; var SumofBudgetRemaining: Decimal; Var ASofDateFilter: date; var SumofForecastedVariance: Decimal);
    var
        JobPlanningLineWork: Record "Job Planning Line";
        JobForcastWork: Record "NS_Job Forecast";
        JobLocal: Record Job;
        TotalBudg: Decimal;
        JobTask2: Record "Job Task";
    begin
        SumofBudgetRemaining := 0;
        SumofForecastedVariance := 0;
        JobForcastWork.RESET();
        JobForcastWork.SETRANGE("NS_Job No.", JobNo);
        JobForcastWork.SetFilter(NS_Posted, '%1', false);
        if JobForcastWork.FINDSET() then
            repeat
                TotalBudg := 0;
                JobTask2.Reset();
                if JobTask2.Get(JobForcastWork."NS_Job No.", JobForcastWork."NS_Job Task No.") then;
                JobPlanningLineWork.reset();
                JobPlanningLineWork.SetRange("Job No.", JobNo);
                JobPlanningLineWork.Setfilter("Job Task No.", JobTask2.Totaling);
                if ASofDateFilter <> 0D then
                    JobPlanningLineWork.setfilter("Planning Date", '..%1', ASofDateFilter);
                JobPlanningLineWork.SetFilter("Line Type", '<>%1', JobPlanningLineWork."Line Type"::Billable);
                if JobPlanningLineWork.FindSet() then
                    repeat
                        TotalBudg := TotalBudg + JobPlanningLineWork."Total Cost"
                    until JobPlanningLineWork.next() = 0;

                JobLocal.Reset();
                JobLocal.SetRange("No.", JobNo);
                JobLocal.Setfilter("NS_Job Task No. Filter", JobTask2.Totaling);
                if ASofDateFilter <> 0D then
                    JobLocal.SETFILTER("NS_Date Filter", '..%1', AsOfDateFilter)
                else
                    JobLocal.SETRANGE("NS_Date Filter");
                if JobLocal.FindFirst() then;
                JobLocal.CALCFIELDS("NS_Usage (Cost) (LCY)");

                SumofBudgetRemaining := SumofBudgetRemaining + (TotalBudg - JobLocal."NS_Usage (Cost) (LCY)");

                if JobForcastWork."NS_Percent Complete" <> 100 then
                    SumofForecastedVariance := SumofForecastedVariance + (TotalBudg - JobForcastWork."NS_Forecasted Completed Cost")
                else
                    SumofForecastedVariance := SumofForecastedVariance + (TotalBudg - JobLocal."NS_Usage (Cost) (LCY)");
            until JobForcastWork.NEXT() = 0;


    end;

    /// <summary>
    /// NS_PostLinesFBTT.
    /// </summary>
    /// <param name="JobNo">Code[20].</param>
    /// <param name="DefaultStatusDate">Date.</param>
    /// <param name="NextBillDate">Date.</param>
    procedure NS_PostLinesFBTT(JobNo: Code[20]; DefaultStatusDate: Date; NextBillDate: Date);
    var
        JobForecast: Record "NS_Job Forecast";
        JobForecast2: Record "NS_Job Forecast";
        JobTask2: Record "Job Task";
        BillStartDate: Date;
        BillEndDate: Date;
        JobDateFilter: Text;
        TotalCostsUsed: Decimal;
        q: Integer;
        ReportJobForecast: Record "NS_Job Forecast";
        JobForecastWorksheetReport: Report "NS_Percentage of Compl.";
        JobForecastWorksheetReport_C: Report "NS_Percentage of Compl.";
        NSJobForecastWrhsPOCByTaskTotals: Report "NS_JFW POC By TaskToatls";
        IncludeSublevelBool: Boolean;
        JobsetupRec: Record "Jobs Setup";
        JobRecord: Record Job;
        JobRec2: Record Job;
        JobRec3: Record Job;
        JobTable: Record job;
        GBPGValTxt: Text;
        JobForecastSubLevelValInsert: Record "NS_Job Forecast";
        JobForecastWkshtPg: Page "NS_Job Forecast Worksheet";
        JobForecastTable: Record "NS_Job Forecast";
    begin
        JobsetupRec.Get;


        Clear(IncludeSublevelBool);

        Clear(GBPGValTxt);

        GBPGValTxt := JobsetupRec."NS_GBPG for Job Forecast";


        if JobNo <> '' then
            if JobTable.get(JobNo) then;
        if JobTable."NS_Forecast Method" <> JobTable."NS_Forecast Method"::"Job Forecast by Task Totals" then begin
            if JobTable."NS_Sub-Level to Job No." = '' then begin
                IF Confirm(TxtIncludeSublevel, true) then begin
                    if JobRecord.Get(JobNo) then begin
                        if JobRecord."NS_Exclude from Job Forecast" = false then begin
                            IncludeSublevelBool := true;

                            NS_ForecastedCompletedAmtNoDate(JobNo, DefaultStatusDate);
                            JobRec2.RESET;
                            JobRec2.SETRANGE("NS_Sub-Level to Job No.", JobNo);
                            JobRec2.SetRange("NS_Exclude from Job Forecast", false);
                            if GBPGValTxt > '' then
                                JobRec2.SetFilter("NS_Gen. Bus. Posting Group New", GBPGValTxt);
                            if JobRec2.FindSet then begin
                                REPEAT
                                    NS_ForecastedCompletedAmtNoDate(JobRec2."No.", DefaultStatusDate);
                                UNTIL JobRec2.NEXT = 0;
                            end
                            else begin

                            end;
                        end;
                        if JobRecord."NS_Exclude from Job Forecast" = true then begin
                            IncludeSublevelBool := false;
                            NS_ForecastedCompletedAmtNoDate(JobNo, DefaultStatusDate);
                        end;
                    end;

                end;
            end else begin
                IncludeSublevelBool := false;
                NS_ForecastedCompletedAmtNoDate(JobNo, DefaultStatusDate);
            end;

            if JobNo > '' then begin
                if DefaultStatusDate > 0D then begin
                    if IncludeSublevelBool = true then begin
                        JobForecastWorksheetReport_C.Set(JobNo, DefaultStatusDate);
                        JobForecastWorksheetReport_C.RunModal();
                        Clear(JobForecastWorksheetReport_C);

                        JobRec2.RESET();
                        JobRec2.SETRANGE("NS_Sub-Level to Job No.", JobNo);
                        if GBPGValTxt > '' then
                            JobRec2.SetFilter("NS_Gen. Bus. Posting Group New", GBPGValTxt);
                        JobRec2.SetRange("NS_Exclude from Job Forecast", false);
                        if JobRec2.findset then begin
                            REPEAT
                                if JobRec2."No." > '' then begin

                                    OnOpenJobForcastPage(JobForecast, JobRec2."No.", DefaultStatusDate, NextBillDate);

                                    JobForecastTable.Reset();
                                    JobForecastTable.SetRange("NS_Job No.", JobRec2."No.");
                                    if JobForecastTable.FindSet() then
                                        repeat
                                            OnAfterGetJobForcastPage(JobForecastTable, JobRec2."No.", DefaultStatusDate, NextBillDate);
                                            OnAfterGetCurrRecordJobForcastPage(JobForecastTable, JobRec2."No.", DefaultStatusDate, NextBillDate);
                                            JobForecastTable.Modify();
                                        until JobForecastTable.Next() = 0;


                                    JobForecastWorksheetReport_C.Set(JobRec2."No.", DefaultStatusDate);
                                    JobForecastWorksheetReport_C.RunModal();
                                    Clear(JobForecastWorksheetReport_C);
                                end;
                            UNTIL JobRec2.NEXT() = 0;
                        end
                        else begin

                        end;
                    end;
                    if IncludeSublevelBool = false then begin
                        JobForecastWorksheetReport.Set(JobNo, DefaultStatusDate);
                        JobForecastWorksheetReport.RUNMODAL();
                        CLEAR(JobForecastWorksheetReport);
                    end
                end else
                    ERROR('Please check the As of date field');
            end;

            JobSetup.GET;
            JobForecast.RESET;
            JobForecast.MARKEDONLY(false);
            if JobNo > '' then
                JobForecast.SETRANGE("NS_Job No.", JobNo);
            JobForecast.SETRANGE(NS_Posted, false);
            if (JobNo = '') and (NextBillDate > 0D) then begin
                BillStartDate := DMY2DATE(1, DATE2DMY(NextBillDate, 2), DATE2DMY(NextBillDate, 3));
                if DATE2DMY(BillStartDate, 2) < 12 then
                    BillEndDate := CALCDATE('<-1D>', DMY2DATE(1, DATE2DMY(NextBillDate, 2) + 1, DATE2DMY(NextBillDate, 3)))
                else
                    BillEndDate := DMY2DATE(12, 31, DATE2DMY(NextBillDate, 3));

                JobForecast.SETFILTER("NS_Bill Date", '%1..%2', BillStartDate, BillEndDate);
                if JobForecast.FINDSET() then
                    repeat
                        JobForecast.MARK := true;
                    until JobForecast.NEXT() = 0;
                JobForecast.SETRANGE("NS_Bill Date");
                JobForecast.SETFILTER("NS_Status Date", '%1..%2', CALCDATE('<-31D>', BillStartDate), BillEndDate);
                if JobForecast.FINDSET() then
                    repeat
                        JobForecast.MARK := true;
                    until JobForecast.NEXT() = 0;
                JobForecast.SETRANGE("NS_Status Date");
                JobForecast.MARKEDONLY(true);
            end;
            if JobForecast.COUNT = 0 then
                MESSAGE(Text002_Txt);
            if JobForecast.FINDSET() then begin
                repeat
                    if ((JobForecast."NS_Status Date" > 0D) or
                        (JobForecast."NS_Percent Complete" > 0))
                       and
                       ((JobForecast."NS_Percent Complete" = 100) or
                        (JobForecast."NS_Percent Complete" < JobSetup."NS_Forecast Percent For HrsReq") or
                        (JobSetup."NS_Forecast Percent For HrsReq" = 0) or
                        (JobForecast."NS_Hours To Finish" > 0) or
                        (JobForecast."NS_Entry Type" = JobForecast."NS_Entry Type"::Price)) then begin
                        if (JobForecast."NS_Entry Type" = JobForecast."NS_Entry Type"::Price) and (JobForecast."NS_Status Date" = 0D) then
                            JobForecast."NS_Status Date" := DefaultStatusDate;
                        JobForecast.NS_Posted := true;
                        JobForecast."NS_User ID" := USERID;
                        if JobForecast."NS_Job Task No." = '13-13200-13280' then
                            q := q;
                        if JobForecast."NS_Forecasted Completed Cost" = 0 then begin
                            JobForecast2.RESET();
                            JobForecast2.SETRANGE("NS_Job No.", JobForecast."NS_Job No.");
                            JobForecast2.SETRANGE("NS_Job Task No.", JobForecast."NS_Job Task No.");
                            JobForecast2.SETRANGE("NS_Line No.", JobForecast."NS_Line No." - 1);

                            if (JobForecast2.FINDFIRST()) and (JobForecast2."NS_Forecasted Completed Cost" <> 0) then
                                JobForecast."NS_Forecasted Completed Cost" := JobForecast2."NS_Forecasted Completed Cost";
                        end;
                        JobForecast.MODIFY();
                        //Build a new unposted line for display
                        JobForecast."NS_Line No." := JobForecast."NS_Line No." + 1;

                        JobForecast."NS_Units Complete" := 0;
                        if JobForecast."NS_Percent Complete" = 100 then
                            JobForecast."NS_Forecasted Completed Cost" := NS_Get100PctCost(JobForecast."NS_Job No.", JobForecast."NS_Job Task No.")
                        else
                            JobForecast."NS_Forecasted Completed Cost" := 0;
                        JobForecast."NS_Forecasted Completed Price" := 0;
                        JobForecast."NS_Bill Date" := 0D;
                        JobForecast."NS_Bill Percent" := 0;
                        JobForecast."NS_PO Expected Receipt Cost" := 0;
                        JobForecast."NS_Posted Check Boolean" := true;
                        JobForecast.NS_Posted := false;
                        JobForecast."NS_User ID" := '';
                        JobForecast.INSERT();
                    end;
                until JobForecast.NEXT() = 0;
            end else
                MESSAGE(Text003_Txt);
            ///// Job Forecast sublevel value insert - start
            if IncludeSublevelBool = true then begin
                JobRec3.RESET;
                JobRec3.SETRANGE("NS_Sub-Level to Job No.", JobNo);
                if GBPGValTxt > '' then
                    JobRec3.SetFilter("NS_Gen. Bus. Posting Group New", GBPGValTxt);
                JobRec3.SetRange("NS_Exclude from Job Forecast", false);
                if JobRec3.FindSet then begin
                    REPEAT
                        JobForecastSubLevelValInsert.RESET();
                        JobForecastSubLevelValInsert.MARKEDONLY(false);
                        if JobRec3."No." > '' then
                            JobForecastSubLevelValInsert.SETRANGE("NS_Job No.", JobRec3."No.");
                        JobForecastSubLevelValInsert.SETRANGE(NS_Posted, false);
                        if (JobRec3."No." = '') and (NextBillDate > 0D) then begin
                            BillStartDate := DMY2DATE(1, DATE2DMY(NextBillDate, 2), DATE2DMY(NextBillDate, 3));
                            if DATE2DMY(BillStartDate, 2) < 12 then
                                BillEndDate := CALCDATE('-1D', DMY2DATE(1, DATE2DMY(NextBillDate, 2) + 1, DATE2DMY(NextBillDate, 3)))
                            else
                                BillEndDate := DMY2DATE(12, 31, DATE2DMY(NextBillDate, 3));

                            JobForecastSubLevelValInsert.SETFILTER("NS_Bill Date", '%1..%2', BillStartDate, BillEndDate);
                            if JobForecastSubLevelValInsert.FINDSET() then
                                repeat
                                    JobForecastSubLevelValInsert.MARK := true;
                                until JobForecastSubLevelValInsert.NEXT = 0;
                            JobForecastSubLevelValInsert.SETRANGE("NS_Bill Date");
                            JobForecastSubLevelValInsert.SETFILTER("NS_Status Date", '%1..%2', CALCDATE('-31D', BillStartDate), BillEndDate);
                            if JobForecastSubLevelValInsert.FINDSET() then
                                repeat
                                    JobForecastSubLevelValInsert.MARK := true;
                                until JobForecastSubLevelValInsert.NEXT() = 0;
                            JobForecastSubLevelValInsert.SETRANGE("NS_Status Date");
                            JobForecastSubLevelValInsert.MARKEDONLY(true);
                        end;
                        if JobForecastSubLevelValInsert.FINDSET() then begin
                            repeat
                                if ((JobForecastSubLevelValInsert."NS_Status Date" > 0D) or
                                    (JobForecastSubLevelValInsert."NS_Percent Complete" > 0))
                                   and
                                   ((JobForecastSubLevelValInsert."NS_Percent Complete" = 100) or
                                    (JobForecastSubLevelValInsert."NS_Percent Complete" < JobSetup."NS_Forecast Percent For HrsReq") or
                                    (JobSetup."NS_Forecast Percent For HrsReq" = 0) or
                                    (JobForecastSubLevelValInsert."NS_Hours To Finish" > 0) or
                                    (JobForecastSubLevelValInsert."NS_Entry Type" = JobForecastSubLevelValInsert."NS_Entry Type"::Price)) then begin
                                    if (JobForecastSubLevelValInsert."NS_Entry Type" = JobForecastSubLevelValInsert."NS_Entry Type"::Price) and (JobForecastSubLevelValInsert."NS_Status Date" = 0D) then
                                        JobForecastSubLevelValInsert."NS_Status Date" := DefaultStatusDate;
                                    JobForecastSubLevelValInsert.NS_Posted := true;
                                    JobForecastSubLevelValInsert."NS_User ID" := USERID;
                                    if JobForecastSubLevelValInsert."NS_Job Task No." = '13-13200-13280' then
                                        q := q;
                                    if JobForecastSubLevelValInsert."NS_Forecasted Completed Cost" = 0 then begin
                                        JobForecast2.RESET;
                                        JobForecast2.SETRANGE("NS_Job No.", JobRec3."No.");
                                        JobForecast2.SETRANGE("NS_Job Task No.", JobForecastSubLevelValInsert."NS_Job Task No.");
                                        JobForecast2.SETRANGE("NS_Line No.", JobForecastSubLevelValInsert."NS_Line No." - 1);
                                        if (JobForecast2.FINDFIRST()) and (JobForecast2."NS_Forecasted Completed Cost" <> 0) then
                                            JobForecastSubLevelValInsert."NS_Forecasted Completed Cost" := JobForecast2."NS_Forecasted Completed Cost";
                                    end;
                                    JobForecastSubLevelValInsert.MODIFY();
                                    //Build a new unposted line for display
                                    JobForecastSubLevelValInsert."NS_Line No." := JobForecastSubLevelValInsert."NS_Line No." + 1;

                                    if JobForecastSubLevelValInsert."NS_Percent Complete" = 0 then
                                        JobForecastSubLevelValInsert."NS_Status Date" := 0D;

                                    JobForecastSubLevelValInsert."NS_Units Complete" := 0;
                                    //"NS_Cost To Complete" := 0;
                                    if JobForecastSubLevelValInsert."NS_Percent Complete" = 100 then
                                        JobForecastSubLevelValInsert."NS_Forecasted Completed Cost" := NS_Get100PctCost(JobRec3."No.", JobForecastSubLevelValInsert."NS_Job Task No.")
                                    else
                                        JobForecastSubLevelValInsert."NS_Forecasted Completed Cost" := 0;
                                    JobForecastSubLevelValInsert."NS_Forecasted Completed Price" := 0;
                                    JobForecastSubLevelValInsert."NS_Hours To Finish" := 0;
                                    JobForecastSubLevelValInsert."NS_Bill Date" := 0D;
                                    JobForecastSubLevelValInsert."NS_Bill Percent" := 0;
                                    JobForecastSubLevelValInsert."NS_PO Expected Receipt Cost" := 0;
                                    JobForecastSubLevelValInsert.NS_Posted := false;
                                    JobForecastSubLevelValInsert."NS_User ID" := '';
                                    OnBeforeInsertJobForecastSubLevelValInsert(JobForecastSubLevelValInsert);//FGH-163.SM.29022024 //PE-269.JS.1.0
                                    JobForecastSubLevelValInsert.INSERT;
                                end;

                            until JobForecastSubLevelValInsert.NEXT = 0;
                        end;
                    UNTIL JobRec3.NEXT = 0;
                end
                else begin

                end;
            end;
        end else begin
            ////////////// Start code for Job PRJ-1299 forecaset by Task totals //////////////////////////////   
            if JobTable."NS_Sub-Level to Job No." = '' then begin
                IF Confirm(TxtIncludeSublevel, true) then begin
                    if JobRecord.Get(JobNo) then begin
                        if JobRecord."NS_Exclude from Job Forecast" = false then begin
                            IncludeSublevelBool := true;

                            NS_ForecastedCompletedAmtNoDateFBTT(JobNo, DefaultStatusDate);
                            JobRec2.RESET;
                            JobRec2.SETRANGE("NS_Sub-Level to Job No.", JobNo);
                            JobRec2.SetRange("NS_Exclude from Job Forecast", false);
                            if GBPGValTxt > '' then
                                JobRec2.SetFilter("NS_Gen. Bus. Posting Group New", GBPGValTxt);
                            if JobRec2.FindSet then begin
                                REPEAT
                                    NS_ForecastedCompletedAmtNoDateFBTT(JobRec2."No.", DefaultStatusDate);
                                UNTIL JobRec2.NEXT = 0;
                            end
                            else begin

                            end;
                        end;
                        if JobRecord."NS_Exclude from Job Forecast" = true then begin
                            IncludeSublevelBool := false;
                            NS_ForecastedCompletedAmtNoDateFBTT(JobNo, DefaultStatusDate);
                        end;
                    end;

                end;
            end else begin
                IncludeSublevelBool := false;
                NS_ForecastedCompletedAmtNoDateFBTT(JobNo, DefaultStatusDate);
            end;

            if JobNo > '' then begin
                if DefaultStatusDate > 0D then begin
                    if IncludeSublevelBool = true then begin
                        NSJobForecastWrhsPOCByTaskTotals.Set(JobNo, DefaultStatusDate);
                        NSJobForecastWrhsPOCByTaskTotals.RunModal();
                        Clear(NSJobForecastWrhsPOCByTaskTotals);

                        JobRec2.RESET();
                        JobRec2.SETRANGE("NS_Sub-Level to Job No.", JobNo);
                        if GBPGValTxt > '' then
                            JobRec2.SetFilter("NS_Gen. Bus. Posting Group New", GBPGValTxt);
                        JobRec2.SetRange("NS_Exclude from Job Forecast", false);
                        if JobRec2.findset then begin
                            REPEAT
                                if JobRec2."No." > '' then begin
                                    OnOpenJobForcastPage(JobForecast, JobRec2."No.", DefaultStatusDate, NextBillDate);

                                    JobForecastTable.Reset();
                                    JobForecastTable.SetRange("NS_Job No.", JobRec2."No.");
                                    if JobForecastTable.FindSet() then
                                        repeat
                                            OnAfterGetJobForcastPage(JobForecastTable, JobRec2."No.", DefaultStatusDate, NextBillDate);
                                            OnAfterGetCurrRecordJobForcastPage(JobForecastTable, JobRec2."No.", DefaultStatusDate, NextBillDate);
                                            JobForecastTable.Modify();
                                        until JobForecastTable.Next() = 0;

                                    NSJobForecastWrhsPOCByTaskTotals.Set(JobRec2."No.", DefaultStatusDate);
                                    NSJobForecastWrhsPOCByTaskTotals.RunModal();
                                    Clear(NSJobForecastWrhsPOCByTaskTotals);
                                end;
                            UNTIL JobRec2.NEXT() = 0;
                        end
                        else begin

                        end;
                    end;
                    if IncludeSublevelBool = false then begin
                        NSJobForecastWrhsPOCByTaskTotals.Set(JobNo, DefaultStatusDate);
                        NSJobForecastWrhsPOCByTaskTotals.RUNMODAL();
                        CLEAR(NSJobForecastWrhsPOCByTaskTotals);
                    end
                end else
                    ERROR('Please check the As of date field');
            end;

            JobSetup.GET;
            JobForecast.RESET;
            JobForecast.MARKEDONLY(false);
            if JobNo > '' then
                JobForecast.SETRANGE("NS_Job No.", JobNo);
            JobForecast.SETRANGE(NS_Posted, false);

            if (JobNo = '') and (NextBillDate > 0D) then begin
                BillStartDate := DMY2DATE(1, DATE2DMY(NextBillDate, 2), DATE2DMY(NextBillDate, 3));
                if DATE2DMY(BillStartDate, 2) < 12 then
                    BillEndDate := CALCDATE('<-1D>', DMY2DATE(1, DATE2DMY(NextBillDate, 2) + 1, DATE2DMY(NextBillDate, 3)))
                else
                    BillEndDate := DMY2DATE(12, 31, DATE2DMY(NextBillDate, 3));

                JobForecast.SETFILTER("NS_Bill Date", '%1..%2', BillStartDate, BillEndDate);
                if JobForecast.FINDSET() then
                    repeat
                        JobForecast.MARK := true;
                    until JobForecast.NEXT() = 0;
                JobForecast.SETRANGE("NS_Bill Date");
                JobForecast.SETFILTER("NS_Status Date", '%1..%2', CALCDATE('<-31D>', BillStartDate), BillEndDate);
                if JobForecast.FINDSET() then
                    repeat
                        JobForecast.MARK := true;
                    until JobForecast.NEXT() = 0;
                JobForecast.SETRANGE("NS_Status Date");
                JobForecast.MARKEDONLY(true);
            end;
            if JobForecast.COUNT = 0 then
                MESSAGE(Text002_Txt);
            if JobForecast.FINDSET() then begin
                repeat
                    if ((JobForecast."NS_Status Date" > 0D) or
                        (JobForecast."NS_Percent Complete" > 0))
                       and
                       ((JobForecast."NS_Percent Complete" = 100) or
                        (JobForecast."NS_Percent Complete" < JobSetup."NS_Forecast Percent For HrsReq") or
                        (JobSetup."NS_Forecast Percent For HrsReq" = 0) or
                        (JobForecast."NS_Hours To Finish" > 0) or
                        (JobForecast."NS_Entry Type" = JobForecast."NS_Entry Type"::Price)) then begin
                        if (JobForecast."NS_Entry Type" = JobForecast."NS_Entry Type"::Price) and (JobForecast."NS_Status Date" = 0D) then
                            JobForecast."NS_Status Date" := DefaultStatusDate;
                        JobForecast.NS_Posted := true;
                        JobForecast."NS_User ID" := USERID;
                        if JobForecast."NS_Job Task No." = '13-13200-13280' then
                            q := q;
                        if JobForecast."NS_Forecasted Completed Cost" = 0 then begin
                            JobForecast2.RESET();
                            JobForecast2.SETRANGE("NS_Job No.", JobForecast."NS_Job No.");
                            JobForecast2.SETRANGE("NS_Job Task No.", JobForecast."NS_Job Task No.");
                            JobForecast2.SETRANGE("NS_Line No.", JobForecast."NS_Line No." - 1);

                            if (JobForecast2.FINDFIRST()) and (JobForecast2."NS_Forecasted Completed Cost" <> 0) then
                                JobForecast."NS_Forecasted Completed Cost" := JobForecast2."NS_Forecasted Completed Cost";
                        end;
                        JobForecast.MODIFY();
                        //Build a new unposted line for display
                        JobForecast."NS_Line No." := JobForecast."NS_Line No." + 1;
                        JobForecast."NS_Units Complete" := 0;
                        if JobForecast."NS_Percent Complete" = 100 then
                            JobForecast."NS_Forecasted Completed Cost" := NS_Get100PctCost(JobForecast."NS_Job No.", JobForecast."NS_Job Task No.")
                        else
                            JobForecast."NS_Forecasted Completed Cost" := 0;
                        JobForecast."NS_Forecasted Completed Price" := 0;

                        JobForecast."NS_Bill Date" := 0D;
                        JobForecast."NS_Bill Percent" := 0;
                        JobForecast."NS_PO Expected Receipt Cost" := 0;
                        JobForecast."NS_Posted Check Boolean" := true;
                        JobForecast.NS_Posted := false;
                        JobForecast."NS_User ID" := '';
                        JobForecast.INSERT();
                    end;
                until JobForecast.NEXT() = 0;
            end else
                MESSAGE(Text003_Txt);
            ///// Job Forecast sublevel value insert - start
            if IncludeSublevelBool = true then begin
                JobRec3.RESET;
                JobRec3.SETRANGE("NS_Sub-Level to Job No.", JobNo);
                if GBPGValTxt > '' then
                    JobRec3.SetFilter("NS_Gen. Bus. Posting Group New", GBPGValTxt);
                JobRec3.SetRange("NS_Exclude from Job Forecast", false);
                if JobRec3.FindSet then begin
                    REPEAT

                        JobForecastSubLevelValInsert.RESET();
                        JobForecastSubLevelValInsert.MARKEDONLY(false);
                        if JobRec3."No." > '' then
                            JobForecastSubLevelValInsert.SETRANGE("NS_Job No.", JobRec3."No.");
                        JobForecastSubLevelValInsert.SETRANGE(NS_Posted, false);

                        if (JobRec3."No." = '') and (NextBillDate > 0D) then begin
                            BillStartDate := DMY2DATE(1, DATE2DMY(NextBillDate, 2), DATE2DMY(NextBillDate, 3));
                            if DATE2DMY(BillStartDate, 2) < 12 then
                                BillEndDate := CALCDATE('-1D', DMY2DATE(1, DATE2DMY(NextBillDate, 2) + 1, DATE2DMY(NextBillDate, 3)))
                            else
                                BillEndDate := DMY2DATE(12, 31, DATE2DMY(NextBillDate, 3));

                            JobForecastSubLevelValInsert.SETFILTER("NS_Bill Date", '%1..%2', BillStartDate, BillEndDate);
                            if JobForecastSubLevelValInsert.FINDSET() then
                                repeat
                                    JobForecastSubLevelValInsert.MARK := true;
                                until JobForecastSubLevelValInsert.NEXT = 0;
                            JobForecastSubLevelValInsert.SETRANGE("NS_Bill Date");
                            JobForecastSubLevelValInsert.SETFILTER("NS_Status Date", '%1..%2', CALCDATE('-31D', BillStartDate), BillEndDate);
                            if JobForecastSubLevelValInsert.FINDSET() then
                                repeat
                                    JobForecastSubLevelValInsert.MARK := true;
                                until JobForecastSubLevelValInsert.NEXT() = 0;
                            JobForecastSubLevelValInsert.SETRANGE("NS_Status Date");
                            JobForecastSubLevelValInsert.MARKEDONLY(true);
                        end;

                        if JobForecastSubLevelValInsert.FINDSET() then begin
                            repeat
                                if ((JobForecastSubLevelValInsert."NS_Status Date" > 0D) or
                                    (JobForecastSubLevelValInsert."NS_Percent Complete" > 0))
                                   and
                                   ((JobForecastSubLevelValInsert."NS_Percent Complete" = 100) or
                                    (JobForecastSubLevelValInsert."NS_Percent Complete" < JobSetup."NS_Forecast Percent For HrsReq") or
                                    (JobSetup."NS_Forecast Percent For HrsReq" = 0) or
                                    (JobForecastSubLevelValInsert."NS_Hours To Finish" > 0) or
                                    (JobForecastSubLevelValInsert."NS_Entry Type" = JobForecastSubLevelValInsert."NS_Entry Type"::Price)) then begin
                                    if (JobForecastSubLevelValInsert."NS_Entry Type" = JobForecastSubLevelValInsert."NS_Entry Type"::Price) and (JobForecastSubLevelValInsert."NS_Status Date" = 0D) then
                                        JobForecastSubLevelValInsert."NS_Status Date" := DefaultStatusDate;
                                    JobForecastSubLevelValInsert.NS_Posted := true;
                                    JobForecastSubLevelValInsert."NS_User ID" := USERID;
                                    if JobForecastSubLevelValInsert."NS_Job Task No." = '13-13200-13280' then
                                        q := q;
                                    if JobForecastSubLevelValInsert."NS_Forecasted Completed Cost" = 0 then begin
                                        JobForecast2.RESET;
                                        JobForecast2.SETRANGE("NS_Job No.", JobRec3."No.");
                                        JobForecast2.SETRANGE("NS_Job Task No.", JobForecastSubLevelValInsert."NS_Job Task No.");
                                        JobForecast2.SETRANGE("NS_Line No.", JobForecastSubLevelValInsert."NS_Line No." - 1);
                                        if (JobForecast2.FINDFIRST()) and (JobForecast2."NS_Forecasted Completed Cost" <> 0) then
                                            JobForecastSubLevelValInsert."NS_Forecasted Completed Cost" := JobForecast2."NS_Forecasted Completed Cost";
                                    end;
                                    JobForecastSubLevelValInsert.MODIFY();

                                    JobForecastSubLevelValInsert."NS_Line No." := JobForecastSubLevelValInsert."NS_Line No." + 1;

                                    if JobForecastSubLevelValInsert."NS_Percent Complete" = 0 then
                                        JobForecastSubLevelValInsert."NS_Status Date" := 0D;

                                    JobForecastSubLevelValInsert."NS_Units Complete" := 0;

                                    if JobForecastSubLevelValInsert."NS_Percent Complete" = 100 then
                                        JobForecastSubLevelValInsert."NS_Forecasted Completed Cost" := NS_Get100PctCost(JobRec3."No.", JobForecastSubLevelValInsert."NS_Job Task No.")
                                    else
                                        JobForecastSubLevelValInsert."NS_Forecasted Completed Cost" := 0;
                                    JobForecastSubLevelValInsert."NS_Forecasted Completed Price" := 0;
                                    JobForecastSubLevelValInsert."NS_Hours To Finish" := 0;
                                    JobForecastSubLevelValInsert."NS_Bill Date" := 0D;
                                    JobForecastSubLevelValInsert."NS_Bill Percent" := 0;
                                    JobForecastSubLevelValInsert."NS_PO Expected Receipt Cost" := 0;
                                    JobForecastSubLevelValInsert.NS_Posted := false;
                                    JobForecastSubLevelValInsert."NS_User ID" := '';
                                    JobForecastSubLevelValInsert.INSERT;
                                end;

                            until JobForecastSubLevelValInsert.NEXT = 0;
                        end;
                    UNTIL JobRec3.NEXT = 0;
                end
                else begin

                end;
            end;
            ////////////// end code for Job forecaset by Task totals //////////////////////////////   
        end;

    end;

    /// <summary>
    /// NS_ForecastedCompletedAmtNoDateFBTT.
    /// </summary>
    /// <param name="JobNo">Code[20].</param>
    /// <param name="DefaultStatusDate">Date.</param>
    procedure NS_ForecastedCompletedAmtNoDateFBTT(JobNo: Code[20]; DefaultStatusDate: Date);
    var
        JobForecast2: Record "NS_Job Forecast";
        Job: Record Job;
        JobTask2: Record "Job Task";
        Amount: Decimal;
        JobTaskHold: Code[20];
        AmountFound: Boolean;
        JobPlanningLineBudget: Record "Job Planning Line";
        ProjectedCost: Decimal;
        PreviousJobForecast: Record "NS_Job Forecast";
        JobForecast: Record "NS_Job Forecast";
        TotalBudget: Decimal;
        ForecastedVariance: Decimal;
        TotalCostsUsed: Decimal;
        q: Integer;
    begin

        if JobNo > '' then begin

            JobForecast.RESET();
            JobForecast.SETRANGE("NS_Job No.", JobNo);
            JobForecast.SETRANGE("NS_Line No.", 100);
            JobForecast.SETRANGE("NS_Status Date", 0D);
            JobForecast.SETRANGE(NS_Posted, false);
            JobForecast.SETFILTER("NS_Forecasted Completed Cost", '%1', 0);
            //SetRange(NS_Complete, false);
            if JobForecast.FINDSET() then
                repeat
                    JobTask2.Reset();
                    if JobTask2.Get(JobForecast."NS_Job No.", JobForecast."NS_Job Task No.") then;
                    if JobForecast."NS_Job Task No." = '13-13200-13280' then
                        q := q;
                    TotalBudget := 0;
                    JobForecast."NS_Percent Complete" := 0;
                    TotalCostsUsed := NS_Get100PctCost(JobForecast."NS_Job No.", JobForecast."NS_Job Task No.");
                    JobPlanningLineBudget.RESET();
                    JobPlanningLineBudget.SETRANGE("Job No.", JobForecast."NS_Job No.");

                    JobPlanningLineBudget.SetFilter("Job Task No.", JobTask2.Totaling);
                    JobPlanningLineBudget.CALCSUMS("Total Cost", "Total Cost (LCY)");
                    TotalBudget := JobPlanningLineBudget."Total Cost";
                    if JobForecast."NS_Hours To Finish" <> 0 then
                        JobForecast."NS_Cost To Complete" := JobForecast."NS_Cost To Complete"
                    else
                        JobForecast."NS_Cost To Complete" := NS_CalcCostToComplete(JobForecast."NS_Status Date", JobForecast."NS_Percent Complete", TotalBudget, TotalCostsUsed,
                                                                 PreviousJobForecast."NS_Status Date",
                                                                 PreviousJobForecast."NS_Forecasted Completed Cost");

                    JobForecast."NS_Forecasted Completed Cost" := TotalCostsUsed + JobForecast."NS_Cost To Complete";
                    JobForecast."NS_Status Date" := DefaultStatusDate;
                    ForecastedVariance := TotalBudget - JobForecast."NS_Forecasted Completed Cost";
                    JobForecast.MODIFY();
                until JobForecast.NEXT() = 0;
        end;
    end;

    /// //PRJ-1299.JS.1.0 19APR2022 - end 

    //PRJ-1299.JS.2.0 23MAY2022 - Start
    /// <summary>
    /// NS_PostLinesIncludeSubLevelsFBTT.
    /// </summary>
    /// <param name="JobNo">Code[20].</param>
    /// <param name="DefaultStatusDate">Date.</param>
    /// <param name="NextBillDate">Date.</param>
    procedure NS_PostLinesIncludeSubLevelsFBTT(JobNo: Code[20]; DefaultStatusDate: Date; NextBillDate: Date);
    var
        JobForecast: Record "NS_Job Forecast";
        JobForecast2: Record "NS_Job Forecast";
        BillStartDate: Date;
        BillEndDate: Date;
        JobDateFilter: Text;
        TotalCostsUsed: Decimal;
        q: Integer;
        ReportJobForecast: Record "NS_Job Forecast";
        JobForecastWorksheetReport: Report "NS_Percentage of Compl.";
        JobForecastWorksheetReport_C: Report "NS_Percentage of Compl.";
        JobForecastWorksheetReport_C1: Report "NS_POCompl Include Sub Levels";
        IncludeSublevelBool: Boolean;
        JobsetupRec: Record "Jobs Setup";
        JobRecord: Record Job;
        JobRec2: Record Job;
        JobRec3: Record Job;
        JobTable: Record job;
        GBPGValTxt: Text;
        JobForecastSubLevelValInsert: Record "NS_Job Forecast";
        JobForecastWkshtPg: Page "NS_Job Forecast Worksheet";
        JobForecastTable: Record "NS_Job Forecast";
        JobNoFilter: Code[20];
        IsHandled: Boolean;//FGH-163.SM.29022024 //PE-269.JS.1.0
    begin
        //FGH-163.SM.29022024 START //PE-269.JS.1.0
        OnBeforePostLinesIncludeSubLevelsFBTT(JobNo, DefaultStatusDate, NextBillDate, IsHandled);
        if IsHandled then
            exit;
        //FGH-163.SM.29022024 END //PE-269.JS.1.0
        //Message('BBBBB');  //OK
        JobNoFilter := '';
        JobNoFilter := '@*' + JobNo + '*';
        JobsetupRec.Get;


        Clear(IncludeSublevelBool);

        Clear(GBPGValTxt);

        GBPGValTxt := JobsetupRec."NS_GBPG for Job Forecast";

        if JobNo <> '' then begin
            if JobTable.get(JobNo) then
                if ((JobTable."NS_Sub-Level to Job No." = '') and (JobTable."NS_Include Sub Levels" = true)) then begin
                    if JobRecord.Get(JobTable."No.") then
                        NS_ForecastedCompletedAmtNoDateIncSubLevels(JobRecord."No.", DefaultStatusDate);
                end;
        end;
        //PRJ-1132.NK.1.0 Start
        //with JobForecast do begin
        if JobNo > '' then begin
            if DefaultStatusDate > 0D then begin
                //Error('EEEEEE');   //OK
                JobForecastWorksheetReport_C1.Set(JobNo, DefaultStatusDate);
                JobForecastWorksheetReport_C1.RunModal();
                Clear(JobForecastWorksheetReport_C1);

                // JobRec2.RESET;
                // //JobRec2.SETRANGE("NS_Sub-Level to Job No.", JobNo);
                // JobRec2.setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                // if GBPGValTxt > '' then
                //     JobRec2.SetFilter("NS_Gen. Bus. Posting Group", GBPGValTxt);
                // JobRec2.SetRange("NS_Exclude from Job Forecast", false);
                // if JobRec2.findset then begin
                //     REPEAT
                //         if JobRec2."No." > '' then begin
                //             //AS - START COMMENT

                //             //SK Start
                //             OnOpenJobForcastPage(JobForecast, JobRec2."No.", DefaultStatusDate, NextBillDate);

                //             JobForecastTable.Reset();
                //             JobForecastTable.SetRange("NS_Job No.", JobRec2."No.");
                //             if JobForecastTable.FindSet() then
                //                 repeat
                //                     OnAfterGetJobForcastPage(JobForecastTable, JobRec2."No.", DefaultStatusDate, NextBillDate);
                //                     OnAfterGetCurrRecordJobForcastPage(JobForecastTable, JobRec2."No.", DefaultStatusDate, NextBillDate);
                //                     JobForecastTable.Modify();
                //                 until JobForecastTable.Next() = 0;
                //             //SK End

                //             //AS - END COMMENT

                //             JobForecastWorksheetReport_C1.Set(JobRec2."No.", DefaultStatusDate);
                //             JobForecastWorksheetReport_C1.RunModal();
                //             Clear(JobForecastWorksheetReport_C1);
                //         end;
                //     UNTIL JobRec2.NEXT = 0;
                //end
                //else begin

                //end;

                // if IncludeSublevelBool = false then begin
                //     JobForecastWorksheetReport.Set(JobNo, DefaultStatusDate);
                //     JobForecastWorksheetReport.RUNMODAL();
                //     CLEAR(JobForecastWorksheetReport);
                // end
            end else
                ERROR('Please check the As of date field');
        end;
        //CTSI-94.ms.1.0.end
        JobSetup.GET();
        JobForecast.RESET();
        JobForecast.MARKEDONLY(false);
        if JobNo > '' then
            JobForecast.SETRANGE("NS_Job No.", JobNo);
        JobForecast.SETRANGE(NS_Posted, false);
        //SetFilter(NS_Complete, '%1', false);//CTSI-232 roll back
        if (JobNo = '') and (NextBillDate > 0D) then begin
            BillStartDate := DMY2DATE(1, DATE2DMY(NextBillDate, 2), DATE2DMY(NextBillDate, 3));
            if DATE2DMY(BillStartDate, 2) < 12 then
                BillEndDate := CALCDATE('<-1D>', DMY2DATE(1, DATE2DMY(NextBillDate, 2) + 1, DATE2DMY(NextBillDate, 3)))
            else
                BillEndDate := DMY2DATE(12, 31, DATE2DMY(NextBillDate, 3));

            JobForecast.SETFILTER("NS_Bill Date", '%1..%2', BillStartDate, BillEndDate);
            if JobForecast.FINDSET() then
                repeat
                    JobForecast.MARK := true;
                until JobForecast.NEXT() = 0;
            JobForecast.SETRANGE("NS_Bill Date");
            JobForecast.SETFILTER("NS_Status Date", '%1..%2', CALCDATE('<-31D>', BillStartDate), BillEndDate);
            if JobForecast.FINDSET() then
                repeat
                    JobForecast.MARK := true;
                until JobForecast.NEXT() = 0;
            JobForecast.SETRANGE("NS_Status Date");
            JobForecast.MARKEDONLY(true);
        end;
        if JobForecast.COUNT = 0 then
            MESSAGE(Text002_Txt);
        if JobForecast.FINDSET() then begin
            repeat
                if ((JobForecast."NS_Status Date" > 0D) or
                    (JobForecast."NS_Percent Complete" > 0))
                   and
                   ((JobForecast."NS_Percent Complete" = 100) or
                    (JobForecast."NS_Percent Complete" < JobSetup."NS_Forecast Percent For HrsReq") or
                    (JobSetup."NS_Forecast Percent For HrsReq" = 0) or
                    (JobForecast."NS_Hours To Finish" > 0) or
                    (JobForecast."NS_Entry Type" = JobForecast."NS_Entry Type"::Price)) then begin
                    if (JobForecast."NS_Entry Type" = JobForecast."NS_Entry Type"::Price) and (JobForecast."NS_Status Date" = 0D) then
                        JobForecast."NS_Status Date" := DefaultStatusDate;
                    JobForecast.NS_Posted := true;
                    JobForecast."NS_User ID" := USERID;
                    if JobForecast."NS_Job Task No." = '13-13200-13280' then
                        q := q;
                    if JobForecast."NS_Forecasted Completed Cost" = 0 then begin
                        JobForecast2.RESET();
                        JobForecast2.SETRANGE("NS_Job No.", JobForecast."NS_Job No.");
                        JobForecast2.SETRANGE("NS_Job Task No.", JobForecast."NS_Job Task No.");
                        JobForecast2.SETRANGE("NS_Line No.", JobForecast."NS_Line No." - 1);
                        //JobForecast2.SetFilter(NS_Complete, '%1', false); //CTSI-232 roll back
                        if (JobForecast2.FINDFIRST()) and (JobForecast2."NS_Forecasted Completed Cost" <> 0) then
                            JobForecast."NS_Forecasted Completed Cost" := JobForecast2."NS_Forecasted Completed Cost";
                    end;
                    JobForecast.MODIFY();
                    //Build a new unposted line for display
                    JobForecast."NS_Line No." := JobForecast."NS_Line No." + 1;

                    //if "NS_Percent Complete" = 0 then //PRJ-565 comment
                    //    "NS_Status Date" := 0D;

                    JobForecast."NS_Units Complete" := 0;
                    //"NS_Cost To Complete" := 0;//ctsi-231
                    if JobForecast."NS_Percent Complete" = 100 then
                        JobForecast."NS_Forecasted Completed Cost" := NS_Get100PctCost(JobForecast."NS_Job No.", JobForecast."NS_Job Task No.")
                    else
                        JobForecast."NS_Forecasted Completed Cost" := 0;
                    JobForecast."NS_Forecasted Completed Price" := 0;
                    //"NS_Hours To Finish" := 0;//PRJ-565.MS.1.0 roll back //PRJ-565.AS.1.0 12MARCH2021- COMMENT
                    JobForecast."NS_Bill Date" := 0D;
                    JobForecast."NS_Bill Percent" := 0;
                    JobForecast."NS_PO Expected Receipt Cost" := 0;
                    JobForecast."NS_Posted Check Boolean" := true;//JD-48.AS.1.0
                    JobForecast.NS_Posted := false;
                    JobForecast."NS_User ID" := '';
                    JobForecast.INSERT();
                end;
            until JobForecast.NEXT() = 0;
        end else
            MESSAGE(Text003_Txt);
        //CTSI-115.AS.1.0 - start
        ///// Job Forecast sublevel value insert - start
        if IncludeSublevelBool = true then begin
            JobRec3.RESET;
            JobRec3.SETRANGE("NS_Sub-Level to Job No.", JobNo);
            if GBPGValTxt > '' then
                //PRJ-1489.GK.1.0 start
                JobRec3.SetFilter("NS_Gen. Bus. Posting Group New", GBPGValTxt);
            //JobRec3.SetFilter("NS_Gen. Bus. Posting Group", GBPGValTxt);
            //PRJ-1489.GK.1.0 end
            JobRec3.SetRange("NS_Exclude from Job Forecast", false);
            if JobRec3.FindSet then begin
                REPEAT
                    //PRJ-1132.NK.1.0 Start
                    //with JobForecastSubLevelValInsert do begin
                    JobForecastSubLevelValInsert.RESET();
                    JobForecastSubLevelValInsert.MARKEDONLY(false);
                    if JobRec3."No." > '' then
                        SETRANGE("NS_Job No.", JobRec3."No.");
                    JobForecastSubLevelValInsert.SETRANGE(NS_Posted, false);
                    //SetFilter(NS_Complete, '%1', false);//CTSI-232 roll back
                    if (JobRec3."No." = '') and (NextBillDate > 0D) then begin
                        BillStartDate := DMY2DATE(1, DATE2DMY(NextBillDate, 2), DATE2DMY(NextBillDate, 3));
                        if DATE2DMY(BillStartDate, 2) < 12 then
                            BillEndDate := CALCDATE('-1D', DMY2DATE(1, DATE2DMY(NextBillDate, 2) + 1, DATE2DMY(NextBillDate, 3)))
                        else
                            BillEndDate := DMY2DATE(12, 31, DATE2DMY(NextBillDate, 3));

                        JobForecastSubLevelValInsert.SETFILTER("NS_Bill Date", '%1..%2', BillStartDate, BillEndDate);
                        if JobForecastSubLevelValInsert.FINDSET() then
                            repeat
                                JobForecastSubLevelValInsert.MARK := true;
                            until JobForecastSubLevelValInsert.NEXT = 0;
                        JobForecastSubLevelValInsert.SETRANGE("NS_Bill Date");
                        JobForecastSubLevelValInsert.SETFILTER("NS_Status Date", '%1..%2', CALCDATE('-31D', BillStartDate), BillEndDate);
                        if JobForecastSubLevelValInsert.FINDSET then
                            repeat
                                JobForecastSubLevelValInsert.MARK := true;
                            until JobForecastSubLevelValInsert.NEXT = 0;
                        JobForecastSubLevelValInsert.SETRANGE("NS_Status Date");
                        JobForecastSubLevelValInsert.MARKEDONLY(true);
                    end;
                    //if COUNT = 0 then
                    //    MESSAGE(Text002_Txt);//PRJ-441.MS.1.0 comment
                    if JobForecastSubLevelValInsert.FINDSET then begin
                        repeat
                            if ((JobForecastSubLevelValInsert."NS_Status Date" > 0D) or
                                (JobForecastSubLevelValInsert."NS_Percent Complete" > 0))
                               and
                               ((JobForecastSubLevelValInsert."NS_Percent Complete" = 100) or
                                (JobForecastSubLevelValInsert."NS_Percent Complete" < JobSetup."NS_Forecast Percent For HrsReq") or
                                (JobSetup."NS_Forecast Percent For HrsReq" = 0) or
                                (JobForecastSubLevelValInsert."NS_Hours To Finish" > 0) or
                                (JobForecastSubLevelValInsert."NS_Entry Type" = JobForecastSubLevelValInsert."NS_Entry Type"::Price)) then begin
                                if (JobForecastSubLevelValInsert."NS_Entry Type" = JobForecastSubLevelValInsert."NS_Entry Type"::Price) and (JobForecastSubLevelValInsert."NS_Status Date" = 0D) then
                                    JobForecastSubLevelValInsert."NS_Status Date" := DefaultStatusDate;
                                JobForecastSubLevelValInsert.NS_Posted := true;
                                JobForecastSubLevelValInsert."NS_User ID" := USERID;
                                if JobForecastSubLevelValInsert."NS_Job Task No." = '13-13200-13280' then
                                    q := q;
                                if JobForecastSubLevelValInsert."NS_Forecasted Completed Cost" = 0 then begin
                                    JobForecast2.RESET;
                                    JobForecast2.SETRANGE("NS_Job No.", JobRec3."No.");
                                    JobForecast2.SETRANGE("NS_Job Task No.", JobForecastSubLevelValInsert."NS_Job Task No.");
                                    JobForecast2.SETRANGE("NS_Line No.", JobForecastSubLevelValInsert."NS_Line No." - 1);
                                    if (JobForecast2.FINDFIRST) and (JobForecast2."NS_Forecasted Completed Cost" <> 0) then
                                        JobForecastSubLevelValInsert."NS_Forecasted Completed Cost" := JobForecast2."NS_Forecasted Completed Cost";
                                end;
                                JobForecastSubLevelValInsert.MODIFY;
                                //Build a new unposted line for display
                                JobForecastSubLevelValInsert."NS_Line No." := JobForecastSubLevelValInsert."NS_Line No." + 1;

                                if JobForecastSubLevelValInsert."NS_Percent Complete" = 0 then
                                    JobForecastSubLevelValInsert."NS_Status Date" := 0D;

                                JobForecastSubLevelValInsert."NS_Units Complete" := 0;
                                //"NS_Cost To Complete" := 0;//ctsi-231
                                if JobForecastSubLevelValInsert."NS_Percent Complete" = 100 then
                                    JobForecastSubLevelValInsert."NS_Forecasted Completed Cost" := NS_Get100PctCost(JobRec3."No.", JobForecastSubLevelValInsert."NS_Job Task No.")
                                else
                                    JobForecastSubLevelValInsert."NS_Forecasted Completed Cost" := 0;
                                JobForecastSubLevelValInsert."NS_Forecasted Completed Price" := 0;
                                JobForecastSubLevelValInsert."NS_Hours To Finish" := 0;
                                JobForecastSubLevelValInsert."NS_Bill Date" := 0D;
                                JobForecastSubLevelValInsert."NS_Bill Percent" := 0;
                                JobForecastSubLevelValInsert."NS_PO Expected Receipt Cost" := 0;
                                JobForecastSubLevelValInsert.NS_Posted := false;
                                JobForecastSubLevelValInsert."NS_User ID" := '';
                                JobForecastSubLevelValInsert.INSERT();
                            end;

                        until JobForecastSubLevelValInsert.NEXT = 0;
                    end //else
                        //MESSAGE(Text003_Txt);//PRJ-441.MS.1.0 comment
                        //end;
                        //PRJ-1132.NK.1.0
                UNTIL JobRec3.NEXT = 0;
            end
            else begin

            end;
        end;
        ///// Job Forecast sublevel value insert - end
        //CTSI-115.AS.1.0 - end
        //end;
        //PRJ-1132.NK.1.0 End
    end;
    //PRJ-1299.JS.2.0 23MAY2022 - end            

    //PRJ-1355.JS.2.0 27MAY2022 - Start
    /// <summary>
    /// NS_Get100PctCostIncludeSubLevelNew.
    /// </summary>
    /// <param name="JobNo">Code[20].</param>
    /// <param name="JobTaskNo">Code[20].</param>
    /// <param name="DefaultStatusDate">Date.</param>
    /// <returns>Return variable TotalCostUsed of type Decimal;.</returns>
    procedure NS_Get100PctCostIncludeSubLevelNew(JobNo: Code[20]; JobTaskNo: Code[20]; DefaultStatusDate: Date) TotalCostUsed: Decimal;   //PRJ-1355.JS.2.0 Revert Parameter
    var
        JobTask: Record "Job Task";
        JobTask2: Record "Job Task";
        NS_JobIncludeSubLevelRec: Record "NS_Job Include Sub Levels";
        NS_JobCodeLen: Integer;
        NS_JobLedgerEntry: Record "Job Ledger Entry";
        NS_FilterJobNo: Code[20];
        IsHandled: Boolean;//FGH-163.SM.29022024 //PE-269.JS.1.0
    begin
        NS_JobCodeLen := 0;
        NS_FilterJobNo := '';
        NS_JobCodeLen := StrLen(JobNo);
        NS_FilterJobNo := '@*' + JobNo + '*';
        TotalCostUsed := 0;

        JobTask.Reset();
        JobTask.SetFilter("Job No.", '%1', NS_FilterJobNo);
        JobTask.SetRange("Job Task No.", JobTaskNo);
        JobTask.SetFilter("Planning Date Filter", '%1', DefaultStatusDate);
        JobTask.CALCFIELDS("Usage (Total Cost)");
        TotalCostUsed := JobTask."Usage (Total Cost)";
        //FGH-163.SM.29022024 START //PE-269.JS.1.0
        OnBeforeGet100PctCostIncludeSubLevelNew(JobNo, JobTaskNo, DefaultStatusDate, TotalCostUsed);
        //FGH-163.SM.29022024 END //PE-269.JS.1.0

        exit(TotalCostUsed);

    end;
    //PRJ-1355.JS.2.0 27MAY2022 - end

    //FGH-163.SM.29022024 PE-269.JS.1.0 05MAR2024 START
    [IntegrationEvent(false, false)]
    local procedure OnBeforeRunReportPOComplSubLevel(JobNo: Code[20]; DefaultStatusDate: Date; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertJobForecastSubLevelValInsert(var JobForecast: Record "NS_Job Forecast")
    begin
    end;
    //FGH-163.SM.29022024 PE-269.JS.1.0 05MAR2024 End

    //FGH-163.SM.29022024 START //PE-269.JS.1.0
    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetJobSubLevelBudgetAmount(var JobNo: code[20]; var JobTaskNo: Code[20]; var SubLevelTotalBudget: decimal; Var ASofDateFilter: date; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetSumOfJobSubLevelCostUsed(var JobNo: code[20]; var JobTaskNo: Code[20]; var SumOfSubLevelTotalCostUsed: decimal; Var ASofDateFilter: date; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeForecastedCompletedAmtNoDateIncSubLevels(JobNo: Code[20]; DefaultStatusDate: Date; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGet100PctCostIncludeSubLevel(JobNo: Code[20]; JobTaskNo: Code[20]; FGHTotalCostUsed: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetJobPlanningLineAndBudgetIncludeSubLevels(JobNo: Code[20]; JobTaskNo: Code[20]; var JobPlanningLine: Record "Job Planning Line"; var TotalBudget: Decimal; Var ASofDateFilter: date; var Ishandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostLinesIncludeSubLevels(JobNo: Code[20]; DefaultStatusDate: Date; NextBillDate: Date; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetBudgetHoursIncludeSubLevels(JobNo: Code[20]; JobTaskNo: Code[20]; var JobPlanningLine: Record "Job Planning Line"; var BudgetedHrs: Decimal; Var ASofDateFilter: date; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetJobSumofTotalBudgetIncludeSubLevels(JobNo: Code[20]; JobTaskNo: Code[20]; var JobPlanningLine: Record "Job Planning Line"; var SumofTotalBudget: Decimal; Var ASofDateFilter: date; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetSumOfTotalCostsUsedIncludeSubLevels(JobNo: Code[20]; JobTaskNo: Code[20]; var JobPlanningLine: Record "Job Planning Line"; var SumOfTotalCostsUsed: Decimal; Var ASofDateFilter: date; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetSumofBudgetRemainingIncludeSubLevelsNew(JobNo: Code[20]; JobTaskNo: Code[20]; var JobPlanningLine: Record "Job Planning Line"; var SumofBudgetRemaining: Decimal; Var ASofDateFilter: date; var SumofForecastedVariance: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostLinesIncludeSubLevelsFBTT(JobNo: Code[20]; DefaultStatusDate: Date; NextBillDate: Date; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGet100PctCostIncludeSubLevelNew(JobNo: Code[20]; JobTaskNo: Code[20]; DefaultStatusDate: Date; FGHTotalCostUsed: Decimal)
    begin
    end;

    //FGH-163.SM.29022024 END //PE-269.JS.1.0

    //PE-282.JS.1.0 26APR2024-Start
    procedure NS_PostLinesWithoutConfirmationIncSubLevel(JobNo: Code[20]; DefaultStatusDate: Date; NextBillDate: Date);
    var
        JobForecast: Record "NS_Job Forecast";
        JobForecast2: Record "NS_Job Forecast";
        JobForecast3: Record "NS_Job Forecast";
        BillStartDate: Date;
        BillEndDate: Date;
        JobDateFilter: Text;
        TotalCostsUsed: Decimal;
        q: Integer;
        ReportJobForecast: Record "NS_Job Forecast";
        JobForecastWorksheetReport: Report "NS_Percentage of Compl.";
        JobForecastWorksheetReport_C: Report "NS_Percentage of Compl.";
        IncludeSublevelBool: Boolean;
        JobsetupRec: Record "Jobs Setup";
        JobRecord: Record Job;
        JobRec2: Record Job;
        JobRec3: Record Job;
        JobTable: Record job;
        GBPGValTxt: Text;
        JobForecastSubLevelValInsert: Record "NS_Job Forecast";
        JobForecastWkshtPg: Page "NS_Job Forecast Worksheet";
        JobForecastTable: Record "NS_Job Forecast";
        JobTabl: Record Job;
        NSJobRec: record Job;
    begin
        if JobsetupRec.Get() then;

        Clear(IncludeSublevelBool);

        Clear(GBPGValTxt);

        GBPGValTxt := JobsetupRec."NS_GBPG for Job Forecast";


        if JobNo <> '' then
            JobTable.get(JobNo);

        IncludeSublevelBool := false;
        NS_ForecastedCompletedAmtNoDate(JobNo, DefaultStatusDate);

        if JobNo > '' then begin
            if DefaultStatusDate > 0D then begin
                if IncludeSublevelBool = true then begin
                    JobForecastWorksheetReport_C.Set(JobNo, DefaultStatusDate);
                    JobForecastWorksheetReport_C.RunModal();
                    Clear(JobForecastWorksheetReport_C);

                    JobRec2.RESET();
                    JobRec2.SETRANGE("NS_Sub-Level to Job No.", JobNo);
                    if GBPGValTxt > '' then
                        JobRec2.SetFilter("NS_Gen. Bus. Posting Group New", GBPGValTxt);
                    JobRec2.SetRange("NS_Exclude from Job Forecast", false);
                    if JobRec2.findset then begin
                        REPEAT
                            if JobRec2."No." > '' then begin
                                OnOpenJobForcastPage(JobForecast, JobRec2."No.", DefaultStatusDate, NextBillDate);

                                JobForecastTable.Reset();
                                JobForecastTable.SetRange("NS_Job No.", JobRec2."No.");
                                if JobForecastTable.FindSet() then
                                    repeat
                                        OnAfterGetJobForcastPage(JobForecastTable, JobRec2."No.", DefaultStatusDate, NextBillDate);
                                        OnAfterGetCurrRecordJobForcastPage(JobForecastTable, JobRec2."No.", DefaultStatusDate, NextBillDate);
                                        JobForecastTable.Modify();
                                    until JobForecastTable.Next() = 0;

                                JobForecastWorksheetReport_C.Set(JobRec2."No.", DefaultStatusDate);
                                JobForecastWorksheetReport_C.RunModal();
                                Clear(JobForecastWorksheetReport_C);
                            end;
                        UNTIL JobRec2.NEXT() = 0;
                    end
                    else begin

                    end;
                end;
                if IncludeSublevelBool = false then begin
                    JobForecastWorksheetReport.Set(JobNo, DefaultStatusDate);
                    JobForecastWorksheetReport.RUNMODAL();
                    CLEAR(JobForecastWorksheetReport);
                end
            end else
                ERROR('Please check the As of date field');
        end;

        JobSetup.GET;
        JobForecast.RESET;
        JobForecast.MARKEDONLY(false);
        if JobNo > '' then
            JobForecast.SETRANGE("NS_Job No.", JobNo);
        JobForecast.SETRANGE(NS_Posted, false);

        if (JobNo = '') and (NextBillDate > 0D) then begin
            BillStartDate := DMY2DATE(1, DATE2DMY(NextBillDate, 2), DATE2DMY(NextBillDate, 3));
            if DATE2DMY(BillStartDate, 2) < 12 then
                BillEndDate := CALCDATE('<-1D>', DMY2DATE(1, DATE2DMY(NextBillDate, 2) + 1, DATE2DMY(NextBillDate, 3)))
            else
                BillEndDate := DMY2DATE(12, 31, DATE2DMY(NextBillDate, 3));

            JobForecast.SETFILTER("NS_Bill Date", '%1..%2', BillStartDate, BillEndDate);
            if JobForecast.FINDSET() then
                repeat
                    JobForecast.MARK := true;
                until JobForecast.NEXT() = 0;
            JobForecast.SETRANGE("NS_Bill Date");
            JobForecast.SETFILTER("NS_Status Date", '%1..%2', CALCDATE('<-31D>', BillStartDate), BillEndDate);
            if JobForecast.FINDSET() then
                repeat
                    JobForecast.MARK := true;
                until JobForecast.NEXT() = 0;
            JobForecast.SETRANGE("NS_Status Date");
            JobForecast.MARKEDONLY(true);
        end;
        if JobForecast.COUNT = 0 then
            MESSAGE(Text002_Txt);
        if JobForecast.FINDSET() then begin
            repeat

                if ((JobForecast."NS_Status Date" > 0D) or
                    (JobForecast."NS_Percent Complete" > 0))
                    then begin

                    JobForecast."NS_Status Date" := DefaultStatusDate;

                    JobForecast.NS_Posted := true;
                    JobForecast."NS_User ID" := USERID;

                    if JobForecast."NS_Job Task No." = '13-13200-13280' then
                        q := q;

                    if JobForecast."NS_Forecasted Completed Cost" = 0 then begin
                        JobForecast2.RESET();
                        JobForecast2.SETRANGE("NS_Job No.", JobForecast."NS_Job No.");
                        JobForecast2.SETRANGE("NS_Job Task No.", JobForecast."NS_Job Task No.");
                        JobForecast2.SETRANGE("NS_Line No.", JobForecast."NS_Line No." - 1);
                        if (JobForecast2.FINDFIRST()) and (JobForecast2."NS_Forecasted Completed Cost" <> 0) then
                            JobForecast."NS_Forecasted Completed Cost" := JobForecast2."NS_Forecasted Completed Cost";
                    end;


                    JobForecast3.RESET();
                    JobForecast3.SETRANGE("NS_Job No.", JobForecast."NS_Job No.");
                    JobForecast3.SETRANGE("NS_Job Task No.", JobForecast."NS_Job Task No.");
                    JobForecast3.SETRANGE("NS_Line No.", JobForecast."NS_Line No.");
                    if JobForecast3.findfirst() then begin
                        JobForecast."NS_Job No." := JobForecast3."NS_Job No.";
                        JobForecast."NS_Job Task No." := JobForecast3."NS_Job Task No.";
                        JobForecast."NS_Forecasted Completed Cost" := JobForecast3."NS_Forecasted Completed Cost";
                        JobForecast."NS_Cost To Complete" := JobForecast3."NS_Cost To Complete";
                        JobForecast."NS_Percent Complete" := JobForecast3."NS_Percent Complete";
                        JobForecast."NS_Remaining Hours" := JobForecast3."NS_Remaining Hours";
                        JobForecast."Budgeted Hours" := JobForecast3."Budgeted Hours";
                        JobForecast."NS_Bill Percent" := JobForecast3."NS_Bill Percent";
                        JobForecast."NS_Budgeted Hrs Percent Compelete" := JobForecast3."NS_Budgeted Hrs Percent Compelete";
                        JobForecast."NS_Forecasted Completed Price" := JobForecast3."NS_Forecasted Completed Price";
                        JobForecast."NS_Units Complete" := JobForecast3."NS_Units Complete";
                    end;

                    JobForecast.MODIFY();

                    JobForecast."NS_Line No." := JobForecast."NS_Line No." + 1;


                    if JobForecast."NS_Percent Complete" = 100 then
                        JobForecast."NS_Forecasted Completed Cost" := NS_Get100PctCost(JobForecast."NS_Job No.", JobForecast."NS_Job Task No.");  //PE-282.JS.1.0 17APR2024 add ;


                    if JobTabl.get(JobForecast."NS_Job No.") then;

                    if NOT ((JobTabl."NS_Include Sub Levels" = false) and (JobTabl."NS_Job Class" = JobTabl."NS_Job Class"::SubJob)) then begin
                        JobForecast."NS_Bill Date" := 0D;
                        JobForecast."NS_Bill Percent" := 0;
                        JobForecast."NS_PO Expected Receipt Cost" := 0;
                        JobForecast."NS_Posted Check Boolean" := true;
                    end;

                    if ((JobTabl."NS_Include Sub Levels" = false) and (JobTabl."NS_Job Class" = JobTabl."NS_Job Class"::SubJob)) then begin
                        if JobForecast."NS_Bill Date" <> 0D then begin
                            JobForecast."NS_Bill Date" := 0D;
                            JobForecast."NS_Bill Percent" := 0;
                            JobForecast."NS_PO Expected Receipt Cost" := 0;
                            JobForecast."NS_Posted Check Boolean" := true;

                        end else begin
                            JobForecast."NS_Bill Percent" := 0;
                            JobForecast."NS_PO Expected Receipt Cost" := 0;
                            JobForecast."NS_Posted Check Boolean" := false;
                        end;
                    end;

                    JobForecast.NS_Posted := false;
                    JobForecast."NS_User ID" := '';

                    JobForecast.INSERT();
                end;
            until JobForecast.NEXT() = 0;
        end else
            MESSAGE(Text003_Txt);

        if IncludeSublevelBool = true then begin
            JobRec3.RESET;
            JobRec3.SETRANGE("NS_Sub-Level to Job No.", JobNo);
            if GBPGValTxt > '' then
                JobRec3.SetFilter("NS_Gen. Bus. Posting Group New", GBPGValTxt);
            JobRec3.SetRange("NS_Exclude from Job Forecast", false);
            if JobRec3.FindSet then begin
                REPEAT

                    JobForecastSubLevelValInsert.RESET();
                    JobForecastSubLevelValInsert.MARKEDONLY(false);
                    if JobRec3."No." > '' then
                        JobForecastSubLevelValInsert.SETRANGE("NS_Job No.", JobRec3."No.");
                    JobForecastSubLevelValInsert.SETRANGE(NS_Posted, false);

                    if (JobRec3."No." = '') and (NextBillDate > 0D) then begin
                        BillStartDate := DMY2DATE(1, DATE2DMY(NextBillDate, 2), DATE2DMY(NextBillDate, 3));
                        if DATE2DMY(BillStartDate, 2) < 12 then
                            BillEndDate := CALCDATE('-1D', DMY2DATE(1, DATE2DMY(NextBillDate, 2) + 1, DATE2DMY(NextBillDate, 3)))
                        else
                            BillEndDate := DMY2DATE(12, 31, DATE2DMY(NextBillDate, 3));

                        JobForecastSubLevelValInsert.SETFILTER("NS_Bill Date", '%1..%2', BillStartDate, BillEndDate);
                        if JobForecastSubLevelValInsert.FINDSET() then
                            repeat
                                JobForecastSubLevelValInsert.MARK := true;
                            until JobForecastSubLevelValInsert.NEXT = 0;
                        JobForecastSubLevelValInsert.SETRANGE("NS_Bill Date");
                        JobForecastSubLevelValInsert.SETFILTER("NS_Status Date", '%1..%2', CALCDATE('-31D', BillStartDate), BillEndDate);
                        if JobForecastSubLevelValInsert.FINDSET() then
                            repeat
                                JobForecastSubLevelValInsert.MARK := true;
                            until JobForecastSubLevelValInsert.NEXT() = 0;
                        JobForecastSubLevelValInsert.SETRANGE("NS_Status Date");
                        JobForecastSubLevelValInsert.MARKEDONLY(true);
                    end;

                    if JobForecastSubLevelValInsert.FINDSET() then begin
                        repeat
                            if ((JobForecastSubLevelValInsert."NS_Status Date" > 0D) or
                                (JobForecastSubLevelValInsert."NS_Percent Complete" > 0))
                               and
                               ((JobForecastSubLevelValInsert."NS_Percent Complete" = 100) or
                                (JobForecastSubLevelValInsert."NS_Percent Complete" < JobSetup."NS_Forecast Percent For HrsReq") or
                                (JobSetup."NS_Forecast Percent For HrsReq" = 0) or
                                (JobForecastSubLevelValInsert."NS_Hours To Finish" > 0) or
                                (JobForecastSubLevelValInsert."NS_Entry Type" = JobForecastSubLevelValInsert."NS_Entry Type"::Price)) then begin
                                if (JobForecastSubLevelValInsert."NS_Entry Type" = JobForecastSubLevelValInsert."NS_Entry Type"::Price) and (JobForecastSubLevelValInsert."NS_Status Date" = 0D) then
                                    JobForecastSubLevelValInsert."NS_Status Date" := DefaultStatusDate;
                                JobForecastSubLevelValInsert.NS_Posted := true;
                                JobForecastSubLevelValInsert."NS_User ID" := USERID;
                                if JobForecastSubLevelValInsert."NS_Job Task No." = '13-13200-13280' then
                                    q := q;
                                if JobForecastSubLevelValInsert."NS_Forecasted Completed Cost" = 0 then begin
                                    JobForecast2.RESET;
                                    JobForecast2.SETRANGE("NS_Job No.", JobRec3."No.");
                                    JobForecast2.SETRANGE("NS_Job Task No.", JobForecastSubLevelValInsert."NS_Job Task No.");
                                    JobForecast2.SETRANGE("NS_Line No.", JobForecastSubLevelValInsert."NS_Line No." - 1);
                                    if (JobForecast2.FINDFIRST()) and (JobForecast2."NS_Forecasted Completed Cost" <> 0) then
                                        JobForecastSubLevelValInsert."NS_Forecasted Completed Cost" := JobForecast2."NS_Forecasted Completed Cost";
                                end;
                                JobForecastSubLevelValInsert.MODIFY();
                                JobForecastSubLevelValInsert."NS_Line No." := JobForecastSubLevelValInsert."NS_Line No." + 1;

                                if JobForecastSubLevelValInsert."NS_Percent Complete" = 0 then
                                    JobForecastSubLevelValInsert."NS_Status Date" := 0D;

                                JobForecastSubLevelValInsert."NS_Units Complete" := 0;

                                if JobForecastSubLevelValInsert."NS_Percent Complete" = 100 then
                                    JobForecastSubLevelValInsert."NS_Forecasted Completed Cost" := NS_Get100PctCost(JobRec3."No.", JobForecastSubLevelValInsert."NS_Job Task No.")
                                else
                                    JobForecastSubLevelValInsert."NS_Forecasted Completed Cost" := 0;
                                JobForecastSubLevelValInsert."NS_Forecasted Completed Price" := 0;
                                JobForecastSubLevelValInsert."NS_Hours To Finish" := 0;
                                JobForecastSubLevelValInsert."NS_Bill Date" := 0D;
                                JobForecastSubLevelValInsert."NS_Bill Percent" := 0;
                                JobForecastSubLevelValInsert."NS_PO Expected Receipt Cost" := 0;
                                JobForecastSubLevelValInsert.NS_Posted := false;
                                JobForecastSubLevelValInsert."NS_User ID" := '';
                                OnBeforeInsertJobForecastSubLevelValInsert(JobForecastSubLevelValInsert); //FGH-163.SM.29022024 PE-269.JS.1.0 05MAR2024
                                JobForecastSubLevelValInsert.INSERT;
                            end;

                        until JobForecastSubLevelValInsert.NEXT = 0;
                    end

                UNTIL JobRec3.NEXT = 0;
            end
            else begin

            end;
        end;

    end;
    //PE-282.JS.1.0 26APR2024-End    
}

