tableextension 14021147 NS_VatAmountLine extends "VAT Amount Line"
{
    // version NAVW111.00.00.24742,NAVNA11.00.00.24742,PPNA11.00

    fields
    {

        //Unsupported feature: CodeModification on ""Invoice Discount Amount"(Field 8).OnValidate". Please convert manually.
        modify("Invoice Discount Amount")
        {
            trigger OnAfterValidate();
            begin
                //ProjectPro - start
                "VAT Base" := NS_AdjustVATBaseAmount(Rec);
                //ProjectPro - end
            end;
        }
        field(14021101; "NS_Retention Percent"; Decimal)
        {
            Caption = 'Retention Percent';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        RetentionPerc: Decimal;

    PROCEDURE NS_AdjustVATBaseAmount(VAR PassVATAmountLine: Record 290): Decimal;
    VAR
        NS_GLSetup: Record 98;
        NS_JobsSetup: Record 315;
    BEGIN
        //ProjectPro - start
        IF "NS_Retention Percent" = 0 THEN
            EXIT(PassVATAmountLine."VAT Base");

        IF NS_JobsSetup.GET THEN BEGIN
            NS_GLSetup.Get();
            IF NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" = NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing" THEN
                EXIT("VAT Base" - ROUND("VAT Base" * ("NS_Retention Percent" / 100), NS_GLSetup."Amount Rounding Precision"));
        END ELSE
            EXIT(PassVATAmountLine."VAT Base");
        //ProjectPro - end
    END;

    PROCEDURE SetRetentionPerc(PassPercent: Decimal);
    BEGIN
        //ProjectPro - start
        RetentionPerc := PassPercent;
        //ProjectPro - end
    END;

    PROCEDURE GetRetentionPerc(): Decimal
    BEGIN
        exit(RetentionPerc);
    END;

}

