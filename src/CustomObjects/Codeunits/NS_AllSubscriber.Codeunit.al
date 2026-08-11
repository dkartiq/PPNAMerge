/// <summary>
/// Codeunit NS_AllSubscriber (ID 14021191).
/// </summary>
/// PRJ-1538.DK.1.0 27JULY2022
/// PE-167.VC.1.0 18Sep2023 | Job -> status -> WIP Message -> Setup -> to disable message.
codeunit 14021191 "NS_AllSubscriber"
{
    var
        JobSetup: Record "Jobs Setup";
        Jobs: Record Job;
        Items: Record Item;
        Contact: Record Contact;
        Resource: Record Resource;
        GLSetup: Record "General Ledger Setup";
        DimMgt: Codeunit DimensionManagement;
        Text002: Label 'You are not authorized to approve time sheet lines. Contact your time sheet administrator.';//PE-188.TY.1.0.16Oct2023

    /// <summary>
    /// NS_CopyPlanningLines.
    /// </summary>
    /// <param name="Rec">Record "NS_Job Material Planning".</param>
    /// <param name="Update">Boolean.</param>
    /// PRJ-1538
    procedure NS_CopyPlanningLines(Rec: Record "NS_Job Material Planning"; Update: Boolean);
    var
        JobMatPlan: Record "NS_Job Material Planning";
        JobPlanLines: Record "Job Planning Line";
        item: Record Item;
        Licdate: date;
        NoOfDays: Text;
        EnvInfoCU: Codeunit "Environment Information";
        AssemBOMRec: Record "NS_Assembley BOM Components";
        AssemBOMRecLeveL2: Record "NS_Assembley BOM Components";
        ResourceRec: Record resource;
        JobMatPlan1: Record "NS_Job Material Planning";
        Resource1: Record Resource;
        item1: Record Item;
        ResourceTbl: Record Resource;
        JobTask1: Record "Job Task";
        NS_Jobs: Record Job;
        NS_ItemVariant: Record "Item Variant";
        NS_JobsSetup: Record "Jobs Setup";
        NS_DefaultDim: Record "Default Dimension";
        JobLoc: Record Job;
        ItemUOM: Record "Item Unit of Measure";
        ItemUOM1: Record "Item Unit of Measure";
        NSJobMaterialPlanning: Record "NS_Job Material Planning";
    begin

        NSJobMaterialPlanning := Rec;

        //PRJ-1641.JS.1.0 21SEP2022 - Start
        // if EnvInfoCU.IsSaaS() then begin
        //     OnCheckPPLicenseExpire();
        // end;
        //PRJ-1641.JS.1.0 21SEP2022 - end

        JobSetup.GET();
        if not Update then
            if CONFIRM('Are you sure you want to erase the current batch? Y/N') then begin
                JobMatPlan.RESET();
                JobMatPlan.SETRANGE("NS_Worksheet Job No.", NSJobMaterialPlanning."NS_Worksheet Job No.");
                if JobMatPlan.FindSet() then
                    JobMatPlan.DELETEALL();
            end;

        JobPlanLines.RESET();
        JobPlanLines.SETRANGE("Job No.", NSJobMaterialPlanning."NS_Worksheet Job No.");
        JobPlanLines.SetFilter("Line Type", '<>%1', JobPlanLines."Line Type"::Billable);
        if not JobSetup."NS_ExpandedJobMaterialPlanning" then
            JobPlanLines.SETFILTER(Type, '%1|%2', JobPlanLines.Type::Item, JobPlanLines.Type::Resource);
        if JobPlanLines.FINDSET(false, false) then
            repeat

                JobMatPlan.RESET();
                JobMatPlan.SETRANGE("NS_Worksheet Job No.", NSJobMaterialPlanning."NS_Worksheet Job No.");
                JobMatPlan.SETRANGE(NS_Type, JobPlanLines.Type);
                JobMatPlan.SETRANGE("NS_Order Code", JobPlanLines."Job Task No.");
                JobMatPlan.SETRANGE("NS_Job Plannine Line No.", JobPlanLines."Line No.");
                if JobMatPlan.FINDFIRST() then begin
                    JobMatPlan.VALIDATE(NS_Quantity, JobPlanLines.Quantity);
                    JobMatPlan.MODIFY();
                end else begin
                    IF (JobPlanLines.Type = JobPlanLines.Type::Resource) then
                        if ResourceTbl.Get(JobPlanLines."No.") then
                            if ResourceTbl."NS_Resource is Purchasable" = true then begin
                                JobMatPlan.INIT();
                                JobMatPlan."NS_Worksheet Job No." := NSJobMaterialPlanning."NS_Worksheet Job No.";
                                JobMatPlan."NS_Line No." := NS_LastLineNo(NSJobMaterialPlanning."NS_Worksheet Job No.") + 10000;
                                JobMatPlan."NS_Document No." := JobPlanLines."Document No.";
                                JobMatPlan."NS_Date Ordered By" := JobPlanLines."Planning Date";
                                JobMatPlan."NS_Date Ordered By" := 0D;
                                JobMatPlan."NS_Date Required" := JobPlanLines."Planning Date";
                                JobMatPlan."NS_Order Code" := JobPlanLines."Job Task No.";
                                JobMatPlan.NS_Type := JobPlanLines.Type.AsInteger();
                                JobMatPlan."NS_Part No." := JobPlanLines."No.";
                                JobMatPlan.NS_Description := JobPlanLines.Description;
                                JobMatPlan."NS_Unit of Measure Code" := JobPlanLines."Unit of Measure Code";
                                JobMatPlan."NS_Variant Code" := JobPlanLines."Variant Code";
                                JobMatPlan.NS_Quantity := JobPlanLines.Quantity;
                                if Jobs.GET(JobPlanLines."Job No.") then begin
                                    if Contact.GET(COPYSTR(Jobs."Bill-to Customer No.", 1, 20)) then
                                        JobMatPlan."NS_Customer Account Name" := Contact.Name;
                                    JobMatPlan."NS_Job Description" := Jobs.Description;

                                    NS_JobsSetup.Get();
                                    if NS_JobsSetup."NS_Flow Job Card Dimension" = true then begin
                                        if NS_Jobs.Get(NSJobMaterialPlanning."NS_Worksheet Job No.") then begin
                                            JobMatPlan."NS_Global Dimension 1 Code" := NS_Jobs."Global Dimension 1 Code";
                                            JobMatPlan."NS_Global Dimension 2 Code" := NS_Jobs."Global Dimension 2 Code";
                                            JobMatPlan."NS_Dimension Set ID" := JobMatPlan.GetDimensionNoFromJob(NS_Jobs."No.");
                                        end;

                                        If JobTask1.get(JobPlanLines."Job No.", JobPlanLines."Job Task No.") then
                                            IF ((JobTask1."Global Dimension 1 Code" <> '') and (JobTask1."Global Dimension 2 Code" <> '')) then begin
                                                JobMatPlan."NS_Global Dimension 1 Code" := JobTask1."Global Dimension 1 Code";
                                                JobMatPlan."NS_Global Dimension 2 Code" := JobTask1."Global Dimension 2 Code";
                                                JobMatPlan."NS_Dimension Set ID" := Rec.NS_GetDimensionNoFromJobTask(JobTask1."Job No.", JobTask1."Job Task No.");
                                            end;
                                    end else
                                        if NS_Jobs.get(NSJobMaterialPlanning."NS_Worksheet Job No.") then begin
                                            NS_DefaultDim.Reset();
                                            NS_DefaultDim.SetRange("Table ID", 27);
                                            NS_DefaultDim.SetRange("No.", JobPlanLines."No.");
                                            if NS_DefaultDim.IsEmpty() then begin
                                                JobMatPlan."NS_Global Dimension 1 Code" := NS_Jobs."Global Dimension 1 Code";
                                                JobMatPlan."NS_Global Dimension 2 Code" := NS_Jobs."Global Dimension 2 Code";
                                                JobMatPlan."NS_Dimension Set ID" := JobMatPlan.GetDimensionNoFromJob(NS_Jobs."No.");
                                                If JobTask1.get(JobPlanLines."Job No.", JobPlanLines."Job Task No.") then begin
                                                    IF ((JobTask1."Global Dimension 1 Code" <> '') and (JobTask1."Global Dimension 2 Code" <> '')) then begin
                                                        JobMatPlan."NS_Global Dimension 1 Code" := JobTask1."Global Dimension 1 Code";
                                                        JobMatPlan."NS_Global Dimension 2 Code" := JobTask1."Global Dimension 2 Code";
                                                        JobMatPlan."NS_Dimension Set ID" := Rec.NS_GetDimensionNoFromJobTask(JobTask1."Job No.", JobTask1."Job Task No.");
                                                    end;
                                                end;
                                            end else begin
                                                if NS_Jobs.get(NSJobMaterialPlanning."NS_Worksheet Job No.") then
                                                    if item1.get(JobPlanLines."No.") then begin
                                                        JobMatPlan."NS_Global Dimension 1 Code" := item1."Global Dimension 1 Code";
                                                        JobMatPlan."NS_Global Dimension 2 Code" := item1."Global Dimension 2 Code";
                                                        JobMatPlan."NS_Dimension Set ID" := Rec.GetDimensionNoFromItemNo(item1."No.");
                                                    end;
                                            end;
                                        end;
                                end;

                                if JobPlanLines.Type = JobPlanLines.Type::Resource then begin
                                    Resource.RESET();
                                    if Resource.GET(JobPlanLines."No.") then
                                        if Resource."NS_Resource is Purchasable" then begin
                                            JobMatPlan."NS_Purchase Res. G/L" := true;
                                            JobMatPlan.NS_Vendor := Resource."Vendor No.";
                                        end
                                        else
                                            JobMatPlan."NS_Purchase Res. G/L" := false;

                                end;

                                JobMatPlan.VALIDATE(NS_Quantity);
                                JobMatPlan."NS_Job Plannine Line No." := JobPlanLines."Line No.";
                                JobMatPlan."NS_Location Code" := JobPlanLines."Location Code";
                                JobMatPlan."NS_Unit Cost" := JobPlanLines."Unit Cost";
                                JobMatPlan."NS_Total Cost" := JobPlanLines.Quantity * JobPlanLines."Unit Cost";
                                JobMatPlan."NS_Segment Code" := JobPlanLines."NS_Segment Code";
                                JobMatPlan."NS_Variant Code" := JobPlanLines."Variant Code";
                                if item.Get(JobPlanLines."No.") then begin
                                    JobMatPlan.NS_Manufacturer := item."Manufacturer Code";
                                    JobMatPlan.NS_Vendor := item."Vendor No.";
                                end;

                                if JobLoc.get(NSJobMaterialPlanning."NS_Worksheet Job No.") then begin
                                    JobMatPlan."NS_Job Purchaser" := JobLoc."NS_Job Purchaser";
                                    JobMatPlan."NS_Job Manager" := JobLoc.NS_Manager;
                                end;

                                JobMatPlan."NS_Main Item" := JobPlanLines."NS_Main Item";
                                JobMatPlan.NS_Level := JobPlanLines.NS_Level;
                                JobMatPlan."NS_Item Type" := JobPlanLines."NS_Item Type";
                                JobMatPlan."NS_Use Tax Amount" := JobPlanLines."NS_Use Tax Amount";
                                JobMatPlan."NS_Use Tax SKU" := JobPlanLines."NS_Use Tax SKU";
                                JobMatPlan.INSERT;

                            end;

                    IF (JobPlanLines.Type = JobPlanLines.Type::Item) then begin
                        JobMatPlan.INIT();
                        JobMatPlan."NS_Worksheet Job No." := NSJobMaterialPlanning."NS_Worksheet Job No.";
                        JobMatPlan."NS_Line No." := NS_LastLineNo(NSJobMaterialPlanning."NS_Worksheet Job No.") + 10000;

                        JobMatPlan."NS_Document No." := JobPlanLines."Document No.";
                        JobMatPlan."NS_Date Ordered By" := JobPlanLines."Planning Date";
                        JobMatPlan."NS_Date Ordered By" := 0D;
                        JobMatPlan."NS_Date Required" := JobPlanLines."Planning Date";
                        JobMatPlan."NS_Order Code" := JobPlanLines."Job Task No.";
                        JobMatPlan.NS_Type := JobPlanLines.Type.AsInteger();
                        JobMatPlan."NS_Part No." := JobPlanLines."No.";
                        JobMatPlan.NS_Description := JobPlanLines.Description;
                        JobMatPlan."NS_Unit of Measure Code" := JobPlanLines."Unit of Measure Code";
                        JobMatPlan.NS_Quantity := JobPlanLines.Quantity;

                        if JobLoc.get(NSJobMaterialPlanning."NS_Worksheet Job No.") then begin
                            JobMatPlan."NS_Job Purchaser" := JobLoc."NS_Job Purchaser";
                            JobMatPlan."NS_Job Manager" := JobLoc.NS_Manager;
                        end;

                        if item1.Get(JobMatPlan."NS_Part No.") then begin
                            JobMatPlan."NS_Base UOM" := item1."Base Unit of Measure";

                            if ItemUOM.Get(item1."No.", JobMatPlan."NS_Unit of Measure Code") then;
                            JobMatPlan."NS_Base UOM (Qty)" := JobMatPlan.NS_Quantity * ItemUOM."Qty. per Unit of Measure";

                        end;

                        if Jobs.GET(JobPlanLines."Job No.") then begin
                            if Contact.GET(COPYSTR(Jobs."Bill-to Customer No.", 1, 20)) then
                                JobMatPlan."NS_Customer Account Name" := Contact.Name;

                            if Resource.GET(Jobs."Person Responsible") then
                                NSJobMaterialPlanning."NS_Job Manager" := Resource.Name
                            else
                                NSJobMaterialPlanning."NS_Job Manager" := '';
                            JobMatPlan."NS_Job Description" := Jobs.Description;

                            NS_JobsSetup.Get();
                            if NS_JobsSetup."NS_Flow Job Card Dimension" = true then begin

                                if NS_Jobs.Get(NSJobMaterialPlanning."NS_Worksheet Job No.") then begin
                                    JobMatPlan."NS_Global Dimension 1 Code" := NS_Jobs."Global Dimension 1 Code";
                                    JobMatPlan."NS_Global Dimension 2 Code" := NS_Jobs."Global Dimension 2 Code";
                                    JobMatPlan."NS_Dimension Set ID" := JobMatPlan.GetDimensionNoFromJob(NS_Jobs."No.");

                                end;
                                If JobTask1.get(JobPlanLines."Job No.", JobPlanLines."Job Task No.") then
                                    IF ((JobTask1."Global Dimension 1 Code" <> '') and (JobTask1."Global Dimension 2 Code" <> '')) then begin
                                        JobMatPlan."NS_Global Dimension 1 Code" := JobTask1."Global Dimension 1 Code";
                                        JobMatPlan."NS_Global Dimension 2 Code" := JobTask1."Global Dimension 2 Code";
                                        JobMatPlan."NS_Dimension Set ID" := Rec.NS_GetDimensionNoFromJobTask(JobTask1."Job No.", JobTask1."Job Task No.");
                                    end;
                            end else
                                if NS_Jobs.get(NSJobMaterialPlanning."NS_Worksheet Job No.") then begin
                                    NS_DefaultDim.Reset();
                                    NS_DefaultDim.SetRange("Table ID", 27);
                                    NS_DefaultDim.SetRange("No.", JobPlanLines."No.");
                                    if NS_DefaultDim.IsEmpty() then begin
                                        JobMatPlan."NS_Global Dimension 1 Code" := NS_Jobs."Global Dimension 1 Code";
                                        JobMatPlan."NS_Global Dimension 2 Code" := NS_Jobs."Global Dimension 2 Code";
                                        JobMatPlan."NS_Dimension Set ID" := JobMatPlan.GetDimensionNoFromJob(NS_Jobs."No.");
                                        If JobTask1.get(JobPlanLines."Job No.", JobPlanLines."Job Task No.") then begin
                                            IF ((JobTask1."Global Dimension 1 Code" <> '') and (JobTask1."Global Dimension 2 Code" <> '')) then begin
                                                JobMatPlan."NS_Global Dimension 1 Code" := JobTask1."Global Dimension 1 Code";
                                                JobMatPlan."NS_Global Dimension 2 Code" := JobTask1."Global Dimension 2 Code";
                                                JobMatPlan."NS_Dimension Set ID" := Rec.NS_GetDimensionNoFromJobTask(JobTask1."Job No.", JobTask1."Job Task No.");
                                            end;
                                        end;
                                    end else begin
                                        if NS_Jobs.get(NSJobMaterialPlanning."NS_Worksheet Job No.") then
                                            if item1.get(JobPlanLines."No.") then begin
                                                JobMatPlan."NS_Global Dimension 1 Code" := item1."Global Dimension 1 Code";
                                                JobMatPlan."NS_Global Dimension 2 Code" := item1."Global Dimension 2 Code";
                                                JobMatPlan."NS_Dimension Set ID" := Rec.GetDimensionNoFromItemNo(item1."No.");
                                            end;
                                    end;
                                end;
                        end;

                        if JobPlanLines.Type = JobPlanLines.Type::Resource then begin
                            Resource.RESET();
                            if Resource.GET(JobPlanLines."No.") then
                                if Resource."NS_Resource is Purchasable" then begin
                                    JobMatPlan."NS_Purchase Res. G/L" := true;
                                    JobMatPlan.NS_Vendor := Resource."Vendor No.";
                                end
                                else
                                    JobMatPlan."NS_Purchase Res. G/L" := false;
                        end;

                        JobMatPlan.VALIDATE(NS_Quantity);
                        JobMatPlan."NS_Job Plannine Line No." := JobPlanLines."Line No.";
                        JobMatPlan."NS_Location Code" := JobPlanLines."Location Code";
                        JobMatPlan."NS_Unit Cost" := JobPlanLines."Unit Cost";
                        JobMatPlan."NS_Total Cost" := JobPlanLines.Quantity * JobPlanLines."Unit Cost";
                        JobMatPlan."NS_Segment Code" := JobPlanLines."NS_Segment Code";
                        JobMatPlan."NS_Variant Code" := JobPlanLines."Variant Code";
                        if item.Get(JobPlanLines."No.") then begin
                            JobMatPlan.NS_Manufacturer := item."Manufacturer Code";
                            JobMatPlan.NS_Vendor := item."Vendor No.";
                        end;
                        JobMatPlan."NS_Main Item" := JobPlanLines."NS_Main Item";
                        JobMatPlan.NS_Level := JobPlanLines.NS_Level;
                        JobMatPlan."NS_Item Type" := JobPlanLines."NS_Item Type";
                        JobMatPlan."NS_Use Tax Amount" := JobPlanLines."NS_Use Tax Amount";
                        JobMatPlan."NS_Use Tax SKU" := JobPlanLines."NS_Use Tax SKU";

                        if JobLoc.get(NSJobMaterialPlanning."NS_Worksheet Job No.") then begin
                            JobMatPlan."NS_Job Purchaser" := JobLoc."NS_Job Purchaser";
                            JobMatPlan."NS_Job Manager" := JobLoc.NS_Manager;
                        end;
                        JobMatPlan.INSERT;
                    end;
                    JobPlanLines."NS_Copied to JMP" := true;
                    JobPlanLines.MODIFY();
                end;

                AssemBOMRec.Reset();
                AssemBOMRec.SetCurrentKey("NS_Ref. JPL Parent Item No.", "NS_Item Type");
                AssemBOMRec.SetRange("NS_Job No.", JobPlanLines."Job No.");
                AssemBOMRec.SetRange(NS_Type, AssemBOMRec.NS_Type::Item);
                AssemBOMRec.SetRange("NS_Job Task No.", JobPlanLines."Job Task No.");
                AssemBOMRec.SetRange("NS_Ref. JPL Line No.", JobPlanLines."Line No.");
                if AssemBOMRec.Findset() then BEGIN
                    repeat
                        JobMatPlan1.INIT();
                        JobMatPlan1."NS_Worksheet Job No." := NSJobMaterialPlanning."NS_Worksheet Job No.";
                        JobMatPlan1."NS_Line No." := NS_LastLineNo(NSJobMaterialPlanning."NS_Worksheet Job No.") + 10000;
                        JobMatPlan1."NS_Document No." := JobPlanLines."Document No.";
                        JobMatPlan1."NS_Date Ordered By" := JobPlanLines."Planning Date";
                        JobMatPlan1."NS_Date Ordered By" := 0D;
                        JobMatPlan1."NS_Date Required" := JobPlanLines."Planning Date";
                        JobMatPlan1."NS_Assembly Item on Job." := AssemBOMRec."NS_Ref. JPL Parent Item No.";
                        if JobLoc.get(NSJobMaterialPlanning."NS_Worksheet Job No.") then begin
                            JobMatPlan."NS_Job Purchaser" := JobLoc."NS_Job Purchaser";
                            JobMatPlan."NS_Job Manager" := JobLoc.NS_Manager;
                        end;
                        if item1.Get(AssemBOMRec."NS_Ref. JPL Parent Item No.") then begin
                            JobMatPlan1.NS_Manufacturer := item1."Manufacturer Code";
                            JobMatPlan1.NS_Vendor := item1."Vendor No.";
                            JobMatPlan1."NS_Item Name New" := item1.Description;

                            NS_JobsSetup.Get();
                            if NS_JobsSetup."NS_Flow Job Card Dimension" = true then begin
                                if NS_Jobs.Get(NSJobMaterialPlanning."NS_Worksheet Job No.") then begin
                                    JobMatPlan1."NS_Global Dimension 1 Code" := NS_Jobs."Global Dimension 1 Code";
                                    JobMatPlan1."NS_Global Dimension 2 Code" := NS_Jobs."Global Dimension 2 Code";
                                    JobMatPlan1."NS_Dimension Set ID" := JobMatPlan.GetDimensionNoFromJob(NS_Jobs."No.");
                                end;
                                If JobTask1.get(JobPlanLines."Job No.", JobPlanLines."Job Task No.") then
                                    IF ((JobTask1."Global Dimension 1 Code" <> '') and (JobTask1."Global Dimension 2 Code" <> '')) then begin
                                        JobMatPlan1."NS_Global Dimension 1 Code" := JobTask1."Global Dimension 1 Code";
                                        JobMatPlan1."NS_Global Dimension 2 Code" := JobTask1."Global Dimension 2 Code";
                                        JobMatPlan1."NS_Dimension Set ID" := Rec.NS_GetDimensionNoFromJobTask(JobTask1."Job No.", JobTask1."Job Task No.");
                                    end;
                            end else begin
                                if NS_Jobs.get(NSJobMaterialPlanning."NS_Worksheet Job No.") then begin
                                    NS_DefaultDim.Reset();
                                    NS_DefaultDim.SetRange("Table ID", 27);
                                    NS_DefaultDim.SetRange("No.", JobPlanLines."No.");
                                    if NS_DefaultDim.IsEmpty() then begin
                                        JobMatPlan."NS_Global Dimension 1 Code" := NS_Jobs."Global Dimension 1 Code";
                                        JobMatPlan."NS_Global Dimension 2 Code" := NS_Jobs."Global Dimension 2 Code";
                                        JobMatPlan."NS_Dimension Set ID" := JobMatPlan.GetDimensionNoFromJob(NS_Jobs."No.");
                                        If JobTask1.get(JobPlanLines."Job No.", JobPlanLines."Job Task No.") then begin
                                            IF ((JobTask1."Global Dimension 1 Code" <> '') and (JobTask1."Global Dimension 2 Code" <> '')) then begin
                                                JobMatPlan."NS_Global Dimension 1 Code" := JobTask1."Global Dimension 1 Code";
                                                JobMatPlan."NS_Global Dimension 2 Code" := JobTask1."Global Dimension 2 Code";
                                                JobMatPlan."NS_Dimension Set ID" := Rec.NS_GetDimensionNoFromJobTask(JobTask1."Job No.", JobTask1."Job Task No.");
                                            end;
                                        end;
                                    end else begin
                                        if NS_Jobs.get(NSJobMaterialPlanning."NS_Worksheet Job No.") then
                                            if item1.get(JobPlanLines."No.") then begin
                                                JobMatPlan."NS_Global Dimension 1 Code" := item1."Global Dimension 1 Code";
                                                JobMatPlan."NS_Global Dimension 2 Code" := item1."Global Dimension 2 Code";
                                                JobMatPlan."NS_Dimension Set ID" := Rec.GetDimensionNoFromItemNo(item1."No.");
                                            end;
                                    end;
                                end;
                            end;
                        end;
                        JobMatPlan1."NS_Quantity Per" := AssemBOMRec."NS_Quantity Per";
                        JobMatPlan1."NS_Order Code" := JobPlanLines."Job Task No.";
                        JobMatPlan1.NS_Type := AssemBOMRec.NS_Type;
                        JobMatPlan1."NS_Part No." := AssemBOMRec."NS_No.";
                        JobMatPlan1.NS_Description := AssemBOMRec."NS_Description New";
                        JobMatPlan1."NS_Unit of Measure Code" := AssemBOMRec."NS_Unit of Measure Code";

                        if ResourceRec.Get(AssemBOMRec."NS_No.") then begin
                            JobMatPlan1.NS_Description := ResourceRec.Name;
                        end;
                        JobMatPlan1."NS_Unit Cost" := AssemBOMRec."NS_Unit Cost";
                        JobMatPlan1.NS_Quantity := AssemBOMRec."NS_Quantity Per" * AssemBOMRec."NS_Quantity of Assembly Item on Job";
                        if item1.Get(AssemBOMRec."NS_No.") then begin
                            JobMatPlan1.NS_Description := item1.Description;
                            JobMatPlan1."NS_Base UOM" := item1."Base Unit of Measure";
                            if ItemUOM1.Get(item1."No.", JobMatPlan1."NS_Unit of Measure Code") then;
                            JobMatPlan1."NS_Base UOM (Qty)" := JobMatPlan1.NS_Quantity * ItemUOM1."Qty. per Unit of Measure";

                        end;
                        if Jobs.GET(JobPlanLines."Job No.") then begin
                            if Contact.GET(COPYSTR(Jobs."Bill-to Customer No.", 1, 20)) then
                                JobMatPlan1."NS_Customer Account Name" := Contact.Name;

                            if Resource1.GET(Jobs."Person Responsible") then
                                NSJobMaterialPlanning."NS_Job Manager" := Resource1.Name
                            else
                                NSJobMaterialPlanning."NS_Job Manager" := '';
                            JobMatPlan1."NS_Job Description" := Jobs.Description;
                        end;

                        if JobMatPlan1.NS_Type = JobMatPlan1.NS_Type::Resource then begin
                            Resource1.RESET();
                            if Resource1.GET(JobMatPlan1."NS_Part No.") then
                                if Resource1."NS_Resource is Purchasable" then begin
                                    JobMatPlan1."NS_Purchase Res. G/L" := true;
                                    JobMatPlan1.NS_Vendor := Resource1."Vendor No.";
                                end
                                else
                                    JobMatPlan1."NS_Purchase Res. G/L" := false;

                        end;

                        JobMatPlan1.VALIDATE(NS_Quantity);
                        JobMatPlan1."NS_Job Plannine Line No." := JobPlanLines."Line No.";
                        JobMatPlan1."NS_Location Code" := JobPlanLines."Location Code";
                        JobMatPlan1."NS_Total Cost" := JobMatPlan1.NS_Quantity * JobPlanLines."Unit Cost";
                        JobMatPlan1."NS_Segment Code" := JobPlanLines."NS_Segment Code";
                        JobMatPlan1."NS_Main Item" := AssemBOMRec."NS_Main Item";
                        JobMatPlan1.NS_Level := AssemBOMRec.NS_Level;
                        JobMatPlan1."NS_Item Type" := AssemBOMRec."NS_Item Type";
                        JobMatPlan1."NS_Use Tax Amount" := JobPlanLines."NS_Use Tax Amount";
                        JobMatPlan1."NS_Use Tax SKU" := JobPlanLines."NS_Use Tax SKU";
                        JobMatPlan1.INSERT;
                    until AssemBOMRec.Next() = 0;
                END;

                AssemBOMRec.Reset();
                AssemBOMRec.SetCurrentKey("NS_Ref. JPL Parent Item No.", "NS_Item Type");
                AssemBOMRec.SetRange("NS_Job No.", JobPlanLines."Job No.");
                AssemBOMRec.SetRange(NS_Type, AssemBOMRec.NS_Type::Resource);
                AssemBOMRec.SetRange("NS_Job Task No.", JobPlanLines."Job Task No.");
                AssemBOMRec.SetRange("NS_Ref. JPL Line No.", JobPlanLines."Line No.");
                if AssemBOMRec.Findset() then BEGIN
                    repeat
                        IF ResourceTbl.Get(AssemBOMRec."NS_No.") then
                            if ResourceTbl."NS_Resource is Purchasable" = true then begin
                                JobMatPlan1.INIT();
                                JobMatPlan1."NS_Worksheet Job No." := NSJobMaterialPlanning."NS_Worksheet Job No.";
                                JobMatPlan1."NS_Line No." := NS_LastLineNo(NSJobMaterialPlanning."NS_Worksheet Job No.") + 10000;
                                JobMatPlan1."NS_Document No." := JobPlanLines."Document No.";
                                JobMatPlan1."NS_Date Ordered By" := JobPlanLines."Planning Date";
                                JobMatPlan1."NS_Date Ordered By" := 0D;
                                JobMatPlan1."NS_Date Required" := JobPlanLines."Planning Date";
                                JobMatPlan1."NS_Assembly Item on Job." := AssemBOMRec."NS_Ref. JPL Parent Item No.";
                                if item1.Get(AssemBOMRec."NS_Ref. JPL Parent Item No.") then begin
                                    JobMatPlan1.NS_Manufacturer := item1."Manufacturer Code";
                                    JobMatPlan1.NS_Vendor := item1."Vendor No.";
                                    JobMatPlan1."NS_Item Name New" := item1.Description;
                                end;
                                JobMatPlan1."NS_Quantity Per" := AssemBOMRec."NS_Quantity Per";
                                JobMatPlan1."NS_Order Code" := JobPlanLines."Job Task No.";
                                JobMatPlan1.NS_Type := AssemBOMRec.NS_Type;
                                JobMatPlan1."NS_Part No." := AssemBOMRec."NS_No.";
                                if JobLoc.get(NSJobMaterialPlanning."NS_Worksheet Job No.") then begin
                                    JobMatPlan."NS_Job Purchaser" := JobLoc."NS_Job Purchaser";
                                    JobMatPlan."NS_Job Manager" := JobLoc.NS_Manager;
                                end;
                                JobMatPlan1.NS_Description := AssemBOMRec."NS_Description New";
                                JobMatPlan1."NS_Unit of Measure Code" := AssemBOMRec."NS_Unit of Measure Code";
                                if item1.Get(AssemBOMRec."NS_No.") then begin
                                    JobMatPlan1.NS_Description := item1.Description;
                                end;
                                if ResourceRec.Get(AssemBOMRec."NS_No.") then begin
                                    JobMatPlan1.NS_Description := ResourceRec.Name;
                                end;

                                JobMatPlan1."NS_Unit Cost" := AssemBOMRec."NS_Unit Cost";
                                JobMatPlan1.NS_Quantity := AssemBOMRec."NS_Quantity Per" * AssemBOMRec."NS_Quantity of Assembly Item on Job";
                                if Jobs.GET(JobPlanLines."Job No.") then begin
                                    if Contact.GET(COPYSTR(Jobs."Bill-to Customer No.", 1, 20)) then
                                        JobMatPlan1."NS_Customer Account Name" := Contact.Name;

                                    if Resource1.GET(Jobs."Person Responsible") then
                                        NSJobMaterialPlanning."NS_Job Manager" := Resource1.Name
                                    else
                                        NSJobMaterialPlanning."NS_Job Manager" := '';
                                    JobMatPlan1."NS_Job Description" := Jobs.Description;
                                end;

                                if JobMatPlan1.NS_Type = JobMatPlan1.NS_Type::Resource then begin
                                    Resource1.RESET();
                                    if Resource1.GET(JobMatPlan1."NS_Part No.") then
                                        if Resource1."NS_Resource is Purchasable" then begin
                                            JobMatPlan1."NS_Purchase Res. G/L" := true;
                                            JobMatPlan1.NS_Vendor := Resource1."Vendor No.";
                                        end
                                        else
                                            JobMatPlan1."NS_Purchase Res. G/L" := false;

                                end;

                                JobMatPlan1.VALIDATE(NS_Quantity);
                                JobMatPlan1."NS_Job Plannine Line No." := JobPlanLines."Line No.";
                                JobMatPlan1."NS_Location Code" := JobPlanLines."Location Code";
                                JobMatPlan1."NS_Total Cost" := JobMatPlan1.NS_Quantity * JobPlanLines."Unit Cost";
                                JobMatPlan1."NS_Segment Code" := JobPlanLines."NS_Segment Code";
                                JobMatPlan1."NS_Main Item" := AssemBOMRec."NS_Main Item";
                                JobMatPlan1.NS_Level := AssemBOMRec.NS_Level;
                                JobMatPlan1."NS_Item Type" := AssemBOMRec."NS_Item Type";
                                JobMatPlan1."NS_Use Tax Amount" := JobPlanLines."NS_Use Tax Amount";
                                JobMatPlan1."NS_Use Tax SKU" := JobPlanLines."NS_Use Tax SKU";
                                JobMatPlan1.INSERT;

                            end;
                    until AssemBOMRec.Next() = 0;
                End;
            until JobPlanLines.NEXT() = 0;
    end;


    /// <summary>
    /// NS_LastLineNo.
    /// </summary>
    /// <param name="JobNo.">Code[20].</param>
    /// <returns>Return value of type Integer.</returns>
    procedure NS_LastLineNo("JobNo.": Code[20]): Integer;
    var
        JobMP: Record "NS_Job Material Planning";
    begin
        JobMP.RESET();
        JobMP.SETRANGE("NS_Worksheet Job No.", "JobNo.");
        if JobMP.FINDLAST() then
            exit(JobMP."NS_Line No.")
        else
            exit(0);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCheckPPLicenseExpire()
    begin
    end;
    //PE-23.NC.1.0 05Jun22023 Start
    procedure InsertCommitemtReportTable(NS_Job: Record Job; NS_SourceJob: Code[20])
    var
        NS_CommitRepTemp: Record NS_CommitmentReportTemp;
        NS_PurchHead: Record "Purchase Header";
        NS_Subcont: Record NS_Subcontract;
        NS_Subcontract: Record NS_Subcontract;
        VendLedEntry: Record "Vendor Ledger Entry";
        PurchInvHead: Record "Purch. Inv. Header";
        NS_SubcontNo: code[20];
        ApprovChang: Decimal;
        PaymReceivAmt: Decimal;
        InvoiceAmt: Decimal;
        RetentionAmt: Decimal;
        PaymReceivAmtPO: Decimal;
        InvoiceAmtPO: Decimal;
        RetentionAmtPO: Decimal;
    begin
        NS_CommitRepTemp.Reset();
        NS_CommitRepTemp.SetRange("NS_Job No.", NS_SourceJob);
        if NS_CommitRepTemp.FindFirst() then
            NS_CommitRepTemp.DeleteAll();
        NS_PurchHead.Reset();
        NS_PurchHead.SetRange("NS_Job No.", NS_SourceJob);
        NS_PurchHead.SetRange("Document Type", NS_PurchHead."Document Type"::Order);
        NS_PurchHead.SetRange("NS_Subcontract No.", '');
        if NS_PurchHead.FindFirst() then
            repeat
                NS_PurchHead.CalcFields(Amount);
                NS_CommitRepTemp.Init();
                NS_CommitRepTemp."NS_Job No." := NS_SourceJob;
                NS_CommitRepTemp."NS_Document Type" := NS_CommitRepTemp."NS_Document Type"::"Purchase Order";
                NS_CommitRepTemp."NS_Document No." := NS_PurchHead."No.";
                NS_CommitRepTemp."NS_Vendor No." := NS_PurchHead."Buy-from Vendor No.";
                NS_CommitRepTemp.NS_Description := NS_Job.Description;
                NS_CommitRepTemp."NS_Subcontact No." := NS_PurchHead."No.";
                NS_CommitRepTemp."NS_Original Commitment" += NS_PurchHead.Amount;
                PaymReceivAmtPO := 0;
                InvoiceAmtPO := 0;
                RetentionAmtPO := 0;
                PurchInvHead.Reset();
                PurchInvHead.SetRange("Order No.", NS_PurchHead."No.");
                if PurchInvHead.FindFirst() then begin
                    VendLedEntry.Reset();
                    VendLedEntry.SetRange("NS_Job No.", NS_SourceJob);
                    VendLedEntry.SetRange("Document No.", PurchInvHead."No.");
                    VendLedEntry.SetRange("Document Type", VendLedEntry."Document Type"::Invoice);
                    if VendLedEntry.FindFirst() then
                        repeat
                            VendLedEntry.CalcFields("Original Amount", "Remaining Amount");
                            InvoiceAmtPO += ABS(VendLedEntry."Original Amount");
                            PaymReceivAmtPO += VendLedEntry."Remaining Amount";
                            if VendLedEntry."NS_Retention Ledger Code" = 'RETENTION' then
                                RetentionAmtPO += ABS(VendLedEntry."Original Amount");
                        until VendLedEntry.Next() = 0;
                end;
                NS_CommitRepTemp."NS_Invoiced Amount" := InvoiceAmtPO;
                NS_CommitRepTemp."NS_Retention Amount" += RetentionAmtPO;
                NS_CommitRepTemp."NS_Payment Received" += PaymReceivAmtPO;
                NS_CommitRepTemp.Insert();
            until NS_PurchHead.Next() = 0;
        NS_Subcont.Reset();
        NS_Subcont.SetRange("NS_Job No.", NS_SourceJob);
        if NS_Subcont.FindFirst() then
            repeat
                NS_SubcontNo := '';
                if STRPOS(NS_Subcont."NS_No.", '.') > 0 then
                    NS_SubcontNo := COPYSTR(NS_Subcont."NS_No.", 1, STRPOS(NS_Subcont."NS_No.", '.') - 1)
                else
                    NS_SubcontNo := NS_Subcont."NS_No.";
                if NS_CommitReportTempExit(NS_SourceJob, NS_SubcontNo, NS_Subcont."NS_Buy-from Vendor No.") then begin
                    NS_CommitRepTemp.Init();
                    NS_CommitRepTemp."NS_Job No." := NS_SourceJob;
                    NS_CommitRepTemp."NS_Document Type" := NS_CommitRepTemp."NS_Document Type"::"Sub-Contract";
                    NS_CommitRepTemp."NS_Document No." := NS_Subcont."NS_No.";
                    NS_CommitRepTemp."NS_Vendor No." := NS_Subcont."NS_Buy-from Vendor No.";
                    NS_CommitRepTemp.NS_Description := NS_Job.Description;

                    NS_CommitRepTemp."NS_Subcontact No." := NS_SubcontNo;
                    NS_Subcontract.Reset();
                    NS_Subcontract.SetRange("NS_Job No.", NS_SourceJob);
                    NS_Subcontract.SetFilter("NS_No.", '@*' + format(NS_SubcontNo) + '*');
                    NS_Subcontract.SetFilter("NS_Sub-LeveltoSubcontractNo.", '%1', '');
                    if NS_Subcontract.FindFirst() then begin
                        NS_Subcontract.CalcFields("NS_Budgeted Cost (LCY)");
                        NS_CommitRepTemp."NS_Original Commitment" += ABS(NS_Subcontract."NS_Budgeted Cost (LCY)");
                    end;
                    ApprovChang := 0;
                    NS_Subcontract.Reset();
                    NS_Subcontract.SetRange("NS_Job No.", NS_SourceJob);
                    NS_Subcontract.SetFilter("NS_No.", '@*' + format(NS_SubcontNo) + '*');
                    NS_Subcontract.SetFilter("NS_Sub-LeveltoSubcontractNo.", '<>%1', '');
                    if NS_Subcontract.FindFirst() then
                        repeat
                            NS_Subcontract.CalcFields("NS_Budgeted Cost (LCY)", "NS_Change Order Commit Amt.");
                            if Abs(NS_Subcontract."NS_Change Order Commit Amt.") > abs(NS_Subcontract."NS_Budgeted Cost (LCY)") then
                                ApprovChang += Abs(NS_Subcontract."NS_Change Order Commit Amt.")
                            ELSE
                                ApprovChang += ABS(NS_Subcontract."NS_Budgeted Cost (LCY)");
                        until NS_Subcontract.Next() = 0;
                    NS_CommitRepTemp."NS_Change Order Commitment" := ApprovChang;
                    PaymReceivAmt := 0;
                    InvoiceAmt := 0;
                    RetentionAmt := 0;
                    NS_Subcontract.Reset();
                    NS_Subcontract.SetRange("NS_Job No.", NS_SourceJob);
                    NS_Subcontract.SetFilter("NS_No.", '@*' + format(NS_SubcontNo) + '*');
                    if NS_Subcontract.FindFirst() then
                        repeat
                            VendLedEntry.Reset();
                            VendLedEntry.SetRange("NS_Job No.", NS_SourceJob);
                            VendLedEntry.SetRange("NS_Subcontract No.", NS_Subcontract."NS_No.");
                            VendLedEntry.SetRange("Document Type", VendLedEntry."Document Type"::Invoice);
                            if VendLedEntry.FindFirst() then
                                repeat
                                    VendLedEntry.CalcFields("Original Amount", "Remaining Amount");
                                    InvoiceAmt += ABS(VendLedEntry."Original Amount");
                                    PaymReceivAmt += VendLedEntry."Remaining Amount";
                                    if VendLedEntry."NS_Retention Ledger Code" = 'RETENTION' then
                                        RetentionAmt += ABS(VendLedEntry."Original Amount");
                                until VendLedEntry.Next() = 0;
                        until NS_Subcontract.Next() = 0;
                    NS_CommitRepTemp."NS_Invoiced Amount" := InvoiceAmt;
                    NS_CommitRepTemp."NS_Retention Amount" := RetentionAmt;
                    NS_CommitRepTemp."NS_Payment Received" := PaymReceivAmt;
                    NS_CommitRepTemp.Insert();
                end;
            until NS_Subcont.Next() = 0;
        Commit();
    end;

    local procedure NS_CommitReportTempExit(NSJobNo1: Code[20]; DocuNo: Code[20]; VendNo: Code[20]): Boolean;
    var
        NS_CommitRepotTemp: Record NS_CommitmentReportTemp;
    begin
        NS_CommitRepotTemp.Reset();
        NS_CommitRepotTemp.SetRange("NS_Job No.", NSJobNo1);
        NS_CommitRepotTemp.SetRange("NS_Subcontact No.", DocuNo);
        NS_CommitRepotTemp.SetRange("NS_Vendor No.", VendNo);
        if NS_CommitRepotTemp.IsEmpty then
            exit(true);
        exit(false);
    end;
    //PE-23.NC.1.0 05Jun22023 End

    //PE-167.VC.1.0 18Sep2023 Start
    [EventSubscriber(ObjectType::Table, Database::Job, 'OnBeforeRecalculateJobWIP', '', false, false)]
    local procedure OnBeforeRecalculateJobWIP(var IsHandled: Boolean; var Job: Record Job)
    var
        NS_JobSetup: Record "Jobs Setup";
        NS_Job: Record Job;
        NS_JobWIPEntry: Record "Job WIP Entry";
        NS_JobWIPGLEntry: Record "Job WIP G/L Entry";
        NS_SkipMessage: Boolean;
    begin
        NS_JobSetup.Get();
        if NS_JobSetup."NS_Skip Recalculate JobWIP" then begin
            NS_JobWIPGLEntry.Reset();
            NS_JobWIPGLEntry.SetRange("Job No.", Job."No.");
            if NS_JobWIPGLEntry.IsEmpty() then Begin
                NS_SkipMessage := true;
            end;
            If NS_SkipMessage then begin
                NS_JobWIPEntry.Reset();
                NS_JobWIPEntry.SetRange("Job No.", Job."No.");
                if NS_JobWIPEntry.IsEmpty() then begin
                    If NS_Job.Get(Job."No.") Then;
                    IsHandled := true;
                End else
                    IsHandled := false;
            End;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Job, 'OnBeforeValidateStatus', '', false, false)]
    local procedure OnBeforeValidateStatus(CurrentFieldNo: Integer; var IsHandled: Boolean; var Job: Record Job; xJob: Record Job)
    var

        NS_JobSetup: Record "Jobs Setup";
        NS_JobWIPEntry: Record "Job WIP Entry";
        NS_JobWIPGLEntry: Record "Job WIP G/L Entry";
        NS_SkipMessage: Boolean;
    begin
        NS_JobSetup.Get();
        if NS_JobSetup."NS_Skip Recalculate JobWIP" then begin
            IF xJob.Status = xJob.Status::Completed THEN begin
                NS_JobWIPGLEntry.Reset();
                NS_JobWIPGLEntry.SetRange("Job No.", Job."No.");
                if NS_JobWIPGLEntry.IsEmpty() then Begin
                    NS_SkipMessage := true;
                end;
                If NS_SkipMessage then begin
                    NS_JobWIPEntry.Reset();
                    NS_JobWIPEntry.SetRange("Job No.", Job."No.");
                    if NS_JobWIPEntry.IsEmpty() then begin
                        Job.Complete := false;
                        Job.Status := Job.Status;
                        Job.Modify();
                        IsHandled := true;
                    end;
                End else
                    IsHandled := false;
            End;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Job, 'OnBeforeChangeJobCompletionStatus', '', false, false)]
    local procedure OnBeforeChangeJobCompletionStatus(var IsHandled: Boolean; var Job: Record Job; var xJob: Record Job)
    var
        NS_JobSetup: Record "Jobs Setup";
        NS_JobWIPEntry: Record "Job WIP Entry";
        NS_JobWIPGLEntry: Record "Job WIP G/L Entry";
        NS_SkipMessage: Boolean;
    begin
        If NS_JobSetup.Get() Then;
        if NS_JobSetup."NS_Skip Recalculate JobWIP" then begin
            If (xJob.Status = xJob.Status::Completed) and (Job.Complete = false) then begin
                NS_JobWIPGLEntry.Reset();
                NS_JobWIPGLEntry.SetRange("Job No.", Job."No.");
                if NS_JobWIPGLEntry.IsEmpty() then Begin
                    NS_SkipMessage := true;
                end;
                If NS_SkipMessage then begin
                    NS_JobWIPEntry.Reset();
                    NS_JobWIPEntry.SetRange("Job No.", Job."No.");
                    if NS_JobWIPEntry.IsEmpty() then begin
                        IsHandled := true;
                    end;
                End else
                    IsHandled := false;
            end;
        end;
    end;
    //PE-167.VC.1.3 27Sep2023 End   

    //PE-188.TY.1.0.16Oct2023 Start

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Time Sheet Approval Management", 'OnBeforeCheckApproverPermissions', '', false, false)]
    local procedure OnBeforeCheckApproverPermissions(var TimeSheetLine: Record "Time Sheet Line"; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Time Sheet Approval Management", 'OnApproveOnBeforeTimeSheetLineModify', '', false, false)]
    local procedure OnApproveOnBeforeTimeSheetLineModify(var TimeSheetLine: Record "Time Sheet Line")
    var
        UserSetup: Record "User Setup";
        TimeSheetHeader: Record "Time Sheet Header";
    begin
        If UserSetup.Get(UserId) then;
        IF TimeSheetHeader.get(TimeSheetLine."Time Sheet No.") OR (UserSetup."Time Sheet Admin.") then begin
            IF TimeSheetHeader."Approver User ID" > '' then begin
                TimeSheetLine.Status := TimeSheetLine.Status::Approved;
                TimeSheetLine."Approved By" := UserId;
                TimeSheetLine."Approval Date" := Today;
            end;
        end else
            // if not UserSetup."Time Sheet Admin." then
            //     if TimeSheetLine."Approver ID" <> UpperCase(UserId) then
                    Error(Text002);
    End;
    //PE-188.TY.1.0.16Oct2023 End 
}