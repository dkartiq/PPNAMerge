page 14021331 "NS_Progress Billing Statistics"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    PageType = Card;
    Caption = 'Progress Billing Statistics';
    SourceTable = "NS_Progress Billing Header";
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
                    Editable = false;
                }
                field(NetChanges; NetChanges)
                {
                    ApplicationArea = All;
                    Caption = 'Net Contract Changes';
                    Editable = false;
                }
                field("ContractBase + NetChanges"; ContractBase + NetChanges)
                {
                    ApplicationArea = All;
                    Caption = 'Current Contract Total';
                    Editable = false;
                }
                field(CompStored; CompStored)
                {
                    ApplicationArea = All;
                    Caption = 'Completed && Stored';
                    Editable = false;
                }
                field("-(Earned - CompStored)"; -(Earned - CompStored))
                {
                    ApplicationArea = All;
                    Caption = 'Total Retention';
                    Editable = false;
                }
                field(Earned; Earned)
                {
                    ApplicationArea = All;
                    Caption = 'Earned';
                    Editable = false;
                }
                field("-(BillingValue - Earned)"; -(BillingValue - Earned))
                {
                    ApplicationArea = All;
                    Caption = 'Previous Certificates';
                    Editable = false;
                }
                field(BillingValue; BillingValue)
                {
                    ApplicationArea = All;
                    Caption = 'Current Billing Value';
                    Editable = false;
                }
                field("ContractBase + NetChanges - Earned"; ContractBase + NetChanges - Earned)
                {
                    ApplicationArea = All;
                    Caption = 'Balance To Finish';
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
                            Editable = false;
                        }
                        field(CurrentAdditions; CurrentAdditions)
                        {
                            ApplicationArea = All;
                            Caption = 'Current';
                            Editable = false;
                        }
                        field("Net Changes"; NetChanges)
                        {
                            ApplicationArea = All;
                            Caption = 'Net Changes';
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
        ContractBase := NS_ProgressBillBaseAmount(Rec);
        ContractTotal := ContractBase + NetChanges;

        BillingValue := 0;
        CompStored := 0;
        //with ProgressBillingLine do begin
        ProgressBillingLine.RESET();
        ProgressBillingLine.SetRange("NS_Progress Billing No.", Rec."NS_No.");
        SETRANGE("NS_Requisition No.", Rec."NS_Requisition No.");
        SETRANGE("NS_Version No.", Rec."NS_Version No.");
        if FINDSET then
            repeat
                CompStored := BillingValue + ProgressBillingLine."NS_Work Amount" + ProgressBillingLine."NS_Stored Materials Amount";
                BillingValue := BillingValue + ProgressBillingLine."NS_Work Amount" + ProgressBillingLine."NS_Stored Materials Amount" +
                                ProgressBillingLine.NS_LastTotal(ProgressBillingLine);
            until NEXT = 0;
        //end;

        CompStored := BillingValue;
        Earned := BillingValue - "NS_Total Retention";
        BillingValue := Earned - NS_ProgressBillPreviousInvoice(Rec);
    end;

    var
        ProgressBillingLine: Record "NS_Progress Billing Line";
        ContractTotal: Decimal;
        CompStored: Decimal;
        Earned: Decimal;
        BillingValue: Decimal;
        PreviousAdditions: Decimal;
        PreviousDeductions: Decimal;
        CurrentAdditions: Decimal;
        CurrentDeductions: Decimal;
        NetChanges: Decimal;
        ContractBase: Decimal;
}

