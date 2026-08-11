pageextension 14021457 NS_GLEntriesDimOverMatrix extends "G/L Entries Dim. Overv. Matrix"
{
    // version NAVW111.00.00.19846,PPNA11.00

    actions
    {
        modify("<Action16>")
        {
            Visible = false;
            Enabled = false;
        }
        addafter("<Action16>")
        {
            action(NS_Action16)
            {
                Caption = 'Navigate';
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
                ApplicationArea = Suite;
                Image = Navigate;
                trigger OnAction();
                begin
                    //ProjectPro - start
                    //Navigate.SetDoc("Posting Date","Document No.");
                    Navigate.SetDocLedger("NS_Retention Ledger Code", "Posting Date", "Document No.");
                    //ProjectPro - end
                    Navigate.RUN;
                end;
            }
        }
    }

    var
        Navigate: Page 344;

    /*
      +------------------------------------------------------------
      +ProjectPro
      +  - Modification(s):
      +     - Call Navigate (Page Action) with Retention Ledger Code parameter
      + -SMP
      +  -Rewritten Actions
      +   -<Action16>
      +------------------------------------------------------------
    */
}

