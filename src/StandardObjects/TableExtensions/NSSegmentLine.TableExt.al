tableextension 14021220 NS_SegmentLine extends "Segment Line"
{
    // version NAVW111.00.00.21836,PPNA11.00

    fields
    {
        modify("Interaction Template Code")
        {
            trigger OnBeforeValidate()
            var
                SegInteractLanguage: Record "Segment Interaction Language";
                InteractTemplLanguage: Record "Interaction Tmpl. Language";
                InteractTmpl: Record "Interaction Template";
                Campaign: Record Campaign;
            begin
                //ProjectPro - start
                IF GETFILTER("NS_Job Quote No.") = '' THEN BEGIN
                    //ProjectPro - end
                    TESTFIELD("Contact No.");
                    Cont.GET("Contact No.");
                    //ProjectPro - start
                END;
                //ProjectPro - end

                "Attachment No." := 0;
                "Language Code" := '';
                Subject := '';
                "Correspondence Type" := "Correspondence Type"::" ";
                "Interaction Group Code" := '';
                "Cost (LCY)" := 0;
                "Duration (Min.)" := 0;
                "Information Flow" := "Information Flow"::" ";
                "Initiated By" := "Initiated By"::" ";
                "Campaign Target" := FALSE;
                "Campaign Response" := FALSE;
                "Correspondence Type" := "Correspondence Type"::" ";
                IF (GETFILTER("Campaign No.") = '') AND (InteractTmpl."Campaign No." <> '') THEN
                    "Campaign No." := '';
                MODIFY;

                IF "Segment No." <> '' THEN BEGIN
                    SegInteractLanguage.RESET;
                    SegInteractLanguage.SETRANGE("Segment No.", "Segment No.");
                    SegInteractLanguage.SETRANGE("Segment Line No.", "Line No.");
                    SegInteractLanguage.DELETEALL(TRUE);
                    GET("Segment No.", "Line No.");
                    IF "Interaction Template Code" <> '' THEN BEGIN
                        SegHeader.GET("Segment No.");
                        IF "Interaction Template Code" <> SegHeader."Interaction Template Code" THEN BEGIN
                            SegHeader.CreateSegInteractions("Interaction Template Code", "Segment No.", "Line No.");
                            "Language Code" := FindLanguage("Interaction Template Code", Cont."Language Code");
                            IF SegInteractLanguage.GET("Segment No.", "Line No.", "Language Code") THEN
                                "Attachment No." := SegInteractLanguage."Attachment No.";
                        END ELSE BEGIN
                            "Language Code" := FindLanguage("Interaction Template Code", Cont."Language Code");
                            IF SegInteractLanguage.GET("Segment No.", 0, "Language Code") THEN
                                "Attachment No." := SegInteractLanguage."Attachment No.";
                        END;
                    END;
                END ELSE BEGIN
                    "Language Code" := FindLanguage("Interaction Template Code", Cont."Language Code");
                    IF InteractTemplLanguage.GET("Interaction Template Code", "Language Code") THEN
                        "Attachment No." := InteractTemplLanguage."Attachment No.";
                END;

                IF InteractTmpl.GET("Interaction Template Code") THEN BEGIN
                    "Interaction Group Code" := InteractTmpl."Interaction Group Code";
                    IF Description = '' THEN
                        Description := InteractTmpl.Description;
                    "Cost (LCY)" := InteractTmpl."Unit Cost (LCY)";
                    "Duration (Min.)" := InteractTmpl."Unit Duration (Min.)";
                    "Information Flow" := InteractTmpl."Information Flow";
                    "Initiated By" := InteractTmpl."Initiated By";
                    "Campaign Target" := InteractTmpl."Campaign Target";
                    "Campaign Response" := InteractTmpl."Campaign Response";

                    CASE TRUE OF
                        SegHeader."Ignore Contact Corres. Type" AND
                      (SegHeader."Correspondence Type (Default)" <> SegHeader."Correspondence Type (Default)"::" "):
                            "Correspondence Type" := SegHeader."Correspondence Type (Default)";
                        InteractTmpl."Ignore Contact Corres. Type" OR
                      ((InteractTmpl."Ignore Contact Corres. Type" = FALSE) AND
                       (Cont."Correspondence Type" = Cont."Correspondence Type"::" ") AND
                       (InteractTmpl."Correspondence Type (Default)" <> InteractTmpl."Correspondence Type (Default)"::" ")):
                            "Correspondence Type" := InteractTmpl."Correspondence Type (Default)";
                        ELSE
                            IF Cont."Correspondence Type" <> Cont."Correspondence Type"::" " THEN
                                "Correspondence Type" := Cont."Correspondence Type"
                            ELSE
                                "Correspondence Type" := xRec."Correspondence Type";
                    END;
                    IF SegHeader."Campaign No." <> '' THEN
                        "Campaign No." := SegHeader."Campaign No."
                    ELSE
                        IF (GETFILTER("Campaign No.") = '') AND (InteractTmpl."Campaign No." <> '') THEN
                            "Campaign No." := InteractTmpl."Campaign No.";
                END;
                IF Campaign.GET("Campaign No.") THEN
                    "Campaign Description" := Campaign.Description;

                MODIFY;

            end;
        }

        field(14021100; "NS_Job Quote No."; Code[20])
        {
            Description = 'ProjectPro';
            Caption = 'Job Quote No.';
            DataClassification = CustomerContent;
        }
    }

    var
        Cont: Record Contact;
        SegHeader: Record "Segment Header";
        Text005: label 'You must fill in the %1 field.';
        Text008: label 'You must select an interaction template with an attachment.';
        Text009: label 'You must select a contact to interact with.';

    procedure GetContact(var outCont: Record Contact)
    begin
        outCont := Cont;
    end;

    procedure NS_CreateInteractionFromJobQuote(VAR JobQuoteHeader: Record "NS_Job Quote Header")
    begin
        //ProjectPro - start
        INIT;
        VALIDATE("NS_Job Quote No.", JobQuoteHeader."NS_Quote No.");
        SETRANGE("NS_Job Quote No.", JobQuoteHeader."NS_Quote No.");
        StartWizard;
        //ProjectPro - end
    end;

    LOCAL procedure UniqueAttachmentExists(): Boolean
    var
        SegInteractLanguage: Record "Segment Interaction Language";
    begin
        IF "Line No." <> 0 THEN BEGIN
            SegInteractLanguage.SETRANGE("Segment No.", "Segment No.");
            SegInteractLanguage.SETRANGE("Segment Line No.", "Line No.");
            EXIT(NOT SegInteractLanguage.ISEMPTY);
        END;
        EXIT(FALSE);
    end;

    LOCAL procedure FindLanguage(InteractTmplCode: Code[10]; ContactLanguageCode: Code[10]) Language: Code[10]
    var
        SegInteractLanguage: Record "Segment Interaction Language";
        InteractTemplLanguage: Record "Interaction Tmpl. Language";
        InteractTmpl: Record "Interaction Template";
    begin
        IF SegHeader.GET("Segment No.") THEN BEGIN
            IF NOT UniqueAttachmentExists AND
               ("Interaction Template Code" = SegHeader."Interaction Template Code")
            THEN BEGIN
                IF SegInteractLanguage.GET("Segment No.", 0, ContactLanguageCode) THEN
                    Language := ContactLanguageCode
                ELSE
                    Language := SegHeader."Language Code (Default)";
            END ELSE
                IF SegInteractLanguage.GET("Segment No.", "Line No.", ContactLanguageCode) THEN
                    Language := ContactLanguageCode
                ELSE BEGIN
                    InteractTmpl.GET(InteractTmplCode);
                    IF SegInteractLanguage.GET("Segment No.", "Line No.", InteractTmpl."Language Code (Default)") THEN
                        Language := InteractTmpl."Language Code (Default)"
                    ELSE BEGIN
                        SegInteractLanguage.SETRANGE("Segment No.", "Segment No.");
                        SegInteractLanguage.SETRANGE("Segment Line No.", "Line No.");
                        IF SegInteractLanguage.FINDFIRST THEN
                            Language := SegInteractLanguage."Language Code";
                    END;
                END;
        END ELSE BEGIN  // Create Interaction:
            IF InteractTemplLanguage.GET(InteractTmplCode, ContactLanguageCode) THEN
                Language := ContactLanguageCode
            ELSE
                IF InteractTmpl.GET(InteractTmplCode) THEN
                    Language := InteractTmpl."Language Code (Default)";
        END;
    end;

    LOCAL procedure ErrorMessage(FieldName: Text[1024])
    begin
        ERROR(Text005, FieldName);
    end;

    procedure CheckStatusEvent(var TempAttachment: Record Attachment; var Cont: Record Contact)
    var
        InteractTmpl: Record "Interaction Template";
        Attachment: Record Attachment;
        SalutationFormula: Record "Salutation Formula";
    begin
        //ProjectPro - start
        //IF "Contact No." = '' THEN
        IF ("Contact No." = '') AND (GETFILTER("NS_Job Quote No.") = '') THEN
            //ProjectPro - end
            ERROR(Text009);
        IF "Interaction Template Code" = '' THEN
            ErrorMessage(FIELDCAPTION("Interaction Template Code"));
        IF "Salesperson Code" = '' THEN
            ErrorMessage(FIELDCAPTION("Salesperson Code"));
        IF Date = 0D THEN
            ErrorMessage(FIELDCAPTION(Date));
        IF Description = '' THEN
            ErrorMessage(FIELDCAPTION(Description));

        InteractTmpl.GET("Interaction Template Code");
        IF InteractTmpl."Wizard Action" = InteractTmpl."Wizard Action"::Open THEN
            IF "Attachment No." = 0 THEN
                ErrorMessage(Attachment.TABLECAPTION);

        //ProjectPro - start
        IF GETFILTER("NS_Job Quote No.") = '' THEN BEGIN
            //ProjectPro - end
            Cont.GET("Contact No.");
            IF SalutationFormula.GET(Cont."Salutation Code", "Language Code", 0) THEN;
            IF SalutationFormula.GET(Cont."Salutation Code", "Language Code", 1) THEN;
            //ProjectPro - start
        END;
        //ProjectPro - end

        IF TempAttachment.FINDFIRST THEN
            TempAttachment.CALCFIELDS("Attachment File");
        IF ("Correspondence Type" = "Correspondence Type"::Email) AND
           NOT TempAttachment."Attachment File".HASVALUE
        THEN
            ERROR(Text008);
    end;
}

