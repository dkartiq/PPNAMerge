tableextension 14021201 NS_IssuedFinChargeMemoLine extends "Issued Fin. Charge Memo Line"
{
    // version NAVW111.00,PPNA11.00

    fields
    {

        //Unsupported feature: CodeModification on ""Entry No."(Field 5).OnLookup". Please convert manually.

        //trigger "(Field 5)();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if Type <> Type::"Customer Ledger Entry" then
          exit;
        IssuedFinChrgMemoHeader.GET("Finance Charge Memo No.");
        CustLedgEntry.SETCURRENTKEY("Customer No.");
        CustLedgEntry.SETRANGE("Customer No.",IssuedFinChrgMemoHeader."Customer No.");
        if CustLedgEntry.GET("Entry No.") then;
        PAGE.RUNMODAL(0,CustLedgEntry);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..5
        //ProjectPro - start
        NS_SalesSetup.GET;
        if not NS_SalesSetup."Sales Retention Inactive" then
          CustLedgEntry.SETRANGE("Retention Ledger Code",IssuedFinChrgMemoHeader."Retention Ledger Code");
        //ProjectPro - end
        if CustLedgEntry.GET("Entry No.") then;
        PAGE.RUNMODAL(0,CustLedgEntry);
        */
        //end;


        //Unsupported feature: CodeModification on ""Document No."(Field 11).OnLookup". Please convert manually.

        //trigger "(Field 11)();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if Type <> Type::"Customer Ledger Entry" then
          exit;
        IssuedFinChrgMemoHeader.GET("Finance Charge Memo No.");
        CustLedgEntry.SETCURRENTKEY("Customer No.");
        CustLedgEntry.SETRANGE("Customer No.",IssuedFinChrgMemoHeader."Customer No.");
        if CustLedgEntry.GET("Entry No.") then;
        PAGE.RUNMODAL(0,CustLedgEntry);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..5
        //ProjectPro - start
        NS_SalesSetup.GET;
        if not NS_SalesSetup."Sales Retention Inactive" then
          CustLedgEntry.SETRANGE("Retention Ledger Code",IssuedFinChrgMemoHeader."Retention Ledger Code");
        //ProjectPro - end
        if CustLedgEntry.GET("Entry No.") then;
        PAGE.RUNMODAL(0,CustLedgEntry);
        */
        //end;
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
}

