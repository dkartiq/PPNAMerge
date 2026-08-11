report 14021216 "NS_Open Purch Invoices by Job"
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
    // +     PP_PurchSetup
    // +
    // +  - Modification(s):
    // +     - OnPreReport() - get Purchases & Payables Setup record
    // +     - Vendor Ledger Entry - OnPreDataItem: add filter on Retention Ledger Code if needed
    // +------------------------------------------------------------
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSOpen Purchase Invoices by Job.rdl';

    Caption = 'Open Purchase Invoices by Job';
    UsageCategory = ReportsAndAnalysis;

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
            column(Open_Purchase_Invoices_by_JobCaption; Open_Purchase_Invoices_by_JobCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry__Document_No__Caption; "Vendor Ledger Entry".FIELDCAPTION("Document No."))
            {
            }
            column(Vendor_NameCaption; Vendor_NameCaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry__Posting_Date_Caption; "Vendor Ledger Entry".FIELDCAPTION("Posting Date"))
            {
            }
            column(Vendor_Ledger_Entry__Due_Date_Caption; "Vendor Ledger Entry".FIELDCAPTION("Due Date"))
            {
            }
            column(Vendor_Ledger_Entry_AmountCaption; Vendor_Ledger_Entry_AmountCaptionLbl)
            {
            }
            column(Amount____Remaining_Amount_Caption; Amount____Remaining_Amount_CaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry__Remaining_Amount_Caption; Vendor_Ledger_Entry__Remaining_Amount_CaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry__Vendor_No__Caption; "Vendor Ledger Entry".FIELDCAPTION("Vendor No."))
            {
            }
            column(Vendor_Ledger_Entry__Currency_Code_Caption; "Vendor Ledger Entry".FIELDCAPTION("Currency Code"))
            {
            }
            dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
            {
                DataItemLink = "Job No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");
                PrintOnlyIfDetail = true;
                column(Job_TABLECAPTION__________Job__No________Total_____; Job.TABLECAPTION + ': ' + Job."No." + '  Total ($)')
                {
                }
                column(Vendor_Ledger_Entry___Amount__LCY__; "Vendor Ledger Entry"."Amount (LCY)")
                {
                }
                column(Vendor_Ledger_Entry___Amount__LCY______Vendor_Ledger_Entry___Remaining_Amt___LCY__; "Vendor Ledger Entry"."Amount (LCY)" - "Vendor Ledger Entry"."Remaining Amt. (LCY)")
                {
                }
                column(Vendor_Ledger_Entry___Remaining_Amt___LCY__; "Vendor Ledger Entry"."Remaining Amt. (LCY)")
                {
                }
                column(Purch__Inv__Line_Document_No_; "Document No.")
                {
                }
                column(Purch__Inv__Line_Line_No_; "Line No.")
                {
                }
                column(Purch__Inv__Line_Job_No_; "Job No.")
                {
                }
                dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
                {
                    DataItemLink = "Document No." = FIELD("Document No.");
                    DataItemTableView = SORTING("Document No.", "Document Type", "Vendor No.")
                                        WHERE("Document Type" = CONST(Invoice),
                                              Open = CONST(true));
                    column(Vendor_Ledger_Entry__Document_No__; "Document No.")
                    {
                    }
                    column(PurchInvoiceHeader__Pay_to_Name_; PurchInvoiceHeader."Pay-to Name")
                    {
                    }
                    column(Vendor_Ledger_Entry__Posting_Date_; "Posting Date")
                    {
                    }
                    column(Vendor_Ledger_Entry__Due_Date_; "Due Date")
                    {
                    }
                    column(Vendor_Ledger_Entry_Amount; Amount)
                    {
                    }
                    column(Amount____Remaining_Amount_; Amount - "Remaining Amount")
                    {
                    }
                    column(Vendor_Ledger_Entry__Remaining_Amount_; "Remaining Amount")
                    {
                    }
                    column(Vendor_Ledger_Entry__Vendor_No__; "Vendor No.")
                    {
                    }
                    column(Vendor_Ledger_Entry__Currency_Code_; "Currency Code")
                    {
                    }
                    column(Vendor_Ledger_Entry_Entry_No_; "Entry No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        CALCFIELDS("Amount (LCY)", "Remaining Amt. (LCY)");
                    end;

                    trigger OnPreDataItem()
                    begin
                        //ProjectPro - start
                        IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN
                            SETRANGE("NS_Retention Ledger Code", NS_PurchSetup."NS_Normal Vendor Ledger No.");
                        //ProjectPro - end
                        SETRANGE("Vendor No.", PurchInvoiceHeader."Pay-to Vendor No.");
                        CurrReport.CREATETOTALS("Amount (LCY)", "Remaining Amt. (LCY)");
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    SETRANGE("Document No.", "Document No.");
                    FIND('+');
                    SETRANGE("Document No.");
                    PurchInvoiceHeader.GET("Document No.");
                end;

                trigger OnPreDataItem()
                begin
                    IF NOT SETCURRENTKEY("Job No.", "Document No.") THEN BEGIN
                        SETCURRENTKEY("Document No.");
                        IF NOT AlreadyDisplayedMessage THEN BEGIN
                            MESSAGE(Text000 + ' ' +
                              Text001,
                              TABLENAME, FIELDCAPTION("Job No."), FIELDCAPTION("Document No."));
                            AlreadyDisplayedMessage := TRUE;
                        END;
                    END;
                    CurrReport.CREATETOTALS("Vendor Ledger Entry"."Amount (LCY)", "Vendor Ledger Entry"."Remaining Amt. (LCY)");
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
        //ProjectPro - start
        NS_PurchSetup.GET;
        //ProjectPro - end
        CompanyInformation.GET;
        FilterString := Job.GETFILTERS;
    end;

    var
        CompanyInformation: Record "Company Information";
        PurchInvoiceHeader: Record "Purch. Inv. Header";
        FilterString: Text;
        AlreadyDisplayedMessage: Boolean;
        Text000: Label 'This report will run much faster next time if you add a key to';
        Text001: Label 'the %1 table (123) which starts with %2,%3';
        Open_Purchase_Invoices_by_JobCaptionLbl: Label 'Open Purchase Invoices by Job';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Vendor_NameCaptionLbl: Label 'Vendor Name';
        Vendor_Ledger_Entry_AmountCaptionLbl: Label 'Invoice Amount';
        Amount____Remaining_Amount_CaptionLbl: Label 'Payments or Adjustments';
        Vendor_Ledger_Entry__Remaining_Amount_CaptionLbl: Label 'Balance Due';
        NS_PurchSetup: Record "Purchases & Payables Setup";
}

