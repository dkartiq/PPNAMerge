report 14021383 "NS_Payroll Interf. Prooflist"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-84.SK.1.0 Added report to search
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSPayroll Interf. Prooflist.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    Caption = 'Payroll Interf. Prooflist';

    dataset
    {
        dataitem("Payroll Interface Jnl Batch"; "NS_Payroll Interface Jnl Batch")
        {
            DataItemTableView = SORTING("NS_Journal Template Name", NS_Name) ORDER(Ascending);
            PrintOnlyIfDetail = true;
            column(PR_Journal_Batch_Name; NS_Name)
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                PrintOnlyIfDetail = true;
                column(COMPANYNAME; COMPANYNAME)
                {
                }
                column(PR_Journal_Batch___Journal_Template_Name_; "Payroll Interface Jnl Batch"."NS_Journal Template Name")
                {
                }
                column(PR_Journal_Batch__Name; "Payroll Interface Jnl Batch".NS_Name)
                {
                }
                column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
                {
                }

                column(PR_Journal_Line__TABLECAPTION__________PRJnlLineFilter; "Payroll Interface Jnl Line".TABLECAPTION + ': ' + PayrollInterfaceJnlLineFilter)
                {
                }
                column(PRJnlLineFilter; PayrollInterfaceJnlLineFilter)
                {
                }
                column(PR_Journal_Batch___Journal_Template_Name_Caption; Job_Journal_Batch___Journal_Template_Name_CaptionLbl)
                {
                }
                column(PR_Journal_Batch__NameCaption; Job_Journal_Batch__NameCaptionLbl)
                {
                }
                column(PR_Journal___TestCaption; Job_Journal___TestCaptionLbl)
                {
                }
                column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                }
                column(PR_Journal_Line__Line_Amount_Caption; "Payroll Interface Jnl Line".FIELDCAPTION(NS_Amount))
                {
                }
                column(PR_Journal_Line__Unit_Price_Caption; "Payroll Interface Jnl Line".FIELDCAPTION(NS_Rate))
                {
                }
                column(PR_Journal_Line__Total_Cost__LCY__Caption; "Payroll Interface Jnl Line".FIELDCAPTION("NS_Employee Name"))
                {
                }
                column(PR_Journal_Line__Unit_Cost__LCY__Caption; 'DELETE')
                {
                }
                column(PR_Journal_Line__Work_Type_Code_Caption; "Payroll Interface Jnl Line".FIELDCAPTION("NS_D/E Type"))
                {
                }
                column(PR_Journal_Line__Unit_of_Measure_Code_Caption; "Payroll Interface Jnl Line".FIELDCAPTION("NS_D/E Code"))
                {
                }
                column(PR_Journal_Line_QuantityCaption; "Payroll Interface Jnl Line".FIELDCAPTION(NS_Hours))
                {
                }
                column(PR_Journal_Line__No__Caption; "Payroll Interface Jnl Line".FIELDCAPTION("NS_Employee No."))
                {
                }
                column(PR_Journal_Line__Document_No__Caption; "Payroll Interface Jnl Line".FIELDCAPTION("NS_Document No."))
                {
                }
                column(PR_Journal_Line_TypeCaption; "Payroll Interface Jnl Line".FIELDCAPTION("NS_Override State"))
                {
                }
                column(PR_Journal_Line__Job_No__Caption; "Payroll Interface Jnl Line".FIELDCAPTION("NS_Job No."))
                {
                }
                column(PR_Journal_Line__Posting_Date_Caption; Job_Journal_Line__Posting_Date_CaptionLbl)
                {
                }
                column(PIJ_ExportStatus_Caption; "Payroll Interface Jnl Line".FIELDCAPTION("NS_Export Status"))
                {
                }
                column(PIJ_ExportStatusDateTime_Caption; "Payroll Interface Jnl Line".FIELDCAPTION("NS_Export Status Date/Time"))
                {
                }
                column(PIJ_WorkDate_Caption; "Payroll Interface Jnl Line".FIELDCAPTION("NS_Work Date"))
                {
                }
                column(PIJ_Shift_Caption; "Payroll Interface Jnl Line".FIELDCAPTION(NS_Shift))
                {
                }
                column(PIJ_SequenceNo_Caption; "Payroll Interface Jnl Line".FIELDCAPTION("NS_Sequence No."))
                {
                }
                column(PIJ_OverrideDivision_Caption; "Payroll Interface Jnl Line".FIELDCAPTION("NS_Override Division"))
                {
                }
                column(PIJ_OverrideBranch_Caption; "Payroll Interface Jnl Line".FIELDCAPTION("NS_Override Branch"))
                {
                }
                column(PIJ_OverrideState_Caption; "Payroll Interface Jnl Line".FIELDCAPTION("NS_Override State"))
                {
                }
                column(PIJ_STLOC_Misc_Field_Caption; "Payroll Interface Jnl Line".FIELDCAPTION("NS_State/Local Misc. Field"))
                {
                }
                column(PIJ_RateNo_Caption; "Payroll Interface Jnl Line".FIELDCAPTION("NS_Rate No."))
                {
                }
                column(PIJ_SSN_Caption; "Payroll Interface Jnl Line".FIELDCAPTION("NS_Social Security No."))
                {
                }
                column(PIJ_JLENo_Caption; "Payroll Interface Jnl Line".FIELDCAPTION("NS_Job Ledger Entry No."))
                {
                }
                column(PIJ_Manual_Caption; "Payroll Interface Jnl Line".FIELDCAPTION("NS_Manual Check No."))
                {
                }
                dataitem("Payroll Interface Jnl Line"; "NS_Payroll Interface Jnl Line")
                {
                    DataItemLink = "NS_Journal Template Name" = FIELD("NS_Journal Template Name"), "NS_Journal Batch Name" = FIELD(NS_Name);
                    DataItemLinkReference = "Payroll Interface Jnl Batch";
                    DataItemTableView = SORTING("NS_Journal Template Name", "NS_Journal Batch Name", "NS_Employee No.", "NS_Work Date");
                    RequestFilterFields = "NS_Journal Batch Name";
                    column(PIJ_Journal_Line__Line_Amount_; NS_Amount)
                    {
                    }
                    column(PIJ_Journal_Line__Unit_Price_; NS_Rate)
                    {
                    }
                    column(PIJ_EmployeeName; "NS_Employee Name")
                    {
                    }
                    column(PIJ_DELETE; 'DELETE')
                    {
                    }
                    column(PIJ_Journal_Line__Work_Type_Code_; "NS_D/E Type")
                    {
                    }
                    column(PIJ_Journal_Line__Unit_of_Measure_Code_; "NS_D/E Code")
                    {
                    }
                    column(PIJ_Journal_Line_Quantity; NS_Hours)
                    {
                    }
                    column(PIJ_Employee_No; "NS_Employee No.")
                    {
                    }
                    column(PIJ_Journal_Line_Type; "NS_Override State")
                    {
                    }
                    column(PIJ_Document_No; "NS_Document No.")
                    {
                    }
                    column(PIJ_Journal_Line__Job_No__; "NS_Job No.")
                    {
                    }
                    column(PIJ_Journal_Line_Journal_Template_Name; "NS_Journal Template Name")
                    {
                    }
                    column(PIJ_Journal_Line_Line_No_; "NS_Line No.")
                    {
                    }
                    column(PIJ_ExportStatus; "NS_Export Status")
                    {
                    }
                    column(PIJ_ExportStatusDatetime; "NS_Export Status Date/Time")
                    {
                    }
                    column(PIJ_WorkDate; "NS_Work Date")
                    {
                    }
                    column(PIJ_Shift; NS_Shift)
                    {
                    }
                    column(PIJ_SequenceNo; "NS_Sequence No.")
                    {
                    }
                    column(PIJ_OverrideDivision; "NS_Override Division")
                    {
                    }
                    column(PIJ_OverrideBranch; "NS_Override Branch")
                    {
                    }
                    column(PIJ_OverrideState; "NS_Override State")
                    {
                    }
                    column(PIJ_STLOC_Misc_Field; "NS_State/Local Misc. Field")
                    {
                    }
                    column(PIJ_RateNo; "NS_Rate No.")
                    {
                    }
                    column(PIJ_SSN; '###-##-' + COPYSTR("NS_Social Security No.", 8, 4))
                    {
                    }
                    column(PIJ_JLENo; "NS_Job Ledger Entry No.")
                    {
                    }
                    column(PIJ_Manual; "NS_Manual Check No.")
                    {
                    }

                    trigger OnAfterGetRecord();
                    var
                        InvtPeriodEndDate: Date;
                    begin
                        if NS_EmptyLine then
                            exit;
                    end;

                    trigger OnPreDataItem();
                    begin
                        PayrollInterfaceJnlTemplate.GET("Payroll Interface Jnl Batch"."NS_Journal Template Name");
                        CurrReport.CREATETOTALS(NS_Hours, NS_Amount);

                        if "Payroll Interface Jnl Batch"."NS_No. Series" <> '' then
                            NoSeries.GET("Payroll Interface Jnl Batch"."NS_No. Series");
                        LastPostingDate := 0D;
                        LastDocNo := '';
                    end;
                }
            }

            trigger OnAfterGetRecord();
            begin
                CurrReport.PAGENO := 1;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        PayrollInterfaceJnlLineFilter := "Payroll Interface Jnl Line".GETFILTERS;
        HumanResourcesSetup.GET;
    end;

    var
        Text000: Label '%1 cannot be filtered when you post recurring journals.';
        Text001: Label '%1 must be specified.';
        Text002: Label 'Job %1 does not exist.';
        Text003: Label '%1 must not be %2 for job %3.';
        Text004: Label '%1 cannot to longer than %2 characters.';
        Text005: Label 'Resource %1 does not exist.';
        Text006: Label '%1 cannot be more than %2.';
        Text007: Label '%1 cannot be more than 1 character.';
        Text008: Label '%1 in the %2 table cannot be more than %3 characters.';
        Text009: Label '%1 must not be a closing date.';
        Text010: Label 'The lines are not listed according to posting date because they were not entered in that order.';
        Text011: Label '%1 is not within your allowed range of posting dates.';
        Text012: Label 'There is a gap in the number series.';
        UserSetup: Record "User Setup";
        GLSetup: Record "General Ledger Setup";
        Job: Record Job;
        Employee: Record Employee;
        PayrollInterfaceJnlTemplate: Record "NS_PayrollInterfaceJnlTemplate";
        HumanResourcesSetup: Record "Human Resources Setup";
        NoSeries: Record "No. Series";
        AllowPostingFrom: Date;
        AllowPostingTo: Date;
        Day: Integer;
        Week: Integer;
        Month: Integer;
        MonthText: Text[30];
        ErrorCounter: Integer;
        ErrorText: array[50] of Text[250];
        PayrollInterfaceJnlLineFilter: Text[250];
        LastPostingDate: Date;
        LastDocNo: Code[20];
        No: array[10] of Code[20];
        Continue: Boolean;
        Text013: Label '%1 must be specified in the %2 table.';
        Text014: Label '%1 must not be less than %2';
        Job_Journal_Batch___Journal_Template_Name_CaptionLbl: Label 'Journal Template';
        Job_Journal_Batch__NameCaptionLbl: Label 'Journal Batch';
        Job_Journal___TestCaptionLbl: Label 'Payroll Interface Journal - Test - PAYCHEX';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Job_Journal_Line__Posting_Date_CaptionLbl: Label 'Posting Date';
}

