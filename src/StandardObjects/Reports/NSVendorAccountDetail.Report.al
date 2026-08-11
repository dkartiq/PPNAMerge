report 14021220 "NS_Vendor Account Detail"
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
    // +     - OnPreReport() - get Purchases & Payables Setup record
    // +     - Vendor Ledger Entry - OnPreDataItem: add filter on Retention Ledger Code if needed
    // +------------------------------------------------------------
    //PRJ-1602.NK.1.0 08Sep2022 | Block Code
  DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PPVendor Account Detail.rdl';

    // ApplicationArea = Basic, Suite; //PRJ-1602.NK.1.0 08Sep2022 Block
    Caption = 'Vendor Account Detail';
    //UsageCategory = ReportsAndAnalysis; //PRJ-1602.NK.1.0 08Sep2022 Block
    UsageCategory = none;//PRJ-1602.NK.1.0 08Sep2022
    dataset
    {
        dataitem(Header; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = CONST(1));
            column(Vendor_Account_DetailCaption; Vendor_Account_DetailCaptionLbl)
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
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Vendors_without_balances_are_not_included_Caption; Vendors_without_balances_are_not_included_CaptionLbl)
            {
            }
            column(Vendor__No__Caption; Vendor__No__CaptionLbl)
            {
            }
            column(DocumentCaption; DocumentCaptionLbl)
            {
            }
            column(Net_ChangeCaption; Net_ChangeCaptionLbl)
            {
            }
            column(BalanceToPrint_Control64Caption; BalanceToPrint_Control64CaptionLbl)
            {
            }
            column(DebitsCaption; DebitsCaptionLbl)
            {
            }
            column(CreditsCaption; CreditsCaptionLbl)
            {
            }
            column(DocNoCaption; DocNoCaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry_AmountCaption; Vendor_Ledger_Entry_AmountCaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry__Currency_Code_Caption; Vendor_Ledger_Entry__Currency_Code_CaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry_OpenCaption; Vendor_Ledger_Entry_OpenCaptionLbl)
            {
            }
            column(Phone_Caption; Phone_CaptionLbl)
            {
            }
            column(Contact_Caption; Contact_CaptionLbl)
            {
            }
            column(Ending_Balance__no_activity_Caption; Ending_Balance__no_activity_CaptionLbl)
            {
            }
            column(Beginning_BalanceCaption; Beginning_BalanceCaptionLbl)
            {
            }
            column(VendorsCaption; VendorsCaptionLbl)
            {
            }
            column(EntriesCaption; EntriesCaptionLbl)
            {
            }
            column(Control8Caption; CAPTIONCLASSTRANSLATE('101,1,' + Text003))
            {
            }
            column(Vendor_Ledger_Entry__Posting_Date_Caption; "Vendor Ledger Entry".FIELDCAPTION("Posting Date"))
            {
            }
            column(Vendor_Ledger_Entry__Document_Type_Caption; Vendor_Ledger_Entry__Document_Type_CaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry_DescriptionCaption; "Vendor Ledger Entry".FIELDCAPTION(Description))
            {
            }
            column(Document_Number_is______Vendor_Ledger_Entry__FIELDCAPTION__External_Document_No___; 'Document Number is ' + "Vendor Ledger Entry".FIELDCAPTION("External Document No."))
            {
            }
            column(GetCurrencyCaptionCode__Currency_Code__; CAPTIONCLASSTRANSLATE(GetCurrencyCaptionCode(Vendor."Currency Code")))
            {
            }
            column(Control104Caption; CAPTIONCLASSTRANSLATE('101,0,' + Text005))
            {
            }
            column(Vendor_Ledger_Entry___Remaining_Amount_Caption; Vendor_Ledger_Entry___Remaining_Amount_CaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry___Original_Pmt__Disc__Possible_Caption; Vendor_Ledger_Entry___Original_Pmt__Disc__Possible_CaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry___Pmt__Discount_Date_Caption; Vendor_Ledger_Entry___Pmt__Discount_Date_CaptionLbl)
            {
            }
            column(Due_DateCaption; Due_DateCaptionLbl)
            {
            }
            column(TempAppliedVendLedgEntry__Entry_No___Control75Caption; TempAppliedVendLedgEntry__Entry_No___Control75CaptionLbl)
            {
            }
            column(FORMAT_TempAppliedVendLedgEntry__Document_Type__Caption; FORMAT_TempAppliedVendLedgEntry__Document_Type__CaptionLbl)
            {
            }
            column(DocNo_Control55Caption; DocNo_Control55CaptionLbl)
            {
            }
            column(PrintAmountsInLocal; PrintAmountsInLocal)
            {
            }
            column(AllHavingBalance; AllHavingBalance)
            {
            }
            column(UseExternalDocNo; UseExternalDocNo)
            {
            }
            column(AdditionalInformation; AdditionalInformation)
            {
            }
            column(OnlyOnePerPage; OnlyOnePerPage)
            {
            }
            column(Vendor_TABLECAPTION__________FilterString; Vendor.TABLECAPTION + ': ' + FilterString)
            {
            }
            column(FilterString; FilterString)
            {
            }
            column(Vendor_Ledger_Entry__TABLECAPTION__________FilterString2; "Vendor Ledger Entry".TABLECAPTION + ': ' + FilterString2)
            {
            }
            column(FilterString2; FilterString2)
            {
            }
            dataitem(Vendor; Vendor)
            {
                RequestFilterFields = "No.", "Search Name", "Vendor Posting Group", "Date Filter";


                column(NewPagePerGroupNo; NewPagePerGroupNo)
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
                column(ToDate; ToDate)
                {
                }
                column(EndingBalanceToPrint; EndingBalanceToPrint)
                {
                }
                column(VendLedgerEntry2_FiND_; VendLedgerEntry2.FINDFIRST)
                {
                }
                column(FromDateToPrint; FromDateToPrint)
                {
                }
                column(BalanceToPrint; BalanceToPrint)
                {
                }
                column(TotalVendors; TotalVendors)
                {
                }
                column(TotalEntries; TotalEntries)
                {
                }
                column(DebitTotal; DebitTotal)
                {
                }
                column(CreditTotal; CreditTotal)
                {
                }
                column(BalanceTotal; BalanceTotal)
                {
                }
                column(Vendor_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
                {
                }
                column(Vendor_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
                {
                }
                dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
                {
                    DataItemLink = "Vendor No." = FIELD("No."),
                                   "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                   "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                    DataItemTableView = SORTING("Vendor No.", "Currency Code", "Posting Date");
                    RequestFilterFields = "Document Type", Open;
                    column(Vendor_Ledger_Entry__Posting_Date_; "Posting Date")
                    {
                    }
                    column(Vendor_Ledger_Entry__Document_Type_; "Document Type")
                    {
                    }
                    column(DocNo; DocNo)
                    {
                    }
                    column(Vendor_Ledger_Entry_Description; Description)
                    {
                    }
                    column(AmountToPrint; AmountToPrint)
                    {
                    }
                    column(AmountToPrint_Control63; -AmountToPrint)
                    {
                    }
                    column(BalanceToPrint_Control64; BalanceToPrint)
                    {
                    }
                    column(Vendor_Ledger_Entry_Open; FORMAT(Open))
                    {
                    }
                    column(Vendor_Ledger_Entry__Currency_Code_; "Currency Code")
                    {
                    }
                    column(Vendor_Ledger_Entry_Amount; Amount)
                    {
                    }
                    column(ToDate_Control91; ToDate)
                    {
                    }
                    column(Ending_Balance_for_____Vendor__No__; 'Ending Balance for ' + Vendor."No.")
                    {
                    }
                    column(TotalDebits; TotalDebits)
                    {
                    }
                    column(TotalCredits; TotalCredits)
                    {
                    }
                    column(BalanceToPrint_Control95; BalanceToPrint)
                    {
                    }
                    column(Vendor_TABLECAPTION_____Total_for_____Vendor__No__; Vendor.TABLECAPTION + ' Total for ' + Vendor."No.")
                    {
                    }
                    column(TotalDebits_Control97; TotalDebits)
                    {
                    }
                    column(TotalCredits_Control98; TotalCredits)
                    {
                    }
                    column(BalanceToPrint_Control99; BalanceToPrint)
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
                    dataitem(OtherInfo; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));
                        column(Vendor_Ledger_Entry___Entry_No__; "Vendor Ledger Entry"."Entry No.")
                        {
                        }
                        column(Vendor_Ledger_Entry___Remaining_Amount_; "Vendor Ledger Entry"."Remaining Amount")
                        {
                        }
                        column(Vendor_Ledger_Entry___Original_Pmt__Disc__Possible_; "Vendor Ledger Entry"."Original Pmt. Disc. Possible")
                        {
                        }
                        column(Vendor_Ledger_Entry___Pmt__Discount_Date_; "Vendor Ledger Entry"."Pmt. Discount Date")
                        {
                        }
                        column(DueDateToPrint; DueDateToPrint)
                        {
                        }
                        column(DocNo_Control55; DocNo)
                        {
                        }
                        column(FORMAT_TempAppliedVendLedgEntry__Document_Type__; TempAppliedVendLedgEntry."Document Type")
                        {
                        }
                        column(TempAppliedVendLedgEntry__Entry_No__; TempAppliedVendLedgEntry."Entry No.")
                        {
                        }
                        column(Vendor_Ledger_Entry__Open; "Vendor Ledger Entry".Open)
                        {
                        }
                        column(Closed_by_Entry_No; "Vendor Ledger Entry"."Closed by Entry No.")
                        {
                        }
                        column(VendorClosedbyEntryNo; VendorClosedbyEntryNo)
                        {
                        }
                        column(BalanceToPrintTemp; BalanceToPrintTemp)
                        {
                        }
                        column(DocNoTemp; DocNoTemp)
                        {
                        }
                        column(OtherInfo_Number; Number)
                        {
                        }
                        column(Apply_ToCaption; Apply_ToCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            IF TempAppliedVendLedgEntry.FIND('-') THEN BEGIN
                                IF UseExternalDocNo THEN
                                    DocNo := TempAppliedVendLedgEntry."External Document No."
                                ELSE
                                    DocNo := TempAppliedVendLedgEntry."Document No.";
                            END ELSE BEGIN
                                DocNo := '';
                                CLEAR(TempAppliedVendLedgEntry);
                            END;

                            IF "Vendor Ledger Entry"."Document Type" <> "Vendor Ledger Entry"."Document Type"::Payment THEN
                                DueDateToPrint := "Vendor Ledger Entry"."Due Date"
                            ELSE
                                DueDateToPrint := 0D;

                            IF "Vendor Ledger Entry"."Pmt. Discount Date" < ToDate THEN
                                "Vendor Ledger Entry"."Original Pmt. Disc. Possible" := 0;

                            IF "Vendor Ledger Entry"."Original Pmt. Disc. Possible" = 0 THEN
                                "Vendor Ledger Entry"."Pmt. Discount Date" := 0D;

                            VendorClosedbyEntryNo := "Vendor Ledger Entry"."Closed by Entry No."
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF NOT AdditionalInformation THEN
                                CurrReport.BREAK;
                        end;
                    }
                    dataitem(AppliedEntries; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        column(DocNo_Control81; DocNo)
                        {
                        }
                        column(FORMAT_TempAppliedVendLedgEntry__Document_Type___Control84; FORMAT(TempAppliedVendLedgEntry."Document Type"))
                        {
                        }
                        column(TempAppliedVendLedgEntry__Entry_No___Control75; TempAppliedVendLedgEntry."Entry No.")
                        {
                        }
                        column(AppliedEntries_Number; Number)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            TempAppliedVendLedgEntry.NEXT;
                            IF UseExternalDocNo THEN
                                DocNo := TempAppliedVendLedgEntry."External Document No."
                            ELSE
                                DocNo := TempAppliedVendLedgEntry."Document No.";
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF NOT AdditionalInformation THEN
                                CurrReport.BREAK;
                            SETRANGE(Number, 2, TempAppliedVendLedgEntry.COUNT);
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF NOT PrintAmountsInLocal THEN
                            AmountToPrint := "Amount (LCY)"
                        ELSE
                            IF "Currency Code" = Currency.Code THEN
                                AmountToPrint := Amount
                            ELSE
                                AmountToPrint :=
                                  ROUND(
                                    CurrExchRate.ExchangeAmtFCYToFCY(
                                      ToDate,
                                      "Currency Code",
                                      Currency.Code,
                                      Amount),
                                    Currency."Amount Rounding Precision");

                        IF Amount > 0 THEN BEGIN
                            TotalDebits := TotalDebits + AmountToPrint;
                            DebitTotal := DebitTotal + "Amount (LCY)";
                        END
                        ELSE BEGIN
                            TotalCredits := TotalCredits - AmountToPrint;
                            CreditTotal := CreditTotal - "Amount (LCY)";
                        END;
                        BalanceToPrintTemp := BalanceToPrint;

                        BalanceToPrint := BalanceToPrint - AmountToPrint;

                        TotalEntries := TotalEntries + 1;
                        BalanceTotal := BalanceTotal - "Amount (LCY)";

                        IF UseExternalDocNo THEN
                            DocNo := "External Document No."
                        ELSE
                            DocNo := "Document No.";

                        DocNoTemp := DocNo;

                        //PPDA.1.0 Start
                        OnBeforeGetAppliedVendEntries(TempAppliedVendLedgEntry, "Vendor Ledger Entry", FALSE, AdditionalInformation);//PPDA.1.0 Added
                        // IF AdditionalInformation THEN //Commented
                        //     EntryAppMgt.GetAppliedVendEntries(TempAppliedVendLedgEntry, "Vendor Ledger Entry", FALSE);//Commented
                        //PPDA.1.0 End
                        IF VendorNoTemp <> "Vendor No." THEN BEGIN
                            VendorNoTemp := "Vendor No.";
                            IF FilterString2 <> '' THEN
                                TotalVendors := TotalVendors + 1;
                        END;
                    end;

                    trigger OnPreDataItem()
                    begin
                        TotalDebits := 0;
                        TotalCredits := 0;
                        SETRANGE("Posting Date", FromDate, ToDate);
                        SETRANGE("Date Filter", FromDate, ToDate);

                        //ProjectPro - start
                        IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN
                            SETRANGE("NS_Retention Ledger Code", NS_PurchSetup."NS_Normal Vendor Ledger No.");
                        //ProjectPro - end

                        IF AdditionalInformation THEN
                            SETAUTOCALCFIELDS(Amount, "Amount (LCY)", "Remaining Amount")
                        ELSE
                            SETAUTOCALCFIELDS(Amount, "Amount (LCY)");
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    IF FromDate <> 0D THEN
                        FromDateToPrint := FromDate - 1
                    ELSE
                        FromDateToPrint := 0D;

                    IF PrintAmountsInLocal THEN
                        IF Currency.READPERMISSION THEN BEGIN
                            TempCurrency.DELETEALL;

                            WITH VendLedgerEntry2 DO BEGIN
                                RESET;
                                SETCURRENTKEY("Vendor No.", "Currency Code");
                                SETRANGE("Vendor No.", Vendor."No.");
                                SETFILTER("Posting Date", '%1..%2', FromDate, ToDate);
                                WHILE FINDFIRST DO BEGIN
                                    TempCurrency.INIT;
                                    TempCurrency.Code := "Currency Code";
                                    TempCurrency.INSERT;
                                    SETFILTER("Currency Code", '>%1', "Currency Code");
                                END;
                            END;
                            GetCurrencyRecord(Currency, "Currency Code");
                        END;

                    /* If Vendor Ledger Filters are being used, we no longer attempt to keep a
                      running balance, and instead just keep a total of selected entries.
                      Otherwise, we need to get beginning balances to keep running balances.  */

                    IF FilterString2 <> '' THEN BEGIN
                        BalanceToPrint := 0;
                        EndingBalanceToPrint := 0;
                    END ELSE BEGIN
                        SETRANGE("Date Filter", 0D, ToDate);
                        IF PrintAmountsInLocal THEN BEGIN
                            EndingBalanceToPrint := 0;
                            IF TempCurrency.FIND('-') THEN
                                REPEAT
                                    SETRANGE("Currency Filter", TempCurrency.Code);
                                    CALCFIELDS("Net Change");
                                    "Net Change" := CurrExchRate.ExchangeAmtFCYToFCY(
                                        ToDate,
                                        TempCurrency.Code,
                                        Currency.Code,
                                        "Net Change");
                                    EndingBalanceToPrint := EndingBalanceToPrint + "Net Change";
                                UNTIL TempCurrency.NEXT = 0;
                            SETRANGE("Currency Filter");
                            EndingBalanceToPrint := ROUND(EndingBalanceToPrint, Currency."Amount Rounding Precision");
                        END ELSE BEGIN
                            CALCFIELDS("Net Change (LCY)");
                            EndingBalanceToPrint := "Net Change (LCY)";
                        END;

                        SETRANGE("Date Filter", 0D, FromDateToPrint);
                        CALCFIELDS("Net Change (LCY)");
                        IF PrintAmountsInLocal THEN BEGIN
                            BalanceToPrint := 0;
                            IF TempCurrency.FIND('-') THEN
                                REPEAT
                                    SETRANGE("Currency Filter", TempCurrency.Code);
                                    CALCFIELDS("Net Change");
                                    "Net Change" := CurrExchRate.ExchangeAmtFCYToFCY(
                                        ToDate,
                                        TempCurrency.Code,
                                        Currency.Code,
                                        "Net Change");
                                    BalanceToPrint := BalanceToPrint + "Net Change";
                                UNTIL TempCurrency.NEXT = 0;
                            SETRANGE("Currency Filter");
                            BalanceToPrint := ROUND(BalanceToPrint, Currency."Amount Rounding Precision");
                        END ELSE
                            BalanceToPrint := "Net Change (LCY)";
                    END;

                    IF FilterString2 = '' THEN
                        IF AllHavingBalance AND
                           (BalanceToPrint = 0) AND
                           (EndingBalanceToPrint = 0)
                        THEN
                            CurrReport.SKIP;

                    IF FilterString2 = '' THEN BEGIN
                        TotalVendors := TotalVendors + 1;  // count if there are no ledger filters
                        VendLedgerEntry2.RESET;
                        VendLedgerEntry2.SETCURRENTKEY("Vendor No.", "Posting Date");
                        VendLedgerEntry2.SETRANGE("Vendor No.", "No.");
                        VendLedgerEntry2.SETRANGE("Posting Date", FromDate, ToDate);
                        BalanceTotal := BalanceTotal + "Net Change (LCY)"; // report total will be in $
                    END;

                    IF OnlyOnePerPage THEN
                        NewPagePerGroupNo += 1;

                end;

                trigger OnPreDataItem()
                begin
                    IF DateFilter <> '' THEN BEGIN
                        FromDate := GETRANGEMIN("Date Filter");
                        ToDate := GETRANGEMAX("Date Filter");
                    END ELSE BEGIN
                        FromDate := 0D;
                        ToDate := WORKDATE;
                        SETRANGE("Date Filter", FromDate, ToDate);
                    END;
                end;
            }
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
                    field(PrintAmountsInVendorCurrency; PrintAmountsInLocal)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Print Amounts in Vendor''s Currency';
                        MultiLine = true;
                        ToolTip = 'Specifies if amounts are printed in the vendor''s currency. Clear the check box to print all amounts in US dollars.';
                    }
                    field(OnlyOnePerPage; OnlyOnePerPage)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Page per Account';
                        ToolTip = 'Specifies if you want to print each account on a separate page. Each account will begin at the top of the following page. Otherwise, each account will follow the previous account on the current page.';
                    }
                    field(AccWithBalancesOnly; AllHavingBalance)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Acc. with Balances Only';
                        ToolTip = 'Specifies that you want to include all accounts that have a balance other than zero, even if there has been no activity in the period. This option cannot be used if you are also entering Customer Ledger Entry Filters such as the Open filter.';
                    }
                    group("Print Additional Details")
                    {
                        Caption = 'Print Additional Details';
                        field(AdditionalInformation; AdditionalInformation)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = '   (Terms, Applications, etc.)';
                        }
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
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInformation.GET;
        GLSetup.GET;
        //ProjectPro - start
        NS_PurchSetup.GET;
        //ProjectPro - end
        FilterString := Vendor.GETFILTERS;
        FilterString2 := "Vendor Ledger Entry".GETFILTERS;
        DateFilter := Vendor.GETFILTER("Date Filter");
        IF (FilterString2 <> '') AND AllHavingBalance THEN
            ERROR(Text000 + ' ' + Text001);

        //CurrReport.NEWPAGEPERRECORD := OnlyOnePerPage;
    end;

    var
        VendLedgerEntry2: Record "Vendor Ledger Entry";
        TempAppliedVendLedgEntry: Record "Vendor Ledger Entry" temporary;
        CompanyInformation: Record "Company Information";
        Currency: Record Currency;
        TempCurrency: Record Currency temporary;
        CurrExchRate: Record "Currency Exchange Rate";
        GLSetup: Record "General Ledger Setup";
        // EntryAppMgt: Codeunit "Entry Application Management";//PPDA.1.0 Commeneted
        FilterString: Text;
        FilterString2: Text;
        DateFilter: Text;
        PrintAmountsInLocal: Boolean;
        AllHavingBalance: Boolean;
        OnlyOnePerPage: Boolean;
        AdditionalInformation: Boolean;
        AmountToPrint: Decimal;
        TotalDebits: Decimal;
        TotalCredits: Decimal;
        BalanceToPrint: Decimal;
        EndingBalanceToPrint: Decimal;
        DebitTotal: Decimal;
        CreditTotal: Decimal;
        BalanceTotal: Decimal;
        FromDate: Date;
        ToDate: Date;
        FromDateToPrint: Date;
        DueDateToPrint: Date;
        TotalVendors: Integer;
        TotalEntries: Integer;
        UseExternalDocNo: Boolean;
        DocNo: Code[50];
        Text000: Label 'Do not select Accounts with Balances Only if you';
        Text001: Label 'are also setting Vendor Ledger Entry Filters.';
        Text003: Label 'Amounts are in the vendor''s local currency (report totals are in %1).';
        Text004: Label 'Amounts are in %1';
        Text005: Label 'Report Totals (%1)';
        NewPagePerGroupNo: Integer;
        VendorClosedbyEntryNo: Integer;
        BalanceToPrintTemp: Decimal;
        DocNoTemp: Code[50];
        VendorNoTemp: Code[20];
        Vendor_Account_DetailCaptionLbl: Label 'Vendor Account Detail';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Vendors_without_balances_are_not_included_CaptionLbl: Label 'Vendors without balances are not included.';
        Vendor__No__CaptionLbl: Label 'Vendor';
        DocumentCaptionLbl: Label 'Document';
        Net_ChangeCaptionLbl: Label 'Net Change';
        BalanceToPrint_Control64CaptionLbl: Label 'Running Balance';
        Vendor_Ledger_Entry__Document_Type_CaptionLbl: Label 'Type';
        DebitsCaptionLbl: Label 'Debits';
        CreditsCaptionLbl: Label 'Credits';
        DocNoCaptionLbl: Label 'Number';
        Vendor_Ledger_Entry_AmountCaptionLbl: Label 'Transaction Amount';
        Vendor_Ledger_Entry__Currency_Code_CaptionLbl: Label 'Transaction Currency';
        Vendor_Ledger_Entry_OpenCaptionLbl: Label 'Open';
        Phone_CaptionLbl: Label 'Phone:';
        Contact_CaptionLbl: Label 'Contact:';
        Ending_Balance__no_activity_CaptionLbl: Label 'Ending Balance (no activity)';
        Beginning_BalanceCaptionLbl: Label 'Beginning Balance';
        VendorsCaptionLbl: Label 'Vendors';
        EntriesCaptionLbl: Label 'Entries';
        Vendor_Ledger_Entry___Remaining_Amount_CaptionLbl: Label 'Remaining Amount';
        Vendor_Ledger_Entry___Original_Pmt__Disc__Possible_CaptionLbl: Label 'Pmt. Disc. Possible';
        Vendor_Ledger_Entry___Pmt__Discount_Date_CaptionLbl: Label 'Discount Date';
        Due_DateCaptionLbl: Label 'Due Date';
        Apply_ToCaptionLbl: Label 'Apply To';
        TempAppliedVendLedgEntry__Entry_No___Control75CaptionLbl: Label 'Entry No.';
        FORMAT_TempAppliedVendLedgEntry__Document_Type__CaptionLbl: Label 'Type';
        DocNo_Control55CaptionLbl: Label 'Number';
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
                EXIT('101,1,' + Text004);

            GetCurrencyRecord(Currency, CurrencyCode);
            EXIT('101,4,' + STRSUBSTNO(Text004, Currency.Description));
        END;
        EXIT('');
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetAppliedVendEntries(Var TempVendAppliedEntries: Record "Vendor Ledger Entry"; Var VendLedgerEntry: Record "Vendor Ledger Entry"; IsBool: Boolean; AdditionalInformation: Boolean)
    begin
    end;
}

