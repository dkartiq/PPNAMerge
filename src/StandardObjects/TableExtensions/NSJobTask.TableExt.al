tableextension 14021213 NS_JobTask extends "Job Task"
{
    // version NAVW111.00.00.22292,PPNA11.00
    //PRJ-1.0.SK    18JUNE2019  Added code in CreateFakeCustomer function
    //CTSI-22.MS-1.001 24 March 2020 added three new fields of hours
    //PRJ-419.MS.1.0 code comment
    //PRJ-807.RS.1.0 9July21 | Ability to Assign Work Units and Work Units Of Measure at Job Task Line
    fields
    {

        modify("Job Task No.")
        {
            trigger OnBeforeValidate()
            begin
                NS_IsFakeCustomer := CreateFakeCustomer();
            end;

            trigger OnAfterValidate()
            begin
                DeleteFakeCustomer(NS_IsFakeCustomer);
            end;
        }

        field(14021100; "NS_Percent Complete"; Decimal)
        {
            Caption = 'Percent Complete';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'ProjectPro';
        }
        field(14021101; "NS_Estimated Hours"; Decimal)
        {
            Caption = 'Estimated Hours';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'ProjectPro';
        }
        field(14021102; "NS_Total Hours Applied"; Decimal)
        {
            CalcFormula = Sum("Job Ledger Entry".Quantity WHERE("Job No." = FIELD("Job No."),
                                                                 "Job Task No." = FIELD("Job Task No.")));
            Caption = 'Total Hours Applied';
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        field(14021103; "NS_Percent Materials"; Decimal)
        {
            Caption = 'Percent Materials';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'ProjectPro';
        }
        field(14021104; "NS_Invoice Due Date"; Date)
        {
            Caption = 'Invoice Due Date';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';

        }
        field(14021120; "NS_Burden Percent"; Decimal)
        {
            Caption = 'Burden Percent';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021140; "NS_Total Percent Complete"; Decimal)
        {
            Caption = 'Total Percent Complete';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021141; "NS_Total Percent Complete Date"; Date)
        {
            Caption = 'Total Percent Complete Date';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021142; "NS_Billing Percent"; Decimal)
        {
            Caption = 'Billing Percent';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021143; "NS_Billing Percent Date"; Date)
        {
            Caption = 'Billing Percent Date';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                Job: Record job;
            begin
                //ProjectPro - start
                Job.get("Job No.");
                "NS_Billing Percent Date" := Job.GetBillDate("NS_Billing Percent Date", "Job No.");
                //ProjectPro - end
            end;
        }
        field(14021190; "NS_Task Before"; Code[20])
        {
            Caption = 'Task Before';
            Description = 'ProjectPro';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
            DataClassification = CustomerContent;
        }
        field(14021191; "NS_Task After"; Code[20])
        {
            Caption = 'Task After';
            Description = 'ProjectPro';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
            DataClassification = CustomerContent;
        }
        field(14021192; "NS_Task Start Date"; Date)
        {
            Caption = 'Task Start Date';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021193; "NS_Task End Date"; Date)
        {
            Caption = 'Task End Date';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021194; "NS_Task Lag Days"; Decimal)
        {
            Caption = 'Task Lag Days';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021195; "NS_Task Days"; Decimal)
        {
            Caption = 'Task Days';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021196; "NS_Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            Description = 'ProjectPro';
            TableRelation = Resource;
            DataClassification = CustomerContent;
        }
        field(14021197; "NS_Start Date Fixed"; Boolean)
        {
            Caption = 'Start Date Fixed';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021198; NS_Manager; Code[20])
        {
            Caption = 'Manager';
            Description = 'ProjectPro';
            TableRelation = Resource WHERE(Type = CONST(Person));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                NS_JobForecast.RESET;
                NS_JobForecast.SETRANGE("NS_Job No.", "Job No.");
                NS_JobForecast.SETRANGE("NS_Job Task No.", "Job Task No.");
                if NS_JobForecast.FINDSET then
                    repeat
                        NS_JobForecast."NS_Task Manager" := NS_Manager;
                        NS_JobForecast.MODIFY;
                    until NS_JobForecast.NEXT = 0;
                //ProjectPro - end
            end;
        }
        field(14021400; "NS_Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021401; "NS_Mark-up"; Decimal)
        {
            Caption = 'Mark-up';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Mark-up" <> xRec."NS_Mark-up" then begin
                    QuoteMgt.NS_CalcAmounts(Rec, xRec, 0);
                    CalcSalesTax("Job No.", "Job Task No.");
                end;
            end;
        }
        field(14021402; "NS_Gross Profit Percentage"; Decimal)
        {
            Caption = 'Gross Profit Percentage';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Gross Profit Percentage" <> xRec."NS_Gross Profit Percentage" then begin
                    QuoteMgt.NS_CalcAmounts(Rec, xRec, 2);
                    CalcSalesTax("Job No.", "Job Task No.");
                end;
            end;
        }
        field(14021403; "NS_Gross Profit"; Decimal)
        {
            Caption = 'Gross Profit';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Gross Profit" <> xRec."NS_Gross Profit" then begin
                    QuoteMgt.NS_CalcAmounts(Rec, xRec, 1);
                    CalcSalesTax("Job No.", "Job Task No.");
                end;
            end;
        }
        field(14021404; "NS_Quantity Weighted"; Boolean)
        {
            Caption = 'Quantity Weighted';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Quantity Weighted" then
                    "NS_Cost Weighted" := false;
            end;
        }
        field(14021405; "NS_Cost Weighted"; Boolean)
        {
            Caption = 'Cost Weighted';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Cost Weighted" then
                    "NS_Quantity Weighted" := false;
            end;
        }
        field(14021408; "NS_Line Amount Incl. Tax"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."NS_Line Amount Incl. Tax" WHERE("Job No." = FIELD("Job No."),
                                                                                 "Job Task No." = FIELD("Job Task No."),
                                                                                 "Job Task No." = FIELD(FILTER(Totaling)),
                                                                                 "Schedule Line" = CONST(true),
                                                                                 "Planning Date" = FIELD("Planning Date Filter")));
            Caption = 'Line Amount Incl. Tax';
            Description = 'ProjectPro';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14021409; "NS_Template No."; Code[20])
        {
            Caption = 'Template No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021410; "NS_Budgeted Hours"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line".Quantity WHERE("Job No." = FIELD("Job No."),
                                                                                 "Job Task No." = FIELD("Job Task No."),
                                                                                 "Job Task No." = FIELD(FILTER(Totaling)),
                                                                                 "Schedule Line" = CONST(true),
                                                                                 "Planning Date" = FIELD("Planning Date Filter"),
                                                                                 "line type" = filter(Budget),
                                                                                 "Type" = filter(Resource),
                                                                                 "Unit of Measure Code" = const('HR')));
            Caption = 'Budgeted Hours';
            Description = 'CTSI-22';
            Editable = false;
            FieldClass = FlowField;
        }

        field(14021411; "NS_Actual Hours"; Decimal)
        {
            CalcFormula = Sum("Job Ledger Entry".Quantity WHERE("Job No." = FIELD("Job No."),
                                                                                 "Job Task No." = FIELD("Job Task No."),
                                                                                 "Job Task No." = FIELD(FILTER(Totaling)),
                                                                                 "Entry Type" = filter(Usage),
                                                                                 "Posting Date" = FIELD("Planning Date Filter"),
                                                                                 "Type" = filter(Resource),
                                                                                 "Unit of Measure Code" = const('HR')));
            Caption = 'Actual Hours';
            Description = 'CTSI-22';
            Editable = false;
            FieldClass = FlowField;

        }

        field(14021412; "NS_Remaining Hours"; Decimal)
        {
            Caption = 'Remaining Hours';
            Description = 'CTSI-22';
            DataClassification = CustomerContent;
        }
        //PRJ-807.RS.1.0 9July21 Start
        field(14021413; "NS_Work Units"; Decimal)
        {
            Caption = 'Work Units';
            DataClassification = CustomerContent;

        }
        field(14021414; "NS_Work Unit of Measure"; Code[10])
        {
            Caption = 'Work Unit of Measure';
            TableRelation = "Unit of Measure".Code;
            DataClassification = CustomerContent;

        }
        //PRJ-807.RS.1.0 9July21 End
    }


    fieldgroups
    {
        addlast(DropDown; "Job No.") { }
    }

    trigger OnBeforeInsert()
    begin
        NS_IsFakeCustomer := CreateFakeCustomer();
    end;

    trigger OnInsert()
    var
        QuoteHeader: Record "NS_Job Quote Header";
    begin

        DeleteFakeCustomer(NS_IsFakeCustomer);

        //ProjectPro - start
        "NS_Burden Percent" := NS_GetDefaultAPOBurdenPercent(NS_FakeJob, "Job Task No.");
        NS_UpdateForecastWorksheet("Job No.", "Job Task No.", "NS_Total Percent Complete Date", "NS_Total Percent Complete", "NS_Billing Percent Date", "NS_Billing Percent");
        IF (QuoteHeader.GET("Job No.")) AND ("NS_Quote No." = '') THEN
            "NS_Quote No." := "Job No.";
        //ProjectPro - end
    end;

    trigger OnModify()
    begin
        //ProjectPro - start
        NS_UpdateForecastWorksheet("Job No.", "Job Task No.", "NS_Total Percent Complete Date", "NS_Total Percent Complete", "NS_Billing Percent Date", "NS_Billing Percent");
        //ProjectPro - end
    end;

    PROCEDURE JobLedgEntriesExist(): Boolean
    VAR
        JobLedgEntry: Record 169;
    BEGIN
        JobLedgEntry.SETCURRENTKEY("Job No.", "Job Task No.");
        JobLedgEntry.SETRANGE("Job No.", "Job No.");
        JobLedgEntry.SETRANGE("Job Task No.", "Job Task No.");
        EXIT(JobLedgEntry.FINDFIRST)
    END;

    PROCEDURE JobPlanningLinesExist(): Boolean;
    VAR
        JobPlanningLine: Record 1003;
    BEGIN
        JobPlanningLine.SETCURRENTKEY("Job No.", "Job Task No.");
        JobPlanningLine.SETRANGE("Job No.", "Job No.");
        JobPlanningLine.SETRANGE("Job Task No.", "Job Task No.");
        EXIT(JobPlanningLine.FINDFIRST)
    END;

    PROCEDURE NS_GetJobTaskDescription(JobNo: Code[20]; JobTaskNo: Code[35]): Text[100];//PRJ-449.AM.1.0
    VAR
        NS_Job: Record 167;
        NS_ActivityCode: Code[10];
        NS_ProcessCode: Code[10];
        NS_OperationCode: Code[10];
        NS_SectionCode: Code[10];//PRJ-688.AM.1.0
        NS_JobActivityRec: Record "NS_Job Activity";
        NS_JobProcessRec: Record "NS_Job Process";
        NS_JobOperationRec: Record "NS_Job Operation";
    BEGIN
        //ProjectPro - start
        Description := '';
        IF (JobNo > '') AND (JobTaskNo > '') THEN BEGIN
            NS_Job.NS_JobTaskNoToAPO(JobTaskNo, NS_ActivityCode, NS_ProcessCode, NS_OperationCode, NS_SectionCode);//PRJ-688.AM.1.0

            IF NS_OperationCode > '' THEN BEGIN
                IF NS_JobOperationRec.GET(0, NS_ActivityCode, NS_ProcessCode, NS_OperationCode) THEN
                    Description := NS_JobOperationRec.NS_Description
                ELSE
                    IF NS_JobOperationRec.GET(1, NS_ActivityCode, NS_ProcessCode, NS_OperationCode) THEN
                        Description := NS_JobOperationRec.NS_Description
                    ELSE
                        Description := Text14021100;
            END ELSE BEGIN
                IF NS_ProcessCode > '' THEN BEGIN
                    IF NS_JobProcessRec.GET(0, NS_ActivityCode, NS_ProcessCode) THEN
                        Description := NS_JobProcessRec.NS_Description
                    ELSE
                        IF NS_JobProcessRec.GET(1, NS_ActivityCode, NS_ProcessCode) THEN
                            Description := NS_JobProcessRec.NS_Description
                        ELSE
                            Description := Text14021100;
                END ELSE
                    IF NS_ActivityCode > '' THEN
                        IF NS_JobActivityRec.GET(0, NS_ActivityCode) THEN
                            Description := NS_JobActivityRec.NS_Description
                        ELSE
                            IF NS_JobActivityRec.GET(1, NS_ActivityCode) THEN
                                Description := NS_JobActivityRec.NS_Description
                            ELSE
                                Description := Text14021100;
            END;
        END;

        EXIT(Description);
        //ProjectPro - end
    END;

    PROCEDURE NS_GetDefaultAPOBurdenPercent(Job: Record 167; JobTaskNo: Code[35]): Decimal;
    VAR
        JobWork: Record 167;
        JobTaskWork: Record 1001;
        JobActivity: Record "NS_Job Activity";
        JobProcess: Record "NS_Job Process";
        JobOperation: Record "NS_Job Operation";
        Activity: Code[10];
        Process: Code[10];
        Operation: Code[10];
        Section: Code[10];//PRJ-688.AM.1.0
        BurdenPercent: Decimal;
    BEGIN
        //ProjectPro - start

        //This routine reads the master APO tables to fill in a Burden Percent on a Job Task.  By looking at a Job's Indirect Burden Type and
        //  the JobTaskNo passed in, this routine will look at the master APO tables to return the correct Burden Percent for the JobTaskNo.

        BurdenPercent := 0;

        IF JobWork.GET(Job."No.") THEN
            IF JobTaskWork.GET(JobWork."No.", JobTaskNo) THEN BEGIN
                JobWork.NS_JobTaskNoToAPO(JobTaskNo, Activity, Process, Operation, Section);//PRJ-688.AM.1.0
                CASE TRUE OF
                    Operation > '':
                        IF JobOperation.GET(JobOperation.NS_Type::Cost, Activity, Process, Operation) THEN
                            CASE Job."NS_Indirect Burden Type" OF
                                Job."NS_Indirect Burden Type"::Project:
                                    BurdenPercent := JobOperation."NS_DefaultProjectBurdenPercent";
                                Job."NS_Indirect Burden Type"::Service:
                                    BurdenPercent := JobOperation."NS_DefaultServiceBurdenPercent";
                            END;
                    Process > '':
                        IF JobProcess.GET(JobProcess.NS_Type::Cost, Activity, Process) THEN
                            CASE Job."NS_Indirect Burden Type" OF
                                Job."NS_Indirect Burden Type"::Project:
                                    BurdenPercent := JobProcess."NS_DefaultProjectBurdenPercent";
                                Job."NS_Indirect Burden Type"::Service:
                                    BurdenPercent := JobProcess."NS_DefaultServiceBurdenPercent";
                            END;
                    Activity > '':
                        IF JobActivity.GET(JobActivity.NS_Type::Cost, Activity) THEN
                            CASE Job."NS_Indirect Burden Type" OF
                                Job."NS_Indirect Burden Type"::Project:
                                    BurdenPercent := JobActivity."NS_DefaultProjectBurdenPerc";
                                Job."NS_Indirect Burden Type"::Service:
                                    BurdenPercent := JobActivity."NS_DefaultServiceBurdenPerc";
                            END;
                END;
            END;

        EXIT(BurdenPercent);
        //ProjectPro - end
    END;

    PROCEDURE NS_GetTaskBurdenPercent(Job: Record 167; JobTaskNo: Code[35]): Decimal;
    VAR
        JobWork: Record 167;
        JobTaskWork: Record 1001;
        BurdenPercent: Decimal;
    BEGIN
        //ProjectPro - start

        //This routine returns the correct Burden Percent for a Job's Task.

        BurdenPercent := 0;

        IF JobWork.GET(Job."No.") THEN
            IF JobTaskWork.GET(JobWork."No.", JobTaskNo) THEN BEGIN
                BurdenPercent := JobTaskWork."NS_Burden Percent";
            END;

        EXIT(BurdenPercent);
        //ProjectPro - end
    END;
    //PRJ-419 comment start
    PROCEDURE NS_UpdateForecastWorksheet(JobNo: Code[20]; JobTaskNo: Code[20]; StatusDate: Date; TotalPct: Decimal; BillDate: Date; BillPct: Decimal);
    VAR
        JobForecast: Record "NS_Job Forecast";
        Found: Boolean;
    BEGIN
        //ProjectPro - start
        //WITH JobForecast DO BEGIN
        //    Found := FALSE;
        //    RESET;
        //    SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date");
        //    SETRANGE("NS_Job No.", JobNo);
        //    SETRANGE("NS_Job Task No.", JobTaskNo);
        //    SETRANGE(NS_Posted, FALSE);
        //    IF FINDSET(TRUE) THEN
        //        Found := TRUE;
        //    IF NOT Found THEN BEGIN
        //        VALIDATE("NS_Job No.", JobNo);
        //        VALIDATE("NS_Job Task No.", JobTaskNo);
        //        "NS_Line No." := 100;
        //        INSERT;
        //        Found := TRUE;
        //    END;

        //    "NS_Status Date" := StatusDate;
        //    "NS_Percent Complete" := TotalPct;
        //    "NS_Bill Date" := BillDate;
        //    "NS_Bill Percent" := BillPct;

        //    MODIFY;
        //END;
        //ProjectPro - end
    END;
    //PRJ-419 comment end

    PROCEDURE NS_POsRecdAndOtstndngByExptRcptDate(JobNo: Code[20]; JobTask: Code[20]; ThroughDate: Date) Total: Decimal;
    VAR
        PurchaseLine: Record 39;
        ItemLedgEntry: Record 32;
        PeriodPurchase: Decimal;
        MonthStartDate: Date;
        MonthEndDate: Date;
    BEGIN
        //ProjectPro - start

        //POs Received and Outstanding by Expected Receipt Date
        //
        //Reviews Purchase Order Lines for the Job where the Expected Receipt Date is in the same month as the ThroughDate.
        //The amount returned is the value of any received amount this month plus any amount yet to be received for these lines.

        Total := 0;

        IF (JobNo > '') AND (ThroughDate > 0D) THEN BEGIN
            MonthStartDate := DMY2DATE(1, DATE2DMY(ThroughDate, 2), DATE2DMY(ThroughDate, 3));
            IF DATE2DMY(ThroughDate, 2) < 12 THEN
                MonthEndDate := DMY2DATE(1, DATE2DMY(ThroughDate, 2) + 1, DATE2DMY(ThroughDate, 3)) - 1
            ELSE
                MonthEndDate := DMY2DATE(31, 12, DATE2DMY(ThroughDate, 3));

            WITH PurchaseLine DO BEGIN
                RESET;
                SETCURRENTKEY("Job No.");
                SETRANGE("Job No.", JobNo);
                SETRANGE("Job Task No.", JobTask);
                SETFILTER("Expected Receipt Date", '%1..%2', MonthStartDate, MonthEndDate);
                IF FINDSET THEN
                    REPEAT
                        Total := Total + "Outstanding Amount";
                        ItemLedgEntry.RESET;
                        ItemLedgEntry.SETCURRENTKEY("Job No.", "Job Task No.", "Entry Type", "Document Date");
                        ItemLedgEntry.SETRANGE("Job No.", JobNo);
                        ItemLedgEntry.SETRANGE("Job Task No.", JobTask);
                        ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Purchase);
                        ItemLedgEntry.SETFILTER("Document Date", '%1..%2', MonthStartDate, MonthEndDate);
                        IF ItemLedgEntry.FINDSET THEN
                            REPEAT
                                ItemLedgEntry.CALCFIELDS("Cost Amount (Actual)");
                                Total := Total + ItemLedgEntry."Cost Amount (Actual)"
                            UNTIL ItemLedgEntry.NEXT = 0;

                    UNTIL NEXT = 0;
            END;
        END;

        EXIT(Total);
        //ProjectPro - end
    END;

    LOCAL PROCEDURE CalcSalesTax(JobNo: Code[20]; JobTaskNo: Code[20]);
    VAR
        lJobPlanLine: Record 1003;
    BEGIN
        lJobPlanLine.RESET;
        lJobPlanLine.SETRANGE("Job No.", JobNo);
        lJobPlanLine.SETRANGE("Job Task No.", JobTaskNo);
        IF lJobPlanLine.FINDSET(TRUE, FALSE) THEN
            REPEAT
                lJobPlanLine.VALIDATE(Quantity);
            UNTIL lJobPlanLine.NEXT = 0;
    END;

    //SPLN 1.0 Start
    local procedure CreateFakeCustomer() IsFakeCustCreate: Boolean
    begin
        //NS_FakeCust.Get("Job No.") //PRJ-1.0.SK Commented
        IF NS_FakeJob.Get("Job No.") Then; //PRJ-1.0.SK Added
        IF NS_FakeCust.Get("Job No.") Then; //PRJ-1.0.SK Added
        NS_BillToCustNo := NS_FakeJob."Bill-to Customer No.";

        if NS_FakeCust."Bill-to Customer No." = '' then begin
            NS_FakeCust."Bill-to Customer No." := '1';
            NS_FakeJob.Modify();
        end;

        if not NS_FakeCust.Get(NS_FakeJob."Bill-to Customer No.") then begin
            NS_FakeCust."Bill-to Customer No." := NS_FakeJob."Bill-to Customer No.";
            NS_FakeCust.Insert();
            exit(true);
        end;

        exit(false);

    end;

    local procedure DeleteFakeCustomer(IsFakeCustCreated: Boolean)
    begin
        NS_FakeJob."Bill-to Customer No." := NS_BillToCustNo;
        NS_FakeJob.Modify();

        if IsFakeCustCreated then begin
            NS_FakeCust.Delete();
        end;
    end;
    //SPLN 1.0 End

    var
        Text14021100: Label 'Unknown';
        NS_JobForecast: Record "NS_Job Forecast";
        QuoteMgt: Codeunit "NS_Job Quote Mgt.";
        NS_FakeJob: Record job;
        NS_FakeCust: Record Customer;
        NS_BillToCustNo: code[20];
        NS_IsFakeCustomer: boolean;
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021100 Percent Complete
//   +     14021101 Estimated Hours
//   +     14021102 Total Hours Applied
//   +     14021103 Percent Materials
//   +     14021104 Invoice Due Date
//   +     14021120 Burden Percent
//   +     14021140 Total Percent Complete
//   +     14021141 Total Percent Complete Date
//   +     14021142 Billing Percent
//   +     14021143 Billing Percent Date
//   +     14021190 Task Before
//   +     14021191 Task After
//   +     14021192 Task Start Date
//   +     14021193 Task End Date
//   +     14021194 Task Lag Days
//   +     14021195 Task Days
//   +     14021196 Resource No.
//   +     14021197 Start Date Fixed
//   +     14021198 Manager
//   +     14021400 Quote No.
//   +     14021401 Mark-up
//   +     14021402 Gross Profit %
//   +     14021403 Gross Profit
//   +     14021404 Quantity Weighted
//   +     14021405 Cost Weighted
//   +     14021408 Line Amount Incl. Tax
//   +     14021409 Template No.
//   +
//   +  - Added function(s):
//   +     PP_GetJobTaskDescription
//   +     PP_GetDefaultAPOBurdenPercent
//   +     PP_GetTaskBurdenPercent
//   +     PP_UpdateForecastWorksheet
//   +     PP_POsRecdAndOtstndngByExptRcptDate
//   +     CalcSalesTax
//   +
//   +  - Added global variable(s):
//   +      QuoteMgt
//   +      PP_JobForecast
//   +
//   +  - Added global text constant(s):
//   +     Text14021100
//   +
//   +  - Modification(s):
//   +     - Field Groups -
//   +         Original: Job Task No.,Description,Job Task Type
//   +         Modified: Job No.,Job Task No.,Description,Job Task Type
//   +     - OnInsert: - Remove code for Bill-to Customer No.
//   +                 - Added setting of
//   +                     Burden Percent
//   +                     Quote No.
//   +                 - Added call to PP_UpdateForecastWorksheet
//   +     - On Modify: - Added call to PP_UpdateForecastWorksheet
//   +     - Fields
//   +       - Job Task No. - OnValidate() - Remove code for Bill-to Customer No.
//   +     - Procedures set for global access
//   +         JobLedgEntriesExist
//   +         JobPlanningLinesExist
//   +-----------------------------------------------------------------------------------------------