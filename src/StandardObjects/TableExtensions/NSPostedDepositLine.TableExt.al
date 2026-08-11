//PPDA.1.0.TBA Start
// tableextension 14021239 NS_PostedDepositLine extends "Posted Deposit Line"
// {
//     // version NAVNA11.00,PPNA11.00

//     fields
//     {
//         field(14021100; "NS_Job No."; Code[20])
//         {
//             Caption = 'Job No.';
//             Description = 'ProjectPro';
//             TableRelation = Job;
//             DataClassification = CustomerContent;
//         }
//         field(14021104; "NS_Job Task No."; Code[35])
//         {
//             Caption = 'Job Task No.';
//             Description = 'ProjectPro';
//             TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("NS_Job No."));
//             DataClassification = CustomerContent;
//         }
//         field(14021162; "NS_Retention Ledger Code"; Code[20])
//         {
//             Caption = 'Retention Ledger Code';
//             Description = 'ProjectPro';
//             TableRelation = "NS_Retention Ledger Code".NS_Code;
//             DataClassification = CustomerContent;
//         }
//         field(14021300; "NS_Subcontract No."; Code[20])
//         {
//             Caption = 'Subcontract No.';
//             Description = 'ProjectPro';
//             TableRelation = NS_Subcontract;
//             DataClassification = CustomerContent;
//         }
//     }
//     /*+---------------------------------------------------------------------------------------------
//     +ProjectPro
//     +  - Added field(s):
//     +     14021100 Job No.
//     +     14021104 Job Task No.
//     +     14021162 Retention Ledger Code
//     +     14021300 Subcontract No.
//     +
//     +-----------------------------------------------------------------------------------------------*/
// }
//PPDA.1.0.TBA End
