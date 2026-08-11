//PPDA.1.0 Commented Start
// report 14021224 "NS_Purchase Order"
// {
//     // +------------------------------------------------------------
//     // +ProjectPro
//     // +  - Added field(s):
//     // +
//     // +
//     // +  - Added function(s):
//     // +
//     // +
//     // +  - Added global variable(s):
//     // +     PP_RetentionAmount
//     // +     PP_BalanceDue
//     // +     JobName
//     // +     JobLocation
//     // +     CustomerAccountName
//     // +     Contact
//     // +     PhoneAndFax
//     // +     Text14021101
//     // +     Text14021102
//     // +     Text14021400
//     // +
//     // +  - Modification(s):
//     // +     - OnPreReport: Assign PhoneAndFax
//     // +     - Purchase Header - OnAfterGetRecord: add set PP_RetentionAmount, PP_BalanceDue, JobName, JobLocation and CustomerAccountName values
//     // +     - Added pass to RDLC: PP_RetentionAmount Caption, PP_RetentionAmount, PP_BalanceDue Caption, PP_BalanceDue
//     // +     - Added Less Retention and Balance Due lines in the footer of the document
//     // +     - Formatted "Balance Due" in footer
//     // +------------------------------------------------------------
//     DefaultLayout = RDLC;
//     RDLCLayout = './Layouts/NSPurchase Order.rdl';

//     Caption = 'Job Purchase Order';//PE-141.NK.1.0 03Aug2023 updated name

