//PPDA.1.0.TBA Start
// pageextension 14021465 NS_SalesStatssExt extends "Sales Stats."
// {
//     // version NAVNA11.00,PPNA11.00

//     layout
//     {
//         addafter(TotalAmount2)
//         {
//             field("NS_Retention Amount (LCY)"; Rec."NS_Retention Amount (LCY)")
//             {
//                 ApplicationArea = All;
//                 Editable = false;
//                 ToolTip = 'Specifies the Retention Amount (LCY)';
//             }
//             field("NS_Final Total"; NS_FinalTotal)
//             {
//                 ApplicationArea = All;
//                 Caption = 'Final Total';
//                 Editable = false;
//             }
//         }
//         addafter("Cust.""Balance (LCY)""")
//         {
//             field("NS_Retention Balance LCY"; NS_RetentionBalanceLCY)
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
//         NS_FinalTotal := p.NS_P10042GetNS_FinalTotal();
//         NS_RetentionBalanceLCY := P.NS_P10042GetNS_RetentionBalanceLCY();


//     end;


// }

//PPDA.1.0.TBA End