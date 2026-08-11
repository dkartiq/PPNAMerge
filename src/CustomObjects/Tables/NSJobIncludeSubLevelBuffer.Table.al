/// <summary>
/// Table NS_Job Include Sub Levels (ID 14021463).
/// </summary>
/// //PRJ-1399.JS.1.0 16MAY2022
table 14021463 "NS_Job Include Sub Levels"
{

    //PRJ-1015.JS.1.0 05Oct2021

    Caption = 'Job Include Sub Levels Buffer';
    DrillDownPageId = "NS_Job Include Sub Level List";
    LookupPageId = "NS_Job Include Sub Level List";
    Permissions = tabledata "NS_Job Include Sub Levels" = rimd;      //PRJ-1399.JS.1.0 16MAY2022. Temp Rollback


    fields
    {
        field(1; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = CustomerContent;
        }
        field(2; "NS_Job Task No."; Code[20])
        {
            Caption = 'Task No.';
            DataClassification = CustomerContent;
        }
        field(3; "NS_Sub Level Job No."; code[20])
        {
            Caption = 'Sub Level Job No.';
            DataClassification = CustomerContent;
        }
        field(4; "NS_Budgeted Cost"; Decimal)
        {
            Caption = 'Budgeted Cost';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Job Planning Line"."Total Cost (LCY)" where("Job No." = field("NS_Job No."),
                        "Job Task No." = field("NS_Job Task No."), "Line Type" = filter(Budget | "Both Budget and Billable"),
                        "Planning Date" = FIELD("NS_Date Filter")));

        }

        field(5; "NS_Actual Cost"; Decimal)
        {
            Caption = 'Actual Cost';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Job Ledger Entry"."Total Cost (LCY)" where("Job No." = field("NS_Job No."),
                        "Job Task No." = field("NS_Job Task No."), "Entry Type" = const(Usage),
                        "Posting Date" = FIELD("NS_Date Filter")));
        }

        field(6; "NS_Billable Price"; Decimal)
        {
            Caption = 'Billable Price';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Job Planning Line"."Line Amount (LCY)" where("Job No." = field("NS_Job No."),
                        "Job Task No." = field("NS_Job Task No."), "Line Type" = filter(Billable | "Both Budget and Billable"),
                        "Planning Date" = FIELD("NS_Date Filter")));
        }

        field(14021116; "NS_Job Class"; Option)
        {
            Caption = 'Job Class';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            OptionCaption = ' ,Master Job,SubJob,Change Order,Extra Work,Proposed,Template,Work Order';
            OptionMembers = " ","Master Job",SubJob,"Change Order","Extra Work",Proposed,Template,"Work Order";
            Editable = false;
        }

        field(14021262; "NS_Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Description = 'ProjectPro';
            FieldClass = FlowFilter;
        }

        field(14021263; "NS_Total Values"; Decimal)
        {
            Caption = 'Total Values';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 8;
            //BlankZero = true;

        }

    }

    keys
    {
        key(Key1; "NS_Job No.", "NS_Job Task No.")
        {

        }
    }

    fieldgroups
    {
    }
}

