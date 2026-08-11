xmlport 14021376 "NS_PAYCHEXRegisterLedgerImport"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Direction = Import;
    Format = VariableText;

    schema
    {
        textelement(paychexpayrollimport)
        {
            XmlName = 'PAYCHEXPayrollImport';
            tableelement(payrollregisterledger; "NS_Payroll Register Ledger")
            {
                AutoReplace = false;
                AutoSave = true;
                AutoUpdate = false;
                XmlName = 'PayrollRegisterLedger';
                SourceTableView = SORTING("NS_Entry No.");
                fieldelement(CompanyID; PayrollRegisterLedger."NS_Company ID")
                {
                }
                textelement(EEIDNo)
                {
                }
                fieldelement(EmployeeName; PayrollRegisterLedger."NS_Employee Name")
                {
                }
                fieldelement(EEAddress1; PayrollRegisterLedger."NS_EE Address 1")
                {
                }
                fieldelement(EEAddress2; PayrollRegisterLedger."NS_EE Address 2")
                {
                }
                fieldelement(EECity; PayrollRegisterLedger."NS_EE City")
                {
                }
                fieldelement(EEState; PayrollRegisterLedger."NS_EE State")
                {
                }
                fieldelement(EEZip; PayrollRegisterLedger."NS_EE Zip")
                {
                }
                fieldelement(EEPhoneNo; PayrollRegisterLedger."NS_EE Phone No.")
                {
                }
                fieldelement(MaritalStatus; PayrollRegisterLedger."NS_Marital Status")
                {
                }
                textelement(GenderText)
                {
                }
                fieldelement(FederalExemptions; PayrollRegisterLedger."NS_Federal Exemptions")
                {
                }
                fieldelement(EEOCode; PayrollRegisterLedger."NS_EEO Code")
                {
                }
                fieldelement(EmployeeClass; PayrollRegisterLedger."NS_Employee Class")
                {
                }
                fieldelement(TradeLicense; PayrollRegisterLedger."NS_Trade License")
                {
                }
                fieldelement(UnionCode; PayrollRegisterLedger."NS_Union Code")
                {
                }
                fieldelement(UnionDues; PayrollRegisterLedger."NS_Union Dues")
                {
                }
                fieldelement(SocialSecurityNo; PayrollRegisterLedger."NS_Social Security No.")
                {
                }
                fieldelement(PeriodEndDate; PayrollRegisterLedger."NS_Period End Date")
                {
                }
                fieldelement(CheckNo; PayrollRegisterLedger."NS_Check No.")
                {
                }
                fieldelement(VoucherNo; PayrollRegisterLedger."NS_Voucher No.")
                {
                }
                fieldelement(CostNo; PayrollRegisterLedger."NS_Cost No.")
                {
                }
                fieldelement(BasicRate; PayrollRegisterLedger."NS_Basic Rate")
                {
                }
                fieldelement(RegularHours; PayrollRegisterLedger."NS_Regular Hours")
                {
                }
                fieldelement(OTHours; PayrollRegisterLedger."NS_OT Hours")
                {
                }
                fieldelement(RegularEarnings; PayrollRegisterLedger."NS_Regular Earnings")
                {
                }
                fieldelement(OTEarnings; PayrollRegisterLedger."NS_OT Earnings")
                {
                }
                fieldelement(OtherHours; PayrollRegisterLedger."NS_Other Hours")
                {
                }
                fieldelement(OtherEarnings; PayrollRegisterLedger."NS_Other Earnings")
                {
                }
                fieldelement(GrossPay; PayrollRegisterLedger."NS_Gross Pay")
                {
                }
                fieldelement(FederalTax; PayrollRegisterLedger."NS_Federal Tax")
                {
                }
                fieldelement(FICA; PayrollRegisterLedger.NS_FICA)
                {
                }
                fieldelement(StateTax; PayrollRegisterLedger."NS_State Tax")
                {
                }
                fieldelement(CityLocalTax; PayrollRegisterLedger."NS_City / Local Tax")
                {
                }
                fieldelement(VoulentaryDeductions; PayrollRegisterLedger."NS_Voulentary Deductions")
                {
                }
                fieldelement(DirectDepositAmount; PayrollRegisterLedger."NS_Direct Deposit Amount")
                {
                }
                fieldelement(NetPay; PayrollRegisterLedger."NS_Net Pay")
                {
                }
                fieldelement(ApprenticePercent; PayrollRegisterLedger."NS_Apprentice Percent")
                {
                }
                fieldelement(OTSupplementalBenefitRate; PayrollRegisterLedger."NS_OT Supplemental BenefitRate")
                {
                }
                fieldelement(PerHeadTax; PayrollRegisterLedger."NS_Per Head Tax")
                {
                }
                fieldelement(RegularSupplementalBenRate; PayrollRegisterLedger."NS_RegularSupplementalBenRate")
                {
                }
                fieldelement(SuppBenefitsEmployeePaid; PayrollRegisterLedger."NS_Supp. BenefitsEmployeePaid")
                {
                }
                fieldelement(SuppBenefitsOtherPaid; PayrollRegisterLedger."NS_Supp. Benefits Other Paid")
                {
                }
                fieldelement(SuppBenefitsUnionPaid; PayrollRegisterLedger."NS_Supp. Benefits Union Paid")
                {
                }
                fieldelement(SUI; PayrollRegisterLedger.NS_SUI)
                {
                }
                fieldelement(SuppBenefitsPaid; PayrollRegisterLedger."NS_Supp. Benefits Paid")
                {
                }

                trigger OnBeforeInsertRecord();
                begin
                    PayrollRegisterLedger."NS_Entry No." := NextEntryNo;

                    // Zero fill EE ID No., the sample data has fields that are 3 long
                    PayrollRegisterLedger."NS_EE ID No." := COPYSTR(LeadingZeros + EEIDNo, STRLEN(LeadingZeros + EEIDNo) - 2, 3);

                    case GenderText of
                        '':
                            PayrollRegisterLedger.NS_Gender := PayrollRegisterLedger.NS_Gender::" ";
                        Male:
                            PayrollRegisterLedger.NS_Gender := PayrollRegisterLedger.NS_Gender::Male;
                        Female:
                            PayrollRegisterLedger.NS_Gender := PayrollRegisterLedger.NS_Gender::Female;
                    end;

                    // Job No. - the Paychex file has '01-' at the beginning of Cost Number field
                    JobNoText := COPYSTR(PayrollRegisterLedger."NS_Cost No.", 4);
                    if Job.GET(JobNoText) then
                        PayrollRegisterLedger."NS_Job No." := JobNoText
                    else begin
                        // remove extra '-' in Cost Numb er field
                        JobNoText := DELCHR(JobNoText, '=', '-');
                        if Job.GET(JobNoText) then
                            PayrollRegisterLedger."NS_Job No." := JobNoText

                    end;




                    if Employee.GET(PayrollRegisterLedger."NS_EE ID No.") then
                        PayrollRegisterLedger."NS_Include in CertifiedPayroll" := Employee."NS_Include in CertifiedPayroll";

                    PayrollRegisterLedger."NS_Date Imported" := PayrollRegisterLedgerBatch."NS_Import Datetime";
                    PayrollRegisterLedger."NS_PR. Register LedgerBatchNo." := PayrollRegisterLedgerBatch."NS_No.";

                    NextEntryNo := NextEntryNo + 1;
                end;
            }
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

    trigger OnPreXmlPort();
    begin
        PayrollRegisterLedgerBatch.SETRANGE("NS_Import Filename", currXMLport.FILENAME);
        if PayrollRegisterLedgerBatch.FIND('-') then
            if not CONFIRM(FileImportedOnce) then ERROR('');
        CLEAR(PayrollRegisterLedgerBatch);

        PayrollRegisterLedgerBatch.INIT;
        PayrollRegisterLedgerBatch."NS_Import Datetime" := CURRENTDATETIME;
        PayrollRegisterLedgerBatch.NS_Username := USERID;
        PayrollRegisterLedgerBatch."NS_Import Filename" := currXMLport.FILENAME;
        PayrollRegisterLedgerBatch.INSERT;

        if PayrollRegisterLedger2.FIND('+') then
            NextEntryNo := PayrollRegisterLedger2."NS_Entry No." + 1
        else
            NextEntryNo := 1;
    end;

    var
        PayrollRegisterLedger2: Record "NS_Payroll Register Ledger";
        NextEntryNo: Integer;
        PayrollRegisterLedgerBatch: Record "NS_Payroll RegisterLedgerBatch";
        Employee: Record Employee;
        Job: Record Job;
        JobNoText: Code[20];
        FileImportedOnce: Label 'File has already been imported once, Continue?';
        LeadingZeros: Label '000000';
        Male: Label 'M';
        Female: Label 'F';
}

