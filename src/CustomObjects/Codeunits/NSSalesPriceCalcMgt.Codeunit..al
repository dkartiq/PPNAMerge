codeunit 14021118 "NS_Sales Price Calc. Mgt."
{
    // version NAVW113.01,PPNA11.00,SPLN

    // SPLN1.00 2019-01-28 Created.
    //   Functions copied from codeunit 7000

    //PRJ-72 VT 06-03-20 Called InitRoundingPrecisionsPP in place of InitRoundingPrecisions
    //PRJ-158/159 VT 27-03-20 Subscriber Added
    //PRJ-1003-PRJ-1004-JS.1.0  25Oct2021 | Add condition in code

    trigger OnRun()
    begin
    end;

    var
        CurrExchRate: Record "Currency Exchange Rate";
        UnitAmountRoundingPrecision: Decimal;
        AmountRoundingPrecision: Decimal;
        UnitAmountRoundingPrecisionFCY: Decimal;
        AmountRoundingPrecisionFCY: Decimal;
        Res: Record Resource;
        DateCaption: Text[30];
        TempSalesPrice: Record "Sales Price" temporary;
        TempSalesLineDisc: Record "Sales Line Discount" temporary;
        Currency: Record Currency;
        VATPerCent: Decimal;
        VATBusPostingGr: Code[20];
        PricesInclVAT: Boolean;
        VATCalcType: Option "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        AllowLineDisc: Boolean;
        AllowInvDisc: Boolean;
        LineDiscPerCent: Decimal;
        PricesInCurrency: Boolean;
        CurrencyFactor: Decimal;
        ExchRateDate: Date;
        GLSetup: Record "General Ledger Setup";
        Item: Record Item;
        FoundSalesPrice: Boolean;
        ResPrice: Record "Resource Price";
        QtyPerUOM: Decimal;
        Qty: Decimal;
        Text000: Label '%1 is less than %2 in the %3.';
        Text010: Label 'Prices including Tax cannot be calculated when %1 is %2.';
        Text018: Label '%1 %2 is greater than %3 and was adjusted to %4.';
        Text001: Label 'The %1 in the %2 must be same as in the %3.';
        TempTableErr: Label 'The table passed as a parameter must be temporary.';


    //PRJ-158/159 VT 27-03-20 Begin
    [EventSubscriber(ObjectType::Codeunit, 7000, 'OnBeforeFindJobJnlLineResPrice', '', false, false)]
    local procedure NS_C7000OnBeforeFindJobJnlLineResPrice(var JobJournalLine: Record "Job Journal Line"; var ResourcePrice: Record "Resource Price")
    var

    begin
        ResourcePrice."NS_Job No." := JobJournalLine."Job No.";
    end;
    //PRJ-158/159 VT 27-03-20 end



    //PPNA17.0 Opened Start OnAfterFindJobJnlLinePrice
    [EventSubscriber(ObjectType::Codeunit, 7000, 'OnFindJobJnlLinePriceOnBeforeJobJnlLineFindJTPrice', '', false, false)]
    local procedure NS_C7000OnAfterFindJobJnlLinePrice(var JobJnlLine: Record "Job Journal Line")
    var
        Job: Record Job;
    begin

        //ProjectPro - start
        NS_JobJnlLineFindCostCategoryPrice(JobJnlLine);
        //ProjectPro - end
    end;
    //PPNA17.0 Opened End



    //PPNA17.0 Opened Start OnAfterJobPlanningLineFindJTPrice
    [EventSubscriber(ObjectType::Codeunit, 7000, 'OnBeforeJobPlanningLineFindJTPrice', '', false, false)]
    local procedure NS_C7000OnAfterJobPlanningLineFindJTPrice(var JobPlanningLine: Record "Job Planning Line"; var IsHandled: Boolean)
    var
        JobItemPrice: Record "Job Item Price";
        JobResPrice: Record "Job Resource Price";
        JobGLAccPrice: Record "Job G/L Account Price";
    begin
        with JobPlanningLine do
            case Type of
                Type::Item:
                    begin
                        JobItemPrice.SetRange("Job No.", "Job No.");
                        JobItemPrice.SetRange("Item No.", "No.");
                        JobItemPrice.SetRange("Variant Code", "Variant Code");
                        JobItemPrice.SetRange("Unit of Measure Code", "Unit of Measure Code");
                        JobItemPrice.SetRange("Currency Code", "Currency Code");
                        JobItemPrice.SetRange("Job Task No.", "Job Task No.");
                        if JobItemPrice.FindFirst then
                            NS_CopyJobItemPriceToJobPlanLine(JobPlanningLine, JobItemPrice)
                        else begin
                            JobItemPrice.SetRange("Job Task No.", ' ');
                            if JobItemPrice.FindFirst then
                                NS_CopyJobItemPriceToJobPlanLine(JobPlanningLine, JobItemPrice);
                        end;

                        //ProjectPro - start
                        if JobItemPrice.IsEmpty then begin
                            JobItemPrice.Reset;
                            JobItemPrice.SetRange("Job No.", "Job No.");
                            JobItemPrice.SetRange("Job Task No.", "Job Task No.");
                            JobItemPrice.SetRange("Item No.", '');
                            if JobItemPrice.FindFirst then begin
                                JobItemPrice.TestField(NS_Type, JobItemPrice.NS_Type::All);
                                NS_CopyJobItemPriceToJobPlanLine(JobPlanningLine, JobItemPrice);
                            end else begin
                                JobItemPrice.SetRange("Job Task No.", '');
                                if JobItemPrice.FindFirst then begin
                                    JobItemPrice.TestField(NS_Type, JobItemPrice.NS_Type::All);
                                    NS_CopyJobItemPriceToJobPlanLine(JobPlanningLine, JobItemPrice);
                                end;
                            end;
                        end;
                        //ProjectPro - end

                        if JobItemPrice.IsEmpty or (not JobItemPrice."Apply Job Discount") then
                            NS_FindJobPlanningLineLineDisc(JobPlanningLine);
                    end;
                Type::Resource:
                    begin
                        //ProjectPro - start
                        if not "NS_Cost Factor Set By Category" then
                            JobPlanningLine."Cost Factor" := 0;
                        //ProjectPro - end
                        Res.Get("No.");
                        JobResPrice.SetRange("Job No.", "Job No.");
                        JobResPrice.SetRange("Currency Code", "Currency Code");
                        JobResPrice.SetRange("Job Task No.", "Job Task No.");
                        case true of
                            //ProjectPro - start
                            NS_JobPlanningLineFindJobResPriceALL(JobPlanningLine, JobResPrice, JobResPrice.Type::Resource):
                                NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                            NS_JobPlanningLineFindJobResPriceWORKTYPE(JobPlanningLine, JobResPrice, JobResPrice.Type::Resource):
                                NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                            //ProjectPro - end
                            NS_JobPlanningLineFindJobResPrice(JobPlanningLine, JobResPrice, JobResPrice.Type::Resource):
                                NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                            //ProjectPro - start
                            NS_JobPlanningLineFindJobResPriceALL(JobPlanningLine, JobResPrice, JobResPrice.Type::"Group(Resource)"):
                                NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                            NS_JobPlanningLineFindJobResPriceWORKTYPE(JobPlanningLine, JobResPrice, JobResPrice.Type::"Group(Resource)"):
                                NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                            //ProjectPro - end
                            NS_JobPlanningLineFindJobResPrice(JobPlanningLine, JobResPrice, JobResPrice.Type::"Group(Resource)"):
                                NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                            //ProjectPro - start
                            NS_JobPlanningLineFindJobResPriceALL(JobPlanningLine, JobResPrice, JobResPrice.Type::All):
                                NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                            NS_JobPlanningLineFindJobResPriceWORKTYPE(JobPlanningLine, JobResPrice, JobResPrice.Type::All):
                                NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                            //ProjectPro - end
                            NS_JobPlanningLineFindJobResPrice(JobPlanningLine, JobResPrice, JobResPrice.Type::All):
                                NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                            else begin
                                    JobResPrice.SetRange("Job Task No.", '');
                                    case true of
                                        //ProjectPro - start
                                        NS_JobPlanningLineFindJobResPriceALL(JobPlanningLine, JobResPrice, JobResPrice.Type::Resource):
                                            NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                                        NS_JobPlanningLineFindJobResPriceWORKTYPE(JobPlanningLine, JobResPrice, JobResPrice.Type::Resource):
                                            NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                                        //ProjectPro - end
                                        NS_JobPlanningLineFindJobResPrice(JobPlanningLine, JobResPrice, JobResPrice.Type::Resource):
                                            NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                                        //ProjectPro - start
                                        NS_JobPlanningLineFindJobResPriceALL(JobPlanningLine, JobResPrice, JobResPrice.Type::"Group(Resource)"):
                                            NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                                        NS_JobPlanningLineFindJobResPriceWORKTYPE(JobPlanningLine, JobResPrice, JobResPrice.Type::"Group(Resource)"):
                                            NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                                        //ProjectPro - end
                                        NS_JobPlanningLineFindJobResPrice(JobPlanningLine, JobResPrice, JobResPrice.Type::"Group(Resource)"):
                                            NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                                        //ProjectPro - start
                                        NS_JobPlanningLineFindJobResPriceALL(JobPlanningLine, JobResPrice, JobResPrice.Type::All):
                                            NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                                        NS_JobPlanningLineFindJobResPriceWORKTYPE(JobPlanningLine, JobResPrice, JobResPrice.Type::All):
                                            NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                                        //ProjectPro - end
                                        NS_JobPlanningLineFindJobResPrice(JobPlanningLine, JobResPrice, JobResPrice.Type::All):
                                            NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                                    end;
                                end;
                        end;
                    end;
                Type::"G/L Account":
                    begin
                        JobGLAccPrice.SetRange("Job No.", "Job No.");
                        JobGLAccPrice.SetRange("G/L Account No.", "No.");
                        JobGLAccPrice.SetRange("Currency Code", "Currency Code");
                        JobGLAccPrice.SetRange("Job Task No.", "Job Task No.");
                        if JobGLAccPrice.FindFirst then
                            NS_CopyJobGLAccPriceToJobPlanLine(JobPlanningLine, JobGLAccPrice)
                        else begin
                            JobGLAccPrice.SetRange("Job Task No.", '');
                            if JobGLAccPrice.FindFirst then;
                            NS_CopyJobGLAccPriceToJobPlanLine(JobPlanningLine, JobGLAccPrice);
                        end;
                    end;
            end;
    end;
    //PPNA17.0 Opened End

    [EventSubscriber(ObjectType::Codeunit, 7000, 'OnAfterFindServLinePrice', '', false, false)]
    local procedure C7000OnAfterFindServLinePrice(var ServiceLine: Record "Service Line"; ServiceHeader: Record "Service Header"; SalesPrice: Record "Sales Price"; ResourcePrice: Record "Resource Price"; ServiceCost: Record "Service Cost"; CalledByFieldNo: Integer)
    var
        SalesRecvSetup: Record "Sales & Receivables Setup";   //PRJ-1003-PRJ-1004-JS.1.0  25Oct2021
    begin
        //OnAfterFindServLinePrice(ServLine,ServHeader,TempSalesPrice,ResPrice,ServCost,CalledByFieldNo);
        SalesRecvSetup.get();    //PRJ-1003-PRJ-1004-JS.1.0  25Oct2021
        if SalesRecvSetup."NS_Disable Sales Price" = false then begin   //PRJ-1003-PRJ-1004-JS.1.0  25Oct2021
            with ServiceLine do begin
                ServiceHeader.Get("Document Type", "Document No.");
                if Type <> Type::" " then begin
                    NS_SetCurrency(
                      ServiceHeader."Currency Code", ServiceHeader."Currency Factor", NS_ServHeaderExchDate(ServiceHeader));
                    NS_SetVAT(ServiceHeader."Prices Including VAT", "VAT %", "VAT Calculation Type".AsInteger(), "VAT Bus. Posting Group");
                    SetUoM(Abs(Quantity), "Qty. per Unit of Measure");
                    NS_SetLineDisc("Line Discount %", "Allow Line Disc.", false);

                    TestField("Qty. per Unit of Measure");
                    if PricesInCurrency then
                        ServiceHeader.TestField("Currency Factor");
                end;

                case Type of
                    Type::Item:
                        begin
                            NS_ServLinePriceExists(ServiceHeader, ServiceLine, false);
                            NS_CalcBestUnitPrice(TempSalesPrice);
                            if FoundSalesPrice or
                               not ((CalledByFieldNo = FieldNo(Quantity)) or
                                    (CalledByFieldNo = FieldNo("Variant Code")))
                            then begin
                                if "Line Discount Type" = "Line Discount Type"::"Line Disc." then
                                    "Allow Line Disc." := TempSalesPrice."Allow Line Disc.";
                                "Unit Price" := TempSalesPrice."Unit Price";
                            end;
                            if not "Allow Line Disc." and ("Line Discount Type" = "Line Discount Type"::"Line Disc.") then
                                "Line Discount %" := 0;
                        end;
                    Type::Resource:
                        begin
                            //ProjectPro - start
                            //SetResPrice("No.","Work Type Code","Currency Code");
                            NS_SetResPrice("Job No.", "No.", "Work Type Code", "Currency Code");
                            //ProjectPro - end
                            CODEUNIT.Run(CODEUNIT::"Resource-Find Price", ResPrice);
                            NS_ConvertPriceToVAT(false, '', '', ResPrice."Unit Price");
                            ResPrice."Unit Price" := ResPrice."Unit Price" * "Qty. per Unit of Measure";
                            NS_ConvertPriceLCYToFCY(ResPrice."Currency Code", ResPrice."Unit Price");
                            if (ResPrice."Unit Price" > ServiceHeader."Max. Labor Unit Price") and
                               (ServiceHeader."Max. Labor Unit Price" <> 0)
                            then begin
                                Res.Get("No.");
                                "Unit Price" := ServiceHeader."Max. Labor Unit Price";
                            end else
                                "Unit Price" := ResPrice."Unit Price";
                        end;
                    Type::Cost:
                        begin
                            ServiceCost.Get("No.");
                            NS_ConvertPriceToVAT(false, '', '', ServiceCost."Default Unit Price");
                            NS_ConvertPriceLCYToFCY('', ServiceCost."Default Unit Price");
                            "Unit Price" := ServiceCost."Default Unit Price";
                        end;
                end;
            end;
        end;  //PRJ-1003-PRJ-1004-JS.1.0  25Oct2021
    end;

    [EventSubscriber(ObjectType::Codeunit, 7000, 'OnAfterFindSalesLinePrice', '', false, false)]
    local procedure NS_C7000OnAfterFindSalesLinePrice(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; var SalesPrice: Record "Sales Price"; ResourcePrice: Record "Resource Price"; CalledByFieldNo: Integer)
    var
        NS_SalesLine: Record "Sales Line";
        NS_AutoCalc: Boolean;
        NS_UnitPrice: Decimal;
    begin
        with SalesLine do begin
            NS_SetCurrency(
              SalesHeader."Currency Code", SalesHeader."Currency Factor", NS_SalesHeaderExchDate(SalesHeader));
            NS_SetVAT(SalesHeader."Prices Including VAT", "VAT %", "VAT Calculation Type".AsInteger(), "VAT Bus. Posting Group");
            SetUoM(Abs(Quantity), "Qty. per Unit of Measure");
            NS_SetLineDisc("Line Discount %", "Allow Line Disc.", "Allow Invoice Disc.");

            TestField("Qty. per Unit of Measure");
            if PricesInCurrency then
                SalesHeader.TestField("Currency Factor");

            case Type of
                Type::Item:
                    begin
                        Item.Get("No.");
                        NS_SalesLinePriceExists(SalesHeader, SalesLine, false);

                        //ProjectPro - start
                        NS_AutoCalc := true;
                        if SalesLine."Job No." > '' then begin
                            if NS_GetJobPlanningItemPrice(SalesLine, NS_UnitPrice) then begin
                                SalesPrice."Unit Price" := NS_UnitPrice;
                                NS_AutoCalc := false;
                            end;
                        end else begin
                            if SalesHeader."NS_Job No." > '' then begin
                                if SalesLine."Unit Price" = 0 then begin
                                    NS_SalesLine := SalesLine;
                                    NS_SalesLine."Job No." := SalesHeader."NS_Job No.";
                                    if NS_GetJobPlanningItemPrice(NS_SalesLine, NS_UnitPrice) then begin
                                        SalesPrice."Unit Price" := NS_UnitPrice;
                                        NS_AutoCalc := false;
                                    end;
                                end else begin
                                    SalesPrice."Unit Price" := SalesLine."Unit Price";
                                    NS_AutoCalc := false;
                                end;
                            end;
                        end;

                        if NS_AutoCalc then
                            //ProjectPro - end

                            NS_CalcBestUnitPrice(SalesPrice);
                        if FoundSalesPrice or
                           not ((CalledByFieldNo = FieldNo(Quantity)) or
                                (CalledByFieldNo = FieldNo("Variant Code")))
                        then begin
                            "Allow Line Disc." := SalesPrice."Allow Line Disc.";
                            "Allow Invoice Disc." := SalesPrice."Allow Invoice Disc.";
                            "Unit Price" := SalesPrice."Unit Price";
                        end;
                        if not "Allow Line Disc." then
                            "Line Discount %" := 0;
                    end;
                Type::Resource:
                    begin
                        //ProjectPro - start
                        //SetResPrice("No.","Work Type Code","Currency Code");
                        NS_SetResPrice("Job No.", "No.", "Work Type Code", "Currency Code");
                        //ProjectPro - end
                        CODEUNIT.Run(CODEUNIT::"Resource-Find Price", ResPrice);
                        NS_ConvertPriceToVAT(false, '', '', ResPrice."Unit Price");
                        NS_ConvertPriceLCYToFCY(ResPrice."Currency Code", ResPrice."Unit Price");
                        "Unit Price" := ResPrice."Unit Price" * "Qty. per Unit of Measure";
                    end;
            end;
        end;
    end;

    local procedure NS_JobJnlLineFindJobResPrice(var JobJnlLine: Record "Job Journal Line"; var JobResPrice: Record "Job Resource Price"; PriceType: Option Resource,"Group(Resource)",All): Boolean
    begin
        //ProjectPro - start
        JobResPrice.SetRange("NS_Skill Class Code", JobJnlLine."NS_Skill Class");
        //ProjectPro - end
        case PriceType of
            PriceType::Resource:
                begin
                    JobResPrice.SetRange(Type, JobResPrice.Type::Resource);
                    JobResPrice.SetRange("Work Type Code", JobJnlLine."Work Type Code");
                    JobResPrice.SetRange(Code, JobJnlLine."No.");
                    exit(JobResPrice.Find('-'));
                end;
            PriceType::"Group(Resource)":
                begin
                    JobResPrice.SetRange(Type, JobResPrice.Type::"Group(Resource)");
                    JobResPrice.SetRange(Code, Res."Resource Group No.");
                    exit(NS_FindJobResPrice(JobResPrice, JobJnlLine."Work Type Code"));
                end;
            PriceType::All:
                begin
                    JobResPrice.SetRange(Type, JobResPrice.Type::All);
                    JobResPrice.SetRange(Code);
                    exit(NS_FindJobResPrice(JobResPrice, JobJnlLine."Work Type Code"));
                end;
        end;
    end;

    procedure NS_JobJnlLineFindJobResPriceWORKTYPE(var JobJnlLine: Record "Job Journal Line"; var JobResPrice: Record "Job Resource Price"; PriceType: Option Resource,"Group(Resource)",All): Boolean
    begin
        //ProjectPro - start
        if JobJnlLine."NS_Skill Class" <> '' then
            exit(false);
        JobResPrice.SetRange("NS_Skill Class Code");
        JobResPrice.SetRange("Work Type Code", JobJnlLine."Work Type Code");
        case PriceType of
            PriceType::Resource:
                begin
                    JobResPrice.SetRange(Type, JobResPrice.Type::Resource);
                    JobResPrice.SetRange(Code, JobJnlLine."No.");
                    exit(JobResPrice.FindFirst);
                end;
            PriceType::"Group(Resource)":
                begin
                    JobResPrice.SetRange(Type, JobResPrice.Type::"Group(Resource)");
                    JobResPrice.SetRange(Code, Res."Resource Group No.");
                    exit(JobResPrice.FindFirst);
                end;
            PriceType::All:
                begin
                    JobResPrice.SetRange(Type, JobResPrice.Type::All);
                    JobResPrice.SetRange(Code);
                    exit(JobResPrice.FindFirst);
                end;
        end;
        //ProjectPro - end
    end;

    local procedure NS_JobJnlLineLineDiscExists(var JobJnlLine: Record "Job Journal Line"; ShowAll: Boolean): Boolean
    var
        Job: Record Job;
    begin
        with JobJnlLine do
            if (Type = Type::Item) and Item.Get("No.") then begin
                Job.Get("Job No.");
                NS_FindSalesLineDisc(
                  TempSalesLineDisc, Job."Bill-to Customer No.", Job."Bill-to Contact No.",
                  Job."Customer Disc. Group", '', "No.", Item."Item Disc. Group", "Variant Code", "Unit of Measure Code",
                  "Currency Code", NS_JobJnlLineStartDate(JobJnlLine, DateCaption), ShowAll);
                exit(TempSalesLineDisc.Find('-'));
            end;
        exit(false);
    end;

    local procedure NS_JobJnlLineStartDate(JobJnlLine: Record "Job Journal Line"; var DateCaption: Text[30]): Date
    begin
        DateCaption := JobJnlLine.FieldCaption("Posting Date");
        exit(JobJnlLine."Posting Date");
    end;

    local procedure NS_FindJobJnlLineLineDisc(var JobJnlLine: Record "Job Journal Line")
    begin
        with JobJnlLine do begin
            NS_SetCurrency("Currency Code", "Currency Factor", "Posting Date");
            SetUoM(Abs(Quantity), "Qty. per Unit of Measure");
            TestField("Qty. per Unit of Measure");
            if Type = Type::Item then begin
                NS_JobJnlLineLineDiscExists(JobJnlLine, false);
                NS_CalcBestLineDisc(TempSalesLineDisc);
                "Line Discount %" := TempSalesLineDisc."Line Discount %";
            end;
        end;
    end;

    local procedure NS_CopyJobResPriceToJobJnlLine(var JobJnlLine: Record "Job Journal Line"; JobResPrice: Record "Job Resource Price")
    begin
        with JobJnlLine do begin
            if JobResPrice."Apply Job Price" then begin
                "Unit Price" := JobResPrice."Unit Price" * "Qty. per Unit of Measure";
                "Cost Factor" := JobResPrice."Unit Cost Factor";
            end;
            if JobResPrice."Apply Job Discount" then
                "Line Discount %" := JobResPrice."Line Discount %";
        end;
    end;

    local procedure NS_CopyJobItemPriceToJobJnlLine(var JobJnlLine: Record "Job Journal Line"; JobItemPrice: Record "Job Item Price")
    begin
        with JobJnlLine do begin
            if JobItemPrice."Apply Job Price" then begin
                "Unit Price" := JobItemPrice."Unit Price";
                "Cost Factor" := JobItemPrice."Unit Cost Factor";
            end;
            if JobItemPrice."Apply Job Discount" then
                "Line Discount %" := JobItemPrice."Line Discount %";
        end;
    end;

    local procedure NS_JobJnlLineFindJTPrice(var JobJnlLine: Record "Job Journal Line")
    var
        JobItemPrice: Record "Job Item Price";
        JobResPrice: Record "Job Resource Price";
        JobGLAccPrice: Record "Job G/L Account Price";
    begin
        with JobJnlLine do
            case Type of
                Type::Item:
                    begin
                        JobItemPrice.SetRange("Job No.", "Job No.");
                        JobItemPrice.SetRange("Item No.", "No.");
                        JobItemPrice.SetRange("Variant Code", "Variant Code");
                        JobItemPrice.SetRange("Unit of Measure Code", "Unit of Measure Code");
                        JobItemPrice.SetRange("Currency Code", "Currency Code");
                        JobItemPrice.SetRange("Job Task No.", "Job Task No.");
                        if JobItemPrice.FindFirst then
                            NS_CopyJobItemPriceToJobJnlLine(JobJnlLine, JobItemPrice)
                        else begin
                            JobItemPrice.SetRange("Job Task No.", ' ');
                            if JobItemPrice.FindFirst then
                                NS_CopyJobItemPriceToJobJnlLine(JobJnlLine, JobItemPrice);
                        end;

                        //ProjectPro - start
                        if JobItemPrice.IsEmpty then begin
                            JobItemPrice.Reset;
                            JobItemPrice.SetRange("Job No.", "Job No.");
                            JobItemPrice.SetRange("Job Task No.", "Job Task No.");
                            JobItemPrice.SetRange("Item No.", '');
                            if JobItemPrice.FindFirst then begin
                                JobItemPrice.TestField(NS_Type, JobItemPrice.NS_Type::All);
                                NS_CopyJobItemPriceToJobJnlLine(JobJnlLine, JobItemPrice);
                            end else begin
                                JobItemPrice.SetRange("Job Task No.", '');
                                if JobItemPrice.FindFirst then begin
                                    JobItemPrice.TestField(NS_Type, JobItemPrice.NS_Type::All);
                                    NS_CopyJobItemPriceToJobJnlLine(JobJnlLine, JobItemPrice);
                                end;
                            end;
                        end;
                        //ProjectPro - end

                        if JobItemPrice.IsEmpty or (not JobItemPrice."Apply Job Discount") then
                            NS_FindJobJnlLineLineDisc(JobJnlLine);
                    end;
                Type::Resource:
                    begin
                        Res.Get("No.");
                        JobResPrice.SetRange("Job No.", "Job No.");
                        JobResPrice.SetRange("Currency Code", "Currency Code");
                        JobResPrice.SetRange("Job Task No.", "Job Task No.");
                        case true of
                            //ProjectPro - start
                            NS_JobJnlLineFindJobResPriceALL(JobJnlLine, JobResPrice, JobResPrice.Type::Resource):
                                NS_CopyJobResPriceToJobJnlLine(JobJnlLine, JobResPrice);
                            NS_JobJnlLineFindJobResPriceWORKTYPE(JobJnlLine, JobResPrice, JobResPrice.Type::Resource):
                                NS_CopyJobResPriceToJobJnlLine(JobJnlLine, JobResPrice);
                            //ProjectPro - end
                            NS_JobJnlLineFindJobResPrice(JobJnlLine, JobResPrice, JobResPrice.Type::Resource):
                                NS_CopyJobResPriceToJobJnlLine(JobJnlLine, JobResPrice);
                            //ProjectPro - start
                            NS_JobJnlLineFindJobResPriceALL(JobJnlLine, JobResPrice, JobResPrice.Type::"Group(Resource)"):
                                NS_CopyJobResPriceToJobJnlLine(JobJnlLine, JobResPrice);
                            NS_JobJnlLineFindJobResPriceWORKTYPE(JobJnlLine, JobResPrice, JobResPrice.Type::"Group(Resource)"):
                                NS_CopyJobResPriceToJobJnlLine(JobJnlLine, JobResPrice);
                            //ProjectPro - end
                            NS_JobJnlLineFindJobResPrice(JobJnlLine, JobResPrice, JobResPrice.Type::"Group(Resource)"):
                                NS_CopyJobResPriceToJobJnlLine(JobJnlLine, JobResPrice);
                            //ProjectPro - start
                            NS_JobJnlLineFindJobResPriceALL(JobJnlLine, JobResPrice, JobResPrice.Type::All):
                                NS_CopyJobResPriceToJobJnlLine(JobJnlLine, JobResPrice);
                            NS_JobJnlLineFindJobResPriceWORKTYPE(JobJnlLine, JobResPrice, JobResPrice.Type::All):
                                NS_CopyJobResPriceToJobJnlLine(JobJnlLine, JobResPrice);
                            //ProjectPro - end
                            NS_JobJnlLineFindJobResPrice(JobJnlLine, JobResPrice, JobResPrice.Type::All):
                                NS_CopyJobResPriceToJobJnlLine(JobJnlLine, JobResPrice);
                            else begin
                                    JobResPrice.SetRange("Job Task No.", '');
                                    case true of
                                        //ProjectPro - start
                                        NS_JobJnlLineFindJobResPriceALL(JobJnlLine, JobResPrice, JobResPrice.Type::Resource):
                                            NS_CopyJobResPriceToJobJnlLine(JobJnlLine, JobResPrice);
                                        NS_JobJnlLineFindJobResPriceWORKTYPE(JobJnlLine, JobResPrice, JobResPrice.Type::Resource):
                                            NS_CopyJobResPriceToJobJnlLine(JobJnlLine, JobResPrice);
                                        //ProjectPro - end
                                        NS_JobJnlLineFindJobResPrice(JobJnlLine, JobResPrice, JobResPrice.Type::Resource):
                                            NS_CopyJobResPriceToJobJnlLine(JobJnlLine, JobResPrice);
                                        //ProjectPro - start
                                        NS_JobJnlLineFindJobResPriceALL(JobJnlLine, JobResPrice, JobResPrice.Type::"Group(Resource)"):
                                            NS_CopyJobResPriceToJobJnlLine(JobJnlLine, JobResPrice);
                                        NS_JobJnlLineFindJobResPriceWORKTYPE(JobJnlLine, JobResPrice, JobResPrice.Type::"Group(Resource)"):
                                            NS_CopyJobResPriceToJobJnlLine(JobJnlLine, JobResPrice);
                                        //ProjectPro - end
                                        NS_JobJnlLineFindJobResPrice(JobJnlLine, JobResPrice, JobResPrice.Type::"Group(Resource)"):
                                            NS_CopyJobResPriceToJobJnlLine(JobJnlLine, JobResPrice);
                                        //ProjectPro - start
                                        NS_JobJnlLineFindJobResPriceALL(JobJnlLine, JobResPrice, JobResPrice.Type::All):
                                            NS_CopyJobResPriceToJobJnlLine(JobJnlLine, JobResPrice);
                                        NS_JobJnlLineFindJobResPriceWORKTYPE(JobJnlLine, JobResPrice, JobResPrice.Type::All):
                                            NS_CopyJobResPriceToJobJnlLine(JobJnlLine, JobResPrice);
                                        //ProjectPro - end
                                        NS_JobJnlLineFindJobResPrice(JobJnlLine, JobResPrice, JobResPrice.Type::All):
                                            NS_CopyJobResPriceToJobJnlLine(JobJnlLine, JobResPrice);
                                    end;
                                end;
                        end;
                    end;
                Type::"G/L Account":
                    begin
                        JobGLAccPrice.SetRange("Job No.", "Job No.");
                        JobGLAccPrice.SetRange("G/L Account No.", "No.");
                        JobGLAccPrice.SetRange("Currency Code", "Currency Code");
                        JobGLAccPrice.SetRange("Job Task No.", "Job Task No.");
                        if JobGLAccPrice.FindFirst then
                            NS_CopyJobGLAccPriceToJobJnlLine(JobJnlLine, JobGLAccPrice)
                        else begin
                            JobGLAccPrice.SetRange("Job Task No.", '');
                            if JobGLAccPrice.FindFirst then;
                            NS_CopyJobGLAccPriceToJobJnlLine(JobJnlLine, JobGLAccPrice);
                        end;
                    end;
            end;
    end;

    local procedure NS_CopyJobGLAccPriceToJobPlanLine(var JobPlanningLine: Record "Job Planning Line"; JobGLAccPrice: Record "Job G/L Account Price")
    begin
        with JobPlanningLine do begin
            //ProjectPro - start
            //"Unit Cost" := JobGLAccPrice."Unit Cost";
            //InitRoundingPrecisions();
            //PRJ-72 VT 06-03-20
            InitRoundingPrecisionsPP(AmountRoundingPrecision, AmountRoundingPrecisionFCY,
            UnitAmountRoundingPrecision, UnitAmountRoundingPrecisionFCY);//PRJ-72 VT 06-03-20
            "Unit Cost (LCY)" := JobGLAccPrice."Unit Cost";
            "Unit Cost" := Round(
              CurrExchRate.ExchangeAmtLCYToFCY(
              "Currency Date", "Currency Code",
              "Unit Cost (LCY)", "Currency Factor"),
              UnitAmountRoundingPrecisionFCY);
            "Direct Unit Cost (LCY)" := Round(
              CurrExchRate.ExchangeAmtLCYToFCY(
              "Currency Date", "Currency Code",
              "Unit Cost (LCY)", "Currency Factor"),
              UnitAmountRoundingPrecisionFCY);
            //ProjectPro - end
            "Unit Price" := JobGLAccPrice."Unit Price" * "Qty. per Unit of Measure";
            "Cost Factor" := JobGLAccPrice."Unit Cost Factor";
            "Line Discount %" := JobGLAccPrice."Line Discount %";
        end;
    end;

    local procedure NS_CopyJobGLAccPriceToJobJnlLine(var JobJnlLine: Record "Job Journal Line"; JobGLAccPrice: Record "Job G/L Account Price")
    begin
        with JobJnlLine do begin
            "Unit Cost" := JobGLAccPrice."Unit Cost";
            "Unit Price" := JobGLAccPrice."Unit Price" * "Qty. per Unit of Measure";
            "Cost Factor" := JobGLAccPrice."Unit Cost Factor";
            "Line Discount %" := JobGLAccPrice."Line Discount %";
        end;
    end;

    local procedure NS_FindJobResPrice(var JobResPrice: Record "Job Resource Price"; WorkTypeCode: Code[10]): Boolean
    begin
        JobResPrice.SetRange("Work Type Code", WorkTypeCode);
        if JobResPrice.FindFirst then
            exit(true);
        JobResPrice.SetRange("Work Type Code", '');
        exit(JobResPrice.FindFirst);
    end;

    local procedure NS_JobPlanningLineFindJobResPrice(var JobPlanningLine: Record "Job Planning Line"; var JobResPrice: Record "Job Resource Price"; PriceType: Option Resource,"Group(Resource)",All): Boolean
    begin
        //ProjectPro - start
        JobResPrice.SetRange("NS_Skill Class Code", JobPlanningLine."NS_Skill Class");
        //ProjectPro - end
        case PriceType of
            PriceType::Resource:
                begin
                    JobResPrice.SetRange(Type, JobResPrice.Type::Resource);
                    JobResPrice.SetRange("Work Type Code", JobPlanningLine."Work Type Code");
                    JobResPrice.SetRange(Code, JobPlanningLine."No.");
                    exit(JobResPrice.Find('-'));
                end;
            PriceType::"Group(Resource)":
                begin
                    JobResPrice.SetRange(Type, JobResPrice.Type::"Group(Resource)");
                    JobResPrice.SetRange(Code, Res."Resource Group No.");
                    exit(NS_FindJobResPrice(JobResPrice, JobPlanningLine."Work Type Code"));
                end;
            PriceType::All:
                begin
                    JobResPrice.SetRange(Type, JobResPrice.Type::All);
                    JobResPrice.SetRange(Code);
                    exit(NS_FindJobResPrice(JobResPrice, JobPlanningLine."Work Type Code"));
                end;
        end;
    end;

    [Scope('Cloud')]
    procedure NS_CalcBestLineDisc(var SalesLineDisc: Record "Sales Line Discount")
    var
        BestSalesLineDisc: Record "Sales Line Discount";
    begin
        with SalesLineDisc do begin
            if FindSet then
                repeat
                    if NS_IsInMinQty("Unit of Measure Code", "Minimum Quantity") then
                        case true of
                            ((BestSalesLineDisc."Currency Code" = '') and ("Currency Code" <> '')) or
                          ((BestSalesLineDisc."Variant Code" = '') and ("Variant Code" <> '')):
                                BestSalesLineDisc := SalesLineDisc;
                            ((BestSalesLineDisc."Currency Code" = '') or ("Currency Code" <> '')) and
                          ((BestSalesLineDisc."Variant Code" = '') or ("Variant Code" <> '')):
                                if BestSalesLineDisc."Line Discount %" < "Line Discount %" then
                                    BestSalesLineDisc := SalesLineDisc;
                        end;
                until Next = 0;
        end;

        SalesLineDisc := BestSalesLineDisc;
    end;

    local procedure NS_JobPlanningLineStartDate(JobPlanningLine: Record "Job Planning Line"; var DateCaption: Text[30]): Date
    begin
        DateCaption := JobPlanningLine.FieldCaption("Planning Date");
        exit(JobPlanningLine."Planning Date");
    end;

    local procedure NS_CopyJobItemPriceToJobPlanLine(var JobPlanningLine: Record "Job Planning Line"; JobItemPrice: Record "Job Item Price")
    begin
        with JobPlanningLine do begin
            if JobItemPrice."Apply Job Price" then begin
                "Unit Price" := JobItemPrice."Unit Price";
                "Cost Factor" := JobItemPrice."Unit Cost Factor";
                //ProjectPro - start
                InitRoundingPrecisions;
                "Unit Cost (LCY)" := JobItemPrice."NS_Unit Cost";
                "Unit Cost" := Round(
                  CurrExchRate.ExchangeAmtLCYToFCY(
                  "Currency Date", "Currency Code",
                  "Unit Cost (LCY)", "Currency Factor"),
                  UnitAmountRoundingPrecisionFCY);
                "Direct Unit Cost (LCY)" := Round(
                  CurrExchRate.ExchangeAmtLCYToFCY(
                  "Currency Date", "Currency Code",
                  "Unit Cost (LCY)", "Currency Factor"),
                  UnitAmountRoundingPrecisionFCY);
                //ProjectPro - end
            end;
            if JobItemPrice."Apply Job Discount" then
                "Line Discount %" := JobItemPrice."Line Discount %";
        end;
    end;

    local procedure NS_CopyJobResPriceToJobPlanLine(var JobPlanningLine: Record "Job Planning Line"; JobResPrice: Record "Job Resource Price")
    begin
        with JobPlanningLine do begin
            if JobResPrice."Apply Job Price" then begin
                "Unit Price" := JobResPrice."Unit Price" * "Qty. per Unit of Measure";
                "Cost Factor" := JobResPrice."Unit Cost Factor";
                //ProjectPro - start
                //"Unit Cost" := JobResPrice."Unit Cost";
                //InitRoundingPrecisions; //PRJ-72 VT 06-03-20
                InitRoundingPrecisionsPP(AmountRoundingPrecision, AmountRoundingPrecisionFCY,
                UnitAmountRoundingPrecision, UnitAmountRoundingPrecisionFCY);//PRJ-72 VT 06-03-20
                "Unit Cost (LCY)" := JobResPrice."NS_Unit Cost";
                "Unit Cost" := Round(
                  CurrExchRate.ExchangeAmtLCYToFCY(
                  "Currency Date", "Currency Code",
                  "Unit Cost (LCY)", "Currency Factor"),
                  UnitAmountRoundingPrecisionFCY);
                "Direct Unit Cost (LCY)" := Round(
                  CurrExchRate.ExchangeAmtLCYToFCY(
                  "Currency Date", "Currency Code",
                  "Unit Cost (LCY)", "Currency Factor"),
                  UnitAmountRoundingPrecisionFCY);
                //ProjectPro - end
            end;
            if JobResPrice."Apply Job Discount" then
                "Line Discount %" := JobResPrice."Line Discount %";
        end;
    end;

    local procedure NS_JobPlanningLineLineDiscExists(var JobPlanningLine: Record "Job Planning Line"; ShowAll: Boolean): Boolean
    var
        Job: Record Job;
    begin
        with JobPlanningLine do
            if (Type = Type::Item) and Item.Get("No.") then begin
                Job.Get("Job No.");
                NS_FindSalesLineDisc(
                  TempSalesLineDisc, Job."Bill-to Customer No.", Job."Bill-to Contact No.",
                  Job."Customer Disc. Group", '', "No.", Item."Item Disc. Group", "Variant Code", "Unit of Measure Code",
                  "Currency Code", NS_JobPlanningLineStartDate(JobPlanningLine, DateCaption), ShowAll);
                exit(TempSalesLineDisc.Find('-'));
            end;
        exit(false);
    end;

    local procedure NS_FindJobPlanningLineLineDisc(var JobPlanningLine: Record "Job Planning Line")
    begin
        with JobPlanningLine do begin
            NS_SetCurrency("Currency Code", "Currency Factor", "Planning Date");
            SetUoM(Abs(Quantity), "Qty. per Unit of Measure");
            TestField("Qty. per Unit of Measure");
            if Type = Type::Item then begin
                NS_JobPlanningLineLineDiscExists(JobPlanningLine, false);
                NS_CalcBestLineDisc(TempSalesLineDisc);
                if AllowLineDisc then
                    "Line Discount %" := TempSalesLineDisc."Line Discount %"
                else
                    "Line Discount %" := 0;
            end;
        end;
    end;

    [Scope('Personalization')]
    procedure NS_JobPlanningLineFindJTPrice(var JobPlanningLine: Record "Job Planning Line")
    var
        JobItemPrice: Record "Job Item Price";
        JobResPrice: Record "Job Resource Price";
        JobGLAccPrice: Record "Job G/L Account Price";
    begin
        with JobPlanningLine do
            case Type of
                Type::Item:
                    begin
                        JobItemPrice.SetRange("Job No.", "Job No.");
                        JobItemPrice.SetRange("Item No.", "No.");
                        JobItemPrice.SetRange("Variant Code", "Variant Code");
                        JobItemPrice.SetRange("Unit of Measure Code", "Unit of Measure Code");
                        JobItemPrice.SetRange("Currency Code", "Currency Code");
                        JobItemPrice.SetRange("Job Task No.", "Job Task No.");
                        if JobItemPrice.FindFirst then
                            NS_CopyJobItemPriceToJobPlanLine(JobPlanningLine, JobItemPrice)
                        else begin
                            JobItemPrice.SetRange("Job Task No.", ' ');
                            if JobItemPrice.FindFirst then
                                NS_CopyJobItemPriceToJobPlanLine(JobPlanningLine, JobItemPrice);
                        end;

                        //ProjectPro - start
                        if JobItemPrice.IsEmpty then begin
                            JobItemPrice.Reset;
                            JobItemPrice.SetRange("Job No.", "Job No.");
                            JobItemPrice.SetRange("Job Task No.", "Job Task No.");
                            JobItemPrice.SetRange("Item No.", '');
                            if JobItemPrice.FindFirst then begin
                                JobItemPrice.TestField(NS_Type, JobItemPrice.NS_Type::All);
                                NS_CopyJobItemPriceToJobPlanLine(JobPlanningLine, JobItemPrice);
                            end else begin
                                JobItemPrice.SetRange("Job Task No.", '');
                                if JobItemPrice.FindFirst then begin
                                    JobItemPrice.TestField(NS_Type, JobItemPrice.NS_Type::All);
                                    NS_CopyJobItemPriceToJobPlanLine(JobPlanningLine, JobItemPrice);
                                end;
                            end;
                        end;
                        //ProjectPro - end

                        if JobItemPrice.IsEmpty or (not JobItemPrice."Apply Job Discount") then
                            NS_FindJobPlanningLineLineDisc(JobPlanningLine);
                    end;
                Type::Resource:
                    begin
                        //ProjectPro - start
                        if not "NS_Cost Factor Set By Category" then
                            JobPlanningLine."Cost Factor" := 0;
                        //ProjectPro - end
                        Res.Get("No.");
                        JobResPrice.SetRange("Job No.", "Job No.");
                        JobResPrice.SetRange("Currency Code", "Currency Code");
                        JobResPrice.SetRange("Job Task No.", "Job Task No.");
                        case true of
                            //ProjectPro - start
                            NS_JobPlanningLineFindJobResPriceALL(JobPlanningLine, JobResPrice, JobResPrice.Type::Resource):
                                NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                            NS_JobPlanningLineFindJobResPriceWORKTYPE(JobPlanningLine, JobResPrice, JobResPrice.Type::Resource):
                                NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                            //ProjectPro - end
                            NS_JobPlanningLineFindJobResPrice(JobPlanningLine, JobResPrice, JobResPrice.Type::Resource):
                                NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                            //ProjectPro - start
                            NS_JobPlanningLineFindJobResPriceALL(JobPlanningLine, JobResPrice, JobResPrice.Type::"Group(Resource)"):
                                NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                            NS_JobPlanningLineFindJobResPriceWORKTYPE(JobPlanningLine, JobResPrice, JobResPrice.Type::"Group(Resource)"):
                                NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                            //ProjectPro - end
                            NS_JobPlanningLineFindJobResPrice(JobPlanningLine, JobResPrice, JobResPrice.Type::"Group(Resource)"):
                                NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                            //ProjectPro - start
                            NS_JobPlanningLineFindJobResPriceALL(JobPlanningLine, JobResPrice, JobResPrice.Type::All):
                                NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                            NS_JobPlanningLineFindJobResPriceWORKTYPE(JobPlanningLine, JobResPrice, JobResPrice.Type::All):
                                NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                            //ProjectPro - end
                            NS_JobPlanningLineFindJobResPrice(JobPlanningLine, JobResPrice, JobResPrice.Type::All):
                                NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                            else begin
                                    JobResPrice.SetRange("Job Task No.", '');
                                    case true of
                                        //ProjectPro - start
                                        NS_JobPlanningLineFindJobResPriceALL(JobPlanningLine, JobResPrice, JobResPrice.Type::Resource):
                                            NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                                        NS_JobPlanningLineFindJobResPriceWORKTYPE(JobPlanningLine, JobResPrice, JobResPrice.Type::Resource):
                                            NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                                        //ProjectPro - end
                                        NS_JobPlanningLineFindJobResPrice(JobPlanningLine, JobResPrice, JobResPrice.Type::Resource):
                                            NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                                        //ProjectPro - start
                                        NS_JobPlanningLineFindJobResPriceALL(JobPlanningLine, JobResPrice, JobResPrice.Type::"Group(Resource)"):
                                            NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                                        NS_JobPlanningLineFindJobResPriceWORKTYPE(JobPlanningLine, JobResPrice, JobResPrice.Type::"Group(Resource)"):
                                            NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                                        //ProjectPro - end
                                        NS_JobPlanningLineFindJobResPrice(JobPlanningLine, JobResPrice, JobResPrice.Type::"Group(Resource)"):
                                            NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                                        //ProjectPro - start
                                        NS_JobPlanningLineFindJobResPriceALL(JobPlanningLine, JobResPrice, JobResPrice.Type::All):
                                            NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                                        NS_JobPlanningLineFindJobResPriceWORKTYPE(JobPlanningLine, JobResPrice, JobResPrice.Type::All):
                                            NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                                        //ProjectPro - end
                                        NS_JobPlanningLineFindJobResPrice(JobPlanningLine, JobResPrice, JobResPrice.Type::All):
                                            NS_CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                                    end;
                                end;
                        end;
                    end;
                Type::"G/L Account":
                    begin
                        JobGLAccPrice.SetRange("Job No.", "Job No.");
                        JobGLAccPrice.SetRange("G/L Account No.", "No.");
                        JobGLAccPrice.SetRange("Currency Code", "Currency Code");
                        JobGLAccPrice.SetRange("Job Task No.", "Job Task No.");
                        if JobGLAccPrice.FindFirst then
                            NS_CopyJobGLAccPriceToJobPlanLine(JobPlanningLine, JobGLAccPrice)
                        else begin
                            JobGLAccPrice.SetRange("Job Task No.", '');
                            if JobGLAccPrice.FindFirst then;
                            NS_CopyJobGLAccPriceToJobPlanLine(JobPlanningLine, JobGLAccPrice);
                        end;
                    end;
            end;
    end;

    local procedure NS_ServLinePriceExists(ServHeader: Record "Service Header"; var ServLine: Record "Service Line"; ShowAll: Boolean): Boolean
    begin
        with ServLine do
            if (Type = Type::Item) and Item.Get("No.") then begin
                NS_FindSalesPrice(
                  TempSalesPrice, "Bill-to Customer No.", ServHeader."Bill-to Contact No.",
                  "Customer Price Group", '', "No.", "Variant Code", "Unit of Measure Code",
                  ServHeader."Currency Code", NS_ServHeaderStartDate(ServHeader, DateCaption), ShowAll);
                exit(TempSalesPrice.Find('-'));
            end;
        exit(false);
    end;

    local procedure NS_ServLineLineDiscExists(ServHeader: Record "Service Header"; var ServLine: Record "Service Line"; ShowAll: Boolean): Boolean
    begin
        with ServLine do
            if (Type = Type::Item) and Item.Get("No.") then begin
                NS_FindSalesLineDisc(
                  TempSalesLineDisc, "Bill-to Customer No.", ServHeader."Bill-to Contact No.",
                  "Customer Disc. Group", '', "No.", Item."Item Disc. Group", "Variant Code", "Unit of Measure Code",
                  ServHeader."Currency Code", NS_ServHeaderStartDate(ServHeader, DateCaption), ShowAll);
                exit(TempSalesLineDisc.Find('-'));
            end;
        exit(false);
    end;

    local procedure NS_ServHeaderExchDate(ServHeader: Record "Service Header"): Date
    begin
        with ServHeader do begin
            if ("Document Type" = "Document Type"::Quote) and
               ("Posting Date" = 0D)
            then
                exit(WorkDate);
            exit("Posting Date");
        end;
    end;

    local procedure NS_ServHeaderStartDate(ServHeader: Record "Service Header"; var DateCaption: Text[30]): Date
    begin
        with ServHeader do
            if "Document Type" in ["Document Type"::Invoice, "Document Type"::"Credit Memo"] then begin
                DateCaption := FieldCaption("Posting Date");
                exit("Posting Date")
            end else begin
                DateCaption := FieldCaption("Order Date");
                exit("Order Date");
            end;
    end;

    local procedure NS_SalesHeaderStartDate(SalesHeader: Record "Sales Header"; var DateCaption: Text[30]): Date
    begin
        with SalesHeader do
            if "Document Type" in ["Document Type"::Invoice, "Document Type"::"Credit Memo"] then begin
                DateCaption := FieldCaption("Posting Date");
                exit("Posting Date")
            end else begin
                DateCaption := FieldCaption("Order Date");
                exit("Order Date");
            end;
    end;

    local procedure NS_GetCustNoForSalesHeader(SalesHeader: Record "Sales Header"): Code[20]
    var
        CustNo: Code[20];
    begin
        CustNo := SalesHeader."Sell-to Customer No.";
        exit(CustNo);
    end;

    local procedure NS_CopySalesPriceToSalesPrice(var FromSalesPrice: Record "Sales Price"; var ToSalesPrice: Record "Sales Price")
    begin
        with ToSalesPrice do begin
            if FromSalesPrice.FindSet then
                repeat
                    ToSalesPrice := FromSalesPrice;
                    Insert;
                until FromSalesPrice.Next = 0;
        end;
    end;

    local procedure NS_CopySalesDiscToSalesDisc(var FromSalesLineDisc: Record "Sales Line Discount"; var ToSalesLineDisc: Record "Sales Line Discount")
    begin
        with ToSalesLineDisc do begin
            if FromSalesLineDisc.FindSet then
                repeat
                    ToSalesLineDisc := FromSalesLineDisc;
                    Insert;
                until FromSalesLineDisc.Next = 0;
        end;
    end;

    local procedure NS_ActivatedCampaignExists(var ToCampaignTargetGr: Record "Campaign Target Group"; CustNo: Code[20]; ContNo: Code[20]; CampaignNo: Code[20]): Boolean
    var
        FromCampaignTargetGr: Record "Campaign Target Group";
        Cont: Record Contact;
    begin
        with FromCampaignTargetGr do begin
            ToCampaignTargetGr.Reset;
            ToCampaignTargetGr.DeleteAll;

            if CampaignNo <> '' then begin
                ToCampaignTargetGr."Campaign No." := CampaignNo;
                ToCampaignTargetGr.Insert;
            end else begin
                SetRange(Type, Type::Customer);
                SetRange("No.", CustNo);
                if FindSet then
                    repeat
                        ToCampaignTargetGr := FromCampaignTargetGr;
                        ToCampaignTargetGr.Insert;
                    until Next = 0
                else begin
                    if Cont.Get(ContNo) then begin
                        SetRange(Type, Type::Contact);
                        SetRange("No.", Cont."Company No.");
                        if FindSet then
                            repeat
                                ToCampaignTargetGr := FromCampaignTargetGr;
                                ToCampaignTargetGr.Insert;
                            until Next = 0;
                    end;
                end;
            end;
            exit(ToCampaignTargetGr.FindFirst);
        end;
    end;

    [Scope('Personalization')]
    procedure NS_FindSalesPrice(var ToSalesPrice: Record "Sales Price"; CustNo: Code[20]; ContNo: Code[20]; CustPriceGrCode: Code[10]; CampaignNo: Code[20]; ItemNo: Code[20]; VariantCode: Code[10]; UOM: Code[10]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean)
    var
        FromSalesPrice: Record "Sales Price";
        TempTargetCampaignGr: Record "Campaign Target Group" temporary;
    begin
        if not ToSalesPrice.IsTemporary then
            Error(TempTableErr);

        with FromSalesPrice do begin
            SetRange("Item No.", ItemNo);
            SetFilter("Variant Code", '%1|%2', VariantCode, '');
            SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
            if not ShowAll then begin
                SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
                if UOM <> '' then
                    SetFilter("Unit of Measure Code", '%1|%2', UOM, '');
                SetRange("Starting Date", 0D, StartingDate);
            end;

            ToSalesPrice.Reset;
            ToSalesPrice.DeleteAll;

            SetRange("Sales Type", "Sales Type"::"All Customers");
            SetRange("Sales Code");
            NS_CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);

            if CustNo <> '' then begin
                SetRange("Sales Type", "Sales Type"::Customer);
                SetRange("Sales Code", CustNo);
                NS_CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
            end;

            if CustPriceGrCode <> '' then begin
                SetRange("Sales Type", "Sales Type"::"Customer Price Group");
                SetRange("Sales Code", CustPriceGrCode);
                NS_CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
            end;

            if not ((CustNo = '') and (ContNo = '') and (CampaignNo = '')) then begin
                SetRange("Sales Type", "Sales Type"::Campaign);
                if NS_ActivatedCampaignExists(TempTargetCampaignGr, CustNo, ContNo, CampaignNo) then
                    repeat
                        SetRange("Sales Code", TempTargetCampaignGr."Campaign No.");
                        NS_CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
                    until TempTargetCampaignGr.Next = 0;
            end;
        end;
    end;

    [Scope('Cloud')]
    procedure NS_FindSalesLineDisc(var ToSalesLineDisc: Record "Sales Line Discount"; CustNo: Code[20]; ContNo: Code[20]; CustDiscGrCode: Code[20]; CampaignNo: Code[20]; ItemNo: Code[20]; ItemDiscGrCode: Code[20]; VariantCode: Code[10]; UOM: Code[10]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean)
    var
        FromSalesLineDisc: Record "Sales Line Discount";
        TempCampaignTargetGr: Record "Campaign Target Group" temporary;
        InclCampaigns: Boolean;
    begin
        with FromSalesLineDisc do begin
            SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
            SetFilter("Variant Code", '%1|%2', VariantCode, '');
            if not ShowAll then begin
                SetRange("Starting Date", 0D, StartingDate);
                SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
                if UOM <> '' then
                    SetFilter("Unit of Measure Code", '%1|%2', UOM, '');
            end;

            ToSalesLineDisc.Reset;
            ToSalesLineDisc.DeleteAll;
            for "Sales Type" := "Sales Type"::Customer to "Sales Type"::Campaign do
                if ("Sales Type" = "Sales Type"::"All Customers") or
                   (("Sales Type" = "Sales Type"::Customer) and (CustNo <> '')) or
                   (("Sales Type" = "Sales Type"::"Customer Disc. Group") and (CustDiscGrCode <> '')) or
                   (("Sales Type" = "Sales Type"::Campaign) and
                    not ((CustNo = '') and (ContNo = '') and (CampaignNo = '')))
                then begin
                    InclCampaigns := false;

                    SetRange("Sales Type", "Sales Type");
                    case "Sales Type" of
                        "Sales Type"::"All Customers":
                            SetRange("Sales Code");
                        "Sales Type"::Customer:
                            SetRange("Sales Code", CustNo);
                        "Sales Type"::"Customer Disc. Group":
                            SetRange("Sales Code", CustDiscGrCode);
                        "Sales Type"::Campaign:
                            begin
                                InclCampaigns := NS_ActivatedCampaignExists(TempCampaignTargetGr, CustNo, ContNo, CampaignNo);
                                SetRange("Sales Code", TempCampaignTargetGr."Campaign No.");
                            end;
                    end;

                    repeat
                        SetRange(Type, Type::Item);
                        SetRange(Code, ItemNo);
                        NS_CopySalesDiscToSalesDisc(FromSalesLineDisc, ToSalesLineDisc);

                        if ItemDiscGrCode <> '' then begin
                            SetRange(Type, Type::"Item Disc. Group");
                            SetRange(Code, ItemDiscGrCode);
                            NS_CopySalesDiscToSalesDisc(FromSalesLineDisc, ToSalesLineDisc);
                        end;

                        if InclCampaigns then begin
                            InclCampaigns := TempCampaignTargetGr.Next <> 0;
                            SetRange("Sales Code", TempCampaignTargetGr."Campaign No.");
                        end;
                    until not InclCampaigns;
                end;
        end;
    end;

    local procedure NS_CalcLineAmount(SalesPrice: Record "Sales Price"): Decimal
    begin
        with SalesPrice do begin
            if "Allow Line Disc." then
                exit("Unit Price" * (1 - LineDiscPerCent / 100));
            exit("Unit Price");
        end;
    end;

    local procedure NS_ConvertPriceToUoM(UnitOfMeasureCode: Code[10]; var UnitPrice: Decimal)
    begin
        if UnitOfMeasureCode = '' then
            UnitPrice := UnitPrice * QtyPerUOM;
    end;

    local procedure NS_IsInMinQty(UnitofMeasureCode: Code[10]; MinQty: Decimal): Boolean
    begin
        if UnitofMeasureCode = '' then
            exit(MinQty <= QtyPerUOM * Qty);
        exit(MinQty <= Qty);
    end;

    [Scope('Cloud')]
    procedure NS_CalcBestUnitPrice(var SalesPrice: Record "Sales Price")
    var
        BestSalesPrice: Record "Sales Price";
        BestSalesPriceFound: Boolean;
    begin
        with SalesPrice do begin
            FoundSalesPrice := FindSet;
            if FoundSalesPrice then
                repeat
                    if NS_IsInMinQty("Unit of Measure Code", "Minimum Quantity") then begin
                        NS_ConvertPriceToVAT(
                          "Price Includes VAT", Item."VAT Prod. Posting Group",
                          "VAT Bus. Posting Gr. (Price)", "Unit Price");
                        NS_ConvertPriceToUoM("Unit of Measure Code", "Unit Price");
                        NS_ConvertPriceLCYToFCY("Currency Code", "Unit Price");

                        case true of
                            ((BestSalesPrice."Currency Code" = '') and ("Currency Code" <> '')) or
                            ((BestSalesPrice."Variant Code" = '') and ("Variant Code" <> '')):
                                begin
                                    BestSalesPrice := SalesPrice;
                                    BestSalesPriceFound := true;
                                end;
                            ((BestSalesPrice."Currency Code" = '') or ("Currency Code" <> '')) and
                          ((BestSalesPrice."Variant Code" = '') or ("Variant Code" <> '')):
                                if (BestSalesPrice."Unit Price" = 0) or
                                   (NS_CalcLineAmount(BestSalesPrice) > NS_CalcLineAmount(SalesPrice))
                                then begin
                                    BestSalesPrice := SalesPrice;
                                    BestSalesPriceFound := true;
                                end;
                        end;
                    end;
                until Next = 0;
        end;

        // No price found in agreement
        if not BestSalesPriceFound then begin
            NS_ConvertPriceToVAT(
              Item."Price Includes VAT", Item."VAT Prod. Posting Group",
              Item."VAT Bus. Posting Gr. (Price)", Item."Unit Price");
            NS_ConvertPriceToUoM('', Item."Unit Price");
            NS_ConvertPriceLCYToFCY('', Item."Unit Price");

            Clear(BestSalesPrice);
            BestSalesPrice."Unit Price" := Item."Unit Price";
            BestSalesPrice."Allow Line Disc." := AllowLineDisc;
            BestSalesPrice."Allow Invoice Disc." := AllowInvDisc;
        end;

        SalesPrice := BestSalesPrice;
    end;

    [Scope('Personalization')]
    procedure NS_SetResPrice(JobNo: Code[20]; Code2: Code[20]; WorkTypeCode: Code[10]; CurrencyCode: Code[10])
    begin
        with ResPrice do begin
            Init;
            Code := Code2;
            "Work Type Code" := WorkTypeCode;
            "Currency Code" := CurrencyCode;
            //ProjectPro - start
            "NS_Job No." := JobNo;
            //ProjectPro - end
        end;
    end;

    local procedure NS_ConvertPriceToVAT(FromPricesInclVAT: Boolean; FromVATProdPostingGr: Code[20]; FromVATBusPostingGr: Code[20]; var UnitPrice: Decimal)
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        if FromPricesInclVAT then begin
            VATPostingSetup.Get(FromVATBusPostingGr, FromVATProdPostingGr);

            case VATPostingSetup."VAT Calculation Type" of
                VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                    VATPostingSetup."VAT %" := 0;
                VATPostingSetup."VAT Calculation Type"::"Sales Tax":
                    Error(
                      Text010,
                      VATPostingSetup.FieldCaption("VAT Calculation Type"),
                      VATPostingSetup."VAT Calculation Type");
            end;

            case VATCalcType of
                VATCalcType::"Normal VAT",
                VATCalcType::"Full VAT",
                VATCalcType::"Sales Tax":
                    begin
                        if PricesInclVAT then begin
                            if VATBusPostingGr <> FromVATBusPostingGr then
                                UnitPrice := UnitPrice * (100 + VATPerCent) / (100 + VATPostingSetup."VAT %");
                        end else
                            UnitPrice := UnitPrice / (1 + VATPostingSetup."VAT %" / 100);
                    end;
                VATCalcType::"Reverse Charge VAT":
                    UnitPrice := UnitPrice / (1 + VATPostingSetup."VAT %" / 100);
            end;
        end else
            if PricesInclVAT then
                UnitPrice := UnitPrice * (1 + VATPerCent / 100);
    end;

    local procedure NS_ConvertPriceLCYToFCY(CurrencyCode: Code[10]; var UnitPrice: Decimal)
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        if PricesInCurrency then begin
            if CurrencyCode = '' then
                UnitPrice :=
                  CurrExchRate.ExchangeAmtLCYToFCY(ExchRateDate, Currency.Code, UnitPrice, CurrencyFactor);
            UnitPrice := Round(UnitPrice, Currency."Unit-Amount Rounding Precision");
        end else
            UnitPrice := Round(UnitPrice, GLSetup."Unit-Amount Rounding Precision");
    end;

    local procedure NS_SalesHeaderExchDate(SalesHeader: Record "Sales Header"): Date
    begin
        with SalesHeader do begin
            if "Posting Date" <> 0D then
                exit("Posting Date");
            exit(WorkDate);
        end;
    end;

    local procedure NS_SetCurrency(CurrencyCode2: Code[10]; CurrencyFactor2: Decimal; ExchRateDate2: Date)
    begin
        PricesInCurrency := CurrencyCode2 <> '';
        if PricesInCurrency then begin
            Currency.Get(CurrencyCode2);
            Currency.TestField("Unit-Amount Rounding Precision");
            CurrencyFactor := CurrencyFactor2;
            ExchRateDate := ExchRateDate2;
        end else
            GLSetup.Get;
    end;

    local procedure NS_SetVAT(PriceInclVAT2: Boolean; VATPerCent2: Decimal; VATCalcType2: Option; VATBusPostingGr2: Code[20])
    begin
        PricesInclVAT := PriceInclVAT2;
        VATPerCent := VATPerCent2;
        VATCalcType := VATCalcType2;
        VATBusPostingGr := VATBusPostingGr2;
    end;

    local procedure SetUoM(Qty2: Decimal; QtyPerUoM2: Decimal)
    begin
        Qty := Qty2;
        QtyPerUOM := QtyPerUoM2;
    end;

    local procedure NS_SetLineDisc(LineDiscPerCent2: Decimal; AllowLineDisc2: Boolean; AllowInvDisc2: Boolean)
    begin
        LineDiscPerCent := LineDiscPerCent2;
        AllowLineDisc := AllowLineDisc2;
        AllowInvDisc := AllowInvDisc2;
    end;

    [Scope('Cloud')]
    procedure NS_SalesLinePriceExists(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; ShowAll: Boolean): Boolean
    var
        IsHandled: Boolean;
    begin
        with SalesLine do
            if (Type = Type::Item) and Item.Get("No.") then begin
                IsHandled := false;
                if not IsHandled then begin
                    NS_FindSalesPrice(
                      TempSalesPrice, NS_GetCustNoForSalesHeader(SalesHeader), SalesHeader."Bill-to Contact No.",
                      "Customer Price Group", '', "No.", "Variant Code", "Unit of Measure Code",
                      SalesHeader."Currency Code", NS_SalesHeaderStartDate(SalesHeader, DateCaption), ShowAll);
                end;
                exit(TempSalesPrice.FindFirst);
            end;
        exit(false);
    end;

    procedure NS_GetJobPlanningItemPrice(SalesLine: Record "Sales Line"; var UnitPrice: Decimal): Boolean
    var
        FinalPrice: Decimal;
        Found: Boolean;
        NS_JobPlanningLine: Record "Job Planning Line";
    begin
        //ProjectPro - start
        Found := false;
        UnitPrice := 0;
        NS_JobPlanningLine.Reset;
        NS_JobPlanningLine.SetCurrentKey("Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                         "NS_Cost Category", Type, "No.", "Variant Code");
        NS_JobPlanningLine.SetRange("Job No.", SalesLine."Job No.");
        NS_JobPlanningLine.SetRange("NS_Entry Type", NS_JobPlanningLine."NS_Entry Type"::Both);
        NS_JobPlanningLine.SetRange("Job Task No.", SalesLine."Job Task No.");
        NS_JobPlanningLine.SetRange(Type, NS_JobPlanningLine.Type::Item);
        NS_JobPlanningLine.SetRange("No.", SalesLine."No.");
        if SalesLine."Variant Code" > '' then
            NS_JobPlanningLine.SetRange("Variant Code", SalesLine."Variant Code");
        if NS_JobPlanningLine.FindSet then
            repeat
                if (NS_JobPlanningLine."Unit Price" < UnitPrice) or
                   (not Found) then begin
                    UnitPrice := NS_JobPlanningLine."Unit Price";
                    Found := true;
                end;
            until NS_JobPlanningLine.Next = 0;
        exit(Found);
        //ProjectPro - end
    end;

    procedure NS_JobJnlLineFindJobResPriceALL(var JobJnlLine: Record "Job Journal Line"; var JobResPrice: Record "Job Resource Price"; PriceType: Option Resource,"Group(Resource)",All): Boolean
    begin
        //ProjectPro - start
        JobResPrice.SetRange("NS_Skill Class Code", JobJnlLine."NS_Skill Class");
        JobResPrice.SetRange("Work Type Code", JobJnlLine."Work Type Code");
        case PriceType of
            PriceType::Resource:
                begin
                    JobResPrice.SetRange(Type, JobResPrice.Type::Resource);
                    JobResPrice.SetRange(Code, JobJnlLine."No.");
                    exit(JobResPrice.FindFirst);
                end;
            PriceType::"Group(Resource)":
                begin
                    JobResPrice.SetRange(Type, JobResPrice.Type::"Group(Resource)");
                    JobResPrice.SetRange(Code, Res."Resource Group No.");
                    exit(JobResPrice.FindFirst);
                end;
            PriceType::All:
                begin
                    JobResPrice.SetRange(Type, JobResPrice.Type::All);
                    JobResPrice.SetRange(Code);
                    exit(JobResPrice.FindFirst);
                end;
        end;
        //ProjectPro - end
    end;

    procedure NS_70(var JobJnlLine: Record "Job Journal Line"; var JobResPrice: Record "Job Resource Price"; PriceType: Option Resource,"Group(Resource)",All; Res: Record Resource): Boolean
    begin
        //ProjectPro - start
        if JobJnlLine."NS_Skill Class" <> '' then
            exit(false);
        JobResPrice.SetRange("NS_Skill Class Code");
        JobResPrice.SetRange("Work Type Code", JobJnlLine."Work Type Code");
        case PriceType of
            PriceType::Resource:
                begin
                    JobResPrice.SetRange(Type, JobResPrice.Type::Resource);
                    JobResPrice.SetRange(Code, JobJnlLine."No.");
                    exit(JobResPrice.FindFirst);
                end;
            PriceType::"Group(Resource)":
                begin
                    JobResPrice.SetRange(Type, JobResPrice.Type::"Group(Resource)");
                    JobResPrice.SetRange(Code, Res."Resource Group No.");
                    exit(JobResPrice.FindFirst);
                end;
            PriceType::All:
                begin
                    JobResPrice.SetRange(Type, JobResPrice.Type::All);
                    JobResPrice.SetRange(Code);
                    exit(JobResPrice.FindFirst);
                end;
        end;
        //ProjectPro - end
    end;

    procedure NS_JobPlanningLineFindJobResPriceALL(var JobPlanningLine: Record "Job Planning Line"; var JobResPrice: Record "Job Resource Price"; PriceType: Option Resource,"Group(Resource)",All): Boolean
    begin
        //ProjectPro - start
        JobResPrice.SetRange("NS_Skill Class Code", JobPlanningLine."NS_Skill Class");
        JobResPrice.SetRange("Work Type Code", JobPlanningLine."Work Type Code");
        case PriceType of
            PriceType::Resource:
                begin
                    JobResPrice.SetRange(Type, JobResPrice.Type::Resource);
                    JobResPrice.SetRange(Code, JobPlanningLine."No.");
                    exit(JobResPrice.FindFirst);
                end;
            PriceType::"Group(Resource)":
                begin
                    JobResPrice.SetRange(Type, JobResPrice.Type::"Group(Resource)");
                    JobResPrice.SetRange(Code, Res."Resource Group No.");
                    exit(JobResPrice.FindFirst);
                end;
            PriceType::All:
                begin
                    JobResPrice.SetRange(Type, JobResPrice.Type::All);
                    JobResPrice.SetRange(Code);
                    exit(JobResPrice.FindFirst);
                end;
        end;
        //ProjectPro - end
    end;

    procedure NS_JobPlanningLineFindJobResPriceWORKTYPE(var JobPlanningLine: Record "Job Planning Line"; var JobResPrice: Record "Job Resource Price"; PriceType: Option Resource,"Group(Resource)",All): Boolean
    begin
        //ProjectPro - start
        if JobPlanningLine."NS_Skill Class" <> '' then
            exit(false);
        JobResPrice.SetRange("NS_Skill Class Code");
        JobResPrice.SetRange("Work Type Code", JobPlanningLine."Work Type Code");
        case PriceType of
            PriceType::Resource:
                begin
                    JobResPrice.SetRange(Type, JobResPrice.Type::Resource);
                    JobResPrice.SetRange(Code, JobPlanningLine."No.");
                    exit(JobResPrice.FindFirst);
                end;
            PriceType::"Group(Resource)":
                begin
                    JobResPrice.SetRange(Type, JobResPrice.Type::"Group(Resource)");
                    JobResPrice.SetRange(Code, Res."Resource Group No.");
                    exit(JobResPrice.FindFirst);
                end;
            PriceType::All:
                begin
                    JobResPrice.SetRange(Type, JobResPrice.Type::All);
                    JobResPrice.SetRange(Code);
                    exit(JobResPrice.FindFirst);
                end;
        end;
        //ProjectPro - end
    end;

    local procedure NS_JobPlanningLineFindCostCategoryPrice(var JobPlanningLine: Record "Job Planning Line")
    var
        JobCostCategoryPrice: Record "NS_Job Cost Category Price";
    begin
        //ProjectPro - start
        with JobPlanningLine do begin
            JobCostCategoryPrice.SetRange("NS_Job No.", "Job No.");
            JobCostCategoryPrice.SetRange("NS_Cost Category Code", "NS_Cost Category");
            if JobCostCategoryPrice.FindFirst then begin
                "Cost Factor" := JobCostCategoryPrice."NS_Unit Cost Factor";
                "NS_Cost Factor Set By Category" := true;
            end else
                "NS_Cost Factor Set By Category" := false;
        end;
        //ProjectPro - end
    end;

    local procedure NS_InitRoundingPrecisions(JobPlanningLine: Record "Job Planning Line")
    var
        Currency: Record Currency;
    begin
        if (AmountRoundingPrecision = 0) or
           (UnitAmountRoundingPrecision = 0) or
           (AmountRoundingPrecisionFCY = 0) or
           (UnitAmountRoundingPrecisionFCY = 0)
        then begin
            Clear(Currency);
            Currency.InitRoundingPrecision;
            AmountRoundingPrecision := Currency."Amount Rounding Precision";
            UnitAmountRoundingPrecision := Currency."Unit-Amount Rounding Precision";

            if JobPlanningLine."Currency Code" <> '' then begin
                Currency.Get(JobPlanningLine."Currency Code");
                Currency.TestField("Amount Rounding Precision");
                Currency.TestField("Unit-Amount Rounding Precision");
            end;

            AmountRoundingPrecisionFCY := Currency."Amount Rounding Precision";
            UnitAmountRoundingPrecisionFCY := Currency."Unit-Amount Rounding Precision";
        end;
    end;

    local procedure NS_JobJnlLineFindCostCategoryPrice(var JobJnlLine: Record "Job Journal Line")
    var
        JobCostCategoryPrice: Record "NS_Job Cost Category Price";
    begin
        with JobJnlLine do begin
            JobCostCategoryPrice.SetRange("NS_Job No.", "Job No.");
            JobCostCategoryPrice.SetRange("NS_Cost Category Code", "NS_Job Cost Category");
            if JobCostCategoryPrice.FindFirst then begin
                "Cost Factor" := JobCostCategoryPrice."NS_Unit Cost Factor";
                "NS_Cost Factor Set By Category" := true;
            end else
                "NS_Cost Factor Set By Category" := false;
        end;
    end;
}

