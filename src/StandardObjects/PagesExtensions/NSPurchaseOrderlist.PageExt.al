pageextension 14021458 NS_PurchaseOrderList extends "Purchase Order List"
{
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,PPNA11.00

    layout
    {
        addafter("Amount Received Not Invoiced (LCY)")
        {
            field("NS_Job No."; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';
            }
            field("NS_Expected Receipt Date"; Rec."Expected Receipt Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Expected Receipt Date';
            }
        }
    }

    /*
      +------------------------------------------------------------
      +ProjectPro
      +  - Modification(s):
      +     - Added Job No. and Expepected Receipt Date fields to the list.
      +------------------------------------------------------------
    */

}