//     dataset
//     {
//         dataitem("Purchase Header"; "Purchase Header")
//         {
//             DataItemTableView = SORTING("Document Type", "No.")
//                                 WHERE("Document Type" = CONST(Order));
//             PrintOnlyIfDetail = true;
//             RequestFilterFields = "No.", "Buy-from Vendor No.", "Pay-to Vendor No.", "No. Printed";
//             column(No_PurchaseHeader; "No.")
//             {
//             }
//             column(NS_JobNo; "NS_Job No.")
//             {
//             }
//             column(JobName; JobName)
//             {
//             }
//             column(JobLocation; JobLocation)
//             {
//             }
//             column(CustomerAccountName; CustomerAccountName)
//             {
//             }
//             dataitem(CopyLoop; Integer)
//             {
//                 DataItemTableView = SORTING(Number);
//                 dataitem(PageLoop; Integer)
//                 {
//                     DataItemTableView = SORTING(Number)
//                                         WHERE(Number = CONST(1));
//                     column(CompanyInformationPicture; CompanyInformation.Picture)
//                     {
//                     }
//                     column(CompanyAddress1; CompanyAddress[1])
//                     {
//                     }
//                     column(CompanyAddress2; CompanyAddress[2])
//                     {
//                     }
//                     column(CompanyAddress3; CompanyAddress[3])
//                     {
//                     }
//                     column(CompanyAddress4; CompanyAddress[4])
//                     {
//                     }
//                     column(CompanyAddress5; CompanyAddress[5])
//                     {
//                     }
//                     column(CompanyAddress6; CompanyAddress[6])
//                     {
//                     }
//                     column(PhoneAndFax; PhoneAndFax)
//                     {
//                     }
//                     column(CopyTxt; CopyTxt)
//                     {
//                     }
//                     column(BuyFromAddress1; BuyFromAddress[1])
//                     {
//                     }
//                     column(BuyFromAddress2; BuyFromAddress[2])
//                     {
//                     }
//                     column(BuyFromAddress3; BuyFromAddress[3])
//                     {
//                     }
//                     column(BuyFromAddress4; BuyFromAddress[4])
//                     {
//                     }
//                     column(BuyFromAddress5; BuyFromAddress[5])
//                     {
//                     }
//                     column(BuyFromAddress6; BuyFromAddress[6])
//                     {
//                     }
//                     column(BuyFromAddress7; BuyFromAddress[7])
//                     {
//                     }
//                     column(ExptRecptDt_PurchaseHeader; "Purchase Header"."Expected Receipt Date")
//                     {
//                     }
//                     column(ShipToAddress1; ShipToAddress[1])
//                     {
//                     }
//                     column(ShipToAddress2; ShipToAddress[2])
//                     {
//                     }
//                     column(ShipToAddress3; ShipToAddress[3])
//                     {
//                     }
//                     column(ShipToAddress4; ShipToAddress[4])
//                     {
//                     }
//                     column(ShipToAddress5; ShipToAddress[5])
//                     {
//                     }
//                     column(ShipToAddress6; ShipToAddress[6])
//                     {
//                     }
//                     column(ShipToAddress7; ShipToAddress[7])
//                     {
//                     }
//                     column(BuyfrVendNo_PurchaseHeader; "Purchase Header"."Buy-from Vendor No.")
//                     {
//                     }
//                     column(YourRef_PurchaseHeader; "Purchase Header"."Your Reference")
//                     {
//                     }
//                     column(SalesPurchPersonName; SalesPurchPerson.Name)
//                     {
//                     }
//                     column(No1_PurchaseHeader; "Purchase Header"."No.")
//                     {
//                     }
//                     column(OrderDate_PurchaseHeader; "Purchase Header"."Order Date")
//                     {
//                     }
//                     column(CompanyAddress7; CompanyAddress[7])
//                     {
//                     }
//                     column(CompanyAddress8; CompanyAddress[8])
//                     {
//                     }
//                     column(BuyFromAddress8; BuyFromAddress[8])
//                     {
//                     }
//                     column(ShipToAddress8; ShipToAddress[8])
//                     {
//                     }
//                     column(ShipmentMethodDescription; ShipmentMethod.Description)
//                     {
//                     }
//                     column(PaymentTermsDescription; PaymentTerms.Description)
//                     {
//                     }
//                     column(CompanyInformationPhoneNo; CompanyInformation."Phone No.")
//                     {
//                     }
//                     column(CopyNo; CopyNo)
//                     {
//                     }
//                     column(VendTaxIdentificationType; FORMAT(Vend."Tax Identification Type"))
//                     {
//                     }
//                     column(ToCaption; ToCaptionLbl)
//                     {
//                     }
//                     column(ReceiveByCaption; ReceiveByCaptionLbl)
//                     {
//                     }
//                     column(VendorIDCaption; VendorIDCaptionLbl)
//                     {
//                     }
//                     column(ConfirmToCaption; ConfirmToCaptionLbl)
//                     {
//                     }
//                     column(BuyerCaption; BuyerCaptionLbl)
//                     {
//                     }
//                     column(ShipCaption; ShipCaptionLbl)
//                     {
//                     }
//                     column(ToCaption1; ToCaption1Lbl)
//                     {
//                     }
//                     column(PurchOrderCaption; PurchOrderCaptionLbl)
//                     {
//                     }
//                     column(PurchOrderNumCaption; PurchOrderNumCaptionLbl)
//                     {
//                     }
//                     column(PurchOrderDateCaption; PurchOrderDateCaptionLbl)
//                     {
//                     }
//                     column(PageCaption; PageCaptionLbl)
//                     {
//                     }
//                     column(ShipViaCaption; ShipViaCaptionLbl)
//                     {
//                     }
//                     column(TermsCaption; TermsCaptionLbl)
//                     {
//                     }
//                     column(PhoneNoCaption; PhoneNoCaptionLbl)
//                     {
//                     }
//                     column(TaxIdentTypeCaption; TaxIdentTypeCaptionLbl)
//                     {
//                     }
//                     column(VendorOrderNo_Lbl; VendorOrderNoLbl)
//                     {
//                     }
//                     column(VendorInvoiceNo_Lbl; VendorInvoiceNoLbl)
//                     {
//                     }
//                     column(VendorOrderNo; "Purchase Header"."Vendor Order No.")
//                     {
//                     }
//                     column(VendorInvoiceNo; "Purchase Header"."Vendor Invoice No.")
//                     {
//                     }
//                     column(PP_RetentionAmount; PP_RetentionAmount)
//                     {
//                     }
//                     column(PP_BalanceDueAmount; PP_BalanceDue)
//                     {
//                     }
//                     dataitem("Purchase Line"; "Purchase Line")
//                     {
//                         DataItemLink = "Document No." = FIELD("No.");
//                         DataItemLinkReference = "Purchase Header";
//                         DataItemTableView = SORTING("Document Type", "Document No.", "Line No.")
//                                             WHERE("Document Type" = CONST(Order));
//                         column(Line_No_PurchaseLine; "Line No.")
//                         {
//                         }
//                         column(AmountExclInvDisc; AmountExclInvDisc)
//                         {
//                         }
//                         column(ItemNumberToPrint; ItemNumberToPrint)
//                         {
//                         }
//                         column(UnitofMeasure_PurchaseLine; "Unit of Measure")
//                         {
//                         }
//                         column(Quantity_PurchaseLine; Quantity)
//                         {
//                         }
//                         column(UnitPriceToPrint; UnitPriceToPrint)
//                         {
//                             DecimalPlaces = 2 : 5;
//                         }
//                         column(Description_PurchaseLine; Description)
//                         {
//                         }
//                         column(PrintFooter; PrintFooter)
//                         {
//                         }
//                         column(InvDiscountAmt_PurchaseLine; "Inv. Discount Amount")
//                         {
//                         }
//                         column(TaxAmount; TaxAmount)
//                         {
//                         }
//                         column(LineAmtTaxAmtInvDiscountAmt; "Line Amount" + TaxAmount - "Inv. Discount Amount")
//                         {
//                         }
//                         column(TotalTaxLabel; TotalTaxLabel)
//                         {
//                         }
//                         column(BreakdownTitle; BreakdownTitle)
//                         {
//                         }
//                         column(BreakdownLabel1; BreakdownLabel[1])
//                         {
//                         }
//                         column(BreakdownAmt1; BreakdownAmt[1])
//                         {
//                         }
//                         column(BreakdownLabel2; BreakdownLabel[2])
//                         {
//                         }
//                         column(BreakdownAmt2; BreakdownAmt[2])
//                         {
//                         }
//                         column(BreakdownLabel3; BreakdownLabel[3])
//                         {
//                         }
//                         column(BreakdownAmt3; BreakdownAmt[3])
//                         {
//                         }
//                         column(BreakdownAmt4; BreakdownAmt[4])
//                         {
//                         }
//                         column(BreakdownLabel4; BreakdownLabel[4])
//                         {
//                         }
//                         column(DocumentNo_PurchaseLine; "Document No.")
//                         {
//                         }
//                         column(ItemNoCaption; ItemNoCaptionLbl)
//                         {
//                         }
//                         column(UnitCaption; UnitCaptionLbl)
//                         {
//                         }
//                         column(DescriptionCaption; DescriptionCaptionLbl)
//                         {
//                         }
//                         column(QuantityCaption; QuantityCaptionLbl)
//                         {
//                         }
//                         column(UnitPriceCaption; UnitPriceCaptionLbl)
//                         {
//                         }
//                         column(TotalPriceCaption; TotalPriceCaptionLbl)
//                         {
//                         }
//                         column(SubtotalCaption; SubtotalCaptionLbl)
//                         {
//                         }
//                         column(InvDiscCaption; InvDiscCaptionLbl)
//                         {
//                         }
//                         column(TotalCaption; TotalCaptionLbl)
//                         {
//                         }
//                         column(PP_RetentionCaption; Text14021101)
//                         {
//                         }
//                         column(PP_BalanceDueCaption; Text14021102)
//                         {
//                         }

