codeunit 14021103 "NS_Payroll Register Management"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------


    trigger OnRun();
    begin
    end;

    var
        Text001: Label 'You must specify %1.';
        Text002: Label '%1 has been set to %2 for %3 records.';

    procedure NS_BatchModifyCertifiedPayrollValue(var PayrollRegisterLedger2: Record "NS_Payroll Register Ledger"; CertifiedPayrollValue: Boolean);
    var
        PayrollRegisterLedger: Record "NS_Payroll Register Ledger";
    begin
        if (PayrollRegisterLedger2.GETFILTER("NS_Period End Date") = '') then
            ERROR(STRSUBSTNO(Text001, PayrollRegisterLedger.FIELDCAPTION("NS_Period End Date")));

        PayrollRegisterLedger.SETCURRENTKEY("NS_Period End Date");
        PayrollRegisterLedger2.COPYFILTER("NS_Period End Date", PayrollRegisterLedger."NS_Period End Date");
        PayrollRegisterLedger2.COPYFILTER("NS_EE ID No.", PayrollRegisterLedger."NS_EE ID No.");

        PayrollRegisterLedger.MODIFYALL("NS_Include in CertifiedPayroll", CertifiedPayrollValue);

        MESSAGE(STRSUBSTNO(Text002, PayrollRegisterLedger2.FIELDCAPTION("NS_Include in CertifiedPayroll"), CertifiedPayrollValue, PayrollRegisterLedger2.COUNT));
    end;
}

