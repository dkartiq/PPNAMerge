pageextension 14021253 NS_PurchOrderStats extends "Purchase Order Statistics"
{
    // version NAVW111.00,PPNA11.00
    //PRJ-659.RS.1.0 17June21 | NS_ should be removed from every page rest mention the page ID and Name.

    layout
    {
        addafter("TotalInclVAT_General")
        {
            field("NS Retention Amount (LCY)"; Rec."NS_Retention Amount (LCY)")
            {
                ApplicationArea = All;
                AutoFormatType = 1;
                Editable = false;
                ToolTip = 'Specifies the Retention Amount (LCY)';
            }
            field("NS Final Total"; NS_FinalTotal)
            {
                ApplicationArea = All;
                AutoFormatType = 1;
                Caption = 'Final Total';

                ToolTip = 'Final Total';
                Editable = false;
            }
        }
        addafter("TotalInclVAT_Invoicing")
        {
            field("NS Retention Amount LCY"; NS_RetentionAmt[2])
            {
                Caption = 'Retention Amount LCY';//PRJ-659.RS.1.0 17June21
                ApplicationArea = All;
                AutoFormatType = 1;
                Editable = false;
                ToolTip = 'Specifies the retention amount.';
            }
        }
        addafter("TotalInclVAT_Shipping")
        {
            field("NS Retention Amount [LCY]"; NS_RetentionAmt[3])
            {
                Caption = 'Retention Amount [LCY]';//PRJ-659.RS.1.0 17June21
                ApplicationArea = All;
                AutoFormatType = 1;
                Editable = false;
                ToolTip = 'Specifies the retention amount.';
            }
        }
        addafter("Vend.""Balance (LCY)""")
        {
            field("NS Retention Balance LCY"; NS_RetentionBalanceLCY)
            {
                ApplicationArea = All;
                AutoFormatType = 1;
                Caption = 'Retention Balance ($)';
                Editable = false;
            }
        }
    }

    var
        JobsSetup: Record "Jobs Setup";

    var
        NS_JobsSetup: Record "Jobs Setup";
        NS_RetentionBalanceLCY: Decimal;
        NS_FinalTotal: Decimal;
        NS_RetentionAmt: array[3] of Decimal;
        NS_PurchaseLine: Record "Purchase Line";
        NS_GLSetup: Record "General Ledger Setup";
        NS_Vend: Record Vendor;
        PurchSetup: Record "Purchases & Payables Setup";

    trigger OnOpenPage()
    begin
        PurchSetup.GET;
        //ProjectPro - start
        NS_JobsSetup.GET;
        //ProjectPro - end
    end;


    trigger OnAfterGetRecord()
    begin
        NS_RefreshOnAfterGetRecord();
    end;

    local procedure NS_RefreshOnAfterGetRecord()
    var
        Totals1: Decimal; //PRJ-NA.SK.1.0 Changed the datatype from Text to Decimal
        Totals2: decimal; //PRJ-NA.SK.1.0 Changed the datatype from Text to Decimal
        TotalAmount1: array[3] of Decimal;
        TotalAmount2: array[3] of Decimal;
    begin



        TotalAmount1[1] := Totals1;
        TotalAmount1[2] := Totals1;
        TotalAmount1[3] := Totals1;

        TotalAmount2[1] := Totals2;
        TotalAmount2[2] := Totals2;
        TotalAmount2[3] := Totals2;


        //ProjectPro - start
        //IF Vend.GET("Pay-to Vendor No.") THEN
        //  Vend.CALCFIELDS("Balance (LCY)")
        //ELSE
        IF NS_Vend.GET("Pay-to Vendor No.") THEN BEGIN
            IF "NS_Retention Percent" <> 0 THEN BEGIN
                VALIDATE("NS_Retention Percent");
                VALIDATE("NS_Retention Date");
            END ELSE
                IF "NS_Retention Amount (LCY)" <> 0 THEN BEGIN
                    VALIDATE("NS_Retention Amount (LCY)");
                    VALIDATE("NS_Retention Date");
                END;
            NS_RetentionBalanceLCY := 0;
            IF NOT PurchSetup."NS_Purchase Retention Inactive" THEN BEGIN
                NS_Vend.SETRANGE("NS_Retention Ledger CodeFilter", NS_JobsSetup."NS_Retention Payable Ledger");
                NS_Vend.CALCFIELDS("Balance (LCY)");
                NS_RetentionBalanceLCY := NS_Vend."Balance (LCY)";
                NS_Vend.SETRANGE("NS_Retention Ledger CodeFilter", PurchSetup."NS_Normal Vendor Ledger No.");
            END;
            NS_RetentionAmt[1] := "NS_Retention Amount (LCY)";
            IF "NS_Retention Percent" <> 0 THEN BEGIN
                JobsSetup.GET;
                IF JobsSetup."NS_Calc Payable Ret Before Tax" THEN BEGIN
                    NS_RetentionAmt[2] := TotalAmount1[2] * ("NS_Retention Percent" / 100);
                    NS_RetentionAmt[3] := TotalAmount1[3] * ("NS_Retention Percent" / 100);
                END ELSE BEGIN
                    NS_RetentionAmt[2] := TotalAmount2[2] * ("NS_Retention Percent" / 100);
                    NS_RetentionAmt[3] := TotalAmount2[3] * ("NS_Retention Percent" / 100);
                END;
            END;

            //Adjust General Retention on a Subcontract Purchase Order
            IF "NS_Subcontract No." > '' THEN
                //Note:  This will not be accurate if there are detail lines that are not part of applied retention.
                //       The problem is that the taxable amount field gets changed during value entry causing
                //       NS_PurchaseLine."Amount Including VAT" to be incorrect.  Larger modifications are needed to develop
                //       this value working in a taxable and partial subcontract area.
                NS_RetentionAmt[1] := ROUND(TotalAmount2[1] * ("NS_Retention Percent" / 100), NS_GLSetup."Amount Rounding Precision");

            NS_Vend.CALCFIELDS("Balance (LCY)")
        END ELSE
            //ProjectPro - end
            CLEAR(NS_Vend);
        NS_FinalTotal := TotalAmount2[1] - NS_RetentionAmt[1];
    end;
}

// +---------------------------------------------------------------------------------------------
// +ProjectPro
// +  - Added field(s):
// +     General - Group
// +       PP Retention Amount (LCY)
// +       PP Final Total
// +     Invoicing - Group
// +       PP Retention Balance LCY
// +     Shipping - Group
// +       PP Retention Amount [LCY]
// +     Vendor - Group
// +       PP Retention Amount LCY
// +
// +  - Added function(s):
// +
// +  - Added global variable(s):
// +     PP_JobsSetup
// +     PP_RetentionBalanceLCY
// +     PP_FinalTotal
// +     PP_RetentionAmt - ARRAY [3]
// +     PP_PurchaseLine
// +     PP_GLSetup
// +
// +  - Added global text constant(s):
// +
// +  - Modification(s):
// +     - OnOpenPage - Read PP_JobsSetup record
// +     - RefreshOnAfterGetRecord - Updated RefreshOnAfterGetRecord function to display
// +                                     Retention information correctly based on Qty. to Invoice
// +                                           Set values for -
// +                                               Retention Percent
// +                                               Retention Amount (LCY)
// +                                               Retention Amount
// +                                               Retention Date
// +                                               Retention Balance (LCY)
// +                                               Final Total
// +                                               PP_FinalTotal
// +                                           Call UpdateHeaderInfo routine
// +-----------------------------------------------------------------------------------------------