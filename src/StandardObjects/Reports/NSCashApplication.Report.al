report 14021214 "NS_Cash Application"
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
    // +     NS_PurchSetup
    // +
    // +  - Modification(s):
    // +     - OnPreReport: get Purchases & Payables Setup record
    // +     - Vendor Ledger Entry - OnPreDataItem: add filter on Retention Ledger Code if needed
    // +     - Vendor Ledger Entry 2 - OnPreDataItem: add filter on Retention Ledger Code if needed
    // +------------------------------------------------------------
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSCash Application.rdl';

    ApplicationArea = Basic, Suite;
    Caption = 'Job Cash Application';//PE-141.NK.1.0 03Aug2023 updated name
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Vendor Posting Group", "Purchaser Code", Priority, "Payment Method Code";
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
            column(PaymentDateString; PaymentDateString)
            {
            }
            column(LastDueDate; LastDueDate)
            {
            }
            column(TakeDiscounts; TakeDiscounts)
            {
            }
            column(PrintAmountsInLocal; PrintAmountsInLocal)
            {
            }
            column(UseExternalDocNo; UseExternalDocNo)
            {
            }
            column(FilterString; FilterString)
            {
            }
            column(Invoices_are_included_which_are_due_through_____FORMAT_LastDueDate_______; 'Invoices are included which are due through ' + FORMAT(LastDueDate) + '.')
            {
            }
            column(DataItem14; 'Invoices which are not yet due may be included so that all available payment discounts can be taken up to ' + FORMAT(DiscountDate) + '.')
            {
            }
            column(Document_Number_is______Vendor_Ledger_Entry__FIELDCAPTION__External_Document_No___; 'Document Number is ' + "Vendor Ledger Entry".FIELDCAPTION("External Document No."))
            {
            }
            column(Vendor_TABLECAPTION__________FilterString; Vendor.TABLECAPTION + ': ' + FilterString)
            {
            }
            column(Vendor__No__; "No.")
            {
            }
            column(Vendor_Name; Name)
            {
            }
            column(BlockedDescription; BlockedDescription)
            {
            }
            column(Vendor__Phone_No__; "Phone No.")
            {
            }
            column(Vendor_Contact; Contact)
            {
            }
            column(GTotAmountDue; GTotAmountDue)
            {
            }
            column(GTotDiscountToTake; GTotDiscountToTake)
            {
            }
            column(GTotAmountToPay; GTotAmountToPay)
            {
            }
            column(Vendor_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(Vendor_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            column(Cash_Application_WorksheetCaption; Cash_Application_WorksheetCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(No_invoices_which_are_due_are_included_Caption; No_invoices_which_are_due_are_included_CaptionLbl)
            {
            }
            column(Control17Caption; CAPTIONCLASSTRANSLATE('101,1,' + Text005))
            {
            }
            column(DocumentCaption; DocumentCaptionLbl)
            {
            }
            column(Vendor__No__Caption; Vendor__No__CaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry__Document_Type_Caption; Vendor_Ledger_Entry__Document_Type_CaptionLbl)
            {
            }
            column(DocNoCaption; DocNoCaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry__Due_Date_Caption; "Vendor Ledger Entry".FIELDCAPTION("Due Date"))
            {
            }
            column(Vendor_Ledger_Entry__Pmt__Discount_Date_Caption; Vendor_Ledger_Entry__Pmt__Discount_Date_CaptionLbl)
            {
            }
            column(InvoiceAmountCaption; InvoiceAmountCaptionLbl)
            {
            }
            column(AmountDueCaption; AmountDueCaptionLbl)
            {
            }
            column(DiscountToTakeCaption; DiscountToTakeCaptionLbl)
            {
            }
            column(AmountToPayCaption; AmountToPayCaptionLbl)
            {
            }
            column(Actual_Amount_to_PayCaption; Actual_Amount_to_PayCaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry__Currency_Code_Caption; Vendor_Ledger_Entry__Currency_Code_CaptionLbl)
            {
            }
            column(Vendor__Phone_No__Caption; Vendor__Phone_No__CaptionLbl)
            {
            }
            column(Vendor_ContactCaption; FIELDCAPTION(Contact))
            {
            }
            column(Control1020000Caption; CAPTIONCLASSTRANSLATE(GetCurrencyCaptionCode("Currency Code")))
            {
            }
            column(Control44Caption; CAPTIONCLASSTRANSLATE('101,0,' + Text006))
            {
            }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No."),
                               "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                               "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                DataItemTableView = SORTING("Vendor No.", Open, Positive, "Due Date")
                                    WHERE(Open = CONST(true),
                                          Positive = CONST(false),
                                          "On Hold" = CONST());
                column(Vendor_Ledger_Entry__Document_Type_; "Document Type")
                {
                }
                column(DocNo; DocNo)
                {
                }
                column(Vendor_Ledger_Entry__Due_Date_; "Due Date")
                {
                }
                column(Vendor_Ledger_Entry__Pmt__Discount_Date_; "Pmt. Discount Date")
                {
                }
                column(InvoiceAmount; InvoiceAmount)
                {
                }
                column(AmountDue; AmountDue)
                {
                }
                column(DiscountToTake; DiscountToTake)
                {
                }
                column(AmountToPay; AmountToPay)
                {
                }
                column(Vendor_Ledger_Entry__Currency_Code_; "Currency Code")
                {
                }
                column(Vendor_Ledger_Entry_Entry_No_; "Entry No.")
                {
                }
                column(Vendor_Ledger_Entry_Vendor_No_; "Vendor No.")
                {
                }
                column(Vendor_Ledger_Entry_Global_Dimension_1_Code; "Global Dimension 1 Code")
                {
                }
                column(Vendor_Ledger_Entry_Global_Dimension_2_Code; "Global Dimension 2 Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    AnyDetails := TRUE;
                    SETRANGE("Date Filter", PaymentDate, DiscountDate);
                    CalcAmounts("Vendor Ledger Entry");
                    IF UseExternalDocNo THEN
                        DocNo := "External Document No."
                    ELSE
                        DocNo := "Document No.";
                end;

                trigger OnPreDataItem()
                begin
                    // Round One:  Payment Discounts
                    IF NOT TakeDiscounts THEN
                        CurrReport.BREAK;
                    SETRANGE("Pmt. Discount Date", PaymentDate, DiscountDate);
                    SETFILTER("Original Pmt. Disc. Possible", '<0');
                    //ProjectPro - start
                    IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN
                        SETRANGE("NS_Retention Ledger Code", NS_PurchSetup."NS_Normal Vendor Ledger No.");
                    //ProjectPro - end
                end;
            }
            dataitem("Vendor Ledger Entry 2"; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No."),
                               "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                               "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                DataItemTableView = SORTING("Vendor No.", Open, Positive, "Due Date")
                                    WHERE(Open = CONST(true),
                                          Positive = CONST(false),
                                          "On Hold" = CONST());
                column(Vendor_Ledger_Entry_2__Document_Type_; "Document Type")
                {
                }
                column(DocNo_Control54; DocNo)
                {
                }
                column(Vendor_Ledger_Entry_2__Due_Date_; "Due Date")
                {
                }
                column(Vendor_Ledger_Entry_2__Pmt__Discount_Date_; "Pmt. Discount Date")
                {
                }
                column(InvoiceAmount_Control57; InvoiceAmount)
                {
                }
                column(AmountDue_Control58; AmountDue)
                {
                }
                column(DiscountToTake_Control59; DiscountToTake)
                {
                }
                column(AmountToPay_Control60; AmountToPay)
                {
                }
                column(Vendor_Ledger_Entry_2__Currency_Code_; "Currency Code")
                {
                }
                column(Vendor_Ledger_Entry_2_Entry_No_; "Entry No.")
                {
                }
                column(Vendor_Ledger_Entry_2_Vendor_No_; "Vendor No.")
                {
                }
                column(Vendor_Ledger_Entry_2_Global_Dimension_1_Code; "Global Dimension 1 Code")
                {
                }
                column(Vendor_Ledger_Entry_2_Global_Dimension_2_Code; "Global Dimension 2 Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    /* check and see if we already took care of this one above */
                    IF TakeDiscounts AND // if it is relevant
                       ("Pmt. Discount Date" <= DiscountDate) AND
                       ("Pmt. Discount Date" >= PaymentDate) AND
                       ("Original Pmt. Disc. Possible" < 0)
                    THEN
                        CurrReport.SKIP;
                    AnyDetails := TRUE;
                    CalcAmounts("Vendor Ledger Entry 2");

                    IF UseExternalDocNo THEN
                        DocNo := "External Document No."
                    ELSE
                        DocNo := "Document No.";

                end;

                trigger OnPreDataItem()
                begin
                    // Round Two:  Items Due at or before Last Due Date
                    SETRANGE("Pmt. Discount Date");        // remove old filters
                    SETRANGE("Original Pmt. Disc. Possible");
                    IF LastDueDate = 0D THEN                  // do not include invoices
                        CurrReport.BREAK; // just because they are

                    SETRANGE("Due Date", 0D, LastDueDate);  // add new filter
                                                            //ProjectPro - start
                    IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN
                        SETRANGE("NS_Retention Ledger Code", NS_PurchSetup."NS_Normal Vendor Ledger No.");
                    //ProjectPro - end
                end;
            }
            dataitem("Vendor Totals"; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = CONST(1));
                column(Vendor__No___Control61; Vendor."No.")
                {
                }
                column(VTotAmountDue; VTotAmountDue)
                {
                }
                column(VTotDiscountToTake; VTotDiscountToTake)
                {
                }
                column(VTotAmountToPay; VTotAmountToPay)
                {
                }
                column(Vendor_Totals_Number; Number)
                {
                }
                column(Control1020001Caption; CAPTIONCLASSTRANSLATE(GetCurrencyCaptionCode(Vendor."Currency Code")))
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF NOT AnyDetails THEN
                        CurrReport.SKIP;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                AnyDetails := FALSE;
                VTotAmountDue := 0;
                VTotDiscountToTake := 0;
                VTotAmountToPay := 0;
                IF "Privacy Blocked" THEN
                    BlockedDescription := PrivacyBlockedTxt
                ELSE
                    BlockedDescription := '';
                IF Blocked <> Blocked::" " THEN
                    BlockedDescription := STRSUBSTNO(Text002, Blocked)
                ELSE
                    BlockedDescription := '';
                IF PrintAmountsInLocal THEN
                    GetCurrencyRecord(Currency, "Currency Code");
                IF PaymentDate = 0D THEN
                    PaymentDate := WORKDATE;
                IF TakeDiscounts AND (DiscountDate < PaymentDate) THEN
                    DiscountDate := PaymentDate;
                PaymentDateString := '(For Payment on ' + FORMAT(PaymentDate, 0, 4) + ')';
            end;

            trigger OnPreDataItem()
            begin
                IF (LastDueDate = 0D) AND NOT TakeDiscounts THEN
                    ERROR(Text000
                      + Text001);
                GTotAmountDue := 0;
                GTotDiscountToTake := 0;
                GTotAmountToPay := 0;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PaymentDate; PaymentDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Payment Date';
                        ToolTip = 'Specifies the date when the payment was made.';
                    }
                    field(LastDueDate; LastDueDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Last Due Date to Pay';
                        ToolTip = 'Specifies the payment due date.';
                    }
                    field(TakePaymentDiscounts; TakeDiscounts)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Take Payment Discounts';
                        ToolTip = 'Specifies if you want to print payment amounts and dates that assume payments will be eligible for all available payment discounts.';
                    }
                    field(LastDiscDateToTake; DiscountDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Last Disc. Date to Take';
                        ToolTip = 'Specifies a payment discount due date. Payment discounts that lapse before the selected date will not be included in the report.';
                    }
                    field(PrintAmountsInLocal; PrintAmountsInLocal)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Print Amounts in Vendor''s Currency';
                        MultiLine = true;
                        ToolTip = 'Specifies if amounts are printed in the vendor''s currency. Clear the check box to print all amounts in US dollars.';
                    }
                    field(UseExternalDocNo; UseExternalDocNo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Use External Doc. No.';
                        ToolTip = 'Specifies if you want to print the vendor''s document numbers, such as the invoice number, on all transactions. Clear this check box to print only internal document numbers.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnClosePage()
        begin
            IF NOT TakeDiscounts THEN
                DiscountDate := 0D
            ELSE
                IF DiscountDate < PaymentDate THEN
                    DiscountDate := PaymentDate;
        end;
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
        GLSetup.GET;
        FilterString := Vendor.GETFILTERS;
    end;

    var
        CompanyInformation: Record "Company Information";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        GLSetup: Record "General Ledger Setup";
        FilterString: Text;
        PaymentDate: Date;
        LastDueDate: Date;
        TakeDiscounts: Boolean;
        DiscountDate: Date;
        PrintAmountsInLocal: Boolean;
        PaymentDateString: Text[40];
        InvoiceAmount: Decimal;
        AmountDue: Decimal;
        DiscountToTake: Decimal;
        AmountToPay: Decimal;
        "AmountDue($)": Decimal;
        "DiscountToTake($)": Decimal;
        "AmountToPay($)": Decimal;
        VTotAmountDue: Decimal;
        VTotDiscountToTake: Decimal;
        VTotAmountToPay: Decimal;
        GTotAmountDue: Decimal;
        GTotDiscountToTake: Decimal;
        GTotAmountToPay: Decimal;
        BlockedDescription: Text[80];
        AnyDetails: Boolean;
        UseExternalDocNo: Boolean;
        DocNo: Code[50];
        Text000: Label 'You must select either to Take Discounts or enter a ';
        Text001: Label 'Last Due Date, or both if you want.';
        Text002: Label '*** This vendor is blocked for %1 processing ***';
        PrivacyBlockedTxt: Label '*** This vendor is blocked for privacy ***.';
        Text003: Label 'Amounts are in %1';
        Text005: Label 'Amounts are in the vendor''s local currency (report total is in %1).';
        Text006: Label 'Report Total (%1)';
        Cash_Application_WorksheetCaptionLbl: Label 'Cash Application Worksheet';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        No_invoices_which_are_due_are_included_CaptionLbl: Label 'No invoices which are due are included.';
        DocumentCaptionLbl: Label 'Document';
        Vendor__No__CaptionLbl: Label 'Vendor';
        Vendor_Ledger_Entry__Document_Type_CaptionLbl: Label 'Type';
        DocNoCaptionLbl: Label 'Number';
        Vendor_Ledger_Entry__Pmt__Discount_Date_CaptionLbl: Label 'Discount Date';
        InvoiceAmountCaptionLbl: Label 'Orig. Invoice Amount';
        AmountDueCaptionLbl: Label 'Amount Due';
        DiscountToTakeCaptionLbl: Label 'Discount Available';
        AmountToPayCaptionLbl: Label 'Suggested Amount to Pay';
        Actual_Amount_to_PayCaptionLbl: Label 'Actual Amount to Pay';
        Vendor_Ledger_Entry__Currency_Code_CaptionLbl: Label 'Orig. Inv. Currency';
        Vendor__Phone_No__CaptionLbl: Label 'Phone';
        NS_PurchSetup: Record "Purchases & Payables Setup";

    [Scope('Cloud')]
    procedure CalcAmounts(VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        VendorLedgerEntry.SETRANGE("Date Filter", 0D, LastDueDate);
        VendorLedgerEntry.CALCFIELDS(Amount, "Remaining Amount", "Remaining Amt. (LCY)");
        InvoiceAmount := -VendorLedgerEntry.Amount;
        "AmountDue($)" := -VendorLedgerEntry."Remaining Amt. (LCY)";

        IF (VendorLedgerEntry."Original Pmt. Disc. Possible" < 0) AND
           (VendorLedgerEntry."Pmt. Discount Date" >= PaymentDate)
        THEN
            DiscountToTake := -VendorLedgerEntry."Original Pmt. Disc. Possible"
        ELSE
            DiscountToTake := 0;

        IF Vendor."Currency Code" <> '' THEN BEGIN
            "DiscountToTake($)" := DiscountToTake * VendorLedgerEntry."Remaining Amt. (LCY)" / VendorLedgerEntry."Remaining Amount";
            IF PrintAmountsInLocal THEN BEGIN
                IF VendorLedgerEntry."Currency Code" = Vendor."Currency Code" THEN
                    AmountDue := -VendorLedgerEntry."Remaining Amount"
                ELSE BEGIN
                    AmountDue :=
                      ROUND(
                        CurrExchRate.ExchangeAmtFCYToFCY(
                          PaymentDate,
                          VendorLedgerEntry."Currency Code",
                          Vendor."Currency Code",
                          -VendorLedgerEntry."Remaining Amount"),
                        Currency."Amount Rounding Precision");
                    DiscountToTake :=
                      ROUND(
                        CurrExchRate.ExchangeAmtFCYToFCY(
                          PaymentDate,
                          VendorLedgerEntry."Currency Code",
                          Vendor."Currency Code",
                          DiscountToTake),
                        Currency."Amount Rounding Precision");
                END;
            END ELSE BEGIN
                AmountDue := "AmountDue($)";
                DiscountToTake := "DiscountToTake($)";
            END;
        END ELSE BEGIN
            AmountDue := "AmountDue($)";
            "DiscountToTake($)" := DiscountToTake;
        END;

        IF (Vendor.Blocked <> Vendor.Blocked::" ") OR Vendor."Privacy Blocked" THEN BEGIN
            AmountToPay := 0;
            "AmountToPay($)" := 0;
        END ELSE BEGIN
            AmountToPay := AmountDue - DiscountToTake;
            "AmountToPay($)" := "AmountDue($)" - "DiscountToTake($)";
        END;

        VTotAmountDue := VTotAmountDue + AmountDue;
        VTotDiscountToTake := VTotDiscountToTake + DiscountToTake;
        VTotAmountToPay := VTotAmountToPay + AmountToPay;
        GTotAmountDue := GTotAmountDue + "AmountDue($)";
        GTotDiscountToTake := GTotDiscountToTake + "DiscountToTake($)";
        GTotAmountToPay := GTotAmountToPay + "AmountToPay($)";
    end;

    local procedure GetCurrencyRecord(var Currency: Record Currency; CurrencyCode: Code[10])
    begin
        IF CurrencyCode = '' THEN BEGIN
            CLEAR(Currency);
            Currency.Description := GLSetup."LCY Code";
            Currency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
        END ELSE
            IF Currency.Code <> CurrencyCode THEN
                Currency.GET(CurrencyCode);
    end;

    local procedure GetCurrencyCaptionCode(CurrencyCode: Code[10]): Text[80]
    begin
        IF PrintAmountsInLocal THEN BEGIN
            IF CurrencyCode = '' THEN
                EXIT('101,1,' + Text003);

            GetCurrencyRecord(Currency, CurrencyCode);
            EXIT('101,4,' + STRSUBSTNO(Text003, Currency.Description));
        END;
        EXIT('');
    end;
}

