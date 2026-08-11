report 14021212 "NS_Export Electronic Payments"
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
    // +     PP_PurchSetup
    // +
    // +  - Modification(s):
    // +     - OnPreReport: get Purchases & Payables Setup record, get Sales & Receivables Setup record
    // +     - Cust. Ledger Entry - OnPreDataItem: add filter on Retention Ledger Code if needed
    // +     - Vendor Ledger Entry - OnPreDataItem: add filter on Retention Ledger Code if needed
    // +------------------------------------------------------------
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSExport Electronic Payments.rdl';

    Caption = 'Export Electronic Payments';

    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Line No.")
                                WHERE("Bank Payment Type" = FILTER("Electronic Payment" | "Electronic Payment-IAT"),
                                      "Document Type" = FILTER(Payment | Refund));
            RequestFilterFields = "Journal Template Name", "Journal Batch Name";
            column(Gen__Journal_Line_Journal_Template_Name; "Journal Template Name")
            {
            }
            column(Gen__Journal_Line_Journal_Batch_Name; "Journal Batch Name")
            {
            }
            column(Gen__Journal_Line_Line_No_; "Line No.")
            {
            }
            column(Gen__Journal_Line_Applies_to_ID; "Applies-to ID")
            {
            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));
                    column(CompanyAddress_1_; CompanyAddress[1])
                    {
                    }
                    column(CompanyAddress_2_; CompanyAddress[2])
                    {
                    }
                    column(CompanyAddress_3_; CompanyAddress[3])
                    {
                    }
                    column(CompanyAddress_4_; CompanyAddress[4])
                    {
                    }
                    column(CompanyAddress_5_; CompanyAddress[5])
                    {
                    }
                    column(CompanyAddress_6_; CompanyAddress[6])
                    {
                    }
                    column(CompanyAddress_7_; CompanyAddress[7])
                    {
                    }
                    column(CompanyAddress_8_; CompanyAddress[8])
                    {
                    }
                    column(CopyTxt; CopyTxt)
                    {
                    }
                    column(PayeeAddress_1_; PayeeAddress[1])
                    {
                    }
                    column(PayeeAddress_2_; PayeeAddress[2])
                    {
                    }
                    column(PayeeAddress_3_; PayeeAddress[3])
                    {
                    }
                    column(PayeeAddress_4_; PayeeAddress[4])
                    {
                    }
                    column(PayeeAddress_5_; PayeeAddress[5])
                    {
                    }
                    column(PayeeAddress_6_; PayeeAddress[6])
                    {
                    }
                    column(PayeeAddress_7_; PayeeAddress[7])
                    {
                    }
                    column(PayeeAddress_8_; PayeeAddress[8])
                    {
                    }
                    column(Gen__Journal_Line___Document_No__; "Gen. Journal Line"."Document No.")
                    {
                    }
                    column(SettleDate; "Gen. Journal Line"."Document Date")
                    {
                    }
                    column(ExportAmount; -ExportAmount)
                    {
                    }
                    column(PayeeBankTransitNo; PayeeBankTransitNo)
                    {
                    }
                    column(PayeeBankAccountNo; PayeeBankAccountNo)
                    {
                    }
                    column(myNumber; CopyLoop.Number)
                    {
                    }
                    column(myBal; "Gen. Journal Line"."Bal. Account No.")
                    {
                    }
                    column(mypostingdate; "Gen. Journal Line"."Posting Date")
                    {
                    }
                    column(Gen__Journal_Line___Applies_to_Doc__No__; "Gen. Journal Line"."Applies-to Doc. No.")
                    {
                    }
                    column(myType; myType)
                    {
                    }
                    column(AmountPaid; AmountPaid)
                    {
                    }
                    column(DiscountTaken; DiscountTaken)
                    {
                    }
                    column(VendLedgEntry__Remaining_Amt___LCY__; -VendLedgEntry."Remaining Amt. (LCY)")
                    {
                    }
                    column(VendLedgEntry__Document_Date_; VendLedgEntry."Document Date")
                    {
                    }
                    column(VendLedgEntry__External_Document_No__; VendLedgEntry."External Document No.")
                    {
                    }
                    column(VendLedgEntry__Document_Type_; VendLedgEntry."Document Type")
                    {
                    }
                    column(AmountPaid_Control57; AmountPaid)
                    {
                    }
                    column(DiscountTaken_Control58; DiscountTaken)
                    {
                    }
                    column(CustLedgEntry__Remaining_Amt___LCY__; -CustLedgEntry."Remaining Amt. (LCY)")
                    {
                    }
                    column(CustLedgEntry__Document_Date_; CustLedgEntry."Document Date")
                    {
                    }
                    column(CustLedgEntry__Document_No__; CustLedgEntry."Document No.")
                    {
                    }
                    column(CustLedgEntry__Document_Type_; CustLedgEntry."Document Type")
                    {
                    }
                    column(PageLoop_Number; Number)
                    {
                    }
                    column(REMITTANCE_ADVICECaption; REMITTANCE_ADVICECaptionLbl)
                    {
                    }
                    column(To_Caption; To_CaptionLbl)
                    {
                    }
                    column(Remittance_Advice_Number_Caption; Remittance_Advice_Number_CaptionLbl)
                    {
                    }
                    column(Settlement_Date_Caption; Settlement_Date_CaptionLbl)
                    {
                    }
                    column(Page_Caption; Page_CaptionLbl)
                    {
                    }
                    column(ExportAmountCaption; ExportAmountCaptionLbl)
                    {
                    }
                    column(PayeeBankTransitNoCaption; PayeeBankTransitNoCaptionLbl)
                    {
                    }
                    column(Deposited_In_Caption; Deposited_In_CaptionLbl)
                    {
                    }
                    column(PayeeBankAccountNoCaption; PayeeBankAccountNoCaptionLbl)
                    {
                    }
                    column(Vendor_Ledger_Entry__Document_Type_Caption; "Vendor Ledger Entry".FIELDCAPTION("Document Type"))
                    {
                    }
                    column(Cust__Ledger_Entry__Document_No__Caption; "Cust. Ledger Entry".FIELDCAPTION("Document No."))
                    {
                    }
                    column(Vendor_Ledger_Entry__Document_Date_Caption; "Vendor Ledger Entry".FIELDCAPTION("Document Date"))
                    {
                    }
                    column(Remaining_Amt___LCY___Control36Caption; Remaining_Amt___LCY___Control36CaptionLbl)
                    {
                    }
                    column(DiscountTaken_Control38Caption; DiscountTaken_Control38CaptionLbl)
                    {
                    }
                    column(AmountPaid_Control43Caption; AmountPaid_Control43CaptionLbl)
                    {
                    }
                    dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
                    {
                        DataItemLink = "Applies-to ID" = FIELD("Applies-to ID");
                        DataItemLinkReference = "Gen. Journal Line";
                        DataItemTableView = SORTING("Customer No.", Open, Positive, "Due Date", "Currency Code")
                                            ORDER(Descending)
                                            WHERE(Open = CONST(true));
                        column(Cust__Ledger_Entry__Document_Type_; "Document Type")
                        {
                        }
                        column(Cust__Ledger_Entry__Document_No__; "Document No.")
                        {
                        }
                        column(Cust__Ledger_Entry__Document_Date_; "Document Date")
                        {
                        }
                        column(Remaining_Amt___LCY__; -"Remaining Amt. (LCY)")
                        {
                        }
                        column(DiscountTaken_Control49; DiscountTaken)
                        {
                        }
                        column(AmountPaid_Control50; AmountPaid)
                        {
                        }
                        column(Cust__Ledger_Entry_Entry_No_; "Entry No.")
                        {
                        }
                        column(Cust__Ledger_Entry_Applies_to_ID; "Applies-to ID")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            CALCFIELDS("Remaining Amt. (LCY)");
                            IF ("Pmt. Discount Date" >= "Gen. Journal Line"."Document Date") AND
                               ("Remaining Pmt. Disc. Possible" <> 0) AND
                               ((-ExportAmount - TotalAmountPaid) - "Remaining Pmt. Disc. Possible" >= -"Amount to Apply")
                            THEN BEGIN
                                DiscountTaken := -"Remaining Pmt. Disc. Possible";
                                AmountPaid := -("Amount to Apply" - "Remaining Pmt. Disc. Possible");
                            END ELSE BEGIN
                                DiscountTaken := 0;
                                IF (-ExportAmount - TotalAmountPaid) > -"Amount to Apply" THEN
                                    AmountPaid := -"Amount to Apply"
                                ELSE
                                    AmountPaid := -ExportAmount - TotalAmountPaid;
                            END;

                            TotalAmountPaid := TotalAmountPaid + AmountPaid;
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF "Gen. Journal Line"."Applies-to ID" = '' THEN
                                CurrReport.BREAK;

                            IF BankAccountIs = BankAccountIs::Acnt THEN BEGIN
                                IF "Gen. Journal Line"."Bal. Account Type" <> "Gen. Journal Line"."Bal. Account Type"::Customer THEN
                                    CurrReport.BREAK;
                                SETRANGE("Customer No.", "Gen. Journal Line"."Bal. Account No.");
                            END ELSE BEGIN
                                IF "Gen. Journal Line"."Account Type" <> "Gen. Journal Line"."Account Type"::Customer THEN
                                    CurrReport.BREAK;
                                SETRANGE("Customer No.", "Gen. Journal Line"."Account No.");
                            END;
                            //ProjectPro - start
                            IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
                                SETRANGE("NS_Retention Ledger Code", NS_SalesSetup."NS_Normal Customer Ledger No.");
                            //ProjectPro - end
                        end;
                    }
                    dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
                    {
                        DataItemLink = "Applies-to ID" = FIELD("Applies-to ID");
                        DataItemLinkReference = "Gen. Journal Line";
                        DataItemTableView = SORTING("Vendor No.", Open, Positive, "Due Date", "Currency Code")
                                            ORDER(Descending)
                                            WHERE(Open = CONST(true));
                        column(Vendor_Ledger_Entry__Document_Type_; "Document Type")
                        {
                        }
                        column(Vendor_Ledger_Entry__External_Document_No__; "External Document No.")
                        {
                        }
                        column(Vendor_Ledger_Entry__Document_Date_; "Document Date")
                        {
                        }
                        column(Remaining_Amt___LCY___Control36; -"Remaining Amt. (LCY)")
                        {
                        }
                        column(DiscountTaken_Control38; DiscountTaken)
                        {
                        }
                        column(AmountPaid_Control43; AmountPaid)
                        {
                        }
                        column(Vendor_Ledger_Entry_Entry_No_; "Entry No.")
                        {
                        }
                        column(Vendor_Ledger_Entry_Applies_to_ID; "Applies-to ID")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            CALCFIELDS("Remaining Amt. (LCY)");
                            IF ("Pmt. Discount Date" >= "Gen. Journal Line"."Document Date") AND
                               ("Remaining Pmt. Disc. Possible" <> 0) AND
                               ((-ExportAmount - TotalAmountPaid) - "Remaining Pmt. Disc. Possible" >= -"Amount to Apply")
                            THEN BEGIN
                                DiscountTaken := -"Remaining Pmt. Disc. Possible";
                                AmountPaid := -("Amount to Apply" - "Remaining Pmt. Disc. Possible");
                            END ELSE BEGIN
                                DiscountTaken := 0;
                                IF (-ExportAmount - TotalAmountPaid) > -"Amount to Apply" THEN
                                    AmountPaid := -"Amount to Apply"
                                ELSE
                                    AmountPaid := -ExportAmount - TotalAmountPaid;
                            END;

                            TotalAmountPaid := TotalAmountPaid + AmountPaid;
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF "Gen. Journal Line"."Applies-to ID" = '' THEN
                                CurrReport.BREAK;

                            IF BankAccountIs = BankAccountIs::Acnt THEN BEGIN
                                IF "Gen. Journal Line"."Bal. Account Type" <> "Gen. Journal Line"."Bal. Account Type"::Vendor THEN
                                    CurrReport.BREAK;
                                SETRANGE("Vendor No.", "Gen. Journal Line"."Bal. Account No.");
                            END ELSE BEGIN
                                IF "Gen. Journal Line"."Account Type" <> "Gen. Journal Line"."Account Type"::Vendor THEN
                                    CurrReport.BREAK;
                                SETRANGE("Vendor No.", "Gen. Journal Line"."Account No.");
                            END;
                        end;
                    }
                    dataitem(Unapplied; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));
                        column(Text004; Text004Lbl)
                        {
                        }
                        column(AmountPaid_Control65; AmountPaid)
                        {
                        }
                        column(Unapplied_Number; Number)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            AmountPaid := -ExportAmount - TotalAmountPaid;
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF TotalAmountPaid >= -ExportAmount THEN
                                CurrReport.BREAK;
                        end;
                    }

                    trigger OnPreDataItem()
                    begin
                        myType := PayeeType;// an Integer variable refer to  option type
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    AmountPaid := SaveAmountPaid;

                    IF Number = 1 THEN // Original
                        CLEAR(CopyTxt)
                    ELSE
                        CopyTxt := CopyLoopLbl;

                    IF "Gen. Journal Line"."Applies-to Doc. No." = '' THEN
                        CLEAR(TotalAmountPaid);
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE(Number, 1, NoCopies + 1);
                    SaveAmountPaid := AmountPaid;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IF "Account Type" = "Account Type"::"Bank Account" THEN BEGIN
                    BankAccountIs := BankAccountIs::Acnt;
                    IF "Account No." <> BankAccount."No." THEN
                        CurrReport.SKIP;
                END ELSE
                    IF "Bal. Account Type" = "Bal. Account Type"::"Bank Account" THEN BEGIN
                        BankAccountIs := BankAccountIs::BalAcnt;
                        IF "Bal. Account No." <> BankAccount."No." THEN
                            CurrReport.SKIP;
                    END ELSE
                        CurrReport.SKIP;
                IF BankAccountIs = BankAccountIs::Acnt THEN BEGIN
                    ExportAmount := "Amount (LCY)";
                    IF "Bal. Account Type" = "Bal. Account Type"::Vendor THEN BEGIN
                        PayeeType := PayeeType::Vendor;
                        Vendor.GET("Bal. Account No.");
                    END ELSE
                        IF "Bal. Account Type" = "Bal. Account Type"::Customer THEN BEGIN
                            PayeeType := PayeeType::Customer;
                            Customer.GET("Bal. Account No.");
                        END ELSE
                            ERROR(AccountTypeErr,
                              FIELDCAPTION("Bal. Account Type"), Customer.TABLECAPTION, Vendor.TABLECAPTION);
                END ELSE BEGIN
                    ExportAmount := -"Amount (LCY)";
                    IF "Account Type" = "Account Type"::Vendor THEN BEGIN
                        PayeeType := PayeeType::Vendor;
                        Vendor.GET("Account No.");
                    END ELSE
                        IF "Account Type" = "Account Type"::Customer THEN BEGIN
                            PayeeType := PayeeType::Customer;
                            Customer.GET("Account No.");
                        END ELSE
                            ERROR(AccountTypeErr,
                              FIELDCAPTION("Account Type"), Customer.TABLECAPTION, Vendor.TABLECAPTION);
                END;

                DiscountTaken := 0;
                AmountPaid := 0;
                TotalAmountPaid := 0;
                IF PayeeType = PayeeType::Vendor THEN
                    ProcessVendor("Gen. Journal Line")
                ELSE
                    ProcessCustomer("Gen. Journal Line");

                TotalAmountPaid := AmountPaid;
            end;

            trigger OnPreDataItem()
            begin
                // If we're in preview mode, the items haven't been exported yet - filter appropriately
                IF CurrReport.PREVIEW THEN BEGIN
                    SETRANGE("Check Exported", FALSE);
                    SETRANGE("Check Printed", FALSE);
                END ELSE BEGIN
                    SETRANGE("Check Exported", FALSE);
                    SETRANGE("Check Printed", FALSE);
                    SETRANGE("Check Transmitted", FALSE);
                END
            end;
        }
    }

    requestpage
    {
        Caption = 'Export Electronic Payments';
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(BankAccountNo; BankAccount."No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Bank Account No.';
                        TableRelation = "Bank Account";
                        ToolTip = 'Specifies the bank account that the payment is exported to.';
                    }
                    field(NumberOfCopies; NoCopies)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Number of Copies';
                        MaxValue = 9;
                        MinValue = 0;
                        ToolTip = 'Specifies the number of copies of each document (in addition to the original) that you want to print.';
                    }
                    field(PrintCompanyAddress; PrintCompany)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Company Address';
                        ToolTip = 'Specifies if your company address is printed at the top of the sheet, because you do not use pre-printed paper. Leave this check box blank to omit your company''s address.';
                    }
                    group(OutputOptions)
                    {
                        Caption = 'Output Options';
                        field(OutputMethod; SupportedOutputMethod)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Output Method';
                            ToolTip = 'Specifies how the electronic payment is exported.';
                            OptionCaption = 'Print,Preview,PDF,Email,Excel,XML';

                            trigger OnValidate()
                            begin
                                MapOutputMethod;
                            end;
                        }
                        field(ChosenOutput; ChosenOutputMethod)
                        {
                            Caption = 'ChosenOutput';
                            Visible = false;
                            ApplicationArea = all;
                            ToolTip = 'Choosen Output';
                        }
                    }
                    group(EmailOptions)
                    {
                        Caption = 'Email Options';
                        Visible = ShowPrintRemaining;
                        field(PrintMissingAddresses; PrintRemaining)
                        {
                            Caption = 'Print remaining statements';
                            ApplicationArea = all;
                            ToolTip = 'Print remaining statements';
                        }
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            MapOutputMethod;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        "Filter": Text;
    begin
        //ProjectPro - start
        NS_SalesSetup.GET;
        NS_PurchSetup.GET;
        //ProjectPro - end
        CompanyInformation.GET;
        Filter := "Gen. Journal Line".GETFILTER("Journal Template Name");
        IF Filter = '' THEN BEGIN
            "Gen. Journal Line".FILTERGROUP(0); // head back to the default filter group and check there.
            Filter := "Gen. Journal Line".GETFILTER("Journal Template Name")
        END;
        GenJournalTemplate.GET(Filter);

        WITH BankAccount DO BEGIN
            GET("No.");
            TESTFIELD(Blocked, FALSE);
            TESTFIELD("Currency Code", '');  // local currency only

            //PPDA.1.0 Start
            OnBeforeApplyTestFieldOnPreReport(BankAccount);//PPDA.1.0 Added
            // TESTFIELD("Export Format"); //PPDA.1.0 Commented
            // TESTFIELD("Last Remittance Advice No."); //PPDA.1.0 Commented
            //PPDA.1.0 End
        END;

        GenJournalTemplate.GET("Gen. Journal Line".GETFILTER("Journal Template Name"));
        IF NOT GenJournalTemplate."Force Doc. Balance" THEN
            IF NOT CONFIRM(CannotVoidQst, TRUE) THEN
                ERROR(UserCancelledErr);

        IF PrintCompany THEN
            FormatAddress.Company(CompanyAddress, CompanyInformation)
        ELSE
            CLEAR(CompanyAddress);
    end;

    var
        CompanyInformation: Record "Company Information";
        GenJournalTemplate: Record "Gen. Journal Template";
        BankAccount: Record "Bank Account";
        Customer: Record Customer;
        CustBankAccount: Record "Customer Bank Account";
        CustLedgEntry: Record "Cust. Ledger Entry";
        Vendor: Record Vendor;
        VendBankAccount: Record "Vendor Bank Account";
        VendLedgEntry: Record "Vendor Ledger Entry";
        FormatAddress: Codeunit "Format Address";
        ExportAmount: Decimal;
        BankAccountIs: Option Acnt,BalAcnt;
        NoCopies: Integer;
        CopyTxt: Code[10];
        PrintCompany: Boolean;
        CompanyAddress: array[8] of Text[50];
        PayeeAddress: array[8] of Text[50];
        PayeeType: Option Vendor,Customer;
        PayeeBankTransitNo: Text[30];
        PayeeBankAccountNo: Text[30];
        DiscountTaken: Decimal;
        AmountPaid: Decimal;
        TotalAmountPaid: Decimal;
        AccountTypeErr: Label 'For Electronic Payments, the %1 must be %2 or %3.', Comment = '%1=Balance account type,%2=Customer table caption,%3=Vendor table caption';
        BankAcctElecPaymentErr: Label 'You must have exactly one %1 with %2 checked for %3 %4.', Comment = '%1=Bank account table caption,%2=Bank account field caption - use for electronic payments,%3=Vendor/Customer table caption,%4=Vendor/Customer number';
        CopyLoopLbl: Label 'COPY', Comment = 'This is the word ''copy'' in all capital letters. It is used for extra copies of a report and indicates that the specific version is not the original, and is a copy.';
        CannotVoidQst: Label 'Warning:  Transactions cannot be financially voided when Force Doc. Balance is set to No in the Journal Template.  Do you want to continue anyway?';
        UserCancelledErr: Label 'Process canceled at user request.';
        myType: Integer;
        SaveAmountPaid: Decimal;
        REMITTANCE_ADVICECaptionLbl: Label 'REMITTANCE ADVICE';
        To_CaptionLbl: Label 'To:';
        Remittance_Advice_Number_CaptionLbl: Label 'Remittance Advice Number:';
        Settlement_Date_CaptionLbl: Label 'Settlement Date:';
        Page_CaptionLbl: Label 'Page:';
        ExportAmountCaptionLbl: Label 'Deposit Amount:';
        PayeeBankTransitNoCaptionLbl: Label 'Bank Transit No:';
        Deposited_In_CaptionLbl: Label 'Deposited In:';
        PayeeBankAccountNoCaptionLbl: Label 'Bank Account No:';
        Remaining_Amt___LCY___Control36CaptionLbl: Label 'Amount Due';
        DiscountTaken_Control38CaptionLbl: Label 'Discount Taken';
        AmountPaid_Control43CaptionLbl: Label 'Amount Paid';
        Text004Lbl: Label 'Unapplied Amount';
        SupportedOutputMethod: Option Print,Preview,PDF,Email,Excel,XML;
        ChosenOutputMethod: Integer;
        PrintRemaining: Boolean;
        [InDataSet]
        ShowPrintRemaining: Boolean;
        NS_SalesSetup: Record "Sales & Receivables Setup";
        NS_PurchSetup: Record "Purchases & Payables Setup";

    local procedure MapOutputMethod()
    var
        CustomLayoutReporting: Codeunit "Custom Layout Reporting";
    begin
        ShowPrintRemaining := (SupportedOutputMethod = SupportedOutputMethod::Email);
        // Supported types: Print,Preview,PDF,Email,Excel,XML
        CASE SupportedOutputMethod OF
            SupportedOutputMethod::Print:
                ChosenOutputMethod := CustomLayoutReporting.GetPrintOption;
            SupportedOutputMethod::Preview:
                ChosenOutputMethod := CustomLayoutReporting.GetPreviewOption;
            SupportedOutputMethod::PDF:
                ChosenOutputMethod := CustomLayoutReporting.GetPDFOption;
            SupportedOutputMethod::Email:
                ChosenOutputMethod := CustomLayoutReporting.GetEmailOption;
            SupportedOutputMethod::Excel:
                ChosenOutputMethod := CustomLayoutReporting.GetExcelOption;
            SupportedOutputMethod::XML:
                ChosenOutputMethod := CustomLayoutReporting.GetXMLOption;
        END;
    end;

    local procedure ProcessVendor(var GenJnlLine: Record "Gen. Journal Line")

    begin
        FormatAddress.Vendor(PayeeAddress, Vendor);
        VendBankAccount.SETRANGE("Vendor No.", Vendor."No.");
        //PPDA.1.0 Start
        OnBeforeShowErrorInProcessVendor(VendBankAccount, Vendor); //PPDA.1.0 Added
        // VendBankAccount.SETRANGE("Use for Electronic Payments", TRUE);//PPDA.1.0 Commented
        // IF VendBankAccount.COUNT <> 1 THEN
        //     ERROR(BankAcctElecPaymentErr,
        //       VendBankAccount.TABLECAPTION, VendBankAccount.FIELDCAPTION("Use for Electronic Payments"),
        //       Vendor.TABLECAPTION, Vendor."No.");
        //PPDA.1.0 End
        VendBankAccount.FINDFIRST;
        PayeeBankTransitNo := VendBankAccount."Transit No.";
        PayeeBankAccountNo := VendBankAccount."Bank Account No.";
        IF GenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
            VendLedgEntry.RESET;
            VendLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Vendor No.");
            VendLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
            VendLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
            VendLedgEntry.SETRANGE("Vendor No.", Vendor."No.");
            VendLedgEntry.SETRANGE(Open, TRUE);
            VendLedgEntry.FINDFIRST;
            VendLedgEntry.CALCFIELDS("Remaining Amt. (LCY)");
            IF (VendLedgEntry."Pmt. Discount Date" >= GenJnlLine."Document Date") AND
               (VendLedgEntry."Remaining Pmt. Disc. Possible" <> 0) AND
               (-(ExportAmount + VendLedgEntry."Remaining Pmt. Disc. Possible") >= -VendLedgEntry."Amount to Apply")
            THEN BEGIN
                DiscountTaken := -VendLedgEntry."Remaining Pmt. Disc. Possible";
                AmountPaid := -(VendLedgEntry."Amount to Apply" - VendLedgEntry."Remaining Pmt. Disc. Possible");
            END ELSE
                IF -ExportAmount > -VendLedgEntry."Amount to Apply" THEN
                    AmountPaid := -VendLedgEntry."Amount to Apply"
                ELSE
                    AmountPaid := -ExportAmount;
        END;
    end;

    local procedure ProcessCustomer(var GenJnlLine: Record "Gen. Journal Line")
    begin
        FormatAddress.Customer(PayeeAddress, Customer);
        CustBankAccount.SETRANGE("Customer No.", Customer."No.");
        //PPDA.1.0 Start
        OnBeforeShowErrorInProcessCustomer(CustBankAccount, Customer); //PPDA.1.0 Added
        // CustBankAccount.SETRANGE("Use for Electronic Payments", TRUE);
        // IF CustBankAccount.COUNT <> 1 THEN
        //     ERROR(BankAcctElecPaymentErr,
        //       CustBankAccount.TABLECAPTION, CustBankAccount.FIELDCAPTION("Use for Electronic Payments"),
        //       Customer.TABLECAPTION, Customer."No.");
        //PPDA.1.0 End
        CustBankAccount.FINDFIRST;
        PayeeBankTransitNo := CustBankAccount."Transit No.";
        PayeeBankAccountNo := CustBankAccount."Bank Account No.";
        IF GenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
            CustLedgEntry.RESET;
            CustLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Customer No.");
            CustLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
            CustLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
            CustLedgEntry.SETRANGE("Customer No.", Customer."No.");
            CustLedgEntry.SETRANGE(Open, TRUE);
            CustLedgEntry.FINDFIRST;
            CustLedgEntry.CALCFIELDS("Remaining Amt. (LCY)");
            IF (CustLedgEntry."Pmt. Discount Date" >= GenJnlLine."Document Date") AND
               (CustLedgEntry."Remaining Pmt. Disc. Possible" <> 0) AND
               (-(ExportAmount - CustLedgEntry."Remaining Pmt. Disc. Possible") >= -CustLedgEntry."Amount to Apply")
            THEN BEGIN
                DiscountTaken := -CustLedgEntry."Remaining Pmt. Disc. Possible";
                AmountPaid := -(CustLedgEntry."Amount to Apply" - CustLedgEntry."Remaining Pmt. Disc. Possible");
            END ELSE
                IF -ExportAmount > -CustLedgEntry."Amount to Apply" THEN
                    AmountPaid := -CustLedgEntry."Amount to Apply"
                ELSE
                    AmountPaid := -ExportAmount;
        END;
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeApplyTestFieldOnPreReport(Var BankAccount: Record "Bank Account")
    begin
    end;

    [IntegrationEvent(False, false)]
    local procedure OnBeforeShowErrorInProcessVendor(Var VendBankAccount: Record "Vendor Bank Account"; Var Vendor: record Vendor)
    begin
    end;

    [IntegrationEvent(False, false)]
    local procedure OnBeforeShowErrorInProcessCustomer(Var CustBankAccount: Record "Customer Bank Account"; Var Customer: record Customer)
    begin
    end;
}

