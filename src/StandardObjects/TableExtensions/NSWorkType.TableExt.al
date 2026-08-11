tableextension 14021133 NS_WorkType extends "Work Type"
{
    // version NAVW17.00,PPNA11.00

    fields
    {
        field(14021100; "NS_Wage Type"; Option)
        {
            Caption = 'Wage Type';
            Description = 'ProjectPro';
            OptionCaption = 'Regular Time,Overtime';
            OptionMembers = "Regular Time",Overtime;
            DataClassification = CustomerContent;
        }
        field(14021101; "NS_Earning Code"; Code[10])
        {
            Caption = 'Earning Code';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
    }
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021100 Wage Type
//   +     14021101 Earning Code
//   +
//   +  - Added function(s):
//   +
//   +  - Added global variable(s):
//   +
//   +  - Added global text constant(s):
//   +
//   +  - Modification(s):
//   +
//   +-----------------------------------------------------------------------------------------------
