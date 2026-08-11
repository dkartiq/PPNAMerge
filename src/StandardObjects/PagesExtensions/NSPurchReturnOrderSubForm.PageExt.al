pageextension 14021179 NS_PurchReturnOrderSubForm extends "Purchase Return Order Subform"
{
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,PPNA11.00

    layout
    {
        modify("No.")
        {
            Visible = false;
            Enabled = false;
        }

        //PRJ-1012.AS.1.0 START
        addafter("No.")
        {
            field("NS_Job No."; Rec."Job No.")
            {
                Caption = 'Job No.';
                ToolTip = 'Specifies the Job No.';
                ApplicationArea = All;
            }
            field("NS_Job Task No."; Rec."Job Task No.")
            {
                Caption = 'Job Task No.';
                ToolTip = 'Specifies the Job No.';
                ApplicationArea = All;
            }

        }
        //PRJ-1012.AS.1.0 END
        addafter(FilteredTypeField)
        {
            field("NS_No.2"; Rec."No.")
            {
                Caption = 'No.';
                ToolTip = 'Specifies the number of a general ledger account, item, additional cost, or fixed asset, depending on what you selected in the Type field.';
                ApplicationArea = PurchReturnOrder;
                ShowMandatory = NOT IsCommentLine;
                trigger OnValidate();
                begin
                    ShowShortcutDimCode(ShortcutDimCode);
                    NoOnAfterValidate();
                    //ProjectPro - start
                    IF Type = Type::NS_Ledger THEN BEGIN
                        NS_Resource.GET("No.");
                        "NS_Job Cost Category" := NS_Resource."NS_Job Cost Category";
                    END;
                    //ProjectPro - end

                    IF xRec."No." <> '' THEN
                        RedistributeTotalsOnAfterValidate;
                    NS_UpdateTypeText;
                end;
            }
        }
        addafter(Description)
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
        addafter("Job Line Type")
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

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "NS_Subcontract No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
        }
    }

    var
        NS_Job: Record Job;
        NS_Resource: Record Resource;
        ShortcutDimCode: ARRAY[8] OF Code[20];
        UnitofMeasureCodeIsChangeable: Boolean;
        IsCommentLine: Boolean;
        TransferExtendedText: Codeunit 378;
        TypeAsText: Text[30];
        TempOptionLookupBuffer: Record 1670;

    LOCAL PROCEDURE NoOnAfterValidate();
    BEGIN
        NS_UpdateEditableOnRow;
        NS_InsertExtendedText(FALSE);
        IF (Type = Type::"Charge (Item)") AND ("No." <> xRec."No.") AND
         (xRec."No." <> '')
      THEN
            CurrPage.SAVERECORD;
    END;

    LOCAL PROCEDURE NS_UpdateEditableOnRow();
    BEGIN
        UnitofMeasureCodeIsChangeable := CanEditUnitOfMeasureCode;
        IsCommentLine := Type = Type::" ";
    END;

    LOCAL PROCEDURE NS_InsertExtendedText(Unconditionally: Boolean);
    BEGIN
        IF TransferExtendedText.PurchCheckIfAnyExtText(Rec, Unconditionally) THEN BEGIN
            CurrPage.SAVERECORD;
            TransferExtendedText.InsertPurchExtText(Rec);
        END;
        IF TransferExtendedText.MakeUpdate THEN
            UpdateForm(TRUE);
    END;

    LOCAL PROCEDURE NS_UpdateTypeText();
    VAR
        RecRef: RecordRef;
    BEGIN
        RecRef.GETTABLE(Rec);
        TypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.FIELD(FIELDNO(Type)));
    END;

    /*
      +------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     "PP Gen. Bus. Posting Group"
      +     "PP Gen. Prod. Posting Group"
      +     "PP Job Cost Category"
      +     "PP Job Revenue Category"
      +
      +  - Added global variable(s):
      +     PP_Job
      +     PP_Resource
      +
      +  - Modification(s):
      +     - No. - OnValidate() - set default value for Job Revenue Category from the Resource table
      +     - OnValidate of Job fields: if the Job No. is blank, then clear Job Task No., Job Cost Category, and Job Revenue Category
      +
      + -SMP
      +  -Rewritten Fields
      +   -No.
      +  -Rewriten Procedures
      +   -UpdateTypeText 
      +   -QuantityOnAfterValidate 
      +   -UpdateEditableOnRow 
      +   -InsertExtendedText 
      +   -NoOnAfterValidate
      +------------------------------------------------------------
    */

}

