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
            Caption = 'Total Est. cost to Complete';
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
            OnCheckPPLicenseExpire();
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
            if ASofDateFilter <> 0D then
                setfilter("Planning Date", '..%1', ASofDateFilter); //Prj-565
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
                    TotalBudget := TotalBudget + "Total Cost"
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
            if ASofDateFilter <> 0D then
                setfilter("Planning Date", '..%1', ASofDateFilter); //Prj-565
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
                    SumofTotalBudget := SumofTotalBudget + "Total Cost"
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
                    if ASofDateFilter <> 0D then
                        JobPlanningLineWork.setfilter("Planning Date", '..%1', ASofDateFilter);
                    JobPlanningLineWork.SetFilter("Line Type", '<>%1', JobPlanningLineWork."Line Type"::Billable);
                    if JobPlanningLineWork.FindSet() then
                        repeat
                            TotalBudg := TotalBudg + JobPlanningLineWork."Total Cost"
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
                    if "NS_Percent Complete" <> 100 then
                        SumofForecastedVariance := SumofForecastedVariance + (TotalBudg - "NS_Forecasted Completed Cost")
                    else
                        SumofForecastedVariance := SumofForecastedVariance + (TotalBudg - JobLocal."NS_Usage (Cost) (LCY)");
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
            if ASofDateFilter <> 0D then
                setfilter("Planning Date", '..%1', ASofDateFilter);
            SetFilter("Line Type", '<>%1', "Line Type"::Billable);
            SetFilter("Schedule Line", '%1', true);
            SetFilter(Type, '%1', Type::Resource);
            SetFilter("Unit of Measure Code", '%1', 'HR');
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
    begin
        JobsetupRec.Get;//CTSI-115.AS.1.0


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
                    if (("NS_Status Date" > 0D) or
                        ("NS_Percent Complete" > 0))
                       and
                       (("NS_Percent Complete" = 100) or
                        ("NS_Percent Complete" < JobSetup."NS_Forecast Percent For HrsReq") or
                        (JobSetup."NS_Forecast Percent For HrsReq" = 0) or
                        ("NS_Hours To Finish" > 0) or
                        ("NS_Entry Type" = "NS_Entry Type"::Price)) then begin
                        if ("NS_Entry Type" = "NS_Entry Type"::Price) and ("NS_Status Date" = 0D) then
                            "NS_Status Date" := DefaultStatusDate;
                        NS_Posted := true;
                        "NS_User ID" := USERID;
                        if "NS_Job Task No." = '13-13200-13280' then
                            q := q;
                        if "NS_Forecasted Completed Cost" = 0 then begin
                            JobForecast2.RESET();
                            JobForecast2.SETRANGE("NS_Job No.", "NS_Job No.");
                            JobForecast2.SETRANGE("NS_Job Task No.", "NS_Job Task No.");
                            JobForecast2.SETRANGE("NS_Line No.", "NS_Line No." - 1);
                            //JobForecast2.SetFilter(NS_Complete, '%1', false); //CTSI-232 roll back
                            if (JobForecast2.FINDFIRST()) and (JobForecast2."NS_Forecasted Completed Cost" <> 0) then
                                "NS_Forecasted Completed Cost" := JobForecast2."NS_Forecasted Completed Cost";
                        end;
                        MODIFY();
                        //Build a new unposted line for display
                        "NS_Line No." := "NS_Line No." + 1;

                        //if "NS_Percent Complete" = 0 then //PRJ-565 comment
                        //    "NS_Status Date" := 0D;

                        "NS_Units Complete" := 0;
                        //"NS_Cost To Complete" := 0;//ctsi-231
                        if "NS_Percent Complete" = 100 then
                            "NS_Forecasted Completed Cost" := NS_Get100PctCost("NS_Job No.", "NS_Job Task No.")
                        else
                            "NS_Forecasted Completed Cost" := 0;
                        "NS_Forecasted Completed Price" := 0;
                        //"NS_Hours To Finish" := 0;//PRJ-565.MS.1.0 roll back //PRJ-565.AS.1.0 12MARCH2021- COMMENT
                        "NS_Bill Date" := 0D;
                        "NS_Bill Percent" := 0;
                        "NS_PO Expected Receipt Cost" := 0;
                        "NS_Posted Check Boolean" := true;//JD-48.AS.1.0
                        NS_Posted := false;
                        "NS_User ID" := '';
                        INSERT();
                    end;
                until NEXT() = 0;
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
                        with JobForecastSubLevelValInsert do begin
                            RESET;
                            MARKEDONLY(false);
                            if JobRec3."No." > '' then
                                SETRANGE("NS_Job No.", JobRec3."No.");
                            SETRANGE(NS_Posted, false);
                            //SetFilter(NS_Complete, '%1', false);//CTSI-232 roll back
                            if (JobRec3."No." = '') and (NextBillDate > 0D) then begin
                                BillStartDate := DMY2DATE(1, DATE2DMY(NextBillDate, 2), DATE2DMY(NextBillDate, 3));
                                if DATE2DMY(BillStartDate, 2) < 12 then
                                    BillEndDate := CALCDATE('-1D', DMY2DATE(1, DATE2DMY(NextBillDate, 2) + 1, DATE2DMY(NextBillDate, 3)))
                                else
                                    BillEndDate := DMY2DATE(12, 31, DATE2DMY(NextBillDate, 3));

                                SETFILTER("NS_Bill Date", '%1..%2', BillStartDate, BillEndDate);
                                if FINDSET then
                                    repeat
                                        MARK := true;
                                    until NEXT = 0;
                                SETRANGE("NS_Bill Date");
                                SETFILTER("NS_Status Date", '%1..%2', CALCDATE('-31D', BillStartDate), BillEndDate);
                                if FINDSET then
                                    repeat
                                        MARK := true;
                                    until NEXT = 0;
                                SETRANGE("NS_Status Date");
                                MARKEDONLY(true);
                            end;
                            //if COUNT = 0 then
                            //    MESSAGE(Text002_Txt);//PRJ-441.MS.1.0 comment
                            if FINDSET then begin
                                repeat
                                    if (("NS_Status Date" > 0D) or
                                        ("NS_Percent Complete" > 0))
                                       and
                                       (("NS_Percent Complete" = 100) or
                                        ("NS_Percent Complete" < JobSetup."NS_Forecast Percent For HrsReq") or
                                        (JobSetup."NS_Forecast Percent For HrsReq" = 0) or
                                        ("NS_Hours To Finish" > 0) or
                                        ("NS_Entry Type" = "NS_Entry Type"::Price)) then begin
                                        if ("NS_Entry Type" = "NS_Entry Type"::Price) and ("NS_Status Date" = 0D) then
                                            "NS_Status Date" := DefaultStatusDate;
                                        NS_Posted := true;
                                        "NS_User ID" := USERID;
                                        if "NS_Job Task No." = '13-13200-13280' then
                                            q := q;
                                        if "NS_Forecasted Completed Cost" = 0 then begin
                                            JobForecast2.RESET;
                                            JobForecast2.SETRANGE("NS_Job No.", JobRec3."No.");
                                            JobForecast2.SETRANGE("NS_Job Task No.", "NS_Job Task No.");
                                            JobForecast2.SETRANGE("NS_Line No.", "NS_Line No." - 1);
                                            if (JobForecast2.FINDFIRST) and (JobForecast2."NS_Forecasted Completed Cost" <> 0) then
                                                "NS_Forecasted Completed Cost" := JobForecast2."NS_Forecasted Completed Cost";
                                        end;
                                        MODIFY;
                                        //Build a new unposted line for display
                                        "NS_Line No." := "NS_Line No." + 1;

                                        if "NS_Percent Complete" = 0 then
                                            "NS_Status Date" := 0D;

                                        "NS_Units Complete" := 0;
                                        //"NS_Cost To Complete" := 0;//ctsi-231
                                        if "NS_Percent Complete" = 100 then
                                            "NS_Forecasted Completed Cost" := NS_Get100PctCost(JobRec3."No.", "NS_Job Task No.")
                                        else
                                            "NS_Forecasted Completed Cost" := 0;
                                        "NS_Forecasted Completed Price" := 0;
                                        "NS_Hours To Finish" := 0;
                                        "NS_Bill Date" := 0D;
                                        "NS_Bill Percent" := 0;
                                        "NS_PO Expected Receipt Cost" := 0;
                                        NS_Posted := false;
                                        "NS_User ID" := '';
                                        INSERT;
                                    end;

                                until NEXT = 0;
                            end //else
                                //MESSAGE(Text003_Txt);//PRJ-441.MS.1.0 comment
                        end;
                    UNTIL JobRec3.NEXT = 0;
                end
                else begin

                end;
            end;
            ///// Job Forecast sublevel value insert - end
            //CTSI-115.AS.1.0 - end
        end;
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
                        TotalBudget := JobPlanningLineBudget."Total Cost";
                        if "NS_Hours To Finish" <> 0 then//ctsi-231
                            "NS_Cost To Complete" := "NS_Cost To Complete" //ctsi-231
                        else//ctsi-231
                            "NS_Cost To Complete" := NS_CalcCostToComplete("NS_Status Date", "NS_Percent Complete", TotalBudget, TotalCostsUsed,
                                                                     PreviousJobForecast."NS_Status Date",
                                                                     PreviousJobForecast."NS_Forecasted Completed Cost");

                        "NS_Forecasted Completed Cost" := TotalCostsUsed + "NS_Cost To Complete";
                        "NS_Status Date" := DefaultStatusDate;
                        ForecastedVariance := TotalBudget - "NS_Forecasted Completed Cost";
                        MODIFY();
                    until NEXT() = 0;
            end;
    end;
    //end;

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

    [IntegrationEvent(false, false)]
    local procedure OnCheckPPLicenseExpire()
    begin
    end;
}

