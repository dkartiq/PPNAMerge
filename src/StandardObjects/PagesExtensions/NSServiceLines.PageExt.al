pageextension 14021299 NS_ServiceLines extends "Service Lines"
{
    // version NAVW111.00.00.19846,NAVNA11.00.00.19846,PPNA11.00

    layout
    {
        addafter("Job Line Type")
        {
            field("NS_Job Revenue Category"; Rec."NS_Job Revenue Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Revenue Category';
            }
        }
    }

    /*
      +------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     "PP Job Revenue Category"
      +
      +  - Modification(s):
      +     - Set columns as Visible=TRUE: Job No., Job Task No., Job Planning Line No., Job Line Type
      +------------------------------------------------------------
    */
}

