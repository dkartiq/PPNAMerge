//Create Object for PE-239 
tableextension 14021424 NS_VendorPaymentBuffer extends "Vendor Payment Buffer"
{
    fields
    {
        field(14021150; "NS_Retention Ledger Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}