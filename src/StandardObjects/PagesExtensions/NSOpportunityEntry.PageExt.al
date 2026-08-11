pageextension 14021196 NS_OpportunityEntry extends "Opportunity Subform"
{
    //PE-6.NK.1.0 24Mar2022 New Created
    layout
    {
        // Add changes to page layout here
        addbefore("Completed %")
        {
            field(NS_QuoteRequired; Rec.NS_QuoteRequired)
            {
                ApplicationArea = all;
                ToolTip = 'Quote Required';
                Caption = 'Quote Required';
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