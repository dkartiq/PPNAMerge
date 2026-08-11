codeunit 14021114 "NS_Event Subscr. Codeunit 12"
{
    // version SPLN1.00
    //PRJ-70.TY.1.0 Added code or avoiding wrong application.
    //PRJ-137.SK.1.0 Added code for passing "Original Currency Factor" and "Adjusted Currency Factor" 
    //PRJ-177.SK.1.0 Added permissons for objects that are modifying by this codeunit
    //Test comment
    //TM-10.AM.1.0 | added code to flow Segment Code.
    //PRJ-1143.JS.1.0 19JAN2022 | block code to flow additional currency amount issue for G/L inconsistency
    Permissions = tabledata "Vendor Ledger Entry" = rimd, tabledata "Cust. Ledger Entry" = rimd, tabledata "Job Ledger Entry" = rimd;
    ; //PRJ-177.SK.1.0 Added  //CTSI-254.AS.1.0 Added Job ledger entry permission

    //PRJ-1143.JS.1.0 18JAN2022 | Block code related to Add currency issue
    //PRJ-1203.JS.1.0 22FEB2022 | Correct Code for Retention Documents
    //PRJ-1194.NK.1.0 29Apr2022 | Add Code
    //PRJCTPR-224.VC.1.0 16Nov2023 | Sale Invoice with Foreign Currency
    //PRJCTPR-260.HS.1.0 8Jan2024 | Added Procedure To True the IsHandled boolean
    trigger OnRun()
    begin
    end;

    var
        NS_JobsSetup: Record "Jobs Setup";
        NS_SalesSetup: Record "Sales & Receivables Setup";
        NS_PurchSetup: Record "Purchases & Payables Setup";
        p: Codeunit "NS_Parameters for Events";

    //PPNA17.0 Opened Start OnCreateGLEntryForTotalAmountsInsertGLEntry
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnCreateGLEntryForTotalAmountsOnBeforeInsertGLEntry', '', false, false)]
    local procedure NS_C12OnCreateGLEntryForTotalAmountsInsertGLEntry(var GLEntry: Record "G/L Entry"; GenJnlLine: Record "Gen. Journal Line"; var isHandled: Boolean)
    begin
        GLEntry."NS_Bal. Ledger No." := GenJnlLine."NS_Bal. Ledger No.";

        //ProjectPro - start
        //InsertGLEntry(GenJnlLine,GLEntry,TRUE);
        NS_SalesSetup.Get;
        if not NS_SalesSetup."NS_Sales Retention Inactive" then begin
            if (GenJnlLine."NS_Retention Ledger Code" = NS_JobsSetup."NS_Retention Receivable Ledger") and
               (GenJnlLine."NS_Retention Amount" <> 0) then
                isHandled := true;
        end;
        //ProjectPro - end
    end;
    //PPNA17.0 Opened End

    //PPNA17.0 Opened  Start OnUpdateCalcInterestBeforeFind 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnUpdateCalcInterestOnAfterCustLedgEntrySetFilters', '', false, false)]
    local procedure NS_C12OnUpdateCalcInterestBeforeFind(var CustLedgEntry: Record "Cust. Ledger Entry"; CVLedgEntryBuf: Record "CV Ledger Entry Buffer")
    begin
        CustLedgEntry.SetRange("NS_Retention Ledger Code", CVLedgEntryBuf."NS_Retention Ledger Code");
    end;
    //PPNA17.0 Opened  End

    //PPNA17.0 Opened Start OnPostDtldVendLedgEntriesCreateGLEntriesForTotalAmounts 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostDtldVendLedgEntriesOnBeforeCreateGLEntriesForTotalAmounts', '', false, false)]
    local procedure NS_C12OnPostDtldVendLedgEntriesCreateGLEntriesForTotalAmounts(var VendPostingGr: Record "Vendor Posting Group"; DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer")
    begin
        //ProjectPro - start
        //CreateGLEntriesForTotalAmounts(
        //  GenJnlLine,TempInvPostBuf,AdjAmount,SaveEntryNo,VendPostingGr.GetPayablesAccount,LedgEntryInserted);

        NS_PurchSetup.Get;
        if not NS_PurchSetup."NS_Purchase Retention Inactive" then begin
            if (DtldCVLedgEntryBuf."NS_Retention Ledger Code" <> NS_PurchSetup."NS_Normal Vendor Ledger No.") and
               (DtldCVLedgEntryBuf."NS_Retention Ledger Code" <> '') then begin
                VendPostingGr.TestField("NS_Retention Payables Account");
                VendPostingGr."Payables Account" := VendPostingGr."NS_Retention Payables Account";
            end;
        end;
    end;
    //     //ProjectPro - end
    // end;
    //PPNA17.0 Opened End

    //PPNA16.0 Modified Event start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPrepareTempVendLedgEntryOnAfterSetFilters', '', false, false)]
    local procedure NS_C12OnPrepareTempVendLedgEntryPositiveCheck(CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; GenJournalLine: Record "Gen. Journal Line"; var OldVendorLedgerEntry: Record "Vendor Ledger Entry")
    Var

        NewCVLedgEntryBuf: Record "CV Ledger Entry Buffer";
    begin
        //ProjectPro - start
        //PRJ-1157.NK.1.0  24JAN2022 - start
        //OldVendLedgEntry.TESTFIELD(Positive,NOT NewCVLedgEntryBuf.Positive)
        // IF NewCVLedgEntryBuf.get(CVLedgerEntryBuffer."Entry No.") then begin
        //     NS_PurchSetup.Get;
        //     if not NS_PurchSetup."NS_Purchase Retention Inactive" then begin
        //         OldVendorLedgerEntry.SetRange("NS_Retention Ledger Code", NewCVLedgEntryBuf."NS_Retention Ledger Code");
        //         if not OldVendorLedgerEntry.FindFirst then begin
        //             OldVendorLedgerEntry.SetRange("NS_Retention Ledger Code", GenJournalLine."NS_Retention Ledger Code");
        //             OldVendorLedgerEntry.FindFirst;
        //             //Probably OldVendLedgEntry.Positive value will not pass following testfield statement.
        //             //In this case need to play like C12OnPrepareTempCustLedgEntryPositiveCheck
        //         end;
        //     end;
        // end;
        NS_PurchSetup.Get;
        if not NS_PurchSetup."NS_Purchase Retention Inactive" then
            OldVendorLedgerEntry.SetRange("NS_Retention Ledger Code", GenJournalLine."NS_Retention Ledger Code");
        //PRJ-1157.NK.1.0  24JAN2022 - end
        //ProjectPro - end
    end;
    //PPNA16.0 Modified Event End

    //PPNA17.0 Opened Start OnPostDtldCustLedgEntriesCreateGLEntriesForTotalAmounts
    //PE-59.GK.1.0 14Mar2023 start
    //[EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostDtldCustLedgEntriesOnBeforeCreateGLEntriesForTotalAmounts', '', false, false)]
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostDtldCustLedgEntriesOnBeforeCreateGLEntriesForTotalAmountsV19', '', false, false)]
    //PE-59.GK.1.0 14Mar2023 end
    local procedure NS_C12OnPostDtldCustLedgEntriesCreateGLEntriesForTotalAmounts(var CustPostingGr: Record "Customer Posting Group"; DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer")
    begin
        //ProjectPro - start
        NS_SalesSetup.Get;
        if not NS_SalesSetup."NS_Sales Retention Inactive" then begin
            if (DtldCVLedgEntryBuf."NS_Retention Ledger Code" <> NS_SalesSetup."NS_Normal Customer Ledger No.") and
               (DtldCVLedgEntryBuf."NS_Retention Ledger Code" <> '') then begin
                CustPostingGr.TestField("NS_RetentionReceivablesAccount");
                CustPostingGr."Receivables Account" := CustPostingGr."NS_RetentionReceivablesAccount";
            end;
        end;
    end;
    //     //ProjectPro - end
    // end;
    //PPNA17.0 Opened End


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPrepareTempCustLedgEntryOnBeforeTempOldCustLedgEntryInsert', '', false, false)]
    local procedure NS_C12OnPrepareTempCustLedgEntryOnBeforeTempOldCustLedgEntryInsert(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        IF CustLedgerEntry."Document Type" <> CustLedgerEntry."Document Type"::Invoice Then begin //PRJ-70.TY.1.0 added
            p.NS_C12SetNewCVLedgEntryBufPositive(CustLedgerEntry.Positive);//PRJ-1566.AS.1.0 22AUG2022
            CustLedgerEntry.Positive := p.NS_C12GetNewCVLedgEntryBufPositive();
        end;

    end;

    //PPNA16.0 Modified Event Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPrepareTempCustLedgEntryOnAfterSetFilters', '', false, false)]
    local procedure NS_C12OnPrepareTempCustLedgEntryPositiveCheck(var OldCustLedgerEntry: Record "Cust. Ledger Entry"; CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; GenJournalLine: Record "Gen. Journal Line")
    var
        NewCVLedgEntryBuf: Record "CV Ledger Entry Buffer";
    begin
        //IF NewCVLedgEntryBuf.GET(CVLedgerEntryBuffer) then begin//PRJ-609 N.S.1.0
        IF NewCVLedgEntryBuf.GET(CVLedgerEntryBuffer."Entry No.") then begin //PRJ-609 N.S.1.0
            p.NS_C12SetNewCVLedgEntryBufPositive(NewCVLedgEntryBuf.Positive);

            //ProjectPro - start
            //OldCustLedgEntry.TESTFIELD(Positive,NOT NewCVLedgEntryBuf.Positive);
            NS_SalesSetup.Get;
            if not NS_SalesSetup."NS_Sales Retention Inactive" then begin
                OldCustLedgerEntry.SetRange("NS_Retention Ledger Code", NewCVLedgEntryBuf."NS_Retention Ledger Code");
                if not OldCustLedgerEntry.FindFirst then begin
                    OldCustLedgerEntry.SetRange("NS_Retention Ledger Code", GenJournalLine."NS_Retention Ledger Code");
                    OldCustLedgerEntry.FindFirst;
                end;
                NS_JobsSetup.Get;
                if GenJournalLine."NS_Retention Document" and
                    (((GenJournalLine."NS_Retention Ledger Code" = NS_JobsSetup."NS_Retention Receivable Ledger") and
                      (GenJournalLine."Document Type" = GenJournalLine."Document Type"::Invoice)) or
                    ((GenJournalLine."NS_Retention Ledger Code" = NS_JobsSetup."NS_Retention Payable Ledger") and
                      (GenJournalLine."Document Type" = GenJournalLine."Document Type"::"Credit Memo"))) then
                    NewCVLedgEntryBuf.Positive := not NewCVLedgEntryBuf.Positive;
                NewCVLedgEntryBuf.Modify();
            end;
        end;
        //ProjectPro - end
    end;
    //PPNA16.0 Modified Event End

    //PPNA17.0 Opened Start OnPostVendAfterPostDtldEntries 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterVendLedgEntryInsert', '', false, false)]
    local procedure NS_C12OnPostVendAfterPostDtldEntries(GenJournalLine: Record "Gen. Journal Line"; var VendorLedgerEntry: Record "Vendor Ledger Entry"; var DtldLedgEntryInserted: Boolean)
    begin
        with GenJournalLine do begin
            NS_PurchSetup.Get;
            NS_JobsSetup.Get;
            //ProjectPro - start
            //Link back to retention ledger entry
            if not NS_PurchSetup."NS_Purchase Retention Inactive" then begin
                if p.NS_C12GetNS_RetentionLinkedEntryNo2 > 0 then begin
                    if "NS_Retention Ledger Code" = NS_PurchSetup."NS_Normal Vendor Ledger No." then begin
                        p.NS_C12SetNS_RetentionLinkedEntryNo(0);
                        p.NS_C12SetNS_MainLinkedEntryNo(VendorLedgerEntry."Entry No.");
                        //Backfill retention entries with main entry no.
                        VendorLedgerEntry.Reset;
                        VendorLedgerEntry.SetFilter("NS_Retention Ledger Code", NS_JobsSetup."NS_Retention Payable Ledger");
                        VendorLedgerEntry.SetFilter("NS_Ledger No. Link", 'XXMultiple');
                        VendorLedgerEntry.SetFilter("NS_Entry No. Link", Format(p.NS_C12GetNextTransactionNo));
                        if VendorLedgerEntry.FindSet then
                            repeat
                                VendorLedgerEntry."NS_Ledger No. Link" := NS_PurchSetup."NS_Normal Vendor Ledger No.";
                                VendorLedgerEntry."NS_Entry No. Link" := p.NS_C12GetNS_MainLinkedEntryNo;
                                VendorLedgerEntry.Modify;
                                if p.NS_C12GetNS_RetentionLinkedEntryNo = 0 then
                                    //keep track of the first related entry no.
                                    p.NS_C12SetNS_RetentionLinkedEntryNo(VendorLedgerEntry."Entry No.");
                            until VendorLedgerEntry.Next = 0;

                        //Fill in main entry with first related retention entry no.
                        VendorLedgerEntry.Get(p.NS_C12GetNS_MainLinkedEntryNo);
                        VendorLedgerEntry."NS_Ledger No. Link" := NS_JobsSetup."NS_Retention Payable Ledger";
                        VendorLedgerEntry."NS_Entry No. Link" := p.NS_C12GetNS_RetentionLinkedEntryNo;
                        VendorLedgerEntry.Modify;
                        p.NS_C12SetNS_RetentionLinkedEntryNo2(0);
                    end
                end else
                    if p.NS_C12GetNS_RetentionLinkedEntryNo > 0 then begin
                        p.NS_C12SetNS_MainLinkedEntryNo(VendorLedgerEntry."Entry No.");
                        VendorLedgerEntry.Get(p.NS_C12GetNS_RetentionLinkedEntryNo);
                        VendorLedgerEntry."NS_Ledger No. Link" := NS_PurchSetup."NS_Normal Vendor Ledger No.";
                        VendorLedgerEntry."NS_Entry No. Link" := p.NS_C12GetNS_MainLinkedEntryNo;
                        VendorLedgerEntry.Modify;
                    end;
            end;
            //ProjectPro - end
        end;

        if GenJournalLine."NS_Retention Document" and DtldLedgEntryInserted then
            DtldLedgEntryInserted := false; //to prevent execute: DtldVendLedgEntry.SetZeroTransNo(NextTransactionNo)
    end;
    //PPNA17.0 Opened End

    //PPNA16.0 Modified Event Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeVendLedgEntryInsert', '', false, false)]
    local procedure NS_C12OnPostVendVendLedgEntryInsert(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        with GenJournalLine do begin
            NS_PurchSetup.Get;
            NS_JobsSetup.Get;
            //ProjectPro - start
            if not NS_PurchSetup."NS_Purchase Retention Inactive" then
                if "NS_Retention Document" and (VendorLedgerEntry."Document Type" = "Document Type"::"Credit Memo") and
                   (VendorLedgerEntry."NS_Retention Ledger Code" = NS_JobsSetup."NS_Retention Payable Ledger") then begin
                    VendorLedgerEntry."Inv. Discount (LCY)" := -VendorLedgerEntry."Inv. Discount (LCY)";
                    VendorLedgerEntry."Original Pmt. Disc. Possible" := -VendorLedgerEntry."Original Pmt. Disc. Possible";
                    VendorLedgerEntry."Remaining Pmt. Disc. Possible" := -VendorLedgerEntry."Remaining Pmt. Disc. Possible";
                end;
            //ProjectPro - end
        end;
    end;
    //PPNA16.0 Modified Event End

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitVendLedgEntry', '', false, false)]
    local procedure NS_C12OnAfterInitVendLedgEntry(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        with GenJournalLine do begin
            NS_PurchSetup.Get;
            NS_JobsSetup.Get;
            //ProjectPro - start
            VendorLedgerEntry."NS_Retention Ledger Code" := "NS_Retention Ledger Code";
            VendorLedgerEntry."NS_Bal. Ledger No." := "NS_Bal. Ledger No.";
            if not NS_PurchSetup."NS_Purchase Retention Inactive" then begin
                VendorLedgerEntry."NS_Retention Percent" := "NS_Retention Percent";
                VendorLedgerEntry."NS_Retention Amount" := "NS_Retention Amount";
                VendorLedgerEntry."NS_Retention Amount (LCY)" := "NS_Retention Amount (LCY)";
                VendorLedgerEntry."NS_Retention Date" := "NS_Retention Date";
                VendorLedgerEntry."NS_Retention Base Amount" := "NS_Retention Base Amount";
                if p.NS_C12GetNS_RetentionLinkedEntryNo = 0 then begin
                    if "NS_Retention Ledger Code" = NS_JobsSetup."NS_Retention Payable Ledger" then begin
                        p.NS_C12SetNS_RetentionLinkedEntryNo2(VendorLedgerEntry."Entry No.");
                        VendorLedgerEntry."NS_Ledger No. Link" := 'XXMultiple';
                        VendorLedgerEntry."NS_Entry No. Link" := p.NS_C12GetNextTransactionNo;
                    end else begin
                        VendorLedgerEntry."NS_Ledger No. Link" := '';
                        VendorLedgerEntry."NS_Entry No. Link" := 0;
                    end
                end else begin
                    VendorLedgerEntry."NS_Ledger No. Link" := NS_JobsSetup."NS_Retention Payable Ledger";
                    VendorLedgerEntry."NS_Entry No. Link" := p.NS_C12GetNS_RetentionLinkedEntryNo;
                end;
            end;
            VendorLedgerEntry."NS_Job No." := "Job No.";
            VendorLedgerEntry."NS_Subcontract No." := "NS_Subcontract No.";
            if "NS_Print Lien Release" > 0 then
                VendorLedgerEntry."NS_Lien Release Print Status" := VendorLedgerEntry."NS_Lien Release Print Status"::Requested;
            VendorLedgerEntry."NS_Lien Release Type" := "NS_Print Lien Release";
            VendorLedgerEntry."NS_Draw No." := "NS_Draw No.";
            VendorLedgerEntry."NS_Retention Document" := "NS_Retention Document"; //PRJ-1194.NK.1.0 29Apr2022 
            //ProjectPro - end
        end;
    end;

    //PPNA17.0 Opened Start OnBeforePostVend 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostVendOnBeforeInitVendLedgEntry', '', false, false)]
    local procedure NS_C12OnBeforePostVend(sender: Codeunit "Gen. Jnl.-Post Line"; var GenJournalLine: Record "Gen. Journal Line"; var VendLedgEntry: Record "Vendor Ledger Entry"; var VendPostingGr: Record "Vendor Posting Group"; var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer")
    var
        NS_SourceCodeSetup: Record "Source Code Setup";
    begin
        with GenJournalLine do begin
            //ProjectPro - start
            NS_PurchSetup.Get;
            NS_SourceCodeSetup.Get;
            if "Source Code" <> NS_SourceCodeSetup."Payment Journal" then
                // Sender.NS_PostVendJob(GenJnlLine, VendLedgEntry, CVLedgEntryBuf, TempDtldCVLedgEntryBuf, VendPostingGr);
                NS_PostVendJob(Sender, GenJournalLine, VendLedgEntry, CVLedgerEntryBuffer, DtldCVLedgEntryBuffer, VendPostingGr);
            //ProjectPro - end
        end;
        p.NS_C12SetNextTransactionNo(Sender.GetNextTransactionNo);
    end;
    //PPNA17.0 Opened End

    //PPNA16.0 Modified Event Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterCustLedgEntryInsert', '', false, false)]
    local procedure NS_C12OnPostCustAfterPostDtldEntries(DtldLedgEntryInserted: Boolean; GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        NS_ClosedByCLE: Record "Cust. Ledger Entry";
        NS_Draw: Record NS_Draw;
        NS_VendLedgEntry: Record "Vendor Ledger Entry";
        NSSalesRecSetup: Record "Sales & Receivables Setup";  //PE-302.JS.1.0 15July2024
    begin
        with GenJournalLine do begin
            NS_SalesSetup.Get;
            NS_JobsSetup.Get;
            //ProjectPro - start
            //Link back to retention ledger entry
            if not NS_SalesSetup."NS_Sales Retention Inactive" then begin
                if p.NS_C12GetNS_RetentionLinkedEntryNo2 > 0 then begin
                    if "NS_Retention Ledger Code" = NS_SalesSetup."NS_Normal Customer Ledger No." then begin
                        p.NS_C12SetNS_RetentionLinkedEntryNo(0);
                        p.NS_C12SetNS_MainLinkedEntryNo(CustLedgerEntry."Entry No.");
                        //Backfill retention entries with main entry no.
                        CustLedgerEntry.Reset;
                        CustLedgerEntry.SetFilter("NS_Retention Ledger Code", NS_JobsSetup."NS_Retention Receivable Ledger");
                        CustLedgerEntry.SetFilter("NS_Ledger No. Link", 'XXMultiple');
                        CustLedgerEntry.SetFilter("NS_Entry No. Link", Format(p.NS_C12GetNextTransactionNo));
                        if CustLedgerEntry.FindSet then
                            repeat
                                CustLedgerEntry."NS_Ledger No. Link" := NS_SalesSetup."NS_Normal Customer Ledger No.";
                                CustLedgerEntry."NS_Entry No. Link" := p.NS_C12GetNS_MainLinkedEntryNo;
                                CustLedgerEntry.Modify;
                                if p.NS_C12GetNS_RetentionLinkedEntryNo = 0 then
                                    //keep track of the first related entry no.
                                    p.NS_C12SetNS_RetentionLinkedEntryNo(CustLedgerEntry."Entry No.");
                            until CustLedgerEntry.Next = 0;

                        //Fill in main entry with first related retention entry no.
                        CustLedgerEntry.Get(p.NS_C12GetNS_MainLinkedEntryNo);
                        CustLedgerEntry."NS_Ledger No. Link" := NS_JobsSetup."NS_Retention Receivable Ledger";
                        CustLedgerEntry."NS_Entry No. Link" := p.NS_C12GetNS_RetentionLinkedEntryNo;
                        CustLedgerEntry.Modify;
                        p.NS_C12SetNS_RetentionLinkedEntryNo2(0);
                    end
                end else
                    if p.NS_C12GetNS_RetentionLinkedEntryNo > 0 then begin
                        p.NS_C12SetNS_MainLinkedEntryNo(CustLedgerEntry."Entry No.");
                        CustLedgerEntry.Get(p.NS_C12GetNS_RetentionLinkedEntryNo);
                        CustLedgerEntry."NS_Ledger No. Link" := NS_SalesSetup."NS_Normal Customer Ledger No.";
                        CustLedgerEntry."NS_Entry No. Link" := p.NS_C12GetNS_MainLinkedEntryNo;
                        CustLedgerEntry.Modify;
                    end;
            end;
            NS_ClosedByCLE.Reset;
            NS_ClosedByCLE.SetCurrentKey("Closed by Entry No.");
            NS_ClosedByCLE.SetRange("Closed by Entry No.", CustLedgerEntry."Entry No.");
            if NS_ClosedByCLE.FindSet then
                repeat
                    if not NS_ClosedByCLE.Open then begin
                        NS_Draw.Reset;
                        NS_Draw.SetCurrentKey("NS_Sales Document Type", "NS_Sales Document No.");
                        case NS_ClosedByCLE."Document Type" of
                            NS_ClosedByCLE."Document Type"::Invoice:
                                NS_Draw.SetRange("NS_Sales Document Type", NS_Draw."NS_Sales Document Type"::Invoice);
                            NS_ClosedByCLE."Document Type"::"Credit Memo":
                                NS_Draw.SetRange("NS_Sales Document Type", NS_Draw."NS_Sales Document Type"::"Credit Memo");
                        end;
                        NS_Draw.SetRange("NS_Sales Document No.", NS_ClosedByCLE."Document No.");
                        if NS_Draw.FindFirst then begin
                            NS_VendLedgEntry.Reset;
                            NS_VendLedgEntry.SetCurrentKey("NS_Draw No.");
                            NS_VendLedgEntry.SetRange("NS_Draw No.", NS_Draw."NS_No.");
                            if NS_VendLedgEntry.FindSet(true) then
                                repeat
                                    NS_VendLedgEntry."Due Date" := CalcDate('<+' + Format(NS_JobsSetup."NS_Draw Default Payment Terms") + '>', CustLedgerEntry."Posting Date");
                                    NS_VendLedgEntry.Modify
                                until NS_VendLedgEntry.Next = 0;
                        end;
                    end;
                until NS_ClosedByCLE.Next = 0;
            //ProjectPro - end
            //PE-302.JS.1.0 15July20024-Start
            if NSSalesRecSetup.get() then begin
                if NSSalesRecSetup."NS_AutoApplySCM After Posting" = true then begin
                    if GenJournalLine."Document Type" = GenJournalLine."Document Type"::"Credit Memo" then begin
                        CustLedgerEntry."NS_AppliesToDocument Type" := GenJournalLine."NS_AppliesToDocument Type";
                        CustLedgerEntry."NS_AppliesToDocument No." := GenJournalLine."NS_AppliesToDocument No.";
                    end;
                end;
            end;
            //PE-302.JS.1.0 15July20024-end

            if GenJournalLine."NS_Retention Document" and DtldLedgEntryInserted then
                DtldLedgEntryInserted := false; //to prevent execute: DtldCustLedgEntry.SetZeroTransNo(NextTransactionNo)
        end;
    end;
    //PPNA16.0 Modified Event End

    //PPNA16.0 Modified evnt Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeCustLedgEntryInsert', '', false, false)]
    local procedure NS_C12OnPostCustCustLedgEntryInsert(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        with GenJournalLine do begin
            NS_SalesSetup.Get;
            NS_JobsSetup.Get;
            if not NS_SalesSetup."NS_Sales Retention Inactive" then
                if "NS_Retention Document" and (CustLedgerEntry."Document Type" = "Document Type"::"Credit Memo") and
                   (CustLedgerEntry."NS_Retention Ledger Code" = NS_JobsSetup."NS_Retention Receivable Ledger") then begin
                    CustLedgerEntry."Sales (LCY)" := -CustLedgerEntry."Sales (LCY)";
                    CustLedgerEntry."Profit (LCY)" := -CustLedgerEntry."Profit (LCY)";
                    CustLedgerEntry."Inv. Discount (LCY)" := -CustLedgerEntry."Inv. Discount (LCY)";
                    CustLedgerEntry."Original Pmt. Disc. Possible" := -CustLedgerEntry."Original Pmt. Disc. Possible";
                    CustLedgerEntry."Pmt. Disc. Given (LCY)" := -CustLedgerEntry."Pmt. Disc. Given (LCY)";
                    CustLedgerEntry.Positive := not CustLedgerEntry.Positive;
                    CustLedgerEntry."Remaining Pmt. Disc. Possible" := -CustLedgerEntry."Remaining Pmt. Disc. Possible";
                    //PE-302.JS.1.0 15July2024-Start
                    if ((GenJournalLine."Document Type" = GenJournalLine."Document Type"::"Credit Memo") and
                        (GenJournalLine."NS_Retention Percent" <> 0)) then begin
                        CustLedgerEntry."NS_AppliesToDocument Type" := GenJournalLine."NS_AppliesToDocument Type";
                        CustLedgerEntry."NS_AppliesToDocument No." := GenJournalLine."NS_AppliesToDocument No.";
                    end;
                    //PE-302.JS.1.0 15July2024-end
                end;
        end;
    end;
    //PPNA16.0 Modified evnt End

    [EventSubscriber(ObjectType::Table, 383, 'OnAfterCopyFromGenJnlLine', '', false, false)]
    local procedure NS_T383OnAfterCopyFromGenJnlLine(var DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; GenJnlLine: Record "Gen. Journal Line")
    var
        NS_TempAmount: Decimal;
        NS_TempAmountLCY: Decimal;
        NS_Currency: Record Currency;  //PRJ-1203.JS.1.0 21FEB2022
        IsHandled: Boolean; //FGH-163.SM.14052024  //PRJCTPR-371.JS.1.0
    begin
        //FGH-163.SM.14052024 START  //PRJCTPR-371.JS.1.0
        OnBeforeNS_T383OnAfterCopyFromGenJnlLine(DtldCVLedgEntryBuffer, GenJnlLine, IsHandled);
        if IsHandled then
            exit;
        //FGH-163.SM.14052024 END  //PRJCTPR-371.JS.1.0
        with GenJnlLine do begin
            if "Account Type" = "Account Type"::Vendor then begin
                DtldCVLedgEntryBuffer."NS_Retention Ledger Code" := "NS_Retention Ledger Code";
                DtldCVLedgEntryBuffer.Amount := Amount - "NS_Retention Amount";
                DtldCVLedgEntryBuffer."Amount (LCY)" := "Amount (LCY)" - "NS_Retention Amount (LCY)";
                DtldCVLedgEntryBuffer."NS_Job No." := "Job No.";
                DtldCVLedgEntryBuffer."NS_Subcontract No." := "NS_Subcontract No.";
            end;

            if "Account Type" = "Account Type"::Customer then begin
                NS_SalesSetup.Get;
                NS_JobsSetup.Get;
                if not NS_SalesSetup."NS_Sales Retention Inactive" then begin
                    if "NS_Retention Document" and ("Document Type" = "Document Type"::"Credit Memo") and
                       ("NS_Retention Ledger Code" = NS_JobsSetup."NS_Retention Receivable Ledger") then begin
                        NS_TempAmount := -Amount;
                        NS_TempAmountLCY := -"Amount (LCY)";
                    end else begin
                        NS_TempAmount := Amount;
                        NS_TempAmountLCY := "Amount (LCY)";
                    end;
                    DtldCVLedgEntryBuffer.Amount := NS_TempAmount - "NS_Retention Amount";
                    DtldCVLedgEntryBuffer."Amount (LCY)" := NS_TempAmountLCY - "NS_Retention Amount (LCY)";
                    //PRJ-1203.JS.1.0 21FEB2022-Start
                    if ((GenJnlLine."NS_Retention Document" = true) And (GenJnlLine."Currency Code" <> '') and
                    (GenJnlLine."Document Type" = GenJnlLine."Document Type"::Invoice) and (GenJnlLine."NS_Retention Ledger Code" = 'RETENTION')) then
                        if GenJnlLine."Currency Factor" <> 0 then begin
                            NS_Currency.GET(GenJnlLine."Currency Code");
                            DtldCVLedgEntryBuffer.Amount := ROUND((GenJnlLine.Amount * GenJnlLine."Currency Factor"), NS_Currency."Amount Rounding Precision");
                        end;
                    //PRJ-1203.JS.1.0 21FEB2022-end 
                end;
                DtldCVLedgEntryBuffer."NS_Job No." := "Job No.";
                DtldCVLedgEntryBuffer."NS_Subcontract No." := "NS_Subcontract No.";
                DtldCVLedgEntryBuffer."NS_Retention Ledger Code" := "NS_Retention Ledger Code";
            end;
            //DtldCVLedgEntryBuffer."Additional-Currency Amount" := 0;   //PRJ-1143.JS.1.0 18JAN2022
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitCustLedgEntry', '', false, false)]
    local procedure NS_C12OnAfterInitCustLedgEntry(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    //PRJCTPR-242.PS.1.0 08Dec2023 Start Commented 
    //PRJCTPR-214.VC.1.0 Start
    var
    //  NS_CLE: Record "Cust. Ledger Entry";
    //PRJCTPR-214.VC.1.0 End
    //PRJCTPR-242.PS.1.0 08Dec2023 End Commented
    begin
        with GenJournalLine do begin
            //ProjectPro - start
            NS_SalesSetup.Get;
            NS_JobsSetup.Get;
            CustLedgerEntry."NS_Retention Ledger Code" := "NS_Retention Ledger Code";
            CustLedgerEntry."NS_Bal. Ledger No." := "NS_Bal. Ledger No.";
            if not NS_SalesSetup."NS_Sales Retention Inactive" then begin
                CustLedgerEntry."NS_Retention Percent" := "NS_Retention Percent";
                CustLedgerEntry."NS_Retention Amount" := "NS_Retention Amount";
                CustLedgerEntry."NS_Retention Amount (LCY)" := "NS_Retention Amount (LCY)";
                CustLedgerEntry."NS_Retention Date" := "NS_Retention Date";
                CustLedgerEntry."NS_Retention Base Amount" := "NS_Retention Base Amount";
                CustLedgerEntry."NS_Retention Document" := "NS_Retention Document";
                //PRJ-1044.GK.2.0 16Dec2021 start
                if CustLedgerEntry."NS_Retention Document" = true then begin
                    CustLedgerEntry."Sales (LCY)" := 0;
                    CustLedgerEntry."NS_Retention Base Amount" := 0
                end;
                //PRJ-1044.GK.2.0 16Dec2021 end
                if p.NS_C12GetNS_RetentionLinkedEntryNo = 0 then
                    if ("NS_Retention Ledger Code" = NS_JobsSetup."NS_Retention Receivable Ledger") and
                       ("NS_Retention Amount" <> 0) then begin
                        p.NS_C12SetNS_RetentionLinkedEntryNo2(CustLedgerEntry."Entry No.");
                        CustLedgerEntry."NS_Ledger No. Link" := 'XXMultiple';
                        CustLedgerEntry."NS_Entry No. Link" := p.NS_C12GetNextTransactionNo;
                    end else begin
                        CustLedgerEntry."NS_Ledger No. Link" := '';
                        CustLedgerEntry."NS_Entry No. Link" := 0;
                    end
                else begin
                    CustLedgerEntry."NS_Ledger No. Link" := NS_JobsSetup."NS_Retention Receivable Ledger";
                    CustLedgerEntry."NS_Entry No. Link" := p.NS_C12GetNS_RetentionLinkedEntryNo;
                end;
            end;
        end;
        CustLedgerEntry."NS_Job No." := GenJournalLine."Job No.";
        //PE-302.JS.1.0 12July2024-Start
        if ((GenJournalLine."Document Type" = GenJournalLine."Document Type"::"Credit Memo") and
            (GenJournalLine."NS_Retention Percent" <> 0)) then begin
            CustLedgerEntry."NS_AppliesToDocument No." := GenJournalLine."NS_AppliesToDocument No.";
            CustLedgerEntry."NS_AppliesToDocument Type" := GenJournalLine."NS_AppliesToDocument Type";
        end;
        //PE-302.JS.1.0 12July2024-end
        //PRJCTPR-242.PS.1.0 08Dec2023 Start Commented 
        //PRJCTPR-214.VC.1.0 Start
        // If NS_CLE.Get(CustLedgerEntry."NS_Entry No. Link") and (NS_CLE."NS_Retention Ledger Code" = 'RETENTION') then begin
        //     NS_CLE.CalcFields("Remaining Amount");
        //     If (NS_CLE."Remaining Amount" <> 0) then
        //         NS_CLE.Open := true
        //     else
        //         NS_CLE.Open := false;
        //     NS_CLE.Modify();
        // end;
        // //PRJCTPR-214.VC.1.0 End
        //PRJCTPR-242.PS.1.0 08Dec2023 End Commented
        CustLedgerEntry."NS_Draw No." := GenJournalLine."NS_Draw No.";//PE-200.AS.1.0 24SEPT2023 ADD
    end;


    //PPNA17.0 Opened Start OnBeforePostCust

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostCustOnBeforeInitCustLedgEntry', '', false, false)]
    local procedure NS_C12OnBeforePostCust(var Sender: Codeunit "Gen. Jnl.-Post Line"; var GenJournalLine: Record "Gen. Journal Line"; var CustLedgEntry: Record "Cust. Ledger Entry"; var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var CustPostingGr: Record "Customer Posting Group")
    begin
        NS_PostCustJob(Sender, GenJournalLine, CustLedgEntry, CVLedgerEntryBuffer, DtldCVLedgEntryBuffer, CustPostingGr);
        p.NS_C12SetNextTransactionNo(Sender.GetNextTransactionNo);
    end;
    //PPNA17.0 Opened End


    //PPNA17.0 Opened Start OnCodeAfterJobLine 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterFindJobLineSign', '', false, false)]
    local procedure C12OnCodeAfterJobLine(GenJnlLine: Record "Gen. Journal Line"; var IsJobLine: Boolean)
    begin
        with GenJnlLine do begin
            //ProjectPro - start done
            //JobLine := ("Job No." <> '');
            NS_JobsSetup.Get;
            IsJobLine := ("Job No." <> '') and ("Journal Batch Name" <> NS_JobsSetup."NS_Received Accrual Batch Name") and
                       ("Journal Batch Name" <> NS_JobsSetup."NS_Labor to Job Batch Name");
            //ProjectPro - end
        end;
    end;
    //PPNA17.0 Opened End

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostGLAccOnBeforeInsertGLEntry', '', false, false)]
    local procedure NS_C12OnPostGLAccOnBeforeInsertGLEntry(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; var IsHandled: Boolean)
    begin
        GLEntry."NS_Bal. Ledger No." := GenJournalLine."NS_Bal. Ledger No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitGLEntry', '', false, false)]
    local procedure C12OnAfterInitGLEntry(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        NS_SalesInvoiceHeader: Record "Sales Invoice Header";
        NS_PurchInvoiceHeader: Record "Purch. Inv. Header";
        NS_CustPostingGr: Record "Customer Posting Group";
        NS_VendPostingGr: Record "Vendor Posting Group";
        JLE: Record "Job Ledger Entry";//CTSI-254.AS.1.0
        Jobsetup: Record "Jobs Setup";//CTSI-254.AS.1.0
    begin
        if NS_CustPostingGr.Get(GenJournalLine."Posting Group") then
            if GenJournalLine."Account Type" = GenJournalLine."Account Type"::Customer then
                if GenJournalLine."Document Type" = GenJournalLine."Document Type"::Invoice then
                    if (GLEntry."G/L Account No." = NS_CustPostingGr."Receivables Account") or
                       (GLEntry."G/L Account No." = NS_CustPostingGr."NS_RetentionReceivablesAccount") then
                        if NS_SalesInvoiceHeader.Get(GLEntry."Document No.") then begin
                            GLEntry."NS_Retention Ledger Code" := NS_SalesInvoiceHeader."NS_Retention Ledger Code";
                            GLEntry."Dimension Set ID" := NS_SalesInvoiceHeader."Dimension Set ID";
                        end;
        if NS_VendPostingGr.Get(GenJournalLine."Posting Group") then
            if GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor then
                if GenJournalLine."Document Type" = GenJournalLine."Document Type"::Invoice then
                    if (GLEntry."G/L Account No." = NS_VendPostingGr."Payables Account") or
                       (GLEntry."G/L Account No." = NS_VendPostingGr."NS_Retention Payables Account") then
                        if NS_PurchInvoiceHeader.Get(GLEntry."Document No.") then begin
                            GLEntry."NS_Retention Ledger Code" := NS_PurchInvoiceHeader."NS_Retention Ledger Code";
                            GLEntry."Dimension Set ID" := NS_PurchInvoiceHeader."Dimension Set ID";
                        end;
        GLEntry."NS_Prepayment for Job No." := GenJournalLine."NS_Prepayment for Job No.";

        //CTSI-254.AS.1.0 - start`
        if Jobsetup.get then;
        if Jobsetup."NS_Advanced Burden Allocation" = true then begin
            if Jobsetup."NS_Burden G/L Journal Batch" <> '' then begin
                if (Jobsetup."NS_Burden G/L Journal Batch" = GenJournalLine."Journal Batch Name") then begin
                    JLE.Reset();
                    JLE.SetRange("Job No.", GLEntry."Job No.");
                    JLE.SetRange("NS_Burden Export", true);
                    JLE.SetFilter("NS_Burden Amount", '<>%1', 0);
                    JLE.SetFilter("NS_Burden Amount Posted to G/L", '%1', 0);
                    if JLE.FindSet() then
                        repeat
                            JLE."NS_Burden Amount Posted to G/L" := JLE."NS_Burden Amount";
                            JLE."NS_Burden Posting Document No." := GenJournalLine."Document No.";
                            JLE."NS_Burden Export" := false;
                            JLE.MODIFY;
                        until JLE.Next() = 0;
                    //CTSI-254.AS.1.0 - end
                end;
            end;
        end;

    end;

    //PPNA16.0 Modified Event Start
    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyPostingGroupsFromDtldCVBuf', '', false, false)]
    local procedure NS_C12OnBeforeCreateGLEntryVATCollectAdjInsertGLEntry(DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer"; var GLEntry: Record "G/L Entry")
    var
        //NS_DimMgt: Codeunit DimensionManagement;//AM
        NS_DimMgt: Codeunit 408;//AM

    begin
        //ProjectPro - start
        NS_SalesSetup.Get;
        if not NS_SalesSetup."NS_Sales Retention Inactive" then begin
            GLEntry."Global Dimension 2 Code" := DtldCVLedgEntryBuf."Initial Entry Global Dim. 2";
            GLEntry."NS_Retention Ledger Code" := DtldCVLedgEntryBuf."NS_Retention Ledger Code";
            NS_DimMgt.ValidateShortcutDimValues(1, GLEntry."Global Dimension 1 Code", GLEntry."Dimension Set ID");
            NS_DimMgt.ValidateShortcutDimValues(2, GLEntry."Global Dimension 2 Code", GLEntry."Dimension Set ID");
        end;
        //ProjectPro - end
    end;
    //PPNA16.0 Modified Event End

    //PPNA16.0 Modified Event Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeCalcCurrencyUnrealizedGainLoss', '', false, false)]
    local procedure NS_C12OnAfterCalcCurrencyUnrealizedGainLossUnRealizedGainLossLCY(GenJnlLine: Record "Gen. Journal Line"; CVLedgEntryBuf: Record "CV Ledger Entry Buffer"; AppliedAmount: Decimal; RemainingAmountBeforeAppln: Decimal; var TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer"; var IsHandled: Boolean)
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        UnRealizedGainLossLCY: Decimal;
    begin

        IF (CVLedgEntryBuf."Currency Code" = '') OR (RemainingAmountBeforeAppln = 0) THEN
            EXIT;

        // Calculate Unrealized GainLoss
        IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer THEN
            UnRealizedGainLossLCY :=
              ROUND(
                DtldCustLedgEntry.GetUnrealizedGainLossAmount(CVLedgEntryBuf."Entry No.") *
                ABS(AppliedAmount / RemainingAmountBeforeAppln))
        ELSE
            UnRealizedGainLossLCY :=
              ROUND(
                DtldVendLedgEntry.GetUnrealizedGainLossAmount(CVLedgEntryBuf."Entry No.") *
                ABS(AppliedAmount / RemainingAmountBeforeAppln));

        // Calculate Unrealized GainLoss
        if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer then
            UnRealizedGainLossLCY :=
              //Round(CustGetUnrealizedGainLossAmount(CVLedgEntryBuf."Entry No.",CVLedgEntryBuf."Retention Ledger Code") *
              Round(DtldCustLedgEntry.NS_GetUnrealizedGainLossAmount(CVLedgEntryBuf."Entry No.", CVLedgEntryBuf."NS_Retention Ledger Code") *
              Abs(AppliedAmount / RemainingAmountBeforeAppln))

        else
            UnRealizedGainLossLCY :=
              //Round(VendorGetUnrealizedGainLossAmount(CVLedgEntryBuf."Entry No.",CVLedgEntryBuf."Retention Ledger Code") *
              Round(DtldVendLedgEntry.NS_GetUnrealizedGainLossAmount(CVLedgEntryBuf."Entry No.", CVLedgEntryBuf."NS_Retention Ledger Code") *
              Abs(AppliedAmount / RemainingAmountBeforeAppln));

        IF UnRealizedGainLossLCY <> 0 THEN
            IF UnRealizedGainLossLCY < 0 THEN
                //TempDtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(//PRJ-1620.AS.1.0 COMMENTED As per V21 Validations not allowing it
                    TempDtldCVLedgEntryBuf.InitDetailedCVLedgEntryBuf(//PRJ-1620.AS.1.0 Added/Replace As per V21 Validations
                  GenJnlLine, CVLedgEntryBuf, TempDtldCVLedgEntryBuf,
                  TempDtldCVLedgEntryBuf."Entry Type"::"Unrealized Loss", 0, -UnRealizedGainLossLCY, 0, 0, 0, 0)
            ELSE
                // TempDtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(//PRJ-1620.AS.1.0 COMMENTED As per V21 Validations not allowing it
                    TempDtldCVLedgEntryBuf.InitDetailedCVLedgEntryBuf(//PRJ-1620.AS.1.0 Added/Replace As per V21 Validations
                  GenJnlLine, CVLedgEntryBuf, TempDtldCVLedgEntryBuf,
                  TempDtldCVLedgEntryBuf."Entry Type"::"Unrealized Gain", 0, -UnRealizedGainLossLCY, 0, 0, 0, 0);

        IsHandled := true;
    end;
    //PPNA16.0 Modified Event End

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeCheckPurchExtDocNo', '', false, false)]
    local procedure NS_C12OnBeforeCheckPurchExtDocNo(GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Vendor Ledger Entry"; CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var Handled: Boolean)
    var
        PurchSetup: Record "Purchases & Payables Setup";
        OldVendLedgEntry: Record "Vendor Ledger Entry";
        PurchaseAlreadyExistsErr: Label 'Purchase %1 %2 already exists for this vendor.', Comment = '%1 = Document Type; %2 = Document No.';
    begin
        PurchSetup.Get;
        if not (PurchSetup."Ext. Doc. No. Mandatory" or (GenJournalLine."External Document No." <> '')) then
            exit;

        GenJournalLine.TestField("External Document No.");
        OldVendLedgEntry.Reset;
        OldVendLedgEntry.SetRange("External Document No.", GenJournalLine."External Document No.");
        OldVendLedgEntry.SetRange("Document Type", GenJournalLine."Document Type");
        OldVendLedgEntry.SetRange("Vendor No.", GenJournalLine."Account No.");
        OldVendLedgEntry.SetRange(Reversed, false);
        //ProjectPro - start
        OldVendLedgEntry.SetRange("NS_Retention Ledger Code", CVLedgerEntryBuffer."NS_Retention Ledger Code");
        //ProjectPro - end

        if not OldVendLedgEntry.IsEmpty then
            Error(
              PurchaseAlreadyExistsErr,
              GenJournalLine."Document Type", GenJournalLine."External Document No.");

        Handled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeCode', '', false, false)]
    LOCAL procedure NS_C12OnBeforeCode(VAR GenJnlLine: Record "Gen. Journal Line"; CheckLine: Boolean; VAR IsPosted: Boolean; VAR GLReg: Record "G/L Register")
    begin
        p.NS_C12SetNS_OrigGenJnlLine(GenJnlLine);
    end;

    procedure NS_PostVendJob(var Sender: Codeunit "Gen. Jnl.-Post Line"; VAR GenJnlLine: Record "Gen. Journal Line"; VAR VendLedgEntry: Record "Vendor Ledger Entry"; VAR CVLedgEntryBuf: Record "CV Ledger Entry Buffer"; VAR TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer"; VAR VendPostingGr: Record "Vendor Posting Group")
    var
        NS_GLAccount: Record "G/L Account";
        NS_GLEntry: Record "G/L Entry";
        NS_SourceCodeSetup: Record "Source Code Setup";
        NS_JobJnlPostLine: Codeunit "Job Jnl.-Post Line";
        NS_GLAcctNo: Code[20];
        NS_GLAcctDesc: Text[50];
        NS_PurchSetup: Record "Purchases & Payables Setup";
        NS_Currency: Record Currency;
        NS_Vend: Record Vendor;
        //TransferCustomFields: Codeunit "Transfer Custom Fields"; //PPDA.1.0 
        OldVendLedgEntry: Record "Vendor Ledger Entry";
        NS_JobsSetup: Record "Jobs Setup";
        GLSetup: Record "General Ledger Setup";
        NS_JobJnlLine: Record "Job Journal Line";
        NS_OrigGenJnlLine: Record "Gen. Journal Line";
        NS_Text002: Label 'Purchase %1 %2 already exists.';
        NS_Text003: label 'Purchase %1 %2 already exists for this vendor.';
        Licdate: date;//PRJ-516
        NoOfDays: Text;//PRJ-516
        EnvInfoCU: Codeunit "Environment Information";//PRJ-516

    begin
        //ProjectPro - start
        WITH GenJnlLine DO BEGIN
            NS_PurchSetup.GET;
            NS_SourceCodeSetup.GET;
            IF "Source Code" = NS_SourceCodeSetup."Payment Journal" THEN
                EXIT;

            NS_JobsSetup.GET;
            NS_PurchSetup.GET;
            p.NS_C12SetNS_RetentionLinkedEntryNo(0);
            p.NS_C12SetNS_MainLinkedEntryNo(0);
            NS_Vend.GET("Account No.");
            IF "Currency Code" = '' THEN
                NS_Currency.InitRoundingPrecision
            ELSE BEGIN
                NS_Currency.GET("Currency Code");
                NS_Currency.TESTFIELD("Amount Rounding Precision");
            END;
            IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN
                IF ("NS_Retention Amount" <> 0) OR "NS_Retention Document" THEN
                    NS_JobsSetup.TESTFIELD("NS_Retention Payable Ledger");

            //Process a Document that needs Retention Withheld -- Copy of Normal Vendor Posting with changes
            IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN BEGIN
                IF (NOT "NS_Retention Document") AND ("NS_Retention Amount (LCY)" <> 0) THEN BEGIN
                    VendPostingGr.TESTFIELD("NS_Retention Payables Account");

                    // //PRJ-516.ms.1.0 start
                    //PRJ-1686.GK.1.0 26Oct2022 start
                    //PRJ-1641.JS.1.0 23SEP2022 - Start
                    if EnvInfoCU.IsSaaS() then begin
                        //     //     //Licdate := DMY2Date(31, 3, 2021);//PRJ-516.AS.1.0 16MARCH2021 Comment
                        //     //     Licdate := DMY2Date(31, 5, 2021);//PRJ-516.AS.1.0 16MARCH2021 Added Change date
                        //     Licdate := DMY2Date(30, 11, 2022);
                        // Licdate := DMY2Date(31, 12, 2022);
                        // Licdate := DMY2Date(31, 1, 2023);
                        // EVALUATE(NoOfDays, FORMAT(Licdate - WorkDate));
                        // if (WorkDate > (Licdate - 15)) and (WorkDate <= Licdate) then
                        //     Message('Your ProjectPro license is going to expire in %1 days.Please contact your administrator.', NoOfDays);
                        // if WorkDate > Licdate then
                        //     Error('Your ProjectPro license has expired.Please contact your administrator.');
                        // end;
                        // //PRJ-516.ms.1.0 end

                        OnCheckPPLicenseExpire();   //PRJ-1641.JS.1.0 23SEP2022 line commented
                        //PRJ-1641.JS.1.0 23SEP2022 - end
                    end;
                    //PRJ-1686.GK.1.0 26Oct2022 end
                    VendLedgEntry.INIT;
                    VendLedgEntry."Vendor No." := "Account No.";
                    VendLedgEntry."Posting Date" := "Posting Date";
                    VendLedgEntry."Document Date" := "Document Date";
                    VendLedgEntry."Document Type" := "Document Type";
                    VendLedgEntry."Document No." := "Document No.";
                    VendLedgEntry."External Document No." := "External Document No.";
                    VendLedgEntry.Description := Description;
                    VendLedgEntry."Currency Code" := "Currency Code";
                    VendLedgEntry."Purchase (LCY)" := "NS_Retention Amount (LCY)";
                    VendLedgEntry."Inv. Discount (LCY)" := 0;
                    VendLedgEntry."Buy-from Vendor No." := "Sell-to/Buy-from No.";
                    VendLedgEntry."Vendor Posting Group" := "Posting Group";
                    VendLedgEntry."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                    VendLedgEntry."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                    VendLedgEntry."NS_Retention Ledger Code" := NS_JobsSetup."NS_Retention Payable Ledger";
                    VendLedgEntry."Dimension Set ID" := "Dimension Set ID";
                    VendLedgEntry."Purchaser Code" := "Salespers./Purch. Code";
                    VendLedgEntry."Source Code" := "Source Code";
                    VendLedgEntry."On Hold" := "On Hold";
                    VendLedgEntry."Applies-to Doc. Type" := "Applies-to Doc. Type";
                    VendLedgEntry."Applies-to Doc. No." := "Applies-to Doc. No.";
                    VendLedgEntry."Due Date" := "Due Date";
                    VendLedgEntry."Pmt. Discount Date" := "Pmt. Discount Date";
                    VendLedgEntry."Applies-to ID" := "Applies-to ID";
                    VendLedgEntry."Journal Batch Name" := "Journal Batch Name";
                    VendLedgEntry."Reason Code" := "Reason Code";
                    VendLedgEntry."Entry No." := Sender.GetNextEntryNo(); //NextEntryNo;
                    VendLedgEntry."Transaction No." := Sender.GetNextTransactionNo(); //NextTransactionNo;
                    VendLedgEntry."User ID" := USERID;
                    VendLedgEntry."Bal. Account Type" := "Bal. Account Type";
                    VendLedgEntry."Bal. Account No." := "Bal. Account No.";
                    VendLedgEntry."NS_Bal. Ledger No." := "NS_Bal. Ledger No.";
                    VendLedgEntry."No. Series" := "Posting No. Series";
                    //PPDA.1.0 Start
                    OnBeforeAssignCustomVLEFields(VendLedgEntry, GenJnlLine); //PPDA.1.0
                                                                              // VendLedgEntry."IRS 1099 Code" := "IRS 1099 Code"; //Moved in dependent app
                                                                              // VendLedgEntry."IRS 1099 Amount" := "IRS 1099 Amount";
                                                                              //PPDA.1.0 End
                    VendLedgEntry."IC Partner Code" := "IC Partner Code";
                    VendLedgEntry.Prepayment := Prepayment;
                    VendLedgEntry."NS_Retention Percent" := "NS_Retention Percent";
                    VendLedgEntry."NS_Retention Amount" := "NS_Retention Amount";
                    VendLedgEntry."NS_Retention Amount (LCY)" := "NS_Retention Amount (LCY)";
                    VendLedgEntry."NS_Retention Date" := "NS_Retention Date";
                    VendLedgEntry."NS_Retention Base Amount" := "NS_Retention Base Amount";
                    VendLedgEntry."NS_Retention Document" := "NS_Retention Document";
                    VendLedgEntry."Remaining Amount" := "NS_Retention Amount";
                    VendLedgEntry."Remaining Amt. (LCY)" := "NS_Retention Amount (LCY)";
                    VendLedgEntry.Open := TRUE;
                    VendLedgEntry."NS_Draw No." := "NS_Draw No.";
                    IF GenJnlLine."Currency Code" <> '' THEN BEGIN
                        GenJnlLine.TESTFIELD("Currency Factor");
                        VendLedgEntry."Adjusted Currency Factor" := GenJnlLine."Currency Factor";
                    END ELSE
                        VendLedgEntry."Adjusted Currency Factor" := 1;
                    VendLedgEntry."Original Currency Factor" := VendLedgEntry."Adjusted Currency Factor";

                    //TransferCustomFields.GenJnlLineTOVendLedgEntry(GenJnlLine, VendLedgEntry); //PPDA.1.0 OnBeforeAssignCustomVLEFields
                    TempDtldCVLedgEntryBuf.DELETEALL;
                    TempDtldCVLedgEntryBuf.INIT;
                    TempDtldCVLedgEntryBuf."CV Ledger Entry No." := VendLedgEntry."Entry No.";
                    TempDtldCVLedgEntryBuf."Entry Type" := TempDtldCVLedgEntryBuf."Entry Type"::"Initial Entry";
                    TempDtldCVLedgEntryBuf."Posting Date" := "Posting Date";
                    TempDtldCVLedgEntryBuf."Document Type" := "Document Type";
                    TempDtldCVLedgEntryBuf."Document No." := "Document No.";
                    TempDtldCVLedgEntryBuf.Amount := "NS_Retention Amount";
                    TempDtldCVLedgEntryBuf."Amount (LCY)" := "NS_Retention Amount (LCY)";
                    TempDtldCVLedgEntryBuf."Additional-Currency Amount" := "NS_Retention Amount";
                    TempDtldCVLedgEntryBuf."CV No." := "Account No.";
                    TempDtldCVLedgEntryBuf."Currency Code" := "Currency Code";
                    TempDtldCVLedgEntryBuf."User ID" := USERID;
                    TempDtldCVLedgEntryBuf."Initial Entry Due Date" := "Due Date";
                    TempDtldCVLedgEntryBuf."Initial Entry Global Dim. 1" := "Shortcut Dimension 1 Code";
                    TempDtldCVLedgEntryBuf."Initial Entry Global Dim. 2" := "Shortcut Dimension 2 Code";
                    TempDtldCVLedgEntryBuf."NS_Retention Ledger Code" := NS_JobsSetup."NS_Retention Receivable Ledger";
                    TempDtldCVLedgEntryBuf."Initial Document Type" := "Document Type";
                    TempDtldCVLedgEntryBuf."NS_Job No." := "Job No.";
                    TempDtldCVLedgEntryBuf."NS_Subcontract No." := "NS_Subcontract No.";
                    CVLedgEntryBuf.CopyFromVendLedgEntry(VendLedgEntry);
                    TempDtldCVLedgEntryBuf.InsertDtldCVLedgEntry(TempDtldCVLedgEntryBuf, CVLedgEntryBuf, TRUE);
                    CVLedgEntryBuf.Open := CVLedgEntryBuf."Remaining Amount" <> 0;
                    CVLedgEntryBuf.Positive := CVLedgEntryBuf."Remaining Amount" > 0;

                    IF "Amount (LCY)" <> 0 THEN BEGIN
                        IF GLSetup."Pmt. Disc. Excl. VAT" THEN
                            CVLedgEntryBuf."Original Pmt. Disc. Possible" := "Sales/Purch. (LCY)" * Amount / "Amount (LCY)"
                        ELSE
                            CVLedgEntryBuf."Original Pmt. Disc. Possible" := Amount;

                        CVLedgEntryBuf."Original Pmt. Disc. Possible" :=
                          ROUND(
                            CVLedgEntryBuf."Original Pmt. Disc. Possible" * "Payment Discount %" / 100,
                            NS_Currency."Amount Rounding Precision");
                        CVLedgEntryBuf."Remaining Pmt. Disc. Possible" := CVLedgEntryBuf."Original Pmt. Disc. Possible";
                    END;

                    IF "Currency Code" <> '' THEN BEGIN
                        TESTFIELD("Currency Factor");
                        CVLedgEntryBuf."Adjusted Currency Factor" := "Currency Factor"
                    END ELSE
                        CVLedgEntryBuf."Adjusted Currency Factor" := 1;
                    CVLedgEntryBuf."Original Currency Factor" := CVLedgEntryBuf."Adjusted Currency Factor";

                    // Check the document no.
                    IF "Recurring Method" = 0 THEN
                        IF "Document Type" IN
                          ["Document Type"::Invoice,
                           "Document Type"::"Credit Memo",
                           "Document Type"::"Finance Charge Memo",
                           "Document Type"::Reminder]
                        THEN BEGIN
                            // Test Internal number
                            OldVendLedgEntry.RESET;
                            IF NOT RECORDLEVELLOCKING THEN
                                OldVendLedgEntry.SETCURRENTKEY("Document No.");
                            OldVendLedgEntry.SETRANGE("Document No.", CVLedgEntryBuf."Document No.");
                            OldVendLedgEntry.SETRANGE("Document Type", CVLedgEntryBuf."Document Type");
                            OldVendLedgEntry.SETRANGE("NS_Retention Ledger Code", CVLedgEntryBuf."NS_Retention Ledger Code");
                            IF NOT OldVendLedgEntry.ISEMPTY THEN
                                ERROR(
                                  NS_Text002,
                                  VendLedgEntry."Document Type", CVLedgEntryBuf."Document No.");

                            IF NS_PurchSetup."Ext. Doc. No. Mandatory" OR
                              (CVLedgEntryBuf."External Document No." <> '')
                            THEN BEGIN
                                // Test vendor number
                                TESTFIELD("External Document No.");
                                OldVendLedgEntry.RESET;
                                IF NOT RECORDLEVELLOCKING THEN
                                    OldVendLedgEntry.SETCURRENTKEY("External Document No.");
                                OldVendLedgEntry.SETRANGE("External Document No.", CVLedgEntryBuf."External Document No.");
                                OldVendLedgEntry.SETRANGE("Document Type", CVLedgEntryBuf."Document Type");
                                OldVendLedgEntry.SETRANGE("Vendor No.", CVLedgEntryBuf."CV No.");
                                OldVendLedgEntry.SETRANGE("NS_Retention Ledger Code", CVLedgEntryBuf."NS_Retention Ledger Code");
                                IF NOT OldVendLedgEntry.ISEMPTY THEN
                                    ERROR(
                                      NS_Text003,
                                      CVLedgEntryBuf."Document Type", CVLedgEntryBuf."External Document No.");
                            END;
                        END;

                    // Post the application
                    Sender.ApplyVendLedgEntry(CVLedgEntryBuf, TempDtldCVLedgEntryBuf, GenJnlLine, NS_Vend); //PPNA17.0 Opened
                                                                                                            // Post Vendor entry
                    CVLedgEntryBuf.CopyFromVendLedgEntry(VendLedgEntry);
                    VendLedgEntry."Amount to Apply" := 0;
                    VendLedgEntry."Applies-to Doc. No." := '';
                    VendLedgEntry."NS_Job No." := "Job No.";
                    VendLedgEntry."NS_Subcontract No." := "NS_Subcontract No.";
                    VendLedgEntry.Positive := CVLedgEntryBuf."Remaining Amount" > 0; //PRJCTPR-369.NC.1.0 21May2024
                    VendLedgEntry.INSERT;

                    // Post Dtld Vendor entry
                    Sender.PostDtldVendLedgEntries(GenJnlLine, TempDtldCVLedgEntryBuf, VendPostingGr, TRUE); //PPNA17.0 Opened
                    p.NS_C12SetNS_RetentionLinkedEntryNo(VendLedgEntry."Entry No.");
                END;
            END;

            //Process a Payment


            NS_SourceCodeSetup.GET;
            IF (GenJnlLine."NS_Subcontract No." > '') AND
               (GenJnlLine."Source Code" IN [NS_SourceCodeSetup."Cash Receipt Journal",
                                             NS_SourceCodeSetup."Payment Journal"])
            //  NS_SourceCodeSetup.Deposits])//PPDA.1.0 Commented
            THEN BEGIN
                //Find the G/L Account No. to post against
                //PPDA.1.0 Start
                OnBeforeFindingGLAccountToPostVend(GenJnlLine, NS_GLAcctNo, NS_GLAcctDesc);
                // NS_GLAcctNo := '';
                // NS_GLAcctDesc := '';
                //PPDA.1.0 End
                IF NS_PurchSetup."NS_Purchase Retention Inactive" THEN
                    NS_GLAcctNo := VendPostingGr."Payables Account"
                ELSE
                    CASE NS_OrigGenJnlLine."NS_Retention Ledger Code" OF
                        NS_PurchSetup."NS_Normal Vendor Ledger No.":
                            NS_GLAcctNo := VendPostingGr."Payables Account";
                        NS_JobsSetup."NS_Retention Payable Ledger":
                            NS_GLAcctNo := VendPostingGr."NS_Retention Payables Account";
                    END;

                IF NS_GLAcctNo > '' THEN BEGIN
                    NS_GLAccount.GET(NS_GLAcctNo);
                    NS_GLAcctDesc := NS_GLAccount.Name;
                END;


                //Create the Job Journal Line to Post
                NS_JobJnlLine.INIT;
                NS_JobJnlLine."Posting Date" := GenJnlLine."Posting Date";
                NS_JobJnlLine."Document Date" := GenJnlLine."Document Date";
                NS_JobJnlLine."Job No." := GenJnlLine."Job No.";
                NS_JobJnlLine."Job Task No." := GenJnlLine."Job Task No.";
                NS_JobJnlLine."NS_Subcontract No." := GenJnlLine."NS_Subcontract No.";
                NS_JobJnlLine.Type := NS_JobJnlLine.Type::"G/L Account";
                NS_JobJnlLine."No." := NS_GLAcctNo;
                NS_JobJnlLine.Description := NS_GLAcctDesc;
                NS_JobJnlLine."Shortcut Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
                NS_JobJnlLine."Shortcut Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
                NS_JobJnlLine."NS_Retention Ledger Code" := GenJnlLine."NS_Retention Ledger Code";
                NS_JobJnlLine."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                NS_JobJnlLine."Entry Type" := NS_JobJnlLine."Entry Type"::NS_Payment; //PPNA17.0 Opened
                NS_JobJnlLine."Document No." := GenJnlLine."Document No.";
                NS_JobJnlLine."External Document No." := GenJnlLine."External Document No.";
                NS_JobJnlLine.Quantity := 1;
                NS_JobJnlLine."Unit Cost" := GenJnlLine.Amount;
                NS_JobJnlLine."NS_Burden Amount" := GenJnlLine."NS_Burden Amount";
                NS_JobJnlLine."Total Cost" := -GenJnlLine.Amount;
                NS_JobJnlLine."Source Code" := GenJnlLine."Source Code";
                NS_JobJnlLine."NS_External Relationship Type" := NS_JobJnlLine."NS_External Relationship Type"::"Vendor";
                NS_JobJnlLine."NS_External Relationship No." := GenJnlLine."Account No.";
                NS_JobJnlLine."NS_External Relationship Name" := GenJnlLine.Description;
                NS_JobJnlLine."NS_Job Cost Category" := GenJnlLine."NS_Job Cost Category";
                NS_JobJnlLine."NS_Job Revenue Category" := GenJnlLine."NS_Job Revenue Category";
                NS_JobJnlLine."NS_Cost-Revenue Type" := GenJnlLine."NS_Cost-Revenue Type";
                NS_JobJnlLine.Chargeable := FALSE;
                NS_JobJnlLine."NS_Segment Code" := GenJnlLine."NS_Segment Code"; //TM-10.AM.1.0

                NS_JobJnlPostLine.RunWithCheck(NS_JobJnlLine);
            END;

        END;
    end;
    //ProjectPro - end


    procedure NS_PostCustJob(var Sender: Codeunit "Gen. Jnl.-Post Line"; VAR GenJnlLine: Record "Gen. Journal Line"; VAR CustLedgEntry: Record "Cust. Ledger Entry"; VAR CVLedgEntryBuf: Record "CV Ledger Entry Buffer"; VAR tempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer"; VAR CustPostingGr: Record "Customer Posting Group")
    var
        NS_GLAccount: Record "G/L Account";
        NS_GLEntry: Record "G/L Entry";
        NS_SourceCodeSetup: Record "Source Code Setup";
        NS_JobJnlPostLine: Codeunit "Job Jnl.-Post Line";
        NS_GLAcctNo: Code[20];
        NS_GLAcctDesc: Text[50];
        NS_Currency: Record Currency;
        NS_Cust: Record Customer;
        NSJobs: Record Job; //PRJCTPR-355.JS.1.0 19APR2024
        NS_SalesSetup: Record "Sales & Receivables Setup";
        //TransferCustomFields: Codeunit "Transfer Custom Fields"; //PPDA.1.0 Added
        OldCustLedgEntry: Record "Cust. Ledger Entry";
        NS_JobsSetup: Record "Jobs Setup";
        GLSetup: Record "General Ledger Setup";
        NS_JobJnlLine: Record "Job Journal Line";
        NS_OrigGenJnlLine: Record "Gen. Journal Line";
        NS_Text001: Label 'Sales %1 %2 already exists.';
        Licdate: date;//PRJ-516
        NoOfDays: Text;//PRJ-516
        EnvInfoCU: Codeunit "Environment Information";//PRJ-516
        IsHandled: Boolean;  //PRJCTPr-235.JS.1.0 25JAN2024   //FGH-163.SM.14052024  //PRJCTPR-371.JS.1.0
        SalesReceivablesSetup: Record "Sales & Receivables Setup"; //PRJCTPR-312 AT.1.0
    begin
        //PRJ-1686.GK.1.0 26Oct2022 start
        //PRJ-1641.JS.1.0 23SEP2022 - Start
        //FGH-163.SM.14052024 START  //PRJCTPR-371.JS.1.0
        OnBeforeNS_PostCustJob(Sender, GenJnlLine, CustLedgEntry, CVLedgEntryBuf, tempDtldCVLedgEntryBuf, CustPostingGr, IsHandled);
        if IsHandled then
            exit;
        //FGH-163.SM.14052024 END  //PRJCTPR-371.JS.1.0
        //PRJ-516.ms.1.0 start
        if EnvInfoCU.IsSaaS() then begin
            //     //Licdate := DMY2Date(31, 3, 2021);//PRJ-516.AS.1.0 16MARCH2021 Comment
            //     //Licdate := DMY2Date(31, 5, 2021);//PRJ-516.AS.1.0 16MARCH2021 Added Change date
            //     Licdate := DMY2Date(30, 11, 2022);
            // Licdate := DMY2Date(31, 12, 2022);
            // Licdate := DMY2Date(31, 1, 2023);
            // EVALUATE(NoOfDays, FORMAT(Licdate - WorkDate));
            // if (WorkDate > (Licdate - 15)) and (WorkDate <= Licdate) then
            //     Message('Your ProjectPro license is going to expire in %1 days.Please contact your administrator.', NoOfDays);
            // if WorkDate > Licdate then
            //     Error('Your ProjectPro license has expired.Please contact your administrator.');
            // END;
            //PRJ-516.ms.1.0 end

            OnCheckPPLicenseExpire();
        end;    //PRJ-1641.JS.1.0 23SEP2022 - line commented
        //PRJ-1641.JS.1.0 23SEP2022 - end
        //PRJ-1686.GK.1.0 26Oct2022 end

        //ProjectPro - start
        WITH GenJnlLine DO BEGIN
            NS_JobsSetup.GET;
            GLSetup.Get();
            p.NS_C12SetNS_RetentionLinkedEntryNo(0);
            p.NS_C12SetNS_MainLinkedEntryNo(0);
            NS_SalesSetup.GET;
            NS_Cust.GET("Account No.");
            IF "Currency Code" = '' THEN BEGIN
                NS_Currency.InitRoundingPrecision;
            END ELSE BEGIN
                NS_Currency.GET("Currency Code");
                NS_Currency.TESTFIELD("Amount Rounding Precision");
            END;

            IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
                IF ("NS_Retention Amount" <> 0) OR "NS_Retention Document" THEN
                    NS_JobsSetup.TESTFIELD("NS_Retention Receivable Ledger");

            //Process a Document that needs Retention Withheld -- Copy of Normal Customer Posting with changes
            IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN BEGIN
                IF (NOT "NS_Retention Document") AND ("NS_Retention Amount (LCY)" <> 0) THEN BEGIN
                    CustPostingGr.TESTFIELD("NS_RetentionReceivablesAccount");
                    CustLedgEntry.INIT;
                    CustLedgEntry."Customer No." := "Account No.";
                    CustLedgEntry."Posting Date" := "Posting Date";
                    CustLedgEntry."Document Date" := "Document Date";
                    CustLedgEntry."Document Type" := "Document Type";
                    CustLedgEntry."Document No." := "Document No.";
                    CustLedgEntry."External Document No." := "External Document No.";
                    CustLedgEntry.Description := Description;
                    CustLedgEntry."Currency Code" := "Currency Code";
                    //CustLedgEntry."Sales (LCY)" := "NS_Retention Amount (LCY)";  //PRJ-1044.GK.1.0 22Nov2021
                    CustLedgEntry."Profit (LCY)" := "NS_Retention Amount (LCY)";
                    CustLedgEntry."Inv. Discount (LCY)" := 0;
                    CustLedgEntry."Sell-to Customer No." := "Sell-to/Buy-from No.";
                    CustLedgEntry."Customer Posting Group" := "Posting Group";
                    CustLedgEntry."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                    CustLedgEntry."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                    CustLedgEntry."NS_Retention Ledger Code" := NS_JobsSetup."NS_Retention Receivable Ledger";
                    CustLedgEntry."Dimension Set ID" := "Dimension Set ID";
                    CustLedgEntry."Salesperson Code" := "Salespers./Purch. Code";
                    CustLedgEntry."Source Code" := "Source Code";
                    CustLedgEntry."On Hold" := "On Hold";
                    CustLedgEntry."Applies-to Doc. Type" := "Applies-to Doc. Type";
                    CustLedgEntry."Applies-to Doc. No." := "Applies-to Doc. No.";
                    CustLedgEntry."Due Date" := CALCDATE('<+' + NS_JobsSetup."NS_Sales Retention Period" + '>', "Due Date");
                    CustLedgEntry."Pmt. Discount Date" := "Pmt. Discount Date";
                    CustLedgEntry."Applies-to ID" := "Applies-to ID";
                    CustLedgEntry."Journal Batch Name" := "Journal Batch Name";
                    CustLedgEntry."Reason Code" := "Reason Code";
                    CustLedgEntry."Entry No." := Sender.GetNextEntryNo(); //NextEntryNo; 
                    CustLedgEntry."Transaction No." := Sender.GetNextTransactionNo(); //NextTransactionNo;
                    CustLedgEntry."User ID" := USERID;
                    CustLedgEntry."Bal. Account Type" := "Bal. Account Type";
                    CustLedgEntry."Bal. Account No." := "Bal. Account No.";
                    CustLedgEntry."NS_Bal. Ledger No." := "NS_Bal. Ledger No.";
                    CustLedgEntry."No. Series" := "Posting No. Series";
                    CustLedgEntry."IC Partner Code" := "IC Partner Code";
                    CustLedgEntry.Prepayment := Prepayment;
                    //PRJ-1044.GK.1.0 22Nov2021 start
                    //CustLedgEntry."NS_Retention Percent" := "NS_Retention Percent"; 
                    // CustLedgEntry."NS_Retention Amount" := "NS_Retention Amount";
                    // CustLedgEntry."NS_Retention Amount (LCY)" := "NS_Retention Amount (LCY)";
                    // CustLedgEntry."NS_Retention Date" := "NS_Retention Date";
                    //CustLedgEntry."NS_Retention Base Amount" := "NS_Retention Base Amount"; 
                    //PRJ-1044.GK.1.0 22Nov2021 end
                    CustLedgEntry."NS_Retention Document" := "NS_Retention Document";
                    //PRJCTPR-224.VC.1.0 Start Comment
                    //CustLedgEntry."Remaining Amount" := "NS_Retention Amount";
                    //CustLedgEntry."Remaining Amt. (LCY)" := "NS_Retention Amount (LCY)";
                    //PRJCTPR-224.VC.1.0 End Comment
                    //PRJCTPR-242.PS.1.0 08Dec2023 Start Commented 
                    //PRJCTPR-214.VC.1.2 Start
                    CustLedgEntry.Open := TRUE;//PRJCTPR-214.VC.1.2 Comment  //PRJCTPR-242.PS.1.0 08Dec2023 Uncommnetd              
                                               //  CustLedgEntry.CalcFields("Remaining Amount");
                                               // CustLedgEntry.Open := CustLedgEntry."Remaining Amount" <> 0;
                                               //PRJCTPR-214.VC.1.2 End
                                               //PRJCTPR-242.PS.1.0 08Dec2023 End Commented 

                    //PRJCTPR-214.AS.1.0 14DEC2023 START
                    CustLedgEntry."NS_Retention Document" := GenJnlLine."NS_Retention Document";

                    CustLedgEntry.CalcFields("Remaining Amount", "Remaining Amt. (LCY)");
                    CustLedgEntry."Remaining Amount" := GenJnlLine."NS_Retention Amount";
                    CustLedgEntry."Remaining Amt. (LCY)" := GenJnlLine."NS_Retention Amount (LCY)";
                    CustLedgEntry.Open := TRUE;
                    //PRJCTPR-214.AS.1.0 14DEC2023 END
                    OnBeforeTransferCustomFields(GenJnlLine, CustLedgEntry);
                    //TransferCustomFields.GenJnlLineTOCustLedgEntry(GenJnlLine, CustLedgEntry);
                    //PPDA.1.0 End
                    tempDtldCVLedgEntryBuf.DELETEALL;
                    tempDtldCVLedgEntryBuf.INIT;
                    tempDtldCVLedgEntryBuf."CV Ledger Entry No." := CustLedgEntry."Entry No.";
                    tempDtldCVLedgEntryBuf."Entry Type" := tempDtldCVLedgEntryBuf."Entry Type"::"Initial Entry";
                    tempDtldCVLedgEntryBuf."Posting Date" := "Posting Date";
                    tempDtldCVLedgEntryBuf."Document Type" := "Document Type";
                    tempDtldCVLedgEntryBuf."Document No." := "Document No.";
                    tempDtldCVLedgEntryBuf.Amount := "NS_Retention Amount";
                    tempDtldCVLedgEntryBuf."Amount (LCY)" := "NS_Retention Amount (LCY)";
                    tempDtldCVLedgEntryBuf."Additional-Currency Amount" := "NS_Retention Amount";
                    tempDtldCVLedgEntryBuf."CV No." := "Account No.";
                    tempDtldCVLedgEntryBuf."Currency Code" := "Currency Code";
                    tempDtldCVLedgEntryBuf."User ID" := USERID;
                    tempDtldCVLedgEntryBuf."Initial Entry Due Date" := "Due Date";
                    tempDtldCVLedgEntryBuf."Initial Entry Global Dim. 1" := "Shortcut Dimension 1 Code";
                    tempDtldCVLedgEntryBuf."Initial Entry Global Dim. 2" := "Shortcut Dimension 2 Code";
                    tempDtldCVLedgEntryBuf."NS_Retention Ledger Code" := NS_JobsSetup."NS_Retention Receivable Ledger";
                    tempDtldCVLedgEntryBuf."Initial Document Type" := "Document Type";
                    tempDtldCVLedgEntryBuf."NS_Job No." := "Job No.";
                    tempDtldCVLedgEntryBuf."NS_Subcontract No." := "NS_Subcontract No.";
                    CVLedgEntryBuf.CopyFromCustLedgEntry(CustLedgEntry);
                    tempDtldCVLedgEntryBuf.InsertDtldCVLedgEntry(tempDtldCVLedgEntryBuf, CVLedgEntryBuf, TRUE);
                    CVLedgEntryBuf.Open := CVLedgEntryBuf."Remaining Amount" <> 0;
                    CVLedgEntryBuf.Positive := CVLedgEntryBuf."Remaining Amount" > 0;

                    IF "Amount (LCY)" <> 0 THEN BEGIN
                        IF GLSetup."Pmt. Disc. Excl. VAT" THEN
                            CVLedgEntryBuf."Original Pmt. Disc. Possible" := "Sales/Purch. (LCY)" * Amount / "Amount (LCY)"
                        ELSE
                            CVLedgEntryBuf."Original Pmt. Disc. Possible" := Amount;
                        CVLedgEntryBuf."Original Pmt. Disc. Possible" :=
                          ROUND(
                            CVLedgEntryBuf."Original Pmt. Disc. Possible" * "Payment Discount %" / 100,
                            NS_Currency."Amount Rounding Precision");

                        CVLedgEntryBuf."Remaining Pmt. Disc. Possible" := CVLedgEntryBuf."Original Pmt. Disc. Possible";
                    END;

                    IF "Currency Code" <> '' THEN BEGIN
                        TESTFIELD("Currency Factor");
                        CVLedgEntryBuf."Original Currency Factor" := "Currency Factor"
                    END ELSE
                        CVLedgEntryBuf."Original Currency Factor" := 1;
                    CVLedgEntryBuf."Adjusted Currency Factor" := CVLedgEntryBuf."Original Currency Factor";

                    // Check the document no.
                    if SalesReceivablesSetup.get() then; //PRJCTPR-312 AT.1.0
                    if not SalesReceivablesSetup."NS_Skip Recurring Method" then begin //PRJCTPR-312 AT.1.0                   
                        IF "Recurring Method" = 0 THEN
                            IF "Document Type" IN
                              ["Document Type"::Invoice,
                               "Document Type"::"Credit Memo",
                               "Document Type"::"Finance Charge Memo",
                               "Document Type"::Reminder]
                            THEN BEGIN
                                OldCustLedgEntry.RESET;
                                IF NOT RECORDLEVELLOCKING THEN
                                    OldCustLedgEntry.SETCURRENTKEY("Document No.");
                                OldCustLedgEntry.SETRANGE("Document No.", CVLedgEntryBuf."Document No.");
                                OldCustLedgEntry.SETRANGE("Document Type", CVLedgEntryBuf."Document Type");
                                OldCustLedgEntry.SETRANGE("NS_Retention Ledger Code", CVLedgEntryBuf."NS_Retention Ledger Code");
                                IF NOT OldCustLedgEntry.ISEMPTY THEN
                                    ERROR(
                                      NS_Text001,
                                      "Document Type", "Document No.");
                            END;
                    end; //PRJCTPR-312 AT.1.0
                    IF NS_SalesSetup."Ext. Doc. No. Mandatory" THEN
                        TESTFIELD("External Document No.");

                    // Post the application
                    Sender.ApplyCustLedgEntry(CVLedgEntryBuf, tempDtldCVLedgEntryBuf, GenJnlLine, NS_Cust);//PPNA17.0 Opened
                    // Post customer entry
                    CVLedgEntryBuf.CopyFromCustLedgEntry(CustLedgEntry);

                    //PRJ-137.SK.1.0 Start
                    IF "Currency Code" <> '' THEN BEGIN
                        TESTFIELD("Currency Factor");
                        CustLedgEntry."Original Currency Factor" := "Currency Factor"
                    END ELSE
                        CustLedgEntry."Original Currency Factor" := 1;
                    CustLedgEntry."Adjusted Currency Factor" := CustLedgEntry."Original Currency Factor";
                    //PRJ-137.SK.1.0 End

                    CustLedgEntry."Amount to Apply" := 0;
                    CustLedgEntry."Applies-to Doc. No." := '';
                    CustLedgEntry."NS_Job No." := "Job No.";
                    CustLedgEntry.INSERT;
                    // Post Dtld. customer entry
                    Sender.PostDtldCustLedgEntries(GenJnlLine, tempDtldCVLedgEntryBuf, CustPostingGr, TRUE);//PPNA17.0 Opened
                    p.NS_C12SetNS_RetentionLinkedEntryNo(CustLedgEntry."Entry No.");
                END;
            END;

            //Process a Payment
            NS_SourceCodeSetup.GET;
            IF (GenJnlLine."Job No." > '') AND
               (GenJnlLine."Source Code" IN [NS_SourceCodeSetup."Cash Receipt Journal",
                                             NS_SourceCodeSetup."Payment Journal"])
            //  NS_SourceCodeSetup.Deposits])//PPDA.1.0 Commented
            THEN BEGIN

                //Find the G/L Account No. to post against
                //PPDA.1.0 Start
                OnBeforeFindingGLAccountToPostCust(GenJnlLine, NS_GLAcctNo, NS_GLAcctDesc);
                // NS_GLAcctNo := '';
                // NS_GLAcctDesc := '';
                //PPDA.1.0 End

                IF NS_SalesSetup."NS_Sales Retention Inactive" THEN
                    NS_GLAcctNo := CustPostingGr."Receivables Account"
                ELSE begin
                    p.NS_C12GetNS_OrigGenJnlLine(NS_OrigGenJnlLine);
                    CASE NS_OrigGenJnlLine."NS_Retention Ledger Code" OF
                        NS_SalesSetup."NS_Normal Customer Ledger No.":
                            NS_GLAcctNo := CustPostingGr."Receivables Account";
                        NS_JobsSetup."NS_Retention Receivable Ledger":
                            NS_GLAcctNo := CustPostingGr.NS_RetentionReceivablesAccount;
                    END;
                end;
                IF NS_GLAcctNo > '' THEN BEGIN
                    NS_GLAccount.GET(NS_GLAcctNo);
                    NS_GLAcctDesc := NS_GLAccount.Name;
                END;

                //Create the Job Journal Line to Post
                if NSJobs.get(GenJnlLine."Job No.") then;  //PRJCTPR-355.JS.1.0 19APR2024
                NS_JobJnlLine.INIT;
                NS_JobJnlLine."Posting Date" := GenJnlLine."Posting Date";
                NS_JobJnlLine."Document Date" := GenJnlLine."Document Date";
                NS_JobJnlLine."Job No." := GenJnlLine."Job No.";
                NS_JobJnlLine."Job Task No." := GenJnlLine."Job Task No.";
                NS_JobJnlLine."NS_Subcontract No." := GenJnlLine."NS_Subcontract No.";
                NS_JobJnlLine.Type := NS_JobJnlLine.Type::"G/L Account";
                NS_JobJnlLine."No." := NS_GLAcctNo;
                NS_JobJnlLine.Description := NS_GLAcctDesc;
                NS_JobJnlLine."Shortcut Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
                NS_JobJnlLine."Shortcut Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
                NS_JobJnlLine."NS_Retention Ledger Code" := GenJnlLine."NS_Retention Ledger Code";
                NS_JobJnlLine."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                NS_JobJnlLine."Entry Type" := NS_JobJnlLine."Entry Type"::NS_Payment;//PPNA17.0 Opened
                NS_JobJnlLine."Document No." := GenJnlLine."Document No.";
                NS_JobJnlLine."External Document No." := GenJnlLine."External Document No.";
                //PRJCTPR-355.JS.1.0 17APR2024 - Start
                if (GenJnlLine."Currency Code" <> '') and (NSJobs."Currency Code" <> '') then
                    NS_JobJnlLine."Currency Code" := GenJnlLine."Currency Code";
                //PRJCTPR-355.JS.1.0 17APR2024 - end
                NS_JobJnlLine.Quantity := 1;
                NS_JobJnlLine."Quantity (Base)" := 1;
                NS_JobJnlLine."Unit Price" := -GenJnlLine.Amount;
                NS_JobJnlLine."Total Price" := -GenJnlLine.Amount;
                NS_JobJnlLine."Source Code" := GenJnlLine."Source Code";
                NS_JobJnlLine."NS_External Relationship Type" := NS_JobJnlLine."NS_External Relationship Type"::Customer;
                NS_JobJnlLine."NS_External Relationship No." := GenJnlLine."Account No.";
                NS_JobJnlLine."NS_External Relationship Name" := GenJnlLine.Description;
                NS_JobJnlLine."NS_Job Cost Category" := GenJnlLine."NS_Job Cost Category";
                NS_JobJnlLine."NS_Job Revenue Category" := GenJnlLine."NS_Job Revenue Category";
                NS_JobJnlLine."NS_Cost-Revenue Type" := GenJnlLine."NS_Cost-Revenue Type";
                NS_JobJnlLine.Chargeable := FALSE;
                NS_JobJnlLine."NS_Segment Code" := GenJnlLine."NS_Segment Code"; //TM-10.AM.1.0

                NS_JobJnlPostLine.RunWithCheck(NS_JobJnlLine);
            END;

        END;
        //ProjectPro - end
    end;


    //Dependent App Events starts from here
    [IntegrationEvent(False, false)]
    local procedure OnBeforeAssignCustomVLEFields(Var VendLedgEntry: Record "Vendor Ledger Entry"; var GenJnlLine: record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(False, false)]
    local procedure OnBeforeFindingGLAccountToPostVend(GenJnlLine: record "Gen. Journal Line"; Var NS_GLAcctNo: code[20]; NS_GLAcctDesc: Text[50])
    begin
    end;

    [IntegrationEvent(False, false)]
    local procedure OnBeforeFindingGLAccountToPostCust(GenJnlLine: record "Gen. Journal Line"; Var NS_GLAcctNo: code[20]; NS_GLAcctDesc: Text[50])
    begin
    end;

    [IntegrationEvent(False, false)]
    local procedure OnBeforeTransferCustomFields(var GenJnlLine: Record "Gen. Journal Line"; var CustLedgEntry: Record "Cust. Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCheckPPLicenseExpire()
    begin
    end;

    //PRJCTPR-260.HS.1.0 8Jan2024 Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnInitVATOnBeforeVATPostingSetupCheck', '', false, false)]
    local procedure OnInitVATOnBeforeVATPostingSetupCheck(var GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;
    //PRJCTPR-260.HS.1.0 8Jan2024 End
    //FGH-163.SM.14052024 START  //PRJCTPR-371.JS.1.0
    [IntegrationEvent(false, false)]
    local procedure OnBeforeNS_T383OnAfterCopyFromGenJnlLine(var DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; GenJnlLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeNS_PostCustJob(var Sender: Codeunit "Gen. Jnl.-Post Line"; VAR GenJnlLine: Record "Gen. Journal Line"; VAR CustLedgEntry: Record "Cust. Ledger Entry"; VAR CVLedgEntryBuf: Record "CV Ledger Entry Buffer"; VAR tempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer"; VAR CustPostingGr: Record "Customer Posting Group"; var IsHandled: Boolean)
    begin
    end;
    //FGH-163.SM.14052024 END //PRJCTPR-371.JS.1.0

}

