pageextension 14021150 NS_PostedPurchInvoiceSubForm extends "Posted Purch. Invoice Subform"
{
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,PPNA11.00
    //TM-10.AM.1.0 | Added Field.
    //PRJ-490.AM.1.0 | Added Field.

    layout
    {
        addafter("Job No.")
        {
            field("NS_Subcontract No."; Rec."NS_Subcontract No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Subcontract No.';
            }
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
                Visible = false;
            }
            field("NS_Segment Code"; Rec."NS_Segment Code")
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Segment Code';
                Description = 'TM-10.AM.1.0';
            }
            //PRJ-490.AM.1.0 Start
            field("NS_FA Job Usage"; "NS_FA Job Usage")
            {
                ApplicationArea = all;
                Caption = 'FA Job Usage';
                Editable = false;
            }
            field("NS_FA Job No."; "NS_FA Job No.")
            {
                ApplicationArea = all;
                Caption = 'FA Job No.';
                Editable = false;
            }
            field("NS_FA Job Task No."; "NS_FA Job Task No.")
            {
                ApplicationArea = all;
                Caption = ' FA Job Task No.';
                Editable = false;
            }
            field("NS_FA Segment Code"; "NS_FA Segment Code")
            {
                ApplicationArea = all;
                Caption = 'FA Segment Code';
                Editable = false;
            }
            //PRJ-490.AM.1.0 End

        }
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
        addafter("Line Discount %")
        {
            field("NS_Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Amount Including VAT';
            }
            field("NS_Retention Applies"; Rec."NS_Retention Applies")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether Retention Applies';
            }
        }
        //PPDA.1.0.TBA Start
        // addafter("IRS 1099 Liable")
        // {
        //     field("NS_JMP Details"; Rec."NS_JMP Details")
        //     {
        //         ApplicationArea = All;
        //         ToolTip = 'Specifies the JMP Details';
        //     }
        // }
        //PPDA.1.0.TBA End
        moveafter("No."; "Job No.")
    }

    //   +---------------------------------------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +     PP Subcontract No.
    //   +     PP Job Task No.
    //   +     PP Job Cost Category
    //   +     PP Job Revenue Category
    //   +     PP Gen. Bus. Posting Group
    //   +     PP Gen. Prod. Posting Group
    //   +     PP Amount Including VAT
    //   +     PP Retention Applies
    //   +     JMP Details
    //   +-----------------------------------------------------------------------------------------------
}

