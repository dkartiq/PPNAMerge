pageextension 14021140 NS_GLRegisters extends "G/L Registers"
{
    // version NAVW111.00.00.24232,NAVNA11.00.00.24232,PPNA11.00
    actions
    {
        modify("Trial Balance")
        {
            Visible = false;
        }

        modify("G/L Register")
        {
            Visible = false;
        }

        addafter("Detail Trial Balance")
        {

            //PPDA.1.0.TBA Start
            // action("NS_Trial Balance")
            // {
            //     ApplicationArea = Suite;
            //     RunObject = report 10022;
            //     Promoted = true;
            //     Image = Report;
            //     PromotedCategory = Report;
            //     Caption = 'Trial Balance';
            //     ToolTip = 'Print or save the chart of accounts that have balances and net changes.';
            // }
            //PPDA.1.0.TBA End
        }

        addafter("Trial Balance by Period")
        {

            //PPDA.1.0.TBA Start
            // action("NS_G/L Register")
            // {
            //     ApplicationArea = Suite;
            //     RunObject = report 10019;
            //     Promoted = true;
            //     Image = Report;
            //     PromotedCategory = Report;
            //     Caption = 'G/L Register';
            //     ToolTip = 'View posted G/L entries.';
            // }
            //PPDA.1.0.TBA End
        }
    }
}

// +---------------------------------------------------------------------------------------------
//       +ProjectPro
//       +  - Added field(s):
//       +
//       +  - Added function(s):
//       +
//       +  - Added global variable(s):
//       +
//       +  - Added global text constant(s):
//       +
//       +  - Modification(s):
//       +     - Modify action list:
//       +         Assigned Name to action of calling Trial Balance report
//       +         Assigned PP G/L Register to action of calling G/L Register report
//+-----------------------------------------------------------------------------------------------