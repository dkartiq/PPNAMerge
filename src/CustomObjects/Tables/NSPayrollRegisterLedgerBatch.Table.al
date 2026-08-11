table 14021383 "NS_Payroll RegisterLedgerBatch"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Payroll Register Ledger Batch';

    fields
    {
        field(1; "NS_No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(2; "NS_Import Datetime"; DateTime)
        {
            Caption = 'Import Datetime';
            DataClassification = CustomerContent;
        }
        field(3; NS_Username; Text[50])
        {
            Caption = 'Username';
            TableRelation = User."User Name";
            DataClassification = CustomerContent;
        }
        field(4; "NS_Import Filename"; Text[250])
        {
            Caption = 'Import Filename';
            DataClassification = CustomerContent;
        }
        field(5; "NS_Import File BLOB"; BLOB)
        {
            Caption = 'Import File BLOB';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        "NS_Import Datetime" := CURRENTDATETIME;
        NS_Username := NS_Username;
    end;
}

