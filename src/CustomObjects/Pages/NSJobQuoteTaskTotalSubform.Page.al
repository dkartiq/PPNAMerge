page 14021425 "NS_Job Quote Task TotalSubform"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-1072.NK.1.0 10122021
    DeleteAllowed = false;
    Caption = 'Job Quote Task Total Subform';
    InsertAllowed = false;
    PageType = ListPart;
    ShowFilter = false;
    SourceTable = "Job Task";
    SourceTableView = WHERE("Job Task Type" = FILTER(Total | "End-Total"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Job Task No.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Description';
                }
                field("WIP Method"; Rec."WIP Method")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the WIP Method';
                    Visible = false;
                }
                field("WIP-Total"; Rec."WIP-Total")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the WIP-Total';
                    Visible = false;
                }
                field("Job Posting Group"; Rec."Job Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Posting Group';
                    Visible = false;
                }
                field("Schedule (Total Cost)"; Rec."Schedule (Total Cost)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Schedule (Total Cost)';
                }
                field("Schedule (Total Price)"; Rec."Schedule (Total Price)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Schedule (Total Price)';
                }
                field("Usage (Total Cost)"; Rec."Usage (Total Cost)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Usage (Total Cost)';
                    Visible = false;
                }
                field("Usage (Total Price)"; Rec."Usage (Total Price)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Usage (Total Price)';
                    Visible = false;
                }
                field("Contract (Total Cost)"; Rec."Contract (Total Cost)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Contract (Total Cost)';
                    Visible = false;
                }
                field("Contract (Total Price)"; Rec."Contract (Total Price)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Contract (Total Price)';
                    Visible = false;
                }
                field("Contract (Invoiced Price)"; Rec."Contract (Invoiced Price)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Contract (Invoiced Price)';
                    Visible = false;
                }
                field("Contract (Invoiced Cost)"; Rec."Contract (Invoiced Cost)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Contract (Invoiced Cost)';
                    Visible = false;
                }
                //PRJ-1072.GK.2.0 Uncomment & Set visible false start
                //PRJ-1072.NK.1.0 Start
                field("Remaining (Total Cost)"; Rec."Remaining (Total Cost)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Remaining (Total Cost)';
                    Visible = false;
                    Editable = false;
                }
                field("Remaining (Total Price)"; Rec."Remaining (Total Price)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Remaining (Total Price)';
                    Visible = false;
                    Editable = false;
                }
                //PRJ-1072.NK.1.0 END.
                //PRJ-1072.GK.2.0 Uncomment & Set visible false end
                field("Amt. Rcd. Not Invoiced"; Rec."Amt. Rcd. Not Invoiced")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Amt. Rcd. Not Invoiced';
                }
                field("Total Percent Complete"; Rec."NS_Total Percent Complete")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Total Percent Complete';
                }
                field("Billing Percent"; Rec."NS_Billing Percent")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Billing Percent';
                }
                field("Quantity Weighted"; Rec."NS_Quantity Weighted")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quantity Weighted';
                    Visible = false;
                }
                field("Cost Weighted"; Rec."NS_Cost Weighted")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Cost Weighted';
                    Visible = false;
                }
                field("Mark-up"; Rec."NS_Mark-up")
                {
                    ApplicationArea = All;
                    Caption = 'Markup %';
                    Editable = FieldEditable;//PRJ-1531.GK.1.0 24Aug2022
                }
                field("<Gross Margin>"; Rec."NS_Gross Profit")
                {
                    ApplicationArea = All;
                    Caption = 'Gross Margin';
                    Editable = FieldEditable;//PRJ-1531.GK.1.0 24Aug2022
                }
                field("<Gross Margin Percentage>"; Rec."NS_Gross Profit Percentage")
                {
                    ApplicationArea = All;
                    //Caption = 'Gross Margin Percentage';//PRJ-1531.GK.1.0 24Aug2022|Comment
                    Caption = 'Gross Margin %';//PRJ-1531.GK.1.0 24Aug2022|Add
                    Editable = FieldEditable;//PRJ-1531.GK.1.0 24Aug2022
                }
                field("Line Amount Incl. Tax"; Rec."NS_Line Amount Incl. Tax")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line Amount Incl. Tax';
                    Visible = false;
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
                action("Update Profit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Update Profit';
                    trigger OnAction();
                    var
                        PlanLine: Record "Job Planning Line";

                        QuoteMgt: Codeunit "NS_Job Quote Mgt.";
                    begin
                        PlanLine.SETRANGE("Job No.", Rec."Job No."); //PRJ-1131.NK.1.0
                        QuoteMgt.NS_CalcProfitAmounts(Rec."Job No.", Rec."Job Task No.", PlanLine);//PRJ-1131.NK.1.0
                        QuoteMgt.NS_CalcProfitAmounts4Totals(Rec."Job No.", Rec."Job Task No.");//PRJ-1120.AS.1.0  //PRJ-1531.GK.1.0 24Aug2022
                    end;
                }
                action("Quote Task Lines")
                {
                    ApplicationArea = All;
                    ToolTip = 'Quote Task Lines';

                    trigger OnAction();
                    var
                        QTaskLine: Record "Job Task";
                        QTaskLinePg: Page "Job Task List";
                        QTaskLine2: Record "Job Task";
                        TaskLines: Page 1002;
                    begin
                        QTaskLine.SETRANGE("Job No.", "Job No.");
                        TaskLines.SETTABLEVIEW(QTaskLine);
                        TaskLines.SetQuoteNo("NS_Quote No.");
                        TaskLines.RUNMODAL;
                    end;
                }
                action("<Task Lines>")
                {
                    ApplicationArea = All;
                    Caption = 'Task Lines';

                    trigger OnAction();
                    var
                        QTaskLine: Record "Job Task";
                        QTaskLinePg: Page "Job Task List";
                        QTaskLine2: Record "Job Task";
                    begin
                        QTaskLine2.GET("Job No.", "Job Task No.");
                        QTaskLine.SETRANGE("Job No.", "Job No.");
                        QTaskLine.SETFILTER("Job Task No.", QTaskLine2.Totaling);
                        PAGE.RUN(1002, QTaskLine);
                    end;
                }
                action("<Planning Lines Task>")
                {
                    ApplicationArea = All;
                    Caption = 'Planning Lines Task';
                    Image = PlanningWorksheet;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction();
                    var
                        PlanningLine: Record "Job Planning Line";
                        PlanningLinePg: Page "Job Planning Lines";
                        QTaskLine: Record "Job Task";
                    begin
                        QTaskLine.GET("Job No.", "Job Task No.");
                        PlanningLine.SETRANGE("Job No.", "Job No.");
                        PlanningLine.SETFILTER("Job Task No.", QTaskLine.Totaling);
                        PAGE.RUN(PAGE::"Job Planning Lines", PlanningLine);
                    end;
                }

            }

            //PRJ-1265.AS.1.0 START
            action("NS_RefreshTaskValues")
            {
                ApplicationArea = all;
                Caption = 'Refresh Task Values';
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
    //PRJ-1531.GK.1.0 24Aug2022 start
    trigger OnAfterGetCurrRecord()
    begin
        if Rec."Job Task Type" = Rec."Job Task Type"::Total then
            FieldEditable := false
        else
            FieldEditable := true;
    end;
    //PRJ-1531.GK.1.0 24Aug2022 end

    var
        FieldEditable: Boolean; //PRJ-1531.GK.1.0 24Aug2022


    //SMPL Replaced "Job Task Lines" name reference to ID 1002
}

