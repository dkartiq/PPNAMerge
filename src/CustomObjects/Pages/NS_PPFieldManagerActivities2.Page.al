page 14021253 "NS_PPFieldManagerActivities2"
{
    //PE-211.AS.1.0 18DEC2023 Created New Page
    Caption = 'Activities ProjectPro';
    PageType = CardPart;
    SourceTable = "NS_ProjectPro Job Cue";
    layout
    {
        area(Content)
        {
            cuegroup("Job Log")
            {
                Caption = 'Job User Tasks';
                // field(RFQ; Rec.NS_CalcCountSeq8())
                field(RFQ; Rec.NS_RFQ_FM)
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    Caption = 'RFI';
                    CaptionClass = '50993,0,0';
                    ToolTip = 'RFI';
                    trigger OnDrillDown()

                    begin
                        NSCode := '';
                        NSNumberFilter.Reset();
                        NSNumberFilter.SetRange("Document No.", 'USER');
                        NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
                        NSNumberFilter.SetRange("NS_User Task Cue Sequence", 1);
                        IF NSNumberFilter.FindFirst() then
                            NSCode := NSNumberFilter."No.";
                        NS_UserTask.Reset();
                        NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
                        NS_UserTask.SetFilter("NS_User Task Category", NSCode);
                        NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_Date);
                        Page.Run(Page::"NSUserTaskList", NS_UserTask);
                    end;
                }
                // field(RFI; Rec.NS_CalcCountSeq9())
                field(RFI; Rec.NS_RFI_FM)
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    Caption = 'RFQ';
                    CaptionClass = '50993,1,0';
                    ToolTip = 'RFQ';
                    trigger OnDrillDown()
                    begin
                        NSCode := '';
                        NSNumberFilter.Reset();
                        NSNumberFilter.SetRange("Document No.", 'USER');
                        NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
                        NSNumberFilter.SetRange("NS_User Task Cue Sequence", 2);
                        IF NSNumberFilter.FindFirst() then
                            NSCode := NSNumberFilter."No.";
                        NS_UserTask.Reset();
                        NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
                        NS_UserTask.SetFilter("NS_User Task Category", NSCode);
                        NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_Date);
                        Page.Run(Page::"NSUserTaskList", NS_UserTask);
                    end;
                }
                // field(Submittal; Rec.NS_CalcCountSeq10())
                field(Submittal; Rec.NS_Submittal_FM)
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    Caption = 'SUBMITTAL';
                    CaptionClass = '50993,2,0';
                    ToolTip = 'SUBMITTAL';
                    trigger OnDrillDown()
                    begin
                        NSCode := '';
                        NSNumberFilter.Reset();
                        NSNumberFilter.SetRange("Document No.", 'USER');
                        NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
                        NSNumberFilter.SetRange("NS_User Task Cue Sequence", 3);
                        IF NSNumberFilter.FindFirst() then
                            NSCode := NSNumberFilter."No.";
                        NS_UserTask.Reset();
                        NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
                        NS_UserTask.SetRange("NS_User Task Category", NSCode);
                        NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_Date);
                        Page.Run(Page::"NSUserTaskList", NS_UserTask);
                    end;

                }
                // field(Transmittal; Rec.NS_CalcCountSeq11())
                field(Transmittal; Rec.NS_Transmittal_FM)
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    Caption = 'TRANSMITTAL';
                    CaptionClass = '50993,3,0';
                    ToolTip = 'TRANSMITTAL';
                    trigger OnDrillDown()
                    begin
                        NSCode := '';
                        NSNumberFilter.Reset();
                        NSNumberFilter.SetRange("Document No.", 'USER');
                        NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
                        NSNumberFilter.SetRange("NS_User Task Cue Sequence", 4);
                        IF NSNumberFilter.FindFirst() then
                            NSCode := NSNumberFilter."No.";
                        NS_UserTask.Reset();
                        NS_UserTask.Reset();
                        NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
                        NS_UserTask.Setrange("NS_User Task Category", NSCode);
                        NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_Date);
                        Page.Run(Page::"NSUserTaskList", NS_UserTask);
                    end;
                }
                // field(Subcontract; Rec.NS_CalcCountSeq12())
                field(Subcontract; Rec.NS_Subcontract_FM)
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    Caption = 'SUBCONTRACT';
                    CaptionClass = '50993,4,0';
                    ToolTip = 'SUBCONTRACT';
                    trigger OnDrillDown()
                    begin
                        NSCode := '';
                        NSNumberFilter.Reset();
                        NSNumberFilter.SetRange("Document No.", 'USER');
                        NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
                        NSNumberFilter.SetRange("NS_User Task Cue Sequence", 5);
                        IF NSNumberFilter.FindFirst() then
                            NSCode := NSNumberFilter."No.";
                        NS_UserTask.Reset();
                        NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
                        NS_UserTask.SetRange("NS_User Task Category", NSCode);
                        NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_Date);
                        Page.Run(Page::NSUserTaskList, NS_UserTask);
                    end;
                }
                // field(SAFETY; Rec.NS_CalcCountSeq13())
                field(SAFETY; Rec.NS_SAFETY_FM)
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    Caption = 'SAFETY';
                    CaptionClass = '50993,5,0';
                    Tooltip = 'SAFETY';
                    trigger OnDrillDown()
                    begin
                        NSCode := '';
                        NSNumberFilter.Reset();
                        NSNumberFilter.SetRange("Document No.", 'USER');
                        NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
                        NSNumberFilter.SetRange("NS_User Task Cue Sequence", 0);
                        IF NSNumberFilter.FindFirst() then
                            NSCode := NSNumberFilter."No.";
                        NSCode2 := '';
                        NSNumberFilter.Reset();
                        NSNumberFilter.SetRange("Document No.", 'USER');
                        NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
                        NSNumberFilter.SetRange("NS_User Task Cue Sequence", 6);
                        IF NSNumberFilter.FindFirst() then
                            NSCode2 := NSNumberFilter."No.";
                        NS_UserTask.Reset();
                        NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
                        NS_UserTask.SetFilter("NS_User Task Category", '%1|%2', NSCode, NSCode2);
                        NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_Date);
                        Page.Run(Page::NSUserTaskList, NS_UserTask);
                    end;
                }
                // field(Tasks; Rec.NS_CalcCountSeq14())
                field(Tasks; Rec.NS_Tasks_FM)
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    Caption = 'TASKS';
                    CaptionClass = '50993,6,0';
                    Tooltip = 'TASKS';
                    trigger OnDrillDown()
                    begin
                        NSCode := '';
                        NSNumberFilter.Reset();
                        NSNumberFilter.SetRange("Document No.", 'USER');
                        NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
                        NSNumberFilter.SetRange("NS_User Task Cue Sequence", 0);
                        IF NSNumberFilter.FindFirst() then
                            NSCode := NSNumberFilter."No.";
                        NSCode2 := '';
                        NSNumberFilter.Reset();
                        NSNumberFilter.SetRange("Document No.", 'USER');
                        NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
                        NSNumberFilter.SetRange("NS_User Task Cue Sequence", 7);
                        IF NSNumberFilter.FindFirst() then
                            NSCode2 := NSNumberFilter."No.";
                        NS_UserTask.Reset();
                        NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
                        NS_UserTask.SetFilter("NS_User Task Category", '%1|%2', NSCode, NSCode2);
                        NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_Date);
                        Page.Run(Page::NSUserTaskList, NS_UserTask);
                    end;
                }
            }

            //PRJCTPR-270.HS.1.0 25Jan2024 Start
            cuegroup("NS_Due")
            {
                ShowCaption = false;
                field("NS_Due in 3 days"; "NS_Due_in 3 days")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the value of the Due in 3 Days field.';
                    Caption = 'Due in 3 days';
                    StyleExpr = NS_Red;
                    trigger OnDrillDown()
                    var
                        NS_UserTaskL: Record "User Task";
                    begin
                        NS_UserTaskL.Reset();
                        NS_UserTaskL.SetFilter("NS_Due Date", '%1..%2', Today, CalcDate('<2D>'));
                        Page.Run(Page::NSUserTaskList, NS_UserTaskL);
                    end;
                }
                field("NS_Due in 7 days"; "NS_Due_in 7 days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Due in 7 Days field.';
                    Caption = 'Due in 7 Days';
                    StyleExpr = NS_Yellow;
                    trigger OnDrillDown()
                    var
                        NS_UserTaskL: Record "User Task";
                    begin
                        NS_UserTaskL.Reset();
                        NS_UserTaskL.SetFilter("NS_Due Date", '%1..%2', CalcDate('<3D>', Today), CalcDate('<7D>'));
                        Page.Run(Page::NSUserTaskList, NS_UserTaskL);
                    end;
                }
                field("NS_Due in More than 7 days"; "NS_Due_in More than 7 days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Due in more than 7 Days field.';
                    Caption = 'Due in more than 7 days';
                    StyleExpr = NS_Green;
                    trigger OnDrillDown()
                    var
                        NS_UserTaskL: Record "User Task";
                    begin
                        NS_UserTaskL.Reset();
                        NS_UserTaskL.SetFilter("NS_Due Date", '>%1', CalcDate('<7D>', Today));
                        Page.Run(Page::NSUserTaskList, NS_UserTaskL);
                    end;
                }
            }
            //PRJCTPR-270.HS.1.0 25Jan2024 End

            cuegroup("Job Log3")
            {
                Caption = 'Over Due Job User Tasks';
                // field(RFI11; Rec.NS_OverJobCount8())
                field(RFI11; Rec.NS_RFI11_FM)
                {
                    ApplicationArea = all;
                    CaptionClass = '50993,0,0';
                    DrillDown = true;
                    ToolTip = 'RFI';
                    trigger OnDrillDown()
                    begin
                        NSCode := '';
                        NSNumberFilter.Reset();
                        NSNumberFilter.SetRange("Document No.", 'USER');
                        NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
                        NSNumberFilter.SetRange("NS_User Task Cue Sequence", 1);
                        IF NSNumberFilter.FindFirst() then
                            NSCode := NSNumberFilter."No.";
                        NS_UserTask.Reset();
                        NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
                        NS_UserTask.SetRange("NS_User Task Category", NSCode);
                        NS_UserTask.SetFilter("NS_Due Date", '%1..%2', 0D, CalcDate('<-1D>'), Today);
                        Page.Run(Page::NSUserTaskList, NS_UserTask);
                    end;
                }

                // field(RFQ1; Rec.NS_OverJobCount9())
                field(RFQ1; Rec.NS_RFQ1_FM)
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    Caption = 'RFQ';
                    CaptionClass = '50993,1,0';
                    ToolTip = 'RFQ';
                    trigger OnDrillDown()

                    begin

                        NSCode := '';
                        NSNumberFilter.Reset();
                        NSNumberFilter.SetRange("Document No.", 'USER');
                        NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
                        NSNumberFilter.SetRange("NS_User Task Cue Sequence", 2);
                        IF NSNumberFilter.FindFirst() then
                            NSCode := NSNumberFilter."No.";
                        NS_UserTask.Reset();
                        NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
                        NS_UserTask.SetFilter("NS_User Task Category", '%1', NSCode);
                        NS_UserTask.SetFilter("NS_Due Date", '%1..%2', 0D, CalcDate('<-1D>'), Today);
                        Page.Run(Page::NSUserTaskList, NS_UserTask);
                    end;
                }
                // field(SUBMITTAL11; Rec.NS_OverJobCount10())
                field(SUBMITTAL11; Rec.NS_SUBMITTAL11_FM)
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    Caption = 'SUBMITTAL';
                    CaptionClass = '50993,2,0';
                    ToolTip = 'SUBMITTAL';
                    trigger OnDrillDown()
                    begin
                        NSCode := '';
                        NSNumberFilter.Reset();
                        NSNumberFilter.SetRange("Document No.", 'USER');
                        NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
                        NSNumberFilter.SetRange("NS_User Task Cue Sequence", 3);
                        IF NSNumberFilter.FindFirst() then
                            NSCode := NSNumberFilter."No.";
                        NS_UserTask.Reset();
                        NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
                        NS_UserTask.SetRange("NS_User Task Category", NSCode);
                        NS_UserTask.SetFilter("NS_Due Date", '%1..%2', 0D, CalcDate('<-1D>'), Today);
                        Page.Run(Page::NSUserTaskList, NS_UserTask);
                    end;
                }
                // field(TRANSMITTAL11; Rec.NS_OverJobCount11())
                field(TRANSMITTAL11; Rec.NS_TRANSMITTAL11_FM)
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    Caption = 'TRANSMITTAL';
                    CaptionClass = '50993,3,0';
                    ToolTip = 'TRANSMITTAL';
                    trigger OnDrillDown()
                    begin
                        NSCode := '';
                        NSNumberFilter.Reset();
                        NSNumberFilter.SetRange("Document No.", 'USER');
                        NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
                        NSNumberFilter.SetRange("NS_User Task Cue Sequence", 4);
                        IF NSNumberFilter.FindFirst() then
                            NSCode := NSNumberFilter."No.";
                        NS_UserTask.Reset();
                        NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
                        NS_UserTask.SetRange("NS_User Task Category", NSCode);
                        NS_UserTask.SetFilter("NS_Due Date", '%1..%2', 0D, CalcDate('<-1D>'), Today);
                        Page.Run(Page::NSUserTaskList, NS_UserTask);
                    end;

                }
                // field(SUBCONTRACT1; Rec.NS_OverJobCount12())
                field(SUBCONTRACT1; Rec.NS_SUBCONTRACT1_FM)
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    Caption = 'SUBCONTRACT';
                    CaptionClass = '50993,4,0';
                    ToolTip = 'SUBCONTRACT';
                    trigger OnDrillDown()
                    begin
                        NSCode := '';
                        NSNumberFilter.Reset();
                        NSNumberFilter.SetRange("Document No.", 'USER');
                        NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
                        NSNumberFilter.SetRange("NS_User Task Cue Sequence", 5);
                        IF NSNumberFilter.FindFirst() then
                            NSCode := NSNumberFilter."No.";
                        NS_UserTask.Reset();
                        NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
                        NS_UserTask.SetRange("NS_User Task Category", NSCode);
                        NS_UserTask.SetFilter("NS_Due Date", '%1..%2', 0D, CalcDate('<-1D>'), Today);
                        Page.Run(Page::NSUserTaskList, NS_UserTask);
                    end;
                }
                // field(Safety1; Rec.NS_OverJobCount13())
                field(Safety1; Rec.NS_Safety1_FM)
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    Caption = 'SAFETY';
                    CaptionClass = '50993,5,0';
                    ToolTip = 'SAFETY';
                    trigger OnDrillDown()
                    begin
                        NSCode := '';
                        NSNumberFilter.Reset();
                        NSNumberFilter.SetRange("Document No.", 'USER');
                        NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
                        NSNumberFilter.SetRange("NS_User Task Cue Sequence", 6);
                        IF NSNumberFilter.FindFirst() then
                            NSCode := NSNumberFilter."No.";
                        NS_UserTask.Reset();
                        NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
                        NS_UserTask.SetRange("NS_User Task Category", NSCode);
                        NS_UserTask.SetFilter("NS_Due Date", '%1..%2', 0D, CalcDate('<-1D>'), Today);
                        Page.Run(Page::NSUserTaskList, NS_UserTask);
                    end;
                }
                // field(TASKS11; Rec.NS_OverJobCount14())
                field(TASKS11; Rec.NS_TASKS11_FM)
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    Caption = 'TASKS';
                    CaptionClass = '50993,6,0';
                    Tooltip = 'TASKS';
                    trigger OnDrillDown()
                    begin
                        NSCode := '';
                        NSNumberFilter.Reset();
                        NSNumberFilter.SetRange("Document No.", 'USER');
                        NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
                        NSNumberFilter.SetRange("NS_User Task Cue Sequence", 0);
                        IF NSNumberFilter.FindFirst() then
                            NSCode := NSNumberFilter."No.";
                        NSCode2 := '';
                        NSNumberFilter.Reset();
                        NSNumberFilter.SetRange("Document No.", 'USER');
                        NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
                        NSNumberFilter.SetRange("NS_User Task Cue Sequence", 7);
                        IF NSNumberFilter.FindFirst() then
                            NSCode2 := NSNumberFilter."No.";
                        NS_UserTask.Reset();
                        NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
                        NS_UserTask.SetFilter("NS_User Task Category", '%1|%2', NSCode, NSCode2);
                        NS_UserTask.SetFilter("NS_Due Date", '%1..%2', 0D, CalcDate('<-1D>'), Today);
                        Page.Run(Page::NSUserTaskList, NS_UserTask);
                    end;
                }
            }
            //PRJCTPR-270.HS.1.0 25Jan2024 Start //PE-211.AS.10.0 START
            cuegroup("NS_OverDue")
            {
                ShowCaption = false;

                field("NS_Total Over Due"; "NS_Total_Over Due")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Over Due field.';
                    Caption = 'Total Over Due';
                    StyleExpr = NS_TotalStyle;
                    trigger OnDrillDown()
                    var
                        NSCodeFilter: Text[200];
                        NSNumberFilterL: Record NSNumberFilter;
                        NS_UserTaskL: Record "User Task";
                    begin
                        NSCode := '';
                        NSNumberFilterL.Reset();
                        NSNumberFilterL.SetRange("Document No.", 'USER');
                        NSNumberFilterL.SetRange(Type, NSNumberFilterL.Type::"NS_User Task Category");
                        IF NSNumberFilterL.Findset() then
                            repeat
                                NSCodeFilter += NSNumberFilterL."No." + '|';
                            Until NSNumberFilterL.Next() = 0;
                        NSCodeFilter := CopyStr(NSCodeFilter, 1, StrLen(NSCodeFilter) - 1);

                        NS_UserTaskL.Reset();
                        NS_UserTaskL.SetFilter("Percent Complete", '<>%1', 100);
                        NS_UserTaskL.SetFilter("NS_User Task Category", NSCodeFilter);
                        NS_UserTaskL.SetFilter("NS_Due Date", '%1..%2', 0D, CalcDate('<-1D>'), Today);
                        Page.Run(Page::NSUserTaskList, NS_UserTaskL);
                    end;
                }
            }
            //PRJCTPR-270.HS.1.0 25Jan2024 End //PE-211.AS.10.0 END
        }
    }

    //PRJCTPR-270.HS.1.0 4Jan2024 Start
    trigger OnAfterGetRecord()
    var
        NS_UserTaskL: Record "User Task";
    begin
        Rec.NS_RFQ_FM := Rec.NS_CalcCountSeq8();
        Rec.NS_RFI_FM := Rec.NS_CalcCountSeq9();
        Rec.NS_Submittal_FM := Rec.NS_CalcCountSeq10();
        Rec.NS_Transmittal_FM := Rec.NS_CalcCountSeq11();
        Rec.NS_Subcontract_FM := Rec.NS_CalcCountSeq12();
        Rec.NS_SAFETY_FM := Rec.NS_CalcCountSeq13();
        Rec.NS_Tasks_FM := Rec.NS_CalcCountSeq14();
        Rec.NS_RFI11_FM := Rec.NS_OverJobCount8();
        Rec.NS_RFQ1_FM := Rec.NS_OverJobCount9();
        Rec.NS_SUBMITTAL11_FM := Rec.NS_OverJobCount10();
        Rec.NS_TRANSMITTAL11_FM := Rec.NS_OverJobCount11();
        Rec.NS_SUBCONTRACT1_FM := Rec.NS_OverJobCount12();
        Rec.NS_Safety1_FM := Rec.NS_OverJobCount13();
        Rec.NS_TASKS11_FM := Rec.NS_OverJobCount14();

        "NS_Due_in 3 days" := 0;
        NS_UserTaskL.Reset();
        NS_UserTaskL.SetFilter("NS_Due Date", '%1..%2', Today, CalcDate('<2D>'));
        if NS_UserTaskL.FindSet() then
            "NS_Due_in 3 days" := NS_UserTaskL.Count;
        if "NS_Due_in 3 days" > 0 then
            NS_Red := 'Unfavorable'
        else
            NS_Red := '';

        "NS_Due_in 7 days" := 0;
        NS_UserTaskL.Reset();
        NS_UserTaskL.SetFilter("NS_Due Date", '%1..%2', CalcDate('<3D>', Today), CalcDate('<7D>'));
        if NS_UserTaskL.FindSet() then
            "NS_Due_in 7 days" := NS_UserTaskL.Count;
        if "NS_Due_in 7 days" > 0 then
            NS_Yellow := 'Ambiguous'
        else
            NS_Yellow := '';

        "NS_Due_in More than 7 days" := 0;
        NS_UserTaskL.Reset();
        NS_UserTaskL.SetFilter("NS_Due Date", '>%1', CalcDate('<7D>', Today));
        if NS_UserTaskL.FindSet() then
            "NS_Due_in More than 7 days" := NS_UserTaskL.Count;
        if "NS_Due_in More than 7 days" > 0 then
            NS_Green := 'Favorable'
        else
            NS_Green := '';

        "NS_Total_Over Due" := 0;
        "NS_Total_Over Due" := Rec.NS_RFI11_FM +
        Rec.NS_RFQ1_FM +
        Rec.NS_SUBMITTAL11_FM +
        Rec.NS_TRANSMITTAL11_FM +
        Rec.NS_SUBCONTRACT1_FM +
        Rec.NS_Safety1_FM +
        Rec.NS_TASKS11_FM;

        if "NS_Total_Over Due" > 0 then
            NS_TotalStyle := 'Unfavorable'
        else
            NS_TotalStyle := '';
    end;
    //PRJCTPR-270.HS.1.0 4Jan2024 End

    trigger OnOpenPage();
    var
        NSConfPersonalizationMgt: Codeunit "Conf./Personalization Mgt.";
    begin
        NSConfPersonalizationMgt.RaiseOnOpenRoleCenterEvent();
        Rec.RESET();
        if not Rec.GET() then begin
            Rec.INIT();
            Rec.INSERT();
        end;
        if NS_APOSetup.Get() then
            if Format(NS_APOSetup."NS_User task Alert No. of Days") <> '' then
                NS_Date := CALCDATE('<+' + format(NS_APOSetup."NS_User task Alert No. of Days") + '>', Today)
            else
                NS_Date := WorkDate();
        Rec.SETFILTER("NS_Date Filter", '%1..%2', 19000101D, CALCDATE('<CM>'));
        Rec.SETFILTER("NS_Date Filter2", '<%1', WORKDATE);
        Rec.SetFilter("NS_Due Date Filter", '%1..%2', Today, NS_Date);
        Rec.SetFilter("NS_Due Date Filter2", '%1..%2', 0D, Today);
        JobsSetup.GET();
    end;

    var

        NS_UserTask: Record "User Task";
        NS_APOSetup: Record NS_APOSetup;
        NS_Date: Date;
        JobsSetup: Record "Jobs Setup";
        NSNumberFilter: Record NSNumberFilter;
        NSCode: Code[20];
        NSCode2: Code[20];

        //PRJCTPR-270.HS.1.0 25Jan2024 Start
        NS_Red: Text;
        NS_Yellow: Text;
        NS_Green: Text;
        NS_TotalStyle: Text;
        "NS_Due_in 3 days": Integer;
        "NS_Due_in 7 days": Integer;
        "NS_Due_in More than 7 days": Integer;
        "NS_Total_Over Due": Integer;
    //PRJCTPR-270.HS.1.0 25Jan2024  End
}