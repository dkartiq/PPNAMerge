page 14021224 "NS_Prepayment History"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Prepayment Lines';
    DataCaptionFields = "NS_Prepayment for Job No.";
    PageType = Card;
    SourceTable = "G/L Entry";

    layout
    {
        area(content)
        {
            group(Entry)
            {
                field(TotalBalanceAvailable; -TotalBalanceAvailable)
                {
                    ApplicationArea = All;
                    Caption = 'Total Balance Available';
                    Editable = false;
                    ToolTip = 'Specifies the Total Balance Available';
                }
                field(AmountToApply; AmountToApply)
                {
                    ApplicationArea = All;
                    Caption = 'Amount To Apply';
                    ToolTip = 'Specifies the Amount To Apply';
                }
            }
            group(History)
            {
                repeater(HistoryLines)
                {
                    field("Document No."; Rec."Document No.")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        HideValue = "Document No.HideValue";
                        StyleExpr = 'Strong';
                        ToolTip = 'Specifies the Document No.';
                    }
                    field("Posting Date"; Rec."Posting Date")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the Posting Date';
                        Visible = false;
                    }
                    field("Document Date"; Rec."Document Date")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the Document Date';
                    }
                    field(Description; Rec.Description)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the Description';
                    }
                    field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Visible = false;
                    }
                    field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Visible = false;
                    }
                    field("-Amount"; -Amount)
                    {
                        ApplicationArea = All;
                        Caption = 'Amount';
                        Editable = false;
                        ToolTip = 'Specifies the Amount';
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        NS_GetBalanceAvailable();
    end;

    trigger OnInit();
    begin
        CurrPage.LOOKUPMODE := true;
    end;

    trigger OnOpenPage();
    begin
        RESET();
        SETCURRENTKEY("NS_Prepayment for Job No.");
        SETRANGE("NS_Prepayment for Job No.", HoldJob);
        if FINDSET() then
            repeat
                TotalBalanceAvailable := TotalBalanceAvailable + Amount;
            until NEXT() = 0;
    end;

    var
        GenLedgEntry: Record "G/L Entry";
        HoldJob: Code[20];
        OriginalEntryNo: Integer;
        TotalBalanceAvailable: Decimal;
        AmountToApply: Decimal;
        BalanceAvailable: Decimal;
        [InDataSet]
        "Document No.HideValue": Boolean;

    procedure NS_Set(JobIn: Code[20]);
    begin
        HoldJob := JobIn;
    end;

    procedure NS_Get(var EntryNo: Integer; var BalanceToUse: Decimal);
    begin
        BalanceToUse := AmountToApply;
    end;

    procedure NS_GetBalanceAvailable();
    begin
        with GenLedgEntry do begin
            RESET();
            SETCURRENTKEY("Document No.");
            SETRANGE("Document No.", Rec."Document No.");
            FINDSET();
            OriginalEntryNo := "Entry No.";
            RESET();
            SETCURRENTKEY("NS_Prepayment for Job No.");
            SETRANGE("NS_Prepayment for Job No.", "Job No.");
            if FINDSET() then
                repeat
                    BalanceAvailable := BalanceAvailable + Amount;
                until NEXT() = 0;
        end;
    end;
}

