pageextension 14021235 NS_PurchaseJournal extends "Purchase Journal"
{
    // version NAVW111.00.00.24232,NAVNA11.00.00.24232,PPNA11.00

    layout
    {
        addafter("Bal. Account No.")
        {
            field("NS Bal. Ledger No."; "NS_Bal. Ledger No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Bal. Ledger No.';
            }
        }
        addafter("Ship-to/Order Address Code")
        {
            field("NS Job No."; Rec."Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';
            }
            field("NS Subcontract No."; Rec."NS_Subcontract No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Subcontract No.';
            }
        }
        addafter("On Hold")
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
                            "NS_Retention Date" := CALCDATE('+1Y', "Posting Date");
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
                        "NS_Retention Date" := CALCDATE('+1Y', "Posting Date");
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
                        "NS_Retention Date" := CALCDATE('+1Y', "Posting Date");
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
    }

    var
        NS_GLSetup: Record "General Ledger Setup";

    trigger OnOpenPage();
    begin
        //ProjectPro - start
        NS_GLSetup.GET;
        //ProjectPro - end    
    end;

    //   +---------------------------------------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +     NS Bal. Ledger No.
    //   +     NS Job No.
    //   +     NS Subcontract No.
    //   +     NS Retention Percent
    //   +     NS Retention Amount (LCY)
    //   +     NS Retention Amount
    //   +     NS Retention Date
    //   +
    //   +  - Added function(s):
    //   +
    //   +  - Added global variable(s):
    //   +     PP_GLSetup
    //   +
    //   +  - Added global text constant(s):
    //   +
    //   +  - Modification(s):
    //   +     - OnOpenPage - Read General Ledger Setup record
    //   +
    //   +     - OnAfterGetRecord - Field Calculations
    //   +
    //   +     - Added action list:
    //   +
    //   +     - Modify action list:
    //   +
    //   +     - Modified controls:
    //   +
    //   +     - Menus:
    //   +
    //   +-----------------------------------------------------------------------------------------------

}

