pageextension 14021258 NS_SalesInvoiceListExt extends "Sales Invoice List"
{

    // This Page extended for //PRJ-1648.PS.1.0 10APR2022
    //PRJ-1648.PS.1.0 10OCT2022
    layout
    {
        addafter("Sell-to Contact")
        {
            field("NS_Retention Document"; Rec."NS_Retention Document")
            {
                ApplicationArea = all;
            }
            field("NS_From Progress Billing No."; Rec."NS_From Progress Billing No.")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}