page 14021372 "NS_Progress Payment Stats. New"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-1131.NK.1.0 10Jan2022 | Removed with statement
    //PRJCTPR-292.HS.1.0 17Jan2024 | Created New Page With PageType = card
    PageType = Card;
    Caption = 'Progress Payment Statistics';
    SourceTable = "NS_Progress Payment Header";
    UsageCategory = Documents;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(ContractBase; ContractBase)
                {
                    ApplicationArea = All;
                    Caption = 'Original Contract Total';
                    ToolTip = 'Original Contract Total';

                    Editable = false;
                }
                field(NetChanges; NetChanges)
                {
                    ApplicationArea = All;
                    Caption = 'Net Contract Changes';
                    ToolTip = 'Net Contract Changes';

                    Editable = false;
                }
                field("ContractBase + NetChanges"; ContractBase + NetChanges)
                {
                    ApplicationArea = All;
                    Caption = 'Current Contract Total';
                    ToolTip = 'Current Contract Total';

                    Editable = false;
                }
                field(CompStored; CompStored)
                {
                    ApplicationArea = All;
                    Caption = 'Completed && Stored';
                    ToolTip = 'Completed && Stored';

                    Editable = false;
                }
                field("-(Earned - CompStored)"; -(Earned - CompStored))
                {
                    ApplicationArea = All;
                    Caption = 'Total Retention';
                    ToolTip = 'Total Retention';

                    Editable = false;
                }
                field(Earned; Earned)
                {
                    ApplicationArea = All;
                    Caption = 'Earned';
                    ToolTip = 'Earned';

                    Editable = false;
                }
                field("-(PaymentValue - Earned)"; -(PaymentValue - Earned))
                {
                    ApplicationArea = All;
                    Caption = 'Previous Certificates';

                    ToolTip = 'Previous Certificates';
                    Editable = false;
                }
                field(PaymentValue; PaymentValue)
                {
                    ApplicationArea = All;
                    Caption = 'Current Billing Value';

                    ToolTip = 'Current Billing Value';
                    Editable = false;
                }
                field("ContractBase + NetChanges - Earned"; ContractBase + NetChanges - Earned)
                {
                    ApplicationArea = All;
                    Caption = 'Balance To Finish';

                    ToolTip = 'Balance To Finish';
                    Editable = false;
                }
            }
            group(Changes)
            {
                Caption = 'Changes';
                fixed(Control1907809801)
                {
                    group(Additions)
                    {
                        Caption = 'Additions';
                        field(PreviousAdditions; PreviousAdditions)
                        {
                            ApplicationArea = All;
                            Caption = 'Previous';

                            ToolTip = 'Previous';
                            Editable = false;
                        }
                        field(CurrentAdditions; CurrentAdditions)
                        {
                            ApplicationArea = All;
                            Caption = 'Current';

                            ToolTip = 'Current';
                            Editable = false;
                        }
                        field("Net Changes"; NetChanges)
                        {
                            ApplicationArea = All;
                            Caption = 'Net Changes';

                            ToolTip = 'Net Changes';
                            Editable = false;
                        }
                    }
                    group(Deductions)
                    {
                        Caption = 'Deductions';
                        field(PreviousDeductions; PreviousDeductions)
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field(CurrentDeductions; CurrentDeductions)
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        Rec.NS_GetChangeOrderValues(Rec."NS_Job No.", //PRJ-1131.NK.1.0
                             Rec.NS_GetPeriodFromDate(Rec."NS_No.", Rec."NS_Period To"), Rec."NS_Period To", //PRJ-1131.NK.1.0
                             PreviousAdditions, PreviousDeductions,
                             CurrentAdditions, CurrentDeductions);

        NetChanges := PreviousAdditions - PreviousDeductions + CurrentAdditions - CurrentDeductions;
        ContractBase := Rec.NS_ProgressPayBaseAmount(Rec); //PRJ-1131.NK.1.0
        ContractTotal := ContractBase + NetChanges;

        PaymentValue := 0;
        CompStored := 0;
        //PRJ-1131.NK.1.0 Start
        //with ProgressPaymentLine do begin
        ProgressPaymentLine.RESET();
        ProgressPaymentLine.SETRANGE("NS_Progress Payment No.", Rec."NS_No.");
        ProgressPaymentLine.SETRANGE("NS_Requisition No.", Rec."NS_Requisition No.");
        ProgressPaymentLine.SETRANGE("NS_Version No.", Rec."NS_Version No.");
        if ProgressPaymentLine.FINDSET() then
            repeat
                CompStored := PaymentValue + ProgressPaymentLine."NS_Work Amount" + ProgressPaymentLine."NS_Stored Materials Amount";
                PaymentValue := PaymentValue + ProgressPaymentLine."NS_Work Amount" + ProgressPaymentLine."NS_Stored Materials Amount" +
                                ProgressPaymentLine.NS_LastTotal(ProgressPaymentLine);
            until ProgressPaymentLine.NEXT() = 0;
        //end;
        //PRJ-1131.NK.1.0 End
        CompStored := PaymentValue;
        Earned := PaymentValue - Rec."NS_Total Retention"; //PRJ-1131.NK.1.0
        PaymentValue := Earned - Rec.NS_ProgressPayPreviousInvoice(Rec); //PRJ-1131.NK.1.0
    end;

    var
        ProgressPaymentLine: Record "NS_Progress Payment Line";
        ContractTotal: Decimal;
        CompStored: Decimal;
        Earned: Decimal;
        PaymentValue: Decimal;
        PreviousAdditions: Decimal;
        PreviousDeductions: Decimal;
        CurrentAdditions: Decimal;
        CurrentDeductions: Decimal;
        NetChanges: Decimal;
        ContractBase: Decimal;
}

