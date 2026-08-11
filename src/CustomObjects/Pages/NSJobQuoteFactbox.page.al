page 14021397 "NS Job Quote Factbox"
{
    //PRJ-1179.RM.1.0 10Feb2022 New page created 
    PageType = CardPart;
    SourceTable = "Document Attachment";
    Caption = 'Job Quote Factbox';

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
                        Recs.SetRange("No.", Rec."No.");
                        IF Recs.FindFirst() then;
                        Page_DcoumentAttachment.SetRecord(Recs);
                        Page_DcoumentAttachment.SetTableView(Recs);
                        Page_DcoumentAttachment.RunModal();
                        Clear(Rec_DocumentAttachment);
                        Clear(Attachments);
                        Rec_DocumentAttachment.Reset();
                        Rec_DocumentAttachment.SetRange("No.", Rec."No.");
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
        Page_DcoumentAttachment: Page "NS Job Quote Attachments";

    trigger OnAfterGetCurrRecord()
    begin
        Clear(Attachments);
        Clear(Rec_DocumentAttachment);
        Rec_DocumentAttachment.Reset();
        Rec_DocumentAttachment.SetRange("No.", Rec."No.");
        IF Rec_DocumentAttachment.FindSet() then
            Attachments := Rec_DocumentAttachment.Count;
    end;
}
