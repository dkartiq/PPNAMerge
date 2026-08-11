tableextension 14021144 NS_DocumentEntry extends "Document Entry"
{
    // version NAVW110.00,PPNA11.00

    fields
    {
        field(14021151; "NS_Ledger No."; Code[20])
        {
            Caption = 'Ledger No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            TableRelation = "NS_Retention Ledger Code".NS_Code;

            trigger OnLookup();
            var
                NS_DimensionValue: Record "Dimension Value";
                NS_JobsSetup: Record "Jobs Setup";
            begin
            end;
        }
    }
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +      14021151 Ledger No.
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