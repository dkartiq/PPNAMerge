page 14021416 "NS_Job Quote Credit Limit Ent."
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Credit Limit Entries';
    DelayedInsert = true;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    SourceTable = "NS_Job Credit Limit Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Effective Date"; Rec."NS_Effective Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Effective Date';
                }
                field("Credit Limit"; Rec."NS_Credit Limit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Credit Limit';
                }
                field("Expiration Date"; Rec."NS_Expiration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Expiration Date';
                }
                field(Comment; Rec.NS_Comment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Comment';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        "NS_Table ID" := DefaultTableID;
        "NS_No." := DefaultNo;
    end;

    trigger OnOpenPage();
    begin
        if (DefaultTableID = 0) or (DefaultNo = '') then
            ERROR(Text000Lbl);
    end;

    var
        DefaultTableID: Integer;
        DefaultNo: Code[20];
        Text000Lbl: Label 'Must be launched from Customer or Contact Card.';

    procedure NS_InitValues(_TableID: Integer; _No: Code[20]);
    begin
        DefaultTableID := _TableID;
        DefaultNo := _No;
    end;
}

