table 14021303 "NS_SubcontractJournalTemplate"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Subcontract Journal Template';

    fields
    {
        field(1; NS_Name; Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(2; NS_Description; Text[80])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(5; "NS_Test Report ID"; Integer)
        {
            Caption = 'Test Report ID';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Report));
            DataClassification = CustomerContent;
        }
        field(6; "NS_Page ID"; Integer)
        {
            Caption = 'Page ID';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Page ID" = 0 then
                    VALIDATE(NS_Recurring);
            end;
        }
        field(7; "NS_Posting Report ID"; Integer)
        {
            Caption = 'Posting Report ID';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Report));
            DataClassification = CustomerContent;
        }
        field(8; "NS_Force Posting Report"; Boolean)
        {
            Caption = 'Force Posting Report';
            DataClassification = CustomerContent;
        }
        field(10; "NS_Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                SubcontractJnlLine.SETRANGE("NS_Journal Template Name", NS_Name);
                SubcontractJnlLine.MODIFYALL("NS_Source Code", "NS_Source Code");
                MODIFY();
            end;
        }
        field(11; "NS_Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
            DataClassification = CustomerContent;
        }
        field(12; NS_Recurring; Boolean)
        {
            Caption = 'Recurring';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if NS_Recurring then
                    "NS_Page ID" := PAGE::"Recurring Job Jnl."
                else
                    "NS_Page ID" := PAGE::"Job Journal";
                "NS_Test Report ID" := REPORT::"Job Journal - Test";
                "NS_Posting Report ID" := REPORT::"Job Register";
                SourceCodeSetup.GET();
                "NS_Source Code" := SourceCodeSetup."Post Recognition";
                if NS_Recurring then
                    TESTFIELD("NS_No. Series", '');
            end;
        }
        field(13; "NS_Test Report Name"; Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Report),
                                                                           "Object ID" = FIELD("NS_Test Report ID")));
            Caption = 'Test Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "NS_Page Name"; Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Page),
                                                                           "Object ID" = FIELD("NS_Page ID")));
            Caption = 'Page Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "NS_Posting Report Name"; Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Report),
                                                                           "Object ID" = FIELD("NS_Posting Report ID")));
            Caption = 'Posting Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "NS_No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_No. Series" <> '' then begin
                    if NS_Recurring then
                        ERROR(
                          Text000_Txt,
                          FIELDCAPTION("NS_Posting No. Series"));
                    if "NS_No. Series" = "NS_Posting No. Series" then
                        "NS_Posting No. Series" := '';
                end;
            end;
        }
        field(17; "NS_Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if ("NS_Posting No. Series" = "NS_No. Series") and ("NS_Posting No. Series" <> '') then
                    FIELDERROR("NS_Posting No. Series", STRSUBSTNO(Text001_Txt, "NS_Posting No. Series"));
            end;
        }
    }

    keys
    {
        key(Key1; NS_Name)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        SubcontractJnlLine.SETRANGE("NS_Journal Template Name", NS_Name);
        SubcontractJnlLine.DELETEALL(true);
        SubcontractJnlBatch.SETRANGE("NS_Journal Template Name", NS_Name);
        SubcontractJnlBatch.DELETEALL();
    end;

    trigger OnInsert();
    begin
        VALIDATE("NS_Page ID");
    end;

    var

        SubcontractJnlBatch: Record "NS_Subcontract Journal Batch";
        SubcontractJnlLine: Record "NS_Subcontract Journal Line";
        SourceCodeSetup: Record "Source Code Setup";
        Text000_Txt: Label 'Only the %1 field can be filled in on recurring journals.', Comment = '%1 = Posting No. Series';
        Text001_Txt: Label 'must not be %1', Comment = '%1 = Posting No. Series';


    //SMPL Replaced "Object" with "AllObj
}

