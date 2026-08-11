page 14021221 "NS_Enter Job No."
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    Caption = 'Enter Job No.';

    layout
    {
        area(content)
        {
            field(JobNo; JobNo)
            {
                ApplicationArea = All;
                TableRelation = Job;
                ToolTip = 'Specifies the Job No.';
                Caption = 'Job No.';
            }
        }
    }

    actions
    {
    }

    var
        JobNo: Code[20];

    procedure NS_ReturnJobNo(var ReturnedJobNo: Code[20]);
    begin
        ReturnedJobNo := JobNo;
    end;
}

