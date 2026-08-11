//PPDA.1.0.TBA Start
// pageextension 14021467 NS_SalesCrMemoStatss extends "Sales Credit Memo Stats."
// {
//     // version NAVNA11.00,PPNA11.00

//     layout
//     {
//         addafter(AmountInclTax)
//         {
//             field("NS_Retention Amount (LCY)"; Rec."NS_Retention Amount (LCY)")
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

//             field(NS_CustomerBalanceLCY; Customer."Balance (LCY)")
//             {
//                 Caption = 'Balance ($)';
//                 ToolTip = 'Specifies the customer''s balance. ';
//                 ApplicationArea = all;
//                 AutoFormatType = 1;
//             }

//             field("NS_Retention Balance LCY"; NS_RetentionBalanceLCY)
//             {
//                 ApplicationArea = All;
//                 AutoFormatType = 1;
//                 Caption = 'Retention Balance ($)';

//                 ToolTip = 'Retention Balance ($)';
//             }

//             field(NS_CustomerCreditLimitLCY; Customer."Credit Limit (LCY)")
//             {
//                 Caption = 'Credit Limit ($)';
//                 ToolTip = 'Specifies the customer''s credit limit.';
//                 ApplicationArea = all;
//                 AutoFormatType = 1;
//             }
//             field(NS_CreditLimitLCYExpendedPct; CreditLimitLCYExpendedPct)
//             {
//                 Caption = 'Expended % of Credit Limit ($)';
//                 ToolTip = 'Specifies how must of the customer''s credit is used, expressed as a percentage of the credit limit.';
//                 ApplicationArea = all;
//             }

//         }


//         modify("Cust.""Balance (LCY)""")
//         {
//             Visible = false;
//             Enabled = false;
//         }

//         modify("Cust.""Credit Limit (LCY)""")
//         {
//             Visible = false;
//             Enabled = false;
//         }
//         modify(CreditLimitLCYExpendedPct)
//         {
//             Visible = false;
//             Enabled = false;
//         }

//     }

//     var
//         Customer: Record Customer;

//         NS_SalesSetup: Record "Sales & Receivables Setup";
//         NS_JobsSetup: Record "Jobs Setup";
//         NS_RetentionBalanceLCY: Decimal;
//         NS_FinalTotal: Decimal;
//         AmountInclTax: Decimal;
//         CreditLimitLCYExpendedPct: Decimal;


//     trigger OnOpenPage();
//     begin
//         //ProjectPro - start
//         NS_SalesSetup.GET;
//         NS_JobsSetup.GET;
//         //ProjectPro - end
//     end;

//     trigger OnAfterGetRecord()
//     var
//         SalesCrMemoLine: Record 115;

//     begin
//         SalesCrMemoLine.SETRANGE("Document No.", "No.");

//         if SalesCrMemoLine.FIND('-') then
//             repeat
//                 AmountInclTax := AmountInclTax + SalesCrMemoLine."Amount Including VAT";
//             until SalesCrMemoLine.Next = 0;

//         if (Customer.GET("Bill-to Customer No.")) then begin
//             NS_RetentionBalanceLCY := 0;
//             if not NS_SalesSetup."NS_Sales Retention Inactive" then
//             //ProjectPro - start
//              begin
//                 Customer.SetRange("NS_Retention Ledger CodeFilter", NS_JobsSetup."NS_Retention Receivable Ledger");
//                 Customer.CalcFields("Balance (LCY)");
//                 NS_RetentionBalanceLCY := Customer."Balance (LCY)";
//                 Customer.SetRange("NS_Retention Ledger CodeFilter", NS_SalesSetup."NS_Normal Customer Ledger No.");
//             end;
//             //ProjectPro - end
//             Customer.CalcFields("Balance (LCY)");
//         end
//         else
//             Clear(Customer);

//         if (Customer."Credit Limit (LCY)" = 0) then
//             CreditLimitLCYExpendedPct := 0
//         else
//             if (Customer."Balance (LCY)" / Customer."Credit Limit (LCY)" < 0) then
//                 CreditLimitLCYExpendedPct := 0
//             else
//                 if (Customer."Balance (LCY)" / Customer."Credit Limit (LCY)" > 1) then
//                     CreditLimitLCYExpendedPct := 10000
//                 else
//                     CreditLimitLCYExpendedPct := ROUND(Customer."Balance (LCY)" / Customer."Credit Limit (LCY)" * 10000, 1);

//         //ProjectPro - start
//         NS_FinalTotal := AmountInclTax - "NS_Retention Amount (LCY)";
//         //ProjectPro - end

//     end;

//     //   +------------------------------------------------------------
//     //   +ProjectPro
//     //   +  - Added field(s):
//     //   +     "PP Retention Amount (LCY)"
//     //   +     "PP Final Total"
//     //   +     "PP Retention Balance (LCY)"
//     //   +
//     //   +  - Added global variable(s):
//     //   +     PP_SalesSetup
//     //   +     PP_JobsSetup
//     //   +     PP_RetentionBalanceLCY
//     //   +     PP_FinalTotal
//     //   +
//     //   +  - Modification(s):
//     //   +     - OnOpenPage: get Sales & Receivables Setup and Jobs Setup records
//     //   +     - OnAfterGetRecord: calculate Retention Balance (LCY) and Final Total
//     //   +------------------------------------------------------------

// }

//PPDA.1.0.TBA End