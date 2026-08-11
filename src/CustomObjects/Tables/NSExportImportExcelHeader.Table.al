table 14021424 "NS_Export/Import Excel Header"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    //SMPL - Replaced "Object" table to "Allobj"

    Caption = 'Export / Import Excel Header';
    LookupPageID = "NS_Export / Import Header";

    fields
    {
        field(1; "NS_Code"; Text[30])
        {
            Caption = 'Code';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(2; "NS_Table No."; Integer)
        {
            Caption = 'Table no.';
            DataClassification = CustomerContent;
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Table));

            trigger OnValidate();
            var
                ObjectTbl: Record AllObj;
            begin
                if ("NS_Table No." <> xRec."NS_Table No.") and
                   (xRec."NS_Table No." <> 0) then
                    if CONFIRM(Text000Lbl) then begin
                        EIELines.RESET();
                        EIELines.LOCKTABLE();
                        EIELines.SETRANGE(NS_Code, NS_Code);
                        EIELines.DELETEALL();
                    end else
                        "NS_Table No." := xRec."NS_Table No.";
                ObjectTbl.SETRANGE("Object Type", ObjectTbl."Object Type"::Table);
                ObjectTbl.SETRANGE("Object ID", "NS_Table No.");
                if ObjectTbl.FINDFIRST() then
                    "NS_Table Name" := ObjectTbl."Object Name";
            end;
        }
        field(3; "NS_Table Name"; Text[30])
        {
            Caption = 'Table name';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(4; "NS_File Name"; Text[250])
        {
            Caption = 'File name';
            DataClassification = CustomerContent;
        }
        field(6; "NS_First DataRow"; Integer)
        {
            Caption = 'First DataRow';
            DataClassification = CustomerContent;
        }
        field(7; NS_ValidateInsertModify; Boolean)
        {
            Caption = 'ValidateInsertModify';
            DataClassification = CustomerContent;
        }
        field(8; NS_ImportOption; Option)
        {
            Caption = 'ImportOption';
            DataClassification = CustomerContent;
            OptionCaption = 'Replace entries,Add entries';
            OptionMembers = "Replace entries","Add entries";
        }
        field(9; NS_AllowDuplicates; Boolean)
        {
            Caption = 'AllowDuplicates';
            DataClassification = CustomerContent;
        }
        field(10; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Job No.", "NS_Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        EIELines.RESET();
        EIELines.LOCKTABLE();
        EIELines.SETRANGE(NS_Code, NS_Code);
        EIELines.SETRANGE("NS_Job No.", "NS_Job No.");
        EIELines.DELETEALL();
    end;

    var
        EIELines: Record "NS_Export / Import Excel Line";
        Text000Lbl: Label 'Changing the table no. will delete all mappings!\Do you want to continue?';
}

