report 14021200 "NS_Change Payment Tolerance"
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
    // +     NS_SalesSetup
    // +     NS_PurchSetup
    // +
    // +  - Modification(s):
    // +     - ChangeCustLedgEntries: get Sales & Receivables Setup record, add filter on Retention Ledger Code if needed
    // +     - ChangeVendLedgEntries: get Purchases & Payables Setup record, add filter on Retention Ledger Code if needed
    // +------------------------------------------------------------

    Caption = 'Job Change Payment Tolerance';//PE-141.NK.1.0 03Aug2023 updated name
    Permissions = TableData 4 = rm,
                  TableData 21 = rm,
                  TableData 25 = rm,
                  TableData 98 = rm;
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Jobs;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(NS_Options)
                {
                    Caption = 'Options';
                    field(NS_AllCurrencies; AllCurrencies)
                    {
                        ApplicationArea = Suite;
                        Caption = 'All Currencies';
                        ToolTip = 'Specifies if you want to change the tolerance setup for both local and all foreign currencies.';

                        trigger OnValidate()
                        begin
                            IF AllCurrencies THEN BEGIN
                                CurrencyCode := '';
                                PaymentTolerancePct := 0;
                                MaxPmtToleranceAmount := 0;
                                CurrencyCodeEnable := FALSE;
                            END ELSE BEGIN
                                CurrencyCodeEnable := TRUE;
                                CurrencyCode := '';
                                PaymentTolerancePct := GLSetup."Payment Tolerance %";
                                MaxPmtToleranceAmount := GLSetup."Max. Payment Tolerance Amount";
                                DecimalPlaces := CheckApplnRounding(GLSetup."Amount Decimal Places");
                            END;
                        end;
                    }
                    field("NS_Currency Code"; CurrencyCode)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Currency Code';
                        Enabled = CurrencyCodeEnable;
                        TableRelation = Currency;
                        ToolTip = 'Specifies the code for the currency that amounts are shown in.';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            Currencies.LOOKUPMODE := TRUE;
                            IF Currencies.RUNMODAL = ACTION::LookupOK THEN
                                Currencies.GetCurrency(CurrencyCode);
                            CLEAR(Currencies);
                            IF CurrencyCode = '' THEN BEGIN
                                GLSetup.GET;
                                PaymentTolerancePct := GLSetup."Payment Tolerance %";
                                MaxPmtToleranceAmount := GLSetup."Max. Payment Tolerance Amount";
                            END ELSE BEGIN
                                Currency.GET(CurrencyCode);
                                PaymentTolerancePct := Currency."Payment Tolerance %";
                                MaxPmtToleranceAmount := Currency."Max. Payment Tolerance Amount";
                            END;
                        end;

                        trigger OnValidate()
                        begin
                            IF NOT AllCurrencies THEN
                                IF CurrencyCode = '' THEN BEGIN
                                    GLSetup.GET;
                                    PaymentTolerancePct := GLSetup."Payment Tolerance %";
                                    MaxPmtToleranceAmount := GLSetup."Max. Payment Tolerance Amount";
                                    DecimalPlaces := CheckApplnRounding(GLSetup."Amount Decimal Places");
                                END ELSE BEGIN
                                    Currency.GET(CurrencyCode);
                                    PaymentTolerancePct := Currency."Payment Tolerance %";
                                    MaxPmtToleranceAmount := Currency."Max. Payment Tolerance Amount";
                                    DecimalPlaces := CheckApplnRounding(Currency."Amount Decimal Places");
                                END;
                        end;
                    }
                    field(NS_PaymentTolerancePct; PaymentTolerancePct)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Payment Tolerance %';
                        DecimalPlaces = 0 : 5;
                        Enabled = true;
                        ToolTip = 'Specifies the percentage by which the payment or refund is allowed to be less than the amount on the invoice or credit memo.';
                    }
                    field("NS_Max. Pmt. Tolerance Amount"; MaxPmtToleranceAmount)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Max. Pmt. Tolerance Amount';
                        DecimalPlaces = 0 : 5;
                        Enabled = true;
                        ToolTip = 'Specifies the maximum allowed amount by which the payment or refund can differ from the amount on the invoice or credit memo.';

                        trigger OnValidate()
                        begin
                            IF AllCurrencies THEN BEGIN
                                DecimalPlaces := 5;
                                FormatString := Text002Lbl + '0:5' + Text003Lbl;
                            END ELSE
                                IF Currency.Code <> '' THEN BEGIN
                                    Currency.GET(Currency.Code);
                                    DecimalPlaces := CheckApplnRounding(Currency."Amount Decimal Places");
                                    FormatString := Text002Lbl + Currency."Amount Decimal Places" + Text003Lbl;
                                END ELSE BEGIN
                                    GLSetup.GET;
                                    DecimalPlaces := CheckApplnRounding(GLSetup."Amount Decimal Places");
                                    FormatString := Text002Lbl + GLSetup."Amount Decimal Places" + Text003Lbl;
                                END;
                            TextFormat := FORMAT(MaxPmtToleranceAmount, 0, FormatString);
                            TextInput := FORMAT(MaxPmtToleranceAmount);
                            IF STRLEN(TextFormat) < STRLEN(TextInput) THEN
                                ERROR(Text004Lbl, DecimalPlaces);
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            CurrencyCodeEnable := TRUE;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        IF AllCurrencies THEN BEGIN
            IF Currency.FIND('-') THEN
                REPEAT
                    IF Currency."Payment Tolerance %" <> PaymentTolerancePct THEN
                        Currency."Payment Tolerance %" := PaymentTolerancePct;
                    IF Currency."Max. Payment Tolerance Amount" <> MaxPmtToleranceAmount THEN
                        Currency."Max. Payment Tolerance Amount" := MaxPmtToleranceAmount;
                    Currency."Max. Payment Tolerance Amount" := ROUND(
                        Currency."Max. Payment Tolerance Amount", Currency."Amount Rounding Precision");
                    Currency.MODIFY;
                UNTIL Currency.NEXT = 0;
            GLSetup.GET;
            IF GLSetup."Payment Tolerance %" <> PaymentTolerancePct THEN
                GLSetup."Payment Tolerance %" := PaymentTolerancePct;
            IF GLSetup."Max. Payment Tolerance Amount" <> MaxPmtToleranceAmount THEN
                GLSetup."Max. Payment Tolerance Amount" := MaxPmtToleranceAmount;
            GLSetup."Max. Payment Tolerance Amount" := ROUND(
                GLSetup."Max. Payment Tolerance Amount", GLSetup."Amount Rounding Precision");
            GLSetup.MODIFY;
        END ELSE
            IF CurrencyCode = '' THEN BEGIN
                GLSetup.GET;
                AmountRoundingPrecision := GLSetup."Amount Rounding Precision";
                IF GLSetup."Payment Tolerance %" <> PaymentTolerancePct THEN
                    GLSetup."Payment Tolerance %" := PaymentTolerancePct;
                IF GLSetup."Max. Payment Tolerance Amount" <> MaxPmtToleranceAmount THEN
                    GLSetup."Max. Payment Tolerance Amount" := MaxPmtToleranceAmount;
                GLSetup."Max. Payment Tolerance Amount" := ROUND(
                    GLSetup."Max. Payment Tolerance Amount", GLSetup."Amount Rounding Precision");
                GLSetup.MODIFY;
            END ELSE
                IF CurrencyCode <> '' THEN BEGIN
                    Currency.GET(CurrencyCode);
                    AmountRoundingPrecision := Currency."Amount Rounding Precision";
                    IF Currency."Payment Tolerance %" <> PaymentTolerancePct THEN
                        Currency."Payment Tolerance %" := PaymentTolerancePct;
                    IF Currency."Max. Payment Tolerance Amount" <> MaxPmtToleranceAmount THEN
                        Currency."Max. Payment Tolerance Amount" := MaxPmtToleranceAmount;
                    Currency."Max. Payment Tolerance Amount" := ROUND(
                        Currency."Max. Payment Tolerance Amount", Currency."Amount Rounding Precision");
                    Currency.MODIFY;
                END;

        IF AllCurrencies THEN BEGIN
            IF CONFIRM(Text001Lbl, TRUE) THEN BEGIN
                IF Currency.FIND('-') THEN
                    REPEAT
                        AmountRoundingPrecision := Currency."Amount Rounding Precision";
                        CurrencyCode := Currency.Code;
                        ChangeCustLedgEntries;
                        ChangeVendLedgEntries;
                    UNTIL Currency.NEXT = 0;
                CurrencyCode := '';
                GLSetup.GET;
                AmountRoundingPrecision := GLSetup."Amount Rounding Precision";
                ChangeCustLedgEntries;
                ChangeVendLedgEntries;
            END;
        END ELSE
            IF CONFIRM(Text001Lbl, TRUE) THEN BEGIN
                ChangeCustLedgEntries;
                ChangeVendLedgEntries;
            END;
    end;

    var
        Currency: Record Currency;
        GLSetup: Record "General Ledger Setup";
        Currencies: Page Currencies;
        CurrencyCode: Code[10];
        PaymentTolerancePct: Decimal;
        MaxPmtToleranceAmount: Decimal;
        Text001Lbl: Label 'Do you want to change all open entries for every customer and vendor that are not blocked?';
        AmountRoundingPrecision: Decimal;
        DecimalPlaces: Integer;
        AllCurrencies: Boolean;
        FormatString: Text[80];
        TextFormat: Text[250];
        TextInput: Text[250];
        Text002Lbl: Label '<Precision,';
        Text003Lbl: Label '><Standard Format,0>';
        Text004Lbl: Label 'The field can have a maximum of %1 decimal places.';
        [InDataSet]
        CurrencyCodeEnable: Boolean;
        NS_SalesSetup: Record "Sales & Receivables Setup";
        NS_PurchSetup: Record "Purchases & Payables Setup";

    local procedure CheckApplnRounding(AmountDecimalPlaces: Text[5]): Integer
    var
        ColonPlace: Integer;
        ReturnNumber: Integer;
        OK: Boolean;
        TempAmountDecimalPlaces: Text[5];
    begin
        ColonPlace := STRPOS(AmountDecimalPlaces, ':');

        IF ColonPlace = 0 THEN BEGIN
            OK := EVALUATE(ReturnNumber, AmountDecimalPlaces);
            IF OK THEN
                EXIT(ReturnNumber);
        END ELSE BEGIN
            TempAmountDecimalPlaces := COPYSTR(AmountDecimalPlaces, ColonPlace + 1, ColonPlace + 1);
            OK := EVALUATE(ReturnNumber, TempAmountDecimalPlaces);
            IF OK THEN
                EXIT(ReturnNumber);
        END;
    end;

    local procedure ChangeCustLedgEntries()
    var
        Customer: Record Customer;
        CustLedgEntry: Record "Cust. Ledger Entry";
        NewPaymentTolerancePct: Decimal;
        NewMaxPmtToleranceAmount: Decimal;
    begin
        //ProjectPro - start
        NS_SalesSetup.GET;
        //ProjectPro - end
        Customer.SETCURRENTKEY("No.");
        Customer.LOCKTABLE;
        IF NOT Customer.FIND('-') THEN
            EXIT;

        REPEAT
            IF NOT Customer."Block Payment Tolerance" THEN BEGIN
                CustLedgEntry.SETCURRENTKEY("Customer No.", Open);
                CustLedgEntry.SETRANGE("Customer No.", Customer."No.");
                CustLedgEntry.SETRANGE(Open, TRUE);
                //ProjectPro - start
                IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
                    CustLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_SalesSetup."NS_Normal Customer Ledger No.");
                //ProjectPro - end
                CustLedgEntry.SETFILTER("Document Type", '%1|%2',
                  CustLedgEntry."Document Type"::Invoice,
                  CustLedgEntry."Document Type"::"Credit Memo");

                CustLedgEntry.SETRANGE("Currency Code", CurrencyCode);
                NewPaymentTolerancePct := PaymentTolerancePct;
                NewMaxPmtToleranceAmount := MaxPmtToleranceAmount;

                CustLedgEntry.LOCKTABLE;
                IF CustLedgEntry.FIND('-') THEN BEGIN
                    REPEAT
                        CustLedgEntry.CALCFIELDS("Remaining Amount");
                        CustLedgEntry."Max. Payment Tolerance" :=
                          ROUND(NewPaymentTolerancePct * CustLedgEntry."Remaining Amount" / 100, AmountRoundingPrecision);
                        IF (CustLedgEntry."Max. Payment Tolerance" = 0) AND
                           (NewMaxPmtToleranceAmount <> 0) OR
                           ((ABS(CustLedgEntry."Max. Payment Tolerance") > NewMaxPmtToleranceAmount) AND
                            (CustLedgEntry."Max. Payment Tolerance" <> 0) AND
                            (NewMaxPmtToleranceAmount <> 0))
                        THEN BEGIN
                            IF CustLedgEntry."Document Type" = CustLedgEntry."Document Type"::Invoice THEN
                                CustLedgEntry."Max. Payment Tolerance" :=
                                  ROUND(NewMaxPmtToleranceAmount, AmountRoundingPrecision)
                            ELSE
                                CustLedgEntry."Max. Payment Tolerance" :=
                                  ROUND(-NewMaxPmtToleranceAmount, AmountRoundingPrecision);
                        END;
                        IF ABS(CustLedgEntry."Remaining Amount") < ABS(CustLedgEntry."Max. Payment Tolerance") THEN
                            CustLedgEntry."Max. Payment Tolerance" := CustLedgEntry."Remaining Amount";
                        CustLedgEntry.MODIFY;
                    UNTIL CustLedgEntry.NEXT = 0;
                END;
            END;
        UNTIL Customer.NEXT = 0;
    end;

    local procedure ChangeVendLedgEntries()
    var
        Vendor: Record Vendor;
        VendLedgEntry: Record "Vendor Ledger Entry";
        NewPaymentTolerancePct: Decimal;
        NewMaxPmtToleranceAmount: Decimal;
    begin
        //ProjectPro - start
        NS_PurchSetup.GET;
        //ProjectPro - end
        Vendor.SETCURRENTKEY("No.");
        Vendor.LOCKTABLE;
        IF NOT Vendor.FIND('-') THEN
            EXIT;
        REPEAT
            IF NOT Vendor."Block Payment Tolerance" THEN BEGIN
                VendLedgEntry.SETCURRENTKEY("Vendor No.", Open);
                VendLedgEntry.SETRANGE("Vendor No.", Vendor."No.");
                //ProjectPro - start
                IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN
                    VendLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_PurchSetup."NS_Normal Vendor Ledger No.");
                //ProjectPro - end

                VendLedgEntry.SETRANGE(Open, TRUE);

                VendLedgEntry.SETFILTER("Document Type", '%1|%2',
                  VendLedgEntry."Document Type"::Invoice,
                  VendLedgEntry."Document Type"::"Credit Memo");

                VendLedgEntry.SETRANGE("Currency Code", CurrencyCode);
                NewPaymentTolerancePct := PaymentTolerancePct;
                NewMaxPmtToleranceAmount := MaxPmtToleranceAmount;

                VendLedgEntry.LOCKTABLE;
                IF VendLedgEntry.FIND('-') THEN BEGIN
                    REPEAT
                        VendLedgEntry.CALCFIELDS("Remaining Amount");
                        VendLedgEntry."Max. Payment Tolerance" :=
                          ROUND(NewPaymentTolerancePct * VendLedgEntry."Remaining Amount" / 100, AmountRoundingPrecision);
                        IF (VendLedgEntry."Max. Payment Tolerance" = 0) AND
                           (NewMaxPmtToleranceAmount <> 0) OR
                           ((ABS(VendLedgEntry."Max. Payment Tolerance") > NewMaxPmtToleranceAmount) AND
                            (VendLedgEntry."Max. Payment Tolerance" <> 0) AND
                            (NewMaxPmtToleranceAmount <> 0))
                        THEN BEGIN
                            IF VendLedgEntry."Document Type" = VendLedgEntry."Document Type"::Invoice THEN
                                VendLedgEntry."Max. Payment Tolerance" :=
                                  ROUND(-NewMaxPmtToleranceAmount, AmountRoundingPrecision)
                            ELSE
                                VendLedgEntry."Max. Payment Tolerance" :=
                                  ROUND(NewMaxPmtToleranceAmount, AmountRoundingPrecision);
                        END;
                        IF ABS(VendLedgEntry."Remaining Amount") < ABS(VendLedgEntry."Max. Payment Tolerance") THEN
                            VendLedgEntry."Max. Payment Tolerance" := VendLedgEntry."Remaining Amount";
                        VendLedgEntry.MODIFY;
                    UNTIL VendLedgEntry.NEXT = 0;
                END;
            END;
        UNTIL Vendor.NEXT = 0;
    end;

    [Scope('Cloud')]
    procedure SetCurrency(NewCurrency: Record Currency)
    begin
        PageSetCurrency(NewCurrency);
        EXIT;
    end;

    local procedure PageSetCurrency(NewCurrency: Record Currency)
    begin
        Currency := NewCurrency;

        IF Currency.Code <> '' THEN BEGIN
            Currency.GET(Currency.Code);
            CurrencyCode := Currency.Code;
            PaymentTolerancePct := Currency."Payment Tolerance %";
            MaxPmtToleranceAmount := Currency."Max. Payment Tolerance Amount";
            DecimalPlaces := CheckApplnRounding(Currency."Amount Decimal Places");
        END ELSE BEGIN
            GLSetup.GET;
            PaymentTolerancePct := GLSetup."Payment Tolerance %";
            MaxPmtToleranceAmount := GLSetup."Max. Payment Tolerance Amount";
            DecimalPlaces := CheckApplnRounding(GLSetup."Amount Decimal Places");
        END;
    end;

    [Scope('Cloud')]
    procedure InitializeRequest(AllCurrenciesFrom: Boolean; CurrencyCodeFrom: Code[10]; PaymentTolerancePctFrom: Decimal; MaxPmtToleranceAmountFrom: Decimal)
    begin
        AllCurrencies := AllCurrenciesFrom;
        CurrencyCode := CurrencyCodeFrom;
        PaymentTolerancePct := PaymentTolerancePctFrom;
        MaxPmtToleranceAmount := MaxPmtToleranceAmountFrom;
    end;
}

