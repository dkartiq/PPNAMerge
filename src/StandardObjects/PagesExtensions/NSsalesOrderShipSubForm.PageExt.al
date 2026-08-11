//PPDA.1.0.TBA Start
// pageextension 14021460 NS_SalesOrderShipSubForm extends "Sales Order Shipment Subform"
// {
//     // version NAVNA11.00,PPNA11.00

//     layout
//     {
//         modify("No.")
//         {
//             Visible = false;
//             Enabled = false;
//         }
//         addafter(Type)
//         {
//             field("NS_No.2"; Rec."No.")
//             {
//                 ApplicationArea = All;
//                 Caption = 'No.';
//                 ToolTip = 'Specifies the number of the record.';
//                 Editable = false;
//                 trigger OnValidate();
//                 begin
//                     ShowShortcutDimCode(ShortcutDimCode);
//                     //ProjectPro - start
//                     IF Type = Type::Resource THEN BEGIN
//                         NS_Resource.GET("No.");
//                         "NS_Job Revenue Category" := NS_Resource."NS_Job Revenue Category";
//                     END;
//                     //ProjectPro - end
//                     NoOnAfterValidate;
//                 end;
//             }
//         }

//         addafter(Nonstock)
//         {
//             field("NS_Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
//             {
//                 ApplicationArea = All;
//                 ToolTip = 'Specifies the Gen. Bus. Posting Group';
//             }
//             field("NS_Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
//             {
//                 ApplicationArea = All;
//                 ToolTip = 'Specifies the Gen. Prod. Posting Group';
//             }
//         }
//         addafter("Quantity Shipped")
//         {
//             field("NS_Job No."; Rec."Job No.")
//             {
//                 ApplicationArea = All;
//                 ToolTip = 'Specifies the Job No.';

//                 trigger OnValidate();
//                 begin
//                     //ProjectPro - start
//                     NS_Job.CorrectForBlankFields("Job No.", "Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
//                     //ProjectPro - end
//                 end;
//             }
//             field("NS_Job Task No."; Rec."Job Task No.")
//             {
//                 ApplicationArea = All;
//                 ToolTip = 'Specifies the Job Task No.';

//                 trigger OnValidate();
//                 begin
//                     //ProjectPro - start
//                     NS_Job.CorrectForBlankFields("Job No.", "Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
//                     //ProjectPro - end
//                 end;
//             }
//             field("NS_Job Cost Category"; Rec."NS_Job Cost Category")
//             {
//                 ApplicationArea = All;
//                 ToolTip = 'Specifies the Job Cost Category';

//                 trigger OnValidate();
//                 begin
//                     //ProjectPro - start
//                     NS_Job.CorrectForBlankFields("Job No.", "Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
//                     //ProjectPro - end
//                 end;
//             }
//             field("NS_Job Revenue Category"; Rec."NS_Job Revenue Category")
//             {
//                 ApplicationArea = All;
//                 ToolTip = 'Specifies the Job Revenue Category';

//                 trigger OnValidate();
//                 begin
//                     //ProjectPro - start
//                     NS_Job.CorrectForBlankFields("Job No.", "Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
//                     //ProjectPro - end
//                 end;
//             }
//         }
//     }

//     var
//         NS_Job: Record Job;
//         NS_Resource: Record Resource;
//         ShortcutDimCode: ARRAY[8] OF Code[20];

//     LOCAL PROCEDURE NoOnAfterValidate();
//     BEGIN
//         InsertExtendedText(FALSE);
//         IF (Type = Type::"Charge (Item)") AND ("No." <> xRec."No.") AND
//            (xRec."No." <> '')
//         THEN
//             CurrPage.SAVERECORD;
//     END;

//     /*
//       +------------------------------------------------------------
//       +ProjectPro
//       +  - Added field(s):
//       +     "PP Gen. Bus. Posting Group"
//       +     "PP Gen. Prod. Posting Group"
//       +     "PP Job No."
//       +     "PP Job Task No."
//       +     "PP Job Cost Category"
//       +     "PP Job Revenue Category"
//       +     "PP Retention Applies"
//       +
//       +  - Added global variable(s):
//       +     PP_Job
//       +     PP_Resource
//       +
//       +  - Modification(s):
//       +     - No. - OnValidate() -  set default value for Job Revenue Category from the related record in the Resource table
//       +     - If the Job No. is blank, then clear Job Task No., Job Cost Category, and Job Revenue Category
//       +     - "PP Job No." - OnValidate() Correct for blank fields
//       +     - "PP Job Task No." - OnValidate() Correct for blank fields
//       +     - "PP Job Cost Category" - OnValidate() Correct for blank fields
//       +     - "PP Job Revenue Category" - OnValidate() Correct for blank fields
//       +
//       + -SMP
//       +  -Rewritten fields
//       +   - No.
//       +------------------------------------------------------------
//     */

// }

//PPDA.1.0.TBA End