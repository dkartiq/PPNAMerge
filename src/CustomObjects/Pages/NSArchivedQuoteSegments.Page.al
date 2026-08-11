page 14021443 "NS_Archived Quote Segments"
{
    // version PPNA11.00

    // PP17002-1 04/06/17 BH - Modify calculations of 'Mark-up', 'Gross Profit' & 'Gross Profit Percent'
    // PP170039 - 06/20/17 - LH - Added "Total Contract Price", code to OnAfterGetRecord defaulting new field
    // PP170049 - 06/20/17 - ZT - Renamed page action "Scope of Work Existing" to "Scope of Work"
    //                          - Disabled and hid page action "Scope of Work New"
    // PP170053 - 06/29/17 - ZT - Added field "Work Units" and "Work Unit of Measure"
    // CAM00017 - 12/08/17 - JPT - Added Copy Segment Action
    // CAM00042 - 12/20/17 - JPT - Modified Current Segment OnAction to Update the current page.  This update will allow min pricing functionality to run on main page.
    //PRJ-872.JS.1.0  13Sep2021

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    Caption = 'Archived Quote Segments';
    SourceTable = "NS_Archived Quote Segments";
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    Editable = false;     //PRJ-872.JS.1.0  13Sep2021

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

                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE();
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

                    trigger OnValidate();
                    begin
                        //PP17002-1 Start Add
                        //QuoteMgt.CalcSegProfitAmounts(Rec,Markup);
                        //PP17002-1 Finish Add
                    end;
                }
                field("Gross Profit"; Rec."NS_Gross Profit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Gross Profit';

                    trigger OnValidate();
                    begin
                        //PP17002-1 Start Add
                        //QuoteMgt.CalcSegProfitAmounts(Rec,GrossProfit);
                        //PP17002-1 Finish Add
                    end;
                }
                field("Gross Profit Percent"; Rec."NS_Gross Profit Percent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Gross Profit Percent';

                    trigger OnValidate();
                    begin
                        //PP17002-1 Start Add
                        //QuoteMgt.CalcSegProfitAmounts(Rec,GrossProfitPercent);
                        //PP17002-1 Finish Add
                    end;
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
            group("View line level functionality.")
            {
                Caption = 'View line level functionality.';
                ToolTip = 'Specifies the &Line';
                action("NS_Planning Lines - Job")
                {
                    ApplicationArea = All;
                    ToolTip = 'View job planning lines.';

                    trigger OnAction();
                    var
                        PlanningLines: Record "NS_Archived QuotePlanningLine";
                        PlanningLinesPg: Page "NS_Archived QuotePlanningLines";
                    begin
                        PlanningLinesPg.NS_InitVar("NS_Job No.", '', false, '', NS_Revision);
                        PlanningLinesPg.EDITABLE(true);
                        if PlanningLinesPg.RUNMODAL() = ACTION::OK then begin
                            CurrPage.UPDATE();
                        end;
                    end;
                }
                action("NS_Planning Lines - Segment")
                {
                    ApplicationArea = All;
                    ToolTip = 'View planning lines by all segments.';

                    trigger OnAction();
                    var
                        PlanningLines: Record "NS_Archived QuotePlanningLine";
                        PlanningLinesPg: Page "NS_Archived QuotePlanningLines";
                    begin
                        PlanningLinesPg.NS_InitVar("NS_Job No.", '', true, '', NS_Revision);
                        PlanningLinesPg.EDITABLE(true);
                        if PlanningLinesPg.RUNMODAL() = ACTION::OK then begin
                            CurrPage.UPDATE();
                        end;
                    end;
                }
                action("NS_Planning Lines - Current Segment")
                {
                    ApplicationArea = All;
                    ToolTip = 'View planning lines by current segment.';

                    trigger OnAction();
                    var
                        PlanningLines: Record "NS_Archived QuotePlanningLine";
                        PlanningLinesPg: Page "NS_Archived QuotePlanningLines";
                    begin
                        PlanningLinesPg.NS_InitVar("NS_Job No.", '', true, "NS_Segment Code", NS_Revision);
                        PlanningLinesPg.EDITABLE(true);
                        if PlanningLinesPg.RUNMODAL() = ACTION::OK then begin
                            CurrPage.UPDATE(); //CAM00042
                        end;
                    end;
                }
                action("NS_Scope of Work")
                {
                    ApplicationArea = All;
                    ToolTip = 'View job scope of work.';

                    trigger OnAction();
                    var
                        ScopeOfWork: Record "NS_Archived Quote ScopeofWork";
                        ScopeOfWorkPg: Page "NS_Archived Quote ScopeofWork";
                        LineNo: Integer;
                    begin
                        ScopeOfWork.RESET();
                        ScopeOfWork.SETRANGE("NS_Quote No.", "NS_Job No.");
                        ScopeOfWork.SETRANGE("NS_Segment Code", "NS_Segment Code");
                        ScopeOfWork.SETRANGE(NS_Revision, NS_Revision);
                        ScopeOfWorkPg.SETTABLEVIEW(ScopeOfWork);
                        ScopeOfWorkPg.RUNMODAL();
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        //PP170039 - start
        if "NS_Total Contract Price" = 0 then
            "NS_Total Contract Price" := "NS_Schedule (Total Price)";
        //PP170039 - end
    end;

    var
    // QuoteMgt: Codeunit "Job Quote Mgt.";
    // Markup: Label 'Markup';
    // GrossProfit: Label 'GrossProfit';
    // GrossProfitPercent: Label 'GrossProfitPercent';
}

