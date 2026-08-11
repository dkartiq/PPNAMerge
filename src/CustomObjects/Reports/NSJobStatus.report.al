report 14021175 "NS_Job Status"
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
    Caption = 'Job Status';
    RDLCLayout = './Layouts/NSJob Status.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;


    dataset
    {
        dataitem(Job; Job)
        {
            column(ReportTitle; ReportTitle)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(TIME; TIME)
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(PageNoCaption; PageNoCaption)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(USERID; USERID)
            {
            }
            column(SubTitle; SubTitle)
            {
            }
            column(DateTitle; DateTitle)
            {
            }
            column(JobNoCaption; JobNoCaption)
            {
            }
            column(Job_No_; Job."No.")
            {
            }
            column(JobDescriptionCaption; JobDescriptionCaption)
            {
            }
            column(Job_Description; Job.Description)
            {
            }
            column(Job_Description_2; Job."Description 2")
            {
            }
            column(JobStatusCaption; JobStatusCaption)
            {
            }
            column(Job_Status; Job.Status)
            {
            }
            column(JobStatusDateCaption; JobStatusDateCaption)
            {
            }
            column(Job_Job_Status_Date; Job."NS_Job Status Date")
            {
            }
            column(JobContractNoCaption; JobContractNoCaption)
            {
            }
            column(Job_Contract_No_; Job."NS_Contract No.")
            {
            }
            column(JobContractDateCaption; JobContractDateCaption)
            {
            }
            column(Job_Contract_Date; Job."NS_Contract Date")
            {
            }
            column(JobSubLevelToJobNoCaption; JobSubLevelToJobNoCaption)
            {
            }
            column(Job_Sub_Level_to_Job_No_; Job."NS_Sub-Level to Job No.")
            {
            }
            column(CONTRACTINFOCaption; CONTRACTINFOCaption)
            {
            }
            column(JobBudgetedPriceCaption; JobBudgetedPriceCaption)
            {
            }
            column(Job_Budgeted_Price__LCY_; Job."NS_Budgeted Price (LCY)")
            {
            }
            column(SubLevelesPriceCaption; SubLevelsPriceCaption)
            {
            }
            column(Sub_LevelsPrice; "Sub-LevelsPrice")
            {
            }
            column(NetPriceCaption; NetPriceCaption)
            {
            }
            column(NetPrice; NetPrice)
            {
            }
            column(JOBINFOCaption; JOBINFOCaption)
            {
            }
            column(JobAddressCaption; JobAddressCaption)
            {
            }
            column(JobSiteAddress_1_; JobSiteAddress[1])
            {
            }
            column(JobSiteAddress_2_; JobSiteAddress[2])
            {
            }
            column(JobSiteAddress_3_; JobSiteAddress[3])
            {
            }
            column(JobSiteAddress_4_; JobSiteAddress[4])
            {
            }
            column(JobSiteAddress_5_; JobSiteAddress[5])
            {
            }
            column(JobContactCaption; JobContactCaption)
            {
            }
            column(Job_Job_Contact; Job."NS_Job Contact")
            {
            }
            column(JobJobPhoneCaption; JobJobPhoneCaption)
            {
            }
            column(Job_Job_Phone; Job."NS_Job Phone")
            {
            }
            column(JobEstimatorCaption; JobEstimatorCaption)
            {
            }
            column(Job_Estimator; Job.NS_Estimator)
            {
            }
            column(JobManagerCaption; JobManagerCaption)
            {
            }
            column(Job_Manager; Job.NS_Manager)
            {
            }
            column(CUSTOMERINFOCaption; CUSTOMERINFOCaption)
            {
            }
            column(CustAddressCaption; CustAddressCaption)
            {
            }
            column(JobBillToAddress_1_; JobBillToAddress[1])
            {
            }
            column(JobBillToAddress_2_; JobBillToAddress[2])
            {
            }
            column(JobBillToAddress_3_; JobBillToAddress[3])
            {
            }
            column(JobBillToAddress_4_; JobBillToAddress[4])
            {
            }
            column(JobBillToAddress_5_; JobBillToAddress[5])
            {
            }
            column(CustContactCaption; CustContactCaption)
            {
            }
            column(Job_Bill_to_Contact; Job."Bill-to Contact")
            {
            }
            column(BILLINGINFOCaption; BILLINGINFOCaption)
            {
            }
            column(PONumberCaption; PONumberCaption)
            {
            }
            column(Job_Customer_PO_Number; Job."NS_Customer PO Number")
            {
            }
            column(BillingMethodCaption; BillingMethodCaption)
            {
            }
            column(Job_Billing_Method; Job."NS_Billing Method")
            {
            }
            column(CONTRACTBILLINGSCaption; CONTRACTBILLINGSCaption)
            {
            }
            column(GrossBillingCaption; GrossBillingCaption)
            {
            }
            column(RetentionCaption; RetentionCaption)
            {
            }
            column(NetBillingsCaption; NetBillingsCaption)
            {
            }
            column(PaymentsCaption; PaymentsCaption)
            {
            }
            column(BalanceCaption; BalanceCaption)
            {
            }
            column(InvoicedPrice; InvoicedPrice)
            {
            }
            column(RetentionAmount; RetentionAmount)
            {
            }
            column(NetBillings; NetBillings)
            {
            }
            column(PaymentReceived; PaymentReceived)
            {
            }
            column(Balance; Balance)
            {
            }
            column(JOBCOSTINGINFOCaption; JOBCOSTINGINFOCaption)
            {
            }
            column(CurrentPeriodCaption; CurrentPeriodCaption)
            {
            }
            column(YearToDateCaption; YearToDateCaption)
            {
            }
            column(TotalJobCostCaption; TotalJobCostCaption)
            {
            }
            column(TotalJobBillingCaption; TotalJobBillingCaption)
            {
            }
            column(BillingCostCaption; BillingCostCaption)
            {
            }
            column(OpenARCaption; OpenARCaption)
            {
            }
            column(OpenAPCaption; OpenAPCaption)
            {
            }
            column(CashFlowCaption; CashFlowCaption)
            {
            }
            column(CurrentPeriod; CurrentPeriod)
            {
            }
            column(YearToDate; YearToDate)
            {
            }
            column(UsageCost; UsageCost)
            {
            }
            column(Billing_Cost; "Billing-Cost")
            {
            }
            column(OpenAR; OpenAR)
            {
            }
            column(OpenAP; OpenAP)
            {
            }
            column(CashFlow; CashFlow)
            {
            }
            column(JOBDATESINFOCaption; JOBDATESINFOCaption)
            {
            }
            column(CreationDateCaption; CreationDateCaption)
            {
            }
            column(EstimatedStartDateCaption; EstimatedStartDateCaption)
            {
            }
            column(StartDateCaption; StartDateCaption)
            {
            }
            column(EstimatedCompletionDateCaption; EstimatedCompletionDateCaption)
            {
            }
            column(CompletionDateCaption; CompletionDateCaption)
            {
            }
            column(EndingDateCaption; EndingDateCaption)
            {
            }
            column(Job_Creation_Date; Job."Creation Date")
            {
            }
            column(Job_Estimated_Start_Date; Job."NS_Estimated Start Date")
            {
            }
            column(Job_Starting_Date; Job."Starting Date")
            {
            }
            column(Job_Estimated_Completion_Date; Job."NS_Estimated Completion Date")
            {
            }
            column(Job_Completion_Date; Job."NS_Completion Date")
            {
            }
            column(Job_Ending_Date; Job."Ending Date")
            {
            }
            column(BUDGETVSACTUALCaption; BUDGETVSACTUALCaption)
            {
            }
            column(BudgetedCostCaption; BudgetedCostCaption)
            {
            }
            column(BudgetedPriceCaption; BudgetedPriceCaption)
            {
            }
            column(BudgetedProfitCaption; BudgetedProfitCaption)
            {
            }
            column(ActualCostCaption; ActualCostCaption)
            {
            }
            column(ActualPriceCaption; ActualPriceCaption)
            {
            }
            column(ActualProfitToDateCaption; ActualProfitToDateCaption)
            {
            }
            column(BudgetedCost; BudgetedCost)
            {
            }
            column(BudgetedPrice; BudgetedPrice)
            {
            }
            column(BudgetedProfit; BudgetedProfit)
            {
            }
            column(BudgetVariancePercentCaption; BudgetVariancePercentCaption)
            {
            }
            column(ActCostVariance_; "ActCostVariance%")
            {
            }
            column(ActPriceVariance_; "ActPriceVariance%")
            {
            }
            column(ActProfitVariance_; "ActProfitVariance%")
            {
            }
            dataitem("Comment Line"; "Comment Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("Table Name", "No.", "Line No.") WHERE("Table Name" = CONST(Job));
                column(Comment_Line_Date; "Comment Line".Date)
                {
                }
                column(Comment_Line_Comment; "Comment Line".Comment)
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                if "IncludeSub-Levels" and not "ShowSub-Levels" and
                   ("NS_Sub-Level to Job No." > '') then
                    CurrReport.SKIP;

                if NewPagePerJob and FirstJobPrinted then
                    CurrReport.NEWPAGE;

                Job.CALCFIELDS("NS_Budgeted Price (LCY)");
                Job.CALCFIELDS("NS_Budgeted Cost (LCY)");
                Job.CALCFIELDS("NS_Invoiced Price (LCY)");
                Job.CALCFIELDS("NS_Usage (Cost) (LCY)");
                Job.CALCFIELDS("NS_Usage (Price) (LCY)");

                BudgetedPrice := Job."NS_Budgeted Price (LCY)";
                BudgetedCost := Job."NS_Budgeted Cost (LCY)";
                BudgetedProfit := BudgetedPrice - BudgetedCost;
                InvoicedPrice := Job."NS_Invoiced Price (LCY)";
                UsageCost := Job."NS_Usage (Cost) (LCY)";
                UsagePrice := Job."NS_Usage (Price) (LCY)";

                if "IncludeSub-Levels" and not "ShowSub-Levels" then begin
                    BudgetedPrice := BudgetedPrice + Job.NS_SLsBudgetedPrice(Job);
                    BudgetedCost := BudgetedCost + Job.NS_SLsBudgetedCost(Job);
                    InvoicedPrice := InvoicedPrice + Job.SLsInvoicedPrice(Job);
                    UsageCost := UsageCost + Job."SLsUsage(Cost)"(Job);
                    UsagePrice := UsagePrice + Job."SLsUsage(Price)"(Job);
                end;

                "Sub-LevelsPrice" := Job.NS_SLsBudgetedPrice(Job);
                NetPrice := Job."NS_Budgeted Price (LCY)" + "Sub-LevelsPrice";
                RetentionAmount := Job.RetentionBalance(Job, '', '');
                NetBillings := InvoicedPrice - RetentionAmount;
                Balance := InvoicedPrice - RetentionAmount - PaymentReceived;
                ActualProfitToDate := InvoicedPrice - UsageCost;
                if "IncludeSub-Levels" and not "ShowSub-Levels" then
                    RetentionAmount := RetentionAmount + Job.SLsRetentionBalance(Job);

                MTD := FORMAT(DMY2DATE(1, DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3))) + '..' + FORMAT(WORKDATE());
                YTD := FORMAT(DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3))) + '..' + FORMAT(WORKDATE());

                JobLedgEntry.RESET;
                JobLedgEntry.SETCURRENTKEY("Job No.", "Entry Type", "Posting Date");
                JobLedgEntry.SETRANGE("Job No.", "No.");
                JobLedgEntry.SETRANGE("Entry Type", JobLedgEntry."Entry Type"::Usage);
                JobLedgEntry.SETFILTER("Posting Date", MTD);
                JobLedgEntry.CALCSUMS("Total Cost");
                CurrentPeriod := JobLedgEntry."Total Cost";

                JobLedgEntry.SETFILTER("Job No.", "No.");
                JobLedgEntry.SETFILTER("Posting Date", YTD);
                JobLedgEntry.CALCSUMS("Total Cost");
                YearToDate := JobLedgEntry."Total Cost";
                if "IncludeSub-Levels" and not "ShowSub-Levels" then
                    YearToDate := YearToDate + "SLsUsage(Cost)"(Job);
                "Billing-Cost" := InvoicedPrice - UsageCost;

                FormatAddress.NS_JobSite(JobSiteAddress, Job);
                FormatAddress.NS_JobBillTo(JobBillToAddress, Job);

                //Find Payments Received
                CLEAR(PaymentReceived);
                with JobLedgEntry do begin
                    RESET;
                    SETCURRENTKEY("Job No.", "Entry Type", "Posting Date", Type);
                    SETRANGE("Job No.", Job."No.");
                    SETRANGE("Entry Type", "Entry Type"::NS_Payment);
                    SETRANGE("Posting Date", 0D, WORKDATE);
                    CALCSUMS("Total Price");
                    PaymentReceived := "Total Price";
                    if "IncludeSub-Levels" then begin
                        Job.SETRANGE("NS_Date Filter");
                        PaymentReceived := PaymentReceived + SLsPaymentReceived(Job);
                    end;
                end;


                //Find Open Accounts Payable
                DocNoHold := '';
                PurchInvLine.RESET;
                PurchInvLine.SETCURRENTKEY("Job No.", "Document No.");
                PurchInvLine.SETRANGE("Job No.", Job."No.");
                if PurchInvLine.FIND('-') then
                    repeat
                        if PurchInvLine."Document No." <> DocNoHold then begin
                            DocNoHold := PurchInvLine."Document No.";
                            VendLedgEntry.RESET;
                            VendLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Vendor No.");
                            VendLedgEntry.SETRANGE("Document No.", PurchInvLine."Document No.");
                            VendLedgEntry.SETRANGE("Document Type", VendLedgEntry."Document Type"::Invoice);
                            VendLedgEntry.SETRANGE(Open, true);
                            if VendLedgEntry.FIND('-') then
                                repeat
                                    VendLedgEntry.CALCFIELDS("Remaining Amount");
                                    OpenAP := OpenAP - VendLedgEntry."Remaining Amount";
                                until VendLedgEntry.NEXT = 0;
                        end;
                    until PurchInvLine.NEXT = 0;

                DocNoHold := '';
                PurchCrMemoLine.RESET;
                PurchCrMemoLine.SETCURRENTKEY("Job No.", "Document No.");
                PurchCrMemoLine.SETRANGE("Job No.", Job."No.");
                if PurchCrMemoLine.FIND('-') then
                    repeat
                        if PurchInvLine."Document No." <> DocNoHold then begin
                            DocNoHold := PurchInvLine."Document No.";
                            VendLedgEntry.RESET;
                            VendLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Vendor No.");
                            VendLedgEntry.SETRANGE("Document No.", PurchCrMemoLine."Document No.");
                            VendLedgEntry.SETRANGE("Document Type", VendLedgEntry."Document Type"::"Credit Memo");
                            VendLedgEntry.SETRANGE(Open, true);
                            if VendLedgEntry.FIND('-') then
                                repeat
                                    VendLedgEntry.CALCFIELDS("Remaining Amount");
                                    OpenAP := OpenAP + VendLedgEntry."Remaining Amount";
                                until VendLedgEntry.NEXT = 0;
                        end;
                    until PurchInvLine.NEXT = 0;

                OpenAR := InvoicedPrice - PaymentReceived;
                CashFlow := OpenAR - OpenAP;

                if BudgetedCost <> 0 then
                    "ActCostVariance%" := (UsageCost / BudgetedCost) * 100
                else
                    "ActCostVariance%" := 0;

                if BudgetedPrice <> 0 then
                    "ActPriceVariance%" := (InvoicedPrice / BudgetedPrice) * 100
                else
                    "ActPriceVariance%" := 0;

                if BudgetedPrice - BudgetedCost <> 0 then
                    "ActProfitVariance%" := ((InvoicedPrice - UsageCost) / (BudgetedPrice - BudgetedCost)) * 100
                else
                    "ActProfitVariance%" := 0;
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
        PurchSetup.GET;
    end;

    var
        JobLedgEntry: Record "Job Ledger Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        CustLedgEntry2: Record "Cust. Ledger Entry";
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        DetailedCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        SalesSetup: Record "Sales & Receivables Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        CommentLine: Record "Comment Line";
        CompanyInformation: Record "Company Information";
        FormatAddress: Codeunit "NS_Format Address";
        DocNoHold: Code[20];
        BudgetedPrice: Decimal;
        BudgetedCost: Decimal;
        BudgetedProfit: Decimal;
        InvoicedPrice: Decimal;
        UsageCost: Decimal;
        UsagePrice: Decimal;
        ActualProfitToDate: Decimal;
        "Sub-LevelsPrice": Decimal;
        NetPrice: Decimal;
        RetentionAmount: Decimal;
        NetBillings: Decimal;
        PaymentReceived: Decimal;
        Balance: Decimal;
        OpenAP: Decimal;
        OpenAR: Decimal;
        CurrentPeriod: Decimal;
        YearToDate: Decimal;
        "Billing-Cost": Decimal;
        CashFlow: Decimal;
        "ActCostVariance%": Decimal;
        "ActPriceVariance%": Decimal;
        "ActProfitVariance%": Decimal;
        "Area": array[15] of Integer;
        MaxAreas: Integer;
        UsedAreas: Integer;
        i: Integer;
        NewPagePerJob: Boolean;
        FirstJobPrinted: Boolean;
        "IncludeSub-Levels": Boolean;
        "ShowSub-Levels": Boolean;
        ShowJobComments: Boolean;
        MTD: Text[30];
        YTD: Text[30];
        JobSiteAddress: array[8] of Text[50];
        JobBillToAddress: array[8] of Text[50];
        "JobBill-toPostCodeCity": Text[90];
        "JobBill-toCountyText": Text[50];
        SubTitle: Text[30];
        DateTitle: Text[30];
        ReportTitle: Label 'Job Status Report';
        PageNoCaption: Label 'Page:';
        JobNoCaption: Label 'No.:';
        JobDescriptionCaption: Label 'Description:';
        JobStatusCaption: Label 'Status:';
        JobStatusDateCaption: Label 'Status Date:';
        JobContractNoCaption: Label 'Contract No:';
        JobContractDateCaption: Label 'Contract Date:';
        JobSubLevelToJobNoCaption: Label 'Sub-level to Job:';
        CONTRACTINFOCaption: Label 'CONTRACT INFO:';
        JobBudgetedPriceCaption: Label 'Contract Price:';
        SubLevelsPriceCaption: Label 'Sub-Levels:';
        NetPriceCaption: Label 'Net Price:';
        JOBINFOCaption: Label 'JOB INFO:';
        JobAddressCaption: Label 'Job Address:';
        JobContactCaption: Label 'Contact:';
        JobJobPhoneCaption: Label 'Phone:';
        JobEstimatorCaption: Label 'Estimator:';
        JobManagerCaption: Label 'Manager:';
        CUSTOMERINFOCaption: Label 'CUSTOMER INFO:';
        CustAddressCaption: Label 'Cust Address:';
        CustContactCaption: Label 'Customer Contact:';
        BILLINGINFOCaption: Label 'BILLING INFO:';
        PONumberCaption: Label 'PO Number:';
        BillingMethodCaption: Label 'Billing Method:';
        CONTRACTBILLINGSCaption: Label 'CONTRACT BILLINGS:';
        GrossBillingCaption: Label 'Gross Billing';
        RetentionCaption: Label 'Retention';
        NetBillingsCaption: Label 'Net Billings';
        PaymentsCaption: Label 'Payments';
        BalanceCaption: Label 'Balance';
        JOBCOSTINGINFOCaption: Label 'JOB COSTING INFO:';
        CurrentPeriodCaption: Label 'Current Period';
        YearToDateCaption: Label 'Year to Date';
        TotalJobCostCaption: Label 'Total Job Cost';
        TotalJobBillingCaption: Label 'Total Job Billing';
        BillingCostCaption: Label 'Billing - Cost';
        OpenARCaption: Label 'Open A/R';
        OpenAPCaption: Label 'Open A/P';
        CashFlowCaption: Label 'Cash Flow';
        JOBDATESINFOCaption: Label 'JOB DATES INFO:';
        CreationDateCaption: Label 'Creation Date';
        EstimatedStartDateCaption: Label 'Estimated Start Date';
        StartDateCaption: Label 'StartDate';
        EstimatedCompletionDateCaption: Label 'Estimated Completion Date';
        CompletionDateCaption: Label 'Estimated Completion Date';
        EndingDateCaption: Label 'Ending Date';
        BUDGETVSACTUALCaption: Label 'BUDGET VS ACTUAL:';
        BudgetedCostCaption: Label 'Budgeted Cost';
        BudgetedPriceCaption: Label 'Budgeted Price';
        BudgetedProfitCaption: Label 'Budgeted Profit';
        ActualCostCaption: Label 'Actual Cost';
        ActualPriceCaption: Label 'Actual Price';
        ActualProfitToDateCaption: Label 'Actual Profit To Date';
        BudgetVariancePercentCaption: Label 'Budget Variance %:';
}

