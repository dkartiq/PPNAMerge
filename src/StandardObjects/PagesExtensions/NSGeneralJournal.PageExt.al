pageextension 14021109 NS_GeneralJournal extends "General Journal"
{
    // version NAVW111.00.00.24232,NAVNA11.00.00.24232,PPNA11.00
    //PRJ-262.MS.1.0 added new field

    layout
    {
        addafter("Bal. Gen. Prod. Posting Group")
        {
            field("NS_Retention Ledger Code"; Rec."NS_Retention Ledger Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Retention Ledger No.';//PRJ-262.MS.1.0
            }
            field("NS_Bal. Ledger No."; Rec."NS_Bal. Ledger No.")
            {
                ToolTip = 'Specifies the Bal. Ledger No.';
                ApplicationArea = All;
            }
            field("NS_Job No."; Rec."Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';
            }
            field("NS_Retention Percent"; Rec."NS_Retention Percent")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Retention Percent';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    "NS_Retention Base Amount" := Amount;
                    "NS_Retention Amount" := ROUND("NS_Retention Base Amount" * ("NS_Retention Percent" / 100), 0.01);
                    //ProjectPro - end
                end;
            }
            field("NS_Retention Amount"; Rec."NS_Retention Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Retention Amount';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    "NS_Retention Base Amount" := Amount;
                    "NS_Retention Percent" := 0;
                    //ProjectPro - end
                end;
            }
            field("NS_Retention Amount (LCY)"; Rec."NS_Retention Amount (LCY)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Retention Amount (LCY)';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    if ("NS_Retention Amount" <> 0) and ("NS_Retention Date" = 0D) then
                        ERROR(Text14021100);
                    //ProjectPro - end
                end;
            }
            field("NS_Retention Date"; Rec."NS_Retention Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Retention Date';
            }
            field("NS_Draw No."; Rec."NS_Draw No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Draw No.';
            }
            field("NS_Posting Group"; Rec."Posting Group")
            {
                ApplicationArea = All;
                Description = 'PRJ-262.MS.1.0';
            }
        }
    }
    actions
    {
        //addafter("Insert Conv. LCY Rndg. Lines")
        addafter("Insert Conv. LCY Rndg. Lines")
        {
            action(NS_PAYCHEXGLPayrollImport)
            {
                ApplicationArea = All;
                Caption = 'Advanced Payroll Import';
                RunObject = XMLport "NS_PAYCHEX GL Payroll Import";
            }
        }
    }

    var
        Text14021100: Label 'A Retention Date must be entered when a Retention Amount exists.';

    /* Documentation
    +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     Bal. Ledger No.
      +     Job No.
      +     Retention Percent
      +     Retention Amount
      +     Retention Amount (LCY)
      +     Retention Date
      +     Draw No.
      +
      +  - Added global text constant(s):
      +     Text14021100
      +
      +  - Modification(s):
      +     - Added action list:
      +         Advanced Payroll Import
      +-----------------------------------------------------------------------------------------------
    */

}

