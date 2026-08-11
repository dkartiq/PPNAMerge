tableextension 14021130 NS_Resource extends Resource
{
    // version NAVW111.00.00.21836,PPNA11.00
    //PRJ-490.MS.1.0 added new field
    //PRJ-991.GK.2.0 22Oct2021 | Add new field.

    fields
    {

        //Unsupported feature: Change OptionString on "Type(Field 2)". Please convert manually.


        field(14021101; "NS_Job Cost Category"; Code[10])
        {
            Caption = 'Job Cost Category';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Cost Category";
            DataClassification = CustomerContent;
        }
        field(14021102; "NS_Job Revenue Category"; Code[10])
        {
            Caption = 'Job Revenue Category';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Revenue Category";
            DataClassification = CustomerContent;
        }
        field(14021400; "NS_Resource is Purchasable"; Boolean)
        {
            Caption = 'Resource is Purchasable';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021401; "NS_Res. FA No."; code[20])
        {
            Caption = 'Res. FA No.';
            Description = 'PRJ-490.MS.1.0';
            DataClassification = CustomerContent;
            Editable = false;
        }
        //PRJ-568.AS.1.0 18FEB2021 - START
        field(14021399; "NS_Default Job Task No"; Code[20])
        {
            Caption = 'Default Job Task No';
            Description = 'Default Job Task No';
            TableRelation = "Job Task"."Job Task No.";
            DataClassification = CustomerContent;
        }
        //PRJ-568.AS.1.0 18FEB2021 - END
        //PRJ-991.GK.2.0 22Oct2021 start
        field(14021412; "NS_No. Of Active Jobs"; Integer)
        {
            FieldClass = FlowField;
            Caption = 'No. Of Active Jobs';
            CalcFormula = count("NS_Job Crew Resource" where("NS_Resource No." = field("No."), "NS_Job Status" = filter(Open)));
            Editable = false;

        }
        //PRJ-991.GK.2.0 22Oct2021 end

    }


    var
    // PP_HRSetup: Record "Human Resources Setup";
    // PP_Employee: Record Employee;
    // Text14021100: Label 'This resource cannot be set to %1 until it has first been assigned to an employee.';
    /*+---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     14021101 Job Cost Category
      +     14021102 Job Revenue Category
      +     14021400  Resource is Purchasable
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +     PP_HRSetup
      +     PP_Employee
      +
      +  - Added global text constant(s):
      +     Text14021100
      +
      +  - Modification(s):
      +     - Type field: added Expense to the end of the OptionString
      +     - Use Time Sheet field
      +         OnValidate() - prohibit setting to True if the resource has not been assigned to an employee record
      +-----------------------------------------------------------------------------------------------*/
}

