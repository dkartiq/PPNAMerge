//PE-85.DK.1.0 | Create New Report
/// <summary>
/// Report NS_UnconditionalLienFinal (ID 14021476).
/// </summary>
report 14021477 NS_UnconditionalLienFinal
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Unconditional Final';
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NS_Unconditional Final.rdl';
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
            column(NSInvoicedDate; NSInvoicedDate) { }
            column("NSMakerofCheck"; NSBilltoName) { }
            column(NSCheckPayableto; NSNameofClaimant) { }
            column(NSInvoiceNo; NSInvoiceNo) { }
            column(NS_Workdate; format(NS_Workdate)) { }
            column(NSLienWaiverType; NSLienWaiverType) { }
            column(NSAddr1; NSAddr1) { }
            trigger OnPreDataItem()
            begin
                NS_Workdate := WorkDate();
                if NS_CompanyInformation.get() then
                    NSNameofClaimant := NS_CompanyInformation.Name;

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
                    NS_JobDis := NS_Job.Description;
                    NS_JobNo1 := NS_Job."No." + ';' + '';
                    NSOwner := NS_Job."Sell-to Customer Name" + ';' + ' ';
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
                //  NS_CLE.SetFilter("Posting Date", '%1', NS_PostingDate);
                NS_CLE.SetRange("Document Type", NS_CLE."Document Type"::Invoice);
                if NS_CLE.FindFirst() then begin
                    repeat
                        NS_CLE.CalcFields("Amount (LCY)", "Remaining Amt. (LCY)");
                        if NS_CLE."Remaining Amt. (LCY)" = 0 then
                            NSLienWaiverType := NS_CLE."NS_Lien Waiver Work Type";
                    until NS_CLE.Next() = 0;
                end;
            end;

            trigger OnAfterGetRecord()
            var
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
    procedure SetDocument(NSJobNo: code[20]; DocNo: code[20]; CustNo: Code[20])
    begin
        if NSJobNo = '' then
            exit;
        NS_JobNo := NSJobNo;
        NSInvoiceNo := DocNo;
        NS_CostNo := CustNo;
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
        NSInvoicedDate: Date;
        NSCheckPayableto: Text[100];
        NSInvoiceNo: Code[20];
        NS_JobNo: Code[20];
        NS_CostNo: Code[20];
        NS_JobDis: Text;
        NS_Workdate: Date;
        NSAddr1: Text[100];
        NS_JobNo1: Code[20];
        NSLienWaiverType: Text[50];
}