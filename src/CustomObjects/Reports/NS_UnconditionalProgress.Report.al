//PE-85.DK.1.0 | Create New Report
report 14021475 NS_UnconditionalProgress
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Unconditional Progress';
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NS_Unconditional Lien.rdl';
    dataset
    {
        dataitem(Integer1; Integer)
        {
            DataItemTableView = where(Number = CONST(3));
            column(NSNameofClaimant; NSNameofClaimant) { }
            column(NSBilltoName; NSBilltoName) { }
            column(NSJobLacation; NSJobLacation) { }
            column(NS_JobNo; NS_JobNo1) { }
            column(NS_JobDis; NS_JobDis) { }
            column(NSOwner; NSOwner) { }
            column(NSInvoicedDate; Format(NSInvoicedDate)) { }
            column("NSMakerofCheck"; NSBilltoName) { }
            column(NSCheckPayableto; NSNameofClaimant) { }
            column(NSInvoiceNo; NSInvoiceNo) { }
            column(NSAmount; NSAmount) { }
            column(NSPostedDoc; NSPostedDoc) { }
            column(NS_Workdate; Format(NS_Workdate)) { }
            column(NSLienWaiverType; NSLienWaiverType) { }
            column(NSAddr1; NSAddr1) { }
            trigger OnpreDataItem()
            begin
                NS_Workdate := WorkDate();
                if NS_CompanyInformation.get() then
                    NSNameofClaimant := NS_CompanyInformation.Name;
                NS_Job.SetRange("No.", NS_JobNo);
                NS_Job.SetRange("Sell-to Customer No.", NS_CostNo);
                if NS_Job.FindSet() then begin
                    NSBilltoName := NS_Job."Sell-to Customer Name";
                    NSOwner := NS_Job."Sell-to Customer Name" + ';' + ' ';
                    if NS_Job."NS_Job Address 2" = '' then
                        NS_Job."NS_Job Address 2" := ''
                    else
                        NS_Job."NS_Job Address 2" := NS_Job."NS_Job Address 2" + ',' + ' ';
                    if NS_Job."NS_Job City" = '' then
                        NS_Job."NS_Job City" := ''
                    else
                        NS_Job."NS_Job City" := NS_Job."NS_Job City" + ',' + ' ';
                    if NS_Job."NS_Job County" = '' then
                        NS_Job."NS_Job County" := ''
                    else
                        NS_Job."NS_Job County" := NS_Job."NS_Job County" + ',' + ' ';
                    if NS_Job."NS_Job Post Code" = '' then
                        NS_Job."NS_Job Post Code" := ''
                    else
                        NS_Job."NS_Job Post Code" := NS_Job."NS_Job Post Code";
                    NSAddr1 := NS_Job."NS_Job Address 2" + NS_Job."NS_Job City" + NS_Job."NS_Job County" + Format(NS_Job."NS_Job Post Code");
                    NS_JobNo1 := NS_Job."No." + ';' + ' ';
                    NS_JobDis := NS_Job.Description;
                    "NSMakerofCheck" := NS_Job."Sell-to Customer Name";
                    if NS_Job."NS_Job Address 1" = '' then
                        NSJobLacation := NS_Job."Sell-to Address" + ',' + ''
                    else
                        NSJobLacation := NS_job."NS_Job Address 1" + ',' + '';
                end;
                NS_CLE.Reset();
                NS_CLE.SetCurrentKey("Posting Date");
                NS_CLE.SetRange("NS_Job No.", NS_JobNo);
                NS_CLE.SetRange("Customer No.", NS_CostNo);
                NS_CLE.SetRange("NS_Retention Ledger Code", 'NORMAL');
                NS_CLE.SetFilter("Posting Date", '%1', NS_PostingDate);
                NS_CLE.SetRange("Document Type", NS_CLE."Document Type"::Invoice);
                if NS_CLE.FindFirst() then begin
                    repeat
                        NS_CLE.CalcFields("Amount (LCY)", "Remaining Amt. (LCY)");
                        if NS_CLE."Remaining Amt. (LCY)" = 0 then begin
                            NSLienWaiverType := NS_CLE."NS_Lien Waiver Work Type";
                            NSAmount := NS_CLE."Amount (LCY)";
                            NSPostedDoc := NS_CLE."Document No." + ';' + '';
                            NSInvoicedDate := NS_PostingDate;
                        end else
                            if NS_CLE."Remaining Amt. (LCY)" <> 0 then
                                Error('You can not run this report because still the invoice has not been completely billed.');

                    until NS_CLE.Next() = 0;
                end;
            end;

            trigger OnAfterGetRecord()
            begin
                NS_CLE.Reset();
                NS_CLE.SetRange("Entry No.", NS_CLE."Entry No.");
                if NS_CLE.FindFirst() then begin
                    NS_CLE."NS_Lien Waiver Signed Date" := WorkDate();
                    NS_CLE."NS_Lien Waiver Print Status" := NS_CLE."NS_Lien Waiver Print Status"::Printed;
                    NS_CLE.Modify();
                end;
            end;
        }
    }
    /// <summary>
    /// SetDocument.
    /// </summary>
    /// <param name="NSJobNo">code[20].</param>
    /// <param name="DocNo">code[20].</param>
    /// <param name="CustNo">Code[20].</param>
    /// <param name="PostingDate">Date.</param>
    procedure SetDocument(NSJobNo: code[20]; DocNo: code[20]; CustNo: Code[20]; PostingDate: Date)
    begin
        if NSJobNo = '' then
            exit;
        NS_JobNo := NSJobNo;
        NSInvoiceNo := DocNo;
        NS_CostNo := CustNo;
        NS_PostingDate := PostingDate;
    end;

    var
        NS_CompanyInformation: Record "Company Information";
        NS_Job: Record job;
        NS_CLE: Record "Cust. Ledger Entry";
        NSNameofClaimant: Text[100];
        NSBilltoName: Text[100];
        NSJobLacation: Text[100];
        NSOwner: Text[100];
        "NSMakerofCheck": Text[100];
        NS_JobDis: Text[200];
        NSInvoicedDate: Date;
        NSCheckPayableto: Text[100];
        NSInvoiceNo: Code[20];
        NSAmount: Decimal;
        NS_JobNo: Code[20];
        NS_CostNo: Code[20];
        NSPostedDoc: Code[20];
        NS_PostingDate: Date;
        NS_Workdate: Date;
        NSAddr1: Text[100];
        NSLienWaiverType: Text[50];
        NS_JobNo1: Code[20];

}