tableextension 14021149 NS_ReminderLine extends "Reminder Line"
{
    // version NAVW111.00,PPNA11.00


    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

    var
        // PP_SalesSetup: Record "Sales & Receivables Setup";
        // PP_PurchSetup: Record "Purchases & Payables Setup";
        ReminderHeader: Record "Reminder Header";
        ReminderTerms: Record "Reminder Terms";
        Currency: Record Currency;
        CustLedgEntry: Record "Cust. Ledger Entry";
        FinChrgTerms: Record "Finance Charge Terms";
        NrOfLinesToInsert: Integer;
        InvalidInterestRateDateErr: Label 'Create interest rate with start date prior to %1.', Comment = '%1=Start Date';
        CalcInterest: Boolean;
        InterestCalcDate: Date;
        NotEnoughSpaceToInsertErr: Label 'There is not enough space to insert lines with additional interest rates.';

    procedure T296GetReminderHeader()
    begin
        IF "Reminder No." <> ReminderHeader."No." THEN BEGIN
            ReminderHeader.GET("Reminder No.");
            T296ProcessReminderHeader;
        END;
    end;

    Local procedure T296ProcessReminderHeader()
    begin
        ReminderHeader.TESTFIELD("Customer No.");
        ReminderHeader.TESTFIELD("Document Date");
        ReminderHeader.TESTFIELD("Customer Posting Group");
        ReminderHeader.TESTFIELD("Reminder Terms Code");
        ReminderTerms.GET(ReminderHeader."Reminder Terms Code");
        IF ReminderHeader."Currency Code" = '' THEN
            Currency.InitRoundingPrecision
        ELSE BEGIN
            Currency.GET(ReminderHeader."Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
        END;
    end;

    procedure T296CalcFinanceChargeInterestRate(VAR FinanceChargeInterestRate: Record "Finance Charge Interest Rate"; VAR UseDueDate: Date; VAR UseInterestRate: Decimal; VAR UseCalcDate: Date)
    var
        LastRateFound: Boolean;
    begin
        UseDueDate := CustLedgEntry."Due Date";
        UseInterestRate := FinChrgTerms."Interest Rate";
        UseCalcDate := 0D;
        NrOfLinesToInsert := 0;

        FinanceChargeInterestRate.INIT;
        FinanceChargeInterestRate.SETRANGE("Fin. Charge Terms Code", ReminderHeader."Fin. Charge Terms Code");
        FinanceChargeInterestRate."Fin. Charge Terms Code" := ReminderHeader."Fin. Charge Terms Code";
        IF FinChrgTerms."Interest Calculation Method" = FinChrgTerms."Interest Calculation Method"::"Average Daily Balance" THEN
            FinanceChargeInterestRate."Start Date" := CALCDATE('<+1D>', CustLedgEntry."Due Date")
        ELSE
            FinanceChargeInterestRate."Start Date" := ReminderHeader."Document Date";
        NrOfLinesToInsert := 0;
        LastRateFound := FALSE;
        IF FinanceChargeInterestRate.FIND('=<') THEN BEGIN
            UseInterestRate := FinanceChargeInterestRate."Interest Rate";
            IF FinChrgTerms."Interest Calculation Method" = FinChrgTerms."Interest Calculation Method"::"Average Daily Balance" THEN
                REPEAT
                    IF FinanceChargeInterestRate."Start Date" <= ReminderHeader."Document Date" THEN
                        NrOfLinesToInsert := NrOfLinesToInsert + 1
                    ELSE
                        LastRateFound := TRUE;
                UNTIL LastRateFound OR (FinanceChargeInterestRate.NEXT = 0);
            IF UseCalcDate = 0D THEN BEGIN
                FinanceChargeInterestRate.NEXT(-1);
                UseCalcDate := FinanceChargeInterestRate."Start Date";
            END;
        END ELSE
            IF FinanceChargeInterestRate.COUNT > 0 THEN
                ERROR(InvalidInterestRateDateErr, FinanceChargeInterestRate."Start Date");

        IF (UseCalcDate = 0D) OR (UseCalcDate < ReminderHeader."Document Date") THEN
            UseCalcDate := ReminderHeader."Document Date";
        "Interest Rate" := UseInterestRate;

    end;

    procedure T296CumulateDetailedEntries(VAR CumAmount: Decimal; UseDueDate: Date; UseCalcDate: Date; UseInterestRate: Decimal; UseInterestPeriod: Decimal)
    var
        IssuedReminderHeader: Record "Issued Reminder Header";
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        InterestStartDate: Date;
        LineFee: Decimal;
    begin
        CalcInterest := TRUE;
        DetailedCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.", "Entry Type", "Posting Date");
        DetailedCustLedgEntry.SETRANGE("Cust. Ledger Entry No.", CustLedgEntry."Entry No.");
        DetailedCustLedgEntry.SETFILTER("Entry Type", '%1|%2|%3|%4|%5',
          DetailedCustLedgEntry."Entry Type"::"Initial Entry",
          DetailedCustLedgEntry."Entry Type"::Application,
          DetailedCustLedgEntry."Entry Type"::"Payment Tolerance",
          DetailedCustLedgEntry."Entry Type"::"Payment Discount Tolerance (VAT Excl.)",
          DetailedCustLedgEntry."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)");
        DetailedCustLedgEntry.SETRANGE("Posting Date", 0D, ReminderHeader."Document Date");
        CumAmount := 0;
        IF DetailedCustLedgEntry.FIND('-') THEN
            REPEAT
                IF DetailedCustLedgEntry."Entry Type" = DetailedCustLedgEntry."Entry Type"::"Initial Entry" THEN
                    InterestStartDate := UseDueDate
                ELSE
                    IF UseDueDate < DetailedCustLedgEntry."Posting Date" THEN
                        InterestStartDate := DetailedCustLedgEntry."Posting Date";
                IF InterestCalcDate > InterestStartDate THEN
                    InterestStartDate := InterestCalcDate;
                IF InterestStartDate < UseCalcDate THEN
                    CumAmount := CumAmount + (DetailedCustLedgEntry.Amount * (UseCalcDate - InterestStartDate));
            UNTIL DetailedCustLedgEntry.NEXT = 0;
        IF NOT FinChrgTerms."Add. Line Fee in Interest" THEN
            IF CustLedgEntry."Document Type" = CustLedgEntry."Document Type"::Reminder THEN
                IF IssuedReminderHeader.GET(CustLedgEntry."Document No.") THEN BEGIN
                    IssuedReminderHeader.CALCFIELDS("Add. Fee per Line");
                    LineFee := IssuedReminderHeader."Add. Fee per Line" + IssuedReminderHeader.CalculateLineFeeVATAmount;
                    CumAmount := CumAmount - LineFee * (ReminderHeader."Document Date" - InterestStartDate);
                    IF CumAmount < 0 THEN
                        CumAmount := 0;
                END;
        IF CalcInterest THEN
            CumAmount := ROUND(CumAmount / UseInterestPeriod * UseInterestRate / 100, Currency."Amount Rounding Precision")
        ELSE
            CumAmount := 0;

    end;

    procedure T296CreateMulitplyInterestRateEntries(VAR ExtraReminderLine: Record "Reminder Line"; VAR FinanceChargeInterestRate: Record "Finance Charge Interest Rate"; VAR UseDueDate: Date; VAR UseInterestRate: Decimal; VAR UseCalcDate: Date; VAR CumAmount: Decimal)
    var
        LineSpacing: Integer;
        NextLineNo: Integer;
        UseInterestPeriod: Integer;
        CurrInterestRateStartDate: Date;
    begin
        ExtraReminderLine.RESET;
        ExtraReminderLine.SETRANGE("Reminder No.", "Reminder No.");
        ExtraReminderLine := Rec;
        IF ExtraReminderLine.FIND('>') THEN BEGIN
            LineSpacing := (ExtraReminderLine."Line No." - "Line No.") DIV
              (1 + NrOfLinesToInsert);
            IF LineSpacing = 0 THEN
                ERROR(NotEnoughSpaceToInsertErr);
        END ELSE
            LineSpacing := 10000;
        NextLineNo := "Line No." + LineSpacing;
        FinanceChargeInterestRate.INIT;
        FinanceChargeInterestRate.SETRANGE("Fin. Charge Terms Code", ReminderHeader."Fin. Charge Terms Code");
        FinanceChargeInterestRate."Fin. Charge Terms Code" := ReminderHeader."Fin. Charge Terms Code";
        FinanceChargeInterestRate."Start Date" := CALCDATE('<+1D>', CustLedgEntry."Due Date");
        IF FinanceChargeInterestRate.FIND('=<') THEN
            REPEAT
                FinanceChargeInterestRate.TESTFIELD("Interest Period (Days)");
                UseInterestPeriod := FinanceChargeInterestRate."Interest Period (Days)";
                UseDueDate := CALCDATE('<-1D>', FinanceChargeInterestRate."Start Date");
                CurrInterestRateStartDate := FinanceChargeInterestRate."Start Date";
                UseInterestRate := FinanceChargeInterestRate."Interest Rate";
                IF FinanceChargeInterestRate.NEXT <> 0 THEN BEGIN
                    IF FinanceChargeInterestRate."Start Date" <= ReminderHeader."Document Date" THEN
                        UseCalcDate := CALCDATE('<-1D>', FinanceChargeInterestRate."Start Date")
                    ELSE
                        UseCalcDate := ReminderHeader."Document Date";
                END ELSE
                    UseCalcDate := ReminderHeader."Document Date";
                ExtraReminderLine := Rec;
                ExtraReminderLine."Line No." := NextLineNo;
                ExtraReminderLine."Due Date" := CALCDATE('<+1D>', InterestCalcDate);
                IF CurrInterestRateStartDate > ExtraReminderLine."Due Date" THEN
                    ExtraReminderLine."Due Date" := CurrInterestRateStartDate;
                ExtraReminderLine."Interest Rate" := UseInterestRate;
                CumulateDetailedEntries(ExtraReminderLine.Amount, UseDueDate, UseCalcDate, UseInterestRate, UseInterestPeriod);
                IF ExtraReminderLine.Amount <> 0 THEN BEGIN
                    CumAmount := CumAmount + ExtraReminderLine.Amount;
                    ExtraReminderLine."Detailed Interest Rates Entry" := TRUE;
                    ExtraReminderLine.INSERT;
                    NextLineNo := ExtraReminderLine."Line No." + LineSpacing;
                END;
                NrOfLinesToInsert := NrOfLinesToInsert - 1;
            UNTIL NrOfLinesToInsert = 0;

    end;
}

