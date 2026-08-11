/// <summary>
/// Report NS_Subcontract Agreement1 (ID 14021478).
/// </summary>
report 14021478 "NS_Subcontract Agreement1"
{
    //PRJCTPR-53.NK.1.0 | Created a new report and layout 
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    DefaultLayout = Word;
    WordLayout = './Layouts/NSSubcontractAgree.docx';

    dataset
    {
        dataitem(NS_SubcontractRec; NS_Subcontract)
        {
            column(NSSubContNo1; "NS_No.") { }
            column(NS_CompanyInfo_name; NS_CompanyInfo.Name) { }
            column(NS_CompanyInfo_pic; NS_CompanyInfo.Picture) { }

            column(NS_StartDate; format("NS_Starting Date")) { }
            column(NSSubPostingDate; format("NS_Starting Date")) { }

            column(NSServiceProvider; NS_SubcontractRec.NS_Description) { }
            column(NS_VendorName; NS_SubcontractRec."NS_Buy-from Name") { }


            column(NS_companyAdd; NS_companyAdd) { }
            column(NS_companyAdd1; NS_companyAdd1) { }
            column(NSMailingadd; NSMailingadd) { }
            column(NSClientName; NSClientName) { }
            column(NSClinetAddress; NSClinetAddress) { }
            column(NSJobAddress; NSJobAddress) { }
            column(NSContractName; NSContractName) { }
            column(NS_TotalCost; NS_TotalCost) { }
            column(NS_Payterms; NS_Payterms) { }
            column(NSDay; NSDay) { }
            column(NSChangeOrderNo; NSChangeOrderNo) { }
            column(NsSubContractName; NsSubContractName) { }
            column(NSSubContMailingAdd; NSSubContMailingAdd) { }
            column(NS_GovLaw; NS_GovLaw) { }
            column(NSMailingadd1; NSMailingadd1) { }
            column(NSMailingadd2; NSMailingadd2) { }
            column(NSMailingadd3; NSMailingadd3) { }
            column(NSMailingadd4; NSMailingadd4) { }
            column(NSMailingadd5; NSMailingadd5) { }
            column(NSMailingadd6; NSMailingadd6) { }

            column(NS_CompletionDate; Format("NS_Completion Date")) { }

            dataitem("NS_Vendor Insurance"; "NS_Vendor Insurance")
            {
                DataItemLink = "NS_Vendor No." = field("NS_Buy-from Vendor No.");

                column(NS_Insurance_Type; "NS_Vendor Insurance"."NS_Insurance Type") { }
                column(NS_Value; "NS_Vendor Insurance".NS_Value) { }
                column(NS_Vendor_No_; "NS_Vendor No.") { }

                column(NS_Policy_No_; "NS_Vendor Insurance"."NS_Policy No.") { }
                column(NS_Expiration_Date; format("NS_Expiration Date")) { }

            }

            trigger OnAfterGetRecord()
            var
                NS_SubcontractLine: Record "NS_Subcontract Lines";
                NS_PurchaseHeader: Record "Purchase Header";

            begin

                NS_PurchaseHeader.Reset();
                NS_PurchaseHeader.SetRange("No.", NS_SubcontractRec."NS_Purchase Document No.");
                if NS_PurchaseHeader.FindFirst() then begin
                    NS_Payterms := NS_PurchaseHeader."Payment Terms Code";
                end;

                NS_SubcontractLine.Reset();
                NS_SubcontractLine.SetRange("NS_Subcontract No.", NS_SubcontractRec."NS_No.");
                if NS_SubcontractLine.FindFirst() then begin
                    repeat
                        NS_TotalCost += NS_SubcontractLine."NS_Total Cost";
                    until NS_SubcontractLine.Next() = 0;
                end;
                NSJob.Reset();
                NSJob.SetRange("No.", NS_SubcontractRec."NS_Job No.");
                if NSJob.FindFirst() then begin
                    NSChangeOrder.Reset();
                    NSChangeOrder.SetRange("NS_Job Class", NSChangeOrder."NS_Job Class"::"Change Order");
                    NSChangeOrder.SetRange("NS_Sub-Level to Job No.", NSJob."No.");
                    if NSChangeOrder.FindFirst() then begin
                        NSChangeOrderNo := NSChangeOrder."No.";
                    end;
                end;
                NS_Vendor.Reset();
                NS_Vendor.SetRange("No.", NS_SubcontractRec."NS_Buy-from Vendor No.");
                if NS_Vendor.FindFirst() then begin
                    NsSubContractName := NS_Vendor.Name;
                    if NS_Vendor.Address = '' then
                        NSSubContMailingAdd1 := ''
                    else
                        NSSubContMailingAdd1 := NS_Vendor.Address + ',' + ' ';
                    if NS_Vendor."Address 2" = '' then
                        NSSubContMailingAdd2 := ''
                    else
                        NSSubContMailingAdd2 := NS_Vendor."Address 2" + ',' + ' ';
                    if NS_Vendor.City = '' then
                        NSSubContMailingAdd3 := ''
                    else
                        NSSubContMailingAdd3 := NS_Vendor.City + ',' + ' ';
                    if NS_Vendor.County = '' then
                        NSSubContMailingAdd4 := ''
                    else
                        NSSubContMailingAdd4 := NS_Vendor.County + ',' + ' ';

                    if NS_Vendor."Post Code" = '' then
                        NSSubContMailingAdd5 := ''
                    else
                        NSSubContMailingAdd5 := NS_Vendor."Post Code";


                    NSSubContMailingAdd := NSSubContMailingAdd1 + NSSubContMailingAdd2 + NSSubContMailingAdd3 + NSSubContMailingAdd4 + NSSubContMailingAdd5;

                end;
                NSJob.Reset();
                NSJob.SetRange("No.", NS_SubcontractRec."NS_Job No.");
                if NSJob.FindFirst() then begin
                    if NSJob."NS_Job Address 1" = '' then
                        NSJobAddress1 := ''
                    else
                        NSJobAddress1 := NSJob."NS_Job Address 1" + ',' + ' ';
                    if NSJob."NS_Job Address 2" = '' then
                        NSJobAddress2 := ''
                    else
                        NSJobAddress2 := NSJob."NS_Job Address 2" + ',' + ' ';
                    if NSJob."NS_Job City" = '' then
                        NSJobAddress3 := ''
                    else
                        NSJobAddress3 := NSJob."NS_Job City" + ',' + ' ';
                    if NSJob."NS_Job County" = '' then
                        NSJobAddress4 := ''
                    else
                        NSJobAddress4 := NSJob."NS_Job County" + ',' + ' ';
                    if NSJob."NS_Job Country/Region Code" = '' then
                        NSJobAddress5 := ''
                    else
                        NSJobAddress5 := NSJob."NS_Job Country/Region Code" + ',' + ' ';
                    if NSJob."NS_Job Post Code" = '' then
                        NSJobAddress6 := ''
                    else
                        NSJobAddress6 := NSJob."NS_Job Post Code";
                    NSJobAddress := NSJobAddress1 + NSJobAddress2 + NSJobAddress3 + NSJobAddress4 + NSJobAddress5 + NSJobAddress6;
                    NS_GovLaw := NSJob."NS_Job County";
                end;
                NSJob.Reset();
                NSJob.SetRange("No.", NS_SubcontractRec."NS_Job No.");
                if NSJob.FindFirst() then begin
                    NS_Customer.Reset();
                    NS_Customer.SetRange("No.", NSJob."Sell-to Customer No.");
                    if NS_Customer.FindFirst() then begin
                        NSClientName := NS_Customer.Name;

                    end;
                    NSJob.Reset();
                    NSJob.SetRange("No.", NS_SubcontractRec."NS_Job No.");
                    if NSJob.FindFirst() then begin
                        NS_Customer.Reset();
                        NS_Customer.SetRange("No.", NSJob."Sell-to Customer No.");
                        if NS_Customer.FindFirst() then begin
                            if NS_Customer.Address = '' then
                                NSClinetAddress1 := ''
                            else
                                NSClinetAddress1 := NS_Customer.Address + ',' + ' ';
                            if NS_Customer."Address 2" = '' then
                                NSClinetAddress2 := ''
                            else
                                NSClinetAddress2 := NS_Customer."Address 2" + ',' + ' ';
                            if NS_Customer.City = '' then
                                NSClinetAddress3 := ''
                            else
                                NSClinetAddress3 := NS_Customer.City + ',' + ' ';
                            if NS_Customer.County = '' then
                                NSClinetAddress4 := ''
                            else
                                NSClinetAddress4 := NS_Customer.County + ',' + ' ';
                            if NS_Customer."Post Code" = '' then
                                NSClinetAddress5 := ''
                            else
                                NSClinetAddress5 := NS_Customer."Post Code";

                            NSClinetAddress := NSClinetAddress1 + NSClinetAddress2 + NSClinetAddress3 + NSClinetAddress4 + NSClinetAddress5;
                        end;
                    end;
                end;
            end;
        }

    }


    trigger OnPreReport()
    begin
        NSDay := 7;
        NS_CompanyInfo.get();
        NS_CompanyInfo.CalcFields(Picture);
        NSContractName := NS_CompanyInfo.Name;
        NS_companyAdd := NS_CompanyInfo.Address;
        NS_companyAdd1 := NS_CompanyInfo."Address 2";

        if NS_CompanyInfo.Address = '' then
            NSMailingadd1 := ''
        else
            NSMailingadd1 := NS_CompanyInfo.Address + ',' + ' ';
        if NS_CompanyInfo."Address 2" = '' then
            NSMailingadd2 := ''
        else
            NSMailingadd2 := NS_CompanyInfo."Address 2" + ',' + ' ';
        if NS_CompanyInfo.City = '' then
            NSMailingadd3 := ''
        else
            NSMailingadd3 := NS_CompanyInfo.City + ',' + ' ';
        if (NS_CompanyInfo.County = '') then
            NSMailingadd4 := ''
        else
            NSMailingadd4 := NS_CompanyInfo.County + ' ';

        if (NS_CompanyInfo."Post Code" = '') then
            NSMailingadd5 := ''
        else
            NSMailingadd5 := NS_CompanyInfo."Post Code";


        NSMailingadd := NSMailingadd1 + NSMailingadd2 + NSMailingadd3 + NSMailingadd4 + NSMailingadd6 + NSMailingadd5;


    end;







    var
        myInt: Integer;
        NS_Subcontract: Record NS_Subcontract;
        NS_CompanyInfo: Record "Company Information";
        NS_Vendor: Record Vendor;
        NS_Customer: Record Customer;
        NSSubContNo: Code[20];
        NSSubPostingDate: Date;
        NSContractName: Text[250];
        NSMailingadd: Text[250];
        NsSubContractName: Text[250];
        NSSubContMailingAdd: Text[250];
        NSSubContMailingAdd1: text;
        NSSubContMailingAdd2: Text;
        NSSubContMailingAdd3: Text;
        NSSubContMailingAdd4: Text;
        NSSubContMailingAdd5: text;
        NSSubContNo1: Code[20];
        NSJob: Record Job;
        NSClientName: Text[250];
        NSClinetAddress: Text[250];
        NSClinetAddress1: Text;
        NSClinetAddress2: Text;
        NSClinetAddress3: Text;
        NSClinetAddress4: Text;
        NSClinetAddress5: Text;
        NSServiceProvider: Text[250];
        NSJobAddress: Text[250];
        NSJobAddress1: Text[250];
        NSJobAddress2: Text[250];
        NSJobAddress3: Text[250];
        NSJobAddress4: Text[250];
        NSJobAddress5: Text[250];
        NSJobAddress6: Text[250];
        NS_StartDate: Date;
        NS_CompletionDate: Date;
        NS_SubcontractLine: Record "NS_Subcontract Lines";
        NS_TotalCost: Decimal;
        NS_PurchaseHeader: Record "Purchase Header";
        NS_Payterms: Code[10];
        NSDay: Integer;
        NSChangeOrder: Record Job;
        NSChangeOrderNo: Code[20];
        NS_GovLaw: Text[20];
        NS_VendorName: text[250];
        BuildResutstring: text;
        NS_companyAdd: Text[250];
        NS_companyAdd1: Text[250];

        NSMailingadd6: Text[250];

        NSInsuranceType: Code[20];
        NSVenInsAmt: Decimal;
        NSPolicyNo: Code[20];
        NSInsExpiryDate: Date;
        NSMailingadd1: text;
        NSMailingadd2: text;
        NSMailingadd3: text;
        NSMailingadd4: text;
        NSMailingadd5: text;


}