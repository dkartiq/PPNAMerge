page 14021381 "NS_PayrollInterfArchiveEntries"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Payroll Interface Archived Export Entries';
    Editable = false;
    PageType = List;
    SourceTable = "NS_Payroll InterfExportArchive";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."NS_Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Document No.';
                }
                field("FORMAT(""Export Status Date/Time"")"; FORMAT(Rec."NS_Export Status Date/Time"))
                {
                    ApplicationArea = All;
                    Caption = 'Export Status Date/Time';
                }
                field("Work Date"; Rec."NS_Work Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Date';
                }
                field("Employee No."; Rec."NS_Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Employee No.';
                }
                field("Employee Name"; Rec."NS_Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Employee Name';
                }
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';
                }
                field(Shift; Rec.NS_Shift)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Shift';
                }
                field("D/E Type"; Rec."NS_D/E Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the D/E Type';
                }
                field("D/E Code"; Rec."NS_D/E Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the D/E Code';
                }
                field(Rate; Rec.NS_Rate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Rate';
                }
                field(Hours; Rec.NS_Hours)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Hours';
                }
                field(Amount; Rec.NS_Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Amount';
                }
                field("Sequence No."; Rec."NS_Sequence No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Sequence No.';
                }
                field("Override Dept."; Rec."NS_Override Dept.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Override Dept.';
                }
                field("Override Division"; Rec."NS_Override Division")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Override Division';
                }
                field("Override Branch"; Rec."NS_Override Branch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Override Branch';
                }
                field("Override State"; Rec."NS_Override State")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Override State';
                }
                field("Override Local"; Rec."NS_Override Local")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Override Local';
                }
                field("State/Local Misc. Field"; Rec."NS_State/Local Misc. Field")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the State/Local Misc. Field';
                }
                field("Rate No."; Rec."NS_Rate No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Rate No.';
                }
                field("Social Security No."; Rec."NS_Social Security No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Social Security No.';
                }
                field("Job Ledger Entry No."; Rec."NS_Job Ledger Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Ledger Entry No.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1100773024; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1100773005; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
    }
}

