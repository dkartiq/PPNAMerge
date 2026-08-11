xmlport 14021376 "NS_PAYCHEXRegisterLedgerImport"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PE-40.RM.1.0 02Feb2023 | Added the caption 
    Caption = 'Import Payroll Ledger Entries';  //PE-40.RM.1.0 1Jan2023 
    Direction = Import; //PE-40.RM.1.0 02Feb2023
    //  Direction = Import;  //PE-40.RM.1.0 02Feb2023 commented
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
                    //PE-40.RM.1.0 02Feb2023 Start

                    trigger OnAfterAssignField()
                    var
                        NS_HRSetup: Record "Human Resources Setup";
                    begin
                        NS_HRSetup.Get();
                        if NS_HRSetup."NS_Company ID" <> PayrollRegisterLedger."NS_Company ID" then
                            Error('Company ID =''%1'' doesn''t match with the Company ID = ''%2'' on Human Resources Setup. It must be similar to Company ID = ''%2''', PayrollRegisterLedger."NS_Company ID", NS_HRSetup."NS_Company ID");
                    end;
                    //PE-40.RM.1.0 02Feb2023 End
                }

                //PE-40.RM.1.0 02Feb2023 start

                // textelement(EEIDNo)
                // {
                // }
                fieldelement(EEIDNo; PayrollRegisterLedger."NS_EE ID No.")
                {
                }
                //PE-40.RM.1.0 02Feb2023 End
                fieldelement(EmployeeName; PayrollRegisterLedger."NS_Employee Name")
                {
                }
                //PE-40.RM.1.0 02Feb2023 start
                fieldelement(JobNo; PayrollRegisterLedger."NS_Job No.")
                {
                }
                fieldelement(SkillClass; PayrollRegisterLedger."NS_Skill Class")
                {
                }
                fieldelement(PayrollNo; payrollregisterledger."NS_Payroll No.")
                {
                }
                //PE-40.RM.1.0 02Feb2023 End
                //PE-40.RM.1.0 02Feb2023 start
                // fieldelement(EEAddress1; PayrollRegisterLedger."NS_EE Address 1")
                // {
                // }

                // fieldelement(EEAddress2; PayrollRegisterLedger."NS_EE Address 2")
                // {
                // }

                // fieldelement(EECity; PayrollRegisterLedger."NS_EE City")
                // {
                // }
                // fieldelement(EEState; PayrollRegisterLedger."NS_EE State")
                // {
                // }
                // fieldelement(EEZip; PayrollRegisterLedger."NS_EE Zip")
                // {
                // }
                // fieldelement(EEPhoneNo; PayrollRegisterLedger."NS_EE Phone No.")
                // {
                // }
                // fieldelement(MaritalStatus; PayrollRegisterLedger."NS_Marital Status")
                // {
                // }
                // textelement(GenderText)
                // {
                // }
                //PE-40.RM.1.0 02Feb2023 End
                fieldelement(FederalExemptions; PayrollRegisterLedger."NS_Federal Exemptions")
                {
                }
                //PE-40.RM.1.0 02Feb2023 Start
                // fieldelement(EEOCode; PayrollRegisterLedger."NS_EEO Code")
                // {
                // }
                fieldelement(EmployeeClass; PayrollRegisterLedger."NS_Employee Class") //PE-40.RM.1.0 16Feb2023
                {
                }
                // fieldelement(TradeLicense; PayrollRegisterLedger."NS_Trade License")
                // {
                // }

                // fieldelement(UnionCode; PayrollRegisterLedger."NS_Union Code")
                // {
                // }
                //PE-40.RM.1.0 02Feb2023 End
                fieldelement(UnionDues; PayrollRegisterLedger."NS_Union Dues")
                {
                }
                fieldelement(SocialSecurityNo; PayrollRegisterLedger."NS_Social Security No.")
                {
                }
                fieldelement(PeriodEndDate; PayrollRegisterLedger."NS_Period End Date")
                {
                }
                //PE-40.RM.1.0 02Feb2023 Start
                // fieldelement(CheckNo; PayrollRegisterLedger."NS_Check No.")
                // {
                // }
                // fieldelement(VoucherNo; PayrollRegisterLedger."NS_Voucher No.")
                // {
                // }
                // fieldelement(CostNo; PayrollRegisterLedger."NS_Cost No.")
                // {
                // }
                //PE-40.RM.1.0 02Feb2023 End
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
                //PE-40.RM.1.0 02Feb2023 Start
                // fieldelement(ApprenticePercent; PayrollRegisterLedger."NS_Apprentice Percent")
                // {
                // }
                // fieldelement(OTSupplementalBenefitRate; PayrollRegisterLedger."NS_OT Supplemental BenefitRate")
                // {
                // }
                // fieldelement(PerHeadTax; PayrollRegisterLedger."NS_Per Head Tax")
                // {
                // }
                // fieldelement(RegularSupplementalBenRate; PayrollRegisterLedger."NS_RegularSupplementalBenRate")
                // {
                // }
                // fieldelement(SuppBenefitsEmployeePaid; PayrollRegisterLedger."NS_Supp. BenefitsEmployeePaid")
                // {
                // }
                // fieldelement(SuppBenefitsOtherPaid; PayrollRegisterLedger."NS_Supp. Benefits Other Paid")
                // {
                // }
                // fieldelement(SuppBenefitsUnionPaid; PayrollRegisterLedger."NS_Supp. Benefits Union Paid")
                // {
                // }
                fieldelement(WorkDate; PayrollRegisterLedger."NS_Work Date")
                {
                }

                // fieldelement(SUI; PayrollRegisterLedger.NS_SUI)
                // {
                // }
                //PE-40.RM.1.0 02Feb2023 End
                //PE-40.RM.1.0 02Feb2023 Start
                // fieldelement(SuppBenefitsPaid; PayrollRegisterLedger."NS_Supp. Benefits Paid")
                // {
                // }
                //PE-40.RM.1.0 02Feb2023 End
                trigger OnBeforeInsertRecord() //PE-40.RM.1.0 09Feb2023 start
                var
                    NS_EmpTab: Record Employee;
                    NS_JobTab: Record Job;
                    NS_SkillClass: Record "NS_Skill Class";

                begin
                    NS_EmpTab.Reset();
                    NS_EmpTab.SetRange("No.", PayrollRegisterLedger."NS_EE ID No.");
                    if NS_EmpTab.IsEmpty then
                        Error('Employee doesn''t exist');

                    NS_JobTab.Reset();
                    NS_JobTab.SetRange("No.", PayrollRegisterLedger."NS_Job No.");
                    if NS_JobTab.IsEmpty then
                        Error('Job doesn''t exist');
                    NS_SkillClass.Reset();
                    NS_SkillClass.SetRange(NS_Code, PayrollRegisterLedger."NS_Skill Class");
                    if NS_SkillClass.IsEmpty then
                        Error('Skill Class doesn''t exist');

                    //PE-40.RM.1.0 09Feb2023 End
                    PayrollRegisterLedger."NS_Entry No." := NextEntryNo;

                    // Zero fill EE ID No., the sample data has fields that are 3 long
                    // PayrollRegisterLedger."NS_EE ID No." := COPYSTR(LeadingZeros + EEIDNo, STRLEN(LeadingZeros + EEIDNo) - 2, 3); //PE-40.RM.1.0 09Feb2023 commented

                    //PE-40.RM.1.0 02Feb2023 Start
                    // case GenderText of
                    //     '':
                    //         PayrollRegisterLedger.NS_Gender := PayrollRegisterLedger.NS_Gender::" ";
                    //     Male:
                    //         PayrollRegisterLedger.NS_Gender := PayrollRegisterLedger.NS_Gender::Male;
                    //     Female:
                    //         PayrollRegisterLedger.NS_Gender := PayrollRegisterLedger.NS_Gender::Female;
                    // end;
                    //PE-40.RM.1.0 02Feb2023 End
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
        if not PayrollRegisterLedgerBatch.FIND('-') then //PE-40.RM.1.0 07Feb2023
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

