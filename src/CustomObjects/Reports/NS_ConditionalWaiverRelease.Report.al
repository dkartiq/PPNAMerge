//PE-85.Dk.1.0 Make a new Report Advance Lien Waiver Customer and New Layout
//PE-85.Dk.1.0 01june2023 Start 
/// <summary>
/// Report NSConditionalWaiver (ID 14021494).
/// </summary>
report 14021494 NSConditionalWaiver
{
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Conditional Progress';
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NS_Conditional Progress.rdl';
    dataset
    {
        dataitem(Integer1; Integer)
        {
            DataItemTableView = where(Number = CONST(3));
            column(NS_CompanyInformation; NS_CompanyInformation.Picture) { }
            column(NSNameofClaimant; NSNameofClaimant) { }
            column(NSBilltoName; NSBilltoName) { }
            column(NSJobLacation; NSJobLacation) { }
            column(NSOwner; NSOwner) { }
            column(NS_JobNo; NS_JobNo1) { }
            column(NS_JobDis; NS_JobDis) { }
            column(NSInvoicedDate; Format(NSInvoicedDate)) { }
            column("NSMakerofCheck"; NSBilltoName) { }
            column(NSCheckofAmount; NSCheckofAmount) { }
            column(NSCheckPayableto; NSNameofClaimant) { }
            column(NSInvoiceNo; NSInvoiceNo) { }
            column(NSPostedDoc; NSPostedDoc) { }
            column(NS_Workdate; format(NS_Workdate)) { }
            column(NSLienWaiverType; NSLienWaiverType) { }
            column(NSAddr1; NSAddr1) { }

            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                CalcFields = "Remaining Amt. (LCY)";
                DataItemTableView = sorting("Posting Date") order(ascending) where("Remaining Amt. (LCY)" = filter(<> 0), "Document Type" = const(Invoice), "NS_Retention Ledger Code" = const('NORMAL'));

                column(NSAmount; "Cust. Ledger Entry"."Remaining Amt. (LCY)") { }
                column(NSRefNo; "Cust. Ledger Entry"."Document No.") { }
                column(InvoiceDate; "Cust. Ledger Entry"."Posting Date") { }
                trigger OnAfterGetRecord()
                begin
                    if ("Cust. Ledger Entry"."Posting Date" > NS_PostingDate) or ("Cust. Ledger Entry"."Document No." = NSInvoiceNo) then
                        CurrReport.Skip();
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("NS_Job No.", NS_JobNo);
                end;
            }
            trigger OnPreDataItem()
            begin
                NS_Workdate := WorkDate();
                if NS_CompanyInformation.get() then begin
                    NS_CompanyInformation.CalcFields(Picture);
                    NSNameofClaimant := NS_CompanyInformation.Name;
                end;
                NS_Job.SetRange("No.", NS_JobNo);
                NS_Job.SetRange("Sell-to Customer No.", NS_CostNo);
                if NS_Job.FindSet() then begin
                    NSBilltoName := NS_Job."Sell-to Customer Name";
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

                    NSOwner := NS_Job."Sell-to Customer Name" + ';' + ' ';
                    NS_JobNo1 := NS_Job."No." + ';' + '';
                    NS_JobDis := NS_Job.Description;
                    "NSMakerofCheck" := NS_Job."Sell-to Customer Name";
                    if NS_Job."NS_Job Address 1" = '' then
                        NSJobLacation := NS_Job."Sell-to Address"
                    else
                        NSJobLacation := NS_job."NS_Job Address 1" + ',' + '';
                end;
                NS_CLE.Reset();
                NS_CLE.SetRange("Document No.", NSInvoiceNo);
                NS_CLE.SetRange("NS_Job No.", NS_JobNo);
                NS_CLE.SetRange("Customer No.", NS_CostNo);
                NS_CLE.SetRange("NS_Retention Ledger Code", 'NORMAL');
                NS_CLE.SetRange("Document Type", NS_CLE."Document Type"::Invoice);
                if NS_CLE.FindFirst() then begin
                    NSInvoicedDate := NS_CLE."Posting Date";
                    NSPostedDoc := NS_CLE."Document No." + ';' + '';
                    NSLienWaiverType := NS_CLE."NS_Lien Waiver Work Type";
                    NS_CLE.CalcFields("Amount (LCY)", "Remaining Amt. (LCY)");
                    NSCheckofAmount := NS_CLE."Remaining Amt. (LCY)";
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
    /// <param name="PostingDate">Date.</param>
    /// <param name="CustNo">Code[20].</param>
    procedure SetDocument(NSJobNo: code[20]; DocNo: code[20]; PostingDate: Date; CustNo: Code[20])
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
        NSCheckofAmount: Decimal;
        NSInvoicedDate: Date;
        NSCheckPayableto: Text[100];
        NSRefNo: Code[100];
        NSInvoiceNo: Code[20];
        NSAmount: Decimal;
        InvoiceDate: Date;
        NS_JobNo: Code[20];
        NS_CostNo: Code[20];
        NS_PostingDate: Date;
        NS_JobDis: Text[200];
        NSPostedDoc: Code[20];
        NS_Workdate: Date;
        NSLienWaiverType: Text[50];
        NSAddr1: Text[100];
        NS_JobNo1: Code[20];

}
//PE-85.Dk.1.0 01june2023 End