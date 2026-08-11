tableextension 14021119 NS_SalesShipmentLine extends "Sales Shipment Line"
{
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,PPNA11.00
    //PRJ-1015.JS.1.0  22Oct2021 | field added

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
            ELSE
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

        field(14021433; "NS_Sub-Level to Job No."; Code[20])    //PRJ-1015.JS.1.0  19Oct2021
        {
            Caption = 'Sub-Level to Job No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            TableRelation = Job;
            Editable = false;
        }


    }

    /* +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     14021101 Job Cost Category
      +     14021102 Job Revenue Category
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +     - Modified Type OptionString to end in Ledger
      +     - Modified OnLookup of No. field
      +-----------------------------------------------------------------------------------------------*/

}

