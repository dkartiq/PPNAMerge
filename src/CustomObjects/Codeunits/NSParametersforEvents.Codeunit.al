codeunit 14021110 "NS_Parameters for Events"
{
    // version SPLN1.00
    // For Events. To pass varaibles between different areas of functionality.
    //PRJ-44.Sk.1.0  Commented two functions due to unusability
    //PRJ-52.SK.1.0 Added functions for handling posting of resource
    //PRJ-153.SK.1.0 Added code and function
    //PRJ-179.SK.1.0 Added code and functions
    //PRJ-196 VT 08-04-20 Added Code and Funtions 
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        P10038NS_RetentionBalanceLCY: Decimal;
        P10038PPFinalTotal: Decimal;
        P352Vend: Record Vendor;
        P352PeriodType: Integer;
        P352AmountType: Integer;
        P351Cust: Record Customer;
        P351PeriodType: Integer;
        P351AmountType: Integer;
        P161TotalAmount2: Decimal;
        P160TotalAmount2: Decimal;
        P152RetentionLedgerCodeFilter: Text;
        P151RetentionLedgerCodeFilter: Text;
        C12NewCVLedgEntryBufPositive: Boolean;
        C12NextTransactionNo: Integer;
        C12NS_MainLinkedEntryNo: Integer;
        C12NS_RetentionLinkedEntryNo2: Integer;
        C12NS_RetentionLinkedEntryNo: Integer;
        C7320QtyperUnitofMeasure: Decimal;
        C1011Quantity: Decimal;
        C951TotalQuantity: Decimal;
        C80RemAmt: Decimal;
        C80RemDiscAmt: Decimal;
        C80PostSalesLine_JobNo: Code[20];
        C80NS_GenJnlLineLedgerNo: Code[20];
        C80GenJnlLineDocNo: Code[20];
        C80GenJnlLineExtDocNo: Code[35];
        C80NS_VatPostingGr: Code[20];
        C90NS_GenJnlLineLedgerNo: Code[20];
        C90PurchInvHeader: Record "Purch. Inv. Header";
        C90PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        C90GenJnlLineDocNo: Code[20];
        C90GenJnlLineExtDocNo: Code[35];
        C90SrcCode: Code[10];
        C11CheckAccountNoJob: code[20];
        C90GenJnlLineDocType: Integer;
        C90PostPurchLine_Type: Integer;
        C1006CopyJob: Boolean;
        C12RetentionDocument: Boolean;
        C12RetentionLedgerCode: Code[20];
        P10039NS_RetentionBalanceLCY: Decimal;
        P10039PPFinalTotal: Decimal;
        P10041TaxAmount: Decimal;
        P10041AmountInclTax: Decimal;
        P10041NS_FinalTotal: Decimal;
        P10041NS_RetentionBalanceLCY: Decimal;
        P10042NS_RetentionBalanceLCY: Decimal;
        P10042NS_FinalTotal: Decimal;
        P10043NS_RetentionBalanceLCY: Decimal;
        P10043NS_FinalTotal: Decimal;
        C12NS_OrigGenJnlLine: Record "Gen. Journal Line";
        //PRJ-52.SK.1.0 Start
        PurchInvHeaderRec: Record "Purch. Inv. Header";
        PurchCrMemoHeaderRec: Record "Purch. Cr. Memo Hdr.";
        //PRJ-52.SK.1.0 End
        P88JobNo: code[20]; //PRJ-153.SK.1.0 Added
        LineTypePurchLine: Record "Purchase Line"; //PRJ-179.Sk.1.0 Added
                                                   //PRJ-196 VT 08-04-20 begin
        P10045NS_FinalTotal: Decimal;
        P10045NS_RetentionBalanceLCY: Decimal;
    //PRJ-196 VT 08-04-20 end; 

    procedure NS_C12SetNS_OrigGenJnlLine(var inNS_OrigGenJnlLine: Record "Gen. Journal Line")
    begin
        C12NS_OrigGenJnlLine.Copy(inNS_OrigGenJnlLine);
    end;

    procedure NS_C12GetNS_OrigGenJnlLine(var outNS_OrigGenJnlLine: Record "Gen. Journal Line")
    begin
        outNS_OrigGenJnlLine := C12NS_OrigGenJnlLine;
    end;

    //PPDA.1.0 Start
    // //PRJ-196 VT 08-04-20
    // procedure NS_P10045SetNS_FinalTotal(inNS_FinalTotal: Decimal)
    // begin
    //     P10045NS_FinalTotal := inNS_FinalTotal;
    // end;

    // procedure P10045GetNS_FinalTotal(): Decimal
    // begin
    //     exit(P10045NS_FinalTotal);
    // end;
    //PPDA.1.0 End

    procedure NS_P10045SetNS_RetentionBalanceLCY(inNS_RetentionBalanceLCY: Decimal)
    begin
        P10045NS_RetentionBalanceLCY := inNS_RetentionBalanceLCY;
    end;

    procedure NS_P10045GetNS_RetentionBalanceLCY(): Decimal
    begin
        exit(P10045NS_RetentionBalanceLCY);
    end;
    //PRJ-196 VT 08-04-20



    //PPDA.1.0 Start
    // procedure NS_P10043SetNS_FinalTotal(inNS_FinalTotal: Decimal)
    // begin
    //     P10043NS_FinalTotal := inNS_FinalTotal;
    // end;

    // procedure NS_P10043GetNS_FinalTotal(): Decimal
    // begin
    //     exit(P10043NS_FinalTotal);
    // end;
    //PPDA.1.0 End


    //PPDA.1.0 Start
    // procedure NS_P10043SetNS_RetentionBalanceLCY(inNS_RetentionBalanceLCY: Decimal)
    // begin
    //     P10043NS_RetentionBalanceLCY := inNS_RetentionBalanceLCY;
    // end;

    // procedure NS_P10043GetNS_RetentionBalanceLCY(): Decimal
    // begin
    //     exit(P10043NS_RetentionBalanceLCY);
    // end;
    //PPDA.1.0 End

    //PPDA.1.0 Start
    // procedure NS_P10042SetNS_FinalTotal(inNS_FinalTotal: Decimal)
    // begin
    //     P10042NS_FinalTotal := inNS_FinalTotal;
    // end;

    // procedure NS_P10042GetNS_FinalTotal(): Decimal
    // begin
    //     exit(P10042NS_FinalTotal);
    // end;
    //PPDA.1.0 End



    //PPDA.1.0 Start
    // procedure NS_P10042SetNS_RetentionBalanceLCY(inNS_RetentionBalanceLCY: Decimal)
    // begin
    //     P10042NS_RetentionBalanceLCY := inNS_RetentionBalanceLCY;
    // end;

    // procedure NS_P10042GetNS_RetentionBalanceLCY(): Decimal
    // begin
    //     exit(P10042NS_RetentionBalanceLCY);
    // end;
    //PPDA.1.0 End


    //PPDA.1.0 Start
    // procedure NS_P10041SetTaxAmount(inTaxAmount: Decimal)
    // begin
    //     P10041TaxAmount := inTaxAmount;
    // end;

    // procedure NS_P10041SetAmountInclTax(inAmountInclTax: Decimal)
    // begin
    //     P10041AmountInclTax := inAmountInclTax;
    // end;

    // procedure NS_P10041SetNS_FinalTotal(inNS_FinalTotal: Decimal)
    // begin
    //     P10041NS_FinalTotal := inNS_FinalTotal;
    // end;

    // procedure NS_P10041SetNS_RetentionBalanceLCY(inNS_RetentionBalanceLCY: Decimal)
    // begin
    //     P10041NS_RetentionBalanceLCY := inNS_RetentionBalanceLCY;
    // end;
    //PPDA.1.0 End

    procedure NS_P10041Get(var NS_RetentionBalanceLCY: Decimal; var NS_FinalTotal: Decimal; var NS_AmountInclTax: Decimal; var NS_TaxAmount: Decimal);
    begin
        NS_RetentionBalanceLCY := P10041NS_RetentionBalanceLCY;
        NS_FinalTotal := P10041NS_FinalTotal;
        NS_AmountInclTax := P10041AmountInclTax;
        NS_TaxAmount := P10041TaxAmount;
    end;

    //PPDA.1.0 Start
    // procedure NS_P10039SetNS_RetentionBalanceLCY(inNS_RetentionBalanceLCY: Decimal)
    // begin
    //     P10039NS_RetentionBalanceLCY := inNS_RetentionBalanceLCY;
    // end;

    // procedure NS_P10039GetNS_RetentionBalanceLCY(): Decimal
    // begin
    //     exit(P10039NS_RetentionBalanceLCY);
    // end;

    // procedure NS_P10039SetPPFinalTotal(inPPFinalTotal: Decimal)
    // begin
    //     P10039PPFinalTotal := inPPFinalTotal;
    // end;

    // procedure NS_P10039GetPPFinalTotal(): Decimal
    // begin
    //     exit(P10039PPFinalTotal);
    // end;
    //PPDA.1.0 End


    //PPDA.1.0 Start
    // procedure NS_P10038SetNS_RetentionBalanceLCY(inNS_RetentionBalanceLCY: Decimal)
    // begin
    //     P10038NS_RetentionBalanceLCY := inNS_RetentionBalanceLCY;
    // end;

    // procedure NS_P10038GetNS_RetentionBalanceLCY(): Decimal
    // begin
    //     exit(P10038NS_RetentionBalanceLCY);
    // end;

    // procedure NS_P10038SetPPFinalTotal(inPPFinalTotal: Decimal)
    // begin
    //     P10038PPFinalTotal := inPPFinalTotal;
    // end;

    // procedure NS_P10038GetPPFinalTotal(): Decimal
    // begin
    //     exit(P10038PPFinalTotal);
    // end;
    //PPDA.1.0 End
    procedure NS_P352SetPram(VAR newVend: Record Vendor; newPeriodType: Integer; newAmountType: Integer)
    begin
        P352AmountType := newAmountType;
        P352PeriodType := newPeriodType;
        P352Vend.COPY(newVend);
    end;

    procedure NS_P352GetParam(VAR newVend: Record Vendor; var newPeriodType: Integer; var newAmountType: Integer)
    begin
        newVend.Copy(P352Vend);
        newPeriodType := P352PeriodType;
        newAmountType := P352AmountType;
    end;

    procedure NS_P351SetPram(VAR newCust: Record Customer; newPeriodType: Integer; newAmountType: Integer)
    begin
        P351AmountType := newAmountType;
        P351PeriodType := newPeriodType;
        P351Cust.COPY(newCust);
    end;

    procedure NS_P351GetParam(VAR newCust: Record Customer; var newPeriodType: Integer; var newAmountType: Integer)
    begin
        newCust.Copy(P351Cust);
        newPeriodType := P351PeriodType;
        newAmountType := P351AmountType;
    end;

    procedure NS_P161SetTotalAmount2(inTotalAmount2: Decimal)
    begin
        P161TotalAmount2 := inTotalAmount2;
    end;

    procedure NS_P161GetTotalAmount2(): Decimal
    begin
        exit(P161TotalAmount2);
    end;

    procedure NS_P160SetTotalAmount2(inTotalAmount2: Decimal)
    begin
        P160TotalAmount2 := inTotalAmount2;
    end;

    procedure NS_P160GetTotalAmount2(): Decimal
    begin
        exit(P160TotalAmount2);
    end;

    procedure NS_P152SetRetentionLedgerCodeFilter(inRetentionLedgerCodeFilter: Text)
    begin
        P152RetentionLedgerCodeFilter := inRetentionLedgerCodeFilter;
    end;

    procedure NS_P152GetRetentionLedgerCodeFilter(): Text
    begin
        exit(P152RetentionLedgerCodeFilter);
    end;

    procedure NS_P151SetRetentionLedgerCodeFilter(inRetentionLedgerCodeFilter: Text)
    begin
        P151RetentionLedgerCodeFilter := inRetentionLedgerCodeFilter;
    end;

    procedure NS_P151GetRetentionLedgerCodeFilter(): Text
    begin
        exit(P151RetentionLedgerCodeFilter);
    end;

    procedure NS_C12SetNewCVLedgEntryBufPositive(inNewCVLedgEntryBufPositive: Boolean)
    begin
        C12NewCVLedgEntryBufPositive := inNewCVLedgEntryBufPositive;
    end;

    procedure NS_C12GetNewCVLedgEntryBufPositive(): Boolean
    begin
        exit(C12NewCVLedgEntryBufPositive);
    end;

    procedure NS_C12SetNextTransactionNo(inNextTransactionNo: Integer)
    begin
        C12NextTransactionNo := inNextTransactionNo;
    end;

    procedure NS_C12GetNextTransactionNo(): Integer
    begin
        exit(C12NextTransactionNo);
    end;

    procedure NS_C12SetNS_MainLinkedEntryNo(inNS_MainLinkedEntryNo: Integer)
    begin
        C12NS_MainLinkedEntryNo := inNS_MainLinkedEntryNo;
    end;

    procedure NS_C12GetNS_MainLinkedEntryNo(): Integer
    begin
        exit(C12NS_MainLinkedEntryNo);
    end;

    procedure NS_C12SetNS_RetentionLinkedEntryNo2(inNS_RetentionLinkedEntryNo2: Integer)
    begin
        C12NS_RetentionLinkedEntryNo2 := inNS_RetentionLinkedEntryNo2;
    end;

    procedure NS_C12GetNS_RetentionLinkedEntryNo2(): Integer
    begin
        exit(C12NS_RetentionLinkedEntryNo2);
    end;

    procedure NS_C12SetNS_RetentionLinkedEntryNo(inNS_RetentionLinkedEntryNo: Integer)
    begin
        C12NS_RetentionLinkedEntryNo := inNS_RetentionLinkedEntryNo;
    end;

    procedure NS_C12GetNS_RetentionLinkedEntryNo(): Integer
    begin
        exit(C12NS_RetentionLinkedEntryNo);
    end;

    procedure NS_C7320SetQtyperUnitofMeasure(inQtyperUnitofMeasure: Decimal)
    begin
        C7320QtyperUnitofMeasure := inQtyperUnitofMeasure;
    end;

    procedure NS_C7320GetQtyperUnitofMeasure(): Decimal
    begin
        exit(C7320QtyperUnitofMeasure);
    end;

    //PRJ-44.Sk.1.0 Start
    // procedure C1011SetQuantity(inQuantity: Decimal)
    // begin
    //     C1011Quantity := inQuantity;
    // end;

    // procedure C1011GetQuantity(): Decimal
    // begin
    //     exit(C1011Quantity);
    // end;
    //PRJ-44.Sk.1.0 End
    procedure NS_C951SetTotalQuantity(inTotalQuantity: Decimal)
    begin
        C951TotalQuantity := inTotalQuantity;
    end;

    procedure NS_C951GetTotalQuantity(): Decimal
    begin
        exit(C951TotalQuantity);
    end;

    procedure NS_C80SetRemDiscAmt(inRemDiscAmt: Decimal)
    begin
        C80RemDiscAmt := inRemDiscAmt;
    end;

    procedure NS_C80GetRemDiscAmt(): Decimal
    begin
        exit(C80RemDiscAmt);
    end;

    procedure NS_C80SetRemAmt(inRemAmt: Decimal)
    begin
        C80RemAmt := inRemAmt;
    end;

    procedure NS_C80GetRemAmt(): Decimal
    begin
        exit(C80RemAmt);
    end;

    procedure NS_C80SetPostSalesLine_JobNo(inPostSalesLine_JobNo: Code[20])
    begin
        C80PostSalesLine_JobNo := inPostSalesLine_JobNo;
    end;

    procedure NS_C80GetPostSalesLine_JobNo(): Code[20]
    begin
        exit(C80PostSalesLine_JobNo);
    end;

    procedure NS_C80SetNS_GenJnlLineLedgerNo(inC90NS_GenJnlLineLedgerNo: Code[20])
    begin
        C80NS_GenJnlLineLedgerNo := inC90NS_GenJnlLineLedgerNo;
    end;

    procedure NS_C80GetNS_GenJnlLineLedgerNo(): Code[20]
    begin
        exit(C80NS_GenJnlLineLedgerNo);
    end;

    procedure NS_C80SetGenJnlLineExtDocNo(inC80GenJnlLineExtDocNo: Code[35])
    begin
        C80GenJnlLineExtDocNo := inC80GenJnlLineExtDocNo;
    end;

    procedure NS_C80GetGenJnlLineExtDocNo(): Code[35]
    begin
        exit(C80GenJnlLineExtDocNo);
    end;

    procedure NS_C80SetGenJnlLineDocNo(inC80GenJnlLineDocNo: Code[20])
    begin
        C80GenJnlLineDocNo := inC80GenJnlLineDocNo;
    end;

    procedure NS_C80GetGenJnlLineDocNo(): Code[20]
    begin
        exit(C80GenJnlLineDocNo);
    end;

    procedure NS_C80GetNS_VatPostingGr(): Code[20]
    begin
        exit(C80NS_VatPostingGr);
    end;

    procedure NS_C80SetNS_VatPostingGr(inNS_VatPostingGr: Code[20])
    begin
        C80NS_VatPostingGr := inNS_VatPostingGr;
    end;

    procedure NS_C90SetGenJnlLineDocType(inC90GenJnlLineDocType: Integer)
    begin
        C90GenJnlLineDocType := inC90GenJnlLineDocType;
    end;

    procedure NS_C90GetGenJnlLineDocType(): Integer
    begin
        exit(C90GenJnlLineDocType);
    end;

    procedure NS_C90SetGenJnlLineExtDocNo(inC90GenJnlLineExtDocNo: Code[35])
    begin
        C90GenJnlLineExtDocNo := inC90GenJnlLineExtDocNo;
    end;

    procedure NS_C90GetGenJnlLineExtDocNo(): Code[35]
    begin
        exit(C90GenJnlLineExtDocNo);
    end;

    procedure NS_C90SetGenJnlLineDocNo(inC90GenJnlLineDocNo: Code[20])
    begin
        C90GenJnlLineDocNo := inC90GenJnlLineDocNo;
    end;

    procedure NS_C90GetGenJnlLineDocNo(): Code[20]
    begin
        exit(C90GenJnlLineDocNo);
    end;

    procedure NS_C90SetNS_GenJnlLineLedgerNo(inC90NS_GenJnlLineLedgerNo: Code[20])
    begin
        C90NS_GenJnlLineLedgerNo := inC90NS_GenJnlLineLedgerNo;
    end;

    procedure NS_C90GetNS_GenJnlLineLedgerNo(): Code[20]
    begin
        exit(C90NS_GenJnlLineLedgerNo)
    end;

    procedure NS_C90SetPostPurchLine_Type(inType: Integer)
    begin
        C90PostPurchLine_Type := inType;
    end;

    procedure NS_C90GetPostPurchLine_Type(): Integer
    begin
        exit(C90PostPurchLine_Type);
    end;

    procedure NS_SetC1006CopyJob(Val: Boolean)
    begin
        C1006CopyJob := Val;
    end;

    procedure NS_GetC1006CopyJob(): Boolean
    begin
        exit(C1006CopyJob);
    end;

    procedure NS_C12SetOnPostCustOnAfterCopyCVLedgEntryBuf(RetentionDocument: Boolean; RetentionLedgerCode: Code[20])
    begin
        C12RetentionDocument := RetentionDocument;
        C12RetentionLedgerCode := RetentionLedgerCode;
    end;

    procedure NS_C12GetOnPostCustOnAfterCopyCVLedgEntryBuf(var RetentionDocument: Boolean; var RetentionLedgerCode: Code[20])
    begin
        RetentionDocument := C12RetentionDocument;
        RetentionLedgerCode := C12RetentionLedgerCode;
    end;

    //PRJ-40.SK.1.0 Modified
    procedure NS_C11SetJobNoBeforeCheckAccountNo(JobNo: code[20])

    begin
        C11CheckAccountNoJob := JobNo;
    end;

    procedure NS_C11GetJobNoBeforeCheckAccountNo(): Code[20]

    begin
        Exit(C11CheckAccountNoJob);
    end;
    //PRJ-40.SK.1.0 Modified

    //PRJ-52.SK.1.0 Start
    procedure NS_C90SetPurchInvHeader(PurchInvHeader: Record "Purch. Inv. Header")

    begin
        PurchInvHeaderRec := PurchInvHeader;
    end;

    procedure NS_C90GetPurchInvHeader(Var PurchInvHeaderRecC90: Record "Purch. Inv. Header")
    begin
        PurchInvHeaderRecC90 := PurchInvHeaderRec;
    end;

    procedure NS_C90SetPurchCrMemoHeader(PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.")

    begin
        PurchCrMemoHeaderRec := PurchCrMemoHeader;
    end;

    procedure NS_C90GetPurchCrMemoHeader(Var PurchCrMemoHeaderC90: Record "Purch. Cr. Memo Hdr.")
    begin
        PurchCrMemoHeaderC90 := PurchCrMemoHeaderRec;
    end;
    //PRJ-52.SK.1.0 End

    //PRJ-153.SK.1.0 Start
    procedure NS_P88SetJobNo(JobNo: code[20])
    begin
        P88JobNo := JobNo;
    end;

    procedure NS_P88GetJobNo(): Code[20]
    begin
        exit(P88JobNo);
    end;
    //PRJ-153.SK.1.0 End

    //PRJ-179.SK.1.0 Start
    procedure NS_SetPurchLineTypeC90(JobPurchLine: Record "Purchase Line")
    begin
        LineTypePurchLine := JobPurchLine;
    end;

    procedure GNS_etPurchLineTypeC90(var GetJobPurchLine: Record "Purchase Line")
    begin
        GetJobPurchLine.Type := LineTypePurchLine.Type;
    end;
    //PRJ-179.SK.1.0 End
}

