report 14021231 "NS_Sales Invoice CTSI B4 Post"
{
    // version NAVNA13.01

    //PRJ-146.SK.1.0 - 11MAR2019 - Added "Less retention" and "Balance Due" field on report.
    //CTSI-42.AS.1.0 08May2020 
    //CTSI-42.AS.1.0 13May2020 : Changed Caption 
    //CTSI-42.AS.1.0 21MAY2020 Changed Revenue Category Description.
    //CTSI-82.MS.1.0 change length from 50 to Text
    //CTSI-42.AS.2.0 24JUNE2020 Done changes in layout & added code
    //CTSI-147.AS.1.0 14SEPT2020 Added code & done change in Layout
    //CTSI-148.AS.1.0 14SEPT2020 Created New Report By Saving 14021320 for Sale Invoice before post data 
    //CTSI-162.AS.1.0 29Sept2020 Done sorting
    //CTSI-175.AS.1.0 14OCT2020 Added Work description, Removed INvoice Discount, Commented code for that & done change in layout to add it
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSSales Invoice CTSI BeforePost.rdl';

    Caption = 'Sales Invoice - Rev. Cat. Summ.';//CTSI-42.AS.1.0 13May2020 : Changed Caption 

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Sell-to Customer No.", "Bill-to Customer No.", "Ship-to Code", "No. Printed";
            RequestFilterHeadingML = ENU = 'Sales Invoice',
                                     ESM = 'Factura venta',
                                     FRC = 'Facture vente',
                                     ENC = 'Sales Invoice';
            column(No_SalesInvHeader; "No.")
            {
            }
            column(Work_Description; Work_Description)
            {
                //CTSI-175.AS.1.0 14OCT2020
            }

            //CTSI-42.AS.2.0 24JUNE2020 - start
            column(jobrecno; jobrecno)
            {

            }
            column(jobrecdesc; jobrecdesc)
            {

            }
            //CTSI-42.AS.2.0 24JUNE2020 - end
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("NS_Job Revenue Category");//CTSI-42.AS.1.0
                dataitem(SalesLineComments; "Sales Comment Line")
                {
                    DataItemLink = "No." = FIELD("Document No."),
                                   "Document Line No." = FIELD("Line No.");
                    DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.")
                                        WHERE("Document Type" = CONST(Invoice));

                    trigger OnAfterGetRecord();
                    begin
                        WITH TempSalesInvoiceLine DO BEGIN
                            INIT;
                            "Document Type" := "Sales Header"."Document Type";//Doc Type added
                            "Document No." := "Sales Header"."No.";
                            "Line No." := HighestLineNo + 10;
                            HighestLineNo := "Line No.";
                        END;
                        IF STRLEN(Comment) <= MAXSTRLEN(TempSalesInvoiceLine.Description) THEN BEGIN
                            TempSalesInvoiceLine.Description := Comment;
                            TempSalesInvoiceLine."Description 2" := '';
                        END ELSE BEGIN
                            SpacePointer := MAXSTRLEN(TempSalesInvoiceLine.Description) + 1;
                            WHILE (SpacePointer > 1) AND (Comment[SpacePointer] <> ' ') DO
                                SpacePointer := SpacePointer - 1;
                            IF SpacePointer = 1 THEN
                                SpacePointer := MAXSTRLEN(TempSalesInvoiceLine.Description) + 1;
                            TempSalesInvoiceLine.Description := COPYSTR(Comment, 1, SpacePointer - 1);
                            TempSalesInvoiceLine."Description 2" :=
                              COPYSTR(COPYSTR(Comment, SpacePointer + 1), 1, MAXSTRLEN(TempSalesInvoiceLine."Description 2"));
                        END;
                        TempSalesInvoiceLine.INSERT;
                    end;
                }

                trigger OnAfterGetRecord();
                begin
                    TempSalesInvoiceLine := "Sales Line";
                    TempSalesInvoiceLine.INSERT;
                    TempSalesInvoiceLineAsm := "Sales Line";
                    TempSalesInvoiceLineAsm.INSERT;

                    HighestLineNo := "Line No.";
                end;

                trigger OnPreDataItem();
                begin
                    TempSalesInvoiceLine.RESET;
                    TempSalesInvoiceLine.DELETEALL;
                    TempSalesInvoiceLineAsm.RESET;
                    TempSalesInvoiceLineAsm.DELETEALL;
                end;
            }
            dataitem("Sales Comment Line"; "Sales Comment Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Type" = CONST(Invoice), "Document Line No." = CONST(0));
                column(DisplayAdditionalFeeNote; DisplayAdditionalFeeNote)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    WITH TempSalesInvoiceLine DO BEGIN
                        INIT;
                        "Document Type" := "Sales Header"."Document Type";//Doc Type added
                        "Document No." := "Sales Header"."No.";
                        "Line No." := HighestLineNo + 1000;
                        HighestLineNo := "Line No.";
                    END;
                    IF STRLEN(Comment) <= MAXSTRLEN(TempSalesInvoiceLine.Description) THEN BEGIN
                        TempSalesInvoiceLine.Description := Comment;
                        TempSalesInvoiceLine."Description 2" := '';
                    END ELSE BEGIN
                        SpacePointer := MAXSTRLEN(TempSalesInvoiceLine.Description) + 1;
                        WHILE (SpacePointer > 1) AND (Comment[SpacePointer] <> ' ') DO
                            SpacePointer := SpacePointer - 1;
                        IF SpacePointer = 1 THEN
                            SpacePointer := MAXSTRLEN(TempSalesInvoiceLine.Description) + 1;
                        TempSalesInvoiceLine.Description := COPYSTR(Comment, 1, SpacePointer - 1);
                        TempSalesInvoiceLine."Description 2" :=
                          COPYSTR(COPYSTR(Comment, SpacePointer + 1), 1, MAXSTRLEN(TempSalesInvoiceLine."Description 2"));
                    END;
                    TempSalesInvoiceLine.INSERT;
                end;

                trigger OnPreDataItem();
                begin
                    WITH TempSalesInvoiceLine DO BEGIN
                        INIT;
                        "Document Type" := "Sales Header"."Document Type";//Doc Type added
                        "Document No." := "Sales Header"."No.";
                        "Line No." := HighestLineNo + 1000;
                        HighestLineNo := "Line No.";
                    END;
                    TempSalesInvoiceLine.INSERT;
                end;
            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));
                    column(CompanyInformationPic; CompanyInformation.Picture)
                    {
                        //CTSI-147.AS.1.0 14SEPT2020
                    }
                    column(CompanyInformationPhone; CompanyInformation."Phone No.")
                    {
                        //CTSI-147.AS.1.0 14SEPT2020 
                    }
                    column(CompName; CompName)
                    {
                        //CTSI-147.AS.1.0 14SEPT2020 
                    }
                    column(CompAddress; CompAddress)
                    {
                        //CTSI-147.AS.1.0 14SEPT2020 
                    }
                    column(CompFinalAddrLine; CompFinalAddrLine)
                    {
                        //CTSI-147.AS.1.0 14SEPT2020 
                    }
                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInformationPicture; CompanyInfo3.Picture)
                    {
                    }
                    column(CompanyAddress1; CompanyAddress[1])
                    {
                    }
                    column(CompanyAddress2; CompanyAddress[2])
                    {
                    }
                    column(CompanyAddress3; CompanyAddress[3])
                    {
                    }
                    column(CompanyAddress4; CompanyAddress[4])
                    {
                    }
                    column(CompanyAddress5; CompanyAddress[5])
                    {
                    }
                    column(CompanyAddress6; CompanyAddress[6])
                    {
                    }
                    column(CopyTxt; CopyTxt)
                    {
                    }
                    column(BillToAddress1; BillToAddress[1])
                    {
                    }
                    column(BillToAddress2; BillToAddress[2])
                    {
                    }
                    column(BillToAddress3; BillToAddress[3])
                    {
                    }
                    column(BillToAddress4; BillToAddress[4])
                    {
                    }
                    column(BillToAddress5; BillToAddress[5])
                    {
                    }
                    column(BillToAddress6; BillToAddress[6])
                    {
                    }
                    column(BillToAddress7; BillToAddress[7])
                    {
                    }
                    column(ShipmentMethodDescription; ShipmentMethod.Description)
                    {
                    }
                    column(ShptDate_SalesInvHeader; "Sales Header"."Shipment Date")
                    {
                    }
                    column(DueDate_SalesInvHeader; "Sales Header"."Due Date")
                    {
                    }
                    column(PaymentTermsDescription; PaymentTerms.Description)
                    {
                    }
                    column(ShipToAddress1; ShipToAddress[1])
                    {
                    }
                    column(ShipToAddress2; ShipToAddress[2])
                    {
                    }
                    column(ShipToAddress3; ShipToAddress[3])
                    {
                    }
                    column(ShipToAddress4; ShipToAddress[4])
                    {
                    }
                    column(ShipToAddress5; ShipToAddress[5])
                    {
                    }
                    column(ShipToAddress6; ShipToAddress[6])
                    {
                    }
                    column(ShipToAddress7; ShipToAddress[7])
                    {
                    }
                    column(BilltoCustNo_SalesInvHeader; "Sales Header"."Bill-to Customer No.")
                    {
                    }
                    column(ExtDocNo_SalesInvHeader; "Sales Header"."External Document No.")
                    {
                    }
                    column(OrderDate_SalesInvHeader; "Sales Header"."Order Date")
                    {
                    }
                    column(OrderNo_SalesInvHeader; "Sales Header"."No.")
                    {
                    }
                    column(RetentionAmount; "Sales Header"."NS_Retention Amount")
                    {
                    }
                    column(LessRetentionCaption; LessRetentionCaption)
                    {
                    }
                    column(BalanceDueCaption; BalanceDueCaption)
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(DocumentDate_SalesInvHeader; "Sales Header"."Document Date")
                    {
                    }
                    column(CompanyAddress7; CompanyAddress[7])
                    {
                    }
                    column(CompanyAddress8; CompanyAddress[8])
                    {
                    }
                    column(BillToAddress8; BillToAddress[8])
                    {
                    }
                    column(ShipToAddress8; ShipToAddress[8])
                    {
                    }
                    column(TaxRegNo; TaxRegNo)
                    {
                    }
                    column(TaxRegLabel; TaxRegLabel)
                    {
                    }
                    column(DocumentText; DocumentText)
                    {
                    }
                    column(CopyNo; CopyNo)
                    {
                    }

                    //PPDA.1.0 Commented Start
                    // column(CustTaxIdentificationType; FORMAT(Cust."Tax Identification Type"))
                    // {
                    // }
                    //PPDA.1.0 Commented End
                    column(BillCaption; BillCaptionLbl)
                    {
                    }
                    column(ToCaption; ToCaptionLbl)
                    {
                    }
                    column(ShipViaCaption; ShipViaCaptionLbl)
                    {
                    }
                    column(ShipDateCaption; ShipDateCaptionLbl)
                    {
                    }
                    column(DueDateCaption; DueDateCaptionLbl)
                    {
                    }
                    column(TermsCaption; TermsCaptionLbl)
                    {
                    }
                    column(CustomerIDCaption; CustomerIDCaptionLbl)
                    {
                    }
                    column(PONumberCaption; PONumberCaptionLbl)
                    {
                    }
                    column(PODateCaption; PODateCaptionLbl)
                    {
                    }
                    column(OurOrderNoCaption; OurOrderNoCaptionLbl)
                    {
                    }
                    column(SalesPersonCaption; SalesPersonCaptionLbl)
                    {
                    }
                    column(ShipCaption; ShipCaptionLbl)
                    {
                    }
                    column(InvoiceNumberCaption; InvoiceNumberCaptionLbl)
                    {
                    }
                    column(InvoiceDateCaption; InvoiceDateCaptionLbl)
                    {
                    }
                    column(PageCaption; PageCaptionLbl)
                    {
                    }
                    column(TaxIdentTypeCaption; TaxIdentTypeCaptionLbl)
                    {
                    }
                    dataitem(SalesInvLine; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        column(AmountExclInvDisc; AmountExclInvDisc)
                        {
                        }
                        column(TempSalesInvoiceLineNo; TempSalesInvoiceLine."No.")
                        {
                        }
                        column(TempSalesInvoiceLineUOM; TempSalesInvoiceLine."Unit of Measure")
                        {
                        }
                        column(OrderedQuantity; OrderedQuantity)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(TempSalesInvoiceLineQty; TempSalesInvoiceLine.Quantity)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(UnitPriceToPrint; UnitPriceToPrint)
                        {
                            DecimalPlaces = 2 : 5;
                        }
                        column(LowDescriptionToPrint; LowDescriptionToPrint)
                        {
                        }
                        column(HighDescriptionToPrint; HighDescriptionToPrint)
                        {
                        }
                        column(TempSalesInvoiceLineDocNo; TempSalesInvoiceLine."Document No.")
                        {
                        }
                        column(TempSalesInvoiceLineLineNo; TempSalesInvoiceLine."Line No.")
                        {
                        }

                        column(TempSalesInvoiceLineJobRevCat; TempSalesInvoiceLine."NS_Job Revenue Category")
                        {
                            //CTSI-42.AS.1.0 08May2020
                        }
                        column(RevenueCat; RevenueCat)
                        {
                            //CTSI-42.AS.1.0 08May2020
                        }
                        column(RevenueDescription; RevenueDescription)
                        {
                            //CTSI-42.AS.1.0 08May2020
                        }
                        column(TaxLiable; TaxLiable)
                        {
                        }
                        column(TempSalesInvoiceLineAmtTaxLiable; TempSalesInvoiceLine.Amount - TaxLiable)
                        {
                        }
                        column(TempSalesInvoiceLineAmtAmtExclInvDisc; TempSalesInvoiceLine.Amount - AmountExclInvDisc)
                        {
                        }
                        column(TempSalesInvoiceLineAmtInclVATAmount; TempSalesInvoiceLine."Amount Including VAT" - TempSalesInvoiceLine.Amount)
                        {
                        }
                        column(TempSalesInvoiceLineAmtInclVAT; TempSalesInvoiceLine."Amount Including VAT")
                        {
                        }
                        column(TotalTaxLabel; TotalTaxLabel)
                        {
                        }
                        column(BreakdownTitle; BreakdownTitle)
                        {
                        }
                        column(BreakdownLabel1; BreakdownLabel[1])
                        {
                        }
                        column(BreakdownAmt1; BreakdownAmt[1])
                        {
                        }
                        column(BreakdownAmt2; BreakdownAmt[2])
                        {
                        }
                        column(BreakdownLabel2; BreakdownLabel[2])
                        {
                        }
                        column(BreakdownAmt3; BreakdownAmt[3])
                        {
                        }
                        column(BreakdownLabel3; BreakdownLabel[3])
                        {
                        }
                        column(BreakdownAmt4; BreakdownAmt[4])
                        {
                        }
                        column(BreakdownLabel4; BreakdownLabel[4])
                        {
                        }
                        column(ItemDescriptionCaption; ItemDescriptionCaptionLbl)
                        {
                        }
                        column(UnitCaption; UnitCaptionLbl)
                        {
                        }
                        column(OrderQtyCaption; OrderQtyCaptionLbl)
                        {
                        }
                        column(QuantityCaption; QuantityCaptionLbl)
                        {
                        }
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        {
                        }
                        column(TotalPriceCaption; TotalPriceCaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(InvoiceDiscountCaption; InvoiceDiscountCaptionLbl)
                        {
                        }
                        column(TotalCaption; TotalCaption)
                        {
                        }
                        column(AmountSubjecttoSalesTaxCaption; AmountSubjecttoSalesTaxCaption)
                        {
                        }
                        column(AmountExemptfromSalesTaxCaption; AmountExemptfromSalesTaxCaption)
                        {
                        }
                        dataitem(AsmLoop; Integer)
                        {
                            DataItemTableView = SORTING(Number);
                            column(TempPostedAsmLineUOMCode; GetUOMText(TempPostedAsmLine."Unit of Measure Code"))
                            {

                                //DecimalPlaces = 0 : 5;
                            }
                            column(TempPostedAsmLineQuantity; TempPostedAsmLine.Quantity)
                            {
                                DecimalPlaces = 0 : 5;
                            }
                            column(TempPostedAsmLineDesc; BlanksForIndent + TempPostedAsmLine.Description)
                            {
                            }
                            column(TempPostedAsmLineNo; BlanksForIndent + TempPostedAsmLine."No.")
                            {
                            }

                            trigger OnAfterGetRecord();
                            begin
                                IF Number = 1 THEN
                                    TempPostedAsmLine.FINDSET
                                ELSE BEGIN
                                    TempPostedAsmLine.NEXT;
                                    TaxLiable := 0;
                                    AmountExclInvDisc := 0;
                                    TempSalesInvoiceLine.Amount := 0;
                                    TempSalesInvoiceLine."Amount Including VAT" := 0;
                                END;
                            end;

                            trigger OnPreDataItem();
                            begin
                                CLEAR(TempPostedAsmLine);
                                SETRANGE(Number, 1, TempPostedAsmLine.COUNT);
                            end;
                        }

                        trigger OnAfterGetRecord();
                        begin
                            Clear(RevenueDescription);//CTSI-42.AS.1.0 08MAY2020
                            Clear(RevenueCat);//CTSI-42.AS.1.0 08MAY2020
                            OnLineNumber := OnLineNumber + 1;

                            WITH TempSalesInvoiceLine DO BEGIN
                                IF OnLineNumber = 1 THEN
                                    FIND('-')
                                ELSE
                                    NEXT;

                                OrderedQuantity := 0;
                                IF "Sales Header"."No." = '' THEN //Order No. to "No."
                                    OrderedQuantity := Quantity
                                ELSE
                                    IF OrderLine.GET(1, "Sales Header"."No.", "Line No.") THEN//Order No. to "No."
                                        OrderedQuantity := OrderLine.Quantity
                                    ELSE BEGIN
                                        //ShipmentLine.SETRANGE("Order No.", "Sales Header"."No.");
                                        //ShipmentLine.SETRANGE("Order Line No.", "Line No.");
                                        //IF ShipmentLine.FIND('-') THEN
                                        //    REPEAT
                                        //        OrderedQuantity := OrderedQuantity + ShipmentLine.Quantity;
                                        //    UNTIL 0 = ShipmentLine.NEXT;
                                    END;

                                DescriptionToPrint := Description + ' ' + "Description 2";

                                //CTSI-42.AS.1.0 08MAY2020 - START
                                if RevenueRec.Get("NS_Job Revenue Category") then begin
                                    RevenueCat := RevenueRec.NS_Code;
                                    RevenueDescription := "NS_Revenue Cat Description";//CTSI-42.AS.1.0 21MAY2020
                                end;
                                //CTSI-42.AS.1.0 08MAY2020 - END

                                IF Type = 0 THEN BEGIN
                                    "No." := '';
                                    "Unit of Measure" := '';
                                    Amount := 0;
                                    "Amount Including VAT" := 0;
                                    "Inv. Discount Amount" := 0;
                                    Quantity := 0;
                                END ELSE
                                    IF Type = Type::"G/L Account" THEN
                                        "No." := '';

                                IF "No." = '' THEN BEGIN
                                    HighDescriptionToPrint := DescriptionToPrint;
                                    LowDescriptionToPrint := '';
                                END ELSE BEGIN
                                    HighDescriptionToPrint := '';
                                    LowDescriptionToPrint := DescriptionToPrint;
                                END;

                                IF Amount <> "Amount Including VAT" THEN
                                    TaxLiable := Amount
                                ELSE
                                    TaxLiable := 0;

                                //AmountExclInvDisc := Amount + "Inv. Discount Amount";//CTSI-175.AS.1.0 14OCT2020 Commented
                                AmountExclInvDisc := Amount;//CTSI-175.AS.1.0 14OCT2020 Added
                                IF Quantity = 0 THEN
                                    UnitPriceToPrint := 0 // so it won't print
                                ELSE
                                    UnitPriceToPrint := ROUND(AmountExclInvDisc / Quantity, 0.00001);
                            END;

                            //CollectAsmInformation(TempSalesInvoiceLine);//Commented base code as ledger doesn't existed for unposted docs
                        end;

                        trigger OnPreDataItem();
                        begin
                            CurrReport.CREATETOTALS(TaxLiable, AmountExclInvDisc, TempSalesInvoiceLine.Amount, TempSalesInvoiceLine."Amount Including VAT");
                            TempSalesInvoiceLine.SetCurrentKey("NS_Job Revenue Category"); //CTSI-162.AS.1.0 29Sept2020 Done sorting
                            NumberOfLines := TempSalesInvoiceLine.COUNT;
                            SETRANGE(Number, 1, NumberOfLines);
                            OnLineNumber := 0;
                        end;
                    }
                    dataitem(LineFee; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            ORDER(Ascending)
                                            WHERE(Number = FILTER(1 ..));
                        column(LineFeeCaptionLbl; TempLineFeeNoteOnReportHist.ReportText)
                        {
                        }

                        trigger OnAfterGetRecord();
                        begin
                            IF NOT DisplayAdditionalFeeNote THEN
                                CurrReport.BREAK;

                            IF Number = 1 THEN BEGIN
                                IF NOT TempLineFeeNoteOnReportHist.FINDSET THEN
                                    CurrReport.BREAK
                            END ELSE
                                IF TempLineFeeNoteOnReportHist.NEXT = 0 THEN
                                    CurrReport.BREAK;
                        end;
                    }
                }

                trigger OnAfterGetRecord();
                begin
                    CurrReport.PAGENO := 1;

                    IF CopyNo = NoLoops THEN BEGIN
                        IF NOT CurrReport.PREVIEW THEN
                            SalesPrinted.Run("Sales Header");//PRJ:194:AS:09APRIL2020 changed from SalesInvPrinted.RUN("Sales Invoice Header");
                        CurrReport.BREAK;
                    END;
                    CopyNo := CopyNo + 1;
                    IF CopyNo = 1 THEN // Original
                        CLEAR(CopyTxt)
                    ELSE
                        CopyTxt := Text000;
                end;

                trigger OnPreDataItem();
                begin
                    NoLoops := 1 + ABS(NoCopies) + Customer."Invoice Copies";
                    IF NoLoops <= 0 THEN
                        NoLoops := 1;
                    CopyNo := 0;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                Clear(jobrecno);//CTSI-42.AS.2.0 24JUNE2020
                Clear(jobrecdesc);//CTSI-42.AS.2.0 24JUNE2020
                Clear(Work_Description);//CTSI-175.AS.1.0 14OCT2020
                IF PrintCompany THEN
                    IF RespCenter.GET("Responsibility Center") THEN BEGIN
                        FormatAddress.RespCenter(CompanyAddress, RespCenter);
                        CompanyInformation."Phone No." := RespCenter."Phone No.";
                        CompanyInformation."Fax No." := RespCenter."Fax No.";
                    END;
                IF "Language Code" <> '' then //PRJ-702.AS.1.0
                    CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                //CTSI-175.AS.1.0 14OCT2020 - start
                calcfields("Work Description");
                if "Work Description".hasvalue then begin
                    "Work Description".CREATEinSTREAM(Streamin);
                    StreamIn.READ(Work_Description);
                end;
                //CTSI-175.AS.1.0 14OCT2020 - end

                IF "Salesperson Code" = '' THEN
                    CLEAR(SalesPurchPerson)
                ELSE
                    SalesPurchPerson.GET("Salesperson Code");

                IF NOT Customer.GET("Bill-to Customer No.") THEN BEGIN
                    CLEAR(Customer);
                    "Bill-to Name" := Text009;
                    "Ship-to Name" := Text009;
                END;
                DocumentText := 'Proforma Invoice';
                // IF "Prepayment Invoice" THEN
                //     DocumentText := USText001;

                //CTSI-42.AS.2.0 24JUNE2020 - start
                if JobRec.get("NS_Job No.") then begin
                    jobrecno := JobRec."No.";
                    jobrecdesc := JobRec.Description;
                end;
                //CTSI-42.AS.2.0 24JUNE2020 - end

                //FormatAddress.SalesInvBillTo(BillToAddress, "Sales Invoice Header");
                //FormatAddress.SalesInvShipTo(ShipToAddress, ShipToAddress, "Sales Invoice Header");

                FormatAddress.SalesHeaderBillTo(BillToAddress, "Sales Header");
                FormatAddress.SalesHeaderShipTo(ShipToAddress, ShipToAddress, "Sales Header");

                IF "Payment Terms Code" = '' THEN
                    CLEAR(PaymentTerms)
                ELSE
                    PaymentTerms.GET("Payment Terms Code");

                IF "Shipment Method Code" = '' THEN
                    CLEAR(ShipmentMethod)
                ELSE
                    ShipmentMethod.GET("Shipment Method Code");

                IF "Currency Code" = '' THEN BEGIN
                    GLSetup.TESTFIELD("LCY Code");
                    TotalCaption := STRSUBSTNO(TotalCaptionTxt, GLSetup."LCY Code");
                    AmountExemptfromSalesTaxCaption := STRSUBSTNO(AmountExemptfromSalesTaxCaptionTxt, GLSetup."LCY Code");
                    AmountSubjecttoSalesTaxCaption := STRSUBSTNO(AmountSubjecttoSalesTaxCaptionTxt, GLSetup."LCY Code");
                END ELSE BEGIN
                    TotalCaption := STRSUBSTNO(TotalCaptionTxt, "Currency Code");
                    AmountExemptfromSalesTaxCaption := STRSUBSTNO(AmountExemptfromSalesTaxCaption, "Currency Code");
                    AmountSubjecttoSalesTaxCaption := STRSUBSTNO(AmountSubjecttoSalesTaxCaption, "Currency Code");
                END;

                GetLineFeeNoteOnReportHist("No.");

                IF LogInteraction THEN
                    IF NOT CurrReport.PREVIEW THEN BEGIN
                        IF "Bill-to Contact No." <> '' THEN
                            SegManagement.LogDocument(
                              4, "No.", 0, 0, DATABASE::Contact, "Bill-to Contact No.", "Salesperson Code",
                              "Campaign No.", "Posting Description", '')
                        ELSE
                            SegManagement.LogDocument(
                              4, "No.", 0, 0, DATABASE::Customer, "Bill-to Customer No.", "Salesperson Code",
                              "Campaign No.", "Posting Description", '');
                    END;

                CLEAR(BreakdownTitle);
                CLEAR(BreakdownLabel);
                CLEAR(BreakdownAmt);
                TotalTaxLabel := Text008;
                TaxRegNo := '';
                TaxRegLabel := '';
                //PPDA.1.0 Commented Start
                // IF "Tax Area Code" <> '' THEN BEGIN
                //     TaxArea.GET("Tax Area Code");
                //     CASE TaxArea."Country/Region" OF
                //         TaxArea."Country/Region"::US:
                //             TotalTaxLabel := Text005;
                //         TaxArea."Country/Region"::CA:
                //             BEGIN
                //                 TotalTaxLabel := Text007;
                //                 TaxRegNo := CompanyInformation."VAT Registration No.";
                //                 TaxRegLabel := CompanyInformation.FIELDCAPTION("VAT Registration No.");
                //             END;
                //     END;
                //     SalesTaxCalc.StartSalesTaxCalculation;
                //     //IF TaxArea."Use External Tax Engine" THEN
                //     //    SalesTaxCalc.CallExternalTaxEngineForDoc(DATABASE::"Sales Invoice Header", 0, "No.")
                //     //ELSE BEGIN
                //     //    SalesTaxCalc.AddSalesInvoiceLines("No.");
                //     //    SalesTaxCalc.EndSalesTaxCalculation("Posting Date");
                //     //END;
                //     //SalesTaxCalc.GetSummarizedSalesTaxTable(TempSalesTaxAmtLine);
                //     BrkIdx := 0;
                //     PrevPrintOrder := 0;
                //     PrevTaxPercent := 0;
                //     WITH TempSalesTaxAmtLine DO BEGIN
                //         RESET;
                //         SETCURRENTKEY("Print Order", "Tax Area Code for Key", "Tax Jurisdiction Code");
                //         IF FIND('-') THEN
                //             REPEAT
                //                 IF ("Print Order" = 0) OR
                //                    ("Print Order" <> PrevPrintOrder) OR
                //                    ("Tax %" <> PrevTaxPercent)
                //                 THEN BEGIN
                //                     BrkIdx := BrkIdx + 1;
                //                     IF BrkIdx > 1 THEN BEGIN
                //                         IF TaxArea."Country/Region" = TaxArea."Country/Region"::CA THEN
                //                             BreakdownTitle := Text006
                //                         ELSE
                //                             BreakdownTitle := Text003;
                //                     END;
                //                     IF BrkIdx > ARRAYLEN(BreakdownAmt) THEN BEGIN
                //                         BrkIdx := BrkIdx - 1;
                //                         BreakdownLabel[BrkIdx] := Text004;
                //                     END ELSE
                //                         BreakdownLabel[BrkIdx] := STRSUBSTNO("Print Description", "Tax %");
                //                 END;
                //                 BreakdownAmt[BrkIdx] := BreakdownAmt[BrkIdx] + "Tax Amount";
                //             UNTIL NEXT = 0;
                //     END;
                //     IF BrkIdx = 1 THEN BEGIN
                //         CLEAR(BreakdownLabel);
                //         CLEAR(BreakdownAmt);
                //     END;
                // END;
                //PPDA.1.0 Commented End
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
                    CaptionML = ENU = 'Options',
                                ESM = 'Opciones',
                                FRC = 'Options',
                                ENC = 'Options';
                    field(NoCopies; NoCopies)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionML = ENU = 'Number of Copies',
                                    ESM = 'Número de copias',
                                    FRC = 'Nombre de copies',
                                    ENC = 'Number of Copies';
                        ToolTipML = ENU = 'Specifies the number of copies of each document (in addition to the original) that you want to print.',
                                    ESM = 'Especifica el número de copias de cada documento (además del original) que desea imprimir.',
                                    FRC = 'Spécifie le nombre de copies de chaque document (en plus de l''original) que vous souhaitez imprimer.',
                                    ENC = 'Specifies the number of copies of each document (in addition to the original) that you want to print.';
                    }
                    field(PrintCompanyAddress; PrintCompany)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionML = ENU = 'Print Company Address',
                                    ESM = 'Imprimir dir. empresa',
                                    FRC = 'Imprimer l''adresse de la compagnie',
                                    ENC = 'Print Company Address';
                        ToolTipML = ENU = 'Specifies if your company address is printed at the top of the sheet, because you do not use pre-printed paper. Leave this check box blank to omit your company''s address.',
                                    ESM = 'Especifica si en la parte superior de la hoja se debe imprimir la dirección de la empresa porque no usa papel preimpreso. Deje la casilla en blanco para omitir la dirección de la empresa.',
                                    FRC = 'Spécifie si l''adresse de votre compagnie est imprimée en haut de la feuille, car vous n''utilisez pas de papier préimprimé. Décochez cette case pour ne pas imprimer l''adresse de votre compagnie.',
                                    ENC = 'Specifies if your company address is printed at the top of the sheet, because you do not use pre-printed paper. Leave this check box blank to omit your company''s address.';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionML = ENU = 'Log Interaction',
                                    ESM = 'Log interacción',
                                    FRC = 'Journal interaction',
                                    ENC = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTipML = ENU = 'Specifies if you want to record the related interactions with the involved contact person in the Interaction Log Entry table.',
                                    ESM = 'Especifica si desea registrar las interacciones relacionadas con la persona de contacto implicada en la tabla Mov. log de interacción.',
                                    FRC = 'Spécifie si vous souhaitez enregistrer les interactions associées avec la personne de contact impliquée dans la table Écriture du journal d''interaction.',
                                    ENC = 'Specifies if you want to record the related interactions with the involved contact person in the Interaction Log Entry table.';
                    }
                    field(DisplayAsmInfo; DisplayAssemblyInformation)
                    {
                        ApplicationArea = Assembly;
                        CaptionML = ENU = 'Show Assembly Components',
                                    ESM = 'Mostrar componentes del ensamblado',
                                    FRC = 'Afficher les composantes d''assemblage',
                                    ENC = 'Show Assembly Components';
                    }
                    field(DisplayAdditionalFeeNote; DisplayAdditionalFeeNote)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionML = ENU = 'Show Additional Fee Note',
                                    ESM = 'Mostrar nota recargo adicional',
                                    FRC = 'Afficher la note de frais supplémentaires',
                                    ENC = 'Show Additional Fee Note';
                        ToolTipML = ENU = 'Specifies if you want notes about additional fees to be shown on the document.',
                                    ESM = 'Especifica si desea que se muestren notas sobre los cargos adicionales en el documento.',
                                    FRC = 'Spécifie si vous souhaitez que les notes concernant les frais supplémentaires soient affichées sur le document.',
                                    ENC = 'Specifies if you want notes about additional fees to be shown on the document.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit();
        begin
            LogInteractionEnable := TRUE;
        end;

        trigger OnOpenPage();
        begin
            InitLogInteraction;
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        GLSetup.GET;
    end;

    trigger OnPreReport();
    begin
        ShipmentLine.SETCURRENTKEY("Order No.", "Order Line No.");
        IF NOT CurrReport.USEREQUESTPAGE THEN
            InitLogInteraction;

        CompanyInformation.GET;
        //CTSI-147.AS.1.0 14SEPT2020 - start
        CompanyInformation.CalcFields(Picture);
        CompName := CompanyInformation.Name;
        if CompanyInformation."Address 2" = '' then
            CompAddress := CompanyInformation.Address;
        if CompanyInformation."Address 2" <> '' then
            CompAddress := CompanyInformation.Address + CompanyInformation."Address 2";
        CompFinalAddrLine := CompanyInformation.City + ',' + CompanyInformation.County + ' ' + CompanyInformation."Post Code";
        //CTSI-147.AS.1.0 14SEPT2020 - end
        SalesSetup.GET;

        CASE SalesSetup."Logo Position on Documents" OF
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                BEGIN
                    CompanyInfo3.GET;
                    CompanyInfo3.CALCFIELDS(Picture);
                END;
            SalesSetup."Logo Position on Documents"::Center:
                BEGIN
                    CompanyInfo1.GET;
                    CompanyInfo1.CALCFIELDS(Picture);
                END;
            SalesSetup."Logo Position on Documents"::Right:
                BEGIN
                    CompanyInfo2.GET;
                    CompanyInfo2.CALCFIELDS(Picture);
                END;
        END;

        // IF PrintCompany THEN//CTSI-147.AS.1.0 14SEPT2020 Commented
        FormatAddress.Company(CompanyAddress, CompanyInformation)
        // ELSE//CTSI-147.AS.1.0 14SEPT2020 Commented
        //     CLEAR(CompanyAddress);//CTSI-147.AS.1.0 14SEPT2020 Commented
    end;

    var
        CompAddress: Text; //CTSI-147.AS.1.0 14SEPT2020
        CompName: Text; //CTSI-147.AS.1.0 14SEPT2020
        CompFinalAddrLine: Text; //CTSI-147.AS.1.0 14SEPT2020
        TaxLiable: Decimal;
        OrderedQuantity: Decimal;
        UnitPriceToPrint: Decimal;
        AmountExclInvDisc: Decimal;
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInformation: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Customer: Record Customer;
        SalesPrinted: Codeunit 313;//Added for Changed Data Item
        RevenueDescription: Text[100];//CTSI-42.AS.1.0 08May2020
        RevenueRec: Record 14021177;//CTSI-42.AS.1.0 08May2020
        RevenueCat: Code[20];//CTSI-42.AS.1.0 08May2020
        Work_Description: Text;//CTSI-175.AS.1.0 14OCT2020
        Streamin: InStream;//CTSI-175.AS.1.0 14OCT2020
        OrderLine: Record "Sales Line";
        ShipmentLine: Record "Sales Shipment Line";
        TempSalesInvoiceLine: Record "Sales Line" temporary;
        TempSalesInvoiceLineAsm: Record "Sales Line" temporary;
        RespCenter: Record "Responsibility Center";
        Language: codeunit Language;
        // TempSalesTaxAmtLine: Record "Sales Tax Amount Line" temporary; //PPDA.1.0 Commented
        TaxArea: Record "Tax Area";
        Cust: Record Customer;
        JobRec: Record Job;//CTSI-42.AS.2.0 24JUNE2020
        jobrecdesc: Text[100];//CTSI-42.AS.2.0 24JUNE2020
        jobrecno: code[20];//CTSI-42.AS.2.0 24JUNE2020
        TempPostedAsmLine: Record "Posted Assembly Line" temporary;
        TempLineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist." temporary;
        GLSetup: Record "General Ledger Setup";
        CompanyAddress: array[8] of Text;//CTSI-82.MS.1.0
        BillToAddress: array[8] of Text;//CTSI-82.MS.1.0
        ShipToAddress: array[8] of Text;//CTSI-82.MS.1.0
        CopyTxt: Text;//CTSI-82.MS.1.0
        DescriptionToPrint: Text;//CTSI-82.MS.1.0
        HighDescriptionToPrint: Text;//CTSI-82.MS.1.0
        LowDescriptionToPrint: Text;//CTSI-82.MS.1.0
        PrintCompany: Boolean;
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        HighestLineNo: Integer;
        SpacePointer: Integer;
        SalesInvPrinted: Codeunit "Sales Inv.-Printed";
        FormatAddress: Codeunit "Format Address";
        SalesTaxCalc: Codeunit "Sales Tax Calculate";
        SegManagement: Codeunit SegManagement;
        LogInteraction: Boolean;
        Text000: TextConst ENU = 'COPY', ESM = 'COPIA', FRC = 'COPIER', ENC = 'COPY';
        TaxRegNo: Text;
        TaxRegLabel: Text;
        TotalTaxLabel: Text;
        BreakdownTitle: Text;
        BreakdownLabel: array[4] of Text;
        BreakdownAmt: array[4] of Decimal;
        Text003: TextConst ENU = 'Sales Tax Breakdown:', ESM = 'Análisis impto. vtas.:', FRC = 'Ventilation taxe de vente :', ENC = 'Sales Tax Breakdown:';
        Text004: TextConst ENU = 'Other Taxes', ESM = 'Otros impuestos', FRC = 'Autres taxes', ENC = 'Other Taxes';
        BrkIdx: Integer;
        PrevPrintOrder: Integer;
        PrevTaxPercent: Decimal;
        Text005: TextConst ENU = 'Total Sales Tax:', ESM = 'Total impto. vtas.:', FRC = 'Taxes de vente totales:', ENC = 'Total Sales Tax:';
        Text006: TextConst ENU = 'Tax Breakdown:', ESM = 'Desglose imptos.:', FRC = 'Ventilation fiscale :', ENC = 'Tax Breakdown:';
        Text007: TextConst ENU = 'Total Tax:', ESM = 'Total impto.:', FRC = 'Taxe totale :', ENC = 'Total Tax:';
        Text008: TextConst ENU = 'Tax:', ESM = 'Impto.:', FRC = 'Taxe :', ENC = 'Tax:';
        Text009: TextConst ENU = 'VOID INVOICE', ESM = 'ANULAR FACTURA', FRC = 'ANNULER FACTURE', ENC = 'VOID INVOICE';
        DocumentText: Text[20];
        USText000: TextConst ENU = 'INVOICE', ESM = 'FACTURA', FRC = 'FACTURE', ENC = 'INVOICE';
        USText001: TextConst ENU = 'PREPAYMENT REQUEST', ESM = 'SOLICITUD PREPAGO', FRC = 'REQU­TE PMENT ANTIC.', ENC = 'PREPAYMENT REQUEST';
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        BillCaptionLbl: TextConst ENU = 'Bill', ESM = 'Facturar', FRC = 'Facturer', ENC = 'Bill';
        ToCaptionLbl: TextConst ENU = 'To:', ESM = 'Para:', FRC = '‡ :', ENC = 'To:';
        ShipViaCaptionLbl: TextConst ENU = 'Ship Via', ESM = 'Envío a través de', FRC = 'Livrer par', ENC = 'Ship Via';
        ShipDateCaptionLbl: TextConst ENU = 'Ship Date', ESM = 'Fecha envío', FRC = 'Date de livraison', ENC = 'Ship Date';
        DueDateCaptionLbl: TextConst ENU = 'Due Date:', ESM = 'Fecha vencimiento:', FRC = 'Date d''échéance:', ENC = 'Due Date:';//CTSI-147.AS.1.0 14SEPT2020
        TermsCaptionLbl: TextConst ENU = 'Terms', ESM = 'Términos', FRC = 'Modalités', ENC = 'Terms';
        CustomerIDCaptionLbl: TextConst ENU = 'Customer ID:', ESM = 'Id. cliente:', FRC = 'Code de client:', ENC = 'Customer ID:';//CTSI-147.AS.1.0 14SEPT2020
        PONumberCaptionLbl: TextConst ENU = 'P.O. Number:', ESM = 'Número pedido compra:', FRC = 'N° de bon de commande:', ENC = 'P.O. Number:';//CTSI-147.AS.1.0 14SEPT2020
        PODateCaptionLbl: TextConst ENU = 'P.O. Date', ESM = 'Fecha pedido compra', FRC = 'Date du bon de commande', ENC = 'P.O. Date';
        OurOrderNoCaptionLbl: TextConst ENU = 'Our Order No.', ESM = 'Nuestro pedido N°', FRC = 'Notre n° de commande', ENC = 'Our Order No.';
        SalesPersonCaptionLbl: TextConst ENU = 'SalesPerson', ESM = 'Vendedor', FRC = 'Représentant', ENC = 'SalesPerson';
        ShipCaptionLbl: TextConst ENU = 'Ship', ESM = 'Enviar', FRC = 'Livrer', ENC = 'Ship';
        InvoiceNumberCaptionLbl: TextConst ENU = 'Invoice Number:', ESM = 'Número factura:', FRC = 'Numéro de facture :', ENC = 'Invoice Number:';
        InvoiceDateCaptionLbl: TextConst ENU = 'Invoice Date:', ESM = 'Fecha factura:', FRC = 'Date de la facture :', ENC = 'Invoice Date:';
        PageCaptionLbl: TextConst ENU = 'Page:', ESM = 'Pág.:', FRC = 'Page :', ENC = 'Page:';
        TaxIdentTypeCaptionLbl: TextConst ENU = 'Tax Ident. Type', ESM = 'Tipo de identificación fiscal', FRC = 'Type ident. taxe', ENC = 'Tax Ident. Type';
        ItemDescriptionCaptionLbl: TextConst ENU = 'Item/Description', ESM = 'Producto/descripción', FRC = 'Article/Description', ENC = 'Item/Description';
        UnitCaptionLbl: TextConst ENU = 'Unit', ESM = 'Unidad', FRC = 'Unité', ENC = 'Unit';
        OrderQtyCaptionLbl: TextConst ENU = 'Order Qty', ESM = 'Cantidad pedido', FRC = 'Qté commande', ENC = 'Order Qty';
        QuantityCaptionLbl: TextConst ENU = 'Quantity', ESM = 'Cantidad', FRC = 'Quantité', ENC = 'Quantity';
        UnitPriceCaptionLbl: TextConst ENU = 'Unit Price', ESM = 'Precio unitario', FRC = 'Prix unitaire', ENC = 'Unit Price';
        TotalPriceCaptionLbl: TextConst ENU = 'Total Price', ESM = 'Precio total', FRC = 'Prix total', ENC = 'Total Price';
        SubtotalCaptionLbl: TextConst ENU = 'Subtotal:', ESM = 'Subtotal:', FRC = 'Sous-total :', ENC = 'Subtotal:';
        InvoiceDiscountCaptionLbl: TextConst ENU = 'Invoice Discount:', ESM = 'Descuento factura:', FRC = 'Escompte de la facture :', ENC = 'Invoice Discount:';
        TotalCaptionTxt: TextConst ENU = 'Total %1:', ESM = 'Total %1:', FRC = 'Total %1 :', ENC = 'Total %1:';
        AmountSubjecttoSalesTaxCaptionTxt: TextConst ENU = 'Amount Subject to Sales Tax %1', ESM = 'Importe sujeto a impuestos de ventas %1', FRC = 'Montant assujetti à la taxe de vente %1', ENC = 'Amount Subject to Sales Tax %1';
        AmountExemptfromSalesTaxCaptionTxt: TextConst ENU = 'Amount Exempt from Sales Tax %1', ESM = 'Importe exento de impuestos de ventas %1', FRC = 'Montant exonéré de la taxe de vente %1', ENC = 'Amount Exempt from Sales Tax %1';
        TotalCaption: Text;
        AmountSubjecttoSalesTaxCaption: Text;
        AmountExemptfromSalesTaxCaption: Text;
        DisplayAdditionalFeeNote: Boolean;
        RetentionAmount: Decimal;
        LessRetentionCaption: Label 'Less Retention';
        BalanceDueCaption: Label 'Balance Due';

    [Scope('Personalization')]
    procedure InitLogInteraction();
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(4) <> '';
    end;

    [Scope('Personalization')]
    procedure CollectAsmInformation(TempSalesInvoiceLine: Record "Sales Invoice Line" temporary);
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        PostedAsmHeader: Record "Posted Assembly Header";
        PostedAsmLine: Record "Posted Assembly Line";
        SalesShipmentLine: Record "Sales Shipment Line";
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        TempPostedAsmLine.DELETEALL;
        IF NOT DisplayAssemblyInformation THEN
            EXIT;
        IF NOT TempSalesInvoiceLineAsm.GET(TempSalesInvoiceLine."Document No.", TempSalesInvoiceLine."Line No.") THEN
            EXIT;
        SalesInvoiceLine.GET(TempSalesInvoiceLineAsm."Document No.", TempSalesInvoiceLineAsm."Line No.");
        IF SalesInvoiceLine.Type <> SalesInvoiceLine.Type::Item THEN
            EXIT;
        WITH ValueEntry DO BEGIN
            SETCURRENTKEY("Document No.");
            SETRANGE("Document No.", SalesInvoiceLine."Document No.");
            SETRANGE("Document Type", "Document Type"::"Sales Invoice");
            SETRANGE("Document Line No.", SalesInvoiceLine."Line No.");
            SETRANGE("Applies-to Entry", 0);
            IF NOT FINDSET THEN
                EXIT;
        END;
        REPEAT
            IF ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.") THEN
                IF ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Shipment" THEN BEGIN
                    SalesShipmentLine.GET(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.");
                    IF SalesShipmentLine.AsmToShipmentExists(PostedAsmHeader) THEN BEGIN
                        PostedAsmLine.SETRANGE("Document No.", PostedAsmHeader."No.");
                        IF PostedAsmLine.FINDSET THEN
                            REPEAT
                                TreatAsmLineBuffer(PostedAsmLine);
                            UNTIL PostedAsmLine.NEXT = 0;
                    END;
                END;
        UNTIL ValueEntry.NEXT = 0;
    end;

    [Scope('Personalization')]
    procedure TreatAsmLineBuffer(PostedAsmLine: Record "Posted Assembly Line");
    begin
        CLEAR(TempPostedAsmLine);
        TempPostedAsmLine.SETRANGE(Type, PostedAsmLine.Type);
        TempPostedAsmLine.SETRANGE("No.", PostedAsmLine."No.");
        TempPostedAsmLine.SETRANGE("Variant Code", PostedAsmLine."Variant Code");
        TempPostedAsmLine.SETRANGE(Description, PostedAsmLine.Description);
        TempPostedAsmLine.SETRANGE("Unit of Measure Code", PostedAsmLine."Unit of Measure Code");
        IF TempPostedAsmLine.FINDFIRST THEN BEGIN
            TempPostedAsmLine.Quantity += PostedAsmLine.Quantity;
            TempPostedAsmLine.MODIFY;
        END ELSE BEGIN
            CLEAR(TempPostedAsmLine);
            TempPostedAsmLine := PostedAsmLine;
            TempPostedAsmLine.INSERT;
        END;
    end;

    [Scope('Personalization')]
    procedure GetUOMText(UOMCode: Code[10]): Text[10];
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        IF NOT UnitOfMeasure.GET(UOMCode) THEN
            EXIT(UOMCode);
        EXIT(UnitOfMeasure.Description);
    end;

    [Scope('Personalization')]
    procedure BlanksForIndent(): Text[10];
    begin
        EXIT(PADSTR('', 2, ' '));
    end;

    local procedure GetLineFeeNoteOnReportHist(SalesInvoiceHeaderNo: Code[20]);
    var
        LineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist.";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Customer: Record Customer;
    begin
        TempLineFeeNoteOnReportHist.DELETEALL;
        CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Invoice);
        CustLedgerEntry.SETRANGE("Document No.", SalesInvoiceHeaderNo);
        IF NOT CustLedgerEntry.FINDFIRST THEN
            EXIT;

        IF NOT Customer.GET(CustLedgerEntry."Customer No.") THEN
            EXIT;

        LineFeeNoteOnReportHist.SETRANGE("Cust. Ledger Entry No", CustLedgerEntry."Entry No.");
        LineFeeNoteOnReportHist.SETRANGE("Language Code", Customer."Language Code");
        IF LineFeeNoteOnReportHist.FINDSET THEN BEGIN
            REPEAT
                TempLineFeeNoteOnReportHist.INIT;
                TempLineFeeNoteOnReportHist.COPY(LineFeeNoteOnReportHist);
                TempLineFeeNoteOnReportHist.INSERT;
            UNTIL LineFeeNoteOnReportHist.NEXT = 0;
        END ELSE BEGIN
            IF Language.GetUserLanguageCode() <> '' then//PRJ-702.AS.1.0
                LineFeeNoteOnReportHist.SETRANGE("Language Code", Language.GetUserLanguageCode());
            IF LineFeeNoteOnReportHist.FINDSET THEN
                REPEAT
                    TempLineFeeNoteOnReportHist.INIT;
                    TempLineFeeNoteOnReportHist.COPY(LineFeeNoteOnReportHist);
                    TempLineFeeNoteOnReportHist.INSERT;
                UNTIL LineFeeNoteOnReportHist.NEXT = 0;
        END;
    end;
}

