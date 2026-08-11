table 14021184 "NS_Job Links"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job Links';

    fields
    {
        field(1; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            NotBlank = true;
            TableRelation = Job."No.";
            DataClassification = CustomerContent;
        }
        field(2; "NS_Parent Job No."; Code[20])
        {
            Caption = 'Parent Job No.';
            NotBlank = true;
            TableRelation = Job."No.";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Job No.", "NS_Parent Job No.")
        {
        }
        key(Key2; "NS_Parent Job No.", "NS_Job No.")
        {
        }
    }

    fieldgroups
    {
    }

    procedure CreateJobLinks(JobNo: Code[20]; Parent: Code[20]);
    var
        Job: Record Job;
        JobsSetup: Record "Jobs Setup";
        JobLinks: Record "NS_Job Links";
        JobNoWork: Code[20];
        NoOfSeparators: Integer;
        i: Integer;
    begin
        with JobLinks do begin
            JobsSetup.GET();
            if JobsSetup."NS_Job List Auto Link Create" then
                if JobNo > '' then
                    if Parent > '' then begin
                        NoOfSeparators := Job.NS_SeparatorCount(JobNo);
                        if NoOfSeparators > 0 then begin
                            JobNoWork := Parent;
                            for i := 1 to NoOfSeparators do
                                if JobNoWork > '' then begin
                                    INIT();
                                    "NS_Job No." := JobNo;
                                    "NS_Parent Job No." := JobNoWork;
                                    if INSERT() then;
                                    JobNoWork := Job.ParentJobNo(JobNoWork);
                                end else begin
                                    INIT();
                                    "NS_Job No." := JobNo;
                                    "NS_Parent Job No." := JobNo;
                                    if INSERT() then;
                                end;
                        end;
                    end;
        end;
    end;

    procedure DeleteJobLinks(JobNo: Code[20]);
    var
        JobsSetup: Record "Jobs Setup";
        JobLinks: Record "NS_Job Links";
    begin
        with JobLinks do
            if JobNo > '' then
                if JobsSetup."NS_Job List Auto Link Create" then begin
                    JobsSetup.GET();
                    RESET();
                    SETCURRENTKEY("NS_Job No.", "NS_Parent Job No.");
                    SETRANGE("NS_Job No.", JobNo);
                    DELETEALL();
                end;
    end;
}

