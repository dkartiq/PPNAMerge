page 14021422 "NS_Job Quote Job Type"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    PageType = Card;
    Caption = 'Job Quote Job Type';
    UsageCategory = Documents;
    ApplicationArea = Jobs;
    SourceTable = "NS_Job Type";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(LoadDefaultTasks; PP_LoadDefaultTasks)
                {
                    ApplicationArea = All;
                    Caption = 'Load Default Tasks';

                    ToolTip = 'Load Default Tasks';
                }
                field("Code"; Rec.NS_Code)
                {
                    ApplicationArea = All;
                    Enabled = PP_LoadDefaultTasks;
                    ToolTip = 'Specifies the Code';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    Enabled = PP_LoadDefaultTasks;
                    ToolTip = 'Specifies the Description';
                }
                field(SegmentType; PP_SegmentType)
                {
                    ApplicationArea = All;
                    Caption = 'Segment Type';
                    Enabled = PP_LoadDefaultTasks;
                    ToolTip = 'Segment Type';
                    OptionCaption = 'Welding,Drawing,Template';

                    trigger OnValidate();
                    begin
                        if PP_LoadDefaultTasks then
                            QuoteHdr.NS_SetSegmentType(PP_SegmentType, true);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnClosePage();
    begin
        if PP_LoadDefaultTasks then
            QuoteHdr.NS_SetSegmentType(PP_SegmentType, true);
    end;

    var
        QuoteHdr: Record "NS_Job Quote Header";
        PP_LoadDefaultTasks: Boolean;
        PP_SegmentType: Option Welding,Drawing,Template;

}

