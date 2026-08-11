tableextension 14021143 NS_RequisitionLine extends "Requisition Line"
{
    // version NAVW111.00.00.25466,PPNA11.00
    //TM-10.AM.1.0 | Added Field.

    fields
    {

        //SPLN: Not in use: Unsupported feature: Change TableRelation on ""No."(Field 5)". Please convert manually.

        field(14021400; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            Description = 'Project Pro';
            DataClassification = CustomerContent;
        }
        field(14021401; "NS_Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            Description = 'Project Pro';
            DataClassification = CustomerContent;
        }
        field(14021402; "NS_JMP Document No."; Code[20])
        {
            Caption = 'JMP Document No.';
            Description = 'Project Pro';
            DataClassification = CustomerContent;
        }
        field(14021403; "NS_Job Planning Line No."; Integer)
        {
            Caption = 'Job Planning Line No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021404; "NS_Segment Code"; Code[20])
        {
            Caption = 'Segment Code';
            Description = 'TM-10.AM.1.0';
            TableRelation = "NS_Job Takeoff Segments"."NS_Segment Code" WHERE("NS_Job No." = FIELD("NS_Job No."));
            DataClassification = CustomerContent;
        }
    }

}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021400 Job No.
//   +     14021401 Job Task No.
//   +     14021402 JMP Document No.
//   +     14021403 Job Planning Line No.
//   +
//   +  - Added function(s):
//   +
//   +  - Added global variable(s):
//   +
//   +  - Added global text constant(s):
//   +
//   +  - Modification(s):
//   +     - TableRelation
//   +         No.   - Add Type of Resource to TableRelation
//   +     - Fields
//   +         Replenishment System: Test ProdBOMHeader
//   +-----------------------------------------------------------------------------------------------