table 14021381 "NS_Payroll InterfExportArchive"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Payroll Interf. Export Archive';
    DrillDownPageID = "NS_PayrollInterfArchiveEntries";
    LookupPageID = "NS_PayrollInterfArchiveEntries";

    fields
    {
        field(1; "NS_Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(3; "NS_Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            DataClassification = CustomerContent;
        }
        field(5; "NS_Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(10; "NS_Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;
            DataClassification = CustomerContent;
        }
        field(11; "NS_Employee Name"; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(20; "NS_Override Dept."; Code[20])
        {
            Caption = 'Override Dept.';
            DataClassification = CustomerContent;
        }
        field(30; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
            DataClassification = CustomerContent;
        }
        field(40; NS_Shift; Code[10])
        {
            Caption = 'Shift';
            DataClassification = CustomerContent;
        }
        field(50; "NS_D/E Type"; Option)
        {
            Caption = 'D/E Type';
            OptionCaption = 'Earning,Deduction';
            OptionMembers = Earning,Deduction;
            DataClassification = CustomerContent;
        }
        field(52; "NS_D/E Code"; Code[10])
        {
            Caption = 'D/E Code';
            DataClassification = CustomerContent;
        }
        field(60; NS_Rate; Decimal)
        {
            Caption = 'Rate';
            DecimalPlaces = 0 : 12;
            DataClassification = CustomerContent;
        }
        field(70; NS_Hours; Decimal)
        {
            Caption = 'Hours';
            DecimalPlaces = 0 : 12;
            DataClassification = CustomerContent;
        }
        field(80; NS_Year; Integer)
        {
            BlankZero = true;
            Caption = 'Year';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(81; NS_Month; Integer)
        {
            BlankZero = true;
            Caption = 'Month';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(82; NS_Day; Integer)
        {
            BlankZero = true;
            Caption = 'Day';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(83; NS_Hour; Integer)
        {
            BlankZero = true;
            Caption = 'Hour';
            DataClassification = CustomerContent;
        }
        field(84; NS_Minute; Integer)
        {
            BlankZero = true;
            Caption = 'Minute';
            DataClassification = CustomerContent;
        }
        field(90; NS_Amount; Decimal)
        {
            Caption = 'Amount';
            DecimalPlaces = 2 : 2;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(100; "NS_Sequence No."; Integer)
        {
            Caption = 'Sequence No.';
            DataClassification = CustomerContent;
        }
        field(110; "NS_Override Division"; Code[20])
        {
            Caption = 'Override Division';
            DataClassification = CustomerContent;
        }
        field(120; "NS_Override Branch"; Code[20])
        {
            Caption = 'Override Branch';
            DataClassification = CustomerContent;
        }
        field(130; "NS_Override State"; Text[30])
        {
            Caption = 'Override State';
            DataClassification = CustomerContent;
        }
        field(140; "NS_Override Local"; Code[10])
        {
            Caption = 'Override Local';
            DataClassification = CustomerContent;
        }
        field(150; "NS_State/Local Misc. Field"; Code[1])
        {
            Caption = 'State/Local Misc. Field';
            DataClassification = CustomerContent;
        }
        field(160; "NS_Rate No."; Code[1])
        {
            Caption = 'Rate No.';
            DataClassification = CustomerContent;
        }
        field(170; "NS_Social Security No."; Text[30])
        {
            Caption = 'Social Security No.';
            DataClassification = CustomerContent;
        }
        field(171; "NS_Manual Check No."; Integer)
        {
            Caption = 'Manual Check No.';
            DataClassification = CustomerContent;
        }
        field(1000; "NS_Job Ledger Entry No."; Integer)
        {
            Caption = 'Job Ledger Entry No.';
            Editable = false;
            TableRelation = "Job Ledger Entry";
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
        field(1010; "NS_Work Date"; Date)
        {
            Caption = 'Work Date';
            DataClassification = CustomerContent;
        }
        field(1021; "NS_Export Status Date/Time"; DateTime)
        {
            Caption = 'Export Status Date/Time';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

