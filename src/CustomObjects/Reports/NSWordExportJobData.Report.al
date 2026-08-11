// //PPDA.1.0 Commented Start
// report 14021162 "NS_Word Export - Job Data"
// {
//     // version PPNA11.00

//     // +------------------------------------------------------------
//     // +ProjectPro
//     // +  - Developed and licensed by GEMKO Information Group Inc.
//     // +  - www.dynamicsnavconstruction.com
//     // +  - www.gemko.com
//     // +------------------------------------------------------------
//     DefaultLayout = RDLC;
//     Caption = 'Word Export - Job Data';
//     RDLCLayout = './Layouts/NSWord Export - Job Data.rdl';
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = Jobs;


//     dataset
//     {
//         dataitem(Job; Job)
//         {
//             column(CompanyInformation_Name; CompanyInformation.Name)
//             {
//             }
//             column(CompanyInformation_Address; CompanyInformation.Address)
//             {
//             }
//             column(CompanyInformation_City; CompanyInformation.City)
//             {
//             }
//             column(CompanyInformation_PostCode; CompanyInformation."Post Code")
//             {
//             }
//             column(CompanyInformation_County; CompanyInformation.County)
//             {
//             }
//             column(CompanyInformation_CountryRegion; CompanyInformation."Country/Region Code")
//             {
//             }
//             column(CompanyInformation_Fax; CompanyInformation."Fax No.")
//             {
//             }
//             column(CompanyInformation_Phone; CompanyInformation."Phone No.")
//             {
//             }
//             column(No_Job; Job."No.")
//             {
//             }
//             column(SearchDescription_Job; Job."Search Description")
//             {
//             }
//             column(Description_Job; Job.Description)
//             {
//             }
//             column(Description2_Job; Job."Description 2")
//             {
//             }
//             column(BilltoCustomerNo_Job; Job."Bill-to Customer No.")
//             {
//             }
//             column(CreationDate_Job; Job."Creation Date")
//             {
//             }
//             column(StartingDate_Job; Job."Starting Date")
//             {
//             }
//             column(EndingDate_Job; Job."Ending Date")
//             {
//             }
//             column(Status_Job; Job.Status)
//             {
//             }
//             column(PersonResponsible_Job; Job."Person Responsible")
//             {
//             }
//             column(GlobalDimension1Code_Job; Job."Global Dimension 1 Code")
//             {
//             }
//             column(GlobalDimension2Code_Job; Job."Global Dimension 2 Code")
//             {
//             }
//             column(JobPostingGroup_Job; Job."Job Posting Group")
//             {
//             }
//             column(Blocked_Job; Job.Blocked)
//             {
//             }
//             column(LastDateModified_Job; Job."Last Date Modified")
//             {
//             }
//             column(Comment_Job; Job.Comment)
//             {
//             }
//             column(CustomerDiscGroup_Job; Job."Customer Disc. Group")
//             {
//             }
//             column(CustomerPriceGroup_Job; Job."Customer Price Group")
//             {
//             }
//             column(LanguageCode_Job; Job."Language Code")
//             {
//             }
//             column(ScheduledResQty_Job; Job."Scheduled Res. Qty.")
//             {
//             }
//             column(ResourceFilter_Job; Job."Resource Filter")
//             {
//             }
//             column(PostingDateFilter_Job; Job."Posting Date Filter")
//             {
//             }
//             column(ResourceGrFilter_Job; Job."Resource Gr. Filter")
//             {
//             }
//             column(ScheduledResGrQty_Job; Job."Scheduled Res. Gr. Qty.")
//             {
//             }
//             column(Picture_Job; Job.Image)
//             {
//             }
//             column(BilltoName_Job; Job."Bill-to Name")
//             {
//             }
//             column(BilltoAddress_Job; Job."Bill-to Address")
//             {
//             }
//             column(BilltoAddress2_Job; Job."Bill-to Address 2")
//             {
//             }
//             column(BilltoCity_Job; Job."Bill-to City")
//             {
//             }
//             column(BilltoCounty_Job; Job."Bill-to County")
//             {
//             }
//             column(BilltoPostCode_Job; Job."Bill-to Post Code")
//             {
//             }
//             column(NoSeries_Job; Job."No. Series")
//             {
//             }
//             column(BilltoCountryRegionCode_Job; Job."Bill-to Country/Region Code")
//             {
//             }
//             column(BilltoName2_Job; Job."Bill-to Name 2")
//             {
//             }
//             column(Reserve_Job; Job.Reserve)
//             {
//             }
//             column(WIPMethod_Job; Job."WIP Method")
//             {
//             }
//             column(CurrencyCode_Job; Job."Currency Code")
//             {
//             }
//             column(BilltoContactNo_Job; Job."Bill-to Contact No.")
//             {
//             }
//             column(BilltoContact_Job; Job."Bill-to Contact")
//             {
//             }
//             column(PlanningDateFilter_Job; Job."Planning Date Filter")
//             {
//             }
//             column(TotalWIPCostAmount_Job; Job."Total WIP Cost Amount")
//             {
//             }
//             column(TotalWIPCostGLAmount_Job; Job."Total WIP Cost G/L Amount")
//             {
//             }
//             column(WIPEntriesExist_Job; Job."WIP Entries Exist")
//             {
//             }
//             column(WIPPostingDate_Job; Job."WIP Posting Date")
//             {
//             }
//             column(WIPGLPostingDate_Job; Job."WIP G/L Posting Date")
//             {
//             }
//             column(InvoiceCurrencyCode_Job; Job."Invoice Currency Code")
//             {
//             }
//             column(ExchCalculationCost_Job; Job."Exch. Calculation (Cost)")
//             {
//             }
//             column(ExchCalculationPrice_Job; Job."Exch. Calculation (Price)")
//             {
//             }
//             column(AllowScheduleContractLines_Job; Job."Allow Schedule/Contract Lines")
//             {
//             }
//             column(Complete_Job; Job.Complete)
//             {
//             }
//             column(RecogSalesAmount_Job; Job."Recog. Sales Amount")
//             {
//             }
//             column(RecogSalesGLAmount_Job; Job."Recog. Sales G/L Amount")
//             {
//             }
//             column(RecogCostsAmount_Job; Job."Recog. Costs Amount")
//             {
//             }
//             column(RecogCostsGLAmount_Job; Job."Recog. Costs G/L Amount")
//             {
//             }
//             column(TotalWIPSalesAmount_Job; Job."Total WIP Sales Amount")
//             {
//             }
//             column(TotalWIPSalesGLAmount_Job; Job."Total WIP Sales G/L Amount")
//             {
//             }
//             column(WIPCompletionCalculated_Job; Job."WIP Completion Calculated")
//             {
//             }
//             column(NextInvoiceDate_Job; Job."Next Invoice Date")
//             {
//             }
//             column(ApplyUsageLink_Job; Job."Apply Usage Link")
//             {
//             }
//             column(WIPWarnings_Job; Job."WIP Warnings")
//             {
//             }
//             column(WIPPostingMethod_Job; Job."WIP Posting Method")
//             {
//             }
//             column(AppliedCostsGLAmount_Job; Job."Applied Costs G/L Amount")
//             {
//             }
//             column(AppliedSalesGLAmount_Job; Job."Applied Sales G/L Amount")
//             {
//             }
//             column(CalcRecogSalesAmount_Job; Job."Calc. Recog. Sales Amount")
//             {
//             }
//             column(CalcRecogCostsAmount_Job; Job."Calc. Recog. Costs Amount")
//             {
//             }
//             column(CalcRecogSalesGLAmount_Job; Job."Calc. Recog. Sales G/L Amount")
//             {
//             }
//             column(CalcRecogCostsGLAmount_Job; Job."Calc. Recog. Costs G/L Amount")
//             {
//             }
//             column(WIPCompletionPosted_Job; Job."WIP Completion Posted")
//             {
//             }
//             column(JobAddress1_Job; Job."NS_Job Address 1")
//             {
//             }
//             column(JobAddress2_Job; Job."NS_Job Address 2")
//             {
//             }
//             column(JobCity_Job; Job."NS_Job City")
//             {
//             }
//             column(JobCounty_Job; Job."NS_Job County")
//             {
//             }
//             column(JobPostCode_Job; Job."NS_Job Post Code")
//             {
//             }
//             column(JobCountryRegionCode_Job; Job."NS_Job Country/Region Code")
//             {
//             }
//             column(JobContact_Job; Job."NS_Job Contact")
//             {
//             }
//             column(JobPhone_Job; Job."NS_Job Phone")
//             {
//             }
//             column(JobShiptoCode_Job; Job."NS_Job Ship-to Code")
//             {
//             }
//             column(SubLeveltoJobNo_Job; Job."NS_Sub-Level to Job No.")
//             {
//             }
//             column(TempLinkedParentJobNo_Job; Job."NS_Temp Linked Parent Job No.")
//             {
//             }
//             column(LastJobForJobList_Job; Job."NS_Last Job For Job List")
//             {
//             }
//             column(JobType_Job; Job."NS_Job Type")
//             {
//             }
//             column(JobClass_Job; Job."NS_Job Class")
//             {
//             }
//             column(TimeAndMaterial_Job; Job."NS_Time And Material")
//             {
//             }
//             column(IndirectBurdenType_Job; Job."NS_Indirect Burden Type")
//             {
//             }
//             column(Estimator_Job; Job.NS_Estimator)
//             {
//             }
//             column(Manager_Job; Job.NS_Manager)
//             {
//             }
//             column(ManagerJobStatus_Job; Job."NS_Manager Job Status")
//             {
//             }
//             column(JobStatusDate_Job; Job."NS_Job Status Date")
//             {
//             }
//             column(EstimatedStartDate_Job; Job."NS_Estimated Start Date")
//             {
//             }
//             column(EstimatedCompletionDate_Job; Job."NS_Estimated Completion Date")
//             {
//             }
//             column(CompletionDate_Job; Job."NS_Completion Date")
//             {
//             }
//             column(JobPostingDate_Job; Job."NS_Job Posting Date")
//             {
//             }
//             column(RecognitionDate_Job; Job."NS_Recognition Date")
//             {
//             }
//             column(UnitofMeasure_Job; Job."NS_Unit of Measure")
//             {
//             }
//             column(TotalUnits_Job; Job."NS_Total Units")
//             {
//             }
//             column(BillingDayofMonth_Job; Job."NS_Billing Day of Month")
//             {
//             }
//             column(BillingMethod_Job; Job."NS_Billing Method")
//             {
//             }
//             column(RecognitionMethod_Job; Job."NS_Recognition Method")
//             {
//             }
//             column(DefaultJobRetention_Job; Job."NS_Default Job Retention")
//             {
//             }
//             column(ForecastType_Job; Job."NS_Forecast Type")
//             {
//             }
//             column(TaxAreaCode_Job; Job."NS_Tax Area Code")
//             {
//             }
//             column(TaxLiable_Job; Job."NS_Tax Liable")
//             {
//             }
//             column(TaxGroupCode_Job; Job."NS_Tax Group Code")
//             {
//             }
//             column(VATBusPostingGroup_Job; Job."NS_VAT Bus. Posting Group")
//             {
//             }
//             column(VATProdPostingGroup_Job; Job."NS_VAT Prod. Posting Group")
//             {
//             }
//             column(ActualPercentComplete_Job; Job."NS_Actual Percent Complete")
//             {
//             }
//             column(ActualPercentCompleteDate_Job; Job."NS_Actual PercentCompleteDate")
//             {
//             }
//             column(ActualUnitsComplete_Job; Job."NS_Actual Units Complete")
//             {
//             }
//             column(ActualUnitsCompleteDate_Job; Job."NS_Actual Units Complete Date")
//             {
//             }
//             column(JobRevenuePosting_Job; Job."NS_Job Revenue Posting")
//             {
//             }
//             column(ProgressBillingNo_Job; Job."NS_Progress Billing No.")
//             {
//             }
//             column(ProgressBillingSubLevel_Job; Job."NS_Progress Billing Sub-Level")
//             {
//             }
//             column(CustomerJobNo_Job; Job."NS_Customer Job No.")
//             {
//             }
//             column(CustomerPONumber_Job; Job."NS_Customer PO Number")
//             {
//             }
//             column(ContractNo_Job; Job."NS_Contract No.")
//             {
//             }
//             column(ContractDate_Job; Job."NS_Contract Date")
//             {
//             }
//             column(ContractFor_Job; Job."NS_Contract For")
//             {
//             }
//             column(ContractType_Job; Job."NS_Contract Type")
//             {
//             }
//             column(RequiresCertifiedPayroll_Job; Job."NS_Requires Certified Payroll")
//             {
//             }
//             column(GenProdPostingGroup_Job; Job."NS_Gen. Prod. Posting Group")
//             {
//             }
//             column(OSFileName_Job; Job."NS_OS File Name")
//             {
//             }
//             column(JobCalendarCode_Job; Job."NS_Job Calendar Code")
//             {
//             }
//             column(CostCategoryFilter_Job; Job."NS_Cost Category Filter")
//             {
//             }
//             column(RevenueCategoryFilter_Job; Job."NS_Revenue Category Filter")
//             {
//             }
//             column(JobTaskNoFilter_Job; Job."NS_Job Task No. Filter")
//             {
//             }
//             column(ExcludeEntryFilter_Job; Job."NS_Exclude Entry Filter")
//             {
//             }
//             column(GlobalDimension1Filter_Job; Job."NS_Global Dimension 1 Filter")
//             {
//             }
//             column(GlobalDimension2Filter_Job; Job."NS_Global Dimension 2 Filter")
//             {
//             }
//             column(EntryTypeFilter_Job; Job."NS_Entry Type Filter")
//             {
//             }
//             column(AdjustmentFilter_Job; Job."NS_Adjustment Filter")
//             {
//             }
//             column(BudgetTypeFilter_Job; Job."NS_Budget Type Filter")
//             {
//             }
//             column(ItemNoFilter_Job; Job."NS_Item No. Filter")
//             {
//             }
//             column(TypeFilter_Job; Job."NS_Type Filter")
//             {
//             }
//             column(DateFilter_Job; Job."NS_Date Filter")
//             {
//             }
//             column(ActivityFilter_Job; Job."NS_Activity Filter")
//             {
//             }
//             column(ProcessFilter_Job; Job."NS_Process Filter")
//             {
//             }
//             column(OperationFilter_Job; Job."NS_Operation Filter")
//             {
//             }
//             column(BudgetedCostLCY_Job; Job."NS_Budgeted Cost (LCY)")
//             {
//             }
//             column(BudgetedPriceLCY_Job; Job."NS_Budgeted Price (LCY)")
//             {
//             }
//             column(BudgetedCostQuantity_Job; Job."NS_Budgeted Cost Quantity")
//             {
//             }
//             column(BudgetedPriceQuantity_Job; Job."NS_Budgeted Price Quantity")
//             {
//             }
//             column(BudgetedResQty_Job; Job."NS_Budgeted Res. Qty.")
//             {
//             }
//             column(BudgetedResGrQty_Job; Job."NS_Budgeted Res. Gr. Qty.")
//             {
//             }
//             column(UsageCostLCY_Job; Job."NS_Usage (Cost) (LCY)")
//             {
//             }
//             column(UsagePriceLCY_Job; Job."NS_Usage (Price) (LCY)")
//             {
//             }
//             column(ActualCostQuantityUsage_Job; Job."NS_Actual Cost Quantity(Usage)")
//             {
//             }
//             column(ActualPriceQuantityUsage_Job; Job."NS_Actual PriceQuantity(Usage)")
//             {
//             }
//             column(ActualCostQuantitySale_Job; Job."NS_Actual Cost Quantity (Sale)")
//             {
//             }
//             column(ActualPriceQuantitySale_Job; Job."NS_Actual Price Quantity(Sale)")
//             {
//             }
//             column(InvoicedPriceLCY_Job; Job."NS_Invoiced Price (LCY)")
//             {
//             }
//             column(AmtPaidLCY_Job; Job."NS_Amt. Paid (LCY)")
//             {
//             }
//             column(AmtPostedToGL_Job; Job."NS_Amt. Posted To G/L")
//             {
//             }
//             column(AmtRecognized_Job; Job."NS_Amt. Recognized")
//             {
//             }
//             column(JobCalendarType_Job; Job."NS_Job Calendar Type")
//             {
//             }
//             column(RetentionLedgerFilter_Job; Job."NS_Retention Ledger Filter")
//             {
//             }
//               column(GenProdPostingGroup_Job; Job."NS_Gen. Prod. Posting Group New")//PRJ-831.AS.1.0 12OCT2021 Replaced Job Table field Gen Bus Posting Grp with Gen Bus Posting Grp New
//              {
//              }
//             dataitem(Subcontract; NS_Subcontract)
//             {
//                 CalcFields = "NS_Budgeted Cost (LCY)";
//                 DataItemLink = "NS_Job No." = FIELD("No.");
//                 column(No_Subcontract; Subcontract."NS_No.")
//                 {
//                 }
//                 column(SearchDescription_Subcontract; Subcontract."NS_Search Description")
//                 {
//                 }
//                 column(Description_Subcontract; Subcontract.NS_Description)
//                 {
//                 }
//                 column(Description2_Subcontract; Subcontract."NS_Description 2")
//                 {
//                 }
//                 column(BuyfromVendorNo_Subcontract; Subcontract."NS_Buy-from Vendor No.")
//                 {
//                 }
//                 column(JobNo_Subcontract; Subcontract."NS_Job No.")
//                 {
//                 }
//                 column(CreationDate_Subcontract; Subcontract."NS_Creation Date")
//                 {
//                 }
//                 column(StartingDate_Subcontract; Subcontract."NS_Starting Date")
//                 {
//                 }
//                 column(EndingDate_Subcontract; Subcontract."NS_Ending Date")
//                 {
//                 }
//                 column(Status_Subcontract; Subcontract.NS_Status)
//                 {
//                 }
//                 column(PersonResponsible_Subcontract; Subcontract."NS_Person Responsible")
//                 {
//                 }
//                 column(GlobalDimension1Code_Subcontract; Subcontract."NS_Global Dimension 1 Code")
//                 {
//                 }
//                 column(GlobalDimension2Code_Subcontract; Subcontract."NS_Global Dimension 2 Code")
//                 {
//                 }
//                 column(Blocked_Subcontract; Subcontract.NS_Blocked)
//                 {
//                 }
//                 column(LastDateModified_Subcontract; Subcontract."NS_Last Date Modified")
//                 {
//                 }
//                 column(Comment_Subcontract; Subcontract.NS_Comment)
//                 {
//                 }
//                 column(LanguageCode_Subcontract; Subcontract."NS_Language Code")
//                 {
//                 }
//                 column(ScheduledResQty_Subcontract; Subcontract."NS_Scheduled Res. Qty.")
//                 {
//                 }
//                 column(ResourceFilter_Subcontract; Subcontract."NS_Resource Filter")
//                 {
//                 }
//                 column(PostingDateFilter_Subcontract; Subcontract."NS_Posting Date Filter")
//                 {
//                 }
//                 column(ResourceGrFilter_Subcontract; Subcontract."NS_Resource Gr. Filter")
//                 {
//                 }
//                 column(ScheduledResGrQty_Subcontract; Subcontract."NS_Scheduled Res. Gr. Qty.")
//                 {
//                 }
//                 column(Picture_Subcontract; Subcontract.NS_Picture)
//                 {
//                 }
//                 column(BuyfromName_Subcontract; Subcontract."NS_Buy-from Name")
//                 {
//                 }
//                 column(BuyfromAddress_Subcontract; Subcontract."NS_Buy-from Address")
//                 {
//                 }
//                 column(BuyfromAddress2_Subcontract; Subcontract."NS_Buy-from Address 2")
//                 {
//                 }
//                 column(BuyfromCity_Subcontract; Subcontract."NS_Buy-from City")
//                 {
//                 }
//                 column(County_Subcontract; Subcontract.NS_County)
//                 {
//                 }
//                 column(BuyfromPostCode_Subcontract; Subcontract."NS_Buy-from Post Code")
//                 {
//                 }
//                 column(NoSeries_Subcontract; Subcontract."NS_No. Series")
//                 {
//                 }
//                 column(BuyfromCountryRegionCode_Subcontract; Subcontract."NS_Buy-fromCountry/RegionCode")
//                 {
//                 }
//                 column(BuyfromName2_Subcontract; Subcontract."NS_Buy-from Name 2")
//                 {
//                 }
//                 column(CurrencyCode_Subcontract; Subcontract."NS_Currency Code")
//                 {
//                 }
//                 column(BuyfromContactNo_Subcontract; Subcontract."NS_Buy-from Contact No.")
//                 {
//                 }
//                 column(BuyfromContact_Subcontract; Subcontract."NS_Buy-from Contact")
//                 {
//                 }
//                 column(PlanningDateFilter_Subcontract; Subcontract."NS_Planning Date Filter")
//                 {
//                 }
//                 column(InvoiceCurrencyCode_Subcontract; Subcontract."NS_Invoice Currency Code")
//                 {
//                 }
//                 column(ExchCalculationCost_Subcontract; Subcontract."NS_Exch. Calculation (Cost)")
//                 {
//                 }
//                 column(ExchCalculationPrice_Subcontract; Subcontract."NS_Exch. Calculation (Price)")
//                 {
//                 }
//                 column(AllowScheduleContractLines_Subcontract; Subcontract."NS_AllowSchedule/ContractLines")
//                 {
//                 }
//                 column(Complete_Subcontract; Subcontract.NS_Complete)
//                 {
//                 }
//                 column(RecogCostsAmount_Subcontract; Subcontract."NS_Recog. Costs Amount")
//                 {
//                 }
//                 column(RecogCostsGLAmount_Subcontract; Subcontract."NS_Recog. Costs G/L Amount")
//                 {
//                 }
//                 column(NextInvoiceDate_Subcontract; Subcontract."NS_Next Invoice Date")
//                 {
//                 }
//                 column(SubLeveltoSubcontractNo_Subcontract; Subcontract."NS_Sub-LeveltoSubcontractNo.")
//                 {
//                 }
//                 column(TempLinkedParentSubcontNo_Subcontract; Subcontract."NS_Temp LinkedParentSubcontNo.")
//                 {
//                 }
//                 column(LastSubcontForSubcontList_Subcontract; Subcontract."NS_Last SubcontForSubcontList")
//                 {
//                 }
//                 column(ManagerSubcontractStatus_Subcontract; Subcontract."NS_Manager Subcontract Status")
//                 {
//                 }
//                 column(SubcontractStatusDate_Subcontract; Subcontract."NS_Subcontract Status Date")
//                 {
//                 }
//                 column(EstimatedStartDate_Subcontract; Subcontract."NS_Estimated Start Date")
//                 {
//                 }
//                 column(EstimatedCompletionDate_Subcontract; Subcontract."NS_Estimated Completion Date")
//                 {
//                 }
//                 column(CompletionDate_Subcontract; Subcontract."NS_Completion Date")
//                 {
//                 }
//                 column(RetentionPercent_Subcontract; Subcontract."NS_Retention Percent")
//                 {
//                 }
//                 column(SubcontractCostPosting_Subcontract; Subcontract."NS_Subcontract Cost Posting")
//                 {
//                 }
//                 column(CostCategoryFilter_Subcontract; Subcontract."NS_Cost Category Filter")
//                 {
//                 }
//                 column(RevenueCategoryFilter_Subcontract; Subcontract."NS_Revenue Category Filter")
//                 {
//                 }
//                 column(JobTaskNoFilter_Subcontract; Subcontract."NS_Job Task No. Filter")
//                 {
//                 }
//                 column(GlobalDimension1Filter_Subcontract; Subcontract."NS_Global Dimension 1 Filter")
//                 {
//                 }
//                 column(GlobalDimension2Filter_Subcontract; Subcontract."NS_Global Dimension 2 Filter")
//                 {
//                 }
//                 column(EntryTypeFilter_Subcontract; Subcontract."NS_Entry Type Filter")
//                 {
//                 }
//                 column(AdjustmentFilter_Subcontract; Subcontract."NS_Adjustment Filter")
//                 {
//                 }
//                 column(BudgetTypeFilter_Subcontract; Subcontract."NS_Budget Type Filter")
//                 {
//                 }
//                 column(TypeFilter_Subcontract; Subcontract."NS_Date Filter")
//                 {
//                 }
//                 column(ActivityFilter_Subcontract; Subcontract."NS_Activity Filter")
//                 {
//                 }
//                 column(ProcessFilter_Subcontract; Subcontract."NS_Process Filter")
//                 {
//                 }
//                 column(OperationFilter_Subcontract; Subcontract."NS_Operation Filter")
//                 {
//                 }
//                 column(BudgetedCostLCY_Subcontract; Subcontract."NS_Budgeted Cost (LCY)")
//                 {
//                 }
//                 column(BudgetedCostQuantity_Subcontract; Subcontract."NS_Budgeted Cost Quantity")
//                 {
//                 }
//                 column(UsageCostLCY_Subcontract; Subcontract."NS_Usage (Cost) (LCY)")
//                 {
//                 }
//                 column(InvoicedCostLCY_Subcontract; Subcontract."NS_Invoiced Cost (LCY)")
//                 {
//                 }
//                 column(SubcontractUsageCostLCY_Subcontract; Subcontract."NS_SubcontractUsageCost(LCY)")
//                 {
//                 }
//                 column(RetentionLedgerFilter_Subcontract; Subcontract."NS_Retention Ledger Filter")
//                 {
//                 }
//                 column(OrginalSubContractAmt_Subcontract; OrginalSubContractAmt)
//                 {
//                 }
//                 column(TotalPrevCO_Subcontract; TotalPrevCO)
//                 {
//                 }
//                 column(ContractPrior_Subcontract; ContractPrior)
//                 {
//                 }
//                 column(BTotalCost_Subcontract; BTotalCost)
//                 {
//                 }
//                 column(NewContractAmount_Subcontract; NewContractAmount)
//                 {
//                 }
//                 dataitem("Subcontract Lines"; "NS_Subcontract Lines")
//                 {
//                     DataItemLink = "NS_Subcontract No." = FIELD("NS_No.");
//                     column(SubcontractNo_SubcontractDetail; "Subcontract Lines"."NS_Subcontract No.")
//                     {
//                     }
//                     column(LineNo_SubcontractDetail; "Subcontract Lines"."NS_Line No.")
//                     {
//                     }
//                     column(JobNo_SubcontractDetail; "Subcontract Lines"."NS_Job No.")
//                     {
//                     }
//                     column(JobTaskNo_SubcontractDetail; "Subcontract Lines"."NS_Job Task No.")
//                     {
//                     }
//                     column(JobCostCategory_SubcontractDetail; "Subcontract Lines"."NS_Job Cost Category")
//                     {
//                     }
//                     column(StartingDate_SubcontractDetail; "Subcontract Lines"."NS_Starting Date")
//                     {
//                     }
//                     column(Type_SubcontractDetail; "Subcontract Lines".NS_Type)
//                     {
//                     }
//                     column(No_SubcontractDetail; "Subcontract Lines"."NS_No.")
//                     {
//                     }
//                     column(Description_SubcontractDetail; "Subcontract Lines".NS_Description)
//                     {
//                     }
//                     column(Quantity_SubcontractDetail; "Subcontract Lines".NS_Quantity)
//                     {
//                     }
//                     column(UnitofMeasureCode_SubcontractDetail; "Subcontract Lines"."NS_Unit of Measure Code")
//                     {
//                     }
//                     column(DirectUnitCost_SubcontractDetail; "Subcontract Lines"."NS_Direct Unit Cost")
//                     {
//                     }
//                     column(UnitCost_SubcontractDetail; "Subcontract Lines"."NS_Unit Cost")
//                     {
//                     }
//                     column(TotalCost_SubcontractDetail; "Subcontract Lines"."NS_Total Cost")
//                     {
//                     }
//                     column(BillingMethod_SubcontractDetail; "Subcontract Lines"."NS_Progress Payment Method")
//                     {
//                     }
//                     column(BaseAmount_SubcontractDetail; "Subcontract Lines"."NS_Base Amount")
//                     {
//                     }
//                     column(QuantityBase_SubcontractDetail; "Subcontract Lines"."NS_Quantity (Base)")
//                     {
//                     }
//                     column(QtyperUnitofMeasure_SubcontractDetail; "Subcontract Lines"."NS_Qty. per Unit of Measure")
//                     {
//                     }
//                     column(CurrencyCode_SubcontractDetail; "Subcontract Lines"."NS_Currency Code")
//                     {
//                     }
//                     column(VariantCode_SubcontractDetail; "Subcontract Lines"."NS_Variant Code")
//                     {
//                     }
//                     column(ActivityCode_SubcontractDetail; "Subcontract Lines"."NS_Activity Code")
//                     {
//                     }
//                     column(ProcessCode_SubcontractDetail; "Subcontract Lines"."NS_Process Code")
//                     {
//                     }
//                     column(OperationCode_SubcontractDetail; "Subcontract Lines"."NS_Operation Code")
//                     {
//                     }
//                     column(WorkUnits_SubcontractDetail; "Subcontract Lines"."NS_Work Units")
//                     {
//                     }
//                     column(WorkUnitofMeasure_SubcontractDetail; "Subcontract Lines"."NS_Work Unit of Measure")
//                     {
//                     }
//                 }
//                 dataitem(SubContract_Vendor; Vendor)
//                 {
//                     DataItemLink = "No." = FIELD("NS_Buy-from Vendor No.");
//                     column(No_SubContractVendor; SubContract_Vendor."No.")
//                     {
//                     }
//                     column(Name_SubContractVendor; SubContract_Vendor.Name)
//                     {
//                     }
//                     column(SearchName_SubContractVendor; SubContract_Vendor."Search Name")
//                     {
//                     }
//                     column(Name2_SubContractVendor; SubContract_Vendor."Name 2")
//                     {
//                     }
//                     column(Address_SubContractVendor; SubContract_Vendor.Address)
//                     {
//                     }
//                     column(Address2_SubContractVendor; SubContract_Vendor."Address 2")
//                     {
//                     }
//                     column(City_SubContractVendor; SubContract_Vendor.City)
//                     {
//                     }
//                     column(Contact_SubContractVendor; SubContract_Vendor.Contact)
//                     {
//                     }
//                     column(PhoneNo_SubContractVendor; SubContract_Vendor."Phone No.")
//                     {
//                     }
//                     column(TelexNo_SubContractVendor; SubContract_Vendor."Telex No.")
//                     {
//                     }
//                     column(OurAccountNo_SubContractVendor; SubContract_Vendor."Our Account No.")
//                     {
//                     }
//                     column(TerritoryCode_SubContractVendor; SubContract_Vendor."Territory Code")
//                     {
//                     }
//                     column(GlobalDimension1Code_SubContractVendor; SubContract_Vendor."Global Dimension 1 Code")
//                     {
//                     }
//                     column(GlobalDimension2Code_SubContractVendor; SubContract_Vendor."Global Dimension 2 Code")
//                     {
//                     }
//                     column(BudgetedAmount_SubContractVendor; SubContract_Vendor."Budgeted Amount")
//                     {
//                     }
//                     column(VendorPostingGroup_SubContractVendor; SubContract_Vendor."Vendor Posting Group")
//                     {
//                     }
//                     column(CurrencyCode_SubContractVendor; SubContract_Vendor."Currency Code")
//                     {
//                     }
//                     column(LanguageCode_SubContractVendor; SubContract_Vendor."Language Code")
//                     {
//                     }
//                     column(StatisticsGroup_SubContractVendor; SubContract_Vendor."Statistics Group")
//                     {
//                     }
//                     column(PaymentTermsCode_SubContractVendor; SubContract_Vendor."Payment Terms Code")
//                     {
//                     }
//                     column(FinChargeTermsCode_SubContractVendor; SubContract_Vendor."Fin. Charge Terms Code")
//                     {
//                     }
//                     column(PurchaserCode_SubContractVendor; SubContract_Vendor."Purchaser Code")
//                     {
//                     }
//                     column(ShipmentMethodCode_SubContractVendor; SubContract_Vendor."Shipment Method Code")
//                     {
//                     }
//                     column(ShippingAgentCode_SubContractVendor; SubContract_Vendor."Shipping Agent Code")
//                     {
//                     }
//                     column(InvoiceDiscCode_SubContractVendor; SubContract_Vendor."Invoice Disc. Code")
//                     {
//                     }
//                     column(CountryRegionCode_SubContractVendor; SubContract_Vendor."Country/Region Code")
//                     {
//                     }
//                     column(Comment_SubContractVendor; SubContract_Vendor.Comment)
//                     {
//                     }
//                     column(Blocked_SubContractVendor; SubContract_Vendor.Blocked)
//                     {
//                     }
//                     column(PaytoVendorNo_SubContractVendor; SubContract_Vendor."Pay-to Vendor No.")
//                     {
//                     }
//                     column(Priority_SubContractVendor; SubContract_Vendor.Priority)
//                     {
//                     }
//                     column(PaymentMethodCode_SubContractVendor; SubContract_Vendor."Payment Method Code")
//                     {
//                     }
//                     column(LastDateModified_SubContractVendor; SubContract_Vendor."Last Date Modified")
//                     {
//                     }
//                     column(DateFilter_SubContractVendor; SubContract_Vendor."Date Filter")
//                     {
//                     }
//                     column(GlobalDimension1Filter_SubContractVendor; SubContract_Vendor."Global Dimension 1 Filter")
//                     {
//                     }
//                     column(GlobalDimension2Filter_SubContractVendor; SubContract_Vendor."Global Dimension 2 Filter")
//                     {
//                     }
//                     column(Balance_SubContractVendor; SubContract_Vendor.Balance)
//                     {
//                     }
//                     column(BalanceLCY_SubContractVendor; SubContract_Vendor."Balance (LCY)")
//                     {
//                     }
//                     column(NetChange_SubContractVendor; SubContract_Vendor."Net Change")
//                     {
//                     }
//                     column(NetChangeLCY_SubContractVendor; SubContract_Vendor."Net Change (LCY)")
//                     {
//                     }
//                     column(PurchasesLCY_SubContractVendor; SubContract_Vendor."Purchases (LCY)")
//                     {
//                     }
//                     column(InvDiscountsLCY_SubContractVendor; SubContract_Vendor."Inv. Discounts (LCY)")
//                     {
//                     }
//                     column(PmtDiscountsLCY_SubContractVendor; SubContract_Vendor."Pmt. Discounts (LCY)")
//                     {
//                     }
//                     column(BalanceDue_SubContractVendor; SubContract_Vendor."Balance Due")
//                     {
//                     }
//                     column(BalanceDueLCY_SubContractVendor; SubContract_Vendor."Balance Due (LCY)")
//                     {
//                     }
//                     column(Payments_SubContractVendor; SubContract_Vendor.Payments)
//                     {
//                     }
//                     column(InvoiceAmounts_SubContractVendor; SubContract_Vendor."Invoice Amounts")
//                     {
//                     }
//                     column(CrMemoAmounts_SubContractVendor; SubContract_Vendor."Cr. Memo Amounts")
//                     {
//                     }
//                     column(FinanceChargeMemoAmounts_SubContractVendor; SubContract_Vendor."Finance Charge Memo Amounts")
//                     {
//                     }
//                     column(PaymentsLCY_SubContractVendor; SubContract_Vendor."Payments (LCY)")
//                     {
//                     }
//                     column(InvAmountsLCY_SubContractVendor; SubContract_Vendor."Inv. Amounts (LCY)")
//                     {
//                     }
//                     column(CrMemoAmountsLCY_SubContractVendor; SubContract_Vendor."Cr. Memo Amounts (LCY)")
//                     {
//                     }
//                     column(FinChargeMemoAmountsLCY_SubContractVendor; SubContract_Vendor."Fin. Charge Memo Amounts (LCY)")
//                     {
//                     }
//                     column(OutstandingOrders_SubContractVendor; SubContract_Vendor."Outstanding Orders")
//                     {
//                     }
//                     column(AmtRcdNotInvoiced_SubContractVendor; SubContract_Vendor."Amt. Rcd. Not Invoiced")
//                     {
//                     }
//                     column(ApplicationMethod_SubContractVendor; SubContract_Vendor."Application Method")
//                     {
//                     }
//                     column(PricesIncludingVAT_SubContractVendor; SubContract_Vendor."Prices Including VAT")
//                     {
//                     }
//                     column(FaxNo_SubContractVendor; SubContract_Vendor."Fax No.")
//                     {
//                     }
//                     column(TelexAnswerBack_SubContractVendor; SubContract_Vendor."Telex Answer Back")
//                     {
//                     }
//                     column(VATRegistrationNo_SubContractVendor; SubContract_Vendor."VAT Registration No.")
//                     {
//                     }
//                     column(GenBusPostingGroup_SubContractVendor; SubContract_Vendor."Gen. Bus. Posting Group")
//                     {
//                     }
//                     column(Picture_SubContractVendor; SubContract_Vendor.Image)
//                     {
//                     }
//                     column(PostCode_SubContractVendor; SubContract_Vendor."Post Code")
//                     {
//                     }
//                     column(County_SubContractVendor; SubContract_Vendor.County)
//                     {
//                     }
//                     column(DebitAmount_SubContractVendor; SubContract_Vendor."Debit Amount")
//                     {
//                     }
//                     column(CreditAmount_SubContractVendor; SubContract_Vendor."Credit Amount")
//                     {
//                     }
//                     column(DebitAmountLCY_SubContractVendor; SubContract_Vendor."Debit Amount (LCY)")
//                     {
//                     }
//                     column(CreditAmountLCY_SubContractVendor; SubContract_Vendor."Credit Amount (LCY)")
//                     {
//                     }
//                     column(EMail_SubContractVendor; SubContract_Vendor."E-Mail")
//                     {
//                     }
//                     column(HomePage_SubContractVendor; SubContract_Vendor."Home Page")
//                     {
//                     }
//                     column(ReminderAmounts_SubContractVendor; SubContract_Vendor."Reminder Amounts")
//                     {
//                     }
//                     column(ReminderAmountsLCY_SubContractVendor; SubContract_Vendor."Reminder Amounts (LCY)")
//                     {
//                     }
//                     column(NoSeries_SubContractVendor; SubContract_Vendor."No. Series")
//                     {
//                     }
//                     column(TaxAreaCode_SubContractVendor; SubContract_Vendor."Tax Area Code")
//                     {
//                     }
//                     column(TaxLiable_SubContractVendor; SubContract_Vendor."Tax Liable")
//                     {
//                     }
//                     column(VATBusPostingGroup_SubContractVendor; SubContract_Vendor."VAT Bus. Posting Group")
//                     {
//                     }
//                     column(CurrencyFilter_SubContractVendor; SubContract_Vendor."Currency Filter")
//                     {
//                     }
//                     column(OutstandingOrdersLCY_SubContractVendor; SubContract_Vendor."Outstanding Orders (LCY)")
//                     {
//                     }
//                     column(AmtRcdNotInvoicedLCY_SubContractVendor; SubContract_Vendor."Amt. Rcd. Not Invoiced (LCY)")
//                     {
//                     }
//                     column(BlockPaymentTolerance_SubContractVendor; SubContract_Vendor."Block Payment Tolerance")
//                     {
//                     }
//                     column(PmtDiscToleranceLCY_SubContractVendor; SubContract_Vendor."Pmt. Disc. Tolerance (LCY)")
//                     {
//                     }
//                     column(PmtToleranceLCY_SubContractVendor; SubContract_Vendor."Pmt. Tolerance (LCY)")
//                     {
//                     }
//                     column(ICPartnerCode_SubContractVendor; SubContract_Vendor."IC Partner Code")
//                     {
//                     }
//                     column(Refunds_SubContractVendor; SubContract_Vendor.Refunds)
//                     {
//                     }
//                     column(RefundsLCY_SubContractVendor; SubContract_Vendor."Refunds (LCY)")
//                     {
//                     }
//                     column(OtherAmounts_SubContractVendor; SubContract_Vendor."Other Amounts")
//                     {
//                     }
//                     column(OtherAmountsLCY_SubContractVendor; SubContract_Vendor."Other Amounts (LCY)")
//                     {
//                     }
//                     column(Prepayment_SubContractVendor; SubContract_Vendor."Prepayment %")
//                     {
//                     }
//                     column(OutstandingInvoices_SubContractVendor; SubContract_Vendor."Outstanding Invoices")
//                     {
//                     }
//                     column(OutstandingInvoicesLCY_SubContractVendor; SubContract_Vendor."Outstanding Invoices (LCY)")
//                     {
//                     }
//                     column(PaytoNoOfArchivedDoc_SubContractVendor; SubContract_Vendor."Pay-to No. Of Archived Doc.")
//                     {
//                     }
//                     column(BuyfromNoOfArchivedDoc_SubContractVendor; SubContract_Vendor."Buy-from No. Of Archived Doc.")
//                     {
//                     }
//                     column(PartnerType_SubContractVendor; SubContract_Vendor."Partner Type")
//                     {
//                     }
//                     column(CreditorNo_SubContractVendor; SubContract_Vendor."Creditor No.")
//                     {
//                     }
//                     column(PreferredBankAccount_SubContractVendor; SubContract_Vendor."Preferred Bank Account Code")
//                     {
//                     }
//                     column(CashFlowPaymentTermsCode_SubContractVendor; SubContract_Vendor."Cash Flow Payment Terms Code")
//                     {
//                     }
//                     column(PrimaryContactNo_SubContractVendor; SubContract_Vendor."Primary Contact No.")
//                     {
//                     }
//                     column(ResponsibilityCenter_SubContractVendor; SubContract_Vendor."Responsibility Center")
//                     {
//                     }
//                     column(LocationCode_SubContractVendor; SubContract_Vendor."Location Code")
//                     {
//                     }
//                     column(LeadTimeCalculation_SubContractVendor; SubContract_Vendor."Lead Time Calculation")
//                     {
//                     }
//                     column(NoofPstdReceipts_SubContractVendor; SubContract_Vendor."No. of Pstd. Receipts")
//                     {
//                     }
//                     column(NoofPstdInvoices_SubContractVendor; SubContract_Vendor."No. of Pstd. Invoices")
//                     {
//                     }
//                     column(NoofPstdReturnShipments_SubContractVendor; SubContract_Vendor."No. of Pstd. Return Shipments")
//                     {
//                     }
//                     column(NoofPstdCreditMemos_SubContractVendor; SubContract_Vendor."No. of Pstd. Credit Memos")
//                     {
//                     }
//                     column(PaytoNoofOrders_SubContractVendor; SubContract_Vendor."Pay-to No. of Orders")
//                     {
//                     }
//                     column(PaytoNoofInvoices_SubContractVendor; SubContract_Vendor."Pay-to No. of Invoices")
//                     {
//                     }
//                     column(PaytoNoofReturnOrders_SubContractVendor; SubContract_Vendor."Pay-to No. of Return Orders")
//                     {
//                     }
//                     column(PaytoNoofCreditMemos_SubContractVendor; SubContract_Vendor."Pay-to No. of Credit Memos")
//                     {
//                     }
//                     column(PaytoNoofPstdReceipts_SubContractVendor; SubContract_Vendor."Pay-to No. of Pstd. Receipts")
//                     {
//                     }
//                     column(PaytoNoofPstdInvoices_SubContractVendor; SubContract_Vendor."Pay-to No. of Pstd. Invoices")
//                     {
//                     }
//                     column(PaytoNoofPstdReturnS_SubContractVendor; SubContract_Vendor."Pay-to No. of Pstd. Return S.")
//                     {
//                     }
//                     column(PaytoNoofPstdCrMemos_SubContractVendor; SubContract_Vendor."Pay-to No. of Pstd. Cr. Memos")
//                     {
//                     }
//                     column(NoofQuotes_SubContractVendor; SubContract_Vendor."No. of Quotes")
//                     {
//                     }
//                     column(NoofBlanketOrders_SubContractVendor; SubContract_Vendor."No. of Blanket Orders")
//                     {
//                     }
//                     column(NoofOrders_SubContractVendor; SubContract_Vendor."No. of Orders")
//                     {
//                     }
//                     column(NoofInvoices_SubContractVendor; SubContract_Vendor."No. of Invoices")
//                     {
//                     }
//                     column(NoofReturnOrders_SubContractVendor; SubContract_Vendor."No. of Return Orders")
//                     {
//                     }
//                     column(NoofCreditMemos_SubContractVendor; SubContract_Vendor."No. of Credit Memos")
//                     {
//                     }
//                     column(NoofOrderAddresses_SubContractVendor; SubContract_Vendor."No. of Order Addresses")
//                     {
//                     }
//                     column(PaytoNoofQuotes_SubContractVendor; SubContract_Vendor."Pay-to No. of Quotes")
//                     {
//                     }
//                     column(PaytoNoofBlanketOrders_SubContractVendor; SubContract_Vendor."Pay-to No. of Blanket Orders")
//                     {
//                     }
//                     column(BaseCalendarCode_SubContractVendor; SubContract_Vendor."Base Calendar Code")
//                     {
//                     }
//                     column(UPSZone_SubContractVendor; SubContract_Vendor."UPS Zone")
//                     {
//                     }
//                     column(FederalIDNo_SubContractVendor; SubContract_Vendor."Federal ID No.")
//                     {
//                     }
//                     column(BankCommunication_SubContractVendor; SubContract_Vendor."Bank Communication")
//                     {
//                     }
//                     column(CheckDateFormat_SubContractVendor; SubContract_Vendor."Check Date Format")
//                     {
//                     }
//                     column(CheckDateSeparator_SubContractVendor; SubContract_Vendor."Check Date Separator")
//                     {
//                     }
//                     column(IRS1099Code_SubContractVendor; SubContract_Vendor."IRS 1099 Code")
//                     {
//                     }
//                     column(BalanceonDate_SubContractVendor; SubContract_Vendor."Balance on Date")
//                     {
//                     }
//                     column(BalanceonDateLCY_SubContractVendor; SubContract_Vendor."Balance on Date (LCY)")
//                     {
//                     }
//                     column(RFCNo_SubContractVendor; SubContract_Vendor."RFC No.")
//                     {
//                     }
//                     column(CURPNo_SubContractVendor; SubContract_Vendor."CURP No.")
//                     {
//                     }
//                     column(StateInscription_SubContractVendor; SubContract_Vendor."State Inscription")
//                     {
//                     }
//                     column(TaxIdentificationType_SubContractVendor; SubContract_Vendor."Tax Identification Type")
//                     {
//                     }
//                     column(DefaultRetentionPercent_SubContractVendor; SubContract_Vendor."NS_Default Retention Percent")
//                     {
//                     }
//                     column(JobCalendarCode_SubContractVendor; SubContract_Vendor."NS_Job Calendar Code")
//                     {
//                     }
//                     column(RetentionLedgerCodeFilter_SubContractVendor; SubContract_Vendor."NS_Retention Ledger CodeFilter")
//                     {
//                     }

