page 14021491 "NS_Committed Line List Page"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    //PRJ-1293.RM.1.0 | 08April2022 Created New List Page
    // +------------------------------------------------------------

    Caption = 'Committed Line List';
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Purchase Line";
    SourceTableView = WHERE("NS_Committed Quantity" = FILTER(<> 0));

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
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description 2';
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
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quantity';
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quantity Received';
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Outstanding Quantity';
                }
                field("Quantity Invoiced"; Rec."Quantity Invoiced")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quantity Invoiced';
                }
                field("Committed Quantity"; Rec."NS_Committed Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Committed Quantity';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit of Measure Code';
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Direct Unit Cost';
                }
                field("Committed Amount"; Rec."NS_Committed Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Committed Amount';
                }

                //PRJ-1618.1.0 START
                field("NS_Committed Amount (LCY)"; Rec."NS_Committed Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Committed Amount (LCY)';
                }
                //PRJ-1618.1.0 END
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Amount';
                    Visible = false;
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
                ToolTip = 'Purchase document';

                trigger OnAction();
                begin
                    PurchaseHeader.RESET();
                    PurchaseHeader.GET(Rec."Document Type", Rec."Document No."); //PRJ-1131.NK.1.0
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
        //RESET;
        Rec.SetFilter("Document Type", '%1|%2', Rec."Document Type"::Order, Rec."Document Type"::"Return Order");//PRJ-321.MS.1.0  //PRJ-1131.NK.1.0
        if JobNo > '' then
            Rec.SETRANGE("Job No.", JobNo); //PRJ-1131.NK.1.0
        if SubcontractNo > '' then
            Rec.SETFILTER("NS_Subcontract No.", SubcontractNo); //PRJ-1131.NK.1.0
        if Rec."Document Type" = Rec."Document Type"::"Return Order" then //PRJ-321.MS.1.0 //PRJ-1131.NK.1.0
            Rec."NS_Committed Amount" := -Rec."NS_Committed Amount";  //PRJ-321.MS.1.0 //PRJ-1131.NK.1.0
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec."Document Type" = Rec."Document Type"::"Return Order" then //PRJ-321.MS.1.0 //PRJ-1131.NK.1.0
            Rec."NS_Committed Amount" := -Rec."NS_Committed Amount";  //PRJ-321.MS.1.0 //PRJ-1131.NK.1.0
    end;

    var
        PurchaseHeader: Record "Purchase Header";
        JobNo: Code[20];
        SubcontractNo: Code[20];
        JobsNo: Code[20];
        PL: Record "Purchase Line";

    procedure NS_SetJob(JobNoIn: Code[20]);
    begin
        JobNo := JobNoIn;
        SubcontractNo := '';
    end;

    procedure NS_SetSubcontract(SubcontNoIn: Code[20]);
    begin
        SubcontractNo := SubcontNoIn;
        JobNo := '';
    end;
}

