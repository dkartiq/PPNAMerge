page 14021385 "NS_Time Sheet Payroll FactBox"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Time Sheet Payroll FactBox';
    PageType = CardPart;
    SourceTable = "Time Sheet Detail";

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
            field(JobDescription; JobDescription)
            {
                ApplicationArea = All;
                Caption = 'Job Description';
            }
            field(ResourceName; ResourceName)
            {
                ApplicationArea = All;
                Caption = 'Resource Name';
            }
            field(SkillClass; SkillClass)
            {
                ApplicationArea = All;
                Caption = 'Skill Class';
            }
            field(WorkTypeCode; WorkTypeCode)
            {
                ApplicationArea = All;
                Caption = 'Work Type Code';
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
            field("Employee Fringe Total"; Rec."NS_Employee Fringe Total")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the "Employee Fringe Total';
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
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        if not TimeSheetLine.GET(Rec."Time Sheet No.", Rec."Time Sheet Line No.") then begin //PRJ-1131.NK.1.0
            // SkillClass := '';//PE-68 Dk.1.0 10April2023 Start
            SkillClassNew := ''; //PE-68 Dk.1.0 10April2023 End
            WorkTypeCode := '';
        end else begin
            //PE-68 Dk.1.0 10April2023 Start
            // SkillClass := TimeSheetLine."NS_Skill Class";
            SkillClassNew := TimeSheetLine."NS_Skill Class New";
            //PE-68 Dk.1.0 10April2023 End
            WorkTypeCode := TimeSheetLine."Work Type Code";
        end;
        if not Resource.GET(Rec."Resource No.") then //PRJ-1131.NK.1.0
            ResourceName := ''
        else
            ResourceName := Resource.Name;
        if not Job.GET(Rec."Job No.") then //PRJ-1131.NK.1.0
            JobDescription := ''
        else
            JobDescription := Job.Description;
    end;

    var
        TimeSheetLine: Record "Time Sheet Line";
        Job: Record Job;
        Resource: Record Resource;
        SkillClass: Code[10];
        SkillClassNew: Code[20];//PE-68 Dk.1.0 10April2023
        WorkTypeCode: Code[10];
        JobDescription: Text[50];
        ResourceName: Text[50];
}

