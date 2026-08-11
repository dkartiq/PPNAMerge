pageextension 14021275 NS_JobTaskLinesSubForm extends "Job Task Lines Subform"
{
    // version NAVW111.00.00.22292,PPNA11.00
    //PRJ-807.RS.1.0 9July21 | Ability to Assign Work Units and Work Units Of Measure at Job Task Line
    //PRJ-959.RM.1.0 04-Oct-2021 | Modify Caption of fields
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    //PRJ-1579.RM.1.0  18Aug2022 | Added tooltip
    Caption = 'Job Task Lines Subform'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        addafter("Job Task Type")
        {
            //PRJ-807.RS.1.0 9July21 Start
            field("NS_Work Units"; Rec."NS_Work Units")
            {
                ApplicationArea = All;
                ToolTip = 'Quantity of work to be performed (Example: Qty of Sq Ft for Tile Flooring)'; //PRJ-1579.RM.1.0 
            }
            field("NS_Work Unit of Measure"; Rec."NS_Work Unit of Measure")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Work Measure'; //PRJ-1579.RM.1.0
            }
            //PRJ-807.RS.1.0 9July21 End
        }
        //PRJ-959.RM.1.0 04-Oct-2021 Start
        modify("Start Date")
        {
            Caption = 'Task Start Date';
        }
        modify("End Date")
        {
            Caption = 'Task End Date';
        }
        //PRJ-959.RM.1.0 04-Oct-2021 Start

        //Unsupported feature: CodeModification on ""Outstanding Orders"(Control 1000).OnDrillDown". Please convert manually.

        //trigger OnDrillDown();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        ApplyPurchaseLineFilters(PurchLine);
        PurchLine.SETFILTER("Outstanding Amount (LCY)",'<> 0');
        PAGE.RUNMODAL(PAGE::"Purchase Lines",PurchLine);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //ProjectPro - start
        //ApplyPurchaseLineFilters(PurchLine);
        PurchLine.SETCURRENTKEY("Document Type","Job No.","Job Task No.");
        PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::Order);
        PurchLine.SETRANGE("Job No.","Job No.");
        if "Job Task Type" in ["Job Task Type"::Total,"Job Task Type"::"End-Total"] then
          PurchLine.SETFILTER("Job Task No.",Totaling)
        else
          PurchLine.SETRANGE("Job Task No.","Job Task No.");
        //ProjectPro - end
        PurchLine.SETFILTER("Outstanding Amount (LCY)",'<> 0');
        PAGE.RUNMODAL(PAGE::"Purchase Lines",PurchLine);
        */
        //end;


        //Unsupported feature: CodeModification on ""Amt. Rcd. Not Invoiced"(Control 1002).OnDrillDown". Please convert manually.

        //trigger  Rcd();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        ApplyPurchaseLineFilters(PurchLine);
        PurchLine.SETFILTER("Amt. Rcd. Not Invoiced (LCY)",'<> 0');
        PAGE.RUNMODAL(PAGE::"Purchase Lines",PurchLine);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //ProjectPro - start
        //ApplyPurchaseLineFilters(PurchLine);
        PurchLine.RESET;
        PurchLine.SETCURRENTKEY("Document Type","Job No.","Job Task No.");
        PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::Order);
        PurchLine.SETRANGE("Job No.","Job No.");
        if "Job Task Type" in ["Job Task Type"::Total,"Job Task Type"::"End-Total"] then
          PurchLine.SETFILTER("Job Task No.",Totaling)
        else
          PurchLine.SETRANGE("Job Task No.","Job Task No.");
        //ProjectPro - end
        PurchLine.SETFILTER("Amt. Rcd. Not Invoiced (LCY)",'<> 0');
        PAGE.RUNMODAL(PAGE::"Purchase Lines",PurchLine);
        */
        //end;
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

