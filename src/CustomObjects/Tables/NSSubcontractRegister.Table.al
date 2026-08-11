table 14021306 "NS_Subcontract Register"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Subcontract Register';

    fields
    {
        field(1; "NS_No."; Integer)
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(2; "NS_From Entry No."; Integer)
        {
            Caption = 'From Entry No.';
            TableRelation = "NS_Subcontract Ledger Entry";
            DataClassification = CustomerContent;
        }
        field(3; "NS_To Entry No."; Integer)
        {
            Caption = 'To Entry No.';
            TableRelation = "NS_Subcontract Ledger Entry";
            DataClassification = CustomerContent;
        }
        field(4; "NS_Creation Date"; Date)
        {
            Caption = 'Creation Date';
            DataClassification = CustomerContent;
        }
        field(5; "NS_Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
            DataClassification = CustomerContent;
        }
        field(6; "NS_User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
            DataClassification = CustomerContent;

            trigger OnLookup();
            var
                LoginMgt: Codeunit "User Management";
            begin
                LoginMgt.DisplayUserInformation("NS_User ID");
            end;
        }
        field(7; "NS_Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_No.")
        {
        }
        key(Key2; "NS_Creation Date")
        {
        }
        key(Key3; "NS_Source Code", "NS_Journal Batch Name", "NS_Creation Date")
        {
        }
    }

    fieldgroups
    {
    }
}

