report 14021403 "NS_Quote Pipeline Report"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-84.SK.1.0 Added report to search
    DefaultLayout = RDLC;
    Caption = 'Quote Pipeline Report';
    RDLCLayout = './Layouts/NSQuote Pipeline Report.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;


    dataset
    {
        dataitem("Job Quote Header"; "NS_Job Quote Header")
        {
            RequestFilterFields = "NS_Quote No.", "NS_Job No.", "NS_Quote Status", "NS_Sell-to Customer No.", "NS_Salesperson Code New", "NS_Estimated Month to Close";//PRJ-867.AS.1.0 23SEPT2021 Changed field Sales Person code to Sales person code New  //PE-300.Dk.1.0  29May2024 Change field NS_Status to "NS_Quote Status"
            column(RepHdr_ReportName; RepHdrReportNameLbl)
            {
            }
            column(RepHdr_PageCaption; RepHdrPageLbl)
            {
            }
            column(RepHdr_Company_Name; CompanyInformation.Name)
            {
            }
            column(Filter_Line; QuoteFilterLbl + FilterLine)
            {
            }
            column(GrpHdr_SalespersonCaption; GrpHdrSalespersonLbl)
            {
            }
            column(GrpTot_TotalCaption; GrpTotTotalLbl)
            {
            }
            column(ColHdr_SellToCustomerNo; ColHdrSellToCustomerNo)
            {
            }
            column(ColHdr_SellToCustomerName; ColHdrSellToCustomerName)
            {
            }
            column(ColHdr_QuoteNot; ColHdrQuoteNo)
            {
            }
            column(ColHdr_Revision; ColHdrRevision)
            {
            }
            column(ColHdr_Description; ColHdrDescription)
            {
            }
            column(ColHdr_ProposalDate; ColHdrProposalDate)
            {
            }
            column(ColHdr_EstimatedMonthToClose; ColHdrEstimatedMonthToClose)
            {
            }
            column(ColHdr_EstimatedCompletionDate; ColHdrEstimatedCompletionDate)
            {
            }
            column(ColHdr_EstimatedPercentToBill; ColHdrEstimatedPercentToBill)
            {
            }
            column(ColHd_Amount; ColHdAmount)
            {
            }
            column(ColHdr_GrossMargin; ColHdrGrossMargin)
            {
            }
            column(ColHdr_GrossMarginPercent; ColHdrGrossMarginPercent)
            {
            }
            column(ColHdr_ProbabilityToClose; ColHdrProbabilityToClose)
            {
            }
            column(ColHdr_Status; ColHdrStatus)
            {
            }
            column(Group_SalespersonName; "Job Quote Header"."NS_Salesperson Name" + ' - ' + "Job Quote Header"."NS_Salesperson Code New")//PRJ-867.AS.1.0 23SEPT2021 Changed field Sales Person code to Sales person code New
            {
            }
            column(Line_SellToCustomerNo; "Job Quote Header"."NS_Sell-to Customer No.")
            {
            }
            column(Line_SellToCustomerName; "Job Quote Header"."NS_Sell-to Customer Name")
            {
            }
            column(Line_QuoteNo; "Job Quote Header"."NS_Quote No.")
            {
            }
            column(Line_Revision; "Job Quote Header".NS_Revision)
            {
            }
            column(Line_Description; "Job Quote Header"."NS_Description/Nickname")
            {
            }
            column(Line_ProposalDate; "Job Quote Header"."NS_Proposal Date")
            {
            }
            column(Line_EstimatedMonthToClose; "Job Quote Header"."NS_Estimated Month to Close")
            {
            }
            column(Line_EstimatedCompletiopnDate; "Job Quote Header"."NS_Estimated Completion Date")
            {
            }
            column(Line_EstimatedPercentToBill; EstimatedPercentToBill)
            {
            }
            column(Line_Amount; "Job Quote Header".NS_Amount)
            {
            }
            column(Line_GrossMargin; "Job Quote Header"."NS_Gross Margin")
            {
            }
            column(Line_GrossMarginPercent; GrossMarginPercent)
            {
            }
            //PE-300.Dk.1.0  29May2024 Start
            // column(Line_ProbabilityToClose; "Job Quote Header"."NS_Probability to Close")
            // {
            // }
            column(Line_ProbabilityToClose; "Job Quote Header"."NS_QuotePro to Close")
            {
            }
            // column(Line_Status; "Job Quote Header".NS_Status)
            // {
            // }
            column(Line_Status; "Job Quote Header"."NS_Quote Status")
            {
            }
            //PE-300.Dk.1.0  29May2024 End

            trigger OnAfterGetRecord();
            var
                Salesperson: Record "Salesperson/Purchaser";
            begin
                CALCFIELDS("NS_Salesperson Name", NS_Amount, "NS_Gross Margin");

                CLEAR(RevisionNo);
                if "NS_Link-to Quote No." <> '' then begin
                    if NS_Revision < RevisionNo then
                        CurrReport.SKIP;
                end;

                EstimatedPercentToBill := FORMAT("NS_Estimated % to Bill") + ' ' + Percent;
                //PE-300-DK.1.0 29May2024 Start
                // ProbabilityValue := "NS_Probability to Close";
                ProbabilityValue := "NS_QuotePro to Close".AsInteger();
                //PE-300-DK.1.0 29May2024 End
                if NS_Amount <> 0 then
                    GrossMarginPercent := FORMAT(ROUND(("NS_Gross Margin" / NS_Amount) * 100, GLSetup."Amount Rounding Precision")) + ' ' + Percent;
            end;

            trigger OnPreDataItem();
            begin
                FilterLine := GETFILTERS;
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
        CompanyInformation.GET;
    end;

    var
        Customer: Record Customer;
        CompanyInformation: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        GrossMarginPct: Decimal;
        ProbabilityValue: Integer;
        RevisionNo: Integer;
        FilterLine: Text[250];
        StatusValue: Text[20];
        EstimatedPercentToBill: Text;
        GrossMarginPercent: Text[30];
        Percent: Label '%';
        RepHdrReportNameLbl: Label 'Quote Pipeline Report';
        RepHdrPageLbl: Label 'Page';
        QuoteFilterLbl: Label 'Quote Filter: ';
        GrpHdrSalespersonLbl: Label 'Salesperson: ';
        GrpTotTotalLbl: Label 'Total ';
        ColHdrSellToCustomerNo: Label 'Customer No.';
        ColHdrSellToCustomerName: Label 'Customer Name';
        ColHdrQuoteNo: Label 'Quote No.';
        ColHdrRevision: Label 'Revision';
        ColHdrDescription: Label 'Description';
        ColHdrProposalDate: Label 'Proposal Date';
        ColHdrEstimatedMonthToClose: Label 'Close Month';
        ColHdrEstimatedCompletionDate: Label 'Estimated Comp. Date';
        ColHdrEstimatedPercentToBill: Label 'Estimated Pct to Bill';
        ColHdAmount: Label 'Amount';
        ColHdrGrossMargin: Label 'Gross Margin';
        ColHdrGrossMarginPercent: Label 'Gross Margin Percent';
        ColHdrProbabilityToClose: Label 'Probablility To Close';
        ColHdrStatus: Label 'Status';
}

