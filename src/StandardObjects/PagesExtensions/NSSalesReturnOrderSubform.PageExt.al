pageextension 14021176 NS_SalesReturnOrderSubForm extends "Sales Return Order Subform"
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
                    NoOnAfterValidate;
                    UpdateEditableOnRow;
                    Rec.ShowShortcutDimCode(ShortcutDimCode);
                    //ProjectPro - start
                    IF Rec.Type = Rec.Type::Resource THEN BEGIN
                        NS_Resource.GET(Rec."No.");
                        "NS_Job Revenue Category" := NS_Resource."NS_Job Revenue Category";
                    END;
                    //ProjectPro - end


                    QuantityOnAfterValidate;
                    IF xRec."No." <> '' THEN
                        RedistributeTotalsOnAfterValidate;
                    UpdateTypeText;
                end;

            }
        }
        addafter("VAT Prod. Posting Group")
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
        addafter(Quantity)
        {
            field("NS_Job No."; Rec."Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields(Rec."Job No.", Rec."Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", Rec."Job Task No.");
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
                    NS_Job.CorrectForBlankFields(Rec."Job No.", Rec."Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", Rec."Job Task No.");
                    //ProjectPro - end
                end;
            }
            field("NS_Job Cost Category"; "NS_Job Cost Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Cost Category';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields(Rec."Job No.", Rec."Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", Rec."Job Task No.");
                    //ProjectPro - end
                end;
            }
            field("NS_Job Revenue Category"; "NS_Job Revenue Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Revenue Category';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields(Rec."Job No.", Rec."Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", Rec."Job Task No.");
                    //ProjectPro - end
                end;
            }
        }
    }

    var
        NS_Job: Record Job;
        NS_Resource: Record Resource;
        TransferExtendedText: Codeunit 378;
        IsCommentLine: Boolean;
        UnitofMeasureCodeIsChangeable: Boolean;
        TotalSalesHeader: Record 36;
        InvDiscAmountEditable: Boolean;
        SalesCalcDiscByType: Codeunit 56;
        ShortcutDimCode: ARRAY[8] OF Code[20];
        TypeAsText: Text[30];
        TempOptionLookupBuffer: Record 1670;


    LOCAL PROCEDURE NoOnAfterValidate();
    BEGIN
        InsertExtendedText(FALSE);
        IF (Rec.Type = Rec.Type::"Charge (Item)") AND (Rec."No." <> xRec."No.") AND
           (xRec."No." <> '')
        THEN
            CurrPage.SAVERECORD;
    END;

    LOCAL PROCEDURE InsertExtendedText(Unconditionally: Boolean);
    BEGIN
        IF TransferExtendedText.SalesCheckIfAnyExtText(Rec, Unconditionally) THEN BEGIN
            CurrPage.SAVERECORD;
            COMMIT;
            TransferExtendedText.InsertSalesExtText(Rec);
        END;
        IF TransferExtendedText.MakeUpdate THEN
            UpdateForm(TRUE);
    END;

    LOCAL PROCEDURE UpdateEditableOnRow();
    VAR
        SalesLine: Record 37;
    BEGIN
        IsCommentLine := NOT Rec.HasTypeToFillMandatoryFields;
        IF NOT IsCommentLine THEN
            UnitofMeasureCodeIsChangeable := Rec.CanEditUnitOfMeasureCode
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

    LOCAL PROCEDURE QuantityOnAfterValidate();
    BEGIN
        IF Rec.Reserve = Rec.Reserve::Always THEN BEGIN
            CurrPage.SAVERECORD;
            Rec.AutoReserve;
            CurrPage.UPDATE(FALSE);
        END;
    END;

    LOCAL PROCEDURE UpdateTypeText();
    VAR
        RecRef: RecordRef;
    BEGIN
        RecRef.GETTABLE(Rec);
        TypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.FIELD(Rec.FIELDNO(Type)));
    END;

    /*
    +------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     "PP Gen. Bus. Posting Group"
      +     "PP Gen. Prod. Posting Group"
      +     "PP Job No."
      +     "PP Job Task No."
      +     "PP Job Cost Category"
      +     "PP Job Revenue Category"
      +
      +  - Added global variable(s):
      +     NS_Job
      +     NS_Resource
      +
      +  - Modification(s):
      +     - If the Job No. is blank, then clear Job Task No., Job Cost Category, and Job Revenue Category
      +     - No. - OnValidate() - Set default value for Job Revenue Category from related record in Resource table
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

