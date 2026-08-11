report 14021414 "NS_BatchUpdatePayWhenPaid"
{

    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Batch Update Due Dates - Pay When Paid';
    Permissions = tabledata "Vendor Ledger Entry" = rm, tabledata "Cust. Ledger Entry" = rm;

    //PE-248.AS.6.0 Created Batch Report
    dataset
    {
        dataitem(Job; Job)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemTableView = sorting("Entry No.") where("Document Type" = filter(Payment), NS_PaywhenPaid = filter(false), "Entry No." = filter(<> 0), "NS_Draw No." = filter(<> ''));
                DataItemLink = "NS_Job No." = field("No.");
                trigger OnAfterGetRecord()
                var
                    vleTable: Record "Vendor Ledger Entry";
                    JobRec1: Record Job;
                    JobStp: Record "Jobs Setup";
                    DrawRecord: Record NS_Draw;
                begin
                    drawRecord.RESET;
                    drawRecord.SetRange("NS_No.", "Cust. Ledger Entry"."NS_Draw No.");
                    drawRecord.SetRange("NS_Job No.", "Cust. Ledger Entry"."NS_Job No.");
                    drawRecord.SetRange(NS_Closed, true);
                    if drawRecord.FindFirst() then
                        CurrReport.Skip();
                    if JobRec1.get("Cust. Ledger Entry"."NS_Job No.") then;
                    if JobStp.Get() then;
                    vleTable.Reset();
                    vleTable.SetCurrentKey("Posting Date", "NS_Job No.");
                    vleTable.Ascending(true);
                    vleTable.SetRange("NS_Job No.", "Cust. Ledger Entry"."NS_Job No.");
                    vleTable.SetRange("NS_Draw No.", "Cust. Ledger Entry"."NS_Draw No.");
                    vleTable.SetRange("Document Type", vleTable."Document Type"::Invoice);
                    vleTable.SetRange(NS_PaywhenPaid, false);
                    vleTable.SetFilter("NS_Retention Ledger Code", '<>%1', JobStp."NS_Retention Payable Ledger");
                    if vleTable.FindSet() then begin
                        repeat
                            vleTable."Due Date" := CalcDate(JobRec1.NS_PaywhenpaidTermsCode, "Cust. Ledger Entry"."Posting Date");
                            vleTable.NS_PaywhenPaid := true;
                            if vleTable.Modify() then begin
                                "Cust. Ledger Entry".NS_PaywhenPaid := true;
                                "Cust. Ledger Entry".Modify();
                            end;
                        until vleTable.Next() = 0;
                    end;
                end;
            }

        }
    }
}