tableextension 14021110 NS_PurchaseHeader extends "Purchase Header"
{
    // version NAVW111.00.00.25466,NAVNA11.00.00.25466,PPNA11.00
    //PRJ-120.SK.1.0 Added code
    //PRJ-145.SK.1.0 Added code
    //PRJ-168.SK.1.0 Blocked some code because that is moved to another object
    //PRJ-277.MS.1.0 Code for retention
    //PRJ-301.MS.1.0 change length from 50 to 100
    //PRJ-809.RS.1.0 13July21 | Filter subcontracts by job on Purchase Order
    //PRJ-889.GK.1.0 13Sep2021 |Add one field
    //PRJ-967.GK.1.0 11Oct2021 |Add one field
    fields
    {
        modify("Pay-to Vendor No.")
        {
            trigger OnBeforeValidate()
            begin
                p.NS_T38SetCreateDim(DATABASE::Job, "NS_Job No.");
            end;
        }

        modify("Purchaser Code")
        {
            trigger OnAfterValidate()
            begin
                p.NS_T38SetCreateDim(DATABASE::Job, "NS_Job No.");
            end;
        }

        modify("Campaign No.")
        {
            trigger OnAfterValidate()
            begin
                p.NS_T38SetCreateDim(DATABASE::Job, "NS_Job No.");
            end;
        }

        modify("Responsibility Center")
        {
            trigger OnAfterValidate()
            begin
                p.NS_T38SetCreateDim(DATABASE::Job, "NS_Job No.");
            end;
        }

        field(14021100; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            Description = 'ProjectPro';
            TableRelation = Job;
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                PurchaseLine: Record "Purchase Line";
                JobLinks: Record "NS_Job Links";
                JobPlanningLine: Record "Job Planning Line";
                Jobs: Record Job;
                JobSetup: Record "Jobs Setup";
                VendorRec: Record Vendor;
                IncompatibleLines: Boolean;

            begin
                //ProjectPro - start
                IF JobSetup.GET() Then;
                if "NS_Job No." <> '' then begin

                    //ProjectPro - start
                    if Jobs.GET("NS_Job No.") then begin
                        "NS_Customer Account Name" := Jobs."Bill-to Name";
                        "NS_Job Name" := Jobs.Description;
                        //PRJ-145.SK.1.0 Start
                        // IF Jobs."NS_Gen. Bus. Posting Group" <> '' then //PRJ-831.AS.1.0 12OCT2021 Comment old
                        //     VALIDATE("Gen. Bus. Posting Group", Jobs."NS_Gen. Bus. Posting Group")//PRJ-120.SK.1.0 Added //PRJ-831.AS.1.0 12OCT2021 Comment old

                        IF Jobs."NS_Gen. Bus. Posting Group New" <> '' then //PRJ-831.AS.1.0 12OCT2021 Add New
                            VALIDATE("Gen. Bus. Posting Group", Jobs."NS_Gen. Bus. Posting Group New")//PRJ-120.SK.1.0 Added //PRJ-831.AS.1.0 12OCT2021 Add New
                    end;
                    //PRJ-145.SK.1.0 End;
                    //ProjectPro - end

                    with PurchaseLine do begin
                        IncompatibleLines := false;
                        RESET();
                        SETRANGE("Document Type", Rec."Document Type");
                        SETRANGE("Document No.", Rec."No.");
                        if FINDSET() then
                            repeat
                                if PurchaseLine."Job No." <> '' then
                                    if not JobLinks.GET(PurchaseLine."Job No.", Rec."NS_Job No.") then
                                        IncompatibleLines := true;
                            until (NEXT() = 0) or IncompatibleLines;

                        if IncompatibleLines then
                            if not CONFIRM(Text14021100_Txt, true, Rec."NS_Job No.") then
                                ERROR(Text14021101_Txt)
                            else begin
                                RESET();
                                SETRANGE("Document Type", Rec."Document Type");
                                SETRANGE("Document No.", Rec."No.");
                                if FINDSET() then
                                    repeat
                                        if "Job No." <> '' then begin
                                            if Type <> Type::"Fixed Asset" then  //PRJ-490.AM.1.0 Start
                                                "Job No." := Rec."NS_Job No."
                                            else
                                                "NS_FA Job No." := Rec."NS_Job No.";  //PRJ-490.AM.1.0 Start

                                            //Check Job Task No.
                                            if "Job Task No." > '' then begin
                                                JobPlanningLine.RESET();
                                                JobPlanningLine.SETRANGE("Job No.", "Job No.");
                                                JobPlanningLine.SETRANGE("Job Task No.", "Job Task No.");
                                                if JobPlanningLine.COUNT() = 0 then
                                                    "Job Task No." := '';
                                            end;
                                            MODIFY();
                                        end;
                                    until NEXT() = 0;
                            end;
                    end;

                    p.NS_T38SetCreateDim(DATABASE::Job, "NS_Job No.");
                    CreateDim(
                      DATABASE::Vendor, "Pay-to Vendor No.",
                      DATABASE::"Salesperson/Purchaser", "Purchaser Code",
                      DATABASE::Campaign, "Campaign No.",
                      DATABASE::"Responsibility Center", "Responsibility Center");
                end
                //PRJ-145.SK.1.0 Start
                else
                    IF JobSetup."NS_Gen. Bus. Posting Group" <> '' then
                        Validate("Gen. Bus. Posting Group", JobSetup."NS_Gen. Bus. Posting Group")
                    else
                        IF VendorRec.Get(Rec."Buy-from Vendor No.") then
                            IF VendorRec."Gen. Bus. Posting Group" <> '' then
                                Validate("Gen. Bus. Posting Group", VendorRec."Gen. Bus. Posting Group");
                //PRJ-145.SK.1.0 End

                NS_AssignDefaultValuesToTaxFields();
                if (xRec."Tax Liable" <> "Tax Liable") or
                   (xRec."Tax Area Code" <> "Tax Area Code") or
                   (xRec."VAT Bus. Posting Group" <> "VAT Bus. Posting Group")
                then
                    RecreatePurchLines(FIELDCAPTION("NS_Job No."));

                //ProjectPro - end
            end;
        }
        field(14021104; "NS_Draw No."; Code[25])
        {
            Caption = 'Draw No.';
            Description = 'ProjectPro';
            TableRelation = NS_Draw."NS_No." WHERE("NS_Job No." = FIELD("NS_Job No."),
                                              NS_Closed = CONST(false));
            DataClassification = CustomerContent;
        }
        field(14021130; "NS_RetentionInvoiceDiscAmount"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Inv. Discount Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                         "Document No." = FIELD("No."),
                                                                         "NS_Retention Applies" = CONST(true)));
            Caption = 'Retention Invoice Disc. Amount';
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        field(14021136; "NS_Retention Base Amount"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."NS_Retention Base Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                             "Document No." = FIELD("No."),
                                                                             "NS_Retention Applies" = CONST(true)));
            Caption = 'Retention Base Amount';
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        field(14021137; "NS_Retention Base Before Tax"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."NS_Retention Base Before Tax" WHERE("Document Type" = FIELD("Document Type"),
                                                                                 "Document No." = FIELD("No."),
                                                                                 "NS_Retention Applies" = CONST(true)));
            Caption = 'Retention Base Before Tax';
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        field(14021138; "NS_Retention Percent"; Decimal)
        {
            Caption = 'Retention Percent';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                GLSetup: Record "General Ledger Setup";
                CurrExchRate: Record "Currency Exchange Rate";
            begin
                //ProjectPro - start
                NS_JobsSetup.GET();
                GLSetup.GET();
                if "NS_Retention Percent" = 0 then begin
                    if NS_JobsSetup."NS_Calc Payable Ret Before Tax" then begin
                        "NS_Retention Amount (LCY)" := 0;
                        "NS_Retention Amount" := 0;
                    end;
                    if ("NS_Retention Amount (LCY)" = 0) and ("NS_Retention Amount" = 0) then
                        "NS_Retention Date" := 0D;
                end else begin
                    TESTFIELD("NS_Retention Document", false);

                    if "Currency Code" = '' then begin
                        "NS_Retention Amount (LCY)" := ROUND(NS_RetentionBase("Document Type", "No.") * ("NS_Retention Percent" / 100),
                                                          GLSetup."Amount Rounding Precision");
                        "NS_Retention Amount" := "NS_Retention Amount (LCY)";
                    end else begin
                        NS_Currency.GET("Currency Code");
                        "NS_Retention Amount" := ROUND(NS_RetentionBase("Document Type", "No.") * ("NS_Retention Percent" / 100),
                                                          GLSetup."Amount Rounding Precision");
                        "NS_Retention Amount (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", "NS_Retention Amount",
                                                          CurrExchRate.ExchangeRate("Posting Date", "Currency Code")),
                                                          NS_Currency."Amount Rounding Precision");
                    end;

                    if "NS_Retention Date" = 0D then
                        if NS_JobsSetup."NS_Purchase Retention Period" <> '' then
                            if "Posting Date" > 0D then
                                "NS_Retention Date" := CALCDATE('+' + NS_JobsSetup."NS_Purchase Retention Period", "Posting Date")
                            else
                                if "Document Date" > 0D then
                                    "NS_Retention Date" := CALCDATE('+' + NS_JobsSetup."NS_Purchase Retention Period", "Document Date")
                                else
                                    ERROR(Text14021102_Txt);
                end;
                //ProjectPro - end
            end;
        }
        field(14021139; "NS_Retention Amount (LCY)"; Decimal)
        {
            Caption = 'Retention Amount ($)';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                CurrExchRate: Record "Currency Exchange Rate";
            begin
                //ProjectPro - start
                TESTFIELD("NS_Retention Document", false);

                NS_JobsSetup.GET();
                if "NS_Retention Amount (LCY)" <> 0 then begin
                    //"NS_Retention Percent" := 0;//PRJ-277.MS.1.0 comment
                    if "Currency Code" = '' then begin
                        "NS_Retention Amount" := "NS_Retention Amount (LCY)"
                    end else begin
                        NS_Currency.GET("Currency Code");
                        "NS_Retention Amount" := ROUND(CurrExchRate.ExchangeAmtLCYToFCY("Posting Date", "Currency Code", "NS_Retention Amount (LCY)",
                                                    CurrExchRate.ExchangeRate("Posting Date", "Currency Code")),
                                                    NS_Currency."Amount Rounding Precision");
                    end;
                    if "NS_Retention Date" = 0D then
                        if NS_JobsSetup."NS_Purchase Retention Period" <> '' then
                            if "Posting Date" > 0D then
                                "NS_Retention Date" := CALCDATE('+' + NS_JobsSetup."NS_Purchase Retention Period", "Posting Date")
                            else
                                if "Document Date" > 0D then
                                    "NS_Retention Date" := CALCDATE('+' + NS_JobsSetup."NS_Purchase Retention Period", "Document Date")
                                else
                                    ERROR(Text14021102_Txt);
                end else
                    "NS_Retention Amount" := 0;
                //ProjectPro - end
            end;
        }
        field(14021140; "NS_Retention Amount"; Decimal)
        {
            Caption = 'Retention Amount';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                CurrExchRate: Record "Currency Exchange Rate";
            begin
                //ProjectPro - start
                TESTFIELD("NS_Retention Document", false);

                NS_JobsSetup.GET();
                if "NS_Retention Amount" <> 0 then begin
                    //"NS_Retention Percent" := 0;//PRJ-277.MS.1.0 comment
                    if "Currency Code" = '' then begin
                        "NS_Retention Amount (LCY)" := "NS_Retention Amount"
                    end else begin
                        NS_Currency.GET("Currency Code");
                        "NS_Retention Amount (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", "NS_Retention Amount",
                                                          CurrExchRate.ExchangeRate("Posting Date", "Currency Code")),
                                                          NS_Currency."Amount Rounding Precision");
                    end;
                    if "NS_Retention Date" = 0D then
                        if NS_JobsSetup."NS_Purchase Retention Period" <> '' then
                            if "Posting Date" > 0D then
                                "NS_Retention Date" := CALCDATE('+' + NS_JobsSetup."NS_Purchase Retention Period", "Posting Date")
                            else
                                if "Document Date" > 0D then
                                    "NS_Retention Date" := CALCDATE('+' + NS_JobsSetup."NS_Purchase Retention Period", "Document Date")
                                else
                                    ERROR(Text14021102_Txt);
                end else
                    "NS_Retention Amount (LCY)" := 0;
                //ProjectPro - end
            end;
        }
        field(14021145; "NS_Retention Date"; Date)
        {
            Caption = 'Retention Date';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                if "NS_Retention Date" > 0D then
                    TESTFIELD("NS_Retention Document", false);

                if "NS_Retention Amount (LCY)" <> 0 then
                    TESTFIELD("NS_Retention Date");
                //ProjectPro - end
            end;
        }
        field(14021146; "NS_Retention Document"; Boolean)
        {
            Caption = 'Retention Document';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                if "NS_Retention Document" = true then begin
                    TESTFIELD("NS_Retention Amount (LCY)", 0);
                    TESTFIELD("NS_Retention Percent", 0);
                    TESTFIELD("NS_Retention Date", 0D);
                end;
                //ProjectPro - end
            end;
        }
        field(14021300; "NS_Subcontract No."; Code[20])
        {
            Caption = 'Subcontract No.';
            Description = 'ProjectPro';
            //TableRelation = NS_Subcontract;//PRJ-809.RS.1.0 13July21 Commented
            TableRelation = NS_Subcontract."NS_No." where("NS_Job No." = field("NS_Job No."));//PRJ-809.RS.1.0 13July21
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                MessageIfPurchLinesExist(FIELDCAPTION("NS_Subcontract No."));
                //ProjectPro - end
            end;
        }
        field(14021301; "NS_Retention Ledger Code"; Code[20])
        {
            Caption = 'Retention Ledger Code';
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            DataClassification = CustomerContent;
        }
        field(14021325; "NS_Progress Payment Document"; Boolean)
        {
            Caption = 'Progress Billing Document';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021327; "NS_From Progress Payment No."; Code[20])
        {
            Caption = 'From Progress Billing No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021328; "NS_From ProgressPaymentReqNo."; Integer)
        {
            Caption = 'From Progress Billing Req. No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021329; "NS_From ProgressPaymentVerNo."; Integer)
        {
            Caption = 'From Progress Billing Ver. No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021340; "NS_Prog Pay Subcontract No."; Code[20])
        {
            Caption = 'Prog Pay Subcontract No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021400; "NS_Job Name"; Text[100])	//PRJ-301.MS.1.0
        {
            Caption = 'Job Name';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021401; "NS_Job Location"; Text[50])
        {
            Caption = 'Job Location';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021402; "NS_Customer Account Name"; Text[100])//PRJ-301.MS.1.0
        {
            Caption = 'Customer Account Name';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        //PRJ-889.GK.1.0 13Sep2021 start
        field(14021403; "NS_Progress Payment Enable"; Option)
        {
            OptionMembers = No,Yes;
            OptionCaption = 'No,Yes';
            Caption = 'Progress Payment Enable';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        //PRJ-889.GK.1.0 13Sep2021 end

        //PRJ-967.GK.1.0 11Oct2021 start
        field(14021404; "NS_Add Job Address"; Boolean)
        {
            Caption = 'Add Job Address';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
        }
        //PRJ-967.GK.1.0 11Oct2021 end
    }
    keys
    {
        key(Key1; "NS_Job No.")
        {
        }
        key(Key2; "NS_Subcontract No.")
        {
        }
    }

    trigger OnAfterInsert()
    begin
        "Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(DATABASE::"Purchase Header", "Document Type".AsInteger(), "No.");
        Modify(false);
    end;
    //PRJ-1010.GK.1.0 10Nov2021 start
    trigger OnAfterDelete()
    var
        PurInvHeader: Record "Purch. Inv. Header";
        SubConHdr: Record NS_Subcontract;
        SubConLine: Record "NS_Subcontract Lines";
    begin
        PurInvHeader.Reset();
        PurInvHeader.SetRange("Order No.", "No.");
        if not PurInvHeader.FindFirst() then begin
            SubConHdr.Reset();
            SubConHdr.SetRange("NS_Purchase Document No.", "No.");
            if SubConHdr.FindSet() then
                repeat
                    SubConHdr."NS_Purchase Document No." := '';
                    SubConHdr.Modify();
                until SubConHdr.Next() = 0;
            SubConLine.Reset();
            SubConLine.SetRange("NS_PO No.", "No.");
            if SubConLine.FindSet() then
                repeat
                    SubConLine."NS_PO No." := '';
                    SubConLine."NS_PO Line No." := 0;
                    SubConLine.Modify();
                until SubConLine.Next() = 0;
        end;

    end;
    //PRJ-1010.GK.1.0 10Nov2021 end


    local procedure IsSingleVendorSelected(): Boolean;
    VAR
        SelectedCount: Integer;
        VendorCount: Integer;
        BuyFromVendorNoFilter: Text;
    BEGIN
        //ProjectPro - start add
        SelectedCount := COUNT();

        IF SelectedCount < 1 THEN
            EXIT(FALSE);

        IF SelectedCount = 1 THEN
            EXIT(TRUE);

        BuyFromVendorNoFilter := GETFILTER("Buy-from Vendor No.");
        SETRANGE("Buy-from Vendor No.", "Buy-from Vendor No.");
        VendorCount := COUNT;
        SETFILTER("Buy-from Vendor No.", BuyFromVendorNoFilter);

        EXIT(SelectedCount = VendorCount);
        //ProjectPro - end add
    END;

    PROCEDURE NS_RetentionBase(DocumentType: enum "Purchase Line Type"; No: Code[20]): Decimal;
    VAR
        PurchaseHeader: Record 38;
        JobsSetup: Record 315;
        TotalRetention: Decimal;
    BEGIN
        //ProjectPro - start add
        TotalRetention := 0;
        JobsSetup.GET();
        IF PurchaseHeader.GET(DocumentType, No) THEN
            IF JobsSetup."NS_Calc Payable Ret Before Tax" THEN BEGIN
                PurchaseHeader.CALCFIELDS("NS_Retention Base Before Tax");
                TotalRetention := PurchaseHeader."NS_Retention Base Before Tax";
            END ELSE BEGIN
                PurchaseHeader.CALCFIELDS("NS_Retention Base Amount");
                TotalRetention := PurchaseHeader."NS_Retention Base Amount"
            END;

        EXIT(TotalRetention);
        //ProjectPro - end add
    END;

    PROCEDURE NS_AssignDefaultValuesToTaxFields();
    VAR
        NS_Job: Record 167;
    BEGIN
        //ProjectPro - start add
        GetVend("Buy-from Vendor No.");
        "VAT Bus. Posting Group" := Vend."VAT Bus. Posting Group";
        "Tax Area Code" := Vend."Tax Area Code";
        "Tax Liable" := Vend."Tax Liable";
        IF "NS_Job No." <> '' THEN
            IF NS_Job.GET("NS_Job No.") THEN BEGIN
                IF NS_Job."NS_VAT Bus. Posting Group" <> '' THEN
                    "VAT Bus. Posting Group" := NS_Job."NS_VAT Bus. Posting Group";
                // IF NS_Job."NS_Tax Area Code" <> '' THEN BEGIN  //PRJ-534.AM.1.0 comment start
                //     "Tax Area Code" := NS_Job."NS_Tax Area Code";
                //     "Tax Liable" := NS_Job."NS_Tax Liable";  
                // END;  //PRJ-534.AM.1.0 comment End
            END;
        VALIDATE("VAT Bus. Posting Group");
        VALIDATE("Tax Area Code");
        VALIDATE("Tax Liable");
        //ProjectPro - end add
    END;


    PROCEDURE NS_CalcHeaderRetention(NS_PurchHeader: Record 38; VAR NS_RetentionBaseAmount: Decimal; VAR NS_RetentionAmount: Decimal; VAR NS_RetentionAmountLCY: Decimal);
    VAR
        NS_GLSetup: Record 98;
        NS_PurchLine: Record 39;
        NS_Currency_Loc: Record 4;
        CurrExchRate: Record "Currency Exchange Rate";
    BEGIN
        //ProjectPro - start add

        //This calculates retention values on the document header with the current "Qty to Receive" usually needed before the posting.

        NS_RetentionBaseAmount := 0;
        NS_RetentionAmount := 0;
        NS_RetentionAmountLCY := 0;

        NS_GLSetup.GET();

        WITH NS_PurchLine DO BEGIN
            RESET();
            SETRANGE("Document Type", NS_PurchHeader."Document Type");
            SETRANGE("Document No.", NS_PurchHeader."No.");
            IF FINDSET() THEN
                REPEAT
                    IF "NS_Retention Applies" THEN
                        NS_RetentionBaseAmount := NS_RetentionBaseAmount + ROUND(("Qty. to Invoice" * "Direct Unit Cost"), NS_GLSetup."Amount Rounding Precision");//PRJ-277.MS.1.0
                                                                                                                                                                   //NS_RetentionBaseAmount := NS_RetentionBaseAmount + ROUND(("Qty. to Receive" * "Direct Unit Cost"), NS_GLSetup."Amount Rounding Precision");//PRJ-277.MS.1.0 comment
                UNTIL NEXT() = 0;

            IF NS_PurchHeader."NS_Retention Percent" = 0 THEN
                NS_RetentionAmountLCY := 0
            ELSE
                NS_RetentionAmountLCY := ROUND(NS_RetentionBaseAmount * NS_PurchHeader."NS_Retention Percent" / 100, NS_GLSetup."Amount Rounding Precision");//PRJ-277.MS.1.0
                                                                                                                                                             //NS_RetentionAmountLCY := ROUND(NS_RetentionBaseAmount / NS_PurchHeader."NS_Retention Percent", NS_GLSetup."Amount Rounding Precision");//PRJ-277.MS.1.0 comment
            NS_RetentionAmount := NS_RetentionAmountLCY;

            IF NS_PurchHeader."Currency Code" > '' THEN BEGIN
                NS_Currency_Loc.GET(NS_PurchHeader."Currency Code");
                NS_RetentionAmount := ROUND(CurrExchRate.ExchangeAmtLCYToFCY(NS_PurchHeader."Posting Date", NS_PurchHeader."Currency Code", NS_RetentionAmountLCY,
                                             CurrExchRate.ExchangeRate(NS_PurchHeader."Posting Date", NS_PurchHeader."Currency Code")),
                                             NS_Currency_Loc."Amount Rounding Precision");
            END;

        END;
        //ProjectPro - end add
    END;

    LOCAL PROCEDURE RecreatePurchLines(ChangedFieldName: Text);
    VAR
        TempPurchLine: Record "Purchase Line" temporary;
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
        TempItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)" temporary;
        TempInteger: Record Integer temporary;
        SalesHeader: Record "Sales Header";
        PurchLine: Record "Purchase Line";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        ExtendedTextAdded: Boolean;
        ConfirmText: Text;

    BEGIN
        IF NOT PurchLinesExist() THEN
            EXIT;

        IF GetHideValidationDialog() OR NOT GUIALLOWED() THEN
            Confirmed := TRUE
        ELSE BEGIN
            IF HasItemChargeAssignment() THEN
                ConfirmText := ResetItemChargeAssignMsg
            ELSE
                ConfirmText := RecreatePurchLinesMsg;
            Confirmed := CONFIRM(ConfirmText, FALSE, ChangedFieldName);
        END;

        IF Confirmed THEN BEGIN
            PurchLine.LOCKTABLE();
            ItemChargeAssgntPurch.LOCKTABLE();
            MODIFY();

            PurchLine.RESET();
            PurchLine.SETRANGE("Document Type", "Document Type");
            PurchLine.SETRANGE("Document No.", "No.");
            IF PurchLine.FINDSET() THEN BEGIN
                REPEAT
                    PurchLine.TESTFIELD("Quantity Received", 0);
                    PurchLine.TESTFIELD("Quantity Invoiced", 0);
                    PurchLine.TESTFIELD("Return Qty. Shipped", 0);
                    PurchLine.CALCFIELDS("Reserved Qty. (Base)");
                    PurchLine.TESTFIELD("Reserved Qty. (Base)", 0);
                    PurchLine.TESTFIELD("Receipt No.", '');
                    PurchLine.TESTFIELD("Return Shipment No.", '');
                    PurchLine.TESTFIELD("Blanket Order No.", '');
                    IF PurchLine."Drop Shipment" OR PurchLine."Special Order" THEN BEGIN
                        CASE TRUE OF
                            PurchLine."Drop Shipment":
                                SalesHeader.GET(SalesHeader."Document Type"::Order, PurchLine."Sales Order No.");
                            PurchLine."Special Order":
                                SalesHeader.GET(SalesHeader."Document Type"::Order, PurchLine."Special Order Sales No.");
                        END;
                        TESTFIELD("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
                        TESTFIELD("Ship-to Code", SalesHeader."Ship-to Code");
                    END;

                    PurchLine.TESTFIELD("Prepmt. Amt. Inv.", 0);
                    TempPurchLine := PurchLine;
                    IF PurchLine.Nonstock THEN BEGIN
                        PurchLine.Nonstock := FALSE;
                        PurchLine.MODIFY();
                    END;
                    TempPurchLine.INSERT();
                UNTIL PurchLine.NEXT() = 0;

                TransferItemChargeAssgntPurchToTemp(ItemChargeAssgntPurch, TempItemChargeAssgntPurch);

                PurchLine.DELETEALL(TRUE);

                PurchLine.INIT();
                PurchLine."Line No." := 0;
                TempPurchLine.FINDSET();
                ExtendedTextAdded := FALSE;
                REPEAT
                    IF TempPurchLine."Attached to Line No." = 0 THEN BEGIN
                        PurchLine.INIT();
                        PurchLine."Line No." := PurchLine."Line No." + 10000;
                        PurchLine.VALIDATE(Type, TempPurchLine.Type);
                        IF TempPurchLine."No." = '' THEN BEGIN
                            PurchLine.VALIDATE(Description, TempPurchLine.Description);
                            PurchLine.VALIDATE("Description 2", TempPurchLine."Description 2");
                        END ELSE BEGIN
                            PurchLine.VALIDATE("No.", TempPurchLine."No.");
                            IF PurchLine.Type <> PurchLine.Type::" " THEN
                                CASE TRUE OF
                                    TempPurchLine."Drop Shipment":
                                        TransferSavedFieldsDropShipment(PurchLine, TempPurchLine);
                                    TempPurchLine."Special Order":
                                        TransferSavedFieldsSpecialOrder(PurchLine, TempPurchLine);
                                    ELSE
                                        TransferSavedFields(PurchLine, TempPurchLine);
                                END;
                        END;

                        PurchLine.INSERT();
                        ExtendedTextAdded := FALSE;

                        IF PurchLine.Type = PurchLine.Type::Item THEN BEGIN
                            ClearItemAssgntPurchFilter(TempItemChargeAssgntPurch);
                            TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type", TempPurchLine."Document Type");
                            TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.", TempPurchLine."Document No.");
                            TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.", TempPurchLine."Line No.");
                            IF TempItemChargeAssgntPurch.FINDSET() THEN
                                REPEAT
                                    IF NOT TempItemChargeAssgntPurch.MARK() THEN BEGIN
                                        TempItemChargeAssgntPurch."Applies-to Doc. Line No." := PurchLine."Line No.";
                                        TempItemChargeAssgntPurch.Description := PurchLine.Description;
                                        TempItemChargeAssgntPurch.MODIFY();
                                        TempItemChargeAssgntPurch.MARK(TRUE);
                                    END;
                                UNTIL TempItemChargeAssgntPurch.NEXT() = 0;
                        END;
                        IF PurchLine.Type = PurchLine.Type::"Charge (Item)" THEN BEGIN
                            TempInteger.INIT();
                            TempInteger.Number := PurchLine."Line No.";
                            TempInteger.INSERT();
                        END;
                    END ELSE
                        IF NOT ExtendedTextAdded THEN BEGIN
                            TransferExtendedText.PurchCheckIfAnyExtText(PurchLine, TRUE);
                            TransferExtendedText.InsertPurchExtText(PurchLine);
                            PurchLine.FINDLAST();
                            ExtendedTextAdded := TRUE;
                        END;
                UNTIL TempPurchLine.NEXT() = 0;

                ClearItemAssgntPurchFilter(TempItemChargeAssgntPurch);
                TempPurchLine.SETRANGE(Type, PurchLine.Type::"Charge (Item)");
                IF TempPurchLine.FINDSET() THEN
                    REPEAT
                        TempItemChargeAssgntPurch.SETRANGE("Document Line No.", TempPurchLine."Line No.");
                        IF TempItemChargeAssgntPurch.FINDSET() THEN BEGIN
                            REPEAT
                                TempInteger.FINDFIRST();
                                ItemChargeAssgntPurch.INIT();
                                ItemChargeAssgntPurch := TempItemChargeAssgntPurch;
                                ItemChargeAssgntPurch."Document Line No." := TempInteger.Number;
                                ItemChargeAssgntPurch.VALIDATE("Unit Cost", 0);
                                ItemChargeAssgntPurch.INSERT();
                            UNTIL TempItemChargeAssgntPurch.NEXT() = 0;
                            TempInteger.DELETE();
                        END;
                    UNTIL TempPurchLine.NEXT() = 0;

                TempPurchLine.SETRANGE(Type);
                TempPurchLine.DELETEALL();
                ClearItemAssgntPurchFilter(TempItemChargeAssgntPurch);
                TempItemChargeAssgntPurch.DELETEALL();
            END;
        END ELSE
            ERROR(
              Text018_Txt, ChangedFieldName);
    END;

    LOCAL PROCEDURE GetVend(VendNo: Code[20]);
    BEGIN
        IF VendNo <> Vend."No." THEN
            Vend.GET(VendNo);
    END;

    LOCAL PROCEDURE HasItemChargeAssignment(): Boolean;
    VAR
        ItemChargeAssgntPurch: Record 5805;
    BEGIN
        ItemChargeAssgntPurch.SETRANGE("Document Type", "Document Type");
        ItemChargeAssgntPurch.SETRANGE("Document No.", "No.");
        ItemChargeAssgntPurch.SETFILTER("Amount to Assign", '<>%1', 0);
        EXIT(NOT ItemChargeAssgntPurch.ISEMPTY);
    END;

    LOCAL PROCEDURE TransferItemChargeAssgntPurchToTemp(VAR ItemChargeAssgntPurch: Record 5805; VAR TempItemChargeAssgntPurch: Record 5805 temporary);
    BEGIN
        ItemChargeAssgntPurch.SETRANGE("Document Type", "Document Type");
        ItemChargeAssgntPurch.SETRANGE("Document No.", "No.");
        IF ItemChargeAssgntPurch.FINDSET() THEN BEGIN
            REPEAT
                TempItemChargeAssgntPurch := ItemChargeAssgntPurch;
                TempItemChargeAssgntPurch.INSERT();
            UNTIL ItemChargeAssgntPurch.NEXT() = 0;
            ItemChargeAssgntPurch.DELETEALL();
        END;
    END;

    LOCAL PROCEDURE TransferSavedFieldsDropShipment(VAR DestinationPurchaseLine: Record 39; VAR SourcePurchaseLine: Record 39);
    VAR
        SalesLine: Record "Sales Line";
        CopyDocMgt: Codeunit "Copy Document Mgt.";
    BEGIN
        SalesLine.GET(SalesLine."Document Type"::Order,
          SourcePurchaseLine."Sales Order No.",
          SourcePurchaseLine."Sales Order Line No.");
        CopyDocMgt.TransfldsFromSalesToPurchLine(SalesLine, DestinationPurchaseLine);
        DestinationPurchaseLine."Drop Shipment" := SourcePurchaseLine."Drop Shipment";
        DestinationPurchaseLine."Purchasing Code" := SalesLine."Purchasing Code";
        DestinationPurchaseLine."Sales Order No." := SourcePurchaseLine."Sales Order No.";
        DestinationPurchaseLine."Sales Order Line No." := SourcePurchaseLine."Sales Order Line No.";
        EVALUATE(DestinationPurchaseLine."Inbound Whse. Handling Time", '<0D>');
        DestinationPurchaseLine.VALIDATE("Inbound Whse. Handling Time");
        SalesLine.VALIDATE("Unit Cost (LCY)", DestinationPurchaseLine."Unit Cost (LCY)");
        SalesLine."Purchase Order No." := DestinationPurchaseLine."Document No.";
        SalesLine."Purch. Order Line No." := DestinationPurchaseLine."Line No.";
        SalesLine.MODIFY();
    END;

    LOCAL PROCEDURE TransferSavedFields(VAR DestinationPurchaseLine: Record 39; VAR SourcePurchaseLine: Record 39);
    var
        PurchLine: Record "Purchase Line";
    BEGIN
        //SPLN1.00 TTU start
        PurchLine := DestinationPurchaseLine;
        //SPLN1.00 TTU end
        DestinationPurchaseLine.VALIDATE("Unit of Measure Code", SourcePurchaseLine."Unit of Measure Code");
        DestinationPurchaseLine.VALIDATE("Variant Code", SourcePurchaseLine."Variant Code");
        DestinationPurchaseLine."Prod. Order No." := SourcePurchaseLine."Prod. Order No.";
        IF DestinationPurchaseLine."Prod. Order No." <> '' THEN BEGIN
            DestinationPurchaseLine.Description := SourcePurchaseLine.Description;
            DestinationPurchaseLine.VALIDATE("VAT Prod. Posting Group", SourcePurchaseLine."VAT Prod. Posting Group");
            DestinationPurchaseLine.VALIDATE("Gen. Prod. Posting Group", SourcePurchaseLine."Gen. Prod. Posting Group");
            DestinationPurchaseLine.VALIDATE("Expected Receipt Date", SourcePurchaseLine."Expected Receipt Date");
            DestinationPurchaseLine.VALIDATE("Requested Receipt Date", SourcePurchaseLine."Requested Receipt Date");
            DestinationPurchaseLine.VALIDATE("Qty. per Unit of Measure", SourcePurchaseLine."Qty. per Unit of Measure");
        END;
        IF (SourcePurchaseLine."Job No." <> '') AND (SourcePurchaseLine."Job Task No." <> '') THEN BEGIN
            DestinationPurchaseLine.VALIDATE("Job No.", SourcePurchaseLine."Job No.");
            DestinationPurchaseLine.VALIDATE("Job Task No.", SourcePurchaseLine."Job Task No.");
            DestinationPurchaseLine."Job Line Type" := SourcePurchaseLine."Job Line Type";
        END;
        IF SourcePurchaseLine.Quantity <> 0 THEN
            DestinationPurchaseLine.VALIDATE(Quantity, SourcePurchaseLine.Quantity);
        IF ("Currency Code" = xRec."Currency Code") AND (PurchLine."Direct Unit Cost" = 0) THEN
            DestinationPurchaseLine.VALIDATE("Direct Unit Cost", SourcePurchaseLine."Direct Unit Cost");
        DestinationPurchaseLine."Routing No." := SourcePurchaseLine."Routing No.";
        DestinationPurchaseLine."Routing Reference No." := SourcePurchaseLine."Routing Reference No.";
        DestinationPurchaseLine."Operation No." := SourcePurchaseLine."Operation No.";
        DestinationPurchaseLine."Work Center No." := SourcePurchaseLine."Work Center No.";
        DestinationPurchaseLine."Prod. Order Line No." := SourcePurchaseLine."Prod. Order Line No.";
        DestinationPurchaseLine."Overhead Rate" := SourcePurchaseLine."Overhead Rate";
    END;

    LOCAL PROCEDURE ClearItemAssgntPurchFilter(VAR TempItemChargeAssgntPurch: Record 5805 temporary);
    BEGIN
        TempItemChargeAssgntPurch.SETRANGE("Document Line No.");
        TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type");
        TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.");
        TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.");
    END;

    LOCAL PROCEDURE TransferSavedFieldsSpecialOrder(VAR DestinationPurchaseLine: Record 39; VAR SourcePurchaseLine: Record 39);
    VAR
        SalesLine: Record "Sales Line";
        CopyDocMgt: Codeunit "Copy Document Mgt.";
    BEGIN
        SalesLine.GET(SalesLine."Document Type"::Order,
          SourcePurchaseLine."Special Order Sales No.",
          SourcePurchaseLine."Special Order Sales Line No.");
        CopyDocMgt.TransfldsFromSalesToPurchLine(SalesLine, DestinationPurchaseLine);
        DestinationPurchaseLine."Special Order" := SourcePurchaseLine."Special Order";
        DestinationPurchaseLine."Purchasing Code" := SalesLine."Purchasing Code";
        DestinationPurchaseLine."Special Order Sales No." := SourcePurchaseLine."Special Order Sales No.";
        DestinationPurchaseLine."Special Order Sales Line No." := SourcePurchaseLine."Special Order Sales Line No.";
        DestinationPurchaseLine.VALIDATE("Unit of Measure Code", SourcePurchaseLine."Unit of Measure Code");
        IF SourcePurchaseLine.Quantity <> 0 THEN
            DestinationPurchaseLine.VALIDATE(Quantity, SourcePurchaseLine.Quantity);

        SalesLine.VALIDATE("Unit Cost (LCY)", DestinationPurchaseLine."Unit Cost (LCY)");
        SalesLine."Special Order Purchase No." := DestinationPurchaseLine."Document No.";
        SalesLine."Special Order Purch. Line No." := DestinationPurchaseLine."Line No.";
        SalesLine.MODIFY();
    END;

    LOCAL PROCEDURE MessageIfPurchLinesExist(ChangedFieldName: Text);
    VAR
        MessageText: Text;
        LinesNotUpdatedMsg: Label 'You have changed %1 on the purchase header, but it has not been changed on the existing purchase lines.', Comment = '%1 = Field Caption';
        SplitMessage_Txt: Label '%1\%2', Comment = '%1 = Field Caption; %2 = Field Caption';
        Text020_Msg: Label 'You must update the existing purchase lines manually.';
    BEGIN
        IF PurchLinesExist() AND NOT GetHideValidationDialog() THEN BEGIN
            MessageText := STRSUBSTNO(LinesNotUpdatedMsg, ChangedFieldName);
            MessageText := STRSUBSTNO(SplitMessage_Txt, MessageText, Text020_Msg);
            MESSAGE(MessageText);
        END;
    END;
    //PRJ-387.N.S.1.0 16Sep2020 Start
    trigger OnInsert()
    begin
        if "Document Type" = "Document Type"::Quote then
            "Posting Date" := WorkDate;
    end;
    //PRJ-387.N.S.1.0 16Sep2020 End

    var
        NS_JobsSetup: Record "Jobs Setup";


        NS_Currency: Record Currency;
        Vend: Record Vendor;
        ArchiveManagement: Codeunit ArchiveManagement;
        p: Codeunit "NS_Parameters for Table Events";
        Text14021100_Txt: Label 'There are lines that are not part of this job.  All Job Numbers will be set to %1.\If a Job Task Number does not exist on the new job, it will be cleared.\Do you want to continue?', Comment = '%1 = Job No.';
        Text14021101_Txt: Label 'The Job No. has not been modified.';

        Text14021102_Txt: Label 'A Document Date is needed so that a Retention Date can be determined.';
        ResetItemChargeAssignMsg: Label 'If you change %1, the existing purchase lines will be deleted and new purchase lines based on the new information in the header will be created.\The amount of the item charge assignment will be reset to 0.\\Do you want to continue?', Comment = '%1 = Field Caption';

        Confirmed: Boolean;
        Text018_Txt: Label 'You must delete the existing purchase lines before you can change %1.', Comment = '%1 = Field Caption';
        RecreatePurchLinesMsg: Label 'If you change %1, the existing purchase lines will be deleted and new purchase lines based on the new information in the header will be created.\\Do you want to continue?;ESM=Si cambia %1, las l¡neas de compra existentes ser n eliminadas y se crear n nuevas l¡neas de compra basadas en la nueva informaci¢n en el encabezado.\\¨Desea continuar?;FRC=Si vous modifiez %1, les lignes achat existantes seront supprim‚es et de nouvelles lignes achat bas‚es sur les nouvelles informations dans l''en-tˆte seront cr‚‚es.\\Voulez-vous continuer?', Comment = '%1 = Field Caption';
    /*+-----------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     14021100 Job No.
      +     14021104 Draw No.
      +     14021130 Retention Invoice Disc. Amount
      +     14021325 Progress Payment Document
      +     14021327 From Progress Payment No.
      +     14021328 From Progress Payment Req.
      +     14021329 From Progress Payment Ver.
      +     14021136 Retention Base Amount
      +     14021137 Retention Base Before Tax
      +     14021138 Retention Percent
      +     14021139 Retention Amount (LCY)
      +     14021140 Retention Amount
      +     14021145 Retention Date
      +     14021146 Retention Document
      +     14021300 Subcontract No.
      +     14021301 Retention Ledger Code
      +     14021340 Prog Pay Subcontract No.
      +     14021400 Job Name
      +     14021401 Job Location
      +     14021402 Customer Account Name
      +
      +  - Added Function(s):
      +     PP_AssignDefaultValuesToTaxFields
      +     PP_PostPurchaseReturn
      +     PP_CalcHeaderRetention
      +     RetentionBase
      +     IsSingleVendorSelected
      +
      +  - Added global variable(s):
      +     PP_JobsSetup
      +     PP_Currency
      +     ArchiveManagement
      +
      +  - Added global text constant(s):
      +     Text14021100
      +     Text14021101
      +     Text14021102
      +
      +  - Modifications(s):
      +     - Added Keys
      +         Job No.
      +         Subcontract No.
      +     - CreateDim() - added 5th parameter for Job table
      +     - OnValidate() - added call to PP_AssignDefaultValuesToTaxFields()
      +         Buy-from Vendor No
      +         Job No.
      +     - Modifications to handle the partial receipt retention values posted
      +     - Required a Posting Date or Document Date to be set when Retention Percent is entered.
      +     - Blocked all code in VerifyReceivedShippedItemLineDimChange
      +-----------------------------------------------------*/
}