//                         trigger OnAfterGetRecord()
//                         begin
//                             OnLineNumber := OnLineNumber + 1;

//                             IF ("Purchase Header"."Tax Area Code" <> '') AND NOT UseExternalTaxEngine THEN
//                                 SalesTaxCalc.AddPurchLine("Purchase Line");

//                             IF "Vendor Item No." <> '' THEN
//                                 ItemNumberToPrint := "Vendor Item No."
//                             ELSE
//                                 ItemNumberToPrint := "No.";
//                             IF Type.AsInteger() = 0 THEN BEGIN
//                                 ItemNumberToPrint := '';
//                                 "Unit of Measure" := '';
//                                 "Line Amount" := 0;
//                                 "Inv. Discount Amount" := 0;
//                                 Quantity := 0;
//                             END;

//                             AmountExclInvDisc := "Line Amount";

//                             IF Quantity = 0 THEN
//                                 UnitPriceToPrint := 0 // so it won't print
//                             ELSE
//                                 UnitPriceToPrint := ROUND(AmountExclInvDisc / Quantity, 0.00001);

//                             IF OnLineNumber = NumberOfLines THEN BEGIN
//                                 PrintFooter := TRUE;

//                                 IF "Purchase Header"."Tax Area Code" <> '' THEN BEGIN
//                                     IF UseExternalTaxEngine THEN
//                                         SalesTaxCalc.CallExternalTaxEngineForPurch("Purchase Header", TRUE)
//                                     ELSE
//                                         SalesTaxCalc.EndSalesTaxCalculation(UseDate);
//                                     SalesTaxCalc.GetSummarizedSalesTaxTable(TempSalesTaxAmtLine);
//                                     BrkIdx := 0;
//                                     PrevPrintOrder := 0;
//                                     PrevTaxPercent := 0;
//                                     TaxAmount := 0;
//                                     WITH TempSalesTaxAmtLine DO BEGIN
//                                         RESET;
//                                         SETCURRENTKEY("Print Order", "Tax Area Code for Key", "Tax Jurisdiction Code");
//                                         IF FIND('-') THEN
//                                             REPEAT
//                                                 IF ("Print Order" = 0) OR
//                                                    ("Print Order" <> PrevPrintOrder) OR
//                                                    ("Tax %" <> PrevTaxPercent)
//                                                 THEN BEGIN
//                                                     BrkIdx := BrkIdx + 1;
//                                                     IF BrkIdx > 1 THEN BEGIN
//                                                         IF TaxArea."Country/Region" = TaxArea."Country/Region"::CA THEN
//                                                             BreakdownTitle := Text006
//                                                         ELSE
//                                                             BreakdownTitle := Text003;
//                                                     END;
//                                                     IF BrkIdx > ARRAYLEN(BreakdownAmt) THEN BEGIN
//                                                         BrkIdx := BrkIdx - 1;
//                                                         BreakdownLabel[BrkIdx] := Text004;
//                                                     END ELSE
//                                                         BreakdownLabel[BrkIdx] := STRSUBSTNO("Print Description", "Tax %");
//                                                 END;
//                                                 BreakdownAmt[BrkIdx] := BreakdownAmt[BrkIdx] + "Tax Amount";
//                                                 TaxAmount := TaxAmount + "Tax Amount";
//                                             UNTIL NEXT = 0;
//                                     END;
//                                     IF BrkIdx = 1 THEN BEGIN
//                                         CLEAR(BreakdownLabel);
//                                         CLEAR(BreakdownAmt);
//                                     END;
//                                 END;
//                             END;
//                         end;

