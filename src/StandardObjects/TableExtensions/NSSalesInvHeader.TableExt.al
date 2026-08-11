tableextension 14021120 NS_SalesInvHeader extends "Sales Invoice Header"
{
    // version NAVW111.00.00.20783,NAVNA11.00.00.20783,PPNA11.00
    //CTSI-150.AS.1.0 28Sept2020 Added new field
    //PRJ-1304.RM.1 22April2022 | Added a Field
    //PRJ-1418.RM.1.0 27May2022 | Made field editable
    //PRJ-1519.NK.1.0 16Jul2022 | Added Code
    //PRJ-1624.NK.1.0 22Sep2022 | Added Field
    //PRJCTPR-252.HS.1.0 21Dec2023 | Added code
    fields
    {

        field(14021100; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            TableRelation = Job;

            trigger OnValidate();
            begin
                //ProjectPro - start
                "Currency Code" := '';
                if NS_Job.GET("NS_Job No.") then begin
                    if NS_Job."Currency Code" > '' then
                        VALIDATE("Currency Code", NS_Job."Currency Code");
                    if NS_Job."Invoice Currency Code" > '' then
                        VALIDATE("Currency Code", NS_Job."Invoice Currency Code");
                end;
                //ProjectPro - end
            end;
        }
        field(14021135; "NS_Retention True Base Amount"; Decimal)
        {
            Caption = 'Retention True Base Amount';
            Description = 'ProjectPro';
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
            DecimalPlaces = 2 : 15; //PRJ-1519.NK.1.0 16Jul2022
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
        field(14021141; "NS_Retention Invoce Total"; Decimal)
        {
            Caption = 'Retention Invoce Total';
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
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021327; "NS_From Progress Billing No."; Code[20])
        {
            Caption = 'From Progress Billing No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
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
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            DataClassification = CustomerContent;
        }
        //CTSI-150.AS.1.0 28Sept2020 - start
        field(14021350; "NS_Use % Billing format"; Boolean)
        {
            Caption = 'Use % Billing Format';
            Description = 'Boolean Use % Billing Format';
            DataClassification = CustomerContent;
        }
        //CTSI-150.AS.1.0 28Sept2020 - end
        //PRJ-1304.RM.1.0 Start
        field(14021408; "NS_Draw No."; Code[25])
        {
            Caption = 'Draw No.';
            Description = 'Draw No.';
            // Editable = false; //PRJ-1418.RM.1.0  commented
            Editable = true; //PRJ-1418.RM.1.0
                             // TableRelation = NS_Draw."NS_No."; //PRJ-1418.RM.1.0 //PRJCTPR-252.HS.1.0 21Dec2023 Commented
            TableRelation = NS_Draw."NS_No." WHERE("NS_Job No." = FIELD("NS_Job No."),  //PRJCTPR-252.HS.1.0 21Dec2023
                                              NS_Closed = CONST(false));
            DataClassification = CustomerContent;
        }
        //PRJ-1304.RM.1.0 End
        //PRJ-1624.NK.1.0 22Sep2022 Start
        field(14021486; "NS_Multiple Retention on Lines"; Boolean)
        {
            Caption = 'Multiple Retention on Lines';
            DataClassification = CustomerContent;
            Description = 'Multiple Retention on Lines';
        }
        //PRJ-1624.NK.1.0 22Sep2022 End

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

    PROCEDURE GetRetentionBase(No: Code[20]): Decimal;
    VAR
        NS_JobsSetup: Record 315;
        NS_SalesInvoiceHeader: Record 112;
    BEGIN
        //ProjectPro - start
        NS_JobsSetup.GET;
        WITH NS_SalesInvoiceHeader DO BEGIN
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
        NS_SalesSetup: Record "Sales & Receivables Setup";
        NS_Job: Record Job;
        CheckLatestQst: Label 'Do you want to check the latest status of the electronic document?', Comment = '%1 is Document Exchange Status';
    /* +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     14021100 Job No.
      +     14021135 Retention True Base Amount
      +     14021136 Retention Base Amount
      +     14021137 Retention Base Before Tax
      +     14021138 Retention Percent
      +     14021139 Retention Amount (LCY)
      +     14021140 Retention Amount
      +     14021141 Retention Invoce Total
      +     14021145 Retention Date
      +     14021146 Retention Document
      +     14021325 Progress Billing Document
      +     14021327 From Progress Billing No.
      +     14021328 From Progress Billing Req. No.
      +     14021329 From Progress Billing Ver. No.
      +     14021330 Retention Ledger Code
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +      PP_SalesSetup
      +      PP_Job
      +
      +  - Added global text constant(s):
      +     CheckLatestQst
      +
      +  - Modification(s):
      +-----------------------------------------------------------------------------------------------*/
}

