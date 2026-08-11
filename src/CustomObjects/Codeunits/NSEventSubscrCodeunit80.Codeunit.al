codeunit 14021113 "NS_Event Subscr. Codeunit 80"
{
    // version SPLN1.00

    // 2019-01-21 SPLN1.00 DMT Created
    //PRJ-57.VT.1.0 04-03-20 Added parameter in Event OnPostSalesLineOnAfterCase and Function NS_PostLedger 
    //PRJ-57.SK.1.0 Added code for removing GL Inconsistency error
    //TM-10.AM.1.0 | Added segment code flow functionality.
    //PRJ-884.JS.1.0 24Aug2021 | code added to test document status released if retention percent is not zero
    //PRJ-1750.NK.1.0 26Dec2022 | Code added    
    //PRJCTPR-10.SD.1.0 10Jan2023 | Code Added.
    //PE-22.JS.1.0 02FEB2022
    trigger OnRun()
    begin
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        GLSetup: Record "General Ledger Setup";
        NS_JobsSetup: Record "Jobs Setup";
        NS_Text14021100: Label 'There must be a value in the Sales & Receivables Setup, Normal Customer Ledger No. to identify the name of the normal ledger for receivables.';
        NS_Text14021101: Label 'There must be a value in the Jobs Setup, Retention Receivable Ledger to identify the name of the retention ledger for receivables.';
        NS_Text14021102: Label 'There must be a value in the Jobs Setup, Retention Dimension Code to identify the name of Global Dimension 2.';
        NS_Text14021103: Label 'A ''Not to Exceed'' value of %1 has been violated in line %2\Type=%3 No.=%4\The rule violated has the following attributes:\Job Task No.=%5 Catgeory=%6\Please correct the lines and post again.';
        NS_Text14021104: Label 'There is %1 in prepayments available for this Job.\An additional %2 could be used.\\Should the post be stopped so that they can be applied';
        NS_Text14021105: Label 'Please modify the prepayment value';
        p: Codeunit "NS_Parameters for Events";

    [Obsolete('Replaced by Microsoft with OnPostLinesOnBeforeGenJnlLinePost() in CU825Sales Post Invoice Events.', '22.0')]//PE-129.AS.1.0
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostInvPostBuffer', '', false, false)]
    local procedure NS_C80OnBeforePostInvPostBuffer(var GenJnlLine: Record "Gen. Journal Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean)
    var
        NS_GenPostingSetup: Record "General Posting Setup";
    begin
        with GenJnlLine do begin
            "NS_Retention Ledger Code" := InvoicePostBuffer."NS_Retention Ledger Code";
            if "Account Type" = "Account Type"::"G/L Account" then begin
                if (NS_GenPostingSetup.Get("Gen. Bus. Posting Group", "Gen. Prod. Posting Group")) and
                    (NS_GenPostingSetup."Sales Prepayments Account" > '') and
                    ("Account No." = NS_GenPostingSetup."Sales Prepayments Account") then
                    "NS_Prepayment for Job No." := SalesHeader."NS_Job No.";
            end;

            "NS_Retention Document" := SalesHeader."NS_Retention Document";
            if "NS_Retention Document" then
                Clear(GenJnlLine);
        end;
    end;
    //PE-129.AS.1.0 START ADD
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Post Invoice Events", 'OnPostLinesOnBeforeGenJnlLinePost', '', false, false)]
    local procedure NS_C825OnPostLinesOnBeforeGenJnlLinePost(var GenJnlLine: Record "Gen. Journal Line"; TempInvoicePostingBuffer: Record "Invoice Posting Buffer" temporary; SalesHeader: Record "Sales Header"; SuppressCommit: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean)
    var
        NS_GenPostingSetup: Record "General Posting Setup";
    begin
        GenJnlLine."NS_Retention Ledger Code" := TempInvoicePostingBuffer."NS_Retention Ledger Code";
        if GenJnlLine."Account Type" = GenJnlLine."Account Type"::"G/L Account" then begin
            if (NS_GenPostingSetup.Get(GenJnlLine."Gen. Bus. Posting Group", GenJnlLine."Gen. Prod. Posting Group")) and
                (NS_GenPostingSetup."Sales Prepayments Account" > '') and
                (GenJnlLine."Account No." = NS_GenPostingSetup."Sales Prepayments Account") then
                GenJnlLine."NS_Prepayment for Job No." := SalesHeader."NS_Job No.";
        end;

        GenJnlLine."NS_Retention Document" := SalesHeader."NS_Retention Document";
        if GenJnlLine."NS_Retention Document" then
            Clear(GenJnlLine);
    end;
    //PE-129.AS.1.0 END ADD

    //PPDA.1.0 Start Moved to dependent app
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesTaxToGL', '', false, false)]
    // local procedure NS_C80OnBeforePostSalesTaxToGL(var GenJnlLine: Record "Gen. Journal Line"; SalesHeader: Record "Sales Header"; SalesTaxAmountLine: Record "Sales Tax Amount Line")
    // begin
    //     GenJnlLine."VAT Bus. Posting Group" := SalesHeader."VAT Bus. Posting Group";
    //     GenJnlLine."VAT Prod. Posting Group" := p.NS_C80GetNS_VatPostingGr;
    // end;
    //PPDA.1.0 End

    [Obsolete('Replaced by Microsoft with OnPostBalancingEntryOnBeforeGenJnlPostLine() in CU825Sales Post Invoice Events.', '22.0')]//PE-129.AS.1.0
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostBalancingEntry', '', false, false)]
    local procedure NS_C80OnBeforePostBalancingEntry(var GenJnlLine: Record "Gen. Journal Line"; SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    begin
        with GenJnlLine do begin
            SalesSetup.Get;
            if not SalesSetup."NS_Sales Retention Inactive" then
                Validate("NS_Retention Ledger Code", p.NS_C80GetNS_GenJnlLineLedgerNo);
            "NS_Retention Document" := SalesHeader."NS_Retention Document";
            "Job No." := SalesHeader."NS_Job No.";
        end;
    end;

    //PE-129.AS.1.0 start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Post Invoice Events", 'OnPostBalancingEntryOnBeforeGenJnlPostLine', '', false, false)]
    local procedure NS_C825OnPostBalancingEntryOnBeforeGenJnlPostLine(var GenJnlLine: Record "Gen. Journal Line"; SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line"; SuppressCommit: Boolean; PreviewMode: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    begin
        SalesSetup.Get();
        if not SalesSetup."NS_Sales Retention Inactive" then
            GenJnlLine.Validate("NS_Retention Ledger Code", p.NS_C80GetNS_GenJnlLineLedgerNo());
        GenJnlLine."NS_Retention Document" := SalesHeader."NS_Retention Document";
        GenJnlLine."Job No." := SalesHeader."NS_Job No.";
    end;
    //PE-129.AS.1.0 end

    [Obsolete('Replaced by Microsoft with OnPostLedgerEntryOnBeforeGenJnlPostLine() in CU825Sales Post Invoice Events.', '22.0')]//PE-129.AS.1.0
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostCustomerEntry', '', false, false)]
    local procedure NS_C80OnBeforePostCustomerEntry(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    var
        IsHandle: Boolean;//FGH-163.AS.29052024  //PE-307.JS.1.0
    begin
        //FGH-163.AS.29052024 START //PE-307.JS.1.0
        NS_OnBefore_NS_C80OnBeforePostCustomerEntry(GenJnlLine, SalesHeader, TotalSalesLine, TotalSalesLineLCY, CommitIsSuppressed, PreviewMode, IsHandle);
        if IsHandle then
            exit;
        //FGH-163.AS.29052024 END //PE-307.JS.1.0

        //PRJ-1170.NK.1.0 Start
        //with GenJnlLine do begin
        SalesSetup.Get();
        if not SalesSetup."NS_Sales Retention Inactive" then
            GenJnlLine.Validate("NS_Retention Ledger Code", p.NS_C80GetNS_GenJnlLineLedgerNo());

        //ProjectPro - start
        if not SalesSetup."NS_Sales Retention Inactive" then begin
            GenJnlLine."NS_Retention Percent" := SalesHeader."NS_Retention Percent";
            if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then begin
                GenJnlLine."NS_Retention Amount" := -SalesHeader."NS_Retention Amount";
                GenJnlLine."NS_Retention Amount (LCY)" := -SalesHeader."NS_Retention Amount (LCY)";
            end else begin
                GenJnlLine."NS_Retention Amount" := SalesHeader."NS_Retention Amount";
                GenJnlLine."NS_Retention Amount (LCY)" := SalesHeader."NS_Retention Amount (LCY)";
            end;
            GenJnlLine."NS_Retention Date" := SalesHeader."NS_Retention Date";
            //NS_JobsSetup.Get();               //MHNA-7.JS.1.0 22JUN2023 line commented
            if NS_JobsSetup.get() then;     //MHNA-7.JS.1.0 22JUN2023 line added
            if (NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" =
                NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"2 - Calc tax on sale then apply retention determined by progress billing") or
               (NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" =
                NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing") then begin

                SalesHeader.CalcFields("NS_Retention Base Before Tax", SalesHeader."NS_Retention Base Amount");  //MHNA-7.JS.1.0 22JUN2023
                GenJnlLine."NS_Retention Base Amount" := SalesHeader."NS_Retention Base Before Tax";
            end else begin
                SalesHeader.CalcFields("NS_Retention Base Amount");  //MHNA-7.JS.1.0 22JUN2023
                GenJnlLine."NS_Retention Base Amount" := SalesHeader."NS_Retention Base Amount";
            end;
            GenJnlLine."NS_Retention Document" := SalesHeader."NS_Retention Document";
            //MHNA-7.JS.1.0 22JUN2023 - Start
        end else begin
            SalesHeader.CalcFields("NS_Retention Base Amount");
            GenJnlLine."NS_Retention Base Amount" := SalesHeader."NS_Retention Base Amount";
        end;
        GenJnlLine."Job No." := SalesHeader."NS_Job No.";
        //MHNA-7.JS.1.0 22JUN2023 - end
        //end;
        //PRJ-1170.NK.1.0 End
    end;
    //PE-129.AS.1.0 start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Post Invoice Events", 'OnPostLedgerEntryOnBeforeGenJnlPostLine', '', false, false)]
    local procedure NS_C825OnPostLedgerEntryOnBeforeGenJnlPostLine(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line"; SuppressCommit: Boolean; PreviewMode: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        IsHandle: Boolean;//FGH-163.AS.29052024 //PE-307.JS.1.0
    begin
        //FGH-163.AS.29052024 start  //PE-307.JS.1.0
        NS_OnBefore_NS_C825OnPostLedgerEntryOnBeforeGenJnlPostLine(GenJnlLine, SalesHeader, TotalSalesLine, TotalSalesLineLCY, SuppressCommit, PreviewMode, GenJnlPostLine, IsHandle);
        if IsHandle then
            exit;
        //FGH-163.AS.29052024 end  //PE-307.JS.1.0

        //PRJ-1170.NK.1.0 Start
        //with GenJnlLine do begin
        SalesSetup.Get();
        if not SalesSetup."NS_Sales Retention Inactive" then
            GenJnlLine.Validate("NS_Retention Ledger Code", p.NS_C80GetNS_GenJnlLineLedgerNo());

        //ProjectPro - start
        if not SalesSetup."NS_Sales Retention Inactive" then begin
            GenJnlLine."NS_Retention Percent" := SalesHeader."NS_Retention Percent";
            if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then begin
                GenJnlLine."NS_Retention Amount" := -SalesHeader."NS_Retention Amount";
                GenJnlLine."NS_Retention Amount (LCY)" := -SalesHeader."NS_Retention Amount (LCY)";
            end else begin
                GenJnlLine."NS_Retention Amount" := SalesHeader."NS_Retention Amount";
                GenJnlLine."NS_Retention Amount (LCY)" := SalesHeader."NS_Retention Amount (LCY)";
            end;
            GenJnlLine."NS_Retention Date" := SalesHeader."NS_Retention Date";
            //NS_JobsSetup.Get();               //MHNA-7.JS.1.0 22JUN2023 line commented
            if NS_JobsSetup.get() then;     //MHNA-7.JS.1.0 22JUN2023 line added
            if (NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" =
                NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"2 - Calc tax on sale then apply retention determined by progress billing") or
               (NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" =
                NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing") then begin

                SalesHeader.CalcFields("NS_Retention Base Before Tax", SalesHeader."NS_Retention Base Amount");  //MHNA-7.JS.1.0 22JUN2023
                GenJnlLine."NS_Retention Base Amount" := SalesHeader."NS_Retention Base Before Tax";
            end else begin
                SalesHeader.CalcFields("NS_Retention Base Amount");  //MHNA-7.JS.1.0 22JUN2023
                GenJnlLine."NS_Retention Base Amount" := SalesHeader."NS_Retention Base Amount";
            end;
            GenJnlLine."NS_Retention Document" := SalesHeader."NS_Retention Document";
            //MHNA-7.JS.1.0 22JUN2023 - Start
        end else begin
            SalesHeader.CalcFields("NS_Retention Base Amount");
            GenJnlLine."NS_Retention Base Amount" := SalesHeader."NS_Retention Base Amount";
        end;
        GenJnlLine."Job No." := SalesHeader."NS_Job No.";
        //MHNA-7.JS.1.0 22JUN2023 - end
        //end;
        //PRJ-1170.NK.1.0 End
    end;
    //PE-129.AS.1.0 end
    //PPDA.1.0 Start
    //PPNA17.0 Opened Start OnDivideAmountVATBaseAmount 
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnDivideAmountOnAfterCalcSalesTaxGeneral', '', false, false)]
    // local procedure NS_C80OnDivideAmountVATBaseAmount(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    // begin
    //     SalesLine."VAT Base Amount" := NS_AdjustVATBase(SalesHeader, SalesLine);
    // end;
    //PPNA17.0 Opened End
    //PPDA.1.0 End



    [Obsolete('Replaced by Microsoft with OnPrepareLineOnAfterFillInvoicePostingBuffer() in CU825Sales Post Invoice Events.', '22.0')]//PE-129.AS.1.0
    //PPNA16.0 Modified Event Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterFillInvoicePostBuffer', '', false, false)]
    local procedure NS_C80OnFillInvoicePostingBufferBeforeSetAccount(SalesLine: Record "Sales Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer")
    var
        NS_CustPostingGr: Record "Customer Posting Group";
        SalesHeader: Record "Sales Header";
    begin

        IF SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then begin
            if (SalesLine.Type <> SalesLine.Type::"G/L Account") and (SalesLine.Type <> SalesLine.Type::"Fixed Asset") then
                if SalesHeader."NS_Retention Document" and (SalesLine.Type = SalesLine.Type::NS_Ledger) then begin
                    NS_CustPostingGr.Get(SalesHeader."Customer Posting Group");
                    NS_CustPostingGr.TestField(NS_RetentionReceivablesAccount);
                    InvoicePostBuffer."G/L Account" := NS_CustPostingGr.NS_RetentionReceivablesAccount;
                end;
        end;

    end;

    //PE-129.AS.1.0 start Add
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Post Invoice Events", 'OnPrepareLineOnAfterFillInvoicePostingBuffer', '', false, false)]
    local procedure NS_C825OnPrepareLineOnAfterFillInvoicePostingBuffer(SalesLine: Record "Sales Line"; var InvoicePostingBuffer: Record "Invoice Posting Buffer" temporary)
    var
        NS_CustPostingGr: Record "Customer Posting Group";
        SalesHeader: Record "Sales Header";
    begin
        IF SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then begin
            if (SalesLine.Type <> SalesLine.Type::"G/L Account") and (SalesLine.Type <> SalesLine.Type::"Fixed Asset") then
                if SalesHeader."NS_Retention Document" and (SalesLine.Type = SalesLine.Type::NS_Ledger) then begin
                    NS_CustPostingGr.Get(SalesHeader."Customer Posting Group");
                    NS_CustPostingGr.TestField(NS_RetentionReceivablesAccount);
                    InvoicePostingBuffer."G/L Account" := NS_CustPostingGr.NS_RetentionReceivablesAccount;
                end;
        end;
    end;
    //PE-129.AS.1.0 end Add


    //PPNA16.0 Modified Event End

    //PPNA17.0 Opened Start OnPostItemJnlLineItemJnlRollRndgBefore 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeClearRemAmtIfNotItemJnlRollRndg', '', false, false)]
    local procedure NS_C80OnPostItemJnlLineItemJnlRollRndgBefore(SalesLine: Record "Sales Line"; ItemJnlRollRndg: Boolean; RemAmt: Decimal; RemDiscAmt: Decimal; var IsHandled: Boolean)
    begin
        p.NS_C80SetRemAmt(RemAmt);
        p.NS_C80SetRemDiscAmt(RemDiscAmt);
        IF SalesLine."Job No." = '' then
            IsHandled := true;
    end;
    //PPNA17.0 Opened End



    //PPNA17.0 Opened Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesCrMemoHeaderInsert', '', false, false)]
    local procedure C80OnBeforeSalesCrMemoHeaderInsert(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean)
    begin
        p.NS_C80SetGenJnlLineDocNo(SalesCrMemoHeader."No.");
        p.NS_C80SetGenJnlLineExtDocNo(SalesCrMemoHeader."External Document No.");

        SalesSetup.Get;
        if not SalesSetup."NS_Sales Retention Inactive" then
            p.NS_C80SetNS_GenJnlLineLedgerNo(SalesSetup."NS_Normal Customer Ledger No.");

        SalesHeader.CalcFields("NS_Retention Base Amount", "NS_Retention Base Before Tax");
        SalesCrMemoHeader."NS_Retention Base Amount" := SalesHeader."NS_Retention Base Amount";
        SalesCrMemoHeader."NS_Retention Base Before Tax" := SalesHeader."NS_Retention Base Before Tax";
    end;
    //PPNA17.0 Opened End


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesInvHeaderInsert', '', false, false)]
    local procedure NS_C80OnBeforeSalesInvHeaderInsert(var SalesInvHeader: Record "Sales Invoice Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean)
    begin
        p.NS_C80SetGenJnlLineDocNo(SalesInvHeader."No.");
        p.NS_C80SetGenJnlLineExtDocNo(SalesInvHeader."External Document No.");

        SalesSetup.Get;
        if not SalesSetup."NS_Sales Retention Inactive" then
            p.NS_C80SetNS_GenJnlLineLedgerNo(SalesSetup."NS_Normal Customer Ledger No.");

        SalesHeader.CalcFields("NS_Retention Base Amount", "NS_Retention Base Before Tax");
        SalesInvHeader."NS_Retention Base Amount" := SalesHeader."NS_Retention Base Amount";
        SalesInvHeader."NS_Retention Base Before Tax" := SalesHeader."NS_Retention Base Before Tax";
    end;

    //PPNA16.0 Modifeid Event Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostSalesLineOnBeforeTestJobNo', '', false, false)]
    local procedure NS_C80OnPostSalesLineBeforeTESTFIELDJobNo(SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
        //p.NS_C80SetPostSalesLine_JobNo := SalesLine."Job No.";
        //SalesLine."Job No." := '';
        //SalesLine.Modify(); //---
        IsHandled := true;
    end;
    //PPNA16.0 Modifeid Event End

    //PPNA16.0 Modifeid Event Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostSalesLineOnBeforeInsertShipmentLine', '', false, false)]
    local procedure NS_C80OnPostSalesLineAfterTESTFIELDJobNo(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; SalesLineACY: Record "Sales Line")
    begin
        //SalesLine."Job No." := p.NS_C80GetPostSalesLine_JobNo;
        //SalesLine.Modify(); //---
        if (SalesLine."Job No." <> '') and (SalesLine."Qty. to Invoice" <> 0) and
            (SalesLine.Type <> SalesLine.Type::NS_Ledger) and (SalesLine."Job Contract Entry No." = 0) then begin
            NS_PostJobEntry(SalesHeader, SalesLine, SalesLineACY);
        end;
    end;
    //PPNA16.0 Modifeid Event End

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterCheckMandatoryFields', '', false, false)]
    local procedure NS_C80OnAfterCheckMandatoryFields(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean)
    begin
        with SalesHeader do begin
            TestField("Customer Posting Group");
            NS_JobsSetup.Get;
            SalesSetup.Get;
            if not SalesSetup."NS_Sales Retention Inactive" then
                if "NS_Retention Amount" <> 0 then
                    TestField("NS_Retention Date");
            NS_CheckNotToExceed(SalesHeader);
            if not NS_CheckPrepaymentAmount(SalesHeader) then
                Error(NS_Text14021105);

            if not SalesSetup."NS_Sales Retention Inactive" then begin
                if SalesSetup."NS_Normal Customer Ledger No." = '' then
                    Error(NS_Text14021100);
                if NS_JobsSetup."NS_Retention Receivable Ledger" = '' then
                    Error(NS_Text14021101);
            end;
        end;
    end;

    //PPDA.1.0 Start Moved to dependent App
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesLine', '', false, false)]
    // local procedure NS_C80OnAfterPostSalesLine(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; CommitIsSuppressed: Boolean)
    // begin
    //     p.NS_C80SetNS_VatPostingGr(SalesLine."VAT Prod. Posting Group");
    // end;
    //PPDA.1.0 End
    local procedure NS_PostJobEntry(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; SalesLineACY: Record "Sales Line")
    var
        NS_JobJnlPostLine: Codeunit "Job Jnl.-Post Line";
        NS_JobJnlLine: Record "Job Journal Line";
        SourceCodeSetup: Record "Source Code Setup";
        NS_Jobs: Record Job;  //PE-22.JS.1.0 02FEB2022
        NSJobs2: Record Job;  //PE-175.JS.1.0 09OCT2023
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate"; //PRJ-1750.NK.1.0 26Dec2022
        CurrFactor: Decimal; //PRJ-1750.NK.1.0 26Dec2022
    begin
        // Post Job entry
        with SalesHeader do begin
            NS_JobJnlLine.Init;
            NS_JobJnlLine."Posting Date" := "Posting Date";
            NS_JobJnlLine."Document Date" := "Document Date";
            NS_JobJnlLine."Country/Region Code" := "VAT Country/Region Code";
            NS_JobJnlLine."Reason Code" := "Reason Code";
            NS_JobJnlLine."Job No." := SalesLine."Job No.";
            NS_JobJnlLine."Job Task No." := SalesLine."Job Task No.";
            NS_JobJnlLine."No." := SalesLine."No.";
            NS_JobJnlLine."Variant Code" := SalesLine."Variant Code";
            NS_JobJnlLine.Description := SalesLine.Description;
            NS_JobJnlLine."Description 2" := SalesLine."Description 2";
            NS_JobJnlLine."Unit of Measure Code" := SalesLine."Unit of Measure Code";
            NS_JobJnlLine."Location Code" := SalesLine."Location Code";
            NS_JobJnlLine."Bin Code" := SalesLine."Bin Code";
            NS_JobJnlLine."Posting Group" := SalesLine."Posting Group";
            NS_JobJnlLine."Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
            NS_JobJnlLine."Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
            NS_JobJnlLine."Dimension Set ID" := SalesLine."Dimension Set ID";
            NS_JobJnlLine."Work Type Code" := SalesLine."Work Type Code";
            NS_JobJnlLine."Gen. Bus. Posting Group" := SalesLine."Gen. Bus. Posting Group";
            NS_JobJnlLine."Gen. Prod. Posting Group" := SalesLine."Gen. Prod. Posting Group";
            NS_JobJnlLine."Transaction Type" := SalesLine."Transaction Type";
            NS_JobJnlLine."Transport Method" := SalesLine."Transport Method";
            NS_JobJnlLine."Entry/Exit Point" := SalesLine."Exit Point";
            NS_JobJnlLine.Area := SalesLine.Area;
            NS_JobJnlLine."Transaction Specification" := SalesLine."Transaction Specification";
            NS_JobJnlLine."Entry Type" := NS_JobJnlLine."Entry Type"::Sale;
            NS_JobJnlLine."Document No." := p.NS_C80GetGenJnlLineDocNo;
            NS_JobJnlLine."External Document No." := p.NS_C80GetGenJnlLineExtDocNo;
            case SalesLine.Type of
                SalesLine.Type::"G/L Account":
                    NS_JobJnlLine.Type := NS_JobJnlLine.Type::"G/L Account";
                SalesLine.Type::Resource:
                    NS_JobJnlLine.Type := NS_JobJnlLine.Type::Resource;
                SalesLine.Type::Item:
                    NS_JobJnlLine.Type := NS_JobJnlLine.Type::Item;
                SalesLine.Type::NS_Ledger:
                    NS_JobJnlLine.Type := NS_JobJnlLine.Type::NS_Ledger;
            end;
            NS_JobJnlLine.Quantity := -SalesLine."Qty. to Invoice";
            NS_JobJnlLine."Quantity (Base)" := -SalesLine."Qty. to Invoice (Base)";
            NS_JobJnlLine."Reserved Qty. (Base)" := -SalesLine."Reserved Qty. (Base)";
            NS_JobJnlLine."Currency Code" := SalesLine."Currency Code";
            //PRJ-1750.NK.1.0 26Dec2022 Start
            NS_JobJnlLine."Currency Factor" := CurrExchRate.ExchangeRate(SalesLine."Posting Date", SalesLine."Currency Code");
            if CurrExchRate.ExchangeRate(SalesLine."Posting Date", SalesLine."Currency Code") <> 0 then
                CurrFactor := CurrExchRate.ExchangeRate(SalesLine."Posting Date", SalesLine."Currency Code")
            else
                CurrFactor := 1;
            //PRJ-1750.NK.1.0 26Dec2022 End
            //PE-22.JS.1.0 02FEB2022 - Start  
            if (SalesLine."Job No." <> '') and (Salesline."Currency Code" <> '') and ((SalesHeader."NS_From ProgressBillingReq.No." <> 0) or (Salesline."Job Contract Entry No." = 0)) then  //PRJCTPR-224.JS.1.0
                if NS_Jobs.get(SalesLine."Job No.") then
                    if (NS_Jobs."Currency Code" = '') and (NS_Jobs."Invoice Currency Code" <> '') then
                        NS_JobJnlLine."Currency Code" := NS_Jobs."Currency Code";
            //PRJCTPR-355.JS.1.0 - 17APR2024 - Start
            if ((SalesLine."Job No." <> '') and (SalesHeader."NS_From ProgressBillingReq.No." <> 0) and (Salesline."Job Contract Entry No." = 0)) then
                if NS_Jobs.get(SalesLine."Job No.") then
                    if (NS_Jobs."Currency Code" <> '') and (NS_Jobs."Invoice Currency Code" = '') then
                        NS_JobJnlLine."Currency Code" := NS_Jobs."Currency Code";
            //PRJCTPR-355.JS.1.0 - 17APR2024 - end
            //PE-22.JS.1.0 02FEB2022 - end    
            //PE-175.JS.1.0 09OCT2023 - Start
            if NSJobs2.get(SalesLine."Job No.") then
                if NSJobs2."NS_Job Class" <> NSJobs2."NS_Job Class"::"Master Job" then
                    NS_JobJnlLine."NS_Sub-Level to Job No." := SalesLine."NS_Sub-Level to Job No.";
            //PE-175.JS.1.0 09OCT2023 - end      
            NS_JobJnlLine."Unit Cost" := SalesLine."Unit Cost";
            NS_JobJnlLine."Unit Cost (LCY)" := SalesLine."Unit Cost (LCY)";
            NS_JobJnlLine."Direct Unit Cost (LCY)" := SalesLine."Unit Cost (LCY)";
            NS_JobJnlLine."Total Cost" := Round(SalesLine."Unit Cost" * NS_JobJnlLine.Quantity, GLSetup."Unit-Amount Rounding Precision");
            NS_JobJnlLine."Total Cost (LCY)" := Round(SalesLine."Unit Cost (LCY)" * NS_JobJnlLine.Quantity, GLSetup."Unit-Amount Rounding Precision");
            NS_JobJnlLine."Total Price" := Round(SalesLine."Unit Price" * NS_JobJnlLine.Quantity, GLSetup."Unit-Amount Rounding Precision");//-SalesLine.Amount;//PRJ-849.MS.1.0 code comment and add code
                                                                                                                                            //PE-22.JS.1.0 07FEB2023 - Start
            if SalesLine."Currency Code" <> '' then
                if Currency.get(SalesLine."Currency Code") then;
            if (SalesLine."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0) and (SalesHeader."NS_From ProgressBillingReq.No." <> 0) then
                NS_JobJnlLine."Total Price" := Round((SalesLine."Unit Price" / SalesHeader."Currency Factor") * NS_JobJnlLine.Quantity, Currency."Amount Rounding Precision");
            //PE-22.JS.1.0 07FEB2023 - end        
            //NS_JobJnlLine."Total Price (LCY)" := Round(SalesLine."Unit Price" * NS_JobJnlLine.Quantity, GLSetup."Unit-Amount Rounding Precision");//-SalesLine.Amount;//PRJ-849.MS.1.0 code comment and add code //PRJ-1750.NK.1.0 26Dec2022 Block
            NS_JobJnlLine."Total Price (LCY)" := Round((SalesLine."Unit Price" / CurrFactor) * NS_JobJnlLine.Quantity, GLSetup."Unit-Amount Rounding Precision"); //PRJ-1750.NK.1.0 26Dec2022
            NS_JobJnlLine."Unit Price" := SalesLine."Unit Price";//-Round(SalesLine.Amount / SalesLine.Quantity, GLSetup."Unit-Amount Rounding Precision");//PRJ-849.MS.1.0 code comment and add code
                                                                 //PE-22.JS.2.0 07FEB2023 - Start
            if (SalesLine."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0) and (SalesHeader."NS_From ProgressBillingReq.No." <> 0) then begin
                NS_JobJnlLine."Total Price (LCY)" := Round((SalesLine."Unit Price" / SalesHeader."Currency Factor") * NS_JobJnlLine.Quantity, Currency."Amount Rounding Precision");
                NS_JobJnlLine."Unit Price" := Round((SalesLine."Unit Price" / SalesHeader."Currency Factor"), Currency."Amount Rounding Precision");
            end;
            //PE-22.JS.2.0 07FEB2023 - end    
            //NS_JobJnlLine."Unit Price (LCY)" := SalesLine."Unit Price"; //PRJ-1750.NK.1.0 26Dec2022 Block
            NS_JobJnlLine."Unit Price (LCY)" := SalesLine."Unit Price" / CurrFactor; //PRJ-1750.NK.1.0 26Dec2022
                                                                                     //PE-22.JS.1.0 07FEB2023- Start
            if (SalesLine."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0) then
                NS_JobJnlLine."Unit Price (LCY)" := Round((SalesLine."Unit Price" / SalesHeader."Currency Factor"), Currency."Amount Rounding Precision");
            //PE-22.JS.1.0 07FEB2023- end
            //NS_JobJnlLine."Line Amount" := -SalesLine."Line Amount"; //PRJCTPR-10.SD.1.0 10Jan2023 - Comment
            //NS_JobJnlLine."Line Amount (LCY)" := -SalesLine."Line Amount";//PRJ-1750.NK.1.0 26Dec2022 Block
            if Currency.Get(SalesLine."Currency Code") then//PRJCTPR-10.SD.1.0 10Jan2023 - Start
                NS_JobJnlLine."Line Amount" := -ROUND(CurrExchRate.ExchangeAmtLCYToFCY(SalesLine."Posting Date",
                                                            SalesLine."Currency Code", SalesLine."Line Amount",
                                                          CurrExchRate.ExchangeRate(SalesLine."Posting Date", SalesLine."Currency Code")),
                                                          Currency."Amount Rounding Precision", '>')
            else
                NS_JobJnlLine."Line Amount" := -SalesLine."Line Amount";
            NS_JobJnlLine."Line Amount (LCY)" := -SalesLine."Line Amount";//PRJCTPR-10.SD.1.0 10Jan2023 - End 
                                                                          //PE-22.JS.1.0 07FEB2023 - Start
            if (SalesLine."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0) and (SalesHeader."NS_From ProgressBillingReq.No." <> 0) then begin
                NS_JobJnlLine."Line Amount" := -SalesLine."Line Amount";
                NS_JobJnlLine."Line Amount (LCY)" := -SalesLine."Line Amount";
            end;
            //PE-22.JS.1.0 07FEB2023 - end        
            //NS_JobJnlLine."Line Amount (LCY)" := -SalesLine."Line Amount" / CurrFactor; //PRJ-1750.NK.1.0 26Dec2022 //PRJCTPR-10.SD.1.0 10Jan2023 - Comment
            NS_JobJnlLine."Line Discount %" := SalesLine."Line Discount %";
            NS_JobJnlLine."Line Discount Amount" := -SalesLine."Line Discount Amount";//PRJ-849.MS.1.0 Added Minus
            NS_JobJnlLine."Line Discount Amount (LCY)" := -SalesLine."Line Discount Amount";//PRJ-849.MS.1.0 Added Minus

            SourceCodeSetup.Get;
            NS_JobJnlLine."Source Code" := SourceCodeSetup.Sales;

            NS_JobJnlLine."Job Posting Only" := true;
            NS_JobJnlLine."Posting No. Series" := "Posting No. Series";
            NS_JobJnlLine."Source Currency Code" := "Currency Code";
            if not Currency.Get("Currency Code") then
                Currency.InitRoundingPrecision; //SPLN1.00
            NS_JobJnlLine."Source Currency Total Cost" := Round(SalesLineACY."Unit Cost" * NS_JobJnlLine.Quantity, Currency."Amount Rounding Precision");
            NS_JobJnlLine."Source Currency Total Price" := -SalesLineACY.Amount;
            NS_JobJnlLine."Qty. per Unit of Measure" := SalesLine."Qty. per Unit of Measure";
            NS_JobJnlLine."NS_Job Cost Category" := SalesLine."NS_Job Cost Category";
            NS_JobJnlLine."NS_Job Revenue Category" := SalesLine."NS_Job Revenue Category";
            NS_JobJnlLine."NS_External Relationship Type" := NS_JobJnlLine."NS_External Relationship Type"::Customer;
            NS_JobJnlLine."NS_External Relationship No." := SalesHeader."Bill-to Customer No.";
            NS_JobJnlLine."NS_External Relationship Name" := SalesHeader."Bill-to Name";
            NS_JobJnlLine."Customer Price Group" := SalesLine."Customer Price Group";
            NS_JobJnlLine."NS_Segment Code" := SalesLine."NS_Segment Code";//TM-10.AM.1.0
            NS_BeforeJobJnlLinePost(SalesLine, NS_JobJnlLine);//PRJ-1583.AS.1.0 Added Integration event
            NS_JobJnlPostLine.RunWithCheck(NS_JobJnlLine);
        end;
    end;

    //PPDA.1.0 Start
    // procedure NS_AdjustVATBase(PassSalesHeader: Record "Sales Header"; PassSalesLine: Record "Sales Line"): Decimal
    // begin
    //     if PassSalesHeader."NS_Retention Percent" = 0 then
    //         exit;
    //     if NS_JobsSetup.Get then
    //         if NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" = NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing" then begin
    //             GLSetup.Get;
    //             exit(PassSalesLine."VAT Base Amount" - Round(PassSalesLine."VAT Base Amount" * (PassSalesHeader."NS_Retention Percent" / 100), GLSetup."Amount Rounding Precision"));
    //         end;
    // end;
    //PPDA.1.0 End

    procedure NS_CheckNotToExceed(SalesHeader: Record "Sales Header")
    var
        NS_JobPlanningLine: Record "Job Planning Line";
        NS_SalesInvoiceLine: Record "Sales Invoice Line";
        NS_SalesCrMemoLine: Record "Sales Cr.Memo Line";
        NS_SalesLine, NS_SalesLine2 : Record "Sales Line";
        NS_Job: Record Job;
        NS_OperationCode, NS_ProcessCode, NS_ActivityCode, NS_JobTaskNoHold, NS_CategoryHold : Code[10];
        NS_PostingAmount, NS_InvoicedValue, NS_NotToExceed : Decimal;
        NS_SectionCode: Code[10];//PRJ-688.AM.1.0
        NS_Found: Boolean;
    begin
        with NS_SalesLine do begin
            Reset;
            SetRange("Document Type", SalesHeader."Document Type");
            SetRange("Document No.", SalesHeader."No.");
            SetFilter("Job No.", '>%1', '');
            if FindSet then
                repeat
                    //Find the lowest "Not To Exceed" value in Price Budget for this item
                    NS_NotToExceed := 0;
                    NS_JobTaskNoHold := '';
                    NS_CategoryHold := '';
                    NS_Found := false;
                    NS_JobPlanningLine.Reset;
                    NS_JobPlanningLine.SetCurrentKey("Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                                     "NS_Cost Category");
                    NS_JobPlanningLine.SetRange("Job No.", "Job No.");
                    NS_JobPlanningLine.SetRange("NS_Entry Type", NS_JobPlanningLine."NS_Entry Type"::Both);
                    NS_Job.NS_JobTaskNoToAPO("Job Task No.", NS_ActivityCode, NS_ProcessCode, NS_OperationCode, NS_SectionCode);//PRJ-688.AM.1.0
                    NS_JobPlanningLine.SetRange("NS_Activity Code", NS_ActivityCode);
                    NS_JobPlanningLine.SetRange("NS_Process Code", NS_ProcessCode);
                    NS_JobPlanningLine.SetRange("NS_Operation Code", NS_OperationCode);
                    NS_JobPlanningLine.SetRange("NS_Section Code", NS_SectionCode);//PRJ-688.AM.1.0
                    NS_JobPlanningLine.SetRange("NS_Cost Category", "NS_Job Revenue Category");
                    case Type of
                        Type::"G/L Account":
                            NS_JobPlanningLine.SetRange(Type, NS_JobPlanningLine.Type::"G/L Account");
                        Type::Item:
                            NS_JobPlanningLine.SetRange(Type, NS_JobPlanningLine.Type::Item);
                        Type::Resource:
                            NS_JobPlanningLine.SetRange(Type, NS_JobPlanningLine.Type::Resource);
                    end;
                    NS_JobPlanningLine.SetRange("No.", "No.");
                    NS_JobPlanningLine.SetRange("Variant Code", "Variant Code");
                    if not NS_JobPlanningLine.IsEmpty then
                        NS_Found := true
                    else begin
                        //Remove APO filters one by one
                        NS_JobPlanningLine.SetRange("NS_Operation Code");
                        if not NS_JobPlanningLine.IsEmpty then
                            NS_Found := true
                        else begin
                            NS_JobPlanningLine.SetRange("NS_Process Code");
                            if not NS_JobPlanningLine.IsEmpty then
                                NS_Found := true
                            else begin
                                //Try again without a Revenue Category
                                NS_JobPlanningLine.SetFilter("Job Task No.", "Job Task No.");
                                NS_JobPlanningLine.SetRange("NS_Cost Category");
                                if not NS_JobPlanningLine.IsEmpty then
                                    NS_Found := true;
                            end;
                        end;
                    end;
                    if NS_Found then
                        if NS_JobPlanningLine.FindSet then
                            repeat
                                NS_Found := true;
                                if ("Job Task No." = '') and (NS_JobPlanningLine."Job Task No." > '') then
                                    NS_Found := false;

                                if NS_Found and (NS_JobPlanningLine."NS_Not To Exceed" > 0) then
                                    if NS_NotToExceed = 0 then begin
                                        NS_NotToExceed := NS_JobPlanningLine."NS_Not To Exceed";
                                        NS_JobTaskNoHold := NS_JobPlanningLine."Job Task No.";
                                        NS_CategoryHold := NS_JobPlanningLine."NS_Cost Category";
                                    end else
                                        if NS_JobPlanningLine."NS_Not To Exceed" < NS_NotToExceed then begin
                                            NS_NotToExceed := NS_JobPlanningLine."NS_Not To Exceed";
                                            NS_JobTaskNoHold := NS_JobPlanningLine."Job Task No.";
                                            NS_CategoryHold := NS_JobPlanningLine."NS_Cost Category";
                                        end;
                            until NS_JobPlanningLine.Next = 0;

                    if NS_NotToExceed > 0 then begin
                        //Find the previously invoiced value that has been posted using the filters that worked above
                        NS_InvoicedValue := 0;
                        NS_SalesInvoiceLine.Reset;
                        NS_SalesInvoiceLine.SetCurrentKey("Sell-to Customer No.");
                        NS_SalesInvoiceLine.SetFilter("Sell-to Customer No.", "Sell-to Customer No.");
                        NS_SalesInvoiceLine.SetFilter("Job No.", "Job No.");
                        NS_SalesInvoiceLine.SetFilter("Job Task No.", NS_JobTaskNoHold);
                        NS_SalesInvoiceLine.SetFilter("NS_Job Revenue Category", NS_CategoryHold);
                        NS_SalesInvoiceLine.SetRange(Type, Type);
                        NS_SalesInvoiceLine.SetRange("No.", "No.");
                        if NS_SalesInvoiceLine.FindSet then
                            repeat
                                NS_Found := true;
                                if (NS_JobTaskNoHold = '') and (NS_SalesInvoiceLine."Job Task No." > '') then
                                    NS_Found := false;
                                if (NS_CategoryHold = '') and (NS_SalesInvoiceLine."NS_Job Revenue Category" > '') then
                                    NS_Found := false;

                                if NS_Found then
                                    NS_InvoicedValue += NS_SalesInvoiceLine.Amount;
                            until NS_SalesInvoiceLine.Next = 0;

                        //Subtract any Credit Memos from the previously invoiced value using the filters that worked above
                        NS_SalesCrMemoLine.Reset;
                        NS_SalesCrMemoLine.SetCurrentKey("Sell-to Customer No.");
                        NS_SalesCrMemoLine.SetFilter("Sell-to Customer No.", "Sell-to Customer No.");
                        NS_SalesCrMemoLine.SetFilter("Job No.", "Job No.");
                        NS_SalesCrMemoLine.SetFilter("Job Task No.", NS_JobTaskNoHold);
                        NS_SalesCrMemoLine.SetFilter("NS_Job Revenue Category", NS_CategoryHold);
                        NS_SalesCrMemoLine.SetRange(Type, Type);
                        NS_SalesCrMemoLine.SetRange("No.", "No.");
                        if NS_SalesCrMemoLine.FindSet then
                            repeat
                                NS_Found := true;
                                if (NS_JobTaskNoHold = '') and (NS_SalesCrMemoLine."Job Task No." > '') then
                                    NS_Found := false;
                                if (NS_CategoryHold = '') and (NS_SalesCrMemoLine."NS_Job Revenue Category" > '') then
                                    NS_Found := false;

                                if NS_Found then
                                    NS_InvoicedValue := NS_InvoicedValue - NS_SalesCrMemoLine.Amount;
                            until NS_SalesCrMemoLine.Next = 0;

                        //Check for any more lines in this Sales Header that are for the same item
                        NS_PostingAmount := "Line Amount";
                        NS_SalesLine2.Reset;
                        NS_SalesLine2.SetRange("Document Type", SalesHeader."Document Type");
                        NS_SalesLine2.SetRange("Document No.", SalesHeader."No.");
                        NS_SalesLine2.SetFilter("Line No.", '>%1', "Line No.");
                        if NS_SalesLine2.FindSet then
                            repeat
                                NS_Found := true;
                                if ("Job Task No." > '') and
                                   (NS_SalesLine2."Job Task No." <> "Job Task No.") then
                                    NS_Found := false;
                                if ("NS_Job Revenue Category" > '') and
                                   (NS_SalesLine2."NS_Job Revenue Category" <> "NS_Job Revenue Category") then
                                    NS_Found := false;
                                if NS_SalesLine2.Type <> Type then
                                    NS_Found := false;
                                if NS_SalesLine2."No." <> "No." then
                                    NS_Found := false;
                                if NS_Found then
                                    NS_PostingAmount := NS_PostingAmount + NS_SalesLine2."Line Amount";
                            until NS_SalesLine2.Next = 0;

                        //Compare InvoicedValue with NotToExceed value
                        if NS_NotToExceed > 0 then
                            if NS_PostingAmount + NS_InvoicedValue > NS_NotToExceed then begin
                                Error(NS_Text14021103, Format(NS_NotToExceed, 0, '<Precision,2:2><Standard Format,0>'), Format("Line No."), Format(Type), "No.",
                                      NS_JobTaskNoHold, NS_CategoryHold);
                            end;
                    end;
                until Next = 0;
        end;
    end;

    procedure NS_CheckPrepaymentAmount(SalesHeader: Record "Sales Header") Continue: Boolean
    var
        GLEntry: Record "G/L Entry";
        NS_Customer: Record Customer;
        NS_Job: Record Job;
        NS_GLPostingSetup: Record "General Posting Setup";
        NS_SalesLine: Record "Sales Line";
        NS_PrepaymentsDifference, NS_TotalPrepaymentsHistory, NS_TotalPrepayments, NS_TotalBilling, NS_TotalSalesHeader : Decimal;
    begin
        Continue := true;

        if SalesHeader."NS_Job No." = '' then
            exit;

        //Get total payment of document
        SalesHeader.CalcFields("Amount Including VAT");
        NS_TotalSalesHeader := SalesHeader."Amount Including VAT";

        NS_Customer.Get(SalesHeader."Bill-to Customer No.");
        NS_Job.Get(SalesHeader."NS_Job No.");

        with NS_SalesLine do begin
            Reset;
            SetRange("Document Type", SalesHeader."Document Type");
            SetRange("Document No.", SalesHeader."No.");
            if FindSet then
                repeat
                    if Type = Type::"G/L Account" then begin
                        if (NS_GLPostingSetup.Get(NS_SalesLine."Gen. Bus. Posting Group", NS_SalesLine."Gen. Prod. Posting Group")) and
                             ("No." = NS_GLPostingSetup."Sales Prepayments Account") then
                            NS_TotalPrepayments := NS_TotalPrepayments - Amount
                        else
                            NS_TotalBilling := NS_TotalBilling + Amount;
                    end;
                until Next = 0;
        end;

        with GLEntry do begin
            SetCurrentKey("NS_Prepayment for Job No.");
            SetRange("NS_Prepayment for Job No.", SalesHeader."NS_Job No.");
            if FindSet then
                repeat
                    if "NS_Prepayment for Job No." > '' then
                        NS_TotalPrepaymentsHistory := NS_TotalPrepaymentsHistory - Amount;
                until Next = 0;
        end;

        NS_PrepaymentsDifference := NS_TotalPrepaymentsHistory - NS_TotalPrepayments;
        if NS_PrepaymentsDifference > 0 then begin
            if Confirm(NS_Text14021104, false, NS_TotalPrepaymentsHistory, NS_PrepaymentsDifference) then
                Continue := false
            else
                Continue := true
        end else
            Continue := true;
    end;

    //PPNA17.0 Opened Start OnPostSalesLineOnAfterCase 
    //PRJ-57.SK.1.0 Start
    //[EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostSalesLineOnAfterCaseType', '', false, false)]   //PE-267.JS.1.0 05MAR2024 line commented event removed in Base BC24 by MS
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostSalesLineOnBeforePostSalesLine', '', false, false)]  //PE-267.JS.1.0 05MAR2024 line added
    //local procedure NS_C80PostLedgerType(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; GenJnlLineDocNo: Code[20]; GenJnlLineExtDocNo: Code[35]; GenJnlLineDocType: Integer; SrcCode: Code[10]; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")//PRJ-57.VT.1.0 04-03-20  //PE-267.JS.1.0 05MAR2024 line commented
    local procedure NS_C80PostLedgerType(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; GenJnlLineDocNo: Code[20]; GenJnlLineExtDocNo: Code[35]; GenJnlLineDocType: Enum "Gen. Journal Document Type"; SrcCode: Code[10]; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line") //PE-267.JS.1.0 05MAR2024 line added
    var
        Ishandle: Boolean;    //FGH-163.SM.29022024  //PE-269.JS.1.0
    begin
        //FGH-163.SM.29022024 //PE-269.JS.1.0 START
        OnbeforeNS_C80PostLedgerType(SalesHeader, SalesLine, GenJnlLineDocNo, GenJnlLineExtDocNo, GenJnlLineDocType, SrcCode, GenJnlPostLine, Ishandle);
        IF ishandle then
            exit;
        //FGH-163.SM.29022024 //PE-269.JS.1.0 END;
        IF SalesLine.Type = SalesLine.Type::NS_Ledger then
            NS_PostLedger(SalesHeader, SalesLine, GenJnlLineDocNo, GenJnlLineExtDocNo, GenJnlLineDocType.AsInteger(), SrcCode, GenJnlPostLine); //PRJ-57.VT.1.0 04-03-20  //PE-267.JS.1.0 05MAR2024
    end;
    //PRJ-57.SK.1.0 End
    //PPNA17.0 Opened End

    //PRJ-57.SK.1.0 Start
    local procedure NS_PostLedger(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; GenJnlLineDocNo: code[20]; GenJnlLineExtDocNo: code[35]; GenJnlLineDocType: Integer; SrcCode: code[10]; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")//PRJ-57.VT.1.0 04-03-20
    var
        GenJnlLine: Record "Gen. Journal Line";
        IsHandle: Boolean;//FGH-163.AS.29052024 //PE-307.JS.1.0
    //GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; // Code Commented PRJ-57.VT.1.0 04-03-20
    begin
        //ProjectPro - start
        WITH SalesHeader DO BEGIN
            //FGH-163.AS.29052024 START  //PE-307.JS.1.0
            NS_OnBeforeNS_PostLedger(SalesHeader, SalesLine, GenJnlLineDocNo, GenJnlLineExtDocNo, GenJnlLineDocType, SrcCode, GenJnlPostLine, IsHandle);//FGH-163.SMAdded Parameter  //PE-269.JS.1.0
            if IsHandle then
                exit;
            //FGH-163.AS.29052024 END  //PE-307.JS.1.0
            IF SalesLine.Amount <> 0 THEN BEGIN
                IF "Document Type" = "Document Type"::"Credit Memo" THEN
                    SalesLine.Amount := -SalesLine.Amount;
                GenJnlLine.INIT;
                GenJnlLine."Posting Date" := "Posting Date";
                GenJnlLine."Document Date" := "Document Date";
                GenJnlLine.Description := SalesLine.Description;
                GenJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                GenJnlLine."NS_Retention Ledger Code" := SalesLine."No.";
                GenJnlLine."Dimension Set ID" := "Dimension Set ID";
                GenJnlLine."Reason Code" := "Reason Code";
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                GenJnlLine."Account No." := "Bill-to Customer No.";
                GenJnlLine."Document Type" := GenJnlLineDocType;
                GenJnlLine."Document No." := GenJnlLineDocNo;
                GenJnlLine."External Document No." := GenJnlLineExtDocNo;
                GenJnlLine."Currency Code" := "Currency Code";
                GenJnlLine.Amount := SalesLine.Amount;
                GenJnlLine."Source Currency Code" := "Currency Code";
                GenJnlLine."Source Currency Amount" := GenJnlLine.Amount;
                GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
                IF SalesHeader."Currency Code" = '' THEN
                    GenJnlLine."Currency Factor" := 1
                ELSE
                    GenJnlLine."Currency Factor" := SalesHeader."Currency Factor";
                GenJnlLine.Correction := Correction;
                GenJnlLine."Sales/Purch. (LCY)" := GenJnlLine.Amount;
                GenJnlLine."Inv. Discount (LCY)" := SalesLine."Inv. Discount Amount";
                GenJnlLine."Bill-to/Pay-to No." := "Bill-to Customer No.";
                GenJnlLine."Salespers./Purch. Code" := "Salesperson Code";
                GenJnlLine."On Hold" := "On Hold";
                GenJnlLine."Applies-to Doc. Type" := "Applies-to Doc. Type";
                GenJnlLine."Applies-to Doc. No." := "Applies-to Doc. No.";
                GenJnlLine."Applies-to ID" := "Applies-to ID";
                GenJnlLine."Allow Application" := "Bal. Account No." = '';
                GenJnlLine."Due Date" := "Due Date";
                GenJnlLine."Payment Terms Code" := "Payment Terms Code";
                GenJnlLine."Pmt. Discount Date" := "Pmt. Discount Date";
                GenJnlLine."Payment Discount %" := "Payment Discount %";
                GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
                GenJnlLine."Source No." := "Bill-to Customer No.";
                GenJnlLine."Source Code" := SrcCode;
                GenJnlLine."Posting No. Series" := "Posting No. Series";
                GenJnlLine."NS_Retention Document" := "NS_Retention Document";
                GenJnlLine."Job No." := "NS_Job No.";
                GenJnlLine."NS_Segment Code" := salesline."NS_Segment Code";//TM-10.AM.1.0 

                GenJnlPostLine.RunWithCheck(GenJnlLine);//PRJ-57.VT.1.0 04-03-20
                IF "Document Type" = SalesHeader."Document Type"::"Credit Memo" THEN
                    SalesLine.Amount := -SalesLine.Amount;
            END;
        END;
        //ProjectPro - end
    end;
    //PRJ-57.SK.1.0 Start
    //TM-10.AM.1.0 start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesInvLineInsert', '', false, false)]

    local procedure C80OnBeforeSalesInvLineInsert(VAR SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line"; CommitIsSuppressed: Boolean)
    begin
        SalesInvLine."NS_Segment Code" := SalesLine."NS_Segment Code";
        SalesLine.CalcFields("NS_Segment Name");//TM-32.AM.1.0
        SalesInvLine."NS_Segment Name" := SalesLine."NS_Segment Name";//TM-32.AM.1.0
    end;
    //TM-10.AM.1.0 end

    //PRJ-884.JS.1.0  24Aug2021-Start
    [EventSubscriber(ObjectType::Codeunit, 80, 'OnBeforePostSalesDoc', '', false, false)]
    local procedure NS_C80OnBeforePostSalesDoc(VAR SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean)
    var
        ProgressBillingHeader: record "NS_Progress Billing Header";//PRJ-1332.GK.1.0 25Apr2022
        L_SalesHeader: Record "Sales Header";  //PRJ-1648.PS.1.0 05OCT2022
    begin

        // PE-15.PS.1.0 08Feb2023  Strat
        If (SalesHeader."NS_Retention Document" = true) and (SalesHeader.Status = SalesHeader.Status::Open) then
            Error('To calculate Retention, Status must be equal to Released on Sales Header: Document Type = %1, Document No.= %2. Current value is %3.', SalesHeader."Document Type",
                SalesHeader."No.", SalesHeader.Status);
        // PE-15.PS.1.0 08Feb2023  End
        IF ((SalesHeader."NS_Retention Percent" <> 0) and (SalesHeader.Status = SalesHeader.Status::Open)) then
            Error('To calculate Retention, Status must be equal to Released on Sales Header: Document Type = %1, Document No.= %2. Current value is %3.', SalesHeader."Document Type",
            SalesHeader."No.", SalesHeader.Status);
        //PRJ-1332.GK.1.0 25Apr2022 start
        // if (SalesHeader."NS_From Progress Billing No." <> '') and (SalesHeader."NS_Progress Billing Document" = true) then begin
        //     ProgressBillingHeader.reset;
        //     ProgressBillingHeader.SetRange("NS_No.", SalesHeader."NS_From Progress Billing No.");
        //     ProgressBillingHeader.SetRange("NS_Requisition No.", SalesHeader."NS_From ProgressBillingReq.No.");
        //     ProgressBillingHeader.SetRange("NS_Version No.", SalesHeader."NS_From ProgressBillingVer.No.");
        //     ProgressBillingHeader.SetRange("NS_Sales Document No.", SalesHeader."No.");
        //     if ProgressBillingHeader.FindFirst() then begin
        //         ProgressBillingHeader.TestField(NS_Final);
        //     end;
        // end;
        //PRJ-1332.GK.1.0 25Apr2022 end

        //PRJ-1648.PS.1.0  05OCT2022 - Start

        if (SalesHeader."NS_Retention Document" = false) and (SalesHeader."NS_From Progress Billing No." <> '') then begin
            L_SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
            L_SalesHeader.SetRange("NS_From Progress Billing No.", SalesHeader."NS_From Progress Billing No.");
            L_SalesHeader.SetRange("NS_From ProgressBillingReq.No.", SalesHeader."NS_From ProgressBillingReq.No.");
            L_SalesHeader.SetRange("NS_Retention Document", true);
            if L_SalesHeader.FindFirst() then begin
                Error('Please post the Retention Document first and then the Progress Billing Sales Invoice can be posted');
            end;
        end;

        //PRJ-1648.PS.1.0  05OCT2022 - End
    end;
    //PRJ-884.JS.1.0 24Aug2021-end

    //FGH-163.SM.29022024 //PE-269.JS.1.0 START
    [IntegrationEvent(false, false)]
    local procedure OnbeforeNS_C80PostLedgerType(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; GenJnlLineDocNo: Code[20]; GenJnlLineExtDocNo: Code[35]; GenJnlLineDocType: Integer; SrcCode: Code[10]; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var Ishandled: Boolean)
    begin
    end;
    //FGH-163.SM.29022024 //PE-269.JS.1.0 END

    //PRJ-1583.AS.1.0 START Added integration event
    [IntegrationEvent(false, false)]
    local procedure NS_BeforeJobJnlLinePost(var SalLineRec: Record "Sales Line"; var JobJnlLineRec: Record "Job Journal Line")
    begin
    end;
    //PRJ-1583.AS.1.0 END

    //FGH-163.AS.29052024 START //PE-307.JS.1.0
    [IntegrationEvent(false, false)]
    local procedure NS_OnBeforeNS_PostLedger(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var GenJnlLineDocNo: code[20]; var GenJnlLineExtDocNo: code[35]; var GenJnlLineDocType: Integer; var SrcCode: code[10]; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var IsHandle: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure NS_OnBefore_NS_C825OnPostLedgerEntryOnBeforeGenJnlPostLine(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line"; var SuppressCommit: Boolean; var PreviewMode: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var IsHandle: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure NS_OnBefore_NS_C80OnBeforePostCustomerEntry(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line"; var CommitIsSuppressed: Boolean; var PreviewMode: Boolean; var IsHandle: Boolean)
    begin

    end;
    //FGH-163.AS.29052024 END //PE-307.JS.1.0

    // PE-225.PS.1.0 10June2024 Start

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterPostSalesDoc', '', false, false)]
    local procedure NS_C80OnBafterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean; PreviewMode: Boolean)
    var
        NSJobSetup: Record "Jobs Setup";
        NSPostedSalesHeader: Record "Sales Invoice Header";
        NSCorrectPostedSalInv: Codeunit "Correct Posted Sales Invoice";
        NSSalesHeaderApplyCud: Codeunit "NS_Sales Header Apply";
    begin
        if NSPostedSalesHeader.Get(SalesInvHdrNo) then;
        if NSJobSetup.Get() then;
        if ((NSPostedSalesHeader."NS_From Progress Billing No." <> '') and (NSPostedSalesHeader."NS_Retention Document" = true)) then begin
            if NSJobSetup."NSAuto Apply Retetion Billing" = true then begin
                if not Confirm('Do you want to apply the Retention Released', true, true) then
                    Error('');
                NSPostedSalesHeader.CalcFields("Remaining Amount");
                if NSPostedSalesHeader."Remaining Amount" <> 0 then begin
                    NSSalesHeaderApplyCud.NSApplyRetentionSalesInvPromRetentionInvoice(NSPostedSalesHeader);
                    NSSalesHeaderApplyCud.NSApplyRetentionSalesInvFromRetentionInvoice(NSPostedSalesHeader);
                end;
            End;
        end;
    end;

    // PE-225.PS.1.0 10June2024 End
}

