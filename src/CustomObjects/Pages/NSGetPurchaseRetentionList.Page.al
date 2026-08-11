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
    Permissions = TableData "Vendor Ledger Entry" = rm;//PE-204.AS.2.0 ADD
    SourceTable = "Vendor Ledger Entry";
    // SourceTableView = SORTING("Vendor No.", "Posting Date", "Currency Code")
    //                   ORDER(Ascending)
    //                   WHERE("Global Dimension 2 Code" = CONST('RETENTION'));//PE-204.AS.2.0 COMMENT
    SourceTableView = SORTING("Vendor No.", "Posting Date", "Currency Code")
                      ORDER(Ascending);//PE-204.AS.2.0 ADD

    layout
    {
        area(content)
        {
            field(JobNoFilter; JobNoFilter)
            {
                ApplicationArea = All;
                Caption = 'Job No. Filter';
                ToolTip = 'Specifies the job no filter.';

                trigger OnValidate()
                var
                begin
                    //PE-204.AS.1.0 START
                    if JobNoFilter <> '' then begin
                        Rec.SetFilter("NS_Job No.", JobNoFilter);
                        CurrPage.Update();
                    end else begin
                        Rec.SetRange("NS_Job No.");
                        CurrPage.Update();
                    end;
                    //PE-204.AS.1.0 END

                end;
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
                //PE-204.AS.1.0 START 
                field("NS_Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    Caption = 'Job No.';
                    ToolTip = 'Job No.';
                }
                field("NS_Retention Ledger Code"; Rec."NS_Retention Ledger Code")
                {
                    ApplicationArea = All;
                    Caption = 'Retention ledger Code';
                    ToolTip = 'Retention Ledger Code';
                }
                //PE-204.AS.1.0 END
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
                    var
                        jbstp: Record "Jobs Setup";//PE-204.AS.4.0
                        vleRec: Record "Vendor Ledger Entry";//PE-204.AS.4.0
                    begin
                        //PE-204.AS.4.0 START
                        if jbstp.get() then;
                        vleRec.Reset();
                        vleRec.SetRange("Vendor No.", Rec."Vendor No.");
                        vleRec.SetRange("Document Type", Rec."Document Type"::Invoice);
                        vleRec.SetRange(Open, TRUE);
                        vleRec.SetRange("NS_Job No.", Rec."NS_Job No.");
                        vleRec.SetRange("NS_Retention Ledger Code", jbstp."NS_Retention Payable Ledger");
                        vleRec.SetFilter("NS_Retention Applies-to Amount", '<>%1', 0);
                        if vleRec.Count() >= 1 then
                            Error('You can only apply one line of Retention on a Purchase Invoice');
                        //PE-204.AS.4.0 END

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
                    ToolTip = 'Global Dimension 1 Code'; //PE-75.RM.1.0 23May2023 
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Global Dimension 2 Code'; //PE-75.RM.1.0 23May2023 
                }
            }
            group(Control41)
            {
                Caption = '';//PE-204.AS.4.0
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
                    var
                        vleRec: Record "Vendor Ledger Entry";//PE-204.AS.4.0
                        jbstp: Record "Jobs Setup";//PE-204.AS.4.0
                    begin
                        //PE-204.AS.4.0 START
                        if jbstp.get() then;
                        vleRec.Reset();
                        vleRec.SetRange("Vendor No.", Rec."Vendor No.");
                        vleRec.SetRange("Document Type", Rec."Document Type"::Invoice);
                        vleRec.SetRange(Open, TRUE);
                        vleRec.SetRange("NS_Job No.", Rec."NS_Job No.");
                        vleRec.SetRange("NS_Retention Ledger Code", jbstp."NS_Retention Payable Ledger");
                        vleRec.SetFilter("NS_Retention Applies-to Amount", '<>%1', 0);
                        if vleRec.Count() >= 1 then
                            Error('You can only apply one line of Retention on a Purchase Invoice');
                        //PE-204.AS.4.0 END
                        if vleRec.Count() = 0 then begin //PE-204.AS.4.0 START COunt condition Added Begin..end
                            if Rec."NS_Retention Applies-to Amount" = 0 then //PRJ-1131.NK.1.0
                                Rec."NS_Retention Applies-to Amount" := Rec."Remaining Amount" //PRJ-1131.NK.1.0
                            else
                                Rec."NS_Retention Applies-to Amount" := 0; //PRJ-1131.NK.1.0
                            Rec.MODIFY(); //PRJ-1131.NK.1.0
                        end;//PE-204.AS.4.0 END COunt condition Added Begin..end
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
                        vleRec: Record "Vendor Ledger Entry";//PE-204.AS.4.0
                        jbstp: Record "Jobs Setup";//PE-204.AS.4.0
                    begin
                        //PE-204.AS.4.0 START
                        if jbstp.get() then;
                        vleRec.Reset();
                        vleRec.SetRange("Vendor No.", Rec."Vendor No.");
                        vleRec.SetRange("Document Type", Rec."Document Type"::Invoice);
                        vleRec.SetRange(Open, TRUE);
                        vleRec.SetRange("NS_Job No.", Rec."NS_Job No.");
                        vleRec.SetRange("NS_Retention Ledger Code", jbstp."NS_Retention Payable Ledger");
                        vleRec.SetFilter("NS_Retention Applies-to Amount", '<>%1', 0);
                        if vleRec.Count() >= 1 then
                            Error('You can only apply one line of Retention on a Purchase Invoice');
                        //PE-204.AS.4.0 END

                        EnteredPct := 0;
                        CLEAR(EnterPercentage);
                        if EnterPercentage.RUNMODAL = ACTION::OK then
                            EnterPercentage.NS_ReturnPercentage(EnteredPct);

                        if vleRec.Count() = 0 then begin//PE-204.AS.4.0 START COunt condition Added Begin..end
                            Rec."NS_Retention Applies-to Amount" := ROUND(Rec.Amount * (EnteredPct / 100), 0.01); //PRJ-1131.NK.1.0
                            Rec.MODIFY(); //PRJ-1131.NK.1.0
                        end;//PE-204.AS.4.0 END COunt condition Added Begin..end
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
                    Visible = false; //PE-204.AS.4.0

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
        Rec.FilterGroup(2); //PRJCTPR-273.NC.1.0 21Dec2023
        if not PurchSetup."NS_Purchase Retention Inactive" then
            SETRANGE("NS_Retention Ledger Code", JobsSetup."NS_Retention Receivable Ledger");
        Rec.FilterGroup(0); //PRJCTPR-273.NC.1.0 21Dec2023
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
        JobNoFilter := PurHdr."NS_Job No.";//PE-204.AS.1.0
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

