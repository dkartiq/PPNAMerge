pageextension 14021289 NS_PurchaseQuoteArchiveSubForm extends "Purchase Quote Archive Subform"
{
    // version NAVW111.00.00.19846,NAVNA11.00.00.19846,PPNA11.00

    layout
    {
        modify("Job No.")
        {
            Visible = true;
        }

        addafter("VAT Prod. Posting Group")
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
        addafter("Shortcut Dimension 2 Code")
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
            }
            field("NS_Job Revenue Category"; Rec."NS_Job Revenue Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Revenue Category';
            }
            field("NS_FA Job Usage"; "NS_FA Job Usage")
            {
                ApplicationArea = all;
                Description = 'PRJ-490.MS.1.0';

            }
            //PRJ-490.AM.1.0 Start
            field("NS_FA Job No."; "NS_FA Job No.")
            {
                ApplicationArea = all;
            }
            field("NS_FA Job Task No."; "NS_FA Job Task No.")
            {
                ApplicationArea = all;
            }
            field("NS_FA Segment Code"; "NS_FA Segment Code")
            {
                ApplicationArea = all;
            }
            //PRJ-490.AM.1.0 End
        }
    }

    /*
      +------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     "Gen. Bus. Posting Group"
      +     "Gen. Prod. Posting Group"
      +     Job Task No.
      +     Job Cost Category
      +     Job Revenue Category
      +
      +  - Modification(s):
      +     - Set Job No. column as Visible=TRUE
      +------------------------------------------------------------
    */

}