//                         trigger OnPreDataItem()
//                         begin
//                             CurrReport.CREATETOTALS(AmountExclInvDisc, "Line Amount", "Inv. Discount Amount");
//                             NumberOfLines := COUNT;
//                             OnLineNumber := 0;
//                             PrintFooter := FALSE;
//                         end;
//                     }
//                 }

//                 trigger OnAfterGetRecord()
//                 begin
//                     IF CopyNo = NoLoops THEN BEGIN
//                         IF NOT CurrReport.PREVIEW THEN
//                             PurchasePrinted.RUN("Purchase Header");
//                         CurrReport.BREAK;
//                     END;
//                     CopyNo := CopyNo + 1;
//                     IF CopyNo = 1 THEN // Original
//                         CLEAR(CopyTxt)
//                     ELSE
//                         CopyTxt := Text000;
//                     TaxAmount := 0;

//                     CLEAR(BreakdownTitle);
//                     CLEAR(BreakdownLabel);
//                     CLEAR(BreakdownAmt);
//                     TotalTaxLabel := Text008;
//                     IF "Purchase Header"."Tax Area Code" <> '' THEN BEGIN
//                         TaxArea.GET("Purchase Header"."Tax Area Code");
//                         CASE TaxArea."Country/Region" OF
//                             TaxArea."Country/Region"::US:
//                                 TotalTaxLabel := Text005;
//                             TaxArea."Country/Region"::CA:
//                                 TotalTaxLabel := Text007;
//                         END;
//                         UseExternalTaxEngine := TaxArea."Use External Tax Engine";
//                         SalesTaxCalc.StartSalesTaxCalculation;
//                     END;
//                 end;

