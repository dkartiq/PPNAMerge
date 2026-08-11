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