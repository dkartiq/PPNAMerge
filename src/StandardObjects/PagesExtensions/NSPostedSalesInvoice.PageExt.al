pageextension 14021143 NS_PostedSalesInvoice extends "Posted Sales Invoice"
{
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,NAVMX11.00.00.23572,PPNA11.00
    //CTSI-42.AS.1.0 21MAY2020  Added action "Sales Invoice - Rev. Cat. Summ."
    //CTSI-150.AS.1.0 28Sept2020 Added field
    //PRJ-1304.RM.1 22April2022 | Added a Field
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    //PRJ-1624.NK.1.0 22Sep2022 | Added Field
    //PRJCTPR-252.HS.1.0 20Dec2023 | Made "NS_Draw No."Uneditable
    Caption = 'Posted Sales Invoice'; //PRJ-1330.NK.1.0 25Apr2022
                                      //PE-265.DK.1.0 29FEB2024 | Added a Action "Create Corrective Retention Credit Memo"
    layout
    {
        modify(GetWorkDescription)
        {
            ToolTip = 'Specifies the Work Description';
        }
        addafter("Work Description")
        {
            //CTSI-150.AS.1.0 28Sept2020 - start
            field("NS_Use % Billing format"; REC."NS_Use % Billing format")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Use % Billing format Boolean';
                Editable = false;
            }
            //PRJ-1304.RM.1 start
            field("NS_Draw No."; Rec."NS_Draw No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the Draw No.';
                Editable = false; //PRJCTPR-252.HS.1.0 20Dec2023
            }
            //PRJ-1304.RM.1 end
            //CTSI-150.AS.1.0 28Sept2020 - end
            field("NS_Job No."; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the Job No.';
            }
            field("NS_Retention Document"; Rec."NS_Retention Document")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies whether this is a Retention Document';
            }
            //PRJ-1624.NK.1.0 22Sep2022 Start
            field("NS_Multiple Retention on Lines"; Rec."NS_Multiple Retention on Lines")
            {
                ApplicationArea = all;
                Editable = false;
                ToolTip = 'Specifies the Multiple Retention on Lines';
                Caption = 'Multiple Retention on Lines';
            }
            //PRJ-1624.NK.1.0 22Sep2022 End
        }
        addafter("Foreign Trade")
        {
            group("NS_Retention")
            {
                Caption = 'Retention';
                field("NS_Retention Base Amount"; Rec."NS_Retention Base Amount")
                {
                    Caption = 'Retention Base Amount + Tax';    //MHNA-7.JS.1.0 23JUN2023
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Retention Base Amount with Tax';   //MHNA-7.JS.1.0 23JUN2023
                }
                //MHNA-7.JS.1.0 23JUN2023 - Start
                field("NS_Retention Base Before Tax"; rec."NS_Retention Base Before Tax")
                {
                    Caption = 'Retention Base Amount';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Retention Base Amount';
                }
                //MHNA-7.JS.1.0 23JUN2023 - end
                field("NS_Retention Percent"; Rec."NS_Retention Percent")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Retention Percent';
                }
                field("NS_Retention Amount (LCY)"; Rec."NS_Retention Amount (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Retention Amount (LCY)';
                }
                field("NS_Retention Amount"; Rec."NS_Retention Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Retention Amount';
                }
                field("NS_Retention Date"; Rec."NS_Retention Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Retention Date';
                }
            }
        }

    }
    //CTSI-42.AS.1.0 21MAY2020 - start
    actions
    {
        addafter(Print)
        {
            action("NS_Sales Invoice - Rev. Cat. Summ.")
            {
                ApplicationArea = All;
                Caption = 'Posted Sales Invoice - Rev. Cat. Sum.';//PE-141.NK.1.0 03Aug2023 updated caption
                Image = Print;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;

                trigger OnAction();
                var
                    SalesInvHdr: Record "Sales Invoice Header";
                begin
                    SalesInvHdr.Reset;
                    SalesInvHdr.SetRange("No.", Rec."No.");
                    SalesInvHdr.SetRange("Bill-to Customer No.", Rec."Bill-to Customer No.");
                    REPORT.RUNMODAL(14021230, true, false, SalesInvHdr);
                end;
            }
            //CTSI-150.AS.1.0 28Sept2020 - start
            action("NS_Percent Billing - Rev. Cat. Summ.")
            {
                ApplicationArea = All;
                Caption = 'Percent Billing - Rev. Cat. Summ.';
                Image = Print;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;

                trigger OnAction();
                var
                    SalesInvHdr: Record "Sales Invoice Header";
                begin
                    SalesInvHdr.Reset;
                    SalesInvHdr.SetRange("No.", Rec."No.");
                    SalesInvHdr.SetRange("Bill-to Customer No.", Rec."Bill-to Customer No.");
                    if SalesInvHdr.FindFirst then begin
                        if SalesInvHdr."NS_Use % Billing format" = false then
                            Error('Please ensure that "Use % Bill Format" is checked to run the report')
                        else
                            REPORT.RUNMODAL(14021233, true, false, SalesInvHdr);
                    end;
                end;
            }
            //CTSI-150.AS.1.0 28Sept2020 - end
        }
        //PRJCTPR-11.GK.1.0 20Apr2023 start
        addafter(Invoice)
        {
            group("NS_Print Lier Waiver")
            {
                Visible = true;
                Caption = 'Print Lier Waiver';

                action("NS_Conditional Progress")
                {
                    ApplicationArea = all;
                    Caption = 'Conditional Progress';
                    trigger OnAction()
                    var
                        ConditionalProgress: Report 14021472;
                    begin
                        ConditionalProgress.SetDocument(rec."NS_Job No.", rec."No.", rec."Currency Code");
                        ConditionalProgress.UseRequestPage(false);
                        ConditionalProgress.Run();
                    end;
                }
                action("NS_Conditional Final")
                {
                    ApplicationArea = all;
                    Caption = 'Conditional Final';
                    trigger OnAction()
                    var
                        ConditionalFinal: Report 14021471;
                    begin
                        ConditionalFinal.SetDocument(rec."NS_Job No.", rec."No.", Rec."Currency Code");
                        ConditionalFinal.UseRequestPage(false);
                        ConditionalFinal.Run();
                    end;
                }
                action("NS_Unconditional Progress")
                {
                    ApplicationArea = all;
                    Caption = 'Unconditional Progress';
                    trigger OnAction()
                    var
                        UnconditionalProgress: Report 14021474;
                    begin
                        UnconditionalProgress.SetDocument(rec."NS_Job No.", rec."No.", Rec."Currency Code");
                        UnconditionalProgress.UseRequestPage(false);
                        UnconditionalProgress.Run();
                    end;
                }
                action("NS_Unconditional Final")
                {
                    ApplicationArea = all;
                    Caption = 'Unconditional Final';
                    trigger OnAction()
                    var
                        UnconditionalFinal: Report 14021473;
                    begin
                        UnconditionalFinal.SetDocument(rec."NS_Job No.", rec."No.", Rec."Currency Code");
                        UnconditionalFinal.UseRequestPage(false);
                        UnconditionalFinal.Run();
                    end;
                }

            }
            //PRJCTPR-11.GK.1.0 20Apr2023 end
        }
        //CTSI-42.AS.1.0 21MAY2020 - end
        //PE-265.DK.1.0 29Feb2024 Start
        addafter(CreateCreditMemo)
        {
            action(NS_CreateCorrectiveRetentionCreditMemon)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Create Corrective Credit Memo with Retention';  //PE-265.JS
                Image = CreateCreditMemo;
                ToolTip = 'Create a credit memo for this posted invoice with retention that you complete and post manually to reverse the posted invoice.';
                Promoted = true;
                PromotedCategory = Category5;
                PromotedOnly = true;

                trigger OnAction()
                var
                    NS_SalesHeader: Record "Sales Header";
                    NS_CorrectPostedSalesInvoice: Codeunit "Correct Posted Sales Invoice";
                begin
                    Rec.SetRange("No.", Rec."No.");
                    if Rec."NS_Retention Amount" <> 0 then begin
                        if (Rec."NS_From Progress Billing No." <> '') then begin
                            Error('Invoice %1 is partially paid or credited. The corrective credit memo may not be fully closed by the invoice. As the Progress Billing No. exist on posted sales invoice %2. Please create a "New Version" from the related Progress Billing Requisition %3-%4-%5 in this case.', Rec."No.", Rec."No.", Rec."NS_From Progress Billing No.", Rec."NS_From ProgressBillingReq.No.", Rec."NS_From ProgressBillingVer.No.");  //PE-265.JS line commented
                        end;
                        if (Rec."NS_From Progress Billing No." = '') then begin
                            NS_CreateCopyDocumentForRetenctionInvoice(rec, NS_SalesHeader, NS_SalesHeader."Document Type"::"Credit Memo", false);
                            PAGE.Run(PAGE::"Sales Credit Memo", NS_SalesHeader);
                        end;
                    end;
                end;
            }
        }

    }
    //PE-265.DK.1.0 29Feb2024 end

    //PE-265.DK.1.0.18March2024 Start
    local procedure NS_CreateCopyDocumentForRetenctionInvoice(var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesHeader: Record "Sales Header"; DocumentType: Enum "Sales Document Type"; SkipCopyFromDescription: Boolean)
    var
        CopyDocMgt: Codeunit "Copy Document Mgt.";
        NS_WrongDocumentTypeForCopyDocumentErr: Label 'You cannot correct or cancel this type of document.';
    begin
        Clear(SalesHeader);
        SalesHeader."No." := '';
        SalesHeader."Document Type" := DocumentType;
        SalesHeader.SetAllowSelectNoSeries();
        SalesHeader.Insert(true);

        case DocumentType of
            SalesHeader."Document Type"::"Credit Memo":
                CopyDocMgt.SetPropertiesForCreditMemoCorrection();
            SalesHeader."Document Type"::Invoice:
                CopyDocMgt.SetPropertiesForInvoiceCorrection(SkipCopyFromDescription);
            else
                Error(NS_WrongDocumentTypeForCopyDocumentErr);
        end;

        CopyDocMgt.CopySalesDocForInvoiceCancelling(SalesInvoiceHeader."No.", SalesHeader);
    end;
    //PE-265.DK.1.0.18March2024 End
    //   +---------------------------------------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +     PP Job No.
    //   +     PP Retention Document
    //   +     PP Retention
    //   +     PP Retention Base Amount
    //   +     PP Retention Percent
    //   +     PP Retention Amount (LCY)
    //   +     PP Retention Amount
    //   +     PP Retention Date
    //   +
    //   +  - Added function(s):
    //   +
    //   +  - Added global variable(s):
    //   +
    //   +  - Added global text constant(s):
    //   +
    //   +  - Modification(s):
    //   +-----------------------------------------------------------------------------------------------

}