//                 trigger OnPreDataItem()
//                 begin
//                     NoLoops := 1 + ABS(NoCopies);
//                     IF NoLoops <= 0 THEN
//                         NoLoops := 1;
//                     CopyNo := 0;
//                 end;
//             }

//             trigger OnAfterGetRecord()
//             var
//                 Job: Record Job;
//             begin
//                 IF PrintCompany THEN
//                     IF RespCenter.GET("Responsibility Center") THEN BEGIN
//                         FormatAddress.RespCenter(CompanyAddress, RespCenter);
//                         CompanyInformation."Phone No." := RespCenter."Phone No.";
//                         CompanyInformation."Fax No." := RespCenter."Fax No.";
//                     END;
//                 CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

//                 IF "Purchaser Code" = '' THEN
//                     CLEAR(SalesPurchPerson)
//                 ELSE
//                     SalesPurchPerson.GET("Purchaser Code");

//                 IF "Payment Terms Code" = '' THEN
//                     CLEAR(PaymentTerms)
//                 ELSE
//                     PaymentTerms.GET("Payment Terms Code");

//                 IF "Shipment Method Code" = '' THEN
//                     CLEAR(ShipmentMethod)
//                 ELSE
//                     ShipmentMethod.GET("Shipment Method Code");

//                 FormatAddress.PurchHeaderBuyFrom(BuyFromAddress, "Purchase Header");
//                 FormatAddress.PurchHeaderShipTo(ShipToAddress, "Purchase Header");

//                 IF NOT CurrReport.PREVIEW THEN BEGIN
//                     IF ArchiveDocument THEN
//                         ArchiveManagement.StorePurchDocument("Purchase Header", LogInteraction);

//                     IF LogInteraction THEN BEGIN
//                         CALCFIELDS("No. of Archived Versions");
//                         SegManagement.LogDocument(
//                           13, "No.", "Doc. No. Occurrence", "No. of Archived Versions", DATABASE::Vendor, "Buy-from Vendor No.",
//                           "Purchaser Code", '', "Posting Description", '');
//                     END;
//                 END;

//                 IF "Posting Date" <> 0D THEN
//                     UseDate := "Posting Date"
//                 ELSE
//                     UseDate := WORKDATE;

//                 //ProjectPro - start
//                 PP_RetentionAmount := "NS_Retention Amount (LCY)";
//                 CALCFIELDS("Amount Including VAT");
//                 PP_BalanceDue := "Amount Including VAT" - "NS_Retention Amount (LCY)";
//                 //ProjectPro - end

