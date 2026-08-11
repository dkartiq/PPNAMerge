report 14021158 "NS_ActualvsBudget Mat by APO"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-84.SK.1.0 Added report to search
    //PRJ-813.AS.1.0 Commented report not needed anymore
    //PE-79.RM.1.0 21Apr2023 | Changes in Layout only
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSActual vs Budget Mat by APO.rdl';
    ObsoleteReason = 'This report will not be release anymore';
    ObsoleteState = Pending;

    Caption = 'Actual vs Budget Material by APO';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(Job; Job)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Bill-to Customer No.", "NS_Date Filter", Status, "NS_Item No. Filter";
            column(Job_No_; "No.")
            {
            }
            dataitem(PageHeader; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                dataitem("Job Planning Line"; "Job Planning Line")
                {
                    DataItemLink = "Job No." = FIELD("No.");
                    DataItemLinkReference = Job;
                    DataItemTableView = SORTING("Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Cost Category", Type, "No.", "Variant Code") ORDER(Ascending);

                    trigger OnAfterGetRecord();
                    begin
                        if "NS_Cost Category" = 'REV' then
                            CurrReport.BREAK;
                        if JobRevCategory.GET("NS_Cost Category") then
                            CurrReport.BREAK;

                        if JobCostCategory.GET("NS_Cost Category") then begin
                            if JobCostCategory.NS_Type <> JobCostCategory.NS_Type::Material then
                                CurrReport.BREAK
                        end else
                            CurrReport.BREAK;
                        if not JobAnalysisBuffer.GET("Job No.", JobAnalysisBuffer."NS_Entry Type"::Cost,
                                                      "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                                     "NS_Cost Category", Type, "No.", "Variant Code", '') then begin
                            if "NS_Cost Category" <> '' then begin

                                JobAnalysisBuffer."NS_Job No." := "Job No.";
                                JobAnalysisBuffer."NS_Entry Type" := JobAnalysisBuffer."NS_Entry Type"::Cost;
                                JobAnalysisBuffer."NS_Activity Code" := "NS_Activity Code";
                                JobAnalysisBuffer."NS_Process Code" := "NS_Process Code";
                                JobAnalysisBuffer."NS_Operation Code" := "NS_Operation Code";
                                JobAnalysisBuffer.NS_Category := "NS_Cost Category";
                                JobAnalysisBuffer.NS_Type := Type;
                                JobAnalysisBuffer."NS_No." := "No.";
                                JobAnalysisBuffer."NS_Variant Code" := "Variant Code";
                                JobAnalysisBuffer.NS_Adjustment := NS_Adjustment;
                                if Description > '' then
                                    JobAnalysisBuffer.NS_Description := Description
                                else begin
                                    if Item.GET("No.") then
                                        JobAnalysisBuffer.NS_Description := Item.Description;
                                end;
                                JobAnalysisBuffer."NS_Budgeted Cost" := "Total Cost (LCY)";
                                JobAnalysisBuffer."NS_Budgeted Cost Qty." := Quantity;
                            end;
                        end else begin
                            JobAnalysisBuffer."NS_Budgeted Cost" := JobAnalysisBuffer."NS_Actual Cost" + "Total Cost (LCY)";
                            JobAnalysisBuffer."NS_Budgeted Cost Qty." := JobAnalysisBuffer."NS_Budgeted Cost Qty." + Quantity;
                            JobAnalysisBuffer.MODIFY;
                        end;
                    end;

                    trigger OnPreDataItem();
                    begin
                        SETFILTER("NS_Entry Type", '%1|%2', "NS_Entry Type"::Cost, "NS_Entry Type"::Both);
                        SETFILTER("NS_Activity Code", Job.GETFILTER("NS_Activity Filter"));
                        SETFILTER("NS_Process Code", Job.GETFILTER("NS_Process Filter"));
                        SETFILTER("NS_Operation Code", Job.GETFILTER("NS_Operation Filter"));
                        //PE-308.DK.1.0 13JUNE2024 Start
                        // SETFILTER(Type, Job.GETFILTER("NS_Type Filter"));
                        SETFILTER(Type, Job.GETFILTER("NS_TypeEnumFilter"));
                        //PE-308.DK.1.0 13JUNE2024 End
                        SETFILTER("Planning Date", Job.GETFILTER("NS_Date Filter"));

                        if Job.GETFILTER("NS_Item No. Filter") > '' then begin
                            SETFILTER(Type, FORMAT(Type::Item));
                            SETFILTER("No.", Job.GETFILTER("NS_Item No. Filter"));
                        end;
                        if Job.GETFILTER("NS_Global Dimension 1 Filter") > '' then
                            SETFILTER("NS_Shortcut Dimension 1 Code", Job.GETFILTER("NS_Global Dimension 1 Filter"));
                        if Job.GETFILTER("NS_Global Dimension 2 Filter") > '' then
                            SETFILTER("NS_Shortcut Dimension 2 Code", Job.GETFILTER("NS_Global Dimension 2 Filter"));
                    end;
                }
                dataitem("Job Ledger Entry"; "Job Ledger Entry")
                {
                    DataItemLink = "Job No." = FIELD("No.");
                    DataItemLinkReference = Job;
                    DataItemTableView = SORTING("Job No.", "Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Job Cost Category", "NS_Job Revenue Category", Type, "No.", "Resource Group No.", "Posting Date") ORDER(Ascending);

                    trigger OnAfterGetRecord();
                    begin
                        if not JobAnalysisBuffer.GET("Job No.", JobAnalysisBuffer."NS_Entry Type"::Cost,
                                                      "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                                     "NS_Job Cost Category", Type, "No.", "Variant Code", '') then begin
                            JobAnalysisBuffer.INIT;
                            JobAnalysisBuffer."NS_Job No." := "Job No.";
                            JobAnalysisBuffer."NS_Entry Type" := JobAnalysisBuffer."NS_Entry Type"::Cost;
                            JobAnalysisBuffer."NS_Activity Code" := "NS_Activity Code";
                            JobAnalysisBuffer."NS_Process Code" := "NS_Process Code";
                            JobAnalysisBuffer."NS_Operation Code" := "NS_Operation Code";
                            if JobCostCategory.GET("NS_Job Cost Category") then begin
                                if JobCostCategory.NS_Type <> JobCostCategory.NS_Type::Material then
                                    CurrReport.BREAK
                            end else
                                CurrReport.BREAK;
                            JobAnalysisBuffer.NS_Category := "NS_Job Cost Category";
                            JobAnalysisBuffer.NS_Type := Type;
                            JobAnalysisBuffer."NS_No." := "No.";
                            JobAnalysisBuffer."NS_Variant Code" := "Variant Code";
                            if Description > '' then
                                JobAnalysisBuffer.NS_Description := Description
                            else begin
                                if Item.GET("Job Planning Line"."No.") then
                                    JobAnalysisBuffer.NS_Description := Item.Description;
                            end;
                            JobAnalysisBuffer."NS_Actual Cost" := "Total Cost (LCY)";
                            JobAnalysisBuffer."NS_Actual Cost Qty." := Quantity;
                            JobAnalysisBuffer.NS_Adjustment := '';
                            JobAnalysisBuffer.INSERT;
                        end else begin
                            JobAnalysisBuffer."NS_Actual Cost" := JobAnalysisBuffer."NS_Actual Cost" + "Total Cost (LCY)";
                            JobAnalysisBuffer."NS_Actual Cost Qty." := JobAnalysisBuffer."NS_Actual Cost Qty." + Quantity;
                            JobAnalysisBuffer.MODIFY;
                        end;
                    end;

                    trigger OnPreDataItem();
                    begin
                        SETRANGE("Entry Type", "Entry Type"::Usage);
                        SETFILTER("NS_Activity Code", Job.GETFILTER("NS_Activity Filter"));
                        SETFILTER("NS_Process Code", Job.GETFILTER("NS_Process Filter"));
                        SETFILTER("NS_Operation Code", Job.GETFILTER("NS_Operation Filter"));
                        //PE-308.DK.1.0 13JUNE2024 Start
                        //SETFILTER(Type, Job.GETFILTER("NS_Type Filter"));
                        SETFILTER(Type, Job.GETFILTER("NS_TypeEnumFilter"));
                        //PE-308.DK.1.0 13JUNE2024 END
                        SETFILTER("Posting Date", Job.GETFILTER("NS_Date Filter"));
                        if Job.GETFILTER("NS_Item No. Filter") > '' then begin
                            SETFILTER(Type, FORMAT(Type::Item));
                            SETFILTER("No.", Job.GETFILTER("NS_Item No. Filter"));
                        end;
                    end;
                }
                dataitem("Sub-Levels"; Job)
                {
                    DataItemLink = "No." = FIELD("No.");
                    DataItemLinkReference = Job;
                    DataItemTableView = SORTING("No.") ORDER(Ascending);
                    dataitem("Job Planning Line Sub-Levels"; "Job Planning Line")
                    {
                        DataItemLink = "Job No." = FIELD("No.");
                        DataItemTableView = SORTING("Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Cost Category", Type, "No.", "Variant Code") ORDER(Ascending);

                        trigger OnAfterGetRecord();
                        begin
                            if JobCostCategory.GET("NS_Cost Category") then begin
                                if JobCostCategory.NS_Type <> JobCostCategory.NS_Type::Material then
                                    CurrReport.SKIP;
                            end else
                                CurrReport.SKIP;

                            if "NS_Cost Category" = '' then
                                "NS_Cost Category" := 'ZZZZZ';

                            JobAnalysisBuffer.RESET;
                            JobAnalysisBuffer.SETCURRENTKEY("NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                                            NS_Category, NS_Type, "NS_No.", "NS_Variant Code", NS_Adjustment);
                            JobAnalysisBuffer.SETRANGE("NS_Job No.", Job."No.");
                            JobAnalysisBuffer.SETRANGE("NS_Entry Type", JobAnalysisBuffer."NS_Entry Type"::Cost);
                            JobAnalysisBuffer.SETRANGE("NS_Activity Code", "NS_Activity Code");
                            JobAnalysisBuffer.SETRANGE("NS_Process Code", "NS_Process Code");
                            JobAnalysisBuffer.SETRANGE("NS_Operation Code", "NS_Operation Code");
                            JobAnalysisBuffer.SETRANGE(NS_Category, "NS_Cost Category");
                            if not JobAnalysisBuffer.FINDSET then begin
                                JobAnalysisBuffer.INIT;
                                JobAnalysisBuffer."NS_Job No." := Job."No.";
                                JobAnalysisBuffer."NS_Entry Type" := "NS_Entry Type";
                                JobAnalysisBuffer."NS_Activity Code" := "NS_Activity Code";
                                JobAnalysisBuffer."NS_Process Code" := "NS_Process Code";
                                JobAnalysisBuffer."NS_Operation Code" := "NS_Operation Code";
                                JobAnalysisBuffer.NS_Category := "NS_Cost Category";
                                JobAnalysisBuffer."NS_Budgeted Cost" := "Total Cost (LCY)";
                                JobAnalysisBuffer."NS_Budgeted Cost Qty." := Quantity;
                                if Description > '' then
                                    JobAnalysisBuffer.NS_Description := Description
                                else begin
                                    if Item.GET("Job Planning Line"."No.") then
                                        JobAnalysisBuffer.NS_Description := Item.Description;
                                end;
                                JobAnalysisBuffer.INSERT;
                            end else begin
                                JobAnalysisBuffer."NS_Budgeted Cost" := JobAnalysisBuffer."NS_Budgeted Cost" + "Total Cost (LCY)";
                                JobAnalysisBuffer."NS_Budgeted Cost Qty." := JobAnalysisBuffer."NS_Budgeted Cost Qty." + Quantity;
                                JobAnalysisBuffer.MODIFY;
                            end;
                        end;

                        trigger OnPreDataItem();
                        begin
                            SETFILTER("NS_Entry Type", '%1|%2', "NS_Entry Type"::Cost, "NS_Entry Type"::Both);
                            SETFILTER("NS_Activity Code", Job.GETFILTER("NS_Activity Filter"));
                            SETFILTER("NS_Process Code", Job.GETFILTER("NS_Process Filter"));
                            SETFILTER("NS_Operation Code", Job.GETFILTER("NS_Operation Filter"));
                            //PE-308.DK.1.0 13JUNE2024 Start
                            //SETFILTER(Type, Job.GETFILTER("NS_Type Filter"));
                            SETFILTER(Type, Job.GETFILTER("NS_TypeEnumFilter"));
                            //PE-308.DK.1.0 13JUNE2024 END
                            SETFILTER("Planning Date", Job.GETFILTER("NS_Date Filter"));
                            if Job.GETFILTER("NS_Item No. Filter") > '' then begin
                                SETFILTER(Type, FORMAT(Type::Item));
                                SETFILTER("No.", Job.GETFILTER("NS_Item No. Filter"));
                            end;
                        end;
                    }
                    dataitem("Job Ledger Entry Sub-Levels"; "Job Ledger Entry")
                    {
                        DataItemLink = "Job No." = FIELD("No.");
                        DataItemTableView = SORTING("Job No.", "Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Job Cost Category", "NS_Job Revenue Category", Type, "No.", "Resource Group No.", "Posting Date") ORDER(Ascending);

                        trigger OnAfterGetRecord();
                        begin
                            if JobCostCategory.GET("NS_Job Cost Category") then begin
                                if JobCostCategory.NS_Type <> JobCostCategory.NS_Type::Material then
                                    CurrReport.SKIP
                            end else
                                CurrReport.SKIP;

                            if "NS_Job Cost Category" = '' then
                                "NS_Job Cost Category" := 'ZZZZZ';

                            JobAnalysisBuffer.RESET;
                            JobAnalysisBuffer.SETCURRENTKEY("NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                                            NS_Category, NS_Type, "NS_No.", "NS_Variant Code");
                            JobAnalysisBuffer.SETRANGE("NS_Job No.", Job."No.");
                            JobAnalysisBuffer.SETRANGE("NS_Entry Type", JobAnalysisBuffer."NS_Entry Type"::Cost);
                            JobAnalysisBuffer.SETRANGE("NS_Activity Code", "NS_Activity Code");
                            JobAnalysisBuffer.SETRANGE("NS_Process Code", "NS_Process Code");
                            JobAnalysisBuffer.SETRANGE("NS_Operation Code", "NS_Operation Code");
                            JobAnalysisBuffer.SETRANGE(NS_Category, "NS_Job Cost Category");
                        end;

                        trigger OnPreDataItem();
                        begin
                            SETRANGE("Entry Type", "Entry Type"::Usage);
                            SETFILTER("NS_Activity Code", Job.GETFILTER("NS_Activity Filter"));
                            SETFILTER("NS_Process Code", Job.GETFILTER("NS_Process Filter"));
                            SETFILTER("NS_Operation Code", Job.GETFILTER("NS_Operation Filter"));
                            //PE-308.DK.1.0 13JUNE2024 Start
                            //SETFILTER(Type, Job.GETFILTER("NS_Type Filter"));
                            SETFILTER(Type, Job.GETFILTER("NS_TypeEnumFilter"));
                            //PE-308.DK.1.0 13JUNE2024 END
                            SETFILTER("Posting Date", Job.GETFILTER("NS_Date Filter"));
                            if Job.GETFILTER("NS_Item No. Filter") > '' then begin
                                SETFILTER(Type, FORMAT(Type::Item));
                                SETFILTER("No.", Job.GETFILTER("NS_Item No. Filter"));
                            end;
                        end;
                    }

                    trigger OnPreDataItem();
                    begin
                        if not "IncludeSub-Levels" then
                            CurrReport.BREAK;
                    end;
                }
                dataitem("Page Header"; "Integer")
                {
                    DataItemTableView = SORTING(Number) ORDER(Ascending);
                    PrintOnlyIfDetail = true;
                    column(USERID; USERID)
                    {
                    }
                    column(CurrReport_PAGENO; CurrReport.PAGENO)
                    {
                    }
                    column(TIME; TIME)
                    {
                    }
                    column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
                    {
                    }
                    column(STRSUBSTNO_Text000_Job__No___; STRSUBSTNO(Text000, Job."No."))
                    {
                    }
                    column(CompanyInformation_Name; CompanyInformation.Name)
                    {
                    }
                    column(Job_TABLECAPTION_____Filters______JobFilter; Job.TABLECAPTION + ' Filters: ' + JobFilter)
                    {
                    }
                    column(Job__Description_2_; Job."Description 2")
                    {
                    }
                    column(Job_FIELDCAPTION__Ending_Date____________FORMAT_Job__Ending_Date__; Job.FIELDCAPTION("Ending Date") + ': ' + FORMAT(Job."Ending Date"))
                    {
                    }
                    column(Job_Description; Job.Description)
                    {
                    }
                    column(Job_FIELDCAPTION__Starting_Date____________FORMAT_Job__Starting_Date__; Job.FIELDCAPTION("Starting Date") + ': ' + FORMAT(Job."Starting Date"))
                    {
                    }
                    column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                    {
                    }
                    column(Job_DescriptionCaption; Job_DescriptionCaptionLbl)
                    {
                    }
                    column(Cost_VarianceCaption; Cost_VarianceCaptionLbl)
                    {
                    }
                    column(Budgeted_Material_CostCaption; Budgeted_Material_CostCaptionLbl)
                    {
                    }
                    column(Actual__Material_CostCaption; Actual__Material_CostCaptionLbl)
                    {
                    }
                    column(No_Caption; No_CaptionLbl)
                    {
                    }
                    column(DescriptionCaption; DescriptionCaptionLbl)
                    {
                    }
                    column(Activity___Process___OperationCaption; Activity___Process___OperationCaptionLbl)
                    {
                    }
                    column(Cost_Percent_VarianceCaption; Cost_Percent_VarianceCaptionLbl)
                    {
                    }
                    column(Actual_Material_QtyCaption; Actual_Material_QtyCaptionLbl)
                    {
                    }
                    column(Budgeted_Material_QtyCaption; Budgeted_Material_QtyCaptionLbl)
                    {
                    }
                    column(Qty_VarianceCaption; Qty_VarianceCaptionLbl)
                    {
                    }
                    column(Qty_Percent_VarianceCaption; Qty_Percent_VarianceCaptionLbl)
                    {
                    }
                    column(Page_Header_Number; Number)
                    {
                    }
                    column(ShowProcesses; ShowProcesses)
                    {
                    }
                    column(ShowOperations; ShowOperations)
                    {
                    }
                    dataitem("Integer"; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(STRSUBSTNO_Text001__Operation__OperationCodetoPrint_; STRSUBSTNO(Text001, 'Operation', OperationCodetoPrint))
                        {
                        }
                        column(Activity_Description; Activity.NS_Description)
                        {
                        }
                        column(TotaltoPrintActualOpCost; TotaltoPrintActualOpCost)
                        {
                        }
                        column(TotaltoPrintBudgetOpCost; TotaltoPrintBudgetOpCost)
                        {
                        }
                        column(TotaltoPrintOpCostVariance; TotaltoPrintOpCostVariance)
                        {
                        }
                        column(TotaltoPrintOpCostVariance__; "TotaltoPrintOpCostVariance%")
                        {
                            DecimalPlaces = 1 : 1;
                        }
                        column(TotaltoPrintActualOpQty; TotaltoPrintActualOpQty)
                        {
                        }
                        column(TotaltoPrintBudgetOpQty; TotaltoPrintBudgetOpQty)
                        {
                        }
                        column(TotaltoPrintOpQtyVariance; TotaltoPrintOpQtyVariance)
                        {
                        }
                        column(TotaltoPrintOpQtyVariance__; "TotaltoPrintOpQtyVariance%")
                        {
                            DecimalPlaces = 1 : 1;
                        }
                        column(STRSUBSTNO_Text001__Process__ProcessCodetoPrint_; STRSUBSTNO(Text001, 'Process', ProcessCodetoPrint))
                        {
                        }
                        column(TotaltoPrintActualProCost; TotaltoPrintActualProCost)
                        {
                        }
                        column(TotaltoPrintBudgetProCost; TotaltoPrintBudgetProCost)
                        {
                        }
                        column(TotaltoPrintProCostVariance; TotaltoPrintProCostVariance)
                        {
                        }
                        column(TotaltoPrintProCostVariance__; "TotaltoPrintProCostVariance%")
                        {
                            DecimalPlaces = 1 : 1;
                        }
                        column(TotaltoPrintActualProQty; TotaltoPrintActualProQty)
                        {
                        }
                        column(TotaltoPrintBudgetProQty; TotaltoPrintBudgetProQty)
                        {
                        }
                        column(TotaltoPrintProQtyVariance; TotaltoPrintProQtyVariance)
                        {
                        }
                        column(TotaltoPrintProQtyVariance__; "TotaltoPrintProQtyVariance%")
                        {
                            DecimalPlaces = 1 : 1;
                        }
                        column(STRSUBSTNO_Text001__Activity__ActivityCodetoPrint_; STRSUBSTNO(Text001, 'Activity', ActivityCodetoPrint))
                        {
                        }
                        column(TotaltoPrintActualActCost; TotaltoPrintActualActCost)
                        {
                        }
                        column(TotaltoPrintBudgetActCost; TotaltoPrintBudgetActCost)
                        {
                        }
                        column(TotaltoPrintActCostVariance; TotaltoPrintActCostVariance)
                        {
                        }
                        column(TotaltoPrintActCostVariance__; "TotaltoPrintActCostVariance%")
                        {
                            DecimalPlaces = 1 : 1;
                        }
                        column(TotaltoPrintActualActQty; TotaltoPrintActualActQty)
                        {
                        }
                        column(TotaltoPrintBudgetActQty; TotaltoPrintBudgetActQty)
                        {
                        }
                        column(TotaltoPrintActQtyVariance; TotaltoPrintActQtyVariance)
                        {
                        }
                        column(TotaltoPrintActQtyVariance__; "TotaltoPrintActQtyVariance%")
                        {
                            DecimalPlaces = 1 : 1;
                        }
                        column(Activity_____Activity_Code; 'Activity ' + JobAnalysisBuffer."NS_Activity Code")
                        {
                        }
                        column(Process_Description; Process.NS_Description)
                        {
                        }
                        column(Process______Process_Code; 'Process ' + JobAnalysisBuffer."NS_Process Code")
                        {
                        }
                        column(Operation_Description; Operation.NS_Description)
                        {
                        }
                        column(Operation_____Operation_Code; 'Operation ' + JobAnalysisBuffer."NS_Operation Code")
                        {
                        }
                        column(JobAnalysisBuffer_Description; JobAnalysisBuffer.NS_Description)
                        {
                        }
                        column(JobAnalysisBuffer__Budgeted_Cost_; JobAnalysisBuffer."NS_Budgeted Cost")
                        {
                        }
                        column(Variance; Variance)
                        {
                        }
                        column(Variance__; "Variance%")
                        {
                            DecimalPlaces = 1 : 1;
                        }
                        column(JobAnalysisBuffer__No__; JobAnalysisBuffer."NS_No.")
                        {
                        }
                        column(JobAnalysisBuffer__Actual_Cost_; JobAnalysisBuffer."NS_Actual Cost")
                        {
                        }
                        column(JobAnalysisBuffer__Actual_Cost_Qty__; JobAnalysisBuffer."NS_Actual Cost Qty.")
                        {
                        }
                        column(JobAnalysisBuffer__Budgeted_Cost_Qty__; JobAnalysisBuffer."NS_Budgeted Cost Qty.")
                        {
                        }
                        column(QtyVariance; QtyVariance)
                        {
                        }
                        column(QtyVariance__; "QtyVariance%")
                        {
                            DecimalPlaces = 1 : 1;
                        }
                        column(TotalActualCost; TotalActualCost)
                        {
                        }
                        column(TotalBudgetCost; TotalBudgetCost)
                        {
                        }
                        column(TotalCostVariance; TotalCostVariance)
                        {
                        }
                        column(TotalCostVariance__; "TotalCostVariance%")
                        {
                            DecimalPlaces = 1 : 1;
                        }
                        column(STRSUBSTNO_Text002_Job__No___; STRSUBSTNO(Text002, Job."No."))
                        {
                        }
                        column(STRSUBSTNO_Text003_Job__No___; STRSUBSTNO(Text003, Job."No."))
                        {
                        }
                        column(TotalActualQty; TotalActualQty)
                        {
                        }
                        column(TotalBudgetQty; TotalBudgetQty)
                        {
                        }
                        column(TotalQtyVariance; TotalQtyVariance)
                        {
                        }
                        column(TotalQtyVariance__; "TotalQtyVariance%")
                        {
                            DecimalPlaces = 1 : 1;
                        }
                        column(Integer_Number; Number)
                        {
                        }

                        trigger OnAfterGetRecord();
                        begin
                            PrintOperationSection := false;
                            PrintProcessSection := false;
                            PrintActivitySection := false;
                            PrintBeginActivitySection := false;
                            PrintBeginProcessSection := false;
                            PrintBeginOperationSection := false;

                            if Number = 1 then
                                JobAnalysisBuffer.FINDSET
                            else
                                if Number > NumBudgetLines then
                                    CLEAR(JobAnalysisBuffer)
                                else
                                    JobAnalysisBuffer.NEXT;
                            if Number = 1 then begin
                                BeginActivityCode;
                                BeginProcessCode;
                                BeginOperationCode;
                            end else
                                if Number > NumBudgetLines then begin
                                    EndActivityCode;
                                    EndProcessCode;
                                    EndOperationCode;
                                end else begin
                                    if JobAnalysisBuffer."NS_Activity Code" <> OldActivityCode then begin
                                        ActivityChange;
                                        ProcessChange;
                                        OperationChange;
                                    end else
                                        if JobAnalysisBuffer."NS_Process Code" <> OldProcessCode then begin
                                            ProcessChange;
                                            OperationChange;
                                        end else
                                            if JobAnalysisBuffer."NS_Operation Code" <> OldOperationCode then
                                                OperationChange;
                                end;
                            if JobAnalysisBuffer."NS_Activity Code" <> '' then begin
                                if not Activity.GET(JobAnalysisBuffer."NS_Entry Type"::Cost, JobAnalysisBuffer."NS_Activity Code") then
                                    Activity.GET(Activity.NS_Type::Revenue, JobAnalysisBuffer."NS_Activity Code")
                                else
                                    Activity.GET(JobAnalysisBuffer."NS_Entry Type"::Cost, JobAnalysisBuffer."NS_Activity Code");
                            end;

                            //Accumulate totals
                            TotalActualQty := TotalActualQty + JobAnalysisBuffer."NS_Actual Cost Qty.";
                            TotalBudgetQty := TotalBudgetQty + JobAnalysisBuffer."NS_Budgeted Cost Qty.";
                            TotalActualCost := TotalActualCost + JobAnalysisBuffer."NS_Actual Cost";
                            TotalBudgetCost := TotalBudgetCost + JobAnalysisBuffer."NS_Budgeted Cost";

                            if (JobAnalysisBuffer."NS_Activity Code" > '') then begin
                                TotalActualActQty := TotalActualActQty + JobAnalysisBuffer."NS_Actual Cost Qty.";
                                TotalBudgetActQty := TotalBudgetActQty + JobAnalysisBuffer."NS_Budgeted Cost Qty.";
                                TotalActualActCost := TotalActualActCost + JobAnalysisBuffer."NS_Actual Cost";
                                TotalBudgetActCost := TotalBudgetActCost + JobAnalysisBuffer."NS_Budgeted Cost";
                            end;

                            if (JobAnalysisBuffer."NS_Process Code" > '') then begin
                                TotalActualProQty := TotalActualProQty + JobAnalysisBuffer."NS_Actual Cost Qty.";
                                TotalBudgetProQty := TotalBudgetProQty + JobAnalysisBuffer."NS_Budgeted Cost Qty.";
                                TotalActualProCost := TotalActualProCost + JobAnalysisBuffer."NS_Actual Cost";
                                TotalBudgetProCost := TotalBudgetProCost + JobAnalysisBuffer."NS_Budgeted Cost";
                            end;

                            if JobAnalysisBuffer."NS_Operation Code" > '' then begin
                                TotalActualOpQty := TotalActualOpQty + JobAnalysisBuffer."NS_Actual Cost Qty.";
                                TotalBudgetOpQty := TotalBudgetOpQty + JobAnalysisBuffer."NS_Budgeted Cost Qty.";
                                TotalActualOpCost := TotalActualOpCost + JobAnalysisBuffer."NS_Actual Cost";
                                TotalBudgetOpCost := TotalBudgetOpCost + JobAnalysisBuffer."NS_Budgeted Cost";
                            end;
                        end;

                        trigger OnPreDataItem();
                        begin
                            JobAnalysisBuffer.RESET;
                            NumBudgetLines := JobAnalysisBuffer.COUNT;
                            if NumBudgetLines = 0 then
                                CurrReport.BREAK;
                            SETRANGE(Number, 1, NumBudgetLines + 1);
                            Job.COPYFILTER("NS_Date Filter", JobAnalysisBuffer."NS_Date Filter");
                            TotalActualQty := 0;
                            TotalBudgetQty := 0;
                            TotalActualCost := 0;
                            TotalBudgetCost := 0;
                        end;
                    }

                    trigger OnPreDataItem();
                    begin
                        SETRANGE(Number, 1);
                    end;
                }
            }

            trigger OnAfterGetRecord();
            begin
                JobAnalysisBuffer.DELETEALL;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                //SMPL
                //CaptionML = ENU='Options',
                //ENA='Options';
                field("Include Sub-Levels"; "IncludeSub-Levels")
                {
                    Caption = 'Include Sub-Levels';
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        if not "IncludeSub-Levels" then begin
                            "ShowSub-Levels" := false;
                        end;
                    end;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        CompanyInformation.GET;
        JobFilter := Job.GETFILTERS;
    end;

    var
        CompanyInformation: Record "Company Information";
        Activity: Record "NS_Job Activity";
        Process: Record "NS_Job Process";
        Operation: Record "NS_Job Operation";
        JobAnalysisBuffer: Record "NS_Job Analysis Buffer" temporary;
        JobCostCategory: Record "NS_Job Cost Category";
        Item: Record Item;
        NumBudgetLines: Integer;
        JobFilter: Text[250];
        "Detail------------------------": Decimal;
        QtyVariance: Decimal;
        "QtyVariance%": Decimal;
        Variance: Decimal;
        "Variance%": Decimal;
        "1-----------------------------": Decimal;
        TotaltoPrintActualActQty: Decimal;
        TotaltoPrintBudgetActQty: Decimal;
        TotaltoPrintActQtyVariance: Decimal;
        "TotaltoPrintActQtyVariance%": Decimal;
        TotaltoPrintActualActCost: Decimal;
        TotaltoPrintBudgetActCost: Decimal;
        TotaltoPrintActCostVariance: Decimal;
        "TotaltoPrintActCostVariance%": Decimal;
        "2-----------------------------": Decimal;
        TotaltoPrintActualProQty: Decimal;
        TotaltoPrintBudgetProQty: Decimal;
        TotaltoPrintProQtyVariance: Decimal;
        "TotaltoPrintProQtyVariance%": Decimal;
        TotaltoPrintActualProCost: Decimal;
        TotaltoPrintBudgetProCost: Decimal;
        TotaltoPrintProCostVariance: Decimal;
        "TotaltoPrintProCostVariance%": Decimal;
        "3-----------------------------": Decimal;
        TotaltoPrintActualOpQty: Decimal;
        TotaltoPrintBudgetOpQty: Decimal;
        TotaltoPrintOpQtyVariance: Decimal;
        "TotaltoPrintOpQtyVariance%": Decimal;
        TotaltoPrintActualOpCost: Decimal;
        TotaltoPrintBudgetOpCost: Decimal;
        TotaltoPrintOpCostVariance: Decimal;
        "TotaltoPrintOpCostVariance%": Decimal;
        "4-----------------------------": Decimal;
        TotalActualQty: Decimal;
        TotalBudgetQty: Decimal;
        TotalQtyVariance: Decimal;
        "TotalQtyVariance%": Decimal;
        TotalActualCost: Decimal;
        TotalBudgetCost: Decimal;
        TotalCostVariance: Decimal;
        "TotalCostVariance%": Decimal;
        "Totals------------------------": Decimal;
        TotalActualActQty: Decimal;
        TotalBudgetActQty: Decimal;
        TotalActualActCost: Decimal;
        TotalBudgetActCost: Decimal;
        TotalActualProQty: Decimal;
        TotalBudgetProQty: Decimal;
        TotalActualProCost: Decimal;
        TotalBudgetProCost: Decimal;
        TotalActualOpQty: Decimal;
        TotalBudgetOpQty: Decimal;
        TotalActualOpCost: Decimal;
        TotalBudgetOpCost: Decimal;
        "------------------------------": Decimal;
        OperationCodetoPrint: Code[10];
        OldOperationCode: Code[10];
        PrintBeginOperationSection: Boolean;
        PrintOperationSection: Boolean;
        ProcessCodetoPrint: Code[10];
        OldProcessCode: Code[10];
        PrintBeginProcessSection: Boolean;
        PrintProcessSection: Boolean;
        ActivityCodetoPrint: Code[10];
        OldActivityCode: Code[10];
        PrintBeginActivitySection: Boolean;
        PrintActivitySection: Boolean;
        Text000: Label 'Actual Material to Budget Material by APO for Job %1';
        Text001: Label 'Total %1 %2';
        Text002: Label 'Total Job %1';
        "IncludeSub-Levels": Boolean;
        Text003: Label 'Total Job %1';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Job_DescriptionCaptionLbl: Label 'Job Description';
        Cost_VarianceCaptionLbl: Label 'Cost Variance';
        Budgeted_Material_CostCaptionLbl: Label 'Budgeted Material Cost';
        Actual__Material_CostCaptionLbl: Label 'Actual  Material Cost';
        No_CaptionLbl: Label 'No.';
        DescriptionCaptionLbl: Label 'Description';
        Activity___Process___OperationCaptionLbl: Label 'Activity / Process / Operation';
        Cost_Percent_VarianceCaptionLbl: Label 'Cost Percent Variance';
        Actual_Material_QtyCaptionLbl: Label 'Actual Material Qty';
        Budgeted_Material_QtyCaptionLbl: Label 'Budgeted Material Qty';
        Qty_VarianceCaptionLbl: Label 'Qty Variance';
        Qty_Percent_VarianceCaptionLbl: Label 'Qty Percent Variance';
        "ShowSub-Levels": Boolean;
        ShowProcesses: Boolean;
        ShowOperations: Boolean;
        JobRevCategory: Record "NS_Job Revenue Category";

    procedure OperationChange();
    begin
        EndOperationCode;
        BeginOperationCode;
    end;

    procedure EndOperationCode();
    begin
        PrintOperationSection := OldOperationCode <> '';
        TotaltoPrintActualOpQty := TotalActualOpQty;
        TotaltoPrintBudgetOpQty := TotalBudgetOpQty;
        TotaltoPrintActualOpCost := TotalActualOpCost;
        TotaltoPrintBudgetOpCost := TotalBudgetOpCost;
        OperationCodetoPrint := OldOperationCode;
    end;

    procedure BeginOperationCode();
    begin
        OldOperationCode := JobAnalysisBuffer."NS_Operation Code";
        TotalActualOpQty := 0;
        TotalBudgetOpQty := 0;
        TotalActualOpCost := 0;
        TotalBudgetOpCost := 0;
        if JobAnalysisBuffer."NS_Operation Code" <> '' then
            Operation.GET(Operation.NS_Type::Cost,
                          JobAnalysisBuffer."NS_Activity Code",
                          JobAnalysisBuffer."NS_Process Code",
                          JobAnalysisBuffer."NS_Operation Code")
        else
            CLEAR(Operation);
        PrintBeginOperationSection := JobAnalysisBuffer."NS_Operation Code" <> '';
    end;

    procedure ProcessChange();
    begin
        EndProcessCode;
        BeginProcessCode;
    end;

    procedure EndProcessCode();
    begin
        PrintProcessSection := OldProcessCode <> '';
        TotaltoPrintActualProQty := TotalActualProQty;
        TotaltoPrintBudgetProQty := TotalBudgetProQty;
        TotaltoPrintActualProCost := TotalActualProCost;
        TotaltoPrintBudgetProCost := TotalBudgetProCost;
        ProcessCodetoPrint := OldProcessCode;
    end;

    procedure BeginProcessCode();
    begin
        OldProcessCode := JobAnalysisBuffer."NS_Process Code";
        TotalActualProQty := 0;
        TotalBudgetProQty := 0;
        TotalActualProCost := 0;
        TotalBudgetProCost := 0;
        if JobAnalysisBuffer."NS_Process Code" <> '' then
            Process.GET(Process.NS_Type::Cost,
                        JobAnalysisBuffer."NS_Activity Code",
                        JobAnalysisBuffer."NS_Process Code")
        else
            CLEAR(Process);
        PrintBeginProcessSection := JobAnalysisBuffer."NS_Process Code" <> '';
    end;

    procedure ActivityChange();
    begin
        EndActivityCode;
        BeginActivityCode;
    end;

    procedure EndActivityCode();
    begin
        PrintActivitySection := true;
        TotaltoPrintActualActQty := TotalActualActQty;
        TotaltoPrintBudgetActQty := TotalBudgetActQty;
        TotaltoPrintActualActCost := TotalActualActCost;
        TotaltoPrintBudgetActCost := TotalBudgetActCost;
        ActivityCodetoPrint := OldActivityCode;
    end;

    procedure BeginActivityCode();
    begin
        OldActivityCode := JobAnalysisBuffer."NS_Activity Code";
        TotalActualActQty := 0;
        TotalBudgetActQty := 0;
        TotalActualActCost := 0;
        TotalBudgetActCost := 0;
        if JobAnalysisBuffer."NS_Activity Code" <> '' then
            Activity.GET(Activity.NS_Type::Cost,
                         JobAnalysisBuffer."NS_Activity Code")
        else
            CLEAR(Activity);
        PrintBeginActivitySection := true;
    end;
}

