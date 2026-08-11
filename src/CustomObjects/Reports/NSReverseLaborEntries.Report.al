report 14021385 "NS_Reverse Labor Entries"
{


    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // + PPAL-64.MS.1.0 Created new report
    // +------------------------------------------------------------
    ///PPAL-64.NS.1.0 Add field on request page
    Caption = 'Reverse Labor Entries';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Job Journal Line"; "Job Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Line No.") ORDER(Ascending);
            trigger OnPreDataItem();
            begin
                JournalTemplateName := GETFILTER("Journal Template Name");
                JournalBatchName := GETFILTER("Journal Batch Name");
                CurrReport.BREAK;
            end;
        }
        dataitem("Job Ledger Entry"; "Job Ledger Entry")
        {
            DataItemTableView = SORTING("Job No.", "Posting date") where(quantity = filter(> 0));
            RequestFilterFields = "Posting Date", "Job No.", "Job Task No.";
            trigger OnAfterGetRecord();
            begin
                JobJnLine.Init();
                JobJnLine."Journal Template Name" := JournalTemplateName;
                JobJnLine."Journal Batch Name" := JournalBatchName;
                JobJnLine."Line No." := NextLineNo;
                JobJnLine."Document No." := "Document No.";
                // JobJnLine.validate("Posting Date", "Posting Date");//PPAL-64.NS.1.0 Code comment
                //PPAL-64.NS.1.0 Start
                if ReversalPostingDate = 0D then
                    JobJnLine."Posting Date" := 0D
                else
                    JobJnLine.validate("Posting Date", ReversalPostingDate);//PPAL-64.NS.1.0
                //PPAL-64.NS.1.0 end

                JobJnLine."Line Type" := "Line Type";
                JobJnLine."Entry Type" := "Entry Type";
                JobJnLine.Type := Type;
                JobJnLine."Job No." := "Job No.";
                JobJnLine."Job Task No." := "Job Task No.";
                JobJnLine."No." := "No.";
                JobJnLine.Description := Description;
                JobJnLine."Description 2" := "Description 2";
                JobJnLine."NS_Job Cost Category" := "NS_Job Cost Category";
                JobJnLine."Unit of Measure Code" := "Unit of Measure Code";
                JobJnLine.Quantity := -Quantity;
                JobJnLine."Quantity (Base)" := -"Quantity (Base)";
                JobJnLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
                JobJnLine.validate("Unit Cost", "Unit Cost");
                JobJnLine.validate("Unit Price", "Unit Price");
                JobJnLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
                JobJnLine.Insert();
                NextLineNo += 10000;
                InsertCount += 1;
            end;

            trigger OnPreDataItem();
            begin
                InsertCount := 0;
                if JobSetup.get then;
                jobsetup.TestField("NS_Job Cost Cat.for Rev.LaborEnt.");
                SETRANGE(Type, Type::Resource);
                SetFilter("NS_Job Cost Category", JobSetup."NS_Job Cost Cat.for Rev.LaborEnt.");
                JobJnLine.RESET;
                JobJnLine.SETRANGE("journal Template Name", journalTemplateName);
                JobJnLine.SETRANGE("Journal Batch Name", JournalBatchName);
                if JobJnLine.FINDLAST then
                    NextLineNo := JobJnLine."Line No." + 10000
                else
                    NextLineNo := 10000;
            end;

            trigger OnPostDataItem();
            begin
                MESSAGE(Text001, InsertCount);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                //PPAL-64.NS.1.0 start
                field(ReversalPostingDate; ReversalPostingDate)
                {
                    Caption = 'Reversal Posting Date';
                    ApplicationArea = all;
                    Visible = true;
                }
                //PPAL-64.NS.1.0 end
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        JobJnLine: Record "Job Journal Line";
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        NextLineNo: Integer;
        InsertCount: Integer;
        Text001: Label '%1 lines have been inserted into the end of the journal.';
        JobSetup: Record "Jobs Setup";
        ReversalPostingDate: Date;//PPAL-64.NS.1.0

}

