table 14021382 "NS_Payroll Register Ledger"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-221.AS.1.0 29MAY2020 - Added Skill Class & Payroll No. field
    //PRJ-384.AS.1.0 11SEPT2020 Removed Inverted commas from Gender field
    Caption = 'Payroll Register Ledger';

    fields
    {
        field(1; "NS_Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(2; "NS_Company ID"; Text[4])
        {
            Caption = 'Company ID';
            DataClassification = CustomerContent;
        }
        field(3; "NS_EE ID No."; Text[6])
        {
            Caption = 'EE ID No.';
            DataClassification = CustomerContent;
        }
        field(4; "NS_Employee Name"; Text[50])
        {
            Caption = 'Employee Name';
            DataClassification = CustomerContent;
        }
        field(5; "NS_EE Address 1"; Text[30])
        {
            Caption = 'EE Address 1';
            DataClassification = CustomerContent;
        }
        field(6; "NS_EE Address 2"; Text[30])
        {
            Caption = 'EE Address 2';
            DataClassification = CustomerContent;
        }
        field(7; "NS_EE City"; Text[20])
        {
            Caption = 'EE City';
            DataClassification = CustomerContent;
        }
        field(8; "NS_EE State"; Text[2])
        {
            Caption = 'EE State';
            DataClassification = CustomerContent;
        }
        field(9; "NS_EE Zip"; Text[10])
        {
            Caption = 'EE Zip';
            DataClassification = CustomerContent;
        }
        field(10; "NS_EE Phone No."; Text[20])
        {
            Caption = 'EE Phone No.';
            DataClassification = CustomerContent;
        }
        field(11; "NS_Marital Status"; Text[1])
        {
            Caption = 'Marital Status';
            DataClassification = CustomerContent;
        }
        field(12; NS_Gender; Option)
        {
            Caption = 'Gender';
            OptionCaption = ' ,Male,Female';//PRJ-384.AS.1.0 11SEPT2020
            OptionMembers = " ",Male,Female;
            DataClassification = CustomerContent;
        }
        field(13; "NS_Federal Exemptions"; Integer)
        {
            Caption = 'Federal Exemptions';
            DataClassification = CustomerContent;
        }
        field(14; "NS_EEO Code"; Code[10])
        {
            Caption = 'EEO Code';
            DataClassification = CustomerContent;
        }
        field(15; "NS_Employee Class"; Text[2])
        {
            Caption = 'Employee Class';
            DataClassification = CustomerContent;
        }
        field(16; "NS_Trade License"; Text[20])
        {
            Caption = 'Trade License';
            DataClassification = CustomerContent;
        }
        field(17; "NS_Union Code"; Text[5])
        {
            Caption = 'Union Code';
            DataClassification = CustomerContent;
        }
        field(18; "NS_Union Dues"; Decimal)
        {
            Caption = 'Union Dues';
            DataClassification = CustomerContent;
        }
        field(19; "NS_Social Security No."; Text[11])
        {
            Caption = 'Social Security No.';
            DataClassification = CustomerContent;
        }
        field(20; "NS_Period End Date"; Date)
        {
            Caption = 'Period End Date';
            DataClassification = CustomerContent;
        }
        field(21; "NS_Check No."; Text[10])
        {
            Caption = 'Check No.';
            DataClassification = CustomerContent;
        }
        field(22; "NS_Voucher No."; Text[30])
        {
            Caption = 'Voucher No.';
            DataClassification = CustomerContent;
        }
        field(23; "NS_Cost No."; Text[50])
        {
            Caption = 'Cost No.';
            DataClassification = CustomerContent;
        }
        field(24; "NS_Basic Rate"; Decimal)
        {
            Caption = 'Basic Rate';
            DataClassification = CustomerContent;
        }
        field(25; "NS_Regular Hours"; Decimal)
        {
            Caption = 'Regular Hours';
            DataClassification = CustomerContent;
        }
        field(26; "NS_OT Hours"; Decimal)
        {
            Caption = 'OT Hours';
            DataClassification = CustomerContent;
        }
        field(27; "NS_Regular Earnings"; Decimal)
        {
            Caption = 'Regular Earnings';
            DataClassification = CustomerContent;
        }
        field(28; "NS_OT Earnings"; Decimal)
        {
            Caption = 'OT Earnings';
            DataClassification = CustomerContent;
        }
        field(29; "NS_Other Hours"; Decimal)
        {
            Caption = 'Other Hours';
            DataClassification = CustomerContent;
        }
        field(30; "NS_Other Earnings"; Decimal)
        {
            Caption = 'Other Earnings';
            DataClassification = CustomerContent;
        }
        field(31; "NS_Gross Pay"; Decimal)
        {
            Caption = 'Gross Pay';
            DataClassification = CustomerContent;
        }
        field(32; "NS_Federal Tax"; Decimal)
        {
            Caption = 'Federal Tax';
            DataClassification = CustomerContent;
        }
        field(33; NS_FICA; Decimal)
        {
            Caption = 'FICA';
            DataClassification = CustomerContent;
        }
        field(34; "NS_State Tax"; Decimal)
        {
            Caption = 'State Tax';
            DataClassification = CustomerContent;
        }
        field(35; "NS_City / Local Tax"; Decimal)
        {
            Caption = 'City / Local Tax';
            DataClassification = CustomerContent;
        }
        field(36; "NS_Voulentary Deductions"; Decimal)
        {
            Caption = 'Voulentary Deductions';
            DataClassification = CustomerContent;
        }
        field(37; "NS_Direct Deposit Amount"; Decimal)
        {
            Caption = 'Direct Deposit Amount';
            DataClassification = CustomerContent;
        }
        field(38; "NS_Net Pay"; Decimal)
        {
            Caption = 'Net Pay';
            DataClassification = CustomerContent;
        }
        field(39; "NS_Apprentice Percent"; Integer)
        {
            Caption = 'Apprentice Percent';
            MaxValue = 99;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(40; "NS_OT Supplemental BenefitRate"; Decimal)
        {
            Caption = 'OT Supplemental Benefit Rate';
            DataClassification = CustomerContent;
        }
        field(41; "NS_Per Head Tax"; Decimal)
        {
            Caption = 'Per Head Tax';
            Description = 'Only Used in the city of Denver, CO';
            DataClassification = CustomerContent;
        }
        field(42; "NS_RegularSupplementalBenRate"; Decimal)
        {
            Caption = 'Regular Supplemental Ben. Rate';
            DataClassification = CustomerContent;
        }
        field(43; "NS_Supp. BenefitsEmployeePaid"; Boolean)
        {
            Caption = 'Supp. Benefits Employee Paid';
            DataClassification = CustomerContent;
        }
        field(44; "NS_Supp. Benefits Other Paid"; Boolean)
        {
            Caption = 'Supp. Benefits Other Paid';
            DataClassification = CustomerContent;
        }
        field(45; "NS_Supp. Benefits Union Paid"; Boolean)
        {
            Caption = 'Supp. Benefits Union Paid';
            DataClassification = CustomerContent;
        }
        field(46; NS_SUI; Decimal)
        {
            Caption = 'SUI';
            DataClassification = CustomerContent;
        }
        field(47; "NS_Supp. Benefits Paid"; Decimal)
        {
            Caption = 'Supp. Benefits Paid';
            DataClassification = CustomerContent;
        }
        field(100; "NS_Include in CertifiedPayroll"; Boolean)
        {
            Caption = 'Include in Certified Payroll';
            DataClassification = CustomerContent;
        }
        field(101; "NS_Date Imported"; DateTime)
        {
            Caption = 'Date Imported';
            DataClassification = CustomerContent;
        }
        field(102; "NS_PR. Register LedgerBatchNo."; Integer)
        {
            Caption = 'PR. Register Ledger Batch No.';
            TableRelation = "NS_Payroll RegisterLedgerBatch"."NS_No.";
            DataClassification = CustomerContent;
        }
        field(103; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job."No.";
            DataClassification = CustomerContent;
        }
        field(104; "NS_Work Date"; Date)
        {
            Caption = 'Work Date';
            DataClassification = CustomerContent;
        }
        //PRJ-221.AS.1.0 29MAY2020 -START
        field(105; "NS_Skill Class"; Code[10])
        {
            Caption = 'Skill Class';
            TableRelation = "NS_Skill Class".NS_Code;
            DataClassification = CustomerContent;
        }
        field(106; "NS_Payroll No."; Code[10])
        {
            Caption = 'Payroll No.';
            DataClassification = CustomerContent;
        }
        //PRJ-221.AS.1.0 29MAY2020 -END
    }

    keys
    {
        key(Key1; "NS_Entry No.")
        {
        }
        key(Key2; "NS_PR. Register LedgerBatchNo.", "NS_Company ID", "NS_EE ID No.")
        {
        }
        key(Key3; "NS_Period End Date", "NS_EE ID No.")
        {
        }
        key(Key4; "NS_Job No.", "NS_Company ID")
        {
        }
        key(Key5; "NS_Job No.", "NS_Period End Date", "NS_Include in CertifiedPayroll", "NS_EE ID No.", "NS_Employee Class")
        {
        }
    }

    fieldgroups
    {
    }
}

