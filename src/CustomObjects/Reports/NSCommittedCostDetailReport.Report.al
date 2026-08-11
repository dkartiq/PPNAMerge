report 14021180 "NS_Committed Cost DetailReport"
{
    //a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-84.SK.1.0 Added report to search
    //GLEI-63:AS:24APRIL2020 Increased the length of "Vendorname" variable from 30 char to 100 char.(For UPP also)
    //PRJ-691.RS.1.0 26May2021| Actual Cost/Billings fast tab does not include Purchase Invoices
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSCommitted Cost Detail Report.rdl';
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Committed Cost Detail Report';
    ApplicationArea = all;

    dataset
    {
        dataitem(Job; Job)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(USERID; USERID)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(JobsFilter; JobsFilter)
            {
            }
            column(PurchaseLineFilter; PurchaseLineFilter)
            {
            }
            column(Job__No__; "No.")
            {
            }
            column(Job_Description; Description)
            {
            }
            column(Purchase_Line___Committed_Amount__LCY__; "Purchase Line"."NS_Committed Amount (LCY)")
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Committed_Cost_DetailCaption; Committed_Cost_DetailCaptionLbl)
            {
            }
            column(JobsFilterCaption; JobsFilterCaptionLbl)
            {
            }
            column(PurchaseLineFilterCaption; PurchaseLineFilterCaptionLbl)
            {
            }
            column(Purchase_Line__Document_No__Caption; "Purchase Line".FIELDCAPTION("Document No."))
            {
            }
            column(Purchase_Line_TypeCaption; "Purchase Line".FIELDCAPTION(Type))
            {
            }
            column(Purchase_Line__No__Caption; "Purchase Line".FIELDCAPTION("No."))
            {
            }
            column(Purchase_Line_DescriptionCaption; "Purchase Line".FIELDCAPTION(Description))
            {
            }
            column(ActivityCodeCaption; ActivityCodeCaptionLbl)
            {
            }
            column(Purchase_Line__Expected_Receipt_Date_Caption; Purchase_Line__Expected_Receipt_Date_CaptionLbl)
            {
            }
            column(VendorNameCaption; VendorNameCaptionLbl)
            {
            }
            column(Purchase_Line__Committed_Quantity_Caption; Purchase_Line__Committed_Quantity_CaptionLbl)
            {
            }
            column(Purchase_Line__Unit_of_Measure_Caption; "Purchase Line".FIELDCAPTION("Unit of Measure"))
            {
            }
            column(Purchase_Line__Unit_Cost_Caption; "Purchase Line".FIELDCAPTION("Unit Cost"))
            {
            }
            column(Purchase_Line__Committed_Amount_Caption; Purchase_Line__Committed_Amount_CaptionLbl)
            {
            }
            column(ProcessCodeCaption; ProcessCodeCaptionLbl)
            {
            }
            column(OperationCodeCaption; OperationCodeCaptionLbl)
            {
            }
            column(Job__No__Caption; Job__No__CaptionLbl)
            {
            }
            column(Report_Total_Caption; Report_Total_CaptionLbl)
            {
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Job No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") ORDER(Ascending)
                where("Document Type" = filter('Order'));//PRJ-691.RS.1.0 26May2021
                RequestFilterFields = "NS_Job Cost Category";
                column(Purchase_Line__Document_No__; "Document No.")
                {
                }
                column(Purchase_Line_Type; Type)
                {
                }
                column(Purchase_Line__No__; "No.")
                {
                }
                column(Purchase_Line_Description; Description)
                {
                }
                column(Purchase_Line__Expected_Receipt_Date_; "Expected Receipt Date")
                {
                }
                column(Purchase_Line__Committed_Quantity_; "NS_Committed Quantity")
                {
                }
                column(Purchase_Line__Unit_of_Measure_; "Unit of Measure")
                {
                }
                column(Purchase_Line__Unit_Cost_; "Unit Cost")
                {
                }
                column(Purchase_Line__Committed_Amount_; "NS_Committed Amount")
                {
                }
                column(ActivityCode; ActivityCode)
                {
                }
                column(VendorName; VendorName)
                {
                }
                column(ProcessCode; ProcessCode)
                {
                }
                column(OperationCode; OperationCode)
                {
                }
                column(Purchase_Line__Committed_Amount__LCY__; "NS_Committed Amount (LCY)")
                {
                }
                column(Job_Total_Caption; Job_Total_CaptionLbl)
                {
                }
                column(Purchase_Line_Document_Type; "Document Type")
                {
                }
                column(Purchase_Line_Line_No_; "Line No.")
                {
                }
                column(Purchase_Line_Job_No_; "Job No.")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    if "Buy-from Vendor No." > '' then
                        if Vendor.GET("Buy-from Vendor No.") then
                            VendorName := Vendor.Name
                        else
                            VendorName := Text001 + "Buy-from Vendor No."
                    else
                        VendorName := '';

                    if "Document Type" = "Document Type"::"Credit Memo" then begin
                        Quantity := -Quantity;
                        "NS_Committed Amount" := -"NS_Committed Amount";
                        "NS_Committed Amount (LCY)" := -"NS_Committed Amount (LCY)";
                    end;

                    Job.NS_JobTaskNoToAPO("Purchase Line"."Job Task No.", ActivityCode, ProcessCode, OperationCode, SectionCode);//PRJ-688.AM.1.0
                end;

                trigger OnPreDataItem();
                begin
                    SETFILTER("NS_Committed Amount", '>0');
                end;
            }

            trigger OnPreDataItem();
            begin
                CurrReport.CREATETOTALS("Purchase Line"."NS_Committed Amount (LCY)");
            end;
        }
    }

    requestpage
    {

        layout
        {
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
        JobsFilter := Job.GETFILTERS();
        PurchaseLineFilter := "Purchase Line".GETFILTERS();
    end;

    var
        Vendor: Record Vendor;
        VendorName: Text[100];//GLEI-63:AS:24APRIL2020
        JobsFilter: Text[250];
        PurchaseLineFilter: Text[250];
        ActivityCode: Code[10];
        ProcessCode: Code[10];
        OperationCode: Code[10];
        SectionCode: Code[10];//PRJ-688.AM.1.0
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Committed_Cost_DetailCaptionLbl: Label 'Committed Cost Detail';
        JobsFilterCaptionLbl: Label 'Jobs Filter:';
        PurchaseLineFilterCaptionLbl: Label 'Purchase Line Filter:';
        ActivityCodeCaptionLbl: Label 'Activity Code';
        Purchase_Line__Expected_Receipt_Date_CaptionLbl: Label 'Expected Receipt';
        VendorNameCaptionLbl: Label 'Vendor Name';
        Purchase_Line__Committed_Quantity_CaptionLbl: Label 'Committed Quantity';
        Purchase_Line__Committed_Amount_CaptionLbl: Label 'Committed Amount';
        ProcessCodeCaptionLbl: Label 'Process Code';
        OperationCodeCaptionLbl: Label 'Operation Code';
        Job__No__CaptionLbl: Label 'Job:';
        Report_Total_CaptionLbl: Label 'Report Total:';
        Job_Total_CaptionLbl: Label 'Job Total:';
        Text001: Label '"Unknown - "';
}

