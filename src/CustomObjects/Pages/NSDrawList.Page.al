page 14021219 "NS_Draw List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    DataCaptionFields = "NS_Job No.";
    Caption = 'Draw List';
    Editable = false;
    PageType = List;
    SourceTable = NS_Draw;

    layout
    {
        area(content)
        {
            repeater(Control1100773000)
            {
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';
                }
                field(Closed; Rec.NS_Closed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Closed';
                }
            }
        }
    }

    actions
    {
    }
}

