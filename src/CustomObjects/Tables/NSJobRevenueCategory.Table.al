table 14021177 "NS_Job Revenue Category"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job Revenue Category';

    DrillDownPageID = "NS_Job Revenue Categories";
    LookupPageID = "NS_Job Revenue Categories";

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
            OptionCaption = ' ,Labor,Material,Equipment,Subcontract,Manufacturing,Overhead,Miscellaneous';
            OptionMembers = " ",Labor,Material,Equipment,Subcontract,Manufacturing,Overhead,Miscellaneous;
            DataClassification = CustomerContent;
        }
        field(4; "NS_Summarize on G703"; Boolean)
        {
            Caption = 'Summarize on G703';
            DataClassification = CustomerContent;
        }
        field(10; "NS_ExcludeFromPctofCompletion"; Boolean)
        {
            Caption = 'Exclude From Pct of Completion';
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
    }
}

