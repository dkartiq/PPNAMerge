pageextension 14021243 NS_CustomerEntryStats extends "Customer Entry Statistics"
{
    // version NAVW111.00,PPNA11.00

    var
    //PP_SalesSetup: Record "Sales & Receivables Setup";


    //Unsupported feature: CodeModification on "OnAfterGetRecord". Please convert manually.

    //trigger OnAfterGetRecord();
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CLEARALL;

    for j := 1 to 6 do begin
      CustLedgEntry[j].SETCURRENTKEY("Document Type","Customer No.","Posting Date");
      CustLedgEntry[j].SETRANGE("Document Type",j); // Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund
      CustLedgEntry[j].SETRANGE("Customer No.","No.");
      if CustLedgEntry[j].FINDLAST then
        CustLedgEntry[j].CALCFIELDS(Amount,"Remaining Amount");
    end;

    CustLedgEntry2.SETCURRENTKEY("Customer No.",Open);
    CustLedgEntry2.SETRANGE("Customer No.","No.");
    CustLedgEntry2.SETRANGE(Open,true);
    if CustLedgEntry2.FIND('+') then
      repeat
        j := CustLedgEntry2."Document Type";
    #17..27
      CustLedgEntry2.RESET;
      CustLedgEntry2.SETCURRENTKEY("Customer No.","Posting Date");
      CustLedgEntry2.SETRANGE("Customer No.","No.");

      CustLedgEntry2.SETFILTER("Posting Date",CustDateFilter[i]);
      CustLedgEntry2.SETRANGE("Posting Date",0D,CustLedgEntry2.GETRANGEMAX("Posting Date"));
      DtldCustLedgEntry2.SETCURRENTKEY("Customer No.","Posting Date");
      CustLedgEntry2.COPYFILTER("Customer No.",DtldCustLedgEntry2."Customer No.");
      CustLedgEntry2.COPYFILTER("Posting Date",DtldCustLedgEntry2."Posting Date");
      DtldCustLedgEntry2.CALCSUMS("Amount (LCY)");
      CustBalanceLCY := DtldCustLedgEntry2."Amount (LCY)";
      HighestBalanceLCY[i] := CustBalanceLCY;
    #40..64
              end else begin
                CustLedgEntry3.SETCURRENTKEY("Closed by Entry No.");
                CustLedgEntry3.SETRANGE("Closed by Entry No.",CustLedgEntry2."Entry No.");
                if CustLedgEntry3.FINDLAST then
                  UpdateDaysToPay(CustLedgEntry3."Posting Date" - CustLedgEntry2."Posting Date");
              end;
        until CustLedgEntry2.NEXT(-1) = 0;
      if NoOfInv <> 0 then
        AvgDaysToPay[i] := DaysToPay / NoOfInv;
    end;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..6
      //ProjectPro - start
      if not NS_SalesSetup."Sales Retention Inactive" then
        CustLedgEntry[j].SETRANGE("Retention Ledger Code",NS_SalesSetup."Normal Customer Ledger No.");
      //ProjectPro - end
    #7..13
    //ProjectPro - start
    if not NS_SalesSetup."Sales Retention Inactive" then
      CustLedgEntry2.SETRANGE("Retention Ledger Code",NS_SalesSetup."Normal Customer Ledger No.");
    //ProjectPro - end
    #14..30
      //ProjectPro - start
      if not NS_SalesSetup."Sales Retention Inactive" then
        CustLedgEntry2.SETRANGE("Retention Ledger Code",NS_SalesSetup."Normal Customer Ledger No.");
      //ProjectPro - end
    #31..33
      //ProjectPro - start
      //DtldCustLedgEntry2.SETCURRENTKEY("Customer No.","Posting Date");
      DtldCustLedgEntry2.SETCURRENTKEY("Customer No.","Posting Date","Initial Entry Global Dim. 1","Initial Entry Global Dim. 2","Retention Ledger Code");
      //ProjectPro - end
      CustLedgEntry2.COPYFILTER("Customer No.",DtldCustLedgEntry2."Customer No.");
      CustLedgEntry2.COPYFILTER("Posting Date",DtldCustLedgEntry2."Posting Date");
      //ProjectPro - start
      if not NS_SalesSetup."Sales Retention Inactive" then
        CustLedgEntry2.COPYFILTER("Retention Ledger Code",DtldCustLedgEntry2."Retention Ledger Code");
      //ProjectPro - end
    #37..67
                //ProjectPro - start
                if not NS_SalesSetup."Sales Retention Inactive" then
                  CustLedgEntry3.SETRANGE("Retention Ledger Code",CustLedgEntry2."Retention Ledger Code");
                //ProjectPro - end
    #68..74
    */
    //end;


    //Unsupported feature: CodeInsertion on "OnOpenPage". Please convert manually.

    //trigger OnOpenPage();
    //begin
    /*
    //ProjectPro - start
    NS_SalesSetup.GET;
    //ProjectPro - end
    */
    //end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

