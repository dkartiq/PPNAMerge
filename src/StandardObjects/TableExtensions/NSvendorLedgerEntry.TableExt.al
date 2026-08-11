tableextension 14021106 NS_VendorLedgerEntry extends "Vendor Ledger Entry"
{
    // version NAVW111.00.00.24232,NAVNA11.00.00.24232,PPNA11.00
    //PRJ-290.AS.1.0 09SEPT20 Changed Captions
    //PE-209.HS.1.0 7Dec2023 | Obselete Bal. to Ledger No.
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
            DataClassification = CustomerContent;
            TableRelation = NS_Draw."NS_No." WHERE("NS_Job No." = FIELD("NS_Job No."),
                                              NS_Closed = CONST(false));
        }
        field(14021129; "NS_Bal. Ledger No."; Code[20])
        {
            //PE-209.HS.1.0 7Dec2023 Start
            // Caption = 'Bal. Ledger No.'; // commented
            Caption = 'Bal. Ledger No. (Obsolete)';
            ObsoleteState = Pending;
            ObsoleteReason = 'Will be removed in next build';
            ObsoleteTag = 'ProjectPro upcoming release 22.0.XXX.00';
            //PE-209.HS.1.0 7Dec2023  End
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            TableRelation = Vendor;
        }
        field(14021136; "NS_Retention Base Amount"; Decimal)
        {
            Caption = 'Retention Base Amount';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
        }
        field(14021138; "NS_Retention Percent"; Decimal)
        {
            Caption = 'Retention Percent';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
        }
        field(14021139; "NS_Retention Amount (LCY)"; Decimal)
        {
            Caption = 'Retention Amount ($)';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
        }
        field(14021140; "NS_Retention Amount"; Decimal)
        {
            Caption = 'Retention Amount';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021141; "NS_Retention Applies-to Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Retention Applies-to Amount';
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
        field(14021150; "NS_Ledger No. Link"; Code[20])
        {
            Caption = 'Ledger No. Link';
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            DataClassification = CustomerContent;
        }
        field(14021151; "NS_Entry No. Link"; Integer)
        {
            Caption = 'Entry No. Link';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021152; "NS_Lien Release Print Status"; Option)
        {
            Caption = 'Lien Release Print Status';
            Description = 'ProjectPro';
            OptionCaption = ' ,Requested,Printed';//PRJ-290.AS.1.0 09SEPT20
            OptionMembers = " ",Requested,Printed;//PRJ-290.AS.1.0 09SEPT20
            DataClassification = CustomerContent;
        }
        field(14021153; "NS_Lien Release Signed Date"; Date)
        {
            Caption = 'Lien Release Signed Date';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021154; "NS_Lien Release Type"; Option)
        {
            Caption = 'Lien Release Type';
            Description = 'ProjectPro';
            OptionCaption = ' ,Progress,Final';
            OptionMembers = " ",Progress,Final;
            DataClassification = CustomerContent;
        }
        //PE-200.AS START
        field(14021155; "NS_PaywhenPaid"; Boolean)
        {
            Caption = 'Pay when paid';
            DataClassification = CustomerContent;
        }
        //PE-200.AS END
        field(14021300; "NS_Subcontract No."; Code[20])
        {
            Caption = 'Subcontract No.';
            Description = 'ProjectPro';
            TableRelation = NS_Subcontract;
            DataClassification = CustomerContent;
        }
        field(14021301; "NS_Retention Ledger Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Retention Ledger Code';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            Description = 'ProjectPro';
        }
        field(14021416; "NS_FA Job No."; Code[20])
        {
            Caption = 'FA Job No.';
            Description = 'PRJ-490.AM.1.0';
            DataClassification = CustomerContent;
        }
        field(14021417; "NS_FA Job Task No."; Code[20])
        {
            Caption = ' FA Job Task No.';
            Description = 'PRJ-490.AM.1.0';
            DataClassification = CustomerContent;
        }
        field(14021418; "NS_FA Segment Code"; Code[20])
        {
            Caption = 'FA Segment Code';
            Description = 'PRJ-490.AM.1.0';
            DataClassification = CustomerContent;
        }
    }
    keys
    {

        key(Key1; "NS_Draw No.")
        {
        }
        key(Key2; "NS_Job No.")
        {
        }
    }
    PROCEDURE GetJobNo(VendLedgEntry: Record 25): Code[20];
    VAR
        NS_PurchInvLine: Record 123;
        NS_PurchCrMemoLine: Record 125;
        JobNo: Code[20];
    BEGIN
        //ProjectPro - start
        //This function returns the Job number associated with a Vendor Ledger Entry.
        //Since there really is no limit as to how many Jobs can appear for a given Vendor Ledger Entry, the first Job
        //  found in the detail lines will be assumed to be the Job for the entire entry.

        JobNo := '';

        CASE VendLedgEntry."Document Type" OF
            VendLedgEntry."Document Type"::Invoice:
                WITH NS_PurchInvLine DO BEGIN
                    RESET;
                    SETFILTER("Document No.", VendLedgEntry."Document No.");
                    IF FINDFIRST THEN
                        REPEAT
                            IF "Job No." > '' THEN
                                JobNo := "Job No.";
                        UNTIL (NEXT = 0) OR (JobNo > '');
                END;
            VendLedgEntry."Document Type"::"Credit Memo":
                WITH NS_PurchCrMemoLine DO BEGIN
                    RESET;
                    SETFILTER("Document No.", VendLedgEntry."Document No.");
                    IF FINDFIRST THEN
                        REPEAT
                            IF "Job No." > '' THEN
                                JobNo := "Job No.";
                        UNTIL (NEXT = 0) OR (JobNo > '');
                END;
        END;

        EXIT(JobNo);
        //ProjectPro - end
    END;

    /*+---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added fields:
      +     14021100 Job No.Code
      +     14021104 Draw No.
      +     14021129 Bal. Ledger No.
      +     14021136 Retention Base Amount
      +     14021138 Retention Percent
      +     14021139 Retention Amount (LCY)
      +     14021140 Retention Amount
      +     14021141 Retention Applies-to Amount
      +     14021145 Retention Date
      +     14021146 Retention Document
      +     14021150 Ledger No. Link
      +     14021151 Entry No. Link
      +     14021152 Lien Release Print Status
      +     14021153 Lien Release Signed Date
      +     14021154 Lien Release Type
      +     14021300 Subcontract No.
      +     14021301 Retention Ledger Code
      +
      +  - Added function(s):
      +     GetJobNo()
      +
      +  - Added global variable(s):
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +    - Added keys:
      +        Draw No.
      +        Job No.
      +
      +    - Enabled key:
      +        Document Type,Vendor No.,Global Dimension 1 Code,Global Dimension 2 Code,Posting Date,Currency Code
      +
      +    - Procedures Modified:
      +       DrillDownOnEntries
      +       DrillDownOnOverdueEntries
      +
      +-----------------------------------------------------------------------------------------------*/

}

