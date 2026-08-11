report 14021217 "NS_Open Vendor Entries"
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
    RDLCLayout = './Layouts/NSOpen Vendor Entries.rdl';

    ApplicationArea = Basic, Suite;
    Caption = 'Open Vendor Entries';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Vendor Posting Group", "Currency Code", "Payment Terms Code";
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
            column(Subtitle; Subtitle)
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
            column(FilterString2; FilterString2)
            {
            }
            column(Document_Number_is______Vendor_Ledger_Entry__FIELDCAPTION__External_Document_No___; 'Document Number is ' + "Vendor Ledger Entry".FIELDCAPTION("External Document No."))
            {
            }
            column(Vendor_TABLECAPTION__________FilterString; Vendor.TABLECAPTION + ': ' + FilterString)
            {
            }
            column(Vendor_Ledger_Entry__TABLECAPTION__________FilterString2; "Vendor Ledger Entry".TABLECAPTION + ': ' + FilterString2)
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
            column(VendorBlockedText; VendorBlockedText)
            {
            }
            column(Vendor_Ledger_Entry___Remaining_Amt___LCY__; -"Vendor Ledger Entry"."Remaining Amt. (LCY)")
            {
            }
            column(Vendor_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(Vendor_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            column(Vendor_Currency_Filter; "Currency Filter")
            {
            }
            column(Vendor_Date_Filter; "Date Filter")
            {
            }
            column(Open_Vendor_EntriesCaption; Open_Vendor_EntriesCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Control9Caption; CAPTIONCLASSTRANSLATE('101,1,' + Text004))
            {
            }
            column(Vendor__No__Caption; Vendor__No__CaptionLbl)
            {
            }
            column(DocumentCaption; DocumentCaptionLbl)
            {
            }
            column(DateCaption; DateCaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry__Document_Type_Caption; Vendor_Ledger_Entry__Document_Type_CaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry_DescriptionCaption; "Vendor Ledger Entry".FIELDCAPTION(Description))
            {
            }
            column(Vendor_Ledger_Entry__Due_Date_Caption; "Vendor Ledger Entry".FIELDCAPTION("Due Date"))
            {
            }
            column(RemainAmountToPrintCaption; RemainAmountToPrintCaptionLbl)
            {
            }
            column(DocNoCaption; DocNoCaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry__On_Hold_Caption; "Vendor Ledger Entry".FIELDCAPTION("On Hold"))
            {
            }
            column(OverDueDaysCaption; OverDueDaysCaptionLbl)
            {
            }
            column(Remaining_Amount_Caption; Remaining_Amount_CaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry__Currency_Code_Caption; "Vendor Ledger Entry".FIELDCAPTION("Currency Code"))
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
            column(Control31Caption; CAPTIONCLASSTRANSLATE('101,0,' + Text005))
            {
            }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No."),
                               "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                               "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                               "Currency Code" = FIELD("Currency Filter"),
                               "Posting Date" = FIELD("Date Filter");
                DataItemTableView = SORTING("Vendor No.", Open, Positive, "Due Date")
                                    WHERE(Open = CONST(true));
                RequestFilterFields = "Document Type", "On Hold";
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
                column(Vendor_Ledger_Entry__Due_Date_; "Due Date")
                {
                }
                column(RemainAmountToPrint; -RemainAmountToPrint)
                {
                }
                column(Vendor_Ledger_Entry__On_Hold_; "On Hold")
                {
                }
                column(OverDueDays; OverDueDays)
                {
                }
                column(Remaining_Amount_; -"Remaining Amount")
                {
                }
                column(Vendor_Ledger_Entry__Currency_Code_; "Currency Code")
                {
                }
                column(Vendor__No___Control40; Vendor."No.")
                {
                }
                column(RemainAmountToPrint_Control41; -RemainAmountToPrint)
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
                column(Vendor_Total_Amount_DueCaption; Vendor_Total_Amount_DueCaptionLbl)
                {
                }
                column(Control1020001Caption; CAPTIONCLASSTRANSLATE(GetCurrencyCaptionCode(Vendor."Currency Code")))
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CALCFIELDS("Remaining Amount", "Remaining Amt. (LCY)");
                    IF (ToDate > "Due Date") AND ("Remaining Amount" < 0) THEN
                        OverDueDays := ToDate - "Due Date"
                    ELSE
                        OverDueDays := 0;

                    IF PrintAmountsInLocal THEN BEGIN
                        IF "Currency Code" = Vendor."Currency Code" THEN
                            RemainAmountToPrint := "Remaining Amount"
                        ELSE
                            IF Vendor."Currency Code" = '' THEN
                                RemainAmountToPrint := "Remaining Amt. (LCY)"
                            ELSE
                                RemainAmountToPrint :=
                                  ROUND(
                                    CurrExchRate.ExchangeAmtFCYToFCY(
                                      DateToConvertCurrency,
                                      "Currency Code",
                                      Vendor."Currency Code",
                                      "Remaining Amount"),
                                    Currency."Amount Rounding Precision");
                    END ELSE
                        RemainAmountToPrint := "Remaining Amt. (LCY)";

                    IF UseExternalDocNo THEN
                        DocNo := "External Document No."
                    ELSE
                        DocNo := "Document No.";
                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CREATETOTALS("Remaining Amt. (LCY)", RemainAmountToPrint);
                    IF ToDate = 0D THEN
                        DateToConvertCurrency := WORKDATE
                    ELSE BEGIN
                        SETRANGE("Due Date", 0D, ToDate);
                        DateToConvertCurrency := ToDate;
                    END;
                    //ProjectPro - start
                    IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN
                        SETRANGE("NS_Retention Ledger Code", NS_PurchSetup."NS_Normal Vendor Ledger No.");
                    //ProjectPro - end
                end;
            }

            trigger OnAfterGetRecord()
            begin
                GetCurrencyRecord(Currency, "Currency Code");
                IF "Privacy Blocked" THEN
                    VendorBlockedText := PrivacyBlockedTxt
                ELSE
                    VendorBlockedText := '';
                IF Blocked <> Blocked::" " THEN
                    VendorBlockedText := STRSUBSTNO(Text001, Blocked)
                ELSE
                    VendorBlockedText := '';
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CREATETOTALS("Vendor Ledger Entry"."Remaining Amt. (LCY)");
                IF ToDate <> 0D THEN
                    Subtitle := Text000 + ' ' + FORMAT(ToDate, 0, 4) + ')';
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
                    field(EndingDate; ToDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ending Date';
                        ToolTip = 'Specifies the date to which the report or batch job processes information.';
                    }
                    field(PrintAmountsInVendorsCurrency; PrintAmountsInLocal)
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

        trigger OnOpenPage()
        begin
            IF ToDate = 0D THEN
                ToDate := WORKDATE;
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
        FilterString2 := "Vendor Ledger Entry".GETFILTERS;
    end;

    var
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        GLSetup: Record "General Ledger Setup";
        FilterString: Text;
        FilterString2: Text;
        VendorBlockedText: Text[80];
        Subtitle: Text[126];
        PrintAmountsInLocal: Boolean;
        DateToConvertCurrency: Date;
        ToDate: Date;
        OverDueDays: Integer;
        RemainAmountToPrint: Decimal;
        CompanyInformation: Record "Company Information";
        UseExternalDocNo: Boolean;
        DocNo: Code[50];
        Text000: Label '(Open Entries Due as of';
        Text001: Label '*** Vendor is Blocked for %1 processing ***';
        PrivacyBlockedTxt: Label '*** Vendor is Blocked for privacy ***.';
        Text003: Label 'Amount due is in %1';
        Text004: Label 'Amounts are in the vendor''s local currency (report totals are in %1).';
        Text005: Label 'Report Total Amount Due (%1)';
        Open_Vendor_EntriesCaptionLbl: Label 'Open Vendor Entries';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Vendor__No__CaptionLbl: Label 'Vendor';
        DocumentCaptionLbl: Label 'Document';
        DateCaptionLbl: Label 'Date';
        Vendor_Ledger_Entry__Document_Type_CaptionLbl: Label 'Type';
        RemainAmountToPrintCaptionLbl: Label 'Amount Due';
        DocNoCaptionLbl: Label 'Number';
        OverDueDaysCaptionLbl: Label 'Days Overdue';
        Remaining_Amount_CaptionLbl: Label 'Remaining Amount';
        Phone_CaptionLbl: Label 'Phone:';
        Contact_CaptionLbl: Label 'Contact:';
        Vendor_Total_Amount_DueCaptionLbl: Label 'Vendor Total Amount Due';
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
                EXIT('101,1,' + Text003);

            GetCurrencyRecord(Currency, CurrencyCode);
            EXIT('101,4,' + STRSUBSTNO(Text003, Currency.Description));
        END;
        EXIT('');
    end;
}

