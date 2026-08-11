report 14021163 NS_GenerateGeneralJournal
{
    //CTSI-274.AM.1.0 Created report to generate General
    //PRJ-830.GK.1.0 20Sep2021 |Added new code.
    //PRJ-983.GK.1.0 14Oct2021 | Comment Code
    //PRJ-1227.JS.1.0 01MAR2022 | Correct code
    //PRJCTPR-215.HS.1.0 31Oct2023 | Add code
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Generate General Journal';
    ProcessingOnly = true;


    dataset
    {
        dataitem(Job; Job)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "NS_Date Filter", "No.", "NS_Gen. Bus. Posting Group New", "Job Posting Group";//PRJ-831.AS.1.0 12OCT2021 Replace Gen Bus Posting with Gen Bus Posting New

            trigger OnPreDataItem()
            var
            begin
                DateVal := Job.GetFilter("NS_Date Filter");
                MaxDate := GetRangeMax("NS_Date Filter");
                //PE-136.JS.1.0 03Aug2023-13MAY2024 Start
                clear(NSRecRecPostingDate);
                clear(NSJobNumber);
                NSJobNumber := job.GetFilter("No.");
                //PE-136.JS.1.0 03Aug2023-13MAY2024 end
                if NSJobSetupNew.get() then begin
                    NSJobSetupNew.Testfield("NS_RevRec Batch No. Series");
                end;

            end;

            trigger OnAfterGetRecord()//Job
            var
            begin
                RevenueRecSummaryTab.Reset();
                //CTSI-286 rollback
                // if CalculateTrueUp then
                //     RevenueRecSummaryTab.SetRange("Entry Type", RevenueRecSummaryTab."Entry Type"::JFW)
                // else
                //     RevenueRecSummaryTab.SetRange("Entry Type", RevenueRecSummaryTab."Entry Type"::Finance);
                //CTSI-286 rollback
                NSJobNumber := Job."No.";   //PE-136.JS.1.0 03Aug2023
                RevenueRecSummaryTab.SetRange("NS_Job No.", Job."No.");
                RevenueRecSummaryTab.SetRange(NS_Voided, false);
                if not CreateOvUdBillings then  //prj-830
                    RevenueRecSummaryTab.SetRange(NS_Posted, false)
                else
                    RevenueRecSummaryTab.SetRange("NS_Over/Under Billings Posted", false); //prj-830
                //RevenueRecSummaryTab.SetRange("True-Up Posted", false);//CTSI-286 rollback
                RevenueRecSummaryTab.SetFilter("NS_Posting Date", DateVal);
                if RevenueRecSummaryTab.FindLast() then begin
                    //PE-136.JS.1.0 04OCT2023 - Start
                    if not CreateOvUdBillings then begin  //PRJ-830                        
                        InsertGnJnLines();
                    end else begin
                        InsertGnJnLinesNew();
                    end;
                    //PRJ-830
                    //PE-136.JS.1.0 04OCT2023 - End     
                end else
                    CurrReport.Skip();
            end;

            trigger OnPostDataItem()
            begin
                //PE-136.JS.1.0 03Aug2023 - Start
                if (NSJobNumber <> '') and (PostingDate <> 0D) then
                    NSCreateReversalEntriesForRevRec(NSJobNumber, PostingDate)
                else
                    if (NSJobNumber = '') and (PostingDate <> 0D) then
                        NSCreateReversalEntriesForRevRecAllJobs(NSJobNumber, PostingDate);
                //PE-136.JS.1.0 03Aug2023 - end
            end;

        }

    }


    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(PostingDate; PostingDate)
                    {
                        Caption = 'Posting Date';
                        NotBlank = true;
                        ApplicationArea = All;
                    }
                    field(DocNo; DocNo)
                    {
                        //PE-271.PS.2.0 04April2024 Start
                        // Caption = 'Document No.'; 
                        Caption = 'Rev Rec Reference No.';
                        Editable = false;
                        //PE-271.PS.2.0 04April2024 End
                        // NotBlank = true;  //PRJCTPR-215.HS.1.0 31Oct2023 commented
                        ApplicationArea = All;
                    }
                    field(DocDescription; DocDescription)
                    {
                        Caption = 'Description';
                        NotBlank = true;
                        ApplicationArea = All;
                    }
                    // field(CalculateTrueUp; CalculateTrueUp)
                    // {
                    //     Caption = 'Calculate True-Up';
                    //     ApplicationArea = all;
                    // }//CTSI-286 rollback
                    field(CreateOvUdBillings; CreateOvUdBillings)
                    {
                        Caption = 'Create Over/Under Billings';
                        ApplicationArea = all;
                        Description = 'PRJ-830.MS.1.0';
                        tooltip = 'Enable this to create Over and Under Billings. If disabled, then the Net Revenue entries will be generated.';  //PE-275.JS.1.0 19MAR2024 line added
                    }
                }
            }
        }


        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
        // PE-271.PS.2.0 5April2024 Start
        trigger OnOpenPage()
        var

        begin
            CreateRevRecReferenceNo();
        end;
        // PE-271.PS.2.0 5April2024 End
    }

    trigger OnPreReport()
    var
        NSJobJournBatches: record "Job Journal Batch";
    begin
        if JobsSetup.Get() then; //PRJCTPR-215.HS.1.0 31Oct2023

        if (JobsSetup."NS_Burden G/L Jour. Temp Rev." = '') or (JobsSetup."NS_Burden G/L Journal Batch Rev." = '') then //PRJ-1546.GK.1.0 08Aug2022\replace template new field
            Error('You must define the Rev. Rec. G/L Journal Template and Batch on Job setup');
        //PRJ-830.GK.1.0 22Sep2021 start|Comment Code
        // if JobsSetup."NS_Default Job Task No. Rev." = '' then
        //     Error('You must define the Rev. Rec. Default Job Task No. on Jobs Setup.');
        //PRJ-830.GK.1.0 22Sep2021 end
        //PRJ-1346.GK.1.0 02May2022 start-comment
        // GenJnlLine.RESET();
        // GenJnlLine.SETRANGE("Journal Template Name", JobsSetup."NS_Burden G/L Journal Template Rev.");
        // GenJnlLine.SETRANGE("Journal Batch Name", JobsSetup."NS_Burden G/L Journal Batch Rev.");
        // if GenJnlLine.FindFirst() then
        //     Error('The general journal batch "%1" must be blank.', JobsSetup."NS_Burden G/L Journal Batch Rev.");
        //PRJ-1346.GK.1.0 02May2022 end

        // //PRJCTPR-215.HS.1.0 31Oct2023 Start
        NS_GenJnlBatch.Reset();
        NS_GenJnlBatch.SetRange(Name, JobsSetup."NS_Burden G/L Journal Batch Rev.");
        if NS_GenJnlBatch.FindFirst() then begin
            if NSNoSeries.Get(NS_GenJnlBatch."No. Series") then
                if not NSNoSeries."Default Nos." then
                    Error('It is not possible to assign numbers automatically. If you want the program to assign numbers automatically, please activate Default Nos. in No. Series=%1.', NSNoSeries.Code);
            if (NS_GenJnlBatch."No. Series" = '') and (DocNo = '') then
                Error('No. Series must have a value in Gen. Journal Batch: Journal Template Name=%1, Batch Name=%2. It cannot be zero or empty.', JobsSetup."NS_Burden G/L Jour. Temp Rev.", NS_GenJnlBatch.Name);
        end;
        //PRJCTPR-215.HS.1.0 31Oct2023  End

        if PostingDate = 0D then
            ERROR(Text002);
        // if DocNo = '' then    //PRJCTPR-215.HS.1.0 31Oct2023  Commented
        //     ERROR(Text003);   //PRJCTPR-215.HS.1.0 31Oct2023  Commented
    end;
    // PE-271.PS.2.0 5April2024 Start

    procedure CreateRevRecReferenceNo()
    var
        NSJobSetup: Record "Jobs Setup";
    begin

        if NSJobSetup.Get() then;
        Clear(DocNo);
        if NSJobSetup."NS_Rev Rec Reference No." <> '' then
            DocNo := NSNoSeriesMgt.GetNextNo(NSJobSetup."NS_Rev Rec Reference No.", today, true)
        else
            Error('"Rev. Rev. Reference No." on the Jobs/Projects Setup must not be blank.');

    end;
    // PE-271.PS.2.0 5April2024 End

    var
        myInt: Integer;
        Postingdate: Date;
        DocDescription: Text[100];
        DocNo: Code[20];
        Text002: Label 'A Posting Date must be entered.';
        Text003: Label 'Document No. must be entered.';
        JobsSetup: Record "Jobs Setup";
        DefDim: Record "Default Dimension";
        GenJnlLine: Record "Gen. Journal Line";
        LineNum: Integer;
        JobPostingGrp: Record "Job Posting Group";
        RevAmountfinance: Decimal;
        //RevAmountJFW: Decimal; //CTSI-286 rollback
        // RevenueRecSummaryTab: Record RevenueRecSummaryTab;
        DateVal: Text;
        GenJournalLine2: Record "Gen. Journal Line";
        //DiffAmount: Decimal;//CTSI-286 rollback
        //CalculateTrueUp: Boolean; //CTSI-286 rollback
        RevenueRecSummaryTab: Record NS_RevenueRecSummaryTab;
        RevenueRecSummaryTab2: Record NS_RevenueRecSummaryTab;
        RevenueRecSummaryTab3: Record NS_RevenueRecSummaryTab;
        RevenueRecSummaryVoid: Record NS_RevenueRecSummaryTab;
        GenJnlLine4: Record "Gen. Journal Line"; //PRJ-1346.GK.1.0 02May2022
        JobTaskLine: Record "Job Task";
        Flag: Boolean;
        GenJnllineInsert: Boolean;
        MaxDate: Date;
        CreateOvUdBillings: Boolean;//PRJ-830
        jobTable: Record Job;//PRJ-950.AS.1.0

        NSJobNumber: code[30];   //PE-136.JS.1.0 03Aug2023-13MAY2024
        NSRecRecPostingDate: date; //PE-136.JS.1.0 03Aug2023-13MAY2024

        NSRevRecGnlJnlBatchNo: code[20]; //PE-136.JS.1.0 03Aug2023
        NSNoSeriesMgt: codeunit NoSeriesManagement;  //PE-136.JS.1.0 03Aug2023
        NSJobSetupNew: record "Jobs Setup";  //PE-136.JS.1.0 03Aug2023

        //PRJCTPR-215.HS.1.0 31Oct2023 Start
        NS_GenJnlBatch: Record "Gen. Journal Batch";
        NSRevRecDocNo: code[20];
        NSRevRecDocNoseries: code[20];
        NSExterDocNo: Code[20];
        NSNoSeries: record "No. Series";
    //NSNoSeriesMgt: codeunit NoSeriesManagement;
    //PRJCTPR-215.HS.1.0 31Oct2023 End

    trigger OnPostReport()
    var
    begin
        if JobsSetup.Get() then;  //PE-136.JS.1.0 03Aug2023 old statement was JobsSetup.Get() 

        // if CalculateTrueUp and GenJnllineInsert then
        //     Message('General Journal True-Up lines has been created for batch %1.', JobsSetup."Burden G/L Journal Batch Rev.");
        //CTSI-286 rollback

        //if not CalculateTrueUp and GenJnllineInsert then //CTSI-286 rollback
        if GenJnllineInsert then //CTSI-286 
            Message('General Journal Entry has been created for batch %1.', JobsSetup."NS_Burden G/L Journal Batch Rev.");

        if NOT GenJnllineInsert then
            Message('There are no General Journal entries created within applied filters');

    end;

    local procedure GetNextLineNo(GenJnLine: Record "Gen. Journal Line") LineNo: Integer
    var
        Jobsetuprec: Record "Jobs Setup";
    begin
        Jobsetuprec.Get();
        GenJnLine.Reset();
        GenJnLine.SetRange("Journal Template Name", Jobsetuprec."NS_Burden G/L Jour. Temp Rev.");//PRJ-1546.GK.1.0 08Aug2022\replace template new field
        GenJnLine.SetRange("Journal Batch Name", Jobsetuprec."NS_Burden G/L Journal Batch Rev.");
        if GenJnLine.FindLast() then
            LineNo := GenJnLine."Line No." + 10000
        else
            LineNo := 10000;
        exit(LineNo);
    end;

    local procedure InsertGnJnLines()
    var
        revrecsummtable: Record NS_RevenueRecSummaryTab;
        revrecsummtable5: Record NS_RevenueRecSummaryTab;
        revrecsummtable6: Record NS_RevenueRecSummaryTab;
        NS_JobTaskLine: Record "Job Task";
        NS_GenJnlBatchL: record "Gen. Journal Batch"; //PE-271.PS.1.0 08April2024 
    begin

        //PE-271.PS.1.0 08April2024 Start
        Clear(NSRevRecDocNoseries);
        Clear(NSExterDocNo);
        Clear(NSRevRecDocNo);
        NS_GenJnlBatchL.Reset();
        NS_GenJnlBatchl.SetRange(Name, JobsSetup."NS_Burden G/L Journal Batch Rev.");
        if NS_GenJnlBatchL.FindFirst() then begin
            if (NS_GenJnlBatchL."No. Series" <> '') then begin
                NSRevRecDocNo := NSNoSeriesMgt.GetNextNo(NS_GenJnlBatchL."No. Series", Today, true);
                NSRevRecDocNoseries := NSRevRecDocNo;
                NSExterDocNo := DocNo;
            end;
            if (NS_GenJnlBatchL."No. Series" = '') and (DocNo <> '') then begin
                NSRevRecDocNoseries := DocNo;
                NSExterDocNo := DocNo;
            end;
            if (NS_GenJnlBatchL."No. Series" <> '') and (DocNo = '') then begin
                NSRevRecDocNoseries := NSRevRecDocNo;
                NSExterDocNo := NSRevRecDocNo;
            end;
        end;
        ////PE-271.PS.1.0 08April2024 End
        if JobsSetup.Get() then;
        if JobPostingGrp.get(Job."Job Posting Group") then;
        //PRJ-830.GK.1.0 16Sep2021 start
        // JobTaskLine.Reset();
        // JobTaskLine.SetRange("Job No.", job."No.");
        // JobTaskLine.SetRange("Job Task No.", JobsSetup."NS_Default Job Task No. Rev.");
        // if not JobTaskLine.FindFirst() then
        //     Error('Default Job Task No. %1 from jobs setup does not exist within Job No. %2', JobsSetup."NS_Default Job Task No. Rev.", job."No.");
        //PRJ-830.GK.1.0 16Sep2021 end

        if (JobsSetup."NS_Mandatory Dimension Rev." <> '') and (JobsSetup."NS_Mandatory Dimension Value Rev." <> '') then begin
            DefDim.Reset();
            DefDim.SetRange("Table ID", 167);
            DefDim.SetRange("No.", RevenueRecSummaryTab."NS_job No.");
            DefDim.SetRange("Dimension Code", JobsSetup."NS_Mandatory Dimension Rev.");
            DefDim.SetRange("Dimension Value Code", JobsSetup."NS_Mandatory Dimension Value Rev.");
            if not DefDim.FindFirst() then begin
                DefDim.Init();
                DefDim.validate("Table ID", 167);
                DefDim.validate("No.", RevenueRecSummaryTab."NS_job No.");
                DefDim.validate("Dimension Code", JobsSetup."NS_Mandatory Dimension Rev.");
                DefDim.validate("Dimension Value Code", JobsSetup."NS_Mandatory Dimension Value Rev.");
                defdim.Insert();
            end;
        end;

        //Net Revenue Amount Finance
        Clear(RevAmountfinance);
        RevenueRecSummaryTab2.Reset();
        RevenueRecSummaryTab2.SetCurrentKey("NS_Entry No.");
        RevenueRecSummaryTab2.SetRange("NS_Job No.", RevenueRecSummaryTab."NS_job No.");//CTSI-286
        RevenueRecSummaryTab2.SetFilter(NS_Posted, '%1', true);
        //RevenueRecSummaryTab2.SetRange("Entry Type", RevenueRecSummaryTab."Entry Type"::Finance);//CTSI-286 rollback
        RevenueRecSummaryTab2.SetFilter("NS_Net Revenue", '<>%1', 0);
        RevenueRecSummaryTab2.SetRange("NS_Posting Date", 0D, MaxDate);
        if RevenueRecSummaryTab2.FindLast() then begin
            RevAmountfinance := RevenueRecSummaryTab."NS_Net Revenue" - RevenueRecSummaryTab2."NS_Net Revenue";//CTSI-286
            //PRJ-1227.JS.1.0 01MAR2022 - start
            if RevenueRecSummaryTab."NS_POC Method" <> RevenueRecSummaryTab."NS_POC Method"::" " then
                //RevAmountfinance := RevenueRecSummaryTab."NS_Gross Revenue" - RevenueRecSummaryTab2."NS_Net Revenue";  //PRJ-1227.JS.1.0 Line commented
                RevAmountfinance := RevenueRecSummaryTab."NS_Net Revenue";   //PRJ-1227.JS.1.0 Line added

            //PRJ-1227.JS.1.0 01MAR2022 - end    
            RevenueRecSummaryTab."NS_Gen.Doc.No." := DocNo;
            RevenueRecSummaryTab."NS_GenJnl Posted Doc. No." := NSRevRecGnlJnlBatchNo;   //PE-136.JS.1.0 03Aug2023
            RevenueRecSummaryTab."NS_True-Up Value" := RevAmountfinance;//CTSI-286
                                                                        // if CalculateTrueUp then
                                                                        //     RevenueRecSummaryTab2.TrueupDoc := true; //CTSI-286 rollback
            RevenueRecSummaryTab.Modify();

        end else begin //CTSI-286 start
            RevAmountfinance := RevenueRecSummaryTab."NS_Net Revenue";
            RevenueRecSummaryTab."NS_Gen.Doc.No." := DocNo;
            RevenueRecSummaryTab."NS_True-Up Value" := RevAmountfinance;
            RevenueRecSummaryTab."NS_GenJnl Posted Doc. No." := NSRevRecGnlJnlBatchNo;   //PE-136.JS.1.0 03Aug2023
            RevenueRecSummaryTab.Modify();
        end; //CTSI-286 end

        //PRJ-658.AS.1.0 17MAY2021 - START
        revrecsummtable.Reset();
        revrecsummtable.SetCurrentKey("NS_Entry No.");
        revrecsummtable.SetRange("NS_Job No.", RevenueRecSummaryTab."NS_job No.");
        //revrecsummtable.SetRange("Entry Type", revrecsummtable."Entry Type"::Finance); //CTSI-286 rollback
        revrecsummtable.SetRange("NS_Net Revenue", 0);
        revrecsummtable.SetFilter("NS_Posting Date", DateVal);
        if revrecsummtable.FindSet() then
            repeat
                revrecsummtable.NS_CheckBool := true;
                revrecsummtable."NS_Gen.Doc.No." := DocNo;//ms
                revrecsummtable.Modify();
            until revrecsummtable.Next() = 0;

        //PRJ-658.AS.1.0 17MAY2021 - END

        //Net Revenue JFW
        //CTSI-286 rollback
        // if CalculateTrueUp then begin
        //     Clear(RevAmountJFW);
        //     RevenueRecSummaryTab3.Reset();
        //     RevenueRecSummaryTab3.SetCurrentKey("Entry No.");
        //     RevenueRecSummaryTab3.SetRange("Job No.", RevenueRecSummaryTab."job No.");
        //     RevenueRecSummaryTab3.SetRange("Entry Type", RevenueRecSummaryTab."Entry Type"::JFW);
        //     RevenueRecSummaryTab3.SetFilter("Net Revenue", '<>%1', 0);
        //     RevenueRecSummaryTab3.SetFilter("Posting Date", DateVal);
        //     if RevenueRecSummaryTab3.FindLast() then begin
        //         RevAmountJFW := RevenueRecSummaryTab3."Net Revenue";
        //         RevenueRecSummaryTab3."Gen.Doc.No." := DocNo;
        //         RevenueRecSummaryTab3.TrueupDoc := true;
        //         RevenueRecSummaryTab3.Modify();

        //     end;
        // end;
        //CTSI-286 rollback
        //CTSI-286 rollback
        // Clear(DiffAmount);
        // DiffAmount := RevAmountJFW - RevAmountfinance; 

        //PRJ-658.AS.1.0 17MAY2021 - START

        // if DiffAmount = 0 then begin
        //     revrecsummtable5.CopyFilters(RevenueRecSummaryTab3);
        //     if revrecsummtable5.FindFirst() then begin
        //         revrecsummtable5.CheckBool := true;
        //         revrecsummtable5.Modify();
        //     end;
        //     revrecsummtable6.CopyFilters(RevenueRecSummaryTab2);
        //     if revrecsummtable6.findfirst then begin
        //         revrecsummtable6.CheckBool := true;
        //         revrecsummtable6.Modify();
        //     end;

        // end;
        //CTSI-286 rollback
        //PRJ-658.AS.1.0 17MAY2021 - END

        clear(LineNum);
        //PRJ-658.AS.1.0 17MAY2021 - START ADDED TRUE UP CONDITION
        //CTSI-286 rollback
        // if CalculateTrueUp = true then begin
        //     if DiffAmount <> 0 then begin //PRJ-658.AS.1.0 17MAY2021 start Added genjnl line insert code inide this condition
        //         with GenJnlLine do begin
        //             INIT;
        //             "Journal Template Name" := JobsSetup."Burden G/L Journal Template rev.";
        //             "Journal Batch Name" := JobsSetup."Burden G/L Journal Batch Rev.";

        //             GenJnlLine."Line No." := GetNextLineNo(GenJnlLine);
        //             "Posting Date" := PostingDate;
        //             "Document No." := DocNo;
        //             //Message('%1', DocNo);
        //             Description := DocDescription;
        //             "Account Type" := "Account Type"::"G/L Account";
        //             if CalculateTrueUp then begin
        //                 "Account No." := JobPostingGrp."Recognized Sales Account";
        //                 "Bal. Account No." := JobPostingGrp."WIP Invoiced Sales Account";
        //                 Validate(Amount, DiffAmount);
        //             end;
        //             if not CalculateTrueUp then begin
        //                 "Account No." := JobPostingGrp."Recognized Sales Account";
        //                 "Bal. Account No." := JobPostingGrp."WIP Invoiced Sales Account";
        //                 VALIDATE(Amount, RevAmountfinance);
        //             end;
        //             "Bal. Account Type" := "Account Type"::"G/L Account";
        //             Validate("Job No.", RevenueRecSummaryTab."Job No.");
        //             validate("Job Task No.", JobsSetup."Default Job Task No. Rev.");
        //             "Job Quantity" := -1;
        //             "System-Created Entry" := true;
        //             if Insert() then
        //                 GenJnllineInsert := true;


        //             Sleep(1000);

        //             DefDim.Reset();
        //             DefDim.SetRange("Table ID", 167);
        //             DefDim.SetRange("No.", RevenueRecSummaryTab."job No.");
        //             DefDim.SetRange("Dimension Code", JobsSetup."Mandatory Dimension Rev.");
        //             DefDim.SetRange("Dimension Value Code", JobsSetup."Mandatory Dimension Value Rev.");
        //             if DefDim.FindFirst() then begin
        //                 DefDim.DeleteAll();
        //             end;

        //         end;
        //     end;//PRJ-658.AS.1.0 17MAY2021 End Added genjnl line insert code inide this condition
        // end;
        //CTSI-286 rollback
        //PRJ-658.AS.1.0 17MAY2021 - END ADDED TRUE UP CONDITION

        //PRJ-658.AS.1.0 17MAY2021 - START ADDED NOT TRUE UP CONDITION
        //if CalculateTrueUp = false then begin //CTSI-286 rollback
        if RevAmountfinance <> 0 then begin//PRJ-658.AS.1.0 17MAY2021 start Added genjnl line insert code inide this condition
            with GenJnlLine do begin
                //PRJ-1346.GK.1.0 02May2022 start
                GenJnlLine4.Reset();
                GenJnlLine4.SetRange("Journal Template Name", JobsSetup."NS_Burden G/L Jour. Temp Rev.");//PRJ-1546.GK.1.0 08Aug2022\replace template new field
                GenJnlLine4.SetRange("Journal Batch Name", JobsSetup."NS_Burden G/L Journal Batch Rev.");
                GenJnlLine4.SetFilter("Account No.", '%1', '');//PRJ-1516.GK.1.0 21July2022
                GenJnlLine4.SetFilter("Document No.", '<>%1', '');
                if GenJnlLine4.FindFirst() then begin
                    GenJnlLine4.Delete();
                end;
                //PRJ-1346.GK.1.0 02May2022 end
                INIT;
                "Journal Template Name" := JobsSetup."NS_Burden G/L Jour. Temp Rev.";//PRJ-1546.GK.1.0 08Aug2022\replace template new field
                "Journal Batch Name" := JobsSetup."NS_Burden G/L Journal Batch Rev.";

                GenJnlLine."Line No." := GetNextLineNo(GenJnlLine);
                "Posting Date" := PostingDate;
                "Document No." := DocNo;
                //PRJCTPR-215.HS.1.0 31Oct2023 Start
                // GenJnlLine."Document No." := DocNo; // Commented
                GenJnlLine."Document No." := NSRevRecDocNoseries;
                GenJnlLine."External Document No." := NSExterDocNo;
                //PRJCTPR-215.HS.1.0 31Oct2023 End
                //Message('%1', DocNo);
                Description := DocDescription;
                "Account Type" := "Account Type"::"G/L Account";
                //CTSI-286 rollback
                // if CalculateTrueUp then begin
                //     "Account No." := JobPostingGrp."Recognized Sales Account";
                //     "Bal. Account No." := JobPostingGrp."WIP Invoiced Sales Account";
                //     Validate(Amount, DiffAmount);
                // end;
                //CTSI-286 rollback
                //if not CalculateTrueUp then begin //CTSI-286 rollback
                "Account No." := JobPostingGrp."Recognized Sales Account";
                "Bal. Account No." := JobPostingGrp."WIP Invoiced Sales Account";
                VALIDATE(Amount, RevAmountfinance);
                //end; //CTSI-286 rollback
                "Bal. Account Type" := "Account Type"::"G/L Account";
                Validate("Job No.", RevenueRecSummaryTab."NS_Job No.");
                //validate("Job Task No.", JobsSetup."NS_Default Job Task No. Rev."); //PRJ-830.GK.1.0 20Sep2021| Commented Code
                NS_JobTaskLine.Reset();
                NS_JobTaskLine.SetRange("Job No.", RevenueRecSummaryTab."NS_Job No.");
                NS_JobTaskLine.SetRange("Job Task Type", NS_JobTaskLine."Job Task Type"::Posting);
                if NS_JobTaskLine.FindFirst() then
                    Validate("Job Task No.", NS_JobTaskLine."Job Task No.");
                //PRJ-830.GK.1.0 20Sep2021 end
                "Job Quantity" := -1;
                "System-Created Entry" := true;
                GenJnlLine."NS_Rev. Rec. Summary Dtls" := true; //PRJCTPR-330.PS.1.0 07April2024 
                //PRJ-950.AS.1.0 - start
                "Shortcut Dimension 1 Code" := RevenueRecSummaryTab."NS_Global Dimension 1 Code";
                "Shortcut Dimension 2 Code" := RevenueRecSummaryTab."NS_Global Dimension 2 Code";
                "Dimension Set ID" := RevenueRecSummaryTab."NS_Dimension Set ID";//PRJ-1041.AS.1.0
                GenJnlLine."NS_RevRec GenJnl Document No." := NSRevRecGnlJnlBatchNo;   //PE-136.JS.1.0 03Aug2023                                                           //PRJ-950.AS.1.0 - end

                //PRJ-830.GK.1.0 20Sep2021 start
                if Insert() then
                    GenJnllineInsert := true;
                //PRJ-983.GK.1.0 14Oct2021 start |Comment Code
                // //PRJ-921.GK.1.0 21Sep2021 start
                // INIT;
                // "Journal Template Name" := JobsSetup."NS_Burden G/L Journal Template rev.";
                // "Journal Batch Name" := JobsSetup."NS_Burden G/L Journal Batch Rev.";

                // GenJnlLine."Line No." := GetNextLineNo(GenJnlLine);
                // "Posting Date" := PostingDate + 1;
                // "Document No." := IncStr(DocNo);
                // Description := DocDescription;
                // "Account Type" := "Account Type"::"G/L Account";
                // "Account No." := JobPostingGrp."Recognized Sales Account";
                // "Bal. Account No." := JobPostingGrp."WIP Invoiced Sales Account";
                // VALIDATE(Amount, -RevAmountfinance);

                // "Bal. Account Type" := "Account Type"::"G/L Account";
                // Validate("Job No.", RevenueRecSummaryTab."NS_Job No.");

                // //PRJ-950.AS.1.0 - start
                // "Shortcut Dimension 1 Code" := RevenueRecSummaryTab."NS_Global Dimension 1 Code";
                // "Shortcut Dimension 2 Code" := RevenueRecSummaryTab."NS_Global Dimension 2 Code";
                // //PRJ-950.AS.1.0 - end

                // NS_JobTaskLine.Reset();
                // NS_JobTaskLine.SetRange("Job No.", RevenueRecSummaryTab."NS_Job No.");
                // NS_JobTaskLine.SetRange("Job Task Type", NS_JobTaskLine."Job Task Type"::Posting);
                // if NS_JobTaskLine.FindFirst() then
                //     Validate("Job Task No.", NS_JobTaskLine."Job Task No.");

                // "Job Quantity" := -1;
                // "System-Created Entry" := true;
                // Insert();
                // //PRJ-921.GK.1.0 21Sep2021 end
                //PRJ-983.GK.1.0 14Oct2021 end


                Sleep(1000);

                DefDim.Reset();
                DefDim.SetRange("Table ID", 167);
                DefDim.SetRange("No.", RevenueRecSummaryTab."NS_job No.");
                DefDim.SetRange("Dimension Code", JobsSetup."NS_Mandatory Dimension Rev.");
                DefDim.SetRange("Dimension Value Code", JobsSetup."NS_Mandatory Dimension Value Rev.");
                if DefDim.FindFirst() then begin
                    DefDim.DeleteAll();
                end;

            end;
        end;//PRJ-658.AS.1.0 17MAY2021 End Added genjnl line insert code inide this condition
    end;
    //PRJ-658.AS.1.0 17MAY2021 - END ADDED NOT TRUE UP CONDITION

    //end;//CTSI-286 rollback


    //PRJ-830 start
    local procedure InsertGnJnLinesNew()
    var
        revrecsummtable: Record NS_RevenueRecSummaryTab;
        revrecsummtable5: Record NS_RevenueRecSummaryTab;
        revrecsummtable6: Record NS_RevenueRecSummaryTab;
        NS_JobTaskLine: Record "Job Task";
        NS_GenJnlBatchL: record "Gen. Journal Batch";
    begin
        //PRJCTPR-215.HS.1.0 17Nov2023 Start
        Clear(NSRevRecDocNoseries);
        Clear(NSExterDocNo);
        Clear(NSRevRecDocNo);
        NS_GenJnlBatchL.Reset();
        NS_GenJnlBatchl.SetRange(Name, JobsSetup."NS_Burden G/L Journal Batch Rev.");
        if NS_GenJnlBatchL.FindFirst() then begin
            if (NS_GenJnlBatchL."No. Series" <> '') then begin
                NSRevRecDocNo := NSNoSeriesMgt.GetNextNo(NS_GenJnlBatchL."No. Series", Today, true);
                NSRevRecDocNoseries := NSRevRecDocNo;
                NSExterDocNo := DocNo;
            end;
            if (NS_GenJnlBatchL."No. Series" = '') and (DocNo <> '') then begin
                NSRevRecDocNoseries := DocNo;
                NSExterDocNo := DocNo;
            end;
            if (NS_GenJnlBatchL."No. Series" <> '') and (DocNo = '') then begin
                NSRevRecDocNoseries := NSRevRecDocNo;
                NSExterDocNo := NSRevRecDocNo;
            end;
        end;
        //PRJCTPR-215.HS.1.0 17Nov2023 End

        if JobsSetup.Get() then;
        if JobPostingGrp.get(Job."Job Posting Group") then;
        //PRJ-830.GK.1.0 16Sep2021 start
        // JobTaskLine.Reset();
        // JobTaskLine.SetRange("Job No.", job."No.");
        // JobTaskLine.SetRange("Job Task No.", JobsSetup."NS_Default Job Task No. Rev.");
        // if not JobTaskLine.FindFirst() then
        //     Error('Default Job Task No. %1 from jobs setup does not exist within Job No. %2', JobsSetup."NS_Default Job Task No. Rev.", job."No.");
        //PRJ-830.GK.1.0 16Sep2021 start

        if (JobsSetup."NS_Mandatory Dimension Rev." <> '') and (JobsSetup."NS_Mandatory Dimension Value Rev." <> '') then begin
            DefDim.Reset();
            DefDim.SetRange("Table ID", 167);
            DefDim.SetRange("No.", RevenueRecSummaryTab."NS_job No.");
            DefDim.SetRange("Dimension Code", JobsSetup."NS_Mandatory Dimension Rev.");
            DefDim.SetRange("Dimension Value Code", JobsSetup."NS_Mandatory Dimension Value Rev.");
            if not DefDim.FindFirst() then begin
                DefDim.Init();
                DefDim.validate("Table ID", 167);
                DefDim.validate("No.", RevenueRecSummaryTab."NS_job No.");
                DefDim.validate("Dimension Code", JobsSetup."NS_Mandatory Dimension Rev.");
                DefDim.validate("Dimension Value Code", JobsSetup."NS_Mandatory Dimension Value Rev.");
                defdim.Insert();
            end;
        end;

        RevenueRecSummaryTab2.Reset();
        RevenueRecSummaryTab2.SetCurrentKey("NS_Entry No.");
        RevenueRecSummaryTab2.SetRange("NS_Job No.", RevenueRecSummaryTab."NS_job No.");
        RevenueRecSummaryTab2.SetFilter("NS_Over/Under Billings Posted", '%1', false);
        //RevenueRecSummaryTab2.SetFilter("NS_Net Revenue", '<>%1', 0);
        RevenueRecSummaryTab2.SetRange("NS_Posting Date", 0D, MaxDate);
        if RevenueRecSummaryTab2.FindLast() then begin
            RevenueRecSummaryTab."NS_Gen.Doc.No." := DocNo;
            if RevenueRecSummaryTab2."NS_Over Billings" <> 0 then
                RevenueRecSummaryTab."NS_Billing Amt. Posted" := -RevenueRecSummaryTab2."NS_Over Billings"
            else
                if RevenueRecSummaryTab2."NS_under Billings" <> 0 then
                    RevenueRecSummaryTab."NS_Billing Amt. Posted" := RevenueRecSummaryTab2."NS_under Billings";
            RevenueRecSummaryTab.Modify();
        end;

        //PRJ-658.AS.1.0 17MAY2021 - START
        revrecsummtable.Reset();
        revrecsummtable.SetCurrentKey("NS_Entry No.");
        revrecsummtable.SetRange("NS_Job No.", RevenueRecSummaryTab."NS_job No.");
        revrecsummtable.SetRange("NS_Net Revenue", 0);
        revrecsummtable.SetFilter("NS_Posting Date", DateVal);
        if revrecsummtable.FindSet() then
            repeat
                revrecsummtable.NS_CheckBool := true;
                revrecsummtable."NS_Gen.Doc.No." := DocNo;
            until revrecsummtable.Next() = 0;

        clear(LineNum);
        // if RevAmountfinance <> 0 then begin//PRJ-658.AS.1.0 17MAY2021 start Added genjnl line insert code inide this condition
        with GenJnlLine do begin
            //PRJ-1346.GK.1.0 02May2022 start
            GenJnlLine4.Reset();
            GenJnlLine4.SetRange("Journal Template Name", JobsSetup."NS_Burden G/L Jour. Temp Rev.");//PRJ-1546.GK.1.0 08Aug2022\replace template new field
            GenJnlLine4.SetRange("Journal Batch Name", JobsSetup."NS_Burden G/L Journal Batch Rev.");
            GenJnlLine4.SetFilter("Account No.", '%1', ''); //PRJ-1516.GK.1.0 21July2022
            GenJnlLine4.SetFilter("Document No.", '<>%1', '');
            if GenJnlLine4.FindFirst() then begin
                GenJnlLine4.Delete();
            end;
            //PRJ-1346.GK.1.0 02May2022 end
            INIT;
            "Journal Template Name" := JobsSetup."NS_Burden G/L Jour. Temp Rev.";//PRJ-1546.GK.1.0 08Aug2022\replace template new field
            "Journal Batch Name" := JobsSetup."NS_Burden G/L Journal Batch Rev.";

            GenJnlLine."Line No." := GetNextLineNo(GenJnlLine);
            "Posting Date" := PostingDate;
            //PRJCTPR-215.HS.1.0 31Oct2023 Start
            // GenJnlLine."Document No." := DocNo; // Commented
            GenJnlLine."Document No." := NSRevRecDocNoseries;
            GenJnlLine."External Document No." := NSExterDocNo;
            //PRJCTPR-215.HS.1.0 31Oct2023 End
            Description := DocDescription;
            "Account Type" := "Account Type"::"G/L Account";
            "Bal. Account Type" := "Account Type"::"G/L Account";
            if RevenueRecSummaryTab."NS_Over Billings" <> 0 then begin
                "Account No." := JobPostingGrp."Recognized Sales Account";
                "Bal. Account No." := JobPostingGrp."NS_Over Billing Account";
                VALIDATE(Amount, RevenueRecSummaryTab."NS_Over Billings");
            end else
                if RevenueRecSummaryTab."NS_under Billings" <> 0 then begin
                    "Account No." := JobPostingGrp."NS_Under Billing Account";
                    "Bal. Account No." := JobPostingGrp."Recognized Sales Account";
                    VALIDATE(Amount, RevenueRecSummaryTab."NS_under Billings");
                end;
            Validate("Job No.", RevenueRecSummaryTab."NS_Job No.");
            //validate("Job Task No.", JobsSetup."NS_Default Job Task No. Rev."); //PRJ-830.GK.1.0 20Sep2021 | Comment Code
            //PRJ-830.GK.1.0 20Sep2021 start
            NS_JobTaskLine.Reset();
            NS_JobTaskLine.SetRange("Job No.", RevenueRecSummaryTab."NS_Job No.");
            NS_JobTaskLine.SetRange("Job Task Type", NS_JobTaskLine."Job Task Type"::Posting);
            if NS_JobTaskLine.FindFirst() then
                Validate("Job Task No.", NS_JobTaskLine."Job Task No.");
            //PRJ-830.GK.1.0 20Sep2021 end
            "Job Quantity" := -1;
            "System-Created Entry" := true;
            GenJnlLine."NS_Rev. Rec. Summary Dtls" := true; //PRJCTPR-330.PS.1.0 07April2024
            //PRJ-950.AS.1.0 - start
            //  GenJnlLine."NS_RevRec GenJnl Document No." := NSRevRecGnlJnlBatchNo;   //PE-136.JS.1.0 03Aug2023
            "Shortcut Dimension 1 Code" := RevenueRecSummaryTab."NS_Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := RevenueRecSummaryTab."NS_Global Dimension 2 Code";
            "Dimension Set ID" := RevenueRecSummaryTab."NS_Dimension Set ID";//PRJ-1041.AS.1.0
            //PRJ-950.AS.1.0 - end
            if Insert() then
                GenJnllineInsert := true;
            //PRJ-921.GK.1.0 21Sep2021 start
            INIT;
            "Journal Template Name" := JobsSetup."NS_Burden G/L Jour. Temp Rev.";//PRJ-1546.GK.1.0 08Aug2022\replace template new field
            "Journal Batch Name" := JobsSetup."NS_Burden G/L Journal Batch Rev.";

            GenJnlLine."Line No." := GetNextLineNo(GenJnlLine);
            "Posting Date" := PostingDate + 1;
            //PRJCTPR-215.HS.1.0 31Oct2023 Start
            // GenJnlLine."Document No." := IncStr(DocNo); //  Commented
            if GenJnllineInsert then begin
                if NS_GenJnlBatch."No. Series" <> '' then
                    GenJnlLine."Document No." := NSNoSeriesMgt.GetNextNo(NS_GenJnlBatch."No. Series", Today, true)
                else
                    GenJnlLine."Document No." := IncStr(DocNo);
            end;
            if DocNo = '' then
                GenJnlLine."External Document No." := GenJnlLine."Document No."
            else
                GenJnlLine."External Document No." := NSExterDocNo;
            GenJnlLine."NS_Rev. Rec. Summary Dtls" := true; //PRJCTPR-330.PS.1.0 07April2024
            //PRJCTPR-215.HS.1.0 31Oct2023 End
            // "Document No." := IncStr(DocNo);
            Description := DocDescription;
            "Account Type" := "Account Type"::"G/L Account";
            "Bal. Account Type" := "Account Type"::"G/L Account";
            if RevenueRecSummaryTab."NS_Over Billings" <> 0 then begin
                "Account No." := JobPostingGrp."Recognized Sales Account";
                "Bal. Account No." := JobPostingGrp."NS_Over Billing Account";
                VALIDATE(Amount, -(RevenueRecSummaryTab."NS_Over Billings"));
            end else
                if RevenueRecSummaryTab."NS_under Billings" <> 0 then begin
                    "Account No." := JobPostingGrp."NS_Under Billing Account";
                    "Bal. Account No." := JobPostingGrp."Recognized Sales Account";
                    VALIDATE(Amount, -(RevenueRecSummaryTab."NS_under Billings"));
                end;
            Validate("Job No.", RevenueRecSummaryTab."NS_Job No.");
            GenJnlLine."NS_RevRec GenJnl Document No." := NSRevRecGnlJnlBatchNo;   //PE-136.JS.1.0 03Aug2023
            NS_JobTaskLine.Reset();
            NS_JobTaskLine.SetRange("Job No.", RevenueRecSummaryTab."NS_Job No.");
            NS_JobTaskLine.SetRange("Job Task Type", NS_JobTaskLine."Job Task Type"::Posting);
            if NS_JobTaskLine.FindFirst() then
                Validate("Job Task No.", NS_JobTaskLine."Job Task No.");
            "Job Quantity" := -1;
            "System-Created Entry" := true;
            //PRJ-950.AS.1.0 - start
            "Shortcut Dimension 1 Code" := RevenueRecSummaryTab."NS_Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := RevenueRecSummaryTab."NS_Global Dimension 2 Code";
            "Dimension Set ID" := RevenueRecSummaryTab."NS_Dimension Set ID";//PRJ-1041.AS.1.0
            //PRJ-950.AS.1.0 - end
            Insert();
            //PRJ-921.GK.1.0 21Sep2021 end

            Sleep(1000);
            DefDim.Reset();
            DefDim.SetRange("Table ID", 167);
            DefDim.SetRange("No.", RevenueRecSummaryTab."NS_job No.");
            DefDim.SetRange("Dimension Code", JobsSetup."NS_Mandatory Dimension Rev.");
            DefDim.SetRange("Dimension Value Code", JobsSetup."NS_Mandatory Dimension Value Rev.");
            if DefDim.FindFirst() then begin
                DefDim.DeleteAll();
            end;

        end;
    end;
    //end;
    //PRJ-830 end
    //PE-136.JS.1.0 03Aug2023 - Start
    local Procedure NSCreateReversalEntriesForRevRec(Var NSJobNo: code[30]; NSPostingDate: date)
    Var
        NSRevRecSummeryDtls: record NS_RevenueRecSummaryTab;
        NSGLLedgEntry: record "G/L Entry";
    begin
        if (NSJobNo <> '') and (NSPostingDate <> 0D) then Begin
            //Message('AAAA-NSJobNo...%1...Posting Date...%2', NSJobNo, NSPostingDate);
            NSRevRecSummeryDtls.Reset();
            NSRevRecSummeryDtls.SetFilter("NS_Entry Type", '%1|%2', NSRevRecSummeryDtls."NS_Entry Type"::JFW, NSRevRecSummeryDtls."NS_Entry Type"::Finance);
            NSRevRecSummeryDtls.setrange("NS_Job No.", NSJobNo);
            NSRevRecSummeryDtls.SetRange(NS_Voided, true);
            NSRevRecSummeryDtls.SetRange("NS_Over/Under Billings Posted", true);
            NSRevRecSummeryDtls.Setfilter("NS_GenJnl Posted Doc. No.", '<>%1', '');
            NSRevRecSummeryDtls.Setfilter("NS_Posting Date", '..%1', PostingDate);
            NSRevRecSummeryDtls.SetRange("NS_Reversed Gen. Posted", false);
            if NSRevRecSummeryDtls.FindSet() then begin
                Repeat
                    //Message('BBBB-NSJobNo...%1...Posting Date...%2....%3.....%4', NSJobNo, NSPostingDate, NSRevRecSummeryDtls.Count, NSPostingDate + 1);
                    NSGLLedgEntry.Reset();
                    NSGLLedgEntry.Setfilter("Posting Date", '%1..%2', NSPostingDate, NSPostingDate + 1);
                    NSGLLedgEntry.SetRange("Job No.", NSJobNo);
                    NSGLLedgEntry.SetRange("NS_RevRec GenJnl Document No.", NSRevRecSummeryDtls."NS_GenJnl Posted Doc. No.");
                    if NSGLLedgEntry.FindSet() then
                        repeat
                            //Message('CCCC-NSJobNo...%1...Posting Date...%2..NSGLLedgEntry..%3..EntryNo..%4', NSJobNo, NSPostingDate, NSGLLedgEntry.Count, NSGLLedgEntry."Entry No.");
                            if NSGLLedgEntry."NS_RevRec GenJnl Document No." <> '' then begin
                                NSReverceRevRecVoidedEntriesFromGLEntrySingleJob(NSGLLedgEntry, NSJobNo);
                            end;
                        until NSGLLedgEntry.Next() = 0;
                until NSRevRecSummeryDtls.Next() = 0;
            end;
            NSRevRecSummeryDtls.Reset();
            NSRevRecSummeryDtls.SetFilter("NS_Entry Type", '%1|%2', NSRevRecSummeryDtls."NS_Entry Type"::JFW, NSRevRecSummeryDtls."NS_Entry Type"::Finance);
            NSRevRecSummeryDtls.setrange("NS_Job No.", NSJobNo);
            NSRevRecSummeryDtls.SetRange(NS_Voided, true);
            NSRevRecSummeryDtls.SetRange(NS_Posted, true);
            NSRevRecSummeryDtls.Setfilter("NS_GenJnl Posted Doc. No.", '<>%1', '');
            NSRevRecSummeryDtls.Setfilter("NS_Posting Date", '..%1', PostingDate);
            NSRevRecSummeryDtls.SetRange("NS_Reversed Gen. Posted", false);
            if NSRevRecSummeryDtls.FindSet() then begin
                Repeat
                    //Message('BBBB-NSJobNo...%1...Posting Date...%2....%3.....%4', NSJobNo, NSPostingDate, NSRevRecSummeryDtls.Count, NSPostingDate + 1);
                    NSGLLedgEntry.Reset();
                    NSGLLedgEntry.Setfilter("Posting Date", '%1..%2', NSPostingDate, NSPostingDate + 1);
                    NSGLLedgEntry.SetRange("Job No.", NSJobNo);
                    NSGLLedgEntry.SetRange("NS_RevRec GenJnl Document No.", NSRevRecSummeryDtls."NS_GenJnl Posted Doc. No.");
                    if NSGLLedgEntry.FindSet() then
                        repeat
                            //Message('CCCC-NSJobNo...%1...Posting Date...%2..NSGLLedgEntry..%3..EntryNo..%4', NSJobNo, NSPostingDate, NSGLLedgEntry.Count, NSGLLedgEntry."Entry No.");
                            if NSGLLedgEntry."NS_RevRec GenJnl Document No." <> '' then begin
                                NSReverceRevRecVoidedEntriesFromGLEntrySingleJob(NSGLLedgEntry, NSJobNo);
                            end;
                        until NSGLLedgEntry.Next() = 0;
                until NSRevRecSummeryDtls.Next() = 0;
            end;
        end;
    end;

    local procedure NSReverceRevRecVoidedEntriesFromGLEntrySingleJob(var NSGLEntryVar: record "G/L Entry"; Var NSJobNo1: code[30])
    var
        NSReversalEntry: Record "Reversal Entry";
        NSGenLedgEntryPage: page "General Ledger Entries";
        NSJobSetup: record "Jobs Setup";
        NSGenJnlLine: record "Gen. Journal Line";

    begin
        if NSJobSetup.get() then begin
            NSJobSetup.testfield("NS_Burden G/L Jour. Temp Rev.");
            NSJobSetup.testfield("NS_Burden G/L Journal Batch Rev.");
        end;
        NSGenJnlLine.Reset();
        NSGenJnlLine.setrange("Journal Template Name", NSJobSetup."NS_Burden G/L Jour. Temp Rev.");
        NSGenJnlLine.SetRange("Journal Batch Name", NSJobSetup."NS_Burden G/L Journal Batch Rev.");
        NSGenJnlLine.SetRange("NS_RevRec GenJnl Document No.", NSGLEntryVar."NS_RevRec GenJnl Document No.");
        NSGenJnlLine.SetRange("NS_RevRec G/L Reverse EntryNo.", NSGLEntryVar."Entry No.");
        if Not NSGenJnlLine.FindFirst() then begin
            NSFillGenJournalLinesReverseRevRecSingleJob(NSGenJnlLine, NSGLEntryVar, NSJobNo1);
        end;
    end;

    local procedure NSFillGenJournalLinesReverseRevRecSingleJob(Var NSGenJnlLine1: record "Gen. Journal Line"; var NSGLEntryVar1: record "G/L Entry"; var NSJobNo2: code[30])
    var
        NSJobSetup1: record "Jobs Setup";
        NS_JobTaskLine: record "Job Task";
        NSJobs1: Record job;
        NSJobPostingGrp1: record "Job Posting Group";
        NSNextLineNumber: integer;
    begin
        clear(NSNextLineNumber);
        if NSJobSetup1.get() then;
        if NSJobs1.get(NSJobNo2) then
            if NSJobPostingGrp1.get(NSJobs1."Job Posting Group") then;

        if NSGLEntryVar1."G/L Account No." = NSJobPostingGrp1."Recognized Sales Account" then begin
            NSGenJnlLine1.Init();
            NSGenJnlLine1."Journal Template Name" := NSJobSetup1."NS_Burden G/L Jour. Temp Rev.";
            NSGenJnlLine1."Journal Batch Name" := NSJobSetup1."NS_Burden G/L Journal Batch Rev.";
            NSNextLineNumber := NSGetGenJulNextLineNumber(NSJobSetup1."NS_Burden G/L Jour. Temp Rev.", NSJobSetup1."NS_Burden G/L Journal Batch Rev.");
            NSGenJnlLine1."Line No." := NSNextLineNumber;
            NSGenJnlLine1.Insert();

            NSGenJnlLine1.Validate("Account Type", NSGenJnlLine1."Account Type"::"G/L Account");
            NSGenJnlLine1.Validate("Account No.", NSGLEntryVar1."G/L Account No.");
            NSGenJnlLine1."Posting Date" := NSGLEntryVar1."Posting Date";
            NSGenJnlLine1."Document No." := NSGLEntryVar1."Document No.";

            NSGenJnlLine1.Description := 'RevRec Reversal-GL Entry Ref. No.' + format(NSGLEntryVar1."Entry No.");

            //NSGenJnlLine1.Validate("Job Quantity", 1);
            NSGenJnlLine1.Validate("Bal. Account Type", NSGenJnlLine1."Bal. Account Type"::"G/L Account");
            NSGenJnlLine1.Validate("Bal. Account No.", NSGLEntryVar1."Bal. Account No.");
            if NSGLEntryVar1.Amount > 0 then
                NSGenJnlLine1.Validate("Amount (LCY)", -NSGLEntryVar1.Amount)
            else
                NSGenJnlLine1.Validate("Amount (LCY)", (-1 * NSGLEntryVar1.Amount));

            NSGenJnlLine1.validate("Job No.", NSJobNo2);
            NS_JobTaskLine.Reset();
            NS_JobTaskLine.SetRange("Job No.", NSJobNo2);
            NS_JobTaskLine.SetRange("Job Task Type", NS_JobTaskLine."Job Task Type"::Posting);
            if NS_JobTaskLine.FindFirst() then
                NSGenJnlLine1.Validate("Job Task No.", NS_JobTaskLine."Job Task No.");

            NSGenJnlLine1."System-Created Entry" := true;
            NSGenJnlLine1.Validate("Job Quantity", 1);
            NSGenJnlLine1."NS_RevRec G/L Reverse EntryNo." := NSGLEntryVar1."Entry No.";
            NSGenJnlLine1."NS_RevRec GenJnl Document No." := NSGLEntryVar1."NS_RevRec GenJnl Document No.";
            NSGenJnlLine1."Gen. Prod. Posting Group" := '';
            NSGenJnlLine1."Bal. Gen. Bus. Posting Group" := '';
            NSGenJnlLine1.Modify();
        end;
    end;

    local procedure NSGetGenJulNextLineNumber(var NSTemplateName: code[20]; NSBatchName: code[20]) NSNextLnNo: integer
    var
        NSGenJnlLine2: record "Gen. Journal Line";
    begin
        NSGenJnlLine2.Reset();
        NSGenJnlLine2.Setrange("Journal Template Name", NSTemplateName);
        NSGenJnlLine2.Setrange("Journal Batch Name", NSBatchName);
        if NSGenJnlLine2.FindLast() then
            NSNextLnNo := NSGenJnlLine2."Line No." + 10000
        else
            NSNextLnNo := 10000;

        exit(NSNextLnNo);
    end;
    //PE-136.JS.1.0 03Aug2023 - end
    //for All Jobs-Start
    local Procedure NSCreateReversalEntriesForRevRecAllJobs(Var NSJobNo: code[30]; NSPostingDate: date)
    Var
        NSRevRecSummeryDtls: record NS_RevenueRecSummaryTab;
        NSGLLedgEntry: record "G/L Entry";
    begin
        if (NSJobNo = '') and (NSPostingDate <> 0D) then Begin
            //Message('First for all Jobs');
            NSRevRecSummeryDtls.Reset();
            NSRevRecSummeryDtls.SetFilter("NS_Entry Type", '%1|%2', NSRevRecSummeryDtls."NS_Entry Type"::JFW, NSRevRecSummeryDtls."NS_Entry Type"::Finance);
            //NSRevRecSummeryDtls.setrange("NS_Job No.", NSJobNo);
            NSRevRecSummeryDtls.SetRange(NS_Voided, true);
            NSRevRecSummeryDtls.SetRange("NS_Over/Under Billings Posted", true);
            NSRevRecSummeryDtls.Setfilter("NS_GenJnl Posted Doc. No.", '<>%1', '');
            NSRevRecSummeryDtls.Setfilter("NS_Posting Date", '..%1', NSPostingDate);
            NSRevRecSummeryDtls.SetRange("NS_Reversed Gen. Posted", false);
            if NSRevRecSummeryDtls.FindSet() then
                Repeat
                    //Message('AAAAA - NSRevRecSummeryDtls Count...%1', NSRevRecSummeryDtls.Count);
                    NSGLLedgEntry.Reset();
                    NSGLLedgEntry.Setfilter("Posting Date", '%1..%2', NSPostingDate, NSPostingDate + 1);
                    NSGLLedgEntry.SetRange("Job No.", NSRevRecSummeryDtls."NS_Job No.");
                    NSGLLedgEntry.SetRange("NS_RevRec GenJnl Document No.", NSRevRecSummeryDtls."NS_GenJnl Posted Doc. No.");
                    if NSGLLedgEntry.FindSet() then
                        repeat
                            //Message('BBBB - NSGLLedgEntry Count...%1', NSGLLedgEntry.Count);
                            if NSGLLedgEntry."NS_RevRec GenJnl Document No." <> '' then begin
                                NSReverceRevRecVoidedEntriesFromGLEntrySingleJobAllJobs(NSGLLedgEntry, NSGLLedgEntry."Job No.");
                            end;
                        until NSGLLedgEntry.Next() = 0;
                until NSRevRecSummeryDtls.Next() = 0
        end;
    end;

    local procedure NSReverceRevRecVoidedEntriesFromGLEntrySingleJobAllJobs(var NSGLEntryVar: record "G/L Entry"; Var NSJobNo1: code[30])
    var
        NSReversalEntry: Record "Reversal Entry";
        NSGenLedgEntryPage: page "General Ledger Entries";
        NSJobSetup: record "Jobs Setup";
        NSGenJnlLine: record "Gen. Journal Line";

    begin
        if NSJobSetup.get() then begin
            NSJobSetup.testfield("NS_Burden G/L Jour. Temp Rev.");
            NSJobSetup.testfield("NS_Burden G/L Journal Batch Rev.");
        end;
        NSGenJnlLine.Reset();
        NSGenJnlLine.setrange("Journal Template Name", NSJobSetup."NS_Burden G/L Jour. Temp Rev.");
        NSGenJnlLine.SetRange("Journal Batch Name", NSJobSetup."NS_Burden G/L Journal Batch Rev.");
        NSGenJnlLine.SetRange("NS_RevRec GenJnl Document No.", NSGLEntryVar."NS_RevRec GenJnl Document No.");
        NSGenJnlLine.SetRange("NS_RevRec G/L Reverse EntryNo.", NSGLEntryVar."Entry No.");
        if Not NSGenJnlLine.FindFirst() then begin
            NSFillGenJournalLinesReverseRevRecSingleJobAllJobs(NSGenJnlLine, NSGLEntryVar, NSJobNo1);
        end;
    end;

    local procedure NSFillGenJournalLinesReverseRevRecSingleJobAllJobs(Var NSGenJnlLine1: record "Gen. Journal Line"; var NSGLEntryVar1: record "G/L Entry"; var NSJobNo2: code[30])
    var
        NSJobSetup1: record "Jobs Setup";
        NS_JobTaskLine: record "Job Task";
        NSJobs1: Record job;
        NSJobPostingGrp1: record "Job Posting Group";
        NSNextLineNumber: integer;
    begin
        clear(NSNextLineNumber);
        if NSJobSetup1.get() then;
        if NSJobs1.get(NSJobNo2) then
            if NSJobPostingGrp1.get(NSJobs1."Job Posting Group") then;

        if NSGLEntryVar1."G/L Account No." = NSJobPostingGrp1."Recognized Sales Account" then begin
            NSGenJnlLine1.Init();
            NSGenJnlLine1."Journal Template Name" := NSJobSetup1."NS_Burden G/L Jour. Temp Rev.";
            NSGenJnlLine1."Journal Batch Name" := NSJobSetup1."NS_Burden G/L Journal Batch Rev.";
            NSNextLineNumber := NSGetGenJulNextLineNumber(NSJobSetup1."NS_Burden G/L Jour. Temp Rev.", NSJobSetup1."NS_Burden G/L Journal Batch Rev.");
            NSGenJnlLine1."Line No." := NSNextLineNumber;
            NSGenJnlLine1.Insert();

            NSGenJnlLine1.Validate("Account Type", NSGenJnlLine1."Account Type"::"G/L Account");
            NSGenJnlLine1.Validate("Account No.", NSGLEntryVar1."G/L Account No.");
            NSGenJnlLine1."Posting Date" := NSGLEntryVar1."Posting Date";
            NSGenJnlLine1."Document No." := NSGLEntryVar1."Document No.";

            NSGenJnlLine1.Description := 'RevRec Reversal-GL Entry Ref. No.' + format(NSGLEntryVar1."Entry No.");

            NSGenJnlLine1.Validate("Bal. Account Type", NSGenJnlLine1."Bal. Account Type"::"G/L Account");
            NSGenJnlLine1.Validate("Bal. Account No.", NSGLEntryVar1."Bal. Account No.");
            if NSGLEntryVar1.Amount > 0 then
                NSGenJnlLine1.Validate("Amount (LCY)", -NSGLEntryVar1.Amount)
            else
                NSGenJnlLine1.Validate("Amount (LCY)", (-1 * NSGLEntryVar1.Amount));

            NSGenJnlLine1.validate("Job No.", NSJobNo2);
            NS_JobTaskLine.Reset();
            NS_JobTaskLine.SetRange("Job No.", NSJobNo2);
            NS_JobTaskLine.SetRange("Job Task Type", NS_JobTaskLine."Job Task Type"::Posting);
            if NS_JobTaskLine.FindFirst() then
                NSGenJnlLine1.Validate("Job Task No.", NS_JobTaskLine."Job Task No.");

            NSGenJnlLine1."System-Created Entry" := true;
            NSGenJnlLine1.Validate("Job Quantity", 1);
            NSGenJnlLine1."NS_RevRec G/L Reverse EntryNo." := NSGLEntryVar1."Entry No.";
            NSGenJnlLine1."NS_RevRec GenJnl Document No." := NSGLEntryVar1."NS_RevRec GenJnl Document No.";
            NSGenJnlLine1."Gen. Prod. Posting Group" := '';
            NSGenJnlLine1."Bal. Gen. Bus. Posting Group" := '';
            NSGenJnlLine1.Modify();
        end;
    end;
    //PE-136.JS.1.0 03Aug2023 - end
}