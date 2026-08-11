//PPDA.1.0 Commenetd Start
// pageextension 14021472 NS_PostedDepositSubForm extends "Posted Deposit Subform"
// {
//     // version NAVNA11.00,PPNA11.00

//     layout
//     {
//         modify("Shortcut Dimension 2 Code")
//         {
//             Visible = true;
//         }

//         addafter(Amount)
//         {
//             field("NS Job No."; Rec."NS_Job No.")
//             {
//                 ApplicationArea = All;
//                 ToolTip = 'Specifies the Job No.';
//             }
//             field("NS Subcontract No."; Rec."NS_Subcontract No.")
//             {
//                 ApplicationArea = All;
//                 ToolTip = 'Specifies the Subcontract No.';
//             }
//         }
//     }

//     /*
//       +------------------------------------------------------------
//       +ProjectPro
//       +  - Added field(s):
//       +     "PP Job No."
//       +     "PP Subcontract No."
//       +
//       +  - Modification(s):
//       +     - Set Shortcut Dimension 2 Code as Visible=TRUE
//       +------------------------------------------------------------
//     */

// }

//PPDA.1.0 Commenetd End