page 14021218 NS_Draws
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    PageType = Card;
    Caption = 'Draws';
    SourceTable = NS_Draw;
    UsageCategory = Documents;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            repeater(Control1100773000)
            {
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';

                    trigger OnAssistEdit();
                    begin
                        if NS_AssistEdit(xRec) then
                            CurrPage.UPDATE();
                    end;
                }
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';
                }
                field("Sales Document Type"; Rec."NS_Sales Document Type")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Document Type';
                    ToolTip = 'Specifies the Sales Document Type';
                }
                field("Sales Document No."; Rec."NS_Sales Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Sales Document No.';
                }
                field("Sales Document Date"; Rec."NS_Sales Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Sales Document Date';
                }
                field("Progress Bill No."; Rec."NS_Progress Bill No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Progress Bill No.';
                }
                field("Progress Bill Requisition No."; Rec."NS_ProgressBillRequisitionNo.")
                {
                    ApplicationArea = All;
                    Caption = 'Progress Bill Requisition No.';
                    ToolTip = 'Specifies the Progress Bill Requisition No.';
                }
                field(Closed; NS_Closed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Closed';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(NS_Draw)
            {
                Caption = 'Draw';
                action("NS_Sales Document")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Document';
                    Image = Sales;
                    ToolTip = 'View associated sales document.';

                    trigger OnAction();
                    var
                        SalesHeader: Record "Sales Header";
                        SalesInvoiceHeader: Record "Sales Invoice Header";
                        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                        RecFound: Boolean;
                    begin
                        //Document Type, No.
                        RecFound := false;
                        if "NS_Sales Document No." > '' then begin
                            //First try the unposted area
                            case "NS_Sales Document Type" of
                                "Sales Document Type"::Invoice.AsInteger():
                                    begin
                                        if SalesHeader.GET(SalesHeader."Document Type"::Invoice, "NS_Sales Document No.") then begin
                                            RecFound := true;
                                            PAGE.RUN(PAGE::"Sales Invoice", SalesHeader);
                                        end;
                                        if not RecFound then begin
                                            if SalesHeader.GET(SalesHeader."Document Type"::Order, "NS_Sales Document No.") then begin
                                                RecFound := true;
                                                PAGE.RUN(PAGE::"Sales Order", SalesHeader);
                                            end;
                                        end;
                                    end;
                                "Sales Document Type"::"Credit Memo".AsInteger():
                                    begin
                                        if SalesHeader.GET(SalesHeader."Document Type"::"Credit Memo", "NS_Sales Document No.") then begin
                                            RecFound := true;
                                            PAGE.RUN(PAGE::"Sales Credit Memo", SalesHeader);
                                        end;
                                    end;
                            end;


                            if not RecFound then
                                //Look in posted area as pre-assigned No.
                                case "NS_Sales Document Type" of
                                    "Sales Document Type"::Invoice.AsInteger():
                                        begin
                                            SalesInvoiceHeader.RESET();
                                            SalesInvoiceHeader.SETCURRENTKEY("Pre-Assigned No.");
                                            SalesInvoiceHeader.SETRANGE("Pre-Assigned No.", "NS_Sales Document No.");
                                            if SalesInvoiceHeader.FINDFIRST() then begin
                                                RecFound := true;
                                                PAGE.RUN(PAGE::"Posted Sales Invoice", SalesInvoiceHeader);
                                            end;
                                        end;
                                    "Sales Document Type"::"Credit Memo".AsInteger():
                                        begin
                                            SalesCrMemoHeader.RESET();
                                            SalesCrMemoHeader.SETCURRENTKEY("Pre-Assigned No.");
                                            SalesCrMemoHeader.SETRANGE("Pre-Assigned No.", "NS_Sales Document No.");
                                            if SalesCrMemoHeader.FINDFIRST() then begin
                                                RecFound := true;
                                                PAGE.RUN(PAGE::"Posted Sales Credit Memo", SalesCrMemoHeader);
                                            end;
                                        end;
                                end;


                            if not RecFound then
                                //Look in posted area as main No.
                                case "NS_Sales Document Type" of
                                    "Sales Document Type"::Invoice.AsInteger():
                                        begin
                                            SalesInvoiceHeader.RESET();
                                            if SalesInvoiceHeader.GET("NS_Sales Document No.") then begin
                                                RecFound := true;
                                                PAGE.RUN(PAGE::"Posted Sales Invoice", SalesInvoiceHeader);
                                            end;
                                        end;
                                    "Sales Document Type"::"Credit Memo".AsInteger():
                                        begin
                                            SalesCrMemoHeader.RESET();
                                            if SalesCrMemoHeader.GET("NS_Sales Document No.") then begin
                                                RecFound := true;
                                                PAGE.RUN(PAGE::"Posted Sales Credit Memo", SalesCrMemoHeader);
                                            end;
                                        end;
                                end;


                            if not RecFound then
                                MESSAGE(Text001Lbl);

                        end;
                    end;
                }
                action("Progress Bill")
                {
                    ApplicationArea = All;
                    Caption = 'Progress Bill';

                    ToolTip = 'Progress Bill';
                    Image = CalculateInvoiceDiscount;
                    RunObject = Page "NS_Progress Billing Header";
                    RunPageLink = "NS_No." = FIELD("NS_Progress Bill No."),
                                  "NS_Requisition No." = FIELD("NS_ProgressBillRequisitionNo."),
                                  "NS_Version No." = FIELD("NS_ProgressBillVersionNo.");
                }
            }
        }
    }

    trigger OnOpenPage();
    begin
        SETRANGE(NS_Closed, false);
    end;

    var
        Text001Lbl: Label 'Can not find the sales document to display.';
        SalesDocumentType: Enum "Sales Document Type";
}

