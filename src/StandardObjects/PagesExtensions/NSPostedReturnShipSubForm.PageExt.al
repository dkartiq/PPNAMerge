pageextension 14021182 NS_PostedReturnShipSubForm extends "Posted Return Shipment Subform"
{
    // version NAVW111.00.00.23572,PPNA11.00

    layout
    {
        modify("Job No.")
        {
            Visible = false;   //PRJ-1012.AS.1.0 Change Value from True to False
        }
        //PRJ-1012.AS.1.0 START
        addafter("No.")
        {
            field("NS_Job No."; Rec."Job No.")
            {
                Caption = 'Job No.';
                ToolTip = 'Specifies the Job No.';
                ApplicationArea = All;
            }
            field("NS_Job Task No."; Rec."Job Task No.")
            {
                Caption = 'Job Task No.';
                ToolTip = 'Specifies the Job No.';
                ApplicationArea = All;
            }

        }
        //PRJ-1012.AS.1.0 END

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
            //PRJ-1012.AS.1.0 START
            field("NS_Job Cost Category"; Rec."NS_Job Cost Category")
            {
                Caption = 'Job Cost Category';
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Cost Category';
            }
            //PRJ-1012.AS.1.0 END
        }
    }

    /*
      +------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     "PP Gen. Bus. Posting Group"
      +     "PP Gen. Prod. Posting Group"
      +
      +  - Modification(s):
      +     - Set Job No. column as Visible=TRUE
      +------------------------------------------------------------
    */

}

