pageextension 14021146 NS_PostedSalesCrMemoSubForm extends "Posted Sales Cr. Memo Subform"
{
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Lines'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        modify("Job No.")
        {
            Visible = false;
        }

        addafter("Allow Invoice Disc.")
        {
            field("NS_Job No. Copy"; Rec."Job No.")
            {
                Caption = 'Job No.';
                ToolTip = 'Specifies the number of the related job.';
                ApplicationArea = "#Advanced";
                Editable = false;
            }
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
        //PPDA.1.0.TBA Start
        // addafter("Amount Including VAT")
        // {
        //     field("NS_Retention Applies"; Rec."NS_Retention Applies")
        //     {
        //         ApplicationArea = All;
        //         Editable = false;
        //         ToolTip = 'Specifies whether Retention Applies';
        //     }
        // }
        //PPDA.1.0.TBA End
        addafter("Shortcut Dimension 2 Code")
        {
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
        }
    }

    //   +---------------------------------------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +     PP Gen. Bus. Posting Group
    //   +     PP Gen. Prod. Posting Group
    //   +     PP Retention Applies
    //   +     Job Task No.
    //   +     Job Cost Category
    //   +     Job Revenue Category
    //   +
    //   +  - Modification(s):
    //   +     - Modified controls:
    //   +         Job No. - Set Visable = TRUE
    //   +                 - Set Editable = FALSE
    //   +-----------------------------------------------------------------------------------------------

}

