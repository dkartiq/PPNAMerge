report 14021185 "NS_Purch Order Status by Job"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-84.SK.1.0 Added report to search
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSPurch Order Status by Job.rdl';
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Purch Order Status by Job';
    ApplicationArea = all;

    dataset
    {
        dataitem(Job; Job)
        {
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
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
            column(OnlyOnePerPage; OnlyOnePerPage)
            {
            }
            column(For_delivery_in_the_period_____PeriodText______; 'For delivery in the period ' + PeriodText + '.')
            {
            }
            column(PeriodText; PeriodText)
            {
            }
            column(PrintAmountsInLocal; PrintAmountsInLocal)
            {
            }
            column(Vendor_TABLECAPTION__________FilterString; Vendor.TABLECAPTION + ': ' + FilterString)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Control11Caption; CAPTIONCLASSTRANSLATE('101,1,' + Text004Lbl))
            {
            }
            column(FilterString; FilterString)
            {
            }
            column(Job_No__; "No.")
            {
            }
            column(JobDesc; "No." + ' - ' + Description)
            {
            }
            dataitem(Vendor; Vendor)
            {
                PrintOnlyIfDetail = true;
                RequestFilterFields = "No.", "Search Name", Priority;
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
                column(OutstandingExclTax__; "OutstandingExclTax$")
                {
                }
                column(Vendor_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
                {
                }
                column(Vendor_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
                {
                }
                column(Purchase_Order_Status_By_JobCaption; Purchase_Order_Status_By_JobCaptionLbl)
                {
                }
                column(JobCaption; JobCaptionLbl)
                {
                }
                column(VendorCaption; VendorCaptionLbl)
                {
                }
                column(PurchaseHeader__Order_Date_Caption; PurchaseHeader__Order_Date_CaptionLbl)
                {
                }
                column(QuantityCaption; QuantityCaptionLbl)
                {
                }
                column(Purchase_Line__Document_No__Caption; Purchase_Line__Document_No__CaptionLbl)
                {
                }
                column(SubcontractLbl; SubcontractCaptionLbl)
                {
                }
                column(Expected_Type_ItemCaption; Expected_Type_ItemCaptionLbl)
                {
                }
                column(Purchase_Line_DescriptionCaption; "Purchase Line".FIELDCAPTION(Description))
                {
                }
                column(Purchase_Line_QuantityCaption; Purchase_Line_QuantityCaptionLbl)
                {
                }
                column(Purchase_Line__Outstanding_Quantity_Caption; Purchase_Line__Outstanding_Quantity_CaptionLbl)
                {
                }
                column(Purchase_Line__Unit_Cost_Caption; "Purchase Line".FIELDCAPTION("Unit Cost"))
                {
                }
                column(OutstandExclInvDisc_Control45Caption; OutstandExclInvDisc_Control45CaptionLbl)
                {
                }
                column(Purchase_Line_TypeCaption; "Purchase Line".FIELDCAPTION(Type))
                {
                }
                column(Purchase_Line__No__Caption; Purchase_Line__No__CaptionLbl)
                {
                }
                column(BackOrderQuantityCaption; BackOrderQuantityCaptionLbl)
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
                column(Control32Caption; CAPTIONCLASSTRANSLATE('101,0,' + Text005Lbl))
                {
                }
                dataitem("Purchase Line"; "Purchase Line")
                {
                    DataItemLink = "Buy-from Vendor No." = FIELD("No."), "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                    DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE("Document Type" = CONST(Order), "Outstanding Quantity" = FILTER(<> 0));
                    RequestFilterFields = "Expected Receipt Date";
                    column(Purchase_Line__Document_No__; "Document No.")
                    {
                    }
                    column(PurchaseHeader__Order_Date_; PurchaseHeader."Order Date")
                    {
                    }
                    column(OutstandExclInvDisc; OutstandExclInvDisc)
                    {
                    }
                    column(Purchase_Line__Expected_Receipt_Date_; "Expected Receipt Date")
                    {
                    }
                    column(Subcontract_No__; "NS_Subcontract No.")
                    {
                    }
                    column(Purchase_Line_Type; Type)
                    {
                    }
                    column(Purchase_Line__No__; "No.")
                    {
                    }
                    column(Purchase_Line_Description; Description)
                    {
                    }
                    column(Purchase_Line_Quantity; Quantity)
                    {
                    }
                    column(Purchase_Line__Outstanding_Quantity_; "Outstanding Quantity")
                    {
                    }
                    column(BackOrderQuantity; BackOrderQuantity)
                    {
                    }
                    column(Purchase_Line__Unit_Cost_; "Unit Cost")
                    {
                    }
                    column(OutstandExclInvDisc_Control45; OutstandExclInvDisc)
                    {
                    }
                    column(OutstandExclInvDisc_Control46; OutstandExclInvDisc)
                    {
                    }
                    column(OutstandingExclTax___OutstandExclInvDisc; OutstandingExclTax - OutstandExclInvDisc)
                    {
                    }
                    column(OutstandExclInvDisc_Control1020004; OutstandExclInvDisc)
                    {
                    }
                    column(Vendor__No___Control50; Vendor."No.")
                    {
                    }
                    column(OutstandingExclTax; OutstandingExclTax)
                    {
                    }
                    column(Purchase_Line_Document_Type; "Document Type")
                    {
                    }
                    column(Purchase_Line_Line_No_; "Line No.")
                    {
                    }
                    column(Purchase_Line_Buy_from_Vendor_No_; "Buy-from Vendor No.")
                    {
                    }
                    column(Purchase_Line_Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code")
                    {
                    }
                    column(Purchase_Line_Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code")
                    {
                    }
                    column(TransferredCaption; TransferredCaptionLbl)
                    {
                    }
                    column(TransferredCaption_Control47; TransferredCaption_Control47Lbl)
                    {
                    }
                    column(Line_and_Invoice_DiscountsCaption; Line_and_Invoice_DiscountsCaptionLbl)
                    {
                    }
                    column(TotalCaption; TotalCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord();
                    begin
                        if "Job No." <> Job."No." then
                            CurrReport.SKIP;

                        if "Expected Receipt Date" <= WORKDATE then
                            BackOrderQuantity := "Outstanding Quantity"
                        else
                            BackOrderQuantity := 0;
                        OutstandingExclTax := ROUND("Outstanding Quantity" * "Line Amount" / Quantity);
                        OutstandExclInvDisc := ROUND("Outstanding Quantity" * "Unit Cost");

                        if "Currency Code" = '' then begin
                            "OutstandingExclTax$" := OutstandingExclTax;
                            "OutstandExclInvDisc$" := OutstandExclInvDisc;
                            "UnitCost($)" := "Unit Cost";
                        end else begin
                            "OutstandingExclTax$" :=
                              ROUND(
                                CurrExchRate.ExchangeAmtFCYToFCY(
                                  WORKDATE,
                                  "Currency Code",
                                  '',
                                  OutstandingExclTax));
                            "OutstandExclInvDisc$" :=
                              ROUND(
                                CurrExchRate.ExchangeAmtFCYToFCY(
                                  WORKDATE,
                                  "Currency Code",
                                  '',
                                  OutstandExclInvDisc));
                            "UnitCost($)" :=
                              ROUND(
                                CurrExchRate.ExchangeAmtFCYToFCY(
                                  WORKDATE,
                                  "Currency Code",
                                  '',
                                  "Unit Cost"),
                                0.00001);
                        end;

                        if PrintAmountsInLocal then begin
                            if Vendor."Currency Code" = '' then begin
                                OutstandingExclTax := "OutstandingExclTax$";
                                OutstandExclInvDisc := "OutstandExclInvDisc$";
                                "Unit Cost" := "UnitCost($)";
                            end else
                                if Vendor."Currency Code" <> "Currency Code" then begin
                                    OutstandingExclTax :=
                                      ROUND(
                                        CurrExchRate.ExchangeAmtFCYToFCY(
                                          WORKDATE,
                                          "Currency Code",
                                          Vendor."Currency Code",
                                          OutstandingExclTax),
                                        Currency."Amount Rounding Precision");
                                    OutstandExclInvDisc :=
                                      ROUND(
                                        CurrExchRate.ExchangeAmtFCYToFCY(
                                          WORKDATE,
                                          "Currency Code",
                                          Vendor."Currency Code",
                                          OutstandExclInvDisc),
                                        Currency."Amount Rounding Precision");
                                    "Unit Cost" :=
                                      ROUND(
                                        CurrExchRate.ExchangeAmtFCYToFCY(
                                          WORKDATE,
                                          "Currency Code",
                                          Vendor."Currency Code",
                                          "Unit Cost"),
                                        Currency."Unit-Amount Rounding Precision");
                                end;
                        end else begin
                            OutstandingExclTax := "OutstandingExclTax$";
                            OutstandExclInvDisc := "OutstandExclInvDisc$";
                            "Unit Cost" := "UnitCost($)";
                        end;
                        PurchaseHeader.GET("Purchase Line"."Document Type", "Purchase Line"."Document No.");
                    end;

                    trigger OnPreDataItem();
                    begin
                        CurrReport.CREATETOTALS(OutstandExclInvDisc, OutstandingExclTax,
                          "OutstandExclInvDisc$", "OutstandingExclTax$");
                    end;
                }

                trigger OnPreDataItem();
                begin
                    CurrReport.CREATETOTALS("OutstandingExclTax$");
                    //CurrReport.NEWPAGEPERRECORD := OnlyOnePerPage;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                PurchaseLine.RESET;
                PurchaseLine.SETCURRENTKEY("Job No.");
                PurchaseLine.SETRANGE("Job No.", "No.");
                if Vendor.GETFILTER("No.") > '' then
                    PurchaseLine.SETFILTER("Buy-from Vendor No.", Vendor.GETFILTER("No."));
                if PurchaseLine.COUNT = 0 then
                    CurrReport.SKIP;
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
                    field(PrintAmountsInLocal; PrintAmountsInLocal)
                    {
                        Caption = 'Print Amounts in Vendor''s Currency';

                        ToolTip = 'Print Amounts in Vendor''s Currency';
                        MultiLine = true;
                        ApplicationArea = All;
                    }
                    field(OnlyOnePerPage; OnlyOnePerPage)
                    {
                        Caption = 'New Page per Job';

                        ToolTip = 'New Page per Job';
                        ApplicationArea = All;
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

    trigger OnPreReport();
    begin
        CompanyInformation.GET;
        GLSetup.GET;
        FilterString := Vendor.GETFILTERS;
        PeriodText := "Purchase Line".GETFILTER("Expected Receipt Date");
    end;

    var
        PurchaseHeader: Record "Purchase Header";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        GLSetup: Record "General Ledger Setup";
        PurchaseLine: Record "Purchase Line";
        FilterString: Text[250];
        PeriodText: Text[100];
        OutstandExclInvDisc: Decimal;
        "OutstandExclInvDisc$": Decimal;
        OutstandingExclTax: Decimal;
        "OutstandingExclTax$": Decimal;
        BackOrderQuantity: Decimal;
        "UnitCost($)": Decimal;
        PrintAmountsInLocal: Boolean;
        OnlyOnePerPage: Boolean;
        CompanyInformation: Record "Company Information";
        Text001Lbl: Label 'Currency: %1';
        Text004Lbl: Label 'Amounts are in the vendor''s local currency (report totals are in %1).';
        Text005Lbl: Label 'Report Totals (%1)';
        Purchase_Order_Status_By_JobCaptionLbl: Label 'Purchase Order Status By Job';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        JobCaptionLbl: Label 'Job';
        VendorCaptionLbl: Label 'Vendor';
        PurchaseHeader__Order_Date_CaptionLbl: Label 'Order Date';
        QuantityCaptionLbl: Label 'Quantity';
        Purchase_Line__Document_No__CaptionLbl: Label 'PO Number';
        SubcontractCaptionLbl: Label 'Subcontract';
        Expected_Type_ItemCaptionLbl: Label 'Expected Type Item';
        Purchase_Line_QuantityCaptionLbl: Label 'Ordered';
        Purchase_Line__Outstanding_Quantity_CaptionLbl: Label 'Remaining';
        OutstandExclInvDisc_Control45CaptionLbl: Label 'Remaining Amount';
        Purchase_Line__No__CaptionLbl: Label 'Item';
        BackOrderQuantityCaptionLbl: Label 'Back';
        Phone_CaptionLbl: Label 'Phone:';
        Contact_CaptionLbl: Label 'Contact:';
        TransferredCaptionLbl: Label 'Transferred';
        TransferredCaption_Control47Lbl: Label 'Transferred';
        Line_and_Invoice_DiscountsCaptionLbl: Label 'Line and Invoice Discounts';
        TotalCaptionLbl: Label 'Total';

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
                exit('101,1,' + Text001Lbl);

            GetCurrencyRecord(Currency, CurrencyCode);
            exit('101,4,' + STRSUBSTNO(Text001Lbl, Currency.Description));
            ;
        end;
        exit('');
    end;
}

