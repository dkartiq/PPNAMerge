page 14021341 "NS_Progress Payment Subform"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-889.GK.1.0 13Sep2021 |Add two fields

    AutoSplitKey = true;
    Caption = 'Progress Payment Subform';
    PageType = ListPart;
    SourceTable = "NS_Progress Payment Line";
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Line No."; Rec."NS_Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line No.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        NS_CheckDocument;
                    end;
                }
                field("Item No."; Rec."NS_Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Item No.';

                    trigger OnValidate();
                    begin
                        NS_CheckDocument;
                    end;
                }
                field(Type; Rec.NS_Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Type';
                }
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    LookupPageID = "NS_Subcontract Detail List";
                    TableRelation = "NS_Subcontract Lines"."NS_No." WHERE(NS_Type = FIELD(NS_Type));
                    ToolTip = 'Specifies the No.';
                }
                field("No. Description"; Rec."NS_No. Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No. Description';
                    //PRJ-1623.GK.1.0 08Sept2022 start
                    Visible = false;
                    ObsoleteState = Pending;
                    ObsoleteReason = 'This field is marked for removal and replaced by new field "NS_No. Description New" because of length mismatch with Puchase Line';
                    ObsoleteTag = '20.0.8.41354';
                    //PRJ-1623.GK.1.0 08Sept2022 end
                }
                //PRJ-1623.GK.1.0 08Sept2022 start
                field("NS_No. Description New"; Rec."NS_No. Description New")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. Description field.';
                }
                //PRJ-1623.GK.1.0 08Sept2022 end
                field("Job Task No."; Rec."NS_Job Task No.")
                {
                    ApplicationArea = All;
                    TableRelation = "Job Task"."Job No." WHERE("Job No." = FIELD("NS_Job No."));
                    ToolTip = 'Specifies the Job Task No.';

                    trigger OnValidate();
                    begin
                        if not JobTask.GET("NS_Job No.", "NS_Job Task No.") then
                            ERROR(Text005Lbl, "NS_Job Task No.", Job."No.");
                        //PRJ-1652.GK.1.0 29Sept2022 start
                        //Rec."NS_Task Description" := JobTask.Description; //PRJ-1131.NK.1.0
                        Rec."NS_Task Description New" := JobTask.Description;
                        //PRJ-1652.GK.1.0 29Sept2022 end
                    end;
                }
                field("Task Description"; Rec."NS_Task Description")
                {
                    ApplicationArea = All;
                    Caption = 'Task Description';
                    ToolTip = 'Task Description';
                    //PRJ-1652.GK.1.0 29Sept2022 start
                    Visible = false;
                    ObsoleteState = Pending;
                    ObsoleteReason = 'This field is marked for removal and replaced by new field "NS_Task Description New" because of length mismatch with Job Task';
                    ObsoleteTag = '20.0.15.41354';
                    //PRJ-1652.GK.1.0 29Sept2022 end
                }
                //PRJ-1652.GK.1.0 29Sept2022 start
                field("NS_Task Description"; Rec."NS_Task Description New")
                {
                    ApplicationArea = All;
                    Caption = 'Task Description';
                    ToolTip = 'Task Description';
                }
                //PRJ-1652.GK.1.0 29Sept2022 end
                field("Cost Category"; Rec."NS_Cost Category")
                {
                    ApplicationArea = All;
                    Caption = 'Cost Category';

                    ToolTip = 'Cost Category';
                    TableRelation = "NS_Job Cost Category";

                    trigger OnValidate();
                    var
                        OK: Boolean;
                    begin
                        OK := false;
                        JobPlanningLine.RESET;
                        JobPlanningLine.SETRANGE("Job No.", Rec."NS_Job No.");
                        JobPlanningLine.SETFILTER("NS_Entry Type", '%1|%2', JobPlanningLine."NS_Entry Type"::Both, JobPlanningLine."NS_Entry Type"::Cost);

                        if JobPlanningLine.FINDSET then
                            repeat
                                if JobPlanningLine."NS_Cost Category" = "NS_Cost Category" then
                                    OK := true;
                            until (JobPlanningLine.NEXT = 0) or OK;

                        if OK then begin
                            NS_CheckDocument;
                            NS_GetData(false);
                        end else begin
                            //  "Cost Category" := xRec."Cost Category";
                            ERROR(Text002Lbl, "NS_Cost Category", "NS_Job No.");
                        end;

                        NS_CostCategoryOnAfterValidate;
                    end;
                }
                field("Payment Method"; Rec."NS_Payment Method")
                {
                    ApplicationArea = All;
                    Editable = "PaymentMethodEditable";
                    ToolTip = 'Specifies the Payment Method';
                }
                field("Contract Quantity"; Rec."NS_Contract Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Contract Quantity';
                    Visible = false;
                }
                field("Base Amount"; Rec."NS_Base Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Base Amount';
                }
                field("Base Quantity"; Rec."NS_Base Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Base Quantity';
                }
                field(Quantity; Rec.NS_Quantity)
                {
                    DecimalPlaces = 2 : 6;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quantity';

                    trigger OnValidate();
                    begin
                        NS_CheckDocument;
                        NS_QuantityOnAfterValidate;
                    end;
                }
                field(Total; Rec.NS_Total)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total';

                    trigger OnValidate();
                    begin
                        NS_CheckDocument;
                        NS_TotalOnAfterValidate;
                    end;
                }
                field(WorkPreviousPayments; WorkPreviousPayments)
                {
                    ApplicationArea = All;
                    Caption = 'Work Previous Billings';

                    ToolTip = 'Work Previous Billings';
                    Editable = false;
                }
                field("Work Amount"; Rec."NS_Work Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Work Amount';
                }
                field("Work Retention Percent"; Rec."NS_Work Retention Percent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Retention Percent';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        NS_CheckDocument;
                        if ProgressPaymentHeader."NS_Work Retention Percent" <> 0 then
                            ERROR(Text003Lbl)
                        else begin
                            if "NS_Work Amount" <> 0 then
                                "NS_Work Retention Amount" := ROUND(("NS_Work Retention Percent" / 100) * "NS_Work Amount", 0.01)
                            else
                                "NS_Work Retention Amount" := ROUND(("NS_Work Retention Percent" / 100) * NS_Total, 0.01);
                        end;
                    end;
                }
                field("Stored Materials Amount"; Rec."NS_Stored Materials Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Stored Materials Amount';

                    trigger OnValidate();
                    begin
                        NS_CheckDocument;
                    end;
                }
                field("Material Retention Percent"; Rec."NS_Material Retention Percent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Material Retention Percent';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        NS_CheckDocument;
                        if ProgressPaymentHeader."NS_Material Retention Percent" <> 0 then
                            ERROR(Text003Lbl)
                        else
                            "NS_Material Retention Amount" := ROUND(("NS_Material Retention Percent" / 100) * "NS_Stored Materials Amount", 0.01);
                    end;
                }
                //PRJ-889.GK.1.0 13Sep2021 start
                field("NS_Progress Payment Amount"; Rec."NS_Progress Payment Amount")
                {
                    ToolTip = 'Specifies the value of the Progress Payment Amount field';
                    ApplicationArea = All;
                }
                field("NS_Posted Payments"; Rec."NS_Posted Payments")
                {
                    ToolTip = 'Specifies the value of the Posted Paymemts field';
                    ApplicationArea = All;
                    Visible = false;
                }
                //PRJ-889.GK.1.0 13Sep2021 end

            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        RecordExists := true;
        WorkPreviousPayments := NS_LastTotal(Rec);
        if ProgressPaymentHeader.GET("NS_Progress Payment No.", "NS_Requisition No.", "NS_Version No.") then;
        "NS_Job No." := ProgressPaymentHeader."NS_Job No.";
        "NS_Subcontract No." := ProgressPaymentHeader."NS_Subcontract No.";
        TaskName := '';
        if JobTask.GET("NS_Job No.", "NS_Job Task No.") then
            TaskName := JobTask.Description;
    end;

    trigger OnInit();
    begin
        PaymentMethodEditable := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        RecordExists := true;
    end;

    trigger OnModifyRecord(): Boolean;
    var
        ProgressPaymentLine: Record "NS_Progress Payment Line";
        PrevTotal: Decimal;
    begin
        ProgressPaymentHeader.GET("NS_Progress Payment No.", "NS_Requisition No.", "NS_Version No.");
        if ProgressPaymentHeader.NS_Status >= ProgressPaymentHeader.NS_Status::Invoiced then
            ERROR(Text001Lbl);

        //Update all latter requisitions with any updated information
        PrevTotal := Rec.NS_Total;
        with ProgressPaymentLine do begin
            RESET;
            SETRANGE("NS_Progress Payment No.", Rec."NS_Progress Payment No.");
            SETFILTER("NS_Requisition No.", '>%1', Rec."NS_Requisition No.");
            SETRANGE("NS_Line No.", Rec."NS_Line No.");
            if FINDSET then
                repeat
                    //Read the header to be sure it is not void
                    ProgressPaymentHeader.GET("NS_Progress Payment No.", "NS_Requisition No.", "NS_Version No.");
                    if ProgressPaymentHeader.NS_Status <> ProgressPaymentHeader.NS_Status::Void then begin
                        if (ProgressPaymentHeader.NS_Status = ProgressPaymentHeader.NS_Status::Open) and
                           (ProgressPaymentHeader.NS_Final = false) then begin
                            "NS_Work Amount" := NS_Total - PrevTotal;
                            "NS_Work Retention Amount" := ROUND("NS_Work Amount" * ("NS_Work Retention Percent" / 100), 0.01);
                            "NS_Material Retention Amount" := ROUND("NS_Stored Materials Amount" * ("NS_Material Retention Percent" / 100), 0.01);
                            MODIFY;
                        end;
                        PrevTotal := NS_Total;
                    end;
                until NEXT = 0;
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        RecordExists := false;
        WorkPreviousPayments := 0;
        if ProgressPaymentHeader.GET("NS_Progress Payment No.", "NS_Requisition No.", "NS_Version No.") then;
        "NS_Job No." := ProgressPaymentHeader."NS_Job No.";
        "NS_Subcontract No." := ProgressPaymentHeader."NS_Subcontract No.";
        TaskName := '';
    end;

    var
        JobPlanningLine: Record "Job Planning Line";
        ProgressPaymentHeader: Record "NS_Progress Payment Header";
        Job: Record Job;
        JobTask: Record "Job Task";
        WorkPreviousPayments: Decimal;
        TaskName: Text[100];//PRJ-1652.GK.1.0 03Oct2022 |Increase length by 100
        RecordExists: Boolean;
        [InDataSet]
        PaymentMethodEditable: Boolean;
        Text001Lbl: Label 'This requisition has had a receivables document generated.\There can be no further changes to this version.\Make a new version if changes are needed.';
        Text002Lbl: Label 'Category %1 does not exist in job budget for job %2';
        Text003Lbl: Label 'A value cannot be entered here because a retainage percent value has been entered for the entire requisition.';
        Text004Lbl: Label 'There is no work contract for this Category abd APO on this job.';
        Text005Lbl: Label 'Job Task %1 does not exist for Job %2';

    procedure NS_GetData(Final: Boolean);
    begin
        if "NS_Item No." = '' then begin
            if JobPlanningLine.GET("NS_Subcontract No.", "NS_Job No.", "NS_Line No.") then
                "NS_Item No." := JobPlanningLine.Description
            else
                "NS_Item No." := '';
        end;

        if "NS_Payment Method" = 0 then
            if JobPlanningLine.GET("NS_Subcontract No.", "NS_Job No.", "NS_Line No.") then
                "NS_Payment Method" := JobPlanningLine."NS_Progress Payment Method";

        JobPlanningLine.RESET;
        if JobPlanningLine.GET(Rec."NS_Subcontract No.", Rec."NS_Job No.", Rec."NS_Line No.") then begin
            //PRJ-1652.GK.1.0 29Sept2022 start
            // if Rec."NS_Task Description" = '' then
            //     Rec."NS_Task Description" := JobPlanningLine.Description;
            if Rec."NS_Task Description New" = '' then
                Rec."NS_Task Description New" := JobPlanningLine.Description;
            //PRJ-1652.GK.1.0 29Sept2022 end
            Rec."NS_Payment Method" := JobPlanningLine."NS_Progress Payment Method";
            if Rec."NS_Payment Method" = Rec."NS_Payment Method"::Unit then begin
                Rec."NS_Base Amount" := JobPlanningLine."Unit Price"; 
                if JobPlanningLine.Quantity < 0 then
                    Rec."NS_Base Amount" := Rec."NS_Base Amount" * -1;
            end else begin
                Rec."NS_Base Amount" := JobPlanningLine."Total Price";
            end;
        end else
            if Final then
                ERROR(Text004Lbl);
    end;

    procedure NS_CheckDocument();
    begin
        ProgressPaymentHeader.GET("NS_Progress Payment No.", "NS_Requisition No.", "NS_Version No.");
        if ProgressPaymentHeader.NS_Status >= ProgressPaymentHeader.NS_Status::Invoiced then
            ERROR(Text001Lbl);
        TaskName := '';
        if JobTask.GET("NS_Job No.", "NS_Job Task No.") then
            TaskName := JobTask.Description;
    end;

    local procedure NS_SubcontractNoOnAfterValidate();
    begin
        Job.CorrectForBlankFields("NS_Job No.", "NS_Subcontract No.", "NS_Cost Category", "NS_Cost Category", "NS_Job Task No.");
    end;

    local procedure NS_CostCategoryOnAfterValidate();
    begin
        Job.CorrectForBlankFields("NS_Job No.", "NS_Subcontract No.", "NS_Cost Category", "NS_Cost Category", "NS_Job Task No.");
    end;

    local procedure NS_SubcontractTaskNoOnAfterValidate();
    begin
        Job.CorrectForBlankFields("NS_Job No.", "NS_Subcontract No.", "NS_Cost Category", "NS_Cost Category", "NS_Job Task No.");
    end;

    local procedure NS_QuantityOnAfterValidate();
    begin
        CurrPage.UPDATE;
    end;

    local procedure NS_TotalOnAfterValidate();
    begin
        CurrPage.UPDATE;
    end;

    local procedure NS_PaymentMethodOnActivate();
    begin
        if WorkPreviousPayments = 0 then
            PaymentMethodEditable := true
        else
            PaymentMethodEditable := false;
    end;

    local procedure NS_BaseAmountOnActivate();
    begin
        if RecordExists then
            PaymentMethodEditable := false
        else
            PaymentMethodEditable := true;
    end;
}

