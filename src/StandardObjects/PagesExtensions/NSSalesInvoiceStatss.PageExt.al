//PPDA.1.0.TBA Start
// pageextension 14021464 NS_SalesInvoiceStatss extends "Sales Invoice Stats."
// {
//     // version NAVNA11.00,PPNA11.00

//     layout
//     {
//         modify(TaxAmount)
//         {
//             Visible = false;
//         }
//         modify(AmountInclTax)
//         {
//             Visible = false;
//         }

//         addafter(AmountInclTax)
//         {
//             field("NS_TaxAmount"; NS_TaxAmount)
//             {
//                 Caption = 'Tax Amount';
//                 ToolTip = 'Specifies the tax amount.';
//                 AutoFormatType = 1;
//                 AutoFormatExpression = "Currency Code";
//                 ApplicationArea = all;
//             }
//             field("NS_AmountInclTax"; NS_AmountInclTax)
//             {
//                 Caption = 'Total Incl. Tax';
//                 ToolTip = 'Specifies the total amount, including tax, that has been posted as invoiced.';
//                 AutoFormatType = 1;
//                 AutoFormatExpression = "Currency Code";
//                 ApplicationArea = all;
//             }

//             field("NS_Retention Amount (LCY)"; "NS_Retention Amount (LCY)")
//             {
//                 ApplicationArea = All;
//                 ToolTip = 'Specifies the Retention Amount (LCY)';
//             }
//             field("NS_Final Total"; NS_FinalTotal)
//             {
//                 ApplicationArea = All;
//                 Caption = 'Final Total';

//                 ToolTip = 'Final Total';
//             }
//         }
//         addafter("Cust.""Balance (LCY)""")
//         {
//             field("NS_Retention Balance LCY"; NS_RetentionBalanceLCY)
//             {
//                 ApplicationArea = All;
//                 AutoFormatType = 1;
//                 Caption = 'Retention Balance ($)';

//                 ToolTip = 'Retention Balance ($)';
//             }
//         }
//     }

//     var
//         p: Codeunit "NS_Parameters for Events";

//         NS_RetentionBalanceLCY: Decimal;
//         NS_FinalTotal: Decimal;
//         NS_TaxAmount: Decimal;
//         NS_AmountInclTax: Decimal;

//     trigger OnAfterGetRecord()
//     begin
//         p.NS_P10041Get(NS_RetentionBalanceLCY, NS_FinalTotal, NS_AmountInclTax, NS_TaxAmount);
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
//       +     PP_SalesSetup
//       +     PP_JobsSetup
//       +     PP_RetentionBalanceLCY
//       +     PP_FinalTotal
//       +
//       +  - Modification(s):
//       +     - OnOpenPage: get Sales & Receivables Setup and Jobs Setup records
//       +     - OnAfterGetRecord: calculate Retention Balance (LCY) and Final Total
//       +                        adjust Tax calculations to take Retention into account
//       +                        Implement new sales tax calculation method: Calc tax only on non-Retention Sales Line Amount
//       +------------------------------------------------------------
//     */

// }

//PPDA.1.0.TBA End