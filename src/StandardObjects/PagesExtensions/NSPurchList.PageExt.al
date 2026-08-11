pageextension 14021122 NS_PurchList extends "Purchase List"
{
    // version NAVW111.00.00.19846,PPNA11.00
    //PRJ-659.RS.1.0 17June21 | NS_ should be removed from every page rest mention the page ID and Name.
    layout
    {
        addafter("Buy-from Vendor No.")
        {
            field("NS_Job No."; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';
            }
            field("NS_Job Description"; NS_Job.Description)
            {
                caption = 'Job Description';//PRJ-659.RS.1.0 17June21
                ApplicationArea = All;
                ToolTip = 'Specifies the description of the job.';
            }
        }
    }

    var
        NS_Job: Record Job;

    trigger OnAfterGetRecord();
    begin
        //ProjectPro - start
        CLEAR(NS_Job);
        IF "NS_Job No." > '' THEN
            IF NS_Job.GET("NS_Job No.") THEN;
        //ProjectPro - end
    end;

    /*
      +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     Job No.
      +     Job Description
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +     PP_Job@1100773000
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +
      +-----------------------------------------------------------------------------------------------
    */

}

