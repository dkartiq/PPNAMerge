pageextension 14021282 NS_JobGLJournal extends "Job G/L Journal"
{
    // version NAVW111.00.00.24232,PPNA11.00
    //TM-10.AM.1.0 | Added Field.
    //PRJ-595.AM | Added Validation on post action.

    layout
    {
        addafter("Ship-to/Order Address Code")
        {
            field("NS_Retention Ledger Code"; Rec."NS_Retention Ledger Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Retention Ledger Code';
            }
        }
        addafter("Job Task No.")
        {
            field("NS_Job Cost Category"; Rec."NS_Job Cost Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Cost Category';
            }
            field("NS_Job Revenue Category"; Rec."NS_Job Revenue Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Revenue Category';
            }
            field("NS_Cost-Revenue Type"; Rec."NS_Cost-Revenue Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Cost-Revenue Type';
            }
            field("NS_Segment Code"; "NS_Segment Code")
            {
                ApplicationArea = All;
                Description = 'TM-10.AM.1.0';
            }
        }
    }
    //PRJ-595.AM.1.0 Start
    actions
    {

        modify("P&ost")
        {
            trigger OnBeforeAction()
            var
            begin
                JobSetup.get();
                if JobSetup."NS_Job Segment Mandatory" then begin
                    GenJnline.Reset();
                    GenJnline.SetCurrentKey("Line No.");
                    GenJnline.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    GenJnline.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJnline.SetRange("Job No.", Rec."Job No.");
                    GenJnline.SetRange("Document No.", Rec."Document No.");
                    if GenJnline.FindSet() then begin
                        repeat
                            GenJnline.TestField("NS_Segment Code");
                        until GenJnline.Next() = 0;
                    end;
                end;
            end;
        }
        //PRJ-595.AM.1.0 Start
    }

    /*
      +------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     "PP Job Cost Category"
      +     "PP Job Revenue Category"
      +     "PP Cost-Revenue Type"
      +     "Retention Ledger Code"
      +------------------------------------------------------------
    */
    var
        Jobsetup: Record "Jobs Setup";
        GenJnline: Record "Gen. Journal Line";

}

