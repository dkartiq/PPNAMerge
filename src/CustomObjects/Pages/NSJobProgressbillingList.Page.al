page 14021328 "NS_Job Progress Billing List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //CTSI-121.N.S.1.0 18Aug2020 Add field manager & person Responsible
    //PRJ-1085.RM.1.0 16Dec2021 | Added Page Help link
    //PRJ-1632.RM.1.0 28Sept2022 | Added some code 
    //PE-53.RM.1.0 07March2023 | Modifed values of some field.
    // PRJCTPR-246.HS.1.0 14Dec2023| Added field
    Caption = 'Job Progress Billing List';
    CardPageID = "NS_Progress Billing Header";
    DataCaptionFields = "NS_No.";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "NS_Progress Billing Header";
    //ContextSensitiveHelpPage = 'user-guide/progress-billing/progress-billings/'; //PRJ-1085.RM.1.0 16Dec2021

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';
                }
                field("Requisition No."; Rec."NS_Requisition No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Requisition No.';
                }
                field("Version No."; Rec."NS_Version No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Version No.';
                }
                field("Requisition Date"; Rec."NS_Requisition Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Requisition Date';
                }
                field("Period To"; Rec."NS_Period To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Period To';
                }
                field(Status; Rec.NS_Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Status';
                }
                field("Sales Document No."; Rec."NS_Sales Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Sales Document No.';
                }
                field(Final; Rec.NS_Final)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Final';
                    Visible = false;
                }
                //CTSI-121.N.S.1.0 18 Aug2020 Start
                field(Manager; Rec.NS_Manager)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the manager';
                }
                field("Person Responsible"; Rec."NS_Person Responsible")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the Person Responsible';
                }
                //CTSI-121.N.S.1.0 18 Aug2020 End
                // PRJ-1632.RM.1.0 start
                //PE-53.RM.1.0 07March2023 start
                field("NS_Billed Amount"; NS_BilledAmt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Billed Amount';
                    Caption = 'Billed Amount';
                }
                // field(NS_AmtDue; NS_AmtDue)
                // {
                //     Caption = 'Amount Due';
                //     ApplicationArea = all;
                //     ToolTip = 'Specify the Amount Due';
                // }
                //PE-53.RM.1.0 07March2023 end
                field(NS_Retention; NS_RetentionAmt) //PE-53.RM.1.0 07March2023
                {
                    Caption = 'Retention Amount';
                    ApplicationArea = All;
                    ToolTip = 'Specify the Retention';
                }
                //PE-53.RM.1.0 07March2023 start
                field(NS_AmtDue; NS_AmtDue)
                {
                    Caption = 'Net Amount';
                    ApplicationArea = all;
                    ToolTip = 'Specify the Amount Due';

                }
                field("NS_Balance Due"; NS_BalanceDue)
                {
                    Caption = 'Balance Due';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Balance Due';

                }
                //PE-53.RM.1.0 07March2023 end
                field("NS_Total Amt."; Rec."NS_Total Amt.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Total field.';
                }
                //PRJ-1632.RM.1.0 end
                //PE-53.RM.1.0 07March2023 start
                field(NS_Final; Rec.NS_Final)
                {
                    ApplicationArea = all;
                    ToolTip = 'Enable this boolean if the Retention% is reduced and further billing is done on same Progress Bill';
                }
                //PE-53.RM.1.0 07March2023 end

                // PRJCTPR-246.HS.1.0 14Dec2023 Start
                field("NS_Posted Sales Invoice No."; Rec."NS_Posted Sales Invoice No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted Sales Invoice No. field.';
                }
                // PRJCTPR-246.HS.1.0 14Dec2023 End
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Show Requisition")
            {
                ApplicationArea = All;
                Caption = 'Show Requisition';
                ToolTip = 'Show Requisition'; //PE-53.RM.1.0 07March2023
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "NS_Progress Billing Header";
                RunPageLink = "NS_No." = FIELD("NS_No."),
                              "NS_Requisition No." = FIELD("NS_Requisition No."),
                              "NS_Version No." = FIELD("NS_Version No.");
                RunPageView = SORTING("NS_No.", "NS_Requisition No.", "NS_Version No.");
            }
            separator(Separator1100773004)
            {
            }
            action(DeleteRequistion)
            {
                ApplicationArea = All;
                Caption = 'Delete Requistion';

                ToolTip = 'Delete Requistion';
                Image = Delete;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;

                trigger OnAction();
                begin
                    ProgressBillingManagement.NS_ProgressBillDelete("NS_No.", "NS_Requisition No.", "NS_Version No.");
                end;
            }
        }
    }

    trigger OnDeleteRecord(): Boolean;
    begin
        ProgressBillingManagement.NS_ProgressBillDelete(Rec."NS_No.", Rec."NS_Requisition No.", Rec."NS_Version No.");
    end;
    //PRJ-1632.RM.1.0 start
    trigger OnAfterGetRecord()
    var
        NS_CustLedEntry: Record "Cust. Ledger Entry";
        NS_SalesInvoiceHeader: Record "Sales Invoice Header";  //PE-53.RM.1.0 07March2023
    begin
        //PE-53.RM.1.0 07March2023 start
        if Rec."NS_R_Reduction & Invoicing" = false then begin
            // Rec.CalcFields("NS_Total Amt.");  //PE-53.RM.1.0 07March2023 commented
            NS_AmtDue := 0;
            NS_CustLedEntry.Reset();
            NS_CustLedEntry.SetRange("Document No.", Rec."NS_Posted Sales Invoice No.");
            NS_CustLedEntry.SetFilter("NS_Retention Ledger Code", '%1', 'NORMAL');
            if NS_CustLedEntry.Findset() then
                repeat

                    // NS_CustLedEntry.CalcFields("Remaining Amount"); 
                    NS_CustLedEntry.CalcFields("Amount (LCY)");
                    NS_AmtDue := NS_CustLedEntry."Amount (LCY)";
                    NS_RetentionAmt := NS_CustLedEntry."NS_Retention Amount (LCY)";
                    NS_BilledAmt := NS_CustLedEntry."Sales (LCY)";

                //PE-53.RM.1.0 07March2023 end
                until NS_CustLedEntry.Next() = 0;
            //PE-53.RM.1.0 07March2023 start
            NS_BalanceDue := 0;
            NS_CustLedEntry.Reset();
            NS_CustLedEntry.SetRange("Document No.", Rec."NS_Posted Sales Invoice No.");
            if NS_CustLedEntry.FindSet() then
                repeat
                    NS_CustLedEntry.CalcFields("Remaining Amt. (LCY)");
                    NS_BalanceDue += NS_CustLedEntry."Remaining Amt. (LCY)";
                until NS_CustLedEntry.Next() = 0;
            //PE-53.RM.1.0 07March2023 end
            //PE-53.RM.1.0 10March2023 start
        end else begin
            NS_AmtDue := 0;
            NS_BilledAmt := 0;
            NS_BalanceDue := 0;
            NS_RetentionAmt := 0;
            NS_SalesInvoiceHeader.RESET();
            NS_SalesInvoiceHeader.SetRange("NS_Job No.", Rec."NS_Job No.");
            NS_SalesInvoiceHeader.SetRange("NS_From Progress Billing No.", Rec."NS_Job No.");
            NS_SalesInvoiceHeader.SetRange("NS_From ProgressBillingReq.No.", Rec."NS_Requisition No.");
            NS_SalesInvoiceHeader.SetFilter(Cancelled, '%1', false);
            if NS_SalesInvoiceHeader.FindSet() then
                repeat
                    NS_SalesInvoiceHeader.CalcFields(Amount);
                    NS_BilledAmt += NS_SalesInvoiceHeader.Amount;
                    NS_BalanceDue := NS_BilledAmt;
                    NS_RetentionAmt := NS_SalesInvoiceHeader."NS_Retention Amount (LCY)";
                until NS_SalesInvoiceHeader.Next() = 0;
            NS_AmtDue := NS_BilledAmt - NS_RetentionAmt;
            //PE-53.RM.1.0 07March2023 end
        end;
        if Rec.NS_Status = Rec.NS_Status::Void then begin
            NS_AmtDue := 0;
            NS_RetentionAmt := 0;
            NS_BilledAmt := 0;
        end;
        //PE-53.RM.1.0 10March2023 end
    end;

    trigger OnAfterGetCurrRecord()
    var
        NS_CustLedEntry: Record "Cust. Ledger Entry";
        NS_SalesInvoiceHeader: Record "Sales Invoice Header";  //PE-53.RM.1.0 07March2023
    begin
        //PE-53.RM.1.0 07March2023
        if Rec."NS_R_Reduction & Invoicing" = false then begin
            // Rec.CalcFields("NS_Total Amt.");  //PE-53.RM.1.0 07March2023 commented
            NS_AmtDue := 0;
            NS_CustLedEntry.Reset();
            NS_CustLedEntry.SetRange("Document No.", Rec."NS_Posted Sales Invoice No.");
            NS_CustLedEntry.SetFilter("NS_Retention Ledger Code", '%1', 'NORMAL');
            if NS_CustLedEntry.Findset() then
                repeat

                    // NS_CustLedEntry.CalcFields("Remaining Amount"); 
                    NS_CustLedEntry.CalcFields("Amount (LCY)");
                    NS_AmtDue := NS_CustLedEntry."Amount (LCY)";
                    NS_RetentionAmt := NS_CustLedEntry."NS_Retention Amount (LCY)";
                    NS_BilledAmt := NS_CustLedEntry."Sales (LCY)";
                //PE-53.RM.1.0 07March2023 end
                until NS_CustLedEntry.Next() = 0;
            //PE-53.RM.1.0 07March2023 start
            NS_BalanceDue := 0;
            NS_CustLedEntry.Reset();
            NS_CustLedEntry.SetRange("Document No.", Rec."NS_Posted Sales Invoice No.");
            if NS_CustLedEntry.FindSet() then
                repeat
                    NS_CustLedEntry.CalcFields("Remaining Amt. (LCY)");
                    NS_BalanceDue += NS_CustLedEntry."Remaining Amt. (LCY)";
                until NS_CustLedEntry.Next() = 0;
            //PE-53.RM.1.0 07March2023 end
        end else begin

            NS_AmtDue := 0;
            NS_BilledAmt := 0;
            NS_BalanceDue := 0;
            NS_RetentionAmt := 0;
            NS_SalesInvoiceHeader.RESET();
            NS_SalesInvoiceHeader.SetRange("NS_Job No.", Rec."NS_Job No.");
            NS_SalesInvoiceHeader.SetRange("NS_From Progress Billing No.", Rec."NS_Job No.");
            NS_SalesInvoiceHeader.SetRange("NS_From ProgressBillingReq.No.", Rec."NS_Requisition No.");
            NS_SalesInvoiceHeader.SetFilter(Cancelled, '%1', false);
            if NS_SalesInvoiceHeader.FindSet() then
                repeat
                    NS_SalesInvoiceHeader.CalcFields(Amount);
                    NS_BilledAmt += NS_SalesInvoiceHeader.Amount;
                    NS_BalanceDue := NS_BilledAmt;
                    NS_RetentionAmt := NS_SalesInvoiceHeader."NS_Retention Amount (LCY)";
                until NS_SalesInvoiceHeader.Next() = 0;
            NS_AmtDue := NS_BilledAmt - NS_RetentionAmt;
            //PE-53.RM.1.0 07March2023 end
        end;
        if Rec.NS_Status = Rec.NS_Status::Void then begin
            NS_AmtDue := 0;
            NS_RetentionAmt := 0;
            NS_BilledAmt := 0;
        end;
        //PE-53.RM.1.0 10March2023 end
    end;
    //PRJ-1632.RM.1.0 end
    var
        ProgressBillingManagement: Codeunit "NS_Progress Billing Management";
        NS_AmtDue: Decimal;  //PRJ-1632.RM.1.0
        //PE-53.RM.1.0 07March2023 start
        NS_RetentionAmt: Decimal;
        NS_BalanceDue: Decimal;
        NS_BilledAmt: Decimal;
        NS_Amt: Decimal;
    //PE-53.RM.1.0 07March2023 end
}

