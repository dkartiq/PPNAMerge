report 14021174 "NS_Job Detail By Gross Margin"
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
    Caption = 'Job Detail By Gross Margin';
    RDLCLayout = './Layouts/NSJob Detail By Gross Margin.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;


    dataset
    {
        dataitem(Job; Job)
        {
            RequestFilterFields = "No.";
            dataitem(JLEReportBufferBuild; "Integer")
            {
                DataItemTableView = SORTING(Number) ORDER(Ascending);
                MaxIteration = 1;

                trigger OnAfterGetRecord();
                begin
                    with JobLedgEntry do begin
                        RESET;
                        SETCURRENTKEY("Job No.");
                        SETRANGE("Job No.", Job."No.");

                        if FINDSET then
                            repeat
                                CLEAR(JobLedgerEntryReportBuffer);
                                JobLedgerEntryReportBuffer.INIT;
                                JLERTEntryNo := JLERTEntryNo + 100;
                                JobLedgerEntryReportBuffer."NS_Entry No." := JLERTEntryNo;
                                JobLedgerEntryReportBuffer."NS_Job No." := "Job No.";
                                JobLedgerEntryReportBuffer.NS_Type := Type;
                                JobLedgerEntryReportBuffer."NS_No." := "No.";
                                JobLedgerEntryReportBuffer."NS_Document No." := "Document No.";
                                JobLedgerEntryReportBuffer."NS_Document Date" := "Document Date";
                                JobLedgerEntryReportBuffer."NS_Source Code" := "Source Code";
                                JobLedgerEntryReportBuffer."NS_Entry Type" := "Entry Type";
                                JobLedgerEntryReportBuffer.NS_Description := Description;
                                JobLedgerEntryReportBuffer.NS_Quantity := Quantity;
                                JobLedgerEntryReportBuffer."NS_Unit of Measure Code" := "Unit of Measure Code";
                                JobLedgerEntryReportBuffer."NS_External Document No." := "External Document No.";
                                JobLedgerEntryReportBuffer."NS_Unit Cost" := "Unit Cost";
                                JobLedgerEntryReportBuffer."NS_Total Cost" := "Total Cost";
                                JobLedgerEntryReportBuffer."NS_Total Price" := "Total Price";
                                JobLedgerEntryReportBuffer."NS_Job Cost Category" := "NS_Job Cost Category";
                                JobLedgerEntryReportBuffer."NS_Job Revenue Category" := "NS_Job Revenue Category";
                                JobLedgerEntryReportBuffer."NS_Activity Code" := "NS_Activity Code";
                                JobLedgerEntryReportBuffer."NS_External Relationship Type" := "NS_External Relationship Type";
                                JobLedgerEntryReportBuffer."NS_External Relationship Name" := "NS_External Relationship Name";

                                if "Entry Type" = "Entry Type"::Sale then
                                    JobLedgerEntryReportBuffer."NS_Sale Or Usage Flag" := 1
                                else
                                    if "Entry Type" = "Entry Type"::Usage then
                                        JobLedgerEntryReportBuffer."NS_Sale Or Usage Flag" := 2;

                                case true of
                                    ("NS_Job Revenue Category" > '') and ("NS_Job Cost Category" > ''):
                                        JobLedgerEntryReportBuffer."NS_Sale Or Cost Flag" :=
                                          JobLedgerEntryReportBuffer."NS_Sale Or Usage Flag";
                                    "NS_Job Revenue Category" > '':
                                        JobLedgerEntryReportBuffer."NS_Sale Or Cost Flag" := 1;
                                    "NS_Job Cost Category" > '':
                                        JobLedgerEntryReportBuffer."NS_Sale Or Cost Flag" := 2;
                                end;

                                JobLedgerEntryReportBuffer.INSERT;
                            until NEXT = 0;

                    end;
                end;

                trigger OnPreDataItem();
                begin
                    JLERTEntryNo := 0;
                    JobLedgerEntryReportBuffer.RESET;
                    JobLedgerEntryReportBuffer.DELETEALL;
                end;
            }
            dataitem(JLEReportBufferBuildSJs; "Integer")
            {
                DataItemTableView = SORTING(Number) ORDER(Ascending);
                MaxIteration = 1;
                dataitem(JLEReportBufferReportHeader; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    MaxIteration = 1;
                    PrintOnlyIfDetail = true;
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
                    column(ReportTitle; ReportTitle)
                    {
                    }
                    column(Job_No_; Job."No.")
                    {
                    }
                    column(PageCaption; PageCaptionLbl)
                    {
                    }
                    column(Sub_LevelsCaption; "Sub-LevelsText")
                    {
                    }
                    column(JobFiltersCaption; JobFiltersLbl)
                    {
                    }
                    column(JobFilters; JobFilters)
                    {
                    }
                    column(Job__No__; STRSUBSTNO(Text14021100, Job."No."))
                    {
                    }
                    column(Job_Description; Job.Description)
                    {
                    }
                    column(Job_SubcontractorCaption; SubcontractorLbl)
                    {
                    }
                    column(Job_ManagerCaption; JobManagerLbl)
                    {
                    }
                    column(Job_Manager; Job.NS_Manager)
                    {
                    }
                    column(PeriodCaption; PeriodLbl)
                    {
                    }
                    column(Period_Date_Range; Job.GETFILTER("NS_Date Filter"))
                    {
                    }
                    column(ActivityProcessOperationCaption; ActivityProcessOperationLbl)
                    {
                    }
                    column(EntryTypeCaption; EntryTypeLbl)
                    {
                    }
                    column(CodeCaption; CodeLbl)
                    {
                    }
                    column(EmployeeVendorNameCaption; EmployeeVendorNameLbl)
                    {
                    }
                    column(DocumentCaption; DocumentLbl)
                    {
                    }
                    column(PurchaseOrderNoCaption; PurchaseOrderNoLbl)
                    {
                    }
                    column(DateCaption; DateLbl)
                    {
                    }
                    column(EntrySourceCaption; EntrySourceHeadingLbl)
                    {
                    }
                    column(EntryDescriptionCaption; EntryDescriptionLbl)
                    {
                    }
                    column(QtyCaption; QtyLbl)
                    {
                    }
                    column(UOMCaption; UOMLbl)
                    {
                    }
                    column(UnitCostCaption; UnitCostLbl)
                    {
                    }
                    column(AmountCaption; AmountLbl)
                    {
                    }
                    column(DifferenceCaption; DifferenceLbl)
                    {
                    }
                    column(TotalJobLbl; STRSUBSTNO(Text14021104, Job."No.", Job.Description))
                    {
                    }
                    column(TotalCaption; TotalLbl)
                    {
                    }
                    column(TotalJobCategoryCaption; TotalJobCategoryLbl)
                    {
                    }
                    column(TotalActivityCaption; TotalActivityLbl)
                    {
                    }
                    column(TotalRevenueCaption; TotalRevenueLbl)
                    {
                    }
                    column(TotalExpenseCaption; TotalExpenseLbl)
                    {
                    }
                    column(TotalNetDifferenceCaption; TotalNetDifferenceLbl)
                    {
                    }
                    dataitem(JLEReportBufferReportData; "Integer")
                    {
                        DataItemTableView = SORTING(Number) ORDER(Ascending);
                        column(Activity_Code; ActivityCode)
                        {
                        }
                        column(Activity_Description; ActivityDescription)
                        {
                        }
                        column(Activity_Caption_and_Code; STRSUBSTNO(Text14021101, ActivityCode))
                        {
                        }
                        column(Sale_Or_Usage_Flag; SaleOrUsageFlag)
                        {
                        }
                        column(Sale_Or_Cost_Flag; SaleOrCostFlag)
                        {
                        }
                        column(Category_Code; CategoryCodeValue)
                        {
                        }
                        column(Category_Name; CategoryNameValue)
                        {
                        }
                        column(Type; TypeValue)
                        {
                        }
                        column("Code"; CodeValue)
                        {
                        }
                        column(Employee_Or_Vendor_Name; EmployeeOrVendorNameValue)
                        {
                        }
                        column(Document_No; DocumentNoValue)
                        {
                        }
                        column(PO_No; PurchaseOrderNoValue)
                        {
                        }
                        column(Date; DateValue)
                        {
                        }
                        column(Entry_Source; EntrySourceValue)
                        {
                        }
                        column(Entry_Description; EntryDescriptionValue)
                        {
                        }
                        column(Qty; QtyValue)
                        {
                        }
                        column(UOM; UOMValue)
                        {
                        }
                        column(Unit_Cost; UnitCostValue)
                        {
                        }
                        column(Amount; AmountValue)
                        {
                        }
                        column(Total_Revenue; TotalRevenueValue)
                        {
                        }
                        column(Total_Expense; TotalExpenseValue)
                        {
                        }

                        trigger OnAfterGetRecord();
                        begin
                            with JobLedgerEntryReportBuffer do begin
                                ActivityCode := '';
                                ActivityDescription := '';
                                if "NS_Activity Code" > '' then begin
                                    if not JobActivity.GET(JobActivity.NS_Type::Cost, "NS_Activity Code") then
                                        JobActivity.GET(JobActivity.NS_Type::Revenue, "NS_Activity Code");
                                    ActivityCode := "NS_Activity Code";
                                    ActivityDescription := JobActivity.NS_Description;
                                end;
                                SaleOrUsageFlag := "NS_Sale Or Usage Flag";
                                SaleOrCostFlag := "NS_Sale Or Cost Flag";
                                if "NS_Sale Or Usage Flag" = 1 then begin
                                    CategoryCodeValue := "NS_Job Revenue Category";
                                    if JobRevenueCategory.GET("NS_Job Revenue Category") then
                                        CategoryNameValue := JobRevenueCategory.NS_Description;
                                end else begin
                                    CategoryCodeValue := "NS_Job Cost Category";
                                    if JobCostCategory.GET("NS_Job Cost Category") then
                                        CategoryNameValue := JobCostCategory.NS_Description;
                                end;

                                //Setup the print line
                                TypeValue := NS_Type;
                                CodeValue := "NS_No.";
                                EmployeeOrVendorNameValue := '';
                                case true of
                                    NS_Type = NS_Type::Resource:
                                        EmployeeOrVendorNameValue := NS_Description;
                                    "NS_External Relationship Type" = "NS_External Relationship Type"::Vendor:
                                        EmployeeOrVendorNameValue := "NS_External Relationship Name";
                                end;
                                DocumentNoValue := "NS_Document No.";
                                PurchaseOrderNoValue := "NS_External Document No.";
                                DateValue := "NS_Document Date";
                                EntrySourceValue := "NS_Source Code";
                                EntryDescriptionValue := NS_Description;
                                QtyValue := NS_Quantity;
                                UOMValue := "NS_Unit of Measure Code";
                                UnitCostValue := "NS_Unit Cost";

                                if "NS_Sale Or Usage Flag" = 1 then
                                    AmountValue := -"NS_Total Price"
                                else
                                    AmountValue := "NS_Total Cost";

                                TotalExpenseValue := 0;
                                TotalRevenueValue := 0;
                                if "NS_Sale Or Usage Flag" = 1 then
                                    TotalRevenueValue := -"NS_Total Price"
                                else
                                    if "NS_Sale Or Cost Flag" = 1 then
                                        TotalRevenueValue := "NS_Total Cost"
                                    else
                                        TotalExpenseValue := "NS_Total Cost";

                                NEXT;
                            end;
                        end;

                        trigger OnPreDataItem();
                        begin
                            JobLedgerEntryReportBuffer.RESET;

                            RESET;
                            SETRANGE(Number, 1, JobLedgerEntryReportBuffer.COUNT);

                            JobLedgerEntryReportBuffer.RESET;
                            JobLedgerEntryReportBuffer.SETCURRENTKEY("NS_Job No.", "NS_Activity Code", "NS_Sale Or Usage Flag", "NS_Job Revenue Category", "NS_Job Cost Category", NS_Type, "NS_Posting Date");
                            if JobLedgerEntryReportBuffer.COUNT = 0 then
                                ERROR(Text14021108, Job."No.")
                            else
                                JobLedgerEntryReportBuffer.FINDSET;

                            TotalExpenseValue := 0;
                            TotalRevenueValue := 0;
                        end;
                    }
                }

                trigger OnAfterGetRecord();
                begin
                    if SubJobRecNo > 0 then
                        SubJob.NEXT;
                    SubJobRecNo := SubJobRecNo + 1;

                    with JobLedgEntry do begin
                        RESET;
                        SETCURRENTKEY("Job No.");
                        SETRANGE("Job No.", SubJob."No.");

                        if FINDSET then
                            repeat
                                CLEAR(JobLedgerEntryReportBuffer);
                                JobLedgerEntryReportBuffer.INIT;
                                JLERTEntryNo := JLERTEntryNo + 100;
                                JobLedgerEntryReportBuffer."NS_Entry No." := JLERTEntryNo;
                                JobLedgerEntryReportBuffer."NS_Job No." := "Job No.";
                                JobLedgerEntryReportBuffer.NS_Type := Type;
                                JobLedgerEntryReportBuffer."NS_No." := "No.";
                                JobLedgerEntryReportBuffer."NS_Document No." := "Document No.";
                                JobLedgerEntryReportBuffer."NS_Document Date" := "Document Date";
                                JobLedgerEntryReportBuffer."NS_Source Code" := "Source Code";
                                JobLedgerEntryReportBuffer."NS_Entry Type" := "Entry Type";
                                JobLedgerEntryReportBuffer.NS_Description := Description;
                                JobLedgerEntryReportBuffer.NS_Quantity := Quantity;
                                JobLedgerEntryReportBuffer."NS_Unit of Measure Code" := "Unit of Measure Code";
                                JobLedgerEntryReportBuffer."NS_External Document No." := "External Document No.";
                                JobLedgerEntryReportBuffer."NS_Unit Cost" := "Unit Cost";
                                JobLedgerEntryReportBuffer."NS_Total Cost" := "Total Cost";
                                JobLedgerEntryReportBuffer."NS_Total Price" := "Total Price";
                                JobLedgerEntryReportBuffer."NS_Job Cost Category" := "NS_Job Cost Category";
                                JobLedgerEntryReportBuffer."NS_Job Revenue Category" := "NS_Job Revenue Category";
                                JobLedgerEntryReportBuffer."NS_Activity Code" := "NS_Activity Code";
                                JobLedgerEntryReportBuffer."NS_External Relationship Type" := "NS_External Relationship Type";
                                JobLedgerEntryReportBuffer."NS_External Relationship Name" := "NS_External Relationship Name";

                                if "Entry Type" = "Entry Type"::Sale then
                                    JobLedgerEntryReportBuffer."NS_Sale Or Usage Flag" := 1
                                else
                                    if "Entry Type" = "Entry Type"::Usage then
                                        JobLedgerEntryReportBuffer."NS_Sale Or Usage Flag" := 2;

                                case true of
                                    ("NS_Job Revenue Category" > '') and ("NS_Job Cost Category" > ''):
                                        JobLedgerEntryReportBuffer."NS_Sale Or Cost Flag" :=
                                          JobLedgerEntryReportBuffer."NS_Sale Or Usage Flag";
                                    "NS_Job Revenue Category" > '':
                                        JobLedgerEntryReportBuffer."NS_Sale Or Cost Flag" := 1;
                                    "NS_Job Cost Category" > '':
                                        JobLedgerEntryReportBuffer."NS_Sale Or Cost Flag" := 2;
                                end;

                                JobLedgerEntryReportBuffer.INSERT;
                            until NEXT = 0;

                    end;
                end;

                trigger OnPreDataItem();
                begin
                    with SubJob do begin
                        RESET;
                        SETCURRENTKEY("NS_Sub-Level to Job No.", "NS_Contract Date");
                        SETRANGE("NS_Sub-Level to Job No.", Job."No.");
                        if FINDSET then
                            JLEReportBufferBuildSJs.SETRANGE(Number, 1, COUNT)
                        else
                            CurrReport.SKIP;
                    end;

                    SubJobRecNo := 0;
                end;
            }
        }
    }
    requestpage
    {
        SaveValues = true;

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

    trigger OnInitReport();
    begin
        CompanyInformation.GET;
    end;

    trigger OnPreReport();
    begin
        JobFilters := Job.GETFILTERS;
        "Sub-LevelsText" := STRSUBSTNO(Text14021105, ' ' + notLbl + ' ');
        ;
    end;

    var
        JobActivity: Record "NS_Job Activity";
        JobRevenueCategory: Record "NS_Job Revenue Category";
        JobCostCategory: Record "NS_Job Cost Category";
        CompanyInformation: Record "Company Information";
        JobLedgerEntryReportBuffer: Record "NS_Job LedgerEntryReportBuffer" temporary;
        JobLedgEntry: Record "Job Ledger Entry";
        SubJob: Record Job;
        "Sub-LevelsText": Text[50];
        JobFilters: Text[250];
        Text14021100: Label 'Job: %1';
        Text14021101: Label 'Activity  %1';
        Text14021104: Label 'Totals for Job %1 - %2';
        Text14021105: Label 'Sub-Levels are%1 included in jobs';
        Text14021107: Label '%1 - %2';
        Text14021108: Label 'There are no Job Ledger Entries for Job %1';
        ReportTitle: Label 'Job Detail by Gross Margin';
        PageCaptionLbl: Label 'Page';
        JobFiltersLbl: Label 'Job Filters:';
        SubcontractorLbl: Label 'Subcontractor';
        JobManagerLbl: Label 'Job Manager';
        PeriodLbl: Label 'Period';
        ActivityProcessOperationLbl: Label 'APO Code';
        EntryTypeLbl: Label 'Entry Type';
        CodeLbl: Label 'Code';
        EmployeeVendorNameLbl: Label 'Employee/Vendor Name';
        DocumentLbl: Label 'Document #';
        PurchaseOrderNoLbl: Label 'PO#';
        DateLbl: Label 'Date';
        EntrySourceHeadingLbl: Label 'Entry Source';
        EntryDescriptionLbl: Label 'Entry Description';
        QtyLbl: Label 'Qty';
        UOMLbl: Label 'UOM';
        UnitCostLbl: Label 'Unit Cost';
        AmountLbl: Label 'Amount';
        TotalLbl: Label 'Total';
        DifferenceLbl: Label 'Net Diff';
        TotalJobCategoryLbl: Label 'Total Job Category';
        RevenueLbl: Label 'Revenue';
        CostLbl: Label 'Cost';
        TotalActivityLbl: Label 'Total Activity';
        TotalRevenueLbl: Label 'Total Revenue';
        TotalExpenseLbl: Label 'Total Expense';
        TotalNetDifferenceLbl: Label 'Total Net Difference';
        notLbl: Label 'not';
        ActivityCode: Code[10];
        ActivityDescription: Text[30];
        SaleOrUsageFlag: Integer;
        SaleOrCostFlag: Integer;
        CategoryCodeValue: Code[10];
        CategoryNameValue: Text[40];
        TypeValue: Option Resource,Item,"G/L Account",Ledger;
        CodeValue: Code[20];
        EmployeeOrVendorNameValue: Text[50];
        DocumentNoValue: Text[50];
        PurchaseOrderNoValue: Text[50];
        DateValue: Date;
        EntrySourceValue: Text[50];
        EntryDescriptionValue: Text[50];
        QtyValue: Decimal;
        UOMValue: Text[10];
        UnitCostValue: Decimal;
        AmountValue: Decimal;
        TotalRevenueValue: Decimal;
        TotalExpenseValue: Decimal;
        JLERTEntryNo: Decimal;
        SubJobRecNo: Integer;
}

