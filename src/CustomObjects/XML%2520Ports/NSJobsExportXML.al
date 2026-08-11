//PRJCTPR-122.AT.1.0.0 27June23
xmlport 14021109 "NS_JobsExport XML"
{

    Caption = 'Export Jobs Lines';
    Direction = Export;
    Format = VariableText;
    TableSeparator = '<NewLine>';   // Default
    RecordSeparator = '<NewLine>';  // Default
    FieldSeparator = ',';   // Default
    FieldDelimiter = '"';   // Default
    TextEncoding = WINDOWS;
    UseRequestPage = false;

    schema
    {
        textelement(root)
        {
            tableelement(Integer; Integer)
            {
                XmlName = 'Header';
                SourceTableView = SORTING(Number) WHERE(Number = CONST(1));
                textelement(JobNo) { trigger OnBeforePassVariable() begin JobNo := Job.FieldCaption(Job."No."); end; }

                textelement(SearchDescription) { trigger OnBeforePassVariable() begin SearchDescription := Job.FieldCaption(Job."Search Description"); end; }
                textelement(Description) { trigger OnBeforePassVariable() begin Description := Job.FieldCaption(Job."Description"); end; }
                textelement(Description2) { trigger OnBeforePassVariable() begin Description2 := Job.FieldCaption(Job."Description 2"); end; }
                textelement(BilltoCustomerNo) { trigger OnBeforePassVariable() begin BilltoCustomerNo := Job.FieldCaption(Job."Bill-to Customer No."); end; }
                textelement(CreationDate) { trigger OnBeforePassVariable() begin CreationDate := Job.FieldCaption(Job."Creation Date"); end; }
                textelement(StartingDate) { trigger OnBeforePassVariable() begin StartingDate := Job.FieldCaption(Job."Starting Date"); end; }
                textelement(EndingDate) { trigger OnBeforePassVariable() begin EndingDate := Job.FieldCaption(Job."Ending Date"); end; }
                textelement(Status) { trigger OnBeforePassVariable() begin Status := Job.FieldCaption(Job."Status"); end; }
                textelement(PersonResponsible) { trigger OnBeforePassVariable() begin PersonResponsible := Job.FieldCaption(Job."Person Responsible"); end; }
                textelement(GlobalDimension1Code) { trigger OnBeforePassVariable() begin GlobalDimension1Code := Job.FieldCaption(Job."Global Dimension 1 Code"); end; }
                textelement(GlobalDimension2Code) { trigger OnBeforePassVariable() begin GlobalDimension2Code := Job.FieldCaption(Job."Global Dimension 2 Code"); end; }
                textelement(JobPostingGroup) { trigger OnBeforePassVariable() begin JobPostingGroup := Job.FieldCaption(Job."Job Posting Group"); end; }
                textelement(Blocked) { trigger OnBeforePassVariable() begin Blocked := Job.FieldCaption(Job."Blocked"); end; }
                textelement(LastDateModified) { trigger OnBeforePassVariable() begin LastDateModified := Job.FieldCaption(Job."Last Date Modified"); end; }
                textelement(CustomerDiscGroup) { trigger OnBeforePassVariable() begin CustomerDiscGroup := Job.FieldCaption(Job."Customer Disc. Group"); end; }
                textelement(CustomerPriceGroup) { trigger OnBeforePassVariable() begin CustomerPriceGroup := Job.FieldCaption(Job."Customer Price Group"); end; }
                textelement(LanguageCode) { trigger OnBeforePassVariable() begin LanguageCode := Job.FieldCaption(Job."Language Code"); end; }
                textelement(BilltoName) { trigger OnBeforePassVariable() begin BilltoName := Job.FieldCaption(Job."Bill-to Name"); end; }
                textelement(BilltoAddress) { trigger OnBeforePassVariable() begin BilltoAddress := Job.FieldCaption(Job."Bill-to Address"); end; }
                textelement(BilltoAddress2) { trigger OnBeforePassVariable() begin BilltoAddress2 := Job.FieldCaption(Job."Bill-to Address 2"); end; }
                textelement(BilltoCity) { trigger OnBeforePassVariable() begin BilltoCity := Job.FieldCaption(Job."Bill-to City"); end; }
                textelement(BilltoCounty) { trigger OnBeforePassVariable() begin BilltoCounty := Job.FieldCaption(Job."Bill-to County"); end; }
                textelement(BilltoPostCode) { trigger OnBeforePassVariable() begin BilltoPostCode := Job.FieldCaption(Job."Bill-to Post Code"); end; }
                textelement(NoSeries) { trigger OnBeforePassVariable() begin NoSeries := Job.FieldCaption(Job."No. Series"); end; }
                textelement(BilltoCountryRegionCode) { trigger OnBeforePassVariable() begin BilltoCountryRegionCode := Job.FieldCaption(Job."Bill-to Country/Region Code"); end; }
                textelement(BilltoName2) { trigger OnBeforePassVariable() begin BilltoName2 := Job.FieldCaption(Job."Bill-to Name 2"); end; }
                textelement(Reserve) { trigger OnBeforePassVariable() begin Reserve := Job.FieldCaption(Job."Reserve"); end; }
                textelement(Image) { trigger OnBeforePassVariable() begin Image := Job.FieldCaption(Job."Image"); end; }
                textelement(WIPMethod) { trigger OnBeforePassVariable() begin WIPMethod := Job.FieldCaption(Job."WIP Method"); end; }
                textelement(CurrencyCode) { trigger OnBeforePassVariable() begin CurrencyCode := Job.FieldCaption(Job."Currency Code"); end; }
                textelement(BilltoContactNo) { trigger OnBeforePassVariable() begin BilltoContactNo := Job.FieldCaption(Job."Bill-to Contact No."); end; }
                textelement(BilltoContact) { trigger OnBeforePassVariable() begin BilltoContact := Job.FieldCaption(Job."Bill-to Contact"); end; }
                textelement(WIPPostingDate) { trigger OnBeforePassVariable() begin WIPPostingDate := Job.FieldCaption(Job."WIP Posting Date"); end; }
                textelement(InvoiceCurrencyCode) { trigger OnBeforePassVariable() begin InvoiceCurrencyCode := Job.FieldCaption(Job."Invoice Currency Code"); end; }
                textelement(ExchCalculationCost) { trigger OnBeforePassVariable() begin ExchCalculationCost := Job.FieldCaption(Job."Exch. Calculation (Cost)"); end; }
                textelement(ExchCalculationPrice) { trigger OnBeforePassVariable() begin ExchCalculationPrice := Job.FieldCaption(Job."Exch. Calculation (Price)"); end; }
                textelement(AllowScheduleContractLines) { trigger OnBeforePassVariable() begin AllowScheduleContractLines := Job.FieldCaption(Job."Allow Schedule/Contract Lines"); end; }
                textelement(Complete) { trigger OnBeforePassVariable() begin Complete := Job.FieldCaption(Job."Complete"); end; }
                textelement(ApplyUsageLink) { trigger OnBeforePassVariable() begin ApplyUsageLink := Job.FieldCaption(Job."Apply Usage Link"); end; }
                textelement(WIPPostingMethod) { trigger OnBeforePassVariable() begin WIPPostingMethod := Job.FieldCaption(Job."WIP Posting Method"); end; }
                textelement(OverBudget) { trigger OnBeforePassVariable() begin OverBudget := Job.FieldCaption(Job."Over Budget"); end; }
                textelement(ProjectManager) { trigger OnBeforePassVariable() begin ProjectManager := Job.FieldCaption(Job."Project Manager"); end; }
                textelement(SelltoCustomerNo) { trigger OnBeforePassVariable() begin SelltoCustomerNo := Job.FieldCaption(Job."Sell-to Customer No."); end; }
                textelement(SelltoCustomerName) { trigger OnBeforePassVariable() begin SelltoCustomerName := Job.FieldCaption(Job."Sell-to Customer Name"); end; }
                textelement(SelltoCustomerName2) { trigger OnBeforePassVariable() begin SelltoCustomerName2 := Job.FieldCaption(Job."Sell-to Customer Name 2"); end; }
                textelement(SelltoAddress) { trigger OnBeforePassVariable() begin SelltoAddress := Job.FieldCaption(Job."Sell-to Address"); end; }
                textelement(SelltoAddress2) { trigger OnBeforePassVariable() begin SelltoAddress2 := Job.FieldCaption(Job."Sell-to Address 2"); end; }
                textelement(SelltoCity) { trigger OnBeforePassVariable() begin SelltoCity := Job.FieldCaption(Job."Sell-to City"); end; }
                textelement(SelltoContact) { trigger OnBeforePassVariable() begin SelltoContact := Job.FieldCaption(Job."Sell-to Contact"); end; }
                textelement(SelltoPostCode) { trigger OnBeforePassVariable() begin SelltoPostCode := Job.FieldCaption(Job."Sell-to Post Code"); end; }
                textelement(SelltoCounty) { trigger OnBeforePassVariable() begin SelltoCounty := Job.FieldCaption(Job."Sell-to County"); end; }
                textelement(SelltoCountryRegionCode) { trigger OnBeforePassVariable() begin SelltoCountryRegionCode := Job.FieldCaption(Job."Sell-to Country/Region Code"); end; }
                textelement(SelltoPhoneNo) { trigger OnBeforePassVariable() begin SelltoPhoneNo := Job.FieldCaption(Job."Sell-to Phone No."); end; }
                textelement(SelltoEMail) { trigger OnBeforePassVariable() begin SelltoEMail := Job.FieldCaption(Job."Sell-to E-Mail"); end; }
                textelement(SelltoContactNo) { trigger OnBeforePassVariable() begin SelltoContactNo := Job.FieldCaption(Job."Sell-to Contact No."); end; }
                textelement(ShiptoCode) { trigger OnBeforePassVariable() begin ShiptoCode := Job.FieldCaption(Job."Ship-to Code"); end; }
                textelement(ShiptoName) { trigger OnBeforePassVariable() begin ShiptoName := Job.FieldCaption(Job."Ship-to Name"); end; }
                textelement(ShiptoName2) { trigger OnBeforePassVariable() begin ShiptoName2 := Job.FieldCaption(Job."Ship-to Name 2"); end; }
                textelement(ShiptoAddress) { trigger OnBeforePassVariable() begin ShiptoAddress := Job.FieldCaption(Job."Ship-to Address"); end; }
                textelement(ShiptoAddress2) { trigger OnBeforePassVariable() begin ShiptoAddress2 := Job.FieldCaption(Job."Ship-to Address 2"); end; }
                textelement(ShiptoCity) { trigger OnBeforePassVariable() begin ShiptoCity := Job.FieldCaption(Job."Ship-to City"); end; }
                textelement(ShiptoContact) { trigger OnBeforePassVariable() begin ShiptoContact := Job.FieldCaption(Job."Ship-to Contact"); end; }
                textelement(ShiptoPostCode) { trigger OnBeforePassVariable() begin ShiptoPostCode := Job.FieldCaption(Job."Ship-to Post Code"); end; }
                textelement(ShiptoCounty) { trigger OnBeforePassVariable() begin ShiptoCounty := Job.FieldCaption(Job."Ship-to County"); end; }
                textelement(ShiptoCountryRegionCode) { trigger OnBeforePassVariable() begin ShiptoCountryRegionCode := Job.FieldCaption(Job."Ship-to Country/Region Code"); end; }
                textelement(ExternalDocumentNo) { trigger OnBeforePassVariable() begin ExternalDocumentNo := Job.FieldCaption(Job."External Document No."); end; }
                textelement(PaymentMethodCode) { trigger OnBeforePassVariable() begin PaymentMethodCode := Job.FieldCaption(Job."Payment Method Code"); end; }
                textelement(PaymentTermsCode) { trigger OnBeforePassVariable() begin PaymentTermsCode := Job.FieldCaption(Job."Payment Terms Code"); end; }
                textelement(YourReference) { trigger OnBeforePassVariable() begin YourReference := Job.FieldCaption(Job."Your Reference"); end; }
                textelement(PriceCalculationMethod) { trigger OnBeforePassVariable() begin PriceCalculationMethod := Job.FieldCaption(Job."Price Calculation Method"); end; }
                textelement(CostCalculationMethod) { trigger OnBeforePassVariable() begin CostCalculationMethod := Job.FieldCaption(Job."Cost Calculation Method"); end; }
                textelement(NSJobAddress1) { trigger OnBeforePassVariable() begin NSJobAddress1 := Job.FieldCaption(Job."NS_Job Address 1"); end; }
                textelement(NSJobAddress2) { trigger OnBeforePassVariable() begin NSJobAddress2 := Job.FieldCaption(Job."NS_Job Address 2"); end; }
                textelement(NSJobCity) { trigger OnBeforePassVariable() begin NSJobCity := Job.FieldCaption(Job."NS_Job City"); end; }
                textelement(NSJobCounty) { trigger OnBeforePassVariable() begin NSJobCounty := Job.FieldCaption(Job."NS_Job County"); end; }
                textelement(NSJobPostCode) { trigger OnBeforePassVariable() begin NSJobPostCode := Job.FieldCaption(Job."NS_Job Post Code"); end; }
                textelement(NSJobCountryRegionCode) { trigger OnBeforePassVariable() begin NSJobCountryRegionCode := Job.FieldCaption(Job."NS_Job Country/Region Code"); end; }
                textelement(NSJobContact) { trigger OnBeforePassVariable() begin NSJobContact := Job.FieldCaption(Job."NS_Job Contact"); end; }
                textelement(NSJobPhone) { trigger OnBeforePassVariable() begin NSJobPhone := Job.FieldCaption(Job."NS_Job Phone"); end; }
                textelement(NSJobShiptoCode) { trigger OnBeforePassVariable() begin NSJobShiptoCode := Job.FieldCaption(Job."NS_Job Ship-to Code"); end; }
                textelement(NSSubLeveltoJobNo) { trigger OnBeforePassVariable() begin NSSubLeveltoJobNo := Job.FieldCaption(Job."NS_Sub-Level to Job No."); end; }
                textelement(NSTempLinkedParentJobNo) { trigger OnBeforePassVariable() begin NSTempLinkedParentJobNo := Job.FieldCaption(Job."NS_Temp Linked Parent Job No."); end; }
                textelement(NSLastJobForJobList) { trigger OnBeforePassVariable() begin NSLastJobForJobList := Job.FieldCaption(Job."NS_Last Job For Job List"); end; }
                textelement(NSCopyJob) { trigger OnBeforePassVariable() begin NSCopyJob := Job.FieldCaption(Job."NS_CopyJob"); end; }
                //textelement(NSJobType) { trigger OnBeforePassVariable() begin NSJobType := Job.FieldCaption(Job."NS_Job Type"); end; }   //PRJCTPR-298.JS.1.0 16JAN2024
                textelement(NSJobType) { trigger OnBeforePassVariable() begin NSJobType := Job.FieldCaption(Job."NS_Job Type New"); end; }  //PRJCTPR-298.JS.1.0 16JAN2024
                textelement(NSJobClass) { trigger OnBeforePassVariable() begin NSJobClass := Job.FieldCaption(Job."NS_Job Class"); end; }
                textelement(NSTimeAndMaterial) { trigger OnBeforePassVariable() begin NSTimeAndMaterial := Job.FieldCaption(Job."NS_Time And Material"); end; }
                textelement(NSIndirectBurdenType) { trigger OnBeforePassVariable() begin NSIndirectBurdenType := Job.FieldCaption(Job."NS_Indirect Burden Type"); end; }
                textelement(NSSalespersonCode) { trigger OnBeforePassVariable() begin NSSalespersonCode := Job.FieldCaption(Job."NS_Salesperson Code"); end; }
                textelement(NSEstimator) { trigger OnBeforePassVariable() begin NSEstimator := Job.FieldCaption(Job."NS_Estimator"); end; }
                textelement(NSManager) { trigger OnBeforePassVariable() begin NSManager := Job.FieldCaption(Job."NS_Manager"); end; }
                textelement(NSManagerJobStatus) { trigger OnBeforePassVariable() begin NSManagerJobStatus := Job.FieldCaption(Job."NS_Manager Job Status"); end; }
                textelement(NSJobStatusDate) { trigger OnBeforePassVariable() begin NSJobStatusDate := Job.FieldCaption(Job."NS_Job Status Date"); end; }
                textelement(NSEstimatedStartDate) { trigger OnBeforePassVariable() begin NSEstimatedStartDate := Job.FieldCaption(Job."NS_Estimated Start Date"); end; }
                textelement(NSEstimatedCompletionDate) { trigger OnBeforePassVariable() begin NSEstimatedCompletionDate := Job.FieldCaption(Job."NS_Estimated Completion Date"); end; }
                textelement(NSCompletionDate) { trigger OnBeforePassVariable() begin NSCompletionDate := Job.FieldCaption(Job."NS_Completion Date"); end; }
                textelement(NSJobPostingDate) { trigger OnBeforePassVariable() begin NSJobPostingDate := Job.FieldCaption(Job."NS_Job Posting Date"); end; }
                textelement(NSRecognitionDate) { trigger OnBeforePassVariable() begin NSRecognitionDate := Job.FieldCaption(Job."NS_Recognition Date"); end; }
                textelement(NSUnitofMeasure) { trigger OnBeforePassVariable() begin NSUnitofMeasure := Job.FieldCaption(Job."NS_Unit of Measure"); end; }
                textelement(NSTotalUnits) { trigger OnBeforePassVariable() begin NSTotalUnits := Job.FieldCaption(Job."NS_Total Units"); end; }
                textelement(NSRevenueRecognized) { trigger OnBeforePassVariable() begin NSRevenueRecognized := Job.FieldCaption(Job."NS_Revenue Recognized"); end; }
                textelement(NSBillingDayofMonth) { trigger OnBeforePassVariable() begin NSBillingDayofMonth := Job.FieldCaption(Job."NS_Billing Day of Month"); end; }
                textelement(NSBillingMethod) { trigger OnBeforePassVariable() begin NSBillingMethod := Job.FieldCaption(Job."NS_Billing Method"); end; }
                textelement(NSRecognitionMethod) { trigger OnBeforePassVariable() begin NSRecognitionMethod := Job.FieldCaption(Job."NS_Recognition Method"); end; }
                textelement(NSDefaultJobRetention) { trigger OnBeforePassVariable() begin NSDefaultJobRetention := Job.FieldCaption(Job."NS_Default Job Retention"); end; }
                textelement(NSForecastType) { trigger OnBeforePassVariable() begin NSForecastType := Job.FieldCaption(Job."NS_Forecast Type"); end; }
                textelement(NSTaxAreaCode) { trigger OnBeforePassVariable() begin NSTaxAreaCode := Job.FieldCaption(Job."NS_Tax Area Code"); end; }
                textelement(NSTaxLiable) { trigger OnBeforePassVariable() begin NSTaxLiable := Job.FieldCaption(Job."NS_Tax Liable"); end; }
                //textelement(NSTaxGroupCode) { trigger OnBeforePassVariable() begin NSTaxGroupCode := Job.FieldCaption(Job."NS_Tax Group Code"); end; } //PRJCTPR-298.JS.1.0 16JAN2024
                textelement(NSTaxGroupCode) { trigger OnBeforePassVariable() begin NSTaxGroupCode := Job.FieldCaption(Job."NS_Tax Group Code New"); end; }  //PRJCTPR-298.JS.1.0 16JAN2024
                textelement(NSVATBusPostingGroup) { trigger OnBeforePassVariable() begin NSVATBusPostingGroup := Job.FieldCaption(Job."NS_VAT Bus. Posting Group"); end; }
                textelement(NSVATProdPostingGroup) { trigger OnBeforePassVariable() begin NSVATProdPostingGroup := Job.FieldCaption(Job."NS_VAT Prod. Posting Group"); end; }
                textelement(NSActualPercentComplete) { trigger OnBeforePassVariable() begin NSActualPercentComplete := Job.FieldCaption(Job."NS_Actual Percent Complete"); end; }
                textelement(NSActualPercentCompleteDate) { trigger OnBeforePassVariable() begin NSActualPercentCompleteDate := Job.FieldCaption(Job."NS_Actual PercentCompleteDate"); end; }
                textelement(NSActualUnitsComplete) { trigger OnBeforePassVariable() begin NSActualUnitsComplete := Job.FieldCaption(Job."NS_Actual Units Complete"); end; }
                textelement(NSActualUnitsCompleteDate) { trigger OnBeforePassVariable() begin NSActualUnitsCompleteDate := Job.FieldCaption(Job."NS_Actual Units Complete Date"); end; }
                textelement(NSJobRevenuePosting) { trigger OnBeforePassVariable() begin NSJobRevenuePosting := Job.FieldCaption(Job."NS_Job Revenue Posting"); end; }
                textelement(NSProgressBillingNo) { trigger OnBeforePassVariable() begin NSProgressBillingNo := Job.FieldCaption(Job."NS_Progress Billing No."); end; }
                textelement(NSProgressBillingSubLevel) { trigger OnBeforePassVariable() begin NSProgressBillingSubLevel := Job.FieldCaption(Job."NS_Progress Billing Sub-Level"); end; }
                textelement(NSCustomerJobNo) { trigger OnBeforePassVariable() begin NSCustomerJobNo := Job.FieldCaption(Job."NS_Customer Job No."); end; }
                textelement(NSCustomerPONumber) { trigger OnBeforePassVariable() begin NSCustomerPONumber := Job.FieldCaption(Job."NS_Customer PO Number"); end; }
                textelement(NSContractNo) { trigger OnBeforePassVariable() begin NSContractNo := Job.FieldCaption(Job."NS_Contract No."); end; }
                textelement(NSContractDate) { trigger OnBeforePassVariable() begin NSContractDate := Job.FieldCaption(Job."NS_Contract Date"); end; }
                textelement(NSContractFor) { trigger OnBeforePassVariable() begin NSContractFor := Job.FieldCaption(Job."NS_Contract For"); end; }
                textelement(NSContractType) { trigger OnBeforePassVariable() begin NSContractType := Job.FieldCaption(Job."NS_Contract Type"); end; }
                textelement(NSContractSellPrice) { trigger OnBeforePassVariable() begin NSContractSellPrice := Job.FieldCaption(Job."NS_Contract Sell Price"); end; }
                textelement(NSRequiresCertifiedPayroll) { trigger OnBeforePassVariable() begin NSRequiresCertifiedPayroll := Job.FieldCaption(Job."NS_Requires Certified Payroll"); end; }
                textelement(NSGenBusPostingGroupNew) { trigger OnBeforePassVariable() begin NSGenBusPostingGroupNew := Job.FieldCaption(Job."NS_Gen. Bus. Posting Group New"); end; }
                textelement(NSGenProdPostingGroupNe) { trigger OnBeforePassVariable() begin NSGenProdPostingGroupNe := Job.FieldCaption(Job."NS_Gen. Prod. Posting Group New"); end; }
                textelement(NSOSFileName) { trigger OnBeforePassVariable() begin NSOSFileName := Job.FieldCaption(Job."NS_OS File Name"); end; }
                textelement(NSJobCalendarCode) { trigger OnBeforePassVariable() begin NSJobCalendarCode := Job.FieldCaption(Job."NS_Job Calendar Code"); end; }
                textelement(NSPrepaymentNo) { trigger OnBeforePassVariable() begin NSPrepaymentNo := Job.FieldCaption(Job."NS_Prepayment No."); end; }
                textelement(NSPrepayment) { trigger OnBeforePassVariable() begin NSPrepayment := Job.FieldCaption(Job."NS_Prepayment %"); end; }
                textelement(NSPrepaymentNoSeries) { trigger OnBeforePassVariable() begin NSPrepaymentNoSeries := Job.FieldCaption(Job."NS_Prepayment No. Series"); end; }
                textelement(NSCompressPrepayment) { trigger OnBeforePassVariable() begin NSCompressPrepayment := Job.FieldCaption(Job."NS_Compress Prepayment"); end; }
                textelement(NSPrepaymentDueDate) { trigger OnBeforePassVariable() begin NSPrepaymentDueDate := Job.FieldCaption(Job."NS_Prepayment Due Date"); end; }
                textelement(NSPrepmtCrMemoNoSeries) { trigger OnBeforePassVariable() begin NSPrepmtCrMemoNoSeries := Job.FieldCaption(Job."NS_Prepmt. Cr. Memo No. Series"); end; }
                textelement(NSPrepmtPaymentTermsCode) { trigger OnBeforePassVariable() begin NSPrepmtPaymentTermsCode := Job.FieldCaption(Job."NS_Prepmt. Payment Terms Code"); end; }
                textelement(NSPrepmtPaymentDiscount) { trigger OnBeforePassVariable() begin NSPrepmtPaymentDiscount := Job.FieldCaption(Job."NS_Prepmt. Payment Discount %"); end; }
                textelement(NSPrepmtCrMemoNo) { trigger OnBeforePassVariable() begin NSPrepmtCrMemoNo := Job.FieldCaption(Job."NS_Prepmt. Cr. Memo No."); end; }
                textelement(NSPrepaymentAmount) { trigger OnBeforePassVariable() begin NSPrepaymentAmount := Job.FieldCaption(Job."NS_Prepayment Amount"); end; }
                textelement(NSAmtRecognized) { trigger OnBeforePassVariable() begin NSAmtRecognized := Job.FieldCaption(Job."NS_Amt. Recognized"); end; }
                textelement(NSForecastMethod) { trigger OnBeforePassVariable() begin NSForecastMethod := Job.FieldCaption(Job."NS_Forecast Method"); end; }
                textelement(NSLastForecastPostedDate) { trigger OnBeforePassVariable() begin NSLastForecastPostedDate := Job.FieldCaption(Job."NS_Last Forecast Posted Date"); end; }
                textelement(NSAPComment) { trigger OnBeforePassVariable() begin NSAPComment := Job.FieldCaption(Job."NS_AP Comment"); end; }
                textelement(NSQuoteNo) { trigger OnBeforePassVariable() begin NSQuoteNo := Job.FieldCaption(Job."NS_Quote No."); end; }
                textelement(NSJobSiteCustomerNo) { trigger OnBeforePassVariable() begin NSJobSiteCustomerNo := Job.FieldCaption(Job."NS_Job Site Customer No."); end; }
                textelement(NSJobSiteCustomerName) { trigger OnBeforePassVariable() begin NSJobSiteCustomerName := Job.FieldCaption(Job."NS_Job Site Customer Name"); end; }
                textelement(NSOwnerNo) { trigger OnBeforePassVariable() begin NSOwnerNo := Job.FieldCaption(Job."NS_Owner No."); end; }
                textelement(NSOwnerName) { trigger OnBeforePassVariable() begin NSOwnerName := Job.FieldCaption(Job."NS_Owner Name"); end; }
                textelement(NSGeneralContractorNo) { trigger OnBeforePassVariable() begin NSGeneralContractorNo := Job.FieldCaption(Job."NS_General Contractor No."); end; }
                textelement(NSGeneralContractorName) { trigger OnBeforePassVariable() begin NSGeneralContractorName := Job.FieldCaption(Job."NS_General Contractor Name"); end; }
                textelement(NSArchitectEngineerNo) { trigger OnBeforePassVariable() begin NSArchitectEngineerNo := Job.FieldCaption(Job."NS_Architect/Engineer No."); end; }
                textelement(NSArchitectEngineerName) { trigger OnBeforePassVariable() begin NSArchitectEngineerName := Job.FieldCaption(Job."NS_Architect/Engineer Name"); end; }
                textelement(NSProjectManagerNo) { trigger OnBeforePassVariable() begin NSProjectManagerNo := Job.FieldCaption(Job."NS_Project Manager No."); end; }
                textelement(NSProjectManagerName) { trigger OnBeforePassVariable() begin NSProjectManagerName := Job.FieldCaption(Job."NS_Project Manager Name"); end; }
                textelement(NSBillingCutoffDayofMonth) { trigger OnBeforePassVariable() begin NSBillingCutoffDayofMonth := Job.FieldCaption(Job."NS_Billing Cutoff Day of Month"); end; }
                textelement(NSCCIPOCIPRCOIPInsurance) { trigger OnBeforePassVariable() begin NSCCIPOCIPRCOIPInsurance := Job.FieldCaption(Job."NS_CCIP/OCIP/RCOIP Insurance"); end; }
                textelement(NSLienWaiverRequired) { trigger OnBeforePassVariable() begin NSLienWaiverRequired := Job.FieldCaption(Job."NS_Lien Waiver Required"); end; }
                textelement(NSUseTaxSKU) { trigger OnBeforePassVariable() begin NSUseTaxSKU := Job.FieldCaption(Job."NS_Use Tax SKU"); end; }
                textelement(NSCustomerAccount) { trigger OnBeforePassVariable() begin NSCustomerAccount := Job.FieldCaption(Job."NS_Customer Account"); end; }
                textelement(NSCreatedfromQuoteNo) { trigger OnBeforePassVariable() begin NSCreatedfromQuoteNo := Job.FieldCaption(Job."NS_Created from Quote No."); end; }
                textelement(NSQuoteRevision) { trigger OnBeforePassVariable() begin NSQuoteRevision := Job.FieldCaption(Job."NS_Quote Revision"); end; }
                textelement(NSUseJobMaterialPlanning) { trigger OnBeforePassVariable() begin NSUseJobMaterialPlanning := Job.FieldCaption(Job."NS_Use Job Material Planning"); end; }
                textelement(NSSelltoCustomerNo) { trigger OnBeforePassVariable() begin NSSelltoCustomerNo := Job.FieldCaption(Job."NS_Sell-to Customer No."); end; }
                textelement(NSSelltoCustomerName) { trigger OnBeforePassVariable() begin NSSelltoCustomerName := Job.FieldCaption(Job."NS_Sell-to Customer Name"); end; }
                textelement(NSLineType) { trigger OnBeforePassVariable() begin NSLineType := Job.FieldCaption(Job."NS_Line Type"); end; }
                textelement(NSEnblGLNResGMCalc) { trigger OnBeforePassVariable() begin NSEnblGLNResGMCalc := Job.FieldCaption(Job."NS_EnblGLNResGMCalc"); end; }
                textelement(NSDFRNos) { trigger OnBeforePassVariable() begin NSDFRNos := Job.FieldCaption(Job."NS_DFR Nos."); end; }
                textelement(NSExcludefromJobForecast) { trigger OnBeforePassVariable() begin NSExcludefromJobForecast := Job.FieldCaption(Job."NS_Exclude from Job Forecast"); end; }
                textelement(NSUseBillingformat) { trigger OnBeforePassVariable() begin NSUseBillingformat := Job.FieldCaption(Job."NS_Use % Billing format"); end; }
                // textelement(NSTaxGroupCodeNew) { trigger OnBeforePassVariable() begin NSTaxGroupCodeNew := Job.FieldCaption(Job."NS_Tax Group Code New"); end; }
                textelement(NSUseTaxPercentage) { trigger OnBeforePassVariable() begin NSUseTaxPercentage := Job.FieldCaption(Job."NS_Use Tax Percentage"); end; }
                textelement(NSIncludeSubLevels) { trigger OnBeforePassVariable() begin NSIncludeSubLevels := Job.FieldCaption(Job."NS_Include Sub Levels"); end; }
                textelement(NSUseJobPlanLineEntries) { trigger OnBeforePassVariable() begin NSUseJobPlanLineEntries := Job.FieldCaption(Job."NS_Use Job Plan. Line Entries"); end; }
                textelement(NSRootJobNo) { trigger OnBeforePassVariable() begin NSRootJobNo := Job.FieldCaption(Job."NS_Root Job No."); end; }
                textelement(NSPOCMethod) { trigger OnBeforePassVariable() begin NSPOCMethod := Job.FieldCaption(Job."NS_POC Method"); end; }
                textelement(NSPOCMethodValue) { trigger OnBeforePassVariable() begin NSPOCMethodValue := Job.FieldCaption(Job."NS_POC Method Value"); end; }
                textelement(NSPOCMethodValueDate) { trigger OnBeforePassVariable() begin NSPOCMethodValueDate := Job.FieldCaption(Job."NS_POC Method Value Date"); end; }
                textelement(NSJobPurchaser) { trigger OnBeforePassVariable() begin NSJobPurchaser := Job.FieldCaption(Job."NS_Job Purchaser"); end; }
                textelement(NSOpenJobBacklog) { trigger OnBeforePassVariable() begin NSOpenJobBacklog := Job.FieldCaption(Job."NS_Open Job Backlog"); end; }
                textelement(NSDelieveryInstruction) { trigger OnBeforePassVariable() begin NSDelieveryInstruction := Job.FieldCaption(Job."NS_Delievery Instruction"); end; }
                // textelement(NSUseTax) { trigger OnBeforePassVariable() begin NSUseTax := Job.FieldCaption(Job."NS_Use Tax"); end; }
                textelement(NSRunBatchOpenJobBacklog) { trigger OnBeforePassVariable() begin NSRunBatchOpenJobBacklog := Job.FieldCaption(Job."NS_Run Batch Open Job Backlog"); end; }
                //textelement(NSNewRunBOpenJobBLog) { trigger OnBeforePassVariable() begin NSNewRunBOpenJobBLog := Job.FieldCaption(Job.Ns_New); end; }
                //textelement(NSNewBillableInvDif) { trigger OnBeforePassVariable() begin NSNewBillableInvDif := Job.FieldCaption(Job.); end; }
                textelement(NSOpportunity) { trigger OnBeforePassVariable() begin NSOpportunity := Job.FieldCaption(Job."NS_Opportunity"); end; }
                // textelement(NSNewRunBOpenJobBLog) { trigger OnBeforePassVariable() begin NSNewRunBOpenJobBLog := Job.FieldCaption(Job."NS_New Run B_OpenJob B Log"); end; }
                // textelement(NSNewBillableInvDif) { trigger OnBeforePassVariable() begin NSNewBillableInvDif := Job.FieldCaption(Job."NS_New Billable/Inv Dif"); end; }
            }
            tableelement(Job; Job)
            {
                XmlName = 'Job';
                AutoSave = true;
                AutoUpdate = true;
                AutoReplace = false;
                SourceTableView = SORTING("No.");
                fieldelement(No; Job."No.") { }
                fieldelement(SearchDescription; Job."Search Description") { }
                fieldelement(Description; Job."Description") { }
                fieldelement(Description2; Job."Description 2") { }
                fieldelement(BilltoCustomerNo; Job."Bill-to Customer No.") { }
                fieldelement(CreationDate; Job."Creation Date") { }
                fieldelement(StartingDate; Job."Starting Date") { }
                fieldelement(EndingDate; Job."Ending Date") { }
                fieldelement(Status; Job."Status") { }
                fieldelement(PersonResponsible; Job."Person Responsible") { }
                fieldelement(GlobalDimension1Code; Job."Global Dimension 1 Code") { }
                fieldelement(GlobalDimension2Code; Job."Global Dimension 2 Code") { }
                fieldelement(JobPostingGroup; Job."Job Posting Group") { }
                fieldelement(Blocked; Job."Blocked") { }
                fieldelement(LastDateModified; Job."Last Date Modified") { }
                fieldelement(CustomerDiscGroup; Job."Customer Disc. Group") { }
                fieldelement(CustomerPriceGroup; Job."Customer Price Group") { }
                fieldelement(LanguageCode; Job."Language Code") { }
                fieldelement(BilltoName; Job."Bill-to Name") { }
                fieldelement(BilltoAddress; Job."Bill-to Address") { }
                fieldelement(BilltoAddress2; Job."Bill-to Address 2") { }
                fieldelement(BilltoCity; Job."Bill-to City") { }
                fieldelement(BilltoCounty; Job."Bill-to County") { }
                fieldelement(BilltoPostCode; Job."Bill-to Post Code") { }
                fieldelement(NoSeries; Job."No. Series") { }
                fieldelement(BilltoCountryRegionCode; Job."Bill-to Country/Region Code") { }
                fieldelement(BilltoName2; Job."Bill-to Name 2") { }
                fieldelement(Reserve; Job."Reserve") { }
                fieldelement(Image; Job."Image") { }
                fieldelement(WIPMethod; Job."WIP Method") { }
                fieldelement(CurrencyCode; Job."Currency Code") { }
                fieldelement(BilltoContactNo; Job."Bill-to Contact No.") { }
                fieldelement(BilltoContact; Job."Bill-to Contact") { }
                fieldelement(WIPPostingDate; Job."WIP Posting Date") { }
                fieldelement(InvoiceCurrencyCode; Job."Invoice Currency Code") { }
                fieldelement(ExchCalculationCost; Job."Exch. Calculation (Cost)") { }
                fieldelement(ExchCalculationPrice; Job."Exch. Calculation (Price)") { }
                fieldelement(AllowScheduleContractLines; Job."Allow Schedule/Contract Lines") { }
                fieldelement(Complete; Job."Complete") { }
                fieldelement(ApplyUsageLink; Job."Apply Usage Link") { }
                fieldelement(WIPPostingMethod; Job."WIP Posting Method") { }
                fieldelement(OverBudget; Job."Over Budget") { }
                fieldelement(ProjectManager; Job."Project Manager") { }
                fieldelement(SelltoCustomerNo; Job."Sell-to Customer No.") { }
                fieldelement(SelltoCustomerName; Job."Sell-to Customer Name") { }
                fieldelement(SelltoCustomerName2; Job."Sell-to Customer Name 2") { }
                fieldelement(SelltoAddress; Job."Sell-to Address") { }
                fieldelement(SelltoAddress2; Job."Sell-to Address 2") { }
                fieldelement(SelltoCity; Job."Sell-to City") { }
                fieldelement(SelltoContact; Job."Sell-to Contact") { }
                fieldelement(SelltoPostCode; Job."Sell-to Post Code") { }
                fieldelement(SelltoCounty; Job."Sell-to County") { }
                fieldelement(SelltoCountryRegionCode; Job."Sell-to Country/Region Code") { }
                fieldelement(SelltoPhoneNo; Job."Sell-to Phone No.") { }
                fieldelement(SelltoEMail; Job."Sell-to E-Mail") { }
                fieldelement(SelltoContactNo; Job."Sell-to Contact No.") { }
                fieldelement(ShiptoCode; Job."Ship-to Code") { }
                fieldelement(ShiptoName; Job."Ship-to Name") { }
                fieldelement(ShiptoName2; Job."Ship-to Name 2") { }
                fieldelement(ShiptoAddress; Job."Ship-to Address") { }
                fieldelement(ShiptoAddress2; Job."Ship-to Address 2") { }
                fieldelement(ShiptoCity; Job."Ship-to City") { }
                fieldelement(ShiptoContact; Job."Ship-to Contact") { }
                fieldelement(ShiptoPostCode; Job."Ship-to Post Code") { }
                fieldelement(ShiptoCounty; Job."Ship-to County") { }
                fieldelement(ShiptoCountryRegionCode; Job."Ship-to Country/Region Code") { }
                fieldelement(ExternalDocumentNo; Job."External Document No.") { }
                fieldelement(PaymentMethodCode; Job."Payment Method Code") { }
                fieldelement(PaymentTermsCode; Job."Payment Terms Code") { }
                fieldelement(YourReference; Job."Your Reference") { }
                fieldelement(PriceCalculationMethod; Job."Price Calculation Method") { }
                fieldelement(CostCalculationMethod; Job."Cost Calculation Method") { }
                fieldelement(NSJobAddress1; Job."NS_Job Address 1") { }
                fieldelement(NSJobAddress2; Job."NS_Job Address 2") { }
                fieldelement(NSJobCity; Job."NS_Job City") { }
                fieldelement(NSJobCounty; Job."NS_Job County") { }
                fieldelement(NSJobPostCode; Job."NS_Job Post Code") { }
                fieldelement(NSJobCountryRegionCode; Job."NS_Job Country/Region Code") { }
                fieldelement(NSJobContact; Job."NS_Job Contact") { }
                fieldelement(NSJobPhone; Job."NS_Job Phone") { }
                fieldelement(NSJobShiptoCode; Job."NS_Job Ship-to Code") { }
                fieldelement(NSSubLeveltoJobNo; Job."NS_Sub-Level to Job No.") { }
                fieldelement(NSTempLinkedParentJobNo; Job."NS_Temp Linked Parent Job No.") { }
                fieldelement(NSLastJobForJobList; Job."NS_Last Job For Job List") { }
                fieldelement(NSCopyJob; Job."NS_CopyJob") { }
                //fieldelement(NSJobType; Job."NS_Job Type") { }  //PRJCTPR-298.JS.1.0 16JAN2024
                fieldelement(NSJobType; Job."NS_Job Type New") { }  //PRJCTPR-298.JS.1.0 16JAN2024
                fieldelement(NSJobClass; Job."NS_Job Class") { }
                fieldelement(NSTimeAndMaterial; Job."NS_Time And Material") { }
                fieldelement(NSIndirectBurdenType; Job."NS_Indirect Burden Type") { }
                fieldelement(NSSalespersonCode; Job."NS_Salesperson Code") { }
                fieldelement(NSEstimator; Job."NS_Estimator") { }
                fieldelement(NSManager; Job."NS_Manager") { }
                fieldelement(NSManagerJobStatus; Job."NS_Manager Job Status") { }
                fieldelement(NSJobStatusDate; Job."NS_Job Status Date") { }
                fieldelement(NSEstimatedStartDate; Job."NS_Estimated Start Date") { }
                fieldelement(NSEstimatedCompletionDate; Job."NS_Estimated Completion Date") { }
                fieldelement(NSCompletionDate; Job."NS_Completion Date") { }
                fieldelement(NSJobPostingDate; Job."NS_Job Posting Date") { }
                fieldelement(NSRecognitionDate; Job."NS_Recognition Date") { }
                fieldelement(NSUnitofMeasure; Job."NS_Unit of Measure") { }
                fieldelement(NSTotalUnits; Job."NS_Total Units") { }
                fieldelement(NSRevenueRecognized; Job."NS_Revenue Recognized") { }
                fieldelement(NSBillingDayofMonth; Job."NS_Billing Day of Month") { }
                fieldelement(NSBillingMethod; Job."NS_Billing Method") { }
                fieldelement(NSRecognitionMethod; Job."NS_Recognition Method") { }
                fieldelement(NSDefaultJobRetention; Job."NS_Default Job Retention") { }
                fieldelement(NSForecastType; Job."NS_Forecast Type") { }
                fieldelement(NSTaxAreaCode; Job."NS_Tax Area Code") { }
                fieldelement(NSTaxLiable; Job."NS_Tax Liable") { }
                //fieldelement(NSTaxGroupCode; Job."NS_Tax Group Code") { }   //PRJCTPR-298.JS.1.0 16JAN2024
                fieldelement(NSTaxGroupCode; Job."NS_Tax Group Code New") { }  //PRJCTPR-298.JS.1.0 16JAN2024
                fieldelement(NSVATBusPostingGroup; Job."NS_VAT Bus. Posting Group") { }
                fieldelement(NSVATProdPostingGroup; Job."NS_VAT Prod. Posting Group") { }
                fieldelement(NSActualPercentComplete; Job."NS_Actual Percent Complete") { }
                fieldelement(NSActualPercentCompleteDate; Job."NS_Actual PercentCompleteDate") { }
                fieldelement(NSActualUnitsComplete; Job."NS_Actual Units Complete") { }
                fieldelement(NSActualUnitsCompleteDate; Job."NS_Actual Units Complete Date") { }
                fieldelement(NSJobRevenuePosting; Job."NS_Job Revenue Posting") { }
                fieldelement(NSProgressBillingNo; Job."NS_Progress Billing No.") { }
                fieldelement(NSProgressBillingSubLevel; Job."NS_Progress Billing Sub-Level") { }
                fieldelement(NSCustomerJobNo; Job."NS_Customer Job No.") { }
                fieldelement(NSCustomerPONumber; Job."NS_Customer PO Number") { }
                fieldelement(NSContractNo; Job."NS_Contract No.") { }
                fieldelement(NSContractDate; Job."NS_Contract Date") { }
                fieldelement(NSContractFor; Job."NS_Contract For") { }
                fieldelement(NSContractType; Job."NS_Contract Type") { }
                fieldelement(NSContractSellPrice; Job."NS_Contract Sell Price") { }
                fieldelement(NSRequiresCertifiedPayroll; Job."NS_Requires Certified Payroll") { }
                fieldelement(NSGenBusPostingGroupNew; Job."NS_Gen. Bus. Posting Group New") { }
                fieldelement(NSGenProdPostingGroupNe; Job."NS_Gen. Prod. Posting Group New") { }
                fieldelement(NSOSFileName; Job."NS_OS File Name") { }
                fieldelement(NSJobCalendarCode; Job."NS_Job Calendar Code") { }
                fieldelement(NSPrepaymentNo; Job."NS_Prepayment No.") { }
                fieldelement(NSPrepayment; Job."NS_Prepayment %") { }
                fieldelement(NSPrepaymentNoSeries; Job."NS_Prepayment No. Series") { }
                fieldelement(NSCompressPrepayment; Job."NS_Compress Prepayment") { }
                fieldelement(NSPrepaymentDueDate; Job."NS_Prepayment Due Date") { }
                fieldelement(NSPrepmtCrMemoNoSeries; Job."NS_Prepmt. Cr. Memo No. Series") { }
                fieldelement(NSPrepmtPaymentTermsCode; Job."NS_Prepmt. Payment Terms Code") { }
                fieldelement(NSPrepmtPaymentDiscount; Job."NS_Prepmt. Payment Discount %") { }
                fieldelement(NSPrepmtCrMemoNo; Job."NS_Prepmt. Cr. Memo No.") { }
                fieldelement(NSPrepaymentAmount; Job."NS_Prepayment Amount") { }
                fieldelement(NSAmtRecognized; Job."NS_Amt. Recognized") { }
                fieldelement(NSForecastMethod; Job."NS_Forecast Method") { }
                fieldelement(NSLastForecastPostedDate; Job."NS_Last Forecast Posted Date") { }
                fieldelement(NSAPComment; Job."NS_AP Comment") { }
                fieldelement(NSQuoteNo; Job."NS_Quote No.") { }
                fieldelement(NSJobSiteCustomerNo; Job."NS_Job Site Customer No.") { }
                fieldelement(NSJobSiteCustomerName; Job."NS_Job Site Customer Name") { }
                fieldelement(NSOwnerNo; Job."NS_Owner No.") { }
                fieldelement(NSOwnerName; Job."NS_Owner Name") { }
                fieldelement(NSGeneralContractorNo; Job."NS_General Contractor No.") { }
                fieldelement(NSGeneralContractorName; Job."NS_General Contractor Name") { }
                fieldelement(NSArchitectEngineerNo; Job."NS_Architect/Engineer No.") { }
                fieldelement(NSArchitectEngineerName; Job."NS_Architect/Engineer Name") { }
                fieldelement(NSProjectManagerNo; Job."NS_Project Manager No.") { }
                fieldelement(NSProjectManagerName; Job."NS_Project Manager Name") { }
                fieldelement(NSBillingCutoffDayofMonth; Job."NS_Billing Cutoff Day of Month") { }
                fieldelement(NSCCIPOCIPRCOIPInsurance; Job."NS_CCIP/OCIP/RCOIP Insurance") { }
                fieldelement(NSLienWaiverRequired; Job."NS_Lien Waiver Required") { }
                fieldelement(NSUseTaxSKU; Job."NS_Use Tax SKU") { }
                fieldelement(NSCustomerAccount; Job."NS_Customer Account") { }
                fieldelement(NSCreatedfromQuoteNo; Job."NS_Created from Quote No.") { }
                fieldelement(NSQuoteRevision; Job."NS_Quote Revision") { }
                fieldelement(NSUseJobMaterialPlanning; Job."NS_Use Job Material Planning") { }
                fieldelement(NSSelltoCustomerNo; Job."NS_Sell-to Customer No.") { }
                fieldelement(NSSelltoCustomerName; Job."NS_Sell-to Customer Name") { }
                fieldelement(NSLineType; Job."NS_Line Type") { }
                fieldelement(NSEnblGLNResGMCalc; Job."NS_EnblGLNResGMCalc") { }
                fieldelement(NSDFRNos; Job."NS_DFR Nos.") { }
                fieldelement(NSExcludefromJobForecast; Job."NS_Exclude from Job Forecast") { }
                fieldelement(NSUseBillingformat; Job."NS_Use % Billing format") { }
                // fieldelement(NSTaxGroupCodeNew; Job."NS_Tax Group Code New") { }
                fieldelement(NSUseTaxPercentage; Job."NS_Use Tax Percentage") { }
                fieldelement(NSIncludeSubLevels; Job."NS_Include Sub Levels") { }
                fieldelement(NSUseJobPlanLineEntries; Job."NS_Use Job Plan. Line Entries") { }
                fieldelement(NSRootJobNo; Job."NS_Root Job No.") { }
                fieldelement(NSPOCMethod; Job."NS_POC Method") { }
                fieldelement(NSPOCMethodValue; Job."NS_POC Method Value") { }
                fieldelement(NSPOCMethodValueDate; Job."NS_POC Method Value Date") { }
                fieldelement(NSJobPurchaser; Job."NS_Job Purchaser") { }
                fieldelement(NSOpenJobBacklog; Job."NS_Open Job Backlog") { }
                fieldelement(NSDelieveryInstruction; Job."NS_Delievery Instruction") { }

                // fieldelement(NSUseTax; Job."NS_Use Tax") { }
                fieldelement(NSRunBatchOpenJobBacklog; Job."NS_Run Batch Open Job Backlog") { }
                fieldelement(NSOpportunity; Job."NS_Opportunity") { }
            }
        }
    }
    trigger OnPostXmlPort()
    begin
        Message('Job Data Exported Successfully');
    end;

}