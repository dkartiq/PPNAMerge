page 14021222 "NS_Enter Percentage"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Enter Percentage';
    layout
    {
        area(content)
        {
            field(Percentg; Percentg)
            {
                ApplicationArea = All;
                Caption = 'Percentage';
                ToolTip = 'Specifies the Percentage';
            }
        }
    }

    actions
    {
    }

    var
        Percentg: Decimal;

    procedure NS_ReturnPercentage(var ReturnedPercentage: Decimal);
    begin
        ReturnedPercentage := Percentg;
    end;
}

