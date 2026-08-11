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
                        PlanningLinesPg.InitVar("NS_Job No.", '', false, '');
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
                        PlanningLinesPg.InitVar("NS_Job No.", '', true, '');
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
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        if "NS_Total Contract Price" = 0 then
            "NS_Total Contract Price" := "NS_Schedule (Total Price)";
    end;

    var
        QuoteMgt: Codeunit "NS_Job Quote Mgt.";
    // Markup: Label 'Markup';
    // GrossProfit: Label 'GrossProfit';
    // GrossProfitPercent: Label 'GrossProfitPercent';
}

