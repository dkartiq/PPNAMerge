page 14021167 "NS_Get APO Links Code"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    PageType = NavigatePage;
    Caption = 'Get APO Links Code';

    layout
    {
        area(content)
        {
            group(Control1100773002)
            {
                field(APOCode; APOLinksHeader.NS_Code)
                {
                    ApplicationArea = All;
                    Caption = 'APOCode';
                    TableRelation = "NS_APO Links Header".NS_Code;
                    ToolTip = 'Specifies the APO Code';
                }
            }
        }
    }

    var
        APOLinksHeader: Record "NS_APO Links Header";

    procedure NS_GetCode(): Code[20];
    begin
        exit(APOLinksHeader.NS_Code);
    end;
}

