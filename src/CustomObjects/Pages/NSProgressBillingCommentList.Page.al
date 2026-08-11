page 14021330 "NS_Progress BillingCommentList"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Comment List';
    DataCaptionFields = "NS_No.";
    Editable = false;
    PageType = Card;
    SourceTable = "NS_Progress BillingCommentLine";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';
                }
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
}

