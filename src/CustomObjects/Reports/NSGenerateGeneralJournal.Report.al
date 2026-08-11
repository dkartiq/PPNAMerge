report 14021163 NS_GenerateGeneralJournal
{
    //CTSI-274.AM.1.0 Created report to generate General
    //PRJ-830.GK.1.0 20Sep2021 |Added new code.
    //PRJ-983.GK.1.0 14Oct2021 | Comment Code
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

                RevenueRecSummaryTab.SetRange("NS_Job No.", Job."No.");
                RevenueRecSummaryTab.SetRange(NS_Voided, false);
                if not CreateOvUdBillings then  //prj-830
                    RevenueRecSummaryTab.SetRange(NS_Posted, false)
                else
                    RevenueRecSummaryTab.SetRange("NS_Over/Under Billings Posted", false); //prj-830
                //RevenueRecSummaryTab.SetRange("True-Up Posted", false);//CTSI-286 rollback
                RevenueRecSummaryTab.SetFilter("NS_Posting Date", DateVal);
                if RevenueRecSummaryTab.FindLast() then begin
                    if not CreateOvUdBillings then//PRJ-830
                        InsertGnJnLines
                    else
                        InsertGnJnLinesNew; //PRJ-830
                end else
                    CurrReport.Skip();
            end;

            trigger OnPostDataItem()
            begin

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
                        Caption = 'Document No.';
                        NotBlank = true;
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
    }

    trigger OnPreReport()
    var
    begin
        JobsSetup.Get();

        if (JobsSetup."NS_Burden G/L Journal Template Rev." = '') or (JobsSetup."NS_Burden G/L Journal Batch Rev." = '') then
            Error('You must define the Rev. Rec. G/L Journal Template and Batch on Job setup');
        //PRJ-830.GK.1.0 22Sep2021 start|Comment Code
        // if JobsSetup."NS_Default Job Task No. Rev." = '' then
        //     Error('You must define the Rev. Rec. Default Job Task No. on Jobs Setup.');
        //PRJ-830.GK.1.0 22Sep2021 end

        GenJnlLine.RESET();
        GenJnlLine.SETRANGE("Journal Template Name", JobsSetup."NS_Burden G/L Journal Template Rev.");
        GenJnlLine.SETRANGE("Journal Batch Name", JobsSetup."NS_Burden G/L Journal Batch Rev.");
        if GenJnlLine.FindFirst() then
            Error('The general journal batch "%1" must be blank.', JobsSetup."NS_Burden G/L Journal Batch Rev.");

        if PostingDate = 0D then
            ERROR(Text002);
        if DocNo = '' then
            ERROR(Text003);
    end;


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
        JobTaskLine: Record "Job Task";
        Flag: Boolean;
        GenJnllineInsert: Boolean;
        MaxDate: Date;
        CreateOvUdBillings: Boolean;//PRJ-830
        jobTable: Record Job;//PRJ-950.AS.1.0

    trigger OnPostReport()
    var
    begin
        JobsSetup.Get();
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
        GenJnLine.SetRange("Journal Template Name", Jobsetuprec."NS_Burden G/L Journal Template Rev.");
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
    begin
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
            RevenueRecSummaryTab."NS_Gen.Doc.No." := DocNo;
            RevenueRecSummaryTab."NS_True-Up Value" := RevAmountfinance;//CTSI-286
                                                                        // if CalculateTrueUp then
                                                                        //     RevenueRecSummaryTab2.TrueupDoc := true; //CTSI-286 rollback
            RevenueRecSummaryTab.Modify();

        end else begin //CTSI-286 start
            RevAmountfinance := RevenueRecSummaryTab."NS_Net Revenue";
            RevenueRecSummaryTab."NS_Gen.Doc.No." := DocNo;
            RevenueRecSummaryTab."NS_True-Up Value" := RevAmountfinance;
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
                INIT;
                "Journal Template Name" := JobsSetup."NS_Burden G/L Journal Template rev.";
                "Journal Batch Name" := JobsSetup."NS_Burden G/L Journal Batch Rev.";

                GenJnlLine."Line No." := GetNextLineNo(GenJnlLine);
                "Posting Date" := PostingDate;
                "Document No." := DocNo;
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
                //PRJ-830.GK.1.0 20Sep2021 start
                NS_JobTaskLine.Reset();
                NS_JobTaskLine.SetRange("Job No.", RevenueRecSummaryTab."NS_Job No.");
                NS_JobTaskLine.SetRange("Job Task Type", NS_JobTaskLine."Job Task Type"::Posting);
                if NS_JobTaskLine.FindFirst() then
                    Validate("Job Task No.", NS_JobTaskLine."Job Task No.");
                //PRJ-830.GK.1.0 20Sep2021 end
                "Job Quantity" := -1;
                "System-Created Entry" := true;

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
    begin
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
            INIT;
            "Journal Template Name" := JobsSetup."NS_Burden G/L Journal Template rev.";
            "Journal Batch Name" := JobsSetup."NS_Burden G/L Journal Batch Rev.";

            GenJnlLine."Line No." := GetNextLineNo(GenJnlLine);
            "Posting Date" := PostingDate;
            "Document No." := DocNo;
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
            if Insert() then
                GenJnllineInsert := true;
            //PRJ-921.GK.1.0 21Sep2021 start
            INIT;
            "Journal Template Name" := JobsSetup."NS_Burden G/L Journal Template rev.";
            "Journal Batch Name" := JobsSetup."NS_Burden G/L Journal Batch Rev.";

            GenJnlLine."Line No." := GetNextLineNo(GenJnlLine);
            "Posting Date" := PostingDate + 1;
            "Document No." := IncStr(DocNo);
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

            //PRJ-950.AS.1.0 - start
            "Shortcut Dimension 1 Code" := RevenueRecSummaryTab."NS_Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := RevenueRecSummaryTab."NS_Global Dimension 2 Code";
            //PRJ-950.AS.1.0 - end

            NS_JobTaskLine.Reset();
            NS_JobTaskLine.SetRange("Job No.", RevenueRecSummaryTab."NS_Job No.");
            NS_JobTaskLine.SetRange("Job Task Type", NS_JobTaskLine."Job Task Type"::Posting);
            if NS_JobTaskLine.FindFirst() then
                Validate("Job Task No.", NS_JobTaskLine."Job Task No.");
            "Job Quantity" := -1;
            "System-Created Entry" := true;
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
}