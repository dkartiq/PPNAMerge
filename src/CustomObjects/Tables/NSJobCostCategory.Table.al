table 14021176 "NS_Job Cost Category"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-511.AM.1.0 | Added Dropdown property.

    Caption = 'Job Cost Category';
    DrillDownPageID = "NS_Job Cost Categories";
    LookupPageID = "NS_Job Cost Categories";

    fields
    {
        field(1; "NS_Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(2; NS_Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; NS_Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Labor,Material,Equipment,Subcontract,Manufacturing,Overhead,Miscellaneous';//PRJ-384.AM.1.0
            OptionMembers = " ",Labor,Material,Equipment,Subcontract,Manufacturing,Overhead,Miscellaneous;
            DataClassification = CustomerContent;
        }
        field(10; "NS_G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(20; "NS_Activity Code"; Code[10])
        {
            Caption = 'Activity Code';
            TableRelation = "NS_Job Activity".NS_Code WHERE(NS_Type = CONST(Cost));
            DataClassification = CustomerContent;
        }
        field(21; "NS_Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            Description = 'ProjectPro';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Code")
        {
        }
        key(Key2; "NS_Activity Code")
        {
        }
    }

    fieldgroups
    {
        //PRJ-511.AM.1.0 Start
        fieldgroup(DropDown; NS_Code, NS_Description, NS_Type)
        {

        }
        //PRJ-511.AM.1.0 End
    }
}

