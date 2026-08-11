page 14021303 "NS_Subcontract Ledger Entries"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Subcontract Ledger Entries';
    DataCaptionExpression = "NS_Subcontract No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "NS_Subcontract Ledger Entry";
    UsageCategory = Documents;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Subcontract No."; Rec."NS_Subcontract No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Subcontract No.';
                }
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Job No.';
                }
                field("Posting Date"; Rec."NS_Posting Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Posting Date';
                }
                field("Entry Type"; Rec."NS_Entry Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Entry Type';
                }
                field("Document No."; Rec."NS_Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Document No.';
                }
                field(Type; Rec.NS_Type)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Type';
                }
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the No.';
                }
                field("Variant Code"; Rec."NS_Variant Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Variant Code';
                    Visible = false;
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Description';
                }
                field("Job Task No."; Rec."NS_Job Task No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Task No.';
                }
                field("Global Dimension 1 Code"; Rec."NS_Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Global Dimension 1 Code';
                }
                field("Global Dimension 2 Code"; Rec."NS_Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Global Dimension 2 Code';
                }
                field("Work Type Code"; Rec."NS_Work Type Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Work Type Code';
                    Visible = false;
                }
                field("Location Code"; Rec."NS_Location Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Location Code';
                    Visible = true;
                }
                field("Work Units"; Rec."NS_Work Units")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Units';
                }
                field("Work Unit of Measure"; Rec."NS_Work Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Unit of Measure';
                }
                field(Quantity; Rec.NS_Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Quantity';
                }
                field("Unit of Measure Code"; Rec."NS_Unit of Measure Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Unit of Measure Code';
                }
                field("Direct Unit Cost (LCY)"; Rec."NS_Direct Unit Cost (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Direct Unit Cost (LCY)';
                    Visible = false;
                }
                field("Unit Cost (LCY)"; Rec."NS_Unit Cost (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Unit Cost (LCY)';
                    Visible = false;
                }
                field("Total Cost (LCY)"; Rec."NS_Total Cost (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Total Cost (LCY)';
                }
                field("User ID"; Rec."NS_User ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the User ID';
                    Visible = false;
                }
                field("Source Code"; Rec."NS_Source Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Source Code';
                    Visible = false;
                }
                field("Reason Code"; Rec."NS_Reason Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies Reason Code';
                    Visible = false;
                }
                field("Entry No."; Rec."NS_Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies Entry No.';
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
                action(NS_Dimensions)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View/edit dimensions.';

                    trigger OnAction();
                    begin
                        xRec.NS_ShowDimensions();
                    end;
                }
            }
        }
        area(processing)
        {
            action("NS_&Navigate")
            {
                Caption = '&Navigate';
                ApplicationArea = All;
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Navigate';

                trigger OnAction();
                begin
                    Navigate.SetDoc("NS_Posting Date", "NS_Document No.");
                    Navigate.RUN;
                end;
            }
        }
    }

    trigger OnModifyRecord(): Boolean;
    begin
        //SPLN missing reference: CODEUNIT.RUN(CODEUNIT::Codeunit14021107,Rec);
        exit(false);
    end;

    trigger OnOpenPage();
    begin
        if FilterSet then begin
            if "ShowSub-Levels" then begin
                RESET();
                Subcontract.RESET();
                Subcontract.SETFILTER("NS_No.", ShowSubcontractRec."NS_No.");
                if Subcontract.FINDSET then
                    repeat
                        Subcontract."MarkSub-Levels"(Subcontract, true);
                    until Subcontract.NEXT() = 0;

                Subcontract.MARKEDONLY(true);
                if Subcontract.FINDSET() then
                    repeat
                        SubcontractLedgEntry2.RESET;
                        SubcontractLedgEntry2.SETCURRENTKEY("NS_Subcontract No.", "NS_Entry Type", "NS_Posting Date", NS_Type);
                        SubcontractLedgEntry2.SETRANGE("NS_Subcontract No.", Subcontract."NS_No.");
                        SubcontractLedgEntry2.SETFILTER("NS_Entry Type", ShowSubcontractRec.GETFILTER("NS_Job Task No. Filter"));
                        SubcontractLedgEntry2.SETFILTER("NS_Posting Date", ShowSubcontractRec.GETFILTER("NS_Posting Date Filter"));
                        SubcontractLedgEntry2.SETFILTER(NS_Type, ShowSubcontractRec.GETFILTER("NS_Type Filter"));
                        if SubcontractLedgEntry2.FINDSET then
                            repeat
                                GET(SubcontractLedgEntry2."NS_Entry No.");
                                MARK(true);
                            until SubcontractLedgEntry2.NEXT = 0;
                    until Subcontract.NEXT = 0;

                //Now look for ledger entries for this subcontract
                SubcontractLedgEntry2.SETRANGE("NS_Subcontract No.", ShowSubcontractRec."NS_No.");
                if SubcontractLedgEntry2.FINDSET then
                    repeat
                        GET(SubcontractLedgEntry2."NS_Entry No.");
                        MARK(true);
                    until SubcontractLedgEntry2.NEXT() = 0;
                MARKEDONLY(true);
            end else begin
                RESET;
                SETCURRENTKEY("NS_Subcontract No.", "NS_Entry Type", "NS_Posting Date", NS_Type);
                if ShowSubcontractRec."NS_No." > '' then
                    SETRANGE("NS_Subcontract No.", ShowSubcontractRec."NS_No.");
                if ShowSubcontractRec.GETFILTER("NS_Job Task No. Filter") > '' then
                    SETFILTER("NS_Entry Type", ShowSubcontractRec.GETFILTER("NS_Job Task No. Filter"));
                if ShowSubcontractRec.GETFILTER("NS_Posting Date Filter") > '' then
                    SETFILTER("NS_Posting Date", ShowSubcontractRec.GETFILTER("NS_Posting Date Filter"));
                if ShowSubcontractRec.GETFILTER("NS_Type Filter") > '' then
                    SETFILTER(NS_Type, ShowSubcontractRec.GETFILTER("NS_Type Filter"));
                if ShowSubcontractRec.GETFILTER("NS_Entry Type Filter") > '' then
                    SETFILTER("NS_Entry Type", ShowSubcontractRec.GETFILTER("NS_Entry Type Filter"));
            end;
        end;
    end;

    var
        SubcontractJnlLine: Record "NS_Subcontract Journal Line";
        PurchaseLine: Record "Purchase Line";
        Subcontract: Record NS_Subcontract;
        SubcontractHold: Record NS_Subcontract;
        SubcontractLedgEntry: Record "NS_Subcontract Ledger Entry";
        SubcontractLedgEntry2: Record "NS_Subcontract Ledger Entry";
        CallingLineType: Option SubcontractJnlLine,PurchaseLine;
        ShowSubcontractRec: Record NS_Subcontract;
        "ShowSub-Levels": Boolean;
        FilterSet: Boolean;
        Navigate: Page Navigate;

    procedure NS_SetSubcontractJnlLine(var NewSubcontractJnlLine: Record "NS_Subcontract Journal Line");
    begin
        SubcontractJnlLine := NewSubcontractJnlLine;
        CallingLineType := CallingLineType::SubcontractJnlLine;
    end;

    procedure NS_SetPurchaseLine(var NewPurchaseLine: Record "Purchase Line");
    begin
        PurchaseLine := NewPurchaseLine;
        CallingLineType := CallingLineType::PurchaseLine;
    end;

    procedure NS_SetFilters(var SubcontractRec: Record NS_Subcontract; "IncludeSub-Levels": Boolean);
    begin
        ShowSubcontractRec := SubcontractRec;
        ShowSubcontractRec.COPYFILTERS(SubcontractRec);
        "ShowSub-Levels" := "IncludeSub-Levels";
        FilterSet := true;
    end;
}

