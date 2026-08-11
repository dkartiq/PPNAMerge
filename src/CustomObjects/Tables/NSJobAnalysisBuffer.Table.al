table 14021182 "NS_Job Analysis Buffer"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-301.N.S.1.0 24Sep2020 change length description,Job name
    //PRJ-1065.JS.1.0 | 08Dec2021 Add two fields

    Caption = 'Job Analysis Buffer';


    fields
    {
        field(1; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';

            TableRelation = Job;
            DataClassification = CustomerContent;
        }
        field(3; "NS_Entry Type"; Option)
        {
            Caption = 'Entry Type';

            OptionCaption = 'Cost,Price';

            OptionMembers = Cost,Price;
            DataClassification = CustomerContent;
        }
        field(5; "NS_Job Task No."; Code[35])
        {
            Caption = 'Job Task No.';

            TableRelation = "NS_Job Activity".NS_Code WHERE(NS_Type = FIELD("NS_Entry Type"));
            DataClassification = CustomerContent;
        }
        field(7; "NS_Activity Code"; Code[10])
        {
            Caption = 'Activity Code';
            DataClassification = CustomerContent;

        }
        field(8; "NS_Process Code"; Code[10])
        {
            Caption = 'Process Code';
            DataClassification = CustomerContent;

        }
        field(9; "NS_Operation Code"; Code[10])
        {
            Caption = 'Operation Code';
            DataClassification = CustomerContent;

        }
        //PRJ-688.AM.1.0
        field(12; "NS_Section Code"; Code[10])
        {
            Caption = 'Section Code';
            DataClassification = CustomerContent;

        }
        //PRJ-688.AM.1.0
        field(10; "NS_Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;

        }
        field(11; "NS_Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;

        }
        field(15; NS_Category; Code[10])
        {
            Caption = 'Category';

            TableRelation = IF ("NS_Entry Type" = CONST(Cost)) "NS_Job Cost Category".NS_Code
            ELSE
            IF ("NS_Entry Type" = CONST(Price)) "NS_Job Revenue Category".NS_Code;
            DataClassification = CustomerContent;
        }
        field(16; NS_Type; Option)
        {
            Caption = 'Type';

            OptionCaption = 'Resource,Item,G/L Account,Group (Resource),Contract';

            OptionMembers = Resource,Item,"G/L Account","Group (Resource)",Contract;
            DataClassification = CustomerContent;
        }
        field(17; "NS_No."; Code[20])
        {
            Caption = 'No.';

            TableRelation = IF (NS_Type = CONST(Resource)) Resource
            ELSE
            IF (NS_Type = CONST(Item)) Item
            ELSE
            IF (NS_Type = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (NS_Type = CONST("Group (Resource)")) "Resource Group";
            DataClassification = CustomerContent;
        }
        field(18; "NS_Variant Code"; Code[10])
        {
            Caption = 'Variant Code';

            TableRelation = IF (NS_Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("NS_No."));
            DataClassification = CustomerContent;
        }
        field(19; NS_Adjustment; Code[10])
        {
            Caption = 'Adjustment';

            TableRelation = "NS_Adjustment Type".NS_Code;
            DataClassification = CustomerContent;
        }
        field(20; "NS_Document Type"; Option)
        {
            Caption = 'Document Type';

            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,Retention';

            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund,Retention;
            DataClassification = CustomerContent;
        }
        field(21; "NS_Document No."; Text[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;

        }
        field(24; "NS_Job Name"; Text[100])   //PRJ-301.N.S.1.0 24Sep2020
        {
            Caption = 'Job Name';
            DataClassification = CustomerContent;

        }
        field(25; NS_Description; Text[100])		 //PRJ-301.N.S.1.0 24Sep2020
        {
            Caption = 'Description';
            DataClassification = CustomerContent;

        }
        field(30; "NS_Transaction Amount"; Decimal)
        {
            Caption = 'Transaction Amount';
            DataClassification = CustomerContent;

        }
        field(31; "NS_Total Cost"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Job Planning Line"."Total Cost" WHERE("Job No." = FIELD("NS_Job No."),
                                                                      "NS_Entry Type" = CONST(Cost),
                                                                      "Job Task No." = FIELD("NS_Job Task No."),
                                                                      "NS_Cost Category" = FIELD(NS_Category),
                                                                      Type = FIELD(NS_Type),
                                                                      "No." = FIELD("NS_No."),
                                                                      "Variant Code" = FIELD("NS_Variant Code"),
                                                                      "Planning Date" = FIELD("NS_Date Filter"),
                                                                      NS_Adjustment = FIELD(NS_Adjustment)));
            Caption = 'Total Cost';

            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "NS_Total Price"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Job Planning Line"."Total Price" WHERE("Job No." = FIELD("NS_Job No."),
                                                                       "NS_Entry Type" = CONST(Both),
                                                                       "Job Task No." = FIELD("NS_Job Task No."),
                                                                       "NS_Cost Category" = FIELD(NS_Category),
                                                                       Type = FIELD(NS_Type),
                                                                       "No." = FIELD("NS_No."),
                                                                       "Variant Code" = FIELD("NS_Variant Code"),
                                                                       "Planning Date" = FIELD("NS_Date Filter"),
                                                                       NS_Adjustment = FIELD(NS_Adjustment)));
            Caption = 'Total Price';

            Editable = false;
            FieldClass = FlowField;
        }
        field(33; NS_Retention; Decimal)
        {
            Caption = 'Retention';
            DataClassification = CustomerContent;

        }
        field(41; "NS_Actual Cost"; Decimal)
        {
            Caption = 'Actual Cost';

            Editable = false;
            DataClassification = CustomerContent;
        }
        field(42; "NS_Actual Price"; Decimal)
        {
            Caption = 'Actual Price';

            Editable = false;
            DataClassification = CustomerContent;
        }
        field(43; "NS_Actual Cost Qty."; Decimal)
        {
            Caption = 'Actual Cost Qty.';
            DataClassification = CustomerContent;

        }
        field(44; "NS_Actual Price Qty."; Decimal)
        {
            Caption = 'Actual Price Qty.';
            DataClassification = CustomerContent;

        }
        field(45; "NS_Budgeted Cost"; Decimal)
        {
            Caption = 'Budgeted Cost';
            DataClassification = CustomerContent;

        }
        field(46; "NS_Budgeted Price"; Decimal)
        {
            Caption = 'Budgeted Price';
            DataClassification = CustomerContent;

        }
        field(47; "NS_Budgeted Cost Qty."; Decimal)
        {
            Caption = 'Budgeted Cost Qty.';
            DataClassification = CustomerContent;

        }
        field(48; "NS_Budgeted Price Qty."; Decimal)
        {
            Caption = 'Budgeted Price Qty.';
            DataClassification = CustomerContent;

        }
        field(60; "NS_Budgeted Work Units"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Budgeted Work Units';
            DataClassification = CustomerContent;

            Editable = false;
        }
        field(62; "NS_Actual Work Units"; Decimal)
        {
            Caption = 'Actual Work Units';
            DataClassification = CustomerContent;

        }
        field(70; "NS_Percent Value"; Decimal)
        {
            Caption = 'Percent Value';
            DataClassification = CustomerContent;
        }
        field(74; "NS_Calculation Source Code"; Text[1])
        {
            Caption = 'Calculation Source Code';
            DataClassification = CustomerContent;
        }
        field(80; "NS_Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
        }
        field(81; "NS_Vendor No."; Text[20])
        {
            Caption = 'Vendor No.';
            DataClassification = CustomerContent;
        }
        field(100; "NS_Date Filter"; Date)
        {
            Caption = 'Date Filter';

            FieldClass = FlowFilter;
        }
        field(101; "NS_Is Locked"; Boolean)
        {
            Caption = 'Is Locked';
            DataClassification = CustomerContent;
        }

        //PRJ-1065.JS.1.0  08Dec2021
        field(102; "NS_Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            DataClassification = CustomerContent;
        }
        field(103; "NS_Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", NS_Category, NS_Type, "NS_No.", "NS_Variant Code", NS_Adjustment, "NS_Is Locked", "NS_Entry No.")
        {
        }
        key(Key2; "NS_Job No.", "NS_Entry Type", NS_Type, "NS_No.", "NS_Variant Code", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", NS_Category, NS_Adjustment)
        {
        }
        key(Key3; "NS_Job No.", "NS_Entry Type", NS_Type, "NS_No.", "NS_Variant Code", "NS_Job Task No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", NS_Category, NS_Adjustment)
        {
        }
        key(Key4; "NS_Entry No.")
        {
        }
        key(Key5; "NS_Posting Date", NS_Type, "NS_No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        Job.NS_JobTaskNoToAPO("NS_Job Task No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code");//PRJ-688.AM.1.0
    end;

    var
        Job: Record Job;
}

