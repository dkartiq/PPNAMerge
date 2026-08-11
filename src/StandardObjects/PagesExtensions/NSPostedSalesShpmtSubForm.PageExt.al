pageextension 14021142 NS_PostedSalesShpmtSubForm extends "Posted Sales Shpt. Subform"
{
    // version NAVW111.00.00.20783,NAVNA11.00.00.20783,PPNA11.00

    layout
    {
        modify("Job No.")
        {
            Visible = true;
        }

        addafter("Variant Code")
        {
            field("NS_Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the Gen. Bus. Posting Group';
            }
            field("NS_Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                Editable = false;
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
        }
    }
}

// +---------------------------------------------------------------------------------------------
// +ProjectPro
// +  - Added field(s):
// +     PP Gen. Bus. Posting Group
// +     PP Gen. Prod. Posting Group
// +     Job Task No.
// +
// +  - Added function(s):
// +
// +  - Added global variable(s):
// +
// +  - Added global text constant(s):
// +
// +  - Modification(s):
// +     - Modified controls:
// +         Job No. - Set Visible=TRUE
// +-----------------------------------------------------------------------------------------------