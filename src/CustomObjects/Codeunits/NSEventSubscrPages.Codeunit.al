codeunit 14021108 "NS_Event Subscr. Pages"
{
    // version SPLN1.00

    // SPLN1.00 DMT 2019-02-04 Created. Custom code of pages.
    //PRJ-148.SK.1.0 Added one more event subscriber from the Page
    //PRJ-153.SK.1.0 Added EventSubscription
    //PRJ-188.SK.1.0 Blocked some code
    //PRJ-196 VT 08-04-20  Event Added and Code Added
    //PRJ-197.AS.1.0 - 15APRIL2020 : Added "Retention LedgerCode Filter" in P151_T21OnBeforeDrillDownEntries() & commented old filter.
    //PRJ-356.MS.1.0 added permission for purch. recpt when post job jnl
    //PRJ-1387.NK.1.0 12May2022 | Add Code
    //PRJ-1348.NK.1.0 24May2022 | Event Added and Code Added
    //PRJ-1571.NK.1.0 17Aug2022 | Event Added and Code Added
    //PRJCTPR-224.VC.1.0 16Nov2023 | Sale Invoice with Foreign Currency
    //PRJCTPR-252.HS.1.0 19Dec2023 | Added EventSubscriber
    //PE-217.DK.1.0 27Dec2023 | Added EventSubscriber
    //PE-217.DK.3.0 23Jan2024 | Code Commented because of issue related to weather Api  
    Permissions = tabledata "Purch. Rcpt. Line" = RIMD;//PRJ-356.MS.1.0
    trigger OnRun()
    begin
    end;

    var
        p: Codeunit "NS_Parameters for Events";
        NS_JobsSetup: Record "Jobs Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        PurchSetup: Record "Purchases & Payables Setup";


    //PRJ-1068.AS.1.0 START
    [EventSubscriber(ObjectType::Page, 1007, 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure NS_PG1007OnAfterValidateEvent(var Rec: Record "Job Planning Line"; var xRec: Record "Job Planning Line")
    var
        JPLRec: Record "Job Planning Line";
        Rec_JobSetup: Record "Jobs Setup"; //PE-323 AT.01 08July2024 Start
    begin
        //PE-323 AT 12july2024 Start
        /*
                JPLRec.reset;
                JPLRec.SetRange("Job No.", Rec."Job No.");
                JPLRec.SetRange("NS_Resource Line No.", Rec."Line No.");
                JPLRec.SetRange("Job Task No.", Rec."Job Task No.");
                if JPLRec.FindFirst() then begin
                    JPLRec.Validate(Quantity, Rec.Quantity * Rec."NS_Labor Hours per Qty.");
                    JPLRec."NS_Labor Hours per Qty." := Rec."NS_Labor Hours per Qty.";
                    JPLRec.Modify();
                end;


                //CJQ-36.PD.1.0 | START
                if JPLRec.FindLast() then begin
                    JPLRec.Validate(Quantity, Rec.Quantity * Rec."NS_Labor Hr Per Qty(Res 2)"); //CJQ-36.PD.1.0
                    JPLRec."NS_Labor Hr Per Qty(Res 2)" := REC."NS_Labor Hr Per Qty(Res 2)"; //CJQ-36.PD.1.0
                    JPLRec.Modify();
                end;
                //CJQ-36.PD.1.0 |END
                */
        //PE-323 AT 12july2024 End
        //PE-323 AT.01 05July2024 start
        if Rec_JobSetup.get then begin
            JPLRec.reset;
            JPLRec.SetRange("Job No.", Rec."Job No.");
            JPLRec.SetRange("NS_Resource Line No.", Rec."Line No.");
            JPLRec.SetRange("Job Task No.", Rec."Job Task No.");
            if not JPLRec.IsEmpty() then
                JPLRec.DeleteAll();
            if Rec_JobSetup."NS_Explode Linked Resource" then begin
                InsertLinkedResourceInProjectPL(Rec);
            end else
                InsertLinkedResourceInProjectPL1(rec);

        end;
        // //PE-323 AT.01 05July2024 End
    end;
    //PRJ-1068.AS.1.0 END

    //PRJ-1068.AS.1.0 START
    [EventSubscriber(ObjectType::Page, 14021217, 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure NS_PG14021217OnAfterValidateEvent(var Rec: Record "Job Planning Line"; var xRec: Record "Job Planning Line")
    var
        JPLRec: Record "Job Planning Line";
    begin
        JPLRec.reset;
        JPLRec.SetRange("Job No.", Rec."Job No.");
        JPLRec.SetRange("NS_Resource Line No.", Rec."Line No.");
        JPLRec.SetRange("Job Task No.", Rec."Job Task No.");
        if JPLRec.FindFirst() then begin
            JPLRec.Validate(Quantity, Rec.Quantity * Rec."NS_Labor Hours per Qty.");
            JPLRec."NS_Labor Hours per Qty." := Rec."NS_Labor Hours per Qty.";
            JPLRec.Modify();
        end;
    end;
    //PRJ-1068.AS.1.0 END


    //PPDA.1.0 Start
    //PRJ-196 VT 08-04-20 begin
    // [EventSubscriber(ObjectType::Page, 10045, 'OnAfterGetRecordEvent', '', false, false)]
    // local procedure NS_P10045OnAfterGetRecordEvent(var Rec: Record "Purch. Inv. Header")
    // var
    //     TaxArea: Record "Tax Area";
    //     Currency: Record Currency;
    //     PurchInvLine: Record "Purch. Inv. Line";
    //     VendAmount: Decimal;
    //     AmountInclVAT: Decimal;
    //     InvDiscAmount: Decimal;
    //     LineQty: Decimal;
    //     TotalNetWeight: Decimal;
    //     TotalGrossWeight: Decimal;
    //     TotalVolume: Decimal;
    //     TotalParcels: Decimal;
    //     TaxPercentage: Decimal;
    //     TaxAmount: Decimal;
    //     AmountLCY: Decimal;
    //     CurrExchRate: Record "Currency Exchange Rate";
    //     Vend: Record Vendor;
    //     SalesTaxCalculate: Codeunit "Sales Tax Calculate";
    //     TempSalesTaxLine: Record "Sales Tax Amount Line" temporary;
    //     TempSalesTaxAmtLine: Record "Sales Tax Amount Line" temporary;
    //     BreakdownTitle: Text[35];
    //     Text006: Label 'Tax Breakdown:';
    //     Text007: Label 'Sales Tax Breakdown:';
    //     Text008: Label 'Other Taxes';
    //     PrevPrintOrder: Integer;
    //     PrevTaxPercent: Decimal;
    //     BrkIdx: Integer;
    //     BreakdownAmt: array[4] of Decimal;
    //     BreakdownLabel: array[4] of Text[30];

    // begin
    //     CLEARALL;
    //     TaxArea.GET(Rec."Tax Area Code");

    //     IF Rec."Currency Code" = '' THEN
    //         Currency.InitRoundingPrecision
    //     ELSE
    //         Currency.GET(Rec."Currency Code");

    //     PurchInvLine.SETRANGE("Document No.", Rec."No.");

    //     IF PurchInvLine.FIND('-') THEN
    //         REPEAT
    //             VendAmount := VendAmount + PurchInvLine.Amount;
    //             AmountInclVAT := AmountInclVAT + PurchInvLine."Amount Including VAT";
    //             IF Rec."Prices Including VAT" THEN
    //                 InvDiscAmount := InvDiscAmount + PurchInvLine."Inv. Discount Amount" / (1 + PurchInvLine."VAT %" / 100)
    //             ELSE
    //                 InvDiscAmount := InvDiscAmount + PurchInvLine."Inv. Discount Amount";
    //             LineQty := LineQty + PurchInvLine.Quantity;
    //             TotalNetWeight := TotalNetWeight + (PurchInvLine.Quantity * PurchInvLine."Net Weight");
    //             TotalGrossWeight := TotalGrossWeight + (PurchInvLine.Quantity * PurchInvLine."Gross Weight");
    //             TotalVolume := TotalVolume + (PurchInvLine.Quantity * PurchInvLine."Unit Volume");
    //             IF PurchInvLine."Units per Parcel" > 0 THEN
    //                 TotalParcels := TotalParcels + ROUND(PurchInvLine.Quantity / PurchInvLine."Units per Parcel", 1, '>');
    //             IF PurchInvLine."VAT %" <> TaxPercentage THEN
    //                 IF TaxPercentage = 0 THEN
    //                     TaxPercentage := PurchInvLine."VAT %"
    //                 ELSE
    //                     TaxPercentage := -1;
    //         UNTIL PurchInvLine.NEXT = 0;
    //     TaxAmount := AmountInclVAT - VendAmount;
    //     InvDiscAmount := ROUND(InvDiscAmount, Currency."Amount Rounding Precision");

    //     IF Rec."Currency Code" = '' THEN
    //         AmountLCY := VendAmount
    //     ELSE
    //         AmountLCY :=
    //           CurrExchRate.ExchangeAmtFCYToLCY(
    //             WORKDATE, Rec."Currency Code", VendAmount, Rec."Currency Factor");

    //     IF NOT Vend.GET(Rec."Pay-to Vendor No.") THEN
    //         CLEAR(Vend);
    //     Vend.CALCFIELDS("Balance (LCY)");

    //     AmountInclVAT := VendAmount;
    //     TaxAmount := 0;
    //     SalesTaxCalculate.StartSalesTaxCalculation;
    //     TempSalesTaxLine.DELETEALL;
    //     IF TaxArea."Use External Tax Engine" THEN
    //         SalesTaxCalculate.CallExternalTaxEngineForDoc(DATABASE::"Purch. Inv. Header", 0, Rec."No.")
    //     ELSE BEGIN
    //         SalesTaxCalculate.AddPurchInvoiceLines(Rec."No.");
    //         SalesTaxCalculate.EndSalesTaxCalculation(Rec."Posting Date");
    //     END;
    //     SalesTaxCalculate.GetSalesTaxAmountLineTable(TempSalesTaxLine);
    //     SalesTaxCalculate.GetSummarizedSalesTaxTable(TempSalesTaxAmtLine);
    //     IF TaxArea."Country/Region" = TaxArea."Country/Region"::CA THEN
    //         BreakdownTitle := Text006
    //     ELSE
    //         BreakdownTitle := Text007;
    //     WITH TempSalesTaxAmtLine DO BEGIN
    //         RESET;
    //         SETCURRENTKEY("Print Order", "Tax Area Code for Key", "Tax Jurisdiction Code");
    //         IF FINDSET THEN BEGIN
    //             REPEAT
    //                 IF ("Print Order" = 0) OR
    //                    ("Print Order" <> PrevPrintOrder) OR
    //                    ("Tax %" <> PrevTaxPercent)
    //                 THEN BEGIN
    //                     BrkIdx := BrkIdx + 1;
    //                     IF BrkIdx > ARRAYLEN(BreakdownAmt) THEN BEGIN
    //                         BrkIdx := BrkIdx - 1;
    //                         BreakdownLabel[BrkIdx] := Text008;
    //                     END ELSE
    //                         BreakdownLabel[BrkIdx] := STRSUBSTNO("Print Description", "Tax %");
    //                 END;
    //                 BreakdownAmt[BrkIdx] := BreakdownAmt[BrkIdx] + "Tax Amount";
    //                 TaxAmount := TaxAmount + "Tax Amount";
    //             UNTIL NEXT = 0;
    //             AmountInclVAT := AmountInclVAT + TaxAmount;
    //         END;
    //     END;
    //     p.NS_P10045SetNS_FinalTotal(AmountInclVAT - Rec."NS_Retention Amount (LCY)"); //PRJ-196 VT 08-04-20
    // end;
    //PPDA.1.0 End

    //PRJ-196 VT 08-04-20 end


    //PPDA.1.0 Start
    // [EventSubscriber(ObjectType::Page, 10043, 'OnAfterGetRecordEvent', '', false, false)]
    // local procedure NS_P10043OnAfterGetRecordEvent(var Rec: Record "Purchase Header")
    // var
    //     Vend: Record Vendor;
    //     TotalAmount2: Decimal;
    //     PurchLine: Record "Purchase Line";
    //     TempPurchLine: Record "Purchase Line" temporary;
    //     TempSalesTaxAmtLine: Record "Sales Tax Amount Line" temporary;
    //     TaxArea: Record "Tax Area";
    //     SalesTaxCalculate: Codeunit "Sales Tax Calculate";
    //     TempSalesTaxLine: Record "Sales Tax Amount Line" temporary;
    //     PurchPost: Codeunit "Purch.-Post";
    //     TotalPurchLine: Record "Purchase Line";
    //     TotalPurchLineLCY: Record "Purchase Line";
    //     TaxAmount: Decimal;
    //     TaxAmountText: Text;
    //     TotalAmount1: Decimal;
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

    //     //PRJ-196 VT 07-04-20 begin

    //     TotalAmount1 :=
    //       TotalPurchLine."Line Amount" - TotalPurchLine."Inv. Discount Amount";
    //     TaxAmount := TempSalesTaxLine.GetTotalTaxAmountFCY;
    //     IF Rec."Prices Including VAT" THEN
    //         TotalAmount2 := TotalPurchLine.Amount
    //     ELSE
    //         TotalAmount2 := TotalAmount1 + TaxAmount;

    //     //PRJ-196 VT 07-04-20 end

    //     p.NS_P10043SetNS_RetentionBalanceLCY(0);
    //     IF Vend."No." <> '' THEN BEGIN
    //         PurchSetup.Get();
    //         IF NOT PurchSetup."NS_Purchase Retention Inactive" THEN BEGIN
    //             Vend.SETRANGE("NS_Retention Ledger CodeFilter", NS_JobsSetup."NS_Retention Payable Ledger");
    //             Vend.CALCFIELDS("Balance (LCY)");
    //             p.NS_P10043SetNS_RetentionBalanceLCY(Vend."Balance (LCY)");
    //             Vend.SETRANGE("NS_Retention Ledger CodeFilter", PurchSetup."NS_Normal Vendor Ledger No.");
    //         END;
    //         Vend.CALCFIELDS("Balance (LCY)")
    //     END;
    //     //p.NS_10043Setpp_FinalTotal(TotalAmount2 - Rec."Retention Amount (LCY)"); //PRJ-196 VT 07-04-20 Commented

    //     p.NS_p10043SetNS_FinalTotal((TotalAmount2) - Rec."NS_Retention Amount (LCY)"); //PRJ-196 VT 07-04-20
    // end;
    //PPDA.1.0 End



    //PPDA.1.0 Start
    // //PPNA17.0 Opened Start OnUpdateHeaderInfoTotalAmount2 
    // [EventSubscriber(ObjectType::Page, 10042, 'OnUpdateHeaderInfoOnAfterCalcTotalAmount', '', false, false)]
    // local procedure NS_P10042OnUpdateHeaderInfoTotalAmount2(VAR TotalAmount2: Decimal; TotalAmount1: Decimal; TaxAmount: Decimal; SalesHeader: Record "Sales Header")
    // begin
    //     if not SalesHeader."Prices Including VAT" then begin
    //         NS_JobsSetup.Get();
    //         IF (NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" =
    //             NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"2 - Calc tax on sale then apply retention determined by progress billing") OR
    //            (NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" =
    //             NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing") THEN
    //             TotalAmount2 := TotalAmount1 + TaxAmount - SalesHeader."NS_Retention Amount (LCY)";
    //     end;
    // end;
    //PPNA17.0 Opened End
    //PPDA.1.0 End




    //PPDA.1.0 Start
    // [EventSubscriber(ObjectType::Page, 10042, 'OnAfterGetRecordEvent', '', false, false)]
    // local procedure NS_P10042OnAfterGetRecordEvent(var Rec: Record "Sales Header")
    // var
    //     SalesLine: Record "Sales Line";
    //     TempSalesLine: Record "Sales Line" temporary;
    //     TempSalesTaxAmtLine: Record "Sales Tax Amount Line" temporary;
    //     TaxArea: Record "Tax Area";
    //     SalesTaxCalculate: Codeunit "Sales Tax Calculate";
    //     TempSalesTaxLine: Record "Sales Tax Amount Line" temporary;
    //     SalesTaxCalculationOverridden: Boolean;
    //     SalesPost: Codeunit "Sales-Post";
    //     TotalAmount1: Decimal;
    //     TotalSalesLine: Record "Sales Line";
    //     TotalSalesLineLCY: Record "Sales Line";
    //     TaxAmount: Decimal;
    //     TaxAmountText: Text;
    //     ProfitLCY: Decimal;
    //     ProfitPct: Decimal;
    //     TotalAdjCostLCY: Decimal;
    //     TotalAmount2: Decimal;
    //     Cust: Record customer;
    // begin
    //     TaxArea.Get(Rec."Tax Area Code");
    //     Cust.Get(Rec."Sell-to Customer No.");
    //     SalesLine.SETRANGE("Document Type", Rec."Document Type");
    //     SalesLine.SETRANGE("Document No.", Rec."No.");
    //     SalesLine.SETFILTER(Type, '>0');
    //     SalesLine.SETFILTER(Quantity, '<>0');
    //     IF SalesLine.FIND('-') THEN
    //         REPEAT
    //             TempSalesLine.COPY(SalesLine);
    //             TempSalesLine.INSERT;
    //             IF NOT TaxArea."Use External Tax Engine" THEN
    //                 SalesTaxCalculate.AddSalesLine(TempSalesLine);
    //         UNTIL SalesLine.NEXT = 0;
    //     TempSalesTaxLine.DELETEALL;

    //     //  OnBeforeCalculateSalesTaxSalesStats(Rec, TempSalesTaxLine, TempSalesTaxAmtLine, SalesTaxCalculationOverridden);

    //     IF NOT SalesTaxCalculationOverridden THEN BEGIN
    //         IF TaxArea."Use External Tax Engine" THEN
    //             SalesTaxCalculate.CallExternalTaxEngineForSales(Rec, TRUE)
    //         ELSE
    //             SalesTaxCalculate.EndSalesTaxCalculation(Rec."Posting Date");

    //         SalesTaxCalculate.GetSalesTaxAmountLineTable(TempSalesTaxLine);
    //         SalesTaxCalculate.DistTaxOverSalesLines(TempSalesLine);
    //     END;

    //     SalesPost.SumSalesLinesTemp(
    //       Rec, TempSalesLine, 0, TotalSalesLine, TotalSalesLineLCY,
    //       TaxAmount, TaxAmountText, ProfitLCY, ProfitPct, TotalAdjCostLCY);

    //     IF Rec."Prices Including VAT" THEN BEGIN
    //         TotalAmount2 := TotalSalesLine.Amount;
    //         TotalAmount1 := TotalAmount2 + TaxAmount;
    //         TotalSalesLine."Line Amount" := TotalAmount1 + TotalSalesLine."Inv. Discount Amount";
    //     END ELSE BEGIN
    //         TotalAmount1 := TotalSalesLine.Amount;
    //         TotalAmount2 := TotalSalesLine."Amount Including VAT";
    //     END;
    //     p.NS_P10042SetNS_RetentionBalanceLCY(0);
    //     IF Cust."No." <> '' THEN BEGIN
    //         SalesSetup.Get();
    //         NS_JobsSetup.Get();
    //         IF NOT SalesSetup."NS_Sales Retention Inactive" THEN BEGIN
    //             Cust.SETRANGE("NS_Retention Ledger CodeFilter", NS_JobsSetup."NS_Retention Receivable Ledger");
    //             Cust.CALCFIELDS("Balance (LCY)");
    //             p.NS_P10042SetNS_RetentionBalanceLCY(Cust."Balance (LCY)");
    //             Cust.SETRANGE("NS_Retention Ledger CodeFilter", SalesSetup."NS_Normal Customer Ledger No.");
    //         END;
    //         //ProjectPro - end
    //         Cust.CALCFIELDS("Balance (LCY)")
    //     END;
    //     p.NS_P10042SetNS_FinalTotal(TotalAmount2 - Rec."NS_Retention Amount (LCY)");
    // end;
    //PPDA.1.0 End



    //PPDA.1.0 Start
    // [EventSubscriber(ObjectType::Page, 10041, 'OnAfterGetRecordAfterCust', '', false, false)]
    // [EventSubscriber(ObjectType::Page, 10041, 'OnAfterGetRecordEvent', '', false, false)]
    // local procedure NS_P10041OnAfterGetRecordEvent(var Rec: Record "Sales Invoice Header")
    // var
    //     TaxArea: Record "Tax Area";
    //     Currency: Record Currency;
    //     SalesInvLine: Record "Sales Invoice Line";
    //     CostCalcMgt: Codeunit "Cost Calculation Management";
    //     TempSalesTaxAmtLine: Record "Sales Tax Amount Line" temporary;
    //     PrevPrintOrder: Integer;
    //     PrevTaxPercent: Decimal;
    //     CustAmount: Decimal;
    //     AmountInclTax: Decimal;
    //     InvDiscAmount: Decimal;
    //     CostLCY: Decimal;
    //     LineQty: Decimal;
    //     TotalNetWeight: Decimal;
    //     TotalGrossWeight: Decimal;
    //     TotalVolume: Decimal;
    //     TotalParcels: Decimal;
    //     TaxPercentage: Decimal;
    //     TotalAdjCostLCY: Decimal;
    //     TaxAmount: Decimal;
    //     AmountLCY: Decimal;
    //     Cust: Record customer;
    //     CurrExchRate: Record "Currency Exchange Rate";
    //     ProfitLCY: Decimal;
    //     ProfitPct: Decimal;
    //     AdjProfitLCY: Decimal;
    //     AdjProfitPct: Decimal;
    // begin
    //     TaxArea.GET(Rec."Tax Area Code");

    //     IF Rec."Currency Code" = '' THEN
    //         Currency.InitRoundingPrecision
    //     ELSE
    //         Currency.GET(Rec."Currency Code");

    //     SalesInvLine.SETRANGE("Document No.", Rec."No.");

    //     IF SalesInvLine.FIND('-') THEN
    //         REPEAT
    //             CustAmount := CustAmount + SalesInvLine.Amount;
    //PRJCTPR-320.NC.1.0 01Mar2024 Start
    // if Rec."NS_Multiple Retention on Lines" then begin
    // if NS_JobsSetup.Get() then;
    // if NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" = NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing" then
    //    AmountInclTax := AmountInclTax + (SalesInvLine."Amount Including VAT" + SalesInvLine."NS_Retention Amount")
    // end else
    //PRJCTPR-320.NC.1.0 01Mar2024 End
    //             AmountInclTax := AmountInclTax + SalesInvLine."Amount Including VAT";
    //             IF Rec."Prices Including VAT" THEN
    //                 InvDiscAmount := InvDiscAmount + SalesInvLine."Inv. Discount Amount" / (1 + SalesInvLine."VAT %" / 100)
    //             ELSE
    //                 InvDiscAmount := InvDiscAmount + SalesInvLine."Inv. Discount Amount";
    //             CostLCY := CostLCY + (SalesInvLine.Quantity * SalesInvLine."Unit Cost (LCY)");
    //             LineQty := LineQty + SalesInvLine.Quantity;
    //             TotalNetWeight := TotalNetWeight + (SalesInvLine.Quantity * SalesInvLine."Net Weight");
    //             TotalGrossWeight := TotalGrossWeight + (SalesInvLine.Quantity * SalesInvLine."Gross Weight");
    //             TotalVolume := TotalVolume + (SalesInvLine.Quantity * SalesInvLine."Unit Volume");
    //             IF SalesInvLine."Units per Parcel" > 0 THEN
    //                 TotalParcels := TotalParcels + ROUND(SalesInvLine.Quantity / SalesInvLine."Units per Parcel", 1, '>');
    //             IF SalesInvLine."VAT %" <> TaxPercentage THEN
    //                 IF TaxPercentage = 0 THEN
    //                     TaxPercentage := SalesInvLine."VAT %"
    //                 ELSE
    //                     TaxPercentage := -1;
    //             TotalAdjCostLCY := TotalAdjCostLCY + CostCalcMgt.CalcSalesInvLineCostLCY(SalesInvLine);
    //         UNTIL SalesInvLine.NEXT = 0;
    //     TaxAmount := AmountInclTax - CustAmount;
    //     InvDiscAmount := ROUND(InvDiscAmount, Currency."Amount Rounding Precision");

    //     IF Rec."Currency Code" = '' THEN
    //         AmountLCY := CustAmount
    //     ELSE
    //         AmountLCY :=
    //           CurrExchRate.ExchangeAmtFCYToLCY(
    //             WORKDATE, Rec."Currency Code", CustAmount, Rec."Currency Factor");
    //     ProfitLCY := AmountLCY - CostLCY;
    //     IF AmountLCY <> 0 THEN
    //         ProfitPct := ROUND(100 * ProfitLCY / AmountLCY, 0.1);

    //     AdjProfitLCY := AmountLCY - TotalAdjCostLCY;
    //     IF AmountLCY <> 0 THEN
    //         AdjProfitPct := ROUND(100 * AdjProfitLCY / AmountLCY, 0.1);

    //     IF Cust.GET(Rec."Bill-to Customer No.") THEN;
    //     NS_JobsSetup.Get();
    //     p.NS_P10041SetNS_RetentionBalanceLCY(0);
    //     p.NS_p10041SetAmountInclTax(AmountInclTax);
    //     p.NS_p10041SetTaxAmount(TaxAmount);

    //     IF Cust."No." <> '' THEN BEGIN
    //         SalesSetup.Get();
    //         IF NOT SalesSetup."NS_Sales Retention Inactive" THEN BEGIN
    //             Cust.SETRANGE("NS_Retention Ledger CodeFilter", NS_JobsSetup."NS_Retention Receivable Ledger");
    //             Cust.CALCFIELDS("Balance (LCY)");
    //             p.NS_p10041SetNS_RetentionBalanceLCY(Cust."Balance (LCY)");
    //             Cust.SETRANGE("NS_Retention Ledger CodeFilter", SalesSetup."NS_Normal Customer Ledger No.");
    //         END;
    //         Cust.CALCFIELDS("Balance (LCY)")
    //     END;

    //     IF NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" <> NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing" THEN BEGIN
    //         IF TaxAmount = 0 THEN
    //             p.NS_p10041SetAmountInclTax(AmountInclTax - Rec."NS_Retention Amount");
    //         IF (TaxAmount <> 0) AND (Rec."NS_Retention Amount" > 0) THEN
    //             p.NS_p10041SetTaxAmount(TaxAmount + Rec."NS_Retention Amount");
    //     END;
    //     p.NS_p10041Setns_FinalTotal(AmountInclTax - Rec."NS_Retention Amount (LCY)");
    // end;
    //PPDA.1.0 End



    //PPDA.1.0 Start
    // //PRJ-09-TY
    // //[EventSubscriber(ObjectType::Page, 10039, 'OnAfterGetReccordAfterVend', '', false, false)]
    // [EventSubscriber(ObjectType::Page, 10039, 'OnAfterGetRecordEvent', '', false, false)]
    // local procedure NS_P10039OnAfterGetRecordEvent(var Rec: Record "Purchase Header")
    // var
    //     PurchLine: Record "Purchase Line";
    //     TempPurchLine: Record "Purchase Line" temporary;
    //     PurchPostPrepmt: Codeunit "Purchase-Post Prepayments";
    //     TempSalesTaxAmtLine: Record "Sales Tax Amount Line" temporary;
    //     PrevPrintOrder: Integer;
    //     PrevTaxPercent: Decimal;
    //     TotalPurchLine: Array[3] of Record "Purchase Line";
    //     TotalPurchLineLCY: array[3] of Record "Purchase Line";
    //     BreakdownLabel: array[3, 4] of Text;
    //     BreakdownAmt: array[3, 4] of Decimal;
    //     i: Integer;
    //     PurchPost: Codeunit "Purch.-Post";
    //     SalesTaxCalculate: Codeunit "Sales Tax Calculate";
    //     TempSalesTaxLine1: Record "Sales Tax Amount Line" temporary;
    //     TempSalesTaxLine2: Record "Sales Tax Amount Line" temporary;
    //     TempSalesTaxLine3: Record "Sales Tax Amount Line" temporary;
    //     VATAmount: array[3] of Decimal;
    //     VATAmountText: array[3] of Text;
    //     TotalAmount1: array[3] of Decimal;
    //     TotalAmount2: array[3] of Decimal;
    //     BrkIdx: Integer;
    //     TaxArea: Record "Tax Area";
    //     BreakdownTitle: Text;
    //     Text1020010: Label 'Tax Breakdown:';
    //     Text1020011: Label 'Sales Tax Breakdown:';
    //     Text1020012: Label 'Other Taxes';
    //     TempVATAmountLine4: Record "VAT Amount Line" temporary;
    //     PrepmtTotalAmount: Decimal;
    //     PrepmtVATAmount: Decimal;
    //     PrepmtVATAmountText: Text;
    //     PrepmtInvPct: Decimal;
    //     PrepmtDeductedPct: Decimal;
    //     PrepmtTotalAmount2: Decimal;
    //     Vend: Record vendor;
    // begin
    //     TaxArea.GET(rec."Tax Area Code");
    //     IF Vend.GET(Rec."Pay-to Vendor No.") THEN;
    //     CLEAR(PurchLine);
    //     CLEAR(TotalPurchLine);
    //     CLEAR(TotalPurchLineLCY);
    //     CLEAR(BreakdownLabel);
    //     CLEAR(BreakdownAmt);

    //     PurchLine.RESET;

    //     FOR i := 1 TO 3 DO BEGIN
    //         TempPurchLine.DELETEALL;
    //         CLEAR(TempPurchLine);
    //         CLEAR(PurchPost);
    //         PurchPost.GetPurchLines(Rec, TempPurchLine, i - 1);
    //         CLEAR(PurchPost);
    //         SalesTaxCalculate.StartSalesTaxCalculation;
    //         TempPurchLine.SETFILTER(Type, '>0');
    //         TempPurchLine.SETFILTER(Quantity, '<>0');
    //         IF TempPurchLine.FIND('-') THEN
    //             REPEAT
    //                 SalesTaxCalculate.AddPurchLine(TempPurchLine);
    //             UNTIL TempPurchLine.NEXT = 0;
    //         TempPurchLine.RESET;
    //         CASE i OF
    //             1:
    //                 BEGIN
    //                     TempSalesTaxLine1.DELETEALL;
    //                     SalesTaxCalculate.EndSalesTaxCalculation(Rec."Posting Date");
    //                     SalesTaxCalculate.GetSalesTaxAmountLineTable(TempSalesTaxLine1);
    //                 END;
    //             2:
    //                 BEGIN
    //                     TempSalesTaxLine2.DELETEALL;
    //                     SalesTaxCalculate.EndSalesTaxCalculation(Rec."Posting Date");
    //                     SalesTaxCalculate.GetSalesTaxAmountLineTable(TempSalesTaxLine2);
    //                 END;
    //             3:
    //                 BEGIN
    //                     TempSalesTaxLine3.DELETEALL;
    //                     SalesTaxCalculate.EndSalesTaxCalculation(Rec."Posting Date");
    //                     SalesTaxCalculate.GetSalesTaxAmountLineTable(TempSalesTaxLine3);
    //                 END;
    //         END;

    //         IF Rec.Status = Rec.Status::Open THEN
    //             SalesTaxCalculate.DistTaxOverPurchLines(TempPurchLine);
    //         PurchPost.SumPurchLinesTemp(
    //           Rec, TempPurchLine, i - 1, TotalPurchLine[i], TotalPurchLineLCY[i],
    //           VATAmount[i], VATAmountText[i]);
    //         TotalAmount1[i] := TotalPurchLine[i].Amount;
    //         TotalAmount2[i] := TotalAmount1[i];
    //         VATAmount[i] := 0;

    //         SalesTaxCalculate.GetSummarizedSalesTaxTable(TempSalesTaxAmtLine);
    //         BrkIdx := 0;
    //         PrevPrintOrder := 0;
    //         PrevTaxPercent := 0;
    //         IF TaxArea."Country/Region" = TaxArea."Country/Region"::CA THEN
    //             BreakdownTitle := Text1020010
    //         ELSE
    //             BreakdownTitle := Text1020011;
    //         WITH TempSalesTaxAmtLine DO BEGIN
    //             RESET;
    //             SETCURRENTKEY("Print Order", "Tax Area Code for Key", "Tax Jurisdiction Code");
    //             IF FIND('-') THEN
    //                 REPEAT
    //                     IF ("Print Order" = 0) OR
    //                        ("Print Order" <> PrevPrintOrder) OR
    //                        ("Tax %" <> PrevTaxPercent)
    //                     THEN BEGIN
    //                         BrkIdx := BrkIdx + 1;
    //                         IF BrkIdx > ARRAYLEN(BreakdownAmt, 2) THEN BEGIN
    //                             BrkIdx := BrkIdx - 1;
    //                             BreakdownLabel[i, BrkIdx] := Text1020012;
    //                         END ELSE
    //                             BreakdownLabel[i, BrkIdx] := STRSUBSTNO("Print Description", "Tax %");
    //                     END;
    //                     BreakdownAmt[i, BrkIdx] := BreakdownAmt[i, BrkIdx] + "Tax Amount";
    //                     VATAmount[i] := VATAmount[i] + "Tax Amount";
    //                 UNTIL NEXT = 0;
    //             TotalAmount2[i] := TotalAmount2[i] + VATAmount[i];
    //         END;
    //     END;
    //     TempPurchLine.DELETEALL;
    //     CLEAR(TempPurchLine);
    //     PurchPostPrepmt.GetPurchLines(Rec, 0, TempPurchLine);
    //     PurchPostPrepmt.SumPrepmt(
    //       Rec, TempPurchLine, TempVATAmountLine4, PrepmtTotalAmount, PrepmtVATAmount, PrepmtVATAmountText);
    //     PrepmtInvPct :=
    //       NS_Pct(TotalPurchLine[1]."Prepmt. Amt. Inv.", PrepmtTotalAmount);
    //     PrepmtDeductedPct :=
    //       NS_Pct(TotalPurchLine[1]."Prepmt Amt Deducted", TotalPurchLine[1]."Prepmt. Amt. Inv.");
    //     IF Rec."Prices Including VAT" THEN BEGIN
    //         PrepmtTotalAmount2 := PrepmtTotalAmount;
    //         PrepmtTotalAmount := PrepmtTotalAmount + PrepmtVATAmount;
    //     END ELSE
    //         PrepmtTotalAmount2 := PrepmtTotalAmount + PrepmtVATAmount;

    //     p.NS_p10039SetPPFinalTotal(0);
    //     p.NS_p10039SetNS_RetentionBalanceLCY(0);
    //     IF Vend."No." <> '' THEN BEGIN
    //         PurchSetup.Get();
    //         NS_JobsSetup.Get();
    //         IF Rec."NS_Retention Percent" <> 0 THEN BEGIN
    //             Rec.VALIDATE("NS_Retention Percent");
    //             Rec.VALIDATE("NS_Retention Date");
    //         END ELSE
    //             IF Rec."NS_Retention Amount (LCY)" <> 0 THEN BEGIN
    //                 Rec.VALIDATE("NS_Retention Amount (LCY)");
    //                 Rec.VALIDATE("NS_Retention Date");
    //             END;
    //         IF NOT PurchSetup."NS_Purchase Retention Inactive" THEN BEGIN
    //             Vend.SETRANGE("NS_Retention Ledger CodeFilter", NS_JobsSetup."NS_Retention Payable Ledger");
    //             Vend.CALCFIELDS("Balance (LCY)");
    //             p.NS_p10039Setns_RetentionBalanceLCY(Vend."Balance (LCY)");
    //             Vend.SETRANGE("NS_Retention Ledger CodeFilter", PurchSetup."NS_Normal Vendor Ledger No.");
    //         END;
    //         Vend.CALCFIELDS("Balance (LCY)")
    //     end;
    //     p.NS_p10039SetPPFinalTotal(TotalAmount2[1] - Rec."NS_Retention Amount (LCY)");
    // end;
    //PRJ-09-TY
    //PPDA.1.0 End


    //PPDA.1.0 Start
    //PPNA17.0 Opened Start OnAfterGetReccordAfterCust 
    //PRJ-148.SK.1.0 Start 
    // [EventSubscriber(ObjectType::Page, 10038, 'OnAfterGetRecordOnBeforeCalcCreditLimit', '', false, false)]
    // local procedure NS_P10038OnAfterGetReccordAfterCust(var Customer: Record Customer; SalesHeader: Record "Sales Header"; TotalAmount2: array[3] of Decimal)
    // begin
    //     p.NS_P10038SetPPFinalTotal(0);
    //     p.NS_p10038Setns_RetentionBalanceLCY(0);
    //     IF Customer."No." <> '' THEN BEGIN
    //         SalesSetup.Get();
    //         NS_JobsSetup.Get();
    //         IF NOT SalesSetup."NS_Sales Retention Inactive" THEN BEGIN
    //             Customer.SETRANGE("NS_Retention Ledger CodeFilter", NS_JobsSetup."NS_Retention Receivable Ledger");
    //             Customer.CALCFIELDS("Balance (LCY)");
    //             p.NS_p10038Setns_RetentionBalanceLCY(Customer."Balance (LCY)");
    //             Customer.SETRANGE("NS_Retention Ledger CodeFilter", SalesSetup."NS_Normal Customer Ledger No.");
    //         END;
    //         Customer.CALCFIELDS("Balance (LCY)")
    //     end;
    //     p.NS_p10038SetPPFinalTotal(TotalAmount2[1] - SalesHeader."NS_Retention Amount (LCY)");
    // end;
    //PRJ-148.SK.1.0 End
    //PPNA17.0 Opened End
    //PPDA.1.0 End


    //PPDA.1.0 Start
    // //PPNA17.0 Opened Start OnCalculateVendor1099BeforeFind 
    // [EventSubscriber(ObjectType::Page, 10016, 'OnCalculateVendor1099OnAfterSetFilters', '', false, false)]
    // local procedure NS_P10016OnCalculateVendor1099BeforeFind(VAR PaymentEntry: Record "Vendor Ledger Entry")
    // begin
    //     PurchSetup.Get();
    //     IF NOT PurchSetup."NS_Purchase Retention Inactive" THEN
    //         PaymentEntry.SETRANGE("NS_Retention Ledger Code", PaymentEntry."NS_Retention Ledger Code");
    // end;
    // //PPNA17.0 Opened End
    //PPDA.1.0 End


    //PPDA.1.0 Start
    // //[EventSubscriber(ObjectType::Page, 10007, 'OnAfterOpenPage', '', false, false)]
    // [EventSubscriber(ObjectType::Page, 10007, 'OnOpenPageEvent', '', false, false)]
    // local procedure NS_P1007OnOpenPageEvent(var Rec: Record Customer)
    // var
    //     i: Integer;
    //     LatestCustLedgerEntry: Record "Cust. Ledger Entry";
    //     CustLedgerEntry: array[4] of Record "Cust. Ledger Entry";
    //     Page10007: page "Customer Credit Information";
    // begin
    //     LatestCustLedgerEntry.RESET;
    //     LatestCustLedgerEntry.SETCURRENTKEY("Document Type", "Customer No.", "Posting Date");
    //     LatestCustLedgerEntry.SETRANGE("Document Type", LatestCustLedgerEntry."Document Type"::Payment);
    //     FOR I := 1 TO ARRAYLEN(CustLedgerEntry) DO BEGIN
    //         CustLedgerEntry[I].RESET;
    //         CustLedgerEntry[I].SETCURRENTKEY("Customer No.", Open, Positive, "Due Date");
    //         CustLedgerEntry[I].SETRANGE(Open, TRUE);
    //     END;
    //     // Turn off editability on Certain fields by default
    //     Page10007.OnCreditManagementForm(FALSE);
    //     SalesSetup.GET;
    //     IF NOT SalesSetup."NS_Sales Retention Inactive" THEN
    //         LatestCustLedgerEntry.SETRANGE("NS_Retention Ledger Code", SalesSetup."NS_Normal Customer Ledger No.");

    //     FOR i := 1 TO ARRAYLEN(CustLedgerEntry) DO BEGIN
    //         IF NOT SalesSetup."NS_Sales Retention Inactive" THEN
    //             CustLedgerEntry[i].SETRANGE("NS_Retention Ledger Code", SalesSetup."NS_Normal Customer Ledger No.");
    //     END;

    // end;
    //PPDA.1.0 End


    //PPNA17.0 Opened Start OnIsShowRecBeforeExit 
    [EventSubscriber(ObjectType::Page, 5859, 'OnAfterIsShowRec', '', false, false)]
    local procedure NS_P5859OnIsShowRecBeforeExit(var Result: Boolean; PurchCrMemoLine2: Record "Purch. Cr. Memo Line")
    begin
        IF PurchCrMemoLine2.Type <> PurchCrMemoLine2.Type::Item THEN
            Result := true
        else
            Result := false;
    end;
    //PPNA17.0 Opened End

    [EventSubscriber(ObjectType::Page, 5854, 'OnBeforeIsShowRec', '', false, false)]
    local procedure NS_P5854OnIsShowRecBeforeExit(var IsHandled: Boolean; var ReturnValue: Boolean; var SalesCrMemoLine2: Record "Sales Cr.Memo Line"; var SalesCrMemoLine: Record "Sales Cr.Memo Line")
    VAR
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        with SalesCrMemoLine2 do begin
            if "Document No." <> SalesCrMemoHeader."No." then
                SalesCrMemoHeader.Get("Document No.");
            if SalesCrMemoHeader."Prepayment Credit Memo" then begin
                ReturnValue := false;
            end;
            ReturnValue := true;
        end;
        IF SalesCrMemoLine.Type <> SalesCrMemoLine.Type::Item THEN
            ReturnValue := true
        else
            ReturnValue := false;
        IsHandled := true;
    end;


    //PPNA17.0 Opened Start OnForecastNameValidate
    //PE-267.JS.1.0 08MAR2024 - start
    //PE-267.JS.1.0 below code commented because TimelineVisualizer control has been deprecated by Base BC 24.0 and has never worked on the web client.     
    // [EventSubscriber(ObjectType::Page, 5540, 'OnForecaseNameOnValidateOnBeforeInitAndCreateTimelineEvents', '', false, false)]
    // local procedure NS_P5540OnForecastNameValidate(VAR IncludeBlanketOrders: Boolean; ForecastName: Code[10])
    // begin
    //     IF ForecastName <> '' THEN
    //         IncludeBlanketOrders := TRUE;
    // end;
    //PPNA17.0 Opened End
    //PE-267.JS.1.0 08MAR2024 - end

    //PRJ-09-TY
    [EventSubscriber(ObjectType::Table, 952, 'OnAfterInsertEvent', '', false, false)]
    local procedure NS_P950OnAfterInsertEvent(var Rec: Record "Time Sheet Detail")
    begin
        IF Rec.Quantity <> 0 THEN begin
            Rec.NS_CalculateWages;
            // Rec.Modify() //PRJ-188.SK.1.0 Blocked
        end;
    end;

    [EventSubscriber(ObjectType::Table, 952, 'OnAfterModifyEvent', '', false, false)]
    local procedure NS_P950OnAfterModifyEvent(var Rec: Record "Time Sheet Detail"; RunTrigger: Boolean)
    begin
        IF Rec.Quantity <> 0 THEN begin
            Rec.NS_CalculateWages;
            // Rec.Modify() //PRJ-188.SK.1.0 Blocked
        end;
    end;


    //PPNA17.0 Opened Start
    //PE-59.GK.1.0 14Mar2023 start
    //[EventSubscriber(ObjectType::Page, 352, 'OnAfterSet', '', false, false)]
    [EventSubscriber(ObjectType::Page, 352, 'OnAfterSetLines', '', false, false)]
    //local procedure NS_P352OnAfterSet(var NewVendor: Record Vendor; newPeriodType: Integer; newAmountType: Option)
    local procedure NS_P352OnAfterSet(var NewVendor: Record Vendor; NewPeriodType: Enum "Analysis Period Type"; NewAmountType: Enum "Analysis Amount Type")
    //PE-59.GK.1.0 14Mar2023 end
    begin
        //PE-59.GK.1.0 14Mar2023 start
        //p.NS_P352SetPram(NewVendor, newPeriodType, newAmountType);
        p.NS_P352SetPram(NewVendor, NewPeriodType.AsInteger(), NewAmountType.AsInteger());
        //PE-59.GK.1.0 14Mar2023 end
    end;
    //PPNA17.0 Opened End


    //PPNA17.0 OpenedStart
    [EventSubscriber(ObjectType::Page, 351, 'OnAfterSet', '', false, false)]
    local procedure NS_P351OnAfterSet(VAR newCust: Record Customer; NewPeriodType: Integer; NewAmountType: Option)
    begin
        p.NS_P351SetPram(newCust, newPeriodType, newAmountType);
    end;
    //PPNA17.0 Opened End

    [EventSubscriber(ObjectType::Page, 256, 'OnAfterValidateEvent', 'Account No.', false, false)]
    local procedure NS_P256OnAfterValidateEventAccountNo(VAR Rec: Record "Gen. Journal Line"; VAR xRec: Record "Gen. Journal Line")
    var
        NS_Vendor: Record Vendor;
        Text14021100: label 'Warning:  Insurance has expired for Vendor %1';
        JobsetupTb1: Record "Jobs Setup";//PRJ-1040.AS.1.0
    begin
        JobsetupTb1.Get();//PRJ-1040.AS.1.0

        WITH Rec DO BEGIN
            IF ("Account Type" = "Account Type"::Vendor) AND
               (NS_Vendor.InsuranceExpired("Account No.", "Posting Date")) THEN
                //MESSAGE(Text14021100, "Account No.");//PRJ-1040.AS.1.0 Commented
                //PRJ-1040.AS.1.0 - start
                if JobsetupTb1."NS_Notify Insurance Exp" = false then
                    MESSAGE(Text14021100, "Account No.");
            //PRJ-1040.AS.1.0 - end

            PurchSetup.GET;
            IF NOT PurchSetup."NS_Purchase Retention Inactive" THEN
                IF "Account Type" = "Account Type"::Vendor THEN
                    VALIDATE("NS_Retention Ledger Code", PurchSetup."NS_Normal Vendor Ledger No.");
        END;

    end;

    [EventSubscriber(ObjectType::Page, 233, 'OnBeforeCalcApplnAmount', '', false, false)]
    local procedure NS_P233OnBeforeCalcApplnAmount(VAR VendorLedgerEntry: Record "Vendor Ledger Entry"; VAR GenJournalLine: Record "Gen. Journal Line")
    var
        AppliedVendLedgEntry: Record "Vendor Ledger Entry";
    begin
        PurchSetup.Get();
        IF NOT PurchSetup."NS_Purchase Retention Inactive" THEN
            AppliedVendLedgEntry.SETRANGE("NS_Retention Ledger Code", VendorLedgerEntry."NS_Retention Ledger Code");
    end;

    [EventSubscriber(ObjectType::Page, 232, 'OnBeforeCalcApplnAmount', '', false, false)]
    local procedure NS_P232OnBeforeCalcApplnAmount(VAR CustLedgerEntry: Record "Cust. Ledger Entry"; VAR GenJournalLine: Record "Gen. Journal Line")
    var
        AppliedCustLedgEntry: Record "Cust. Ledger Entry";
    begin
        SalesSetup.Get();
        IF NOT SalesSetup."NS_Sales Retention Inactive" THEN
            AppliedCustLedgEntry.SETRANGE("NS_Retention Ledger Code", GenJournalLine."NS_Retention Ledger Code");
    end;

    [EventSubscriber(ObjectType::Page, 201, 'OnBeforeActionEvent', 'P&ost', false, false)]
    local procedure NS_P201OnBeforeActionEvent(VAR Rec: Record "Job Journal Line")
    var
        lJobJnlLine: Record "Job Journal Line";
        lPurchReceiptLine: Record "Purch. Rcpt. Line";
        lJobMaterialPlan: Record "NS_Job Material Planning";
    begin
        lJobJnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
        lJobJnlLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
        lJobJnlLine.SETRANGE("Job No.", Rec."Job No.");
        IF lJobJnlLine.FINDSET(TRUE, FALSE) THEN BEGIN
            REPEAT
                lJobMaterialPlan.SETRANGE("NS_Worksheet Job No.", lJobJnlLine."Job No.");
                lJobMaterialPlan.SETRANGE("NS_Document No.", lJobJnlLine."Document No.");
                lJobMaterialPlan.SETRANGE("NS_Part No.", lJobJnlLine."No.");
                IF lJobMaterialPlan.FINDFIRST THEN BEGIN
                    //lJobMaterialPlan."NS_Total Quantity Staged" += lJobJnlLine.Quantity; //PRJ-1432.GK.1.0 13July2022 comment
                    lJobMaterialPlan."NS_Box Text" := lJobJnlLine."NS_Box Ref.";
                    lJobMaterialPlan.MODIFY;
                END;
                IF lPurchReceiptLine.GET(lJobJnlLine."NS_Purch. Receipt Doc. No.", lJobJnlLine."NS_Purch. Receipt Line No.") THEN BEGIN
                    lPurchReceiptLine."NS_Journal Status" := lPurchReceiptLine."NS_Journal Status"::Posted;
                    lPurchReceiptLine.MODIFY;
                END;
            UNTIL lJobJnlLine.NEXT = 0;
        END;
    end;
    //PRJ-09-TY
    //[EventSubscriber(ObjectType::Page, 161, 'OnCalculateTotalsGetVend', '', false, false)]
    [EventSubscriber(ObjectType::Page, 161, 'OnAfterGetRecordEvent', '', false, false)]
    local procedure NS_P161OnAfterGetRecordEvent(var Rec: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
        TempPurchLine: Record "Purchase Line" temporary;
        TotalPurchLine: Record "Purchase Line";
        TotalPurchLineLCY: Record "Purchase Line";
        PurchPost: Codeunit "Purch.-Post";
        VATAmount: Decimal;
        VATAmountText: Text;
        TotalAmount2: Decimal;
        TotalAmount1: Decimal;
        Vend: Record vendor;
    begin
        CLEAR(PurchLine);
        CLEAR(TotalPurchLine);
        CLEAR(TotalPurchLineLCY);
        CLEAR(PurchPost);

        PurchPost.GetPurchLines(Rec, TempPurchLine, 0);
        CLEAR(PurchPost);
        PurchPost.SumPurchLinesTemp(
          Rec, TempPurchLine, 0, TotalPurchLine, TotalPurchLineLCY, VATAmount, VATAmountText);

        IF Rec."Prices Including VAT" THEN BEGIN
            TotalAmount2 := TotalPurchLine.Amount;
            TotalAmount1 := TotalAmount2 + VATAmount;
            TotalPurchLine."Line Amount" := TotalAmount1 + TotalPurchLine."Inv. Discount Amount";
        END ELSE BEGIN
            TotalAmount1 := TotalPurchLine.Amount;
            TotalAmount2 := TotalPurchLine."Amount Including VAT";
        END;
        IF Vend.GET(Rec."Pay-to Vendor No.") THEN;
        if Vend."No." <> '' then begin
            IF Rec."NS_Retention Percent" <> 0 THEN BEGIN
                Rec.VALIDATE("NS_Retention Percent");
                Rec.VALIDATE("NS_Retention Date");
            END ELSE
                IF Rec."NS_Retention Amount (LCY)" <> 0 THEN BEGIN
                    Rec.VALIDATE("NS_Retention Amount (LCY)");
                    Rec.VALIDATE("NS_Retention Date");
                END;
            PurchSetup.Get;
            if not PurchSetup."NS_Purchase Retention Inactive" then begin
                Vend.SETRANGE("NS_Retention Ledger CodeFilter", PurchSetup."NS_Normal Vendor Ledger No.");
                Vend.CALCFIELDS("Balance (LCY)");
            end;
        end;
        p.NS_P161SetTotalAmount2(TotalAmount2);
    end;
    //PRJ-09-TY
    // [EventSubscriber(ObjectType::Page, 160, 'OnCalculateTotalsGetCust', '', false, false)]
    [EventSubscriber(ObjectType::Page, 160, 'OnAfterGetRecordEvent', '', false, false)]
    local procedure NS_P160OnAfterGetRecordEvent(var Rec: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        TempSalesLine: Record "Sales Line" temporary;
        TotalSalesLine: Record "Sales Line";
        TotalSalesLineLCY: Record "Sales Line";
        SalesPost: Codeunit "Sales-Post";
        VATAmount: Decimal;
        VATAmountText: Text;
        ProfitLCY: Decimal;
        ProfitPct: Decimal;
        TotalAdjCostLCY: Decimal;
        AdjProfitLCY: Decimal;
        AdjProfitPct: Decimal;
        TotalAmount2: Decimal;
        TotalAmount1: Decimal;
        Cust: Record customer;
    begin
        CLEAR(SalesLine);
        CLEAR(TotalSalesLine);
        CLEAR(TotalSalesLineLCY);
        CLEAR(SalesPost);

        SalesPost.GetSalesLines(Rec, TempSalesLine, 0);
        CLEAR(SalesPost);
        SalesPost.SumSalesLinesTemp(
          Rec, TempSalesLine, 0, TotalSalesLine, TotalSalesLineLCY,
          VATAmount, VATAmountText, ProfitLCY, ProfitPct, TotalAdjCostLCY);

        AdjProfitLCY := TotalSalesLineLCY.Amount - TotalAdjCostLCY;
        IF TotalSalesLineLCY.Amount <> 0 THEN
            AdjProfitPct := ROUND(AdjProfitLCY / TotalSalesLineLCY.Amount * 100, 0.1);

        IF Rec."Prices Including VAT" THEN BEGIN
            TotalAmount2 := TotalSalesLine.Amount;
            TotalAmount1 := TotalAmount2 + VATAmount;
            TotalSalesLine."Line Amount" := TotalAmount1 + TotalSalesLine."Inv. Discount Amount";
        END ELSE BEGIN
            TotalAmount1 := TotalSalesLine.Amount;
            TotalAmount2 := TotalSalesLine."Amount Including VAT";
        END;

        IF Cust.GET(Rec."Bill-to Customer No.") THEN;
        if Cust."No." <> '' then begin
            SalesSetup.Get;
            if not SalesSetup."NS_Sales Retention Inactive" then begin
                Cust.SetRange("NS_Retention Ledger CodeFilter", SalesSetup."NS_Normal Customer Ledger No.");
                Cust.CalcFields("Balance (LCY)")
            end;
        end;
        p.NS_P160SetTotalAmount2(TotalAmount2);
    end;

    [EventSubscriber(ObjectType::Table, 25, 'OnBeforeDrillDownOnOverdueEntries', '', false, false)]
    local procedure NS_P152_T25OnBeforeDrillDownOnOverdueEntries(var VendorLedgerEntry: Record "Vendor Ledger Entry"; var DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry")
    begin
        DetailedVendorLedgEntry.SetFilter("NS_Retention Ledger Code", p.NS_P152GetRetentionLedgerCodeFilter);
    end;

    [EventSubscriber(ObjectType::Table, 25, 'OnBeforeDrillDownEntries', '', false, false)]
    local procedure NS_P152_T25OnBeforeDrillDownEntries(var VendorLedgerEntry: Record "Vendor Ledger Entry"; var DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry")
    begin
        DetailedVendorLedgEntry.SetFilter("NS_Retention Ledger Code", p.NS_P152GetRetentionLedgerCodeFilter);
    end;

    [EventSubscriber(ObjectType::Page, 152, 'OnAfterGetCurrRecordEvent', '', false, false)]
    local procedure NS_P152OnAfterGetCurrRecordEvent(var Rec: Record Vendor)
    begin
        p.NS_P152SetRetentionLedgerCodeFilter(Rec.GetFilter("NS_Retention Ledger CodeFilter"));
    end;



    //PPNA17.0 Opened Start OnAfterGetRecordDateFilter 
    [EventSubscriber(ObjectType::Page, 152, 'OnAfterSetDateFilter', '', false, false)]
    local procedure NS_P152OnAfterGetRecordEvent(var Vendor: Record Vendor)
    begin
        with Vendor do begin
            PurchSetup.Get;
            if not PurchSetup."NS_Purchase Retention Inactive" then begin
                SetRange("NS_Retention Ledger CodeFilter", PurchSetup."NS_Normal Vendor Ledger No.");
                CalcFields("Balance (LCY)");
            end;
        end;
    end;
    //PPNA17.0 Opened End

    [EventSubscriber(ObjectType::Page, 151, 'OnAfterGetCurrRecordEvent', '', false, false)]
    local procedure NS_P151OnAfterGetCurrRecordEvent(var Rec: Record Customer)
    begin
        p.NS_P151SetRetentionLedgerCodeFilter(Rec.GetFilter("NS_Retention Ledger CodeFilter"));
    end;

    [EventSubscriber(ObjectType::Table, 21, 'OnBeforeDrillDownEntries', '', false, false)]
    local procedure NS_P151_T21OnBeforeDrillDownEntries(var CustLedgerEntry: Record "Cust. Ledger Entry"; var DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    begin
        SalesSetup.Get;
        if SalesSetup."NS_Sales Retention Inactive" then
            DetailedCustLedgEntry.SetFilter("Initial Entry Global Dim. 2", p.NS_P151GetRetentionLedgerCodeFilter)
        else
            //DetailedCustLedgEntry.SetFilter("Retention Ledger Code", SalesSetup."Normal Customer Ledger No.");//PRJ-197.AS.1.0 - 15APRIL2020 Commented old code
            DetailedCustLedgEntry.SetFilter("NS_Retention Ledger Code", p.NS_P151GetRetentionLedgerCodeFilter);//PRJ-197.AS.1.0 - 15APRIL2020
    end;

    [EventSubscriber(ObjectType::Table, 21, 'OnBeforeDrillDownOnOverdueEntries', '', false, false)]
    local procedure NS_P151_T21OnBeforeDrillDownOnOverdueEntries(var CustLedgerEntry: Record "Cust. Ledger Entry"; var DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    begin
        DetailedCustLedgEntry.SetFilter("NS_Retention Ledger Code", p.NS_P151GetRetentionLedgerCodeFilter);
    end;




    //PPNA17.0 Opened Start OnAfterGetRecordDateFilter 
    [EventSubscriber(ObjectType::Page, 151, 'OnAfterSetDateFilter', '', false, false)]
    local procedure NS_P151OnAfterGetRecordDateFilter(var Customer: Record Customer)
    begin
        with Customer do begin
            SalesSetup.Get;
            if not SalesSetup."NS_Sales Retention Inactive" then begin
                SetFilter("NS_Retention Ledger CodeFilter", SalesSetup."NS_Normal Customer Ledger No.");
                CalcFields("Balance (LCY)");
            end;
        end;
    end;
    //PPNA17.0 Opened End

    [EventSubscriber(ObjectType::Page, 96, 'OnNewRecordEvent', '', false, false)]
    local procedure NS_P96OnNewRecordEvent(var Rec: Record "Sales Line"; BelowxRec: Boolean; var xRec: Record "Sales Line")
    var
        NS_SalesHeader: Record "Sales Header";
    begin
        with Rec do begin
            "NS_Retention Applies" := true;
            if NS_SalesHeader.Get("Document Type", "Document No.") then
                "Job No." := NS_SalesHeader."NS_Job No.";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 364, 'OnBeforeInitDeleteHeader', '', false, false)]
    local procedure NS_P50_C364OnBeforeInitDeleteHeader(var PurchHeader: Record "Purchase Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var ReturnShptHeader: Record "Return Shipment Header"; var PurchInvHeaderPrepmt: Record "Purch. Inv. Header"; var PurchCrMemoHdrPrepmt: Record "Purch. Cr. Memo Hdr."; var SourceCode: Code[10])
    var
        NS_ProgressPaymentHeader: Record "NS_Progress Payment Header";
        NS_Text14021100: Label 'Purchase Order can not be deleted because Progress Payment is used.';
    begin
        with PurchHeader do
            if "NS_Subcontract No." > '' then begin
                NS_ProgressPaymentHeader.SetRange("NS_No.", "No.");
                if not NS_ProgressPaymentHeader.IsEmpty then
                    Error(NS_Text14021100);
            end;
    end;

    //PPDA.1.0 Start
    // local procedure NS_Pct(Numerator: Decimal; Denominator: Decimal): Decimal
    // begin
    //     IF Denominator = 0 THEN
    //         EXIT(0);
    //     EXIT(ROUND(Numerator / Denominator * 10000, 1));

    // end;
    //PPDA.1.0 End

    //PRJ-153.SK.1.0 Start
    [EventSubscriber(ObjectType::Report, Report::NS_JobCreateSalesInvoice, 'OnBeforeOnPreDataItemReport', '', False, False)]
    local procedure NS_PassJobNo(var JobNo: Code[20])
    var
        ParatemeterForEvents14021100: Codeunit "NS_Parameters for Events";
    begin
        JobNo := ParatemeterForEvents14021100.NS_P88GetJobNo();
    end;
    //PRJ-153.SK.1.0 End
    //PRJ-1387.NK.1.0 12May2022 start

    // [EventSubscriber(ObjectType::Page, 50, 'OnBeforeActionEvent', 'Post', false, false)]
    // local procedure Mandatorytaxfields(var Rec: Record "Purchase Header")
    // var
    //     PurchaseLine: Record "Purchase Line";
    // begin
    //     PurchaseLine.Reset();
    //     PurchaseLine.SetRange("Document No.", Rec."No.");
    //     PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
    //     PurchaseLine.SetFilter("No.", '<>%1', '');
    //     if PurchaseLine.FindSet() then
    //         repeat
    //             PurchaseLine.TestField("Tax Area Code");
    //             PurchaseLine.TestField("Tax Group Code");
    //         until PurchaseLine.Next() = 0;

    // end;

    // [EventSubscriber(ObjectType::Page, 50, 'OnBeforeActionEvent', 'Release', false, false)]
    // local procedure Mandatorytaxfields2(var Rec: Record "Purchase Header")
    // var
    //     PurchaseLine: Record "Purchase Line";
    // begin
    //     PurchaseLine.Reset();
    //     PurchaseLine.SetRange("Document No.", Rec."No.");
    //     PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
    //     PurchaseLine.SetFilter("No.", '<>%1', '');
    //     if PurchaseLine.FindSet() then
    //         repeat
    //             PurchaseLine.TestField("Tax Area Code");
    //             PurchaseLine.TestField("Tax Group Code");
    //         until PurchaseLine.Next() = 0;

    // end;
    //PRJ-1387.NK.1.0 12May2022 End
    //PRJ-1348.NK.1.0 24May2022 Start
    [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Caption Class", 'OnResolveCaptionClass', '', False, False)]
    local procedure NS_ResolveCaptionClass(CaptionArea: Text; CaptionExpr: Text; Language: Integer; var Caption: Text; var Resolved: Boolean)
    begin
        if CaptionArea = '50999' then begin
            Caption := NS_AOPCaptionChange(CaptionExpr);
            Resolved := true;
        end;
        if CaptionArea = '50998' then begin
            Caption := NS_AOPDescription(CaptionExpr);
            Resolved := true;
        end;
        if CaptionArea = '50997' then begin
            Caption := NS_AOPSourcCaption(CaptionExpr);
            Resolved := true;
        end;
        if CaptionArea = '50996' then begin
            Caption := NS_AOPDestinationCaption(CaptionExpr);
            Resolved := true;
        end;
        if CaptionArea = '50995' then begin
            Caption := NS_ReportCaption(CaptionExpr);
            Resolved := true;
        end;
        //PRJ-1571.NK.1.0 17Aug2022 Start
        if CaptionArea = '50994' then begin
            Caption := NS_AOPRepotFilter(CaptionExpr);
            Resolved := true;
        end;
        //PRJ-1571.NK.1.0 17Aug2022 End

        //PE-185.NC.1.0 05Oct2023 Start
        if CaptionArea = '50993' then begin
            Caption := NS_UserTaskCaption(CaptionExpr);
            Resolved := true;
        end;
        //PE-185.NC.1.0 05Oct2023 End
    end;

    Local Procedure NS_AOPCaptionChange(Caption: Text): Text
    var
        APOSetup: Record NS_APOSetup;
        MyCaptionType: Text;
        MyCaptionRef: Text;
        CommaPosition: Integer;
        jobSetup: Record "Jobs Setup";
    begin
        if APOSetup.Get() then; //PRJ-1348.NK.1.0 08Sep2022
        if jobSetup.Get() then; //PRJ-1348.NK.1.0 08Sep2022
        if jobSetup."NS_Activate Task Pick List" then begin
            CommaPosition := StrPos(Caption, ',');
            if CommaPosition > 0 then Begin
                MyCaptionType := COpystr(Caption, 1, CommaPosition - 1);
                MyCaptionRef := CopyStr(Caption, CommaPosition + 1);
                case MyCaptionType of
                    '0':
                        exit(APOSetup."Activity Code");
                    '1':
                        exit(APOSetup."Process Code");
                    '2':
                        exit(APOSetup."Operation Code");
                    '3':
                        exit(APOSetup."Section Code");
                End;
            end;
        end else begin
            CommaPosition := StrPos(Caption, ',');
            if CommaPosition > 0 then Begin
                MyCaptionType := COpystr(Caption, 1, CommaPosition - 1);
                MyCaptionRef := CopyStr(Caption, CommaPosition + 1);
                case MyCaptionType of
                    '0':
                        exit('Activity Code');
                    '1':
                        exit('Process Code');
                    '2':
                        exit('Operation Code');
                    '3':
                        exit('Section Code');
                End;
            end;
        end;
        exit('');
    end;

    Local Procedure NS_AOPDescription(Caption: Text): Text
    var
        APOSetup: Record NS_APOSetup;
        APOCapt: Record NS_APOCaptionMaster;
        jobSetup: Record "Jobs Setup";
        MyCaptionType: Text;
        MyCaptionRef: Text;
        CommaPosition: Integer;
    begin
        if APOSetup.Get() then; //PRJ-1348.NK.1.0 08Sep2022
        if jobSetup.Get() then; //PRJ-1348.NK.1.0 08Sep2022
        if jobSetup."NS_Activate Task Pick List" then begin
            CommaPosition := StrPos(Caption, ',');
            if CommaPosition > 0 then Begin
                MyCaptionType := COpystr(Caption, 1, CommaPosition - 1);
                MyCaptionRef := CopyStr(Caption, CommaPosition + 1);
                case MyCaptionType of
                    '0':
                        begin
                            if APOCapt.get(APOCapt.NS_Type::Activity, APOSetup."Activity Code") then;
                            exit(APOCapt.NS_Description);
                        end;
                    '1':
                        begin
                            if APOCapt.get(APOCapt.NS_Type::Process, APOSetup."Process Code") then;
                            exit(APOCapt.NS_Description);
                        end;
                    '2':
                        begin
                            if APOCapt.get(APOCapt.NS_Type::Operation, APOSetup."Operation Code") then;
                            exit(APOCapt.NS_Description);
                        end;
                    '3':
                        begin
                            if APOCapt.get(APOCapt.NS_Type::Section, APOSetup."Section Code") then;
                            exit(APOCapt.NS_Description);
                        end;
                End;
            end;
        end else begin
            CommaPosition := StrPos(Caption, ',');
            if CommaPosition > 0 then Begin
                MyCaptionType := COpystr(Caption, 1, CommaPosition - 1);
                MyCaptionRef := CopyStr(Caption, CommaPosition + 1);
                case MyCaptionType of
                    '0':
                        exit('Activity Description');
                    '1':
                        exit('Process Description');
                    '2':
                        exit('Operation Description');
                    '3':
                        exit('Section Description');
                End;
            end;
        end;
        exit('');
    end;

    Local Procedure NS_AOPSourcCaption(Caption: Text): Text
    var
        APOSetup: Record NS_APOSetup;
        APOCapt: Record NS_APOCaptionMaster;
        jobSetup: Record "Jobs Setup";
        MyCaptionType: Text;
        MyCaptionRef: Text;
        CommaPosition: Integer;
    begin
        if APOSetup.Get() then; //PRJ-1348.NK.1.0 08Sep2022
        if jobSetup.Get() then; //PRJ-1348.NK.1.0 08Sep2022
        if jobSetup."NS_Activate Task Pick List" then begin
            CommaPosition := StrPos(Caption, ',');
            if CommaPosition > 0 then Begin
                MyCaptionType := COpystr(Caption, 1, CommaPosition - 1);
                MyCaptionRef := CopyStr(Caption, CommaPosition + 1);
                case MyCaptionType of
                    '0':
                        begin
                            if APOCapt.get(APOCapt.NS_Type::Activity, APOSetup."Activity Code") then;
                            exit(APOCapt.NS_Source);
                        end;
                    '1':
                        begin
                            if APOCapt.get(APOCapt.NS_Type::Process, APOSetup."Process Code") then;
                            exit(APOCapt.NS_Source);
                        end;
                    '2':
                        begin
                            if APOCapt.get(APOCapt.NS_Type::Operation, APOSetup."Operation Code") then;
                            exit(APOCapt.NS_Source);
                        end;
                    '3':
                        begin
                            if APOCapt.get(APOCapt.NS_Type::Section, APOSetup."Section Code") then;
                            exit(APOCapt.NS_Source);
                        end;
                End;
            end;
        end else begin
            CommaPosition := StrPos(Caption, ',');
            if CommaPosition > 0 then Begin
                MyCaptionType := COpystr(Caption, 1, CommaPosition - 1);
                MyCaptionRef := CopyStr(Caption, CommaPosition + 1);
                case MyCaptionType of
                    '0':
                        exit('Activity Source');
                    '1':
                        exit('Process Source');
                    '2':
                        exit('Operation Source');
                    '3':
                        exit('Section Source');
                End;
            end;
        end;
        exit('');
    end;

    Local Procedure NS_AOPDestinationCaption(Caption: Text): Text
    var
        APOSetup: Record NS_APOSetup;
        APOCapt: Record NS_APOCaptionMaster;
        jobSetup: Record "Jobs Setup";
        MyCaptionType: Text;
        MyCaptionRef: Text;
        CommaPosition: Integer;
    begin
        if APOSetup.Get() then; //PRJ-1348.NK.1.0 08Sep2022
        if jobSetup.Get() then; //PRJ-1348.NK.1.0 08Sep2022
        if jobSetup."NS_Activate Task Pick List" then begin
            CommaPosition := StrPos(Caption, ',');
            if CommaPosition > 0 then Begin
                MyCaptionType := COpystr(Caption, 1, CommaPosition - 1);
                MyCaptionRef := CopyStr(Caption, CommaPosition + 1);
                case MyCaptionType of
                    '0':
                        begin
                            if APOCapt.get(APOCapt.NS_Type::Activity, APOSetup."Activity Code") then;
                            exit(APOCapt.NS_Destination);
                        end;
                    '1':
                        begin
                            if APOCapt.get(APOCapt.NS_Type::Process, APOSetup."Process Code") then;
                            exit(APOCapt.NS_Destination);
                        end;
                    '2':
                        begin
                            if APOCapt.get(APOCapt.NS_Type::Operation, APOSetup."Operation Code") then;
                            exit(APOCapt.NS_Destination);
                        end;
                    '3':
                        begin
                            if APOCapt.get(APOCapt.NS_Type::Section, APOSetup."Section Code") then;
                            exit(APOCapt.NS_Destination);
                        end;
                End;
            end;
        end else begin
            CommaPosition := StrPos(Caption, ',');
            if CommaPosition > 0 then Begin
                MyCaptionType := COpystr(Caption, 1, CommaPosition - 1);
                MyCaptionRef := CopyStr(Caption, CommaPosition + 1);
                case MyCaptionType of
                    '0':
                        exit('Activity Matching');
                    '1':
                        exit('Process Matching');
                    '2':
                        exit('Operation Matching');
                    '3':
                        exit('Section Matching');
                End;
            end;
        end;
        exit('');
    end;

    Local Procedure NS_ReportCaption(Caption: Text): Text
    var
        APOSetup: Record NS_APOSetup;
        APOCapt: Record NS_APOCaptionMaster;
        jobSetup: Record "Jobs Setup";
        MyCaptionType: Text;
        MyCaptionRef: Text;
        CommaPosition: Integer;
    begin
        if APOSetup.Get() then; //PRJ-1348.NK.1.0 08Sep2022
        if jobSetup.Get() then; //PRJ-1348.NK.1.0 08Sep2022
        if jobSetup."NS_Activate Task Pick List" then begin
            CommaPosition := StrPos(Caption, ',');
            if CommaPosition > 0 then Begin
                MyCaptionType := COpystr(Caption, 1, CommaPosition - 1);
                MyCaptionRef := CopyStr(Caption, CommaPosition + 1);
                case MyCaptionType of
                    '0':
                        begin
                            if APOCapt.get(APOCapt.NS_Type::Activity, APOSetup."Activity Code") then;
                            exit(APOCapt.NS_Report);
                        end;
                    '1':
                        begin
                            if APOCapt.get(APOCapt.NS_Type::Process, APOSetup."Process Code") then;
                            exit(APOCapt.NS_Report);
                        end;
                    '2':
                        begin
                            if APOCapt.get(APOCapt.NS_Type::Operation, APOSetup."Operation Code") then;
                            exit(APOCapt.NS_Report);
                        end;
                    '3':
                        begin
                            if APOCapt.get(APOCapt.NS_Type::Section, APOSetup."Section Code") then;
                            exit(APOCapt.NS_Report);
                        end;
                End;
            end;
        end else begin
            CommaPosition := StrPos(Caption, ',');
            if CommaPosition > 0 then Begin
                MyCaptionType := COpystr(Caption, 1, CommaPosition - 1);
                MyCaptionRef := CopyStr(Caption, CommaPosition + 1);
                case MyCaptionType of
                    '0':
                        exit('Show Activity Code');
                    '1':
                        exit('Show Process Code');
                    '2':
                        exit('Show Operation Code');
                    '3':
                        exit('Show Section Code');
                End;
            end;
        end;
        exit('');
    end;
    //PRJ-1348.NK.1.0 24May2022 End
    //PRJ-1571.NK.1.0 17Aug2022 Start
    Local Procedure NS_AOPRepotFilter(Caption: Text): Text
    var
        APOSetup: Record NS_APOSetup;
        MyCaptionType: Text;
        MyCaptionRef: Text;
        CommaPosition: Integer;
        jobSetup: Record "Jobs Setup";
    begin
        if APOSetup.Get() then; //PRJ-1348.NK.1.0 08Sep2022
        if jobSetup.Get() then; //PRJ-1348.NK.1.0 08Sep2022
        if jobSetup."NS_Activate Task Pick List" then begin
            CommaPosition := StrPos(Caption, ',');
            if CommaPosition > 0 then Begin
                MyCaptionType := COpystr(Caption, 1, CommaPosition - 1);
                MyCaptionRef := CopyStr(Caption, CommaPosition + 1);
                case MyCaptionType of
                    '0':
                        exit(APOSetup."Activity Code" + ' Filter');
                    '1':
                        exit(APOSetup."Process Code" + ' Filter');
                    '2':
                        exit(APOSetup."Operation Code" + ' Filter');
                    '3':
                        exit(APOSetup."Section Code" + ' Filter');
                End;
            end;
        end else begin
            CommaPosition := StrPos(Caption, ',');
            if CommaPosition > 0 then Begin
                MyCaptionType := COpystr(Caption, 1, CommaPosition - 1);
                MyCaptionRef := CopyStr(Caption, CommaPosition + 1);
                case MyCaptionType of
                    '0':
                        exit('Activity Filter');
                    '1':
                        exit('Process Filter');
                    '2':
                        exit('Operation Filter');
                    '3':
                        exit('Section Filter');
                End;
            end;
        end;
        exit('');
    end;
    //PRJ-1571.NK.1.0 17Aug2022 End
    //PE-185.NC.1.0 05Oct2023 Start
    Local Procedure NS_UserTaskCaption(Caption: Text): Text
    var
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        MyCaptionType: Text;
        MyCaptionRef: Text;
        CommaPosition: Integer;
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            CommaPosition := StrPos(Caption, ',');
            if CommaPosition > 0 then Begin
                MyCaptionType := COpystr(Caption, 1, CommaPosition - 1);
                MyCaptionRef := CopyStr(Caption, CommaPosition + 1);
                case MyCaptionType of
                    '0':
                        begin
                            NSNumberFilter.Reset();
                            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 1);
                            if NSNumberFilter.FindFirst() then
                                exit(NSNumberFilter."No.");
                        end;
                    '1':
                        begin
                            NSNumberFilter.Reset();
                            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 2);
                            if NSNumberFilter.FindFirst() then
                                exit(NSNumberFilter."No.");
                        end;
                    '2':
                        begin
                            NSNumberFilter.Reset();
                            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 3);
                            if NSNumberFilter.FindFirst() then
                                exit(NSNumberFilter."No.");
                        end;
                    '3':
                        begin
                            NSNumberFilter.Reset();
                            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 4);
                            if NSNumberFilter.FindFirst() then
                                exit(NSNumberFilter."No.");
                        end;
                    '4':
                        begin
                            NSNumberFilter.Reset();
                            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 5);
                            if NSNumberFilter.FindFirst() then
                                exit(NSNumberFilter."No.");
                        end;
                    '5':
                        begin
                            NSNumberFilter.Reset();
                            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 6);
                            if NSNumberFilter.FindFirst() then
                                exit(NSNumberFilter."No.");
                        end;
                    '6':
                        begin
                            NSNumberFilter.Reset();
                            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 7);
                            if NSNumberFilter.FindFirst() then
                                exit(NSNumberFilter."No.");
                        end;
                End;
            end;
        end else begin
            CommaPosition := StrPos(Caption, ',');
            if CommaPosition > 0 then Begin
                MyCaptionType := COpystr(Caption, 1, CommaPosition - 1);
                MyCaptionRef := CopyStr(Caption, CommaPosition + 1);
                case MyCaptionType of
                    '0':
                        exit('JOB LOG');
                    '1':
                        exit('RFQ');
                    '2':
                        exit('RFI');
                    '3':
                        exit('SUBMITTAL');
                    '4':
                        exit('SAFETY');
                    '5':
                        exit('TRANSMITTAL');
                    '6':
                        exit('Other User Task');
                End;
            end;
        end;
        exit('');
    end;
    //PE-185.NC.1.0 05Oct2023 End 

    //PRJCTPR-93.PS.1.0 12April2023 Start 
    [EventSubscriber(ObjectType::Page, Page::"Req. Worksheet", 'OnBeforeOpenReqWorksheet', '', true, true)]
    local procedure NS_OnBeforeOpenReqWorksheet(var CUrrentJnlBatchName: Code[10])
    var
        NS_USerSetup: Record "User Setup";
    begin
        if NS_USerSetup.Get(UserId) then
            CUrrentJnlBatchName := NS_USerSetup."NS_JMP Batch Name";
    end;
    //PRJCTPR-93.PS.1.0 12April2023 End 

    //PRJCTPR-205.PS.1.0 01Nov2023  Start 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ReqJnlManagement", 'OnWkshTemplateSelectionSetFilter', '', true, true)]
    local procedure "ReqJnlManagement_OnWkshTemplateSelectionSetFilter"
    (
        var ReqWkshTemplate: Record "Req. Wksh. Template";
        var Type: Enum "Req. Worksheet Template Type"
    )
    var
        NS_UserSetup: Record "User Setup";
    begin
        if NS_UserSetup.Get(UserId) then;
        if NS_UserSetup."NS_JMP Template WKS. Name" <> '' then begin
            ReqWkshTemplate.SetRange(Name, NS_UserSetup."NS_JMP Template WKS. Name");
            if ReqWkshTemplate.FindFirst() then;
        end else
            exit;

    end;

    //PRJCTPR-205.PS.1.0 01Nov2023 End


    //PRJCTPR-252.HS.1.0 19Dec2023 Start
    [EventSubscriber(ObjectType::Page, Page::"Posted Purch. Invoice - Update", 'OnAfterRecordChanged', '', false, false)]
    local procedure OnAfterRecordChanged(var PurchInvHeader: Record "Purch. Inv. Header"; xPurchInvHeader: Record "Purch. Inv. Header"; var IsChanged: Boolean; xPurchInvHeaderGlobal: Record "Purch. Inv. Header");
    var
        VLEentries: Record "Vendor Ledger Entry";
        UserSetup: Record "User Setup";//PE-200.AS.10.0
    begin
        //PE-200.AS.10.0 START
        if UserSetup.Get(UserId) then
            if NOT UserSetup.NS_AllowDrawNoChange then
                Error('You are not authorized to Change the Draw No. Please contact your administrator.');
        //PE-200.AS.10.0 END

        IsChanged := (PurchInvHeader."NS_Draw No." <> xPurchInvHeaderGlobal."NS_Draw No.");

        //PE-200.AS.10.0 START
        VLEentries.Reset();
        VLEentries.SetRange("Document Type", VLEentries."Document Type"::Invoice);
        VLEentries.SetRange("Document No.", PurchInvHeader."No.");
        if VLEentries.FindSet() then
            repeat
                VLEentries."NS_Draw No." := PurchInvHeader."NS_Draw No.";
                VLEentries.Modify(true);
            until VLEentries.Next() = 0;
        //PE-200.AS.10.0 END
    end;

    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Inv. - Update", 'OnAfterRecordChanged', '', false, false)]
    local procedure OnAfterRecordChange(var SalesInvoiceHeader: Record "Sales Invoice Header"; xSalesInvoiceHeader: Record "Sales Invoice Header"; var IsChanged: Boolean);
    begin
        IsChanged := (SalesInvoiceHeader."NS_Draw No." <> xSalesInvoiceHeader."NS_Draw No.")
    end;
    //PRJCTPR-252.HS.1.0 19Dec2023 End
    //PE-217.DK.3.0 23Jan2024 Start Code UnCommented because of issue Resolved to weather Api 
    //PE-217.DK.1.0 27Dec2023 Start
    [EventSubscriber(ObjectType::Table, Database::"NS_Daily Job Log", 'OnAfterValidateEvent', 'NS_Job Zip Code', false, false)]
    local procedure NS_WeatherApi(var Rec: Record "NS_Daily Job Log")
    var
        NS_JsonText: Text;
        country: Text;
        TmpText: Text;
        Weather: Text;
        Clouds: Text;
        city: Text;
        image: Text;
        degree: Char;
        temp: Decimal;
        temp1: Decimal;
        NS_httpClient: HttpClient;
        NS_ResponceMessage: HttpResponseMessage;
        NS_JsonObject: JsonObject;
        NS_JsonObject1: JsonObject;
        NS_jsonToken1: JsonToken;
        JsonTokChoices: JsonToken;
        NS_JsonArray: JsonArray;
        NS_ApoSetup: Record NS_APOSetup; //PRJCTPR-381.Dk.1.0 29May2024
    begin
        degree := 0176;
        if not NS_httpClient.Get('http://api.openweathermap.org/data/2.5/weather?q=' + Rec."NS_Job Zip Code" + '&units=metric&APPID=127a614cec19b6d1facb93855cba6328', NS_ResponceMessage) then
            //PRJCTPR-356.DK.1.0 Start
            //Error('Web service call failed for openweather api');
            Error('Please enter a valid Zip Code on the Job Card under Job Address.');
        if not NS_ResponceMessage.IsSuccessStatusCode() then
            //Error('Web service error details:\Status Code:%1\Description:%2',
            Error('Please enter a valid Zip Code on the Job Card under Job Address.');
        // NS_ResponceMessage.HttpStatusCode(),
        // NS_ResponceMessage.ReasonPhrase());
        //PRJCTPR-356.DK.1.0 End
        NS_ResponceMessage.Content().ReadAs(NS_JsonText);
        if not NS_JsonObject.ReadFrom(NS_JsonText) then
            Error('Error ... Not an Json Object - Invaled Response');
        if NS_JsonObject.Get('weather', NS_jsonToken1) then begin
            NS_JsonArray := NS_jsonToken1.AsArray();
            NS_JsonArray.Get(0, JsonTokChoices);
            NS_JsonObject1 := JsonTokChoices.AsObject();
        end;
        temp := NS_SelectJsonToken(NS_JsonObject, '$.main.temp').AsValue().AsDecimal();
        country := NS_SelectJsonToken(NS_JsonObject, '$.sys.country').AsValue().AsText();
        Weather := NS_SelectJsonToken(NS_JsonObject1, 'description').AsValue().AsText();
        Clouds := NS_GetJsonToken(NS_JsonObject1, 'main').AsValue().AsText();
        image := NS_SelectJsonToken(NS_JsonObject1, 'icon').AsValue().AsText();
        city := NS_GetJsonToken(NS_JsonObject, 'name').AsValue().AsText();
        // TmpText := Format(temp) + ' ' + Format(degree) + 'C' + '<br> ' + 'Weather :' + Format(Weather) + '<br> ' + 'Country :' + Format(country);
        if NS_ApoSetup.Get() then begin //PRJCTPR-381.Dk.1.0 29May2024
            // if Format(Rec."Measuring Scale") = 'Celsius' then begin //PRJCTPR-381.Dk.1.0 29May2024
            if Format(NS_ApoSetup."NS_Temperature Measuring Scale") = 'Celsius' then begin //PRJCTPR-381.Dk.1.0 29May2024
                Rec."Weather/Temperature Other" := Format(Weather);
                Rec.Temperature := Format(temp) + Format(degree) + 'C';
            end else begin
                temp1 := ((temp * 1.8) + 32);
                Rec."Weather/Temperature Other" := Format(Weather);
                Rec.Temperature := Format(temp1) + Format(degree) + 'F';
            end;
        end; //PRJCTPR-381.Dk.1.0 29May2024
        if Clouds = 'Rain' then
            Rec.Rainy := true;
        if Clouds = 'Wind' then
            Rec.Windy := true;
        if Clouds = 'Clear' then
            Rec.Clear := true;
        //exit(TmpText);
    end;

    local procedure NS_GetJsonToken(NS_JsonObject: JsonObject; NS_TokenKey: Text) JsonToken: JsonToken
    begin
        if not NS_JsonObject.Get(NS_TokenKey, JsonToken) then
            Error('Token not found for key:%1' + NS_TokenKey);
    end;

    local procedure NS_SelectJsonToken(NSJosnObject: JsonObject; path: Text) JsonToken: JsonToken
    begin
        if not NSJosnObject.SelectToken(path, JsonToken) then
            Error('Token not found for path:%1' + Path);
    end;
    // //PE-217.DK.1.0 27Dec2023 End
    //PE-217.DK.3.0 23Jan2024 End
     //PE-323 AT.01 03July2024 start
    procedure InsertLinkedResourceInProjectPL(Rec: Record "Job Planning Line")
    var

        JPLRec: Record "Job Planning Line";
        JPLRec2: Record "Job Planning Line";
        JPLRec3: Record "Job Planning Line";
        jobTblRec: Record Job;
        JQHeader: Record "NS_Job Quote Header";
        TLaborRatebyTask: Record "NS_Labor rate by task list";
        Res: Record Resource;
        JobTaskRec: Record "Job Task";
        NS_LinkedResources: Record "NS_Linked Resources";
        RecItem: Record Item;

    Begin
        IF Rec.Type = Rec.Type::Item then begin
            if RecItem.get(Rec."No.") then
                //if Rec."NS_Linked Resource" <> '' then begin
                    NS_LinkedResources.Reset();
            NS_LinkedResources.SetCurrentKey("NS_Item No.", "NS_Linked Resource");
            NS_LinkedResources.SetRange("NS_Item No.", RecItem."No.");
            // NS_LinkedResources.SetRange(NS_Default, false);
            if rec.Quantity > 0 then
                if NS_LinkedResources.FindSet() then Begin
                    repeat
                        JPLRec3.INIT;
                        if Rec."Job No." <> '' then
                            JPLRec3."Job No." := Rec."Job No.";
                        if Res."NS_Default Job Task No" <> '' then begin
                            if not JobTaskRec.Get(Rec."Job No.", Res."NS_Default Job Task No") then
                                Error('You cannot insert Resouce Line having Job Task No. %1 not defined in Task lines of Job %2', Res."NS_Default Job Task No", Rec."Job No.");
                            JPLRec3."Job Task No." := Res."NS_Default Job Task No";
                        end
                        else
                            JPLRec3."Job Task No." := Rec."Job Task No.";
                        JPLRec3."Line No." := GetLineNoFormJPL(Rec);
                        JPLRec3."NS_Resource Line No." := Rec."Line No.";
                        JPLRec3."NS_Entry Type" := Rec."NS_Entry Type";
                        JPLRec3."Line Type" := Rec."Line Type";
                        JPLRec3."Document No." := Rec."Document No.";
                        JPLRec3."Document Date" := Rec."Document Date";
                        JPLRec3."Planning Date" := Rec."Planning Date";
                        JPLRec3."NS_Quote Category" := Rec."NS_Quote Category";
                        //JPLRec3."NS_Quote Category Type" := Rec."NS_Quote Category Type";
                        JPLRec3."NS_Shortcut Dimension 1 Code" := Rec."NS_Shortcut Dimension 1 Code";
                        JPLRec3."NS_Shortcut Dimension 2 Code" := Rec."NS_Shortcut Dimension 2 Code";
                        JPLRec3."Planned Delivery Date" := Rec."Planned Delivery Date";
                        JPLRec3."NS_Progress Billing Method" := Rec."NS_Progress Billing Method";
                        JPLRec3.Type := JPLRec2.Type::Resource;
                        JPLRec3."No." := NS_LinkedResources."NS_Linked Resource";
                        IF Res.GET(NS_LinkedResources."NS_Linked Resource") Then begin
                            IF Res."NS_Job Revenue Category" <> '' THEN
                                JPLRec3."NS_Revenue Category" := Res."NS_Job Revenue Category";
                            IF Res."NS_Job Cost Category" <> '' THEN
                                JPLRec3."NS_Cost Category" := Res."NS_Job Cost Category";
                            JPLRec3.Description := Res.Name;
                            JPLRec3."Description 2" := Res."Name 2";
                            JPLRec3."Gen. Prod. Posting Group" := Res."Gen. Prod. Posting Group";
                            JPLRec3."Resource Group No." := Res."Resource Group No.";
                            JPLRec3."Unit of Measure Code" := Res."Base Unit of Measure";
                            JPLRec3."Unit Cost" := Res."Unit Cost";
                            JPLRec3."Unit Price" := Res."Unit Price";
                        end;
                        JPLRec3.Validate(Quantity, Rec.Quantity * NS_LinkedResources."NS_Labor Hr. per Qty");
                        JPLRec3."Planning Date" := Rec."Planning Date";
                        JPLRec3."Planned Delivery Date" := Rec."Planned Delivery Date";
                        JPLRec3."NS_Parent Linked Item" := Rec."No.";
                        JPLRec3."NS_Labor Hours per Qty." := NS_LinkedResources."NS_Labor Hr. per Qty";


                        if jobTblRec.get(Rec."Job No.") then;
                        JPLRec3."Gen. Bus. Posting Group" := jobTblRec."NS_Gen. Bus. Posting Group New";
                        JPLRec3."Customer Price Group" := jobTblRec."Customer Price Group";
                        JPLRec3."NS_Segment Code" := Rec."NS_Segment Code";
                        JPLRec3."NS_Segment Name" := Rec."NS_Segment Name";
                        JPLRec3."NS_Segment Type" := Rec."NS_Segment Type";
                        JPLRec3."User ID" := Rec."User ID";
                        JPLRec3.INSERT;
                    Until NS_LinkedResources.Next() = 0;
                end;
            //End;
        end;
    end;

    procedure InsertLinkedResourceInProjectPL1(Rec: Record "Job Planning Line")
    var

        JPLRec: Record "Job Planning Line";
        JPLRec2: Record "Job Planning Line";
        JPLRec3: Record "Job Planning Line";
        jobTblRec: Record Job;
        JQHeader: Record "NS_Job Quote Header";
        TLaborRatebyTask: Record "NS_Labor rate by task list";
        Res: Record Resource;
        JobTaskRec: Record "Job Task";
        NS_LinkedResources: Record "NS_Linked Resources";
        RecItem: Record Item;

    Begin
        IF Rec.Type = Rec.Type::Item then begin
            if RecItem.get(Rec."No.") then
                //if Rec."NS_Linked Resource" <> '' then begin
            NS_LinkedResources.Reset();
            NS_LinkedResources.SetCurrentKey("NS_Item No.", "NS_Linked Resource");
            NS_LinkedResources.SetRange("NS_Item No.", RecItem."No.");
            NS_LinkedResources.SetRange(NS_Default, true);
            if rec.Quantity > 0 then
                if NS_LinkedResources.FindSet() then Begin
                    repeat
                        JPLRec3.INIT;
                        if Rec."Job No." <> '' then
                            JPLRec3."Job No." := Rec."Job No.";
                        if Res."NS_Default Job Task No" <> '' then begin
                            if not JobTaskRec.Get(Rec."Job No.", Res."NS_Default Job Task No") then
                                Error('You cannot insert Resouce Line having Job Task No. %1 not defined in Task lines of Job %2', Res."NS_Default Job Task No", Rec."Job No.");
                            JPLRec3."Job Task No." := Res."NS_Default Job Task No";
                        end
                        else
                            JPLRec3."Job Task No." := Rec."Job Task No.";
                        JPLRec3."Line No." := GetLineNoFormJPL(Rec);
                        JPLRec3."NS_Resource Line No." := Rec."Line No.";
                        JPLRec3."NS_Entry Type" := Rec."NS_Entry Type";
                        JPLRec3."Line Type" := Rec."Line Type";
                        JPLRec3."Document No." := Rec."Document No.";
                        JPLRec3."Document Date" := Rec."Document Date";
                        JPLRec3."Planning Date" := Rec."Planning Date";
                        JPLRec3."NS_Quote Category" := Rec."NS_Quote Category";
                        //JPLRec3."NS_Quote Category Type" := Rec."NS_Quote Category Type";
                        JPLRec3."NS_Shortcut Dimension 1 Code" := Rec."NS_Shortcut Dimension 1 Code";
                        JPLRec3."NS_Shortcut Dimension 2 Code" := Rec."NS_Shortcut Dimension 2 Code";
                        JPLRec3."Planned Delivery Date" := Rec."Planned Delivery Date";
                        JPLRec3."NS_Progress Billing Method" := Rec."NS_Progress Billing Method";
                        JPLRec3.Type := JPLRec2.Type::Resource;
                        JPLRec3."No." := NS_LinkedResources."NS_Linked Resource";
                        IF Res.GET(NS_LinkedResources."NS_Linked Resource") Then begin
                            IF Res."NS_Job Revenue Category" <> '' THEN
                                JPLRec3."NS_Revenue Category" := Res."NS_Job Revenue Category";
                            IF Res."NS_Job Cost Category" <> '' THEN
                                JPLRec3."NS_Cost Category" := Res."NS_Job Cost Category";
                            JPLRec3.Description := Res.Name;
                            JPLRec3."Description 2" := Res."Name 2";
                            JPLRec3."Gen. Prod. Posting Group" := Res."Gen. Prod. Posting Group";
                            JPLRec3."Resource Group No." := Res."Resource Group No.";
                            JPLRec3."Unit of Measure Code" := Res."Base Unit of Measure";
                            JPLRec3."Unit Cost" := Res."Unit Cost";
                            JPLRec3."Unit Price" := Res."Unit Price";
                        end;
                        JPLRec3.Validate(Quantity, Rec.Quantity * NS_LinkedResources."NS_Labor Hr. per Qty");
                        JPLRec3."Planning Date" := Rec."Planning Date";
                        JPLRec3."Planned Delivery Date" := Rec."Planned Delivery Date";
                        JPLRec3."NS_Parent Linked Item" := Rec."No.";
                        JPLRec3."NS_Labor Hours per Qty." := NS_LinkedResources."NS_Labor Hr. per Qty";


                        if jobTblRec.get(Rec."Job No.") then;
                        JPLRec3."Gen. Bus. Posting Group" := jobTblRec."NS_Gen. Bus. Posting Group New";
                        JPLRec3."Customer Price Group" := jobTblRec."Customer Price Group";
                        JPLRec3."NS_Segment Code" := Rec."NS_Segment Code";
                        JPLRec3."NS_Segment Name" := Rec."NS_Segment Name";
                        JPLRec3."NS_Segment Type" := Rec."NS_Segment Type";
                        JPLRec3."User ID" := Rec."User ID";
                        JPLRec3.INSERT;
                    Until NS_LinkedResources.Next() = 0;
                end;
            //End;
        end;
    end;

    local procedure GetLineNoFormJPL(Rec: Record "Job Planning Line") LastLineNo: Integer;
    var
        JPLRec: Record "Job Planning Line";
    begin

        JPLRec.SetCurrentKey("Job No.", "Job Task No.");
        JPLRec.SetRange("Job No.", Rec."Job No.");
        JPLRec.SetRange("Job Task No.", Rec."Job Task No.");
        if JPLRec.FindLast() then
            exit(JPLRec."Line No." + 10000);
    end;
    //PE-323 AT.01 03July2024 End
}

