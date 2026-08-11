codeunit 14021109 "NS_Parameters for Table Events"
{
    // version SPLN1.00

    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        T37TotalVATBase: Decimal;
        T37TotalAmount: Decimal;
        T37TotalAmountInclVAT: Decimal;
        T37TotalQuantityBase: Decimal;
        T37QtyTypeLocal: Option General,Invoicing,Shipping;
        T39NS_JobCurrencyFactorHold: Decimal;
        T39NS_JobCurrencyCodeHold: Code[20];
        T39GenBusPostingGroupTemp: Code[20];
        T39TotalLineAmount: Decimal;
        T39TotalInvDiscAmount: Decimal;
        T39TotalAmount: Decimal;
        T39TotalAmountInclVAT: Decimal;
        T39TotalQuantityBase: Decimal;
        T81NS_LedgerNoHold: Code[20];
        T36TestSalesLineFieldsBeforeRecreate_JobNo: Code[20];
        Navigate_NS_NewLedgerNo: Code[20];
        Navigate_NS_NewDocNo: Code[20];
        Navigate_NS_NewPostingDate: Date;
        T210TimeSheetNo: Code[20];
        T7RecId: RecordId;
        T38CreateDimType2: Integer;
        T38CreateDimCode2: Code[20];
        T39StdTextRecId: RecordId;
        T39No_PurchLine: Record "Purchase Line";
        T39JobPlanningLineNo_UsageLink: Boolean;
        GetValueOfLineType: Integer;
        SetValueOfLineType: Integer;
        //PPNA16.0 
        JobTaskNo_T210: Code[20];
        JobNo_T210: code[20];
        CurrencyCode_T210: Code[10];
    //PPNA16.0 

    procedure NS_T39SetJobPlanningLineNo_UsageLink(inT39JobPlanningLineNo_UsageLink: Boolean)
    begin
        T39JobPlanningLineNo_UsageLink := inT39JobPlanningLineNo_UsageLink;
    end;

    procedure NS_T39GetJobPlanningLineNo_UsageLink(): Boolean
    begin
        exit(T39JobPlanningLineNo_UsageLink);
    end;

    procedure NS_T39SetNo_PurchaseLine(inPurchaseLine: Record "Purchase Line")
    begin
        T39No_PurchLine := inPurchaseLine;
    end;

    procedure NS_T39GetNo_PurchaseLine(var outPurchaseLine: Record "Purchase Line");
    begin
        outPurchaseLine := T39No_PurchLine;
    end;

    procedure NS_T39SetStdTextRecId(inRecId: RecordId)
    begin
        T39StdTextRecId := inRecId;
    end;

    procedure NS_T39GetStdTextRecId(var outRecId: RecordId)
    begin
        outRecId := T39StdTextRecId;
    end;

    procedure NS_T38SetCreateDim(inType: Integer; inCode: Code[20])
    begin
        T38CreateDimCode2 := inCode;
        T38CreateDimType2 := inType;
    end;

    procedure NS_T38GetCreateDim(var outType: Integer; outCode: Code[20])
    begin
        outCode := T38CreateDimCode2;
        outType := T38CreateDimType2;
    end;

    procedure NS_T7SetRecId(inRecId: RecordId)
    begin
        T7RecId := inRecId;
    end;

    procedure NS_T7GetRecId(var outRecId: RecordId)
    begin
        outRecId := T7RecId;
    end;

    procedure NS_T210SetTimeSheetNo(inTimeSheetNo: Code[20])
    begin
        T210TimeSheetNo := inTimeSheetNo;
    end;

    procedure NS_T210GetTimeSheetNo(): Code[20]
    begin
        exit(T210TimeSheetNo);
    end;

    procedure NS_SetNS_Navigate(inPostingDate: Date; inDocNo: Code[20]; inLedgerNo: code[20])
    begin
        Navigate_NS_NewDocNo := inDocNo;
        Navigate_NS_NewLedgerNo := inLedgerNo;
        Navigate_NS_NewPostingDate := inPostingDate;
    end;

    procedure NS_GetNS_Navigate(var outPostingDate: Date; var outDocNo: Code[20]; var outLedgerNo: code[20])
    begin
        outDocNo := Navigate_NS_NewDocNo;
        outLedgerNo := Navigate_NS_NewLedgerNo;
        outPostingDate := Navigate_NS_NewPostingDate;
    end;

    procedure NS_T36SetT36TestSalesLineFieldsBeforeRecreate_JobNo(TestSalesLineFieldsBeforeRecreate_JobNo: code[20])
    begin
        T36TestSalesLineFieldsBeforeRecreate_JobNo := TestSalesLineFieldsBeforeRecreate_JobNo;
    end;

    procedure NS_T36GetT36TestSalesLineFieldsBeforeRecreate_JobNo(): Code[20]
    begin
        exit(T36TestSalesLineFieldsBeforeRecreate_JobNo);
    end;

    procedure NS_T37SetTotalVATBase(TotalVATBase: Decimal)
    begin
        T37TotalVATBase := TotalVATBase;
    end;

    procedure NS_T37GetTotalVATBase(): Decimal
    begin
        exit(T37TotalVATBase);
    end;

    procedure NS_T37SetTotalAmount(TotalAmount: Decimal)
    begin
        T37TotalAmount := TotalAmount;
    end;

    procedure NS_T37GetTotalAmount(): Decimal
    begin
        exit(T37TotalAmount);
    end;

    procedure NS_T37SetTotalAmountInclVAT(TotalAmountInclVAT: Decimal)
    begin
        T37TotalAmountInclVAT := TotalAmountInclVAT;
    end;

    procedure NS_T37GetTotalAmountInclVAT(): Decimal
    begin
        exit(T37TotalAmountInclVAT);
    end;

    procedure NS_T37SetTotalQuantityBase(TotalQuantityBase: Decimal)
    begin
        T37TotalQuantityBase := TotalQuantityBase;
    end;

    procedure NS_T37GetTotalQuantityBase(): Decimal
    begin
        exit(T37TotalQuantityBase);
    end;

    procedure NS_T37SetQtyTypeLocal(QtyTypeLocal: Option General,Invoicing,Shipping)
    begin
        T37QtyTypeLocal := QtyTypeLocal;
    end;

    procedure NS_T37GetQtyTypeLocal(): Integer
    begin
        exit(T37QtyTypeLocal);
    end;

    procedure NS_T39SetNS_JobCurrencyFactorHold(NS_JobCurrencyFactorHold: Decimal)
    begin
        T39NS_JobCurrencyFactorHold := NS_JobCurrencyFactorHold;
    end;

    procedure NS_T39GetNS_JobCurrencyFactorHold(): Decimal
    begin
        exit(T39NS_JobCurrencyFactorHold);
    end;

    procedure NS_T39SetNS_JobCurrencyCodeHold(NS_JobCurrencyCodeHold: Code[20])
    begin
        T39NS_JobCurrencyCodeHold := NS_JobCurrencyCodeHold;
    end;

    procedure NS_T39GetNS_JobCurrencyCodeHold(): Code[20]
    begin
        exit(T39NS_JobCurrencyCodeHold);
    end;

    procedure NS_T39SetGenBusPostingGroupTemp(GenBusPostingGroup: Code[20])
    begin
        T39GenBusPostingGroupTemp := GenBusPostingGroup;
    end;

    procedure NS_T39GetGenBusPostingGroupTemp(): Code[20]
    begin
        exit(T39GenBusPostingGroupTemp);
    end;

    procedure NS_T39SetTotalLineAmount()
    begin
    end;

    procedure NS_T39GetTotalLineAmount()
    begin
    end;

    procedure NS_T39SetTotalInvDiscAmount()
    begin
    end;

    procedure NS_T39GetTotalInvDiscAmount()
    begin
    end;

    procedure NS_T39SetTotalAmount()
    begin
    end;

    procedure NS_T39GetTotalAmount()
    begin
    end;

    procedure NS_T39SetTotalAmountInclVAT()
    begin
    end;

    procedure NS_T39GetTotalAmountInclVAT()
    begin
    end;

    procedure NS_T39SetTotalQuantityBase()
    begin
    end;

    procedure NS_T39GetTotalQuantityBase()
    begin
    end;

    procedure NS_T81SetNS_LedgerNoHold(NS_LedgerNoHold: Code[20])
    begin
        T81NS_LedgerNoHold := NS_LedgerNoHold;
    end;

    procedure NS_T81GetNS_LedgerNoHold(): Code[20]
    begin
        exit(T81NS_LedgerNoHold);
    end;

    //PRJ-52.SK.1.0 Start

    procedure NS_SetTypeBeforeJobNoValidate(TypeValue: Integer)

    begin
        SetValueOfLineType := TypeValue;
    end;

    procedure NS_GetTypeBeforeJobNoValidate(): Integer

    begin
        GetValueOfLineType := SetValueOfLineType;
        Exit(GetValueOfLineType);
    end;

    //PRJ-52.SK.1.0 End


    //PPNA16.0 Start
    procedure NS_SetT210FieldsOnBeforeRetrieveCostPrice(JobTaskNo: code[20]; JobNo: code[20]; CurrencyCode: code[10])
    begin
        JobTaskNo_T210 := JobTaskNo;
        JobNo_T210 := JobNo;
        CurrencyCode_T210 := CurrencyCode;

    end;

    procedure NS_GetT210FieldsOnBeforeFindResUnitCost(Var JobTaskNo: code[20]; Var JobNo: code[20]; Var CurrencyCode: code[10])
    begin
        JobTaskNo := JobTaskNo_T210;
        JobNo := JobNo_T210;
        CurrencyCode := CurrencyCode_T210;

    end;
    //PPNA16.0 End

}

