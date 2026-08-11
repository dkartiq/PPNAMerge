pageextension 14021236 NS_CashRcptJournalExt extends "Cash Receipt Journal"
{
    // version NAVW111.00.00.24232,NAVNA11.00.00.24232,NSNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Cash Receipt Journals'; //PRJ-1330.NK.1.0 25Apr2022
    //ZEL-6 Dk.1.0 23March2023 | Add  field NS_Retention Ledger Code,Job No,Job Task No
    layout
    {
        addafter("Bal. Account No.")
        {
            field("NS Bal. Ledger No."; Rec."NS_Bal. Ledger No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Bal. Ledger No.';
            }
        }
        addafter("Applies-to ID")
        {
            field("NS Retention Percent"; Rec."NS_Retention Percent")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Retention Percent';
                Visible = false;

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    if "NS_Retention Percent" = 0 then begin
                        if ("NS_Retention Amount (LCY)" = 0) and ("NS_Retention Amount" = 0) then
                            "NS_Retention Date" := 0D;
                    end else begin
                        "NS_Retention Amount (LCY)" := ROUND("NS_Retention Base Amount" * ("NS_Retention Percent" / 100), NS_GLSetup."Amount Rounding Precision");
                        if "NS_Retention Date" = 0D then
                            "NS_Retention Date" := CALCDATE('+ 1Y', "Posting Date");
                    end;
                    CurrPage.UPDATE;
                    //ProjectPro - end
                end;
            }
            field("NS Retention Amount (LCY)"; Rec."NS_Retention Amount (LCY)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Retention Amount (LCY)';
                Visible = false;

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    "NS_Retention Percent" := 0;
                    if ("NS_Retention Amount (LCY)" <> 0) and ("NS_Retention Date" = 0D) then
                        "NS_Retention Date" := CALCDATE('+1Y ', "Posting Date");
                    CurrPage.UPDATE;
                    //ProjectPro - end
                end;
            }
            field("NS Retention Amount"; Rec."NS_Retention Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Retention Amount';
                Visible = false;

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    "NS_Retention Percent" := 0;
                    if ("NS_Retention Amount" <> 0) and ("NS_Retention Date" = 0D) then
                        "NS_Retention Date" := CALCDATE('+1Y ', "Posting Date");
                    CurrPage.UPDATE;
                    //ProjectPro - end
                end;
            }
            field("NS Retention Date"; Rec."NS_Retention Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Retention Date';
                Visible = false;
            }
        }
        //ZEL-6 Dk.1.0 23March2023 Start
        addafter("NS Bal. Ledger No.")
        {
            field("NS_Retention Ledger Code"; Rec."NS_Retention Ledger Code")
            {
                ToolTip = 'Specifies the Retention Ledger Code';
                ApplicationArea = All;

            }
        }
        addafter("Account No.")
        {
            field("NSJob No."; Rec."Job No.")
            {
                ToolTip = 'Specifies the Job No.';
                ApplicationArea = All;
            }
            field("NSJob Task No."; Rec."Job Task No.")
            {
                ToolTip = 'Specifies the Job Task No.';
                ApplicationArea = All;
            }
        }
        //ZEL-6 Dk.1.0 23March2023 End

        //PE-200.AS.11.0 START
        addafter("NSJob No.")
        {
            field("NS_Draw No."; Rec."NS_Draw No.")
            {
                ToolTip = 'Specifies the Draw No.';
                ApplicationArea = All;
            }
        }
        //PE-200.AS.11.0 END
    }
    var
        NS_GLSetup: Record "General Ledger Setup";
}