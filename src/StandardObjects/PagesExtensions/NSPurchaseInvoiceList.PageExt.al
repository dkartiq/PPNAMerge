pageextension 14021160 NS_PurchaseInvoiceList extends "Purchase Invoices"
{
    //PRJCTPR-354.JS.1.0 22MAY2024 New Page Extention
    layout
    {
        // Add changes to page layout here
        addafter("Location Code")
        {
            field("NS_Job No."; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';
            }
            field("NS_Job Name"; Rec."NS_Job Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Name';
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