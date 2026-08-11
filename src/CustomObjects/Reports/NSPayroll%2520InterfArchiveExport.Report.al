report 14021379 "NS_Payroll InterfArchiveExport"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Payroll Interface Archive Export';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Payroll Interface Jnl Line"; "NS_Payroll Interface Jnl Line")
        {
            DataItemTableView = SORTING("NS_Journal Template Name", "NS_Journal Batch Name", "NS_Line No.") ORDER(Ascending);

            trigger OnAfterGetRecord();
            begin
                if "NS_Export Status" = "NS_Export Status"::Exported then begin
                    PayrollInterfExportArchive.INIT();
                    PayrollInterfExportArchive."NS_Entry No." := NextEntryNo;
                    PayrollInterfExportArchive."NS_Journal Batch Name" := "NS_Journal Batch Name";
                    PayrollInterfExportArchive."NS_Document No." := "NS_Document No.";
                    PayrollInterfExportArchive."NS_Employee No." := "NS_Employee No.";
                    PayrollInterfExportArchive."NS_Employee Name" := "NS_Employee Name";
                    PayrollInterfExportArchive."NS_Override Dept." := "NS_Override Dept.";
                    PayrollInterfExportArchive."NS_Job No." := "NS_Job No.";
                    PayrollInterfExportArchive.NS_Shift := NS_Shift;
                    PayrollInterfExportArchive."NS_D/E Type" := "NS_D/E Type";
                    PayrollInterfExportArchive."NS_D/E Code" := "NS_D/E Code";
                    PayrollInterfExportArchive.NS_Rate := NS_Rate;
                    PayrollInterfExportArchive.NS_Hours := NS_Hours;
                    PayrollInterfExportArchive.NS_Year := NS_Year;
                    PayrollInterfExportArchive.NS_Month := NS_Month;
                    PayrollInterfExportArchive.NS_Day := NS_Day;
                    PayrollInterfExportArchive.NS_Hour := NS_Hour;
                    PayrollInterfExportArchive.NS_Minute := NS_Minute;
                    PayrollInterfExportArchive.NS_Amount := NS_Amount;
                    PayrollInterfExportArchive."NS_Sequence No." := "NS_Sequence No.";
                    PayrollInterfExportArchive."NS_Override Division" := "NS_Override Division";
                    PayrollInterfExportArchive."NS_Override Branch" := "NS_Override Branch";
                    PayrollInterfExportArchive."NS_Override State" := "NS_Override State";
                    PayrollInterfExportArchive."NS_Override Local" := "NS_Override Local";
                    PayrollInterfExportArchive."NS_State/Local Misc. Field" := "NS_State/Local Misc. Field";
                    PayrollInterfExportArchive."NS_Rate No." := "NS_Rate No.";
                    PayrollInterfExportArchive."NS_Social Security No." := "NS_Social Security No.";
                    PayrollInterfExportArchive."NS_Job Ledger Entry No." := "NS_Job Ledger Entry No.";
                    PayrollInterfExportArchive."NS_Work Date" := "NS_Work Date";
                    PayrollInterfExportArchive."NS_Export Status Date/Time" := "NS_Export Status Date/Time";
                    PayrollInterfExportArchive."NS_Manual Check No." := "NS_Manual Check No.";
                    PayrollInterfExportArchive.INSERT();
                    NextEntryNo += 1;
                    DELETE;
                    ArchiveCount += 1;
                end;
            end;

            trigger OnPostDataItem();
            begin
                if ArchiveCount = 0 then
                    MESSAGE(Text002_Lbl)
                else
                    if ArchiveCount = 1 then
                        MESSAGE(Text003_Lbl)
                    else
                        MESSAGE(Text004_Lbl, ArchiveCount);
            end;

            trigger OnPreDataItem();
            begin
                PayrollInterfExportArchive.LOCKTABLE;
                if PayrollInterfExportArchive.FINDLAST() then
                    NextEntryNo := PayrollInterfExportArchive."NS_Entry No." + 1
                else
                    NextEntryNo := 1;
                ArchiveCount := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Instruction; Text001_Lbl)
                {
                    Editable = false;
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

    var

        PayrollInterfExportArchive: Record "NS_Payroll InterfExportArchive";
        NextEntryNo: Integer;
        ArchiveCount: Integer;
        Text002_Lbl: Label 'No action has been taken because only exported lines can be archived.';
        Text003_Lbl: Label '1 line has been archived.';
        Text004_Lbl: Label '#1 lines have been archived.';
        Text001_Lbl: Label 'Press OK to archive the Exported lines.';
}

