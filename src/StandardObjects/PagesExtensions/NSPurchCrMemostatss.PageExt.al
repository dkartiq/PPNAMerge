//PPDA.1.0.TBA Start
// pageextension 14021469 NS_PurchCrMemoStatssExt extends "Purch. Credit Memo Stats."
// {
//     // version NAVNA11.00,PPNA11.00

//     layout
//     {
//         addafter(AmountInclVAT)
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
//                 Editable = false;
//             }
//         }

//         modify("Vend.""Balance (LCY)""")
//         {
//             Enabled = false;
//             Visible = false;
//         }

//         addafter("Vend.""Balance (LCY)""")
//         {

//             field(NS_VendBalanceLCY; Vend."Balance (LCY)")
//             {
//                 Caption = 'Balance ($)';
//                 ToolTip = 'Specifies the customer''s balance. ';
//                 ApplicationArea = All;
//                 ;
//                 AutoFormatType = 1;
//             }

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
//         NS_JobsSetup: Record "Jobs Setup";
//         NS_PurchSetup: Record "Purchases & Payables Setup";
//         NS_RetentionBalanceLCY: Decimal;
//         NS_FinalTotal: Decimal;
//         PurchCrMemoLine: Record "Purch. Cr. Memo Line";
//         Vend: Record Vendor;
//         VendAmount: Decimal;
//         AmountInclVAT: Decimal;
//         TaxAmount: Decimal;

//     trigger OnOpenPage();
//     begin
//         //ProjectPro - start
//         NS_PurchSetup.GET;
//         NS_JobsSetup.GET;
//         //ProjectPro - end
//     end;

//     trigger OnAfterGetRecord()
//     var
//         TempSalesTaxAmtLine: Record "Sales Tax Amount Line" temporary;
//     begin
//         PurchCrMemoLine.SETRANGE("Document No.", "No.");

//         IF PurchCrMemoLine.FIND('-') THEN
//             REPEAT
//                 VendAmount := VendAmount + PurchCrMemoLine.Amount;
//                 AmountInclVAT := AmountInclVAT + PurchCrMemoLine."Amount Including VAT";
//             UNTIL PurchCrMemoLine.NEXT = 0;

//         //ProjectPro - start
//         IF NS_JobsSetup."NS_Calc Payable Ret Before Tax" THEN
//             TaxAmount := AmountInclVAT - VendAmount + "NS_Retention Amount (LCY)"
//         ELSE
//             //ProjectPro - end
//             TaxAmount := AmountInclVAT - VendAmount;

//         IF NOT Vend.GET("Pay-to Vendor No.") THEN
//             CLEAR(Vend);
//         //ProjectPro - start
//         NS_RetentionBalanceLCY := 0;
//         IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN BEGIN
//             Vend.SETRANGE("NS_Retention Ledger CodeFilter", NS_JobsSetup."NS_Retention Payable Ledger");
//             Vend.CALCFIELDS("Balance (LCY)");
//             NS_RetentionBalanceLCY := Vend."Balance (LCY)";
//             Vend.SETRANGE("NS_Retention Ledger CodeFilter", NS_PurchSetup."NS_Normal Vendor Ledger No.");
//         END;
//         //ProjectPro - end
//         Vend.CALCFIELDS("Balance (LCY)");

//         AmountInclVAT := VendAmount;
//         TaxAmount := 0;

//         WITH TempSalesTaxAmtLine DO BEGIN
//             RESET;
//             SETCURRENTKEY("Print Order", "Tax Area Code for Key", "Tax Jurisdiction Code");
//             IF FINDSET THEN BEGIN
//                 REPEAT
//                     TaxAmount := TaxAmount + "Tax Amount";
//                 UNTIL NEXT = 0;
//                 AmountInclVAT := AmountInclVAT + TaxAmount;
//             end;
//         end;

//         //ProjectPro - start
//         NS_FinalTotal := AmountInclVAT - "NS_Retention Amount (LCY)";
//         //ProjectPro - end

//     end;

//     //       +------------------------------------------------------------
//     //       +ProjectPro
//     //       +  - Added field(s):
//     //       +     "PP Retention Balance (LCY)"
//     //       +     "PP Final Total"
//     //       +     "PP Retention Amount (LCY)"
//     //       +
//     //       +  - Added global variable(s):
//     //       +     PP_JobsSetup
//     //       +     PP_PurchSetup
//     //       +     PP_RetentionBalanceLCY
//     //       +     PP_FinalTotal
//     //       +
//     //       +  - Modification(s):
//     //       +     - OnOpenPage: get Jobs Setup and Purchase & Payables Setup records
//     //       +     - OnAfterGetRecord: calculate Tax Amount, Retention Balance LCY, and Final Total
//     //       +------------------------------------------------------------
//     //          
//     //
//     //      SMP - recreated OnAfterGetRecord parts from standard
//     //      SMP - replaced Vend."Balance (LCY)" with custom

// }

//PPDA.1.0.TBA End