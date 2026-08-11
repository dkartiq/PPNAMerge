table 14021377 "NS_Employee Burden Detail"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Employee Burden Detail';

    fields
    {
        field(1; "NS_Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            NotBlank = true;
            TableRelation = Employee;
            DataClassification = CustomerContent;
        }
        field(4; "NS_Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(10; "NS_Burden Type"; Code[10])
        {
            Caption = 'Burden Type';
            TableRelation = "NS_Burden Type";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Burden Type" <> '' then
                    if BurdenType.GET("NS_Burden Type") then begin
                        NS_Description := BurdenType.NS_Description;
                        "NS_Burden Rate Type" := BurdenType."NS_Default Rate Type";
                    end;
            end;
        }
        field(15; NS_Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(18; "NS_Burden Rate Type"; Option)
        {
            Caption = 'Burden Rate Type';
            OptionCaption = 'Percentage,Flat Rate';
            OptionMembers = Percentage,"Flat Rate";
            DataClassification = CustomerContent;
        }
        field(20; "NS_Burden Rate per Hour"; Decimal)
        {
            Caption = 'Burden Rate per Hour';
            DataClassification = CustomerContent;
        }
        field(200; "NS_Effective Date"; Date)
        {
            Caption = 'Effective Date';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Employee No.", "NS_Line No.")
        {
        }
        key(Key2; "NS_Employee No.", "NS_Effective Date")
        {
        }
    }

    fieldgroups
    {
    }

    var
        BurdenType: Record "NS_Burden Type";

    procedure NS_CalculateBurden(ResourceNo: Code[20]; WageRateToPost: Decimal; Hours: Decimal; PostingDate: Date) BurdenAmountToPost: Decimal;
    var
        Employee: Record Employee;
        EmployeeBurdenDetail: Record "NS_Employee Burden Detail";
    begin
        BurdenAmountToPost := 0;
        Employee.RESET();
        Employee.SETCURRENTKEY("Resource No.");
        Employee.SETRANGE("Resource No.", ResourceNo);
        if Employee.FINDFIRST() then begin
            EmployeeBurdenDetail.RESET();
            EmployeeBurdenDetail.SETRANGE("NS_Employee No.", Employee."No.");
            EmployeeBurdenDetail.SETFILTER("NS_Effective Date", '..%1', PostingDate);
            if EmployeeBurdenDetail.FINDSET() then
                repeat
                    if EmployeeBurdenDetail."NS_Burden Rate Type" = EmployeeBurdenDetail."NS_Burden Rate Type"::"Flat Rate" then
                        BurdenAmountToPost += EmployeeBurdenDetail."NS_Burden Rate per Hour" * Hours
                    else
                        BurdenAmountToPost += ((EmployeeBurdenDetail."NS_Burden Rate per Hour" / 100) * (WageRateToPost * Hours));
                until EmployeeBurdenDetail.NEXT() = 0;
        end;
    end;
}

