tableextension 14021115 NS_CustomerPostGroup extends "Customer Posting Group"
{
    // version NAVW111.00.00.24742,PPNA11.00

    fields
    {
        field(14021150; "NS_RetentionReceivablesAccount"; Code[20])
        {
            Caption = 'Retention Receivables Account';
            Description = 'ProjectPro';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                GLAccountCategoryMgt.CheckGLAccount("NS_RetentionReceivablesAccount", false, false, GLAccountCategory."Account Category"::Income, '');
                //ProjectPro - end
            end;
        }
    }
    var
        GLAccountCategoryMgt: Codeunit 570;
        GLAccountCategory: Record 570;

    /*+---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     14021150 Retention Receivables Account
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +-----------------------------------------------------------------------------------------------*/
}

