pageextension 14021143 NS_PostedSalesInvoice extends "Posted Sales Invoice"
{
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,NAVMX11.00.00.23572,PPNA11.00
    //CTSI-42.AS.1.0 21MAY2020  Added action "Sales Invoice - Rev. Cat. Summ."
    //CTSI-150.AS.1.0 28Sept2020 Added field
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
        }
        addafter("Foreign Trade")
        {
            group("NS_Retention")
            {
                Caption = 'Retention';
                field("NS_Retention Base Amount"; Rec."NS_Retention Base Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Retention Base Amount';
                }
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
                Caption = 'Sales Invoice - Rev. Cat. Summ.';
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
    }
    //CTSI-42.AS.1.0 21MAY2020 - end

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

