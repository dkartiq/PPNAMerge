report 14021330 "NS_Get Contact forProgressBill"
{
    //a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    //     FDD109 2018-08-22
    //   "Job Element Code" assignment added
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
    // +------------------------------------------------------------

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
                if "Sub-Levels" then
                    "ProcessSub-Levels"(Job);
            end;

            trigger OnPreDataItem();
            begin
                ItemNo := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
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
        JobPlanningLine: Record "Job Planning Line";
        JobActivity: Record "NS_Job Activity";
        JobProcess: Record "NS_Job Process";
        JobOperation: Record "NS_Job Operation";
        LastLineNo: Integer;
        ItemNo: Integer;
        "Sub-Levels": Boolean;
        ParamProgressBillNo: Code[20];
        ParamRequisitionNo: Integer;
        ParamVersionNo: Integer;
        BudgetDesc: Text[100];//PRJ-301.AS.1.0  Increased length from 50 to 100 chars
        APODesc: Text[100];//PRJ-449.AM.1.0
        Text001: Label 'Should the Job %1 card be updated to show that it is part of progress bill %2?';
        Text002: Label 'Is job %1 a change order for Progress bill %2?';
        Text003: Label 'The following Revenue Category lines will be duplicated from Job No. %1\\%2\\Do you want to continue?';
        Text004: Label 'Should the sub-level %1 job card be updated to show that it is part of progress bill %2?';
        Text005: Label 'Is job %1 a sub-level for progress bill%2?';
        // >> Upgrade
        MasterJobNo: Code[20];
    // << Upgrade

    procedure SetParameters(ProgBillNo: Code[20]; ReqNo: Integer; VerNo: Integer);
    begin
        ParamProgressBillNo := ProgBillNo;
        ParamRequisitionNo := ReqNo;
        ParamVersionNo := VerNo;
    end;

    procedure ProcessJobBudget(Job: Record Job);
    var
        DLines: Text[500];
        PBLine: Record "NS_Progress Billing Line";
        RevCatTble: Record "NS_Job Revenue Category";//PRJ-702.AS.1.0
        // >> Upgrade
        IsHandled: Boolean;
    // << Upgrade
    begin
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
                        // >> Upgrade
                        OnBeforeInsertProcessJobBudget(Job, ProgressBillingLine, JobPlanningLine, ParamProgressBillNo);
                        //ProgressBillingLine.INSERT();
                        //ProgressBillingLine.VALIDATE("NS_Work Retention Percent", Job."NS_Default Job Retention");
                        // << Upgrade
                    end;
                until NEXT() = 0;
        end;
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
}

