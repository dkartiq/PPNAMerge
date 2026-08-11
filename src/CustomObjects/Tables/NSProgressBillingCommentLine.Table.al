table 14021327 "NS_Progress BillingCommentLine"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Progress Billing Comment Line';
    DrillDownPageID = "NS_Progress BillingCommentList";
    LookupPageID = "NS_Progress BillingCommentList";

    fields
    {
        field(1; "NS_No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(2; "NS_Requisition No."; Integer)
        {
            Caption = 'Requisition No.';
            DataClassification = CustomerContent;
        }
        field(3; "NS_Version No."; Integer)
        {
            Caption = 'Version No.';
            DataClassification = CustomerContent;
        }
        field(4; "NS_Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(5; NS_Date; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(6; "NS_Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(7; NS_Comment; Text[80])
        {
            Caption = 'Comment';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_No.", "NS_Requisition No.", "NS_Version No.", "NS_Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    procedure SetUpNewLine();
    var
    begin
    end;
}

