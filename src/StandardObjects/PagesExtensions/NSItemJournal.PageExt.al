pageextension 14021110 NS_ItemJournal extends "Item Journal"
{
    // version NAVW111.00.00.23572,PPNA11.00

    layout
    {
        modify("Item No.")
        {
            trigger OnAfterValidate();
            begin
                //ProjectPro - start
                NS_CalcMarkup;
                //ProjectPro - end
            end;
        }

        modify("Variant Code")
        {
            trigger OnBeforeValidate();
            begin
                //ProjectPro - start
                NS_CalcMarkup();
                //ProjectPro - end
            end;
        }

        modify(Quantity)
        {
            trigger OnBeforeValidate();
            begin
                //ProjectPro - start
                NS_CalcMarkup();
                //ProjectPro - end
            end;
        }

        modify("Unit Amount")
        {
            trigger OnBeforeValidate();
            begin
                //ProjectPro - start
                NS_CalcMarkup();
                //ProjectPro - end
            end;
        }

        modify("Unit Cost")
        {
            trigger OnBeforeValidate();
            begin
                //ProjectPro - start
                NS_CalcMarkup;
                //ProjectPro - end
            end;
        }

        addafter(ShortcutDimCode8)
        //addafter("ShortcutDimCode[8]")
        {
            field("NS_Retention Ledger Code"; Rec."NS_Retention Ledger Code")
            {
                ApplicationArea = All;
Caption = 'Retention Ledger Code';
                ToolTip = 'Specifies the Retention Ledger Code';
            }
            field("NS_Job No."; Rec."Job No.")
            {
                ApplicationArea = All;
Caption = 'Job No.';
                ToolTip = 'Specifies the Job No.';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    if ("Entry Type" in ["Entry Type"::Purchase, "Entry Type"::Sale]) and ("Job No." > '') then
                        ERROR(Text14021100);
                    NS_CheckMarkupFields(FIELDNO("Job No."));
                    //ProjectPro - end
                end;
            }
            field("NS_Subcontract No."; Rec."NS_Subcontract No.")
            {
                Editable = NS_SubcontractNoEditable;
Caption = 'Subcontract No.';
                ToolTip = 'Specifies the Subcontract No.';
                ApplicationArea = All;

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_CheckMarkupFields(FIELDNO("NS_Subcontract No."));
                    //ProjectPro - end
                end;
            }
            field("NS_Category"; Rec.NS_Category)
            {
                Editable = NS_CategoryEditable;
                ToolTip = 'Specifies the Category';
                ApplicationArea = All;

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_CheckMarkupFields(FIELDNO(NS_Category));
                    //ProjectPro - end
                end;
            }
            field("NS_Job Task No."; Rec."Job Task No.")
            {
                Editable = NS_JobTaskNoEditable;
                ToolTip = 'Specifies the Job Task No.';
Caption= 'Job Task No.';
                ApplicationArea = All;

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_CheckMarkupFields(FIELDNO("Job Task No."));
                    //ProjectPro - end
                end;
            }
        }
        addafter("Unit Cost")
        {
            field("NS_Job Unit Cost"; Rec."NS_Job Unit Cost")
            {
                ToolTip = 'Specifies the Job Unit Cost';
                ApplicationArea = All;
Caption = 'Job Unit Cost';
            }
            field("NS_Job Cost"; Rec."NS_Job Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Cost';
            }
            field("NS_Markup Type"; Rec."NS_Markup Type")
            {
                Editable = NS_MarkupTypeEditable;
                ToolTip = 'Specifies the Markup Type';
                Visible = false;
                ApplicationArea = All;

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_CheckMarkupFields(FIELDNO("NS_Markup Type"));
                    //ProjectPro - end
                end;
            }
            field("NS_Markup Value"; Rec."NS_Markup Value")
            {
                Editable = NS_MarkupValueEditable;
                ToolTip = 'Specifies the Markup Value';
                Visible = false;
                ApplicationArea = All;

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_CheckMarkupFields(FIELDNO("NS_Markup Value"));
                    //ProjectPro - end
                end;
            }
            field("NS_Job Unit Price"; Rec."NS_Job Unit Price")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Unit Price';
            }
            field("NS_Job Price"; Rec."NS_Job Price")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Price';
            }
        }
    }

    var
        NS_JobsSetup: Record "Jobs Setup";
        NS_GLSetup: Record "General Ledger Setup";
        NS_JobPlanningLine: Record "Job Planning Line";
        NS_MarkupFound: Boolean;
        [InDataSet]
        NS_SubcontractNoEditable: Boolean;
        [InDataSet]
        NS_CategoryEditable: Boolean;
        [InDataSet]
        NS_JobTaskNoEditable: Boolean;
        [InDataSet]
        NS_MarkupTypeEditable: Boolean;
        [InDataSet]
        NS_MarkupValueEditable: Boolean;

        Text14021100: Label 'Job No. can only be entered on Positive Adjmt. and Negative Adjmt. entries.';

    trigger OnAfterGetRecord();
    begin
        //ProjectPro - start
        NS_CalcMarkup;
        //ProjectPro - end
    end;

    trigger OnOpenPage();
    begin
        //ProjectPro - start
        NS_GLSetup.GET;
        NS_JobsSetup.GET;
        NS_MarkupValueEditable := TRUE;
        NS_MarkupTypeEditable := TRUE;
        NS_JobTaskNoEditable := TRUE;
        NS_CategoryEditable := TRUE;
        NS_SubcontractNoEditable := TRUE;
        //ProjectPro - end
    end;

    procedure NS_CheckMarkupFields(CurrentField: Integer);
    var
        NS_ClearFrom: Integer;
    begin
        //ProjectPro - start
        NS_ClearFrom := 99;

        case CurrentField of
            FIELDNO("Job No."):
                if "Job No." = '' then
                    NS_ClearFrom := 1;
            FIELDNO(NS_Category):
                if NS_Category = '' then
                    NS_ClearFrom := 3;
            FIELDNO("Job Task No."):
                if "Job Task No." = '' then
                    NS_ClearFrom := 4;
        end;

        if (NS_ClearFrom > 0) and (NS_ClearFrom < 2) then
            "Job No." := '';

        if (NS_ClearFrom > 0) and (NS_ClearFrom < 3) then
            "NS_Subcontract No." := '';

        if (NS_ClearFrom > 0) and (NS_ClearFrom < 4) then
            NS_Category := '';

        if (NS_ClearFrom > 0) and (NS_ClearFrom < 5) then
            "Job Task No." := '';

        if "Job No." = '' then begin
            "NS_Job Unit Cost" := 0;
            "NS_Markup Type" := 0;
            "NS_Markup Value" := 0;
            "NS_Job Unit Price" := 0;
        end;

        NS_CalcMarkup;
        //ProjectPro - end
    end;

    procedure NS_CalcMarkup();
    var
        NS_Item: Record Item;
    begin
        //ProjectPro - start
        if "Job No." > '' then begin
            //Get starting cost
            NS_GetJobCost;
            if not NS_MarkupFound then
                "NS_Job Unit Cost" := "Unit Amount";
            "NS_Job Cost" := ROUND("NS_Job Unit Cost" * Quantity, NS_GLSetup."Amount Rounding Precision");

            // Calculate Job price based on markup
            case "NS_Markup Type" of
                0:
                    begin
                        "NS_Markup Value" := 0;
                        "NS_Job Unit Price" := "NS_Job Unit Cost";
                        "NS_Job Price" := ROUND("NS_Job Unit Price" * Quantity, NS_GLSetup."Amount Rounding Precision");
                    end;
                "NS_Markup Type"::"%":
                    begin
                        "NS_Job Unit Price" := ROUND("NS_Job Unit Cost" * (1 + ("NS_Markup Value" / 100)), NS_GLSetup."Amount Rounding Precision");
                        "NS_Job Price" := ROUND("NS_Job Unit Price" * Quantity, NS_GLSetup."Amount Rounding Precision");
                    end;
                "NS_Markup Type"::"$U":
                    begin
                        "NS_Job Unit Price" := "NS_Job Unit Cost" + "NS_Markup Value";
                        "NS_Job Price" := ROUND("NS_Job Unit Price" * Quantity, NS_GLSetup."Amount Rounding Precision");
                    end;
                "NS_Markup Type"::"$T":
                    begin
                        "NS_Job Unit Price" := "NS_Job Unit Cost";
                        "NS_Job Price" := ROUND(("NS_Job Unit Price" * Quantity), NS_GLSetup."Amount Rounding Precision") + "NS_Markup Value";
                    end;
            end;
        end else begin
            "NS_Subcontract No." := '';
            NS_Category := '';
            "Job Task No." := '';
            "NS_Markup Type" := 0;
            "NS_Markup Value" := 0;
            "NS_Job Unit Cost" := 0;
            "NS_Job Cost" := 0;
            "NS_Job Unit Price" := 0;
            "NS_Job Price" := 0;
        end;

        if (("Item No." <> '') and NS_Item.GET("Item No.") and (NS_Category = '')) then
            NS_Category := NS_Item."NS_Job Cost Category";

        if "Job No." = '' then begin
            NS_SubcontractNoEditable := false;
            NS_CategoryEditable := false;
            NS_JobTaskNoEditable := false;
            NS_MarkupTypeEditable := false;
            NS_MarkupValueEditable := false;
        end else begin
            NS_SubcontractNoEditable := true;
            NS_CategoryEditable := true;
            NS_JobTaskNoEditable := true;
            NS_MarkupTypeEditable := true;
            NS_MarkupValueEditable := true;
        end;
        //ProjectPro - end
    end;

    procedure NS_GetJobCost();
    begin
        //ProjectPro - start
        // Look to see if we can get markups on the item from the job, if one was entered.
        // If so, then fill in the values and lock the fields.
        //    Otherwise, the user can modify the values.

        NS_MarkupFound := false;
        if NS_JobsSetup."NS_Item JNL Use Budgeted Cost" then
            with NS_JobPlanningLine do begin
                if Rec."Job No." > '' then begin
                    RESET;
                    SETCURRENTKEY("Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                  "NS_Subcontract No.", "NS_Cost Category", Type, "No.", "Variant Code", "NS_Rate Type", NS_Adjustment);
                    SETRANGE("Job No.", Rec."Job No.");
                    SETRANGE("NS_Entry Type", "NS_Entry Type"::Cost);
                    if Rec."Job Task No." > '' then
                        SETRANGE("Job Task No.", Rec."Job Task No.");
                    if Rec."NS_Subcontract No." > '' then
                        SETRANGE("NS_Subcontract No.", Rec."NS_Subcontract No.");
                    if Rec.NS_Category > '' then
                        SETRANGE("NS_Cost Category", Rec.NS_Category);
                    SETRANGE(Type, Type::Item);
                    SETRANGE("No.", Rec."Item No.");
                    if FINDFIRST then begin
                        "NS_Job Unit Cost" := "Unit Cost";
                        NS_MarkupFound := true;
                    end;
                end;
            end;
        //ProjectPro - end
    end;

    /* Documentation
     +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     Retention Ledger Code
      +     Job No.
      +     Subcontract No.
      +     Category
      +     Job Task No.
      +     Job Unit Cost
      +     Job Cost
      +     Markup Type
      +     Markup Value
      +     Job Unit Price
      +     Job Price
      +
      +  - Added function(s):
      +     CheckMarkupFields
      +     CalcMarkup
      +     GetJobCost
      +
      +  - Added global variable(s):
      +     PP_JobsSetup
      +     PP_MarkupFound
      +     PP_SubcontractNoEditable
      +     PP_CategoryEditable
      +     PP_JobTaskNoEditable
      +     PP_MarkupTypeEditable
      +     PP_MarkupValueEditable
      +     PP_GLSetup
      +     PP_JobPlanningLine
      +
      +  - Added global text constant(s):
      +     Text14021100
      +
      +  - Modification(s):
      +     - OnOpenPage - Read setup records
      +                         General Ledger Setup
      +                         Jobs Setup
      +                  - Initialize variables
      +     - CalcMarkup: Called in the following locations
      +                       OnAfterGetRecord()
      +                       Item No.
      +                       Variant Code
      +                       Quantity
      +                       Unit Amount
      +                       Unit Cost
      +                       CheckMarkupFields()
      +     - CheckMarkupFields: Called in the following locations
      +                       Job No.
      +                       Subcontract No.
      +                       Category
      +                       Job Task No.
      +                       Markup Type
      +                       Markup Value
      +
      + -SMP
      +  -Modified Page Triggers
      +   -OnOpenPage
      +   -OnAfterGetRecord
      +  -Modified Fields
      +   -Unit Cost
      +   -Unit Amount
      +   -Quantity
      +   -Variant Code
      +   -Item No.
      +-----------------------------------------------------------------------------------------------
      */

}

