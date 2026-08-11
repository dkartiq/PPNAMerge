/// <summary>
/// PageExtension NS_InventorySetup (ID 14021359) extends Record Inventory Setup.
/// </summary>
pageextension 14021359 "NS_InventorySetup" extends "Inventory Setup"
{
    //PRJCTPR-198.AS.1.0  Added New Page Extension for adding new field NS_AllowZeroCostJLE
    layout
    {

        addafter("Copy Item Descr. to Entries")
        {
            //PRJCTPR-198.AS.1.0 START
            field(NS_AllowZeroCostJLE; Rec.NS_AllowZeroCostJLE)
            {
                ApplicationArea = All;
                ToolTip = 'Enable this to create Job Ledger Entries while booking usage with zero cost/price for items';//PRJCTPR-198.AS.2.0 Add
            }
            //PRJCTPR-198.AS.1.0 END
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}