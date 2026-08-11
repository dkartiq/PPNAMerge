report 14021206 "NS_Suggest Job Jnl. Lines"
{
    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Added field(s):
    // +
    // +
    // +  - Added function(s):
    // +
    // +
    // +  - Added global variable(s):
    // +
    // +
    // +  - Modification(s):
    // +     - OnPostReport: populate Unit Cost, Document No. and Payroll Burden Amount
    // +------------------------------------------------------------

    Caption = 'Suggest Job Jnl. Lines';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(NS_Options)
                {
                    Caption = 'Options';
                    field(NS_StartingDate; StartingDate)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Starting Date';
                        ToolTip = 'Specifies the date from which the report or batch job processes information.';
                    }
                    field(NS_EndingDate; EndingDate)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Ending Date';
                        ToolTip = 'Specifies the date to which the report or batch job processes information.';
                    }
                    field(NS_ResourceNoFilter; ResourceNoFilter)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Resource No. Filter';
                        TableRelation = Resource;
                        ToolTip = 'Specifies the resource number that the batch job will suggest job lines for.';
                    }
                    field(NS_JobNoFilter; JobNoFilter)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job No. Filter';
                        TableRelation = Job;
                        ToolTip = 'Specifies a filter for the job numbers that will be included in the report.';
                    }
                    field(NS_JobTaskNoFilter; JobTaskNoFilter)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job Task No. Filter';
                        ToolTip = 'Specifies a filter for the job task numbers that will be included in the report.';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            JobTask: Record "Job Task";
                        begin
                            JobTask.FILTERGROUP(2);
                            IF JobNoFilter <> '' THEN
                                JobTask.SETFILTER("Job No.", JobNoFilter);
                            JobTask.FILTERGROUP(0);
                            IF PAGE.RUNMODAL(PAGE::"Job Task List", JobTask) = ACTION::LookupOK THEN
                                JobTask.TESTFIELD("Job Task Type", JobTask."Job Task Type"::Posting);
                            JobTaskNoFilter := JobTask."Job Task No.";
                        end;
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

    trigger OnPostReport()
    var
        NoSeriesMgt: Codeunit 396;
        TimeSheetMgt: Codeunit "Time Sheet Management";
        NextDocNo: Code[20];
        LineNo: Integer;
        QtyToPost: Decimal;
        Resource: Record Resource;
    begin
        DateFilter := TimeSheetMgt.GetDateFilter(StartingDate, EndingDate);
        FillTimeSheetLineBuffer;

        IF TempTimeSheetLine.FINDSET THEN BEGIN
            JobJnlLine.LOCKTABLE;
            JobJnlTemplate.GET(JobJnlLine."Journal Template Name");
            JobJnlBatch.GET(JobJnlLine."Journal Template Name", JobJnlLine."Journal Batch Name");
            IF JobJnlBatch."No. Series" = '' THEN
                NextDocNo := ''
            ELSE
                NextDocNo := NoSeriesMgt.GetNextNo(JobJnlBatch."No. Series", TempTimeSheetLine."Time Sheet Starting Date", FALSE);

            JobJnlLine.SETRANGE("Journal Template Name", JobJnlLine."Journal Template Name");
            JobJnlLine.SETRANGE("Journal Batch Name", JobJnlLine."Journal Batch Name");
            IF JobJnlLine.FINDLAST THEN;
            LineNo := JobJnlLine."Line No.";

            REPEAT
                TimeSheetHeader.GET(TempTimeSheetLine."Time Sheet No.");
                TimeSheetDetail.SETRANGE("Time Sheet No.", TempTimeSheetLine."Time Sheet No.");
                TimeSheetDetail.SETRANGE("Time Sheet Line No.", TempTimeSheetLine."Line No.");
                IF DateFilter <> '' THEN
                    TimeSheetDetail.SETFILTER(Date, DateFilter);
                TimeSheetDetail.SETFILTER(Quantity, '<>0');
                TimeSheetDetail.SETRANGE(Posted, FALSE);
                IF TimeSheetDetail.FINDSET THEN
                    REPEAT
                        QtyToPost := TimeSheetDetail.GetMaxQtyToPost;
                        IF QtyToPost <> 0 THEN BEGIN
                            JobJnlLine.INIT;
                            LineNo := LineNo + 10000;
                            JobJnlLine."Line No." := LineNo;
                            JobJnlLine."Time Sheet No." := TimeSheetDetail."Time Sheet No.";
                            JobJnlLine."Time Sheet Line No." := TimeSheetDetail."Time Sheet Line No.";
                            JobJnlLine."Time Sheet Date" := TimeSheetDetail.Date;
                            JobJnlLine.VALIDATE("Job No.", TimeSheetDetail."Job No.");
                            JobJnlLine."Source Code" := JobJnlTemplate."Source Code";
                            IF TimeSheetDetail."Job Task No." <> '' THEN
                                JobJnlLine.VALIDATE("Job Task No.", TimeSheetDetail."Job Task No.");
                            JobJnlLine.VALIDATE(Type, JobJnlLine.Type::Resource);
                            JobJnlLine.VALIDATE("No.", TimeSheetHeader."Resource No.");
                            IF TempTimeSheetLine."Work Type Code" <> '' THEN
                                JobJnlLine.VALIDATE("Work Type Code", TempTimeSheetLine."Work Type Code");
                            JobJnlLine.VALIDATE("Posting Date", TimeSheetDetail.Date);
                            JobJnlLine."Document No." := NextDocNo;
                            NextDocNo := INCSTR(NextDocNo);
                            JobJnlLine."Posting No. Series" := JobJnlBatch."Posting No. Series";
                            JobJnlLine.Description := TempTimeSheetLine.Description;
                            JobJnlLine.VALIDATE(Quantity, QtyToPost);
                            JobJnlLine.VALIDATE(Chargeable, TempTimeSheetLine.Chargeable);
                            JobJnlLine."Reason Code" := JobJnlBatch."Reason Code";
                            OnAfterTransferTimeSheetDetailToJobJnlLine(JobJnlLine, JobJnlTemplate, TempTimeSheetLine, TimeSheetDetail);
                            //ProjectPro - start
                            JobJnlLine.VALIDATE("Unit Cost", TimeSheetDetail."NS_Wage Rate to Post");
                            JobJnlLine."Document No." := TimeSheetDetail."Time Sheet No.";
                            JobJnlLine."NS_Payroll Burden Amount" := TimeSheetDetail."NS_Burden Amount to Post";
                            IF TimeSheetDetail."Resource No." <> '' THEN BEGIN
                                Resource.GET(TimeSheetDetail."Resource No.");
                                JobJnlLine."NS_Job Cost Category" := Resource."NS_Job Cost Category";
                            END;
                            //ProjectPro - end
                            JobJnlLine.INSERT;
                        END;
                    UNTIL TimeSheetDetail.NEXT = 0;
            UNTIL TempTimeSheetLine.NEXT = 0;
        END;
    end;

    var
        JobJnlLine: Record "Job Journal Line";
        JobJnlBatch: Record "Job Journal Batch";
        JobJnlTemplate: Record "Job Journal Template";
        TimeSheetHeader: Record "Time Sheet Header";
        TimeSheetLine: Record "Time Sheet Line";
        TempTimeSheetLine: Record "Time Sheet Line" temporary;
        TimeSheetDetail: Record "Time Sheet Detail";
        ResourceNoFilter: Code[1024];
        JobNoFilter: Code[1024];
        JobTaskNoFilter: Code[1024];
        StartingDate: Date;
        EndingDate: Date;
        DateFilter: Text[30];

    [Scope('Cloud')]
    procedure SetJobJnlLine(NewJobJnlLine: Record "Job Journal Line")
    begin
        JobJnlLine := NewJobJnlLine;
    end;

    [Scope('Cloud')]
    procedure InitParameters(NewJobJnlLine: Record "Job Journal Line"; NewResourceNoFilter: Code[1024]; NewJobNoFilter: Code[1024]; NewJobTaskNoFilter: Code[1024]; NewStartingDate: Date; NewEndingDate: Date)
    begin
        JobJnlLine := NewJobJnlLine;
        ResourceNoFilter := NewResourceNoFilter;
        JobNoFilter := NewJobNoFilter;
        JobTaskNoFilter := NewJobTaskNoFilter;
        StartingDate := NewStartingDate;
        EndingDate := NewEndingDate;
    end;

    local procedure FillTimeSheetLineBuffer()
    var
        SkipLine: Boolean;
    begin
        IF ResourceNoFilter <> '' THEN
            TimeSheetHeader.SETFILTER("Resource No.", ResourceNoFilter);
        IF DateFilter <> '' THEN BEGIN
            TimeSheetHeader.SETFILTER("Starting Date", DateFilter);
            TimeSheetHeader.SETFILTER("Starting Date", '..%1', TimeSheetHeader.GETRANGEMAX("Starting Date"));
            TimeSheetHeader.SETFILTER("Ending Date", DateFilter);
            TimeSheetHeader.SETFILTER("Ending Date", '%1..', TimeSheetHeader.GETRANGEMIN("Ending Date"));
        END;

        IF TimeSheetHeader.FINDSET THEN
            REPEAT
                TimeSheetLine.SETRANGE("Time Sheet No.", TimeSheetHeader."No.");
                TimeSheetLine.SETRANGE(Type, TimeSheetLine.Type::Job);
                TimeSheetLine.SETRANGE(Status, TimeSheetLine.Status::Approved);
                IF JobNoFilter <> '' THEN
                    TimeSheetLine.SETFILTER("Job No.", JobNoFilter);
                IF JobTaskNoFilter <> '' THEN
                    TimeSheetLine.SETFILTER("Job Task No.", JobTaskNoFilter);
                TimeSheetLine.SETRANGE(Posted, FALSE);
                IF TimeSheetLine.FINDSET THEN
                    REPEAT
                        TempTimeSheetLine := TimeSheetLine;
                        OnBeforeInsertTempTimeSheetLine(JobJnlLine, TimeSheetHeader, TempTimeSheetLine, SkipLine);
                        IF NOT SkipLine THEN
                            TempTimeSheetLine.INSERT;
                    UNTIL TimeSheetLine.NEXT = 0;
            UNTIL TimeSheetHeader.NEXT = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertTempTimeSheetLine(JobJournalLine: Record "Job Journal Line"; TimeSheetHeader: Record "Time Sheet Header"; var TempTimeSheetLine: Record "Time Sheet Line" temporary; var SkipLine: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterTransferTimeSheetDetailToJobJnlLine(var JobJournalLine: Record "Job Journal Line"; JobJournalTemplate: Record "Job Journal Template"; var TempTimeSheetLine: Record "Time Sheet Line" temporary; TimeSheetDetail: Record "Time Sheet Detail")
    begin
    end;
}

