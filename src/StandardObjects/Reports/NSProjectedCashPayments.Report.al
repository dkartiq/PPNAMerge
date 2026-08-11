report 14021218 "NS_Projected Cash Payments"
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
    RDLCLayout = './Layouts/NSProjected Cash Payments.rdl';

    ApplicationArea = Basic, Suite;
    Caption = 'Job Projected Cash Payments';//PE-141.NK.1.0 03Aug2023 updated name
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Vendor Posting Group", "Currency Code", Blocked;
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
            column(SubTitle; SubTitle)
            {
            }
            column(PrintDetail; PrintDetail)
            {
            }
            column(Text003; Text003Lbl)
            {
            }
            column(Text004; Text004Lbl)
            {
            }
            column(PrintAmountsInLocal; PrintAmountsInLocal)
            {
            }
            column(TakeAllDiscounts; TakeAllDiscounts)
            {
            }
            column(UseExternalDocNo; UseExternalDocNo)
            {
            }
            column(Document_Number_is______Vendor_Ledger_Entry__FIELDCAPTION__External_Document_No___; 'Document Number is ' + "Vendor Ledger Entry".FIELDCAPTION("External Document No."))
            {
            }
            column(Vendor_TABLECAPTION__________FilterString; Vendor.TABLECAPTION + ': ' + FilterString)
            {
            }
            column(FilterString; FilterString)
            {
            }
            column(PeriodStartingDate_2_; PeriodStartingDate[2])
            {
            }
            column(PeriodStartingDate_3_; PeriodStartingDate[3])
            {
            }
            column(PeriodStartingDate_4_; PeriodStartingDate[4])
            {
            }
            column(PeriodStartingDate_2__Control19; PeriodStartingDate[2])
            {
            }
            column(PeriodStartingDate_3____1; PeriodStartingDate[3] - 1)
            {
            }
            column(PeriodStartingDate_4____1; PeriodStartingDate[4] - 1)
            {
            }
            column(PeriodStartingDate_5____1; PeriodStartingDate[5] - 1)
            {
            }
            column(PeriodStartingDate_5____1_Control23; PeriodStartingDate[5] - 1)
            {
            }
            column(PeriodStartingDate_2__Control27; PeriodStartingDate[2])
            {
            }
            column(PeriodStartingDate_3__Control28; PeriodStartingDate[3])
            {
            }
            column(PeriodStartingDate_4__Control29; PeriodStartingDate[4])
            {
            }
            column(PeriodStartingDate_2__Control34; PeriodStartingDate[2])
            {
            }
            column(PeriodStartingDate_3____1_Control35; PeriodStartingDate[3] - 1)
            {
            }
            column(PeriodStartingDate_4____1_Control36; PeriodStartingDate[4] - 1)
            {
            }
            column(PeriodStartingDate_5____1_Control37; PeriodStartingDate[5] - 1)
            {
            }
            column(PeriodStartingDate_5____1_Control38; PeriodStartingDate[5] - 1)
            {
            }
            column(Vendor__No__; "No.")
            {
            }
            column(Vendor_Name; Name)
            {
            }
            column(Vendor__Phone_No__; "Phone No.")
            {
            }
            column(Vendor_Contact; Contact)
            {
            }
            column(GrandTotalAmountDue_1_; -GrandTotalAmountDue[1])
            {
            }
            column(GrandTotalAmountDue_2_; -GrandTotalAmountDue[2])
            {
            }
            column(GrandTotalAmountDue_3_; -GrandTotalAmountDue[3])
            {
            }
            column(GrandTotalAmountDue_4_; -GrandTotalAmountDue[4])
            {
            }
            column(GrandTotalAmountDue_5_; -GrandTotalAmountDue[5])
            {
            }
            column(GrandTotalAmountToPrint; -GrandTotalAmountToPrint)
            {
            }
            column(Vendor_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(Vendor_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            column(Projected_Cash_PaymentsCaption; Projected_Cash_PaymentsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Control9Caption; CAPTIONCLASSTRANSLATE('101,1,' + Text005))
            {
            }
            column(Assumes_that_all_available_early_payment_discounts_are_taken_Caption; Assumes_that_all_available_early_payment_discounts_are_taken_CaptionLbl)
            {
            }
            column(Assumes_that_invoices_are_not_paid_early_to_take_payment_discounts_Caption; Assumes_that_invoices_are_not_paid_early_to_take_payment_discounts_CaptionLbl)
            {
            }
            column(Invoices_which_are_on_hold_are_not_included_Caption; Invoices_which_are_on_hold_are_not_included_CaptionLbl)
            {
            }
            column(BeforeCaption; BeforeCaptionLbl)
            {
            }
            column(AfterCaption; AfterCaptionLbl)
            {
            }
            column(Vendor__No__Caption; Vendor__No__CaptionLbl)
            {
            }
            column(Vendor_NameCaption; FIELDCAPTION(Name))
            {
            }
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(DocumentCaption; DocumentCaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry__Pmt__Discount_Date_Caption; Vendor_Ledger_Entry__Pmt__Discount_Date_CaptionLbl)
            {
            }
            column(BeforeCaption_Control32; BeforeCaption_Control32Lbl)
            {
            }
            column(AfterCaption_Control33; AfterCaption_Control33Lbl)
            {
            }
            column(Vendor_Ledger_Entry__Document_Type_Caption; Vendor_Ledger_Entry__Document_Type_CaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry__Due_Date_Caption; "Vendor Ledger Entry".FIELDCAPTION("Due Date"))
            {
            }
            column(BalanceCaption_Control41; BalanceCaption_Control41Lbl)
            {
            }
            column(DocNoCaption; DocNoCaptionLbl)
            {
            }
            column(Phone_Caption; Phone_CaptionLbl)
            {
            }
            column(Contact_Caption; Contact_CaptionLbl)
            {
            }
            column(Control1020000Caption; CAPTIONCLASSTRANSLATE(GetCurrencyCaptionCode("Currency Code")))
            {
            }
            column(Control115Caption; CAPTIONCLASSTRANSLATE('101,0,' + Text006))
            {
            }
            dataitem(VendCurrency; Integer)
            {
                DataItemTableView = SORTING(Number);
                PrintOnlyIfDetail = true;
                column(Transactions_using_____TempCurrency_Code__________TempCurrency_Description; 'Transactions using ' + TempCurrency.Code + ': ' + TempCurrency.Description)
                {
                }
                column(SkipCurrencyTotal; SkipCurrencyTotal)
                {
                }
                column(TempCurrency_Code; TempCurrency.Code)
                {
                }
                column(VendTotalLabel; VendTotalLabel)
                {
                }
                column(VendTotalAmountDue_1_; -VendTotalAmountDue[1])
                {
                }
                column(VendTotalAmountDue_2_; -VendTotalAmountDue[2])
                {
                }
                column(VendTotalAmountDue_3_; -VendTotalAmountDue[3])
                {
                }
                column(VendTotalAmountDue_4_; -VendTotalAmountDue[4])
                {
                }
                column(VendTotalAmountDue_5_; -VendTotalAmountDue[5])
                {
                }
                column(VendTotalAmountToPrint; -VendTotalAmountToPrint)
                {
                }
                column(VendTotalAmountDue_1__Control103; -VendTotalAmountDue[1])
                {
                }
                column(VendTotalAmountDue_2__Control104; -VendTotalAmountDue[2])
                {
                }
                column(VendTotalAmountDue_3__Control105; -VendTotalAmountDue[3])
                {
                }
                column(VendTotalAmountDue_4__Control106; -VendTotalAmountDue[4])
                {
                }
                column(VendTotalAmountDue_5__Control107; -VendTotalAmountDue[5])
                {
                }
                column(VendTotalAmountToPrint_Control108; -VendTotalAmountToPrint)
                {
                }
                column(VendCurrency_Number; Number)
                {
                }
                dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
                {
                    DataItemLink = "Vendor No." = FIELD("No."),
                                   "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                   "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                    DataItemLinkReference = Vendor;
                    DataItemTableView = SORTING("Vendor No.", Open, Positive, "Due Date")
                                        WHERE(Open = CONST(true),
                                              "On Hold" = CONST());
                    column(AmountDue_1_; -AmountDue[1])
                    {
                    }
                    column(AmountDue_2_; -AmountDue[2])
                    {
                    }
                    column(AmountDue_3_; -AmountDue[3])
                    {
                    }
                    column(AmountDue_4_; -AmountDue[4])
                    {
                    }
                    column(AmountDue_5_; -AmountDue[5])
                    {
                    }
                    column(AmountToPrint; -AmountToPrint)
                    {
                    }
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
                    column(AmountDue_1__Control67; -AmountDue[1])
                    {
                    }
                    column(AmountDue_2__Control68; -AmountDue[2])
                    {
                    }
                    column(AmountDue_3__Control69; -AmountDue[3])
                    {
                    }
                    column(AmountDue_4__Control70; -AmountDue[4])
                    {
                    }
                    column(AmountDue_5__Control71; -AmountDue[5])
                    {
                    }
                    column(AmountToPrint_Control72; -AmountToPrint)
                    {
                    }
                    column(AmountDue_1__Control73; -AmountDue[1])
                    {
                    }
                    column(AmountDue_2__Control74; -AmountDue[2])
                    {
                    }
                    column(AmountDue_3__Control75; -AmountDue[3])
                    {
                    }
                    column(AmountDue_4__Control76; -AmountDue[4])
                    {
                    }
                    column(AmountDue_5__Control77; -AmountDue[5])
                    {
                    }
                    column(AmountToPrint_Control78; -AmountToPrint)
                    {
                    }
                    column(Total_for______TempCurrency_Description; 'Total for ' + TempCurrency.Description)
                    {
                    }
                    column(AmountDue_1__Control5; -AmountDue[1])
                    {
                    }
                    column(AmountDue_2__Control6; -AmountDue[2])
                    {
                    }
                    column(AmountDue_3__Control7; -AmountDue[3])
                    {
                    }
                    column(AmountDue_4__Control8; -AmountDue[4])
                    {
                    }
                    column(AmountDue_5__Control88; -AmountDue[5])
                    {
                    }
                    column(AmountToPrint_Control95; -AmountToPrint)
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
                    column(Balance_ForwardCaption; Balance_ForwardCaptionLbl)
                    {
                    }
                    column(Balance_to_Carry_ForwardCaption; Balance_to_Carry_ForwardCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        CALCFIELDS("Remaining Amount", "Remaining Amt. (LCY)");
                        IF TakeAllDiscounts AND
                           ("Original Pmt. Disc. Possible" < 0) AND
                           ("Pmt. Discount Date" >= BeginProjectionDate)
                        THEN BEGIN
                            DateToSelectColumn := "Pmt. Discount Date";
                            "AmountToPrint($)" := "Remaining Amt. (LCY)"
                              - ("Original Pmt. Disc. Possible"
                                 * "Remaining Amt. (LCY)"
                                 / "Remaining Amount");
                            AmountToPrint := "Remaining Amount" - "Original Pmt. Disc. Possible";
                        END ELSE BEGIN
                            DateToSelectColumn := "Due Date";
                            "AmountToPrint($)" := "Remaining Amt. (LCY)";
                            AmountToPrint := "Remaining Amount";
                        END;

                        IF NOT PrintAmountsInLocal OR (Vendor."Currency Code" = '') THEN
                            AmountToPrintVend := "AmountToPrint($)"
                        ELSE
                            IF "Currency Code" = Vendor."Currency Code" THEN
                                AmountToPrintVend := AmountToPrint
                            ELSE
                                AmountToPrintVend :=
                                  ROUND(
                                    CurrExchRate.ExchangeAmtFCYToFCY(
                                      DateToSelectColumn,
                                      "Currency Code",
                                      Vendor."Currency Code",
                                      AmountToPrint),
                                    Currency."Amount Rounding Precision");

                        i := 0;
                        WHILE DateToSelectColumn >= PeriodStartingDate[i + 1] DO
                            i := i + 1;

                        AmountDue[i] := AmountToPrint;
                        VendTotalAmountDue[i] := VendTotalAmountDue[i] + AmountToPrintVend;
                        VendTotalAmountToPrint := VendTotalAmountToPrint + AmountToPrintVend;
                        GrandTotalAmountDue[i] := GrandTotalAmountDue[i] + "AmountToPrint($)";
                        GrandTotalAmountToPrint := GrandTotalAmountToPrint + "AmountToPrint($)";

                        IF UseExternalDocNo THEN
                            DocNo := "External Document No."
                        ELSE
                            DocNo := "Document No.";
                    end;

                    trigger OnPreDataItem()
                    begin
                        //CurrReport.CREATETOTALS(AmountToPrint, AmountDue);
                        IF Currency.READPERMISSION THEN
                            SETRANGE("Currency Code", TempCurrency.Code);
                        //ProjectPro - start
                        IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN
                            SETRANGE("NS_Retention Ledger Code", NS_PurchSetup."NS_Normal Vendor Ledger No.");
                        //ProjectPro - end
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    IF Currency.READPERMISSION THEN BEGIN
                        IF Number = 1 THEN
                            TempCurrency.FIND('-')
                        ELSE
                            TempCurrency.NEXT;
                    END;
                    VendTotalLabel := 'Total for ' + Vendor.TABLECAPTION + ' ' + Vendor."No." + ' (';
                    IF PrintAmountsInLocal AND (Vendor."Currency Code" <> '') THEN
                        VendTotalLabel := VendTotalLabel + Vendor."Currency Code"
                    ELSE
                        VendTotalLabel := VendTotalLabel + GLSetup."LCY Code";
                    VendTotalLabel := VendTotalLabel + ')';
                end;

                trigger OnPreDataItem()
                begin
                    IF Currency.READPERMISSION THEN BEGIN
                        SETRANGE(Number, 1, TempCurrency.COUNT);
                        CASE TempCurrency.COUNT OF
                            0:
                                CurrReport.BREAK;
                            1:
                                BEGIN
                                    TempCurrency.FIND('-');
                                    IF PrintAmountsInLocal THEN
                                        SkipCurrencyTotal := (TempCurrency.Code = Vendor."Currency Code")
                                    ELSE
                                        SkipCurrencyTotal := (TempCurrency.Code = '');
                                END;
                            ELSE
                                SkipCurrencyTotal := FALSE;
                        END;
                    END ELSE BEGIN
                        SETRANGE(Number, 1);
                        SkipCurrencyTotal := TRUE;
                    END;

                    CLEAR(VendTotalAmountDue);
                    VendTotalAmountToPrint := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IF Currency.READPERMISSION THEN BEGIN
                    TempCurrency.DELETEALL;
                    WITH VendLedgEntry2 DO BEGIN
                        SETCURRENTKEY("Vendor No.", Open, Positive, "Due Date", "Currency Code");
                        SETRANGE("Vendor No.", Vendor."No.");
                        SETRANGE(Open, TRUE);
                        SETFILTER("On Hold", '');
                        SETFILTER("Currency Code", '=%1', '');
                        IF FINDFIRST THEN BEGIN
                            TempCurrency.INIT;
                            TempCurrency.Code := '';
                            TempCurrency.Description := GLSetup."LCY Code";
                            TempCurrency.INSERT;
                        END;
                    END;
                    WITH Currency DO
                        IF FIND('-') THEN
                            REPEAT
                                VendLedgEntry2.SETRANGE("Currency Code", Code);
                                IF VendLedgEntry2.FINDFIRST THEN BEGIN
                                    TempCurrency.INIT;
                                    TempCurrency.Code := Code;
                                    TempCurrency.Description := Description;
                                    TempCurrency.INSERT;
                                END;
                            UNTIL NEXT = 0;
                END;

                GetCurrencyRecord(Currency, "Currency Code");
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
                    field(BeginProjectionDate; BeginProjectionDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Begin Projections on';
                        ToolTip = 'Specifies, in the MMDDYY format, when projections begin. The default is today''s date.';
                    }
                    field(PeriodCalculation; PeriodCalculation)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Length of Period';
                        ToolTip = 'Specifies the time increment by which to project the customer balances. For example: 30D = 30 days, 1M = one month, which is different from 30 days.';
                    }
                    field(TakeAllDiscounts; TakeAllDiscounts)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Assume all Payment Discounts are Taken';
                        MultiLine = true;
                        ToolTip = 'Specifies if you want to print amounts and dates that assume that invoices are paid early in order to take advantage of all available payment discounts. Payment discounts that lapse before the Begin Projections on date are not available. If you do not select this field, this report will print amounts and dates that assume that invoices are not to be paid until their due date.';
                    }
                    field(PrintTotalsInVendorsCurrency; PrintAmountsInLocal)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Print Totals in Vendor''s Currency';
                        MultiLine = true;
                        ToolTip = 'Specifies if totals are printed in the customer''s currency. Clear the check box to print all totals in US dollars.';
                    }
                    field(PrintDetail; PrintDetail)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Detail';
                        ToolTip = 'Specifies if individual transactions are included in the report. Clear the check box to include only totals.';
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

        trigger OnOpenPage()
        begin
            IF BeginProjectionDate = 0D THEN
                BeginProjectionDate := WORKDATE;
            IF FORMAT(PeriodCalculation) = '' THEN
                EVALUATE(PeriodCalculation, '<1M>');
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        IF PrintAmountsInLocal AND NOT Currency.READPERMISSION THEN
            ERROR(Text001);
        IF BeginProjectionDate = 0D THEN
            BeginProjectionDate := WORKDATE;
        IF FORMAT(PeriodCalculation) = '' THEN
            EVALUATE(PeriodCalculation, '<1M>');
        PeriodStartingDate[1] := 0D;
        PeriodStartingDate[2] := BeginProjectionDate;
        FOR i := 3 TO 5 DO
            PeriodStartingDate[i] := CALCDATE(PeriodCalculation, PeriodStartingDate[i - 1]);
        PeriodStartingDate[6] := 99991231D;
        CompanyInformation.GET;
        GLSetup.GET;
        //ProjectPro - start
        NS_PurchSetup.GET;
        //ProjectPro - end
        FilterString := Vendor.GETFILTERS;
    end;

    var
        CompanyInformation: Record "Company Information";
        Currency: Record Currency;
        TempCurrency: Record Currency temporary;
        CurrExchRate: Record "Currency Exchange Rate";
        VendLedgEntry2: Record "Vendor Ledger Entry";
        GLSetup: Record "General Ledger Setup";
        FilterString: Text;
        SubTitle: Text[88];
        VendTotalLabel: Text[50];
        PeriodCalculation: DateFormula;
        PeriodStartingDate: array[6] of Date;
        BeginProjectionDate: Date;
        DateToSelectColumn: Date;
        TakeAllDiscounts: Boolean;
        PrintAmountsInLocal: Boolean;
        PrintDetail: Boolean;
        SkipCurrencyTotal: Boolean;
        i: Integer;
        AmountToPrint: Decimal;
        AmountToPrintVend: Decimal;
        "AmountToPrint($)": Decimal;
        VendTotalAmountToPrint: Decimal;
        GrandTotalAmountToPrint: Decimal;
        AmountDue: array[5] of Decimal;
        VendTotalAmountDue: array[5] of Decimal;
        GrandTotalAmountDue: array[5] of Decimal;
        UseExternalDocNo: Boolean;
        DocNo: Code[50];
        Text001: Label 'You cannot choose to print vendor totals in vendor currency unless you can use Multiple Currencies';
        Text002: Label 'Currency: %1';
        Text005: Label 'Vendor totals are in the vendor''s currency (report totals are in %1).';
        Text006: Label 'Report Totals (%1)';
        Text003Lbl: Label '(Detail)';
        Text004Lbl: Label '(Summary)';
        Projected_Cash_PaymentsCaptionLbl: Label 'Projected Cash Payments';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Assumes_that_all_available_early_payment_discounts_are_taken_CaptionLbl: Label 'Assumes that all available early payment discounts are taken.';
        Assumes_that_invoices_are_not_paid_early_to_take_payment_discounts_CaptionLbl: Label 'Assumes that invoices are not paid early to take payment discounts.';
        Invoices_which_are_on_hold_are_not_included_CaptionLbl: Label 'Invoices which are on hold are not included.';
        BeforeCaptionLbl: Label 'Before';
        AfterCaptionLbl: Label 'After';
        Vendor__No__CaptionLbl: Label 'Vendor';
        BalanceCaptionLbl: Label 'Balance';
        DocumentCaptionLbl: Label 'Document';
        Vendor_Ledger_Entry__Pmt__Discount_Date_CaptionLbl: Label 'Discount Date';
        BeforeCaption_Control32Lbl: Label 'Before';
        AfterCaption_Control33Lbl: Label 'After';
        Vendor_Ledger_Entry__Document_Type_CaptionLbl: Label 'Type';
        BalanceCaption_Control41Lbl: Label 'Balance';
        DocNoCaptionLbl: Label 'Number';
        Phone_CaptionLbl: Label 'Phone:';
        Contact_CaptionLbl: Label 'Contact:';
        Balance_ForwardCaptionLbl: Label 'Balance Forward';
        Balance_to_Carry_ForwardCaptionLbl: Label 'Balance to Carry Forward';
        NS_PurchSetup: Record "Purchases & Payables Setup";

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
                EXIT('101,1,' + Text002);

            GetCurrencyRecord(Currency, CurrencyCode);
            EXIT('101,4,' + STRSUBSTNO(Text002, Currency.Description));
        END;
        EXIT('');
    end;
}

