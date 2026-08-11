/// <summary>
/// Page NS_PunchList Task Subform (ID 14021336).
/// </summary>
page 14021336 "NS_PunchList Task Subform"
{
    // PE-288.JS.1.0 06MAY2024 | Created new Page
    PageType = ListPart;
    SourceTable = NS_PunchListDailyTasks;
    Caption = 'Punch List Tasks';
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    RefreshOnActivate = TRUE;


    layout
    {
        area(Content)
        {
            repeater(List)
            {

                field("NS_Job No."; Rec."NS_Job No.")
                {
                    Caption = 'Job No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Job No. field.';
                    Editable = NS_LineEdit;
                    Visible = false;
                }
                field("NS_Job Task No."; Rec."NS_Job Task No.")
                {
                    Caption = 'Job Task No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Job Task No. field.';
                    Editable = NS_LineEdit;
                }
                field("NS_Job Task Description."; Rec."NS_Job Task Description.")
                {
                    Caption = 'Job Description';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Job Task Description field.';
                    Editable = NS_LineEdit;
                }
                field("NS_User Task"; Rec."NS_User Task")
                {
                    Caption = 'User Task';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User Job Task No. field.';
                    Editable = NS_LineEdit;

                    trigger OnLookup(VAR Text: Text): Boolean;
                    var
                        NS_UserTask: Record "User Task";
                        NS_UsertasklistPg: page "User Task List";
                    begin
                        NS_UserTask.Reset();
                        NS_UserTask.SetRange("NS_Job No.", rec."NS_Job No.");
                        NS_UserTask.SetRange("NS_Task No.", rec."NS_Job Task No.");
                        if Page.RunModal(Page::"User Task List", NS_UserTask) = ACTION::LookupOK then begin

                            Rec."NS_User Task" := NS_UserTask.ID;
                            Rec.NS_StartDate := NS_UserTask."Start DateTime";
                            Rec.NS_DueDate := NS_UserTask."NS_Due Date";
                            Rec.NS_Assignee := NS_UserTask."Assigned To User Name";
                            if NS_UserTask.Priority = NS_UserTask.Priority::Low then
                                Rec.NS_Priority := rec.NS_Priority::NS_Low;
                            if NS_UserTask.Priority = NS_UserTask.Priority::High then
                                Rec.NS_Priority := rec.NS_Priority::NS_High;
                            if NS_UserTask.Priority = NS_UserTask.Priority::Normal then
                                Rec.NS_Priority := rec.NS_Priority::NS_Normal;
                        end;
                    end;
                }
                field("NS_Punch List Code"; Rec."NS_Punch List Code")
                {
                    Caption = 'Punch List Code';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Punch List Code field.';
                    Editable = NS_LineEdit;
                    trigger OnLookup(VAR Text: Text): Boolean;
                    var
                        myInt: Integer;
                        NS_PunchListCode: Record "NS_Punch List Code";
                        NS_PunchlistCodePg: Page "NS_Punch List Codes";
                    begin
                        NS_PunchListCode.Reset();
                        if Page.RUNMODAL(Page::"NS_Punch List Codes", Ns_PunchListCode) = ACTION::LookupOK then begin
                            Rec."NS_Punch List Code" := Ns_PunchListCode."NS_Punch List code";
                            Rec.NS_PunchListDescription := Ns_PunchListCode.NS_Description;
                        end;

                    end;

                }
                field(NS_PunchListDescription; Rec.NS_PunchListDescription)
                {
                    Caption = 'Punch List Description';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Punch List Description field.';
                    Editable = NS_LineEdit;
                }

                field(NS_status; Rec.NS_status)
                {
                    Caption = 'Status';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                    Editable = NS_LineEdit;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        if rec.NS_status = rec.NS_status::NS_InReview then
                            NS_Edit := True
                        else
                            NS_Edit := False;
                    end;
                }
                field(NS_Priority; Rec.NS_Priority)
                {
                    Caption = 'Priority';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Priority field.';
                    Editable = NS_LineEdit;
                }
                field(NS_StartDate; DT2Date(Rec.NS_StartDate))
                {
                    Caption = 'Start Date';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Start Date field.';
                    Editable = NS_LineEdit;
                }
                field(NS_DueDate; Rec.NS_DueDate)
                {
                    Caption = 'Due Date';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Due Date field.';
                    Editable = NS_LineEdit;
                }
                field(NS_ClientApproval; Rec.NS_ClientApproval)
                {
                    Caption = 'Client Approval';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Client Approval field.';
                    Editable = NS_LineEdit;
                }
                field(NS_Close; Rec.NS_Close)
                {
                    Caption = 'Close';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Close field.';
                    trigger OnValidate()
                    var
                        myInt: Integer;
                        NS_PunchListHeader: Record "NS_Punch List Header";
                        NS_Punchlistlines: Record NS_PunchListDailyTasks;
                        NS_Punchlistlines2: Record NS_PunchListDailyTasks;
                        NS_Punchlistlines3: Record NS_PunchListDailyTasks;
                        NScount: Integer;
                        NSClose: Integer;
                    begin
                        if Rec.NS_Close then begin
                            Rec.NS_closeDate := Today;
                            Rec."NS_Closed By" := UserId;
                        end
                        else begin
                            Rec.NS_closeDate := 0D;
                            Rec."NS_Closed By" := '';
                        end;

                        Clear(NScount);
                        Clear(NSClose);
                        NS_Punchlistlines.Reset();
                        NS_Punchlistlines.SetRange("NS_Punch List No.", Rec."NS_Punch List No.");
                        NS_Punchlistlines.SetRange("NS_Job No.", rec."NS_Job No.");
                        if NS_Punchlistlines.FindSet() then
                            NScount := NS_Punchlistlines.Count;

                        NS_Punchlistlines2.Reset();
                        NS_Punchlistlines2.SetRange("NS_Punch List No.", Rec."NS_Punch List No.");
                        NS_Punchlistlines2.SetFilter("NS_Line No.", '<>%1', rec."NS_Line No.");
                        NS_Punchlistlines2.SetRange(NS_Close, true);
                        if NS_Punchlistlines2.FindFirst() then
                            NSClose := NS_Punchlistlines2.Count;
                        if rec.NS_Close = true then
                            NSClose += 1;

                        NS_PunchListHeader.Reset();
                        NS_PunchListHeader.SetRange("NS_PunchListNo.", rec."NS_Punch List No.");
                        NS_PunchListHeader.SetRange("NS_Job No.", rec."NS_Job No.");
                        if NS_PunchListHeader.FindSet() then begin
                            if NScount = NSClose then
                                NS_PunchListHeader.NS_Status := NS_PunchListHeader.NS_Status::Completed
                            else
                                NS_PunchListHeader.NS_Status := NS_PunchListHeader.NS_Status::Open;
                            NS_PunchListHeader.Modify()
                        end;
                        if (rec."NS_Job No." = '') or (rec."NS_Job Task No." = '') or (rec."NS_User Task" = 0) or (rec."NS_Punch List Code" = '') then begin
                            rec.TestField(rec."NS_Job No.");
                            rec.TestField(rec."NS_Job Task No.");
                            rec.TestField(rec."NS_User Task");
                            rec.TestField(rec."NS_Punch List Code");
                        end;

                        if rec.NS_status <> rec.NS_status::NS_Complete then
                            Error('Status should be completed in order to close the line');

                        if rec.NS_Close then
                            NS_LineEdit := False
                        else
                            NS_LineEdit := true;
                    end;
                }
                field(NSPP_Content; Rec.NSPP_Content)
                {
                    Caption = 'Image Content';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Content field.';

                }
                field(NSPP_GetImage; Rec.NSPP_GetImage)
                {
                    Caption = 'Image Full View';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Image full view';
                    Editable = false;
                    Visible = false;

                    trigger OnDrillDown()
                    var
                        NSPPPunchListLinImage: record NS_PunchListDailyTasks;
                        NSPPPunchListListImagePage: page NS_PunchListPicturePage;

                    begin
                        NSPPPunchListLinImage.Reset();
                        NSPPPunchListLinImage.setrange("NS_Job No.", rec."NS_Job No.");
                        NSPPPunchListLinImage.setrange("NS_Job Task No.", rec."NS_Job Task No.");
                        NSPPPunchListLinImage.setrange("NS_User Task", rec."NS_User Task");
                        NSPPPunchListLinImage.setrange("NS_Punch List Code", rec."NS_Punch List Code");
                        NSPPPunchListLinImage.setrange("NS_Punch List No.", rec."NS_Punch List No.");
                        NSPPPunchListLinImage.setrange("NS_Line No.", rec."NS_Line No.");
                        if NSPPPunchListLinImage.FindFirst() then begin
                            NSPPPunchListLinImage.CalcFields(NSPP_Content);
                            NSPPPunchListListImagePage.SetTableView(NSPPPunchListLinImage);
                            NSPPPunchListListImagePage.Run();
                        end;
                    end;
                }
                field(NS_Notes; Rec.NS_Comments)
                {
                    Caption = 'Comments';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Notes field.';
                    Editable = NS_LineEdit;
                }
                field("NS_Closed By"; Rec."NS_Closed By")
                {
                    Caption = 'Closed By';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Closed By field.';
                    Editable = NS_LineEdit;
                }
                field(NS_closeDate; Rec.NS_closeDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Closed Date field.';
                    Caption = 'Closed Date';
                    Editable = NS_LineEdit;
                }
                field(NS_Assignee; Rec.NS_Assignee)
                {
                    Caption = 'Assignee';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Assignee field.';
                    Editable = NS_LineEdit;
                }
                field(NS_link; rec.NS_link)
                {
                    Caption = 'link';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the link field.';
                    visible = false;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        if rec.NS_link <> '' then
                            NS_Hyperlink := rec.NS_link
                        else
                            NS_Hyperlink := '';

                    end;

                }
                field(NS_Camera_Image; Rec.NS_Camera_Image)
                {
                    Caption = 'Image';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the the Camera Image field.';
                }
                field(NS_links; NS_Hyperlink)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the link field.';
                    Caption = 'View Link';
                    Editable = false;
                    visible = false;
                    ExtendedDatatype = URL;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(NSTakePicture)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Take';
                Image = Camera;
                ToolTip = 'Activate the camera on the device.';
                Visible = NSCameraAvailable;
                RunObject = Page NS_PunchListPicturePage;
                RunPageLink = "NS_Job No." = field("NS_Job No."), "NS_Job Task No." = field("NS_Job Task No."),
                    "NS_User Task" = field("NS_User Task"), "NS_Punch List Code" = field("NS_Punch List Code"),
                    "NS_Punch List No." = field("NS_Punch List No."), "NS_Line No." = field("NS_Line No.");

                trigger OnAction()
                begin
                    NSPPTakeNewPicture();
                end;
            }

            action(ImportPicture)
            {
                ApplicationArea = All;
                Caption = 'Import Image';
                Image = Import;
                ToolTip = 'Import a picture file.';
                Visible = NSHideActions = FALSE;
                trigger OnAction()
                begin
                    NSPPImportFromDevice();
                end;
            }
            action(NSPPDeletePicture)
            {
                ApplicationArea = All;
                Caption = 'Delete Image';
                Image = Delete;
                ToolTip = 'Delete the record.';
                trigger OnAction()
                begin
                    NSDeleteItemPicture();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        NSPUnchlistHeader: Record "NS_Punch List Header";
    begin
        NS_LineEdit := true;

        NSTenentMedia.Reset();
        NSTenentMedia.setrange(ID, rec."NSPP_Tenent Media ID");
        if NSTenentMedia.FindFirst() then begin
            NSTenentMedia.CalcFields(Content);
            rec.NSPP_Content := NSTenentMedia.Content;
        end;
    end;

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
        NSPUnchlistHeader: Record "NS_Punch List Header";
    begin
        NS_LineEdit := true;


        NSTenentMedia.Reset();
        NSTenentMedia.setrange(ID, rec."NSPP_Tenent Media ID");
        if NSTenentMedia.FindFirst() then begin
            NSTenentMedia.CalcFields(Content);
            rec.NSPP_Content := NSTenentMedia.Content;
        end;
    end;

    trigger OnOpenPage()
    var
        NSPUnchlistHeader: Record "NS_Punch List Header";
    begin
        NS_LineEdit := true;
        // if (NSPUnchlistHeader.NS_Status = NSPUnchlistHeader.NS_Status::Open) then
        //     NS_LineEdit := true
        // else
        //     NS_LineEdit := false;

        NSCameraAvailable := NSCamera.IsAvailable();

    end;


    var
        myInt: Integer;
        NSTenentMedia: record "Tenant Media";
        NS_Edit: Boolean;
        NS_LineEdit: Boolean;
        NS_Hyperlink: text;
        NS_LinkEdit: boolean;
        NSCamera: codeunit Camera;

        NSCameraAvailable: Boolean;
        NSPPMimeTypeTok: Label 'image/jpeg', Locked = true;
        NSOverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
        NSSelectPictureTxt: Label 'Select a picture to upload';
        NSDeleteImageQst: Label 'Are you sure you want to delete the picture?';
        NSDeleteExportEnabled: Boolean;
        NSHideActions: Boolean;


    local procedure NSPPTakeNewPicture()
    var
        NSPPPictureInstream: InStream;
        NSPPPictureDescription: Text;
    begin
        rec.testfield("NS_Job No.");
        Rec.TestField("NS_Job Task No.");
        rec.testfield("NS_User Task");
        Rec.TestField("NS_Punch List Code");
        rec.testfield("NS_Punch List No.");
        rec.TestField("NS_Line No.");

        NSPPOnTakePictureOnBeforeAddPicture(Rec);

        if Rec.NS_Camera_Image.HasValue() then
            //if rec.NS_Camera_Image.count > 0 then
            if not Confirm(NSOverrideImageQst) then
                exit;

        if NSCamera.GetPicture(NSPPPictureInstream, NSPPPictureDescription) then begin
            Clear(Rec.NS_Camera_Image);
            rec."NSPP_Tenent Media ID" := Rec.NS_Camera_Image.ImportStream(NSPPPictureInstream, NSPPPictureDescription, NSPPMimeTypeTok);
            Rec.Modify(true);
        end;
    end;


    /// <summary>
    /// NSPPImportFromDevice.
    /// </summary>
    procedure NSPPImportFromDevice()
    var
        NSPPFileManagement: Codeunit "File Management";
        NSPPFileName: Text;
        NSPPClientFileName: Text;
        NSPPInStr: InStream;
    begin
        Clear(NSPPInStr);
        Rec.Find();
        rec.testfield("NS_Job No.");
        Rec.TestField("NS_Job Task No.");
        rec.testfield("NS_User Task");
        Rec.TestField("NS_Punch List Code");
        rec.testfield("NS_Punch List No.");
        rec.TestField("NS_Line No.");


        //if rec.NS_Camera_Image.count > 0 then
        if Rec.NS_Camera_Image.HasValue() then
            if not Confirm(NSOverrideImageQst) then
                Error('');
        NSPPClientFileName := '';

        UploadIntoStream(NSSelectPictureTxt, '', '', NSPPClientFileName, NSPPInStr);

        if NSPPClientFileName <> '' then
            NSPPFileName := NSPPFileManagement.GetFileName(NSPPClientFileName);

        if NSPPFileName = '' then
            Error('');
        Clear(Rec.NS_Camera_Image);
        rec."NSPP_Tenent Media ID" := Rec.NS_Camera_Image.ImportStream(NSPPInStr, NSPPFileName, NSPPMimeTypeTok);
        Rec.Modify(true);
    end;


    // local procedure NSPPSetEditableOnPictureActions()
    // begin
    //     if Rec.NS_Camera_Image.count > 0 then
    //         NSPPDeleteExportEnabled := true
    //     else
    //         NSPPDeleteExportEnabled := false;
    // end;


    /// <summary>
    /// NSPPDeleteItemPicture.
    /// </summary>
    procedure NSDeleteItemPicture()
    var
        NNPPTenentMedia: Record "Tenant Media";
    begin
        Rec.Find();
        rec.testfield("NS_Job No.");
        Rec.TestField("NS_Job Task No.");
        rec.testfield("NS_User Task");
        Rec.TestField("NS_Punch List Code");
        rec.testfield("NS_Punch List No.");
        rec.TestField("NS_Line No.");
        if not Confirm(NSDeleteImageQst) then
            exit;

        NSTenentMedia.Reset();
        NSTenentMedia.setrange(ID, rec."NSPP_Tenent Media ID");
        if NSTenentMedia.FindFirst() then begin
            NSTenentMedia.Delete();
        end;
        Clear(Rec."NSPP_Content");
        Rec.Modify(true);
    end;

    [IntegrationEvent(false, false)]
    local procedure NSPPOnTakePictureOnBeforeAddPicture(var NSPunchListTask: Record NS_PunchListDailyTasks)
    begin
    end;

}