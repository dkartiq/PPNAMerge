report 14021300 "NS_Subcontract Status byVendor"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-84.SK.1.0 Added report to search
    //PRJ-218:AS:14April2020 : Changed the layout from "Subcontract Status by Vendor.rdlc" to "Subcontract Status by Vendor_New.rdlc"
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSCustomized subcontract Status by Vendor_New.rdl';//PRJ-218:AS:14April2020
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Subcontract Status by Vendor';
    ApplicationArea = all;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(Page_Caption; PageLbl)
            {
            }
            column(USERID; USERID)
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(Vendor_FilterCaption; VendorFilterLbl)
            {
            }
            column(Subcontract_FilterCaption; SubcontractFilterLbl)
            {
            }
            column(Vendor__No; "No.")
            {
            }
            column(Vendor_Name; Name)
            {
            }
            column(Report_TitleCaption; ReportTitleLbl)
            {
            }
            column(Vendor_NoCaption; VendorNoLbl)
            {
            }
            column(Subcontract_NoCaption; SubcontractNoLbl)
            {
            }
            column(DescriptionCaption; DescriptionLbl)
            {
            }
            column(Starting_DateCaption; StartingDateLbl)
            {
            }
            column(Contract_AmountCaption; ContractAmountLbl)
            {
            }
            column(Invoiced_AmountCaption; InvoicedAmountLbl)
            {
            }
            column(Retention_BalanceCaption; RetentionBalanceLbl)
            {
            }
            column(Payment_AmountCaption; PaymentAmountLbl)
            {
            }
            column(Balance_DueCaption; BalanceDueLbl)
            {
            }
            column(Contract_BalanceCaption; ContractBalanceLbl)
            {
            }
            column(VendorFilter; VendorFilter)
            {
            }
            column(SubcontractFilter; SubcontractFilter)
            {
            }
            column(ShowSubcontractDetail; ShowSubcontractDetail)
            {
            }
            column(ShowLineDetail; ShowLineDetail)
            {
            }
            dataitem(Header; NS_Subcontract)
            {
                DataItemLink = "NS_Buy-from Vendor No." = FIELD("No.");
                RequestFilterFields = "NS_No.";
                column(Vendor_No; "NS_Buy-from Vendor No.")
                {
                }
                column(No; "NS_No.")
                {
                }
                column(Description; NS_Description)
                {
                }
                column(Starting_Date; "NS_Starting Date")
                {
                }
                column(TotalToPrint_Budgeted_Cost; TotalToPrintBudgetedCost)
                {
                }
                column(TotalToPrint_Invoiced_Cost; TotalToPrintInvoicedAmount)
                {
                }
                column(TotalToPrint_Contract_Balance; TotalToPrintContractBalance)
                {
                }
                column(TotalToPrint_Retention_Amount; TotalToPrintRetentionAmount)
                {
                }
                column(TotalToPrint_Payment_Made; TotalToPrintPaymentMade)
                {
                }
                column(TotalToPrint_Balance_Due; TotalToPrintBalanceDue)
                {
                }
                column(Vendor_No_Totals; VendorLbl + Vendor."No." + TotalsLbl)
                {
                }
                dataitem(A_Header; NS_Subcontract)
                {
                    DataItemLink = "NS_No." = FIELD("NS_No.");
                    DataItemLinkReference = Header;
                    DataItemTableView = SORTING("NS_No.") ORDER(Ascending);
                    column(A_SubContractLineNo; SubContractLineNo)
                    {
                    }
                    column(A_Subcontract_No; "NS_No.")
                    {
                    }
                    column(A_Subcontract_Description; NS_Description)
                    {
                    }
                    column(A_Starting_Date; "NS_Starting Date")
                    {
                    }
                    column(A_Contract_Amount; A_BudgetedCost)
                    {
                    }
                    column(A_Invoiced_Amount; A_InvoicedCost)
                    {
                    }
                    column(A_Contract_Balance; A_ContractBalance)
                    {
                    }
                    column(A_Retention_Balance; A_RetentionAmount)
                    {
                    }
                    column(A_Payment_Amount; A_PaymentMade)
                    {
                    }
                    column(A_Balance_Due; A_BalanceDue)
                    {
                    }
                    dataitem(B_Detail; "NS_Subcontract Lines")
                    {
                        DataItemLink = "NS_Subcontract No." = FIELD("NS_No.");
                        DataItemTableView = SORTING("NS_Subcontract No.", "NS_Line No.") ORDER(Ascending);
                        column(B_Job_NoCaption; B_JobNoLbl)
                        {
                        }
                        column(B_Job_DescriptionCaption; B_JobDescriptionLbl)
                        {
                        }
                        column(B_Job_TaskCaption; B_JobTaskLbl)
                        {
                        }
                        column(B_SubcontractLineDescriptionCaption; B_SubcontractLineDescriptionLbl)
                        {
                        }
                        column(B_TypeCaption; B_TypeLbl)
                        {
                        }
                        column(B_NoCaption; B_NoLbl)
                        {
                        }
                        column(B_QuantityCaption; B_QuantityLbl)
                        {
                        }
                        column(B_Unit_Of_MeasureCaption; B_UnitOfMeasureLbl)
                        {
                        }
                        column(B_Unit_CostCaption; B_UnitCostLbl)
                        {
                        }
                        column(B_Total_CostCaption; B_TotalCostLbl)
                        {
                        }
                        column(B_Job_No; "NS_Job No.")
                        {
                        }
                        column(B_Job_Description; Job.Description)
                        {
                        }
                        column(B_Job_Task_No; "NS_Job Task No.")
                        {
                        }
                        column(B_Subcontract_Line_Description; NS_Description)
                        {
                        }
                        column(B_Type; NS_Type)
                        {
                        }
                        column(B_No; "NS_No.")
                        {
                        }
                        column(B_Quantity; NS_Quantity)
                        {
                        }
                        column(B_Unit_Of_Measure_Code; "NS_Unit of Measure Code")
                        {
                        }
                        column(B_Unit_Cost; "NS_Unit Cost")
                        {
                        }
                        column(B_Total_Cost; "NS_Total Cost")
                        {
                        }

                        trigger OnAfterGetRecord();
                        begin
                            SubContractLineNo := SubContractLineNo + 1;
                            if SubContractLineNo > 1 then begin
                                //Clear these values so that they are not accumulating for every detail line in higher level totals
                                TotalToPrintBudgetedCost := 0;
                                TotalToPrintInvoicedAmount := 0;
                                TotalToPrintContractBalance := 0;
                                TotalToPrintRetentionAmount := 0;
                                TotalToPrintPaymentMade := 0;
                                TotalToPrintBalanceDue := 0;
                                A_BudgetedCost := 0;
                                A_InvoicedCost := 0;
                                A_ContractBalance := 0;
                                A_RetentionAmount := 0;
                                A_PaymentMade := 0;
                                A_BalanceDue := 0;
                            end;
                        end;

                        trigger OnPreDataItem();
                        begin
                            //This area shows details for the subcontracts if further detail is requested about each Subcontract header being shown
                            if not ShowLineDetail then
                                CurrReport.BREAK;
                            SubContractLineNo := 0;
                        end;
                    }

                    trigger OnAfterGetRecord();
                    begin
                        SubContractLineNo := SubContractLineNo + 1;
                        CalculatePaymentsMade(A_Header);
                        CALCFIELDS("NS_Invoiced Cost (LCY)");
                        A_BudgetedCost := "NS_Budgeted Cost (LCY)";
                        A_InvoicedCost := "NS_Invoiced Cost (LCY)";
                        A_ContractBalance := A_BudgetedCost - A_InvoicedCost;
                        A_RetentionAmount := -NS_RetentionBalance(A_Header, '', '');
                        A_PaymentMade := PaymentMade;
                        A_BalanceDue := A_InvoicedCost - PaymentMade;
                    end;

                    trigger OnPreDataItem();
                    begin
                        //This area shows information for each subcontract contributing to the total for the Vendor as requested
                        if not ShowSubcontractDetail then
                            CurrReport.BREAK;
                        SubContractLineNo := 0;
                    end;
                }

                trigger OnAfterGetRecord();
                begin
                    ClearDetail;
                    "NS_Invoiced Cost (LCY)" := -"NS_Invoiced Cost (LCY)";
                    RetentionAmount := NS_RetentionBalance(Header, '', '');
                    CalculatePaymentsMade(Header);
                    PaymentMade := PaymentMade + NS_SLsPaymentMade(Header);

                    ChangeOrderSubcontracts.RESET();
                    ChangeOrderSubcontracts.SETCURRENTKEY("NS_Sub-LeveltoSubcontractNo.", "NS_Buy-from Vendor No.");
                    ChangeOrderSubcontracts.SETRANGE("NS_Sub-LeveltoSubcontractNo.", "NS_No.");
                    ChangeOrderSubcontracts.SETRANGE("NS_Buy-from Vendor No.", "NS_Buy-from Vendor No.");
                    if ChangeOrderSubcontracts.FINDSET() then
                        repeat
                            RetentionAmount := RetentionAmount + NS_RetentionBalance(ChangeOrderSubcontracts, '', '');
                        until ChangeOrderSubcontracts.NEXT() = 0;

                    if Vendor.GET("NS_Buy-from Vendor No.") then
                        VendorName := Vendor.Name
                    else
                        VendorName := Text001;

                    CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Invoiced Cost (LCY)");
                    TotalToPrintBudgetedCost := "NS_Budgeted Cost (LCY)" + NS_SLsBudgetedCost(Header);
                    TotalToPrintInvoicedAmount := "NS_Invoiced Cost (LCY)" + NS_SLsInvoicedCost(Header);
                    TotalToPrintContractBalance := TotalToPrintBudgetedCost - TotalToPrintInvoicedAmount;
                    TotalToPrintRetentionAmount := -RetentionAmount;
                    TotalToPrintPaymentMade := PaymentMade;
                    TotalToPrintBalanceDue := TotalToPrintInvoicedAmount - TotalToPrintRetentionAmount - TotalToPrintPaymentMade
                end;

                trigger OnPreDataItem();
                begin
                    CurrReport.CREATETOTALS(TotalToPrintBudgetedCost, TotalToPrintInvoicedAmount, TotalToPrintRetentionAmount, TotalToPrintPaymentMade);
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                //SMPL - Caption = 'RequestPage';
                group(Options)
                {
                    field("Show Subcontract Detail"; ShowSubcontractDetail)
                    {
                        Caption = 'Show Subcontract Detail';
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            if not ShowSubcontractDetail then
                                ShowLineDetail := false;
                        end;
                    }
                    field("Show Line Detail"; ShowLineDetail)
                    {
                        Caption = 'Show Subcontract Line Detail';
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            if ShowLineDetail then
                                ShowSubcontractDetail := true;
                        end;
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
        ShowSubcontractDetail := true;
        ShowLineDetail := true;
    end;

    trigger OnPreReport();
    begin
        CompanyInformation.GET();
        PurchaseSetup.GET();
        VendorFilter := Vendor.GETFILTERS;
        SubcontractFilter := Header.GETFILTERS;
    end;

    var
        CompanyInformation: Record "Company Information";
        PurchaseSetup: Record "Purchases & Payables Setup";
        InvPayDetails: Record "Vendor Ledger Entry" temporary;
        ChangeOrderSubcontracts: Record NS_Subcontract;
        Job: Record Job;
        RetentionAmount: Decimal;
        PaymentMade: Decimal;
        TotalToPrintBudgetedCost: Decimal;
        TotalToPrintInvoicedAmount: Decimal;
        TotalToPrintContractBalance: Decimal;
        TotalToPrintRetentionAmount: Decimal;
        TotalToPrintPaymentMade: Decimal;
        TotalToPrintBalanceDue: Decimal;
        A_BudgetedCost: Decimal;
        A_InvoicedCost: Decimal;
        A_ContractBalance: Decimal;
        A_RetentionAmount: Decimal;
        A_PaymentMade: Decimal;
        A_BalanceDue: Decimal;
        LastInvPayRec: Integer;
        SubContractLineNo: Integer;
        ShowSubcontractDetail: Boolean;
        ShowLineDetail: Boolean;
        VendorFilter: Text[250];
        SubcontractFilter: Text[250];
        VendorName: Text[250];
        Text001: Label 'UNKNOWN!';
        PageLbl: Label 'Page';
        ReportTitleLbl: Label 'Subcontract Status by Vendor';
        VendorFilterLbl: Label 'Vendor Filter: ';
        SubcontractFilterLbl: Label 'Subcontract Filter: ';
        VendorNoLbl: Label 'Vendor No.';
        SubcontractNoLbl: Label 'Subcontract No.';
        DescriptionLbl: Label 'Description';
        StartingDateLbl: Label 'Starting Date';
        ContractAmountLbl: Label 'Contract Amount';
        InvoicedAmountLbl: Label 'Invoiced Amount';
        ContractBalanceLbl: Label 'Contract Balance';
        RetentionBalanceLbl: Label 'Retention Balance';
        PaymentAmountLbl: Label 'Payment Amount';
        BalanceDueLbl: Label 'Balance Due';
        B_JobNoLbl: Label 'Job No.';
        B_JobNameLbl: Label 'Job Name';
        B_JobDescriptionLbl: Label 'Job Description';
        B_JobTaskLbl: Label 'Job Task';
        B_SubcontractLineDescriptionLbl: Label 'Subcontract Line Description';
        B_TypeLbl: Label 'Type';
        B_NoLbl: Label 'No.';
        B_QuantityLbl: Label 'Quantity';
        B_UnitOfMeasureLbl: Label 'Unit of Measure';
        B_UnitCostLbl: Label 'Unit Cost';
        B_TotalCostLbl: Label 'Total Cost';
        VendorLbl: Label 'Vendor ';
        TotalsLbl: Label ' Totals:';

    procedure ClearDetail();
    begin
        InvPayDetails.RESET();
        InvPayDetails.DELETEALL();
        LastInvPayRec := 0;
    end;

    procedure InsertDetail(DocDate: Date; DocType: Option; DocNo: Code[20]; DocAmount: Decimal; DocSource: Text[3]; DocEntryNo: Integer);
    var
        i: Integer;
        SkipRec: Boolean;
    begin
        //Using a temporary table based on Vendor Ledger Entry

        with InvPayDetails do begin
            //Ensure this is not already here
            SkipRec := false;
            RESET;
            SETCURRENTKEY("Transaction No.");
            SETRANGE("Transaction No.", DocEntryNo);
            if FINDSET then
                repeat
                    if Description = DocSource then
                        SkipRec := true;
                until (NEXT = 0) or SkipRec;

            if not SkipRec then begin
                INIT;
                LastInvPayRec := LastInvPayRec + 1;
                "Entry No." := LastInvPayRec;
                "Posting Date" := DocDate;
                "Document Type" := DocType;
                "Document No." := DocNo;
                "Purchase (LCY)" := DocAmount;
                Description := DocSource;
                "Transaction No." := DocEntryNo;
                INSERT;
            end;
        end;
    end;

    procedure CalculatePaymentsMade(SubcontractHead: Record NS_Subcontract);
    var
        SubcontractHeader: Record NS_Subcontract;
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
        SourceCodeSetup: Record "Source Code Setup";
    begin
        //Find Payments Made
        CLEAR(PaymentMade);

        with SubcontractHeader do begin
            GET(SubcontractHead."NS_No.");
            SourceCodeSetup.GET();

            RESET();
            DetailedVendorLedgEntry.RESET();
            DetailedVendorLedgEntry.SETCURRENTKEY("NS_Subcontract No.", "Source Code", "Posting Date");
            DetailedVendorLedgEntry.SETRANGE("NS_Subcontract No.", "NS_No.");
            DetailedVendorLedgEntry.SETRANGE("Source Code", SourceCodeSetup."Payment Journal");
            DetailedVendorLedgEntry.SETRANGE("Posting Date", 0D, WORKDATE);
            DetailedVendorLedgEntry.CALCSUMS("Amount (LCY)");
            PaymentMade := DetailedVendorLedgEntry."Amount (LCY)";
            if ShowLineDetail then begin
                //Add records to InvoicePayment Detail for listing
                DetailedVendorLedgEntry.RESET();
                DetailedVendorLedgEntry.SETCURRENTKEY("NS_Subcontract No.", "Source Code", "Posting Date");
                DetailedVendorLedgEntry.SETRANGE("NS_Subcontract No.", "NS_No.");
                DetailedVendorLedgEntry.SETRANGE("Source Code", SourceCodeSetup."Payment Journal");
                DetailedVendorLedgEntry.SETRANGE("Posting Date", 0D, WORKDATE);
                if DetailedVendorLedgEntry.FINDSET() then
                    repeat
                        InsertDetail(DetailedVendorLedgEntry."Posting Date", 1, DetailedVendorLedgEntry."Document No.",
                                     DetailedVendorLedgEntry."Amount (LCY)", 'SCL', DetailedVendorLedgEntry."Entry No.");
                    until DetailedVendorLedgEntry.NEXT() = 0;
            end;
        end;
    end;
}

