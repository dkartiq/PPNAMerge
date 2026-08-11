report 14021493 "NS_Cost & BillingReportDetail"
{
    //PRJ-1145.AS.1.0 15FEB2022 Created New Report
    //PRJ-1643.SM.1.0 Done cahnges in layout

    UsageCategory = ReportsAndAnalysis;
    Caption = 'Cost & Billing Report Detailed';
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSCostBillingreportDetailed.rdl';

    dataset
    {
        dataitem("Job Ledger Entry"; "Job Ledger Entry")
        {
            RequestFilterFields = "Job No.", "Posting Date", "Job Task No.", "NS_Job Cost Category", "Global Dimension 1 Code";
            column(Posting_Date; "Posting Date")
            {

            }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code")
            {

            }
            column(Document_No_; "Document No.")
            {

            }
            column(External_Document_No_; "External Document No.")
            {

            }
            column(NS_Job_Cost_Category; "NS_Job Cost Category")
            {

            }
            column(Quantity; Quantity)
            {

            }
            column(postingDateFilter; postingDateFilter)
            {

            }
            column(Job_Task_No_; "Job Task No.")
            {

            }
            column(Job_No_; "Job No.")
            {

            }
            column(CostAmt; CostAmt)
            {

            }
            //PE-141.AS.1.0 14AUG2023 start
            column(TIME; TIME)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name) { }
            column(CompanyInformationPic; CompanyInformation.Picture) { }
            column(CompanyInformationAdd; CompanyInformation.Address) { }
            column(CompanyInformationadd2; CompanyInformation."Address 2") { }
            column(CompanyInformationcity; CompanyInformation.City) { }
            column(CompanyInformationRegion; CompanyInformation."Country/Region Code") { }
            column(CompanyInformationpost; CompanyInformation."Post Code") { }
            column(CompanyInformationCountry; CompanyInformation.County) { }
            column(CompanyInformationPhone; CompanyInformation."Phone No.") { }
            column(NS_CompanyFullAddress; NS_CompanyFullAddress) { }//PE-141.AS.1.0 24AUG2023
            //PE-141.AS.1.0 14AUG2023 end
            column(BillingAmt; BillingAmt)
            {

            }
            column(Dimen_Name; Rec_DimensionValue.Name)
            {

            }
            column(Rec_JobDescr; Rec_Job.Description)
            {

            }
            column(Rec_JobTaskDesc; Rec_JobTask.Description)
            {

            }
            column(NS_External_Relationship_No_; "NS_External Relationship No.")
            {

            }
            column(NS_External_Relationship_Name; "NS_External Relationship Name")
            {

            }
            column(ViewonlySummary; ViewonlySummary)
            {

            }
            trigger OnPreDataItem()
            begin
                JobNoFilter := "Job Ledger Entry".GetFilter("Job No.");
                IF JobNoFilter = '' then;
                // Error('Job No. Filter is Mandatory !');
                postingDateFilter := "Job Ledger Entry".GetFilter("Posting Date");
            end;

            trigger OnAfterGetRecord()
            begin
                Clear(BillingAmt);
                Clear(CostAmt);
                IF "Job Ledger Entry"."Entry Type" = "Job Ledger Entry"."Entry Type"::Sale then begin
                    IF "Job Ledger Entry"."Line Amount" < 0 then
                        BillingAmt := ABS("Job Ledger Entry"."Line Amount")
                    ELSE
                        BillingAmt := -1 * "Job Ledger Entry"."Line Amount";
                end
                else
                    CostAmt := "Total Cost";
                IF (CostAmt = 0) AND (BillingAmt = 0) then
                    CurrReport.Skip();

                Rec_DimensionValue.Reset();
                Rec_DimensionValue.SetRange(Code, "Job Ledger Entry"."Global Dimension 1 Code");
                IF Rec_DimensionValue.FindFirst() then;

                IF Rec_Job.Get("Job Ledger Entry"."Job No.") then;
                IF Rec_JobTask.Get("Job Ledger Entry"."Job No.", "Job Ledger Entry"."Job Task No.") then;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(ViewonlySummary; ViewonlySummary)
                    {
                        ApplicationArea = All;
                        Caption = 'Summary';

                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    trigger OnPreReport();
    begin
        //PE-141.AS.1.0 14AUG2023 start
        CompanyInformation.GET;
        CompanyInformation.CalcFields(Picture);
        //PE-141.AS.1.0 14AUG2023 end

        //PE-141.AS.1.0 start 24Aug2023
        if CompanyInformation.Address = '' then
            NS_CompanyInformationAdd := ''
        else
            NS_CompanyInformationAdd := CompanyInformation.Address;
        if CompanyInformation."Address 2" = '' then
            NS_CompanyInformationadd2 := ''
        else
            NS_CompanyInformationadd2 := CompanyInformation."Address 2";

        if CompanyInformation.City = '' then
            NS_CompanyInformationcity := ''
        else
            NS_CompanyInformationcity := CompanyInformation.City + ',' + ' ';
        if CompanyInformation.County = '' then
            NS_CompanyInformationCountry := ''
        else
            NS_CompanyInformationCountry := CompanyInformation.County + ' ';
        if CompanyInformation."Post Code" = '' then
            NS_CompanyInformationpost := ''
        else
            NS_CompanyInformationpost := CompanyInformation."Post Code";
        NS_CompanyFullAddress := NS_CompanyInformationcity + NS_CompanyInformationCountry + NS_CompanyInformationpost;

        //PE-141.AS.1.0 start 24Aug2023
    end;

    var
        myInt: Integer;
        JobNoFilter: Code[20];
        postingDateFilter: Text[50];
        BillingAmt: Decimal;
        CostAmt: Decimal;
        Rec_DimensionValue: Record "Dimension Value";
        Rec_Job: Record Job;
        Rec_JobTask: Record "Job Task";
        ViewonlySummary: Boolean;
        CompanyInformation: Record "Company Information";//PE-141.AS.1.0 14AUG2023
                                                         //PE-141.AS.1.0 start 24Aug2023 
        NS_CompanyInformationAdd: Text[250];
        NS_CompanyInformationadd2: Text[250];
        NS_CompanyInformationcity: Text;
        NS_CompanyInformationRegion: Code[20];
        NS_CompanyInformationpost: Code[20];
        NS_CompanyInformationCountry: Text[250];
        NS_CompanyFullAddress: Text[250];
    //PE-141.AS.1.0 24Aug2023 
}