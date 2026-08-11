/// <summary>
/// PageExtension NS_GLAccountCardExt (ID 14021399) extends Record G/L Account Card.
/// </summary>
//PRJ-1089.GK.1.0 28Dec2021| Add new extension for adding new field cost category
//PRJ-1330.NK.1.0 25Apr2022 | Change Caption

pageextension 14021399 NS_GLAccountCardExt extends "G/L Account Card"
{
    Caption = 'G/L Account Card'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        addafter("Omit Default Descr. in Jnl.")
        {

            field("NS_Cost Category"; Rec."NS_Cost Category")
            {
                ToolTip = 'Specifies the value of the Cost Category field.';
                ApplicationArea = All;
            }
        }
    }


}