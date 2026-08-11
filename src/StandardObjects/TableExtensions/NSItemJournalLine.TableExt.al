tableextension 14021114 NS_ItemJnlLineExt extends "Item Journal Line"
{
    // version NAVW111.00.00.24232,PPNA11.00

    fields
    {
        //Unsupported feature: Change TableRelation on ""Job No."(Field 1000)". Please convert manually.
        //Unsupported feature: Change TableRelation on ""Job Task No."(Field 1001)". Please convert manually.

        modify("Entry Type")
        {
            trigger OnBeforeValidate()
            begin
                IF ("Job No." > '') AND
                   NOT ("Entry Type" IN ["Entry Type"::"Positive Adjmt.",
                                         "Entry Type"::"Negative Adjmt."]) THEN
                    ERROR(Text14021100Lbl);
            end;
        }
        field(14021101; NS_Category; Code[10])
        {
            Caption = 'Category';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Cost Category";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                GetUnitAmount(FIELDNO(NS_Category));
                //ProjectPro - end
            end;
        }
        field(14021120; "NS_External Relationship Type"; Option)
        {
            Caption = 'External Relationship Type';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            OptionCaption = '" ,Customer,Vendor"';
            OptionMembers = " ",Customer,Vendor;
        }
        field(14021121; "NS_External Relationship No."; Code[20])
        {
            Caption = 'External Relationship No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021122; "NS_External Relationship Name"; Text[50])
        {
            Caption = 'External Relationship Name';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021150; "NS_Markup Type"; Option)
        {
            Caption = 'Markup Type';
            Description = 'ProjectPro';
            OptionCaption = '" ,%,$U,$T"';
            OptionMembers = " ","%","$U","$T";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                GetUnitAmount(FIELDNO("NS_Markup Type"));
                //ProjectPro - end
            end;
        }
        field(14021151; "NS_Markup Value"; Decimal)
        {
            Caption = 'Markup Value';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                GetUnitAmount(FIELDNO("NS_Markup Value"));
                //ProjectPro - end
            end;
        }
        field(14021152; "NS_Job Price"; Decimal)
        {
            Caption = 'Job Price';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021153; "NS_Job Unit Price"; Decimal)
        {
            Caption = 'Job Unit Price';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021154; "NS_Job Cost"; Decimal)
        {
            Caption = 'Job Cost';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021155; "NS_Job Unit Cost"; Decimal)
        {
            Caption = 'Job Unit Cost';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021156; "NS_Job Currency Factor"; Decimal)
        {
            Caption = 'Job Currency Factor';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021157; "NS_Job Currency Code"; Code[20])
        {
            Caption = 'Job Currency Code';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
        }
        field(14021300; "NS_Subcontract No."; Code[20])
        {
            Caption = 'Subcontract No.';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            TableRelation = NS_Subcontract;

            trigger OnValidate();
            begin
                //ProjectPro - start
                GetUnitAmount(FIELDNO("NS_Subcontract No."));
                //ProjectPro - end
            end;
        }
        field(14021301; "NS_Retention Ledger Code"; Code[20])
        {
            Caption = 'Retention Ledger Code';
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            DataClassification = CustomerContent;
        }
    }

    LOCAL PROCEDURE GetUnitAmount(CalledByFieldNo: Integer);
    VAR
        UnitCostValue: Decimal;
    BEGIN
        RetrieveCosts;
        IF ("Value Entry Type" <> "Value Entry Type"::"Direct Cost") OR
           ("Item Charge No." <> '')
        THEN
            EXIT;

        UnitCostValue := UnitCost;
        IF (CalledByFieldNo = FIELDNO(Quantity)) AND
           (Item."No." <> '') AND (Item."Costing Method" <> Item."Costing Method"::Standard)
        THEN
            UnitCostValue := "Unit Cost" / UOMMgt.GetQtyPerUnitOfMeasure(Item, "Unit of Measure Code");

        CASE "Entry Type" OF
            "Entry Type"::Purchase:
                PurchPriceCalcMgt.FindItemJnlLinePrice(Rec, CalledByFieldNo);
            "Entry Type"::Sale:
                SalesPriceCalcMgt.FindItemJnlLinePrice(Rec, CalledByFieldNo);
            "Entry Type"::"Positive Adjmt.":
                "Unit Amount" :=
                  ROUND(
                    ((UnitCostValue - "Overhead Rate") * "Qty. per Unit of Measure") / (1 + "Indirect Cost %" / 100),
                    GLSetup."Unit-Amount Rounding Precision");
            "Entry Type"::"Negative Adjmt.":
                "Unit Amount" := UnitCostValue * "Qty. per Unit of Measure";
            "Entry Type"::Transfer:
                "Unit Amount" := 0;
        END;
    END;

    LOCAL PROCEDURE NS_RetrieveCosts();
    VAR
        StockkeepingUnit: Record 5700;
    BEGIN
        IF ("Value Entry Type" <> "Value Entry Type"::"Direct Cost") OR
           ("Item Charge No." <> '')
        THEN
            EXIT;

        NS_ReadGLSetup;
        NS_GetItem;
        IF StockkeepingUnit.GET("Location Code", "Item No.", "Variant Code") THEN
            UnitCost := StockkeepingUnit."Unit Cost"
        ELSE
            UnitCost := Item."Unit Cost";

        IF "Entry Type" = "Entry Type"::Transfer THEN
            UnitCost := 0
        ELSE
            IF Item."Costing Method" <> Item."Costing Method"::Standard THEN
                UnitCost := ROUND(UnitCost, GLSetup."Unit-Amount Rounding Precision");
    END;

    LOCAL PROCEDURE NS_GetItem();
    BEGIN
        IF Item."No." <> "Item No." THEN
            Item.GET("Item No.");
    END;

    LOCAL PROCEDURE NS_ReadGLSetup();
    BEGIN
        IF NOT GLSetupRead THEN BEGIN
            GLSetup.GET;
            GLSetupRead := TRUE;
        END;
    END;

    var
        Text14021100Lbl: Label 'Job No. can only be entered on Positive or Negative Adjustment entries.';
        UnitCost: Decimal;
        Item: Record Item;
        GLSetupRead: Boolean;
        GLSetup: Record 98;
        UOMMgt: Codeunit 5402;
        PurchPriceCalcMgt: Codeunit 7010;
        SalesPriceCalcMgt: Codeunit 7000;
    /*+---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     14021101 Category
      +     14021120 External Relationship Type
      +     14021121 External Relationship No.
      +     14021122 External Relationship Name
      +     14021150 Markup Type
      +     14021151 Markup Value
      +     14021152 Job Price
      +     14021153 Job Unit Price
      +     14021154 Job Cost
      +     14021155 Job Unit Cost
      +     14021156 Job Currency Factor
      +     14021157 Job Currency Code
      +     14021300 Subcontract No.
      +     14021301 Retention Ledger Code
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +
      +  - Added global text constant(s):
      +     Text14021100
      +
      +  - Modification(s):
      +     - Entry Type field must be Positive Adjmt or Negative Adjmt if Job No. is entered
      +     - Job No. set table relation
      +     - Job Task No. set table relation
      +     - Add more fields for processing
      +         CopyFromPurchLine
      +         CopyFromServHeader
      +         CopyFromJobJnlLine
      +-----------------------------------------------------------------------------------------------*/
}
