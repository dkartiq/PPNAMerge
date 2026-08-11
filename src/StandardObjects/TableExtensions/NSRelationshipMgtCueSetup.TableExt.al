tableextension 14021236 NS_RelationshipMgtCueSetup extends "Relationship Mgmt. Cue"
{
    // version NAVW111.00,PPNA11.00

    fields
    {
        field(14021100; "NS_Open Job Quotes"; Integer)
        {
            //PE-300.Dk.1.0  29May2024 Start
            // CalcFormula = Count ("NS_Job Quote Header" WHERE(NS_Status = FILTER(Open)));
            CalcFormula = Count("NS_Job Quote Header" WHERE("NS_Quote Status" = FILTER(Open)));
            //PE-300.Dk.1.0  29May2024 End
            Caption = 'Open Job Quotes';
            Description = 'ProjectPro';
            FieldClass = FlowField;

        }
    }
}

//   --------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021100 Open Job Quotes
//   +
//   +-----------------------------------------------------------------------------------------------