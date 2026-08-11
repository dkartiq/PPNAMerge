page 14021205 "NS_Purchase Line List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Purchase Line List';
    Editable = false;
    PageType = List;
    SourceTable = "Purchase Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Document Type';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Document No.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Type';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Expected Receipt Date';
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Buy-from Vendor No.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Currency Code';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quantity';
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Outstanding Quantity';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit of Measure Code';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Amount';
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Direct Unit Cost';
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line Discount %';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Purchase Doc")
            {
                ApplicationArea = All;
                Caption = 'Purchase Doc';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                tooltip = 'Purchase Doc';

                trigger OnAction();
                begin
                    PurchaseHeader.RESET();
                    PurchaseHeader.GET("Document Type", "Document No.");
                    if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then
                        PAGE.RUN(PAGE::"Purchase Order", PurchaseHeader)
                    else
                        PAGE.RUN(PAGE::"Purchase Invoice", PurchaseHeader);
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        if JobNo > '' then
            SETRANGE("Job No.", JobNo);
        if vnoo > '' then
            SETRANGE("Buy-from Vendor No.", vnoo);
    end;

    var
        PurchaseHeader: Record "Purchase Header";
        JobNo: Code[20];
        vnoo: Code[10];

    procedure NS_SetJob(JobNoIn: Code[20]);
    begin
        JobNo := JobNoIn;
    end;

    procedure NS_SetVendor(vno: Code[10]);
    begin
        vnoo := vno;
    end;
}

