report 14021351 "NS_Suggest Billing Task Lines"
{
    //PRJ-820.JS.1.0 02Aug2021
    //PRJ-878.JS.1.0 19Aug2021 | correct date filter caption

    Caption = 'Suggest Billing By Task';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(ProgressBillingLine; "NS_Progress Billing Line")
        {
            DataItemTableView = SORTING("NS_Progress Billing No.", "NS_Requisition No.", "NS_Version No.", "NS_Job No.", "NS_Revenue Category", "NS_Job Task No.") ORDER(Ascending);

            trigger OnAfterGetRecord();
            begin
                TotalActualCost := 0;
                TotalBudgtCost := 0;
                TotalInvoicedAmt := 0;
                PercentBudgVsActual := 0;
                PercetProgresBilling := 0;
                Clear(PostingDateFrom);
                clear(PostingDateTo);

                PostingDateFrom := 20010101D;

                if DATE2DMY(JobForecastPostingDate, 2) < 12 then
                    PostingDateTo := CALCDATE('-1D', DMY2DATE(1, DATE2DMY(JobForecastPostingDate, 2) + 1, DATE2DMY(JobForecastPostingDate, 3)))
                else
                    PostingDateTo := DMY2DATE(31, 12, DATE2DMY(JobForecastPostingDate, 3));

                APOLinkLine1.Reset();
                APOLinkLine1.SetRange(NS_Code, ProgressBillingLine."NS_Job No.");
                APOLinkLine1.SetRange("NS_Rev. Dest. Task Code", ProgressBillingLine."NS_Job Task No.");
                IF APOLinkLine1.FindSet() then
                    repeat
                        JobTaskLine.Reset();
                        JobTaskLine.SetRange("Job No.", APOLinkLine1.NS_Code);
                        JobTaskLine.SetRange("Job Task No.", APOLinkLine1."NS_Rev. Dest. Task Code");
                        IF JobTaskLine.FindFirst() then begin
                            TotalBillingAmt := 0;
                            TotalInvoicedAmt := 0;
                            JobTaskLine.CalcFields("Contract (Total Price)", "Contract (Invoiced Price)");
                            TotalBillingAmt := JobTaskLine."Contract (Total Price)";
                        end;

                        JobTaskLine2.Reset();
                        JobTaskLine2.SetRange("Job No.", APOLinkLine1.NS_Code);
                        JobTaskLine2.SetRange("Job Task No.", APOLinkLine1."NS_Cost Source Task Code");
                        IF JobTaskLine2.FindFirst() then
                            IF APOLinkLine1."NS_Source Category" = '' then begin
                                JobTaskLine2.CalcFields("Schedule (Total Cost)", "Usage (Total Cost)");
                                TotalBudgtCost += JobTaskLine2."Schedule (Total Cost)";
                            end else begin
                                JobPlanningLine.Reset();
                                JobPlanningLine.SetRange("Job No.", JobTaskLine2."Job No.");
                                JobPlanningLine.SetRange("Job Task No.", JobTaskLine2."Job Task No.");
                                JobPlanningLine.SetRange("NS_Cost Category", APOLinkLine1."NS_Source Category");
                                IF JobPlanningLine.FindSet() then begin
                                    JobPlanningLine.CalcSums("Total Cost");
                                    TotalBudgtCost := JobPlanningLine."Total Cost";
                                end;
                            end;

                        // JobTaskLine2.Reset();
                        // JobTaskLine2.SetRange("Job No.", APOLinkLine1.NS_Code);
                        // JobTaskLine2.SetRange("Job Task No.", APOLinkLine1."NS_Cost Source Task Code");
                        // IF JobTaskLine2.FindFirst() then begin
                        //     JobTaskLine2.CalcFields("Schedule (Total Cost)", "Usage (Total Cost)");
                        //     TotalBudgtCost += JobTaskLine2."Schedule (Total Cost)";
                        // end;



                        // JobLedgerEntry.Reset();
                        // JobLedgerEntry.SetRange("Job No.", ProgressBillingLine."NS_Job No.");
                        // JobLedgerEntry.SetRange("Job Task No.", APOLinkLine1."NS_Cost Source Task Code");
                        // JobLedgerEntry.SetRange("Entry Type", JobLedgerEntry."Entry Type"::Usage);
                        // JobLedgerEntry.SETFILTER("Posting Date", '%1..%2', PostingDateFrom, PostingDateTo);
                        // IF JobLedgerEntry.FindFirst() then
                        //     repeat
                        //         TotalActualCost += JobLedgerEntry."Total Cost";
                        //     until JobLedgerEntry.Next() = 0;

                        JobLedgerEntry.Reset();
                        JobLedgerEntry.SetRange("Job No.", ProgressBillingLine."NS_Job No.");
                        JobLedgerEntry.SetRange("Job Task No.", APOLinkLine1."NS_Cost Source Task Code");
                        JobLedgerEntry.SetRange("Entry Type", JobLedgerEntry."Entry Type"::Usage);
                        JobLedgerEntry.SETFILTER("Posting Date", '%1..%2', PostingDateFrom, PostingDateTo);
                        //PRJ-878.JS.1.0 19Aug2021 -Start
                        IF APOLinkLine1."NS_Source Category" <> '' then
                            JobLedgerEntry.SetRange("NS_Job Cost Category", APOLinkLine1."NS_Source Category");
                        //PRJ-878.JS.1.0 19Aug2021 -end    
                        IF JobLedgerEntry.FindSet() then begin
                            JobLedgerEntry.CalcSums("Total Cost");
                            TotalActualCost += JobLedgerEntry."Total Cost";
                        end;
                    until APOLinkLine1.Next() = 0;
                IF TotalBudgtCost > 0 then
                    PercentBudgVsActual := Round(((TotalActualCost * 100) / TotalBudgtCost), 0.01, '=');  //PRJ-878.JS.1.0 19Aug2021
                validate(ProgressBillingLine.NS_Quantity, PercentBudgVsActual);
                ProgressBillingLine.Modify();
            end;

            trigger OnPreDataItem();
            begin
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
            area(content)
            {
                group(PostingDateFilter)
                {
                    field(JobForecastPostingDate; JobForecastPostingDate)
                    {
                        Caption = 'As on Date';    //PRJ-878.JS.1.0 19Aug2021 old caption Billing Posting Date
                        ApplicationArea = All;
                        ToolTip = 'Define Billing Posting Date';
                    }
                }
            }
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
    end;

    var
        JobForecast: Record "NS_Job Forecast";
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        JobPlanningLine: Record "Job Planning Line";   //PRJ-881.JS.1.0 26Aug2021
        No: Code[20];
        RequisitionNo: Integer;
        VersionNo: Integer;
        Text001: Label 'Progress Billing No %1 does not exist.';
        JobNo: Code[20];
        JobForecastPostingDate: Date;
        PostingDateFrom: Date;
        PostingDateTo: Date;
        APOLinkLine1: Record "NS_APO Links Line";
        APOLinkLine2: Record "NS_APO Links Line";
        JobTaskLine: Record "Job Task";
        JobTaskLine2: Record "Job Task";
        JobLedgerEntry: Record "Job Ledger Entry";
        TotalBillingAmt: Decimal;
        TotalBudgtCost: Decimal;
        TotalActualCost: Decimal;
        TotalInvoicedAmt: Decimal;
        PercentBudgVsActual: Decimal;
        PercetProgresBilling: Decimal;




    procedure SetParameters(NoIn: Code[20]; RequisitionNoIn: Integer; VersionNoIn: Integer; JobNoIn: Code[20]);
    begin
        No := NoIn;
        RequisitionNo := RequisitionNoIn;
        VersionNo := VersionNoIn;
        JobNo := JobNoIn;
    end;
}

