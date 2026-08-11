report 14021208 "NS_Open Sales Invoices by Job"
{
    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Added field(s):
    // +
    // +
    // +  - Added function(s):
    // +
    // +
    // +  - Added global variable(s):
    // +     PP_SalesSetup
    // +
    // +  - Modification(s):
    // +     - OnPreReport: get Sales & Receivables Setup record
    // +     - Cust. Ledger Entry - OnPreDataItem: add filter on Retention Ledger Code if needed
    // +------------------------------------------------------------
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSOpen Sales Invoices by Job.rdl';

    Caption = 'Open Sales Invoices by Job';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Jobs;

    dataset
    {
        dataitem(Job; Job)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", Description, "Bill-to Customer No.", "Person Responsible";
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(TIME; TIME)
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }

            column(USERID; USERID)
            {
            }
            column(Job_TABLECAPTION__________FilterString; Job.TABLECAPTION + ': ' + FilterString)
            {
            }
            column(FilterString; FilterString)
            {
            }
            column(TABLECAPTION___________No__; TABLECAPTION + ': ' + "No.")
            {
            }
            column(Job_Description; Description)
            {
            }
            column(Job_No_; "No.")
            {
            }
            column(Open_Sales_Invoices_by_JobCaption; Open_Sales_Invoices_by_JobCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Document_No__Caption; "Cust. Ledger Entry".FIELDCAPTION("Document No."))
            {
            }
            column(SalesInvoiceHeader__Bill_to_Name_Caption; SalesInvoiceHeader__Bill_to_Name_CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Posting_Date_Caption; "Cust. Ledger Entry".FIELDCAPTION("Posting Date"))
            {
            }
            column(Cust__Ledger_Entry__Due_Date_Caption; "Cust. Ledger Entry".FIELDCAPTION("Due Date"))
            {
            }
            column(Cust__Ledger_Entry__Amount__LCY__Caption; Cust__Ledger_Entry__Amount__LCY__CaptionLbl)
            {
            }
            column(Amount__LCY______Remaining_Amt___LCY__Caption; Amount__LCY______Remaining_Amt___LCY__CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Remaining_Amt___LCY__Caption; Cust__Ledger_Entry__Remaining_Amt___LCY__CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Customer_No__Caption; "Cust. Ledger Entry".FIELDCAPTION("Customer No."))
            {
            }
            column(Cust__Ledger_Entry__Currency_Code_Caption; "Cust. Ledger Entry".FIELDCAPTION("Currency Code"))
            {
            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Job No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");
                PrintOnlyIfDetail = true;
                column(Job_TABLECAPTION__________Job__No________Total_____; Job.TABLECAPTION + ': ' + Job."No." + '  Total ($)')
                {
                }
                column(Cust__Ledger_Entry___Amount__LCY__; "Cust. Ledger Entry"."Amount (LCY)")
                {
                }
                column(Cust__Ledger_Entry___Amount__LCY______Cust__Ledger_Entry___Remaining_Amt___LCY__; "Cust. Ledger Entry"."Amount (LCY)" - "Cust. Ledger Entry"."Remaining Amt. (LCY)")
                {
                }
                column(Cust__Ledger_Entry___Remaining_Amt___LCY__; "Cust. Ledger Entry"."Remaining Amt. (LCY)")
                {
                }
                column(Sales_Invoice_Line_Document_No_; "Document No.")
                {
                }
                column(Sales_Invoice_Line_Line_No_; "Line No.")
                {
                }
                column(Sales_Invoice_Line_Job_No_; "Job No.")
                {
                }
                dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
                {
                    DataItemLink = "Document No." = FIELD("Document No.");
                    DataItemTableView = SORTING("Document No.", "Document Type", "Customer No.")
                                        WHERE("Document Type" = CONST(Invoice),
                                              Open = CONST(true));
                    column(Cust__Ledger_Entry__Document_No__; "Document No.")
                    {
                    }
                    column(SalesInvoiceHeader__Bill_to_Name_; SalesInvoiceHeader."Bill-to Name")
                    {
                    }
                    column(Cust__Ledger_Entry__Posting_Date_; "Posting Date")
                    {
                    }
                    column(Cust__Ledger_Entry__Due_Date_; "Due Date")
                    {
                    }
                    column(Cust__Ledger_Entry__Amount__LCY__; "Amount (LCY)")
                    {
                    }
                    column(Amount__LCY______Remaining_Amt___LCY__; "Amount (LCY)" - "Remaining Amt. (LCY)")
                    {
                    }
                    column(Cust__Ledger_Entry__Remaining_Amt___LCY__; "Remaining Amt. (LCY)")
                    {
                    }
                    column(Cust__Ledger_Entry__Customer_No__; "Customer No.")
                    {
                    }
                    column(Cust__Ledger_Entry__Currency_Code_; "Currency Code")
                    {
                    }
                    column(Cust__Ledger_Entry_Entry_No_; "Entry No.")
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        SETRANGE("Customer No.", SalesInvoiceHeader."Bill-to Customer No.");
                        //ProjectPro - start
                        IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
                            SETRANGE("NS_Retention Ledger Code", NS_SalesSetup."NS_Normal Customer Ledger No.");
                        //ProjectPro - end
                        CurrReport.CREATETOTALS("Amount (LCY)", "Remaining Amt. (LCY)");
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    SETRANGE("Document No.", "Document No.");
                    FIND('+');
                    SETRANGE("Document No.");
                    SalesInvoiceHeader.GET("Document No.");
                end;

                trigger OnPreDataItem()
                begin
                    IF NOT SETCURRENTKEY("Job No.", "Document No.") THEN BEGIN
                        SETCURRENTKEY("Document No.");
                        IF NOT AlreadyDisplayedMessage THEN BEGIN
                            MESSAGE(Text000Lbl + Text001Lbl,
                              TABLECAPTION, FIELDCAPTION("Job No."), FIELDCAPTION("Document No."));
                            AlreadyDisplayedMessage := TRUE;
                        END;
                    END;
                    CurrReport.CREATETOTALS("Cust. Ledger Entry"."Amount (LCY)", "Cust. Ledger Entry"."Remaining Amt. (LCY)");
                end;
            }
        }
    }

    requestpage
    {
        SaveValues = true;

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

    trigger OnPreReport()
    begin
        CompanyInformation.GET;
        //ProjectPro - start
        NS_SalesSetup.GET;
        //ProjectPro - end
        FilterString := Job.GETFILTERS;
    end;

    var
        CompanyInformation: Record "Company Information";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        FilterString: Text;
        AlreadyDisplayedMessage: Boolean;
        Text000Lbl: Label 'This report will run much faster next time if you add a key to';
        Text001Lbl: Label ' the %1 table (113) which starts with %2,%3';
        Open_Sales_Invoices_by_JobCaptionLbl: Label 'Open Sales Invoices by Job';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        SalesInvoiceHeader__Bill_to_Name_CaptionLbl: Label 'Customer Name';
        Cust__Ledger_Entry__Amount__LCY__CaptionLbl: Label 'Invoice Amount';
        Amount__LCY______Remaining_Amt___LCY__CaptionLbl: Label 'Payments or Adjustments';
        Cust__Ledger_Entry__Remaining_Amt___LCY__CaptionLbl: Label 'Balance Due';
        NS_SalesSetup: Record "Sales & Receivables Setup";
}

