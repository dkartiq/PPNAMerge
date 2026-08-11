report 14021382 "NS_Payroll Interf. TestPayloci"
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
    RDLCLayout = './Layouts/NSPayroll Interf. Test - Payloci.rdl';
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Payroll Interf. Test - Paylocity';
    ApplicationArea = all;

    dataset
    {
        dataitem("Payroll Interface Jnl Batch"; "NS_Payroll Interface Jnl Batch")
        {
            DataItemTableView = SORTING("NS_Journal Template Name", NS_Name) ORDER(Ascending);
            PrintOnlyIfDetail = true;
            column(Job_Journal_Batch_Name; NS_Name)
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                PrintOnlyIfDetail = true;
                column(COMPANYNAME; COMPANYNAME)
                {
                }
                column(Job_Journal_Batch___Journal_Template_Name_; "Payroll Interface Jnl Batch"."NS_Journal Template Name")
                {
                }
                column(Job_Journal_Batch__Name; "Payroll Interface Jnl Batch".NS_Name)
                {
                }
                column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
                {
                }

                column(Job_Journal_Line__TABLECAPTION__________JobJnlLineFilter; "Payroll Interface Jnl Line".TABLECAPTION + ': ' + PayrollInterfaceJnlLineFilter)
                {
                }
                column(JobJnlLineFilter; PayrollInterfaceJnlLineFilter)
                {
                }
                column(Job_Journal_Batch___Journal_Template_Name_Caption; Job_Journal_Batch___Journal_Template_Name_CaptionLbl)
                {
                }
                column(Job_Journal_Batch__NameCaption; Job_Journal_Batch__NameCaptionLbl)
                {
                }
                column(Job_Journal___TestCaption; Job_Journal___TestCaptionLbl)
                {
                }
                column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Job_Journal_Line__Line_Amount_Caption; "Payroll Interface Jnl Line".FIELDCAPTION(NS_Amount))
                {
                }
                column(Job_Journal_Line__Unit_Price_Caption; "Payroll Interface Jnl Line".FIELDCAPTION(NS_Rate))
                {
                }
                column(Job_Journal_Line__Total_Cost__LCY__Caption; "Payroll Interface Jnl Line".FIELDCAPTION("NS_Employee Name"))
                {
                }
                column(Job_Journal_Line__Unit_Cost__LCY__Caption; 'DELETE')
                {
                }
                column(Job_Journal_Line__Work_Type_Code_Caption; "Payroll Interface Jnl Line".FIELDCAPTION("NS_D/E Type"))
                {
                }
                column(Job_Journal_Line__Unit_of_Measure_Code_Caption; "Payroll Interface Jnl Line".FIELDCAPTION("NS_D/E Code"))
                {
                }
                column(Job_Journal_Line_QuantityCaption; "Payroll Interface Jnl Line".FIELDCAPTION(NS_Hours))
                {
                }
                column(Job_Journal_Line__No__Caption; "Payroll Interface Jnl Line".FIELDCAPTION("NS_Employee No."))
                {
                }
                column(Job_Journal_Line__Document_No__Caption; "Payroll Interface Jnl Line".FIELDCAPTION("NS_Document No."))
                {
                }
                column(Job_Journal_Line_TypeCaption; "Payroll Interface Jnl Line".FIELDCAPTION("NS_Override State"))
                {
                }
                column(Job_Journal_Line__Job_No__Caption; "Payroll Interface Jnl Line".FIELDCAPTION("NS_Job No."))
                {
                }
                column(Job_Journal_Line__Posting_Date_Caption; Job_Journal_Line__Posting_Date_CaptionLbl)
                {
                }
                dataitem("Payroll Interface Jnl Line"; "NS_Payroll Interface Jnl Line")
                {
                    DataItemLink = "NS_Journal Template Name" = FIELD("NS_Journal Template Name"), "NS_Journal Batch Name" = FIELD(NS_Name);
                    DataItemLinkReference = "Payroll Interface Jnl Batch";
                    DataItemTableView = SORTING("NS_Journal Template Name", "NS_Journal Batch Name", "NS_Line No.");

                    column(Job_Journal_Line__Line_Amount_; NS_Amount)
                    {
                    }
                    column(Job_Journal_Line__Unit_Price_; NS_Rate)
                    {
                    }
                    column(Job_Journal_Line__Total_Cost__LCY__; "NS_Employee Name")
                    {
                    }
                    column(Job_Journal_Line__Unit_Cost__LCY__; 'DELETE')
                    {
                    }
                    column(Job_Journal_Line__Work_Type_Code_; "NS_D/E Type")
                    {
                    }
                    column(Job_Journal_Line__Unit_of_Measure_Code_; "NS_D/E Code")
                    {
                    }
                    column(Job_Journal_Line_Quantity; NS_Hours)
                    {
                    }
                    column(Job_Journal_Line__No__; "NS_Employee No.")
                    {
                    }
                    column(Job_Journal_Line_Type; "NS_Override State")
                    {
                    }
                    column(Job_Journal_Line__Document_No__; "NS_Document No.")
                    {
                    }
                    column(Job_Journal_Line__Job_No__; "NS_Job No.")
                    {
                    }
                    column(Job_Journal_Line_Journal_Template_Name; "NS_Journal Template Name")
                    {
                    }
                    column(Job_Journal_Line_Line_No_; "NS_Line No.")
                    {
                    }
                    dataitem(ErrorLoop; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(ErrorText_Number_; ErrorText[Number])
                        {
                        }
                        column(ErrorText_Number_Caption; ErrorText_Number_CaptionLbl)
                        {
                        }

                        trigger OnPostDataItem();
                        begin
                            ErrorCounter := 0;
                        end;

                        trigger OnPreDataItem();
                        begin
                            SETRANGE(Number, 1, ErrorCounter);
                        end;
                    }

                    trigger OnAfterGetRecord();
                    var
                        InvtPeriodEndDate: Date;
                    begin
                        if NS_EmptyLine then
                            exit;

                        if "NS_Job No." = '' then
                            AddError(STRSUBSTNO(Text001, FIELDCAPTION("NS_Job No.")))
                        else
                            if not Job.GET("NS_Job No.") then
                                AddError(STRSUBSTNO(Text002, "NS_Job No."))
                            else begin
                                if Job.Blocked.AsInteger() > Job.Blocked::" ".AsInteger() then
                                    AddError(STRSUBSTNO(Text003, Job.FIELDCAPTION(Blocked), Job.Blocked, "NS_Job No."));
                            end;

                        if "NS_Document No." = '' then
                            AddError(STRSUBSTNO(Text001, FIELDCAPTION("NS_Document No.")));

                        if "NS_Employee No." = '' then
                            AddError(STRSUBSTNO(Text001, FIELDCAPTION("NS_Employee No.")))
                        else
                            if not Employee.GET("NS_Employee No.") then
                                AddError(STRSUBSTNO(Text005, "NS_Employee No."));

                        if "Payroll Interface Jnl Batch"."NS_No. Series" <> '' then begin
                            if LastDocNo <> '' then
                                if ("NS_Document No." <> LastDocNo) and ("NS_Document No." <> INCSTR(LastDocNo)) then
                                    AddError(Text012);
                            LastDocNo := "NS_Document No.";
                        end;

                        if "NS_D/E Type" = "NS_D/E Type"::Earning then begin
                            if (HumanResourcesSetup."NS_Earning Code Identifier" = '') or
                               (HumanResourcesSetup."NS_Earning Code Identifier" = ' ') then
                                AddError(STRSUBSTNO(Text013, HumanResourcesSetup.FIELDCAPTION("NS_Earning Code Identifier"), HumanResourcesSetup.TABLECAPTION));
                        end else begin
                            if (HumanResourcesSetup."NS_Deduction Code Identifier" = '') or
                               (HumanResourcesSetup."NS_Deduction Code Identifier" = ' ') then
                                AddError(STRSUBSTNO(Text013, HumanResourcesSetup.FIELDCAPTION("NS_Deduction Code Identifier"), HumanResourcesSetup.TABLECAPTION));
                        end;

                        if ("NS_D/E Code" = '') or
                           ("NS_D/E Code" = ' ') or
                           ("NS_D/E Code" = '  ') then
                            AddError(STRSUBSTNO(Text001, FIELDCAPTION("NS_D/E Code")));

                        // Can I kill this?
                        if NS_Year > 2099 then
                            AddError(STRSUBSTNO(Text006, FIELDCAPTION(NS_Year), 2099));
                        if NS_Year < 2000 then
                            AddError(STRSUBSTNO(Text014, FIELDCAPTION(NS_Year), 2000));
                        if Month > 12 then
                            AddError(STRSUBSTNO(Text006, FIELDCAPTION(NS_Month), 12));
                        if Month < 1 then
                            AddError(STRSUBSTNO(Text014, FIELDCAPTION(NS_Month), 1));
                        if Day > 31 then
                            AddError(STRSUBSTNO(Text006, FIELDCAPTION(NS_Day), 31));
                        if Day < 1 then
                            AddError(STRSUBSTNO(Text014, FIELDCAPTION(NS_Day), 1));
                        if NS_Hour > 24 then
                            AddError(STRSUBSTNO(Text006, FIELDCAPTION(NS_Hour), 24));
                        if NS_Minute > 60 then
                            AddError(STRSUBSTNO(Text006, FIELDCAPTION(NS_Minute), 60));

                        // Must observer Divsion, Branch, Department hierarchy
                        if (("NS_Override Division" = '') and ("NS_Override Branch" <> '')) then
                            AddError(STRSUBSTNO(Text015, FIELDCAPTION("NS_Override Branch"), FIELDCAPTION("NS_Override Division")));

                        if (("NS_Override Division" = '') and ("NS_Override Dept." <> '')) then
                            AddError(STRSUBSTNO(Text015, FIELDCAPTION("NS_Override Dept."), FIELDCAPTION("NS_Override Division")));

                        if (("NS_Override Branch" = '') and ("NS_Override Dept." <> '')) then
                            AddError(STRSUBSTNO(Text015, FIELDCAPTION("NS_Override Dept."), FIELDCAPTION("NS_Override Branch")));


                        if STRLEN("NS_Social Security No.") > 11 then
                            AddError(STRSUBSTNO(Text004, FIELDCAPTION("NS_Social Security No."), 11));
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
        Text015: Label '%1 cannot be specified when %2 is not specified';
        Job_Journal_Batch___Journal_Template_Name_CaptionLbl: Label 'Journal Template';
        Job_Journal_Batch__NameCaptionLbl: Label 'Journal Batch';
        Job_Journal___TestCaptionLbl: Label 'Payroll Interface Journal - Test - Paylocity';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Job_Journal_Line__Posting_Date_CaptionLbl: Label 'Posting Date';
        ErrorText_Number_CaptionLbl: Label 'Warning!';

    local procedure AddError(Text: Text[250]);
    begin
        ErrorCounter := ErrorCounter + 1;
        ErrorText[ErrorCounter] := Text;
    end;
}

