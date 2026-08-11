pageextension 14021266 NS_PostedSalesInvLines extends "Posted Sales Invoice Lines"
{
    // version NAVW111.00.00.19846,NAVNA11.00.00.19846,PPNA11.00
    //PRJ-659.RS.1.0 17June21 | NS_ should be removed from every page rest mention the page ID and Name.
    layout
    {
        addafter("Variant Code")
        {
            field("NS_Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Gen. Bus. Posting Group';
            }
            field("NS_Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Gen. Prod. Posting Group';
            }
        }
        addafter("Job No.")
        {
            field("NS_Job Task No."; Rec."Job Task No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Task No.';
            }
            field("NS_Job Cost Category"; Rec."NS_Job Cost Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Cost Category';
                Visible = false;
            }
            field("NS_Job Revenue Category"; Rec."NS_Job Revenue Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Revenue Category';
            }
            field("NS_Retention Applies"; Rec."NS_Retention Applies")
            {
                Caption = 'Retention Applies';//PRJ-659.RS.1.0 17June21
                ApplicationArea = All;
                ToolTip = 'Specifies whether Retention Applies';
            }
        }
    }

    /*
      +------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     "PP Gen. Bus. Posting Group"
      +     "PP Gen. Prod. Posting Group"
      +     "PP Job Task No."
      +     "PP Job Cost Category"
      +     "PP Job Revenue Category"
      +     "PP Retention Applies"
      +
      +  - Modification(s):
      +     - Set Job No. column as Visible=TRUE
      +------------------------------------------------------------
    */

}

