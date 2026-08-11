codeunit 14021104 "NS_Job-Post PrepaymentYesNo"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------


    trigger OnRun();
    begin
    end;

    var
        Text000: Label 'Do you want to post a prepayment for job %1?';
        Text001: Label 'Do you want to post a credit memo for job %1?';
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";

    procedure NS_PostPrepmtInvoiceYN(var Job2: Record Job; SalesHeader2: Record "Sales Header"; SalesLine2: Record "Sales Line"; Print: Boolean);
    var
        Job: Record Job;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        JobPostPrepayments: Codeunit "NS_Job-Post Prepayments";
    begin
        Job.COPY(Job2);
        SalesHeader.COPY(SalesHeader2);
        SalesLine.COPY(SalesLine2);

        with Job do begin

            JobPostPrepayments.NS_Invoice(Job, SalesHeader, SalesLine);

            if Print then
                NS_GetReport(SalesHeader, SalesLine, 0);

            COMMIT;
            Job2 := Job;
        end;
    end;

    procedure NS_PostPrepmtCrMemoYN(var Job2: Record Job; SalesHeader2: Record "Sales Header"; SalesLine2: Record "Sales Line"; Print: Boolean);
    var
        Job: Record Job;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        JobPostPrepayments: Codeunit "NS_Job-Post Prepayments";
    begin
        Job.COPY(Job2);
        SalesHeader.COPY(SalesHeader2);
        SalesLine.COPY(SalesLine2);

        with Job do begin
            if not CONFIRM(Text001, false, "No.") then
                exit;

            JobPostPrepayments.NS_CreditMemo(Job, SalesHeader, SalesLine);

            if Print then
                NS_GetReport(SalesHeader, SalesLine, 1);

            COMMIT;
            Job2 := Job;
        end;
    end;

    procedure NS_GetReport(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; DocumentType: Option Invoice,"Credit Memo");
    var
        ReportSelection: Record "Report Selections";
    begin
        with SalesHeader do
            case DocumentType of
                DocumentType::Invoice:
                    begin
                        SalesInvHeader."No." := "Last Prepayment No.";
                        SalesInvHeader.SETRECFILTER;
                        NS_PrintReport(ReportSelection.Usage::"S.Invoice".AsInteger());
                    end;
                DocumentType::"Credit Memo":
                    begin
                        SalesCrMemoHeader."No." := "Last Prepmt. Cr. Memo No.";
                        SalesCrMemoHeader.SETRECFILTER;
                        NS_PrintReport(ReportSelection.Usage::"S.Cr.Memo".AsInteger());
                    end;
            end;
    end;

    local procedure NS_PrintReport(ReportUsage: Integer);
    var
        ReportSelection: Record "Report Selections";
    begin
        ReportSelection.SETRANGE(Usage, ReportUsage);
        ReportSelection.FIND('-');
        repeat
            ReportSelection.TESTFIELD("Report ID");
            case ReportUsage of
                ReportSelection.Usage::"S.Invoice".AsInteger():
                    REPORT.RUN(ReportSelection."Report ID", false, false, SalesInvHeader);
                ReportSelection.Usage::"S.Cr.Memo".AsInteger():
                    REPORT.RUN(ReportSelection."Report ID", false, false, SalesCrMemoHeader);
            end;
        until ReportSelection.NEXT() = 0;
    end;
}

