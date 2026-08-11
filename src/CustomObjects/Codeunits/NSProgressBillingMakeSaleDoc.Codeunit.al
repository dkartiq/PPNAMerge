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
    //PRJ-904.JS.1.0 10Sep2021 | Modify code as per process requirement
    //PRJ-913.JS.1.0�13Sep2021 | write code to flow dimension value as per job task
    //PRJ-973.GK.1.0 13Oct2021 | Added new code for progress billing

    trigger OnRun();
    begin
    end;

    var
        Text01Lbl: Label 'The draw number %1 has already been used for progress bill %2 - %3.  Do you want to override that with this billing?', Comment = '%1=NS_Draw No.,%2=NS_ProgressBillRequisitionNo.,%3=NS_ProgressBillRequisitionNo.';

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
        NoSeriesMgt: Codeunit NoSeriesManagement;
        RequisitionAmount: Decimal;
        PreviousRetention: Decimal;
        RetBalance: Decimal;
        BillingValue: Decimal;
        TotalBilling: Decimal;
        Earned: Decimal;
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
                OnCheckPPLicenseExpire();
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
                        else
                            SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";
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
                        SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";
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

            //Fill in the rest of the sales header
            SalesHeader."Sell-to Customer No." := Job."Bill-to Customer No.";
            SalesHeader.InitRecord;
            NoSeriesMgt.SetDefaultSeries(SalesHeader."Shipping No. Series", SalesSetup."Posted Shipment Nos.");
            SalesHeader.VALIDATE("Sell-to Customer No.");
            SalesHeader.VALIDATE("Posting Date", "NS_Period To"); //PRJ-699.N.S.1.0
            SalesHeader.VALIDATE("Tax Liable", Job."NS_Tax Liable");
            SalesHeader.VALIDATE("Tax Area Code", Job."NS_Tax Area Code");
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
                end;
                // >> Upgrade
                //SalesHeader.VALIDATE("NS_Retention Amount"); // #132
                // << Upgrade
            end;
            // >> Upgrade
            SalesHeader."NS_Progress Billing Document" := true;
            // << Upgrade
            SalesHeader."NS_From Progress Billing No." := "NS_No.";
            SalesHeader."NS_From ProgressBillingReq.No." := "NS_Requisition No.";
            SalesHeader."NS_From ProgressBillingVer.No." := "NS_Version No.";
            // >> Upgrade
            //SalesHeader.VALIDATE("NS_Job No.", "NS_Job No.");
            // << Upgrade
            SalesHeader."NS_Use % Billing format" := Job."NS_Use % Billing format";//CTSI-150.AS.1.0
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
            //Set up Sales Lines
            LineRetention := false;
            if SalesHeader."NS_Retention Document" then
                NS_RetentionDocumentLines(BillingHeader, SalesHeader, Job)
            else
                NS_NormalDocumentLines(BillingHeader, SalesHeader, Job);
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
                                        CustLedgerEntry.CALCFIELDS("Remaining Amt. (LCY)");
                                        RetBalance := RetBalance + CustLedgerEntry."Remaining Amt. (LCY)";
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
                                        CustLedgerEntry.CALCFIELDS("Remaining Amt. (LCY)");
                                        RetBalance := RetBalance + CustLedgerEntry."Remaining Amt. (LCY)";
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

            //Update Sales Header
            SalesHeader."External Document No." := Job."NS_Customer PO Number";//CTSI-179.MS.1.0
            SalesHeader."Salesperson Code" := Job."NS_Salesperson Code";//PRJ-415
            SalesHeader.MODIFY;

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
            OnCheckPPLicenseExpire();
        end;
        //PRJ-516.ms.1.0 end
        //Create Normal Receivables Document Lines
        with ProgressBillingLine do begin
            JobsSetup.GET;
            LineNumber := 0;
            RESET;
            SETRANGE("NS_Progress Billing No.", BillingHeader."NS_No.");
            SETRANGE("NS_Requisition No.", BillingHeader."NS_Requisition No.");
            SETRANGE("NS_Version No.", BillingHeader."NS_Version No.");
            if FINDSET then
                repeat
                    if "NS_Line Amount" <> 0 then begin
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
                        //PRJ-992.AS.1.0 START
                        if NSJPL.Get("NS_Job No.", "NS_Job Task No.", "NS_Planing Line No.") then;

                        if (NSJPL.Type = NSJPL.Type::Item) and (NSJPL."NS_Progress Billing Method" = NSJPL."NS_Progress Billing Method"::Unit) then
                            SalesLine.Type := SalesLine.Type::Item
                        else
                            //PRJ-992.AS.1.0 END
                            SalesLine.Type := SalesLine.Type::"G/L Account";
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

                        //PRJ-992.AS.1.0 START
                        if SalesLine.Type = SalesLine.Type::Item then
                            SalesLine."No." := NSJPL."No.";
                        //PRJ-992.AS.1.0 END

                        NS_OnBeforeSalesLineNovalidateinNormalDocLinesofProgBill(SalesLine, ProgressBillingLine);//PRJ-989.AS.1.0 18OCT2021 Added Event //PRJ-1020.AS.1.0 Added
                        SalesLine.VALIDATE("No.");
                        //PRJ-333.AS.1.0 27 JULY 2020 - START
                        // if job."NS_Gen. Prod. Posting Group" <> '' then//PRJ-831.AS.1.0 12OCT2021 Comment old
                        //     SalesLine."Gen. Prod. Posting Group" := Job."NS_Gen. Prod. Posting Group" //PRJ-333.AM.1.0 //PRJ-831.AS.1.0 12OCT2021 Comment old

                        if job."NS_Gen. Prod. Posting Group New" <> '' then//PRJ-831.AS.1.0 12OCT2021 Add New
                            SalesLine."Gen. Prod. Posting Group" := Job."NS_Gen. Prod. Posting Group New" //PRJ-333.AM.1.0//PRJ-831.AS.1.0 12OCT2021 Add New
                        else
                            SalesLine."Gen. Prod. Posting Group" := JobsSetup."NS_Prog. Bill Gen. ProdPostGr.";//PRJ-333.AS.1.0 27 JULY 20220 
                                                                                                               //PRJ-333.AS.1.0 27 JULY 20220 - end  

                        //PRJ-992.AS.1.0 START
                        if (SalesLine.Type = SalesLine.Type::Item) and (SalesLine."No." <> '') then
                            if SalesLine."Gen. Prod. Posting Group" = '' then begin
                                if ItemRec.Get(SalesLine."No.") then
                                    SalesLine."Gen. Prod. Posting Group" := ItemRec."Gen. Prod. Posting Group";
                            end;
                        //PRJ-992.AS.1.0 END

                        if "NS_Item No." > '' then
                            SalesLine.Description := COPYSTR("NS_Item No." + ' - ' + NS_Description, 1, 50)
                        else
                            SalesLine.Description := NS_Description;
                        SalesLine.VALIDATE("Tax Liable", Job."NS_Tax Liable");
                        SalesLine.VALIDATE("Tax Area Code", Job."NS_Tax Area Code");
                        SalesLine.VALIDATE("Tax Group Code", Job."NS_Tax Group Code");
                        //PRJ-992.AS.1.0 START
                        if (NSJPL.Type = NSJPL.Type::Item) and (NSJPL."NS_Progress Billing Method" = NSJPL."NS_Progress Billing Method"::Unit) and (NSJPL."No." <> '') then
                            SalesLine.Quantity := NS_Quantity
                        else
                            //PRJ-992.AS.1.0 END
                            SalesLine.Quantity := 1;
                        SalesLine.VALIDATE(Quantity);
                        SalesLine."Unit Price" := "NS_Work Amount" + "NS_Stored Materials Amount" + NS_LastTotal(ProgressBillingLine) -
                                                  BillingHeader.NS_LastProgressBillTCS(ProgressBillingLine);

                        NS_AfterSalesLineUnitpriceassgmtinNormDocLinefProgBill(SalesLine);//PRJ-989.AS.1.0 18OCT2021 Added Event

                        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then begin
                            if SalesLine."Unit Price" < 0 then begin
                                SalesLine."Unit Price" := -SalesLine."Unit Price";
                            end else begin
                                SalesLine.Quantity := -SalesLine.Quantity;
                                SalesLine.VALIDATE(Quantity);
                            end;
                        end;

                        SalesLine.VALIDATE("Unit Price");
                        SalesLine.Amount := SalesLine."Unit Price";
                        SalesLine."NS_Segment Code" := "NS_Segment Code";//TM-10.AM.1.0
                        CalcFields("NS_Segment Name");//TM-32.AM.1.0
                        SalesLine."NS_Segment Name" := ProgressBillingLine."NS_Segment Name";//TM-32.AM.1.0
                        SalesLine.VALIDATE(Amount);
                        SalesLine."Job No." := "NS_Job No.";
                        SalesLine."NS_Job Revenue Category" := "NS_Revenue Category";
                        //CTSI-42.AS.1.0 21MAY2020 - start
                        //if SalesLine."Document Type" = SalesLine."Document Type"::Invoice then
                        SalesLine."NS_Revenue Cat Description" := "NS_Revenue Cat Description";//PRJ-702.AS.1.0
                        //CTSI-42.AS.1.0 21MAY2020 - end
                        SalesLine."Job Task No." := BillingHeader.NS_APOToJobTaskNo("NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code");//PRJ-688.AM.1.0
                        if (BillingHeader."NS_Work Retention Percent" > 0) or (BillingHeader."NS_Material Retention Percent" > 0) then
                            SalesLine."NS_Retention Applies" := true;
                        SalesLine."Shortcut Dimension 1 Code" := Job."Global Dimension 1 Code";
                        SalesLine."Shortcut Dimension 2 Code" := Job."Global Dimension 2 Code";
                        SalesLine."Dimension Set ID" := BillingHeader.NS_GetDimensionNoFromJob(BillingHeader."NS_Job No."); //PRJ-913.JS.1.0 line added

                        //PRJ-913.JS.1.0�13Sep2021-Start                        
                        if JobTask.GET(SalesLine."Job No.", SalesLine."Job Task No.") then
                            IF ((JobTask."Global Dimension 1 Code" <> '') and (JobTask."Global Dimension 2 Code" <> '')) then begin
                                SalesLine."Shortcut Dimension 1 Code" := JobTask."Global Dimension 1 Code";
                                SalesLine."Shortcut Dimension 2 Code" := JobTask."Global Dimension 2 Code";
                                SalesLine."Dimension Set ID" := BillingHeader.NS_GetDimensionNoFromJobTask(SalesLine."Job No.", SalesLine."Job Task No.");
                            end;
                        //PRJ-913.JS.1.0�13Sep2021-end                         

                        //SalesLine."Dimension Set ID" := JobDimensionNo;//PRJ-180.SK.1.1 Commented                        
                        //SalesLine."Dimension Set ID" := BillingHeader.NS_GetDimensionNoFromJob(BillingHeader."NS_Job No."); //PRJ-180.SK.1.1 Added //PRJ-913.JS.1.0 Commented                    

                        SalesLine."NS_From Prog. Billing Base Amount" := "NS_Base Amount";//CTSI-150.AS.1.0 28Sept2020
                                                                                          // >> Upgrade
                        OnBeforeInsertNS_NormalDocumentLines(SalesLine, ProgressBillingLine);
                        // << Upgrade
                        if SalesLine.Amount <> 0 then
                            SalesLine.INSERT;
                    end;
                until ProgressBillingLine.NEXT = 0;
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
        LineNumber: Integer;
        Text0001: Label '"Retention for Job "';
        Text0002: Label 'Retention percentage changes cannot be on the same document with regular billings.';
        JobDimensionNo: Integer;
        Licdate: date;//PRJ-516
        NoOfDays: Text;//PRJ-516
        EnvInfoCU: Codeunit "Environment Information";//PRJ-516
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
            OnCheckPPLicenseExpire();
        end;
        //PRJ-516.ms.1.0 end
        //Create Retention Receivables Document Lines
        with ProgressBillingLine do begin
            LineNumber := 10000;
            JobsSetup.GET;
            SalesSetup.GET;

            if not SalesSetup."NS_Sales Retention Inactive" then begin
                RESET;
                SETRANGE("NS_Progress Billing No.", BillingHeader."NS_No.");
                SETRANGE("NS_Requisition No.", BillingHeader."NS_Requisition No.");
                SETRANGE("NS_Version No.", BillingHeader."NS_Version No.");
                if FINDSET then
                    repeat
                        if "NS_Work Amount" = 0 then begin
                            //Build the sales line
                            SalesLine.INIT;
                            SalesLine."Document Type" := SalesHeader."Document Type";
                            SalesLine."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
                            SalesLine."Document No." := SalesHeader."No.";
                            SalesLine."Line No." := LineNumber;
                            SalesLine.Type := SalesLine.Type::NS_Ledger;
                            SalesLine.VALIDATE(Type);
                            SalesLine."No." := JobsSetup."NS_Retention Receivable Ledger";
                            SalesLine.VALIDATE("No.");
                            // if job."NS_Gen. Prod. Posting Group" <> '' then //PRJ-333.AM.2.0 added code //PRJ-831.AS.1.0 12OCT2021 Comment old
                            //     SalesLine."Gen. Prod. Posting Group" := Job."NS_Gen. Prod. Posting Group" //PRJ-333.AM.2.0 added code //PRJ-831.AS.1.0 12OCT2021 Comment old

                            if job."NS_Gen. Prod. Posting Group New" <> '' then //PRJ-333.AM.2.0 added code //PRJ-831.AS.1.0 12OCT2021 Add New
                                SalesLine."Gen. Prod. Posting Group" := Job."NS_Gen. Prod. Posting Group New" //PRJ-333.AM.2.0 added code//PRJ-831.AS.1.0 12OCT2021 Add New
                            else                                                                          //PRJ-333.AM.2.0 added code
                                SalesLine."Gen. Prod. Posting Group" := JobsSetup."NS_Prog. Bill Gen. ProdPostGr.";

                            SalesLine.Description := Text0001 + "NS_Job No.";
                            SalesLine."Job No." := "NS_Job No.";
                            SalesLine.Quantity := 1;
                            SalesLine.VALIDATE(Quantity);
                            SalesLine."Unit Price" := "NS_Billed Work Retention Amt" + "NS_Billed MaterialRetentionAmt";

                            if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then
                                SalesLine."Unit Price" := -SalesLine."Unit Price";
                            SalesLine.Amount := SalesLine."Unit Price";
                            SalesLine.VALIDATE("Unit Price");
                            SalesLine.VALIDATE(Amount);
                            SalesLine."NS_Job Revenue Category" := "NS_Revenue Category";
                            SalesLine."Job Task No." := BillingHeader.NS_APOToJobTaskNo("NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code");//PRJ-688.AM.1.0
                                                                                                                                                                       //CTSI-42.AS.1.0 21MAY2020 - start
                                                                                                                                                                       //if SalesLine."Document Type" = SalesLine."Document Type"::Invoice then
                            SalesLine."NS_Revenue Cat Description" := "NS_Revenue Cat Description";//PRJ-702.AS.1.0
                            //CTSI-42.AS.1.0 21MAY2020 - end
                            SalesLine.VALIDATE("Tax Liable", Job."NS_Tax Liable");
                            SalesLine.VALIDATE("Tax Area Code", Job."NS_Tax Area Code");
                            SalesLine.VALIDATE("Tax Group Code", Job."NS_Tax Group Code");
                            SalesLine."NS_Retention Applies" := false;
                            //SalesLine."Dimension Set ID" := JobDimensionNo;//PRJ-180.SK.1.1 Commented
                            SalesLine."NS_Segment Code" := "NS_Segment Code";//TM-10.AM.2.0
                            CalcFields("NS_Segment Name");//TM-32.AM.1.0
                            SalesLine."NS_Segment Name" := ProgressBillingLine."NS_Segment Name";//TM-32.AM.1.0
                            SalesLine."Shortcut Dimension 1 Code" := Job."Global Dimension 1 Code";   //PRJ-913.JS.1.0�14Sep2021 Line added
                            SalesLine."Shortcut Dimension 2 Code" := Job."Global Dimension 2 Code";   //PRJ-913.JS.1.0�14Sep2021 Line added                                                        
                            SalesLine."Dimension Set ID" := BillingHeader.NS_GetDimensionNoFromJob(BillingHeader."NS_Job No."); //PRJ-180.SK.1.1 Added
                            SalesLine."NS_From Prog. Billing Base Amount" := "NS_Base Amount";//CTSI-150.AS.1.0 28Sept2020

                            //PRJ-913.JS.1.0�14Sep2021-Start                        
                            if JobTask1.GET(SalesLine."Job No.", SalesLine."Job Task No.") then
                                IF ((JobTask1."Global Dimension 1 Code" <> '') and (JobTask1."Global Dimension 2 Code" <> '')) then begin
                                    SalesLine."Shortcut Dimension 1 Code" := JobTask1."Global Dimension 1 Code";
                                    SalesLine."Shortcut Dimension 2 Code" := JobTask1."Global Dimension 2 Code";
                                    SalesLine."Dimension Set ID" := BillingHeader.NS_GetDimensionNoFromJobTask(SalesLine."Job No.", SalesLine."Job Task No.");
                                end;
                            //PRJ-913.JS.1.0�13Sep2021-end 
                            // >> Upgrade
                            OnBeforeInsertNS_NormalDocumentLines(SalesLine, ProgressBillingLine);
                            // << Upgrade
                            if SalesLine.Amount <> 0 then begin
                                SalesLine.INSERT;
                                LineNumber := LineNumber + 10000;
                            end;
                        end else
                            ERROR(Text0002);

                    until NEXT = 0;
            end;
        end;
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
    // >> Upgrade
    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertNS_NormalDocumentLines(var SalesLine: Record "Sales Line"; var ProgressBillingLine: Record "NS_Progress Billing Line")
    begin
    end;
    // << Upgrade
}



