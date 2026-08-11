pageextension 14021267 NS_PostedSalesCrMemoLines extends "Posted Sales Credit Memo Lines"
{
    // version NAVW111.00.00.19846,NAVNA11.00.00.19846,NSNA11.00

    layout
    {
        addafter("Variant Code")
        {
            field("NS Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Gen. Bus. Posting Group';
            }
            field("NS Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Gen. Prod. Posting Group';
            }
        }
        addafter("Job No.")
        {
            field("NS Job Task No."; Rec."Job Task No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Task No.';
            }
            field("NS Job Cost Category"; Rec."NS_Job Cost Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Cost Category';
                Visible = false;
            }
            field("NS Job Revenue Category"; Rec."NS_Job Revenue Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Revenue Category';
            }
            field("NS Retention Applies"; Rec."NS_Retention Applies")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether Retention ANSlies';
            }
        }
    }

    /*
      +------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     "NS Gen. Bus. Posting Group"
      +     "NS Gen. Prod. Posting Group"
      +     "NS Job Task No."
      +     "NS Job Cost Category"
      +     "NS Job Revenue Category"
      +     "NS Retention ANSlies"
      +
      +  - Modification(s):
      +     - Set Job No. column as Visible=TRUE
      +------------------------------------------------------------
    */
}

