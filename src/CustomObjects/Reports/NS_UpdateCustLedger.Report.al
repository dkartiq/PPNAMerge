/// <summary>
/// Report NS_Update Cust Ledger Report (ID 14021492).
/// </summary>
//PRJ-1044.GK.1.0 22Nov2021 |Add report
report 14021492 "NS_Update Cust Ledger"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Update Cust Ledger Report';
    Permissions = tabledata "Cust. Ledger Entry" = rm;

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            trigger OnPreDataItem()
            var
                jobsetup: Record "Jobs Setup";
            begin
                jobsetup.Get();
                SetRange("NS_Retention Ledger Code", jobsetup."NS_Retention Receivable Ledger");
            end;

            trigger OnAfterGetRecord()
            var
                CustLedgerEntry: Record "Cust. Ledger Entry";
            begin
                "Cust. Ledger Entry"."Sales (LCY)" := 0;
                "Cust. Ledger Entry"."NS_Retention Amount" := 0;
                "Cust. Ledger Entry"."NS_Retention Amount (LCY)" := 0;
                "Cust. Ledger Entry"."NS_Retention Base Amount" := 0;
                "Cust. Ledger Entry"."NS_Retention Percent" := 0;
                "Cust. Ledger Entry"."NS_Retention Date" := 0D;
                Modify();
                CustLedgerEntry.Reset();
                CustLedgerEntry.SetRange("NS_Retention Document", true);
                if CustLedgerEntry.FindFirst() then begin
                    repeat
                        CustLedgerEntry."Sales (LCY)" := 0;
                        CustLedgerEntry."NS_Retention Base Amount" := 0;
                        CustLedgerEntry.Modify();
                    until CustLedgerEntry.Next() = 0;
                end;


            end;
        }
    }
    trigger OnPostReport()

    begin
        Message('Updated Sucessfully');
    end;
}

