xmlport 14021377 "NS_PAYCHEX GL Payroll Import"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Direction = Import;
    Format = VariableText;

    schema
    {
        textelement(PaychexGLPayrollImport)
        {
            tableelement("Gen. Journal Line"; "Gen. Journal Line")
            {
                XmlName = 'GenJnlLine';
                textelement(Field1)
                {
                }
                textelement(Field2)
                {
                }
                textelement(Field3)
                {
                }
                textelement(Field4)
                {
                }
                textelement(Field5)
                {
                }
                textelement(Field6)
                {
                }
                textelement(Field7)
                {
                }

                trigger OnBeforeInsertRecord();
                begin
                    "Gen. Journal Line"."Journal Template Name" := Generallbl;
                    "Gen. Journal Line"."Journal Batch Name" := PayrollLbl;
                    "Gen. Journal Line"."Line No." := NextLineNo;
                    "Gen. Journal Line"."Posting Date" := PostingDate;
                    "Gen. Journal Line"."Document Date" := PostingDate;
                    "Gen. Journal Line"."Account Type" := "Gen. Journal Line"."Account Type"::"G/L Account";
                    "Gen. Journal Line"."Account No." := Field1;
                    "Gen. Journal Line"."Document No." := DocumentNo;
                    "Gen. Journal Line".Description := COPYSTR(Field2 + ' ' + Field3 + ' ' + Field4 + ' ' + Field5, 1, 50);

                    // If Job Line, then get then G/L Acct from the Job Posting Group
                    if Job.GET(Field1) then begin
                        //"Gen. Journal Line"."Job No." := Field1;

                        Job.TESTFIELD(Job."Job Posting Group");
                        if JobPostingGroup.GET(Job."Job Posting Group") then begin
                            JobPostingGroup.TESTFIELD(JobPostingGroup."NS_G/L Labor Expense Account");
                            "Gen. Journal Line"."Account No." := JobPostingGroup."NS_G/L Labor Expense Account";
                        end;

                    end;

                    EVALUATE(DBAmt, Field6);
                    EVALUATE(CRAmt, Field7);
                    if DBAmt <> 0 then
                        "Gen. Journal Line".Amount := DBAmt
                    else
                        "Gen. Journal Line".Amount := CRAmt * -1;


                    NextLineNo := NextLineNo + 1000;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(PostingDate; PostingDate)
                {
                    Caption = 'Posting Date';

                    ToolTip = 'Posting Date';
                    ApplicationArea = all;
                }
                field(DocumentNo; DocumentNo)
                {
                    Caption = 'Document No.';

                    ToolTip = 'Document No.';
                    ApplicationArea = all;
                }
            }
        }

        actions
        {
        }
    }

    trigger OnInitXmlPort();
    begin
        NextLineNo := 1000;
        if not GenJournalBatch.GET(Generallbl, PayrollLbl) then
            ERROR(Text001lbl);
    end;

    var
        Job: Record Job;
        JobPostingGroup: Record "Job Posting Group";
        GenJournalBatch: Record "Gen. Journal Batch";
        PostingDate: Date;
        DocumentNo: Code[20];
        NextLineNo: Integer;
        DBAmt: Decimal;
        CRAmt: Decimal;

        GeneralLbl: Label 'GENERAL';
        PayrollLbl: Label 'PAYROLL';
        Text001Lbl: Label 'Please setup a PAYROLL Batch in the within the GENERAL Gen. Journal Templates.';
}

