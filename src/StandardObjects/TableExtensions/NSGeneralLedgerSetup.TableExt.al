tableextension 14021117 NS_GeneralLedgerSetup extends "General Ledger Setup"
{
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,PPNA11.00

    fields
    {
        field(14021400; "NS_G/L Use Tax Account No."; Code[20])
        {
            Caption = 'G/L Use Tax Account No.';
            Description = 'Project Pro';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(14021401; "NS_G/L Use Tax Bal.AccountNo."; Code[20])
        {
            Caption = 'G/L Use Tax Bal. Account No.';
            Description = 'Project Pro';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(14021402; "NS_G/L Use Tax JobCostCategory"; Code[10])
        {
            Caption = 'G/L Use Tax Job Cost Category';
            Description = 'Project Pro';
            TableRelation = "NS_Job Cost Category";
            DataClassification = CustomerContent;
        }
        field(14021403; "NS_G/L Job Sales Tax Acc. No."; Code[20])
        {
            Caption = 'G/L Job Sales Tax Acc. No.';
            Description = 'Project Pro';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(14021404; "NS_Disable VariantCheckAdjmt."; Boolean)
        {
            Caption = 'Disable Variant Check Adjmt.';
            Description = 'Project Pro';
            DataClassification = CustomerContent;
        }
    }

    /* +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     14021400 G/L Use Tax Account No.
      +     14021401 G/L Use Tax Bal. Account No.
      +     14021402 G/L Use Tax Job Cost Category
      +     14021403 G/L Job Sales Tax Acc. No.
      +     14021404 Disable Variant Check Adjmt.
      +
      +-----------------------------------------------------------------------------------------------*/

}

