report 14021376 "NS_Create PayrollInterfEntries"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    Caption = 'Create Payroll Interf Entries';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Payroll Interface Jnl Line"; "NS_Payroll Interface Jnl Line")
        {
            DataItemTableView = SORTING("NS_Journal Template Name", "NS_Journal Batch Name", "NS_Line No.") ORDER(Ascending);

            trigger OnPreDataItem();
            begin
                JournalTemplateName := GETFILTER("NS_Journal Template Name");
                JournalBatchName := GETFILTER("NS_Journal Batch Name");
                CurrReport.BREAK;
            end;
        }
        dataitem("Job Ledger Entry"; "Job Ledger Entry")
        {
            DataItemTableView = SORTING("Entry Type", Type, "No.", "Posting Date");
            RequestFilterFields = "Posting Date";
            RequestFilterHeading = '"Specify the Job Ledger Posting Date range to draw entries from "';

            trigger OnAfterGetRecord();
            begin
                if Quantity <> 0 then
                    if "No." <> '' then begin
                        Employee.RESET();
                        Employee.SETCURRENTKEY("Resource No.");
                        Employee.SETRANGE("Resource No.", "No.");
                        if Employee.FINDFIRST() then begin
                            PayrollInterfaceJnlLine.INIT();
                            PayrollInterfaceJnlLine."NS_Journal Template Name" := JournalTemplateName;
                            PayrollInterfaceJnlLine."NS_Journal Batch Name" := JournalBatchName;
                            if InitializeFirstLine then begin
                                PayrollInterfaceJnlLine.NS_SetUpNewLine(LastPayrollInterfaceJnlLine);
                                InitializeFirstLine := false;
                            end else
                                PayrollInterfaceJnlLine."NS_Document No." := LastPayrollInterfaceJnlLine."NS_Document No.";
                            if DefaultDocumentNo <> '' then
                                PayrollInterfaceJnlLine."NS_Document No." := DefaultDocumentNo;
                            PayrollInterfaceJnlLine."NS_Line No." := NextLineNo;
                            PayrollInterfaceJnlLine.VALIDATE("NS_Work Date", "Job Ledger Entry"."Posting Date");
                            PayrollInterfaceJnlLine.VALIDATE("NS_Employee No.", Employee."No.");
                            PayrollInterfaceJnlLine."NS_Job No." := "Job Ledger Entry"."Job No.";
                            PayrollInterfaceJnlLine."NS_D/E Type" := PayrollInterfaceJnlLine."NS_D/E Type"::Earning;
                            if WorkType.GET("Job Ledger Entry"."Work Type Code") then
                                PayrollInterfaceJnlLine."NS_D/E Code" := WorkType."NS_Earning Code";
                            PayrollInterfaceJnlLine.NS_Rate := "Job Ledger Entry"."Unit Cost (LCY)";
                            PayrollInterfaceJnlLine.VALIDATE(NS_Hours, "Job Ledger Entry".Quantity);
                            if "Job Ledger Entry"."NS_Jobsite Work" then
                                PayrollInterfaceJnlLine.VALIDATE("NS_Override State", "Job Ledger Entry"."NS_Payroll Work State");
                            PayrollInterfaceJnlLine."NS_Social Security No." := Employee."Social Security No.";
                            PayrollInterfaceJnlLine."NS_Job Ledger Entry No." := "Job Ledger Entry"."Entry No.";
                            PayrollInterfaceJnlLine.INSERT();
                            NextLineNo += 10000;
                            LastPayrollInterfaceJnlLine := PayrollInterfaceJnlLine;
                            InsertCount += 1;
                        end;
                    end;
            end;

            trigger OnPostDataItem();
            begin
                MESSAGE(Text002, InsertCount);
            end;

            trigger OnPreDataItem();
            begin
                InsertCount := 0;
                InitializeFirstLine := true;
                SETRANGE("Entry Type", "Entry Type"::Usage);
                SETRANGE(Type, Type::Resource);
                LastPayrollInterfaceJnlLine.RESET();
                LastPayrollInterfaceJnlLine.SETRANGE("NS_Journal Template Name", JournalTemplateName);
                LastPayrollInterfaceJnlLine.SETRANGE("NS_Journal Batch Name", JournalBatchName);
                if LastPayrollInterfaceJnlLine.FINDLAST() then
                    NextLineNo := LastPayrollInterfaceJnlLine."NS_Line No." + 10000
                else
                    NextLineNo := 10000;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                //SMPL - Caption = 'Deafult Document No';
                field(DefaultDocumentNo; DefaultDocumentNo)
                {
                    Caption = 'Enter the Document No. to default on each line';
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
        if "Job Ledger Entry".GETFILTER("Posting Date") = '' then
            ERROR(Text001);
    end;

    var
        NextLineNo: Integer;
        InsertCount: Integer;
        Text001: Label 'You must specify a filter for the Posting Date.';
        Text002: Label '%1 lines have been inserted into the end of the journal.';
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        Employee: Record Employee;
        PayrollInterfaceJnlLine: Record "NS_Payroll Interface Jnl Line";
        LastPayrollInterfaceJnlLine: Record "NS_Payroll Interface Jnl Line";
        WorkType: Record "Work Type";
        InitializeFirstLine: Boolean;
        DefaultDocumentNo: Code[20];

    procedure SetTemplateBatch(PassedTemplateName: Code[10]; PassedBatchName: Code[10]);
    begin
        JournalTemplateName := PassedTemplateName;
        JournalBatchName := PassedBatchName;
    end;
}

