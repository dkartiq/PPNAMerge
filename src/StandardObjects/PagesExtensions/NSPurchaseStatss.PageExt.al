//PPDA.1.0 Commented Start
// pageextension 14021466 NS_PurchaseStatss extends "Purchase Stats."
// {
//     // version NAVNA11.00,PPNA11.00

//     layout
//     {
//         addafter(TotalAmount2)
//         {
//             field("NS Retention Amount (LCY)"; Rec."NS_Retention Amount (LCY)")
//             {
//                 ApplicationArea = All;
//                 Editable = false;
//                 ToolTip = 'Specifies the Retention Amount (LCY)';
//             }
//             field("NS Final Total"; PP_FinalTotal)
//             {
//                 ApplicationArea = All;
//                 Caption = 'Final Total';

//                 ToolTip = 'Final Total';
//                 Editable = false;
//             }
//         }
//         addafter("Vend.""Balance (LCY)""")
//         {
//             field("NS Retention Balance LCY"; PP_RetentionBalanceLCY)
//             {
//                 ApplicationArea = All;
//                 AutoFormatType = 1;
//                 Caption = 'Retention Balance ($)';

//                 ToolTip = 'Retention Balance ($)';
//                 Editable = false;
//             }
//         }
//     }

//     var
//         PP_JobsSetup: Record "Jobs Setup";
//         PP_RetentionBalanceLCY: Decimal;
//         PP_FinalTotal: Decimal;
//         p: Codeunit "NS_Parameters for Events";

//     trigger OnAfterGetRecord();
//     begin
//         PP_FinalTotal := p.NS_P10043GetNS_FinalTotal();
//         PP_RetentionBalanceLCY := p.NS_P10043GetNS_RetentionBalanceLCY();
//     end;

//     /*
//       +------------------------------------------------------------
//       +ProjectPro
//       +  - Added field(s):
//       +     "PP Retention Amount (LCY)"
//       +     "PP Final Total"
//       +     "PP Retention Balance (LCY)"
//       +
//       +  - Added global variable(s):
//       +     PP_JobsSetup
//       +     PP_RetentionBalanceLCY
//       +     PP_FinalTotal
//       +
//       +  - Modification(s):
//       +     - OnOpenPage: get Jobs Setup record
//       +     - OnAfterGetRecord: calculate Retention Balance (LCY) and Final Total
//       +------------------------------------------------------------
//     */

// }

//PPDA.1.0 Commented End