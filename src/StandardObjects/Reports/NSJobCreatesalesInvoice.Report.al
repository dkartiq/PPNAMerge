report 14021226 NS_JobCreateSalesInvoice
{

    //PRJ-153.SK.1.0 Added evetns and code
    ApplicationArea = Jobs;
    Caption = 'Job Create Sales Invoice';//PE-141.NK.1.0 03Aug2023 updated name
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Job Task"; "Job Task")
        {
            DataItemTableView = SORTING("Job No.", "Job Task No.");
            RequestFilterFields = "Job Task No.", "Planning Date Filter";

            trigger OnAfterGetRecord()
            var
                IsHandled: Boolean;
            begin
                IsHandled := false;
                OnBeforeJobTaskOnAfterGetRecord("Job Task", IsHandled);
                if not IsHandled then
                    JobCreateInvoice.CreateSalesInvoiceJobTask(
                      "Job Task", PostingDate, InvoicePerTask, NoOfInvoices, OldJobNo, OldJTNo, false);
            end;

            trigger OnPostDataItem()
            begin
                JobCreateInvoice.CreateSalesInvoiceJobTask(
                  "Job Task", PostingDate, InvoicePerTask, NoOfInvoices, OldJobNo, OldJTNo, true);
            end;

            trigger OnPreDataItem()
            begin
                NoOfInvoices := 0;
                OldJobNo := '';
                OldJTNo := '';
                //PRJ-153.SK.1.0 Start
                OnBeforeOnPreDataItemReport(JobNo);
                IF JobNo <> '' then
                    SetRange("Job No.", JobNo);
                //PRJ-153.SK.1.0 End
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(NS_Options)
                {
                    Caption = 'Options';
                    field(NS_PostingDate; PostingDate)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Posting Date';
                        ToolTip = 'Specifies the posting date for the document.';
                    }
                    field(NS_JobChoice; JobChoice)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Create Invoice per';
                        OptionCaption = 'Job,Job Task';
                        ToolTip = 'Specifies, if you select the Job Task option, that you want to create one invoice per job task rather than the one invoice per job that is created by default.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            PostingDate := WorkDate;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        OnBeforePostReport;

        JobCalcBatches.EndCreateInvoice(NoOfInvoices);

        OnAfterPostReport(NoOfInvoices);
    end;

    trigger OnPreReport()
    begin
        JobCalcBatches.BatchError(PostingDate, Text000Lbl);
        InvoicePerTask := JobChoice = JobChoice::"Job Task";
        JobCreateInvoice.DeleteSalesInvoiceBuffer;

        OnAfterPreReport;
    end;

    var
        JobCreateInvoice: Codeunit "Job Create-Invoice";
        JobCalcBatches: Codeunit "Job Calculate Batches";
        PostingDate: Date;
        NoOfInvoices: Integer;
        InvoicePerTask: Boolean;
        JobChoice: Option Job,"Job Task";
        OldJobNo: Code[20];
        OldJTNo: Code[20];
        Text000Lbl: Label 'A', Comment = 'A';
        //PRJ-153.SK.1.0 Start
        JobNo: Code[20];
    //PRJ-153.SK.1.0 End

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostReport(NoOfInvoices: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPreReport()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeJobTaskOnAfterGetRecord(JobTask: Record "Job Task"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostReport()
    begin
    end;

    //PRJ-153.SK.1.0 Start
    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnPreDataItemReport(VAR JobNo: Code[20])
    begin
    end;
    //PRJ-153.SK.1.0 End
}

