page 14021195 "NS_Job Calendar Change List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job Calendar Change List';
    DataCaptionFields = "NS_Job Calendar Code";
    Editable = false;
    PageType = List;
    SourceTable = "NS_Job Calendar Change";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Job Calendar Code"; Rec."NS_Job Calendar Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Calendar Code';
                    Visible = false;
                }
                field("Recurring System"; Rec."NS_Recurring System")
                {
                    ApplicationArea = All;
                    Caption = 'Recurring System';
                    OptionCaption = '" ,Annual Recurring,Weekly Recurring"';
                    ToolTip = 'Specifies the Recurring System';
                }
                field(Date; Rec.NS_Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Date';
                }
                field(Day; Rec.NS_Day)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Day';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field(Nonworking; Rec.NS_Nonworking)
                {
                    ApplicationArea = All;
                    Caption = 'Nonworking';
                    ToolTip = 'Specifies the Nonworking';
                }
            }
        }
    }

    actions
    {
    }
}

