/// <summary>
/// Codeunit NS_Sales Header Apply (ID 14021316).
/// </summary>
//PRJ-1108.GK.1.0 11Jan2022-Create new codeunit for application.
//PRJ-1170.RM.1.0  28Jan2022 | Removed with statement
codeunit 14021316 "NS_Sales Header Apply"
{
    TableNo = "Sales Header";

    trigger OnRun()
    var
        NS_JobSetup: Record "Jobs Setup";
    begin
        if NS_JobSetup.Get() then;
        SalesHeader.Copy(Rec);
        //PRJ-1170.RM.1.0.001 start
        //with SalesHeader do begin
        BilToCustNo := SalesHeader."Bill-to Customer No.";
        CustLedgEntry.SetCurrentKey("Customer No.", Open);
        CustLedgEntry.SetRange("Customer No.", BilToCustNo);
        CustLedgEntry.SetRange(Open, true);
        CustLedgEntry.SetRange("NS_Retention Ledger Code", NS_JobSetup."NS_Retention Receivable Ledger"); //PRJ-1108
        OnRunOnAfterFilterCustLedgEntryRetention(CustLedgEntry);
        if SalesHeader."Applies-to ID" = '' then
            SalesHeader."Applies-to ID" := SalesHeader."No.";
        if SalesHeader."Applies-to ID" = '' then
            Error(
              Text000,
              SalesHeader.FieldCaption("No."), SalesHeader.FieldCaption("Applies-to ID"));
        ApplyCustEntries.SetSales(SalesHeader, CustLedgEntry, SalesHeader.FieldNo("Applies-to ID"));
        ApplyCustEntries.SetRecord(CustLedgEntry);
        ApplyCustEntries.SetTableView(CustLedgEntry);
        ApplyCustEntries.LookupMode(true);
        OK := ApplyCustEntries.RunModal = ACTION::LookupOK;
        Clear(ApplyCustEntries);
        if not OK then
            exit;
        CustLedgEntry.Reset();
        CustLedgEntry.SetCurrentKey("Customer No.", Open);
        CustLedgEntry.SetRange("Customer No.", BilToCustNo);
        CustLedgEntry.SetRange(Open, true);
        CustLedgEntry.SetRange("Applies-to ID", SalesHeader."Applies-to ID");
        OnRunOnBeforeCustLedgEntryFindFirstRetention(CustLedgEntry);
        if CustLedgEntry.FindFirst() then begin
            SalesHeader."Applies-to Doc. Type" := SalesHeader."Applies-to Doc. Type"::" ";
            SalesHeader."Applies-to Doc. No." := '';
        end else
            SalesHeader."Applies-to ID" := '';

        SalesHeader.Modify();
        //end;
        //PRJ-1170.RM.1.0.001 end
    end;

    var
        Text000: Label 'You must specify %1 or %2.';
        SalesHeader: Record "Sales Header";
        CustLedgEntry: Record "Cust. Ledger Entry";
        ApplyCustEntries: Page "NS_Apply Customer Entries";
        BilToCustNo: Code[20];
        OK: Boolean;

        SalesHeaderApply: Codeunit "Sales Header Apply";

    [IntegrationEvent(false, false)]
    local procedure OnRunOnAfterFilterCustLedgEntryRetention(var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnRunOnBeforeCustLedgEntryFindFirstRetention(var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
    end;

    //PE-302.JS.1.0 30MAY2024-Start
    procedure NSApplyRetentionSCMFromRetentionInvoice(var NSSalesCrMemoHdr: Record "Sales Cr.Memo Header")
    var
        NSApplyFromCustLedgerEntry: Record "Cust. Ledger Entry";
        NSApplyToCustLedgerEntry: Record "Cust. Ledger Entry";
        NSCustEntryApplyPostEntries: Codeunit "CustEntry-Apply Posted Entries";
        NSSalesNRecSetup: Record "Sales & Receivables Setup";
        NSJobsSetup: Record "Jobs Setup";
    begin
        // applying 'Retention' ledger entry
        if NSJobsSetup.get() then;
        if NSSalesNRecSetup.get() then;
        NSApplyFromCustLedgerEntry.Reset();
        NSApplyFromCustLedgerEntry.SetRange("Document Type", NSApplyFromCustLedgerEntry."Document Type"::"Credit Memo");
        NSApplyFromCustLedgerEntry.SetRange("Document No.", NSSalesCrMemoHdr."No.");
        NSApplyFromCustLedgerEntry.SetRange("Customer No.", NSSalesCrMemoHdr."Bill-to Customer No.");
        NSApplyFromCustLedgerEntry.SetRange("NS_Job No.", NSSalesCrMemoHdr."NS_Job No.");
        //NSApplyFromCustLedgerEntry.SetRange("NS_Retention Ledger Code", 'RETENTION');
        NSApplyFromCustLedgerEntry.SetRange("NS_Retention Ledger Code", NSJobsSetup."NS_Retention Receivable Ledger");
        NSApplyFromCustLedgerEntry.SetRange(Open, true);
        if NSApplyFromCustLedgerEntry.FindFirst() then begin
            NSApplyFromCustLedgerEntry.CalcFields("Remaining Amount");
            if NSApplyFromCustLedgerEntry."Remaining Amount" <> 0 then begin
                NSApplyToCustLedgerEntry.Reset();
                NSApplyToCustLedgerEntry.SetRange("Document Type", NSApplyToCustLedgerEntry."Document Type"::Invoice);
                NSApplyToCustLedgerEntry.SetRange("Document No.", NSApplyFromCustLedgerEntry."NS_AppliesToDocument No.");
                NSApplyToCustLedgerEntry.SetRange("Customer No.", NSApplyFromCustLedgerEntry."Customer No.");
                NSApplyToCustLedgerEntry.SetRange("NS_Job No.", NSApplyFromCustLedgerEntry."NS_Job No.");
                NSApplyToCustLedgerEntry.SetRange("NS_Retention Ledger Code", NSApplyFromCustLedgerEntry."NS_Retention Ledger Code");
                NSApplyToCustLedgerEntry.SetRange(Open, true);
                if NSApplyToCustLedgerEntry.FindFirst() then begin
                    NSMarkSCMSourceEntryinCustLedgEntry(NSApplyFromCustLedgerEntry);
                    NSFinalApplySelectedCustLedgEntry(NSApplyFromCustLedgerEntry, NSApplyToCustLedgerEntry);
                end;
            end;
            Commit();
        end;
    end;

    procedure NSApplyNormalSCMFromNormalInvoice(var NSSalesCrMemoHdr: Record "Sales Cr.Memo Header")
    var
        NSApplyFromCustLedgerEntry: Record "Cust. Ledger Entry";
        NSApplyToCustLedgerEntry: Record "Cust. Ledger Entry";
        NSCustEntryApplyPostEntries: Codeunit "CustEntry-Apply Posted Entries";
        NSSalesNRecSetup: Record "Sales & Receivables Setup";
    begin

        // applying 'Retention' ledger entry
        if NSSalesNRecSetup.get() then;
        NSApplyFromCustLedgerEntry.Reset();
        NSApplyFromCustLedgerEntry.SetRange("Document Type", NSApplyFromCustLedgerEntry."Document Type"::"Credit Memo");
        NSApplyFromCustLedgerEntry.SetRange("Document No.", NSSalesCrMemoHdr."No.");
        NSApplyFromCustLedgerEntry.SetRange("Customer No.", NSSalesCrMemoHdr."Bill-to Customer No.");
        NSApplyFromCustLedgerEntry.SetRange("NS_Job No.", NSSalesCrMemoHdr."NS_Job No.");
        NSApplyFromCustLedgerEntry.SetRange(Open, true);
        //NSApplyFromCustLedgerEntry.SetRange("NS_Retention Ledger Code", 'NORMAL');
        NSApplyFromCustLedgerEntry.Setfilter("NS_Retention Ledger Code", '%1', NSSalesNRecSetup."NS_Normal Customer Ledger No.");
        if NSApplyFromCustLedgerEntry.FindFirst() then begin
            NSApplyFromCustLedgerEntry.CalcFields("Remaining Amount");
            if NSApplyFromCustLedgerEntry."Remaining Amount" <> 0 then begin
                NSApplyToCustLedgerEntry.Reset();
                NSApplyToCustLedgerEntry.SetRange("Document Type", NSApplyToCustLedgerEntry."Document Type"::Invoice);
                NSApplyToCustLedgerEntry.SetRange("Document No.", NSApplyFromCustLedgerEntry."NS_AppliesToDocument No.");
                NSApplyToCustLedgerEntry.SetRange("Customer No.", NSApplyFromCustLedgerEntry."Customer No.");
                NSApplyToCustLedgerEntry.SetRange("NS_Job No.", NSApplyFromCustLedgerEntry."NS_Job No.");
                NSApplyToCustLedgerEntry.Setfilter("NS_Retention Ledger Code", '%1', NSApplyFromCustLedgerEntry."NS_Retention Ledger Code");
                NSApplyToCustLedgerEntry.SetRange(Open, true);
                if NSApplyToCustLedgerEntry.FindFirst() then begin
                    NSMarkSCMSourceEntryinCustLedgEntry(NSApplyFromCustLedgerEntry);
                    NSFinalApplySelectedCustLedgEntry(NSApplyFromCustLedgerEntry, NSApplyToCustLedgerEntry);
                end;
            end;
            Commit();
        end;
    end;

    procedure NSFinalApplySelectedCustLedgEntry(var FromCustLedgentry: Record "Cust. Ledger Entry"; var ToCustLedgEntry: Record "Cust. Ledger Entry")
    var
        NSCannotApplyClosedEntriesErr: Label 'One or more of the entries that you selected is closed. You cannot apply closed entries.';
        NSCustLedgEntry: Record "Cust. Ledger Entry";
        NSApplyUnapplyParameters: Record "Apply Unapply Parameters";
        NSGenJnlBatch: Record "Gen. Journal Batch";
        NSGLSetup: Record "General Ledger Setup";
        NSCustEntryApplID: Code[50];
    begin
        NSCustEntryApplID := UserId;

        if not ToCustLedgEntry.Open then
            Error(NSCannotApplyClosedEntriesErr);

        if ToCustLedgEntry."Remaining Amount" = 0 then
            ToCustLedgEntry.CalcFields("Remaining Amount");

        ToCustLedgEntry."Applying Entry" := true;
        ToCustLedgEntry."Applies-to ID" := NSCustEntryApplID;
        ToCustLedgEntry."Amount to Apply" := ToCustLedgEntry."Remaining Amount";
        CODEUNIT.Run(CODEUNIT::"Cust. Entry-Edit", ToCustLedgEntry);
        Commit();

        Clear(NSApplyUnapplyParameters);
        NSGLSetup.GetRecordOnce();
        if NSGLSetup."Journal Templ. Name Mandatory" then begin
            NSGLSetup.TestField("Apply Jnl. Template Name");
            NSGLSetup.TestField("Apply Jnl. Batch Name");
            NSApplyUnapplyParameters."Journal Template Name" := NSGLSetup."Apply Jnl. Template Name";
            NSApplyUnapplyParameters."Journal Batch Name" := NSGLSetup."Apply Jnl. Batch Name";
            NSGenJnlBatch.Get(NSGLSetup."Apply Jnl. Template Name", NSGLSetup."Apply Jnl. Batch Name");
        end;
        NSApplyUnapplyParameters."Document No." := ToCustLedgEntry."Document No.";

        NSAutoApplySCM(ToCustLedgEntry, NSApplyUnapplyParameters);

    end;

    procedure NSMarkSCMSourceEntryinCustLedgEntry(var FromCustLedgentry: Record "Cust. Ledger Entry")
    var
        NSCannotApplyClosedEntriesErr: Label 'One or more of the entries that you selected is closed. You cannot apply closed entries.';
        NSCustLedgEntry: Record "Cust. Ledger Entry";
        NSApplyUnapplyParameters: Record "Apply Unapply Parameters";
        NSGenJnlBatch: Record "Gen. Journal Batch";
        NSGLSetup: Record "General Ledger Setup";
        NSCustEntryApplID: Code[50];
    begin
        NSCustEntryApplID := UserId;

        //if FromCustLedgentry."Remaining Amount" = 0 then
        if FromCustLedgentry."Remaining Amount" <> 0 then
            FromCustLedgentry.CalcFields("Remaining Amount");

        FromCustLedgentry."Applying Entry" := true;
        FromCustLedgentry."Applies-to ID" := NSCustEntryApplID;
        FromCustLedgentry."Amount to Apply" := FromCustLedgentry."Remaining Amount";
        CODEUNIT.Run(CODEUNIT::"Cust. Entry-Edit", FromCustLedgentry);
        Commit();

    end;

    procedure NSFlowNSAppliesDocTypeAndNSAppliesDocNoInRetentionCLE(var NSSalesCrMemoHdr: Record "Sales Cr.Memo Header")
    var
        NSApplyFromCustLedgerEntry: Record "Cust. Ledger Entry";
        NSSalesNRecSetup: Record "Sales & Receivables Setup";
        NSJobsSetup: Record "Jobs Setup";
    begin
        if NSJobsSetup.get() then;
        if NSSalesNRecSetup.get() then;
        if NSSalesNRecSetup."NS_AutoApplySCM After Posting" = true then begin
            NSApplyFromCustLedgerEntry.Reset();
            NSApplyFromCustLedgerEntry.SetRange("Document Type", NSApplyFromCustLedgerEntry."Document Type"::"Credit Memo");
            NSApplyFromCustLedgerEntry.SetRange("Document No.", NSSalesCrMemoHdr."No.");
            NSApplyFromCustLedgerEntry.SetRange("Customer No.", NSSalesCrMemoHdr."Bill-to Customer No.");
            NSApplyFromCustLedgerEntry.SetRange("NS_Job No.", NSSalesCrMemoHdr."NS_Job No.");
            NSApplyFromCustLedgerEntry.SetRange("NS_Retention Ledger Code", NSJobsSetup."NS_Retention Receivable Ledger");
            NSApplyFromCustLedgerEntry.SetRange(Open, true);
            if NSApplyFromCustLedgerEntry.FindFirst() then begin
                NSApplyFromCustLedgerEntry."NS_AppliesToDocument Type" := NSSalesCrMemoHdr."NS_AppliesToDocument Type";
                NSApplyFromCustLedgerEntry."NS_AppliesToDocument No." := NSSalesCrMemoHdr."NS_AppliesToDocument No.";
                NSApplyFromCustLedgerEntry.Modify();
                Commit();
            end;
        end;
    end;
    //PE-302.JS.1.0 30MAY2024-end


    local procedure NSAutoApplySCM(CustLedgEntry: Record "Cust. Ledger Entry"; ApplyUnapplyParameters: Record "Apply Unapply Parameters"): Boolean
    var
        NSMustNotBeBeforeErr: Label 'The posting date entered must not be before the posting date on the Cust. Ledger Entry.';
        NSPaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        IsHandled: Boolean;
    begin
        CustLedgEntry.Get(CustLedgEntry."Entry No.");

        if ApplyUnapplyParameters."Posting Date" = 0D then
            ApplyUnapplyParameters."Posting Date" := NSGetApplicationDate(CustLedgEntry)
        else
            if ApplyUnapplyParameters."Posting Date" < NSGetApplicationDate(CustLedgEntry) then
                Error(NSMustNotBeBeforeErr);

        if ApplyUnapplyParameters."Document No." = '' then
            ApplyUnapplyParameters."Document No." := CustLedgEntry."Document No.";

        NSCustPostApplyCustLedgEntry(CustLedgEntry, ApplyUnapplyParameters);  //*****Neet to check
        exit(true);
    end;

    local procedure NSGetApplicationDate(CustLedgEntry: Record "Cust. Ledger Entry") ApplicationDate: Date
    var
        NSApplyToCustLedgEntry: Record "Cust. Ledger Entry";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit(ApplicationDate);

        ApplicationDate := 0D;
        NSApplyToCustLedgEntry.SetCurrentKey("Customer No.", "Applies-to ID");
        NSApplyToCustLedgEntry.SetRange("Customer No.", CustLedgEntry."Customer No.");
        NSApplyToCustLedgEntry.SetRange("Applies-to ID", CustLedgEntry."Applies-to ID");
        NSApplyToCustLedgEntry.FindSet();
        repeat
            if NSApplyToCustLedgEntry."Posting Date" > ApplicationDate then
                ApplicationDate := NSApplyToCustLedgEntry."Posting Date";
        until NSApplyToCustLedgEntry.Next() = 0;
    end;

    local procedure NSCustPostApplyCustLedgEntry(CustLedgEntry: Record "Cust. Ledger Entry"; ApplyUnapplyParameters: Record "Apply Unapply Parameters")
    var
        NSNoEntriesAppliedErr: Label 'Cannot post because you did not specify which entry to apply. You must specify an entry in the %1 field for one or more open entries.', Comment = '%1 - Caption of "Applies to ID" field of Gen. Journal Line';
        NSSourceCodeSetup: Record "Source Code Setup";
        NSGenJnlLine: Record "Gen. Journal Line";
        NSGenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        NSEntryNoBeforeApplication: Integer;
        NSEntryNoAfterApplication: Integer;
        NSSuppressCommit: Boolean;
        IsHandled: Boolean;
    begin
        NSSourceCodeSetup.Get();

        NSGenJnlLine.Init();
        NSGenJnlLine."Document No." := ApplyUnapplyParameters."Document No.";
        NSGenJnlLine."Posting Date" := ApplyUnapplyParameters."Posting Date";
        NSGenJnlLine."VAT Reporting Date" := NSGenJnlLine."Posting Date";
        NSGenJnlLine."Document Date" := NSGenJnlLine."Posting Date";
        NSGenJnlLine."Account Type" := NSGenJnlLine."Account Type"::Customer;
        NSGenJnlLine."Account No." := CustLedgEntry."Customer No.";
        CustLedgEntry.CalcFields("Debit Amount", "Credit Amount", "Debit Amount (LCY)", "Credit Amount (LCY)");
        NSGenJnlLine.Correction :=
            (CustLedgEntry."Debit Amount" < 0) or (CustLedgEntry."Credit Amount" < 0) or
            (CustLedgEntry."Debit Amount (LCY)" < 0) or (CustLedgEntry."Credit Amount (LCY)" < 0);
        NSGenJnlLine.CopyCustLedgEntry(CustLedgEntry);
        NSGenJnlLine."Source Code" := NSSourceCodeSetup."Sales Entry Application";
        NSGenJnlLine."System-Created Entry" := true;
        NSGenJnlLine."Journal Template Name" := ApplyUnapplyParameters."Journal Template Name";
        NSGenJnlLine."Journal Batch Name" := ApplyUnapplyParameters."Journal Batch Name";

        NSEntryNoBeforeApplication := NSFindLastApplDtldCustLedgEntry();

        NSGenJnlPostLine.CustPostApplyCustLedgEntry(NSGenJnlLine, CustLedgEntry);

        NSEntryNoAfterApplication := NSFindLastApplDtldCustLedgEntry();

        // if NSEntryNoAfterApplication = NSEntryNoBeforeApplication then
        //     Error(NSNoEntriesAppliedErr, NSGenJnlLine.FieldCaption("Applies-to ID"));

        NSRunUpdateAnalysisView();
    end;


    local procedure NSFindLastApplDtldCustLedgEntry(): Integer
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        DtldCustLedgEntry.LockTable();
        exit(DtldCustLedgEntry.GetLastEntryNo());
    end;

    local procedure NSRunUpdateAnalysisView()
    var
        NSUpdateAnalysisView: Codeunit "Update Analysis View";
        IsHandled: Boolean;
    begin
        NSUpdateAnalysisView.UpdateAll(0, true);
    end;

    //PE-225.PS.1.0 18June2024 Start
    procedure NSApplyRetentionSalesInvFromRetentionInvoice(var NSPostedSalesInv: Record "Sales Invoice Header")
    var
        NSApplyFromCustLedgerEntry: Record "Cust. Ledger Entry";
        NSApplyToCustLedgerEntry: Record "Cust. Ledger Entry";
        NSCustEntryApplyPostEntries: Codeunit "CustEntry-Apply Posted Entries";
        NSSalesNRecSetup: Record "Sales & Receivables Setup";
        NSJobsSetup: Record "Jobs Setup";
    begin
        // applying 'Retention' ledger entry
        if NSJobsSetup.get() then;
        if NSSalesNRecSetup.get() then;
        NSApplyFromCustLedgerEntry.Reset();
        NSApplyFromCustLedgerEntry.SetRange("Document Type", NSApplyFromCustLedgerEntry."Document Type"::"Credit Memo");
        NSApplyFromCustLedgerEntry.SetRange("Document No.", NSPostedSalesInv."No.");
        NSApplyFromCustLedgerEntry.SetRange("Customer No.", NSPostedSalesInv."Bill-to Customer No.");
        NSApplyFromCustLedgerEntry.SetRange("NS_Job No.", NSPostedSalesInv."NS_Job No.");
        NSApplyFromCustLedgerEntry.SetRange("NS_Retention Ledger Code", NSJobsSetup."NS_Retention Receivable Ledger");
        NSApplyFromCustLedgerEntry.SetRange(Open, true);
        if NSApplyFromCustLedgerEntry.FindFirst() then begin
            NSApplyFromCustLedgerEntry.CalcFields("Remaining Amount");
            if NSApplyFromCustLedgerEntry."Remaining Amount" <> 0 then begin
                NSApplyToCustLedgerEntry.Reset();
                NSApplyToCustLedgerEntry.SetRange("Document Type", NSApplyToCustLedgerEntry."Document Type"::Invoice);
                NSApplyToCustLedgerEntry.SetRange("Document No.", NSApplyFromCustLedgerEntry."NS_AppliesToDocument No.");
                NSApplyToCustLedgerEntry.SetRange("Customer No.", NSApplyFromCustLedgerEntry."Customer No.");
                NSApplyToCustLedgerEntry.SetRange("NS_Job No.", NSApplyFromCustLedgerEntry."NS_Job No.");
                NSApplyToCustLedgerEntry.SetRange("NS_Retention Ledger Code", NSApplyFromCustLedgerEntry."NS_Retention Ledger Code");
                NSApplyToCustLedgerEntry.SetRange(Open, true);
                if NSApplyToCustLedgerEntry.FindFirst() then begin
                    NSMarkSCMSourceEntryinCustLedgEntry(NSApplyFromCustLedgerEntry);
                    NSFinalApplySelectedCustLedgEntry(NSApplyFromCustLedgerEntry, NSApplyToCustLedgerEntry);
                end;
            end;
            Commit();
        end;
    end;

    procedure NSApplyRetentionSalesInvPromRetentionInvoice(var NSPostedSalesInv: Record "Sales Invoice Header")
    var
        NSApplyFromCustLedgerEntry: Record "Cust. Ledger Entry";
        NSApplyToCustLedgerEntry: Record "Cust. Ledger Entry";
        NSCustEntryApplyPostEntries: Codeunit "CustEntry-Apply Posted Entries";
        NSSalesNRecSetup: Record "Sales & Receivables Setup";
        NSJobsSetup: Record "Jobs Setup";
        NS_Description: Code[100];
    begin
        // applying 'Retention' ledger entry
        NS_Description := '"Retention for Job "' + NSPostedSalesInv."NS_Job No.";
        if NSJobsSetup.get() then;
        if NSSalesNRecSetup.get() then;
        NSApplyFromCustLedgerEntry.Reset();
        NSApplyFromCustLedgerEntry.SetRange("Document Type", NSApplyFromCustLedgerEntry."Document Type"::Invoice);
        // NSApplyFromCustLedgerEntry.SetRange("Document No.", NSPostedSalesInv."No.");
        NSApplyFromCustLedgerEntry.SetRange("Customer No.", NSPostedSalesInv."Bill-to Customer No.");
        NSApplyFromCustLedgerEntry.SetRange("NS_Job No.", NSPostedSalesInv."NS_Job No.");
        NSApplyFromCustLedgerEntry.SetRange("NS_Retention Ledger Code", 'RETENTION');
        NSApplyFromCustLedgerEntry.SetRange("NS_Retention Document", false);
        // NSApplyFromCustLedgerEntry.SetFilter(Description, '<>%1', NS_Description);
        NSApplyFromCustLedgerEntry.SetRange(Open, true);
        if NSApplyFromCustLedgerEntry.FindSet() then begin
            // Message('Normal..%1', Format(NSApplyFromCustLedgerEntry.Count));
            repeat
                NSApplyFromCustLedgerEntry.CalcFields("Remaining Amount");
                if NSApplyFromCustLedgerEntry."Remaining Amount" <> 0 then begin
                    NSApplyToCustLedgerEntry.Reset();
                    NSApplyToCustLedgerEntry.SetRange("Document Type", NSApplyToCustLedgerEntry."Document Type"::Invoice);
                    NSApplyToCustLedgerEntry.SetRange("Customer No.", NSApplyFromCustLedgerEntry."Customer No.");
                    NSApplyToCustLedgerEntry.SetRange("NS_Job No.", NSApplyFromCustLedgerEntry."NS_Job No.");
                    NSApplyToCustLedgerEntry.SetRange("NS_Retention Ledger Code", 'RETENTION');
                    // NSApplyToCustLedgerEntry.SetRange(Description, NS_Description);
                    NSApplyToCustLedgerEntry.SetRange("NS_Retention Document", true);
                    NSApplyToCustLedgerEntry.SetRange(Open, true);
                    if NSApplyToCustLedgerEntry.FindSet() then begin
                        // Message('Rete..%1', Format(NSApplyToCustLedgerEntry.Count));
                        repeat
                            NSMarkSCMSourceEntryinCustLedgEntry(NSApplyFromCustLedgerEntry);
                            NSFinalApplySalesInvSelectedCustLedgEntry(NSApplyFromCustLedgerEntry, NSApplyToCustLedgerEntry);
                        until NSApplyToCustLedgerEntry.Next = 0;
                    end;

                end;
            Until NSApplyFromCustLedgerEntry.Next = 0;

            Commit();

            // NS_Description := '"Retention for Job "' + NSPostedSalesInv."NS_Job No.";
            // if NSJobsSetup.get() then;
            // if NSSalesNRecSetup.get() then;
            // NSApplyFromCustLedgerEntry.Reset();
            // NSApplyFromCustLedgerEntry.SetRange("Document Type", NSApplyFromCustLedgerEntry."Document Type"::Invoice);
            // // NSApplyFromCustLedgerEntry.SetRange("Document No.", NSPostedSalesInv."No.");
            // NSApplyFromCustLedgerEntry.SetRange("Customer No.", NSPostedSalesInv."Bill-to Customer No.");
            // NSApplyFromCustLedgerEntry.SetRange("NS_Job No.", NSPostedSalesInv."NS_Job No.");
            // NSApplyFromCustLedgerEntry.SetRange("NS_Retention Ledger Code", 'RETENTION');
            // NSApplyFromCustLedgerEntry.SetFilter(Description, '<>%1', NS_Description);
            // NSApplyFromCustLedgerEntry.SetRange(Open, true);
            // if NSApplyFromCustLedgerEntry.FindSet() then begin
            //     Message('Normal..%1', Format(NSApplyFromCustLedgerEntry.Count));
            //     repeat
            //         NSApplyFromCustLedgerEntry.CalcFields("Remaining Amount");
            //         if NSApplyFromCustLedgerEntry."Remaining Amount" <> 0 then begin
            //             NSApplyToCustLedgerEntry.Reset();
            //             NSApplyToCustLedgerEntry.SetRange("Document Type", NSApplyToCustLedgerEntry."Document Type"::Invoice);
            //             NSApplyToCustLedgerEntry.SetRange("Customer No.", NSApplyFromCustLedgerEntry."Customer No.");
            //             NSApplyToCustLedgerEntry.SetRange("NS_Job No.", NSApplyFromCustLedgerEntry."NS_Job No.");
            //             NSApplyToCustLedgerEntry.SetRange("NS_Retention Ledger Code", 'RETENTION');
            //             NSApplyToCustLedgerEntry.SetRange(Description, NS_Description);
            //             NSApplyToCustLedgerEntry.SetRange("NS_Retention Document", true);
            //             NSApplyToCustLedgerEntry.SetRange(Open, true);
            //             if NSApplyToCustLedgerEntry.FindSet() then begin
            //                 Message('Rete..%1', Format(NSApplyToCustLedgerEntry.Count));
            //                 repeat
            //                     NSMarkSCMSourceEntryinCustLedgEntry(NSApplyFromCustLedgerEntry);
            //                     NSFinalApplySalesInvSelectedCustLedgEntry(NSApplyFromCustLedgerEntry, NSApplyToCustLedgerEntry);
            //                 until NSApplyToCustLedgerEntry.Next = 0;
            //             end;

            //         end;
            //     Until NSApplyFromCustLedgerEntry.Next = 0;

            //     Commit();


            //     NS_Description := '"Retention for Job "' + NSPostedSalesInv."NS_Job No.";
            //     if NSJobsSetup.get() then;
            //     if NSSalesNRecSetup.get() then;
            //     NSApplyFromCustLedgerEntry.Reset();
            //     NSApplyFromCustLedgerEntry.SetRange("Document Type", NSApplyFromCustLedgerEntry."Document Type"::Invoice);
            //     // NSApplyFromCustLedgerEntry.SetRange("Document No.", NSPostedSalesInv."No.");
            //     NSApplyFromCustLedgerEntry.SetRange("Customer No.", NSPostedSalesInv."Bill-to Customer No.");
            //     NSApplyFromCustLedgerEntry.SetRange("NS_Job No.", NSPostedSalesInv."NS_Job No.");
            //     NSApplyFromCustLedgerEntry.SetRange("NS_Retention Ledger Code", 'RETENTION');
            //     NSApplyFromCustLedgerEntry.SetFilter(Description, '<>%1', NS_Description);
            //     NSApplyFromCustLedgerEntry.SetRange(Open, true);
            //     if NSApplyFromCustLedgerEntry.FindSet() then begin
            //         Message('Normal..%1', Format(NSApplyFromCustLedgerEntry.Count));
            //         repeat
            //             NSApplyFromCustLedgerEntry.CalcFields("Remaining Amount");
            //             if NSApplyFromCustLedgerEntry."Remaining Amount" <> 0 then begin
            //                 NSApplyToCustLedgerEntry.Reset();
            //                 NSApplyToCustLedgerEntry.SetRange("Document Type", NSApplyToCustLedgerEntry."Document Type"::Invoice);
            //                 NSApplyToCustLedgerEntry.SetRange("Customer No.", NSApplyFromCustLedgerEntry."Customer No.");
            //                 NSApplyToCustLedgerEntry.SetRange("NS_Job No.", NSApplyFromCustLedgerEntry."NS_Job No.");
            //                 NSApplyToCustLedgerEntry.SetRange("NS_Retention Ledger Code", 'RETENTION');
            //                 NSApplyToCustLedgerEntry.SetRange(Description, NS_Description);
            //                 NSApplyToCustLedgerEntry.SetRange("NS_Retention Document", true);
            //                 NSApplyToCustLedgerEntry.SetRange(Open, true);
            //                 if NSApplyToCustLedgerEntry.FindSet() then begin
            //                     Message('Rete..%1', Format(NSApplyToCustLedgerEntry.Count));
            //                     repeat
            //                         NSMarkSCMSourceEntryinCustLedgEntry(NSApplyFromCustLedgerEntry);
            //                         NSFinalApplySalesInvSelectedCustLedgEntry(NSApplyFromCustLedgerEntry, NSApplyToCustLedgerEntry);
            //                     until NSApplyToCustLedgerEntry.Next = 0;
            //                 end;

            //             end;
            //         Until NSApplyFromCustLedgerEntry.Next = 0;

            //         Commit();
            //     End;
            // end;
        end;
    End;


    local procedure NSAutoApplySalesInv(CustLedgEntry: Record "Cust. Ledger Entry"; ApplyUnapplyParameters: Record "Apply Unapply Parameters"): Boolean
    var
        NSMustNotBeBeforeErr: Label 'The posting date entered must not be before the posting date on the Cust. Ledger Entry.';
        NSPaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        IsHandled: Boolean;
        NS_PostApplication: Page "Post Application";
    begin
        CustLedgEntry.Get(CustLedgEntry."Entry No.");

        if ApplyUnapplyParameters."Posting Date" = 0D then
            ApplyUnapplyParameters."Posting Date" := NSGetApplicationDate(CustLedgEntry)
        else
            if ApplyUnapplyParameters."Posting Date" < NSGetApplicationDate(CustLedgEntry) then
                Error(NSMustNotBeBeforeErr);

        if ApplyUnapplyParameters."Document No." = '' then
            ApplyUnapplyParameters."Document No." := CustLedgEntry."Document No.";
        NSCustPostApplyCustLedgEntry(CustLedgEntry, ApplyUnapplyParameters);  //*****Neet to check //Change by PS here open posting Dailogbox
        exit(true);
    end;


    procedure NSFinalApplySalesInvSelectedCustLedgEntry(var FromCustLedgentry: Record "Cust. Ledger Entry"; var ToCustLedgEntry: Record "Cust. Ledger Entry")
    var
        NSCannotApplyClosedEntriesErr: Label 'One or more of the entries that you selected is closed. You cannot apply closed entries.';
        NSCustLedgEntry: Record "Cust. Ledger Entry";
        NSApplyUnapplyParameters: Record "Apply Unapply Parameters";
        NSGenJnlBatch: Record "Gen. Journal Batch";
        NSGLSetup: Record "General Ledger Setup";
        NSCustEntryApplID: Code[50];
    begin
        NSCustEntryApplID := UserId;

        if not ToCustLedgEntry.Open then
            Error(NSCannotApplyClosedEntriesErr);

        ToCustLedgEntry.CalcFields("Remaining Amount");

        ToCustLedgEntry."Applying Entry" := true;
        ToCustLedgEntry."Applies-to ID" := NSCustEntryApplID;
        ToCustLedgEntry."Amount to Apply" := ToCustLedgEntry."Remaining Amount";
        CODEUNIT.Run(CODEUNIT::"Cust. Entry-Edit", ToCustLedgEntry);
        Commit();

        Clear(NSApplyUnapplyParameters);
        NSGLSetup.GetRecordOnce();
        if NSGLSetup."Journal Templ. Name Mandatory" then begin
            NSGLSetup.TestField("Apply Jnl. Template Name");
            NSGLSetup.TestField("Apply Jnl. Batch Name");
            NSApplyUnapplyParameters."Journal Template Name" := NSGLSetup."Apply Jnl. Template Name";
            NSApplyUnapplyParameters."Journal Batch Name" := NSGLSetup."Apply Jnl. Batch Name";
            NSGenJnlBatch.Get(NSGLSetup."Apply Jnl. Template Name", NSGLSetup."Apply Jnl. Batch Name");
        end;
        NSApplyUnapplyParameters."Document No." := ToCustLedgEntry."Document No.";

        NSAutoApplySalesInv(ToCustLedgEntry, NSApplyUnapplyParameters);

    end;
    //PE-225.PS.1.0 18June2024 End

}
