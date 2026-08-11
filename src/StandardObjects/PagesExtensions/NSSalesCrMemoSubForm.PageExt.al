pageextension 14021135 NS_SalesCrMemoSubForm extends "Sales Cr. Memo Subform"
{
    // version NAVW111.00.00.24232,NAVNA11.00.00.24232,PPNA11.00
    //TM-10.AM.1.0 30OCT2020 | Added 1 field on page layout.
    //PPAL-171.AM.1.0 | Added code to flow Segment Code.
    //PRJ-1261.NK.1.0 23Mar2022 | Editable Fields
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Lines'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        //PRJCTPR-333.PS.1.0 14May2024 Start
        modify(Type)
        {
            Editable = NS_TypeEditeable;
        }
        //PRJCTPR-333.PS.1.0 14May2024 End 

        modify("No.")
        {
            Visible = false;
            Enabled = false;
        }
        addafter(FilteredTypeField)
        {
            field("NS_No.2"; "No.")
            {
                Caption = 'No.';
                ToolTip = 'Specifies the number of a general ledger account, item, resource, additional cost, or fixed asset, depending on the contents of the Type field.';
                ApplicationArea = Basic, Suite;
                ShowMandatory = NOT IsCommentLine;
                Editable = NS_TypeEditeable; //PRJCTPR-333.PS.1.0 14May2024
                trigger OnValidate();
                begin
                    ShowShortcutDimCode(ShortcutDimCode);
                    //ProjectPro - start
                    IF Type = Type::Resource THEN BEGIN
                        NS_Resource.GET("No.");
                        "NS_Job Revenue Category" := NS_Resource."NS_Job Revenue Category";
                    END;
                    //ProjectPro - end
                    NS_NoOnAfterValidate;
                    NS_UpdateEditableOnRow;
                    IF xRec."No." <> '' THEN
                        RedistributeTotalsOnAfterValidate;
                    NS_UpdateTypeText;
                end;
            }
        }

        modify("Job No.")
        {
            Editable = true; //PRJ-1261.NK.1.0 23Mar2022
            trigger OnAfterValidate();
            begin
                //ProjectPro - start
                NS_Job.CorrectForBlankFields("Job No.", "Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                //ProjectPro - end
            end;
        }

        modify("Job Task No.")
        {
            Editable = true; //PRJ-1261.NK.1.0 23Mar2022
            trigger OnBeforeValidate();
            begin
                //ProjectPro - start
                NS_Job.CorrectForBlankFields("Job No.", "Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                //ProjectPro - end
            end;
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
            //TM-10.AM.1.0 start
            field("NS_Segment Code"; Rec."NS_Segment Code")
            {
                ApplicationArea = all;
                Description = 'TM-10.AM.1.0';
                Caption = 'Segment Code';
            }
            //TM-10.AM.1.0 end
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        //PRJCTPR-333.PS.1.0 20March2024 Start 

        NS_TypeEditeable := true;
        NS_TypeEditeable := NSTypeNonEditeable;
        //PRJCTPR-333.PS.1.0 20March2024 End 
    end;

    //PRJCTPR-333.PS.1.0 06May2024 Start
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        NS_TypeEditeable := NSTypeNonEditeable;

    end;

    //PRJCTPR-333.PS.1.0 06May2024 End

    var
        NS_SalesHeader: Record "Sales Header";
        NS_Job: Record Job;
        NS_Resource: Record Resource;
        ShortcutDimCode: ARRAY[8] OF Code[20];
        TransferExtendedText: Codeunit 378;
        IsCommentLine: Boolean;
        UnitofMeasureCodeIsChangeable: Boolean;
        TotalSalesHeader: Record 36;
        InvDiscAmountEditable: Boolean;
        SalesCalcDiscountByType: Codeunit 56;
        TypeAsText: Text[30];
        TempOptionLookupBuffer: Record 1670;
        NS_NoNonediteable: Boolean; //PRJCTPR-333.PS.1.0 14may2024   
        NS_TypeEditeable: Boolean; //PRJCTPR-333.PS.1.0 14may2024   

    procedure GetJobBudget(CustNo: Code[10]);
    var
        NS_JobPlanningLine: Record "Job Planning Line";
        NS_Job: Record Job;
        NS_SalesHeader: Record "Sales Header";
        NS_SalesLine: Record "Sales Line";
        NS_JobNo: Code[20];
        NS_JobTaskNo: Code[35];
        NS_LineNo: Integer;
        NS_GetJobPlanningLine: Page "NS_Get Job Planning Line";
    begin
        //ProjectPro - start
        NS_JobPlanningLine."Job No." := "Job No.";
        NS_JobPlanningLine."NS_Cost Category" := "NS_Job Cost Category";
        NS_JobPlanningLine."NS_Revenue Category" := "NS_Job Revenue Category";
        NS_JobPlanningLine."Job Task No." := "Job Task No.";
        NS_JobPlanningLine."NS_Entry Type" := NS_JobPlanningLine."NS_Entry Type"::Price;

        NS_GetJobPlanningLine.NS_Set(CustNo,
                                  NS_JobPlanningLine."Job No.",
                                  NS_JobPlanningLine."NS_Cost Category",
                                  NS_JobPlanningLine."NS_Revenue Category",
                                  NS_JobPlanningLine."Job Task No.",
                                  NS_JobPlanningLine."NS_Entry Type");

        if NS_GetJobPlanningLine.RUNMODAL = ACTION::LookupOK then begin
            NS_GetJobPlanningLine.NS_Get(NS_JobNo, NS_JobTaskNo, NS_LineNo);
            NS_JobPlanningLine.GET(NS_JobNo, NS_JobTaskNo, NS_LineNo);
            NS_SalesHeader.GET("Document Type", "Document No.");
            NS_LineNo := 0;
            NS_SalesLine.RESET;
            NS_SalesLine.SETRANGE("Document Type", NS_SalesHeader."Document Type");
            NS_SalesLine.SETRANGE("Document No.", NS_SalesHeader."No.");
            if NS_SalesLine.FINDLAST then
                NS_LineNo := NS_SalesLine."Line No.";
            NS_LineNo := NS_LineNo + 10000;

            with NS_SalesLine do begin
                INIT;
                "Document Type" := NS_SalesHeader."Document Type";
                "Document No." := NS_SalesHeader."No.";
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
                "Unit Price" := NS_JobPlanningLine."Unit Price";
                "Job No." := NS_JobPlanningLine."Job No.";
                "Job Task No." := NS_JobPlanningLine."Job Task No.";
                "NS_Job Cost Category" := NS_JobPlanningLine."NS_Cost Category";
                "NS_Job Revenue Category" := NS_JobPlanningLine."NS_Revenue Category";
                "Shortcut Dimension 1 Code" := NS_JobPlanningLine."NS_Shortcut Dimension 1 Code";
                "Shortcut Dimension 2 Code" := NS_JobPlanningLine."NS_Shortcut Dimension 2 Code";
                "Dimension Set ID" := NS_JobPlanningLine."NS_Dimension Set ID";
                "NS_Segment Code" := NS_JobPlanningLine."NS_Segment Code";//PPAL-171.AM.1.0
                INSERT;
            end;
        end;
        CLEAR(NS_GetJobPlanningLine);
        //ProjectPro - end
    end;

    LOCAL PROCEDURE NS_NoOnAfterValidate();
    BEGIN
        NS_InsertExtendedText(FALSE);
        IF (Type = Type::"Charge (Item)") AND ("No." <> xRec."No.") AND
           (xRec."No." <> '')
        THEN
            CurrPage.SAVERECORD;
    END;

    LOCAL PROCEDURE NS_InsertExtendedText(Unconditionally: Boolean);
    BEGIN
        IF TransferExtendedText.SalesCheckIfAnyExtText(Rec, Unconditionally) THEN BEGIN
            CurrPage.SAVERECORD;
            COMMIT;
            TransferExtendedText.InsertSalesExtText(Rec);
        END;
        IF TransferExtendedText.MakeUpdate THEN
            UpdateForm(TRUE);
    END;

    LOCAL PROCEDURE NS_UpdateEditableOnRow();
    VAR
        SalesLine: Record 37;
    BEGIN
        IsCommentLine := NOT HasTypeToFillMandatoryFields;
        IF NOT IsCommentLine THEN
            UnitofMeasureCodeIsChangeable := CanEditUnitOfMeasureCode
        ELSE
            UnitofMeasureCodeIsChangeable := FALSE;

        IF TotalSalesHeader."No." <> '' THEN BEGIN
            SalesLine.SETRANGE("Document No.", TotalSalesHeader."No.");
            SalesLine.SETRANGE("Document Type", TotalSalesHeader."Document Type");
            IF NOT SalesLine.ISEMPTY THEN
                InvDiscAmountEditable :=
                  SalesCalcDiscountByType.InvoiceDiscIsAllowed(TotalSalesHeader."Invoice Disc. Code") AND CurrPage.EDITABLE;
        END;
    END;

    LOCAL PROCEDURE NS_UpdateTypeText();
    VAR
        RecRef: RecordRef;
    BEGIN
        RecRef.GETTABLE(Rec);
        TypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.FIELD(FIELDNO(Type)));
    END;


    //PRJCTPR-333.PS.1.0 14May2024 Start
    Local procedure NSTypeNonEditeable(): Boolean
    var
        NS_SalesHeader: Record "Sales Header";
    begin
        NS_NoNonediteable := true;
        NS_SalesHeader.Reset();
        NS_SalesHeader.SetRange("Document Type", Rec."Document Type");
        NS_SalesHeader.SetRange("No.", Rec."Document No.");
        NS_SalesHeader.SetRange("NS_Retention Document", true);
        if NS_SalesHeader.FindFirst() then
            NS_NoNonediteable := false;
        exit(NS_NoNonediteable);

    end;

    //PRJCTPR-333.PS.1.0 14May2024  End

    /* Documentaion
      +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     PP Gen. Bus. Posting Group
      +     PP Gen. Prod. Posting Group
      +     PP Job Cost Category
      +     PP Job Revenue Category
      +
      +  - Added function(s):
      +     Get Job Budget
      +
      +  - Added global variable(s):
      +     PP_SalesHeader
      +     PP_Job
      +     PP_Resource
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +     - OnNewRecord - Set Retention Applies to TRUE
      +                   - Set Job No. to match Sales Header
      +     - Modified controls:
      +         No. - OnValidate - Added setting of Job Revenue Category if Type is Resource
      +     - Added calls to CorrectForBlankFields from Job
      +         Job No.
      +         Job Task No.
      +       
      +-----------------------------------------------------------------------------------------------
      SPLN DMT: OnNewRecord code moved to: [EventSubscriber(ObjectType::Page, 96, 'OnNewRecordEvent', '', false, false)]      
    */

}

