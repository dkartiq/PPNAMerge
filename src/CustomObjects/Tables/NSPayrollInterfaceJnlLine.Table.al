table 14021380 "NS_Payroll Interface Jnl Line"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-204.MS.1.0 -  change the caption of option field
    //TM-10.AM.1.0  added new fields for payroll interface
    Caption = 'Payroll Interface Jnl Line';

    fields
    {
        field(1; "NS_Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Job Journal Template";
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
        field(2; "NS_Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(3; "NS_Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Job Journal Batch".Name WHERE("Journal Template Name" = FIELD("NS_Journal Template Name"));
            DataClassification = CustomerContent;
        }
        field(5; "NS_Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Document No." <> xRec."NS_Document No." then
                    if "NS_Export Status" = "NS_Export Status"::Exported then
                        ERROR(Text002);
            end;
        }
        field(10; "NS_Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Employee No." <> xRec."NS_Employee No." then begin
                    if "NS_Export Status" = "NS_Export Status"::Exported then
                        ERROR(Text002);
                    "NS_Employee Name" := '';
                    if Employee.GET("NS_Employee No.") then
                        "NS_Employee Name" := COPYSTR(Employee."First Name" + ' ' + Employee."Last Name", 1, 50);
                end;
            end;
        }
        field(11; "NS_Employee Name"; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Employee Name" <> xRec."NS_Employee Name" then
                    if "NS_Export Status" = "NS_Export Status"::Exported then
                        ERROR(Text002);
            end;
        }
        field(20; "NS_Override Dept."; Code[20])
        {
            Caption = 'Override Dept.';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Override Dept." <> xRec."NS_Override Dept." then
                    if "NS_Export Status" = "NS_Export Status"::Exported then
                        ERROR(Text002);
            end;
        }
        field(30; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Job No." <> xRec."NS_Job No." then
                    if "NS_Export Status" = "NS_Export Status"::Exported then
                        ERROR(Text002);
            end;
        }
        field(40; NS_Shift; Code[10])
        {
            Caption = 'Shift';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if NS_Shift <> xRec.NS_Shift then
                    if "NS_Export Status" = "NS_Export Status"::Exported then
                        ERROR(Text002);
            end;
        }
        field(50; "NS_D/E Type"; Option)
        {
            Caption = 'D/E Type';
            OptionCaption = 'Earning,Deduction';
            OptionMembers = Earning,Deduction;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_D/E Type" <> xRec."NS_D/E Type" then
                    if "NS_Export Status" = "NS_Export Status"::Exported then
                        ERROR(Text002);
            end;
        }
        field(52; "NS_D/E Code"; Code[10])
        {
            Caption = 'D/E Code';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_D/E Code" <> xRec."NS_D/E Code" then
                    if "NS_Export Status" = "NS_Export Status"::Exported then
                        ERROR(Text002);
            end;
        }
        field(60; NS_Rate; Decimal)
        {
            Caption = 'Rate';
            DecimalPlaces = 0 : 12;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if NS_Rate <> xRec.NS_Rate then
                    if "NS_Export Status" = "NS_Export Status"::Exported then
                        ERROR(Text002)
                    else
                        NS_CalculateAmount;
            end;
        }
        field(70; NS_Hours; Decimal)
        {
            Caption = 'Hours';
            DecimalPlaces = 0 : 12;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if NS_Hours <> xRec.NS_Hours then
                    if "NS_Export Status" = "NS_Export Status"::Exported then
                        ERROR(Text002)
                    else
                        NS_CalculateAmount;
            end;
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
            BlankZero = true;
            Caption = 'Sequence No.';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Sequence No." <> xRec."NS_Sequence No." then
                    if "NS_Export Status" = "NS_Export Status"::Exported then
                        ERROR(Text002);
            end;
        }
        field(110; "NS_Override Division"; Code[20])
        {
            Caption = 'Override Division';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Override Division" <> xRec."NS_Override Division" then
                    if "NS_Export Status" = "NS_Export Status"::Exported then
                        ERROR(Text002);
            end;
        }
        field(120; "NS_Override Branch"; Code[20])
        {
            Caption = 'Override Branch';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Override Branch" <> xRec."NS_Override Branch" then
                    if "NS_Export Status" = "NS_Export Status"::Exported then
                        ERROR(Text002);
            end;
        }
        field(130; "NS_Override State"; Text[30])
        {
            Caption = 'Override State';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Override State" <> xRec."NS_Override State" then
                    if "NS_Export Status" = "NS_Export Status"::Exported then
                        ERROR(Text002)
                    else
                        if "NS_Override State" = '' then
                            "NS_State/Local Misc. Field" := ''
                        else
                            "NS_State/Local Misc. Field" := 'S';
            end;
        }
        field(140; "NS_Override Local"; Code[10])
        {
            Caption = 'Override Local';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Override Local" <> xRec."NS_Override Local" then
                    if "NS_Export Status" = "NS_Export Status"::Exported then
                        ERROR(Text002);
            end;
        }
        field(150; "NS_State/Local Misc. Field"; Code[1])
        {
            Caption = 'State/Local Misc. Field';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_State/Local Misc. Field" <> xRec."NS_State/Local Misc. Field" then
                    if "NS_Export Status" = "NS_Export Status"::Exported then
                        ERROR(Text002);
            end;
        }
        field(160; "NS_Rate No."; Code[1])
        {
            Caption = 'Rate No.';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if NS_Rate <> xRec.NS_Rate then
                    if "NS_Export Status" = "NS_Export Status"::Exported then
                        ERROR(Text002);
            end;
        }
        field(170; "NS_Social Security No."; Text[30])
        {
            Caption = 'Social Security No.';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Social Security No." <> xRec."NS_Social Security No." then
                    if "NS_Export Status" = "NS_Export Status"::Exported then
                        ERROR(Text002);
            end;
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

            trigger OnLookup();
            var
                JobLedgerEntries: Page "Job Ledger Entries";
                JobLedgerEntry: Record "Job Ledger Entry";
            begin
                CLEAR(JobLedgerEntries);
                JobLedgerEntry.RESET();
                JobLedgerEntry.SETRANGE("Entry No.", "NS_Job Ledger Entry No.");
                JobLedgerEntries.SETTABLEVIEW(JobLedgerEntry);
                JobLedgerEntries.RUNMODAL;
            end;
        }
        field(1010; "NS_Work Date"; Date)
        {
            Caption = 'Work Date';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Work Date" <> xRec."NS_Work Date" then
                    if "NS_Export Status" = "NS_Export Status"::Exported then
                        ERROR(Text002);

                if "NS_Work Date" = 0D then begin
                    NS_Year := 0;
                    NS_Month := 0;
                    NS_Day := 0;
                end else begin
                    NS_Year := DATE2DMY("NS_Work Date", 3);
                    NS_Month := DATE2DMY("NS_Work Date", 2);
                    NS_Day := DATE2DMY("NS_Work Date", 1);
                end;
            end;
        }
        field(1020; "NS_Export Status"; Option)
        {
            Caption = 'Export Status';
            Editable = false;
            OptionCaption = ' ,"Exported"';  //PRJ-204.MS.1.0
            OptionMembers = " ",Exported;
            DataClassification = CustomerContent;
        }
        field(1021; "NS_Export Status Date/Time"; DateTime)
        {
            Caption = 'Export Status Date/Time';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(1022; "NS_Work Type"; Code[10])
        {
            Caption = 'Work Type';
            Description = 'TM-10.AM.1.0';
            DataClassification = CustomerContent;
        }
        field(1023; "NS_Non-Work"; Decimal)
        {
            Caption = 'Non-Work';
            Description = 'TM-10.AM.1.0';
            DataClassification = CustomerContent;
        }
        field(1024; "NS_Working Hours"; Decimal)
        {
            caption = 'Working Hours';
            Description = 'TM-10.AM.1.0';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "NS_Working Hours" > 8 then begin
                    "NS_Reg.Hours" := 8;
                    if ("NS_Working Hours" - 8) >= 4 then
                        "NS_Over Time" := 4
                    else
                        "NS_Over Time" := "NS_Working Hours" - 8;
                    if ("NS_Working Hours" - 8 - 4) > 0 then
                        "NS_Double Time" := ("NS_Working Hours" - 8 - 4)
                    else
                        "NS_Double Time" := 0;

                end else begin
                    "NS_Reg.Hours" := "NS_Working Hours";
                    "NS_Over Time" := 0;
                    "NS_Double Time" := 0;
                end;
                Validate(NS_Hours, "NS_Reg.Hours");

            end;

        }
        field(1025; "NS_Reg.Hours"; Decimal)
        {
            Caption = 'Reg';
            Description = 'TM-10.AM.1.0';
            DataClassification = CustomerContent;
        }
        field(1026; "NS_Over Time"; Decimal)
        {
            Caption = 'OT';
            Description = 'TM-10.AM.1.0';
            DataClassification = CustomerContent;
        }
        field(1027; "NS_Double Time"; Decimal)
        {
            Caption = 'DT';
            Description = 'TM-10.AM.1.0';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(Key1; "NS_Journal Template Name", "NS_Journal Batch Name", "NS_Line No.")
        {
        }
        key(Key2; "NS_Journal Template Name", "NS_Journal Batch Name", "NS_Employee No.", "NS_Work Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        if "NS_Export Status" = "NS_Export Status"::Exported then
            ERROR(Text001);
    end;

    trigger OnInsert();
    begin
        LOCKTABLE();
        PayrollInterfaceJnlTemplate.GET("NS_Journal Template Name");
        PayrollInterfaceJnlBatch.GET("NS_Journal Template Name", "NS_Journal Batch Name");
    end;

    var
        PayrollInterfaceJnlTemplate: Record "NS_PayrollInterfaceJnlTemplate";
        PayrollInterfaceJnlBatch: Record "NS_Payroll Interface Jnl Batch";
        Employee: Record Employee;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text001: Label 'Exported lines cannot be deleted.';
        Text002: Label 'You cannot edit Exported lines.';

    procedure NS_EmptyLine(): Boolean;
    begin
        exit("NS_Employee No." = '');
    end;

    procedure NS_SetUpNewLine(LastPayrollInterfaceJnlLine: Record "NS_Payroll Interface Jnl Line");
    begin
        PayrollInterfaceJnlTemplate.GET("NS_Journal Template Name");
        PayrollInterfaceJnlBatch.GET("NS_Journal Template Name", "NS_Journal Batch Name");
        SETRANGE("NS_Journal Template Name", "NS_Journal Template Name");
        SETRANGE("NS_Journal Batch Name", "NS_Journal Batch Name");
        if FINDFIRST() then
            "NS_Document No." := LastPayrollInterfaceJnlLine."NS_Document No."
        else
            if PayrollInterfaceJnlBatch."NS_No. Series" <> '' then begin
                CLEAR(NoSeriesMgt);
                "NS_Document No." := NoSeriesMgt.TryGetNextNo(PayrollInterfaceJnlBatch."NS_No. Series", WORKDATE);
            end;
    end;

    procedure NS_CalculateAmount();
    var
        Currency: Record Currency;
    begin
        Currency.InitRoundingPrecision;
        NS_Amount := ROUND((NS_Rate * NS_Hours), Currency."Amount Rounding Precision");
    end;
}

