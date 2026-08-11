pageextension 14021284 NS_SalesOrderArchive extends "Sales Order Archive"
{
    // version NAVW111.00.00.19846,NAVNA11.00.00.19846,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Sales Order Archive'; //PRJ-1330.NK.1.0 25Apr2022
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

