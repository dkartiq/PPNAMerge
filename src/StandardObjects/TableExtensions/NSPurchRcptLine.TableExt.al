tableextension 14021125 NS_PurchRcptLine extends "Purch. Rcpt. Line"
{
    // version NAVW111.00.00.23572,PPNA11.00
    //TM-10.AM.1.0 | Added Field
    //PRJ-817.JS.1.0�04Aug2021 | Add fields work unit and work unit of measure
    //PRJ-1015.JS.1.0 22Oct2021 | Add field

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
            IF (Type = const(NS_Ledger)) "NS_Retention Ledger Code".NS_Code;
        }
        field(14021101; "NS_Job Cost Category"; Code[10])
        {
            Caption = 'Job Cost Category';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            TableRelation = "NS_Job Cost Category";
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
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
        }
        field(14021402; "NS_Journal Status"; Option)
        {
            Caption = 'Journal Status';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            OptionCaption = '" ,Journal,Posted"';
            OptionMembers = " ",Journal,Posted;
        }
        field(14021403; "NS_Staged Quantity"; Decimal)
        {
            Caption = 'Staged Quantity';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021404; "NS_Post Accrual"; Boolean)
        {
            Caption = 'Post Accrual';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021405; "NS_Accrual Posted"; Boolean)
        {
            Caption = 'Accrual Posted';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021406; "NS_Accrual Account No."; Code[20])
        {
            Caption = 'Accrual Account No.';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            TableRelation = "G/L Account";
        }
        field(14021407; "NS_Bal. Accrual Account No."; Code[20])
        {
            Caption = 'Bal. Accrual Account No.';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            TableRelation = "G/L Account";
        }
        field(14021408; "NS_Segment Code"; Code[20])
        {
            Caption = 'Segment Code';
            Description = 'TM-10.AM.1.0';
            //TableRelation = "Job Takeoff Segments"."Segment Code" WHERE("Job No." = FIELD("Job No."));
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

        field(14021433; "NS_Sub-Level to Job No."; Code[20])    //PRJ-1015.JS.1.0  19Oct2021
        {
            Caption = 'Sub-Level to Job No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            TableRelation = Job;
            Editable = false;
        }
        //PRJ-1681.GK.1.0 19Oct2022 start
        field(14021434; "NS_JMP Line No."; Integer)
        {
            caption = 'JMP Line No.';
            description = 'ProjectPro';
            DataClassification = CustomerContent;
            Editable = false;

        }
        //PRJ-1681.GK.1.0 19Oct2022 end
        //PRJCTPR-256.JS.1.0 - Start
        field(14021409; "NS_PPSegment Code"; Code[20])
        {
            Caption = 'Segment Code';
            TableRelation = "NS_Job Takeoff Segments"."NS_Segment Code" WHERE("NS_Job No." = FIELD("Job No."));
            DataClassification = CustomerContent;
            editable = false;
        }
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
        key(Key1; NS_Staged)
        {
        }
    }

    /*+---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     14021101 Job Cost Category
      +     14021102 Job Revenue Category
      +     14021112 Work Type Code
      +     14021300 Subcontract No.
      +     14021400 Staged
      +     14021401 JMP Document No.
      +     14021402 Journal Status
      +     14021403 Staged Quantity
      +     14021404 Post Accrual
      +     14021405 Accrual Posted
      +     14021406 Accrual Account No.
      +     14021407 Bal. Accrual Account No.
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +     - Added Keys
      +         Job No.,Job Task No.,No.,Staged
      +     - Modify fields to allow for a Ledger type record
      +         Type
      +         No.
      +-----------------------------------------------------------------------------------------------*/
}

