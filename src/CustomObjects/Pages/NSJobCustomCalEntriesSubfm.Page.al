page 14021193 "NS_Job Custom CalEntriesSubfm"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job Custom Cal. Entries Subfm';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = Date;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(CurrentSourceType; CurrentSourceType)
                {
                    ApplicationArea = All;
                    Caption = 'Current Source Type';
                    OptionCaption = 'Company,Customer,Vendor,Location,Shipping Agent';
                    ToolTip = 'Specifies the Current Source Type';
                    Visible = false;
                }
                field(CurrentSourceCode; CurrentSourceCode)
                {
                    ApplicationArea = All;
                    Caption = 'Current Source Code';
                    ToolTip = 'Specifies the Current Source Code';
                    Visible = false;
                }
                field(CurrentAdditionalSourceCode; CurrentAdditionalSourceCode)
                {
                    ApplicationArea = All;
                    Caption = 'Current Additional Source Code';
                    ToolTip = 'Specifies the Current Additional Source Code';
                    Visible = false;
                }
                field(CurrentJobCalendarCode; CurrentJobCalendarCode)
                {
                    ApplicationArea = All;
                    Caption = 'Current Job Calendar Code';
                    Editable = false;
                    ToolTip = 'Specifies the Current Job Calendar Code';
                    Visible = false;
                }
                field("Period Start"; Rec."Period Start")
                {
                    ApplicationArea = All;
                    Caption = 'Date';
                    Editable = false;
                    ToolTip = 'Specifies the Date';
                }
                field("Period Name"; Rec."Period Name")
                {
                    ApplicationArea = All;
                    Caption = 'Day';
                    Editable = false;
                    ToolTip = 'Specifies the Day';
                }
                field(WeekNo; WeekNo)
                {
                    ApplicationArea = All;
                    Caption = 'Week No.';
                    Editable = false;
                    ToolTip = 'Specifies the Week No.';
                    Visible = false;
                }
                field(Nonworking; Nonworking)
                {
                    ApplicationArea = All;
                    Caption = 'Nonworking';
                    Editable = true;
                    ToolTip = 'Specifies the Nonworking';

                    trigger OnValidate();
                    begin
                        NS_UpdateJobCalendarChanges;
                    end;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Specifies the Description';

                    trigger OnValidate();
                    begin
                        NS_UpdateJobCalendarChanges;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        Nonworking :=
          JobCalendarMgmt.NS_CheckJobCustomDateStatus(
            CurrentSourceType, CurrentSourceCode, CurrentAdditionalSourceCode, CurrentJobCalendarCode, "Period Start", Description);
        WeekNo := DATE2DWY("Period Start", 2);
        NS_CurrentJobCalendarCodeOnFormat;
        NS_PeriodStartOnFormat;
        NS_PeriodNameOnFormat;
        NS_DescriptionOnFormat;
    end;

    trigger OnFindRecord(Which: Text): Boolean;
    begin
        exit(PeriodFormMgt.FindDate(Which, Rec, ItemPeriodLength));
    end;

    trigger OnNextRecord(Steps: Integer): Integer;
    begin
        exit(PeriodFormMgt.NextDate(Steps, Rec, ItemPeriodLength));
    end;

    trigger OnOpenPage();
    begin
        RESET;
        NS_OnActivateForm;
    end;

    var
        Item: Record Item;
        JobCalendarChange: Record "NS_Job Calendar Change";
        JobCustomCalendarChange: Record "NS_Job Custom Calendar Change";
        CurrentJobCalendarCode: Code[10];
        CurrentSourceCode: Code[20];
        Description: Text[50];
        ItemPeriodLength: Option Day,Week,Month,Quarter,Year,Period;
        CurrentSourceType: Option Company,Customer,Vendor,Location,"Shipping Agent";
        CurrentAdditionalSourceCode: Code[20];
        Nonworking: Boolean;
        JobCalendarMgmt: Codeunit "NS_Job Calendar Management";
        PeriodFormMgt: Codeunit PeriodFormManagement;
        WeekNo: Integer;

    procedure NS_SetJobCalendarCode(SourceType: Option Company,Customer,Vendor,Location,"Shipping Agent"; SourceCode: Code[20]; AdditionalSourceCode: Code[20]; JobCalendarCode: Code[10]);
    begin
        CurrentSourceType := SourceType;
        CurrentSourceCode := SourceCode;
        CurrentAdditionalSourceCode := AdditionalSourceCode;
        CurrentJobCalendarCode := JobCalendarCode;

        CurrPage.UPDATE;
    end;

    procedure NS_UpdateJobCalendarChanges();
    begin
        JobCustomCalendarChange.RESET();
        JobCustomCalendarChange.SETRANGE("NS_Source Type", CurrentSourceType);
        JobCustomCalendarChange.SETRANGE("NS_Source Code", CurrentSourceCode);
        JobCustomCalendarChange.SETRANGE("NS_Job Calendar Code", CurrentJobCalendarCode);
        JobCustomCalendarChange.SETRANGE(NS_Date, "Period Start");
        if JobCustomCalendarChange.FINDFIRST() then
            JobCustomCalendarChange.DELETE();

        if not NS_IsInJobCalendar then begin
            JobCustomCalendarChange.INIT();
            JobCustomCalendarChange."NS_Source Type" := CurrentSourceType;
            JobCustomCalendarChange."NS_Source Code" := CurrentSourceCode;
            JobCustomCalendarChange."NS_Additional Source Code" := CurrentAdditionalSourceCode;
            JobCustomCalendarChange."NS_Job Calendar Code" := CurrentJobCalendarCode;
            JobCustomCalendarChange.NS_Date := "Period Start";
            JobCustomCalendarChange.NS_Day := "Period No.";
            JobCustomCalendarChange.NS_Description := Description;
            JobCustomCalendarChange.NS_Nonworking := Nonworking;
            JobCustomCalendarChange.INSERT();
        end;
    end;

    procedure NS_IsInJobCalendar(): Boolean;
    var
        JobCalendarChange_Loc: Record "NS_Job Calendar Change";
    begin
        JobCalendarChange_Loc.SETRANGE("NS_Job Calendar Code", CurrentJobCalendarCode);
        JobCalendarChange_Loc.SETRANGE(NS_Date, "Period Start");
        JobCalendarChange_Loc.SETRANGE(NS_Day, "Period No.");
        JobCalendarChange_Loc.SETRANGE("NS_Recurring System", JobCalendarChange_Loc."NS_Recurring System"::" ");
        if JobCalendarChange_Loc.FINDFIRST() then
            exit(JobCalendarChange_Loc.NS_Nonworking = Nonworking);

        JobCalendarChange_Loc.SETRANGE(NS_Date, 0D);
        JobCalendarChange_Loc.SETRANGE(NS_Day, "Period No.");
        JobCalendarChange_Loc.SETRANGE("NS_Recurring System", JobCalendarChange_Loc."NS_Recurring System"::"Weekly Recurring");
        if JobCalendarChange_Loc.FINDFIRST() then
            exit(JobCalendarChange_Loc.NS_Nonworking = Nonworking);

        JobCalendarChange_Loc.SETRANGE(NS_Date);
        JobCalendarChange_Loc.SETRANGE(NS_Day, JobCalendarChange_Loc.NS_Day::" ");
        JobCalendarChange_Loc.SETRANGE("NS_Recurring System", JobCalendarChange_Loc."NS_Recurring System"::"Annual Recurring");
        if JobCalendarChange_Loc.FINDSET() then
            repeat
                if (DATE2DMY(JobCalendarChange_Loc.NS_Date, 2) = DATE2DMY("Period Start", 2)) and
                   (DATE2DMY(JobCalendarChange_Loc.NS_Date, 1) = DATE2DMY("Period Start", 1))
                then
                    exit(JobCalendarChange_Loc.NS_Nonworking = Nonworking);
            until JobCalendarChange_Loc.NEXT() = 0;

        exit(not Nonworking);
    end;

    procedure NS_GetCurrentDate(): Date;
    begin
        exit("Period Start");
    end;

    local procedure NS_OnActivateForm();
    begin
        NS_SetJobCalendarCode(CurrentSourceType, CurrentSourceCode, CurrentAdditionalSourceCode, CurrentJobCalendarCode);
    end;

    local procedure NS_CurrentJobCalendarCodeOnFormat();
    begin
        if Nonworking then;
    end;

    local procedure NS_PeriodStartOnFormat();
    begin
        if Nonworking then;
    end;

    local procedure NS_PeriodNameOnFormat();
    begin
        if Nonworking then;
    end;

    local procedure NS_DescriptionOnFormat();
    begin
        if Nonworking then;
    end;
}

