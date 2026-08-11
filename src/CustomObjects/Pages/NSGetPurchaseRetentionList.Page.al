page 14021213 "NS_Get Purchase Retention List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Get Purchase Retention List';
    DataCaptionFields = "Vendor No.";
    DeleteAllowed = false;
    UsageCategory = Documents;
    ApplicationArea = Jobs;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Vendor Ledger Entry";
    SourceTableView = SORTING("Vendor No.", "Posting Date", "Currency Code")
                      ORDER(Ascending)
                      WHERE("Global Dimension 2 Code" = CONST('RETENTION'));

    layout
    {
        area(content)
        {
            field(JobNoFilter; JobNoFilter)
            {
                ApplicationArea = All;
                Caption = 'Job No. Filter';
                ToolTip = 'Specifies the job no filter.';
            }
            repeater(Control1)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Posting Date';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Document Type';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Document No.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Description';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Currency Code';
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Amount';
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Remaining Amount';
                }
                field("Retention Applies-to Amount"; Rec."NS_Retention Applies-to Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Retention Applies-to Amount';
                    Visible = true;

                    trigger OnValidate();
                    begin
                        NS_RetentionAppliestoAmountOnAfte;
                    end;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Due Date';
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Open';
                    Visible = false;
                }
                field(Positive; Rec.Positive)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Positive';
                    Visible = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
            group(Control41)
            {
                field(TotalAmount; TotalAmount)
                {
                    ApplicationArea = All;
                    AutoFormatExpression = ApplnCurrencyCode;
                    AutoFormatType = 1;
                    Caption = 'Amount';
                    Editable = false;
                    ToolTip = 'Specifies the Amount';
                }
                field(TotalRetention; TotalRetention)
                {
                    ApplicationArea = All;
                    AutoFormatExpression = ApplnCurrencyCode;
                    AutoFormatType = 1;
                    Caption = 'Current';
                    Editable = false;
                    ToolTip = 'Specifies the Current';
                }
                field("TotalAmount - TotalRetention"; TotalAmount - TotalRetention)
                {
                    ApplicationArea = All;
                    AutoFormatExpression = ApplnCurrencyCode;
                    AutoFormatType = 1;
                    Caption = 'Balance';
                    Editable = false;
                    ToolTip = 'Specifies the Balance';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                action("Detailed &Ledger Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Detailed &Ledger Entries';
                    Image = VendorLedger;
                    RunObject = Page "Detailed Vendor Ledg. Entries";
                    RunPageLink = "Vendor Ledger Entry No." = FIELD("Entry No.");
                    RunPageView = SORTING("NS_Subcontract No.", "Vendor Ledger Entry No.", "Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("Applied E&ntries")
                {
                    ApplicationArea = All;
                    Caption = 'Applied E&ntries';
                    Image = Approve;
                    RunObject = Page "Applied Vendor Entries";
                    RunPageOnRec = true;
                    ToolTip = 'View the Applied E&ntries';
                }
            }
            group("&Include")
            {
                Caption = '&Include';
                action(Action1100773002)
                {
                    ApplicationArea = All;
                    Caption = '&Include';
                    Image = SelectField;
                    ShortCutKey = 'F7';
                    ToolTip = 'Include retention';

                    trigger OnAction();
                    begin
                        if "NS_Retention Applies-to Amount" = 0 then
                            "NS_Retention Applies-to Amount" := "Remaining Amount"
                        else
                            "NS_Retention Applies-to Amount" := 0;
                        MODIFY();

                        CurrPage.UPDATE();
                        NS_FormCalculations();
                    end;
                }
                action("Include &%")
                {
                    ApplicationArea = All;
                    Caption = 'Include &%';
                    Image = Percentage;
                    ShortCutKey = 'Shift+F11';
                    ToolTip = 'Include retention perentage';

                    trigger OnAction();
                    var
                        EnteredPct: Decimal;
                    begin
                        EnteredPct := 0;
                        CLEAR(EnterPercentage);
                        if EnterPercentage.RUNMODAL = ACTION::OK then
                            EnterPercentage.NS_ReturnPercentage(EnteredPct);
                        "NS_Retention Applies-to Amount" := ROUND(Amount * (EnteredPct / 100), 0.01);
                        MODIFY();

                        CurrPage.UPDATE();
                        NS_FormCalculations();
                    end;
                }
                action("Include &All %")
                {
                    ApplicationArea = All;
                    Caption = 'Include &All %';
                    Image = ExciseApplyToLine;
                    ShortCutKey = 'Ctrl+F11';
                    ToolTip = 'Include all retention percentage';

                    trigger OnAction();
                    var
                        EnteredPct: Decimal;
                    begin
                        EnteredPct := 0;
                        CLEAR(EnterPercentage);
                        if EnterPercentage.RUNMODAL = ACTION::OK then
                            EnterPercentage.NS_ReturnPercentage(EnteredPct);

                        VendLedgEntry2.RESET();
                        VendLedgEntry2.COPYFILTERS(Rec);
                        if VendLedgEntry2.FINDSET() then
                            repeat
                                VendLedgEntry2.CALCFIELDS(Amount);
                                VendLedgEntry2."NS_Retention Applies-to Amount" := ROUND(VendLedgEntry2.Amount * (EnteredPct / 100), 0.01);
                                VendLedgEntry2.MODIFY();
                            until VendLedgEntry2.NEXT() = 0;

                        CurrPage.UPDATE();
                        NS_FormCalculations();
                    end;
                }
                action("&Clear All")
                {
                    ApplicationArea = All;
                    Caption = '&Clear All';
                    Image = ClearLog;
                    ToolTip = 'Clear all.';

                    trigger OnAction();
                    begin
                        VendLedgEntry2.RESET();
                        VendLedgEntry2.COPYFILTERS(Rec);
                        if VendLedgEntry2.FINDSET() then
                            repeat
                                VendLedgEntry2."NS_Retention Applies-to Amount" := 0;
                                VendLedgEntry2.MODIFY();
                            until VendLedgEntry2.NEXT() = 0;

                        CurrPage.UPDATE();
                        NS_FormCalculations();
                    end;
                }
            }
        }
        area(processing)
        {
            action("&Navigate")
            {
                ApplicationArea = All;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Navigate';

                trigger OnAction();
                begin
                    Navigate.SetDoc("Posting Date", "Document No.");
                    Navigate.RUN;
                end;
            }
        }
    }

    trigger OnInit();
    begin
        CurrPage.LOOKUPMODE := true;
    end;

    trigger OnModifyRecord(): Boolean;
    begin
        CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit", Rec);
        exit(false);
    end;

    trigger OnOpenPage();
    begin
        PurchSetup.GET();
        JobsSetup.GET();
        if not PurchSetup."NS_Purchase Retention Inactive" then
            SETRANGE("NS_Retention Ledger Code", JobsSetup."NS_Retention Receivable Ledger");
        VendLedgEntry.COPY(Rec);
        NS_FormCalculations();
    end;

    var
        Text000: Label 'Undefined';
        VendLedgEntry: Record "Vendor Ledger Entry";
        VendLedgEntry2: Record "Vendor Ledger Entry";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        Job: Record Job;
        Vendor: Record Vendor;
        VendorPostingGroup: Record "Vendor Posting Group";
        PurchSetup: Record "Purchases & Payables Setup";
        JobsSetup: Record "Jobs Setup";
        TotalAmount: Decimal;
        TotalRetention: Decimal;
        ApplnCurrencyCode: Code[10];
        LastLineNo: Integer;
        JobNoFilter: Code[20];
        Navigate: Page Navigate;
        EnterPercentage: Page "NS_Enter Percentage";

    procedure NS_SetPurchHeader(PurHdr: Record "Purchase Header");
    begin
        PurchHeader := PurHdr;
    end;

    procedure NS_FormCalculations();
    begin
        //Calculate total retention chosen
        TotalAmount := 0;
        TotalRetention := 0;
        VendLedgEntry2.RESET();
        VendLedgEntry2.COPYFILTERS(Rec);
        if VendLedgEntry2.FINDSET() then
            repeat
                VendLedgEntry2.CALCFIELDS(Amount);
                TotalAmount := TotalAmount + VendLedgEntry2.Amount;
                TotalRetention := TotalRetention + VendLedgEntry2."NS_Retention Applies-to Amount";
            until VendLedgEntry2.NEXT() = 0;
    end;

    local procedure NS_RetentionAppliestoAmountOnAfte();
    begin
        CurrPage.UPDATE();
        NS_FormCalculations();
    end;
}

