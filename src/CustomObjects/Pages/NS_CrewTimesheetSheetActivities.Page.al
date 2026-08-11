page 14021255 "NS_CreTimesSheetCues"
{
    Caption = 'Crew TimeSheet';
    PageType = CardPart;
    SourceTable = "NS_ProjectPro Job Cue";
    //PE-211.AS.2.0 Created New Page
    layout
    {
        area(content)
        {

            cuegroup("NS_crewTimeSheet")
            {
                Caption = ' ';
                Visible = true;
                field(OpenTimeSheets; OpenTimeSheets)
                {
                    ApplicationArea = All;
                    Caption = 'Open TimeSheets';
                    DrillDown = true;
                    trigger OnDrillDown();
                    VAR
                        NS_TimeSheetLineCustomRec: Record NS_TimeSheetLineCustom;
                    begin
                        NS_TimeSheetLineCustomRec.Reset();
                        NS_TimeSheetLineCustomRec.SetRange(NS_Status, NS_TimeSheetLineCustomRec.NS_Status::Open);
                        NS_TimeSheetLineCustomRec.SetRange("NS_Field Manager", USERID());
                        PAGE.RUN(PAGE::"NS_CrewTimeSheetRoleCenter", NS_TimeSheetLineCustomRec);
                    end;
                }
            }

            cuegroup("NS_crewTimeSheet2")
            {
                Caption = ' ';
                Visible = true;
                field(SubMittedTimeSheets; SubMittedTimeSheets)
                {
                    ApplicationArea = All;
                    Caption = 'Submitted Time Sheets';
                    DrillDown = true;
                    trigger OnDrillDown();
                    var
                        NS_TimeSheetLineCustomRec: Record NS_TimeSheetLineCustom;
                    begin
                        NS_TimeSheetLineCustomRec.Reset();
                        NS_TimeSheetLineCustomRec.SetRange(NS_Status, NS_TimeSheetLineCustomRec.NS_Status::Submitted);
                        NS_TimeSheetLineCustomRec.SetRange("NS_Field Manager", USERID());
                        PAGE.RUN(PAGE::"NS_CrewTimeSheetRoleCenter", NS_TimeSheetLineCustomRec);
                    end;
                }
                field(RejectedTimeSheets; RejectedTimeSheets)
                {
                    ApplicationArea = All;
                    Caption = 'Rejected Time Sheets';
                    DrillDown = true;
                    trigger OnDrillDown();
                    var
                        NS_TimeSheetLineCustomRec: Record NS_TimeSheetLineCustom;
                    begin
                        NS_TimeSheetLineCustomRec.Reset();
                        NS_TimeSheetLineCustomRec.SetRange(NS_Status, NS_TimeSheetLineCustomRec.NS_Status::Rejected);
                        NS_TimeSheetLineCustomRec.SetRange("NS_Field Manager", USERID());
                        PAGE.RUN(PAGE::"NS_CrewTimeSheetRoleCenter", NS_TimeSheetLineCustomRec);
                    end;
                }
                field(ApproovedTimeSheets; ApproovedTimeSheets)
                {
                    ApplicationArea = All;
                    Caption = 'Approved Time Sheets';
                    DrillDown = true;
                    trigger OnDrillDown();
                    var
                        NS_TimeSheetLineCustomRec: Record NS_TimeSheetLineCustom;
                    begin
                        NS_TimeSheetLineCustomRec.Reset();
                        NS_TimeSheetLineCustomRec.SetRange(NS_Status, NS_TimeSheetLineCustomRec.NS_Status::Approved);
                        NS_TimeSheetLineCustomRec.SetRange("NS_Field Manager", USERID());
                        PAGE.RUN(PAGE::"NS_CrewTimeSheetRoleCenter", NS_TimeSheetLineCustomRec);
                    end;
                }
            }

        }


    }
    // }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        //Calculate open TimeSheets
        OpenTimeSheets := 0;
        NS_TimeSheetLineCustomRec1.RESET();
        NS_TimeSheetLineCustomRec1.SetRange("NS_Field Manager", USERID());
        if NS_TimeSheetLineCustomRec1.FIND('-') then
            repeat
                if NS_TimeSheetLineCustomRec1.NS_Status = NS_TimeSheetLineCustomRec1.NS_Status::Open then
                    OpenTimeSheets += 1;
            until NS_TimeSheetLineCustomRec1.NEXT() = 0;

        //Calculate SubMitted      
        SubMittedTimeSheets := 0;
        NS_TimeSheetLineCustomRec2.RESET();
        NS_TimeSheetLineCustomRec2.SetRange("NS_Field Manager", USERID());
        if NS_TimeSheetLineCustomRec2.FIND('-') then
            repeat
                if NS_TimeSheetLineCustomRec2.NS_Status = NS_TimeSheetLineCustomRec2.NS_Status::Submitted then
                    SubMittedTimeSheets += 1;
            until NS_TimeSheetLineCustomRec2.NEXT() = 0;

        //Calculate Rejected     
        RejectedTimeSheets := 0;
        NS_TimeSheetLineCustomRec3.RESET();
        NS_TimeSheetLineCustomRec3.SetRange("NS_Field Manager", USERID());
        if NS_TimeSheetLineCustomRec3.FIND('-') then
            repeat
                if NS_TimeSheetLineCustomRec3.NS_Status = NS_TimeSheetLineCustomRec3.NS_Status::Rejected then
                    RejectedTimeSheets += 1;
            until NS_TimeSheetLineCustomRec3.NEXT() = 0;

        //Calculate Approved   
        ApproovedTimeSheets := 0;
        NS_TimeSheetLineCustomRec4.RESET();
        NS_TimeSheetLineCustomRec4.SetRange("NS_Field Manager", USERID());
        if NS_TimeSheetLineCustomRec4.FIND('-') then
            repeat
                if NS_TimeSheetLineCustomRec4.NS_Status = NS_TimeSheetLineCustomRec4.NS_Status::Approved then
                    ApproovedTimeSheets += 1;
            until NS_TimeSheetLineCustomRec4.NEXT() = 0;
    end;

    trigger OnOpenPage();
    begin
        Rec.RESET();
        if not Rec.GET() then begin
            Rec.INIT();
            Rec.INSERT();
        end;

    end;

    var
        JobCalc: Record Job;
        OpenTimeSheets: Integer;
        NS_TimeSheetLineCustomRec1: Record NS_TimeSheetLineCustom;
        NS_TimeSheetLineCustomRec2: Record NS_TimeSheetLineCustom;

        NS_TimeSheetLineCustomRec3: Record NS_TimeSheetLineCustom;
        NS_TimeSheetLineCustomRec4: Record NS_TimeSheetLineCustom;

        SubMittedTimeSheets: Integer;
        RejectedTimeSheets: Integer;
        ApproovedTimeSheets: Integer;

}

