tableextension 14021202 NS_SalesRecSetup extends "Sales & Receivables Setup"
{
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,PPNA11.00
    //PRJ-931.JS.1.0 23Sep2021 | Add one filed

    fields
    {
        field(14021150; "NS_Normal Customer Ledger No."; Code[20])
        {
            Caption = 'Normal Customer Ledger No.';
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            DataClassification = CustomerContent;
        }
        field(14021151; "NS_Sales Retention Inactive"; Boolean)
        {
            Caption = 'Sales Retention Inactive';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021400; "NS_Ship-To Address Nos."; Code[10])
        {
            Caption = 'Ship-To Address Nos.';
            Description = 'ProjectPro';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(14021401; "NS_Past Due BalanceGracePeriod"; DateFormula)
        {
            Caption = 'Past Due Balance Grace Period';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                CreditReviewMgt.NS_Authorize(STRSUBSTNO(Text14021400, FIELDCAPTION("NS_Past Due BalanceGracePeriod")));
            end;
        }
        field(14021402; "NS_CreditReviewToleranceAmount"; Decimal)
        {
            Caption = 'Credit Review Tolerance Amount';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                CreditReviewMgt.NS_Authorize(STRSUBSTNO(Text14021400, FIELDCAPTION("NS_CreditReviewToleranceAmount")));
            end;
        }
        field(14021403; "NS_Disable Sales Price"; Boolean)     //PRJ-931.JS.1.0�23Sep2021
        {
            Caption = 'Disable Sales Price';
            Description = 'Disable Sales Price for Sales line';
            DataClassification = CustomerContent;
        }
    }

    var
        CreditReviewMgt: Codeunit "NS_Job CreditReviewMgt.";
        Text14021400: Label 'Not authorized to change %1.';
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +      14021150 Normal Customer Ledger No.
//   +      14021151 Sales Retention Inactive
//   +      14021400 Ship-to Adress Nos.
//   +      14021401 Past Due Balance Grace Period
//   +      14021402 Credit Review Tolerance Amount

//   +  - Added function(s):
//   +
//   +  - Added global variable(s):
//   +      CreditReviewMgt
//   +      Text14021400
//   +
//   +  - Added global text constant(s):
//   +
//   +  - Modification(s):
//   +
//   +-----------------------------------------------------------------------------------------------