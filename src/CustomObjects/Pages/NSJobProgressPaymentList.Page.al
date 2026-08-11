page 14021342 "NS_Job Progress Payment List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job Progress Payment List';
    CardPageID = "NS_Progress Payment Header";
    DataCaptionFields = "NS_No.";
    Editable = false;
    PageType = List;
    SourceTable = "NS_Progress Payment Header";

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
                field("Requisition No."; Rec."NS_Requisition No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Requisition No.';
                }
                field("Version No."; Rec."NS_Version No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Version No.';
                }
                field("Requisition Date"; Rec."NS_Requisition Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Requisition Date';
                }
                field("Period To"; Rec."NS_Period To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Period To"';
                }
                field(Status; Rec.NS_Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Status';
                }
                field(Final; Rec.NS_Final)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Final';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Page Progress Payment Header>")
            {
                ApplicationArea = All;
                Caption = 'Show Requisition';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "NS_Progress Payment Header";
                RunPageLink = "NS_No." = FIELD("NS_No."),
                              "NS_Requisition No." = FIELD("NS_Requisition No."),
                              "NS_Version No." = FIELD("NS_Version No.");
                RunPageView = SORTING("NS_No.", "NS_Requisition No.", "NS_Version No.");
            }
        }
    }
}

