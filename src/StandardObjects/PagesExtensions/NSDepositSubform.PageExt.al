//PPDA.1.0 Commenetd Start
// pageextension 14021471 NS_DepositSubForm extends "Deposit Subform"
// {
//     // version NAVNA11.00.00.23572,PPNA11.00
//     //PRJ-141.SK.1.0 Added code
//     layout
//     {
//         modify(Amount)
//         {
//             Visible = false;
//         }
//         addafter(Amount)
//         {
//             field("NS_Job No."; Rec."Job No.")
//             {
//                 ApplicationArea = All;
//                 ToolTip = 'Specifies the Job No.';

//                 trigger OnValidate();
//                 begin
//                     CurrPage.UPDATE;
//                 end;
//             }
//         }
//         //PRJ-141.SK.1.0 Start
//         modify("Account Type")
//         {
//             trigger OnAfterValidate()
//             begin
//                 IF xRec."Account Type" <> "Account Type" THEN
//                     CustomValidateProcedure;
//             end;
//         }
//         //PRJ-141.SK.1.0 End

//         //PRJ-141.SK.1.0 Start
//         modify("Account No.")
//         {
//             trigger OnAfterValidate()
//             begin
//                 IF xRec."Account No." <> "Account No." THEN
//                     CustomValidateProcedure;
//             end;
//         }
//         //PRJ-141.SK.1.0 End
//     }

//     var
//     // NS_JobsSetup: Record "Jobs Setup";
//     // Text14021100: Label 'There is no Default Deposit Job Task No. specified.\\Please setup one in Jobs Setup.';

//     trigger OnNewRecord(BelowxRec: Boolean);
//     begin
//         IF xRec."Account Type" <> "Account Type" THEN BEGIN
//             CustomValidateProcedure;
//         end;
//     end;

//     procedure CustomValidateProcedure()
//     var
//         DepositHeader: Record 10140;
//     begin
//         BEGIN
//             DepositHeader.SETCURRENTKEY("Journal Template Name", "Journal Batch Name");
//             DepositHeader.SETRANGE("Journal Template Name", "Journal Template Name");
//             DepositHeader.SETRANGE("Journal Batch Name", "Journal Batch Name");
//             DepositHeader.FINDFIRST;
//             "Bal. Account Type" := "Bal. Account Type"::"Bank Account";
//             "Bal. Account No." := DepositHeader."Bank Account No.";
//             "Currency Code" := DepositHeader."Currency Code";
//             "Currency Factor" := DepositHeader."Currency Factor";
//             VALIDATE("Posting Date", DepositHeader."Posting Date");
//             "External Document No." := DepositHeader."No.";
//             "Reason Code" := DepositHeader."Reason Code";
//             //ProjectPro - start
//             VALIDATE("Shortcut Dimension 1 Code", DepositHeader."Shortcut Dimension 1 Code");
//             VALIDATE("Shortcut Dimension 2 Code", DepositHeader."Shortcut Dimension 2 Code");
//             VALIDATE("NS_Retention Ledger Code", DepositHeader."NS_Retention Ledger Code");
//             //ProjectPro - end
//         end;
//     END;

//     LOCAL PROCEDURE AccountTypeOnAfterValidate();
//     BEGIN
//         IF "Account Type" = "Account Type"::Vendor THEN
//             "Document Type" := "Document Type"::Refund
//         ELSE
//             "Document Type" := "Document Type"::Payment;
//     END;

//     /*
//       +------------------------------------------------------------
//       +ProjectPro
//       +  - Added field(s):
//       +     "PP Job No."
//       +
//       +  - Added global variable(s):
//       +     NS_JobsSetup
//       +
//       +  - Added Text Constants:
//       +     Text14021100
//       +
//       +  - Modification(s):
//       +     - Set Shortcut Dimension 2 Code column as Visible=TRUE
//       +     - CopyValuesFromHeader: added code to copy Shortcut Dimension 1 Code, Shortcut Dimension 2 Code, and Retention Ledger Code
//       +     - Modified fields for use of 'Retention Ledger Code' instead of 'Global Dimension Code 2'
//       + -SMP
//       +  -pulled custom code to new procedure CustomValidateProcedure and set it to activate on NewRecord page trigger
//       +------------------------------------------------------------
//       */

// }

//PPDA.1.0 Commenetd End