page 14021212 "NS_Get Sales Retention List"
{
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Get Sales Retention List';
    DataCaptionFields = "Customer No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    Permissions = TableData "Cust. Ledger Entry" = rm;
    SourceTable = "Cust. Ledger Entry";
    SourceTableView = SORTING("Customer No.", "Posting Date", "Currency Code")
                      ORDER(Ascending);
    // >> Upgrade
    PromotedActionCategories = 'New,Process,Report,Include';
    // << Upgrade
    layout
    {
        area(content)
        {
            field(JobNoFilter; JobNoFilter)
            {
                ApplicationArea = All;
                Caption = 'Job No. Filter';
                ToolTip = 'Specifies the ob No. Filter';

                trigger OnValidate()
                var
                begin
                    //MHNA-3.NK.1.0 start 08feb2023
                    if JobNoFilter <> '' then begin
                        Rec.SetFilter("NS_Job No.", JobNoFilter);
                        CurrPage.Update();
                    end else begin
                        Rec.SetRange("NS_Job No.");
                        CurrPage.Update();
                    end;
                    //MHNA-3.NK.1.0 End 08feb2023

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
                //MHNA-3.NK.1.0  start 07feb2023 
                field("NS_Job No."; "NS_Job No.")
                {
                    ApplicationArea = All;
                    Caption = 'Job No.';
                    ToolTip = 'Job No.'; //PE-75.RM.1.0 23May2023
                }
                field("NS_Retention Ledger Code"; "NS_Retention Ledger Code")
                {
                    ApplicationArea = All;
                    Caption = 'Retention ledger Code';
                    ToolTip = 'Retention Ledger Code';  //PE-75.RM.1.0 23May2023
                }
                //MHNA-3.NK.1.0  end 07feb2023 
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

                    trigger OnValidate();
                    begin
                        NS_RetentionAppliestoAmountOnAfte();
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
                action("Reminder/Fin. Charge Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Reminder/Fin. Charge Entries';
                    Image = Reminder;
                    RunObject = Page "Reminder/Fin. Charge Entries";
                    RunPageLink = "Customer Entry No." = FIELD("Entry No.");
                    RunPageView = SORTING("Customer Entry No.");
                    ToolTip = 'View the Reminder/Fin. Charge Entries';
                }
                action("Detailed &Ledger Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Detailed &Ledger Entries';
                    Image = CustomerLedger;
                    RunObject = Page "Detailed Cust. Ledg. Entries";
                    RunPageLink = "Cust. Ledger Entry No." = FIELD("Entry No.");
                    RunPageView = SORTING("Cust. Ledger Entry No.", "Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the Detailed &Ledger Entries';
                }
                action("Applied E&ntries")
                {
                    ApplicationArea = All;
                    Caption = 'Applied E&ntries';
                    Image = Approve;
                    RunObject = Page "Applied Customer Entries";
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
                    ToolTip = 'Include';
                    // >> Upgrade
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    // << Upgrade
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
                    ToolTip = 'Include retention percentage';
                    // >> upgrade
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    // << Upgrade
                    trigger OnAction();
                    var
                        Window: Dialog;
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
                    ToolTip = 'Include all rentention percentage.';
                    // >> Upgrade
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    // << Upgrade
                    trigger OnAction();
                    var
                        EnteredPct: Decimal;
                    begin
                        EnteredPct := 0;
                        CLEAR(EnterPercentage);
                        if EnterPercentage.RUNMODAL = ACTION::OK then
                            EnterPercentage.NS_ReturnPercentage(EnteredPct);

                        CustLedgEntry2.RESET();
                        CustLedgEntry2.COPYFILTERS(Rec);
                        if CustLedgEntry2.FINDSET() then
                            repeat
                                CustLedgEntry2.CALCFIELDS(Amount);
                                CustLedgEntry2."NS_Retention Applies-to Amount" := ROUND(CustLedgEntry2.Amount * (EnteredPct / 100), 0.01);
                                CustLedgEntry2.MODIFY();
                            until CustLedgEntry2.NEXT() = 0;

                        CurrPage.UPDATE();
                        NS_FormCalculations();
                    end;
                }
                action("&Clear All")
                {
                    ApplicationArea = All;
                    Caption = '&Clear All';
                    Image = ClearLog;
                    ToolTip = 'Clear all retention.';
                    // >> Upgrade
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    // << Upgrade
                    trigger OnAction();
                    begin
                        CustLedgEntry2.RESET();
                        CustLedgEntry2.COPYFILTERS(Rec);
                        if CustLedgEntry2.FINDSET() then
                            repeat
                                CustLedgEntry2."NS_Retention Applies-to Amount" := 0;
                                CustLedgEntry2.MODIFY();
                            until CustLedgEntry2.NEXT() = 0;

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
                // >> Upgrade
                PromotedOnly = true;

                // << Upgrade

                trigger OnAction();
                begin
                    //PPDA.1.0 Start
                    // Navigate.NS_SetDocLedger("Global Dimension 2 Code", "Posting Date", "Document No.");
                    // Navigate.RUN;
                    //PPDA.1.0 End
                end;
            }
        }
    }

    trigger OnModifyRecord(): Boolean;
    begin
        CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit", Rec);
        exit(false);
    end;

    trigger OnOpenPage();
    begin
        SalesSetup.GET();
        JobsSetup.GET();
        if not SalesSetup."NS_Sales Retention Inactive" then
            SETRANGE("NS_Retention Ledger Code", JobsSetup."NS_Retention Receivable Ledger");
        CustLedgEntry.COPY(Rec);
        NS_FormCalculations();
    end;

    var
        Text000: Label 'Undefined';
        CustLedgEntry: Record "Cust. Ledger Entry";
        CustLedgEntry2: Record "Cust. Ledger Entry";
        SalesHeader: Record "Sales Header";
        // SalesLine: Record "Sales Line";
        // Job: Record Job;
        // Customer: Record Customer;
        // CustomerPostingGroup: Record "Customer Posting Group";
        SalesSetup: Record "Sales & Receivables Setup";
        JobsSetup: Record "Jobs Setup";
        TotalAmount: Decimal;
        TotalRetention: Decimal;
        ApplnCurrencyCode: Code[10];
        // LastLineNo: Integer;
        JobNoFilter: Code[20];
        // Navigate: Page "NS_Navigate"; //PPDA.1.0 Commented
        EnterPercentage: Page "NS_Enter Percentage";

    procedure NS_SetSalesHeader(SlsHdr: Record "Sales Header");
    begin
        SalesHeader := SlsHdr;
        JobNoFilter := SlsHdr."NS_Job No.";  //MHNA-3.NK.1.0  start 08feb2023
    end;

    procedure NS_FormCalculations();
    begin
        //Calculate total retention chosen
        TotalAmount := 0;
        TotalRetention := 0;
        CustLedgEntry2.RESET();
        CustLedgEntry2.COPYFILTERS(Rec);
        if CustLedgEntry2.FINDSET() then
            repeat
                CustLedgEntry2.CALCFIELDS(Amount);
                TotalAmount := TotalAmount + CustLedgEntry2.Amount;
                TotalRetention := TotalRetention + CustLedgEntry2."NS_Retention Applies-to Amount";
            until CustLedgEntry2.NEXT() = 0;
    end;

    local procedure NS_RetentionAppliestoAmountOnAfte();
    begin
        CurrPage.UPDATE();
        NS_FormCalculations();
    end;
}

