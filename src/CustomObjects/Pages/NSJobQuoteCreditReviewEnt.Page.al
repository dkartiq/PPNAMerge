page 14021417 "NS_Job Quote Credit Review Ent"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Credit Review Entries';
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    SourceTable = "NS_Job Credit Review Ent.";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer No."; Rec."NS_Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Customer No.';
                }
                field("Customer Name"; Rec."NS_Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Customer Name';
                }
                field("Document Area"; Rec."NS_Document Area")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Document Area';
                }
                field("Document Type"; Rec."NS_Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Document Type';
                }
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';
                }
                field(Collector; Rec.NS_Collector)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Collector';
                }
                field("Document Amount"; Rec."NS_Document Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Document Amount';
                }
                field("Release Attempted"; Rec."NS_Release Attempted")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Release Attempted';
                }
                field(Status; Rec.NS_Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Status';
                }
                field("Entry Text"; Rec."NS_Entry Text")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Entry Text';
                }
            }
        }
        area(factboxes)
        {
            part("Customer Statistics"; "Customer Statistics FactBox")
            {
                ApplicationArea = All;
                Caption = 'Customer Statistics';
                SubPageLink = "No." = FIELD("NS_Customer No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(NS_Navigate)
            {
                ApplicationArea = All;
                Caption = 'Navigate';

                ToolTip = 'Navigate';

                trigger OnAction();
                begin
                    CreditReviewMgt.NS_OpenSource(Rec);
                end;
            }
        }
        area(processing)
        {
            action(Reopen)
            {
                ApplicationArea = All;
                Caption = 'Re&open';
                ToolTip = 'Re&open';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    CreditReviewMgt.NS_Reopen(Rec);
                    CurrPage.UPDATE(false);
                end;
            }
            action(NS_Approve)
            {
                ApplicationArea = All;
                Caption = 'App&rove';

                ToolTip = 'App&rove';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    CreditReviewMgt.NS_Approve(Rec, '');
                    CurrPage.UPDATE(false);
                end;
            }
            action("NS_Document History")
            {
                ApplicationArea = All;
                Caption = 'Document &History';
                ToolTip = 'Document &History';

                Image = History;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    NS_ShowDocumentHistory();
                end;
            }
            action("NS_Documents for Review")
            {
                ApplicationArea = All;
                Caption = 'Docu&ments for Review';
                ToolTip = 'Docu&ments for Review';

                Image = SelectEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    NS_ShowEntriesForReview(false);
                end;
            }
            action("NS_Show Document")
            {
                ApplicationArea = All;
                Caption = 'Show Document';
                ToolTip = 'Show Document';

                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Shift+F7';

                trigger OnAction();
                begin
                    NS_ShowDocument();
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        CreditReviewMgt.NS_Authorize(Text000Lbl);
        NS_ShowEntriesForReview(true);
    end;

    var
        CreditReviewMgt: Codeunit "NS_Job CreditReviewMgt.";
        Text000Lbl: Label 'Not authorized to view Credit Review entries.';
        Text002Lbl: Label 'Document %1 does not exist.', Comment = '%1=Job No.';

    procedure NS_ShowDocumentHistory();
    begin
        SETCURRENTKEY("NS_Table ID", "NS_No.", "NS_Document Area");
        ASCENDING(true);
        SETRANGE("NS_Table ID", DATABASE::"Sales Header");
        SETRANGE("NS_Document Area", "NS_Document Area"::Sales);
        SETRANGE("NS_No.", "NS_No.");
        SETRANGE(NS_Status);
        SETRANGE("NS_Last Entry");
        SETRANGE("NS_Release Attempted");
        CurrPage.UPDATE(false);
    end;

    procedure NS_ShowEntriesForReview(_InitialView: Boolean);
    var
        _No: Code[20];
    begin
        _No := "NS_No.";

        SETCURRENTKEY("NS_Table ID", "NS_No.", "NS_Document Area");
        ASCENDING(false);
        SETRANGE("NS_Table ID", DATABASE::"Sales Header");
        SETRANGE("NS_Document Area", "NS_Document Area"::Sales);
        SETRANGE("NS_No.");
        SETRANGE(NS_Status, NS_Status::Review);
        SETRANGE("NS_Last Entry", true);
        SETRANGE("NS_Release Attempted", true);

        if _InitialView then
            exit;

        SETRANGE("NS_No.", _No);
        if FINDFIRST() then;
        SETRANGE("NS_No.");
        CurrPage.UPDATE(false);
    end;

    procedure NS_ShowDocument();
    var
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";
    begin
        case "NS_Document Area" of
            "NS_Document Area"::Sales:
                begin
                    if not SalesHeader.GET("NS_Document Type", "NS_No.") then
                        ERROR(Text002Lbl, "NS_No.");
                    case "NS_Document Type" of
                        "NS_Document Type"::Quote:
                            PAGE.RUN(PAGE::"Sales Quote", SalesHeader);
                        "NS_Document Type"::Order:
                            PAGE.RUN(PAGE::"Sales Order", SalesHeader);
                        "NS_Document Type"::Invoice:
                            PAGE.RUN(PAGE::"Sales Invoice", SalesHeader);
                        "NS_Document Type"::"Return Order":
                            PAGE.RUN(PAGE::"Sales Return Order", SalesHeader);
                        "NS_Document Type"::"Credit Memo":
                            PAGE.RUN(PAGE::"Sales Credit Memo", SalesHeader);
                        "NS_Document Type"::"Blanket Order":
                            PAGE.RUN(PAGE::"Blanket Sales Order", SalesHeader);
                    end;
                end;
            "NS_Document Area"::Purchase:
                begin
                    if not PurchHeader.GET("NS_Document Type", "NS_No.") then
                        ERROR(Text002Lbl, "NS_No.");
                    case "NS_Document Type" of
                        "NS_Document Type"::Quote:
                            PAGE.RUN(PAGE::"Purchase Quote", PurchHeader);
                        "NS_Document Type"::Order:
                            PAGE.RUN(PAGE::"Purchase Order", PurchHeader);
                        "NS_Document Type"::Invoice:
                            PAGE.RUN(PAGE::"Purchase Invoice", PurchHeader);
                        "NS_Document Type"::"Return Order":
                            PAGE.RUN(PAGE::"Purchase Return Order", PurchHeader);
                        "NS_Document Type"::"Credit Memo":
                            PAGE.RUN(PAGE::"Purchase Credit Memo", PurchHeader);
                        "NS_Document Type"::"Blanket Order":
                            PAGE.RUN(PAGE::"Blanket Purchase Order", PurchHeader);
                    end;
                end;
        end;
    end;
}

