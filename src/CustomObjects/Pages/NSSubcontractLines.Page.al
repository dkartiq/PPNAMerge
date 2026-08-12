page 14021301 "NS_Subcontract Lines"
{
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-274 VT1.0 21-05-20 Code Added
    //PRJ-383.N.S.1.0 16Sep2020 Remove direct unit cost field
    //PRJ-492.RS.1.0 11May2021 | Hide/Unhide Fields
    //PRJ-616.N.S.1.0 add task description when manually entry is inserted
    //PRJ-974.RM.1.0 09Oct2021 | Made field invisible from Page
    //PRJ-999.JS.1.0 01Nov2021 | Add fields
    //PRJ-1374.RM.1.0 13May2022 | Added a new field
    //PE-210.HS.1.0 23Nov2023| Add Code
    AutoSplitKey = true;
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "NS_Subcontract Lines";
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    // >> Upgrade
    SourceTableView = SORTING("NS_Subcontract No.", "NS_Line No.");
    // << Upgrade
    layout
    {
        area(content)
        {
            repeater(Control1100773000)
            {
                field(Type; Rec.NS_Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Type';
                }
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';
                }
                //PRJ-492.N.S.1.0 Start
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                //PRJ-492.N.S.1.0 End
                field(JobNo; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';

                    trigger OnValidate();
                    begin
                        NS_JobNoOnAfterValidate();
                    end;
                }
                field("Job Task No."; Rec."NS_Job Task No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Task No.';

                    trigger OnValidate();
                    begin
                        NS_JobTaskNoOnAfterValidate();
                    end;
                }
                field("Job Task Description"; Rec."NS_Job Task Description")
                {
                    ApplicationArea = All;
                    Caption = 'Task Description';
                    ToolTip = 'Specifies the Task Description';
                }
                field("Job Cost Category"; Rec."NS_Job Cost Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Cost Category';

                    trigger OnValidate();
                    begin
                        NS_JobCostCategoryOnAfterValidate();
                    end;
                }
                field("Starting Date"; Rec."NS_Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Starting Date';
                    Visible = false; //PRJ-492.AS.1.0 //Doubt
                }
                //PRJ-974.RM.1.0 09Oct2021 Start
                // field("Variant Code"; Rec."NS_Variant Code")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the Variant Code';
                //     Visible = false;  //PRJ-974.RM.1.0 09Oct2021
                // }
                ////PRJ-974.RM.1.0 09Oct2021 End

                //PRJ-492.N.S.1.0 Start
                // field(Description; Rec.NS_Description)
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the Description';
                // }
                //PRJ-492.N.S.1.0 End
                field(Quantity; Rec.NS_Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quantity';
                }
                field("Unit of Measure Code"; Rec."NS_Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit of Measure Code';
                }
                field("Direct Unit Cost"; Rec."NS_Direct Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Direct Unit Cost';
                    Visible = false;//PRJ-383.N.S.1.0 16Sep2020

                    trigger OnValidate();
                    begin
                        NS_DirectUnitCostOnAfterValidate();
                    end;
                }
                field("Unit Cost"; Rec."NS_Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit Cost';
                    StyleExpr = NS_color; //PE-210.HS.1.0 23Nov2023
                    //PE-210.HS.1.0 23Nov2023 Start
                    trigger OnValidate()
                    var
                        NS_JPL: Record "Job Planning Line";
                        NS_JobSetup: Record "Jobs Setup";
                    begin
                        Clear(NS_color);
                        if NS_JobSetup.Get() then;
                        if NS_JobSetup.NS_CostExceedsColor then begin
                            NS_JPL.Reset();
                            NS_JPL.SetRange("Job No.", rec."NS_Job No.");
                            NS_JPL.SetRange("Job Task No.", rec."NS_Job Task No.");
                            NS_JPL.SetRange("Line No.", rec."NS_JPL Line No.");
                            if NS_JPL.FindFirst() then begin
                                if rec."NS_Unit Cost" > NS_JPL."Unit Cost" then
                                    NS_color := 'Unfavorable'
                                else
                                    NS_color := 'standard';
                            end;
                        end;
                    end;
                    //PE-210.HS.1.0 23Nov2023 End
                }
                field("Total Cost"; Rec."NS_Total Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Cost';
                }
                field("Work Units"; Rec."NS_Work Units")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Units';
                    Visible = false; //PRJ-492.AS.1.0 //DOUBT
                }
                field("Work Unit of Measure"; Rec."NS_Work Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Unit of Measure';
                    Visible = false; //PRJ-492.AS.1.0 Doubt
                }
                //PRJ-974.RM.1.0 09Oct2021 Start
                // field("Progress Payment Method"; Rec."NS_Progress Payment Method")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the Progress Payment Method';
                //     Visible = false; //PRJ-492.AS.1.0 //Doubt
                // }

                // field("Base Amount"; Rec."NS_Base Amount")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the Base Amount';
                //     Visible = false; //PRJ-492.AS.1.0 //Doubt //PRJ-974.RM.1.0 09Oct2021
                // }
                //PRJ-974.RM.1.0 09Oct2021 End
                //PRJ-274 VT1.0 21-05-20 begin
                field("PO No."; Rec."NS_PO No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the PO No.';
                }
                field("PO Line No."; Rec."NS_PO Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the PO Line No.';
                    //Visible = false; //PRJ-492.AS.1.0  //Doubt//PRJ-492.RS.1.0 11May2021 Comment
                    Visible = true;//PRJ-492.RS.1.0 11May2021
                }
                //PRJ-274 VT1.0 21-05-20 end
                //PRJ-999.JS.1.0 01Nov2021-Start
                field("NS_Shortcut Dimension 1 Code"; Rec."NS_Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                    ApplicationArea = All;
                }
                field("NS_Shortcut Dimension 2 Code"; Rec."NS_Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                    ApplicationArea = All;
                }
                //PRJ-999.JS.1.0 01Nov2021-end              
                //PRJ-1374.RM.1.0 start
                field("NS_Location Code"; Rec."NS_Location Code")
                {

                    ToolTip = 'Specifies the Location Code';
                    ApplicationArea = all;

                }
                //PRJ-1374.RM.1.0 end
                //PE-177.DK.1.0 10Nov2023 Start
                field("NS_Change Request No."; Rec."NS_Change Request No.")
                {
                    Caption = 'Change Request No.';
                    ApplicationArea = all;
                    Editable = false;
                }
                //PE-177.DK.1.0 10Nov2023  End
                //PRJCTPR-237 AT.0.1 12Dec2023 Start
                field("NS_Segment Code"; rec."NS_Segment Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the segment code.';
                }
                //PRJCTPR-237 AT.0.1 12Dec2023 END
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Line)
            {
                Caption = 'Line';
                action("NS_Show Vendor Insurance")
                {
                    ApplicationArea = All;
                    Caption = 'Show Vendor Insurance';

                    ToolTip = 'Show Vendor Insurance';
                    Image = ServiceAgreement;

                    trigger OnAction();
                    begin

                        NS_ShowVendorInsurance();
                    end;
                }
                action(NS_Dimensions)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions';

                    ToolTip = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction();
                    begin
                        ShowDimensions()
                    end;
                }
            }
        }
    }
    //PE-210.HS.1.0 23Nov2023 Start
    trigger OnAfterGetRecord()
    var
        NS_JPL: Record "Job Planning Line";
        NS_JobSetup: Record "Jobs Setup";
    begin
        Clear(NS_color);
        if NS_JobSetup.Get() then;
        if NS_JobSetup.NS_CostExceedsColor then begin
            NS_JPL.Reset();
            NS_JPL.SetRange("Job No.", rec."NS_Job No.");
            NS_JPL.SetRange("Job Task No.", rec."NS_Job Task No.");
            NS_JPL.SetRange("Line No.", rec."NS_JPL Line No.");
            if NS_JPL.FindFirst() then begin
                if rec."NS_Unit Cost" > NS_JPL."Unit Cost" then
                    NS_color := 'Unfavorable'
                else
                    NS_color := 'standard';
            end;
        end;
    end;
    //PE-210.HS.1.0 23Nov2023 End

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        if Subcontract.GET("NS_Subcontract No.") then begin
            "NS_Dimension Set ID" := Subcontract."NS_Dimension Set ID";
            // "NS_Job No." := Subcontract."NS_Job No.";//PE-137.DK.1.0 26July2023 code commenting right on type validation
        end;
    end;

    var
        Job: Record Job;
        JobPlanningLine: Record "Job Planning Line";
        Subcontract: Record NS_Subcontract;
        NS_color: text; //PE-210.HS.1.0 23Nov2023
        //PE-177.DK.3.0 23Jan2024 Start
        NSNo: Code[20];
        Change_Order: Boolean;
    //PE-177.DK.3.0 23Jan2024 End
    // DimMgt: Codeunit DimensionManagement;
    // DocumentType: Label 'Subcontract';

    procedure NS_ShowVendorInsurance();
    begin
        Rec.ShowVendorInsurance
    end;

    // procedure ShowVendorInsurance();
    // begin
    //     Rec.ShowVendorInsurance
    // end;

    local procedure NS_JobNoOnAfterValidate();
    begin
        Job.CorrectForBlankFields("NS_Job No.", "NS_Subcontract No.", "NS_Job Cost Category", "NS_Job Cost Category", "NS_Job Task No.");
    end;

    local procedure NS_JobTaskNoOnAfterValidate();
    var
        JobTaskRec: Record "Job Task";//PRJ-616.N.S.1.0
        JobSetup: Record "Jobs Setup";  //PRJCTPR-380.DK.2.0 3May2024
        NS_JobTaskDim: Record "Job Task Dimension";
        NS_DimSetEnt: Record "Dimension Set Entry";
        NS_Job: Record Job;
        NS_DefaultDim: Record "Default Dimension";
    begin
        Job.CorrectForBlankFields("NS_Job No.", "NS_Subcontract No.", "NS_Job Cost Category", "NS_Job Cost Category", "NS_Job Task No.");

        "NS_Job Task Description" := '';

        JobPlanningLine.RESET();
        JobPlanningLine.SETRANGE("Job No.", "NS_Job No.");
        JobPlanningLine.SETRANGE("Job Task No.", "NS_Job Task No.");
        if JobPlanningLine.FINDFIRST() then
            "NS_Job Task Description" := JobPlanningLine.Description;
        //PRJ-616.N.S.1.0 Start
        if "NS_Job Task Description" = '' then begin

            if JobTaskRec.get(Rec."NS_Job No.", Rec."NS_Job Task No.") then
                "NS_Job Task Description" := JobTaskRec.Description
            else
                "NS_Job Task Description" := '';
        end;
        //PRJ-616.N.S.1.0 END
        //PRJCTPR-380.DK.2.0 3May2024 Start
        if JobSetup.Get() then;
        if JobTaskRec.get(Rec."NS_Job No.", Rec."NS_Job Task No.") then;
        if NS_Job.Get(Rec."NS_Job No.") then;
        if JobSetup."NS_Flow Job Card Dimension" then begin
            if (JobTaskRec."Global Dimension 1 Code" <> '') AND (JobTaskRec."Global Dimension 2 Code" <> '') then begin
                Rec.Validate("NS_Shortcut Dimension 1 Code", JobTaskRec."Global Dimension 1 Code");
                Rec.Validate("NS_Shortcut Dimension 2 Code", JobTaskRec."Global Dimension 2 Code");
                Rec.Modify();
                NS_JobTaskDim.Reset();
                NS_JobTaskDim.SetRange("Job No.", Rec."NS_Job No.");
                NS_JobTaskDim.SetRange("Job Task No.", Rec."NS_Job Task No.");
                if NS_JobTaskDim.FindSet() then
                    repeat
                        NS_DimSetEnt."Dimension Set ID" := Rec."NS_Dimension Set ID";
                        NS_DimSetEnt.Validate("Dimension Code", NS_JobTaskDim."Dimension Code");
                        NS_DimSetEnt.Validate("Dimension Value Code", NS_JobTaskDim."Dimension Value Code");
                        NS_DimSetEnt.Modify();
                    until NS_JobTaskDim.Next() = 0;
            end else begin
                Rec.Validate("NS_Shortcut Dimension 1 Code", NS_Job."Global Dimension 1 Code");
                Rec.Validate("NS_Shortcut Dimension 2 Code", NS_Job."Global Dimension 2 Code");
                Rec.Modify();
                NS_DefaultDim.Reset();
                NS_DefaultDim.SetRange("No.", Rec."NS_Job No.");
                if NS_DefaultDim.FindSet() then
                    repeat
                        NS_DimSetEnt."Dimension Set ID" := Rec."NS_Dimension Set ID";
                        NS_DimSetEnt.Validate("Dimension Code", NS_DefaultDim."Dimension Code");
                        NS_DimSetEnt.Validate("Dimension Value Code", NS_DefaultDim."Dimension Value Code");
                        NS_DimSetEnt.Modify();
                    until NS_DefaultDim.Next() = 0;
            end;

        end
        //PRJCTPR-380.DK.2.0 3May2024 End
    end;

    local procedure NS_JobCostCategoryOnAfterValidate();
    begin
        Job.CorrectForBlankFields("NS_Job No.", "NS_Subcontract No.", "NS_Job Cost Category", "NS_Job Cost Category", "NS_Job Task No.");
    end;

    local procedure NS_DirectUnitCostOnAfterValidate();
    begin
        Rec."NS_Unit Cost" := Rec."NS_Direct Unit Cost"; //PRJ-1131.NK.1.0
        Rec.VALIDATE("NS_Unit Cost"); //PRJ-1131.NK.1.0
    end;

    //PE-177.DK.2.0 22Nov2023 Start
    /// <summary>
    /// NS_GetFromSubcontractChangeRequestLine.
    /// </summary>
    /// <param name="NS_No">Code[20].</param>
    /// <param name="NSLeveltoSubcontractNo">code[20].</param>
    /// <param name="ChangeReqNo">Code[20].</param>
    /// <param name="NSChangeOrdger">Boolean.</param>
    procedure NS_GetFromSubcontractChangeRequestLine(NS_No: Code[20]; NSLeveltoSubcontractNo: code[20]; ChangeReqNo: Code[20]; NSChangeOrdger: Boolean);
    var
        NS_SubconLine: Record "NS_Subcontract Lines";
        NS_PassSubconLine: Record "NS_Subcontract Lines";
        NS_SubconLineNew: Record "NS_Subcontract Lines";
        LastLineNo: Integer;
        NS_count: Integer;
    begin
        NS_count := 0;
        LastLineNo := 0;
        NS_SubconLineNew.RESET();
        NS_SubconLineNew.SETRANGE("NS_Subcontract No.", NS_No);
        if NS_SubconLineNew.FINDSet() then begin
            NS_count := NS_SubconLineNew.Count + 1;
            LastLineNo := NS_count * 10000;
        end;
        NS_PassSubconLine.Reset();
        NS_PassSubconLine.SetRange("NS_Subcontract No.", ChangeReqNo);
        if NS_PassSubconLine.FINDfirst() then begin
            if NS_SubconLineNew."NS_Line No." = 0 then
                LastLineNo := 10000;
            repeat
                NS_SubconLine.Reset();
                NS_SubconLine.INIT();
                NS_SubconLine."NS_Subcontract No." := NS_No;
                NS_SubconLine."NS_Line No." := LastLineNo;
                NS_SubconLine.NS_Type := NS_PassSubconLine.NS_Type;
                NS_SubconLine.NS_Description := NS_PassSubconLine.NS_Description;
                NS_SubconLine."NS_No." := NS_PassSubconLine."NS_No.";
                NS_SubconLine."NS_Job Task Description" := NS_PassSubconLine."NS_Job Task Description";
                NS_SubconLine."NS_Job Cost Category" := NS_PassSubconLine."NS_Job Cost Category";
                NS_SubconLine.NS_Quantity := NS_PassSubconLine.NS_Quantity;
                NS_SubconLine."NS_Unit of Measure Code" := NS_PassSubconLine."NS_Unit of Measure Code";
                NS_SubconLine."NS_Unit Cost" := NS_PassSubconLine."NS_Unit Cost";
                NS_SubconLine."NS_Total Cost" := NS_PassSubconLine."NS_Total Cost";
                //PE-177.DK.3.0 23Jan2024 Start Please Remove This Line because no need to this code
                //NS_SubconLine."NS_PO No." := NS_PassSubconLine."NS_PO No.";
                //NS_SubconLine."NS_PO Line No." := NS_PassSubconLine."NS_PO Line No.";
                //PE-177.DK.3.0 23Jan2024 End
                NS_SubconLine."NS_Job No." := NS_PassSubconLine."NS_Job No.";
                NS_SubconLine."NS_Job Task No." := NS_PassSubconLine."NS_Job Task No.";
                NS_SubconLine."NS_Activity Code" := NS_PassSubconLine."NS_Activity Code";
                NS_SubconLine."NS_Process Code" := NS_PassSubconLine."NS_Process Code";
                NS_SubconLine."NS_Operation Code" := NS_PassSubconLine."NS_Operation Code";
                NS_SubconLine."NS_Change Request No." := ChangeReqNo;
                NS_SubconLine.Insert();
                LastLineNo := LastLineNo + 10000;
            until NS_PassSubconLine.Next() = 0;
        end;
    end;
    //PE-177.DK.2.0 22Nov2023 End
}

