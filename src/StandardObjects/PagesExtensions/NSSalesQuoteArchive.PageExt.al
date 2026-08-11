pageextension 14021286 NS_SalesQuoteArchive extends "Sales Quote Archive"
{
    // version NAVW111.00.00.19846,NAVNA11.00.00.19846,PPNA11.00

    layout
    {
        addafter(Status)
        {
            field("NS_Job No."; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';
            }
        }
    }

    /*
      +------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     "PP Job No."
      +------------------------------------------------------------
    */

}

