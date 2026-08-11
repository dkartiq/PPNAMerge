page 14021196 "NS_Where-Used Job Calendar"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Where-Used Job Calendar';
    DataCaptionFields = "NS_Job Calendar Code";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "NS_Where Used Job Calendar";
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Source Type"; Rec."NS_Source Type")
                {
                    ApplicationArea = All;
                    Caption = 'Source Type';
                    ToolTip = 'Specifies the Source Type';
                }
                field("Source Code"; Rec."NS_Source Code")
                {
                    ApplicationArea = All;
                    Caption = 'Source Code';
                    ToolTip = 'Specifies the Source Code';
                }
                field("Additional Source Code"; Rec."NS_Additional Source Code")
                {
                    ApplicationArea = All;
                    Caption = 'Additional Source Code';
                    ToolTip = 'Specifies the Additional Source Code';
                }
                field("Source Name"; Rec."NS_Source Name")
                {
                    ApplicationArea = All;
                    Caption = 'Source Name';
                    ToolTip = 'Specifies the Source Name';
                }
                field("Job Custom Changes Exist"; Rec."NS_Job Custom Changes Exist")
                {
                    ApplicationArea = All;
                    Caption = 'Job Custom Changes Exist';
                    ToolTip = 'Specifies the Job Custom Changes Exist';
                }
            }
        }
    }

    actions
    {
    }
}

