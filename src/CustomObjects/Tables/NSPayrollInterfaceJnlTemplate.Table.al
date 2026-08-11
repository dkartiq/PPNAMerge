table 14021378 "NS_PayrollInterfaceJnlTemplate"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Payroll Interface Jnl Template';
    DrillDownPageID = "NS_PayrollInterfaceJnlTemplate";
    LookupPageID = "NS_PayrollInterfaceJnlTemplate";

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
        field(4; "NS_Create Entries Report ID"; Integer)
        {
            Caption = 'Create Entries Report ID';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Report));
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
                if "NS_Page ID" = 0 then begin
                    "NS_Page ID" := PAGE::"NS_Payroll InterfaceJnlPAYCHEX";
                    "NS_Create Entries Report ID" := REPORT::"NS_Create PayrollInterfEntries";
                    "NS_Test Report ID" := REPORT::"NS_Payroll Interf. TestPAYCHEX";
                    "NS_Export XMLport ID" := XMLPORT::"NS_PAYCHEX Export";
                end;
            end;
        }
        field(7; "NS_Export XMLport ID"; Integer)
        {
            Caption = 'Export XMLport ID';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(XMLport));
            DataClassification = CustomerContent;
        }
        field(8; "NS_Force Posting Report"; Boolean)
        {
            Caption = 'Force Posting Report';
            DataClassification = CustomerContent;
        }
        field(12; "NS_Create Entries Report Name"; Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Report),
                                                                           "Object ID" = FIELD("NS_Create Entries Report ID")));
            Caption = 'Create Entries Report Name';
            Editable = false;
            FieldClass = FlowField;
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
        field(15; "NS_Export XMLport Name"; Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(XMLport),
                                                                           "Object ID" = FIELD("NS_Export XMLport ID")));
            Caption = 'Posting Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "NS_No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
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
        PayrollInterfaceJnlLine.SETRANGE("NS_Journal Template Name", NS_Name);
        PayrollInterfaceJnlLine.DELETEALL(true);
        PayrollInterfaceJnlBatch.SETRANGE("NS_Journal Template Name", NS_Name);
        PayrollInterfaceJnlBatch.DELETEALL();
    end;

    trigger OnInsert();
    begin
        VALIDATE("NS_Page ID");
    end;

    var
        PayrollInterfaceJnlBatch: Record "NS_Payroll Interface Jnl Batch";
        PayrollInterfaceJnlLine: Record "NS_Payroll Interface Jnl Line";
}

