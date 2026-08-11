report 14021202 "NS_Suggest Vendor Payments"
{


    //PRJ-10.SK.1.0 - Added Code in function GetVendLedgEntries for filtering "Vendor Ledger Entries"
    // version NAVW111.00.00.25466,NAVNA11.00.00.25466,PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Added field(s):
    // +
    // +
    // +  - Added function(s):
    // +
    // +
    // +  - Added global variable(s):
    // +     PP_PurchSetup
    // +     PP_VendorInsuranceMessage
    // +     PP_IncludeRetention
    // +     PP_SubcontractNo
    // +     PP_DrawNo
    // +     PP_JobNo
    // +     Text14021100
    // +
    // +  - Modification(s):
    // +     - OnPreReport: get Purchases & Payables Setup record
    // +     - OnPostDataItem: raise message if Vendor Insurance has expired
    // +     - Added to the Options tab: Job No., Include Retention, Subcontract No., and Draw No.
    // +     - GetVendLedgEntries: add Vendor Ledger Entry filters: Job No., Subcontract No., Draw No., and Retention Ledger Code
    // +     - SaveAmount: copy Job No., Subcontract No., Draw No. from Vendor Ledger Entry to General Journal Line
    // +     - MakeGenJnlLines: copy Job No., Subcontract No., Draw No. from Vendor Ledger Entry to Temp Payment Buffer and to General Journal Line
    //PRJ-254.MS.1.0 new code added for vendor payment suggustion
    // +------------------------------------------------------------
    //PRJ-785.RS.1.0 12July2021 | Draw No Field Character Length
    //SPS-18.RM.1.0 27July2023 | Added some code
    //PRJCTPR-248.HS.1.0 27Dec2023 | Added code

    Caption = 'Job Suggest Vendor Payments';//PE-141.NK.1.0 Start 09Aug2023
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Jobs;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = SORTING("No.")
                                WHERE(Blocked = FILTER(= ' '));
            RequestFilterFields = "No.", "Payment Method Code";

            trigger OnAfterGetRecord()
            begin
                CLEAR(VendorBalance);
                CALCFIELDS("Balance (LCY)");
                VendorBalance := "Balance (LCY)";

                IF StopPayments THEN
                    CurrReport.BREAK;
                Window.UPDATE(1, "No.");
                IF VendorBalance > 0 THEN BEGIN
                    GetVendLedgEntries(TRUE, FALSE);
                    GetVendLedgEntries(FALSE, FALSE);
                    CheckAmounts(FALSE);
                    ClearNegative;
                END;
            end;

            trigger OnPostDataItem()
            begin
                IF UsePriority AND NOT StopPayments THEN BEGIN
                    RESET;
                    COPYFILTERS(Vend2);
                    SETCURRENTKEY(Priority);
                    SETRANGE(Priority, 0);
                    IF FIND('-') THEN
                        REPEAT
                            CLEAR(VendorBalance);
                            CALCFIELDS("Balance (LCY)");
                            VendorBalance := "Balance (LCY)";
                            IF VendorBalance > 0 THEN BEGIN
                                Window.UPDATE(1, "No.");
                                GetVendLedgEntries(TRUE, FALSE);
                                GetVendLedgEntries(FALSE, FALSE);
                                CheckAmounts(FALSE);
                                ClearNegative;
                            END;
                        UNTIL (NEXT = 0) OR StopPayments;
                END;

                IF UsePaymentDisc AND NOT StopPayments THEN BEGIN
                    RESET;
                    COPYFILTERS(Vend2);
                    Window2.OPEN(Text007);
                    IF FIND('-') THEN
                        REPEAT
                            CLEAR(VendorBalance);
                            CALCFIELDS("Balance (LCY)");
                            VendorBalance := "Balance (LCY)";
                            Window2.UPDATE(1, "No.");
                            PayableVendLedgEntry.SETRANGE("Vendor No.", "No.");
                            IF VendorBalance > 0 THEN BEGIN
                                GetVendLedgEntries(TRUE, TRUE);
                                GetVendLedgEntries(FALSE, TRUE);
                                CheckAmounts(TRUE);
                                ClearNegative;
                            END;
                        UNTIL (NEXT = 0) OR StopPayments;
                    Window2.CLOSE;
                END ELSE
                    IF FIND('-') THEN
                        REPEAT
                            ClearNegative;
                        UNTIL NEXT = 0;

                DimSetEntry.LOCKTABLE;
                GenJnlLine.LOCKTABLE;
                GenJnlTemplate.GET(GenJnlLine."Journal Template Name");
                GenJnlBatch.GET(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
                GenJnlLine.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
                GenJnlLine.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
                IF GenJnlLine.FINDLAST THEN BEGIN
                    LastLineNo := GenJnlLine."Line No.";
                    GenJnlLine.INIT;
                END;

                Window2.OPEN(Text008);

                //ProjectPro - start

                if JobsSetup.Get() then; //SPS-18.RM.1.0 27July2023
                PayableVendLedgEntry.RESET;
                IF PayableVendLedgEntry.FINDSET THEN BEGIN
                    NS_VendorInsuranceMessage := '';
                    REPEAT
                        IF (Vendor.InsuranceExpired(PayableVendLedgEntry."Vendor No.", TODAY)) THEN
                            IF NS_VendorInsuranceMessage <> PayableVendLedgEntry."Vendor No." THEN BEGIN
                                if not JobsSetup."NS_Notify Insurance Exp" then //SPS-18.RM.1.0 27July2023  
                                    MESSAGE(Text14021100, PayableVendLedgEntry."Vendor No.");
                                NS_VendorInsuranceMessage := PayableVendLedgEntry."Vendor No.";
                            END;
                    UNTIL PayableVendLedgEntry.NEXT = 0;
                END;
                //ProjectPro - end

                PayableVendLedgEntry.RESET;
                PayableVendLedgEntry.SETRANGE(Priority, 1, 2147483647);
                MakeGenJnlLines;
                PayableVendLedgEntry.RESET;
                PayableVendLedgEntry.SETRANGE(Priority, 0);
                MakeGenJnlLines;
                PayableVendLedgEntry.RESET;
                PayableVendLedgEntry.DELETEALL;

                Window2.CLOSE;
                Window.CLOSE;
                ShowMessage(MessageText);
            end;

            trigger OnPreDataItem()
            begin
                IF LastDueDateToPayReq = 0D THEN
                    ERROR(Text000);
                IF (PostingDate = 0D) AND (NOT UseDueDateAsPostingDate) THEN
                    ERROR(Text001);

                BankPmtType := GenJnlLine2."Bank Payment Type";
                BalAccType := GenJnlLine2."Bal. Account Type";
                BalAccNo := GenJnlLine2."Bal. Account No.";
                GenJnlLineInserted := FALSE;
                SeveralCurrencies := FALSE;
                MessageText := '';


                IF ((BankPmtType = GenJnlLine2."Bank Payment Type"::" ") OR
                    SummarizePerVend) AND
                   (NextDocNo = '')
                THEN
                    ERROR(Text002);

                IF ((BankPmtType = GenJnlLine2."Bank Payment Type"::"Manual Check") AND
                    NOT SummarizePerVend AND
                    NOT DocNoPerLine)
                THEN
                    ERROR(Text017, GenJnlLine2.FIELDCAPTION("Bank Payment Type"), FORMAT(GenJnlLine2."Bank Payment Type"::"Manual Check"));


                IF UsePaymentDisc AND (LastDueDateToPayReq < WORKDATE) THEN
                    IF NOT CONFIRM(Text003, FALSE, WORKDATE) THEN
                        ERROR(Text005);
                //PRJ-254.MS.1.0 start
                if SummarizePerVend then begin
                    if NS_JobNo <> '' then
                        Error('You can not take Job no. filter with Summarize per Vendor');
                end;
                //PRJ-254.MS.1.0 end

                Vend2.COPYFILTERS(Vendor);

                OriginalAmtAvailable := AmountAvailable;
                IF UsePriority THEN BEGIN
                    SETCURRENTKEY(Priority);
                    SETRANGE(Priority, 1, 2147483647);
                    UsePriority := TRUE;
                END;
                Window.OPEN(Text006);

                SelectedDim.SETRANGE("User ID", USERID);
                SelectedDim.SETRANGE("Object Type", 3);
                SelectedDim.SETRANGE("Object ID", REPORT::"Suggest Vendor Payments");
                SummarizePerDim := SelectedDim.FIND('-') AND SummarizePerVend;

                NextEntryNo := 1;
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
                group(NS_Options)
                {
                    Caption = 'Options';
                    group("NS_Find Payments")
                    {
                        Caption = 'Find Payments';
                        field(LastPaymentDate; LastDueDateToPayReq)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Last Payment Date';
                            ToolTip = 'Specifies the latest payment date that can appear on the vendor ledger entries to be included in the batch job. Only entries that have a due date or a payment discount date before or on this date will be included. If the payment date is earlier than the system date, a warning will be displayed.';
                        }
                        field(NS_FindPaymentDiscounts; UsePaymentDisc)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Find Payment Discounts';
                            Importance = Additional;
                            MultiLine = true;
                            ToolTip = 'Specifies if you want the batch job to include vendor ledger entries for which you can receive a payment discount.';

                            trigger OnValidate()
                            begin
                                IF UsePaymentDisc AND UseDueDateAsPostingDate THEN
                                    ERROR(PmtDiscUnavailableErr);
                            end;
                        }
                        field(NS_UseVendorPriority; UsePriority)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Use Vendor Priority';
                            Importance = Additional;
                            ToolTip = 'Specifies if the Priority field on the vendor cards will determine in which order vendor entries are suggested for payment by the batch job. The batch job always prioritizes vendors for payment suggestions if you specify an available amount in the Available Amount ($) field.';

                            trigger OnValidate()
                            begin
                                IF NOT UsePriority AND (AmountAvailable <> 0) THEN
                                    ERROR(Text011);
                            end;
                        }
                        field("NS_Available Amount (LCY)"; AmountAvailable)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Available Amount ($)';
                            Importance = Additional;
                            ToolTip = 'Specifies a maximum amount (in $) that is available for payments. The batch job will then create a payment suggestion on the basis of this amount and the Use Vendor Priority check box. It will only include vendor entries that can be paid fully.';

                            trigger OnValidate()
                            begin
                                IF AmountAvailable <> 0 THEN
                                    UsePriority := TRUE;
                            end;
                        }
                        field(NS_SkipExportedPayments; SkipExportedPayments)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Skip Exported Payments';
                            Importance = Additional;
                            ToolTip = 'Specifies if you do not want the batch job to insert payment journal lines for documents for which payments have already been exported to a bank file.';
                        }
                        field(NS_CheckOtherJournalBatches; CheckOtherJournalBatches)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Check Other Journal Batches';
                            ToolTip = 'Specifies whether to exclude payments that are already included in another journal batch from new suggested payments. This helps avoid duplicate payments.';
                        }
                    }
                    group("Summarize Results")
                    {
                        Caption = 'Summarize Results';
                        field(NS_SummarizePerVendor; SummarizePerVend)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Summarize per Vendor';
                            ToolTip = 'Specifies if you want the batch job to make one line per vendor for each currency in which the vendor has ledger entries. If, for example, a vendor uses two currencies, the batch job will create two lines in the payment journal for this vendor. The batch job then uses the Applies-to ID field when the journal lines are posted to apply the lines to vendor ledger entries. If you do not select this check box, then the batch job will make one line per invoice.';

                            trigger OnValidate()
                            begin
                                IF SummarizePerVend AND UseDueDateAsPostingDate THEN
                                    ERROR(PmtDiscUnavailableErr);
                            end;
                        }
                        field(NS_SummarizePerDimText; SummarizePerDimText)
                        {
                            ApplicationArea = Suite;
                            Caption = 'By Dimension';
                            Editable = false;
                            Enabled = SummarizePerDimTextEnable;
                            Importance = Additional;
                            ToolTip = 'Specifies the dimensions that you want the batch job to consider.';

                            trigger OnAssistEdit()
                            var
                                DimSelectionBuf: Record "Dimension Selection Buffer";
                            begin
                                DimSelectionBuf.SetDimSelectionMultiple(3, REPORT::"Suggest Vendor Payments", SummarizePerDimText);
                            end;
                        }
                    }
                    group("NS_Fill in Journal Lines")
                    {
                        Caption = 'Fill in Journal Lines';
                        field(NS_PostingDate; PostingDate)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Posting Date';
                            Editable = UseDueDateAsPostingDate = FALSE;
                            Importance = Promoted;
                            ToolTip = 'Specifies the date for the posting of this batch job. By default, the working date is entered, but you can change it.';

                            trigger OnValidate()
                            begin
                                ValidatePostingDate;
                            end;
                        }
                        field(NS_UseDueDateAsPostingDate; UseDueDateAsPostingDate)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Calculate Posting Date from Applies-to-Doc. Due Date';
                            Importance = Additional;
                            ToolTip = 'Specifies if the due date on the purchase invoice will be used as a basis to calculate the payment posting date.';

                            trigger OnValidate()
                            begin
                                IF UseDueDateAsPostingDate AND (SummarizePerVend OR UsePaymentDisc) THEN
                                    ERROR(PmtDiscUnavailableErr);
                                IF NOT UseDueDateAsPostingDate THEN
                                    CLEAR(DueDateOffset);
                            end;
                        }
                        field(NS_DueDateOffset; DueDateOffset)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Applies-to-Doc. Due Date Offset';
                            Editable = UseDueDateAsPostingDate;
                            Enabled = UseDueDateAsPostingDate;
                            Importance = Additional;
                            ToolTip = 'Specifies a period of time that will separate the payment posting date from the due date on the invoice. Example 1: To pay the invoice on the Friday in the week of the due date, enter CW-2D (current week minus two days). Example 2: To pay the invoice two days before the due date, enter -2D (minus two days).';
                        }
                        field(NS_StartingDocumentNo; NextDocNo)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Starting Document No.';
                            ToolTip = 'Specifies the next available number in the number series for the journal batch that is linked to the payment journal. When you run the batch job, this is the document number that appears on the first payment journal line. You can also fill in this field manually.';

                            trigger OnValidate()
                            var
                                UnincrementableStringError: Label '%1 contains no number and cannot be incremented.';
                            begin
                                IF NextDocNo <> '' THEN
                                    IF INCSTR(NextDocNo) = '' THEN
                                        ERROR(UnincrementableStringError, StartingDocumentNoErr);
                            end;
                        }
                        field(NS_NewDocNoPerLine; DocNoPerLine)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'New Doc. No. per Line';
                            Importance = Additional;
                            ToolTip = 'Specifies if you want the batch job to fill in the payment journal lines with consecutive document numbers, starting with the document number specified in the Starting Document No. field.';

                            trigger OnValidate()
                            begin
                                IF NOT UsePriority AND (AmountAvailable <> 0) THEN
                                    ERROR(Text013);
                            end;
                        }
                        field(NS_BalAccountType; GenJnlLine2."Bal. Account Type")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Bal. Account Type';
                            Importance = Additional;
                            ToolTip = 'Specifies the balancing account type that payments on the payment journal are posted to.';

                            trigger OnValidate()
                            begin
                                GenJnlLine2."Bal. Account No." := '';
                            end;
                        }
                        field(NS_BalAccountNo; GenJnlLine2."Bal. Account No.")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Bal. Account No.';
                            Importance = Additional;
                            ToolTip = 'Specifies the balancing account number that payments on the payment journal are posted to.';

                            trigger OnLookup(var Text: Text): Boolean
                            begin
                                CASE GenJnlLine2."Bal. Account Type" OF
                                    GenJnlLine2."Bal. Account Type"::"G/L Account":
                                        IF PAGE.RUNMODAL(0, GLAcc) = ACTION::LookupOK THEN
                                            GenJnlLine2."Bal. Account No." := GLAcc."No.";
                                    GenJnlLine2."Bal. Account Type"::Customer, GenJnlLine2."Bal. Account Type"::Vendor:
                                        ERROR(Text009, GenJnlLine2.FIELDCAPTION("Bal. Account Type"));
                                    GenJnlLine2."Bal. Account Type"::"Bank Account":
                                        IF PAGE.RUNMODAL(0, BankAcc) = ACTION::LookupOK THEN
                                            GenJnlLine2."Bal. Account No." := BankAcc."No.";
                                END;
                            end;

                            trigger OnValidate()
                            begin
                                IF GenJnlLine2."Bal. Account No." <> '' THEN
                                    CASE GenJnlLine2."Bal. Account Type" OF
                                        GenJnlLine2."Bal. Account Type"::"G/L Account":
                                            GLAcc.GET(GenJnlLine2."Bal. Account No.");
                                        GenJnlLine2."Bal. Account Type"::Customer, GenJnlLine2."Bal. Account Type"::Vendor:
                                            ERROR(Text009, GenJnlLine2.FIELDCAPTION("Bal. Account Type"));
                                        GenJnlLine2."Bal. Account Type"::"Bank Account":
                                            BankAcc.GET(GenJnlLine2."Bal. Account No.");
                                    END;
                            end;
                        }
                        field(NS_BankPaymentType; GenJnlLine2."Bank Payment Type")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Bank Payment Type';
                            Importance = Additional;
                            ToolTip = 'Specifies the check type to be used, if you use Bank Account as the balancing account type.';

                            trigger OnValidate()
                            begin
                                IF (GenJnlLine2."Bal. Account Type" <> GenJnlLine2."Bal. Account Type"::"Bank Account") AND
                                   (GenJnlLine2."Bank Payment Type".AsInteger() > 0)
                                THEN
                                    ERROR(
                                      Text010,
                                      GenJnlLine2.FIELDCAPTION("Bank Payment Type"),
                                      GenJnlLine2.FIELDCAPTION("Bal. Account Type"));
                            end;
                        }
                    }
                    group("NS_ProjectPro")
                    {
                        Caption = 'ProjectPro';
                        field("NS_Job No."; NS_JobNo)
                        {
                            Caption = 'Job No.';

                            ToolTip = 'Job No.';
                            TableRelation = Job."No.";
                            ApplicationArea = all;
                        }
                        field("NS_Include Retention"; NS_IncludeRetention)
                        {
                            //Caption = 'Include Retention'; //PRJ-10.SK.1.0 Commented
                            Caption = 'Retention Only'; //PRJ-10.SK.1.0 Added
                            ToolTip = 'Retention Only';
                            ApplicationArea = all;
                        }
                        field("NS_Subcontract No."; NS_SubcontractNo)
                        {
                            Caption = 'Subcontract No.';

                            ToolTip = 'Subcontract No.';
                            TableRelation = NS_Subcontract."NS_No.";
                            ApplicationArea = all;
                        }
                        field("NS_Draw No."; NS_DrawNo)
                        {
                            Caption = 'Draw No.';

                            ToolTip = 'Draw No.';
                            LookupPageID = NS_Draws;
                            TableRelation = NS_Draw."NS_No.";
                            ApplicationArea = all;
                        }
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            SummarizePerDimTextEnable := TRUE;
            SkipExportedPayments := TRUE;
        end;

        trigger OnOpenPage()
        begin
            IF LastDueDateToPayReq = 0D THEN
                LastDueDateToPayReq := WORKDATE;
            IF PostingDate = 0D THEN
                PostingDate := WORKDATE;
            ValidatePostingDate;
            SetDefaults;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    var
        PermissionManager: Codeunit "Environment Information";
    begin
        IF PermissionManager.IsSaaS() THEN
            CheckOtherJournalBatches := TRUE;
    end;

    trigger OnPostReport()
    begin
        COMMIT;
        IF NOT VendorLedgEntryTemp.ISEMPTY THEN
            IF CONFIRM(Text024) THEN
                PAGE.RUNMODAL(0, VendorLedgEntryTemp);

        IF NOT TempErrorMessage.ISEMPTY THEN
            IF CONFIRM(ReviewNotSuggestedLinesQst) THEN
                TempErrorMessage.ShowErrorMessages(FALSE);
    end;

    trigger OnPreReport()
    begin
        CompanyInformation.GET;
        VendorLedgEntryTemp.DELETEALL;
        ShowPostingDateWarning := FALSE;
        //ProjectPro - start
        NS_PurchSetup.GET;
        //ProjectPro - end
    end;

    var
        Text000: Label 'In the Last Payment Date field, specify the last possible date that payments must be made.';
        Text001: Label 'In the Posting Date field, specify the date that will be used as the posting date for the journal entries.';
        Text002: Label 'In the Starting Document No. field, specify the first document number to be used.';
        Text003: Label 'The payment date is earlier than %1.\\Do you still want to run the batch job?', Comment = '%1 is a date';
        Text005: Label 'The batch job was interrupted.';
        Text006: Label 'Processing vendors                       #1##########';
        Text007: Label 'Processing vendors for payment discounts #1##########';
        Text008: Label 'Inserting payment journal lines          #1##########';
        Text009: Label '%1 must be G/L Account or Bank Account.';
        Text010: Label '%1 must be filled only when %2 is Bank Account.';
        Text011: Label 'Use Vendor Priority must be activated when the value in the Amount Available field is not 0.';
        Text013: Label 'Use Vendor Priority must be activated when the value in the Amount Available Amount ($) field is not 0.';
        Text017: Label 'If %1 = %2 and you have not selected the Summarize per Vendor field,\ then you must select the New Doc. No. per Line.', Comment = 'If Bank Payment Type = Computer Check and you have not selected the Summarize per Vendor field,\ then you must select the New Doc. No. per Line.';
        Text020: Label 'You have only created suggested vendor payment lines for the %1 %2.\ However, there are other open vendor ledger entries in currencies other than %2.\\', Comment = 'You have only created suggested vendor payment lines for the Currency Code EUR.\ However, there are other open vendor ledger entries in currencies other than EUR.';
        Text021: Label 'You have only created suggested vendor payment lines for the %1 %2.\ There are no other open vendor ledger entries in other currencies.\\', Comment = 'You have only created suggested vendor payment lines for the Currency Code EUR\ There are no other open vendor ledger entries in other currencies.\\';
        Text022: Label 'You have created suggested vendor payment lines for all currencies.\\';
        Vend2: Record Vendor;
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        DimSetEntry: Record "Dimension Set Entry";
        GenJnlLine2: Record "Gen. Journal Line";
        VendLedgEntry: Record "Vendor Ledger Entry";
        GLAcc: Record "G/L Account";
        BankAcc: Record "Bank Account";
        PayableVendLedgEntry: Record "Payable Vendor Ledger Entry" temporary;
        CompanyInformation: Record "Company Information";
        TempPaymentBuffer: Record "Payment Buffer" temporary;
        OldTempPaymentBuffer: Record "Payment Buffer" temporary;
        SelectedDim: Record "Selected Dimension";
        VendorLedgEntryTemp: Record "Vendor Ledger Entry" temporary;
        TempErrorMessage: Record "Error Message" temporary;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit 408;
        DimBufMgt: Codeunit "Dimension Buffer Management";
        Window: Dialog;
        Window2: Dialog;
        UsePaymentDisc: Boolean;
        PostingDate: Date;
        LastDueDateToPayReq: Date;
        NextDocNo: Code[20];
        AmountAvailable: Decimal;
        OriginalAmtAvailable: Decimal;
        UsePriority: Boolean;
        SummarizePerVend: Boolean;
        SummarizePerDim: Boolean;
        SummarizePerDimText: Text[250];
        LastLineNo: Integer;
        NextEntryNo: Integer;
        DueDateOffset: DateFormula;
        UseDueDateAsPostingDate: Boolean;
        StopPayments: Boolean;
        DocNoPerLine: Boolean;
        BankPmtType: Enum "Bank Payment Type";
        BalAccType: Enum "Gen. Journal Account Type";
        BalAccNo: Code[20];
        MessageText: Text;
        GenJnlLineInserted: Boolean;
        SeveralCurrencies: Boolean;
        Text024: Label 'There are one or more entries for which no payment suggestions have been made because the posting dates of the entries are later than the requested posting date. Do you want to see the entries?';
        [InDataSet]
        SummarizePerDimTextEnable: Boolean;
        Text025: Label 'The %1 with the number %2 has a %3 with the number %4.';
        ShowPostingDateWarning: Boolean;
        VendorBalance: Decimal;
        ReplacePostingDateMsg: Label 'For one or more entries, the requested posting date is before the work date.\\These posting dates will use the work date.';
        PmtDiscUnavailableErr: Label 'You cannot use Find Payment Discounts or Summarize per Vendor together with Calculate Posting Date from Applies-to-Doc. Due Date, because the resulting posting date might not match the payment discount date.';
        SkipExportedPayments: Boolean;
        MessageToRecipientMsg: Label 'Payment of %1 %2 ', Comment = '%1 document type, %2 Document No.';
        StartingDocumentNoErr: Label 'Starting Document No.';
        CheckOtherJournalBatches: Boolean;
        ReviewNotSuggestedLinesQst: Label 'There are payments in other journal batches that are not suggested here. This helps avoid duplicate payments. To add them to this batch, remove the payment from the other batch, and then suggest payments again.\\Do you want to review the payments from the other journal batches now?';
        NotSuggestedPaymentInfoTxt: Label 'There are payments in %1 %2, %3 %4, %5 %6', Comment = 'There are payments in Journal Template Name PAYMENT, Journal Batch Name GENERAL, Applies-to Doc. No. 101321';
        NS_PurchSetup: Record "Purchases & Payables Setup";
        NS_VendorInsuranceMessage: Code[20];
        NS_JobNo: Code[20];
        NS_IncludeRetention: Boolean;
        NS_SubcontractNo: Code[20];
        NS_DrawNo: Code[25];//PRJ-785.RS.1.0 12July2021 Size Increased
        Text14021100: Label 'Warning! Insurance has expired for Vendor %1';
        JobsSetup: Record "Jobs Setup";//SPS-18.RM.1.0 27July2023

    procedure SetGenJnlLine(NewGenJnlLine: Record "Gen. Journal Line")
    begin
        GenJnlLine := NewGenJnlLine;
    end;

    local procedure ValidatePostingDate()
    begin
        GenJnlBatch.GET(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
        IF GenJnlBatch."No. Series" = '' THEN
            NextDocNo := ''
        ELSE BEGIN
            NextDocNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", PostingDate, FALSE);
            CLEAR(NoSeriesMgt);
        END;
    end;

    procedure InitializeRequest(LastPmtDate: Date; FindPmtDisc: Boolean; NewAvailableAmount: Decimal; NewSkipExportedPayments: Boolean; NewPostingDate: Date; NewStartDocNo: Code[20]; NewSummarizePerVend: Boolean; BalAccType: Enum "Gen. Journal Account Type"; BalAccNo: Code[20]; BankPmtType: Enum "Bank Payment Type")
    begin
        LastDueDateToPayReq := LastPmtDate;
        UsePaymentDisc := FindPmtDisc;
        AmountAvailable := NewAvailableAmount;
        SkipExportedPayments := NewSkipExportedPayments;
        PostingDate := NewPostingDate;
        NextDocNo := NewStartDocNo;
        SummarizePerVend := NewSummarizePerVend;
        GenJnlLine2."Bal. Account Type" := BalAccType;
        GenJnlLine2."Bal. Account No." := BalAccNo;
        GenJnlLine2."Bank Payment Type" := BankPmtType;
    end;

    local procedure GetVendLedgEntries(Positive: Boolean; Future: Boolean)
    begin
        VendLedgEntry.RESET;
        VendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive, "Due Date");
        VendLedgEntry.SETRANGE("Vendor No.", Vendor."No.");
        VendLedgEntry.SETRANGE(Open, TRUE);
        VendLedgEntry.SETRANGE(Positive, Positive);
        VendLedgEntry.SETRANGE("Applies-to ID", '');
        VendLedgEntry.SETFILTER("Document Type", '<>%1', VendLedgEntry."Document Type"::Payment);
        IF Future THEN BEGIN
            VendLedgEntry.SETRANGE("Due Date", LastDueDateToPayReq + 1, DMY2DATE(31, 12, 9999));
            VendLedgEntry.SETRANGE("Pmt. Discount Date", PostingDate, LastDueDateToPayReq);
            VendLedgEntry.SETFILTER("Remaining Pmt. Disc. Possible", '<>0');
        END ELSE
            VendLedgEntry.SETRANGE("Due Date", 0D, LastDueDateToPayReq);
        IF SkipExportedPayments THEN
            VendLedgEntry.SETRANGE("Exported to Payment File", FALSE);
        VendLedgEntry.SETRANGE("On Hold", '');
        VendLedgEntry.SETFILTER("Currency Code", Vendor.GETFILTER("Currency Filter"));
        VendLedgEntry.SETFILTER("Global Dimension 1 Code", Vendor.GETFILTER("Global Dimension 1 Filter"));
        VendLedgEntry.SETFILTER("Global Dimension 2 Code", Vendor.GETFILTER("Global Dimension 2 Filter"));

        //ProjectPro - start
        IF NS_JobNo > '' THEN
            VendLedgEntry.SETRANGE("NS_Job No.", NS_JobNo);
        IF (NOT NS_PurchSetup."NS_Purchase Retention Inactive") AND (NOT NS_IncludeRetention) THEN
            VendLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_PurchSetup."NS_Normal Vendor Ledger No.")
        //PRJ-10.SK.1.0 Start
        ELSE
            IF (NOT NS_PurchSetup."NS_Purchase Retention Inactive") AND (NS_IncludeRetention) THEN
                VendLedgEntry.SETRANGE("NS_Retention Ledger Code", 'RETENTION');
        //PRJ-10.SK.1.0 End
        IF NS_SubcontractNo > '' THEN
            VendLedgEntry.SETRANGE("NS_Subcontract No.", NS_SubcontractNo);
        IF NS_DrawNo > '' THEN
            VendLedgEntry.SETRANGE("NS_Draw No.", NS_DrawNo);
        //ProjectPro - end

        IF VendLedgEntry.FIND('-') THEN
            REPEAT
                SaveAmount;
                IF VendLedgEntry."Accepted Pmt. Disc. Tolerance" OR
                   (VendLedgEntry."Accepted Payment Tolerance" <> 0)
                THEN BEGIN
                    VendLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
                    VendLedgEntry."Accepted Payment Tolerance" := 0;
                    CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit", VendLedgEntry);
                END;
            UNTIL VendLedgEntry.NEXT = 0;
    end;

    local procedure SaveAmount()
    var
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
    begin
        WITH GenJnlLine DO BEGIN
            INIT;
            SetPostingDate(GenJnlLine, VendLedgEntry."Due Date", PostingDate);
            "Document Type" := "Document Type"::Payment;
            "Account Type" := "Account Type"::Vendor;
            Vend2.GET(VendLedgEntry."Vendor No.");
            Vend2.CheckBlockedVendOnJnls(Vend2, "Document Type".AsInteger(), FALSE);
            Description := Vend2.Name;
            "Posting Group" := Vend2."Vendor Posting Group";
            "Salespers./Purch. Code" := Vend2."Purchaser Code";
            "Payment Terms Code" := Vend2."Payment Terms Code";
            VALIDATE("Bill-to/Pay-to No.", "Account No.");
            VALIDATE("Sell-to/Buy-from No.", "Account No.");
            "Gen. Posting Type" := 0;
            "Gen. Bus. Posting Group" := '';
            "Gen. Prod. Posting Group" := '';
            "VAT Bus. Posting Group" := '';
            "VAT Prod. Posting Group" := '';
            VALIDATE("Currency Code", VendLedgEntry."Currency Code");
            VALIDATE("Payment Terms Code");
            VendLedgEntry.CALCFIELDS("Remaining Amount");
            IF PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(GenJnlLine, VendLedgEntry, 0, FALSE) THEN
                Amount := -(VendLedgEntry."Remaining Amount" - VendLedgEntry."Remaining Pmt. Disc. Possible")
            ELSE
                Amount := -VendLedgEntry."Remaining Amount";
            VALIDATE(Amount);

            //ProjectPro - start
            "Job No." := VendLedgEntry."NS_Job No.";
            "NS_Subcontract No." := VendLedgEntry."NS_Subcontract No.";
            "NS_Draw No." := VendLedgEntry."NS_Draw No.";
            //ProjectPro - end

        END;

        IF UsePriority THEN
            PayableVendLedgEntry.Priority := Vendor.Priority
        ELSE
            PayableVendLedgEntry.Priority := 0;
        PayableVendLedgEntry."Vendor No." := VendLedgEntry."Vendor No.";
        PayableVendLedgEntry."Entry No." := NextEntryNo;
        PayableVendLedgEntry."Vendor Ledg. Entry No." := VendLedgEntry."Entry No.";
        PayableVendLedgEntry.Amount := GenJnlLine.Amount;
        PayableVendLedgEntry."Amount (LCY)" := GenJnlLine."Amount (LCY)";
        PayableVendLedgEntry.Positive := (PayableVendLedgEntry.Amount > 0);
        PayableVendLedgEntry.Future := (VendLedgEntry."Due Date" > LastDueDateToPayReq);
        PayableVendLedgEntry."Currency Code" := VendLedgEntry."Currency Code";
        PayableVendLedgEntry.INSERT;
        NextEntryNo := NextEntryNo + 1;
    end;

    local procedure CheckAmounts(Future: Boolean)
    var
        CurrencyBalance: Decimal;
        PrevCurrency: Code[10];
    begin
        PayableVendLedgEntry.SETRANGE("Vendor No.", Vendor."No.");
        PayableVendLedgEntry.SETRANGE(Future, Future);

        IF PayableVendLedgEntry.FIND('-') THEN BEGIN
            REPEAT
                IF PayableVendLedgEntry."Currency Code" <> PrevCurrency THEN BEGIN
                    IF CurrencyBalance > 0 THEN
                        AmountAvailable := AmountAvailable - CurrencyBalance;
                    CurrencyBalance := 0;
                    PrevCurrency := PayableVendLedgEntry."Currency Code";
                END;
                IF (OriginalAmtAvailable = 0) OR
                   (AmountAvailable >= CurrencyBalance + PayableVendLedgEntry."Amount (LCY)")
                THEN
                    CurrencyBalance := CurrencyBalance + PayableVendLedgEntry."Amount (LCY)"
                ELSE
                    PayableVendLedgEntry.DELETE;
            UNTIL PayableVendLedgEntry.NEXT = 0;
            IF OriginalAmtAvailable > 0 THEN
                AmountAvailable := AmountAvailable - CurrencyBalance;
            IF (OriginalAmtAvailable > 0) AND (AmountAvailable <= 0) THEN
                StopPayments := TRUE;
        END;
        PayableVendLedgEntry.RESET;
    end;

    local procedure MakeGenJnlLines()
    var
        GenJnlLine1: Record "Gen. Journal Line";
        DimBuf: Record "Dimension Buffer";
        Vendor: Record Vendor;
        RemainingAmtAvailable: Decimal;
    begin
        TempPaymentBuffer.RESET;
        TempPaymentBuffer.DELETEALL;

        IF BalAccType = BalAccType::"Bank Account" THEN BEGIN
            CheckCurrencies(BalAccType, BalAccNo, PayableVendLedgEntry);
            SetBankAccCurrencyFilter(BalAccType, BalAccNo, PayableVendLedgEntry);
        END;

        IF OriginalAmtAvailable <> 0 THEN BEGIN
            RemainingAmtAvailable := OriginalAmtAvailable;
            RemovePaymentsAboveLimit(PayableVendLedgEntry, RemainingAmtAvailable);
        END;
        IF PayableVendLedgEntry.FIND('-') THEN
            REPEAT
                PayableVendLedgEntry.SETRANGE("Vendor No.", PayableVendLedgEntry."Vendor No.");
                PayableVendLedgEntry.FIND('-');
                REPEAT
                    VendLedgEntry.GET(PayableVendLedgEntry."Vendor Ledg. Entry No.");
                    SetPostingDate(GenJnlLine1, VendLedgEntry."Due Date", PostingDate);
                    IF VendLedgEntry."Posting Date" <= GenJnlLine1."Posting Date" THEN BEGIN
                        TempPaymentBuffer."Vendor No." := VendLedgEntry."Vendor No.";
                        TempPaymentBuffer."Currency Code" := VendLedgEntry."Currency Code";
                        //ProjectPro - start
                        TempPaymentBuffer."NS_Job No." := VendLedgEntry."NS_Job No.";
                        TempPaymentBuffer."NS_Subcontract No." := VendLedgEntry."NS_Subcontract No.";
                        TempPaymentBuffer."NS_Draw No." := VendLedgEntry."NS_Draw No.";
                        //ProjectPro - end
                        TempPaymentBuffer."Payment Method Code" := VendLedgEntry."Payment Method Code";
                        TempPaymentBuffer."Creditor No." := VendLedgEntry."Creditor No.";
                        TempPaymentBuffer."Payment Reference" := VendLedgEntry."Payment Reference";
                        TempPaymentBuffer."Exported to Payment File" := VendLedgEntry."Exported to Payment File";
                        TempPaymentBuffer."Applies-to Ext. Doc. No." := VendLedgEntry."External Document No.";
                        OnUpdateTempBufferFromVendorLedgerEntry(TempPaymentBuffer, VendLedgEntry);
                        SetTempPaymentBufferDims(DimBuf);

                        VendLedgEntry.CALCFIELDS("Remaining Amount");

                        IF SummarizePerVend THEN BEGIN
                            TempPaymentBuffer."Vendor Ledg. Entry No." := 0;
                            IF TempPaymentBuffer.FIND THEN BEGIN
                                TempPaymentBuffer.Amount := TempPaymentBuffer.Amount + PayableVendLedgEntry.Amount;
                                TempPaymentBuffer.MODIFY;
                            END ELSE BEGIN
                                TempPaymentBuffer."Document No." := NextDocNo;
                                NextDocNo := INCSTR(NextDocNo);
                                TempPaymentBuffer.Amount := PayableVendLedgEntry.Amount;
                                Window2.UPDATE(1, VendLedgEntry."Vendor No.");
                                TempPaymentBuffer.INSERT;
                            END;
                            VendLedgEntry."Applies-to ID" := TempPaymentBuffer."Document No.";
                        END ELSE
                            IF NOT IsEntryAlreadyApplied(GenJnlLine, VendLedgEntry) THEN BEGIN
                                TempPaymentBuffer."Vendor Ledg. Entry Doc. Type" := VendLedgEntry."Document Type";
                                TempPaymentBuffer."Vendor Ledg. Entry Doc. No." := VendLedgEntry."Document No.";
                                TempPaymentBuffer."Global Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code";
                                TempPaymentBuffer."Global Dimension 2 Code" := VendLedgEntry."Global Dimension 2 Code";
                                TempPaymentBuffer."Dimension Set ID" := VendLedgEntry."Dimension Set ID";
                                TempPaymentBuffer."Vendor Ledg. Entry No." := VendLedgEntry."Entry No.";
                                TempPaymentBuffer.Amount := PayableVendLedgEntry.Amount;
                                Window2.UPDATE(1, VendLedgEntry."Vendor No.");
                                //ProjectPro - start
                                TempPaymentBuffer."NS_Retention Ledger Code" := VendLedgEntry."NS_Retention Ledger Code";
                                //ProjectPro - end
                                TempPaymentBuffer.INSERT;
                            END;

                        VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
                        CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit", VendLedgEntry);
                    END ELSE BEGIN
                        VendorLedgEntryTemp := VendLedgEntry;
                        VendorLedgEntryTemp.INSERT;
                    END;

                    PayableVendLedgEntry.DELETE;
                    IF OriginalAmtAvailable <> 0 THEN BEGIN
                        RemainingAmtAvailable := RemainingAmtAvailable - PayableVendLedgEntry."Amount (LCY)";
                        RemovePaymentsAboveLimit(PayableVendLedgEntry, RemainingAmtAvailable);
                    END;

                UNTIL NOT PayableVendLedgEntry.FINDSET;
                PayableVendLedgEntry.DELETEALL;
                PayableVendLedgEntry.SETRANGE("Vendor No.");
            UNTIL NOT PayableVendLedgEntry.FIND('-');

        CLEAR(OldTempPaymentBuffer);
        TempPaymentBuffer.SETCURRENTKEY("Document No.");
        TempPaymentBuffer.SETFILTER(
          "Vendor Ledg. Entry Doc. Type", '<>%1&<>%2', TempPaymentBuffer."Vendor Ledg. Entry Doc. Type"::Refund,
          TempPaymentBuffer."Vendor Ledg. Entry Doc. Type"::Payment);

        CollectExistingPaymentLines;

        IF TempPaymentBuffer.FIND('-') THEN
            REPEAT
                WITH GenJnlLine DO BEGIN
                    INIT;
                    Window2.UPDATE(1, TempPaymentBuffer."Vendor No.");
                    LastLineNo := LastLineNo + 10000;
                    "Line No." := LastLineNo;
                    "Document Type" := "Document Type"::Payment;
                    "Posting No. Series" := GenJnlBatch."Posting No. Series";
                    IF SummarizePerVend THEN
                        "Document No." := TempPaymentBuffer."Document No."
                    ELSE
                        IF DocNoPerLine THEN BEGIN
                            IF TempPaymentBuffer.Amount < 0 THEN
                                "Document Type" := "Document Type"::Refund;

                            "Document No." := NextDocNo;
                            NextDocNo := INCSTR(NextDocNo);
                        END ELSE
                            IF (TempPaymentBuffer."Vendor No." = OldTempPaymentBuffer."Vendor No.") AND
                               (TempPaymentBuffer."Currency Code" = OldTempPaymentBuffer."Currency Code")
                            THEN
                                "Document No." := OldTempPaymentBuffer."Document No."
                            ELSE BEGIN
                                "Document No." := NextDocNo;
                                NextDocNo := INCSTR(NextDocNo);
                                OldTempPaymentBuffer := TempPaymentBuffer;
                                OldTempPaymentBuffer."Document No." := "Document No.";
                            END;
                    "Account Type" := "Account Type"::Vendor;
                    SetHideValidation(TRUE);
                    ShowPostingDateWarning := ShowPostingDateWarning OR
                      SetPostingDate(GenJnlLine, GetApplDueDate(TempPaymentBuffer."Vendor Ledg. Entry No."), PostingDate);
                    VALIDATE("Account No.", TempPaymentBuffer."Vendor No.");
                    Vendor.GET(TempPaymentBuffer."Vendor No.");
                    IF (Vendor."Pay-to Vendor No." <> '') AND (Vendor."Pay-to Vendor No." <> "Account No.") THEN
                        MESSAGE(Text025, Vendor.TABLECAPTION, Vendor."No.", Vendor.FIELDCAPTION("Pay-to Vendor No."),
                          Vendor."Pay-to Vendor No.");
                    "Bal. Account Type" := BalAccType;
                    VALIDATE("Bal. Account No.", BalAccNo);
                    VALIDATE("Currency Code", TempPaymentBuffer."Currency Code");
                    "Message to Recipient" := GetMessageToRecipient(SummarizePerVend);
                    "Bank Payment Type" := BankPmtType;
                    //PRJCTPR-248.HS.1.0 27Dec2023 Start
                    // IF SummarizePerVend THEN   //Commented 
                    //     GenJnlLine."Applies-to ID" := GenJnlLine."Document No."; //Commented
                    IF SummarizePerVend THEN begin
                        GenJnlLine."Applies-to ID" := GenJnlLine."Document No.";
                        GenJnlLine."NS_Retention Ledger Code" := VendLedgEntry."NS_Retention Ledger Code";
                    end
                    else
                        GenJnlLine."NS_Retention Ledger Code" := TempPaymentBuffer."NS_Retention Ledger Code";
                    //PRJCTPR-248.HS.1.0 27Dec2023 End
                    Description := Vendor.Name;
                    "Source Line No." := TempPaymentBuffer."Vendor Ledg. Entry No.";
                    "Shortcut Dimension 1 Code" := TempPaymentBuffer."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := TempPaymentBuffer."Global Dimension 2 Code";
                    //ProjectPro - start
                    //"NS_Retention Ledger Code" := TempPaymentBuffer."NS_Retention Ledger Code"; //PRJCTPR-248.HS.1.0 27Dec2023 Commented
                    //ProjectPro - end
                    "Dimension Set ID" := TempPaymentBuffer."Dimension Set ID";
                    "Source Code" := GenJnlTemplate."Source Code";
                    "Reason Code" := GenJnlBatch."Reason Code";
                    VALIDATE(Amount, TempPaymentBuffer.Amount);
                    "Applies-to Doc. Type" := TempPaymentBuffer."Vendor Ledg. Entry Doc. Type";
                    "Applies-to Doc. No." := TempPaymentBuffer."Vendor Ledg. Entry Doc. No.";
                    "Payment Method Code" := TempPaymentBuffer."Payment Method Code";
                    "Creditor No." := TempPaymentBuffer."Creditor No.";
                    "Payment Reference" := TempPaymentBuffer."Payment Reference";
                    "Exported to Payment File" := TempPaymentBuffer."Exported to Payment File";
                    "Applies-to Ext. Doc. No." := TempPaymentBuffer."Applies-to Ext. Doc. No.";
                    //ProjectPro - start
                    "Job No." := TempPaymentBuffer."NS_Job No.";
                    "NS_Subcontract No." := TempPaymentBuffer."NS_Subcontract No.";
                    "NS_Draw No." := TempPaymentBuffer."NS_Draw No.";
                    //ProjectPro - end
                    OnBeforeUpdateGnlJnlLineDimensionsFromTempBuffer(GenJnlLine, TempPaymentBuffer);
                    UpdateDimensions(GenJnlLine);
                    INSERT;
                    GenJnlLineInserted := TRUE;
                END;
            UNTIL TempPaymentBuffer.NEXT = 0;
    end;

    local procedure UpdateDimensions(var GenJnlLine: Record "Gen. Journal Line")
    var
        DimBuf: Record "Dimension Buffer";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        TempDimSetEntry2: Record "Dimension Set Entry" temporary;
        DimVal: Record "Dimension Value";
        NewDimensionID: Integer;
        DimSetIDArr: array[10] of Integer;
        NSDimCreate: List of [Dictionary of [Integer, Code[20]]];  //PRJCTPR-155.JS.1.0 11Sep2023
        NSDataPosition: Dictionary of [Integer, Code[20]];      //PRJCTPR-155.JS.1.0 11Sep2023        
    begin
        //PRJ-1137.RM.1.0.003 start
        // WITH GenJnlLine DO BEGIN
        NewDimensionID := GenJnlLine."Dimension Set ID";
        IF SummarizePerVend THEN BEGIN
            DimBuf.RESET();
            DimBuf.DELETEALL();
            DimBufMgt.GetDimensions(TempPaymentBuffer."Dimension Entry No.", DimBuf);
            IF DimBuf.FINDSET() THEN
                REPEAT
                    DimVal.GET(DimBuf."Dimension Code", DimBuf."Dimension Value Code");
                    TempDimSetEntry."Dimension Code" := DimBuf."Dimension Code";
                    TempDimSetEntry."Dimension Value Code" := DimBuf."Dimension Value Code";
                    TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
                    TempDimSetEntry.INSERT;
                UNTIL DimBuf.NEXT() = 0;
            NewDimensionID := DimMgt.GetDimensionSetID(TempDimSetEntry);
            GenJnlLine."Dimension Set ID" := NewDimensionID;
        END;
        //PRJCTPR-155.JS.1.0 11Sep2023 - Start
        // GenJnlLine.CreateDim(
        //   DimMgt.TypeToTableID1(GenJnlLine."Account Type".AsInteger()), GenJnlLine."Account No.",
        //   DimMgt.TypeToTableID1(GenJnlLine."Bal. Account Type".AsInteger()), GenJnlLine."Bal. Account No.",
        //   DATABASE::Job, GenJnlLine."Job No.",
        //   DATABASE::"Salesperson/Purchaser", GenJnlLine."Salespers./Purch. Code",
        //   DATABASE::Campaign, GenJnlLine."Campaign No.");

        NSDataPosition.Add(DimMgt.TypeToTableID1(GenJnlLine."Account Type".AsInteger()), GenJnlLine."Account No.");
        NSDataPosition.Add(DimMgt.TypeToTableID1(GenJnlLine."Bal. Account Type".AsInteger()), GenJnlLine."Bal. Account No.");
        NSDataPosition.Add(DATABASE::Job, GenJnlLine."Job No.");
        NSDataPosition.Add(DATABASE::"Salesperson/Purchaser", GenJnlLine."Salespers./Purch. Code");
        NSDataPosition.Add(DATABASE::Campaign, GenJnlLine."Campaign No.");

        NSDimCreate.Add(NSDataPosition);
        GenJnlLine.CreateDim(NSDimCreate);
        //PRJCTPR-155.JS.1.0 11Sep2023 - end

        IF NewDimensionID <> GenJnlLine."Dimension Set ID" THEN BEGIN
            DimSetIDArr[1] := GenJnlLine."Dimension Set ID";
            DimSetIDArr[2] := NewDimensionID;
            GenJnlLine."Dimension Set ID" :=
              DimMgt.GetCombinedDimensionSetID(DimSetIDArr, GenJnlLine."Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 2 Code");
        END;

        IF SummarizePerVend THEN BEGIN
            DimMgt.GetDimensionSet(TempDimSetEntry, GenJnlLine."Dimension Set ID");
            IF AdjustAgainstSelectedDim(TempDimSetEntry, TempDimSetEntry2) THEN
                GenJnlLine."Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry2);
            DimMgt.UpdateGlobalDimFromDimSetID(GenJnlLine."Dimension Set ID", GenJnlLine."Shortcut Dimension 1 Code",
              GenJnlLine."Shortcut Dimension 2 Code");
        END;
        //END;
        //PRJ-1137.RM.1.0.003 end
    end;

    local procedure SetBankAccCurrencyFilter(BalAccType: Enum "Gen. Journal Account Type"; BalAccNo: Code[20]; var TmpPayableVendLedgEntry: Record "Payable Vendor Ledger Entry")
    var
        BankAcc: Record "Bank Account";
    begin
        IF BalAccType = BalAccType::"Bank Account" THEN
            IF BalAccNo <> '' THEN BEGIN
                BankAcc.GET(BalAccNo);
                IF BankAcc."Currency Code" <> '' THEN
                    TmpPayableVendLedgEntry.SETRANGE("Currency Code", BankAcc."Currency Code");
            END;
    end;

    local procedure ShowMessage(Text: Text)
    begin
        IF GenJnlLineInserted THEN BEGIN
            IF ShowPostingDateWarning THEN
                Text += ReplacePostingDateMsg;
            IF Text <> '' THEN
                MESSAGE(Text);
        END;
    end;

    local procedure CheckCurrencies(BalAccType: Enum "Gen. Journal Account Type"; BalAccNo: Code[20]; var TmpPayableVendLedgEntry: Record "Payable Vendor Ledger Entry")
    var
        BankAcc: Record 270;
        TmpPayableVendLedgEntry2: Record "Payable Vendor Ledger Entry" temporary;
    begin
        IF BalAccType = BalAccType::"Bank Account" THEN
            IF BalAccNo <> '' THEN BEGIN
                BankAcc.GET(BalAccNo);
                IF BankAcc."Currency Code" <> '' THEN BEGIN
                    TmpPayableVendLedgEntry2.RESET;
                    TmpPayableVendLedgEntry2.DELETEALL;
                    IF TmpPayableVendLedgEntry.FIND('-') THEN
                        REPEAT
                            TmpPayableVendLedgEntry2 := TmpPayableVendLedgEntry;
                            TmpPayableVendLedgEntry2.INSERT;
                        UNTIL TmpPayableVendLedgEntry.NEXT = 0;

                    TmpPayableVendLedgEntry2.SETFILTER("Currency Code", '<>%1', BankAcc."Currency Code");
                    SeveralCurrencies := SeveralCurrencies OR TmpPayableVendLedgEntry2.FINDFIRST;

                    IF SeveralCurrencies THEN
                        MessageText :=
                          STRSUBSTNO(Text020, BankAcc.FIELDCAPTION("Currency Code"), BankAcc."Currency Code")
                    ELSE
                        MessageText :=
                          STRSUBSTNO(Text021, BankAcc.FIELDCAPTION("Currency Code"), BankAcc."Currency Code");
                END ELSE
                    MessageText := Text022;
            END;
    end;

    local procedure ClearNegative()
    var
        TempCurrency: Record Currency temporary;
        PayableVendLedgEntry2: Record "Payable Vendor Ledger Entry" temporary;
        CurrencyBalance: Decimal;
    begin
        CLEAR(PayableVendLedgEntry);
        PayableVendLedgEntry.SETRANGE("Vendor No.", Vendor."No.");

        WHILE PayableVendLedgEntry.NEXT <> 0 DO BEGIN
            TempCurrency.Code := PayableVendLedgEntry."Currency Code";
            CurrencyBalance := 0;
            IF TempCurrency.INSERT THEN BEGIN
                PayableVendLedgEntry2 := PayableVendLedgEntry;
                PayableVendLedgEntry.SETRANGE("Currency Code", PayableVendLedgEntry."Currency Code");
                REPEAT
                    CurrencyBalance := CurrencyBalance + PayableVendLedgEntry."Amount (LCY)"
                UNTIL PayableVendLedgEntry.NEXT = 0;
                IF CurrencyBalance < 0 THEN BEGIN
                    PayableVendLedgEntry.DELETEALL;
                    AmountAvailable += CurrencyBalance;
                END;
                PayableVendLedgEntry.SETRANGE("Currency Code");
                PayableVendLedgEntry := PayableVendLedgEntry2;
            END;
        END;
        PayableVendLedgEntry.RESET;
    end;

    local procedure DimCodeIsInDimBuf(DimCode: Code[20]; DimBuf: Record "Dimension Buffer"): Boolean
    begin
        DimBuf.RESET;
        DimBuf.SETRANGE("Dimension Code", DimCode);
        EXIT(NOT DimBuf.ISEMPTY);
    end;

    local procedure RemovePaymentsAboveLimit(var PayableVendLedgEntry: Record "Payable Vendor Ledger Entry"; RemainingAmtAvailable: Decimal)
    begin
        PayableVendLedgEntry.SETFILTER("Amount (LCY)", '>%1', RemainingAmtAvailable);
        PayableVendLedgEntry.DELETEALL;
        PayableVendLedgEntry.SETRANGE("Amount (LCY)");
    end;

    local procedure InsertDimBuf(var DimBuf: Record "Dimension Buffer"; TableID: Integer; EntryNo: Integer; DimCode: Code[20]; DimValue: Code[20])
    begin
        DimBuf.INIT;
        DimBuf."Table ID" := TableID;
        DimBuf."Entry No." := EntryNo;
        DimBuf."Dimension Code" := DimCode;
        DimBuf."Dimension Value Code" := DimValue;
        DimBuf.INSERT;
    end;

    local procedure GetMessageToRecipient(SummarizePerVend: Boolean): Text[140]
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        IF SummarizePerVend THEN
            EXIT(CompanyInformation.Name);

        VendorLedgerEntry.GET(TempPaymentBuffer."Vendor Ledg. Entry No.");
        IF VendorLedgerEntry."Message to Recipient" <> '' THEN
            EXIT(VendorLedgerEntry."Message to Recipient");

        EXIT(
          STRSUBSTNO(
            MessageToRecipientMsg,
            TempPaymentBuffer."Vendor Ledg. Entry Doc. Type",
            TempPaymentBuffer."Applies-to Ext. Doc. No."));
    end;

    local procedure SetPostingDate(var GenJnlLine: Record "Gen. Journal Line"; DueDate: Date; PostingDate: Date): Boolean
    begin
        IF NOT UseDueDateAsPostingDate THEN BEGIN
            GenJnlLine.VALIDATE("Posting Date", PostingDate);
            EXIT(FALSE);
        END;

        IF DueDate = 0D THEN
            DueDate := GenJnlLine.GetAppliesToDocDueDate;
        EXIT(GenJnlLine.SetPostingDateAsDueDate(DueDate, DueDateOffset));
    end;

    local procedure GetApplDueDate(VendLedgEntryNo: Integer): Date
    var
        AppliedVendLedgEntry: Record "Vendor Ledger Entry";
    begin
        IF AppliedVendLedgEntry.GET(VendLedgEntryNo) THEN
            EXIT(AppliedVendLedgEntry."Due Date");

        EXIT(PostingDate);
    end;

    local procedure AdjustAgainstSelectedDim(var TempDimSetEntry: Record "Dimension Set Entry" temporary; var TempDimSetEntry2: Record "Dimension Set Entry" temporary): Boolean
    begin
        IF SelectedDim.FINDSET THEN BEGIN
            REPEAT
                TempDimSetEntry.SETRANGE("Dimension Code", SelectedDim."Dimension Code");
                IF TempDimSetEntry.FINDFIRST THEN BEGIN
                    TempDimSetEntry2.TRANSFERFIELDS(TempDimSetEntry, TRUE);
                    TempDimSetEntry2.INSERT;
                END;
            UNTIL SelectedDim.NEXT = 0;
            EXIT(TRUE);
        END;
        EXIT(FALSE);
    end;

    local procedure SetTempPaymentBufferDims(var DimBuf: Record "Dimension Buffer")
    var
        GLSetup: Record "General Ledger Setup";
        EntryNo: Integer;
    begin
        IF SummarizePerDim THEN BEGIN
            DimBuf.RESET;
            DimBuf.DELETEALL;
            IF SelectedDim.FIND('-') THEN
                REPEAT
                    IF DimSetEntry.GET(
                         VendLedgEntry."Dimension Set ID", SelectedDim."Dimension Code")
                    THEN
                        InsertDimBuf(DimBuf, DATABASE::"Dimension Buffer", 0, DimSetEntry."Dimension Code",
                          DimSetEntry."Dimension Value Code");
                UNTIL SelectedDim.NEXT = 0;
            EntryNo := DimBufMgt.FindDimensions(DimBuf);
            IF EntryNo = 0 THEN
                EntryNo := DimBufMgt.InsertDimensions(DimBuf);
            TempPaymentBuffer."Dimension Entry No." := EntryNo;
            IF TempPaymentBuffer."Dimension Entry No." <> 0 THEN BEGIN
                GLSetup.GET;
                IF DimCodeIsInDimBuf(GLSetup."Global Dimension 1 Code", DimBuf) THEN
                    TempPaymentBuffer."Global Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code"
                ELSE
                    TempPaymentBuffer."Global Dimension 1 Code" := '';
                IF DimCodeIsInDimBuf(GLSetup."Global Dimension 2 Code", DimBuf) THEN
                    TempPaymentBuffer."Global Dimension 2 Code" := VendLedgEntry."Global Dimension 2 Code"
                ELSE
                    TempPaymentBuffer."Global Dimension 2 Code" := '';
            END ELSE BEGIN
                TempPaymentBuffer."Global Dimension 1 Code" := '';
                TempPaymentBuffer."Global Dimension 2 Code" := '';
            END;
            TempPaymentBuffer."Dimension Set ID" := VendLedgEntry."Dimension Set ID";
        END ELSE BEGIN
            TempPaymentBuffer."Dimension Entry No." := 0;
            TempPaymentBuffer."Global Dimension 1 Code" := '';
            TempPaymentBuffer."Global Dimension 2 Code" := '';
            TempPaymentBuffer."Dimension Set ID" := 0;
        END;
    end;

    local procedure IsEntryAlreadyApplied(GenJnlLine3: Record "Gen. Journal Line"; VendLedgEntry2: Record "Vendor Ledger Entry"): Boolean
    var
        GenJnlLine4: Record "Gen. Journal Line";
    begin
        GenJnlLine4.SETRANGE("Journal Template Name", GenJnlLine3."Journal Template Name");
        GenJnlLine4.SETRANGE("Journal Batch Name", GenJnlLine3."Journal Batch Name");
        GenJnlLine4.SETRANGE("Account Type", GenJnlLine4."Account Type"::Vendor);
        GenJnlLine4.SETRANGE("Account No.", VendLedgEntry2."Vendor No.");
        GenJnlLine4.SETRANGE("Applies-to Doc. Type", VendLedgEntry2."Document Type");
        GenJnlLine4.SETRANGE("Applies-to Doc. No.", VendLedgEntry2."Document No.");
        EXIT(NOT GenJnlLine4.ISEMPTY);
    end;

    local procedure SetDefaults()
    begin
        GenJnlBatch.GET(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
        IF GenJnlBatch."Bal. Account No." <> '' THEN BEGIN
            GenJnlLine2."Bal. Account Type" := GenJnlBatch."Bal. Account Type";
            GenJnlLine2."Bal. Account No." := GenJnlBatch."Bal. Account No.";
        END;
    end;

    local procedure CollectExistingPaymentLines()
    var
        GenJournalLine: Record "Gen. Journal Line";
        LineFound: Boolean;
    begin
        IF NOT CheckOtherJournalBatches THEN
            EXIT;

        IF TempPaymentBuffer.FINDSET THEN
            REPEAT
                LineFound := FALSE;
                GenJournalLine.SETRANGE("Document Type", GenJournalLine."Document Type"::Payment);
                GenJournalLine.SETRANGE("Account Type", GenJournalLine."Account Type"::Vendor);
                GenJournalLine.SETRANGE("Account No.", TempPaymentBuffer."Vendor No.");
                GenJournalLine.SETRANGE("Applies-to Doc. Type", TempPaymentBuffer."Vendor Ledg. Entry Doc. Type");
                GenJournalLine.SETRANGE("Applies-to Doc. No.", TempPaymentBuffer."Vendor Ledg. Entry Doc. No.");
                IF GenJournalLine.FINDSET THEN
                    REPEAT
                        IF (GenJournalLine."Journal Batch Name" <> GenJnlLine."Journal Batch Name") OR
                           (GenJournalLine."Journal Template Name" <> GenJnlLine."Journal Template Name")
                        THEN BEGIN
                            TempErrorMessage.LogMessage(
                              GenJournalLine, GenJournalLine.FIELDNO("Applies-to ID"),
                              TempErrorMessage."Message Type"::Warning,
                              STRSUBSTNO(
                                NotSuggestedPaymentInfoTxt,
                                GenJournalLine.FIELDCAPTION("Journal Template Name"),
                                GenJournalLine."Journal Template Name",
                                GenJournalLine.FIELDCAPTION("Journal Batch Name"),
                                GenJournalLine."Journal Batch Name",
                                GenJournalLine.FIELDCAPTION("Applies-to Doc. No."),
                                GenJournalLine."Applies-to Doc. No."));
                            LineFound := TRUE;
                        END;
                    UNTIL GenJournalLine.NEXT = 0;
                IF LineFound THEN
                    TempPaymentBuffer.DELETE;
            UNTIL TempPaymentBuffer.NEXT = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateTempBufferFromVendorLedgerEntry(var TempPaymentBuffer: Record "Payment Buffer" temporary; VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateGnlJnlLineDimensionsFromTempBuffer(var GenJournalLine: Record "Gen. Journal Line"; TempPaymentBuffer: Record "Payment Buffer" temporary)
    begin
    end;
}

