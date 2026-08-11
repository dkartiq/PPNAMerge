codeunit 14021112 "NS_Event Subscr. Codeunit 90"
{
    // version SPLN1.00

    // 2019-01-18 SPLN1.00 DMT Created
    //PRJ-52.SK.1.0 Added event for handling posting of resource
    //PRJ-168.SK.1.0 Added a function in this codeunit so that we can define indirect modify permission for a object.
    //PRJ-179.SK.1.0 Added code for creating JobLedgerEntry while posting resource
    //PRJ-196 VT 07-04-20 Code Added and Commmented
    //PRJ-205 VT 08-04-20 Code Added and Commented
    //PPAL-73.SK.1.0 - 28AUG2020 - Commented some code
    //PRJ-457.MS.1.0 add permission for post PO or PI
    //PRJ-372.MS.1.0 code comment due to wrong value changes
    //PRJ-884.JS.1.0 24Aug2021 | code added for retention to release documnet before posting
    Permissions = tabledata "Purch. Rcpt. Line" = imd, tabledata 169 = rimd; //PRJ-168.SK.1.0 Added//PRJ-457.MS.1.0

    trigger OnRun()
    begin
    end;

    var
        NS_GLSetup: Record "General Ledger Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        NS_JobsSetup: Record "Jobs Setup";
        p: Codeunit "NS_Parameters for Events";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeCheckExternalDocumentNumber', '', false, false)]
    local procedure NS_C90OnBeforeCheckExternalDocumentNumber(VendorLedgerEntry: Record "Vendor Ledger Entry"; PurchaseHeader: Record "Purchase Header"; var Handled: Boolean)
    var
        PurchaseAlreadyExistsErr: Label 'Purchase %1 %2 already exists for this vendor.', Comment = '%1 = Document Type, %2 = Document No.';
    begin

        PurchSetup.Get;
        if PurchSetup."NS_Purchase Retention Inactive" then
            VendorLedgerEntry.SetCurrentKey("External Document No.")
        else begin
            VendorLedgerEntry.SetCurrentKey("External Document No.", "Document Type", "Vendor No.");
            VendorLedgerEntry.SetRange("NS_Retention Ledger Code", p.NS_C90GetNS_GenJnlLineLedgerNo);
        end;

        VendorLedgerEntry.SetRange("Document Type", p.NS_C90GetGenJnlLineDocType);
        VendorLedgerEntry.SetRange("External Document No.", p.NS_C90GetGenJnlLineExtDocNo);
        VendorLedgerEntry.SetRange("Vendor No.", PurchaseHeader."Pay-to Vendor No.");
        VendorLedgerEntry.SetRange(Reversed, false);
        if VendorLedgerEntry.FindFirst then
            Error(
              PurchaseAlreadyExistsErr, VendorLedgerEntry."Document Type", p.NS_C90GetGenJnlLineExtDocNo);
        Handled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePostInvPostBuffer', '', false, false)]
    local procedure NS_C90OnBeforePostInvPostBuffer(var GenJnlLine: Record "Gen. Journal Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer"; var PurchHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; CommitIsSupressed: Boolean)
    var
        NS_JobTask: Record "Job Task";
    begin
        GenJnlLine."NS_Retention Ledger Code" := InvoicePostBuffer."NS_Retention Ledger Code";

        if (GenJnlLine."Job No." > '') and (GenJnlLine."Job Task No." > '') then
            if NS_JobTask.Get(GenJnlLine."Job No.", GenJnlLine."Job Task No.") then
                if NS_JobTask."NS_Burden Percent" > 0 then begin
                    NS_GLSetup.Get;
                    GenJnlLine."NS_Burden Amount" := Round(GenJnlLine.Amount * NS_JobTask."NS_Burden Percent", NS_GLSetup."Amount Rounding Precision");
                    GenJnlLine.Amount := GenJnlLine.Amount * GenJnlLine."NS_Burden Amount";
                end;
        GenJnlLine."NS_Draw No." := PurchHeader."NS_Draw No.";
        GenJnlLine."NS_Subcontract No." := PurchHeader."NS_Subcontract No.";
        if PurchHeader."NS_Retention Document" then
            Clear(GenJnlLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePurchRcptLineInsert', '', false, false)]
    local procedure NS_C90OnBeforePurchRcptLineInsert(var PurchRcptLine: Record "Purch. Rcpt. Line"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchLine: Record "Purchase Line"; CommitIsSupressed: Boolean)
    begin
        PurchRcptLine.NS_Staged := true;
        PurchRcptLine."NS_Staged Quantity" := PurchLine."Qty. to Receive";
    end;

    //PPDA.1.0 Start
    // //PPNA17.0 Opened Start OnPostProvincialSalesTaxToGLGenJnlLineAssign 
    // [EventSubscriber(ObjectType::Codeunit, 90, 'OnPostProvincialSalesTaxToGLOnAfterGenJnlLineAssignFields', '', false, false)]
    // local procedure NS_C90OnPostProvincialSalesTaxToGLGenJnlLineAssign(var GenJnlLine: Record "Gen. Journal Line"; PurchaseHeader: Record "Purchase Header")
    // begin
    //     GenJnlLine."NS_Draw No." := PurchaseHeader."NS_Draw No.";
    // end;
    // //PPNA17.0 Opened End
    //PPDA.1.0 End


    //PPDA.1.0 Start
    // //PPNA17.0 Opened Start OnPostSalesTaxToGenJnlLineAssign 
    // [EventSubscriber(ObjectType::Codeunit, 90, 'OnPostSalesTaxToGLOnAfterGenJnlLineAssignField', '', false, false)]
    // local procedure NS_C90OnPostSalesTaxToGenJnlLineAssign(var GenJnlLine: Record "Gen. Journal Line"; PurchHeader: Record "Purchase Header"; PurchLine: Record "Purchase Line")
    // begin
    //     GenJnlLine."NS_Draw No." := PurchHeader."NS_Draw No.";
    //     GenJnlLine."VAT Bus. Posting Group" := PurchLine."VAT Bus. Posting Group";
    //     GenJnlLine."VAT Prod. Posting Group" := PurchLine."VAT Prod. Posting Group";
    // end;
    //PPNA17.0 Opened End
    //PPDA.1.0 End


    //PPDA.1.0 Start
    //PPNA17.0 Opened Start OnAddSalesTaxLineToSalesTaxCalcVATBaseAmount 
    // [EventSubscriber(ObjectType::Codeunit, 90, 'OnAddSalesTaxLineToSalesTaxCalcOnBeforeOnBeforeTempPurchLineForSalesTaxInsert', '', false, false)]
    // local procedure NS_C90OnAddSalesTaxLineToSalesTaxCalcVATBaseAmount(var TempPurchLineForSalesTax: Record "Purchase Line"; PurchHeader: Record "Purchase Header")
    // var
    //     GLSetup: Record "General Ledger Setup"; //PRJ-196 VT 07-04-20 Code Added
    // begin
    //     with TempPurchLineForSalesTax do begin
    //         PurchSetup.Get;
    //         if not PurchSetup."NS_Purchase Retention Inactive" then begin
    //             NS_JobsSetup.Get;
    //             if NS_JobsSetup."NS_Calc Payable Ret Before Tax" and "NS_Retention Applies" then
    //                 // "VAT Base Amount" := Amount - (Amount * (PurchHeader."Retention Percent" / 100));//PRJ-196 VT 07-04-20 Code Commented 
    //                 GLSetup.Get;//PRJ-196 VT 07-04-20 Code Added
    //             "VAT Base Amount" := "VAT Base Amount" - Round("VAT Base Amount" * (PurchHeader."NS_Retention Percent" / 100), GLSetup."Amount Rounding Precision"); //PRJ-196 VT 07-04-20 Code Added
    //         end;
    //     end;
    // end;
    //PPNA17.0 Opened End
    //PPDA.1.0 End




    [EventSubscriber(ObjectType::Table, 81, 'OnAfterCopyGenJnlLineFromPurchHeader', '', false, false)]
    local procedure NS_T81OnAfterCopyGenJnlLineFromPurchHeader(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        with GenJournalLine do begin
            PurchSetup.Get;
            if not PurchSetup."NS_Purchase Retention Inactive" then begin
                Validate("NS_Retention Ledger Code", p.NS_C90GetNS_GenJnlLineLedgerNo);
                "NS_Retention Percent" := PurchaseHeader."NS_Retention Percent";
                //SPLN 1.00 Retention Amount assign valid for Balance Account posting too
                if PurchaseHeader."Document Type" = "Document Type"::"Credit Memo" then begin
                    "NS_Retention Amount" := PurchaseHeader."NS_Retention Amount";
                    "NS_Retention Amount (LCY)" := PurchaseHeader."NS_Retention Amount (LCY)";
                end else begin
                    "NS_Retention Amount" := -PurchaseHeader."NS_Retention Amount";
                    "NS_Retention Amount (LCY)" := -PurchaseHeader."NS_Retention Amount (LCY)";
                end;
                "NS_Retention Date" := PurchaseHeader."NS_Retention Date";
                NS_JobsSetup.Get;
                if NS_JobsSetup."NS_Calc Payable Ret Before Tax" then
                    "NS_Retention Base Amount" := PurchaseHeader."NS_Retention Base Before Tax"
                else
                    "NS_Retention Base Amount" := PurchaseHeader."NS_Retention Base Amount";

            end;
            "NS_Retention Document" := PurchaseHeader."NS_Retention Document";
            "Job No." := PurchaseHeader."NS_Job No.";
            "NS_Subcontract No." := PurchaseHeader."NS_Subcontract No.";
            "NS_Draw No." := PurchaseHeader."NS_Draw No.";
        end;
    end;


    //PPDA.1.0 Start
    // //PPNA17.0 Opened Start OnSumPurchLinesTempVATAmount 
    // [EventSubscriber(ObjectType::Codeunit, 90, 'OnSumPurchLinesTempOnAfterCalcVATAmount', '', false, false)]
    // local procedure NS_C90OnSumPurchLinesTempVATAmount(PurchHeader: Record "Purchase Header"; TotalPurchLine: Record "Purchase Line"; OldPurchLine: Record "Purchase Line"; var VATAmount: Decimal)
    // begin
    //     PurchSetup.Get;
    //     if not PurchSetup."NS_Purchase Retention Inactive" then begin
    //         NS_JobsSetup.Get;
    //         if NS_JobsSetup."NS_Calc Payable Ret Before Tax" and OldPurchLine."NS_Retention Applies" then
    //             VATAmount := TotalPurchLine."Amount Including VAT" - TotalPurchLine.Amount +
    //                          (TotalPurchLine.Amount * (PurchHeader."NS_Retention Percent" / 100));
    //     end;
    // end;
    //PPNA17.0 Opened End
    //PPDA.1.0 End


    //[EventSubscriber(ObjectType::Codeunit, 90, 'OnDivideAmountElseAssignVATBaseAmount', '', false, false)]
    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterDivideAmount', '', false, false)]
    local procedure NS_C90OnAfterDivideAmount(PurchHeader: Record "Purchase Header"; PurchLine: Record "Purchase Line")
    begin
        PurchLine."VAT Base Amount" := NS_AdjustVATBase(PurchHeader, PurchLine);
    end;

    //[EventSubscriber(ObjectType::Codeunit, 90, 'OnDivideAmountThenAssignVATBaseAmount', '', false, false)]
    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterDivideAmount', '', false, false)]
    local procedure NS_C90OnAfterDivideAmount1(PurchHeader: Record "Purchase Header"; PurchLine: Record "Purchase Line")
    begin
        PurchLine."VAT Base Amount" := NS_AdjustVATBase(PurchHeader, PurchLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterFillInvoicePostBuffer', '', false, false)]
    local procedure NS_C90OnAfterFillInvoicePostBuffer(var InvoicePostBuffer: Record "Invoice Post. Buffer"; PurchLine: Record "Purchase Line"; var TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary; CommitIsSupressed: Boolean)
    var
        Job: Record Job;
        PurchHeader: Record "Purchase Header";
        GenPostingSetup: Record "General Posting Setup";
        NS_VendPostingGr: Record "Vendor Posting Group";
    begin
        //Modify the InvPostingBuffer[1]."G/L Account" depending if this is a job related line --
        //   The change will happen if it is a time-and-materials job reguardless of the line type.
        //   The change will also happen if the job is NOT a time-and-materials job and this is NOT a G/L line type.
        //   -- So no` changes on regular jobs on G/L line types.
        //if PurchLine."Job No." > '' then begin //PRJ-571 comment start
        //    Job.Get(PurchLine."Job No.");
        //    if (not Job."NS_Time And Material") and (PurchLine.Type = PurchLine.Type::"G/L Account") then begin
        //        // Do Nothing  --  done for clarity of the IF above
        //    end else begin
        //        if PurchLine."Document Type" in [PurchLine."Document Type"::"Return Order", PurchLine."Document Type"::"Credit Memo"] then begin
        //            PurchHeader.Get(PurchLine."Document Type", PurchLine."Document No.");
        //            if PurchHeader."NS_Retention Document" then begin
        //                NS_VendPostingGr.Get(PurchHeader."Vendor Posting Group");
        //                NS_VendPostingGr.TestField("NS_Retention Payables Account");
        //                InvoicePostBuffer."G/L Account" := NS_VendPostingGr."NS_Retention Payables Account";
        //            end else begin
        //                GenPostingSetup.Get(PurchLine."Gen. Bus. Posting Group", PurchLine."Gen. Prod. Posting Group");
        //                GenPostingSetup.TestField("Purch. Credit Memo Account");
        //                InvoicePostBuffer."G/L Account" := GenPostingSetup."Purch. Credit Memo Account";
        //            end;
        //        end else begin
        //            PurchHeader.Get(PurchLine."Document Type", PurchLine."Document No.");
        //            if PurchHeader."NS_Retention Document" then begin
        //                NS_VendPostingGr.Get(PurchHeader."Vendor Posting Group");
        //                NS_VendPostingGr.TestField("NS_Retention Payables Account");
        //                InvoicePostBuffer."G/L Account" := NS_VendPostingGr."NS_Retention Payables Account";
        //            end else begin
        //                GenPostingSetup.Get(PurchLine."Gen. Bus. Posting Group", PurchLine."Gen. Prod. Posting Group");
        //                GenPostingSetup.TestField("Purch. Account");
        //                InvoicePostBuffer."G/L Account" := GenPostingSetup."Purch. Account";
        //            end;
        //        end;
        //   end;
        //end;//PRJ-571 comment end
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePurchCrMemoHeaderInsert', '', false, false)]
    local procedure NS_C90OnBeforePurchCrMemoHeaderInsert(var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var PurchHeader: Record "Purchase Header"; CommitIsSupressed: Boolean)
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        PurchSetup.Get;
        if not PurchSetup."NS_Purchase Retention Inactive" then begin
            PurchHeader.CalcFields("NS_Retention Base Amount", "NS_Retention Base Before Tax");
            PurchCrMemoHdr."NS_Retention Base Amount" := PurchHeader."NS_Retention Base Amount";
            PurchCrMemoHdr."NS_Retention Base Before Tax" := PurchHeader."NS_Retention Base Before Tax";
        end;

        if not PurchSetup."NS_Purchase Retention Inactive" then
            p.NS_C90SetNS_GenJnlLineLedgerNo(PurchSetup."NS_Normal Vendor Ledger No.");

        p.NS_C90SetGenJnlLineDocType(GenJnlLine."Document Type"::"Credit Memo".AsInteger());
        p.NS_C90SetGenJnlLineDocNo(PurchCrMemoHdr."No.");
        p.NS_C90SetGenJnlLineExtDocNo(PurchHeader."Vendor Cr. Memo No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePurchInvHeaderInsert', '', false, false)]
    local procedure NS_C90OnBeforePurchInvHeaderInsert(var PurchInvHeader: Record "Purch. Inv. Header"; var PurchHeader: Record "Purchase Header"; CommitIsSupressed: Boolean)
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        PurchSetup.Get;
        if not PurchSetup."NS_Purchase Retention Inactive" then begin
            PurchHeader.CalcFields("NS_Retention Base Amount", "NS_Retention Base Before Tax");
            PurchInvHeader."NS_Retention Base Amount" := PurchHeader."NS_Retention Base Amount";
            PurchInvHeader."NS_Retention Base Before Tax" := PurchHeader."NS_Retention Base Before Tax";
        end;

        if not PurchSetup."NS_Purchase Retention Inactive" then
            p.NS_C90SetNS_GenJnlLineLedgerNo(PurchSetup."NS_Normal Vendor Ledger No.");

        p.NS_C90SetGenJnlLineDocType(GenJnlLine."Document Type"::Invoice.AsInteger());
        p.NS_C90SetGenJnlLineDocNo(PurchInvHeader."No.");
        p.NS_C90SetGenJnlLineExtDocNo(PurchHeader."Vendor Invoice No.");
    end;

    //PRJ-52.SK.1.0 Start
    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePostResourceLine', '', false, false)]
    local procedure NS_C90OnBeforePostResourceLine(PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line"; var IsHandled: Boolean)
    var
        SourceCodeSetup: Record "Source Code Setup";
    begin
        with PurchaseLine do begin
            SourceCodeSetup.Get();
            case Type of
                PurchaseLine.Type::Resource:
                    begin
                        NS_PostResourceLine(PurchaseHeader, PurchaseLine, SourceCodeSetup.Purchases);
                    end;
            end;
        end;
        IsHandled := true;
    end;
    //PRJ-52.SK.1.0 Start

    //PRJ-182.SK.1.0 Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnPostPurchLineOnAfterSetEverythingInvoiced', '', false, false)]
    local procedure NS_C90OnPostPurchLineOnAfterSetEverythingInvoiced(PurchaseLine: Record "Purchase Line")
    begin
        p.NS_SetPurchLineTypeC90(PurchaseLine); //PRJ-182.SK.1.0 Added
    end;
    //PRJ-182.SK.1.0 End


    //PPNA17.0 Opened Start OnPostPurchLineAfterCase
    //PRJ-Need to open in version 19-Start 
    // [EventSubscriber(ObjectType::Codeunit, codeunit::"Purch.-Post", 'OnPostPurchLineOnAfterPostByType', '', false, false)]
    // local procedure NS_C90OnPostPurchLineBeforeCase(PurchHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    // var
    //     SourceCodeSetup: Record "Source Code Setup";
    //     PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
    // begin
    //     with PurchLine do begin
    //         SourceCodeSetup.Get();
    //         case Type of
    //             //PRJ-52.SK.1.0 STart
    //             // PurchaseLine.Type::Resource:
    //             //     begin
    //             //         NS_PostResourceLine(PurchHeader, PurchaseLine, PurchInvHeader, PurchCrMemoHeader, SourceCodeSetup.Purchases);
    //             //         p.NS_C90SetPostPurchLine_Type(Type);
    //             //         Type := Type::" ";
    //             //     end;
    //             //PRJ-52.SK.1.0 End
    //             PurchLine.Type::NS_Ledger:
    //                 NS_PostLedger(PurchHeader, PurchLine, SourceCodeSetup.Purchases, GenJnlPostLine);//PRJ-205 VT 08-04-20 Added GenJnlPostLine Parameter
    //         end;
    //     end;
    // end;
    // //PPNA17.0 Opened End
    //PRJ-Need to open in version 19-Start 


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterCheckPurchDoc', '', false, false)]
    local procedure NS_C90OnAfterCheckPurchDoc(var PurchHeader: Record "Purchase Header"; CommitIsSupressed: Boolean; WhseShip: Boolean; WhseReceive: Boolean)
    var
        NS_Text14021100: Label 'There must be a value in the Purchases and Payables Setup, Normal Ledger No. to identify the name of the normal ledger for payables.';
        NS_Text14021101: Label 'There must be a value in the Jobs Setup, Retention Payable Ledger to identify the name of the rentention ledger for payables.';
    begin
        PurchSetup.Get;
        if not PurchSetup."NS_Purchase Retention Inactive" then begin
            if PurchSetup."NS_Normal Vendor Ledger No." = '' then
                Error(NS_Text14021100);
            NS_JobsSetup.Get;
            if NS_JobsSetup."NS_Retention Payable Ledger" = '' then
                Error(NS_Text14021101);
        end;
    end;

    local procedure NS_PostResourceLine(PurchHeader: Record "Purchase Header"; PurchLine: Record "Purchase Line"; SrcCode: Code[10])
    var
        NS_ResJnlLine: Record "Res. Journal Line";
        C90: Codeunit "Purch.-Post";
        NS_ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        JobPostLine: Codeunit "Job Post-Line";
        JobPurchLine: Record "Purchase Line";
        //PRJ-52.SK.1.0 Start
        ParameterForEvents: Codeunit "NS_Parameters for Events";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
    //PRJ-52.SK.1.0 End

    begin
        //Project Pro Start
        if PurchLine."Qty. to Invoice" <> 0 then begin
            with PurchHeader do begin
                NS_ResJnlLine.Init;
                NS_ResJnlLine."Posting Date" := "Posting Date";
                NS_ResJnlLine."Document Date" := "Document Date";
                NS_ResJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                NS_ResJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                NS_ResJnlLine."NS_Retention Ledger Code" := "NS_Retention Ledger Code";
                NS_ResJnlLine."Dimension Set ID" := "Dimension Set ID";
                NS_ResJnlLine."Reason Code" := "Reason Code";
                NS_ResJnlLine."Resource No." := PurchLine."No.";
                NS_ResJnlLine.Description := PurchLine.Description;
                NS_ResJnlLine."Work Type Code" := PurchLine."NS_Work Type Code";
                NS_ResJnlLine."Job No." := PurchLine."Job No.";
                NS_ResJnlLine."Unit of Measure Code" := PurchLine."Unit of Measure Code";
                NS_ResJnlLine."Gen. Bus. Posting Group" := PurchLine."Gen. Bus. Posting Group";
                NS_ResJnlLine."Gen. Prod. Posting Group" := PurchLine."Gen. Prod. Posting Group";
                NS_ResJnlLine."Entry Type" := NS_ResJnlLine."Entry Type"::Usage;
                NS_ResJnlLine."Document No." := p.NS_C90GetGenJnlLineDocNo;
                NS_ResJnlLine."External Document No." := p.NS_C90GetGenJnlLineExtDocNo;
                NS_ResJnlLine.Quantity := PurchLine."Qty. to Invoice";
                NS_ResJnlLine."Direct Unit Cost" := PurchLine."Direct Unit Cost";
                NS_ResJnlLine."Unit Cost" := PurchLine."Unit Cost (LCY)";
                NS_ResJnlLine."Unit Price" := PurchLine."Unit Price (LCY)";
                NS_ResJnlLine."Total Cost" := Round(PurchLine."Unit Cost (LCY)" * NS_ResJnlLine.Quantity);
                NS_ResJnlLine."Total Price" := Round(PurchLine."Unit Price (LCY)" * NS_ResJnlLine.Quantity);
                NS_ResJnlLine."Source Code" := SrcCode;
                NS_ResJnlPostLine.Run(NS_ResJnlLine);
                if PurchLine."Job No." <> '' then begin
                    Clear(JobPostLine);
                    C90.CreateJobPurchLine(JobPurchLine, PurchLine, "Prices Including VAT");
                    //PRJ-52.SK.1.0 Start
                    ParameterForEvents.NS_C90GetPurchInvHeader(PurchInvHeader);
                    ParameterForEvents.NS_C90GetPurchCrMemoHeader(PurchCrMemoHeader);
                    //PRJ-52.SK.1.0 End

                    //PPAL-73.SK.1.0 Comment start
                    //PRJ-179.SK.1.0 Start
                    // IF JobPurchLine.Type = JobPurchLine.Type::Resource then begin
                    //     JobPurchLine.Type := JobPurchLine.Type::Item;
                    // end;
                    //PRJ-179.SK.1.0 End
                    //PPAL-73.SK.1.0 Comment End

                    JobPostLine.PostJobOnPurchaseLine(PurchHeader, PurchInvHeader, PurchCrMemoHeader, JobPurchLine, SrcCode);
                end;
            end;
        end;
        //Project Pro End
    end;

    //PRJ-52.SK.1.0 Start
    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterInsertPostedHeaders', '', false, false)]
    local procedure NS_C90SetPostedHeaders(var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var ReturnShptHeader: Record "Return Shipment Header")
    var
        ParametersForEvents: Codeunit "NS_Parameters for Events";
    begin
        ParametersForEvents.NS_C90SetPurchInvHeader(PurchInvHeader);
        ParametersForEvents.NS_C90SetPurchCrMemoHeader(PurchCrMemoHdr);
    end;
    //PRJ-52.SK.1.0 End


    local procedure NS_PostLedger(PurchHeader: Record "Purchase Header"; PurchLine: Record "Purchase Line"; SrcCode: Code[10]; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")//PRJ-205 VT 08-04-20 Added GenJnlPostLine Param
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        //ProjectPro - start
        if PurchLine.Amount <> 0 then begin
            with PurchHeader do begin
                GenJnlLine.Init;
                GenJnlLine."Posting Date" := "Posting Date";
                GenJnlLine."Document Date" := "Document Date";
                GenJnlLine.Description := PurchLine.Description;
                GenJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                //GenJnlLine."Retention Ledger Code" := "Retention Ledger Code";//PRJ-205 VT 09-04-20 Commented
                GenJnlLine."NS_Retention Ledger Code" := PurchLine."No.";//PRJ-205 VT 09-04-20 Added
                GenJnlLine."Dimension Set ID" := "Dimension Set ID";
                GenJnlLine."Reason Code" := "Reason Code";
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
                GenJnlLine."Account No." := "Buy-from Vendor No.";
                GenJnlLine."Document Type" := p.NS_C90GetGenJnlLineDocType;
                GenJnlLine."Document No." := p.NS_C90GetGenJnlLineDocNo;
                GenJnlLine."External Document No." := p.NS_C90GetGenJnlLineExtDocNo;
                GenJnlLine."Currency Code" := "Currency Code";
                GenJnlLine.Amount := PurchLine.Amount;
                GenJnlLine."Source Currency Code" := "Currency Code";
                GenJnlLine."Source Currency Amount" := PurchLine.Amount;
                GenJnlLine."Amount (LCY)" := PurchLine.Amount;
                if PurchHeader."Currency Code" = '' then
                    GenJnlLine."Currency Factor" := 1
                else
                    GenJnlLine."Currency Factor" := PurchHeader."Currency Factor";
                GenJnlLine.Correction := Correction;
                GenJnlLine."Sales/Purch. (LCY)" := PurchLine.Amount;
                GenJnlLine."Profit (LCY)" := (PurchLine.Amount - PurchLine."Unit Cost");
                GenJnlLine."Inv. Discount (LCY)" := PurchLine."Inv. Discount Amount";
                GenJnlLine."Bill-to/Pay-to No." := "Buy-from Vendor No.";
                GenJnlLine."Salespers./Purch. Code" := "Purchaser Code";
                GenJnlLine."On Hold" := "On Hold";
                GenJnlLine."Applies-to Doc. Type" := "Applies-to Doc. Type";
                GenJnlLine."Applies-to Doc. No." := "Applies-to Doc. No.";
                GenJnlLine."Applies-to ID" := "Applies-to ID";
                GenJnlLine."Allow Application" := "Bal. Account No." = '';
                GenJnlLine."Due Date" := "Due Date";
                GenJnlLine."Payment Terms Code" := "Payment Terms Code";
                GenJnlLine."Pmt. Discount Date" := "Pmt. Discount Date";
                GenJnlLine."Payment Discount %" := "Payment Discount %";
                GenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
                GenJnlLine."Source No." := "Buy-from Vendor No.";
                GenJnlLine."Source Code" := SrcCode;
                GenJnlLine."Posting No. Series" := "Posting No. Series";
                GenJnlLine."NS_Retention Document" := "NS_Retention Document";
                GenJnlLine."Job No." := "NS_Job No.";
                GenJnlLine."NS_Subcontract No." := "NS_Subcontract No.";
                GenJnlLine."NS_Draw No." := "NS_Draw No.";
                GenJnlPostLine.RunWithCheck(GenJnlLine);
            end;
        end;
        //ProjectPro - end
    end;

    procedure NS_AdjustVATBase(PassPurchHeader: Record "Purchase Header"; PassPurchLine: Record "Purchase Line"): Decimal
    var
        NS_GLSetup: Record "General Ledger Setup";
        NS_JobsSetup: Record "Jobs Setup";
    begin
        if PassPurchHeader."NS_Retention Percent" = 0 then
            exit;
        if NS_JobsSetup.Get then begin
            NS_GLSetup.Get; //SPLN1.00
            if NS_JobsSetup."NS_A/P RetentionTaxCalcMethod" = NS_JobsSetup."NS_A/P RetentionTaxCalcMethod"::"3 - Calc tax on purchase less the retention amount" then
                exit(PassPurchLine."VAT Base Amount" - Round(PassPurchLine."VAT Base Amount" * (PassPurchHeader."NS_Retention Percent" / 100), NS_GLSetup."Amount Rounding Precision"));
        end;
    end;

    //PRJ-168.SK.1.0 Start
    // PROCEDURE NS_PostPurchaseReturn(PurchaseRet: Record 38); //PRJ-372 code comment start
    // VAR
    //     PurchLine: Record 39;
    //     PurchRcptLine: Record 121;
    //     JobMatPlan: Record "NS_Job Material Planning";
    // BEGIN
    //     //ProjectPro - start add
    //     WITH PurchaseRet DO BEGIN
    //         PurchLine.SETRANGE("Document Type", "Document Type");
    //         PurchLine.SETRANGE("Document No.", "No.");
    //         PurchLine.SETRANGE(Type, PurchLine.Type::Item);
    //         IF PurchLine.FINDSET(FALSE, FALSE) THEN BEGIN
    //             PurchRcptLine.SETCURRENTKEY("Job No.", "Job Task No.", "No.", NS_Staged);
    //             PurchRcptLine.SETRANGE("Job No.", PurchLine."Job No.");
    //             PurchRcptLine.SETRANGE("Job Task No.", PurchLine."Job Task No.");
    //             PurchRcptLine.SETRANGE(Type, PurchRcptLine.Type::Item);
    //             PurchRcptLine.SETRANGE("No.", PurchLine."No.");
    //             PurchRcptLine.SETRANGE(NS_Staged, TRUE);
    //             IF PurchRcptLine.FINDFIRST THEN BEGIN
    //                 PurchRcptLine."NS_Staged Quantity" -= PurchLine."Return Qty. to Ship";
    //                 PurchRcptLine.Quantity -= PurchLine."Return Qty. to Ship";
    //                 PurchRcptLine.MODIFY;
    //             END;
    //         END;
    //     END;
    //     //ProjectPro - end add
    // END; //PRJ-372 code comment end
    //PRJ-168.SK.1.0 End
    //PRJ-372.MS.1.0 Start
    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforeReturnShptLineInsert', '', false, false)]
    local procedure NS_C90OnBeforeReturnShptLineInsert(VAR ReturnShptLine: Record "Return Shipment Line"; VAR ReturnShptHeader: Record "Return Shipment Header"; VAR PurchLine: Record "Purchase Line"; CommitIsSupressed: Boolean)
    begin
        ReturnShptLine."NS_JMP Document No." := PurchLine."NS_JMP Document No.";
    end;
    //PRJ-372.MS.1.0 End

    //PRJ-516.MS.1.0 start
    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure NS_C90OnBeforePostPurchaseDoc(VAR PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean; VAR HideProgressWindow: Boolean)
    var
        PurhLine: Record "Purchase Line";
        Licdate: date;
        NoOfDays: Text;
        EnvInfoCU: Codeunit "Environment Information";//PRJ-516
    begin
        //PRJ-884.JS.1.0 24Aug2021-Start
        IF ((PurchaseHeader."NS_Retention Percent" <> 0) and (PurchaseHeader.Status = PurchaseHeader.Status::Open)) then
            IF PurchaseHeader."NS_Subcontract No." = '' then
                Error('To calculate Retention, Status must be equal to Released on Purchase Header: Document Type = %1, Document No.= %2. Current value is %3.', PurchaseHeader."Document Type",
                PurchaseHeader."No.", PurchaseHeader.Status)
            else
                Error('To calculate Retention, Status must be equal to Released on Subcontract Purchase Header: Document Type = %1, Document No.= %2. Current value is %3.', PurchaseHeader."Document Type",
                PurchaseHeader."No.", PurchaseHeader.Status);
        //PRJ-884.JS.1.0 24Aug2021-end        
        if EnvInfoCU.IsSaaS() then begin
            PurhLine.Reset();
            PurhLine.SetRange("Document No.", PurchaseHeader."No.");
            PurhLine.SetFilter(Quantity, '<>%1', 0);
            if PurhLine.FindFirst() then begin
                if (PurhLine."NS_Subcontract No." <> '') or (PurhLine."NS_Segment Code" <> '') or (PurhLine."NS_JMP Document No." <> '')
                    or (PurhLine."NS_Job Cost Category" <> '') then begin
                    //Licdate := DMY2Date(31, 3, 2021);//PRJ-516.AS.1.0 16MARCH2021 Comment
                    // Licdate := DMY2Date(31, 5, 2021);//PRJ-516.AS.1.0 16MARCH2021 Added Change date
                    // EVALUATE(NoOfDays, FORMAT(Licdate - WorkDate));
                    // if (WorkDate > (Licdate - 6)) and (WorkDate <= Licdate) then
                    //     Message('Your free trial is going to expire in %1 days.Please contact your administrator.', NoOfDays);
                    // if WorkDate > Licdate then
                    //     Error('Your free trial has expired.Please contact your administrator.');
                    OnCheckPPLicenseExpire();
                end;

            end;
        end;
    end;
    //PRJ-516.MS.1.0 end


    [IntegrationEvent(false, false)]
    local procedure OnCheckPPLicenseExpire()
    begin
    end;
}

