pageextension 14021154 NS_PostedPurchInvoices extends "Posted Purchase Invoices"
{
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,PPNA11.00
    //PRJ-659.RS.1.0 17June21 | NS_ should be removed from every page rest mention the page ID and Name.
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    //PRJ-1380.NK.1.0 16May2022 | Added new fields
    Caption = 'Posted Purchase Invoices'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field("NS_Job No."; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';
            }
            //PRJ-1380.NK.1.0 16May2022 Start
            field("NS_Job Purchaser"; Rec."NS_Job Purchaser")
            {
                ApplicationArea = All;
                ToolTip = 'Job Purchaser';
                Caption = 'Job Purchaser';
                Description = 'PRJ-1380.NK.1.0';
            }
            field("NS_Job Manager"; Rec."NS_Job Manager")
            {
                ApplicationArea = All;
                ToolTip = 'Job Manager';
                Caption = 'Job Manager';
                Description = 'PRJ-1380.NK.1.0';
            }
            //PRJ-1380.NK.1.0 16May2022 End
            field("NS_Job Description"; NS_Job.Description)
            {
                Caption = 'Job Description';//PRJ-659.RS.1.0 17Une21
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Description';
            }
        }
    }

    var
        NS_Job: Record Job;

    trigger OnAfterGetRecord();
    begin
        //ProjectPro - start
        if not NS_Job.GET("NS_Job No.") then
            CLEAR(NS_Job);
        //ProjectPro - end    
    end;
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     Job No.
//   +     Job Description
//   +
//   +  - Added function(s):
//   +
//   +  - Added global variable(s):
//   +     PP_Job
//   +
//   +  - Added global text constant(s):
//   +
//   +  - Modification(s):
//   +     - OnAfterGetRecord - Get related Job record
//   +-----------------------------------------------------------------------------------------------