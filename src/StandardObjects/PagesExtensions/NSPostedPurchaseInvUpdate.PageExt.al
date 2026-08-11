pageextension 14021474 NSPostedPurchInvUpdate extends "Posted Purch. Invoice - Update"
{
    //PRJCTPR-252.HS.1.0 19Dec2023| Extended Page and Added Field NS_Draw No. 
    layout
    {
        addlast("Invoice Details")
        {
            field("NS_Draw No."; rec."NS_Draw No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Draw No.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
}
