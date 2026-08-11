tableextension 14021113 Ns_GenJnlLine extends "Gen. Journal Line"
{
    // version NAVW111.00.00.24232,NAVNA11.00.00.24232,PPNA11.00
    //TM-10.AM.1.0 | Added field & Code.
    //PRJ-490.AM.1.0 Added Fields
    //PE-209.HS.1.0 7Dec2023 | Obselete Bal. to Ledger No.

    fields
    {
        modify("Job No.")
        {
            trigger OnBeforeValidate()
            var
                NSDimCreate: List of [Dictionary of [Integer, Code[20]]];  //PRJCTPR-155.JS.1.0 11Sep2023
                NSDataPosition: Dictionary of [Integer, Code[20]];      //PRJCTPR-155.JS.1.0 11Sep2023
                NSDimMgt: codeunit DimensionManagement; //PRJCTPR-155.JS.1.0 11Sep2023
            begin
                IF "Job No." = xRec."Job No." THEN
                    EXIT;
                "NS_Segment Code" := '';//TM-10.AM.1.0

                SourceCodeSetup.GET;
                IF "Source Code" <> SourceCodeSetup."Job G/L WIP" THEN
                    VALIDATE("Job Task No.", '');

                //PRJCTPR-155.JS.1.0 11Sep2023 - Start
                IF "Job No." = '' THEN BEGIN
                    // CreateDim(
                    //   DATABASE::Job, "Job No.",
                    //   DimMgt.TypeToTableID1("Account Type".AsInteger()), "Account No.",
                    //   DimMgt.TypeToTableID1("Bal. Account Type".AsInteger()), "Bal. Account No.",
                    //   DATABASE::"Salesperson/Purchaser", "Salespers./Purch. Code",
                    //   DATABASE::Campaign, "Campaign No.");

                    Clear(NSDimCreate);
                    NSDimMgt.AddDimSource(NSDimCreate, DATABASE::Job, "Job No.");
                    NSDimMgt.AddDimSource(NSDimCreate, DimMgt.TypeToTableID1("Account Type".AsInteger()), "Account No.");
                    NSDimMgt.AddDimSource(NSDimCreate, DimMgt.TypeToTableID1("Bal. Account Type".AsInteger()), "Bal. Account No.");
                    NSDimMgt.AddDimSource(NSDimCreate, DATABASE::"Salesperson/Purchaser", "Salespers./Purch. Code");
                    NSDimMgt.AddDimSource(NSDimCreate, DATABASE::Campaign, "Campaign No.");
                    CreateDim(NSDimCreate);

                    EXIT;
                END;
                //PRJCTPR-155.JS.1.0 11Sep2023 - end

                //ProjectPro - start
                //TESTFIELD("Account Type","Account Type"::"G/L Account");
                IF NOT ("Account Type" IN ["Account Type"::"G/L Account", "Account Type"::Customer, "Account Type"::Vendor]) THEN
                    ERROR(Text14021100);
                //ProjectPro - end

                IF "Bal. Account No." <> '' THEN
                    IF NOT ("Bal. Account Type" IN ["Bal. Account Type"::"G/L Account", "Bal. Account Type"::"Bank Account"]) THEN
                        ERROR(Text016, FIELDCAPTION("Bal. Account Type"));

                Job.GET("Job No.");
                Job.TestBlocked;
                "Job Currency Code" := Job."Currency Code";
                "Job Line Type" := Job."NS_Line Type";  //PRJCTPR-59.NK.1.0 13feb2022


                //PRJCTPR-155.JS.1.0 11Sep2023 - start
                // CreateDim(
                //   DATABASE::Job, "Job No.",
                //   DimMgt.TypeToTableID1("Account Type".AsInteger()), "Account No.",
                //   DimMgt.TypeToTableID1("Bal. Account Type".AsInteger()), "Bal. Account No.",
                //   DATABASE::"Salesperson/Purchaser", "Salespers./Purch. Code",
                //   DATABASE::Campaign, "Campaign No.");

                Clear(NSDimCreate);
                NSDimMgt.AddDimSource(NSDimCreate, DATABASE::Job, "Job No.");
                NSDimMgt.AddDimSource(NSDimCreate, DimMgt.TypeToTableID1("Account Type".AsInteger()), "Account No.");
                NSDimMgt.AddDimSource(NSDimCreate, DimMgt.TypeToTableID1("Bal. Account Type".AsInteger()), "Bal. Account No.");
                NSDimMgt.AddDimSource(NSDimCreate, DATABASE::"Salesperson/Purchaser", "Salespers./Purch. Code");
                NSDimMgt.AddDimSource(NSDimCreate, DATABASE::Campaign, "Campaign No.");
                CreateDim(NSDimCreate);
                //PRJCTPR-155.JS.1.0 11Sep2023 - ends

                xRec."Job No." := "Job No."; //SPLN: to prevent executing OnValidate code
            end;
        }

        field(14021101; "NS_Job Cost Category"; Code[10])
        {
            Caption = 'Job Cost Category';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Cost Category";
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                NS_JobCostCategory: Record "NS_Job Cost Category";
                NS_TempJobNo: Code[20];
            begin
                //ProjectPro - start
                NS_TempJobNo := "Job No.";
                if NS_JobCostCategory.GET("NS_Job Cost Category") then
                    if NS_JobCostCategory."NS_G/L Account No." <> '' then begin
                        VALIDATE("Account Type", "Account Type"::"G/L Account");
                        VALIDATE("Account No.", NS_JobCostCategory."NS_G/L Account No.");
                        if NS_TempJobNo <> '' then
                            VALIDATE("Job No.", NS_TempJobNo);
                        if NS_JobCostCategory."NS_Activity Code" <> '' then
                            if "Job No." <> '' then
                                VALIDATE("Job Task No.", NS_JobCostCategory."NS_Activity Code");
                    end;
                //ProjectPro - end
            end;
        }
        field(14021102; "NS_Job Revenue Category"; Code[10])
        {
            Caption = 'Job Revenue Category';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Revenue Category";
            DataClassification = CustomerContent;
        }
        field(14021103; "NS_Cost-Revenue Type"; Option)
        {
            Caption = 'Cost-Revenue Type';
            Description = 'ProjectPro';
            OptionCaption = 'Cost,Revenue';
            OptionMembers = Cost,Revenue;
            DataClassification = CustomerContent;
        }
        field(14021104; "NS_Draw No."; Code[25])
        {
            Caption = 'Draw No.';
            Description = 'ProjectPro';
            TableRelation = NS_Draw;
            DataClassification = CustomerContent;
        }
        field(14021105; "NS_Burden Amount"; Decimal)
        {
            Caption = 'Burden Amount';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021106; "NS_Prepayment for Job No."; Code[20])
        {
            Caption = 'Prepayment for Job No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
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
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            DataClassification = CustomerContent;
        }
        field(14021136; "NS_Retention Base Amount"; Decimal)
        {
            Caption = 'Retention Base Amount';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                NS_TestRetentionLedgerCode(Rec);
            end;
        }
        field(14021138; "NS_Retention Percent"; Decimal)
        {
            Caption = 'Retention Percent';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                NS_TestRetentionLedgerCode(Rec);
                if "NS_Retention Percent" > 0 then
                    "NS_Retention Amount" := ROUND(Amount * "NS_Retention Percent" / 100, 0.01);
            end;
        }
        field(14021139; "NS_Retention Amount (LCY)"; Decimal)
        {
            Caption = 'Retention Amount ($)';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';

            trigger OnValidate();
            begin
                NS_TestRetentionLedgerCode(Rec);
            end;
        }
        field(14021140; "NS_Retention Amount"; Decimal)
        {
            Caption = 'Retention Amount';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                NS_TestRetentionLedgerCode(Rec);
            end;
        }
        field(14021145; "NS_Retention Date"; Date)
        {
            Caption = 'Retention Date';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                NS_TestRetentionLedgerCode(Rec);
                if "NS_Retention Amount" <> 0 then
                    Rec.TESTFIELD("NS_Retention Amount (LCY)");
            end;
        }
        field(14021146; "NS_Retention Document"; Boolean)
        {
            Caption = 'Retention Document';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                NS_TestRetentionLedgerCode(Rec);
            end;
        }
        field(14021150; "NS_Print Lien Release"; Option)
        {
            Caption = 'Print Lien Release';
            Description = 'ProjectPro';
            OptionCaption = ' ,Progress,Final';
            OptionMembers = " ",Progress,Final;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if ("NS_Print Lien Release" > 0) and ("Job No." = '') then
                    ERROR(Text14021101);
            end;
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

            trigger OnValidate();
            begin
                NS_TestRetentionLedgerCode(Rec);
            end;
        }
        field(14021302; "NS_Segment Code"; Code[20])
        {
            Caption = 'Segment Code';
            Description = 'TM-10.AM.1.0';
            DataClassification = CustomerContent;
            TableRelation = "NS_Job Takeoff Segments"."NS_Segment Code" WHERE("NS_Job No." = FIELD("Job No."));
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
        //PE-136.JS.1.0 03Aug2023 - Start
        field(14021419; "NS_RevRec GenJnl Document No."; Code[20])
        {
            Caption = 'Rev. Rec. Gen. Jnl. Document No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            editable = false;
        }
        field(14021420; "NS_RevRec G/L Reverse EntryNo."; integer)
        {
            Caption = 'Rev. Rec. G/L Reverse Entry No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            editable = false;
        }
        //PE-136.JS.1.0 03Aug2023 - end
        //PRJCTPR-330.PS.1.0 07April2024 Start
        field(14021421; "NS_Rev. Rec. Summary Dtls"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Rev. Rec. Summary Details';
        }
        //PRJCTPR-330.PS.1.0 07April2024 End
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

    //PE-136.JS.1.0 10JUN2024-Start
    trigger OnDelete()
    begin
        if (rec."NS_RevRec G/L Reverse EntryNo." > 0) and (rec."NS_RevRec GenJnl Document No." <> '') then begin
            if confirm(NSTextLabel1RecRecDel, true) then begin
                if confirm(NSTextLabel2RecRecDel, true) then
                    exit
                else
                    Error('');
            end else
                Error('');
        end;
    end;
    //PE-136.JS.1.0 10JUN2024-end

    trigger OnBeforeInsert()
    begin
        NS_TestRetentionLedgerCode(Rec);
    end;

    trigger OnBeforeModify()
    begin
        NS_TestRetentionLedgerCode(Rec);
    end;


    PROCEDURE NS_TestRetentionLedgerCode(TempGenJnlLine: Record 81);
    BEGIN
        //ProjectPro - start
        WITH TempGenJnlLine DO BEGIN
            CASE "Account Type" OF
                "Account Type"::Customer:
                    BEGIN
                        NS_SalesSetup.GET;
                        IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
                            TESTFIELD("NS_Retention Ledger Code");
                    END;
                "Account Type"::Vendor:
                    BEGIN
                        NS_PurchSetup.GET;
                        IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN
                            TESTFIELD("NS_Retention Ledger Code");
                    END;
            END;
        END;
        //ProjectPro - end
    END;

    var
        NS_LedgerNoHold: Code[20];
        NS_SalesSetup: Record "Sales & Receivables Setup";
        NS_PurchSetup: Record "Purchases & Payables Setup";
        NS_JobsSetup: Record "Jobs Setup";
        NS_DimensionValue: Record "Dimension Value";
        Text14021100: Label 'Account Type must be G/L Account, Customer, or Vendor';
        Text14021101: Label 'To print a lien release, the Job No. cannot be blank.';
        Text016: Label '%1 must be G/L Account or Bank Account.';
        Job: Record Job;
        SourceCodeSetup: Record "Source Code Setup";
        DimMgt: Codeunit DimensionManagement;
        NSTextLabel1RecRecDel: Label 'Deleting the Rev. Rec. Reversal entries will create the G/L inconsistencies in entries. Do you want to continue?';  //PE-136.JS.1.0 10JUN2024
        NSTextLabel2RecRecDel: Label 'Are you sure you want to delete the Rev. Rec. Reversal Entries?';  //PE-136.JS.1.0 10JUN2024

    /*+---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     14021101 Job Cost Category
      +     14021102 Job Revenue Category
      +     14021103 Cost-Revenue Type
      +     14021104 Draw No.
      +     14021105 Burden Amount
      +     14021106 Prepayment for Job No.
      +     14021129 Bal. Ledger No.
      +     14021136 Retention Base Amount
      +     14021138 Retention Percent
      +     14021139 Retention Amount (LCY)
      +     14021140 Retention Amount
      +     14021145 Retention Date
      +     14021146 Retention Document
      +     14021150 Print Lien Release
      +     14021300 Subcontract No.
      +     14021301 "Retention Ledger Code"
      +
      +  - Added function(s):
      +     PP_TestRetentionLedgerCode
      +
      +  - Added global variable(s):
      +     PP_SalesSetup
      +     PP_PurchSetup
      +     PP_JobsSetup
      +     PP_DimensionValue
      +
      +  - Added global text constant(s):
      +     Text14021100
      +     Text14021101
      +
      +  - Modification(s):
      +     - OnValidate modifications
      +         Account No.
      +         Applies-to Doc No.
      +         Job No.
      +     - Procedure modifications
      +         CreateDim
      +         FindFirstCustLedgEntryWithAppliesToID
      +         FindFirstVendLedgEntryWithAppliesToID
      +         CopyFromPaymentCustLedgEntry
      +         CopyFromPaymentVendLedgEntry
      +         GetCustomerAccount
      +         GetVendorAccount
      +     - Account Type OnValidate:
      +         - Set Retention Ledger code
      +-----------------------------------------------------------------------------------------------*/
}

