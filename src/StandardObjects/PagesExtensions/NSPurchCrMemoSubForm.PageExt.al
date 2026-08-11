pageextension 14021137 NS_PurchCrMemoSubForm extends "Purch. Cr. Memo Subform"
{
    // version NAVW111.00.00.23019,NAVNA11.00.00.23019,PPNA11.00
    //PPAL-171.AM.1.0 |Added code to flow segment code.
    //PRJ-939.JS.1.0 27Sep2021 | Add fields
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Lines'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        modify("No.")
        {
            Visible = false;
            Enabled = false;
        }

        //PRJCTPR-333.PS.1.0 14may2024 Start

        modify(Type)
        {
            Editable = NS_TypeNonEditeable;
        }

        //PRJCTPR-333.PS.1.0 14may2024 End
        addafter(FilteredTypeField)
        {
            field("NS_No.2"; Rec."No.")
            {
                Caption = 'No.';
                ToolTip = 'Specifies the number of a general ledger account, an item, an additional cost or a fixed asset, depending on what you selected in the Type field.';
                ApplicationArea = All;
                ShowMandatory = NOT IsCommentLine;
                Editable = NS_TypeNonEditeable; //PRJCTPR-333.PS.1.0 14may2024 
                trigger OnValidate();
                begin
                    ShowShortcutDimCode(ShortcutDimCode);
                    //ProjectPro - start
                    IF Type = Type::NS_Ledger THEN BEGIN
                        NS_Resource.GET("No.");
                        "NS_Job Cost Category" := NS_Resource."NS_Job Cost Category";
                    END;
                    //ProjectPro - end
                    NS_NoOnAfterValidate;
                    UpdateEditableOnRow;

                    IF xRec."No." <> '' THEN
                        RedistributeTotalsOnAfterValidate;
                    NS_UpdateTypeText;
                end;
            }
        }

        modify("Job No.")
        {
            trigger OnAfterValidate();
            begin
                //ProjectPro - start
                NS_Job.CorrectForBlankFields("Job No.", "Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                //ProjectPro - end
            end;
        }

        modify("Job Task No.")
        {

            trigger OnBeforeValidate();
            begin
                //ProjectPro - start
                NS_Job.CorrectForBlankFields("Job No.", "Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                //ProjectPro - end
            end;
        }

        addafter("Job No.")
        {
            field("NS_Subcontract No."; Rec."NS_Subcontract No.")
            {
                ToolTip = 'Specifies the Subcontract No.';
                ApplicationArea = all;

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
        }
        addafter("Job Task No.")
        {
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
            //PRJ-464.Am.1.0 Start
            field("NS_Segment Code"; "NS_Segment Code")
            {
                ApplicationArea = all;
            }
            //PRJ-464.Am.1.0 End
            field("NS_Job Revenue Category"; Rec."NS_Job Revenue Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Revenue Category';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
            //PE-43.JS.1.0 16FEB2023-Start
            field("NS_FA Job Task No."; Rec."NS_FA Job Task No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the  FA Job Task No. field.';
                Editable = NSMarkeditable;
            }
            field("NS_FA Segment Code"; Rec."NS_FA Segment Code")
            {
                ApplicationArea = All;
                ToolTip = 'Select the Segment ';
                Editable = NSMarkeditable;
            }
            field("NS_FA Job Usage"; Rec."NS_FA Job Usage")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the FA Job Usage field.';
                Editable = NSMarkeditable;
            }
            field("NS_FA Job No."; Rec."NS_FA Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the FA Job No. field.';
                Editable = NSMarkeditable;
            }
            //PE-43.JS.1.0 16FEB2023-end            
        }
        addafter("Variant Code")
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
            //PRJ-939.JS.1.0 27Sep2021
            field("NS_Retention Base Amount"; Rec."NS_Retention Base Amount")
            {
                ToolTip = 'Specifies the value of the Retention Base Amount field';
                ApplicationArea = All;
                Editable = false;
                Visible = false;
            }
            field("NS_Retention Base Before Tax"; Rec."NS_Retention Base Before Tax")
            {
                ToolTip = 'Specifies the value of the Retention Base Before Tax field';
                ApplicationArea = All;
                Editable = false;
                Visible = false;
            }
            //PRJ-939.JS.1.0 27Sep2021
        }
        //PPDA.1.0.TBA Start
        // addafter("Amount Including VAT")
        // {
        //     field("NS_Retention Applies"; Rec."NS_Retention Applies")
        //     {
        //         ApplicationArea = All;
        //         ToolTip = 'Specifies whether Retention Applies';
        //     }
        // }
        //PPDA.1.0.TBA End
        moveafter("No."; "Job No.")
    }
    actions
    {
        addafter(GetReturnShipmentLines)
        {
            action("NS_Get Job Planning Lines")
            {
                ApplicationArea = All;
                Caption = 'Get Job &Planning Lines';

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
        NS_PurchHeader: Record "Purchase Header";
        NS_Job: Record Job;
        NS_Resource: Record Resource;
        IsCommentLine: Boolean;
        ShortcutDimCode: ARRAY[8] OF Code[20];
        UnitofMeasureCodeIsChangeable: Boolean;
        TypeAsText: Text[30];
        TempOptionLookupBuffer: Record 1670;

        NSMarkeditable: Boolean;  //PE-43.JS.1.0 20FEB2023
        NS_NoNonediteable: Boolean; //PRJCTPR-333.PS.1.0 14MAy2024
        NS_TypeNonEditeable: Boolean; //PRJCTPR-333.PS.1.0 14MAy2024

    //PE-43.JS.1.0 20FEB2023 - Start
    trigger OnAfterGetCurrRecord()
    var
    begin
        NSMarkeditable := true;
        if (Rec.Type = Rec.Type::"Fixed Asset") and (Rec."Return Shipment No." <> '') then
            NSMarkeditable := false;

        //PRJCTPR-333.PS.1.0 14MAy2024 Start
        NS_TypeNonEditeable := true;
        NS_TypeNonEditeable := NSTypeNonEditeable();
        //PRJCTPR-333.PS.1.0 14MAy2024 End
    end;
    //PE-43.JS.1.0 20FEB2023 - end  

    LOCAL PROCEDURE NS_NoOnAfterValidate();
    BEGIN
        InsertExtendedText(FALSE);
        IF (Type = Type::"Charge (Item)") AND ("No." <> xRec."No.") AND
         (xRec."No." <> '')
      THEN
            CurrPage.SAVERECORD;
    END;

    LOCAL PROCEDURE UpdateEditableOnRow();
    BEGIN
        IF Type <> Type::" " THEN
            UnitofMeasureCodeIsChangeable := CanEditUnitOfMeasureCode
        ELSE
            UnitofMeasureCodeIsChangeable := FALSE;

        IsCommentLine := Type = Type::" "
    END;

    LOCAL PROCEDURE NS_UpdateTypeText();
    VAR
        RecRef: RecordRef;
    BEGIN
        RecRef.GETTABLE(Rec);
        TypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.FIELD(FIELDNO(Type)));
    END;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        //ProjectPro - start
        "NS_Retention Applies" := TRUE;
        IF NS_PurchHeader.GET("Document Type", "Document No.") THEN
            "Job No." := NS_PurchHeader."NS_Job No.";
        //ProjectPro - end
    end;

    procedure NS_GetJobBudget(VendNo: Code[20]);
    var
        NS_JobPlanningLine: Record "Job Planning Line";
        NS_Job: Record Job;
        NS_PurchHeader: Record "Purchase Header";
        NS_PurchLine: Record "Purchase Line";
        NSJobTask1: record "Job Task"; //PRJCTPR-199.JS.1.0 07NOV2023
        NSJobSetup1: record "Jobs Setup";   //PRJCTPR-199.JS.1.0 07NOV2023
        NSBillingHeader: record "NS_Progress Billing Header"; //PRJCTPR-199.JS.1.0 07NOV2023
        NS_JobNo: Code[20];
        NS_JobTaskNo: Code[35];
        NS_LineNo: Integer;
        NS_WasBlank: Boolean;
        Text14021100: Label '"Job No.: "';
        NS_GetJobPlanningLine: Page "NS_Get Job Planning Line";
        NS_EnterJobNo: Page "NS_Enter Job No.";
    begin
        if NSJobSetup1.get() then;  //PRJCTPR-199.JS.1.0 07NOV2023
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
            NS_PurchHeader.GET(Rec."Document Type", Rec."Document No."); //PRJ-1135.NK.1.0
            //PE-260.JS.1.0 07MAR2024 - Start
            if (NS_PurchHeader."NS_Job No." <> '') and (NS_PurchHeader."NS_Multiple Jobs on Lines" = false) then
                if NS_PurchHeader."NS_Job No." <> NS_JobPlanningLine."Job No." then
                    error('Please enable "Multiple Jobs on Lines" in %1 no. %2 on "Purchase %3 Header"', NS_PurchHeader."Document Type", NS_PurchHeader."No.", NS_PurchHeader."Document Type");
            //PE-260.JS.1.0 07MAR2024 - end
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
                //"Job Task No." := NS_JobPlanningLine."Job Task No.";//PRJCTPR-199.JS.1.0 11DEC2023 line commented
                Validate("Job Task No.", NS_JobPlanningLine."Job Task No.");   //PRJCTPR-199.JS.1.0 11DEC2023 line added
                "NS_Job Cost Category" := NS_JobPlanningLine."NS_Cost Category";
                "NS_Job Revenue Category" := NS_JobPlanningLine."NS_Revenue Category";
                //PRJCTPR-199.JS.1.0 07NOV2023 - Start
                // "Shortcut Dimension 1 Code" := NS_JobPlanningLine."NS_Shortcut Dimension 1 Code";
                // "Shortcut Dimension 2 Code" := NS_JobPlanningLine."NS_Shortcut Dimension 2 Code";
                // "Dimension Set ID" := NS_JobPlanningLine."NS_Dimension Set ID";
                //PRJCTPR-199.JS.1.0 07NOV2023 - end
                "NS_Segment Code" := NS_JobPlanningLine."NS_Segment Code";//PPAL-171.AM.1.0
                INSERT;
            end;

        end else
            if NS_WasBlank then
                "Job No." := '';

        CLEAR(NS_GetJobPlanningLine);
        CLEAR(NS_EnterJobNo);
        //ProjectPro - end
    end;

    //PRJCTPR-333.PS.4.0 03May2024 End 
    Local procedure NSTypeNonEditeable(): Boolean
    var
        NS_PurchaseHeader: Record "Purchase Header";
    begin
        NS_NoNonediteable := true;
        NS_PurchaseHeader.Reset();
        NS_PurchaseHeader.SetRange("Document Type", Rec."Document Type");
        NS_PurchaseHeader.SetRange("No.", Rec."Document No.");
        NS_PurchaseHeader.SetRange("NS_Retention Document", true);
        if NS_PurchaseHeader.FindFirst() then
            NS_NoNonediteable := false;
        exit(NS_NoNonediteable);

    end;

    //PRJCTPR-333.PS.1.0 20March2024 End 

    /* Documentation
      +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     PP Subcontract No.
      +     PP Job Cost Category
      +     PP Job Revenue Category
      +     PP Gen. Bus. Posting Group
      +     PP Gen. Prod. Posting Group
      +     PP Retention Applies
      +
      +  - Added function(s):
      +     GetJobBudget
      +
      +  - Added global variable(s):
      +     PP_PurchHeader
      +     PP_Job
      +     PP_Resource
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +     - OnNewRecord - Set Retention Applies TRUE
      +                   - Set Job No from Purchase Header
      +     - Added action list:
      +         PP Get Job Planning Lines
      +     - Modify action list:
      +         No. - OnValidate - Set Job Cost Category on records with Type of Ledger
      +
      + -SMP
      +  -Rewritten Fields
      +   -No.
      +  -Added Procedures
      +   -UpdateTypeText 
      +   -UpdateEditableOnRow 
      +   -NoOnAfterValidate
      +-----------------------------------------------------------------------------------------------
    */

}

