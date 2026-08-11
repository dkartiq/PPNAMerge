report 14021329 "NS_Get Billing Forecast"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    Caption = 'Get Billing Forecast';
    ProcessingOnly = true;

    dataset
    {
        dataitem(ProgressBillingLine; "NS_Progress Billing Line")
        {
            DataItemTableView = SORTING("NS_Progress Billing No.", "NS_Requisition No.", "NS_Version No.", "NS_Job No.", "NS_Revenue Category", "NS_Job Task No.") ORDER(Ascending);

            trigger OnAfterGetRecord();
            begin
                JobForecast.RESET();
                JobForecast.SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Bill Date");
                JobForecast.SETRANGE("NS_Job No.", JobNo);
                JobForecast.SETRANGE("NS_Job Task No.", "NS_Job Task No.");
                JobForecast.SETRANGE(NS_Posted, true);
                PostingDateFrom := DMY2DATE(1, DATE2DMY(JobForecastPostingDate, 2), DATE2DMY(JobForecastPostingDate, 3));
                if DATE2DMY(JobForecastPostingDate, 2) < 12 then
                    PostingDateTo := CALCDATE('-1D', DMY2DATE(1, DATE2DMY(JobForecastPostingDate, 2) + 1, DATE2DMY(JobForecastPostingDate, 3)))
                else
                    //PostingDateTo := DMY2DATE(12,31,DATE2DMY(JobForecastPostingDate,3));
                    PostingDateTo := DMY2DATE(31, 12, DATE2DMY(JobForecastPostingDate, 3));
                JobForecast.SETFILTER("NS_Bill Date", '%1..%2', PostingDateFrom, PostingDateTo);
                if JobForecast.FINDSET() then begin
                    repeat
                        if JobForecast."NS_Bill Percent" <> 0 then begin
                            "NS_Billing Method" := "NS_Billing Method"::"%";
                            VALIDATE(NS_Quantity, JobForecast."NS_Bill Percent");
                        end;
                    until JobForecast.NEXT() = 0;
                    MODIFY;
                end;
            end;

            trigger OnPreDataItem();
            begin
                RESET;
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
                group(Control1100773001)
                {
                    field(JobForecastPostingDate; JobForecastPostingDate)
                    {
                        Caption = 'Job Forecast Posting Date';
                        ApplicationArea = All;
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
        No: Code[20];
        RequisitionNo: Integer;
        VersionNo: Integer;
        Text001: Label 'Progress Billing No %1 does not exist.';
        JobNo: Code[20];
        JobForecastPostingDate: Date;
        PostingDateFrom: Date;
        PostingDateTo: Date;

    procedure SetParameters(NoIn: Code[20]; RequisitionNoIn: Integer; VersionNoIn: Integer; JobNoIn: Code[20]);
    begin
        No := NoIn;
        RequisitionNo := RequisitionNoIn;
        VersionNo := VersionNoIn;
        JobNo := JobNoIn;
    end;
}

