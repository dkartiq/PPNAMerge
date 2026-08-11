pageextension 14021273 NS_DetailedVendorLedgEntries extends "Detailed Vendor Ledg. Entries"
{
    // version NAVW111.00.00.24232,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Detailed Vendor Ledger Entries'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        addafter("Initial Entry Global Dim. 2")
        {
            field("NS_Retention Ledger Code"; Rec."NS_Retention Ledger Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Retention Ledger Code';
            }
        }
        addafter("Initial Entry Due Date")
        {
            field("NS_Job No."; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';
            }
            field("NS_Subcontract No."; Rec."NS_Subcontract No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Subcontract No.';
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
            action(NS_Navigate)
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
        NS_DtldVendLedgEntry2: Record "Detailed Vendor Ledg. Entry";
        NS_Subcontract: Record NS_Subcontract;
        NS_ShowSubcontractRec: Record NS_Subcontract;
        NS_FilterSet: Boolean;
        NS_SourceCodeSetup: Record "Source Code Setup";
        NS_ShowSubLevels: Boolean;
        Navigate: Page 344;

    trigger OnOpenPage();
    begin
        //ProjectPro - start
        IF NS_FilterSet THEN BEGIN
            NS_SourceCodeSetup.GET;
            IF NS_ShowSubLevels THEN BEGIN
                RESET;
                NS_Subcontract.RESET;
                NS_Subcontract.SETRANGE("NS_No.", NS_ShowSubcontractRec."NS_No.");
                IF NS_Subcontract.FINDSET THEN
                    REPEAT
                        NS_Subcontract."MarkSub-Levels"(NS_Subcontract, TRUE);
                    UNTIL NS_Subcontract.NEXT = 0;
                NS_Subcontract.MARKEDONLY(TRUE);
                IF NS_Subcontract.FINDSET THEN
                    REPEAT
                        NS_DtldVendLedgEntry2.RESET;
                        NS_DtldVendLedgEntry2.SETCURRENTKEY("NS_Subcontract No.", "Source Code", "Posting Date");
                        NS_DtldVendLedgEntry2.SETRANGE("NS_Subcontract No.", NS_Subcontract."NS_No.");
                        NS_DtldVendLedgEntry2.SETRANGE("Source Code", NS_SourceCodeSetup."Payment Journal");
                        NS_DtldVendLedgEntry2.SETFILTER("Posting Date", NS_ShowSubcontractRec.GETFILTER("NS_Date Filter"));
                        IF NS_DtldVendLedgEntry2.FINDSET THEN
                            REPEAT
                                GET(NS_DtldVendLedgEntry2."Entry No.");
                                MARK(TRUE);
                            UNTIL NS_DtldVendLedgEntry2.NEXT = 0;
                    UNTIL NS_Subcontract.NEXT = 0;

                //Now look for ledger entries for this Job
                NS_DtldVendLedgEntry2.SETRANGE("NS_Subcontract No.", NS_ShowSubcontractRec."NS_No.");
                IF NS_DtldVendLedgEntry2.FINDSET THEN
                    REPEAT
                        GET(NS_DtldVendLedgEntry2."Entry No.");
                        MARK(TRUE);
                    UNTIL NS_DtldVendLedgEntry2.NEXT = 0;
                MARKEDONLY(TRUE);
            END ELSE BEGIN
                RESET;
                SETCURRENTKEY("NS_Subcontract No.", "Source Code", "Posting Date");
                SETRANGE("Source Code", NS_SourceCodeSetup."Payment Journal");
                IF NS_ShowSubcontractRec."NS_No." > '' THEN
                    SETRANGE("NS_Subcontract No.", NS_ShowSubcontractRec."NS_No.");
                IF NS_ShowSubcontractRec.GETFILTER("NS_Date Filter") > '' THEN
                    SETFILTER("Posting Date", NS_ShowSubcontractRec.GETFILTER("NS_Date Filter"));
            END;
        END;
        //ProjectPro - end
    end;

    procedure SetFilters(var SubcontractRec: Record NS_Subcontract; "Include Sub-Levels": Boolean);
    begin
        //ProjectPro - start
        NS_ShowSubcontractRec := SubcontractRec;
        NS_ShowSubcontractRec.COPYFILTERS(SubcontractRec);
        NS_ShowSubLevels := "Include Sub-Levels";
        NS_FilterSet := true;
        //ProjectPro - end
    end;

    /* Documentation
      +------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     "PP Job No."
      +     "PP Subcontract No."
      +
      +  - Added function(s):
      +     SetFilters()
      +
      +  - Added global variable(s):
      +     NS_DtldVendLedgEntry2
      +     NS_Subcontract
      +     NS_ShowSubcontractRec
      +     NS_FilterSet
      +     NS_SourceCodeSetup
      +     NS_ShowSubLevels
      +
      +  - Modification(s):
      +     - OnOpenPage: added feature to show ledger entries for sub-level jobs
      +     - Call Navigate function with Retention Ledger Code parameter
      +
      + -SMP
      +  -Rewritten Action
      +   -&Navigate
      +------------------------------------------------------------
    */

}

