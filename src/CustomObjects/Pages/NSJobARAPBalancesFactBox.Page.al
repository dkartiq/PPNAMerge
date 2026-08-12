page 14021360 "NS_Job A/R A/P BalancesFactBox"
{
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job A/R A/P Balances';
    PageType = CardPart;
    SourceTable = Job;

    layout
    {
        area(content)
        {
            field("'      Job To Date'"; '      Job To Date')
            {
                ApplicationArea = All;
                Caption = 'PROJECTPRO';

                ToolTip = 'PROJECTPRO';
                Editable = false;
            }
            field("ActualCostToDate[3]"; ActualCostToDate[3])
            {
                ApplicationArea = All;
                Caption = 'Actual Cost to Date';

                ToolTip = 'Actual Cost to Date';
                Editable = false;

                trigger OnDrillDown();
                begin
                    ShowJobRec.RESET;
                    ShowJobRec := Rec;
                    ShowJobRec.SETRANGE("NS_Date Filter", 0D, WORKDATE());
                    ShowJobRec.SETRANGE("NS_Entry Type Filter", JobLedgerEntry."Entry Type"::Usage);
                    JobLedgerEntries.NS_SetFilters(ShowJobRec, false);
                    JobLedgerEntries.RUNMODAL;
                    CLEAR(JobLedgerEntries);
                end;
            }
            field("InvoiceBilled[3]"; InvoiceBilled[3])
            {
                ApplicationArea = All;
                Caption = 'Customer Invoices to Date';

                ToolTip = 'Customer Invoices to Date';
                Editable = false;

                trigger OnDrillDown();
                begin
                    ShowJobRec.RESET;
                    ShowJobRec := Rec;
                    //ShowJobRec.SETFILTER("NS_Type Filter", '<>%1', ShowJobRec."NS_Type Filter"::Ledger); //PRJ-1131.RM.1.0 10Jan2022 need to be checked //PE-306.JS.1.0 06JUN2024 line commented
                    ShowJobRec.SETFILTER("NS_TypeEnumFilter", '<>%1', ShowJobRec."NS_TypeEnumFilter"::Text); //PRJ-1131.RM.1.0 10Jan2022 //PE-306.JS.1.0 06JUN2024 line added
                    ShowJobRec.SETRANGE("NS_Date Filter", 0D, WORKDATE);
                    ShowJobRec.SETRANGE("NS_Entry Type Filter", JobLedgerEntry."Entry Type"::Sale);
                    JobLedgerEntries.NS_SetFilters(ShowJobRec, false);
                    JobLedgerEntries.RUNMODAL;
                    CLEAR(JobLedgerEntries);
                end;
            }
            field(ARBalance; ARBalance)
            {
                ApplicationArea = All;
                Caption = 'A/R Balance';

                ToolTip = 'A/R Balance';
                Editable = false;

                trigger OnDrillDown();
                var
                    DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                    CustLedgEntry: Record "Cust. Ledger Entry";
                begin
                    DtldCustLedgEntry.RESET;
                    DtldCustLedgEntry.SETCURRENTKEY("NS_Job No.");
                    DtldCustLedgEntry.SETRANGE("NS_Job No.", "No.");
                    if JobsSetup."NS_Retention Receivable Ledger" <> '' then
                        DtldCustLedgEntry.SETFILTER("NS_Retention Ledger Code", '<>%1', JobsSetup."NS_Retention Receivable Ledger");
                    CustLedgEntry.DrillDownOnEntries(DtldCustLedgEntry);
                end;
            }
            field(ARRetentionBalance; ARRetentionBalance)
            {
                ApplicationArea = All;
                Caption = 'A/R Retention Balance';

                ToolTip = 'A/R Retention Balance';
                Editable = false;

                trigger OnDrillDown();
                var
                    CustLedgEntryRetention: Record "Cust. Ledger Entry";
                    SalesInvoiceLine: Record "Sales Invoice Line";
                    SalesCrMemoLine: Record "Sales Cr.Memo Line";
                begin
                    with CustLedgEntryRetention do begin
                        SETRANGE("NS_Job No.", "No.");
                        SETRANGE("NS_Retention Ledger Code", JobsSetup."NS_Retention Receivable Ledger");
                        SetRange(Open, true); //PRJCTPR-220.DK.1.0 06NOV2023
                        if FINDSET then;
                    end;
                    PAGE.RUN(PAGE::"Customer Ledger Entries", CustLedgEntryRetention);
                end;
            }
            field(APBalance; APBalance)
            {
                ApplicationArea = All;
                Caption = 'A/P Balance';

                ToolTip = 'A/P Balance';
                Editable = false;

                trigger OnDrillDown();
                begin
                    VendLedgEntry.SETRANGE("NS_Job No.", "No.");
                    VendLedgEntry.SETRANGE(Open, true);
                    PAGE.RUN(PAGE::"Vendor Ledger Entries", VendLedgEntry);
                end;
            }
            field(APRetentionBalance; APRetentionBalance)
            {
                ApplicationArea = All;
                Caption = 'A/P Retention Balance';

                ToolTip = 'A/P Retention Balance';
                Editable = false;

                trigger OnDrillDown();
                var
                    VendLedgEntryRetention: Record "Vendor Ledger Entry";
                begin
                    VendLedgEntry.SETRANGE("NS_Job No.", "No.");
                    VendLedgEntry.SETRANGE("NS_Retention Ledger Code", JobsSetup."NS_Retention Receivable Ledger");
                    PAGE.RUN(PAGE::"Vendor Ledger Entries", VendLedgEntry);
                end;
            }
            field(SubcontractBalance; SubcontractBalance)
            {
                ApplicationArea = All;
                Caption = 'Subcontractor Balance';

                ToolTip = 'Subcontractor Balance';
                Editable = false;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        NS_OnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        NS_OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage();
    begin
        JobsSetup.GET;
        SalesSetup.GET;
        PurchSetup.GET;
        SourceCodeSetup.GET;
    end;

    var
        JobsSetup: Record "Jobs Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        SourceCodeSetup: Record "Source Code Setup";
        ShowJobRec: Record Job;
        JobLedgerEntry: Record "Job Ledger Entry";
        // CustomerRec: Record Customer;
        VendLedgEntry: Record "Vendor Ledger Entry";
        // PurchInvLine: Record "Purch. Inv. Line";
        // PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        Subcontract: Record NS_Subcontract;
        SubcontractDetail: Record "NS_Subcontract Lines";
        SubcontractLedgEntry: Record "NS_Subcontract Ledger Entry";
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
        PaymentReceived: array[3] of Decimal;
        CommittedCost: Decimal;
        ActualCostToDate: array[3] of Decimal;
        InvoiceBilled: array[3] of Decimal;
        ARBalance: Decimal;
        ARRetentionBalance: Decimal;
        APBalance: Decimal;
        APRetentionBalance: Decimal;
        SubcontractBalance: Decimal;
        "Sub-LevelsCost": Decimal;
        "Sub-LevelsPrice": Decimal;
        CalcValues: array[8, 40] of Decimal;
        JobLedgerEntries: Page "Job Ledger Entries";
    // DtldCustLedgEntries: Page "Detailed Cust. Ledg. Entries";
    // CommittedLineList: Page "PP_Committed Line List";

    procedure NS_ShowDetails();
    begin
        PAGE.RUN(PAGE::"Job Card", Rec);
    end;

    procedure NS_CalcStatistics();
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        CustLedgerEntri: Record "Cust. Ledger Entry"; //PRJCTPR-193.DK.1.0 20SEP2023
        Blank: Code[20];
        // >> Upgrade
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    // << Upgrade
    begin
        // >> Upgrade
        //FDD108 Start
        if "NS_Sub-Level to Job No." = "No." then
            exit;
        //FDD108 End
        // << Upgrade
        NS_CalculateJobFinancials(Rec, ActualCostToDate, InvoiceBilled, PaymentReceived, CommittedCost, false);
        //Calculate Common Values
        CLEAR("Sub-LevelsCost");
        CLEAR("Sub-LevelsPrice");
        "Sub-LevelsCost" := NS_SLsBudgetedCost(Rec);
        "Sub-LevelsPrice" := NS_SLsBudgetedPrice(Rec);

        NS_CalculateJobStatistics(Rec, ActualCostToDate, InvoiceBilled, "Sub-LevelsCost", "Sub-LevelsPrice", CommittedCost, false, CalcValues);
        ARRetentionBalance := CalcValues[3, 1];
        APRetentionBalance := CalcValues[3, 2];

        //Calculate A/R Balance
        ARBalance := 0;
        //PRJCTPR-193.DK.1.0 15Sep2023 START
        // DtldCustLedgEntry.RESET();
        // >> Upgrade
        // >> 001
        //DtldCustLedgEntry.SETCURRENTKEY("Job No.");
        DtldCustLedgEntry.SetCurrentKey("NS_Job No.", "Customer No.", "Initial Entry Global Dim. 2");
        // << 001
        // << Upgrade
        // DtldCustLedgEntry.SETCURRENTKEY("NS_Job No.");
        // DtldCustLedgEntry.SETRANGE("NS_Job No.", Rec."No.");//PRJ-1131.RM.1.0 10Jan2022 need to be checked
        // DtldCustLedgEntry.SETRANGE("Customer No.", Rec."Bill-to Customer No.");//PRJ-1131.RM.1.0 10Jan2022 need to be checked
        // if JobsSetup."NS_Retention Receivable Ledger" <> '' then
        //     DtldCustLedgEntry.SETFILTER("Initial Entry Global Dim. 2", '<>%1', JobsSetup."NS_Retention Receivable Ledger");
        // if DtldCustLedgEntry.FINDSET() then
        //     repeat
        //         ARBalance := ARBalance + DtldCustLedgEntry.Amount;
        //     until DtldCustLedgEntry.NEXT() = 0;

        //Calculate A/R Balance From Customer Ledger entries
        CustLedgerEntri.RESET();
        CustLedgerEntri.SETCURRENTKEY("NS_Job No.");
        CustLedgerEntri.SETRANGE("NS_Job No.", Rec."No.");
        CustLedgerEntri.SetRange(Open, true);
        if JobsSetup."NS_Retention Receivable Ledger" <> '' then
            CustLedgerEntri.SETFILTER("NS_Retention Ledger Code", '<>%1', JobsSetup."NS_Retention Receivable Ledger");
        if CustLedgerEntri.FINDSET() then
            repeat
                CustLedgerEntri.CalcFields(Amount);
                if CustLedgerEntri.Amount <> 0 then
                    ARBalance += CustLedgerEntri.Amount;
            until CustLedgerEntri.NEXT() = 0;
        //PRJCTPR-193.DK.1.0 15Sep2023 END
        //Calculate A/P Balance
        APBalance := 0;
        // >> Upgrade
        // VendLedgEntry.RESET();
        // VendLedgEntry.SETRANGE("NS_Job No.", "No.");
        // VendLedgEntry.SETRANGE(Open, true);
        // if VendLedgEntry.FINDSET() then
        //     repeat
        //         VendLedgEntry.CALCFIELDS(Amount);
        //         APBalance += ABS(VendLedgEntry.Amount);
        //     until VendLedgEntry.NEXT() = 0;
        DtldVendLedgEntry.Reset;

        // >> 001
        DtldVendLedgEntry.SetCurrentKey("NS_Job No.", "NS_Retention Ledger Code");
        //DtldVendLedgEntry.SETCURRENTKEY("Job No.");
        // << 001

        DtldVendLedgEntry.SetRange("NS_Job No.", "No.");
        if not PurchSetup."NS_Purchase Retention Inactive" then
            DtldVendLedgEntry.SetFilter("NS_Retention Ledger Code", '<>%1', JobsSetup."NS_Retention Payable Ledger");

        // >> 001
        /*
        IF DtldVendLedgEntry.FINDSET THEN
          REPEAT
            APBalance := APBalance + DtldVendLedgEntry.Amount;
          UNTIL DtldVendLedgEntry.NEXT = 0;
        */
        DtldVendLedgEntry.CalcSums(Amount);
        APBalance := DtldVendLedgEntry.Amount;
        // << 001
        // << Upgrade

        //Subcontract Balance
        SubcontractBalance := 0;
        Blank := '';
        Subcontract.RESET();
        Subcontract.SETCURRENTKEY("NS_Sub-LeveltoSubcontractNo.");
        Subcontract.SETFILTER("NS_Sub-LeveltoSubcontractNo.", '=%1', Blank);
        if Subcontract.FINDSET() then
            repeat
                SubcontractDetail.RESET();
                SubcontractDetail.SETCURRENTKEY("NS_Subcontract No.", "NS_Job No.");
                SubcontractDetail.SETRANGE("NS_Subcontract No.", Subcontract."NS_No.");
                SubcontractDetail.SETRANGE("NS_Job No.", "No.");
                if SubcontractDetail.FINDFIRST() then begin
                    //Invoices
                    SubcontractLedgEntry.RESET();
                    SubcontractLedgEntry.SETCURRENTKEY("NS_Subcontract No.", "NS_Entry Type");
                    SubcontractLedgEntry.SETRANGE("NS_Subcontract No.", Subcontract."NS_No.");
                    SubcontractLedgEntry.SETRANGE("NS_Entry Type", SubcontractLedgEntry."NS_Entry Type"::Purchase);
                    SubcontractLedgEntry.SETFILTER(NS_Type, '<>%1', SubcontractLedgEntry.NS_Type::Ledger);
                    SubcontractLedgEntry.SETRANGE("NS_Posting Date", 0D, WORKDATE);
                    SubcontractLedgEntry.CALCSUMS("NS_Total Cost (LCY)");
                    SubcontractBalance += SubcontractLedgEntry."NS_Total Cost (LCY)";
                    SubcontractBalance += Subcontract.NS_SLsInvoicedCost(Subcontract);
                    //Payments
                    DetailedVendorLedgEntry.RESET();
                    DetailedVendorLedgEntry.SETCURRENTKEY("NS_Subcontract No.", "Source Code", "Posting Date");
                    DetailedVendorLedgEntry.SETRANGE("NS_Subcontract No.", Subcontract."NS_No.");
                    DetailedVendorLedgEntry.SETRANGE("Source Code", SourceCodeSetup."Payment Journal");
                    DetailedVendorLedgEntry.SETRANGE("Posting Date", 0D, WORKDATE);
                    DetailedVendorLedgEntry.CALCSUMS("Amount (LCY)");
                    SubcontractBalance -= DetailedVendorLedgEntry."Amount (LCY)";
                    SubcontractBalance -= Subcontract.NS_SLsPaymentMade(Subcontract);
                end;
            until Subcontract.NEXT() = 0;
    end;

    local procedure NS_OnAfterGetCurrRecord();
    begin
        xRec := Rec;
        NS_CalcStatistics;
    end;

    //SMPL - Renamed OnAfterGetCurrRecord to PP_OnAfterGetCurrRecord  
}

