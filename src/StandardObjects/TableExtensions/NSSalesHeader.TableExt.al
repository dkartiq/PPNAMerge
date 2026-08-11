tableextension 14021108 NS_SalesHeader extends "Sales Header"
{
    // version NAVW111.00.00.25466,NAVNA11.00.00.25466,PPNA11.00
    //PRJ-131.SK.1.0 Added code for populating the "Gen. Bus. Posting Group" from diffrent setups on condition basis.
    //CTSI-150.AS.1.0 28Sept2020 Added new field
    //PRJ-415.MS.1.0 flow of salesperson from Job to SI
    //PRJ-911.GK.1.0 10Sep2021 |Validate Default job retention on job No.
    fields
    {

        field(14021100; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            Description = 'ProjectPro';
            TableRelation = Job;
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                NS_SalesLine: Record "Sales Line";
                NS_JobLinks: Record "NS_Job Links";
                NS_JobPlanningLine: Record "Job Planning Line";
                NS_Job: Record Job;
                IncompatibleLines: Boolean;
                JobSetup: Record "Jobs Setup";
                CustomerRec: Record Customer;
            begin
                //ProjectPro - start
                if "NS_Job No." = '' then
                    exit;

                IF JobSetup.Get() then;
                with NS_SalesLine do begin
                    IncompatibleLines := false;
                    RESET;
                    SETRANGE("Document Type", Rec."Document Type");
                    SETRANGE("Document No.", Rec."No.");
                    if FINDFIRST then
                        repeat
                            if "Job No." <> '' then
                                if not NS_JobLinks.GET("Job No.", Rec."NS_Job No.") then
                                    IncompatibleLines := true;
                        until (NEXT = 0) or IncompatibleLines;

                    if IncompatibleLines then
                        if not CONFIRM(Text14021100lbl, true, Rec."NS_Job No.") then
                            ERROR(Text14021101Lbl)
                        else begin
                            RESET;
                            SETRANGE("Document Type", Rec."Document Type");
                            SETRANGE("Document No.", Rec."No.");
                            if FIND('-') then
                                repeat
                                    if "Job No." > '' then begin
                                        "Job No." := Rec."NS_Job No.";

                                        //Check Job Task No.
                                        if "Job Task No." > '' then begin
                                            NS_JobPlanningLine.RESET;
                                            NS_JobPlanningLine.SETRANGE("Job No.", "Job No.");
                                            NS_JobPlanningLine.SETRANGE("Job Task No.", "Job Task No.");
                                            if NS_JobPlanningLine.ISEMPTY then
                                                "Job Task No." := '';
                                        end;

                                        MODIFY;
                                    end;
                                until NEXT = 0;
                        end;
                end;
                "Currency Code" := '';
                if NS_Job.GET(Rec."NS_Job No.") then begin
                     Validate("NS_Retention Percent", NS_Job."NS_Default Job Retention"); //PRJ-911.GK.1.0 10Sep2021
                    if NS_Job."Currency Code" > '' then
                        VALIDATE("Currency Code", NS_Job."Currency Code");
                    if NS_Job."Invoice Currency Code" > '' then
                        VALIDATE("Currency Code", NS_Job."Invoice Currency Code");

                    //PRJ-131.SK.1.0 Start
                    // IF NS_Job."NS_Gen. Bus. Posting Group" <> '' then//PRJ-831.AS.1.0 12OCT2021 Comment old
                    //    Validate("Gen. Bus. Posting Group", NS_Job."NS_Gen. Bus. Posting Group")//PRJ-831.AS.1.0 12OCT2021 Comment old

                    IF NS_Job."NS_Gen. Bus. Posting Group New" <> '' then//PRJ-831.AS.1.0 12OCT2021 Add New
                        Validate("Gen. Bus. Posting Group", NS_Job."NS_Gen. Bus. Posting Group New")//PRJ-831.AS.1.0 12OCT2021 Add New
                    else
                        IF JobSetup."NS_Gen. Bus. Posting Group" <> '' then
                            Validate("Gen. Bus. Posting Group", JobSetup."NS_Gen. Bus. Posting Group")
                        else
                            IF CustomerRec.Get(Rec."Sell-to Customer No.") then
                                IF CustomerRec."Gen. Bus. Posting Group" <> '' then
                                    Validate("Gen. Bus. Posting Group", CustomerRec."Gen. Bus. Posting Group");
                    //PRJ-131.SK.1.0 End
                    validate("External Document No.", NS_Job."NS_Customer PO Number");//CTSI-179.MS.1.0
                    "Salesperson Code" := NS_Job."NS_Salesperson Code";//PRJ-415
                   

                end;
                //ProjectPro - end
            end;
        }
        field(14021130; "NS_Retention InvoiceDiscAmount"; Decimal)
        {
            CalcFormula = Sum ("Sales Line"."Inv. Discount Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                         "Document No." = FIELD("No."),
                                                                         "NS_Retention Applies" = CONST(true)));
            Caption = 'Retention Invoice Disc. Amount';
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        field(14021136; "NS_Retention Base Amount"; Decimal)
        {
            CalcFormula = Sum ("Sales Line"."Amount Including VAT" WHERE("Document Type" = FIELD("Document Type"),
                                                                         "Document No." = FIELD("No."),
                                                                         "NS_Retention Applies" = CONST(true)));
            Caption = 'Retention Base Amount';
            Description = 'ProjectPro';
            FieldClass = FlowField;

            trigger OnValidate();
            var
                JobsSetup: Record "Jobs Setup";
            begin
            end;
        }
        field(14021137; "NS_Retention Base Before Tax"; Decimal)
        {
            CalcFormula = Sum ("Sales Line"."Line Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                "Document No." = FIELD("No."),
                                                                "NS_Retention Applies" = CONST(true)));
            Caption = 'Retention Base Before Tax';
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        field(14021138; "NS_Retention Percent"; Decimal)
        {
            Caption = 'Retention Percent';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                GLSetup: Record 98;
                CurrExchRate: Record 330;
            begin
                //ProjectPro - start
                NS_JobsSetup.GET;
                GLSetup.GET;
                if "NS_Retention Percent" = 0 then begin
                    if (NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" =
                        NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"2 - Calc tax on sale then apply retention determined by progress billing") or
                       (NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" =
                        NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing") then begin
                        "NS_Retention Amount (LCY)" := 0;
                        "NS_Retention Amount" := 0;
                    end;
                    if ("NS_Retention Amount (LCY)" = 0) and ("NS_Retention Amount" = 0) then
                        "NS_Retention Date" := 0D;
                end else begin
                    //TESTFIELD("Retention Document", FALSE);
                    if "Currency Code" = '' then begin
                        "NS_Retention Amount (LCY)" := ROUND(NS_RetentionBase("Document Type", "No.") * ("NS_Retention Percent" / 100),
                                                          GLSetup."Amount Rounding Precision");
                        "NS_Retention Amount" := "NS_Retention Amount (LCY)";
                    end else begin
                        NS_Currency.GET("Currency Code");
                        "NS_Retention Amount" := ROUND(NS_RetentionBase("Document Type", "No.") * ("NS_Retention Percent" / 100),
                                                          GLSetup."Amount Rounding Precision");
                        "NS_Retention Amount (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", "NS_Retention Amount",
                                                          CurrExchRate.ExchangeRate("Posting Date", "Currency Code")),
                                                          NS_Currency."Amount Rounding Precision");
                    end;
                    if "NS_Retention Date" = 0D then
                        if NS_JobsSetup."NS_Sales Retention Period" <> '' then
                            "NS_Retention Date" := CALCDATE('+' + NS_JobsSetup."NS_Sales Retention Period", "Posting Date");
                end;
                //ProjectPro - end
            end;
        }
        field(14021139; "NS_Retention Amount (LCY)"; Decimal)
        {
            Caption = 'Retention Amount ($)';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                CurrExchRate: Record 330;
            begin
                //ProjectPro - start
                NS_JobsSetup.GET;
                if "NS_Retention Amount (LCY)" <> 0 then begin
                    TESTFIELD("NS_Retention Document", false);
                    "NS_Retention Percent" := 0;
                    if "Currency Code" = '' then begin
                        "NS_Retention Amount" := "NS_Retention Amount (LCY)";
                    end else begin
                        NS_Currency.GET("Currency Code");
                        "NS_Retention Amount" := ROUND(CurrExchRate.ExchangeAmtLCYToFCY("Posting Date", "Currency Code", "NS_Retention Amount (LCY)",
                                                    CurrExchRate.ExchangeRate("Posting Date", "Currency Code")),
                                                    NS_Currency."Amount Rounding Precision");
                    end;
                    if "NS_Retention Date" = 0D then
                        if NS_JobsSetup."NS_Sales Retention Period" <> '' then
                            "NS_Retention Date" := CALCDATE('+' + NS_JobsSetup."NS_Sales Retention Period", "Posting Date");
                end else
                    "NS_Retention Amount" := 0;
                //ProjectPro - end
            end;
        }
        field(14021140; "NS_Retention Amount"; Decimal)
        {
            Caption = 'Retention Amount';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                CurrExchRate: Record 330;
            begin
                //ProjectPro - start
                NS_JobsSetup.GET;
                if "NS_Retention Amount" <> 0 then begin
                    TESTFIELD("NS_Retention Document", false);
                    "NS_Retention Percent" := 0;
                    if "Currency Code" = '' then begin
                        "NS_Retention Amount (LCY)" := "NS_Retention Amount";
                    end else begin
                        NS_Currency.GET("Currency Code");
                        "NS_Retention Amount (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", "NS_Retention Amount",
                                                          CurrExchRate.ExchangeRate("Posting Date", "Currency Code")),
                                                          NS_Currency."Amount Rounding Precision");
                    end;
                    if "NS_Retention Date" = 0D then
                        if NS_JobsSetup."NS_Sales Retention Period" <> '' then
                            "NS_Retention Date" := CALCDATE('+' + NS_JobsSetup."NS_Sales Retention Period", "Posting Date");
                end else
                    "NS_Retention Amount (LCY)" := 0;
                //ProjectPro - end
            end;
        }
        field(14021145; "NS_Retention Date"; Date)
        {
            Caption = 'Retention Date';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                if CurrFieldNo <> 0 then begin
                    if "NS_Retention Date" > 0D then
                        TESTFIELD("NS_Retention Document", false);

                    if "NS_Retention Amount (LCY)" <> 0 then
                        TESTFIELD("NS_Retention Date");
                end;
                //ProjectPro - end
            end;
        }
        field(14021146; "NS_Retention Document"; Boolean)
        {
            Caption = 'Retention Document';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                if "NS_Retention Document" = true then begin
                    TESTFIELD("NS_Retention Amount (LCY)", 0);
                    TESTFIELD("NS_Retention Percent", 0);
                    TESTFIELD("NS_Retention Date", 0D);
                end;
                //ProjectPro - end
            end;
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
            DataClassification = CustomerContent;
            TableRelation = "NS_Retention Ledger Code".NS_Code;
        }
        //CTSI-150.AS.1.0 28Sept2020 - start
        field(14021350; "NS_Use % Billing format"; Boolean)
        {
            Caption = 'Use % Billing Format';
            Description = 'Boolean Use % Billing Format';
            DataClassification = CustomerContent;
        }
        //CTSI-150.AS.1.0 28Sept2020 - end
        field(14021400; "NS_Free Freight"; Boolean)
        {
            Caption = 'Free Freight';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021401; "NS_Entered By"; Code[50])
        {
            Caption = 'Entered By';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021402; "NS_Core Credit Override"; Boolean)
        {
            Caption = 'Core Credit Override';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021403; NS_Collector; Code[10])
        {
            Caption = 'Collector';
            Description = 'ProjectPro';
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
        }
        field(14021404; "NS_Credit Approved By"; Code[50])
        {
            Caption = 'Credit Approved By';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021405; "NS_Credit Approved On"; DateTime)
        {
            Caption = 'Credit Approved On';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021406; "NS_Invoice Delivery Method"; Code[10])
        {
            Caption = 'Invoice Delivery Method';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
    }

    procedure NS_RetentionBase(DocumentType: enum "Sales Document Type"; No: Code[20]): Decimal;
    var
        SalesHeader: Record 36;
        SalesLine: Record 37;
        TotalRetention: Decimal;
    BEGIN
        //ProjectPro - start
        TotalRetention := 0;
        NS_JobsSetup.GET;

        IF SalesHeader.GET(DocumentType, No) THEN
            IF (NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" =
                NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"2 - Calc tax on sale then apply retention determined by progress billing") OR
               (NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" =
                NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing") THEN BEGIN
                SalesHeader.CALCFIELDS("NS_Retention Base Before Tax", "NS_Retention InvoiceDiscAmount");
                TotalRetention := SalesHeader."NS_Retention Base Before Tax" - SalesHeader."NS_Retention InvoiceDiscAmount";
            END ELSE BEGIN
                SalesHeader.CALCFIELDS("NS_Retention Base Amount", "NS_Retention InvoiceDiscAmount");
                TotalRetention := SalesHeader."NS_Retention Base Amount" - SalesHeader."NS_Retention InvoiceDiscAmount";
            END;

        EXIT(TotalRetention);
        //ProjectPro - end
    END;

    var
        NS_JobsSetup: Record "Jobs Setup";
        NS_Currency: Record Currency;
        NS_JobCust: Record Customer;
        Text14021100lbl: Label 'There are lines that are not part of this job.  All Job Numbers will be set to %1.\If a Job Task Number does not exist on the new job, it will be cleared.\Do you want to continue?';
        Text14021101Lbl: Label 'The Job No. has not been modified.';
    /*+----------------------------------------------------------
  +ProjectPro
  + - Added field(s):
  +    14021100 Job No.
  +    14021130 Invoice Discount Amount
  +    14021136 Retention Base Amount
  +    14021137 Retention Base Before Tax
  +    14021138 Retention Percent
  +    14021139 Retention Amount (LCY)
  +    14021140 Retention Amount
  +    14021145 Retention Date
  +    14021146 Retention Document
  +    14021325 Progress Billing Document
  +    14021327 From Progress Billing No.
  +    14021328 From Progress Billing Req. No.
  +    14021329 From Progress Billing Ver. No.
  +    14021330 Retention Ledger Code
  +    14021400 Free Freight
  +    14021401 Entered By
  +    14021402 Core Credit Override
  +    14021403 Collector
  +    14021404 Credit Approved By
  +    14021405 Credit Approved On
  +    14021406 Invoice Delivery Method
  +
  + - Added function(s):
  +    RetentionBase
  +
  + - Added global variable(s):
  +     PP_JobsSetup
  +     PP_Currency
  +     PP_JobCust
  +
  + - Added global text constant(s):
  +     Text14021100
  +     Text14021101
  +
  + - Modification(s):
  +    - Set Customer Posting Group as Editable = Yes
  +    - Added field value for 'Customer Posting Group' after a Job No. is entered
  +    - Modification for retention in foreign currency
  +    - Modified Retention Base function to calcfields on the correct field
  +    - Modifed InitFromContact, InitFromTemplate to set shipping fields
  +    - Added number settings initialization to fields
  +       - In Sell-to Customer No. OnValidate()
  +       - In InitFromContact()
  +       - In InitFromTemplate
  +       Shipping No.
  +       Posting No.
  +       Return Receipt No.
  +       Prepayment No.
  +       Prepmt. Cr. Memo No.
  +   - TestSalesLineFieldsBeforeRecreate - Removed Testfield on Job No.
  +   - CreateSalesLine - Set Job No.
  +----------------------------------------------------------*/
}

