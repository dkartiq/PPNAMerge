tableextension 14021128 NS_PurchCrMemoHeader extends "Purch. Cr. Memo Hdr."
{
    // version NAVW111.00.00.20783,NAVNA11.00.00.20783,PPNA11.00

    fields
    {
        field(14021100; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            Description = 'ProjectPro';
            TableRelation = Job;
            DataClassification = CustomerContent;
        }
        field(14021104; "NS_Draw No."; Code[25])
        {
            Caption = 'Draw No.';
            Description = 'ProjectPro';
            TableRelation = NS_Draw."NS_No." WHERE("NS_Job No." = FIELD("NS_Job No."),
                                              NS_Closed = CONST(false));
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

            trigger OnValidate();
            begin
                //ProjectPro - start
                if "NS_Retention Percent" > 0 then begin
                    CALCFIELDS("Amount Including VAT");
                    "NS_Retention Amount" := ROUND("Amount Including VAT" * "NS_Retention Percent" / 100, 0.01);
                end;
                //ProjectPro - end
            end;
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

            trigger OnValidate();
            begin
                //ProjectPro - start
                if "NS_Retention Amount" <> 0 then
                    TESTFIELD("NS_Retention Amount (LCY)");
                //ProjectPro - end
            end;
        }
        field(14021146; "NS_Retention Document"; Boolean)
        {
            Caption = 'Retention Document';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021300; "NS_Subcontract No."; Code[20])
        {
            Caption = 'Subcontract No.';
            Description = 'ProjectPro';
            TableRelation = NS_Subcontract;
            DataClassification = CustomerContent;
        }
        field(14021301; "NS_Retention Ledger Code"; Code[20])
        {
            Caption = 'Retention Ledger Code';
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            DataClassification = CustomerContent;
        }
    }
    PROCEDURE GetRetentionBase(No: Code[20]): Decimal;
    VAR
        NS_JobsSetup: Record 315;
        NS_PurchCrMemoHdr: Record 124;
    BEGIN
        //ProjectPro - start
        NS_JobsSetup.GET;
        WITH NS_PurchCrMemoHdr DO BEGIN
            IF GET(No) THEN BEGIN
                IF NS_JobsSetup."NS_Calc Payable Ret Before Tax" THEN
                    EXIT("NS_Retention Base Before Tax")
                ELSE
                    EXIT("NS_Retention Base Amount");
            END ELSE
                EXIT(0);
        END;
        //ProjectPro - end
    END;


    var
        NS_PurchSetup: Record "Purchases & Payables Setup";
    /*+---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     14021100 Job No.
      +     14021104 Draw No.
      +     14021136 Retention Base Amount
      +     14021137 Retention Base Before Tax
      +     14021138 Retention Percent
      +     14021139 Retention Amount (LCY)
      +     14021140 Retention Amount
      +     14021145 Retention Date
      +     14021146 Retention Document
      +     14021300 Subcontract No.
      +     14021301 Retention Ledger Code
      +
      +  - Added function(s):
      +     GetRetentionBase
      +
      +  - Added global variable(s):
      +     PP_PurchSetup
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +     - Navigate() - set filter to call NavigateForm page as appropriate
      +     - Modify fields to allow for a Ledger type record
      +         Type
      +-----------------------------------------------------------------------------------------------*/
}

