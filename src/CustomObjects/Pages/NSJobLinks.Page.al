page 14021216 "NS_Job Links"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job Links';
    PageType = Card;
    SourceTable = "NS_Job Links";

    layout
    {
        area(content)
        {
            field("Job:"; '')
            {
                ApplicationArea = All;
                CaptionClass = FORMAT(JobDesc);
                Caption = 'Job:';
                Editable = false;
                ToolTip = 'Specifies the Job:';
            }
            repeater(Control1100773000)
            {
                field("Parent Job No."; Rec."NS_Parent Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Parent Job No.';

                    trigger OnValidate();
                    begin
                        NS_ParentJobNoOnAfterValidate();
                    end;
                }
                field(JobDescription; JobDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    Editable = false;
                    ToolTip = 'Specifies the Name';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        Job.GET("NS_Parent Job No.");
        JobDescription := Job.Description;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        JobDescription := '';
    end;

    trigger OnOpenPage();
    begin
        CLEAR(ParentJob);
        if "NS_Job No." > '' then
            ParentJob.GET("NS_Job No.");
        JobDesc := COPYSTR(ParentJob."No." + ' - ' + ParentJob.Description, 1, 50);
    end;

    var
        Job: Record Job;
        ParentJob: Record Job;
        JobLinkCheck: Record "NS_Job Links";
        JobDesc: Text[50];
        JobDescription: Text[50];

    local procedure NS_ParentJobNoOnAfterValidate();
    begin
        Job.GET("NS_Parent Job No.");
        JobDescription := Job.Description
    end;
}

