report 14021330 "NS_Get Contact forProgressBill"
{
    //a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // + GLEI-11.MS.1.0001 added code for flow of thre fields	
    //PRJ-203:AS:21APRIL2020 : Duplicated GLEI-11
    //PRJ-301.AS.1.0 : Increased BudgetDesc length
    //TM-10.AM.1.0 | segment Code flow.
    ////PRJ-679.N.S.1.0 change contact to contract
    //PRJ-773.SK.1.0 | 24JUNE2021 | Added required events
    //PRJ-999.JS.1.0 09Nov2021 | Add Code for dimension
    // +------------------------------------------------------------
    //PRJ-1414.AS.1.0 25May2022 Created and Added event for CTSI

    Caption = 'Get Contract for Progress Bill';//PRJ-679.N.S.1.0 change contact to contract
    ProcessingOnly = true;

    dataset
    {
        dataitem(Job; Job)
        {
            RequestFilterFields = "No.", "NS_Progress Billing No.";

            trigger OnAfterGetRecord();
            begin
                //Find Last Line Number in Sales Line table for the Invoice
                with ProgressBillingLine do begin
                    RESET();
                    SETRANGE("NS_Progress Billing No.", ParamProgressBillNo);
                    SETRANGE("NS_Requisition No.", ParamRequisitionNo);
                    SETRANGE("NS_Version No.", ParamVersionNo);
                    if FINDLAST() then
                        LastLineNo := "NS_Line No."
                    else
                        LastLineNo := 0;
                end;

                ProcessJobBudget(Job);
                // >> Upgrade
                // if "NS_Progress Billing No." = '' then
                //     if CONFIRM(Text001, true, "No.", ParamProgressBillNo) then begin
                //         "NS_Progress Billing No." := ParamProgressBillNo;
                //         if CONFIRM(Text002, false, "No.", ParamProgressBillNo) then begin
                //             "NS_Progress Billing Sub-Level" := true;
                //         end;
                //         MODIFY();
                //     end;
                JobOnAfterGetRecord(Job, MasterJobNo, ParamProgressBillNo);
                // << Upgrade
                if "NS_Progress Billing No." = '' then
                    if CONFIRM(Text001, true, "No.", ParamProgressBillNo) then begin
                        "NS_Progress Billing No." := ParamProgressBillNo;
                        if CONFIRM(Text002, false, "No.", ParamProgressBillNo) then begin
                            "NS_Progress Billing Sub-Level" := true;
                            //PRJ-1708.JS.1.0 12DEC2022 - Start
                            NSIsProgressBillChangeOrder := true;
                            NS_ProgressBillingLine.RESET();
                            NS_ProgressBillingLine.SETRANGE("NS_Progress Billing No.", ParamProgressBillNo);
                            NS_ProgressBillingLine.SETRANGE("NS_Requisition No.", ParamRequisitionNo);
                            NS_ProgressBillingLine.SETRANGE("NS_Version No.", ParamVersionNo);
                            NS_ProgressBillingLine.SetFilter("NS_Job No.", '%1', NS_JobNoFilter);
                            if NS_ProgressBillingLine.FindSet() then
                                repeat
                                    //NS_ProgressBillingLine.ModifyAll("NS_Change Order", true);
                                    NS_ProgressBillingLine."NS_Change Order" := true;
                                    NS_ProgressBillingLine.Modify();
                                until NS_ProgressBillingLine.Next() = 0;
                            //PRJ-1708.JS.1.0 12DEC2022 - end;
                        end;
                        MODIFY();
                    end;

                if "Sub-Levels" then
                    "ProcessSub-Levels"(Job);
            end;

            trigger OnPreDataItem();
            begin
                Job.SetFilter("NS_Job Class", '<>%1', Job."NS_Job Class"::"Change Request"); //PE-193.PS.1.0 08Nov2023
                ItemNo := 0;
                NS_JobNoFilter := '';
                NS_JobNoFilter := GetFilter("No.");
            end;
        }
    }

    requestpage
    {

        layout
        {
            //PRJ-1036.GK.1.0 22Nov2021 start
            // area(Content)
            // {
            //     group(Options)
            //     {
            //         Caption = 'Options';
            //         field("Sub-Levels"; "Sub-Levels")
            //         {
            //             ApplicationArea = all;
            //             Caption = 'Sub-Levels';
            //             ToolTip = 'To add Sub-level lines';
            //         }
            //     }
            // }
            //PRJ-1036.GK.1.0 22Nov2021 end

        }
        actions
        {

        }
    }

    labels
    {
    }

    var
        ProgressBillingLine: Record "NS_Progress Billing Line";
        NS_ProgressBillingLine: Record "NS_Progress Billing Line";   //PRJ-1708.JS.1.0 12DEC2022
        JobPlanningLine: Record "Job Planning Line";
        JobActivity: Record "NS_Job Activity";
        JobProcess: Record "NS_Job Process";
        JobOperation: Record "NS_Job Operation";
        JobTask1: Record "Job Task";    //PRJ-999.JS.1.0 12Nov2021
        BillingHeader: Record "NS_Progress Billing Header";   //PRJ-999.JS.1.0 12Nov2021
        LastLineNo: Integer;
        ItemNo: Integer;
        "Sub-Levels": Boolean;
        ParamProgressBillNo: Code[20];
        NS_JobNoFilter: Code[240];   //PRJ-1708.JS.1.0 12DEC2022
        ParamRequisitionNo: Integer;
        ParamVersionNo: Integer;
        BudgetDesc: Text[100];//PRJ-301.AS.1.0  Increased length from 50 to 100 chars
        APODesc: Text[100];//PRJ-449.AM.1.0
        Text001: Label 'Should the Job %1 card be updated to show that it is part of progress bill %2?';
        Text002: Label 'Is job %1 a change order for Progress bill %2?';
        Text003: Label 'The following Revenue Category lines will be duplicated from Job No. %1\\%2\\Do you want to continue?';
        Text004: Label 'Should the sub-level %1 job card be updated to show that it is part of progress bill %2?';
        Text005: Label 'Is job %1 a sub-level for progress bill%2?';
        NSIsProgressBillChangeOrder: Boolean;   //PRJ-1708.JS.1.0 12DEC2022
        // >> Upgrade
        MasterJobNo: Code[20];
    // << Upgrade
    //PRJ-1414.AS.1.0 START Created event
    [IntegrationEvent(false, false)]
    local procedure NS_OnAfterProcessJobBudget(ParamProgressBillNoL: Code[20]; ParamRequisitionNoL: integer; ParamVersionNoL: integer)
    begin
    end;
    //PRJ-1414.AS.1.0 END
    //PRJ-1465.GK.1.0 20June2022 start
    [IntegrationEvent(false, false)]
    local procedure NS_OnBeforeInsertProgressBillingLine(var Job: Record "Job Planning Line"; ProgressBillingLine: Record "NS_Progress Billing Line")//PRJ-1465.GK.2.0 04July2022
    begin

    end;
    //PRJ-1465.GK.1.0 20June2022 end

    //PRJ-1465.GK.1.0 05July2022 start
    [IntegrationEvent(false, false)]
    local procedure NS_OnBeforeInsertProgressBillingLineS1(var Job: Record "Job Planning Line"; var ProgressBillingLine: Record "NS_Progress Billing Line")
    begin

    end;
    //PRJ-1465.GK.1.0 05July2022 end

    /// <summary>
    /// SetParameters.
    /// </summary>
    /// <param name="ProgBillNo">Code[20].</param>
    /// <param name="ReqNo">Integer.</param>
    /// <param name="VerNo">Integer.</param>
    procedure SetParameters(ProgBillNo: Code[20]; ReqNo: Integer; VerNo: Integer);
    begin
        ParamProgressBillNo := ProgBillNo;
        ParamRequisitionNo := ReqNo;
        ParamVersionNo := VerNo;
    end;

    procedure ProcessJobBudget(Job: Record Job);
    var
        //DLines: Text[500];  PRJCTPR-178 TY.1.0 210823
        DLines: Text; //PRJCTPR-178 TY.1.0 210823
        PBLine: Record "NS_Progress Billing Line";
        RevCatTble: Record "NS_Job Revenue Category";//PRJ-702.AS.1.0
        NSProgressBillingHeader: Record "NS_Progress Billing Header";   //PRJ-1373.JS.1.0 06MAY2022
        NSJobs: Record Job;  //PE-22.JS.1.0 21FEB2023
        NSJob: Record Job; //PRJCTPR-238.NC.1.0 05Jan2024
        // >> Upgrade
        IsHandled: Boolean;
    // << Upgrade
    begin
        If NSProgressBillingHeader.Get(ParamProgressBillNo, ParamRequisitionNo, ParamVersionNo) then; //PRJ-1373.JS.1.0 06MAY2022
        //PE-22.JS.1.0 21FEB2023 - Start
        if NSProgressBillingHeader."NS_Job No." <> '' then
            if NSJobs.get(NSProgressBillingHeader."NS_Job No.") then
                if NSJobs."Invoice Currency Code" <> '' then begin
                    NSProgressBillingHeader."NS_Invoiced Currency Code" := NSJobs."Invoice Currency Code";
                    NSProgressBillingHeader.Modify();
                end;
        //PE-22.JS.1.0 21FEB2023 - End        
        DLines := '';
        JobPlanningLine.RESET();
        JobPlanningLine.SETCURRENTKEY("Job No.", "NS_Entry Type", "Job Task No.", "NS_Cost Category", "NS_Revenue Category", Type, "No.", "Variant Code");
        JobPlanningLine.SETRANGE("Job No.", Job."No.");
        JobPlanningLine.SETFILTER("NS_Entry Type", '%1|%2', JobPlanningLine."NS_Entry Type"::Price, JobPlanningLine."NS_Entry Type"::Both);
        if JobPlanningLine.FINDSET() then
            repeat
                PBLine.RESET();
                PBLine.SETRANGE("NS_Progress Billing No.", ParamProgressBillNo);
                PBLine.SETRANGE("NS_Requisition No.", ParamRequisitionNo);
                PBLine.SETRANGE("NS_Version No.", ParamVersionNo);
                if PBLine.FINDSET() then
                    repeat
                        if PBLine."NS_Job No." = JobPlanningLine."Job No." then
                            if PBLine."NS_Job Task No." = JobPlanningLine."Job Task No." then
                                if PBLine."NS_Revenue Category" = JobPlanningLine."NS_Revenue Category" then
                                    DLines := DLines + '| ' + PBLine."NS_Revenue Category" + '  ' + PBLine.NS_Description + ' '
                    until PBLine.NEXT() = 0;
            until JobPlanningLine.NEXT() = 0;
        if DLines <> '' then
            if not CONFIRM(Text003, true, Job."No.", DLines) then
                exit;

        with JobPlanningLine do begin
            RESET();
            SETRANGE("Job No.", Job."No.");
            if FINDSET() then
                repeat
                    if ("NS_Entry Type" = "NS_Entry Type"::Price) or ("NS_Entry Type" = "NS_Entry Type"::Both) then begin
                        APODesc := '';
                        BudgetDesc := Description;
                        if JobActivity.GET(JobActivity.NS_Type::Revenue, "NS_Activity Code") then
                            APODesc := JobActivity.NS_Description;

                        if JobProcess.GET(JobProcess.NS_Type::Revenue, "NS_Process Code") then
                            APODesc := JobProcess.NS_Description;

                        if JobOperation.GET(JobOperation.NS_Type::Revenue, "NS_Operation Code") then
                            APODesc := JobOperation.NS_Description;

                        ProgressBillingLine.INIT();
                        ProgressBillingLine."NS_Progress Billing No." := ParamProgressBillNo;
                        ProgressBillingLine."NS_Requisition No." := ParamRequisitionNo;
                        ProgressBillingLine."NS_Version No." := ParamVersionNo;
                        LastLineNo := LastLineNo + 10000;
                        ProgressBillingLine."NS_Line No." := LastLineNo;
                        ItemNo := ItemNo + 1;
                        ProgressBillingLine."NS_Item No." := FORMAT(ItemNo);
                        ProgressBillingLine."NS_Job No." := "Job No.";
                        ProgressBillingLine."NS_Revenue Category" := "NS_Revenue Category";
                        //PRJ-702.AS.1.0 - start
                        if RevCatTble.Get(ProgressBillingLine."NS_Revenue Category") then
                            ProgressBillingLine."NS_Revenue Cat Description" := RevCatTble.NS_Description;
                        //PRJ-702.AS.1.0 - end
                        ProgressBillingLine."NS_Job Task No." := "Job Task No.";
                        // >> Upgrade
                        //FDD108 Start
                        //ProgressBillingLine."NS_Activity Code" := "NS_Activity Code";
                        ProgressBillingLine."NS_Activity Code" := "Job Task No.";
                        //FDD108 Stop
                        // << Upgrade
                        ProgressBillingLine."NS_Process Code" := "NS_Process Code";
                        ProgressBillingLine."NS_Operation Code" := "NS_Operation Code";
                        if BudgetDesc > '' then
                            ProgressBillingLine.NS_Description := BudgetDesc
                        else
                            ProgressBillingLine.NS_Description := APODesc;
                        ProgressBillingLine."NS_Billing Method" := "NS_Progress Billing Method";
                        if ProgressBillingLine."NS_Billing Method" = ProgressBillingLine."NS_Billing Method"::Unit then begin
                            ProgressBillingLine."NS_Contract Quantity" := Quantity;
                            ProgressBillingLine."NS_Base Amount" := "Unit Price";
                            if Quantity < 0 then
                                ProgressBillingLine."NS_Base Amount" := ProgressBillingLine."NS_Base Amount" * -1;
                        end else
                            ProgressBillingLine."NS_Base Amount" := "Total Price";
                        ProgressBillingLine."NS_Segment Code" := "NS_Segment Code"; //TM-10.AM.1.0
                        //GLEI-11.MS.1.001 //PRJ-203:AS:21APRIL2020 start
                        ProgressBillingLine."NS_Unit of Measure Code" := "Unit of Measure Code";
                        ProgressBillingLine."NS_Planing Line No." := "Line No.";
                        ProgressBillingLine."NS_Scheduled Values" := "Line Amount (LCY)";
                        //GLEI-11.MS.1.001 //PRJ-203:AS:21APRIL2020 end 
                        //PRJ-1708.JS.1.0 12DEC2022 - Start
                        ProgressBillingLine."NS_Contract Forecast Date" := JobPlanningLine."NS_Contract Forecast Date";
                        if NSIsProgressBillChangeOrder = true then
                            ProgressBillingLine."NS_Change Order" := true
                        else
                            // ProgressBillingLine."NS_Change Order" := false; //PE-142.NC.1.0 03Aug2023 Block
                            ProgressBillingLine."NS_Change Order" := JobPlanningLine."NS_Change Order"; //PE-142.NC.1.0 03Aug2023
                                                                                                        //PRJ-1708.JS.1.0 12DEC2022 - end  
                                                                                                        //PRJCTPR-238.NC.1.0 05Jan2024 Start
                        if NSJob.get(JobPlanningLine."Job No.") then;
                        if NSJob."NS_Job Class" = NSJob."NS_Job Class"::"Change Order" then
                            ProgressBillingLine."NS_Change Order" := true;
                        //PRJCTPR-238.NC.1.0 05Jan2024 End
                        //PRJ-999.JS.1.0 09Nov2021-Start
                        ProgressBillingLine."NS_Shortcut Dimension 1 Code" := Job."Global Dimension 1 Code";
                        ProgressBillingLine."NS_Shortcut Dimension 2 Code" := Job."Global Dimension 2 Code";
                        ProgressBillingLine."NS_Dimension Set ID" := ProgressBillingLine.GetDimensionNoFromJob(Job."No.");

                        if JobTask1.GET(ProgressBillingLine."NS_Job No.", ProgressBillingLine."NS_Job Task No.") then
                            IF ((JobTask1."Global Dimension 1 Code" <> '') and (JobTask1."Global Dimension 2 Code" <> '')) then begin
                                ProgressBillingLine."NS_Shortcut Dimension 1 Code" := JobTask1."Global Dimension 1 Code";
                                ProgressBillingLine."NS_Shortcut Dimension 2 Code" := JobTask1."Global Dimension 2 Code";
                                ProgressBillingLine."NS_Dimension Set ID" := BillingHeader.NS_GetDimensionNoFromJobTask(ProgressBillingLine."NS_Job No.", ProgressBillingLine."NS_Job Task No.");
                            end;
                        //PRJ-999.JS.1.0 09Nov2021-end   
                        // >> Upgrade
                        OnBeforeInsertProcessJobBudget(Job, ProgressBillingLine, JobPlanningLine, ParamProgressBillNo);
                        //ProgressBillingLine.INSERT();
                        //ProgressBillingLine.VALIDATE("NS_Work Retention Percent", Job."NS_Default Job Retention");
                        // << Upgrade
                        //PRJ-773.SK.1.0 Start
                        OnBeforeInsertProgressBillingLine(ProgressBillingLine, JobPlanningLine);
                        //PRJ-773.SK.1.0 End
                        //PRJ-1465.GK.1.0 20June2022 start
                        NS_OnBeforeInsertProgressBillingLineS1(JobPlanningLine, ProgressBillingLine);
                        //PRJ-1465.GK.1.0 20June2022 end
                        ProgressBillingLine.INSERT();
                        ProgressBillingLine.VALIDATE("NS_Work Retention Percent", Job."NS_Default Job Retention");
                        //PRJ-1373.JS.1.0 - Start
                        if Job."NS_Default Job Retention" = 0 then
                            ProgressBillingLine.VALIDATE("NS_Work Retention Percent", NSProgressBillingHeader."NS_Work Retention Percent");
                        //PRJ-1373.JS.1.0 - end    
                    end;
                until NEXT() = 0;
        end;
        NS_OnAfterProcessJobBudget(ParamProgressBillNo, ParamRequisitionNo, ParamVersionNo);//PRJ-1414.AS.1.0 Added event

    end;

    procedure "ProcessSub-Levels"(Job: Record Job);
    var
        "Sub-LevelJob": Record Job;
    begin
        with "Sub-LevelJob" do begin
            RESET();
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", Job."No.");
            if FINDSET() then
                repeat
                    ProcessJobBudget("Sub-LevelJob");

                    if "NS_Progress Billing No." = '' then
                        if CONFIRM(Text004, true, "Sub-LevelJob"."No.", ParamProgressBillNo) then begin
                            "NS_Progress Billing No." := ParamProgressBillNo;
                            if CONFIRM(Text005, true, "Sub-LevelJob"."No.", ParamProgressBillNo) then begin
                                "NS_Progress Billing Sub-Level" := true;
                            end;
                            MODIFY();
                        end;

                    "ProcessSub-Levels"("Sub-LevelJob");
                until NEXT() = 0;
        end;
    end;
    // >> Upgrade
    [IntegrationEvent(false, false)]
    procedure OnBeforeInsertProcessJobBudget(var Job: Record Job; var ProgressBillingLine: record "NS_Progress Billing Line"; var JobPlanningLine: record "Job Planning Line"; var ParamProgressBillNo: code[20])
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure JobOnAfterGetRecord(var Job: Record Job; var MasterJobNo: Code[20]; var ParamProgressBillNo: Code[20])
    begin

    end;

    // << Upgrade

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertProgressBillingLine(Var ProgressBillingLine: Record "NS_Progress Billing Line"; Var JobPlanningLine: Record "Job Planning Line")
    begin
    end;
}

