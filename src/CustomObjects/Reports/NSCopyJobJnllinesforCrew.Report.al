report 14021375 "NS_Copy Job Jnl lines for Crew"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    Caption = 'Copy Job Jnl Lines for Crew';
    ProcessingOnly = true;


    dataset
    {
        dataitem("Job Journal Line"; "Job Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Line No.");

            trigger OnAfterGetRecord();
            begin
                CrewLine.RESET();
                CrewLine.SETRANGE(NS_Code, CrewNo);
                if CrewLine.FINDSET() then
                    repeat
                        if "No." <> CrewLine."NS_Resource No." then
                            if CrewLine."NS_Resource No." <> '' then
                                if Resource.GET(CrewLine."NS_Resource No.") then begin
                                    //Determine next Line No. to assign
                                    JobJnlLine3.RESET();
                                    JobJnlLine3.SETRANGE("Journal Template Name", "Journal Template Name");
                                    JobJnlLine3.SETRANGE("Journal Batch Name", "Journal Batch Name");
                                    if not JobJnlLine3.FINDLAST() then
                                        NextLineNo := 10000
                                    else
                                        NextLineNo := JobJnlLine3."Line No." + 10000;
                                    //Create new journal line
                                    JobJnlLine2.TRANSFERFIELDS("Job Journal Line", false);
                                    JobJnlLine2."Journal Template Name" := "Journal Template Name";
                                    JobJnlLine2."Journal Batch Name" := "Journal Batch Name";
                                    JobJnlLine2."Line No." := NextLineNo;
                                    JobJnlLine2."NS_Job Revenue Category" := "NS_Job Revenue Category";
                                    JobJnlLine2.VALIDATE("No.", CrewLine."NS_Resource No.");
                                    JobJnlLine2.VALIDATE("Work Type Code", "Work Type Code");
                                    JobJnlLine2.VALIDATE(Quantity, Quantity);
                                    JobJnlLine2.INSERT(true);
                                    InsertCount += 1;
                                end;
                    until CrewLine.NEXT() = 0;
            end;

            trigger OnPostDataItem();
            begin
                MESSAGE(Text002, InsertCount);
            end;

            trigger OnPreDataItem();
            begin
                InsertCount := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(CrewNo; CrewNo)
                {
                    Caption = 'Enter Crew No. to use for journal line copying';
                    TableRelation = NS_Crew;
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

    trigger OnPreReport();
    begin
        if CrewNo = '' then
            ERROR(Text001);
    end;

    var
        CrewNo: Code[10];
        Text001: Label 'A Crew No. must be specified for Journal Line copying.';
        CrewLine: Record "NS_Crew Line";
        Resource: Record Resource;
        JobJnlLine2: Record "Job Journal Line";
        JobJnlLine3: Record "Job Journal Line";
        NextLineNo: Integer;
        InsertCount: Integer;
        Text002: Label '%1 lines have been inserted into the end of the journal.';
}

