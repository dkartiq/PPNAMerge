pageextension 14021440 NS_ItemVendorCatalog extends "Item Vendor Catalog"
//PRJ-1082.RM.1.0 15Dec2021 | Created new page extension
{
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Item Vendor Catalog'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        // Add changes to page layout here
        addafter("Vendor No.")
        {
            field("NS_Vendor Name"; Rec."NS_Vendor Name")
            {
                ApplicationArea = all;
                Caption = 'Vendor Name';
                ToolTip = 'Specifies the Vendor Name';
            }
        }

    }

    actions
    {
        // Add changes to page actions here
    }


}