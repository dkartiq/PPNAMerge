pageextension 14021282 NS_JobGLJournal extends "Job G/L Journal"
{
    // version NAVW111.00.00.24232,PPNA11.00
    //TM-10.AM.1.0 | Added Field.
    //PRJ-595.AM | Added Validation on post action.
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    //PRJ-1579.RM.1.0 18Aug2022 | Added tooltip
    Caption = 'Job G/L Journals'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        //PRJ-1579.RM.1.0 start
        modify(ShortcutDimCode3)
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 3 , which you set up in the General Ledger Setup window.';
        }
        //PRJ-1579.RM.1.0 end

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
                ToolTip = 'select the Segment'; //PRJ-1579.RM.1.0
            }

        }
        modify("Account No.")
        {
            trigger OnBeforeValidate()
            begin
                //PRJCTPR-60 NK.1.0 13march2022 start
                if (Rec."Account Type" = Rec."Account Type"::"G/L Account") and (Rec."Job No." = '') then
                    if GLAccount.Get(Rec."Account No.") then begin
                        Rec."NS_Job Cost Category" := GLAccount."NS_Cost Category";
                    end else begin
                        if (Rec."Account Type" = Rec."Account Type"::"G/L Account") and (Rec."Job No." <> '') then
                            PP_JobPlanningLine1.Reset();
                        PP_JobPlanningLine1.SetRange("Job No.", Rec."Job No.");
                        PP_JobPlanningLine1.SetRange(Type, PP_JobPlanningLine1.Type::"G/L Account");
                        PP_JobPlanningLine1.SetRange("No.", Rec."Account No.");
                        PP_JobPlanningLine1.SetRange("Job Task No.", Rec."Job Task No.");
                        if PP_JobPlanningLine1.FindSet() then
                            Rec."NS_Job Cost Category" := PP_JobPlanningLine1."NS_Cost Category";

                    end;
                //PRJCTPR-60.NK.1.0 13march2022 end
            end;
        }
        modify("Job No.")
        {
            trigger OnBeforeValidate()
            begin
                //PRJCTPR-60 NK.1.0 13march2022 start
                if (Rec."Account Type" = Rec."Account Type"::"G/L Account") and (Rec."Job No." = '') then
                    if GLAccount.Get(Rec."Account No.") then begin
                        Rec."NS_Job Cost Category" := GLAccount."NS_Cost Category";
                    end else begin
                        if (Rec."Account Type" = Rec."Account Type"::"G/L Account") and (Rec."Job No." <> '') then
                            PP_JobPlanningLine1.Reset();
                        PP_JobPlanningLine1.SetRange("Job No.", Rec."Job No.");
                        PP_JobPlanningLine1.SetRange(Type, PP_JobPlanningLine1.Type::"G/L Account");
                        PP_JobPlanningLine1.SetRange("No.", Rec."Account No.");
                        PP_JobPlanningLine1.SetRange("Job Task No.", Rec."Job Task No.");
                        if PP_JobPlanningLine1.FindSet() then
                            Rec."NS_Job Cost Category" := PP_JobPlanningLine1."NS_Cost Category";

                    end;
                //PRJCTPR-60.NK.1.0 13march2022 end
            end;
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

        GLAccount: Record "G/L Account";//PRJCTPR-60.NK.1.0 start13march2023

        PP_JobPlanningLine1: Record "Job Planning Line"; //PRJCTPR-60.NK.1.0 start13march2023

}

