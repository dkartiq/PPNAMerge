page 14021307 "NS_SubcontractPurchParameter"
{
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Subcontract Purchase Parameter';
    PageType = CardPart;
    UsageCategory = Documents;
    ApplicationArea = Jobs;


    layout
    {
        area(content)
        {
            group("Purchase Document Type")
            {
                Caption = 'Purchase Document Type';
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Rows;
                field(DocumentType; DocumentType)
                {
                    ApplicationArea = All;
                    // >> Upgrade
                    //OptionCaption = 'Purchase Order,Purchase Invoice';
                    OptionCaption = 'Purchase Quote,Purchase Order,Purchase Invoice';
                    ShowCaption = false;
                    // << Upgrade
                    ToolTip = 'Specifies the document type.';

                    trigger OnValidate();
                    begin
                        if DocumentType = DocumentType::"Purch. Invoice" then
                            NS_PurchInvoiceDocumentTypeOnVali;
                        if DocumentType = DocumentType::"Purch. Order" then
                            NS_PurchOrderDocumentTypeOnValida;
                        // >> Upgrade
                        if DocumentType = DocumentType::"Purch. Quote" then
                            PurchQuoteDocumentTypeOnValida;
                        // << Upgrade
                    end;
                }
            }
            // >> Upgrade
            field(DeliverGoods; DeliverGoods)
            {
                Caption = 'Deliver Goods to Site';
                Editable = NOT DontDeliverGoods;
            }
            // << Upgrade
        }
    }

    actions
    {
    }

    var
        PurchaseDocument: Code[20];
        //DocumentType: Option "Purch. Order","Purch. Invoice";
        OldDocumentType: Option "Purchase Order","Purchase Invoice";
    // >> Upgrade
    protected var
        DocumentType: Option "Purch. Quote","Purch. Order","Purch. Invoice";
        DeliverGoods: Boolean;
        [InDataSet]
        DontDeliverGoods: Boolean;

    trigger OnOpenPage()
    begin
        // #152 Start
        DocumentType := DocumentType::"Purch. Order";
        // >> 001
        //DeliverGoods := TRUE;
        if DontDeliverGoods then
            DeliverGoods := false
        else
            DeliverGoods := true;
        // << 001
        // #152 End
    end;
    // << Upgrade

    procedure NS_GetResults(var DocType: Option; var DocNo: Code[20]);
    begin
        DocType := DocumentType;
        DocNo := PurchaseDocument;
    end;
    // >> Upgrade
    procedure NS_GetResults(var DocType: Option; var DocNo: Code[20]; var DeliverGoods_: Boolean);
    begin
        DocType := DocumentType;
        DocNo := PurchaseDocument;
        DeliverGoods_ := DeliverGoods; // #152
    end;
    // << Upgrade

    local procedure NS_PurchOrderDocumentTypeOnAfterV();
    begin
        if DocumentType <> OldDocumentType then begin
            PurchaseDocument := '';
            OldDocumentType := DocumentType;
        end;
    end;

    local procedure NS_PurchInvoiceDocumentTypeOnAfte();
    begin
        if DocumentType <> OldDocumentType then begin
            PurchaseDocument := '';
            OldDocumentType := DocumentType;
        end;
    end;

    local procedure NS_PurchOrderDocumentTypeOnValida();
    begin
        NS_PurchOrderDocumentTypeOnAfterV;
    end;

    local procedure NS_PurchInvoiceDocumentTypeOnVali();
    begin
        NS_PurchInvoiceDocumentTypeOnAfte;
    end;
    // >> Upgrade
    procedure SetParemeter(DontDeliverGoods_: Boolean)
    begin
        // >> 001 new Function
        DontDeliverGoods := DontDeliverGoods_;
        // << 001
    end;

    local procedure PurchQuoteDocumentTypeOnValida()
    begin
        NS_PurchOrderDocumentTypeOnAfterV();
        ;
    end;

    local procedure PurchQuoteDocumentTypeOnAfterV()
    begin
        if DocumentType <> OldDocumentType then begin
            PurchaseDocument := '';
            OldDocumentType := DocumentType;
        end;
    end;
    // << Upgrade
}

