tableextension 14021121 NS_SalesInvoiceLine extends "Sales Invoice Line"
{
    // version NAVW111.00.00.24742,NAVNA11.00.00.24742,PPNA11.00
    //TM-10.AM.1.0 | Added Field.
    //CTSI-150.AS.1.0 added new field
    //PRJ-1015.JS.1.0 22Oct2021 | field Added
    //PRJ-1624.NK.1.0 22Sep2022 | Added Fields
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
        field(14021136; "NS_Balance To Print"; Decimal)
        {
            Caption = 'Balance To Print';
            Description = 'ProjectPro';
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
        field(14021135; "NS_Retention Applies"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(14021137; "NS_Segment Code"; Code[20])
        {
            Caption = 'Segment Code';
            Description = 'TM-10.AM.1.0';
            //TableRelation = "Job Takeoff Segments"."Segment Code" WHERE("Job No." = FIELD("Job No."));
            DataClassification = CustomerContent;
        }
        //TM-32.AM.1.0
        field(14021415; "NS_Segment Name"; Text[50])
        {
            Caption = 'Segment Name';
            DataClassification = CustomerContent;
        }
        //TM-32.AM.1.0
        field(14021430; "NS_DFR No."; Code[20])
        {
            Caption = 'DFR No.';
            Description = 'JD-10.MS.1.0';
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
        //PRJ-1624.NK.1.0 22Sep2022 Start
        field(14021486; "NS_Retention %"; Decimal)
        {
            Caption = 'Retention %';
            DecimalPlaces = 2 : 15;
            DataClassification = CustomerContent;
            Description = 'Retention %';
        }
        field(14021487; "NS_Retention Amount"; Decimal)
        {
            Caption = 'Retention Amount';
            DataClassification = CustomerContent;
            Description = 'Retention Amount';
        }
        //PRJ-1624.NK.1.0 22Sep2022 End

    }

    keys
    {
        key(Key10; "NS_Retention Applies")
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
      +     - Added keys
      +         Retention Applies
      +         Job No.,Document No.
      +     - Modify fields to allow for a Ledger type record
      +         Type
      +         No.
      +-----------------------------------------------------------------------------------------------*/

}

