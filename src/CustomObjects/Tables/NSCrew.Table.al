table 14021163 NS_Crew
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-949.GK.1.0 01Oct2021 | Add field & Code.

    Caption = 'Crew';

    fields
    {
        field(1; "NS_Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(2; NS_Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;

        }
        //PRJ-949.GK.1.0 01Oct2021 start
        field(3; NS_Active; Boolean)
        {
            Caption = 'Active';
            DataClassification = CustomerContent;
        }
        field(4; "NS_Total Crew Member"; Integer)
        {
            Caption = 'Total Crew Member';
            FieldClass = FlowField;
            CalcFormula = count("NS_Crew Line" WHERE(NS_Code = field(NS_Code)));
            Editable = false;
        }
        field(5; "NS_Active Crew Member"; Integer)
        {
            Caption = 'Active Crew Member';
            FieldClass = FlowField;
            CalcFormula = count("NS_Crew Line" WHERE(NS_Code = field(NS_Code), NS_Active = filter(true)));
            Editable = false;
        }
        field(6; "NS_Inactive Crew Member"; Integer)
        {
            Caption = 'Inactive Crew Member';
            FieldClass = FlowField;
            CalcFormula = count("NS_Crew Line" WHERE(NS_Code = field(NS_Code), NS_Active = filter(false)));
            Editable = false;
        }
        //PRJ-949.GK.1.0 01Oct2021 end
    }

    keys
    {
        key(Key1; "NS_Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; NS_Code, NS_Description) { }    //PRJCTPR-343.JS.1.0 21MAR2024
    }
    //PRJ-949.GK.1.0 01Oct2021 start

    trigger OnInsert()
    begin
        if NS_Code <> '' then
            Validate(NS_Active, true);
    end;
    //PRJ-949.GK.1.0 01Oct2021 end

    trigger OnDelete();
    var
        CrewLine: Record "NS_Crew Line";
    begin
        CrewLine.RESET();
        CrewLine.SETRANGE(NS_Code, NS_Code);
        CrewLine.DELETEALL();
    end;
}

