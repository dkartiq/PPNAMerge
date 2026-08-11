pageextension 14021134 NS_SalesQuoteSubForm extends "Sales Quote Subform"
{
    // version NAVW111.00.00.24232,NAVNA11.00.00.24232,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Lines'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        modify("No.")
        {
            Visible = false;
            Enabled = false;
        }
        addafter(FilteredTypeField)
        {
            field("NS_No.2"; Rec."No.")
            {
                Caption = 'No.';
                ToolTip = 'Specifies the number of a general ledger account, item, resource, additional cost, or fixed asset, depending on the contents of the Type field.';
                ApplicationArea = Basic, Suite;
                ShowMandatory = NOT IsCommentLine;
                trigger OnValidate();
                begin
                    ShowShortcutDimCode(ShortcutDimCode);
                    NS_NoOnAfterValidate;
                    //ProjectPro - start
                    IF Type = Type::Resource THEN BEGIN
                        NS_Resource.GET("No.");
                        "NS_Job Revenue Category" := NS_Resource."NS_Job Revenue Category";
                    END;
                    //ProjectPro - end

                    IF xRec."No." <> '' THEN
                        RedistributeTotalsOnAfterValidate;

                    NS_UpdateEditableOnRow;
                    NS_UpdateTypeText;
                end;

            }
        }

        addafter("Substitution Available")
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
        addafter("Qty. Assigned")
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
        }
    }

    var
        NS_Job: Record Job;
        NS_Resource: Record Resource;
        ShortcutDimCode: ARRAY[8] OF Code[20];
        IsCommentLine: Boolean;
        UnitofMeasureCodeIsChangeable: Boolean;
        TotalSalesHeader: Record 36;
        InvDiscAmountEditable: Boolean;
        SalesCalcDiscByType: Codeunit 56;
        TransferExtendedText: Codeunit 378;
        TypeAsText: Text[30];
        TempOptionLookupBuffer: Record 1670;


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
                  SalesCalcDiscByType.InvoiceDiscIsAllowed(TotalSalesHeader."Invoice Disc. Code") AND CurrPage.EDITABLE;
        END;
    END;

    LOCAL PROCEDURE NS_NoOnAfterValidate();
    BEGIN
        NS_InsertExtendedText(FALSE);
        IF (Type = Type::"Charge (Item)") AND ("No." <> xRec."No.") AND
           (xRec."No." <> '')
        THEN
            CurrPage.SAVERECORD;

        SaveAndAutoAsmToOrder;
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

    LOCAL PROCEDURE SaveAndAutoAsmToOrder();
    BEGIN
        IF (Type = Type::Item) AND IsAsmToOrderRequired THEN BEGIN
            CurrPage.SAVERECORD;
            AutoAsmToOrder;
            CurrPage.UPDATE(FALSE);
        END;
    END;

    LOCAL PROCEDURE NS_UpdateTypeText();
    VAR
        RecRef: RecordRef;
    BEGIN
        RecRef.GETTABLE(Rec);
        TypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.FIELD(FIELDNO(Type)));
    END;

    /*
      +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     PP Gen. Bus. Posting Group
      +     PP Gen. Prod. Posting Group
      +     PP Job No.
      +     PP Job Task No.
      +     PP Job Cost Category
      +     PP Job Revenue Category
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +     PP_Job
      +     PP_Resource
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +     - Modified controls:
      +         No. - OnValidate - Set Job Revenue Category if Type is Resource
      +
      + -SMP
      +  -Rewritten fields
      +   -"No."
      +  -Added procedures
      +   -UpdateTypeText 
      +   -SaveAndAutoAsmToOrder 
      +   -InsertExtendedText
      +   -NoOnAfterValidate
      +   -UpdateEditableOnRow
      +-----------------------------------------------------------------------------------------------
      */

}

