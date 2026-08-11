//Posted Sales Invoices bug with object name usage
pageextension 14021153 NS_PostedSalesInvoices extends "Posted Sales Invoices"
{
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,PPNA11.00
    //PRJ-659.RS.1.0 17June21 | NS_ should be removed from every page rest mention the page ID and Name.
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Posted Sales Invoices'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("NS_Job No."; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';
            }
            field("NS_Job Description"; NS_Job.Description)
            {
                Caption = 'Job Description';//PRJ-659.RS.1.0 17June21
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Description.';
            }
            //PRJ-1648.PS.1.0 10OCT2022 - Start

            field("NS_Retention Document"; Rec."NS_Retention Document")
            {
                ApplicationArea = All;

            }

            //PRJ-1648.PS.1.0 10OCT2022 - End
        }
    }
    var
        NS_Job: Record Job;

    trigger OnAfterGetRecord()
    begin
        //ProjectPro - start
        CLEAR(NS_Job);
        IF "NS_Job No." > '' THEN
            IF NS_Job.GET("NS_Job No.") THEN;
        //ProjectPro - end
    end;


}

