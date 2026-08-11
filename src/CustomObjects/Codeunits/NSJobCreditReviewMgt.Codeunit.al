codeunit 14021402 "NS_Job CreditReviewMgt."
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
        CreditReviewEntry: Record "NS_Job Credit Review Ent.";
        TempCustNo: Code[20];
        TempCustName: Text[50];

    procedure NS_Approve(_CreditReviewEntry: Record "NS_Job Credit Review Ent."; _EntryText: Text[250]);
    begin
        // called from page; if called separately, be sure to call function Authorize

        if _CreditReviewEntry."NS_No." = '' then
            exit;

        _CreditReviewEntry.TESTFIELD(NS_Status, _CreditReviewEntry.NS_Status::Review);
        _CreditReviewEntry.TESTFIELD("NS_Release Attempted", true);
        NS_NewCreditReviewEntry(_CreditReviewEntry."NS_Table ID"
                            , _CreditReviewEntry."NS_No."
                            , _CreditReviewEntry."NS_Document Area"
                            , _CreditReviewEntry."NS_Document Type"
                            , _CreditReviewEntry."NS_Document Amount"
                            , CreditReviewEntry.NS_Status::Approved
                            , _EntryText);
        COMMIT;
        NS_ReleaseDocument(_CreditReviewEntry);
    end;

    procedure NS_AttemptRelease(_TableID: Integer; _No: Code[20]; _DocArea: Integer; _DocType: Integer);
    var
        _CreditReviewEntry: Record "NS_Job Credit Review Ent.";
    begin
        // called from function PerformManualRelease in Codeunit 414

        _CreditReviewEntry.SETCURRENTKEY("NS_Table ID", "NS_No.", "NS_Document Area", "NS_Document Type");
        _CreditReviewEntry.SETRANGE("NS_Table ID", _TableID);
        _CreditReviewEntry.SETRANGE("NS_No.", _No);
        _CreditReviewEntry.SETRANGE("NS_Document Area", _DocArea);
        _CreditReviewEntry.SETRANGE("NS_Document Type", _DocType);
        _CreditReviewEntry.SETRANGE("NS_Last Entry", true);
        if not _CreditReviewEntry.FINDFIRST then
            exit;

        with _CreditReviewEntry do
            if NS_Status <> NS_Status::Review then
                exit;

        _CreditReviewEntry."NS_Release Attempted" := true;
        _CreditReviewEntry.MODIFY;
        COMMIT;
    end;

    procedure NS_Authorize(_ErrorText: Text[250]);
    var
        _UserSetup: Record "User Setup";
    begin
        _UserSetup.GET(USERID);
        //IF NOT _UserSetup."Credit Review Authorization" THEN
        //ERROR(_ErrorText);
    end;

    procedure NS_ClearLastEntry(_TableID: Integer; _No: Code[20]; _DocArea: Integer; _DocType: Integer);
    var
        _CreditReviewEntry: Record "NS_Job Credit Review Ent.";
    begin
        _CreditReviewEntry.SETCURRENTKEY("NS_Table ID", "NS_No.", "NS_Document Area", "NS_Document Type");
        _CreditReviewEntry.SETRANGE("NS_Table ID", _TableID);
        _CreditReviewEntry.SETRANGE("NS_No.", _No);
        _CreditReviewEntry.SETRANGE("NS_Document Area", _DocArea);
        _CreditReviewEntry.SETRANGE("NS_Document Type", _DocType);
        _CreditReviewEntry.SETRANGE("NS_Last Entry", true);
        _CreditReviewEntry.MODIFYALL("NS_Last Entry", false);
    end;

    procedure NS_ConvertToCustomer(_Contact: Record Contact; _Customer: Record Customer);
    var
        _CreditLimitEntry: Record "NS_Job Credit Limit Entry";
        _CreditLimitEntry2: Record "NS_Job Credit Limit Entry";
        _Customer2: Record Customer;
    begin
        _CreditLimitEntry.SETCURRENTKEY("NS_Table ID", "NS_No.", "NS_Effective Date", "NS_Expiration Date");
        _CreditLimitEntry.SETRANGE("NS_Table ID", DATABASE::Contact);
        _CreditLimitEntry.SETRANGE("NS_No.", _Contact."No.");
        if _CreditLimitEntry.FINDSET(false) then
            repeat
                CLEAR(_CreditLimitEntry2);
                _CreditLimitEntry2 := _CreditLimitEntry;
                _CreditLimitEntry2."NS_Table ID" := DATABASE::Customer;
                _CreditLimitEntry2."NS_No." := _Customer."No.";
                _CreditLimitEntry2."NS_Modified by" := '';
                _CreditLimitEntry2."NS_Modified at Date" := 0D;
                _CreditLimitEntry2."NS_Modified at Time" := 000000T;
                _CreditLimitEntry2.INSERT(true);
            until _CreditLimitEntry.NEXT = 0;

        if _Contact."NS_Credit Approval Complete" <> 0D then begin
            _Customer2.GET(_Customer."No.");
            _Customer2."NS_Credit Approval Complete" := _Contact."NS_Credit Approval Complete";
            _Customer2.MODIFY;
        end;
    end;

    procedure NS_CreditReviewCheck(_TableID: Integer; _No: Code[20]; _DocArea: Integer; _DocType: Integer);
    var
        _CreditReviewEntry: Record "NS_Job Credit Review Ent.";
        _Text000: Label 'Document is under credit review and may not be modified or released at this time.';
    begin
        _CreditReviewEntry.SETCURRENTKEY("NS_Table ID", "NS_No.", "NS_Document Area", "NS_Document Type");
        _CreditReviewEntry.SETRANGE("NS_Table ID", _TableID);
        _CreditReviewEntry.SETRANGE("NS_No.", _No);
        _CreditReviewEntry.SETRANGE("NS_Document Area", _DocArea);
        _CreditReviewEntry.SETRANGE("NS_Document Type", _DocType);
        _CreditReviewEntry.SETRANGE("NS_Last Entry", true);
        _CreditReviewEntry.SETRANGE("NS_Release Attempted", true);
        if not _CreditReviewEntry.FINDFIRST then
            exit;

        with _CreditReviewEntry do
            if NS_Status in [NS_Status::Review] then
                ERROR(_Text000);
    end;

    procedure NS_GetCreditLimit(_TableID: Integer; _No: Code[20]): Decimal;
    var
        _CreditLimitEntry: Record "NS_Job Credit Limit Entry";
    begin
        _CreditLimitEntry.SETCURRENTKEY("NS_Table ID", "NS_No.", "NS_Effective Date", "NS_Expiration Date");
        _CreditLimitEntry.SETRANGE("NS_Table ID", _TableID);
        _CreditLimitEntry.SETRANGE("NS_No.", _No);
        _CreditLimitEntry.SETRANGE("NS_Effective Date", 0D, WORKDATE);
        _CreditLimitEntry.SETFILTER("NS_Expiration Date", '%1|%2..', 0D, WORKDATE);
        _CreditLimitEntry.CALCSUMS("NS_Credit Limit");
        exit(_CreditLimitEntry."NS_Credit Limit");
    end;

    procedure NS_GetLastCreditReviewStatus(_TableID: Integer; _No: Code[20]; _DocArea: Integer; _DocType: Integer): Text[30];
    var
        _CreditReviewEntry: Record "NS_Job Credit Review Ent.";
        _Text000: Label 'None';
    begin
        _CreditReviewEntry.SETCURRENTKEY("NS_Table ID", "NS_No.", "NS_Document Area", "NS_Document Type");
        _CreditReviewEntry.SETRANGE("NS_Table ID", _TableID);
        _CreditReviewEntry.SETRANGE("NS_No.", _No);
        _CreditReviewEntry.SETRANGE("NS_Document Area", _DocArea);
        _CreditReviewEntry.SETRANGE("NS_Document Type", _DocType);
        _CreditReviewEntry.SETRANGE("NS_Last Entry", true);
        if _CreditReviewEntry.FINDFIRST then
            exit(COPYSTR(FORMAT(_CreditReviewEntry.NS_Status), 1, 30))
        else
            exit(_Text000);
    end;

    procedure NS_GetPastDueBalanceGracePeriod(_Customer: Record Customer) _ReturnVal: Text[250];
    var
        _SalesSetup: Record "Sales & Receivables Setup";
    begin
        _ReturnVal := FORMAT(_Customer."NS_Past Due BalanceGracePeriod");
        if _ReturnVal <> '' then begin
            if _ReturnVal[1] <> '-' then
                _ReturnVal := '-' + _ReturnVal;
            exit;
        end;

        _SalesSetup.GET;
        _ReturnVal := FORMAT(_SalesSetup."NS_Past Due BalanceGracePeriod");
        if _ReturnVal <> '' then
            if _ReturnVal[1] <> '-' then
                _ReturnVal := '-' + _ReturnVal;
    end;

    procedure NS_GetPriorApprovedAmount(_TableID: Integer; _No: Code[20]; _DocArea: Integer; _DocType: Integer): Decimal;
    var
        _CreditReviewEntry: Record "NS_Job Credit Review Ent.";
    begin
        _CreditReviewEntry.SETCURRENTKEY("NS_Table ID", "NS_No.", "NS_Document Area", "NS_Document Type");
        _CreditReviewEntry.SETRANGE("NS_Table ID", _TableID);
        _CreditReviewEntry.SETRANGE("NS_No.", _No);
        _CreditReviewEntry.SETRANGE("NS_Document Area", _DocArea);
        _CreditReviewEntry.SETRANGE("NS_Document Type", _DocType);
        _CreditReviewEntry.SETRANGE(NS_Status, _CreditReviewEntry.NS_Status::Approved);
        if not _CreditReviewEntry.FINDLAST then
            exit(0);

        exit(_CreditReviewEntry."NS_Document Amount");
    end;

    procedure NS_NewCreditReviewEntry(_TableID: Integer; _No: Code[20]; _DocArea: Integer; _DocType: Integer; _DocAmount: Decimal; _Status: Integer; _EntryText: Text[250]);
    var
        _Customer: Record Customer;
        _SalesHeader: Record "Sales Header";
        _LastEntry: Boolean;
        _CustomerNo: Code[20];
        _CustomerName: Text[50];
    begin
        _LastEntry := _Status in [CreditReviewEntry.NS_Status::Review, CreditReviewEntry.NS_Status::Approved];
        if _LastEntry then
            NS_ClearLastEntry(_TableID, _No, _DocArea, _DocType);

        if _TableID = DATABASE::"Sales Header" then
            if _SalesHeader.GET(_DocType, _No) then begin
                if _Customer.GET(_SalesHeader."Bill-to Customer No.") then begin
                    _CustomerNo := _Customer."No.";
                    _CustomerName := _Customer.Name;
                end;
                if _Status = CreditReviewEntry.NS_Status::Approved then begin
                    _SalesHeader."NS_Credit Approved By" := USERID;
                    _SalesHeader."NS_Credit Approved On" := CURRENTDATETIME;
                    _SalesHeader.MODIFY;
                end;
            end;

        if (_CustomerNo = '') and (TempCustNo <> '') then begin
            _CustomerNo := TempCustNo;
            _CustomerName := TempCustName;
            CLEAR(TempCustNo);
            CLEAR(TempCustName);
        end;

        CLEAR(CreditReviewEntry);
        with CreditReviewEntry do begin
            INIT;
            "NS_Table ID" := _TableID;
            "NS_No." := _No;
            "NS_Document Area" := _DocArea;
            "NS_Document Type" := _DocType;
            "NS_Document Amount" := _DocAmount;
            NS_Status := _Status;
            "NS_Customer No." := _CustomerNo;
            "NS_Customer Name" := _CustomerName;
            "NS_Entry Text" := _EntryText;
            "NS_Last Entry" := _LastEntry;
            INSERT(true);
        end;
    end;

    procedure NS_OnInsertSalesHeader(var _SalesHeader: Record "Sales Header");
    var
        _CreditReviewEntry: Record "NS_Job Credit Review Ent.";
    begin
        // called from OnInsert of T36

        with _CreditReviewEntry do begin
            SETCURRENTKEY("NS_Table ID", "NS_No.", "NS_Document Area", "NS_Document Type");
            SETRANGE("NS_Table ID", DATABASE::"Sales Header");
            SETRANGE("NS_Document Area", "NS_Document Area"::Sales);
            SETRANGE("NS_Customer No.", _SalesHeader."Bill-to Customer No.");
            SETRANGE("NS_Created by", USERID);
            SETRANGE("NS_Last Entry", true);
            SETFILTER("NS_No.", '%1', '');
            if FINDLAST then begin
                "NS_Document Type" := _SalesHeader."Document Type".AsInteger();
                "NS_No." := _SalesHeader."No.";
                MODIFY;
            end;
        end;
    end;

    procedure NS_OnModifySalesHeader(_SalesHeader: Record "Sales Header");
    begin
        NS_CreditReviewCheck(DATABASE::"Sales Header"
                         , _SalesHeader."No."
                         , 0         // Document Area::Sales
                         , _SalesHeader."Document Type".AsInteger());
    end;

    procedure NS_OnModifySalesLine(_SalesLine: Record "Sales Line");
    var
        _SalesHeader: Record "Sales Header";
    begin
        if not _SalesHeader.GET(_SalesLine."Document Type", _SalesLine."Document No.") then
            exit;
        NS_CreditReviewCheck(DATABASE::"Sales Header"
                         , _SalesHeader."No."
                         , 0         // Document Area::Sales
                         , _SalesHeader."Document Type".AsInteger());
    end;

    procedure NS_OpenSource(_CreditReviewEntry: Record "NS_Job Credit Review Ent.");
    var
        _Customer: Record Customer;
        _SalesHeader: Record "Sales Header";
    begin
        // called from Page 14021420

        with _CreditReviewEntry do
            case "NS_Table ID" of
                DATABASE::Customer:
                    if _Customer.GET("NS_No.") then
                        PAGE.RUN(PAGE::"Customer Card", _Customer);
                DATABASE::"Sales Header":
                    if _SalesHeader.GET("NS_Document Type", "NS_No.") then
                        case "NS_Document Type" of
                            "NS_Document Type"::Quote:
                                PAGE.RUN(PAGE::"Sales Quote", _SalesHeader);
                            "NS_Document Type"::Order:
                                PAGE.RUN(PAGE::"Sales Order", _SalesHeader);
                        end;
            end;
    end;

    procedure NS_OnValidateCreditApprovalComplete(_TableID: Integer; _No: Code[20]; _EntryText: Text[250]; _ErrorText: Text[250]);
    var
        _CreditReviewEntry: Record "NS_Job Credit Review Ent.";
    begin
        NS_Authorize(_ErrorText);
        NS_NewCreditReviewEntry(_TableID
                            , _No
                            , 0             // CreditReviewEntry.Document Area::Sales
                            , 0             // CreditReviewEntry.Document Type::Quote
                            , 0             // CreditReviewEntry.Document Amount
                            , 0             // CreditReviewEntry.Status::Message
                            , _EntryText);
    end;

    procedure NS_ReleaseDocument(_CreditReviewEntry: Record "NS_Job Credit Review Ent.");
    var
        _SalesHeader: Record "Sales Header";
    begin
        with _CreditReviewEntry do
            case "NS_Document Area" of
                "NS_Document Area"::Sales:
                    if _SalesHeader.GET("NS_Document Type", "NS_No.") then
                        CODEUNIT.RUN(CODEUNIT::"Release Sales Document", _SalesHeader);
            end;
    end;

    procedure NS_Reopen(var _CreditReviewEntry: Record "NS_Job Credit Review Ent.");
    begin
        // called from page 14021420; if called separately, be sure to call function Authorize

        if _CreditReviewEntry."NS_No." = '' then
            exit;

        _CreditReviewEntry.TESTFIELD(NS_Status, _CreditReviewEntry.NS_Status::Review);
        _CreditReviewEntry.TESTFIELD("NS_Release Attempted", true);
        _CreditReviewEntry."NS_Release Attempted" := false;
        _CreditReviewEntry.MODIFY;
    end;

    procedure NS_SalesHeaderCreditReviewCheck(_SalesHeader: Record "Sales Header");
    var
        _Customer: Record Customer;
        _SalesSetup: Record "Sales & Receivables Setup";
        _ApprovedAmount: Decimal;
        _DocumentAmount: Decimal;
        _CustCheckCreditLimit: Page "Check Credit Limit";
        _EntryText: Text[250];
        Customer: Record Customer;
        CrReviewToleranceAmt: Decimal;
    begin
        // initial check to see if it is pending credit review
        NS_CreditReviewCheck(DATABASE::"Sales Header"
                         , _SalesHeader."No."
                         , 0         // Document Area::Sales
                         , _SalesHeader."Document Type".AsInteger());

        // called from Codeunit 312

        CLEAR(_CustCheckCreditLimit);

        // tolerance check - if approved already, and amount is within tolerance, exit the function

        _SalesSetup.GET;
        _DocumentAmount := NS_SalesHeaderGetTotalForDocument(_SalesHeader);
        _ApprovedAmount := NS_GetPriorApprovedAmount(DATABASE::"Sales Header"
                                                 , _SalesHeader."No."
                                                 , 0             // CreditReviewEntry.Document Area::Sales
                                                 , _SalesHeader."Document Type".AsInteger());
        if not Customer.GET(_SalesHeader."Bill-to Customer No.") then
            Customer.INIT;
        if Customer.NS_CreditReviewToleranceAmount <> 0 then
            CrReviewToleranceAmt := Customer.NS_CreditReviewToleranceAmount
        else
            CrReviewToleranceAmt := _SalesSetup.NS_CreditReviewToleranceAmount;

        //IF _DocumentAmount <= _ApprovedAmount + CrReviewToleranceAmt THEN
        //   _CustCheckCreditLimit.SetApproved;

        // credit check

        //PPNA16.0 Blocked Start
        // if not _CustCheckCreditLimit.SalesHeaderShowWarning(_SalesHeader) then
        //     exit;
        //PPNA16.0 Blocked End

        // generate new Review entry

        if _SalesHeader."No." = '' then begin
            TempCustNo := _SalesHeader."Bill-to Customer No.";
            if _Customer.GET(TempCustNo) then
                TempCustName := _Customer.Name;
        end;

        _EntryText := _CustCheckCreditLimit.GetHeading;
        NS_NewCreditReviewEntry(DATABASE::"Sales Header"
                            , _SalesHeader."No."
                            , 0             // CreditReviewEntry.Document Area::Sales
                            , _SalesHeader."Document Type".AsInteger()
                            , _DocumentAmount
                            , CreditReviewEntry.NS_Status::Review
                            , _EntryText);
    end;

    procedure NS_SalesHeaderGetTotalForDocument(_SalesHeader: Record "Sales Header") _LineAmount: Decimal;
    var
        _SalesLine: Record "Sales Line";
    begin
        _SalesLine.SETRANGE("Document Type", _SalesHeader."Document Type");
        _SalesLine.SETRANGE("Document No.", _SalesHeader."No.");
        if _SalesLine.FINDSET(false) then
            repeat
                _LineAmount += _SalesLine."Line Amount";
            until _SalesLine.NEXT = 0;
    end;

    procedure NS_SalesLineCreditReviewCheck(_SalesLine: Record "Sales Line");
    var
        _SalesSetup: Record "Sales & Receivables Setup";
        _ApprovedAmount: Decimal;
        _DocumentAmount: Decimal;
        _CustCheckCreditLimit: Page "Check Credit Limit";
        _EntryText: Text[250];
        Customer: Record Customer;
        CrReviewToleranceAmt: Decimal;
    begin
        // initial check to see if it is pending credit review

        NS_CreditReviewCheck(DATABASE::"Sales Header"
                         , _SalesLine."Document No."
                         , 0         // Document Area::Sales
                         , _SalesLine."Document Type".AsInteger());

        // called from Codeunit 312

        CLEAR(_CustCheckCreditLimit);

        // tolerance check - if approved already, and amount is within tolerance, exit the function

        _SalesSetup.GET;
        _DocumentAmount := NS_SalesLineGetTotalForDocument(_SalesLine);
        _ApprovedAmount := NS_GetPriorApprovedAmount(DATABASE::"Sales Header"
                                                 , _SalesLine."Document No."
                                                 , 0             // CreditReviewEntry.Document Area::Sales
                                                 , _SalesLine."Document Type".AsInteger());
        if not Customer.GET(_SalesLine."Bill-to Customer No.") then
            Customer.INIT;
        if Customer.NS_CreditReviewToleranceAmount <> 0 then
            CrReviewToleranceAmt := Customer.NS_CreditReviewToleranceAmount
        else
            CrReviewToleranceAmt := _SalesSetup.NS_CreditReviewToleranceAmount;

        if _DocumentAmount <= _ApprovedAmount + CrReviewToleranceAmt then
            exit;

        // credit check

        //PPNA16.0 Blocked Start
        // if not _CustCheckCreditLimit.SalesLineShowWarning(_SalesLine) then
        //     exit;
        //PPNA16.0 Blocked End

        // generate new Review entry

        _EntryText := _CustCheckCreditLimit.GetHeading;
        NS_NewCreditReviewEntry(DATABASE::"Sales Header"
                            , _SalesLine."Document No."
                            , 0             // CreditReviewEntry.Document Area::Sales
                            , _SalesLine."Document Type".AsInteger()
                            , _DocumentAmount
                            , CreditReviewEntry.NS_Status::Review
                            , _EntryText);
    end;

    procedure NS_SalesLineGetTotalForDocument(_SalesLine: Record "Sales Line"): Decimal;
    var
        _SalesHeader: Record "Sales Header";
    begin
        if not _SalesHeader.GET(_SalesLine."Document Type", _SalesLine."Document No.") then
            exit;

        exit(NS_SalesHeaderGetTotalForDocument(_SalesHeader) + _SalesLine."Line Amount");
    end;

    procedure NS_ShowCreditLimitEntries(_TableID: Integer; _No: Code[20]);
    var
        _CreditLimitEntry: Record "NS_Job Credit Limit Entry";
        _CreditLimitEntries: Page "NS_Job Quote Credit Limit Ent.";
    begin
        _CreditLimitEntry.SETCURRENTKEY("NS_Table ID", "NS_No.", "NS_Effective Date", "NS_Expiration Date");
        _CreditLimitEntry.FILTERGROUP := 255;
        _CreditLimitEntry.SETRANGE("NS_Table ID", _TableID);
        _CreditLimitEntry.SETRANGE("NS_No.", _No);
        _CreditLimitEntry.FILTERGROUP := 0;

        if _CreditLimitEntry.ISEMPTY then
            with _CreditLimitEntry do begin
                INIT;
                "NS_Table ID" := _TableID;
                "NS_No." := _No;
                "NS_Effective Date" := WORKDATE;
                "NS_Credit Limit" := 0.01;
                INSERT(true);
            end;

        CLEAR(_CreditLimitEntries);
        _CreditLimitEntries.NS_InitValues(_TableID, _No);
        _CreditLimitEntries.SETTABLEVIEW(_CreditLimitEntry);
        _CreditLimitEntries.RUN;
    end;
}

