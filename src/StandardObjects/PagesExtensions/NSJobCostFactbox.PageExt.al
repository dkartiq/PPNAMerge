/// <summary>
/// PageExtension NS_JobCostFactbox (ID 14021492) extends Record Job Cost Factbox.
/// </summary>
///PE-41.NK.1.0 03Jan2022
///New page is created to add A/p retention balance and A/R retentionbalance in factobx areas
pageextension 14021492 NS_JobCostFactbox extends "Job Cost Factbox"
{
    //ContextSensitiveHelpPage = 'user-guide/';

    layout
    {
        addafter("Actual Cost")
        {
            field(NS_APRetentionBalance; CalcValues[3, 2])
            {
                ApplicationArea = All;
                Caption = 'A/P Retention Balance';
                Editable = false;
                ToolTip = 'Retention Balance in Vendor Card for this Job';
                trigger OnDrillDown();
                begin
                    CustLedgEntryRetention.CLEARMARKS();
                    if not SalesSetup."NS_Sales Retention Inactive" then begin
                        CustLedgEntryRetention.RESET();
                        CustLedgEntryRetention.SETCURRENTKEY("Document Type", "Customer No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date", "Currency Code", "NS_Retention Ledger Code");
                        CustLedgEntryRetention.SETRANGE("Customer No.", Rec."Bill-to Customer No.");
                        CustLedgEntryRetention.SETRANGE("NS_Retention Ledger Code", JobsSetup."NS_Retention Receivable Ledger");
                        if CustLedgEntryRetention.FINDSET() then
                            repeat
                                case CustLedgEntryRetention."Document Type" of
                                    CustLedgEntryRetention."Document Type"::Invoice:
                                        begin
                                            SalesInvoiceLine.RESET();
                                            SalesInvoiceLine.SETRANGE("Document No.", CustLedgEntryRetention."Document No.");
                                            SalesInvoiceLine.SETRANGE("Job No.", Rec."No.");
                                            if SalesInvoiceLine.FINDSET() then
                                                repeat
                                                    CustLedgEntryRetention.MARK(true);
                                                until SalesInvoiceLine.NEXT() = 0;
                                        end;
                                    CustLedgEntryRetention."Document Type"::"Credit Memo":
                                        begin
                                            SalesCrMemoLine.RESET();
                                            SalesCrMemoLine.SETRANGE("Document No.", CustLedgEntryRetention."Document No.");
                                            SalesInvoiceLine.SETRANGE("Job No.", Rec."No.");
                                            if SalesCrMemoLine.FINDSET() then
                                                repeat
                                                    CustLedgEntryRetention.MARK(true);
                                                until SalesCrMemoLine.NEXT() = 0;
                                        end;
                                    CustLedgEntryRetention."Document Type"::Payment:
                                        CustLedgEntryRetention.MARK(true);
                                end;
                            until CustLedgEntryRetention.NEXT() = 0;
                    end;

                    CustLedgEntryRetention.MARKEDONLY(true);
                    PAGE.RUN(PAGE::"Customer Ledger Entries", CustLedgEntryRetention);

                end;




            }

        }
        addafter("Invoiced Price")
        {
            field(NS_ARRetentionBalance; CalcValues[3, 1])
            {
                ApplicationArea = All;
                Caption = 'A/R Retention Balance';
                Editable = false;
                Importance = Promoted;
                ToolTip = 'Retention Balance in Customer Card for this Job';
                trigger OnDrillDown();
                begin

                    CustLedgEntryRetention.CLEARMARKS();
                    if not SalesSetup."NS_Sales Retention Inactive" then begin
                        CustLedgEntryRetention.RESET();
                        CustLedgEntryRetention.SETCURRENTKEY("Document Type", "Customer No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date", "Currency Code", "NS_Retention Ledger Code");
                        CustLedgEntryRetention.SETRANGE("Customer No.", Rec."Bill-to Customer No.");
                        CustLedgEntryRetention.SETRANGE("NS_Retention Ledger Code", JobsSetup."NS_Retention Receivable Ledger");
                        if CustLedgEntryRetention.FINDSET() then
                            repeat
                                case CustLedgEntryRetention."Document Type" of
                                    CustLedgEntryRetention."Document Type"::Invoice:
                                        begin
                                            SalesInvoiceLine.RESET();
                                            SalesInvoiceLine.SETRANGE("Document No.", CustLedgEntryRetention."Document No.");
                                            SalesInvoiceLine.SETRANGE("Job No.", Rec."No.");
                                            if SalesInvoiceLine.FINDSET() then
                                                repeat
                                                    CustLedgEntryRetention.MARK(true);
                                                until SalesInvoiceLine.NEXT() = 0;
                                        end;
                                    CustLedgEntryRetention."Document Type"::"Credit Memo":
                                        begin
                                            SalesCrMemoLine.RESET();
                                            SalesCrMemoLine.SETRANGE("Document No.", CustLedgEntryRetention."Document No.");
                                            SalesInvoiceLine.SETRANGE("Job No.", Rec."No.");
                                            if SalesCrMemoLine.FINDSET() then
                                                repeat
                                                    CustLedgEntryRetention.MARK(true);
                                                until SalesCrMemoLine.NEXT() = 0;
                                        end;
                                    CustLedgEntryRetention."Document Type"::Payment:
                                        CustLedgEntryRetention.MARK(true);
                                end;
                            until CustLedgEntryRetention.NEXT() = 0;
                    end;
                    CustLedgEntryRetention.MARKEDONLY(true);
                    PAGE.RUN(PAGE::"Customer Ledger Entries", CustLedgEntryRetention);

                end;
            }
        }

    }
    var
        CalcValues: array[8, 40] of Decimal;
        CustLedgEntryRetention: Record "Cust. Ledger Entry";
        JobsSetup: Record "Jobs Setup";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesSetup: Record "Sales & Receivables Setup";

}
