pageextension 14021152 NS_PostedPurchCrMemoSubForm extends "Posted Purch. Cr. Memo Subform"
{
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,NSNA11.00

    layout
    {
        modify("Job No.")
        {
            Visible = true;
        }

        addafter("Job No.")
        {
            field("NS Subcontract No."; Rec."NS_Subcontract No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Subcontract No.';
            }
            field("NS Job Task No."; Rec."Job Task No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Task No.';
            }
            field("NS Job Cost Category"; Rec."NS_Job Cost Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Cost Category';
            }
            field("NS Job Revenue Category"; Rec."NS_Job Revenue Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Revenue Category';
                Visible = false;
            }
        }
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
        addafter("Line Discount %")
        {
            field("NS Retention Applies"; Rec."NS_Retention Applies")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether Retention ANSlies';
            }
        }
        moveafter("No."; "Job No.")
    }
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     NS Subcontract No.
//   +     NS Job Task No.
//   +     NS Job Cost Category
//   +     NS Job Revenue Category
//   +     NS Gen. Bus. Posting Group
//   +     NS Gen. Prod. Posting Group
//   +     NS Retention ANSlies
//   +
//   +  - Modification(s):
//   +     - Modified controls:
//   +         Job No. - Set Visable=TRUE
//   +-----------------------------------------------------------------------------------------------