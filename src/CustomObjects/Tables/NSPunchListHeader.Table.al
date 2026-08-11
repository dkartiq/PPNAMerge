/// <summary>
/// Table NSPP1_Punch List Header (ID 14021132).
/// </summary>
table 14021132 "NS_Punch List Header"
{
    //PE-288.JS.1.0 06MAY2024 | Created new Table
    Caption = 'Punch List Header';
    DataCaptionFields = "NS_PunchListNo.", NS_Description;
    Permissions = tabledata "NS_Punch List Header" = RIMD;

    fields
    {
        field(1; "NS_PunchListNo."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Punch List No.';

        }
        field(2; NS_Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(3; "NS_Job No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Job No.';
            TableRelation = Job."No.";
            trigger OnValidate()
            var
                myInt: Integer;
                NS_Job: Record Job;
            begin
                if rec."NS_Job No." <> '' then begin
                    rec.NS_User := UserId;
                    NS_Job.SetRange("No.", rec."NS_Job No.");
                    if NS_Job.FindFirst() then
                        "NS_Job Description" := NS_Job.Description;
                    rec.Modify();
                end;

            end;

        }
        field(4; NS_Status; Enum "NS PunchList Doc Status")
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
            Editable = false;
        }
        field(5; NS_User; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'User';
            Editable = false;
        }
        field(6; "NS_Job Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Job Description';
            Editable = false;

        }
    }

    keys
    {
        key(Pk; "NS_PunchListNo.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
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