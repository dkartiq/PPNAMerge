pageextension 14021108 NS_ItemCard extends "Item Card"
{
    // version NAVW111.00.00.24742,NAVNA11.00.00.24742,PPNA11.00
    //PRJ-262.MS.1.0 added new field
    //PRJ-260.MS.1.0 added new field
    //PPAL-19.AS.1.0 12AUG2020 Added Manufacturer code, manufacturer
    //PPAL-19.AS.1.0 Hide Manufacturer field
    //PPAL-111.NS.1.0 27Aug2020 Manufacturer code is already available in page
    //PPAL-111.AS.1.0 Again checked the issue and commented code
    layout
    {

        modify("Indirect Cost %")
        {
            Enabled = true;
        }
        addafter("Item Category Code")
        {
            field("NS_Job Cost Category"; Rec."NS_Job Cost Category")
            {
                ToolTip = 'Specifies the Job Cost Category';
                Caption = 'Job Cost Category';
                ApplicationArea = All;
            }
        }
        addafter("Qty. on Job Order")
        {
            field("NS_Qty. on Job Journals"; Rec."NS_Qty. on Job Journals")
            {
                DecimalPlaces = 0 : 0;
                Editable = false;
                Caption = 'Qty. on Job Journals';
                ApplicationArea = All;
                ToolTip = 'Specifies the Qty. on Job Journals';
            }
        }
        //PPAL-19.AS.1.0 12AUG2020 - start //PPAL-111.AS.1.0 - Commented start
        // addafter("Manufacturing Policy")
        // {
        //     field(NS_Manufacturer; NS_Manufacturer)
        //     {
        //         ApplicationArea = all;
        //         Description = 'Project Pro';
        //         visible = false;//PPAL-19.AS.1.0
        //         Caption = 'Manufacturer';
        //     }
        // }//PPAL-111.AS.1.0 - Commented end
        addafter(Description)
        {
            field("NS_Manufacturer Code"; Rec."Manufacturer Code")
            {
                ApplicationArea = ALL;
                Description = 'PRJ-260.MS.1.0';
                Caption = 'Manufacturer Code';
            }
        }
        //PPAL-19.AS.1.0 12AUG2020 - end
        //PRJ-568.AS.1.0 - START
        addafter("Common Item No.")
        {
            field("NS_Linked Resource"; Rec."NS_Linked Resource")
            {
            Caption = 'Linked Resource';
                ApplicationArea = ALL;
                Description = 'Linked Resource';
            }
            field("NS_Labor Hours per Qty."; Rec."NS_Labor Hours per Qty.")
            {
            Caption = 'Labor Hours per Qty.';
                ApplicationArea = ALL;
                Description = 'Labor Hours per Qty.';
            }
        }
        //PRJ-568.AS.1.0 - END
    }

    /* Documentation
     +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     Qty. on Job Journals
      +-----------------------------------------------------------------------------------------------
    */

}

