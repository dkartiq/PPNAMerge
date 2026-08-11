table 14021375 "NS_Employee Wage Rate"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-159 VT 13-03-20 Code Commented
    //PRJ-158 VT 13-03-20 Code Added
    Caption = 'Employee Wage Rate';

    fields
    {
        field(1; "NS_Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            NotBlank = true;
            TableRelation = Employee;
            DataClassification = CustomerContent;
        }
        field(4; "NS_Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(10; "NS_Skill Class"; Code[10])
        {
            Caption = 'Skill Class';
            TableRelation = "NS_Skill Class";
            DataClassification = CustomerContent;
            //PE-68.Dk.1.0 10April2023 Start
            ObsoleteReason = 'Replace with New Field by increasing code length from 10 to 20';
            ObsoleteState = Pending;
            ObsoleteTag = 'This field will remove in ProjectPro upcoming build 22.0.XX.49984';
            //PE-68.Dk.1.0 10April2023 End
            //PRJ-1557.GK.1.0 26Aug2022 start
            trigger OnValidate()
            var
                NSResourceSkillClass: Record NS_ResourceSkillClass;
                NSEmployee: Record Employee;
                NSResourceSkillClass2: Record NS_ResourceSkillClass;
            begin
                if ("NS_Skill Class" <> '') AND ("NS_Employee No." <> '') then
                    if NSEmployee.Get("NS_Employee No.") AND (NSEmployee."Resource No." <> '') then begin
                        NSResourceSkillClass.Reset();
                        NSResourceSkillClass.SetRange("NS_Resource No.", NSEmployee."Resource No.");
                        NSResourceSkillClass.SetRange("NS_Skill Class Code", "NS_Skill Class");
                        if not NSResourceSkillClass.FindFirst() then begin
                            NSResourceSkillClass2.Init();
                            NSResourceSkillClass2.Validate("NS_Resource No.", NSEmployee."Resource No.");
                            NSResourceSkillClass2.Validate("NS_Skill Class Code", "NS_Skill Class");
                            NSResourceSkillClass2.Insert();
                        end;
                    end;
            end;
            // PRJ-1557.GK.1.0 26Aug2022 end
        }
        //PE-68.Dk.1.0 10April2023 Start
        field(11; "NS_Skill Class New"; Code[20])
        {
            Caption = 'Skill Class';
            TableRelation = "NS_Skill Class";
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                NSResourceSkillClass: Record NS_ResourceSkillClass;
                NSEmployee: Record Employee;
                NSResourceSkillClass2: Record NS_ResourceSkillClass;
            begin
                if ("NS_Skill Class New" <> '') AND ("NS_Employee No." <> '') then
                    if NSEmployee.Get("NS_Employee No.") AND (NSEmployee."Resource No." <> '') then begin
                        NSResourceSkillClass.Reset();
                        NSResourceSkillClass.SetRange("NS_Resource No.", NSEmployee."Resource No.");
                        NSResourceSkillClass.SetRange("NS_Skill Class Code", "NS_Skill Class New");
                        if not NSResourceSkillClass.FindFirst() then begin
                            NSResourceSkillClass2.Init();
                            NSResourceSkillClass2.Validate("NS_Resource No.", NSEmployee."Resource No.");
                            NSResourceSkillClass2.Validate("NS_Skill Class Code", "NS_Skill Class New");
                            NSResourceSkillClass2.Insert();
                        end;
                    end;
            end;
        }
        //PE-68.Dk.1.0 10April2023 End
        field(20; "NS_Work Type Code"; Code[10])
        {
            Caption = 'Work Type';
            TableRelation = "Work Type";
            DataClassification = CustomerContent;
        }
        field(30; "NS_Wage Rate"; Decimal)
        {
            Caption = 'Wage Rate';
            DataClassification = CustomerContent;
        }
        field(40; "NS_Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(100; "NS_Fringe - Insurance"; Decimal)
        {
            BlankZero = true;
            Caption = 'Fringe - Insurance';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                NS_CalculateFringeTotal;
            end;
        }
        field(110; "NS_Fringe - Vacation Time"; Decimal)
        {
            BlankZero = true;
            Caption = 'Fringe - Vacation Time';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                NS_CalculateFringeTotal;
            end;
        }
        field(120; "NS_Fringe - Education"; Decimal)
        {
            BlankZero = true;
            Caption = 'Fringe - Education';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                NS_CalculateFringeTotal;
            end;
        }
        field(130; "NS_Fringe - Misc. 1"; Decimal)
        {
            BlankZero = true;
            Caption = 'Fringe - Misc. 1';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                NS_CalculateFringeTotal;
            end;
        }
        field(140; "NS_Fringe - Misc. 2"; Decimal)
        {
            BlankZero = true;
            Caption = 'Fringe - Misc. 2';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                NS_CalculateFringeTotal;
            end;
        }
        field(150; "NS_Fringe - Misc. 3"; Decimal)
        {
            BlankZero = true;
            Caption = 'Fringe - Misc. 3';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                NS_CalculateFringeTotal;
            end;
        }
        field(190; "NS_Fringe Total"; Decimal)
        {
            Caption = 'Fringe Total';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(200; "NS_Effective Date"; Date)
        {
            Caption = 'Effective Date';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Employee No.", "NS_Line No.")
        {
        }
        key(Key2; "NS_Skill Class", "NS_Work Type Code", "NS_Effective Date")
        {
            ObsoleteState = Pending;//PE-68.Dk.1.0 10April2023
            ObsoleteReason = 'To increase the length for NS_Skill Class field';//PE-68.Dk.1.0 10April2023
            ObsoleteTag = 'Will be removed in ProjectProUpcoming App 22.0.XXXX build';//PE-68.Dk.1.0 10April2023
        }
        //PE-68.Dk.1.0 10April2023 Start
        key(Key3; "NS_Skill Class New", "NS_Work Type Code", "NS_Effective Date")
        {
        }
        //PE-68.Dk.1.0 10April2023 End
    }

    fieldgroups
    {
    }

    trigger OnModify();
    begin
        TESTFIELD("NS_Work Type Code");
        if "NS_Effective Date" = 0D then
            MESSAGE(Text001);
    end;

    var
        Text001: Label 'Warning, entries without an Effective Date are ignored by the system.';
        Employee: Record Employee;
        EmployeeWageRate: Record "NS_Employee Wage Rate";
        JobResourcePrice: Record "Job Resource Price";
        Resource: Record Resource;
        Text003: Label 'User entered rates.';
        Text004: Label 'System calculated based on Employee Rates.';
        Text005: Label 'System calculated based on Prevailing Rates.';
        Text006: Label 'System calculated, wage rate based on Prevailing Rate';
        Text007: Label 'System calculated, wage rate based on Employee Rate';
        Text008: Label ', with Fringe adjustment';
        Text009: Label ', no Fringe adjustment';
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        UnitAmountRoundingPrecision: Decimal;

    procedure NS_CalculateFringeTotal();
    begin
        "NS_Fringe Total" := "NS_Fringe - Insurance" + "NS_Fringe - Vacation Time" + "NS_Fringe - Education" +
                          "NS_Fringe - Misc. 1" + "NS_Fringe - Misc. 2" + "NS_Fringe - Misc. 3";
    end;

    procedure NS_CalculateWagesJobJournal(var JobJnlLine: Record "Job Journal Line");
    begin
        if JobJnlLine.Type = JobJnlLine.Type::Resource then
            if JobJnlLine."No." <> '' then begin
                //Get Employee Card Wage Rates
                JobJnlLine."NS_Employee Wage Rate" := 0;
                JobJnlLine."NS_Employee Fringe - Insurance" := 0;
                JobJnlLine."NS_Employee Fringe - Vacation" := 0;
                JobJnlLine."NS_Employee Fringe - Education" := 0;
                JobJnlLine."NS_Employee Fringe - Misc. 1" := 0;
                JobJnlLine."NS_Employee Fringe - Misc. 2" := 0;
                JobJnlLine."NS_Employee Fringe - Misc. 3" := 0;
                JobJnlLine."NS_Employee Fringe Total" := 0;
                Employee.RESET();
                Employee.SETCURRENTKEY("Resource No.");
                Employee.SETRANGE("Resource No.", JobJnlLine."No.");
                if Employee.FINDFIRST() then begin
                    //Match on Skill Class,Work Type Code,Effective Date
                    EmployeeWageRate.RESET();
                    //PE-68.Dk.1.0 10April2023 Start
                    //EmployeeWageRate.SETCURRENTKEY("NS_Skill Class", "NS_Work Type Code", "NS_Effective Date");
                    EmployeeWageRate.SETCURRENTKEY("NS_Skill Class New", "NS_Work Type Code", "NS_Effective Date");
                    //PE-68.Dk.1.0 10April2023 End
                    EmployeeWageRate.SETRANGE("NS_Employee No.", Employee."No.");
                    //PE-68.Dk.1.0 10April2023 Start
                    // EmployeeWageRate.SETRANGE("NS_Skill Class", JobJnlLine."NS_Skill Class");
                    EmployeeWageRate.SETRANGE("NS_Skill Class New", JobJnlLine."NS_Skill Class New");
                    //PE-68.Dk.1.0 10April2023 End
                    EmployeeWageRate.SETRANGE("NS_Work Type Code", JobJnlLine."Work Type Code");
                    EmployeeWageRate.SETFILTER("NS_Effective Date", '..%1', JobJnlLine."Posting Date");
                    if EmployeeWageRate.FINDLAST() then begin
                        JobJnlLine."NS_Employee Wage Rate" := EmployeeWageRate."NS_Wage Rate";
                        JobJnlLine."NS_Employee Fringe - Insurance" := EmployeeWageRate."NS_Fringe - Insurance";
                        JobJnlLine."NS_Employee Fringe - Vacation" := EmployeeWageRate."NS_Fringe - Vacation Time";
                        JobJnlLine."NS_Employee Fringe - Education" := EmployeeWageRate."NS_Fringe - Education";
                        JobJnlLine."NS_Employee Fringe - Misc. 1" := EmployeeWageRate."NS_Fringe - Misc. 1";
                        JobJnlLine."NS_Employee Fringe - Misc. 2" := EmployeeWageRate."NS_Fringe - Misc. 2";
                        JobJnlLine."NS_Employee Fringe - Misc. 3" := EmployeeWageRate."NS_Fringe - Misc. 3";
                        JobJnlLine."NS_Employee Fringe Total" := EmployeeWageRate."NS_Fringe Total";
                    end else begin
                        //Match on Skill Class=<blank>,Work Type Code,Effective Date
                        //PE-68.Dk.1.0 10April2023 Start
                        // EmployeeWageRate.SETRANGE("NS_Skill Class", '');
                        EmployeeWageRate.SETRANGE("NS_Skill Class New", '');
                        //PE-68.Dk.1.0 10April2023 End
                        if EmployeeWageRate.FINDFIRST() then begin
                            JobJnlLine."NS_Employee Wage Rate" := EmployeeWageRate."NS_Wage Rate";
                            JobJnlLine."NS_Employee Fringe - Insurance" := EmployeeWageRate."NS_Fringe - Insurance";
                            JobJnlLine."NS_Employee Fringe - Vacation" := EmployeeWageRate."NS_Fringe - Vacation Time";
                            JobJnlLine."NS_Employee Fringe - Education" := EmployeeWageRate."NS_Fringe - Education";
                            JobJnlLine."NS_Employee Fringe - Misc. 1" := EmployeeWageRate."NS_Fringe - Misc. 1";
                            JobJnlLine."NS_Employee Fringe - Misc. 2" := EmployeeWageRate."NS_Fringe - Misc. 2";
                            JobJnlLine."NS_Employee Fringe - Misc. 3" := EmployeeWageRate."NS_Fringe - Misc. 3";
                            JobJnlLine."NS_Employee Fringe Total" := EmployeeWageRate."NS_Fringe Total";
                        end;
                    end;
                end;
                //Get Job Resource Costs (Prevailing Rates)
                JobJnlLine."NS_Prevailing Wage Rate" := 0;
                JobJnlLine."NS_Prevailing Fringe Rate" := 0;
                if JobJnlLine."Job No." <> '' then begin
                    //Match on Job Task No.,Type=Resource,Code=Resource No.,Work Type Code,Skill Class Code
                    JobResourcePrice.RESET();
                    JobResourcePrice.SETRANGE("Job No.", JobJnlLine."Job No.");
                    JobResourcePrice.SETRANGE("Job Task No.", JobJnlLine."Job Task No.");
                    JobResourcePrice.SETRANGE(Type, JobResourcePrice.Type::Resource);
                    JobResourcePrice.SETRANGE(Code, JobJnlLine."No.");
                    JobResourcePrice.SETRANGE("Work Type Code", JobJnlLine."Work Type Code");
                    //PE-68.Dk.1.0 10April2023 Start
                    // JobResourcePrice.SETRANGE("NS_Skill Class Code", JobJnlLine."NS_Skill Class");
                    JobResourcePrice.SETRANGE("NS_Skill Class Code New", JobJnlLine."NS_Skill Class New");
                    //PE-68.Dk.1.0 10April2023 End
                    if JobResourcePrice.FINDFIRST() then begin
                        JobJnlLine."NS_Prevailing Wage Rate" := JobResourcePrice."NS_Skill Rate";
                        JobJnlLine."NS_Prevailing Fringe Rate" := JobResourcePrice."NS_Fringe Rate";
                    end else begin
                        //Match on Job Task No.,Type=Resource,Code=Resource No.,Work Type Code,Skill Class Code=<blank>
                        //PE-68.Dk.1.0 10April2023 Start
                        // JobResourcePrice.SETRANGE("NS_Skill Class Code", '');
                        JobResourcePrice.SETRANGE("NS_Skill Class Code New", '');
                        //PE-68.Dk.1.0 10April2023 End
                        if JobResourcePrice.FINDFIRST() then begin
                            JobJnlLine."NS_Prevailing Wage Rate" := JobResourcePrice."NS_Skill Rate";
                            JobJnlLine."NS_Prevailing Fringe Rate" := JobResourcePrice."NS_Fringe Rate";
                        end else begin
                            //Match on Job Task No.=<blank>,Type=Resource,Code=Resource No.,Work Type Code,Skill Class Code
                            JobResourcePrice.SETRANGE("Job Task No.", '');
                            //PE-68.Dk.1.0 10April2023 Start
                            //JobResourcePrice.SETRANGE("NS_Skill Class Code", JobJnlLine."NS_Skill Class");
                            JobResourcePrice.SETRANGE("NS_Skill Class Code New", JobJnlLine."NS_Skill Class New");
                            //PE-68.Dk.1.0 10April2023 End
                            if JobResourcePrice.FINDFIRST() then begin
                                JobJnlLine."NS_Prevailing Wage Rate" := JobResourcePrice."NS_Skill Rate";
                                JobJnlLine."NS_Prevailing Fringe Rate" := JobResourcePrice."NS_Fringe Rate";
                            end else begin
                                //Match on Job Task No.=<blank>,Type=Resource,Code=Resource No.,Work Type Code,Skill Class Code=<blank>
                                //PE-68.Dk.1.0 10April2023 Start
                                // JobResourcePrice.SETRANGE("NS_Skill Class Code", '');
                                JobResourcePrice.SETRANGE("NS_Skill Class Code New", '');
                                //PE-68.Dk.1.0 10April2023 End
                                if JobResourcePrice.FINDFIRST() then begin
                                    JobJnlLine."NS_Prevailing Wage Rate" := JobResourcePrice."NS_Skill Rate";
                                    JobJnlLine."NS_Prevailing Fringe Rate" := JobResourcePrice."NS_Fringe Rate";
                                end else begin
                                    if Resource.GET(JobJnlLine."No.") then
                                        if Resource."Resource Group No." <> '' then begin
                                            //Match on Job Task No.,Type=Group(Resource),Code=Resource Group No.,Work Type Code,Skill Class Code
                                            JobResourcePrice.SETRANGE("Job Task No.", JobJnlLine."Job Task No.");
                                            JobResourcePrice.SETRANGE(Type, JobResourcePrice.Type::"Group(Resource)");
                                            JobResourcePrice.SETRANGE(Code, Resource."Resource Group No.");
                                            //PE-68.Dk.1.0 10April2023 Start
                                            //JobResourcePrice.SETRANGE("NS_Skill Class Code", JobJnlLine."NS_Skill Class");
                                            JobResourcePrice.SETRANGE("NS_Skill Class Code New", JobJnlLine."NS_Skill Class New");
                                            //PE-68.Dk.1.0 10April2023 End
                                            if JobResourcePrice.FINDFIRST() then begin
                                                JobJnlLine."NS_Prevailing Wage Rate" := JobResourcePrice."NS_Skill Rate";
                                                JobJnlLine."NS_Prevailing Fringe Rate" := JobResourcePrice."NS_Fringe Rate";
                                            end else begin
                                                //Match on Job Task No.,Type=Group(Resource),Code=Resource Group No.,Work Type Code,Skill Class Code=<blank>
                                                //PE-68.Dk.1.0 10April2023 Start
                                                // JobResourcePrice.SETRANGE("NS_Skill Class Code", ''); 
                                                JobResourcePrice.SETRANGE("NS_Skill Class Code New", '');
                                                //PE-68.Dk.1.0 10April2023 End
                                                if JobResourcePrice.FINDFIRST() then begin
                                                    JobJnlLine."NS_Prevailing Wage Rate" := JobResourcePrice."NS_Skill Rate";
                                                    JobJnlLine."NS_Prevailing Fringe Rate" := JobResourcePrice."NS_Fringe Rate";
                                                end else begin
                                                    //Match on Job Task No.=<blank>,Type=Group(Resource),Code=Resource Group No.,Work Type Code,Skill Class Code
                                                    JobResourcePrice.SETRANGE("Job Task No.", '');
                                                    //PE-68.Dk.1.0 10April2023 Start
                                                    // JobResourcePrice.SETRANGE("NS_Skill Class Code", JobJnlLine."NS_Skill Class");
                                                    JobResourcePrice.SETRANGE("NS_Skill Class Code New", JobJnlLine."NS_Skill Class New");
                                                    //PE-68.Dk.1.010April2023 End
                                                    if JobResourcePrice.FINDFIRST() then begin
                                                        JobJnlLine."NS_Prevailing Wage Rate" := JobResourcePrice."NS_Skill Rate";
                                                        JobJnlLine."NS_Prevailing Fringe Rate" := JobResourcePrice."NS_Fringe Rate";
                                                    end else begin
                                                        //Match on Job Task No.=<blank>,Type=Group(Resource),Code=Resource Group No.,Work Type Code,Skill Class Code=<blank>
                                                        //PE-68.Dk.1.0 10April2023 Start
                                                        // JobResourcePrice.SETRANGE("NS_Skill Class Code", '');
                                                        JobResourcePrice.SETRANGE("NS_Skill Class Code New", '');
                                                        //PE-68.Dk.1.0 10April2023 End
                                                        if JobResourcePrice.FINDFIRST() then begin
                                                            JobJnlLine."NS_Prevailing Wage Rate" := JobResourcePrice."NS_Skill Rate";
                                                            JobJnlLine."NS_Prevailing Fringe Rate" := JobResourcePrice."NS_Fringe Rate";
                                                        end;
                                                    end;
                                                end;
                                            end;
                                        end;
                                end;
                            end;
                        end;
                    end;
                end;
                //Set Wage Rate to Post and Fringe Rate to Post
                //PRJ-159 VT 13-03-20 begin // Code Commented
                //  if (JobJnlLine."Prevailing Wage Rate" = 0) and (JobJnlLine."Employee Wage Rate" = 0) then begin
                //     JobJnlLine."Unit Cost" := 0;
                //     JobJnlLine."Unit Cost (LCY)" := 0;
                //    JobJnlLine."Wage Calculation Basis" := '';
                //end else begin
                //PRJ-159 VT 13-03-20 End  
                if (JobJnlLine."NS_Prevailing Wage Rate" <> 0) or (JobJnlLine."NS_Employee Wage Rate" <> 0) then begin//PRJ-158 VT 13-03-20 Code Added
                    CLEAR(Currency);
                    Currency.InitRoundingPrecision;
                    UnitAmountRoundingPrecision := Currency."Unit-Amount Rounding Precision";
                    if (JobJnlLine."NS_Prevailing Wage Rate" = 0) and (JobJnlLine."NS_Employee Wage Rate" <> 0) then begin
                        JobJnlLine."Unit Cost" := JobJnlLine."NS_Employee Wage Rate";
                        JobJnlLine."Unit Cost (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(JobJnlLine."Posting Date", JobJnlLine."Currency Code",
                                                                                               JobJnlLine."Unit Cost", JobJnlLine."Currency Factor"),
                                                                                               UnitAmountRoundingPrecision);
                        JobJnlLine."NS_Wage Calculation Basis" := Text004;
                    end else begin
                        if (JobJnlLine."NS_Employee Wage Rate" = 0) and (JobJnlLine."NS_Prevailing Wage Rate" <> 0) then begin
                            JobJnlLine."Unit Cost" := JobJnlLine."NS_Prevailing Wage Rate";
                            JobJnlLine."Unit Cost (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(JobJnlLine."Posting Date", JobJnlLine."Currency Code",
                                                                                                   JobJnlLine."Unit Cost", JobJnlLine."Currency Factor"),
                                                                                                   UnitAmountRoundingPrecision);
                            JobJnlLine."NS_Wage Calculation Basis" := Text005;
                        end else begin
                            if JobJnlLine."NS_Prevailing Wage Rate" >= JobJnlLine."NS_Employee Wage Rate" then begin
                                JobJnlLine."Unit Cost" := JobJnlLine."NS_Prevailing Wage Rate";
                                JobJnlLine."Unit Cost (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(JobJnlLine."Posting Date", JobJnlLine."Currency Code",
                                                                                                       JobJnlLine."Unit Cost", JobJnlLine."Currency Factor"),
                                                                                                       UnitAmountRoundingPrecision);
                                JobJnlLine."NS_Wage Calculation Basis" := Text006;
                            end else begin
                                JobJnlLine."Unit Cost" := JobJnlLine."NS_Employee Wage Rate";
                                JobJnlLine."Unit Cost (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(JobJnlLine."Posting Date", JobJnlLine."Currency Code",
                                                                                                       JobJnlLine."Unit Cost", JobJnlLine."Currency Factor"),
                                                                                                       UnitAmountRoundingPrecision);
                                JobJnlLine."NS_Wage Calculation Basis" := Text007;
                            end;
                        end;
                    end;
                end;
            end;
    end;

    procedure CalculateWagesTimeSheetDetail(var TimeSheetDetail: Record "Time Sheet Detail");
    begin
    end;
}

