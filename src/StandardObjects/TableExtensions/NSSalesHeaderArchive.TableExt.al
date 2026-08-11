tableextension 14021221 NS_SalesHeaderArchive extends "Sales Header Archive"
{
    // version NAVW111.00.00.20783,NAVNA11.00.00.20783,PPNA11.00

    fields
    {
        field(14021100; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            Description = 'ProjectPro';
            TableRelation = Job;
            DataClassification = CustomerContent;
        }
        field(14021136; "NS_Retention Base Amount"; Decimal)
        {
            CalcFormula = Sum ("Sales Line Archive"."Amount Including VAT" WHERE("Document Type" = FIELD("Document Type"),
                                                                                 "Document No." = FIELD("No."),
                                                                                 "NS_Retention Applies" = CONST(true)));
            Caption = 'Retention Base Amount';
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        field(14021137; "NS_Retention Base Before Tax"; Decimal)
        {
            CalcFormula = Sum ("Sales Line Archive".Amount WHERE("Document Type" = FIELD("Document Type"),
                                                                 "Document No." = FIELD("No."),
                                                                 "NS_Retention Applies" = CONST(true)));
            Caption = 'Retention Base Before Tax';
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        field(14021138; "NS_Retention Percent"; Decimal)
        {
            Caption = 'Retention Percent';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021139; "NS_Retention Amount (LCY)"; Decimal)
        {
            Caption = 'Retention Amount ($)';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021140; "NS_Retention Amount"; Decimal)
        {
            Caption = 'Retention Amount';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021145; "NS_Retention Date"; Date)
        {
            Caption = 'Retention Date';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021146; "NS_Retention Document"; Boolean)
        {
            Caption = 'Retention Document';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021325; "NS_Progress Billing Document"; Boolean)
        {
            Caption = 'Progress Billing Document';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021330; "NS_Retention Ledger Code"; Code[20])
        {
            Caption = 'Retention Ledger Code';
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            DataClassification = CustomerContent;
        }
    }
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021100 Job No.
//   +     14021136 Retention Base Amount
//   +     14021137 Retention Base Before Tax
//   +     14021138 Retention Percent
//   +     14021139 Retention Amount (LCY)
//   +     14021140 Retention Amount
//   +     14021145 Retention Date
//   +     14021146 Retention Document
//   +     14021325 Progress Billing Document
//   +     14021330 Retention Ledger Code
//   +
//   +-----------------------------------------------------------------------------------------------