page 14021351 "NS_ProjectPro My Jobs"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'ProjectPro - My Jobs';
    PageType = ListPart;
    SourceTable = "NS_My Job";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';

                    trigger OnValidate();
                    begin
                        NS_GetJob();
                    end;
                }
                field("Job.Description"; Job.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    Editable = false;
                    Tooltip = 'Job Description';
                }
                field("Job.""Manager Job Status"""; Job."NS_Manager Job Status")
                {
                    ApplicationArea = All;
                    Caption = 'Manager Job Status';
                    ToolTip = 'Manager Job Status';


                }
                field("Job.""Job Class"""; Job."NS_Job Class")
                {
                    ApplicationArea = All;
                    Caption = 'Job Class';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Open)
            {
                ApplicationArea = All;
                Caption = 'Open';
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Return';

                trigger OnAction();
                begin
                    NS_OpenJobCard();
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        NS_GetJob();
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        CLEAR(Job);
    end;

    trigger OnOpenPage();
    begin
        SETRANGE("NS_User ID", USERID);
    end;

    var
        Job: Record Job;
        testv: Decimal;

    procedure NS_OpenJobCard();
    begin
        if Job.GET("NS_Job No.") then
            PAGE.RUN(PAGE::"Job Card", Job);
    end;

    procedure NS_GetJob();
    begin
        if not Job.GET("NS_Job No.") then
            CLEAR(Job);
    end;
}

