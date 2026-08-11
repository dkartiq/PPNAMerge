pageextension 14021198 NS_OpportunityList extends "Opportunity List"
{
    //PE-6.NK.1.0 14Mar2023 New Created
    layout
    {
        addafter(CurrSalesCycleStage)
        {

            field(NS_JobOrderNo; Rec.NS_JobOrderNo)
            {
                ApplicationArea = All;
                Caption = 'Job No.';
                ToolTip = 'Specifies the Job Order No.';
            }
            field(NS_JobQuoteNo; Rec.NS_JobQuoteNo)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Quote No.';
            }
        }
    }

    actions
    {
        modify("Show Sales Quote")
        {
            Visible = false;
        }
        modify(CreateSalesQuote)
        {
            Visible = false;
        }
    }
}