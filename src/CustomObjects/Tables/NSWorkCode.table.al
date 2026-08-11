table 14021499 "NS_Work Type Info"
{
    //PRJ-464.AM.1.0 1DEC2020 | Added New Table.
    //PE-311.PP.1.0 11JUN2024 | Added "NS_Include Line" & "NS_Work Instructions" Field to print the instructions on work order report

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
            Caption = 'Date Assigned';  //PE-311.PP.1.0 11JUN2024 // Old caption was 'Date'
        }
        field(4; "NS_Work Type"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'WO Ref. No.';   //PE-311.PP.1.0 11JUN2024 // Old caption was 'Work Type'
        }
        field(5; "NS_Work Description"; Text[500])
        {
            DataClassification = CustomerContent;
            Caption = 'Work Description';
        }
        //PE-311.PP.1.0 11JUN2024 start
        field(6; "NS_Include Line"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Include Line';
        }
        field(7; "NS_Work Instructions"; Text[200])
        {
            DataClassification = CustomerContent;
            Caption = 'Work Instructions';
        }
        field(8; "NS_Work Requested Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Work Requested Date';
        }
        field(9; "NS_Work Task No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Work Task No.';
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("NS_Job No."), "Job Task Type" = Const(Posting));
            trigger OnValidate()
            var
                Jobtask: Record "Job Task";
            begin
                "NS_Work Task Description" := '';
                if Jobtask.get("NS_Job No.", "NS_Work Task No.") then
                    "NS_Work Task Description" := Jobtask.Description;
            end;
        }
        field(10; "NS_Work Task Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Work Task Description';
            Editable = false;
        }
        //PE-311.PP.1.0 11JUN2024 end
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
        "NS_Include Line" := true; //PE-311.PP.1.0 11JUN2024
        "NS_Work Type" := "NS_Job No."; //PE-311.PP.1.0 11JUN2024
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