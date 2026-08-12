codeunit 14021326 "NS_Progress BillingMakeSaleDoc"
{
    // "a3b03edf-3f59-46a5-9644-a1f4a6b1d289"
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-180.SK.1.0 Added code for flowing Dimension from Progress billing to Sales INvoice
    //PRJ-180.SK.1.1 Added code for flow dimension on to lines from Progress billing document
    //CTSI-42.AS.1.0 21MAY2020 : Added Revenue Category Description value to Sales Line in case of invoice.
    //PRJ-293.MS.1.0 added code for retention calcultion
    //PRJ-333.AS.1.0 27 JULY 2020 Added Gen product posting group values to functions RetentionDocumentLines, NormalDocumentLines for Sales line
    //CTSI-179.MS.1.0 added code for flow of cust po no from job card to SI
    //CTSI-150 added code 
    //CTSI-150.AS.1.0 28Sept2020 Added code
    //TM-10.AM.1.0 | Added Segment code to flow.
    //PRJ-333.AM.1.0 | Modified existing code.
    //TM-10.AM.2.0 | added segment code in retention flow.
    //PRJ-333.AM.2.0 | Added Code to flow GPG while retention lines .
    //PRJ-650 Add project Pro in Error message or Warning message
    //PRJ-628.AM.1.0 Added & commented Code to assign condition based value in No.field in Sales Invoice Creation.
    //PRJ-773.SK.1.0 | 24JUNE2021 | Added event for required place
    //PRJ-862.JS.1.0-13Aug2021 | Existing lines commented and new line added 
    //PRJ-876.JS.1.0-23Aug2021 | code segment changet because of code conflict
    //PRJ-876.JS.1.0-23Aug2021 | while creating sales order from progress billing
    //PRJ-904.JS.1.0 10Sep2021 | Modify code as per process requirement
    //PRJ-913.JS.1.0�13Sep2021 | write code to flow dimension value as per job task
    //PRJ-973.GK.1.0 13Oct2021 | Added new code for progress billing
    //PRJ-1039.JS.1.0  12Nov2021 | Add code
    //PRJ-999.JS.1.0 12Nov2021 | Add code for dimension    
    //PRJ-1061.AS.1.0 Added PRJ-992 under condition of JobSetup Enable Item Field
    //PRJ-1304.RM.1 22April2022 | Added some code for Draw No.s
    //PRJ-1289.JS.1.0 30APR2022 | Write Procedure to create progress billing Credit Note
    //PRJ-1414.AS.1.0 25May2022 Created and Added event for CTSI
    //PRJ-1519.NK.1.0 17Aug2022 | Change code   
    //PRJ-1624.NK.1.0 23Sep2022 | Added Code    
    //ZEL-4.RM.1.0 10April2023 | Added some code  
    //PRJCTPR-299.DK.1.0 Start | Added Some code
    trigger OnRun();
    begin
        clear(BoolforNormalLineReteion) //PE-15.PS.1.0 19Jan2023
    end;

    var
        Text01Lbl: Label 'The draw number %1 has already been used for progress bill %2 - %3.  Do you want to override that with this billing?', Comment = '%1=NS_Draw No.,%2=NS_ProgressBillRequisitionNo.,%3=NS_ProgressBillRequisitionNo.';
        BoolforNormalLineReteion: Boolean; //PRJ-1648.PS.1.0 12OCT2022
        BoolforNormalLineStore: Boolean; //PRJ-1648.PS.1.0 12OCT2022
        BoolforNormalLine: Boolean;//PRJ-1648.PS.1.0 12OCT2022

    procedure NS_MakeReceivablesDocument(var BillingHeader: Record "NS_Progress Billing Header");
    var
        SalesHeader: Record "Sales Header";
        Job: Record Job;
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        ProgressBillingLine: Record "NS_Progress Billing Line";
        SalesSetup: Record "Sales & Receivables Setup";
        JobsSetup: Record "Jobs Setup";
        GLSetup: Record "General Ledger Setup";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        NoSeriesRelationship: Record "No. Series Relationship";
        Customer: Record Customer;
        Draw: Record NS_Draw;
        NS_JobsSetup: Record "Jobs Setup";    //PRJ-1138.JS.1.0  13Dec2022
        NS_Jobs: Record Job; //PE-22.JS.1.0 02FEB2023
        NS_Currency: Record Currency; //PE-22.JS.1.0 02FEB2023
        NSCurrencyExchange: Record "Currency Exchange Rate"; //PE-22.JS.1.0 02FEB2023
        NoSeriesMgt: Codeunit NoSeriesManagement;
        RequisitionAmount: Decimal;
        PreviousRetention: Decimal;
        RetBalance: Decimal;
        BillingValue: Decimal;
        TotalBilling: Decimal;
        Earned: Decimal;
        AIAG702Value08: Decimal;   //PRJ-1289.JS.1.0 29APR2022
        JobDimensionNo: Integer;
        Statement: Text[200];
        Used: Boolean;
        Mismatch: Boolean;
        Text001Lbl: Label 'The previous requisition must be invoiced before\making a document for this requisition.';
        Text002Lbl: Label 'Sales order document creation stopped.';
        Text003Lbl: Label 'Sales invoice document creation stopped.';
        Text004Lbl: Label 'This requisition cannot be processed because the retention credit amount is more than\the value of the retention for the Job at this time.\\This requisition should be modified to process only the credit value of the requisition.\Then make another requisition to reduce the retention.';
        Text005Lbl: Label '"Sales Order "';
        Text006Lbl: Label '"Sales Invoice "';
        Text007Lbl: Label '"Sales Credit Memo "';
        Text008Lbl: Label '" created from requisition."';
        LineRetention: Boolean;
        Licdate: date;//PRJ-516
        NoOfDays: Text;//PRJ-516
        EnvInfoCU: Codeunit "Environment Information";//PRJ-516
        Text001: Label 'Period To Date %1 is earlier than the Contract Forecast Date for Line No. %2. Do you still want to create Sales Document?'; //PRJCTPR-366.NC.1.0 11Jun2024
    begin
        with BillingHeader do begin
            //PRJ-516.ms.1.0 start
            if EnvInfoCU.IsSaaS() then begin
                //Licdate := DMY2Date(31, 3, 2021);//PRJ-516.AS.1.0 16MARCH2021 Comment
                // Licdate := DMY2Date(31, 5, 2021);//PRJ-516.AS.1.0 16MARCH2021 Added Change date
                // EVALUATE(NoOfDays, FORMAT(Licdate - WorkDate));
                // if (WorkDate > (Licdate - 6)) and (WorkDate <= Licdate) then
                //     Message('Your free trial is going to expire in %1 days.Please contact your administrator.', NoOfDays);
                // if WorkDate > Licdate then
                //     Error('Your free trial has expired.Please contact your administrator.');
                //PRJ-1686.GK.1.0 26Oct2022 start
                //PRJ-1641.JS.1.0 23SEP2022 - Start		
                // Licdate := DMY2Date(30, 11, 2022);
                // Licdate := DMY2Date(31, 12, 2022);
                // Licdate := DMY2Date(31, 1, 2023);
                // EVALUATE(NoOfDays, FORMAT(Licdate - WorkDate));
                // if (WorkDate > (Licdate - 15)) and (WorkDate <= Licdate) then
                //     Message('Your ProjectPro license is going to expire in %1 days.Please contact your administrator.', NoOfDays);
                // if WorkDate > Licdate then
                //     Error('Your ProjectPro license has expired.Please contact your administrator.');
                OnCheckPPLicenseExpire();   //PRJ-1641.JS.1.0 23SEP2022 line commented
                //PRJ-1641.JS.1.0 23SEP2022 - end
                //PRJ-1686.GK.1.0 26Oct2022 end               
            end;
            //PRJ-516.ms.1.0 end
            // Check that the Draw number has not been used on another progress bill
            if "NS_Draw No." > '' then begin
                Mismatch := false;
                Draw.RESET;
                Draw.SETRANGE("NS_No.", "NS_Draw No.");
                if Draw.FINDFIRST then begin
                    if (Draw."NS_Progress Bill No." <> "NS_No.") and (Draw."NS_Progress Bill No." <> '') then
                        Mismatch := true;
                    if (Draw."NS_ProgressBillRequisitionNo." <> "NS_Requisition No.") and
                       (Draw."NS_ProgressBillRequisitionNo." <> 0) then
                        Mismatch := true;
                    if Mismatch then begin
                        Statement := STRSUBSTNO(Text01Lbl, "NS_Draw No.", Draw."NS_ProgressBillRequisitionNo.",
                                                Draw."NS_ProgressBillRequisitionNo.");
                        if not CONFIRM(Statement) then
                            exit;
                    end;
                end;
            end;

            NS_OnAfterDrawfunctionsExecutedRetDocLines(BillingHeader);//PRJ-989.AS.1.0 18OCT2021 Added Event

            JobsSetup.GET;
            SalesSetup.GET;
            GLSetup.GET;
            Job.GET("NS_Job No.");
            if Customer.GET(Job."Bill-to Customer No.") then;
            CALCFIELDS("NS_Line Work Amount", "NS_Line Material Amount");
            NS_CalculateRequisition(BillingHeader);
            COMMIT;
            if ProgressBillingHeader.NS_IsInvoiced(BillingHeader, 1) <> 1 then
                ERROR(Text001Lbl);
            PreviousRetention := ProgressBillingHeader.NS_LastProgressBillRetention(BillingHeader);

            //Find the amount of the requisition
            BillingValue := 0;
            TotalBilling := 0;
            with ProgressBillingLine do begin
                RESET;
                SETRANGE("NS_Progress Billing No.", ProgressBillingHeader."NS_No.");
                SETRANGE("NS_Requisition No.", ProgressBillingHeader."NS_Requisition No.");
                SETRANGE("NS_Version No.", ProgressBillingHeader."NS_Version No.");
                if FINDSET then
                    repeat
                        TotalBilling := BillingValue + "NS_Work Amount" + "NS_Stored Materials Amount";
                        BillingValue := BillingValue + "NS_Work Amount" + "NS_Stored Materials Amount" + NS_LastTotal(ProgressBillingLine);
                    until NEXT = 0;
            end;

            TotalBilling := BillingValue;
            Earned := BillingValue - ProgressBillingHeader."NS_Total Retention";
            RequisitionAmount := Earned - ProgressBillingHeader.NS_ProgressBillPreviousInvoice(ProgressBillingHeader);

            //PRJCTPR-366.NC.1.0 11Jun2024 Start
            ProgressBillingLine.Reset();
            ProgressBillingLine.SetRange("NS_Progress Billing No.", BillingHeader."NS_No.");
            ProgressBillingLine.SetRange("NS_Requisition No.", BillingHeader."NS_Requisition No.");
            ProgressBillingLine.SetRange("NS_Version No.", BillingHeader."NS_Version No.");
            ProgressBillingLine.SetFilter("NS_Contract Forecast Date", '>%1', BillingHeader."NS_Period To");
            if ProgressBillingLine.FindSet() then begin
                if not Confirm(STRSUBSTNO(Text001, BillingHeader."NS_Period To", ProgressBillingLine."NS_Line No.")) then
                    exit;
            end;
            //PRJCTPR-366.NC.1.0 11Jun2024 End
            //Setup a new Sales Header
            SalesHeader.INIT;
            SalesHeader."NS_Progress Billing Document" := true;

            //Determine if the document will be an Order, Invoice or Credit Memo
            case true of
                RequisitionAmount = 0:
                    begin
                        if NS_RetentionDocumentValue(BillingHeader) >= 0 then
                            if JobsSetup."NS_Sales Document Type" = JobsSetup."NS_Sales Document Type"::Order then
                                SalesHeader."Document Type" := SalesHeader."Document Type"::Order
                            else
                                SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice
                        //PRJ-1289.JS.1.0 29APR-2022-Start
                        else begin
                            AIAG702Value08 := 0;
                            AIAG702Value08 := NS_RetentionDocumentValueAIAG702Values(BillingHeader);
                            if AIAG702Value08 < 0 then
                                SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo"
                            else
                                SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                        end;
                        //PRJ-1289.JS.1.0 29APR-2022-end    
                    end;
                RequisitionAmount > 0:
                    begin
                        if JobsSetup."NS_Sales Document Type" = JobsSetup."NS_Sales Document Type"::Order then
                            SalesHeader."Document Type" := SalesHeader."Document Type"::Order
                        else
                            SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                    end;
                RequisitionAmount < 0:
                    begin
                        //PRJ-1289.JS.1.0 29APR-2022-start
                        //SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";
                        AIAG702Value08 := 0;
                        AIAG702Value08 := NS_RetentionDocumentValueAIAG702Values(BillingHeader);
                        if AIAG702Value08 < 0 then
                            SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo"
                        else
                            SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                        //PRJ-1289.JS.1.0 29APR-2022-end 
                    end;
            end;

            //PRJ-904.JS.1.0 10Sep2021-start
            // Find the next document number
            // case SalesHeader."Document Type" of
            //     SalesHeader."Document Type"::Order:
            //         begin
            //             SalesSetup.TESTFIELD("Order Nos.");
            //             NoSeriesRelationship.RESET;
            //             NoSeriesRelationship.SETRANGE(Code, SalesSetup."Order Nos.");
            //             if NoSeriesRelationship.COUNT > 1 then begin
            //                 if NoSeriesMgt.SelectSeries(SalesSetup."Order Nos.", SalesHeader."No. Series", SalesHeader."No. Series") then
            //                     SalesHeader."No." := NoSeriesMgt.GetNextNo(SalesHeader."No. Series", WORKDATE(), true)
            //                 else
            //                     ERROR(Text002Lbl);
            //             end else
            //                 NoSeriesMgt.InitSeries(SalesSetup."Order Nos.", '',
            //                                        "NS_Requisition Date", SalesHeader."No.", SalesHeader."No. Series");
            //         end;
            //     SalesHeader."Document Type"::Invoice:
            //         begin
            //             SalesSetup.TESTFIELD("Invoice Nos.");
            //             NoSeriesRelationship.RESET;
            //             NoSeriesRelationship.SETRANGE(Code, SalesSetup."Invoice Nos.");
            //             if NoSeriesRelationship.COUNT > 1 then begin
            //                 if NoSeriesMgt.SelectSeries(SalesSetup."Invoice Nos.", 'XXX', SalesHeader."No. Series") then
            //                     SalesHeader."No." := NoSeriesMgt.GetNextNo(SalesHeader."No. Series", WORKDATE(), true)
            //                 else
            //                     ERROR(Text003Lbl);
            //             end else
            //                 NoSeriesMgt.InitSeries(SalesSetup."Invoice Nos.", '',
            //                                        "NS_Requisition Date", SalesHeader."No.", SalesHeader."No. Series");
            //         end;
            //     SalesHeader."Document Type"::"Credit Memo":
            //         begin
            //             SalesSetup.TESTFIELD("Credit Memo Nos.");
            //             NoSeriesRelationship.RESET;
            //             NoSeriesRelationship.SETRANGE(Code, SalesSetup."Credit Memo Nos.");
            //             if NoSeriesRelationship.COUNT > 1 then begin
            //                 if NoSeriesMgt.SelectSeries(SalesSetup."Credit Memo Nos.", 'XXX', SalesHeader."No. Series") then
            //                     SalesHeader."No." := NoSeriesMgt.GetNextNo(SalesHeader."No. Series", WORKDATE(), true)
            //                 else
            //                     ERROR(Text003Lbl);
            //             end else
            //                 NoSeriesMgt.InitSeries(SalesSetup."Credit Memo Nos.", '',
            //                                        "NS_Requisition Date", SalesHeader."No.", SalesHeader."No. Series");
            //         end;
            // end;
            //Find the next document number            
            case SalesHeader."Document Type" of
                SalesHeader."Document Type"::Order:
                    begin
                        SalesSetup.TESTFIELD("Order Nos.");
                        NoSeriesRelationship.Reset();
                        NoSeriesRelationship.SETRANGE(Code, SalesSetup."Order Nos.");
                        if NoSeriesRelationship.COUNT > 1 then begin
                            if NoSeriesMgt.SelectSeries(SalesSetup."Order Nos.", SalesHeader."No. Series", SalesHeader."No. Series") then
                                SalesHeader."No." := NoSeriesMgt.GetNextNo(SalesHeader."No. Series", WORKDATE(), true)
                            else
                                ERROR(Text002Lbl);
                        end else
                            NoSeriesMgt.InitSeries(SalesSetup."Order Nos.", '',
                                                   "NS_Requisition Date", SalesHeader."No.", SalesHeader."No. Series");
                    end;
                SalesHeader."Document Type"::Invoice:
                    begin
                        SalesSetup.TESTFIELD("Invoice Nos.");
                        JobsSetup.Get();
                        If JobsSetup."NS_PB Sales Invoice Nos." <> '' then begin
                            NoSeriesRelationship.Reset();
                            NoSeriesRelationship.SETRANGE(Code, JobsSetup."NS_PB Sales Invoice Nos.");
                            if NoSeriesRelationship.COUNT > 1 then begin
                                if NoSeriesMgt.SelectSeries(JobsSetup."NS_PB Sales Invoice Nos.", 'XXX', SalesHeader."No. Series") then
                                    SalesHeader."No." := NoSeriesMgt.GetNextNo(SalesHeader."No. Series", WORKDATE(), true)
                                else
                                    ERROR(Text003Lbl);
                            end else
                                NoSeriesMgt.InitSeries(JobsSetup."NS_PB Sales Invoice Nos.", '',
                                                       "NS_Requisition Date", SalesHeader."No.", SalesHeader."No. Series");

                        end else begin
                            NoSeriesRelationship.Reset();
                            NoSeriesRelationship.SETRANGE(Code, SalesSetup."Invoice Nos.");
                            if NoSeriesRelationship.COUNT > 1 then begin
                                if NoSeriesMgt.SelectSeries(SalesSetup."Invoice Nos.", 'XXX', SalesHeader."No. Series") then
                                    SalesHeader."No." := NoSeriesMgt.GetNextNo(SalesHeader."No. Series", WORKDATE(), true)
                                else
                                    ERROR(Text003Lbl);
                            end else
                                NoSeriesMgt.InitSeries(SalesSetup."Invoice Nos.", '',
                                                       "NS_Requisition Date", SalesHeader."No.", SalesHeader."No. Series");
                        end;
                    end;
                SalesHeader."Document Type"::"Credit Memo":
                    begin
                        SalesSetup.TESTFIELD("Credit Memo Nos.");
                        JobsSetup.Get();
                        If JobsSetup."NS_PB Sales Credit Memo Nos." <> '' then begin
                            NoSeriesRelationship.Reset();
                            NoSeriesRelationship.SETRANGE(Code, JobsSetup."NS_PB Sales Credit Memo Nos.");
                            if NoSeriesRelationship.COUNT > 1 then begin
                                if NoSeriesMgt.SelectSeries(JobsSetup."NS_PB Sales Credit Memo Nos.", 'XXX', SalesHeader."No. Series") then
                                    SalesHeader."No." := NoSeriesMgt.GetNextNo(SalesHeader."No. Series", WORKDATE(), true)
                                else
                                    ERROR(Text003Lbl);
                            end else
                                NoSeriesMgt.InitSeries(JobsSetup."NS_PB Sales Credit Memo Nos.", '',
                                                       "NS_Requisition Date", SalesHeader."No.", SalesHeader."No. Series");
                        end else begin
                            NoSeriesRelationship.Reset();
                            NoSeriesRelationship.SETRANGE(Code, SalesSetup."Credit Memo Nos.");
                            if NoSeriesRelationship.COUNT > 1 then begin
                                if NoSeriesMgt.SelectSeries(SalesSetup."Credit Memo Nos.", 'XXX', SalesHeader."No. Series") then
                                    SalesHeader."No." := NoSeriesMgt.GetNextNo(SalesHeader."No. Series", WORKDATE(), true)
                                else
                                    ERROR(Text003Lbl);
                            end else
                                NoSeriesMgt.InitSeries(SalesSetup."Credit Memo Nos.", '',
                                                       "NS_Requisition Date", SalesHeader."No.", SalesHeader."No. Series");
                        end;
                    end;
            end;
            //PRJ-904.JS.1.0 10Sep2021-end


            NS_OnBeforeInsertCustomerNoMakeReceivablesDocument(SalesHeader, RequisitionAmount, BillingHeader);//PRJ-1030.AS.1.0 Added event
                                                                                                              //Fill in the rest of the sales header
                                                                                                              //SalesHeader."Sell-to Customer No." := Job."Bill-to Customer No.";//ZEL-4.RM.1.0 10April2023 commented
            SalesHeader."Sell-to Customer No." := Job."Sell-to Customer No."; //ZEL-4.RM.1.0 10April2023
            SalesHeader."NS_Draw No." := BillingHeader."NS_Draw No.";//PRJ-1304.RM.1
            SalesHeader.InitRecord;
            NoSeriesMgt.SetDefaultSeries(SalesHeader."Shipping No. Series", SalesSetup."Posted Shipment Nos.");
            SalesHeader.VALIDATE("Sell-to Customer No.");
            SalesHeader."Bill-to Customer No." := ''; //ZEL-4.RM.1.0 10April2023 
            SalesHeader.VALIDATE("Posting Date", "NS_Period To"); //PRJ-699.N.S.1.0
            //SalesHeader.VALIDATE("Tax Liable", Job."NS_Tax Liable");    //PRJ-862.JS.1.0 Commented
            //SalesHeader.VALIDATE("Tax Area Code", Job."NS_Tax Area Code");   //PRJ-862.JS.1.0 Commented
            //PRJ-904.JS.1.0 10Sep2021-Start
            if JobsSetup."NS_Sales Document Type" = JobsSetup."NS_Sales Document Type"::Order then
                if JobsSetup."NS_PB Posted Invoice Nos." <> '' then
                    NoSeriesMgt.SetDefaultSeries(SalesHeader."Posting No. Series", JobsSetup."NS_PB Posted Invoice Nos.")
                else
                    NoSeriesMgt.SetDefaultSeries(SalesHeader."Posting No. Series", SalesSetup."Posted Invoice Nos.");

            If JobsSetup."NS_Sales Document Type" = JobsSetup."NS_Sales Document Type"::Invoice then
                If JobsSetup."NS_PB Posted Invoice Nos." <> '' then
                    NoSeriesMgt.SetDefaultSeries(SalesHeader."Posting No. Series", JobsSetup."NS_PB Posted Invoice Nos.")
                else
                    NoSeriesMgt.SetDefaultSeries(SalesHeader."Posting No. Series", SalesSetup."Posted Invoice Nos.");

            if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then
                if JobsSetup."NS_PB Posted Cr. Memo Nos." <> '' then
                    NoSeriesMgt.SetDefaultSeries(SalesHeader."Posting No. Series", JobsSetup."NS_PB Posted Cr. Memo Nos.");
            //PRJ-904.JS.1.0 10Sep2021-end                

            //Find the retention values
            CALCFIELDS("NS_Requisition Total");
            if (not NS_Final) and ("NS_Requisition Total" <> 0) then
                SalesHeader."NS_Retention Percent" := "NS_Work Retention Percent";
            //PRJ-1648.PS.1.0 11OCT2022 - Start
            // NS_RetentionMultipleDocs(BillingHeader);
            if BillingHeader."NS_R_Reduction & Invoicing" = true then begin
                if (BoolforNormalLineReteion = false) and (NS_StoreMarRetentionAmt(BillingHeader) <> 0) then begin
                    // if (NS_StoreMarRetentionAmt(BillingHeader) <> 0) then begin
                    SalesHeader."NS_Retention Document" := true
                end else begin
                    if (BoolforNormalLineStore = false) and (BoolforNormalLineReteion = false) then
                        BoolforNormalLine := true;
                end;
            end;

            //PRJ-1648.PS.1.0 11OCT2022 - End                
            if "NS_Requisition Total" = 0 then
                SalesHeader."NS_Retention Document" := true
            else begin
                if "NS_Total Retention" <> 0 then begin
                    if (JobsSetup."NS_A/R RetentionTaxCalcMethod" =
                        JobsSetup."NS_A/R RetentionTaxCalcMethod"::"2 - Calc tax on sale then apply retention determined by progress billing") or
                       (JobsSetup."NS_A/R RetentionTaxCalcMethod" =
                        JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing") then
                        SalesHeader."NS_Retention Amount" := "NS_Total Retention" - PreviousRetention
                    else
                        SalesHeader."NS_Retention Percent" := ProgressBillingHeader."NS_Work Retention Percent";
                    if "NS_Line Work Amount" < 0 then
                        SalesHeader."NS_Retention Amount" := -SalesHeader."NS_Retention Amount";
                    if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then
                        SalesHeader."NS_Retention Date" := CALCDATE(JobsSetup."NS_Sales Retention Period", SalesHeader."Document Date")
                    else
                        SalesHeader."NS_Retention Date" := SalesHeader."Document Date";
                    // >> Upgrade
                    //SalesHeader.VALIDATE("NS_Retention Amount"); // #132
                    // << Upgrade
                    //PRJ-1624.NK.1.0 26Sep2022 Start
                    if BillingHeader."NS_Multiple Retention on Lines" then begin
                        BillingHeader.CalcFields("NS_Lines Total Retention Amt");
                        SalesHeader."NS_Retention Amount" := Round((BillingHeader."NS_Lines Total Retention Amt" - PreviousRetention + NS_TotalStoreMarRetentionAmt(BillingHeader)), 0.01);
                        //PE-22.JS.1.0 21FEB2023-Start
                        if (SalesHeader."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0) then begin
                            if NS_Currency.get(SalesHeader."Currency Code") then;
                            SalesHeader."NS_Retention Amount" := Round((SalesHeader."NS_Retention Amount" * SalesHeader."Currency Factor"),
                            NS_Currency."Unit-Amount Rounding Precision");
                        end;
                        // >> Upgrade
                        SalesHeader."NS_Progress Billing Document" := true;
                        // << Upgrade
                    end;
                    //PRJ-1624.NK.1.0 26Sep2022 End
                    //PRJ-1648.PS.1.0 19Dec2022 Start

                    if (BillingHeader."NS_Multiple Retention on Lines") And (BillingHeader."NS_R_Reduction & Invoicing" = false) then begin  //PRJ-1648.PS.1.0 19Dec2022
                        BillingHeader.CalcFields("NS_Lines Total Retention New");
                        BillingHeader.CalcFields("NS_Stored Material Ret. Amt"); //PE-15.PS.1.0 02Feb2023
                        SalesHeader."NS_Retention Amount" := Round((BillingHeader."NS_Lines Total Retention Amt" - PreviousRetention + NS_TotalStoreMarRetentionAmt(BillingHeader)), 0.01); //PE-15.PS.1.0 02Feb2023
                                                                                                                                                                                            //PE-22.JS.1.0 21FEB2023-Start
                        if (SalesHeader."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0) then begin
                            if NS_Currency.get(SalesHeader."Currency Code") then;
                            SalesHeader."NS_Retention Amount" := Round((SalesHeader."NS_Retention Amount" * SalesHeader."Currency Factor"),
                            NS_Currency."Unit-Amount Rounding Precision");
                        end;
                        //PE-22.JS.1.0 21FEB2023-end   
                    end;

                    //PRJ-1648.PS.1.0 19Dec2022 End
                    //   SalesHeader.VALIDATE("NS_Retention Amount"); //PE-22.JS.1.0 line commented
                end;

                SalesHeader."NS_From Progress Billing No." := "NS_No.";
                SalesHeader."NS_From ProgressBillingReq.No." := "NS_Requisition No.";
                SalesHeader."NS_From ProgressBillingVer.No." := "NS_Version No.";
                // >> Upgrade
                //SalesHeader.VALIDATE("NS_Job No.", "NS_Job No.");
                // << Upgrade
                if BillingHeader."NS_Multiple Retention on Lines" then
                    SalesHeader."NS_Multiple Retention on Lines" := BillingHeader."NS_Multiple Retention on Lines";
                //PRJ-1624.NK.1.0 23Sep2022             
                SalesHeader.VALIDATE("NS_Job No.", "NS_Job No.");
                SalesHeader."NS_Use % Billing format" := Job."NS_Use % Billing format";//CTSI-150.AS.1.0
                SalesHeader."NS_Draw No." := BillingHeader."NS_Draw No.";//PRJ-1304.RM.1
                                                                         //PE-22.JS.1.0 02FEB2023-Start
                if (SalesHeader."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0) then
                    if NS_Currency.get(SalesHeader."Currency Code") then
                        SalesHeader.VALIDATE("NS_Retention Amount", Round(SalesHeader."NS_Retention Amount" * SalesHeader."Currency Factor",
                        NS_Currency."Unit-Amount Rounding Precision"));
                //PE-22.JS.1.0 02FEB2023-end
                NS_OnBeforeInsertSalesHeaderinPB(SalesHeader, BillingHeader, Job);//PRJ-1414.AS.1.0 Added event
                SalesHeader.INSERT;
                // >> Upgrade
                //FDD108 Start

                // SalesHeader.VALIDATE("Shortcut Dimension 1 Code", Job."Global Dimension 1 Code");
                // SalesHeader.VALIDATE("Shortcut Dimension 2 Code", Job."Global Dimension 2 Code");
                //JobDimensionNo := ProgressBillingHeader.GetDimensionNoFromJob(ProgressBillingHeader."Job No."); //PRJ-180.SK.1.0 Commented
                JobDimensionNo := ProgressBillingHeader.NS_GetDimensionNoFromJob("NS_Job No.");//PRJ-180.SK.1.0 Added
                                                                                               // SalesHeader."Dimension Set ID" := JobDimensionNo;
                SalesHeader.Validate("NS_Job No.", "NS_Job No.");
                SalesHeader.Modify;
                //FDD108 End
                // << Upgrade

                //SalesHeader.VALIDATE("Tax Liable", Job."NS_Tax Liable");     //PRJ-862.JS.1.0 Line Added //PRJCTPR-133.NC.1.0 22June2023 Block
                //SalesHeader.VALIDATE("Tax Area Code", Job."NS_Tax Area Code");   //PRJ-862.JS.1.0 Line Added //PRJCTPR-133.NC.1.0 22June2023 Block
                //PRJCTPR-199.JS.1.0 12DEC2023 Start belwo code commented
                // SalesHeader.VALIDATE("Shortcut Dimension 1 Code", Job."Global Dimension 1 Code");
                // SalesHeader.VALIDATE("Shortcut Dimension 2 Code", Job."Global Dimension 2 Code");
                //JobDimensionNo := ProgressBillingHeader.GetDimensionNoFromJob(ProgressBillingHeader."Job No."); //PRJ-180.SK.1.0 Commented
                // JobDimensionNo := ProgressBillingHeader.NS_GetDimensionNoFromJob("NS_Job No.");//PRJ-180.SK.1.0 Added
                // SalesHeader."Dimension Set ID" := JobDimensionNo;
                //PRJ-999.JS.1.0 12Nov2021 Start
                // SalesHeader."Shortcut Dimension 1 Code" := "NS_Global Dimension 1 Code";
                // SalesHeader."Shortcut Dimension 2 Code" := "NS_Global Dimension 2 Code";
                // SalesHeader."Dimension Set ID" := "NS_Dimension Set ID";
                //PRJCTPR-199.JS.1.0 12DEC2023 end belwo code commented
                //PRJ-999.JS.1.0 12Nov2021 end

                //PRJ-876.JS.1.0 23Aug2021-Start-below code commented
                //Set up Sales Lines
                // LineRetention := false;
                // if SalesHeader."NS_Retention Document" then
                //     NS_RetentionDocumentLines(BillingHeader, SalesHeader, Job)
                // else
                //     NS_NormalDocumentLines(BillingHeader, SalesHeader, Job);
                //PRJ-876.JS.1.0 23Aug2021-end    
                // >> Upgrade
                // #132 Start
                SalesHeader.Get(SalesHeader."Document Type", SalesHeader."No.");
                SalesHeader.Validate("NS_Retention Amount");
                SalesHeader.Modify;
                // #132 End
                // << Upgrade
                //Validation Checks
                if ("NS_Work Retention Percent" <> 0) or ("NS_Material Retention Percent" <> 0) then begin
                    //Find current Retention Balance for this Job
                    CustLedgerEntry.CLEARMARKS;
                    CustLedgerEntry.RESET;
                    CustLedgerEntry.SETCURRENTKEY("Customer No.", "Posting Date");
                    CustLedgerEntry.SETRANGE("Customer No.", Job."Bill-to Customer No.");
                    CustLedgerEntry.SETRANGE(Open, true);
                    if not SalesSetup."NS_Sales Retention Inactive" then
                        CustLedgerEntry.SETRANGE("NS_Retention Ledger Code", JobsSetup."NS_Retention Receivable Ledger");
                    if CustLedgerEntry.FINDSET then
                        repeat
                            if CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::Invoice then begin
                                Used := false;
                                SalesInvoiceLine.RESET;
                                SalesInvoiceLine.SETRANGE("Document No.", CustLedgerEntry."Document No.");
                                if SalesInvoiceLine.FINDSET then
                                    repeat
                                        if SalesInvoiceLine."Job No." = "NS_Job No." then begin
                                            //PE-22.JS.1.0 17FEB2023 - Start
                                            //CustLedgerEntry.CALCFIELDS("Remaining Amt. (LCY)");
                                            CustLedgerEntry.CALCFIELDS("Remaining Amt. (LCY)", "Remaining Amount");
                                            if CustLedgerEntry."Currency Code" = '' then
                                                RetBalance := RetBalance + CustLedgerEntry."Remaining Amt. (LCY)"
                                            else
                                                RetBalance := RetBalance + CustLedgerEntry."Remaining Amount";
                                            //PE-22.JS.1.0 17FEB2023 - end  
                                            Used := true
                                        end;
                                    until (SalesInvoiceLine.NEXT = 0) or Used;
                            end;
                            if CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::"Credit Memo" then begin
                                Used := false;
                                SalesCrMemoLine.RESET;
                                SalesCrMemoLine.SETRANGE("Document No.", CustLedgerEntry."Document No.");
                                if SalesCrMemoLine.FINDSET then
                                    repeat
                                        if SalesCrMemoLine."Job No." = "NS_Job No." then begin
                                            //PE-22.JS.1.0 17FEB2023 - Start
                                            //CustLedgerEntry.CALCFIELDS("Remaining Amt. (LCY)");
                                            CustLedgerEntry.CALCFIELDS("Remaining Amt. (LCY)", "Remaining Amount");
                                            if CustLedgerEntry."Currency Code" = '' then
                                                RetBalance := RetBalance + CustLedgerEntry."Remaining Amt. (LCY)"
                                            else
                                                RetBalance := RetBalance + CustLedgerEntry."Remaining Amount";
                                            //PE-22.JS.1.0 17FEB2023 - end 
                                            Used := true
                                        end;
                                    until (SalesCrMemoLine.NEXT = 0) or Used;
                            end;
                        until CustLedgerEntry.NEXT = 0;
                    if SalesHeader."NS_Retention Amount" + RetBalance < 0 then
                        ERROR(Text004Lbl);
                end;

                SalesHeader."NS_Retention Percent" := 0;
                if "NS_Requisition Total" <> 0 then
                    SalesHeader."NS_Retention Percent" := "NS_Work Retention Percent";//PRJ-293.MS.1.0
                                                                                      //SalesHeader."NS_Retention Percent" := ROUND(SalesHeader."NS_Retention Amount" / "NS_Requisition Total" * 100, GLSetup."Amount Rounding Precision");
                                                                                      //PRJ-1519.NK.1.0 08Sep2022 Start                                                                                   //SalesHeader."NS_Retention Percent" := ROUND(SalesHeader."NS_Retention Amount" / "NS_Requisition Total" * 100, GLSetup."Amount Rounding Precision");
                if BillingHeader."NS_Work Retention Percent" = 0 then
                    if BillingHeader."NS_Material Retention Percent" <> 0 then
                        SalesHeader."NS_Retention Percent" := BillingHeader."NS_Material Retention Percent";
                //PRJ-1519.NK.1.0 08Sep2022 End
                //Update Sales Header
                SalesHeader.Validate("Bill-to Customer No.", Job."Bill-to Customer No."); //PRJCTPR-386 AT.01 25june2024
                SalesHeader."External Document No." := Job."NS_Customer PO Number";//CTSI-179.MS.1.0
                SalesHeader."Salesperson Code" := Job."NS_Salesperson Code";//PRJ-415
                                                                            //ZEL-4.RM.1.0 10April2023 Start

                //SalesHeader.Validate("Bill-to Customer No.", Job."Bill-to Customer No."); //PRJCTPR-386 AT.01 25june2024 Block
                //PRJCTPR-133.NC.1.0 22June2023 Start
                if Job."NS_Tax Liable" = true then
                    SalesHeader.VALIDATE("Tax Liable", Job."NS_Tax Liable");
                if Job."NS_Tax Area Code" <> '' then
                    SalesHeader.VALIDATE("Tax Area Code", Job."NS_Tax Area Code");
                //PRJCTPR-133.NC.1.0 22June2023 End
                if Job."Invoice Currency Code" <> '' then
                    SalesHeader.Validate("Currency Code", Job."Invoice Currency Code");
                //ZEL-4.RM.1.0 10April2023 End
                SalesHeader."Your Reference" := Job."Your Reference";  //ZEL-5.GK.1.0 21Apr2023

                //PRJCTPR-177.AS.1.0 Start
                //PRJCTPR-199.JS.1.0 12DEC2023 Start belwo code commented  
                // SalesHeader."Shortcut Dimension 1 Code" := BillingHeader."NS_Global Dimension 1 Code";
                // SalesHeader."Shortcut Dimension 2 Code" := BillingHeader."NS_Global Dimension 2 Code";
                // SalesHeader."Dimension Set ID" := BillingHeader."NS_Dimension Set ID";
                //PRJCTPR-199.JS.1.0 12DEC2023 end belwo code commented
                //PRJCTPR-177.AS.1.0 end
                //SSCM-8.PS2048.22052024  //PRJCTPR-371.JS.1.0 22MAY2024
                NS_OnBeforeModifySalesHeaderAfterDimension(SalesHeader, BillingHeader, Job);
                //SSCM-8.PS2048.22052024  //PRJCTPR-371.JS.1.0 22MAY2024
                SalesHeader.MODIFY;
                //PRJ-876.JS.1.0 23Aug2021-Start bellow code added
                //Set up Sales Lines
                //PRJ-1648.PS.1.0 12OCT2022 - Start

                if BoolforNormalLine = true then begin
                    NS_RetentionStoreDocLine(BillingHeader, SalesHeader, Job);
                end else begin
                    LineRetention := false;
                    if SalesHeader."NS_Retention Document" then begin
                        //PRJ-1519.NK.1.0 17Aug2022 Start
                        if NS_CalcLastStrAmt(BillingHeader) then
                            NS_StoreMatrZeroLines(BillingHeader, SalesHeader, Job)
                        else
                            NS_RetentionDocumentLines(BillingHeader, SalesHeader, Job);
                        //NS_RetentionDocumentLines(BillingHeader, SalesHeader, Job);
                        // else
                        //     NS_NormalDocumentLines(BillingHeader, SalesHeader, Job);
                    end else begin
                        if NS_StoreMarRetentionAmt(BillingHeader) <> 0 then
                            NS_NormalDocumentLines(BillingHeader, SalesHeader, Job)
                        else
                            NS_RetentionStoreDocLine(BillingHeader, SalesHeader, Job);
                    end;
                end;

                //PRJ-1648.PS.1.0 12OCT2022 - End
                //PRJ-1519.NK.1.0 17Aug2022 end
                //PRJ-876.JS.1.0 23Aug2021-end            

                //Update Progress Billing Header with Receivable Document Information
                NS_OnDrawNoskip(BillingHeader, SalesHeader);//PRJ-989.AS.1.0 18OCT2021 Added Event
                case SalesHeader."Document Type" of
                    SalesHeader."Document Type"::Order:
                        "NS_Sales Document Type" := "NS_Sales Document Type"::Order;
                    SalesHeader."Document Type"::Invoice:
                        "NS_Sales Document Type" := "NS_Sales Document Type"::Invoice;
                    SalesHeader."Document Type"::"Credit Memo":
                        "NS_Sales Document Type" := "NS_Sales Document Type"::"Credit";
                end;
                "NS_Sales Document No." := SalesHeader."No.";
                NS_Status := NS_Status::Invoiced;
                MODIFY;

                //Update Draw record to show sales document created
                if "NS_Draw No." > '' then begin
                    //Draw record was read in earlier
                    case SalesHeader."Document Type" of
                        SalesHeader."Document Type"::Order:
                            Draw."NS_Sales Document Type" := Draw."NS_Sales Document Type"::Invoice;
                        SalesHeader."Document Type"::Invoice:
                            Draw."NS_Sales Document Type" := Draw."NS_Sales Document Type"::Invoice;
                        SalesHeader."Document Type"::"Credit Memo":
                            Draw."NS_Sales Document Type" := Draw."NS_Sales Document Type"::"Credit Memo";
                    end;
                    Draw."NS_Sales Document No." := SalesHeader."No.";
                    Draw."NS_Sales Document Date" := SalesHeader."Document Date";
                    Draw."NS_Progress Bill No." := "NS_No.";
                    Draw."NS_ProgressBillRequisitionNo." := "NS_Requisition No.";
                    Draw."NS_ProgressBillVersionNo." := "NS_Version No.";
                    Draw.MODIFY;
                end;

                //Show appropriate completion message
                case "NS_Sales Document Type" of
                    "NS_Sales Document Type"::Order:
                        MESSAGE(Text005Lbl + SalesHeader."No." + Text008Lbl);
                    "NS_Sales Document Type"::Invoice:
                        MESSAGE(Text006Lbl + SalesHeader."No." + Text008Lbl);
                    "NS_Sales Document Type"::"Credit":
                        MESSAGE(Text007Lbl + SalesHeader."No." + Text008Lbl);
                end;
            end;
        end;
    end;

    procedure NS_NormalDocumentLines(BillingHeader: Record "NS_Progress Billing Header"; SalesHeader: Record "Sales Header"; Job: Record Job);
    var
        ProgressBillingLine: Record "NS_Progress Billing Line";
        SalesLine: Record "Sales Line";
        JobTask: Record "Job Task";
        RevCatTbl: Record "NS_Job Revenue Category";//PRJ-702.AS.1.0
        JobActivity: Record "NS_Job Activity";
        JobProcess: Record "NS_Job Process";
        JobOperation: Record "NS_Job Operation";
        JobSection: Record NS_Sections;//PRJ-688.AM.1.0
        JobPostingGroup: Record "Job Posting Group";
        JobsSetup: Record "Jobs Setup";
        NS_Currency: Record Currency;  //PE-22.JS.1.0 02FEB2023
        NS_CurrencyExchange: Record "Currency Exchange Rate"; //PE-22.JS.1.0 02FEB2023
        PreviousStoredMaterial: Decimal;
        StoredMaterialToBill: Decimal;
        LineNumber: Integer;
        JobDimensionNo: Integer;
        LineRetention: Boolean;
        Licdate: date;//PRJ-516
        NoOfDays: Text;//PRJ-516
        EnvInfoCU: Codeunit "Environment Information";//PRJ-516
        NS_JobPlanningLines: Record "Job Planning Line"; //PRJ-973.GK.1.0 13Oct2021
        NSJPL: Record "Job Planning Line";//PRJ-992.AS.1.0
        ItemRec: Record Item;//PRJ-992.AS.1.0
        NS_Jobs: Record Job;  //PRJ-1039.JS.1.0 12Nov2021
        NS_JobsSetup: Record "Jobs Setup";   //PRJ-1138.JS.1.0  13Dec2022
        NS_SalesRecSetup: Record "Sales & Receivables Setup"; //PRJ-1543.GK.1.0 28July2022 
        RecSalesHead: Record "Sales Header"; //PRJ-1624.NK.1.0 20Oct2022
        RecSalesLine: Record "Sales Line"; //PRJ-1624.NK.1.0 20Oct2022
        PreviousRetention: Decimal; //PRJ-1624.NK.1.0 04Oct2022 
        PreviousStoreAmt: decimal;//PRJ-1624.NK.1.0 19Oct2022
        ChangeStoreMarAmt: Boolean; //PRJ-1624.NK.1.0 20Oct2022
        RetentionAmt: decimal; //PRJ-1624.NK.1.0 20Oct2022
        NS_GLAccount: Record "G/L Account";//PRJCTPR-299.DK.1.0
        NS_Resource: Record Resource;//PRJCTPR-299.DK.1.0
        SalesTaxCalculate: Codeunit "Sales Tax Calculate"; //PRJCTPR-320.NC.1.0 13Feb2024
        GLSetup: Record "General Ledger Setup"; //PRJCTPR-376.NC.1.0 18Jun2024
    begin
        //PRJ-516.ms.1.0 start
        if EnvInfoCU.IsSaaS() then begin
            //Licdate := DMY2Date(31, 3, 2021);//PRJ-516.AS.1.0 16MARCH2021 Comment
            // Licdate := DMY2Date(31, 5, 2021);//PRJ-516.AS.1.0 16MARCH2021 Added Change date
            // EVALUATE(NoOfDays, FORMAT(Licdate - WorkDate));
            // if (WorkDate > (Licdate - 6)) and (WorkDate <= Licdate) then
            //     Message('Your free trial is going to expire in %1 days.Please contact your administrator.', NoOfDays);
            // if WorkDate > Licdate then
            //     Error('Your free trial has expired.Please contact your administrator.');
            //PRJ-1686.GK.1.0 26Oct2022 start
            //PRJ-1641.JS.1.0 23SEP2022 - Start		
            // Licdate := DMY2Date(30, 11, 2022);
            // Licdate := DMY2Date(31, 12, 2022);
            // Licdate := DMY2Date(31, 1, 2023);
            // EVALUATE(NoOfDays, FORMAT(Licdate - WorkDate));
            // if (WorkDate > (Licdate - 15)) and (WorkDate <= Licdate) then
            //     Message('Your ProjectPro license is going to expire in %1 days.Please contact your administrator.', NoOfDays);
            // if WorkDate > Licdate then
            //     Error('Your ProjectPro license has expired.Please contact your administrator.');
            OnCheckPPLicenseExpire();   //PRJ-1641.JS.1.0 23SEP2022 line commented
            //PRJ-1641.JS.1.0 23SEP2022 - end
            //PRJ-1686.GK.1.0 26Oct2022 end            
        end;
        //PRJ-516.ms.1.0 end
        //Create Normal Receivables Document Lines
        with ProgressBillingLine do begin
            JobsSetup.GET;
            if GLSetup.Get() then; //PRJCTPR-376.NC.1.0 18Jun2024
            LineNumber := 0;
            RESET;
            SETRANGE("NS_Progress Billing No.", BillingHeader."NS_No.");
            SETRANGE("NS_Requisition No.", BillingHeader."NS_Requisition No.");
            SETRANGE("NS_Version No.", BillingHeader."NS_Version No.");
            if FINDSET then
                repeat
                    IF (ProgressBillingLine."NS_Work Amount" + ProgressBillingLine."NS_Stored Materials Amount" + ProgressBillingLine.NS_LastTotal(ProgressBillingLine) - BillingHeader.NS_LastProgressBillTCS(ProgressBillingLine)) <> 0 THEN begin  //PRJ-1624.NK.1.0 04Oct2022 
                                                                                                                                                                                                                                                      //if ProgressBillingLine."NS_Line Amount" <> 0 then begin  //PRJ-1624.NK.1.0 04Oct2022 Block
                                                                                                                                                                                                                                                      //Look for line retention calculations
                                                                                                                                                                                                                                                      //Look for line retention calculations
                        if ("NS_Work Retention Percent" <> 0) or
                           ("NS_Work Retention Amount" <> 0) or
                           ("NS_Material Retention Percent" <> 0) or
                           ("NS_Material Retention Amount" <> 0) then
                            LineRetention := true;

                        //Find to amount of Stored Materials to Bill
                        PreviousStoredMaterial := NS_LastProgressBillStoredMatLine(ProgressBillingLine);
                        if "NS_Stored Materials Amount" - PreviousStoredMaterial > 0 then
                            StoredMaterialToBill := "NS_Stored Materials Amount" - PreviousStoredMaterial
                        else
                            StoredMaterialToBill := 0;

                        //Build the sales line
                        SalesLine.INIT;
                        SalesLine."Document Type" := SalesHeader."Document Type";
                        SalesLine."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
                        SalesLine."Document No." := SalesHeader."No.";
                        LineNumber := LineNumber + 10000;
                        SalesLine."Line No." := LineNumber;
                        //PRJ-1061.AS.1.0 START <<
                        IF JobsSetup."NS_EnableItemNosForProgBill" = TRUE THEN BEGIN
                            //PRJ-992.AS.1.0 START
                            if NSJPL.Get("NS_Job No.", "NS_Job Task No.", "NS_Planing Line No.") then;

                            if (NSJPL.Type = NSJPL.Type::Item) and (NSJPL."NS_Progress Billing Method" = NSJPL."NS_Progress Billing Method"::Unit) then
                                SalesLine.Type := SalesLine.Type::Item
                            else
                                //PRJ-992.AS.1.0 END
                                SalesLine.Type := SalesLine.Type::"G/L Account";
                        END ELSE BEGIN
                            SalesLine.Type := SalesLine.Type::"G/L Account";
                        END;
                        //PRJ-1061.AS.1.0 END >>
                        SalesLine.VALIDATE(Type);

                        //Find the account to use
                        CLEAR(JobActivity);
                        CLEAR(JobProcess);
                        CLEAR(JobOperation);
                        Clear(JobSection);//PRJ-688.AM.1.0
                        if "NS_Job Task No." > '' then begin
                            JobActivity.GET(JobActivity.NS_Type::Revenue, "NS_Activity Code");
                            if "NS_Process Code" > '' then begin
                                JobProcess.GET(JobProcess.NS_Type::Revenue, "NS_Activity Code", "NS_Process Code");
                                if "NS_Operation Code" > '' then begin
                                    JobOperation.GET(JobOperation.NS_Type::Revenue, "NS_Activity Code", "NS_Process Code", "NS_Operation Code");
                                    //PRJ-688.AM.1.0
                                    if "NS_Section Code" > '' then
                                        JobSection.Get(JobSection.NS_Type::Revenue, "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code")
                                end;//PRJ-688.AM.1.0
                            end;
                        end;

                        // JobPostingGroup.GET(Job."Job Posting Group");//PRJ-628.AM.1.0 Commented
                        // SalesLine."No." := JobPostingGroup."Recognized Sales Account";//PRJ-628.AM.1.0 Commented
                        //PRJ-973.GK.1.0 13Oct2021 start

                        NS_JobPlanningLines.Reset();
                        NS_JobPlanningLines.SetRange("Job No.", "NS_Job No.");
                        NS_JobPlanningLines.SetRange("Job Task No.", "NS_Job Task No.");
                        NS_JobPlanningLines.SetRange("Line No.", "NS_Planing Line No.");
                        NS_JobPlanningLines.SetRange("NS_Use Job Plan. Line Entries", true);
                        NS_JobPlanningLines.SetRange(Type, NS_JobPlanningLines.Type::"G/L Account");
                        if NS_JobPlanningLines.FindFirst() then begin
                            SalesLine."No." := NS_JobPlanningLines."No.";
                        end else begin
                            if ProgressBillingLine."NS_Job Task No." <> '' then begin
                                IF JobTask.GET("NS_Job No.", "NS_Job Task No.") then
                                    if JobTask."Job Posting Group" <> '' then begin
                                        JobPostingGroup.GET(JobTask."Job Posting Group");
                                        SalesLine."No." := JobPostingGroup."Recognized Sales Account";
                                    end else //PRJ-628.AM.1.0 Start
                                        if JobTask."Job Posting Group" = '' then begin
                                            if Job.Get(ProgressBillingLine."NS_Job No.") then
                                                if JobPostingGroup.GET(Job."Job Posting Group") then
                                                    SalesLine."No." := JobPostingGroup."Recognized Sales Account";
                                        end; //PRJ-628.AM.1.0 End

                            end;
                        end;
                        //PRJ-973.GK.1.0 13Oct2021 end

                        //PRJ-1061.AS.1.0 START <<
                        IF JobsSetup."NS_EnableItemNosForProgBill" = TRUE THEN BEGIN
                            //PRJ-992.AS.1.0 START
                            if SalesLine.Type = SalesLine.Type::Item then
                                SalesLine."No." := NSJPL."No.";
                            //PRJ-992.AS.1.0 END
                        END;
                        //PRJ-1061.AS.1.0 END >>

                        NS_OnBeforeSalesLineNovalidateinNormalDocLinesofProgBill(SalesLine, ProgressBillingLine);//PRJ-989.AS.1.0 18OCT2021 Added Event //PRJ-1020.AS.1.0 Added
                        SalesLine.VALIDATE("No.");
                        //PRJ-1465.GK.1.0 20June2022 start
                        NS_OnBeforeInsertNormalDocumentLineMakeReceivablesDocument(SalesLine, ProgressBillingLine);
                        //PRJ-1465.GK.1.0 20June2022 end
                        //PRJCTPR-177.AS.1.0 Start
                        //PRJCTPR-199.JS.1.0 12DEC02023 Start below code commenetd
                        // SalesLine."Shortcut Dimension 1 Code" := ProgressBillingLine."NS_Shortcut Dimension 1 Code";
                        // SalesLine."Shortcut Dimension 2 Code" := ProgressBillingLine."NS_Shortcut Dimension 2 Code";
                        // SalesLine."Dimension Set ID" := ProgressBillingLine."NS_Dimension Set ID";
                        //PRJCTPR-199.JS.1.0 12DEC02023 end 
                        //PRJCTPR-177.AS.1.0 end
                        SalesLine.Insert();     //PRJ-876.JS.1.0 24Aug2021
                                                //PRJ-333.AS.1.0 27 JULY 2020 - START
                        NS_OnAfterInsertSalesLineFromProgressBillLine(SalesLine, ProgressBillingLine); //PE-95.NC.1.0 19May2023
                        // if job."NS_Gen. Prod. Posting Group" <> '' then//PRJ-831.AS.1.0 12OCT2021 Comment old
                        //     SalesLine."Gen. Prod. Posting Group" := Job."NS_Gen. Prod. Posting Group" //PRJ-333.AM.1.0 //PRJ-831.AS.1.0 12OCT2021 Comment old

                        if job."NS_Gen. Prod. Posting Group New" <> '' then//PRJ-831.AS.1.0 12OCT2021 Add New
                            SalesLine."Gen. Prod. Posting Group" := Job."NS_Gen. Prod. Posting Group New" //PRJ-333.AM.1.0//PRJ-831.AS.1.0 12OCT2021 Add New
                        else
                            //SalesLine."Gen. Prod. Posting Group" := JobsSetup."NS_Prog. Bill Gen. ProdPostGr.";//PRJ-333.AS.1.0 27 JULY 20220 //PRJ-1684.AS.1.0 Commented
                            SalesLine."Gen. Prod. Posting Group" := JobsSetup."NS_ProgBillGenProdPostGr New";//PRJ-333.AS.1.0 27 JULY 20220 //PRJ-1684.AS.1.0 Add
                                                                                                             //PRJ-333.AS.1.0 27 JULY 20220 - end  

                        //PRJ-1061.AS.1.0 START <<
                        IF JobsSetup."NS_EnableItemNosForProgBill" = TRUE THEN BEGIN
                            //PRJ-992.AS.1.0 START
                            if (SalesLine.Type = SalesLine.Type::Item) and (SalesLine."No." <> '') then
                                if SalesLine."Gen. Prod. Posting Group" = '' then begin
                                    if ItemRec.Get(SalesLine."No.") then
                                        SalesLine."Gen. Prod. Posting Group" := ItemRec."Gen. Prod. Posting Group";
                                end;
                            //PRJ-992.AS.1.0 END
                        END;
                        //PRJCTPR-299.DK.1.0 Start
                        IF (JobsSetup."NS_ProgBillGenProdPostGr New" = '') and (Job."NS_Gen. Prod. Posting Group New" = '') THEN BEGIN
                            if (SalesLine.Type = SalesLine.Type::"G/L Account") and (SalesLine."No." <> '') then
                                if SalesLine."Gen. Prod. Posting Group" = '' then begin
                                    if NS_GLAccount.Get(SalesLine."No.") then
                                        SalesLine."Gen. Prod. Posting Group" := NS_GLAccount."Gen. Prod. Posting Group";
                                end;
                            if (SalesLine.Type = SalesLine.Type::Resource) and (SalesLine."No." <> '') then
                                if SalesLine."Gen. Prod. Posting Group" = '' then begin
                                    if NS_Resource.Get(SalesLine."No.") then
                                        SalesLine."Gen. Prod. Posting Group" := NS_Resource."Gen. Prod. Posting Group";
                                end;
                        END;
                        //PRJCTPR-299.DK.1.0 END

                        //PRJ-1061.AS.1.0 END >>
                        //PRJ-1543.GK.1.0 28July2022 start

                        if NS_SalesRecSetup.Get() then;
                        if NS_SalesRecSetup."NS_Allow Description excl Nos." then begin
                            SalesLine.Description := ProgressBillingLine.NS_Description;
                        end else begin
                            if ProgressBillingLine."NS_Item No." > '' then
                                //SalesLine.Description := COPYSTR(ProgressBillingLine."NS_Item No." + ' - ' + ProgressBillingLine.NS_Description, 1, 50)   //PRJCTPR-189.JS.1.0 05Sep2023 line commented
                            SalesLine.Description := COPYSTR(ProgressBillingLine."NS_Item No." + ' - ' + ProgressBillingLine.NS_Description, 1, 100)   //PRJCTPR-189.JS.1.0 05Sep2023 line added
                            else
                                SalesLine.Description := ProgressBillingLine.NS_Description;
                        end;
                        //PRJ-1543.GK.1.0 28July2022 end
                        SalesLine.VALIDATE("Tax Liable", Job."NS_Tax Liable");
                        SalesLine.VALIDATE("Tax Area Code", Job."NS_Tax Area Code");
                        //SalesLine.VALIDATE("Tax Group Code", Job."NS_Tax Group Code"); //PRJCTPR-298.JS.1.0 Commented
                        SalesLine.VALIDATE("Tax Group Code", Job."NS_Tax Group Code New");  //PRJCTPR-298.JS.1.0
                        //PRJ-1061.AS.1.0 START <<
                        //PRJCTPR-136.NC.1.0 28June2023 Start
                        //IF JobsSetup."NS_EnableItemNosForProgBill" = TRUE THEN BEGIN 
                        IF JobsSetup."NS_Transfer Qty of Units to SI" = TRUE THEN BEGIN
                            if NSJPL.Get(ProgressBillingLine."NS_Job No.", ProgressBillingLine."NS_Job Task No.", ProgressBillingLine."NS_Planing Line No.") then;
                            if (ProgressBillingLine."NS_Current Work Unit" <> 0) and (NSJPL."NS_Progress Billing Method" = NSJPL."NS_Progress Billing Method"::Unit) and (NSJPL."No." <> '') then begin
                                SalesLine.Quantity := ProgressBillingLine."NS_Current Work Unit";
                                SalesLine.validate("Unit of Measure Code", ProgressBillingLine."NS_Unit of Measure Code");
                            end
                            //SalesLine.Quantity := ProgressBillingLine.NS_Quantity 
                            //PRJCTPR-136.NC.1.0 28June2023 End
                            else
                                SalesLine.Quantity := 1;
                        END ELSE BEGIN
                            SalesLine.Quantity := 1;
                        END;
                        //PRJ-1061.AS.1.0 END >>
                        //PE-301.NC.1.0 12Jun2024 Start
                        if JobsSetup.NS_EnableItemNosForProgBill then begin
                            if SalesLine.Type = SalesLine.Type::Item then begin
                                if Job.Get(ProgressBillingLine."NS_Job No.") then;
                                if job."NS_Pur/Sale UOM for B&B JPL" then begin
                                    if NSJPL.Get(ProgressBillingLine."NS_Job No.", ProgressBillingLine."NS_Job Task No.", ProgressBillingLine."NS_Planing Line No.") then;
                                    if ((NSJPL."Line Type" = NSJPL."Line Type"::"Both Budget and Billable") and (NSJPL.Type = NSJPL.Type::Item)) then begin
                                        if ItemRec.Get(SalesLine."No.") then;
                                        if ItemRec."Sales Unit of Measure" <> '' then
                                            SalesLine.Validate("Unit of Measure Code", ItemRec."Sales Unit of Measure");
                                    end;
                                end;
                            end;
                        end;
                        //PE-301.NC.1.0 12Jun2024 End

                        SalesLine.VALIDATE(Quantity);
                        SalesLine."Unit Price" := Round(ProgressBillingLine."NS_Work Amount" + ProgressBillingLine."NS_Stored Materials Amount" + ProgressBillingLine.NS_LastTotal(ProgressBillingLine) -
                                               BillingHeader.NS_LastProgressBillTCS(ProgressBillingLine), 0.01); //PE-15.PS.1.0 16Jan2023

                        NS_AfterSalesLineUnitpriceassgmtinNormDocLinefProgBill(SalesLine);//PRJ-989.AS.1.0 18OCT2021 Added Event
                        //PE-22.JS.1.0 02FEB2023 - Start
                        if SalesLine."Document Type" = SalesLine."Document Type"::Invoice then begin
                            if (SalesLine."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0) then
                                if NS_Currency.get(SalesLine."Currency Code") then
                                    SalesLine.Validate("Unit Price", Round(SalesLine."Unit Price" * SalesHeader."Currency Factor",
                                    NS_Currency."Unit-Amount Rounding Precision"));
                        end;
                        //PE-22.JS.1.0 02FEB2023 - End

                        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then begin
                            if SalesLine."Unit Price" < 0 then begin
                                SalesLine."Unit Price" := -SalesLine."Unit Price";
                            end else begin
                                SalesLine.Quantity := -SalesLine.Quantity;
                                SalesLine.VALIDATE(Quantity);
                            end;
                        end;
                        SalesLine.Amount := Round(SalesLine."Unit Price", 0.01);//PE-15.PS.1.0 16Jan2023
                        SalesLine.VALIDATE("Unit Price");
                        SalesLine.Amount := SalesLine."Unit Price";
                        SalesLine."NS_Segment Code" := "NS_Segment Code";//TM-10.AM.1.0
                        CalcFields("NS_Segment Name");//TM-32.AM.1.0
                        SalesLine."NS_Segment Name" := ProgressBillingLine."NS_Segment Name";//TM-32.AM.1.0
                        SalesLine.VALIDATE(Amount);
                        //PRJCTPR-136.NC.1.0 2June2023 Start
                        IF JobsSetup."NS_Transfer Qty of Units to SI" THEN BEGIN
                            if NSJPL.Get(ProgressBillingLine."NS_Job No.", ProgressBillingLine."NS_Job Task No.", ProgressBillingLine."NS_Planing Line No.") then;
                            if (ProgressBillingLine."NS_Current Work Unit" <> 0) and (NSJPL."NS_Progress Billing Method" = NSJPL."NS_Progress Billing Method"::Unit) and (NSJPL."No." <> '') then begin
                                SalesLine."Unit Price" := SalesLine.Amount / ProgressBillingLine."NS_Current Work Unit";
                                SalesLine.Validate("Unit Price");
                                SalesLine.validate("Unit of Measure Code", ProgressBillingLine."NS_Unit of Measure Code");
                            end;
                        end;
                        //PRJCTPR-136.NC.1.0 28June2023 End
                        //PE-301.NC.1.0 12Jun2024 Start
                        if JobsSetup.NS_EnableItemNosForProgBill then begin
                            if SalesLine.Type = SalesLine.Type::Item then begin
                                if Job.Get(ProgressBillingLine."NS_Job No.") then;
                                if job."NS_Pur/Sale UOM for B&B JPL" then begin
                                    if NSJPL.Get(ProgressBillingLine."NS_Job No.", ProgressBillingLine."NS_Job Task No.", ProgressBillingLine."NS_Planing Line No.") then;
                                    if ((NSJPL."Line Type" = NSJPL."Line Type"::"Both Budget and Billable") and (NSJPL.Type = NSJPL.Type::Item)) then begin
                                        if ItemRec.Get(SalesLine."No.") then;
                                        if ItemRec."Sales Unit of Measure" <> '' then
                                            SalesLine.Validate("Unit of Measure Code", ItemRec."Sales Unit of Measure");
                                    end;
                                end;
                            end;
                        end;
                        //PE-301.NC.1.0 12Jun2024 End
                        //PRJ-1624.NK.1.0 23Sep2022 Start
                        // if BillingHeader."NS_Multiple Retention on Lines" then begin
                        if ((BillingHeader."NS_Multiple Retention on Lines" = true) and (BillingHeader."NS_R_Reduction & Invoicing" = False)) then begin  //PRJ-1648.PS.1.0 8Dec2022
                            PreviousRetention := NS_LastProgrBillRetLine(BillingHeader, ProgressBillingLine);
                            PreviousStoreAmt := 0;
                            if NS_LastStotrBilling(ProgressBillingLine) > ProgressBillingLine."NS_Stored Materials Amount" then
                                PreviousStoreAmt := NS_LastStotrBilling(ProgressBillingLine) - ProgressBillingLine."NS_Stored Materials Amount";
                            if ((ProgressBillingLine."NS_Stored Mat. Retention Amt" <> 0) and (ProgressBillingLine."NS_Work Retention Percent" <> 0)) then begin
                                if ProgressBillingLine."NS_Work Retention Amount" - PreviousRetention = 0 then begin
                                    SalesLine."NS_Retention %" := ProgressBillingLine."NS_Stored Material Retention %";
                                    //SalesLine."NS_Retention Amount" := ProgressBillingLine."NS_Work Retention Amount" - PreviousRetention + ProgressBillingLine."NS_Stored Mat. Retention Amt"; //PRJCTPR-376.NC.1.0 18Jun2024 Block
                                    SalesLine."NS_Retention Amount" := Round((ProgressBillingLine."NS_Work Retention Amount" - PreviousRetention + ProgressBillingLine."NS_Stored Mat. Retention Amt"), GLSetup."Amount Rounding Precision"); //PRJCTPR-376.NC.1.0 18Jun2024
                                    //PE-22.JS.1.0 21FEB2023-Start
                                    if (SalesHeader."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0) then begin
                                        if NS_Currency.get(SalesHeader."Currency Code") then;
                                        SalesLine."NS_Retention Amount" := Round((SalesLine."NS_Retention Amount" * SalesHeader."Currency Factor"),
                                        NS_Currency."Unit-Amount Rounding Precision");
                                    end;
                                    //PE-22.JS.1.0 21FEB2023-end 
                                end else begin
                                    if NS_LastStotrBilling(ProgressBillingLine) - ProgressBillingLine."NS_Stored Materials Amount" = 0 then begin
                                        SalesLine."NS_Retention %" := ProgressBillingLine."NS_Work Retention Percent";
                                        //SalesLine."NS_Retention Amount" := ProgressBillingLine."NS_Work Retention Amount" - PreviousRetention + ProgressBillingLine."NS_Stored Mat. Retention Amt"; //PRJCTPR-376.NC.1.0 18Jun2024 Block
                                        SalesLine."NS_Retention Amount" := Round((ProgressBillingLine."NS_Work Retention Amount" - PreviousRetention + ProgressBillingLine."NS_Stored Mat. Retention Amt"), GLSetup."Amount Rounding Precision"); //PRJCTPR-376.NC.1.0 18Jun2024
                                        //PE-22.JS.1.0 20FEB2023-Start
                                        if (SalesHeader."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0) then
                                            if NS_Currency.get(SalesHeader."Currency Code") then
                                                SalesLine.VALIDATE("NS_Retention Amount", Round(SalesLine."NS_Retention Amount" * SalesHeader."Currency Factor",
                                                    NS_Currency."Unit-Amount Rounding Precision"));
                                        //PE-22.JS.1.0 20FEB2023-ends    
                                    end else begin
                                        SalesLine."NS_Retention %" := 0;
                                        //SalesLine."NS_Retention Amount" := ProgressBillingLine."NS_Work Retention Amount" - PreviousRetention + ProgressBillingLine."NS_Stored Mat. Retention Amt"; //PRJCTPR-376.NC.1.0 18Jun2024 Block
                                        SalesLine."NS_Retention Amount" := Round((ProgressBillingLine."NS_Work Retention Amount" - PreviousRetention + ProgressBillingLine."NS_Stored Mat. Retention Amt"), GLSetup."Amount Rounding Precision"); //PRJCTPR-376.NC.1.0 18Jun2024
                                        //PE-22.JS.1.0 20FEB2023-Start
                                        if (SalesHeader."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0) then
                                            if NS_Currency.get(SalesHeader."Currency Code") then
                                                SalesLine.VALIDATE("NS_Retention Amount", Round(SalesLine."NS_Retention Amount" * SalesHeader."Currency Factor",
                                                    NS_Currency."Unit-Amount Rounding Precision"));
                                        //PE-22.JS.1.0 20FEB2023-ends
                                    end;
                                end;
                            end else begin
                                if ProgressBillingLine."NS_Stored Mat. Retention Amt" <> 0 then begin
                                    SalesLine."NS_Retention %" := ProgressBillingLine."NS_Stored Material Retention %";
                                    if NS_LastStotrBilling(ProgressBillingLine) < ProgressBillingLine."NS_Stored Materials Amount" then
                                        //SalesLine."NS_Retention Amount" := ProgressBillingLine."NS_Stored Mat. Retention Amt" - NS_LastStotrRetentionAmt(ProgressBillingLine)  //PRJCTPR-376.NC.1.0 18Jun2024 Block
                                    SalesLine."NS_Retention Amount" := Round((ProgressBillingLine."NS_Stored Mat. Retention Amt" - NS_LastStotrRetentionAmt(ProgressBillingLine)), GLSetup."Amount Rounding Precision") //PRJCTPR-376.NC.1.0 18Jun2024
                                    else
                                        //SalesLine."NS_Retention Amount" := ProgressBillingLine."NS_Stored Mat. Retention Amt";  //PRJCTPR-376.NC.1.0 18Jun2024 Block
                                    SalesLine."NS_Retention Amount" := Round((ProgressBillingLine."NS_Stored Mat. Retention Amt"), GLSetup."Amount Rounding Precision"); //PRJCTPR-376.NC.1.0 18Jun2024
                                    //PE-22.JS.1.0 20FEB2023-Start
                                    if (SalesHeader."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0) then
                                        if NS_Currency.get(SalesHeader."Currency Code") then
                                            SalesLine.VALIDATE("NS_Retention Amount", Round(SalesLine."NS_Retention Amount" * SalesHeader."Currency Factor",
                                                NS_Currency."Unit-Amount Rounding Precision"));
                                    //PE-22.JS.1.0 20FEB2023-ends  
                                end else begin
                                    SalesLine."NS_Retention %" := ProgressBillingLine."NS_Work Retention Percent";
                                    //SalesLine."NS_Retention Amount" := ProgressBillingLine."NS_Work Retention Amount" - PreviousRetention; //PRJCTPR-376.NC.1.0 18Jun2024 Block
                                    SalesLine."NS_Retention Amount" := Round((ProgressBillingLine."NS_Work Retention Amount" - PreviousRetention), GLSetup."Amount Rounding Precision"); //PRJCTPR-376.NC.1.0 18Jun2024
                                    //PE-22.JS.1.0 20FEB2023-Start
                                    if (SalesHeader."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0) then
                                        if NS_Currency.get(SalesHeader."Currency Code") then
                                            SalesLine.VALIDATE("NS_Retention Amount", Round(SalesLine."NS_Retention Amount" * SalesHeader."Currency Factor",
                                                NS_Currency."Unit-Amount Rounding Precision"));
                                    //PE-22.JS.1.0 20FEB2023-ends   
                                    if ((ProgressBillingLine."NS_Work Retention Amount" = 0) AND (ProgressBillingLine."NS_Stored Mat. Retention Amt" = 0) AND (ProgressBillingLine."NS_Work Retention Percent" = 0) AND (ProgressBillingLine."NS_Stored Material Retention %" = 0)) then
                                        SalesLine."NS_Retention Amount" := 0;
                                end;
                            end;
                            if PreviousStoreAmt > 0 then Begin
                                SalesLine."NS_Retention %" := ProgressBillingLine."NS_Work Retention Percent";
                                //SalesLine."NS_Retention Amount" := ((ProgressBillingLine."NS_Work Retention Amount" - PreviousRetention) - (NS_LastStotrRetentionAmt(ProgressBillingLine) - ProgressBillingLine."NS_Stored Mat. Retention Amt")); //PRJCTPR-376.NC.1.0 18Jun2024 Block
                                SalesLine."NS_Retention Amount" := Round(((ProgressBillingLine."NS_Work Retention Amount" - PreviousRetention) - (NS_LastStotrRetentionAmt(ProgressBillingLine) - ProgressBillingLine."NS_Stored Mat. Retention Amt")), GLSetup."Amount Rounding Precision"); //PRJCTPR-376.NC.1.0 18Jun2024
                                //PE-22.JS.1.0 20FEB2023-Start
                                if (SalesHeader."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0) then
                                    if NS_Currency.get(SalesHeader."Currency Code") then
                                        SalesLine.VALIDATE("NS_Retention Amount", Round(SalesLine."NS_Retention Amount" * SalesHeader."Currency Factor",
                                            NS_Currency."Unit-Amount Rounding Precision"));
                                //PE-22.JS.1.0 20FEB2023-ends 

                                ChangeStoreMarAmt := True;
                            end;
                        end;
                        //PRJ-1624.NK.1.0 23Sep2022 End

                        //PRJ-1648.PS.1.0 19Dec2022 Start

                        if (BillingHeader."NS_Multiple Retention on Lines" = true) and (BillingHeader."NS_R_Reduction & Invoicing") then begin

                            // PE-15.PS.1.0 25Jan2023 Start

                            PreviousRetention := NS_LastProgrBillRetLine(BillingHeader, ProgressBillingLine);
                            PreviousStoreAmt := 0;
                            if NS_LastStotrBilling(ProgressBillingLine) > ProgressBillingLine."NS_Stored Materials Amount" then
                                PreviousStoreAmt := NS_LastStotrBilling(ProgressBillingLine) - ProgressBillingLine."NS_Stored Materials Amount";

                            // PE-15.PS.1.0 25Jan2023 End

                            if (ProgressBillingLine."NS_Work Amount" <> 0) and (ProgressBillingLine."NS_Stored Materials Amount" = 0) then begin
                                SalesLine."NS_Retention %" := ProgressBillingLine."NS_Work Retention Percent";
                                //SalesLine."NS_Retention Amount" := ProgressBillingLine."NS_Line Label Retetion"; //PRJCTPR-376.NC.1.0 18Jun2024 Block
                                SalesLine."NS_Retention Amount" := Round((ProgressBillingLine."NS_Line Label Retetion"), GLSetup."Amount Rounding Precision"); //PRJCTPR-376.NC.1.0 18Jun2024
                                //PE-22.JS.1.0 20FEB2023-Start
                                if (SalesHeader."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0) then
                                    if NS_Currency.get(SalesHeader."Currency Code") then
                                        SalesLine.VALIDATE("NS_Retention Amount", Round(SalesLine."NS_Retention Amount" * SalesHeader."Currency Factor",
                                            NS_Currency."Unit-Amount Rounding Precision"));
                                //PE-22.JS.1.0 20FEB2023-ends  
                            end;
                            if (ProgressBillingLine."NS_Work Amount" = 0) and (ProgressBillingLine."NS_Stored Materials Amount" <> 0) then begin
                                //SalesLine."NS_Retention Amount" := ProgressBillingLine."NS_Line Storage_Retetion" - ProgressBillingLine."NS_Eff Store Work Ret Red"; //PE-15.PS.1.0 09Jan2023 //PRJCTPR-376.NC.1.0 18Jun2024 Block
                                SalesLine."NS_Retention Amount" := Round((ProgressBillingLine."NS_Line Storage_Retetion" - ProgressBillingLine."NS_Eff Store Work Ret Red"), GLSetup."Amount Rounding Precision"); //PRJCTPR-376.NC.1.0 18Jun2024
                                SalesLine."NS_Retention %" := ProgressBillingLine."NS_Stored Material Retention %";
                                //PE-22.JS.1.0 20FEB2023-Start
                                if (SalesHeader."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0) then
                                    if NS_Currency.get(SalesHeader."Currency Code") then
                                        SalesLine.VALIDATE("NS_Retention Amount", Round(SalesLine."NS_Retention Amount" * SalesHeader."Currency Factor",
                                            NS_Currency."Unit-Amount Rounding Precision"));
                                //PE-22.JS.1.0 20FEB2023-ends 
                            end;
                            if (ProgressBillingLine."NS_Work Amount" <> 0) and (ProgressBillingLine."NS_Stored Materials Amount" <> 0) then begin
                                //SalesLine."NS_Retention Amount" := ProgressBillingLine."NS_Line Storage_Retetion" + ProgressBillingLine."NS_Line Label Retetion" - ProgressBillingLine."NS_Eff Store Work Ret Red"; //PE-15.PS.1.0 09Jan2023 //PRJCTPR-376.NC.1.0 18Jun2024 Block
                                SalesLine."NS_Retention Amount" := Round((ProgressBillingLine."NS_Line Storage_Retetion" + ProgressBillingLine."NS_Line Label Retetion" - ProgressBillingLine."NS_Eff Store Work Ret Red"), GLSetup."Amount Rounding Precision"); //PRJCTPR-376.NC.1.0 18Jun2024
                                SalesLine."NS_Retention %" := 0;
                                //PE-22.JS.1.0 20FEB2023-Start
                                if (SalesHeader."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0) then
                                    if NS_Currency.get(SalesHeader."Currency Code") then
                                        SalesLine.VALIDATE("NS_Retention Amount", Round(SalesLine."NS_Retention Amount" * SalesHeader."Currency Factor",
                                            NS_Currency."Unit-Amount Rounding Precision"));
                                //PE-22.JS.1.0 20FEB2023-ends  
                            end;

                            //PE-15.PS.1.0 16Jan2023 Strat
                            if PreviousStoreAmt > 0 then Begin
                                SalesLine."NS_Retention %" := ProgressBillingLine."NS_Work Retention Percent";
                                //SalesLine."NS_Retention Amount" := Round(SalesLine."Unit Price" * (SalesLine."NS_Retention %" / 100), 0.0001);  //PE-15.PS.1.0 16Jan2023 //PRJCTPR-376.NC.1.0 18Jun2024 Block
                                SalesLine."NS_Retention Amount" := Round((SalesLine."Unit Price" * (SalesLine."NS_Retention %" / 100)), GLSetup."Amount Rounding Precision"); //PRJCTPR-376.NC.1.0 18Jun2024
                                ChangeStoreMarAmt := True;
                                //PE-22.JS.1.0 20FEB2023-Start
                                if (SalesHeader."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0) then
                                    if NS_Currency.get(SalesHeader."Currency Code") then
                                        //SalesLine.VALIDATE("NS_Retention Amount", Round(SalesLine."NS_Retention Amount" * SalesHeader."Currency Factor",
                                        //    NS_Currency."Unit-Amount Rounding Precision"));
                                        SalesLine.Validate("NS_Retention Amount", SalesLine."NS_Retention Amount");
                                //PE-22.JS.1.0 20FEB2023-ends 
                            end;

                            //PE-15.PS.1.0 16Jan2023 End

                        end;

                        //PRJ-1648.PS.1.0 19Dec2022 End

                        SalesLine."Job No." := "NS_Job No.";
                        SalesLine."NS_Job Revenue Category" := "NS_Revenue Category";
                        //CTSI-42.AS.1.0 21MAY2020 - start
                        //if SalesLine."Document Type" = SalesLine."Document Type"::Invoice then
                        SalesLine."NS_Revenue Cat Description" := "NS_Revenue Cat Description";//PRJ-702.AS.1.0
                                                                                               //CTSI-42.AS.1.0 21MAY2020 - end
                                                                                               //PRJCTPR-199.JS.1.0 12DEC2023 Start
                                                                                               // SalesLine."Job Task No." := BillingHeader.NS_APOToJobTaskNo("NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code");//PRJ-688.AM.1.0
                        SalesLine.validate("Job Task No.", BillingHeader.NS_APOToJobTaskNo(ProgressBillingLine."NS_Activity Code", ProgressBillingLine."NS_Process Code", ProgressBillingLine."NS_Operation Code", ProgressBillingLine."NS_Section Code"));
                        //PRJCTPR-199.JS.1.0 12DEC2023 end
                        if (BillingHeader."NS_Work Retention Percent" > 0) or (BillingHeader."NS_Material Retention Percent" > 0) then
                            SalesLine."NS_Retention Applies" := true;
                        //PRJ-1308.GK.1.0 05May2022 start-Comment
                        // SalesLine."Shortcut Dimension 1 Code" := Job."Global Dimension 1 Code";
                        // SalesLine."Shortcut Dimension 2 Code" := Job."Global Dimension 2 Code";
                        // SalesLine."Dimension Set ID" := BillingHeader.NS_GetDimensionNoFromJob(BillingHeader."NS_Job No."); //PRJ-913.JS.1.0 line added
                        //PRJ-1308.GK.1.0 05May2022 end
                        //PRJ-1308.GK.1.0 05May2022 start comment
                        ////PRJ-913.JS.1.0�13Sep2021-Start                       
                        // if JobTask.GET(SalesLine."Job No.", SalesLine."Job Task No.") then
                        //     IF ((JobTask."Global Dimension 1 Code" <> '') and (JobTask."Global Dimension 2 Code" <> '')) then begin
                        //         SalesLine."Shortcut Dimension 1 Code" := JobTask."Global Dimension 1 Code";
                        //         SalesLine."Shortcut Dimension 2 Code" := JobTask."Global Dimension 2 Code";
                        //         SalesLine."Dimension Set ID" := BillingHeader.NS_GetDimensionNoFromJobTask(SalesLine."Job No.", SalesLine."Job Task No.");
                        //     end;
                        ////PRJ-913.JS.1.0�13Sep2021-end
                        //PRJ-1308.GK.1.0 05May2022 end                      

                        //PRJ-1039.JS.1.0 12Nov2021-Start
                        If NS_Jobs.get(SalesLine."Job No.") then
                            if NS_Jobs."NS_Sub-Level to Job No." = '' then
                                SalesLine."NS_Sub-Level to Job No." := NS_Jobs."No."
                            else
                                SalesLine."NS_Sub-Level to Job No." := NS_Jobs."NS_Sub-Level to Job No.";
                        //PRJ-1039.JS.1.0 12Nov2021-end                                                      

                        //SalesLine."Dimension Set ID" := JobDimensionNo;//PRJ-180.SK.1.1 Commented                        
                        //SalesLine."Dimension Set ID" := BillingHeader.NS_GetDimensionNoFromJob(BillingHeader."NS_Job No."); //PRJ-180.SK.1.1 Added //PRJ-913.JS.1.0 Commented                    

                        SalesLine."NS_From Prog. Billing Base Amount" := "NS_Base Amount";//CTSI-150.AS.1.0 28Sept2020
                                                                                          // >> Upgrade
                        OnBeforeInsertNS_NormalDocumentLines(SalesLine, ProgressBillingLine);
                        // << Upgrade
                        //PRJ-773.SK.1.0 Start
                        OnBeforeInsertSalesLineFromProgressBillLine(SalesLine, ProgressBillingLine);
                        //PRJ-773.SK.1.0 End
                        //PRJ-773.SK.1.0 End
                        //PRJCTPR-320.NC.1.0 12Feb2024 Start
                        if NS_JobsSetup.Get() then;
                        if NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" = NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing" then begin
                            if BillingHeader."NS_Multiple Retention on Lines" then begin
                                SalesLine."VAT Base Amount" := SalesLine.Amount - SalesLine."NS_Retention Amount";
                                SalesLine."Amount Including VAT" :=
                                                  SalesLine.Amount - SalesLine."NS_Retention Amount" +
                                                  SalesTaxCalculate.CalculateTax(
                                                    SalesLine."Tax Area Code", SalesLine."Tax Group Code", SalesLine."Tax Liable", SalesHeader."Posting Date",
                                                    SalesLine."VAT Base Amount", SalesLine."Quantity (Base)", SalesHeader."Currency Factor");
                            end;
                        end;
                        //PRJCTPR-320.NC.1.0 12Feb2024 End

                        //PRJ-1465.GK.1.0 20June2022 start
                        if SalesLine.Amount <> 0 then begin
                            //SalesLine.INSERT;   //PRJ-876.JS.1.0 24Aug2021 code commented
                            NS_OnBeforeModifyNormalDocumentLineMakeReceivablesDocument(SalesLine, ProgressBillingLine);
                            SalesLine.Modify();   //PRJ-876.JS.1.0 24Aug2021 line added
                        end;
                        //PRJ-1465.GK.1.0 20June2022 end
                    end;
                until ProgressBillingLine.NEXT = 0;
            //PRJ-1624.NK.1.0 20Oct2022 Start
            if BillingHeader."NS_Multiple Retention on Lines" then begin
                if ChangeStoreMarAmt then begin
                    RetentionAmt := 0;
                    RecSalesLine.Reset();
                    RecSalesLine.Setrange("Document Type", SalesHeader."Document Type");
                    RecSalesLine.Setrange("Document No.", SalesHeader."No.");
                    if RecSalesLine.FindSet() then
                        repeat
                            RetentionAmt += RecSalesLine."NS_Retention Amount";
                        Until RecSalesLine.Next() = 0;
                    RetentionAmt := Round(RetentionAmt, 0.01);
                    RecSalesHead.Reset();
                    RecSalesHead.Setrange("Document Type", SalesHeader."Document Type");
                    RecSalesHead.Setrange("No.", SalesHeader."No.");
                    if RecSalesHead.FindSet() then Begin
                        RecSalesHead.VALIDATE("NS_Retention Amount", RetentionAmt);
                        RecSalesHead.Modify();
                    End;
                end;
            End;
            //PRJ-1624.NK.1.0 20Oct2022 End
        end;
    end;

    procedure NS_RetentionDocumentLines(BillingHeader: Record "NS_Progress Billing Header"; SalesHeader: Record "Sales Header"; Job: Record Job);
    var
        ProgressBillingLine: Record "NS_Progress Billing Line";
        SalesLine: Record "Sales Line";
        SalesSetup: Record "Sales & Receivables Setup";
        RevCatTbl: Record "NS_Job Revenue Category";//PRJ-702.AS.1.0
        JobsSetup: Record "Jobs Setup";
        JobTask1: Record "Job Task";   //PRJ-913.JS.1.0�13Sep2021
        NS_JobsSetup: Record "Jobs Setup";   //PRJ-1138.JS.1.0  13Dec2022
        NS_Currency: Record Currency;  //PE-22.JS.1.0 08FEB2023
        LineNumber: Integer;
        Text0001: Label '"Retention for Job "';
        Text0002: Label 'Retention percentage changes cannot be on the same document with regular billings.';
        JobDimensionNo: Integer;
        Licdate: date;//PRJ-516
        NoOfDays: Text;//PRJ-516
        EnvInfoCU: Codeunit "Environment Information";//PRJ-516
        PreviousRetention: decimal; //PRJ-1624.NK.1.0 04Oct2022
        PreviousStoreAmt: decimal; //PRJ-1624.NK.1.0 20Oct2022
        RecSalesHead: Record "Sales Header"; //PRJ-1624.NK.1.0 20Oct2022
        RecSalesLine: Record "Sales Line"; //PRJ-1624.NK.1.0 20Oct2022
        ChangeStoreMarAmt: Boolean; //PRJ-1624.NK.1.0 20Oct2022
        RetentionAmt: decimal; //PRJ-1624.NK.1.0 20Oct2022
        SalesTaxCalculate: Codeunit "Sales Tax Calculate"; //PRJCTPR-320.NC.1.0 16Feb2024
        GLSetup: Record "General Ledger Setup"; //PRJCTPR-376.NC.1.0 18Jun2024
    begin
        //PRJ-516.ms.1.0 start
        if EnvInfoCU.IsSaaS() then begin
            //Licdate := DMY2Date(31, 3, 2021);//PRJ-516.AS.1.0 16MARCH2021 Comment
            // Licdate := DMY2Date(31, 5, 2021);//PRJ-516.AS.1.0 16MARCH2021 Added Change date
            // EVALUATE(NoOfDays, FORMAT(Licdate - WorkDate));
            // if (WorkDate > (Licdate - 6)) and (WorkDate <= Licdate) then
            //     Message('Your free trial is going to expire in %1 days.Please contact your administrator.', NoOfDays);
            // if WorkDate > Licdate then
            //     Error('Your free trial has expired.Please contact your administrator.');
            //PRJ-1686.GK.1.0 26Oct2022 start
            //PRJ-1641.JS.1.0 23SEP2022 - Start		
            // Licdate := DMY2Date(30, 11, 2022);
            // Licdate := DMY2Date(31, 12, 2022);
            // Licdate := DMY2Date(31, 1, 2023);
            // EVALUATE(NoOfDays, FORMAT(Licdate - WorkDate));
            // if (WorkDate > (Licdate - 15)) and (WorkDate <= Licdate) then
            //     Message('Your ProjectPro license is going to expire in %1 days.Please contact your administrator.', NoOfDays);
            // if WorkDate > Licdate then
            //     Error('Your ProjectPro license has expired.Please contact your administrator.');
            OnCheckPPLicenseExpire();   //PRJ-1641.JS.1.0 23SEP2022 line commented
            //PRJ-1641.JS.1.0 23SEP2022 - end
            //PRJ-1686.GK.1.0 26Oct2022 end

        end;
        //PRJ-516.ms.1.0 end
        //Create Retention Receivables Document Lines
        with ProgressBillingLine do begin
            LineNumber := 10000;
            JobsSetup.GET;
            SalesSetup.GET;
            if GLSetup.Get() then; //PRJCTPR-376.NC.1.0 18Jun2024
            if not SalesSetup."NS_Sales Retention Inactive" then begin
                RESET;
                SETRANGE("NS_Progress Billing No.", BillingHeader."NS_No.");
                SETRANGE("NS_Requisition No.", BillingHeader."NS_Requisition No.");
                SETRANGE("NS_Version No.", BillingHeader."NS_Version No.");
                if FINDSET then
                    repeat
                        // if ProgressBillingLine."NS_Work Amount" = 0 then begin //PRJ-1028.NK.1.0 09Feb2022 START Blocked if..end else
                        //Build the sales line
                        if (ProgressBillingLine."NS_Billed Work Retention Amt" + ProgressBillingLine."NS_Billed MaterialRetentionAmt") <> 0 then begin //PRJ-1519.NK.1.0 24Aug2022
                            SalesLine.INIT;
                            SalesLine."Document Type" := SalesHeader."Document Type";
                            SalesLine."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
                            SalesLine."Document No." := SalesHeader."No.";
                            SalesLine."Line No." := LineNumber;
                            SalesLine.Type := SalesLine.Type::NS_Ledger;
                            SalesLine.VALIDATE(Type);
                            SalesLine."No." := JobsSetup."NS_Retention Receivable Ledger";
                            SalesLine.VALIDATE("No.");
                            //PRJ-1465.GK.1.0 20June2022 start
                            NS_OnBeforeInsertRetentionDocumentLineMakeReceivablesDocument(SalesLine, ProgressBillingLine);
                            //PRJ-1465.GK.1.0 20June2022 end
                            SalesLine.Insert();   //PRJ-876.JS.1.0 24Aug2021 line added
                                                  // if job."NS_Gen. Prod. Posting Group" <> '' then //PRJ-333.AM.2.0 added code //PRJ-831.AS.1.0 12OCT2021 Comment old
                                                  //     SalesLine."Gen. Prod. Posting Group" := Job."NS_Gen. Prod. Posting Group" //PRJ-333.AM.2.0 added code //PRJ-831.AS.1.0 12OCT2021 Comment old
                            NS_OnAfterInsertSalesLineFromProgressBillLine(SalesLine, ProgressBillingLine); //PE-95.NC.1.0 19May2023
                            if job."NS_Gen. Prod. Posting Group New" <> '' then //PRJ-333.AM.2.0 added code //PRJ-831.AS.1.0 12OCT2021 Add New
                                SalesLine."Gen. Prod. Posting Group" := Job."NS_Gen. Prod. Posting Group New" //PRJ-333.AM.2.0 added code//PRJ-831.AS.1.0 12OCT2021 Add New
                            else                                                                          //PRJ-333.AM.2.0 added code
                                                                                                          //SalesLine."Gen. Prod. Posting Group" := JobsSetup."NS_Prog. Bill Gen. ProdPostGr.";//PRJ-1684.AS.1.0 Commented
                                SalesLine."Gen. Prod. Posting Group" := JobsSetup."NS_ProgBillGenProdPostGr New";//PRJ-1684.AS.1.0 Add

                            SalesLine.Description := Text0001 + "NS_Job No.";
                            SalesLine."Job No." := "NS_Job No.";
                            SalesLine.Quantity := 1;
                            SalesLine.VALIDATE(Quantity);
                            SalesLine."Unit Price" := Round(ProgressBillingLine."NS_Billed Work Retention Amt" + ProgressBillingLine."NS_Billed MaterialRetentionAmt", 0.01); //PE-15.PS.1.0 16Jan2023

                            if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then
                                SalesLine."Unit Price" := -SalesLine."Unit Price";
                            SalesLine.Amount := Round(SalesLine."Unit Price", 0.01);//PE-15.PS.1.0 16Jan2023
                            //PE-22.JS.1.0 08FEB2023-Start
                            //SalesLine.VALIDATE("Unit Price");                        
                            if SalesLine."Document Type" in [SalesLine."Document Type"::Invoice, SalesHeader."Document Type"::"Credit Memo"] then begin
                                if (SalesLine."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0) then
                                    if NS_Currency.get(SalesLine."Currency Code") then
                                        SalesLine.Validate("Unit Price", Round(SalesLine."Unit Price" * SalesHeader."Currency Factor",
                                        NS_Currency."Unit-Amount Rounding Precision"));
                                if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then
                                    SalesLine."Unit Price" := -SalesLine."Unit Price";
                            end;
                            //PE-22.JS.1.0 08FEB2023-End 
                            SalesLine.VALIDATE("Unit Price");
                            SalesLine.VALIDATE(Amount);
                            //PRJ-1624.NK.1.0 23Sep2022 Start
                            if ((BillingHeader."NS_Multiple Retention on Lines" = true) and (BillingHeader."NS_R_Reduction & Invoicing" = False)) then begin  //PRJ-1648.PS.1.0 8Dec2022
                                PreviousRetention := NS_LastProgrBillRetLine(BillingHeader, ProgressBillingLine);
                                PreviousStoreAmt := 0;
                                if NS_LastStotrBilling(ProgressBillingLine) > ProgressBillingLine."NS_Stored Materials Amount" then
                                    PreviousStoreAmt := NS_LastStotrBilling(ProgressBillingLine) - ProgressBillingLine."NS_Stored Materials Amount";
                                if ((ProgressBillingLine."NS_Stored Mat. Retention Amt" <> 0) and (ProgressBillingLine."NS_Work Retention Percent" <> 0)) then begin
                                    if ProgressBillingLine."NS_Work Retention Amount" - PreviousRetention = 0 then begin
                                        SalesLine."NS_Retention %" := ProgressBillingLine."NS_Stored Material Retention %";
                                        //SalesLine."NS_Retention Amount" := ProgressBillingLine."NS_Work Retention Amount" - PreviousRetention + ProgressBillingLine."NS_Stored Mat. Retention Amt"; //PRJCTPR-376.NC.1.0 18Jun2024 Block
                                        SalesLine."NS_Retention Amount" := Round((ProgressBillingLine."NS_Work Retention Amount" - PreviousRetention + ProgressBillingLine."NS_Stored Mat. Retention Amt"), GLSetup."Amount Rounding Precision"); //PRJCTPR-376.NC.1.0 18Jun2024
                                        //PE-22.JS.1.0 20FEB2023-Start
                                        if (SalesHeader."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0) then
                                            if NS_Currency.get(SalesHeader."Currency Code") then
                                                SalesLine.VALIDATE("NS_Retention Amount", Round(SalesLine."NS_Retention Amount" * SalesHeader."Currency Factor",
                                                    NS_Currency."Unit-Amount Rounding Precision"));
                                        //PE-22.JS.1.0 20FEB2023-ends  
                                    end else begin
                                        if NS_LastStotrBilling(ProgressBillingLine) - ProgressBillingLine."NS_Stored Materials Amount" = 0 then begin
                                            SalesLine."NS_Retention %" := ProgressBillingLine."NS_Work Retention Percent";
                                            //SalesLine."NS_Retention Amount" := ProgressBillingLine."NS_Work Retention Amount" - PreviousRetention; //PRJCTPR-376.NC.1.0 18Jun2024
                                            SalesLine."NS_Retention Amount" := Round((ProgressBillingLine."NS_Work Retention Amount" - PreviousRetention), GLSetup."Amount Rounding Precision"); //PRJCTPR-376.NC.1.0 18Jun2024
                                        end else begin
                                            SalesLine."NS_Retention %" := 0;
                                            // SalesLine."NS_Retention Amount" := ProgressBillingLine."NS_Work Retention Amount" - PreviousRetention + ProgressBillingLine."NS_Stored Mat. Retention Amt"; //PRJCTPR-376.NC.1.0 18Jun2024 Block
                                            SalesLine."NS_Retention Amount" := Round((ProgressBillingLine."NS_Work Retention Amount" - PreviousRetention + ProgressBillingLine."NS_Stored Mat. Retention Amt"), GLSetup."Amount Rounding Precision"); //PRJCTPR-376.NC.1.0 18Jun2024
                                        end;
                                    end;
                                end else begin
                                    if ProgressBillingLine."NS_Stored Mat. Retention Amt" <> 0 then begin
                                        SalesLine."NS_Retention %" := ProgressBillingLine."NS_Stored Material Retention %";
                                        if NS_LastStotrBilling(ProgressBillingLine) < ProgressBillingLine."NS_Stored Materials Amount" then
                                            //SalesLine."NS_Retention Amount" := ProgressBillingLine."NS_Stored Mat. Retention Amt" - NS_LastStotrRetentionAmt(ProgressBillingLine) //PRJCTPR-376.NC.1.0 18Jun2024 Block
                                            SalesLine."NS_Retention Amount" := Round((ProgressBillingLine."NS_Stored Mat. Retention Amt" - NS_LastStotrRetentionAmt(ProgressBillingLine)), GLSetup."Amount Rounding Precision") //PRJCTPR-376.NC.1.0 18Jun2024
                                        else
                                            //SalesLine."NS_Retention Amount" := ProgressBillingLine."NS_Stored Mat. Retention Amt"; //PRJCTPR-376.NC.1.0 18Jun2024 Block
                                            SalesLine."NS_Retention Amount" := Round((ProgressBillingLine."NS_Stored Mat. Retention Amt"), GLSetup."Amount Rounding Precision"); //PRJCTPR-376.NC.1.0 18Jun2024
                                    end else begin
                                        SalesLine."NS_Retention %" := ProgressBillingLine."NS_Work Retention Percent";
                                        //SalesLine."NS_Retention Amount" := ProgressBillingLine."NS_Work Retention Amount" - PreviousRetention; //PRJCTPR-376.NC.1.0 18Jun2024 Block
                                        SalesLine."NS_Retention Amount" := Round((ProgressBillingLine."NS_Work Retention Amount" - PreviousRetention), GLSetup."Amount Rounding Precision"); //PRJCTPR-376.NC.1.0 18Jun2024
                                        if ((ProgressBillingLine."NS_Work Retention Amount" = 0) AND (ProgressBillingLine."NS_Stored Mat. Retention Amt" = 0) AND (ProgressBillingLine."NS_Work Retention Percent" = 0) AND (ProgressBillingLine."NS_Stored Material Retention %" = 0)) then
                                            SalesLine."NS_Retention Amount" := 0;
                                    end;
                                end;
                                if PreviousStoreAmt > 0 then Begin
                                    SalesLine."NS_Retention %" := ProgressBillingLine."NS_Work Retention Percent";
                                    //SalesLine."NS_Retention Amount" := ((ProgressBillingLine."NS_Work Retention Amount" - PreviousRetention) - (NS_LastStotrRetentionAmt(ProgressBillingLine) - ProgressBillingLine."NS_Stored Mat. Retention Amt")); //PRJCTPR-376.NC.1.0 18Jun2024 Block
                                    SalesLine."NS_Retention Amount" := Round(((ProgressBillingLine."NS_Work Retention Amount" - PreviousRetention) - (NS_LastStotrRetentionAmt(ProgressBillingLine) - ProgressBillingLine."NS_Stored Mat. Retention Amt")), GLSetup."Amount Rounding Precision"); //PRJCTPR-376.NC.1.0 18Jun2024
                                    ChangeStoreMarAmt := True;
                                end;
                            end;
                            //PRJ-1624.NK.1.0 23Sep2022 End

                            //PRJ-1648.PS.1.0 8Dec2022 Start
                            if ((BillingHeader."NS_Multiple Retention on Lines" = true) and (BillingHeader."NS_R_Reduction & Invoicing" = true)) then begin
                                PreviousRetention := NS_LastProgrBillRetLine(BillingHeader, ProgressBillingLine);
                                if ((ProgressBillingLine."NS_Stored Mat. Retention Amt" <> 0) and (ProgressBillingLine."NS_Work Retention Percent" <> 0)) then begin
                                    if ProgressBillingLine."NS_Work Ret Amt Reduction" - PreviousRetention = 0 then
                                        SalesLine."NS_Retention %" := ProgressBillingLine."NS_Stored Material Retention %"
                                    else
                                        SalesLine."NS_Retention %" := 0;
                                    //SalesLine."NS_Retention Amount" := ProgressBillingLine."NS_Work Ret Amt Reduction" - PreviousRetention + ProgressBillingLine."NS_Stored Mat. Retention Amt"; //PRJCTPR-376.NC.1.0 18Jun2024
                                    SalesLine."NS_Retention Amount" := Round((ProgressBillingLine."NS_Work Ret Amt Reduction" - PreviousRetention + ProgressBillingLine."NS_Stored Mat. Retention Amt"), GLSetup."Amount Rounding Precision"); //PRJCTPR-376.NC.1.0 18Jun2024
                                    //PE-22.JS.1.0 20FEB2023-Start
                                    if (SalesHeader."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0) then
                                        if NS_Currency.get(SalesHeader."Currency Code") then
                                            SalesLine.VALIDATE("NS_Retention Amount", Round(SalesLine."NS_Retention Amount" * SalesHeader."Currency Factor",
                                                NS_Currency."Unit-Amount Rounding Precision"));
                                    //PE-22.JS.1.0 20FEB2023-ends  
                                end else begin
                                    if ProgressBillingLine."NS_Stored Mat. Retention Amt" <> 0 then begin
                                        SalesLine."NS_Retention %" := ProgressBillingLine."NS_Stored Material Retention %";
                                        //SalesLine."NS_Retention Amount" := ProgressBillingLine."NS_Stored Mat. Retention Amt" - ProgressBillingLine."NS_Eff Store Work Ret Red";//PE-15.PS.1.0 9Jan23 //PRJCTPR-376.NC.1.0 18Jun2024 Block
                                        SalesLine."NS_Retention Amount" := Round((ProgressBillingLine."NS_Stored Mat. Retention Amt" - ProgressBillingLine."NS_Eff Store Work Ret Red"), GLSetup."Amount Rounding Precision"); //PRJCTPR-376.NC.1.0 18Jun2024
                                        //PE-22.JS.1.0 20FEB2023-Start 
                                        if (SalesHeader."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0) then
                                            if NS_Currency.get(SalesHeader."Currency Code") then
                                                SalesLine.VALIDATE("NS_Retention Amount", Round(SalesLine."NS_Retention Amount" * SalesHeader."Currency Factor",
                                                    NS_Currency."Unit-Amount Rounding Precision"));
                                        //PE-22.JS.1.0 20FEB2023-ends  
                                    end else begin
                                        SalesLine."NS_Retention %" := ProgressBillingLine."NS_Work Retention Percent";
                                        //SalesLine."NS_Retention Amount" := ProgressBillingLine."NS_Work Ret Amt Reduction" - PreviousRetention; //PRJCTPR-376.NC.1.0 18Jun2024 Block
                                        SalesLine."NS_Retention Amount" := Round((ProgressBillingLine."NS_Work Ret Amt Reduction" - PreviousRetention), GLSetup."Amount Rounding Precision"); //PRJCTPR-376.NC.1.0 18Jun2024
                                        //PE-22.JS.1.0 20FEB2023-Start
                                        if (SalesHeader."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0) then
                                            if NS_Currency.get(SalesHeader."Currency Code") then
                                                SalesLine.VALIDATE("NS_Retention Amount", Round(SalesLine."NS_Retention Amount" * SalesHeader."Currency Factor",
                                                    NS_Currency."Unit-Amount Rounding Precision"));
                                        //PE-22.JS.1.0 20FEB2023-ends 
                                    end;
                                end;
                            end;
                            //PRJ-1648.PS.1.0 8Dec2022 End
                            SalesLine."NS_Job Revenue Category" := "NS_Revenue Category";
                            //PRJCTPR-199.JS.1.0 12DEC2023 - Start 
                            //SalesLine."Job Task No." := BillingHeader.NS_APOToJobTaskNo(ProgressBillingLine."NS_Activity Code", ProgressBillingLine."NS_Process Code", ProgressBillingLine."NS_Operation Code", ProgressBillingLine."NS_Section Code");//PRJ-688.AM.1.0
                            SalesLine.validate("Job Task No.", BillingHeader.NS_APOToJobTaskNo(ProgressBillingLine."NS_Activity Code", ProgressBillingLine."NS_Process Code", ProgressBillingLine."NS_Operation Code", ProgressBillingLine."NS_Section Code"));
                            //PRJCTPR-199.JS.1.0 12DEC2023 - end
                            //CTSI-42.AS.1.0 21MAY2020 - start
                            //if SalesLine."Document Type" = SalesLine."Document Type"::Invoice then
                            SalesLine."NS_Revenue Cat Description" := "NS_Revenue Cat Description";//PRJ-702.AS.1.0
                            //CTSI-42.AS.1.0 21MAY2020 - end
                            SalesLine.VALIDATE("Tax Liable", Job."NS_Tax Liable");
                            SalesLine.VALIDATE("Tax Area Code", Job."NS_Tax Area Code");
                            // SalesLine.VALIDATE("Tax Group Code", Job."NS_Tax Group Code"); //PRJCTPR-298.JS.1.0
                            SalesLine.VALIDATE("Tax Group Code", Job."NS_Tax Group Code New");  //PRJCTPR-298.JS.1.0
                            SalesLine."NS_Retention Applies" := false;
                            //SalesLine."Dimension Set ID" := JobDimensionNo;//PRJ-180.SK.1.1 Commented
                            SalesLine."NS_Segment Code" := "NS_Segment Code";//TM-10.AM.2.0
                            CalcFields("NS_Segment Name");//TM-32.AM.1.0
                            SalesLine."NS_Segment Name" := ProgressBillingLine."NS_Segment Name";//TM-32.AM.1.0
                                                                                                 //PRJ-1308.GK.1.0 05May2022 start comment
                                                                                                 // SalesLine."Shortcut Dimension 1 Code" := Job."Global Dimension 1 Code";   //PRJ-913.JS.1.0�14Sep2021 Line added
                                                                                                 // SalesLine."Shortcut Dimension 2 Code" := Job."Global Dimension 2 Code";   //PRJ-913.JS.1.0�14Sep2021 Line added                                                        
                                                                                                 // SalesLine."Dimension Set ID" := BillingHeader.NS_GetDimensionNoFromJob(BillingHeader."NS_Job No."); //PRJ-180.SK.1.1 Added
                                                                                                 //PRJ-1308.GK.1.0 05May2022 end
                            SalesLine."NS_From Prog. Billing Base Amount" := "NS_Base Amount";//CTSI-150.AS.1.0 28Sept2020
                            SalesLine."NS_Retention Amount" := 0; //PE-15.PS.1.0 17Jan2023
                            SalesLine."NS_Retention %" := 0;  //PE-15.PS.1.0 17Jan2023
                                                              //PRJ-1308.GK.1.0 05May2022 start Comment
                                                              // //PRJ-913.JS.1.0�14Sep2021-Start                        
                                                              // if JobTask1.GET(SalesLine."Job No.", SalesLine."Job Task No.") then
                                                              //     IF ((JobTask1."Global Dimension 1 Code" <> '') and (JobTask1."Global Dimension 2 Code" <> '')) then begin
                                                              //         SalesLine."Shortcut Dimension 1 Code" := JobTask1."Global Dimension 1 Code";
                                                              //         SalesLine."Shortcut Dimension 2 Code" := JobTask1."Global Dimension 2 Code";
                                                              //         SalesLine."Dimension Set ID" := BillingHeader.NS_GetDimensionNoFromJobTask(SalesLine."Job No.", SalesLine."Job Task No.");
                                                              //     end;
                                                              // //PRJ-913.JS.1.0�13Sep2021-end
                                                              //PRJ-1308.GK.1.0 05May2022 end
                                                              //PRJ-1308.GK.1.0 05May2022 start comment
                                                              // //PRJ-999.JS.1.0 12Nov2021 Start
                                                              //PRJCTPR-199.JS.1.0 12DEC2023 Start belwo code commented
                                                              // SalesLine."Shortcut Dimension 1 Code" := ProgressBillingLine."NS_Shortcut Dimension 1 Code";
                                                              // SalesLine."Shortcut Dimension 2 Code" := ProgressBillingLine."NS_Shortcut Dimension 2 Code";
                                                              // SalesLine."Dimension Set ID" := ProgressBillingLine."NS_Dimension Set ID";
                                                              // //PRJ-999.JS.1.0 12Nov2021 end
                                                              //PRJCTPR-199.JS.1.0 12DEC2023 end belwo code commented
                                                              //PRJ-1308.GK.1.0 05May2022 end  
                                                              //PRJCTPR-320.NC.1.0 16Feb2024 Start
                            if NS_JobsSetup.Get() then;
                            if NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" = NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing" then begin
                                if BillingHeader."NS_Multiple Retention on Lines" then begin
                                    SalesLine."VAT Base Amount" := SalesLine.Amount - SalesLine."NS_Retention Amount";
                                    SalesLine."Amount Including VAT" :=
                                                      SalesLine.Amount - SalesLine."NS_Retention Amount" +
                                                      SalesTaxCalculate.CalculateTax(
                                                        SalesLine."Tax Area Code", SalesLine."Tax Group Code", SalesLine."Tax Liable", SalesHeader."Posting Date",
                                                        SalesLine."VAT Base Amount", SalesLine."Quantity (Base)", SalesHeader."Currency Factor");
                                end;
                            end;
                            //PRJCTPR-320.NC.1.0 16Feb2024 End
                            // >> Upgrade
                            OnBeforeInsertNS_NormalDocumentLines(SalesLine, ProgressBillingLine);
                            // << Upgrade
                            if SalesLine.Amount <> 0 then begin
                                //SalesLine.INSERT;  //PRJ-876.JS.1.0 24Aug2021 commented
                                //PRJ-1465.GK.1.0 20June2022 start
                                NS_OnBeforeModifyRetentionDocumentLineMakeReceivablesDocument(SalesLine, ProgressBillingLine);
                                //PRJ-1465.GK.1.0 20June2022 end
                                SalesLine.Modify();    //PRJ-876.JS.1.0 24Aug2021 line added
                                //LineNumber := LineNumber + 10000;//PRJ-1031.AS.1.0 COMMENT
                            end;
                            LineNumber := LineNumber + 10000;//PRJ-1031.AS.1.0 CHANGED CODE LOCATION
                        end else
                            ERROR(Text0002);
                    //   end; //PRJ-1519.NK.1.0 24Aug2022
                    until NEXT = 0;
                //PRJ-1624.NK.1.0 20Oct2022 Start
                if BillingHeader."NS_Multiple Retention on Lines" then begin
                    if ChangeStoreMarAmt then begin
                        RetentionAmt := 0;
                        RecSalesLine.Reset();
                        RecSalesLine.Setrange("Document Type", SalesHeader."Document Type");
                        RecSalesLine.Setrange("Document No.", SalesHeader."No.");
                        if RecSalesLine.FindSet() then
                            repeat
                                RetentionAmt += RecSalesLine."NS_Retention Amount";
                            Until RecSalesLine.Next() = 0;
                        RetentionAmt := Round(RetentionAmt, 0.01);
                        RecSalesHead.Reset();
                        RecSalesHead.Setrange("Document Type", SalesHeader."Document Type");
                        RecSalesHead.Setrange("No.", SalesHeader."No.");
                        if RecSalesHead.FindSet() then Begin
                            RecSalesHead.VALIDATE("NS_Retention Amount", RetentionAmt);
                            RecSalesHead.Modify();
                        End;
                    end;
                End;
                //PRJ-1624.NK.1.0 20Oct2022 End
            end;
        end;
        //PRJ-1648.PS.1.0 10OCT2022 - Start

        NS_RetentionMultipleDocs(BillingHeader);

        //PRJ-1648.PS.1.0 10OCT2022 - End
    end;

    procedure NS_RetentionDocumentValue(BillingHeader: Record "NS_Progress Billing Header"): Decimal;
    var
        ProgressBillingLine: Record "NS_Progress Billing Line";
        WorkPreviousBilling: Decimal;
        PreviousStoredMaterial: Decimal;
        PreviousRetention: Decimal;
        Value09: Decimal;
        Value11: Decimal;
        Value13: Decimal;
        Value14: Decimal;
        Value16: Decimal;
        Value17: Decimal;
    begin
        //This routine returns the value of a Retention document.
        //
        //This is done by performing all the calculations necessary on a progress billing document for Value17
        //Value17 = Value15 - Value16
        //        = {Value09 - Value14} - {Value16}
        //        = {Value09 - [Value11 + Value13]} - {Value16}
        //Value09 = WorkPreviousBilling + "Requisition Total"
        //Value11 = ROUND((WorkPreviousBilling + "Line Work Amount") * ("Work Retention Percent" / 100),0.01)
        //Value13 = ROUND("Line Material Amount" * ("Material Retention Percent" / 100),0.01)
        //Value16 = WorkPreviousBilling - PreviousRetention + PreviousStoredMaterial

        with BillingHeader do begin
            Value17 := 0;
            WorkPreviousBilling := ProgressBillingLine.NS_TotalWorkPreviousBilling(BillingHeader);
            PreviousStoredMaterial := NS_LastProgressBillStoredMat(BillingHeader);
            PreviousRetention := NS_PreviousProgressBillRetention(BillingHeader, '', '', '', '', '', '');//PRJ-688.AM.1.0
            CALCFIELDS("NS_Line Work Amount", "NS_Line Material Amount", "NS_Requisition Total");
            Value09 := WorkPreviousBilling + "NS_Requisition Total";

            Value11 := 0;
            if "NS_Work Retention Percent" <> 0 then
                Value11 := ROUND((WorkPreviousBilling + "NS_Line Work Amount") * ("NS_Work Retention Percent" / 100), 0.01);

            Value13 := 0;
            if "NS_Material Retention Percent" <> 0 then
                Value13 := ROUND("NS_Line Material Amount" * ("NS_Material Retention Percent" / 100), 0.01);

            if Value11 + Value13 <> 0 then
                Value14 := Value11 + Value13
            else begin
                ProgressBillingLine.RESET;
                ProgressBillingLine.SETRANGE("NS_Progress Billing No.", "NS_No.");
                ProgressBillingLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
                ProgressBillingLine.SETRANGE("NS_Version No.", "NS_Version No.");
                if ProgressBillingLine.FINDSET then
                    repeat
                        Value14 := Value14 + ProgressBillingLine."NS_Work Retention Amount" + ProgressBillingLine."NS_Material Retention Amount";
                    until ProgressBillingLine.NEXT = 0;
            end;

            Value16 := WorkPreviousBilling - PreviousRetention + PreviousStoredMaterial;
            Value17 := Value09 - Value14 - Value16;

            exit(Value17);
        end;
    end;


    [IntegrationEvent(false, false)]
    local procedure OnCheckPPLicenseExpire()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertSalesLineFromProgressBillLine(Var SalesLine: Record "Sales Line"; Var ProgressBillingLine: Record "NS_Progress Billing Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure NS_OnAfterDrawfunctionsExecutedRetDocLines(var PrgbillingHdr: record "NS_Progress Billing Header")//PRJ-989.AS.1.0 18OCT2021 AddedIntegration Event
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure NS_OnBeforeSalesLineNovalidateinNormalDocLinesofProgBill(var SalLine: Record "Sales Line"; var PrgBillLine: Record "NS_Progress Billing Line")//PRJ-989.AS.1.0 18OCT2021 AddedIntegration Event //PRJ-1020.AS.1.0 Added
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure NS_AfterSalesLineUnitpriceassgmtinNormDocLinefProgBill(var SalLine: Record "Sales Line")//PRJ-989.AS.1.0 18OCT2021 AddedIntegration Event
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure NS_OnDrawNoskip(var BillHdr: Record "NS_Progress Billing Header"; var SalHdrRec: Record "Sales Header")//PRJ-989.AS.1.0 18OCT2021 AddedIntegration Event
    begin
    end;

    //PRJ-1030.AS.1.0 START Added integration event
    [IntegrationEvent(false, false)]
    local procedure NS_OnBeforeInsertCustomerNoMakeReceivablesDocument(var Salhder: Record "Sales Header"; var ReqsAm: Decimal; var BilHdr: Record "NS_Progress Billing Header")
    begin
    end;
    //PRJ-1030.AS.1.0 END
    // >> Upgrade
    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertNS_NormalDocumentLines(var SalesLine: Record "Sales Line"; var ProgressBillingLine: Record "NS_Progress Billing Line")
    begin
    end;
    // << Upgrade
    //PRJ-1465.GK.1.0 20June2022 start
    [IntegrationEvent(false, false)]
    local procedure NS_OnBeforeInsertNormalDocumentLineMakeReceivablesDocument(var SalesLine: Record "Sales Line"; ProgressBillingLine: Record "NS_Progress Billing Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure NS_OnBeforeModifyNormalDocumentLineMakeReceivablesDocument(var SalesLine: Record "Sales Line"; ProgressBillingLine: Record "NS_Progress Billing Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure NS_OnAfterInsertRetentionDocumentLineMakeReceivablesDocument(var SalesLine: Record "Sales Line"; ProgressBillingLine: Record "NS_Progress Billing Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure NS_OnBeforeInsertRetentionDocumentLineMakeReceivablesDocument(var SalesLine: Record "Sales Line"; ProgressBillingLine: Record "NS_Progress Billing Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure NS_OnBeforeModifyRetentionDocumentLineMakeReceivablesDocument(var SalesLine: Record "Sales Line"; ProgressBillingLine: Record "NS_Progress Billing Line")
    begin
    end;
    //PRJ-1465.GK.1.0 20June2022 end
    //PRJ-1414.AS.1.0 START Creaed event
    [IntegrationEvent(false, false)]
    local procedure NS_OnBeforeInsertSalesHeaderinPB(var Salhder: Record "Sales Header"; var BilHdr: Record "NS_Progress Billing Header"; var Job: Record Job)
    begin
    end;

    //SSCM-8.PS2048.22052024  //PRJCTPR-371.JS.1.0 22MAY2024
    [IntegrationEvent(false, false)]
    local procedure NS_OnBeforeModifySalesHeaderAfterDimension(var Salhder: Record "Sales Header"; var BilHdr: Record "NS_Progress Billing Header"; var Job: Record Job)
    begin
    end;
    //SSCM-8.PS2048.22052024  //PRJCTPR-371.JS.1.0 22MAY2024

    //PRJ-1414.AS.1.0 END
    //PE-95.NC.1.0 19May2023 Start
    [IntegrationEvent(false, false)]
    local procedure NS_OnAfterInsertSalesLineFromProgressBillLine(Var SalesLine: Record "Sales Line"; Var ProgressBillingLine: Record "NS_Progress Billing Line")
    begin
    end;
    //PE-95.NC.1.0 19May2023 End

    //PRJ-1289.JS.1.0 29APR2022 -Start
    /// <summary>
    /// NS_RetentionDocumentValueAIAG702Values.
    /// </summary>
    /// <param name="BillingHeader">Record "NS_Progress Billing Header".</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure NS_RetentionDocumentValueAIAG702Values(BillingHeader: Record "NS_Progress Billing Header"): Decimal;
    var
        ProgressBillingLine: Record "NS_Progress Billing Line";
        ProgressBillligHeader: Record "NS_Progress Billing Header";
        WorkPreviousBilling: Decimal;
        Value01: Decimal;
        Value02: Decimal;
        Value03: Decimal;
        Value04: Decimal;
        Value05a1: Decimal;
        Value05a2: Decimal;
        Value05b1: Decimal;
        Value05b2: Decimal;
        Value05c: Decimal;
        Value06: Decimal;
        Value07: Decimal;
        Value08: Decimal;
        PreviousAdditions: Decimal;
        PreviousDeductions: Decimal;
        CurrentAdditions: Decimal;
        CurrentDeductions: Decimal;
        PreviousReqPeriodToDate: Date;
        NSLineWorkRetnAmount: Decimal;
        NSDiffrenceAmount: Decimal;
        PreviousStoredMaterial: Decimal;
        PreviousEarning: Decimal;
    begin
        PreviousAdditions := 0;
        PreviousDeductions := 0;
        CurrentAdditions := 0;
        CurrentDeductions := 0;
        PreviousReqPeriodToDate := 0D;
        WorkPreviousBilling := 0;
        PreviousStoredMaterial := 0;
        PreviousEarning := 0;
        Value01 := 0;
        Value02 := 0;
        Value03 := 0;
        Value04 := 0;
        Value05a1 := 0;
        Value05b1 := 0;
        Value05c := 0;
        Value06 := 0;
        Value07 := 0;
        Value08 := 0;

        //Error('...%1.....%2......%3', BillingHeader."NS_No.", BillingHeader."NS_Requisition No.", BillingHeader."NS_Version No.");
        BillingHeader.CALCFIELDS("NS_Line Work Amount", "NS_Line Material Amount", "NS_Requisition Total");

        WorkPreviousBilling := ProgressBillingLine.NS_TotalWorkPreviousBilling(BillingHeader);

        PreviousStoredMaterial := ProgressBillligHeader.NS_LastProgressBillStoredMat(BillingHeader);
        PreviousEarning := ProgressBillligHeader.NS_ProgressBillPreviousTotalEarn(BillingHeader);
        //PreviousRetention := ProgressBillligHeader.NS_PreviousProgressBillRetention(BillingHeader, '', '', '', '', '', '');

        PreviousReqPeriodToDate := ProgressBillligHeader.NS_GetPeriodFromDate(BillingHeader."NS_No.", BillingHeader."NS_Period To");
        ProgressBillligHeader.NS_GetChangeOrderValues(BillingHeader."NS_Job No.",
                     PreviousReqPeriodToDate, BillingHeader."NS_Period To",
                     PreviousAdditions, PreviousDeductions,
                     CurrentAdditions, CurrentDeductions);

        Value01 := ProgressBillligHeader.NS_ProgressBillBaseAmount(BillingHeader);

        Value02 := PreviousAdditions - PreviousDeductions + CurrentAdditions - CurrentDeductions;
        Value03 := Value01 + Value02;
        Value04 := WorkPreviousBilling + BillingHeader."NS_Requisition Total";
        //Error('Value04...%1...', WorkPreviousBilling + BillingHeader."NS_Requisition Total");
        Value05a1 := BillingHeader."NS_Work Retention Percent";

        //////////////////////////////////////////////////////////////////////        
        if BillingHeader."NS_Work Retention Percent" <> 0 then begin
            NSLineWorkRetnAmount := 0;
            NSDiffrenceAmount := 0;
            Value05a2 := ROUND((WorkPreviousBilling + BillingHeader."NS_Line Work Amount") * (BillingHeader."NS_Work Retention Percent" / 100), 0.01);
            ProgressBillingLine.RESET();
            ProgressBillingLine.SETRANGE("NS_Progress Billing No.", BillingHeader."NS_No.");
            ProgressBillingLine.SETRANGE("NS_Requisition No.", BillingHeader."NS_Requisition No.");
            ProgressBillingLine.SETRANGE("NS_Version No.", BillingHeader."NS_Version No.");
            if ProgressBillingLine.FINDSET() then
                repeat
                    NSLineWorkRetnAmount := NSLineWorkRetnAmount + ProgressBillingLine."NS_Work Retention Amount";
                until ProgressBillingLine.NEXT() = 0;

            NSDiffrenceAmount := NSLineWorkRetnAmount - Value05a2;
            if NSDiffrenceAmount <> 0 then
                Value05a2 := Value05a2 + NSDiffrenceAmount;
        end else
            Value05a2 := 0;

        //Error('Value05a2...%1', Value05a2);  --OK

        Value05b1 := BillingHeader."NS_Material Retention Percent";
        if BillingHeader."NS_Material Retention Percent" <> 0 then
            Value05b2 := ROUND(BillingHeader."NS_Line Material Amount" * (BillingHeader."NS_Material Retention Percent" / 100), 0.01)
        else
            Value05b2 := 0;

        if Value05a2 + Value05b2 <> 0 then
            Value05c := Value05a2 + Value05b2
        else begin
            ProgressBillingLine.RESET();
            ProgressBillingLine.SETRANGE("NS_Progress Billing No.", BillingHeader."NS_No.");
            ProgressBillingLine.SETRANGE("NS_Requisition No.", BillingHeader."NS_Requisition No.");
            ProgressBillingLine.SETRANGE("NS_Version No.", BillingHeader."NS_Version No.");
            if ProgressBillingLine.FINDSET() then
                repeat
                    Value05c := Value05c + ProgressBillingLine."NS_Work Retention Amount" + ProgressBillingLine."NS_Material Retention Amount";
                until ProgressBillingLine.NEXT() = 0;
        end;

        //Error('Value05c...%1', Value05c);  //ok
        ////////////////////////////////////////////////////////////////////////////////
        Value06 := Value04 - Value05c;
        //Error('Value06...%1...', Value04 - Value05c);
        Value07 := ProgressBillligHeader.NS_ProgressBillPreviousInvoiceNew(BillingHeader);
        Value08 := Value06 - Value07;
        //Error('Value08...%1....', Value08);

        exit(Value08);
        //PRJ-1289.JS.1.0 29APR2022 - end
    end;
    //PRJ-1519.NK.1.0 17Aug2022 Start
    procedure NS_StoreMarRetentionAmt(BillingHeader: Record "NS_Progress Billing Header"): Decimal;
    var
        ProgressBillingLine: Record "NS_Progress Billing Line";
        StoreMatAmt: Decimal;
    begin
        StoreMatAmt := 0;
        ProgressBillingLine.RESET();
        ProgressBillingLine.SETRANGE("NS_Progress Billing No.", BillingHeader."NS_No.");
        ProgressBillingLine.SETRANGE("NS_Requisition No.", BillingHeader."NS_Requisition No.");
        ProgressBillingLine.SETRANGE("NS_Version No.", BillingHeader."NS_Version No.");
        if ProgressBillingLine.FINDSET() then
            repeat
                StoreMatAmt += (ProgressBillingLine."NS_Work Amount" + ProgressBillingLine."NS_Stored Materials Amount" + ProgressBillingLine.NS_LastTotal(ProgressBillingLine) -
                                              BillingHeader.NS_LastProgressBillTCS(ProgressBillingLine));
            until ProgressBillingLine.NEXT() = 0;
        exit(StoreMatAmt)
    end;

    procedure NS_TotalStoreMarRetentionAmt(BillingHeader: Record "NS_Progress Billing Header"): Decimal;
    var
        ProgressBillingLine: Record "NS_Progress Billing Line";
        StoreMatAmt: Decimal;
    begin
        StoreMatAmt := 0;
        ProgressBillingLine.RESET();
        ProgressBillingLine.SETRANGE("NS_Progress Billing No.", BillingHeader."NS_No.");
        ProgressBillingLine.SETRANGE("NS_Requisition No.", BillingHeader."NS_Requisition No.");
        ProgressBillingLine.SETRANGE("NS_Version No.", BillingHeader."NS_Version No.");
        ProgressBillingLine.SetFilter("NS_Stored Mat. Retention Amt", '<>%1', 0);
        if ProgressBillingLine.FINDSET() then
            repeat
                //PRJ-1624.NK.1.0 07Nov2022 Start
                if ProgressBillingLine."NS_Stored Materials Amount" <> NS_LastStotrBilling(ProgressBillingLine) then begin
                    if NS_LastStotrBilling(ProgressBillingLine) < ProgressBillingLine."NS_Stored Materials Amount" then
                        StoreMatAmt += ProgressBillingLine."NS_Stored Mat. Retention Amt" - NS_LastStotrRetentionAmt(ProgressBillingLine)
                    else
                        StoreMatAmt += ProgressBillingLine."NS_Stored Mat. Retention Amt";
                end else begin
                    StoreMatAmt += ProgressBillingLine."NS_Stored Mat. Retention Amt"; //PE-15.PS.1.0 03Feb2023
                end;
            //PRJ-1624.NK.1.0 07Nov2022 End
            until ProgressBillingLine.NEXT() = 0;
        exit(StoreMatAmt)
    end;


    //PRJ-1648 PS.1.0 19Dec2022 Start
    procedure NS_TotalStoreMarRetentionAmtforLine(BillingHeader: Record "NS_Progress Billing Header"): Decimal;
    var
        ProgressBillingLine: Record "NS_Progress Billing Line";
        StoreMatAmt: Decimal;
    begin
        StoreMatAmt := 0;
        ProgressBillingLine.RESET();
        ProgressBillingLine.SETRANGE("NS_Progress Billing No.", BillingHeader."NS_No.");
        ProgressBillingLine.SETRANGE("NS_Requisition No.", BillingHeader."NS_Requisition No.");
        ProgressBillingLine.SETRANGE("NS_Version No.", BillingHeader."NS_Version No.");
        ProgressBillingLine.SetFilter("NS_Stored Mat. Retention Amt", '<>%1', 0);
        if ProgressBillingLine.FINDSET() then
            repeat
                StoreMatAmt += ProgressBillingLine."NS_Stored Mat. Retention Amt" - ProgressBillingLine."NS_Eff Store Work Ret Red"; //PE-15.PS.1.0 09Jan2023
            until ProgressBillingLine.NEXT() = 0;
        exit(StoreMatAmt)
    end;

    //PRJ-1648 PS.1.0 19Dec2022 End

    procedure NS_RetentionStoreDocLine(BillingHeader: Record "NS_Progress Billing Header"; SalesHeader: Record "Sales Header"; Job: Record Job);
    var
        ProgressBillingLine: Record "NS_Progress Billing Line";
        SalesLine: Record "Sales Line";
        SaleHead: Record "Sales Header";
        SalesSetup: Record "Sales & Receivables Setup";
        RevCatTbl: Record "NS_Job Revenue Category";
        JobsSetup: Record "Jobs Setup";
        NSCurrency: Record Currency;   //PE-22.JS.1.0 17FEB2023
        JobTask1: Record "Job Task";
        NS_JobsSetup: Record "Jobs Setup";
        LineNumber: Integer;
        Text0001: Label '"Retention for Job "';
        Text0002: Label 'Retention percentage changes cannot be on the same document with regular billings.';
        JobDimensionNo: Integer;
        Licdate: date;
        NoOfDays: Text;
        EnvInfoCU: Codeunit "Environment Information";
    begin
        //PRJ-1686.GK.1.0 22Nov2022 start
        if EnvInfoCU.IsSaaS() then
            OnCheckPPLicenseExpire();
        //PRJ-1686.GK.1.0 22Nov2022 end


        LineNumber := 10000;
        JobsSetup.GET();
        SalesSetup.GET();
        if not SalesSetup."NS_Sales Retention Inactive" then begin
            ProgressBillingLine.RESET();
            ProgressBillingLine.SETRANGE("NS_Progress Billing No.", BillingHeader."NS_No.");
            ProgressBillingLine.SETRANGE("NS_Requisition No.", BillingHeader."NS_Requisition No.");
            ProgressBillingLine.SETRANGE("NS_Version No.", BillingHeader."NS_Version No.");
            if ProgressBillingLine.FINDSET() then
                repeat
                    SalesLine.INIT();
                    SalesLine."Document Type" := SalesHeader."Document Type";
                    SalesLine."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
                    SalesLine."Document No." := SalesHeader."No.";
                    SalesLine."Line No." := LineNumber;
                    SalesLine.Type := SalesLine.Type::NS_Ledger;
                    SalesLine.VALIDATE(Type);
                    SalesLine."No." := JobsSetup."NS_Retention Receivable Ledger";
                    SalesLine.VALIDATE("No.");
                    NS_OnBeforeInsertRetentionDocumentLineMakeReceivablesDocument(SalesLine, ProgressBillingLine);
                    SalesLine.Insert();
                    NS_OnAfterInsertSalesLineFromProgressBillLine(SalesLine, ProgressBillingLine); //PE-95.NC.1.0 19May2023
                    if job."NS_Gen. Prod. Posting Group New" <> '' then
                        SalesLine."Gen. Prod. Posting Group" := Job."NS_Gen. Prod. Posting Group New"
                    else
                        //SalesLine."Gen. Prod. Posting Group" := JobsSetup."NS_Prog. Bill Gen. ProdPostGr.";//PRJ-1684.AS.1.0 Commented
                    SalesLine."Gen. Prod. Posting Group" := JobsSetup."NS_ProgBillGenProdPostGr New";//PRJ-1684.AS.1.0 Add
                    SalesLine.Description := Text0001 + ProgressBillingLine."NS_Job No.";
                    SalesLine."Job No." := ProgressBillingLine."NS_Job No.";
                    SalesLine.Quantity := 1;
                    SalesLine.VALIDATE(Quantity);
                    //PRJ-1519.NK.1.0 15Sep2022 Start
                    if ProgressBillingLine.NS_LastStotrBilling(ProgressBillingLine) = ProgressBillingLine."NS_Stored Materials Amount" then
                        SalesLine."Unit Price" := Round(ProgressBillingLine."NS_Billed Work Retention Amt" + ProgressBillingLine."NS_Billed MaterialRetentionAmt", 0.01)  //PE-15.PS.1.0 16Jan2023
                    else
                        //PRJ-1519.NK.1.0 15Sep2022 End
                        SalesLine."Unit Price" := Round(ProgressBillingLine."NS_Billed Work Retention Amt" + ProgressBillingLine."NS_Billed MaterialRetentionAmt" + ProgressBillingLine."NS_Stored Mat. Retention Amt", 0.01);//PE-15.PS.1.0 16Jan2023

                    if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then
                        SalesLine."Unit Price" := -SalesLine."Unit Price";
                    SalesLine.Amount := Round(SalesLine."Unit Price", 0.01);  //PE-15.PS.1.0 16Jan2023
                    SalesLine.VALIDATE("Unit Price");
                    SalesLine.VALIDATE(Amount);
                    //PE-22.JS.1.0 17FEB2023-Start
                    if (SalesHeader."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0) then begin
                        if NSCurrency.get(SalesHeader."Currency Code") then begin
                            SalesLine.VALIDATE("Unit Price", Round(SalesLine."Unit Price" * SalesHeader."Currency Factor",
                            NSCurrency."Unit-Amount Rounding Precision"));
                        end;
                    end;
                    //PE-22.JS.1.0 17FEB2023-end
                    SalesLine."NS_Job Revenue Category" := ProgressBillingLine."NS_Revenue Category";
                    //PRJCTPR-199.JS.1.0 12DEC2023 Start
                    // SalesLine."Job Task No." := BillingHeader.NS_APOToJobTaskNo(ProgressBillingLine."NS_Activity Code", ProgressBillingLine."NS_Process Code", ProgressBillingLine."NS_Operation Code", ProgressBillingLine."NS_Section Code");
                    SalesLine.validate("Job Task No.", BillingHeader.NS_APOToJobTaskNo(ProgressBillingLine."NS_Activity Code", ProgressBillingLine."NS_Process Code", ProgressBillingLine."NS_Operation Code", ProgressBillingLine."NS_Section Code"));
                    //PRJCTPR-199.JS.1.0 12DEC2023 end
                    SalesLine."NS_Revenue Cat Description" := ProgressBillingLine."NS_Revenue Cat Description";
                    SalesLine.VALIDATE("Tax Liable", Job."NS_Tax Liable");
                    SalesLine.VALIDATE("Tax Area Code", Job."NS_Tax Area Code");
                    //SalesLine.VALIDATE("Tax Group Code", Job."NS_Tax Group Code"); //PRJCTPR-298.JS.1.0
                    SalesLine.VALIDATE("Tax Group Code", Job."NS_Tax Group Code New"); //PRJCTPR-298.JS.1.0
                    SalesLine."NS_Retention Applies" := false;
                    SalesLine."NS_Segment Code" := ProgressBillingLine."NS_Segment Code";
                    ProgressBillingLine.CalcFields("NS_Segment Name");
                    SalesLine."NS_Segment Name" := ProgressBillingLine."NS_Segment Name";
                    SalesLine."NS_From Prog. Billing Base Amount" := ProgressBillingLine."NS_Base Amount";
                    if SalesLine.Amount <> 0 then begin
                        NS_OnBeforeModifyRetentionDocumentLineMakeReceivablesDocument(SalesLine, ProgressBillingLine);
                        SalesLine.Modify();
                    end;
                    LineNumber := LineNumber + 10000;
                until ProgressBillingLine.NEXT() = 0;
            SaleHead.Reset();
            SaleHead.SetRange("No.", SalesHeader."No.");
            if SaleHead.FindFirst() then begin
                SaleHead."NS_Retention Percent" := 0;
                SaleHead."NS_Retention Document" := true;
                SaleHead.Modify();
            end;
        end;
        NS_RetentionMultipleDocsStore(BillingHeader); //PRJ-1648.PS.1.0 03Jan202023
    end;

    procedure NS_CalcLastStrAmt(BillingHeader: Record "NS_Progress Billing Header"): Boolean;
    var
        ProgressBillingLine: Record "NS_Progress Billing Line";
        ProgBillingHead: Record "NS_Progress Billing Header";
        StoreMatAmt: Decimal;
        LastStoreMatAmt: Decimal;
    begin
        BillingHeader.CalcFields("NS_Requisition Total");
        if BillingHeader."NS_Requisition Total" = 0 then begin
            LastStoreMatAmt := 0;
            ProgBillingHead.Reset();
            ProgBillingHead.SetRange("NS_No.", BillingHeader."NS_No.");
            ProgBillingHead.SETFILTER("NS_Requisition No.", '<%1', BillingHeader."NS_Requisition No.");
            ProgBillingHead.SetRange(NS_Status, ProgBillingHead.NS_Status::Invoiced);
            if ProgBillingHead.FindLast() then begin
                ProgressBillingLine.RESET();
                ProgressBillingLine.SETRANGE("NS_Progress Billing No.", ProgBillingHead."NS_No.");
                ProgressBillingLine.SETRANGE("NS_Requisition No.", ProgBillingHead."NS_Requisition No.");
                ProgressBillingLine.SETRANGE("NS_Version No.", ProgBillingHead."NS_Version No.");
                if ProgressBillingLine.FINDSET() then
                    repeat
                        LastStoreMatAmt += ProgressBillingLine."NS_Stored Materials Amount";
                    until ProgressBillingLine.NEXT() = 0;
            end;
            StoreMatAmt := 0;
            ProgressBillingLine.RESET();
            ProgressBillingLine.SETRANGE("NS_Progress Billing No.", BillingHeader."NS_No.");
            ProgressBillingLine.SETRANGE("NS_Requisition No.", BillingHeader."NS_Requisition No.");
            ProgressBillingLine.SETRANGE("NS_Version No.", BillingHeader."NS_Version No.");
            if ProgressBillingLine.FINDSET() then
                repeat
                    StoreMatAmt += ProgressBillingLine."NS_Stored Materials Amount";
                until ProgressBillingLine.NEXT() = 0;
            if StoreMatAmt = 0 then
                if LastStoreMatAmt > 0 then
                    exit(true);
        end;
        exit(false);
    end;

    procedure NS_StoreMatrZeroLines(BillingHeader: Record "NS_Progress Billing Header"; SalesHeader: Record "Sales Header"; Job: Record Job);
    var
        ProgressBillingLine: Record "NS_Progress Billing Line";
        SalesLine: Record "Sales Line";
        JobTask: Record "Job Task";
        RevCatTbl: Record "NS_Job Revenue Category";
        JobActivity: Record "NS_Job Activity";
        JobProcess: Record "NS_Job Process";
        JobOperation: Record "NS_Job Operation";
        JobSection: Record NS_Sections;
        JobPostingGroup: Record "Job Posting Group";
        JobsSetup: Record "Jobs Setup";
        PreviousStoredMaterial: Decimal;
        StoredMaterialToBill: Decimal;
        LineNumber: Integer;
        JobDimensionNo: Integer;
        LineRetention: Boolean;
        Licdate: date;
        NoOfDays: Text;
        EnvInfoCU: Codeunit "Environment Information";
        NS_JobPlanningLines: Record "Job Planning Line";
        NSJPL: Record "Job Planning Line";
        ItemRec: Record Item;
        NS_Jobs: Record Job;
        NS_JobsSetup: Record "Jobs Setup";
        NS_SalesRecSetup: Record "Sales & Receivables Setup";
        SaleHead: Record "Sales Header";
        TotOldStoreAmt: Decimal;
    begin
        //PRJ-1686.GK.1.0 22Nov2022 start
        if EnvInfoCU.IsSaaS() then
            OnCheckPPLicenseExpire();
        //PRJ-1686.GK.1.0 22Nov2022 end

        JobsSetup.GET();
        LineNumber := 0;
        TotOldStoreAmt := 0;
        ProgressBillingLine.RESET();
        ProgressBillingLine.SETRANGE("NS_Progress Billing No.", BillingHeader."NS_No.");
        ProgressBillingLine.SETRANGE("NS_Requisition No.", BillingHeader."NS_Requisition No.");
        ProgressBillingLine.SETRANGE("NS_Version No.", BillingHeader."NS_Version No.");
        if ProgressBillingLine.FINDSET() then
            repeat
                if ProgressBillingLine."NS_Old Stored Materials Amount" <> 0 then begin
                    if (ProgressBillingLine."NS_Work Retention Percent" <> 0) or
                       (ProgressBillingLine."NS_Work Retention Amount" <> 0) or
                       (ProgressBillingLine."NS_Material Retention Percent" <> 0) or
                       (ProgressBillingLine."NS_Material Retention Amount" <> 0) then
                        LineRetention := true;

                    TotOldStoreAmt += ProgressBillingLine."NS_Old Stored Materials Amount";
                    PreviousStoredMaterial := ProgressBillingLine.NS_LastProgressBillStoredMatLine(ProgressBillingLine);
                    if ProgressBillingLine."NS_Stored Materials Amount" - PreviousStoredMaterial > 0 then
                        StoredMaterialToBill := ProgressBillingLine."NS_Stored Materials Amount" - PreviousStoredMaterial
                    else
                        StoredMaterialToBill := 0;
                    SalesLine.INIT;
                    SalesLine."Document Type" := SalesHeader."Document Type";
                    SalesLine."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
                    SalesLine."Document No." := SalesHeader."No.";
                    LineNumber := LineNumber + 10000;
                    SalesLine."Line No." := LineNumber;
                    IF JobsSetup."NS_EnableItemNosForProgBill" = TRUE THEN BEGIN
                        if NSJPL.Get(ProgressBillingLine."NS_Job No.", ProgressBillingLine."NS_Job Task No.", ProgressBillingLine."NS_Planing Line No.") then;
                        if (NSJPL.Type = NSJPL.Type::Item) and (NSJPL."NS_Progress Billing Method" = NSJPL."NS_Progress Billing Method"::Unit) then
                            SalesLine.Type := SalesLine.Type::Item
                        else
                            SalesLine.Type := SalesLine.Type::"G/L Account";
                    END ELSE BEGIN
                        SalesLine.Type := SalesLine.Type::"G/L Account";
                    END;
                    SalesLine.VALIDATE(Type);
                    CLEAR(JobActivity);
                    CLEAR(JobProcess);
                    CLEAR(JobOperation);
                    Clear(JobSection);
                    if ProgressBillingLine."NS_Job Task No." > '' then begin
                        JobActivity.GET(JobActivity.NS_Type::Revenue, ProgressBillingLine."NS_Activity Code");
                        if ProgressBillingLine."NS_Process Code" > '' then begin
                            JobProcess.GET(JobProcess.NS_Type::Revenue, ProgressBillingLine."NS_Activity Code", ProgressBillingLine."NS_Process Code");
                            if ProgressBillingLine."NS_Operation Code" > '' then begin
                                JobOperation.GET(JobOperation.NS_Type::Revenue, ProgressBillingLine."NS_Activity Code", ProgressBillingLine."NS_Process Code", ProgressBillingLine."NS_Operation Code");
                                if ProgressBillingLine."NS_Section Code" > '' then
                                    JobSection.Get(JobSection.NS_Type::Revenue, ProgressBillingLine."NS_Activity Code", ProgressBillingLine."NS_Process Code", ProgressBillingLine."NS_Operation Code", ProgressBillingLine."NS_Section Code")
                            end;
                        end;
                    end;
                    NS_JobPlanningLines.Reset();
                    NS_JobPlanningLines.SetRange("Job No.", ProgressBillingLine."NS_Job No.");
                    NS_JobPlanningLines.SetRange("Job Task No.", ProgressBillingLine."NS_Job Task No.");
                    NS_JobPlanningLines.SetRange("Line No.", ProgressBillingLine."NS_Planing Line No.");
                    NS_JobPlanningLines.SetRange("NS_Use Job Plan. Line Entries", true);
                    NS_JobPlanningLines.SetRange(Type, NS_JobPlanningLines.Type::"G/L Account");
                    if NS_JobPlanningLines.FindFirst() then begin
                        SalesLine."No." := NS_JobPlanningLines."No.";
                    end else begin
                        if ProgressBillingLine."NS_Job Task No." <> '' then begin
                            IF JobTask.GET(ProgressBillingLine."NS_Job No.", ProgressBillingLine."NS_Job Task No.") then
                                if JobTask."Job Posting Group" <> '' then begin
                                    JobPostingGroup.GET(JobTask."Job Posting Group");
                                    SalesLine."No." := JobPostingGroup."Recognized Sales Account";
                                end else
                                    if JobTask."Job Posting Group" = '' then begin
                                        if Job.Get(ProgressBillingLine."NS_Job No.") then
                                            if JobPostingGroup.GET(Job."Job Posting Group") then
                                                SalesLine."No." := JobPostingGroup."Recognized Sales Account";
                                    end;
                        end;
                    end;
                    IF JobsSetup."NS_EnableItemNosForProgBill" = TRUE THEN BEGIN
                        if SalesLine.Type = SalesLine.Type::Item then
                            SalesLine."No." := NSJPL."No.";
                    END;
                    SalesLine.VALIDATE("No.");
                    NS_OnBeforeInsertNormalDocumentLineMakeReceivablesDocument(SalesLine, ProgressBillingLine);
                    SalesLine.Insert();
                    NS_OnAfterInsertSalesLineFromProgressBillLine(SalesLine, ProgressBillingLine); //PE-95.NC.1.0 19May2023
                    if job."NS_Gen. Prod. Posting Group New" <> '' then
                        SalesLine."Gen. Prod. Posting Group" := Job."NS_Gen. Prod. Posting Group New"
                    else
                        //SalesLine."Gen. Prod. Posting Group" := JobsSetup."NS_Prog. Bill Gen. ProdPostGr.";//PRJ-1684.AS.1.0 Comented
                    SalesLine."Gen. Prod. Posting Group" := JobsSetup."NS_ProgBillGenProdPostGr New";//PRJ-1684.AS.1.0 Add
                    IF JobsSetup."NS_EnableItemNosForProgBill" = TRUE THEN BEGIN
                        if (SalesLine.Type = SalesLine.Type::Item) and (SalesLine."No." <> '') then
                            if SalesLine."Gen. Prod. Posting Group" = '' then begin
                                if ItemRec.Get(SalesLine."No.") then
                                    SalesLine."Gen. Prod. Posting Group" := ItemRec."Gen. Prod. Posting Group";
                            end;
                    END;
                    if NS_SalesRecSetup.Get() then;
                    if NS_SalesRecSetup."NS_Allow Description excl Nos." then begin
                        SalesLine.Description := ProgressBillingLine.NS_Description;
                    end else begin
                        if ProgressBillingLine."NS_Item No." > '' then
                            //SalesLine.Description := COPYSTR(ProgressBillingLine."NS_Item No." + ' - ' + ProgressBillingLine.NS_Description, 1, 50)   //PRJCTPR-189.JS.1.0 05Sep2023 line commented
                            SalesLine.Description := COPYSTR(ProgressBillingLine."NS_Item No." + ' - ' + ProgressBillingLine.NS_Description, 1, 100)   //PRJCTPR-189.JS.1.0 05Sep2023 line added
                        else
                            SalesLine.Description := ProgressBillingLine.NS_Description;
                    end;
                    SalesLine.VALIDATE("Tax Liable", Job."NS_Tax Liable");
                    SalesLine.VALIDATE("Tax Area Code", Job."NS_Tax Area Code");
                    //SalesLine.VALIDATE("Tax Group Code", Job."NS_Tax Group Code"); //PRJCTPR-298.JS.1.0
                    SalesLine.VALIDATE("Tax Group Code", Job."NS_Tax Group Code New"); //PRJCTPR-298.JS.1.0

                    //PRJCTPR-136.NC.1.0 28June2023 Start
                    //IF JobsSetup."NS_EnableItemNosForProgBill" = TRUE THEN BEGIN  
                    IF JobsSetup."NS_Transfer Qty of Units to SI" THEN BEGIN
                        if NSJPL.Get(ProgressBillingLine."NS_Job No.", ProgressBillingLine."NS_Job Task No.", ProgressBillingLine."NS_Planing Line No.") then;
                        //if (NSJPL.Type = NSJPL.Type::Item) and (NSJPL."NS_Progress Billing Method" = NSJPL."NS_Progress Billing Method"::Unit) and (NSJPL."No." <> '') then
                        if (ProgressBillingLine."NS_Current Work Unit" <> 0) and (NSJPL."NS_Progress Billing Method" = NSJPL."NS_Progress Billing Method"::Unit) and (NSJPL."No." <> '') then begin
                            SalesLine.Quantity := ProgressBillingLine."NS_Current Work Unit";
                            SalesLine.validate("Unit of Measure Code", ProgressBillingLine."NS_Unit of Measure Code");
                        end
                        //SalesLine.Quantity := ProgressBillingLine.NS_Quantity 
                        //PRJCTPR-136.NC.1.0 28June2023 End
                        else
                            SalesLine.Quantity := 1;
                    END ELSE BEGIN
                        SalesLine.Quantity := 1;
                    END;
                    //PE-301.NC.1.0 12Jun2024 Start
                    if JobsSetup.NS_EnableItemNosForProgBill then begin
                        if SalesLine.Type = SalesLine.Type::Item then begin
                            if Job.Get(ProgressBillingLine."NS_Job No.") then;
                            if job."NS_Pur/Sale UOM for B&B JPL" then begin
                                if NSJPL.Get(ProgressBillingLine."NS_Job No.", ProgressBillingLine."NS_Job Task No.", ProgressBillingLine."NS_Planing Line No.") then;
                                if ((NSJPL."Line Type" = NSJPL."Line Type"::"Both Budget and Billable") and (NSJPL.Type = NSJPL.Type::Item)) then begin
                                    if ItemRec.Get(SalesLine."No.") then;
                                    if ItemRec."Sales Unit of Measure" <> '' then
                                        SalesLine.Validate("Unit of Measure Code", ItemRec."Sales Unit of Measure");
                                end;
                            end;
                        end;
                    end;
                    //PE-301.NC.1.0 12Jun2024 End
                    SalesLine.VALIDATE(Quantity);
                    SalesLine."Unit Price" := Round(ProgressBillingLine."NS_Work Amount" + ProgressBillingLine."NS_Stored Materials Amount" + ProgressBillingLine.NS_LastTotal(ProgressBillingLine) -
                                              BillingHeader.NS_LastProgressBillTCS(ProgressBillingLine), 0.01); //PE-15.PS.1.0 16Jan2023

                    if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then begin
                        if SalesLine."Unit Price" < 0 then begin
                            SalesLine."Unit Price" := -SalesLine."Unit Price";
                        end else begin
                            SalesLine.Quantity := -SalesLine.Quantity;
                            SalesLine.VALIDATE(Quantity);
                        end;
                    end;

                    SalesLine.VALIDATE("Unit Price");
                    SalesLine.Amount := Round(SalesLine."Unit Price", 0.01);  //PE-15.PS.1.0 16Jan2023
                    SalesLine."NS_Segment Code" := ProgressBillingLine."NS_Segment Code";//TM-10.AM.1.0
                    ProgressBillingLine.CalcFields("NS_Segment Name");//TM-32.AM.1.0
                    SalesLine."NS_Segment Name" := ProgressBillingLine."NS_Segment Name";//TM-32.AM.1.0
                    SalesLine.VALIDATE(Amount);
                    //PRJCTPR-136.NC.1.0 28June2023 Start
                    IF JobsSetup."NS_Transfer Qty of Units to SI" THEN BEGIN
                        if NSJPL.Get(ProgressBillingLine."NS_Job No.", ProgressBillingLine."NS_Job Task No.", ProgressBillingLine."NS_Planing Line No.") then;
                        if (ProgressBillingLine."NS_Current Work Unit" <> 0) and (NSJPL."NS_Progress Billing Method" = NSJPL."NS_Progress Billing Method"::Unit) and (NSJPL."No." <> '') then begin
                            SalesLine."Unit Price" := SalesLine.Amount / ProgressBillingLine."NS_Current Work Unit";
                            SalesLine.Validate("Unit Price");
                            SalesLine.validate("Unit of Measure Code", ProgressBillingLine."NS_Unit of Measure Code");
                        end;
                    end;

                    //PE-301.NC.1.0 12Jun2024 Start
                    if JobsSetup.NS_EnableItemNosForProgBill then begin
                        if SalesLine.Type = SalesLine.Type::Item then begin
                            if Job.Get(ProgressBillingLine."NS_Job No.") then;
                            if job."NS_Pur/Sale UOM for B&B JPL" then begin
                                if NSJPL.Get(ProgressBillingLine."NS_Job No.", ProgressBillingLine."NS_Job Task No.", ProgressBillingLine."NS_Planing Line No.") then;
                                if ((NSJPL."Line Type" = NSJPL."Line Type"::"Both Budget and Billable") and (NSJPL.Type = NSJPL.Type::Item)) then begin
                                    if ItemRec.Get(SalesLine."No.") then;
                                    if ItemRec."Sales Unit of Measure" <> '' then
                                        SalesLine.Validate("Unit of Measure Code", ItemRec."Sales Unit of Measure");
                                end;
                            end;
                        end;
                    end;
                    //PE-301.NC.1.0 12Jun2024 End
                    SalesLine."Job No." := ProgressBillingLine."NS_Job No.";
                    SalesLine."NS_Job Revenue Category" := ProgressBillingLine."NS_Revenue Category";
                    SalesLine."NS_Revenue Cat Description" := ProgressBillingLine."NS_Revenue Cat Description";//PRJ-702.AS.1.0

                    //PRJCTPR-199.JS.1.0 12DEC2023 Start
                    //SalesLine."Job Task No." := BillingHeader.NS_APOToJobTaskNo(ProgressBillingLine."NS_Activity Code", ProgressBillingLine."NS_Process Code", ProgressBillingLine."NS_Operation Code", ProgressBillingLine."NS_Section Code");//PRJ-688.AM.1.0
                    SalesLine.validate("Job Task No.", BillingHeader.NS_APOToJobTaskNo(ProgressBillingLine."NS_Activity Code", ProgressBillingLine."NS_Process Code", ProgressBillingLine."NS_Operation Code", ProgressBillingLine."NS_Section Code"));
                    //PRJCTPR-199.JS.1.0 12DEC2023 end
                    if (BillingHeader."NS_Work Retention Percent" > 0) or (BillingHeader."NS_Material Retention Percent" > 0) then
                        SalesLine."NS_Retention Applies" := true;

                    If NS_Jobs.get(SalesLine."Job No.") then
                        if NS_Jobs."NS_Sub-Level to Job No." = '' then
                            SalesLine."NS_Sub-Level to Job No." := NS_Jobs."No."
                        else
                            SalesLine."NS_Sub-Level to Job No." := NS_Jobs."NS_Sub-Level to Job No.";

                    SalesLine."NS_From Prog. Billing Base Amount" := ProgressBillingLine."NS_Base Amount";//CTSI-150.AS.1.0 28Sept2020

                    if SalesLine.Amount <> 0 then begin
                        NS_OnBeforeModifyNormalDocumentLineMakeReceivablesDocument(SalesLine, ProgressBillingLine);
                        SalesLine.Modify();
                    end;
                    SaleHead.Reset();
                    SaleHead.SetRange("No.", SalesHeader."No.");
                    if SaleHead.FindFirst() then begin
                        SaleHead."NS_Retention Document" := false;
                        SaleHead."NS_Retention Amount" := TotOldStoreAmt;
                        SaleHead.Validate("NS_Retention Percent", BillingHeader."NS_Work Retention Percent");
                        SaleHead.Modify();
                    end;
                end;
            until ProgressBillingLine.NEXT() = 0;
    end;
    //PRJ-1519.NK.1.0 17Aug2022 End
    //PRJ-1624.NK.1.0 04Oct2022 Start
    procedure NS_LastProgrBillRetLine(ProgBillHead: Record "NS_Progress Billing Header"; ProgBillLine: record "NS_Progress Billing Line"): Decimal;
    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        ProgressBillingLine: record "NS_Progress Billing Line";
        LastRetention: Decimal;
    begin
        LastRetention := 0;
        ProgressBillingHeader.RESET();
        ProgressBillingHeader.SETRANGE("NS_No.", ProgBillHead."NS_No.");
        ProgressBillingHeader.SETFILTER("NS_Requisition No.", '<%1', ProgBillHead."NS_Requisition No.");
        ProgressBillingHeader.SETFILTER(NS_Status, '<>%1', ProgressBillingHeader.NS_Status::Void);
        if ProgressBillingHeader.FINDLAST() then begin
            ProgressBillingLine.Reset();
            ProgressBillingLine.setrange("NS_Progress Billing No.", ProgressBillingHeader."NS_Job No.");
            ProgressBillingLine.setrange("NS_Requisition No.", ProgressBillingHeader."NS_Requisition No.");
            ProgressBillingLine.setrange("NS_Version No.", ProgressBillingHeader."NS_Version No.");
            ProgressBillingLine.SetRange("NS_Line No.", ProgBillLine."NS_Line No.");
            if ProgressBillingLine.findfirst() then
                LastRetention += ProgressBillingLine."NS_Work Retention Amount";
        end;
        exit(LastRetention);
    end;

    procedure NS_LastStotrBilling(var ProgBilingLine: Record "NS_Progress Billing Line"): Decimal;
    var
        ProgressBillingHeader_Loc: Record "NS_Progress Billing Header";
        ProgressBillingLine: record "NS_Progress Billing Line";
        NS_LastStoreAmount: Decimal;
    begin
        NS_LastStoreAmount := 0;
        ProgressBillingLine.RESET();
        ProgressBillingLine.SETRANGE("NS_Progress Billing No.", ProgBilingLine."NS_Progress Billing No.");
        ProgressBillingLine.SETFILTER("NS_Requisition No.", '<%1', ProgBilingLine."NS_Requisition No.");
        ProgressBillingLine.SETRANGE("NS_Line No.", ProgBilingLine."NS_Line No.");
        if ProgressBillingLine.FINDSET() then
            repeat
                if ProgressBillingHeader_Loc.GET(ProgressBillingLine."NS_Progress Billing No.", ProgressBillingLine."NS_Requisition No.", ProgressBillingLine."NS_Version No.") then
                    if ProgressBillingHeader_Loc.NS_Status <> ProgressBillingHeader_Loc.NS_Status::Void then
                        NS_LastStoreAmount := ProgressBillingLine."NS_Stored Materials Amount";
            until ProgressBillingLine.NEXT() = 0;
        exit(NS_LastStoreAmount);
    end;

    procedure NS_LastStotrRetentionAmt(var ProgBilingLine: Record "NS_Progress Billing Line"): Decimal;
    var
        ProgressBillingHeader_Loc: Record "NS_Progress Billing Header";
        ProgressBillingLine: record "NS_Progress Billing Line";
        NS_LastStoreAmount: Decimal;
    begin
        NS_LastStoreAmount := 0;
        ProgressBillingLine.RESET();
        ProgressBillingLine.SETRANGE("NS_Progress Billing No.", ProgBilingLine."NS_Progress Billing No.");
        ProgressBillingLine.SETFILTER("NS_Requisition No.", '<%1', ProgBilingLine."NS_Requisition No.");
        ProgressBillingLine.SETRANGE("NS_Line No.", ProgBilingLine."NS_Line No.");
        if ProgressBillingLine.FINDSET() then
            repeat
                if ProgressBillingHeader_Loc.GET(ProgressBillingLine."NS_Progress Billing No.", ProgressBillingLine."NS_Requisition No.", ProgressBillingLine."NS_Version No.") then
                    if ProgressBillingHeader_Loc.NS_Status <> ProgressBillingHeader_Loc.NS_Status::Void then
                        NS_LastStoreAmount := ProgressBillingLine."NS_Stored Mat. Retention Amt";
            until ProgressBillingLine.NEXT() = 0;
        exit(NS_LastStoreAmount);
    end;
    //PRJ-1624.NK.1.0 04Oct2022 End  

    //PRJ-1648.PS.1.0 10OCT2022 - Start
    procedure NS_RetentionMultipleDocs(BillingHeader: Record "NS_Progress Billing Header")
    var

    begin
        if BillingHeader."NS_R_Reduction & Invoicing" = true then begin
            BoolforNormalLineReteion := true;
            NS_MakeReceivablesDocument(BillingHeader)
        end;
    end;

    procedure NS_RetentionMultipleDocsStore(BillingHeader: Record "NS_Progress Billing Header")
    var

    begin
        if BillingHeader."NS_R_Reduction & Invoicing" = true then begin
            BoolforNormalLineStore := true;
            NS_MakeReceivablesDocument(BillingHeader)
        end;
    end;

    //PRJ-1648.PS.1.0 10OCT2022 - End    
}

