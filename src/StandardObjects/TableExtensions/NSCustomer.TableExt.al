tableextension 14021103 NS_Customer extends Customer
{
    // version NAVW111.00.00.24742,NAVNA11.00.00.24742,PPNA11.00
    //PRJ-678.N.S.1.0 Update currency code in Job card
    //PRJ-882.JS.1.0 27Aug2021 | Add one field
    fields
    {

        //Unsupported feature: Change CalcFormula on "Balance(Field 58)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Balance (LCY)"(Field 59)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Net Change"(Field 60)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Net Change (LCY)"(Field 61)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Sales (LCY)"(Field 62)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Profit (LCY)"(Field 63)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Inv. Discounts (LCY)"(Field 64)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Pmt. Discounts (LCY)"(Field 65)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Balance Due"(Field 66)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Balance Due (LCY)"(Field 67)". Please convert manually.


        //Unsupported feature: Change CalcFormula on "Payments(Field 69)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Invoice Amounts"(Field 70)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Cr. Memo Amounts"(Field 71)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Finance Charge Memo Amounts"(Field 72)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Payments (LCY)"(Field 74)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Inv. Amounts (LCY)"(Field 75)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Cr. Memo Amounts (LCY)"(Field 76)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Fin. Charge Memo Amounts (LCY)"(Field 77)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Outstanding Orders"(Field 78)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Shipped Not Invoiced"(Field 79)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Debit Amount"(Field 97)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Credit Amount"(Field 98)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Debit Amount (LCY)"(Field 99)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Credit Amount (LCY)"(Field 100)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Reminder Amounts"(Field 105)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Reminder Amounts (LCY)"(Field 106)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Outstanding Orders (LCY)"(Field 113)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Shipped Not Invoiced (LCY)"(Field 114)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Pmt. Disc. Tolerance (LCY)"(Field 117)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Pmt. Tolerance (LCY)"(Field 118)". Please convert manually.


        //Unsupported feature: Change CalcFormula on "Refunds(Field 120)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Refunds (LCY)"(Field 121)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Other Amounts"(Field 122)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Other Amounts (LCY)"(Field 123)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Outstanding Invoices (LCY)"(Field 125)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Outstanding Invoices"(Field 126)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Outstanding Serv. Orders (LCY)"(Field 5910)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Serv Shipped Not Invoiced(LCY)"(Field 5911)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Outstanding Serv.Invoices(LCY)"(Field 5912)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Balance on Date"(Field 10021)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Balance on Date (LCY)"(Field 10022)". Please convert manually.
        //PRJ-678.N.S.1.0 Start
        modify("Currency Code")
        {
            trigger OnAfterValidate()
            var
                JobRec: Record job;
            begin

                JobRec.reset();
                JobRec.SetRange("NS_Sell-to Customer No.", Rec."No.");
                if JobRec.FindSet() then
                    repeat
                        JobRec."Currency Code" := Rec."Currency Code";
                        JobRec.Modify();
                    until JobRec.Next() = 0;

            end;
        }
        //PRJ-678.N.S.1.0 END
        field(14021150; "NS_Default Retention Percent"; Decimal)
        {
            Caption = 'Default Retention Percent';
            DataClassification = CustomerContent;

            Description = 'ProjectPro';
        }

        field(14021400; "NS_County Name"; Text[30])
        {
            Caption = 'County Name';
            Description = 'ProjectPro';
            TableRelation = "Ship-to Address".County;
            DataClassification = CustomerContent;
        }
        field(14021401; NS_Collector; Code[10])
        {
            Caption = 'Credit Associate';
            Description = 'ProjectPro';
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
        }
        field(14021402; "NS_Customer PO Required"; Boolean)
        {
            Caption = 'Customer PO Required';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021403; "NS_Quoting Customer"; Boolean)
        {
            Caption = 'Quoting Customer';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021404; "NS_Past Due BalanceGracePeriod"; DateFormula)
        {
            Caption = 'Past Due Balance Grace Period';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021405; "NS_Credit Approval Complete"; Date)
        {
            Caption = 'Credit Approval Complete';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                CreditReviewMgt.NS_OnValidateCreditApprovalComplete(DATABASE::Customer
                                                                , "No."
                                                                , STRSUBSTNO(Text14021400Lbl  // entry text
                                                                           , FIELDCAPTION("NS_Credit Approval Complete")
                                                                           , TABLECAPTION
                                                                           , Name)
                                                                , STRSUBSTNO(Text14021401Lbl  // error text
                                                                           , FIELDCAPTION("NS_Credit Approval Complete")));
            end;
        }
        field(14021406; "NS_Credit Follow-up Date"; Date)
        {
            Caption = 'Credit Follow-up Date';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021407; "NS_CreditReviewToleranceAmount"; Decimal)
        {
            Caption = 'Credit Review Tolerance Amount';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';

            trigger OnValidate();
            var
                CreditReviewMgt: Codeunit "NS_Job CreditReviewMgt.";
            begin
                CreditReviewMgt.NS_Authorize(STRSUBSTNO(Text14021401Lbl, FIELDCAPTION("NS_CreditReviewToleranceAmount")));
            end;
        }
        field(14021408; "NS_Payment Pending"; Boolean)
        {
            CalcFormula = Exist("Gen. Journal Line" WHERE("Account Type" = CONST(Customer),
                                                           "Account No." = FIELD("No."),
                                                           Amount = FILTER(<> 0)));
            Caption = 'Payment Pending';
            Description = 'ProjectPro';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14021409; "NS_Credit Card on File"; Boolean)
        {
            Caption = 'Credit Card on File';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
        }
        field(14021410; "NS_Sales InvoiceDeliveryMethod"; Code[10])
        {
            Caption = 'Sales Invoice Delivery Method';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
        }
        field(14021411; "NS_Serv. InvoiceDeliveryMethod"; Code[10])
        {
            Caption = 'Serv. Invoice Delivery Method';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021412; "NS_Job Invoice Delivery Method"; Code[10])
        {
            Caption = 'Job Invoice Delivery Method';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021413; "NS_Next Planned Call-up Date"; Date)
        {
            Caption = 'Next Planned Call-up Date';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
        }
        field(14021414; "NS_Free Freight"; Boolean)
        {
            Caption = 'Free Freight';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021169; "NS_Retention Ledger CodeFilter"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            Caption = 'Retention Ledger Code';
        }
        field(14021168; "NS_Job Calendar Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Job Calendar Code';
            Description = 'ProjectPro';
        }
        field(14021170; "NS_Total Sales"; Decimal)     //PRJ-882.JS.1.0 27Aug2021
        {
            Caption = 'Total Sales';
            Description = 'ProjectPro';
            FieldClass = FlowField;
            CalcFormula = sum("Cust. Ledger Entry"."Sales (LCY)" where("NS_Retention Ledger Code" = filter('NORMAL'),
             "Customer No." = field("No."), "Sales (LCY)" = filter(<> 0)));
            editable = false;
        }

    }


    trigger OnBeforeInsert()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        IF "No." = '' THEN
            IF DocumentNoVisibility.CustomerNoSeriesIsDefault THEN BEGIN
                SalesSetup.GET;
                SalesSetup.TESTFIELD("Customer Nos.");
                NoSeriesMgt.InitSeries(SalesSetup."Customer Nos.", xRec."No. Series", 0D, "No.", "No. Series");
            END else
                TestField("No."); //SPLN1.00
    end;

    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        CreditReviewMgt: Codeunit "NS_Job CreditReviewMgt.";
        Text14021400Lbl: Label '%1 for %2 %3.';
        Text14021401Lbl: Label 'Not authorized to change %1.', Comment = '%1=Credit Review Tolerance Amount';


    procedure GetDefaultBankAcc(VAR CustomerBankAccount: Record "Customer Bank Account")
    begin
        IF "Preferred Bank Account Code" <> '' THEN
            CustomerBankAccount.GET("No.", "Preferred Bank Account Code")
        ELSE BEGIN
            CustomerBankAccount.SETRANGE("Customer No.", "No.");
            IF NOT CustomerBankAccount.FINDFIRST THEN
                CLEAR(CustomerBankAccount);
        END;
    end;

    /*
        SPLN1.00 2019-02-13 DMT Added code
      +-----------------------------------------------------
      +ProjectPro
      +  - Added fields:
      +     14021150 Default Retention Percent
      +     14021168 Job Calendar Code
      +     14021169 Retention Ledger Code Filter
      +     14021400 County Name
      +     14021401 Collector
      +     14021402 Customer PO Required
      +     14021403 Quoting Customer
      +     14021404 Past Due Balance Grace Period
      +     14021405 Credit Approval Complete
      +     14021406 Credit Follow-up Date
      +     14021407 Credit Review Tolerance
      +     14021408 Payment Pending
      +     14021409 Credit Card on File
      +     14021410 Sales Invoice Delivery Method
      +     14021411 Serv. Invoice Delivery Method
      +     14021412 Job Invoice Delivery Method
      +     14021413 Next Planned Call-up Date
      +     14021414 Free Freight
      +
      +  - Added functions(s)
      +     GetDefaultBankAcc
      +
      +  - Added Global Variable(s):
      +     CreditReviewMgt
      +
      +  - Added Global Text Constant(s):
      +     Text14021400
      +     Text14021401
      +
      +  - Modification(s):
      +     - Flowfilters:
      +            58 Balance
      +            59 Balance (LCY)
      +            60 Net Change
      +            61 Net Change (LCY)
      +            62 Sales (LCY)
      +            63 Profit (LCY)
      +            64 Inv. Discounts (LCY)
      +            65 Pmt. Discounts (LCY)
      +            66 Balance Due
      +            67 Balance Due (LCY)
      +            69 Payments
      +            70 Invoice Amounts
      +            71 Cr. Memo Amounts
      +            72 Finance Charge Memo Amounts
      +            74 Payments (LCY)
      +            75 Inv. Amounts (LCY)
      +            76 Cr. Memo Amounts (LCY)
      +            77 Fin. Charge Memo Amounts (LCY)
      +            78 Outstanding Orders
      +            79 Shipped Not Invoiced
      +            97 Debit Amount
      +            98 Credit Amount
      +            99 Debit Amount (LCY)
      +           100 Credit Amount (LCY)
      +           105 Reminder Amounts
      +           106 Reminder Amounts (LCY)
      +           113 Outstanding Orders (LCY)
      +           114 Shipped Not Invoiced (LCY)
      +           117 Pmt. Disc. Tolerance (LCY)
      +           118 Payment Tolerance (LCY)
      +           120 Refunds
      +           121 Refunds (LCY)
      +           122 Other Amounts
      +           123 Other Amounts (LCY)
      +           126 Outstanding Invoices
      +          5910 Outstanding Serv. Orders (LCY)
      +          5911 Serv Shipped Not Invoiced(LCY)
      +          5912 Outstanding Serv.Invoices(LCY)
      +         10021 Balance on Date
      +         10022 Balance on Date (LCY)
      +
      +-----------------------------------------------------*/
}

