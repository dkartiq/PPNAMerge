pageextension 14021121 NS_PurchaseCreditMemo extends "Purchase Credit Memo"
{
    // version NAVW111.00.00.24742,NAVNA11.00.00.24742,PPNA11.00
    //PRJ-168.SK.1.0 Added code
    //PRJ-372.MS.1.0 code comment due to wrong value changes
    //TM-10.AM.1.0 23NOV2020 | Added validation on Post action.
    layout
    {
        addafter("Assigned User ID")
        {
            field("NS_Job No."; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';
            }
            field("NS_Retention Document"; Rec."NS_Retention Document")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Retention Document';
            }
            field("NS_Subcontract No."; Rec."NS_Subcontract No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Subcontract No.';
            }
            field("NS_Draw No."; Rec."NS_Draw No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Draw No.';
            }
        }
        //PPDA.1.0.TBA Start
        // addafter("Electronic Invoice")
        // {
        //     group("NS_Retention")
        //     {
        //         Caption = 'Retention';
        //        field("NS_Retention Base Amount"; NS_RetentionBaseAmount)    //PRJ-939.JS.1.0 27Sep2021
        //         {
        //             ApplicationArea = All;
        //             Editable = false;
        //             ToolTip = 'Specifies the Retention Base Amount';
        //         }
        //         field("NS_Retention Percent"; Rec."NS_Retention Percent")
        //         {
        //             ApplicationArea = All;
        //             Editable = NS_RetentionPercentEditable;
        //             Importance = Promoted;
        //             ToolTip = 'Specifies the Retention Percent';

        //             trigger OnValidate();
        //             begin
        //                 //ProjectPro - start
        //                 TESTFIELD(Status, Status::Open.AsInteger());
        //                 //ProjectPro - end
        //             end;
        //         }
        //         field("NS_Retention Amount (LCY)"; Rec."NS_Retention Amount (LCY)")
        //         {
        //             ApplicationArea = All;
        //             Editable = NS_RetentionAmountLCYEditable;
        //             Importance = Promoted;
        //             ToolTip = 'Specifies the Retention Amount (LCY)';

        //             trigger OnValidate();
        //             begin
        //                 //ProjectPro - start
        //                 TESTFIELD(Status, Status::Open.AsInteger());
        //                 //ProjectPro - end
        //             end;
        //         }
        //         field("NS_Retention Amount"; Rec."NS_Retention Amount")
        //         {
        //             ApplicationArea = All;
        //             Editable = NS_RetentionAmountEditable;
        //             ToolTip = 'Specifies the Retention Amount';
        //         }
        //         field("NS_Retention Date"; Rec."NS_Retention Date")
        //         {
        //             ApplicationArea = All;
        //             Editable = NS_RetentionDateEditable;
        //             ToolTip = 'Specifies the Retention Date';

        //             trigger OnValidate();
        //             begin
        //                 //ProjectPro - start
        //                 TESTFIELD(Status, Status::Open.AsInteger());
        //                 //ProjectPro - end
        //             end;
        //         }
        //     }
        // }
        //PPDA.1.0.TBA End
    }
    actions
    {
        modify(Post)
        {
            Visible = false;
            Enabled = false;
        }
        addbefore(Preview)
        {
            action(NS_PostNew)
            {
                Caption = 'P&ost';
                ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedIsBig = true;
                Image = PostOrder;
                PromotedCategory = Process;
                trigger OnAction();
                var
                    EventSubsCOD14021112: Codeunit "NS_Event Subscr. Codeunit 90"; //PRJ-168.SK.1.0 Added
                begin
                    //ProjectPro - start
                    //NS_PostPurchaseReturn(Rec); //PRJ-168.SK.1.0 Blocked
                    //EventSubsCOD14021112.NS_PostPurchaseReturn(Rec); //PRJ-168.SK.1.0 Added	//PRJ-372 code comment
                    //ProjectPro - end
                    //TM-10.AM.1.0 Start
                    Jobssetup.Get();
                    if Jobssetup."NS_Job Segment Mandatory" then
                        if PurchaseCredit.Type <> PurchaseCredit.Type::"Fixed Asset" then begin
                            PurchaseCredit.Reset();
                            PurchaseCredit.SetCurrentKey("Document No.", "Line No.");
                            PurchaseCredit.SetRange("Document No.", Rec."No.");
                            PurchaseCredit.SetRange("Document Type", Rec."Document Type");
                            PurchaseCredit.SetFilter("No.", '<>%1', '');
                            PurchaseCredit.SetFilter("Job No.", '<>%1', '');
                            if PurchaseCredit.FindSet() then begin
                                repeat
                                    PurchaseCredit.TestField("NS_Segment Code");
                                until PurchaseCredit.Next() = 0;
                            end;
                        end;
                    //TM-10.AM.1.0 End
                    Post(CODEUNIT::"Purch.-Post (Yes/No)");
                end;
            }
        }

        addafter(CalculateInvoiceDiscount)
        {
            separator(NS_Separator1100773003)
            {
            }
            action("NS_Get Job Planning Lines")
            {
                Caption = 'Get Job &Planning Lines';
                Image = JobLines;
                ApplicationArea = All;
                ToolTip = 'Get Job Planning Lines';

                trigger OnAction();
                begin
                    //ProjectPro - start
                    CurrPage.PurchLines.PAGE.NS_GetJobBudget('')
                    //ProjectPro - end
                end;
            }
            action("NS_Get Retention")
            {
                Caption = 'Get R&etention';
                Image = SuggestCustomerPayments;
                ApplicationArea = All;
                ToolTip = 'Get Retention';

                trigger OnAction();
                begin
                    //ProjectPro - start
                    if "NS_Retention Document" then
                        NS_GetJobRLedger
                    else
                        MESSAGE(Text14021101);
                    //ProjectPro - end
                end;
            }
            action("NS_Get Subcontract")
            {
                Caption = 'Get &Subcontract';
                Image = CalculateRemainingUsage;
                ApplicationArea = All;
                ToolTip = 'Get Subcontract';

                trigger OnAction();
                begin
                    //ProjectPro - start
                    NS_GetSubcontract;
                    //ProjectPro - end
                end;
            }
        }
    }

    var
        NS_RetentionBaseAmount: Decimal;
        [InDataSet]
        NS_RetentionPercentEditable: Boolean;
        [InDataSet]
        NS_RetentionAmountLCYEditable: Boolean;
        [InDataSet]
        NS_RetentionAmountEditable: Boolean;
        [InDataSet]
        NS_RetentionDateEditable: Boolean;
        NS_JobsSetup: Record "Jobs Setup";
        NS_PurchHeader: Record "Purchase Header";
        JobsSetup: Record "Jobs Setup";//TM-10.AM.1.0
        PurchaseCredit: Record "Purchase Line";//TM-10.AM.1.0
        NS_VendLedgEntry: Record "Vendor Ledger Entry";
        NS_PurchSetup: Record "Purchases & Payables Setup";
        NS_GetPurchaseRetentionList: Page "NS_Get Purchase Retention List";
        Text14021100: Label '"Retention for job "';
        Text14021101: Label 'This function can only be performed if Retention Document is checked.';
        LinesInstructionMgt: Codeunit 1320;
        DocumentIsPosted: Boolean;
        IsOfficeAddin: Boolean;
        OpenPostedPurchCrMemoQst: Label 'The credit memo has been posted and archived.\\Do you want to open the posted credit memo from the Posted Purchase Credit Memos window?';

    trigger OnOpenPage();
    var
        OfficeMgt: Codeunit 1630;
    begin
        IsOfficeAddin := OfficeMgt.IsAvailable;
        IF ("No." <> '') AND ("Buy-from Vendor No." = '') THEN
            DocumentIsPosted := (NOT GET("Document Type", "No."));
        //ProjectPro - start
        NS_JobsSetup.GET;
        NS_PurchSetup.GET;
        NS_RetentionDateEditable := TRUE;
        NS_RetentionAmountEditable := TRUE;
        NS_RetentionAmountLCYEditable := TRUE;
        NS_RetentionPercentEditable := TRUE;
        //ProjectPro - end
    end;

    trigger OnAfterGetRecord();
    begin
        //ProjectPro - start
        NS_RetentionCalcs;
        //ProjectPro - end
    end;

    LOCAL PROCEDURE Post(PostingCodeunitID: Integer);
    VAR
        PurchaseHeader: Record 38;
        PurchCrMemoHdr: Record 124;
        ApplicationAreaSetup: Record 9178;
        InstructionMgt: Codeunit 1330;
        IsScheduledPosting: Boolean;
    BEGIN
        IF ApplicationAreaSetup.IsFoundationEnabled THEN
            LinesInstructionMgt.PurchaseCheckAllLinesHaveQuantityAssigned(Rec);

        SendToPosting(PostingCodeunitID);

        IsScheduledPosting := "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting";
        DocumentIsPosted := (NOT PurchaseHeader.GET("Document Type", "No.")) OR IsScheduledPosting;

        IF IsScheduledPosting THEN
            CurrPage.CLOSE;
        CurrPage.UPDATE(FALSE);

        IF PostingCodeunitID <> CODEUNIT::"Purch.-Post (Yes/No)" THEN
            EXIT;

        IF IsOfficeAddin THEN BEGIN
            PurchCrMemoHdr.SETRANGE("Pre-Assigned No.", "No.");
            IF PurchCrMemoHdr.FINDFIRST THEN
                PAGE.RUN(PAGE::"Posted Purchase Credit Memo", PurchCrMemoHdr);
        END ELSE
            IF InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode) THEN
                NS_ShowPostedConfirmationMessage;
    END;


    procedure NS_GetJobRLedger();
    var
        NS_PurchLine: Record "Purchase Line";
        NS_LineNumber: Integer;
        Text0001: Label '"Retention for job "';
    begin
        //ProjectPro - start
        NS_PurchHeader.COPY(Rec);
        NS_PurchHeader.SETRECFILTER;
        if not NS_PurchSetup."NS_Purchase Retention Inactive" then begin
            NS_VendLedgEntry.RESET;
            NS_VendLedgEntry.SETRANGE("Vendor No.", "Buy-from Vendor No.");
            NS_VendLedgEntry.SETRANGE("Document Type", NS_VendLedgEntry."Document Type"::Invoice);
            NS_VendLedgEntry.SETRANGE(Open, true);
            NS_VendLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_JobsSetup."NS_Retention Payable Ledger");
            NS_GetPurchaseRetentionList.SETTABLEVIEW(NS_VendLedgEntry);
            NS_GetPurchaseRetentionList.NS_SetPurchHeader(NS_PurchHeader);

            if NS_GetPurchaseRetentionList.RUNMODAL = ACTION::OK then begin
                with NS_VendLedgEntry do begin

                    NS_PurchLine.RESET;
                    NS_PurchLine.SETRANGE("Document Type", NS_PurchHeader."Document Type");
                    NS_PurchLine.SETRANGE("Document No.", NS_PurchHeader."No.");
                    if NS_PurchLine.FINDLAST then
                        NS_LineNumber := NS_PurchLine."Line No."
                    else
                        NS_LineNumber := 0;
                    SETFILTER("NS_Retention Applies-to Amount", '<>0');
                    if FINDSET then
                        repeat

                            NS_PurchLine.INIT;
                            NS_PurchLine."Document Type" := NS_PurchHeader."Document Type";
                            NS_PurchLine."Buy-from Vendor No." := NS_PurchHeader."Buy-from Vendor No.";
                            NS_PurchLine."Document No." := NS_PurchHeader."No.";
                            NS_LineNumber := NS_LineNumber + 10000;
                            NS_PurchLine."Line No." := NS_LineNumber;
                            NS_PurchLine.Type := NS_PurchLine.Type::NS_Ledger;
                            NS_PurchLine.VALIDATE(Type);
                            NS_PurchLine."No." := NS_JobsSetup."NS_Retention Payable Ledger";
                            NS_PurchLine.VALIDATE("No.");
                            NS_PurchLine.Description := Text14021100 + NS_PurchLine."Job No.";
                            NS_PurchLine."Job No." := NS_VendLedgEntry.GetJobNo(NS_VendLedgEntry);
                            NS_PurchLine.Quantity := 1;
                            NS_PurchLine.VALIDATE(Quantity);
                            NS_PurchLine."Direct Unit Cost" := "NS_Retention Applies-to Amount";
                            NS_PurchLine.Amount := NS_PurchLine."Unit Cost";
                            if NS_PurchHeader."Document Type" = NS_PurchHeader."Document Type"::"Credit Memo" then
                                NS_PurchLine."Direct Unit Cost" := -NS_PurchLine."Direct Unit Cost";
                            NS_PurchLine.VALIDATE("Direct Unit Cost");
                            NS_PurchLine.INSERT;


                            "NS_Retention Applies-to Amount" := 0;
                            "Applies-to ID" := '';
                            MODIFY;
                        until NEXT = 0;
                end;
            end;

            CLEAR(NS_GetPurchaseRetentionList);
        end;
        //ProjectPro - end
    end;

    procedure NS_RetentionCalcs();
    begin
        //ProjectPro - start
        NS_RetentionBaseAmount := NS_RetentionBase("Document Type", "No.");

        if "NS_Retention Percent" <> 0 then begin
            VALIDATE("NS_Retention Percent");
            VALIDATE("NS_Retention Date");
        end else
            if "NS_Retention Amount (LCY)" <> 0 then begin
                VALIDATE("NS_Retention Amount (LCY)");
                VALIDATE("NS_Retention Date");
            end;

        if "NS_Retention Document" then begin
            "NS_Retention Percent" := 0;
            "NS_Retention Amount (LCY)" := 0;
            "NS_Retention Amount" := 0;
            "NS_Retention Date" := 0D;
            NS_RetentionPercentEditable := false;
            NS_RetentionAmountLCYEditable := false;
            NS_RetentionAmountEditable := false;
            NS_RetentionDateEditable := false;
        end else begin
            NS_RetentionPercentEditable := true;
            NS_RetentionAmountLCYEditable := true;
            NS_RetentionAmountEditable := true;
            NS_RetentionDateEditable := true;
        end;

        if NS_JobsSetup."NS_Calc Payable Ret Before Tax" then begin
            NS_RetentionAmountLCYEditable := false;
            NS_RetentionAmountEditable := false;
        end;
        //ProjectPro - end
    end;

    procedure NS_GetSubcontract();
    begin
        //ProjectPro - start
        CODEUNIT.RUN(CODEUNIT::"NS_Purch.-Get Subcontract", Rec);
        //ProjectPro - end
    end;

    LOCAL PROCEDURE NS_ShowPostedConfirmationMessage();
    VAR
        PurchCrMemoHdr: Record 124;
        InstructionMgt: Codeunit 1330;
    BEGIN
        PurchCrMemoHdr.SETRANGE("Pre-Assigned No.", "No.");
        IF PurchCrMemoHdr.FINDFIRST THEN
            IF InstructionMgt.ShowConfirm(OpenPostedPurchCrMemoQst, InstructionMgt.ShowPostedConfirmationMessageCode) THEN
                PAGE.RUN(PAGE::"Posted Purchase Credit Memo", PurchCrMemoHdr);
    END;

    /* Documentation
      +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     Job No.
      +     Retention Document
      +     Subcontract No.
      +     Draw No.
      +     - PP Retention;
      +         PP Retention Base Amount
      +         PP Retention Percent
      +         PP Retention Amount (LCY)
      +         PP Retention Amount
      +         PP Retention Date
      +
      +  - Added function(s):
      +     PP_GetJobRLedger
      +     PP_RetentionCalcs
      +     PP_GetSubcontract
      +
      +  - Added global variable(s):
      +     PP_RetentionBaseAmount
      +     PP_RetentionPercentEditable
      +     PP_RetentionAmountLCYEditable
      +     PP_RetentionAmountEditable
      +     PP_RetentionDateEditable
      +     PP_JobsSetup
      +     PP_PurchHeader
      +     PP_VendLedgEntry
      +     PP_PurchSetup
      +     PP_GetPurchaseRetentionList
      +
      +  - Added global text constant(s):
      +      Text14021100
      +      Text14021101
      +
      +  - Modification(s):
      +     - OnOpenPage - Read setup records
      +                       Jobs Setup
      +                       Purchases and Payables Setup
      +                  - Initialize variables
      +
      +     - OnAfterGetRecord - Call PP_RetentionCalcs
      +
      +     - Added action list:
      +         Get Job Planning Lines
      +         Get Retention
      +         Get Subcontract
      +
      +     - Modify action list:
      +         Post - Added call to PP_PostPurchaseReturn
      +
      + -SMP
      +  -Modified Page Trigers
      +   -OnOpenPage
      +   -OnAfterGetRecord
      +  -Rewritten Action
      +   -Post
      +  -Rewritten procedure
      +   -Post
      +-----------------------------------------------------------------------------------------------
    */

}

