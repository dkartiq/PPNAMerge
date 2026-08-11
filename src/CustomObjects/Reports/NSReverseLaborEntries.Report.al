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
    //PE-68 Dk.1.0 10April2023 | Add Some Code
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
            //PE-68.NK.1.0 start 20April2023 start
            // RequestFilterFields = "Posting Date", "Job No.", "Job Task No."; 
            RequestFilterFields = "Posting Date", "Job No.", "Job Task No.", "NS_Job Cost Category";
            //PE-68.NK.1.0 start 20April2023 end
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
                //PE-68 Dk.1.0 10April2023 Start
                JobJnLine."NS_Segment Code" := "NS_Segment Code";
                JobJnLine."NS_Crew Code" := "NS_Crew Code";
                JobJnLine."NS_Crew Time Sheet Ref. No." := "NS_Crew Time Sheet Ref. No.";
                JobJnLine."Work Type Code" := "Work Type Code";
                JobJnLine."NS_Union Code" := "NS_Union Code";
                JobJnLine."NS_Skill Code New" := "NS_Skill code New";
                JobJnLine."NS_Skill Class New" := "NS_Skill Class New";
                //PE-68 Dk.1.0 10April2023 End
                JobJnLine.Insert();
                NextLineNo += 10000;
                InsertCount += 1;
            end;

            trigger OnPreDataItem();
            begin
                //PE-68.NK.1.0 20April2023 Start 
                NS_jobCostCategory := '';
                NS_jobCostCategory := "Job Ledger Entry".GetFilter("NS_Job Cost Category");
                //PE-68.NK.1.0 20April2023 End
                InsertCount := 0;
                if JobSetup.get() then;
                //jobsetup.TestField("NS_Job Cost Cat.for Rev.LaborEnt."); //PE-68.NK.1.0 20April2023 comment
                SETRANGE(Type, Type::Resource);
                //PE-68.NK.1.0 start 20April2023
                // SetFilter("NS_Job Cost Category", JobSetup."NS_Job Cost Cat.for Rev.LaborEnt.");
                if NS_jobCostCategory <> '' then
                    SetFilter("NS_Job Cost Category", NS_jobCostCategory)
                else
                    if JobSetup."NS_Job Cost Cat.for Rev.LaborEnt." <> '' then
                        SetFilter("NS_Job Cost Category", JobSetup."NS_Job Cost Cat.for Rev.LaborEnt.");
                //PE-68.NK.1.0  end 20April2023
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
        NS_jobCostCategory: Code[50];//PE-68.NK.1.0 20April2023

}

