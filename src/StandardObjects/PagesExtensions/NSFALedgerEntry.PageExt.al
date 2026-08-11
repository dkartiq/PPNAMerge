pageextension 14021350 NS_FALedger extends "FA Ledger Entries"
{
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'FA Ledger Entries'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        addafter("No. of Depreciation Days")
        {
            //PRJ-490.AM.1.0 Start
            field("NS_FA Job No."; "NS_FA Job No.")
            {
                ApplicationArea = all;
                Caption = 'FA Job No.';
                Editable = false;
            }
            field("NS_FA Job Task No."; "NS_FA Job Task No.")
            {
                ApplicationArea = all;
                Caption = ' FA Job Task No.';
                Editable = false;
            }
            field("NS_FA Segment Code"; "NS_FA Segment Code")
            {
                ApplicationArea = all;
                Caption = 'FA Segment Code';
                Editable = false;
            }
            field("NS_FA Res. No."; "NS_FA Res. No.")
            {
                ApplicationArea = all;
                Caption = 'FA Res.No.';
                Editable = false;
            }
            //PRJ-490.AM.1.0 End
        }

    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}