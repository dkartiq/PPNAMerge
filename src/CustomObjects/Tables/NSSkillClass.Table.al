table 14021186 "NS_Skill Class"
{
    //PPAL-72.AS.1.0 Added field group property for code & description field show after dropdown
    DataClassification = CustomerContent;
    LookupPageId = "NS_Skill Classes";
    Caption = 'Skill Class';
    fields
    {
        field(1; NS_Code; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';

        }
        field(10; NS_Description; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';

        }
    }

    keys
    {
        key(PK; NS_Code)
        {
            Clustered = true;
        }
    }
    //PPAL-72.AS.1.0 - START
    fieldgroups
    {
        fieldgroup(NS_DropDown; NS_Code, NS_Description)
        {

        }
    }
    //PPAL-72.AS.1.0 - END

}