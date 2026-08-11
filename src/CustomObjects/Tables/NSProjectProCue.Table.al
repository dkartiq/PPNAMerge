table 14021353 "NS_ProjectPro Job Cue"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'ProjectPro Job Cue';

    fields
    {
        field(1; "NS_Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; "NS_Jobs To Complete This Month"; Integer)
        {
            CalcFormula = Count(Job WHERE("NS_Manager Job Status" = CONST(Handover),
                                           "NS_Estimated Completion Date" = FIELD("NS_Date Filter")));
            Caption = 'Jobs To Complete This Month';
            FieldClass = FlowField;
        }
        field(3; "NS_Retention Invoices Due"; Integer)
        {
            Caption = 'Retention Invoices Due';
            DataClassification = CustomerContent;
        }
        field(4; "NS_Job Profit below Estimate"; Integer)
        {
            Caption = 'Job Profit below Estimate';
            DataClassification = CustomerContent;
        }
        field(5; "NS_Open Job Purchase Orders"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("NS_Job No." = FILTER(<> ''),
                                                         "Document Type" = CONST(Order),
                                                         Status = CONST(Open)));
            Caption = 'Open Job Purchase Orders';
            FieldClass = FlowField;
        }
        field(6; "NS_Job CostExceedsContBillings"; Integer)
        {
            Caption = 'Job Cost Exceeds Cont Billings';
            DataClassification = CustomerContent;
        }
        field(20; "NS_Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(21; "NS_Date Filter2"; Date)
        {
            Caption = 'Date Filter2';
            Editable = false;
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; "NS_Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

