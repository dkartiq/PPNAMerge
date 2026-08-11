/// <summary>
/// Table NS_Job Crews (ID 14021225).
/// </summary>
//PRJ-991.GK.2.0 22Oct2021 |Add new Table.
table 14021225 "NS_Job Crew Resource"
{
    DataClassification = CustomerContent;
    Caption = 'Job Crew Resources';

    fields
    {
        field(1; "NS_Job No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Job No.';
            TableRelation = Job;

        }
        field(2; "NS_Crew Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Crew Code';
            TableRelation = NS_Crew where(NS_Active = const(true));
            trigger OnValidate()
            var
                NS_CrewLines: Record "NS_Crew Line";
            begin
                NS_CrewLines.Reset();
                NS_CrewLines.SetRange(NS_Code, "NS_Crew Code");
                NS_CrewLines.SetRange(NS_Active, true);
                if NS_CrewLines.FindSet() then
                    repeat

                    until NS_CrewLines.Next() = 0;

            end;

        }
        field(3; "NS_Resource No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Resource;
            Caption = 'Resource No.';
            trigger OnValidate()

            begin

            end;
        }

        //PRJ-991.GK.2.0 22Oct2021 start
        field(4; "NS_Job Status"; Enum "Job Status")
        {
            Caption = 'Job Status';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Job.Status where("No." = field("NS_Job No.")));

        }
        //PRJ-991.GK.2.0 22Oct2021 end




    }

    keys
    {
        key(Key1; "NS_Job No.", "NS_Crew Code", "NS_Resource No.")
        {
            Clustered = true;
        }
    }
    var


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