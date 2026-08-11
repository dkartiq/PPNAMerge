pageextension 14021454 NS_SalesRelationshipMgrAct extends "Sales & Relationship Mgr. Act."
{
    // version NAVW111.00,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Activities'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        addafter("Active Campaigns")
        {
            field("NS_Open Job Quotes"; Rec."NS_Open Job Quotes")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number Open Job Quotes';
            }
        }
    }

    /*
      +------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     14021100 - "Open Job Quotes"
      +------------------------------------------------------------
    */

}

