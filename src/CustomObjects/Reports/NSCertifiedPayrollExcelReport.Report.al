report 14021380 "NS_CertifiedPayrollExcelReport"
{
    // ProjectPro - developed and licensed by GEMKO Information Group Inc.   www.dynamicsnavconstruction.com   www.gemko.com
    // 
    // NOTES:
    // 1.  The date being expected is the Payroll Register Ledger."Period End Date".  Other dates will not provide values.
    // 2.  PeriodEndDate & Job No. Both are mandatory to use this report.
    // 
    //PRJ-221.AS.1.0 29MAY2020 Created New report in Layout form by using concepts of "Certified Payroll Excel Report (14021380)" in NAV2017PP, as automation functions are not working in BC versions.
    //PRJ-553.SK.1.0 17FEB2021 Commented some piece of code that will not work in V18 and alos not useful in this report.
    DefaultLayout = RDLC;
    Caption = 'Certified Payroll Excel Report';
    RDLCLayout = './Layouts/NSCertifiedPayrollLayout.rdl';
    PreviewMode = Normal;
    ProcessingOnly = false;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("WH347 TempTable"; "NS_WH347 TempTable")
        {
            DataItemTableView = SORTING("NS_Period End Date", "NS_Job No.", "NS_Employee No.", "NS_Employee Class")
                                WHERE("NS_Job No." = FILTER(<> ''));
            RequestFilterFields = "NS_Job No.";
            column(PayrollCap; PayrollCap)
            {
            }
            column(PersonNotReqCap; PersonNotReqCap)
            {
            }
            column(ForContractOptCap; ForContractOptCap)
            {
            }
            column(NameContractCap; NameContractCap)
            {
            }
            column(AddrCap; AddrCap)
            {
            }
            column(OMBCap; OMBCap)
            {
            }
            column(ExpCap; ExpCap)
            {
            }
            column(PAYROLLNOCap; PAYROLLNOCap)
            {
            }
            column(ForWkBegCap; ForWkBegCap)
            {
            }
            column(ForWkEndCap; ForWkEndCap)
            {
            }
            column(ProjLocCap; ProjLocCap)
            {
            }
            column(ProjContCap; ProjContCap)
            {
            }
            column(NamAddAndCap; NamAddAndCap)
            {
            }
            column(SocSecNOCap; SocSecNOCap)
            {
            }
            column(OfEmpCap; OfEmpCap)
            {
            }
            column(NofWHTDCap; NofWHTDCap)
            {
            }
            column(WorkCap; WorkCap)
            {
            }
            column(ClassfCap; ClassfCap)
            {
            }
            column(OTOrSTCap; OTOrSTCap)
            {
            }
            column(DayDateCap; DayDateCap)
            {
            }
            column(HrWrkEchDayCap; HrWrkEchDayCap)
            {
            }
            column(TotalCap; TotalCap)
            {
            }
            column(RATECap; RATECap)
            {
            }
            column(GROSSCap; GROSSCap)
            {
            }
            column(HOURSCap; HOURSCap)
            {
            }
            column(OFPAYCap; OFPAYCap)
            {
            }
            column(AMOUNTCap; AMOUNTCap)
            {
            }
            column(EARNEDCap; EARNEDCap)
            {
            }
            column(DEDUCTIONSCap; DEDUCTIONSCap)
            {
            }
            column(FICACap; FICACap)
            {
            }
            column(WHTDCap; WHTDCap)
            {
            }
            column(StateTxCap; StateTxCap)
            {
            }
            column(CityLocTaxCap; CityLocTaxCap)
            {
            }
            column(VolDedCap; VolDedCap)
            {
            }
            column(NETWAGESPAIDCap; NETWAGESPAIDCap)
            {
            }
            column(USDepttCap; USDepttCap)
            {
            }
            column(WagHrDivisionCap; WagHrDivisionCap)
            {
            }
            column(StatmComplnceCap; StatmComplnceCap)
            {
            }
            column(PayRLNoCap; PayRLNoCap)
            {
            }
            column(PPDateCap; PPDateCap)
            {
            }
            column(ContrNoCap; ContrNoCap)
            {
            }
            column(DATECap; DATECap)
            {
            }
            column(Day1; Day1)
            {
            }
            column(Day2; Day2)
            {
            }
            column(Day3; Day3)
            {
            }
            column(Day4; Day4)
            {
            }
            column(Day5; Day5)
            {
            }
            column(Day6; Day6)
            {
            }
            column(Day7; Day7)
            {
            }
            //PPDA.1.0 Start
            // column(ComPInfoFedIDNo; ComPInfo."Federal ID No.")
            // {
            // }
            column(ComPInfoFedIDNo; FederalID)
            {
            }
            //PPDA.1.0 End
            column(PeriodEndDate_WH347TempTable; "WH347 TempTable"."NS_Period End Date")
            {
            }
            column(JobNo_WH347TempTable; "WH347 TempTable"."NS_Job No.")
            {
            }
            column(EmployeeNo_WH347TempTable; "WH347 TempTable"."NS_Employee No.")
            {
            }
            column(EmployeeClass_WH347TempTable; "WH347 TempTable"."NS_Employee Class")
            {
            }
            column(Day1RegularHours_WH347TempTable; "WH347 TempTable"."NS_Day 1 Regular Hours")
            {
            }
            column(Day2RegularHours_WH347TempTable; "WH347 TempTable"."NS_Day 2 Regular Hours")
            {
            }
            column(Day3RegularHours_WH347TempTable; "WH347 TempTable"."NS_Day 3 Regular Hours")
            {
            }
            column(Day4RegularHours_WH347TempTable; "WH347 TempTable"."NS_Day 4 Regular Hours")
            {
            }
            column(Day5RegularHours_WH347TempTable; "WH347 TempTable"."NS_Day 5 Regular Hours")
            {
            }
            column(Day6RegularHours_WH347TempTable; "WH347 TempTable"."NS_Day 6 Regular Hours")
            {
            }
            column(Day7RegularHours_WH347TempTable; "WH347 TempTable"."NS_Day 7 Regular Hours")
            {
            }
            column(Day1OvertimeHours_WH347TempTable; "WH347 TempTable"."NS_Day 1 Overtime Hours")
            {
            }
            column(Day2OvertimeHours_WH347TempTable; "WH347 TempTable"."NS_Day 2 Overtime Hours")
            {
            }
            column(Day3OvertimeHours_WH347TempTable; "WH347 TempTable"."NS_Day 3 Overtime Hours")
            {
            }
            column(Day4OvertimeHours_WH347TempTable; "WH347 TempTable"."NS_Day 4 Overtime Hours")
            {
            }
            column(Day5OvertimeHours_WH347TempTable; "WH347 TempTable"."NS_Day 5 Overtime Hours")
            {
            }
            column(Day6OvertimeHours_WH347TempTable; "WH347 TempTable"."NS_Day 6 Overtime Hours")
            {
            }
            column(Day7OvertimeHours_WH347TempTable; "WH347 TempTable"."NS_Day 7 Overtime Hours")
            {
            }
            column(PayrollCode; PayrollCode)
            {
            }
            column(RegEarningsTotal; RegEarningsTotal)
            {
            }
            column(OTearningsTotal; OTearningsTotal)
            {
            }
            column(PayrollRegisterLedgBasicRate; PayrollRegisterLedger."NS_Basic Rate")
            {
            }
            column(PayrollRegisterLedRegularEarnings; PayrollRegisterLedger."NS_Regular Earnings")
            {
            }
            column(PayrollRegisterLedgSocialSecurityNo; PayrollRegisterLedger."NS_Social Security No.")
            {
            }
            column(PayrollRegisterLedGrossPay; PayrollRegisterLedger."NS_Gross Pay")
            {
            }
            column(PayrollRegisterLedgerFederalTax; PayrollRegisterLedger."NS_Federal Tax")
            {
            }
            column(PayrollRegisterLedgerFICA; PayrollRegisterLedger.NS_FICA)
            {
            }
            column(PayrollRegisterLedgCityLocalTax; PayrollRegisterLedger."NS_City / Local Tax")
            {
            }
            column(PayrollRegisterLedgerStateTax; PayrollRegisterLedger."NS_State Tax")
            {
            }
            column(PayrollRegisterLedgerVoulentaryDedc; PayrollRegisterLedger."NS_Voulentary Deductions")
            {
            }
            column(PayrollRegisterLedgerNetPay; PayrollRegisterLedger."NS_Net Pay")
            {
            }
            column(PayrollRegisterLedgerPeriodEndDate; PayrollRegisterLedger."NS_Period End Date")
            {
            }
            column(WeekBeginDate; CALCDATE('-6D', PayrollRegisterLedger."NS_Period End Date"))
            {
            }
            column(PayrollRegisterLedgerJobNo; PayrollRegisterLedger."NS_Job No.")
            {
            }
            column(PayrollRegisterLedgerFedExemp; PayrollRegisterLedger."NS_Federal Exemptions")
            {
            }
            column(PayrollRegisterLedgerEmpName; PayrollRegisterLedger."NS_Employee Name")
            {
            }
            column(EEAdd1; PayrollRegisterLedger."NS_EE Address 1")
            {
            }
            column(EEAdd2; PayrollRegisterLedger."NS_EE Address 2")
            {
            }
            column(EECity; PayrollRegisterLedger."NS_EE City")
            {
            }
            column(EEState; PayrollRegisterLedger."NS_EE State")
            {
            }
            column(EEZip; PayrollRegisterLedger."NS_EE Zip")
            {
            }
            column(EEPhone; PayrollRegisterLedger."NS_EE Phone No.")
            {
            }
            column(PayrollRegSkillClass; PayrollRegisterLedger."NS_Skill Class")
            {
            }
            column(MaskedSSNToShow; MaskedSSNToShow)
            {
            }
            column(HRWH347ContName; HumanResourceSetup."NS_WH 347 Contractor Name")
            {
            }
            column(HRWH347Addr1; HumanResourceSetup."NS_WH 347 Address 1")
            {
            }
            column(HRWH347Addr2; HumanResourceSetup."NS_WH 347 Address 2")
            {
            }
            column(HRWH347SignatoryP; HumanResourceSetup."NS_WH 347 Signatory Party")
            {
            }
            column(HRWH347Title; HumanResourceSetup."NS_WH 347 Title")
            {
            }
            column(reg1; reg1)
            {
            }
            column(reg2; reg2)
            {
            }
            column(reg3; reg3)
            {
            }
            column(reg4; reg4)
            {
            }
            column(reg5; reg5)
            {
            }
            column(reg6; reg6)
            {
            }
            column(reg7; reg7)
            {
            }
            column(ot1; ot1)
            {
            }
            column(ot2; ot2)
            {
            }
            column(ot3; ot3)
            {
            }
            column(ot4; ot4)
            {
            }
            column(ot5; ot5)
            {
            }
            column(ot6; ot6)
            {
            }
            column(ot7; ot7)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CLEAR(EmpCode);
                CLEAR(RegEarningsTotal);
                CLEAR(OTearningsTotal);
                CLEAR(PayrollCode);

                // Get appropriate PayrollRegisterLedger record
                PayrollRegisterLedger.SETCURRENTKEY("NS_Job No.", "NS_Period End Date", "NS_Include in CertifiedPayroll", "NS_EE ID No.", "NS_Employee Class");
                PayrollRegisterLedger.SETRANGE("NS_Job No.", "WH347 TempTable"."NS_Job No.");
                PayrollRegisterLedger.SETRANGE("NS_Period End Date", "WH347 TempTable"."NS_Period End Date");
                PayrollRegisterLedger.SETRANGE("NS_Include in CertifiedPayroll", TRUE);
                PayrollRegisterLedger.SETRANGE("NS_EE ID No.", "WH347 TempTable"."NS_Employee No.");
                PayrollRegisterLedger.SETRANGE("NS_Employee Class", "WH347 TempTable"."NS_Employee Class");
                PayrollRegisterLedger.FIND('-');

                IF PayrollRegisterLedger."NS_EE ID No." <> EmpCode THEN BEGIN
                    PayrollRegisterLedger2.SETCURRENTKEY("NS_Job No.", "NS_Period End Date", "NS_Include in CertifiedPayroll", "NS_EE ID No.", "NS_Employee Class");
                    PayrollRegisterLedger2.SETRANGE("NS_Job No.", "WH347 TempTable"."NS_Job No.");
                    PayrollRegisterLedger2.SETRANGE("NS_Period End Date", "WH347 TempTable"."NS_Period End Date");
                    PayrollRegisterLedger2.SETRANGE("NS_Include in CertifiedPayroll", TRUE);
                    PayrollRegisterLedger2.SETRANGE("NS_EE ID No.", "WH347 TempTable"."NS_Employee No.");
                    PayrollRegisterLedger2.SETRANGE("NS_Employee Class", "WH347 TempTable"."NS_Employee Class");
                    IF PayrollRegisterLedger2.FINDSET THEN
                        REPEAT
                            RegEarningsTotal += PayrollRegisterLedger2."NS_Regular Earnings";
                            OTearningsTotal += PayrollRegisterLedger2."NS_OT Earnings";
                        UNTIL PayrollRegisterLedger2.NEXT = 0;

                    //PayrollNo. Data - start
                    IF "WH347 TempTable"."NS_Job No." <> JobCode THEN BEGIN
                        PayrollRegisterLedger2.RESET;
                        PayrollRegisterLedger2.SETCURRENTKEY("NS_Job No.", "NS_Period End Date", "NS_Include in CertifiedPayroll", "NS_EE ID No.", "NS_Employee Class");
                        PayrollRegisterLedger2.SETRANGE("NS_Job No.", "WH347 TempTable"."NS_Job No.");
                        PayrollRegisterLedger2.SETRANGE("NS_Period End Date", "WH347 TempTable"."NS_Period End Date");
                        PayrollRegisterLedger2.SETRANGE("NS_Include in CertifiedPayroll", TRUE);
                        PayrollRegisterLedger2.SETRANGE("NS_EE ID No.", "WH347 TempTable"."NS_Employee No.");
                        PayrollRegisterLedger2.SETRANGE("NS_Employee Class", "WH347 TempTable"."NS_Employee Class");
                        IF PayrollRegisterLedger2.FINDFIRST THEN
                            PayrollCode := PayrollRegisterLedger2."NS_Payroll No.";
                    END;
                    //PayrollNo. Data - end

                    //REG OT HRS Data - start
                    IF HumanResourceSetup."NS_Payroll Week Ending Day" = HumanResourceSetup."NS_Payroll Week Ending Day"::Sunday THEN BEGIN
                        CLEAR(reg1);
                        CLEAR(reg2);
                        CLEAR(reg3);
                        CLEAR(reg4);
                        CLEAR(reg5);
                        CLEAR(reg6);
                        CLEAR(reg7);
                        CLEAR(ot1);
                        CLEAR(ot2);
                        CLEAR(ot3);
                        CLEAR(ot4);
                        CLEAR(ot5);
                        CLEAR(ot6);
                        CLEAR(ot7);
                        PayrollRegisterLedger_L.RESET();
                        PayrollRegisterLedger_L.SETCURRENTKEY("NS_Job No.", "NS_Period End Date", "NS_Include in CertifiedPayroll", "NS_EE ID No.", "NS_Employee Class");
                        PayrollRegisterLedger_L.SETRANGE("NS_Job No.", "WH347 TempTable"."NS_Job No.");
                        PayrollRegisterLedger_L.SETRANGE("NS_Work Date", date7);
                        PayrollRegisterLedger_L.SETRANGE("NS_Include in CertifiedPayroll", TRUE);
                        PayrollRegisterLedger_L.SETRANGE("NS_EE ID No.", "WH347 TempTable"."NS_Employee No.");
                        PayrollRegisterLedger_L.SETRANGE("NS_Employee Class", "WH347 TempTable"."NS_Employee Class");
                        IF PayrollRegisterLedger_L.FINDSET THEN
                            REPEAT
                                reg1 += PayrollRegisterLedger_L."NS_Regular Hours";
                                ot1 += PayrollRegisterLedger_L."NS_OT Hours";
                            UNTIL PayrollRegisterLedger_L.NEXT = 0;

                        PayrollRegisterLedger_L.SETRANGE("NS_Work Date", date6);
                        IF PayrollRegisterLedger_L.FINDSET THEN
                            REPEAT
                                reg2 += PayrollRegisterLedger_L."NS_Regular Hours";
                                ot2 += PayrollRegisterLedger_L."NS_OT Hours";
                            UNTIL PayrollRegisterLedger_L.NEXT = 0;

                        PayrollRegisterLedger_L.SETRANGE("NS_Work Date", date5);
                        IF PayrollRegisterLedger_L.FINDSET THEN
                            REPEAT
                                reg3 += PayrollRegisterLedger_L."NS_Regular Hours";
                                ot3 += PayrollRegisterLedger_L."NS_OT Hours";
                            UNTIL PayrollRegisterLedger_L.NEXT = 0;

                        PayrollRegisterLedger_L.SETRANGE("NS_Work Date", date4);
                        IF PayrollRegisterLedger_L.FINDSET THEN
                            REPEAT
                                reg4 += PayrollRegisterLedger_L."NS_Regular Hours";
                                ot4 += PayrollRegisterLedger_L."NS_OT Hours";
                            UNTIL PayrollRegisterLedger_L.NEXT = 0;

                        PayrollRegisterLedger_L.SETRANGE("NS_Work Date", date3);
                        IF PayrollRegisterLedger_L.FINDSET THEN
                            REPEAT
                                reg5 += PayrollRegisterLedger_L."NS_Regular Hours";
                                ot5 += PayrollRegisterLedger_L."NS_OT Hours";
                            UNTIL PayrollRegisterLedger_L.NEXT = 0;

                        PayrollRegisterLedger_L.SETRANGE("NS_Work Date", date2);
                        IF PayrollRegisterLedger_L.FINDSET THEN
                            REPEAT
                                reg6 += PayrollRegisterLedger_L."NS_Regular Hours";
                                ot6 += PayrollRegisterLedger_L."NS_OT Hours";
                            UNTIL PayrollRegisterLedger_L.NEXT = 0;


                        PayrollRegisterLedger_L.SETRANGE("NS_Work Date", date1);
                        IF PayrollRegisterLedger_L.FINDSET THEN
                            REPEAT
                                reg7 += PayrollRegisterLedger_L."NS_Regular Hours";
                                ot7 += PayrollRegisterLedger_L."NS_OT Hours";
                            UNTIL PayrollRegisterLedger_L.NEXT = 0;
                    END;
                    //REG OT HRS Data - end
                    // Regular Earnings Total - End


                    //REG OT HRS Data - start
                    IF HumanResourceSetup."NS_Payroll Week Ending Day" = HumanResourceSetup."NS_Payroll Week Ending Day"::Saturday THEN BEGIN
                        CLEAR(reg1);
                        CLEAR(reg2);
                        CLEAR(reg3);
                        CLEAR(reg4);
                        CLEAR(reg5);
                        CLEAR(reg6);
                        CLEAR(reg7);
                        CLEAR(ot1);
                        CLEAR(ot2);
                        CLEAR(ot3);
                        CLEAR(ot4);
                        CLEAR(ot5);
                        CLEAR(ot6);
                        CLEAR(ot7);
                        PayrollRegisterLedger_L.RESET();
                        PayrollRegisterLedger_L.SETCURRENTKEY("NS_Job No.", "NS_Period End Date", "NS_Include in CertifiedPayroll", "NS_EE ID No.", "NS_Employee Class");
                        PayrollRegisterLedger_L.SETRANGE("NS_Job No.", "WH347 TempTable"."NS_Job No.");
                        PayrollRegisterLedger_L.SETRANGE("NS_Work Date", date7);
                        PayrollRegisterLedger_L.SETRANGE("NS_Include in CertifiedPayroll", TRUE);
                        PayrollRegisterLedger_L.SETRANGE("NS_EE ID No.", "WH347 TempTable"."NS_Employee No.");
                        PayrollRegisterLedger_L.SETRANGE("NS_Employee Class", "WH347 TempTable"."NS_Employee Class");
                        IF PayrollRegisterLedger_L.FINDSET THEN
                            REPEAT
                                reg1 += PayrollRegisterLedger_L."NS_Regular Hours";
                                ot1 += PayrollRegisterLedger_L."NS_OT Hours";
                            UNTIL PayrollRegisterLedger_L.NEXT = 0;

                        PayrollRegisterLedger_L.SETRANGE("NS_Work Date", date6);
                        IF PayrollRegisterLedger_L.FINDSET THEN
                            REPEAT
                                reg2 += PayrollRegisterLedger_L."NS_Regular Hours";
                                ot2 += PayrollRegisterLedger_L."NS_OT Hours";
                            UNTIL PayrollRegisterLedger_L.NEXT = 0;

                        PayrollRegisterLedger_L.SETRANGE("NS_Work Date", date5);
                        IF PayrollRegisterLedger_L.FINDSET THEN
                            REPEAT
                                reg3 += PayrollRegisterLedger_L."NS_Regular Hours";
                                ot3 += PayrollRegisterLedger_L."NS_OT Hours";
                            UNTIL PayrollRegisterLedger_L.NEXT = 0;

                        PayrollRegisterLedger_L.SETRANGE("NS_Work Date", date4);
                        IF PayrollRegisterLedger_L.FINDSET THEN
                            REPEAT
                                reg4 += PayrollRegisterLedger_L."NS_Regular Hours";
                                ot4 += PayrollRegisterLedger_L."NS_OT Hours";
                            UNTIL PayrollRegisterLedger_L.NEXT = 0;

                        PayrollRegisterLedger_L.SETRANGE("NS_Work Date", date3);
                        IF PayrollRegisterLedger_L.FINDSET THEN
                            REPEAT
                                reg5 += PayrollRegisterLedger_L."NS_Regular Hours";
                                ot5 += PayrollRegisterLedger_L."NS_OT Hours";
                            UNTIL PayrollRegisterLedger_L.NEXT = 0;

                        PayrollRegisterLedger_L.SETRANGE("NS_Work Date", date2);
                        IF PayrollRegisterLedger_L.FINDSET THEN
                            REPEAT
                                reg6 += PayrollRegisterLedger_L."NS_Regular Hours";
                                ot6 += PayrollRegisterLedger_L."NS_OT Hours";
                            UNTIL PayrollRegisterLedger_L.NEXT = 0;


                        PayrollRegisterLedger_L.SETRANGE("NS_Work Date", date1);
                        IF PayrollRegisterLedger_L.FINDSET THEN
                            REPEAT
                                reg7 += PayrollRegisterLedger_L."NS_Regular Hours";
                                ot7 += PayrollRegisterLedger_L."NS_OT Hours";
                            UNTIL PayrollRegisterLedger_L.NEXT = 0;
                    END;
                    //REG OT HRS Data - end
                    // Regular Earnings Total - End
                END;


                Job.GET("WH347 TempTable"."NS_Job No.");

                IF PreviousJobNo <> CurrentJobNo THEN BEGIN
                    //PRJ-553.1.0 Start
                    // TempBlob.INIT;
                    // HumanResourceSetup.CALCFIELDS("NS_WH 347 XLS Template");
                    // TempBlob.Blob := HumanResourceSetup."NS_WH 347 XLS Template";
                    //PRJ-553.1.0 End
                END;
                WriteHeaderData;
                MarkSSNFtn;
                PreviousJobNo := CurrentJobNo;
                EmpCode := PayrollRegisterLedger."NS_EE ID No.";
                JobCode := "WH347 TempTable"."NS_Job No.";
            end;

            trigger OnPreDataItem()
            begin
                CLEAR(Day1);
                CLEAR(Day2);
                CLEAR(Day3);
                CLEAR(Day4);
                CLEAR(Day5);
                CLEAR(Day6);
                CLEAR(Day7);

                HumanResourceSetup.GET;
                ComPInfo.GET;
                OnBeforeSetFederalID(FederalID);//PPDA.1.0 Added
                PreviousJobNo := '';
                CurrentJobNo := '';


                // Dates Calculation - start
                IF (HumanResourceSetup."NS_Payroll Week Ending Day" = HumanResourceSetup."NS_Payroll Week Ending Day"::Saturday)
                THEN BEGIN
                    CLEAR(date1);
                    CLEAR(date2);
                    CLEAR(date3);
                    CLEAR(date4);
                    CLEAR(date5);
                    CLEAR(date6);
                    CLEAR(date7);


                    UsedPEDate := PeriodEndDate;
                    date1 := UsedPEDate;
                    Day1 := STRSUBSTNO('%1/%2', DATE2DMY(UsedPEDate, 2), DATE2DMY(UsedPEDate, 1));
                    UsedPEDate := CALCDATE('-1D', PeriodEndDate);
                    date2 := UsedPEDate;
                    Day2 := STRSUBSTNO('%1/%2', DATE2DMY(UsedPEDate, 2), DATE2DMY(UsedPEDate, 1));
                    UsedPEDate := CALCDATE('-2D', PeriodEndDate);
                    date3 := UsedPEDate;
                    Day3 := STRSUBSTNO('%1/%2', DATE2DMY(UsedPEDate, 2), DATE2DMY(UsedPEDate, 1));
                    UsedPEDate := CALCDATE('-3D', PeriodEndDate);
                    date4 := UsedPEDate;
                    Day4 := STRSUBSTNO('%1/%2', DATE2DMY(UsedPEDate, 2), DATE2DMY(UsedPEDate, 1));
                    UsedPEDate := CALCDATE('-4D', PeriodEndDate);
                    date5 := UsedPEDate;
                    Day5 := STRSUBSTNO('%1/%2', DATE2DMY(UsedPEDate, 2), DATE2DMY(UsedPEDate, 1));
                    UsedPEDate := CALCDATE('-5D', PeriodEndDate);
                    date6 := UsedPEDate;
                    Day6 := STRSUBSTNO('%1/%2', DATE2DMY(UsedPEDate, 2), DATE2DMY(UsedPEDate, 1));
                    UsedPEDate := CALCDATE('-6D', PeriodEndDate);
                    date7 := UsedPEDate;
                    Day7 := STRSUBSTNO('%1/%2', DATE2DMY(UsedPEDate, 2), DATE2DMY(UsedPEDate, 1));
                END;

                IF (HumanResourceSetup."NS_Payroll Week Ending Day" = HumanResourceSetup."NS_Payroll Week Ending Day"::Sunday) THEN BEGIN
                    CLEAR(date1);
                    CLEAR(date2);
                    CLEAR(date3);
                    CLEAR(date4);
                    CLEAR(date5);
                    CLEAR(date6);
                    CLEAR(date7);
                    IF PeriodEndDate <> 0D THEN
                        UsedPEDate := PeriodEndDate;
                    date7 := UsedPEDate;
                    Day7 := STRSUBSTNO('%1/%2', DATE2DMY(UsedPEDate, 2), DATE2DMY(UsedPEDate, 1));
                    UsedPEDate := CALCDATE('-1D', PeriodEndDate);
                    date1 := UsedPEDate;
                    Day1 := STRSUBSTNO('%1/%2', DATE2DMY(UsedPEDate, 2), DATE2DMY(UsedPEDate, 1));
                    UsedPEDate := CALCDATE('-2D', PeriodEndDate);
                    date2 := UsedPEDate;
                    Day2 := STRSUBSTNO('%1/%2', DATE2DMY(UsedPEDate, 2), DATE2DMY(UsedPEDate, 1));
                    UsedPEDate := CALCDATE('-3D', PeriodEndDate);
                    date3 := UsedPEDate;
                    Day3 := STRSUBSTNO('%1/%2', DATE2DMY(UsedPEDate, 2), DATE2DMY(UsedPEDate, 1));
                    UsedPEDate := CALCDATE('-4D', PeriodEndDate);
                    date4 := UsedPEDate;
                    Day4 := STRSUBSTNO('%1/%2', DATE2DMY(UsedPEDate, 2), DATE2DMY(UsedPEDate, 1));
                    UsedPEDate := CALCDATE('-5D', PeriodEndDate);
                    date5 := UsedPEDate;
                    Day5 := STRSUBSTNO('%1/%2', DATE2DMY(UsedPEDate, 2), DATE2DMY(UsedPEDate, 1));
                    UsedPEDate := CALCDATE('-6D', PeriodEndDate);
                    date6 := UsedPEDate;
                    Day6 := STRSUBSTNO('%1/%2', DATE2DMY(UsedPEDate, 2), DATE2DMY(UsedPEDate, 1));
                END;
                // Dates Calculation - End
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field(PeriodEndDate; PeriodEndDate)
                {
                    Caption = 'Period End Date';
                    NotBlank = true;
                    ApplicationArea = all;
                }
            }
        }

        actions
        {
        }

        trigger OnClosePage()
        var
            PayrollRegisterLedger2: Record "NS_Payroll Register Ledger";
        begin
            IF PeriodEndDate = 0D THEN
                ERROR(STRSUBSTNO(Text001, 'Period End Date'));

            "WH347 TempTable".DELETEALL;

            HRSetup.GET;
            CLEAR(JobNoValue);

            JobNoValue := "WH347 TempTable".GETFILTER("NS_Job No.");
            IF HRSetup."NS_Payroll Week Ending Day" = HRSetup."NS_Payroll Week Ending Day"::Saturday THEN BEGIN
                PayrollRegisterLedger2.SETRANGE("NS_Job No.", "WH347 TempTable".GETFILTER("NS_Job No."));
                PayrollRegisterLedger2.SETRANGE("NS_Period End Date", PeriodEndDate);
                IF PayrollRegisterLedger2.FIND('-') THEN
                    REPEAT
                        CreateWH347TempTable(PayrollRegisterLedger2."NS_Period End Date", PayrollRegisterLedger2."NS_Job No.", PayrollRegisterLedger2."NS_EE ID No.", PayrollRegisterLedger2."NS_Employee Class");
                    UNTIL (PayrollRegisterLedger2.NEXT = 0);
            END;

            IF HRSetup."NS_Payroll Week Ending Day" = HRSetup."NS_Payroll Week Ending Day"::Sunday THEN BEGIN
                WITH "WH347 TempTable" DO BEGIN
                    PayrollRegisterLedger2.RESET;
                    PayrollRegisterLedger2.SETRANGE("NS_Job No.", "WH347 TempTable".GETFILTER("NS_Job No."));
                    PayrollRegisterLedger2.SETRANGE("NS_Period End Date", PeriodEndDate);
                    // PayrollRegisterLedger2.SETRANGE("EE ID No.",EmpCode);
                    IF PayrollRegisterLedger2.FIND('-') THEN
                        REPEAT
                            IF EmpNo <> PayrollRegisterLedger2."NS_EE ID No." THEN BEGIN
                                IF NOT WH347TempTable_G.GET(PeriodEndDate, JobNoValue, PayrollRegisterLedger2."NS_EE ID No.", PayrollRegisterLedger2."NS_Employee Class") THEN BEGIN
                                    INIT;
                                    "NS_Period End Date" := PeriodEndDate;
                                    "NS_Employee No." := PayrollRegisterLedger2."NS_EE ID No.";
                                    "NS_Employee Class" := PayrollRegisterLedger2."NS_Employee Class";
                                    "NS_Job No." := JobNoValue;
                                    INSERT;
                                END;
                            END;
                            EmpNo := PayrollRegisterLedger2."NS_EE ID No.";
                        UNTIL PayrollRegisterLedger2.NEXT = 0;

                END;
            END;
        end;

        trigger OnOpenPage()
        begin
            WH347TempTable_G.RESET;
            WH347TempTable_G.SETFILTER("NS_Period End Date", '<>%1');
            IF WH347TempTable_G.FINDSET THEN
                WH347TempTable_G.DELETEALL;
        end;
    }

    labels
    {
    }

    var

        CompInfo: Record "Company Information";
        FederalID: text[100];
        WH347TempTable_G: Record "NS_WH347 TempTable";
        HumanResourceSetup: Record "Human Resources Setup";
        HRSetup: Record "Human Resources Setup";
        Job: Record Job;
        //TempBlob: Record TempBlob temporary;//Removing this because of V19 removal process
        PayrollRegisterLedger: Record "NS_Payroll Register Ledger";
        PayrollRegisterLedger2: Record "NS_Payroll Register Ledger";
        PayrollRegisterLedger_L: Record "NS_Payroll Register Ledger";
        DateTable: Record Date;
        PreviousJobNo: Code[20];
        CurrentJobNo: Code[20];
        LineNo: Integer;
        i: Integer;
        PeriodEndDate: Date;
        TempDate: Date;
        DayOfTheWeek: array[7] of Text[10];
        SSNMask: Label '###-##-';
        ColA: Label 'A';
        ColB: Label 'B';
        ColC: Label 'C';
        ColD: Label 'D';
        ColE: Label 'E';
        ColF: Label 'F';
        ColG: Label 'G';
        ColH: Label 'H';
        ColI: Label 'I';
        ColJ: Label 'J';
        ColK: Label 'K';
        ColL: Label 'L';
        ColM: Label 'M';
        ColN: Label 'N';
        ColO: Label 'O';
        ColP: Label 'P';
        ColQ: Label 'Q';
        ColR: Label 'R';
        ColS: Label 'S';
        ColT: Label 'T';
        ColU: Label 'U';
        Row1: Label '1';
        Row5: Label '5';
        Row6: Label '6';
        Row8: Label '8';
        Row9: Label '9';
        Row10: Label '10';
        Row11: Label '11';
        Row12: Label '12';
        Row13: Label '13';
        Row15: Label '15';
        Row16: Label '16';
        Row18: Label '18';
        Row20: Label '20';
        PayrollCap: Label 'PAYROLL';
        PersonNotReqCap: Label 'Persons are not required to respond to the collection of information unless it displays a currently valid OMB control number.';
        ForContractOptCap: Label '(For Contractor''s Optional Use; See Instruction, Form WH-347 Inst.)';
        NameContractCap: Label 'Name of Contractor:';
        AddrCap: Label 'Address:';
        OMBCap: Label 'OMB No.:';
        ExpCap: Label 'Expires:';
        PAYROLLNOCap: Label 'Payroll No.: ';
        ForWkBegCap: Label 'For Week Begining:';
        ForWkEndCap: Label 'For Week Ending:';
        ProjLocCap: Label 'Project and Location:';
        ProjContCap: Label 'Project and Contract No.:';
        NamAddAndCap: Label 'NAME, ADDRESS, AND';
        SocSecNOCap: Label 'SOCIAL SECURITY NO.';
        OfEmpCap: Label 'OF EMPLOYEE';
        NofWHTDCap: Label 'NO. OF WITHHOLDING EXEMPTIONS';
        WorkCap: Label 'WORK';
        ClassfCap: Label 'CLASSIFICATION';
        OTOrSTCap: Label 'OT. Or ST.';
        DayDateCap: Label 'DAY & DATE';
        HrWrkEchDayCap: Label 'HOURS WORKED EACH DAY';
        TotalCap: Label 'TOTAL';
        RATECap: Label 'RATE';
        GROSSCap: Label 'GROSS';
        HOURSCap: Label 'HOURS';
        OFPAYCap: Label 'OF PAY';
        AMOUNTCap: Label 'AMOUNT';
        EARNEDCap: Label 'EARNED';
        DEDUCTIONSCap: Label 'DEDUCTIONS';
        FICACap: Label 'FICA';
        WHTDCap: Label 'WITH-HOLDING';
        StateTxCap: Label 'STATE-TAX';
        CityLocTaxCap: Label 'CITY/LOCAL TAX';
        VolDedCap: Label 'VOL. DEDUCTIONS';
        NETWAGESPAIDCap: Label 'NNET WAGES PAID FOR WEEK';
        USDepttCap: Label 'U.S. Department of Labor';
        WagHrDivisionCap: Label 'Wage and Hour Division';
        StatmComplnceCap: Label 'STATEMENT OF COMPLIANCE';
        PayRLNoCap: Label 'PAYROLL NO:';
        PPDateCap: Label 'PAYROLL PAYMENT DATE';
        ContrNoCap: Label 'CONTRACT NUMBER';
        DATECap: Label 'DATE:';
        HRContrName: Text[100];
        HRAddr1: Text[100];
        HRAddr2: Text[100];
        HRSignParty: Text[100];
        HRTitle: Text[100];
        Text001: Label '%1 must be specified';
        DaysStore: array[6] of Text[100];
        MaskedSSNToShow: Text[100];
        Day1: Text;
        Day2: Text;
        Day3: Text;
        Day4: Text;
        Day5: Text;
        Day6: Text;
        Day7: Text;
        UsedPEDate: Date;
        EmpCode: Code[20];
        RegEarningsTotal: Decimal;
        reg1: Decimal;
        reg2: Decimal;
        reg3: Decimal;
        reg4: Decimal;
        reg5: Decimal;
        reg6: Decimal;
        reg7: Decimal;
        ot1: Decimal;
        ot2: Decimal;
        ot3: Decimal;
        ot4: Decimal;
        ot5: Decimal;
        ot6: Decimal;
        ot7: Decimal;
        date1: Date;
        date2: Date;
        date3: Date;
        date4: Date;
        date5: Date;
        date6: Date;
        date7: Date;
        JobNoValue: Code[20];
        EmpNo: Code[20];
        JobCode: Code[20];
        PayrollCode: Code[20];
        OTearningsTotal: Decimal;

    [Scope('Cloud')]
    procedure WriteHeaderData()
    var
        WeeksDate: Date;
        j: Integer;
        TxtDateFormula: Label '-%1d';
        TxtDateOfTheWeek: Label '''%1/%2';
    begin
        // Calculate Day of the Week;
        TempDate := PayrollRegisterLedger."NS_Period End Date";
        i := 7;
        j := 0;

        WHILE i <> 0 DO BEGIN
            DateTable.GET(DateTable."Period Type"::Date, TempDate);
            DayOfTheWeek[i] := COPYSTR(DateTable."Period Name", 1, 1);

            IF j <> 0 THEN
                WeeksDate := CALCDATE(STRSUBSTNO(TxtDateFormula, j), TempDate)
            ELSE
                WeeksDate := TempDate;

            i := i - 1;
            TempDate := CALCDATE('-1D', TempDate);
        END;
    end;

    [Scope('Cloud')]
    procedure CreateWH347TempTable(PeriodEndDate: Date; JobNo: Code[20]; EmployeeNo: Code[20]; EmployeeClass: Text[2])
    var
        REG: array[7] of Decimal;
        OT: array[7] of Decimal;
        REGPAY: array[7] of Decimal;
        OTPAY: array[7] of Decimal;
    begin
        IF "WH347 TempTable".GET(PeriodEndDate, JobNo, EmployeeNo, EmployeeClass) THEN
            EXIT;

        TempDate := PeriodEndDate;
        CLEAR(REG);
        CLEAR(OT);
        CLEAR(REGPAY);
        CLEAR(OTPAY);
        CLEAR(reg1);
        CLEAR(reg2);
        CLEAR(reg3);
        CLEAR(reg4);
        CLEAR(reg5);
        CLEAR(reg6);
        CLEAR(reg7);
        CLEAR(ot1);
        CLEAR(ot2);
        CLEAR(ot3);
        CLEAR(ot4);
        CLEAR(ot5);
        CLEAR(ot6);
        CLEAR(ot7);

        PayrollRegisterLedger.SETCURRENTKEY("NS_Job No.", "NS_Period End Date", "NS_Include in CertifiedPayroll", "NS_EE ID No.", "NS_Employee Class");
        PayrollRegisterLedger.SETRANGE("NS_Job No.", JobNo);
        PayrollRegisterLedger.SETRANGE("NS_Period End Date", PeriodEndDate);
        PayrollRegisterLedger.SETRANGE("NS_Include in CertifiedPayroll", TRUE);
        PayrollRegisterLedger.SETRANGE("NS_EE ID No.", EmployeeNo);
        PayrollRegisterLedger.SETRANGE("NS_Employee Class", EmployeeClass);
        IF PayrollRegisterLedger.FIND('-') THEN
            REPEAT
                // Summarize by Day of the Week
                FOR i := 7 DOWNTO 1 DO BEGIN
                    IF TempDate = PayrollRegisterLedger."NS_Work Date" THEN BEGIN
                        REG[i] := REG[i] + PayrollRegisterLedger."NS_Regular Hours";
                        OT[i] := OT[i] + PayrollRegisterLedger."NS_OT Hours";
                        REGPAY[i] := REGPAY[i] + PayrollRegisterLedger."NS_Regular Earnings";
                        OTPAY[i] := OTPAY[i] + PayrollRegisterLedger."NS_OT Earnings";
                    END;
                    TempDate := CALCDATE('-1D', TempDate);
                END;
                TempDate := PeriodEndDate;

            UNTIL (PayrollRegisterLedger.NEXT = 0);

        // Create the summary record.
        IF PayrollRegisterLedger.COUNT > 0 THEN BEGIN
            WITH "WH347 TempTable" DO BEGIN
                INIT;
                "NS_Period End Date" := PeriodEndDate;
                "NS_Job No." := JobNo;
                "NS_Employee No." := EmployeeNo;
                "NS_Employee Class" := EmployeeClass;
                "NS_Day 1 Regular Hours" := REG[1];
                "NS_Day 2 Regular Hours" := REG[2];
                "NS_Day 3 Regular Hours" := REG[3];
                "NS_Day 4 Regular Hours" := REG[4];
                "NS_Day 5 Regular Hours" := REG[5];
                "NS_Day 6 Regular Hours" := REG[6];
                "NS_Day 7 Regular Hours" := REG[7];
                "NS_Day 1 Overtime Hours" := OT[1];
                "NS_Day 2 Overtime Hours" := OT[2];
                "NS_Day 3 Overtime Hours" := OT[3];
                "NS_Day 4 Overtime Hours" := OT[4];
                "NS_Day 5 Overtime Hours" := OT[5];
                "NS_Day 6 Overtime Hours" := OT[6];
                "NS_Day 7 Overtime Hours" := OT[7];
                INSERT;
            END;
        END;
    end;

    [Scope('Cloud')]
    procedure MarkSSNFtn()
    var
        MaskedSSN: Text[11];
    begin
        CLEAR(MaskedSSN);
        CLEAR(MaskedSSNToShow);
        MaskedSSN := SSNMask + COPYSTR(PayrollRegisterLedger."NS_Social Security No.", 6, 4);
        MaskedSSNToShow := MaskedSSN;
    end;

    [Scope('Internal')]
    procedure CreateWH347TempTableforSunday(PeriodEndDate: Date; JobNo: Code[20])
    var
        REG: array[7] of Decimal;
        OT: array[7] of Decimal;
        REGPAY: array[7] of Decimal;
        OTPAY: array[7] of Decimal;
    begin
        CLEAR(REG);
        CLEAR(OT);
        CLEAR(REGPAY);
        CLEAR(OTPAY);
        CLEAR(reg1);
        CLEAR(reg2);
        CLEAR(reg3);
        CLEAR(reg4);
        CLEAR(reg5);
        CLEAR(reg6);
        CLEAR(reg7);
        CLEAR(ot1);
        CLEAR(ot2);
        CLEAR(ot3);
        CLEAR(ot4);
        CLEAR(ot5);
        CLEAR(ot6);
        CLEAR(ot7);
        CLEAR(JobNo);

        PayrollRegisterLedger_L.RESET;
        PayrollRegisterLedger_L.SETCURRENTKEY("NS_Job No.", "NS_Period End Date", "NS_Include in CertifiedPayroll", "NS_EE ID No.", "NS_Employee Class");
        PayrollRegisterLedger_L.SETRANGE("NS_Job No.", JobNoValue);
        PayrollRegisterLedger_L.SETRANGE("NS_Work Date", date7);
        PayrollRegisterLedger_L.SETRANGE("NS_Include in CertifiedPayroll", TRUE);
        IF PayrollRegisterLedger_L.FINDSET THEN
            REPEAT
                reg1 += PayrollRegisterLedger_L."NS_Regular Hours";
                ot1 += PayrollRegisterLedger_L."NS_OT Hours";
            UNTIL PayrollRegisterLedger_L.NEXT = 0;

        PayrollRegisterLedger_L.SETRANGE("NS_Work Date", date1);
        IF PayrollRegisterLedger_L.FINDSET THEN
            REPEAT
                reg2 += PayrollRegisterLedger_L."NS_Regular Hours";
                ot2 += PayrollRegisterLedger_L."NS_OT Hours";
            UNTIL PayrollRegisterLedger_L.NEXT = 0;

        PayrollRegisterLedger_L.SETRANGE("NS_Work Date", date2);
        IF PayrollRegisterLedger_L.FINDSET THEN
            REPEAT
                reg3 += PayrollRegisterLedger_L."NS_Regular Hours";
                ot3 += PayrollRegisterLedger_L."NS_OT Hours";
            UNTIL PayrollRegisterLedger_L.NEXT = 0;

        PayrollRegisterLedger_L.SETRANGE("NS_Work Date", date3);
        IF PayrollRegisterLedger_L.FINDSET THEN
            REPEAT
                reg4 += PayrollRegisterLedger_L."NS_Regular Hours";
                ot4 += PayrollRegisterLedger_L."NS_OT Hours";
            UNTIL PayrollRegisterLedger_L.NEXT = 0;

        PayrollRegisterLedger_L.SETRANGE("NS_Work Date", date4);
        IF PayrollRegisterLedger_L.FINDSET THEN
            REPEAT
                reg5 += PayrollRegisterLedger_L."NS_Regular Hours";
                ot5 += PayrollRegisterLedger_L."NS_OT Hours";
            UNTIL PayrollRegisterLedger_L.NEXT = 0;

        PayrollRegisterLedger_L.SETRANGE("NS_Work Date", date5);
        IF PayrollRegisterLedger_L.FINDSET THEN
            REPEAT
                reg6 += PayrollRegisterLedger_L."NS_Regular Hours";
                ot6 += PayrollRegisterLedger_L."NS_OT Hours";
            UNTIL PayrollRegisterLedger_L.NEXT = 0;


        PayrollRegisterLedger_L.SETRANGE("NS_Work Date", date6);
        IF PayrollRegisterLedger_L.FINDSET THEN
            REPEAT
                reg7 += PayrollRegisterLedger_L."NS_Regular Hours";
                ot7 += PayrollRegisterLedger_L."NS_OT Hours";
            UNTIL PayrollRegisterLedger_L.NEXT = 0;
    end;

    //PPDA.1.0 Start Added
    [IntegrationEvent(false, false)]
    local procedure OnBeforeSetFederalID(Var FederalID: text[100])
    begin
    end;
    //PPDA.1.0 End Added
}

