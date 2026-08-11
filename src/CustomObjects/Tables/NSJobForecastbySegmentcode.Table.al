table 14021439 "NS_Job Forecast by Seg code"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //JD-48.AS.1.0 31OCT2020 Created new Table by Saving 14021187

    Caption = 'Job Forecast by Segment code';

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
        field(3; "NS_Segment Code"; Code[20])
        {
            Caption = 'Segment Code';
            Editable = false;
            DataClassification = CustomerContent;

        }
        field(4; "NS_Segment Name"; Text[50])
        {
            Caption = 'Segment Name';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(5; "NS_Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(6; "NS_Posted Segment Boolean"; boolean)
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
        field(506; "NS_Budgeted Hours"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line".Quantity WHERE("Job No." = FIELD("NS_Job No."),
                                                                                 "NS_Segment Code" = field("NS_Segment Code"),
                                                                                 "Job Task No." = FIELD("NS_Job Task No."),
                                                                                 //"Job Task No." = FIELD(FILTER(Totaling)),
                                                                                 "Schedule Line" = CONST(true),
                                                                                 //"Planning Date" = FIELD("Date Filter"),
                                                                                 "line type" = filter(Budget),
                                                                                 "Type" = filter(Resource),
                                                                                 "Unit of Measure Code" = const('HR')));
            Caption = 'Budgeted Hours';
            Description = 'CTSI-21';
            Editable = false;
            FieldClass = FlowField;
        }

        field(507; "NS_Actual Hours"; Decimal)
        {
            CalcFormula = Sum("Job Ledger Entry".Quantity WHERE("Job No." = FIELD("NS_Job No."),
                                                                                 "NS_Segment Code" = field("NS_Segment Code"),
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
    }

    keys
    {
        key(Key1; "NS_Job No.", "NS_Segment Code", "NS_Job Task No.", "NS_Line No.")
        {
            SumIndexFields = "NS_Forecasted Completed Cost", "NS_Forecasted Completed Price";
        }
        key(Key2; "NS_Job No.", "NS_Segment Code", "NS_Job Task No.", "NS_Status Date", NS_Posted)
        {
        }
        key(Key3; "NS_Job No.", "NS_Segment Code", "NS_Job Task No.", NS_Posted, "NS_Status Date")
        {
            SumIndexFields = "NS_Forecasted Completed Cost", "NS_Forecasted Completed Price";
        }
        key(Key4; NS_Posted)
        {
        }
        key(Key5; "NS_Job No.", "NS_Segment Code", "NS_Job Task No.", NS_Posted, "NS_Bill Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        if "NS_Job No." = '' then
            exit;
    end;

    trigger OnModify();
    begin
        UpdateJobTask("NS_Job No.", "NS_Job Task No.", "NS_Status Date", "NS_Percent Complete", "NS_Bill Date", "NS_Bill Percent");
    end;

    var
        Text001_Txt: Label 'Do you want to post this status to the job?';
        Text002_Txt: Label 'Job %1, Task %2 is over %3 complete and therefore requires a "Hours to Finish" value.', comment = '%1 = Job %2 = Job task %3 = Job Task';
        JobSetup: Record "Jobs Setup";
        Text003_Txt: Label 'There is nothing to post.  Check that there are entries for Status Dates.';
        Text004: Label 'Posting complete.';
        Text005: Label 'Do you want to post the billing to the job?';
        Text006: Label 'There is nothing to post.  Check that there are entries for billing dates.';

    procedure NS_GetNewTasks(JobNo: Code[20]; TaskManagerNo: Code[20]);//JD-48.AS.2.0
    var
        JobTask: Record "Job Task";
        JobPlanningLine: Record "Job Planning Line";
        JobForecast: Record "NS_Job Forecast";
        JobForecastbySegCode: Record "NS_Job Forecast by Seg code";
        JLE: Record "Job Ledger Entry";//JD-48.AS.2.0
        JobTakeoffseg: Record "NS_Job Takeoff Segments";
        JLEJobForecastbySegCode: Record "NS_Job Forecast by Seg code";//JD-48.AS.2.0
    begin
        //Add any Job Task lines that are not yet in the Job Forecast table


        //Insert JFW through JPL - start
        JobPlanningLine.RESET;
        JobPlanningLine.SetCurrentKey("Job No.", "Job Task No.", "NS_Segment Code", "Line No.");
        JobPlanningLine.SETRANGE("Job No.", JobNo);
        if JobPlanningLine.FindSet then
            repeat
                JobForecastbySegCode.RESET;
                JobForecastbySegCode.SetCurrentKey("NS_Segment Code");
                JobForecastbySegCode.SETRANGE("NS_Job No.", JobPlanningLine."Job No.");
                JobForecastbySegCode.SetRange("NS_Segment Code", JobPlanningLine."NS_Segment Code");
                JobForecastbySegCode.SetRange("NS_Job Task No.", JobPlanningLine."Job Task No.");
                JobForecastbySegCode.SetRange("NS_Line No.", 100);
                if not JobForecastbySegCode.FindFirst then begin
                    JobForecastbySegCode.INIT;
                    JobForecastbySegCode."NS_Job No." := JobPlanningLine."Job No.";
                    JobForecastbySegCode."NS_Job Task No." := JobPlanningLine."Job Task No.";
                    JobForecastbySegCode."NS_Segment Code" := JobPlanningLine."NS_Segment Code";
                    JobForecastbySegCode."NS_Entry Type" := JobPlanningLine."NS_Entry Type";
                    JobForecastbySegCode."NS_Line No." := 100;
                    JobTakeoffseg.Reset;
                    JobTakeoffseg.SetRange("NS_Job No.", JobPlanningLine."Job No.");
                    JobTakeoffseg.SetRange("NS_Segment Code", JobPlanningLine."NS_Segment Code");
                    if JobTakeoffseg.FindFirst then
                        JobForecastbySegCode."NS_Segment Name" := JobTakeoffseg."NS_Segment Name";
                    JobForecastbySegCode.INSERT(true);
                end;
            until JobPlanningLine.next = 0;
        //Insert JFW through JPL - end

        //Insert JFW through JLE - start
        JLE.RESET;
        JLE.SetCurrentKey("Job No.", "NS_Segment Code", "Job Task No.");
        JLE.SETRANGE("Job No.", JobNo);
        if JLE.FindSet then
            repeat
                JobForecastbySegCode.RESET;
                JobForecastbySegCode.SetCurrentKey("NS_Segment Code");
                JobForecastbySegCode.SETRANGE("NS_Job No.", JLE."Job No.");
                JobForecastbySegCode.SetRange("NS_Segment Code", JLE."NS_Segment Code");
                JobForecastbySegCode.SetRange("NS_Job Task No.", JLE."Job Task No.");
                JobForecastbySegCode.SetRange("NS_Line No.", 100);
                if not JobForecastbySegCode.FindFirst then begin
                    JobForecastbySegCode.INIT;
                    JobForecastbySegCode."NS_Job No." := JLE."Job No.";
                    JobForecastbySegCode."NS_Job Task No." := JLE."Job Task No.";
                    JobForecastbySegCode."NS_Segment Code" := JLE."NS_Segment Code";
                    JobForecastbySegCode."NS_Entry Type" := JLE."Entry Type";
                    JobForecastbySegCode."NS_Line No." := 100;
                    JobTakeoffseg.Reset;
                    JobTakeoffseg.SetRange("NS_Job No.", JLE."Job No.");
                    JobTakeoffseg.SetRange("NS_Segment Code", JLE."NS_Segment Code");
                    if JobTakeoffseg.FindFirst then
                        JobForecastbySegCode."NS_Segment Name" := JobTakeoffseg."NS_Segment Name";
                    JobForecastbySegCode.INSERT(true);
                end;
            until JLE.Next = 0;
        //Insert JFW through JLE - end
        //JD-48.AS.2.0 - END
    end;

    procedure NS_GetLastPostedStatus(JobNo: Code[20]; JobTaskNo: Code[20]; DateLimit: Date; var JobForecast: Record "NS_Job Forecast by Seg code"; SGMNTCode: Code[20]);
    begin
        //Return the last Job Forecast record for the Job and Task passed in with a status of Posted

        with JobForecast do begin
            RESET();
            SETCURRENTKEY(NS_Posted);
            SETRANGE(NS_Posted, true);
            SETRANGE("NS_Job No.", JobNo);
            SETRANGE("NS_Job Task No.", JobTaskNo);
            SetRange("NS_Segment Code", SGMNTCode);
            if DateLimit > 0D then
                SETFILTER("NS_Status Date", '<=%1', DateLimit);
            if not FINDLAST() then
                CLEAR(JobForecast);
        end;
    end;

    procedure NS_GetUnpostedRecord(JobNo: Code[20]; JobTaskNo: Code[20]; var JobForecast: Record "NS_Job Forecast by Seg code");
    begin
        //Return the Job Forecast record for the Job and Task passed in with a status of not Posted

        with JobForecast do begin
            RESET();
            SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date");
            SETRANGE("NS_Job No.", JobNo);
            SETRANGE("NS_Job Task No.", JobTaskNo);
            SETRANGE(NS_Posted, false);
            if not FINDFIRST() then
                CLEAR(JobForecast);
        end;
    end;

    procedure NS_GetJobPlanningLineAndBudget(JobNo: Code[20]; JobTaskNo: Code[20]; var JobPlanningLine: Record "Job Planning Line"; var TotalBudget: Decimal; SGMNTCode: Code[20]);
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
            SetRange("NS_Segment Code", SGMNTCode);
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
                PercentRemaining := 1;
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
        JobForecast: Record "NS_Job Forecast by Seg code";
        JobForecast2: Record "NS_Job Forecast by Seg code";
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
                                    Mode::"Worksheet Cost", Mode::"Worksheet Price":
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
                                        end;
                                end;
                            JobTaskHold := "NS_Job Task No.";
                        end;
                        if ("NS_Job Task No." = JobTaskHold) and ("NS_Status Date" > 0D) and NS_Posted then begin
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
                            Mode::"Worksheet Cost", Mode::"Worksheet Price":
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
                                end;
                        end;
                end;
            end;
        end;
        exit(Answer);
    end;

    procedure NS_PostLines(JobNo: Code[20]; DefaultStatusDate: Date; NextBillDate: Date);
    var
        JobForecast: Record "NS_Job Forecast by Seg code";
        JobForecast2: Record "NS_Job Forecast by Seg code";
        BillStartDate: Date;
        BillEndDate: Date;
        JobDateFilter: Text;//not present in V17
        TotalCostsUsed: Decimal;//not present in V17
        q: Integer;
    begin
        if CONFIRM(Text001_Txt, false) then
            NS_ForecastedCompletedAmtNoDate(JobNo, DefaultStatusDate);
        with JobForecast do begin
            JobSetup.GET;
            RESET;
            MARKEDONLY(false);
            if JobNo > '' then
                SETRANGE("NS_Job No.", JobNo);
            SETRANGE(NS_Posted, false);
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
                            JobForecast2.SetRange("NS_Segment Code", "NS_Segment Code");
                            JobForecast2.SETRANGE("NS_Job Task No.", "NS_Job Task No.");
                            JobForecast2.SETRANGE("NS_Line No.", "NS_Line No." - 1);
                            if (JobForecast2.FINDFIRST()) and (JobForecast2."NS_Forecasted Completed Cost" <> 0) then begin
                                "NS_Forecasted Completed Cost" := JobForecast2."NS_Forecasted Completed Cost";
                            end;
                        end;
                        MODIFY();
                        //Build a new unposted line for display
                        "NS_Line No." := "NS_Line No." + 1;

                        if "NS_Percent Complete" = 0 then
                            "NS_Status Date" := 0D;

                        "NS_Units Complete" := 0;
                        "NS_Cost To Complete" := 0;
                        if "NS_Percent Complete" = 100 then
                            "NS_Forecasted Completed Cost" := NS_Get100PctCost("NS_Job No.", "NS_Job Task No.")
                        else
                            "NS_Forecasted Completed Cost" := 0;
                        "NS_Forecasted Completed Price" := 0;
                        "NS_Hours To Finish" := 0;
                        "NS_Bill Date" := 0D;
                        "NS_Bill Percent" := 0;
                        "NS_PO Expected Receipt Cost" := 0;
                        "NS_Posted Segment Boolean" := true;
                        NS_Posted := false;
                        "NS_User ID" := '';
                        INSERT();
                    end;
                until NEXT() = 0;
            end else
                MESSAGE(Text003_Txt);
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
        CompletionStatus: Record "NS_Job Forecast by Seg code";
        CompletionStatusJob: Record "NS_Job Forecast by Seg code";
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
        JobForecast2: Record "NS_Job Forecast by Seg code";
        Job: Record Job;
        Amount: Decimal;
        JobTaskHold: Code[20];
        AmountFound: Boolean;
        JobForecast: Record "NS_Job Forecast by Seg code";
        ProjectedCost: Decimal;
        TotalBudget: Decimal;
        JobPlanningLineBudget: Record "Job Planning Line";
        PreviousJobForecast: Record "NS_Job Forecast by Seg code";
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
                if FINDSET() then
                    repeat
                        if "NS_Job Task No." = '13-13200-13280' then
                            q := q;
                        TotalBudget := 0;
                        "NS_Percent Complete" := 0;
                        TotalCostsUsed := NS_Get100PctCost("NS_Job No.", "NS_Job Task No.");
                        JobPlanningLineBudget.RESET();
                        JobPlanningLineBudget.SETRANGE("Job No.", "NS_Job No.");
                        JobPlanningLineBudget.SetRange("NS_Segment Code", "NS_Segment Code");
                        JobPlanningLineBudget.SETRANGE("Job Task No.", "NS_Job Task No.");
                        JobPlanningLineBudget.CALCSUMS("Total Cost", "Total Cost (LCY)");
                        TotalBudget := JobPlanningLineBudget."Total Cost";
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
}

