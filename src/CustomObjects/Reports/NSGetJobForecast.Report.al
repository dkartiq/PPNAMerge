report 14021331 "NS_Get Job Forecast"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    Caption = 'Get Job Forecast';
    ProcessingOnly = true;

    dataset
    {
        dataitem(JobLedgerEntry; "Job Ledger Entry")
        {
            RequestFilterFields = "Posting Date";

            trigger OnAfterGetRecord();
            var
                Category: Code[10];
            begin
                with JobLedgEntryWork do begin

                    JobLedgEntryWork := JobLedgerEntry;
                    Category := '';
                    APOLinksHeader.NS_Translate("Job No.", 0, "NS_Activity Code", "NS_Process Code", "NS_Operation Code", Category);
                    if "NS_Activity Code" > '' then
                        "Job Task No." := COPYSTR(Job.APOToJobTaskNo("NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code"), 1, 20)//PRJ-688.AM.1.0
                    else
                        "Job Task No." := '';

                    ProgressBillingLineTemp.RESET();
                    ProgressBillingLineTemp.SETCURRENTKEY("NS_Progress Billing No.", "NS_Requisition No.", "NS_Version No.", "NS_Job No.", "NS_Revenue Category", "NS_Job Task No.");
                    ProgressBillingLineTemp.SETRANGE("NS_Progress Billing No.", No);
                    ProgressBillingLineTemp.SETRANGE("NS_Requisition No.", RequisitionNo);
                    ProgressBillingLineTemp.SETRANGE("NS_Version No.", VersionNo);
                    ProgressBillingLineTemp.SETRANGE("NS_Job No.", JobNo);
                    ProgressBillingLineTemp.SETRANGE("NS_Revenue Category", Category);
                    ProgressBillingLineTemp.SETRANGE("NS_Job Task No.", "Job Task No.");
                    if ProgressBillingLineTemp.FINDSET(true) then begin
                        ProgressBillingLineTemp.NS_Quantity := ProgressBillingLineTemp.NS_Quantity + Quantity;
                        ProgressBillingLineTemp.NS_Total := ProgressBillingLineTemp.NS_Total + "Line Amount (LCY)";
                        ProgressBillingLineTemp."NS_Job Ledger Entry TotalPrice" := ProgressBillingLineTemp."NS_Job Ledger Entry TotalPrice" + "Total Price (LCY)";
                        ProgressBillingLineTemp."NS_Job Ledger Entry Total Cost" := ProgressBillingLineTemp."NS_Job Ledger Entry Total Cost" + "Total Cost (LCY)";
                        ProgressBillingLineTemp.MODIFY();
                    end else begin
                        ProgressBillingLineTemp.INIT();
                        ProgressBillingLineTemp."NS_Progress Billing No." := No;
                        ProgressBillingLineTemp."NS_Requisition No." := RequisitionNo;
                        ProgressBillingLineTemp."NS_Version No." := VersionNo;
                        LastLineNo := LastLineNo + 10000;
                        ProgressBillingLineTemp."NS_Line No." := LastLineNo;
                        ProgressBillingLineTemp."NS_Job No." := JobNo;
                        ProgressBillingLineTemp."NS_Revenue Category" := Category;
                        ProgressBillingLineTemp."NS_Job Task No." := "Job Task No.";
                        ProgressBillingLineTemp.NS_Quantity := Quantity;
                        ProgressBillingLineTemp.NS_Total := "Line Amount (LCY)";
                        ProgressBillingLineTemp."NS_Job Ledger Entry TotalPrice" := "Total Price (LCY)";
                        ProgressBillingLineTemp."NS_Job Ledger Entry Total Cost" := "Total Cost (LCY)";
                        ProgressBillingLineTemp.INSERT();
                    end;

                end;
            end;

            trigger OnPreDataItem();
            begin
                LastLineNo := 0;

                RESET();
                SETCURRENTKEY("Job No.", "Job Task No.", "Entry Type", "Posting Date");
                SETRANGE("Job No.", JobNo);
            end;
        }
        dataitem(JobTask; "Job Task")
        {

            trigger OnAfterGetRecord();
            var
                ActivityCode: Code[10];
                ProcessCode: Code[10];
                OperationCode: Code[10];
                SectionCode: Code[10];//PRJ-688.AM.1.0
                Category: Code[10];
                TranslatedJobTaskNo: Code[35];
            begin
                //Translate the Job Task APO and Cost Category into a revenue APO and revenue category

                //Get Budget's Cost Category from first line of Job Planning Line
                JobPlanningLine.RESET();
                JobPlanningLine.SETRANGE("Job No.", JobNo);
                JobPlanningLine.SETRANGE("Job Task No.", "Job Task No.");
                JobPlanningLine.SETRANGE("Line Type", JobPlanningLine."Line Type"::Budget);
                if JobPlanningLine.FINDFIRST() then
                    Category := JobPlanningLine."NS_Cost Category"
                else
                    Category := '';
                Job.NS_JobTaskNoToAPO("Job Task No.", ActivityCode, ProcessCode, OperationCode, SectionCode);//PRJ-688.AM.1.0
                APOLinksHeader.NS_Translate("Job No.", 0, ActivityCode, ProcessCode, OperationCode, Category);
                TranslatedJobTaskNo := Job.APOToJobTaskNo(ActivityCode, ProcessCode, OperationCode, SectionCode);//PRJ-688.AM.1.0

                //Get the matching ProgessBillingLineTemp record and add in the "Schedule (Total Cost)" to the TaskBudget
                CALCFIELDS("Schedule (Total Cost)");
                ProgressBillingLineTemp.RESET();
                ProgressBillingLineTemp.SETCURRENTKEY("NS_Progress Billing No.", "NS_Requisition No.", "NS_Version No.", "NS_Job No.", "NS_Revenue Category", "NS_Job Task No.");
                ProgressBillingLineTemp.SETRANGE("NS_Progress Billing No.", No);
                ProgressBillingLineTemp.SETRANGE("NS_Requisition No.", RequisitionNo);
                ProgressBillingLineTemp.SETRANGE("NS_Version No.", VersionNo);
                ProgressBillingLineTemp.SETRANGE("NS_Job No.", JobNo);
                ProgressBillingLineTemp.SETRANGE("NS_Revenue Category", Category);
                ProgressBillingLineTemp.SETRANGE("NS_Job Task No.", TranslatedJobTaskNo);
                if ProgressBillingLineTemp.FINDSET(true) then begin
                    ProgressBillingLineTemp."NS_Task Budget" := ProgressBillingLineTemp."NS_Task Budget" + "Schedule (Total Cost)";
                    ProgressBillingLineTemp."NS_Utilized Cost" := ProgressBillingLineTemp."NS_Utilized Cost" + ("Schedule (Total Cost)" * ("NS_Billing Percent" / 100));
                    ProgressBillingLineTemp.MODIFY();
                end;
            end;

            trigger OnPreDataItem();
            begin
                RESET();
                SETRANGE("Job No.", JobNo);
                SETRANGE("Job Task Type", "Job Task Type"::Posting);
                SETFILTER("Schedule (Total Cost)", '>0');
            end;
        }
        dataitem(JobTaskPrice; "Job Task")
        {

            trigger OnAfterGetRecord();
            var
                Category: Code[10];
            begin
                //Get the matching ProgessBillingLineTemp record and add in the "Schedule (Total Cost)" to the TaskBudget

                //Get Budget's Revenue Category from first line of Job Planning Line
                JobPlanningLine.RESET();
                JobPlanningLine.SETRANGE("Job No.", JobNo);
                JobPlanningLine.SETRANGE("Job Task No.", "Job Task No.");
                JobPlanningLine.SETRANGE("Line Type", JobPlanningLine."Line Type"::Billable);
                if JobPlanningLine.FINDFIRST() then
                    Category := JobPlanningLine."NS_Revenue Category"
                else
                    Category := '';

                CALCFIELDS("Contract (Total Price)");
                ProgressBillingLineTemp.RESET();
                ProgressBillingLineTemp.SETCURRENTKEY("NS_Progress Billing No.", "NS_Requisition No.", "NS_Version No.", "NS_Job No.", "NS_Revenue Category", "NS_Job Task No.");
                ProgressBillingLineTemp.SETRANGE("NS_Progress Billing No.", No);
                ProgressBillingLineTemp.SETRANGE("NS_Requisition No.", RequisitionNo);
                ProgressBillingLineTemp.SETRANGE("NS_Version No.", VersionNo);
                ProgressBillingLineTemp.SETRANGE("NS_Job No.", JobNo);
                ProgressBillingLineTemp.SETRANGE("NS_Revenue Category", Category);
                ProgressBillingLineTemp.SETRANGE("NS_Job Task No.", "Job Task No.");
                if ProgressBillingLineTemp.FINDSET(true) then begin
                    ProgressBillingLineTemp."NS_Finished Contract Price" := "Contract (Total Price)";
                    ProgressBillingLineTemp.MODIFY();
                end;
            end;

            trigger OnPreDataItem();
            begin
                RESET();
                SETRANGE("Job No.", JobNo);
                SETRANGE("Job Task Type", "Job Task Type"::Posting);
                SETFILTER("Contract (Total Price)", '>0');
            end;
        }
        dataitem(JobForecast; "NS_Job Forecast")
        {
            DataItemTableView = SORTING("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date") ORDER(Ascending);

            trigger OnAfterGetRecord();
            var
                ForecastLastTaskLine: Record "NS_Job Forecast";
                ActivityCode: Code[10];
                ProcessCode: Code[10];
                OperationCode: Code[10];
                SectionCode: Code[10];//PRJ-688.AM.1.0
                Category: Code[10];
            begin
                //There will only be updates to temp records that already exist.  All the necessary records should be created at this point, otherwise ignore it.

                with JobForecastWork do begin
                    JobForecastWork := JobForecast;

                    //Make sure we are working with the last history line for this record
                    ForecastLastTaskLine.RESET();
                    ForecastLastTaskLine.SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date");
                    ForecastLastTaskLine.SETRANGE("NS_Job No.", JobNo);
                    ForecastLastTaskLine.SETRANGE("NS_Job Task No.", "NS_Job Task No.");
                    ForecastLastTaskLine.SETRANGE(NS_Posted, true);
                    JobLedgEntry.COPYFILTER("Posting Date", "NS_Status Date");
                    ForecastLastTaskLine.FINDLAST();
                    if "NS_Line No." = ForecastLastTaskLine."NS_Line No." then begin
                        Category := '';
                        Job.NS_JobTaskNoToAPO("NS_Job Task No.", ActivityCode, ProcessCode, OperationCode, SectionCode);//PRJ-688.AM.1.0
                        APOLinksHeader.NS_Translate("NS_Job No.", 0, ActivityCode, ProcessCode, OperationCode, Category);
                        if ActivityCode > '' then
                            "NS_Job Task No." := COPYSTR(Job.APOToJobTaskNo(ActivityCode, ProcessCode, OperationCode, SectionCode), 1, 20)//PRJ-688.AM.1.0
                        else
                            "NS_Job Task No." := '';

                        ProgressBillingLineTemp.RESET();
                        ProgressBillingLineTemp.SETCURRENTKEY("NS_Progress Billing No.", "NS_Requisition No.", "NS_Version No.", "NS_Job No.", "NS_Revenue Category", "NS_Job Task No.");
                        ProgressBillingLineTemp.SETRANGE("NS_Progress Billing No.", No);
                        ProgressBillingLineTemp.SETRANGE("NS_Requisition No.", RequisitionNo);
                        ProgressBillingLineTemp.SETRANGE("NS_Version No.", VersionNo);
                        ProgressBillingLineTemp.SETRANGE("NS_Job No.", JobNo);
                        ProgressBillingLineTemp.SETRANGE("NS_Revenue Category", Category);
                        ProgressBillingLineTemp.SETRANGE("NS_Job Task No.", "NS_Job Task No.");
                        if ProgressBillingLineTemp.FINDSET(true) then begin
                            //This is using a Cumulative Moving Average
                            ProgressBillingLineTemp."NS_Forecast Worksheet Count" := ProgressBillingLineTemp."NS_Forecast Worksheet Count" + 1;
                            ProgressBillingLineTemp."NS_Average Percent Complete" := ProgressBillingLineTemp."NS_Average Percent Complete" +
                              (("NS_Percent Complete" - ProgressBillingLineTemp."NS_Average Percent Complete") / ProgressBillingLineTemp."NS_Forecast Worksheet Count");
                            ProgressBillingLineTemp."NS_Forecasted Completed Cost" := ProgressBillingLineTemp."NS_Forecasted Completed Cost" + "NS_Forecasted Completed Cost";
                            ProgressBillingLineTemp.MODIFY();
                        end;
                    end;
                end;
            end;

            trigger OnPreDataItem();
            begin
                RESET;
                SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date");
                SETRANGE("NS_Job No.", JobNo);
                SETRANGE(NS_Posted, true);
                JobLedgEntry.COPYFILTER("Posting Date", "NS_Status Date")
            end;
        }
        dataitem(ProgressBillingLineModify; "NS_Progress Billing Line")
        {
            DataItemTableView = SORTING("NS_Progress Billing No.", "NS_Requisition No.", "NS_Version No.", "NS_Job No.", "NS_Revenue Category", "NS_Job Task No.") ORDER(Ascending);

            trigger OnAfterGetRecord();
            begin
                ProgressBillingLineTemp.RESET();
                ProgressBillingLineTemp.SETCURRENTKEY("NS_Progress Billing No.", "NS_Requisition No.", "NS_Version No.", "NS_Job No.", "NS_Revenue Category", "NS_Job Task No.");
                ProgressBillingLineTemp.SETRANGE("NS_Progress Billing No.", "NS_Progress Billing No.");
                ProgressBillingLineTemp.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
                ProgressBillingLineTemp.SETRANGE("NS_Version No.", "NS_Version No.");
                ProgressBillingLineTemp.SETRANGE("NS_Job No.", "NS_Job No.");
                ProgressBillingLineTemp.SETRANGE("NS_Revenue Category", "NS_Revenue Category");
                ProgressBillingLineTemp.SETRANGE("NS_Job Task No.", "NS_Job Task No.");
                if ProgressBillingLineTemp.FINDSET() then begin
                    //Use values from Job Forecast Worksheet if possible, otherwise use the accumulation from the Job Ledger Entries
                    Job.GET("NS_Job No.");
                    if ProgressBillingLineTemp."NS_Forecast Worksheet Count" > 0 then begin

                        if Job."NS_Forecast Type" = Job."NS_Forecast Type"::"% of Budget" then begin
                            if ProgressBillingLineTemp."NS_Task Budget" <> 0 then
                                RatioCompleted := ROUND(ProgressBillingLineTemp."NS_Utilized Cost" / ProgressBillingLineTemp."NS_Task Budget", 0.0001)
                            else
                                RatioCompleted := 0;
                            NS_Total := ROUND(ProgressBillingLineTemp."NS_Finished Contract Price" * RatioCompleted, GLSetup."Appln. Rounding Precision");
                        end else
                            NS_Total := ROUND("NS_Base Amount" * (ProgressBillingLineTemp."NS_Average Percent Complete" / 100), GLSetup."Appln. Rounding Precision");

                    end else begin

                        if ProgressBillingLineTemp."NS_Job Ledger Entry Total Cost" <> 0 then
                            RatioCompleted := ROUND(ProgressBillingLineTemp.NS_Total / ProgressBillingLineTemp."NS_Job Ledger Entry Total Cost", 0.01)
                        else
                            RatioCompleted := 0;
                        NS_Total := ROUND(ProgressBillingLineTemp."NS_Job Ledger Entry TotalPrice" * RatioCompleted, GLSetup."Appln. Rounding Precision");

                    end;
                    "NS_Billing Method" := "NS_Billing Method"::"%";
                    NS_Quantity := (NS_Total / "NS_Base Amount") * 100;
                    MODIFY();
                end;
            end;

            trigger OnPreDataItem();
            begin
                //This area will update matching Progress Bill lines with new values calculated

                RESET();
                SETCURRENTKEY("NS_Progress Billing No.", "NS_Requisition No.", "NS_Version No.", "NS_Job No.", "NS_Revenue Category", "NS_Job Task No.");
                SETRANGE("NS_Progress Billing No.", No);
                SETRANGE("NS_Requisition No.", RequisitionNo);
                SETRANGE("NS_Version No.", VersionNo);
                SETRANGE("NS_Job No.", JobNo);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        if not ProgressBillingHeader.GET(No, RequisitionNo, VersionNo) then
            ERROR(Text001, No);

        GLSetup.GET();
        JobSetup.GET();
    end;

    var
        JobSetup: Record "Jobs Setup";
        JobLedgEntry: Record "Job Ledger Entry";
        JobLedgEntryWork: Record "Job Ledger Entry";
        JobForecastWork: Record "NS_Job Forecast";
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        ProgressBillingLine: Record "NS_Progress Billing Line";
        ProgressBillingLineTemp: Record "NS_Progress Billing Line" temporary;
        JobPlanningLine: Record "Job Planning Line";
        Job: Record Job;
        GLSetup: Record "General Ledger Setup";
        APOLinksHeader: Record "NS_APO Links Header";
        No: Code[20];
        RequisitionNo: Integer;
        VersionNo: Integer;
        Text001: Label 'Progress Billing No %1 does not exist.';
        JobNo: Code[20];
        RatioCompleted: Decimal;
        LastLineNo: Integer;
        LastItemNo: Code[5];


    procedure SetJobLedgEntry(NoIn: Code[20]; RequisitionNoIn: Integer; VersionNoIn: Integer; JobNoIn: Code[20]);
    begin
        No := NoIn;
        RequisitionNo := RequisitionNoIn;
        VersionNo := VersionNoIn;
        JobNo := JobNoIn;
    end;
}

