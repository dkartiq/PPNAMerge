tableextension 14021116 NS_VendorPostingGroup extends "Vendor Posting Group"
{
    // version NAVW111.00.00.24742,PPNA11.00

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
            end;
        }
    }
    var
        GLAccountCategoryMgt: Codeunit 570;
        GLAccountCategory: Record 570;
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