//                 //ProjectPro - start
//                 IF Job.GET("NS_Job No.") THEN BEGIN
//                     JobName := Job.Description;
//                     JobLocation := Job."NS_Job Site Customer Name";
//                     CustomerAccountName := 'No Customer Account Name';
//                     IF Job."NS_Customer Account" <> '' THEN BEGIN
//                         Contact.SETRANGE("No.", Job."NS_Customer Account");
//                         IF Contact.FINDFIRST THEN
//                             CustomerAccountName := Contact.Name;
//                     END;
//                 END;
//                 //ProjectPro - end
//             end;

//             trigger OnPreDataItem()
//             begin
//                 IF PrintCompany THEN
//                     FormatAddress.Company(CompanyAddress, CompanyInformation)
//                 ELSE
//                     CLEAR(CompanyAddress);
//             end;
//         }
//     }

//     requestpage
//     {
//         SaveValues = true;

//         layout
//         {
//             area(content)
//             {
//                 group(Options)
//                 {
//                     Caption = 'Options';
//                     field(NumberOfCopies; NoCopies)
//                     {
//                         Caption = 'Number of Copies';
//                         ApplicationArea = all;
//                     }
//                     field(PrintCompanyAddress; PrintCompany)
//                     {
//                         Caption = 'Print Company Address';
//                         ApplicationArea = all;
//                     }
//                     field(ArchiveDocument; ArchiveDocument)
//                     {
//                         Caption = 'Archive Document';
//                         Enabled = ArchiveDocumentEnable;
//                         ApplicationArea = all;

//                         trigger OnValidate()
//                         begin
//                             IF NOT ArchiveDocument THEN
//                                 LogInteraction := FALSE;
//                         end;
//                     }
//                     field(LogInteraction; LogInteraction)
//                     {
//                         Caption = 'Log Interaction';
//                         Enabled = LogInteractionEnable;
//                         ApplicationArea = all;

//                         trigger OnValidate()
//                         begin
//                             IF LogInteraction THEN
//                                 ArchiveDocument := ArchiveDocumentEnable;
//                         end;
//                     }
//                 }
//             }
//         }

//         actions
//         {
//         }

//         trigger OnInit()
//         begin
//             LogInteractionEnable := TRUE;
//             ArchiveDocumentEnable := TRUE;
//         end;

//         trigger OnOpenPage()
//         begin
//             ArchiveDocument := ArchiveManagement.PurchaseDocArchiveGranule;
//             LogInteraction := SegManagement.FindInteractTmplCode(13) <> '';

//             ArchiveDocumentEnable := ArchiveDocument;
//             LogInteractionEnable := LogInteraction;
//         end;
//     }

//     labels
//     {
//     }

//     trigger OnPreReport()
//     begin
//         CompanyInformation.GET('');
//         //ProjectPro - start
//         CompanyInformation.CALCFIELDS(Picture);
//         PhoneAndFax := STRSUBSTNO(Text14021400, CompanyInformation."Phone No.", CompanyInformation."Fax No.");
//         //ProjectPro - end
//     end;

