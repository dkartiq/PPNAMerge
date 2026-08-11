page 14021383 "NS_Manager Time Sheet Overview"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    AutoSplitKey = true;
    Caption = 'Manager Time Sheet Overview';
    InsertAllowed = false;
    PageType = Worksheet;
    PromotedActionCategories = 'New,Process,Report,Navigate,Show';
    SaveValues = true;
    SourceTable = "Time Sheet Line";

    layout
    {
        area(content)
        {
            group(Control26)
            {
                field(CrewFilter; CrewFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Crew Filter';
                    TableRelation = NS_Crew;

                    trigger OnValidate();
                    begin
                        if CrewFilter <> '' then begin
                            TempResource.DELETEALL();
                            Crew.GET(CrewFilter);
                            CrewLine.RESET();
                            CrewLine.SETRANGE(NS_Code, CrewFilter);
                            if not CrewLine.FINDSET() then
                                ERROR(Text001, CrewFilter)
                            else begin
                                repeat
                                    if CrewLine."NS_Resource No." <> '' then
                                        if Resource.GET(CrewLine."NS_Resource No.") then
                                            if not TempResource.GET(CrewLine."NS_Resource No.") then begin
                                                TempResource.INIT();
                                                TempResource."No." := CrewLine."NS_Resource No.";
                                                TempResource.INSERT();
                                            end;
                                until CrewLine.NEXT() = 0;
                                if not TempResource.FINDSET() then
                                    ERROR(Text002)
                                else begin
                                    CLEARMARKS;
                                    SETRANGE("NS_Resource No.");
                                    if FINDSET() then
                                        repeat
                                            if TempResource.GET("NS_Resource No.") then
                                                MARK(true);
                                        until NEXT() = 0;
                                    MARKEDONLY(true);
                                    ClearCrewFilter := false;
                                    CurrPage.UPDATE(false);
                                end;
                            end;
                        end;
                    end;
                }
                field(ClearCrewFilter; ClearCrewFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Clear Crew Filter';

                    trigger OnValidate();
                    begin
                        if ClearCrewFilter then begin
                            CrewFilter := '';
                            CLEARMARKS;
                            RESET();
                            CurrPage.UPDATE(false);
                        end;
                    end;
                }
            }
            repeater(Control1)
            {
                field("Resource No."; Rec."NS_Resource No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Resource No.';

                    trigger OnValidate();
                    begin
                        NS_CheckIfPosted(FIELDCAPTION("NS_Resource No."));
                        NS_LookupResourceName;
                    end;
                }
                field(ResourceName; ResourceName)
                {
                    ApplicationArea = All;
                    Caption = 'Resource Name';
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Type';

                    trigger OnValidate();
                    begin
                        NS_CheckIfPosted(FIELDCAPTION(Type));
                    end;
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';

                    trigger OnValidate();
                    begin
                        NS_CheckIfPosted(FIELDCAPTION("Job No."));
                    end;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Task No.';

                    trigger OnValidate();
                    begin
                        NS_CheckIfPosted(FIELDCAPTION("Job Task No."));
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field("Skill Class"; '')//PE-68 Dk.1.0 10April2023
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Skill Class';
                    Visible = false;//PE-68 Dk.1.0 10April2023
                }
                //PE-68 Dk.1.0 10April2023 Start
                field("Skill Class New"; Rec."NS_Skill Class New")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Skill Class';
                }

                //PE-68 Dk.1.0 10April2023 End
                field("Work Type Code"; Rec."Work Type Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Type Code';

                    trigger OnValidate();
                    begin
                        NS_CheckIfPosted(FIELDCAPTION("Work Type Code"));
                    end;
                }
                field("Cause of Absence Code"; Rec."Cause of Absence Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Cause of Absence Code';
                }
                field("Total Quantity"; Rec."Total Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Quantity';

                    trigger OnDrillDown();
                    var
                        TimeSheetDetail: Record "Time Sheet Detail";
                        ManagerTimeSheetLineDetail: Page "NS_Manager TimeSheetLineDetail";
                    begin
                        CLEAR(ManagerTimeSheetLineDetail);
                        TimeSheetDetail.RESET();
                        TimeSheetDetail.SETRANGE("Time Sheet No.", "Time Sheet No.");
                        TimeSheetDetail.SETRANGE("Time Sheet Line No.", "Line No.");
                        ManagerTimeSheetLineDetail.SETTABLEVIEW(TimeSheetDetail);
                        ManagerTimeSheetLineDetail.RUNMODAL;
                        CALCFIELDS("Total Quantity");
                    end;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Status';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Posted';
                }
                field("Total Posted Quantity"; Rec."NS_Total Posted Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Posted Quantity';
                }
                field("Time Sheet No."; Rec."Time Sheet No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Time Sheet No.';

                    trigger OnValidate();
                    begin
                        NS_CheckIfPosted(FIELDCAPTION("Time Sheet No."));
                    end;
                }
                field("Time Sheet Starting Date"; Rec."Time Sheet Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Time Sheet Starting Date';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'Time Sheet Line No.';

                    trigger OnValidate();
                    begin
                        NS_CheckIfPosted(FIELDCAPTION("Line No."));
                    end;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("Posting E&ntries")
                {
                    ApplicationArea = All;
                    Caption = 'Posting E&ntries';
                    Image = PostingEntries;
                    Promoted = true;
                    PromotedCategory = Category5;
                    ShortCutKey = 'Ctrl+F7';

                    trigger OnAction();
                    begin
                        TimeSheetMgt.ShowPostingEntries("Time Sheet No.", "Line No.");
                    end;
                }
            }
            group("Co&mments")
            {
                Caption = 'Co&mments';
                Image = ViewComments;
                action("&Time Sheet Comments")
                {
                    ApplicationArea = All;
                    Caption = '&Time Sheet Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "Time Sheet Comment Sheet";
                    RunPageLink = "No." = FIELD("Time Sheet No."),
                                  "Time Sheet Line No." = CONST(0);
                }
                action(Comments_Line)
                {
                    ApplicationArea = All;
                    Caption = '&Line Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "Time Sheet Comment Sheet";
                    RunPageLink = "No." = FIELD("Time Sheet No."),
                                  "Time Sheet Line No." = FIELD("Line No.");
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = '&Approve';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction();
                    begin
                        NS_Approve;
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = '&Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        NS_Reject;
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = All;
                    Caption = 'Re&open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        NS_Reopen;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        NS_LookupResourceName;
    end;

    trigger OnDeleteRecord(): Boolean;
    begin
        if Posted then
            ERROR(Text003);
    end;

    trigger OnOpenPage();
    begin
        UserSetup.GET(USERID);
        if not UserSetup."Time Sheet Admin." then
            ERROR(Text005);
        CrewFilter := '';
        ClearCrewFilter := false;
    end;

    var
        UserSetup: Record "User Setup";
        Resource: Record Resource;
        TempResource: Record Resource temporary;
        Crew: Record NS_Crew;
        CrewLine: Record "NS_Crew Line";
        TimeSheetHeader: Record "Time Sheet Header";
        TimeSheetLine: Record "Time Sheet Line";
        TimeSheetMgt: Codeunit "Time Sheet Management";
        TimeSheetApprovalMgt: Codeunit "Time Sheet Approval Management";
        Description: Text[50];
        ResourceName: Text[50];
        StartDateFilter: Date;
        EndDateFilter: Date;
        CrewFilter: Code[10];
        Text001: Label 'Crew %1 does not have any resources assigned to it.';
        ClearCrewFilter: Boolean;
        Text002: Label 'There are no valid Resource Nos. assigned to Crew %1.';
        Text003: Label 'Delete not allowed because this line has been posted. Use the Time Sheet Archive function.';
        Text004: Label 'The %1 cannot be modified since the line has already been posted.';
        CurrPosition: Text[200];
        Text005: Label 'Your Login has not been setup as a Time Sheet Administrator.';

    procedure NS_Process("Action": Option "Approve Selected","Approve All","Reopen Selected","Reopen All","Reject Selected","Reject All");
    var
        TimeSheetLine: Record "Time Sheet Line";
        ActionType: Option Approve,Reopen,Reject;
    begin
        case Action of
            Action::"Approve All",
          Action::"Reject All":
                NS_FilterAllLines(TimeSheetLine, ActionType::Approve);
            Action::"Reopen All":
                NS_FilterAllLines(TimeSheetLine, ActionType::Reopen);
            else
                CurrPage.SETSELECTIONFILTER(TimeSheetLine);
        end;
        if TimeSheetLine.FINDSET() then
            repeat
                case Action of
                    Action::"Approve Selected",
                  Action::"Approve All":
                        TimeSheetApprovalMgt.Approve(TimeSheetLine);
                    Action::"Reopen Selected",
                  Action::"Reopen All":
                        TimeSheetApprovalMgt.ReopenApproved(TimeSheetLine);
                    Action::"Reject Selected",
                  Action::"Reject All":
                        TimeSheetApprovalMgt.Reject(TimeSheetLine);
                end;
            until TimeSheetLine.NEXT() = 0;
        CurrPage.UPDATE(false);
    end;

    procedure NS_Approve();
    var
        "Action": Option "Approve Selected","Approve All","Reopen Selected","Reopen All","Reject Selected","Reject All";
        ActionType: Option Approve,Reopen,Reject;
    begin
        case NS_ShowDialog(ActionType::Approve) of
            1:
                NS_Process(Action::"Approve All");
            2:
                NS_Process(Action::"Approve Selected");
        end;
    end;

    procedure NS_Reopen();
    var
        ActionType: Option Approve,Reopen,Reject;
        "Action": Option "Approve Selected","Approve All","Reopen Selected","Reopen All","Reject Selected","Reject All";
    begin
        case NS_ShowDialog(ActionType::Reopen) of
            1:
                NS_Process(Action::"Reopen All");
            2:
                NS_Process(Action::"Reopen Selected");
        end;
    end;

    procedure NS_Reject();
    var
        ActionType: Option Approve,Reopen,Reject;
        "Action": Option "Approve Selected","Approve All","Reopen Selected","Reopen All","Reject Selected","Reject All";
    begin
        case NS_ShowDialog(ActionType::Reject) of
            1:
                NS_Process(Action::"Reject All");
            2:
                NS_Process(Action::"Reject Selected");
        end;
    end;

    procedure NS_GetDialogText(ActionType: Option Approve,Reopen,Reject): Text[100];
    var
        TimeSheetLine: Record "Time Sheet Line";
    begin
        NS_FilterAllLines(TimeSheetLine, ActionType);
        exit(TimeSheetApprovalMgt.GetManagerTimeSheetDialogText(ActionType, TimeSheetLine.COUNT));
    end;

    procedure NS_FilterAllLines(var TimeSheetLine: Record "Time Sheet Line"; ActionType: Option Approve,Reopen,Reject);
    var
        MarkCount: Integer;
    begin
        TimeSheetLine.COPYFILTERS(Rec);
        TimeSheetLine.FILTERGROUP(2);
        TimeSheetLine.SETFILTER(Type, '<>%1', TimeSheetLine.Type::" ");
        TimeSheetLine.FILTERGROUP(0);
        CurrPosition := GETPOSITION;
        MarkCount := 0;
        if FINDSET() then
            repeat
                if MARK then begin
                    MarkCount += 1;
                    if TimeSheetLine.FINDSET() then
                        repeat
                            if TimeSheetLine."Time Sheet No." = "Time Sheet No." then
                                if TimeSheetLine."Line No." = "Line No." then
                                    TimeSheetLine.MARK(true);
                        until TimeSheetLine.NEXT() = 0;
                end;
            until NEXT() = 0;
        if MarkCount > 0 then
            TimeSheetLine.MARKEDONLY(true);
        SETPOSITION(CurrPosition);
        case ActionType of
            ActionType::Approve,
          ActionType::Reject:
                TimeSheetLine.SETRANGE(Status, TimeSheetLine.Status::Submitted);
            ActionType::Reopen:
                TimeSheetLine.SETRANGE(Status, TimeSheetLine.Status::Approved);
        end;
    end;

    local procedure NS_ShowDialog(ActionType: Option Approve,Reopen,Reject): Integer;
    begin
        exit(STRMENU(NS_GetDialogText(ActionType), 1, TimeSheetApprovalMgt.GetManagerTimeSheetDialogInstruction(ActionType)));
    end;

    procedure NS_LookupResourceName();
    begin
        ResourceName := '';
        if Resource.GET("NS_Resource No.") then
            ResourceName := Resource.Name;
    end;

    procedure NS_CheckIfPosted(FieldName: Text[100]);
    begin
        if Posted then
            ERROR(Text004, FieldName);
    end;
}

