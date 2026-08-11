page 14021399 "NS Job Quote Attachments"
{
    //PRJ-1179.RM.1.0 10Feb2022 New page created 
    Caption = 'Job Quote Attached Documents';
    DelayedInsert = true;
    Editable = true;
    PageType = Worksheet;
    SourceTable = "Document Attachment";
    SourceTableView = SORTING(ID, "Table ID", "No.");
    RefreshOnActivate = true;
    Permissions = TableData "14021402" = IMD;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    trigger OnDrillDown()
                    var
                        myInt: Integer;
                        FileManagement: Codeunit "File Management";
                        TempBlob: Codeunit "Temp Blob";
                        FilterTxt: Label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*';
                        ImportTxt: Label 'Attach a document.';
                        FileDialogTxt: Label 'Attachments (%1)|%1';
                        FileName: Text;
                        FromRecRef: RecordRef;

                    begin
                        IF Recs.Get(Rec."No.") then;
                        FromRecRef.GetTable(Recs);
                        IF Rec."Document Reference ID".HASVALUE THEN
                            Export2(TRUE)
                        ELSE BEGIN
                            FileName := FileManagement.BLOBImportWithFilter(TempBlob, ImportTxt, FileName, STRSUBSTNO(FileDialogTxt, FilterTxt), FilterTxt);
                            SaveAttachment2(FromRecRef, FileName, TempBlob, TRUE, Recs."NS_Quote No.");
                            CurrPage.UPDATE(FALSE);
                        END;

                    end;
                }
                field("File Type"; Rec."File Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("File Extension"; Rec."File Extension")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(User; Rec.User)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Attached Date"; Rec."Attached Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }

    }
    var
        Recs: Record "NS_Job Quote Header";


    procedure Export2(ShowFileDialog: Boolean): Text
    var
        FullFileName: Text;
        DocumentStream: OutStream;
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
    begin

        IF Rec.ID = 0 THEN
            EXIT;
        // Ensure document has value in DB
        IF NOT Rec."Document Reference ID".HASVALUE THEN
            EXIT;

        FullFileName := Rec."File Name" + '.' + Rec."File Extension";
        TempBlob.CREATEOUTSTREAM(DocumentStream);
        Rec."Document Reference ID".EXPORTSTREAM(DocumentStream);
        EXIT(FileManagement.BLOBExport(TempBlob, FullFileName, ShowFileDialog));
    end;

    procedure SaveAttachment2(RecRef: RecordRef; FileName: Text; TempBlob: Codeunit "Temp Blob"; OpportunityAttachment: Boolean; OpportunityNo: Code[30])
    var
        IncomingFileName2: Text;
        DocStream2: Instream;
        EmptyFileNameErr: Label 'No content';
        FileManagement: Codeunit "File Management";
        NoDocumentAttachedErr: Label 'No document attached';
        FieldRef: FieldRef;
        LineNo: Integer;
        Rec_Document: Record "Document Attachment";
        Rec_Attachment: Record "Document Attachment";
    begin
        IF FileName = '' THEN
            ERROR(EmptyFileNameErr);
        // Validate file/media is not empty
        IF NOT TempBlob.HASVALUE THEN
            ERROR(EmptyFileNameErr);

        IncomingFileName2 := FileName;
        Clear(Rec_Attachment);
        Rec_Attachment.Reset();
        Rec_Attachment.INIT();
        Rec_Attachment.VALIDATE("File Extension", FileManagement.GetExtension(IncomingFileName2));
        Rec_Attachment.VALIDATE("File Name", COPYSTR(FileManagement.GetFileNameWithoutExtension(IncomingFileName2), 1, MAXSTRLEN(Rec."File Name"))); //PRJ-1131.NK.1.0
        //Rec_Attachment.Validate("Document Type", "Document Type"::Order);
        Rec_Attachment.VALIDATE("Table ID", RecRef.NUMBER);
        Rec_Attachment.Validate("No.", Recs."NS_Quote No.");
        TempBlob.CREATEINSTREAM(DocStream2);
        Rec_Attachment."Document Reference ID".IMPORTSTREAM(DocStream2, '', IncomingFileName2);
        IF NOT Rec_Attachment."Document Reference ID".HASVALUE THEN
            ERROR(NoDocumentAttachedErr);
        CASE RecRef.NUMBER OF
            DATABASE::NS_Subcontract:
                BEGIN
                    FieldRef := RecRef.FIELD(1);
                    Clear(Rec_Document);
                    Rec_Document.SetRange("Table ID", RecRef.Number);
                    Rec_Document.SetRange("No.", Recs."NS_Quote No.");
                    IF Rec_Document.FindLast() then begin
                        Rec_Attachment.Validate("Line No.", Rec_Document."Line No." + 1000);
                    end
                    else begin
                        Rec_Attachment.Validate("Line No.", 1000);
                    end;

                END;
        END;
        Rec_Attachment.INSERT(TRUE);
    end;

}