pageextension 14021124 NS_PurchInvoiceSubForm extends "Purch. Invoice Subform"
{
    // version NAVW111.00.00.24232,NAVNA11.00.00.24232,PPNA11.00
    //PRJ-389.MS.1.0 added filter for get job plng line
    //TM-10.AM.1.0 | Added Field.
    //PRJ-490.MS.1.0 added new field
    //PRJ-492.RS.1.0 10May2021 | Hide/Unhide Fields
    //PRJ-817.JS.1.0�26July2021 | Add fields
    layout
    {
        // addafter("Job Task No.")//PRJ-492.N.S.1.0

        movebefore(Description; "Job Task No.") //PRJ-492.N.S.1.0

        addafter(Description)//PRJ-492.N.S.1.0 
        {
            field("NS_Job Cost Category"; Rec."NS_Job Cost Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Cost Category';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "NS_Subcontract No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
            field("NS_Job Revenue Category"; Rec."NS_Job Revenue Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Revenue Category';
                Visible = false;

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "NS_Subcontract No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
        }
        //addafter("Variant Code")//PRJ-492.N.S.1.0
        addafter("Job Task No.")//PRJ-492.N.S.1.0//PRJ-492.RS.1.0 10May2021 change from "NS-Segment Code"
        {
            field("NS_FA Segment Code"; "NS_FA Segment Code")
            {
                ApplicationArea = all;
                Visible = false;//PRJ-492.N.S.1.0 

            }
            field("NS_Segment Code"; Rec."NS_Segment Code")
            {
                ApplicationArea = ALL;
                Caption = 'Segment Code';
                Description = 'TM-10.AM.1.0';
                //Visible = false; //PRJ-492.AS.1.0 //PRJ-492.RS.1.0 25May2021 Comment
                Visible = true;//PRJ-492.RS.1.0 25May2021
            }
            field("NS_Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Gen. Bus. Posting Group';
            }
            field("NS_Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Gen. Prod. Posting Group';
            }


        }
        //moveafter("NS_Gen. Prod. Posting Group"; "Shortcut Dimension 1 Code")//PRJ-492.N.S.1.0
        //moveafter("Shortcut Dimension 1 Code"; "Shortcut Dimension 2 Code")//PRJ-492.N.S.1.0
        //addafter("Line Discount %")//PRJ-492.N.S.1.0
        addafter("Direct Unit Cost")//PRJ-492.N.S.1.0
        {
            field("NS_Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Amount Including VAT';
            }
            field("NS_Retention Applies"; Rec."NS_Retention Applies")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Retention Applies';
                Visible = false; //PRJ-492.AS.1.0 //Doubt
            }
            field("NS_FA Job Usage"; "NS_FA Job Usage")
            {
                ApplicationArea = all;
                Description = 'PRJ-490.MS.1.0';
                Visible = false; //PRJ-492.N.S.1.0

            }
            //PRJ-490.AM.1.0 Start
            field("NS_FA Job No."; "NS_FA Job No.")
            {
                ApplicationArea = all;
                Visible = false;//PRJ-492.N.S.1.0
            }
            field("NS_FA Job Task No."; "NS_FA Job Task No.")
            {
                ApplicationArea = all;
                Visible = false;//PRJ-492.N.S.1.0
            }
            //PRJ-490.AM.1.0 End
        }

        moveafter("No."; "Job No.")

        modify("Job No.")
        {
            Visible = true;
            trigger OnAfterValidate();
            begin
                //ProjectPro - start
                NS_Job.CorrectForBlankFields("Job No.", "NS_Subcontract No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                //ProjectPro - end
            end;
        }
        // moveafter("NS_Subcontract No."; "Job Task No.")//PRJ-492.N.S.1.0

        modify("Job Task No.")
        {
            Visible = true;
            trigger OnAfterValidate();
            begin
                //ProjectPro - start
                NS_Job.CorrectForBlankFields("Job No.", "NS_Subcontract No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                //ProjectPro - end
            end;
        }
        //PRJ-492.RS.1.0 10May2021 Start
        moveafter("Direct Unit Cost"; "Line Discount %")
        moveafter("Line Discount %"; "Line Amount")
        moveafter("Line Amount"; "Tax Area Code")
        moveafter("Tax Area Code"; "Tax Group Code")
        moveafter("NS_Amount Including VAT"; "Qty. to Assign")
        moveafter("Qty. to Assign"; "Qty. Assigned")
        moveafter("Qty. Assigned"; "Shortcut Dimension 1 Code")
        moveafter("Shortcut Dimension 1 Code"; "Shortcut Dimension 2 Code")
        moveafter("No."; Description)//PRJ-492.RS.2.0 27May2021
        addafter("Shortcut Dimension 2 Code")
        {
            field("NS_JMP Document No."; Rec."NS_JMP Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Material Planning Document No.';
                //Visible = false; //PRJ-492.AS.1.0//PRJ-492.RS.1.0 10May2021 Comment
                Visible = true;//PRJ-492.RS.1.0 10May2021
            }
            field("NS_Subcontract No."; Rec."NS_Subcontract No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Subcontract No.';
                //Visible = false; //PRJ-492.AS.1.0//PRJ-492.RS.1.0 10May2021 Comment
                Visible = true;//PRJ-492.RS.1.0 10May2021

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "NS_Subcontract No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
        }
        modify("Depreciation Book Code")
        {
            Visible = true;
        }
        moveafter("NS_Gen. Prod. Posting Group"; "Depreciation Book Code")
        //PRJ-492.RS.1.0 10May2021 end

        //PRJ-817.JS.1.0�26July2021-Start
        addafter("Unit of Measure Code")
        {
            field("NS_Work Units"; Rec."NS_Work Units")
            {
                ToolTip = 'Specifies the value of the Work Units field';
                ApplicationArea = All;
            }
            field("NS_Work Unit of Measure"; Rec."NS_Work Unit of Measure")
            {
                ToolTip = 'Specifies the value of the Work Unit of Measure field';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("F&unctions")
        {
            action("NS_Get Job Planning Lines")
            {
                ApplicationArea = All;
                Caption = 'Get Job &Planning Lines';
                ToolTip = 'Get Job Planning Lines';

                trigger OnAction();
                begin
                    //ProjectPro - start
                    NS_GetJobBudget('');
                    //ProjectPro - end
                end;
            }
        }
    }

    var
        PurchHeader: Record "Purchase Header";

    var
        NS_GetJobPlanningLine: Page "NS_Get Job Planning Line";
        NS_Job: Record Job;
        NS_Resource: Record Resource;
        Text14021100: Label '"Job No.: "';

    trigger OnNewRecord(BelowxRec: Boolean);
    var
        PurchHeader: Record 38;
    begin
        //ProjectPro - start
        "NS_Retention Applies" := TRUE;
        IF Type <> Type::" " THEN
            IF PurchHeader.GET("Document Type", "Document No.") THEN
                IF PurchHeader."NS_Job No." <> '' THEN
                    VALIDATE("Job No.", PurchHeader."NS_Job No.");
        //ProjectPro - end
    end;

    procedure NS_GetJobBudget(VendNo: Code[20]);
    var
        NS_JobPlanningLine: Record "Job Planning Line";
        NS_Job: Record Job;
        NS_PurchHeader: Record "Purchase Header";
        NS_PurchLine: Record "Purchase Line";
        NS_JobNo: Code[20];
        NS_JobTaskNo: Code[35];
        NS_LineNo: Integer;
        NS_WasBlank: Boolean;
        NS_EnterJobNo: Page "NS_Enter Job No.";
    begin
        //ProjectPro - start
        if "Job No." = '' then begin
            NS_PurchHeader.GET("Document Type", "Document No.");
            NS_PurchHeader.TESTFIELD("NS_Job No.");
            NS_JobNo := NS_PurchHeader."NS_Job No.";
        end else
            NS_JobNo := "Job No.";
        NS_JobPlanningLine.RESET;
        NS_JobPlanningLine.SETRANGE("Job No.", NS_JobNo);
        NS_JobPlanningLine.SetFilter("Line Type", '%1|%2', NS_JobPlanningLine."Line Type"::Budget,
                                                        NS_JobPlanningLine."Line Type"::"Both Budget and Billable");//PRJ-389
        NS_GetJobPlanningLine.NS_SetGetFrom("Document Type", 2, "Document No.");
        NS_GetJobPlanningLine.SETTABLEVIEW(NS_JobPlanningLine);
        NS_GetJobPlanningLine.NS_Set('', NS_JobNo, '', '', '', 0);
        NS_GetJobPlanningLine.RUNMODAL;
        CLEAR(NS_GetJobPlanningLine);
        //ProjectPro - end
    end;

    /* Documentation 
      +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     PP Get Job Planning Lines
      +     JMP Document No.
      +     PP Subcontract No.
      +     Job Task No.
      +     PP Job Cost Category
      +     PP Job Revenue Category
      +     PP Gen. Bus. Posting Group
      +     PP Gen. Prod. Posting Group
      +     PP Amount Including VAT
      +     PP Retention Applies
      +
      +  - Added function(s):
      +     PP_GetJobBudget
      +
      +  - Added global variable(s):
      +     PP_GetJobPlanningLine
      +     PP_Job
      +     PP_Resource
      +
      +  - Added global text constant(s):
      +     Text14021100
      +
      +  - Modification(s):
      +     - OnNewRecord
      +         Set Job No to one that is defined on the header
      +
      +     - Added action list:
      +         No.           - OnValidate - Added Call CorrectForBlankFields
      +         Job No.       - OnValidate - Added Call to CorrectForBlankFields
      +                       - Visibility set TRUE
      +         Job Task No.  - OnValidate - Added Call to CorrectForBlankFields
      +                       - Visibility set TRUE
      +
      +     - Modify action list:
      +         PP_Get Job Planning Line
      +-----------------------------------------------------------------------------------------------
    */

}

