// PRJ-471.MS.1.0 new changes for posting SI and PI with type Ledger
codeunit 14021107 NS_EventSubscriberCod12
{



    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", 'OnAfterCheckAccountNo', '', False, False)]
    // local procedure C12OnAfterCheckAccountNo(var GenJournalLine: Record "Gen. Journal Line")
    // Var
    //     GenJnlLineLocal: Record "Gen. Journal Line";
    // begin
    //     GenJournalLine."Job No." := ParameterCU.C11GetJobNoBeforeCheckAccountNo();

    // end;

    //Added this codeunit for EventSubscription of Codeunit 11
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", 'OnBeforeCheckAccountNo', '', False, False)]
    local procedure NS_C12OnBeforeCheckAccountNo(var GenJnlLine: Record "Gen. Journal Line"; var CheckDone: Boolean)
    Var
        GenJnlLineLocal: Record "Gen. Journal Line";
        Text010: Label '%1 %2 and %3 %4 is not allowed';
        Text003: Label 'must have the same sign as %1';
    begin
        // ParameterCU.C11SetJobNoBeforeCheckAccountNo(GenJnlLine."Job No.");
        // GenJnlLine."Job No." := '';
        WITH GenJnlLine DO
            CASE "Account Type" OF
                "Account Type"::Customer, "Account Type"::Vendor, "Account Type"::Employee:
                    BEGIN
                        TESTFIELD("Gen. Posting Type", 0);
                        TESTFIELD("Gen. Bus. Posting Group", '');
                        TESTFIELD("Gen. Prod. Posting Group", '');
                        TESTFIELD("VAT Bus. Posting Group", '');
                        TESTFIELD("VAT Prod. Posting Group", '');

                        IF (("Account Type" = "Account Type"::Customer) AND
                            ("Bal. Gen. Posting Type" = "Bal. Gen. Posting Type"::Purchase)) OR
                           (("Account Type" = "Account Type"::Vendor) AND
                            ("Bal. Gen. Posting Type" = "Bal. Gen. Posting Type"::Sale))
                        THEN
                            ERROR(
                              Text010,
                              FIELDCAPTION("Account Type"), "Account Type",
                              FIELDCAPTION("Bal. Gen. Posting Type"), "Bal. Gen. Posting Type");

                        NS_CheckDocType(GenJnlLine);

                        IF NOT "System-Created Entry" AND
                           (((Amount < 0) XOR ("Sales/Purch. (LCY)" < 0)) AND (Amount <> 0) AND ("Sales/Purch. (LCY)" <> 0))
                            //ProjectPro - start
                            AND (NOT "NS_Retention Document")
                        //ProjectPro - end
                        THEN
                            FIELDERROR("Sales/Purch. (LCY)", STRSUBSTNO(Text003, FIELDCAPTION(Amount)));
                        //ProjectPro - start
                        //TESTFIELD("Job No.",'');
                        //ProjectPro - end

                        NS_CheckICPartner("Account Type", "Account No.", "Document Type", GenJnlLine);

                        CheckDone := true;
                    END;
            END;

    end;


    local procedure NS_CheckDocType(GenJnlLine: Record "Gen. Journal Line")
    var
        IsPayment: Boolean;
        EmployeeAccountDocTypeErr: Label 'must be empty or set to Payment when Account Type field is set to Employee';
    begin
        WITH GenJnlLine DO
            IF "Document Type".AsInteger() <> 0 THEN BEGIN
                IF ("Account Type" = "Account Type"::Employee) AND NOT
                   ("Document Type" IN ["Document Type"::Payment, "Document Type"::" "])
                THEN
                    FIELDERROR("Document Type", EmployeeAccountDocTypeErr);

                IsPayment := "Document Type" IN ["Document Type"::Payment, "Document Type"::"Credit Memo"];
                IF IsPayment XOR (("Account Type" = "Account Type"::Customer) XOR NS_IsVendorPaymentToCrMemo(GenJnlLine)) THEN
                    NS_ErrorIfNegativeAmt(GenJnlLine)
                ELSE
                    NS_ErrorIfPositiveAmt(GenJnlLine);
            END;
    end;


    local procedure NS_IsVendorPaymentToCrMemo(GenJnlLine: Record "Gen. Journal Line"): Boolean
    var
        GenJournalTemplate: Record "Gen. Journal Template";
    begin
        WITH GenJnlLine DO BEGIN
            IF ("Account Type" = "Account Type"::Vendor) AND
               ("Document Type" = "Document Type"::Payment) AND
               ("Applies-to Doc. Type" = "Applies-to Doc. Type"::"Credit Memo") AND
               ("Applies-to Doc. No." <> '')
            THEN BEGIN
                GenJournalTemplate.GET("Journal Template Name");
                EXIT(GenJournalTemplate.Type = GenJournalTemplate.Type::Payments);
            END;
            EXIT(FALSE);
        END;
    end;


    local procedure NS_ErrorIfNegativeAmt(GenJnlLine: Record "Gen. Journal Line")
    var
        RaiseError: Boolean;
        IsHandled: Boolean; //FGH-163.SM.240424  //PRJCTPR-358.JS.1.0 24APR2024
    begin
        RaiseError := GenJnlLine.Amount < 0;
        // PRJ-471.MS.1.0 start
        if (GenJnlLine."Document Type" = GenJnlLine."Document Type"::Invoice) and not GenJnlLine."NS_Retention Document" then
            RaiseError := RaiseError
        else
            RaiseError := false;

        //FGH-163.SM.240424 START    //PRJCTPR-358.JS.1.0 24APR2024
        OnBeforeErrorIfNegativeAmt(GenJnlLine, IsHandled);
        If IsHandled then
            exit;
        //FGH-163.SM.240424 END  //PRJCTPR-358.JS.1.0 24APR2024  
        // PRJ-471.MS.1.0 end
        IF RaiseError THEN
          GenJnlLine.FIELDERROR(Amount, 'must be positive');
    end;

    local procedure NS_ErrorIfPositiveAmt(GenJnlLine: Record "Gen. Journal Line")
    var
        RaiseError: Boolean;
    begin
        RaiseError := GenJnlLine.Amount > 0;
        //PRJCTPR-210.AS.1.0 START COMMENT
        // // PRJ-471.MS.1.0 start
        // if (GenJnlLine."Document Type" = GenJnlLine."Document Type"::"Credit Memo") and not GenJnlLine."NS_Retention Document" then
        //     RaiseError := RaiseError
        // else
        //     RaiseError := false;
        // // PRJ-471.MS.1.0 end       
        //PRJCTPR-210.AS.1.0 END COMMENT

        //PRJCTPR-210.AS.1.0 START ADD
        // PRJ-471.MS.1.0 start
        if ((GenJnlLine."Journal Template Name" = '') and (GenJnlLine."Journal Batch Name" = '')) then begin
            if (GenJnlLine."Document Type" = GenJnlLine."Document Type"::"Credit Memo") and not GenJnlLine."NS_Retention Document" then
                RaiseError := RaiseError
            else
                RaiseError := false;
        end;
        // PRJ-471.MS.1.0 end       
        //PRJCTPR-210.AS.1.0 END ADD
        IF RaiseError THEN
            GenJnlLine.FIELDERROR(Amount, 'must be negetive');
    end;

    local procedure NS_CheckICPartner(AccountType: Enum "Gen. Journal Account Type"; AccountNo: Code[20]; DocumentType: Enum "Gen. Journal Document Type"; GenJnlLine: Record "Gen. Journal Line")
    var
        Vendor: Record Vendor;
        GenJnlTemplate: Record "Gen. Journal Template";
        ICPartner: Record "IC Partner";
    begin
        IF GenJnlTemplate.GET(GenJnlLine."Journal Template Name") then;
        case AccountType of
            AccountType::Vendor:
                if Vendor.Get(AccountNo) then begin
                    Vendor.CheckBlockedVendOnJnls(Vendor, DocumentType, true);
                    if (Vendor."IC Partner Code" <> '') and (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany) and
                       ICPartner.Get(Vendor."IC Partner Code")
                    then
                        ICPartner.CheckICPartnerIndirect(Format(AccountType), AccountNo);
                end;

        end;
    end;

    var
        ParameterCU: Codeunit "NS_Parameters for Events";

    //FGH-163.SM.240424 START   //PRJCTPR-358.JS.1.0 24APR2024
    [IntegrationEvent(false, false)]
    local procedure OnBeforeErrorIfNegativeAmt(Var GenJnlLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    begin
    end;
    //FGH-163.SM.240424 START  //PRJCTPR-358.JS.1.0 24APR2024
}