//                     //PPDA.1.0 Start
//                     trigger OnAfterGetRecord()
//                     begin

//                     end;
//                     //PPDA.1.0 End
//                 }
//                 dataitem(SubContract_Resource; Resource)
//                 {
//                     DataItemLink = "No." = FIELD("NS_Person Responsible");
//                     column(No_SubContractResource; SubContract_Resource."No.")
//                     {
//                     }
//                     column(Type_SubContractResource; SubContract_Resource.Type)
//                     {
//                     }
//                     column(Name_SubContractResource; SubContract_Resource.Name)
//                     {
//                     }
//                     column(SearchName_SubContractResource; SubContract_Resource."Search Name")
//                     {
//                     }
//                     column(Name2_SubContractResource; SubContract_Resource."Name 2")
//                     {
//                     }
//                     column(Address_SubContractResource; SubContract_Resource.Address)
//                     {
//                     }
//                     column(Address2_SubContractResource; SubContract_Resource."Address 2")
//                     {
//                     }
//                     column(City_SubContractResource; SubContract_Resource.City)
//                     {
//                     }
//                     column(SocialSecurityNo_SubContractResource; SubContract_Resource."Social Security No.")
//                     {
//                     }
//                     column(JobTitle_SubContractResource; SubContract_Resource."Job Title")
//                     {
//                     }
//                     column(Education_SubContractResource; SubContract_Resource.Education)
//                     {
//                     }
//                     column(ContractClass_SubContractResource; SubContract_Resource."Contract Class")
//                     {
//                     }
//                     column(EmploymentDate_SubContractResource; SubContract_Resource."Employment Date")
//                     {
//                     }
//                     column(ResourceGroupNo_SubContractResource; SubContract_Resource."Resource Group No.")
//                     {
//                     }
//                     column(GlobalDimension1Code_SubContractResource; SubContract_Resource."Global Dimension 1 Code")
//                     {
//                     }
//                     column(GlobalDimension2Code_SubContractResource; SubContract_Resource."Global Dimension 2 Code")
//                     {
//                     }
//                     column(BaseUnitofMeasure_SubContractResource; SubContract_Resource."Base Unit of Measure")
//                     {
//                     }
//                     column(DirectUnitCost_SubContractResource; SubContract_Resource."Direct Unit Cost")
//                     {
//                     }
//                     column(IndirectCost_SubContractResource; SubContract_Resource."Indirect Cost %")
//                     {
//                     }
//                     column(UnitCost_SubContractResource; SubContract_Resource."Unit Cost")
//                     {
//                     }
//                     column(Profit_SubContractResource; SubContract_Resource."Profit %")
//                     {
//                     }
//                     column(PriceProfitCalculation_SubContractResource; SubContract_Resource."Price/Profit Calculation")
//                     {
//                     }
//                     column(UnitPrice_SubContractResource; SubContract_Resource."Unit Price")
//                     {
//                     }
//                     column(VendorNo_SubContractResource; SubContract_Resource."Vendor No.")
//                     {
//                     }
//                     column(LastDateModified_SubContractResource; SubContract_Resource."Last Date Modified")
//                     {
//                     }
//                     column(Comment_SubContractResource; SubContract_Resource.Comment)
//                     {
//                     }
//                     column(Blocked_SubContractResource; SubContract_Resource.Blocked)
//                     {
//                     }
//                     column(DateFilter_SubContractResource; SubContract_Resource."Date Filter")
//                     {
//                     }
//                     column(UnitofMeasureFilter_SubContractResource; SubContract_Resource."Unit of Measure Filter")
//                     {
//                     }
//                     column(Capacity_SubContractResource; SubContract_Resource.Capacity)
//                     {
//                     }
//                     column(QtyonOrderJob_SubContractResource; SubContract_Resource."Qty. on Order (Job)")
//                     {
//                     }
//                     column(QtyQuotedJob_SubContractResource; SubContract_Resource."Qty. Quoted (Job)")
//                     {
//                     }
//                     column(UsageQty_SubContractResource; SubContract_Resource."Usage (Qty.)")
//                     {
//                     }
//                     column(UsageCost_SubContractResource; SubContract_Resource."Usage (Cost)")
//                     {
//                     }
//                     column(UsagePrice_SubContractResource; SubContract_Resource."Usage (Price)")
//                     {
//                     }
//                     column(SalesQty_SubContractResource; SubContract_Resource."Sales (Qty.)")
//                     {
//                     }
//                     column(SalesCost_SubContractResource; SubContract_Resource."Sales (Cost)")
//                     {
//                     }
//                     column(SalesPrice_SubContractResource; SubContract_Resource."Sales (Price)")
//                     {
//                     }
//                     column(ChargeableFilter_SubContractResource; SubContract_Resource."Chargeable Filter")
//                     {
//                     }
//                     column(GenProdPostingGroup_SubContractResource; SubContract_Resource."Gen. Prod. Posting Group")
//                     {
//                     }
//                     column(Picture_SubContractResource; SubContract_Resource.Picture)
//                     {
//                     }
//                     column(PostCode_SubContractResource; SubContract_Resource."Post Code")
//                     {
//                     }
//                     column(County_SubContractResource; SubContract_Resource.County)
//                     {
//                     }
//                     column(AutomaticExtTexts_SubContractResource; SubContract_Resource."Automatic Ext. Texts")
//                     {
//                     }
//                     column(NoSeries_SubContractResource; SubContract_Resource."No. Series")
//                     {
//                     }
//                     column(TaxGroupCode_SubContractResource; SubContract_Resource."Tax Group Code")
//                     {
//                     }
//                     column(VATProdPostingGroup_SubContractResource; SubContract_Resource."VAT Prod. Posting Group")
//                     {
//                     }
//                     column(CountryRegionCode_SubContractResource; SubContract_Resource."Country/Region Code")
//                     {
//                     }
//                     column(ICPartnerPurchGLAccNo_SubContractResource; SubContract_Resource."IC Partner Purch. G/L Acc. No.")
//                     {
//                     }
//                     column(QtyonAssemblyOrder_SubContractResource; SubContract_Resource."Qty. on Assembly Order")
//                     {
//                     }
//                     column(UseTimeSheet_SubContractResource; SubContract_Resource."Use Time Sheet")
//                     {
//                     }
//                     column(TimeSheetOwnerUserID_SubContractResource; SubContract_Resource."Time Sheet Owner User ID")
//                     {
//                     }
//                     column(TimeSheetApproverUserID_SubContractResource; SubContract_Resource."Time Sheet Approver User ID")
//                     {
//                     }
//                     column(QtyonServiceOrder_SubContractResource; SubContract_Resource."Qty. on Service Order")
//                     {
//                     }
//                     column(ServiceZoneFilter_SubContractResource; SubContract_Resource."Service Zone Filter")
//                     {
//                     }
//                     column(InCustomerZone_SubContractResource; SubContract_Resource."In Customer Zone")
//                     {
//                     }
//                     column(JobCostCategory_SubContractResource; SubContract_Resource."NS_Job Cost Category")
//                     {
//                     }
//                     column(JobRevenueCategory_SubContractResource; SubContract_Resource."NS_Job Revenue Category")
//                     {
//                     }
//                 }

