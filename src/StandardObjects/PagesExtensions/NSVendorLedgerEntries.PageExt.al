pageextension 14021107 NS_VendorLedgerEntries extends "Vendor Ledger Entries"
{
    // version NAVW111.00.00.24232,NAVNA11.00.00.24232,PPNA11.00

    layout
    {
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
            field("NS_Subcontract No."; Rec."NS_Subcontract No.")
            {
                Editable = false;
                ToolTip = 'Specifies the Subcontract No.';
                ApplicationArea = All;
            }
            field("NS_Draw No."; Rec."NS_Draw No.")
            {
                Editable = false;
                ToolTip = 'Specifies the Draw No.';
                ApplicationArea = All;
            }
            field("NS_Lien Release Print Status"; Rec."NS_Lien Release Print Status")
            {
                Editable = true;
                ToolTip = 'Specifies the Lien Release Print Status';
                ApplicationArea = All;
            }
            field("NS_Lien Release Signed Date"; Rec."NS_Lien Release Signed Date")
            {
                Editable = true;
                ApplicationArea = All;
                ToolTip = 'Specifies the Lien Release Signed Date';
            }
            field("NS_Lien Release Type"; Rec."NS_Lien Release Type")
            {
                Editable = true;
                ApplicationArea = All;
                ToolTip = 'Specifies the Lien Release Type';
            }
            //PRJ-490.AM.1.0 Start
            field("NS_FA Job No."; "NS_FA Job No.")
            {
                ApplicationArea = all;
                Caption = 'FA Job No.';
                Editable = false;
            }
            field("NS_FA Job Task No."; "NS_FA Job Task No.")
            {
                ApplicationArea = all;
                Caption = ' FA Job Task No.';
                Editable = false;
            }
            field("NS_FA Segment Code"; "NS_FA Segment Code")
            {
                ApplicationArea = all;
                Caption = 'FA Segment Code';
                Editable = false;
            }
            //PRJ-490.AM.1.0 End
        }
        //PPDA.1.0.TBA Start
        // addafter("IRS 1099 Amount")
        // {
        //     field("NS_Retention Base Amount"; Rec."NS_Retention Base Amount")
        //     {
        //         Editable = false;
        //         ApplicationArea = All;
        //         ToolTip = 'Specifies the Retention Base Amount';
        //     }
        //     field("NS_Retention Percent"; Rec."NS_Retention Percent")
        //     {
        //         Editable = false;
        //         ApplicationArea = All;
        //         ToolTip = 'Specifies the Retention Percent';
        //     }
        //     field("NS_Retention Amount (LCY)"; Rec."NS_Retention Amount (LCY)")
        //     {
        //         Editable = false;
        //         ApplicationArea = All;
        //         ToolTip = 'Specifies the Retention Amount (LCY)';
        //     }
        //     field("NS_Retention Amount"; Rec."NS_Retention Amount")
        //     {
        //         Editable = false;
        //         ApplicationArea = All;
        //         ToolTip = 'Specifies the Retention Amount';
        //     }
        //     field("NS_Retention Date"; Rec."NS_Retention Date")
        //     {
        //         Editable = false;
        //         ApplicationArea = All;
        //         ToolTip = 'Specifies the Retention Date"1';
        //     }
        // }
        //PPDA.1.0.TBA End
    }
    actions
    {
        addafter(IncomingDocAttachFile)
        {
            action("NS_Print Lien Release")
            {
                Caption = 'Print Lien Release';
                Image = PrintChecklistReport;
                ApplicationArea = All;
                ToolTip = 'Print Lien Release';

                trigger OnAction();
                var
                    NS_JobsSetup: Record "Jobs Setup";
                    LienRelease: Report "NS_Lien Release 01";
                    VLE: Record "Vendor Ledger Entry";//PRJ-290.AS.1.0 27AUG20
                begin
                    //ProjectPro - start
                    //LienRelease.InitVariables(Rec);
                    //LienRelease.RUNMODAL;
                    //PRJ-290.AS.1.0 27AUG20 - start
                    CurrPage.SETSELECTIONFILTER(VLE); // fetch the marks
                                                      // internally property Marked is set to true at the selected records
                                                      // the loop will fetch only these records
                    REPORT.RUNMODAL(14021302, TRUE, FALSE, VLE);
                    //PRJ-290.AS.1.0 27AUG20 - end
                    //ProjectPro - end
                end;
            }
        }
        modify("&Navigate")
        {
            Visible = false;
        }
        addafter("NS_Print Lien Release")
        {
            action(NS_Navigate)
            {
                Caption = 'Navigate';
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
                ApplicationArea = Basic, Suite;
                Promoted = true;
                Image = Navigate;
                PromotedCategory = Process;
                Scope = "Repeater";
                trigger OnAction();
                begin
                    //ProjectPro - start
                    //Navigate.SetDoc("Posting Date","Document No.");
                    Navigate.SetDocLedger("NS_Retention Ledger Code", Rec."Posting Date", Rec."Document No.");
                    Navigate.RUN;
                    //ProjectPro - end
                end;
            }
        }
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
      +     Subcontract No.
      +     Draw No.
      +     Lien Release Print Status
      +     Lien Release Signed Date
      +     Lien Release Type
      +     Retention Base Amount
      +     Retention Percent
      +     Retention Amount (LCY)
      +     Retention Amount
      +     Retention Date
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +     - Added action list:
      +         PP Print Lien Release
      +
      +     - Modify action list:
      +         Navigate - OnAction - Modified call to Navigate.SetDoc to call Navigate.SetDocLedger
      +
      + -SMP
      +  -Rewritten Actions
      +   -&Navigate
      +-----------------------------------------------------------------------------------------------
      */
}

