pageextension 14021300 NS_FixedAsset extends "Fixed Asset Card"
{
    //PRJ-490.MS.1.0 added new field
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Fixed Asset Card'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        addafter("Responsible Employee")
        {
            field("NS_FA Res. No."; "NS_FA Res. No.")
            {
                ApplicationArea = All;
                Caption = 'FA Res. No.';
                ToolTip = 'FA Res. No.';
            }

        }
    }

}

