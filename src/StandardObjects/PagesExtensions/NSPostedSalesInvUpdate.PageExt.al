pageextension 14021475 NSPostedSalesInvUpdate extends "Posted Sales Inv. - Update"
{
    //PRJCTPR-252.HS.1.0 19Dec2023| Extended Page and Added Field NS_Draw No. 
    layout
    {
        addlast(Payment)
        {

            field("NS_Draw No."; Rec."NS_Draw No.")
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

    var
        myInt: Integer;
}