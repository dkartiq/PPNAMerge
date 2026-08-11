page 14021192 "NS_Job CalendarEntriesSubform"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job Calendar Entries Subform';
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
                field(CurrentCalendarCode; CurrentCalendarCode)
                {
                    ApplicationArea = All;
                    Caption = 'Job Calendar Code';
                    Editable = false;
                    ToolTip = 'Specifies the Job Calendar Code';
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
                        NS_UpdateJobCalendarChanges();
                    end;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Specifies the Description';

                    trigger OnValidate();
                    begin
                        NS_UpdateJobCalendarChanges();
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
        Nonworking := JobCalendarMgmt.NS_CheckDateStatus(CurrentCalendarCode, "Period Start", Description);
        WeekNo := DATE2DWY("Period Start", 2);
        NS_CurrentCalendarCodeOnFormat();
        NS_PeriodStartOnFormat();
        NS_PeriodNameOnFormat();
        NS_DescriptionOnFormat();
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
        RESET();
        SETFILTER("Period Start", '>=%1', 00000101D);
        NS_OnActivateForm();
    end;

    var
        JobCalendarChange: Record "NS_Job Calendar Change";
        PeriodFormMgt: Codeunit PeriodFormManagement;
        JobCalendarMgmt: Codeunit "NS_Job Calendar Management";

        ItemPeriodLength: Option Day,Week,Month,Quarter,Year,Period;
        Nonworking: Boolean;
        Description: Text[50];
        CurrentCalendarCode: Code[10];

        WeekNo: Integer;

    procedure NS_SetJobCalendarCode(CalendarCode: Code[10]);
    begin
        CurrentCalendarCode := CalendarCode;
        CurrPage.UPDATE();
    end;

    procedure NS_UpdateJobCalendarChanges();
    begin
        JobCalendarChange.RESET();
        JobCalendarChange.SETRANGE("NS_Job Calendar Code", CurrentCalendarCode);
        JobCalendarChange.SETRANGE(NS_Date, "Period Start");
        if JobCalendarChange.FINDFIRST() then
            JobCalendarChange.DELETE();
        JobCalendarChange.INIT();
        JobCalendarChange."NS_Job Calendar Code" := CurrentCalendarCode;
        JobCalendarChange.NS_Date := "Period Start";
        JobCalendarChange.NS_Description := Description;
        JobCalendarChange.NS_Nonworking := Nonworking;
        JobCalendarChange.NS_Day := "Period No.";
        JobCalendarChange.INSERT();
    end;

    local procedure NS_OnActivateForm();
    begin
        NS_SetJobCalendarCode(CurrentCalendarCode);
    end;

    local procedure NS_CurrentCalendarCodeOnFormat();
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

