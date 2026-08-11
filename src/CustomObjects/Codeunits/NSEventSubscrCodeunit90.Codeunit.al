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
    //PRJ-1194.NK.1.0 29Apr2022 | Add Code
    //PRJ-1387.NK.1.0 12May2022 | Add Code
    //PRJ-1380.NK.1.0 13May2022 | Added code for purchaser code flow
    //PRJ-1651.JS.1.0 29SEP2022 | Validation Check for FA Resource Issue
    //PRJ-1655.JS.1.0 11OCT2022 | Correct condition for Staged Qty.
    //PRJ-1740.SD.1.0 15Dec2022 | Code addded to check value of "Job Cost Category" in Resource.
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

    [Obsolete('Replaced by Microsoft with OnPostLinesOnBeforeGenJnlLinePost() in codeunit 826 "Purch. Post Invoice Events.', '22.0')]//PE-129.AS.2.0
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

    //PE-129.AS.2.0 start Add
    [EventSubscriber(ObjectType::Codeunit, 826, 'OnPostLinesOnBeforeGenJnlLinePost', '', false, false)]
    local procedure NS_C826OnPostLinesOnBeforeGenJnlLinePost(var GenJnlLine: Record "Gen. Journal Line"; PurchHeader: Record "Purchase Header"; TempInvoicePostingBuffer: Record "Invoice Posting Buffer"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; SuppressCommit: Boolean)
    var
        NS_JobTask: Record "Job Task";
    begin
        GenJnlLine."NS_Retention Ledger Code" := TempInvoicePostingBuffer."NS_Retention Ledger Code";

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
    //PE-129.AS.2.0 end Add

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePurchRcptLineInsert', '', false, false)]
    local procedure NS_C90OnBeforePurchRcptLineInsert(var PurchRcptLine: Record "Purch. Rcpt. Line"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchLine: Record "Purchase Line"; CommitIsSupressed: Boolean)
    begin
        //PRJ-1655.JS.1.0 11OCT2022 - Start
        //PurchRcptLine.NS_Staged := true;
        //PurchRcptLine."NS_Staged Quantity" := PurchLine."Qty. to Receive";
        if PurchLine.NS_Staged then begin
            PurchRcptLine.NS_Staged := true;
            PurchRcptLine."NS_Staged Quantity" := PurchLine."Qty. to Receive";
        end;
        //PRJ-1655.JS.1.0 11OCT2022 - end


    end;
    //PRJ-1432.GK.1.0 13July2022 start
    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterPurchRcptLineInsert', '', false, false)]
    local procedure NS_C90OnafterPurchRcptLineInsert(var PurchRcptLine: Record "Purch. Rcpt. Line"; PurchRcptHeader: Record "Purch. Rcpt. Header")
    var
        JobMaterialPlanning: Record "NS_Job Material Planning";
    begin
        if (PurchRcptLine.NS_Staged = true) AND (PurchRcptLine."NS_JMP Document No." <> '') then begin//PRJ-1681.GK.1.0 19Oct2022
            JobMaterialPlanning.Reset();
            JobMaterialPlanning.SetRange("NS_Document No.", PurchRcptLine."NS_JMP Document No.");
            JobMaterialPlanning.SetRange("NS_Worksheet Job No.", PurchRcptLine."Job No.");
            JobMaterialPlanning.SetRange("NS_Order Code", PurchRcptLine."Job Task No.");
            JobMaterialPlanning.SetRange("NS_Part No.", PurchRcptLine."No.");
            //PRJ-1681.GK.1.0 19Oct2022 start
            if PurchRcptLine.Type = PurchRcptLine.Type::Item then
                JobMaterialPlanning.SetRange(NS_Type, JobMaterialPlanning.NS_Type::Item);
            if PurchRcptLine.Type = PurchRcptLine.Type::Resource then
                JobMaterialPlanning.SetRange(NS_Type, JobMaterialPlanning.NS_Type::Resource);
            if PurchRcptLine.Type = PurchRcptLine.Type::"G/L Account" then
                JobMaterialPlanning.SetRange(NS_Type, JobMaterialPlanning.NS_Type::"G/L Account");
            JobMaterialPlanning.SetRange("NS_Line No.", PurchRcptLine."NS_JMP Line No.");
            //PRJ-1681.GK.1.0 19Oct2022 end
            if JobMaterialPlanning.FindFirst() then begin
                JobMaterialPlanning."NS_Total Quantity Staged" += JobMaterialPlanning."NS_Total Quantity Staged" + PurchRcptLine.Quantity
                - JobMaterialPlanning."NS_Inventory Qty. Staged";//PE-146.NK.1.0 start 21Aug2023
                JobMaterialPlanning.Modify();
            end;
        end;
    end;
    //PRJ-1432.GK.1.0 13July2022 end


    //PRJ-1696.GK.1.0 15Dec2022 start
    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterPurchRcptLineInsert', '', false, false)]
    local procedure NS_C90OnafterPurchRcptLineInsertUpdateJLE(var PurchRcptLine: Record "Purch. Rcpt. Line"; PurchRcptHeader: Record "Purch. Rcpt. Header")
    var
        NSPurchPaySetup: Record "Purchases & Payables Setup";
        NSJobLedgerEntry: Record "Job Ledger Entry";
    begin
        if (NSPurchPaySetup.Get()) AND (NSPurchPaySetup."NS_Enab. Rcpt Int. Ent. in JLE") then begin
            if (PurchRcptLine."Job No." <> '') AND (PurchRcptLine.Type = PurchRcptLine.Type::Item) AND (PurchRcptLine."Quantity Invoiced" = 0) then begin
                NSJobLedgerEntry.Init();
                NSJobLedgerEntry."Entry No." := NSJobLedgerEntry.GetLastEntryNo() + 1;
                NSJobLedgerEntry.Insert(true);
                NSJobLedgerEntry."Posting Date" := PurchRcptLine."Posting Date";
                NSJobLedgerEntry."NS_Interim Entry" := true;
                NSJobLedgerEntry."Entry Type" := NSJobLedgerEntry."Entry Type"::Usage;
                NSJobLedgerEntry."Document No." := PurchRcptLine."Document No.";
                NSJobLedgerEntry."Job No." := PurchRcptLine."Job No.";
                NSJobLedgerEntry."Job Task No." := PurchRcptLine."Job Task No.";
                NSJobLedgerEntry."Unit of Measure Code" := PurchRcptLine."Unit of Measure Code";
                //NSJobLedgerEntry."External Document No.":=
                NSJobLedgerEntry."NS_External Relationship Type" := NSJobLedgerEntry."NS_External Relationship Type"::Vendor;
                NSJobLedgerEntry."NS_External Relationship No." := PurchRcptLine."Buy-from Vendor No.";
                NSJobLedgerEntry."NS_External Relationship Name" := PurchRcptHeader."Buy-from Vendor Name";
                NSJobLedgerEntry.Type := NSJobLedgerEntry.Type::Item;
                NSJobLedgerEntry."No." := PurchRcptLine."No.";
                NSJobLedgerEntry.Description := PurchRcptLine.Description;
                NSJobLedgerEntry."NS_Job Cost Category" := PurchRcptLine."NS_Job Cost Category";
                NSJobLedgerEntry.Validate(Quantity, PurchRcptLine.Quantity);
                NSJobLedgerEntry.Validate("Unit Cost", PurchRcptLine."Unit Cost");
                NSJobLedgerEntry.Validate("Total Cost", PurchRcptLine.Quantity * PurchRcptLine."Unit Cost");
                NSJobLedgerEntry.Validate("Unit Cost (LCY)", PurchRcptLine."Unit Cost (LCY)");
                NSJobLedgerEntry.Validate("Total Cost (LCY)", PurchRcptLine.Quantity * PurchRcptLine."Unit Cost (LCY)");
                NSJobLedgerEntry.Validate("Unit Price", PurchRcptLine."Job Unit Price");
                NSJobLedgerEntry.validate("Line Amount", (PurchRcptLine.Quantity) * (PurchRcptLine."Job Unit Price"));
                NSJobLedgerEntry."Ledger Entry Type" := NSJobLedgerEntry."Ledger Entry Type"::Item;
                NSJobLedgerEntry."NS_Accural Status" := NSJobLedgerEntry."NS_Accural Status"::NS_Open;
                NSJobLedgerEntry.Adjusted := false;
                NSJobLedgerEntry."NS_Receipt No." := PurchRcptLine."Document No.";
                NSJobLedgerEntry."NS_Receipt Line No." := PurchRcptLine."Line No.";
                NSJobLedgerEntry.Modify();

            end;
        end;
    end;

    //Undo Receipt
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Undo Purchase Receipt Line", 'OnAfterInsertNewReceiptLine', '', false, false)]
    local procedure NS_UndoReceiptLines(var PurchRcptLine: Record "Purch. Rcpt. Line")
    var
        NSPurchPaySetup: Record "Purchases & Payables Setup";
        NSJobLedgerEntry: Record "Job Ledger Entry";
        NSJobLedgerEntry1: Record "Job Ledger Entry";
    begin
        if (NSPurchPaySetup.Get()) AND (NSPurchPaySetup."NS_Enab. Rcpt Int. Ent. in JLE") then begin
            if PurchRcptLine."Job No." <> '' then begin
                NSJobLedgerEntry.Reset();
                NSJobLedgerEntry.SetRange("NS_Receipt No.", PurchRcptLine."Document No.");
                NSJobLedgerEntry.SetRange("NS_Receipt Line No.", PurchRcptLine."Line No.");
                NSJobLedgerEntry.SetRange("NS_Accural Status", NSJobLedgerEntry."NS_Accural Status"::NS_Open);
                NSJobLedgerEntry.SetRange("NS_Interim Entry", true);
                if NSJobLedgerEntry.FindFirst() then begin
                    NSJobLedgerEntry1.Init();
                    NSJobLedgerEntry1."Entry No." := NSJobLedgerEntry1.GetLastEntryNo() + 1;
                    NSJobLedgerEntry1.Insert(true);
                    NSJobLedgerEntry1."Posting Date" := NSJobLedgerEntry."Posting Date";
                    NSJobLedgerEntry1."NS_Interim Entry" := true;
                    NSJobLedgerEntry1."Entry Type" := NSJobLedgerEntry."Entry Type";
                    NSJobLedgerEntry1."Document No." := NSJobLedgerEntry."Document No.";
                    NSJobLedgerEntry1."Job No." := NSJobLedgerEntry."Job No.";
                    NSJobLedgerEntry1."Job Task No." := NSJobLedgerEntry."Job Task No.";
                    NSJobLedgerEntry1."Unit of Measure Code" := NSJobLedgerEntry."Unit of Measure Code";
                    NSJobLedgerEntry1."NS_External Relationship Type" := NSJobLedgerEntry."NS_External Relationship Type";
                    NSJobLedgerEntry1."NS_External Relationship No." := NSJobLedgerEntry."NS_External Relationship No.";
                    NSJobLedgerEntry1."NS_External Relationship Name" := NSJobLedgerEntry."NS_External Relationship Name";
                    NSJobLedgerEntry1.Type := NSJobLedgerEntry.Type;
                    NSJobLedgerEntry1."No." := NSJobLedgerEntry."No.";
                    NSJobLedgerEntry1.Description := NSJobLedgerEntry.Description;
                    NSJobLedgerEntry1."NS_Job Cost Category" := NSJobLedgerEntry."NS_Job Cost Category";
                    NSJobLedgerEntry1.Validate(Quantity, -(NSJobLedgerEntry.Quantity));
                    NSJobLedgerEntry1.Validate("Unit Cost", NSJobLedgerEntry."Unit Cost");
                    NSJobLedgerEntry1.Validate("Total Cost", -NSJobLedgerEntry."Total Cost");
                    NSJobLedgerEntry1.Validate("Unit Cost (LCY)", NSJobLedgerEntry."Unit Cost (LCY)");
                    NSJobLedgerEntry1.Validate("Total Cost (LCY)", -NSJobLedgerEntry."Total Cost (LCY)");
                    NSJobLedgerEntry1.Validate("Unit Price", NSJobLedgerEntry."Unit Price");
                    NSJobLedgerEntry1.validate("Line Amount", -NSJobLedgerEntry."Line Amount");
                    NSJobLedgerEntry1."Ledger Entry Type" := NSJobLedgerEntry."Ledger Entry Type"::Item;
                    NSJobLedgerEntry1."NS_Accural Status" := NSJobLedgerEntry."NS_Accural Status"::NS_Closed;
                    NSJobLedgerEntry1.Adjusted := false;
                    NSJobLedgerEntry1."NS_Receipt No." := NSJobLedgerEntry."NS_Receipt No.";
                    NSJobLedgerEntry1."NS_Receipt Line No." := NSJobLedgerEntry."NS_Receipt Line No.";
                    NSJobLedgerEntry1.Modify();
                    NSJobLedgerEntry."NS_Accural Status" := NSJobLedgerEntry."NS_Accural Status"::NS_Closed;
                    NSJobLedgerEntry.Modify();

                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure NS_OnAfterPostJobOnPurchaseLine(PurchInvHdrNo: Code[20]; var PurchaseHeader: Record "Purchase Header")
    var
        NSPurchPaySetup: Record "Purchases & Payables Setup";
        NSJobLedgerEntry: Record "Job Ledger Entry";
        NSPurchInvLine: Record "Purch. Inv. Line";
        NSJobLedgerEntry1: Record "Job Ledger Entry";
        NSJobLedgerEntry2: Record "Job Ledger Entry";
        NSJobLedgerEntry3: Record "Job Ledger Entry";
        NSError: Label 'You can not reverse more than actual Intrim Entry in Job Ledger Entry';
    begin
        if (NSPurchPaySetup.Get()) AND (NSPurchPaySetup."NS_Enab. Rcpt Int. Ent. in JLE") then begin
            if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice then begin
                NSPurchInvLine.Reset();
                NSPurchInvLine.SetRange("Document No.", PurchInvHdrNo);
                NSPurchInvLine.SetRange(Type, NSPurchInvLine.Type::Item);
                NSPurchInvLine.SetFilter("Job No.", '<>%1', '');
                NSPurchInvLine.SetFilter("Receipt No.", '<>%1', '');
                NSPurchInvLine.SetFilter("Receipt Line No.", '<>%1', 0);
                if NSPurchInvLine.FindSet() then begin
                    repeat
                        NSJobLedgerEntry.Reset();
                        NSJobLedgerEntry.SetRange("Document No.", NSPurchInvLine."Document No.");
                        NSJobLedgerEntry.SetRange("Entry Type", NSJobLedgerEntry."Entry Type"::Usage);
                        NSJobLedgerEntry.SetRange("NS_Receipt No.", NSPurchInvLine."Receipt No.");
                        NSJobLedgerEntry.SetRange("NS_Receipt Line No.", NSPurchInvLine."Receipt Line No.");
                        NSJobLedgerEntry.SetRange("NS_Interim Entry", false);
                        if NSJobLedgerEntry.FindFirst() then begin
                            NSJobLedgerEntry1.Reset();
                            NSJobLedgerEntry1.SetRange("NS_Receipt No.", NSJobLedgerEntry."NS_Receipt No.");
                            NSJobLedgerEntry1.SetRange("Entry Type", NSJobLedgerEntry1."Entry Type"::Usage);
                            NSJobLedgerEntry1.SetRange("NS_Receipt Line No.", NSJobLedgerEntry."NS_Receipt Line No.");
                            NSJobLedgerEntry1.SetRange("NS_Accural Status", NSJobLedgerEntry1."NS_Accural Status"::NS_Open);
                            NSJobLedgerEntry1.SetRange("NS_Interim Entry", true);
                            if NSJobLedgerEntry1.FindFirst() then begin
                                if NSJobLedgerEntry1.Quantity > NSJobLedgerEntry.Quantity then begin
                                    NSJobLedgerEntry2.Init();
                                    NSJobLedgerEntry2."Entry No." := NSJobLedgerEntry2.GetLastEntryNo() + 1;
                                    NSJobLedgerEntry2.Insert(true);
                                    NSJobLedgerEntry2."Posting Date" := NSJobLedgerEntry1."Posting Date";
                                    NSJobLedgerEntry2."NS_Interim Entry" := true;
                                    NSJobLedgerEntry2."Entry Type" := NSJobLedgerEntry1."Entry Type";
                                    NSJobLedgerEntry2."Document No." := NSJobLedgerEntry1."Document No.";
                                    NSJobLedgerEntry2."Job No." := NSJobLedgerEntry1."Job No.";
                                    NSJobLedgerEntry2."Job Task No." := NSJobLedgerEntry1."Job Task No.";
                                    NSJobLedgerEntry2."NS_External Relationship Type" := NSJobLedgerEntry1."NS_External Relationship Type";
                                    NSJobLedgerEntry2."NS_External Relationship No." := NSJobLedgerEntry1."NS_External Relationship No.";
                                    NSJobLedgerEntry2."NS_External Relationship Name" := NSJobLedgerEntry1."NS_External Relationship Name";
                                    NSJobLedgerEntry2.Type := NSJobLedgerEntry1.Type;
                                    NSJobLedgerEntry2."No." := NSJobLedgerEntry1."No.";
                                    NSJobLedgerEntry2.Description := NSJobLedgerEntry1.Description;
                                    NSJobLedgerEntry2."Unit of Measure Code" := NSJobLedgerEntry1."Unit of Measure Code";
                                    NSJobLedgerEntry2."NS_Job Cost Category" := NSJobLedgerEntry1."NS_Job Cost Category";
                                    NSJobLedgerEntry2.Validate(Quantity, -(NSJobLedgerEntry1.Quantity));
                                    NSJobLedgerEntry2.Validate("Unit Cost", NSJobLedgerEntry1."Unit Cost");
                                    NSJobLedgerEntry2.Validate("Total Cost", -(NSJobLedgerEntry1.Quantity * NSJobLedgerEntry1."Unit Cost"));
                                    NSJobLedgerEntry2.Validate("Unit Cost (LCY)", NSJobLedgerEntry1."Unit Cost (LCY)");
                                    NSJobLedgerEntry2.Validate("Total Cost (LCY)", -(NSJobLedgerEntry1.Quantity * NSJobLedgerEntry1."Unit Cost (LCY)"));
                                    NSJobLedgerEntry2.Validate("Unit Price", NSJobLedgerEntry1."Unit Price");
                                    NSJobLedgerEntry2.validate("Line Amount", -NSJobLedgerEntry1."Line Amount");
                                    NSJobLedgerEntry2."Ledger Entry Type" := NSJobLedgerEntry1."Ledger Entry Type"::Item;
                                    NSJobLedgerEntry2."NS_Accural Status" := NSJobLedgerEntry1."NS_Accural Status"::NS_Closed;
                                    NSJobLedgerEntry2.Adjusted := false;
                                    NSJobLedgerEntry2."NS_Receipt No." := NSJobLedgerEntry1."NS_Receipt No.";
                                    NSJobLedgerEntry2."NS_Receipt Line No." := NSJobLedgerEntry1."NS_Receipt Line No.";
                                    NSJobLedgerEntry2.Modify();
                                    NSJobLedgerEntry1."NS_Accural Status" := NSJobLedgerEntry1."NS_Accural Status"::NS_Closed;
                                    NSJobLedgerEntry1.Modify();
                                    NSJobLedgerEntry3.Init();
                                    NSJobLedgerEntry3."Entry No." := NSJobLedgerEntry3.GetLastEntryNo() + 1;
                                    NSJobLedgerEntry3.Insert(true);
                                    NSJobLedgerEntry3."Posting Date" := NSJobLedgerEntry1."Posting Date";
                                    NSJobLedgerEntry3."NS_Interim Entry" := true;
                                    NSJobLedgerEntry3."Entry Type" := NSJobLedgerEntry1."Entry Type";
                                    NSJobLedgerEntry3."Document No." := NSJobLedgerEntry1."Document No.";
                                    NSJobLedgerEntry3."Job No." := NSJobLedgerEntry1."Job No.";
                                    NSJobLedgerEntry3."Job Task No." := NSJobLedgerEntry1."Job Task No.";
                                    NSJobLedgerEntry3."NS_External Relationship Type" := NSJobLedgerEntry1."NS_External Relationship Type";
                                    NSJobLedgerEntry3."NS_External Relationship No." := NSJobLedgerEntry1."NS_External Relationship No.";
                                    NSJobLedgerEntry3."NS_External Relationship Name" := NSJobLedgerEntry1."NS_External Relationship Name";
                                    NSJobLedgerEntry3.Type := NSJobLedgerEntry1.Type;
                                    NSJobLedgerEntry3."No." := NSJobLedgerEntry1."No.";
                                    NSJobLedgerEntry3."Unit of Measure Code" := NSJobLedgerEntry1."Unit of Measure Code";
                                    NSJobLedgerEntry3.Description := NSJobLedgerEntry1.Description;
                                    NSJobLedgerEntry3."NS_Job Cost Category" := NSJobLedgerEntry1."NS_Job Cost Category";
                                    NSJobLedgerEntry3.Validate(Quantity, (NSJobLedgerEntry1.Quantity - NSJobLedgerEntry.Quantity));
                                    NSJobLedgerEntry3.Validate("Unit Cost", NSJobLedgerEntry1."Unit Cost");
                                    NSJobLedgerEntry3.Validate("Total Cost", ((NSJobLedgerEntry1.Quantity - NSJobLedgerEntry.Quantity) * NSJobLedgerEntry1."Unit Cost"));
                                    NSJobLedgerEntry3.Validate("Unit Cost (LCY)", NSJobLedgerEntry1."Unit Cost (LCY)");
                                    NSJobLedgerEntry3.Validate("Total Cost (LCY)", ((NSJobLedgerEntry1.Quantity - NSJobLedgerEntry.Quantity) * NSJobLedgerEntry1."Unit Cost (LCY)"));
                                    NSJobLedgerEntry3.Validate("Unit Price", NSJobLedgerEntry1."Unit Price");
                                    NSJobLedgerEntry3.validate("Line Amount", ((NSJobLedgerEntry1.Quantity - NSJobLedgerEntry.Quantity) * NSJobLedgerEntry1."Unit Price"));
                                    NSJobLedgerEntry3."Ledger Entry Type" := NSJobLedgerEntry1."Ledger Entry Type"::Item;
                                    NSJobLedgerEntry3."NS_Accural Status" := NSJobLedgerEntry1."NS_Accural Status"::NS_Open;
                                    NSJobLedgerEntry3.Adjusted := false;
                                    NSJobLedgerEntry3."NS_Receipt No." := NSJobLedgerEntry1."NS_Receipt No.";
                                    NSJobLedgerEntry3."NS_Receipt Line No." := NSJobLedgerEntry1."NS_Receipt Line No.";
                                    NSJobLedgerEntry3.Modify();
                                end;
                                if NSJobLedgerEntry1.Quantity = NSJobLedgerEntry.Quantity then begin
                                    NSJobLedgerEntry2.Init();
                                    NSJobLedgerEntry2."Entry No." := NSJobLedgerEntry2.GetLastEntryNo() + 1;
                                    NSJobLedgerEntry2.Insert(true);
                                    NSJobLedgerEntry2."Posting Date" := NSJobLedgerEntry1."Posting Date";
                                    NSJobLedgerEntry2."NS_Interim Entry" := true;
                                    NSJobLedgerEntry2."Entry Type" := NSJobLedgerEntry1."Entry Type";
                                    NSJobLedgerEntry2."Document No." := NSJobLedgerEntry1."Document No.";
                                    NSJobLedgerEntry2."Job No." := NSJobLedgerEntry1."Job No.";
                                    NSJobLedgerEntry2."Job Task No." := NSJobLedgerEntry1."Job Task No.";
                                    NSJobLedgerEntry2."NS_External Relationship Type" := NSJobLedgerEntry1."NS_External Relationship Type";
                                    NSJobLedgerEntry2."NS_External Relationship No." := NSJobLedgerEntry1."NS_External Relationship No.";
                                    NSJobLedgerEntry2."NS_External Relationship Name" := NSJobLedgerEntry1."NS_External Relationship Name";
                                    NSJobLedgerEntry2.Type := NSJobLedgerEntry1.Type;
                                    NSJobLedgerEntry2."No." := NSJobLedgerEntry1."No.";
                                    NSJobLedgerEntry2.Description := NSJobLedgerEntry1.Description;
                                    NSJobLedgerEntry2."Unit of Measure Code" := NSJobLedgerEntry1."Unit of Measure Code";
                                    NSJobLedgerEntry2."NS_Job Cost Category" := NSJobLedgerEntry1."NS_Job Cost Category";
                                    NSJobLedgerEntry2.Validate(Quantity, -(NSJobLedgerEntry1.Quantity));
                                    NSJobLedgerEntry2.Validate("Unit Cost", NSJobLedgerEntry1."Unit Cost");
                                    NSJobLedgerEntry2.Validate("Total Cost", -NSJobLedgerEntry1."Total Cost");
                                    NSJobLedgerEntry2.Validate("Unit Cost (LCY)", NSJobLedgerEntry1."Unit Cost (LCY)");
                                    NSJobLedgerEntry2.Validate("Total Cost (LCY)", -NSJobLedgerEntry1."Total Cost (LCY)");
                                    NSJobLedgerEntry2.Validate("Unit Price", NSJobLedgerEntry1."Unit Price");
                                    NSJobLedgerEntry2.validate("Line Amount", -NSJobLedgerEntry1."Line Amount");
                                    NSJobLedgerEntry2."Ledger Entry Type" := NSJobLedgerEntry1."Ledger Entry Type"::Item;
                                    NSJobLedgerEntry2."NS_Accural Status" := NSJobLedgerEntry1."NS_Accural Status"::NS_Closed;
                                    NSJobLedgerEntry2.Adjusted := false;
                                    NSJobLedgerEntry2."NS_Receipt No." := NSJobLedgerEntry1."NS_Receipt No.";
                                    NSJobLedgerEntry2."NS_Receipt Line No." := NSJobLedgerEntry1."NS_Receipt Line No.";
                                    NSJobLedgerEntry2.Modify();
                                    NSJobLedgerEntry1."NS_Accural Status" := NSJobLedgerEntry1."NS_Accural Status"::NS_Closed;
                                    NSJobLedgerEntry1.Modify();
                                end;
                                if NSJobLedgerEntry1.Quantity < NSJobLedgerEntry.Quantity then begin
                                    Error(NSError);
                                end;

                            end;
                        end;


                    until NSPurchInvLine.Next() = 0;
                end;
            end;
        end;
    end;
    //PRJ-1696.GK.1.0 15Dec2022 end

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
            //PRJ-1194.NK.1.0 29Apr2022 Start
            if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice then
                if PurchaseHeader."NS_Retention Document" then
                    GenJournalLine."NS_Retention Document" := PurchaseHeader."NS_Retention Document";
            //PRJ-1194.NK.1.0 29Apr2022 End
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


    [Obsolete('Replaced by Microsoft with event OnPrepareLineOnAfterFillInvoicePostingBuffer in codeunit 826 "Purch. Post Invoice Events".', '22.0')]//PE-129.AS.2.0
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
        PurchInvHeader."NS_Job Purchaser" := PurchHeader."NS_Job Purchaser";  //PRJ-1380.NK.1.0 13May2022 
        PurchInvHeader."NS_Job Manager" := PurchHeader."NS_Job Manager";  //PRJ-1380.NK.1.0 13May2022 
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
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Purch.-Post", 'OnPostPurchLineOnAfterPostByType', '', false, false)]
    local procedure NS_C90OnPostPurchLineBeforeCase(PurchHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        SourceCodeSetup: Record "Source Code Setup";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
    begin
        with PurchLine do begin
            SourceCodeSetup.Get();
            case Type of
                //PRJ-52.SK.1.0 STart
                // PurchaseLine.Type::Resource:
                //     begin
                //         NS_PostResourceLine(PurchHeader, PurchaseLine, PurchInvHeader, PurchCrMemoHeader, SourceCodeSetup.Purchases);
                //         p.NS_C90SetPostPurchLine_Type(Type);
                //         Type := Type::" ";
                //     end;
                //PRJ-52.SK.1.0 End
                PurchLine.Type::NS_Ledger:
                    NS_PostLedger(PurchHeader, PurchLine, SourceCodeSetup.Purchases, GenJnlPostLine);//PRJ-205 VT 08-04-20 Added GenJnlPostLine Parameter
            end;
        end;
    end;
    //PPNA17.0 Opened End


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
                NS_OnAfterCopyFromPurchaseLine(PurchLine, NS_ResJnlLine);//PRJ-1622.GK.1.0 08Sept2022
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
    //PRJ-1380.NK.1.0 13May2022  Start
    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePurchRcptHeaderInsert', '', false, false)]
    local procedure NS_C90OnBeforePurchRcptHdrInsert(VAR PurchRcptHeader: Record "Purch. Rcpt. Header"; VAR PurchaseHeader: Record "Purchase Header"; CommitIsSupressed: Boolean)
    begin
        PurchRcptHeader."NS_Job Purchaser" := PurchaseHeader."NS_Job Purchaser";
        PurchRcptHeader."NS_Job Manager" := PurchaseHeader."NS_Job Manager";
    end;
    //PRJ-1380.NK.1.0 13May2022  End
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
        PurchLineRec: Record "Purchase Line"; //PRJ-1387.NK.1.0 12May2022
        NSPurchLineRec: Record "Purchase Line"; //PRJ-1651.JS.1.0 29SEP2022         
        NSFARec: Record "Fixed Asset";   //PRJ-1651.JS.1.0 29SEP2022
        NSResRec: Record Resource;     //PRJ-1651.JS.1.0 29SEP2022     
        NSJobsSetup: Record "Jobs Setup"; //PRJ-1740.SD.1.0 15Dec2022
    begin
        //PRJ-884.JS.1.0 24Aug2021-Start
        IF ((PurchaseHeader."NS_Retention Percent" <> 0) and (PurchaseHeader.Status = PurchaseHeader.Status::Open)) then
            IF PurchaseHeader."NS_Subcontract No." = '' then
                Error('To calculate Retention, Status must be equal to Released on Purchase Header: Document Type = %1, Document No.= %2. Current value is %3.', PurchaseHeader."Document Type",
                PurchaseHeader."No.", PurchaseHeader.Status)
            else
                Error('To calculate Retention, Status must be equal to Released on Subcontract Purchase Header: Document Type = %1, Document No.= %2. Current value is %3.', PurchaseHeader."Document Type",
                PurchaseHeader."No.", PurchaseHeader.Status);
        //PRJ-1473.GK.1.0 23June2022 start
        // //PRJ-1387.NK.1.0 12May2022 Start
        // PurchLineRec.Reset();
        // PurchLineRec.SetRange("Document No.", PurchaseHeader."No.");
        // PurchLineRec.SetFilter("Document Type", '%1|%2', PurchLineRec."Document Type"::Order, PurchLineRec."Document Type"::"Return Order");
        // PurchLineRec.SetFilter("No.", '<>%1', '');
        // if PurchLineRec.FindSet() then
        //     repeat
        //         PurchLineRec.TestField("Tax Area Code");
        //         PurchLineRec.TestField("Tax Group Code");
        //     until PurchLineRec.Next() = 0;
        // //PRJ-1387.NK.1.0 12May2022 End
        //PRJ-1473.GK.1.0 23June2022 end
        //PRJ-884.JS.1.0 24Aug2021-end

        //PRJ-1651.JS.1.0 29SEP2022 - Start
        NSPurchLineRec.Reset();
        NSPurchLineRec.SetRange("Document Type", PurchaseHeader."Document Type");
        NSPurchLineRec.SetRange("Document No.", PurchaseHeader."No.");
        NSPurchLineRec.SetFilter(Type, '%1', NSPurchLineRec.Type::"Fixed Asset");
        NSPurchLineRec.SetFilter("NS_FA Job Usage", '%1', true);
        if NSPurchLineRec.FindSet() then
            repeat
                IF NSFARec.Get(NSPurchLineRec."No.") then begin
                    NSFARec.TestField("NS_FA Res. No.");
                    if NSResRec.Get(NSFARec."NS_FA Res. No.") then begin
                        NSResRec.Testfield(Blocked, false);   //PRJ-1651.JS.1.0 11OCT2022
                        NSResRec.TestField("Base Unit of Measure");
                        NSResRec.TestField("Gen. Prod. Posting Group");
                        if NS_JobsSetup.Get() then//PRJ-1740.SD.1.0 15Dec2022 -Start
                            if (NS_JobsSetup."NS_Cost Category Required Bud") and (NS_JobsSetup."NS_Cost Category Required") then
                                NSResRec.TestField("NS_Job Cost Category");//PRJ-1740.SD.1.0 15Dec2022 -End
                    end;
                end;
                if NSPurchLineRec."NS_FA Job No." <> '' then
                    NSPurchLineRec.TestField("NS_FA Job Task No.");
            Until NSPurchLineRec.Next() = 0;
        //PRJ-1651.JS.1.0 29SEP2022 - End        

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
                    //PRJ-1686.GK.1.0 26Oct2022 start
                    //PRJ-1641.JS.1.0 23SEP2022 - Start		
                    // Licdate := DMY2Date(30, 11, 2022);
                    // Licdate := DMY2Date(31, 12, 2022);
                    // Licdate := DMY2Date(31, 1, 2023);
                    // EVALUATE(NoOfDays, FORMAT(Licdate - WorkDate));
                    // if (WorkDate > (Licdate - 15)) and (WorkDate <= Licdate) then
                    //     Message('Your ProjectPro license is going to expire in %1 days.Please contact your administrator.', NoOfDays);
                    // if WorkDate > Licdate then
                    //     Error('Your ProjectPro license has expired.Please contact your administrator.');
                    OnCheckPPLicenseExpire();   //PRJ-1641.JS.1.0 23SEP2022 line commented
                    //PRJ-1641.JS.1.0 23SEP2022 - end
                    //PRJ-1686.GK.1.0 26Oct2022 end
                end;

            end;
        end;
    end;
    //PRJ-516.MS.1.0 end


    [IntegrationEvent(false, false)]
    local procedure OnCheckPPLicenseExpire()
    begin
    end;
    //PRJ-1473.GK.1.0 23June2022 start
    // //PRJ-1387.NK.1.0 12May2022 Start
    // [EventSubscriber(ObjectType::Codeunit, 415, 'OnPerformManualReleaseOnBeforeTestPurchasePrepayment', '', false, false)]
    // local procedure TaxFieldsmandatoryReleaseAction(var PurchaseHeader: Record "Purchase Header")
    // var
    //     PurchLineRec: Record "Purchase Line";
    // begin
    //     PurchLineRec.Reset();
    //     PurchLineRec.SetRange("Document No.", PurchaseHeader."No.");
    //     PurchLineRec.SetFilter("Document Type", '%1|%2', PurchLineRec."Document Type"::Order, PurchLineRec."Document Type"::"Return Order");
    //     PurchLineRec.SetFilter("No.", '<>%1', '');
    //     if PurchLineRec.FindSet() then
    //         repeat
    //             PurchLineRec.TestField("Tax Area Code");
    //             PurchLineRec.TestField("Tax Group Code");
    //         until PurchLineRec.Next() = 0;
    // end;
    // //PRJ-1387.NK.1.0 12May2022 End
    //PRJ-1473.GK.1.0 23June2022 end
    //PRJ-1622.GK.1.0 08Sept2022 start
    [IntegrationEvent(false, false)]
    local procedure NS_OnAfterCopyFromPurchaseLine(PurchaseLine: Record "Purchase Line"; var NS_ResJnlLine: Record "Res. Journal Line")
    begin
    end;
    //PRJ-1622.GK.1.0 08Sept2022 end
    //PE-36.GK.1.0 - Start
    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterPurchInvLineInsert', '', false, false)]
    local procedure NS_C90OnRunOnAfterPostInvoiceUpdateJLE(var PurchInvLine: Record "Purch. Inv. Line"; PurchInvHeader: Record "Purch. Inv. Header"; PurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header"; PurchRcptHeader: Record "Purch. Rcpt. Header")
    var
        NSPurchPaySetup: Record "Purchases & Payables Setup";
        NSJobLedgerEntry: Record "Job Ledger Entry";
        NSPurchInvLine: Record "Purch. Inv. Line";
        NSJobLedgerEntry1: Record "Job Ledger Entry";
        NSJobLedgerEntry2: Record "Job Ledger Entry";
        NSJobLedgerEntry3: Record "Job Ledger Entry";
        NSJobLedgerEntry4: Record "Job Ledger Entry";
        NSJobLedgerEntry5: Record "Job Ledger Entry";
        NSJobLedgerEntry6: Record "Job Ledger Entry";
        NSJobLedgerEntry7: Record "Job Ledger Entry";
        NSJobLedgerEntry8: Record "Job Ledger Entry";
        NSJobLedgerEntry9: Record "Job Ledger Entry";
        NSJobLedgerEntry10: Record "Job Ledger Entry";
        NSPurchRcptLine: Record "Purch. Rcpt. Line";
        TotalQuantity: Decimal;
        RemainingQuantity: Decimal;
    begin
        if (NSPurchPaySetup.Get()) AND (NSPurchPaySetup."NS_Enab. Rcpt Int. Ent. in JLE") then begin
            if PurchHeader."Document Type" = PurchHeader."Document Type"::Order then begin
                Clear(RemainingQuantity);
                Clear(PurchInvLine);
                NSPurchInvLine.Reset();
                NSPurchInvLine.SetRange("Document No.", PurchInvHeader."No.");
                NSPurchInvLine.SetRange(Type, NSPurchInvLine.Type::Item);
                NSPurchInvLine.SetFilter("Job No.", '<>%1', '');
                if NSPurchInvLine.FindSet() then begin
                    repeat
                        TotalQuantity := NSPurchInvLine.Quantity;
                        NSPurchRcptLine.Reset();
                        NSPurchRcptLine.SetRange("Order No.", NSPurchInvLine."Order No.");
                        NSPurchRcptLine.SetRange("Order Line No.", NSPurchInvLine."Order Line No.");
                        if NSPurchRcptLine.FindSet() then
                            repeat
                                if TotalQuantity <> 0 then begin
                                    NSJobLedgerEntry.Reset();
                                    NSJobLedgerEntry.SetRange("Entry Type", NSJobLedgerEntry."Entry Type"::Usage);
                                    NSJobLedgerEntry.SetRange("NS_Receipt No.", NSPurchRcptLine."Document No.");
                                    NSJobLedgerEntry.SetRange("NS_Receipt Line No.", NSPurchRcptLine."Line No.");
                                    NSJobLedgerEntry.SetRange("NS_Interim Entry", true);
                                    NSJobLedgerEntry.SetRange("NS_Accural Status", NSJobLedgerEntry."NS_Accural Status"::NS_Open);
                                    if NSJobLedgerEntry.FindFirst() then begin
                                        //repeat
                                        if NSJobLedgerEntry.Quantity > TotalQuantity then begin
                                            NSJobLedgerEntry1.Init();
                                            NSJobLedgerEntry1."Entry No." := NSJobLedgerEntry1.GetLastEntryNo() + 1;
                                            NSJobLedgerEntry1.Insert(true);
                                            NSJobLedgerEntry1."Posting Date" := NSJobLedgerEntry."Posting Date";
                                            NSJobLedgerEntry1."NS_Interim Entry" := true;
                                            NSJobLedgerEntry1."Entry Type" := NSJobLedgerEntry."Entry Type";
                                            NSJobLedgerEntry1."Document No." := NSJobLedgerEntry."Document No.";
                                            NSJobLedgerEntry1."Job No." := NSJobLedgerEntry."Job No.";
                                            NSJobLedgerEntry1."Job Task No." := NSJobLedgerEntry."Job Task No.";
                                            NSJobLedgerEntry1."Unit of Measure Code" := NSPurchRcptLine."Unit of Measure Code";
                                            NSJobLedgerEntry1."NS_External Relationship Type" := NSJobLedgerEntry."NS_External Relationship Type";
                                            NSJobLedgerEntry1."NS_External Relationship No." := NSJobLedgerEntry."NS_External Relationship No.";
                                            NSJobLedgerEntry1."NS_External Relationship Name" := NSJobLedgerEntry."NS_External Relationship Name";
                                            NSJobLedgerEntry1.Type := NSJobLedgerEntry.Type;
                                            NSJobLedgerEntry1."No." := NSJobLedgerEntry."No.";
                                            NSJobLedgerEntry1.Description := NSJobLedgerEntry.Description;
                                            NSJobLedgerEntry1."NS_Job Cost Category" := NSJobLedgerEntry."NS_Job Cost Category";
                                            NSJobLedgerEntry1.Validate(Quantity, -(NSJobLedgerEntry.Quantity));
                                            NSJobLedgerEntry1.Validate("Unit Cost", NSJobLedgerEntry."Unit Cost");
                                            NSJobLedgerEntry1.Validate("Total Cost", -(NSJobLedgerEntry.Quantity * NSJobLedgerEntry."Unit Cost"));
                                            NSJobLedgerEntry1.Validate("Unit Cost (LCY)", NSJobLedgerEntry."Unit Cost (LCY)");
                                            NSJobLedgerEntry1.Validate("Total Cost (LCY)", -(NSJobLedgerEntry.Quantity * NSJobLedgerEntry."Unit Cost (LCY)"));
                                            NSJobLedgerEntry1.Validate("Unit Price", NSJobLedgerEntry."Unit Price");
                                            NSJobLedgerEntry1.Validate("Line Amount", -NSJobLedgerEntry."Line Amount");
                                            NSJobLedgerEntry1."Ledger Entry Type" := NSJobLedgerEntry."Ledger Entry Type"::Item;
                                            NSJobLedgerEntry1."NS_Accural Status" := NSJobLedgerEntry1."NS_Accural Status"::NS_Closed;
                                            NSJobLedgerEntry1.Adjusted := false;
                                            NSJobLedgerEntry1."NS_Receipt No." := NSJobLedgerEntry."NS_Receipt No.";
                                            NSJobLedgerEntry1."NS_Receipt Line No." := NSJobLedgerEntry."NS_Receipt Line No.";
                                            NSJobLedgerEntry1.Modify();
                                            NSJobLedgerEntry."NS_Accural Status" := NSJobLedgerEntry."NS_Accural Status"::NS_Closed;
                                            NSJobLedgerEntry.Modify();

                                            NSJobLedgerEntry2.Init();
                                            NSJobLedgerEntry2."Entry No." := NSJobLedgerEntry2.GetLastEntryNo() + 1;
                                            NSJobLedgerEntry2.Insert(true);
                                            NSJobLedgerEntry2."Posting Date" := NSJobLedgerEntry."Posting Date";
                                            NSJobLedgerEntry2."NS_Interim Entry" := true;
                                            NSJobLedgerEntry2."Entry Type" := NSJobLedgerEntry."Entry Type";
                                            NSJobLedgerEntry2."Document No." := NSJobLedgerEntry."Document No.";
                                            NSJobLedgerEntry2."Job No." := NSJobLedgerEntry."Job No.";
                                            NSJobLedgerEntry2."Job Task No." := NSJobLedgerEntry."Job Task No.";
                                            NSJobLedgerEntry2."Unit of Measure Code" := NSPurchRcptLine."Unit of Measure Code";
                                            NSJobLedgerEntry2."NS_External Relationship Type" := NSJobLedgerEntry."NS_External Relationship Type";
                                            NSJobLedgerEntry2."NS_External Relationship No." := NSJobLedgerEntry."NS_External Relationship No.";
                                            NSJobLedgerEntry2."NS_External Relationship Name" := NSJobLedgerEntry."NS_External Relationship Name";
                                            NSJobLedgerEntry2.Type := NSJobLedgerEntry1.Type;
                                            NSJobLedgerEntry2."No." := NSJobLedgerEntry1."No.";
                                            NSJobLedgerEntry2.Description := NSJobLedgerEntry1.Description;
                                            NSJobLedgerEntry2."NS_Job Cost Category" := NSJobLedgerEntry."NS_Job Cost Category";
                                            NSJobLedgerEntry2.Validate(Quantity, (NSJobLedgerEntry.Quantity - TotalQuantity));
                                            NSJobLedgerEntry2.Validate("Unit Cost", NSJobLedgerEntry."Unit Cost");
                                            NSJobLedgerEntry2.Validate("Total Cost", ((NSJobLedgerEntry.Quantity - TotalQuantity) * NSJobLedgerEntry."Unit Cost"));
                                            NSJobLedgerEntry2.Validate("Unit Cost (LCY)", NSJobLedgerEntry."Unit Cost (LCY)");
                                            NSJobLedgerEntry2.Validate("Total Cost (LCY)", ((NSJobLedgerEntry.Quantity - TotalQuantity) * NSJobLedgerEntry."Unit Cost (LCY)"));
                                            NSJobLedgerEntry2.Validate("Unit Price", NSJobLedgerEntry."Unit Price");
                                            NSJobLedgerEntry2.validate("Line Amount", ((NSJobLedgerEntry.Quantity - TotalQuantity) * NSJobLedgerEntry."Unit Price"));
                                            NSJobLedgerEntry2."Ledger Entry Type" := NSJobLedgerEntry."Ledger Entry Type"::Item;
                                            NSJobLedgerEntry2."NS_Accural Status" := NSJobLedgerEntry."NS_Accural Status"::NS_Open;
                                            NSJobLedgerEntry2.Adjusted := false;
                                            NSJobLedgerEntry2."NS_Receipt No." := NSJobLedgerEntry1."NS_Receipt No.";
                                            NSJobLedgerEntry2."NS_Receipt Line No." := NSJobLedgerEntry1."NS_Receipt Line No.";
                                            NSJobLedgerEntry2.Modify();
                                            TotalQuantity := 0;
                                        end;
                                        if NSJobLedgerEntry.Quantity = TotalQuantity then begin
                                            NSJobLedgerEntry3.Init();
                                            NSJobLedgerEntry3."Entry No." := NSJobLedgerEntry3.GetLastEntryNo() + 1;
                                            NSJobLedgerEntry3.Insert(true);
                                            NSJobLedgerEntry3."Posting Date" := NSJobLedgerEntry."Posting Date";
                                            NSJobLedgerEntry3."NS_Interim Entry" := true;
                                            NSJobLedgerEntry3."Entry Type" := NSJobLedgerEntry."Entry Type";
                                            NSJobLedgerEntry3."Document No." := NSJobLedgerEntry."Document No.";
                                            NSJobLedgerEntry3."Job No." := NSJobLedgerEntry."Job No.";
                                            NSJobLedgerEntry3."Job Task No." := NSJobLedgerEntry."Job Task No.";
                                            NSJobLedgerEntry3."Unit of Measure Code" := NSPurchRcptLine."Unit of Measure Code";
                                            NSJobLedgerEntry3."NS_External Relationship Type" := NSJobLedgerEntry."NS_External Relationship Type";
                                            NSJobLedgerEntry3."NS_External Relationship No." := NSJobLedgerEntry."NS_External Relationship No.";
                                            NSJobLedgerEntry3."NS_External Relationship Name" := NSJobLedgerEntry."NS_External Relationship Name";
                                            NSJobLedgerEntry3.Type := NSJobLedgerEntry.Type;
                                            NSJobLedgerEntry3."No." := NSJobLedgerEntry."No.";
                                            NSJobLedgerEntry3.Description := NSJobLedgerEntry.Description;
                                            NSJobLedgerEntry3."NS_Job Cost Category" := NSJobLedgerEntry."NS_Job Cost Category";
                                            NSJobLedgerEntry3.Validate(Quantity, -(NSJobLedgerEntry.Quantity));
                                            NSJobLedgerEntry3.Validate("Unit Cost", NSJobLedgerEntry."Unit Cost");
                                            NSJobLedgerEntry3.Validate("Total Cost", -NSJobLedgerEntry."Total Cost");
                                            NSJobLedgerEntry3.Validate("Unit Cost (LCY)", NSJobLedgerEntry."Unit Cost (LCY)");
                                            NSJobLedgerEntry3.Validate("Total Cost (LCY)", -NSJobLedgerEntry."Total Cost (LCY)");
                                            NSJobLedgerEntry3.Validate("Unit Price", NSJobLedgerEntry."Unit Price");
                                            NSJobLedgerEntry3.validate("Line Amount", -NSJobLedgerEntry."Line Amount");
                                            NSJobLedgerEntry3."Ledger Entry Type" := NSJobLedgerEntry."Ledger Entry Type"::Item;
                                            NSJobLedgerEntry3."NS_Accural Status" := NSJobLedgerEntry."NS_Accural Status"::NS_Closed;
                                            NSJobLedgerEntry3.Adjusted := false;
                                            NSJobLedgerEntry3."NS_Receipt No." := NSJobLedgerEntry."NS_Receipt No.";
                                            NSJobLedgerEntry3."NS_Receipt Line No." := NSJobLedgerEntry."NS_Receipt Line No.";
                                            NSJobLedgerEntry3.Modify();
                                            NSJobLedgerEntry."NS_Accural Status" := "NS_Accrual Status"::NS_Closed;
                                            NSJobLedgerEntry.Modify();
                                            TotalQuantity := 0;
                                        end;
                                        if NSJobLedgerEntry.Quantity < TotalQuantity then begin
                                            NSJobLedgerEntry4.Init();
                                            NSJobLedgerEntry4."Entry No." := NSJobLedgerEntry4.GetLastEntryNo() + 1;
                                            NSJobLedgerEntry4.Insert(true);
                                            NSJobLedgerEntry4."Posting Date" := NSJobLedgerEntry."Posting Date";
                                            NSJobLedgerEntry4."NS_Interim Entry" := true;
                                            NSJobLedgerEntry4."Entry Type" := NSJobLedgerEntry."Entry Type";
                                            NSJobLedgerEntry4."Document No." := NSJobLedgerEntry."Document No.";
                                            NSJobLedgerEntry4."Job No." := NSJobLedgerEntry."Job No.";
                                            NSJobLedgerEntry4."Job Task No." := NSJobLedgerEntry."Job Task No.";
                                            NSJobLedgerEntry4."Unit of Measure Code" := NSPurchRcptLine."Unit of Measure Code";
                                            NSJobLedgerEntry4."NS_External Relationship Type" := NSJobLedgerEntry."NS_External Relationship Type";
                                            NSJobLedgerEntry4."NS_External Relationship No." := NSJobLedgerEntry."NS_External Relationship No.";
                                            NSJobLedgerEntry4."NS_External Relationship Name" := NSJobLedgerEntry."NS_External Relationship Name";
                                            NSJobLedgerEntry4.Type := NSJobLedgerEntry.Type;
                                            NSJobLedgerEntry4."No." := NSJobLedgerEntry."No.";
                                            NSJobLedgerEntry4.Description := NSJobLedgerEntry.Description;
                                            NSJobLedgerEntry4."NS_Job Cost Category" := NSJobLedgerEntry."NS_Job Cost Category";
                                            NSJobLedgerEntry4.Validate(Quantity, -(NSJobLedgerEntry.Quantity));
                                            NSJobLedgerEntry4.Validate("Unit Cost", NSJobLedgerEntry."Unit Cost");
                                            NSJobLedgerEntry4.Validate("Total Cost", -NSJobLedgerEntry."Total Cost");
                                            NSJobLedgerEntry4.Validate("Unit Cost (LCY)", NSJobLedgerEntry."Unit Cost (LCY)");
                                            NSJobLedgerEntry4.Validate("Total Cost (LCY)", -NSJobLedgerEntry."Total Cost (LCY)");
                                            NSJobLedgerEntry4.Validate("Unit Price", NSJobLedgerEntry."Unit Price");
                                            NSJobLedgerEntry4.validate("Line Amount", -NSJobLedgerEntry."Line Amount");
                                            NSJobLedgerEntry4."Ledger Entry Type" := NSJobLedgerEntry."Ledger Entry Type"::Item;
                                            NSJobLedgerEntry4."NS_Accural Status" := NSJobLedgerEntry."NS_Accural Status"::NS_Closed;
                                            NSJobLedgerEntry4.Adjusted := false;
                                            NSJobLedgerEntry4."NS_Receipt No." := NSJobLedgerEntry."NS_Receipt No.";
                                            NSJobLedgerEntry4."NS_Receipt Line No." := NSJobLedgerEntry."NS_Receipt Line No.";
                                            NSJobLedgerEntry4.Modify();
                                            NSJobLedgerEntry."NS_Accural Status" := "NS_Accrual Status"::NS_Closed;
                                            NSJobLedgerEntry.Modify();
                                            TotalQuantity := TotalQuantity - NSJobLedgerEntry.Quantity;
                                        end;
                                    end;
                                end;
                            until NSPurchRcptLine.Next() = 0;
                    until NSPurchInvLine.Next() = 0;
                end;
            end;
        end;
    end;
    //PE-36.GK.1.0 end
    //PRJCTPR-211.NC.1.0 31Oct2023 Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterModifyTempLine', '', false, false)]
    local procedure NS_OnAfterModifyTempLine(var PurchaseLine: Record "Purchase Line")
    var
        NS_JobsSetup: Record "Jobs Setup";
    begin
        PurchaseLine."NS_Retention Base Amount" := 0;
        PurchaseLine."NS_Retention Base Before Tax" := 0;
        IF PurchaseLine."NS_Retention Applies" AND (PurchaseLine.Quantity <> 0) THEN BEGIN
            IF PurchaseLine."NS_Subcontract No." = '' THEN BEGIN
                PurchaseLine."NS_Retention Base Amount" := PurchaseLine."Qty. to Receive" * PurchaseLine."Direct Unit Cost";
                PurchaseLine."NS_Retention Base Before Tax" := PurchaseLine."Qty. to Receive" * PurchaseLine."Direct Unit Cost";
                PurchaseLine.Modify();
                if PurchaseLine."Document Type" = PurchaseLine."Document Type"::"Credit Memo" then begin
                    PurchaseLine."NS_Retention Base Amount" := PurchaseLine.Quantity * PurchaseLine."Direct Unit Cost";
                    PurchaseLine."NS_Retention Base Before Tax" := PurchaseLine."NS_Retention Base Amount";
                    PurchaseLine.Modify();
                end;
            END ELSE BEGIN
                PurchaseLine."NS_Retention Base Amount" := PurchaseLine."Qty. to Receive" * PurchaseLine."Direct Unit Cost";
                PurchaseLine."NS_Retention Base Before Tax" := PurchaseLine."Qty. to Receive" * PurchaseLine."Direct Unit Cost";
                PurchaseLine.Modify();
                if NS_JobsSetup.Get() then;
                if NS_JobsSetup."NS_A/P RetentionTaxCalcMethod" = NS_JobsSetup."NS_A/P RetentionTaxCalcMethod"::"1 - Calc tax on purchase then apply a retention value based on taxed purchase amount" then begin
                    if PurchaseLine."VAT %" <> 0 then
                        PurchaseLine."NS_Retention Base Amount" := (PurchaseLine.Quantity * PurchaseLine."Direct Unit Cost" * PurchaseLine."VAT %" / 100) + PurchaseLine.Quantity * PurchaseLine."Direct Unit Cost"
                    else
                        PurchaseLine."NS_Retention Base Amount" := PurchaseLine."Amount Including VAT";
                    PurchaseLine."NS_Retention Base Before Tax" := PurchaseLine."NS_Retention Base Amount";
                    PurchaseLine.Modify();
                end;
            END;
        end;
    end;
    //PRJCTPR-211.NC.1.0 31Oct2023 End

    //PE-204.AS.2.0 START
    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforeTestPurchLineJob', '', false, false)]
    local procedure NS_C90OnRunOnBeforeTestPurchLineJob(PurchaseLine: Record "Purchase Line"; var IsHandled: Boolean)
    var
    begin
        if PurchaseLine.Type = PurchaseLine.Type::NS_Ledger then
            IsHandled := true;
    end;
    //PE-204.AS.2.0 END
    //PRJCTPR-256.JS.1.0 14DEC2023 - Start
    [EventSubscriber(ObjectType::codeunit, 90, 'OnInsertReceiptLineOnAfterInitPurchRcptLine', '', false, false)]
    local procedure OnInsertReceiptLineOnAfterInitPurchRcptLine(var PurchRcptLine: Record "Purch. Rcpt. Line"; PurchLine: Record "Purchase Line"; ItemLedgShptEntryNo: Integer; xPurchLine: Record "Purchase Line"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var CostBaseAmount: Decimal; PostedWhseRcptHeader: Record "Posted Whse. Receipt Header"; WhseRcptHeader: Record "Warehouse Receipt Header"; var WhseRcptLine: Record "Warehouse Receipt Line")
    begin
        if PurchLine."NS_JMP Details" <> '' then
            PurchRcptLine."NS_Segment Code" := copystr(PurchLine."NS_JMP Details", 1, 20);
    end;
    //PRJCTPR-256.JS.1.0 14DEC2023 - end
}

