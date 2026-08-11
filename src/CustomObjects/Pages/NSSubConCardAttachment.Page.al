page 14021389 "NS_SubContract Card Factbox"
{
    //PRJ-532.AS.1.0 New Page Created

    Caption = 'Documents Attached';
    PageType = CardPart;
    SourceTable = NS_Subcontract;

    layout
    {
        area(Content)
        {
            group(Control2)
            {
                ShowCaption = false;
                field(Attachments; Attachments)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Documents';
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the number of attachments.';
                    trigger OnDrillDown()
                    var
                        Recs: Record "Document Attachment";
                    begin
                        Clear(Page_DcoumentAttachment);
                        Clear(Recs);
                        Recs.Reset();
                        Recs.SetRange("No.", Rec."NS_No.");
                        IF Recs.FindFirst() then;
                        Page_DcoumentAttachment.SetRecord(Recs);
                        Page_DcoumentAttachment.SetTableView(Recs);
                        Page_DcoumentAttachment.RunModal();
                        Clear(Rec_DocumentAttachment);
                        Clear(Attachments);
                        Rec_DocumentAttachment.Reset();
                        Rec_DocumentAttachment.SetRange("No.", Rec."NS_No.");
                        IF Rec_DocumentAttachment.FindSet() then
                            Attachments := Rec_DocumentAttachment.Count;
                    end;
                }
            }
        }
    }


    var
        Attachments: Integer;
        Rec_DocumentAttachment: Record "Document Attachment";
        Page_DcoumentAttachment: Page "NS_SubconDocsAttach";

    trigger OnAfterGetCurrRecord()
    begin
        Clear(Attachments);
        Clear(Rec_DocumentAttachment);
        Rec_DocumentAttachment.Reset();
        Rec_DocumentAttachment.SetRange("No.", Rec."NS_No.");
        IF Rec_DocumentAttachment.FindSet() then
            Attachments := Rec_DocumentAttachment.Count;
    end;
}