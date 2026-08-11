codeunit 14021102 "NS_Job Calendar Management"
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
        Customer: Record Customer;
        Vendor: Record Vendor;
        Location: Record Location;
        CompanyInfo: Record "Company Information";
        ServMgtSetup: Record "Service Mgt. Setup";
        ShippingAgentServices: Record "Shipping Agent Services";
        JobCalChange: Record "NS_Job Calendar Change";
        CustJobCalChange: Record "NS_Job Custom Calendar Change";
        CustJobCalEntry: Record "NS_Job Custom Calendar Entry";
        TempCustJobChange: Record "NS_Job Custom Calendar Change" temporary;
        TempCounter: Integer;
        CalculatedDays: Integer;
        CalendarCode: Code[10];
        OriginalDate: Date;
        DayName: Text[30];
        Text001: Label 'Yes';
        Text002: Label 'No';

    procedure NS_ShowJobCustomCalendar(ForSourcetype: Option Company,Customer,Vendor,Location,"Shipping Agent",Service; ForSourceCode: Code[20]; ForAdditionalSourceCode: Code[20]; ForJobCalendarCode: Code[10]);
    begin
        CustJobCalEntry.DELETEALL;
        CustJobCalEntry.INIT();
        CustJobCalEntry."NS_Source Type" := ForSourcetype;
        CustJobCalEntry."NS_Source Code" := ForSourceCode;
        CustJobCalEntry."NS_Additional Source Code" := ForAdditionalSourceCode;
        CustJobCalEntry."NS_Job Calendar Code" := ForJobCalendarCode;
        CustJobCalEntry.INSERT();
        //SPLN Missing reference PAGE.RUN(PAGE::Page14021141,CustJobCalEntry);
    end;

    procedure NS_GetJobCalendarCode(SourceType: Option Company,Customer,Vendor,Location,"Shipping Agent",Service; SourceCode: Code[20]; AdditionalSourceCode: Code[20]): Code[10];
    begin
        case SourceType of
            SourceType::Company:
                if CompanyInfo.GET then
                    exit(CompanyInfo."Base Calendar Code");
            SourceType::Customer:
                if Customer.GET(SourceCode) then
                    exit(Customer."NS_Job Calendar Code");
            SourceType::Vendor:
                if Vendor.GET(SourceCode) then
                    exit(Vendor."NS_Job Calendar Code");
            SourceType::"Shipping Agent":
                if ShippingAgentServices.GET(SourceCode, AdditionalSourceCode) then
                    exit(ShippingAgentServices."NS_Job Calendar Code")
                else
                    if CompanyInfo.GET then
                        exit(CompanyInfo."Base Calendar Code");
            SourceType::Location:
                if Location.GET(SourceCode) then
                    if Location."NS_Job Calendar Code" <> '' then
                        exit(Location."NS_Job Calendar Code")
                    else
                        if CompanyInfo.GET then
                            exit(CompanyInfo."Base Calendar Code");
            SourceType::Service:
                if ServMgtSetup.GET then
                    exit(ServMgtSetup."Base Calendar Code");
        end;
    end;

    procedure NS_CheckDateStatus(JobCalendarCode: Code[10]; TargetDate: Date; var Description: Text[50]): Boolean;
    begin
        JobCalChange.RESET();
        JobCalChange.SETRANGE("NS_Job Calendar Code", JobCalendarCode);
        if JobCalChange.FINDSET() then
            repeat
                case JobCalChange."NS_Recurring System" of
                    JobCalChange."NS_Recurring System"::" ":
                        if TargetDate = JobCalChange.NS_Date then begin
                            Description := JobCalChange.NS_Description;
                            exit(JobCalChange.NS_Nonworking);
                        end;
                    JobCalChange."NS_Recurring System"::"Weekly Recurring":
                        if DATE2DWY(TargetDate, 1) = JobCalChange.NS_Day then begin
                            Description := JobCalChange.NS_Description;
                            exit(JobCalChange.NS_Nonworking);
                        end;
                    JobCalChange."NS_Recurring System"::"Annual Recurring":
                        if (DATE2DMY(TargetDate, 2) = DATE2DMY(JobCalChange.NS_Date, 2)) and
                           (DATE2DMY(TargetDate, 1) = DATE2DMY(JobCalChange.NS_Date, 1))
                        then begin
                            Description := JobCalChange.NS_Description;
                            exit(JobCalChange.NS_Nonworking);
                        end;
                end;
            until JobCalChange.NEXT() = 0;
        Description := '';
    end;

    procedure NS_CheckJobCustomDateStatus(SourceType: Option Company,Customer,Vendor,Location,"Shipping Agent",Service; SourceCode: Code[20]; AdditionalSourceCode: Code[20]; JobCalendarCode: Code[10]; TargetDate: Date; var Description: Text[50]): Boolean;
    begin
        NS_CombineChanges(SourceType, SourceCode, AdditionalSourceCode, JobCalendarCode);
        TempCustJobChange.RESET;
        TempCustJobChange.SETCURRENTKEY("NS_Entry No.");
        if TempCustJobChange.FINDSET then
            repeat
                case TempCustJobChange."NS_Recurring System" of
                    TempCustJobChange."NS_Recurring System"::" ":
                        if TargetDate = TempCustJobChange.NS_Date then begin
                            Description := TempCustJobChange.NS_Description;
                            exit(TempCustJobChange.NS_Nonworking);
                        end;

                    TempCustJobChange."NS_Recurring System"::"Weekly Recurring":
                        if DATE2DWY(TargetDate, 1) = TempCustJobChange.NS_Day then begin
                            Description := TempCustJobChange.NS_Description;
                            exit(TempCustJobChange.NS_Nonworking);
                        end;

                    TempCustJobChange."NS_Recurring System"::"Annual Recurring":
                        if (DATE2DMY(TargetDate, 2) = DATE2DMY(TempCustJobChange.NS_Date, 2)) and
                           (DATE2DMY(TargetDate, 1) = DATE2DMY(TempCustJobChange.NS_Date, 1))
                        then begin
                            Description := TempCustJobChange.NS_Description;
                            exit(TempCustJobChange.NS_Nonworking);
                        end;
                end;
            until TempCustJobChange.NEXT() = 0;
        Description := '';
    end;

    procedure NS_CombineChanges(SourceType: Option Company,Customer,Vendor,Location,"Shipping Agent",Service; SourceCode: Code[20]; AdditionalSourceCode: Code[20]; JobCalendarCode: Code[10]);
    begin
        TempCustJobChange.RESET();
        TempCustJobChange.DELETEALL();

        TempCounter := 0;
        CustJobCalChange.RESET();
        CustJobCalChange.SETRANGE("NS_Source Type", SourceType);
        CustJobCalChange.SETRANGE("NS_Source Code", SourceCode);
        CustJobCalChange.SETRANGE("NS_Job Calendar Code", JobCalendarCode);
        CustJobCalChange.SETRANGE("NS_Additional Source Code", AdditionalSourceCode);
        if CustJobCalChange.FINDSET() then
            repeat
                TempCounter := TempCounter + 1;
                TempCustJobChange.INIT();
                TempCustJobChange."NS_Source Type" := CustJobCalChange."NS_Source Type";
                TempCustJobChange."NS_Source Code" := CustJobCalChange."NS_Source Code";
                TempCustJobChange."NS_Job Calendar Code" := CustJobCalChange."NS_Job Calendar Code";
                TempCustJobChange."NS_Additional Source Code" := CustJobCalChange."NS_Additional Source Code";
                TempCustJobChange.NS_Date := CustJobCalChange.NS_Date;
                TempCustJobChange.NS_Description := CustJobCalChange.NS_Description;
                TempCustJobChange.NS_Day := CustJobCalChange.NS_Day;
                TempCustJobChange.NS_Nonworking := CustJobCalChange.NS_Nonworking;
                TempCustJobChange."NS_Recurring System" := CustJobCalChange."NS_Recurring System";
                TempCustJobChange."NS_Entry No." := TempCounter;
                TempCustJobChange.INSERT();
            until CustJobCalChange.NEXT() = 0;

        JobCalChange.RESET();
        JobCalChange.SETRANGE("NS_Job Calendar Code", JobCalendarCode);
        if JobCalChange.FINDSET() then
            repeat
                TempCounter := TempCounter + 1;
                TempCustJobChange.INIT();
                TempCustJobChange."NS_Entry No." := TempCounter;
                TempCustJobChange."NS_Source Type" := SourceType;
                TempCustJobChange."NS_Source Code" := SourceCode;
                TempCustJobChange."NS_Job Calendar Code" := JobCalChange."NS_Job Calendar Code";
                TempCustJobChange.NS_Date := JobCalChange.NS_Date;
                TempCustJobChange.NS_Description := JobCalChange.NS_Description;
                TempCustJobChange.NS_Day := JobCalChange.NS_Day;
                TempCustJobChange.NS_Nonworking := JobCalChange.NS_Nonworking;
                TempCustJobChange."NS_Recurring System" := JobCalChange."NS_Recurring System";
                TempCustJobChange.INSERT();
            until JobCalChange.NEXT() = 0;
    end;

    procedure NS_CreateWhereUsedEntries(JobCalendarCode: Code[10]);
    var
        WhereUsedJobCalendar: Record "NS_Where Used Job Calendar";
    begin
        WhereUsedJobCalendar.DELETEALL();
        if CompanyInfo.GET then
            if CompanyInfo."Base Calendar Code" = JobCalendarCode then begin
                WhereUsedJobCalendar.INIT();
                WhereUsedJobCalendar."NS_Job Calendar Code" := JobCalendarCode;
                WhereUsedJobCalendar."NS_Source Type" := WhereUsedJobCalendar."NS_Source Type"::Company;
                WhereUsedJobCalendar."NS_Source Name" := CompanyInfo.Name;
                WhereUsedJobCalendar."NS_Job Custom Changes Exist" :=
                  NS_JobCustomChangesExist(
                    WhereUsedJobCalendar."NS_Source Type"::Company, '', '', JobCalendarCode);
                WhereUsedJobCalendar.INSERT();
            end;

        Customer.RESET();
        Customer.SETRANGE("NS_Job Calendar Code", JobCalendarCode);
        if Customer.FINDSET() then
            repeat
                WhereUsedJobCalendar.INIT();
                WhereUsedJobCalendar."NS_Job Calendar Code" := JobCalendarCode;
                WhereUsedJobCalendar."NS_Source Type" := WhereUsedJobCalendar."NS_Source Type"::Customer;
                WhereUsedJobCalendar."NS_Source Code" := Customer."No.";
                WhereUsedJobCalendar."NS_Source Name" := Customer.Name;
                WhereUsedJobCalendar."NS_Job Custom Changes Exist" :=
                  NS_JobCustomChangesExist(
                    WhereUsedJobCalendar."NS_Source Type"::Customer, Customer."No.", '', JobCalendarCode);
                WhereUsedJobCalendar.INSERT();
            until Customer.NEXT() = 0;

        Vendor.RESET();
        Vendor.SETRANGE("NS_Job Calendar Code", JobCalendarCode);
        if Vendor.FINDSET() then
            repeat
                WhereUsedJobCalendar.INIT();
                WhereUsedJobCalendar."NS_Job Calendar Code" := JobCalendarCode;
                WhereUsedJobCalendar."NS_Source Type" := WhereUsedJobCalendar."NS_Source Type"::Vendor;
                WhereUsedJobCalendar."NS_Source Code" := Vendor."No.";
                WhereUsedJobCalendar."NS_Source Name" := Vendor.Name;
                WhereUsedJobCalendar."NS_Job Custom Changes Exist" :=
                  NS_JobCustomChangesExist(
                    WhereUsedJobCalendar."NS_Source Type"::Vendor, Vendor."No.", '', JobCalendarCode);
                WhereUsedJobCalendar.INSERT();
            until Vendor.NEXT() = 0;

        Location.RESET();
        Location.SETRANGE("NS_Job Calendar Code", JobCalendarCode);
        if Location.FINDSET() then
            repeat
                WhereUsedJobCalendar.INIT();
                WhereUsedJobCalendar."NS_Job Calendar Code" := JobCalendarCode;
                WhereUsedJobCalendar."NS_Source Type" := WhereUsedJobCalendar."NS_Source Type"::Location;
                WhereUsedJobCalendar."NS_Source Code" := Location.Code;
                WhereUsedJobCalendar."NS_Source Name" := Location.Name;
                WhereUsedJobCalendar."NS_Job Custom Changes Exist" :=
                  NS_JobCustomChangesExist(
                    WhereUsedJobCalendar."NS_Source Type"::Location, Location.Code, '', JobCalendarCode);
                WhereUsedJobCalendar.INSERT();
            until Location.NEXT() = 0;

        ShippingAgentServices.RESET();
        ShippingAgentServices.SETRANGE("NS_Job Calendar Code", JobCalendarCode);
        if ShippingAgentServices.FINDSET() then
            repeat
                WhereUsedJobCalendar.INIT();
                WhereUsedJobCalendar."NS_Job Calendar Code" := JobCalendarCode;
                WhereUsedJobCalendar."NS_Source Type" := WhereUsedJobCalendar."NS_Source Type"::"Shipping Agent";
                WhereUsedJobCalendar."NS_Source Code" := ShippingAgentServices."Shipping Agent Code";
                WhereUsedJobCalendar."NS_Additional Source Code" := ShippingAgentServices.Code;
                WhereUsedJobCalendar."NS_Source Name" := ShippingAgentServices.Description;
                WhereUsedJobCalendar."NS_Job Custom Changes Exist" :=
                  NS_JobCustomChangesExist(
                    WhereUsedJobCalendar."NS_Source Type"::"Shipping Agent", ShippingAgentServices."Shipping Agent Code",
                    ShippingAgentServices.Code, JobCalendarCode);
                WhereUsedJobCalendar.INSERT();
            until ShippingAgentServices.NEXT() = 0;

        if ServMgtSetup.GET then
            if ServMgtSetup."Base Calendar Code" = JobCalendarCode then begin
                WhereUsedJobCalendar.INIT();
                WhereUsedJobCalendar."NS_Job Calendar Code" := JobCalendarCode;
                WhereUsedJobCalendar."NS_Source Type" := WhereUsedJobCalendar."NS_Source Type"::Service;
                WhereUsedJobCalendar."NS_Source Name" := ServMgtSetup.TABLECAPTION;
                WhereUsedJobCalendar."NS_Job Custom Changes Exist" :=
                  NS_JobCustomChangesExist(
                    WhereUsedJobCalendar."NS_Source Type"::Service, '', '', JobCalendarCode);
                WhereUsedJobCalendar.INSERT();
            end;


        COMMIT;
    end;

    procedure NS_JobCustomChangesExist(SourceType: Option Company,Customer,Vendor,Location,"Shipping Agent",Service; SourceCode: Code[20]; AdditionalSourceCode: Code[20]; JobCalendarCode: Code[10]): Boolean;
    begin
        CustJobCalChange.RESET();
        CustJobCalChange.SETRANGE("NS_Source Type", SourceType);
        CustJobCalChange.SETRANGE("NS_Source Code", SourceCode);
        CustJobCalChange.SETRANGE("NS_Additional Source Code", AdditionalSourceCode);
        CustJobCalChange.SETRANGE("NS_Job Calendar Code", JobCalendarCode);
        if CustJobCalChange.FINDFIRST() then
            exit(true);
    end;

    procedure NS_JobCustomCalendarExistText(SourceType: Option Company,Customer,Vendor,Location,"Shipping Agent",Service; SourceCode: Code[20]; AdditionalSourceCode: Code[20]; JobCalendarCode: Code[10]): Text[10];
    begin
        if NS_JobCustomChangesExist(SourceType, SourceCode, AdditionalSourceCode, JobCalendarCode) then
            exit(Text001);
        exit(Text002);
    end;

    procedure NS_CalcDateBOC(OrgDateExpression: Text[30]; OrgDate: Date; FirstSourceType: Option Company,Customer,Vendor,Location,"Shipping Agent"; FirstSourceCode: Code[20]; FirstAddCode: Code[20]; SecondSourceType: Option Company,Customer,Vendor,Location,"Shipping Agent"; SecondSourceCode: Code[20]; SecondAddCode: Code[20]; CheckBothCalendars: Boolean): Date;
    var
        FirstJobCalCode: Code[10];
        SecondJobCalCode: Code[10];
        LoopTerminator: Boolean;
        LoopCounter: Integer;
        NewDate: Date;
        TempDesc: Text[30];
        Nonworking: Boolean;
        Nonworking2: Boolean;
        LoopFactor: Integer;
        CalConvTimeFrame: Integer;
        DateFormula: DateFormula;
        Ok: Boolean;
        NegDateFormula: DateFormula;
    begin
        if (FirstSourceType = FirstSourceType::"Shipping Agent") and
           ((FirstSourceCode = '') or (FirstAddCode = ''))
        then begin
            FirstSourceType := FirstSourceType::Company;
            FirstSourceCode := '';
            FirstAddCode := '';
        end;
        if (SecondSourceType = SecondSourceType::"Shipping Agent") and
           ((SecondSourceCode = '') or (SecondAddCode = ''))
        then begin
            SecondSourceType := SecondSourceType::Company;
            SecondSourceCode := '';
            SecondAddCode := '';
        end;
        if (FirstSourceType = FirstSourceType::Location) and
           (FirstSourceCode = '')
        then begin
            FirstSourceType := FirstSourceType::Company;
            FirstSourceCode := '';
        end;
        if (SecondSourceType = SecondSourceType::Location) and
           (SecondSourceCode = '')
        then begin
            SecondSourceType := SecondSourceType::Company;
            SecondSourceCode := '';
        end;
        if CompanyInfo.GET then
            CalConvTimeFrame := CALCDATE(CompanyInfo."Cal. Convergence Time Frame", WORKDATE) - WORKDATE;

        FirstJobCalCode := NS_GetJobCalendarCode(FirstSourceType, FirstSourceCode, FirstAddCode);
        SecondJobCalCode := NS_GetJobCalendarCode(SecondSourceType, SecondSourceCode, SecondAddCode);
        EVALUATE(DateFormula, OrgDateExpression);
        EVALUATE(NegDateFormula, '<-0D>');

        if OrgDate = 0D then
            OrgDate := WORKDATE;
        if (CALCDATE(DateFormula, OrgDate) >= OrgDate) and (DateFormula <> NegDateFormula) then
            LoopFactor := 1
        else
            LoopFactor := -1;

        NewDate := OrgDate;
        if CALCDATE(DateFormula, OrgDate) <> OrgDate then begin
            repeat
                NewDate := NewDate + LoopFactor;
                if CheckBothCalendars and (FirstJobCalCode = '') and (SecondJobCalCode <> '') then
                    Ok := not (
                      NS_CheckJobCustomDateStatus(
                        SecondSourceType, SecondSourceCode, SecondAddCode, SecondJobCalCode, NewDate, TempDesc))
                else
                    Ok := not (
                      NS_CheckJobCustomDateStatus(
                        FirstSourceType, FirstSourceCode, FirstAddCode, FirstJobCalCode, NewDate, TempDesc));
                if Ok then
                    LoopCounter := LoopCounter + 1;
                if NewDate >= OrgDate + CalConvTimeFrame then
                    LoopCounter := ABS(CALCDATE(DateFormula, OrgDate) - OrgDate);
            until LoopCounter = ABS(CALCDATE(DateFormula, OrgDate) - OrgDate);
        end;

        LoopCounter := 0;
        repeat
            LoopCounter := LoopCounter + 1;
            Nonworking :=
              NS_CheckJobCustomDateStatus(
                FirstSourceType, FirstSourceCode, FirstAddCode, FirstJobCalCode, NewDate, TempDesc);
            Nonworking2 :=
              NS_CheckJobCustomDateStatus(
                SecondSourceType, SecondSourceCode, SecondAddCode, SecondJobCalCode, NewDate, TempDesc);
            if Nonworking then begin
                NewDate := NewDate + LoopFactor;
            end else begin
                if not CheckBothCalendars then begin
                    exit(NewDate);
                end else begin
                    if (Nonworking = false) and
                       (Nonworking2 = false) then
                        exit(NewDate)
                    else
                        NewDate := NewDate + LoopFactor;
                end;
            end;
            if LoopCounter >= CalConvTimeFrame then
                LoopTerminator := true;
        until LoopTerminator = true;
        exit(NewDate);
    end;

    procedure NS_CalcDateBOC2(OrgDateExpression: Text[30]; OrgDate: Date; FirstSourceType: Option Company,Customer,Vendor,Location,"Shipping Agent"; FirstSourceCode: Code[20]; FirstAddCode: Code[20]; SecondSourceType: Option Company,Customer,Vendor,Location,"Shipping Agent"; SecondSourceCode: Code[20]; SecondAddCode: Code[20]; CheckBothCalendars: Boolean): Date;
    var
        NewOrgDateExpression: Text[30];
    begin
        // Use this procedure to subtract time expression.
        NewOrgDateExpression := NS_ReverseSign(OrgDateExpression);
        exit(NS_CalcDateBOC(NewOrgDateExpression, OrgDate, FirstSourceType, FirstSourceCode, FirstAddCode,
          SecondSourceType, SecondSourceCode, SecondAddCode, CheckBothCalendars));
    end;

    local procedure NS_ReverseSign(DateFormulaExpr: Text[30]): Text[30];
    var
        NewDateFormulaExpr: Text[30];
    begin
        NewDateFormulaExpr := CONVERTSTR(DateFormulaExpr, '+-', '-+');
        if not (DateFormulaExpr[1] in ['+', '-']) then
            NewDateFormulaExpr := '-' + NewDateFormulaExpr;
        exit(NewDateFormulaExpr);
    end;
}

