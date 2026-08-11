report 14021371 "NS_Get Receipt Lines - Job"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    //PRJ-256.MS.1.0 added permission
    //PRJ-394.MS.1.0 added code for GBPG
    //TM-10.AM.1.0 | Added Segment Flow code.
    // +------------------------------------------------------------

    Caption = 'Get Receipt Lines - Job';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Jobs;
    Permissions = tabledata "Purch. Rcpt. Line" = rimd; //PRJ-256.MS.1.0

    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            DataItemTableView = SORTING("No.");
            dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {
                DataItemLink = "Buy-from Vendor No." = FIELD("Buy-from Vendor No."), "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") WHERE(NS_Staged = FILTER(true), Type = FILTER(Item), "NS_Journal Status" = FILTER(" "));
                RequestFilterFields = "Job No.", "Job Task No.";

                trigger OnAfterGetRecord();
                begin
                    if "Purch. Rcpt. Line".NS_Staged then
                        CreateJobJrnlLine();
                end;

                trigger OnPreDataItem();
                begin
                    if DocNo <> '' then
                        SETRANGE("NS_JMP Document No.", DocNo);
                end;
            }
        }
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
                    field(DocumentNo; DocNo)
                    {
                        Caption = 'Document No.';
                        ApplicationArea = All;
                    }
                    field(PostingDate; PostingDate)
                    {
                        Caption = 'Posting Date';
                        ApplicationArea = All;
                    }
                    field(TemplateName; TemplateName)
                    {
                        Caption = 'Template Name';
                        Editable = false;
                        Lookup = false;
                        TableRelation = "Gen. Journal Template";
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            if TemplateName = '' then begin
                                BatchName := '';
                                exit;
                            end;
                            GenJnlTemplate.GET(TemplateName);
                            if GenJnlTemplate.Type <> GenJnlTemplate.Type::Jobs then begin
                                GenJnlTemplate.Type := GenJnlTemplate.Type::Jobs;
                                ERROR(Text001,
                                  GenJnlTemplate.TABLECAPTION, GenJnlTemplate.FIELDCAPTION(Type), GenJnlTemplate.Type);
                            end;
                        end;
                    }
                    field(BatchName; BatchName)
                    {
                        Caption = 'Batch Name';
                        Editable = false;
                        Lookup = false;
                        ApplicationArea = All;

                        trigger OnLookup(VAR Text: Text): Boolean;
                        begin
                            if TemplateName = '' then
                                ERROR(Text000, JobJnlLine.FIELDCAPTION("Journal Template Name"));
                            JobJnlLine."Journal Template Name" := TemplateName;
                            JobJnlLine.FILTERGROUP := 2;
                            JobJnlLine.SETRANGE("Journal Template Name", TemplateName);
                            JobJnlLine.SETRANGE("Journal Batch Name", BatchName);
                            JobJnlManagement.LookupName(BatchName, JobJnlLine);
                            JobJnlManagement.CheckName(BatchName, JobJnlLine);
                        end;

                        trigger OnValidate();
                        begin
                            JobJnlManagement.CheckName(BatchName, JobJnlLine);
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            TemplateName := TemplateName3;
            BatchName := BatchName3;
            DocNo := DocNo2;
        end;
    }

    labels
    {
    }

    var
        GenJnlTemplate: Record "Gen. Journal Template";
        JobJnlLine: Record "Job Journal Line";
        DocNo: Code[20];
        DocNo2: Code[20];
        PostingDate: Date;
        TemplateName: Code[10];
        BatchName: Code[10];
        TemplateName3: Code[10];
        BatchName3: Code[10];
        Text000: Label 'You must specify %1.';
        Text001: Label '%1 %2 must be %3.';
        NextLineNo: Integer;
        JobJnlTemplate: Record "Job Journal Template";
        JobJnlBatch: Record "Job Journal Batch";
        JobJnlManagement: Codeunit JobJnlManagement;
        JobSU: Record "Jobs Setup";

    procedure SetBatch(TemplateName2: Code[10]; BatchName2: Code[10]);
    begin
        TemplateName3 := TemplateName2;
        BatchName3 := BatchName2;
    end;

    procedure SetDocNo(InputDocNo: Code[20]);
    begin
        DocNo2 := InputDocNo;
    end;

    procedure CreateJobJrnlLine();
    var
        job: Record Job;
    begin
        JobSU.GET();
        JobJnlLine.LOCKTABLE;
        JobJnlLine.VALIDATE("Journal Template Name", TemplateName);
        JobJnlLine.VALIDATE("Journal Batch Name", BatchName);
        JobJnlLine.SETRANGE("Journal Template Name", JobJnlLine."Journal Template Name");
        JobJnlLine.SETRANGE("Journal Batch Name", JobJnlLine."Journal Batch Name");
        if JobJnlLine.FINDLAST() then
            NextLineNo := JobJnlLine."Line No." + 10000
        else
            NextLineNo := 10000;

        CLEAR(JobJnlLine);
        JobJnlLine."Journal Template Name" := TemplateName;
        JobJnlLine."Journal Batch Name" := BatchName;
        JobJnlTemplate.GET(TemplateName);
        JobJnlBatch.GET(TemplateName, BatchName);
        JobJnlLine."Source Code" := JobJnlTemplate."Source Code";
        JobJnlLine."Reason Code" := JobJnlBatch."Reason Code";
        JobJnlLine.DontCheckStdCost;
        JobJnlLine."Job No." := "Purch. Rcpt. Line"."Job No.";
        JobJnlLine."Job Task No." := "Purch. Rcpt. Line"."Job Task No.";
        JobJnlLine."Posting Date" := PostingDate;
        JobJnlLine."Document Date" := "Purch. Rcpt. Line"."Posting Date";
        JobJnlLine.Type := JobJnlLine.Type::Item;
        JobJnlLine.VALIDATE("No.", "Purch. Rcpt. Line"."No.");
        JobJnlLine.Description := "Purch. Rcpt. Line".Description;
        JobJnlLine."Unit of Measure Code" := "Purch. Rcpt. Line"."Unit of Measure";
        JobJnlLine."Location Code" := "Purch. Rcpt. Line"."Location Code";
        JobJnlLine."Direct Unit Cost (LCY)" := "Purch. Rcpt. Line"."Direct Unit Cost";
        JobJnlLine.NS_Staged := "Purch. Rcpt. Line".NS_Staged;
        JobJnlLine."Document No." := "Purch. Rcpt. Line"."NS_JMP Document No.";
        if "Purch. Rcpt. Line"."NS_Staged Quantity" <> 0 then
            JobJnlLine.VALIDATE(Quantity, "Purch. Rcpt. Line"."NS_Staged Quantity")
        else
            JobJnlLine.VALIDATE(Quantity, "Purch. Rcpt. Line".Quantity);
        JobJnlLine."NS_Purch. Receipt Doc. No." := "Purch. Rcpt. Line"."Document No.";
        JobJnlLine."NS_Purch. Receipt Line No." := "Purch. Rcpt. Line"."Line No.";
        JobJnlLine."Line No." := NextLineNo;
        JobJnlLine.VALIDATE("Shortcut Dimension 1 Code", "Purch. Rcpt. Line"."Shortcut Dimension 1 Code");
        JobJnlLine.VALIDATE("Shortcut Dimension 2 Code", "Purch. Rcpt. Line"."Shortcut Dimension 2 Code");
        JobJnlLine."NS_Segment Code" := "Purch. Rcpt. Line"."NS_Segment Code";//TM-10.AM.1.0
        //PRJ-394 start
        if job.get("Purch. Rcpt. Line"."Job No.") then;
        if "Purch. Rcpt. Line"."Gen. Bus. Posting Group" <> '' then
            JobJnlLine."Gen. Bus. Posting Group" := "Purch. Rcpt. Line"."Gen. Bus. Posting Group"
        else
            //JobJnlLine."Gen. Bus. Posting Group" := job."NS_Gen. Bus. Posting Group";//PRJ-831.AS.1.0 12OCT2021 Comment old
             JobJnlLine."Gen. Bus. Posting Group" := job."NS_Gen. Bus. Posting Group New";//PRJ-831.AS.1.0 12OCT2021 Add New
        //PRJ-394 end
        NextLineNo := NextLineNo + 10000;
        if JobJnlLine.INSERT(true) then begin
            "Purch. Rcpt. Line"."NS_Journal Status" := "Purch. Rcpt. Line"."NS_Journal Status"::Journal;
            "Purch. Rcpt. Line".MODIFY();
        end;
    end;
}

