pageextension 14021104 NS_CustomerLedgerEntries extends "Customer Ledger Entries"
{
    // version NAVW111.00.00.24232,NAVNA11.00.00.24232,PPNA11.00

    layout
    {
        modify("Reason Code")
        {
            Visible = false;
            Enabled = false;

        }
        addafter("Source Code")
        {
            field("NS_ReasonCode"; Rec."Reason Code")
            {
                ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the entry.';
                ApplicationArea = Advanced;
                Caption = 'Reason Code';
                Editable = false;
                Visible = false;
            }
        }
        addafter("Global Dimension 2 Code")
        {
            field("NS_Retention Ledger Code"; Rec."NS_Retention Ledger Code")
            {
                ToolTip = 'Specifies the Retention Ledger Code';
                ApplicationArea = All;
            }
        }
        addafter("Bal. Account No.")
        {
            field("NS_Bal. Ledger No."; Rec."NS_Bal. Ledger No.")
            {
                Editable = false;
                ToolTip = 'Specifies the Bal. Ledger No.';
                ApplicationArea = All;
            }
        }
        addafter("On Hold")
        {
            field("NS_Job No."; Rec."NS_Job No.")
            {
                Editable = false;
                ToolTip = 'Specifies the Job No.';
                ApplicationArea = All;
            }
        }
        addafter("Reason Code")
        {
            field("NS_Retention Base Amount"; Rec."NS_Retention Base Amount")
            {
                Editable = false;
                ToolTip = 'Specifies the Retention Base Amount';
                ApplicationArea = All;
            }
            field("NS_Retention Percent"; Rec."NS_Retention Percent")
            {
                Editable = false;
                ToolTip = 'Specifies the Retention Percent';
                ApplicationArea = All;
            }
            field("NS_Retention Amount LCY"; Rec."NS_Retention Amount (LCY)")
            {
                Editable = false;
                ToolTip = 'Specifies the Retention Amount (LCY)';
                ApplicationArea = All;
            }
            field("NS_Retention Amount"; Rec."NS_Retention Amount")
            {
                Editable = false;
                ToolTip = 'Specifies the Retention Amount';
                ApplicationArea = All;
            }
            field("NS_Retention Date"; Rec."NS_Retention Date")
            {
                Editable = false;
                ToolTip = 'Specifies the Retention Date';
                ApplicationArea = All;
            }
            field("NS_Retention Document"; Rec."NS_Retention Document")
            {
                Editable = false;
                ToolTip = 'Specifies the Retention Document';
                ApplicationArea = All;
            }
        }
    }
    actions
    {

        modify("&Navigate")
        {
            Visible = false;
        }
        //PPDA.1.0.TBA Start
        // addafter("&Cancel")
        // {
        //     action("NS_Navigate")
        //     {
        //         Caption = 'Navigate';
        //         ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
        //         ApplicationArea = Basic, Suite;
        //         Promoted = true;
        //         Image = Navigate;
        //         PromotedCategory = Process;
        //         Scope = "Repeater";
        //         trigger OnAction();
        //         begin
        //             //ProjectPro - start
        //             //Navigate.SetDoc("Posting Date","Document No.");
        //             Navigate.SetDocLedger("NS_Retention Ledger Code", "Posting Date", "Document No.");
        //             Navigate.RUN;
        //             //ProjectPro - end
        //         end;
        //     }
        // }
        //PPDA.1.0.TBA End
    }
    var
        Navigate: Page 344;

    /*
    +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     Retention Ledger Code
      +     Bal. Ledger No.
      +     Job No.
      +     Retention Base Amount
      +     Retention Percent
      +     Retention Amount (LCY)
      +     Retention Amount
      +     Retention Date
      +     Retention Document
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +     - Modified action list:
      +         Detailed Ledger Entries - RunPageLink - Added field Initial Entry Global Dim. 2
      +         Navigate                - OnAction - Modified call to Navigate.SetDoc to call Navigate.SetDocLedger
      +
      + -SMP
      +  -Rewritten Actions
      +   -&Navigate
      +  -Rewritten Fields
      +   -Reason Code
      +-----------------------------------------------------------------------------------------------
      */
}

