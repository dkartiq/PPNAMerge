page 14021307 "NS_SubcontractPurchParameter"
{
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
                    OptionCaption = 'Purchase Order,Purchase Invoice';
                    ToolTip = 'Specifies the document type.';

                    trigger OnValidate();
                    begin
                        if DocumentType = DocumentType::"Purch. Invoice" then
                            NS_PurchInvoiceDocumentTypeOnVali;
                        if DocumentType = DocumentType::"Purch. Order" then
                            NS_PurchOrderDocumentTypeOnValida;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    var
        PurchaseDocument: Code[20];
        DocumentType: Option "Purch. Order","Purch. Invoice";
        OldDocumentType: Option "Purchase Order","Purchase Invoice";

    procedure NS_GetResults(var DocType: Option; var DocNo: Code[20]);
    begin
        DocType := DocumentType;
        DocNo := PurchaseDocument;
    end;

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
}

