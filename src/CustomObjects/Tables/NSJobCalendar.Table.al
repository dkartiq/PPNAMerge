table 14021168 "NS_Job Calendar"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job Calendar';
    DataCaptionFields = "NS_Code", NS_Name;
    LookupPageID = "NS_Job Calendar List";

    fields
    {
        field(1; "NS_Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(2; NS_Name; Text[30])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(3; "NS_Custom Changes Exist"; Boolean)
        {
            CalcFormula = Exist("NS_Job Calendar Change" WHERE("NS_Job Calendar Code" = FIELD(NS_Code)));
            Caption = 'Customized Changes Exist';
            Editable = false;
            FieldClass = FlowField;
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

    trigger OnDelete();
    var
        CustCalendarChange: Record "NS_Job Custom Calendar Change";
        JobCalendarLine: Record "NS_Job Calendar Change";
    begin
        CustCalendarChange.RESET();
        CustCalendarChange.SETRANGE("NS_Job Calendar Code", NS_Code);
        if CustCalendarChange.ISEMPTY() then
            ERROR(Text001_Txt, NS_Code);

        JobCalendarLine.RESET();
        JobCalendarLine.SETRANGE("NS_Job Calendar Code", NS_Code);
        JobCalendarLine.DELETEALL();
    end;

    var
        Text001_Txt: Label 'You cannot delete this record. Custom calendar changes exist for calendar code=<%1>.', Comment = '%1 = Calendar Code';
}

