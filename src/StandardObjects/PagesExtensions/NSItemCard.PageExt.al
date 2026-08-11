pageextension 14021108 NS_ItemCard extends "Item Card"
{
    // version NAVW111.00.00.24742,NAVNA11.00.00.24742,PPNA11.00
    //PRJ-262.MS.1.0 added new field
    //PRJ-260.MS.1.0 added new field
    //PPAL-19.AS.1.0 12AUG2020 Added Manufacturer code, manufacturer
    //PPAL-19.AS.1.0 Hide Manufacturer field
    //PPAL-111.NS.1.0 27Aug2020 Manufacturer code is already available in page
    //PPAL-111.AS.1.0 Again checked the issue and commented code
    //PRJ-1058.GK.1.0 26Nov2021 Twinoaks  Custmization for Twinoaks
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    //PRJ-1335.NK.1.0 02May2022 Add Field.
    Caption = 'Item Card'; //PRJ-1330.NK.1.0 25Apr2022
    //PE-243.Dk.2.0 06March2023 | Add Field
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
            //PRJ-1335.NK.1.0 02May2022 Start
            field("NS_Revenue Category"; Rec."NS_Revenue Category")
            {
                ToolTip = 'Specifies the Revenue Category';
                Caption = 'Revenue Category';
                ApplicationArea = All;
            }
            //PRJ-1335.NK.1.0 02May2022 End

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
                //PE-323.AT.1.0 14Jun24  Start
                ObsoleteState = Pending;
                ObsoleteReason = 'Will be removed in next build because ProjectPro enhance new functionality.';
                ObsoleteTag = 'ProjectPro upcoming release 24.0.XXX.00';
                //PE-323.AT.1.0 14Jun24  end
            }
            field("NS_Labor Hours per Qty."; Rec."NS_Labor Hours per Qty.")
            {
                Caption = 'Labor Hours per Qty.';
                ApplicationArea = ALL;
                Description = 'Labor Hours per Qty.';
                //PE-323.AT.1.0 14Jun24  Start
                ObsoleteState = Pending;
                ObsoleteReason = 'Will be removed in next build';
                ObsoleteTag = 'Will be removed in next build because ProjectPro enhance new functionality.';
                //PE-323.AT.1.0 14Jun24  end
            }

        }
        //PRJ-568.AS.1.0 - END

        //PRJ-1058.GK.1.0 26Nov2021 Twinoaks Start
        addafter("Purchasing Code")
        {
            field("NS_Quote Costs"; Rec."NS_Quote Costs")
            {
                ApplicationArea = all;
                Caption = 'Quote Costs';
            }
            field("NS_Quote Costs Modified Date"; Rec."NS_Quote Costs Modified Date")
            {
                ApplicationArea = all;
                Caption = 'Quote Costs Modified Date';
            }
        }
        //PRJ-1058.GK.1.0 26Nov2021 Twinoaks End
        //PE-243.Dk.2.0 06March2023 Start
        addafter("Base Unit of Measure")
        {
            field("Ns_Parent Item UOM"; Rec."Ns_Parent Item UOM")
            {
                ApplicationArea = all;
            }
        }
        //PE-243.Dk.2.0 06March2023 End
    }
    actions
    {
        //PE-323.AT.1.0 13Jun24 start
        addafter("Cost Shares")
        {
            action(NSLinkedResources)
            {
                Caption = 'Linked Resources';
                ;
                ToolTip = 'Create the Linked Resource list for the item.';
                Image = Link;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = Assembly;
                RunObject = page "NS_Linked Resources";
                RunPageLink = "NS_Item No." = field("No.");

            }
        }
        //PE-323.AT.1.0 13Jun24 End
    }
    /* Documentation
     +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     Qty. on Job Journals
      +-----------------------------------------------------------------------------------------------
    */

}

