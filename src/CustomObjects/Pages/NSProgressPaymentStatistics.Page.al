page 14021346 "NS_Progress Payment Statistics"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    PageType = CardPart;
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
        NS_GetChangeOrderValues("NS_Job No.",
                             NS_GetPeriodFromDate("NS_No.", "NS_Period To"), "NS_Period To",
                             PreviousAdditions, PreviousDeductions,
                             CurrentAdditions, CurrentDeductions);

        NetChanges := PreviousAdditions - PreviousDeductions + CurrentAdditions - CurrentDeductions;
        ContractBase := NS_ProgressPayBaseAmount(Rec);
        ContractTotal := ContractBase + NetChanges;

        PaymentValue := 0;
        CompStored := 0;
        with ProgressPaymentLine do begin
            RESET;
            ProgressPaymentLine.SETRANGE("NS_Progress Payment No.", Rec."NS_No.");
            SETRANGE("NS_Requisition No.", Rec."NS_Requisition No.");
            SETRANGE("NS_Version No.", Rec."NS_Version No.");
            if FINDSET then
                repeat
                    CompStored := PaymentValue + ProgressPaymentLine."NS_Work Amount" + ProgressPaymentLine."NS_Stored Materials Amount";
                    PaymentValue := PaymentValue + ProgressPaymentLine."NS_Work Amount" + ProgressPaymentLine."NS_Stored Materials Amount" +
                                    ProgressPaymentLine.NS_LastTotal(ProgressPaymentLine);
                until NEXT = 0;
        end;

        CompStored := PaymentValue;
        Earned := PaymentValue - "NS_Total Retention";
        PaymentValue := Earned - NS_ProgressPayPreviousInvoice(Rec);
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

