pageextension 14021136 NS_PurchaseQuoteSubForm extends "Purchase Quote Subform"
{
    // version NAVW111.00.00.23019,NAVNA11.00.00.23019,PPNA11.00
    //TM-10.AM.1.0 20OCT2020 | Added Field.
    //PRJ-490.MS.1.0 added new field
    //PRJ-492.RS.1.0 27May2021 | Hide/Unhide Fields 

    layout
    {
        modify(Type)
        {
            trigger OnBeforeValidate();
            begin
                NS_SetJobCostCategory;
            end;
        }
        modify("No.")
        {
            trigger OnBeforeValidate();
            begin
                NS_SetJobCostCategory;
            end;
        }
        modify("Cross-Reference No.")
        {
            trigger OnBeforeValidate();
            begin
                NS_SetJobCostCategory;
            end;
        }
        modify(Description)
        {
            trigger OnBeforeValidate();
            begin
                NS_SetJobCostCategory;
            end;
        }
        //addafter("Variant Code")//PRJ-492.RS.2.0 27May2021 Comment
        addafter(Description)//PRJ-492.RS.2.0 27May2021
        {
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
        //addafter("Amount Including VAT")//PRJ-492 Test Commented this V17 Code
        addafter("Line Amount") //PRJ-492 Test Added this in place of addafter("Amount Including VAT")
        {
            //PPDA.1.0.TBA Start
            //     field("NS_Retention Applies"; Rec."NS_Retention Applies")
            //     {
            //         ApplicationArea = All;
            //         ToolTip = 'Specifies whether Retention Applies';
            //     }
            //PPDA.1.0.TBA End
            field("NS_FA Job Usage"; "NS_FA Job Usage")
            {
                ApplicationArea = all;
                Description = 'PRJ-490.MS.1.0';
            }
            //PRJ-490.AM.1.0 Start
            field("NS_FA Job No."; "NS_FA Job No.")
            {
                ApplicationArea = all;
                Visible = false;//PRJ-492.RS.1.0 27May2021
            }
            field("NS_FA Job Task No."; "NS_FA Job Task No.")
            {
                ApplicationArea = all;
                Visible = false;//PRJ-492.RS.1.0 27May2021
            }
            field("NS_FA Segment Code"; "NS_FA Segment Code")
            {
                ApplicationArea = all;
                Visible = false;//PRJ-492.RS.1.0 27May2021
            }
            //PRJ-490.AM.1.0 End
        }
        //addafter("Qty. Assigned") //PRJ-492.RS.1.0 27May2021 Comment
        addbefore("NS_Gen. Bus. Posting Group") //PRJ-492.RS.1.0 27May2021
        {
            field("NS_Job No."; Rec."Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
            field("NS_Job Task No."; Rec."Job Task No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Task No.';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
            field("NS_Segment Code"; REC."NS_Segment Code")
            {
                ApplicationArea = all;
            }
            field("NS_Job Revenue Category"; Rec."NS_Job Revenue Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Revenue Category';
                Visible = false;//PRJ-492.RS.1.0 27May2021

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
        }
        //PRJ-492.RS.1.0 27May2021 Start
        addafter("NS_Gen. Prod. Posting Group")
        {
            //TM-10.AM.1.0 Start
            field("NS_Depreciation Book Code"; "Depreciation Book Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the Depreciation Book Code';
                Caption = 'Depreciation Book Code';
            }
            //TM-10.AM.1.0 End
            field("NS_Job Cost Category"; Rec."NS_Job Cost Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Cost Category';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("NS_Subcontract No."; Rec."NS_Subcontract No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Subcontract No.';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
        }
        //PRJ-492.RS.1.0 27May2021 End

    }
    actions
    {
        //addafter("Insert &Ext. Texts")
        addafter("Insert &Ext. Texts")
        {
            action("NS_Get Job Planning Line")
            {
                ApplicationArea = All;
                Caption = 'Get Job &Planning Line';

                trigger OnAction();
                begin
                    //ProjectPro - start
                    GetJobBudget('');
                    //ProjectPro - end
                end;
            }
        }
    }

    var
        NS_Job: Record Job;
        NS_PurchHeader: Record "Purchase Header";
        NS_Resource: Record Resource;
        NS_GetJobPlanningLine: Page "NS_Get Job Planning Line";

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        //ProjectPro - start
        IF NS_PurchHeader.GET("Document Type", "Document No.") THEN
            "Job No." := NS_PurchHeader."NS_Job No.";
        //ProjectPro - end
    end;

    local procedure NS_SetJobCostCategory()
    begin
        //ProjectPro - start
        IF Type = Type::NS_Ledger THEN BEGIN
            NS_Resource.GET("No.");
            "NS_Job Cost Category" := NS_Resource."NS_Job Cost Category";
        END;
        //ProjectPro - end
    end;

    procedure GetJobBudget(VendNo: Code[20]);
    var
        NS_JobPlanningLine: Record "Job Planning Line";
        NS_PurchLine: Record "Purchase Line";
        NS_JobNo: Code[20];
        NS_JobTaskNo: Code[35];
        NS_LineNo: Integer;
        NS_WasBlank: Boolean;
        NS_EnterJobNo: Page "NS_Enter Job No.";
    begin
        //ProjectPro - start
        NS_WasBlank := false;
        if "Job No." = '' then begin
            NS_WasBlank := true;
            if NS_EnterJobNo.RUNMODAL = ACTION::OK then
                NS_EnterJobNo.NS_ReturnJobNo(NS_JobNo);
        end;

        if NS_WasBlank then
            NS_JobPlanningLine."Job No." := NS_JobNo
        else
            NS_JobPlanningLine."Job No." := "Job No.";
        NS_JobPlanningLine."NS_Entry Type" := NS_JobPlanningLine."NS_Entry Type"::Cost;

        NS_GetJobPlanningLine.NS_Set(VendNo,
                                  NS_JobPlanningLine."Job No.",
                                  NS_JobPlanningLine."NS_Cost Category",
                                  NS_JobPlanningLine."NS_Revenue Category",
                                  NS_JobPlanningLine."Job Task No.",
                                  NS_JobPlanningLine."NS_Entry Type");

        if NS_GetJobPlanningLine.RUNMODAL = ACTION::LookupOK then begin
            NS_GetJobPlanningLine.NS_Get(NS_JobNo, NS_JobTaskNo, NS_LineNo);
            NS_JobPlanningLine.GET(NS_JobNo, NS_JobTaskNo, NS_LineNo);
            NS_PurchHeader.GET("Document Type", "Document No.");
            NS_LineNo := 0;
            NS_PurchLine.RESET;
            NS_PurchLine.SETRANGE("Document Type", NS_PurchHeader."Document Type");
            NS_PurchLine.SETRANGE("Document No.", NS_PurchHeader."No.");
            if NS_PurchLine.FINDLAST then
                NS_LineNo := NS_PurchLine."Line No.";
            NS_LineNo := NS_LineNo + 10000;

            with NS_PurchLine do begin
                INIT;
                "Document Type" := NS_PurchHeader."Document Type";
                "Document No." := NS_PurchHeader."No.";
                "Line No." := NS_LineNo;
                case NS_JobPlanningLine.Type of
                    NS_JobPlanningLine.Type::Resource:
                        Type := Type::Resource;
                    NS_JobPlanningLine.Type::Item:
                        Type := Type::Item;
                    NS_JobPlanningLine.Type::"G/L Account":
                        Type := Type::"G/L Account";
                end;
                VALIDATE(Type);
                VALIDATE("No.", NS_JobPlanningLine."No.");
                "Variant Code" := NS_JobPlanningLine."Variant Code";
                Description := NS_JobPlanningLine.Description;
                "Gen. Bus. Posting Group" := NS_JobPlanningLine."Gen. Bus. Posting Group";
                "Gen. Prod. Posting Group" := NS_JobPlanningLine."Gen. Prod. Posting Group";
                VALIDATE("Location Code", NS_JobPlanningLine."Location Code");
                "Bin Code" := NS_JobPlanningLine."Bin Code";
                VALIDATE(Quantity, NS_JobPlanningLine.Quantity);
                "Unit of Measure Code" := NS_JobPlanningLine."Unit of Measure Code";
                "Unit Cost" := NS_JobPlanningLine."Unit Cost";
                "Unit Cost (LCY)" := NS_JobPlanningLine."Unit Cost (LCY)";
                "Job No." := NS_JobPlanningLine."Job No.";
                "Job Task No." := NS_JobPlanningLine."Job Task No.";
                "NS_Job Cost Category" := NS_JobPlanningLine."NS_Cost Category";
                "NS_Job Revenue Category" := NS_JobPlanningLine."NS_Revenue Category";
                "Shortcut Dimension 1 Code" := NS_JobPlanningLine."NS_Shortcut Dimension 1 Code";
                "Shortcut Dimension 2 Code" := NS_JobPlanningLine."NS_Shortcut Dimension 2 Code";
                "Dimension Set ID" := NS_JobPlanningLine."NS_Dimension Set ID";
                INSERT;
            end;

        end else
            if NS_WasBlank then
                "Job No." := '';

        CLEAR(NS_GetJobPlanningLine);
        CLEAR(NS_EnterJobNo);
        //ProjectPro - end
    end;

    /*
      +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     PP Gen. Bus. Posting Group
      +     PP Gen. Prod. Posting Group
      +     PP Retention Applies
      +     PP Job No.
      +     PP Subcontract No.
      +     PP Job Task No.
      +     PP Job Cost Category
      +     PP Job Revenue Category
      +
      +  - Added function(s):
      +     GetJobBudget
      +
      +  - Added global variable(s):
      +     PP_Job
      +     PP_PurchHeader
      +     PP_Resource
      +     PP_GetJobPlanningLine
      +
      +  - Added global text constant(s):
      +     GetJobBudget
      +
      +  - Modification(s):
      +     - OnNewRecord - Set Job No. from the header
      +     - Added action list:
      +         PP Get Job Planning Line
      +     - NoOnAfterValidate - Set Job Cost Category on Types of Ledger
      + -SMP
      +  -Instead of inserting code to procedure, modified fields to apply code earlyer
      +-----------------------------------------------------------------------------------------------
    */
}

