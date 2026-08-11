pageextension 14021277 NS_JobTaskList extends "Job Task List"
{
    // version NAVW111.00,NAVNA11.00,PPNA11.00

    actions
    {
        addafter("Jobs - Transaction Detail")
        {
            action("NS_Job Rcvd Not Invoiced")
            {
                ApplicationArea = All;
                Caption = 'Job Rcvd Not Invoiced';
                ToolTip = 'Job Rcvd Not Invoiced';

                trigger OnAction();
                var
                    RcvdNotInvoiced: Report "NS_ProjectPro Rcvd NotInvoiced";
                begin
                    //ProjectPro - start
                    RcvdNotInvoiced.SetFilter(Rec."Job No.", Rec."Job Task No.");
                    RcvdNotInvoiced.RUNMODAL;
                    //ProjectPro - end
                end;
            }
        }
    }

    //   +------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +
    //   +
    //   +  - Added function(s):
    //   +
    //   +
    //   +  - Added global variable(s):
    //   +
    //   +
    //   +  - Modification(s):
    //   +     - Added Page Action 'Job Rcvd Not Invoiced' along with OnAction code
    //   +------------------------------------------------------------

}

