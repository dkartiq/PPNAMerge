pageextension 14021240 NS_ReqWorksheet extends "Req. Worksheet"
{
    // version NAVW111.00.00.19846,NAVNA11.00.00.19846,PPNA11.00
    //PRJ-58.SK.1.0 Added customised "CarryOutActionMessage" Action on this page.
    //TM-10.AM.1.0 | Added Field.
    //PRJ-492.RS.1.0 25May2021 | Hide/Unhide fields
    //PRJ-999.JS.1.0 10Nov2021 | Add code for dimension
    //PRJ-1148.JS.1.0 20JAN2022 | Correct code for item default dimension
    //PRJ-1380.NK.1.0 16May2022 | Added new fields
    //PRJ-1479.NK.1.0 29Jun2022 | ADDED CODE
    //PRJ-1579.RM.1.0  18Aug2022 | Added tooltip
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Requisition Worksheets'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        addafter(CurrentJnlBatchName)
        {
            field(NS_DocNo; DocNo)
            {
                ApplicationArea = All;
                Caption = 'Document No.';
                ToolTip = 'Specifies the Document no.'; //PRJ-1579.RM.1.0 
                // ToolTip = 'Document No.'; //PRJ-1579.RM.1.0  commented
            }
        }
        addafter("Transfer-from Code")
        {
            field("NS_Job No."; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';
            }
            field("NS_Job Task No."; Rec."NS_Job Task No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Task No.';
            }
            //PRJ-1380.NK.1.0 16May2022 Start
            field("NS_Job Manager"; Rec."NS_Job Manager")
            {
                ApplicationArea = All;
                // ToolTip = 'Job Manager'; //PRJ-1579.RM.1.0 commented
                // ToolTip = 'Specifies the Job manager'; //PRJ-1579.RM.1.0 //PRJ-1579.RM.2.0 commented
                ToolTip = 'Specifies the Job Manager'; //PRJ-1579.RM.2.0
                Caption = 'Job Manager';
                Description = 'PRJ-1380.NK.1.0';
                Editable = false;
            }
            field("NS_Job Purchaser"; Rec."NS_Job Purchaser")
            {
                ApplicationArea = All;
                // ToolTip = 'Job Purchaser'; //PRJ-1579.RM.1.0 commented
                ToolTip = 'Specifies the Job Purchaser'; //PRJ-1579.RM.1.0 
                Caption = 'Job Purchaser';
                Description = 'PRJ-1380.NK.1.0';
                Editable = false;
            }
            //PRJ-1380.NK.1.0 16May2022 end
            field("NS_Segment Code"; "NS_Segment Code")
            {
                ApplicationArea = All;
                Description = 'TM-10.AM.1.0';
                //Visible = false;//PRJ-492.AS.1.0 //PRJ-492.RS.1.0 25May2021 Comment
                Visible = true;//PRJ-492.RS.1.0 25May2021
                // ToolTip = 'Select the segment '; //PRJ-1579.RM.1.0 //PRJ-1579.RM.2.0 commented
                ToolTip = 'Select the Segment'; //PRJ-1579.RM.2.0 

            }
            //PRJCTPR-256.JS.1.0 15DEC2023 - Start
            field("NS_JMP Details"; Rec."NS_JMP Details")
            {
                caption = 'JMP Details';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the JMP Details field.';
            }
            //PRJCTPR-256.JS.1.0 15DEC2023 - Start
        }
    }
    actions
    {

        modify(CalculatePlan)
        {
            Visible = false;
            Enabled = false;
        }
        //PRJ-58.SK.1.0 Start
        modify(CarryOutActionMessage)
        {
            Visible = false;
            Enabled = false;
        }
        addafter(Reserve)
        {
            action(NS_CarryOutActionMessage)
            {
                Caption = 'Carry &Out Action Message';
                ToolTip = 'Use a batch job to help you create actual supply orders from the order proposals.';
                ApplicationArea = Planning;
                Image = CarryOutActionMessage;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Ellipsis = true;

                trigger OnAction()
                var
                    PerformAction: report "NS_Carry Out Act Msg. - Req.";

                begin
                    PerformAction.SetReqWkshLine(Rec);
                    PerformAction.RUNMODAL;
                    PerformAction.GetReqWkshLine(Rec);
                    //CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");

                    CurrPage.UPDATE(FALSE);
                end;

            }
        }
        //PRJ-58.SK.1.0 End


        addafter("F&unctions")
        {
            action(NS_CalculatePlan_Copy)
            {

                Ellipsis = true;
                Caption = 'PP Calculate Plan';
                ToolTip = 'Use a batch job to help you calculate a supply plan for items and stockkeeping units that have the Replenishment System field set to Purchase or Transfer.';
                ApplicationArea = Planning;
                Promoted = true;
                PromotedIsBig = true;
                Image = CalculatePlan;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    DocNo: Code[20];
                    JobsSetup: Record "Jobs Setup";
                    CalculatePlan: Report "NS_Calculate Plan - Req. Wksh.";
                    NS_UserSetup: Record "User Setup"; //PRJCTPR-93.NC.1.0 03May2023
                begin
                    //PRJ-1479.NK.1.0 29Jun2022 Start
                    //PRJCTPR-93.NC.1.0 03May2023 Start
                    //JobsSetup.GET;
                    //DocNo := JobsSetup."NS_Req JMP Doc. No.";
                    if NS_UserSetup.Get(UserId) then;
                    DocNo := NS_UserSetup."NS_Req JMP Doc. No.";
                    //PRJCTPR-93.NC.1.0 03May2023 End
                    // DocNo := '';
                    // JobMaterialPlan.Reset();
                    // JobMaterialPlan.SetFilter("NS_Req JMP Doc. No.", '<>%1', '');
                    // if JobMaterialPlan.FindFirst() then
                    //     DocNo := JobMaterialPlan."NS_Req JMP Doc. No.";
                    //PRJ-1479.NK.1.0 29Jun2022 End
                    //ProjectPro - start Modify
                    CalculatePlan.SetTemplAndWorksheet("Worksheet Template Name", "Journal Batch Name", DocNo);
                    //ProjectPro - end Modify
                    CalculatePlan.RUNMODAL;
                    CLEAR(CalculatePlan);
                end;
            }
        }
    }

    //PRJ-999.JS.1.0 10Nov2021 Start
    trigger OnNewRecord(BelowxRec: Boolean);
    var
        NS_Job: Record Job;
        JobTask1: Record "Job Task";
        NS_JobsSetup: Record "Jobs Setup";   //PRJ-1148.JS.1.0 20JAN2022
        NS_DefaultDim: Record "Default Dimension"; //PRJ-1148.JS.1.0 20JAN2022
        NS_Item: Record Item; //PRJ-1148.JS.1.0 20JAN2022
        NS_JobMatPlan: Record "NS_Job Material Planning";  //PRJ-1148.JS.1.0 20JAN2022
    begin
        //PRJ-1148.JS.1.0 20JAN2022 - Start
        NS_JobsSetup.Get();
        if NS_JobsSetup."NS_Flow Job Card Dimension" = true then begin
            //PRJ-1148.JS.1.0 20JAN2022 - end
            If Rec."NS_Job No." <> '' then
                If NS_Job.get(rec."NS_Job No.") then begin
                    Rec."Shortcut Dimension 1 Code" := NS_Job."Global Dimension 1 Code";
                    Rec."Shortcut Dimension 1 Code" := NS_Job."Global Dimension 2 Code";
                    Rec."Dimension Set ID" := rec.GetDimensionNoFromJob(NS_Job."No.");
                end;
            if JobTask1.GET(Rec."NS_Job No.", Rec."NS_Job Task No.") then
                IF ((JobTask1."Global Dimension 1 Code" <> '') and (JobTask1."Global Dimension 2 Code" <> '')) then begin
                    Rec."Shortcut Dimension 1 Code" := JobTask1."Global Dimension 1 Code";
                    Rec."Shortcut Dimension 2 Code" := JobTask1."Global Dimension 2 Code";
                    Rec."Dimension Set ID" := Rec.NS_GetDimensionNoFromJobTask(JobTask1."Job No.", JobTask1."Job Task No.");
                end;
            //PRJ-1148.JS.1.0 20JAN2022 - start        
        end else
            if NS_Job.get(Rec."NS_Job No.") then begin
                NS_DefaultDim.Reset();
                NS_DefaultDim.SetRange("Table ID", 27);
                NS_DefaultDim.SetRange("No.", Rec."No.");
                if NS_DefaultDim.IsEmpty() then begin
                    Rec."Shortcut Dimension 1 Code" := NS_Job."Global Dimension 1 Code";
                    Rec."Shortcut Dimension 2 Code" := NS_Job."Global Dimension 2 Code";
                    Rec."Dimension Set ID" := NS_JobMatPlan.GetDimensionNoFromJob(NS_Job."No.");
                    If JobTask1.get(Rec."NS_Job No.", Rec."NS_Job Task No.") then
                        IF ((JobTask1."Global Dimension 1 Code" <> '') and (JobTask1."Global Dimension 2 Code" <> '')) then begin
                            Rec."Shortcut Dimension 1 Code" := NS_Job."Global Dimension 1 Code";
                            Rec."Shortcut Dimension 2 Code" := NS_Job."Global Dimension 2 Code";
                            Rec."Dimension Set ID" := Rec.NS_GetDimensionNoFromJobTask(JobTask1."Job No.", JobTask1."Job Task No.");
                        end;
                end else
                    if NS_Job.get(Rec."NS_Job No.") then
                        if NS_Item.get(Rec."No.") then begin
                            Rec."Shortcut Dimension 1 Code" := NS_Item."Global Dimension 1 Code";
                            Rec."Shortcut Dimension 2 Code" := NS_Item."Global Dimension 2 Code";
                            Rec."Dimension Set ID" := NS_JobMatPlan.GetDimensionNoFromItemNo(NS_Item."No.");
                        end;
            end;
        Rec.ShowShortcutDimCode(ShortcutDimCode);
        //PRJ-1148.JS.1.0 20JAN2022 - end
    end;

    trigger OnAfterGetRecord();
    var
        NS_Job: Record Job;
        JobTask1: Record "Job Task";
        NS_JobsSetup: Record "Jobs Setup";   //PRJ-1148.JS.1.0 20JAN2022
        NS_DefaultDim: Record "Default Dimension"; //PRJ-1148.JS.1.0 20JAN2022
        NS_Item: Record Item; //PRJ-1148.JS.1.0 20JAN2022
        NS_JobMatPlan: Record "NS_Job Material Planning";  //PRJ-1148.JS.1.0 20JAN2022        
    begin
        //PRJ-1148.JS.1.0 20JAN2022 - Start
        NS_JobsSetup.Get();
        if NS_JobsSetup."NS_Flow Job Card Dimension" = true then begin
            //PRJ-1148.JS.1.0 20JAN2022 - end
            If Rec."NS_Job No." <> '' then
                If NS_Job.get(rec."NS_Job No.") then begin
                    Rec."Shortcut Dimension 1 Code" := NS_Job."Global Dimension 1 Code";
                    Rec."Shortcut Dimension 1 Code" := NS_Job."Global Dimension 2 Code";
                    Rec."Dimension Set ID" := rec.GetDimensionNoFromJob(NS_Job."No.");
                end;
            if JobTask1.GET(Rec."NS_Job No.", Rec."NS_Job Task No.") then
                IF ((JobTask1."Global Dimension 1 Code" <> '') and (JobTask1."Global Dimension 2 Code" <> '')) then begin
                    Rec."Shortcut Dimension 1 Code" := JobTask1."Global Dimension 1 Code";
                    Rec."Shortcut Dimension 2 Code" := JobTask1."Global Dimension 2 Code";
                    Rec."Dimension Set ID" := Rec.NS_GetDimensionNoFromJobTask(JobTask1."Job No.", JobTask1."Job Task No.");
                end;
            //PRJ-1148.JS.1.0 20JAN2022 - start        
        end else
            if NS_Job.get(Rec."NS_Job No.") then begin
                NS_DefaultDim.Reset();
                NS_DefaultDim.SetRange("Table ID", 27);
                NS_DefaultDim.SetRange("No.", Rec."No.");
                if NS_DefaultDim.IsEmpty() then begin
                    Rec."Shortcut Dimension 1 Code" := NS_Job."Global Dimension 1 Code";
                    Rec."Shortcut Dimension 2 Code" := NS_Job."Global Dimension 2 Code";
                    Rec."Dimension Set ID" := NS_JobMatPlan.GetDimensionNoFromJob(NS_Job."No.");
                    If JobTask1.get(Rec."NS_Job No.", Rec."NS_Job Task No.") then
                        IF ((JobTask1."Global Dimension 1 Code" <> '') and (JobTask1."Global Dimension 2 Code" <> '')) then begin
                            Rec."Shortcut Dimension 1 Code" := NS_Job."Global Dimension 1 Code";
                            Rec."Shortcut Dimension 2 Code" := NS_Job."Global Dimension 2 Code";
                            Rec."Dimension Set ID" := Rec.NS_GetDimensionNoFromJobTask(JobTask1."Job No.", JobTask1."Job Task No.");
                        end;
                end else
                    if NS_Job.get(Rec."NS_Job No.") then
                        if NS_Item.get(Rec."No.") then begin
                            Rec."Shortcut Dimension 1 Code" := NS_Item."Global Dimension 1 Code";
                            Rec."Shortcut Dimension 2 Code" := NS_Item."Global Dimension 2 Code";
                            Rec."Dimension Set ID" := NS_JobMatPlan.GetDimensionNoFromItemNo(NS_Item."No.");
                        end;
            end;
        Rec.ShowShortcutDimCode(ShortcutDimCode);
        //PRJ-1148.JS.1.0 20JAN2022 - end
    end;
    //PRJ-999.JS.1.0 10Nov2021 end
    PROCEDURE InitVar(lDocNo: Code[20]);
    BEGIN
        DocNo := lDocNo;
    END;

    var
        DocNo: Code[20];
        JobMaterialPlan: Record "NS_Job Material Planning"; //PRJ-1479.NK.1.0 29Jun2022

    trigger OnOpenPage()
    var
        JobsSetup: Record "Jobs Setup";
        NS_UserSetup: Record "User Setup"; //PRJCTPR-93.NC.1.0 03May2023
    begin
        //PRJ-1479.NK.1.0 29Jun2022 Start 
        //PRJCTPR-93.NC.1.0 03May2023 Start
        //JobsSetup.GET; 
        //DocNo := JobsSetup."NS_Req JMP Doc. No."; 
        if NS_UserSetup.Get(UserId) then;
        DocNo := NS_UserSetup."NS_Req JMP Doc. No.";
        //PRJCTPR-93.NC.1.0 03May2023 End
        // DocNo := '';
        // JobMaterialPlan.Reset();
        // JobMaterialPlan.SetFilter("NS_Req JMP Doc. No.", '<>%1', '');
        // if JobMaterialPlan.FindFirst() then
        //     DocNo := JobMaterialPlan."NS_Req JMP Doc. No.";
        //PRJ-1479.NK.1.0 29Jun2022 End
    end;

    //   +---------------------------------------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +     Job No.
    //   +     Job Task No.
    //   +     Document No.
    //   +
    //   +  - Added function(s):
    //   +     InitVar
    //   +
    //   +  - Added global variable(s):
    //   +     DocNo
    //   +     JobsSetup
    //   +
    //   +  - Added global text constant(s):
    //   +
    //   +  - Modification(s):
    //   +     - OnOpenPage - Read Job Setup record
    //   +                  - Set DocNo to JobsSetup.Req JMP Doc. No.
    //   +     - Added DocNo to call of CalculatePlan.SetTemplAndWorksheet
    //   +-----------------------------------------------------------------------------------------------

}

