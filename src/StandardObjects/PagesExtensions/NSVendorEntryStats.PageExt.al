pageextension 14021244 NS_VendorEntryStats extends "Vendor Entry Statistics"
{
    // version NAVW111.00,PPNA11.00

    var
    //NS_PurchSetup: Record "Purchases & Payables Setup";


    //Unsupported feature: CodeModification on "OnAfterGetRecord". Please convert manually.

    //trigger OnAfterGetRecord();
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CLEARALL;

    for j := 1 to 6 do begin
      VendLedgEntry[j].SETCURRENTKEY("Document Type","Vendor No.","Posting Date");
      VendLedgEntry[j].SETRANGE("Document Type",j); // Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund
      VendLedgEntry[j].SETRANGE("Vendor No.","No.");
      if VendLedgEntry[j].FINDLAST then
        VendLedgEntry[j].CALCFIELDS(Amount,"Remaining Amount");
    end;

    VendLedgEntry2.SETCURRENTKEY("Vendor No.",Open);
    VendLedgEntry2.SETRANGE("Vendor No.","No.");
    VendLedgEntry2.SETRANGE(Open,true);
    if VendLedgEntry2.FIND('+') then
      repeat
        j := VendLedgEntry2."Document Type";
    #17..28
      VendLedgEntry2.SETCURRENTKEY("Vendor No.","Posting Date");
      VendLedgEntry2.SETRANGE("Vendor No.","No.");
      VendLedgEntry2.SETFILTER("Posting Date",VendDateFilter[i]);
      if VendLedgEntry2.FIND('+') then
        repeat
          j := VendLedgEntry2."Document Type";
    #35..48
          end;
        until VendLedgEntry2.NEXT(-1) = 0;
    end;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..6
      //ProjectPro - start
      if not NS_PurchSetup."Purchase Retention Inactive" then
        VendLedgEntry[j].SETRANGE("Retention Ledger Code",NS_PurchSetup."Normal Vendor Ledger No.");
      //ProjectPro - end
    #7..13
    //ProjectPro - start
    if not NS_PurchSetup."Purchase Retention Inactive" then
      VendLedgEntry2.SETRANGE("Retention Ledger Code",NS_PurchSetup."Normal Vendor Ledger No.");
    //ProjectPro - end
    #14..31
      //ProjectPro - start
      if not NS_PurchSetup."Purchase Retention Inactive" then
        VendLedgEntry2.SETRANGE("Retention Ledger Code",NS_PurchSetup."Normal Vendor Ledger No.");
      //ProjectPro - end
    #32..51
    */
    //end;


    //Unsupported feature: CodeInsertion on "OnOpenPage". Please convert manually.

    //trigger OnOpenPage();
    //begin
    /*
    //ProjectPro - start
    NS_PurchSetup.GET;
    //ProjectPro - end
    */
    //end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

