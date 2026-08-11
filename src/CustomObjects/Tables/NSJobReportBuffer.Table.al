table 14021189 "NS_Job Report Buffer"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-259.AS.1.0 Increase descripth from 50 to 100 chars
    Caption = 'Job Report Buffer';

    fields
    {
        field(1; "NS_Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(5; "NS_Record Source"; Option)
        {
            Caption = 'Record Source';
            OptionCaption = 'Job,SubJob';
            OptionMembers = Job,SubJob;
            DataClassification = CustomerContent;
        }
        field(10; "NS_Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Cost,Price';
            OptionMembers = Cost,Price;
            DataClassification = CustomerContent;
        }
        field(13; "NS_Locked Budget Record"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(15; "NS_Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(75; "NS_Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
        }
        field(80; "NS_Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = CustomerContent;
        }
        field(100; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
            DataClassification = CustomerContent;
        }
        field(105; "NS_Job Name"; Text[50])
        {
            Caption = 'Job Name';
            DataClassification = CustomerContent;
        }
        field(110; "NS_Job Description"; Text[100])//PRJ-259.AS.1.0
        {
            Caption = 'Job Description';
            DataClassification = CustomerContent;
        }
        field(120; "NS_Job Task No."; Code[35])
        {
            Caption = 'Job Task No.';
            DataClassification = CustomerContent;
        }
        field(125; NS_Category; Code[10])
        {
            Caption = 'Category';
            TableRelation = IF ("NS_Entry Type" = CONST(Cost)) "NS_Job Cost Category".NS_Code
            ELSE
            IF ("NS_Entry Type" = CONST(Price)) "NS_Job Revenue Category".NS_Code;
            DataClassification = CustomerContent;
        }
        field(150; "NS_Activity Code"; Code[10])
        {
            Caption = 'Activity Code';
            DataClassification = CustomerContent;
        }
        field(155; "NS_Process Code"; Code[10])
        {
            Caption = 'Process Code';
            DataClassification = CustomerContent;
        }
        field(160; "NS_Operation Code"; Code[10])
        {
            Caption = 'Operation Code';
            DataClassification = CustomerContent;
        }
        //PRJ-688.AM.1.0
        field(161; "NS_Section Code"; Code[10])
        {
            Caption = 'Section Code';
            DataClassification = CustomerContent;
        }
        //PRJ-688.AM.1.0
        field(300; "NS_Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = '" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,Retention"';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund,Retention;
            DataClassification = CustomerContent;
        }
        field(305; "NS_Document No."; Text[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(350; NS_Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Resource,Item,G/L Account,Group (Resource),Contract';
            OptionMembers = Resource,Item,"G/L Account","Group (Resource)",Contract;
            DataClassification = CustomerContent;
        }
        field(355; "NS_No."; Code[20])
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
        field(360; "NS_Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = IF (NS_Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("NS_No."));
            DataClassification = CustomerContent;
        }
        field(365; NS_Description; Text[100])//PRJ-259.AS.1.0
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(370; "NS_Unit Of Measure"; Code[10])
        {
            Caption = 'Unit Of Measure';
            DataClassification = CustomerContent;
        }
        field(390; NS_Adjustment; Code[10])
        {
            Caption = 'Adjustment';
            TableRelation = "NS_Adjustment Type".NS_Code;
            DataClassification = CustomerContent;
        }
        field(500; "NS_Budgeted Cost Qty."; Decimal)
        {
            Caption = 'Budgeted Cost Qty.';
            DataClassification = CustomerContent;
        }
        field(505; "NS_Budgeted Price Qty."; Decimal)
        {
            Caption = 'Budgeted Price Qty.';
            DataClassification = CustomerContent;
        }
        field(510; "NS_Budgeted Cost"; Decimal)
        {
            Caption = 'Budgeted Cost';
            DataClassification = CustomerContent;
        }
        field(515; "NS_Budgeted Price"; Decimal)
        {
            Caption = 'Budgeted Price';
            DataClassification = CustomerContent;
        }
        field(550; "NS_Budgeted Work Units"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Budgeted Work Units';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(555; "NS_Budgeted Cost Per Work Unit"; Decimal)
        {
            Caption = 'Budgeted Cost Per Work Unit';
            DataClassification = CustomerContent;
        }
        field(560; "NS_BudgetedPricePerWorkUnit"; Decimal)
        {
            Caption = 'Budgeted Price Per Work Unit';
            DataClassification = CustomerContent;
        }
        field(575; "NS_Locked Budgeted Cost Qty."; Decimal)
        {
            Caption = 'Budgeted Cost Qty.';
            DataClassification = CustomerContent;
        }
        field(576; "NS_Locked Budgeted Price Qty."; Decimal)
        {
            Caption = 'Budgeted Price Qty.';
            DataClassification = CustomerContent;
        }
        field(577; "NS_Locked Budgeted Cost"; Decimal)
        {
            Caption = 'Budgeted Cost';
            DataClassification = CustomerContent;
        }
        field(578; "NS_Locked Budgeted Price"; Decimal)
        {
            Caption = 'Budgeted Price';
            DataClassification = CustomerContent;
        }
        field(579; "NS_Locked Budgeted Work Units"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Budgeted Work Units';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(600; "NS_Actual Cost Qty."; Decimal)
        {
            Caption = 'Actual Cost Qty.';
            DataClassification = CustomerContent;
        }
        field(605; "NS_Actual Price Qty."; Decimal)
        {
            Caption = 'Actual Price Qty.';
            DataClassification = CustomerContent;
        }
        field(610; "NS_Actual Cost"; Decimal)
        {
            Caption = 'Actual Cost';
            DataClassification = CustomerContent;
        }
        field(615; "NS_Actual Price"; Decimal)
        {
            Caption = 'Actual Price';
            DataClassification = CustomerContent;
        }
        field(650; "NS_Actual Work Units"; Decimal)
        {
            Caption = 'Actual Work Units';
            DataClassification = CustomerContent;
        }
        field(655; "NS_Actual Cost Per Work Unit"; Decimal)
        {
            Caption = 'Actual Cost Per Work Unit';
            DataClassification = CustomerContent;
        }
        field(660; "NS_Actual Price Per Work Unit"; Decimal)
        {
            Caption = 'Actual Price Per Work Unit';
            DataClassification = CustomerContent;
        }
        field(675; "NS_Committed Quantity"; Decimal)
        {
            Caption = 'Committed Quantity';
            DataClassification = CustomerContent;
        }
        field(676; "NS_Committed Qty. (Base)"; Decimal)
        {
            Caption = 'Committed Qty. (Base)';
            DataClassification = CustomerContent;
        }
        field(677; "NS_Committed Amount (LCY)"; Decimal)
        {
            Caption = 'Committed Amount (LCY)';
            DataClassification = CustomerContent;
        }
        field(678; "NS_Committed Amount"; Decimal)
        {
            Caption = 'Committed Amount';
            DataClassification = CustomerContent;
        }
        field(700; "NS_Transaction Amount"; Decimal)
        {
            Caption = 'Transaction Amount';
            DataClassification = CustomerContent;
        }
        field(705; "NS_Total Cost"; Decimal)
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
        field(710; "NS_Total Price"; Decimal)
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
        field(715; "NS_Retention Percent"; Decimal)
        {
            Caption = 'Retention Percent';
            DataClassification = CustomerContent;
        }
        field(720; "NS_Retention Amount"; Decimal)
        {
            Caption = 'Retention Amount';
            DataClassification = CustomerContent;
        }
        field(2000; "NS_Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; "NS_Entry No.")
        {
        }
        key(Key2; "NS_Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", NS_Category, NS_Type, "NS_No.", "NS_Variant Code", NS_Adjustment, "NS_Locked Budget Record")
        {
        }
        key(Key3; "NS_Job No.", "NS_Entry Type", NS_Type, "NS_No.", "NS_Variant Code", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", NS_Category, NS_Adjustment)
        {
        }
        key(Key4; "NS_Job No.", "NS_Entry Type", NS_Type, "NS_No.", "NS_Variant Code", "NS_Job Task No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", NS_Category, NS_Adjustment)
        {
        }
        key(Key5; "NS_Posting Date", NS_Type, "NS_No.")
        {
        }
        key(Key6; "NS_Record Source")
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

