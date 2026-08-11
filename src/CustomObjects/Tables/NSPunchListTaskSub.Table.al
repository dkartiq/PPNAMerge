
/// <summary>
/// Table NSPP1_PunchListTask (ID 91103).
/// </summary>
table 14021134 NS_PunchListDailyTasks
{
    //PE-288.JS.1.0 06MAY2024 | Created new Page    
    LookupPageId = "NS_PunchList Task Subform";
    DrillDownPageId = "NS_PunchList Task Subform";
    Caption = 'Punch List Tasks';
    Permissions = tabledata NS_PunchListDailyTasks = RIMD;

    fields
    {
        field(1; "NS_Job No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Job No.';
            TableRelation = Job;

            trigger OnValidate()
            var
                NS_Job: Record Job;
            begin
                if "NS_Job No." <> '' then begin
                    NS_Job.SetRange("No.", Rec."NS_Job No.");
                    if NS_Job.FindFirst() then begin
                        NSPP1_JobDescription := NS_Job.Description;
                    end;
                end;

            end;

        }
        field(2; "NS_Job Task No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("NS_Job No."));

            trigger OnValidate()
            var
                Jobtask: Record "Job Task";
            begin
                if "NS_Job Task No." <> '' then begin
                    Jobtask.SetRange("Job Task No.", rec."NS_Job Task No.");
                    if jobtask.FindFirst() then begin
                        Rec."NS_Job Task Description." := Jobtask.Description;
                    end;
                    NS_status := NS_status::NS_Open;
                end;
            end;
        }
        field(3; "NS_Job Task Description."; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Job Task Description';
        }
        field(4; NS_Status; Enum NS_UserTaskStatus)
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
        }
        field(5; NS_Priority; Enum NS_UserTaskPriority)
        {
            DataClassification = CustomerContent;
            Caption = 'Priority';
        }
        field(6; NS_StartDate; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Start Date';
        }
        field(7; NS_DueDate; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Due Date';
        }
        field(8; "NS_User Task"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'User Task ';
        }
        field(9; "NS_Punch List Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Punch List Code';
        }
        field(10; NS_Assignee; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Assignee';
        }
        field(11; NS_Comments; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Comments';
        }
        field(12; NS_Close; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Closed';
        }
        field(13; NS_PunchListDescription; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Punch List Description';
        }
        field(14; NS_CloseDate; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Closed Date';
        }
        field(15; "NS_Punch List No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(16; "NS_Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(17; NS_ClientApproval; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Required Client Approval';
        }
        field(18; "NS_Closed By"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Closed By';
        }
        field(19; NS_link; Text[100])
        {
            DataClassification = CustomerContent;
            ExtendedDatatype = URL;
            Caption = 'Link';

        }
        field(20; "NS_Camera_Image"; Media)  //Old value is Media
        {
            DataClassification = CustomerContent;
            Caption = 'Camera Image';

        }
        field(21; NSPP_GetImage; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Image';    //Assisted Edit Button

        }
        field(22; "NSPP_Tenent Media ID"; Guid)
        {
            DataClassification = CustomerContent;
            Caption = 'Tenent Media ID';
            editable = false;
        }
        field(23; NSPP_Content; BLOB)
        {
            DataClassification = CustomerContent;
            Caption = 'Content';
            Subtype = Bitmap;
        }
        field(24; NSPP1_JobDescription; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Job Description';
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