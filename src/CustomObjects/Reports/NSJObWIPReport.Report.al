report 14021183 "NS_Job WIP Report"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //SMPL - captions can't be used on area
    //PRJ-84.SK.1.0 Added report to search
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSJob WIP Report.rdl';
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Job WIP Report';
    ApplicationArea = all;

    dataset
    {
        dataitem(Job; Job)
        {
            RequestFilterFields = "No.", "NS_Date Filter";
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(Filters1; Filters1)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Job_WIP_ReportCaption; Job_WIP_ReportCaptionLbl)
            {
            }
            column(Filters1Caption; Filters1CaptionLbl)
            {
            }
            column(Job_No_Caption; Job_No_CaptionLbl)
            {
            }
            column(Job_NameCaption; Job_NameCaptionLbl)
            {
            }
            column(WIP_CostCaption; WIP_CostCaptionLbl)
            {
            }
            column(WIP_Cost_Posted_to_G_LCaption; WIP_Cost_Posted_to_G_LCaptionLbl)
            {
            }
            column(WIP_SalesCaption; WIP_SalesCaptionLbl)
            {
            }
            column(WIP_Sales_Posted_to_G_LCaption; WIP_Sales_Posted_to_G_LCaptionLbl)
            {
            }
            column(Recog__SalesCaption; Recog__SalesCaptionLbl)
            {
            }
            column(Recog__Sales_Posted_to_G_LCaption; Recog__Sales_Posted_to_G_LCaptionLbl)
            {
            }
            column(Recog__CostsCaption; Recog__CostsCaptionLbl)
            {
            }
            column(Recog__Costs_Posted_to_G_LCaption; Recog__Costs_Posted_to_G_LCaptionLbl)
            {
            }
            column(Job__WIP_Method_Caption; FIELDCAPTION("WIP Method"))
            {
            }
            column(FINAL_TOTAL_Caption; FINAL_TOTAL_CaptionLbl)
            {
            }
            column(Job_No_; "No.")
            {
            }
            column(Job__WIP_Method_; Job."WIP Method")
            {
            }
            column(Job_Description; Job.Description)
            {
            }
            column(Job__No__; Job."No.")
            {
            }
            column(WIP_Cost; JobBuffer."Total WIP Cost Amount")
            {
            }
            column(WIP_Cost_Posted_to_G_L; JobBuffer."Total WIP Cost G/L Amount")
            {
            }
            column(WIP_Sales; JobBuffer."Total WIP Sales Amount")
            {
            }
            column(WIP_Sales_Posted_to_G_L; JobBuffer."Total WIP Sales G/L Amount")
            {
            }
            column(Recog__Sales; JobBuffer."Recog. Sales Amount")
            {
            }
            column(Recog__Sales_Posted_to_G_L; JobBuffer."Recog. Sales G/L Amount")
            {
            }
            column(Recog__Costs; JobBuffer."Recog. Costs Amount")
            {
            }
            column(Recog__Costs_Posted_to_G_L; JobBuffer."Recog. Costs G/L Amount")
            {
            }

            trigger OnAfterGetRecord();
            begin
                BuildJobToPrint;

                if ("NS_Sub-Level to Job No." > '') and "IncludeSub-Levels" then
                    CurrReport.SKIP;

                if BalancesOnly then
                    if (JobBuffer."Total WIP Cost Amount" = 0) and
                       (JobBuffer."Total WIP Cost G/L Amount" = 0) and
                       (JobBuffer."Total WIP Sales Amount" = 0) and
                       (JobBuffer."Total WIP Sales G/L Amount" = 0) and
                       (JobBuffer."Recog. Costs Amount" = 0) and
                       (JobBuffer."Recog. Costs G/L Amount" = 0) and
                       (JobBuffer."Recog. Sales Amount" = 0) and
                       (JobBuffer."Recog. Sales G/L Amount" = 0) then
                        CurrReport.SKIP;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                //SMPL Start - CaptionML = ENU='<Control1>',
                //SMPL End -         ENA='RequestPage';
                group(Options)
                {
                    field("Include Sub-Levels"; "IncludeSub-Levels")
                    {
                        Caption = 'Include Sub-Levels';
                        ApplicationArea = All;
                    }
                    field("Show Only Jobs With Balances"; BalancesOnly)
                    {
                        Caption = 'Show Only Jobs With Balances';
                        ApplicationArea = All;
                    }
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

    trigger OnInitReport();
    begin
        BalancesOnly := true;
    end;

    trigger OnPreReport();
    begin
        Filters1 := Job.GETFILTERS();
    end;

    var
        Job2: Record Job;
        JobBuffer: Record Job temporary;
        Filters1: Text[250];
        "IncludeSub-Levels": Boolean;
        BalancesOnly: Boolean;
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Job_WIP_ReportCaptionLbl: Label 'Job WIP Report';
        Filters1CaptionLbl: Label 'Jobs:';
        Job_No_CaptionLbl: Label 'Job No.';
        Job_NameCaptionLbl: Label 'Job Name';
        WIP_CostCaptionLbl: Label 'WIP Cost';
        WIP_Cost_Posted_to_G_LCaptionLbl: Label 'WIP Cost Posted to G/L';
        WIP_SalesCaptionLbl: Label 'WIP Sales';
        WIP_Sales_Posted_to_G_LCaptionLbl: Label 'WIP Sales Posted to G/L';
        Recog__SalesCaptionLbl: Label 'Recog. Sales';
        Recog__Sales_Posted_to_G_LCaptionLbl: Label 'Recog. Sales Posted to G/L';
        Recog__CostsCaptionLbl: Label 'Recog. Costs';
        Recog__Costs_Posted_to_G_LCaptionLbl: Label 'Recog. Costs Posted to G/L';
        FINAL_TOTAL_CaptionLbl: Label 'FINAL TOTAL:';
    // JobWIPBuffer__Job_No__CaptionLbl: Label 'Job No.';
    // FORMAT_JobWIPBuffer__WIP_Method__CaptionLbl: Label 'WIP Method';
    // FORMAT_JobWIPBuffer_Type_CaptionLbl: Label 'Type';
    // JobWIPBuffer__G_L_Account_No__CaptionLbl: Label 'G/L Account No.';
    // JobWIPBuffer__WIP_Entry_Amount_CaptionLbl: Label 'WIP Entry Amount';
    // JobWIPBuffer__WIP_Schedule__Total_Cost__CaptionLbl: Label 'WIP Schedule (Total Cost)';
    // JobWIPBuffer__WIP_Schedule__Total_Price__CaptionLbl: Label 'WIP Schedule (Total Price)';
    // JobWIPBuffer__WIP_Usage__Total_Cost__CaptionLbl: Label 'WIP Usage (Total Cost)';
    // JobWIPBuffer__WIP_Usage__Total_Price__CaptionLbl: Label 'WIP Usage (Total Price)';
    // JobWIPBuffer__WIP_Contract__Total_Cost__CaptionLbl: Label 'WIP Contract (Total Cost)';
    // JobWIPBuffer__WIP_Contract__Total_Price__CaptionLbl: Label 'WIP Contract (Total Price)';
    // JobWIPBuffer__WIP__Invoiced_Price__CaptionLbl: Label 'WIP (Invoiced Price)';
    // JobWIPBuffer__WIP__Invoiced_Cost__CaptionLbl: Label 'WIP (Invoiced Cost)';

    procedure BuildJobToPrint();
    begin
        Job2.RESET;
        Job2 := Job;
        Job2.COPYFILTERS(Job);
        Job2.SETFILTER("No.", Job."No.");
        Job2."MarkSub-Levels"(Job2, "IncludeSub-Levels");
        CLEAR(JobBuffer);
        Job2.MARKEDONLY(true);

        if Job2.FINDSET then
            repeat
                Job2.CALCFIELDS("Total WIP Cost Amount",
                                "Total WIP Cost G/L Amount",
                                "Total WIP Sales Amount",
                                "Total WIP Sales G/L Amount",
                                "Recog. Costs Amount",
                                "Recog. Costs G/L Amount",
                                "Recog. Sales Amount",
                                "Recog. Sales G/L Amount");
                JobBuffer."Total WIP Cost Amount" := JobBuffer."Total WIP Cost Amount" + Job2."Total WIP Cost Amount";
                JobBuffer."Total WIP Cost G/L Amount" := JobBuffer."Total WIP Cost G/L Amount" + Job2."Total WIP Cost G/L Amount";
                JobBuffer."Total WIP Sales Amount" := JobBuffer."Total WIP Sales Amount" + Job2."Total WIP Sales Amount";
                JobBuffer."Total WIP Sales G/L Amount" := JobBuffer."Total WIP Sales G/L Amount" + Job2."Total WIP Sales G/L Amount";
                JobBuffer."Recog. Costs Amount" := JobBuffer."Recog. Costs Amount" + Job2."Recog. Costs Amount";
                JobBuffer."Recog. Costs G/L Amount" := JobBuffer."Recog. Costs G/L Amount" + Job2."Recog. Costs G/L Amount";
                JobBuffer."Recog. Sales Amount" := JobBuffer."Recog. Sales Amount" + Job2."Recog. Sales Amount";
                JobBuffer."Recog. Sales G/L Amount" := JobBuffer."Recog. Sales G/L Amount" + Job2."Recog. Sales G/L Amount";
            until Job2.NEXT = 0;
    end;
}

