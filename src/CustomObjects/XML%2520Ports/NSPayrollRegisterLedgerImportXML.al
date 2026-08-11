//PE-86.AT 22May23
/// <summary>
/// XmlPort NS_PayrollRegLedgeImport XML (ID 14021106).
/// </summary>
xmlport 14021106 "NS_PayrollRegLedgeImport XML"
{

    Caption = 'Export Internal Expense Lines';
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
                textelement(EmpNoHeader) { }
                textelement(FederalExemptionsHeader) { }
                textelement(UnionDuesHeader) { }
                textelement(SocialSecurityNoHeader) { }
                textelement(PeriodEndDateHeader) { }
                textelement(BasicRateHeader) { }
                textelement(RegularHoursHeader) { }
                textelement(OTHoursHeader) { }
                textelement(RegularEarningsHeader) { }
                textelement(OTEarningsHeader) { }
                textelement(OtherHoursHeader) { }
                textelement(OtherEarningsHeader) { }
                textelement(GrossPayHeader) { }
                textelement(FederalTaxHeader) { }
                textelement(FICAHeader) { }
                textelement(StateTaxHeader) { }
                textelement(CityLocalTaxHeader) { }
                textelement(VoulentaryDeductionsHeader) { }
                textelement(DirectDepositAmountHeader) { }
                textelement(NetPayHeader) { }
                textelement(IncludeinCertifiedPayroll) { }
                textelement(JobNoHeader) { }
                textelement(WorkDateHeader) { }
                textelement(SkillClassHeader) { }
                textelement(PayrollNoHeader) { }

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
        PayRegLedger: Record "NS_Payroll Register Ledger";

    trigger OnPostXmlPort()
    begin
        Message('Payroll Register Ledger Entries Imported Successfully');
    end;

    LOCAL PROCEDURE AssignHeaderValues();
    BEGIN
        EmpNoHeader := PayRegLedger.FieldCaption("NS_EE ID No.");
        FederalExemptionsHeader := PayRegLedger.FieldCaption("NS_Federal Exemptions");
        UnionDuesHeader := PayRegLedger.FieldCaption("NS_Union Dues");
        SocialSecurityNoHeader := PayRegLedger.FieldCaption("NS_Social Security No.");
        PeriodEndDateHeader := PayRegLedger.FieldCaption("NS_Period End Date");
        BasicRateHeader := PayRegLedger.FieldCaption("NS_Basic Rate");
        RegularHoursHeader := PayRegLedger.FieldCaption("NS_Regular Hours");
        OTHoursHeader := PayRegLedger.FieldCaption("NS_OT Hours");
        RegularEarningsHeader := PayRegLedger.FieldCaption("NS_Regular Earnings");
        OTEarningsHeader := PayRegLedger.FieldCaption("NS_OT Earnings");
        OtherHoursHeader := PayRegLedger.FieldCaption("NS_Other Hours");
        OtherEarningsHeader := PayRegLedger.FieldCaption("NS_Other Earnings");
        GrossPayHeader := PayRegLedger.FieldCaption("NS_Gross Pay");
        FederalTaxHeader := PayRegLedger.FieldCaption("NS_Federal Tax");
        FICAHeader := PayRegLedger.FieldCaption(NS_FICA);
        StateTaxHeader := PayRegLedger.FieldCaption("NS_State Tax");
        CityLocalTaxHeader := PayRegLedger.FieldCaption("NS_City / Local Tax");
        VoulentaryDeductionsHeader := PayRegLedger.FieldCaption("NS_Voulentary Deductions");
        DirectDepositAmountHeader := PayRegLedger.FieldCaption("NS_Direct Deposit Amount");
        NetPayHeader := PayRegLedger.FieldCaption("NS_Net Pay");
        IncludeinCertifiedPayroll := PayRegLedger.FieldCaption("NS_Include in CertifiedPayroll");
        JobNoHeader := PayRegLedger.FieldCaption("NS_Job No.");
        WorkDateHeader := PayRegLedger.FieldCaption("NS_Work Date");
        SkillClassHeader := PayRegLedger.FieldCaption("NS_Skill Class");
        PayrollNoHeader := PayRegLedger.FieldCaption("NS_Payroll No.");



    END;

    LOCAL PROCEDURE InsertData();
    VAR

        PayRegLedger1: Record "NS_Payroll Register Ledger";
        NextEntryNo: Integer;
        HRSetup: Record "Human Resources Setup";
        Emp: Record Employee;
    BEGIN
        HRSetup.Get();
        IF RecCount <> 0 THEN BEGIN
            if PayRegLedger1.FindLast() then
                NextEntryNo := PayRegLedger1."NS_Entry No." + 1
            else
                NextEntryNo := 1;
            PayRegLedger.INIT;
            PayRegLedger."NS_Entry No." := NextEntryNo;
            PayRegLedger."NS_EE ID No." := EmpNoHeader;
            Emp.get(PayRegLedger."NS_EE ID No.");
            PayRegLedger."NS_Employee Name" := Emp."First Name";
            EVALUATE(PayRegLedger."NS_Federal Exemptions", FederalExemptionsHeader);
            EVALUATE(PayRegLedger."NS_Union Dues", UnionDuesHeader);
            EVALUATE(PayRegLedger."NS_Social Security No.", SocialSecurityNoHeader);
            EVALUATE(PayRegLedger."NS_Period End Date", PeriodEndDateHeader);
            EVALUATE(PayRegLedger."NS_Basic Rate", BasicRateHeader);
            EVALUATE(PayRegLedger."NS_Regular Hours", RegularHoursHeader);
            EVALUATE(PayRegLedger."NS_OT Hours", OTHoursHeader);
            EVALUATE(PayRegLedger."NS_Regular Earnings", RegularEarningsHeader);
            EVALUATE(PayRegLedger."NS_OT Earnings", OTEarningsHeader);
            EVALUATE(PayRegLedger."NS_Other Hours", OtherHoursHeader);
            EVALUATE(PayRegLedger."NS_Other Earnings", OtherEarningsHeader);
            EVALUATE(PayRegLedger."NS_Gross Pay", GrossPayHeader);
            EVALUATE(PayRegLedger."NS_Federal Tax", FederalTaxHeader);
            EVALUATE(PayRegLedger.NS_FICA, FICAHeader);
            EVALUATE(PayRegLedger."NS_State Tax", StateTaxHeader);
            EVALUATE(PayRegLedger."NS_City / Local Tax", CityLocalTaxHeader);
            EVALUATE(PayRegLedger."NS_Voulentary Deductions", VoulentaryDeductionsHeader);
            EVALUATE(PayRegLedger."NS_Direct Deposit Amount", DirectDepositAmountHeader);
            EVALUATE(PayRegLedger."NS_Net Pay", NetPayHeader);
            EVALUATE(PayRegLedger."NS_Include in CertifiedPayroll", IncludeinCertifiedPayroll);
            EVALUATE(PayRegLedger."NS_Job No.", JobNoHeader);
            EVALUATE(PayRegLedger."NS_Work Date", WorkDateHeader);
            PayRegLedger."NS_Skill Class" := SkillClassHeader;
            PayRegLedger."NS_Payroll No." := PayrollNoHeader;
            PayRegLedger."NS_Company ID" := HRSetup."NS_Company ID";
            if PayRegLedger."NS_Skill Class" > '' then begin
                PayRegLedger."NS_Employee Class" := UpperCase(CopyStr(PayRegLedger."NS_Skill Class", 1, 2));
            end;

            PayRegLedger.INSERT(true);
        END ELSE
            RecCount += 1;
    END;
}
