page 14021426 "NS_Job Quote Package SubForm"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    AutoSplitKey = true;
    Caption = 'Quote Package Subform';
    DelayedInsert = true;
    PageType = ListPart;
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    SourceTable = "NS_Job Quote Line";
    SourceTableView = WHERE(NS_Type = FILTER(Template));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.NS_Type)
                {
                    ApplicationArea = All;
                    OptionCaption = '" ,,,,,Package"';
                    ToolTip = 'Specifies the Type';

                    trigger OnValidate();
                    begin
                        if NS_Type <> xRec.NS_Type then
                            if NS_Type <> NS_Type::Template then begin
                                MESSAGE(STRSUBSTNO(Text14021400Lbl, FORMAT(NS_Type::Template)));
                                NS_Type := NS_Type::Template;
                            end;
                    end;
                }
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';

                    trigger OnValidate();
                    begin
                        NS_NoOnAfterValidate();
                    end;
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
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
                action(PP_Attributes)
                {
                    ApplicationArea = All;
                    ToolTip = 'Attributes';
                    Caption = 'Attributes';
                    Image = EditList;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        if "NS_Attribute Set Entry No." = 0 then
                            "NS_Attribute Set Entry No." := AttributeMgt.NS_GetNextAttributeSetEntryNo;
                        AttributeMgt.NS_ShowAttributeSetEntries("NS_Attribute Set Entry No.");
                    end;
                }
                action(NS_Dimensions)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ToolTip = 'Dimensions';
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction();
                    var
                        QuoteMgt: Codeunit "NS_Job Quote Mgt.";
                    begin
                        QuoteMgt.NS_ShowDocDimForLine(Rec);
                    end;
                }
                action("NS_Feature Text")
                {
                    ApplicationArea = All;
                    ToolTip = 'Feature Text';
                    Caption = 'Feature Text';
                    Image = EditList;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "NS_Job Quote Feature Text";
                }
                action("NS_Scope of &Work")
                {
                    ApplicationArea = All;
                    Caption = 'Scope of &Work';

                    ToolTip = 'Scope of &Work';
                    Image = EditList;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "NS_Job Quote Scope of Work";
                }
                action(NS_Comments)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';

                    ToolTip = 'Comments';
                    Image = ViewComments;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Comment List";
                }
                action("<NS_Task Lines>")
                {
                    ApplicationArea = All;
                    Caption = 'Task Lines';
                    Image = TaskList;

                    ToolTip = 'Task Lines';

                    trigger OnAction();
                    var
                        QTaskLine: Record "Job Task";
                        QTaskLinePg: Page "Job Task List";
                    begin
                        if NS_Type <> NS_Type::Template then begin
                            QTaskLine.SETRANGE("Job No.", "NS_Quote No.");
                            QTaskLine.SETRANGE("Job Task No.", "NS_Job Task No.");
                        end else begin
                            QTaskLinePg.EDITABLE(false);
                            QTaskLine.SETRANGE("Job No.", "NS_Quote No.");
                        end;
                        PAGE.RUN(1002, QTaskLine);
                    end;
                }
                action("<NS_Planning Lines Task>")
                {
                    ApplicationArea = All;
                    Caption = 'Planning Lines Task';

                    ToolTip = 'Planning Lines Task';
                    Image = PlanningWorksheet;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction();
                    var
                        PlanningLine: Record "Job Planning Line";
                        PlanningLinePg: Page "Job Planning Lines";
                    begin
                        if NS_Type <> NS_Type::Template then begin
                            PlanningLine.SETRANGE("Job No.", "NS_Quote No.");
                            PlanningLine.SETRANGE("Job Task No.", "NS_Job Task No.");
                        end else begin
                            PlanningLine.SETRANGE("Job No.", "NS_Quote No.");
                        end;
                        PAGE.RUN(PAGE::"Job Planning Lines", PlanningLine);
                    end;
                }
                action("<NS_Planning Lines Single>")
                {
                    ApplicationArea = All;
                    Caption = 'Planning Lines Single';
                    ToolTip = 'Planning lines Single';
                    Image = Planning;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction();
                    var
                        PlanningLine: Record "Job Planning Line";
                        PlanningLinePg: Page "Job Planning Lines";
                    begin
                        if NS_Type <> NS_Type::Template then begin
                            PlanningLine.SETRANGE("Job No.", "NS_Quote No.");
                            PlanningLine.SETRANGE("Job Task No.", "NS_Job Task No.");
                            PlanningLine.SETRANGE(Type, NS_Type);
                            PlanningLine.SETRANGE("No.", "NS_No.");
                        end else begin
                            PlanningLine.SETRANGE("Job No.", "NS_Quote No.");
                        end;
                        PAGE.RUN(PAGE::"Job Planning Lines", PlanningLine);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        NS_Type := NS_Type::Template;
    end;

    trigger OnAfterGetRecord();
    begin
        NS_Type := NS_Type::Template;
    end;

    var
        AttributeMgt: Codeunit "NS_Job Quote Mgt.";
        Text14021400Lbl: Label 'Only Lines of Type %1 are allowed in this section.', Comment = '%1=PP_Type::Template';

    local procedure NS_NoOnAfterValidate();
    var
        QuoteMgt: Codeunit "NS_Job Quote Mgt.";
    begin
        case NS_Type of
            NS_Type::Template:
                begin
                    "NS_Unit of Measure Code" := 'EA';
                    "NS_Qty. per Unit of Measure" := 1;
                    NS_Quantity := 1;
                    CurrPage.SAVERECORD();
                    if ("NS_No." <> xRec."NS_No.") and (Rec."NS_No." <> '') then begin
                        if xRec."NS_No." = '' then
                            QuoteMgt.NS_LoadFromJobTmpl("NS_Quote No.", "NS_No.")
                        else
                            QuoteMgt.NS_OnRenameQuoteLine(Rec, xRec);
                    end;
                end;
        end;
    end;

    //SMPL Replaced "Job Task Lines" name reference to ID 1002
}

