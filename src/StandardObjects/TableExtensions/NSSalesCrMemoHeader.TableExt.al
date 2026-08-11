tableextension 14021122 NS_SalesCrMemoHeader extends "Sales Cr.Memo Header"
{
    // version NAVW111.00.00.24232,NAVNA11.00.00.24232,PPNA11.00

    fields
    {
        field(14021100; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            Description = 'ProjectPro';
            TableRelation = Job;
            DataClassification = CustomerContent;
        }
        field(14021136; "NS_Retention Base Amount"; Decimal)
        {
            Caption = 'Retention Base Amount';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021137; "NS_Retention Base Before Tax"; Decimal)
        {
            Caption = 'Retention Base Before Tax';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021138; "NS_Retention Percent"; Decimal)
        {
            Caption = 'Retention Percent';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021139; "NS_Retention Amount (LCY)"; Decimal)
        {
            Caption = 'Retention Amount ($)';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021140; "NS_Retention Amount"; Decimal)
        {
            Caption = 'Retention Amount';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021145; "NS_Retention Date"; Date)
        {
            Caption = 'Retention Date';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021146; "NS_Retention Document"; Boolean)
        {
            Caption = 'Retention Document';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021325; "NS_Progress Billing Document"; Boolean)
        {
            Caption = 'Progress Billing Document';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
        }
        field(14021327; "NS_From Progress Billing No."; Code[20])
        {
            Caption = 'From Progress Billing No.';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
        }
        field(14021328; "NS_From ProgressBillingReq.No."; Integer)
        {
            Caption = 'From Progress Billing Req. No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021329; "NS_From ProgressBillingVer.No."; Integer)
        {
            Caption = 'From Progress Billing Ver. No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021330; "NS_Retention Ledger Code"; Code[20])
        {
            Caption = 'Retention Ledger Code';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
        }
    }
    PROCEDURE GetRetentionBase(No: Code[20]): Decimal;
    VAR
        NS_JobsSetup: Record 315;
        NS_SalesCrMemoHeader: Record 114;
    BEGIN
        //ProjectPro - start
        NS_JobsSetup.GET;
        WITH NS_SalesCrMemoHeader DO BEGIN
            IF GET(No) THEN BEGIN
                IF (NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" =
                    NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"2 - Calc tax on sale then apply retention determined by progress billing") OR
                   (NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" =
                    NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing") THEN
                    EXIT("NS_Retention Base Before Tax")
                ELSE
                    EXIT("NS_Retention Base Amount");
            END ELSE
                EXIT(0);
        END;
        //ProjectPro - end
    END;

    var
    //PP_SalesSetup: Record "Sales & Receivables Setup";
    /*+---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     14021100 Job No.
      +     14021136 Retention Base Amount
      +     14021137 Retention Base Before Tax
      +     14021138 Retention Percent
      +     14021139 Retention Amount (LCY)
      +     14021140 Retention Amount
      +     14021145 Retention Date
      +     14021146 Retention Document
      +     14021325 Progress Billing Document
      +     14021327 From Progress Billing No.
      +     14021328 From Progress Billing Req. No.
      +     14021329 From Progress Billing Ver. No.
      +     14021330 Retention Ledger Code
      +
      +  - Added function(s):
      +     GetRetentionBase
      +
      +  - Added global variable(s):
      +     PP_SalesSetup
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +     - Navigate() - set filter to call NavigateForm page as appropriate
      +
      +-----------------------------------------------------------------------------------------------*/

}

