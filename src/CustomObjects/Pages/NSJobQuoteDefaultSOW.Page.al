page 14021432 "NS_Job Quote Default SOW"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job Quote Default Scope of Work';
    DataCaptionFields = "NS_Code";
    PageType = ListPlus;
    SourceTable = "NS_Job Quote Def Scope of Work";
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Selected; Rec.NS_Selected)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Selected';
                    Visible = TrueFalse;
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
                field("Description 2"; Rec."NS_Description 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description 2';
                }
            }
        }
    }

    actions
    {
    }

    var
        TrueFalse: Boolean;

    procedure NS_InitVar(lTrueFalse: Boolean);
    begin
        TrueFalse := lTrueFalse;
    end;
}

