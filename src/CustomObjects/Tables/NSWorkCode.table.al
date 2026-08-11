table 14021499 "NS_Work Type Info"
{
    //PRJ-464.AM.1.0 1DEC2020 | Added New Table.
    DataClassification = CustomerContent;
    Caption = 'Work Completed';

    fields
    {
        field(1; "NS_Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "NS_Job No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Job No.';

        }
        field(3; "NS_Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date';
        }
        field(4; "NS_Work Type"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Work Type';
        }
        field(5; "NS_Work Description"; Text[500])
        {
            DataClassification = CustomerContent;
            Caption = 'Work Description';
        }
    }

    keys
    {
        key(Key1; "NS_Job No.", "NS_Entry No.")
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