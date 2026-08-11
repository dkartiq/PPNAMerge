codeunit 14021105 "NS_Job-Post Prepayments"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Permissions = TableData "Sales Line" = imd,
                  TableData "Invoice Post. Buffer" = imd,
                  TableData "Sales Invoice Header" = imd,
                  TableData "Sales Invoice Line" = imd,
                  TableData "Sales Cr.Memo Header" = imd,
                  TableData "Sales Cr.Memo Line" = imd,
                  TableData "General Posting Setup" = imd;

    trigger OnRun();
    begin
    end;

    var
        Text000: Label 'is not within your range of allowed posting dates';
        GLSetup: Record "General Ledger Setup";
        GenPostingSetup: Record "General Posting Setup";
        Text001: Label 'Invoice,Credit Memo';
        Text002: Label 'Posting Prepayment Lines   #2######\';
        Text003: Label '%1 %2 -> Invoice %3';
        Text004: Label 'Posting sales and tax      #3######\';
        Text005: Label 'Posting to customers       #4######\';
        Text006: Label 'Posting to bal. account    #5######';
        Text007: Label 'The combination of dimensions that is used in the document of type %1 with the number %2 is blocked. %3.';
        Text008: Label 'The combination of dimensions that is used in the document of type %1 with the number %2, line no. %3 is blocked. %4.';
        Text009: Label 'The dimensions that are used in the document of type %1 with the number %2 are not valid. %3.';
        Text010: Label 'The dimensions that are used in the document of type %1 with the number %2, line no. %3 are not valid. %4.';
        TempPrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer" temporary;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        Text011: Label '%1 %2 -> Credit Memo %3';
        Job: Record Job;
        Text14021100: Label 'Prepayment Invoice, Order %1';
        Text14021101: Label 'Prepayment Credit, Order %1';

    procedure NS_Invoice(var Job: Record Job; var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line");
    begin
        NS_Code(Job, SalesHeader, SalesLine, 0);
    end;

    procedure NS_CreditMemo(var Job: Record Job; var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line");
    begin
        NS_Code(Job, SalesHeader, SalesLine, 1);
    end;

    local procedure NS_Code(var Job2: Record Job; var SalesHeader2: Record "Sales Header"; var SalesLine2: Record "Sales Line"; DocumentType: Option Invoice,"Credit Memo");
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SourceCodeSetup: Record "Source Code Setup";
        Cust: Record Customer;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        PrepmtInvBuffer: Record "Prepayment Inv. Line Buffer" temporary;
        TotalPrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer";
        TotalPrepmtInvLineBufferLCY: Record "Prepayment Inv. Line Buffer";
        GenJnlLine: Record "Gen. Journal Line";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        TempVATAmountLineDeduct: Record "VAT Amount Line" temporary;
        CustLedgEntry: Record "Cust. Ledger Entry";
        TempSalesLines: Record "Sales Line" temporary;
        TempVATAmountLine0: Record "VAT Amount Line" temporary;
        TempVATAmountLine1: Record "VAT Amount Line" temporary;
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Window: Dialog;
        GenJnlLineDocNo: Code[20];
        GenJnlLineExtDocNo: Code[35];
        SrcCode: Code[10];
        PostingNoSeriesCode: Code[10];
        CalcPmtDiscOnCrMemos: Boolean;
        PostingDescription: Text[50];
        GenJnlLineDocType: Integer;
        PrevLineNo: Integer;
        LineCount: Integer;
        PostedDocTabNo: Integer;
        LineNo: Integer;
    begin
        Job := Job2;
        SalesHeader := SalesHeader2;
        SalesLine := SalesLine2;

        GLSetup.GET;
        SalesSetup.GET;
        with Job do begin
            TESTFIELD("Bill-to Customer No.");
            if GenJnlCheckLine.DateNotAllowed("NS_Prepayment Due Date") then
                FIELDERROR("NS_Prepayment Due Date", Text000);
            NS_ValidatePaymentMethod(SalesHeader);
            NS_CheckDim(SalesHeader);
            Cust.GET("Bill-to Customer No.");
            Cust.CheckBlockedCustOnDocs(Cust, NS_PrepmtDocTypeToDocType(DocumentType), false, true);

            // Get Doc. No. and save
            case DocumentType of
                DocumentType::Invoice:
                    begin
                        "NS_Prepayment No." :=
                          NoSeriesMgt.GetNextNo(SalesSetup."Posted Prepmt. Inv. Nos.", "NS_Prepayment Due Date", true);
                        GenJnlLineDocNo := "NS_Prepayment No.";
                        "NS_Prepayment No. Series" := SalesSetup."Posted Prepmt. Inv. Nos.";
                        PostingNoSeriesCode := "NS_Prepayment No. Series";
                    end;
                DocumentType::"Credit Memo":
                    begin
                        "NS_Prepmt. Cr. Memo No." :=
                          NoSeriesMgt.GetNextNo(SalesSetup."Posted Prepmt. Cr. Memo Nos.", "NS_Prepayment Due Date", true);
                        GenJnlLineDocNo := "NS_Prepmt. Cr. Memo No.";
                        PostingNoSeriesCode := "NS_Prepmt. Cr. Memo No. Series";
                        "NS_Prepmt. Cr. Memo No. Series" := SalesSetup."Posted Prepmt. Cr. Memo Nos.";
                    end;
            end;

            Window.OPEN(
              '#1#################################\\' +
              Text002 +
              Text004 +
              Text005 +
              Text006);
            Window.UPDATE(1, STRSUBSTNO('%1 %2', SELECTSTR(1 + DocumentType, Text001), "No."));

            SalesSetup.GET;
            SourceCodeSetup.GET;
            SrcCode := SourceCodeSetup.Sales;

            // Create posted header
            case DocumentType of
                DocumentType::Invoice:
                    begin
                        NS_InsertSalesInvHeader(SalesInvHeader, SalesHeader, PostingDescription, GenJnlLineDocNo, SrcCode, PostingNoSeriesCode);
                        PostingDescription := STRSUBSTNO(Text14021100, Job."No.");
                        GenJnlLineDocType := GenJnlLine."Document Type"::Invoice.AsInteger();
                        PostedDocTabNo := DATABASE::"Sales Invoice Header";
                        Window.UPDATE(1, STRSUBSTNO(Text003, DocumentType, "No.", SalesInvHeader."No."));
                    end;
                DocumentType::"Credit Memo":
                    begin
                        CalcPmtDiscOnCrMemos := NS_GetCalcPmtDiscOnCrMemos("NS_Prepmt. Payment Terms Code");
                        NS_InsertSalesCrMemoHeader(
                          SalesCrMemoHeader, SalesHeader, PostingDescription, GenJnlLineDocNo, SrcCode, PostingNoSeriesCode,
                          CalcPmtDiscOnCrMemos);
                        GenJnlLineDocType := GenJnlLine."Document Type"::"Credit Memo".AsInteger();
                        PostedDocTabNo := DATABASE::"Sales Cr.Memo Header";
                        Window.UPDATE(1, STRSUBSTNO(Text011, DocumentType, "No.", SalesCrMemoHeader."No."));
                    end;
            end;
            if SalesSetup."Copy Comments Order to Invoice" then
                NS_CopyCommentLines("No.", PostedDocTabNo, GenJnlLineDocNo);
            // Reverse old lines
            if DocumentType = DocumentType::Invoice then begin
                OnBeforeGetSalesLinesToDeduct(SalesHeader, TempSalesLines); //PPDA.1.0 Added
                //NS_GetSalesLinesToDeduct(SalesHeader,TempSalesLines)//PPDA.1.0 Commenetd
                if not TempSalesLines.ISEMPTY then
                    NS_CalcVATAmountLines(SalesHeader, TempSalesLines, TempVATAmountLineDeduct, DocumentType::"Credit Memo");
            end;

            // Create Lines
            PrepmtInvBuffer.DELETEALL;

            NS_BuildInvLineBuffer(SalesHeader, SalesLine, DocumentType, PrepmtInvBuffer, true);
            PrepmtInvBuffer.FIND('-');
            repeat
                LineCount := LineCount + 1;
                Window.UPDATE(2, LineCount);
                if PrepmtInvBuffer."Line No." <> 0 then
                    LineNo := PrevLineNo + PrepmtInvBuffer."Line No."
                else
                    LineNo := PrevLineNo + 10000;
                case DocumentType of
                    DocumentType::Invoice:
                        begin
                            SalesInvLine.INIT;
                            SalesInvLine."Document No." := SalesInvHeader."No.";
                            SalesInvLine."Line No." := LineNo;
                            SalesInvLine."Sell-to Customer No." := SalesInvHeader."Sell-to Customer No.";
                            SalesInvLine."Bill-to Customer No." := SalesInvHeader."Bill-to Customer No.";
                            SalesInvLine.Type := SalesInvLine.Type::"G/L Account";
                            SalesInvLine."No." := PrepmtInvBuffer."G/L Account No.";
                            SalesInvLine."Posting Date" := SalesInvHeader."Posting Date";
                            SalesInvLine."Unit of Measure Code" := SalesLine."Unit of Measure Code";
                            SalesInvLine.Description := PrepmtInvBuffer.Description;
                            SalesInvLine.Quantity := 1;
                            SalesInvLine."Unit Price" := PrepmtInvBuffer.Amount;
                            SalesInvLine."Line Amount" := PrepmtInvBuffer.Amount;
                            SalesInvLine."Gen. Bus. Posting Group" := PrepmtInvBuffer."Gen. Bus. Posting Group";
                            SalesInvLine."Gen. Prod. Posting Group" := PrepmtInvBuffer."Gen. Prod. Posting Group";
                            SalesInvLine."VAT Bus. Posting Group" := PrepmtInvBuffer."VAT Bus. Posting Group";
                            SalesInvLine."VAT Prod. Posting Group" := PrepmtInvBuffer."VAT Prod. Posting Group";
                            SalesInvLine."VAT %" := PrepmtInvBuffer."VAT %";
                            SalesInvLine.Amount := PrepmtInvBuffer.Amount;
                            SalesInvLine."VAT Difference" := PrepmtInvBuffer."VAT Difference";
                            SalesInvLine."Amount Including VAT" := PrepmtInvBuffer."Amount Incl. VAT";
                            SalesInvLine."VAT Calculation Type" := PrepmtInvBuffer."VAT Calculation Type";
                            SalesInvLine."VAT Base Amount" := PrepmtInvBuffer."VAT Base Amount";
                            SalesInvLine."VAT Identifier" := PrepmtInvBuffer."VAT Identifier";
                            SalesInvLine."Job No." := Job."No.";
                            NS_CreateInvoiceDimensions(SalesInvLine);
                            SalesInvLine.INSERT;
                            PostedDocTabNo := DATABASE::"Sales Invoice Line";
                        end;
                    DocumentType::"Credit Memo":
                        begin
                            SalesCrMemoLine.INIT;
                            SalesCrMemoLine."Document No." := SalesCrMemoHeader."No.";
                            SalesCrMemoLine."Line No." := LineNo;
                            SalesCrMemoLine."Sell-to Customer No." := SalesCrMemoHeader."Sell-to Customer No.";
                            SalesCrMemoLine."Bill-to Customer No." := SalesCrMemoHeader."Bill-to Customer No.";
                            SalesCrMemoLine.Type := SalesInvLine.Type::"G/L Account";
                            SalesCrMemoLine."No." := PrepmtInvBuffer."G/L Account No.";
                            SalesCrMemoLine."Posting Date" := SalesCrMemoHeader."Posting Date";
                            SalesCrMemoLine.Description := PrepmtInvBuffer.Description;
                            SalesCrMemoLine.Quantity := 1;
                            SalesCrMemoLine."Unit Price" := PrepmtInvBuffer.Amount;
                            SalesCrMemoLine."Line Amount" := PrepmtInvBuffer.Amount;
                            SalesCrMemoLine."Gen. Bus. Posting Group" := PrepmtInvBuffer."Gen. Bus. Posting Group";
                            SalesCrMemoLine."Gen. Prod. Posting Group" := PrepmtInvBuffer."Gen. Prod. Posting Group";
                            SalesCrMemoLine."VAT Bus. Posting Group" := PrepmtInvBuffer."VAT Bus. Posting Group";
                            SalesCrMemoLine."VAT Prod. Posting Group" := PrepmtInvBuffer."VAT Prod. Posting Group";
                            SalesCrMemoLine."VAT %" := PrepmtInvBuffer."VAT %";
                            SalesCrMemoLine.Amount := PrepmtInvBuffer.Amount;
                            SalesCrMemoLine."VAT Difference" := PrepmtInvBuffer."VAT Difference";
                            SalesCrMemoLine."Amount Including VAT" := PrepmtInvBuffer."Amount Incl. VAT";
                            SalesCrMemoLine."VAT Calculation Type" := PrepmtInvBuffer."VAT Calculation Type";
                            SalesCrMemoLine."VAT Base Amount" := PrepmtInvBuffer."VAT Base Amount";
                            SalesCrMemoLine."VAT Identifier" := PrepmtInvBuffer."VAT Identifier";
                            SalesCrMemoLine."Job No." := Job."No.";
                            NS_CreateCrMemoDimensions(SalesCrMemoLine);
                            SalesCrMemoLine.INSERT;
                            PostedDocTabNo := DATABASE::"Sales Cr.Memo Line";
                        end;
                end;
                PrevLineNo := LineNo;
            until PrepmtInvBuffer.NEXT = 0;

            // G/L Posting
            LineCount := 0;
            NS_CompressInvLineBuffer(SalesHeader, PrepmtInvBuffer);
            PrepmtInvBuffer.SETRANGE(Adjustment, false);
            PrepmtInvBuffer.FINDSET(true);
            repeat
                if DocumentType = DocumentType::Invoice then
                    PrepmtInvBuffer.ReverseAmounts;
                NS_RoundAmounts(SalesHeader, PrepmtInvBuffer, TotalPrepmtInvLineBuffer, TotalPrepmtInvLineBufferLCY);
                if "Currency Code" = '' then begin
                    NS_AdjustInvLineBuffers(SalesHeader, SalesLine, PrepmtInvBuffer, TotalPrepmtInvLineBuffer, DocumentType);
                    TotalPrepmtInvLineBufferLCY := TotalPrepmtInvLineBuffer;
                end else
                    NS_AdjustInvLineBuffers(SalesHeader, SalesLine, PrepmtInvBuffer, TotalPrepmtInvLineBufferLCY, DocumentType);
                PrepmtInvBuffer.MODIFY;
            until PrepmtInvBuffer.NEXT = 0;

            PrepmtInvBuffer.RESET;
            PrepmtInvBuffer.SETCURRENTKEY(Adjustment);
            PrepmtInvBuffer.FIND('+');
            repeat
                LineCount := LineCount + 1;
                Window.UPDATE(3, LineCount);

                GenJnlLine.INIT;
                GenJnlLine."Posting Date" := SalesHeader."Posting Date";
                GenJnlLine."Document Date" := SalesHeader."Document Date";
                GenJnlLine.Description := PostingDescription;
                GenJnlLine."Document Type" := GenJnlLineDocType;
                GenJnlLine."Document No." := GenJnlLineDocNo;
                GenJnlLine."External Document No." := GenJnlLineExtDocNo;
                GenJnlLine."Account No." := PrepmtInvBuffer."G/L Account No.";
                GenJnlLine."System-Created Entry" := true;
                GenJnlLine.Amount := PrepmtInvBuffer.Amount;
                GenJnlLine."Source Currency Code" := "Currency Code";
                GenJnlLine."Source Currency Amount" := PrepmtInvBuffer."Amount (ACY)";
                GenJnlLine.Correction :=
                  (DocumentType = DocumentType::"Credit Memo") and GLSetup."Mark Cr. Memos as Corrections";
                if not PrepmtInvBuffer.Adjustment then
                    GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::Sale;
                GenJnlLine."Gen. Bus. Posting Group" := PrepmtInvBuffer."Gen. Bus. Posting Group";
                GenJnlLine."Gen. Prod. Posting Group" := PrepmtInvBuffer."Gen. Prod. Posting Group";
                GenJnlLine."VAT Bus. Posting Group" := PrepmtInvBuffer."VAT Bus. Posting Group";
                GenJnlLine."VAT Prod. Posting Group" := PrepmtInvBuffer."VAT Prod. Posting Group";
                GenJnlLine."VAT Calculation Type" := PrepmtInvBuffer."VAT Calculation Type";
                GenJnlLine."VAT Base Amount" := PrepmtInvBuffer."VAT Base Amount";
                GenJnlLine."Source Curr. VAT Base Amount" := PrepmtInvBuffer."VAT Base Amount (ACY)";
                GenJnlLine."VAT Amount" := PrepmtInvBuffer."VAT Amount";
                GenJnlLine."Source Curr. VAT Amount" := PrepmtInvBuffer."VAT Amount (ACY)";
                GenJnlLine."VAT Difference" := PrepmtInvBuffer."VAT Difference";
                GenJnlLine."VAT Posting" := GenJnlLine."VAT Posting"::"Manual VAT Entry";
                if GenJnlLine."Document Type" = GenJnlLine."Document Type"::Invoice then begin
                    GenJnlLine."Shortcut Dimension 1 Code" := SalesInvLine."Shortcut Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := SalesInvLine."Shortcut Dimension 1 Code";
                    GenJnlLine."Dimension Set ID" := SalesInvLine."Dimension Set ID";
                end else begin
                    GenJnlLine."Shortcut Dimension 1 Code" := SalesCrMemoLine."Shortcut Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := SalesCrMemoLine."Shortcut Dimension 1 Code";
                    GenJnlLine."Dimension Set ID" := SalesCrMemoLine."Dimension Set ID";
                end;
                GenJnlLine."Job No." := PrepmtInvBuffer."Job No.";
                GenJnlLine."Source Code" := SrcCode;
                GenJnlLine."Bill-to/Pay-to No." := "Bill-to Customer No.";
                GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
                GenJnlLine."Source No." := "Bill-to Customer No.";
                GenJnlLine."VAT Calculation Type" := GenJnlLine."VAT Calculation Type"::"Sales Tax";
                GenJnlLine.Prepayment := true;
                GenJnlLine."Job No." := PrepmtInvBuffer."Job No.";
                GenJnlLine."NS_Prepayment for Job No." := PrepmtInvBuffer."Job No.";
                NS_RunGenJnlPostLine(GenJnlLine);
            until PrepmtInvBuffer.NEXT(-1) = 0;

            // Post customer entry
            Window.UPDATE(4, 1);
            GenJnlLine.INIT;
            GenJnlLine."Posting Date" := SalesHeader."Posting Date";
            GenJnlLine."Document Date" := SalesHeader."Document Date";
            GenJnlLine.Description := PostingDescription;
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
            GenJnlLine."Account No." := "Bill-to Customer No.";
            GenJnlLine."Document Type" := GenJnlLineDocType;
            GenJnlLine."Document No." := GenJnlLineDocNo;
            GenJnlLine."External Document No." := GenJnlLineExtDocNo;
            GenJnlLine."Currency Code" := "Currency Code";
            GenJnlLine.Amount := -TotalPrepmtInvLineBuffer."Amount Incl. VAT";
            GenJnlLine."Source Currency Code" := "Currency Code";
            GenJnlLine."Source Currency Amount" := -TotalPrepmtInvLineBuffer."Amount Incl. VAT";
            GenJnlLine."Amount (LCY)" := -TotalPrepmtInvLineBufferLCY."Amount Incl. VAT";
            GenJnlLine."Currency Factor" := 1;
            GenJnlLine.Correction :=
              (DocumentType = DocumentType::"Credit Memo") and GLSetup."Mark Cr. Memos as Corrections";
            GenJnlLine."Sales/Purch. (LCY)" := -TotalPrepmtInvLineBufferLCY.Amount;
            GenJnlLine."Profit (LCY)" := -TotalPrepmtInvLineBufferLCY.Amount;
            GenJnlLine."Sell-to/Buy-from No." := "Bill-to Customer No.";
            GenJnlLine."Bill-to/Pay-to No." := "Bill-to Customer No.";
            GenJnlLine."System-Created Entry" := true;
            GenJnlLine."Due Date" := "NS_Prepayment Due Date";
            GenJnlLine."Payment Terms Code" := "NS_Prepmt. Payment Terms Code";
            GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
            GenJnlLine."Source No." := "Bill-to Customer No.";
            GenJnlLine."Source Code" := SrcCode;
            GenJnlLine."Posting No. Series" := SalesSetup."Posted Prepmt. Inv. Nos.";
            GenJnlLine.Prepayment := true;
            if DocumentType = DocumentType::Invoice then
                GenJnlLine."Pmt. Discount Date" := "NS_Prepayment Due Date";
            GenJnlLine."NS_Retention Ledger Code" := SalesSetup."NS_Normal Customer Ledger No.";
            GenJnlLine."Job No." := PrepmtInvBuffer."Job No.";//*!*
            if GenJnlLine."Document Type" = GenJnlLine."Document Type"::Invoice then begin
                GenJnlLine."Shortcut Dimension 1 Code" := SalesInvLine."Shortcut Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code" := SalesInvLine."Shortcut Dimension 1 Code";
                GenJnlLine."Dimension Set ID" := SalesInvLine."Dimension Set ID";
            end else begin
                GenJnlLine."Shortcut Dimension 1 Code" := SalesCrMemoLine."Shortcut Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code" := SalesCrMemoLine."Shortcut Dimension 1 Code";
                GenJnlLine."Dimension Set ID" := SalesCrMemoLine."Dimension Set ID";
            end;
            GenJnlPostLine.RunWithCheck(GenJnlLine);


            // Update lines & header
            NS_UpdateSalesDocument(SalesHeader, SalesLine, DocumentType, GenJnlLineDocNo);
        end;

        Job2 := Job;
        SalesHeader2 := SalesHeader;
        SalesLine2 := SalesLine;
    end;

    local procedure NS_RoundAmounts(SalesHeader: Record "Sales Header"; var PrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer"; var TotalPrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer"; var TotalPrepmtInvLineBufLCY: Record "Prepayment Inv. Line Buffer");
    var
        VAT: Boolean;
    begin
        TotalPrepmtInvLineBuf.IncrAmounts(PrepmtInvLineBuf);

        if SalesHeader."Currency Code" <> '' then begin
            VAT := PrepmtInvLineBuf.Amount <> PrepmtInvLineBuf."Amount Incl. VAT";

            PrepmtInvLineBuf."Amount Incl. VAT" :=
              NS_AmountToLCY(
                SalesHeader, TotalPrepmtInvLineBuf."Amount Incl. VAT", TotalPrepmtInvLineBufLCY."Amount Incl. VAT");
            if VAT then
                PrepmtInvLineBuf.Amount := ROUND(PrepmtInvLineBuf."Amount Incl. VAT" / (1 + PrepmtInvLineBuf."VAT %" / 100))
            else
                PrepmtInvLineBuf.Amount := PrepmtInvLineBuf."Amount Incl. VAT";
            PrepmtInvLineBuf."VAT Amount" := PrepmtInvLineBuf."Amount Incl. VAT" - PrepmtInvLineBuf.Amount;
            if PrepmtInvLineBuf."VAT Base Amount" <> 0 then
                PrepmtInvLineBuf."VAT Base Amount" := PrepmtInvLineBuf.Amount;
        end;

        TotalPrepmtInvLineBufLCY.IncrAmounts(PrepmtInvLineBuf);
    end;

    local procedure NS_AmountToLCY(SalesHeader: Record "Sales Header"; TotalAmt: Decimal; PrevTotalAmt: Decimal): Decimal;
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        CurrExchRate.INIT;
        with SalesHeader do
            exit(
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY("Prepayment Due Date", "Currency Code", TotalAmt, 1)) -
              PrevTotalAmt);
    end;

    procedure NS_BuildInvLineBuffer(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; DocumentType: Option; var PrepmtInvBuf: Record "Prepayment Inv. Line Buffer"; UpdateLines: Boolean);
    var
        PrepmtInvBuf2: Record "Prepayment Inv. Line Buffer";
        TotalPrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer";
        TotalPrepmtInvLineBufferDummy: Record "Prepayment Inv. Line Buffer";
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        with SalesHeader do begin
            TempPrepmtInvLineBuf.RESET;
            TempPrepmtInvLineBuf.DELETEALL;
            SalesSetup.GET;
            NS_FillInvLineBuffer(SalesHeader, SalesLine, PrepmtInvBuf2);
            if UpdateLines then
                TempPrepmtInvLineBuf.CopyWithLineNo(PrepmtInvBuf2, SalesLine."Line No.");
            PrepmtInvBuf.InsertInvLineBuffer(PrepmtInvBuf2);
            if SalesSetup."Invoice Rounding" then
                NS_RoundAmounts(
                  SalesHeader, PrepmtInvBuf2, TotalPrepmtInvLineBuffer, TotalPrepmtInvLineBufferDummy);
            if SalesSetup."Invoice Rounding" then
                if NS_InsertInvoiceRounding(
                     SalesHeader, PrepmtInvBuf2, TotalPrepmtInvLineBuffer, SalesLine."Line No.")
                then
                    PrepmtInvBuf.InsertInvLineBuffer(PrepmtInvBuf2);
        end;
    end;

    local procedure NS_AdjustInvLineBuffers(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var PrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer"; var TotalPrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer"; DocumentType: Option Invoice,"Credit Memo");
    var
        VATAdjustment: array[2] of Decimal;
        //VAT: Option Base,Amount; //PRJ-682.AS.1.0 18MAY2021 Comment old
        VAT: Option ,Base,Amount;//PRJ-682.AS.1.0 18MAY2021 Added
    begin
        NS_CalcPrepmtAmtInvLCYInLines(SalesHeader, SalesLine, PrepmtInvLineBuf, DocumentType, VATAdjustment);
        if ABS(VATAdjustment[VAT::Base]) > GLSetup."Amount Rounding Precision" then
            NS_InsertCorrInvLineBuffer(PrepmtInvLineBuf, SalesHeader, VATAdjustment[VAT::Base])
        else
            if (VATAdjustment[VAT::Base] <> 0) or (VATAdjustment[VAT::Amount] <> 0) then begin
                PrepmtInvLineBuf.AdjustVATBase(VATAdjustment);
                TotalPrepmtInvLineBuf.AdjustVATBase(VATAdjustment);
            end;
    end;

    local procedure NS_CalcPrepmtAmtInvLCYInLines(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var PrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer"; DocumentType: Option Invoice,"Credit Memo"; var VATAdjustment: array[2] of Decimal);
    var
        PrepmtInvBufAmount: array[2] of Decimal;
        TotalAmount: array[2] of Decimal;
        LineAmount: array[2] of Decimal;
        Ratio: array[2] of Decimal;
        PrepmtAmtReminder: array[2] of Decimal;
        PrepmtAmountRnded: array[2] of Decimal;
        //VAT: Option Base,Amount;//PRJ-682.AS.1.0 18MAY2021 COMMENT OLD CODE
        VAT: Option ,Base,Amount;//PRJ-682.AS.1.0 18MAY2021 ADD WITH OPTION BLANK
    begin
        PrepmtInvLineBuf.AmountsToArray(PrepmtInvBufAmount);
        if DocumentType = DocumentType::Invoice then
            NS_ReverseDecArray(PrepmtInvBufAmount);

        TempPrepmtInvLineBuf.SetFilterOnPKey(PrepmtInvLineBuf);
        TempPrepmtInvLineBuf.CALCSUMS(Amount, "Amount Incl. VAT");
        TempPrepmtInvLineBuf.AmountsToArray(TotalAmount);
        for VAT := VAT::Base to VAT::Amount do
            if TotalAmount[VAT] = 0 then
                Ratio[VAT] := 0
            else
                Ratio[VAT] := PrepmtInvBufAmount[VAT] / TotalAmount[VAT];
        if TempPrepmtInvLineBuf.FINDSET then
            repeat
                TempPrepmtInvLineBuf.AmountsToArray(LineAmount);
                PrepmtAmountRnded[VAT::Base] := NS_CalcRndedAmount(LineAmount[VAT::Base], Ratio[VAT::Base], PrepmtAmtReminder[VAT::Base]);
                PrepmtAmountRnded[VAT::Amount] := NS_CalcRndedAmount(LineAmount[VAT::Amount], Ratio[VAT::Amount], PrepmtAmtReminder[VAT::Amount]);

                if DocumentType = DocumentType::"Credit Memo" then begin
                    VATAdjustment[VAT::Base] :=
                      VATAdjustment[VAT::Base] + SalesLine."Prepmt. Amount Inv. (LCY)" - PrepmtAmountRnded[VAT::Base];
                    SalesLine."Prepmt. Amount Inv. (LCY)" := 0;
                    VATAdjustment[VAT::Amount] :=
                      VATAdjustment[VAT::Amount] + SalesLine."Prepmt. VAT Amount Inv. (LCY)" - PrepmtAmountRnded[VAT::Amount];
                    SalesLine."Prepmt. VAT Amount Inv. (LCY)" := 0;
                end else begin
                    SalesLine."Prepmt. Amount Inv. (LCY)" := SalesLine."Prepmt. Amount Inv. (LCY)" + PrepmtAmountRnded[VAT::Base];
                    SalesLine."Prepmt. VAT Amount Inv. (LCY)" := SalesLine."Prepmt. VAT Amount Inv. (LCY)" + PrepmtAmountRnded[VAT::Amount];
                end;
            until TempPrepmtInvLineBuf.NEXT = 0;
        TempPrepmtInvLineBuf.DELETEALL;
    end;

    local procedure NS_CalcRndedAmount(LineAmount: Decimal; Ratio: Decimal; var Reminder: Decimal) RndedAmount: Decimal;
    var
        Amount: Decimal;
    begin
        Amount := Reminder + LineAmount * Ratio;
        RndedAmount := ROUND(Amount);
        Reminder := Amount - RndedAmount;
    end;

    local procedure NS_ReverseDecArray(var DecArray: array[2] of Decimal);
    var
        Idx: Integer;
    begin
        for Idx := 1 to ARRAYLEN(DecArray) do
            DecArray[Idx] := -DecArray[Idx];
    end;

    local procedure NS_InsertCorrInvLineBuffer(var PrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer"; SalesHeader: Record "Sales Header"; VATBaseAdjustment: Decimal);
    var
        NewPrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer";
        SavedPrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer";
        AdjmtAmountACY: Decimal;
    begin
        SavedPrepmtInvLineBuf := PrepmtInvLineBuf;

        if SalesHeader."Currency Code" = '' then
            AdjmtAmountACY := VATBaseAdjustment
        else
            AdjmtAmountACY := 0;

        //PRJ-831.AS.1.0 - START
        // NewPrepmtInvLineBuf.FillAdjInvLineBuffer(
        //   PrepmtInvLineBuf,
        //   NS_GetPrepmtAccNo(PrepmtInvLineBuf."Gen. Bus. Posting Group", PrepmtInvLineBuf."Gen. Prod. Posting Group"),
        //   VATBaseAdjustment, AdjmtAmountACY);
        // PrepmtInvLineBuf.InsertInvLineBuffer(NewPrepmtInvLineBuf);
        //PRJ-831.AS.1.0 - END

        //PRJ-831.AS.1.0 - START
        NewPrepmtInvLineBuf.FillAdjInvLineBuffer(
  PrepmtInvLineBuf,
  NS_GetPrepmtAccNo_New(PrepmtInvLineBuf."Gen. Bus. Posting Group", PrepmtInvLineBuf."Gen. Prod. Posting Group"),
  VATBaseAdjustment, AdjmtAmountACY);
        PrepmtInvLineBuf.InsertInvLineBuffer(NewPrepmtInvLineBuf);
        //PRJ-831.AS.1.0 - END

        NewPrepmtInvLineBuf.FillAdjInvLineBuffer(
          PrepmtInvLineBuf,
          NS_GetCorrBalAccNo(SalesHeader, VATBaseAdjustment > 0),
          -VATBaseAdjustment, -AdjmtAmountACY);
        PrepmtInvLineBuf.InsertInvLineBuffer(NewPrepmtInvLineBuf);

        PrepmtInvLineBuf := SavedPrepmtInvLineBuf;
    end;

    [Obsolete('Will be removed in Next build')]
    procedure NS_GetPrepmtAccNo(GenBusPostingGroup: Code[10]; GenProdPostingGroup: Code[10]): Code[20];  //PRJ-831.JS.1.0 12Aug2021 Line Commented
    begin
        if (GenBusPostingGroup <> GenPostingSetup."Gen. Bus. Posting Group") or
           (GenProdPostingGroup <> GenPostingSetup."Gen. Prod. Posting Group")
        then begin
            GenPostingSetup.GET(GenBusPostingGroup, GenProdPostingGroup);
            GenPostingSetup.TESTFIELD("Sales Prepayments Account");
        end;
        exit(GenPostingSetup."Sales Prepayments Account");
    end;

    procedure NS_GetPrepmtAccNo_New(GenBusPostingGroup: Code[20]; GenProdPostingGroup: Code[20]): Code[20];  //PRJ-831.JS.1.0 12Aug2021 Line Added// PRJ-831.AS.1.0 Added new function
    begin
        if (GenBusPostingGroup <> GenPostingSetup."Gen. Bus. Posting Group") or
           (GenProdPostingGroup <> GenPostingSetup."Gen. Prod. Posting Group")
        then begin
            GenPostingSetup.GET(GenBusPostingGroup, GenProdPostingGroup);
            GenPostingSetup.TESTFIELD("Sales Prepayments Account");
        end;
        exit(GenPostingSetup."Sales Prepayments Account");
    end;

    procedure NS_GetCorrBalAccNo(SalesHeader: Record "Sales Header"; PositiveAmount: Boolean): Code[20];
    var
        BalAccNo: Code[20];
    begin
        if SalesHeader."Currency Code" = '' then
            BalAccNo := NS_GetInvRoundingAccNo(SalesHeader."Customer Posting Group")
        else
            BalAccNo := NS_GetGainLossGLAcc(SalesHeader."Currency Code", PositiveAmount);
        exit(BalAccNo);
    end;

    procedure NS_GetInvRoundingAccNo(CustomerPostingGroup: Code[10]): Code[20];
    var
        CustPostingGr: Record "Customer Posting Group";
        GLAcc: Record "G/L Account";
    begin
        CustPostingGr.GET(CustomerPostingGroup);
        CustPostingGr.TESTFIELD("Invoice Rounding Account");
        GLAcc.GET(CustPostingGr."Invoice Rounding Account");
        exit(CustPostingGr."Invoice Rounding Account");
    end;

    local procedure NS_GetGainLossGLAcc(CurrencyCode: Code[10]; PositiveAmount: Boolean): Code[20];
    var
        Currency: Record Currency;
    begin
        Currency.GET(CurrencyCode);
        if PositiveAmount then begin
            Currency.TESTFIELD("Realized Gains Acc.");
            exit(Currency."Realized Gains Acc.");
        end;
        Currency.TESTFIELD("Realized Losses Acc.");
        exit(Currency."Realized Losses Acc.");
    end;

    local procedure NS_GetCurrencyAmountRoundingPrecision(CurrencyCode: Code[10]): Decimal;
    var
        Currency: Record Currency;
    begin
        Currency.Initialize(CurrencyCode);
        Currency.TESTFIELD("Amount Rounding Precision");
        exit(Currency."Amount Rounding Precision");
    end;

    procedure NS_FillInvLineBuffer(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; var PrepmtInvBuf: Record "Prepayment Inv. Line Buffer");
    begin
        with PrepmtInvBuf do begin
            CLEAR(PrepmtInvBuf);

            NS_FillInvLineBufKey(SalesLine, PrepmtInvBuf);
            if not SalesHeader."Compress Prepayment" then begin
                "Line No." := SalesLine."Line No.";
                Description := SalesLine.Description;
            end;
            FillFromGLAcc(SalesHeader."Compress Prepayment");
            "Gen. Bus. Posting Group" := SalesLine."Gen. Bus. Posting Group";
            "VAT Bus. Posting Group" := SalesLine."VAT Bus. Posting Group";
            "VAT Calculation Type" := SalesLine."Prepmt. VAT Calc. Type";
            "Global Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
            "Global Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
            Amount := SalesLine."Prepayment Amount";
            "Amount Incl. VAT" := SalesLine."Prepmt. Amt. Incl. VAT";
            "VAT Base Amount" := SalesLine."Prepayment Amount";
            "VAT Amount" := SalesLine."Prepmt. Amt. Incl. VAT" - SalesLine."Prepayment Amount";
            "Amount (ACY)" := SalesLine."Prepayment Amount";
            "VAT Base Amount (ACY)" := SalesLine."Prepayment Amount";
            "VAT Amount (ACY)" := SalesLine."Prepmt. Amt. Incl. VAT" - SalesLine."Prepayment Amount";
            "VAT %" := SalesLine."Prepayment VAT %";
            "VAT Identifier" := SalesLine."Prepayment VAT Identifier";
            "VAT Difference" := SalesLine."Prepayment VAT Difference";
            "Job No." := SalesLine."Job No.";
        end;
    end;

    local procedure NS_FillInvLineBufKey(SalesLine: Record "Sales Line"; var PrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer");
    begin
        with PrepmtInvLineBuf do begin
            //"G/L Account No." := NS_GetPrepmtAccNo(SalesLine."Gen. Bus. Posting Group", SalesLine."Gen. Prod. Posting Group");//PRJ-831.AS.2.0 
            "G/L Account No." := NS_GetPrepmtAccNo_New(SalesLine."Gen. Bus. Posting Group", SalesLine."Gen. Prod. Posting Group");//PRJ-831.AS.2.0 
            "Dimension Set ID" := SalesLine."Dimension Set ID";
            "Job No." := SalesLine."Job No.";
            "Tax Area Code" := SalesLine."Tax Area Code";
            "Tax Liable" := SalesLine."Tax Liable";
            "Tax Group Code" := SalesLine."Tax Group Code";
        end;
    end;

    local procedure NS_InsertInvoiceRounding(SalesHeader: Record "Sales Header"; var PrepmtInvBuf: Record "Prepayment Inv. Line Buffer"; TotalPrepmtInvBuf: Record "Prepayment Inv. Line Buffer"; PrevLineNo: Integer): Boolean;
    var
        SalesLine: Record "Sales Line";
    begin
        if NS_InitInvoiceRoundingLine(SalesHeader, TotalPrepmtInvBuf."Amount Incl. VAT", SalesLine) then begin
            NS_CreateDimensions(SalesLine);
            with PrepmtInvBuf do begin
                CLEAR(PrepmtInvBuf);
                "Invoice Rounding" := true;
                "G/L Account No." := SalesLine."No.";
                "Gen. Bus. Posting Group" := SalesHeader."Gen. Bus. Posting Group";
                "VAT Bus. Posting Group" := SalesHeader."VAT Bus. Posting Group";
                "Gen. Prod. Posting Group" := SalesLine."Gen. Prod. Posting Group";
                "VAT Prod. Posting Group" := SalesLine."VAT Prod. Posting Group";
                "VAT Calculation Type" := SalesLine."VAT Calculation Type";
                "Global Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
                "Global Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
                "Dimension Set ID" := SalesLine."Dimension Set ID";
                Amount := SalesLine."Line Amount";
                "Amount Incl. VAT" := SalesLine."Amount Including VAT";
                "VAT Base Amount" := SalesLine."Line Amount";
                "VAT Amount" := SalesLine."Amount Including VAT" - SalesLine."Line Amount";
                "Amount (ACY)" := SalesLine."Prepayment Amount";
                "VAT Base Amount (ACY)" := SalesLine."Line Amount";
                "VAT Amount (ACY)" := SalesLine."Amount Including VAT" - SalesLine."Line Amount";
                "VAT %" := SalesLine."VAT %";
                "VAT Identifier" := SalesLine."VAT Identifier";
                "Line No." := PrevLineNo + 10000;
            end;
            exit(true);
        end;
    end;

    local procedure NS_InitInvoiceRoundingLine(SalesHeader: Record "Sales Header"; TotalAmount: Decimal; var SalesLine: Record "Sales Line"): Boolean;
    var
        Currency: Record Currency;
        InvoiceRoundingAmount: Decimal;
    begin
        Currency.Initialize(SalesHeader."Currency Code");
        Currency.TESTFIELD("Invoice Rounding Precision");
        InvoiceRoundingAmount :=
          -ROUND(
            TotalAmount -
            ROUND(
              TotalAmount,
              Currency."Invoice Rounding Precision",
              Currency.InvoiceRoundingDirection),
            Currency."Amount Rounding Precision");

        if InvoiceRoundingAmount = 0 then
            exit(false);

        with SalesLine do begin
            SetHideValidationDialog(true);
            "Document Type" := SalesHeader."Document Type";
            "Document No." := SalesHeader."No.";
            "System-Created Entry" := true;
            Type := Type::"G/L Account";
            VALIDATE("No.", NS_GetInvRoundingAccNo(SalesHeader."Customer Posting Group"));
            VALIDATE(Quantity, 1);
            if SalesHeader."Prices Including VAT" then
                VALIDATE("Unit Price", InvoiceRoundingAmount)
            else
                VALIDATE(
                  "Unit Price",
                  ROUND(
                    InvoiceRoundingAmount /
                    (1 + (1 - SalesHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
                    Currency."Amount Rounding Precision"));
            "Prepayment Amount" := "Unit Price";
            VALIDATE("Amount Including VAT", InvoiceRoundingAmount);
        end;
        exit(true);
    end;

    local procedure NS_CompressInvLineBuffer(SalesHeader: Record "Sales Header"; var PrepmtInvBuffer: Record "Prepayment Inv. Line Buffer");
    var
        PrepmtInvBuffer2: Record "Prepayment Inv. Line Buffer" temporary;
    begin
        if SalesHeader."Compress Prepayment" then
            exit;

        with PrepmtInvBuffer2 do begin
            PrepmtInvBuffer.FIND('-');
            repeat
                PrepmtInvBuffer2 := PrepmtInvBuffer;
                "Line No." := 0;
                if FIND then begin
                    IncrAmounts(PrepmtInvBuffer);
                    MODIFY;
                end else
                    INSERT;
            until PrepmtInvBuffer.NEXT = 0;

            PrepmtInvBuffer.DELETEALL;

            FIND('-');
            repeat
                PrepmtInvBuffer := PrepmtInvBuffer2;
                PrepmtInvBuffer.INSERT;
            until NEXT = 0;
        end;
    end;

    local procedure NS_CopyCommentLines(FromNumber: Code[20]; ToDocType: Integer; ToNumber: Code[20]);
    var
        SalesCommentLine: Record "Sales Comment Line";
        SalesCommentLine2: Record "Sales Comment Line";
    begin
        with SalesCommentLine do begin
            SETRANGE("Document Type", "Document Type"::Order);
            SETRANGE("No.", FromNumber);
            if FIND('-') then
                repeat
                    SalesCommentLine2 := SalesCommentLine;
                    case ToDocType of
                        DATABASE::"Sales Invoice Header":
                            SalesCommentLine2."Document Type" :=
                              SalesCommentLine2."Document Type"::"Posted Invoice";
                        DATABASE::"Sales Cr.Memo Header":
                            SalesCommentLine2."Document Type" :=
                              SalesCommentLine2."Document Type"::"Posted Credit Memo";
                    end;
                    SalesCommentLine2."No." := ToNumber;
                    SalesCommentLine2.INSERT;
                until NEXT = 0;
        end;
    end;

    procedure NS_CalcVATAmountLines(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var VATAmountLine: Record "VAT Amount Line"; DocumentType: Option Invoice,"Credit Memo",Statistic);
    var
        PrevVatAmountLine: Record "VAT Amount Line";
        Currency: Record Currency;
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        NewAmount: Decimal;
        NewPrepmtVATDiffAmt: Decimal;
    begin
        Currency.Initialize(SalesHeader."Currency Code");

        VATAmountLine.DELETEALL;

        with SalesLine do begin
            NS_ApplyFilter(SalesHeader, DocumentType, SalesLine);
            if FIND('-') then
                repeat
                    OnBeforeSetNewAmount(NewAmount, DocumentType, SalesLine, SalesHeader); //PPDA.1.0 Added
                    //NewAmount := NS_PrepmtAmount(SalesLine, DocumentType, SalesHeader."Prepmt. Include Tax");//PPDA.1.0 Commented
                    if NewAmount <> 0 then begin
                        if DocumentType = DocumentType::Invoice then
                            NewAmount := "Prepmt. Line Amount";
                        if "Prepmt. VAT Calc. Type" in
                           ["VAT Calculation Type"::"Reverse Charge VAT", "VAT Calculation Type"::"Sales Tax"]
                        then
                            "VAT %" := 0;
                        if not VATAmountLine.GET(
                             "Prepayment VAT Identifier",
                             "Prepmt. VAT Calc. Type", "Prepayment Tax Group Code",
                             false, NewAmount >= 0)
                        then begin
                            VATAmountLine.INIT;
                            VATAmountLine."VAT Identifier" := "Prepayment VAT Identifier";
                            VATAmountLine."VAT Calculation Type" := "Prepmt. VAT Calc. Type";
                            VATAmountLine."Tax Group Code" := "Prepayment Tax Group Code";
                            VATAmountLine."VAT %" := "Prepayment VAT %";
                            VATAmountLine.Modified := true;
                            VATAmountLine.Positive := NewAmount >= 0;
                            VATAmountLine."Includes Prepayment" := true;
                            VATAmountLine.INSERT;
                        end;
                        VATAmountLine."Line Amount" := VATAmountLine."Line Amount" + NewAmount;
                        NewPrepmtVATDiffAmt := NS_PrepmtVATDiffAmount(SalesLine, DocumentType);
                        if DocumentType = DocumentType::Invoice then
                            NewPrepmtVATDiffAmt := "Prepayment VAT Difference" + "Prepmt VAT Diff. to Deduct" +
                              "Prepmt VAT Diff. Deducted";
                        VATAmountLine."VAT Difference" := VATAmountLine."VAT Difference" + NewPrepmtVATDiffAmt;
                        VATAmountLine.MODIFY;
                    end;
                until NEXT = 0;
        end;

        with VATAmountLine do
            if FIND('-') then
                repeat
                    if (PrevVatAmountLine."VAT Identifier" <> "VAT Identifier") or
                       (PrevVatAmountLine."VAT Calculation Type" <> "VAT Calculation Type") or
                       (PrevVatAmountLine."Tax Group Code" <> "Tax Group Code") or
                       (PrevVatAmountLine."Use Tax" <> "Use Tax")
                    then
                        PrevVatAmountLine.INIT;
                    if SalesHeader."Prices Including VAT" then begin
                        case "VAT Calculation Type" of
                            "VAT Calculation Type"::"Normal VAT",
                            "VAT Calculation Type"::"Reverse Charge VAT":
                                begin
                                    "VAT Base" :=
                                      ROUND(
                                        ("Line Amount" - "Invoice Discount Amount") / (1 + "VAT %" / 100),
                                        Currency."Amount Rounding Precision") - "VAT Difference";
                                    "VAT Amount" :=
                                      "VAT Difference" +
                                      ROUND(
                                        PrevVatAmountLine."VAT Amount" +
                                        ("Line Amount" - "VAT Base" - "VAT Difference") *
                                        (1 - SalesHeader."VAT Base Discount %" / 100),
                                        Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                    "Amount Including VAT" := "VAT Base" + "VAT Amount";
                                    if Positive then
                                        PrevVatAmountLine.INIT
                                    else begin
                                        PrevVatAmountLine := VATAmountLine;
                                        PrevVatAmountLine."VAT Amount" :=
                                          ("Line Amount" - "VAT Base" - "VAT Difference") *
                                          (1 - SalesHeader."VAT Base Discount %" / 100);
                                        PrevVatAmountLine."VAT Amount" :=
                                          PrevVatAmountLine."VAT Amount" -
                                          ROUND(PrevVatAmountLine."VAT Amount", Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                    end;
                                end;
                            "VAT Calculation Type"::"Sales Tax":
                                begin
                                    "Amount Including VAT" := "Line Amount" - "Invoice Discount Amount";
                                    "VAT Base" :=
                                      ROUND(
                                        SalesTaxCalculate.ReverseCalculateTax(
                                          SalesHeader."Tax Area Code", "Tax Group Code", SalesHeader."Tax Liable",
                                          SalesHeader."Posting Date", "Amount Including VAT", Quantity, SalesHeader."Currency Factor"),
                                        Currency."Amount Rounding Precision");
                                    "VAT Amount" := "VAT Difference" + "Amount Including VAT" - "VAT Base";
                                    if "VAT Base" = 0 then
                                        "VAT %" := 0
                                    else
                                        "VAT %" := ROUND(100 * "VAT Amount" / "VAT Base", 0.00001);
                                end;
                        end;
                    end else
                        case "VAT Calculation Type" of
                            "VAT Calculation Type"::"Normal VAT",
                            "VAT Calculation Type"::"Reverse Charge VAT":
                                begin
                                    "VAT Base" := "Line Amount" - "Invoice Discount Amount";
                                    "VAT Amount" :=
                                      "VAT Difference" +
                                      ROUND(
                                        PrevVatAmountLine."VAT Amount" +
                                        "VAT Base" * "VAT %" / 100 * (1 - SalesHeader."VAT Base Discount %" / 100),
                                        Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                    "Amount Including VAT" := "Line Amount" - "Invoice Discount Amount" + "VAT Amount";
                                    if Positive then
                                        PrevVatAmountLine.INIT
                                    else begin
                                        PrevVatAmountLine := VATAmountLine;
                                        PrevVatAmountLine."VAT Amount" :=
                                          "VAT Base" * "VAT %" / 100 * (1 - SalesHeader."VAT Base Discount %" / 100);
                                        PrevVatAmountLine."VAT Amount" :=
                                          PrevVatAmountLine."VAT Amount" -
                                          ROUND(PrevVatAmountLine."VAT Amount", Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                    end;
                                end;
                            "VAT Calculation Type"::"Sales Tax":
                                begin
                                    "VAT Base" := "Line Amount" - "Invoice Discount Amount";
                                    "VAT Amount" :=
                                      SalesTaxCalculate.CalculateTax(
                                        SalesHeader."Tax Area Code", "Tax Group Code", SalesHeader."Tax Liable",
                                        SalesHeader."Posting Date", "VAT Base", Quantity, SalesHeader."Currency Factor");
                                    if "VAT Base" = 0 then
                                        "VAT %" := 0
                                    else
                                        "VAT %" := ROUND(100 * "VAT Amount" / "VAT Base", 0.00001);
                                    "VAT Amount" :=
                                      "VAT Difference" +
                                      ROUND("VAT Amount", Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                    "Amount Including VAT" := "VAT Base" + "VAT Amount";
                                end;
                        end;

                    "Calculated VAT Amount" := "VAT Amount" - "VAT Difference";
                    MODIFY;
                until NEXT = 0;
    end;

    local procedure NS_CheckDim(SalesHeader: Record "Sales Header");
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine."Line No." := 0;
        NS_CheckDimValuePosting(SalesHeader, SalesLine);
        NS_CheckDimComb(SalesHeader, SalesLine);

        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.SETFILTER(Type, '<>%1', SalesLine.Type::" ");
        if SalesLine.FIND('-') then
            repeat
                NS_CheckDimComb(SalesHeader, SalesLine);
                NS_CheckDimValuePosting(SalesHeader, SalesLine);
            until SalesLine.NEXT = 0;
    end;

    procedure NS_ApplyFilter(SalesHeader: Record "Sales Header"; DocumentType: Option Invoice,"Credit Memo",Statistic; var SalesLine: Record "Sales Line");
    begin
        with SalesLine do begin
            RESET;
            SETRANGE("Document Type", SalesHeader."Document Type");
            SETRANGE("Document No.", SalesHeader."No.");
            SETFILTER(Type, '<>%1', Type::" ");
            if DocumentType in [DocumentType::Invoice, DocumentType::Statistic] then
                SETFILTER("Prepmt. Line Amount", '<>0')
            else
                SETFILTER("Prepmt. Amt. Inv.", '<>0');
        end;
    end;

    //PPDA.1.0 Start
    // procedure NS_PrepmtAmount(SalesLine: Record "Sales Line"; DocumentType: Option Invoice,"Credit Memo",Statistic; IncludeTax: Boolean): Decimal;
    // var
    //     PrepmtAmt: Decimal;
    // begin
    //     with SalesLine do begin
    //         case DocumentType of
    //             DocumentType::Statistic:
    //                 PrepmtAmt := "Prepmt. Line Amount";
    //             DocumentType::Invoice:
    //                 PrepmtAmt := "Prepmt. Line Amount" - "Prepmt. Amt. Inv.";
    //             else
    //                 PrepmtAmt := "Prepmt. Amt. Inv." - "Prepmt Amt Deducted";
    //         end;
    //         if IncludeTax then
    //             PrepmtAmt := CalcAmountIncludingTax(PrepmtAmt);
    //         exit(PrepmtAmt);
    //     end;
    // end;
    //PPDA.1.0 End
    local procedure NS_CheckDimComb(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line");
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        if SalesLine."Line No." = 0 then
            if not DimMgt.CheckDimIDComb(SalesHeader."Dimension Set ID") then
                ERROR(Text007, SalesHeader."Document Type", SalesHeader."No.", DimMgt.GetDimCombErr);

        if SalesLine."Line No." <> 0 then
            if not DimMgt.CheckDimIDComb(SalesLine."Dimension Set ID") then
                ERROR(Text008, SalesHeader."Document Type", SalesHeader."No.", SalesLine."Line No.", DimMgt.GetDimCombErr);
    end;

    local procedure NS_CheckDimValuePosting(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line");
    var
        DimMgt: Codeunit DimensionManagement;
        TableIDArr: array[10] of Integer;
        NumberArr: array[10] of Code[20];
    begin
        if SalesLine."Line No." = 0 then begin
            TableIDArr[1] := DATABASE::Customer;
            NumberArr[1] := SalesHeader."Bill-to Customer No.";
            TableIDArr[2] := DATABASE::Job;
            //NumberArr[2] := SalesHeader."Job No.";
            TableIDArr[3] := DATABASE::"Salesperson/Purchaser";
            NumberArr[3] := SalesHeader."Salesperson Code";
            TableIDArr[4] := DATABASE::Campaign;
            NumberArr[4] := SalesHeader."Campaign No.";
            TableIDArr[5] := DATABASE::"Responsibility Center";
            NumberArr[5] := SalesHeader."Responsibility Center";
            if not DimMgt.CheckDimValuePosting(TableIDArr, NumberArr, SalesHeader."Dimension Set ID") then
                ERROR(
                  Text009,
                  SalesHeader."Document Type", SalesHeader."No.", DimMgt.GetDimValuePostingErr);
        end else begin
            TableIDArr[1] := DimMgt.TypeToTableID3(SalesLine.Type.AsInteger());
            NumberArr[1] := SalesLine."No.";
            TableIDArr[2] := DATABASE::Job;
            NumberArr[2] := SalesLine."Job No.";
            if not DimMgt.CheckDimValuePosting(TableIDArr, NumberArr, SalesLine."Dimension Set ID") then
                ERROR(
                  Text010,
                  SalesHeader."Document Type", SalesHeader."No.", SalesLine."Line No.", DimMgt.GetDimValuePostingErr);
        end;
    end;

    local procedure NS_RunGenJnlPostLine(var GenJnlLine: Record "Gen. Journal Line");
    begin
        GenJnlPostLine.RunWithCheck(GenJnlLine);
    end;

    local procedure NS_CreateDimensions(var SalesLine: Record "Sales Line");
    var
        SourceCodeSetup: Record "Source Code Setup";
        DimMgt: Codeunit DimensionManagement;
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        SourceCodeSetup.GET;
        TableID[1] := DATABASE::"G/L Account";
        No[1] := SalesLine."No.";
        TableID[2] := DATABASE::Job;
        No[2] := SalesLine."Job No.";
        TableID[3] := DATABASE::"Responsibility Center";
        No[3] := SalesLine."Responsibility Center";
        SalesLine."Shortcut Dimension 1 Code" := '';
        SalesLine."Shortcut Dimension 2 Code" := '';
        SalesLine."Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            TableID, No, SourceCodeSetup.Sales,
            SalesLine."Shortcut Dimension 1 Code", SalesLine."Shortcut Dimension 2 Code", SalesLine."Dimension Set ID", DATABASE::Customer);
    end;

    procedure NS_CreateInvoiceDimensions(var SalesInvoiceLine: Record "Sales Invoice Line");
    var
        SourceCodeSetup: Record "Source Code Setup";
        DimMgt: Codeunit DimensionManagement;
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        SourceCodeSetup.GET;
        TableID[1] := DATABASE::"G/L Account";
        No[1] := SalesInvoiceLine."No.";
        TableID[2] := DATABASE::Job;
        No[2] := SalesInvoiceLine."Job No.";
        TableID[3] := DATABASE::"Responsibility Center";
        No[3] := SalesInvoiceLine."Responsibility Center";
        SalesInvoiceLine."Shortcut Dimension 1 Code" := '';
        SalesInvoiceLine."Shortcut Dimension 2 Code" := '';
        SalesInvoiceLine."Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            TableID, No, SourceCodeSetup.Sales,
            SalesInvoiceLine."Shortcut Dimension 1 Code", SalesInvoiceLine."Shortcut Dimension 2 Code", SalesInvoiceLine."Dimension Set ID", DATABASE::Customer);
    end;

    procedure NS_CreateCrMemoDimensions(var SalesCrMemoLine: Record "Sales Cr.Memo Line");
    var
        SourceCodeSetup: Record "Source Code Setup";
        DimMgt: Codeunit DimensionManagement;
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        SourceCodeSetup.GET;
        TableID[1] := DATABASE::"G/L Account";
        No[1] := SalesCrMemoLine."No.";
        TableID[2] := DATABASE::Job;
        No[2] := SalesCrMemoLine."Job No.";
        TableID[3] := DATABASE::"Responsibility Center";
        No[3] := SalesCrMemoLine."Responsibility Center";
        SalesCrMemoLine."Shortcut Dimension 1 Code" := '';
        SalesCrMemoLine."Shortcut Dimension 2 Code" := '';
        SalesCrMemoLine."Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            TableID, No, SourceCodeSetup.Sales,
            SalesCrMemoLine."Shortcut Dimension 1 Code", SalesCrMemoLine."Shortcut Dimension 2 Code", SalesCrMemoLine."Dimension Set ID", DATABASE::Customer);
    end;

    local procedure NS_PrepmtDocTypeToDocType(DocumentType: Option Invoice,"Credit Memo"): Integer;
    begin
        case DocumentType of
            DocumentType::Invoice:
                exit(2);
            DocumentType::"Credit Memo":
                exit(3);
        end;
        exit(2);
    end;


    //PPDA.1.0 Start
    // procedure NS_GetSalesLinesToDeduct(SalesHeader: Record "Sales Header"; var SalesLines: Record "Sales Line");
    // var
    //     SalesLine: Record "Sales Line";
    // begin
    //     NS_ApplyFilter(SalesHeader, 1, SalesLine);
    //     if SalesLine.FINDSET then
    //         repeat
    //             if (NS_PrepmtAmount(SalesLine, 0, SalesHeader."Prepmt. Include Tax") <> 0) and
    //                (NS_PrepmtAmount(SalesLine, 1, SalesHeader."Prepmt. Include Tax") <> 0)
    //             then begin
    //                 SalesLines := SalesLine;
    //                 SalesLines.INSERT;
    //             end;
    //         until SalesLine.NEXT = 0;
    // end;
    //PPDA.1.0 End

    procedure NS_ValidatePaymentMethod(SalesHeader: Record "Sales Header");
    var
        PaymentMethod: Record "Payment Method";
    begin
        if SalesHeader."Payment Method Code" <> '' then begin
            if PaymentMethod.GET(SalesHeader."Payment Method Code") then begin
                //SPLN1.00 - Start
                //IF PaymentMethod."Payment Processor" = PaymentMethod."Payment Processor"::"1" THEN
                //  PaymentMethod.FIELDERROR("Payment Processor");
                //SPLN1.00 - End
            end;
        end;
    end;

    procedure NS_PrepmtVATDiffAmount(SalesLine: Record "Sales Line"; DocumentType: Option Invoice,"Credit Memo",Statistic): Decimal;
    begin
        with SalesLine do
            case DocumentType of
                DocumentType::Statistic:
                    exit("Prepayment VAT Difference");
                DocumentType::Invoice:
                    exit("Prepayment VAT Difference");
                else
                    exit("Prepmt VAT Diff. to Deduct");
            end;
    end;

    local procedure NS_UpdateSalesDocument(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; DocumentType: Option Invoice,"Credit Memo"; GenJnlLineDocNo: Code[20]);
    begin
        with SalesHeader do begin
            if DocumentType = DocumentType::Invoice then begin
                SalesHeader."Last Prepayment No." := GenJnlLineDocNo;
                SalesLine."Prepmt. Amt. Inv." := SalesLine."Prepmt. Line Amount";
                SalesLine."Prepmt. Amount Inv. Incl. VAT" := SalesLine."Prepmt. Amt. Incl. VAT";
                SalesLine."Prepmt VAT Diff. to Deduct" :=
                  SalesLine."Prepmt VAT Diff. to Deduct" + SalesLine."Prepayment VAT Difference";
                SalesLine."Prepayment VAT Difference" := 0;
            end else begin
                SalesHeader."Last Prepmt. Cr. Memo No." := GenJnlLineDocNo;
                SalesLine."Prepmt. Amt. Inv." := SalesLine."Prepmt Amt Deducted";
                if "Prices Including VAT" then
                    SalesLine."Prepmt. Amount Inv. Incl. VAT" := SalesLine."Prepmt. Amt. Inv."
                else
                    SalesLine."Prepmt. Amount Inv. Incl. VAT" :=
                      ROUND(
                        SalesLine."Prepmt. Amt. Inv." * (100 + SalesLine."Prepayment VAT %") / 100,
                        NS_GetCurrencyAmountRoundingPrecision(SalesLine."Currency Code"));
                SalesLine."Prepmt. Amt. Incl. VAT" := SalesLine."Prepmt. Amount Inv. Incl. VAT";
                SalesLine."Prepmt Amt to Deduct" := 0;
                SalesLine."Prepmt VAT Diff. to Deduct" := 0;
                SalesLine."Prepayment VAT Difference" := 0;
            end;
        end;
    end;

    local procedure NS_InsertSalesInvHeader(var SalesInvHeader: Record "Sales Invoice Header"; SalesHeader: Record "Sales Header"; PostingDescription: Text[50]; GenJnlLineDocNo: Code[20]; SrcCode: Code[10]; PostingNoSeriesCode: Code[10]);
    begin
        with SalesHeader do begin
            SalesInvHeader.INIT;
            SalesInvHeader.TRANSFERFIELDS(SalesHeader);
            PostingDescription := STRSUBSTNO(Text14021100, Job."No.");
            SalesInvHeader."Posting Description" := PostingDescription;
            SalesInvHeader."Payment Terms Code" := "Prepmt. Payment Terms Code";
            SalesInvHeader."Due Date" := "Prepayment Due Date";
            SalesInvHeader."Payment Discount %" := "Prepmt. Payment Discount %";
            SalesInvHeader."No." := GenJnlLineDocNo;
            SalesInvHeader."Pre-Assigned No. Series" := '';
            SalesInvHeader."Source Code" := SrcCode;
            SalesInvHeader."User ID" := USERID;
            SalesInvHeader."No. Printed" := 0;
            SalesInvHeader."Prepayment Invoice" := true;
            SalesInvHeader."Prepayment No. Series" := PostingNoSeriesCode;
            SalesInvHeader."Prepayment Order No." := Job."No.";
            SalesInvHeader."NS_Job No." := Job."No.";
            SalesInvHeader.INSERT;
        end;
    end;

    local procedure NS_InsertSalesCrMemoHeader(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; SalesHeader: Record "Sales Header"; PostingDescription: Text[50]; GenJnlLineDocNo: Code[20]; SrcCode: Code[10]; PostingNoSeriesCode: Code[10]; CalcPmtDiscOnCrMemos: Boolean);
    begin
        with SalesHeader do begin
            SalesCrMemoHeader.INIT;
            SalesCrMemoHeader.TRANSFERFIELDS(SalesHeader);
            SalesCrMemoHeader."Payment Terms Code" := "Prepmt. Payment Terms Code";
            SalesCrMemoHeader."Payment Discount %" := "Prepmt. Payment Discount %";
            if ("Prepmt. Payment Terms Code" <> '') and not CalcPmtDiscOnCrMemos then begin
                SalesCrMemoHeader."Payment Discount %" := 0;
                SalesCrMemoHeader."Pmt. Discount Date" := 0D;
            end;
            PostingDescription := STRSUBSTNO(Text14021101, Job."No.");
            SalesCrMemoHeader."Posting Description" := PostingDescription;
            SalesCrMemoHeader."Due Date" := "Prepayment Due Date";
            SalesCrMemoHeader."No." := GenJnlLineDocNo;
            SalesCrMemoHeader."Pre-Assigned No. Series" := '';
            SalesCrMemoHeader."Source Code" := SrcCode;
            SalesCrMemoHeader."User ID" := USERID;
            SalesCrMemoHeader."No. Printed" := 0;
            SalesCrMemoHeader."Prepayment Credit Memo" := true;
            SalesCrMemoHeader."Prepmt. Cr. Memo No. Series" := PostingNoSeriesCode;
            SalesCrMemoHeader."Prepayment Order No." := Job."No.";
            SalesCrMemoHeader.Correction := GLSetup."Mark Cr. Memos as Corrections";
            SalesCrMemoHeader."NS_Job No." := Job."No.";
            SalesCrMemoHeader."Shortcut Dimension 1 Code" := Job."Global Dimension 1 Code";
            SalesCrMemoHeader."Shortcut Dimension 2 Code" := Job."Global Dimension 2 Code";
            SalesCrMemoHeader.INSERT;
        end;
    end;

    local procedure NS_GetCalcPmtDiscOnCrMemos(PrepmtPmtTermsCode: Code[10]): Boolean;
    var
        PaymentTerms: Record "Payment Terms";
    begin
        if PrepmtPmtTermsCode = '' then
            exit(false);
        PaymentTerms.GET(PrepmtPmtTermsCode);
        exit(PaymentTerms."Calc. Pmt. Disc. on Cr. Memos");
    end;

    procedure NS_UpdateSalesTaxOnLines(var SalesLine: Record "Sales Line"; IncludeTax: Boolean; DocumentType: Option Invoice,"Credit Memo");
    begin
        /*
        WITH SalesHeader DO BEGIN
          SalesLine.RESET;
          SalesLine.SETRANGE("Document Type","Document Type");
          SalesLine.SETRANGE("Document No.","No.");
          IF DocumentType = DocumentType::Invoice THEN BEGIN
            "Last Prepayment No." := GenJnlLineDocNo;
            "Prepayment No." := '';
            SalesLine.SETFILTER("Prepmt. Line Amount",'<>0');
          IF FINDSET THEN
              REPEAT
                IF SalesLine."Prepmt. Line Amount" <> SalesLine."Prepmt. Amt. Inv." THEN BEGIN
                  SalesLine."Prepmt. Amt. Inv." := SalesLine."Prepmt. Line Amount";
                  SalesLine."Prepmt. Amount Inv. Incl. VAT" := SalesLine."Prepmt. Amt. Incl. VAT";
                  SalesLine.CalcPrepaymentToDeduct;
                  SalesLine."Prepmt VAT Diff. to Deduct" :=
                    SalesLine."Prepmt VAT Diff. to Deduct" + SalesLine."Prepayment VAT Difference";
                  SalesLine."Prepayment VAT Difference" := 0;
                  SalesLine.MODIFY;
        
                END;
              UNTIL SalesLine.NEXT = 0;
          END ELSE BEGIN
            "Last Prepmt. Cr. Memo No." := GenJnlLineDocNo;
            "Prepmt. Cr. Memo No." := '';
            SalesLine.SETFILTER("Prepmt. Amt. Inv.",'<>0');
            IF SalesLine.FINDSET(TRUE) THEN
              REPEAT
                SalesLine."Prepmt. Amt. Inv." := SalesLine."Prepmt Amt Deducted";
                SalesLine."Prepmt. Line Amount" := SalesLine."Prepmt. Amt. Inv.";
                IF "Prices Including VAT" THEN
                  SalesLine."Prepmt. Amount Inv. Incl. VAT" := SalesLine."Prepmt. Amt. Inv."
                ELSE
                  SalesLine."Prepmt. Amount Inv. Incl. VAT" :=
                    ROUND(
                      SalesLine."Prepmt. Amt. Inv." * (100 + SalesLine."Prepayment VAT %") / 100,
                      GetCurrencyAmountRoundingPrecision(SalesLine."Currency Code"));
                SalesLine."Prepmt. Amt. Incl. VAT" := SalesLine."Prepmt. Amount Inv. Incl. VAT";
                SalesLine."Prepmt Amt to Deduct" := 0;
                SalesLine."Prepmt VAT Diff. to Deduct" := 0;
                SalesLine."Prepayment VAT Difference" := 0;
                SalesLine.MODIFY;
              UNTIL SalesLine.NEXT = 0;
          END;
        END;
        */

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSetNewAmount(Var NewAmount: Decimal; DocumentType: Option Invoice,"Credit Memo",Statistic; SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetSalesLinesToDeduct(SalesHeader: Record "Sales Header"; Var SalesLines: Record "Sales Line")
    begin
    end;
}

