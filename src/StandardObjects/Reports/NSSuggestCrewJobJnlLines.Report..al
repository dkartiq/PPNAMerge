/// <summary>
/// Report NS_Suggest Crew Job Jnl. Lines (ID 14021379).
/// </summary>
/// //PRJ-841.JS.1.0 16Aug2021 | add code line
/// //PRJ-842.JS.1.0 16Aug2021 |  add code line
///  //PRJCTPR-2.RM.1.0 13Dec2022 | Added some code
report 14021391 "NS_Suggest Crew Job Jnl. Lines"
{
    Caption = 'Suggest Crew Job Jnl. Line';
    ProcessingOnly = true;

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
                group(Options)
                {
                    Caption = 'Options';
                    field(StartingDate; StartingDate)
                    {
                        ApplicationArea = ALL;
                        Caption = 'Starting Date';
                        ToolTip = 'Specifies the date from which the report or batch job processes information.';
                    }
                    field(EndingDate; EndingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Ending Date';
                        ToolTip = 'Specifies the date to which the report or batch job processes information.';
                    }
                    field(ResourceNoFilter; ResourceNoFilter)
                    {
                        ApplicationArea = all;
                        Caption = 'Resource No.';
                        TableRelation = Resource;
                        ToolTip = 'Specifies the resource number that the batch job will suggest job lines for.';
                    }
                    field(CrewNoFilter; CrewNoFilter)
                    {
                        ApplicationArea = all;
                        Caption = 'Crew Code';
                        TableRelation = NS_Crew;
                        ToolTip = 'Specifies a filter for the Crew Code that will be included in the report.';
                    }
                    field(JobNoFilter; JobNoFilter)
                    {
                        ApplicationArea = all;
                        Caption = 'Job No.';
                        TableRelation = Job;
                        ToolTip = 'Specifies a filter for the job numbers that will be included in the report.';
                    }
                    field(JobTaskNoFilter; JobTaskNoFilter)
                    {
                        ApplicationArea = all;
                        Visible = false;
                        Caption = 'Job Task No.';
                        ToolTip = 'Specifies a filter for the job task numbers that will be included in the report.';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            JobTask: Record "Job Task";
                        begin
                            JobTask.FilterGroup(2);
                            if JobNoFilter <> '' then
                                JobTask.SetFilter("Job No.", JobNoFilter);
                            JobTask.FilterGroup(0);
                            if PAGE.RunModal(PAGE::"Job Task List", JobTask) = ACTION::LookupOK then
                                JobTask.TestField("Job Task Type", JobTask."Job Task Type"::Posting);
                            JobTaskNoFilter := JobTask."Job Task No.";
                        end;
                    }
                    //PE-121.PS.1.0 7Jul2023 Start
                    field(NS_DocNo; NS_DocNo)
                    {
                        Caption = 'Document No.';
                        ApplicationArea = All;
                        ToolTip = 'Specify “Document No.” to assign the same on all the Job Journal lines. This field is mandatory to fill in to post the entries.'; //PE-121.PS.2.0 20Jul2023
                    }
                    //PE-121.PS.1.0 7Jul2023 End
                }
            }
        }
        //PE-121.PS.1.0 12Jul2023 Start

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        var
        begin
            if CloseAction = Action::OK then begin  //PE-121.PS.2.0 20Jul2023
                if NS_DocNo = '' then
                    Error('Document No. should not be Blank');
            end;
        end;

        //PE-121.PS.1.0 12Jul2023 End 

    }

    labels
    {
    }

    trigger OnPostReport()
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        TimeSheetMgt: Codeunit "Time Sheet Management";
        NextDocNo: Code[20];
        LineNo: Integer;
        QtyToPost: Decimal;
    begin
        DateFilter := TimeSheetMgt.GetDateFilter(StartingDate, EndingDate);
        NS_FillTimeSheetLineBuffer();

        if TempTimeSheetLine.FindSet() then begin
            JobJnlLine.LockTable();
            JobJnlTemplate.Get(JobJnlLine."Journal Template Name");
            JobJnlBatch.Get(JobJnlLine."Journal Template Name", JobJnlLine."Journal Batch Name");
            if JobJnlBatch."No. Series" = '' then
                NextDocNo := ''
            else
                NextDocNo := NoSeriesMgt.GetNextNo(JobJnlBatch."No. Series", TempTimeSheetLine."Time Sheet Starting Date", false);

            JobJnlLine.SetRange("Journal Template Name", JobJnlLine."Journal Template Name");
            JobJnlLine.SetRange("Journal Batch Name", JobJnlLine."Journal Batch Name");
            if JobJnlLine.FindLast then;
            LineNo := JobJnlLine."Line No.";

            repeat
                TimeSheetHeader.Get(TempTimeSheetLine."Time Sheet No.");
                TimeSheetDetail.SetRange("Time Sheet No.", TempTimeSheetLine."Time Sheet No.");
                TimeSheetDetail.SetRange("Time Sheet Line No.", TempTimeSheetLine."Line No.");
                if DateFilter <> '' then
                    TimeSheetDetail.SetFilter(Date, DateFilter);
                TimeSheetDetail.SetFilter(Quantity, '<>0');
                TimeSheetDetail.SetRange(Posted, false);
                if CrewNoFilter <> '' then
                    TimeSheetDetail.SetRange("NS_Crew Code", CrewNoFilter);
                if TimeSheetDetail.FindSet() then
                    repeat
                        QtyToPost := TimeSheetDetail.GetMaxQtyToPost();
                        if QtyToPost <> 0 then begin
                            JobJnlLine.Init();
                            LineNo := LineNo + 10000;
                            JobJnlLine."Line No." := LineNo;
                            JobJnlLine."Time Sheet No." := TimeSheetDetail."Time Sheet No.";
                            JobJnlLine."Time Sheet Line No." := TimeSheetDetail."Time Sheet Line No.";
                            JobJnlLine."Time Sheet Date" := TimeSheetDetail.Date;
                            JobJnlLine.Validate("Job No.", TimeSheetDetail."Job No.");
                            JobJnlLine."Source Code" := JobJnlTemplate."Source Code";
                            if TimeSheetDetail."Job Task No." <> '' then
                                JobJnlLine.Validate("Job Task No.", TimeSheetDetail."Job Task No.");
                            JobJnlLine.Validate(Type, JobJnlLine.Type::Resource);
                            JobJnlLine.Validate("No.", TimeSheetDetail."Resource No.");   //PRJ-772.JS.1.0 21JULY2021
                            if TempTimeSheetLine."Work Type Code" <> '' then
                                JobJnlLine.Validate("Work Type Code", TempTimeSheetLine."Work Type Code");
                            JobJnlLine.Validate("Posting Date", TimeSheetDetail.Date);
                            JobJnlLine."Document No." := NextDocNo;
                            NextDocNo := IncStr(NextDocNo);
                            JobJnlLine."Posting No. Series" := JobJnlBatch."Posting No. Series";
                            JobJnlLine.Description := TempTimeSheetLine.Description;
                            JobJnlLine."NS_Crew Code" := TimeSheetDetail."NS_Crew Code";
                            JobJnlLine."NS_Crew Time Sheet Ref. No." := TempTimeSheetLine."NS_Ref Customize TimesheetNo.";
                            JobJnlLine."NS_Crew Time Sheet Line" := TimeSheetDetail."NS_CrewTimeSheetLine";
                            JobJnlLine.Validate(Quantity, QtyToPost);
                            JobJnlLine.Validate(Chargeable, TempTimeSheetLine.Chargeable);
                            JobJnlLine."NS_Crew Time Unique Line ID" := TempTimeSheetLine."NS_Crew Time Unique Line ID"; //PRJ-772.JS.1.0 26JULY2021
                            JobJnlLine."NS_Segment Code" := TempTimeSheetLine."NS_Segment Code";  //PRJ-842.JS.1.0 16Aug2021
                            JobJnlLine."NS_Union Code" := TempTimeSheetLine."NS_Union Code"; //PRJCTPR-2.RM.1.0 13Dec2022
                            JobJnlLine.Description := TempTimeSheetLine."NS_Resource Name New"; //PE-121.PS.1.0 12Jul2023 
                            //PE-68 Dk.1.0 10April2023 Start
                            //JobJnlLine."NS_Skill Code" := TempTimeSheetLine."NS_Skill Code";  //PRJ-841.JS.1.0 16Aug2021 
                            JobJnlLine."NS_Skill Code New" := TempTimeSheetLine."NS_Skill Code New";
                            //PE-68 Dk.1.0 10April2023 End
                            JobJnlLine."Time Sheet No." := TimeSheetDetail."Time Sheet No.";            //PRJ-772.JS.1.0 28JULY2021
                            JobJnlLine."Work Type Code" := TimeSheetDetail."NS_Work Type Code";         //PRJ-772.JS.1.0 28JULY2021
                            JobJnlLine."NS_Crew Time Sheet Date" := TimeSheetDetail."NS_Crew Time Sheet Date";    //PRJ-772.JS.1.0 28JULY2021
                            JobJnlLine."Reason Code" := JobJnlBatch."Reason Code";
                            //PE-68 Dk.1.0 10April2023 Start
                            //JobJnlLine.Validate("NS_Skill Class", TempTimeSheetLine."NS_Skill Code");   //PRJ-1315.JS.1.0 18APR2022  
                            JobJnlLine.Validate("NS_Skill Class New", TempTimeSheetLine."NS_Skill Code New");
                            //PE-68 Dk.1.0 10April2023 End                                                                              
                            //NS_OnAfterTransferTimeSheetDetailToJobJnlLine(JobJnlLine, JobJnlTemplate, TempTimeSheetLine, TimeSheetDetail, JobJnlBatch);
                            //PE-121.PS.1.0 06Jul2023 start
                            if NS_DocNo <> '' then
                                JobJnlLine."Document No." := NS_DocNo;
                            //PE-121.PS.1.0 06Jul2023 End
                            JobJnlLine.Insert();
                        end;
                    until TimeSheetDetail.Next() = 0;
            //NS_OnOnPostReportOnTempTimeSheetLineEndLoop(JobJnlLine, NextDocNo, LineNo);
            until TempTimeSheetLine.Next() = 0;
        end;
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
        CrewNoFilter: code[20];
        NS_DocNo: Code[20];//PE-121.PS.1.0 

    procedure NS_etJobJnlLine(NewJobJnlLine: Record "Job Journal Line")
    begin
        JobJnlLine := NewJobJnlLine;
    end;

    procedure NS_InitParameters(NewJobJnlLine: Record "Job Journal Line"; NewResourceNoFilter: Code[1024]; NewJobNoFilter: Code[1024]; NewJobTaskNoFilter: Code[1024]; NewStartingDate: Date; NewEndingDate: Date)
    begin
        JobJnlLine := NewJobJnlLine;
        ResourceNoFilter := NewResourceNoFilter;
        JobNoFilter := NewJobNoFilter;
        JobTaskNoFilter := NewJobTaskNoFilter;
        StartingDate := NewStartingDate;
        EndingDate := NewEndingDate;
    end;

    local procedure NS_FillTimeSheetLineBuffer()
    var
        SkipLine: Boolean;
    begin
        if ResourceNoFilter <> '' then
            TimeSheetHeader.SetFilter("Resource No.", ResourceNoFilter);
        if CrewNoFilter <> '' then
            TimeSheetHeader.SetFilter("NS_Crew code", CrewNoFilter);
        if DateFilter <> '' then begin
            TimeSheetHeader.SetFilter("Starting Date", DateFilter);
            TimeSheetHeader.SetFilter("Starting Date", '..%1', TimeSheetHeader.GetRangeMax("Starting Date"));
            TimeSheetHeader.SetFilter("Ending Date", DateFilter);
            TimeSheetHeader.SetFilter("Ending Date", '%1..', TimeSheetHeader.GetRangeMin("Ending Date"));
        end;

        if TimeSheetHeader.FindSet() then
            repeat
                //TimeSheetDetail.SetRange("Time Sheet No.",);
                //TimeSheetDetail.SetRange();
                TimeSheetLine.SetRange("Time Sheet No.", TimeSheetHeader."No.");
                TimeSheetLine.SetRange(Type, TimeSheetLine.Type::Job);
                TimeSheetLine.SetRange(Status, TimeSheetLine.Status::Approved);
                if JobNoFilter <> '' then
                    TimeSheetLine.SetFilter("Job No.", JobNoFilter);
                if JobTaskNoFilter <> '' then
                    TimeSheetLine.SetFilter("Job Task No.", JobTaskNoFilter);
                TimeSheetLine.SetRange(Posted, false);
                if ResourceNoFilter <> '' then
                    TimeSheetLine.SetRange("NS_Resource No.", ResourceNoFilter);
                if TimeSheetLine.FindSet() then
                    repeat
                        TempTimeSheetLine := TimeSheetLine;
                        //NS_OnBeforeInsertTempTimeSheetLine(JobJnlLine, TimeSheetHeader, TempTimeSheetLine, SkipLine);
                        if not SkipLine then
                            TempTimeSheetLine.Insert();
                    until TimeSheetLine.Next() = 0;
            until TimeSheetHeader.Next() = 0;
    end;
}

