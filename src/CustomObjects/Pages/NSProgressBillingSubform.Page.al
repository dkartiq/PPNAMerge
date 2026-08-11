page 14021326 "NS_Progress Billing Subform"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +  - Base Amount  Non editable CTSI-18 -MS
    // +  - GLEI-11.MS.1.0001 added 4 new fields
    //     - calculation of previous work unit 
    //PRJ-203:AS:21APRIL2020 : Duplicated GLEI-11  & CTSI-18
    //CTSI-41.AS.1.0 21MAY2020 Added Revenue Category Description Field.
    //TM-10.AM.1.0 | Added Field.
    //PRJ-464.AM.1.0 | Added code to validate Current work unit when Values is entered in NS_Total first.
    // +------------------------------------------------------------
    //PRJ-492.RS.1.0 11May2021 | Hide/Unhide Fields
    //PRJ-999.JS.1.0 09Nov2021 | Add fields and Action
    //PRJ-1519.NK.1.0 10Aug2022 | Add Fields
    AutoSplitKey = true;
    Caption = 'Progress Billing Subform';
    PageType = ListPart;
    SourceTable = "NS_Progress Billing Line";
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
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';

                    trigger OnValidate();
                    begin
                        NS_CheckDocument;
                        NS_JobNoOnAfterValidate;
                    end;
                }
                //TM-32.AM.1.0
                field("NS_Segment Name"; "NS_Segment Name")
                {
                    ApplicationArea = all;
                    Visible = false; //PRJ-492.AS.1.0 Doubt

                }
                //TM-32.AM.1.0

                field("Revenue Category"; Rec."NS_Revenue Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Revenue Category';
                    Visible = false; //PRJ-492.AS.1.0

                    trigger OnValidate();
                    var
                        OK: Boolean;
                    begin
                        OK := false;
                        JobPlanningLine.RESET();
                        JobPlanningLine.SETRANGE("Job No.", "NS_Job No.");
                        JobPlanningLine.SETFILTER("NS_Entry Type", '%1|%2', JobPlanningLine."NS_Entry Type"::Both, JobPlanningLine."NS_Entry Type"::Price);
                        if JobPlanningLine.FINDSET then
                            repeat
                                if JobPlanningLine."NS_Revenue Category" = "NS_Revenue Category" then
                                    OK := true;
                            until (JobPlanningLine.NEXT = 0) or OK;

                        if OK then begin
                            NS_CheckDocument;
                            NS_GetData(false);
                        end else
                            ERROR(Text002Lbl, "NS_Revenue Category", "NS_Job No.");
                        NS_RevenueCategoryOnAfterValidate;
                    end;
                }
                //CTSI-41.AS.1.0 21MAY2020 - START
                field("NS_Revenue Cat Description"; REC."NS_Revenue Cat Description")
                {
                    ApplicationArea = all;
                    Description = 'Specifies Revenue Category Description';

                    trigger OnValidate()
                    var
                        ProgBillLine_L: Record "NS_Progress Billing Line";
                    begin
                        ProgBillLine_L.Reset;
                        ProgBillLine_L.SetRange("NS_Progress Billing No.", Rec."NS_Progress Billing No.");
                        ProgBillLine_L.SetRange("NS_Requisition No.", Rec."NS_Requisition No.");
                        ProgBillLine_L.SetRange("NS_Version No.", rec."NS_Version No.");
                        ProgBillLine_L.SetRange("NS_Revenue Category", rec."NS_Revenue Category");
                        if ProgBillLine_L.FindSet then
                            repeat
                                ProgBillLine_L."NS_Revenue Cat Description" := Rec."NS_Revenue Cat Description";
                                ProgBillLine_L.Modify();
                                CurrPage.Update(false);
                            until ProgBillLine_L.Next = 0;
                    end;
                }
                //CTSI-41.AS.1.0 21MAY2020 - END
                field("Job Task No."; Rec."NS_Job Task No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Task No.';
                    Visible = true;

                    trigger OnValidate();
                    begin
                        NS_CheckDocument;
                        NS_GetData(false);
                        NS_JobTaskNoOnAfterValidate;
                    end;
                }
                field("Segment Code"; Rec."NS_Segment Code")
                {
                    ApplicationArea = all;
                    Description = 'TM-10.AM.1.0';
                    // Visible = false; //PRJ-492.AS.1.0 //PRJ-492.RS.1.0 25May2021 Comment
                    Visible = true;//PRJ-492.RS.1.0 25May2021
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';

                    trigger OnValidate();
                    begin
                        NS_CheckDocument;
                    end;
                }
                field("Billing Method"; Rec."NS_Billing Method")
                {
                    ApplicationArea = All;
                    //Editable = "Billing MethodEditable";//PRJ-992.AS.1.0 Commented
                    Editable = false;//PRJ-992.AS.1.0 Added False editable
                    ToolTip = 'Specifies the Billing Method';
                }
                field("Contract Quantity"; Rec."NS_Contract Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Contract Quantity';
                    Visible = false;
                    Editable = false;//PRJ-992.AS.1.0 Added False editable
                }
                field("Base Amount"; Rec."NS_Base Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Base Amount';
                    Editable = false;    //CTSI-19 - MS 3-19-2020 //PRJ-203:AS:21APRIL2020//Doubt
                }
                field(Quantity; Rec.NS_Quantity)
                {
                    ApplicationArea = All;
                    DecimalPlaces = 2 : 6;
                    ToolTip = 'Specifies the Quantity';

                    trigger OnValidate();
                    begin
                        NS_CheckDocument;
                        if "NS_Work Amount" <> 0 then //PRJ-464.AM.1.0
                            "NS_Current Work Unit" := NS_Quantity - NS_GetPreviousWorkunit(rec) //GLEI-11.MS.1.0001	//PRJ-203:AS:21APRIL2020
                        else //PRJ-464.AM.1.0
                            "NS_Current Work Unit" := 0; //PRJ-464.AM.1.0
                        NS_QuantityOnAfterValidate;
                    end;
                }
                field("Unit of Measure Code"; Rec."NS_Unit of Measure Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'unit of Measure Code';
                    Editable = false;
                    Description = 'GLEI-11.MS.1.0001,//PRJ-203:AS:21APRIL2020';//PRJ-492.RS.1.0 11May2021 Copy & Past from another place
                }
                field(Total; Rec.NS_Total)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total';

                    trigger OnValidate();
                    begin
                        NS_CheckDocument;
                        //PRJ-464.AM.1.0 Start
                        if "NS_Work Amount" <> 0 then
                            "NS_Current Work Unit" := NS_Quantity - NS_GetPreviousWorkunit(rec)
                        else
                            "NS_Current Work Unit" := 0;
                        //PRJ-464.AM.1.0 End
                        NS_TotalOnAfterValidate;
                    end;
                }
                field(WorkPreviousBillings; WorkPreviousBillings)
                {
                    ApplicationArea = All;
                    Caption = 'Work Previous Billings';

                    ToolTip = 'Work Previous Billings';
                    Editable = false;
                }
                field("Work Amount"; Rec."NS_Work Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Amount';
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
                //PRJ-1519.NK.1.0 12Sep2022 Start
                field(StorePreviousBillings; StorePreviousBillings)
                {
                    ApplicationArea = All;
                    Caption = 'Store Previous Billings';

                    ToolTip = 'Store Previous Billings';
                    Editable = false;
                }
                //PRJ-1519.NK.1.0 12Sep2022 End
                field("Material Retention Percent"; Rec."NS_Material Retention Percent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Material Retention Percent';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        NS_CheckDocument;
                        if ProgressBillingHeader."NS_Material Retention Percent" <> 0 then
                            ERROR(Text003Lbl)
                        else
                            "NS_Material Retention Amount" := ROUND(("NS_Material Retention Percent" / 100) * "NS_Stored Materials Amount", 0.01);
                    end;
                }
                field("Scheduled Values"; Rec."NS_Scheduled Values")
                {
                    ApplicationArea = all;
                    Description = 'GLEI-11.MS.1.0001,//PRJ-203:AS:21APRIL2020';
                    ToolTip = 'Scheduled Values';
                    Visible = false;//PRJ-492.RS.1.0 11May2021

                }
                field(PreviousWorkUnit; PreviousWorkUnit)
                {
                    ApplicationArea = all;
                    Caption = 'Previous Work Unit';

                    ToolTip = 'Previous Work Unit';
                    Editable = false;
                    Description = 'GLEI-11.MS.1.0001,//PRJ-203:AS:21APRIL2020';
                }
                field("Current Work Unit"; Rec."NS_Current Work Unit")
                {
                    ApplicationArea = all;
                    ToolTip = 'Current work Unit';
                    Description = 'GLEI-11.MS.1.0001,//PRJ-203:AS:21APRIL2020';
                }
                field("Work Retention Percent"; Rec."NS_Work Retention Percent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Retention Percent';
                    Visible = true;//PRJ-492.RS.1.0 11May2021

                    trigger OnValidate();
                    begin
                        NS_CheckDocument;
                        if ProgressBillingHeader."NS_Work Retention Percent" <> 0 then
                            ERROR(Text003Lbl)
                        else begin
                            if not ProgressBillingHeader."NS_Multiple Retention on Lines" then begin //PRJ-1624.NK.1.0 07Nov2022
                                if Rec."NS_Work Amount" <> 0 then //PRJ-1131.NK.1.0
                                    Rec."NS_Work Retention Amount" := ROUND((Rec."NS_Work Retention Percent" / 100) * Rec."NS_Work Amount", 0.01) //PRJ-1131.NK.1.0
                                else
                                    Rec."NS_Work Retention Amount" := ROUND((Rec."NS_Work Retention Percent" / 100) * Rec.NS_Total, 0.01); //PRJ-1131.NK.1.0

                                //PRJ-1648.PS.1.0 14Dec2022 Start
                                if ProgressBillingHeader."NS_R_Reduction & Invoicing" then
                                    Rec."NS_Work Retention Amount" := ROUND((Rec."NS_Work Retention Percent" / 100) * Rec.NS_Total, 0.01);
                                //PRJ-1648.PS.1.0 14Dec2022 End 

                            end; //PRJ-1624.NK.1.0 07Nov2022
                        end;
                    end;
                }
                field("Work Retention Amount"; Rec."NS_Work Retention Amount")//PRJ-492.RS.1.0 11May2021
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Retention Amount';
                }
                //PRJ-1519.NK.1.0 10Aug2022 Start
                field("NS_Stored Material Retention %"; Rec."NS_Stored Material Retention %")
                {
                    ApplicationArea = all;
                    ToolTip = 'Stored Material Retention Percentage';
                    trigger OnValidate()
                    begin
                        if ProgressBillingHeader."NS_Material Retention Percent" <> 0 then
                            ERROR(Text003Lbl)
                    end;
                }
                field("NS_Stored Material Retention Amt"; Rec."NS_Stored Mat. Retention Amt")
                {
                    ApplicationArea = all;
                    ToolTip = 'Stored Material Retention Amount';
                }
                //PRJ-1519.NK.1.0 10Aug2022 End
                field("Planing Line No."; Rec."NS_Planing Line No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Planning Line No.';
                    Editable = false;
                    Description = 'GLEI-11.MS.1.0001,//PRJ-203:AS:21APRIL2020';
                    //Visible = false; //PRJ-492.AS.1.0 //Doubt//PRJ-492.RS.1.0 11May2021 comment
                    Visible = true;//PRJ-492.RS.1.0 11May2021
                }
                //PRJ-999.JS.1.0 09Nov2021 - Start
                field("NS_Shortcut Dimension 1 Code"; Rec."NS_Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NS_Shortcut Dimension 2 Code"; Rec."NS_Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                //PRJ-999.JS.1.0 09Nov2021 - end                

                //PRJ-1708.JS.1.0 12DEC2022 - Start
                field("NS_Contract Forecast Date"; Rec."NS_Contract Forecast Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the value of the Contract Forecaset Date field.';
                }
                field("NS_Change Order"; Rec."NS_Change Order")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the value of the _Change Order field.';
                }
                //PRJ-1708.JS.1.0 12DEC2022 - end
                // PRJCTPR-174.PS.1.0 10Aug2023 Start
                field("NS_PreviousRetPer %"; Rec."NS_PreviousRetPer %")
                {
                    ApplicationArea = all;
                }
                // PRJCTPR-174.PS.1.0 10Aug2023 End
            }
        }
    }

    actions
    {
        //PRJ-999.JS.1.0 09Nov2021 Start
        area(processing)
        {
            group(Line)
            {
                Caption = 'Line';
                action(NS_Dimensions)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions';

                    ToolTip = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction();
                    begin
                        Rec.ShowDimensions()
                    end;
                }
            }
        }
        //PRJ-999.JS.1.0 09Nov2021 end         
    }

    trigger OnAfterGetRecord();
    begin
        RecordExists := true;
        WorkPreviousBillings := Rec.NS_LastTotal(Rec);
        StorePreviousBillings := Rec.NS_LastStotrBilling(Rec); //PRJ-1519.NK.1.0 12Sep2022
        PreviousWorkUnit := Rec.NS_GetPreviousWorkunit(rec); //GLEI-11.MS.1.0001 //PRJ-203:AS:21APRIL2020
        Rec."NS_PreviousRetPer %" := Rec.NS_GetPreviousRetetionkunit(Rec); //PRJCTPR-174.PS.1.0 10Aug2023
        if ProgressBillingHeader.GET(Rec."NS_Progress Billing No.", Rec."NS_Requisition No.", Rec."NS_Version No.") then;
    end;

    trigger OnInit();
    begin
        "Billing MethodEditable" := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        RecordExists := true;
    end;

    trigger OnModifyRecord(): Boolean;
    var
        ProgressBillingLine: Record "NS_Progress Billing Line";
        PrevTotal: Decimal;
    begin
        ProgressBillingHeader.GET("NS_Progress Billing No.", "NS_Requisition No.", "NS_Version No.");
        if ProgressBillingHeader."NS_Sales Document No." > '' then
            ERROR(Text001Lbl);

        //Update all latter requisitions with any updated information
        PrevTotal := Rec.NS_Total;
        with ProgressBillingLine do begin
            RESET;
            SETRANGE("NS_Progress Billing No.", Rec."NS_Progress Billing No.");
            SETFILTER("NS_Requisition No.", '>%1', Rec."NS_Requisition No.");
            SETRANGE("NS_Line No.", Rec."NS_Line No.");
            if FINDSET then
                repeat
                    //Read the header to be sure it is not void
                    ProgressBillingHeader.GET("NS_Progress Billing No.", "NS_Requisition No.", "NS_Version No.");
                    if ProgressBillingHeader.NS_Status <> ProgressBillingHeader.NS_Status::Void then begin
                        if (ProgressBillingHeader.NS_Status = ProgressBillingHeader.NS_Status::Open) and
                           (ProgressBillingHeader.NS_Final = false) then begin
                            "NS_Work Amount" := NS_Total - PrevTotal;
                            "NS_Work Retention Amount" := ROUND("NS_Work Amount" * ("NS_Work Retention Percent" / 100), 0.01);
                            "NS_Material Retention Amount" := ROUND("NS_Stored Materials Amount" * ("NS_Material Retention Percent" / 100), 0.01);
                            MODIFY();
                        end;
                        PrevTotal := NS_Total;
                    end;
                until NEXT() = 0;
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        RecordExists := false;
        WorkPreviousBillings := 0;
        StorePreviousBillings := 0; //PRJ-1519.NK.1.0 12Sep2022
        PreviousWorkUnit := 0; //PRJ-203:AS:21APRIL2020
        PreviousRetUnit := 0;//PRJCTPR-174.PS.1.0 10Aug2023
    end;
    //PE-118.NC.1.0 07Aug2023 Start
    trigger OnDeleteRecord(): Boolean
    begin
        ProgressBillingHeader.GET(Rec."NS_Progress Billing No.", Rec."NS_Requisition No.", Rec."NS_Version No."); //PRJ-1131.NK.1.0
        if ProgressBillingHeader."NS_Sales Document No." > '' then
            ERROR(Text001Lbl);
    end;
    //PE-118.NC.1.0 07Aug2023 End

    var
        JobPlanningLine: Record "Job Planning Line";
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        Job: Record Job;
        WorkPreviousBillings: Decimal;
        StorePreviousBillings: Decimal; //PRJ-1519.NK.1.0 12Sep2022
        PreviousWorkUnit: Decimal; //PRJ-203:AS:21APRIL2020
        PreviousRetUnit: Decimal; //PRJCTPR-174.PS.1.0 10Aug2023
        RecordExists: Boolean;
        [InDataSet]
        "Billing MethodEditable": Boolean;
        Text001Lbl: Label 'This requisition has had a receivables document generated.\There can be no further changes to this version.\Make a new version if changes are needed.';
        Text002Lbl: Label 'Category %1 does not exist in job budget for job %2';
        Text003Lbl: Label 'A value cannot be entered here because a retainage percent value has been entered for the entire requisition.';
        Text004Lbl: Label 'There is no work contract for this Category abd APO on this job.';
        Text005Lbl: Label 'A value cannot be entered here because a Material retainage percent value has been entered for the entire requisition.'; //PRJ-1519.NK.1.0 30Aug2022

    procedure NS_GetData(Final: Boolean);
    begin
        if "NS_Item No." = '' then begin
            if JobPlanningLine.GET("NS_Job No.", "NS_Job Task No.", "NS_Line No.") then
                "NS_Item No." := JobPlanningLine.Description
            else
                "NS_Item No." := '';
        end;

        if "NS_Billing Method" = 0 then
            if JobPlanningLine.GET("NS_Job No.", "NS_Job Task No.", "NS_Line No.") then
                "NS_Billing Method" := JobPlanningLine."NS_Progress Billing Method";

        JobPlanningLine.RESET;
        if JobPlanningLine.GET("NS_Job No.", "NS_Job Task No.", "NS_Line No.") then begin
            if NS_Description = '' then
                NS_Description := JobPlanningLine.Description;
            "NS_Billing Method" := JobPlanningLine."NS_Progress Billing Method";
            if "NS_Billing Method" = "NS_Billing Method"::Unit then begin
                "NS_Base Amount" := JobPlanningLine."Unit Price";
                if JobPlanningLine.Quantity < 0 then
                    "NS_Base Amount" := "NS_Base Amount" * -1;
            end else begin
                "NS_Base Amount" := JobPlanningLine."Total Price";
            end;
        end else
            if Final then
                ERROR(Text004Lbl);
    end;

    procedure NS_CheckDocument();
    begin
        ProgressBillingHeader.GET("NS_Progress Billing No.", "NS_Requisition No.", "NS_Version No.");
        if ProgressBillingHeader."NS_Sales Document No." > '' then
            ERROR(Text001Lbl);
    end;

    local procedure NS_JobNoOnAfterValidate();
    begin
        Job.CorrectForBlankFields("NS_Job No.", "NS_Job No.", "NS_Revenue Category", "NS_Revenue Category", "NS_Job Task No.");
    end;

    local procedure NS_RevenueCategoryOnAfterValidate();
    begin
        Job.CorrectForBlankFields("NS_Job No.", "NS_Job No.", "NS_Revenue Category", "NS_Revenue Category", "NS_Job Task No.");
    end;

    local procedure NS_JobTaskNoOnAfterValidate();
    begin
        Job.CorrectForBlankFields("NS_Job No.", "NS_Job No.", "NS_Revenue Category", "NS_Revenue Category", "NS_Job Task No.");
    end;

    local procedure NS_QuantityOnAfterValidate();
    begin
        CurrPage.UPDATE;
    end;

    local procedure NS_TotalOnAfterValidate();
    begin
        CurrPage.UPDATE;
    end;

    local procedure NS_BillingMethodOnActivate();
    begin
        if WorkPreviousBillings = 0 then
            "Billing MethodEditable" := true
        else
            "Billing MethodEditable" := false;
    end;

    local procedure NS_BaseAmountOnActivate();
    begin
        if RecordExists then
            "Billing MethodEditable" := false
        else
            "Billing MethodEditable" := true;
    end;
}

