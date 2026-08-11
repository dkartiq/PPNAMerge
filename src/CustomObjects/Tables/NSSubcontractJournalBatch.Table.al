table 14021305 "NS_Subcontract Journal Batch"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Subcontract Journal Batch';
    DataCaptionFields = NS_Name, NS_Description;

    fields
    {
        field(1; "NS_Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "NS_SubcontractJournalTemplate";
            DataClassification = CustomerContent;
        }
        field(2; NS_Name; Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(3; NS_Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(4; "NS_Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Reason Code" <> xRec."NS_Reason Code" then begin
                    JobJnlLine.SETRANGE("Journal Template Name", "NS_Journal Template Name");
                    JobJnlLine.SETRANGE("Journal Batch Name", NS_Name);
                    JobJnlLine.MODIFYALL("Reason Code", "NS_Reason Code");
                    MODIFY();
                end;
            end;
        }
        field(5; "NS_No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_No. Series" <> '' then begin
                    JobJnlTemplate.GET("NS_Journal Template Name");
                    if JobJnlTemplate.Recurring then
                        ERROR(
                          Text000_Txt,
                          FIELDCAPTION("NS_Posting No. Series"));
                    if "NS_No. Series" = "NS_Posting No. Series" then
                        VALIDATE("NS_Posting No. Series", '');
                end;
            end;
        }
        field(6; "NS_Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if ("NS_Posting No. Series" = "NS_No. Series") and ("NS_Posting No. Series" <> '') then
                    FIELDERROR("NS_Posting No. Series", STRSUBSTNO(Text001_Txt, "NS_Posting No. Series"));
                JobJnlLine.SETRANGE("Journal Template Name", "NS_Journal Template Name");
                JobJnlLine.SETRANGE("Journal Batch Name", NS_Name);
                JobJnlLine.MODIFYALL("Posting No. Series", "NS_Posting No. Series");
                MODIFY();
            end;
        }
    }

    keys
    {
        key(Key1; "NS_Journal Template Name", NS_Name)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        JobJnlLine.SETRANGE("Journal Template Name", "NS_Journal Template Name");
        JobJnlLine.SETRANGE("Journal Batch Name", NS_Name);
        JobJnlLine.DELETEALL(true);
    end;

    trigger OnInsert();
    begin
        LOCKTABLE();
        JobJnlTemplate.GET("NS_Journal Template Name");
    end;

    trigger OnRename();
    begin
        JobJnlLine.SETRANGE("Journal Template Name", xRec."NS_Journal Template Name");
        JobJnlLine.SETRANGE("Journal Batch Name", xRec.NS_Name);
        if JobJnlLine.FINDSET() then
            repeat
                JobJnlLine.RENAME("NS_Journal Template Name", NS_Name, JobJnlLine."Line No.");
            until JobJnlLine.NEXT() = 0;
    end;

    var

        JobJnlTemplate: Record "Job Journal Template";
        JobJnlLine: Record "Job Journal Line";
        Text000_Txt: Label 'Only the %1 field can be filled in on recurring journals.', Comment = '%1 = Posting No. Series';
        Text001_Txt: Label 'must not be %1', Comment = '%1 = Posting No. Series';

    procedure SetupNewBatch();
    begin
        JobJnlTemplate.GET("NS_Journal Template Name");
        "NS_No. Series" := JobJnlTemplate."No. Series";
        "NS_Posting No. Series" := JobJnlTemplate."Posting No. Series";
        "NS_Reason Code" := JobJnlTemplate."Reason Code";
    end;
}

