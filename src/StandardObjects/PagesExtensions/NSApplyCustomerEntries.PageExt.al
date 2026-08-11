pageextension 14021233 NS_ApplyCustomerEntries extends "Apply Customer Entries"
{
    // version NAVW111.00.00.24232,NAVNA11.00.00.24232,NSNA11.00
    //PRJ-201:AS:08APRIL2020 - Added Retention Ledger Code in page.
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Apply Customer Entries'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        addafter(Description)
        {
            field("NS Job No."; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';
            }
            //PRJ-201:AS:08APRIL2020 - START
            field("NS_Retention Ledger Code"; Rec."NS_Retention Ledger Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Retetention ledger code';
            }
            //PRJ-201:AS:08APRIL2020 - END
        }
    }

}