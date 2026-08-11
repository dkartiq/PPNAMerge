table 14021420 "NS_Job Credit Review Ent."
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Credit Review Entry';
    DrillDownPageID = "NS_Job Quote Credit Review Ent";
    LookupPageID = "NS_Job Quote Credit Review Ent";

    fields
    {
        field(1; "NS_Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(11; "NS_Table ID"; Integer)
        {
            Caption = 'Table ID';
            DataClassification = CustomerContent;
        }
        field(21; "NS_No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(30; "NS_Document Area"; Option)
        {
            Caption = 'Document Area';
            OptionCaption = 'Sales,Purchase';
            OptionMembers = Sales,Purchase;
            DataClassification = CustomerContent;
        }
        field(31; "NS_Document Type"; Option)
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(36; "NS_Document Amount"; Decimal)
        {
            Caption = 'Document Amount';
            DataClassification = CustomerContent;
        }
        field(71; "NS_Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
        }
        field(72; "NS_Customer Name"; Text[50])
        {
            Caption = 'Customer Name';
            DataClassification = CustomerContent;
        }
        field(201; NS_Status; Option)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            OptionCaption = 'Message,,,Error,,,Review,,,Approved';
            OptionMembers = Message,,,Error,,,Review,,,Approved;
        }
        field(211; "NS_Last Entry"; Boolean)
        {
            Caption = 'Last Entry';
            DataClassification = CustomerContent;
        }
        field(501; "NS_Entry Text"; Text[250])
        {
            Caption = 'Entry Text';
            DataClassification = CustomerContent;
        }
        field(1001; NS_Collector; Code[10])
        {
            CalcFormula = Lookup(Customer.NS_Collector WHERE("No." = FIELD("NS_Customer No.")));
            Caption = 'Credit Associate';
            Editable = false;
            FieldClass = FlowField;
        }
        field(2001; "NS_Release Attempted"; Boolean)
        {
            Caption = 'Release Attempted';
            DataClassification = CustomerContent;
        }
        field(5001; "NS_Created by"; Code[50])
        {
            Caption = 'Created by';
            TableRelation = User;
            DataClassification = CustomerContent;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(5002; "NS_Created at Date"; Date)
        {
            Caption = 'Created at Date';
            DataClassification = CustomerContent;
        }
        field(5003; "NS_Created at Time"; Time)
        {
            Caption = 'Created at Time';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Entry No.")
        {
        }
        key(Key2; "NS_Table ID", "NS_No.", "NS_Document Area", "NS_Document Type")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(NS_DropDown; "NS_Entry No.", "NS_Table ID", "NS_No.", "NS_Customer No.", "NS_Entry Text", "NS_Customer Name", "NS_Created by", "NS_Created at Date")
        {
        }
    }

    trigger OnDelete();
    begin
        CreditReviewMgt.NS_Authorize(STRSUBSTNO(Text000Lbl, TABLECAPTION));
    end;

    trigger OnInsert();
    begin
        if NS_Status = NS_Status::Approved then
            CreditReviewMgt.NS_Authorize(STRSUBSTNO(Text000Lbl, TABLECAPTION));

        "NS_Entry No." := 0;
        "NS_Created by" := USERID[50];
        "NS_Created at Date" := TODAY;
        "NS_Created at Time" := TIME;
    end;

    trigger OnModify();
    begin
        if NS_Status = NS_Status::Approved then
            CreditReviewMgt.NS_Authorize(STRSUBSTNO(Text000Lbl, TABLECAPTION));
    end;

    trigger OnRename();
    begin
        CreditReviewMgt.NS_Authorize(STRSUBSTNO(Text000Lbl, TABLECAPTION));
    end;

    var
        CreditReviewMgt: Codeunit "NS_Job CreditReviewMgt.";
        Text000Lbl: Label 'Credit Review authorization is required to insert, modify, or delete records in %1.', Comment = '%1=TABLECAPTION';
}

