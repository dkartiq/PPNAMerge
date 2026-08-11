page 14021305 "NS_Job Subcontract List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job Subcontract List';
    CardPageID = "NS_Subcontract Card";
    DataCaptionFields = "NS_Job No.";
    Editable = false;
    PageType = List;
    SourceTable = NS_Subcontract;
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            repeater(Control1100773000)
            {
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field("Buy-from Vendor No."; Rec."NS_Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Buy-from Vendor No.';
                }
                field("Buy-from Name"; Rec."NS_Buy-from Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Buy-from Name';
                }
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';
                }
                field("Starting Date"; Rec."NS_Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Starting Date';
                }
                field("Ending Date"; Rec."NS_Ending Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Ending Date';
                }
                field("Completion Date"; Rec."NS_Completion Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Completion Date';
                }
                field(Status; Rec.NS_Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Status';
                }
                field("Person Responsible"; Rec."NS_Person Responsible")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Person Responsible';
                }
                field("Budgeted Cost (LCY)"; Rec."NS_Budgeted Cost (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Budgeted Cost (LCY)';
                }
                field("Invoiced Cost (LCY)"; Rec."NS_Invoiced Cost (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Invoiced Cost (LCY)';
                }
                field("Usage (Cost) (LCY)"; Rec."NS_Usage (Cost) (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Usage (Cost) (LCY)';
                    Visible = false;
                }
                field("Sub-Level to Subcontract No."; Rec."NS_Sub-LeveltoSubcontractNo.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Sub-Level to Subcontract No.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("NS_New Subcontract Card")
            {
                ApplicationArea = All;
                Caption = 'New Subcontract';
                Image = NewDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                //SMPL RunPageMode = Create;
                ToolTip = 'Create a new subcontract.';

                trigger OnAction();
                var
                    Subcontract: Record NS_Subcontract;
                    SubcontractCard: Page "NS_Subcontract Card";
                begin
                    Subcontract.INIT();
                    Subcontract.VALIDATE("NS_Job No.", JobNo);
                    Subcontract.INSERT(true);

                    SubcontractCard.SETRECORD(Subcontract);
                    SubcontractCard.RUN();
                    NS_JobMark();
                end;

            }
            action("NS_Subcontract Card")
            {
                ApplicationArea = All;
                Caption = 'Subcontract';
                Image = CalculateRemainingUsage;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "NS_Subcontract Card";
                RunPageLink = "NS_No." = FIELD(FILTER("NS_No."));
                RunPageOnRec = true;
                ToolTip = 'View the subcontract card.';
            }
        }
    }

    trigger OnOpenPage();
    begin
        if JobNo > '' then begin
            JobFilter := JobNo;
            NS_JobMark();
        end;
    end;

    var
        Subcontract: Record NS_Subcontract;
        SubcontractDetail: Record "NS_Subcontract Lines";
        JobFilter: Text[250];
        JobNo: Code[20];

    procedure NS_JobMark();
    begin
        RESET();
        if JobFilter > '' then begin
            with Subcontract do begin
                RESET();
                SETFILTER("NS_Job No.", JobFilter);
                if FINDSET() then
                    repeat
                        if Rec.GET("NS_No.") then
                            Rec.MARK(true);
                    until NEXT() = 0;
            end;
            MARKEDONLY(true);
        end;
    end;

    procedure NS_Set(JobNoIn: Code[20]);
    begin
        JobNo := JobNoIn;
    end;

    local procedure NS_JobFilterOnAfterValidate();
    begin
        NS_JobMark();
    end;

    //SMPL Page run in create mode by default
}

