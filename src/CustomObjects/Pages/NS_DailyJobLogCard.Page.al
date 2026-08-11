/// <summary>
/// Page MyPage (ID 14021454).
/// </summary>
/// Create New Page for Daily Job Log //PE-168.PS.1.0 18Sep2023
/// //PE-168.HS.1.0 7Dec2023 | Add Code 

page 14021454 "NS_Daily Job Log Card"
{
    PageType = Document;
    RefreshOnActivate = true;
    Caption = 'Job Daily Log Card';
    UsageCategory = Documents;
    SourceTable = "NS_Daily Job Log";
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = PageEdit;
                field("NS_No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document No.';
                }
                field("NS_Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No. for the log.';
                    trigger OnValidate()
                    var
                        NSJob: Record Job;
                    begin
                        if Rec."NS_Job No." <> '' then begin
                            if NSJob.get(Rec."NS_Job No.") then;
                            Rec."NS_Job Address 1" := NSJob."NS_Job Address 1";
                            Rec."NS_Job Address 2" := NSJOB."NS_Job Address 2";
                            Rec.NS_City := NSJOB."NS_Job City";
                            //PE-217.DK.3.0 23Jan2024 Start
                            //PE-217.DK.2.0 3Jan2024 Start
                            // Rec."NS_Job Zip Code" := NSJOB."NS_Job Post Code";
                            if NSJOB."NS_Job Post Code" <> '' then
                                Rec.Validate("NS_Job Zip Code", NSJOB."NS_Job Post Code")
                            else
                                Rec."NS_Job Zip Code" := NSJOB."NS_Job Post Code";
                            //PE-217.DK.2.0 3Jan2024 End
                            //PE-217.DK.3.0 23Jan2024 End
                            Rec."NS_Job County" := NSJob."NS_Job County";
                            Rec."NS_Contract Date" := NSJob."NS_Contract Date";
                            Rec.NS_Country := NSJob."NS_Job Country/Region Code";
                            Rec."NS_Completion Date" := NSjob."NS_Completion Date";
                            Rec.Validate(NS_Manager, NSjob.NS_Manager);
                            rec."NS_Estimated Completion Date" := NSJob."NS_Estimated Completion Date"; //PE-168.HS.1.0 10Nov2023
                            rec.NS_Description := NSJob.Description;  //PE-168.HS.1.0 16Nov2023
                            Rec.Modify();
                            //PE-217.DK.3.0 23Jan2024 End
                        end;
                    end;
                }
                field(NS_Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the Daily Job Log.';
                }
                field("NS_Log Date"; Rec."NS_Log Date")
                {
                    ApplicationArea = All;
                    ToolTip = ' Specifies the date for which the entry is made.';
                    ShowMandatory = true; //PE-168.HS.1.0 28Nov2023
                }
                field("NS_Job Address 1"; Rec."NS_Job Address 1")
                {
                    ApplicationArea = All;
                    ToolTip = ' Specifies the address 1 for the job.';
                }
                field("NS_Job Address 2"; Rec."NS_Job Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the address 2 for the job.';
                }
                field(NS_City; Rec.NS_City)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the city of the job.';
                }
                field("NS_Job County"; Rec."NS_Job County")
                {
                    ApplicationArea = All;
                    ToolTip = ' Specifies the state of the job. ';
                }

                field(NS_Country; Rec.NS_Country)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Country of the job.';
                }
                field("NS_Job Zip Code"; Rec."NS_Job Zip Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the zip code of the job.';
                }
                field(NS_Manager; Rec.NS_Manager)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Project Manager for the Job.';
                }
                field("NS_Project Manager Name"; Rec."NS_Project Manager Name")
                {
                    ApplicationArea = All;
                    Caption = 'Manager Name';
                    Editable = false;
                    ToolTip = 'Specifies the Project Manager name.';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the value of the Email field.';
                    Visible = false;   //PE-168.HS.1.0 16Nov2023
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = ' Specifies the ID of the person creating the Job log.';
                    Caption = 'Prepared By';  //PE-168.HS.1.0 22Nov2023
                }
                field("Date of Creation"; Rec."Date of Creation")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the logging date. It takes in the date of the system.';
                }
                field("Time of Creation"; Rec."Time of Creation")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the logging time. It takes in the time of the system.';
                }
                field("Work Shift"; Rec."Work Shift")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the worker shift.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the value of the Status field.';
                }

            }
            group(Weather)
            {
                Caption = 'Weather/Temperature';
                Editable = PageEdit;
                field(Clear; Rec.Clear)
                {
                    ApplicationArea = all;
                }
                field(Windy; Rec.Windy)
                {
                    ApplicationArea = all;
                }
                field(Rainy; Rec.Rainy)
                {
                    ApplicationArea = all;
                }
                field("Measuring Scale"; Rec."Measuring Scale")
                {
                    ApplicationArea = all;
                    Editable = false; //PE-168.HS.1.0 6Dec2023
                    Caption = 'Temperature Scale'; //PE-168.HS.1.0 6Dec2023
                    trigger OnValidate()
                    var

                    begin
                        if Rec.Temperature <> '' then begin
                            Rec.Temperature := '';
                        end;
                    end;
                }
                field(Temperature; Rec.Temperature)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                    begin
                        if Rec."Measuring Scale" <> Rec."Measuring Scale"::" " then begin
                            if Rec."Measuring Scale" = Rec."Measuring Scale"::Celsius then
                                Rec.Temperature := Rec.Temperature + '°C'
                            else
                                Rec.Temperature := Rec.Temperature + '°F';
                        end;
                    end;
                }
                field("Weather/Temperature Other"; Rec."Weather/Temperature Other")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Other';
                    ToolTip = 'Specifies the value of the Weather/Temperature Other field.';
                }

            }
            group("Site Condition")
            {
                Editable = PageEdit;
                field(Muddy; rec.Muddy)
                {
                    ApplicationArea = all;
                }
                field(Dusty; Rec.Dusty)
                {
                    ApplicationArea = all;
                }
                field("Site Condition Other"; Rec."Site Condition Other")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Other';
                    ToolTip = 'Specifies the value of the Site Condition Other field.';
                }
            }
            group(ContractSchedule)
            {
                Editable = PageEdit;
                Caption = 'Contract Schedule';
                field("NS_Contract Date"; Rec."NS_Contract Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the contract date of the job';
                }
                field("NS_Estimated Completion Date"; Rec."NS_Estimated Completion Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Job Estimated Completion Date from the job card.'; //PE-168.HS.1.0 22Nov2023
                }

                field("NS_Worker Count"; Rec."NS_Worker Count")
                {
                    ApplicationArea = all;
                    Tooltip = 'Specifies the no. of workers present on the log date.';
                    MinValue = 0;
                    MaxValue = 100000;
                }
                field("NS_Completion Date"; Rec."NS_Completion Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Estimated Completion Date according to the Project Manager.';
                }
                field("“Work Completed to Date % "; Rec."NS_Actual Work Completion %")
                {
                    ApplicationArea = all;
                    MinValue = 0;
                    MaxValue = 100;
                    Caption = 'PM Est. Work Compl. to Date %';  //PE-168.HS.1.0 16Nov2023
                    ToolTip = ' Specifies work completed to date according to the Project Manager. It is not based on any calculation.'; //PE-168.HS.1.0 10Nov2023
                }
            }
            part("Risks/Delay"; "NS_DailyJobLogSubform")
            {
                Editable = PageEdit;
                ApplicationArea = all;
                UpdatePropagation = Both;
                SubPageLink = "Document Type" = filter(Risks), "Documnet No." = field("NS_No."), "Documnet Job No." = field("NS_Job No.");

            }
            part("Safety Issues/Accidents"; "NS_Accidents SafetyIssue")
            {
                Editable = PageEdit;
                ApplicationArea = all;
                UpdatePropagation = Both;
                SubPageLink = "Document Type" = filter(Accidents), "Documnet No." = field("NS_No."), "Documnet Job No." = field("NS_Job No.");
            }
            part("Work Performed Today"; "NS_Daily Job task Subfrom")
            {
                Editable = PageEdit;
                ApplicationArea = all;
                UpdatePropagation = Both;
                SubPageLink = "Document Type" = filter("Job Task"), "Documnet No." = field("NS_No."), "Documnet Job No." = field("NS_Job No.");
            }
            part("Vendor/Subcontractors"; "NS_Daily PO Subform")
            {
                Editable = PageEdit;
                ApplicationArea = all;
                UpdatePropagation = Both;
                SubPageLink = "Document Type" = filter(Order), "Documnet No." = field("NS_No."), "Documnet Job No." = field("NS_Job No.");
            }
            part("NS_Daily Job Visitors Subfrom"; "NS_Daily Job Visitors Subfrom")
            {
                Editable = PageEdit;
                ApplicationArea = all;
                UpdatePropagation = Both;
                SubPageLink = "Document Type" = filter(Visitors), "Documnet No." = field("NS_No."), "Documnet Job No." = field("NS_Job No.");
            }
            //PE-217.DK.1.0 27Dec2023 Start
            group("SGN Signature Group")
            {
                Caption = 'Digital Signature Pad';   //PRJCTPR-235.JS.1.0 23JAN2023
                usercontrol("SGN SGNSignaturePad"; "NS_SignaturePad")
                {
                    ApplicationArea = All;
                    Visible = true;
                    trigger Ready()
                    begin
                        CurrPage."SGN SGNSignaturePad".InitializeSignaturePad();
                    end;

                    trigger Sign(Signature: Text)
                    begin
                        Rec.SignDocument(Signature);

                    end;
                }


            }

            //PE-217.DK.1.0 27Dec2023 End
            //PE-217.DK.2.0 27Dec2023 Start
            group("Signiture") //PE-217.DK.3.0 23Jan2024
            {
                caption = 'Signature Image';   //PRJCTPR-235.JS.1.0 23JAN2023
                field("SGN Signature"; Rec."NS_Signature")
                {
                    Caption = '';
                    ApplicationArea = Basic, Suit;
                    //Visible = false; //PE-217.DK.3.0 23Jan2024  //PRJCTPR-235.JS.1.0 23JAN2023
                }

            }
            //PE-217.DK.2.0 27Dec2023 End

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
                Enabled = Rec.Status <> Rec.Status::Release;
                Image = ReleaseDoc;
                ToolTip = 'Release the document.';
                Promoted = true;   //PE-168.HS.1.0 28Nov2023
                PromotedCategory = Process; //PE-168.HS.1.0 28Nov2023
                trigger OnAction()
                begin
                    if not Confirm('Do you want to Release Document?', false) then
                        exit;
                    Rec.Status := Rec.Status::Release;
                    Rec.Modify();
                end;
            }

            action(Reopen)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Re&open';
                Enabled = Rec.Status <> Rec.Status::Open;
                Image = ReOpen;
                ToolTip = 'Reopen the document for changes';
                Promoted = true;   //PE-168.HS.1.0 28Nov2023
                PromotedCategory = Process; //PE-168.HS.1.0 28Nov2023
                trigger OnAction()
                begin
                    if not Confirm('Do you want to Reopen Document?', false) then
                        exit;
                    Rec.Status := Rec.Status::Open;
                    Rec.Modify();
                end;
            }
            //PE-253.PS.1.0 15Feb2024 Start 
            action("NS_Post Job Work Unit")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Submit Job Work Units';
                ToolTip = 'Specifies posting of "Work Units Completed" through Job Journal. To post the Journal, the user must have permission on the user setup.';
                Image = JobJournal;
                trigger OnAction()
                var
                    NS_UserSetup: Record "User Setup";
                    NS_JobJournalRec: Record "Job Journal Line";
                    NS_JobJournalpage: Page "Job Journal";
                    NSDailyJobLogSub: Record "NS_Daily Job Log Sub.";
                begin
                    if NS_UserSetup.get(UserId) then;
                    if Rec.Status = Rec.Status::Release then begin
                        If NS_UserSetup."NS_Allow posting Job Journal" = true then begin

                            NSDailyJobLogSub.NS_CreateEntriesForJobJournals(Rec);
                            NS_JobJournalRec.Reset();
                            NS_JobJournalRec.SetRange("Journal Batch Name", 'DEFAULT');
                            NS_JobJournalRec.SetRange("Journal Template Name", 'JOB');
                            NS_JobJournalRec.SetRange("Job No.", Rec."NS_Job No.");
                            if NS_JobJournalRec.findSet() then
                                Page.RUN(201, NS_JobJournalRec);


                        end else
                            Error('You cannot submit to the Job Journal as you do not have permission. Please check “Allow Submittal of Job Work Units” on the user setup.');
                    end else begin
                        Error('Status must be Released');
                    end;


                end;

            }
            //PE-253.PS.1.0 15Feb2024 End 
            action(Email)
            {
                ApplicationArea = All;
                Caption = 'Send Email';
                Image = Email;
                ToolTip = 'Send an email';
                Promoted = true;   //PE-168.HS.1.0 28Nov2023
                PromotedCategory = Process; //PE-168.HS.1.0 28Nov2023
                trigger OnAction()
                var
                    TempEmailItem: Record "Email Item" temporary;
                    EmailScenario: Enum "Email Scenario";
                begin
                    Rec.TestField("E-Mail");
                    Rec.TestField(Status, Rec.Status::Release);
                    if not Confirm('Do you want to Send Mail?', false) then
                        exit;
                    SendEmailNotificationToClient(Rec, Today);
                end;
            }
            //PE-168.DK.1.0 01NOV2023 Start 
            action("Daily Job Log Report")
            {
                ApplicationArea = All;
                Caption = 'Job Daily Log Report';
                Image = Report;
                ToolTip = 'Job Daily Log';
                Promoted = true;   //PE-168.HS.1.0 28Nov2023
                PromotedCategory = Process; //PE-168.HS.1.0 28Nov2023
                trigger OnAction()
                var
                    NS_DailyJobLog: Report "NS_Daily Job Log Report";
                    NS_DailyJobLogs: Record "NS_Daily Job Log"; //PE-168.HS.1.0 6NOV2023
                begin
                    //PE-168.HS.1.0 6NOV2023 Start
                    NS_DailyJobLogs.SetRange("NS_No.", rec."NS_No.");
                    if NS_DailyJobLogs.FindFirst() then
                        Report.RunModal(14021453, true, false, NS_DailyJobLogs)
                    //PE-168.HS.1.0 6NOV2023 End
                end;
                //PE-168.DK.1.0 01NOV2023 End
            }
        }

    }
    trigger OnInsertRecord(NSRec: Boolean): Boolean
    var
        JobSetup: Record "Jobs Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NSJob: Record Job; //PE-168.HS.1.0 7Dec2023
        NSAPOSetup: Record NS_APOSetup;//PRJCTPR-275.PS.1.0 22Dec2023

    begin
        if NSAPOSetup.Get() then;
        if JobSetup.Get() then;
        if Rec."NS_No." = '' then begin
            // Rec."NS_No." := NoSeriesMgt.GetNextNo(JobSetup."NS_Daliy Job Doc No.", Today, true); //PRJCTPR-275.PS.1.0 22Dec2023 Commented
            Rec."NS_No." := NoSeriesMgt.GetNextNo(NSAPOSetup."NS_Job Daliy Log Doc. No.", Today, true);
            Rec."NS_Log Date" := WorkDate();

            //PE-168.HS.1.0 7Dec2023 Start
            if Rec.GETFILTER("NS_Job No.") <> '' then
                Rec."NS_Job No." := Rec.GETFILTER("NS_Job No.");
            if Rec."NS_Job No." <> '' then begin
                if NSJob.get(Rec."NS_Job No.") then;
                Rec."NS_Job Address 1" := NSJob."NS_Job Address 1";
                Rec."NS_Job Address 2" := NSJOB."NS_Job Address 2";
                Rec.NS_City := NSJOB."NS_Job City";
                //PRJCTPR-356.DK.1.0 01May2024 Start
                if NSJOB."NS_Job Post Code" <> '' then
                    Rec.Validate("NS_Job Zip Code", NSJOB."NS_Job Post Code")
                else
                    //PRJCTPR-356.DK.1.0 01May2024 End
                Rec."NS_Job Zip Code" := NSJOB."NS_Job Post Code";
                Rec."NS_Job County" := NSJob."NS_Job County";
                Rec."NS_Contract Date" := NSJob."NS_Contract Date";
                Rec.NS_Country := NSJob."NS_Job Country/Region Code";
                Rec."NS_Completion Date" := NSjob."NS_Completion Date";
                Rec.Validate(NS_Manager, NSjob.NS_Manager);
                rec."NS_Estimated Completion Date" := NSJob."NS_Estimated Completion Date";
                rec.NS_Description := NSJob.Description;
                if Rec."Date of Creation" = 0D then begin
                    Rec."Date of Creation" := WorkDate();
                    Rec."Time of Creation" := Time;
                    Rec."Created By" := UserId;
                end;
            end;
            //PE-168.HS.1.0 7Dec2023 End
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec.Status = Rec.Status::Open then
            PageEdit := true
        else
            PageEdit := false;
    end;

    trigger OnOpenPage()
    begin
        if Rec.Status = Rec.Status::Open then
            PageEdit := true
        else
            PageEdit := false;
    end;

    var
        Resource: Record Resource;
        NS_Purchase: Record "Purchase Header";
        PageEdit: Boolean;
        ManagerName: Text;

        kkk: Page "Customer list";

    procedure SendEmailNotificationToClient(Rec: Record "NS_Daily Job Log"; LicValidDate: date)

    var
        EmailMessege: codeunit "Email Message";
        EmailSend: Codeunit Email;
        Body: text;
        BodyText: Text;
        DailyJobLogSenderEmail: Text;
        UserSetup: Record "User Setup";
    begin
        Clear(BodyText);
        Clear(DailyJobLogSenderEmail);
        if UserSetup.Get(UserId) then;
        UserSetup.TestField("E-Mail");
        DailyJobLogSenderEmail := UserSetup."E-Mail";

        if Rec."E-Mail" <> '' then
            BodyText += (Format(StrSubstNo('Dear %1 ,', rec."NS_Project Manager Name")));
        BodyText += (Format('<BR>'));
        BodyText += (Format('<BR>'));
        BodyText += (Format(StrSubstNo('Please find attchement daily job log ')));
        BodyText += (Format('<BR>'));
        BodyText += (Format('<BR>'));
        BodyText += (Format(StrSubstNo('In case of any query wright me back %1', DailyJobLogSenderEmail)));
        BodyText += (Format('<BR>'));
        BodyText += (Format('<BR>'));
        if Rec."E-Mail" <> '' then begin
            if Rec."No of Email Send" = 0 then
                EmailMessege.Create(Rec."E-Mail", 'Daily Job Log ' + Rec."NS_Job No." + ' ' + Format(Rec."Date of Creation") + ' ' + Format(Rec."Work Shift"), BodyText, true)
            else
                EmailMessege.Create(Rec."E-Mail", 'Revised ' + Format(Rec."No of Email Send") + ' Daily Job Log ' + Rec."NS_Job No." + ' ' + Format(Rec."Date of Creation") + ' ' + Format(Rec."Work Shift"), BodyText, true);
            if EmailSend.Send(EmailMessege) then begin
                Rec."No of Email Send" := rec."No of Email Send" + 1;
                Rec.Modify();
            end;
        end;
    end;
}