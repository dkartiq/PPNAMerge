pageextension 14021241 NS_RecurringReqWrkshtExt extends "Recurring Req. Worksheet"
{
    // version NAVW111.00.00.19846,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Recurring Requisition Worksheets'; //PRJ-1330.NK.1.0 25Apr2022
    actions
    {

        modify("Calculate Plan")
        {
            Visible = false;
            Enabled = false;
        }

        addafter("F&unctions")
        {
            action("NS_Calculate Plan Copy")
            {
                Ellipsis = true;
                Caption = 'PP Calculate Plan';
                ToolTip = 'Use a batch job to help you calculate a supply plan for items and stockkeeping units that have the Replenishment System field set to Purchase or Transfer.';
                ApplicationArea = "#Planning";
                Image = CalculatePlan;

                trigger OnAction();
                begin
                    //ProjectPro - start
                    ReorderItems.SetTemplAndWorksheet("Worksheet Template Name", "Journal Batch Name", "No.");
                    //ProjectPro - end
                    ReorderItems.RUNMODAL;
                    CLEAR(ReorderItems);
                end;
            }
        }
    }

    var
        ReorderItems: Report "NS_Calculate Plan - Req. Wksh.";

    //   +---------------------------------------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +
    //   +  - Added function(s):
    //   +
    //   +  - Added global variable(s):
    //   +
    //   +  - Added global text constant(s):
    //   +
    //   +  - Modification(s):
    //   +    - Added No. to the parameters of call to ReorderItems.SetTemplAndWorksheet
    //   +-----------------------------------------------------------------------------------------------
}

