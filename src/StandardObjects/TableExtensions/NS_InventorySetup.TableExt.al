/// <summary>
/// TableExtension NS_InventorySetup (ID 14021242) extends Record Inventory Setup.
/// </summary>
tableextension 14021242 NS_InventorySetup extends "Inventory Setup"
{

    //PRJCTPR-198.AS.1.0  Added New Table Extension for adding new field NS_AllowZeroCostJLE
    fields
    {

        //PRJCTPR-198.AS.1.0 START
        field(14021102; "NS_AllowZeroCostJLE"; Boolean)
        {
            Caption = 'Allow Zero Cost JLE';
            DataClassification = CustomerContent;
        }
        //PRJCTPR-198.AS.1.0 END
    }

    var
        myInt: Integer;
}