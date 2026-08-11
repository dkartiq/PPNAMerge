/// <summary>
/// Page NS Punch List Card (ID 14021103).
/// </summary>
page 14021103 "NS Punch List Card"
{
    //PE-288.JS.1.0 06MAY2024 | Created new Page
    PageType = Document;
    UsageCategory = Documents;
    SourceTable = "NS_Punch List Header";
    RefreshOnActivate = true;
    Caption = 'Punch List';
    ApplicationArea = all;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = NS_PageEdit;

                field("NS_PunchListNo."; Rec."NS_PunchListNo.")
                {
                    Caption = 'No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PunchListNo. field.';
                }
                field(NS_Description; Rec.NS_Description)
                {
                    Caption = 'Description';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("NS_Job No."; Rec."NS_Job No.")
                {
                    Caption = 'Job No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Job No. field.';
                }
                field("NS_Job Description"; Rec."NS_Job Description")
                {
                    Caption = 'Job Description';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Job Description field.';
                }
                field(NS_Status; Rec.NS_Status)
                {
                    Caption = 'Status';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(NS_User; Rec.NS_User)
                {
                    Caption = 'User';
                    ApplicationArea = RecordLinks;
                    ToolTip = 'Specifies the value of the User field.';
                }

            }
            part(NS_PunchListTask; "NS_PunchList Task Subform")
            {
                ApplicationArea = All;
                Caption = 'Punch List Task';
                Editable = NS_PageEdit;
                UpdatePropagation = Both;
                SubPageLink = "NS_Punch List No." = field("NS_PunchListNo."), "NS_Job No." = field("NS_Job No.");

            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(Release)
            {
                ApplicationArea = Suite;
                Caption = 'Re&lease';
                Enabled = Rec.NS_Status <> Rec.NS_Status::Release;
                Image = ReleaseDoc;
                ToolTip = 'Release the document.';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    if not Confirm('Do you want to Release Document?', false) then
                        exit;
                    Rec.NS_Status := Rec.NS_Status::Release;
                    Rec.Modify();
                end;
            }

            action(Reopen)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Re&open';
                Enabled = Rec.NS_Status <> Rec.NS_Status::Open;
                Image = ReOpen;
                ToolTip = 'Reopen the document for changes';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    if not Confirm('Do you want to Reopen Document?', false) then
                        exit;
                    Rec.NS_Status := Rec.NS_Status::Open;
                    Rec.Modify();
                end;
            }

            action("NS_TakePicture")
            {
                caption = 'Take Picture';
                visible = false;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                image = Camera;
                ApplicationArea = Basic, Suite;

                trigger OnAction()
                begin

                end;
            }
            action("Punch List Report")
            {
                Caption = 'Punch List Report';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                image = Report;
                ApplicationArea = Basic, Suite;
                trigger OnAction()
                var
                    NSJobPunchListReport: Report NS_PunchListReport;
                    NSPunchListHeader: Record "NS_Punch List Header";
                begin
                    NSPunchListHeader.Reset();
                    NSPunchListHeader.SetRange("NS_PunchListNo.", rec."NS_PunchListNo.");
                    Report.RunModal(Report::NS_PunchListReport, true, true, NSPunchListHeader);
                end;
            }


        }

    }


    trigger OnInsertRecord(NSRec: Boolean): Boolean
    var
        NSFielMgtSetup: record NS_APOSetup;
        NSNoSeriesMgt: Codeunit NoSeriesManagement;
        NS_Job: Record Job;
    begin
        if NSFielMgtSetup.Get() then;
        if rec."NS_PunchListNo." = '' then
            rec."NS_PunchListNo." := NSNoSeriesMgt.GetNextNo(NSFielMgtSetup."NS_PunchList No.", Today, true);
        if Rec.GETFILTER("NS_Job No.") <> '' then
            Rec."NS_Job No." := Rec.GETFILTER("NS_Job No.");

        if rec."NS_Job No." <> '' then begin
            rec.NS_User := UserId;
            if NS_Job.Get(rec."NS_Job No.") then;
            Rec."NS_Job Description" := NS_Job.Description;
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        if (Rec.NS_Status = Rec.NS_Status::Open) or (Rec.NS_Status = Rec.NS_Status::Completed) then
            NS_PageEdit := true
        else
            NS_PageEdit := false;
    end;

    trigger OnOpenPage()
    begin
        if (Rec.NS_Status = Rec.NS_Status::Open) or (Rec.NS_Status = Rec.NS_Status::Completed) then
            NS_PageEdit := true
        else
            NS_PageEdit := false;

    end;

    var
        myInt: Integer;
        NS_PageEdit: Boolean;
        NSPPCamera: codeunit Camera;




}

