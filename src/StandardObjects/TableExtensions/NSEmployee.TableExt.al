tableextension 14021225 NS_Employee extends Employee
{
    // version NAVW111.00.00.21836,PPNA11.00

    fields
    {
        field(14021375; "NS_Default Work State"; Text[30])
        {
            Caption = 'Default Work State';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021376; "NS_Include in CertifiedPayroll"; Boolean)
        {
            Caption = 'Certified Payroll';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        //PRJ-1557.GK.1.0 26Aug2022 start
        modify("Resource No.")
        {
            trigger OnAfterValidate()
            var
                NSResourceSkillClass: Record NS_ResourceSkillClass;
                NSEmployeeWageRate: Record "NS_Employee Wage Rate";
                NSResourceSkillClass2: Record NS_ResourceSkillClass;
            begin
                if "Resource No." <> '' then begin
                    NSEmployeeWageRate.Reset();
                    NSEmployeeWageRate.SetRange("NS_Employee No.", "No.");
                    //PE-68.Dk.1.0 10April2023 Start
                    // NSEmployeeWageRate.SetFilter("NS_Skill Class", '<>%1', ''); 
                    NSEmployeeWageRate.SetFilter("NS_Skill Class New", '<>%1', '');
                    //PE-68 Dk.1.0 10April2023 End
                    if NSEmployeeWageRate.FindSet() then begin
                        repeat
                            NSResourceSkillClass.Reset();
                            //PE-68 Dk.1.0  10April2023 Start
                            //NSResourceSkillClass.SetRange("NS_Skill Class Code", NSEmployeeWageRate."NS_Skill Class");
                            NSResourceSkillClass.SetRange("NS_Skill Class Code", NSEmployeeWageRate."NS_Skill Class New");
                            //PE-68 Dk.1.0 10April2023 End
                            NSResourceSkillClass.SetRange("NS_Resource No.", "Resource No.");
                            if not NSResourceSkillClass.FindFirst() then begin
                                NSResourceSkillClass2.Init();
                                NSResourceSkillClass2.Validate("NS_Resource No.", "Resource No.");
                                //PE-68 Dk.1.0 10April2023 Start
                                // NSResourceSkillClass2.Validate("NS_Skill Class Code", NSEmployeeWageRate."NS_Skill Class");
                                NSResourceSkillClass2.Validate("NS_Skill Class Code", NSEmployeeWageRate."NS_Skill Class New");
                                //PE-68 Dk.1.0 10April2023 End
                                NSResourceSkillClass2.Insert();
                            end;

                        until NSEmployeeWageRate.Next() = 0;
                    end;
                end;
            end;
        }
        //PRJ-1557.GK.1.0 26Aug2022 end
    }
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021375 Default Work State
//   +     14021376 Certified Payroll
//   +
//   +  - Modification(s):
//   +     - Added Keys:
//   +         Resource No.
//   +-----------------------------------------------------------------------------------------------