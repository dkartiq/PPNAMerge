report 14021209 "NS_Projected Cash Receipts"
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
    // +     - Customer - OnAfterGetRecord: add filter on Retention Ledger Code if needed on CustLedgEntry2
    // +     - Cust. Ledger Entry - OnPreDataItem: add filter on Retention Ledger Code if needed
    // +------------------------------------------------------------
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSProjected Cash Receipts.rdl';

    ApplicationArea = Basic, Suite;
    Caption = 'Job Projected Cash Receipts';//PE-141.NK.1.0 03Aug2023 updated name
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Customer Posting Group", "Currency Code", Blocked;
            column(Projected_Cash_Receipts_; 'Projected Cash Receipts')
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

            column(USERID; USERID)
            {
            }
            column(SubTitle; SubTitle)
            {
            }
            column(PrintAmountsInLocal; PrintAmountsInLocal)
            {
            }
            column(PAGENO_TakeAllDiscounts; (CurrReport.PAGENO = 1) AND (TakeAllDiscounts))
            {
            }
            column(PAGENO_NotTakeAllDiscounts; (CurrReport.PAGENO = 1) AND (NOT TakeAllDiscounts))
            {
            }
            column(PAGENO_FilterString; (CurrReport.PAGENO = 1) AND (FilterString <> ''))
            {
            }
            column(Customer_TABLECAPTION__________FilterString; Customer.TABLECAPTION + ': ' + FilterString)
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
            column(PrintDetail; PrintDetail)
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
            column(Customer__No__; "No.")
            {
            }
            column(Customer_Name; Name)
            {
            }
            column(Customer__Phone_No__; "Phone No.")
            {
            }
            column(Customer_Contact; Contact)
            {
            }
            column(GrandTotalAmountDue_1_; GrandTotalAmountDue[1])
            {
            }
            column(GrandTotalAmountDue_2_; GrandTotalAmountDue[2])
            {
            }
            column(GrandTotalAmountDue_3_; GrandTotalAmountDue[3])
            {
            }
            column(GrandTotalAmountDue_4_; GrandTotalAmountDue[4])
            {
            }
            column(GrandTotalAmountDue_5_; GrandTotalAmountDue[5])
            {
            }
            column(GrandTotalAmountToPrint; GrandTotalAmountToPrint)
            {
            }
            column(Customer_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(Customer_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
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
            column(Customer__No__Caption; Customer__No__CaptionLbl)
            {
            }
            column(Customer_NameCaption; FIELDCAPTION(Name))
            {
            }
            column(AmountToPrintCaption; AmountToPrintCaptionLbl)
            {
            }
            column(DocumentCaption; DocumentCaptionLbl)
            {
            }
            column(Discount_DateCaption; Discount_DateCaptionLbl)
            {
            }
            column(BeforeCaption_Control32; BeforeCaption_Control32Lbl)
            {
            }
            column(AfterCaption_Control33; AfterCaption_Control33Lbl)
            {
            }
            column(TypeCaption; TypeCaptionLbl)
            {
            }
            column(Due_DateCaption; Due_DateCaptionLbl)
            {
            }
            column(AmountToPrint_Control72Caption; AmountToPrint_Control72CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Document_No__Caption; Cust__Ledger_Entry__Document_No__CaptionLbl)
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
            column(Control55Caption; CAPTIONCLASSTRANSLATE('101,0,' + Text006))
            {
            }
            dataitem(CustCurrency; Integer)
            {
                DataItemTableView = SORTING(Number);
                PrintOnlyIfDetail = true;
                column(Transactions_using_____TempCurrency_Code__________TempCurrency_Description; 'Transactions using ' + TempCurrency.Code + ': ' + TempCurrency.Description)
                {
                }
                column(SkipCurrencyTotal; SkipCurrencyTotal)
                {
                }
                column(CustTotalLabel; CustTotalLabel)
                {
                }
                column(CustTotalAmountDue_1_; CustTotalAmountDue[1])
                {
                }
                column(CustTotalAmountDue_2_; CustTotalAmountDue[2])
                {
                }
                column(CustTotalAmountDue_3_; CustTotalAmountDue[3])
                {
                }
                column(CustTotalAmountDue_4_; CustTotalAmountDue[4])
                {
                }
                column(CustTotalAmountDue_5_; CustTotalAmountDue[5])
                {
                }
                column(CustTotalAmountToPrint; CustTotalAmountToPrint)
                {
                }
                column(CustTotal_Label; CustTotalLabel)
                {
                }
                column(CustTotalAmountDue_1__Control83; CustTotalAmountDue[1])
                {
                }
                column(CustTotalAmountDue_2__Control84; CustTotalAmountDue[2])
                {
                }
                column(CustTotalAmountDue_3__Control85; CustTotalAmountDue[3])
                {
                }
                column(CustTotalAmountDue_4__Control86; CustTotalAmountDue[4])
                {
                }
                column(CustTotalAmountDue_5__Control87; CustTotalAmountDue[5])
                {
                }
                column(CustTotalAmountToPrint_Control88; CustTotalAmountToPrint)
                {
                }
                column(CustCurrency_Number; Number)
                {
                }
                dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = FIELD("No."),
                                   "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                   "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                    DataItemLinkReference = Customer;
                    DataItemTableView = SORTING("Customer No.", Open, Positive, "Due Date")
                                        WHERE(Open = CONST(true),
                                              "On Hold" = CONST());
                    column(AmountDue_1_; AmountDue[1])
                    {
                    }
                    column(AmountDue_2_; AmountDue[2])
                    {
                    }
                    column(AmountDue_3_; AmountDue[3])
                    {
                    }
                    column(AmountDue_4_; AmountDue[4])
                    {
                    }
                    column(AmountDue_5_; AmountDue[5])
                    {
                    }
                    column(AmountToPrint; AmountToPrint)
                    {
                    }
                    column(Cust__Ledger_Entry__Document_Type_; "Document Type")
                    {
                    }
                    column(Cust__Ledger_Entry__Document_No__; "Document No.")
                    {
                    }
                    column(Due_Date__; "Due Date")
                    {
                    }
                    column(Pmt__Discount_Date__; "Pmt. Discount Date")
                    {
                    }
                    column(AmountDue_1__Control67; AmountDue[1])
                    {
                    }
                    column(AmountDue_2__Control68; AmountDue[2])
                    {
                    }
                    column(AmountDue_3__Control69; AmountDue[3])
                    {
                    }
                    column(AmountDue_4__Control70; AmountDue[4])
                    {
                    }
                    column(AmountDue_5__Control71; AmountDue[5])
                    {
                    }
                    column(AmountToPrint_Control72; AmountToPrint)
                    {
                    }
                    column(AmountDue_1__Control73; AmountDue[1])
                    {
                    }
                    column(AmountDue_2__Control74; AmountDue[2])
                    {
                    }
                    column(AmountDue_3__Control75; AmountDue[3])
                    {
                    }
                    column(AmountDue_4__Control76; AmountDue[4])
                    {
                    }
                    column(AmountDue_5__Control77; AmountDue[5])
                    {
                    }
                    column(AmountToPrint_Control78; AmountToPrint)
                    {
                    }
                    column(Total_for______TempCurrency_Description; 'Total for ' + TempCurrency.Description)
                    {
                    }
                    column(AmountDue_4__Control89; AmountDue[4])
                    {
                    }
                    column(AmountToPrint_Control90; AmountToPrint)
                    {
                    }
                    column(AmountDue_5__Control91; AmountDue[5])
                    {
                    }
                    column(AmountDue_3__Control92; AmountDue[3])
                    {
                    }
                    column(AmountDue_2__Control93; AmountDue[2])
                    {
                    }
                    column(AmountDue_1__Control94; AmountDue[1])
                    {
                    }
                    column(Cust__Ledger_Entry_Entry_No_; "Entry No.")
                    {
                    }
                    column(Cust__Ledger_Entry_Customer_No_; "Customer No.")
                    {
                    }
                    column(Cust__Ledger_Entry_Global_Dimension_1_Code; "Global Dimension 1 Code")
                    {
                    }
                    column(Cust__Ledger_Entry_Global_Dimension_2_Code; "Global Dimension 2 Code")
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
                           ("Remaining Pmt. Disc. Possible" > 0) AND
                           ("Pmt. Discount Date" >= BeginProjectionDate)
                        THEN BEGIN
                            DateToSelectColumn := "Pmt. Discount Date";
                            "AmountToPrint($)" := "Remaining Amt. (LCY)"
                              - ("Remaining Pmt. Disc. Possible"
                                 * "Remaining Amt. (LCY)"
                                 / "Remaining Amount");
                            AmountToPrint := "Remaining Amount" - "Remaining Pmt. Disc. Possible";
                        END ELSE BEGIN
                            DateToSelectColumn := "Due Date";
                            "AmountToPrint($)" := "Remaining Amt. (LCY)";
                            AmountToPrint := "Remaining Amount";
                        END;

                        IF NOT PrintAmountsInLocal OR (Customer."Currency Code" = '') THEN
                            AmountToPrintCust := "AmountToPrint($)"
                        ELSE
                            IF "Currency Code" = Customer."Currency Code" THEN
                                AmountToPrintCust := AmountToPrint
                            ELSE
                                AmountToPrintCust :=
                                  ROUND(
                                    CurrExchRate.ExchangeAmtFCYToFCY(
                                      DateToSelectColumn,
                                      "Currency Code",
                                      Customer."Currency Code",
                                      AmountToPrint),
                                    Currency."Amount Rounding Precision");

                        i := 0;
                        WHILE DateToSelectColumn >= PeriodStartingDate[i + 1] DO
                            i := i + 1;

                        AmountDue[i] := AmountToPrint;
                        CustTotalAmountDue[i] := CustTotalAmountDue[i] + AmountToPrintCust;
                        CustTotalAmountToPrint := CustTotalAmountToPrint + AmountToPrintCust;
                        GrandTotalAmountDue[i] := GrandTotalAmountDue[i] + "AmountToPrint($)";
                        GrandTotalAmountToPrint := GrandTotalAmountToPrint + "AmountToPrint($)";
                    end;

                    trigger OnPreDataItem()
                    begin
                        //CurrReport.CREATETOTALS(AmountToPrint, AmountDue);
                        IF Currency.READPERMISSION THEN
                            SETRANGE("Currency Code", TempCurrency.Code);
                        //ProjectPro - start
                        IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
                            SETRANGE("NS_Retention Ledger Code", NS_SalesSetup."NS_Normal Customer Ledger No.");
                        //ProjectPro - end
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    CustTotalLabel := 'Total for ' + Customer.TABLECAPTION + ' ' + Customer."No." + ' (';
                    IF PrintAmountsInLocal AND (Customer."Currency Code" <> '') THEN
                        CustTotalLabel := CustTotalLabel + Customer."Currency Code"
                    ELSE
                        CustTotalLabel := CustTotalLabel + GLSetup."LCY Code";
                    CustTotalLabel := CustTotalLabel + ')';
                    IF TempCurrency.COUNT > 0 THEN BEGIN
                        IF Number = 1 THEN
                            TempCurrency.FIND('-')
                        ELSE
                            TempCurrency.NEXT;
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE(Number, 1, TempCurrency.COUNT);
                    CASE TempCurrency.COUNT OF
                        0:
                            BEGIN
                                SETRANGE(Number, 1);
                                SkipCurrencyTotal := TRUE;
                            END;
                        1:
                            BEGIN
                                TempCurrency.FIND('-');
                                IF PrintAmountsInLocal THEN
                                    SkipCurrencyTotal := (TempCurrency.Code = Customer."Currency Code")
                                ELSE
                                    SkipCurrencyTotal := (TempCurrency.Code = '');
                            END;
                        ELSE
                            SkipCurrencyTotal := FALSE;
                    END;

                    CLEAR(CustTotalAmountDue);
                    CustTotalAmountToPrint := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IF Currency.FINDSET THEN BEGIN
                    IF PrintDetail THEN
                        SubTitle := Text002
                    ELSE
                        SubTitle := Text003;
                    TempCurrency.DELETEALL;
                    WITH CustLedgEntry2 DO BEGIN
                        SETCURRENTKEY("Customer No.", Open, Positive, "Due Date", "Currency Code");
                        SETRANGE("Customer No.", Customer."No.");
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
                        REPEAT
                            CustLedgEntry2.SETRANGE("Currency Code", Code);
                            IF CustLedgEntry2.FINDFIRST THEN BEGIN
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
                    field(PrintTotalsInCustomersCurrency; PrintAmountsInLocal)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Print Totals in Customer''s Currency';
                        MultiLine = true;
                        ToolTip = 'Specifies if totals are printed in the customer''s currency. Clear the check box to print all totals in US dollars.';
                    }
                    field(PrintDetail; PrintDetail)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Detail';
                        ToolTip = 'Specifies if individual transactions are included in the report. Clear the check box to include only totals.';
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
        FilterString := Customer.GETFILTERS;
        //ProjectPro - start
        NS_SalesSetup.GET;
        //ProjectPro - end
    end;

    var
        CompanyInformation: Record "Company Information";
        Currency: Record Currency;
        TempCurrency: Record Currency temporary;
        CurrExchRate: Record "Currency Exchange Rate";
        CustLedgEntry2: Record "Cust. Ledger Entry";
        GLSetup: Record "General Ledger Setup";
        FilterString: Text;
        SubTitle: Text[88];
        CustTotalLabel: Text[50];
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
        AmountToPrintCust: Decimal;
        "AmountToPrint($)": Decimal;
        CustTotalAmountToPrint: Decimal;
        GrandTotalAmountToPrint: Decimal;
        AmountDue: array[5] of Decimal;
        CustTotalAmountDue: array[5] of Decimal;
        GrandTotalAmountDue: array[5] of Decimal;
        Text001: Label 'You cannot choose to print customer totals in customer currency unless you can use Multiple Currencies';
        Text002: Label '(Detail)';
        Text003: Label '(Summary)';
        Text004: Label 'Currency: %1';
        Text005: Label 'Customer totals are in the customer''s currency (report totals are in %1)';
        Text006: Label 'Report Totals (%1)';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Assumes_that_all_available_early_payment_discounts_are_taken_CaptionLbl: Label 'Assumes that all available early payment discounts are taken.';
        Assumes_that_invoices_are_not_paid_early_to_take_payment_discounts_CaptionLbl: Label 'Assumes that invoices are not paid early to take payment discounts.';
        Invoices_which_are_on_hold_are_not_included_CaptionLbl: Label 'Invoices which are on hold are not included.';
        BeforeCaptionLbl: Label 'Before';
        AfterCaptionLbl: Label 'After';
        Customer__No__CaptionLbl: Label 'Customer';
        AmountToPrintCaptionLbl: Label 'Balance';
        DocumentCaptionLbl: Label 'Document';
        Discount_DateCaptionLbl: Label 'Discount Date';
        BeforeCaption_Control32Lbl: Label 'Before';
        AfterCaption_Control33Lbl: Label 'After';
        TypeCaptionLbl: Label 'Type';
        Due_DateCaptionLbl: Label 'Due Date';
        AmountToPrint_Control72CaptionLbl: Label 'Balance';
        Cust__Ledger_Entry__Document_No__CaptionLbl: Label 'Number';
        Phone_CaptionLbl: Label 'Phone:';
        Contact_CaptionLbl: Label 'Contact:';
        Balance_ForwardCaptionLbl: Label 'Balance Forward';
        Balance_to_Carry_ForwardCaptionLbl: Label 'Balance to Carry Forward';
        NS_SalesSetup: Record "Sales & Receivables Setup";

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
                EXIT('101,1,' + Text004);

            GetCurrencyRecord(Currency, CurrencyCode);
            EXIT('101,4,' + STRSUBSTNO(Text004, Currency.Description));
        END;
        EXIT('');
    end;
}

