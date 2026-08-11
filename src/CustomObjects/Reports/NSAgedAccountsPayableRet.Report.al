report 14021188 "NS_Aged Accounts Payable Ret"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    // SMPL DateFormula propertyussage deprecated use DateFormula type instead
    //PRJ-84.SK.1.0 Made this report searchable
    //PRJ-266.MS.1.0 added code 
    //PRJ-1133.RM.1.0 15Jan2022 | Removed with statement
    //PRJ-1193.RM.1.0 15Feb2022 | Double Conversion Problem on Aging
    //PRJ-1235.RM.1.0 02March2022 | Added Job Description column
    //PRJCTPR-35 DK.1.0 11Jan2023 |Increase External Document Character length 20 to 35
    //PRJCTPR-35 DK.1.0 16Jan2023 |last 20 characters will be picked Also change Layout
    //PE-291.JS.1.0 02MAY2024 Change only in RDL layout
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSAged Accounts Payable Ret.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Jobs;
    Caption = 'Aged A/P with Retention';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Vendor Posting Group", "Payment Terms Code", "Purchaser Code";
            column(Aged_Accounts_Payable_; 'Aged A/P with Retention')//PRJ-1193.RM.1.0
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            //PRJ-1193.RM.1.0 start
            column(GrandTotalBalanceDue_; GrandTotalBalanceDue)
            {
            }
            column(GrandBalanceDue_1_; GrandBalanceDue[1])
            {
            }
            column(GrandBalanceDue_2_; GrandBalanceDue[2])
            {
            }
            column(GrandBalanceDue_3_; GrandBalanceDue[3])
            {
            }
            column(GrandBalanceDue_4_; GrandBalanceDue[4])
            {
            }
            //PRJ-1193.RM.1.0 end

            column(TIME; TIME)
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
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
            column(Document_Number_is______Vendor_Ledger_Entry__FIELDCAPTION__External_Document_No___; 'Document Number is ' + "Vendor Ledger Entry".FIELDCAPTION("External Document No."))
            {
            }
            column(Vendor_TABLECAPTION__________FilterString; Vendor.TABLECAPTION + ': ' + FilterString)
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
            column(PrintToExcel; PrintToExcel)
            {
            }
            column(PrintDetail; PrintDetail)
            {
            }
            column(PrintAmountsInLocal; PrintAmountsInLocal)
            {
            }
            column(ShowAllForOverdue; ShowAllForOverdue)
            {
            }
            column(UseExternalDocNo; UseExternalDocNo)
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
            column(BlockedDescription; BlockedDescription)
            {
            }
            column(TotalBalanceDue__; -"TotalBalanceDue$")
            {
            }
            column(BalanceDue___1_; -"BalanceDue$"[1])
            {
            }
            column(BalanceDue___2_; -"BalanceDue$"[2])
            {
            }
            column(BalanceDue___3_; -"BalanceDue$"[3])
            {
            }
            column(BalanceDue___4_; -"BalanceDue$"[4])
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
            column(TotalBalanceDue___Control91; -"TotalBalanceDue$")
            {
            }
            column(BalanceDue___1__Control92; -"BalanceDue$"[1])
            {
            }
            column(BalanceDue___2__Control93; -"BalanceDue$"[2])
            {
            }
            column(BalanceDue___3__Control94; -"BalanceDue$"[3])
            {
            }
            column(PercentString_1__Control95; PercentString[1])
            {
            }
            column(PercentString_2__Control96; PercentString[2])
            {
            }
            column(PercentString_3__Control97; PercentString[3])
            {
            }
            column(BalanceDue___4__Control98; -"BalanceDue$"[4])
            {
            }
            column(PercentString_4__Control99; PercentString[4])
            {
            }
            column(Vendor_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(Vendor_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
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
            column(Vendor__No__Caption; FIELDCAPTION("No."))
            {
            }
            column(NameCaption; NameCaptionLbl)
            {
            }
            column(AmountDueToPrint_Control74Caption; AmountDueToPrint_Control74CaptionLbl)
            {
            }
            column(Vendor__No__Caption_Control22; FIELDCAPTION("No."))
            {
            }
            column(Vendor_NameCaption; FIELDCAPTION(Name))
            {
            }
            column(DocNoCaption; DocNoCaptionLbl)
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(TypeCaption; TypeCaptionLbl)
            {
            }
            column(AmountDueToPrint_Control63Caption; AmountDueToPrint_Control63CaptionLbl)
            {
            }
            column(DocumentCaption; DocumentCaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry___Currency_Code_Caption; Vendor_Ledger_Entry___Currency_Code_CaptionLbl)
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
            column(Control47Caption; CAPTIONCLASSTRANSLATE('101,0,' + Text022))
            {
            }
            column(Control48Caption; CAPTIONCLASSTRANSLATE('101,0,' + Text022))
            {
            }
            column(RetentionCaption; RetentionLbl)
            {
            }
            column(JobNoCaption; JobNoLbl)
            {
            }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No."), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                DataItemTableView = SORTING("Vendor No.", Open, Positive, "Due Date");

                trigger OnAfterGetRecord();
                var
                    UseRecord: Boolean;
                begin
                    UseRecord := true;

                    if not PurchSetup."NS_Purchase Retention Inactive" then
                        if not IncludeRetention then
                            if "NS_Retention Ledger Code" = JobsSetup."NS_Retention Payable Ledger" then
                                UseRecord := false;

                    //Determine if the record will be used based on Draw No.
                    if DrawNo > '' then
                        if "NS_Draw No." <> DrawNo then
                            UseRecord := false;

                    if UseRecord then begin
                        SETRANGE("Date Filter", 0D, PeriodEndingDate[1]);
                        CALCFIELDS("Remaining Amount");
                        if "Remaining Amount" <> 0 then
                            InsertTemp("Vendor Ledger Entry");
                    end;
                    CurrReport.SKIP;    // this fools the system into thinking that no details "printed"...yet
                end;

                trigger OnPreDataItem();
                begin
                    // Find ledger entries which are posted before the date of the aging.
                    SETRANGE("Posting Date", 0D, PeriodEndingDate[1]);

                    if (FORMAT(ShowOnlyOverDueBy) <> '') and not ShowAllForOverdue then
                        SETRANGE("Due Date", 0D, CalculatedDate);
                end;
            }
            dataitem(Totals; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(AmountDueToPrint; -AmountDueToPrint)
                {
                }
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
                //PRJ-1235.RM.1.0 start

                column("Job_Desc_Caption"; JobDescLbl)
                {
                }

                column(Descr; NSJobDesc)
                {
                }

                //PRJ-1235.RM.1.0 end
                column(AgingDate; AgingDate)
                {
                }
                column(Vendor_Ledger_Entry__Description; "Vendor Ledger Entry".Description)
                {
                }
                column(Vendor_Ledger_Entry___Document_Type_; "Vendor Ledger Entry"."Document Type")
                {
                }
                column(DocNo; DocNo)
                {
                }
                column(RetentionToPrint; -RetentionToPrint)
                {
                }
                column(AmountDueToPrint_Control63; -AmountDueToPrint)
                {
                }
                column(AmountDue_1__Control64; -AmountDue[1])
                {
                }
                column(AmountDue_2__Control65; -AmountDue[2])
                {
                }
                column(AmountDue_3__Control66; -AmountDue[3])
                {
                }
                column(AmountDue_4__Control67; -AmountDue[4])
                {
                }
                column(Vendor_Ledger_Entry___Currency_Code_; "Vendor Ledger Entry"."Currency Code")
                {
                }
                column(AmountDueToPrint_Control68; -AmountDueToPrint)
                {
                }
                column(AmountDue_1__Control69; -AmountDue[1])
                {
                }
                column(AmountDue_2__Control70; -AmountDue[2])
                {
                }
                column(AmountDue_3__Control71; -AmountDue[3])
                {
                }
                column(AmountDue_4__Control72; -AmountDue[4])
                {
                }
                column(AmountDueToPrint_Control74; -AmountDueToPrint)
                {
                }
                column(AmountDue_1__Control75; -AmountDue[1])
                {
                }
                column(AmountDue_2__Control76; -AmountDue[2])
                {
                }
                column(AmountDue_3__Control77; -AmountDue[3])
                {
                }
                column(AmountDue_4__Control78; -AmountDue[4])
                {
                }
                column(PercentString_1__Control5; PercentString[1])
                {
                }
                column(PercentString_2__Control6; PercentString[2])
                {
                }
                column(PercentString_3__Control7; PercentString[3])
                {
                }
                column(PercentString_4__Control8; PercentString[4])
                {
                }
                column(Vendor__No___Control80; Vendor."No.")
                {
                }
                column(AmountDueToPrint_Control81; -AmountDueToPrint)
                {
                }
                column(AmountDue_1__Control82; -AmountDue[1])
                {
                }
                column(AmountDue_2__Control83; -AmountDue[2])
                {
                }
                column(AmountDue_3__Control84; -AmountDue[3])
                {
                }
                column(AmountDue_4__Control85; -AmountDue[4])
                {
                }
                column(PercentString_1__Control87; PercentString[1])
                {
                }
                column(PercentString_2__Control88; PercentString[2])
                {
                }
                column(PercentString_3__Control89; PercentString[3])
                {
                }
                column(PercentString_4__Control90; PercentString[4])
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
                column(Control1020001Caption; CAPTIONCLASSTRANSLATE(GetCurrencyCaptionCode(Vendor."Currency Code")))
                {
                }
                column(AgingDateText; AgingDateText)
                {
                }
                column(VLE_JobNo; "Vendor Ledger Entry"."NS_Job No.")
                {
                }
                //PRJ-1193.RM.1.0 start
                column(NS_RetentionToPrintUSD; NS_RetentionToPrintUSD)
                { }
                column("NS_Retention_Ledger_Code"; TempVendLedgEntry."NS_Retention Ledger Code")
                { }
                //PRJ-1193.RM.1.0 end

                trigger OnAfterGetRecord();
                begin
                    CalcPercents(AmountDueToPrint, AmountDue);
                    CLEAR(AmountDue); //PRJ-266.MS.1.0 Added
                    if Number = 1 then
                        //TempVendLedgEntry.FINDFIRST
                        TempVendLedgEntry.FIND('-') //PRJ-266.MS.1.0 Added
                    else
                        TempVendLedgEntry.NEXT;
                    TempVendLedgEntry.SETRANGE("Date Filter", 0D, PeriodEndingDate[1]);
                    TempVendLedgEntry.CALCFIELDS("Remaining Amount", "Remaining Amt. (LCY)");
                    if TempVendLedgEntry."Remaining Amount" = 0 then
                        CurrReport.SKIP;
                    if TempVendLedgEntry."Currency Code" <> '' then
                        TempVendLedgEntry."Remaining Amt. (LCY)" :=
                          ROUND(
                            CurrExchRate.ExchangeAmtFCYToFCY(
                              PeriodEndingDate[1],
                              TempVendLedgEntry."Currency Code",
                              '',
                              TempVendLedgEntry."Remaining Amount"));
                    if PrintAmountsInLocal then begin
                        TempVendLedgEntry."Remaining Amount" :=
                          ROUND(
                            CurrExchRate.ExchangeAmtFCYToFCY(
                              PeriodEndingDate[1],
                              TempVendLedgEntry."Currency Code",
                              Vendor."Currency Code",
                              TempVendLedgEntry."Remaining Amount"),
                            Currency."Amount Rounding Precision");
                        AmountDueToPrint := TempVendLedgEntry."Remaining Amount";
                        NS_RetentionToPrintUSD2 := TempVendLedgEntry."Remaining Amt. (LCY)";//PRJ-1193.RM.1.0
                    end else begin
                        AmountDueToPrint := TempVendLedgEntry."Remaining Amt. (LCY)";
                        NS_RetentionToPrintUSD2 := TempVendLedgEntry."Remaining Amt. (LCY)";//PRJ-1193.RM.1.0
                    end;
                    NSJobDesc := ' ';//PRJ-1235.RM.1.0 start
                    if NSJob.Get(TempVendLedgEntry."NS_Job No.") then
                        NSJobDesc := NSJob.Description; //PRJ-1235.RM.1.0 end

                    //if (not PurchSetup."NS_Purchase Retention Inactive") and	//PRJ-266.MS.1.0 code comment
                    //   (TempVendLedgEntry."NS_Retention Ledger Code" = JobsSetup."NS_Retention Payable Ledger") and
                    //   (TempVendLedgEntry."NS_Retention Date" > 0D) then
                    //    AgingDate := TempVendLedgEntry."NS_Retention Date"
                    //else
                    case AgingMethod of
                        AgingMethod::"Due Date":
                            AgingDate := TempVendLedgEntry."Due Date";
                        AgingMethod::"Trans Date":
                            AgingDate := TempVendLedgEntry."Posting Date";
                        AgingMethod::"Document Date":
                            AgingDate := TempVendLedgEntry."Document Date";
                    end;
                    AgingDateText := FORMAT(DATE2DMY(AgingDate, 3)) + FORMAT(DATE2DMY(AgingDate, 2)) + FORMAT(DATE2DMY(AgingDate, 1));
                    j := 0;
                    while AgingDate < PeriodEndingDate[j + 1] do begin
                        j := j + 1;
                        if j = 5 then
                            CurrReport.BREAK;
                    end;
                    if j = 0 then
                        j := 1;

                    RetentionToPrint := 0;
                    NS_RetentionToPrintUSD := 0;//PRJ-1193.RM.1.0
                    if not PurchSetup."NS_Purchase Retention Inactive" then
                        if TempVendLedgEntry."NS_Retention Ledger Code" = JobsSetup."NS_Retention Payable Ledger" then begin
                            RetentionToPrint := AmountDueToPrint;
                            NS_RetentionToPrintUSD := NS_RetentionToPrintUSD2;//PRJ-1193.RM.1.0
                            TotalRetention := TotalRetention + RetentionToPrint;
                            if AgingDate > PeriodEndingDate[1] then
                                AmountDueToPrint := 0;
                        end;

                    if TempVendLedgEntry."NS_Retention Ledger Code" = JobsSetup."NS_Retention Payable Ledger" then begin
                        AmountDueToPrint := 0;
                        "RetentionDue$"[j] := "RetentionDue$"[j] + TempVendLedgEntry."Remaining Amt. (LCY)";
                        TempVendLedgEntry."Remaining Amt. (LCY)" := 0;
                    end;

                    AmountDue[j] := AmountDueToPrint;
                    "BalanceDue$"[j] := "BalanceDue$"[j] + TempVendLedgEntry."Remaining Amt. (LCY)";

                    "TotalBalanceDue$" := 0;
                    VendTotAmountDue[j] := VendTotAmountDue[j] + AmountDueToPrint;
                    VendTotAmountDueToPrint := VendTotAmountDueToPrint + AmountDueToPrint;

                    for j := 1 to 4 do
                        "TotalBalanceDue$" := "TotalBalanceDue$" + "BalanceDue$"[j];
                    CalcPercents("TotalBalanceDue$", "BalanceDue$");

                    "Vendor Ledger Entry" := TempVendLedgEntry;
                    //PRJCTPR-35 DK.1.0 16Jan2023 start
                    // if UseExternalDocNo then
                    //     DocNo := "Vendor Ledger Entry"."External Document No."
                    // else
                    //     DocNo := "Vendor Ledger Entry"."Document No.";
                    //PRJCTPR-358.JS.1.0 24APR2024 - Start
                    if UseExternalDocNo then begin // changed :: Enclosed If in begin end.
                        DocNoLength := StrLen("Vendor Ledger Entry"."External Document No.");
                        if (DocNoLength <= 20) then // Condition Merged
                            DocNo := "Vendor Ledger Entry"."External Document No.";
                        if DocNoLength > 20 then begin
                            DifferencChar := DocNoLength - 20;
                            DocNo := DelStr("Vendor Ledger Entry"."External Document No.", 1, DifferencChar)
                        end;
                    end   //PRJCTPR-358.JS.1.0 24APR2024 - end
                    else
                        DocNo := "Vendor Ledger Entry"."Document No.";
                    //PRJCTPR-35 DK.1.0 16Jan2023 End

                    // Do NOT use the following fields in the sections:
                    // "Applied-To Doc. Type"
                    // "Applied-To Doc. No."
                    // Open
                    // "Paym. Disc. Taken"
                    // "Closed by Entry No."
                    // "Closed at Date"
                    // "Closed by Amount"

                    //PRJ-1193.RM.1.0 Start
                    TotalNumberOfEntries -= 1;
                    if TotalNumberOfEntries = 0 then begin
                        for j := 1 to 4 do
                            GrandBalanceDue[j] += "BalanceDue$"[j];
                        GrandTotalBalanceDue += "TotalBalanceDue$";
                    end;
                    if PrintDetail and PrintToExcel then
                        MakeExcelDataBody();
                    NumberOfLines += 1;
                end;
                //PRJ-1193.RM.1.0 End


                trigger OnPostDataItem();
                begin
                    if TempVendLedgEntry.COUNT > 0 then begin
                        for j := 1 to 4 do
                            AmountDue[j] := VendTotAmountDue[j];
                        AmountDueToPrint := VendTotAmountDueToPrint;
                        if not PrintDetail and PrintToExcel then
                            MakeExcelDataBody();
                    end;
                end;

                trigger OnPreDataItem();
                begin
                    //CurrReport.CREATETOTALS(AmountDueToPrint, AmountDue);
                    CurrReport.CREATETOTALS(RetentionToPrint);
                    SETRANGE(Number, 1, TempVendLedgEntry.COUNT);
                    TempVendLedgEntry.SETCURRENTKEY("Vendor No.", "Posting Date");
                    CLEAR("BalanceDue$");
                    CLEAR(VendTotAmountDue);
                    VendTotAmountDueToPrint := 0;
                    TotalNumberOfEntries := TempVendLedgEntry.Count();//PRJ-1193.RM.1.0
                end;
            }

            trigger OnAfterGetRecord();
            var
                VendLedgEntry: Record "Vendor Ledger Entry";
            begin
                if PrintAmountsInLocal then begin
                    GetCurrencyRecord(Currency, "Currency Code");
                    CurrencyFactor := CurrExchRate.ExchangeRate(PeriodEndingDate[1], "Currency Code");
                end;

                if Blocked <> Blocked::" " then
                    BlockedDescription := STRSUBSTNO(Text003, Blocked)
                else
                    BlockedDescription := '';

                TempVendLedgEntry.DELETEALL;

                if FORMAT(ShowOnlyOverDueBy) <> '' then
                    CalculatedDate := CALCDATE(ShowOnlyOverDueBy, PeriodEndingDate[1]);

                if ShowAllForOverdue and (FORMAT(ShowOnlyOverDueBy) <> '') then begin
                    VendLedgEntry.SETRANGE("Vendor No.", "No.");
                    VendLedgEntry.SETRANGE(Open, true);
                    VendLedgEntry.SETRANGE("Due Date", 0D, CalculatedDate);
                    if not VendLedgEntry.FINDFIRST() then
                        CurrReport.SKIP;
                end;
            end;

            trigger OnPreDataItem();
            begin
                CLEAR("BalanceDue$");
                if PeriodEndingDate[1] = 0D then
                    PeriodEndingDate[1] := WORKDATE;

                if PrintDetail then begin
                    SubTitle := Text004;
                end else
                    SubTitle := Text005;

                SubTitle := SubTitle + Text006 + ' ' + FORMAT(PeriodEndingDate[1], 0, 4) + ')';

                if AgingMethod = AgingMethod::"Due Date" then begin
                    DateTitle := Text007;
                    ShortDateTitle := Text008;
                    ColumnHead[2] := Text009 + ' '
                      + FORMAT(PeriodEndingDate[1] - PeriodEndingDate[3])
                      + ' ' + Text010;
                    ColumnHeadHead := ' ' + Text011 + ' ';
                end else
                    if AgingMethod = AgingMethod::"Trans Date" then begin
                        DateTitle := Text012;
                        ShortDateTitle := Text013;
                        ColumnHead[2] := FORMAT(PeriodEndingDate[1] - PeriodEndingDate[2] + 1)
                          + ' - '
                          + FORMAT(PeriodEndingDate[1] - PeriodEndingDate[3])
                          + ' ' + Text010;
                        ColumnHeadHead := ' ' + Text014 + ' ';
                    end else begin
                        DateTitle := Text015;
                        ShortDateTitle := Text016;
                        ColumnHead[2] := FORMAT(PeriodEndingDate[1] - PeriodEndingDate[2] + 1)
                          + ' - '
                          + FORMAT(PeriodEndingDate[1] - PeriodEndingDate[3])
                          + ' ' + Text010;
                        ColumnHeadHead := ' ' + Text017 + ' ';
                    end;

                ColumnHead[1] := Text018;
                ColumnHead[3] := FORMAT(PeriodEndingDate[1] - PeriodEndingDate[3] + 1)
                  + ' - '
                  + FORMAT(PeriodEndingDate[1] - PeriodEndingDate[4])
                  + ' ' + Text010;
                ColumnHead[4] := 'Over '
                  + FORMAT(PeriodEndingDate[1] - PeriodEndingDate[4])
                  + ' ' + Text010;

                if PrintToExcel then
                    MakeExcelInfo();
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
                    field(DrawNo; DrawNo)
                    {
                        Caption = 'Draw No.';
                        ApplicationArea = All;
                    }
                    field(AgedAsOf; PeriodEndingDate[1])
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
                        Caption = 'Aging Method';
                        OptionCaption = 'Due Date,Trans Date,Document Date';
                        ApplicationArea = All;
                    }
                    field(LengthOfAgingPeriods; PeriodCalculation)
                    {
                        Caption = 'Length of Aging Periods';
                        ApplicationArea = All;

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
                        Caption = 'Show All for Overdue By Vendor';
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            if AgingMethod <> AgingMethod::"Due Date" then
                                ERROR(Text120);
                            if ShowAllForOverdue and (FORMAT(ShowOnlyOverDueBy) = '') then
                                ERROR(Text119);
                        end;
                    }
                    field(PrintAmountsInVendorsCurrency; PrintAmountsInLocal)
                    {
                        Caption = 'Print Amounts in Vendor''s Currency';
                        MultiLine = true;
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            if ShowAllForOverdue and (FORMAT(ShowOnlyOverDueBy) = '') then
                                ERROR(Text119);
                        end;
                    }
                    field(UseExternalDocNo; UseExternalDocNo)
                    {
                        Caption = 'Use External Doc. No.';
                        ApplicationArea = All;
                    }
                    field(PrintDetail; PrintDetail)
                    {
                        Caption = 'Print Detail';
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            if not PrintDetail then
                                IncludeRetention := false;
                        end;
                    }
                    field(IncludeRetention; IncludeRetention)
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
            NS_CreateExcelbook();//PRJ-1193.RM.1.0
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
        PurchSetup.GET;
        FilterString := Vendor.GETFILTERS;
    end;

    var
        CompanyInformation: Record "Company Information";
        TempVendLedgEntry: Record "Vendor Ledger Entry" temporary;
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        GLSetup: Record "General Ledger Setup";
        JobsSetup: Record "Jobs Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        ExcelBuf: Record "Excel Buffer" temporary;
        PeriodCalculation: DateFormula;
        ShowOnlyOverDueBy: DateFormula;
        AgingMethod: Option "Due Date","Trans Date","Document Date";
        PrintAmountsInLocal: Boolean;
        PrintDetail: Boolean;
        IncludeRetention: Boolean;
        PrintToExcel: Boolean;
        AmountDue: array[4] of Decimal;
        TotalNumberOfEntries: Integer;//PRJ-1193.RM.1.0 
        NS_RetentionToPrintUSD2: Decimal;//PRJ-1193.RM.1.0 
        NS_RetentionToPrintUSD: Decimal;//PRJ-1193.RM.1.0
        NumberOfLines: Integer;//PRJ-1193.RM.1.0
        GrandTotalBalanceDue: Decimal;//PRJ-1193.RM.1.0
        GrandBalanceDue: array[4] of Decimal;//PRJ-1193.RM.1.0

        "BalanceDue$": array[4] of Decimal;
        ColumnHead: array[4] of Text[20];
        ColumnHeadHead: Text[59];
        PercentString: array[4] of Text[10];
        Percent: Decimal;
        "TotalBalanceDue$": Decimal;
        AmountDueToPrint: Decimal;
        BlockedDescription: Text[80];
        j: Integer;
        CurrencyFactor: Decimal;
        FilterString: Text[250];
        SubTitle: Text[88];
        DateTitle: Text[20];
        ShortDateTitle: Text[20];
        DrawNo: Code[10];
        PeriodEndingDate: array[5] of Date;
        AgingDate: Date;
        UseExternalDocNo: Boolean;
        DocNo: Code[35];//PRJCTPR-35 DK.1.0 11Jan2023 The previous length is 20 char.
        DifferencChar: integer;//PRJCTPR-35 DK.1.0 16Jan2023
        DocNoLength: Integer;//PRJCTPR-35 DK.1.0 16Jan2023
        Text001: Label 'Amounts are in %1';
        Text003: Label '*** This vendor is blocked for %1 processing ***';
        Text004: Label '(Detail';
        Text005: Label '(Summary';
        Text006: Label ', aged as of';
        Text007: Label 'due date.';
        Text008: Label 'Due Date';
        Text009: Label 'Up To';
        Text010: Label 'Days';
        Text011: Label 'Aged Overdue Amounts';
        Text012: Label 'transaction date.';
        Text013: Label 'Trx Date';
        Text014: Label 'Aged Vendor Balances';
        Text015: Label 'document date.';
        Text016: Label 'Doc Date';
        Text017: Label 'Aged Vendor Balances';
        Text018: Label 'Current';
        Text021: Label 'Amounts are in the vendor''s local currency (report totals are in %1).';
        Text022: Label 'Report Total Amount Due (%1)';
        Text101: Label 'Data';
        Text102: Label 'Aged A/P with Retention'; //PRJ-1193.RM.1.0
        Text103: Label 'Company Name';
        Text104: Label 'Report No.';
        Text105: Label 'Report Name';
        Text106: Label 'User ID';
        Text107: Label 'Date / Time';
        Text108: Label 'Vendor Filters';
        Text109: Label 'Aged by';
        Text122: Label 'Amounts in Customer''s Currency'; //PRJ-1193.RM.1.0 
        Text123: Label 'Print Detail'; //PRJ-1193.RM.1.0 
        Text124: Label 'Include Retention'; //PRJ-1193.RM.1.0 
        Text125: Label 'Use External Doc. No.';//PRJ-1193.RM.1.0 
        JobDescLbl: Label 'Job Description'; //PRJ-1235.RM.1.0
        NSJobDesc: Text;//PRJ-1235.RM.1.0
        Text110: Label 'Amounts are';
        Text111: Label 'In our Functional Currency';
        Text112: Label 'As indicated in Data';
        Text113: Label 'Aged as of';
        Text114: Label 'Aging Date (%1)';
        Text115: Label 'Balance Due';
        Text116: Label 'Document Currency';
        Text117: Label 'Vendor Currency';
        ShowAllForOverdue: Boolean;
        Text119: Label 'Show Only Overdue By Needs a Valid Date Formula';
        CalculatedDate: Date;
        Text120: Label 'This option is only allowed for method Due Date';
        VendTotAmountDue: array[4] of Decimal;
        VendTotAmountDueToPrint: Decimal;
        Text121: Label 'You must enter a period calculation in the Length of Aging Periods field.';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Aged_byCaptionLbl: Label 'Aged by';
        NameCaptionLbl: Label 'Name';
        AmountDueToPrint_Control74CaptionLbl: Label 'Balance Due';
        DocNoCaptionLbl: Label 'Doc. Number';
        DescriptionCaptionLbl: Label 'Description';
        TypeCaptionLbl: Label 'Type';
        AmountDueToPrint_Control63CaptionLbl: Label 'Balance Due';
        DocumentCaptionLbl: Label 'Document';
        Vendor_Ledger_Entry___Currency_Code_CaptionLbl: Label 'Doc. Curr.';
        Phone_CaptionLbl: Label 'Phone:';
        Contact_CaptionLbl: Label 'Contact:';
        Balance_ForwardCaptionLbl: Label 'Balance Forward';
        Balance_to_Carry_ForwardCaptionLbl: Label 'Balance to Carry Forward';
        Total_Amount_DueCaptionLbl: Label 'Total Amount Due';
        Total_Amount_DueCaption_Control86Lbl: Label 'Total Amount Due';
        RetentionLbl: Label 'Retention';
        RetentionToPrint: Decimal;
        TotalRetention: Decimal;
        "RetentionDue$": array[4] of Decimal;
        AgingDateText: Text[8];
        JobNoLbl: Label 'Job No.';
        NSJob: Record Job;//PRJ-1235.RM.1.0

    local procedure InsertTemp(var VendLedgEntry: Record "Vendor Ledger Entry");
    begin
        //PRJ-1133.RM.1.0.001 start
        //with TempVendLedgEntry do begin
        if TempVendLedgEntry.GET(VendLedgEntry."Entry No.") then
            exit;
        TempVendLedgEntry := VendLedgEntry;
        case AgingMethod of
            AgingMethod::"Due Date":
                TempVendLedgEntry."Posting Date" := TempVendLedgEntry."Due Date";
            AgingMethod::"Document Date":
                TempVendLedgEntry."Posting Date" := TempVendLedgEntry."Document Date";
        end;
        TempVendLedgEntry.INSERT();
        //end;
        //PRJ-1133.RM.1.0.001 end
    end;

    procedure CalcPercents(Total: Decimal; Amounts: array[4] of Decimal);
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

    local procedure GetCurrencyRecord(var Currency: Record Currency; CurrencyCode: Code[10]);
    begin
        if CurrencyCode = '' then begin
            CLEAR(Currency);
            Currency.Description := GLSetup."LCY Code";
            Currency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
        end else
            if Currency.Code <> CurrencyCode then
                Currency.GET(CurrencyCode);
    end;

    local procedure GetCurrencyCaptionCode(CurrencyCode: Code[10]): Text[80];
    begin
        if PrintAmountsInLocal then begin
            if CurrencyCode = '' then
                exit('101,1,' + Text001);

            GetCurrencyRecord(Currency, CurrencyCode);
            exit('101,4,' + STRSUBSTNO(Text001, Currency.Description));
            ;
        end;
        exit('');
    end;

    local procedure MakeExcelInfo();
    begin
        ExcelBuf.SetUseInfoSheet;
        ExcelBuf.AddInfoColumn(FORMAT(Text103), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(CompanyInformation.Name, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text105), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(FORMAT(Text102), false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text104), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(REPORT::"NS_Aged Accounts Payable Ret", false, false, false, false, '', ExcelBuf."Cell Type"::Number);//PRJ-1193.RM.1.0
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
        ExcelBuf.AddInfoColumn(FORMAT(Text122), false, true, false, false, '', ExcelBuf."Cell Type"::Text);//PRJ-1193.RM.1.0
        ExcelBuf.AddInfoColumn(PrintAmountsInLocal, false, false, false, false, '', ExcelBuf."Cell Type"::Text);//PRJ-1193.RM.1.0
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text123), false, true, false, false, '', ExcelBuf."Cell Type"::Text);//PRJ-1193.RM.1.0
        ExcelBuf.AddInfoColumn(PrintDetail, false, false, false, false, '', ExcelBuf."Cell Type"::Text);//PRJ-1193.RM.1.0
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text124), false, true, false, false, '', ExcelBuf."Cell Type"::Text);//PRJ-1193.RM.1.0
        ExcelBuf.AddInfoColumn(IncludeRetention, false, false, false, false, '', ExcelBuf."Cell Type"::Text);//PRJ-1193.RM.1.0
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text125), false, true, false, false, '', ExcelBuf."Cell Type"::Text);//PRJ-1193.RM.1.0
        ExcelBuf.AddInfoColumn(UseExternalDocNo, false, false, false, false, '', ExcelBuf."Cell Type"::Text);//PRJ-1193.RM.1.0
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text110), false, true, false, false, '', ExcelBuf."Cell Type"::Text);
        if PrintAmountsInLocal then
            ExcelBuf.AddInfoColumn(FORMAT(Text112), false, false, false, false, '', ExcelBuf."Cell Type"::Text)
        else
            ExcelBuf.AddInfoColumn(FORMAT(Text111), false, false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.ClearNewRow;
        MakeExcelDataHeader;
    end;

    local procedure MakeExcelDataHeader();
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Vendor Ledger Entry".FIELDCAPTION("Vendor No."), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Vendor.FIELDCAPTION(Name), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        if PrintDetail then begin
            ExcelBuf.AddColumn(STRSUBSTNO(Text114, ShortDateTitle), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn("Vendor Ledger Entry".FIELDCAPTION(Description), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn("Vendor Ledger Entry".FIELDCAPTION("Document Type"), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn("Vendor Ledger Entry".FIELDCAPTION("Document No."), false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        end;
        if IncludeRetention then
            ExcelBuf.AddColumn(RetentionLbl, false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
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

    local procedure MakeExcelDataBody();
    var
        CurrencyCodeToPrint: Code[20];
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Vendor."No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Vendor.Name, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        if PrintDetail then begin
            ExcelBuf.AddColumn(AgingDate, false, '', false, false, false, '', ExcelBuf."Cell Type"::Date);
            ExcelBuf.AddColumn("Vendor Ledger Entry".Description, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(FORMAT("Vendor Ledger Entry"."Document Type"), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(DocNo, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        end;
        if IncludeRetention then
            ExcelBuf.AddColumn(-RetentionToPrint, false, '', false, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(-AmountDueToPrint, false, '', false, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(-AmountDue[1], false, '', false, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(-AmountDue[2], false, '', false, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(-AmountDue[3], false, '', false, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(-AmountDue[4], false, '', false, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
        if PrintAmountsInLocal then begin
            if PrintDetail then
                CurrencyCodeToPrint := "Vendor Ledger Entry"."Currency Code"
            else
                CurrencyCodeToPrint := Vendor."Currency Code";
            if CurrencyCodeToPrint = '' then
                CurrencyCodeToPrint := GLSetup."LCY Code";
            ExcelBuf.AddColumn(CurrencyCodeToPrint, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text)
        end;
    end;
    //PRJ-1193.RM.1.0 Start
    local procedure NS_CreateExcelbook();
    begin
        ExcelBuf.CreateNewBook(Text102);
        ExcelBuf.WriteSheet(Text102, CompanyName, UserId);
        ExcelBuf.CloseBook();
        ExcelBuf.SetFriendlyFilename(StrSubstNo(Text102, CurrentDateTime, UserId));
        ExcelBuf.OpenExcel();
    end;


    // local procedure CreateExcelbook();
    // begin

    //     //ExcelBuf.CreateBookAndOpenExcel('', Text101, Text102, COMPANYNAME, USERID); //PPNA16.0 Commented

    //     ERROR('');
    // end;
    //PRJ-1193.RM.1.0 End
}

