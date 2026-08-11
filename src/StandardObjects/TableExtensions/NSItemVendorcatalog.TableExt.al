tableextension 14021295 NS_ItemVendorCatalog extends "Item Vendor"
//PRJ-1082.RM.1.0 15Dec2021 |Created New table extension
{

    fields
    {
        // Add changes to table fields here
        field(14021400; "NS_Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            Editable = false;
            DataClassification = CustomerContent;
        }


    }

    var
        myInt: Integer;
}