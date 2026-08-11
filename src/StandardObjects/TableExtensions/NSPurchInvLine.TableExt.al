tableextension 14021127 NS_PurchInvLine extends "Purch. Inv. Line"
{
    // version NAVW111.00.00.24742,NAVNA11.00.00.24742,PPNA11.00
    //TM-10.AM.1.0 | Added Field.
    //PRJ-490.AM.1.0 | Added Fields
    //PRJ-817.JS.1.0�04Aug2021 | Add fields work unit and work unit of measure
    //PRJ-939.JS.1.0 27Sep2021 | Add code
    //PRJ-1015.JS.1.0 22Oct2021 | field Added

    fields
    {

        //Unsupported feature: Change OptionString on "Type(Field 5)". Please convert manually.
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
            IF (Type = const(NS_Ledger)) "NS_Retention Ledger Code".NS_Code;
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
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
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
            DataClassification = CustomerContent;
            TableRelation = NS_Subcontract;
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
        field(14021408; "NS_JMP Details"; Text[30])
        {
            Caption = 'JMP Details';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            //PRJCTPR-256.JS.1.0 14DEC2023 - Start
            ObsoleteState = Pending;
            ObsoleteReason = 'Replaced by new field “JMP Details” with increased length 100 characters';
            ObsoleteTag = 'Repleace in ProjectPro Upcomming release 23.0.XX.XXXX';
            //PRJCTPR-256.JS.1.0 14DEC2023 - end 
        }
        field(14021409; "NS_Segment Code"; Code[20])
        {
            Caption = 'Segment Code';
            Description = 'TM-10.AM.1.0';
            //TableRelation = "Job Takeoff Segments"."Segment Code" WHERE("Job No." = FIELD("Job No."));
            DataClassification = CustomerContent;
        }
        field(14021415; "NS_FA Job Usage"; Boolean)
        {
            Caption = 'FA Job Usage';
            Description = 'PRJ-490.MS.1.0';
            DataClassification = CustomerContent;

        }
        field(14021416; "NS_FA Job No."; Code[20])
        {
            Caption = 'FA Job No.';
            Description = 'PRJ-490.AM.1.0';
            DataClassification = CustomerContent;

        }
        field(14021417; "NS_FA Job Task No."; Code[20])
        {
            Caption = ' FA Job Task No.';
            Description = 'PRJ-490.AM.1.0';
            DataClassification = CustomerContent;
        }
        field(14021418; "NS_FA Segment Code"; Code[20])
        {
            Caption = 'FA Segment Code';
            Description = 'PRJ-490.AM.1.0';
            DataClassification = CustomerContent;
            //TableRelation = "NS_Job Takeoff Segments"."NS_Segment Code" WHERE("NS_Job No." = FIELD("Job No."));
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

        //PRJ-939.JS.1.0 27Sep2021 - start
        field(14021140; "NS_Retention Base Amount"; Decimal)
        {
            Caption = 'Retention Base Amount';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            editable = false;
        }
        field(14021144; "NS_Retention Base Before Tax"; Decimal)
        {
            Caption = 'Retention Base Before Tax';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            editable = false;
        }
        //PRJ-939.JS.1.0 27Sep2021 - end     

        field(14021433; "NS_Sub-Level to Job No."; Code[20])    //PRJ-1015.JS.1.0  19Oct2021
        {
            Caption = 'Sub-Level to Job No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            TableRelation = Job;
            Editable = false;
        }
        //PRJCTPR-256.JS.1.0 - Start
        field(14021322; "NS_PPJMP Details"; Text[100])
        {
            Caption = 'JMP Details';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        //PRJCTPR-256.JS.1.0 - end 


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
      +     14021408 JMP Details
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +
      +  - Modified:
      +     - Added Keys
      +         Retention Applies
      +     - Added Ledger to end of Type Option string
      +     - Modified Type OptionString to end in Ledger
      +     - Modify fields to allow for a Ledger type record
      +         Type
      +------------------------------------------------------------*/

}