//                 trigger OnAfterGetRecord();
//                 begin
//                     OrginalSubContractAmt := 0;
//                     ContractPrior := 0;
//                     TotalPrevCO := 0;
//                     BTotalCost := 0;
//                     NewContractAmount := 0;

//                     if ParentSubContract.GET(Subcontract."NS_Sub-LeveltoSubcontractNo.") then begin
//                         ParentSubContract.CALCFIELDS("NS_Budgeted Cost (LCY)");
//                         OrginalSubContractAmt := ParentSubContract."NS_Budgeted Cost (LCY)";

//                         //Now loop through all the Children and get the Budget Cost

//                         ChildSubContract.RESET;
//                         ChildSubContract.SETRANGE("NS_Sub-LeveltoSubcontractNo.", ParentSubContract."NS_No.");
//                         ChildSubContract.SETRANGE(NS_Status, ChildSubContract.NS_Status::Order);
//                         ChildSubContract.SETFILTER("NS_No.", '<>%1', Subcontract."NS_No.");
//                         if ChildSubContract.FINDFIRST then begin
//                             repeat
//                                 ChildSubContract.CALCFIELDS("NS_Budgeted Cost (LCY)");
//                                 TotalPrevCO := TotalPrevCO + ChildSubContract."NS_Budgeted Cost (LCY)";
//                             until ChildSubContract.NEXT = 0;
//                         end;
//                     end;

