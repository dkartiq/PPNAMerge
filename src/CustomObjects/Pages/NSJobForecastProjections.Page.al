page 14021186 "NS_Job Forecast Projections"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job Forecast Projections';
    PageType = Worksheet;
    SourceTable = "NS_Job Forecast Projections";

    layout
    {
        area(content)
        {
            field("Job No."; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the Job No.';
            }
            field("Job Task No."; Rec."NS_Job Task No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the Job Task No.';
            }
            repeater(Group)
            {
                field("Projection Date"; Rec."NS_Projection Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Projection Date';
                }
                field("Percent Complete"; Rec."NS_Percent Complete")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Percent Complete';
                }
            }
        }
    }

    actions
    {
    }
}

