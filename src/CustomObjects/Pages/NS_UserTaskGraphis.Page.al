/// <summary>
/// Page NS_UserTaskGraphicsPage (ID 14021108).
/// </summary>
//PE-241.DK.1.0 Create new Page
page 14021108 NS_UserTaskGraphicsPage
{
    Caption = '';
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = NSNumberFilter;
    SourceTableView = order(ascending) where(Type = filter("NS_User Task Category"), "Document No." = const('User'));
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                // caption = 'User Task Analytics';
                Caption = '';
                field(NS_StackChart; NS_StackChart)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                usercontrol(NS_UserTaskGraphics; NS_UserTaskGraphics)
                {
                    ApplicationArea = all;
                    trigger IAddInReady()
                    begin
                    end;
                }


            }
        }
    }
    trigger OnAfterGetRecord()
    var
        NS_UserTask: Record "User Task";
        USerTAskCategory: Code[50];
        NS_NumberFilter: Record NSNumberFilter;
        CurrentInputDate: Date;
        DueDay: Date;
        NS_OverdueCount2: Integer;
        NS_Next7DayCount2: Integer;
        NS_GreatherThanCount2: Integer;
        NS_OverdueCount3: Integer;
        NS_Next7DayCount3: Integer;
        NS_GreatherThanCount3: Integer;
        NS_OverdueCount4: Integer;
        NS_Next7DayCount4: Integer;
        NS_GreatherThanCount4: Integer;
        NS_OverdueCount5: Integer;
        NS_Next7DayCount5: Integer;
        NS_GreatherThanCount5: Integer;
        NS_OverdueCount6: Integer;
        NS_Next7DayCount6: Integer;
        NS_GreatherThanCount6: Integer;
        NS_OverdueCount7: Integer;
        NS_Next7DayCount7: Integer;
        NS_GreatherThanCount7: Integer;
        NS_UserTask1: Record "User Task";
    //hyperlinkText: ;
    begin
        Clear(NS_OverdueCount);
        Clear(NS_Next7DayCount);
        Clear(NS_GreatherThanCount);
        CurrentInputDate := WorkDate();
        NS_NumberFilter.SetRange("Document No.", 'User');
        NS_NumberFilter.SetRange(Type, NS_NumberFilter.Type::"NS_User Task Category");
        if NS_NumberFilter.FindSet() then begin
            repeat
                if NS_NumberFilter."NS_User Task Cue Sequence" = 1 then begin
                    NS_UserTask.SetRange("NS_User Task Category", NS_NumberFilter."No.");
                    NS_UserTask.SetFilter("Percent Complete", '<%1', 100);
                    If NS_UserTask.FindSet() then begin
                        repeat
                            NS_UserTaskCat := NS_UserTask."NS_User Task Category";
                            Clear(DueDay);
                            DueDay := (DT2Date(NS_UserTask."Due DateTime"));
                            if DueDay < CurrentInputDate then begin

                                NS_OverdueCount += 1;
                                NS_UserTask1.Reset();
                                NS_UserTask1.SetRange("NS_User Task Category", NS_UserTask."NS_User Task Category");
                                NS_UserTask1.SetFilter("NS_Due Date", '<%1', CurrentInputDate);
                                NS_UserTask1.SetFilter("Percent Complete", '<%1', 100);
                                if NS_UserTask1.FindSet() then
                                    HyperlinkTextSEQ1 := GETURL(CURRENTCLIENTTYPE, COMPANYNAME, OBJECTTYPE::Page, 1170, NS_UserTask1, True);
                            end;
                            if ((DueDay > CurrentInputDate) And (CurrentInputDate + 7 >= DueDay)) then begin
                                NS_Next7DayCount += 1;
                                NS_UserTask1.Reset();
                                NS_UserTask1.SetRange("NS_User Task Category", NS_UserTask."NS_User Task Category");
                                NS_UserTask1.SetFilter("Percent Complete", '<%1', 100);
                                NS_UserTask1.SetFilter("NS_Due Date", '>%1&<=%2', CurrentInputDate, CurrentInputDate + 7);
                                if NS_UserTask1.FindSet() then
                                    HyperlinkTextSEQ2 := GETURL(CURRENTCLIENTTYPE, COMPANYNAME, OBJECTTYPE::Page, 1170, NS_UserTask1, True);
                            end;
                            if (DueDay > CurrentInputDate + 7) then begin
                                NS_GreatherThanCount += 1;
                                NS_UserTask1.Reset();
                                NS_UserTask1.SetRange("NS_User Task Category", NS_UserTask."NS_User Task Category");
                                NS_UserTask1.SetFilter("Percent Complete", '<%1', 100);
                                NS_UserTask1.SetFilter("NS_Due Date", '>%1', CurrentInputDate + 7);
                                if NS_UserTask1.FindSet() then
                                    HyperlinkTextSEQ3 := GETURL(CURRENTCLIENTTYPE, COMPANYNAME, OBJECTTYPE::Page, 1170, NS_UserTask1, True);
                            end;
                        until NS_UserTask.Next = 0;

                    end;
                end;
                if NS_NumberFilter."NS_User Task Cue Sequence" = 2 then begin
                    NS_UserTask.SetRange("NS_User Task Category", NS_NumberFilter."No.");
                    NS_UserTask.SetFilter("Percent Complete", '<%1', 100);
                    If NS_UserTask.FindSet() then begin
                        repeat
                            NS_UserTaskCat2 := NS_UserTask."NS_User Task Category";
                            Clear(DueDay);
                            DueDay := (DT2Date(NS_UserTask."Due DateTime"));
                            if DueDay < CurrentInputDate then begin
                                NS_OverdueCount2 += 1;
                                NS_UserTask1.Reset();
                                NS_UserTask1.SetRange("NS_User Task Category", NS_UserTask."NS_User Task Category");
                                NS_UserTask1.SetFilter("Percent Complete", '<%1', 100);
                                NS_UserTask1.SetFilter("NS_Due Date", '<%1', CurrentInputDate);
                                HyperlinkTextSEQ4 := GETURL(CURRENTCLIENTTYPE, COMPANYNAME, OBJECTTYPE::Page, 1170, NS_UserTask1, True);
                            end;
                            if ((DueDay > CurrentInputDate) And (CurrentInputDate + 7 >= DueDay)) then begin
                                NS_Next7DayCount2 += 1;
                                NS_UserTask1.Reset();
                                NS_UserTask1.SetRange("NS_User Task Category", NS_UserTask."NS_User Task Category");
                                NS_UserTask1.SetFilter("Percent Complete", '<%1', 100);
                                NS_UserTask1.SetFilter("NS_Due Date", '>%1&<=%2', CurrentInputDate, CurrentInputDate + 7);
                                HyperlinkTextSEQ5 := GETURL(CURRENTCLIENTTYPE, COMPANYNAME, OBJECTTYPE::Page, 1170, NS_UserTask1, True);
                            end;

                            if (DueDay > CurrentInputDate + 7) then begin
                                NS_GreatherThanCount2 += 1;
                                NS_UserTask1.Reset();
                                NS_UserTask1.SetRange("NS_User Task Category", NS_UserTask."NS_User Task Category");
                                NS_UserTask1.SetFilter("Percent Complete", '<%1', 100);
                                NS_UserTask1.SetFilter("NS_Due Date", '>%1', CurrentInputDate + 7);
                                HyperlinkTextSEQ6 := GETURL(CURRENTCLIENTTYPE, COMPANYNAME, OBJECTTYPE::Page, 1170, NS_UserTask1, True);
                            end;
                        until NS_UserTask.Next = 0;

                    end;

                end;
                if NS_NumberFilter."NS_User Task Cue Sequence" = 3 then begin
                    NS_UserTask.SetRange("NS_User Task Category", NS_NumberFilter."No.");
                    NS_UserTask.SetFilter("Percent Complete", '<%1', 100);
                    If NS_UserTask.FindSet() then begin
                        repeat
                            NS_UserTaskCat3 := NS_UserTask."NS_User Task Category";
                            Clear(DueDay);
                            DueDay := (DT2Date(NS_UserTask."Due DateTime"));
                            if DueDay < CurrentInputDate then begin
                                NS_OverdueCount3 += 1;
                                NS_UserTask1.Reset();
                                NS_UserTask1.SetRange("NS_User Task Category", NS_UserTask."NS_User Task Category");
                                NS_UserTask1.SetFilter("Percent Complete", '<%1', 100);
                                NS_UserTask1.SetFilter("NS_Due Date", '<%1', CurrentInputDate);
                                HyperlinkTextSEQ7 := GETURL(CURRENTCLIENTTYPE, COMPANYNAME, OBJECTTYPE::Page, 1170, NS_UserTask1, True);
                            end;

                            if ((DueDay >= CurrentInputDate) And (CurrentInputDate + 7 >= DueDay)) then begin
                                NS_Next7DayCount3 += 1;
                                NS_UserTask1.Reset();
                                NS_UserTask1.SetRange("NS_User Task Category", NS_UserTask."NS_User Task Category");
                                NS_UserTask1.SetFilter("Percent Complete", '<%1', 100);
                                NS_UserTask1.SetFilter("NS_Due Date", '>%1&<=%2', CurrentInputDate, CurrentInputDate + 7);
                                HyperlinkTextSEQ8 := GETURL(CURRENTCLIENTTYPE, COMPANYNAME, OBJECTTYPE::Page, 1170, NS_UserTask1, True);
                            end;

                            if (DueDay > CurrentInputDate + 7) then begin
                                NS_GreatherThanCount3 += 1;
                                NS_UserTask1.Reset();
                                NS_UserTask1.SetRange("NS_User Task Category", NS_UserTask."NS_User Task Category");
                                NS_UserTask1.SetFilter("Percent Complete", '<%1', 100);
                                NS_UserTask1.SetFilter("NS_Due Date", '>%1', CurrentInputDate + 7);
                                HyperlinkTextSEQ9 := GETURL(CURRENTCLIENTTYPE, COMPANYNAME, OBJECTTYPE::Page, 1170, NS_UserTask1, True);
                            end;

                        until NS_UserTask.Next = 0;
                    end;


                end;
                if NS_NumberFilter."NS_User Task Cue Sequence" = 4 then begin
                    NS_UserTask.SetRange("NS_User Task Category", NS_NumberFilter."No.");
                    NS_UserTask.SetFilter("Percent Complete", '<%1', 100);
                    // NS_UserTask.SetRange("Assigned To", UserId); // for User Wishes
                    If NS_UserTask.FindSet() then begin
                        repeat
                            NS_UserTaskCat4 := NS_UserTask."NS_User Task Category";
                            Clear(DueDay);
                            DueDay := (DT2Date(NS_UserTask."Due DateTime"));
                            if DueDay < CurrentInputDate then begin
                                NS_OverdueCount4 += 1;
                                NS_UserTask1.Reset();
                                NS_UserTask1.SetRange("NS_User Task Category", NS_UserTask."NS_User Task Category");
                                NS_UserTask1.SetFilter("Percent Complete", '<%1', 100);
                                NS_UserTask1.SetFilter("NS_Due Date", '<%1', CurrentInputDate);
                                HyperlinkTextSEQ10 := GETURL(CURRENTCLIENTTYPE, COMPANYNAME, OBJECTTYPE::Page, 1170, NS_UserTask1, True);
                            end;

                            if ((DueDay > CurrentInputDate) And (CurrentInputDate + 7 >= DueDay)) then begin
                                NS_Next7DayCount4 += 1;
                                NS_UserTask1.Reset();
                                NS_UserTask1.SetRange("NS_User Task Category", NS_UserTask."NS_User Task Category");
                                NS_UserTask1.SetFilter("Percent Complete", '<%1', 100);
                                NS_UserTask1.SetFilter("NS_Due Date", '>%1&<=%2', CurrentInputDate, CurrentInputDate + 7);
                                HyperlinkTextSEQ11 := GETURL(CURRENTCLIENTTYPE, COMPANYNAME, OBJECTTYPE::Page, 1170, NS_UserTask1, True);
                            end;

                            if (DueDay > CurrentInputDate + 7) then begin
                                NS_GreatherThanCount4 += 1;
                                NS_UserTask1.Reset();
                                NS_UserTask1.SetRange("NS_User Task Category", NS_UserTask."NS_User Task Category");
                                NS_UserTask1.SetFilter("Percent Complete", '<%1', 100);
                                NS_UserTask1.SetFilter("NS_Due Date", '>%1', CurrentInputDate + 7);
                                HyperlinkTextSEQ12 := GETURL(CURRENTCLIENTTYPE, COMPANYNAME, OBJECTTYPE::Page, 1170, NS_UserTask1, True);
                            end;

                        until NS_UserTask.Next = 0;
                    end;
                end;
                if NS_NumberFilter."NS_User Task Cue Sequence" = 5 then begin
                    NS_UserTask.SetRange("NS_User Task Category", NS_NumberFilter."No.");
                    NS_UserTask.SetFilter("Percent Complete", '<%1', 100);
                    If NS_UserTask.FindSet() then begin
                        repeat
                            NS_UserTaskCat5 := NS_UserTask."NS_User Task Category";
                            Clear(DueDay);
                            DueDay := (DT2Date(NS_UserTask."Due DateTime"));
                            if DueDay < CurrentInputDate then begin
                                NS_OverdueCount5 += 1;
                                NS_UserTask1.Reset();
                                NS_UserTask1.SetRange("NS_User Task Category", NS_UserTask."NS_User Task Category");
                                NS_UserTask1.SetFilter("Percent Complete", '<%1', 100);
                                NS_UserTask1.SetFilter("NS_Due Date", '<%1', CurrentInputDate);
                                HyperlinkTextSEQ13 := GETURL(CURRENTCLIENTTYPE, COMPANYNAME, OBJECTTYPE::Page, 1170, NS_UserTask1, True);
                            end;

                            if ((DueDay > CurrentInputDate) And (CurrentInputDate + 7 >= DueDay)) then begin
                                NS_Next7DayCount5 += 1;
                                NS_UserTask1.Reset();
                                NS_UserTask1.SetRange("NS_User Task Category", NS_UserTask."NS_User Task Category");
                                NS_UserTask1.SetFilter("Percent Complete", '<%1', 100);
                                NS_UserTask1.SetFilter("NS_Due Date", '>%1&<=%2', CurrentInputDate, CurrentInputDate + 7);
                                HyperlinkTextSEQ14 := GETURL(CURRENTCLIENTTYPE, COMPANYNAME, OBJECTTYPE::Page, 1170, NS_UserTask1, True);
                            end;

                            if (DueDay > CurrentInputDate + 7) then begin
                                NS_GreatherThanCount5 += 1;
                                NS_UserTask1.Reset();
                                NS_UserTask1.SetRange("NS_User Task Category", NS_UserTask."NS_User Task Category");
                                NS_UserTask1.SetFilter("Percent Complete", '<%1', 100);
                                NS_UserTask1.SetFilter("NS_Due Date", '>%1', CurrentInputDate + 7);
                                HyperlinkTextSEQ15 := GETURL(CURRENTCLIENTTYPE, COMPANYNAME, OBJECTTYPE::Page, 1170, NS_UserTask1, True);
                            end;

                        until NS_UserTask.Next = 0;
                    end;
                end;
                if NS_NumberFilter."NS_User Task Cue Sequence" = 6 then begin
                    NS_UserTask.SetRange("NS_User Task Category", NS_NumberFilter."No.");
                    NS_UserTask.SetFilter("Percent Complete", '<%1', 100);
                    If NS_UserTask.FindSet() then begin
                        repeat
                            // NS_UserTaskCat6 += (Format('<B>'));
                            NS_UserTaskCat6 := NS_UserTask."NS_User Task Category";
                            Clear(DueDay);
                            DueDay := (DT2Date(NS_UserTask."Due DateTime"));
                            if DueDay < CurrentInputDate then begin
                                NS_OverdueCount6 += 1;
                                NS_UserTask1.Reset();
                                NS_UserTask1.SetRange("NS_User Task Category", NS_UserTask."NS_User Task Category");
                                NS_UserTask1.SetFilter("Percent Complete", '<%1', 100);
                                NS_UserTask1.SetFilter("NS_Due Date", '<%1', CurrentInputDate);
                                HyperlinkTextSEQ16 := GETURL(CURRENTCLIENTTYPE, COMPANYNAME, OBJECTTYPE::Page, 1170, NS_UserTask1, True);
                            end;

                            if ((DueDay > CurrentInputDate) And (CurrentInputDate + 7 >= DueDay)) then begin
                                NS_Next7DayCount6 += 1;
                                NS_UserTask1.Reset();
                                NS_UserTask1.SetRange("NS_User Task Category", NS_UserTask."NS_User Task Category");
                                NS_UserTask1.SetFilter("Percent Complete", '<%1', 100);
                                NS_UserTask1.SetFilter("NS_Due Date", '>%1&<=%2', CurrentInputDate, CurrentInputDate + 7);
                                HyperlinkTextSEQ17 := GETURL(CURRENTCLIENTTYPE, COMPANYNAME, OBJECTTYPE::Page, 1170, NS_UserTask1, True);

                            end;

                            if (DueDay > CurrentInputDate + 7) then begin
                                NS_GreatherThanCount6 += 1;
                                NS_UserTask1.Reset();
                                NS_UserTask1.SetRange("NS_User Task Category", NS_UserTask."NS_User Task Category");
                                NS_UserTask1.SetFilter("Percent Complete", '<%1', 100);
                                NS_UserTask1.SetFilter("NS_Due Date", '>%1', CurrentInputDate + 7);
                                HyperlinkTextSEQ18 := GETURL(CURRENTCLIENTTYPE, COMPANYNAME, OBJECTTYPE::Page, 1170, NS_UserTask1, True);

                            end;

                        until NS_UserTask.Next = 0;
                    end;
                end;
                if NS_NumberFilter."NS_User Task Cue Sequence" = 7 then begin
                    NS_UserTask.SetRange("NS_User Task Category", NS_NumberFilter."No.");
                    NS_UserTask.SetFilter("Percent Complete", '<%1', 100);
                    //  NS_UserTask.SetRange("Assigned To", UserId); // for User Wishes
                    If NS_UserTask.FindSet() then begin
                        repeat
                            NS_UserTaskCat7 := NS_UserTask."NS_User Task Category";
                            Clear(DueDay);
                            DueDay := (DT2Date(NS_UserTask."Due DateTime"));
                            if DueDay < CurrentInputDate then begin
                                NS_OverdueCount7 += 1;
                                NS_UserTask1.Reset();
                                NS_UserTask1.SetRange("NS_User Task Category", NS_UserTask."NS_User Task Category");
                                NS_UserTask1.SetFilter("Percent Complete", '<%1', 100);
                                NS_UserTask1.SetFilter("NS_Due Date", '<%1', CurrentInputDate);
                                HyperlinkTextSEQ19 := GETURL(CURRENTCLIENTTYPE, COMPANYNAME, OBJECTTYPE::Page, 1170, NS_UserTask1, True);

                            end;
                            if ((DueDay >= CurrentInputDate) And (CurrentInputDate + 7 >= DueDay)) then begin
                                NS_Next7DayCount7 += 1;
                                NS_UserTask1.Reset();
                                NS_UserTask1.SetRange("NS_User Task Category", NS_UserTask."NS_User Task Category");
                                NS_UserTask1.SetFilter("Percent Complete", '<%1', 100);
                                NS_UserTask1.SetFilter("NS_Due Date", '>%1&<%2', CurrentInputDate, CurrentInputDate + 7);
                                HyperlinkTextSEQ20 := GETURL(CURRENTCLIENTTYPE, COMPANYNAME, OBJECTTYPE::Page, 1170, NS_UserTask1, True);

                            end;

                            if (DueDay > CurrentInputDate + 7) then begin
                                NS_GreatherThanCount7 += 1;
                                NS_UserTask1.Reset();
                                NS_UserTask1.SetRange("NS_User Task Category", NS_UserTask."NS_User Task Category");
                                NS_UserTask1.SetFilter("Percent Complete", '<%1', 100);
                                NS_UserTask1.SetFilter("NS_Due Date", '>%1', CurrentInputDate + 7);
                                HyperlinkTextSEQ21 := GETURL(CURRENTCLIENTTYPE, COMPANYNAME, OBJECTTYPE::Page, 1170, NS_UserTask1, True);

                            end;

                        until NS_UserTask.Next = 0;
                    end;
                end;
            until NS_NumberFilter.Next = 0;
            CurrPage.NS_UserTaskGraphics.NS_InitializeUserTaskLabel(NS_UserTaskCat, NS_UserTaskCat2, NS_UserTaskCat3, NS_UserTaskCat4, NS_UserTaskCat5, NS_UserTaskCat6, NS_UserTaskCat7);

            CurrPage.NS_UserTaskGraphics.NS_InitializeUserTaskGraphis(HyperlinkText, Format(NS_OverdueCount), Format(NS_Next7DayCount), Format(NS_GreatherThanCount), Format(NS_OverdueCount2), Format(NS_Next7DayCount2), Format(NS_GreatherThanCount2), Format(NS_OverdueCount3), Format(NS_Next7DayCount3), Format(NS_GreatherThanCount3), Format(NS_OverdueCount4), Format(NS_Next7DayCount4), Format(NS_GreatherThanCount4), Format(NS_OverdueCount5), Format(NS_Next7DayCount5), Format(NS_GreatherThanCount5), Format(NS_OverdueCount6), Format(NS_Next7DayCount6), Format(NS_GreatherThanCount6), Format(NS_OverdueCount7), Format(NS_Next7DayCount7), Format(NS_GreatherThanCount7), NS_Label);
            CurrPage.NS_UserTaskGraphics.NS_HyperLink(HyperlinkTextSEQ1, HyperlinkTextSEQ2, HyperlinkTextSEQ3, HyperlinkTextSEQ4, HyperlinkTextSEQ5, HyperlinkTextSEQ6, HyperlinkTextSEQ7, HyperlinkTextSEQ8, HyperlinkTextSEQ9, HyperlinkTextSEQ10, HyperlinkTextSEQ11, HyperlinkTextSEQ12, HyperlinkTextSEQ13, HyperlinkTextSEQ14, HyperlinkTextSEQ15, HyperlinkTextSEQ16, HyperlinkTextSEQ17, HyperlinkTextSEQ18, HyperlinkTextSEQ19, HyperlinkTextSEQ20, HyperlinkTextSEQ21);
        end;
    end;

    trigger OnOpenPage()
    begin
        NS_Label.Add(NS_OverDue);
        NS_Label.Add(NS_Next7Day);
        NS_Label.Add(NS_GreatherThan);
    end;

    var
        Count1: Code[20];
        NS_Label: JsonArray;
        NS_OverDue: Label 'Overdue';
        NS_Next7Day: Label 'Next 7 Days';
        NS_GreatherThan: Label '>7 Days';
        NS_UserTaskCat: Code[20];
        NS_UserTaskCat2: Code[20];
        NS_UserTaskCat3: Code[20];
        NS_UserTaskCat4: Code[20];
        NS_UserTaskCat5: Code[20];
        NS_UserTaskCat6: Code[20];
        NS_UserTaskCat7: Code[20];
        NS_OverdueDate: Code[20];
        NS_OverdueData: JsonArray;
        NS_OverdueData1: array[7] of Text;
        NS_Next7DayDate: Code[20];
        NS_GreatherThanDate: Code[20];
        NS_DateCalculation: Integer;
        NS_DateCalculation2: Integer;
        NS_DateCalculation3: Integer;
        fixedCalculation: Code[20];
        NS_OverdueCount: Integer;
        NS_Next7DayCount: Integer;
        NS_Next7DayData: JsonArray;
        NS_GreatherThanCount: Integer;
        NS_GrearherThanData: JsonArray;
        Day2: Date;
        Month: Integer;
        Year: Integer;
        NS_StackChart: Label 'User Task Analytics';
        HyperlinkText: JsonArray;
        HyperlinkTextSEQ1: Text[500];
        HyperlinkTextSEQ2: Text[500];
        HyperlinkTextSEQ3: Text[500];
        HyperlinkTextSEQ4: Text[500];
        HyperlinkTextSEQ5: Text[500];
        HyperlinkTextSEQ6: Text[500];
        HyperlinkTextSEQ7: Text[500];
        HyperlinkTextSEQ8: Text[500];
        HyperlinkTextSEQ9: Text[500];
        HyperlinkTextSEQ10: Text[500];
        HyperlinkTextSEQ11: Text[500];
        HyperlinkTextSEQ12: Text[500];
        HyperlinkTextSEQ13: Text[500];
        HyperlinkTextSEQ14: Text[500];
        HyperlinkTextSEQ15: Text[500];
        HyperlinkTextSEQ16: Text[500];
        HyperlinkTextSEQ17: Text[500];
        HyperlinkTextSEQ18: Text[500];
        HyperlinkTextSEQ19: Text[500];
        HyperlinkTextSEQ20: Text[500];
        HyperlinkTextSEQ21: Text[500];
}