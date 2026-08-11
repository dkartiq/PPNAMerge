/// <summary>
/// Page NS_PPProjectManagerActivities (ID 14021317).
/// </summary>
page 14021317 "NS_PPProjectManagerActivities"
{
    Caption = 'Activities ProjectPro';
    PageType = CardPart;
    SourceTable = "NS_ProjectPro Job Cue";
    //PE-109.PS.1.0 07Jun2023 | Create New Page
    //PRJCTPR-270.HS.1.0 4Jan2023 | Added and Blocked Some Code
    //PRJCTPR-270.HS.1.0 25Jan2024 | Added some code

    layout
    {
        area(Content)
        {
            cuegroup("Job Log")
            {
                Caption = 'Job User Tasks';
                //field("Job Log1"; Rec."NS_Job log") //PE-185.NC.1.0 10Oct2023 Block
                // field("Job Log1"; Rec.NS_CalcCountSeq1()) //PE-185.NC.1.0 10Oct2023  //PRJCTPR-270.HS.1.0 4Jan2023 Block
                field("Job Log1"; Rec."NS_Job Log") //PRJCTPR-270.HS.1.0 4Jan2023 
                {
                    ApplicationArea = all;
                    Caption = 'Job Log';
                    CaptionClass = '50993,0,0';//PE-185.NC.1.0 10Oct2023
                    DrillDown = true;
                    ToolTip = 'Job Log';
                    trigger OnDrillDown()
                    begin
                        //PE-185.NC.1.0 10Oct2023 Start
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
                        NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_Date);
                        Page.Run(Page::NSUserTaskList, NS_UserTask);
                        //PE-185.NC.1.0 10Oct2023 end
                    end;
                }
                //field(RFQ; Rec.NS_RFQ) //PE-185.NC.1.0 10Oct2023 Block
                // field(RFQ; Rec.NS_CalcCountSeq2()) //PE-185.NC.1.0 10Oct2023  //PRJCTPR-270.HS.1.0 4Jan2023 Block
                field(RFQ; Rec.NS_RFQ) //PRJCTPR-270.HS.1.0 4Jan2023 
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    Caption = 'RFQ';
                    CaptionClass = '50993,1,0'; //PE-185.NC.1.0 10Oct2023
                    ToolTip = 'RFQ';
                    trigger OnDrillDown()

                    begin
                        //PE-185.NC.1.0 10Oct2023 Start
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
                        //PE-185.NC.1.0 10Oct2023 End
                    end;
                }
                //field(RFI; Rec.NS_RFI) //PE-185.NC.1.0 10Oct2023 Block
                // field(RFI; Rec.NS_CalcCountSeq3()) //PE-185.NC.1.0 10Oct2023 //PRJCTPR-270.HS.1.0 4Jan2023 Block
                field(RFI; Rec.NS_RFI)  //PRJCTPR-270.HS.1.0 4Jan2023
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    Caption = 'RFI';
                    CaptionClass = '50993,2,0'; //PE-185.NC.1.0 10Oct2023
                    ToolTip = 'RFI';
                    trigger OnDrillDown()
                    begin
                        //PE-185.NC.1.0 10Oct2023 Start
                        NSCode := '';
                        NSNumberFilter.Reset();
                        NSNumberFilter.SetRange("Document No.", 'USER');
                        NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
                        NSNumberFilter.SetRange("NS_User Task Cue Sequence", 3);
                        IF NSNumberFilter.FindFirst() then
                            NSCode := NSNumberFilter."No.";
                        NS_UserTask.Reset();
                        NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
                        NS_UserTask.SetFilter("NS_User Task Category", NSCode);
                        NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_Date);
                        Page.Run(Page::"NSUserTaskList", NS_UserTask);
                        //PE-185.NC.1.0 10Oct2023 End
                    end;
                }
                //field(Submittal; rec.NS_Submittal) //PE-185.NC.1.0 10Oct2023 Block
                // field(Submittal; Rec.NS_CalcCountSeq4()) //PE-185.NC.1.0 10Oct2023  //PRJCTPR-270.HS.1.0 4Jan2023 Block
                field(Submittal; rec.NS_Submittal) //PRJCTPR-270.HS.1.0 4Jan2023
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    Caption = 'Submittal';
                    CaptionClass = '50993,3,0'; //PE-185.NC.1.0 05Oct2023
                    ToolTip = 'Submittal';
                    trigger OnDrillDown()
                    begin
                        //PE-185.NC.1.0 10Oct2023  Start
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
                        NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_Date);
                        Page.Run(Page::"NSUserTaskList", NS_UserTask);
                        //PE-185.NC.1.0 10Oct2023 End
                    end;

                }
                //field(Transmittal; Rec.NS_Transmittal) //PE-185.NC.1.0 10Oct2023 Block
                // field(Transmittal; Rec.NS_CalcCountSeq5()) //PE-185.NC.1.0 10Oct2023 //PRJCTPR-270.HS.1.0 4Jan2023 Block
                field(Transmittal; Rec.NS_Transmittal) //PRJCTPR-270.HS.1.0 4Jan2023
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    Caption = 'Transmittal';
                    CaptionClass = '50993,4,0'; //PE-185.NC.1.0 10Oct2023
                    ToolTip = 'Transmittal';
                    trigger OnDrillDown()
                    begin
                        //PE-185.NC.1.0 10Oct2023 Start
                        NSCode := '';
                        NSNumberFilter.Reset();
                        NSNumberFilter.SetRange("Document No.", 'USER');
                        NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
                        NSNumberFilter.SetRange("NS_User Task Cue Sequence", 5);
                        IF NSNumberFilter.FindFirst() then
                            NSCode := NSNumberFilter."No.";
                        NS_UserTask.Reset();
                        NS_UserTask.Reset();
                        NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
                        NS_UserTask.Setrange("NS_User Task Category", NSCode);
                        NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_Date);
                        Page.Run(Page::"NSUserTaskList", NS_UserTask);
                        //PE-185.NC.1.0 10Oct2023 End
                    end;
                }
                //field(Safety; rec.NS_Safety) //PE-185.NC.1.0 10Oct2023 Block
                // field(Safety; Rec.NS_CalcCountSeq6()) //PE-185.NC.1.0 10Oct2023 //PRJCTPR-270.HS.1.0 4Jan2023 Block
                field(Safety; rec.NS_Safety) //PRJCTPR-270.HS.1.0 4Jan2023
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    Caption = 'Safety';
                    CaptionClass = '50993,5,0'; //PE-185.NC.1.0 05Oct2023
                    ToolTip = 'Safety';
                    trigger OnDrillDown()
                    begin
                        //PE-185.NC.1.0 10Oct2023 Start
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
                        NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_Date);
                        Page.Run(Page::NSUserTaskList, NS_UserTask);
                        //PE-185.NC.1.0 10Oct2023 End
                    end;
                }
                //field(OtherUserTask; Rec."NS_Other User Task") //PE-185.NC.1.0 10Oct2023 Block
                // field(OtherUserTask; Rec.NS_CalcCountSeq7()) //PE-185.NC.1.0 10Oct2023 //PRJCTPR-270.HS.1.0 4Jan2023 Block
                field(OtherUserTask; Rec."NS_Other User Task") //PRJCTPR-270.HS.1.0 4Jan2023
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    Caption = 'Other User Task';
                    CaptionClass = '50993,6,0'; //PE-185.NC.1.0 10Oct2023
                    Tooltip = 'Other User Task';
                    trigger OnDrillDown()
                    begin
                        //PE-185.NC.1.0 10Oct2023 Start
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
                        //PE-185.NC.1.0 10Oct2023 End
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
                //field("Job Log2"; Rec."NS_Job log1") //PE-185.NC.1.0 10Oct2023 Block
                // field("Job Log2"; Rec.NS_OverJobCount1()) //PE-185.NC.1.0 10Oct2023 //PRJCTPR-270.HS.1.0 4Jan2023 Block
                field("Job Log2"; Rec."NS_Job log1") //PRJCTPR-270.HS.1.0 4Jan2023
                {
                    ApplicationArea = all;
                    CaptionClass = '50993,0,0'; //PE-185.NC.1.0 05Oct2023
                    DrillDown = true;
                    ToolTip = 'Job Log';
                    trigger OnDrillDown()
                    begin
                        //PE-185.NC.1.0 10Oct2023 Start
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
                        //PE-185.NC.1.0 10Oct2023 End
                    end;
                }
                //field(RFQ1; Rec.NS_RFQ1) //PE-185.NC.1.0 10Oct2023 Block
                // field(RFQ1; Rec.NS_OverJobCount2()) //PE-185.NC.1.0 10Oct2023 //PRJCTPR-270.HS.1.0 4Jan2023 Block
                field(RFQ1; Rec.NS_RFQ1) //PRJCTPR-270.HS.1.0 4Jan2023
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    Caption = 'RFQ';
                    CaptionClass = '50993,1,0'; //PE-185.NC.1.0 05Oct2023
                    ToolTip = 'RFQ';
                    trigger OnDrillDown()

                    begin
                        //PE-185.NC.1.0 10Oct2023 Start
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
                        //PE-185.NC.1.0 10Oct2023 End
                    end;
                }
                //field(RFI1; Rec.NS_RFI1) //PE-185.NC.1.0 10Oct2023 Block
                // field(RFI1; Rec.NS_OverJobCount3())  //PE-185.NC.1.0 10Oct2023 //PRJCTPR-270.HS.1.0 4Jan2023 Block
                field(RFI1; Rec.NS_RFI1) //PRJCTPR-270.HS.1.0 4Jan2023 
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    Caption = 'RFI';
                    CaptionClass = '50993,2,0'; //PE-185.NC.1.0 05Oct2023
                    ToolTip = 'RFI';
                    trigger OnDrillDown()
                    begin
                        //PE-185.NC.1.0 10Oct2023 Start
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
                        //PE-185.NC.1.0 10Oct2023 End
                    end;
                }
                //field(Submittal1; rec.NS_Submittal1) //PE-185.NC.1.0 10Oct2023 Block
                // field(Submittal1; Rec.NS_OverJobCount4()) //PE-185.NC.1.0 10Oct2023 //PRJCTPR-270.HS.1.0 4Jan2023 Block
                field(Submittal1; rec.NS_Submittal1) //PRJCTPR-270.HS.1.0 4Jan2023
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    Caption = 'Submittal';
                    CaptionClass = '50993,3,0'; //PE-185.NC.1.0 05Oct2023
                    ToolTip = 'Submittal';
                    trigger OnDrillDown()
                    begin
                        //PE-185.NC.1.0 10Oct2023 Start
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
                        //PE-185.NC.1.0 10Oct2023 End
                    end;

                }
                //field(Transmittal1; Rec.NS_Transmittal1) //PE-185.NC.1.0 10Oct2023 Block
                // field(Transmittal1; Rec.NS_OverJobCount5()) //PE-185.NC.1.0 10Oct2023  //PRJCTPR-270.HS.1.0 4Jan2023 Block
                field(Transmittal1; Rec.NS_Transmittal1) //PRJCTPR-270.HS.1.0 4Jan2023
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    Caption = 'Transmittal';
                    CaptionClass = '50993,4,0'; //PE-185.NC.1.0 10Oct2023
                    ToolTip = 'Transmittal';
                    trigger OnDrillDown()
                    begin
                        //PE-185.NC.1.0 10Oct2023 Start
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
                        //PE-185.NC.1.0 10Oct2023 End
                    end;
                }
                //field(Safety1; rec.NS_Safety1) //PE-185.NC.1.0 10Oct2023 Block
                // field(Safety1; Rec.NS_OverJobCount6()) //PE-185.NC.1.0 10Oct2023   //PRJCTPR-270.HS.1.0 4Jan2023 Block
                field(Safety1; rec.NS_Safety1) //PRJCTPR-270.HS.1.0 4Jan2023
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    Caption = 'Safety';
                    CaptionClass = '50993,5,0'; //PE-185.NC.1.0 10Oct2023
                    ToolTip = 'Safety';
                    trigger OnDrillDown()
                    begin
                        //PE-185.NC.1.0 10Oct2023 Start
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
                        //PE-185.NC.1.0 10Oct2023 End
                    end;
                }
                //field(OtherUserTask1; Rec."NS_Other User Task1") //PE-185.NC.1.0 10Oct2023 Block
                // field(OtherUserTask1; Rec.NS_OverJobCount7()) //PE-185.NC.1.0 10Oct2023 //PRJCTPR-270.HS.1.0 4Jan2023 Block
                field(OtherUserTask1; Rec."NS_Other User Task1") //PRJCTPR-270.HS.1.0 4Jan2023
                {
                    ApplicationArea = all;
                    DrillDown = true;
                    Caption = 'Other User Task';
                    CaptionClass = '50993,6,0'; //PE-185.NC.1.0 05Oct2023
                    Tooltip = 'Other User Task';
                    trigger OnDrillDown()
                    begin
                        //PE-185.NC.1.0 10Oct2023 Start
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
                        //PE-185.NC.1.0 10Oct2023 End
                    end;
                }
            }

            //PRJCTPR-270.HS.1.0 25Jan2024 Start
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
            //PRJCTPR-270.HS.1.0 25Jan2024 End
        }
    }
    //PRJCTPR-270.HS.1.0 4Jan2024 Start
    trigger OnAfterGetRecord()
    var
        NS_UserTaskL: Record "User Task";
    begin
        Rec."NS_Job Log" := Rec.NS_CalcCountSeq1();
        Rec.NS_RFQ := Rec.NS_CalcCountSeq2();
        Rec.NS_RFI := Rec.NS_CalcCountSeq3();
        rec.NS_Submittal := Rec.NS_CalcCountSeq4();
        Rec.NS_Transmittal := Rec.NS_CalcCountSeq5();
        Rec.NS_Safety := Rec.NS_CalcCountSeq6();
        Rec."NS_Other User Task" := Rec.NS_CalcCountSeq7();
        Rec."NS_Job log1" := Rec.NS_OverJobCount1();
        Rec.NS_RFQ1 := Rec.NS_OverJobCount2();
        Rec.NS_RFI1 := Rec.NS_OverJobCount3();
        rec.NS_Submittal1 := Rec.NS_OverJobCount4();
        Rec.NS_Transmittal1 := Rec.NS_OverJobCount5();
        Rec.NS_Safety1 := Rec.NS_OverJobCount6();
        Rec."NS_Other User Task1" := Rec.NS_OverJobCount7();

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
        "NS_Total_Over Due" := Rec."NS_Job Log1" + Rec.NS_RFI1 + Rec.NS_RFQ1 + Rec.NS_Submittal1 + Rec.NS_Transmittal1 + Rec.NS_Safety1 + Rec."NS_Other User Task1";
        if "NS_Total_Over Due" > 0 then
            NS_TotalStyle := 'Unfavorable'
        else
            NS_TotalStyle := '';
    end;
    //PRJCTPR-270.HS.1.0 4Jan2024 End

    trigger OnOpenPage();
    var
        NSConfPersonalizationMgt: Codeunit "Conf./Personalization Mgt.";//PRJ-1686.GK.4.0 18Dec2022
    begin
        NSConfPersonalizationMgt.RaiseOnOpenRoleCenterEvent();//PRJ-1686.GK.4.0 18Dec2022
        Rec.RESET(); //PRJ-1131.NK.1.0
        if not Rec.GET() then begin //PRJ-1131.NK.1.0
            Rec.INIT(); //PRJ-1131.NK.1.0
            Rec.INSERT(); //PRJ-1131.NK.1.0
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
        NSNumberFilter: Record NSNumberFilter; //PE-185.NC.1.0 10Oct2023
        NSCode: Code[20]; //PE-185.NC.1.0 10Oct2023
        NSCode2: Code[20]; //PE-185.NC.1.0 10Oct2023

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