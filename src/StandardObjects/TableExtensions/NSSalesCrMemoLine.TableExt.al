tableextension 14021123 NS_SalesCrMemoLine extends "Sales Cr.Memo Line"
{
    // version NAVW111.00.00.24742,NAVNA11.00.00.24742,PPNA11.00

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
            IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge"
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
    }
    keys
    {
        key(Key1; "NS_Retention Applies")
        {
        }
    }


    /*+---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     14021101 Job Cost Category
      +     14021102 Job Revenue Category
      +     14021135 Retention Applies
      +     14021136 Balance to Print
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +     - Added key
      +         Retention Applies
      +
      +-----------------------------------------------------------------------------------------------*/
}

