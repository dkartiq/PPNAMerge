/// <summary>
/// Table NSPP1PunchListLineImage (ID 91126).
/// </summary>
table 14021133 NSPunchListLineImage
{
    //PE-288.JS.1.0 06MAY2024 | Created new Table
    Caption = 'Punch List Image';
    Permissions = tabledata NSPunchListLineImage = RIMD;

    fields
    {
        field(1; "NS_Job No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(2; "NS_Job Task No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("NS_Job No."));
        }
        field(3; "NS_User Task"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'User Task ';
        }
        field(4; "NS_Punch List Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Punch List Code';
        }
        field(5; "NS_Punch List No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(6; "NS_Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(11; NSPPImage; Media)
        {
            Caption = 'Image';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Pk; "NS_Job No.", "NS_Job Task No.", "NS_User Task", "NS_Punch List Code", "NS_Punch List No.", "NS_Line No.")
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