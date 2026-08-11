pageextension 14021477 NS_ApplyVendorEntries extends "Apply Vendor Entries"
{
    // version NAVW111.00.00.24232,NAVNA11.00.00.24232,PPNA11.00
    //PRJ-201:AS:15APRIL2020 - Created new extension page & added "Retention Ledger Code" field in page.
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Apply Vendor Entries'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        addafter(Description)
        {
            field("NS_Retention Ledger Code"; Rec."NS_Retention Ledger Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Retetention ledger code';
            }
        }

    }

}