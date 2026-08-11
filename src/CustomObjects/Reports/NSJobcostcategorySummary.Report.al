report 14021178 "NS_Job Cost Category Summary"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //SMPL - Caption = 'RequestPage' can't be used on area
    //PRJ-84.SK.1.0 Added report to search
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSJob Cost Category Summary.rdl';
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Job Cost Category Summary';
    ApplicationArea = all;

    dataset
    {
        dataitem(Job; Job)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Bill-to Customer No.", "NS_Date Filter", Status;
            column(TIME; TIME)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(USERID; USERID)
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(Sub_LevelsText_; "Sub-LevelsText")
            {
            }
            column(Job_TABLECAPTION_____Filters______JobFilter; Job.TABLECAPTION + ' Filters: ' + JobFilter)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Job_Cost_Category_SummaryCaption; Job_Cost_Category_SummaryCaptionLbl)
            {
            }
            column(Inv_ActCaption; Inv_ActCaptionLbl)
            {
            }
            column(Amt_InvoicedCaption; Amt_InvoicedCaptionLbl)
            {
            }
            column(Com_ActCaption; Com_ActCaptionLbl)
            {
            }
            column(Est_ActCaption; Est_ActCaptionLbl)
            {
            }
            column(ActualCaption; ActualCaptionLbl)
            {
            }
            column(CommittedCaption; CommittedCaptionLbl)
            {
            }
            column(EstimateCaption; EstimateCaptionLbl)
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(Job_No_Caption; Job_No_CaptionLbl)
            {
            }
            column(Job_No_; "No.")
            {
            }
            dataitem("Job Planning Line"; "Job Planning Line")
            {
                DataItemLink = "Job No." = FIELD("No.");
                DataItemTableView = SORTING("Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Cost Category", Type, "No.", "Variant Code") ORDER(Ascending);

                trigger OnAfterGetRecord();
                begin
                    if "NS_Cost Category" = '' then
                        "NS_Cost Category" := 'ZZZZZ';
                    JobAnalysisBuffer.RESET;
                    JobAnalysisBuffer.SETCURRENTKEY("NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                                    NS_Category, NS_Type, "NS_No.", "NS_Variant Code", NS_Adjustment);
                    JobAnalysisBuffer.SETRANGE("NS_Job No.", "Job No.");
                    JobAnalysisBuffer.SETRANGE("NS_Entry Type", JobAnalysisBuffer."NS_Entry Type"::Cost);
                    JobAnalysisBuffer.SETRANGE(NS_Category, "NS_Cost Category");
                    if not JobAnalysisBuffer.FINDFIRST then begin
                        JobAnalysisBuffer.INIT;
                        JobAnalysisBuffer."NS_Job No." := "Job No.";
                        JobAnalysisBuffer."NS_Entry Type" := JobAnalysisBuffer."NS_Entry Type"::Cost;
                        JobAnalysisBuffer.NS_Category := "NS_Cost Category";
                        JobAnalysisBuffer."NS_Budgeted Cost" := "Total Cost";
                        JobAnalysisBuffer."NS_Operation Code" := "Variant Code";
                        JobAnalysisBuffer.INSERT;
                    end else begin
                        JobAnalysisBuffer."NS_Budgeted Cost" := JobAnalysisBuffer."NS_Budgeted Cost" + "Total Cost";
                        JobAnalysisBuffer.MODIFY;
                    end;
                end;

                trigger OnPreDataItem();
                begin
                    if (Job."NS_Sub-Level to Job No." > '') and "ShowSub-Levels" then
                        CurrReport.SKIP;

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
                DataItemLink = "Job No." = FIELD("No.");
                DataItemTableView = SORTING("Job No.", "Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Job Cost Category", "NS_Job Revenue Category", Type, "No.", "Resource Group No.", "Posting Date") ORDER(Ascending);

                trigger OnAfterGetRecord();
                var
                    NextLineNo: Integer;
                begin
                    if "NS_Job Cost Category" = '' then
                        "NS_Job Cost Category" := 'ZZZZZ';

                    JobAnalysisBuffer.RESET;
                    JobAnalysisBuffer.SETCURRENTKEY("NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                                    NS_Category, NS_Type, "NS_No.", "NS_Variant Code", NS_Adjustment);
                    JobAnalysisBuffer.SETRANGE("NS_Job No.", "Job No.");
                    JobAnalysisBuffer.SETRANGE("NS_Entry Type", JobAnalysisBuffer."NS_Entry Type"::Cost);
                    JobAnalysisBuffer.SETRANGE(NS_Category, "NS_Job Cost Category");
                    if not JobAnalysisBuffer.FINDFIRST then begin
                        JobAnalysisBuffer.INIT;
                        JobAnalysisBuffer."NS_Job No." := "Job No.";
                        JobAnalysisBuffer."NS_Entry Type" := JobAnalysisBuffer."NS_Entry Type"::Cost;
                        JobAnalysisBuffer.NS_Category := "NS_Job Cost Category";
                        JobAnalysisBuffer."NS_Actual Cost" := "Total Cost";
                        JobAnalysisBuffer."NS_Operation Code" := "Variant Code";
                        JobAnalysisBuffer.INSERT;
                    end else begin
                        JobAnalysisBuffer."NS_Actual Cost" := JobAnalysisBuffer."NS_Actual Cost" + "Total Cost";
                        JobAnalysisBuffer.MODIFY;
                    end;
                end;

                trigger OnPreDataItem();
                begin
                    if (Job."NS_Sub-Level to Job No." > '') and "ShowSub-Levels" then
                        CurrReport.SKIP;

                    SETRANGE("Entry Type", "Entry Type"::Usage);
                    SETFILTER("NS_Activity Code", Job.GETFILTER("NS_Activity Filter"));
                    SETFILTER("NS_Process Code", Job.GETFILTER("NS_Process Filter"));
                    SETFILTER("NS_Operation Code", Job.GETFILTER("NS_Operation Filter"));
                    SETFILTER(Type, Job.GETFILTER("NS_Type Filter"));
                    SETFILTER("Posting Date", Job.GETFILTER("NS_Date Filter"));
                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(Job_FIELDNAME__Starting_Date____________FORMAT_Job__Starting_Date__; Job.FIELDNAME("Starting Date") + ': ' + FORMAT(Job."Starting Date"))
                {
                }
                column(Job_FIELDNAME__Ending_Date____________FORMAT_Job__Ending_Date__; Job.FIELDNAME("Ending Date") + ': ' + FORMAT(Job."Ending Date"))
                {
                }
                column(Job_Description; Job.Description)
                {
                }
                column(Job__No__; Job."No.")
                {
                }
                column(Job__Budgeted_Price__LCY__; Job."NS_Budgeted Price (LCY)")
                {
                }
                column(Job__Description_2_; Job."Description 2")
                {
                }
                column(TotaltoPrintCatCost; TotaltoPrintCatCost)
                {
                }
                column(TotaltoPrintBudgetCatCost; TotaltoPrintBudgetCatCost)
                {
                }
                column(CategorytoPrint; CategorytoPrint)
                {
                }
                column(CategoryDescription; CategoryDescription)
                {
                }
                column(TotaltoPrintCommittedCatCost; TotaltoPrintCommittedCatCost)
                {
                }
                column(TotaltoPrintBudgetCatCost___TotaltoPrintCatCost; TotaltoPrintBudgetCatCost - TotaltoPrintCatCost)
                {
                }
                column(TotaltoPrintCommittedCatCost___TotaltoPrintCatCost; TotaltoPrintCommittedCatCost - TotaltoPrintCatCost)
                {
                }
                column(Job_Total_; 'Job Total')
                {
                }
                column(TotaltoPrintBudgetCatCost_Control39; TotaltoPrintBudgetCatCost)
                {
                }
                column(TotaltoPrintCommittedCatCost_Control40; TotaltoPrintCommittedCatCost)
                {
                }
                column(TotaltoPrintCatCost_Control41; TotaltoPrintCatCost)
                {
                }
                column(TotaltoPrintBudgetCatCost___TotaltoPrintCatCost_Control42; TotaltoPrintBudgetCatCost - TotaltoPrintCatCost)
                {
                }
                column(TotaltoPrintCommittedCatCost___TotaltoPrintCatCost_Control43; TotaltoPrintCommittedCatCost - TotaltoPrintCatCost)
                {
                }
                column(TotaltoPrintCatPrice; TotaltoPrintCatPrice)
                {
                }
                column(TotaltoPrintCatPrice___TotaltoPrintCatCost; TotaltoPrintCatPrice - TotaltoPrintCatCost)
                {
                }
                column(Job__Budgeted_Price__LCY__Caption; Job__Budgeted_Price__LCY__CaptionLbl)
                {
                }
                column(Integer_Number; Number)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    if JobAnalysisBuffer.NS_Category <> OldCategory then begin
                        CLEAR(TotaltoPrintBudgetCatCost);
                        CLEAR(TotaltoPrintCatCost);
                        JobAnalysisBuffer2.RESET;
                        JobAnalysisBuffer2.SETRANGE("NS_Job No.", JobAnalysisBuffer."NS_Job No.");
                        JobAnalysisBuffer2.SETRANGE("NS_Entry Type", JobAnalysisBuffer."NS_Entry Type"::Cost);
                        JobAnalysisBuffer2.SETRANGE(NS_Category, JobAnalysisBuffer.NS_Category);
                        JobAnalysisBuffer2.SETFILTER("NS_Date Filter", Job.GETFILTER("NS_Date Filter"));
                        if JobAnalysisBuffer2.FINDSET then
                            repeat
                                TotaltoPrintBudgetCatCost := TotaltoPrintBudgetCatCost + JobAnalysisBuffer2."NS_Budgeted Cost";
                                TotaltoPrintCatCost := TotaltoPrintCatCost + JobAnalysisBuffer2."NS_Actual Cost";
                            until JobAnalysisBuffer2.NEXT = 0;
                        if "IncludeSub-Levels" and not "ShowSub-Levels" then begin
                            SubJobs.RESET;
                            SubJobs.SETRANGE("NS_Sub-Level to Job No.", JobAnalysisBuffer."NS_Job No.");
                            if SubJobs.FINDSET then
                                repeat
                                    SubJobPlanningLine.RESET;
                                    SubJobPlanningLine.SETCURRENTKEY("Job No.", "NS_Subcontract No.", "NS_Entry Type",
                                                                     "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                                                     "NS_Cost Category", Type, "No.", "Planning Date", NS_Adjustment);
                                    SubJobPlanningLine.SETRANGE("Job No.", SubJobs."No.");
                                    SubJobPlanningLine.SETFILTER("NS_Entry Type", '%1|%2',
                                                                              SubJobPlanningLine."NS_Entry Type"::Cost,
                                                                              SubJobPlanningLine."NS_Entry Type"::Both);
                                    SubJobPlanningLine.SETRANGE("NS_Cost Category", JobAnalysisBuffer.NS_Category);
                                    SubJobPlanningLine.SETFILTER("Planning Date", Job.GETFILTER("NS_Date Filter"));
                                    if SubJobPlanningLine.FINDSET then
                                        repeat
                                            TotaltoPrintBudgetCatCost := TotaltoPrintBudgetCatCost + SubJobPlanningLine."Total Cost";
                                        until SubJobPlanningLine.NEXT = 0;
                                until SubJobs.NEXT = 0;
                        end;

                        CLEAR(TotaltoPrintCommittedCatCost);

                        PurchaseLine.RESET;
                        PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Order);
                        PurchaseLine.SETRANGE("Job No.", JobAnalysisBuffer."NS_Job No.");
                        PurchaseLine.SETRANGE("NS_Job Cost Category", JobAnalysisBuffer.NS_Category);
                        if PurchaseLine.FINDSET then
                            repeat
                                TotaltoPrintCommittedCatCost := TotaltoPrintCommittedCatCost + PurchaseLine."Outstanding Amount";
                            until PurchaseLine.NEXT = 0;
                        if "IncludeSub-Levels" and not "ShowSub-Levels" then begin
                            SubJobs.RESET;
                            SubJobs.SETCURRENTKEY("NS_Sub-Level to Job No.", "NS_Contract Date");
                            SubJobs.SETRANGE("NS_Sub-Level to Job No.", JobAnalysisBuffer."NS_Job No.");
                            if SubJobs.FINDSET then
                                repeat
                                    PurchaseLine.RESET;
                                    PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Order);
                                    PurchaseLine.SETRANGE("Job No.", SubJobs."No.");
                                    PurchaseLine.SETRANGE("NS_Job Cost Category", JobAnalysisBuffer.NS_Category);
                                    if PurchaseLine.FINDSET then
                                        repeat
                                            TotaltoPrintCommittedCatCost := TotaltoPrintCommittedCatCost + PurchaseLine."Outstanding Amount";
                                        until PurchaseLine.NEXT = 0;
                                until SubJobs.NEXT = 0;
                        end;
                        CategorytoPrint := JobAnalysisBuffer.NS_Category;
                        OldCategory := JobAnalysisBuffer.NS_Category;
                        PrintDetailLine := true;
                    end;

                    JobAnalysisBuffer.NEXT;
                end;

                trigger OnPreDataItem();
                begin
                    //Duplicate JobAnalysisBuffer to JobAnalysisBuffer2
                    with JobAnalysisBuffer do begin
                        RESET;
                        if FINDSET then
                            repeat
                                JobAnalysisBuffer2.COPY(JobAnalysisBuffer);
                                JobAnalysisBuffer2.INSERT;
                            until NEXT = 0;
                    end;

                    JobAnalysisBuffer.RESET;
                    NumBudgetLines := JobAnalysisBuffer.COUNT;
                    if NumBudgetLines = 0 then
                        CurrReport.BREAK;
                    SETRANGE(Number, 1, NumBudgetLines);
                    Job.COPYFILTER("NS_Date Filter", JobAnalysisBuffer."NS_Date Filter");
                    CurrReport.CREATETOTALS(TotaltoPrintCatCost, TotaltoPrintCommittedCatCost, TotaltoPrintBudgetCatCost);
                    JobAnalysisBuffer.RESET;
                    JobAnalysisBuffer.FINDSET;
                    CLEAR(OldCategory);
                end;
            }

            trigger OnAfterGetRecord();
            begin
                JobAnalysisBuffer.DELETEALL;
                JobAnalysisBuffer2.DELETEALL;
                if ("NS_Sub-Level to Job No." > '') and not "ShowSub-Levels" then
                    CurrReport.SKIP;
            end;

            trigger OnPreDataItem();
            begin
                JobHold := Job;
                JobHold.COPYFILTERS(Job);
                "MarkSub-Levels"(Job, "IncludeSub-Levels");
                FILTERGROUP(10);
                COPYFILTERS(JobHold);
                SETRANGE("No.");
                FILTERGROUP(0);
                COPYFILTERS(JobHold);
                CurrReport.CREATETOTALS(TotaltoPrintCatCost, TotaltoPrintCommittedCatCost, TotaltoPrintBudgetCatCost, TotaltoPrintCatPrice);
            end;
        }
        dataitem(FinalTotal; "Integer")
        {
            DataItemTableView = SORTING(Number);
            column(TotaltoPrintCommittedCatCost___TotaltoPrintCatCost_Control46; TotaltoPrintCommittedCatCost - TotaltoPrintCatCost)
            {
            }
            column(TotaltoPrintBudgetCatCost___TotaltoPrintCatCost_Control47; TotaltoPrintBudgetCatCost - TotaltoPrintCatCost)
            {
            }
            column(TotaltoPrintCatCost_Control48; TotaltoPrintCatCost)
            {
            }
            column(TotaltoPrintCommittedCatCost_Control49; TotaltoPrintCommittedCatCost)
            {
            }
            column(TotaltoPrintBudgetCatCost_Control50; TotaltoPrintBudgetCatCost)
            {
            }
            column(CategoryDescription_Control51; CategoryDescription)
            {
            }
            column(CategorytoPrint_Control52; CategorytoPrint)
            {
            }
            column(TotaltoPrintBudgetCatCost_Control30; TotaltoPrintBudgetCatCost)
            {
            }
            column(TotaltoPrintCommittedCatCost_Control27; TotaltoPrintCommittedCatCost)
            {
            }
            column(TotaltoPrintCatCost_Control26; TotaltoPrintCatCost)
            {
            }
            column(TotaltoPrintBudgetCatCost___TotaltoPrintCatCost_Control32; TotaltoPrintBudgetCatCost - TotaltoPrintCatCost)
            {
            }
            column(TotaltoPrintCommittedCatCost___TotaltoPrintCatCost_Control31; TotaltoPrintCommittedCatCost - TotaltoPrintCatCost)
            {
            }
            column(FinalTotalCatPrice; FinalTotalCatPrice)
            {
            }
            column(FinalTotalCatPrice___TotaltoPrintCatCost; FinalTotalCatPrice - TotaltoPrintCatCost)
            {
            }
            column(Final_TotalCaption; Final_TotalCaptionLbl)
            {
            }
            column(Inv_ActCaption_Control1000000002; Inv_ActCaption_Control1000000002Lbl)
            {
            }
            column(Amt_InvoicedCaption_Control1000000003; Amt_InvoicedCaption_Control1000000003Lbl)
            {
            }
            column(Com_ActCaption_Control1000000004; Com_ActCaption_Control1000000004Lbl)
            {
            }
            column(Est_ActCaption_Control1000000005; Est_ActCaption_Control1000000005Lbl)
            {
            }
            column(ActualCaption_Control1000000006; ActualCaption_Control1000000006Lbl)
            {
            }
            column(CommittedCaption_Control1000000007; CommittedCaption_Control1000000007Lbl)
            {
            }
            column(EstimateCaption_Control1000000008; EstimateCaption_Control1000000008Lbl)
            {
            }
            column(DescriptionCaption_Control1000000009; DescriptionCaption_Control1000000009Lbl)
            {
            }
            column(Job_No_Caption_Control1000000010; Job_No_Caption_Control1000000010Lbl)
            {
            }
            column(FinalTotal_Number; Number)
            {
            }

            trigger OnAfterGetRecord();
            begin
                if JobAnalysisBufferFT.NS_Category <> OldCategory then
                    CategorytoPrint := JobAnalysisBufferFT.NS_Category;
                TotaltoPrintBudgetCatCost := JobAnalysisBufferFT."NS_Budgeted Cost";
                TotaltoPrintCommittedCatCost := JobAnalysisBufferFT."NS_Total Price";
                TotaltoPrintCatCost := JobAnalysisBufferFT."NS_Actual Cost";
                PrintDetailLine := true;
                JobAnalysisBufferFT.NEXT;
            end;

            trigger OnPreDataItem();
            begin
                JobAnalysisBufferFT.RESET;
                NumBudgetLines := JobAnalysisBufferFT.COUNT;
                if NumBudgetLines = 0 then
                    CurrReport.BREAK;
                SETRANGE(Number, 1, NumBudgetLines);
                CurrReport.CREATETOTALS(TotaltoPrintCatCost, TotaltoPrintCommittedCatCost, TotaltoPrintBudgetCatCost);
                JobAnalysisBufferFT.RESET;
                JobAnalysisBufferFT.FINDSET;
                CLEAR(OldCategory);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                //SMPL - Caption = 'RequestPage';
                group(Options)
                {
                    field("Include Sub-Levels"; "IncludeSub-Levels")
                    {
                        ApplicationArea = All;
                    }
                    field("Show Sub-Levels"; "ShowSub-Levels")
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

        if not "ShowSub-Levels" then
            if "IncludeSub-Levels" then
                "Sub-LevelsText" := Text001
            else
                "Sub-LevelsText" := Text002
        else
            "Sub-LevelsText" := Text002
    end;

    var
        CompanyInformation: Record "Company Information";
        JobList: Record Job;
        JobSearch: Record Job;
        JobCostCategory: Record "NS_Job Cost Category";
        JobAnalysisBuffer: Record "NS_Job Analysis Buffer" temporary;
        JobAnalysisBuffer2: Record "NS_Job Analysis Buffer" temporary;
        SubJobPlanningLine: Record "Job Planning Line";
        JobAnalysisBufferFT: Record "NS_Job Analysis Buffer" temporary;
        PurchaseLine: Record "Purchase Line";
        JobLedgerEntry: Record "Job Ledger Entry";
        JobLedgerEntry2: Record "Job Ledger Entry";
        SubJobs: Record Job;
        JobHold: Record Job;
        NumBudgetLines: Integer;
        JobFilter: Text[250];
        "Sub-LevelsText": Text[50];
        OldCategory: Code[10];
        TotaltoPrintCatCost: Decimal;
        TotaltoPrintCatPrice: Decimal;
        TotaltoPrintBudgetCatCost: Decimal;
        TotaltoPrintCommittedCatCost: Decimal;
        FinalTotalCatCost: Decimal;
        FinalTotalCatPrice: Decimal;
        CategorytoPrint: Code[10];
        PrintDetailLine: Boolean;
        CategoryDescription: Text[30];
        "IncludeSub-Levels": Boolean;
        "ShowSub-Levels": Boolean;
        Uncategorized: Boolean;
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Job_Cost_Category_SummaryCaptionLbl: Label 'Job Cost Category Summary';
        Inv_ActCaptionLbl: Label 'Inv-Act';
        Amt_InvoicedCaptionLbl: Label 'Amt Invoiced';
        Com_ActCaptionLbl: Label 'Com-Act';
        Est_ActCaptionLbl: Label 'Est-Act';
        ActualCaptionLbl: Label 'Actual';
        CommittedCaptionLbl: Label 'Committed';
        EstimateCaptionLbl: Label 'Estimate';
        DescriptionCaptionLbl: Label 'Description';
        Job_No_CaptionLbl: Label 'Job No.';
        Job__Budgeted_Price__LCY__CaptionLbl: Label 'Contract Amount:';
        Final_TotalCaptionLbl: Label 'Final Total';
        Inv_ActCaption_Control1000000002Lbl: Label 'Inv-Act';
        Amt_InvoicedCaption_Control1000000003Lbl: Label 'Amt Invoiced';
        Com_ActCaption_Control1000000004Lbl: Label 'Com-Act';
        Est_ActCaption_Control1000000005Lbl: Label 'Est-Act';
        ActualCaption_Control1000000006Lbl: Label 'Actual';
        CommittedCaption_Control1000000007Lbl: Label 'Committed';
        EstimateCaption_Control1000000008Lbl: Label 'Estimate';
        DescriptionCaption_Control1000000009Lbl: Label 'Description';
        Job_No_Caption_Control1000000010Lbl: Label 'Job No.';
        Text001: Label 'Sub-Levels are included in jobs';
        Text002: Label 'Sub-Levels are not included in jobs';
}

