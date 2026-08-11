pageextension 14021272 NS_DetailedCustLedgEntries extends "Detailed Cust. Ledg. Entries"
{
    // version NAVW111.00.00.24232,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Detailed Customer Ledger Entries'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        addfirst(Control1)
        {
            field("NS_Job No."; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';
            }
        }
        addafter("Initial Entry Global Dim. 2")
        {
            field("NS_Retention Ledger Code"; Rec."NS_Retention Ledger Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Retention Ledger Code';
            }
        }
    }
    actions
    {

        modify("&Navigate")
        {
            Visible = false;
            Enabled = false;
        }
        addafter("Unapply Entries")
        {
            action(NS_Navigate2)
            {
                Caption = '&Navigate';
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
                ApplicationArea = Basic, Suite;
                Promoted = true;
                Image = Navigate;
                PromotedCategory = Process;
                trigger OnAction();
                begin
                    //ProjectPro - start
                    //Navigate.SetDoc("Posting Date","Document No.");
                    Navigate.SetDocLedger("NS_Retention Ledger Code", "Posting Date", "Document No.");
                    //ProjectPro - end
                    Navigate.SetDoc("Posting Date", "Document No.");
                    Navigate.RUN;
                end;
            }
        }
    }

    var
        NS_Job: Record Job;
        NS_FilterSet: Boolean;
        NS_ShowSubLevels: Boolean;
        NS_DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
        NS_ShowJobRec: Record Job;
        Navigate: Page 344;

    trigger OnOpenPage();
    begin
        //ProjectPro - start
        IF NS_FilterSet THEN BEGIN
            IF NS_ShowSubLevels THEN BEGIN
                RESET;
                NS_Job.RESET;
                NS_Job.SETRANGE("No.", NS_ShowJobRec."No.");
                IF NS_Job.FINDSET THEN
                    REPEAT
                        NS_Job."MarkSub-Levels"(NS_Job, TRUE);
                    UNTIL NS_Job.NEXT = 0;
                NS_Job.MARKEDONLY(TRUE);
                IF NS_Job.FINDSET THEN
                    REPEAT
                        NS_DtldCustLedgEntry2.RESET;
                        NS_DtldCustLedgEntry2.SETCURRENTKEY("NS_Job No.", "Document Type", "Posting Date");
                        NS_DtldCustLedgEntry2.SETRANGE("NS_Job No.", NS_Job."No.");
                        NS_DtldCustLedgEntry2.SETRANGE("Document Type", NS_DtldCustLedgEntry2."Document Type"::Payment);
                        NS_DtldCustLedgEntry2.SETFILTER("Posting Date", NS_ShowJobRec.GETFILTER("NS_Date Filter"));
                        IF NS_DtldCustLedgEntry2.FINDSET THEN
                            REPEAT
                                GET(NS_DtldCustLedgEntry2."Entry No.");
                                MARK(TRUE);
                            UNTIL NS_DtldCustLedgEntry2.NEXT = 0;
                    UNTIL NS_Job.NEXT = 0;

                //Now look for ledger entries for this Job
                NS_DtldCustLedgEntry2.SETRANGE("NS_Job No.", NS_ShowJobRec."No.");
                IF NS_DtldCustLedgEntry2.FINDSET THEN
                    REPEAT
                        GET(NS_DtldCustLedgEntry2."Entry No.");
                        MARK(TRUE);
                    UNTIL NS_DtldCustLedgEntry2.NEXT = 0;
                MARKEDONLY(TRUE);
            END ELSE BEGIN
                RESET;
                SETCURRENTKEY("NS_Job No.", "Document Type", "Posting Date");
                SETRANGE("Document Type", "Document Type"::Payment);
                IF NS_ShowJobRec."No." > '' THEN
                    SETRANGE("NS_Job No.", NS_ShowJobRec."No.");
                IF NS_ShowJobRec.GETFILTER("NS_Date Filter") > '' THEN
                    SETFILTER("Posting Date", NS_ShowJobRec.GETFILTER("NS_Date Filter"));
            END;
        END;
        //ProjectPro - end
    end;

    procedure NS_SetFilters(var JobRec: Record Job; "Include Sub-Levels": Boolean);
    begin
        //ProjectPro - start
        NS_ShowJobRec := JobRec;
        NS_ShowJobRec.COPYFILTERS(JobRec);
        NS_ShowSubLevels := "Include Sub-Levels";
        NS_FilterSet := true;
        //ProjectPro - end
    end;

    /* Documentation
      +------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     "PP Job No."
      +     "Retention Ledger Code"
      +
      +  - Added function(s):
      +     SetFilters()
      +
      +  - Added global variable(s):
      +     NS_Job
      +     NS_FilterSet
      +     NS_ShowSubLevels
      +     NS_DtldCustLedgEntry2
      +     NS_ShowJobRec
      +
      +  - Modification(s):
      +     - Call Navigate with Retention Ledger Code parameter
      +     - Added code to OnOpenPage() to a feature showing ledger entries for sub-level jobs
      +
      + -SMP
      +  -Rewritten Actions
      +   -&Navigate
      +------------------------------------------------------------
    */

}

