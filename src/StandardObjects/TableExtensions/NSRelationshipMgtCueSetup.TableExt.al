tableextension 14021236 NS_RelationshipMgtCueSetup extends "Relationship Mgmt. Cue"
{
    // version NAVW111.00,PPNA11.00
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    fields
    {
        field(14021100; "NS_Open Job Quotes"; Integer)
        {
            CalcFormula = Count("NS_Job Quote Header" WHERE(NS_Status = FILTER(Created)));
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