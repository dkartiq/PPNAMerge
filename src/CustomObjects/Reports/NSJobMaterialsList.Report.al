report 14021190 "NS_Job Materials List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-84.SK.1.0 Added report to search
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSJob Materials List.rdl';
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Job Materials List';
    ApplicationArea = all;

    dataset
    {
        dataitem(Job; Job)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Bill-to Customer No.", "NS_Date Filter", Status, "NS_Activity Filter", "NS_Process Filter", "NS_Operation Filter", "NS_Item No. Filter";
            column(Job_No_; "No.")
            {
            }
            dataitem(PageHeader; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(USERID; USERID)
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
                column(Job_Sub_Levels_are_combined_Caption; Job_Sub_Levels_are_combined_CaptionLbl)
                {
                }
                column(Job_DescriptionCaption; Job_DescriptionCaptionLbl)
                {
                }
                column(No_Caption; No_CaptionLbl)
                {
                }
                column(DescriptionCaption; DescriptionCaptionLbl)
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
                column(JobAnalysisBuffer__Job_No__Caption; JobAnalysisBuffer__Job_No__CaptionLbl)
                {
                }
                column(PageHeader_Number; Number)
                {
                }
                dataitem("Job Planning Line"; "Job Planning Line")
                {
                    DataItemLinkReference = Job;
                    DataItemTableView = SORTING("Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Cost Category", Type, "No.", "Variant Code") ORDER(Ascending);

                    trigger OnAfterGetRecord();
                    begin
                        if JobCostCategory.GET("Job Planning Line"."NS_Cost Category") then begin
                            if JobCostCategory.NS_Type <> JobCostCategory.NS_Type::Material then
                                CurrReport.SKIP
                        end else
                            CurrReport.SKIP;

                        JobAnalysisBuffer.RESET();
                        JobAnalysisBuffer.SETCURRENTKEY("NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                                        NS_Category, NS_Type, "NS_No.", "NS_Variant Code", NS_Adjustment);
                        JobAnalysisBuffer.SETRANGE("NS_Job No.", "Job No.");
                        JobAnalysisBuffer.SETRANGE("NS_Entry Type", "NS_Entry Type");
                        JobAnalysisBuffer.SETRANGE("NS_Activity Code", "NS_Activity Code");
                        JobAnalysisBuffer.SETRANGE("NS_Process Code", "NS_Process Code");
                        JobAnalysisBuffer.SETRANGE("NS_Job Task No.", "NS_Operation Code");
                        JobAnalysisBuffer.SETRANGE(NS_Category, "NS_Cost Category");
                        JobAnalysisBuffer.SETRANGE(NS_Type, Type);
                        JobAnalysisBuffer.SETRANGE("NS_No.", "No.");
                        JobAnalysisBuffer.SETRANGE("NS_Variant Code", "Variant Code");
                        if not JobAnalysisBuffer.FINDFIRST() then begin
                            JobAnalysisBuffer.INIT();
                            JobAnalysisBuffer."NS_Job No." := "Job No.";
                            JobAnalysisBuffer."NS_Entry Type" := "NS_Entry Type";
                            JobAnalysisBuffer."NS_Activity Code" := "NS_Activity Code";
                            JobAnalysisBuffer."NS_Process Code" := "NS_Process Code";
                            JobAnalysisBuffer."NS_Operation Code" := "NS_Operation Code";
                            JobAnalysisBuffer.NS_Category := "NS_Cost Category";
                            JobAnalysisBuffer.NS_Type := Type;
                            JobAnalysisBuffer."NS_No." := "No.";
                            JobAnalysisBuffer."NS_Variant Code" := "Variant Code";
                            JobAnalysisBuffer."NS_Budgeted Cost" := "Total Cost";
                            JobAnalysisBuffer."NS_Budgeted Cost Qty." := Quantity;
                            if Description > '' then
                                JobAnalysisBuffer.NS_Description := Description
                            else begin
                                if Item.GET("Job Planning Line"."No.") then
                                    JobAnalysisBuffer.NS_Description := Item.Description;
                            end;
                            JobAnalysisBuffer.INSERT();
                        end else begin
                            if (JobAnalysisBuffer.NS_Description = '') and (Description > '') then
                                JobAnalysisBuffer.NS_Description := Description;
                            JobAnalysisBuffer."NS_Budgeted Cost" := JobAnalysisBuffer."NS_Budgeted Cost" + "Total Cost";
                            JobAnalysisBuffer."NS_Budgeted Cost Qty." := JobAnalysisBuffer."NS_Budgeted Cost Qty." + Quantity;
                            JobAnalysisBuffer.MODIFY();
                        end;
                    end;

                    trigger OnPreDataItem();
                    begin
                        SETRANGE("Job No.", Job."No.");
                        SETFILTER("NS_Entry Type", '%1|%2', "NS_Entry Type"::Cost, "NS_Entry Type"::Both);
                        SETFILTER("NS_Activity Code", Job.GETFILTER("NS_Activity Filter"));
                        SETFILTER("NS_Process Code", Job.GETFILTER("NS_Process Filter"));
                        SETFILTER("NS_Operation Code", Job.GETFILTER("NS_Operation Filter"));
                        SETFILTER(Type, Job.GETFILTER("NS_Type Filter"));
                        SETFILTER("Planning Date", Job.GETFILTER("NS_Date Filter"));
                    end;
                }
                dataitem("Job Ledger Entry"; "Job Ledger Entry")
                {
                    DataItemLinkReference = Job;
                    DataItemTableView = SORTING("Job No.", "Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Job Cost Category", "NS_Job Revenue Category", Type, "No.", "Resource Group No.", "Posting Date") ORDER(Ascending);

                    trigger OnAfterGetRecord();
                    begin
                        if JobCostCategory.GET("NS_Job Cost Category") then begin
                            if JobCostCategory.NS_Type <> JobCostCategory.NS_Type::Material then
                                CurrReport.SKIP;
                        end else
                            CurrReport.SKIP;

                        //If the record is not in the budget we are not reporting it just becuase it is in the ledger!
                        if JobAnalysisBuffer.GET("Job No.", JobAnalysisBuffer."NS_Entry Type"::Cost, "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                                 "NS_Job Cost Category", Type, "No.", "Variant Code", '') then begin
                            if (JobAnalysisBuffer.NS_Description = '') and (Description > '') then
                                JobAnalysisBuffer.NS_Description := Description;

                            JobAnalysisBuffer."NS_Actual Cost" := JobAnalysisBuffer."NS_Actual Cost" + "Total Cost";
                            JobAnalysisBuffer."NS_Actual Cost Qty." := JobAnalysisBuffer."NS_Actual Cost Qty." + Quantity;
                            JobAnalysisBuffer.MODIFY();
                        end;
                    end;

                    trigger OnPreDataItem();
                    begin
                        SETRANGE("Job No.", Job."No.");
                        SETRANGE("Entry Type", "Entry Type"::Usage);
                        SETFILTER(Type, '<>%1', Type::NS_Ledger);
                        SETFILTER("NS_Activity Code", Job.GETFILTER("NS_Activity Filter"));
                        SETFILTER("NS_Process Code", Job.GETFILTER("NS_Process Filter"));
                        SETFILTER("NS_Operation Code", Job.GETFILTER("NS_Operation Filter"));
                        SETFILTER("Posting Date", Job.GETFILTER("NS_Date Filter"));
                    end;
                }
                dataitem("Sub-Levels"; Job)
                {
                    DataItemLink = "NS_Sub-Level to Job No." = FIELD("No.");
                    DataItemLinkReference = Job;
                    DataItemTableView = SORTING("No.") ORDER(Ascending);
                    dataitem("Job Planning Line Sub-Levels"; "Job Planning Line")
                    {
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

                            if "CombineSub-Levels" then
                                SubJobNo := Job."No."
                            else
                                SubJobNo := "Job No.";

                            JobAnalysisBuffer.RESET();
                            JobAnalysisBuffer.SETCURRENTKEY("NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                                            NS_Category, NS_Type, "NS_No.", "NS_Variant Code", NS_Adjustment);
                            JobAnalysisBuffer.SETRANGE("NS_Job No.", SubJobNo);
                            JobAnalysisBuffer.SETRANGE("NS_Entry Type", "NS_Entry Type");
                            JobAnalysisBuffer.SETRANGE("NS_Activity Code", "NS_Activity Code");
                            JobAnalysisBuffer.SETRANGE("NS_Process Code", "NS_Process Code");
                            JobAnalysisBuffer.SETRANGE("NS_Operation Code", "NS_Operation Code");
                            JobAnalysisBuffer.SETRANGE(NS_Category, "NS_Cost Category");
                            JobAnalysisBuffer.SETRANGE(NS_Type, Type);
                            JobAnalysisBuffer.SETRANGE("NS_No.", "No.");
                            JobAnalysisBuffer.SETRANGE("NS_Variant Code", "Variant Code");
                            if not JobAnalysisBuffer.FINDFIRST() then begin
                                JobAnalysisBuffer.INIT();
                                JobAnalysisBuffer."NS_Job No." := SubJobNo;
                                JobAnalysisBuffer."NS_Entry Type" := "NS_Entry Type";
                                JobAnalysisBuffer."NS_Activity Code" := "NS_Activity Code";
                                JobAnalysisBuffer."NS_Process Code" := "NS_Process Code";
                                JobAnalysisBuffer."NS_Operation Code" := "NS_Operation Code";
                                JobAnalysisBuffer.NS_Category := "NS_Cost Category";
                                JobAnalysisBuffer.NS_Type := Type;
                                JobAnalysisBuffer."NS_No." := "No.";
                                JobAnalysisBuffer."NS_Variant Code" := "Variant Code";
                                JobAnalysisBuffer."NS_Budgeted Cost" := "Total Cost";
                                JobAnalysisBuffer."NS_Budgeted Cost Qty." := Quantity;
                                if Description > '' then
                                    JobAnalysisBuffer.NS_Description := Description
                                else begin
                                    if Item.GET("Job Planning Line"."No.") then
                                        JobAnalysisBuffer.NS_Description := Item.Description;
                                end;
                                JobAnalysisBuffer.INSERT();
                            end else begin
                                if (JobAnalysisBuffer.NS_Description = '') and (Description > '') then
                                    JobAnalysisBuffer.NS_Description := Description;
                                JobAnalysisBuffer."NS_Budgeted Cost" := JobAnalysisBuffer."NS_Budgeted Cost" + "Total Cost";
                                JobAnalysisBuffer."NS_Budgeted Cost Qty." := JobAnalysisBuffer."NS_Budgeted Cost Qty." + Quantity;
                                JobAnalysisBuffer.MODIFY();
                            end;
                        end;

                        trigger OnPreDataItem();
                        begin
                            SETRANGE("Job No.", "Sub-Levels"."No.");
                            SETFILTER("NS_Entry Type", '%1|%2', "NS_Entry Type"::Cost, "NS_Entry Type"::Both);
                            SETFILTER("NS_Activity Code", Job.GETFILTER("NS_Activity Filter"));
                            SETFILTER("NS_Process Code", Job.GETFILTER("NS_Process Filter"));
                            SETFILTER("NS_Operation Code", Job.GETFILTER("NS_Operation Filter"));
                            SETFILTER("Planning Date", Job.GETFILTER("NS_Date Filter"));
                        end;
                    }
                    dataitem("Job Ledger Entry Sub-Levels"; "Job Ledger Entry")
                    {
                        DataItemTableView = SORTING("Job No.", "Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Job Cost Category", "NS_Job Revenue Category", Type, "No.", "Resource Group No.", "Posting Date") ORDER(Ascending);

                        trigger OnAfterGetRecord();
                        begin
                            if JobCostCategory.GET("NS_Job Cost Category") then begin
                                if JobCostCategory.NS_Type <> JobCostCategory.NS_Type::Material then
                                    CurrReport.SKIP;
                            end else
                                CurrReport.SKIP;

                            if "CombineSub-Levels" then
                                SubJobNo := Job."No."
                            else
                                SubJobNo := "Job No.";

                            //If the record is not in the budget we are not reporting it just becuase it is in the ledger!
                            //IF JobAnalysisBuffer.GET(SubJobNo,JobAnalysisBuffer."Entry Type"::Cost,"Activity Code","Process Code","Operation Code",
                            //                         "Job Cost Category",Type,"No.","Variant Code",'') THEN BEGIN
                            if JobAnalysisBuffer.GET(SubJobNo, JobAnalysisBuffer."NS_Entry Type"::Cost, "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                                     "NS_Job Cost Category", Type, "No.", "Variant Code", '', 0) then begin

                                if (JobAnalysisBuffer.NS_Description = '') and (Description > '') then
                                    JobAnalysisBuffer.NS_Description := Description;
                                JobAnalysisBuffer."NS_Actual Cost" := JobAnalysisBuffer."NS_Actual Cost" + "Total Cost";
                                JobAnalysisBuffer."NS_Actual Cost Qty." := JobAnalysisBuffer."NS_Actual Cost Qty." + Quantity;
                                JobAnalysisBuffer.MODIFY();
                            end;
                        end;

                        trigger OnPreDataItem();
                        begin
                            SETRANGE("Job No.", "Sub-Levels"."No.");
                            SETRANGE("Entry Type", "Entry Type"::Usage);
                            SETFILTER(Type, '<>%1', Type::NS_Ledger);
                            SETFILTER("NS_Activity Code", Job.GETFILTER("NS_Activity Filter"));
                            SETFILTER("NS_Process Code", Job.GETFILTER("NS_Process Filter"));
                            SETFILTER("NS_Operation Code", Job.GETFILTER("NS_Operation Filter"));
                            SETFILTER("Posting Date", Job.GETFILTER("NS_Date Filter"));
                        end;
                    }

                    trigger OnPreDataItem();
                    begin
                        if not "IncludeSub-Levels" then
                            CurrReport.BREAK;
                    end;
                }
                dataitem("Integer"; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    column(JobAnalysisBuffer__No__; JobAnalysisBuffer."NS_No.")
                    {
                    }
                    column(JobAnalysisBuffer_Description; JobAnalysisBuffer.NS_Description)
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
                    column(QtyVariancePct; QtyVariancePct)
                    {
                    }
                    column(JobAnalysisBuffer__Job_No__; JobAnalysisBuffer."NS_Job No.")
                    {
                    }
                    column(Integer_Number; Number)
                    {
                    }

                    trigger OnAfterGetRecord();
                    begin
                        if Number = 1 then
                            JobAnalysisBuffer.FINDSET()
                        else
                            if Number > NumBudgetLines then
                                CLEAR(JobAnalysisBuffer)
                            else
                                JobAnalysisBuffer.NEXT();
                    end;

                    trigger OnPreDataItem();
                    begin
                        JobAnalysisBuffer.RESET;
                        JobAnalysisBuffer.SETCURRENTKEY("NS_Job No.", "NS_Entry Type", NS_Type, "NS_No.");
                        NumBudgetLines := JobAnalysisBuffer.COUNT;
                        if NumBudgetLines = 0 then
                            CurrReport.BREAK;
                        SETRANGE(Number, 1, NumBudgetLines);
                        Job.COPYFILTER("NS_Date Filter", JobAnalysisBuffer."NS_Date Filter");
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
                group(Options)
                {
                    field("Include Sub-Levels"; "IncludeSub-Levels")
                    {
                        ApplicationArea = All;
                    }
                    field("Combine Sub-Levels"; "CombineSub-Levels")
                    {
                        ApplicationArea = All;
                    }
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
        SubJobNo: Code[20];
        NumBudgetLines: Integer;
        JobFilter: Text[250];
        QtyVariance: Decimal;
        QtyVariancePct: Decimal;
        Variance: Decimal;
        VariancePct: Decimal;
        Text000: Label 'Job Materials List';
        "IncludeSub-Levels": Boolean;
        "CombineSub-Levels": Boolean;
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Job_Sub_Levels_are_combined_CaptionLbl: Label 'Job Sub-Levels are combined.';
        Job_DescriptionCaptionLbl: Label 'Job Description:';
        No_CaptionLbl: Label 'No.';
        DescriptionCaptionLbl: Label 'Description';
        Actual_Material_QtyCaptionLbl: Label 'Actual Material Qty';
        Budgeted_Material_QtyCaptionLbl: Label 'Budgeted Material Qty';
        Qty_VarianceCaptionLbl: Label 'Qty Variance';
        Qty_Percent_VarianceCaptionLbl: Label 'Qty Percent Variance';
        JobAnalysisBuffer__Job_No__CaptionLbl: Label 'Job No.';
}

