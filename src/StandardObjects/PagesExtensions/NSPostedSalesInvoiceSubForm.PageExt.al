pageextension 14021144 NS_PostedSalesInvoiceSubForm extends "Posted Sales Invoice Subform"
{
    // version NAVW111.00.00.19846,NAVNA11.00.00.19846,PPNA11.00
//CTSI-42.AS.1.0 21MAY2020 Added Code
    layout
    {
        modify("Job No.")
        {
            Visible = false;
            Enabled = false;
        }

        addafter("Allow Invoice Disc.")
        {
            field("NS_Job No. Copy"; Rec."Job No.")
            {
                Caption = 'Job No.';
                ToolTip = 'Specifies the number of the related job.';
                ApplicationArea = Jobs;
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
            }
            field("NS_Job Revenue Category"; Rec."NS_Job Revenue Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Revenue Category';
                Editable = true;//CTSI-42
            }
            //CTSI-42.AS.1.0 21MAY2020 - START
            field("NS_Revenue Cat Description"; REC."NS_Revenue Cat Description")
            {
                ApplicationArea = all;
                Description = 'Specifies Revenue Category Description';
                Editable = true;
                //Editable = false;
            }
            //CTSI-42.AS.1.0 21MAY2020 - END
            //TM-32.AM.1.0
            field("NS_Segment Code"; "NS_Segment Code")
            {
                ApplicationArea = all;
            }
            field("NS_Segment Name"; "NS_Segment Name")
            {
                ApplicationArea = all;
            }
            //TM-32.AM.1.0
            field("NS_DFR No."; Rec."NS_DFR No.")
            {
                ApplicationArea = all;
                Caption = 'DFR No.';
                Description = 'JD-10.MS.1.0';
            }
        }
    }

    //   +---------------------------------------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +     PP Gen. Bus. Posting Group
    //   +     PP Gen. Prod. Posting Group
    //   +     PP Retention Applies
    //   +     PP Job Task No.
    //   +     PP Job Cost Category
    //   +     PP Job Revenue Category;
    //   +
    //   +  - Added function(s):
    //   +
    //   +  - Added global variable(s):
    //   +
    //   +  - Added global text constant(s):
    //   +
    //   +  - Modification(s):
    //   +     - OnOpenPage - Read setup records
    //   +
    //   +     - OnAfterGetRecord - Field Calculations
    //   +
    //   +     - Added action list:
    //   +
    //   +     - Modify action list:
    //   +
    //   +     - Modified controls:
    //   +         Job No. - Set Visable = TRUE
    //   +                 - Set Editable = FALSE
    //   +     - Menus:
    //   +
    //   +-----------------------------------------------------------------------------------------------

}

