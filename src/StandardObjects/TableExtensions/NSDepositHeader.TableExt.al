//PPDA.1.0.TBA Start
// tableextension 14021237 NS_DepositHeader extends "Deposit Header"
// {
//     // version NAVNA11.00,PPNA11.00

//     fields
//     {
//         field(14021301; "NS_Retention Ledger Code"; Code[20])
//         {
//             Caption = 'Retention Ledger Code';
//             Description = 'ProjectPro';
//             TableRelation = "NS_Retention Ledger Code".NS_Code;
//             DataClassification = CustomerContent;
//         }
//     }

//     var
//         PP_SalesReceivablesSetup: Record "Sales & Receivables Setup";
// }
//PPDA.1.0.TBA End
//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021301 Retention Ledger Code
//   +
//   +-----------------------------------------------------------------------------------------------
