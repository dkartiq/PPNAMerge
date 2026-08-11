//PPDA.1.0 Commented Start
// pageextension 14021468 NS_PurchaseInvoiceStatss extends "Purchase Invoice Stats."
// {
//     // version NAVNA11.00,PPNA11.00
//     //PRJ-196 VT 08-04-20 : Code Added and Commented
//     layout
//     {
//         addafter(AmountInclVAT)
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

//         modify("Vend.""Balance (LCY)""")
//         {
//             Visible = false;
//             Enabled = false;
//         }

//         addafter("Vend.""Balance (LCY)""")
//         {
//             field(NS_VendBalanceLCY; Vend."Balance (LCY)")
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
//                 Editable = false;
//             }
//         }
//     }

//     var
//         NS_JobsSetup: Record "Jobs Setup";
//         NS_PurchSetup: Record "Purchases & Payables Setup";
//         NS_RetentionBalanceLCY: Decimal;
//         NS_FinalTotal: Decimal;
//         VendAmount: Decimal;
//         AmountInclVAT: Decimal;
//         TaxAmount: Decimal;
//         PurchInvLine: Record 123;
//         Vend: Record 23;
//         p: Codeunit "NS_Parameters for Events"; //PRJ-196 VT 08-04-20 Added


//     trigger OnOpenPage()
//     begin
//         //ProjectPro - start
//         NS_PurchSetup.GET;
//         NS_JobsSetup.GET;
//         //ProjectPro - end
//     end;


//     trigger OnAfterGetRecord()
//     var
//         TempSalesTaxAmtLine: Record 10011 temporary;
//     begin
//NS_FinalTotal := p.P10045GetNS_FinalTotal();//PRJ-196 VT 08-04-20 Added //PRJCTPR-336.NC.1.0 19Mar2024 Block
//         PurchInvLine.SETRANGE("Document No.", "No.");
//         IF PurchInvLine.FIND('-') THEN
//             REPEAT
//                 VendAmount := VendAmount + PurchInvLine.Amount;
//                 AmountInclVAT := AmountInclVAT + PurchInvLine."Amount Including VAT";
//             UNTIL PurchInvLine.NEXT = 0;
//NS_FinalTotal := AmountInclVAT - Rec."NS_Retention Amount (LCY)"; //PRJCTPR-336.NC.1.0 19Mar2024
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
//         //NS_FinalTotal := AmountInclVAT - "Retention Amount (LCY)"; //PRJ-196 VT 07-04-20 Commented
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
//     //   +     PP_JobsSetup
//     //   +     PP_PurchSetup
//     //   +     PP_RetentionBalanceLCY
//     //   +     PP_FinalTotal
//     //   +
//     //   +  - Modification(s):
//     //   +      - OnOpenPage: get Jobs Setup and Purchase & Payables Setup records
//     //   +      - OnAfterGetRecord: calculate Tax Amount, Retention Balance LCY, and Final Total
//     //   +------------------------------------------------------------
//     //          
//     //
//     //      SMP - recreated OnAfterGetRecord parts from standard
//     //      SMP - replaced Vend."Balance (LCY)" with custom one

// }

//PPDA.1.0 Commented End