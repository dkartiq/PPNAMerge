tableextension 14021109 NS_SalesLine extends "Sales Line"
{
    // version NAVW111.00.00.24742,NAVNA11.00.00.24742,PPNA11.00
    //PRJ-53.SK.1.0 Added code for initialize the "currency"
    //JD-10.MS.1.0 Added new field
    //CTSI-42.AS.1.0 08May2020 Adding new key for inv report 
    //CTSI-42.AS.1.0 21MAY2020 Added Revenue Category Description Field
    //PRJ-264.AS.1.0 02JUNE2020 - Modified Table relation for No. field to add retention ledger code relation
    //PRJ-389.MS.1.0  added filter for get job plng line
    //TM-10.AM.1.0 | Added Field.
    //CTSI-150.AS.1.0 added new fields
    fields
    {
        //PRJ-264.AS.1.0 02JUNE2020 - start
        modify("No.")
        {
            TableRelation = IF (Type = CONST(" ")) "Standard Text" ELSE
            IF (Type = CONST("G/L Account"), "System-Created Entry" = CONST(false)) "G/L Account" WHERE("Direct Posting" = CONST(true),
                            "Account Type" = CONST(Posting), Blocked = CONST(false)) ELSE
            IF (Type = CONST("G/L Account"), "System-Created Entry" = CONST(true)) "G/L Account" ELSE
            IF (Type = CONST(Resource)) Resource ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset" ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge" ELSE
            IF (Type = CONST(Item), "Document Type" = FILTER(<> "Credit Memo" & <> "Return Order")) Item WHERE(Blocked = CONST(false), "Sales Blocked" = CONST(false))
            ELSE
            IF (Type = CONST(Item), "Document Type" = FILTER("Credit Memo" | "Return Order")) Item WHERE(Blocked = CONST(false))
            ELSE
            IF (Type = CONST(Resource)) Resource ELSE
            IF (Type = CONST(NS_Ledger)) "NS_Retention Ledger Code";
        }
        //PRJ-264.AS.1.0 02JUNE2020 - end
        modify(Amount)
        {
            trigger OnAfterValidate()
            var
                SalesTaxCalculate: Codeunit "Sales Tax Calculate";
                CodeUnit50020: Codeunit "NS_Event Subscr. Tables";
                SalesHeader: Record "Sales Header";
                Currency: Record Currency;
                IsHandled: Boolean;
            begin
                SalesHeader.Get("Document Type", "Document No.");
                //PRJ-53.SK.1.0 Start
                IF Currency.Get(SalesHeader."Currency Code") THEN begin
                    SalesHeader.TestField("VAT Base Discount %", 0);
                    Rec."VAT Base Amount" := Round(Rec.Amount, Currency."Amount Rounding Precision")
                end else begin
                    Currency.InitRoundingPrecision();
                    SalesHeader.TestField("VAT Base Discount %", 0);
                    Rec."VAT Base Amount" := Round(Rec.Amount, Currency."Amount Rounding Precision");
                end;
                //PRJ-53.SK.1.0 End
                //ProjectPro - start
                CodeUnit50020.NS_T37NS_AdjustVATBaseAmount(Rec, SalesHeader);
                //ProjectPro - end


                OnBeforeSetAmountIncludingVAT(Rec."Amount Including VAT", IsHandled);
                IF Not IsHandled then
                    Rec."Amount Including VAT" :=
                      Rec.Amount +
                      SalesTaxCalculate.CalculateTax(
                        Rec."Tax Area Code", Rec."Tax Group Code", Rec."Tax Liable", SalesHeader."Posting Date",
                        Rec."VAT Base Amount", Rec."Quantity (Base)", SalesHeader."Currency Factor");
                if Rec."VAT Base Amount" <> 0 then
                    Rec."VAT %" :=
                      //ProjectPro - start
                      //ROUND(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount",0.00001)
                      Round(100 * (Rec."Amount Including VAT" - Rec.Amount) / Rec."VAT Base Amount", 0.00001)
                //ProjectPro - end
                else
                    Rec."VAT %" := 0;
                Rec."Amount Including VAT" := Round(Rec."Amount Including VAT", Currency."Amount Rounding Precision");
            end;
        }
        modify("Amount Including VAT")
        {
            trigger OnAfterValidate()
            var
                SalesHeader: Record "Sales Header";
                Currency: Record Currency;
            begin
                SalesHeader.Get("Document Type", "Document No.");
                //PRJ-53.SK.1.0 Start
                IF NOT Currency.Get(SalesHeader."Currency Code") then
                    Currency.InitRoundingPrecision();
                //PRJ-53.SK.1.0 END
                if Rec.Amount <> 0 then
                    Rec."VAT %" :=
                      //ProjectPro - start
                      //ROUND(100 * ("Amount Including VAT" - Amount) / Amount,0.00001)
                      Round(100 * (Rec."Amount Including VAT" - Rec.Amount) / Rec."VAT Base Amount", 0.00001)
                //ProjectPro - end
                else
                    Rec."VAT %" := 0;
                Rec.Amount := Round(Rec.Amount, Currency."Amount Rounding Precision");
                Rec."VAT Base Amount" := Rec.Amount;
            end;
        }
        //Unsupported feature: Change Editable on ""VAT %"(Field 25)". Please convert manually.
        //Unsupported feature: Change Editable on ""Amount Including VAT"(Field 30)". Please convert manually.
        //Unsupported feature: PropertyDeletion on ""Job No."(Field 45)". Please convert manually.

        field(14021101; "NS_Job Cost Category"; Code[10])
        {
            Caption = 'Job Cost Category';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Cost Category";
            DataClassification = CustomerContent;
        }
        field(14021102; "NS_Job Revenue Category"; Code[10])
        {
            Caption = 'Job Revenue Category';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Revenue Category";
            DataClassification = CustomerContent;
        }
        field(14021135; "NS_Retention Applies"; Boolean)
        {
            Caption = 'Retention Applies';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            InitValue = true;

            trigger OnValidate();
            begin
                //ProjectPro - start
                TestStatusOpen;
                //ProjectPro - end
            end;
        }
        field(14021136; "NS_Balance To Print"; Decimal)
        {
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }

        field(14021400; NS_Status; Option)
        {
            Caption = 'Status';

            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(14021401; "NS_PP Cost"; Decimal)
        {
            Caption = 'PP Cost';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021402; "NS_List Price"; Decimal)
        {
            Caption = 'List Price';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021403; "NS_Gross Margin"; Integer)
        {
            Caption = 'Gross Margin';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if (CurrFieldNo = FIELDNO("NS_Gross Margin")) and
                   ("NS_Gross Margin" <> 0) then
                    NS_CalcUnitPricefromGrossMargin;
            end;
        }
        field(14021404; "NS_No. 2"; Code[30])
        {
            Caption = 'Mfg. Item No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                QuoteMgt.NS_ValidateNo2OnSalesLine(Rec);
            end;
        }
        field(14021405; "NS_Core Credit Relation"; Code[20])
        {
            Caption = 'Core Credit Relation';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021406; "NS_Core CreditRelationVariant"; Code[10])
        {
            Caption = 'Core Credit Relation Variant';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021407; "NS_Contract Price Found"; Boolean)
        {
            Caption = 'Contract Price Found';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021408; "NS_Manufacturer Code"; Code[10])
        {
            Caption = 'Manufacturer Code';
            Description = 'ProjectPro';
            TableRelation = Manufacturer;
            DataClassification = CustomerContent;
        }
        field(14021409; "NS_Original Order Qty."; Decimal)
        {
            Caption = 'Original Order Qty.';
            DecimalPlaces = 0 : 5;
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021410; "NS_First Shipment"; Boolean)
        {
            Caption = 'First Shipment';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021411; "NS_First Shipment Complete"; Boolean)
        {
            Caption = 'First Shipment Complete';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            Editable = false;
        }
        field(14021412; "NS_Exclude from Usage"; Boolean)
        {
            Caption = 'Exclude from Usage';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021413; "NS_Demand Date"; Date)
        {
            Caption = 'Demand Date';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        //CTSI-42.AS.1.0 21MAY2020 - START
        field(14021431; "NS_Revenue Cat Description"; Text[100])
        {
            Caption = 'Revenue Cat. Description';
            Description = 'Revenue Cat. Description';
            DataClassification = CustomerContent;
        }
        //CTSI-42.AS.1.0 21MAY2020 - END
        //CTSI-150.AS.1.0 28Sept2020 - start
        field(14021432; "NS_From Prog. Billing Base Amount"; Decimal)
        {
            Caption = 'From Prog. Billing Base Amount';
            Description = 'From Prog. Billing Base Amount';
            DataClassification = CustomerContent;
        }
        //CTSI-150.AS.1.0 28Sept2020 - end

        field(14021414; "NS_Segment Code"; Code[20])
        {
            Caption = 'Segment Code';
            Description = 'TM-10.AM.1.0';
            TableRelation = "NS_Job Takeoff Segments"."NS_Segment Code" WHERE("NS_Job No." = FIELD("Job No."));
            DataClassification = CustomerContent;
        }
        //TM-32.AM.1.0
        field(14021415; "NS_Segment Name"; Text[50])
        {
            CalcFormula = Lookup("NS_Job Takeoff Segments"."NS_Segment Name" WHERE("NS_Job No." = FIELD("Job No."), "NS_Segment Code" = FIELD("NS_Segment Code")));
            Caption = 'Segment Name';
            FieldClass = FlowField;
        }
        //TM-32.AM.1.0
        field(14021430; "NS_DFR No."; code[20])
        {
            Caption = 'DFR No.';
            Description = 'JD-10.MS.1.0';
            Editable = false;
            DataClassification = CustomerContent;
        }

    }
    keys
    {
        key(Key1; "NS_Retention Applies")
        {
        }
        key(key5; "NS_Job Revenue Category")   //adding new key for inv report //CTSI-42.AS.1.0 
        {

        }
    }

    PROCEDURE CalcGrossMargin();
    VAR
        CalcMargin: Decimal;
    BEGIN
        CASE TRUE OF
            "Unit Cost" <> 0:
                BEGIN
                    CalcMargin := (ROUND("Unit Price" / "Unit Cost", 1) * 100);
                    CASE TRUE OF
                        (CalcMargin < -2147483647):
                            VALIDATE("NS_Gross Margin", -2147483647);
                        (CalcMargin > 2147483647):
                            VALIDATE("NS_Gross Margin", 2147483647);
                        ELSE
                            VALIDATE("NS_Gross Margin", CalcMargin);
                    END;
                END;
            "NS_PP Cost" <> 0:
                BEGIN
                    CalcMargin := (ROUND("Unit Price" / "NS_PP Cost", 1) * 100);
                    CASE TRUE OF
                        (CalcMargin < -2147483647):
                            VALIDATE("NS_Gross Margin", -2147483647);
                        (CalcMargin > 2147483647):
                            VALIDATE("NS_Gross Margin", 2147483647);
                        ELSE
                            VALIDATE("NS_Gross Margin", CalcMargin);
                    END;
                END ELSE
                        "NS_Gross Margin" := 100;
        END;
    END;

    PROCEDURE NS_CalcUnitPricefromGrossMargin();
    BEGIN
        IF ("Unit Cost" = 0) AND
          ("NS_PP Cost" = 0) THEN
            ERROR(Text14021400Lbl);
        IF "Unit Cost" <> 0 THEN BEGIN
            VALIDATE("Unit Price", ROUND("Unit Cost" + ("Unit Cost" * ("NS_Gross Margin" / 100)), 0.01))
        END ELSE BEGIN
            IF "NS_PP Cost" <> 0 THEN
                VALIDATE("Unit Price", ROUND("NS_PP Cost" + ("NS_PP Cost" * ("NS_Gross Margin" / 100)), 0.01))
        END;
    END;

    PROCEDURE GetPurchCode(DropShip: Boolean; SpecialOrder: Boolean; VAR PurchCode: Code[10]);
    VAR
        Purchasing: Record 5721;
    BEGIN
        CASE TRUE OF
            DropShip AND SpecialOrder:
                ERROR(Text14021401Lbl);
            DropShip:
                BEGIN
                    Purchasing.RESET;
                    Purchasing.SETRANGE("Drop Shipment", TRUE);
                    IF Purchasing.FINDFIRST THEN
                        PurchCode := Purchasing.Code;
                END;
            SpecialOrder:
                BEGIN
                    Purchasing.RESET;
                    Purchasing.SETRANGE("Special Order", TRUE);
                    IF Purchasing.FINDFIRST THEN
                        PurchCode := Purchasing.Code;
                END;
        END;
    END;

    PROCEDURE SetDropShipbyLocation();
    BEGIN
        IF ("Document Type" IN ["Document Type"::Order, "Document Type"::Invoice]) AND
           (Type = Type::Item) THEN BEGIN
            VALIDATE("Purchasing Code", '');
        END;
    END;

    PROCEDURE SetDefaultVariant();
    VAR
        ItemVariant: Record 5401;
    BEGIN
        ItemVariant.RESET;
        ItemVariant.SETRANGE("Item No.", "No.");
        ItemVariant.SETRANGE(NS_Default, TRUE);
        IF ItemVariant.FINDFIRST THEN
            VALIDATE("Variant Code", ItemVariant.Code);
    END;

    PROCEDURE NS_GetJobLedger();
    BEGIN
        NS_GetJobUsage.SetCurrentSalesLine(Rec);
        NS_GetJobUsage.RUNMODAL;
        CLEAR(NS_GetJobUsage);
        //ProjectPro - end
    END;

    PROCEDURE NS_GetJobBudget(CustNo: Code[20]);
    VAR
        NS_JobPlanningLine: Record 1003;
        NS_Job: Record 167;
        NS_SalesHeader: Record 36;
        NS_SalesLine: Record 37;
        NS_JobNo: Code[20];
        NS_JobTaskNo: Code[35];
        NS_LineNo: Integer;
        NS_GetJobPlanningLine: Page "NS_Get Job Planning Line";
    BEGIN
        IF "Job No." = '' THEN BEGIN
            NS_SalesHeader.GET("Document Type", "Document No.");
            NS_SalesHeader.TESTFIELD("NS_Job No.");
            NS_JobNo := NS_SalesHeader."NS_Job No.";
        END ELSE
            NS_JobNo := "Job No.";
        NS_JobPlanningLine.RESET;
        NS_JobPlanningLine.SETRANGE("Job No.", NS_JobNo);
        NS_JobPlanningLine.SetFilter("Line Type", '%1|%2', NS_JobPlanningLine."Line Type"::Billable,
                                                       NS_JobPlanningLine."Line Type"::"Both Budget and Billable");//PRJ-389.MS.1.0
        NS_GetJobPlanningLine.NS_SetGetFrom("Document Type", 1, "Document No.");
        NS_GetJobPlanningLine.SETTABLEVIEW(NS_JobPlanningLine);
        NS_GetJobPlanningLine.NS_Set('', NS_JobNo, '', '', '', 0);
        NS_GetJobPlanningLine.RUNMODAL;

        CLEAR(NS_GetJobPlanningLine);
    END;

    PROCEDURE NS_AdjustVATBaseAmount(VAR SalesHeader: Record "Sales Header");
    VAR
        NS_GLSetup: Record 98;
        NS_JobsSetup: Record 315;
    BEGIN
        //ProjectPro - start
        IF SalesHeader."NS_Retention Percent" = 0 THEN
            EXIT;

        IF NS_JobsSetup.GET THEN BEGIN
            IF NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" = NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing" THEN
                "VAT Base Amount" := Amount - ROUND("VAT Base Amount" * (SalesHeader."NS_Retention Percent" / 100), NS_GLSetup."Amount Rounding Precision");
        END;
        //ProjectPro - end
    END;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSetAmountIncludingVAT(Var AmountIncludeVAT: Decimal; VAR IsHandled: boolean)
    begin
    end;


    var
        //PurchCode: Code[10];
        NS_GetJobUsage: Report "NS_Get Job Usage";
        QuoteMgt: Codeunit "NS_Job Quote Mgt.";
        Text14021400Lbl: Label 'Unable to calculate price from gross margin.  This item does not have a Unit Cost or Non-Stock Cost value.';
        Text14021401Lbl: Label 'A Purchasing Code cannot be Drop Ship and Special Order.';

    /*+---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added fields:
      +     14021101 Job Cost Category
      +     14021102 Job Revenue Category
      +     14021135 Retention Applies
      +     14021136 Balance To Print
      +     14021400 Status
      +     14021401 PP Cost
      +     14021402 List Price
      +     14021403 Gross Margin
      +     14021404 No. 2
      +     14021405 Core Credit Relation
      +     14021406 Core Credit Relation Variant
      +     14021407 Contract Price Found
      +     14021408 Manufacturer Code
      +     14021409 Original Order Qty.
      +     14021410 First Shipment
      +     14021411 First Shipment Complete
      +     14021412 Exclude from Usage
      +     14021413 Demand Date
      +
      +  - Added function(s):
      +     PP_GetJobLedger  - Should be the sames a P47
      +     PP_GetJobBudget  - Should be the sames a P47
      +     CalcGrossMargin
      +     CalcUnitPricefromGrossMargin
      +     GetPurchCode
      +     SetDropShipByLocation
      +     SetDefaultVariant
      +
      +  - Added global variable(s):
      +     PurchCode
      +     QuoteMgt
      +     PP_GetJobUsage
      +
      +  - Added global text constant(s):
      +     Text14021400
      +     Text14021401
      +
      +  - Modification(s):
      +     - Added Keys:
      +         Retention Applies
      +         Document Type,Document No.,Job No.,Job Revenue Category,Job Task No.
      +     - Modified OnLookup for:
      +         Amount
      +         UpdateVATAmounts()
      +         UpdateVATOnLines
      +         Job Task No.
      +     - Added OnLookup code to Job Task No.
      +     - Added OnValidate to avoid GET of non-existant Standard Text to No.
      +     - Modify to allow field modifictions Job Task No.
      +     - Modify Type field by adding Ledger to the end of the OptionString
      +     - Modify the Editable property to Yes
      +         VAT %
      +         Amount Including VAT
      +         Job No.
      +     - Modify Calculation of VAT %
      +-----------------------------------------------------------------------------------------------*/
}

