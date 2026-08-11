table 14021384 "NS_WH347 TempTable"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'WH347 TempTable';

    fields
    {
        field(1; "NS_Period End Date"; Date)
        {
            Caption = 'Period End Date';
            DataClassification = CustomerContent;
        }
        field(2; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job."No.";
            DataClassification = CustomerContent;
        }
        field(3; "NS_Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee."No.";
            DataClassification = CustomerContent;
        }
        field(4; "NS_Employee Class"; Text[2])
        {
            Caption = 'Employee Class';
            DataClassification = CustomerContent;
        }
        field(5; "NS_Day 1 Regular Hours"; Decimal)
        {
            Caption = 'Day 1 Regular Hours';
            DataClassification = CustomerContent;
        }
        field(6; "NS_Day 2 Regular Hours"; Decimal)
        {
            Caption = 'Day 2 Regular Hours';
            DataClassification = CustomerContent;
        }
        field(7; "NS_Day 3 Regular Hours"; Decimal)
        {
            Caption = 'Day 3 Regular Hours';
            DataClassification = CustomerContent;
        }
        field(8; "NS_Day 4 Regular Hours"; Decimal)
        {
            Caption = 'Day 4 Regular Hours';
            DataClassification = CustomerContent;
        }
        field(9; "NS_Day 5 Regular Hours"; Decimal)
        {
            Caption = 'Day 5 Regular Hours';
            DataClassification = CustomerContent;
        }
        field(10; "NS_Day 6 Regular Hours"; Decimal)
        {
            Caption = 'Day 6 Regular Hours';
            DataClassification = CustomerContent;
        }
        field(11; "NS_Day 7 Regular Hours"; Decimal)
        {
            Caption = 'Day 7 Regular Hours';
            DataClassification = CustomerContent;
        }
        field(13; "NS_Day 1 Overtime Hours"; Decimal)
        {
            Caption = 'Day 1 Overtime Hours';
            DataClassification = CustomerContent;
        }
        field(14; "NS_Day 2 Overtime Hours"; Decimal)
        {
            Caption = 'Day 2 Overtime Hours';
            DataClassification = CustomerContent;
        }
        field(15; "NS_Day 3 Overtime Hours"; Decimal)
        {
            Caption = 'Day 3 Overtime Hours';
            DataClassification = CustomerContent;
        }
        field(16; "NS_Day 4 Overtime Hours"; Decimal)
        {
            Caption = 'Day 4 Overtime Hours';
            DataClassification = CustomerContent;
        }
        field(17; "NS_Day 5 Overtime Hours"; Decimal)
        {
            Caption = 'Day 5 Overtime Hours';
            DataClassification = CustomerContent;
        }
        field(18; "NS_Day 6 Overtime Hours"; Decimal)
        {
            Caption = 'Day 6 Overtime Hours';
            DataClassification = CustomerContent;
        }
        field(19; "NS_Day 7 Overtime Hours"; Decimal)
        {
            Caption = 'Day 7 Overtime Hours';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Period End Date", "NS_Job No.", "NS_Employee No.", "NS_Employee Class")
        {
        }
    }

    fieldgroups
    {
    }
}

