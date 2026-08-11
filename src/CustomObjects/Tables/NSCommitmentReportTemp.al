/// <summary>
/// Table NS_CommitmentReportTemp (ID 14021141).
/// </summary>
table 14021141 NS_CommitmentReportTemp
{
    //PE-23.NC.1.0 05Jun22023 Create New Table for calculation
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "NS_Job No."; Code[20])
        {

            DataClassification = CustomerContent;

        }
        field(2; "NS_Description"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; "NS_Document Type"; Option)
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Sub-Contract,Purchase Order';
            OptionMembers = ,"Sub-Contract","Purchase Order";
        }
        field(4; "NS_Document No."; Code[30])
        {
            DataClassification = CustomerContent;
        }
        field(5; "NS_Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(6; "NS_Subcontact No."; Code[30])
        {
            DataClassification = CustomerContent;
        }
        field(7; "NS_Original Commitment"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(8; "NS_Change Order Commitment"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(9; "NS_Invoiced Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(10; "NS_Retention Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(11; "NS_Payments Issued"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(12; "NS_Payment Received"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Job No.", "NS_Document Type", "NS_Document No.", "NS_Vendor No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}