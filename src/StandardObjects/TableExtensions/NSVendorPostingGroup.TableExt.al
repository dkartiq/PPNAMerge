tableextension 14021116 NS_VendorPostingGroup extends "Vendor Posting Group"
{
    // version NAVW111.00.00.24742,PPNA11.00
    //PRJCTPR-279.HS.1.0 17Jan2024 | Added Code

    fields
    {
        field(14021150; "NS_Retention Payables Account"; Code[20])
        {
            Caption = 'Retention Payables Account';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";

            trigger OnValidate();
            begin
                //ProjectPro - start
                GLAccountCategoryMgt.CheckGLAccount("NS_Retention Payables Account", false, false, GLAccountCategory."Account Category"::Expense, '');
                //ProjectPro - end

                //PRJCTPR-279.HS.1.0 17Jan2024 Start
                NS_GLAcc.Reset();
                NS_GLAcc.SetRange("No.", Rec."NS_Retention Payables Account");
                if NS_GLAcc.FindFirst() then begin
                    if NS_GLAcc."Gen. Prod. Posting Group" = '' then
                        Error('There must be a General Product Posting Group on %1. It cannot be blank.', Rec."NS_Retention Payables Account");
                end;
                //PRJCTPR-279.HS.1.0 17Jan2024 End
            end;
        }
    }
    var
        GLAccountCategoryMgt: Codeunit 570;
        GLAccountCategory: Record 570;
        NS_GLAcc: record "G/L Account"; //PRJCTPR-279.HS.1.0 17Jan2024
}

//  +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021150 Retention Payables Account
//   +
//   +  - Added function(s):
//   +
//   +  - Added global variable(s):
//   +
//   +  - Added global text constant(s):
//   +
//   +  - Modification(s):
//   +
//   +-----------------------------------------------------------------------------------------------