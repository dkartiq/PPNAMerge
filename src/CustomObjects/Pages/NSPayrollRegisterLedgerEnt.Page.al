page 14021386 "NS_Payroll Register Ledger Ent"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-221.AS.1.0 : Code Commented
    Caption = 'Payroll Register Ledger Entries';
    PageType = List;
    SourceTable = "NS_Payroll Register Ledger";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."NS_Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Entry No.';
                }
                field("Company ID"; Rec."NS_Company ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Company ID';
                }
                field("EE ID No."; Rec."NS_EE ID No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the EE ID No.';
                }
                field("Employee Name"; Rec."NS_Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Employee Name';
                }
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';
                }
                //PRJ-221.AS.1.0 29MAY2020 -START
                field("Skill Class"; Rec."NS_Skill Class")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Skill Class';
                }
                //PRJ-221.AS.1.0 29MAY2020 -END
                field("EE Address 1"; Rec."NS_EE Address 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the EE Address 1';
                }
                field("EE Address 2"; Rec."NS_EE Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the EE Address 2';
                }
                field("EE City"; Rec."NS_EE City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the EE City';
                }
                field("EE State"; Rec."NS_EE State")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the EE State';
                }
                field("EE Zip"; Rec."NS_EE Zip")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the EE Zip';
                }
                field("EE Phone No."; Rec."NS_EE Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the EE Phone No.';
                }
                field("Marital Status"; Rec."NS_Marital Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Marital Status';
                }
                field(Gender; Rec.NS_Gender)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Gender';
                }
                //PRJ-221.AS.1.0 29MAY2020 -START
                field("Payroll No."; Rec."NS_Payroll No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Payroll No.';
                }
                //PRJ-221.AS.1.0 29MAY2020 -END
                field("Federal Exemptions"; Rec."NS_Federal Exemptions")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Federal Exemptions';
                }
                field("EEO Code"; Rec."NS_EEO Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the EEO Code';
                }
                field("Employee Class"; Rec."NS_Employee Class")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Employee Class';
                }
                field("Trade License"; Rec."NS_Trade License")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Trade License';
                }
                field("Union Code"; Rec."NS_Union Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Union Code';
                }
                field("Union Dues"; Rec."NS_Union Dues")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Union Dues';
                }
                field("Social Security No."; Rec."NS_Social Security No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Social Security No.';
                }
                field("Period End Date"; Rec."NS_Period End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Period End Date';
                }
                field("Check No."; Rec."NS_Check No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Check No.';
                }
                field("Voucher No."; Rec."NS_Voucher No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Voucher No.';
                }
                field("Cost No."; Rec."NS_Cost No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Cost No.';
                }
                field("Basic Rate"; Rec."NS_Basic Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Basic Rate';
                }
                field("Regular Hours"; Rec."NS_Regular Hours")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Regular Hours';
                }
                field("OT Hours"; Rec."NS_OT Hours")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the OT Hours';
                }
                field("Regular Earnings"; Rec."NS_Regular Earnings")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Regular Earnings';
                }
                field("OT Earnings"; Rec."NS_OT Earnings")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the OT Earnings';
                }
                field("Other Hours"; Rec."NS_Other Hours")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Other Hours';
                }
                field("Other Earnings"; Rec."NS_Other Earnings")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Other Earnings';
                }
                field("Gross Pay"; Rec."NS_Gross Pay")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Gross Pay';
                }
                field("Federal Tax"; Rec."NS_Federal Tax")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Federal Tax';
                }
                field(FICA; Rec.NS_FICA)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the FICA';
                }
                field("State Tax"; Rec."NS_State Tax")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the State Tax';
                }
                field("City / Local Tax"; Rec."NS_City / Local Tax")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the City / Local Tax';
                }
                field("Voulentary Deductions"; Rec."NS_Voulentary Deductions")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Voulentary Deductions';
                }
                field("Direct Deposit Amount"; Rec."NS_Direct Deposit Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Direct Deposit Amount';
                }
                field("Net Pay"; Rec."NS_Net Pay")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Net Pay';
                }
                field("Apprentice Percent"; Rec."NS_Apprentice Percent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Apprentice Percent';
                }
                field("OT Supplemental Benefit Rate"; Rec."NS_OT Supplemental BenefitRate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the OT Supplemental Benefit Rate';
                }
                field("Per Head Tax"; Rec."NS_Per Head Tax")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Per Head Tax';
                }
                field("Regular Supplemental Ben. Rate"; Rec.NS_RegularSupplementalBenRate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Regular Supplemental Ben. Rate';
                }
                field("Supp. Benefits Employee Paid"; Rec."NS_Supp. BenefitsEmployeePaid")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Supp. Benefits Employee Paid';
                }
                field("Supp. Benefits Other Paid"; Rec."NS_Supp. Benefits Other Paid")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Supp. Benefits Other Paid';
                }
                field("Supp. Benefits Union Paid"; Rec."NS_Supp. Benefits Union Paid")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Supp. Benefits Union Paid';
                }
                field(SUI; Rec.NS_SUI)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the SUI';
                }
                field("Supp. Benefits Paid"; Rec."NS_Supp. Benefits Paid")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Supp. Benefits Paid';
                }
                field("Include in Certified Payroll"; Rec."NS_Include in CertifiedPayroll")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Include in Certified Payroll';
                }
                field("Date Imported"; Rec."NS_Date Imported")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Date Imported';
                }
                field("PR. Register Ledger Batch No."; Rec."NS_PR. Register LedgerBatchNo.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the PR. Register Ledger Batch No.';
                    Visible = false;
                }
                field("Work Date"; Rec."NS_Work Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Date';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Import Payroll Ledger Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Import Payroll Ledger Entries';
                    Ellipsis = true;
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Import Payroll Ledger Entries';

                    trigger OnAction();
                    var
                        HumanResourcesSetup: Record "Human Resources Setup";
                    begin
                        HumanResourcesSetup.FIND('+');
                        //HumanResourcesSetup.TESTFIELD("PP_Payroll RegImportXMLPortNo");//PRJ-221.AS.1.0 Commented Code
                        XMLPORT.RUN(14021376, true, true);
                        CurrPage.UPDATE;
                    end;
                }
                action("Set Certified Payroll to Yes")
                {
                    ApplicationArea = All;
                    Caption = 'Set Certified Payroll to Yes';
                    Ellipsis = true;
                    Image = UpdateUnitCost;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Set Certified Payroll to Yes';

                    trigger OnAction();
                    var
                        PayrollRegisterManagement: Codeunit "NS_Payroll Register Management";
                    begin
                        if (GETFILTER("NS_Period End Date") = '') then
                            ERROR(STRSUBSTNO(Text001, FIELDCAPTION("NS_Period End Date")));

                        if CONFIRM(STRSUBSTNO(Text002, FIELDCAPTION("NS_Include in CertifiedPayroll"), Yes, FIELDCAPTION("NS_Period End Date"), FIELDCAPTION("NS_EE ID No."))) then
                            PayrollRegisterManagement.NS_BatchModifyCertifiedPayrollValue(Rec, true)
                        else
                            MESSAGE(Text003);
                    end;
                }
                action("Set Certified Payroll to No")
                {
                    ApplicationArea = All;
                    Caption = 'Set Certified Payroll to No';
                    Ellipsis = true;
                    Image = UpdateUnitCost;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Set Certified Payroll to No';

                    trigger OnAction();
                    var
                        PayrollRegisterManagement: Codeunit "NS_Payroll Register Management";
                    begin
                        if (GETFILTER("NS_Period End Date") = '') then
                            ERROR(STRSUBSTNO(Text001, FIELDCAPTION("NS_Period End Date")));

                        if CONFIRM(STRSUBSTNO(Text002, FIELDCAPTION("NS_Include in CertifiedPayroll"), No, FIELDCAPTION("NS_Period End Date"), FIELDCAPTION("NS_EE ID No."))) then
                            PayrollRegisterManagement.NS_BatchModifyCertifiedPayrollValue(Rec, false)
                        else
                            MESSAGE(Text003);
                    end;
                }
                action("Run Certified Payroll Report")
                {
                    ApplicationArea = All;
                    Caption = 'Run Certified Payroll Report';

                    ToolTip = 'Run Certified Payroll Report';
                    Ellipsis = true;
                    Image = UpdateUnitCost;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    var
                        PayrollRegisterManagement: Codeunit "NS_Payroll Register Management";
                    begin
                        Message('Please ensure that Payroll Week End Date equals to Saturday or Sunday on HR Setup.Also PeriodEndDate on list page and report must be according to it.');//PRJ-221.AS.1.0 29MAY2020
                        REPORT.RUN(14021380, true, true);
                    end;
                }
            }
        }
    }

    var
        Text001: Label 'You must specify a filter for %1 to perform this batch update.';
        Text002: Label 'This proces will update all values of %1 to %2.\Filters on %3 and %4 will be used.\Do you want to continue?';
        Text003: Label 'Action cancelled by the user.';
        Yes: Label 'Yes';
        No: Label 'No';
}

