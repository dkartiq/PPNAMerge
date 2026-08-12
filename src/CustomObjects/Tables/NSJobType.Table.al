table 14021175 "NS_Job Type"
{
    // "a3b03edf-3f59-46a5-9644-a1f4a6b1d289"
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job Type';
    DrillDownPageID = "NS_Job Types";
    LookupPageID = "NS_Job Types";

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
    }

    keys
    {
        key(Key1; "NS_Code")
        {
        }
    }

    fieldgroups
    {
        // >> Upgrade
        fieldgroup(DropDown; NS_Code, NS_Description)
        {
        }
        // << Upgrade
    }
}

