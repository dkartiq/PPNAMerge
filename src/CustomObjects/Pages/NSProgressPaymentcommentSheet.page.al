page 14021344 "NS_ProgressPaymentCommentSheet"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    AutoSplitKey = true;
    Caption = 'Progress Payment Comment Sheet';
    DataCaptionFields = "NS_No.";
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = Card;
    UsageCategory = Documents;
    ApplicationArea = Jobs;
    SourceTable = "NS_Progress PaymentCommentLine";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Date; Rec.NS_Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Date';
                }
                field(Comment; Rec.NS_Comment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Comment';
                }
                field("Code"; Rec.NS_Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Code';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        SetUpNewLine();
    end;
}

