//PPDA.1.0.TBA Start
// pageextension 14021463 NS_PurchOrderStatss extends "Purchase Order Stats."
// {
//     // version NAVNA11.00,PPNA11.00
//     //PRJ-276.MS.1.0 added code for retention 

//     layout
//     {
//         addafter("TotalAmount2[1]")
//         {
//             //field("PP Retention Amount LCY"; "NS_Retention Amount (LCY)") //PRJ-276.MS.1.0 code comment
//             field("NS_Total Retention Amount"; TotalRetenAmt)   //PRJ-276.MS.1.0 code comment
//             {
//                 ApplicationArea = All;
//                 Editable = false;
//                 ToolTip = 'Specifies the Retention Amount (LCY)';
//             }
//             field("NS Final Total"; NS_FinalTotal)
//             {
//                 ApplicationArea = All;
//                 AutoFormatExpression = "Currency Code";
//                 AutoFormatType = 1;
//                 Caption = 'Final Total';
//                 Editable = false;
//             }
//         }
//         addafter("TotalAmount2[2]")
//         {
//             field("NS Retention Amount (LCY)"; Rec."NS_Retention Amount (LCY)")
//             {
//                 ApplicationArea = All;
//                 Editable = false;
//                 ToolTip = 'Specifies the Retention Amount (LCY)';
//             }
//         }
//         addafter("TotalAmount2[3]")
//         {
//             field("NS Retention Amount [LCY]"; Rec."NS_Retention Amount (LCY)")
//             {
//                 ApplicationArea = All;
//                 Editable = false;
//                 ToolTip = 'Specifies the Retention Amount (LCY)';
//             }
//         }
//         addafter("Vend.""Balance (LCY)""")
//         {
//             field("NS RetentionBalanceLCY"; NS_RetentionBalanceLCY)
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
//         NS_RetentionBalanceLCY: Decimal;
//         NS_FinalTotal: Decimal;
//         NS_FinalTotal1: Decimal; //PRJ-276.MS.1.0 
//         p: Codeunit "NS_Parameters for Events";
//         TotalRetenAmt: Decimal; //PRJ-276.MS.1.0 

//     trigger OnAfterGetCurrRecord()
//     begin
//         //PRJ-276.MS.1.0 
//         NS_FinalTotal1 := p.NS_P10039GetPPFinalTotal();
//         NS_RetentionBalanceLCY := p.NS_P10039GetNS_RetentionBalanceLCY();
//         TotalRetenAmt := GetTotalRetention;
//         NS_FinalTotal := NS_FinalTotal1 + "NS_Retention Amount (LCY)" - TotalRetenAmt;
//         //PRJ-276.MS.1.0   
//     end;

//     trigger OnAfterGetRecord();
//     begin
//         //PP_FinalTotal := p.P10039GetPPFinalTotal();//PRJ-276.MS.1.0 code comment
//         NS_FinalTotal1 := p.NS_P10039GetPPFinalTotal(); //PRJ-276.MS.1.0 
//         NS_RetentionBalanceLCY := p.NS_P10039GetNS_RetentionBalanceLCY();
//         TotalRetenAmt := GetTotalRetention; //PRJ-276.MS.1.0
//         NS_FinalTotal := NS_FinalTotal1 + "NS_Retention Amount (LCY)" - TotalRetenAmt; //PRJ-276.MS.1.0  
//     end;

//     ////PRJ-276.MS.1.0
//     local procedure GetTotalRetention(): Decimal
//     var
//         PurchaseLine: Record "Purchase Line";
//         TotalRetn: Decimal;
//     begin

//         TotalRetn := 0;
//         PurchaseLine.reset;
//         Purchaseline.SetCurrentKey("Document No.", "Document No.");
//         Purchaseline.SetRange("Document Type", "Document Type");
//         Purchaseline.SetRange("Document No.", "no.");
//         Purchaseline.CalcSums("Line Amount");
//         if "NS_Retention Percent" <> 0 then
//             TotalRetn := PurchaseLine."Line Amount" / "NS_Retention Percent";
//         exit(TotalRetn);

//     end;
//     //PRJ-276.MS.1.0
//     // +------------------------------------------------------------
//     // +ProjectPro
//     // +  - Added field(s):
//     // +     "PP Retention Amount (LCY)"
//     // +     "PP Final Total"
//     // +     "PP RetentionBalanceLCY"
//     // +
//     // +  - Added global variable(s):
//     // +     PP_JobsSetup
//     // +     PP_RetentionBalanceLCY
//     // +     PP_FinalTotal
//     // +
//     // +  - Modification(s):
//     // +     - OnOpenPage: get Jobs Setup record
//     // +     - OnAfterGetRecord: calulate Retention Balance and Final Total
//     // +------------------------------------------------------------
// }

//PPDA.1.0.TBA End