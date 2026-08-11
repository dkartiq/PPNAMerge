tableextension 14021105 NS_Vendor extends Vendor
{
    // version NAVW111.00.00.24232,NAVNA11.00.00.24232,PPNA11.00

    fields
    {

        //Unsupported feature: Change CalcFormula on "Balance(Field 58)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Balance (LCY)"(Field 59)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Net Change"(Field 60)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Net Change (LCY)"(Field 61)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Purchases (LCY)"(Field 62)". Please convert manually.


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


        //Unsupported feature: Change CalcFormula on ""Amt. Rcd. Not Invoiced"(Field 79)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Debit Amount"(Field 97)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Credit Amount"(Field 98)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Debit Amount (LCY)"(Field 99)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Credit Amount (LCY)"(Field 100)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Reminder Amounts"(Field 104)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Reminder Amounts (LCY)"(Field 105)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Outstanding Orders (LCY)"(Field 113)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Amt. Rcd. Not Invoiced (LCY)"(Field 114)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Pmt. Disc. Tolerance (LCY)"(Field 117)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Pmt. Tolerance (LCY)"(Field 118)". Please convert manually.


        //Unsupported feature: Change CalcFormula on "Refunds(Field 120)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Refunds (LCY)"(Field 121)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Other Amounts"(Field 122)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Other Amounts (LCY)"(Field 123)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Outstanding Invoices"(Field 125)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Outstanding Invoices (LCY)"(Field 126)". Please convert manually.


        //Unsupported feature: Change Numeric on ""Creditor No."(Field 170)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Balance on Date"(Field 10021)". Please convert manually.


        //Unsupported feature: Change CalcFormula on ""Balance on Date (LCY)"(Field 10022)". Please convert manually.

        field(14021168; "NS_Job Calendar Code"; Code[10])
        {
            Caption = 'Job Calendar Code';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Calendar";
            DataClassification = CustomerContent;
        }
        field(14021400; "NS_Resource Provider"; Boolean)
        {
            Caption = 'Resource Provider';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }

        field(14021150; "NS_Default Retention Percent"; Decimal)
        {
            Caption = 'Default Retention Percent';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021169; "NS_Retention Ledger CodeFilter"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Retention Ledger Code';
            Description = 'ProjectPro';
        }
    }


    trigger OnBeforeInsert()
    var
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
    begin
        IF "No." = '' THEN
            IF DocumentNoVisibility.VendorNoSeriesIsDefault THEN BEGIN
                PurchSetup.GET;
                PurchSetup.TESTFIELD("Vendor Nos.");
                NoSeriesMgt.InitSeries(PurchSetup."Vendor Nos.", xRec."No. Series", 0D, "No.", "No. Series");
            END else
                TestField("No."); //SPLN1.00
    end;

    PROCEDURE InsuranceExpired(VendorNo: Code[20]; AsOfDate: Date) Expired: Boolean;
    VAR
        NS_VendorInsurance: Record "NS_Vendor Insurance";
    BEGIN
        //ProjectPro - start
        Expired := FALSE;

        WITH NS_VendorInsurance DO BEGIN
            RESET;
            SETRANGE("NS_Vendor No.", VendorNo);
            IF FINDFIRST THEN
                REPEAT
                    IF "NS_Expiration Date" <= AsOfDate THEN
                        Expired := TRUE;
                UNTIL NEXT = 0;
        END;

        EXIT;
        //ProjectPro - end
    END;

    /*+---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added fields:
      +     14021150 Default Retention Percent
      +     14021168 Job Calendar Code
      +     14021169 Retention Ledger Code Filter
      +     14021400 Resource Provider
      +
      +  - Added function(s):
      +     InsuranceExpired
      +
      +  - Added global variable(s):
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +     - Updated flowfilters on fields to include Retention Ledger Code:
      +            58 Balance
      +            59 Balance (LCY)
      +            60 Net Change
      +            61 Net Change (LCY)
      +            62 Purchases (LCY)
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
      +            79 Amt. Rcd. Not Invoiced
      +            97 Debit Amount
      +            98 Credit Amount
      +            99 Debit Amount (LCY)
      +           100 Credit Amount (LCY)
      +           104 Reminder Amounts
      +           105 Reminder Amounts (LCY)
      +           113 Outstanding Orders (LCY)
      +           114 Amt. Rcd. Not Invoiced (LCY)
      +           117 Pmt. Disc. Tolerance (LCY)
      +           118 Pmt. Tolerance (LCY)
      +           120 Refunds
      +           121 Refunds (LCY)
      +           122 Other Amounts
      +           123 Other Amounts (LCY)
      +           125 Outstanding Invoices
      +           126 Outstanding Invoices (LCY)
      +         10021 Balance on Date
      +         10022 Balance on Date (LCY)
      +
      +     - Modified Function(s):
      +         OpenVendorLedgerEntries
      +
      +-----------------------------------------------------------------------------------------------*/
}

