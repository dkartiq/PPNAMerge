//PPDA.1.0 Commented Start
// pageextension 14021466 NS_PurchaseStatss extends "Purchase Stats."
// {
//     // version NAVNA11.00,PPNA11.00

//     layout
//     {
//         addafter(TotalAmount2)
//         {
//             field("NS Retention Amount (LCY)"; Rec."NS_Retention Amount (LCY)")
//             {
//                 ApplicationArea = All;
//                 Editable = false;
//                 ToolTip = 'Specifies the Retention Amount (LCY)';
//             }
//             field("NS Final Total"; PP_FinalTotal)
//             {
//                 ApplicationArea = All;
//                 Caption = 'Final Total';

//                 ToolTip = 'Final Total';
//                 Editable = false;
//             }
//         }
//         addafter("Vend.""Balance (LCY)""")
//         {
//             field("NS Retention Balance LCY"; PP_RetentionBalanceLCY)
//             {
//                 ApplicationArea = All;
//                 AutoFormatType = 1;
//                 Caption = 'Retention Balance ($)';

//                 ToolTip = 'Retention Balance ($)';
//                 Editable = false;
//             }
//         }
//     }

//     var
//         PP_JobsSetup: Record "Jobs Setup";
//         PP_RetentionBalanceLCY: Decimal;
//         PP_FinalTotal: Decimal;
//         p: Codeunit "NS_Parameters for Events";

//     trigger OnAfterGetRecord();
//     begin
//        PP_FinalTotal := p.NS_P10043GetNS_FinalTotal(); //PRJCTPR-336.NC.1.0 13Mar2024 Block
//PP_FinalTotal := NS_CalcFinalTotal();//PRJCTPR-336.NC.1.0 13Mar2024
//         PP_RetentionBalanceLCY := p.NS_P10043GetNS_RetentionBalanceLCY();
//     end;

//     /*
//       +------------------------------------------------------------
//       +ProjectPro
//       +  - Added field(s):
//       +     "PP Retention Amount (LCY)"
//       +     "PP Final Total"
//       +     "PP Retention Balance (LCY)"
//       +
//       +  - Added global variable(s):
//       +     PP_JobsSetup
//       +     PP_RetentionBalanceLCY
//       +     PP_FinalTotal
//       +
//       +  - Modification(s):
//       +     - OnOpenPage: get Jobs Setup record
//       +     - OnAfterGetRecord: calculate Retention Balance (LCY) and Final Total
//       +------------------------------------------------------------
//     */
//PRJCTPR-336.NC.1.0 13Mar2024 Start
// local procedure NS_CalcFinalTotal(): Decimal
// var
//     TempPurchLine: Record "Purchase Line" temporary;
//     PurchLine: Record "Purchase Line";
//     TaxArea: Record "Tax Area";
//     SalesTaxCalculate: Codeunit "Sales Tax Calculate";
//     TempSalesTaxLine: Record "Sales Tax Amount Line" temporary;
//     TempSalesTaxAmtLine: Record "Sales Tax Amount Line" temporary;
//     TotalPurchLine: Record "Purchase Line";
//     TotalPurchLineLCY: Record "Purchase Line";
//     PurchPost: Codeunit "Purch.-Post";
//     Vend: Record Vendor;
//     TotalAmount2: Decimal;
//     TaxAmount: Decimal;
//     TotalAmount1: Decimal;
//     TaxAmountText: Text[30];
// begin
//     TaxArea.GET(Rec."Tax Area Code");
//     Vend.Get(Rec."Pay-to Vendor No.");
//     PurchLine.SETRANGE("Document Type", Rec."Document Type");
//     PurchLine.SETRANGE("Document No.", Rec."No.");
//     PurchLine.SETFILTER(Type, '>0');
//     PurchLine.SETFILTER(Quantity, '<>0');
//     IF PurchLine.FIND('-') THEN
//         REPEAT
//             TempPurchLine.COPY(PurchLine);
//             TempPurchLine.INSERT;
//             IF NOT TaxArea."Use External Tax Engine" THEN
//                 SalesTaxCalculate.AddPurchLine(TempPurchLine);
//         UNTIL PurchLine.NEXT = 0;
//     TempSalesTaxLine.DELETEALL;
//     IF TaxArea."Use External Tax Engine" THEN
//         SalesTaxCalculate.CallExternalTaxEngineForPurch(Rec, TRUE)
//     ELSE
//         SalesTaxCalculate.EndSalesTaxCalculation(Rec."Posting Date");
//     SalesTaxCalculate.GetSalesTaxAmountLineTable(TempSalesTaxLine);

//     SalesTaxCalculate.DistTaxOverPurchLines(TempPurchLine);
//     PurchPost.SumPurchLinesTemp(
//       Rec, TempPurchLine, 0, TotalPurchLine, TotalPurchLineLCY, TaxAmount, TaxAmountText);

//     IF Rec."Prices Including VAT" THEN BEGIN
//         TotalAmount2 := TotalPurchLine.Amount;
//         TotalAmount1 := TotalPurchLine."Line Amount" - TotalPurchLine."Inv. Discount Amount";
//     END ELSE BEGIN
//         TotalAmount1 := TotalPurchLine.Amount;
//         TotalAmount2 := TotalPurchLine."Amount Including VAT";
//     END;

//     TotalAmount1 :=
//       TotalPurchLine."Line Amount" - TotalPurchLine."Inv. Discount Amount";
//     TaxAmount := TempSalesTaxLine.GetTotalTaxAmountFCY;
//     IF Rec."Prices Including VAT" THEN
//         TotalAmount2 := TotalPurchLine.Amount
//     ELSE
//         TotalAmount2 := TotalAmount1 + TaxAmount;
//     exit(TotalAmount2 - Rec."NS_Retention Amount (LCY)");
// end;
//PRJCTPR-336.NC.1.0 13Mar2024 End
// }

//PPDA.1.0 Commented End