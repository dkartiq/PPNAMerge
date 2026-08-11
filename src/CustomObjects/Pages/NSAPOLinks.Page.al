page 14021165 "NS_APO Links"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    PageType = Document;
    SourceTable = "NS_APO Links Header";
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'APO Links';

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Type; Rec.NS_Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Type';
                }
                field("Code"; Rec.NS_Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Code';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
            }
            part(APOLines; "NS_APO Links Subform")
            {
                ApplicationArea = All;
                SubPageLink = NS_Type = FIELD(NS_Type),
                              NS_Code = FIELD(NS_Code);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("NS_Copy from template")
            {
                ApplicationArea = All;
                Caption = 'Copy from template';
                Image = Copy;
                Promoted = true;
                ToolTip = 'Copy from template';

                trigger OnAction();
                begin
                    NS_CopyFromTemplate(NS_Code);
                end;
            }
        }
    }
}

