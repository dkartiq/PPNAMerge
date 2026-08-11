//PRJCTPR-122.AT.1.0.0 27June23
xmlport 14021108 "NS_JobImport XML"
{

    Caption = 'Import Jobs Lines';
    Direction = Import;
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
                AutoSave = false;
                SourceTableView = where(Number = filter(1));

                textelement(No) { }
                textelement(SearchDescription) { }
                textelement(Description) { }
                textelement(Description2) { }
                textelement(BilltoCustomerNo) { }
                textelement(CreationDate) { }
                textelement(StartingDate) { }
                textelement(EndingDate) { }
                textelement(Status) { }
                textelement(PersonResponsible) { }
                textelement(GlobalDimension1Code) { }
                textelement(GlobalDimension2Code) { }
                textelement(JobPostingGroup) { }
                textelement(Blocked) { }
                textelement(LastDateModified) { }
                textelement(CustomerDiscGroup) { }
                textelement(CustomerPriceGroup) { }
                textelement(LanguageCode) { }
                textelement(BilltoName) { }
                textelement(BilltoAddress) { }
                textelement(BilltoAddress2) { }
                textelement(BilltoCity) { }
                textelement(BilltoCounty) { }
                textelement(BilltoPostCode) { }
                textelement(NoSeries) { }
                textelement(BilltoCountryRegionCode) { }
                textelement(BilltoName2) { }
                textelement(Reserve) { }
                textelement(Image) { }
                textelement(WIPMethod) { }
                textelement(CurrencyCode) { }
                textelement(BilltoContactNo) { }
                textelement(BilltoContact) { }
                textelement(WIPPostingDate) { }
                textelement(InvoiceCurrencyCode) { }
                textelement(ExchCalculationCost) { }
                textelement(ExchCalculationPrice) { }
                textelement(AllowScheduleContractLines) { }
                textelement(Complete) { }
                textelement(ApplyUsageLink) { }
                textelement(WIPPostingMethod) { }
                textelement(OverBudget) { }
                textelement(ProjectManager) { }
                textelement(SelltoCustomerNo) { }
                textelement(SelltoCustomerName) { }
                textelement(SelltoCustomerName2) { }
                textelement(SelltoAddress) { }
                textelement(SelltoAddress2) { }
                textelement(SelltoCity) { }
                textelement(SelltoContact) { }
                textelement(SelltoPostCode) { }
                textelement(SelltoCounty) { }
                textelement(SelltoCountryRegionCode) { }
                textelement(SelltoPhoneNo) { }
                textelement(SelltoEMail) { }
                textelement(SelltoContactNo) { }
                textelement(ShiptoCode) { }
                textelement(ShiptoName) { }
                textelement(ShiptoName2) { }
                textelement(ShiptoAddress) { }
                textelement(ShiptoAddress2) { }
                textelement(ShiptoCity) { }
                textelement(ShiptoContact) { }
                textelement(ShiptoPostCode) { }
                textelement(ShiptoCounty) { }
                textelement(ShiptoCountryRegionCode) { }
                textelement(ExternalDocumentNo) { }
                textelement(PaymentMethodCode) { }
                textelement(PaymentTermsCode) { }
                textelement(YourReference) { }
                textelement(PriceCalculationMethod) { }
                textelement(CostCalculationMethod) { }
                textelement(NSJobAddress1) { }
                textelement(NSJobAddress2) { }
                textelement(NSJobCity) { }
                textelement(NSJobCounty) { }
                textelement(NSJobPostCode) { }
                textelement(NSJobCountryRegionCode) { }
                textelement(NSJobContact) { }
                textelement(NSJobPhone) { }
                textelement(NSJobShiptoCode) { }
                textelement(NSSubLeveltoJobNo) { }
                textelement(NSTempLinkedParentJobNo) { }
                textelement(NSLastJobForJobList) { }
                textelement(NSCopyJob) { }
                textelement(NSJobType) { }
                textelement(NSJobClass) { }
                textelement(NSTimeAndMaterial) { }
                textelement(NSIndirectBurdenType) { }
                textelement(NSSalespersonCode) { }
                textelement(NSEstimator) { }
                textelement(NSManager) { }
                textelement(NSManagerJobStatus) { }
                textelement(NSJobStatusDate) { }
                textelement(NSEstimatedStartDate) { }
                textelement(NSEstimatedCompletionDate) { }
                textelement(NSCompletionDate) { }
                textelement(NSJobPostingDate) { }
                textelement(NSRecognitionDate) { }
                textelement(NSUnitofMeasure) { }
                textelement(NSTotalUnits) { }
                textelement(NSRevenueRecognized) { }
                textelement(NSBillingDayofMonth) { }
                textelement(NSBillingMethod) { }
                textelement(NSRecognitionMethod) { }
                textelement(NSDefaultJobRetention) { }
                textelement(NSForecastType) { }
                textelement(NSTaxAreaCode) { }
                textelement(NSTaxLiable) { }
                textelement(NSTaxGroupCode) { }
                textelement(NSVATBusPostingGroup) { }
                textelement(NSVATProdPostingGroup) { }
                textelement(NSActualPercentComplete) { }
                textelement(NSActualPercentCompleteDate) { }
                textelement(NSActualUnitsComplete) { }
                textelement(NSActualUnitsCompleteDate) { }
                textelement(NSJobRevenuePosting) { }
                textelement(NSProgressBillingNo) { }
                textelement(NSProgressBillingSubLevel) { }
                textelement(NSCustomerJobNo) { }
                textelement(NSCustomerPONumber) { }
                textelement(NSContractNo) { }
                textelement(NSContractDate) { }
                textelement(NSContractFor) { }
                textelement(NSContractType) { }
                textelement(NSContractSellPrice) { }
                textelement(NSRequiresCertifiedPayroll) { }
                textelement(NSGenBusPostingGroupNew) { }
                textelement(NSGenProdPostingGroupNe) { }
                textelement(NSOSFileName) { }
                textelement(NSJobCalendarCode) { }
                textelement(NSPrepaymentNo) { }
                textelement(NSPrepayment) { }
                textelement(NSPrepaymentNoSeries) { }
                textelement(NSCompressPrepayment) { }
                textelement(NSPrepaymentDueDate) { }
                textelement(NSPrepmtCrMemoNoSeries) { }
                textelement(NSPrepmtPaymentTermsCode) { }
                textelement(NSPrepmtPaymentDiscount) { }
                textelement(NSPrepmtCrMemoNo) { }
                textelement(NSPrepaymentAmount) { }
                textelement(NSAmtRecognized) { }
                textelement(NSForecastMethod) { }
                textelement(NSLastForecastPostedDate) { }
                textelement(NSAPComment) { }
                textelement(NSQuoteNo) { }
                textelement(NSJobSiteCustomerNo) { }
                textelement(NSJobSiteCustomerName) { }
                textelement(NSOwnerNo) { }
                textelement(NSOwnerName) { }
                textelement(NSGeneralContractorNo) { }
                textelement(NSGeneralContractorName) { }
                textelement(NSArchitectEngineerNo) { }
                textelement(NSArchitectEngineerName) { }
                textelement(NSProjectManagerNo) { }
                textelement(NSProjectManagerName) { }
                textelement(NSBillingCutoffDayofMonth) { }
                textelement(NSCCIPOCIPRCOIPInsurance) { }
                textelement(NSLienWaiverRequired) { }
                textelement(NSUseTaxSKU) { }
                textelement(NSCustomerAccount) { }
                textelement(NSCreatedfromQuoteNo) { }
                textelement(NSQuoteRevision) { }
                textelement(NSUseJobMaterialPlanning) { }
                textelement(NSSelltoCustomerNo) { }
                textelement(NSSelltoCustomerName) { }
                textelement(NSLineType) { }
                textelement(NSEnblGLNResGMCalc) { }
                textelement(NSDFRNos) { }
                textelement(NSExcludefromJobForecast) { }
                textelement(NSUseBillingformat) { }
                // textelement(NSTaxGroupCodeNew) { }
                textelement(NSUseTaxPercentage) { }
                textelement(NSIncludeSubLevels) { }
                textelement(NSUseJobPlanLineEntries) { }
                textelement(NSRootJobNo) { }
                textelement(NSPOCMethod) { }
                textelement(NSPOCMethodValue) { }
                textelement(NSPOCMethodValueDate) { }
                textelement(NSJobPurchaser) { }
                textelement(NSOpenJobBacklog) { }
                textelement(NSDelieveryInstruction) { }
                // textelement(NSUseTax) { }
                textelement(NSRunBatchOpenJobBacklog) { }
                // textelement(NSNewRunBOpenJobBLog) { }
                // textelement(NSNewBillableInvDif) { }
                textelement(NSOpportunity) { }
                // textelement(NSNewRunBOpenJobBLog) { }
                // textelement(NSNewBillableInvDif) { }



                trigger OnPreXmlItem()
                begin
                    AssignHeaderValues;
                end;

                trigger OnAfterInsertRecord()
                begin
                    InsertData;
                end;

            }
        }

    }

    var
        RecCount: Integer;
        Job: Record Job;

    trigger OnPostXmlPort()
    begin
        Message('Job Data Imported Successfully');
    end;

    LOCAL PROCEDURE AssignHeaderValues();
    BEGIN

        No := job.FieldCaption("No.");
        SearchDescription := job.FieldCaption("Search Description");
        Description := job.FieldCaption("Description");
        Description2 := job.FieldCaption("Description 2");
        BilltoCustomerNo := job.FieldCaption("Bill-to Customer No.");
        CreationDate := job.FieldCaption("Creation Date");
        StartingDate := job.FieldCaption("Starting Date");
        EndingDate := job.FieldCaption("Ending Date");
        Status := job.FieldCaption("Status");
        PersonResponsible := job.FieldCaption("Person Responsible");
        GlobalDimension1Code := job.FieldCaption("Global Dimension 1 Code");
        GlobalDimension2Code := job.FieldCaption("Global Dimension 2 Code");
        JobPostingGroup := job.FieldCaption("Job Posting Group");
        Blocked := job.FieldCaption("Blocked");
        LastDateModified := job.FieldCaption("Last Date Modified");
        CustomerDiscGroup := job.FieldCaption("Customer Disc. Group");
        CustomerPriceGroup := job.FieldCaption("Customer Price Group");
        LanguageCode := job.FieldCaption("Language Code");
        BilltoName := job.FieldCaption("Bill-to Name");
        BilltoAddress := job.FieldCaption("Bill-to Address");
        BilltoAddress2 := job.FieldCaption("Bill-to Address 2");
        BilltoCity := job.FieldCaption("Bill-to City");
        BilltoCounty := job.FieldCaption("Bill-to County");
        BilltoPostCode := job.FieldCaption("Bill-to Post Code");
        NoSeries := job.FieldCaption("No. Series");
        BilltoCountryRegionCode := job.FieldCaption("Bill-to Country/Region Code");
        BilltoName2 := job.FieldCaption("Bill-to Name 2");
        Reserve := job.FieldCaption("Reserve");
        Image := job.FieldCaption("Image");
        WIPMethod := job.FieldCaption("WIP Method");
        CurrencyCode := job.FieldCaption("Currency Code");
        BilltoContactNo := job.FieldCaption("Bill-to Contact No.");
        BilltoContact := job.FieldCaption("Bill-to Contact");
        WIPPostingDate := job.FieldCaption("WIP Posting Date");
        InvoiceCurrencyCode := job.FieldCaption("Invoice Currency Code");
        ExchCalculationCost := job.FieldCaption("Exch. Calculation (Cost)");
        ExchCalculationPrice := job.FieldCaption("Exch. Calculation (Price)");
        AllowScheduleContractLines := job.FieldCaption("Allow Schedule/Contract Lines");
        Complete := job.FieldCaption("Complete");
        ApplyUsageLink := job.FieldCaption("Apply Usage Link");
        WIPPostingMethod := job.FieldCaption("WIP Posting Method");
        OverBudget := job.FieldCaption("Over Budget");
        ProjectManager := job.FieldCaption("Project Manager");
        // SelltoCustomerNo := job.FieldCaption("Sell-to Customer No.");
        SelltoCustomerName := job.FieldCaption("Sell-to Customer Name");
        SelltoCustomerName2 := job.FieldCaption("Sell-to Customer Name 2");
        SelltoAddress := job.FieldCaption("Sell-to Address");
        SelltoAddress2 := job.FieldCaption("Sell-to Address 2");
        SelltoCity := job.FieldCaption("Sell-to City");
        SelltoContact := job.FieldCaption("Sell-to Contact");
        SelltoPostCode := job.FieldCaption("Sell-to Post Code");
        SelltoCounty := job.FieldCaption("Sell-to County");
        SelltoCountryRegionCode := job.FieldCaption("Sell-to Country/Region Code");
        SelltoPhoneNo := job.FieldCaption("Sell-to Phone No.");
        SelltoEMail := job.FieldCaption("Sell-to E-Mail");
        SelltoContactNo := job.FieldCaption("Sell-to Contact No.");
        ShiptoCode := job.FieldCaption("Ship-to Code");
        ShiptoName := job.FieldCaption("Ship-to Name");
        ShiptoName2 := job.FieldCaption("Ship-to Name 2");
        ShiptoAddress := job.FieldCaption("Ship-to Address");
        ShiptoAddress2 := job.FieldCaption("Ship-to Address 2");
        ShiptoCity := job.FieldCaption("Ship-to City");
        ShiptoContact := job.FieldCaption("Ship-to Contact");
        ShiptoPostCode := job.FieldCaption("Ship-to Post Code");
        ShiptoCounty := job.FieldCaption("Ship-to County");
        ShiptoCountryRegionCode := job.FieldCaption("Ship-to Country/Region Code");
        ExternalDocumentNo := job.FieldCaption("External Document No.");
        PaymentMethodCode := job.FieldCaption("Payment Method Code");
        PaymentTermsCode := job.FieldCaption("Payment Terms Code");
        YourReference := job.FieldCaption("Your Reference");
        PriceCalculationMethod := job.FieldCaption("Price Calculation Method");
        CostCalculationMethod := job.FieldCaption("Cost Calculation Method");
        NSJobAddress1 := job.FieldCaption("NS_Job Address 1");
        NSJobAddress2 := job.FieldCaption("NS_Job Address 2");
        NSJobCity := job.FieldCaption("NS_Job City");
        NSJobCounty := job.FieldCaption("NS_Job County");
        NSJobPostCode := job.FieldCaption("NS_Job Post Code");
        NSJobCountryRegionCode := job.FieldCaption("NS_Job Country/Region Code");
        NSJobContact := job.FieldCaption("NS_Job Contact");
        NSJobPhone := job.FieldCaption("NS_Job Phone");
        NSJobShiptoCode := job.FieldCaption("NS_Job Ship-to Code");
        NSSubLeveltoJobNo := job.FieldCaption("NS_Sub-Level to Job No.");
        NSTempLinkedParentJobNo := job.FieldCaption("NS_Temp Linked Parent Job No.");
        NSLastJobForJobList := job.FieldCaption("NS_Last Job For Job List");
        NSCopyJob := job.FieldCaption("NS_CopyJob");
        //NSJobType := job.FieldCaption("NS_Job Type");  //PRJCTPR-298.JS.1.0 16JAN2024
        NSJobType := job.FieldCaption("NS_Job Type New");  //PRJCTPR-298.JS.1.0 16JAN2024
        NSJobClass := job.FieldCaption("NS_Job Class");
        NSTimeAndMaterial := job.FieldCaption("NS_Time And Material");
        NSIndirectBurdenType := job.FieldCaption("NS_Indirect Burden Type");
        NSSalespersonCode := job.FieldCaption("NS_Salesperson Code");
        NSEstimator := job.FieldCaption("NS_Estimator");
        NSManager := job.FieldCaption("NS_Manager");
        NSManagerJobStatus := job.FieldCaption("NS_Manager Job Status");
        NSJobStatusDate := job.FieldCaption("NS_Job Status Date");
        NSEstimatedStartDate := job.FieldCaption("NS_Estimated Start Date");
        NSEstimatedCompletionDate := job.FieldCaption("NS_Estimated Completion Date");
        NSCompletionDate := job.FieldCaption("NS_Completion Date");
        NSJobPostingDate := job.FieldCaption("NS_Job Posting Date");
        NSRecognitionDate := job.FieldCaption("NS_Recognition Date");
        NSUnitofMeasure := job.FieldCaption("NS_Unit of Measure");
        NSTotalUnits := job.FieldCaption("NS_Total Units");
        NSRevenueRecognized := job.FieldCaption("NS_Revenue Recognized");
        NSBillingDayofMonth := job.FieldCaption("NS_Billing Day of Month");
        NSBillingMethod := job.FieldCaption("NS_Billing Method");
        NSRecognitionMethod := job.FieldCaption("NS_Recognition Method");
        NSDefaultJobRetention := job.FieldCaption("NS_Default Job Retention");
        NSForecastType := job.FieldCaption("NS_Forecast Type");
        NSTaxAreaCode := job.FieldCaption("NS_Tax Area Code");
        NSTaxLiable := job.FieldCaption("NS_Tax Liable");
        //NSTaxGroupCode := job.FieldCaption("NS_Tax Group Code");  //PRJCTPR-298.JS.1.0 16JAN2024
        NSTaxGroupCode := job.FieldCaption("NS_Tax Group Code New");  //PRJCTPR-298.JS.1.0 16JAN2024
        NSVATBusPostingGroup := job.FieldCaption("NS_VAT Bus. Posting Group");
        NSVATProdPostingGroup := job.FieldCaption("NS_VAT Prod. Posting Group");
        NSActualPercentComplete := job.FieldCaption("NS_Actual Percent Complete");
        NSActualPercentCompleteDate := job.FieldCaption("NS_Actual PercentCompleteDate");
        NSActualUnitsComplete := job.FieldCaption("NS_Actual Units Complete");
        NSActualUnitsCompleteDate := job.FieldCaption("NS_Actual Units Complete Date");
        NSJobRevenuePosting := job.FieldCaption("NS_Job Revenue Posting");
        NSProgressBillingNo := job.FieldCaption("NS_Progress Billing No.");
        NSProgressBillingSubLevel := job.FieldCaption("NS_Progress Billing Sub-Level");
        NSCustomerJobNo := job.FieldCaption("NS_Customer Job No.");
        NSCustomerPONumber := job.FieldCaption("NS_Customer PO Number");
        NSContractNo := job.FieldCaption("NS_Contract No.");
        NSContractDate := job.FieldCaption("NS_Contract Date");
        NSContractFor := job.FieldCaption("NS_Contract For");
        NSContractType := job.FieldCaption("NS_Contract Type");
        NSContractSellPrice := job.FieldCaption("NS_Contract Sell Price");
        NSRequiresCertifiedPayroll := job.FieldCaption("NS_Requires Certified Payroll");
        NSGenBusPostingGroupNew := job.FieldCaption("NS_Gen. Bus. Posting Group New");
        NSGenProdPostingGroupNe := job.FieldCaption("NS_Gen. Prod. Posting Group New");
        NSOSFileName := job.FieldCaption("NS_OS File Name");
        NSJobCalendarCode := job.FieldCaption("NS_Job Calendar Code");
        NSPrepaymentNo := job.FieldCaption("NS_Prepayment No.");
        NSPrepayment := job.FieldCaption("NS_Prepayment %");
        NSPrepaymentNoSeries := job.FieldCaption("NS_Prepayment No. Series");
        NSCompressPrepayment := job.FieldCaption("NS_Compress Prepayment");
        NSPrepaymentDueDate := job.FieldCaption("NS_Prepayment Due Date");
        NSPrepmtCrMemoNoSeries := job.FieldCaption("NS_Prepmt. Cr. Memo No. Series");
        NSPrepmtPaymentTermsCode := job.FieldCaption("NS_Prepmt. Payment Terms Code");
        NSPrepmtPaymentDiscount := job.FieldCaption("NS_Prepmt. Payment Discount %");
        NSPrepmtCrMemoNo := job.FieldCaption("NS_Prepmt. Cr. Memo No.");
        NSPrepaymentAmount := job.FieldCaption("NS_Prepayment Amount");
        NSAmtRecognized := job.FieldCaption("NS_Amt. Recognized");
        NSForecastMethod := job.FieldCaption("NS_Forecast Method");
        NSLastForecastPostedDate := job.FieldCaption("NS_Last Forecast Posted Date");
        NSAPComment := job.FieldCaption("NS_AP Comment");
        NSQuoteNo := job.FieldCaption("NS_Quote No.");
        NSJobSiteCustomerNo := job.FieldCaption("NS_Job Site Customer No.");
        NSJobSiteCustomerName := job.FieldCaption("NS_Job Site Customer Name");
        NSOwnerNo := job.FieldCaption("NS_Owner No.");
        NSOwnerName := job.FieldCaption("NS_Owner Name");
        NSGeneralContractorNo := job.FieldCaption("NS_General Contractor No.");
        NSGeneralContractorName := job.FieldCaption("NS_General Contractor Name");
        NSArchitectEngineerNo := job.FieldCaption("NS_Architect/Engineer No.");
        NSArchitectEngineerName := job.FieldCaption("NS_Architect/Engineer Name");
        NSProjectManagerNo := job.FieldCaption("NS_Project Manager No.");
        NSProjectManagerName := job.FieldCaption("NS_Project Manager Name");
        NSBillingCutoffDayofMonth := job.FieldCaption("NS_Billing Cutoff Day of Month");
        NSCCIPOCIPRCOIPInsurance := job.FieldCaption("NS_CCIP/OCIP/RCOIP Insurance");
        NSLienWaiverRequired := job.FieldCaption("NS_Lien Waiver Required");
        NSUseTaxSKU := job.FieldCaption("NS_Use Tax SKU");
        NSCustomerAccount := job.FieldCaption("NS_Customer Account");
        NSCreatedfromQuoteNo := job.FieldCaption("NS_Created from Quote No.");
        NSQuoteRevision := job.FieldCaption("NS_Quote Revision");
        NSUseJobMaterialPlanning := job.FieldCaption("NS_Use Job Material Planning");
        NSSelltoCustomerNo := job.FieldCaption("NS_Sell-to Customer No.");
        NSSelltoCustomerName := job.FieldCaption("NS_Sell-to Customer Name");
        NSLineType := job.FieldCaption("NS_Line Type");
        NSEnblGLNResGMCalc := job.FieldCaption("NS_EnblGLNResGMCalc");
        NSDFRNos := job.FieldCaption("NS_DFR Nos.");
        NSExcludefromJobForecast := job.FieldCaption("NS_Exclude from Job Forecast");
        NSUseBillingformat := job.FieldCaption("NS_Use % Billing format");
        // NSTaxGroupCodeNew := job.FieldCaption("NS_Tax Group Code New");
        NSUseTaxPercentage := job.FieldCaption("NS_Use Tax Percentage");
        NSIncludeSubLevels := job.FieldCaption("NS_Include Sub Levels");
        NSUseJobPlanLineEntries := job.FieldCaption("NS_Use Job Plan. Line Entries");
        NSRootJobNo := job.FieldCaption("NS_Root Job No.");
        NSPOCMethod := job.FieldCaption("NS_POC Method");
        NSPOCMethodValue := job.FieldCaption("NS_POC Method Value");
        NSPOCMethodValueDate := job.FieldCaption("NS_POC Method Value Date");
        NSJobPurchaser := job.FieldCaption("NS_Job Purchaser");
        NSOpenJobBacklog := job.FieldCaption("NS_Open Job Backlog");
        NSDelieveryInstruction := job.FieldCaption("NS_Delievery Instruction");
        // NSUseTax := job.FieldCaption("NS_Use Tax");
        NSRunBatchOpenJobBacklog := job.FieldCaption("NS_Run Batch Open Job Backlog");
        NSOpportunity := job.FieldCaption("NS_Opportunity");

    END;

    LOCAL PROCEDURE InsertData();
    VAR



    BEGIN
        IF RecCount <> 0 THEN BEGIN
            //if GuiAllowed then begin
            Job.INIT;
            Job."No." := No;
            Job."Search Description" := SearchDescription;
            Job.INSERT();
            Job."Description" := Description;
            Job."Description 2" := Description2;
            Job."Bill-to Customer No." := BilltoCustomerNo;
            Evaluate(Job."Creation Date", CreationDate);
            Evaluate(Job."Starting Date", StartingDate);
            Evaluate(Job."Ending Date", EndingDate);
            Evaluate(Job."Status", Status);
            Job."Person Responsible" := PersonResponsible;
            Job."Global Dimension 1 Code" := GlobalDimension1Code;
            Job."Global Dimension 2 Code" := GlobalDimension2Code;
            Job."Job Posting Group" := JobPostingGroup;
            Evaluate(Job."Blocked", Blocked);
            Evaluate(Job."Last Date Modified", LastDateModified);
            Job."Customer Disc. Group" := CustomerDiscGroup;
            Job."Customer Price Group" := CustomerPriceGroup;
            Job."Language Code" := LanguageCode;
            Job."Bill-to Name" := BilltoName;
            Job."Bill-to Address" := BilltoAddress;
            Job."Bill-to Address 2" := BilltoAddress2;
            Job."Bill-to City" := BilltoCity;
            Job."Bill-to County" := BilltoCounty;
            Job."Bill-to Post Code" := BilltoPostCode;
            Job."No. Series" := NoSeries;
            Job."Bill-to Country/Region Code" := BilltoCountryRegionCode;
            Job."Bill-to Name 2" := BilltoName2;
            Evaluate(Job."Reserve", Reserve);
            Evaluate(Job."Image", Image);
            Job."WIP Method" := WIPMethod;
            Job."Currency Code" := CurrencyCode;
            Job."Bill-to Contact No." := BilltoContactNo;
            Job."Bill-to Contact" := BilltoContact;
            Evaluate(Job."WIP Posting Date", WIPPostingDate);
            Job."Invoice Currency Code" := InvoiceCurrencyCode;
            Evaluate(Job."Exch. Calculation (Cost)", ExchCalculationCost);
            Evaluate(Job."Exch. Calculation (Price)", ExchCalculationPrice);
            Evaluate(Job."Allow Schedule/Contract Lines", AllowScheduleContractLines);
            Evaluate(Job."Complete", Complete);
            Evaluate(Job."Apply Usage Link", ApplyUsageLink);
            Evaluate(Job."WIP Posting Method", WIPPostingMethod);
            Evaluate(Job."Over Budget", OverBudget);
            Job."Project Manager" := ProjectManager;
            //Job."Sell-to Customer No." := SelltoCustomerNo;// n
            Job."Sell-to Customer Name" := SelltoCustomerName;
            Job."Sell-to Customer Name 2" := SelltoCustomerName2;
            Job."Sell-to Address" := SelltoAddress;
            Job."Sell-to Address 2" := SelltoAddress2;
            Job."Sell-to City" := SelltoCity;
            Job."Sell-to Contact" := SelltoContact;
            Job."Sell-to Post Code" := SelltoPostCode;
            Job."Sell-to County" := SelltoCounty;
            Job."Sell-to Country/Region Code" := SelltoCountryRegionCode;
            Job."Sell-to Phone No." := SelltoPhoneNo;
            Job."Sell-to E-Mail" := SelltoEMail;
            Job."Sell-to Contact No." := SelltoContactNo;
            Job."Ship-to Code" := ShiptoCode;
            Job."Ship-to Name" := ShiptoName;
            Job."Ship-to Name 2" := ShiptoName2;
            Job."Ship-to Address" := ShiptoAddress;
            Job."Ship-to Address 2" := ShiptoAddress2;
            Job."Ship-to City" := ShiptoCity;
            Job."Ship-to Contact" := ShiptoContact;
            Job."Ship-to Post Code" := ShiptoPostCode;
            Job."Ship-to County" := ShiptoCounty;
            Job."Ship-to Country/Region Code" := ShiptoCountryRegionCode;
            Job."External Document No." := ExternalDocumentNo;
            Job."Payment Method Code" := PaymentMethodCode;
            Job."Payment Terms Code" := PaymentTermsCode;
            Job."Your Reference" := YourReference;
            Evaluate(Job."Price Calculation Method", PriceCalculationMethod);
            Evaluate(Job."Cost Calculation Method", CostCalculationMethod);
            Job."NS_Job Address 1" := NSJobAddress1;
            Job."NS_Job Address 2" := NSJobAddress2;
            Job."NS_Job City" := NSJobCity;
            Job."NS_Job County" := NSJobCounty;
            Job."NS_Job Post Code" := NSJobPostCode;
            Job."NS_Job Country/Region Code" := NSJobCountryRegionCode;
            Job."NS_Job Contact" := NSJobContact;
            Job."NS_Job Phone" := NSJobPhone;
            Job."NS_Job Ship-to Code" := NSJobShiptoCode;
            Job."NS_Sub-Level to Job No." := NSSubLeveltoJobNo;
            Job."NS_Temp Linked Parent Job No." := NSTempLinkedParentJobNo;
            Evaluate(Job."NS_Last Job For Job List", NSLastJobForJobList);
            Evaluate(Job."NS_CopyJob", NSCopyJob);
            //Job."NS_Job Type" := NSJobType;  //PRJCTPR-298.JS.1.0 16JAN2024
            Job."NS_Job Type New" := NSJobType;  //PRJCTPR-298.JS.1.0 16JAN2024
            Evaluate(Job."NS_Job Class", NSJobClass);
            Evaluate(Job."NS_Time And Material", NSTimeAndMaterial);
            Evaluate(Job."NS_Indirect Burden Type", NSIndirectBurdenType);
            Job."NS_Salesperson Code" := NSSalespersonCode;
            Job."NS_Estimator" := NSEstimator;
            Job."NS_Manager" := NSManager;
            Evaluate(Job."NS_Manager Job Status", NSManagerJobStatus);
            Evaluate(Job."NS_Job Status Date", NSJobStatusDate);
            Evaluate(Job."NS_Estimated Start Date", NSEstimatedStartDate);
            Evaluate(Job."NS_Estimated Completion Date", NSEstimatedCompletionDate);
            Evaluate(Job."NS_Completion Date", NSCompletionDate);
            Evaluate(Job."NS_Job Posting Date", NSJobPostingDate);
            Evaluate(Job."NS_Recognition Date", NSRecognitionDate);
            Job."NS_Unit of Measure" := NSUnitofMeasure;
            Evaluate(Job."NS_Total Units", NSTotalUnits);
            Evaluate(Job."NS_Revenue Recognized", NSRevenueRecognized);
            Job."NS_Billing Day of Month" := NSBillingDayofMonth;
            Evaluate(Job."NS_Billing Method", NSBillingMethod);
            Evaluate(Job."NS_Recognition Method", NSRecognitionMethod);
            Evaluate(Job."NS_Default Job Retention", NSDefaultJobRetention);
            Evaluate(Job."NS_Forecast Type", NSForecastType);
            Job."NS_Tax Area Code" := NSTaxAreaCode;
            Evaluate(Job."NS_Tax Liable", NSTaxLiable);
            //Job."NS_Tax Group Code" := NSTaxGroupCode;  //PRJCTPR-298.JS.1.0 16JAN2024
            Job."NS_Tax Group Code New" := NSTaxGroupCode; //PRJCTPR-298.JS.1.0 16JAN2024
            Job."NS_VAT Bus. Posting Group" := NSVATBusPostingGroup;
            Job."NS_VAT Prod. Posting Group" := NSVATProdPostingGroup;
            Evaluate(Job."NS_Actual Percent Complete", NSActualPercentComplete);
            Evaluate(Job."NS_Actual PercentCompleteDate", NSActualPercentCompleteDate);
            Evaluate(Job."NS_Actual Units Complete", NSActualUnitsComplete);
            Evaluate(Job."NS_Actual Units Complete Date", NSActualUnitsCompleteDate);
            Evaluate(Job."NS_Job Revenue Posting", NSJobRevenuePosting);
            Job."NS_Progress Billing No." := NSProgressBillingNo;
            Evaluate(Job."NS_Progress Billing Sub-Level", NSProgressBillingSubLevel);
            Job."NS_Customer Job No." := NSCustomerJobNo;
            Job."NS_Customer PO Number" := NSCustomerPONumber;
            Job."NS_Contract No." := NSContractNo;
            Evaluate(Job."NS_Contract Date", NSContractDate);
            Job."NS_Contract For" := NSContractFor;
            Evaluate(Job."NS_Contract Type", NSContractType);
            Evaluate(Job."NS_Contract Sell Price", NSContractSellPrice);
            Evaluate(Job."NS_Requires Certified Payroll", NSRequiresCertifiedPayroll);
            Job."NS_Gen. Bus. Posting Group New" := NSGenBusPostingGroupNew;
            Evaluate(Job."NS_Gen. Prod. Posting Group NeW", NSGenProdPostingGroupNe);
            Job."NS_OS File Name" := NSOSFileName;
            Job."NS_Job Calendar Code" := NSJobCalendarCode;
            Job."NS_Prepayment No." := NSPrepaymentNo;
            Evaluate(Job."NS_Prepayment %", NSPrepayment);
            Job."NS_Prepayment No. Series" := NSPrepaymentNoSeries;
            Evaluate(Job."NS_Compress Prepayment", NSCompressPrepayment);
            Evaluate(Job."NS_Prepayment Due Date", NSPrepaymentDueDate);
            Job."NS_Prepmt. Cr. Memo No. Series" := NSPrepmtCrMemoNoSeries;
            Job."NS_Prepmt. Payment Terms Code" := NSPrepmtPaymentTermsCode;
            Evaluate(Job."NS_Prepmt. Payment Discount %", NSPrepmtPaymentDiscount);
            Job."NS_Prepmt. Cr. Memo No." := NSPrepmtCrMemoNo;
            Evaluate(Job."NS_Prepayment Amount", NSPrepaymentAmount);
            Evaluate(Job."NS_Amt. Recognized", NSAmtRecognized);
            Evaluate(Job."NS_Forecast Method", NSForecastMethod);
            Evaluate(Job."NS_Last Forecast Posted Date", NSLastForecastPostedDate);
            Job."NS_AP Comment" := NSAPComment;
            Job."NS_Quote No." := NSQuoteNo;
            Job."NS_Job Site Customer No." := NSJobSiteCustomerNo;
            Job."NS_Job Site Customer Name" := NSJobSiteCustomerName;
            Job."NS_Owner No." := NSOwnerNo;
            Job."NS_Owner Name" := NSOwnerName;
            Job."NS_General Contractor No." := NSGeneralContractorNo;
            Job."NS_General Contractor Name" := NSGeneralContractorName;
            Job."NS_Architect/Engineer No." := NSArchitectEngineerNo;
            Job."NS_Architect/Engineer Name" := NSArchitectEngineerName;
            Job."NS_Project Manager No." := NSProjectManagerNo;
            Job."NS_Project Manager Name" := NSProjectManagerName;
            EVALUATE(Job."NS_Billing Cutoff Day of Month", NSBillingCutoffDayofMonth);
            EVALUATE(Job."NS_CCIP/OCIP/RCOIP Insurance", NSCCIPOCIPRCOIPInsurance);
            EVALUATE(Job."NS_Lien Waiver Required", NSLienWaiverRequired);
            Job."NS_Use Tax SKU" := NSUseTaxSKU;
            Job."NS_Customer Account" := NSCustomerAccount;
            Job."NS_Created from Quote No." := NSCreatedfromQuoteNo;
            Evaluate(Job."NS_Quote Revision", NSQuoteRevision);
            Evaluate(Job."NS_Use Job Material Planning", NSUseJobMaterialPlanning);
            Job.validate("NS_Sell-to Customer No.", NSSelltoCustomerNo);
            Job."NS_Sell-to Customer Name" := NSSelltoCustomerName;
            Evaluate(Job."NS_Line Type", NSLineType);
            Evaluate(Job."NS_EnblGLNResGMCalc", NSEnblGLNResGMCalc);
            Job."NS_DFR Nos." := NSDFRNos;
            Evaluate(Job."NS_Exclude from Job Forecast", NSExcludefromJobForecast);
            Evaluate(Job."NS_Use % Billing format", NSUseBillingformat);
            // Job."NS_Tax Group Code New" := NSTaxGroupCodeNew;
            Evaluate(Job."NS_Use Tax Percentage", NSUseTaxPercentage);
            Evaluate(Job."NS_Include Sub Levels", NSIncludeSubLevels);
            Evaluate(Job."NS_Use Job Plan. Line Entries", NSUseJobPlanLineEntries);
            Job."NS_Root Job No." := NSRootJobNo;
            Evaluate(Job."NS_POC Method", NSPOCMethod);
            Evaluate(Job."NS_POC Method Value", NSPOCMethodValue);
            Evaluate(Job."NS_POC Method Value Date", NSPOCMethodValueDate);
            Job."NS_Job Purchaser" := NSJobPurchaser;
            Evaluate(Job."NS_Open Job Backlog", NSOpenJobBacklog);
            Job."NS_Delievery Instruction" := NSDelieveryInstruction;
            // Evaluate(Job."NS_Use Tax", NSUseTax);
            Evaluate(Job."NS_Run Batch Open Job Backlog", NSRunBatchOpenJobBacklog);
            Job."NS_Opportunity" := NSOpportunity;
            job.Modify(false);

            UpdateGlobalDimensionValue(167, Job."No.", 1, GlobalDimension1Code);
            UpdateGlobalDimensionValue(167, Job."No.", 2, GlobalDimension2Code);

            //end;
        END ELSE
            RecCount += 1;
    END;


    var
        GLSetupShortcutDimCode: array[8] of Code[20];
        GLSetupGlobalDimCode: array[2] of Code[20];

    procedure GetGLSetupGlobalDim(var GLSetupShortcutDimCode: array[2] of Code[20])
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get();

        GLSetupGlobalDimCode[1] := GLSetup."Global Dimension 1 Code";
        GLSetupGlobalDimCode[2] := GLSetup."Global Dimension 2 Code";
    end;

    procedure UpdateGlobalDimensionValue(TableID: Integer; No: Code[20]; FieldNumber: Integer; GlobalDimCode: Code[20])
    var
        DefaultDim: Record "Default Dimension";
        GLSetup: Record "General Ledger Setup";
        DimensionManagement: Codeunit DimensionManagement;
    begin
        GetGLSetupGlobalDim(GLSetupGlobalDimCode);
        if GlobalDimCode <> '' then begin
            if DefaultDim.Get(TableID, No, GLSetupGlobalDimCode[FieldNumber])
            then begin
                DefaultDim.Validate("Dimension Value Code", GlobalDimCode);
                DefaultDim.Modify();
            end else begin
                DefaultDim.Init();
                DefaultDim."Table ID" := TableID;
                DefaultDim."No." := No;
                DefaultDim."Dimension Code" := GLSetupGlobalDimCode[FieldNumber];
                DefaultDim."Dimension Value Code" := GlobalDimCode;
                DefaultDim.Insert();
            end;
        end;
    end;

}

