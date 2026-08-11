page 14021384 "NS_Manager TimeSheetLineDetail"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    InsertAllowed = false;
    Caption = 'Manager Timesheet line Detail';
    PageType = Worksheet;
    SourceTable = "Time Sheet Detail";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    Editable = AllowEdit;
                    ToolTip = 'Specifies the Date';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Type';
                }
                field("Resource No."; Rec."Resource No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Resource No.';
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Job No.';
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Job Task No.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = AllowEdit;
                    ToolTip = 'Specifies the Quantity';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Status';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Posted';
                }
                field("Posted Quantity"; Rec."Posted Quantity")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Posted Quantity';
                }
                field("Wage Rate to Post"; Rec."NS_Wage Rate to Post")
                {
                    ApplicationArea = All;
                    Editable = AllowEdit;
                    ToolTip = 'Specifies the Wage Rate to Post';
                }
                field("Fringe Rate to Post"; Rec."NS_Fringe Rate to Post")
                {
                    ApplicationArea = All;
                    Editable = AllowEdit;
                    ToolTip = 'Specifies the Fringe Rate to Post';
                }
                field("Burden Amount to Post"; Rec."NS_Burden Amount to Post")
                {
                    ApplicationArea = All;
                    Editable = AllowEdit;
                    ToolTip = 'Specifies the Burden Amount to Post';
                }
                field("Rate to Post Calculation Basis"; Rec."NS_Rate toPostCalculationBasis")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Rate to Post Calculation Basis';
                }
            }
        }
        area(factboxes)
        {
            part(Control1100773014; "NS_Time Sheet Payroll FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Time Sheet No." = FIELD("Time Sheet No."),
                              "Time Sheet Line No." = FIELD("Time Sheet Line No."),
                              Date = FIELD(Date);
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        if Posted then
            AllowEdit := false
        else
            AllowEdit := true;
    end;

    var
        AllowEdit: Boolean;
}

