page 14021431 "NS_Job Quote Segment TotalSubF"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PPAL-172.MS.1.0 added new action Select Package for package functionality
    //PRJ-659.RS.1.0 22June21 | NS_�should�be�removed�from�every�page�rest�mention�the�page�ID�and�Name.
    //PRJ-735.JS.1.0 01Dec2021 | Add code
    //PRJ-1104.JS.1.0 02FEB2022 
    //PRJ-1312.NK.1.0 03May2022 | Add Code
    PageType = ListPart;
    SourceTable = "NS_Job Takeoff Segments";
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    Caption = 'Job Quote Segment TotalSubF';//PRJ-659.RS.1.0 1July21 Caption Added

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Segment Code"; Rec."NS_Segment Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Segment Code';
                }
                field("Segment Name"; Rec."NS_Segment Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Segment Name';
                }
                field("Schedule (Total Cost)"; Rec."NS_Schedule (Total Cost)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Schedule (Total Cost)';
                    Caption = 'Schedule (Total Cost)';


                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Schedule (Total Price)"; Rec."NS_Schedule (Total Price)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Schedule (Total Price)';
                }
                field("Total Contract Price"; Rec."NS_Total Contract Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Contract Price';
                }

                //PRJCTPR-319.JS.1.0 07MAR2024 - Start
                field("NS_Freeze Total Contract Price"; Rec."NS_Freeze Total Contract Price")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Enable this field allow to freeze segment "Total Contarct Price" to avoid any further change in "Total Contract Price" value.';
                }
                //PRJCTPR-319.JS.1.0 07MAR2024 - end

                field("Remaining (Total Cost)"; Rec."NS_Remaining (Total Cost)")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the Remaining (Total Cost)';
                    Visible = false;
                }
                field("Remaining (Total Price)"; Rec."NS_Remaining (Total Price)")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the Remaining (Total Price)';
                    Visible = false;
                }
                field("Amt. Rcd. Not Invoiced"; Rec."NS_Amt. Rcd. Not Invoiced")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the Amt. Rcd. Not Invoiced';
                    Visible = false;
                }
                field("Line Amount Incl. Tax"; Rec."NS_Line Amount Incl. Tax")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the Line Amount Incl. Tax';
                    Visible = false;
                }
                field("Mark-up"; Rec."NS_Mark-up")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Mark-up';
                }
                field("Gross Profit"; Rec."NS_Gross Profit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Gross Profit';
                }
                field("Gross Profit Percent"; Rec."NS_Gross Profit Percent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Gross Profit Percent';
                }
                field("Work Units"; Rec."NS_Work Units")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Units';
                }
                field("Work Unit of Measure"; Rec."NS_Work Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Unit of Measure';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                action(NS_CalcSegmentProfits)
                {
                    ApplicationArea = All;
                    Caption = 'Calc Segment Profits';

                    trigger OnAction();
                    begin
                        QuoteMgt.NS_CalcSegmentProfitAmounts("NS_Job No.", "NS_Segment Code");
                    end;
                }
                action(NS_CalcProfits)
                {
                    ApplicationArea = All;
                    Caption = 'Calc Profits';

                    trigger OnAction();
                    begin
                        QuoteMgt.NS_CalcSegmentProfitAmounts("NS_Job No.", '');
                    end;
                }
                action("NS_Planning Lines - Job")
                {
                    ApplicationArea = All;
                    ToolTip = 'Planning Lines-Job';
                    Caption = 'Planning Lines-Job';//PRJ-659.RS.1.0 22June21 New Added

                    trigger OnAction();
                    var
                        PlanningLines: Record "Job Planning Line";
                        PlanningLinesPg: Page "Job Planning Lines";
                    begin
                        PlanningLinesPg.InitVar(Rec."NS_Job No.", '', false, ''); //PRJ-1131.RM.1.0
                        PlanningLinesPg.NS_GetQuoteSegmentLineVars(rec."NS_Job No.", rec."NS_Segment Code");  //PRJCTPR-319.JS.1.0 13MAR2024 line added
                        PlanningLinesPg.EDITABLE(true);
                        if PlanningLinesPg.RUNMODAL = ACTION::OK then begin
                            CurrPage.UPDATE;
                        end;
                    end;
                }
                action("Planning Lines - Segment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Planning Lines - Segment';

                    trigger OnAction();
                    var
                        PlanningLines: Record "Job Planning Line";
                        PlanningLinesPg: Page "Job Planning Lines";
                    begin
                        PlanningLinesPg.InitVar(Rec."NS_Job No.", '', true, ''); //PRJ-1131.RM.1.0
                        PlanningLinesPg.NS_GetQuoteSegmentLineVars(rec."NS_Job No.", rec."NS_Segment Code");  //PRJCTPR-319.JS.1.0 13MAR2024 line added
                        PlanningLinesPg.EDITABLE(true);
                        if PlanningLinesPg.RUNMODAL = ACTION::OK then begin
                            CurrPage.UPDATE;
                        end;
                    end;
                }
                action("NS_Planning Lines - Current Segment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Planning Lines - Current Segment';
                    Caption = 'Planning Lines - Current Segment';//PRJ-659.RS.1.0 22June21 New Added

                    trigger OnAction();
                    var
                        PlanningLines: Record "Job Planning Line";
                        PlanningLinesPg: Page "Job Planning Lines";
                    begin
                        PlanningLinesPg.InitVar("NS_Job No.", '', true, "NS_Segment Code");
                        PlanningLinesPg.EDITABLE(true);
                        //if PlanningLinesPg.RUNMODAL = ACTION::OK then begin
                        PlanningLinesPg.NS_GetQuoteSegmentLineVars(rec."NS_Job No.", rec."NS_Segment Code");  //PRJCTPR-319.JS.1.0 25FEB2024 line added
                        PlanningLinesPg.Run();//Test //ppal-172 
                        CurrPage.UPDATE;
                        // end;
                    end;
                }
                action("NS_Scope of Work New ")
                {
                    ApplicationArea = All;
                    ToolTip = 'Scope of work';
                    Enabled = false;
                    Visible = false;
                    Caption = 'Scope of Work New';//PRJ-659.RS.1.0 22June21 New Added

                    trigger OnAction();
                    var
                        DefScope: Record "NS_Job Quote Def Scope of Work";
                        DefScopePg: Page "NS_Job Quote Default SOW";
                        ScopeOfWork: Record "NS_Job Quote Scope of Work";
                        ScopeOfWorkPg: Page "NS_Job Quote Scope of Work";
                        Text14021400Lbl: Label 'Scope of Work Entries Already Exist for Quote %1 Segment %2.\Do you Want to Delete them?', Comment = '%1=Job No.,%2=Segment Code';
                        LineNo: Integer;
                    begin
                        ScopeOfWork.SETRANGE("NS_Segment Code", "NS_Segment Code");
                        if ScopeOfWork.FINDFIRST() then begin
                            if CONFIRM(Text14021400Lbl, false, "NS_Job No.", "NS_Segment Code") then begin
                                ScopeOfWork.RESET;
                                ScopeOfWork.SETRANGE("NS_Quote No.", "NS_Job No.");
                                ScopeOfWork.SETRANGE("NS_Segment Code", "NS_Segment Code");
                                ScopeOfWork.DELETEALL();
                                COMMIT();
                                DefScopePg.SETTABLEVIEW(DefScope);
                                DefScopePg.EDITABLE(true);
                                DefScopePg.NS_InitVar(true);
                                if DefScopePg.RUNMODAL = ACTION::OK then begin
                                    DefScope.SETRANGE(NS_Selected, true);
                                    DefScopePg.GETRECORD(DefScope);
                                    if DefScope.FINDSET(false, true) then
                                        repeat
                                            LineNo += 1;
                                            ScopeOfWork.RESET();
                                            ScopeOfWork.INIT();
                                            ScopeOfWork."NS_Quote No." := "NS_Job No.";
                                            ScopeOfWork."NS_Segment Code" := "NS_Segment Code";
                                            ScopeOfWork."NS_Line No." := LineNo * 10000;
                                            ScopeOfWork."NS_Segment Name" := "NS_Segment Name";
                                            ScopeOfWork.NS_Description := DefScope.NS_Description;
                                            ScopeOfWork."NS_Description 2" := DefScope."NS_Description 2";
                                            ScopeOfWork.NS_Code := DefScope.NS_Code;
                                            ScopeOfWork.INSERT();
                                            DefScope.NS_Selected := false;
                                            DefScope.MODIFY();
                                        until DefScope.NEXT() = 0;
                                end;
                            end else begin
                                ScopeOfWork.RESET;
                                ScopeOfWork.SETRANGE("NS_Quote No.", "NS_Job No.");
                                ScopeOfWork.SETRANGE("NS_Segment Code", "NS_Segment Code");
                                ScopeOfWorkPg.SETTABLEVIEW(ScopeOfWork);
                                ScopeOfWorkPg.RUN();
                            end;
                        end else begin
                            DefScopePg.SETTABLEVIEW(DefScope);
                            DefScopePg.EDITABLE(true);
                            DefScopePg.NS_InitVar(true);
                            if DefScopePg.RUNMODAL() = ACTION::OK then begin
                                DefScope.SETRANGE(NS_Selected, true);
                                DefScopePg.GETRECORD(DefScope);
                                if DefScope.FINDSET(false, true) then
                                    repeat
                                        LineNo += 1;
                                        ScopeOfWork.RESET();
                                        ScopeOfWork.INIT();
                                        ScopeOfWork.NS_Code := DefScope.NS_Code;
                                        ScopeOfWork."NS_Quote No." := "NS_Job No.";
                                        ScopeOfWork."NS_Segment Code" := "NS_Segment Code";
                                        ScopeOfWork."NS_Line No." := LineNo * 10000;
                                        ScopeOfWork."NS_Segment Name" := "NS_Segment Name";
                                        ScopeOfWork.NS_Description := DefScope.NS_Description;
                                        ScopeOfWork."NS_Description 2" := DefScope."NS_Description 2";
                                        ScopeOfWork.INSERT();
                                        DefScope.NS_Selected := false;
                                        DefScope.MODIFY();
                                    until DefScope.NEXT() = 0;
                            end;
                        end;
                    end;
                }
                action("NS_Scope of Work")
                {
                    ApplicationArea = All;
                    ToolTip = 'Scope Of Work';
                    Caption = 'Scope of Work';//PRJ-659.RS.1.0 22June21 New Added

                    trigger OnAction();
                    var
                        DefScope: Record "NS_Job Quote Def Scope of Work";
                        DefScopePg: Page "NS_Job Quote Default SOW";
                        ScopeOfWork: Record "NS_Job Quote Scope of Work";
                        ScopeOfWorkPg: Page "NS_Job Quote Scope of Work";
                        LineNo: Integer;
                    begin
                        ScopeOfWork.RESET();
                        ScopeOfWork.SETRANGE("NS_Quote No.", "NS_Job No.");
                        ScopeOfWork.SETRANGE("NS_Segment Code", "NS_Segment Code");
                        ScopeOfWorkPg.SETTABLEVIEW(ScopeOfWork);
                        ScopeOfWorkPg.NS_InitValue(Rec."NS_Job No.", Rec."NS_Segment Code");    //PRJ-735.JS.1.0 01Dec2021
                        ScopeOfWorkPg.RUNMODAL();
                    end;
                }
                action("NS_Select Package")
                {
                    ApplicationArea = all;
                    ToolTip = 'Select LineWise Package';
                    Description = 'PPAL-172.MS.1.0';
                    Caption = 'Select Package';
                    trigger OnAction()
                    var
                        JobTempListP: Page NS_JobListTemplateWise;
                    begin
                        JobTempListP.NS_getQuoteNo(Rec."NS_Job No.", "NS_Segment Code");
                        JobTempListP.RunModal();
                    end;
                }
                //PRJCTPR-319.JS.1.0 11MAR2024 - Start
                action("NS_Freeze Contract Price")
                {
                    ApplicationArea = All;
                    Caption = 'Freeze Contract Price';
                    ToolTip = 'This action is use to freeze "Total Contract Price" on all segment lines for this quote, in single click';
                    Image = Ledger;

                    trigger OnAction();
                    var
                        NSJobQuoteTakeoffSegemnt: record "NS_Job Takeoff Segments";
                    begin
                        NSJobQuoteTakeoffSegemnt.Reset();
                        NSJobQuoteTakeoffSegemnt.SetRange("NS_Job No.", Rec."NS_Job No.");
                        if NSJobQuoteTakeoffSegemnt.FindSet() then
                            repeat
                                if NSJobQuoteTakeoffSegemnt."NS_Total Contract Price" <> 0 then begin
                                    NSJobQuoteTakeoffSegemnt."NS_Freeze Total Contract Price" := true;
                                    NSJobQuoteTakeoffSegemnt.Modify();
                                end;
                            until NSJobQuoteTakeoffSegemnt.next() = 0;
                        CurrPage.UPDATE;
                    end;
                }
                action("NS_UNFreeze Contract Price")
                {
                    ApplicationArea = All;
                    Caption = 'Un-Freeze Contract Price';
                    ToolTip = 'This action is use to un-freeze "Total Contract Price" on all segment lines for this quote, in single click';
                    Image = UndoFluent;

                    trigger OnAction();
                    var
                        NSJobQuoteTakeoffSegemnt: record "NS_Job Takeoff Segments";
                    begin
                        NSJobQuoteTakeoffSegemnt.Reset();
                        NSJobQuoteTakeoffSegemnt.SetRange("NS_Job No.", Rec."NS_Job No.");
                        if NSJobQuoteTakeoffSegemnt.FindSet() then
                            repeat
                                NSJobQuoteTakeoffSegemnt."NS_Freeze Total Contract Price" := false;
                                NSJobQuoteTakeoffSegemnt.Modify();
                            until NSJobQuoteTakeoffSegemnt.next() = 0;
                        CurrPage.UPDATE;
                    end;
                }
                //PRJCTPR-319.JS.1.0 11MAR2024 - end                
            }

            //PRJ-1265.AS.1.0 START
            action("NS_RefreshSegmentValues")
            {
                ApplicationArea = all;
                Caption = 'Refresh Segment Values';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction();
                begin
                    CurrPage.Update();
                end;
            }
            //PRJ-1265.AS.1.0 END
        }
    }

    trigger OnAfterGetRecord();
    begin
        //PRJ-1104.JS.1.0 02FEB2022-Start
        //PRJ-1104.AS.1.0 START Commented the codes
        //if "NS_Total Contract Price" = 0 then
        // "NS_Total Contract Price" := "NS_Schedule (Total Price)";
        //Rec.Validate("NS_Total Contract Price", "NS_Schedule (Total Price)");
        //PRJ-1104.AS.1.0 END Commented the code
        // if Rec."NS_Total Contract Price" = 0 then//PRJCTPR-82.AS.1.0 31MARCH2023
        //Rec."NS_Total Contract Price" := Rec."NS_Schedule (Total Price)"; //PRJ-1312.NK.1.0 03May2022 Block
        If Rec."NS_Total Contract Price" = 0 then  //PRJCTPR-145.PS.1.0 05Jul2023
            Rec.Validate("NS_Total Contract Price", Rec."NS_Schedule (Total Price)"); //PRJ-1312.NK.1.0 03May2022
        //PRJ-1104.AS.1.0 END Commented the code  
        //PRJ-1104.JS.1.0 02FEB2022-end  
    end;

    trigger OnAfterGetCurrRecord();
    begin
        //PRJ-1104.JS.1.0 02FEB2022-Start
        //PRJ-1104.AS.1.0 START
        //Rec.CalcFields("NS_Schedule (Total Price)");
        //Rec.Validate("NS_Total Contract Price", Rec."NS_Schedule (Total Price)");
        //PRJ-1104.AS.1.0 END
        //PRJ-1104.JS.1.0 02FEB2022-end
    end;

    var
        QuoteMgt: Codeunit "NS_Job Quote Mgt.";
    // Markup: Label 'Markup';
    // GrossProfit: Label 'GrossProfit';
    // GrossProfitPercent: Label 'GrossProfitPercent';
}