//                     BTotalCost := OrginalSubContractAmt + TotalPrevCO;
//                     NewContractAmount := OrginalSubContractAmt + TotalPrevCO + Subcontract."NS_Budgeted Cost (LCY)";
//                 end;
//             }
//             dataitem("Job Task"; "Job Task")
//             {
//                 DataItemLink = "Job No." = FIELD("No.");
//                 column(JobNo_JobTask; "Job Task"."Job No.")
//                 {
//                 }
//                 column(JobTaskNo_JobTask; "Job Task"."Job Task No.")
//                 {
//                 }
//                 column(Description_JobTask; "Job Task".Description)
//                 {
//                 }
//                 column(JobTaskType_JobTask; "Job Task"."Job Task Type")
//                 {
//                 }
//                 column(WIPTotal_JobTask; "Job Task"."WIP-Total")
//                 {
//                 }
//                 column(JobPostingGroup_JobTask; "Job Task"."Job Posting Group")
//                 {
//                 }
//                 column(WIPMethod_JobTask; "Job Task"."WIP Method")
//                 {
//                 }
//                 column(ScheduleTotalCost_JobTask; "Job Task"."Schedule (Total Cost)")
//                 {
//                 }
//                 column(ScheduleTotalPrice_JobTask; "Job Task"."Schedule (Total Price)")
//                 {
//                 }
//                 column(UsageTotalCost_JobTask; "Job Task"."Usage (Total Cost)")
//                 {
//                 }
//                 column(UsageTotalPrice_JobTask; "Job Task"."Usage (Total Price)")
//                 {
//                 }
//                 column(ContractTotalCost_JobTask; "Job Task"."Contract (Total Cost)")
//                 {
//                 }
//                 column(ContractTotalPrice_JobTask; "Job Task"."Contract (Total Price)")
//                 {
//                 }
//                 column(ContractInvoicedPrice_JobTask; "Job Task"."Contract (Invoiced Price)")
//                 {
//                 }
//                 column(ContractInvoicedCost_JobTask; "Job Task"."Contract (Invoiced Cost)")
//                 {
//                 }
//                 column(PostingDateFilter_JobTask; "Job Task"."Posting Date Filter")
//                 {
//                 }
//                 column(PlanningDateFilter_JobTask; "Job Task"."Planning Date Filter")
//                 {
//                 }
//                 column(Totaling_JobTask; "Job Task".Totaling)
//                 {
//                 }
//                 column(NewPage_JobTask; "Job Task"."New Page")
//                 {
//                 }
//                 column(NoofBlankLines_JobTask; "Job Task"."No. of Blank Lines")
//                 {
//                 }
//                 column(Indentation_JobTask; "Job Task".Indentation)
//                 {
//                 }
//                 column(RecognizedSalesAmount_JobTask; "Job Task"."Recognized Sales Amount")
//                 {
//                 }
//                 column(RecognizedCostsAmount_JobTask; "Job Task"."Recognized Costs Amount")
//                 {
//                 }
//                 column(RecognizedSalesGLAmount_JobTask; "Job Task"."Recognized Sales G/L Amount")
//                 {
//                 }
//                 column(RecognizedCostsGLAmount_JobTask; "Job Task"."Recognized Costs G/L Amount")
//                 {
//                 }
//                 column(GlobalDimension1Code_JobTask; "Job Task"."Global Dimension 1 Code")
//                 {
//                 }
//                 column(GlobalDimension2Code_JobTask; "Job Task"."Global Dimension 2 Code")
//                 {
//                 }
//                 column(OutstandingOrders_JobTask; "Job Task"."Outstanding Orders")
//                 {
//                 }
//                 column(AmtRcdNotInvoiced_JobTask; "Job Task"."Amt. Rcd. Not Invoiced")
//                 {
//                 }
//                 column(RemainingTotalCost_JobTask; "Job Task"."Remaining (Total Cost)")
//                 {
//                 }
//                 column(RemainingTotalPrice_JobTask; "Job Task"."Remaining (Total Price)")
//                 {
//                 }
//                 column(StartDate_JobTask; "Job Task"."Start Date")
//                 {
//                 }
//                 column(EndDate_JobTask; "Job Task"."End Date")
//                 {
//                 }
//                 column(BurdenPercent_JobTask; "Job Task"."NS_Burden Percent")
//                 {
//                 }
//                 column(TotalPercentComplete_JobTask; "Job Task"."NS_Total Percent Complete")
//                 {
//                 }
//                 column(TotalPercentCompleteDate_JobTask; "Job Task"."NS_Total Percent Complete Date")
//                 {
//                 }
//                 column(BillingPercent_JobTask; "Job Task"."NS_Billing Percent")
//                 {
//                 }
//                 column(BillingPercentDate_JobTask; "Job Task"."NS_Billing Percent Date")
//                 {
//                 }
//                 column(TaskBefore_JobTask; "Job Task"."NS_Task Before")
//                 {
//                 }
//                 column(TaskAfter_JobTask; "Job Task"."NS_Task After")
//                 {
//                 }
//                 column(TaskStartDate_JobTask; "Job Task"."NS_Task Start Date")
//                 {
//                 }
//                 column(TaskEndDate_JobTask; "Job Task"."NS_Task End Date")
//                 {
//                 }
//                 column(TaskLagDays_JobTask; "Job Task"."NS_Task Lag Days")
//                 {
//                 }
//                 column(TaskDays_JobTask; "Job Task"."NS_Task Days")
//                 {
//                 }
//                 column(ResourceNo_JobTask; "Job Task"."NS_Resource No.")
//                 {
//                 }
//                 column(StartDateFixed_JobTask; "Job Task"."NS_Start Date Fixed")
//                 {
//                 }
//                 column(Manager_JobTask; "Job Task".NS_Manager)
//                 {
//                 }
//                 dataitem("Job Planning Line"; "Job Planning Line")
//                 {
//                     DataItemLink = "Job No." = FIELD("Job No."), "Job Task No." = FIELD("Job Task No.");
//                     column(LineNo_JobPlanningLine; "Job Planning Line"."Line No.")
//                     {
//                     }
//                     column(JobNo_JobPlanningLine; "Job Planning Line"."Job No.")
//                     {
//                     }
//                     column(PlanningDate_JobPlanningLine; "Job Planning Line"."Planning Date")
//                     {
//                     }
//                     column(DocumentNo_JobPlanningLine; "Job Planning Line"."Document No.")
//                     {
//                     }
//                     column(Type_JobPlanningLine; "Job Planning Line".Type)
//                     {
//                     }
//                     column(No_JobPlanningLine; "Job Planning Line"."No.")
//                     {
//                     }
//                     column(Description_JobPlanningLine; "Job Planning Line".Description)
//                     {
//                     }
//                     column(Quantity_JobPlanningLine; "Job Planning Line".Quantity)
//                     {
//                     }
//                     column(DirectUnitCostLCY_JobPlanningLine; "Job Planning Line"."Direct Unit Cost (LCY)")
//                     {
//                     }
//                     column(UnitCostLCY_JobPlanningLine; "Job Planning Line"."Unit Cost (LCY)")
//                     {
//                     }
//                     column(TotalCostLCY_JobPlanningLine; "Job Planning Line"."Total Cost (LCY)")
//                     {
//                     }
//                     column(UnitPriceLCY_JobPlanningLine; "Job Planning Line"."Unit Price (LCY)")
//                     {
//                     }
//                     column(TotalPriceLCY_JobPlanningLine; "Job Planning Line"."Total Price (LCY)")
//                     {
//                     }
//                     column(ResourceGroupNo_JobPlanningLine; "Job Planning Line"."Resource Group No.")
//                     {
//                     }
//                     column(UnitofMeasureCode_JobPlanningLine; "Job Planning Line"."Unit of Measure Code")
//                     {
//                     }
//                     column(LocationCode_JobPlanningLine; "Job Planning Line"."Location Code")
//                     {
//                     }
//                     column(LastDateModified_JobPlanningLine; "Job Planning Line"."Last Date Modified")
//                     {
//                     }
//                     column(UserID_JobPlanningLine; "Job Planning Line"."User ID")
//                     {
//                     }
//                     column(WorkTypeCode_JobPlanningLine; "Job Planning Line"."Work Type Code")
//                     {
//                     }
//                     column(CustomerPriceGroup_JobPlanningLine; "Job Planning Line"."Customer Price Group")
//                     {
//                     }
//                     column(CountryRegionCode_JobPlanningLine; "Job Planning Line"."Country/Region Code")
//                     {
//                     }
//                     column(GenBusPostingGroup_JobPlanningLine; "Job Planning Line"."Gen. Bus. Posting Group")
//                     {
//                     }
//                     column(GenProdPostingGroup_JobPlanningLine; "Job Planning Line"."Gen. Prod. Posting Group")
//                     {
//                     }
//                     column(DocumentDate_JobPlanningLine; "Job Planning Line"."Document Date")
//                     {
//                     }
//                     column(JobTaskNo_JobPlanningLine; "Job Planning Line"."Job Task No.")
//                     {
//                     }
//                     column(LineAmountLCY_JobPlanningLine; "Job Planning Line"."Line Amount (LCY)")
//                     {
//                     }
//                     column(UnitCost_JobPlanningLine; "Job Planning Line"."Unit Cost")
//                     {
//                     }
//                     column(TotalCost_JobPlanningLine; "Job Planning Line"."Total Cost")
//                     {
//                     }
//                     column(UnitPrice_JobPlanningLine; "Job Planning Line"."Unit Price")
//                     {
//                     }
//                     column(TotalPrice_JobPlanningLine; "Job Planning Line"."Total Price")
//                     {
//                     }
//                     column(LineAmount_JobPlanningLine; "Job Planning Line"."Line Amount")
//                     {
//                     }
//                     column(LineDiscountAmount_JobPlanningLine; "Job Planning Line"."Line Discount Amount")
//                     {
//                     }
//                     column(LineDiscountAmountLCY_JobPlanningLine; "Job Planning Line"."Line Discount Amount (LCY)")
//                     {
//                     }
//                     column(CostFactor_JobPlanningLine; "Job Planning Line"."Cost Factor")
//                     {
//                     }
//                     column(SerialNo_JobPlanningLine; "Job Planning Line"."Serial No.")
//                     {
//                     }
//                     column(LotNo_JobPlanningLine; "Job Planning Line"."Lot No.")
//                     {
//                     }
//                     column(LineDiscount_JobPlanningLine; "Job Planning Line"."Line Discount %")
//                     {
//                     }
//                     column(LineType_JobPlanningLine; "Job Planning Line"."Line Type")
//                     {
//                     }
//                     column(CurrencyCode_JobPlanningLine; "Job Planning Line"."Currency Code")
//                     {
//                     }
//                     column(CurrencyDate_JobPlanningLine; "Job Planning Line"."Currency Date")
//                     {
//                     }
//                     column(CurrencyFactor_JobPlanningLine; "Job Planning Line"."Currency Factor")
//                     {
//                     }
//                     column(ScheduleLine_JobPlanningLine; "Job Planning Line"."Schedule Line")
//                     {
//                     }
//                     column(ContractLine_JobPlanningLine; "Job Planning Line"."Contract Line")
//                     {
//                     }
//                     column(JobContractEntryNo_JobPlanningLine; "Job Planning Line"."Job Contract Entry No.")
//                     {
//                     }
//                     column(InvoicedAmountLCY_JobPlanningLine; "Job Planning Line"."Invoiced Amount (LCY)")
//                     {
//                     }
//                     column(InvoicedCostAmountLCY_JobPlanningLine; "Job Planning Line"."Invoiced Cost Amount (LCY)")
//                     {
//                     }
//                     column(VATUnitPrice_JobPlanningLine; "Job Planning Line"."VAT Unit Price")
//                     {
//                     }
//                     column(VATLineDiscountAmount_JobPlanningLine; "Job Planning Line"."VAT Line Discount Amount")
//                     {
//                     }
//                     column(VATLineAmount_JobPlanningLine; "Job Planning Line"."VAT Line Amount")
//                     {
//                     }
//                     column(VAT_JobPlanningLine; "Job Planning Line"."VAT %")
//                     {
//                     }
//                     column(Description2_JobPlanningLine; "Job Planning Line"."Description 2")
//                     {
//                     }
//                     column(JobLedgerEntryNo_JobPlanningLine; "Job Planning Line"."Job Ledger Entry No.")
//                     {
//                     }
//                     column(Status_JobPlanningLine; "Job Planning Line".Status)
//                     {
//                     }
//                     column(LedgerEntryType_JobPlanningLine; "Job Planning Line"."Ledger Entry Type")
//                     {
//                     }
//                     column(LedgerEntryNo_JobPlanningLine; "Job Planning Line"."Ledger Entry No.")
//                     {
//                     }
//                     column(SystemCreatedEntry_JobPlanningLine; "Job Planning Line"."System-Created Entry")
//                     {
//                     }
//                     column(UsageLink_JobPlanningLine; "Job Planning Line"."Usage Link")
//                     {
//                     }
//                     column(RemainingQty_JobPlanningLine; "Job Planning Line"."Remaining Qty.")
//                     {
//                     }
//                     column(RemainingQtyBase_JobPlanningLine; "Job Planning Line"."Remaining Qty. (Base)")
//                     {
//                     }
//                     column(RemainingTotalCost_JobPlanningLine; "Job Planning Line"."Remaining Total Cost")
//                     {
//                     }
//                     column(RemainingTotalCostLCY_JobPlanningLine; "Job Planning Line"."Remaining Total Cost (LCY)")
//                     {
//                     }
//                     column(RemainingLineAmount_JobPlanningLine; "Job Planning Line"."Remaining Line Amount")
//                     {
//                     }
//                     column(RemainingLineAmountLCY_JobPlanningLine; "Job Planning Line"."Remaining Line Amount (LCY)")
//                     {
//                     }
//                     column(QtyPosted_JobPlanningLine; "Job Planning Line"."Qty. Posted")
//                     {
//                     }
//                     column(QtytoTransfertoJournal_JobPlanningLine; "Job Planning Line"."Qty. to Transfer to Journal")
//                     {
//                     }
//                     column(PostedTotalCost_JobPlanningLine; "Job Planning Line"."Posted Total Cost")
//                     {
//                     }
//                     column(PostedTotalCostLCY_JobPlanningLine; "Job Planning Line"."Posted Total Cost (LCY)")
//                     {
//                     }
//                     column(PostedLineAmount_JobPlanningLine; "Job Planning Line"."Posted Line Amount")
//                     {
//                     }
//                     column(PostedLineAmountLCY_JobPlanningLine; "Job Planning Line"."Posted Line Amount (LCY)")
//                     {
//                     }
//                     column(QtyTransferredtoInvoice_JobPlanningLine; "Job Planning Line"."Qty. Transferred to Invoice")
//                     {
//                     }
//                     column(QtytoTransfertoInvoice_JobPlanningLine; "Job Planning Line"."Qty. to Transfer to Invoice")
//                     {
//                     }
//                     column(QtyInvoiced_JobPlanningLine; "Job Planning Line"."Qty. Invoiced")
//                     {
//                     }
//                     column(QtytoInvoice_JobPlanningLine; "Job Planning Line"."Qty. to Invoice")
//                     {
//                     }
//                     column(ReservedQuantity_JobPlanningLine; "Job Planning Line"."Reserved Quantity")
//                     {
//                     }
//                     column(ReservedQtyBase_JobPlanningLine; "Job Planning Line"."Reserved Qty. (Base)")
//                     {
//                     }
//                     column(Reserve_JobPlanningLine; "Job Planning Line".Reserve)
//                     {
//                     }
//                     column(Planned_JobPlanningLine; "Job Planning Line".Planned)
//                     {
//                     }
//                     column(VariantCode_JobPlanningLine; "Job Planning Line"."Variant Code")
//                     {
//                     }
//                     column(BinCode_JobPlanningLine; "Job Planning Line"."Bin Code")
//                     {
//                     }
//                     column(QtyperUnitofMeasure_JobPlanningLine; "Job Planning Line"."Qty. per Unit of Measure")
//                     {
//                     }
//                     column(QuantityBase_JobPlanningLine; "Job Planning Line"."Quantity (Base)")
//                     {
//                     }
//                     column(RequestedDeliveryDate_JobPlanningLine; "Job Planning Line"."Requested Delivery Date")
//                     {
//                     }
//                     column(PromisedDeliveryDate_JobPlanningLine; "Job Planning Line"."Promised Delivery Date")
//                     {
//                     }
//                     column(PlannedDeliveryDate_JobPlanningLine; "Job Planning Line"."Planned Delivery Date")
//                     {
//                     }
//                     column(ServiceOrderNo_JobPlanningLine; "Job Planning Line"."Service Order No.")
//                     {
//                     }
//                     column(CostCategory_JobPlanningLine; "Job Planning Line"."NS_Cost Category")
//                     {
//                     }
//                     column(RevenueCategory_JobPlanningLine; "Job Planning Line"."NS_Revenue Category")
//                     {
//                     }
//                     column(ShortcutDimension1Code_JobPlanningLine; "Job Planning Line"."NS_Shortcut Dimension 1 Code")
//                     {
//                     }
//                     column(ShortcutDimension2Code_JobPlanningLine; "Job Planning Line"."NS_Shortcut Dimension 2 Code")
//                     {
//                     }
//                     column(ActivityCode_JobPlanningLine; "Job Planning Line"."NS_Activity Code")
//                     {
//                     }
//                     column(ProcessCode_JobPlanningLine; "Job Planning Line"."NS_Process Code")
//                     {
//                     }
//                     column(OperationCode_JobPlanningLine; "Job Planning Line"."NS_Operation Code")
//                     {
//                     }
//                     column(WorkUnits_JobPlanningLine; "Job Planning Line"."NS_Work Units")
//                     {
//                     }
//                     column(WorkUnitofMeasure_JobPlanningLine; "Job Planning Line"."NS_Work Unit of Measure")
//                     {
//                     }
//                     column(SkillClass_JobPlanningLine; "Job Planning Line"."NS_Skill Class")
//                     {
//                     }
//                     column(EntryType_JobPlanningLine; "Job Planning Line"."NS_Entry Type")
//                     {
//                     }
//                     column(Adjustment_JobPlanningLine; "Job Planning Line".NS_Adjustment)
//                     {
//                     }
//                     column(RateType_JobPlanningLine; "Job Planning Line"."NS_Rate Type")
//                     {
//                     }
//                     column(RateTypeValue_JobPlanningLine; "Job Planning Line"."NS_Rate Type Value")
//                     {
//                     }
//                     column(NotToExceed_JobPlanningLine; "Job Planning Line"."NS_Not To Exceed")
//                     {
//                     }
//                     column(SubcontractNo_JobPlanningLine; "Job Planning Line"."NS_Subcontract No.")
//                     {
//                     }
//                     column(SubcontractLineNo_JobPlanningLine; "Job Planning Line"."NS_Subcontract Line No.")
//                     {
//                     }
//                     column(ProgressBillingMethod_JobPlanningLine; "Job Planning Line"."NS_Progress Billing Method")
//                     {
//                     }
//                     column(TempNo_JobPlanningLine; "Job Planning Line".NS_TempNo)
//                     {
//                     }
//                     column(TempLocation_JobPlanningLine; "Job Planning Line".NS_TempLocation)
//                     {
//                     }
//                     column(TempVariant_JobPlanningLine; "Job Planning Line".NS_TempVariant)
//                     {
//                     }
//                     column(TempUM_JobPlanningLine; "Job Planning Line".NS_TempUM)
//                     {
//                     }
//                     column(TempWorkType_JobPlanningLine; "Job Planning Line".NS_TempWorkType)
//                     {
//                     }
//                     column(DimensionSetID_JobPlanningLine; "Job Planning Line"."NS_Dimension Set ID")
//                     {
//                     }
//                     column(RetentionLedgerCode_JobPlanningLine; "Job Planning Line"."NS_Retention Ledger Code")
//                     {
//                     }
//                     dataitem(Resource; Resource)
//                     {
//                         DataItemLink = "No." = FIELD("No.");
//                         column(No_Resource; Resource."No.")
//                         {
//                         }
//                         column(Type_Resource; Resource.Type)
//                         {
//                         }
//                         column(Name_Resource; Resource.Name)
//                         {
//                         }
//                         column(SearchName_Resource; Resource."Search Name")
//                         {
//                         }
//                         column(Name2_Resource; Resource."Name 2")
//                         {
//                         }
//                         column(Address_Resource; Resource.Address)
//                         {
//                         }
//                         column(Address2_Resource; Resource."Address 2")
//                         {
//                         }
//                         column(City_Resource; Resource.City)
//                         {
//                         }
//                         column(SocialSecurityNo_Resource; Resource."Social Security No.")
//                         {
//                         }
//                         column(JobTitle_Resource; Resource."Job Title")
//                         {
//                         }
//                         column(Education_Resource; Resource.Education)
//                         {
//                         }
//                         column(ContractClass_Resource; Resource."Contract Class")
//                         {
//                         }
//                         column(EmploymentDate_Resource; Resource."Employment Date")
//                         {
//                         }
//                         column(ResourceGroupNo_Resource; Resource."Resource Group No.")
//                         {
//                         }
//                         column(GlobalDimension1Code_Resource; Resource."Global Dimension 1 Code")
//                         {
//                         }
//                         column(GlobalDimension2Code_Resource; Resource."Global Dimension 2 Code")
//                         {
//                         }
//                         column(BaseUnitofMeasure_Resource; Resource."Base Unit of Measure")
//                         {
//                         }
//                         column(DirectUnitCost_Resource; Resource."Direct Unit Cost")
//                         {
//                         }
//                         column(IndirectCost_Resource; Resource."Indirect Cost %")
//                         {
//                         }
//                         column(UnitCost_Resource; Resource."Unit Cost")
//                         {
//                         }
//                         column(Profit_Resource; Resource."Profit %")
//                         {
//                         }
//                         column(PriceProfitCalculation_Resource; Resource."Price/Profit Calculation")
//                         {
//                         }
//                         column(UnitPrice_Resource; Resource."Unit Price")
//                         {
//                         }
//                         column(VendorNo_Resource; Resource."Vendor No.")
//                         {
//                         }
//                         column(LastDateModified_Resource; Resource."Last Date Modified")
//                         {
//                         }
//                         column(Comment_Resource; Resource.Comment)
//                         {
//                         }
//                         column(Blocked_Resource; Resource.Blocked)
//                         {
//                         }
//                         column(DateFilter_Resource; Resource."Date Filter")
//                         {
//                         }
//                         column(UnitofMeasureFilter_Resource; Resource."Unit of Measure Filter")
//                         {
//                         }
//                         column(Capacity_Resource; Resource.Capacity)
//                         {
//                         }
//                         column(QtyonOrderJob_Resource; Resource."Qty. on Order (Job)")
//                         {
//                         }
//                         column(QtyQuotedJob_Resource; Resource."Qty. Quoted (Job)")
//                         {
//                         }
//                         column(UsageQty_Resource; Resource."Usage (Qty.)")
//                         {
//                         }
//                         column(UsageCost_Resource; Resource."Usage (Cost)")
//                         {
//                         }
//                         column(UsagePrice_Resource; Resource."Usage (Price)")
//                         {
//                         }
//                         column(SalesQty_Resource; Resource."Sales (Qty.)")
//                         {
//                         }
//                         column(SalesCost_Resource; Resource."Sales (Cost)")
//                         {
//                         }
//                         column(SalesPrice_Resource; Resource."Sales (Price)")
//                         {
//                         }
//                         column(ChargeableFilter_Resource; Resource."Chargeable Filter")
//                         {
//                         }
//                         column(GenProdPostingGroup_Resource; Resource."Gen. Prod. Posting Group")
//                         {
//                         }
//                         column(Picture_Resource; Resource.Picture)
//                         {
//                         }
//                         column(PostCode_Resource; Resource."Post Code")
//                         {
//                         }
//                         column(County_Resource; Resource.County)
//                         {
//                         }
//                         column(AutomaticExtTexts_Resource; Resource."Automatic Ext. Texts")
//                         {
//                         }
//                         column(NoSeries_Resource; Resource."No. Series")
//                         {
//                         }
//                         column(TaxGroupCode_Resource; Resource."Tax Group Code")
//                         {
//                         }
//                         column(VATProdPostingGroup_Resource; Resource."VAT Prod. Posting Group")
//                         {
//                         }
//                         column(CountryRegionCode_Resource; Resource."Country/Region Code")
//                         {
//                         }
//                         column(ICPartnerPurchGLAccNo_Resource; Resource."IC Partner Purch. G/L Acc. No.")
//                         {
//                         }
//                         column(QtyonAssemblyOrder_Resource; Resource."Qty. on Assembly Order")
//                         {
//                         }
//                         column(UseTimeSheet_Resource; Resource."Use Time Sheet")
//                         {
//                         }
//                         column(TimeSheetOwnerUserID_Resource; Resource."Time Sheet Owner User ID")
//                         {
//                         }
//                         column(TimeSheetApproverUserID_Resource; Resource."Time Sheet Approver User ID")
//                         {
//                         }
//                         column(QtyonServiceOrder_Resource; Resource."Qty. on Service Order")
//                         {
//                         }
//                         column(ServiceZoneFilter_Resource; Resource."Service Zone Filter")
//                         {
//                         }
//                         column(InCustomerZone_Resource; Resource."In Customer Zone")
//                         {
//                         }
//                         column(JobCostCategory_Resource; Resource."NS_Job Cost Category")
//                         {
//                         }
//                         column(JobRevenueCategory_Resource; Resource."NS_Job Revenue Category")
//                         {
//                         }
//                     }
//                     dataitem(Item; Item)
//                     {
//                         DataItemLink = "No." = FIELD("No.");
//                         column(No_Item; Item."No.")
//                         {
//                         }
//                         column(No2_Item; Item."No. 2")
//                         {
//                         }
//                         column(Description_Item; Item.Description)
//                         {
//                         }
//                         column(SearchDescription_Item; Item."Search Description")
//                         {
//                         }
//                         column(Description2_Item; Item."Description 2")
//                         {
//                         }
//                         column(AssemblyBOM_Item; Item."Assembly BOM")
//                         {
//                         }
//                         column(BaseUnitofMeasure_Item; Item."Base Unit of Measure")
//                         {
//                         }
//                         column(PriceUnitConversion_Item; Item."Price Unit Conversion")
//                         {
//                         }
//                         column(Type_Item; Item.Type)
//                         {
//                         }
//                         column(InventoryPostingGroup_Item; Item."Inventory Posting Group")
//                         {
//                         }
//                         column(ShelfNo_Item; Item."Shelf No.")
//                         {
//                         }
//                         column(ItemDiscGroup_Item; Item."Item Disc. Group")
//                         {
//                         }
//                         column(AllowInvoiceDisc_Item; Item."Allow Invoice Disc.")
//                         {
//                         }
//                         column(StatisticsGroup_Item; Item."Statistics Group")
//                         {
//                         }
//                         column(CommissionGroup_Item; Item."Commission Group")
//                         {
//                         }
//                         column(UnitPrice_Item; Item."Unit Price")
//                         {
//                         }
//                         column(PriceProfitCalculation_Item; Item."Price/Profit Calculation")
//                         {
//                         }
//                         column(Profit_Item; Item."Profit %")
//                         {
//                         }
//                         column(CostingMethod_Item; Item."Costing Method")
//                         {
//                         }
//                         column(UnitCost_Item; Item."Unit Cost")
//                         {
//                         }
//                         column(StandardCost_Item; Item."Standard Cost")
//                         {
//                         }
//                         column(LastDirectCost_Item; Item."Last Direct Cost")
//                         {
//                         }
//                         column(IndirectCost_Item; Item."Indirect Cost %")
//                         {
//                         }
//                         column(CostisAdjusted_Item; Item."Cost is Adjusted")
//                         {
//                         }
//                         column(AllowOnlineAdjustment_Item; Item."Allow Online Adjustment")
//                         {
//                         }
//                         column(VendorNo_Item; Item."Vendor No.")
//                         {
//                         }
//                         column(VendorItemNo_Item; Item."Vendor Item No.")
//                         {
//                         }
//                         column(LeadTimeCalculation_Item; Item."Lead Time Calculation")
//                         {
//                         }
//                         column(ReorderPoint_Item; Item."Reorder Point")
//                         {
//                         }
//                         column(MaximumInventory_Item; Item."Maximum Inventory")
//                         {
//                         }
//                         column(ReorderQuantity_Item; Item."Reorder Quantity")
//                         {
//                         }
//                         column(AlternativeItemNo_Item; Item."Alternative Item No.")
//                         {
//                         }
//                         column(UnitListPrice_Item; Item."Unit List Price")
//                         {
//                         }
//                         column(DutyDue_Item; Item."Duty Due %")
//                         {
//                         }
//                         column(DutyCode_Item; Item."Duty Code")
//                         {
//                         }
//                         column(GrossWeight_Item; Item."Gross Weight")
//                         {
//                         }
//                         column(NetWeight_Item; Item."Net Weight")
//                         {
//                         }
//                         column(UnitsperParcel_Item; Item."Units per Parcel")
//                         {
//                         }
//                         column(UnitVolume_Item; Item."Unit Volume")
//                         {
//                         }
//                         column(Durability_Item; Item.Durability)
//                         {
//                         }
//                         column(FreightType_Item; Item."Freight Type")
//                         {
//                         }
//                         column(TariffNo_Item; Item."Tariff No.")
//                         {
//                         }
//                         column(DutyUnitConversion_Item; Item."Duty Unit Conversion")
//                         {
//                         }
//                         column(CountryRegionPurchasedCode_Item; Item."Country/Region Purchased Code")
//                         {
//                         }
//                         column(BudgetQuantity_Item; Item."Budget Quantity")
//                         {
//                         }
//                         column(BudgetedAmount_Item; Item."Budgeted Amount")
//                         {
//                         }
//                         column(BudgetProfit_Item; Item."Budget Profit")
//                         {
//                         }
//                         column(Comment_Item; Item.Comment)
//                         {
//                         }
//                         column(Blocked_Item; Item.Blocked)
//                         {
//                         }
//                         column(CostisPostedtoGL_Item; Item."Cost is Posted to G/L")
//                         {
//                         }
//                         column(LastDateModified_Item; Item."Last Date Modified")
//                         {
//                         }
//                         column(DateFilter_Item; Item."Date Filter")
//                         {
//                         }
//                         column(GlobalDimension1Filter_Item; Item."Global Dimension 1 Filter")
//                         {
//                         }
//                         column(GlobalDimension2Filter_Item; Item."Global Dimension 2 Filter")
//                         {
//                         }
//                         column(LocationFilter_Item; Item."Location Filter")
//                         {
//                         }
//                         column(Inventory_Item; Item.Inventory)
//                         {
//                         }
//                         column(NetInvoicedQty_Item; Item."Net Invoiced Qty.")
//                         {
//                         }
//                         column(NetChange_Item; Item."Net Change")
//                         {
//                         }
//                         column(PurchasesQty_Item; Item."Purchases (Qty.)")
//                         {
//                         }
//                         column(SalesQty_Item; Item."Sales (Qty.)")
//                         {
//                         }
//                         column(PositiveAdjmtQty_Item; Item."Positive Adjmt. (Qty.)")
//                         {
//                         }
//                         column(NegativeAdjmtQty_Item; Item."Negative Adjmt. (Qty.)")
//                         {
//                         }
//                         column(PurchasesLCY_Item; Item."Purchases (LCY)")
//                         {
//                         }
//                         column(SalesLCY_Item; Item."Sales (LCY)")
//                         {
//                         }
//                         column(PositiveAdjmtLCY_Item; Item."Positive Adjmt. (LCY)")
//                         {
//                         }
//                         column(NegativeAdjmtLCY_Item; Item."Negative Adjmt. (LCY)")
//                         {
//                         }
//                         column(COGSLCY_Item; Item."COGS (LCY)")
//                         {
//                         }
//                         column(QtyonPurchOrder_Item; Item."Qty. on Purch. Order")
//                         {
//                         }
//                         column(QtyonSalesOrder_Item; Item."Qty. on Sales Order")
//                         {
//                         }
//                         column(PriceIncludesVAT_Item; Item."Price Includes VAT")
//                         {
//                         }
//                         column(DropShipmentFilter_Item; Item."Drop Shipment Filter")
//                         {
//                         }
//                         column(VATBusPostingGrPrice_Item; Item."VAT Bus. Posting Gr. (Price)")
//                         {
//                         }
//                         column(GenProdPostingGroup_Item; Item."Gen. Prod. Posting Group")
//                         {
//                         }
//                         column(Picture_Item; Item.Picture)
//                         {
//                         }
//                         column(TransferredQty_Item; Item."Transferred (Qty.)")
//                         {
//                         }
//                         column(TransferredLCY_Item; Item."Transferred (LCY)")
//                         {
//                         }
//                         column(CountryRegionofOriginCode_Item; Item."Country/Region of Origin Code")
//                         {
//                         }
//                         column(AutomaticExtTexts_Item; Item."Automatic Ext. Texts")
//                         {
//                         }
//                         column(NoSeries_Item; Item."No. Series")
//                         {
//                         }
//                         column(TaxGroupCode_Item; Item."Tax Group Code")
//                         {
//                         }
//                         column(VATProdPostingGroup_Item; Item."VAT Prod. Posting Group")
//                         {
//                         }
//                         column(Reserve_Item; Item.Reserve)
//                         {
//                         }
//                         column(ReservedQtyonInventory_Item; Item."Reserved Qty. on Inventory")
//                         {
//                         }
//                         column(ReservedQtyonPurchOrders_Item; Item."Reserved Qty. on Purch. Orders")
//                         {
//                         }
//                         column(ReservedQtyonSalesOrders_Item; Item."Reserved Qty. on Sales Orders")
//                         {
//                         }
//                         column(GlobalDimension1Code_Item; Item."Global Dimension 1 Code")
//                         {
//                         }
//                         column(GlobalDimension2Code_Item; Item."Global Dimension 2 Code")
//                         {
//                         }
//                         column(ResQtyonOutboundTransfer_Item; Item."Res. Qty. on Outbound Transfer")
//                         {
//                         }
//                         column(ResQtyonInboundTransfer_Item; Item."Res. Qty. on Inbound Transfer")
//                         {
//                         }
//                         column(ResQtyonSalesReturns_Item; Item."Res. Qty. on Sales Returns")
//                         {
//                         }
//                         column(ResQtyonPurchReturns_Item; Item."Res. Qty. on Purch. Returns")
//                         {
//                         }
//                         column(StockoutWarning_Item; Item."Stockout Warning")
//                         {
//                         }
//                         column(PreventNegativeInventory_Item; Item."Prevent Negative Inventory")
//                         {
//                         }
//                         column(CostofOpenProductionOrders_Item; Item."Cost of Open Production Orders")
//                         {
//                         }
//                         column(ApplicationWkshUserID_Item; Item."Application Wksh. User ID")
//                         {
//                         }
//                         column(AssemblyPolicy_Item; Item."Assembly Policy")
//                         {
//                         }
//                         column(ResQtyonAssemblyOrder_Item; Item."Res. Qty. on Assembly Order")
//                         {
//                         }
//                         column(ResQtyonAsmComp_Item; Item."Res. Qty. on  Asm. Comp.")
//                         {
//                         }
//                         column(QtyonAssemblyOrder_Item; Item."Qty. on Assembly Order")
//                         {
//                         }
//                         column(QtyonAsmComponent_Item; Item."Qty. on Asm. Component")
//                         {
//                         }
//                         column(QtyonJobOrder_Item; Item."Qty. on Job Order")
//                         {
//                         }
//                         column(ResQtyonJobOrder_Item; Item."Res. Qty. on Job Order")
//                         {
//                         }
//                         column(LowLevelCode_Item; Item."Low-Level Code")
//                         {
//                         }
//                         column(LotSize_Item; Item."Lot Size")
//                         {
//                         }
//                         column(SerialNos_Item; Item."Serial Nos.")
//                         {
//                         }
//                         column(LastUnitCostCalcDate_Item; Item."Last Unit Cost Calc. Date")
//                         {
//                         }
//                         column(RolledupMaterialCost_Item; Item."Rolled-up Material Cost")
//                         {
//                         }
//                         column(RolledupCapacityCost_Item; Item."Rolled-up Capacity Cost")
//                         {
//                         }
//                         column(Scrap_Item; Item."Scrap %")
//                         {
//                         }
//                         column(InventoryValueZero_Item; Item."Inventory Value Zero")
//                         {
//                         }
//                         column(DiscreteOrderQuantity_Item; Item."Discrete Order Quantity")
//                         {
//                         }
//                         column(MinimumOrderQuantity_Item; Item."Minimum Order Quantity")
//                         {
//                         }
//                         column(MaximumOrderQuantity_Item; Item."Maximum Order Quantity")
//                         {
//                         }
//                         column(SafetyStockQuantity_Item; Item."Safety Stock Quantity")
//                         {
//                         }
//                         column(OrderMultiple_Item; Item."Order Multiple")
//                         {
//                         }
//                         column(SafetyLeadTime_Item; Item."Safety Lead Time")
//                         {
//                         }
//                         column(FlushingMethod_Item; Item."Flushing Method")
//                         {
//                         }
//                         column(ReplenishmentSystem_Item; Item."Replenishment System")
//                         {
//                         }
//                         column(ScheduledReceiptQty_Item; Item."Scheduled Receipt (Qty.)")
//                         {
//                         }
//                         column(ScheduledNeedQty_Item; Item."Scheduled Need (Qty.)")
//                         {
//                         }
//                         column(RoundingPrecision_Item; Item."Rounding Precision")
//                         {
//                         }
//                         column(BinFilter_Item; Item."Bin Filter")
//                         {
//                         }
//                         column(VariantFilter_Item; Item."Variant Filter")
//                         {
//                         }
//                         column(SalesUnitofMeasure_Item; Item."Sales Unit of Measure")
//                         {
//                         }
//                         column(PurchUnitofMeasure_Item; Item."Purch. Unit of Measure")
//                         {
//                         }
//                         column(TimeBucket_Item; Item."Time Bucket")
//                         {
//                         }
//                         column(ReservedQtyonProdOrder_Item; Item."Reserved Qty. on Prod. Order")
//                         {
//                         }
//                         column(ResQtyonProdOrderComp_Item; Item."Res. Qty. on Prod. Order Comp.")
//                         {
//                         }
//                         column(ResQtyonReqLine_Item; Item."Res. Qty. on Req. Line")
//                         {
//                         }
//                         column(ReorderingPolicy_Item; Item."Reordering Policy")
//                         {
//                         }
//                         column(IncludeInventory_Item; Item."Include Inventory")
//                         {
//                         }
//                         column(ManufacturingPolicy_Item; Item."Manufacturing Policy")
//                         {
//                         }
//                         column(ReschedulingPeriod_Item; Item."Rescheduling Period")
//                         {
//                         }
//                         column(LotAccumulationPeriod_Item; Item."Lot Accumulation Period")
//                         {
//                         }
//                         column(DampenerPeriod_Item; Item."Dampener Period")
//                         {
//                         }
//                         column(DampenerQuantity_Item; Item."Dampener Quantity")
//                         {
//                         }
//                         column(OverflowLevel_Item; Item."Overflow Level")
//                         {
//                         }
//                         column(PlanningTransferShipQty_Item; Item."Planning Transfer Ship. (Qty).")
//                         {
//                         }
//                         column(PlanningWorksheetQty_Item; Item."Planning Worksheet (Qty.)")
//                         {
//                         }
//                         column(StockkeepingUnitExists_Item; Item."Stockkeeping Unit Exists")
//                         {
//                         }
//                         column(ManufacturerCode_Item; Item."Manufacturer Code")
//                         {
//                         }
//                         column(ItemCategoryCode_Item; Item."Item Category Code")
//                         {
//                         }
//                         column(CreatedFromNonstockItem_Item; Item."Created From Nonstock Item")
//                         {
//                         }
//                         //SPLN Start: Obsolete field
//                         //column(ProductGroupCode_Item;Item."Product Group Code")
//                         //{
//                         //}
//                         //SPLN End
//                         column(SubstitutesExist_Item; Item."Substitutes Exist")
//                         {
//                         }
//                         column(QtyinTransit_Item; Item."Qty. in Transit")
//                         {
//                         }
//                         column(TransOrdReceiptQty_Item; Item."Trans. Ord. Receipt (Qty.)")
//                         {
//                         }
//                         column(TransOrdShipmentQty_Item; Item."Trans. Ord. Shipment (Qty.)")
//                         {
//                         }
//                         column(QtyAssignedtoship_Item; Item."Qty. Assigned to ship")
//                         {
//                         }
//                         column(QtyPicked_Item; Item."Qty. Picked")
//                         {
//                         }
//                         column(ServiceItemGroup_Item; Item."Service Item Group")
//                         {
//                         }
//                         column(QtyonServiceOrder_Item; Item."Qty. on Service Order")
//                         {
//                         }
//                         column(ResQtyonServiceOrders_Item; Item."Res. Qty. on Service Orders")
//                         {
//                         }
//                         column(ItemTrackingCode_Item; Item."Item Tracking Code")
//                         {
//                         }
//                         column(LotNos_Item; Item."Lot Nos.")
//                         {
//                         }
//                         column(ExpirationCalculation_Item; Item."Expiration Calculation")
//                         {
//                         }
//                         column(LotNoFilter_Item; Item."Lot No. Filter")
//                         {
//                         }
//                         column(SerialNoFilter_Item; Item."Serial No. Filter")
//                         {
//                         }
//                         column(QtyonPurchReturn_Item; Item."Qty. on Purch. Return")
//                         {
//                         }
//                         column(QtyonSalesReturn_Item; Item."Qty. on Sales Return")
//                         {
//                         }
//                         column(NoofSubstitutes_Item; Item."No. of Substitutes")
//                         {
//                         }
//                         column(SpecialEquipmentCode_Item; Item."Special Equipment Code")
//                         {
//                         }
//                         column(PutawayTemplateCode_Item; Item."Put-away Template Code")
//                         {
//                         }
//                         column(PutawayUnitofMeasureCode_Item; Item."Put-away Unit of Measure Code")
//                         {
//                         }
//                         column(PhysInvtCountingPeriodCode_Item; Item."Phys Invt Counting Period Code")
//                         {
//                         }
//                         column(LastCountingPeriodUpdate_Item; Item."Last Counting Period Update")
//                         {
//                         }
//                         column(LastPhysInvtDate_Item; Item."Last Phys. Invt. Date")
//                         {
//                         }
//                         column(UseCrossDocking_Item; Item."Use Cross-Docking")
//                         {
//                         }
//                         column(NextCountingStartDate_Item; Item."Next Counting Start Date")
//                         {
//                         }
//                         column(NextCountingEndDate_Item; Item."Next Counting End Date")
//                         {
//                         }
//                         column(IdentifierCode_Item; Item."Identifier Code")
//                         {
//                         }
//                         column(DutyClass_Item; Item."Duty Class")
//                         {
//                         }
//                         column(ConsumptionsQty_Item; Item."Consumptions (Qty.)")
//                         {
//                         }
//                         column(OutputsQty_Item; Item."Outputs (Qty.)")
//                         {
//                         }
//                         column(RelScheduledReceiptQty_Item; Item."Rel. Scheduled Receipt (Qty.)")
//                         {
//                         }
//                         column(RelScheduledNeedQty_Item; Item."Rel. Scheduled Need (Qty.)")
//                         {
//                         }
//                         column(JobCostCategory_Item; Item."NS_Job Cost Category")
//                         {
//                         }
//                         column(RoutingNo_Item; Item."Routing No.")
//                         {
//                         }
//                         column(ProductionBOMNo_Item; Item."Production BOM No.")
//                         {
//                         }
//                         column(SingleLevelMaterialCost_Item; Item."Single-Level Material Cost")
//                         {
//                         }
//                         column(SingleLevelCapacityCost_Item; Item."Single-Level Capacity Cost")
//                         {
//                         }
//                         column(SingleLevelSubcontrdCost_Item; Item."Single-Level Subcontrd. Cost")
//                         {
//                         }
//                         column(SingleLevelCapOvhdCost_Item; Item."Single-Level Cap. Ovhd Cost")
//                         {
//                         }
//                         column(SingleLevelMfgOvhdCost_Item; Item."Single-Level Mfg. Ovhd Cost")
//                         {
//                         }
//                         column(OverheadRate_Item; Item."Overhead Rate")
//                         {
//                         }
//                         column(RolledupSubcontractedCost_Item; Item."Rolled-up Subcontracted Cost")
//                         {
//                         }
//                         column(RolledupMfgOvhdCost_Item; Item."Rolled-up Mfg. Ovhd Cost")
//                         {
//                         }
//                         column(RolledupCapOverheadCost_Item; Item."Rolled-up Cap. Overhead Cost")
//                         {
//                         }
//                         column(PlanningIssuesQty_Item; Item."Planning Issues (Qty.)")
//                         {
//                         }
//                         column(PlanningReceiptQty_Item; Item."Planning Receipt (Qty.)")
//                         {
//                         }
//                         column(PlannedOrderReceiptQty_Item; Item."Planned Order Receipt (Qty.)")
//                         {
//                         }
//                         column(FPOrderReceiptQty_Item; Item."FP Order Receipt (Qty.)")
//                         {
//                         }
//                         column(RelOrderReceiptQty_Item; Item."Rel. Order Receipt (Qty.)")
//                         {
//                         }
//                         column(PlanningReleaseQty_Item; Item."Planning Release (Qty.)")
//                         {
//                         }
//                         column(PlannedOrderReleaseQty_Item; Item."Planned Order Release (Qty.)")
//                         {
//                         }
//                         column(PurchReqReceiptQty_Item; Item."Purch. Req. Receipt (Qty.)")
//                         {
//                         }
//                         column(PurchReqReleaseQty_Item; Item."Purch. Req. Release (Qty.)")
//                         {
//                         }
//                         column(OrderTrackingPolicy_Item; Item."Order Tracking Policy")
//                         {
//                         }
//                         column(ProdForecastQuantityBase_Item; Item."Prod. Forecast Quantity (Base)")
//                         {
//                         }
//                         column(ProductionForecastName_Item; Item."Production Forecast Name")
//                         {
//                         }
//                         column(ComponentForecast_Item; Item."Component Forecast")
//                         {
//                         }
//                         column(QtyonProdOrder_Item; Item."Qty. on Prod. Order")
//                         {
//                         }
//                         column(QtyonComponentLines_Item; Item."Qty. on Component Lines")
//                         {
//                         }
//                         column(Critical_Item; Item.Critical)
//                         {
//                         }
//                         column(CommonItemNo_Item; Item."Common Item No.")
//                         {
//                         }
//                     }
//                 }
//             }
//         }
//     }

//     requestpage
//     {

//         layout
//         {
//         }

//         actions
//         {
//         }
//     }

//     labels
//     {
//     }

//     trigger OnPreReport();
//     begin
//         CompanyInformation.GET;
//     end;

//     var
//         OrginalSubContractAmt: Decimal;
//         TotalPrevCO: Decimal;
//         ContractPrior: Decimal;
//         BTotalCost: Decimal;
//         NewContractAmount: Decimal;
//         ParentSubContract: Record NS_Subcontract;
//         ChildSubContract: Record NS_Subcontract;
//         CompanyInformation: Record "Company Information";
// }

//PPDA.1.0 Commented End