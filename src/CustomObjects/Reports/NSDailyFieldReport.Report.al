report 14021421 "NS_Daily Field Report"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-84.SK.1.0 Added report to search
    //PRJ-195.MS.1.0 SignatureLabel change var length from 30 to 50
    //   - modify the layout of report    
    //PRJ-223.MS.1.0 added two new field and modify the layout of report
    //JD-10:AS:27APRIL2020 : Created New Report by Saving Report "14021288".
    //JD-10:AS:27APRIL2020 : Here "JobCostCategory" is used as "JobNo." & in layout has very important group on it.
    //JD-42.NS.1.0 add condition of DFR no creation
    //JD-44.NS.1.0 12Aug2020 Add filter not required line type budget
    //JD-54.AM.1.0 Added new conditions on Predataitem and new column added.added new grouping in layout. 
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSDaily Field Report.rdl';
    Caption = 'Daily Field Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;


    dataset
    {
        dataitem(Job; Job)
        {
            RequestFilterFields = "No.";
            column(WorkOrderNo; Job."No.")
            {
            }
            column(WorkOrderDate; TODAY)
            {
            }
            column(WorkOrderManager; Job.NS_Manager)
            {
            }
            column(WorkOrderCustAddress; BilltoAddress)
            {
            }
            column(WorkOrderCustAddress2; BilltoAddress2)
            {
            }
            column(WorkOrderCustName; "Bill-to Name")
            {
            }
            column(WorkOrderCustPhone; BilltoPhone)
            {
            }
            column(WorkOrderDescription; Job.Description)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddress; CompAddress)
            {
            }
            column(CompanyPhone; CompPhone)
            {
            }
            column(CompanyLogo; CompanyInfo.Picture)
            {
            }
            column(FooterSignatureLabel; SignatureLabel)
            {
            }
            column(FooterDateLabel; DateLabel)
            {
            }
            column(FooterCustSignatureLabel; CustSignatureLabel)
            {
            }

            dataitem("Job Planning Line"; "Job Planning Line")
            {
                DataItemTableView = sorting("Line No.") order(ascending);
                DataItemLinkReference = job;
                DataItemLink = "Job No." = field("No.");
                RequestFilterFields = "NS_DFR No.";

                column(JobCostCategory; "Job No.")//JD-10:AS:27APRIL2020
                {
                }

                column(JobCostCatDesc; Description)
                {
                }
                column(Detail_CostCategory; "Job Planning Line"."Job No.")//JD-10:AS:27APRIL2020
                {
                }
                column(Detail_WorkOrderDate; "Job Planning Line"."Planning Date")
                {
                }
                column(Detail_Type; "Job Planning Line".Type)
                {
                }
                column(Detail_No; "Job Planning Line"."No.")
                {
                }
                column(Detail_Description; "Job Planning Line".Description)
                {
                }
                column(Detail_Quantity; "Job Planning Line".Quantity)
                {
                }
                column(Detail_Rate; "Job Planning Line"."Unit Price")
                {
                }
                column(Detail_Total; "Job Planning Line"."Line Amount")
                {
                }

                column(Skill_Code; "Job Planning Line"."NS_Skill Class")
                {
                }
                column(Work_TYpe_Code; "Job Planning Line"."Work Type Code")
                {
                }
                column(DFRnoVar; "Job Planning Line"."NS_DFR No.")
                {
                }
                //JD-54.AM.1.0 start
                column(DFRNo; "Job Planning Line"."NS_DFR No.")
                {

                }
                column(IsDFRcreate; IsDFRcreate)
                {

                }
                //JD-54.AM.1.0 end
                trigger OnPreDataItem();
                var
                    NoSeriesMgt: Codeunit 396;
                begin
                    if (startdate <> 0D) and (enddate <> 0D) then //JD-54.AM.1.0 
                        "Job Planning Line".SetRange("Planning Date", startdate, enddate);
                    // "Job Planning Line".SetFilter("Line Type", '%1', "Job Planning Line"."Line Type"::Billable); //JD-44.NS.1.0 12Aug2020 code comment
                    "Job Planning Line".SetFilter("Line Type", '<>%1', "Job Planning Line"."Line Type"::Budget); //JD-44.NS.1.0 12Aug2020
                    //if (IsDFRcreate) then //JD-42.NS.1.0 code comment
                    if (IsDFRcreate) AND (startdate <> 0D) then //JD-42.NS.1.0
                        NoSeriesMgt.InitSeries(Job."NS_DFR Nos.", Job."NS_DFR Nos.", 0D, DFRnoVar, Job."NS_DFR Nos.");
                end;

                trigger OnAfterGetRecord()
                begin

                    if IsDFRcreate then begin
                        "Job Planning Line"."NS_DFR Created" := true;
                        "NS_DFR No." := DFRnoVar;
                        Modify();
                    end;
                    if "NS_DFR No." = '' then
                        CurrReport.Skip();
                end;

            }

            trigger OnAfterGetRecord();
            var
                Cust: Record Customer;
                EntryNo: Integer;
                PlanLineLocal: Record "Job Planning Line";

            begin
                if IsDFRcreate then begin
                    TestField("NS_DFR Nos.");
                    PlanLineLocal.Reset();
                    PlanLineLocal.SetRange("Job No.", "No.");
                    PlanLineLocal.SetRange("Planning Date", startdate, enddate);
                    PlanLineLocal.SetFilter("NS_DFR No.", '<>%1', '');
                    if PlanLineLocal.FindFirst() then
                        Error('DFR no. is already created for this period');
                end;
                if Job."Bill-to Customer No." <> '' then
                    Cust.GET(Job."Bill-to Customer No.");

                CompanyInfo.GET;
                CompanyInfo.CALCFIELDS(Picture);
                BilltoAddress := Job."Bill-to Address" + ', ' + Job."Bill-to Address 2";
                BilltoAddress2 := Job."Bill-to City" + ' ' + Job."Bill-to County" + ' ' + Job."Bill-to Post Code";
                BilltoPhone := 'Phone: ' + Cust."Phone No.";
                CompAddress := CompanyInfo.Address;
                if CompanyInfo."Address 2" <> '' then
                    CompAddress := CompAddress + ', ' + CompanyInfo."Address 2";
                CompAddress := CompAddress + ' ' + CompanyInfo.City + ' ' + CompanyInfo.County + ' ' + CompanyInfo."Post Code";
                CompPhone := 'Phone: ' + CompanyInfo."Phone No." + ' Fax: ' + CompanyInfo."Fax No.";
                SignatureLabel := STRSUBSTNO(Text001, CompanyInfo.Name);
            end;

            trigger OnPreDataItem();
            begin
                if JobNoFilter <> '' then
                    Job.SETFILTER("No.", JobNoFilter);
                DFRnoVar := '';

            end;

        }
    }
    requestpage
    {

        // SaveValues = true;//PRJ-425.AM.1.0
        layout
        {
            area(Content)
            {

                group(DateFilters)
                {
                    field(startdate; startdate)
                    {
                        ApplicationArea = jobs;
                        Caption = 'Planning Start Date';
                    }
                    field(enddate; enddate)
                    {
                        ApplicationArea = jobs;
                        Caption = 'Planning End Date';
                    }
                    field(IsDFRcreate; IsDFRcreate)
                    {
                        Caption = 'DFR No. Create';
                        ApplicationArea = jobs;

                    }
                }
            }
        }

        actions
        {

        }

        trigger OnOpenPage()
        begin
            //  IsDFRcreate := false; //PRJ-425.AM.1.0
        end;
    }

    labels
    {
    }

    var
        BilltoAddress: Text[120];
        BilltoAddress2: Text[120];
        BilltoPhone: Text[60];
        ActivityCodes: Text[1000];
        JobDescription: Text[1000];
        CompAddress: Text[120];
        CompAddress2: Text[120];
        CompPhone: Text[60];
        CompanyInfo: Record "Company Information";
        Text001: Label '%1 Signature';
        DateLabel: Label 'Date';
        CustSignatureLabel: Label 'Customer Signature';
        CostCategoryCode: Code[20];
        CompName: Text[120];
        TempLedgEntryCount: Integer;
        RowCount: Integer;
        SignatureLabel: Text[50]; //PRJ-195.MS.1.0 Modified
        JobNoFilter: Text[60];
        startdate: Date;
        enddate: Date;
        IsDFRcreate: Boolean;
        DFRnoVar: Code[20];
        DFRNo: Code[20];//JD-54.AM.1.0

    procedure NS_SetFilter(PassJobNoFilter: Text[60]);
    begin
        JobNoFilter := PassJobNoFilter;
    end;
}

