tableextension 14021224 NS_PurchaseLineArchive extends "Purchase Line Archive"
{
    // version NAVW111.00,NAVNA11.00,PPNA11.00
    //PRJ-817.JS.1.0�04Aug2021 | Add fields work unit and work unit of measure
    //PRJ-1015.JS.1.0 22Oct2021 | Add field

    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge";
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
        field(14021104; "NS_Job Task No."; Code[35])
        {
            Caption = 'Job Task No.';
            Description = 'ProjectPro';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
            DataClassification = CustomerContent;
        }
        field(14021112; "NS_Work Type Code"; Code[10])
        {
            Caption = 'Work Type Code';
            Description = 'ProjectPro';
            TableRelation = "Work Type";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                if "NS_Committed Amount (LCY)" <> xRec."NS_Committed Amount (LCY)" then
                    if Type <> Type::NS_Ledger then
                        ERROR(Text14021100)
                    else
                        if Quantity <> 0 then
                            VALIDATE(Quantity, xRec.Quantity);
                //ProjectPro - end
            end;
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
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
        }
        field(14021118; "NS_Committed Amount"; Decimal)
        {
            Caption = 'Committed Amount';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                Currency2: Record Currency;
            begin
            end;
        }
        field(14021300; "NS_Subcontract No."; Code[20])
        {
            Caption = 'Subcontract No.';
            Description = 'ProjectPro';
            TableRelation = NS_Subcontract;
            DataClassification = CustomerContent;
        }
        field(14021135; "NS_Retention Applies"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Retention Applies';
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

        field(14021433; "NS_Sub-Level to Job No."; Code[20])    //PRJ-1015.JS.1.0  19Oct2021
        {
            Caption = 'Sub-Level to Job No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            TableRelation = Job;
            Editable = false;
        }

    }

    keys
    {
        key(key5; "NS_Retention Applies")
        {

        }
    }

    var
        Text14021100: Label 'Work Type can only be specified for Resource lines.';
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021101 Job Cost Category
//   +     14021102 Job Revenue Category
//   +     14021104 Job Task No.
//   +     14021112 Work Type Code
//   +     14021115 Committed Quantity
//   +     14021116 Committed Qty. (Base)
//   +     14021117 Committed Amount (LCY)
//   +     14021118 Committed Amount
//   +     14021135 Retention Applies
//   +     14021300 Subcontract No.
//   +
//   +  - Added global text constant(s):
//   +     Text14021100
//   +
//   +  - Modification(s):
//   +     Added Keys:
//   +       Retention Applies
//   +     Fields:
//   +       Type  - Added to OptionString
//   +                   Ledger
//   +                   Resource
//   +       No.   - TableRelation - modify 3 to Resource
//   +-----------------------------------------------------------------------------------------------