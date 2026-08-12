tableextension 14021104 NS_CustLedEntry extends "Cust. Ledger Entry"
{
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version NAVW111.00.00.20783,NAVNA11.00.00.20783,PPNA11.00
    //PE-209.HS.1.0 7Dec2023 | Obselete Bal. to Ledger No.

    fields
    {
        field(14021100; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021129; "NS_Bal. Ledger No."; Code[20])
        {
            //PE-209.HS.1.0 7Dec2023  Start
            // Caption = 'Bal. Ledger No.';// commented
            Caption = 'Bal. Ledger No. (Obsolete)';
            ObsoleteState = Pending;
            ObsoleteReason = 'Will be removed in next build';
            ObsoleteTag = 'ProjectPro upcoming release 22.0.XXX.00';
            //PE-209.HS.1.0 7Dec2023  End
            Description = 'ProjectPro';
            TableRelation = Customer;
            DataClassification = CustomerContent;
        }
        field(14021136; "NS_Retention Base Amount"; Decimal)
        {
            Caption = 'Retention Base Amount';
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
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
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
        field(14021152; "NS_Retention Ledger Code"; code[20]) //MHNA-8.NC.1.0 29Jun2023 |Increase length 10 to 20
        {
            DataClassification = CustomerContent;
            Caption = 'Retention Ledger Code';
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
        }
        //PRJCTPR-11.GK.1.0 20Apr2023 start
        field(14021153; "NS_Lien Waiver Type"; Option)
        {
            Caption = 'Lien Waiver Type';
            Editable = true;
            DataClassification = CustomerContent;
            OptionCaption = ' ,Conditional-Progress,Unconditional-Progress,Conditional-Final,Unconditional-Final';
            OptionMembers = " ","Conditional-Progress","Unconditional-Progress","Conditional-Final","Unconditional-Final";
        }
        field(14021154; "NS_Lien Waiver Signed Date"; Date)
        {
            Editable = true;
            DataClassification = CustomerContent;
            Caption = 'Lien Waiver Signed Date';
        }
        field(14021155; "NS_Lien Waiver Print Status"; Option)
        {
            Caption = 'Lien Waiver Print Status';
            Editable = true;
            DataClassification = CustomerContent;
            OptionCaption = ' ,Reprint,Printed';
            OptionMembers = " ",Reprint,Printed;
        }
        field(14021156; "NS_Lien Waiver Amount"; Decimal)
        {
            Caption = 'Lien Waiver Amount';
            DataClassification = CustomerContent;
            Editable = true;
        }
        field(14021157; "NS_Lien Waiver Payment"; Decimal)
        {
            Caption = 'Lien Waiver Payment';
            DataClassification = CustomerContent;
            Editable = true;
        }
        field(14021158; "NS_Lien Waiver Work Type"; Text[50])
        {
            Caption = 'Lien Waiver Work Type';
            DataClassification = CustomerContent;
            Editable = true;
        }
        //PRJCTPR-11.GK.1.0 20Apr2023 end

        //PE-200.AS.1.0 24SEPT2023 START
        field(14021159; "NS_Draw No."; Code[25])
        {
            DataClassification = CustomerContent;
            Caption = 'Draw No.';
        }
        //PE-200.AS.1.0 24SEPT2023 END

        //PE-200.AS.9.0 START
        field(14021160; "NS_PaywhenPaid"; Boolean)
        {
            Caption = 'Pay when paid';
            DataClassification = CustomerContent;
        }
        //PE-200.AS.9.0 END
        //PE-302.JS.1.0 29MAY24-Start
        field(14021311; "NS_AppliesToDocument Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'AppliesToDocument Type';
            DataClassification = CustomerContent;
            Description = '"Applies To Document Type" is required to resolve posting issue with other ISV running with ProjectPro on same environment';
            Editable = false;
        }
        field(14021312; "NS_AppliesToDocument No."; code[20])
        {
            Caption = 'AppliesToDocument No.';
            DataClassification = CustomerContent;
            Description = '"Applies To Document No." is required to resolve posting issue with other ISV running with ProjectPro on same environment';
            Editable = false;
        }
        //PE-302.JS.1.0 29MAY24-end 

    }

    keys
    {
        //     //Unsupported feature: Deletion on ""Document Type","Customer No.","Global Dimension 1 Code","Global Dimension 2 Code","Posting Date","Currency Code"(Key)". Please convert manually.
        //     key(Key1; "Document Type", "Customer No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date", "Currency Code", "Retention Ledger Code")

    }


    PROCEDURE NS_GetJobNo(CustLedgEntry: Record 21): Code[20];
    VAR
        PP_SalesInvoiceLine: Record 113;
        PP_SalesCrMemoLine: Record 115;
        JobNo: Code[20];
    BEGIN
        //ProjectPro - start
        //This function returns the job number associated with a Customer Ledger Entry.
        //Since there really is no limit as to how many jobs can appear for a given Customer Ledger Entry, the first job
        //  found in the detail lines will be assumed to be the job for the entire entry.

        JobNo := '';

        CASE CustLedgEntry."Document Type" OF
            CustLedgEntry."Document Type"::Invoice:
                WITH PP_SalesInvoiceLine DO BEGIN
                    RESET;
                    SETFILTER("Document No.", CustLedgEntry."Document No.");
                    IF FINDFIRST THEN
                        REPEAT
                            IF "Job No." > '' THEN
                                JobNo := "Job No.";
                        UNTIL (NEXT = 0) OR (JobNo > '');
                END;
            CustLedgEntry."Document Type"::"Credit Memo":
                WITH PP_SalesCrMemoLine DO BEGIN
                    RESET;
                    SETFILTER("Document No.", CustLedgEntry."Document No.");
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
    /*+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added fields:
      +     14021100 Job No.
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
      +     14021152 Retention Ledger Code
      +
      +  - Added function(s):
      +     GetJobNo()
      +
      +  - Added global variable(s):
      +
      +  - Modifcation(s):
      +     - DrollDownOnEntries:
      +         - Set Job No. filter.
      +     - Set key as enabled:
      +         Document Type,Customer No.,Global Dimension 1 Code,Global Dimension 2 Code,Posting Date,Currency Code
      +
      +     - Modified key:
      +         "Document Type,Customer No.,Global Dimension 1 Code,Global Dimension 2 Code,Posting Date,Currency Code,Retention Ledger Code" (added "Retention Ledger Code")
      +
      +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

}

