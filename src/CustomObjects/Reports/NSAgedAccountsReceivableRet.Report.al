report 14021187 "NS_Aged Accounts ReceivableRet"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    // SMPL DateFormula propertyussage deprecated use DateFormula type instead
    //PRJ-84.SK.1.0 Added report to search
    //PRJ-215.MS.1.0 rearrange code on aftergetrecord trigger of Totals dataitem as per 2017DB
    //CTSI-158.AS.1.0 21SEPT2020 Increased lengths of Text
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSAged Accounts Receivable Ret.rdl';
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Aged Accounts Receivable';
    ApplicationArea = all;

    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Customer Posting Group", "Payment Terms Code", "Salesperson Code";
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
            column(DateTitle; DateTitle)
            {
            }
            column(Customer_TABLECAPTION__________FilterString; Customer.TABLECAPTION + ': ' + FilterString)
            {
            }
            column(ColumnHeadHead; ColumnHeadHead)
            {
            }
            column(ColumnHead_1_; ColumnHead[1])
            {
            }
            column(ColumnHead_2_; ColumnHead[2])
            {
            }
            column(ColumnHead_3_; ColumnHead[3])
            {
            }
            column(ColumnHead_4_; ColumnHead[4])
            {
            }
            column(PrintDetail; PrintDetail)
            {
            }
            column(PrintToExcel; PrintToExcel)
            {
            }
            column(PrintAmountsInLocal; PrintAmountsInLocal)
            {
            }
            column(ShowAllForOverdue; ShowAllForOverdue)
            {
            }
            column(IncludeRetention; IncludeRetention)
            {
            }
            column(FilterString; FilterString)
            {
            }
            column(ColumnHeadHead_Control21; ColumnHeadHead)
            {
            }
            column(ShortDateTitle; ShortDateTitle)
            {
            }
            column(ColumnHead_1__Control26; ColumnHead[1])
            {
            }
            column(ColumnHead_2__Control27; ColumnHead[2])
            {
            }
            column(ColumnHead_3__Control28; ColumnHead[3])
            {
            }
            column(ColumnHead_4__Control29; ColumnHead[4])
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
            column(BlockedDescription; BlockedDescription)
            {
            }
            column(OverLimitDescription; OverLimitDescription)
            {
            }
            column(TotalBalanceDue__; "TotalBalanceDue$")
            {
            }
            column(BalanceDue___1_; "BalanceDue$"[1])
            {
            }
            column(BalanceDue___2_; "BalanceDue$"[2])
            {
            }
            column(BalanceDue___3_; "BalanceDue$"[3])
            {
            }
            column(BalanceDue___4_; "BalanceDue$"[4])
            {
            }
            column(PercentString_1_; PercentString[1])
            {
            }
            column(PercentString_2_; PercentString[2])
            {
            }
            column(PercentString_3_; PercentString[3])
            {
            }
            column(PercentString_4_; PercentString[4])
            {
            }
            column(TotalBalanceDue___Control30; "TotalBalanceDue$")
            {
            }
            column(BalanceDue___1__Control48; "BalanceDue$"[1])
            {
            }
            column(BalanceDue___2__Control94; "BalanceDue$"[2])
            {
            }
            column(PercentString_1__Control95; PercentString[1])
            {
            }
            column(PercentString_2__Control96; PercentString[2])
            {
            }
            column(BalanceDue___3__Control97; "BalanceDue$"[3])
            {
            }
            column(PercentString_3__Control98; PercentString[3])
            {
            }
            column(BalanceDue___4__Control99; "BalanceDue$"[4])
            {
            }
            column(PercentString_4__Control100; PercentString[4])
            {
            }
            column(Customer_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            column(Customer_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(Aged_Accounts_ReceivableCaption; Aged_Accounts_ReceivableCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Aged_byCaption; Aged_byCaptionLbl)
            {
            }
            column(Control11Caption; CAPTIONCLASSTRANSLATE('101,1,' + Text021))
            {
            }
            column(Customer__No__Caption; FIELDCAPTION("No."))
            {
            }
            column(Customer_NameCaption; FIELDCAPTION(Name))
            {
            }
            column(AmountDueToPrint_Control74Caption; AmountDueToPrint_Control74CaptionLbl)
            {
            }
            column(Credit_LimitCaption; Credit_LimitCaptionLbl)
            {
            }
            column(Customer__No__Caption_Control22; FIELDCAPTION("No."))
            {
            }
            column(NameCaption; NameCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry___Document_No__Caption; Cust__Ledger_Entry___Document_No__CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__DescriptionCaption; Cust__Ledger_Entry__DescriptionCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry___Document_Type_Caption; Cust__Ledger_Entry___Document_Type_CaptionLbl)
            {
            }
            column(AmountDueToPrint_Control63Caption; AmountDueToPrint_Control63CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry___Currency_Code_Caption; Cust__Ledger_Entry___Currency_Code_CaptionLbl)
            {
            }
            column(DocumentCaption; DocumentCaptionLbl)
            {
            }
            column(Customer__Phone_No__Caption; FIELDCAPTION("Phone No."))
            {
            }
            column(Customer_ContactCaption; FIELDCAPTION(Contact))
            {
            }
            column(Control1020000Caption; CAPTIONCLASSTRANSLATE(NS_GetCurrencyCaptionCode("Currency Code")))
            {
            }
            column(Control47Caption; CAPTIONCLASSTRANSLATE('101,0,' + Text022))
            {
            }
            column(Control8Caption; CAPTIONCLASSTRANSLATE('101,0,' + Text022))
            {
            }
            column(JobCaption; NS_JobLbl)
            {
            }
            column(RetentionCaption; NS_RetentionLbl)
            {
            }
            column(CLE_JobNo_Caption; JobNoLbl)
            {
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD("No."), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter");
                DataItemTableView = SORTING("Customer No.", Open, Positive, "Due Date", "Currency Code");

                trigger OnAfterGetRecord();
                begin
                    SETRANGE("Date Filter", 0D, PeriodEndingDate[1]);
                    CALCFIELDS("Remaining Amount");
                    if "Remaining Amount" <> 0 then
                        NS_InsertTemp("Cust. Ledger Entry");
                    CurrReport.SKIP;    // this fools the system into thinking that no details "printed"...yet
                end;

                trigger OnPreDataItem();
                var
                    UseRecord: Boolean;
                begin
                    // Find ledger entries which are posted before the date of the aging
                    UseRecord := true;
                    if not SalesSetup."NS_Sales Retention Inactive" then
                        if not IncludeRetention then
                            if "NS_Retention Ledger Code" = JobsSetup."NS_Retention Receivable Ledger" then
                                UseRecord := false;

                    if UseRecord then begin
                        SETRANGE("Posting Date", 0D, PeriodEndingDate[1]);

                        if (FORMAT(ShowOnlyOverDueBy) <> '') and not ShowAllForOverdue then
                            SETRANGE("Due Date", 0D, CalculatedDate);
                    end;
                end;
            }
            dataitem(Totals; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(AmountDueToPrint; AmountDueToPrint)
                {
                }
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
                column(AgingDate; AgingDate)
                {
                }
                column(Cust__Ledger_Entry__Description; "Cust. Ledger Entry".Description)
                {
                }
                column(Cust_Ledger_Entry_Job_No; "Cust. Ledger Entry"."NS_Job No.")
                {
                }
                column(Cust__Ledger_Entry___Document_Type_; "Cust. Ledger Entry"."Document Type")
                {
                }
                column(Cust__Ledger_Entry___Document_No__; "Cust. Ledger Entry"."Document No.")
                {
                }
                column(RetentionToPrint; NS_RetentionToPrint)
                {
                }
                column(AmountDueToPrint_Control63; AmountDueToPrint)
                {
                }
                column(AmountDue_1__Control64; AmountDue[1])
                {
                }
                column(AmountDue_2__Control65; AmountDue[2])
                {
                }
                column(AmountDue_3__Control66; AmountDue[3])
                {
                }
                column(AmountDue_4__Control67; AmountDue[4])
                {
                }
                column(Cust__Ledger_Entry___Currency_Code_; "Cust. Ledger Entry"."Currency Code")
                {
                }
                column(AmountDueToPrint_Control68; AmountDueToPrint)
                {
                }
                column(AmountDue_1__Control69; AmountDue[1])
                {
                }
                column(AmountDue_2__Control70; AmountDue[2])
                {
                }
                column(AmountDue_3__Control71; AmountDue[3])
                {
                }
                column(AmountDue_4__Control72; AmountDue[4])
                {
                }
                column(AmountDueToPrint_Control74; AmountDueToPrint)
                {
                }
                column(AmountDue_1__Control75; AmountDue[1])
                {
                }
                column(AmountDue_2__Control76; AmountDue[2])
                {
                }
                column(AmountDue_3__Control77; AmountDue[3])
                {
                }
                column(AmountDue_4__Control78; AmountDue[4])
                {
                }
                column(CreditLimitToPrint; CreditLimitToPrint)
                {
                }
                column(PercentString_1__Control4; PercentString[1])
                {
                }
                column(PercentString_2__Control5; PercentString[2])
                {
                }
                column(PercentString_3__Control6; PercentString[3])
                {
                }
                column(PercentString_4__Control7; PercentString[4])
                {
                }
                column(Customer__No___Control80; Customer."No.")
                {
                }
                column(AmountDueToPrint_Control81; AmountDueToPrint)
                {
                }
                column(AmountDue_1__Control82; AmountDue[1])
                {
                }
                column(AmountDue_2__Control83; AmountDue[2])
                {
                }
                column(AmountDue_3__Control84; AmountDue[3])
                {
                }
                column(AmountDue_4__Control85; AmountDue[4])
                {
                }
                column(CreditLimitToPrint_Control88; CreditLimitToPrint)
                {
                }
                column(PercentString_1__Control89; PercentString[1])
                {
                }
                column(PercentString_2__Control90; PercentString[2])
                {
                }
                column(PercentString_3__Control91; PercentString[3])
                {
                }
                column(PercentString_4__Control92; PercentString[4])
                {
                }
                column(Totals_Number; Number)
                {
                }
                column(Balance_ForwardCaption; Balance_ForwardCaptionLbl)
                {
                }
                column(Balance_to_Carry_ForwardCaption; Balance_to_Carry_ForwardCaptionLbl)
                {
                }
                column(Total_Amount_DueCaption; Total_Amount_DueCaptionLbl)
                {
                }
                column(Total_Amount_DueCaption_Control86; Total_Amount_DueCaption_Control86Lbl)
                {
                }
                column(Credit_Limit_Caption; Credit_Limit_CaptionLbl)
                {
                }
                column(Control1020001Caption; CAPTIONCLASSTRANSLATE(NS_GetCurrencyCaptionCode(Customer."Currency Code")))
                {
                }
                column(AgingDateText; NS_AgingDateText)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    NS_CalcPercents(AmountDueToPrint, AmountDue);
                    CLEAR(AmountDue); //PRJ-215.MS.1.0 Added
                    AmountDueToPrint := 0; //PRJ-215.MS.1.0 Added
                    if Number = 1 then
                        // TempCustLedgEntry.FINDFIRST //PRJ-215.MS.1.0 Commented
                        TempCustLedgEntry.FIND('-') //PRJ-215.MS.1.0 Added
                    else
                        TempCustLedgEntry.NEXT;
                    TempCustLedgEntry.SETRANGE("Date Filter", 0D, PeriodEndingDate[1]);
                    TempCustLedgEntry.CALCFIELDS("Remaining Amount", "Remaining Amt. (LCY)");
                    if TempCustLedgEntry."Remaining Amount" = 0 then
                        CurrReport.SKIP;
                    if TempCustLedgEntry."Currency Code" <> '' then
                        TempCustLedgEntry."Remaining Amt. (LCY)" :=
                          ROUND(
                            CurrExchRate.ExchangeAmtFCYToFCY(
                              PeriodEndingDate[1],
                              TempCustLedgEntry."Currency Code",
                              '',
                              TempCustLedgEntry."Remaining Amount"));
                    if PrintAmountsInLocal then begin
                        TempCustLedgEntry."Remaining Amount" :=
                          ROUND(
                            CurrExchRate.ExchangeAmtFCYToFCY(
                              PeriodEndingDate[1],
                              TempCustLedgEntry."Currency Code",
                              Customer."Currency Code",
                              TempCustLedgEntry."Remaining Amount"),
                            Currency."Amount Rounding Precision");
                        AmountDueToPrint := TempCustLedgEntry."Remaining Amount";
                    end else
                        AmountDueToPrint := TempCustLedgEntry."Remaining Amt. (LCY)";

                    //PRJ-215.MS.1.0 Commented Start
                    // if (not SalesSetup."Sales Retention Inactive") and
                    //    (TempCustLedgEntry."Retention Ledger Code" = JobsSetup."Retention Receivable Ledger") and
                    //    (TempCustLedgEntry."Retention Date" > 0D) then
                    //     AgingDate := TempCustLedgEntry."Retention Date"
                    // else
                    //PRJ-215.MS.1.0 Commeneted End
                    case AgingMethod of
                        AgingMethod::"Due Date":
                            AgingDate := TempCustLedgEntry."Due Date";
                        AgingMethod::"Trans Date":
                            AgingDate := TempCustLedgEntry."Posting Date";
                        AgingMethod::"Document Date":
                            AgingDate := TempCustLedgEntry."Document Date";
                    end;
                    // NS_AgingDateText := FORMAT(DATE2DMY(AgingDate, 3)) + FORMAT(DATE2DMY(AgingDate, 2)) + FORMAT(DATE2DMY(AgingDate, 1)); //PRJ-215.MS.1.0 Added
                    j := 0;

                    //PRJ-215.MS.1.0 Commented Start
                    // while AgingDate < PeriodEndingDate[j + 1] do begin
                    //     j := j + 1;
                    //     if j = 5 then
                    //         CurrReport.BREAK;
                    // end;
                    // if j = 0 then
                    //     j := 1;
                    //PRJ-215.MS.1.0 Commented End

                    //PRJ-215.MS.1.0 Start
                    WHILE AgingDate < PeriodEndingDate[j + 1] DO
                        j := j + 1;
                    IF j = 0 THEN
                        j := 1;
                    //PRJ-215.MS.1.0 End

                    NS_RetentionToPrint := 0;
                    NS_RetentionToPrint := 0;
                    if not SalesSetup."NS_Sales Retention Inactive" then
                        if TempCustLedgEntry."NS_Retention Ledger Code" = JobsSetup."NS_Retention Receivable Ledger" then begin
                            NS_RetentionToPrint := AmountDueToPrint;
                            NS_TotalRetention := NS_TotalRetention + NS_RetentionToPrint;
                            if AgingDate > PeriodEndingDate[1] then
                                AmountDueToPrint := 0;
                        end;

                    if TempCustLedgEntry."NS_Retention Ledger Code" = JobsSetup."NS_Retention Receivable Ledger" then begin
                        AmountDueToPrint := 0;
                        "NS_RetentionDue$"[j] := "NS_RetentionDue$"[j] + TempCustLedgEntry."Remaining Amt. (LCY)";
                        TempCustLedgEntry."Remaining Amt. (LCY)" := 0;
                    end;

                    AmountDue[j] := AmountDueToPrint;
                    "BalanceDue$"[j] := "BalanceDue$"[j] + TempCustLedgEntry."Remaining Amt. (LCY)";

                    CustTotAmountDue[j] := CustTotAmountDue[j] + AmountDueToPrint;
                    CustTotAmountDueToPrint := CustTotAmountDueToPrint + AmountDueToPrint;

                    "TotalBalanceDue$" := 0;
                    for j := 1 to 4 do
                        "TotalBalanceDue$" := "TotalBalanceDue$" + "BalanceDue$"[j];
                    NS_CalcPercents("TotalBalanceDue$", "BalanceDue$");

                    "Cust. Ledger Entry" := TempCustLedgEntry;

                    // Do NOT use the following fields in the sections:
                    // "Applied-To Doc. Type"
                    // "Applied-To Doc. No."
                    // Open
                    // "Paym. Disc. Taken"
                    // "Closed by Entry No."
                    // "Closed at Date"
                    // "Closed by Amount"


                    //PRJ-215.MS.1.0 Start
                    // if PrintDetail and PrintToExcel then
                    //     MakeExcelDataBody;
                    //PRJ-215.MS.1.0 End
                end;


                trigger OnPostDataItem();
                begin
                    if TempCustLedgEntry.COUNT > 0 then begin
                        for j := 1 to 4 do
                            AmountDue[j] := CustTotAmountDue[j];
                        AmountDueToPrint := CustTotAmountDueToPrint;
                        if not PrintDetail and PrintToExcel then
                            NS_MakeExcelDataBody;
                    end;
                end;

                trigger OnPreDataItem();
                begin
                    //CurrReport.CREATETOTALS(AmountDueToPrint, AmountDue);
                    CurrReport.CREATETOTALS(NS_RetentionToPrint);
                    SETRANGE(Number, 1, TempCustLedgEntry.COUNT);
                    TempCustLedgEntry.SETCURRENTKEY("Customer No.", "Posting Date");
                    CLEAR("BalanceDue$");
                    CLEAR(CustTotAmountDue);
                    CustTotAmountDueToPrint := 0;
                end;
            }

            trigger OnAfterGetRecord();
            var
                CustLedgEntry: Record "Cust. Ledger Entry";
            begin
                if PrintAmountsInLocal then begin
                    NS_GetCurrencyRecord(Currency, "Currency Code");
                    CurrencyFactor := CurrExchRate.ExchangeRate(PeriodEndingDate[1], "Currency Code");
                end;

                if Blocked <> Blocked::" " then
                    BlockedDescription := STRSUBSTNO(Text002, Blocked)
                else
                    BlockedDescription := '';

                if "Credit Limit (LCY)" = 0 then begin
                    CreditLimitToPrint := Text003;
                    OverLimitDescription := '';
                end else begin
                    SETRANGE("Date Filter", 0D, PeriodEndingDate[1]);
                    CALCFIELDS("Net Change (LCY)");
                    if "Net Change (LCY)" > "Credit Limit (LCY)" then
                        OverLimitDescription := Text004
                    else
                        OverLimitDescription := '';
                    if PrintAmountsInLocal and ("Currency Code" <> '') then
                        "Credit Limit (LCY)" :=
                          CurrExchRate.ExchangeAmtLCYToFCY(PeriodEndingDate[1], "Currency Code", "Credit Limit (LCY)", CurrencyFactor);
                    CreditLimitToPrint := FORMAT(ROUND("Credit Limit (LCY)", 1));
                end;

                TempCustLedgEntry.DELETEALL;
                LedgEntryLast := 0;

                if FORMAT(ShowOnlyOverDueBy) <> '' then
                    CalculatedDate := CALCDATE(ShowOnlyOverDueBy, PeriodEndingDate[1]);

                if ShowAllForOverdue and (FORMAT(ShowOnlyOverDueBy) <> '') then begin
                    CustLedgEntry.SETRANGE("Customer No.", "No.");
                    CustLedgEntry.SETRANGE(Open, true);
                    CustLedgEntry.SETRANGE("Due Date", 0D, CalculatedDate);
                    if not CustLedgEntry.FINDFIRST then
                        CurrReport.SKIP;
                end;
            end;

            trigger OnPreDataItem();
            begin
                CLEAR("BalanceDue$");

                if PrintDetail then
                    SubTitle := Text006
                else
                    SubTitle := Text007;

                SubTitle := SubTitle + Text008 + ' ' + FORMAT(PeriodEndingDate[1], 0, 4) + ')';

                case AgingMethod of
                    AgingMethod::"Due Date":
                        begin
                            DateTitle := Text009;
                            ShortDateTitle := Text010;
                            ColumnHead[2] := Text011 + ' '
                              + FORMAT(PeriodEndingDate[1] - PeriodEndingDate[3])
                              + Text012;
                            ColumnHeadHead := Text013 + ' ';
                        end;
                    AgingMethod::"Trans Date":
                        begin
                            DateTitle := Text014;
                            ShortDateTitle := Text015;
                            ColumnHead[2] := FORMAT(PeriodEndingDate[1] - PeriodEndingDate[2] + 1)
                              + ' - '
                              + FORMAT(PeriodEndingDate[1] - PeriodEndingDate[3])
                              + Text012;
                            ColumnHeadHead := Text016 + ' ';
                        end;
                    AgingMethod::"Document Date":
                        begin
                            DateTitle := Text017;
                            ShortDateTitle := Text018;
                            ColumnHead[2] := FORMAT(PeriodEndingDate[1] - PeriodEndingDate[2] + 1)
                              + ' - '
                              + FORMAT(PeriodEndingDate[1] - PeriodEndingDate[3])
                              + Text012;
                            ColumnHeadHead := Text016 + ' ';
                        end;
                end;

                ColumnHead[1] := Text019;
                ColumnHead[3] := FORMAT(PeriodEndingDate[1] - PeriodEndingDate[3] + 1)
                  + ' - '
                  + FORMAT(PeriodEndingDate[1] - PeriodEndingDate[4])
                  + Text012;
                ColumnHead[4] := Text020 + ' '
                  + FORMAT(PeriodEndingDate[1] - PeriodEndingDate[4])
                  + Text012;

                if PrintToExcel then
                    NS_MakeExcelInfo;
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
                    field("PeriodEndingDate[1]"; PeriodEndingDate[1])
                    {
                        Caption = 'Aged as of';
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            if PeriodEndingDate[1] = 0D then
                                PeriodEndingDate[1] := WORKDATE;
                        end;
                    }
                    field(AgingMethod; AgingMethod)
                    {
                        Caption = 'Aged by';
                        OptionCaption = 'Trans Date,Due Date,Document Date';
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            if AgingMethod in [AgingMethod::"Document Date", AgingMethod::"Trans Date"] then begin
                                EVALUATE(ShowOnlyOverDueBy, '');
                                ShowAllForOverdue := false;
                            end;
                        end;
                    }
                    field(PeriodCalculation; PeriodCalculation)
                    {
                        Caption = 'Length of Aging Periods';
                        ApplicationArea = All;
                        //SMPL - DateFormula = true;

                        trigger OnValidate();
                        begin
                            if FORMAT(PeriodCalculation) = '' then
                                ERROR(Text121);
                        end;
                    }
                    field(ShowOnlyOverDueBy; ShowOnlyOverDueBy)
                    {
                        Caption = 'Show If Overdue By';
                        ApplicationArea = All;
                        //SMPL - DateFormula = true;

                        trigger OnValidate();
                        begin
                            if AgingMethod <> AgingMethod::"Due Date" then
                                ERROR(Text120);
                            if FORMAT(ShowOnlyOverDueBy) = '' then
                                ShowAllForOverdue := false;
                        end;
                    }
                    field(ShowAllForOverdue; ShowAllForOverdue)
                    {
                        Caption = 'Show All for Overdue Customer';
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            if AgingMethod <> AgingMethod::"Due Date" then
                                ERROR(Text120);
                            if ShowAllForOverdue and (FORMAT(ShowOnlyOverDueBy) = '') then
                                ERROR(Text119);
                        end;
                    }
                    field(PrintAmountsInLocal; PrintAmountsInLocal)
                    {
                        Caption = 'Print Amounts in Customer''s Currency';
                        MultiLine = true;
                        ApplicationArea = All;
                    }
                    field(PrintDetailCtl; PrintDetail)
                    {
                        Caption = 'Print Detail';
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            if not PrintDetail then
                                IncludeRetention := false;
                        end;
                    }
                    field(IncludeRetentionCtl; IncludeRetention)
                    {
                        Caption = 'Include Retention';
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            if IncludeRetention then
                                PrintDetail := true;
                        end;
                    }
                    field(PrintToExcel; PrintToExcel)
                    {
                        Caption = 'Print to Excel';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            if PeriodEndingDate[1] = 0D then begin
                PeriodEndingDate[1] := WORKDATE;
                EVALUATE(PeriodCalculation, '<30D>');
            end;
        end;
    }

    labels
    {
    }

    trigger OnPostReport();
    begin
        if PrintToExcel then
            NS_CreateExcelbook;
    end;

    trigger OnPreReport();
    begin
        if FORMAT(PeriodCalculation) <> '' then
            EVALUATE(PeriodCalculation, '-' + FORMAT(PeriodCalculation));
        if FORMAT(ShowOnlyOverDueBy) <> '' then
            EVALUATE(ShowOnlyOverDueBy, '-' + FORMAT(ShowOnlyOverDueBy));
        if AgingMethod = AgingMethod::"Due Date" then begin
            PeriodEndingDate[2] := PeriodEndingDate[1];
            for j := 3 to 4 do
                PeriodEndingDate[j] := CALCDATE(PeriodCalculation, PeriodEndingDate[j - 1]);
        end else
            for j := 2 to 4 do
                PeriodEndingDate[j] := CALCDATE(PeriodCalculation, PeriodEndingDate[j - 1]);

        PeriodEndingDate[5] := 0D;
        CompanyInformation.GET;
        GLSetup.GET;
        JobsSetup.GET;
        SalesSetup.GET;
        FilterString := Customer.GETFILTERS;
    end;

    var
        CompanyInformation: Record "Company Information";
        TempCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        GLSetup: Record "General Ledger Setup";
        JobsSetup: Record "Jobs Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        ExcelBuf: Record "Excel Buffer" temporary;
        PeriodCalculation: DateFormula;
        ShowOnlyOverDueBy: DateFormula;
        AgingMethod: Option "Trans Date","Due Date","Document Date";
        PrintAmountsInLocal: Boolean;
        PrintDetail: Boolean;
        PrintToExcel: Boolean;
        IncludeRetention: Boolean;
        AmountDue: array[4] of Decimal;
        "BalanceDue$": array[4] of Decimal;
        ColumnHead: array[4] of Text;//CTSI-158.AS.1.0 21SEPT2020 Changed length from 20 chars
        ColumnHeadHead: Text;//CTSI-158.AS.1.0 21SEPT2020 Changed length from 59 chars
        PercentString: array[4] of Text;//CTSI-158.AS.1.0 21SEPT2020 Changed length from 10 chars
        Percent: Decimal;
        "TotalBalanceDue$": Decimal;
        AmountDueToPrint: Decimal;
        CreditLimitToPrint: Text;//CTSI-158.AS.1.0 21SEPT2020 Changed length from 25 chars
        BlockedDescription: Text;//CTSI-158.AS.1.0 21SEPT2020 Changed length from 60 chars
        OverLimitDescription: Text;//CTSI-158.AS.1.0 21SEPT2020 Changed length from 25 chars
        j: Integer;
        CurrencyFactor: Decimal;
        FilterString: Text;//CTSI-158.AS.1.0 21SEPT2020 Changed length from 250 chars
        SubTitle: Text;//CTSI-158.AS.1.0 21SEPT2020 Changed length from 88 chars
        DateTitle: Text;//CTSI-158.AS.1.0 21SEPT2020 Changed length from 20 chars
        ShortDateTitle: Text;//CTSI-158.AS.1.0 21SEPT2020 Changed length from 20 chars
        PeriodEndingDate: array[5] of Date;
        AgingDate: Date;
        LedgEntryLast: Integer;
        Text001: Label 'Amounts are in %1';
        Text002: Label '*** This customer is blocked  for %1 processing ***  ';
        Text003: Label 'No Limit';
        Text004: Label '*** Over Limit ***';
        Text006: Label '(Detail';
        Text007: Label '(Summary';
        Text008: Label ', aged as of';
        Text009: Label 'due date.';
        Text010: Label 'Due Date';
        Text011: Label 'Up To';
        Text012: Label ' Days';
        Text013: Label ' Aged Overdue Amounts';
        Text014: Label 'transaction date.';
        Text015: Label 'Trx Date';
        Text016: Label ' Aged Customer Balances';
        Text017: Label 'document date.';
        Text018: Label 'Doc Date';
        Text019: Label 'Current';
        Text020: Label 'Over';
        Text021: Label 'Amounts are in the customer''s local currency (report totals are in %1).';
        Text022: Label 'Report Total Amount Due (%1)';
        Text101: Label 'Data';
        Text102: Label 'Aged Accounts Receivable';
        Text103: Label 'Company Name';
        Text104: Label 'Report No.';
        Text105: Label 'Report Name';
        Text106: Label 'User ID';
        Text107: Label 'Date / Time';
        Text108: Label 'Customer Filters';
        Text109: Label 'Aged by';
        Text110: Label 'Amounts are';
        Text111: Label 'In our Functional Currency';
        Text112: Label 'As indicated in Data';
        Text113: Label 'Aged as of';
        Text114: Label 'Aging Date (%1)';
        Text115: Label 'Balance Due';
        Text116: Label 'Document Currency';
        Text117: Label 'Customer Currency';
        Text118: Label 'Credit Limit';
        Text119: Label 'Show Only Overdue By Needs a Valid Date Formula';
        ShowAllForOverdue: Boolean;
        CalculatedDate: Date;
        Text120: Label 'This option is only allowed for method Due Date';
        CustTotAmountDue: array[4] of Decimal;
        CustTotAmountDueToPrint: Decimal;
        Text121: Label 'You must enter a period calculation in the Length of Aging Periods field.';
        Aged_Accounts_ReceivableCaptionLbl: Label 'Aged Accounts Receivable';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Aged_byCaptionLbl: Label 'Aged by';
        AmountDueToPrint_Control74CaptionLbl: Label 'Balance Due';
        Credit_LimitCaptionLbl: Label 'Credit Limit';
        Cust__Ledger_Entry___Document_No__CaptionLbl: Label 'Number';
        NameCaptionLbl: Label 'Name';
        Cust__Ledger_Entry__DescriptionCaptionLbl: Label 'Description';
        Cust__Ledger_Entry___Document_Type_CaptionLbl: Label 'Type';
        AmountDueToPrint_Control63CaptionLbl: Label 'Balance Due';
        Cust__Ledger_Entry___Currency_Code_CaptionLbl: Label 'Doc. Curr.';
        DocumentCaptionLbl: Label 'Document';
        Balance_ForwardCaptionLbl: Label 'Balance Forward';
        Balance_to_Carry_ForwardCaptionLbl: Label 'Balance to Carry Forward';
        Total_Amount_DueCaptionLbl: Label 'Total Amount Due';
        Total_Amount_DueCaption_Control86Lbl: Label 'Total Amount Due';
        Credit_Limit_CaptionLbl: Label 'Credit Limit:';
        NS_JobLbl: Label 'Job';
        NS_RetentionLbl: Label 'Retention';
        NS_RetentionToPrint: Decimal;
        NS_TotalRetention: Decimal;
        "NS_RetentionDue$": array[4] of Decimal;
        NS_AgingDateText: Text;//CTSI-158.AS.1.0 21SEPT2020 Changed length from 4 chars
        JobNoLbl: Label 'Job No.';

    local procedure NS_InsertTemp(var CustLedgEntry: Record "Cust. Ledger Entry");
    begin
        with TempCustLedgEntry do begin
            if GET(CustLedgEntry."Entry No.") then
                exit;
            TempCustLedgEntry := CustLedgEntry;
            case AgingMethod of
                AgingMethod::"Due Date":
                    "Posting Date" := "Due Date";
                AgingMethod::"Document Date":
                    "Posting Date" := "Document Date";
            end;
            INSERT;
        end;
    end;

    procedure NS_CalcPercents(Total: Decimal; Amounts: array[4] of Decimal);
    var
        i: Integer;
        j: Integer;
    begin
        CLEAR(PercentString);
        if Total <> 0 then
            for i := 1 to 4 do begin
                Percent := Amounts[i] / Total * 100.0;
                if STRLEN(FORMAT(ROUND(Percent))) + 4 > MAXSTRLEN(PercentString[1]) then
                    PercentString[i] := PADSTR(PercentString[i], MAXSTRLEN(PercentString[i]), '*')
                else begin
                    PercentString[i] := FORMAT(ROUND(Percent));
                    j := STRPOS(PercentString[i], '.');
                    if j = 0 then
                        PercentString[i] := PercentString[i] + '.00'
                    else
                        if j = STRLEN(PercentString[i]) - 1 then
                            PercentString[i] := PercentString[i] + '0';
                    PercentString[i] := PercentString[i] + '%';
                end;
            end;
    end;

    local procedure NS_GetCurrencyRecord(var Currency: Record Currency; CurrencyCode: Code[10]);
    begin
        if CurrencyCode = '' then begin
            CLEAR(Currency);
            Currency.Description := GLSetup."LCY Code";
            Currency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
        end else
            if Currency.Code <> CurrencyCode then
                Currency.GET(CurrencyCode);
    end;

    local procedure NS_GetCurrencyCaptionCode(CurrencyCode: Code[10]): Text;//CTSI-158.AS.1.0 21SEPT2020 Changed length from 80 chars
    begin
        if PrintAmountsInLocal then begin
            if CurrencyCode = '' then
                exit('101,1,' + Text001);

            NS_GetCurrencyRecord(Currency, CurrencyCode);
            exit('101,4,' + STRSUBSTNO(Text001, Currency.Description));
            ;
        end;
        exit('');
    end;

    local procedure NS_MakeExcelInfo();
    begin
        ExcelBuf.SetUseInfoSheet;
        ExcelBuf.AddInfoColumn(FORMAT(Text103), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(CompanyInformation.Name, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text105), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(FORMAT(Text102), false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text104), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(REPORT::"Aged Accounts Receivable", false, false, false, false, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text106), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(USERID, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text107), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(TODAY, false, false, false, false, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddInfoColumn(TIME, false, false, false, false, '', ExcelBuf."Cell Type"::Time);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text108), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(FilterString, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text109), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(DateTitle, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text113), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(PeriodEndingDate[1], false, false, false, false, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text110), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        if PrintAmountsInLocal then
            ExcelBuf.AddInfoColumn(FORMAT(Text112), false, false, false, false, '', ExcelBuf."Cell Type"::Text)
        else
            ExcelBuf.AddInfoColumn(FORMAT(Text111), false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.ClearNewRow;
        NS_MakeExcelDataHeader;
    end;

    local procedure NS_MakeExcelDataHeader();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Cust. Ledger Entry".FIELDCAPTION("Customer No."), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Customer.FIELDCAPTION(Name), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        if PrintDetail then begin
            ExcelBuf.AddColumn(STRSUBSTNO(Text114, ShortDateTitle), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn("Cust. Ledger Entry".FIELDCAPTION(Description), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn("Cust. Ledger Entry".FIELDCAPTION("NS_Job No."), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn("Cust. Ledger Entry".FIELDCAPTION("Document Type"), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn("Cust. Ledger Entry".FIELDCAPTION("Document No."), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        end else
            ExcelBuf.AddColumn(FORMAT(Text118), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        if IncludeRetention then
            ExcelBuf.AddColumn(NS_RetentionLbl, false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Text115), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ColumnHead[1], false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ColumnHead[2], false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ColumnHead[3], false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ColumnHead[4], false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        if PrintAmountsInLocal then begin
            if PrintDetail then
                ExcelBuf.AddColumn(FORMAT(Text116), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text)
            else
                ExcelBuf.AddColumn(FORMAT(Text117), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        end;
    end;

    local procedure NS_MakeExcelDataBody();
    var
        CurrencyCodeToPrint: Code[20];
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Customer."No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Customer.Name, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        if PrintDetail then begin
            ExcelBuf.AddColumn(AgingDate, false, '', false, false, false, '', ExcelBuf."Cell Type"::Date);
            ExcelBuf.AddColumn("Cust. Ledger Entry".Description, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn("Cust. Ledger Entry"."NS_Job No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(FORMAT("Cust. Ledger Entry"."Document Type"), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn("Cust. Ledger Entry"."Document No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        end else
            if OverLimitDescription = '' then
                ExcelBuf.AddColumn(CreditLimitToPrint, false, '', false, false, false, '#,##0', ExcelBuf."Cell Type"::Number)
            else
                ExcelBuf.AddColumn(CreditLimitToPrint, false, OverLimitDescription, true, false, false, '#,##0', ExcelBuf."Cell Type"::Number);
        if IncludeRetention then
            ExcelBuf.AddColumn(NS_RetentionToPrint, false, '', false, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(AmountDueToPrint, false, '', false, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(AmountDue[1], false, '', false, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(AmountDue[2], false, '', false, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(AmountDue[3], false, '', false, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(AmountDue[4], false, '', false, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
        if PrintAmountsInLocal then begin
            if PrintDetail then
                CurrencyCodeToPrint := "Cust. Ledger Entry"."Currency Code"
            else
                CurrencyCodeToPrint := Customer."Currency Code";
            if CurrencyCodeToPrint = '' then
                CurrencyCodeToPrint := GLSetup."LCY Code";
            ExcelBuf.AddColumn(CurrencyCodeToPrint, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text)
        end;
    end;

    local procedure NS_CreateExcelbook();
    begin
        //ExcelBuf.CreateBookAndOpenExcel(Text101,Text102,COMPANYNAME,USERID);
        ERROR('');
    end;
}

