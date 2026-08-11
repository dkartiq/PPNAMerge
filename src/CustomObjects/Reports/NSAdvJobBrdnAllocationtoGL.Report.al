report 14021193 "NS_AdvJobBrdnAllocationtoG/L"
{
    //CTSI-254.AS.1.0 25MARCH2021 New report by saving as report 14021167 Allocate Job Burden to G/L

    Permissions = TableData "Job Ledger Entry" = rimd, Tabledata "No. Series Line" = rimd;
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    Caption = 'Advanced Job Burden Allocation to G/L';
    dataset
    {

        dataitem("Job Ledger Entry";
        "Job Ledger Entry")
        {
            DataItemTableView = sorting("Job No.") ORDER(Ascending) WHERE("NS_Burden Amount" = FILTER(<> 0), "NS_Burden Amount Posted to G/L" = CONST(0));
            RequestFilterFields = "Job No.", "Posting Date";

            trigger OnAfterGetRecord();
            begin
                Clear(BurdenAmtTotal);
                i := 0;
                if JobsSetup.Get() then;


                if JobNum <> "Job Ledger Entry"."Job No." then begin
                    ProgressWindow.OPEN('Processing for Job number #1#######');
                    Flag := true;
                    // NumSeriesRec.reset;
                    // NumSeriesRec.setrange("Series Code", NoSeriescode);
                    // IF NumSeriesRec.find('-') then begin
                    //     if NumSeriesRec."Last No. Used" <> '' then
                    //         DocumentNo := incstr(NumSeriesRec."last no. used")
                    //     else
                    //         DocumentNo := NumSeriesRec."Starting No.";

                    //     NumSeriesRec."last no. used" := DocumentNo;
                    //     NumSeriesRec.modify;
                    // end;
                    DocumentNo := NoSeriescode;

                    if job.get("Job Ledger Entry"."Job No.") then;

                    if JobPostingGrp.get(Job."Job Posting Group") then;

                    JobTaskLine.Reset();
                    JobTaskLine.SetRange("Job No.", job."No.");
                    JobTaskLine.SetRange("Job Task No.", JobsSetup."NS_Default Job Task No.");
                    if not JobTaskLine.FindFirst() then
                        Error('Default Job Task No. %1 from jobs setup does not exist within Job No. %2', JobsSetup."NS_Default Job Task No.", job."No.");

                    JLERec.Reset();
                    JLERec.SetCurrentKey("Job No.");
                    JLERec.SetRange("Job No.", "Job Ledger Entry"."Job No.");
                    JLERec.SetFilter("NS_Burden Amount", '<>%1', 0);
                    JLERec.SetFilter("NS_Burden Amount Posted to G/L", '%1', 0);
                    if PDFilter <> '' then
                        JLERec.SetFilter("Posting Date", PDFilter);
                    if JLERec.FindSet() then begin
                        repeat
                            JLERec."NS_Burden Export" := true;
                            BurdenAmtTotal += JLERec."NS_Burden Amount";
                            JLERec.MODIFY;
                        until JLERec.Next() = 0;
                    end;
                    if (JobsSetup."NS_Mandatory Dimension" <> '') and (JobsSetup."NS_Mandatory Dimension Value" <> '') then begin
                        DefDim.Reset();
                        DefDim.SetRange("Table ID", 167);
                        DefDim.SetRange("No.", job."No.");
                        DefDim.SetRange("Dimension Code", JobsSetup."NS_Mandatory Dimension");
                        DefDim.SetRange("Dimension Value Code", JobsSetup."NS_Mandatory Dimension Value");
                        if not DefDim.FindFirst() then begin
                            DefDim.Init();
                            DefDim.validate("Table ID", 167);
                            DefDim.validate("No.", job."No.");
                            DefDim.validate("Dimension Code", JobsSetup."NS_Mandatory Dimension");
                            DefDim.validate("Dimension Value Code", JobsSetup."NS_Mandatory Dimension Value");
                            defdim.Insert();

                        end;

                    end;

                    with GenJnlLine do begin
                        INIT;
                        "Journal Template Name" := JobsSetup."NS_Burden G/L Journal Template";
                        "Journal Batch Name" := JobsSetup."NS_Burden G/L Journal Batch";
                        LineNum += 10000;
                        GenJnlLine."Line No." := LineNum;
                        "Posting Date" := PostingDate;
                        "Document No." := DocumentNo;
                        //"Burden Job No." := "Job Ledger Entry"."Job No.";S
                        if DocumentDescription <> '' then
                            Description := DocumentDescription;
                        "Account Type" := "Account Type"::"G/L Account";
                        "Account No." := JobPostingGrp."NS_Allocated Job Burden";
                        "Bal. Account Type" := "Account Type"::"G/L Account";
                        "Bal. Account No." := JobPostingGrp."NS_Job Burden Off-Set";
                        VALIDATE(Amount, BurdenAmtTotal);
                        Validate("Job No.", "Job Ledger Entry"."Job No.");
                        "Job Task No." := JobsSetup."NS_Default Job Task No.";
                        "Job Quantity" := -1;

                        "System-Created Entry" := true;
                        //"Bal. Ledger No." := Job."Global Dimension 2 Code";
                        Insert(true);
                        SLEEP(1000);
                        ProgressWindow.UPDATE(1, job."No.");
                        DefDim.Reset();
                        DefDim.SetRange("Table ID", 167);
                        DefDim.SetRange("No.", job."No.");
                        DefDim.SetRange("Dimension Code", JobsSetup."NS_Mandatory Dimension");
                        DefDim.SetRange("Dimension Value Code", JobsSetup."NS_Mandatory Dimension Value");
                        if DefDim.FindFirst() then begin
                            DefDim.DeleteAll();
                        end;
                    end;
                    if JobsSetup."NS_Auto Post Burden to G/L" = true then begin
                        GenJnlLine.RESET();
                        GenJnlLine.SETRANGE("Journal Template Name", JobsSetup."NS_Burden G/L Journal Template");
                        GenJnlLine.SETRANGE("Journal Batch Name", JobsSetup."NS_Burden G/L Journal Batch");
                        if not GenJnlLine.ISEMPTY() then begin
                            GenJnlPostLine.RUN(GenJnlLine);

                            GenJnlLine.DeleteAll();
                        end;
                        Commit();
                        if Jobsetup."NS_Advanced Burden Allocation" = true then begin
                            if Jobsetup."NS_Burden G/L Journal Batch" <> '' then begin
                                if (Jobsetup."NS_Burden G/L Journal Batch" = "Journal Batch Name") then begin
                                    JLE.Reset();
                                    JLE.SetCurrentKey("Job No.");
                                    JLE.SetRange("Job No.", "Job Ledger Entry"."Job No.");
                                    if PDFilter <> '' then
                                        JLE.SetFilter("Posting Date", PDFilter);
                                    JLE.SetFilter("NS_Burden Amount", '<>%1', 0);
                                    JLE.SetFilter("NS_Burden Amount Posted to G/L", '%1', 0);
                                    JLE.SetRange("NS_Burden Export", true);
                                    if JLE.FindSet() then
                                        repeat
                                            JLE."NS_Burden Amount Posted to G/L" := JLE."NS_Burden Amount";
                                            JLE."NS_Burden Posting Document No." := DocumentNo;
                                            JLE."NS_Burden Export" := false;
                                            JLE.MODIFY;
                                        until JLE.Next() = 0;
                                end;
                            end;
                        end;
                    end;
                end;
                JobNum := "Job Ledger Entry"."Job No.";
            end;

            trigger OnPreDataItem();
            begin

                PDFilter := "Job Ledger Entry".getfilter("Posting Date");
                Clear(JobNum);
            end;

            trigger OnPostDataItem();
            begin
                if Flag then
                    ProgressWindow.CLOSE;
            end;
        }

    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(content)
            {
                field(PostingDate; PostingDate)
                {
                    Caption = 'Posting Date';
                    NotBlank = true;
                    ApplicationArea = All;
                }
                field(NoSeriescode; NoSeriescode)//CTSI-254.AS.1.0 25MARCH2021
                {
                    Caption = 'Burden Document No.';
                    NotBlank = true;
                    ApplicationArea = All;
                    //TableRelation = "No. Series".Code;
                }
                field(Description; DocumentDescription)
                {
                    Caption = 'Description';
                    NotBlank = true;
                    ApplicationArea = All;
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

    trigger OnInitReport();
    begin
        PostingDate := WORKDATE;
        DocumentDescription := DefaultDescription;
    end;

    trigger OnPreReport();
    begin

        JobsSetup.Get();

        if JobsSetup."NS_Advanced Burden Allocation" = false
        then
            Error('Please enable "Advanced Burden Allocation" setup on Jobs Setup, to use this batch.');

        //CTSI-254.AM.1.0 - START
        if UserSetup.Get(UserId) then
            if NOT UserSetup."NS_Access to Job Burden Allocation Batch" then
                Error('You are not authorized to run this Batch.');
        //CTSI-254.AM.1.0 - END

        if (JobsSetup."NS_Burden G/L Journal Template" = '') or (JobsSetup."NS_Burden G/L Journal Batch" = '') then
            Error('You must define the G/L Journal Template and Batch on Job setup');


        GenJnlLine.RESET();
        GenJnlLine.SETRANGE("Journal Template Name", JobsSetup."NS_Burden G/L Journal Template");
        GenJnlLine.SETRANGE("Journal Batch Name", JobsSetup."NS_Burden G/L Journal Batch");
        if GenJnlLine.FindFirst() then
            Error('The general journal batch "%1" must be blank.', JobsSetup."NS_Burden G/L Journal Batch");

        if PostingDate = 0D then
            ERROR(Text002);
        if NoSeriescode = '' then
            ERROR(Text003);
    end;

    trigger OnPostReport()
    begin
        JobsSetup.Get();
        if (JobsSetup."NS_Auto Post Burden to G/L" = true) and (Flag = true) then
            Message('Job Burden has been posted to G/L');

        if (JobsSetup."NS_Auto Post Burden to G/L" = false) and (Flag = true) then
            Message('Job Burden details are updated on G/L Journal Batch %1', JobsSetup."NS_Burden G/L Journal Batch");//CTSI-254.AM
        if Flag = false then
            Message('There are no burden entries created/posted within applied filters');
    end;

    var
        i: Integer;
        Text001: Label 'The Burden Alloc Dimension in Jobs Setup must be one of the Shortcut dimensions.\\The system is not setup for other dimensions.';
        Text002: Label 'A Posting Date must be entered.';
        Text003: Label 'No. Series code must be entered.';
        NoSeriescode: code[20];
        NumSeriesRec: Record "No. Series Line";
        Text004: Label 'A Document Description must be entered.';
        Text005: Label 'Job %1 does not have a valid %2 of %3.';
        GenJnlLine: Record "Gen. Journal Line";
        JobsSetup: Record "Jobs Setup";
        GLSetup: Record "General Ledger Setup";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        PostingDate: Date;
        DocumentNo: Code[20];
        LineNum: Integer;
        JLE: Record "Job Ledger Entry";
        JLERec: Record "Job Ledger Entry";
        BurdenAmtTotal: Decimal;
        JobPostingGrp: Record "Job Posting Group";
        DocumentDescription: Text[50];
        DefaultDescription: Label 'Burden Allocation';
        NoSeriesMgt: Codeunit NoSeriesManagement;
        JobNum: code[20];
        Job: Record Job;
        JobRec: Record Job;
        PDFilter: Text;
        UserSetup: Record "User Setup";
        DefDim: Record "Default Dimension";
        JobTaskLine: Record "Job Task";
        ProgressWindow: Dialog;
        Flag: Boolean;
        Jobsetup: Record "Jobs Setup";
}

