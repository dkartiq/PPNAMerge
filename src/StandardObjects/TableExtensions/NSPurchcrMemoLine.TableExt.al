tableextension 14021129 NS_PurchCrMemoLine extends "Purch. Cr. Memo Line"
{
    // version NAVW111.00.00.24742,NAVNA11.00.00.24742,PPNA11.00
    //PRJ-817.JS.1.0�04Aug2021 | Add fields work unit and work unit of measure

    fields
    {

        //Unsupported feature: Change OptionString on "Type(Field 5)". Please convert manually.


        //Unsupported feature: Change TableRelation on ""No."(Field 6)". Please convert manually.
        modify("No.")
        {
            TableRelation = IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge"
            else
            if (Type = const(Resource)) Resource
            else
            IF (Type = CONST(NS_Ledger)) "NS_Retention Ledger Code".NS_Code;
        }
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
        field(14021112; "NS_Work Type Code"; Code[10])
        {
            Caption = 'Work Type Code';
            Description = 'ProjectPro';
            TableRelation = "Work Type";
            DataClassification = CustomerContent;
        }
        field(14021115; "NS_Committed Quantity"; Decimal)
        {
            Caption = 'Committed Quantity';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021116; "NS_Committed Qty. (Base)"; Decimal)
        {
            Caption = 'Committed Qty. (Base)';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021117; "NS_Committed Amount (LCY)"; Decimal)
        {
            Caption = 'Committed Amount ($)';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021118; "NS_Committed Amount"; Decimal)
        {
            Caption = 'Committed Amount';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021135; "NS_Retention Applies"; Boolean)
        {
            Caption = 'Retention Applies';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021136; "NS_Balance To Print"; Decimal)
        {
            Caption = 'Balance To Print';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021300; "NS_Subcontract No."; Code[20])
        {
            Caption = 'Subcontract No.';
            Description = 'ProjectPro';
            TableRelation = NS_Subcontract;
            DataClassification = CustomerContent;
        }
        field(14021400; NS_Staged; Boolean)
        {
            Caption = 'Staged';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021401; "NS_JMP Document No."; Code[20])
        {
            Caption = 'JMP Document No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }

        //PRJ-817.JS.1.0�04Aug2021-Start
        field(14021419; "NS_Work Units"; Decimal)
        {
            Caption = 'Work Units';
            DataClassification = CustomerContent;
            MinValue = 0;
            Editable = false;

        }
        field(14021420; "NS_Work Unit of Measure"; Code[10])
        {
            Caption = 'Work Unit of Measure';
            TableRelation = "Unit of Measure".Code;
            DataClassification = CustomerContent;
            Editable = false;

        }
        field(14021421; "NS_Work Unit Completed"; Decimal)
        {
            Caption = 'Work Unit Completed';
            DataClassification = CustomerContent;
            MinValue = 0;
            Editable = false;
        }
        //PRJ-817.JS.1.0�04Aug2021-end

    }
    keys
    {
        key(Key1; "NS_Retention Applies")
        {
        }

    }

    /*+------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     14021101 Job Cost Category
      +     14021102 Job Revenue Category
      +     14021112 Work Type Code
      +     14021115 Committed Quantity
      +     14021116 Committed Qty. (Base)
      +     14021117 Committed Amount (LCY)
      +     14021118 Committed Amount
      +     14021135 Retention Applies
      +     14021136 Balance To Print
      +     14021300 Subcontract No.
      +     14021400 Staged
      +     14021401 JMP Document No.
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +
      +  - Modified:
      +     - Added Keys
      +         Retention Applies
      +         Job No.,Document No.
      +     - Added Ledger to end of Type Optionstring
      +-----------------------------------------------------------*/

}