//     var
//         UnitPriceToPrint: Decimal;
//         AmountExclInvDisc: Decimal;
//         ShipmentMethod: Record "Shipment Method";
//         PaymentTerms: Record "Payment Terms";
//         SalesPurchPerson: Record "Salesperson/Purchaser";
//         CompanyInformation: Record "Company Information";
//         RespCenter: Record "Responsibility Center";
//         Language: Codeunit Language;
//         TempSalesTaxAmtLine: Record "Sales Tax Amount Line" temporary;
//         TaxArea: Record "Tax Area";
//         Vend: Record Vendor;
//         CompanyAddress: array[8] of Text[50];
//         BuyFromAddress: array[8] of Text[50];
//         ShipToAddress: array[8] of Text[50];
//         CopyTxt: Text[10];
//ItemNumberToPrint: Text[20];   //PRJCTPR-99.JS.1.0 12APR2023 line commented
//ItemNumberToPrint: Text[50];    //PRJCTPR-99.JS.1.0 12APR2023 line added
//         PrintCompany: Boolean;
//         PrintFooter: Boolean;
//         NoCopies: Integer;
//         NoLoops: Integer;
//         CopyNo: Integer;
//         NumberOfLines: Integer;
//         OnLineNumber: Integer;
//         PurchasePrinted: Codeunit "Purch.Header-Printed";
//         FormatAddress: Codeunit "Format Address";
//         SalesTaxCalc: Codeunit "Sales Tax Calculate";
//         ArchiveManagement: Codeunit ArchiveManagement;
//         SegManagement: Codeunit SegManagement;
//         ArchiveDocument: Boolean;
//         LogInteraction: Boolean;
//         TaxAmount: Decimal;
//         TotalTaxLabel: Text[30];
//         BreakdownTitle: Text[30];
//         BreakdownLabel: array[4] of Text[30];
//         BreakdownAmt: array[4] of Decimal;
//         BrkIdx: Integer;
//         PrevPrintOrder: Integer;
//         PrevTaxPercent: Decimal;
//         UseDate: Date;
//         Text000: Label 'COPY';
//         Text003: Label 'Sales Tax Breakdown:';
//         Text004: Label 'Other Taxes';
//         Text005: Label 'Total Sales Tax:';
//         Text006: Label 'Tax Breakdown:';
//         Text007: Label 'Total Tax:';
//         Text008: Label 'Tax:';
//         UseExternalTaxEngine: Boolean;
//         [InDataSet]
//         ArchiveDocumentEnable: Boolean;
//         [InDataSet]
//         LogInteractionEnable: Boolean;
//         ToCaptionLbl: Label 'To:';
//         ReceiveByCaptionLbl: Label 'Receive By';
//         VendorIDCaptionLbl: Label 'Vendor ID';
//         ConfirmToCaptionLbl: Label 'Confirm To';
//         BuyerCaptionLbl: Label 'Buyer';
//         ShipCaptionLbl: Label 'Ship';
//         ToCaption1Lbl: Label 'To:';
//         PurchOrderCaptionLbl: Label 'PURCHASE ORDER';
//         PurchOrderNumCaptionLbl: Label 'Purchase Order Number:';
//         PurchOrderDateCaptionLbl: Label 'Purchase Order Date:';
//         PageCaptionLbl: Label 'Page:';
//         ShipViaCaptionLbl: Label 'Ship Via';
//         TermsCaptionLbl: Label 'Terms';
//         PhoneNoCaptionLbl: Label 'Phone No.';
//         TaxIdentTypeCaptionLbl: Label 'Tax Ident. Type';
//         ItemNoCaptionLbl: Label 'Item No.';
//         UnitCaptionLbl: Label 'Unit';
//         DescriptionCaptionLbl: Label 'Description';
//         QuantityCaptionLbl: Label 'Quantity';
//         UnitPriceCaptionLbl: Label 'Unit Price';
//         TotalPriceCaptionLbl: Label 'Total Price';
//         SubtotalCaptionLbl: Label 'Subtotal:';
//         InvDiscCaptionLbl: Label 'Invoice Discount:';
//         TotalCaptionLbl: Label 'Total:';
//         VendorOrderNoLbl: Label 'Vendor Order No.';
//         VendorInvoiceNoLbl: Label 'Vendor Invoice No.';
//         Text14021101: Label 'Less Retention:';
//         Text14021102: Label 'Balance Due:';
//         PP_RetentionAmount: Decimal;
//         PP_BalanceDue: Decimal;
//         [InDataSet]
//         JobName: Text;
//         [InDataSet]
//         JobLocation: Text;
//         [InDataSet]
//         CustomerAccountName: Text;
//         Contact: Record Contact;
//         PhoneAndFax: Text[1000];
//         Text14021400: Label 'Phone: %1   Fax %2';
// }

//PPDA.1.0 Commented End