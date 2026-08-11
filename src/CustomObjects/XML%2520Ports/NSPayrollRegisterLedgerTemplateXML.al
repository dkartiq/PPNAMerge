
//PE-86.AT 22May23
/// <summary>
/// XmlPort NS_PayrollRegLedTemplate XML (ID 14021107).
/// </summary>
xmlport 14021107 "NS_PayrollRegLedTemplate XML"
{

    Caption = 'Export Internal Expense Lines';
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

                textelement(EmpNoHeader)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EmpNoHeader := payrollregisterledger.FieldCaption(payrollregisterledger."NS_EE ID No.");
                    end;
                }

                textelement(FederalExemptionsHeader)
                {
                    trigger OnBeforePassVariable()
                    begin
                        FederalExemptionsHeader := payrollregisterledger.FieldCaption(payrollregisterledger."NS_Federal Exemptions");
                    end;
                }
                textelement(UnionDuesHeader)
                {
                    trigger OnBeforePassVariable()
                    begin
                        UnionDuesHeader := payrollregisterledger.FieldCaption(payrollregisterledger."NS_Union Dues");
                    end;
                }
                textelement(SocialSecurityNoHeader)
                {
                    trigger OnBeforePassVariable()
                    begin
                        SocialSecurityNoHeader := payrollregisterledger.FieldCaption(payrollregisterledger."NS_Social Security No.");
                    end;
                }
                textelement(PeriodEndDateHeader)
                {
                    trigger OnBeforePassVariable()
                    begin
                        PeriodEndDateHeader := payrollregisterledger.FieldCaption(payrollregisterledger."NS_Period End Date");
                    end;
                }
                textelement(BasicRateHeader)
                {
                    trigger OnBeforePassVariable()
                    begin
                        BasicRateHeader := payrollregisterledger.FieldCaption(payrollregisterledger."NS_Basic Rate");
                    end;
                }
                textelement(RegularHoursHeader)
                {
                    trigger OnBeforePassVariable()
                    begin
                        RegularHoursHeader := payrollregisterledger.FieldCaption(payrollregisterledger."NS_Regular Hours");
                    end;
                }
                textelement(OTHoursHeader)
                {
                    trigger OnBeforePassVariable()
                    begin
                        OTHoursHeader := payrollregisterledger.FieldCaption(payrollregisterledger."NS_OT Hours");
                    end;
                }
                textelement(RegularEarningsHeader)
                {
                    trigger OnBeforePassVariable()
                    begin
                        RegularEarningsHeader := payrollregisterledger.FieldCaption(payrollregisterledger."NS_Regular Earnings");
                    end;
                }
                textelement(OTEarningsHeader)
                {
                    trigger OnBeforePassVariable()
                    begin
                        OTEarningsHeader := payrollregisterledger.FieldCaption(payrollregisterledger."NS_OT Earnings");
                    end;
                }
                textelement(OtherHoursHeader)
                {
                    trigger OnBeforePassVariable()
                    begin
                        OtherHoursHeader := payrollregisterledger.FieldCaption(payrollregisterledger."NS_Other Hours");
                    end;
                }
                textelement(OtherEarningsHeader)
                {
                    trigger OnBeforePassVariable()
                    begin
                        OtherEarningsHeader := payrollregisterledger.FieldCaption(payrollregisterledger."NS_Other Earnings");
                    end;
                }
                textelement(GrossPayHeader)
                {
                    trigger OnBeforePassVariable()
                    begin
                        GrossPayHeader := payrollregisterledger.FieldCaption(payrollregisterledger."NS_Gross Pay");
                    end;
                }
                textelement(FederalTaxHeader)
                {
                    trigger OnBeforePassVariable()
                    begin
                        FederalTaxHeader := payrollregisterledger.FieldCaption(payrollregisterledger."NS_Federal Tax");
                    end;
                }
                textelement(FICAHeader)
                {
                    trigger OnBeforePassVariable()
                    begin
                        FICAHeader := payrollregisterledger.FieldCaption(payrollregisterledger.NS_FICA);
                    end;
                }
                textelement(StateTaxHeader)
                {
                    trigger OnBeforePassVariable()
                    begin
                        StateTaxHeader := payrollregisterledger.FieldCaption(payrollregisterledger."NS_State Tax");
                    end;
                }
                textelement(CityLocalTaxHeader)
                {
                    trigger OnBeforePassVariable()
                    begin
                        CityLocalTaxHeader := payrollregisterledger.FieldCaption(payrollregisterledger."NS_City / Local Tax");
                    end;
                }
                textelement(VoulentaryDeductionsHeader)
                {
                    trigger OnBeforePassVariable()
                    begin
                        VoulentaryDeductionsHeader := payrollregisterledger.FieldCaption(payrollregisterledger."NS_Voulentary Deductions");
                    end;
                }
                textelement(DirectDepositAmountHeader)
                {
                    trigger OnBeforePassVariable()
                    begin
                        DirectDepositAmountHeader := payrollregisterledger.FieldCaption(payrollregisterledger."NS_Direct Deposit Amount");
                    end;
                }
                textelement(NetPayHeader)
                {
                    trigger OnBeforePassVariable()
                    begin
                        NetPayHeader := payrollregisterledger.FieldCaption(payrollregisterledger."NS_Net Pay");
                    end;
                }
                textelement(IncludeinCertifiedPayroll)
                {
                    trigger OnBeforePassVariable()
                    begin
                        IncludeinCertifiedPayroll := payrollregisterledger.FieldCaption(payrollregisterledger."NS_Include in CertifiedPayroll");
                    end;
                }
                textelement(JobNoHeader)
                {
                    trigger OnBeforePassVariable()
                    begin
                        JobNoHeader := payrollregisterledger.FieldCaption(payrollregisterledger."NS_Job No.");
                    end;
                }
                textelement(WorkDateHeader)
                {
                    trigger OnBeforePassVariable()
                    begin
                        WorkDateHeader := payrollregisterledger.FieldCaption(payrollregisterledger."NS_Work Date");
                    end;
                }
                textelement(SkillClassHeader)
                {
                    trigger OnBeforePassVariable()
                    begin
                        SkillClassHeader := payrollregisterledger.FieldCaption(payrollregisterledger."NS_Skill Class");
                    end;
                }
                textelement(PayrollNoHeader)
                {
                    trigger OnBeforePassVariable()
                    begin
                        PayrollNoHeader := payrollregisterledger.FieldCaption(payrollregisterledger."NS_Payroll No.");
                    end;
                }

            }
            tableelement(payrollregisterledger; "NS_Payroll Register Ledger")
            {
                XmlName = 'payrollregisterledger';
                AutoSave = true;
                AutoUpdate = true;
                AutoReplace = false;
                SourceTableView = SORTING("NS_Entry No.");

            }
        }
    }
    trigger OnPostXmlPort()
    begin
        Message('Payroll Register Ledger Entries Template Exported Successfully');
    end;

}
