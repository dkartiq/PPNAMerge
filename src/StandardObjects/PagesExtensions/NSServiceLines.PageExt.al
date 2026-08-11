pageextension 14021299 NS_ServiceLines extends "Service Lines"
{
    // version NAVW111.00.00.19846,NAVNA11.00.00.19846,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Service Lines'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        addafter("Job Line Type")
        {
            field("NS_Job Revenue Category"; Rec."NS_Job Revenue Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Revenue Category';
            }
            //PRJCTPR-222.JS.1.0 08NOV2023 - start            
            field("NS_Job Cost Category"; Rec."NS_Job Cost Category")
            {
                caption = 'Job Cost Category';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Job Cost Category field.';
            }
            //PRJCTPR-222.JS.1.0 08NOV2023 - start
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

