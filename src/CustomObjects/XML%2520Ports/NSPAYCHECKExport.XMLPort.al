xmlport 14021375 "NS_PAYCHEX Export"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Direction = Export;
    Format = FixedText;

    schema
    {
        textelement(PayrollInterfaceJnl)
        {
            tableelement("Payroll Interface Jnl Line"; "NS_Payroll Interface Jnl Line")
            {
                XmlName = 'PayrollINterfaceJnlLine';
                SourceTableView = SORTING("NS_Journal Template Name", "NS_Journal Batch Name", "NS_Line No.") ORDER(Ascending);

                textelement(formattedemployeeno)
                {
                    XmlName = 'EmployeeNo';
                    Width = 20; //PRJ-524.AM.1.0


                    trigger OnBeforePassVariable();
                    begin
                        FormattedEmployeeNo := "Payroll Interface Jnl Line"."NS_Employee No.";
                        if STRLEN(FormattedEmployeeNo) > 20 then //PRJ-524.AM.1.0
                            ERROR(Text001Lbl, "Payroll Interface Jnl Line".FIELDCAPTION("NS_Employee No."), 6);
                        while STRLEN(FormattedEmployeeNo) < 20 do //PRJ-524.AM.1.0
                            FormattedEmployeeNo := ' ' + FormattedEmployeeNo;
                    end;
                }
                textelement(formattedname)
                {
                    XmlName = 'Name';
                    Width = 25;

                    trigger OnBeforePassVariable();
                    begin
                        FormattedName := "Payroll Interface Jnl Line"."NS_Employee Name";
                        if STRLEN(FormattedName) > 25 then
                            ERROR(Text001Lbl, "Payroll Interface Jnl Line".FIELDCAPTION("NS_Employee Name"), 25);
                        while STRLEN(FormattedName) < 25 do
                            FormattedName := ' ' + FormattedName;
                    end;
                }
                textelement(formattedoverridedept)
                {
                    XmlName = 'OverrideDept';
                    Width = 6;

                    trigger OnBeforePassVariable();
                    begin
                        FormattedOverrideDept := "Payroll Interface Jnl Line"."NS_Override Dept.";
                        if STRLEN(FormattedOverrideDept) > 6 then
                            ERROR(Text001Lbl, "Payroll Interface Jnl Line".FIELDCAPTION("NS_Override Dept."), 6);
                        while STRLEN(FormattedOverrideDept) < 6 do
                            FormattedOverrideDept := ' ' + FormattedOverrideDept;
                    end;
                }
                textelement(formattedjob)
                {
                    XmlName = 'Job';
                    Width = 12;

                    trigger OnBeforePassVariable();
                    begin
                        FormattedJob := "Payroll Interface Jnl Line"."NS_Job No.";
                        if STRLEN(FormattedJob) > 12 then
                            ERROR(Text001Lbl, "Payroll Interface Jnl Line".FIELDCAPTION("NS_Job No."), 12);
                        while STRLEN(FormattedJob) < 12 do
                            FormattedJob := ' ' + FormattedJob
                    end;
                }
                textelement(formattedshift)
                {
                    XmlName = 'Shift';
                    Width = 1;

                    trigger OnBeforePassVariable();
                    begin
                        FormattedShift := "Payroll Interface Jnl Line".NS_Shift;
                        if STRLEN(FormattedShift) > 1 then
                            ERROR(Text001Lbl, "Payroll Interface Jnl Line".FIELDCAPTION(NS_Shift), 1);
                        if FormattedShift = '' then
                            FormattedShift := ' ';
                    end;
                }
                textelement(formattedde)
                {
                    XmlName = 'D-E';
                    Width = 1;

                    trigger OnBeforePassVariable();
                    begin
                        if "Payroll Interface Jnl Line"."NS_D/E Type" = "Payroll Interface Jnl Line"."NS_D/E Type"::Earning then begin
                            if (HumanResourcesSetup."NS_Earning Code Identifier" = '') or
                               (HumanResourcesSetup."NS_Earning Code Identifier" = ' ') then
                                ERROR(Text002Lbl, HumanResourcesSetup.FIELDCAPTION("NS_Earning Code Identifier"), HumanResourcesSetup.TABLECAPTION);
                            if STRLEN(HumanResourcesSetup."NS_Earning Code Identifier") > 1 then
                                ERROR(Text003, HumanResourcesSetup.FIELDCAPTION("NS_Earning Code Identifier"), HumanResourcesSetup.TABLECAPTION, 1);
                            FormattedDE := HumanResourcesSetup."NS_Earning Code Identifier";
                        end else begin
                            if (HumanResourcesSetup."NS_Deduction Code Identifier" = '') or
                               (HumanResourcesSetup."NS_Deduction Code Identifier" = ' ') then
                                ERROR(Text002Lbl, HumanResourcesSetup.FIELDCAPTION("NS_Deduction Code Identifier"), HumanResourcesSetup.TABLECAPTION);
                            if STRLEN(HumanResourcesSetup."NS_Deduction Code Identifier") > 1 then
                                ERROR(Text003, HumanResourcesSetup.FIELDCAPTION("NS_Deduction Code Identifier"), HumanResourcesSetup.TABLECAPTION, 1);
                            FormattedDE := HumanResourcesSetup."NS_Deduction Code Identifier";
                        end;
                    end;
                }
                textelement(formattedearncode)
                {
                    XmlName = 'EarnCode';
                    Width = 2;

                    trigger OnBeforePassVariable();
                    begin
                        FormattedEarnCode := "Payroll Interface Jnl Line"."NS_D/E Code";
                        if STRLEN(FormattedEarnCode) > 2 then
                            ERROR(Text001Lbl, "Payroll Interface Jnl Line".FIELDCAPTION("NS_D/E Code"), 2);
                        while STRLEN(FormattedEarnCode) < 2 do
                            FormattedEarnCode := ' ' + FormattedEarnCode;
                        if FormattedEarnCode = '  ' then
                            ERROR(Text004Lbl, "Payroll Interface Jnl Line".FIELDCAPTION("NS_D/E Code"));
                    end;
                }
                textelement(formattedrate)
                {
                    XmlName = 'Rate';
                    Width = 9;

                    trigger OnBeforePassVariable();
                    begin
                        if "Payroll Interface Jnl Line".NS_Rate > 999999999 then
                            ERROR(Text005Lbl, "Payroll Interface Jnl Line".FIELDCAPTION(NS_Rate), 999999999);
                        FormattedRate := FORMAT("Payroll Interface Jnl Line".NS_Rate);
                        if STRLEN(FormattedRate) > 9 then
                            FormattedRate := COPYSTR(FormattedRate, 1, 9);
                        while STRLEN(FormattedRate) < 9 do
                            FormattedRate := '0' + FormattedRate;
                    end;
                }
                textelement(formattedhours)
                {
                    XmlName = 'Hours';
                    Width = 8;

                    trigger OnBeforePassVariable();
                    begin
                        if "Payroll Interface Jnl Line".NS_Hours > 99999999 then
                            ERROR(Text005Lbl, "Payroll Interface Jnl Line".FIELDCAPTION(NS_Hours), 99999999);
                        FormattedHours := FORMAT("Payroll Interface Jnl Line".NS_Hours);
                        if STRLEN(FormattedHours) > 8 then
                            FormattedHours := COPYSTR(FormattedHours, 1, 8);
                        while STRLEN(FormattedHours) < 8 do
                            FormattedHours := '0' + FormattedHours;
                    end;
                }
                textelement(formattedyear)
                {
                    XmlName = 'Year';
                    Width = 4;

                    trigger OnBeforePassVariable();
                    begin
                        if "Payroll Interface Jnl Line".NS_Year > 2099 then
                            ERROR(Text005Lbl, "Payroll Interface Jnl Line".FIELDCAPTION(NS_Year), 2099);
                        if "Payroll Interface Jnl Line".NS_Year < 2000 then
                            ERROR(Text006Lbl, "Payroll Interface Jnl Line".FIELDCAPTION(NS_Year), 2000);
                        FormattedYear := FORMAT("Payroll Interface Jnl Line".NS_Year);
                    end;
                }
                textelement(formattedmonth)
                {
                    XmlName = 'Month';
                    Width = 2;

                    trigger OnBeforePassVariable();
                    begin
                        if "Payroll Interface Jnl Line".NS_Month > 12 then
                            ERROR(Text005Lbl, "Payroll Interface Jnl Line".FIELDCAPTION(NS_Month), 12);
                        if "Payroll Interface Jnl Line".NS_Month < 1 then
                            ERROR(Text006Lbl, "Payroll Interface Jnl Line".FIELDCAPTION(NS_Month), 1);
                        FormattedMonth := FORMAT("Payroll Interface Jnl Line".NS_Month);
                        if STRLEN(FormattedMonth) = 1 then
                            FormattedMonth := '0' + FormattedMonth;
                    end;
                }
                textelement(formattedday)
                {
                    XmlName = 'Day';
                    Width = 2;

                    trigger OnBeforePassVariable();
                    begin
                        if "Payroll Interface Jnl Line".NS_Day > 31 then
                            ERROR(Text005Lbl, "Payroll Interface Jnl Line".FIELDCAPTION(NS_Day), 31);
                        if "Payroll Interface Jnl Line".NS_Day < 1 then
                            ERROR(Text006Lbl, "Payroll Interface Jnl Line".FIELDCAPTION(NS_Day), 1);
                        FormattedDay := FORMAT("Payroll Interface Jnl Line".NS_Day);
                        if STRLEN(FormattedDay) = 1 then
                            FormattedDay := '0' + FormattedDay;
                    end;
                }
                textelement(formattedhour)
                {
                    XmlName = 'Hour';
                    Width = 2;

                    trigger OnBeforePassVariable();
                    begin
                        if "Payroll Interface Jnl Line".NS_Hour > 24 then
                            ERROR(Text005Lbl, "Payroll Interface Jnl Line".FIELDCAPTION(NS_Hour), 24);
                        FormattedHour := FORMAT("Payroll Interface Jnl Line".NS_Hour);
                        while STRLEN(FormattedHour) < 2 do
                            FormattedHour := '0' + FormattedHour;
                    end;
                }
                textelement(formattedminute)
                {
                    XmlName = 'Minute';
                    Width = 2;

                    trigger OnBeforePassVariable();
                    begin
                        if "Payroll Interface Jnl Line".NS_Minute > 60 then
                            ERROR(Text005Lbl, "Payroll Interface Jnl Line".FIELDCAPTION(NS_Minute), 60);
                        FormattedMinute := FORMAT("Payroll Interface Jnl Line".NS_Minute);
                        while STRLEN(FormattedMinute) < 2 do
                            FormattedMinute := '0' + FormattedMinute;
                    end;
                }
                textelement(formattedamount)
                {
                    XmlName = 'Amount';
                    Width = 9;

                    trigger OnBeforePassVariable();
                    begin
                        if "Payroll Interface Jnl Line".NS_Amount > 999999999 then
                            ERROR(Text005Lbl, "Payroll Interface Jnl Line".FIELDCAPTION(NS_Amount), 999999999);
                        FormattedAmount := FORMAT("Payroll Interface Jnl Line".NS_Amount);
                        if STRLEN(FormattedAmount) > 9 then
                            FormattedAmount := COPYSTR(FormattedAmount, 1, 9);
                        while STRLEN(FormattedAmount) < 9 do
                            FormattedAmount := '0' + FormattedAmount;
                    end;
                }
                textelement(formattedseqnumber)
                {
                    XmlName = 'SeqNumber';
                    Width = 1;

                    trigger OnBeforePassVariable();
                    begin
                        if "Payroll Interface Jnl Line"."NS_Sequence No." > 9 then
                            ERROR(Text005Lbl, "Payroll Interface Jnl Line".FIELDCAPTION("NS_Sequence No."), 9);
                        FormattedSeqNumber := FORMAT("Payroll Interface Jnl Line"."NS_Sequence No.");
                        if FormattedSeqNumber = '' then
                            FormattedSeqNumber := '0';
                    end;
                }
                textelement(formattedoverridedivision)
                {
                    XmlName = 'OverrideDivision';
                    Width = 6;

                    trigger OnBeforePassVariable();
                    begin
                        FormattedOverrideDivision := "Payroll Interface Jnl Line"."NS_Override Division";
                        if STRLEN(FormattedOverrideDivision) > 6 then
                            ERROR(Text001Lbl, "Payroll Interface Jnl Line".FIELDCAPTION("NS_Override Division"), 6);
                        while STRLEN(FormattedOverrideDivision) < 6 do
                            FormattedOverrideDivision := ' ' + FormattedOverrideDivision;
                    end;
                }
                textelement(formattedoverridebranch)
                {
                    XmlName = 'OverrideBranch';
                    Width = 6;

                    trigger OnBeforePassVariable();
                    begin
                        FormattedOverrideBranch := "Payroll Interface Jnl Line"."NS_Override Branch";
                        if STRLEN(FormattedOverrideBranch) > 6 then
                            ERROR(Text001Lbl, "Payroll Interface Jnl Line".FIELDCAPTION("NS_Override Branch"), 6);
                        while STRLEN(FormattedOverrideBranch) < 6 do
                            FormattedOverrideBranch := ' ' + FormattedOverrideBranch;
                    end;
                }
                textelement(formattedoverridestate)
                {
                    XmlName = 'OverrideState';
                    Width = 2;

                    trigger OnBeforePassVariable();
                    begin
                        FormattedOverrideState := "Payroll Interface Jnl Line"."NS_Override State";
                        if STRLEN(FormattedOverrideState) > 2 then
                            ERROR(Text001Lbl, "Payroll Interface Jnl Line".FIELDCAPTION("NS_Override State"), 2);
                        while STRLEN(FormattedOverrideState) < 2 do
                            FormattedOverrideState := ' ' + FormattedOverrideState;
                    end;
                }
                textelement(formattedoverridelocal)
                {
                    XmlName = 'OverrideLocal';
                    Width = 10;

                    trigger OnBeforePassVariable();
                    begin
                        FormattedOverrideLocal := "Payroll Interface Jnl Line"."NS_Override Local";
                        if STRLEN(FormattedOverrideLocal) > 10 then
                            ERROR(Text001Lbl, "Payroll Interface Jnl Line".FIELDCAPTION("NS_Override Local"), 10);
                        while STRLEN(FormattedOverrideLocal) < 10 do
                            FormattedOverrideLocal := ' ' + FormattedOverrideLocal;
                    end;
                }
                textelement(formattedstatelocalmiscfield)
                {
                    XmlName = 'StateLocalMiscField';
                    Width = 1;

                    trigger OnBeforePassVariable();
                    begin
                        FormattedStateLocalMiscField := "Payroll Interface Jnl Line"."NS_State/Local Misc. Field";
                        if STRLEN(FormattedStateLocalMiscField) > 1 then
                            ERROR(Text001Lbl, "Payroll Interface Jnl Line".FIELDCAPTION("NS_State/Local Misc. Field"), 1);
                        if FormattedStateLocalMiscField = '' then
                            FormattedStateLocalMiscField := ' ';
                    end;
                }
                textelement(formattedrateno)
                {
                    XmlName = 'RateNo';
                    Width = 1;

                    trigger OnBeforePassVariable();
                    begin
                        FormattedRateNo := "Payroll Interface Jnl Line"."NS_Rate No.";
                        if STRLEN(FormattedRateNo) > 1 then
                            ERROR(Text001Lbl, "Payroll Interface Jnl Line".FIELDCAPTION("NS_Rate No."), 1);
                        if FormattedRateNo = '' then
                            FormattedRateNo := ' ';
                    end;
                }
                textelement(formattedsocsecnumber)
                {
                    XmlName = 'SocSecNumber';
                    Width = 11;

                    trigger OnBeforePassVariable();
                    begin
                        FormattedSocSecNumber := "Payroll Interface Jnl Line"."NS_Social Security No.";
                        if STRLEN(FormattedSocSecNumber) > 11 then
                            ERROR(Text001Lbl, "Payroll Interface Jnl Line".FIELDCAPTION("NS_Social Security No."), 11);
                        while STRLEN(FormattedSocSecNumber) < 11 do
                            FormattedSocSecNumber := ' ' + FormattedSocSecNumber;
                    end;
                }
                textelement(formattedfiller)
                {
                    XmlName = 'Filler';
                    Width = 6;

                    trigger OnBeforePassVariable();
                    begin
                        while STRLEN(FormattedFiller) < 6 do
                            FormattedFiller := ' ' + FormattedFiller;
                    end;
                }

                trigger OnAfterGetRecord();
                begin
                    "Payroll Interface Jnl Line"."NS_Export Status" := "Payroll Interface Jnl Line"."NS_Export Status"::Exported;
                    "Payroll Interface Jnl Line"."NS_Export Status Date/Time" := CURRENTDATETIME;
                    "Payroll Interface Jnl Line".MODIFY;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Instruction; Text000Lbl)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
            }
        }

        actions
        {
        }
    }

    trigger OnPreXmlPort();
    begin
        if "Payroll Interface Jnl Line".COUNT = 0 then
            ERROR(Text999Lbl);
        HumanResourcesSetup.GET;
    end;

    var
        Text000Lbl: Label 'Press OK to start the export.';
        Text001Lbl: Label '%1 cannot be longer than %2 characters.', Comment = '%1=NS_Social Security No.,%2=11';
        HumanResourcesSetup: Record "Human Resources Setup";
        Text002Lbl: Label '%1 must be specified in the %2 table.';
        Text003: Label '%1 in the %2 table cannot be longer than %3 characters.';
        Text004Lbl: Label '%1 must be specified.';
        Text005Lbl: Label '%1 cannot be greater than %2';
        Text006Lbl: Label '%1 cannot be less than %2';
        ExportCount: Integer;
        Text999Lbl: Label 'There are no lines in the journal with Export Status = <blank>';
}

