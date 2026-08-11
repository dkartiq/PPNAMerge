pageextension 14021115 NS_SalesList extends "Sales List"
{
    // version NAVW111.00.00.19846,PPNA11.00
    //PRJ-659.RS.1.0 17June21 | NS_ should be removed from every page rest mention the page ID and Name.
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
                ToolTip = 'Specifies the Job Description';
            }
        }
    }

    var
        NS_Job: Record Job;

    trigger OnAfterGetCurrRecord();
    begin
        //ProjectPro - start
        CLEAR(NS_Job);
        IF "NS_Job No." > '' THEN
            IF NS_Job.GET("NS_Job No.") THEN;
        //ProjectPro - end
    end;

    /* Documentation
      +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     Job No.
      +     Job Description
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +     PP_Job
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +-----------------------------------------------------------------------------------------------
    */

}

