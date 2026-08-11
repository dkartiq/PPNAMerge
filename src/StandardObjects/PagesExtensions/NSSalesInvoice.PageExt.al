pageextension 14021113 NS_SalesInvoice extends "Sales Invoice"
{
    // version NAVW111.00.00.25466,NAVNA11.00.00.25466,PPNA11.00
    //TM-10.AM.1.0 30OCT2020 | added validation on Post Action.
    //CTSI-150.AS.1.0 28Sept2020 Added field
    //CTSI-150.AS.1.0 28Sept2020 Added button
    //PRJ-744.JS.1.0�23July2021 Add code to block voided invoice from posting
    //PRJ-955.RM.1.0 05-Oct-2021 | Make action's option Invisible  & Add them in Prepare action.
    //PRJ-955.RM.1.0 05-Oct-2021 | Move Action options to existing Prepare action .
    //PRJ-955.GK.1.0 07-Oct-2021 | Add after Copy Document action in place of Remove Incoming Doc.
    layout
    {
        //CTSI-150.AS.1.0 28Sept2020 - start
        addafter("Work Description")
        {
            field("NS_Use % Billing format"; REC."NS_Use % Billing format")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Use % Billing format Boolean';
            }
        }
        //CTSI-150.AS.1.0 28Sept2020 - end
        addafter("Assigned User ID")
        {
            field("NS_Job No."; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    if "NS_Job No." <> xRec."NS_Job No." then
                        CurrPage.UPDATE;
                    //ProjectPro - end
                end;
            }
            field("NS_Retention Document"; Rec."NS_Retention Document")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Retention Document';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_RetentionCalcs;
                    //ProjectPro - end
                end;
            }
        }
        addafter("Foreign Trade")
        {
            group("NS_Retention")
            {
                Caption = 'Retention';

                field("NS_Retention Base Amount"; NS_RetentionBaseAmount)
                {
                    ApplicationArea = All;
                    Caption = 'Retention Base Amount';
                    Editable = false;
                    ToolTip = 'Specifies the Retention Base Amount';
                }
                field("NS_Retention Percent"; Rec."NS_Retention Percent")
                {
                    ApplicationArea = All;
                    Caption = 'Retention Percent';
                    Editable = NS_RetentionPercentEditable;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Retention Percent';

                    trigger OnValidate();
                    begin
                        //ProjectPro - start
                        TESTFIELD(Status, Status::Open.AsInteger());
                        if "NS_Retention Percent" = 0 then begin
                            if ("NS_Retention Amount (LCY)" = 0) and ("NS_Retention Amount" = 0) then
                                "NS_Retention Date" := 0D;
                        end else begin
                            "NS_Retention Amount (LCY)" := ROUND("NS_Retention Base Amount" * ("NS_Retention Percent" / 100), NS_GLSetup."Amount Rounding Precision");
                            if "NS_Retention Date" = 0D then
                                "NS_Retention Date" := CALCDATE('+1Y', "Posting Date");
                        end;
                        CurrPage.UPDATE;
                        //ProjectPro - end
                    end;
                }
                field("NS_Retention Amount LCY"; Rec."NS_Retention Amount (LCY)")
                {
                    ApplicationArea = All;
                    Editable = NS_RetentionAmountLCYEditable;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Retention Amount (LCY)';

                    trigger OnValidate();
                    begin
                        //ProjectPro - start
                        TESTFIELD(Status, Status::Open.AsInteger());
                        "NS_Retention Percent" := 0;
                        if ("NS_Retention Amount (LCY)" <> 0) and ("NS_Retention Date" = 0D) then
                            "NS_Retention Date" := CALCDATE('+1Y', "Posting Date");
                        CurrPage.UPDATE;
                        //ProjectPro - end
                    end;
                }
                field("NS_Retention Amount"; Rec."NS_Retention Amount")
                {
                    ApplicationArea = All;
                    Editable = NS_RetentionAmountEditable;
                    ToolTip = 'Specifies the Retention Amount';

                    trigger OnValidate();
                    begin
                        //ProjectPro - start
                        TESTFIELD(Status, Status::Open.AsInteger());
                        "NS_Retention Percent" := 0;
                        if ("NS_Retention Amount" <> 0) and ("NS_Retention Date" = 0D) then
                            "NS_Retention Date" := CALCDATE('+1Y', "Posting Date");
                        CurrPage.UPDATE;
                        //ProjectPro - end
                    end;
                }
                field("NS_Retention Date"; Rec."NS_Retention Date")
                {
                    ApplicationArea = All;
                    Editable = NS_RetentionDateEditable;
                    ToolTip = 'Specifies the Retention Date';

                    trigger OnValidate();
                    begin
                        //ProjectPro - start
                        TESTFIELD(Status, Status::Open.AsInteger());
                        //ProjectPro - end
                    end;
                }
            }
        }
    }
    actions
    {
        modify(Statistics)
        {
            Visible = false;
            Enabled = false;
        }
        //CTSI-148.AS.1.0 14Sept2020 - Start //PRJ-702 START
        addafter(DraftInvoice)
        {
            action(NS_SaleInvRevCatSumm)
            {
                ApplicationArea = All;
                Caption = 'Sales Invoice - Rev. Cat. Summ.';
                Image = Print;

                trigger OnAction();
                var
                    SalesHdr: Record "Sales Header";
                begin
                    SalesHdr.Reset;
                    SalesHdr.SetRange("No.", Rec."No.");
                    SalesHdr.SetRange("Bill-to Customer No.", Rec."Bill-to Customer No.");
                    REPORT.RUNMODAL(14021231, true, false, SalesHdr);
                end;
            }
            //CTSI-150.AS.1.0 28Sept2020 - start
            action(NS_PercBilRevCatSum)
            {
                ApplicationArea = All;
                Caption = 'Percent Billing - Rev. Cat. Summ.';
                Image = Print;

                trigger OnAction();
                var
                    SalesHdr_L: Record "Sales Header";
                begin
                    SalesHdr_L.Reset;
                    SalesHdr_L.SetRange("No.", Rec."No.");
                    SalesHdr_L.SetRange("Bill-to Customer No.", Rec."Bill-to Customer No.");
                    if SalesHdr_L.FindFirst then begin
                        if SalesHdr_L."NS_Use % Billing format" = false then
                            Error('Please ensure that "Use % Bill Format" is checked to run the report')
                        else
                            REPORT.RUNMODAL(14021234, true, false, SalesHdr_L);
                    end;
                end;
            }
            //CTSI-150.AS.1.0 28Sept2020 - end
        }
        //CTSI-148.AS.1.0 14Sept2020 - end //PRJ-702 END

        //TM-10.AM.1.0 Start
        modify(Post)
        {
            trigger OnBeforeAction()
            var
                BillingHeader: Record 14021325;//PRJ-744
            begin
                JobSetup.Get();
                if JobSetup."NS_Job Segment Mandatory" then
                    if SalesLineSegment.Type <> SalesLineSegment.Type::"Fixed Asset" then begin
                        SalesLineSegment.Reset();
                        SalesLineSegment.SetCurrentKey("Document No.", "Line No.");
                        SalesLineSegment.SetRange("Document No.", Rec."No.");
                        SalesLineSegment.SetRange("Document Type", Rec."Document Type");
                        SalesLineSegment.SetFilter("Job No.", '<>%1', '');
                        if SalesLineSegment.FindSet() then begin
                            repeat
                                SalesLineSegment.TestField("NS_Segment Code");
                            until SalesLineSegment.Next() = 0;
                        end;
                    end;
                //PRJ-744.JS.1.0�23July2021-Start    
                IF Rec."Document Type" = Rec."Document Type"::Invoice then
                    IF ((Rec."NS_Job No." <> '') and (Rec."NS_From Progress Billing No." <> '') AND
                        (Rec."NS_From ProgressBillingReq.No." <> 0) AND
                        (Rec."NS_From ProgressBillingVer.No." <> 0)) then begin
                        BillingHeader.Reset();
                        BillingHeader.SETRANGE("NS_Job No.", Rec."NS_Job No.");
                        BillingHeader.SetRange("NS_No.", Rec."NS_From Progress Billing No.");
                        BillingHeader.SetRange("NS_Requisition No.", rec."NS_From ProgressBillingReq.No.");
                        BillingHeader.SetRange("NS_Version No.", Rec."NS_From ProgressBillingVer.No.");
                        BillingHeader.SetRange("NS_Sales Document No.", Rec."No.");
                        IF BillingHeader.FindFirst() then
                            IF BillingHeader.NS_Status = BillingHeader.NS_Status::Void then
                                Error('Not able to Post the Sales Invoice No. %1 as the Progress Billing No. %2 is already been Voided', Rec."No.", BillingHeader."NS_No.");
                    end;
                //PRJ-744.JS.1.0�23July2021-End
            end;
        }
        //TM-10.AM.1.0 End
        addafter("&Invoice")
        {
            action(NS_StatisticsModified)
            {
                ShortcutKey = F7;
                Caption = 'Statistics';
                ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
                ApplicationArea = Basic, Suite;
                Promoted = true;
                Enabled = "No." <> '';
                Image = Statistics;
                PromotedCategory = Category7;
                trigger OnAction();
                var
                    Handled: Boolean;
                    SalesCalcDiscountByType: Codeunit "Sales - Calc Discount By Type";
                BEGIN
                    OnBeforeStatisticsAction(Rec, Handled);
                    IF NOT Handled THEN BEGIN
                        CalcInvDiscForHeader;
                        //ProjectPro - start
                        MODIFY(TRUE);
                        //ProjectPro - end
                        COMMIT;
                        OnBeforeCalculateSalesTaxStatistics(Rec, TRUE);
                        //PPDA.1.0 Start
                        // IF "Tax Area Code" = '' THEN
                        //     PAGE.RUNMODAL(PAGE::"Sales Statistics", Rec)
                        // ELSE
                        //     PAGE.RUNMODAL(PAGE::"Sales Order Stats.", Rec);
                        //PPDA.1.0 End
                        Page.RunModal(Page::"Sales Statistics", Rec);//PPDA.1.0 Added
                        SalesCalcDiscountByType.ResetRecalculateInvoiceDisc(Rec); //PPDA.1.0 Added
                    END
                END;
            }
        }

        addafter(CopyDocument) //PRJ-955.GK.1.0 07-Oct-2021 | Add line
        //addafter(RemoveIncomingDoc) //PRJ-955.GK.1.0 07-Oct-2021 | Comment line
        {
            action("NS_Get Job Planning Line")
            {
                ApplicationArea = All;
                Caption = 'Get Job &Planning Line';
                Image = JobLines;
                //PRJ-955.RM.1.0 05-Oct-2021  Start
                PromotedCategory = Category6;
                Promoted = true;
                //PRJ-955.RM.1.0 05-Oct-2021 end

                trigger OnAction();
                begin
                    //ProjectPro - start
                    //CurrPage.SalesLines.PAGE.NS_GetJobBudget("Sell-to Customer No.");
                    NS_SalesLine.NS_GetJobBudget("Sell-to Customer No.");
                    //ProjectPro - end
                end;
            }
            action("NS_Get Usage")
            {
                ApplicationArea = All;
                Caption = 'Get &Usage';
                Image = LinesFromTimesheet;
                //PRJ-955.RM.1.0 05-Oct-2021 Start
                PromotedCategory = Category6;
                Promoted = true;
                //PRJ-955.RM.1.0 05-Oct-2021 End

                trigger OnAction();
                begin
                    //ProjectPro - start
                    NS_GetUsage;
                    //ProjectPro - end
                end;
            }
            action("NS_Get Contract")
            {
                ApplicationArea = All;
                Caption = 'Get &Billings';
                Image = SuggestVendorBills;
                //PRJ-955.RM.1.0 05-Oct-2021 Start
                PromotedCategory = Category6;
                Promoted = true;
                //PRJ-955.RM.1.0 05-Oct-2021 End

                trigger OnAction();
                begin
                    //ProjectPro - start
                    NS_GetContractPrice;
                    //ProjectPro - end
                end;
            }
            action("NS_Get Retention")
            {
                ApplicationArea = All;
                Caption = 'Get R&etention';
                Image = SuggestCustomerPayments;
                //PRJ-955.RM.1.0 05-Oct-2021 Start
                PromotedCategory = Category6;
                Promoted = true;
                //PRJ-955.RM.1.0 05-Oct-2021 End
                trigger OnAction();
                begin
                    //ProjectPro - start
                    if "NS_Retention Document" then
                        NS_GetJobRLedger
                    else
                        MESSAGE(Text14021100);
                    //ProjectPro - end
                end;
            }
        }
    }

    var
        NS_RetentionBaseAmount: Decimal;
        NS_RetentionPercentEditable: Boolean;
        NS_RetentionAmountLCYEditable: Boolean;
        NS_RetentionAmountEditable: Boolean;
        NS_RetentionDateEditable: Boolean;
        NS_JobsSetup: Record "Jobs Setup";
        NS_GLSetup: Record "General Ledger Setup";
        NS_SalesHeader: Record "Sales Header";
        NS_CustLedgEntry: Record "Cust. Ledger Entry";
        NS_SalesSetup: Record "Sales & Receivables Setup";
        NS_GetSalesRetentionList: Page "NS_Get Sales Retention List";
        NS_GetContract: Report "NS_Get Contract";
        Text14021100: Label 'This function can only be used when the Retention Document field is checked.';
        Text14021101: Label '"Retention for job "';
        NS_SalesLine: Record "Sales Line";
        SalesLineSegment: Record "Sales Line";//TM-10.AM.1.0
        JobSetup: Record "Jobs Setup";//TM-10.AM.1.0


    trigger OnAfterGetRecord();
    begin
        //ProjectPro - start
        NS_RetentionCalcs;
        //ProjectPro - end
    end;

    trigger OnOpenPage();
    begin
        //ProjectPro - start
        NS_RetentionDateEditable := TRUE;
        NS_RetentionAmountEditable := TRUE;
        NS_RetentionAmountLCYEditable := TRUE;
        NS_RetentionPercentEditable := TRUE;
        NS_JobsSetup.GET;
        NS_GLSetup.GET;
        NS_SalesSetup.GET;
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

        if (NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" =
            NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"2 - Calc tax on sale then apply retention determined by progress billing") or
           (NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" =
            NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing") then begin
            NS_RetentionAmountLCYEditable := false;
            NS_RetentionAmountEditable := false;
        end;

        if "NS_Progress Billing Document" then begin
            NS_RetentionPercentEditable := false;
            NS_RetentionAmountLCYEditable := false;
            NS_RetentionAmountEditable := false;
        end;
        //ProjectPro - end
    end;

    procedure NS_GetUsage();
    begin
        //ProjectPro - start
        //CurrPage.SalesLines.PAGE.NS_GetJobLedger;
        NS_SalesLine.NS_GetJobLedger;
        //ProjectPro - end
    end;

    LOCAL PROCEDURE OnBeforeStatisticsAction(VAR SalesHeader: Record 36; VAR Handled: Boolean);
    BEGIN
    END;

    LOCAL PROCEDURE OnBeforeCalculateSalesTaxStatistics(VAR SalesHeader: Record 36; ShowDialog: Boolean);
    BEGIN
    END;

    procedure NS_GetJobRLedger();
    var
        NS_SalesLine: Record "Sales Line";
        NS_Job: Record Job;
        NS_LineNumber: Integer;
    begin
        //ProjectPro - start
        NS_SalesHeader.COPY(Rec);
        NS_SalesHeader.SETRECFILTER;
        if not NS_SalesSetup."NS_Sales Retention Inactive" then begin
            NS_CustLedgEntry.RESET;
            NS_CustLedgEntry.SETRANGE("Customer No.", "Sell-to Customer No.");
            NS_CustLedgEntry.SETRANGE("Document Type", NS_CustLedgEntry."Document Type"::Invoice);
            NS_CustLedgEntry.SETRANGE(Open, true);
            NS_CustLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_JobsSetup."NS_Retention Receivable Ledger");
            NS_GetSalesRetentionList.SETTABLEVIEW(NS_CustLedgEntry);
            NS_GetSalesRetentionList.NS_SetSalesHeader(NS_SalesHeader);

            if NS_GetSalesRetentionList.RUNMODAL = ACTION::OK then
                with NS_CustLedgEntry do begin

                    NS_SalesLine.RESET;
                    NS_SalesLine.SETRANGE("Document Type", NS_SalesHeader."Document Type");
                    NS_SalesLine.SETRANGE("Document No.", NS_SalesHeader."No.");
                    if NS_SalesLine.FINDLAST then
                        NS_LineNumber := NS_SalesLine."Line No."
                    else
                        NS_LineNumber := 0;
                    SETFILTER("NS_Retention Applies-to Amount", '<>0');
                    if FINDSET then
                        repeat
                            if not NS_Job.GET(NS_CustLedgEntry.NS_GetJobNo(NS_CustLedgEntry)) then
                                NS_Job."NS_Contract No." := '';

                            NS_SalesLine.INIT;
                            NS_SalesLine."Document Type" := NS_SalesHeader."Document Type";
                            NS_SalesLine."Sell-to Customer No." := NS_SalesHeader."Sell-to Customer No.";
                            NS_SalesLine."Document No." := NS_SalesHeader."No.";
                            NS_LineNumber := NS_LineNumber + 10000;
                            NS_SalesLine."Line No." := NS_LineNumber;
                            NS_SalesLine.Type := NS_SalesLine.Type::NS_Ledger;
                            NS_SalesLine.VALIDATE(Type);
                            NS_SalesLine."No." := NS_JobsSetup."NS_Retention Receivable Ledger";
                            NS_SalesLine.VALIDATE("No.");
                            NS_SalesLine.Description := Text14021101 + NS_CustLedgEntry.NS_GetJobNo(NS_CustLedgEntry);
                            if NS_Job."NS_Contract No." > '' then
                                NS_SalesLine.Description := NS_SalesLine.Description + ' \ ' + NS_Job."NS_Contract No.";
                            NS_SalesLine."Job No." := NS_CustLedgEntry.NS_GetJobNo(NS_CustLedgEntry);
                            NS_SalesLine.Quantity := 1;
                            NS_SalesLine.VALIDATE(Quantity);
                            NS_SalesLine."Unit Price" := "NS_Retention Applies-to Amount";
                            if NS_SalesHeader."Document Type" = NS_SalesHeader."Document Type"::"Credit Memo" then
                                NS_SalesLine."Unit Price" := -NS_SalesLine."Unit Price";
                            NS_SalesLine.VALIDATE("Unit Price");
                            if NS_SalesLine."Tax Liable" then
                                if NS_SalesLine."Tax Area Code" <> '' then
                                    NS_SalesLine.VALIDATE("Tax Group Code", NS_Job."NS_Tax Group Code");
                            NS_SalesLine.INSERT;


                            "NS_Retention Applies-to Amount" := 0;
                            "Applies-to ID" := '';
                            MODIFY;
                        until NEXT = 0;
                end;
        end;

        CLEAR(NS_GetSalesRetentionList);
        //ProjectPro - end
    end;

    procedure NS_GetContractPrice();
    var
        NS_JobPlanningLine: Record "Job Planning Line";
    begin
        //ProjectPro - start
        NS_SalesHeader.COPY(Rec);
        NS_SalesHeader.SETRECFILTER;
        NS_JobPlanningLine.RESET;
        if "NS_Job No." <> '' then
            NS_JobPlanningLine.SETRANGE("Job No.", "NS_Job No.");
        NS_JobPlanningLine.SETRANGE("Line Type", NS_JobPlanningLine."Line Type"::Billable);
        NS_GetContract.SETTABLEVIEW(NS_JobPlanningLine);
        NS_GetContract.SETTABLEVIEW(NS_SalesHeader);
        NS_GetContract.RUNMODAL;
        CLEAR(NS_GetContract);
        //ProjectPro - end
    end;

    /* Documentation
    +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     Job No.
      +     Retention Document
      +     Retention Base Amount
      +     Retention Percent
      +     Retention Percent
      +     Retention Amount (LCY)
      +     Retention Amount
      +     Retention Date
      +
      +  - Added function(s):
      +     PP_RetentionCalcs
      +     PP_GetUsage
      +     PP_GetJobRLedger
      +     PP_GetContractPrice
      +
      +  - Added global variable(s):
      +     PP_RetentionBaseAmount
      +     PP_RetentionPercentEditable
      +     PP_RetentionAmountLCYEditable
      +     PP_RetentionAmountEditable
      +     PP_RetentionDateEditable
      +     PP_JobsSetup
      +     PP_GLSetup
      +     PP_SalesHeader
      +     PP_CustLedgEntry
      +     PP_SalesSetup
      +     PP_GetSalesRetentionList
      +     PP_GetContract
      +     PP_SalesLine
      +
      +  - Added global text constant(s):
      +     Text14021100
      +     Text14021101
      +
      +  - Modification(s):
      +     - OnOpenPage - Read setup records
      +                       PP_JobsSetup
      +                       PP_GLSetup
      +                       PP_SalesSetup
      +                  - Initialize variables
      +     - Modified controls:
      +         Statistics - OnAction - Add call PP_RetentionCalcs
      +     - Menus:
      +       - Added commands
      +           Get Job Planning Line
      +           Get Usage
      +           Get Billings
      +           Get Retention
      +       - Added Retention fasttab
      +
      + -SMP
      +  -Modified page Triggers
      +   -OnOpenPage
      +   -OnAfterGetRecord
      +  -Rewritten Actions
      +   -Statistics
      +-----------------------------------------------------------------------------------------------
    */

}

