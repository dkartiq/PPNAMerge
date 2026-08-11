//PPDA.1.0.TBA Start
// pageextension 14021462 NS_SalesOrderStatss extends "Sales Order Stats."
// {
//     // version NAVNA11.00,PPNA11.00

//     layout
//     {
//         addafter("TotalAmount2[1]")
//         {
//             field("NS Retention Amount (LCY)"; Rec."NS_Retention Amount (LCY)")
//             {
//                 ApplicationArea = All;
//                 Editable = false;
//                 ToolTip = 'Specifies the Retention Amount (LCY)';
//             }
//             field("NS Final Total"; NS_FinalTotal)
//             {
//                 ApplicationArea = All;
//                 Caption = 'Final Total';
//             }
//         }
//         addafter("TotalAmount2[2]")
//         {
//             field("NS Retention Amount LCY"; Rec."NS_Retention Amount (LCY)")
//             {
//                 ApplicationArea = All;
//                 ToolTip = 'Specifies the Retention Amount (LCY)';
//             }
//         }
//         addafter("TotalAmount2[3]")
//         {
//             field("NS Retention Amount [LCY]"; Rec."NS_Retention Amount (LCY)")
//             {
//                 ApplicationArea = All;
//                 ToolTip = 'Specifies the Retention Amount (LCY)';
//             }
//         }
//         addafter("Cust.""Balance (LCY)""")
//         {
//             field("NS Retention Balance LCY"; NS_RetentionBalanceLCY)
//             {
//                 ApplicationArea = All;
//                 AutoFormatType = 1;
//                 Caption = 'Retention Balance ($)';
//                 Editable = false;
//             }
//         }
//     }

//     var
//         NS_RetentionBalanceLCY: Decimal;
//         NS_FinalTotal: Decimal;
//         p: Codeunit "NS_Parameters for Events";

//     trigger OnAfterGetRecord();
//     begin
//         NS_FinalTotal := p.NS_P10038GetPPFinalTotal();
//         NS_RetentionBalanceLCY := p.NS_P10038GetNS_RetentionBalanceLCY();
//     end;
// }

//PPDA.1.0.TBA End