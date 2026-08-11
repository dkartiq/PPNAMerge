report 14021172 "NS_Job Detail by Task"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-84.SK.1.0 Added report to search
    //CTSI-158.AS.1.0 21SEPT2020 Increased lengths of Text
    DefaultLayout = RDLC;
    Caption = 'Job Detail by Task';
    RDLCLayout = './Layouts/NSJob Detail by Task.rdl';
    UsageCategory = ReportsAndAnalysis;
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
            column(ReportTitle; ReportTitle)
            {
            }
            column(Job_No_; "No.")
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
            column(TotalJobLbl; STRSUBSTNO(Text14021104, Job."No.", Job.Description))
            {
            }
            column(TotalJobCategoryCaption; TotalJobCategoryLbl)
            {
            }
            column(TotalOperationCaption; TotalOperationLbl)
            {
            }
            column(TotalProcessCaption; TotalProcessLbl)
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
            column(Show_Processes; ShowProcesses)
            {
            }
            column(Show_Operations; ShowOperations)
            {
            }
            dataitem(JobLedgerEntry; "Job Ledger Entry")
            {
                DataItemTableView = SORTING("Entry No.") ORDER(Ascending) WHERE("Entry Type" = CONST(Usage));
                column(Activity_Code; ActivityCode)
                {
                }
                column(Activity_Description; ActivityDescription)
                {
                }
                column(Activity_Caption_and_Code; STRSUBSTNO(Text14021101, ActivityCode))
                {
                }
                column(Process_Code; ProcessCode)
                {
                }
                column(Process_Description; ProcessDescription)
                {
                }
                column(Process_Caption_and_Code; STRSUBSTNO(Text14021102, ProcessCode))
                {
                }
                column(Operation_Code; OperationCode)
                {
                }
                column(Operation_Description; OperationDescription)
                {
                }
                column(Operation_Caption_and_Code; STRSUBSTNO(Text14021103, OperationCode))
                {
                }
                column(Type; TypeValue)
                {
                }
                column("Code"; CodeValue)
                {
                }
                column(EmployeeVendorName; EmployeeVendorNameValue)
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
                column(Total_Subcontract; TotalSubcontractValue)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    //Set Activity/Process/Operation Codes and Descriptions
                    CLEAR(JobActivity);
                    CLEAR(JobProcess);
                    CLEAR(JobOperation);
                    ActivityCode := '';
                    ActivityDescription := '';
                    ProcessCode := '';
                    ProcessDescription := '';
                    OperationCode := '';
                    OperationDescription := '';
                    if "NS_Activity Code" > '' then begin
                        if not JobActivity.GET(JobActivity.NS_Type::Cost, "NS_Activity Code") then
                            JobActivity.GET(JobActivity.NS_Type::Revenue, "NS_Activity Code");
                        ActivityCode := "NS_Activity Code";
                        ActivityDescription := JobActivity.NS_Description;
                        if "NS_Process Code" > '' then begin
                            if not JobProcess.GET(JobActivity.NS_Type::Cost, "NS_Activity Code", "NS_Process Code") then
                                JobProcess.GET(JobActivity.NS_Type::Revenue, "NS_Activity Code", "NS_Process Code");
                            ProcessCode := "NS_Process Code";
                            ProcessDescription := JobProcess.NS_Description;
                            if "NS_Operation Code" > '' then begin
                                if not JobOperation.GET(JobActivity.NS_Type::Cost, "NS_Activity Code", "NS_Process Code", "NS_Operation Code") then
                                    JobOperation.GET(JobActivity.NS_Type::Revenue, "NS_Activity Code", "NS_Process Code", "NS_Operation Code");
                                OperationCode := "NS_Operation Code";
                                OperationDescription := JobOperation.NS_Description;
                            end;
                        end;
                    end;

                    //Setup the print line
                    TypeValue := Type;
                    CodeValue := "No.";
                    case true of
                        "Ledger Entry Type" = "Ledger Entry Type"::Resource:
                            EmployeeVendorNameValue := Description;
                        "NS_External Relationship Type" = "NS_External Relationship Type"::Vendor:
                            EmployeeVendorNameValue := "NS_External Relationship Name";
                    end;
                    DocumentNoValue := "Document No.";
                    PurchaseOrderNoValue := "External Document No.";
                    DateValue := "Document Date";
                    EntrySourceValue := "Source Code";
                    EntryDescriptionValue := Description;
                    QtyValue := Quantity;
                    UOMValue := "Unit of Measure Code";
                    UnitCostValue := "Unit Cost (LCY)";

                    if "NS_Job Cost Category" > '' then begin
                        AmountValue := "Total Cost (LCY)";
                        TotalExpenseValue := "Total Cost (LCY)";
                        TotalRevenueValue := 0;
                    end else begin
                        AmountValue := -"Total Price (LCY)";
                        TotalRevenueValue := -"Total Price (LCY)";
                        TotalExpenseValue := 0;
                    end;
                end;

                trigger OnPreDataItem();
                begin
                    RESET;
                    SETCURRENTKEY("Job No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Job Cost Category", "Entry Type", "Posting Date");
                    SETRANGE("Job No.", Job."No.");
                    if Job.GETFILTER("NS_Date Filter") > '' then
                        SETFILTER("Document Date", Job.GETFILTER("NS_Date Filter"));

                    TotalExpenseValue := 0;
                    TotalRevenueValue := 0;
                end;
            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field("Show Processes"; ShowProcesses)
                    {
                        Caption = 'Show Processes';
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            if not ShowProcesses then
                                ShowOperations := false;
                        end;
                    }
                    field("Show Operations"; ShowOperations)
                    {
                        Caption = 'Show Operations';
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            if ShowOperations then
                                ShowProcesses := true;
                        end;
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
        JobProcess: Record "NS_Job Process";
        JobOperation: Record "NS_Job Operation";
        CompanyInformation: Record "Company Information";
        "Sub-LevelsText": Text;//CTSI-158.AS.1.0 21SEPT2020 Changed length from 50 chars
        JobFilters: Text;//CTSI-158.AS.1.0 21SEPT2020 Changed length from 250 chars
        ShowProcesses: Boolean;
        ShowOperations: Boolean;
        Text14021100: Label 'Job: %1';
        Text14021101: Label 'Activity  %1';
        Text14021102: Label 'Process %1';
        Text14021103: Label 'Operation %1';
        Text14021104: Label 'Totals for Job %1 - %2';
        Text14021105: Label 'Sub-Levels are%1 included in jobs';
        Text14021106: Label '%1 thru %2';
        Text14021107: Label '%1 - %2';
        ReportTitle: Label 'Job Detail by Task';
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
        TotalJobCategoryLbl: Label 'Total Job Category';
        TotalOperationLbl: Label 'Total Operation';
        TotalProcessLbl: Label 'Total Process';
        TotalActivityLbl: Label 'Total Activity';
        TotalRevenueLbl: Label 'Total Revenue';
        TotalExpenseLbl: Label 'Total Expense';
        TotalNetDifferenceLbl: Label 'Total Net Difference';
        notLbl: Label 'not';
        RecordType: Text[10];
        ActivityCode: Code[10];
        ActivityDescription: Text;//CTSI-158.AS.1.0 21SEPT2020 Changed length from 30 chars
        ProcessCode: Code[10];
        ProcessDescription: Text;//CTSI-158.AS.1.0 21SEPT2020 Changed length from 30 chars
        OperationCode: Code[10];
        OperationDescription: Text;//CTSI-158.AS.1.0 21SEPT2020 Changed length from 30 chars
        TypeValue: Option Resource,Item,"G/L Account",Ledger;
        CodeValue: Code[20];
        EmployeeVendorNameValue: Text;//CTSI-158.AS.1.0 21SEPT2020 Changed length from 50 chars
        DocumentNoValue: Text;//CTSI-158.AS.1.0 21SEPT2020 Changed length from 50 chars
        PurchaseOrderNoValue: Text;//CTSI-158.AS.1.0 21SEPT2020 Changed length from 50 chars
        DateValue: Date;
        EntrySourceValue: Text;//CTSI-158.AS.1.0 21SEPT2020 Changed length from 50 chars
        EntryDescriptionValue: Text;//CTSI-158.AS.1.0 21SEPT2020 Changed length from 50 chars
        QtyValue: Decimal;
        UOMValue: Text;//CTSI-158.AS.1.0 21SEPT2020 Changed length from 10 chars
        UnitCostValue: Decimal;
        AmountValue: Decimal;
        Cost: Label 'Cost';
        Revenue: Label 'Revenue';
        TotalRevenueValue: Decimal;
        TotalExpenseValue: Decimal;
        TotalSubcontractValue: Decimal;

    procedure SetProcessOperation(ProcessCodeIn: Code[10]; OperationCodeIn: Code[10]; var ProcessCodeOut: Code[10]; var OperationCodeOut: Code[10]);
    begin
        //This routine either passes incoming Process and Operation codes back out or returns empty strings
        //     depending on if the processes or operations are to be shown.

        if ShowProcesses then
            ProcessCodeOut := ProcessCodeIn
        else
            ProcessCodeOut := '';

        if ShowOperations then
            OperationCodeOut := OperationCodeIn
        else
            OperationCodeOut := '';
    end;
}

