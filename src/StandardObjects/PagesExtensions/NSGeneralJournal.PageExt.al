pageextension 14021109 NS_GeneralJournal extends "General Journal"
{
    // version NAVW111.00.00.24232,NAVNA11.00.00.24232,PPNA11.00
    //PRJ-262.MS.1.0 added new field
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'General Journals'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        // PRJCTPR-330.PS.1.0 11April2024 Start
        modify("External Document No.")
        {
            Editable = NS_ExternalDocNo;
            trigger OnafterValidate()
            begin
                NS_ExternalDocNo := true;
                if Rec."NS_Rev. Rec. Summary Dtls" = true then
                    NS_ExternalDocNo := false;
            end;

        }
        // PRJCTPR-330.PS.1.0 11April2024 End
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
            //PE-136.JS.1.0 07Aug2023 - Start
            field("NS_Job Task No."; Rec."Job Task No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Task No.';
            }
            field("NS_Job Quantity"; Rec."Job Quantity")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the quantity for the job ledger entry that is derived from posting the journal line. If the Job Quantity is 0, the total amount on the job ledger entry will also be 0.';
            }
            field("NS_Job Cost Category"; Rec."NS_Job Cost Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Cost Category';
            }
            //PE-136.JS.1.0 07Aug2023 - end
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
            //PRJCTPR-330.PS.1.0 10April2024 Start
            field("NS_Rev. Rec. Summary Dtls"; Rec."NS_Rev. Rec. Summary Dtls")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Rev. Rec. Summary Details';
            }
            //PRJCTPR-330.PS.1.0 10April2024 End
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

    //PRJCTPR-387.DK.1.0 20JUNE2024 Start
    trigger OnOpenPage()
    begin
        NS_ExternalDocNo := NS_ExtDocNoEditeable;
    end;
    //PRJCTPR-387.DK.1.0 20JUNE2024 End

    // PRJCTPR-330.PS.1.0 11April2024 Start
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        NS_ExternalDocNo := NS_ExtDocNoEditeable;
    end;

    procedure NS_ExtDocNoEditeable(): Boolean
    var
        NS_GenJournalLine: Record "Gen. Journal Line";

    begin
        NS_ExternalDocNofrzed := true;
        NS_GenJournalLine.Reset();
        NS_GenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        NS_GenJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        NS_GenJournalLine.SetRange("Line No.", Rec."Line No.");
        NS_GenJournalLine.SetRange("NS_Rev. Rec. Summary Dtls", true);
        if NS_GenJournalLine.FindFirst() then
            NS_ExternalDocNofrzed := false;
        exit(NS_ExternalDocNofrzed);

    end;
    // PRJCTPR-330.PS.1.0 11April2024 End 
    var
        Text14021100: Label 'A Retention Date must be entered when a Retention Amount exists.';
        NS_ExternalDocNo: Boolean;  // PRJCTPR-330.PS.1.0 11April2024
        NS_ExternalDocNofrzed: Boolean; // PRJCTPR-330.PS.1.0 11April2024

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

