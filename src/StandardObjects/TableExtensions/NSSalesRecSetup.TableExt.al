tableextension 14021202 NS_SalesRecSetup extends "Sales & Receivables Setup"
{
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,PPNA11.00
    //PRJ-931.JS.1.0 23Sep2021 | Add one filed
    //PRJ-1624.NK.1.0 21Sep2022 | Add One Field
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
        //PRJ-1543.GK.1.0 28July2022 start
        field(14021404; "NS_Allow Description excl Nos."; Boolean)
        {
            Caption = 'Allow Description on Progress Billing excluding Nos.';
            Description = 'Allow Description excluding Nos. For Progress Billing Sales Document';
            DataClassification = CustomerContent;
        }
        //PRJ-1543.GK.1.0 28July2022 end
        //PRJ-1624.NK.1.0 21Sep2022 Start
        field(14021405; "NS_Allow diff Ret. On PB Line"; Boolean)
        {
            Caption = 'Allow different Retention On PB Lines';
            Description = 'This field is use to allow for different Retention % on Progress Billings & Direct Sales Invoice';
            DataClassification = CustomerContent;
        }
        //PRJ-1624.NK.1.0 21Sep2022 End
        //PRJCTPR-312 AT.1.0 09feb2024 start
        field(14021407; "NS_Skip Recurring Method"; Boolean)
        {
            Caption = 'Skip Error Recurring Method (MEM)';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            Editable = false;
        }
        //PRJCTPR-312 AT.1.0 09feb2024 End
        //PE-302.JS.1.0 20MAY2024-Start
        field(14021411; "NS_AutoApplySCM After Posting"; Boolean)
        {
            Caption = 'Auto Apply SCM After Posting';
            Description = 'Auto Apply Sales Credit Memo After Posting if ProjectPro using with another (ISV)';
            DataClassification = CustomerContent;
        }
        //PE-302.JS.1.0 20MAY2024-end
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