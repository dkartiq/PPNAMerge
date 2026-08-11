page 14021382 "NS_Job Journal Labor FactBox"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    PageType = CardPart;
    Caption = 'Job Journal Labor FactBox';
    SourceTable = "Job Journal Line";

    layout
    {
        area(content)
        {
            field("'     '"; '     ')
            {
                ApplicationArea = All;
                Caption = 'PROJECTPRO';
                Editable = false;
            }
            field(EmployeeNo; EmployeeNo)
            {
                ApplicationArea = All;
                Caption = 'Employee No.';
            }
            field(EmployeeName; EmployeeName)
            {
                ApplicationArea = All;
                Caption = 'Employee Name';
            }
            field("Employee Wage Rate"; Rec."NS_Employee Wage Rate")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Employee Wage Rate';
            }
            field("Employee Fringe - Insurance"; Rec."NS_Employee Fringe - Insurance")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Employee Fringe - Insurance';
            }
            field("Employee Fringe - Vacation"; Rec."NS_Employee Fringe - Vacation")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Employee Fringe - Vacation';
            }
            field("Employee Fringe - Education"; Rec."NS_Employee Fringe - Education")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Employee Fringe - Education';
            }
            field("Employee Fringe - Misc. 1"; Rec."NS_Employee Fringe - Misc. 1")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Employee Fringe - Misc. 1';
            }
            field("Employee Fringe - Misc. 2"; Rec."NS_Employee Fringe - Misc. 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Employee Fringe - Misc. 2';
            }
            field("Employee Fringe - Misc. 3"; Rec."NS_Employee Fringe - Misc. 3")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Employee Fringe - Misc. 3';
            }
            field("Employee Fringe Total"; Rec."NS_Employee Fringe Total")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Employee Fringe Total';
            }
            field("Prevailing Wage Rate"; Rec."NS_Prevailing Wage Rate")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Prevailing Wage Rate';
            }
            field("Prevailing Fringe Rate"; Rec."NS_Prevailing Fringe Rate")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Prevailing Fringe Rate';
            }
            field("Wage Calculation Basis"; Rec."NS_Wage Calculation Basis")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Wage Calculation Basis';
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        EmployeeNo := '';
        EmployeeName := '';
        if Type = Type::Resource then
            if "No." <> '' then begin
                Employee.RESET();
                Employee.SETCURRENTKEY("Resource No.");
                Employee.SETRANGE("Resource No.", "No.");
                if Employee.FINDFIRST() then begin
                    EmployeeNo := Employee."No.";
                    EmployeeName := Employee."First Name" + ' ' + Employee."Last Name";
                end;
            end;
    end;

    trigger OnOpenPage();
    begin
        if not Employee.READPERMISSION then
            ERROR(Text001);
    end;

    var
        Employee: Record Employee;
        Text001: Label 'You must have read permission to the Employee table in order to access the Job Journal Labor Factbox.';
        EmployeeNo: Code[20];
        EmployeeName: Text[80];
}

