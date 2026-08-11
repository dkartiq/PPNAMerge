//PPDA.1.0 Commented Start
// pageextension 14021473 NS_PostedDepositLines extends "Posted Deposit Lines"
// {
//     // version NAVNA11.00.00.23572,PPNA11.00

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
//       +   - Set Shortcut Dimension 2 Code column as Visible=TRUE
//       +------------------------------------------------------------
//     */
// }

//PPDA.1.0 Commented End