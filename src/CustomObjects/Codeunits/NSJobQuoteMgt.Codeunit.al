codeunit 14021400 "NS_Job Quote Mgt."
{
    // "a3b03edf-3f59-46a5-9644-a1f4a6b1d289"
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-309.MS.1.0 addedd code for job quote not showinng sell to cutomer no.
    //PRJ-279.MS.1.0 added code create revision
    //PPAL-33-PRJ-311.MS.1.0 code comment for extra plng line creation 
    //PPAL-147.AS.2.0 30SEPT2020  Done code
    //PPAL-147.AS.2.0 05Oct2020 Added & commented code
    //PPAL-147.AS.2.0 06Oct2020 Added & commented codes 
    //PPAL-147.AS.2.0 02Oct2020 Commented & Added code
    //PPAL-172.MS.1.0 added code for package functionality
    //PRJ-646.AM | Recalculated Total Contract Price field by taking Schedule Price calculation in it .
    //PRJ-914.AS.1.0 20OCT2021 Created New Function
    //PRJ-1104.JS.1.0 02FEB2022
    //PRJ-1215.JS.1.0 23FEB2022 | Correct code for contact
    //PRJ-1487.NK.1.0 01Jul2022 | Added Code
    //PRJCTPR-81.NK.1.0 17Mar2023 | Added Code
    //PE-6.NK.1.0 21Mar2023
    //PRJCTPR-197 Dk.1.0 31March2023 | Job No. Rewrite Issue.
    //PRJCTPR-216.VC.1.0 08Nov2023 | Customers name do not populate on jobs of job quote.
    Permissions = tabledata "NS_Assembley BOM Components" = rimd;//PRJ-563.AS.4.0
    trigger OnRun();
    begin
    end;

    var
        QuoteHeader: Record "NS_Job Quote Header";
        SalesLine: Record "Sales Line";
        HideValidationDialog: Boolean;
        "Fields": array[100] of Text[250];
        ReadOnly: Boolean;
        GLSetup: Record "General Ledger Setup";
        Text14021400Lbl: Label 'The Selected Gross Margin Change will Result in %1 Planning Lines to be Transacted at Below Cost\Do You Want to Proceed?';
        Text14021401Lbl: Label 'The Selected Mark-up Change will Result in %1 Planning Lines to be Transacted at Below Cost\Do You Want to Proceed?';
        Text14021402Lbl: Label 'The Selected Gross Margin Percenatge Change will Result in %1 Planning Lines to be Transacted at Below Cost\Do You Want to Proceed?';
        Job: Record Job;
        BySegment: Boolean;
        DisableJobTaskLoad: Boolean;

    procedure NS_AmountCheck(_QuoteHeader: Record "NS_Job Quote Header");
    var
        _EventLogEntry: Record "NS_Job Quote Event Log Entry";
        _QuoteLine: Record "NS_Job Quote Line";
        _SalesLine: Record "Sales Line";
        _AmountSyncError: Boolean;
        _Text000: Label 'NAV sales quote line amount out of sync.  Quote No. %1 Line %2 %3 %4 Amount %5.  Source enhanced quote line: No. %6 Amount %7.';
    begin
        if _QuoteHeader."NS_Quote No." = '' then
            exit;
        _QuoteLine.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        _QuoteLine.SETFILTER(NS_Quantity, '<>0');
        if _QuoteLine.FINDSET(false) then
            repeat
                if not _AmountSyncError then
                    if (_QuoteLine."NS_Sales Quote No." <> '') and (_QuoteLine."NS_Sales Quote Line No." <> 0) then
                        if _SalesLine.GET(_SalesLine."Document Type"::Quote, _QuoteLine."NS_Sales Quote No.", _QuoteLine."NS_Sales Quote Line No.") then
                            if ROUND(_SalesLine."Line Amount", 0.01) <> ROUND(_QuoteLine.NS_Amount, 0.01) then
                                _AmountSyncError := true;
            until _QuoteLine.NEXT = 0;

        if not _AmountSyncError then
            exit;

        NS_SyncSalesQuoteLines(_QuoteHeader);

        if _QuoteLine.FINDSET(false) then
            repeat
                if (_QuoteLine."NS_Sales Quote No." <> '') and (_QuoteLine."NS_Sales Quote Line No." <> 0) then
                    if _SalesLine.GET(_SalesLine."Document Type"::Quote, _QuoteLine."NS_Sales Quote No.", _QuoteLine."NS_Sales Quote Line No.") then
                        if ROUND(_SalesLine."Line Amount", 0.01) <> ROUND(_QuoteLine.NS_Amount, 0.01) then
                            with _EventLogEntry do
                                NewEventLogEntry('AMTSYNC'
                                                , "NS_Object Type"::Codeunit
                                                , CODEUNIT::"NS_Job Quote Mgt."
                                                , NS_Status::Message
                                                , STRSUBSTNO(_Text000
                                                           , _SalesLine."Document No."
                                                           , FORMAT(_SalesLine."Line No.")
                                                           , FORMAT(_SalesLine.Type)
                                                           , _SalesLine."No."
                                                           , FORMAT(_SalesLine."Line Amount")
                                                           , _QuoteLine."NS_Quote No."
                                                           , FORMAT(_QuoteLine.NS_Amount))
                                                , ''
                                                , false
                                                , '');
            until _QuoteLine.NEXT = 0;
    end;

    procedure NS_ArchiveRevision(qQuoteHeader: Record "NS_Job Quote Header");
    var
        qQuoteLine: Record "NS_Job Quote Line";
        ArchiveHeader: Record "NS_Job Quote Header Archive";
        ArchiveLine: Record "NS_Job Quote Line Archive";
        ArchiveTask: Record "NS_Archived Quote Task";
        ArchivePlanLine: Record "NS_Archived QuotePlanningLine";
        ArchiveSOW: Record "NS_Archived Quote ScopeofWork";
        ArchiveSegment: Record "NS_Archived Quote Segments";
        PlanLine: Record "Job Planning Line";
        JobTask: Record "Job Task";
        SOW: Record "NS_Job Quote Scope of Work";
        Segment: Record "NS_Job Takeoff Segments";
    begin
        ArchiveHeader.INIT;
        ArchiveHeader.TRANSFERFIELDS(qQuoteHeader, false);
        ArchiveHeader."NS_Quote No." := qQuoteHeader."NS_Quote No.";
        ArchiveHeader.NS_Revision := qQuoteHeader.NS_Revision;
        //ArchiveHeader."NS_Job No." := ArchiveHeader."NS_Quote No.";//PRJ-279.MS.1.0 comment
        ArchiveHeader."NS_Job No." := ArchiveHeader."NS_Job No."; //PRJ-279.MS.1.0
        ArchiveHeader.NS_Archived := CURRENTDATETIME;
        ArchiveHeader.INSERT;

        qQuoteLine.RESET;
        qQuoteLine.SETRANGE("NS_Quote No.", qQuoteHeader."NS_Quote No.");
        if qQuoteLine.FINDFIRST then
            repeat
                ArchiveLine.INIT;
                ArchiveLine.TRANSFERFIELDS(qQuoteLine, false);
                ArchiveLine."NS_Quote No." := qQuoteLine."NS_Quote No.";
                ArchiveLine."NS_Quote Line No." := qQuoteLine."NS_Quote Line No.";
                ArchiveLine.NS_Revision := qQuoteLine.NS_Revision;
                ArchiveLine.INSERT;
            until qQuoteLine.NEXT = 0;

        //PRJ-774.AS.1.0 07JULY2021 - START Commented old code & move hole functionality to a function NS_MovePlanninglinedatatoArchive()
        // PlanLine.RESET;
        // PlanLine.SETRANGE("Job No.", qQuoteHeader."NS_Job No."); //PRJ-279.MS.1.0
        // //PlanLine.SETRANGE("NS_Quote No.", qQuoteHeader."NS_Quote No.");  //PRJ-279.MS.1.0 comment
        // if PlanLine.FINDSET then
        //     repeat
        //         ArchivePlanLine.INIT;
        //         ArchivePlanLine.TRANSFERFIELDS(PlanLine);
        //         ArchivePlanLine.NS_Revision := qQuoteHeader.NS_Revision;
        //         ArchivePlanLine.INSERT;
        //     until PlanLine.NEXT = 0;
        //PRJ-774.AS.1.0 07JULY2021 - END

        NS_MovePlanninglinedatatoArchive(qQuoteHeader);//PRJ-774.AS.1.0 07JULY2021
        JobTask.RESET;
        JobTask.SETRANGE("NS_Quote No.", qQuoteHeader."NS_Quote No.");
        if JobTask.FINDSET then
            repeat
                ArchiveTask.INIT;
                ArchiveTask.TRANSFERFIELDS(JobTask);
                ArchiveTask.NS_Revision := qQuoteHeader.NS_Revision;
                ArchiveTask.INSERT;
            until JobTask.NEXT = 0;

        SOW.RESET;
        SOW.SETRANGE("NS_Quote No.", qQuoteHeader."NS_Quote No.");
        if SOW.FINDSET then
            repeat
                ArchiveSOW.INIT;
                ArchiveSOW.TRANSFERFIELDS(SOW);
                ArchiveSOW.NS_Revision := qQuoteHeader.NS_Revision;
                ArchiveSOW.INSERT;
            until SOW.NEXT = 0;

        Segment.RESET;
        Segment.SETRANGE("NS_Job No.", qQuoteHeader."NS_Quote No.");
        if Segment.FINDSET then
            repeat
                ArchiveSegment.INIT;
                //ArchiveSegment.TRANSFERFIELDS(Segment);//PRJ-774.AS.1.0 - Commented
                //PRJ-774.AS.1.0 - start
                ArchiveSegment.NS_Type := Segment.NS_Type;
                ArchiveSegment."NS_Job No." := Segment."NS_Job No.";
                ArchiveSegment."NS_Segment Code" := Segment."NS_Segment Code";
                ArchiveSegment."NS_Segment Name" := Segment."NS_Segment Name";
                ArchiveSegment."NS_Job No." := Segment."NS_Job No.";
                ArchiveSegment."NS_Is Total" := Segment."NS_Is Total";
                ArchiveSegment."NS_Size of Weld" := Segment."NS_Size of Weld";
                ArchiveSegment."NS_Weld Time (Hours)" := Segment."NS_Weld Time (Hours)";
                ArchiveSegment.NS_Default := Segment.NS_Default;
                ArchiveSegment."NS_Schedule (Total Cost)" := Segment."NS_Schedule (Total Cost)";
                ArchiveSegment."NS_Schedule (Total Price)" := Segment."NS_Schedule (Total Price)";
                ArchiveSegment."NS_Remaining (Total Cost)" := Segment."NS_Remaining (Total Cost)";
                ArchiveSegment."NS_Remaining (Total Price)" := Segment."NS_Remaining (Total Price)";
                ArchiveSegment."NS_Amt. Rcd. Not Invoiced" := Segment."NS_Amt. Rcd. Not Invoiced";
                ArchiveSegment."NS_Mark-up" := Segment."NS_Mark-up";
                ArchiveSegment."NS_Gross Profit" := Segment."NS_Gross Profit";
                ArchiveSegment."NS_Gross Profit Percent" := Segment."NS_Gross Profit Percent";
                ArchiveSegment."NS_Line Amount Incl. Tax" := Segment."NS_Line Amount Incl. Tax";
                ArchiveSegment."NS_Total Contract Price" := Segment."NS_Total Contract Price";
                ArchiveSegment."NS_Template No." := Segment."NS_Template No.";
                ArchiveSegment."NS_Work Units" := Segment."NS_Work Units";
                ArchiveSegment."NS_Work Unit of Measure" := Segment."NS_Work Unit of Measure";
                //PRJ-774.AS.1.0 - end
                ArchiveSegment.NS_Revision := qQuoteHeader.NS_Revision;
                ArchiveSegment.INSERT;
            until Segment.NEXT = 0;
    end;

    procedure NS_Assign(_QuoteHeader: Record "NS_Job Quote Header");
    var
        _QuoteHeader2: Record "NS_Job Quote Header";
        _User: Record User;
        _Text000: Label 'Quote %1 was assigned to %2.';
    begin
        // if PAGE.RUNMODAL(PAGE::Users,_User) <> ACTION::LookupOK then
        //   exit;

        _QuoteHeader2.GET(_QuoteHeader."NS_Quote No.");
        _QuoteHeader2."NS_Salesperson/User ID" := _User."User Name";
        _QuoteHeader2.MODIFY;
        MESSAGE(_Text000, _QuoteHeader."NS_Quote No.", _User."User Name");
    end;

    procedure NS_CalcBaseQty(_QuoteLine: Record "NS_Job Quote Line"; _Qty: Decimal): Decimal;
    begin
        with _QuoteLine do begin
            TESTFIELD("NS_Qty. per Unit of Measure");
            exit(ROUND(_Qty * "NS_Qty. per Unit of Measure", 0.00001));
        end;
    end;

    procedure NS_CalcAmounts(var Rec: Record "Job Task"; xRec: Record "Job Task"; CalcOpt: Option MarkUp,Margin,Pct);
    var
        QuoteTaskLine: Record "Job Task";
        QuotePlanLine: Record "Job Planning Line";
    begin
        GLSetup.GET;
        case CalcOpt of
            CalcOpt::MarkUp:
                NS_CalcAmountsFromMarkup(Rec, xRec);
            CalcOpt::Margin:
                NS_CalcAmountsFromMargin(Rec, xRec);
            CalcOpt::Pct:
                NS_CalcAmountsFromPercent(Rec, xRec);
        end;
    end;

    procedure NS_CalcSegmentAmounts(var Rec: Record "NS_Job Takeoff Segments"; xRec: Record "NS_Job Takeoff Segments"; CalcOpt: Option MarkUp,Margin,Pct,ContractPrice);
    var
        QuoteTaskLine: Record "Job Task";
        QuotePlanLine: Record "Job Planning Line";
        JobSegment: Record "NS_Job Takeoff Segments";
    begin
        GLSetup.GET;
        case CalcOpt of
            CalcOpt::MarkUp:
                NS_CalcSegAmountsFromMarkup(Rec, xRec);
            CalcOpt::Margin:
                NS_CalcSegAmountsFromMargin(Rec, xRec);
            CalcOpt::Pct:
                NS_CalcSegAmountsFromPercent(Rec, xRec);
            CalcOpt::ContractPrice:
                NS_CalcSegAmountsFromContractPrice(Rec, xRec);
        end;
    end;

    local procedure NS_CalcAmountsFromMargin(var Rec: Record "Job Task"; xRec: Record "Job Task");
    var
        AmtDelta: Decimal;
        AmtTotal: Decimal;
        QuotePlanLine: Record "Job Planning Line";
        RecCt: Integer;
        QtyTotal: Decimal;
        CostRecs: Integer;
        tmpQuotePlanLine: Record "Job Planning Line" temporary;
        CostTotal: Decimal;
        PlanLineRscQty: Decimal;
    begin
        with Rec do begin
            AmtTotal := "Schedule (Total Price)";
            AmtDelta := "NS_Gross Profit" - xRec."NS_Gross Profit";
            CostTotal := "Schedule (Total Cost)";
            QuotePlanLine.RESET;
            QuotePlanLine.SETRANGE("Job No.", "Job No.");
            QuotePlanLine.SETFILTER("Job Task No.", Totaling);
            QuotePlanLine.CALCSUMS(Quantity, "Quantity (Base)");
            QtyTotal := QuotePlanLine.Quantity;
            RecCt := QuotePlanLine.COUNT;

            if (not "NS_Quantity Weighted") and (not "NS_Cost Weighted") then begin
                if QuotePlanLine.FINDSET(true, false) then begin
                    repeat
                        tmpQuotePlanLine := QuotePlanLine;
                        tmpQuotePlanLine.INSERT;
                        if QuotePlanLine.Quantity <> 0 then begin //*
                            if QuotePlanLine.Type <> QuotePlanLine.Type::Resource then begin
                                QuotePlanLine."Unit Price" := QuotePlanLine."Unit Cost" +
                                                            ROUND(("NS_Gross Profit" / QtyTotal), GLSetup."Amount Rounding Precision");
                                QuotePlanLine."Total Price" := ROUND((QuotePlanLine."Unit Price" * QuotePlanLine.Quantity), GLSetup."Amount Rounding Precision");
                                QuotePlanLine.VALIDATE("Line Amount", QuotePlanLine."Unit Price" * QuotePlanLine.Quantity);
                                if QuotePlanLine."Unit Cost" > QuotePlanLine."Unit Price" then
                                    CostRecs += 1;
                                QuotePlanLine.MODIFY;
                            end;

                        end;
                    until QuotePlanLine.NEXT = 0;
                end;
            end;

            if "NS_Quantity Weighted" then begin
                if QuotePlanLine.FINDSET(true, false) then begin
                    repeat
                        tmpQuotePlanLine := QuotePlanLine;
                        tmpQuotePlanLine.INSERT;

                        QuotePlanLine."Unit Price" := QuotePlanLine."Unit Cost" +
                                                      ROUND("NS_Gross Profit" / QtyTotal, GLSetup."Amount Rounding Precision");

                        QuotePlanLine."Total Price" := ROUND((QuotePlanLine."Unit Price" * QuotePlanLine.Quantity), GLSetup."Amount Rounding Precision");
                        QuotePlanLine.VALIDATE("Line Amount", QuotePlanLine."Unit Price" * QuotePlanLine.Quantity);
                        if QuotePlanLine."Unit Cost (LCY)" > QuotePlanLine."Unit Price (LCY)" then
                            CostRecs += 1;
                        QuotePlanLine.MODIFY;
                    until QuotePlanLine.NEXT = 0;
                end;
            end;

            if "NS_Cost Weighted" then begin
                if QuotePlanLine.FINDSET(true, false) then begin
                    repeat
                        tmpQuotePlanLine := QuotePlanLine;
                        tmpQuotePlanLine.INSERT;

                        if QuotePlanLine.Quantity = 1 then
                            QuotePlanLine."Unit Price" := QuotePlanLine."Unit Cost" +
                                                          ROUND("NS_Gross Profit" * (QuotePlanLine."Total Price" / AmtTotal), GLSetup."Amount Rounding Precision")
                        else
                            QuotePlanLine."Unit Price" := QuotePlanLine."Unit Cost" +
                                                          ROUND(("NS_Gross Profit" * ((QuotePlanLine."Total Price" / AmtTotal)) / QuotePlanLine.Quantity), GLSetup."Amount Rounding Precision");

                        QuotePlanLine."Unit Price" := ROUND(QuotePlanLine."Unit Price", GLSetup."Amount Rounding Precision");
                        QuotePlanLine."Total Price" := ROUND((QuotePlanLine."Unit Price" * QuotePlanLine.Quantity), GLSetup."Amount Rounding Precision");
                        QuotePlanLine.VALIDATE("Line Amount", QuotePlanLine."Unit Price" * QuotePlanLine.Quantity);
                        if QuotePlanLine."Unit Cost (LCY)" > QuotePlanLine."Unit Price (LCY)" then
                            CostRecs += 1;
                        QuotePlanLine.MODIFY;
                    until QuotePlanLine.NEXT = 0;
                end;
            end;

            if CostRecs <> 0 then begin
                if not CONFIRM(Text14021400Lbl, true, CostRecs) then begin
                    tmpQuotePlanLine.RESET;
                    if tmpQuotePlanLine.FINDSET(false, false) then
                        repeat
                            QuotePlanLine.RESET;
                            QuotePlanLine.SETRANGE("Job No.", tmpQuotePlanLine."Job No.");
                            QuotePlanLine.SETRANGE("Job Task No.", tmpQuotePlanLine."Job Task No.");
                            QuotePlanLine.SETRANGE("Line No.", tmpQuotePlanLine."Line No.");
                            if QuotePlanLine.FINDFIRST then begin
                                QuotePlanLine.DELETE;
                                COMMIT;
                                QuotePlanLine := tmpQuotePlanLine;
                                QuotePlanLine.INSERT;
                            end;
                        until tmpQuotePlanLine.NEXT = 0;
                end;
            end;
            CALCFIELDS("Schedule (Total Cost)", "Schedule (Total Price)");
            if "Schedule (Total Price)" <> 0 then begin
                "NS_Mark-up" := (("Schedule (Total Price)" - "Schedule (Total Cost)") / "Schedule (Total Cost)") * 100;
                "NS_Gross Profit Percentage" := (1 - "Schedule (Total Cost)" / "Schedule (Total Price)") * 100;
                MODIFY;
            end else begin
                "NS_Mark-up" := 0;
                "NS_Gross Profit Percentage" := 0;
                MODIFY;
            end;
        end;
    end;

    local procedure NS_CalcSegAmountsFromMargin(var Rec: Record "NS_Job Takeoff Segments"; xRec: Record "NS_Job Takeoff Segments");
    var
        AmtDelta: Decimal;
        AmtTotal: Decimal;
        QuotePlanLine: Record "Job Planning Line";
        RecCt: Integer;
        QtyTotal: Decimal;
        CostRecs: Integer;
        tmpQuotePlanLine: Record "Job Planning Line" temporary;
        CostTotal: Decimal;
        PlanLineRscQty: Decimal;
        TotalPrice: Decimal;
    begin
        with Rec do begin
            AmtTotal := "NS_Schedule (Total Price)";
            AmtDelta := "NS_Gross Profit" - xRec."NS_Gross Profit";
            CostTotal := "NS_Schedule (Total Cost)";
            QuotePlanLine.RESET;
            QuotePlanLine.SETRANGE("Job No.", "NS_Job No.");
            QuotePlanLine.SETRANGE("NS_Segment Code", "NS_Segment Code");
            QuotePlanLine.CALCSUMS(Quantity, "Quantity (Base)");
            QtyTotal := QuotePlanLine.Quantity;
            RecCt := QuotePlanLine.COUNT;

            if QuotePlanLine.FINDSET(true, false) then begin
                repeat
                    tmpQuotePlanLine := QuotePlanLine;
                    tmpQuotePlanLine.INSERT;
                    if QuotePlanLine.Quantity <> 0 then begin //*
                        if QuotePlanLine.Type <> QuotePlanLine.Type::Resource then begin
                            QuotePlanLine."Unit Price" := QuotePlanLine."Unit Cost" +
                                                        ROUND(("NS_Gross Profit" / QtyTotal), GLSetup."Amount Rounding Precision");

                            QuotePlanLine."Total Price" := ROUND((QuotePlanLine."Unit Price" * QuotePlanLine.Quantity), GLSetup."Amount Rounding Precision");
                            QuotePlanLine.VALIDATE("Line Amount", QuotePlanLine."Unit Price" * QuotePlanLine.Quantity);
                            if QuotePlanLine."Unit Cost" > QuotePlanLine."Unit Price" then
                                CostRecs += 1;
                            QuotePlanLine.MODIFY;
                        end;

                    end;
                until QuotePlanLine.NEXT = 0;
            end;

            if CostRecs <> 0 then begin
                if not CONFIRM(Text14021400Lbl, true, CostRecs) then begin
                    tmpQuotePlanLine.RESET;
                    if tmpQuotePlanLine.FINDSET(false, false) then
                        repeat
                            QuotePlanLine.RESET;
                            QuotePlanLine.SETRANGE("Job No.", tmpQuotePlanLine."Job No.");
                            QuotePlanLine.SETRANGE("Job Task No.", tmpQuotePlanLine."Job Task No.");
                            QuotePlanLine.SETRANGE("Line No.", tmpQuotePlanLine."Line No.");
                            if QuotePlanLine.FINDFIRST then begin
                                QuotePlanLine.DELETE;
                                COMMIT;
                                QuotePlanLine := tmpQuotePlanLine;
                                QuotePlanLine.INSERT;
                            end;
                        until tmpQuotePlanLine.NEXT = 0;
                end;
            end;

            CALCFIELDS("NS_Schedule (Total Cost)");
            "NS_Mark-up" := ("NS_Gross Profit" / "NS_Schedule (Total Cost)") * 100;
            "NS_Total Contract Price" := "NS_Schedule (Total Cost)" * (1 + ("NS_Mark-up" / 100));
            NS_UpdateSegmentAmounts(Rec);

        end;
    end;

    local procedure NS_CalcAmountsFromMarkup(var Rec: Record "Job Task"; xRec: Record "Job Task");
    var
        MarkupDelta: Decimal;
        AmtTotal: Decimal;
        QuotePlanLine: Record "Job Planning Line";
        RecCt: Integer;
        QtyTotal: Decimal;
        CostRecs: Integer;
        tmpQuotePlanLine: Record "Job Planning Line" temporary;
        PlanLineRscQty: Decimal;
    begin
        with Rec do begin
            AmtTotal := "Schedule (Total Price)";
            MarkupDelta := "NS_Mark-up" - xRec."NS_Mark-up";
            QuotePlanLine.RESET;
            QuotePlanLine.SETRANGE("Job No.", "Job No.");
            QuotePlanLine.SETFILTER("Job Task No.", Totaling);
            QuotePlanLine.CALCSUMS(Quantity, "Quantity (Base)");
            QtyTotal := QuotePlanLine.Quantity;
            RecCt := QuotePlanLine.COUNT;

            if (not "NS_Quantity Weighted") and (not "NS_Cost Weighted") then begin
                if QuotePlanLine.FINDSET(true, false) then begin
                    repeat
                        tmpQuotePlanLine := QuotePlanLine;
                        tmpQuotePlanLine.INSERT;
                        if QuotePlanLine.Quantity > 0 then begin
                            if QuotePlanLine.Type <> QuotePlanLine.Type::Resource then begin
                                QuotePlanLine."Unit Price" := ROUND((("NS_Mark-up" / 100) * QuotePlanLine."Unit Cost" +
                                                              QuotePlanLine."Unit Cost"), GLSetup."Amount Rounding Precision");

                                QuotePlanLine."Total Price" := ROUND(QuotePlanLine."Unit Price" * QuotePlanLine.Quantity, GLSetup."Amount Rounding Precision");
                                QuotePlanLine.VALIDATE("Line Amount", QuotePlanLine."Unit Price" * QuotePlanLine.Quantity);
                                if QuotePlanLine."Unit Cost" > QuotePlanLine."Unit Price" then
                                    CostRecs += 1;
                                QuotePlanLine.MODIFY;
                            end;

                        end;
                    until QuotePlanLine.NEXT = 0;
                end;
            end;

            if "NS_Quantity Weighted" then begin
                if QuotePlanLine.FINDSET(true, false) then begin
                    repeat
                        tmpQuotePlanLine := QuotePlanLine;
                        tmpQuotePlanLine.INSERT;

                        if QuotePlanLine.Quantity = 1 then
                            QuotePlanLine."Unit Price" := ROUND((("NS_Mark-up" / 100) * QuotePlanLine."Unit Cost" +
                                                          QuotePlanLine."Unit Cost"), GLSetup."Amount Rounding Precision")
                        else
                            QuotePlanLine."Unit Price" := QuotePlanLine."Unit Cost" + ROUND(((("NS_Mark-up" / 100) * QuotePlanLine."Unit Cost" +
                                                          QuotePlanLine."Unit Cost") / QtyTotal) / QuotePlanLine.Quantity, GLSetup."Amount Rounding Precision");

                        QuotePlanLine."Total Price" := ROUND(QuotePlanLine."Total Price" * QuotePlanLine.Quantity, GLSetup."Amount Rounding Precision");
                        QuotePlanLine.VALIDATE("Line Amount", QuotePlanLine."Unit Price" * QuotePlanLine.Quantity);
                        if QuotePlanLine."Unit Cost (LCY)" > QuotePlanLine."Unit Price (LCY)" then
                            CostRecs += 1;
                        QuotePlanLine.MODIFY;
                    until QuotePlanLine.NEXT = 0;
                end;
            end;

            if "NS_Cost Weighted" then begin
                if QuotePlanLine.FINDSET(true, false) then begin
                    repeat
                        tmpQuotePlanLine := QuotePlanLine;
                        tmpQuotePlanLine.INSERT;
                        if QuotePlanLine.Quantity > 0 then begin
                            if QuotePlanLine.Quantity = 1 then
                                QuotePlanLine."Unit Price" := (("NS_Mark-up" / 100) * QuotePlanLine."Unit Cost" + QuotePlanLine."Unit Cost") / AmtTotal
                            else
                                QuotePlanLine."Unit Price" := ((("NS_Mark-up" / 100) * QuotePlanLine."Unit Cost" + QuotePlanLine."Unit Cost") / AmtTotal) / QuotePlanLine."Unit Price";

                            QuotePlanLine."Total Price" := ROUND(QuotePlanLine."Total Price", GLSetup."Amount Rounding Precision");
                            QuotePlanLine."Unit Price" := ROUND((QuotePlanLine."Total Price" / QuotePlanLine.Quantity), GLSetup."Amount Rounding Precision");
                            QuotePlanLine.VALIDATE("Line Amount", QuotePlanLine."Unit Price" * QuotePlanLine.Quantity);
                            if QuotePlanLine."Unit Cost (LCY)" > QuotePlanLine."Unit Price (LCY)" then
                                CostRecs += 1;
                            QuotePlanLine.MODIFY;
                        end;
                    until QuotePlanLine.NEXT = 0;
                end;
            end;

            if CostRecs <> 0 then begin
                if not CONFIRM(Text14021401Lbl, true, CostRecs) then begin
                    tmpQuotePlanLine.RESET;
                    if tmpQuotePlanLine.FINDSET(false, false) then
                        repeat
                            QuotePlanLine.RESET;
                            QuotePlanLine.SETRANGE("Job No.", tmpQuotePlanLine."Job No.");
                            QuotePlanLine.SETRANGE("Job Task No.", tmpQuotePlanLine."Job Task No.");
                            QuotePlanLine.SETRANGE("Line No.", tmpQuotePlanLine."Line No.");
                            if QuotePlanLine.FINDFIRST then begin
                                QuotePlanLine.DELETE;
                                COMMIT;
                                QuotePlanLine := tmpQuotePlanLine;
                                QuotePlanLine.INSERT;
                            end;
                        until tmpQuotePlanLine.NEXT = 0;
                end;
            end;
            CALCFIELDS("Schedule (Total Cost)", "Schedule (Total Price)");
            if "Schedule (Total Price)" <> 0 then begin
                "NS_Gross Profit" := "Schedule (Total Price)" - "Schedule (Total Cost)";
                "NS_Gross Profit Percentage" := (1 - "Schedule (Total Cost)" / "Schedule (Total Price)") * 100;
                MODIFY;
            end else begin
                "NS_Gross Profit" := 0;
                "NS_Gross Profit Percentage" := 0;
                MODIFY;
            end;
        end;
    end;

    local procedure NS_CalcSegAmountsFromMarkup(var Rec: Record "NS_Job Takeoff Segments"; xRec: Record "NS_Job Takeoff Segments");
    var
        MarkupDelta: Decimal;
        AmtTotal: Decimal;
        QuotePlanLine: Record "Job Planning Line";
        RecCt: Integer;
        QtyTotal: Decimal;
        CostRecs: Integer;
        tmpQuotePlanLine: Record "Job Planning Line" temporary;
        PlanLineRscQty: Decimal;
        TotalPrice: Decimal;
    begin
        with Rec do begin
            AmtTotal := "NS_Schedule (Total Price)";
            MarkupDelta := "NS_Mark-up" - xRec."NS_Mark-up";
            QuotePlanLine.RESET;
            QuotePlanLine.SETRANGE("Job No.", "NS_Job No.");
            QuotePlanLine.SETRANGE("NS_Segment Code", "NS_Segment Code");
            QuotePlanLine.CALCSUMS(Quantity, "Quantity (Base)");
            QtyTotal := QuotePlanLine.Quantity;
            RecCt := QuotePlanLine.COUNT;

            if QuotePlanLine.FINDSET(true, false) then begin
                repeat
                    tmpQuotePlanLine := QuotePlanLine;
                    tmpQuotePlanLine.INSERT;
                    if QuotePlanLine.Quantity > 0 then begin
                        if (QuotePlanLine.Type <> QuotePlanLine.Type::Text) and (QuotePlanLine."Unit Cost" <> 0) then begin
                            QuotePlanLine."Unit Price" := ROUND((("NS_Mark-up" / 100) * QuotePlanLine."Unit Cost" +
                                                        QuotePlanLine."Unit Cost"), GLSetup."Amount Rounding Precision");

                            QuotePlanLine."Total Price" := ROUND(QuotePlanLine."Unit Price" * QuotePlanLine.Quantity, GLSetup."Amount Rounding Precision");
                            QuotePlanLine.VALIDATE("Line Amount", QuotePlanLine."Unit Price" * QuotePlanLine.Quantity);
                            if QuotePlanLine."Unit Cost" > QuotePlanLine."Unit Price" then
                                CostRecs += 1;
                            QuotePlanLine.MODIFY;
                        end;

                    end;
                until QuotePlanLine.NEXT = 0;
            end;

            if CostRecs <> 0 then begin
                if not CONFIRM(Text14021401Lbl, true, CostRecs) then begin
                    tmpQuotePlanLine.RESET;
                    if tmpQuotePlanLine.FINDSET(false, false) then
                        repeat
                            QuotePlanLine.RESET;
                            QuotePlanLine.SETRANGE("Job No.", tmpQuotePlanLine."Job No.");
                            QuotePlanLine.SETRANGE("Job Task No.", tmpQuotePlanLine."Job Task No.");
                            QuotePlanLine.SETRANGE("Line No.", tmpQuotePlanLine."Line No.");
                            if QuotePlanLine.FINDFIRST then begin
                                QuotePlanLine.DELETE;
                                COMMIT;
                                QuotePlanLine := tmpQuotePlanLine;
                                QuotePlanLine.INSERT;
                            end;
                        until tmpQuotePlanLine.NEXT = 0;
                end;
            end;

            CALCFIELDS("NS_Schedule (Total Cost)");
            "NS_Total Contract Price" := "NS_Schedule (Total Cost)" * (1 + ("NS_Mark-up" / 100));
            NS_UpdateSegmentAmounts(Rec);
        end;
    end;

    local procedure NS_CalcAmountsFromPercent(var Rec: Record "Job Task"; xRec: Record "Job Task");
    var
        PercentDelta: Decimal;
        AmtTotal: Decimal;
        QuotePlanLine: Record "Job Planning Line";
        RecCt: Integer;
        QtyTotal: Decimal;
        CostRecs: Integer;
        tmpQuotePlanLine: Record "Job Planning Line" temporary;
        PlanLineRscQty: Decimal;
        JQHdr: Record "NS_Job Quote Header";//PRJ-1443.AS.1.0
    begin
        //PRJ-1170.NK.1.0 Start
        //with Rec do begin
        AmtTotal := Rec."Schedule (Total Price)";
        PercentDelta := Rec."NS_Gross Profit Percentage" - xRec."NS_Gross Profit Percentage";
        QuotePlanLine.RESET();
        QuotePlanLine.SETRANGE("Job No.", Rec."Job No.");
        QuotePlanLine.SETFILTER("Job Task No.", Rec.Totaling);
        QuotePlanLine.CALCSUMS(Quantity, "Quantity (Base)");
        QtyTotal := QuotePlanLine.Quantity;
        RecCt := QuotePlanLine.COUNT();

        if (not Rec."NS_Quantity Weighted") and (not Rec."NS_Cost Weighted") then begin
            if QuotePlanLine.FINDSET(true, false) then begin
                repeat
                    tmpQuotePlanLine := QuotePlanLine;
                    tmpQuotePlanLine.INSERT();
                    if QuotePlanLine.Quantity > 0 then begin

                        if JQHdr.Get(QuotePlanLine."Job No.") then;//PRJ-1443.AS.1.0

                        //PRJ-1443.AS.1.0 START
                        if JQHdr.NS_EnblGLNResGMCalc = false then begin
                            //OLD PROJECTPRO CONDITION START Code ..Putted Inside false condition of NS_EnblGLNResGMCalc
                            if QuotePlanLine.Type <> QuotePlanLine.Type::Resource then begin
                                //PRJ-1443.AS.1.0 -- START Commented Old
                                // QuotePlanLine."Unit Price" := ROUND(QuotePlanLine."Unit Cost" / (1 - (Rec."NS_Gross Profit Percentage" / 100)), GLSetup."Amount Rounding Precision");
                                // QuotePlanLine."Total Price" := ROUND(QuotePlanLine."Unit Price" * QuotePlanLine.Quantity, GLSetup."Amount Rounding Precision");
                                // QuotePlanLine.VALIDATE("Line Amount", QuotePlanLine."Unit Price");
                                // if QuotePlanLine."Unit Cost" > QuotePlanLine."Unit Price" then
                                //     CostRecs += 1;
                                //PRJ-1443.AS.1.0 -- END Commented Old

                                //PRJ-1443.AS.1.0 -- START done code
                                QuotePlanLine."Unit Price" := ROUND(QuotePlanLine."Unit Cost" / (1 - (Rec."NS_Gross Profit Percentage" / 100)), GLSetup."Amount Rounding Precision");
                                QuotePlanLine."Total Price" := ROUND(QuotePlanLine."Unit Price" * QuotePlanLine.Quantity, GLSetup."Amount Rounding Precision");
                                QuotePlanLine.VALIDATE("Line Amount", QuotePlanLine.Quantity * QuotePlanLine."Unit Price");
                                if QuotePlanLine."Unit Cost" > QuotePlanLine."Unit Price" then
                                    CostRecs += 1;
                                //PRJ-1443.AS.1.0 -- END done code
                                QuotePlanLine.MODIFY();
                            end;
                            //OLD PROJECTPRO CONDITION END ..Putted Inside false condition of NS_EnblGLNResGMCalc
                        end;

                        if JQHdr.NS_EnblGLNResGMCalc = true then begin
                            //PRJ-1443.AS.1.0 -- START Commented Old
                            // QuotePlanLine."Unit Price" := ROUND(QuotePlanLine."Unit Cost" / (1 - (Rec."NS_Gross Profit Percentage" / 100)), GLSetup."Amount Rounding Precision");
                            // QuotePlanLine."Total Price" := ROUND(QuotePlanLine."Unit Price" * QuotePlanLine.Quantity, GLSetup."Amount Rounding Precision");
                            // QuotePlanLine.VALIDATE("Line Amount", QuotePlanLine."Unit Price");
                            // if QuotePlanLine."Unit Cost" > QuotePlanLine."Unit Price" then
                            //     CostRecs += 1;
                            //PRJ-1443.AS.1.0 -- END Commented Old

                            //PRJ-1443.AS.1.0 -- START done code
                            QuotePlanLine."Unit Price" := ROUND(QuotePlanLine."Unit Cost" / (1 - (Rec."NS_Gross Profit Percentage" / 100)), GLSetup."Amount Rounding Precision");
                            QuotePlanLine."Total Price" := ROUND(QuotePlanLine."Unit Price" * QuotePlanLine.Quantity, GLSetup."Amount Rounding Precision");
                            QuotePlanLine.VALIDATE("Line Amount", QuotePlanLine.Quantity * QuotePlanLine."Unit Price");
                            if QuotePlanLine."Unit Cost" > QuotePlanLine."Unit Price" then
                                CostRecs += 1;
                            //PRJ-1443.AS.1.0 -- END done code
                            QuotePlanLine.MODIFY();
                        end;
                        //PRJ-1443.AS.1.0 -- START CODE BLOCKED
                        // end else begin
                        //     QuotePlanLine."Unit Price" := ROUND(QuotePlanLine."Unit Cost" / (1 - (Rec."NS_Gross Profit Percentage" / 100)), GLSetup."Amount Rounding Precision");
                        //     QuotePlanLine."Total Price" := ROUND(QuotePlanLine."Unit Price" * PlanLineRscQty, GLSetup."Amount Rounding Precision");
                        //     QuotePlanLine.VALIDATE("Line Amount", QuotePlanLine."Unit Price");
                        //     if QuotePlanLine."Unit Cost" > QuotePlanLine."Unit Price" then
                        //         CostRecs += 1;
                        //     QuotePlanLine.MODIFY();
                        // end;
                        //PRJ-1443.AS.1.0 -- END CODE BLOCKED


                        //PRJ-1443.AS.1.0 END
                    end;
                until QuotePlanLine.NEXT() = 0;
            end;
        end;

        if Rec."NS_Quantity Weighted" then begin
            if QuotePlanLine.FINDSET(true, false) then begin
                repeat
                    tmpQuotePlanLine := QuotePlanLine;
                    tmpQuotePlanLine.INSERT();
                    //PRJ-1443.AS.1.0 -- START Commented Old
                    // QuotePlanLine."Unit Price" := ROUND(((1 + Rec."NS_Gross Profit" / 100) * (QuotePlanLine.Quantity / QtyTotal)) *
                    //                                   QuotePlanLine."Unit Cost", GLSetup."Amount Rounding Precision");

                    // QuotePlanLine."Total Price" := ROUND(QuotePlanLine."Total Price", GLSetup."Amount Rounding Precision");
                    // QuotePlanLine."Unit Price" := ROUND((QuotePlanLine."Total Price" / QuotePlanLine.Quantity), GLSetup."Amount Rounding Precision");
                    // QuotePlanLine.VALIDATE("Line Amount", QuotePlanLine."Unit Price" * QuotePlanLine.Quantity);
                    // if QuotePlanLine."Unit Cost (LCY)" > QuotePlanLine."Unit Price (LCY)" then
                    //     CostRecs += 1;
                    //PRJ-1443.AS.1.0 -- END Commented Old

                    //PRJ-1443.AS.1.0 -- START done code
                    QuotePlanLine."Unit Price" := ROUND(QuotePlanLine."Unit Cost" / (1 - (Rec."NS_Gross Profit Percentage" / 100)), GLSetup."Amount Rounding Precision");
                    QuotePlanLine."Total Price" := ROUND(QuotePlanLine."Unit Price" * QuotePlanLine.Quantity, GLSetup."Amount Rounding Precision");
                    QuotePlanLine.VALIDATE("Line Amount", QuotePlanLine.Quantity * QuotePlanLine."Unit Price");
                    if QuotePlanLine."Unit Cost" > QuotePlanLine."Unit Price" then
                        CostRecs += 1;
                    //PRJ-1443.AS.1.0 -- END done code
                    QuotePlanLine.MODIFY();
                until QuotePlanLine.NEXT() = 0;
            end;
        end;

        if Rec."NS_Cost Weighted" then begin
            if QuotePlanLine.FINDSET(true, false) then begin
                repeat
                    tmpQuotePlanLine := QuotePlanLine;
                    tmpQuotePlanLine.INSERT();
                    //PRJ-1443.AS.1.0 -- START Commented Old
                    // QuotePlanLine."Unit Price" := ROUND(((1 + Rec."NS_Gross Profit" / 100) * (QuotePlanLine."Total Price" / AmtTotal)) *
                    //                                   QuotePlanLine."Unit Cost", GLSetup."Amount Rounding Precision");

                    // QuotePlanLine."Total Price" := ROUND(QuotePlanLine."Total Price", GLSetup."Amount Rounding Precision");
                    // QuotePlanLine."Unit Price" := ROUND((QuotePlanLine."Total Price" / QuotePlanLine.Quantity), GLSetup."Amount Rounding Precision");
                    // QuotePlanLine.VALIDATE("Line Amount", QuotePlanLine."Unit Price" * QuotePlanLine.Quantity);
                    // if QuotePlanLine."Unit Cost (LCY)" > QuotePlanLine."Unit Price (LCY)" then
                    //     CostRecs += 1;
                    //PRJ-1443.AS.1.0 -- END Commented Old

                    //PRJ-1443.AS.1.0 -- START done code
                    QuotePlanLine."Unit Price" := ROUND(QuotePlanLine."Unit Cost" / (1 - (Rec."NS_Gross Profit Percentage" / 100)), GLSetup."Amount Rounding Precision");
                    QuotePlanLine."Total Price" := ROUND(QuotePlanLine."Unit Price" * QuotePlanLine.Quantity, GLSetup."Amount Rounding Precision");
                    QuotePlanLine.VALIDATE("Line Amount", QuotePlanLine.Quantity * QuotePlanLine."Unit Price");
                    if QuotePlanLine."Unit Cost" > QuotePlanLine."Unit Price" then
                        CostRecs += 1;
                    //PRJ-1443.AS.1.0 -- END done code
                    QuotePlanLine.MODIFY();
                until QuotePlanLine.NEXT() = 0;
            end;
        end;

        if CostRecs <> 0 then begin
            if not CONFIRM(Text14021402Lbl, true, CostRecs) then begin
                tmpQuotePlanLine.RESET();
                if tmpQuotePlanLine.FINDSET(false, false) then
                    repeat
                        QuotePlanLine.RESET();
                        QuotePlanLine.SETRANGE("Job No.", tmpQuotePlanLine."Job No.");
                        QuotePlanLine.SETRANGE("Job Task No.", tmpQuotePlanLine."Job Task No.");
                        QuotePlanLine.SETRANGE("Line No.", tmpQuotePlanLine."Line No.");
                        if QuotePlanLine.FINDFIRST() then begin
                            QuotePlanLine.DELETE();
                            COMMIT();
                            QuotePlanLine := tmpQuotePlanLine;
                            QuotePlanLine.INSERT();
                        end;
                    until tmpQuotePlanLine.NEXT() = 0;
            end;
        end;
        Rec.CALCFIELDS("Schedule (Total Cost)", "Schedule (Total Price)");
        if Rec."Schedule (Total Price)" <> 0 then begin
            Rec."NS_Mark-up" := ((Rec."Schedule (Total Price)" - Rec."Schedule (Total Cost)") / Rec."Schedule (Total Cost)") * 100;
            Rec."NS_Gross Profit" := Rec."Schedule (Total Price)" - Rec."Schedule (Total Cost)";
            Rec.MODIFY();
        end else begin
            Rec."NS_Mark-up" := 0;
            Rec."NS_Gross Profit" := 0;
            Rec.MODIFY();
        end;
        //end;
        //PRJ-1170.NK.1.0 End
    end;

    local procedure NS_CalcSegAmountsFromPercent(var Rec: Record "NS_Job Takeoff Segments"; xRec: Record "NS_Job Takeoff Segments");
    var
        PercentDelta: Decimal;
        AmtTotal: Decimal;
        QuotePlanLine: Record "Job Planning Line";
        RecCt: Integer;
        QtyTotal: Decimal;
        CostRecs: Integer;
        tmpQuotePlanLine: Record "Job Planning Line" temporary;
        PlanLineRscQty: Decimal;
        TotalPrice: Decimal;
        JQHdr: Record "NS_Job Quote Header";//PRJ-1443.AS.1.0
    begin
        //PRJ-1170.NK.1.0 Start
        //with Rec do begin
        AmtTotal := Rec."NS_Schedule (Total Price)";
        PercentDelta := Rec."NS_Gross Profit Percent" - xRec."NS_Gross Profit Percent";
        QuotePlanLine.RESET();
        QuotePlanLine.SETRANGE("Job No.", Rec."NS_Job No.");
        QuotePlanLine.SETRANGE("NS_Segment Code", Rec."NS_Segment Code");
        QuotePlanLine.CALCSUMS(Quantity, "Quantity (Base)");
        QtyTotal := QuotePlanLine.Quantity;
        RecCt := QuotePlanLine.COUNT();

        if QuotePlanLine.FINDSET(true, false) then begin
            repeat
                tmpQuotePlanLine := QuotePlanLine;
                tmpQuotePlanLine.INSERT();
                if QuotePlanLine.Quantity > 0 then begin

                    if JQHdr.Get(QuotePlanLine."Job No.") then;//PRJ-1443.AS.1.0
                                                               //PRJ-1443.AS.1.0 START
                    if JQHdr.NS_EnblGLNResGMCalc = false then begin
                        //OLD PROJECTPRO CONDITION START Code ..Putted Inside false condition of NS_EnblGLNResGMCalc
                        if QuotePlanLine.Type <> QuotePlanLine.Type::Resource then begin
                            QuotePlanLine."Unit Price" := ROUND(QuotePlanLine."Unit Cost" / (1 - (Rec."NS_Gross Profit Percent" / 100)), GLSetup."Amount Rounding Precision");
                            QuotePlanLine."Total Price" := ROUND(QuotePlanLine."Unit Price" * QuotePlanLine.Quantity, GLSetup."Amount Rounding Precision");
                            //QuotePlanLine.VALIDATE("Line Amount", QuotePlanLine."Unit Price");//PRJ-1206.AS.1.0 18FEB2022 COMMENT
                            QuotePlanLine.VALIDATE("Line Amount", QuotePlanLine.Quantity * QuotePlanLine."Unit Price");//PRJ-1206.AS.1.0 18FEB2022 ADDED
                            if QuotePlanLine."Unit Cost" > QuotePlanLine."Unit Price" then
                                CostRecs += 1;
                            QuotePlanLine.MODIFY();
                        end;
                        //OLD PROJECTPRO CONDITION END Code ..Putted Inside false condition of NS_EnblGLNResGMCalc
                    end;

                    if JQHdr.NS_EnblGLNResGMCalc = true then begin
                        QuotePlanLine."Unit Price" := ROUND(QuotePlanLine."Unit Cost" / (1 - (Rec."NS_Gross Profit Percent" / 100)), GLSetup."Amount Rounding Precision");
                        QuotePlanLine."Total Price" := ROUND(QuotePlanLine."Unit Price" * QuotePlanLine.Quantity, GLSetup."Amount Rounding Precision");
                        QuotePlanLine.VALIDATE("Line Amount", QuotePlanLine.Quantity * QuotePlanLine."Unit Price");
                        if QuotePlanLine."Unit Cost" > QuotePlanLine."Unit Price" then
                            CostRecs += 1;
                        QuotePlanLine.MODIFY();
                    end;
                    //PRJ-1443.AS.1.0 END
                end;
            until QuotePlanLine.NEXT() = 0;
        end;

        if CostRecs <> 0 then begin
            if not CONFIRM(Text14021402Lbl, true, CostRecs) then begin
                tmpQuotePlanLine.RESET();
                if tmpQuotePlanLine.FINDSET(false, false) then
                    repeat
                        QuotePlanLine.RESET();
                        QuotePlanLine.SETRANGE("Job No.", tmpQuotePlanLine."Job No.");
                        QuotePlanLine.SETRANGE("Job Task No.", tmpQuotePlanLine."Job Task No.");
                        QuotePlanLine.SETRANGE("Line No.", tmpQuotePlanLine."Line No.");
                        if QuotePlanLine.FINDFIRST() then begin
                            QuotePlanLine.DELETE();
                            COMMIT();
                            QuotePlanLine := tmpQuotePlanLine;
                            QuotePlanLine.INSERT();
                        end;
                    until tmpQuotePlanLine.NEXT() = 0;
            end;
        end;

        Rec.CALCFIELDS("NS_Schedule (Total Cost)");
        Rec."NS_Total Contract Price" := Rec."NS_Schedule (Total Cost)" / (1 - (Rec."NS_Gross Profit Percent" / 100));
        NS_UpdateSegmentAmounts(Rec);
        //end;
        //PRJ-1170.NK.1.0 End
    end;

    procedure NS_CalcSegProfitAmounts(var JobTakeoffSegment: Record "NS_Job Takeoff Segments"; FieldChanged: Text[20]);
    var
        Markup: Label 'Markup';
        GrossProfit: Label 'GrossProfit';
        GrossProfitPercent: Label 'GrossProfitPercent';
        BasicCost: Decimal;
        BasicPrice: Decimal;
        BasicProfit: Decimal;
    begin
        with JobTakeoffSegment do begin
            BasicCost := "NS_Schedule (Total Cost)";
            BasicPrice := "NS_Schedule (Total Price)";
            BasicProfit := BasicPrice - BasicCost;
            case FieldChanged of
                Markup:
                    begin
                        if "NS_Mark-up" <> 0 then
                            "NS_Gross Profit" := ROUND(BasicCost * "NS_Mark-up" / 100, 0.01)
                        else
                            "NS_Gross Profit" := BasicProfit;

                        if BasicCost + "NS_Gross Profit" <> 0 then
                            "NS_Gross Profit Percent" := ROUND((1 - (BasicCost / (BasicCost + "NS_Gross Profit"))) * 100, 0.01)
                        else
                            "NS_Gross Profit Percent" := 0;
                    end;
                GrossProfit:
                    begin
                        "NS_Mark-up" := ROUND("NS_Gross Profit" / BasicCost, 0.01) * 100;
                        if BasicCost + "NS_Gross Profit" <> 0 then
                            "NS_Gross Profit Percent" := ROUND((1 - (BasicCost / (BasicCost + "NS_Gross Profit"))) * 100, 0.01)
                        else
                            "NS_Gross Profit Percent" := 0
                    end;
                GrossProfitPercent:
                    begin
                        "NS_Gross Profit" := ROUND((BasicCost / (1 - "NS_Gross Profit Percent" / 100)) - BasicCost, 0.01);
                        "NS_Mark-up" := ROUND(("NS_Gross Profit" / BasicCost) * 100, 0.01);
                    end;
            end;
        end;
    end;

    procedure NS_CalcProfitAmounts(JobNo: Code[20]; JobTaskNo: Code[20]; PlanLine: Record "Job Planning Line");
    var
        qJobTask: Record "Job Task";
        MinTotal: Text[250];
        MaxTotal: Text[250];
        Text00001: Label '..';
        TotalCost: Decimal;
        TotalPrice: Decimal;
        qPlanLine: Record "Job Planning Line";
    begin
        if not NS_CheckTaskTotals(JobNo, JobTaskNo) then
            exit;
        qJobTask.SETRANGE("Job No.", JobNo);
        qJobTask.SETRANGE("Job Task No.", JobTaskNo);
        if qJobTask.FINDFIRST then
            repeat
                qJobTask.SETRANGE("Job Task No.");
                qJobTask.NEXT;
            until qJobTask."Job Task Type" = qJobTask."Job Task Type"::"End-Total";

        qPlanLine.RESET;
        qPlanLine.SETRANGE("Job No.", JobNo);
        qPlanLine.SETFILTER("Job Task No.", qJobTask.Totaling);
        qPlanLine.SETFILTER("Line No.", '<>%1', PlanLine."Line No.");
        if qPlanLine.FINDSET then
            repeat
                TotalPrice += qPlanLine."Line Amount (LCY)";
                TotalCost += qPlanLine."Total Cost (LCY)";
            until qPlanLine.NEXT = 0;
        TotalCost += PlanLine."Total Cost (LCY)";
        TotalPrice += PlanLine."Line Amount (LCY)";

        if (TotalPrice <> 0) and (TotalCost <> 0) then begin
            qJobTask."NS_Mark-up" := ((TotalPrice - TotalCost) / TotalCost) * 100;
            qJobTask."NS_Gross Profit" := TotalPrice - TotalCost;
            qJobTask."NS_Gross Profit Percentage" := ((TotalPrice - TotalCost) / TotalPrice) * 100;
            qJobTask.MODIFY;
        end else begin
            qJobTask."NS_Mark-up" := 0;
            qJobTask."NS_Gross Profit" := 0;
            qJobTask."NS_Gross Profit Percentage" := 0;
            qJobTask.MODIFY;
        end;
    end;

    //PRJ-1120.AS.1.0 START
    procedure NS_CalcProfitAmounts4Totals(JobNo: Code[20]; JobTaskNo: Code[20]);
    var
        JTaskLines: Record "Job Task";
    begin
        JTaskLines.Reset();
        JTaskLines.SetRange("Job No.", JobNo);
        JTaskLines.SetRange("Job Task Type", JTaskLines."Job Task Type"::Total);
        if JTaskLines.FindFirst() then begin
            JTaskLines.CalcFields("Schedule (Total Cost)", "Schedule (Total Price)");

            if (JTaskLines."Schedule (Total Price)" <> 0) and (JTaskLines."Schedule (Total Cost)" <> 0) then begin
                JTaskLines."NS_Mark-up" := ((JTaskLines."Schedule (Total Price)" - JTaskLines."Schedule (Total Cost)") / JTaskLines."Schedule (Total Cost)") * 100;
                JTaskLines."NS_Gross Profit" := JTaskLines."Schedule (Total Price)" - JTaskLines."Schedule (Total Cost)";
                JTaskLines."NS_Gross Profit Percentage" := ((JTaskLines."Schedule (Total Price)" - JTaskLines."Schedule (Total Cost)") / JTaskLines."Schedule (Total Price)") * 100;
                JTaskLines.MODIFY;
            end else begin
                JTaskLines."NS_Mark-up" := 0;
                JTaskLines."NS_Gross Profit" := 0;
                JTaskLines."NS_Gross Profit Percentage" := 0;
                JTaskLines.MODIFY;
            end;

        end;
    end;
    //PRJ-1120.AS.1.0 END

    procedure NS_CalcSegmentProfitAmounts(JobNo: Code[20]; SegmentDrawingCode: Code[20]);
    var
        qJobTask: Record "Job Task";
        MinTotal: Text[250];
        MaxTotal: Text[250];
        Text00001: Label '..';
        TotalCost: Decimal;
        TotalPrice: Decimal;
        qJobSegment: Record "NS_Job Takeoff Segments";
    begin
        qJobSegment.Reset();   //PRJCTPR-319.JS.1.0
        qJobSegment.SETRANGE("NS_Job No.", JobNo);
        if SegmentDrawingCode <> '' then
            qJobSegment.SETRANGE("NS_Segment Code", SegmentDrawingCode);

        if qJobSegment.FINDSET(true, false) then
            repeat
                if qJobSegment."NS_Freeze Total Contract Price" = false then   //PRJCTPR-319.JS.1.0 07MAR2024
                    NS_UpdateSegmentAmounts(qJobSegment);
            until qJobSegment.NEXT = 0;
    end;

    procedure NS_ContractPriceFoundForSalesLine(var _SalesLine: Record "Sales Line");
    var
        _SalesHeader: Record "Sales Header";
        _PriceMgt: Codeunit "NS_Job Quote Price Mgt.";
    begin
        with _SalesLine do begin
            "NS_Contract Price Found" := false;
            if _SalesHeader.GET(_SalesLine."Document Type", _SalesLine."Document No.") then
                if _PriceMgt.NS_FindSalesLinePrice(_SalesHeader
                                               , _SalesLine
                                               , _SalesLine.FIELDNO(Quantity)
                                               , "NS_Contract Price Found") <> 0 then
                    ;
        end;
    end;

    procedure NS_ConvertToJob(var _QuoteHeader: Record "NS_Job Quote Header"; _DetailContractLines: Boolean);
    var
        _Text000: Label 'Quote has not yet been accepted.  Are you sure you want to continue?';
        _Contact: Record Contact;
        _ContactBusRel: Record "Contact Business Relation";
        _Customer: Record Customer;
        _DefDim: Record "Default Dimension";
        _DimSetEntry: Record "Dimension Set Entry";
        _GenLedgSetup: Record "General Ledger Setup";
        _Item: Record Item;
        _ItemCategory: Record "Item Category";
        _Job: Record Job;
        _JobContact: Record "NS_Job Contact";
        _JobPlanningLine: Record "Job Planning Line";
        _JobPlanningLine2: Record "Job Planning Line";
        _JobsSetup: Record "Jobs Setup";
        _JobTask: Record "Job Task";
        _QuoteInstallImportLine: Record "NS_Job Quote Import Line";
        _QuoteInstallJobsSetup: Record "NS_Job Quote Install";
        _QuoteInstallJobsSetupSvc: Record "NS_Job Quote Install";
        _QuoteLine: Record "NS_Job Quote Line";
        _QuoteSetup: Record "Jobs Setup";
        _Resource: Record Resource;
        _SalesHeader: Record "Sales Header";
        _TempBuf: Record "Aging Band Buffer" temporary;
        _InstallTasksExist: Boolean;
        _ServiceTaskExists: Boolean;
        _DimMgt: Codeunit DimensionManagement;
        _NoSeriesMgt: Codeunit NoSeriesManagement;
        _ReleaseSalesDoc: Codeunit "Release Sales Document";
        _CostCategoryCode: Code[10];
        _JobNo: Code[20];
        _JobNoSeries: Code[10];
        _RevenueCategoryCode: Code[10];
        _SyncQuoteNo: Code[20];
        _Total: Decimal;
        _TotalSalesTax: Decimal;
        _TotalUseTax: Decimal;
        _LineNo: Integer;
        _JobTakeoffSegments: Record "NS_Job Takeoff Segments";
    begin
        _QuoteSetup.GET;
        _QuoteSetup.TESTFIELD("NS_ResourceNo. forContractLine");
        _QuoteSetup.TESTFIELD("NS_Install Category Code");
        _QuoteSetup.TESTFIELD("NS_ResourceNo. forContractLine");
        NS_TestFieldsRequiredForConversion(_QuoteHeader);

        _QuoteHeader.TESTFIELD(NS_Template, false);
        _QuoteHeader.TESTFIELD("NS_Job No.", '');

        NS_QuotingCheck(_QuoteHeader);

        _GenLedgSetup.GET;
        _GenLedgSetup.TESTFIELD("NS_G/L Job Sales Tax Acc. No.");

        _JobsSetup.GET;

        with _QuoteHeader do
            //PE-300-DK.1.0 29May2024 Start
            // if _QuoteHeader.NS_Status <> _QuoteHeader.NS_Status::Accepted 
            if _QuoteHeader."NS_Quote Status" <> _QuoteHeader."NS_Quote Status"::Accepted then
                //PE-300-DK.1.0 29May2024 End
                if not CONFIRM(_Text000, false) then
                    exit;


        _SyncQuoteNo := NS_GetNoPortion(_QuoteHeader."NS_Quote No.");
        if _QuoteSetup."Job Nos." <> '' then
            _JobNoSeries := _QuoteSetup."Job Nos."
        else begin
            _JobsSetup.GET;
            _JobsSetup.TESTFIELD("Job Nos.");
            _JobNoSeries := _JobsSetup."Job Nos.";
        end;
        _JobNo := _NoSeriesMgt.GetNextNo(_JobNoSeries, TODAY, true);
        _JobNo := NS_GetNonNoPortion(_JobNo);
        _JobNo := _JobNo + _SyncQuoteNo;

        // create job

        with _Job do begin
            INIT;
            "No." := _JobNo;
            NS_SetHideValidationDialog(true);
            _Job."Apply Usage Link" := _JobsSetup."Apply Usage Link by Default";
            if not _Job.FIND then
                INSERT(true)
            else
                MODIFY(true);
            if _QuoteHeader."NS_Job Class" <> _QuoteHeader."NS_Job Class"::" " then begin
                "NS_Job Class" := _QuoteHeader."NS_Job Class";
                if _QuoteHeader."NS_Sub-Level to Job No." <> '' then
                    VALIDATE("NS_Sub-Level to Job No.", _QuoteHeader."NS_Sub-Level to Job No.");
            end;
            VALIDATE(Description, UPPERCASE(_QuoteHeader."NS_Description/Nickname"));
            VALIDATE("Bill-to Customer No.", _QuoteHeader."NS_Bill-to Customer No.");
            VALIDATE(NS_Estimator, _QuoteHeader."NS_Estimator No.");
            if _QuoteHeader."NS_Owner No." <> '' then begin
                _ContactBusRel.SETRANGE("Contact No.", _QuoteHeader."NS_Owner No.");
                _ContactBusRel.SETRANGE("Link to Table", _ContactBusRel."Link to Table"::Customer);
                if _ContactBusRel.FINDFIRST then
                    if _Customer.GET(_ContactBusRel."No.") then
                        VALIDATE("NS_Owner No.", _ContactBusRel."No.");
            end;
            VALIDATE("NS_Job Site Customer No.", _QuoteHeader."NS_Sell-to Customer No.");
            //"NS_Salesperson Code" := _QuoteHeader."NS_Salesperson Code"; //PRJ-867.AS.1.0 23SEPT2021 Comment
            "NS_Salesperson Code" := _QuoteHeader."NS_Salesperson Code New";//PRJ-867.AS.1.0 23SEPT2021 Changed field Sales Person code to Sales person code New
            VALIDATE("NS_General Contractor No.", _QuoteHeader."NS_General Contractor No.");
            VALIDATE("NS_Architect/Engineer No.", _QuoteHeader."NS_Architect/Engineer No.");
            VALIDATE("NS_Project Manager No.", _QuoteHeader."NS_Project Manager No.");
            VALIDATE("Person Responsible", _QuoteHeader."NS_Project Manager No.");
            NS_Manager := _QuoteHeader."NS_Project Manager No.";
            "NS_Estimated Start Date" := _QuoteHeader."NS_Estimated Start Date";
            "Starting Date" := _QuoteHeader."NS_Estimated Start Date";
            "NS_Estimated Completion Date" := _QuoteHeader."NS_Estimated Completion Date";
            "Ending Date" := _QuoteHeader."NS_Estimated Completion Date";
            Status := Status::Planning;
            if _QuoteHeader."NS_Certified Payroll" = _QuoteHeader."NS_Certified Payroll"::Yes then
                "NS_Requires Certified Payroll" := true;
            NS_Bond := _QuoteHeader.NS_Bond;
            //PRJCTPR-197 Dk.1.0 Start
            // _Job."NS_Job Type" := _QuoteHeader."NS_Job Type Code";
            _Job."NS_Job Type New" := _QuoteHeader."NS_Job Type Code";
            //PRJCTPR-197 Dk.1.0 End
            "NS_Billing Cutoff Day of Month" := _QuoteHeader."NS_Billing Cutoff Day of Month";
            "NS_CCIP/OCIP/RCOIP Insurance" := _QuoteHeader."NS_CCIP/OCIP/RCOIP Insurance";
            "NS_Lien Waiver Required" := _QuoteHeader."NS_Lien Waiver Required";
            "Global Dimension 1 Code" := _QuoteHeader."NS_Shortcut Dimension 1 Code";
            "Global Dimension 2 Code" := _QuoteHeader."NS_Shortcut Dimension 2 Code";
            "NS_Quote No." := _QuoteHeader."NS_Quote No.";
            "NS_Customer PO Number" := _QuoteHeader."NS_External Document No.";
            "NS_Default Job Retention" := _QuoteHeader."NS_Retainage %";
            MODIFY;
        end;

        if _QuoteHeader."NS_Contact No." <> '' then
            with _JobContact do begin
                INIT;
                "NS_Job No." := _Job."No.";
                NS_Type := NS_Type::Owner;
                NS_Code := COPYSTR(_QuoteHeader."NS_Contact No.", 1, MAXSTRLEN(NS_Code));
                NS_Name := COPYSTR(_QuoteHeader."NS_Contact Name", 1, MAXSTRLEN(NS_Name));
                if _Contact.GET(_QuoteHeader."NS_Contact No.") then begin
                    if NS_Name = '' then
                        NS_Name := COPYSTR(_Contact.Name, 1, MAXSTRLEN(NS_Name));
                    "NS_Name 2" := COPYSTR(_Contact."Name 2", 1, MAXSTRLEN("NS_Name 2"));
                    NS_Address := COPYSTR(_Contact.Address, 1, MAXSTRLEN(NS_Address));
                    "NS_Address 2" := COPYSTR(_Contact."Address 2", 1, MAXSTRLEN("NS_Address 2"));
                    NS_City := COPYSTR(_Contact.City, 1, MAXSTRLEN(NS_City));
                    NS_County := COPYSTR(_Contact.County, 1, MAXSTRLEN(NS_County));
                    "NS_Post Code" := COPYSTR(_Contact."Post Code", 1, MAXSTRLEN("NS_Post Code"));
                    "NS_Primary Phone No." := COPYSTR(_Contact."Phone No.", 1, MAXSTRLEN("NS_Primary Phone No."));
                    "NS_Primary Fax No." := COPYSTR(_Contact."Fax No.", 1, MAXSTRLEN("NS_Primary Fax No."));
                    "NS_Primary e-Mail" := COPYSTR(_Contact."E-Mail", 1, MAXSTRLEN("NS_Primary e-Mail"));
                    "NS_Primary Home Page" := COPYSTR(_Contact."Home Page", 1, MAXSTRLEN("NS_Primary Home Page"));
                end;
                INSERT;
            end;
        if (_QuoteHeader."NS_General Contractor No." <> '') or (_QuoteHeader."NS_General Contractor Name" <> '') then
            with _JobContact do begin
                INIT;
                "NS_Job No." := _Job."No.";
                NS_Type := NS_Type::"General Contractor";
                NS_Code := COPYSTR(_QuoteHeader."NS_General Contractor No.", 1, MAXSTRLEN(NS_Code));
                NS_Name := COPYSTR(_QuoteHeader."NS_General Contractor Name", 1, MAXSTRLEN(NS_Name));
                if _Contact.GET(_QuoteHeader."NS_General Contractor No.") then begin
                    if NS_Name = '' then
                        NS_Name := COPYSTR(_Contact.Name, 1, MAXSTRLEN(NS_Name));
                    "NS_Name 2" := COPYSTR(_Contact."Name 2", 1, MAXSTRLEN("NS_Name 2"));
                    NS_Address := COPYSTR(_Contact.Address, 1, MAXSTRLEN(NS_Address));
                    "NS_Address 2" := COPYSTR(_Contact."Address 2", 1, MAXSTRLEN("NS_Address 2"));
                    NS_City := COPYSTR(_Contact.City, 1, MAXSTRLEN(NS_City));
                    NS_County := COPYSTR(_Contact.County, 1, MAXSTRLEN(NS_County));
                    "NS_Post Code" := COPYSTR(_Contact."Post Code", 1, MAXSTRLEN("NS_Post Code"));
                    "NS_Primary Phone No." := COPYSTR(_Contact."Phone No.", 1, MAXSTRLEN("NS_Primary Phone No."));
                    "NS_Primary Fax No." := COPYSTR(_Contact."Fax No.", 1, MAXSTRLEN("NS_Primary Fax No."));
                    "NS_Primary e-Mail" := COPYSTR(_Contact."E-Mail", 1, MAXSTRLEN("NS_Primary e-Mail"));
                    "NS_Primary Home Page" := COPYSTR(_Contact."Home Page", 1, MAXSTRLEN("NS_Primary Home Page"));
                end;
                INSERT;
            end;

        if _QuoteHeader."NS_Bill-to Customer No." <> '' then
            with _JobContact do begin
                INIT;
                "NS_Job No." := _Job."No.";
                NS_Type := NS_Type::Owner;
                if STRLEN(_QuoteHeader."NS_Bill-to Customer No.") > MAXSTRLEN(NS_Code) then
                    NS_Code := 'BILL-TO'   // code length is 10 (Project Pro table/field)
                else
                    NS_Code := _QuoteHeader."NS_Bill-to Customer No.";
                NS_Name := COPYSTR(_QuoteHeader."NS_Bill-to Customer Name", 1, MAXSTRLEN(NS_Name));
                if _Customer.GET(_QuoteHeader."NS_Bill-to Customer No.") then begin
                    if NS_Name = '' then
                        NS_Name := COPYSTR(_Customer.Name, 1, MAXSTRLEN(NS_Name));
                    "NS_Name 2" := COPYSTR(_Customer."Name 2", 1, MAXSTRLEN("NS_Name 2"));
                    NS_Address := COPYSTR(_Customer.Address, 1, MAXSTRLEN(NS_Address));
                    "NS_Address 2" := COPYSTR(_Customer."Address 2", 1, MAXSTRLEN("NS_Address 2"));
                    NS_City := COPYSTR(_Customer.City, 1, MAXSTRLEN(NS_City));
                    NS_County := COPYSTR(_Customer.County, 1, MAXSTRLEN(NS_County));
                    "NS_Post Code" := COPYSTR(_Customer."Post Code", 1, MAXSTRLEN("NS_Post Code"));
                    "NS_Primary Phone No." := COPYSTR(_Customer."Phone No.", 1, MAXSTRLEN("NS_Primary Phone No."));
                    "NS_Primary Fax No." := COPYSTR(_Customer."Fax No.", 1, MAXSTRLEN("NS_Primary Fax No."));
                    "NS_Primary e-Mail" := COPYSTR(_Customer."E-Mail", 1, MAXSTRLEN("NS_Primary e-Mail"));
                    "NS_Primary Home Page" := COPYSTR(_Customer."Home Page", 1, MAXSTRLEN("NS_Primary Home Page"));
                end;
                INSERT;
            end;

        // dimensions

        if _QuoteHeader."NS_Dimension Set ID" <> 0 then begin
            _DefDim.SETRANGE("Table ID", DATABASE::Job);
            _DefDim.SETRANGE("No.", _Job."No.");
            _DimSetEntry.SETRANGE("Dimension Set ID", _QuoteHeader."NS_Dimension Set ID");
            if _DimSetEntry.FINDSET(false) then
                repeat
                    _DefDim.SETRANGE("Dimension Code", _DimSetEntry."Dimension Code");
                    if _DefDim.FINDFIRST then begin
                        _DefDim."Dimension Value Code" := _DimSetEntry."Dimension Value Code";
                        _DefDim.MODIFY;
                    end else
                        with _DefDim do begin
                            INIT;
                            "Table ID" := DATABASE::Job;
                            "No." := _Job."No.";
                            "Dimension Code" := _DimSetEntry."Dimension Code";
                            "Dimension Value Code" := _DimSetEntry."Dimension Value Code";
                            INSERT;
                        end;
                until _DimSetEntry.NEXT = 0;
        end;

        // compile categories

        CLEAR(_TempBuf);
        _TempBuf.DELETEALL;
        _QuoteLine.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        if _QuoteLine.FINDSET(false) then
            repeat
                _TempBuf.SETRANGE("Currency Code", _QuoteLine."NS_Category Code");
                if _TempBuf.ISEMPTY then
                    with _TempBuf do begin
                        INIT;
                        "Currency Code" := _QuoteLine."NS_Category Code";
                        INSERT;
                    end;
            until _QuoteLine.NEXT = 0;

        // create beginning and ending job tasks

        with _JobTask do begin
            INIT;
            "Job No." := _JobNo;
            "Job Task No." := '10000';
            "Job Task Type" := "Job Task Type"::"Begin-Total";
            //"Job Posting Group" := _QuoteHeader."NS_Job Posting Group";//PRJ-993.AS.1.0 18OCT2021 comment old code for field "NS_Job Posting Group" for Job Quote header
            "Job Posting Group" := _QuoteHeader."NS_Job Posting Group New";//PRJ-993.AS.1.0 18OCT2021 Add new code for field "NS_Job Posting Group New" for Job Quote header
            Description := 'BEGIN JOB';
            INSERT(true);
            INIT;
            "Job No." := _JobNo;
            "Job Task No." := '90000';
            "Job Task Type" := "Job Task Type"::"End-Total";
            if EVALUATE(Totaling, '10000..90000') then;
            //"Job Posting Group" := _QuoteHeader."NS_Job Posting Group";//PRJ-993.AS.1.0 18OCT2021 comment old code for field "NS_Job Posting Group" for Job Quote header
            "Job Posting Group" := _QuoteHeader."NS_Job Posting Group New";//PRJ-993.AS.1.0 18OCT2021 Add new code for field "NS_Job Posting Group New" for Job Quote header
            Description := 'END JOB';
            INSERT(true);
        end;

        // create job tasks on a per-category basis

        _TempBuf.SETRANGE("Currency Code");
        if _TempBuf.FINDSET(false) then
            repeat
                _JobTask.INIT;
                _JobTask."Job No." := _JobNo;
                if _TempBuf."Currency Code" = '' then
                    _JobTask."Job Task No." := 'UNCAT'
                else
                    _JobTask."Job Task No." := _TempBuf."Currency Code";
                if _ItemCategory.GET(_TempBuf."Currency Code") then
                    _JobTask.Description := UPPERCASE(COPYSTR(_ItemCategory.Description, 1, MAXSTRLEN(_JobTask.Description)));
                //_JobTask."Job Posting Group" := _QuoteHeader."NS_Job Posting Group";//PRJ-993.AS.1.0 18OCT2021 comment old code for field "NS_Job Posting Group" for Job Quote header
                _JobTask."Job Posting Group" := _QuoteHeader."NS_Job Posting Group New";//PRJ-993.AS.1.0 18OCT2021 Add new code for field "NS_Job Posting Group New" for Job Quote header
                _JobTask.Indentation := 1;
                _JobTask.INSERT;
            until _TempBuf.NEXT = 0;

        // determine whether service task exists

        _QuoteInstallImportLine.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        _QuoteInstallImportLine.SETFILTER("NS_Line No.", '500000');
        _QuoteInstallImportLine.SETFILTER("NS_Column 6 Value", '<>%1&<>%2', '', '0');
        _ServiceTaskExists := not _QuoteInstallImportLine.ISEMPTY;

        // determine whether installation tasks exist

        _QuoteInstallImportLine.SETFILTER("NS_Line No.", '>190000');
        _QuoteInstallImportLine.SETFILTER("NS_Column 1 Value", '<>Service&<>SERVICE');
        _InstallTasksExist := not _QuoteInstallImportLine.ISEMPTY;

        // get configuration information for service line

        _QuoteInstallJobsSetupSvc.SETFILTER(NS_Type, '%1|%2', 'Service', 'SERVICE');
        if not _QuoteInstallJobsSetupSvc.FINDFIRST then
            _QuoteInstallJobsSetupSvc.INIT;

        // create job planning lines

        if _TempBuf.FINDSET(false) then
            repeat
                _QuoteLine.SETRANGE("NS_Category Code", _TempBuf."Currency Code");
                CLEAR(_LineNo);
                CLEAR(_Total);
                CLEAR(_TotalSalesTax);
                CLEAR(_TotalUseTax);
                if _QuoteLine.FINDSET(false) then
                    repeat

                        // insert job planning lines if Category Code <> Install Category Code *OR*
                        //   no defined installation tasks exist

                        if (_TempBuf."Currency Code" <> _QuoteSetup."NS_Install Category Code") or
                           (not _InstallTasksExist)
                        then begin

                            _LineNo += 10000;
                            _JobPlanningLine.INIT;
                            _JobPlanningLine."Job No." := _JobNo;
                            if _TempBuf."Currency Code" = '' then
                                _JobPlanningLine."Job Task No." := 'UNCAT'
                            else
                                _JobPlanningLine."Job Task No." := _TempBuf."Currency Code";  // currency code = category code
                            _JobPlanningLine."Line No." := _LineNo;
                            _JobPlanningLine."Usage Link" := _JobsSetup."Apply Usage Link by Default";
                            _JobPlanningLine.INSERT;
                            _JobPlanningLine.VALIDATE("Planning Date", WORKDATE);
                            case _QuoteLine.NS_Type of
                                _QuoteLine.NS_Type::"G/L Account":
                                    _JobPlanningLine.VALIDATE(Type, _JobPlanningLine.Type::"G/L Account");
                                _QuoteLine.NS_Type::Item:
                                    begin
                                        _JobPlanningLine.VALIDATE(Type, _JobPlanningLine.Type::Item);
                                        if _Item.GET(_QuoteLine."NS_No.") then begin
                                            _JobPlanningLine."NS_Cost Category" := _Item."NS_Job Cost Category";
                                            _CostCategoryCode := _Item."NS_Job Cost Category";
                                        end;
                                    end;
                                _QuoteLine.NS_Type::Resource:
                                    begin
                                        _JobPlanningLine.VALIDATE(Type, _JobPlanningLine.Type::Resource);
                                        if _Resource.GET(_QuoteLine."NS_No.") then begin
                                            _JobPlanningLine."NS_Cost Category" := _Resource."NS_Job Cost Category";
                                            _CostCategoryCode := _Resource."NS_Job Cost Category";
                                            _RevenueCategoryCode := _Resource."NS_Job Revenue Category";
                                        end;
                                    end;
                            end;
                            if _TempBuf."Currency Code" = _QuoteSetup."NS_Service Category Code" then
                                _JobPlanningLine.VALIDATE("No.", _QuoteSetup."NS_ResourceNo. forContractLine")
                            else
                                _JobPlanningLine.VALIDATE("No.", _QuoteLine."NS_No.");
                            if _QuoteLine.NS_Description <> _JobPlanningLine.Description then
                                _JobPlanningLine.Description := UPPERCASE(COPYSTR(_QuoteLine.NS_Description, 1, MAXSTRLEN(_JobPlanningLine.Description)));
                            if _QuoteLine."NS_Variant Code" <> '' then
                                _JobPlanningLine.VALIDATE("Variant Code", _QuoteLine."NS_Variant Code");
                            if _QuoteLine."NS_Unit of Measure Code" <> '' then
                                _JobPlanningLine.VALIDATE("Unit of Measure Code", _QuoteLine."NS_Unit of Measure Code");
                            if _QuoteHeader."NS_Location Code" <> '' then
                                _JobPlanningLine.VALIDATE("Location Code", _QuoteHeader."NS_Location Code");
                            if _QuoteLine."NS_Shortcut Dimension 1 Code" <> '' then
                                _JobPlanningLine.VALIDATE("NS_Shortcut Dimension 1 Code", _QuoteLine."NS_Shortcut Dimension 1 Code");
                            if _QuoteLine."NS_Shortcut Dimension 2 Code" <> '' then
                                _JobPlanningLine.VALIDATE("NS_Shortcut Dimension 2 Code", _QuoteLine."NS_Shortcut Dimension 2 Code");
                            if _QuoteLine.NS_Quantity <> 0 then
                                _JobPlanningLine.VALIDATE(Quantity, _QuoteLine.NS_Quantity);
                            if _QuoteLine."NS_Vendor Cost" <> 0 then
                                _JobPlanningLine."Direct Unit Cost (LCY)" := _QuoteLine."NS_Vendor Cost"
                            else
                                _JobPlanningLine."Direct Unit Cost (LCY)" := _QuoteLine."NS_Unit Cost";
                            if _QuoteLine."NS_Vendor Cost" <> 0 then
                                _JobPlanningLine.VALIDATE("Unit Cost (LCY)", _QuoteLine."NS_Vendor Cost")
                            else
                                if _QuoteLine."NS_Unit Cost" <> 0 then
                                    _JobPlanningLine.VALIDATE("Unit Cost (LCY)", _QuoteLine."NS_Unit Cost");
                            _JobPlanningLine.VALIDATE("Unit Price (LCY)", 0);
                            if _QuoteLine."NS_Amount Including VAT" <> 0 then
                                _TotalSalesTax += _QuoteLine."NS_Amount Including VAT" - _QuoteLine.NS_Amount;
                            _Total += _QuoteLine.NS_Amount;
                            if _TempBuf."Currency Code" = _QuoteSetup."NS_Service Category Code" then
                                if _QuoteInstallJobsSetupSvc."NS_Cost Category" <> '' then
                                    _JobPlanningLine."NS_Cost Category" := _QuoteInstallJobsSetupSvc."NS_Cost Category";
                            _JobPlanningLine."NS_Quote No." := _QuoteLine."NS_Quote No.";
                            _JobPlanningLine."NS_Quote Line No." := _QuoteLine."NS_Quote Line No.";
                            _JobPlanningLine."NS_Vendor No." := _QuoteLine."NS_Vendor No.";
                            _JobPlanningLine."NS_Vendor Quote No." := _QuoteLine."NS_Vendor Quote No.";
                            _JobPlanningLine."NS_Use Tax SKU" := _QuoteLine."NS_Use Tax SKU";
                            _JobPlanningLine."NS_Use Tax Amount" := _QuoteLine."NS_Use Tax Amount";
                            _TotalUseTax += _QuoteLine."NS_Use Tax Amount";
                            _JobPlanningLine.MODIFY;
                            _JobPlanningLine2 := _JobPlanningLine;

                            // create separate schedule line for use tax to be incorporated as part of overall job cost;
                            // this cannot be bundled into the previous schedule line because of product ordering.  Meredith 2/26/14
                            if _QuoteLine."NS_Use Tax Amount" <> 0 then begin
                                _LineNo += 10000;
                                _JobPlanningLine.INIT;
                                _JobPlanningLine."Job No." := _JobNo;
                                if _TempBuf."Currency Code" = '' then
                                    _JobPlanningLine."Job Task No." := 'UNCAT'
                                else
                                    _JobPlanningLine."Job Task No." := _TempBuf."Currency Code";
                                _JobPlanningLine."Line No." := _LineNo;
                                _JobPlanningLine."Usage Link" := _JobsSetup."Apply Usage Link by Default";
                                _JobPlanningLine.INSERT;
                                _JobPlanningLine.VALIDATE("Line Type", _JobPlanningLine."Line Type"::Billable);
                                _JobPlanningLine.VALIDATE("Planning Date", WORKDATE);
                                _JobPlanningLine.VALIDATE(Type, _JobPlanningLine.Type::"G/L Account");
                                _JobPlanningLine.VALIDATE("No.", _GenLedgSetup."NS_G/L Job Sales Tax Acc. No.");
                                _JobPlanningLine.Description := 'ACCRUED USE TAX';
                                if _QuoteHeader."NS_Shortcut Dimension 1 Code" <> '' then
                                    _JobPlanningLine.VALIDATE("NS_Shortcut Dimension 1 Code", _QuoteHeader."NS_Shortcut Dimension 1 Code");
                                if _QuoteHeader."NS_Shortcut Dimension 2 Code" <> '' then
                                    _JobPlanningLine.VALIDATE("NS_Shortcut Dimension 2 Code", _QuoteHeader."NS_Shortcut Dimension 2 Code");
                                _JobPlanningLine.VALIDATE(Quantity, 1);
                                _JobPlanningLine."Direct Unit Cost (LCY)" := _QuoteLine."NS_Use Tax Amount";
                                _JobPlanningLine.VALIDATE("Unit Cost (LCY)", _QuoteLine."NS_Use Tax Amount");
                                _JobPlanningLine.VALIDATE("Unit Price (LCY)", 0);
                                _JobPlanningLine.MODIFY;
                            end;

                            // create contract line if detail

                            if _DetailContractLines then begin
                                _LineNo += 10000;
                                _JobPlanningLine.INIT;
                                _JobPlanningLine."Job No." := _JobNo;
                                if _TempBuf."Currency Code" = '' then
                                    _JobPlanningLine."Job Task No." := 'UNCAT'
                                else
                                    _JobPlanningLine."Job Task No." := _TempBuf."Currency Code";
                                _JobPlanningLine."Line No." := _LineNo;
                                _JobPlanningLine."Usage Link" := _JobsSetup."Apply Usage Link by Default";
                                _JobPlanningLine.INSERT;
                                _JobPlanningLine.VALIDATE("Line Type", _JobPlanningLine."Line Type"::Billable);
                                _JobPlanningLine.VALIDATE("Planning Date", WORKDATE);
                                if (_TempBuf."Currency Code" = _QuoteSetup."NS_Service Category Code") and
                                   (_QuoteInstallJobsSetupSvc."NS_G/L Account No." <> '')
                                then begin
                                    _JobPlanningLine.VALIDATE(Type, _JobPlanningLine.Type::"G/L Account");
                                    _JobPlanningLine.VALIDATE("No.", _QuoteInstallJobsSetupSvc."NS_G/L Account No.");
                                end else begin
                                    _JobPlanningLine.VALIDATE(Type, _JobPlanningLine2.Type);
                                    _JobPlanningLine.VALIDATE("No.", _JobPlanningLine2."No.");
                                end;
                                if _QuoteLine.NS_Description <> _JobPlanningLine.Description then
                                    _JobPlanningLine.Description := UPPERCASE(COPYSTR(_QuoteLine.NS_Description, 1, MAXSTRLEN(_JobPlanningLine.Description)));
                                if _TempBuf."Currency Code" = _QuoteSetup."NS_Service Category Code" then
                                    if _ItemCategory.GET(_TempBuf."Currency Code") then
                                        _JobPlanningLine.Description := UPPERCASE(COPYSTR(_ItemCategory.Description, 1, MAXSTRLEN(_JobPlanningLine.Description)));
                                if _QuoteHeader."NS_Location Code" <> '' then
                                    _JobPlanningLine.VALIDATE("Location Code", _QuoteHeader."NS_Location Code");
                                if _QuoteLine."NS_Shortcut Dimension 1 Code" <> '' then
                                    _JobPlanningLine.VALIDATE("NS_Shortcut Dimension 1 Code", _QuoteLine."NS_Shortcut Dimension 1 Code");
                                if _QuoteLine."NS_Shortcut Dimension 2 Code" <> '' then
                                    _JobPlanningLine.VALIDATE("NS_Shortcut Dimension 2 Code", _QuoteLine."NS_Shortcut Dimension 2 Code");
                                _JobPlanningLine.VALIDATE(Quantity, 1);
                                if _QuoteLine."NS_Amount Including VAT" <> 0 then
                                    _JobPlanningLine.VALIDATE("Unit Price (LCY)", _QuoteLine."NS_Amount Including VAT")
                                else
                                    _JobPlanningLine.VALIDATE("Unit Price (LCY)", _QuoteLine.NS_Amount);
                                _JobPlanningLine."Direct Unit Cost (LCY)" := 0;
                                _JobPlanningLine."Unit Cost (LCY)" := 0;
                                _JobPlanningLine."Total Cost (LCY)" := 0;
                                _JobPlanningLine."Unit Cost" := 0;
                                _JobPlanningLine."Total Cost" := 0;
                                if _TempBuf."Currency Code" = _QuoteSetup."NS_Service Category Code" then
                                    if _QuoteInstallJobsSetupSvc."NS_Revenue Category" <> '' then
                                        _JobPlanningLine."NS_Revenue Category" := _QuoteInstallJobsSetupSvc."NS_Revenue Category";
                                _JobPlanningLine."NS_Quote No." := _QuoteLine."NS_Quote No.";
                                _JobPlanningLine."NS_Quote Line No." := _QuoteLine."NS_Quote Line No.";
                                //do not populate cost category when line type is Contract; do not override revenue category from above
                                if _JobPlanningLine."NS_Revenue Category" = '' then
                                    _JobPlanningLine."NS_Revenue Category" := _RevenueCategoryCode;
                                _JobPlanningLine."NS_Vendor No." := _QuoteLine."NS_Vendor No.";
                                _JobPlanningLine."NS_Vendor Quote No." := _QuoteLine."NS_Vendor Quote No.";
                                _JobPlanningLine."NS_Use Tax SKU" := _QuoteLine."NS_Use Tax SKU";
                                _JobPlanningLine."NS_Use Tax Amount" := _QuoteLine."NS_Use Tax Amount";
                                _JobPlanningLine.MODIFY;
                            end;

                        end;

                    until _QuoteLine.NEXT = 0;

                // create separate job planning lines if installation tasks are defined
                // revenue line not necessary for each category (journal Thu 9/19/2013 3:00 PM)

                if _TempBuf."Currency Code" = _QuoteSetup."NS_Install Category Code" then
                    if _InstallTasksExist then
                        if _QuoteInstallImportLine.FINDSET(false) then
                            repeat

                                _QuoteInstallJobsSetup.SETRANGE(NS_Type, _QuoteInstallImportLine."NS_Column 1 Value");
                                _QuoteInstallJobsSetup.SETRANGE(NS_Subtype, _QuoteInstallImportLine."NS_Column 2 Value");
                                if _QuoteInstallJobsSetup.FINDFIRST then begin
                                    _LineNo += 10000;
                                    _JobPlanningLine.INIT;
                                    _JobPlanningLine."Job No." := _JobNo;
                                    _JobPlanningLine."Job Task No." := _TempBuf."Currency Code";
                                    _JobPlanningLine."Line No." := _LineNo;
                                    _JobPlanningLine."Usage Link" := _JobsSetup."Apply Usage Link by Default";
                                    _JobPlanningLine.INSERT;
                                    _JobPlanningLine.VALIDATE("Planning Date", WORKDATE);
                                    _JobPlanningLine.VALIDATE(Type, _JobPlanningLine.Type::"G/L Account");
                                    _JobPlanningLine.VALIDATE("No.", _QuoteInstallJobsSetup."NS_G/L Account No.");
                                    _JobPlanningLine.Description :=
                                      UPPERCASE(COPYSTR(STRSUBSTNO('%1-%2', _QuoteInstallJobsSetup.NS_Type, _QuoteInstallJobsSetup.NS_Subtype), 1, MAXSTRLEN(_JobPlanningLine.Description)));
                                    if _QuoteHeader."NS_Location Code" <> '' then
                                        _JobPlanningLine.VALIDATE("Location Code", _QuoteHeader."NS_Location Code");
                                    _JobPlanningLine.VALIDATE(Quantity, 1);
                                    if EVALUATE(_JobPlanningLine."Direct Unit Cost (LCY)", _QuoteInstallImportLine."NS_Column 6 Value") then;
                                    if EVALUATE(_JobPlanningLine."Unit Cost (LCY)", _QuoteInstallImportLine."NS_Column 6 Value") then
                                        if _JobPlanningLine."Unit Cost (LCY)" <> 0 then
                                            _JobPlanningLine.VALIDATE("Unit Cost (LCY)");
                                    _JobPlanningLine.VALIDATE("Unit Price (LCY)", 0);
                                    _JobPlanningLine."NS_Cost Category" := _QuoteInstallJobsSetup."NS_Cost Category";
                                    //do not populate revenue category for lines of type Schedule
                                    if _QuoteInstallJobsSetup."NS_Shortcut Dimension 1 Code" <> '' then
                                        _JobPlanningLine.VALIDATE("NS_Shortcut Dimension 1 Code", _QuoteInstallJobsSetup."NS_Shortcut Dimension 1 Code");
                                    if _QuoteInstallJobsSetup."NS_Shortcut Dimension 2 Code" <> '' then
                                        _JobPlanningLine.VALIDATE("NS_Shortcut Dimension 2 Code", _QuoteInstallJobsSetup."NS_Shortcut Dimension 2 Code");
                                    _JobPlanningLine.MODIFY;
                                end;

                            until _QuoteInstallImportLine.NEXT = 0;

                // create contract line if summary OR installation-related revenue line OR service-related revenue line

                CLEAR(_QuoteInstallJobsSetup);
                _QuoteInstallJobsSetup.RESET;
                _QuoteInstallJobsSetup.SETFILTER(NS_Type, '%1|%2', 'Material', 'MATERIAL');
                _QuoteInstallJobsSetup.SETFILTER(NS_Subtype, '%1|%2|%3|%4', 'Contract', 'CONTRACT', 'Total', 'TOTAL');

                if (not _DetailContractLines) or
                   ((_InstallTasksExist) and (_TempBuf."Currency Code" = _QuoteSetup."NS_Install Category Code"))
                then begin
                    _LineNo += 10000;
                    _JobPlanningLine.INIT;
                    _JobPlanningLine."Job No." := _JobNo;
                    if _TempBuf."Currency Code" = '' then
                        _JobPlanningLine."Job Task No." := 'UNCAT'
                    else
                        _JobPlanningLine."Job Task No." := _TempBuf."Currency Code";
                    _JobPlanningLine."Line No." := _LineNo;
                    _JobPlanningLine."Usage Link" := _JobsSetup."Apply Usage Link by Default";
                    _JobPlanningLine.INSERT;
                    _JobPlanningLine.VALIDATE("Line Type", _JobPlanningLine."Line Type"::Billable);
                    _JobPlanningLine.VALIDATE("Planning Date", WORKDATE);
                    if _QuoteInstallJobsSetup.FINDFIRST and _InstallTasksExist and
                       (_TempBuf."Currency Code" = _QuoteSetup."NS_Install Category Code")
                    then begin
                        _JobPlanningLine.VALIDATE(Type, _JobPlanningLine.Type::"G/L Account");
                        _JobPlanningLine.VALIDATE("No.", _QuoteInstallJobsSetup."NS_G/L Account No.");
                        //do not populate cost category for lines of type Contract
                        _JobPlanningLine."NS_Revenue Category" := _QuoteInstallJobsSetup."NS_Revenue Category";
                        _JobPlanningLine."NS_Quote No." := _QuoteLine."NS_Quote No.";
                        _JobPlanningLine."NS_Quote Line No." := _QuoteLine."NS_Quote Line No.";
                        _JobPlanningLine.Description := COPYSTR('INSTALLATION', 1, MAXSTRLEN(_JobPlanningLine.Description));
                    end else                                                         // Service
                        if (_TempBuf."Currency Code" = _QuoteSetup."NS_Service Category Code") and _ServiceTaskExists then begin
                            _JobPlanningLine.VALIDATE(Type, _JobPlanningLine.Type::"G/L Account");
                            _JobPlanningLine.VALIDATE("No.", _QuoteInstallJobsSetupSvc."NS_G/L Account No.");
                            //do not populate cost category for lines of type Contract
                            _JobPlanningLine."NS_Revenue Category" := _QuoteInstallJobsSetupSvc."NS_Revenue Category";
                            _JobPlanningLine."NS_Quote No." := _QuoteLine."NS_Quote No.";
                            _JobPlanningLine."NS_Quote Line No." := _QuoteLine."NS_Quote Line No.";
                            _JobPlanningLine.Description := COPYSTR('SERVICE STARTUP & TRAINING', 1, MAXSTRLEN(_JobPlanningLine.Description));
                        end else begin                                                   // Other summary lines
                            _JobPlanningLine.VALIDATE(Type, _JobPlanningLine.Type::Resource);
                            case _TempBuf."Currency Code" of
                                _QuoteSetup."NS_Install Category Code":
                                    begin
                                        _JobPlanningLine.VALIDATE("No.", _QuoteSetup."NS_ResourceNo. forInstallLine");
                                        if _ItemCategory.GET(_TempBuf."Currency Code") then
                                            _JobPlanningLine.Description := UPPERCASE(COPYSTR(_ItemCategory.Description, 1, MAXSTRLEN(_JobPlanningLine.Description)));
                                    end;
                                _QuoteSetup."NS_Service Category Code":
                                    begin
                                        _JobPlanningLine.VALIDATE("No.", _QuoteSetup."NS_ResourceNo. forServiceLine");
                                        if _ItemCategory.GET(_TempBuf."Currency Code") then
                                            _JobPlanningLine.Description := UPPERCASE(COPYSTR(_ItemCategory.Description, 1, MAXSTRLEN(_JobPlanningLine.Description)));
                                    end;
                                else begin
                                    _JobPlanningLine.VALIDATE("No.", _QuoteSetup."NS_ResourceNo. forContractLine");
                                    if _JobTask.GET(_JobPlanningLine."Job No.", _JobPlanningLine."Job Task No.") then
                                        _JobPlanningLine.Description := UPPERCASE(COPYSTR(_JobTask.Description, 1, MAXSTRLEN(_JobPlanningLine.Description)))
                                    else
                                        _JobPlanningLine.Description := UPPERCASE(COPYSTR(_QuoteHeader."NS_Description/Nickname", 1, MAXSTRLEN(_JobPlanningLine.Description)));
                                end;
                            end;
                            _JobPlanningLine."NS_Quote No." := _QuoteLine."NS_Quote No.";
                            _JobPlanningLine."NS_Quote Line No." := _QuoteLine."NS_Quote Line No.";
                            //do not populate cost category for lines of type Contract
                            if (_JobPlanningLine."NS_Revenue Category" = '') and (_RevenueCategoryCode <> '') then
                                _JobPlanningLine."NS_Revenue Category" := _RevenueCategoryCode;
                        end;
                    if _TempBuf."Currency Code" = _QuoteSetup."NS_Service Category Code" then
                        if _ItemCategory.GET(_TempBuf."Currency Code") then
                            _JobPlanningLine.Description := UPPERCASE(COPYSTR(_ItemCategory.Description, 1, MAXSTRLEN(_JobPlanningLine.Description)));
                    if _QuoteHeader."NS_Location Code" <> '' then
                        _JobPlanningLine.VALIDATE("Location Code", _QuoteHeader."NS_Location Code");
                    if _QuoteLine."NS_Shortcut Dimension 1 Code" <> '' then
                        _JobPlanningLine.VALIDATE("NS_Shortcut Dimension 1 Code", _QuoteLine."NS_Shortcut Dimension 1 Code");
                    if _QuoteLine."NS_Shortcut Dimension 2 Code" <> '' then
                        _JobPlanningLine.VALIDATE("NS_Shortcut Dimension 2 Code", _QuoteLine."NS_Shortcut Dimension 2 Code");
                    _JobPlanningLine.VALIDATE(Quantity, 1);
                    if _TempBuf."Currency Code" = _QuoteSetup."NS_Install Category Code" then
                        _JobPlanningLine.VALIDATE("Unit Price (LCY)", _QuoteLine.NS_Amount)
                    else
                        _JobPlanningLine.VALIDATE("Unit Price (LCY)", _Total);
                    _JobPlanningLine."Direct Unit Cost (LCY)" := 0;
                    _JobPlanningLine."Unit Cost (LCY)" := 0;
                    _JobPlanningLine."Total Cost (LCY)" := 0;
                    _JobPlanningLine."Unit Cost" := 0;
                    _JobPlanningLine."Total Cost" := 0;
                    _JobPlanningLine."NS_Use Tax SKU" := _QuoteLine."NS_Use Tax SKU";
                    _JobPlanningLine."NS_Use Tax Amount" := _TotalUseTax;
                    _JobPlanningLine.MODIFY;
                end;

                // create separate contract line for sales tax

                if _TotalSalesTax <> 0 then begin
                    _LineNo += 10000;
                    _JobPlanningLine.INIT;
                    _JobPlanningLine."Job No." := _JobNo;
                    if _TempBuf."Currency Code" = '' then
                        _JobPlanningLine."Job Task No." := 'UNCAT'
                    else
                        _JobPlanningLine."Job Task No." := _TempBuf."Currency Code";
                    _JobPlanningLine."Line No." := _LineNo;
                    _JobPlanningLine."Usage Link" := _JobsSetup."Apply Usage Link by Default";
                    _JobPlanningLine.INSERT;
                    _JobPlanningLine.VALIDATE("Line Type", _JobPlanningLine."Line Type"::Billable);
                    _JobPlanningLine.VALIDATE("Planning Date", WORKDATE);
                    _JobPlanningLine.VALIDATE(Type, _JobPlanningLine.Type::"G/L Account");
                    _JobPlanningLine.VALIDATE("No.", _GenLedgSetup."NS_G/L Job Sales Tax Acc. No.");
                    if _QuoteHeader."NS_Shortcut Dimension 1 Code" <> '' then
                        _JobPlanningLine.VALIDATE("NS_Shortcut Dimension 1 Code", _QuoteHeader."NS_Shortcut Dimension 1 Code");
                    if _QuoteHeader."NS_Shortcut Dimension 2 Code" <> '' then
                        _JobPlanningLine.VALIDATE("NS_Shortcut Dimension 2 Code", _QuoteHeader."NS_Shortcut Dimension 2 Code");
                    _JobPlanningLine.VALIDATE(Quantity, 1);
                    _JobPlanningLine.VALIDATE("Unit Price (LCY)", _TotalSalesTax);
                    _JobPlanningLine."Direct Unit Cost (LCY)" := 0;
                    _JobPlanningLine."Unit Cost (LCY)" := 0;
                    _JobPlanningLine."Total Cost (LCY)" := 0;
                    _JobPlanningLine."Unit Cost" := 0;
                    _JobPlanningLine."Total Cost" := 0;
                    _JobPlanningLine."NS_Revenue Category" := _RevenueCategoryCode;
                    _JobPlanningLine.MODIFY;
                    //progress billing
                    //_STOMgtCustom.pbCommitTempQuoteLine(_JobPlanningLine,_QuoteHeader."Proposal Date");
                end;

            until _TempBuf.NEXT = 0;

        // delete NAV sales quote

        if _SalesHeader.GET(_SalesHeader."Document Type"::Quote, _QuoteHeader."NS_Sales Quote No.") then begin
            if _SalesHeader.Status <> _SalesHeader.Status::Open then begin
                //_ReleaseSalesDoc.SetHideValidationDialog(TRUE);
                _ReleaseSalesDoc.Reopen(_SalesHeader);
            end;
            _SalesHeader.GET(_SalesHeader."Document Type"::Quote, _QuoteHeader."NS_Sales Quote No.");
            _SalesHeader.SetHideValidationDialog(true);
            _SalesHeader.DELETE(true);
        end;

        // stamp quote with job no.

        _QuoteHeader.VALIDATE("NS_Job No.", _JobNo);
        //PE-300-DK.1.0 29May2024 Start
        // _QuoteHeader.NS_Status := _QuoteHeader.NS_Status::Closed;
        _QuoteHeader."NS_Quote Status" := _QuoteHeader."NS_Quote Status"::Closed;
        //PE-300-DK.1.0 29May2024 End
        _QuoteHeader.MODIFY;

        // display the job

        PAGE.RUN(PAGE::"Job Card", _Job);
    end;

    procedure NS_ConvertQuoteJob(var lQuoteHeader: Record "NS_Job Quote Header");
    var
        JobsSetup: Record "Jobs Setup";
        QuoteJob: Record Job;
        JobfromQuote: Record Job;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        JobPostingGroup: Record "Job Posting Group";
        JobPL: Record "Job Planning Line";
        Text14021400: Label 'Quote No. %1 has been converted to Job No. %2';
        DefaultDimRec: Record "Default Dimension";//PRJ-409.AS.1.0 28DEC2020
        DefaultDimRec2: Record "Default Dimension";//PRJ-409.AS.1.0 28DEC2020
        Jobsegments: Record "NS_Job Takeoff Segments";
        QuoteTaskLines: Record "Job Task";//PRJ-646.AM
        AssemBOMRec: Record "NS_Assembley BOM Components";//PRJ-563.AS.4.0
        AssemBOMRec1: Record "NS_Assembley BOM Components";//PRJ-563.AS.4.0
        TextUpdte001: Label 'System will update the Job Task Lines and Job Planning Lines for Job Quote No. %1, with Sub Level to Job No. %2.\\Do you want to continue ?';
        TextUpdte002: Label 'System will create the Job Change Order with the Job Task Lines and Job Planning Lines from Job Quote No. %1.\\Do you want to continue ?'; //PRJCTPR-81.NK.1.0 22Mar2023
        UpdJob: Record job;
        DocumentAttachment: Record "Document Attachment"; //PRJ-1487.GK.1.0 29June2022
        DocumentAttachment2: Record "Document Attachment";//PRJ-1487.GK.1.0 29June2022
        DocumentAttachment3: Record "Document Attachment";//PRJ-1487.GK.1.0 29June2022
        Opportunity: Record Opportunity; //PE-6.NK.1.0 21Mar2023
        NS_NoSeries: Record "No. Series"; //PE-128.PS.2.0 
        NS_Job: Record Job; //PE-128.PS.2.0 08April2024
    begin

        //PRJ-914.AS.1.0 20OCT2021 START <<For Change order with Sub level Job No Done code & in below code deployed previous code for else begin .. end with No Code changing
        IF (lQuoteHeader."NS_Job class" = lQuoteHeader."NS_Job class"::"Change Order") AND (lQuoteHeader."NS_Sub-Level to Job No." <> '') then Begin
            //if CONFIRM(TextUpdte001, true, lQuoteHeader."NS_Quote No.", lQuoteHeader."NS_Sub-Level to Job No.") then begin //PRJCTPR-81.NK.1.0 22Mar2023 Block
            if NOT CONFIRM(TextUpdte002, true, lQuoteHeader."NS_Quote No.") then begin //PRJCTPR-81.NK.1.0 22Mar2023    
                exit; //PRJCTPR-81.NK.1.0 22Mar2023
                JobsSetup.GET;
                JobsSetup.TESTFIELD("Job Nos.");
                QuoteJob.RESET;
                QuoteJob.GET(lQuoteHeader."NS_Quote No.");
                if UpdJob.get(lQuoteHeader."NS_Sub-Level to Job No.") then;

                JobfromQuote.INIT;
                JobfromQuote := QuoteJob;
                JobfromQuote."No." := NS_GetNextChangeOrderNo(lQuoteHeader."NS_Sub-Level to Job No.", JobsSetup."NS_Change Order No. Separator");
                JobfromQuote.VALIDATE("No.");
                JobfromQuote."NS_Sell-to Customer No." := lQuoteHeader."NS_Sell-to Customer No.";
                JobfromQuote."NS_Sell-to Customer Name" := lQuoteHeader."NS_Sell-to Customer Name";
                JobfromQuote."Global Dimension 1 Code" := lQuoteHeader."NS_Shortcut Dimension 1 Code";//PRJ-409.AS.1.0 28DEC2020
                JobfromQuote."Global Dimension 2 Code" := lQuoteHeader."NS_Shortcut Dimension 2 Code";//PRJ-409.AS.1.0 28DEC2020
                                                                                                      //PE-6.NK.1.0 21Mar2023 Start
                if Opportunity.Get(lQuoteHeader.NS_Opportunity) then begin
                    Opportunity.NS_JobOrderNo := JobfromQuote."No.";
                    Opportunity.Modify();
                end;
                //PE-6.NK.1.0 21Mar2023 End
                if JobfromQuote.INSERT then begin
                    JobfromQuote.VALIDATE(Status, JobfromQuote.Status::Planning);
                    JobfromQuote."NS_Created from Quote No." := lQuoteHeader."NS_Quote No.";
                    JobfromQuote."NS_Job Class" := JobfromQuote."NS_Job Class"::"Change Order";
                    //PRJCTPR-197 DK.1.0 Start
                    //JobfromQuote."NS_Job Type" := lQuoteHeader."NS_Job Type Code";
                    JobfromQuote."NS_Job Type New" := lQuoteHeader."NS_Job Type Code";
                    //PRJCTPR-197 DK.1.0 End
                    JobfromQuote."Job Posting Group" := lQuoteHeader."NS_Job Posting Group New";//PRJ-1372.GK.1.0 11May2022
                    NS_CopyQuoteJobTasksToJobChangeOrder(UpdJob, JobfromQuote);
                    NS_CopyQuoteJPLToJobChangeOrder(UpdJob, JobfromQuote);
                    NS_ConvertQuoteSegmentsChangeOrder(UpdJob, JobfromQuote);

                    Jobsegments.Reset();
                    Jobsegments.SetRange("NS_Job No.", lQuoteHeader."NS_Job No.");
                    if NOT Jobsegments.FindFirst() then begin
                        lQuoteHeader.NS_UpdateMinSellPrice();
                        JobsSetup.GET();
                        QuoteTaskLines.RESET();
                        QuoteTaskLines.SETRANGE("Job No.", lQuoteHeader."NS_Job No.");
                        QuoteTaskLines.SETRANGE("Job Task No.", JobsSetup."NS_Total Task No.");
                        if QuoteTaskLines.FINDFIRST() then begin
                            QuoteTaskLines.CALCFIELDS("Schedule (Total Price)", "NS_Line Amount Incl. Tax");
                            lQuoteHeader."NS_Total Contract Price" := ROUND((QuoteTaskLines."Schedule (Total Price)" / (1 - (lQuoteHeader."NS_Minimum Selling Price G.M.%" / 100))), 0.01);
                        end;

                        if lQuoteHeader."NS_Total Contract Price" > 0 then begin
                            JobPostingGroup.GET(lQuoteHeader."NS_Job Posting Group New");
                            JobPostingGroup.TESTFIELD("Recognized Sales Account");
                            JobsSetup.TESTFIELD("NS_Billing Job Task No.");
                            JobPL.INIT;
                            JobPL.Type := JobPL.Type::"G/L Account";
                            JobPL."Job No." := JobfromQuote."No.";
                            JobPL.VALIDATE("No.", JobPostingGroup."Recognized Sales Account");
                            JobPL.VALIDATE("Job Task No.", JobsSetup."NS_Billing Job Task No.");
                            JobPL.VALIDATE("Line Type", JobPL."Line Type"::Billable);
                            JobPL.VALIDATE(Quantity, 1);
                            JobPL.VALIDATE("Unit Price", lQuoteHeader."NS_Total Contract Price");
                            JobPL.INSERT(true);
                        end;
                    end;

                    if JobsSetup."NS_Auto Lock Planning Lines" then
                        JobfromQuote.NS_CopyPlanningToLocked(JobfromQuote."No.");

                    NS_DeleteQuoteJPL(lQuoteHeader);
                    NS_DeleteQuoteJobTasks(lQuoteHeader);
                    QuoteJob.DELETE;
                end;
                lQuoteHeader."NS_Job No." := JobfromQuote."No.";
                lQuoteHeader."NS_Date Converted to Order" := Today();//PRJ-1156.AS.1.0
                NS_CopyQuoteLinksToJob(lQuoteHeader, JobfromQuote);
                //PE-300-DK.1.0 29May2024 Start
                // lQuoteHeader.NS_Status := lQuoteHeader.NS_Status::Accepted;
                lQuoteHeader."NS_Quote Status" := lQuoteHeader."NS_Quote Status"::Accepted;
                //PE-300-DK.1.0 29May2024 End
                JobfromQuote."NS_Default Job Retention" := lQuoteHeader."NS_Retainage %";//PRJ-1192.AS.1.0 18FEB2022
                JobfromQuote.Modify();

                AssemBOMRec.Reset();
                AssemBOMRec.SetRange("NS_Job No.", lQuoteHeader."NS_Quote No.");
                if AssemBOMRec.Findset() then begin
                    repeat
                        if AssemBOMRec1.Get(AssemBOMRec."NS_Job No.", AssemBOMRec."NS_Job Task No.", AssemBOMRec."NS_Line No.") then
                            AssemBOMRec1.RENAME(JobfromQuote."No.", AssemBOMRec."NS_Job Task No.", AssemBOMRec."NS_Line No.");
                    until AssemBOMRec.next = 0;
                end;

                DefaultDimRec.Reset;
                DefaultDimRec.SetRange("Table ID", 14021402);
                DefaultDimRec.SetRange("No.", lQuoteHeader."NS_Quote No.");
                if DefaultDimRec.FindSet then
                    repeat
                        DefaultDimRec2.Init;
                        DefaultDimRec2."Table ID" := 167;
                        DefaultDimRec2."No." := lQuoteHeader."NS_Job No.";
                        DefaultDimRec2."Dimension Code" := DefaultDimRec."Dimension Code";
                        DefaultDimRec2."Dimension Value Code" := DefaultDimRec."Dimension Value Code";
                        DefaultDimRec2.Insert;
                    until DefaultDimRec.Next = 0;

                lQuoteHeader.MODIFY;

                MESSAGE(STRSUBSTNO(Text14021400, lQuoteHeader."NS_Quote No.", lQuoteHeader."NS_Job No."));
            end
            else begin
                JobsSetup.GET;
                JobsSetup.TESTFIELD("Job Nos.");
                QuoteJob.RESET;
                QuoteJob.GET(lQuoteHeader."NS_Quote No.");

                JobfromQuote.INIT;
                JobfromQuote := QuoteJob;
                JobfromQuote."No." := NS_GetNextChangeOrderNo(lQuoteHeader."NS_Sub-Level to Job No.", JobsSetup."NS_Change Order No. Separator");
                JobfromQuote.VALIDATE("No.");
                JobfromQuote."NS_Sell-to Customer No." := lQuoteHeader."NS_Sell-to Customer No.";
                JobfromQuote."NS_Sell-to Customer Name" := lQuoteHeader."NS_Sell-to Customer Name";
                JobfromQuote."Global Dimension 1 Code" := lQuoteHeader."NS_Shortcut Dimension 1 Code";//PRJ-409.AS.1.0 28DEC2020
                JobfromQuote."Global Dimension 2 Code" := lQuoteHeader."NS_Shortcut Dimension 2 Code";//PRJ-409.AS.1.0 28DEC2020
                if JobfromQuote.INSERT then begin
                    JobfromQuote.VALIDATE(Status, JobfromQuote.Status::Planning);
                    JobfromQuote."NS_Created from Quote No." := lQuoteHeader."NS_Quote No.";
                    JobfromQuote."NS_Job Class" := JobfromQuote."NS_Job Class"::"Change Order";
                    //PRJCTPR-197 Dk.1.0 Start
                    // JobfromQuote."NS_Job Type" := lQuoteHeader."NS_Job Type Code";
                    JobfromQuote."NS_Job Type New" := lQuoteHeader."NS_Job Type Code";
                    //PRJCTPR-197 Dk.1.0 End
                    JobfromQuote."Job Posting Group" := lQuoteHeader."NS_Job Posting Group New"; //PRJ-1372.GK.1.0 11May2022
                    NS_CopyQuoteJobTasksToJob(lQuoteHeader, JobfromQuote);
                    NS_CopyQuoteJPLToJob(lQuoteHeader, JobfromQuote);
                    NS_ConvertQuoteSegments(lQuoteHeader, JobfromQuote);

                    Jobsegments.Reset();
                    Jobsegments.SetRange("NS_Job No.", lQuoteHeader."NS_Job No.");
                    if NOT Jobsegments.FindFirst() then begin
                        lQuoteHeader.NS_UpdateMinSellPrice();
                        JobsSetup.GET();
                        QuoteTaskLines.RESET();
                        QuoteTaskLines.SETRANGE("Job No.", lQuoteHeader."NS_Job No.");
                        QuoteTaskLines.SETRANGE("Job Task No.", JobsSetup."NS_Total Task No.");
                        if QuoteTaskLines.FINDFIRST() then begin
                            QuoteTaskLines.CALCFIELDS("Schedule (Total Price)", "NS_Line Amount Incl. Tax");
                            lQuoteHeader."NS_Total Contract Price" := ROUND((QuoteTaskLines."Schedule (Total Price)" / (1 - (lQuoteHeader."NS_Minimum Selling Price G.M.%" / 100))), 0.01);
                        end;

                        if lQuoteHeader."NS_Total Contract Price" > 0 then begin
                            JobPostingGroup.GET(lQuoteHeader."NS_Job Posting Group New");
                            JobPostingGroup.TESTFIELD("Recognized Sales Account");
                            JobsSetup.TESTFIELD("NS_Billing Job Task No.");
                            JobPL.INIT;
                            JobPL.Type := JobPL.Type::"G/L Account";
                            JobPL."Job No." := JobfromQuote."No.";
                            JobPL.VALIDATE("No.", JobPostingGroup."Recognized Sales Account");
                            JobPL.VALIDATE("Job Task No.", JobsSetup."NS_Billing Job Task No.");
                            JobPL.VALIDATE("Line Type", JobPL."Line Type"::Billable);
                            JobPL.VALIDATE(Quantity, 1);
                            JobPL.VALIDATE("Unit Price", lQuoteHeader."NS_Total Contract Price");
                            JobPL.INSERT(true);
                        end;
                    end;

                    if JobsSetup."NS_Auto Lock Planning Lines" then
                        JobfromQuote.NS_CopyPlanningToLocked(JobfromQuote."No.");

                    NS_DeleteQuoteJPL(lQuoteHeader);
                    NS_DeleteQuoteJobTasks(lQuoteHeader);
                    QuoteJob.DELETE;
                end;
                lQuoteHeader."NS_Job No." := JobfromQuote."No.";
                lQuoteHeader."NS_Date Converted to Order" := Today();//PRJ-1156.AS.1.0
                NS_CopyQuoteLinksToJob(lQuoteHeader, JobfromQuote);
                //PE-300-DK.1.0 29May2024 Start
                // lQuoteHeader.NS_Status := lQuoteHeader.NS_Status::Accepted;
                lQuoteHeader."NS_Quote Status" := lQuoteHeader."NS_Quote Status"::Accepted;
                //PE-300-DK.1.0 29May2024 End
                JobfromQuote."NS_Default Job Retention" := lQuoteHeader."NS_Retainage %";//PRJ-1192.AS.1.0 18FEB2022
                JobfromQuote.Modify();

                AssemBOMRec.Reset();
                AssemBOMRec.SetRange("NS_Job No.", lQuoteHeader."NS_Quote No.");
                if AssemBOMRec.Findset() then begin
                    repeat
                        if AssemBOMRec1.Get(AssemBOMRec."NS_Job No.", AssemBOMRec."NS_Job Task No.", AssemBOMRec."NS_Line No.") then
                            AssemBOMRec1.RENAME(JobfromQuote."No.", AssemBOMRec."NS_Job Task No.", AssemBOMRec."NS_Line No.");
                    until AssemBOMRec.next = 0;
                end;

                DefaultDimRec.Reset;
                DefaultDimRec.SetRange("Table ID", 14021402);
                DefaultDimRec.SetRange("No.", lQuoteHeader."NS_Quote No.");
                if DefaultDimRec.FindSet then
                    repeat
                        DefaultDimRec2.Init;
                        DefaultDimRec2."Table ID" := 167;
                        DefaultDimRec2."No." := lQuoteHeader."NS_Job No.";
                        DefaultDimRec2."Dimension Code" := DefaultDimRec."Dimension Code";
                        DefaultDimRec2."Dimension Value Code" := DefaultDimRec."Dimension Value Code";
                        DefaultDimRec2.Insert;
                    until DefaultDimRec.Next = 0;

                lQuoteHeader.MODIFY;

                MESSAGE(STRSUBSTNO(Text14021400, lQuoteHeader."NS_Quote No.", lQuoteHeader."NS_Job No."));
            end;
        END
        //PRJ-914.AS.1.0 20OCT2021 END	>>For Change order with Sub level Job No Done code
        ELSE BEGIN //PRJ-914.AS.1.0 20OCT2021 START <<Deployed previous code for else begin .. end with No Code Changing
            JobsSetup.GET;
            JobsSetup.TESTFIELD("Job Nos.");
            QuoteJob.RESET;
            QuoteJob.GET(lQuoteHeader."NS_Quote No.");

            JobfromQuote.INIT;
            JobfromQuote := QuoteJob;
            //PE-128.PS.2.0 29March2024 Start
            if NS_NoSeries.Get(lQuoteHeader."NS_Job No. Series") then;
            if (NS_NoSeries."Manual Nos." = false) And (NS_NoSeries."Default Nos." = false) then
                Error('It is not possible to assign numbers automatically. If you want the program to assign numbers automatically, please activate Default Nos. in No. Series %1.', lQuoteHeader."NS_Job No. Series");

            if lQuoteHeader."NS_Job No. Series" <> '' then begin
                if NS_NoSeries.Get(lQuoteHeader."NS_Job No. Series") then;
                if (NS_NoSeries."Manual Nos." = true) And (NS_NoSeries."Default Nos." = true) then begin
                    if lQuoteHeader."NS_Manual Job No." = '' then
                        JobfromQuote."No." := NoSeriesMgt.GetNextNo(lQuoteHeader."NS_Job No. Series", Today, true)
                    else
                        JobfromQuote."No." := lQuoteHeader."NS_Manual Job No.";
                    JobfromQuote.VALIDATE("No.");
                end;

                If (NS_NoSeries."Manual Nos." = true) And (NS_NoSeries."Default Nos." = false) then
                    JobfromQuote."No." := lQuoteHeader."NS_Manual Job No.";

                If (NS_NoSeries."Manual Nos." = false) And (NS_NoSeries."Default Nos." = true) then
                    JobfromQuote."No." := NoSeriesMgt.GetNextNo(lQuoteHeader."NS_Job No. Series", Today, true);
                JobfromQuote.VALIDATE("No.");
            end;

            NS_Job.Reset();
            NS_Job.SetRange("No.", JobfromQuote."No.");
            if NS_Job.FindFirst() then
                Error('The record in table Job already exists. Identification fields and values: No. %1', JobfromQuote."No.");

            //PE-128.PS.2.0 29March2024  End 
            JobfromQuote."NS_Sell-to Customer No." := lQuoteHeader."NS_Sell-to Customer No.";
            JobfromQuote."NS_Sell-to Customer Name" := lQuoteHeader."NS_Sell-to Customer Name";
            JobfromQuote."Global Dimension 1 Code" := lQuoteHeader."NS_Shortcut Dimension 1 Code";//PRJ-409.AS.1.0 28DEC2020
            JobfromQuote."Global Dimension 2 Code" := lQuoteHeader."NS_Shortcut Dimension 2 Code";//PRJ-409.AS.1.0 28DEC2020
            //PE-6.NK.1.0 21Mar2023 Start
            if Opportunity.Get(lQuoteHeader.NS_Opportunity) then begin
                Opportunity.NS_JobOrderNo := JobfromQuote."No.";
                Opportunity.Modify();
            end;
            //PE-6.NK.1.0 21Mar2023 End
            if JobfromQuote.INSERT then begin
                JobfromQuote.VALIDATE(Status, JobfromQuote.Status::Planning);
                JobfromQuote."NS_Created from Quote No." := lQuoteHeader."NS_Quote No.";
                JobfromQuote."NS_Job Class" := JobfromQuote."NS_Job Class"::"Master Job";
                //PRJCTPR-197 Dk.1.0 Start
                // JobfromQuote."NS_Job Type" := lQuoteHeader."NS_Job Type Code";
                JobfromQuote."NS_Job Type New" := lQuoteHeader."NS_Job Type Code";
                //PRJCTPR-197 Dk.1.0 End
                JobfromQuote."NS_Job Class" := JobsSetup."NS_Default Job Class";
                JobfromQuote."Job Posting Group" := lQuoteHeader."NS_Job Posting Group New";//PRJ-1372.GK.1.0 11May2022
                NS_CopyQuoteJobTasksToJob(lQuoteHeader, JobfromQuote);
                NS_CopyQuoteJPLToJob(lQuoteHeader, JobfromQuote);
                NS_ConvertQuoteSegments(lQuoteHeader, JobfromQuote);

                //PRJ-497.AM.1.0 start
                Jobsegments.Reset();
                Jobsegments.SetRange("NS_Job No.", lQuoteHeader."NS_Job No.");
                if NOT Jobsegments.FindFirst() then begin
                    lQuoteHeader.NS_UpdateMinSellPrice();
                    //PRJ-497.AM.1.0 End
                    //PRJ-311.MS.1.0 start comment --PPAL-33 //PRJ-497.AM.1.0 Uncomment start
                    //PRJ-646.AM start
                    JobsSetup.GET();
                    QuoteTaskLines.RESET();
                    QuoteTaskLines.SETRANGE("Job No.", lQuoteHeader."NS_Job No.");
                    QuoteTaskLines.SETRANGE("Job Task No.", JobsSetup."NS_Total Task No.");
                    if QuoteTaskLines.FINDFIRST() then begin
                        QuoteTaskLines.CALCFIELDS("Schedule (Total Price)", "NS_Line Amount Incl. Tax");
                        lQuoteHeader."NS_Total Contract Price" := ROUND((QuoteTaskLines."Schedule (Total Price)" / (1 - (lQuoteHeader."NS_Minimum Selling Price G.M.%" / 100))), 0.01);
                    end;
                    //PRJ-646.AM End
                    if lQuoteHeader."NS_Total Contract Price" > 0 then begin
                        //JobPostingGroup.GET(lQuoteHeader."NS_Job Posting Group");//PRJ-993.AS.1.0 18OCT2021 comment old code for field "NS_Job Posting Group" for Job Quote header
                        JobPostingGroup.GET(lQuoteHeader."NS_Job Posting Group New");//PRJ-993.AS.1.0 18OCT2021 Add new code for field "NS_Job Posting Group New" for Job Quote header
                        JobPostingGroup.TESTFIELD("Recognized Sales Account");
                        JobsSetup.TESTFIELD("NS_Billing Job Task No.");
                        JobPL.INIT;
                        JobPL.Type := JobPL.Type::"G/L Account";
                        JobPL."Job No." := JobfromQuote."No."; //PRJ-497.AM.1.0 changed location of Job No. validate
                        JobPL.VALIDATE("No.", JobPostingGroup."Recognized Sales Account");
                        JobPL.VALIDATE("Job Task No.", JobsSetup."NS_Billing Job Task No.");
                        JobPL.VALIDATE("Line Type", JobPL."Line Type"::Billable);
                        JobPL.VALIDATE(Quantity, 1);
                        JobPL.VALIDATE("Unit Price", lQuoteHeader."NS_Total Contract Price");
                        JobPL.INSERT(true);
                    end;
                end;
                //PRJ-311.MS.1.0 End comment PPAL-33 //PRJ-497.AM.1.0 Uncomment End

                if JobsSetup."NS_Auto Lock Planning Lines" then
                    JobfromQuote.NS_CopyPlanningToLocked(JobfromQuote."No.");

                NS_DeleteQuoteJPL(lQuoteHeader);
                NS_DeleteQuoteJobTasks(lQuoteHeader);
                QuoteJob.DELETE;
            end;
            lQuoteHeader."NS_Job No." := JobfromQuote."No.";
            lQuoteHeader."NS_Date Converted to Order" := Today();//PRJ-1156.AS.1.0
            NS_CopyQuoteLinksToJob(lQuoteHeader, JobfromQuote);
            //PE-300-DK.1.0 29May2024 Start
            //lQuoteHeader.NS_Status := lQuoteHeader.NS_Status::Accepted;
            lQuoteHeader."NS_Quote Status" := lQuoteHeader."NS_Quote Status"::Accepted;
            //PE-300-DK.1.0 29May2024 End
            JobfromQuote."NS_Default Job Retention" := lQuoteHeader."NS_Retainage %";//PRJ-1192.AS.1.0 18FEB2022
            JobfromQuote.Modify();//PRJ-883.AS.1.0 20AUG21

            //PRJ-563.AS.4.0 START
            AssemBOMRec.Reset();
            AssemBOMRec.SetRange("NS_Job No.", lQuoteHeader."NS_Quote No.");
            if AssemBOMRec.Findset() then begin
                repeat
                    if AssemBOMRec1.Get(AssemBOMRec."NS_Job No.", AssemBOMRec."NS_Job Task No.", AssemBOMRec."NS_Line No.") then
                        AssemBOMRec1.RENAME(JobfromQuote."No.", AssemBOMRec."NS_Job Task No.", AssemBOMRec."NS_Line No.");
                until AssemBOMRec.next = 0;
            end;
            //PRJ-563.AS.4.0 END

            //PRJ-409.AS.1.0 28DEC2020 start
            DefaultDimRec.Reset;
            DefaultDimRec.SetRange("Table ID", 14021402);
            DefaultDimRec.SetRange("No.", lQuoteHeader."NS_Quote No.");
            if DefaultDimRec.FindSet then
                repeat
                    DefaultDimRec2.Init;
                    DefaultDimRec2."Table ID" := 167;
                    DefaultDimRec2."No." := lQuoteHeader."NS_Job No.";
                    DefaultDimRec2."Dimension Code" := DefaultDimRec."Dimension Code";
                    DefaultDimRec2."Dimension Value Code" := DefaultDimRec."Dimension Value Code";
                    DefaultDimRec2.Insert;
                until DefaultDimRec.Next = 0;
            //PRJ-409.AS.1.0 28DEC2020 end
            lQuoteHeader.MODIFY;
            //PRJ-1487.GK.1.0 29June2022 start
            DocumentAttachment.reset;
            DocumentAttachment.SetRange("No.", lQuoteHeader."NS_Quote No.");
            DocumentAttachment.SetRange("Table ID", 14021402);
            if DocumentAttachment.FindSet() then
                repeat
                    DocumentAttachment2.init();
                    DocumentAttachment2."Table ID" := 167;
                    DocumentAttachment2."No." := JobfromQuote."No.";
                    DocumentAttachment2."Document Type" := DocumentAttachment2."Document Type"::Quote;
                    DocumentAttachment3.reset;
                    DocumentAttachment3.SetRange("No.", JobfromQuote."No.");
                    DocumentAttachment3.SetRange("Table ID", 167);
                    //PRJ-1487.NK.1.0 01Jul2022 Start
                    if DocumentAttachment3.FindLast() then
                        DocumentAttachment2."Line No." := DocumentAttachment3."Line No." + 10000
                    else
                        DocumentAttachment2."Line No." := 10000;
                    // if not DocumentAttachment3.FindFirst() then
                    //     DocumentAttachment2."Line No." := 10000
                    //     else
                    //     DocumentAttachment2."Line No." := DocumentAttachment3."Line No." + 1000;
                    //PRJ-1487.NK.1.0 01Jul2022 End


                    DocumentAttachment2.Insert();
                    DocumentAttachment2."File Name" := DocumentAttachment."File Name";
                    DocumentAttachment2."File Type" := DocumentAttachment."File Type";
                    DocumentAttachment2."File Extension" := DocumentAttachment."File Extension";
                    DocumentAttachment2."Attached By" := DocumentAttachment."Attached By";
                    DocumentAttachment2.User := DocumentAttachment.User;
                    DocumentAttachment2.modify();
                until DocumentAttachment.next = 0;
            //PRJ-1487.GK.1.0 29June2022 end
            MESSAGE(STRSUBSTNO(Text14021400, lQuoteHeader."NS_Quote No.", lQuoteHeader."NS_Job No."));
        end;
    END;
    //PRJ-914.AS.1.0 20OCT2021 END >>Deployed previous code for else begin .. end with No Code Changing

    procedure NS_CopyDocument(_QuoteHeader: Record "NS_Job Quote Header");
    var
        _QuoteHeader2: Record "NS_Job Quote Header";
        _NewDocNo: Code[20];
    begin
        _NewDocNo := NS_DuplicateQuote(_QuoteHeader);
        _QuoteHeader2.GET(_NewDocNo);
        _QuoteHeader2."NS_Copy in Progress" := false;
        _QuoteHeader2.NS_Revision := 1;
        _QuoteHeader2.MODIFY;
        NS_SyncSalesQuoteLines(_QuoteHeader2);
        PAGE.RUN(PAGE::"NS_Job Quote", _QuoteHeader2);
    end;

    procedure NS_CopyDocumentJQ(_QuoteHeader: Record "NS_Job Quote Header"; CustNo: Code[20]);
    var
        _QuoteHeader2: Record "NS_Job Quote Header";
        _NewDocNo: Code[20];
    begin
        _NewDocNo := NS_DuplicateQuoteJQ(_QuoteHeader, CustNo);
        _QuoteHeader2.GET(_NewDocNo);
        _QuoteHeader2."NS_Copy in Progress" := false;
        _QuoteHeader2.NS_Revision := 0;
        _QuoteHeader2.MODIFY;
        PAGE.RUN(PAGE::"NS_Job Quote", _QuoteHeader2);
    end;

    procedure NS_CopyFeatureTextForQuoteLine(_QuoteLine: Record "NS_Job Quote Line");
    var
        _DefaultFeatureText: Record "NS_Job Quote Def. Feature Text";
        _FeatureText: Record "NS_Job Quote Feature Text";
        _LineNo: Integer;
    begin
        with _FeatureText do begin
            SETRANGE("NS_Quote No.", _QuoteLine."NS_Quote No.");
            SETRANGE("NS_Quote Line No.", _QuoteLine."NS_Quote Line No.");
            if not ISEMPTY then
                exit;
        end;

        case _QuoteLine.NS_Type of
            _QuoteLine.NS_Type::"G/L Account":
                _DefaultFeatureText.SETRANGE("NS_Table ID", DATABASE::"G/L Account");
            _QuoteLine.NS_Type::Item:
                _DefaultFeatureText.SETRANGE("NS_Table ID", DATABASE::Item);
            _QuoteLine.NS_Type::Resource:
                _DefaultFeatureText.SETRANGE("NS_Table ID", DATABASE::Resource);
            else
                exit;
        end;
        _DefaultFeatureText.SETRANGE("NS_No.", _QuoteLine."NS_No.");
        if _DefaultFeatureText.ISEMPTY then
            exit;

        if _DefaultFeatureText.FINDSET(false) then
            repeat
                _LineNo += 10000;
                with _FeatureText do begin
                    INIT;
                    TRANSFERFIELDS(_DefaultFeatureText, false);
                    "NS_Quote No." := _QuoteLine."NS_Quote No.";
                    "NS_Quote Line No." := _QuoteLine."NS_Quote Line No.";
                    "NS_Line No." := _LineNo;
                    INSERT;
                end;
            until _DefaultFeatureText.NEXT = 0;
    end;

    procedure NS_CopyLinksFromQuoteToQuote(_DestQuote: Record "NS_Job Quote Header"; _SourceQuote: Record "NS_Job Quote Header");
    var
        _FieldRef: FieldRef;
        _RecRef: RecordRef;
        _QuoteRecID: RecordID;
        _ItemRecID: RecordID;
    begin
        _RecRef.OPEN(DATABASE::"NS_Job Quote Header");
        _FieldRef := _RecRef.FIELD(_DestQuote.FIELDNO("NS_Quote No."));
        _FieldRef.SETRANGE(_DestQuote."NS_Quote No.");
        if _RecRef.FINDFIRST then
            _RecRef.COPYLINKS(_SourceQuote);
    end;

    procedure NS_CopyLinksFromItemToQuote(_QuoteNo: Code[20]; _Item: Record Item);
    var
        _QuoteHeader: Record "NS_Job Quote Header";
        _RecLink: Record "Record Link";
        _FieldRef: FieldRef;
        _RecRef: RecordRef;
        _QuoteRecID: RecordID;
        _ItemRecID: RecordID;
    begin
        _RecRef.OPEN(DATABASE::"NS_Job Quote Header");
        _FieldRef := _RecRef.FIELD(_QuoteHeader.FIELDNO("NS_Quote No."));
        _FieldRef.SETRANGE(_QuoteNo);
        if _RecRef.FINDFIRST then
            _RecRef.COPYLINKS(_Item);
    end;

    procedure NS_CopyQuoteJob(qQuoteHeaderSrc: Record "NS_Job Quote Header"; var qQuoteHeaderDst: Record "NS_Job Quote Header");
    var
        qQuoteJobSrc: Record Job;
        qQuoteJobDst: Record Job;
    begin
        if qQuoteJobSrc.GET(qQuoteHeaderSrc."NS_Job No.") then begin
            qQuoteJobDst.TRANSFERFIELDS(qQuoteJobSrc, true);
            qQuoteJobDst."No." := qQuoteHeaderDst."NS_Job No.";
            qQuoteJobDst.VALIDATE("Bill-to Customer No.", qQuoteHeaderDst."NS_Bill-to Customer No.");
            if qQuoteJobDst.INSERT(false) then
                NS_CopySubTablesJob(qQuoteHeaderSrc."NS_Job No.", qQuoteHeaderDst."NS_Job No.");
        end;
    end;

    procedure NS_CopyQuoteToLibrary(_QuoteHeader: Record "NS_Job Quote Header");
    var
        _QuoteHeader2: Record "NS_Job Quote Header";
        _NewNo: Code[20];
        _Text000: Label 'Copy Quote to LIBRARY?';
        _Text001: Label 'Unable to copy document to LIBRARY.';
    begin
        if NS_QuoteListFiltered then
            ERROR(_Text001);

        if not HideValidationDialog then
            if not CONFIRM(_Text000, false) then
                exit;

        _NewNo := NS_DuplicateQuote(_QuoteHeader);
        if not _QuoteHeader2.GET(_NewNo) then
            exit;

        _QuoteHeader2."NS_Copy in Progress" := false;
        _QuoteHeader2."NS_Salesperson/User ID" := 'LIBRARY';
        _QuoteHeader2."NS_Created by" := 'LIBRARY';
        _QuoteHeader2.NS_Template := true;
        _QuoteHeader2.MODIFY;
    end;

    procedure NS_CopyScopeOfWorkForQuoteLine(_QuoteLine: Record "NS_Job Quote Line");
    var
        _DefaultScopeOfWork: Record "NS_Job Quote Def Scope of Work";
        _ScopeOfWork: Record "NS_Job Quote Scope of Work";
        _LineNo: Integer;
    begin
        /*WITH _ScopeOfWork DO BEGIN
          SETRANGE("Quote No.",_QuoteLine."Quote No.");
          SETRANGE("Quote Line No.",_QuoteLine."Quote Line No.");
          IF NOT _ScopeOfWork.ISEMPTY THEN
            EXIT;
        END;
        
        CASE _QuoteLine.Type OF
          _QuoteLine.Type::"G/L Account":
            _DefaultScopeOfWork.SETRANGE("Table ID",DATABASE::"G/L Account");
          _QuoteLine.Type::Item:
            _DefaultScopeOfWork.SETRANGE("Table ID",DATABASE::Item);
          _QuoteLine.Type::Resource:
            _DefaultScopeOfWork.SETRANGE("Table ID",DATABASE::Resource);
          ELSE
            EXIT;
        END;
        _DefaultScopeOfWork.SETRANGE("No.",_QuoteLine."No.");
        IF _DefaultScopeOfWork.ISEMPTY THEN
          EXIT;
        
        IF _DefaultScopeOfWork.FINDSET(FALSE) THEN
          REPEAT
            _LineNo += 10000;
            WITH _ScopeOfWork DO BEGIN
              INIT;
              TRANSFERFIELDS(_DefaultScopeOfWork,FALSE);
              "Quote No." := _QuoteLine."Quote No.";
              "Quote Line No." := _QuoteLine."Quote Line No.";
              "Line No." := _LineNo;
              INSERT;
            END;
          UNTIL _DefaultScopeOfWork.NEXT = 0;*/

    end;

    procedure NS_CopyScopeOfWorkFromSetup(var _QuoteHeader: Record "NS_Job Quote Header");
    var
        _DefaultScopeOfWork: Record "NS_Job Quote Def Scope of Work";
        _SalesSetup: Record "Sales & Receivables Setup";
        _ScopeOfWork: Record "NS_Job Quote Scope of Work";
    begin
        /*_SalesSetup.GET;
        
        _DefaultScopeOfWork.SETRANGE("Table ID",DATABASE::"Sales & Receivables Setup");
        _DefaultScopeOfWork.SETRANGE("No.",_SalesSetup."Primary Key");
        IF NOT _DefaultScopeOfWork.FINDSET(FALSE) THEN
          EXIT;
        
        REPEAT
          WITH _ScopeOfWork DO BEGIN
            INIT;
            "Quote No." := _QuoteHeader."Quote No.";
            "Line No." := _DefaultScopeOfWork."Line No.";
            "Text Value" := _DefaultScopeOfWork."Text Value";
            INSERT;
          END;
        UNTIL _DefaultScopeOfWork.NEXT = 0;*/

    end;

    local procedure NS_CopySubTablesJob(qSourceJobNo: Code[20]; qDestinationJobNo: Code[20]);
    var
        qJobTaskSrc: Record "Job Task";
        qJobPlanSrc: Record "Job Planning Line";
        qJobTaskDst: Record "Job Task";
        qJobPlanDst: Record "Job Planning Line";
    begin
        qJobTaskSrc.RESET;
        qJobTaskSrc.SETRANGE("Job No.", qSourceJobNo);
        if qJobTaskSrc.FINDSET(false, false) then
            repeat
                qJobTaskDst := qJobTaskSrc;
                qJobTaskDst."Job No." := qDestinationJobNo;
                qJobTaskDst."NS_Quote No." := qDestinationJobNo;
                qJobTaskDst.INSERT;
            until qJobTaskSrc.NEXT = 0;

        qJobPlanSrc.RESET;
        qJobPlanSrc.SETRANGE("Job No.", qSourceJobNo);
        if qJobPlanSrc.FINDSET(false, false) then
            repeat
                qJobPlanDst := qJobPlanSrc;
                qJobPlanDst."Job No." := qDestinationJobNo;
                qJobPlanDst.INSERT;
            until qJobPlanSrc.NEXT = 0;
    end;

    local procedure NS_CopyQuoteTaskLines(lQuoteHeader: Record "NS_Job Quote Header"; lQuoteHeader2: Record "NS_Job Quote Header");
    var
        qTaskLines: Record "Job Task";
        lTaskLines: Record "Job Task";
    begin
        with lQuoteHeader do begin
            qTaskLines.SETRANGE("Job No.", "NS_Quote No.");
            if qTaskLines.FINDSET(true, true) then
                repeat
                    lTaskLines.INIT;
                    lTaskLines := qTaskLines;
                    lTaskLines."Job No." := lQuoteHeader2."NS_Quote No.";
                    if not lTaskLines.INSERT then
                        lTaskLines.MODIFY;
                    lTaskLines."NS_Quote No." := lQuoteHeader2."NS_Quote No.";
                    lTaskLines.MODIFY;
                until qTaskLines.NEXT = 0;
        end;
    end;

    local procedure NS_CopyQuotePlanningLines(lQuoteHeader: Record "NS_Job Quote Header");
    var
        qPlanningLines: Record "Job Planning Line";
        lPlanningLines: Record "Job Planning Line";
    begin
        with lQuoteHeader do begin
            qPlanningLines.SETRANGE("Job No.", "NS_Quote No.");
            if qPlanningLines.FINDSET(true, true) then
                repeat
                    lPlanningLines := qPlanningLines;
                    lPlanningLines.Validate("No.", qPlanningLines."No.");//PRJ-1340.GK.1.0 04May2022
                    lPlanningLines."Job No." := "NS_Job No.";
                    if lPlanningLines.INSERT then;
                until qPlanningLines.NEXT = 0;
        end;
    end;

    procedure NS_CreateDim(var _QuoteHeader: Record "NS_Job Quote Header"; _Type1: Integer; _No1: Code[20]; _Type2: Integer; _No2: Code[20]; _Type3: Integer; _No3: Code[20]; _Type4: Integer; _No4: Code[20]; _Type5: Integer; _No5: Code[20]);
    var
        _SourceCodeSetup: Record "Source Code Setup";
        _DimMgt: Codeunit DimensionManagement;
        _TableID: array[10] of Integer;
        _No: array[10] of Code[20];
        _OldDimSetID: Integer;
        _NSDefaultDimSource: List of [Dictionary of [Integer, Code[20]]];   //PRJCTPR-155.JS.1.0 08Sep2023
    begin
        //PRJ-1170.NK.1.0 Start
        //with _QuoteHeader do begin
        _SourceCodeSetup.GET();
        _TableID[1] := _Type1;
        _No[1] := _No1;
        _TableID[2] := _Type2;
        _No[2] := _No2;
        //_TableID[3] := _Type3;  // Campaign
        //_No[3] := _No3;
        //_TableID[4] := _Type4;  // Responsibility Center
        //_No[4] := _No4;
        //_TableID[5] := _Type5;  // Customer Template
        //_No[5] := _No5;
        _QuoteHeader."NS_Shortcut Dimension 1 Code" := '';
        _QuoteHeader."NS_Shortcut Dimension 2 Code" := '';
        //PRJCTPR-155.JS.1.0 08Sep2023 - Start
        if (_TableID[1] <> 0) and (_No[1] <> '') then begin
            _DimMgt.AddDimSource(_NSDefaultDimSource, _TableID[1], _No[1]);
            //_TableID[3] := _Type3;  // Campaign
            //_No[3] := _No3;
            //_TableID[4] := _Type4;  // Responsibility Center
            //_No[4] := _No4;
            //_TableID[5] := _Type5;  // Customer Template
            //_No[5] := _No5;
            _OldDimSetID := _QuoteHeader."NS_Dimension Set ID";
            _QuoteHeader."NS_Dimension Set ID" :=
              //_DimMgt.GetDefaultDimID(_TableID, _No, _SourceCodeSetup.Sales, _QuoteHeader."NS_Shortcut Dimension 1 Code", _QuoteHeader."NS_Shortcut Dimension 2 Code", 0, 0);  
              _DimMgt.GetDefaultDimID(_NSDefaultDimSource, _SourceCodeSetup.Sales, _QuoteHeader."NS_Shortcut Dimension 1 Code", _QuoteHeader."NS_Shortcut Dimension 2 Code", 0, 0);
        end;
        if (_TableID[2] <> 0) and (_No[2] <> '') then begin
            _DimMgt.AddDimSource(_NSDefaultDimSource, _TableID[2], _No[2]);
            _OldDimSetID := _QuoteHeader."NS_Dimension Set ID";
            _QuoteHeader."NS_Dimension Set ID" :=
              _DimMgt.GetDefaultDimID(_NSDefaultDimSource, _SourceCodeSetup.Sales, _QuoteHeader."NS_Shortcut Dimension 1 Code", _QuoteHeader."NS_Shortcut Dimension 2 Code", 0, 0);
        end;
        //PRJCTPR-155.JS.1.0 08Sep2023 - end
        if (_OldDimSetID <> _QuoteHeader."NS_Dimension Set ID") and NS_QuoteLinesExist(_QuoteHeader) then begin
            _QuoteHeader.MODIFY();
            NS_UpdateAllLineDim(_QuoteHeader, _QuoteHeader."NS_Dimension Set ID", _OldDimSetID);
        end;
        //end;
        //PRJ-1170.NK.1.0 End
    end;

    procedure NS_CreateDimForLine(var _QuoteLine: Record "NS_Job Quote Line"; _Type1: Integer; _No1: Code[20]; _Type2: Integer; _No2: Code[20]; _Type3: Integer; _No3: Code[20]);
    var
        _QuoteHeader: Record "NS_Job Quote Header";
        _SourceCodeSetup: Record "Source Code Setup";
        _DimMgt: Codeunit DimensionManagement;
        _DimSetID: Integer;
        _TableID: array[10] of Integer;
        _No: array[10] of Code[20];
        _NSDefaultDimSource: List of [Dictionary of [Integer, Code[20]]];   //PRJCTPR-155.JS.1.0 08Sep2023
    begin
        if not _QuoteHeader.GET(_QuoteLine."NS_Quote No.") then
            _QuoteHeader.INIT;

        _DimSetID := _QuoteLine."NS_Dimension Set ID";
        if _DimSetID = 0 then
            if _QuoteHeader."NS_Dimension Set ID" <> 0 then
                _DimSetID := _QuoteHeader."NS_Dimension Set ID";

        //PRJ-1170.NK.1.0 Start
        //with _QuoteLine do begin
        _SourceCodeSetup.GET();
        _TableID[1] := _Type1;
        _No[1] := _No1;
        _DimMgt.AddDimSource(_NSDefaultDimSource, _TableID[1], _No[1]);  //PRJCTPR-155.JS.1.0 08Sep2023
        //_TableID[2] := _Type2;  // Job
        //_No[2] := _No2;
        //_TableID[3] := _Type3;  // Responsibility Center
        //_No[3] := _No3;
        _QuoteLine."NS_Shortcut Dimension 1 Code" := '';
        _QuoteLine."NS_Shortcut Dimension 2 Code" := '';
        _QuoteLine."NS_Dimension Set ID" :=
          //PRJCTPR-155.JS.1.0 08Sep2023 - Start
          //     _DimMgt.GetDefaultDimID(
          //       _TableID, _No, _SourceCodeSetup.Sales,
          //   _QuoteLine."NS_Shortcut Dimension 1 Code", _QuoteLine."NS_Shortcut Dimension 2 Code",
          //       _DimSetID, DATABASE::Customer);
          _DimMgt.GetDefaultDimID(
            _NSDefaultDimSource, _SourceCodeSetup.Sales,
        _QuoteLine."NS_Shortcut Dimension 1 Code", _QuoteLine."NS_Shortcut Dimension 2 Code",
            _DimSetID, DATABASE::Customer);
        //PRJCTPR-155.JS.1.0 08Sep2023 - end
        _DimMgt.UpdateGlobalDimFromDimSetID(_QuoteLine."NS_Dimension Set ID", _QuoteLine."NS_Shortcut Dimension 1 Code", _QuoteLine."NS_Shortcut Dimension 2 Code");
        _QuoteLine.MODIFY();
        //end;
        //PRJ-1170.NK.1.0 End
    end;

    procedure NS_CreateRevision(_QuoteHeader: Record "NS_Job Quote Header");
    var
        _QuoteHeader2: Record "NS_Job Quote Header";
        _NewQuoteNo: Code[20];
        _RevisionNew: Integer;
        _RevisionOld: Integer;
    begin
        if _QuoteHeader."NS_Quote No." = '' then
            exit;

        _QuoteHeader.TESTFIELD(NS_Template, false);

        _RevisionOld := _QuoteHeader.NS_Revision;
        if _QuoteHeader."NS_Link-to Quote No." = '' then begin
            _QuoteHeader."NS_Link-to Quote No." := _QuoteHeader."NS_Quote No.";
            _QuoteHeader.MODIFY;
        end;

        if not _QuoteHeader."NS_Preserve Pricing Flag" then begin
            _QuoteHeader."NS_Preserve Pricing Flag" := true;
            _QuoteHeader.MODIFY;
        end;

        _RevisionNew := _RevisionOld;
        _QuoteHeader2.SETCURRENTKEY("NS_Link-to Quote No.");
        _QuoteHeader2.SETRANGE("NS_Link-to Quote No.", _QuoteHeader."NS_Link-to Quote No.");
        if _QuoteHeader2.FINDSET(false) then
            repeat
                if _QuoteHeader2.NS_Revision > _RevisionNew then
                    _RevisionNew := _QuoteHeader2.NS_Revision;
            until _QuoteHeader2.NEXT = 0;
        _RevisionNew += 1;
        _QuoteHeader.NS_Revision := -_RevisionNew;
        _QuoteHeader.MODIFY;

        _NewQuoteNo := NS_DuplicateQuote(_QuoteHeader);
        _QuoteHeader2.GET(_NewQuoteNo);
        _QuoteHeader2."NS_Link-to Quote No." := _QuoteHeader."NS_Link-to Quote No.";
        _QuoteHeader2."NS_Copy in Progress" := false;
        _QuoteHeader2.MODIFY(true);

        _QuoteHeader.NS_Revision := _RevisionOld;
        _QuoteHeader."NS_Preserve Pricing Flag" := false;
        _QuoteHeader.MODIFY;

        NS_SyncSalesQuoteLines(_QuoteHeader2);

        PAGE.RUN(PAGE::"NS_Job Quote", _QuoteHeader2);
    end;

    // >> Upgrade
    //procedure NS_CreateRevisionJQ(var qQuoteHeader: Record "NS_Job Quote Header");
    procedure NS_CreateRevisionJQ(var qQuoteHeader: Record "NS_Job Quote Header"; IsRevision: Boolean)
    // << Upgrade
    var
        qQuoteLine: Record "NS_Job Quote Line";
        QuoteJob: Record Job;
    begin
        NS_ArchiveRevision(qQuoteHeader);

        qQuoteHeader.NS_Revision += 1;
        qQuoteHeader.MODIFY;

        qQuoteLine.SETRANGE("NS_Quote No.", qQuoteHeader."NS_Quote No.");
        if qQuoteLine.FINDSET(true, false) then
            repeat
                qQuoteLine.NS_Revision := qQuoteHeader.NS_Revision;
                qQuoteLine.MODIFY;
            until qQuoteLine.NEXT = 0;

        if QuoteJob.GET(qQuoteHeader."NS_Job No.") then begin
            QuoteJob."NS_Quote Revision" := qQuoteHeader.NS_Revision;
            QuoteJob.MODIFY;
        end;

        MESSAGE('Job Quote Revision Created: ' + qQuoteHeader."NS_Quote No." + '.' + FORMAT(qQuoteHeader.NS_Revision - 1));
    end;

    procedure NS_CreateSalesQuoteHeader(var _QuoteHeader: Record "NS_Job Quote Header");
    var
        _SalesHeader: Record "Sales Header";
        _NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        // create sales quote header

        if _QuoteHeader."NS_Sales Quote No." = '' then begin
            _SalesHeader.INIT;
            _SalesHeader."No." := _QuoteHeader."NS_Quote No.";
            _SalesHeader.INSERT(true);
            _QuoteHeader."NS_Sales Quote No." := _SalesHeader."No.";
        end;
    end;

    procedure NS_DeleteOldAddresses(_QuoteHeader: Record "NS_Job Quote Header");
    var
        _Address: Record "Ship-to Address";
    begin
        if _QuoteHeader."NS_Link-to Quote No." <> '' then
            exit;

        _Address.SETRANGE("NS_Table ID", DATABASE::"NS_Job Quote Header");
        _Address.SETRANGE("NS_No.", _QuoteHeader."NS_Quote No.");

        if _QuoteHeader."NS_Sell-to Customer No." <> '' then begin
            _Address.SETFILTER("Customer No.", '<>%1&<>%2', '', _QuoteHeader."NS_Sell-to Customer No.");
            _Address.DELETEALL;
        end;

        if _QuoteHeader."NS_Contact No." <> '' then begin
            _Address.SETRANGE("Customer No.");
            _Address.SETFILTER("NS_Contact No.", '<>%1&<>%2', '', _QuoteHeader."NS_Contact No.");
            _Address.DELETEALL;
        end;
        COMMIT;
    end;

    procedure NS_DuplicateQuote(_QuoteHeader: Record "NS_Job Quote Header"): Code[20];
    var
        _Address: Record "Ship-to Address";
        _Address2: Record "Ship-to Address";
        _QuoteComment: Record "Comment Line";
        _QuoteComment2: Record "Comment Line";
        _QuoteHeader2: Record "NS_Job Quote Header";
        _QuoteLine: Record "NS_Job Quote Line";
        _QuoteLine2: Record "NS_Job Quote Line";
        _FeatureText: Record "NS_Job Quote Feature Text";
        _FeatureText2: Record "NS_Job Quote Feature Text";
        _ScopeOfWork: Record "NS_Job Quote Scope of Work";
        _ScopeOfWork2: Record "NS_Job Quote Scope of Work";
        _AttributeMgt: Codeunit "NS_Job Quote Mgt.";
        _DimMgt: Codeunit DimensionManagement;
        _NewQuoteNo: Code[20];
    begin
        if _QuoteHeader."NS_Quote No." = '' then
            exit;

        // duplicate header

        _QuoteHeader2.INIT;
        _QuoteHeader2.TRANSFERFIELDS(_QuoteHeader, false);
        _QuoteHeader2."NS_Duplicated-from Quote No." := _QuoteHeader."NS_Quote No.";
        _QuoteHeader2."NS_Copy in Progress" := true;
        _QuoteHeader2.INSERT(true);
        _NewQuoteNo := _QuoteHeader2."NS_Quote No.";

        // addresses

        _Address.SETRANGE("NS_Table ID", DATABASE::"NS_Job Quote Header");
        _Address.SETRANGE("NS_No.", _QuoteHeader."NS_Quote No.");
        if _Address.FINDSET(false) then
            repeat
                _Address2 := _Address;
                _Address2."NS_No." := _NewQuoteNo;
                _Address2.INSERT;
            until _Address.NEXT = 0;

        // lines, attributes; refresh unit cost and unit price

        _QuoteLine.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        if _QuoteLine.FINDSET(false) then
            repeat
                _QuoteLine2 := _QuoteLine;
                _QuoteLine2."NS_Quote No." := _NewQuoteNo;
                _QuoteLine2."NS_Attribute Set Entry No." := NS_DuplicateAttributeSet(_QuoteLine."NS_Attribute Set Entry No.");
                if _QuoteHeader."NS_Preserve Pricing Flag" then
                    with _QuoteLine2 do begin
                        INSERT;
                        "NS_Created by" := USERID;
                        "NS_Created at Date" := TODAY;
                        "NS_Created at Time" := TIME;
                        "NS_Modified by" := '';
                        "NS_Modified at Date" := 0D;
                        "NS_Modified at Time" := 000000T;
                        "NS_Sales Quote No." := _QuoteHeader2."NS_Sales Quote No.";
                        "NS_Sales Quote Line No." := 0;
                    end
                else begin
                    _QuoteLine2.INSERT(true);
                    NS_OnValidateNoQuoteLine(_QuoteLine2);
                    if _QuoteLine2.NS_Description <> _QuoteLine.NS_Description then
                        _QuoteLine2.NS_Description := _QuoteLine.NS_Description;
                    if _QuoteLine2."NS_Unit of Measure Code" <> _QuoteLine."NS_Unit of Measure Code" then
                        _QuoteLine2.VALIDATE("NS_Unit of Measure Code", _QuoteLine."NS_Unit of Measure Code");
                    if (_QuoteLine."NS_Variant Code" = '') and (_QuoteLine.NS_Type = _QuoteLine.NS_Type::Item) and (_QuoteLine."NS_No." <> '') then
                        _QuoteLine2."NS_Variant Code" := NS_GetVariantIfRequired(_QuoteLine."NS_No.");
                    if _QuoteLine2.NS_Quantity <> _QuoteLine.NS_Quantity then
                        _QuoteLine2.VALIDATE(NS_Quantity, _QuoteLine.NS_Quantity);
                    if _QuoteLine2."NS_Vendor Cost" <> _QuoteLine."NS_Vendor Cost" then
                        _QuoteLine2.VALIDATE("NS_Vendor Cost", _QuoteLine."NS_Vendor Cost");
                    if (_QuoteLine2."NS_Unit Price" = 0) and (_QuoteLine."NS_Unit Price" <> 0) then
                        _QuoteLine2.VALIDATE("NS_Unit Price", _QuoteLine."NS_Unit Price");
                    // using NAV price engine; Unit Price retrieved from Sales Quote (T37)
                    // if we re-validate the Markup, we reset the unit price to the source line
                    if _QuoteLine2."NS_Line Discount %" <> _QuoteLine."NS_Line Discount %" then
                        _QuoteLine2.VALIDATE("NS_Line Discount %", _QuoteLine."NS_Line Discount %");
                end;
                if _QuoteLine2."NS_Category Code" <> _QuoteLine."NS_Category Code" then
                    _QuoteLine2."NS_Category Code" := _QuoteLine."NS_Category Code";
                _QuoteLine2.MODIFY;
            until _QuoteLine.NEXT = 0;

        // feature text

        _FeatureText.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        if _FeatureText.FINDSET(false) then
            repeat
                _FeatureText2 := _FeatureText;
                _FeatureText2."NS_Quote No." := _NewQuoteNo;
                _FeatureText2.INSERT(true);
            until _FeatureText.NEXT = 0;

        // scope of work

        _ScopeOfWork.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        if _ScopeOfWork.FINDSET(false) then
            repeat
                _ScopeOfWork2 := _ScopeOfWork;
                _ScopeOfWork2."NS_Quote No." := _NewQuoteNo;
                _ScopeOfWork2.INSERT(true);
            until _ScopeOfWork.NEXT = 0;

        // comments

        _QuoteComment.SETRANGE("Table Name", _QuoteComment."Table Name"::NS_Quote);
        _QuoteComment.SETRANGE("No.", _QuoteHeader."NS_Quote No.");
        if _QuoteComment.FINDSET(false) then
            repeat
                _QuoteComment2 := _QuoteComment;
                _QuoteComment2."No." := _NewQuoteNo;
                _QuoteComment2.INSERT(true);
            until _QuoteComment.NEXT = 0;

        // links

        NS_CopyLinksFromQuoteToQuote(_QuoteHeader2, _QuoteHeader);

        exit(_QuoteHeader2."NS_Quote No.");
    end;

    procedure NS_DuplicateQuoteJQ(_QuoteHeader: Record "NS_Job Quote Header"; CustNo: Code[20]): Code[20];
    var
        _Address: Record "Ship-to Address";
        _Address2: Record "Ship-to Address";
        _QuoteComment: Record "Comment Line";
        _QuoteComment2: Record "Comment Line";
        _QuoteHeader2: Record "NS_Job Quote Header";
        _QuoteLine: Record "NS_Job Quote Line";
        _QuoteLine2: Record "NS_Job Quote Line";
        _FeatureText: Record "NS_Job Quote Feature Text";
        _FeatureText2: Record "NS_Job Quote Feature Text";
        _ScopeOfWork: Record "NS_Job Quote Scope of Work";
        _ScopeOfWork2: Record "NS_Job Quote Scope of Work";
        _CustomerRec: record customer;    //PRJ-1215.JS.1.0 23FEB2022
        _AttributeMgt: Codeunit "NS_Job Quote Mgt.";
        _DimMgt: Codeunit DimensionManagement;
        _NewQuoteNo: Code[20];
        _PPJobTakeoffSegments: Record "NS_Job Takeoff Segments";
        _PPJobTakeoffSegments2: Record "NS_Job Takeoff Segments";
    begin
        if _QuoteHeader."NS_Quote No." = '' then
            exit;

        // duplicate header

        _QuoteHeader2.INIT;
        _QuoteHeader2.TRANSFERFIELDS(_QuoteHeader, false);
        _QuoteHeader2."NS_Duplicated-from Quote No." := _QuoteHeader."NS_Quote No.";
        _QuoteHeader2."NS_Copy in Progress" := true;
        _QuoteHeader2.VALIDATE("NS_Sell-to Customer No.", CustNo);
        //PRJ-1215.JS.1.0 23FEB2022 - Start
        If _CustomerRec.Get(CustNo) then begin
            _QuoteHeader2."NS_Contact No." := _CustomerRec."primary contact no.";
            _QuoteHeader2."NS_Contact Name" := _CustomerRec.Contact;
        end;
        //PRJ-1215.JS.1.0 23FEB2022 - end;    
        NS_OnInsertQuoteCopy(_QuoteHeader2);
        NS_CopyQuoteJob(_QuoteHeader, _QuoteHeader2);
        _NewQuoteNo := _QuoteHeader2."NS_Quote No.";

        // addresses

        _Address.SETRANGE("NS_Table ID", DATABASE::"NS_Job Quote Header");
        _Address.SETRANGE("NS_No.", _QuoteHeader."NS_Quote No.");
        if _Address.FINDSET(false) then
            repeat
                _Address2 := _Address;
                _Address2."NS_No." := _NewQuoteNo;
                _Address2.INSERT;
            until _Address.NEXT = 0;

        // lines, attributes; refresh unit cost and unit price

        _QuoteLine.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        if _QuoteLine.FINDSET(false) then
            repeat
                _QuoteLine2 := _QuoteLine;
                _QuoteLine2."NS_Quote No." := _NewQuoteNo;
                with _QuoteLine2 do begin
                    INSERT;
                    "NS_Created by" := USERID;
                    "NS_Created at Date" := TODAY;
                    "NS_Created at Time" := TIME;
                    "NS_Modified by" := '';
                    "NS_Modified at Date" := 0D;
                    "NS_Modified at Time" := 000000T;
                    "NS_Sales Quote No." := _QuoteHeader2."NS_Sales Quote No.";
                    "NS_Sales Quote Line No." := 0;
                end;
                _QuoteLine2.MODIFY;
            until _QuoteLine.NEXT = 0;

        // feature text

        _FeatureText.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        if _FeatureText.FINDSET(false) then
            repeat
                _FeatureText2 := _FeatureText;
                _FeatureText2."NS_Quote No." := _NewQuoteNo;
                _FeatureText2.INSERT(true);
            until _FeatureText.NEXT = 0;

        // scope of work

        _ScopeOfWork.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        if _ScopeOfWork.FINDSET(false) then
            repeat
                _ScopeOfWork2 := _ScopeOfWork;
                _ScopeOfWork2."NS_Quote No." := _NewQuoteNo;
                _ScopeOfWork2.INSERT(true);
            until _ScopeOfWork.NEXT = 0;


        // comments

        _QuoteComment.SETRANGE("Table Name", _QuoteComment."Table Name"::NS_Quote);
        _QuoteComment.SETRANGE("No.", _QuoteHeader."NS_Quote No.");
        if _QuoteComment.FINDSET(false) then
            repeat
                _QuoteComment2 := _QuoteComment;
                _QuoteComment2."No." := _NewQuoteNo;
                _QuoteComment2.INSERT(true);
            until _QuoteComment.NEXT = 0;

        // links

        NS_CopyLinksFromQuoteToQuote(_QuoteHeader2, _QuoteHeader);

        // Tasks and Planning
        NS_CopyQuoteTaskLines(_QuoteHeader, _QuoteHeader2);
        NS_CopyQuotePlanningLines(_QuoteHeader2);

        //Takeoff Segments
        _PPJobTakeoffSegments.RESET;
        _PPJobTakeoffSegments.SETRANGE("NS_Job No.", _QuoteHeader."NS_Job No.");
        if _PPJobTakeoffSegments.FINDSET then
            repeat
                _PPJobTakeoffSegments2 := _PPJobTakeoffSegments;
                _PPJobTakeoffSegments2."NS_Job No." := _QuoteHeader2."NS_Job No.";
                _PPJobTakeoffSegments2.INSERT(true);
            until _PPJobTakeoffSegments.NEXT = 0;

        exit(_QuoteHeader2."NS_Quote No.");
    end;

    procedure NS_EditAddresses(_QuoteNo: Code[20]);
    var
        _Address: Record "Ship-to Address";
    begin
        _Address.FILTERGROUP := 4;
        _Address.SETRANGE("NS_Table ID", DATABASE::"NS_Job Quote Header");
        _Address.SETRANGE("NS_No.", _QuoteNo);
        _Address.FILTERGROUP := 0;
        PAGE.RUNMODAL(PAGE::"Ship-to Address List", _Address);
    end;

    procedure NS_GetCatCodeForItem(_ItemNo: Code[20]): Code[10];
    var
        _Item: Record Item;
    begin
        if _Item.GET(_ItemNo) then
            exit(_Item."Item Category Code");
    end;

    procedure NS_GetDescForItem(_ItemNo: Code[20]): Text[50];
    var
        _Item: Record Item;
    begin
        if _Item.GET(_ItemNo) then
            exit(_Item.Description);
    end;

    procedure NS_GetName(_TableID: Integer; _FieldNo: Integer; _Code: Code[20]; var _Value: Text[50]);
    var
        _Contact: Record Contact;
        _Job: Record Job;
        _QuoteHeader: Record "NS_Job Quote Header";
        _Resource: Record Resource;
    begin
        case _TableID of
            DATABASE::"NS_Job Quote Header":
                case _FieldNo of
                    _QuoteHeader.FIELDNO("NS_General Contractor No."):
                        if _Contact.GET(_Code) then
                            _Value := _Contact.Name
                        else
                            _Value := '';
                    _QuoteHeader.FIELDNO("NS_Architect/Engineer No."):
                        if _Contact.GET(_Code) then
                            _Value := _Contact.Name
                        else
                            _Value := '';
                    _QuoteHeader.FIELDNO("NS_Project Manager No."):
                        // >> Upgrade
                        // if _Resource.GET(_Code) then
                        //     _Value := _Resource.Name
                        if Salesperson.Get(_Code) then //FDD109
                            _Value := Salesperson.Name //FDD109
                        else
                            _Value := '';
                // << Upgrade
                end;
            DATABASE::Job:
                case _FieldNo of
                    _Job.FIELDNO("NS_General Contractor No."):
                        if _Contact.GET(_Code) then
                            _Value := _Contact.Name
                        else
                            _Value := '';
                    _Job.FIELDNO("NS_Architect/Engineer No."):
                        if _Contact.GET(_Code) then
                            _Value := _Contact.Name
                        else
                            _Value := '';
                    _Job.FIELDNO("NS_Project Manager No."):
                        if _Resource.GET(_Code) then
                            _Value := _Resource.Name
                        else
                            _Value := '';
                end;
        end;
    end;

    procedure NS_GetNonNoPortion(_NoSeriesCode: Code[20]): Code[20];
    begin
        exit(DELCHR(_NoSeriesCode, '=', '0123456789'));
    end;

    procedure NS_GetNoPortion(_NoSeriesCode: Code[20]): Code[20];
    begin
        exit(DELCHR(_NoSeriesCode, '=', DELCHR(_NoSeriesCode, '=', '0123456789')));
    end;

    procedure NS_GetQuoteHeaderC50000(_QuoteLine: Record "NS_Job Quote Line");
    begin
        CLEAR(QuoteHeader);
        QuoteHeader.GET(_QuoteLine."NS_Quote No.");
    end;

    procedure NS_GetEnhQuoteNoFrOrderNo(_QuoteNo: Code[20]; _OrderNo: Code[20]): Code[20];
    var
        _QuoteHeader: Record "NS_Job Quote Header";
    begin
        //PE-300-DK.1.0 29May2024 Start
        //_QuoteHeader.SETRANGE(NS_Status, _QuoteHeader.NS_Status::Closed);
        _QuoteHeader.SETRANGE("NS_Quote Status", _QuoteHeader."NS_Quote Status"::Closed);
        //PE-300-DK.1.0 29May2024 End
        _QuoteHeader.SETRANGE("NS_Sales Order No.", _OrderNo);
        if not _QuoteHeader.FINDFIRST then
            exit(_QuoteNo)
        else
            exit(_QuoteHeader."NS_Quote No.");
    end;

    procedure NS_GetQuoteRelTypeFromTableID(_TableID: Integer): Integer;
    begin
        case _TableID of
            DATABASE::"G/L Account":
                exit(1);
            DATABASE::Item:
                exit(2);
            DATABASE::Resource:
                exit(3);
        end;
    end;

    procedure NS_GetDescriptionQuoteTypeRelation(var _QuoteTypeRelation: Record "NS_Job Quote Type Relation");
    var
        _GLAcc: Record "G/L Account";
        _Item: Record Item;
        _Res: Record Resource;
    begin
        with _QuoteTypeRelation do begin
            case "NS_Table ID" of
                DATABASE::Item:
                    begin
                        _Item.GET("NS_No.");
                        NS_Description := _Item.Description;
                        "NS_Category Code" := _Item."Item Category Code";
                    end;
                DATABASE::Resource:
                    begin
                        _Res.GET("NS_No.");
                        NS_Description := _Res.Name;
                    end;
                DATABASE::"G/L Account":
                    begin
                        _GLAcc.GET("NS_No.");
                        NS_Description := _GLAcc.Name;
                    end;
            end;
        end;
    end;

    procedure NS_GetItemNo2(_ItemNo: Code[20]): Code[30];
    var
        _Item: Record Item;
    begin
        if _Item.GET(_ItemNo) then
            exit(_Item."No. 2");
    end;

    procedure NS_GetLatestRevisionNo(_QuoteHeader: Record "NS_Job Quote Header") _Revision: Integer;
    var
        _QuoteHeader2: Record "NS_Job Quote Header";
    begin
        if _QuoteHeader."NS_Link-to Quote No." = '' then
            exit(0);

        _Revision := _QuoteHeader.NS_Revision;
        _QuoteHeader2.SETCURRENTKEY("NS_Link-to Quote No.");
        _QuoteHeader2.SETRANGE("NS_Link-to Quote No.", _QuoteHeader."NS_Link-to Quote No.");
        if _QuoteHeader2.FINDSET(false) then
            repeat
                if _QuoteHeader2.NS_Revision > _Revision then
                    _Revision := _QuoteHeader2.NS_Revision;
            until _QuoteHeader2.NEXT = 0;
    end;

    procedure NS_GetObjectName(_Type: Integer; _ID: Integer): Text;
    var
        _Object: Record allobj;
    begin
        _Object.SETRANGE("Object Type", _Type);
        _Object.SETRANGE("Object ID", _ID);
        if not _Object.FINDFIRST then
            _Object.INIT;
        exit(_Object."Object Name");
    end;

    procedure NS_GetNextNo(): Code[20];
    var
        _NoSeries: Record "No. Series";
        _NoSeriesMgt: Codeunit NoSeriesManagement;
        QuoteSetup: Record "Jobs Setup";
    begin
        QuoteSetup.GET;
        QuoteSetup.TESTFIELD("Job Nos.");
        QuoteSetup.TESTFIELD("NS_Job Quote No. Series");
        _NoSeries.GET(QuoteSetup."NS_Job Quote No. Series");
        _NoSeries.TESTFIELD("Default Nos.");
        exit(_NoSeriesMgt.GetNextNo(QuoteSetup."NS_Job Quote No. Series", WORKDATE, true));
    end;

    procedure NS_GetQuoteLine(_QuoteLine: Record "NS_Job Quote Line");
    begin
        CLEAR(SalesLine);
        if _QuoteLine."NS_Sales Quote Line No." <> 0 then
            SalesLine.GET(SalesLine."Document Type"::Quote, _QuoteLine."NS_Sales Quote No.", _QuoteLine."NS_Sales Quote Line No.");
    end;

    procedure NS_GetEquipGrossMarginPct(_QuoteHeader: Record "NS_Job Quote Header"): Decimal;
    var
        _QuoteLine: Record "NS_Job Quote Line";
        _TotalAmount: Decimal;
        _TotalCostOfGoodsSold: Decimal;
        _UnitCost: Decimal;
    begin
        _QuoteLine.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        _QuoteLine.SETRANGE(NS_Type, _QuoteLine.NS_Type::Item);
        if _QuoteLine.FINDSET(false) then
            repeat
                _UnitCost := _QuoteLine."NS_Vendor Cost";
                if _UnitCost = 0 then
                    _UnitCost := _QuoteLine."NS_Unit Cost";
                _UnitCost := _QuoteLine."NS_Total Cost";
                _TotalAmount += _QuoteLine.NS_Amount;
                _TotalCostOfGoodsSold := _TotalCostOfGoodsSold + _UnitCost * _QuoteLine.NS_Quantity;
            until _QuoteLine.NEXT = 0;

        if _TotalAmount = 0 then
            exit(0)
        else
            exit(ROUND((_TotalAmount - _TotalCostOfGoodsSold) / ABS(_TotalAmount) * 100, 0.01));
    end;

    procedure NS_GetTotalGrossMarginPct(_QuoteHeader: Record "NS_Job Quote Header"): Decimal;
    var
        _QuoteLine: Record "NS_Job Quote Line";
        _TotalAmount: Decimal;
        _TotalCostOfGoodsSold: Decimal;
        _UnitCost: Decimal;
    begin
        _QuoteLine.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        if _QuoteLine.FINDSET(false) then
            repeat
                _UnitCost := _QuoteLine."NS_Vendor Cost";
                if _UnitCost = 0 then
                    _UnitCost := _QuoteLine."NS_Unit Cost";
                _UnitCost := _QuoteLine."NS_Total Cost";
                _TotalAmount += _QuoteLine.NS_Amount;
                _TotalCostOfGoodsSold := _TotalCostOfGoodsSold + _UnitCost * _QuoteLine.NS_Quantity;
            until _QuoteLine.NEXT = 0;

        if _TotalAmount = 0 then
            exit(0)
        else
            exit(ROUND((_TotalAmount - _TotalCostOfGoodsSold) / ABS(_TotalAmount) * 100, 0.01));
    end;

    procedure NS_GetVariantIfRequired(_ItemNo: Code[20]): Code[10];
    var
        _ItemVariant: Record "Item Variant";
    begin
        _ItemVariant.SETRANGE("Item No.", _ItemNo);
        if _ItemVariant.ISEMPTY then
            exit;

        _ItemVariant.SETRANGE(Code, 'OEM');
        if not _ItemVariant.ISEMPTY then
            exit('OEM');

        _ItemVariant.SETFILTER(Code, 'OEM*');
        if _ItemVariant.FINDFIRST then
            exit(_ItemVariant.Code);

        _ItemVariant.SETRANGE(Code);
        if _ItemVariant.FINDFIRST then
            exit(_ItemVariant.Code);
    end;

    procedure NS_GetVendorInfoUsingNavQuoteNo(_NavQuoteNo: Code[20]; _LineNo: Integer; var _VendorNo: Code[20]; var _VendorName: Text[50]; var _VendorContact: Text[50]; var _VendorContactNo: Code[20]; var _VendorQuoteNo: Text[30]; var _VendorCost: Decimal);
    var
        _QuoteHeader: Record "NS_Job Quote Header";
        _QuoteLine: Record "NS_Job Quote Line";
    begin
        CLEAR(_VendorNo);
        CLEAR(_VendorName);
        CLEAR(_VendorContact);
        CLEAR(_VendorContactNo);
        CLEAR(_VendorQuoteNo);
        CLEAR(_VendorCost);

        _QuoteHeader.SETCURRENTKEY("NS_Sales Quote No.");
        _QuoteHeader.SETRANGE("NS_Sales Quote No.", _NavQuoteNo);
        if not _QuoteHeader.FINDFIRST then
            exit;

        _QuoteLine.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        _QuoteLine.SETRANGE("NS_Sales Quote Line No.", _LineNo);
        if not _QuoteLine.FINDFIRST then
            exit;

        _VendorNo := _QuoteLine."NS_Vendor No.";
        _VendorName := _QuoteLine."NS_Vendor Name";
        _VendorContact := _QuoteLine."NS_Vendor Contact";
        _VendorContactNo := _QuoteLine."NS_Vendor Contact No.";
        _VendorQuoteNo := _QuoteLine."NS_Vendor Quote No.";
        _VendorCost := _QuoteLine."NS_Vendor Cost";
    end;

    procedure NS_ImportInstallation(_QuoteNo: Code[20]);
    begin
        NS_ImportInstallationText(_QuoteNo);
    end;

    procedure NS_ImportInstallationText(_QuoteNo: Code[20]);
    var
        _FilenameData: Label 'InstallBidFormData.txt';
        _PathData: Label 'c:\temp\';
        _QuoteHeader: Record "NS_Job Quote Header";
        _QuoteInstallImportLine: Record "NS_Job Quote Import Line";
        _QuoteInstallJobsSetupSvc: Record "NS_Job Quote Install";
        _QuoteLine: Record "NS_Job Quote Line";
        _QuoteSetup: Record "Jobs Setup";
        _GLAccNoServLine: Code[20];
        _ResNoServLine: Code[20];
        _File: File;
        _TotalCost: Decimal;
        _TotalCostForService: Decimal;
        _TotalPrice: Decimal;
        _TotalPriceForService: Decimal;
        _is: InStream;
        _k: Integer;
        _m: Integer;
        _LineNo: Integer;
        _rc: Integer;
        _FilenameImport: Text[250];
        _PathTemp: Text[250];
        _TempFilename: Text[250];
        _Text000: Label '%1%2 does not exist.  Please run the macro in the Install Bid Form by pressing Ctrl + K.';
        _TextLine: Text[1024];
        _Text001: Label 'Installation data already exists for this quote.  Erase existing data?';
        _Text002: Label 'The position of data in the exported text file does not match system specifications.  The Installation Bid data will not be imported.  Identifying data:  %1 %2 %3, %4.';
        _Text003: Label 'Unable to find the import file.  Did you execute the macro in Excel?';
    begin
        _QuoteSetup.GET;
        _QuoteSetup.TESTFIELD("NS_ResourceNo. forInstallLine");
        _QuoteSetup.TESTFIELD("NS_Install Category Code");
        _QuoteSetup.TESTFIELD("NS_ResourceNo. forServiceLine");

        if not _QuoteHeader.GET(_QuoteNo) then
            exit;
        //PE-300-DK.1.0 29May2024 Start
        // _QuoteHeader.TESTFIELD(NS_Status, _QuoteHeader.NS_Status::Open);
        _QuoteHeader.TESTFIELD("NS_Quote Status", _QuoteHeader."NS_Quote Status"::Open);
        //PE-300-DK.1.0 29May2024 End
        // 20130930 - because the majority of J&F users will be accessing the NAV Windows Client via
        // Remote Desktop published application, the "local" drive to the client is \\ts01\c, not their
        // local drive.  Syntech is mapping T: for every Terminal Service user to \\nav1\Transfer.
        // The macro in the Install Bid Form has been changed to save to T:\Transfer; thus, the code
        // below to do all the file wrangling is no longer necessary.  It remains here as a helpful template.

        /*
        // automatically retrieve a file from client c:\temp ... thanks Lars: http://tinyurl.com/k8gcplz
        
        _File.CREATETEMPFILE;
        _File.CREATEINSTREAM(_is);
        DOWNLOADFROMSTREAM(_is,'','<TEMP>','',_TempFilename);
        _File.CLOSE;
        
        FOR _k := STRLEN(_TempFilename) DOWNTO 1 DO
          IF _TempFilename[_k] = '\' THEN BEGIN
            _PathTemp := COPYSTR(_TempFilename,1,_k);
            _k := 1;
          END;
        
        IF NOT ISCLEAR(_FileSystemObj) THEN
          CLEAR(_FileSystemObj);
        CREATE(_FileSystemObj,TRUE,TRUE);
        IF NOT _FileSystemObj.FileExists(_PathData + _FilenameData) THEN
          ERROR(_Text000,_PathData,_FilenameData);
        IF _FileSystemObj.FileExists(_PathTemp + _FilenameData) THEN
          _FileSystemObj.DeleteFile(_PathTemp + _FilenameData,TRUE);
        _FileSystemObj.MoveFile(_PathData + _FilenameData,_PathTemp + _FilenameData);
        CLEAR(_FileSystemObj);
        UPLOAD('','<TEMP>','',_FilenameData,_FilenameImport);
        */

        // generate import filename - local to middle-tier

        _TempFilename := LOWERCASE(USERID);
        for _k := STRLEN(_TempFilename) downto 1 do
            if _TempFilename[_k] = '\' then
                if _m = 0 then
                    _m := _k;
        if _m <> 0 then
            _TempFilename := COPYSTR(_TempFilename, _m + 1);
        _FilenameImport := 'c:\Transfer\InstallBidFormData-' + _TempFilename + '.txt';

        CLEAR(_File);
        //PPNA16.0 Blocked Start
        // _File.WRITEMODE(false);
        // _File.TEXTMODE(true);
        // if not _File.OPEN(_FilenameImport) then begin
        //     _FilenameImport := 'c:\temp\InstallBidFormData-' + _TempFilename + '.txt';
        //     if not _File.OPEN(_FilenameImport) then
        //         ERROR(_Text003);
        // end;
        //PPNA16.0 Blocked End

        // get GLAcc information for service line

        _QuoteInstallJobsSetupSvc.SETFILTER(NS_Type, '%1|%2', 'Service', 'SERVICE');
        if _QuoteInstallJobsSetupSvc.FINDFIRST then
            _GLAccNoServLine := _QuoteInstallJobsSetupSvc."NS_G/L Account No.";
        if _GLAccNoServLine = '' then
            _GLAccNoServLine := _QuoteSetup."NS_G/L AccountNo.-ServiceLine";

        _ResNoServLine := _QuoteSetup."NS_ResourceNo. forServiceLine";

        // erase existing installation data

        _QuoteInstallImportLine.SETRANGE("NS_Quote No.", _QuoteNo);
        if not _QuoteInstallImportLine.ISEMPTY then
            if not HideValidationDialog then
                if not CONFIRM(_Text001, false) then
                    exit;
        _QuoteInstallImportLine.DELETEALL;

        _QuoteLine.SETRANGE("NS_Quote No.", _QuoteNo);
        _QuoteLine.SETRANGE(NS_Type, _QuoteLine.NS_Type::Resource);
        _QuoteLine.SETRANGE("NS_No.", _QuoteSetup."NS_ResourceNo. forInstallLine");
        _QuoteLine.DELETEALL;
        _QuoteLine.SETRANGE(NS_Type, _QuoteLine.NS_Type::"G/L Account");
        _QuoteLine.SETRANGE("NS_No.", _GLAccNoServLine);
        _QuoteLine.DELETEALL;

        _QuoteLine.SETRANGE(NS_Type, _QuoteLine.NS_Type::Resource);
        _QuoteLine.SETRANGE("NS_No.", _ResNoServLine);
        _QuoteLine.DELETEALL;

        // import the data

        //PPNA16.0 Blocked Start
        // while not (_File.READ(_TextLine) = 0) do begin
        //     ParseTabDelimitedLine(_TextLine);
        //     _LineNo += 10000;
        //     with _QuoteInstallImportLine do begin
        //         INIT;
        //         "NS_Quote No." := _QuoteNo;
        //         "NS_Line No." := _LineNo;
        //         "NS_Column 1 Value" := COPYSTR(Fields[1], 1, MAXSTRLEN("NS_Column 1 Value"));
        //         "NS_Column 2 Value" := COPYSTR(Fields[2], 1, MAXSTRLEN("NS_Column 2 Value"));
        //         "NS_Column 3 Value" := COPYSTR(Fields[3], 1, MAXSTRLEN("NS_Column 3 Value"));
        //         "NS_Column 4 Value" := COPYSTR(Fields[4], 1, MAXSTRLEN("NS_Column 4 Value"));
        //         "NS_Column 5 Value" := COPYSTR(Fields[5], 1, MAXSTRLEN("NS_Column 5 Value"));
        //         "NS_Column 6 Value" := COPYSTR(Fields[6], 1, MAXSTRLEN("NS_Column 6 Value"));
        //         "NS_Column 7 Value" := COPYSTR(Fields[7], 1, MAXSTRLEN("NS_Column 7 Value"));
        //         "NS_Column 8 Value" := COPYSTR(Fields[8], 1, MAXSTRLEN("NS_Column 8 Value"));
        //         "NS_Column 9 Value" := COPYSTR(Fields[9], 1, MAXSTRLEN("NS_Column 9 Value"));
        //         INSERT(true);
        //     end;
        // end;
        // _File.CLOSE;
        //PPNA16.0 Blocked End

        // erase the import file

        //if ERASE(_FilenameImport) then; //PPNA16.0 Blocked 

        // create lines on Quote for INSTALL, SERVICE

        if not _QuoteInstallImportLine.GET(_QuoteNo, 170000) then
            ERROR(_Text002, _QuoteInstallImportLine.TABLECAPTION, _QuoteNo, '170000', 'Installation Contract Amount');
        if not EVALUATE(_TotalPrice, _QuoteInstallImportLine."NS_Column 2 Value") then
            ERROR(_Text002, _QuoteInstallImportLine.TABLECAPTION, _QuoteNo, '170000', 'Installation Contract Amount');

        if not _QuoteInstallImportLine.GET(_QuoteNo, 680000) then
            ERROR(_Text002, _QuoteInstallImportLine.TABLECAPTION, _QuoteNo, '680000', 'Total cost');
        if not EVALUATE(_TotalCost, _QuoteInstallImportLine."NS_Column 9 Value") then
            ERROR(_Text002, _QuoteInstallImportLine.TABLECAPTION, _QuoteNo, '680000', 'Total cost');

        if not _QuoteInstallImportLine.GET(_QuoteNo, 140000) then
            ERROR(_Text002, _QuoteInstallImportLine.TABLECAPTION, _QuoteNo, '140000', 'Service price');
        if not EVALUATE(_TotalCostForService, _QuoteInstallImportLine."NS_Column 8 Value") then
            ERROR(_Text002, _QuoteInstallImportLine.TABLECAPTION, _QuoteNo, '140000', 'Service cost');
        if not EVALUATE(_TotalPriceForService, _QuoteInstallImportLine."NS_Column 2 Value") then
            ERROR(_Text002, _QuoteInstallImportLine.TABLECAPTION, _QuoteNo, '140000', 'Service price');
        _TotalCost -= _TotalCostForService;
        _TotalPrice -= _TotalPriceForService;

        CLEAR(_LineNo);
        CLEAR(_QuoteLine);
        with _QuoteLine do begin
            RESET;
            SETRANGE("NS_Quote No.", _QuoteNo);
            if FINDLAST then
                _LineNo := _QuoteLine."NS_Quote Line No.";
            _LineNo += 10000;

            // line for INSTALL

            if (_TotalCost <> 0) or (_TotalPrice <> 0) then begin
                INIT;
                "NS_No." := _QuoteHeader."NS_Quote No.";
                "NS_Quote Line No." := _LineNo;
                INSERT(true);
                NS_Type := NS_Type::Resource;
                "NS_No." := _QuoteSetup."NS_ResourceNo. forInstallLine";
                NS_OnValidateNoQuoteLine(_QuoteLine);
                VALIDATE(NS_Quantity, 1);
                if _TotalCost <> 0 then
                    VALIDATE("NS_Vendor Cost", _TotalCost);
                if _TotalPrice <> 0 then
                    VALIDATE("NS_Unit Price", _TotalPrice);
                "NS_Category Code" := _QuoteSetup."NS_Install Category Code";
                MODIFY(true);
            end;

            // line for SERVICE

            if (_TotalCostForService <> 0) or (_TotalPriceForService <> 0) then begin
                _LineNo += 10000;
                INIT;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                "NS_Quote Line No." := _LineNo;
                INSERT(true);
                NS_Type := NS_Type::Resource;
                "NS_No." := _ResNoServLine;
                NS_OnValidateNoQuoteLine(_QuoteLine);
                NS_Description := _QuoteSetup."NS_Service Line Description";
                VALIDATE(NS_Quantity, 1);
                if _TotalCostForService <> 0 then
                    VALIDATE("NS_Vendor Cost", _TotalCostForService);
                if _TotalPriceForService <> 0 then
                    VALIDATE("NS_Unit Price", _TotalPriceForService);
                "NS_Category Code" := _QuoteSetup."NS_Service Category Code";
                MODIFY(true);
            end;
        end;

    end;

    procedure NS_Inactive(var _QuoteHeader: Record "NS_Job Quote Header");
    begin

        //with _QuoteHeader do
        //PE-300-DK.1.0 29May2024 Start
        // case _QuoteHeader.NS_Status of
        //     _QuoteHeader.NS_Status::Open:
        //         begin
        //             _QuoteHeader.NS_Status := _QuoteHeader.NS_Status::Inactive;
        //             _QuoteHeader.MODIFY();
        //         end;
        //     _QuoteHeader.NS_Status::Inactive:
        //         begin
        //             _QuoteHeader.NS_Status := _QuoteHeader.NS_Status::Open;
        //             _QuoteHeader.MODIFY();
        //         end;
        //     else
        //         _QuoteHeader.FIELDERROR(NS_Status);
        // end;

        case _QuoteHeader."NS_Quote Status" of
            _QuoteHeader."NS_Quote Status"::Open:
                begin
                    _QuoteHeader."NS_Quote Status" := _QuoteHeader."NS_Quote Status"::Inactive;
                    _QuoteHeader.MODIFY();
                end;
            _QuoteHeader."NS_Quote Status"::Inactive:
                begin
                    _QuoteHeader."NS_Quote Status" := _QuoteHeader."NS_Quote Status"::Open;
                    _QuoteHeader.MODIFY();
                end;
            else
                _QuoteHeader.FIELDERROR("NS_Quote Status");
        end;
        //PE-300-DK.1.0 29May2024 End

    end;

    procedure NS_JobOnValidateJobSiteCustNo(var _Job: Record Job);
    var
        _Customer: Record Customer;
    begin
        if _Job."NS_Job Site Customer No." = '' then
            exit;

        if _Customer.GET(_Job."NS_Job Site Customer No.") then
            with _Job do begin
                "NS_Job Site Customer Name" := COPYSTR(_Customer.Name, 1, MAXSTRLEN("NS_Job Site Customer Name"));
                "NS_Job Address 1" := COPYSTR(_Customer.Address, 1, MAXSTRLEN("NS_Job Address 1"));
                "NS_Job Address 2" := COPYSTR(_Customer."Address 2", 1, MAXSTRLEN("NS_Job Address 2"));
                "NS_Job City" := COPYSTR(_Customer.City, 1, MAXSTRLEN("NS_Job City"));
                "NS_Job County" := COPYSTR(_Customer.County, 1, MAXSTRLEN("NS_Job County"));
                "NS_Job Post Code" := COPYSTR(_Customer."Post Code", 1, MAXSTRLEN("NS_Job Post Code"));
                "NS_Job Country/Region Code" := COPYSTR(_Customer."Country/Region Code", 1, MAXSTRLEN("NS_Job Country/Region Code"));
                "NS_Job Contact" := COPYSTR(_Customer.Contact, 1, MAXSTRLEN("NS_Job Contact"));
                "NS_Job Phone" := COPYSTR(_Customer."Phone No.", 1, MAXSTRLEN("NS_Job Phone"));
            end;
    end;

    procedure NS_JobOnValidateOwnerNo(var _Job: Record Job);
    var
        _Customer: Record Customer;
    begin
        CLEAR(_Job."NS_Owner Name");
        if _Job."NS_Owner No." = '' then
            exit;

        if _Customer.GET(_Job."NS_Owner No.") then
            _Job."NS_Owner Name" := _Customer.Name;
    end;

    procedure NS_LoadFromGLAct(qGLAct: Record "G/L Account"; var qQuoteLine: Record "NS_Job Quote Line");
    var
        JobTask: Record "Job Task";
        JobTaskList: Page "Job Task Lines";
        qJobPlanLine: Record "Job Planning Line";
        qJobPlanLine2: Record "Job Planning Line";
        LineNo: Integer;
        qJob: Record Job;
        JPLine: Record "Job Planning Line";//PPAL-147.AS.2.0 30SEPT2020
        NS_Jobsetup: Record "Jobs Setup"; //PRJCTPR-153.PS.1.0 18Jul2023
    begin

        NS_GetQuoteHeaderC50000(qQuoteLine);

        qJobPlanLine.SETRANGE("Job No.", qQuoteLine."NS_Quote No.");
        qJobPlanLine.SETRANGE("Job Task No.", qQuoteLine."NS_Job Task No.");
        qJobPlanLine.SETRANGE("No.", qQuoteLine."NS_No.");
        //qJobPlanLine.SETRANGE("NS_Entry Type", qJobPlanLine."NS_Entry Type"::Both);//PPAL-147.AS.2.0 02Oct2020 Commented
        //qJobPlanLine.SETRANGE("Line Type", qJobPlanLine."Line Type"::"Both Budget and Billable");	//PPAL-147.AS.2.0 02Oct2020 Commented
        qJobPlanLine.SETRANGE(Type, qJobPlanLine.Type::"G/L Account");
        if qJobPlanLine.FINDFIRST then begin
            qJobPlanLine."No." := qQuoteLine."NS_No.";
            //qJobPlanLine.MODIFY;//PPAL-147.AS.2.0 02Oct2020 Commented
            qJobPlanLine.MODIFY(true);//PPAL-147.AS.2.0 02Oct2020 Added
            exit;
        end;

        //PPAL-147.AS.2.0 02Oct2020 - Start Added condition in begin end
        JPLine.Reset;
        JPLine.SetRange("Job No.", qQuoteLine."NS_Quote No.");
        JPLine.SetRange("Job Task No.", qQuoteLine."NS_Job Task No.");
        JPLine.SetRange("Line No.", qQuoteLine."NS_Quote Line No.");
        if not JPLine.FindFirst then begin
            qJobPlanLine2.RESET;
            qJobPlanLine2.SETRANGE("Job No.", qQuoteLine."NS_Quote No.");
            if qJobPlanLine2.FINDLAST then
                LineNo := qJobPlanLine2."Line No." + 10000
            else
                LineNo := 10000;

            qJobPlanLine.INIT;
            qJobPlanLine."Job No." := qQuoteLine."NS_Quote No.";
            qJobPlanLine."Job Task No." := qQuoteLine."NS_Job Task No.";
            qJobPlanLine."Line No." := LineNo;
            qJobPlanLine."Document No." := qJobPlanLine2."Document No.";
            qJobPlanLine.Type := qJobPlanLine.Type::"G/L Account";
            qJobPlanLine."No." := qGLAct."No.";
            qJobPlanLine.Description := qGLAct.Name;
            qJobPlanLine."Gen. Prod. Posting Group" := qGLAct."Gen. Prod. Posting Group";
            qJobPlanLine."Unit of Measure Code" := 'EA';
            qJobPlanLine."Unit Cost" := 0;
            qJobPlanLine."Unit Price" := 0;
            qJobPlanLine."NS_Cost Category" := 'ADM';
            qJobPlanLine."Planning Date" := QuoteHeader."NS_Proposal Date";//PPAL-147.AS.2.0 06Oct2020 Add
            qJobPlanLine."Planned Delivery Date" := QuoteHeader."NS_Proposal Date";//PPAL-147.AS.2.0 06Oct2020 Add
                                                                                   //PRJCTPR-153.PS.1.0 11Jul2023 Start
            if NS_Jobsetup.Get() then;
            qJobPlanLine."Usage Link" := NS_Jobsetup."Apply Usage Link by Default";
            //PRJCTPR-153.PS.1.0 11Jul2023 End 
            qJobPlanLine.INSERT;

            qQuoteLine."NS_Unit of Measure Code" := 'EA';
            qQuoteLine."NS_Unit Cost" := 0;
            qQuoteLine."NS_Unit Price" := 0;
            qQuoteLine."NS_Qty. per Unit of Measure" := 1;
        end;
        if JPLine.FindFirst then begin
            qJobPlanLine."Job No." := qQuoteLine."NS_Quote No.";
            qJobPlanLine."Job Task No." := qQuoteLine."NS_Job Task No.";
            qJobPlanLine."Line No." := qQuoteLine."NS_Quote Line No.";
            qJobPlanLine."Document No." := qJobPlanLine2."Document No.";
            qJobPlanLine.Type := qJobPlanLine.Type::"G/L Account";
            qJobPlanLine."No." := qGLAct."No.";
            qJobPlanLine.Description := qGLAct.Name;
            qJobPlanLine."Gen. Prod. Posting Group" := qGLAct."Gen. Prod. Posting Group";
            qJobPlanLine."Unit of Measure Code" := qQuoteLine."NS_Unit of Measure Code";
            qJobPlanLine."Unit Cost" := qQuoteLine."NS_Unit Cost";
            qJobPlanLine."Unit Price" := qQuoteLine."NS_Unit Price";
            qJobPlanLine."Line Amount" := qQuoteLine.NS_Amount;
            qJobPlanLine."Line Discount %" := qQuoteLine."NS_Line Discount %";
            qJobPlanLine.Quantity := qQuoteLine.NS_Quantity;
            qJobPlanLine."Quantity (Base)" := qQuoteLine."NS_Quantity (Base)";
            qJobPlanLine."NS_Revenue Category" := qQuoteLine."NS_Revenue Category";
            //PRJCTPR-153.PS.1.0 11Jul2023 Start
            if NS_Jobsetup.Get() then;
            qJobPlanLine."Usage Link" := NS_Jobsetup."Apply Usage Link by Default";
            //PRJCTPR-153.PS.1.0 11Jul2023 End 
            qJobPlanLine.Modify;
        end;
        //PPAL-147.AS.2.0 02Oct2020 End - Added condition

        qQuoteLine."NS_Unit of Measure Code" := 'EA';
        qQuoteLine."NS_Unit Cost" := 0;
        qQuoteLine."NS_Unit Price" := 0;
        qQuoteLine."NS_Qty. per Unit of Measure" := 1;
        qQuoteLine."NS_Total Cost" := 0;//PPAL-147.AS.2.0 02Oct2020
        qQuoteLine."NS_Total Price" := 0;//PPAL-147.AS.2.0 02Oct2020
        qQuoteLine.NS_Amount := 0;//PPAL-147.AS.2.0 02Oct2020
        qQuoteLine."NS_Line Discount %" := 0;//PPAL-147.AS.2.0 02Oct2020
        qQuoteLine.NS_Quantity := 0;//PPAL-147.AS.2.0 02Oct2020
    end;

    procedure NS_LoadFromItem(var qQuoteLine: Record "NS_Job Quote Line"; qItem: Record Item);
    var
        JobTask: Record "Job Task";
        JobTaskList: Page "Job Task Lines";
        qJobPlanLine: Record "Job Planning Line";
        qJobPlanLine2: Record "Job Planning Line";
        LineNo: Integer;
        qJob: Record Job;
        ItemUoMTbl: Record "Item Unit of Measure";
        QtyUoM: Decimal;
        JPLine: Record "Job Planning Line";//PPAL-147.AS.2.0 05Oct2020
        NS_Jobsetup: Record "Jobs Setup"; //PRJCTPR-153.PS.1.0 18Jul2023
    begin
        NS_GetQuoteHeaderC50000(qQuoteLine);

        qJobPlanLine.SETRANGE("Job No.", qQuoteLine."NS_Quote No.");
        qJobPlanLine.SETRANGE("Job Task No.", qQuoteLine."NS_Job Task No.");
        qJobPlanLine.SETRANGE("No.", qQuoteLine."NS_No.");
        //qJobPlanLine.SETRANGE("NS_Entry Type", qJobPlanLine."NS_Entry Type"::Both);  //PPAL-147.AS.2.0 05Oct2020 Comment
        //qJobPlanLine.SETRANGE("Line Type", qJobPlanLine."Line Type"::"Both Budget and Billable");	 //PPAL-147.AS.2.0 05Oct2020 Comment
        qJobPlanLine.SETRANGE(Type, qJobPlanLine.Type::Item);
        if qJobPlanLine.FINDFIRST then begin
            qJobPlanLine."No." := qQuoteLine."NS_No.";
            //qJobPlanLine.MODIFY;//PPAL-147.AS.2.0 05Oct2020 Commented
            qJobPlanLine.MODIFY(true);//PPAL-147.AS.2.0 05Oct2020 Added
            exit;
        end;

        qJob.GET(QuoteHeader."NS_Job No.");


        //PPAL-147.AS.2.0 05Oct2020 - Start Added condition in begin end
        JPLine.Reset;
        JPLine.SetRange("Job No.", qQuoteLine."NS_Quote No.");
        JPLine.SetRange("Job Task No.", qQuoteLine."NS_Job Task No.");
        JPLine.SetRange("Line No.", qQuoteLine."NS_Quote Line No.");
        if not JPLine.FindFirst then begin
            qJobPlanLine2.RESET;
            qJobPlanLine2.SETRANGE("Job No.", qQuoteLine."NS_Quote No.");
            if qJobPlanLine2.FINDLAST then
                LineNo := qJobPlanLine2."Line No." + 10000
            else
                LineNo := 10000;

            qJobPlanLine.INIT;
            qJobPlanLine."Job No." := qQuoteLine."NS_Quote No.";
            qJobPlanLine."Job Task No." := qQuoteLine."NS_Job Task No.";
            qJobPlanLine."Line No." := LineNo;
            qJobPlanLine."NS_Entry Type" := qJobPlanLine."NS_Entry Type"::Both;
            qJobPlanLine."Line Type" := qJobPlanLine."Line Type"::"Both Budget and Billable";
            qJobPlanLine."Document No." := qJobPlanLine2."Document No.";
            qJobPlanLine.Type := qJobPlanLine.Type::Item;
            qJobPlanLine."No." := qItem."No.";
            qJobPlanLine.Description := qItem.Description;
            qJobPlanLine."Gen. Prod. Posting Group" := qItem."Gen. Prod. Posting Group";
            qJobPlanLine."Unit of Measure Code" := qItem."Base Unit of Measure";
            //qJobPlanLine.VALIDATE("Unit Cost", qItem."Unit Cost");//PPAL-147.AS.2.0 05Oct2020 Comment
            //qJobPlanLine.VALIDATE("Unit Price", qItem."Unit List Price");//PPAL-147.AS.2.0 05Oct2020 Comment
            qJobPlanLine."Unit Cost" := qQuoteLine."NS_Unit Cost";//PPAL-147.AS.2.0 05Oct2020 Add
            qJobPlanLine."Unit Price" := qQuoteLine."NS_Unit Price";//PPAL-147.AS.2.0 05Oct2020 Add
            qJobPlanLine.Quantity := qQuoteLine.NS_Quantity;//PPAL-147.AS.2.0 06Oct2020 Add
            qJobPlanLine."Quantity (Base)" := qQuoteLine."NS_Quantity (Base)";//PPAL-147.AS.2.0 06Oct2020 Add
            qJobPlanLine."Line Amount" := qQuoteLine.NS_Amount;//PPAL-147.AS.2.0 06Oct2020 Add
            qJobPlanLine."Line Discount %" := qQuoteLine."NS_Line Discount %";//PPAL-147.AS.2.0 06Oct2020 Add
            qJobPlanLine."Total Cost" := qQuoteLine."NS_Total Cost";//PPAL-147.AS.2.0 06Oct2020 Add
            qJobPlanLine."Total Price" := qQuoteLine."NS_Total Price";//PPAL-147.AS.2.0 06Oct2020 Add
            qJobPlanLine."NS_Cost Category" := qItem."NS_Job Cost Category";
            qJobPlanLine."Planning Date" := QuoteHeader."NS_Proposal Date";
            qJobPlanLine."Planned Delivery Date" := QuoteHeader."NS_Proposal Date";
            //PRJCTPR-153.PS.1.0 11Jul2023 Start
            if NS_Jobsetup.Get() then;
            qJobPlanLine."Usage Link" := NS_Jobsetup."Apply Usage Link by Default";
            //PRJCTPR-153.PS.1.0 11Jul2023 End 
            qJobPlanLine.INSERT;

        end;//PPAL-147.AS.2.0 05Oct2020 End - Added condition

        if JPLine.FindFirst then begin
            qJobPlanLine."Job No." := qQuoteLine."NS_Quote No.";
            qJobPlanLine."Job Task No." := qQuoteLine."NS_Job Task No.";
            qJobPlanLine."Line No." := qQuoteLine."NS_Quote Line No.";
            qJobPlanLine."Document No." := qJobPlanLine2."Document No.";
            qJobPlanLine.Type := qJobPlanLine.Type::Item;
            qJobPlanLine."No." := qItem."No.";
            qJobPlanLine.Description := qItem.Description;
            qJobPlanLine."Gen. Prod. Posting Group" := qItem."Gen. Prod. Posting Group";
            qJobPlanLine."Unit of Measure Code" := qQuoteLine."NS_Unit of Measure Code";
            qJobPlanLine."Unit Cost" := qQuoteLine."NS_Unit Cost";
            qJobPlanLine."Unit Price" := qQuoteLine."NS_Unit Price";
            qJobPlanLine."Total Cost" := qQuoteLine."NS_Total Cost";//PPAL-147.AS.2.0 06Oct2020 Add
            qJobPlanLine."Total Price" := qQuoteLine."NS_Total Price";//PPAL-147.AS.2.0 06Oct2020 Add
            qJobPlanLine."Line Amount" := qQuoteLine.NS_Amount;
            qJobPlanLine."Line Discount %" := qQuoteLine."NS_Line Discount %";
            qJobPlanLine.Quantity := qQuoteLine.NS_Quantity;
            qJobPlanLine."Quantity (Base)" := qQuoteLine."NS_Quantity (Base)";
            qJobPlanLine."NS_Revenue Category" := qQuoteLine."NS_Revenue Category";
            qJobPlanLine.Modify;
        end;
        //PPAL-147.AS.2.0 02Oct2020 End - Added condition

        if ItemUoMTbl.GET(qItem."No.", qItem."Base Unit of Measure") then
            QtyUoM := ItemUoMTbl."Qty. per Unit of Measure"
        else
            QtyUoM := 1;

        qQuoteLine."NS_Manufacturer Code" := qItem."Manufacturer Code";
        qQuoteLine."NS_Unit of Measure Code" := qItem."Base Unit of Measure";
        qQuoteLine."NS_Qty. per Unit of Measure" := QtyUoM;
        qQuoteLine.VALIDATE("NS_Vendor No.", qItem."Vendor No.");
        //qQuoteLine.VALIDATE("NS_Unit Cost", qItem."Unit Cost");	//PPAL-147.AS.2.0 05Oct2020 Comment
        //qQuoteLine.VALIDATE("NS_Unit Price", qItem."Unit Price");	//PPAL-147.AS.2.0 05Oct2020 Comment
        qQuoteLine."NS_Category Code" := qItem."Item Category Code";
        qQuoteLine."NS_Cost Category" := qItem."NS_Job Cost Category";
        qQuoteLine."NS_Unit Cost" := qItem."Unit Cost";//PPAL-147.AS.2.0 05Oct2020 Add
        qQuoteLine."NS_Unit Price" := qItem."Unit Price";//PPAL-147.AS.2.0 05Oct2020 Add
        qQuoteLine."NS_Category Code" := qItem."Item Category Code";
        qQuoteLine."NS_Cost Category" := qItem."NS_Job Cost Category";
        qQuoteLine."NS_Total Cost" := 0;//PPAL-147.AS.2.0 06Oct2020
        qQuoteLine."NS_Total Price" := 0;//PPAL-147.AS.2.0 06Oct2020
        qQuoteLine.NS_Amount := 0;//PPAL-147.AS.2.0 06Oct2020
        qQuoteLine."NS_Line Discount %" := 0;//PPAL-147.AS.2.0 06Oct2020
        qQuoteLine.NS_Quantity := 0;//PPAL-147.AS.2.0 06Oct2020
        qQuoteLine.MODIFY;
    end;

    procedure NS_LoadFromJobTmpl(qJobNo: Code[20]; tJobNo: Code[20]);
    var
        QuoteJob: Record Job;
        QuotePlanLine: Record "Job Planning Line";
        TmplPlanLine: Record "Job Planning Line";
        QPL: Record "Job Planning Line";
        QuoteTaskLine: Record "Job Task";
        TmplTaskLine: Record "Job Task";
        QuoteSegment: Record "NS_Job Takeoff Segments";
        TmplSegment: Record "NS_Job Takeoff Segments";
        Segment: Record "NS_Job Takeoff Segments";
        PlanLineNo: Integer;
        SegmentDwgCode: Code[20];
        x: Integer;
    begin
        if QuoteJob.GET(qJobNo) then begin

            TmplTaskLine.RESET;
            TmplTaskLine.SETRANGE("Job No.", tJobNo);
            if TmplTaskLine.FINDSET(false, false) then
                repeat
                    QuoteTaskLine.SETRANGE("Job No.", qJobNo);
                    QuoteTaskLine.SETRANGE("Job Task No.", TmplTaskLine."Job Task No.");
                    if not QuoteTaskLine.FINDFIRST then begin
                        QuoteTaskLine := TmplTaskLine;
                        QuoteTaskLine."NS_Template No." := QuoteTaskLine."Job No.";
                        QuoteTaskLine."Job No." := qJobNo;
                        QuoteTaskLine."NS_Quote No." := qJobNo;
                        QuoteTaskLine.INSERT;
                    end;
                until TmplTaskLine.NEXT = 0;

            TmplPlanLine.RESET;
            TmplPlanLine.SETRANGE("Job No.", tJobNo);
            if TmplPlanLine.FINDSET(false, false) then
                repeat
                    QPL.RESET;
                    QPL.SETRANGE("Job No.", qJobNo);
                    QPL.SETRANGE("Job Task No.", TmplPlanLine."Job Task No.");
                    QPL.SETRANGE("Document No.", TmplPlanLine."Document No.");
                    if QPL.FINDLAST then
                        PlanLineNo := QPL."Line No." + 10000
                    else
                        PlanLineNo := 10000;

                    QuotePlanLine := TmplPlanLine;
                    QuotePlanLine."NS_Template No." := QuotePlanLine."Job No.";
                    QuotePlanLine."Job No." := qJobNo;
                    QuotePlanLine."NS_Quote No." := qJobNo;
                    QuotePlanLine."Line No." := PlanLineNo;
                    QuotePlanLine.VALIDATE(Quantity);
                    QuotePlanLine.NS_TempNo := QuotePlanLine."No.";
                    QuotePlanLine.NS_TempLocation := QuotePlanLine."Location Code";
                    QuotePlanLine.NS_TempVariant := QuotePlanLine."Variant Code";
                    QuotePlanLine.NS_TempUM := QuotePlanLine."Unit of Measure Code";
                    QuotePlanLine.NS_TempWorkType := QuotePlanLine."Work Type Code";
                    QuotePlanLine.NS_TempSkillClass := QuotePlanLine."NS_Skill Class";
                    QuotePlanLine.VALIDATE(Quantity, TmplPlanLine.Quantity);
                    QuotePlanLine.INSERT;
                until TmplPlanLine.NEXT = 0;

            TmplSegment.RESET;
            TmplSegment.SETRANGE("NS_Job No.", tJobNo);
            if TmplSegment.FINDSET(false, false) then
                repeat
                    x += 1;
                    Segment.RESET;
                    Segment.SETRANGE(NS_Type, Segment.NS_Type::Drawing);
                    Segment.SETRANGE("NS_Job No.", qJobNo);
                    Segment.SETRANGE("NS_Segment Code", TmplSegment."NS_Segment Code");
                    Segment.SETRANGE("NS_Size of Weld", TmplSegment."NS_Size of Weld");
                    if Segment.FINDLAST then
                        SegmentDwgCode := INCSTR(Segment."NS_Segment Code")
                    else
                        if x = 1 then
                            SegmentDwgCode := '1'
                        else
                            SegmentDwgCode := INCSTR(SegmentDwgCode);
                    QuoteSegment.SETRANGE(NS_Type, QuoteSegment.NS_Type::Drawing);
                    QuoteSegment.SETRANGE("NS_Job No.", qJobNo);
                    QuoteSegment.SETRANGE("NS_Segment Code", TmplSegment."NS_Segment Code");
                    QuoteSegment.SETRANGE("NS_Size of Weld", TmplSegment."NS_Size of Weld");
                    if not QuoteSegment.FINDFIRST then begin
                        QuoteSegment := TmplSegment;
                        QuoteSegment."NS_Template No." := QuoteSegment."NS_Job No.";
                        QuoteSegment."NS_Job No." := qJobNo;
                        QuoteSegment.NS_Type := QuoteSegment.NS_Type::Drawing;
                        QuoteSegment."NS_Segment Code" := SegmentDwgCode;
                        QuoteSegment.INSERT;
                    end else begin
                    end;
                until TmplSegment.NEXT = 0;

        end;
    end;
    //PPAL-172.MS.1.0 start
    procedure NS_LoadFromJobTmplPackage(qJobNo: Code[20]; tJobNo: Code[20]; SegCode: Code[20]);
    var
        QuoteJob: Record Job;
        QuotePlanLine: Record "Job Planning Line";
        TmplPlanLine: Record "Job Planning Line";
        QPL: Record "Job Planning Line";
        QuoteTaskLine: Record "Job Task";
        TmplTaskLine: Record "Job Task";
        QuoteSegment: Record "NS_Job Takeoff Segments";
        TmplSegment: Record "NS_Job Takeoff Segments";
        Segment: Record "NS_Job Takeoff Segments";
        PlanLineNo: Integer;
        SegmentDwgCode: Code[20];
        x: Integer;
    begin
        if QuoteJob.GET(qJobNo) then begin

            TmplTaskLine.RESET;
            TmplTaskLine.SETRANGE("Job No.", tJobNo);
            if TmplTaskLine.FINDSET(false, false) then
                repeat
                    QuoteTaskLine.SETRANGE("Job No.", qJobNo);
                    QuoteTaskLine.SETRANGE("Job Task No.", TmplTaskLine."Job Task No.");
                    if not QuoteTaskLine.FINDFIRST then begin
                        QuoteTaskLine := TmplTaskLine;
                        QuoteTaskLine."NS_Template No." := QuoteTaskLine."Job No.";
                        QuoteTaskLine."Job No." := qJobNo;
                        QuoteTaskLine."NS_Quote No." := qJobNo;
                        QuoteTaskLine.INSERT;
                    end;
                until TmplTaskLine.NEXT = 0;

            TmplPlanLine.RESET;
            TmplPlanLine.SETRANGE("Job No.", tJobNo);
            if TmplPlanLine.FINDSET(false, false) then
                repeat
                    QPL.RESET;
                    QPL.SETRANGE("Job No.", qJobNo);
                    QPL.SETRANGE("Job Task No.", TmplPlanLine."Job Task No.");
                    // QPL.SETRANGE("Document No.", TmplPlanLine."Document No."); //PRJCTPR-359.NC.1.0 21May2024 Block
                    if QPL.FINDLAST then
                        PlanLineNo := QPL."Line No." + 10000
                    else
                        PlanLineNo := 10000;

                    QuotePlanLine := TmplPlanLine;
                    QuotePlanLine."NS_Template No." := QuotePlanLine."Job No.";
                    QuotePlanLine."Job No." := qJobNo;
                    QuotePlanLine."NS_Quote No." := qJobNo;
                    QuotePlanLine."Line No." := PlanLineNo;
                    QuotePlanLine.VALIDATE(Quantity);
                    QuotePlanLine.NS_TempNo := QuotePlanLine."No.";
                    QuotePlanLine.NS_TempLocation := QuotePlanLine."Location Code";
                    QuotePlanLine.NS_TempVariant := QuotePlanLine."Variant Code";
                    QuotePlanLine.NS_TempUM := QuotePlanLine."Unit of Measure Code";
                    QuotePlanLine.NS_TempWorkType := QuotePlanLine."Work Type Code";
                    QuotePlanLine.NS_TempSkillClass := QuotePlanLine."NS_Skill Class";
                    QuotePlanLine.VALIDATE(Quantity, TmplPlanLine.Quantity);
                    //QuotePlanLine."NS_Segment Code" := SegCode; //PRJCTPR-359.NC.1.0 21May2024 Block
                    QuotePlanLine.Validate("NS_Segment Code", SegCode); //PRJCTPR-359.NC.1.0 21May2024
                    QuotePlanLine.INSERT;
                until TmplPlanLine.NEXT = 0;

            TmplSegment.RESET;
            TmplSegment.SETRANGE("NS_Job No.", tJobNo);
            if TmplSegment.FINDSET(false, false) then
                repeat
                    x += 1;
                    Segment.RESET;
                    Segment.SETRANGE(NS_Type, Segment.NS_Type::Drawing);
                    Segment.SETRANGE("NS_Job No.", qJobNo);
                    Segment.SETRANGE("NS_Segment Code", TmplSegment."NS_Segment Code");
                    Segment.SETRANGE("NS_Size of Weld", TmplSegment."NS_Size of Weld");
                    if Segment.FINDLAST then
                        SegmentDwgCode := INCSTR(Segment."NS_Segment Code")
                    else
                        if x = 1 then
                            SegmentDwgCode := '1'
                        else
                            SegmentDwgCode := INCSTR(SegmentDwgCode);
                    QuoteSegment.SETRANGE(NS_Type, QuoteSegment.NS_Type::Drawing);
                    QuoteSegment.SETRANGE("NS_Job No.", qJobNo);
                    QuoteSegment.SETRANGE("NS_Segment Code", TmplSegment."NS_Segment Code");
                    QuoteSegment.SETRANGE("NS_Size of Weld", TmplSegment."NS_Size of Weld");
                    if not QuoteSegment.FINDFIRST then begin
                        QuoteSegment := TmplSegment;
                        QuoteSegment."NS_Template No." := QuoteSegment."NS_Job No.";
                        QuoteSegment."NS_Job No." := qJobNo;
                        QuoteSegment.NS_Type := QuoteSegment.NS_Type::Drawing;
                        QuoteSegment."NS_Segment Code" := SegmentDwgCode;
                        QuoteSegment.INSERT;
                    end else begin
                    end;
                until TmplSegment.NEXT = 0;

        end;
    end;

    procedure NS_OnRenameQuoteLinePackage(NewQuoteLine: Record "NS_Job Quote Line"; PrevQuoteLine: Record "NS_Job Quote Line"; QSegCode: code[20]);
    var
        JobTask: Record "Job Task";
        Segment: Record "NS_Job Takeoff Segments";
        JobPlanLine: Record "Job Planning Line";
    begin
        NS_OnDeleteJobQuoteLine(PrevQuoteLine);
        NS_LoadFromJobTmplPackage(NewQuoteLine."NS_Quote No.", NewQuoteLine."NS_No.", QSegCode);
    end;

    //PPAL-172.MS.1.0 end

    procedure NS_LoadFromResource(var qQuoteLine: Record "NS_Job Quote Line"; qResource: Record Resource);
    var
        JobTask: Record "Job Task";
        JobTaskList: Page "Job Task Lines";
        qJobPlanLine: Record "Job Planning Line";
        qJobPlanLine2: Record "Job Planning Line";
        LineNo: Integer;
        JPLine: Record "Job Planning Line";//PPAL-147.AS.2.0 05Oct2020
        NS_Jobsetup: Record "Jobs Setup";//PRJCTPR-153.PS.1.0
    begin

        NS_GetQuoteHeaderC50000(qQuoteLine);

        qJobPlanLine.SETRANGE("Job No.", qQuoteLine."NS_Quote No.");
        qJobPlanLine.SETRANGE("Job Task No.", qQuoteLine."NS_Job Task No.");
        qJobPlanLine.SETRANGE("No.", qQuoteLine."NS_No.");
        //qJobPlanLine.SETRANGE("NS_Entry Type", qJobPlanLine."NS_Entry Type"::Both);//PPAL-147.AS.2.0 05Oct2020 Comment
        //qJobPlanLine.SETRANGE("Line Type", qJobPlanLine."Line Type"::"Both Budget and Billable");	//PPAL-147.AS.2.0 05Oct2020 Comment
        qJobPlanLine.SETRANGE(Type, qJobPlanLine.Type::Resource);
        if qJobPlanLine.FINDFIRST then begin
            qJobPlanLine."No." := qQuoteLine."NS_No.";
            qJobPlanLine.MODIFY;
            exit;
        end;

        //PPAL-147.AS.2.0 05Oct2020 - Start Added condition in begin end
        JPLine.Reset;
        JPLine.SetRange("Job No.", qQuoteLine."NS_Quote No.");
        JPLine.SetRange("Job Task No.", qQuoteLine."NS_Job Task No.");
        JPLine.SetRange("Line No.", qQuoteLine."NS_Quote Line No.");
        if not JPLine.FindFirst then begin

            qJobPlanLine2.RESET;
            qJobPlanLine2.SETRANGE("Job No.", qQuoteLine."NS_Quote No.");
            if qJobPlanLine2.FINDLAST then
                LineNo := qJobPlanLine2."Line No." + 10000
            else
                LineNo := 10000;


            qJobPlanLine.INIT;
            qJobPlanLine."Job No." := qQuoteLine."NS_Quote No.";
            qJobPlanLine."Job Task No." := qQuoteLine."NS_Job Task No.";
            qJobPlanLine."Line No." := LineNo;
            qJobPlanLine."Document No." := qJobPlanLine2."Document No.";
            qJobPlanLine.Type := qJobPlanLine.Type::Resource;
            qJobPlanLine."No." := qResource."No.";
            qJobPlanLine.Description := qResource.Name;
            qJobPlanLine."Gen. Prod. Posting Group" := qResource."Gen. Prod. Posting Group";
            qJobPlanLine."Unit of Measure Code" := qResource."Base Unit of Measure";
            //qJobPlanLine."Unit Cost" := qResource."Unit Cost";//PPAL-147.AS.2.0 06Oct2020 Commented
            //qJobPlanLine."Unit Price" := qResource."Unit Price";//PPAL-147.AS.2.0 06Oct2020 Commented
            qJobPlanLine."NS_Cost Category" := qResource."NS_Job Cost Category";
            qJobPlanLine."Unit Cost" := qQuoteLine."NS_Unit Cost";//PPAL-147.AS.2.0 06Oct2020 Add
            qJobPlanLine."Unit Price" := qQuoteLine."NS_Unit Price";//PPAL-147.AS.2.0 06Oct2020 Add
            qJobPlanLine.Quantity := qQuoteLine.NS_Quantity;
            qJobPlanLine."Quantity (Base)" := qQuoteLine."NS_Quantity (Base)";
            qJobPlanLine."Line Amount" := qQuoteLine.NS_Amount;//PPAL-147.AS.2.0 06Oct2020 Add
            qJobPlanLine."Line Discount %" := qQuoteLine."NS_Line Discount %";//PPAL-147.AS.2.0 06Oct2020 Add
            qJobPlanLine."Total Cost" := qQuoteLine."NS_Total Cost";//PPAL-147.AS.2.0 06Oct2020 Add
            qJobPlanLine."Total Price" := qQuoteLine."NS_Total Price";//PPAL-147.AS.2.0 06Oct2020 Add
            qJobPlanLine."NS_Revenue Category" := qQuoteLine."NS_Revenue Category";
            qJobPlanLine."Planning Date" := QuoteHeader."NS_Proposal Date";//PPAL-147.AS.2.0 06Oct2020 Add
            qJobPlanLine."Planned Delivery Date" := QuoteHeader."NS_Proposal Date";//PPAL-147.AS.2.0 06Oct2020 Add
                                                                                   //PRJCTPR-153.PS.1.0 11Jul2023 Start
            if NS_Jobsetup.Get() then;
            qJobPlanLine."Usage Link" := NS_Jobsetup."Apply Usage Link by Default";
            //PRJCTPR-153.PS.1.0 11Jul2023 End 
            qJobPlanLine.INSERT;
        end;//PPAL-147.AS.2.0 05Oct2020 End - Added condition
        qQuoteLine."NS_Qty. per Unit of Measure" := 1;
        qQuoteLine."NS_Unit of Measure Code" := qResource."Base Unit of Measure";
        qQuoteLine.VALIDATE("NS_Vendor No.", qResource."Vendor No.");
        qQuoteLine."NS_Unit Cost" := qResource."Unit Cost";
        qQuoteLine."NS_Unit Price" := qResource."Unit Price";
        qQuoteLine."NS_Cost Category" := qResource."NS_Job Cost Category";
        qJobPlanLine.Type := qJobPlanLine.Type::Resource;
        qJobPlanLine."No." := qResource."No.";
        qJobPlanLine.Description := qResource.Name;
        qJobPlanLine."Gen. Prod. Posting Group" := qResource."Gen. Prod. Posting Group";
        qJobPlanLine."Unit of Measure Code" := qQuoteLine."NS_Unit of Measure Code";
        qJobPlanLine."Unit Cost" := qQuoteLine."NS_Unit Cost";
        qJobPlanLine."Unit Price" := qQuoteLine."NS_Unit Price";
        qJobPlanLine."Total Cost" := qQuoteLine."NS_Total Cost";//PPAL-147.AS.2.0 05Oct2020 Add
        qJobPlanLine."Total Price" := qQuoteLine."NS_Total Price";//PPAL-147.AS.2.0 05Oct2020 Add
        qJobPlanLine."Line Amount" := qQuoteLine.NS_Amount;
        qJobPlanLine."Line Discount %" := qQuoteLine."NS_Line Discount %";
        qJobPlanLine.Quantity := qQuoteLine.NS_Quantity;
        qJobPlanLine."Quantity (Base)" := qQuoteLine."NS_Quantity (Base)";
        qJobPlanLine."NS_Revenue Category" := qQuoteLine."NS_Revenue Category";
        qJobPlanLine.Modify;
        //end;

        //PPAL-147.AS.2.0 02Oct2020 End - Added condition

        qQuoteLine."NS_Qty. per Unit of Measure" := 1;
        qQuoteLine."NS_Unit of Measure Code" := qResource."Base Unit of Measure";
        qQuoteLine.VALIDATE("NS_Vendor No.", qResource."Vendor No.");
        qQuoteLine."NS_Unit Cost" := qResource."Unit Cost";
        qQuoteLine."NS_Unit Price" := qResource."Unit Price";
        qQuoteLine."NS_Cost Category" := qResource."NS_Job Cost Category";
        qQuoteLine."NS_Total Cost" := 0;//PPAL-147.AS.2.0 06Oct2020
        qQuoteLine."NS_Total Price" := 0;//PPAL-147.AS.2.0 06Oct2020
        qQuoteLine.NS_Amount := 0;//PPAL-147.AS.2.0 06Oct2020
        qQuoteLine."NS_Line Discount %" := 0;//PPAL-147.AS.2.0 06Oct2020
        qQuoteLine.NS_Quantity := 0;//PPAL-147.AS.2.0 06Oct2020
    end;

    procedure NS_LoadFromTask(var qQuoteLine: Record "NS_Job Quote Line"; qTask: Record "NS_Job Operation");
    var
        JobTask: Record "Job Task";
        JobTaskList: Page "Job Task Lines";
        qJobPlanLine: Record "Job Planning Line";
        qJobPlanLine2: Record "Job Planning Line";
        LineNo: Integer;
    begin
        qJobPlanLine2.RESET;
        qJobPlanLine2.SETRANGE("Job No.", qQuoteLine."NS_Quote No.");
        if qJobPlanLine2.FINDLAST then
            LineNo := qJobPlanLine2."Line No." + 10000
        else
            LineNo := 10000;

        JobTask."Job No." := qQuoteLine."NS_Quote No.";
        JobTask."Job Task No." := qTask."NS_Activity Code" + '-' + qTask."NS_Process Code" + '-' + qTask.NS_Code;
        JobTask.Description := qTask.NS_Description;
        JobTask."Job Task Type" := qTask.NS_Type;
        JobTask."NS_Quote No." := qQuoteLine."NS_Quote No.";
        JobTask.INSERT;

        qQuoteLine."NS_Qty. per Unit of Measure" := 1;
        qQuoteLine."NS_Unit of Measure Code" := 'EA';
        ;
        qQuoteLine."NS_Job Task No." := qTask."NS_Activity Code" + '-' + qTask."NS_Process Code" + '-' + qTask.NS_Code;
        ;
    end;

    procedure NS_MakeOrder(_QuoteNo: Code[20]) _OrderExists: Boolean;
    var
        _DocApprovalEntry: Record "Approval Entry";
        _Location: Record Location;
        _QuoteComment: Record "Comment Line";
        _QuoteHeader: Record "NS_Job Quote Header";
        _QuoteLine: Record "NS_Job Quote Line";
        _SalesCommentLine: Record "Sales Comment Line";
        _SalesHeader: Record "Sales Header";
        _SalesLine: Record "Sales Line";
        _DocApprovalMgt: Codeunit "Approvals Mgmt.";
        _PurchasingCode: Code[10];
        _LineNo: Integer;
    begin
        _QuoteHeader.GET(_QuoteNo);
        _QuoteHeader.TESTFIELD("NS_Sell-to Customer No.");
        _QuoteHeader.TESTFIELD("NS_Equipment Only");
        NS_TestFieldsRequiredForConversion(_QuoteHeader);
        NS_QuotingCheck(_QuoteHeader);
        NS_AmountCheck(_QuoteHeader);
        //PE-300-DK.1.0 29May2024 Start
        // if _QuoteHeader.NS_Status = _QuoteHeader.NS_Status::Open then begin
        if _QuoteHeader."NS_Quote Status" = _QuoteHeader."NS_Quote Status"::Open then begin
            //PE-300-DK.1.0 29May2024 End
            NS_SetStatusReleased(_QuoteHeader);
        end;
        _SalesHeader.GET(_SalesHeader."Document Type"::Quote, _QuoteHeader."NS_Sales Quote No.");
        COMMIT;
        CODEUNIT.RUN(CODEUNIT::"Sales-Quote to Order (Yes/No)", _SalesHeader);

        // test for existence of order

        _SalesHeader.SETRANGE("Document Type", _SalesHeader."Document Type"::Order);
        _SalesHeader.SETRANGE("Quote No.", _QuoteHeader."NS_Sales Quote No.");
        _OrderExists := _SalesHeader.FINDFIRST;
        if not _OrderExists then
            exit;

        // close the quote and stamp it with order no.
        //PE-300-DK.1.0 29May2024 Start
        // _QuoteHeader.NS_Status := _QuoteHeader.NS_Status::Closed;
        _QuoteHeader."NS_Quote Status" := _QuoteHeader."NS_Quote Status"::Closed;
        //PE-300-DK.1.0 29May2024 End
        _QuoteHeader."NS_Sales Order No." := _SalesHeader."No.";
        _QuoteHeader."NS_Date Converted to Order" := TODAY;
        _QuoteHeader.MODIFY;

        // update order date and document date

        _SalesHeader.SetHideValidationDialog(true);
        _SalesHeader.VALIDATE("Order Date", WORKDATE);
        _SalesHeader.VALIDATE("Document Date", WORKDATE);
        _SalesHeader.MODIFY;

        // copy comments

        _QuoteComment.SETRANGE("No.", _QuoteHeader."NS_Quote No.");
        if _QuoteComment.FINDSET(false) then begin
            _SalesCommentLine.SETRANGE("Document Type", _SalesCommentLine."Document Type"::Order);
            _SalesCommentLine.SETRANGE("No.", _SalesHeader."No.");
            if _SalesCommentLine.FINDSET(false) then
                repeat
                    if _SalesCommentLine."Line No." > _LineNo then
                        _LineNo := _SalesCommentLine."Line No.";
                until _SalesCommentLine.NEXT = 0;
            // copy
            repeat
                _LineNo += 10000;
                _SalesCommentLine.INIT;
                _SalesCommentLine."Document Type" := _SalesCommentLine."Document Type"::Order;
                _SalesCommentLine."No." := _SalesHeader."No.";
                _SalesCommentLine."Document Line No." := _QuoteComment."Line No.";
                _SalesCommentLine."Line No." := _LineNo;
                _SalesCommentLine.Date := _QuoteComment.Date;
                _SalesCommentLine.Comment := COPYSTR(_QuoteComment.Comment, 1, MAXSTRLEN(_SalesCommentLine.Comment));
                //_SalesCommentLine."Print On Order Confirmation" := true;//_QuoteComment."Print On Quote"; //PPDA.1.0 Commented
                _SalesCommentLine.INSERT;
            until _QuoteComment.NEXT = 0;
        end;
        // ensure the drop shipment and purchasing code are set per location
        _SalesLine.SETRANGE("Document Type", _SalesLine."Document Type"::Order);
        _SalesLine.SETRANGE("Document No.", _SalesHeader."No.");
        _SalesLine.SETRANGE(Type, _SalesLine.Type::Item);
        _SalesLine.SETFILTER(Quantity, '<>0');
        if _SalesLine.FINDSET(false) then
            repeat
                if _Location.Code <> _SalesLine."Location Code" then
                    if not _Location.GET(_SalesLine."Location Code") then
                        _Location.INIT;
                if _Location."NS_Drop Ship Location" then begin
                    _SalesLine.GetPurchCode(true, false, _PurchasingCode);
                    _SalesLine.VALIDATE("Purchasing Code", _PurchasingCode);
                    _SalesLine.MODIFY;
                end;
            until _SalesLine.NEXT = 0;

        // open NAV order

        PAGE.RUN(PAGE::"Sales Order", _SalesHeader);
    end;

    procedure NS_OnDeleteQuote(_QuoteHeader: Record "NS_Job Quote Header");
    var
        _Address: Record "Ship-to Address";
        _QuoteLine: Record "NS_Job Quote Line";
        _FeatureText: Record "NS_Job Quote Feature Text";
        _SalesHeader: Record "Sales Header";
        _ScopeOfWork: Record "NS_Job Quote Scope of Work";
        lJob: Record Job;
        lTask: Record "Job Task";
        lPlan: Record "Job Planning Line";
    begin
        _QuoteHeader.TESTFIELD(NS_Template, false);

        _QuoteLine.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        _QuoteLine.DELETEALL(true);

        _FeatureText.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        _FeatureText.DELETEALL;

        _ScopeOfWork.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        _ScopeOfWork.DELETEALL;

        _Address.SETRANGE("NS_Table ID", DATABASE::"NS_Job Quote Header");
        _Address.SETRANGE("NS_No.", _QuoteHeader."NS_Quote No.");
        _Address.DELETEALL;

        if _QuoteHeader."NS_Sales Quote No." <> '' then
            if _SalesHeader.GET(_SalesHeader."Document Type"::Quote, _QuoteHeader."NS_Sales Quote No.") then begin
                _SalesHeader.SetHideValidationDialog(true);
                _SalesHeader.DELETE(true);
            end;

        if lJob.GET(_QuoteHeader."NS_Job No.") then
            lJob.DELETE(true);
    end;

    procedure NS_OnDeleteQuoteLine(_QuoteLine: Record "NS_Job Quote Line");
    var
        _AttributeSetEntry: Record "NS_Job Quote Attribute Set Ent";
        _QuoteComment: Record "Comment Line";
        _FeatureText: Record "NS_Job Quote Feature Text";
        _SalesLine: Record "Sales Line";
        _ScopeOfWork: Record "NS_Job Quote Scope of Work";
        qJobTask: Record "Job Task";
        qJobPlan: Record "Job Planning Line";
    begin
        NS_GetQuoteHeaderC50000(_QuoteLine);
        //PE-300-DK.1.0 29May2024 Start
        //QuoteHeader.TESTFIELD(NS_Status, QuoteHeader.NS_Status::Open);
        QuoteHeader.TESTFIELD("NS_Quote Status", QuoteHeader."NS_Quote Status"::Open);
        //PE-300-DK.1.0 29May2024 End
        if _QuoteLine."NS_Attribute Set Entry No." <> 0 then begin
            _AttributeSetEntry.SETRANGE("NS_Attribute Set ID", _QuoteLine."NS_Attribute Set Entry No.");
            _AttributeSetEntry.DELETEALL;
        end;

        _FeatureText.SETRANGE("NS_Quote No.", _QuoteLine."NS_Quote No.");
        _FeatureText.SETRANGE("NS_Quote Line No.", _QuoteLine."NS_Quote Line No.");
        _FeatureText.DELETEALL;

        _ScopeOfWork.SETRANGE("NS_Quote No.", _QuoteLine."NS_Quote No.");
        _ScopeOfWork.SETRANGE("NS_Quote Line No.", _QuoteLine."NS_Quote Line No.");
        _ScopeOfWork.DELETEALL;

        _QuoteComment.SETRANGE("Table Name", _QuoteComment."Table Name"::NS_Quote);
        _QuoteComment.SETRANGE("No.", _QuoteLine."NS_Quote No.");
        _QuoteComment.SETRANGE("Line No.", _QuoteLine."NS_Quote Line No.");
        _QuoteComment.DELETEALL;

        if (_QuoteLine."NS_Sales Quote No." <> '') and (_QuoteLine."NS_Sales Quote Line No." <> 0) then
            if _SalesLine.GET(_SalesLine."Document Type"::Quote, _QuoteLine."NS_Sales Quote No.", _QuoteLine."NS_Sales Quote Line No.") then
                _SalesLine.DELETE(true);

        with _QuoteLine do begin
            qJobPlan.RESET;
            qJobPlan.SETRANGE("Job No.", QuoteHeader."NS_Job No.");
            qJobPlan.SETRANGE("Job Task No.", "NS_Job Task No.");

            if NS_Type = NS_Type::Item then
                qJobPlan.SETRANGE(Type, NS_Type - 1);

            if NS_Type = NS_Type::Resource then
                qJobPlan.SETRANGE(Type, NS_Type - 3);

            if NS_Type = NS_Type::"G/L Account" then
                qJobPlan.SETRANGE(Type, NS_Type + 1);

            if NS_Type = NS_Type::Task then
                qJobPlan.SETRANGE(Type, NS_Type - 1);

            if NS_Type = NS_Type::Template then
                qJobPlan.SETRANGE(Type, NS_Type);

            qJobPlan.SETRANGE("No.", "NS_No.");
            if qJobPlan.FINDFIRST then
                qJobPlan.DELETE;
        end;
    end;

    procedure NS_OnDeleteSalesQuote(_SalesHeader: Record "Sales Header");
    var
        _Text000: Label 'Sales Quote %1 is associated with %2 %3 and may not be deleted.';
    begin
        if _SalesHeader."Document Type" <> _SalesHeader."Document Type"::Quote then
            exit;
        CLEAR(QuoteHeader);
        QuoteHeader.RESET;
        QuoteHeader.SETRANGE("NS_Sales Quote No.", _SalesHeader."No.");
        if QuoteHeader.FINDFIRST then
            ERROR(_Text000, _SalesHeader."No.", QuoteHeader.TABLECAPTION, QuoteHeader."NS_Quote No.");
    end;

    procedure NS_OnInsertQuote(var _QuoteHeader: Record "NS_Job Quote Header"; TrueFalse: Boolean);
    var
        _NoSeries: Record "No. Series";
        _UserSetup: Record "User Setup";
        QuoteSetup: Record "Jobs Setup";
    begin
        if not _UserSetup.GET(USERID) then
            _UserSetup.INIT;

        with _QuoteHeader do begin
            if _QuoteHeader.NS_Revision < 0 then begin
                _QuoteHeader."NS_Quote No." := COPYSTR(_QuoteHeader."NS_Link-to Quote No." + '.' + FORMAT(ABS(_QuoteHeader.NS_Revision))
                                                   , 1, MAXSTRLEN("NS_Quote No."));
                _QuoteHeader.NS_Revision := ABS(_QuoteHeader.NS_Revision);
            end else
                if "NS_Quote No." = '' then
                    "NS_Quote No." := NS_GetNextNo
                else begin
                    QuoteSetup.GET;
                    QuoteSetup.TESTFIELD("Job Nos.");
                    _NoSeries.GET(QuoteSetup."NS_Job Quote No. Series");
                    // >> Upgrade
                    NS_OnInsertQuote1(_QuoteHeader, IsHandled);
                    if IsHandled then
                        _NoSeries.TESTFIELD("Manual Nos.");

                    // << Upgrade
                end;

            "NS_Job Class" := "NS_Job Class"::"Master Job";
            "NS_Created by" := USERID;
            "NS_Created at Date" := TODAY;
            "NS_Created at Time" := TIME;
            "NS_Modified by" := '';
            "NS_Modified at Date" := 0D;
            "NS_Modified at Time" := 000000T;
            "NS_Accepted by" := '';
            "NS_Accepted at Date" := 0D;
            "NS_Accepted at Time" := 000000T;

            "NS_Salesperson/User ID" := USERID;

            "NS_Proposal Date" := WORKDATE;
            "NS_Job No." := "NS_Quote No.";

            if _QuoteHeader."NS_Duplicated-from Quote No." = '' then begin
                //"Equipment Only" := _UserSetup."Quote Default Equip. Only";
                "NS_Use Tax Liable" := "NS_Use Tax Liable"::No;
            end;

            NS_Status := NS_Status::Open;
            NS_Template := false;
            "NS_Link-to Quote No." := '';
            "NS_Sales Quote No." := '';
            "NS_Sales Order No." := '';
            "NS_Date Submitted to Estimator" := 0D;
            "NS_Preserve Pricing Flag" := false;
        end;
        //PE-300-DK.1.0 29May2024 Start
        //_QuoteHeader.NS_Status := _QuoteHeader.NS_Status::Open;
        _QuoteHeader."NS_Quote Status" := _QuoteHeader."NS_Quote Status"::Open;
        //PE-300-DK.1.0 29May2024 End

        if _QuoteHeader."NS_Duplicated-from Quote No." = '' then
            NS_CopyScopeOfWorkFromSetup(_QuoteHeader);
        NS_CreateQuoteJob(_QuoteHeader, TrueFalse);
        Commit();    //PRJCTPR-164.JS.1.0
    end;

    local procedure NS_OnInsertQuoteCopy(var _QuoteHeader: Record "NS_Job Quote Header");
    var
        _NoSeries: Record "No. Series";
        _UserSetup: Record "User Setup";
        QuoteSetup: Record "Jobs Setup";
    begin
        if not _UserSetup.GET(USERID) then
            _UserSetup.INIT;

        with _QuoteHeader do begin
            if _QuoteHeader.NS_Revision < 0 then begin
                _QuoteHeader."NS_Quote No." := COPYSTR(_QuoteHeader."NS_Link-to Quote No." + '.' + FORMAT(ABS(_QuoteHeader.NS_Revision))
                                                   , 1, MAXSTRLEN("NS_Quote No."));
                _QuoteHeader.NS_Revision := ABS(_QuoteHeader.NS_Revision);
            end else
                if "NS_Quote No." = '' then
                    "NS_Quote No." := NS_GetNextNo
                else begin
                    QuoteSetup.GET;
                    QuoteSetup.TESTFIELD("Job Nos.");
                    _NoSeries.GET(QuoteSetup."NS_Job Quote No. Series");
                    _NoSeries.TESTFIELD("Manual Nos.");
                end;

            "NS_Created by" := USERID;
            "NS_Created at Date" := TODAY;
            "NS_Created at Time" := TIME;
            "NS_Modified by" := '';
            "NS_Modified at Date" := 0D;
            "NS_Modified at Time" := 000000T;
            "NS_Accepted by" := '';
            "NS_Accepted at Date" := 0D;
            "NS_Accepted at Time" := 000000T;

            "NS_Salesperson/User ID" := USERID;

            "NS_Proposal Date" := WORKDATE;
            "NS_Job No." := "NS_Quote No.";

            if _QuoteHeader."NS_Duplicated-from Quote No." = '' then begin
                //"Equipment Only" := _UserSetup."Quote Default Equip. Only";
                "NS_Use Tax Liable" := "NS_Use Tax Liable"::No;
            end;

            NS_Status := NS_Status::Open;
            NS_Template := false;
            //IF Revision = 0 THEN
            //Revision := 1;
            "NS_Link-to Quote No." := '';
            "NS_Sales Quote No." := '';
            "NS_Sales Order No." := '';
            "NS_Date Submitted to Estimator" := 0D;
            "NS_Preserve Pricing Flag" := false;
        end;
        //PE-300-DK.1.0 29May2024 Start
        //_QuoteHeader.NS_Status := _QuoteHeader.NS_Status::Open;
        _QuoteHeader."NS_Quote Status" := _QuoteHeader."NS_Quote Status"::Open;
        //PE-300-DK.1.0 29May2024 End
        if _QuoteHeader."NS_Duplicated-from Quote No." = '' then
            NS_CopyScopeOfWorkFromSetup(_QuoteHeader);
        _QuoteHeader.INSERT(false);
    end;

    procedure NS_OnInsertQuoteLine(var _QuoteLine: Record "NS_Job Quote Line");
    begin
        NS_GetQuoteHeaderC50000(_QuoteLine);
        with _QuoteLine do begin
            "NS_Created by" := USERID;
            "NS_Created at Date" := TODAY;
            "NS_Created at Time" := TIME;
            "NS_Modified by" := '';
            "NS_Modified at Date" := 0D;
            "NS_Modified at Time" := 000000T;
            "NS_Sales Quote No." := QuoteHeader."NS_Sales Quote No.";
            "NS_Sales Quote Line No." := 0;
            NS_Quantity := 0;
            "NS_Quantity (Base)" := 0;
            "NS_Unit Cost" := 0;
            "NS_Use Tax SKU" := '';
            "NS_Use Tax Amount" := 0;
            "NS_Sales Tax Amount" := 0;
            "NS_Unit Price" := 0;
            "NS_Total Price" := 0;
            NS_Amount := 0;
            "NS_Amount Including VAT" := 0;
            NS_Markup := 0;
            "NS_Line Discount Amount" := 0;
            "NS_Line Discount %" := 0;
            "NS_Gross Margin %" := 0;
        end;
    end;

    procedure NS_OnLookupSubLevelFromJob(var _Job: Record Job);
    var
        _Job2: Record Job;
    begin
        // if same no. selected, crashes service tier with recursive loop
        _Job2.FILTERGROUP := 255;
        _Job2.SETFILTER("No.", '<>%1', _Job."No.");
        _Job2.FILTERGROUP := 0;
        if _Job."NS_Sub-Level to Job No." <> '' then begin
            _Job2.SETRANGE("No.", _Job."NS_Sub-Level to Job No.");
            if _Job2.FINDFIRST then;
            _Job2.SETRANGE("No.");
        end;
        if PAGE.RUNMODAL(PAGE::"Job List", _Job2) = ACTION::LookupOK then
            _Job.VALIDATE("NS_Sub-Level to Job No.", _Job2."No.");
    end;

    procedure NS_OnModifyQuote(var _QuoteHeader: Record "NS_Job Quote Header");
    var
        _DocumentApprovalEntry: Record "Approval Entry";
        _DocumentApprovalMgt: Codeunit "Approvals Mgmt.";
    begin
        _QuoteHeader.TESTFIELD(NS_Template, false);

        with _QuoteHeader do begin
            "NS_Modified by" := USERID;
            "NS_Modified at Date" := TODAY;
            "NS_Modified at Time" := TIME;
        end;
        NS_ModifyQuoteJob(_QuoteHeader);
        commit();     //PRJCTPR-164.JS.1.0
    end;

    procedure NS_OnModifyQuoteLine(var _QuoteLine: Record "NS_Job Quote Line");
    var
        _DocumentApprovalEntry: Record "Approval Entry";
        _DocumentApprovalMgt: Codeunit "Approvals Mgmt.";
    begin
        NS_GetQuoteHeaderC50000(_QuoteLine);
        QuoteHeader.TESTFIELD(NS_Template, false);

        if not HideValidationDialog then
            with _QuoteLine do begin
                "NS_Modified by" := USERID;
                "NS_Modified at Date" := TODAY;
                "NS_Modified at Time" := TIME;
            end;
    end;

    procedure NS_OnValidateAddressNo(var _QuoteLine: Record "NS_Job Quote Line");
    var
        _Address: Record "Ship-to Address";
    begin
        with _QuoteLine do
            if "NS_Address No." <> '' then
                if _Address.GET(DATABASE::"NS_Job Quote Header", "NS_Quote No.", "NS_Address No.") then begin
                    "NS_Location Code" := _Address."Location Code";
                    "NS_Tax Area Code" := _Address."Tax Area Code";
                    "NS_Tax Liable" := _Address."Tax Liable";
                end;
    end;

    procedure NS_OnValidateAttachedToLineNo(var _QuoteLine: Record "NS_Job Quote Line");
    var
        _QuoteLine2: Record "NS_Job Quote Line";
        _Text000: Label 'If you continue, the price for this line will be reduced to zero.  Continue?';
        _confirmed: Boolean;
    begin
        if _QuoteLine."NS_Attached to Line No." = 0 then
            exit;

        _QuoteLine2.GET(_QuoteLine."NS_Quote No.", _QuoteLine."NS_Attached to Line No.");
        if (_QuoteLine."NS_Unit Price" <> 0) or (_QuoteLine.NS_Amount <> 0) then begin
            if not HideValidationDialog then
                if not CONFIRM(_Text000, false) then begin
                    _QuoteLine."NS_Attached to Line No." := 0;
                    exit;
                end;
            NS_ZeroUnitPrice(_QuoteLine);
        end;
    end;

    procedure NS_OnValidateBillToCustomer(var _QuoteHeader: Record "NS_Job Quote Header");
    var
        _Address: Record "Ship-to Address";
        _Customer: Record Customer;
    begin
        if _QuoteHeader."NS_Bill-to Customer No." = '' then
            _QuoteHeader."NS_Bill-to Customer No." := _QuoteHeader."NS_Sell-to Customer No.";

        with _QuoteHeader do
            NS_CreateDim(_QuoteHeader,
              DATABASE::Customer, "NS_Bill-to Customer No.",
              DATABASE::"Salesperson/Purchaser", "NS_Salesperson Code New",//PRJ-867.AS.1.0 23SEPT2021 Changed field Sales Person code to Sales person code New
              0, '',   // Campaign
              0, '',   // Responsibility Center
              0, '');  // Customer Template

        if _Customer.GET(_QuoteHeader."NS_Bill-to Customer No.") then begin
            _QuoteHeader."NS_Bill-to Customer Name" := _Customer.Name;
            _QuoteHeader."NS_Payment Terms Code" := _Customer."Payment Terms Code";
        end;

        _Address.SETRANGE("NS_Table ID", DATABASE::"NS_Job Quote Header");
        _Address.SETRANGE("NS_No.", _QuoteHeader."NS_Quote No.");
        _Address.DELETEALL;

        // copy addresses

        NS_CopyCustomerAddress(_QuoteHeader, _QuoteHeader."NS_Bill-to Customer No.");

        if _QuoteHeader."NS_Sales Quote No." <> '' then
            NS_SyncSalesQuoteHeader(_QuoteHeader);
    end;

    procedure NS_OnValidateContactNo(var _QuoteHeader: Record "NS_Job Quote Header");
    var
        _Contact: Record Contact;
        _ContBusRel: Record "Contact Business Relation";
        _Customer: Record Customer;
    begin
        with _QuoteHeader do
            if "NS_Contact No." = '' then
                "NS_Contact Name" := ''
            else
                if _Contact.GET("NS_Contact No.") then
                    "NS_Contact Name" := _Contact.Name
                else
                    "NS_Contact Name" := '';

        // contact business relation

        //PRJ-1170.NK.1.0 Start
        //with _QuoteHeader do
        //PRJ-1215.JS.1.0 06MAR2022 - Start
        // if _QuoteHeader."NS_Contact No." <> '' then begin
        //     _ContBusRel.SETRANGE("Contact No.", _QuoteHeader."NS_Contact No.");
        //     _ContBusRel.SETRANGE("Link to Table", _ContBusRel."Link to Table"::Customer);
        //     _ContBusRel.SETFILTER("No.", '<>%1', '');
        //     if _ContBusRel.FINDFIRST() then
        //         if _Customer.GET(_ContBusRel."No.") then
        //             _QuoteHeader.VALIDATE("NS_Sell-to Customer No.", _Customer."No.");
        // end;
        //PRJ-1215.JS.1.0 06MAR2022 - end
        //PRJ-1170.NK.1.0 End
        // copy addresses
        if _Customer."No." <> '' then
            NS_CopyContactAddress(_QuoteHeader);
    end;

    procedure NS_OnValidateDescription(var _QuoteLine: Record "NS_Job Quote Line");
    begin
        NS_SyncSalesQuoteLine(_QuoteLine, false);
    end;

    procedure NS_OnValidateEquipmentOnly(var _QuoteHeader: Record "NS_Job Quote Header");
    var
        _QuoteLine: Record "NS_Job Quote Line";
    begin
        //PE-300-DK.1.0 29May2024 Start
        // _QuoteHeader.TESTFIELD(NS_Status, _QuoteHeader.NS_Status::Open);
        _QuoteHeader.TESTFIELD("NS_Quote Status", _QuoteHeader."NS_Quote Status"::Open);
        //PE-300-DK.1.0 29May2024 End
        if not _QuoteHeader."NS_Equipment Only" then
            exit;

        _QuoteHeader."NS_Use Tax Liable" := _QuoteHeader."NS_Use Tax Liable"::No;

        _QuoteLine.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        if _QuoteLine.FINDSET(true) then
            repeat
                _QuoteLine."NS_Use Tax SKU" := '';
                _QuoteLine."NS_Use Tax Amount" := 0;
                _QuoteLine."NS_Sales Tax Amount" := 0;
                NS_OnValidateUnitPrice(_QuoteLine, _QuoteLine.FIELDNO("NS_Unit Price"));
                _QuoteLine.MODIFY;
            until _QuoteLine.NEXT = 0;
    end;

    procedure NS_OnValidateEstimatorNo(var _QuoteHeader: Record "NS_Job Quote Header");
    var
        // >> Upgrade
        // _Resource: Record Resource;
        Salesperson: Record "Salesperson/Purchaser";
    // << Upgrade
    begin
        CLEAR(_QuoteHeader."NS_Estimator Name");
        with _QuoteHeader do
            if "NS_Estimator No." <> '' then
                if _Resource.GET("NS_Estimator No.") then
                    "NS_Estimator Name" := _Resource.Name;
    end;

    procedure NS_OnValidateJobNo(var _QuoteHeader: Record "NS_Job Quote Header");
    begin
        with _QuoteHeader do
            CALCFIELDS("NS_Job Description");
    end;

    procedure NS_OnValidateLocationCode(var _QuoteHeader: Record "NS_Job Quote Header");
    var
        _Text000: Label 'Update %1 on lines?';
        _QuoteLine: Record "NS_Job Quote Line";
    begin
        _QuoteHeader.TESTFIELD("NS_Location Code");

        if not HideValidationDialog then
            if not CONFIRM(_Text000, false, _QuoteHeader.FIELDCAPTION("NS_Location Code")) then
                exit;

        _QuoteLine.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        _QuoteLine.SETRANGE(NS_Type, _QuoteLine.NS_Type::Item, _QuoteLine.NS_Type::Resource);
        _QuoteLine.MODIFYALL("NS_Location Code", _QuoteHeader."NS_Location Code");
        _QuoteHeader.MODIFY;

        if _QuoteHeader."NS_Sales Quote No." <> '' then begin
            NS_SyncSalesQuoteHeader(_QuoteHeader);
            NS_SyncSalesQuoteLines(_QuoteHeader);
        end;
    end;

    procedure NS_OnValidateNoQuoteLine(var _QuoteLine: Record "NS_Job Quote Line");
    var
        _AttachedItem: Record Item;
        _GLAcc: Record "G/L Account";
        _Item: Record Item;
        _ItemUom: Record "Item Unit of Measure";
        _QuoteLine2: Record "NS_Job Quote Line";
        _Res: Record Resource;
        _DimMgt: Codeunit DimensionManagement;
        _LineNo: Integer;
        JobPlanningLine: Record "Job Planning Line";
    begin
        NS_GetQuoteHeaderC50000(_QuoteLine);

        QuoteHeader.TESTFIELD(NS_Template, false);
        //PE-300-DK.1.0 29May2024 Start
        // QuoteHeader.TESTFIELD(NS_Status, QuoteHeader.NS_Status::Open);
        QuoteHeader.TESTFIELD("NS_Quote Status", QuoteHeader."NS_Quote Status"::Open);
        //PE-300-DK.1.0 29May2024 End
        if _QuoteLine."NS_No." = '' then begin
            NS_SyncSalesQuoteLine(_QuoteLine, false);
            _QuoteLine.INIT;
            exit;
        end;

        CLEAR(_QuoteLine."NS_Manufacturer Code");

        with _QuoteLine do begin
            "NS_Line Discount Amount" := 0;
            "NS_Line Discount %" := 0;
            case NS_Type of
                NS_Type::"G/L Account":
                    begin
                        _GLAcc.GET("NS_No.");
                        NS_Description := _GLAcc.Name;
                        "NS_Unit of Measure Code" := '';
                        "NS_Qty. per Unit of Measure" := 1;
                        "NS_No. 2" := "NS_No.";
                    end;
                NS_Type::Item:
                    begin
                        _Item.GET("NS_No.");
                        NS_Description := _Item.Description;
                        "NS_No. 2" := _Item."No. 2";
                        "NS_Category Code" := _Item."Item Category Code";
                        if _Item."Sales Unit of Measure" <> '' then
                            VALIDATE("NS_Unit of Measure Code", _Item."Sales Unit of Measure")
                        else
                            if _Item."Base Unit of Measure" <> '' then
                                VALIDATE("NS_Unit of Measure Code", _Item."Base Unit of Measure")
                            else
                                "NS_Unit of Measure Code" := '';
                        "NS_Unit Cost" := _Item."Unit Cost";
                        "NS_Unit Price" := _Item."Unit Price";
                        "NS_Manufacturer Code" := _Item."Manufacturer Code";
                        if QuoteHeader."NS_Duplicated-from Quote No." = '' then
                            NS_CopyLinksFromItemToQuote("NS_Quote No.", _Item);
                        "NS_Location Code" := QuoteHeader."NS_Location Code";
                        "NS_Qty. per Unit of Measure" := 1;
                    end;
                NS_Type::Resource:
                    begin
                        _Res.GET("NS_No.");
                        NS_Description := _Res.Name;
                        "NS_Unit of Measure Code" := _Res."Base Unit of Measure";
                        "NS_Qty. per Unit of Measure" := 1;
                        "NS_No. 2" := "NS_No.";
                    end;

                NS_Type::Task:
                    begin
                        "NS_Unit of Measure Code" := 'EA';
                        "NS_Qty. per Unit of Measure" := 1;
                    end;
                else begin
                    "NS_Unit of Measure Code" := '';
                    "NS_Qty. per Unit of Measure" := 1;
                end;
            end;
            "NS_Quantity (Base)" := NS_CalcBaseQty(_QuoteLine, NS_Quantity);
            NS_SyncSalesQuoteLine(_QuoteLine, false);
            NS_GetQuoteLine(_QuoteLine);
            if SalesLine."Unit Cost" <> 0 then
                "NS_Unit Cost" := SalesLine."Unit Cost";
            if SalesLine."Unit Price" <> 0 then
                "NS_Unit Price" := SalesLine."Unit Price";
            if "NS_Unit Price" <> 0 then
                NS_Markup := "NS_Unit Cost" / "NS_Unit Price";
            //PRJCTPR-155.JS.1.0 11Sep2023 - Start
            // NS_CreateDimForLine(_QuoteLine,
            //   _DimMgt.TypeToTableID3(_QuoteLine.NS_Type), _QuoteLine."NS_No.",
            //   DATABASE::Job, '',
            //   DATABASE::"Responsibility Center", '');
            NS_CreateDimForLine(_QuoteLine,
              _DimMgt.SalesLineTypeToTableID(_QuoteLine.NS_Type), _QuoteLine."NS_No.",
              DATABASE::Job, '',
              DATABASE::"Responsibility Center", '');
            //PRJCTPR-155.JS.1.0 11Sep2023 - end
        end;

        case _QuoteLine.NS_Type of
            _QuoteLine.NS_Type::Item:
                begin
                    _Item.GET(_QuoteLine."NS_No.");
                    NS_LoadFromItem(_QuoteLine, _Item);
                end;

            _QuoteLine.NS_Type::"G/L Account":
                begin
                    _GLAcc.GET(_QuoteLine."NS_No.");
                    NS_LoadFromGLAct(_GLAcc, _QuoteLine);
                end;

            _QuoteLine.NS_Type::Resource:
                begin
                    _Res.GET(_QuoteLine."NS_No.");
                    NS_LoadFromResource(_QuoteLine, _Res);
                end;
        end;

        if not QuoteHeader."NS_Copy in Progress" then begin
            NS_CopyAttributesForQuoteLine(_QuoteLine);
            NS_CopyFeatureTextForQuoteLine(_QuoteLine);
            NS_CopyScopeOfWorkForQuoteLine(_QuoteLine);
        end;

        //attached items
        NS_SetHideValidationDialog(true);
        if _QuoteLine.NS_Type = _QuoteLine.NS_Type::Item then begin
            // get last line no. on quote
            _QuoteLine2.SETRANGE("NS_Quote No.", _QuoteLine."NS_Quote No.");
            if _QuoteLine2.FINDLAST then
                _LineNo := _QuoteLine2."NS_Quote Line No."
            else
                _LineNo := _QuoteLine."NS_Quote Line No.";
            // check for attached items
            _AttachedItem.SETRANGE("NS_Parent Item No.", _QuoteLine."NS_No.");
            _AttachedItem.SETFILTER("NS_Quantity Per Parent Item", '<>0');
            _AttachedItem.SETFILTER("NS_Parent Item UOM", '<>%1', '');
            // create new quote lines attached to current line
            if _AttachedItem.FINDSET(false, false) then
                repeat
                    if _Item.GET(_AttachedItem."No.") then
                        if _ItemUom.GET(_AttachedItem."No.", _AttachedItem."NS_Parent Item UOM") then begin
                            _LineNo += 10000;
                            _QuoteLine2.INIT;
                            _QuoteLine2."NS_Quote No." := _QuoteLine."NS_Quote No.";
                            _QuoteLine2."NS_Quote Line No." := _LineNo;
                            _QuoteLine2.INSERT(true);
                            _QuoteLine2.NS_Type := _QuoteLine2.NS_Type::Item;
                            _QuoteLine2."NS_No." := _Item."No.";
                            NS_OnValidateNoQuoteLine(_QuoteLine2);
                            _QuoteLine2.VALIDATE("NS_Unit of Measure Code", _AttachedItem."NS_Parent Item UOM");
                            _QuoteLine2.VALIDATE(NS_Quantity, _AttachedItem."NS_Quantity Per Parent Item");
                            _QuoteLine2."NS_Attached to Line No." := _QuoteLine."NS_Quote Line No.";
                            NS_ZeroUnitPrice(_QuoteLine2);
                            _QuoteLine2.MODIFY;
                        end;
                until _AttachedItem.NEXT = 0;
        end;
    end;

    procedure NS_OnValidateOwnerNo(var _QuoteHeader: Record "NS_Job Quote Header");
    var
        _Contact: Record Contact;
    begin
        CLEAR(_QuoteHeader."NS_Owner Name");
        if _QuoteHeader."NS_Owner No." = '' then
            exit;

        if _Contact.GET(_QuoteHeader."NS_Owner No.") then
            _QuoteHeader."NS_Owner Name" := _Contact.Name;
    end;

    procedure NS_OnValidateQuantity(var _QuoteLine: Record "NS_Job Quote Line");
    var
        qJobPlanLine: Record "Job Planning Line";
        qJobPlanLine2: Record "Job Planning Line";
        LineNo: Integer;
    begin
        with _QuoteLine do begin
            if "NS_Qty. per Unit of Measure" = 0 then
                "NS_Qty. per Unit of Measure" := 1;
            "NS_Quantity (Base)" := NS_CalcBaseQty(_QuoteLine, NS_Quantity);

            qJobPlanLine2.RESET;
            qJobPlanLine2.SETRANGE("Job No.", "NS_Quote No.");
            if qJobPlanLine2.FINDLAST then
                LineNo := qJobPlanLine2."Line No." + 10000
            else
                LineNo := 10000;

            qJobPlanLine.RESET;
            qJobPlanLine.SETRANGE("Job No.", "NS_Quote No.");
            qJobPlanLine.SETRANGE("Job Task No.", "NS_Job Task No.");
            qJobPlanLine.SETRANGE(Type, NS_Type);
            qJobPlanLine.SETRANGE("No.", "NS_No.");
            if qJobPlanLine.FINDFIRST then begin
                if qJobPlanLine.Quantity <> NS_Quantity then begin
                    qJobPlanLine.VALIDATE(Quantity, NS_Quantity);
                    qJobPlanLine.MODIFY;
                end;
            end;
        end;
    end;

    procedure NS_OnValidateQuantity2(qQuoteLine: Record "NS_Job Quote Line");
    var
        qQuotePlanLine: Record "Job Planning Line";
    begin

        qQuotePlanLine.RESET;
        qQuotePlanLine.SETRANGE("Job No.", qQuoteLine."NS_Quote No.");
        qQuotePlanLine.SETRANGE("Job Task No.", qQuoteLine."NS_Job Task No.");

        if qQuoteLine.NS_Type = qQuoteLine.NS_Type::Item then
            qQuotePlanLine.SETRANGE(Type, qQuoteLine.NS_Type - 1);

        if qQuoteLine.NS_Type = qQuoteLine.NS_Type::Resource then
            qQuotePlanLine.SETRANGE(Type, qQuoteLine.NS_Type - 3);

        if qQuoteLine.NS_Type = qQuoteLine.NS_Type::"G/L Account" then
            qQuotePlanLine.SETRANGE(Type, qQuoteLine.NS_Type + 1);

        if qQuoteLine.NS_Type = qQuoteLine.NS_Type::Task then
            qQuotePlanLine.SETRANGE(Type, qQuoteLine.NS_Type - 1);

        if qQuoteLine.NS_Type = qQuoteLine.NS_Type::Template then
            qQuotePlanLine.SETRANGE(Type, qQuoteLine.NS_Type);

        qQuotePlanLine.SETRANGE("No.", qQuoteLine."NS_No.");
        if qQuotePlanLine.FINDFIRST then
            if qQuotePlanLine.Quantity <> qQuoteLine.NS_Quantity then begin
                qQuotePlanLine.VALIDATE(Quantity, qQuoteLine.NS_Quantity);
                qQuotePlanLine.MODIFY;
            end;
    end;

    procedure NS_OnValidateSalespersonCode(var _QuoteHeader: Record "NS_Job Quote Header");
    begin
        with _QuoteHeader do
            CALCFIELDS("NS_Salesperson Name");
    end;

    procedure NS_OnValidateSellToCustomer(var _QuoteHeader: Record "NS_Job Quote Header");
    var
        _CommentLine: Record "Comment Line";
        _Customer: Record Customer;
        _Customer2: Record Customer;
        _QuoteComment: Record "Comment Line";
        _QuoteLine: Record "NS_Job Quote Line";
        _SalesLine: Record "Sales Line";
        _xQuoteHeader: Record "NS_Job Quote Header";
        _PreservePricing: Boolean;
        _xPreservePricing: Boolean;
        _LineNo: Integer;
    begin
        if _xQuoteHeader.GET(_QuoteHeader."NS_Quote No.") then
            if _xQuoteHeader."NS_Sell-to Customer No." = '' then
                _PreservePricing := true
            else
                if _Customer.GET(_xQuoteHeader."NS_Sell-to Customer No.") then
                    if _Customer."NS_Quoting Customer" then
                        _PreservePricing := true;
        _xPreservePricing := _QuoteHeader."NS_Preserve Pricing Flag";
        if _PreservePricing then
            _QuoteHeader."NS_Preserve Pricing Flag" := true;
        // create NAV sales quote
        if _QuoteHeader."NS_Sales Quote No." = '' then
            NS_CreateSalesQuoteHeader(_QuoteHeader);

        with _QuoteHeader do begin
            _Customer.GET("NS_Sell-to Customer No.");
            if _Customer."Bill-to Customer No." = '' then
                VALIDATE("NS_Bill-to Customer No.", "NS_Sell-to Customer No.")
            else
                VALIDATE("NS_Bill-to Customer No.", _Customer."Bill-to Customer No.");
            "NS_Location Code" := _Customer."Location Code";
            if _Customer."Salesperson Code" <> '' then
                VALIDATE("NS_Salesperson Code New", _Customer."Salesperson Code");//PRJ-867.AS.1.0 23SEPT2021 Changed field Sales Person code to Sales person code New
            "NS_Sell-to Customer Name" := _Customer.Name;
            if _Customer2.GET(_Customer."Bill-to Customer No.") then
                "NS_Bill-to Customer Name" := _Customer2.Name
            else
                "NS_Bill-to Customer Name" := "NS_Sell-to Customer Name";

            "NS_Shipping Advice" := _Customer."Shipping Advice".AsInteger();
            "NS_Free Freight" := _Customer."NS_Free Freight";
        end;

        if _QuoteHeader."NS_Sales Quote No." <> '' then
            NS_SyncSalesQuoteHeader(_QuoteHeader);
        if not _QuoteHeader."NS_Preserve Pricing Flag" then begin
            _SalesLine.SETRANGE("Document Type", _SalesLine."Document Type"::Quote);
            _SalesLine.SETRANGE("Document No.", _QuoteHeader."NS_Sales Quote No.");
            _SalesLine.DELETEALL;
            _QuoteLine.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
            if _QuoteLine.FINDSET(false) then
                repeat
                    NS_OnValidateNoQuoteLine(_QuoteLine);
                    NS_OnValidateUnitPrice(_QuoteLine, _QuoteLine.FIELDNO("NS_Unit Price"));
                    _QuoteLine.MODIFY;
                until _QuoteLine.NEXT = 0;
        end;

        // copy comments

        _QuoteComment.SETRANGE("No.", _QuoteHeader."NS_Quote No.");
        _QuoteComment.SETRANGE("Line No.", 0);
        if _QuoteComment.FINDLAST then
            _LineNo := _QuoteComment."Line No.";

        _CommentLine.SETRANGE("Table Name", _CommentLine."Table Name"::Customer);
        _CommentLine.SETRANGE("No.", _QuoteHeader."NS_Sell-to Customer No.");
        if _CommentLine.FINDSET(false) then
            repeat
                with _QuoteComment do begin
                    _LineNo += 10000;
                    INIT;
                    "No." := _QuoteHeader."NS_Quote No.";
                    "Line No." := _LineNo;
                    Comment := COPYSTR(_CommentLine.Comment, 1, MAXSTRLEN(Comment));
                    Date := _CommentLine.Date;
                    INSERT(true);
                end;
            until _CommentLine.NEXT = 0;

        // copy addresses

        NS_CopyCustomerAddress(_QuoteHeader, _QuoteHeader."NS_Sell-to Customer No.");

        if not _xPreservePricing then
            _QuoteHeader."NS_Preserve Pricing Flag" := false;

        _QuoteHeader."NS_Job Ship-to Code" := '';
    end;

    procedure NS_OnValidateSelltoCustomerJQ(var qQuoteHeader: Record "NS_Job Quote Header");
    var
        lSellToCust: Record Customer;
        lBillToCust: Record Customer;
        Job: Record Job;
        JobPlanLine: Record "Job Planning Line";
    begin
        with qQuoteHeader do begin
            if lSellToCust.GET("NS_Sell-to Customer No.") then begin
                "NS_Sell-to Customer Name" := lSellToCust.Name;
                "NS_Job Address 1" := lSellToCust.Address;
                "NS_Job Address 2" := lSellToCust."Address 2";
                "NS_Job City" := lSellToCust.City;
                "NS_Job County" := lSellToCust.County;
                "NS_Job Post Code" := lSellToCust."Post Code";
                qQuoteHeader.validate("NS_Contact No.", lSellToCust."primary contact No.");  //PRJ-1215.JS.1.0  23FEB2022
                if lSellToCust."Bill-to Customer No." <> '' then begin
                    VALIDATE("NS_Bill-to Customer No.", lSellToCust."Bill-to Customer No.");
                    lBillToCust.GET(lSellToCust."Bill-to Customer No.");
                    "NS_Bill-to Customer Name" := lBillToCust.Name;

                    "NS_Bill-to Address" := lBillToCust.Address;
                    "NS_Bill-to Address 2" := lBillToCust."Address 2";
                    "NS_Bill-to City" := lBillToCust.City;
                    "NS_Bill-to County" := lBillToCust.County;
                    "NS_Bill-to Post Code" := lBillToCust."Post Code";
                end else begin
                    VALIDATE("NS_Bill-to Customer No.", "NS_Sell-to Customer No.");
                    "NS_Bill-to Customer Name" := lSellToCust.Name;

                    "NS_Bill-to Address" := lSellToCust.Address;
                    "NS_Bill-to Address 2" := lSellToCust."Address 2";
                    "NS_Bill-to City" := lSellToCust.City;
                    "NS_Bill-to County" := lSellToCust.County;
                    "NS_Bill-to Post Code" := lSellToCust."Post Code";
                end;
            end else
                ERROR('Site Customer No. must be populated');

            if Job.GET(qQuoteHeader."NS_Job No.") then
                if lSellToCust.GET(qQuoteHeader."NS_Sell-to Customer No.") then
                    //PRJCTPR-164.JS.1.0 21July2023 - Strat
                    if qQuoteHeader."NS_Sell-to Customer No." <> Job."NS_Sell-to Customer No." then begin
                        //Job.Validate("NS_Sell-to Customer No.", qQuoteHeader."NS_Sell-to Customer No."); Block
                        Job."NS_Sell-to Customer No." := qQuoteHeader."NS_Sell-to Customer No.";
                        Job."NS_Sell-to Customer Name" := lSellToCust.Name;//PRJCTPR-216.VC.1.0
                        Job."Sell-to Customer Name" := lSellToCust.Name;
                        Job."Sell-to Address" := lSellToCust.Address;
                        Job."Sell-to Address 2" := lSellToCust."Address 2";
                        Job."Sell-to City" := lSellToCust.City;
                        Job."Sell-to County" := lSellToCust.County;
                        Job."Sell-to Post Code" := lSellToCust."Post Code";
                        Job."Sell-to Country/Region Code" := lSellToCust."Country/Region Code";
                        Job."Sell-to Customer Name 2" := lSellToCust."Name 2";
                        Job."Sell-to Contact" := lSellToCust.Contact;
                        Job."Sell-to Customer Name" := lSellToCust.Name;
                        Job."Sell-to Customer No." := qQuoteHeader."NS_Sell-to Customer No.";
                        //PRJCTPR-216.VC.1.0 Start
                        Job."Sell-to Customer No." := lSellToCust."No.";
                        Job."Sell-to Customer Name" := lSellToCust.Name;
                        //PRJCTPR-216.VC.1.0 End
                        Job."Sell-to Customer Name 2" := lSellToCust."Name 2";
                        Job.MODIFY();
                    end;
            //PRJCTPR-164.JS.1.0 21July2023 - End                
            if lSellToCust."No." <> lSellToCust."Bill-to Customer No." then begin
                if lBillToCust.GET(lSellToCust."Bill-to Customer No.") then begin
                    Job."Bill-to Name" := lBillToCust.Name;
                    Job."Bill-to Address" := lBillToCust.Address;
                    Job."Bill-to Address 2" := lBillToCust."Address 2";
                    Job."Bill-to City" := lBillToCust.City;
                    Job."Bill-to County" := lBillToCust.County;
                    Job."Bill-to Post Code" := lBillToCust."Post Code";
                    Job."Bill-to Country/Region Code" := lBillToCust."Country/Region Code";
                    Job."Bill-to Name 2" := lBillToCust."Name 2";
                    //Job."Bill-to Contact No." :=
                    Job."Bill-to Contact" := lBillToCust.Contact;
                    Job.MODIFY();
                end;
            end else begin
                Job."Bill-to Name" := lSellToCust.Name;
                Job."Bill-to Address" := lSellToCust.Address;
                Job."Bill-to Address 2" := lSellToCust."Address 2";
                Job."Bill-to City" := lSellToCust.City;
                Job."Bill-to County" := lSellToCust.County;
                Job."Bill-to Post Code" := lSellToCust."Post Code";
                Job."Bill-to Country/Region Code" := lSellToCust."Country/Region Code";
                Job."Bill-to Name 2" := lSellToCust."Name 2";
                //Job."Bill-to Contact No." :=
                Job."Bill-to Contact" := lSellToCust.Contact;
                Job.MODIFY();
            end;
            Commit();    //PRJCTPR-164.JS.1.0

            JobPlanLine.RESET;
            JobPlanLine.SETRANGE("Job No.", "NS_Quote No.");
            if (JobPlanLine.FINDFIRST) and ("NS_Sell-to Customer No." = '') then
                ERROR('Sell-to Customer No. cannot be blank');

            "NS_Job Ship-to Code" := '';

        end;
    end;

    procedure NS_OnValidateTemplate(var _QuoteHeader: Record "NS_Job Quote Header");
    var
        _Text000: Label 'This quote has been assigned to the LIBRARY, so Template may not be changed.';
        _Text001: Label 'This quote has been assigned to the LIBRARY.  If Template is turned OFF, the document will be removed from the LIBRARY.  Continue?';
    begin
        if STRPOS(UPPERCASE(_QuoteHeader."NS_Created by"), 'LIBRARY') <> 0 then begin
            if NS_QuoteListFiltered then
                ERROR(_Text000);       // normal quote users not able to edit Template on quotes assigned to LIBRARY
            if not HideValidationDialog then
                if not CONFIRM(_Text001, false) then
                    ERROR(_Text000);
            _QuoteHeader."NS_Salesperson/User ID" := USERID;
            _QuoteHeader."NS_Created by" := USERID;  // super quote users, if modify Template, change USERID
        end;                                    //   so the quote no longer appears in the LIBRARY
        _QuoteHeader.MODIFY;
    end;

    procedure NS_OnValidateType(var _QuoteLine: Record "NS_Job Quote Line"; _xQuoteLine: Record "NS_Job Quote Line");
    var
        _Type: Integer;
    begin
        _Type := _QuoteLine.NS_Type;
        if (_xQuoteLine.NS_Type <> 0) and (_xQuoteLine."NS_No." <> '') then begin
            _QuoteLine.INIT;
            _QuoteLine.NS_Type := _Type;
            NS_SyncSalesQuoteLine(_QuoteLine, false);
        end;
    end;

    procedure NS_OnValidateUnitOfMeasure(var _QuoteLine: Record "NS_Job Quote Line");
    var
        _ItemUnitOfMeasure: Record "Item Unit of Measure";
        _ResUnitOfMeasure: Record "Resource Unit of Measure";
    begin
        with _QuoteLine do
            case NS_Type of
                NS_Type::Item:
                    begin
                        _ItemUnitOfMeasure.GET("NS_No.", "NS_Unit of Measure Code");
                        "NS_Qty. per Unit of Measure" := _ItemUnitOfMeasure."Qty. per Unit of Measure";
                        "NS_Quantity (Base)" := NS_CalcBaseQty(_QuoteLine, NS_Quantity);
                    end;
                NS_Type::Resource:
                    begin
                        _ResUnitOfMeasure.GET("NS_No.", "NS_Unit of Measure Code");
                        "NS_Qty. per Unit of Measure" := _ResUnitOfMeasure."Qty. per Unit of Measure";
                        "NS_Quantity (Base)" := NS_CalcBaseQty(_QuoteLine, NS_Quantity);
                    end;
                else begin
                    "NS_Qty. per Unit of Measure" := 1;
                    "NS_Quantity (Base)" := NS_Quantity;
                end;
            end;

        NS_SyncSalesQuoteLine(_QuoteLine, false);
    end;

    procedure NS_OnValidateUnitPrice(var _QuoteLine: Record "NS_Job Quote Line"; _FieldNo: Integer);
    var
        _Currency: Record Currency;
        _Item: Record Item;
        _ItemVariant: Record "Item Variant";
        _ItemNoToDisplay: Code[30];
        _UnitCost: Decimal;
        _Text000: Label 'One or more %1 records exist for %2 %3.  %4 is required.';
    begin
        with _QuoteLine do
            if (_FieldNo = FIELDNO(NS_Quantity)) and
               (NS_Quantity <> 0) and
               (NS_Type = NS_Type::Item) and
               ("NS_No." <> '') and
               ("NS_Variant Code" = '')
            then begin
                _ItemNoToDisplay := "NS_No.";
                if "NS_No. 2" <> '' then
                    _ItemNoToDisplay := "NS_No. 2";
                _ItemVariant.SETRANGE("Item No.", "NS_No.");
                if not _ItemVariant.ISEMPTY then
                    ERROR(_Text000, _ItemVariant.TABLECAPTION, _Item.TABLECAPTION, _ItemNoToDisplay, FIELDCAPTION("NS_Variant Code"));
            end;

        if _QuoteLine."NS_Attached to Line No." <> 0 then begin
            NS_ZeroUnitPrice(_QuoteLine);
            exit;
        end;

        with _QuoteLine do begin

            if NS_Quantity = 0 then begin
                "NS_Qty. per Unit of Measure" := 1;
                "NS_Quantity (Base)" := 0;
                NS_Markup := 0;
                NS_Amount := 0;
                exit;
            end;

            "NS_Quantity (Base)" := NS_CalcBaseQty(_QuoteLine, NS_Quantity);

            _UnitCost := "NS_Vendor Cost";
            if _UnitCost = 0 then
                _UnitCost := "NS_Unit Cost";

            // new field Total Cost incorporates Use Tax Amount as part of the cost
            _Currency.InitRoundingPrecision;
            //"Total Cost" := _UnitCost;//*
            "NS_Total Cost" := "NS_Unit Cost" * NS_Quantity;
            if "NS_Use Tax Amount" <> 0 then
                "NS_Total Cost" := ROUND(_UnitCost + "NS_Use Tax Amount" / NS_Quantity, _Currency."Amount Rounding Precision");

            // if Quote is marked Use Tax Liable, calculate Use Tax

            NS_GetQuoteHeaderC50000(_QuoteLine);
            if QuoteHeader."NS_Use Tax Liable" <> QuoteHeader."NS_Use Tax Liable"::Yes then begin
                CLEAR("NS_Use Tax SKU");
                CLEAR("NS_Use Tax Amount");
                CLEAR("NS_Sales Tax Amount");
            end else
                if not (_FieldNo in [FIELDNO("NS_Use Tax Amount"), FIELDNO("NS_Sales Tax Amount")]) then begin
                    CLEAR("NS_Use Tax SKU");
                    CLEAR("NS_Use Tax Amount");
                    CLEAR("NS_Sales Tax Amount");
                end;

            // calculate the Unit Price based on markup and vice versa

            case _FieldNo of
                FIELDNO(NS_Amount):
                    begin
                        if NS_Amount - "NS_Line Discount Amount" < 0 then begin
                            "NS_Line Discount Amount" := 0;
                            "NS_Line Discount %" := 0;
                        end;
                        "NS_Total Price" := NS_Amount / NS_Quantity;
                        "NS_Total Price" := ROUND("NS_Total Price", _Currency."Amount Rounding Precision");
                        if NS_Amount = 0 then begin
                            NS_ZeroUnitPrice(_QuoteLine);
                            exit;
                        end;
                        if "NS_Total Price" = 0 then
                            NS_Markup := 0
                        else
                            NS_Markup := ROUND((("NS_Total Price" - "NS_Total Cost") / "NS_Total Cost") * 100, _Currency."Amount Rounding Precision");
                        if NS_Markup = 0 then
                            "NS_Unit Price" := 0
                        else
                            "NS_Unit Price" := ROUND(_UnitCost + (_UnitCost * (NS_Markup / 100)), _Currency."Amount Rounding Precision");
                        NS_OnValidateUnitPrice(_QuoteLine, FIELDNO("NS_Unit Price"));
                        exit;
                    end;
                FIELDNO("NS_Vendor Cost"),
                FIELDNO("NS_Unit Cost"),
                FIELDNO("NS_Unit Price"), FIELDNO(NS_Quantity):
                    begin
                        if "NS_Unit Price" = 0 then
                            NS_Markup := 0
                        else
                            NS_Markup := (("NS_Unit Price" - _UnitCost) / _UnitCost) * 100;
                    end
                else
                    if NS_Markup <> 0 then
                        "NS_Unit Price" := ROUND(_UnitCost + (_UnitCost * (NS_Markup / 100)), _Currency."Amount Rounding Precision");
            end;

            if NS_Markup = 0 then
                "NS_Total Price" := 0
            else
                "NS_Total Price" := ROUND("NS_Total Cost" + ("NS_Total Cost" * (NS_Markup / 100)), _Currency."Amount Rounding Precision");
            NS_Amount := ROUND(NS_Quantity * "NS_Unit Price", _Currency."Amount Rounding Precision");
            if NS_Amount - "NS_Line Discount Amount" < 0 then begin
                "NS_Line Discount Amount" := 0;
                "NS_Line Discount %" := 0;
            end;

            // adjust for line discount

            if NS_Amount = 0 then
                "NS_Line Discount %" := 0
            else
                case _FieldNo of
                    FIELDNO("NS_Line Discount Amount"):
                        begin
                            if "NS_Line Discount Amount" > NS_Amount then
                                "NS_Line Discount Amount" := NS_Amount;
                            if "NS_Line Discount Amount" < 0 then
                                "NS_Line Discount Amount" := 0;
                            "NS_Line Discount %" := ROUND("NS_Line Discount Amount" / NS_Amount * 100, 0.00001);
                        end
                    else begin
                        "NS_Line Discount Amount" := NS_Amount * ("NS_Line Discount %" / 100);
                        if "NS_Line Discount Amount" > NS_Amount then
                            "NS_Line Discount Amount" := NS_Amount;
                        if "NS_Line Discount Amount" < 0 then
                            "NS_Line Discount Amount" := 0;
                        "NS_Line Discount %" := ROUND(("NS_Line Discount Amount" / NS_Amount) * 100, 0.00001);
                    end;
                end;

            // synchronize the sales quote line
            // when the document is submitted for review, the sales quote will get released,
            // and the tax amounts will flow back to the Quote lines

            NS_SyncSalesQuoteLine(_QuoteLine, true);

            // adjust amount for line discount amount

            NS_Amount -= "NS_Line Discount Amount";
            NS_Amount := ROUND(NS_Amount, _Currency."Amount Rounding Precision");

            // calculate Gross Margin %

            if NS_Amount = 0 then
                "NS_Gross Margin %" := 0
            else
                "NS_Gross Margin %" := ROUND(((NS_Amount - "NS_Total Cost") / NS_Amount) * 100, 0.01);

            "NS_Gross Margin" := NS_Amount - "NS_Total Cost";

            NS_GetQuoteLine(_QuoteLine);
            NS_ContractPriceFoundForSalesLine(SalesLine);
            "NS_Contract Price Found" := SalesLine."NS_Contract Price Found";

        end;
    end;

    procedure NS_OnValidateUseTaxLiable(var _QuoteHeader: Record "NS_Job Quote Header");
    var
        _QuoteLine: Record "NS_Job Quote Line";
        _Text000: Label 'One or more lines on this bid contain a %1.  Lines will be adjusted to remove the %2.  Continue?';
    begin
        exit;

        if _QuoteHeader."NS_Use Tax Liable" <> _QuoteHeader."NS_Use Tax Liable"::Yes then
            exit;

        _QuoteLine.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        _QuoteLine.SETFILTER("NS_Use Tax Amount", '<>0');
        if not _QuoteLine.FINDSET(true) then
            exit;

        if GUIALLOWED then
            if not CONFIRM(_Text000
                          , false
                          , _QuoteLine.FIELDCAPTION("NS_Use Tax Amount")
                          , _QuoteLine.FIELDCAPTION("NS_Use Tax Amount"))
            then begin
                _QuoteHeader."NS_Use Tax Liable" := _QuoteHeader."NS_Use Tax Liable"::Yes;
                exit;
            end;

        repeat
            _QuoteLine.VALIDATE("NS_Use Tax Amount", 0);
            _QuoteLine.MODIFY(true);
        until _QuoteLine.NEXT = 0;
    end;

    procedure NS_OnValidateVariantCode(var _QuoteLine: Record "NS_Job Quote Line");
    var
        _Item: Record Item;
        _ItemVariant: Record "Item Variant";
        _Text000: Label 'One or more %1 records exist for %2 %3.  %4 is required.';
        _ItemNoToDisplay: Code[30];
    begin
        _ItemVariant.SETRANGE("Item No.", _QuoteLine."NS_No.");
        with _QuoteLine do begin
            _ItemNoToDisplay := "NS_No.";
            if "NS_No. 2" <> '' then
                _ItemNoToDisplay := "NS_No. 2";
            if "NS_Variant Code" <> '' then
                NS_OnValidateUnitPrice(_QuoteLine, FIELDNO("NS_Variant Code"))
            else
                if not _ItemVariant.ISEMPTY then
                    ERROR(_Text000, _ItemVariant.TABLECAPTION, _Item.TABLECAPTION, _ItemNoToDisplay, FIELDCAPTION("NS_Variant Code"));
        end;
    end;

    procedure NS_OnValidateVendorNo(var _QuoteLine: Record "NS_Job Quote Line");
    var
        _Vendor: Record Vendor;
    begin
        with _QuoteLine do
            if "NS_Vendor No." <> '' then
                if _Vendor.GET("NS_Vendor No.") then begin
                    "NS_Vendor Name" := _Vendor.Name;
                    "NS_Vendor Contact" := _Vendor.Contact;
                end;
    end;

    procedure NS_OpenUseTaxQuestionnaire(_QuoteHeader: Record "NS_Job Quote Header");
    var
        _UseTaxQuestionnaire: Page "NS_JobQuoteUseTaxQuestionnaire";
    begin
        _QuoteHeader.TESTFIELD("NS_Equipment Only", false);

        PAGE.RUNMODAL(PAGE::NS_JobQuoteUseTaxQuestionnaire, _QuoteHeader);
        _QuoteHeader.GET(_QuoteHeader."NS_Quote No.");
        if ((_QuoteHeader."NS_Use Tax Qualify Response 1" in [2]) and
            (_QuoteHeader."NS_Use Tax Qualify Response 2" in [2]))
        then
            _QuoteHeader."NS_Use Tax Liable" := _QuoteHeader."NS_Use Tax Liable"::Yes
        else
            _QuoteHeader."NS_Use Tax Liable" := _QuoteHeader."NS_Use Tax Liable"::No;
        _QuoteHeader.MODIFY;
    end;

    procedure NS_Parse(_ContentStr: Text[1024]; _Delimiter: Text[1]): Integer;
    var
        _k: Integer;
    begin
        CLEAR(Fields);
        _k := 1;
        repeat
            if (STRPOS(_ContentStr, _Delimiter) <> 0) then begin
                Fields[_k] := COPYSTR(_ContentStr, 1, STRPOS(_ContentStr, _Delimiter) - 1);
                _ContentStr := DELSTR(_ContentStr, 1, STRPOS(_ContentStr, _Delimiter));
            end else begin
                Fields[_k] := COPYSTR(_ContentStr, 1, MAXSTRLEN(Fields[_k]));
                CLEAR(_ContentStr);
            end;
            Fields[_k] := DELCHR(Fields[_k], '<>', '"');
            _k += 1;
        until (_k > ARRAYLEN(Fields)) or (_ContentStr = '');
        _k -= 1;
        exit(_k);
    end;

    procedure NS_ParseTabDelimitedLine(_TextLine: Text[1024]);
    var
        _tab: Char;
        _index: Integer;
        _delimiter: Text[1];
    begin
        _tab := 9;
        _delimiter := STRSUBSTNO('%1', _tab);

        _index := 1;
        CLEAR(Fields);
        if (_TextLine = '') then
            exit;

        repeat
            if (STRPOS(_TextLine, _delimiter) <> 0) then begin
                Fields[_index] := COPYSTR(_TextLine, 1, STRPOS(_TextLine, _delimiter) - 1);
                _TextLine := DELSTR(_TextLine, 1, STRPOS(_TextLine, _delimiter));
            end else begin
                Fields[_index] := COPYSTR(_TextLine, 1, STRLEN(_TextLine));
                _TextLine := '';
            end;
            Fields[_index] := DELCHR(Fields[_index], '<>', '"');
            _index += 1;
        until (_index > ARRAYLEN(Fields)) or (_TextLine = '');
    end;

    procedure NS_QuoteContainsInstallService(_QuoteHeader: Record "NS_Job Quote Header"): Boolean;
    var
        _QuoteLine: Record "NS_Job Quote Line";
        QuoteSetup: Record "Jobs Setup";
    begin
        QuoteSetup.GET;
        _QuoteLine.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        _QuoteLine.SETFILTER("NS_Category Code", '%1|%2', QuoteSetup."NS_Install Category Code", QuoteSetup."NS_Service Category Code");
        exit(not _QuoteLine.ISEMPTY);
    end;

    procedure NS_QuoteLinesExist(_QuoteHeader: Record "NS_Job Quote Header"): Boolean;
    var
        _QuoteLine: Record "NS_Job Quote Line";
    begin
        with _QuoteHeader do begin
            _QuoteLine.SETRANGE("NS_Quote No.", "NS_Quote No.");
            exit(_QuoteLine.FINDFIRST);
        end;
    end;

    procedure NS_QuoteListFiltered(): Boolean;
    var
        _UserSetup: Record "User Setup";
    begin
        if not _UserSetup.GET(USERID) then
            exit(true);

        exit(false);
    end;

    procedure NS_QuoteSelection(_QuoteHeader: Record "NS_Job Quote Header");
    var
        _QuoteTypeRel: Record "NS_Job Quote Type Relation";
        _Item: Record Item;
        _ItemCategory: Record "Item Category";
        _TempQuoteSelBuf: Record "NS_Job Quote Sel. Buf." temporary;
        _CurrCategoryCode: Code[10];
        _CurrEntryNo: Integer;
        _EntryNo: Integer;
        _RecCount: Integer;
        _TableID: Integer;
        _Text000: Label 'No records were found for %1 %2.';
    begin
        _QuoteHeader.TESTFIELD(NS_Template, false);

        CLEAR(_TempQuoteSelBuf);
        _TempQuoteSelBuf.DELETEALL;

        // build list of GLAccounts/Items/Resources based on Quote Type Relation

        _QuoteHeader.TESTFIELD("NS_Quote Type Code");
        with _QuoteTypeRel do begin
            SETRANGE("NS_Quote Type Code", _QuoteHeader."NS_Quote Type Code");
            if _QuoteTypeRel.FINDSET(false) then
                repeat
                    _EntryNo += 10;
                    _TempQuoteSelBuf.INIT;
                    _TempQuoteSelBuf."NS_Entry No." := _EntryNo;
                    _TempQuoteSelBuf."NS_Quote No." := _QuoteHeader."NS_Quote No.";
                    _TempQuoteSelBuf.NS_Indentation := 1;
                    _TempQuoteSelBuf.NS_Type := NS_GetQuoteRelTypeFromTableID(_QuoteTypeRel."NS_Table ID");
                    _TempQuoteSelBuf."NS_No." := _QuoteTypeRel."NS_No.";
                    if _TempQuoteSelBuf.NS_Type = _TempQuoteSelBuf.NS_Type::Item then
                        _TempQuoteSelBuf."NS_No. 2" := NS_GetItemNo2(_TempQuoteSelBuf."NS_No.");
                    _TempQuoteSelBuf.NS_Description := COPYSTR(_QuoteTypeRel.NS_Description, 1, MAXSTRLEN(_TempQuoteSelBuf.NS_Description));
                    _TempQuoteSelBuf."NS_Category Code" := _QuoteTypeRel."NS_Category Code";
                    if _TempQuoteSelBuf.NS_Description in ['', ' '] then
                        if _TempQuoteSelBuf.NS_Type = _TempQuoteSelBuf.NS_Type::Item then
                            _TempQuoteSelBuf.NS_Description := COPYSTR(NS_GetDescForItem(_TempQuoteSelBuf."NS_No.")
                                                                   , 1, MAXSTRLEN(_TempQuoteSelBuf.NS_Description));
                    if _TempQuoteSelBuf."NS_Category Code" = '' then
                        if _TempQuoteSelBuf.NS_Type = _TempQuoteSelBuf.NS_Type::Item then
                            _TempQuoteSelBuf."NS_Category Code" := COPYSTR(NS_GetCatCodeForItem(_TempQuoteSelBuf."NS_No.")
                                                                       , 1, MAXSTRLEN(_TempQuoteSelBuf."NS_Category Code"));
                    _TempQuoteSelBuf.INSERT;
                    _RecCount += 1;
                until _QuoteTypeRel.NEXT = 0;
        end;
        if _RecCount = 0 then begin
            MESSAGE(_Text000, _QuoteHeader.FIELDCAPTION("NS_Quote Type Code"), _QuoteHeader."NS_Quote Type Code");
            exit;
        end;

        // sort list by Item Category

        _CurrCategoryCode := '----------';
        _TempQuoteSelBuf.SETCURRENTKEY("NS_Category Code");
        if _TempQuoteSelBuf.FINDSET(false) then
            repeat
                if _CurrCategoryCode <> _TempQuoteSelBuf."NS_Category Code" then begin
                    _CurrCategoryCode := _TempQuoteSelBuf."NS_Category Code";
                    _CurrEntryNo := _TempQuoteSelBuf."NS_Entry No.";
                    _TempQuoteSelBuf.INIT;
                    _TempQuoteSelBuf."NS_Entry No." := _CurrEntryNo - 1;
                    if _ItemCategory.GET(_CurrCategoryCode) then
                        _TempQuoteSelBuf.NS_Description := COPYSTR(STRSUBSTNO('%1:  %2', _CurrCategoryCode, _ItemCategory.Description)
                                                               , 1
                                                               , MAXSTRLEN(_TempQuoteSelBuf.NS_Description));
                    if _TempQuoteSelBuf.NS_Description = '' then
                        _TempQuoteSelBuf.NS_Description := 'Uncategorized';
                    _TempQuoteSelBuf."NS_Category Code" := _CurrCategoryCode;
                    _TempQuoteSelBuf.INSERT;
                    _TempQuoteSelBuf.GET(_CurrEntryNo);
                end;
            until _TempQuoteSelBuf.NEXT = 0;

        // display list

        if _TempQuoteSelBuf.FINDFIRST then;
        PAGE.RUN(PAGE::"NS_Job Quote Selection", _TempQuoteSelBuf);
    end;

    procedure NS_QuoteSelectionCopyResults(var _TempQuoteSelBuf: Record "NS_Job Quote Sel. Buf." temporary);
    var
        _QuoteHeader: Record "NS_Job Quote Header";
        _QuoteLine: Record "NS_Job Quote Line";
        _LineNo: Integer;
    begin
        _TempQuoteSelBuf.SETFILTER(NS_Type, '>0');
        _TempQuoteSelBuf.SETFILTER(NS_Quantity, '>0');
        if _TempQuoteSelBuf.FINDSET(false) then begin
            _QuoteLine.SETRANGE("NS_Quote No.", _TempQuoteSelBuf."NS_Quote No.");
            if _QuoteLine.FINDLAST then
                _LineNo := ROUND(_QuoteLine."NS_Quote Line No." + 1, 10000, '>');
            repeat
                _LineNo += 10000;
                _QuoteLine.INIT;
                _QuoteLine."NS_Quote No." := _TempQuoteSelBuf."NS_Quote No.";
                _QuoteLine."NS_Quote Line No." := _LineNo;
                _QuoteLine.INSERT(true);
                NS_GetQuoteHeaderC50000(_QuoteLine);
                _QuoteLine.NS_Type := _TempQuoteSelBuf.NS_Type;
                _QuoteLine."NS_No." := _TempQuoteSelBuf."NS_No.";
                NS_OnValidateNoQuoteLine(_QuoteLine);
                _QuoteLine."NS_Variant Code" := NS_GetVariantIfRequired(_TempQuoteSelBuf."NS_No.");
                _QuoteLine.VALIDATE(NS_Quantity, _TempQuoteSelBuf.NS_Quantity);
                _QuoteLine."NS_Category Code" := _TempQuoteSelBuf."NS_Category Code";
                _QuoteLine.MODIFY(true);
            until _TempQuoteSelBuf.NEXT = 0;
        end;
    end;

    procedure NS_QuotingCheck(_QuoteHeader: Record "NS_Job Quote Header");
    var
        _Customer: Record Customer;
        _Item: Record Item;
        _QuoteLine: Record "NS_Job Quote Line";
        _Text000: Label '%1 must not be %2 for %3 %4, %5 %6 %7, line %8.';
    begin
        // quoting customers not allowed
        if _Customer.GET(_QuoteHeader."NS_Sell-to Customer No.") then
            _Customer.TESTFIELD("NS_Quoting Customer", false);
        if _QuoteHeader."NS_Sell-to Customer No." <> _QuoteHeader."NS_Bill-to Customer No." then
            if _Customer.GET(_QuoteHeader."NS_Bill-to Customer No.") then
                _Customer.TESTFIELD("NS_Quoting Customer", false);
        // quoting items not allowed
        _QuoteLine.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        _QuoteLine.SETRANGE(NS_Type, _QuoteLine.NS_Type::Item);
        if _QuoteLine.FINDSET(false) then
            repeat
                if _QuoteLine."NS_No." <> '' then
                    if _Item.GET(_QuoteLine."NS_No.") then
                        if _Item."NS_Quoting Item" then
                            ERROR(_Text000
                                 , _Item.FIELDCAPTION("NS_Quoting Item")
                                 , FORMAT(_Item."NS_Quoting Item")
                                 , _Item.TABLECAPTION
                                 , _Item."No."
                                 , _QuoteLine.FIELDCAPTION("NS_No. 2")
                                 , _QuoteLine."NS_No. 2"
                                 , _QuoteLine.NS_Description
                                 , FORMAT(_QuoteLine."NS_Quote Line No."));
            until _QuoteLine.NEXT = 0;
        CLEAR(_QuoteLine);
        _QuoteLine.RESET;
    end;

    procedure NS_Resync(_QuoteHeader: Record "NS_Job Quote Header");
    var
        _Text000: Label 'Are you absolutely sure you want to delete the NAV Sales Quote and generate a new one based on this Enhanced Sales Quote?';
        _QuoteLine: Record "NS_Job Quote Line";
        _SalesHeader: Record "Sales Header";
        _Text001: Label 'Deleting existing NAV Sales Quote No. %1 and \regenerating from this Enhanced Sales Quote No. %2 ...';
        _d: Dialog;
        NSQuoteStatus: enum "NS_Quote Status";  //PE-300.JS.1.0 29JULY2024
        NSQuoteStatusInt: Integer; //PE-300.JS.1.0 29JULY2024
    begin
        //PE-300.JS.1.0 29JULY2024
        Clear(NSQuoteStatusInt);
        NSQuoteStatus := NSQuoteStatus::Open;
        NSQuoteStatusInt := NSQuoteStatus.AsInteger();
        //PE-300.JS.1.0 29JULY2024
        _QuoteHeader.TESTFIELD("NS_Sales Quote No.");
        //PE-300-DK.1.0 29May2024 Start
        // if _QuoteHeader.NS_Status > _QuoteHeader.NS_Status::Open then
        //     _QuoteHeader.FIELDERROR(NS_Status);
        if _QuoteHeader."NS_Quote Status".AsInteger() > NSQuoteStatusInt then  //PE-300.JS.1.0 29July2024
            _QuoteHeader.FIELDERROR("NS_Quote Status");
        //PE-300-DK.1.0 29May2024 End
        if not CONFIRM(_Text000, false) then
            exit;
        _d.OPEN(STRSUBSTNO(_Text001, _QuoteHeader."NS_Sales Quote No.", _QuoteHeader."NS_Quote No."));
        _SalesHeader.GET(_SalesHeader."Document Type"::Quote, _QuoteHeader."NS_Sales Quote No.");
        _SalesHeader.SetHideValidationDialog(true);
        _SalesHeader.DELETE(true);
        _QuoteHeader."NS_Sales Quote No." := '';
        _QuoteHeader.MODIFY;
        _QuoteLine.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        _QuoteLine.MODIFYALL("NS_Sales Quote No.", '');
        _QuoteLine.MODIFYALL("NS_Sales Quote Line No.", 0);
        COMMIT;
        _QuoteHeader.GET(_QuoteHeader."NS_Quote No.");
        NS_SyncSalesQuoteLines(_QuoteHeader);
        _d.CLOSE;
    end;

    procedure NS_SearchItemNo(_CurrItemNo: Code[20]): Code[20];
    var
        _Item: Record Item;
        _ItemSearch: Page "NS_Job Quote Item Search";
    begin
        if _CurrItemNo <> '' then begin
            _Item.SETRANGE("No.", _CurrItemNo);
            if _Item.FINDFIRST then;
            _Item.SETRANGE("No.");
        end;
        CLEAR(_ItemSearch);
        _ItemSearch.SETTABLEVIEW(_Item);
        if _ItemSearch.RUNMODAL = ACTION::LookupOK then
            exit(_Item."No.")
        else
            exit(_ItemSearch.NS_GetItemNoSelected);
    end;

    procedure NS_SearchNo(_TableID: Integer; _Type: Integer; _No: Code[20]): Code[20];
    var
        _FixedAsset: Record "Fixed Asset";
        _GLAcc: Record "G/L Account";
        _Item: Record Item;
        _ItemCharge: Record "Item Charge";
        _Resource: Record Resource;
        _SalesLine: Record "Sales Line";
        _StdText: Record "Standard Text";
    begin
        case _TableID of
            DATABASE::"Sales Line":
                case _Type of
                    _SalesLine.Type::" ".AsInteger():
                        begin
                            if _No <> '' then begin
                                _StdText.SETRANGE(Code, _No);
                                if _StdText.FINDFIRST then;
                                _StdText.SETRANGE(Code);
                            end;
                            if PAGE.RUNMODAL(PAGE::"Standard Text Codes", _StdText) = ACTION::LookupOK then
                                exit(_StdText.Code);
                        end;
                    _SalesLine.Type::"G/L Account".AsInteger():
                        begin
                            if _No <> '' then begin
                                _GLAcc.SETRANGE("No.", _No);
                                if _GLAcc.FINDFIRST then;
                                _GLAcc.SETRANGE("No.");
                            end;
                            if PAGE.RUNMODAL(PAGE::"G/L Account List", _GLAcc) = ACTION::LookupOK then
                                exit(_GLAcc."No.");
                        end;
                    _SalesLine.Type::Item.AsInteger():  // this code will not be reached from OnLookup of "No. 2" on Page 46
                        begin
                            if _No <> '' then begin
                                _Item.SETRANGE("No.", _No);
                                if _Item.FINDFIRST then;
                                _Item.SETRANGE("No.");
                            end;
                            if PAGE.RUNMODAL(PAGE::"Item List", _Item) = ACTION::LookupOK then
                                exit(_Item."No.");
                        end;
                    _SalesLine.Type::Resource.AsInteger():
                        begin
                            if _No <> '' then begin
                                _Resource.SETRANGE("No.", _No);
                                if _Resource.FINDFIRST then;
                                _Resource.SETRANGE("No.");
                            end;
                            if PAGE.RUNMODAL(PAGE::"Resource List", _Resource) = ACTION::LookupOK then
                                exit(_Resource."No.");
                        end;
                    _SalesLine.Type::"Fixed Asset".AsInteger():
                        begin
                            if _No <> '' then begin
                                _FixedAsset.SETRANGE("No.", _No);
                                if _FixedAsset.FINDFIRST then;
                                _FixedAsset.SETRANGE("No.");
                            end;
                            if PAGE.RUNMODAL(PAGE::"Fixed Asset List", _FixedAsset) = ACTION::LookupOK then
                                exit(_FixedAsset."No.");
                        end;
                    _SalesLine.Type::"Charge (Item)".AsInteger():
                        begin
                            if _No <> '' then begin
                                _ItemCharge.SETRANGE("No.", _No);
                                if _ItemCharge.FINDFIRST then;
                                _ItemCharge.SETRANGE("No.");
                            end;
                            if PAGE.RUNMODAL(PAGE::"Item Charges", _ItemCharge) = ACTION::LookupOK then
                                exit(_ItemCharge."No.");
                        end;
                end;
            DATABASE::"NS_Job Quote Line":
                case _Type of
                    _SalesLine.Type::"G/L Account".AsInteger():
                        begin
                            if _No <> '' then begin
                                _GLAcc.SETRANGE("No.", _No);
                                if _GLAcc.FINDFIRST then;
                                _GLAcc.SETRANGE("No.");
                            end;
                            if PAGE.RUNMODAL(PAGE::"G/L Account List", _GLAcc) = ACTION::LookupOK then
                                exit(_GLAcc."No.");
                        end;
                    _SalesLine.Type::Resource.AsInteger():
                        begin
                            if _No <> '' then begin
                                _Resource.SETRANGE("No.", _No);
                                if _Resource.FINDFIRST then;
                                _Resource.SETRANGE("No.");
                            end;
                            if PAGE.RUNMODAL(PAGE::"Resource List", _Resource) = ACTION::LookupOK then
                                exit(_Resource."No.");
                        end;
                end;
        end;
    end;

    procedure NS_SetHideValidationDialog(_HideValidationDialog: Boolean);
    begin
        HideValidationDialog := _HideValidationDialog;
    end;

    procedure NS_SetPricePreserve(var _QuoteHeader: Record "NS_Job Quote Header"; _ExecuteOnModifyTrigger: Boolean);
    var
        _UserSetup: Record "User Setup";
        _Text000: Label 'You do not have Authorization for this function.\Please contact your systems administrator.';
        _Text001: Label '%1 is %2 on Quote %3.';
    begin
        if not _UserSetup.GET(USERID) then
            exit;

        with _QuoteHeader do begin
            "NS_Preserve Pricing Flag" := not "NS_Preserve Pricing Flag";
            MODIFY(_ExecuteOnModifyTrigger);
            MESSAGE(_Text001, FIELDCAPTION("NS_Preserve Pricing Flag"), FORMAT("NS_Preserve Pricing Flag"), "NS_Quote No.");
        end;
    end;

    procedure NS_SetStatusOpen(var _QuoteHeader: Record "NS_Job Quote Header");
    var
        _DocumentApprovalEntry: Record "Approval Entry";
        _Item: Record Item;
        _QuoteLine: Record "NS_Job Quote Line";
        _SalesHeader: Record "Sales Header";
        _DocumentApprovalMgt: Codeunit "Approvals Mgmt.";
        _ReleaseSalesDoc: Codeunit "Release Sales Document";
        NSQuoteStatus: enum "NS_Quote Status";  //PE-300.JS.1.0 29JULY2024
        NSQuoteStatusInt: Integer; //PE-300.JS.1.0 29JULY2024        
        _Blocked: Boolean;
        _BlockedItemNo: Code[20];
        _Text000: Label 'At least one item is marked as Blocked on the Item Card:  No. %1, Mfg. Item No. %2, %3';
    begin
        //PE-300.JS.1.0 29JULY2024
        Clear(NSQuoteStatusInt);
        NSQuoteStatus := NSQuoteStatus::Accepted;
        NSQuoteStatusInt := NSQuoteStatus.AsInteger();
        //PE-300.JS.1.0 29JULY2024        
        _QuoteHeader.TESTFIELD(NS_Template, false);
        //PE-300-DK.1.0 29May2024 Start
        // if _QuoteHeader.NS_Status > _QuoteHeader.NS_Status::Accepted then
        //     _QuoteHeader.FIELDERROR(NS_Status);
        //if _QuoteHeader."NS_Quote Status".AsInteger() > _QuoteHeader."NS_Quote Status".AsInteger() then
        if _QuoteHeader."NS_Quote Status".AsInteger() > NSQuoteStatusInt then
            _QuoteHeader.FIELDERROR("NS_Quote Status");
        //PE-300-DK.1.0 29May2024 End
        //PRJ-1170.NK.1.0 Start
        //with _DocumentApprovalEntry do
        //PE-300-DK.1.0 29May2024 Start
        // _QuoteHeader.NS_Status := _QuoteHeader.NS_Status::Open;
        _QuoteHeader."NS_Quote Status" := _QuoteHeader."NS_Quote Status"::Open;
        //PE-300-DK.1.0 29May2024 End

        if _QuoteHeader."NS_Sales Quote No." <> '' then
            if _SalesHeader.GET(_SalesHeader."Document Type", _QuoteHeader."NS_Sales Quote No.") then begin
                CLEAR(_ReleaseSalesDoc);
                _ReleaseSalesDoc.Reopen(_SalesHeader);
            end;

        _QuoteLine.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        _QuoteLine.MODIFYALL("NS_Amount Including VAT", 0);

        if _QuoteLine.FINDSET(false) then
            repeat
                _QuoteLine."NS_Use Tax SKU" := '';
                _QuoteLine."NS_Use Tax Amount" := 0;
                _QuoteLine."NS_Sales Tax Amount" := 0;
                _Blocked := false;
                if _QuoteLine.NS_Type = _QuoteLine.NS_Type::Item then
                    if _Item.GET(_QuoteLine."NS_No.") then
                        if _Item.Blocked then begin
                            _Blocked := true;
                            _BlockedItemNo := _Item."No.";
                        end;
                if not _Blocked then
                    NS_OnValidateUnitPrice(_QuoteLine, _QuoteLine.FIELDNO("NS_Unit Price"));
                _QuoteLine.MODIFY;
            until _QuoteLine.NEXT = 0;

        if not HideValidationDialog then
            if _BlockedItemNo <> '' then
                if _Item.GET(_BlockedItemNo) then
                    MESSAGE(_Text000, _Item."No.", _Item."No. 2", _Item.Description);
    end;

    procedure NS_SetStatusReleased(var _QuoteHeader: Record "NS_Job Quote Header");
    var
        _DocumentApprovalEntry: Record "Approval Entry";
        _QuoteLine: Record "NS_Job Quote Line";
        _SalesHeader: Record "Sales Header";
        _SalesLine: Record "Sales Line";
        _DocumentApprovalMgt: Codeunit "Approvals Mgmt.";
        _ReleaseSalesDoc: Codeunit "Release Sales Document";
        _Proposal: Boolean;
        _Text000: Label 'Every line for Item, Resource or G/L Account must have a Category Code.  Line No. found: %1';
        NSQuoteStatus: enum "NS_Quote Status";  //PE-300.JS.1.0 29JULY2024
        NSQuoteStatusInt: Integer; //PE-300.JS.1.0 29JULY2024        
    begin
        //PE-300.JS.1.0 29JULY2024
        Clear(NSQuoteStatusInt);
        NSQuoteStatus := NSQuoteStatus::Released;
        NSQuoteStatusInt := NSQuoteStatus.AsInteger();
        //PE-300.JS.1.0 29JULY2024
        // require category code
        _QuoteLine.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        _QuoteLine.SETFILTER(NS_Type, '<>%1', _QuoteLine.NS_Type::" ");
        _QuoteLine.SETFILTER("NS_Category Code", '%1', '');
        if _QuoteLine.FINDFIRST then
            ERROR(_Text000, _QuoteLine."NS_Quote Line No.");
        CLEAR(_QuoteLine);
        _QuoteLine.RESET;

        _QuoteHeader.TESTFIELD("NS_Sell-to Customer No.");
        _Proposal := not _QuoteHeader."NS_Equipment Only";
        _QuoteHeader.TESTFIELD(NS_Template, false);
        //PE-300-DK.1.0 29May2024 Start
        // if _Proposal then
        //     _QuoteHeader.TESTFIELD(NS_Status, _QuoteHeader.NS_Status::Review)     // requires mgr approval
        // else
        //     if _QuoteHeader.NS_Status >= _QuoteHeader.NS_Status::Released then
        //         _QuoteHeader.FIELDERROR(NS_Status);
        if _Proposal then
            _QuoteHeader.TESTFIELD("NS_Quote Status", _QuoteHeader."NS_Quote Status"::Review)     // requires mgr approval
        else
            //if _QuoteHeader."NS_Quote Status".Asinteger() >= _QuoteHeader."NS_Quote Status".AsInteger() then
            if _QuoteHeader."NS_Quote Status".Asinteger() >= NSQuoteStatusInt then   //PE-300.JS.1.0 29July2024
                _QuoteHeader.FIELDERROR("NS_Quote Status");
        //PE-300-DK.1.0 29May2024 End
        if _QuoteHeader."NS_Equipment Only" then begin  // quotes marked equipment only do not require user to select Review action
                                                        // send approval request
            _QuoteHeader.CALCFIELDS(NS_Amount);
            /*_DocumentApprovalMgt.NewDocumentApprovalEntry(DATABASE::"Job Quote Header"
                                                         ,_QuoteHeader."Quote No."
                                                         ,_DocumentApprovalEntry."Document Area"::Sales
                                                         ,_DocumentApprovalEntry."Document Type"::Quote
                                                         ,_QuoteHeader.Amount
                                                         ,GetEquipGrossMarginPct(_QuoteHeader)
                                                         ,_DocumentApprovalEntry.Status::Review
                                                         ,QuoteContainsInstallService(_QuoteHeader)
                                                         ,FALSE    // equipment/service approved
                                                         ,_QuoteHeader."Equipment Only"
                                                         ,'')*/
        end;
        if not HideValidationDialog then
            /*IF NOT _DocumentApprovalMgt.AttemptRelease(DATABASE::"Job Quote Header"
                                                      ,_QuoteHeader."Quote No."
                                                      ,_DocumentApprovalEntry."Document Area"::Sales
                                                      ,_DocumentApprovalEntry."Document Type"::Quote)
            THEN BEGIN
              _DocumentApprovalMgt.ApprovalMsg(FALSE);*/
            exit;
        //END;

        NS_SyncSalesQuoteHeader(_QuoteHeader);
        NS_SyncSalesQuoteLines(_QuoteHeader);
        //PE-300-DK.1.0 29May2024 Start
        //_QuoteHeader.NS_Status := _QuoteHeader.NS_Status::Released;
        _QuoteHeader."NS_Quote Status" := _QuoteHeader."NS_Quote Status"::Released;
        //PE-300-DK.1.0 29May2024 End
        _QuoteHeader.MODIFY;

        // release associated sales quote

        _SalesHeader.GET(_SalesHeader."Document Type"::Quote, _QuoteHeader."NS_Sales Quote No.");
        CLEAR(_ReleaseSalesDoc);
        _ReleaseSalesDoc.RUN(_SalesHeader);

        // synchronize Amount Including VAT

        _QuoteLine.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        if _QuoteLine.FINDSET(false) then
            repeat
                if _SalesLine.GET(_SalesLine."Document Type"::Quote
                                 , _QuoteLine."NS_Sales Quote No."
                                 , _QuoteLine."NS_Sales Quote Line No.")
                then
                    if _SalesLine."Amount Including VAT" <> 0 then begin
                        if _QuoteHeader."NS_Use Tax Liable" <> _QuoteHeader."NS_Use Tax Liable"::Yes then begin
                            _QuoteLine."NS_Amount Including VAT" := _SalesLine."Amount Including VAT";
                            _QuoteLine."NS_Sales Tax Amount" := _SalesLine."Amount Including VAT" - _SalesLine.Amount;
                        end else
                            _QuoteLine."NS_Amount Including VAT" := _QuoteLine.NS_Amount + _QuoteLine."NS_Sales Tax Amount";
                        _QuoteLine.MODIFY;
                    end;
            until _QuoteLine.NEXT = 0;

    end;

    procedure NS_SetStatusReview(var _QuoteHeader: Record "NS_Job Quote Header");
    var
        _DocumentApprovalEntry: Record "Approval Entry";
        _QuoteLine: Record "NS_Job Quote Line";
        _SalesHeader: Record "Sales Header";
        _SalesLine: Record "Sales Line";
        _DocumentApprovalMgt: Codeunit "Approvals Mgmt.";
        _ReleaseSalesDoc: Codeunit "Release Sales Document";
        _Text000: Label 'Use Tax eligibility has not yet been determined on %1 %2.';
        _Text001: Label 'Every line for Item, Resource or G/L Account must have a Category Code.  Line No. found: %1';
    begin
        // test status

        _QuoteHeader.TESTFIELD(NS_Template, false);
        //PE-300-DK.1.0 29May2024 Start
        // _QuoteHeader.TESTFIELD(NS_Status, _QuoteHeader.NS_Status::Open);
        _QuoteHeader.TESTFIELD("NS_Quote Status", _QuoteHeader."NS_Quote Status"::Open);
        //PE-300-DK.1.0 29May2024 End
        _QuoteHeader.TESTFIELD("NS_Equipment Only", false);

        // require category code
        _QuoteLine.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        _QuoteLine.SETFILTER(NS_Type, '<>%1', _QuoteLine.NS_Type::" ");
        _QuoteLine.SETFILTER("NS_Category Code", '%1', '');
        if _QuoteLine.FINDFIRST then
            ERROR(_Text001, _QuoteLine."NS_Quote Line No.");
        CLEAR(_QuoteLine);
        _QuoteLine.RESET;

        // calculate Use Tax

        if _QuoteHeader."NS_Use Tax Liable" = _QuoteHeader."NS_Use Tax Liable"::" " then
            NS_VerifyUseTaxEligibility(_QuoteHeader, false);
        if _QuoteHeader."NS_Use Tax Liable" = _QuoteHeader."NS_Use Tax Liable"::" " then
            ERROR(_Text000, _QuoteHeader.TABLECAPTION, _QuoteHeader."NS_Quote No.")
        else begin
            _QuoteHeader.MODIFY;
            COMMIT;
        end;

        // create Sales Quote if not exist

        // >> Upgrade
        // NS_CreateSalesQuoteHeader(_QuoteHeader);

        // // synchronize Sales Quote and Quote (Enhanced)

        // NS_SyncSalesQuoteHeader(_QuoteHeader);
        // NS_SyncSalesQuoteLines(_QuoteHeader);

        // // release quote

        // if _SalesHeader.GET(_SalesHeader."Document Type"::Quote, _QuoteHeader."NS_Sales Quote No.") then begin
        //     CLEAR(_ReleaseSalesDoc);
        //     //_ReleaseSalesDoc.SetHideValidationDialog(TRUE);
        //     _ReleaseSalesDoc.RUN(_SalesHeader);
        // end;

        // // copy taxability information from quote

        // _QuoteLine.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        // if _QuoteLine.FINDSET(true) then
        //     repeat
        //         if _QuoteLine."NS_Sales Quote Line No." <> 0 then
        //             if _SalesLine.GET(_SalesLine."Document Type"::Quote, _QuoteLine."NS_Sales Quote No.", _QuoteLine."NS_Sales Quote Line No.") then begin
        //                 if _QuoteHeader."NS_Use Tax Liable" = _QuoteHeader."NS_Use Tax Liable"::No then begin
        //                     _QuoteLine."NS_Amount Including VAT" := _SalesLine."Amount Including VAT";
        //                     _QuoteLine."NS_Sales Tax Amount" := _SalesLine."Amount Including VAT" - _SalesLine.Amount;
        //                 end else
        //                     _QuoteLine."NS_Amount Including VAT" := _QuoteLine.NS_Amount + _QuoteLine."NS_Sales Tax Amount";
        //                 _QuoteLine.MODIFY;
        //             end;
        //     until _QuoteLine.NEXT = 0;
        // << Upgrade

        // set document status
        //PE-300-DK.1.0 29May2024 Start
        // _QuoteHeader.NS_Status := _QuoteHeader.NS_Status::Review;
        _QuoteHeader."NS_Quote Status" := _QuoteHeader."NS_Quote Status"::Review;
        //PE-300-DK.1.0 29May2024 End
        _QuoteHeader.MODIFY;

        // send approval request

        _QuoteHeader.CALCFIELDS(NS_Amount);
        /*_DocumentApprovalMgt.NewDocumentApprovalEntry(DATABASE::"Job Quote Header"
                                                     ,_QuoteHeader."Quote No."
                                                     ,_DocumentApprovalEntry."Document Area"::Sales
                                                     ,_DocumentApprovalEntry."Document Type"::Quote
                                                     ,_QuoteHeader.Amount
                                                     ,GetEquipGrossMarginPct(_QuoteHeader)
                                                     ,_DocumentApprovalEntry.Status::Review
                                                     ,QuoteContainsInstallService(_QuoteHeader)
                                                     ,FALSE     // equipment/service approved
                                                     ,_QuoteHeader."Equipment Only"
                                                     ,'')*/

    end;

    procedure NS_ShareQuote(_QuoteHeader: Record "NS_Job Quote Header");
    var
        _QuoteHeader2: Record "NS_Job Quote Header";
        _User: Record User;
        _NewDocNo: Code[20];
        _Text000: Label 'Quote %1 was created and assigned to %2.';
    begin
        // if PAGE.RUNMODAL(PAGE::Users,_User) <> ACTION::LookupOK then
        //   exit;

        _NewDocNo := NS_DuplicateQuote(_QuoteHeader);
        _QuoteHeader2.GET(_NewDocNo);
        _QuoteHeader2."NS_Created by" := _User."User Name";
        _QuoteHeader2."NS_Salesperson/User ID" := _User."User Name";
        _QuoteHeader2.NS_Template := true;
        _QuoteHeader2.MODIFY;
        MESSAGE(_Text000, _NewDocNo, _User."User Name");
    end;

    procedure NS_ShowAttributesUsingNavQuoteNo(_NavQuoteNo: Code[20]; _LineNo: Integer);
    var
        _QuoteHeader: Record "NS_Job Quote Header";
        _QuoteLine: Record "NS_Job Quote Line";
        _AttributeMgt: Codeunit "NS_Job Quote Mgt.";
        _Text000: Label 'No attributes were found using filters: \';
        _Text001: Label '%1: %2\';
        _Text002: Label '%3: %4';
        _Text003: Label 'A matching quote line was found but the %1 was zero.';
    begin
        _QuoteHeader.SETCURRENTKEY("NS_Sales Quote No.");
        _QuoteHeader.SETRANGE("NS_Sales Quote No.", _NavQuoteNo);
        if not _QuoteHeader.FINDFIRST then
            ERROR(_Text000 + _Text001, _QuoteHeader.TABLECAPTION, _QuoteHeader.GETFILTERS);

        _QuoteLine.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        _QuoteLine.SETRANGE("NS_Sales Quote Line No.", _LineNo);
        if not _QuoteLine.FINDFIRST then
            ERROR(_Text000 + _Text001 + _Text002
                 , _QuoteHeader.TABLECAPTION
                 , _QuoteHeader.GETFILTERS
                 , _QuoteLine.TABLECAPTION
                 , _QuoteLine.GETFILTERS);

        if _QuoteLine."NS_Attribute Set Entry No." = 0 then
            ERROR(_Text003, _QuoteLine.FIELDCAPTION("NS_Attribute Set Entry No."));

        NS_SetReadOnly(true);
        NS_ShowAttributeSetEntries(_QuoteLine."NS_Attribute Set Entry No.");
    end;

    procedure NS_ShowDocDim(var _QuoteHeader: Record "NS_Job Quote Header");
    var
        _DimMgt: Codeunit DimensionManagement;
        _OldDimSetID: Integer;
    begin
        with _QuoteHeader do begin
            _OldDimSetID := "NS_Dimension Set ID";
            "NS_Dimension Set ID" :=
              _DimMgt.EditDimensionSet(
                "NS_Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "NS_Quote No."),
                "NS_Shortcut Dimension 1 Code", "NS_Shortcut Dimension 2 Code");
            if _OldDimSetID <> "NS_Dimension Set ID" then begin
                MODIFY;
                if NS_QuoteLinesExist(_QuoteHeader) then
                    NS_UpdateAllLineDim(_QuoteHeader, "NS_Dimension Set ID", _OldDimSetID);
            end;
            NS_SyncSalesQuoteHeader(_QuoteHeader);
        end;
    end;

    procedure NS_ShowDocDimForLine(var _QuoteLine: Record "NS_Job Quote Line");
    var
        _DimMgt: Codeunit DimensionManagement;
        _OldDimSetID: Integer;
    begin
        with _QuoteLine do begin
            _OldDimSetID := "NS_Dimension Set ID";
            "NS_Dimension Set ID" :=
              _DimMgt.EditDimensionSet(
                "NS_Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "NS_Quote No."),
                "NS_Shortcut Dimension 1 Code", "NS_Shortcut Dimension 2 Code");
            if _OldDimSetID <> "NS_Dimension Set ID" then begin
                MODIFY;
                NS_SyncSalesQuoteLine(_QuoteLine, false);
            end;
        end;
    end;

    procedure NS_ShowFeatureTextUsingNavQuoteNo(_NavQuoteNo: Code[20]; _LineNo: Integer);
    var
        _FeatureText: Record "NS_Job Quote Feature Text";
        _QuoteHeader: Record "NS_Job Quote Header";
        _QuoteLine: Record "NS_Job Quote Line";
        _Text000: Label 'No %1 records were found using filters: \';
        _Text001: Label '%2: %3\';
        _Text002: Label '%4: %5';
        _Text003: Label 'A matching quote line was found but no %1 records were found.';
        _FeatureTextPage: Page "NS_Job Quote Feature Text";
    begin
        _QuoteHeader.SETCURRENTKEY("NS_Sales Quote No.");
        _QuoteHeader.SETRANGE("NS_Sales Quote No.", _NavQuoteNo);
        if not _QuoteHeader.FINDFIRST then
            ERROR(_Text000 + _Text001, _QuoteHeader.TABLECAPTION, _QuoteHeader.TABLECAPTION, _QuoteHeader.GETFILTERS);

        _QuoteLine.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        _QuoteLine.SETRANGE("NS_Sales Quote Line No.", _LineNo);
        if not _QuoteLine.FINDFIRST then
            ERROR(_Text000 + _Text001 + _Text002
                 , _QuoteHeader.TABLECAPTION
                 , _QuoteHeader.GETFILTERS
                 , _QuoteLine.TABLECAPTION
                 , _QuoteLine.GETFILTERS);

        _FeatureText.FILTERGROUP := 255;
        _FeatureText.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        _FeatureText.SETRANGE("NS_Quote Line No.", _QuoteLine."NS_Quote Line No.");
        _FeatureText.FILTERGROUP := 0;
        if _FeatureText.ISEMPTY then
            ERROR(_Text003, _FeatureText.TABLECAPTION)
        else begin
            _FeatureTextPage.SETTABLEVIEW(_FeatureText);
            _FeatureTextPage.EDITABLE(false);
            _FeatureTextPage.RUN;
        end;
    end;

    procedure NS_ShowJobQuote(lQuoteHeader: Record "NS_Job Quote Header");
    var
        lJob: Record Job;
        //PRJCTPR-342.DK.1.0 Start
        DocumentAttachment: Record "Document Attachment";
        NS_DocumentAttachmentNew: Record "Document Attachment";
        LineNo: Integer;
    //PRJCTPR-342.DK.1.0 End
    begin
        if lJob.GET(lQuoteHeader."NS_Quote No.") then;
        NS_DocumentAttachmentNew.Reset();
        NS_DocumentAttachmentNew.SetRange("No.", lJob."No.");
        NS_DocumentAttachmentNew.SetRange("Table ID", 167);
        if NS_DocumentAttachmentNew.FindSet() then
            NS_DocumentAttachmentNew.DeleteAll();
        //PRJCTPR-342.DK.1.0 Start 
        DocumentAttachment.Reset();
        DocumentAttachment.SetRange("No.", lJob."No.");

        IF DocumentAttachment.FindSet() then begin
            repeat
                NS_DocumentAttachmentNew.Reset();
                NS_DocumentAttachmentNew.SetRange("No.", lJob."No.");
                NS_DocumentAttachmentNew.SetRange("Table ID", 167);
                if NS_DocumentAttachmentNew.FINDLAST then
                    LineNo := NS_DocumentAttachmentNew."Line No." + 1000
                else
                    LineNo := 1000;
                NS_DocumentAttachmentNew.init;
                NS_DocumentAttachmentNew."Table ID" := 167;
                NS_DocumentAttachmentNew."Line No." := LineNo;
                NS_DocumentAttachmentNew."No." := DocumentAttachment."No.";
                NS_DocumentAttachmentNew."Document Type" := DocumentAttachment."Document Type";
                NS_DocumentAttachmentNew.SystemRowVersion := DocumentAttachment.SystemRowVersion;
                NS_DocumentAttachmentNew.ID := DocumentAttachment.ID;
                NS_DocumentAttachmentNew."Attached Date" := DocumentAttachment."Attached Date";
                NS_DocumentAttachmentNew."Attached By" := DocumentAttachment."Attached By";
                NS_DocumentAttachmentNew."File Name" := DocumentAttachment."File Name";
                NS_DocumentAttachmentNew."File Type" := DocumentAttachment."File Type";
                NS_DocumentAttachmentNew."File Extension" := DocumentAttachment."File Extension";
                NS_DocumentAttachmentNew."Document Reference ID" := DocumentAttachment."Document Reference ID";
                NS_DocumentAttachmentNew.Insert();
            until DocumentAttachment.Next = 0;
        end;
        PAGE.RUN(PAGE::"Job Card", lJob);
    end;
    //PRJCTPR-342.DK.1.0 End
    procedure NS_ShowSalesQuote(_QuoteHeader: Record "NS_Job Quote Header");
    var
        _SalesHeader: Record "Sales Header";
    begin
        _QuoteHeader.TESTFIELD("NS_Sales Quote No.");
        _SalesHeader.GET(_SalesHeader."Document Type"::Quote, _QuoteHeader."NS_Sales Quote No.");
        PAGE.RUN(PAGE::"Sales Quote", _SalesHeader);
    end;

    procedure NS_ShowScopeOfWorkUsingNavQuoteNo(_NavQuoteNo: Code[20]; _LineNo: Integer);
    var
        _QuoteHeader: Record "NS_Job Quote Header";
        _QuoteLine: Record "NS_Job Quote Line";
        _Text000: Label 'No %1 records were found using filters: \';
        _Text001: Label '%2: %3\';
        _Text002: Label '%4: %5';
        _Text003: Label 'A matching quote line was found but no %1 records were found.';
        _ScopeOfWork: Record "NS_Job Quote Scope of Work";
        _ScopeOfWorkPage: Page "NS_Job Quote Scope of Work";
    begin
        _QuoteHeader.SETCURRENTKEY("NS_Sales Quote No.");
        _QuoteHeader.SETRANGE("NS_Sales Quote No.", _NavQuoteNo);
        if not _QuoteHeader.FINDFIRST then
            ERROR(_Text000 + _Text001, _QuoteHeader.TABLECAPTION, _QuoteHeader.TABLECAPTION, _QuoteHeader.GETFILTERS);

        _QuoteLine.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        _QuoteLine.SETRANGE("NS_Sales Quote Line No.", _LineNo);
        if not _QuoteLine.FINDFIRST then
            ERROR(_Text000 + _Text001 + _Text002
                 , _QuoteHeader.TABLECAPTION
                 , _QuoteHeader.GETFILTERS
                 , _QuoteLine.TABLECAPTION
                 , _QuoteLine.GETFILTERS);

        _ScopeOfWork.FILTERGROUP := 255;
        _ScopeOfWork.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        _ScopeOfWork.SETRANGE("NS_Quote Line No.", _QuoteLine."NS_Quote Line No.");
        _ScopeOfWork.FILTERGROUP := 0;
        if _ScopeOfWork.ISEMPTY then
            ERROR(_Text003, _ScopeOfWork.TABLECAPTION)
        else begin
            _ScopeOfWorkPage.SETTABLEVIEW(_ScopeOfWork);
            _ScopeOfWorkPage.EDITABLE(false);
            _ScopeOfWorkPage.RUN;
        end;
    end;

    procedure NS_SyncSalesQuoteHeader(_QuoteHeader: Record "NS_Job Quote Header");
    var
        _Address: Record "Ship-to Address";
        _Customer: Record Customer;
        //_CustomerTemplate: Record "Customer Template";  //PRJCTPR-155.JS.1.0 line commented
        _CustomerTemplate: Record "Customer Templ.";  //PRJCTPR-155.JS.1.0 line added
        _SalesHeader: Record "Sales Header";
        _DimMgt: Codeunit DimensionManagement;
        _ReleaseSalesDoc: Codeunit "Release Sales Document";
        _NewDimSetID: Integer;
    begin
        if _QuoteHeader."NS_Sales Quote No." = '' then
            exit;
        if not _SalesHeader.GET(_SalesHeader."Document Type"::Quote, _QuoteHeader."NS_Sales Quote No.") then
            exit;
        if _SalesHeader.Status <> _SalesHeader.Status::Open then begin
            CLEAR(_ReleaseSalesDoc);
            //_ReleaseSalesDoc.SetHideValidationDialog(TRUE);
            _ReleaseSalesDoc.Reopen(_SalesHeader);
            _SalesHeader.GET(_SalesHeader."Document Type"::Quote, _QuoteHeader."NS_Sales Quote No.");
        end;

        _SalesHeader.SetHideValidationDialog(true);
        if _QuoteHeader."NS_Sell-to Customer No." <> '' then begin
            if _SalesHeader."Sell-to Customer No." <> _QuoteHeader."NS_Sell-to Customer No." then
                _SalesHeader.VALIDATE("Sell-to Customer No.", _QuoteHeader."NS_Sell-to Customer No.");
            if _QuoteHeader."NS_Bill-to Customer No." <> _QuoteHeader."NS_Sell-to Customer No." then
                if _SalesHeader."Bill-to Customer No." <> _QuoteHeader."NS_Bill-to Customer No." then
                    _SalesHeader.VALIDATE("Bill-to Customer No.", _QuoteHeader."NS_Bill-to Customer No.");
        end;
        //if _SalesHeader."Salesperson Code" <> _QuoteHeader."NS_Salesperson Code" then//PRJ-867.AS.1.0 23SEPT2021 Comment
        //    _SalesHeader.VALIDATE("Salesperson Code", _QuoteHeader."NS_Salesperson Code");//PRJ-867.AS.1.0 23SEPT2021 Comment

        if _SalesHeader."Salesperson Code" <> _QuoteHeader."NS_Salesperson Code New" then//PRJ-867.AS.1.0 23SEPT2021 Changed field Sales Person code to Sales person code New
            _SalesHeader.VALIDATE("Salesperson Code", _QuoteHeader."NS_Salesperson Code New");//PRJ-867.AS.1.0 23SEPT2021 Changed field Sales Person code to Sales person code New

        if (_QuoteHeader."NS_Sell-to Customer No." = '') and (_QuoteHeader."NS_Bill-to Customer No." = '') then
            if _CustomerTemplate.FINDFIRST then
                // _SalesHeader."Sell-to Customer Template Code" := _CustomerTemplate.Code;//PRJ-1620.AS.1.0 COMMENTED As per V21 Validations not allowing
        _SalesHeader."Sell-to Customer Templ. Code" := _CustomerTemplate.Code;//PRJ-1620.AS.1.0 Added/Replaced As per V21 Validations
        if _QuoteHeader."NS_Contact No." <> '' then
            if _SalesHeader."Sell-to Contact No." <> _QuoteHeader."NS_Contact No." then
                _SalesHeader.VALIDATE("Sell-to Contact No.", _QuoteHeader."NS_Contact No.");

        if _SalesHeader."Payment Terms Code" <> _QuoteHeader."NS_Payment Terms Code" then
            _SalesHeader.VALIDATE("Payment Terms Code", _QuoteHeader."NS_Payment Terms Code");
        if _SalesHeader."Shipment Method Code" <> _QuoteHeader."NS_Shipment Method Code" then
            _SalesHeader."Shipment Method Code" := _QuoteHeader."NS_Shipment Method Code";
        _SalesHeader."Your Reference" := _QuoteHeader."NS_External Document No.";
        _SalesHeader."External Document No." := _QuoteHeader."NS_External Document No.";
        _NewDimSetID := _DimMgt.GetDeltaDimSetID(_SalesHeader."Dimension Set ID"
                                                , _QuoteHeader."NS_Dimension Set ID"
                                                , _SalesHeader."Dimension Set ID");
        if _NewDimSetID <> _SalesHeader."Dimension Set ID" then begin
            _SalesHeader."Dimension Set ID" := _NewDimSetID;
            _DimMgt.UpdateGlobalDimFromDimSetID(_SalesHeader."Dimension Set ID"
                                               , _SalesHeader."Shortcut Dimension 1 Code"
                                               , _SalesHeader."Shortcut Dimension 2 Code");
        end;
        // update addresses
        _Address.SETRANGE("NS_Table ID", DATABASE::"NS_Job Quote Header");
        _Address.SETRANGE("NS_No.", _QuoteHeader."NS_Quote No.");
        _Address.SETRANGE("NS_Address Type", _Address."NS_Address Type"::"Sell-to");
        if _Address.FINDFIRST then begin
            _SalesHeader."Sell-to Customer Name" := _Address.Name;
            _SalesHeader."Sell-to Customer Name 2" := _Address."Name 2";
            _SalesHeader."Sell-to Address" := _Address.Address;
            _SalesHeader."Sell-to Address 2" := _Address."Address 2";
            _SalesHeader."Sell-to City" := _Address.City;
            _SalesHeader."Sell-to County" := _Address.County;
            _SalesHeader."Sell-to Post Code" := _Address."Post Code";
            _SalesHeader."Sell-to Country/Region Code" := _Address."Country/Region Code";
            _SalesHeader."Sell-to Contact" := _Address.Contact;
        end;
        _Address.SETRANGE("NS_Address Type", _Address."NS_Address Type"::"Bill-to");
        if _Address.FINDFIRST then begin
            _SalesHeader."Bill-to Name" := _Address.Name;
            _SalesHeader."Bill-to Name 2" := _Address."Name 2";
            _SalesHeader."Bill-to Address" := _Address.Address;
            _SalesHeader."Bill-to Address 2" := _Address."Address 2";
            _SalesHeader."Bill-to City" := _Address.City;
            _SalesHeader."Bill-to County" := _Address.County;
            _SalesHeader."Bill-to Post Code" := _Address."Post Code";
            _SalesHeader."Bill-to Country/Region Code" := _Address."Country/Region Code";
            _SalesHeader."Bill-to Contact" := _Address.Contact;
        end;
        _Address.SETRANGE("NS_Address Type", _Address."NS_Address Type"::"Ship-to");
        if _Address.FINDFIRST then begin
            _SalesHeader."Ship-to Code" := '';
            _SalesHeader."Ship-to Name" := _Address.Name;
            _SalesHeader."Ship-to Address" := _Address.Address;
            _SalesHeader."Ship-to Address 2" := _Address."Address 2";
            _SalesHeader."Ship-to City" := _Address.City;
            _SalesHeader."Ship-to County" := _Address.County;
            _SalesHeader."Ship-to Post Code" := _Address."Post Code";
            _SalesHeader."Ship-to Country/Region Code" := _Address."Country/Region Code";
            _SalesHeader."Ship-to Contact" := _Address.Contact;
        end;

        if _Customer.GET(_QuoteHeader."NS_Sell-to Customer No.") then begin
            _SalesHeader."Sell-to Customer Name" := _Customer.Name;
            _SalesHeader."Sell-to Customer Name 2" := _Customer."Name 2";
            _SalesHeader."Sell-to Address" := _Customer.Address;
            _SalesHeader."Sell-to Address 2" := _Customer."Address 2";
            _SalesHeader."Sell-to City" := _Customer.City;
            _SalesHeader."Sell-to County" := _Customer.County;
            _SalesHeader."Sell-to Post Code" := _Customer."Post Code";
            _SalesHeader."Sell-to Country/Region Code" := _Customer."Country/Region Code";
            _SalesHeader."Sell-to Contact" := _Customer.Contact;
            if _Address.ISEMPTY then begin  // do not override if they have selected a ship-to address
                _SalesHeader."Ship-to Name" := _Customer.Name;
                _SalesHeader."Ship-to Name 2" := _Customer."Name 2";
                _SalesHeader."Ship-to Address" := _Customer.Address;
                _SalesHeader."Ship-to Address 2" := _Customer."Address 2";
                _SalesHeader."Ship-to City" := _Customer.City;
                _SalesHeader."Ship-to County" := _Customer.County;
                _SalesHeader."Ship-to Post Code" := _Customer."Post Code";
                _SalesHeader."Ship-to Country/Region Code" := _Customer."Country/Region Code";
                _SalesHeader."Ship-to Contact" := _Customer.Contact;
            end;
        end;
        if _Customer.GET(_QuoteHeader."NS_Bill-to Customer No.") then begin
            _SalesHeader."Bill-to Name" := _Customer.Name;
            _SalesHeader."Bill-to Name 2" := _Customer."Name 2";
            _SalesHeader."Bill-to Address" := _Customer.Address;
            _SalesHeader."Bill-to Address 2" := _Customer."Address 2";
            _SalesHeader."Bill-to City" := _Customer.City;
            _SalesHeader."Bill-to County" := _Customer.County;
            _SalesHeader."Bill-to Post Code" := _Customer."Post Code";
            _SalesHeader."Bill-to Country/Region Code" := _Customer."Country/Region Code";
            _SalesHeader."Bill-to Contact" := _Customer.Contact;
        end;

        if _QuoteHeader."NS_Use Tax Liable" = _QuoteHeader."NS_Use Tax Liable"::Yes then begin
            _SalesHeader."Tax Liable" := false;
            //_SalesHeader."STO Enable" := FALSE;
        end;

        if _SalesHeader."Location Code" <> _QuoteHeader."NS_Location Code" then
            _SalesHeader.VALIDATE("Location Code", _QuoteHeader."NS_Location Code");

        _SalesHeader."NS_Free Freight" := _QuoteHeader."NS_Free Freight";

        if _SalesHeader."Shipping Advice".AsInteger() <> _QuoteHeader."NS_Shipping Advice" then
            _SalesHeader.VALIDATE("Shipping Advice", _QuoteHeader."NS_Shipping Advice");


        if _QuoteHeader."NS_Requested Delivery Date" <> 0D then
            if _SalesHeader."Requested Delivery Date" <> _QuoteHeader."NS_Requested Delivery Date" then
                _SalesHeader."Requested Delivery Date" := _QuoteHeader."NS_Requested Delivery Date";

        _SalesHeader.MODIFY(true);
    end;

    procedure NS_SyncSalesQuoteLine(var _QuoteLine: Record "NS_Job Quote Line"; _OverrideUnitPrice: Boolean);
    var
        _QuoteHeader: Record "NS_Job Quote Header";
        _QuoteLine2: Record "NS_Job Quote Line";
        _SalesHeader: Record "Sales Header";
        _SalesLine: Record "Sales Line";
        _DimMgt: Codeunit DimensionManagement;
        _NewDimSetID: Integer;
    begin
        if _SalesLine.GET(_SalesLine."Document Type"::Quote, _QuoteLine."NS_Sales Quote No.", _QuoteLine."NS_Quote Line No.") then begin
            _NewDimSetID := _DimMgt.GetDeltaDimSetID(_SalesLine."Dimension Set ID"
                                                    , _QuoteLine."NS_Dimension Set ID"
                                                    , _SalesLine."Dimension Set ID");
            if ((_SalesLine."No." = _QuoteLine."NS_No.") and
               (_SalesLine."Variant Code" = _QuoteLine."NS_Variant Code") and
               (_SalesLine.Description = _QuoteLine.NS_Description) and
               (_SalesLine.Quantity = _QuoteLine.NS_Quantity) and
               (_SalesLine."Unit Price" = _QuoteLine."NS_Total Price") and
               (_SalesLine."Line Discount Amount" = _QuoteLine."NS_Line Discount Amount") and
               (_SalesLine."Unit of Measure Code" = _QuoteLine."NS_Unit of Measure Code") and
               (_SalesLine."Location Code" = _QuoteLine."NS_Location Code") and
               (_NewDimSetID = _SalesLine."Dimension Set ID") and
               (_SalesLine."Tax Area Code" = _QuoteLine."NS_Tax Area Code") and
               (_SalesLine."Tax Liable" = _QuoteLine."NS_Tax Liable"))
            then
                exit;
        end;

        if (_QuoteLine.NS_Type = _QuoteLine.NS_Type::Task) or (_QuoteLine.NS_Type = _QuoteLine.NS_Type::Template) then
            exit;

        // ensure sales quote exists

        if _QuoteLine."NS_Sales Quote No." = '' then begin
            _QuoteHeader.GET(_QuoteLine."NS_Quote No.");
            NS_CreateSalesQuoteHeader(_QuoteHeader);
            _QuoteHeader.MODIFY;
            NS_SyncSalesQuoteHeader(_QuoteHeader);  // initialize sell-to, bill-to customer nos.
            _QuoteLine."NS_Sales Quote No." := _QuoteHeader."NS_Sales Quote No.";
        end;

        NS_GetQuoteHeaderC50000(_QuoteLine);
        if not _SalesHeader.GET(_SalesHeader."Document Type"::Quote, _QuoteLine."NS_Sales Quote No.") then
            _SalesHeader.INIT;

        // verify tax area code exists on header if populated on any of the lines

        _QuoteLine2.SETRANGE("NS_Quote No.", _QuoteLine."NS_Quote No.");
        _QuoteLine2.SETFILTER("NS_Tax Area Code", '<>%1', '');
        if _QuoteLine2.FINDFIRST then
            if _SalesHeader.GET(_SalesHeader."Document Type"::Quote, _QuoteLine."NS_Sales Quote No.") then
                if _SalesHeader."Tax Area Code" = '' then begin
                    _SalesHeader.SetHideValidationDialog(true);
                    _SalesHeader.VALIDATE("Tax Area Code", _QuoteLine2."NS_Tax Area Code");
                    _SalesHeader.VALIDATE("Tax Liable", true);
                    _SalesHeader.MODIFY;
                end;

        if not _SalesLine.GET(_SalesLine."Document Type"::Quote
                             , _QuoteLine."NS_Sales Quote No."
                             , _QuoteLine."NS_Quote Line No.")
        then begin
            _SalesLine.INIT;
            _SalesLine."Document Type" := _SalesLine."Document Type"::Quote;
            _SalesLine."Document No." := _QuoteLine."NS_Sales Quote No.";
            _SalesLine."Line No." := _QuoteLine."NS_Quote Line No.";
            _SalesLine.INSERT(true);
        end;
        _SalesLine.SetHideValidationDialog(true);
        case _QuoteLine.NS_Type of
            _QuoteLine.NS_Type::Item:
                _SalesLine.VALIDATE(Type, _SalesLine.Type::Item);
            _QuoteLine.NS_Type::Resource:
                _SalesLine.VALIDATE(Type, _SalesLine.Type::Resource);
            _QuoteLine.NS_Type::"G/L Account":
                _SalesLine.VALIDATE(Type, _SalesLine.Type::"G/L Account");
            _QuoteLine.NS_Type::" ":
                _SalesLine.VALIDATE(Type, _SalesLine.Type::" ");
        end;
        _SalesLine.VALIDATE("No.", _QuoteLine."NS_No.");
        if _QuoteLine."NS_Variant Code" <> '' then
            _SalesLine.VALIDATE("Variant Code", _QuoteLine."NS_Variant Code");
        if _QuoteLine."NS_Unit of Measure Code" <> '' then
            _SalesLine.VALIDATE("Unit of Measure Code", _QuoteLine."NS_Unit of Measure Code");
        if _QuoteLine.NS_Quantity <> 0 then
            _SalesLine.VALIDATE(Quantity, _QuoteLine.NS_Quantity);
        if _OverrideUnitPrice then
            _SalesLine.VALIDATE("Unit Price", _QuoteLine."NS_Total Price");
        _SalesLine.Description := _QuoteLine.NS_Description;
        if _QuoteLine.NS_Type <> _QuoteLine.NS_Type::" " then begin
            if _QuoteLine."NS_Line Discount Amount" <> 0 then
                _SalesLine.VALIDATE("Line Discount Amount", _QuoteLine."NS_Line Discount Amount");
            if _QuoteLine."NS_Location Code" <> '' then
                _SalesLine.VALIDATE("Location Code", _QuoteLine."NS_Location Code");
            if QuoteHeader."NS_Use Tax Liable" = QuoteHeader."NS_Use Tax Liable"::Yes then
                _SalesLine."Tax Liable" := false
            else begin
                _SalesLine.VALIDATE("Tax Area Code", _SalesHeader."Tax Area Code");
                _SalesLine.VALIDATE("Tax Liable", _SalesHeader."Tax Liable");
            end;
            _NewDimSetID := _DimMgt.GetDeltaDimSetID(_SalesLine."Dimension Set ID"
                                                    , _QuoteLine."NS_Dimension Set ID"
                                                    , _SalesLine."Dimension Set ID");
            if _NewDimSetID <> _SalesLine."Dimension Set ID" then begin
                _SalesLine."Dimension Set ID" := _NewDimSetID;
                _DimMgt.UpdateGlobalDimFromDimSetID(_SalesLine."Dimension Set ID"
                                                   , _SalesLine."Shortcut Dimension 1 Code"
                                                   , _SalesLine."Shortcut Dimension 2 Code");
            end;
        end;
        _SalesLine.MODIFY(true);

        if _QuoteLine."NS_Sales Quote Line No." <> _SalesLine."Line No." then
            _QuoteLine."NS_Sales Quote Line No." := _SalesLine."Line No.";
    end;

    procedure NS_SyncSalesQuoteLines(_QuoteHeader: Record "NS_Job Quote Header");
    var
        _QuoteLine: Record "NS_Job Quote Line";
        _SalesLine: Record "Sales Line";
    begin
        _SalesLine.SETRANGE("Document Type", _SalesLine."Document Type"::Quote);
        _SalesLine.SETRANGE("Document No.", _QuoteHeader."NS_Sales Quote No.");
        _SalesLine.DELETEALL;
        _SalesLine.SetHideValidationDialog(true);

        _QuoteLine.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        if _QuoteLine.FINDSET(false) then
            repeat
                NS_SyncSalesQuoteLine(_QuoteLine, true);
                _QuoteLine.MODIFY;
            until _QuoteLine.NEXT = 0;
    end;

    procedure NS_TestFieldsRequiredForConversion(_QuoteHeader: Record "NS_Job Quote Header");
    begin
        with _QuoteHeader do begin
            TESTFIELD("NS_Requested Delivery Date");
            TESTFIELD("NS_Location Code");
            TESTFIELD("NS_Shipment Method Code");
        end;
    end;

    procedure NS_TestStatusChange(_SalesHeader: Record "Sales Header");
    var
        _Text000: Label 'Sales %1 %2 is associated with Quote %3 ... the requested change is not permitted.';
        _QuoteHeader: Record "NS_Job Quote Header";
    begin
        if _SalesHeader."Document Type" <> _SalesHeader."Document Type"::Quote then
            exit;

        _QuoteHeader.SETCURRENTKEY("NS_Sales Quote No.");
        _QuoteHeader.SETRANGE("NS_Sales Quote No.", _SalesHeader."No.");
        if _QuoteHeader.FINDFIRST then
            ERROR(_Text000
                 , FORMAT(_SalesHeader."Document Type")
                 , _SalesHeader."No."
                 , _QuoteHeader."NS_Quote No.");
    end;

    local procedure NS_UpdateAllLineDim(var _QuoteHeader: Record "NS_Job Quote Header"; _NewParentDimSetID: Integer; _OldParentDimSetID: Integer);
    var
        _QuoteLine: Record "NS_Job Quote Line";
        _DimMgt: Codeunit DimensionManagement;
        _QuoteLineOldDimSetID: Integer;
        _NewDimSetID: Integer;
        Text000: Label 'You may have changed a dimension.\\Do you want to update the lines?';
    begin
        // Update all lines with changed dimensions.

        if _NewParentDimSetID = _OldParentDimSetID then
            exit;
        if GUIALLOWED then
            if not CONFIRM(Text000) then
                exit;

        with _QuoteHeader do begin
            _QuoteLine.SETRANGE("NS_Quote No.", "NS_Quote No.");
            _QuoteLine.LOCKTABLE;
            if _QuoteLine.FIND('-') then
                repeat
                    _NewDimSetID := _DimMgt.GetDeltaDimSetID(_QuoteLine."NS_Dimension Set ID", _NewParentDimSetID, _OldParentDimSetID);
                    if _QuoteLine."NS_Dimension Set ID" <> _NewDimSetID then begin
                        _QuoteLineOldDimSetID := _QuoteLine."NS_Dimension Set ID";
                        _QuoteLine."NS_Dimension Set ID" := _NewDimSetID;
                        _DimMgt.UpdateGlobalDimFromDimSetID(
                          _QuoteLine."NS_Dimension Set ID", _QuoteLine."NS_Shortcut Dimension 1 Code", _QuoteLine."NS_Shortcut Dimension 2 Code");
                        _QuoteLine.MODIFY;
                        NS_SyncSalesQuoteLine(_QuoteLine, false);
                    end;
                until _QuoteLine.NEXT = 0;
        end;
    end;

    procedure NS_VerifyUseTaxEligibility(var _QuoteHeader: Record "NS_Job Quote Header"; _Transaction: Boolean);
    var
        _Text000: Label 'Eligibility for Use Tax has not been determined.';
        _Prompt: Boolean;
        _UseTaxQuestionnaire: Page "NS_JobQuoteUseTaxQuestionnaire";
        _Text001: Label '"  Please open the %1."';
        _Text002: Label '"  Would you like to open the %1 now?"';
        _Text003: Label 'Required fields for Use Tax have not been completed.';
    begin
        if _QuoteHeader."NS_Equipment Only" then
            exit;

        if _QuoteHeader."NS_Use Tax Liable" = _QuoteHeader."NS_Use Tax Liable"::" " then
            if _Transaction then
                ERROR(_Text000 + _Text001, _UseTaxQuestionnaire.CAPTION)
            else
                _Prompt := true;

        with _QuoteHeader do
            if (_QuoteHeader."NS_Use Tax- Contractor Status" = _QuoteHeader."NS_Use Tax- Contractor Status"::" ") or
               (_QuoteHeader."NS_Use Tax- Contract Type" = _QuoteHeader."NS_Use Tax- Contract Type"::" ") or
               (_QuoteHeader."NS_Use Tax- Property Type" = _QuoteHeader."NS_Use Tax- Property Type"::" ") or
               (_QuoteHeader."NS_Use Tax- Project Type" = _QuoteHeader."NS_Use Tax- Project Type"::" ") or
               (_QuoteHeader."NS_Use Tax- DownstrContStatus" = _QuoteHeader."NS_Use Tax- DownstrContStatus"::" ") or
               (_QuoteHeader."NS_Use Tax- Charge Type" = _QuoteHeader."NS_Use Tax- Charge Type"::" ") or
               (_QuoteHeader."NS_Use Tax- ChargeType Detail" = _QuoteHeader."NS_Use Tax- ChargeType Detail"::" ") or
               (_QuoteHeader."NS_Use Tax-PotentProjExempt." = _QuoteHeader."NS_Use Tax-PotentProjExempt."::"Not Applicable")
            then
                if _Transaction then
                    ERROR(_Text003 + _Text001, _UseTaxQuestionnaire.CAPTION)
                else
                    _Prompt := true;

        if _Prompt then
            if CONFIRM(_Text000 + _Text002, true, _UseTaxQuestionnaire.CAPTION) then begin
                NS_OpenUseTaxQuestionnaire(_QuoteHeader);
                _QuoteHeader.GET(_QuoteHeader."NS_Quote No.");
            end;
    end;

    procedure NS_ValidateNo2OnQuoteLine(var _QuoteLine: Record "NS_Job Quote Line");
    var
        _Item: Record Item;
    begin
        if _QuoteLine."NS_No. 2" = '' then begin
            _QuoteLine."NS_No." := '';
            exit;
        end;

        _QuoteLine.TESTFIELD(NS_Type, _QuoteLine.NS_Type::Item);

        _Item.SETCURRENTKEY("No. 2");
        _Item.SETRANGE("No. 2", _QuoteLine."NS_No. 2");
        if _Item.FINDFIRST then begin
            _QuoteLine."NS_No." := _Item."No.";
            exit;
        end;

        _Item.SETFILTER("No. 2", STRSUBSTNO('%1*', _QuoteLine."NS_No. 2"));
        if _Item.FINDFIRST then begin
            _QuoteLine."NS_No." := _Item."No.";
            exit;
        end;

        _Item.SETRANGE("No. 2", _QuoteLine."NS_No. 2");
        _Item.FINDFIRST;
    end;

    procedure NS_ValidateNo2OnSalesLine(var _SalesLine: Record "Sales Line");
    var
        _Item: Record Item;
    begin
        if _SalesLine."NS_No. 2" = '' then begin
            _SalesLine.VALIDATE("No.", '');
            exit;
        end;

        _SalesLine.TESTFIELD(Type, _SalesLine.Type::Item.AsInteger());

        _Item.SETCURRENTKEY("No. 2");
        _Item.SETRANGE("No. 2", _SalesLine."NS_No. 2");
        if _Item.FINDFIRST then begin
            _SalesLine.VALIDATE("No.", _Item."No.");
            exit;
        end;

        _Item.SETFILTER("No. 2", STRSUBSTNO('%1*', _SalesLine."NS_No. 2"));
        if _Item.FINDFIRST then begin
            _SalesLine.VALIDATE("No.", _Item."No.");
            exit;
        end;

        _Item.SETRANGE("No. 2", _SalesLine."NS_No. 2");
        _Item.FINDFIRST;
    end;

    procedure NS_ValidateShortcutDimCode(var _QuoteHeader: Record "NS_Job Quote Header"; _FieldNumber: Integer; var _ShortcutDimCode: Code[20]);
    var
        _DimMgt: Codeunit DimensionManagement;
        _OldDimSetID: Integer;
    begin
        with _QuoteHeader do begin
            _OldDimSetID := "NS_Dimension Set ID";
            _DimMgt.ValidateShortcutDimValues(_FieldNumber, _ShortcutDimCode, "NS_Dimension Set ID");
            if "NS_Quote No." <> '' then
                MODIFY;

            if _OldDimSetID <> "NS_Dimension Set ID" then begin
                MODIFY;
                if NS_QuoteLinesExist(_QuoteHeader) then
                    NS_UpdateAllLineDim(_QuoteHeader, "NS_Dimension Set ID", _OldDimSetID);
            end;
        end;

        NS_SyncSalesQuoteHeader(_QuoteHeader);
    end;

    procedure NS_ValidateShortcutDimCodeForLine(var _QuoteLine: Record "NS_Job Quote Line"; _FieldNumber: Integer; var _ShortcutDimCode: Code[20]);
    var
        _DimMgt: Codeunit DimensionManagement;
        _OldDimSetID: Integer;
    begin
        with _QuoteLine do begin
            _OldDimSetID := "NS_Dimension Set ID";
            _DimMgt.ValidateShortcutDimValues(_FieldNumber, _ShortcutDimCode, "NS_Dimension Set ID");
            if "NS_Quote No." <> '' then
                MODIFY;

            if _OldDimSetID <> "NS_Dimension Set ID" then
                MODIFY;
        end;
    end;

    procedure NS_ZeroUnitPrice(var _QuoteLine: Record "NS_Job Quote Line");
    begin
        with _QuoteLine do begin
            "NS_Unit Price" := 0;
            "NS_Contract Price Found" := false;
            "NS_Total Price" := 0;
            "NS_Use Tax SKU" := '';
            "NS_Use Tax Amount" := 0;
            "NS_Sales Tax Amount" := 0;
            NS_Amount := 0;
            "NS_Amount Including VAT" := 0;
            "NS_Line Discount Amount" := 0;
            "NS_Line Discount %" := 0;
            "NS_Gross Margin %" := 0;
            "NS_Gross Margin" := 0;
        end;
    end;

    procedure GetSubtotals(QuoteHeader2: Record "NS_Job Quote Header"; TotalType: Integer): Decimal;
    var
        QuoteLine: Record "NS_Job Quote Line";
        Amt: Decimal;
    begin
        Amt := 0;
        QuoteLine.RESET;
        QuoteLine.SETCURRENTKEY("NS_Category Code", "NS_No.");
        QuoteLine.SETRANGE("NS_Quote No.", QuoteHeader2."NS_Quote No.");
        case TotalType of
            1:
                // Freight
                begin
                    QuoteLine.SETRANGE(NS_Type, QuoteLine.NS_Type::Resource);
                    QuoteLine.SETRANGE("NS_No.", 'FREIGHT');
                end;
            2:
                // Equipment Subtotal
                begin
                    QuoteLine.SETFILTER(NS_Type, '%1|%2', QuoteLine.NS_Type::Resource, QuoteLine.NS_Type::Item);
                    QuoteLine.SETFILTER("NS_Category Code", '%1..%2', '21000', '38000');
                    QuoteLine.SETFILTER("NS_No.", '<>%1', 'FREIGHT');
                end;
            3:
                // Installation Subtotal
                begin
                    QuoteLine.SETFILTER(NS_Type, '%1|%2', QuoteLine.NS_Type::Resource, QuoteLine.NS_Type::Item);
                    QuoteLine.SETRANGE("NS_Category Code", '51000');

                end;
            4:
                // Bond Subtotal
                begin
                    QuoteLine.SETFILTER(NS_Type, '%1|%2', QuoteLine.NS_Type::Resource, QuoteLine.NS_Type::Item);
                    QuoteLine.SETRANGE("NS_Category Code", '59000');
                end;
            5:
                // Service Subtotal
                begin
                    QuoteLine.SETFILTER(NS_Type, '%1|%2', QuoteLine.NS_Type::Resource, QuoteLine.NS_Type::"G/L Account");
                    QuoteLine.SETRANGE("NS_Category Code", '61000');
                end;
        end;
        if QuoteLine.FINDSET then
            repeat
                Amt += QuoteLine.NS_Amount;
            until QuoteLine.NEXT = 0;
        exit(Amt);
    end;

    local procedure "--- Address Management --"();
    begin
    end;

    procedure NS_CopyContactAddress(_QuoteHeader: Record "NS_Job Quote Header");
    var
        _Address: Record "Ship-to Address";
        _Contact: Record Contact;
    begin
        if _QuoteHeader."NS_Contact No." = '' then
            exit;

        if not _Contact.GET(_QuoteHeader."NS_Contact No.") then
            exit;

        // ensure contact address exists as job site address for bid

        with _Address do begin
            INIT;
            "NS_Table ID" := DATABASE::"NS_Job Quote Header";
            "NS_No." := _QuoteHeader."NS_Quote No.";
            "NS_Contact No." := _Contact."No.";
            TRANSFERFIELDS(_Contact, false);
            "Customer No." := _QuoteHeader."NS_Sell-to Customer No.";
            Name := _Contact.Name;
            "NS_Contact No." := _Contact."No.";
            if INSERT(true) then;
        end;
    end;

    procedure NS_CopyCustomerAddress(var _QuoteHeader: Record "NS_Job Quote Header"; _CustomerNo: Code[20]);
    var
        _Address: Record "Ship-to Address";
        _Customer: Record Customer;
        _ShipToAddress: Record "Ship-to Address";
    begin
        if not _Customer.GET(_CustomerNo) then
            exit;

        // ensure customer address exists as job site address for bid

        with _Address do begin
            INIT;
            "NS_Table ID" := DATABASE::"NS_Job Quote Header";
            "NS_No." := _QuoteHeader."NS_Quote No.";
            if _CustomerNo = _QuoteHeader."NS_Sell-to Customer No." then begin
                "NS_Address Type" := "NS_Address Type"::"Sell-to";
                "Address 2" := COPYSTR(_QuoteHeader."NS_Sell-to Customer No." + ' SITE', 1, MAXSTRLEN("Address 2"));
            end else
                if _CustomerNo = _QuoteHeader."NS_Bill-to Customer No." then begin
                    "NS_Address Type" := "NS_Address Type"::"Bill-to";
                    "Address 2" := COPYSTR(_QuoteHeader."NS_Bill-to Customer No." + ' BILL', 1, MAXSTRLEN("Address 2"));
                end else
                    "Address 2" := _Customer."No.";
            TRANSFERFIELDS(_Customer, false); //*
            Name := _Customer.Name;
            "Customer No." := _Customer."No.";
        end;

        // copy all ship-to addresses for bid

        _ShipToAddress.SETRANGE("Customer No.", _CustomerNo);
        if _ShipToAddress.FINDSET(false) then
            repeat
                with _Address do begin
                    INIT;
                    "NS_Table ID" := DATABASE::"NS_Job Quote Header";
                    "NS_No." := _QuoteHeader."NS_Quote No.";
                    Code := _ShipToAddress.Code;
                    TRANSFERFIELDS(_ShipToAddress, false);
                    "Customer No." := _ShipToAddress."Customer No.";
                    if INSERT(true) then;
                end;
            until _ShipToAddress.NEXT = 0
        else
            with _Address do begin
                RESET;
                SETRANGE("NS_Table ID", DATABASE::"NS_Job Quote Header");
                SETRANGE("NS_No.", _QuoteHeader."NS_Quote No.");
                SETRANGE("NS_Address Type", "NS_Address Type"::"Ship-to");
                if ISEMPTY then begin
                    SETRANGE("NS_Address Type", "NS_Address Type"::"Sell-to");
                    if FINDFIRST then begin
                        "Address 2" := COPYSTR(_CustomerNo + ' SHIP', 1, MAXSTRLEN("Address 2"));
                        "Customer No." := _CustomerNo;
                        if INSERT(true) then;
                    end;
                end;
            end;
    end;

    local procedure "-- Attribute Management --"();
    begin
    end;

    procedure NS_CopyAttributesForQuoteLine(var _QuoteLine: Record "NS_Job Quote Line");
    var
        _AttributeSetEntry: Record "NS_Job Quote Attribute Set Ent";
        _DefaultAttribute: Record "NS_Job Quote Default Attribute";
        _EntryNo: Integer;
    begin
        if _QuoteLine."NS_Attribute Set Entry No." <> 0 then
            exit;

        case _QuoteLine.NS_Type of
            _QuoteLine.NS_Type::"G/L Account":
                _DefaultAttribute.SETRANGE("NS_Table ID", DATABASE::"G/L Account");
            _QuoteLine.NS_Type::Item:
                _DefaultAttribute.SETRANGE("NS_Table ID", DATABASE::Item);
            _QuoteLine.NS_Type::Resource:
                _DefaultAttribute.SETRANGE("NS_Table ID", DATABASE::Resource);
        end;
        _DefaultAttribute.SETRANGE("NS_No.", _QuoteLine."NS_No.");
        if _DefaultAttribute.ISEMPTY then
            exit;

        _EntryNo := NS_GetNextAttributeSetEntryNo;
        if _DefaultAttribute.FINDSET(false) then
            repeat
                with _AttributeSetEntry do begin
                    INIT;
                    TRANSFERFIELDS(_DefaultAttribute, false);
                    "NS_Attribute Set ID" := _EntryNo;
                    "NS_Attribute Code" := _DefaultAttribute."NS_Attribute Code";
                    INSERT;
                end;
            until _DefaultAttribute.NEXT = 0;

        _QuoteLine."NS_Attribute Set Entry No." := _EntryNo;
        _QuoteLine.MODIFY;
    end;

    procedure NS_DuplicateAttributeSet(_AttributeSetEntryNo: Integer): Integer;
    var
        _AttributeSetEntry: Record "NS_Job Quote Attribute Set Ent";
        _AttributeSetEntry2: Record "NS_Job Quote Attribute Set Ent";
        _NextEntryNo: Integer;
    begin
        if _AttributeSetEntryNo = 0 then
            exit(0);

        _AttributeSetEntry.SETRANGE("NS_Attribute Set ID", _AttributeSetEntryNo);
        if not _AttributeSetEntry.FINDSET(false) then
            exit(0);

        _NextEntryNo := NS_GetNextAttributeSetEntryNo;
        repeat
            _AttributeSetEntry2 := _AttributeSetEntry;
            _AttributeSetEntry2."NS_Attribute Set ID" := _NextEntryNo;
            _AttributeSetEntry2.INSERT(true);
        until _AttributeSetEntry.NEXT = 0;

        exit(_NextEntryNo);
    end;

    procedure NS_GetNextAttributeSetEntryNo() _EntryNo: Integer;
    var
        _QuoteSetup: Record "Jobs Setup";
        _NoSeries: Record "No. Series";
        _NoSeriesMgt: Codeunit NoSeriesManagement;
        _NextNo: Code[20];
        _Text000: Label 'The system was unable to utilize the next number from the %1 %2 for the set of Attribute Set Entries.';
    begin
        _QuoteSetup.GET;
        _QuoteSetup.TESTFIELD("NS_Job Attribute No. Series");
        _NoSeries.GET(_QuoteSetup."NS_Job Attribute No. Series");
        _NoSeries.TESTFIELD("Default Nos.");
        _NoSeries.TESTFIELD("Manual Nos.", false);
        _NextNo := _NoSeriesMgt.GetNextNo(_QuoteSetup."NS_Job Attribute No. Series", WORKDATE, true);
        _NextNo := DELCHR(_NextNo, '=', DELCHR(_NextNo, '=', '0123456789'));
        if not EVALUATE(_EntryNo, _NextNo) then
            ERROR(_Text000, _NoSeries.TABLECAPTION, _QuoteSetup."NS_Job Attribute No. Series");
    end;

    procedure NS_OnInsertAttributeSetEntry(var _AttributeSetEntry: Record "NS_Job Quote Attribute Set Ent");
    var
        _Attribute: Record "NS_Job Quote Attribute";
    begin
        _Attribute.GET(_AttributeSetEntry."NS_Attribute Code");
        _AttributeSetEntry."NS_Value Type" := _Attribute."NS_Value Type";
    end;

    procedure NS_OnInsertDefaultAttribute(var _DefaultAttribute: Record "NS_Job Quote Default Attribute");
    var
        _Attribute: Record "NS_Job Quote Attribute";
    begin
        _Attribute.GET(_DefaultAttribute."NS_Attribute Code");
        _DefaultAttribute."NS_Value Type" := _Attribute."NS_Value Type";
    end;

    procedure NS_OnValidateTextValueAttributeSetEntry(var _AttributeSetEntry: Record "NS_Job Quote Attribute Set Ent");
    begin
        with _AttributeSetEntry do
            if "NS_Text Value" = '' then begin
                CLEAR("NS_Boolean Value");
                CLEAR("NS_Code Value");
                CLEAR("NS_Date Value");
                CLEAR("NS_Decimal Value");
                CLEAR("NS_Integer Value");
            end else
                case "NS_Value Type" of
                    "NS_Value Type"::Boolean:
                        EVALUATE("NS_Boolean Value", "NS_Text Value");
                    "NS_Value Type"::Code:
                        "NS_Code Value" := COPYSTR("NS_Text Value", 1, MAXSTRLEN("NS_Code Value"));
                    "NS_Value Type"::Date:
                        EVALUATE("NS_Date Value", "NS_Text Value");
                    "NS_Value Type"::Decimal:
                        EVALUATE("NS_Decimal Value", "NS_Text Value");
                    "NS_Value Type"::Integer:
                        EVALUATE("NS_Integer Value", "NS_Text Value");
                end;
    end;

    procedure NS_OnValidateTextValueDefaultAttribute(var _DefaultAttribute: Record "NS_Job Quote Default Attribute");
    begin
        with _DefaultAttribute do
            if "NS_Text Value" = '' then begin
                CLEAR("NS_Boolean Value");
                CLEAR("NS_Code Value");
                CLEAR("NS_Date Value");
                CLEAR("NS_Decimal Value");
                CLEAR("NS_Integer Value");
            end else
                case "NS_Value Type" of
                    "NS_Value Type"::Boolean:
                        EVALUATE("NS_Boolean Value", "NS_Text Value");
                    "NS_Value Type"::Code:
                        "NS_Code Value" := COPYSTR("NS_Text Value", 1, MAXSTRLEN("NS_Code Value"));
                    "NS_Value Type"::Date:
                        EVALUATE("NS_Date Value", "NS_Text Value");
                    "NS_Value Type"::Decimal:
                        EVALUATE("NS_Decimal Value", "NS_Text Value");
                    "NS_Value Type"::Integer:
                        EVALUATE("NS_Integer Value", "NS_Text Value");
                end;
    end;

    procedure NS_OnValidateValueTypeAttribute(_Attribute: Record "NS_Job Quote Attribute");
    var
        _AttributeSetEntry: Record "NS_Job Quote Attribute Set Ent";
        _DefaultAttribute: Record "NS_Job Quote Default Attribute";
        _Text000: Label '%1 must not be changed because one or more records exist for Table %2.';
    begin
        with _DefaultAttribute do begin
            SETCURRENTKEY("NS_Attribute Code");
            SETRANGE("NS_Attribute Code", _Attribute.NS_Code);
            if not ISEMPTY then
                ERROR(_Text000, _Attribute.FIELDCAPTION("NS_Value Type"), _DefaultAttribute.TABLECAPTION);
        end;
        with _AttributeSetEntry do begin
            SETCURRENTKEY("NS_Attribute Code");
            SETRANGE("NS_Attribute Code", _Attribute.NS_Code);
            if not ISEMPTY then
                ERROR(_Text000, _Attribute.FIELDCAPTION("NS_Value Type"), _AttributeSetEntry.TABLECAPTION);
        end;
    end;

    procedure NS_SetReadOnly(_ReadOnly: Boolean);
    begin
        ReadOnly := _ReadOnly;
    end;

    procedure NS_ShowDefaultAttributes(_TableID: Integer; _No: Code[20]);
    var
        _DefaultAttribute: Record "NS_Job Quote Default Attribute";
    begin
        with _DefaultAttribute do begin
            FILTERGROUP := 2;
            SETRANGE("NS_Table ID", _TableID);
            SETRANGE("NS_No.", _No);
            FILTERGROUP := 0;
            PAGE.RUN(PAGE::"NS_Job QuoteDefaultAttributes", _DefaultAttribute);
        end;
    end;

    procedure NS_ShowAttributeSetEntries(_EntryNo: Integer);
    var
        _AttributeSetEntry: Record "NS_Job Quote Attribute Set Ent";
        _AttributeSetEntries: Page "NS_Job Quote Attribute Set Ent";
    begin
        if _EntryNo = 0 then
            _EntryNo := NS_GetNextAttributeSetEntryNo;
        _AttributeSetEntry.FILTERGROUP := 2;
        _AttributeSetEntry.SETRANGE("NS_Attribute Set ID", _EntryNo);
        _AttributeSetEntry.FILTERGROUP := 0;
        if not ReadOnly then
            PAGE.RUN(PAGE::"NS_Job Quote Attribute Set Ent", _AttributeSetEntry)
        else begin
            CLEAR(_AttributeSetEntries);
            _AttributeSetEntries.SETTABLEVIEW(_AttributeSetEntry);
            _AttributeSetEntries.EDITABLE(false);
            _AttributeSetEntries.RUNMODAL;
        end;
    end;

    procedure NS_CreateQuoteJob(lJobQuote: Record "NS_Job Quote Header"; TrueFalse: Boolean): Code[20];
    var
        QuoteJob: Record Job;
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        QuoteJob.RESET;
        QuoteJob.INIT;
        QuoteJob."No." := lJobQuote."NS_Quote No.";
        //PRJCTPR-197 Dk.1.0 Start
        //QuoteJob."NS_Job Type" := lJobQuote."NS_Job Type Code";
        QuoteJob."NS_Job Type New" := lJobQuote."NS_Job Type Code";
        //PRJCTPR-197 Dk.1.0 End
        if lJobQuote."NS_Job Class" <> 0 then
            QuoteJob."NS_Job Class" := lJobQuote."NS_Job Class"
        else
            QuoteJob."NS_Job Class" := QuoteJob."NS_Job Class"::Proposed;
        QuoteJob.InitVar(TrueFalse, true);
        QuoteJob.SetDisableLoadTasks(DisableJobTaskLoad);
        if not QuoteJob.INSERT(true) then
            QuoteJob.MODIFY(true);
    end;

    procedure NS_ModifyQuoteJob(JobQuote: Record "NS_Job Quote Header");
    var
        QuoteJob: Record Job;
    begin
        QuoteJob.RESET;
        QuoteJob.SETRANGE("No.", JobQuote."NS_Quote No.");
        if QuoteJob.FINDFIRST then begin
            QuoteJob.VALIDATE(Description, JobQuote."NS_Description/Nickname");
            if JobQuote."NS_Sell-to Customer No." <> '' then //PRJ-309.MS.1.0
                QuoteJob.Validate("NS_Sell-to Customer No.", JobQuote."NS_Sell-to Customer No.");
            if QuoteJob."Bill-to Customer No." <> JobQuote."NS_Bill-to Customer No." then
                QuoteJob.VALIDATE("Bill-to Customer No.", JobQuote."NS_Bill-to Customer No.");
            QuoteJob."Creation Date" := JobQuote."NS_Proposal Date";
            QuoteJob."Starting Date" := JobQuote."NS_Estimated Start Date";
            QuoteJob."Ending Date" := JobQuote."NS_Estimated Completion Date";
            QuoteJob.NS_EnblGLNResGMCalc := JobQuote.NS_EnblGLNResGMCalc;//PRJ-1443
            QuoteJob.Status := QuoteJob.Status::Quote;
            QuoteJob."NS_Job Class" := QuoteJob."NS_Job Class"::Proposed;
            QuoteJob."Global Dimension 1 Code" := JobQuote."NS_Shortcut Dimension 1 Code";
            QuoteJob."Global Dimension 2 Code" := JobQuote."NS_Shortcut Dimension 2 Code";
            //QuoteJob.VALIDATE("NS_Salesperson Code", JobQuote."NS_Salesperson Code");//PRJ-867.AS.1.0 23SEPT2021 Comment
            QuoteJob.VALIDATE("NS_Salesperson Code", JobQuote."NS_Salesperson Code New");//PRJ-867.AS.1.0 23SEPT2021 Changed field Sales Person code to Sales person code New
                                                                                         //QuoteJob."Job Type" := FORMAT(JobQuote."Job Type");//*
                                                                                         //PRJCTPR-197 Dk.1.0 Start
                                                                                         // QuoteJob."NS_Job Type" := JobQuote."NS_Job Type Code";
            QuoteJob."NS_Job Type New" := JobQuote."NS_Job Type Code";
            //PRJCTPR-197 Dk.1.0 End
            QuoteJob."NS_Job Class" := JobQuote."NS_Job Class";
            QuoteJob."NS_Sub-Level to Job No." := JobQuote."NS_Sub-Level to Job No.";
            QuoteJob."NS_Owner No." := JobQuote."NS_Owner No.";
            QuoteJob."NS_Owner Name" := JobQuote."NS_Owner Name";
            QuoteJob."NS_General Contractor No." := JobQuote."NS_General Contractor No.";
            QuoteJob."NS_General Contractor Name" := JobQuote."NS_General Contractor Name";
            QuoteJob."NS_Architect/Engineer No." := JobQuote."NS_Architect/Engineer No.";
            QuoteJob."NS_Architect/Engineer Name" := JobQuote."NS_Architect/Engineer Name";
            QuoteJob."NS_Project Manager No." := JobQuote."NS_Project Manager No.";
            QuoteJob."NS_Project Manager Name" := JobQuote."NS_Project Manager Name";
            QuoteJob.NS_Manager := JobQuote."NS_Project Manager No.";
            QuoteJob.NS_Estimator := JobQuote."NS_Estimator No.";
            if EVALUATE(QuoteJob."NS_Requires Certified Payroll", FORMAT(JobQuote."NS_Certified Payroll")) then;//*
            QuoteJob.NS_Bond := JobQuote.NS_Bond;
            QuoteJob."NS_CCIP/OCIP/RCOIP Insurance" := JobQuote."NS_CCIP/OCIP/RCOIP Insurance";
            QuoteJob."NS_Lien Waiver Required" := JobQuote."NS_Lien Waiver Required";
            QuoteJob."NS_Billing Cutoff Day of Month" := JobQuote."NS_Billing Cutoff Day of Month";
            QuoteJob."NS_Estimated Start Date" := JobQuote."NS_Estimated Start Date";
            QuoteJob."NS_Estimated Completion Date" := JobQuote."NS_Estimated Completion Date";
            QuoteJob."NS_Tax Area Code" := JobQuote."NS_Tax Area Code";
            QuoteJob."NS_Tax Liable" := JobQuote."NS_Tax Liable";
            // QuoteJob."NS_Tax Group Code" := JobQuote."NS_Tax Group Code"; //PRJCTPR-298.JS.1.0 16JAN2024
            QuoteJob."NS_Tax Group Code New" := JobQuote."NS_Tax Group Code";  //PRJCTPR-298.JS.1.0
            QuoteJob."NS_VAT Bus. Posting Group" := JobQuote."NS_VAT Bus. Posting Group";
            QuoteJob."NS_VAT Prod. Posting Group" := JobQuote."NS_VAT Prod. Posting Group";
            QuoteJob."NS_Use Tax SKU" := JobQuote."NS_Use Tax SKU";
            QuoteJob."Bill-to Name" := JobQuote."NS_Bill-to Customer Name";
            QuoteJob."Bill-to Address" := JobQuote."NS_Bill-to Address";
            QuoteJob."Bill-to Address 2" := JobQuote."NS_Bill-to Address 2";
            QuoteJob."Bill-to City" := JobQuote."NS_Bill-to City";
            QuoteJob."Bill-to County" := JobQuote."NS_Bill-to County";
            QuoteJob."Bill-to Post Code" := JobQuote."NS_Bill-to Post Code";
            QuoteJob."Bill-to Country/Region Code" := JobQuote."NS_Bill-to Country/Region Code";
            QuoteJob."Bill-to Name 2" := JobQuote."NS_Bill-to Name 2";
            QuoteJob."NS_Job Address 1" := JobQuote."NS_Job Address 1";
            QuoteJob."NS_Job Address 2" := JobQuote."NS_Job Address 2";
            QuoteJob."NS_Job City" := JobQuote."NS_Job City";
            QuoteJob."NS_Job Post Code" := JobQuote."NS_Job Post Code";
            QuoteJob."NS_Job Country/Region Code" := JobQuote."NS_Job Country/Region Code";
            QuoteJob."NS_Job Ship-to Code" := JobQuote."NS_Job Ship-to Code";
            QuoteJob.MODIFY;
        end;
    end;

    local procedure NS_CheckTaskTotals(JobNo: Code[20]; TaskNo: Code[20]): Boolean;
    var
        JobTask: Record "Job Task";
        JobTask2: Record "Job Task";
    begin
        JobTask.RESET;
        JobTask.SETRANGE("Job No.", JobNo);
        JobTask.SETFILTER("Job Task No.", '>=%1', TaskNo);
        JobTask.SETRANGE("Job Task Type", JobTask."Job Task Type"::"End-Total");
        if JobTask.FINDFIRST then begin
            JobTask2.RESET;
            JobTask2.SETRANGE("Job No.", JobNo);
            JobTask2.SETFILTER("Job Task No.", JobTask.Totaling);
            if JobTask2.FINDSET then
                repeat
                    if JobTask2."Job Task No." = TaskNo then
                        exit(true);
                until JobTask2.NEXT = 0;
            exit(false);
        end else
            exit(false);
    end;

    local procedure NS_ConvertQuoteSegments(lQuoteHeader: Record "NS_Job Quote Header"; lJob: Record Job);
    var
        _JobTakeoffSegments: Record "NS_Job Takeoff Segments";
        _JobPlanningLine: Record "Job Planning Line";
        NewSegment: Record "NS_Job Takeoff Segments";
        _LastJPL: Record "Job Planning Line";
        _LineNo: Integer;
        JobPostingGroup: Record "Job Posting Group";
        JobsSetup: Record "Jobs Setup";
        TotalContractPrice: Decimal;
    begin
        JobsSetup.GET;
        JobsSetup.TESTFIELD("NS_Billing Job Task No.");

        //lQuoteHeader.TESTFIELD("NS_Job Posting Group");//PRJ-993.AS.1.0 18OCT2021 comment old code for field "NS_Job Posting Group" for Job Quote header
        lQuoteHeader.TESTFIELD("NS_Job Posting Group New");//PRJ-993.AS.1.0 18OCT2021 Add new code for field "NS_Job Posting Group New" for Job Quote header
        //JobPostingGroup.GET(lQuoteHeader."NS_Job Posting Group");//PRJ-993.AS.1.0 18OCT2021 comment old code for field "NS_Job Posting Group" for Job Quote header
        JobPostingGroup.GET(lQuoteHeader."NS_Job Posting Group New");//PRJ-993.AS.1.0 18OCT2021 Add new code for field "NS_Job Posting Group New" for Job Quote header
        JobPostingGroup.TESTFIELD("Recognized Sales Account");

        _JobTakeoffSegments.RESET;
        _JobTakeoffSegments.SETRANGE("NS_Job No.", lQuoteHeader."NS_Quote No.");
        if _JobTakeoffSegments.FINDSET then
            repeat

                _JobTakeoffSegments.CALCFIELDS("NS_Schedule (Total Price)");
                if _JobTakeoffSegments."NS_Total Contract Price" = 0 then
                    TotalContractPrice := _JobTakeoffSegments."NS_Schedule (Total Price)"
                else
                    TotalContractPrice := _JobTakeoffSegments."NS_Total Contract Price";

                if TotalContractPrice > 0 then begin

                    //Create Job Takeoff Segment for new Job
                    NewSegment.INIT;
                    NewSegment := _JobTakeoffSegments;
                    NewSegment."NS_Job No." := lJob."No.";
                    //IF NewSegment.INSERT THEN;
                    NewSegment.INSERT(true);

                    //Look for last Job Planning Line to get Line No.
                    _LastJPL.RESET;
                    _LastJPL.SETRANGE("Job No.", lJob."No.");
                    _LastJPL.SETRANGE("Job Task No.", JobsSetup."NS_Billing Job Task No.");
                    if _LastJPL.FINDLAST then
                        _LineNo := _LastJPL."Line No." + 10000
                    else
                        _LineNo := 10000;

                    //Create Job Planning Lines of type Billable for the Segment Total
                    _JobPlanningLine.INIT;
                    _JobPlanningLine.VALIDATE("Job No.", lJob."No.");
                    _JobPlanningLine.VALIDATE("Job Task No.", JobsSetup."NS_Billing Job Task No.");
                    _JobPlanningLine.VALIDATE("Line No.", _LineNo);
                    _JobPlanningLine.VALIDATE("NS_Segment Code", _JobTakeoffSegments."NS_Segment Code");
                    _JobPlanningLine.VALIDATE(Type, _JobPlanningLine.Type::"G/L Account");
                    _JobPlanningLine.VALIDATE("No.", JobPostingGroup."Recognized Sales Account");
                    _JobPlanningLine.VALIDATE("Line Type", _JobPlanningLine."Line Type"::Billable);
                    _JobPlanningLine.VALIDATE(Quantity, 1);
                    _JobPlanningLine.VALIDATE("Unit Price", TotalContractPrice);
                    _JobPlanningLine.VALIDATE("Planning Date", TODAY);
                    _JobPlanningLine.Description := _JobTakeoffSegments."NS_Segment Name";
                    _JobPlanningLine.INSERT;
                end;
            until _JobTakeoffSegments.NEXT = 0;
    end;

    //PRJ-914.AS.1.0 START
    local procedure NS_ConvertQuoteSegmentsChangeOrder(UpdateJob: Record Job; lJob: Record Job);
    var
        _JobTakeoffSegments: Record "NS_Job Takeoff Segments";
        _JobPlanningLine: Record "Job Planning Line";
        NewSegment: Record "NS_Job Takeoff Segments";
        _LastJPL: Record "Job Planning Line";
        _LineNo: Integer;
        JobPostingGroup: Record "Job Posting Group";
        JobsSetup: Record "Jobs Setup";
        TotalContractPrice: Decimal;
    begin
        JobsSetup.GET;
        JobsSetup.TESTFIELD("NS_Billing Job Task No.");

        if JobPostingGroup.GET(UpdateJob."Job Posting Group") then;
        JobPostingGroup.TESTFIELD("Recognized Sales Account");

        _JobTakeoffSegments.RESET;
        _JobTakeoffSegments.SETRANGE("NS_Job No.", UpdateJob."No.");
        if _JobTakeoffSegments.FINDSET then
            repeat

                _JobTakeoffSegments.CALCFIELDS("NS_Schedule (Total Price)");
                if _JobTakeoffSegments."NS_Total Contract Price" = 0 then
                    TotalContractPrice := _JobTakeoffSegments."NS_Schedule (Total Price)"
                else
                    TotalContractPrice := _JobTakeoffSegments."NS_Total Contract Price";

                if TotalContractPrice > 0 then begin

                    //Create Job Takeoff Segment for new Job
                    NewSegment.INIT;
                    NewSegment := _JobTakeoffSegments;
                    NewSegment."NS_Job No." := lJob."No.";
                    //IF NewSegment.INSERT THEN;
                    NewSegment.INSERT(true);

                    //Look for last Job Planning Line to get Line No.
                    _LastJPL.RESET;
                    _LastJPL.SETRANGE("Job No.", lJob."No.");
                    _LastJPL.SETRANGE("Job Task No.", JobsSetup."NS_Billing Job Task No.");
                    if _LastJPL.FINDLAST then
                        _LineNo := _LastJPL."Line No." + 10000
                    else
                        _LineNo := 10000;

                    //Create Job Planning Lines of type Billable for the Segment Total
                    _JobPlanningLine.INIT;
                    _JobPlanningLine.VALIDATE("Job No.", lJob."No.");
                    _JobPlanningLine.VALIDATE("Job Task No.", JobsSetup."NS_Billing Job Task No.");
                    _JobPlanningLine.VALIDATE("Line No.", _LineNo);
                    _JobPlanningLine.VALIDATE("NS_Segment Code", _JobTakeoffSegments."NS_Segment Code");
                    _JobPlanningLine.VALIDATE(Type, _JobPlanningLine.Type::"G/L Account");
                    _JobPlanningLine.VALIDATE("No.", JobPostingGroup."Recognized Sales Account");
                    _JobPlanningLine.VALIDATE("Line Type", _JobPlanningLine."Line Type"::Billable);
                    _JobPlanningLine.VALIDATE(Quantity, 1);
                    _JobPlanningLine.VALIDATE("Unit Price", TotalContractPrice);
                    _JobPlanningLine.VALIDATE("Planning Date", TODAY);
                    _JobPlanningLine.Description := _JobTakeoffSegments."NS_Segment Name";
                    _JobPlanningLine.INSERT;
                end;
            until _JobTakeoffSegments.NEXT = 0;
    end;
    //PRJ-914.AS.1.0 END

    procedure NS_SetBySegment(PassSegment: Boolean);
    begin
        BySegment := PassSegment;
    end;

    local procedure NS_CalcSegAmountsFromContractPrice(var Rec: Record "NS_Job Takeoff Segments"; xRec: Record "NS_Job Takeoff Segments");
    var
        PercentDelta: Decimal;
        AmtTotal: Decimal;
        QuotePlanLine: Record "Job Planning Line";
        RecCt: Integer;
        QtyTotal: Decimal;
        CostRecs: Integer;
        tmpQuotePlanLine: Record "Job Planning Line" temporary;
        PlanLineRscQty: Decimal;
    begin
        NS_UpdateSegmentAmounts(Rec);
    end;

    local procedure NS_CopyQuoteLinksToJob(var PassQuote: Record "NS_Job Quote Header"; var PassJob: Record Job);
    var
        RecordLink: Record "Record Link";
        NewRecLink: Record "Record Link";
        RecRef: RecordRef;
        LinkID: Integer;
    begin
        RecordLink.RESET;
        if RecordLink.FINDLAST then
            LinkID := RecordLink."Link ID"
        else
            LinkID := 0;
        RecordLink.RESET;
        RecordLink.SETFILTER("Record ID", 'NS_Job Quote Header: ' + PassQuote."NS_Quote No.");//PPAL-33.MS.1.0 add NS_ on cap
        if RecordLink.FINDSET then
            repeat
                LinkID += 1;
                NewRecLink.INIT;
                NewRecLink.TRANSFERFIELDS(RecordLink);
                NewRecLink."Link ID" := LinkID;
                RecRef.OPEN(167);
                RecRef.GETTABLE(PassJob);
                NewRecLink."Record ID" := RecRef.RECORDID;
                NewRecLink.INSERT;
                RecRef.CLOSE;
            until RecordLink.NEXT = 0;
    end;

    procedure NS_OnDeleteJobQuoteLine(PassQuoteLine: Record "NS_Job Quote Line");
    var
        JobTask: Record "Job Task";
        Segment: Record "NS_Job Takeoff Segments";
        JobPlanLine: Record "Job Planning Line";
    begin
        if PassQuoteLine.NS_Type <> PassQuoteLine.NS_Type::Template then
            exit;
        JobPlanLine.RESET;
        JobPlanLine.SETRANGE("Job No.", PassQuoteLine."NS_Quote No.");
        JobPlanLine.SETRANGE("NS_Template No.", PassQuoteLine."NS_No.");
        if JobPlanLine.FINDSET then
            repeat
                JobPlanLine.DELETE;
            until JobPlanLine.NEXT = 0;

        JobTask.RESET;
        JobTask.SETRANGE("Job No.", PassQuoteLine."NS_Quote No.");
        JobTask.SETRANGE("NS_Template No.", PassQuoteLine."NS_No.");
        if JobTask.FINDSET then
            repeat
                JobTask.DELETE;
            until JobTask.NEXT = 0;

        Segment.RESET;
        Segment.SETRANGE("NS_Job No.", PassQuoteLine."NS_Quote No.");
        Segment.SETRANGE("NS_Template No.", PassQuoteLine."NS_No.");
        if Segment.FINDSET then
            repeat
                Segment.DELETE;
            until Segment.NEXT = 0;
    end;

    procedure NS_OnRenameQuoteLine(NewQuoteLine: Record "NS_Job Quote Line"; PrevQuoteLine: Record "NS_Job Quote Line");
    var
        JobTask: Record "Job Task";
        Segment: Record "NS_Job Takeoff Segments";
        JobPlanLine: Record "Job Planning Line";
    begin
        NS_OnDeleteJobQuoteLine(PrevQuoteLine);
        NS_LoadFromJobTmpl(NewQuoteLine."NS_Quote No.", NewQuoteLine."NS_No.");
    end;

    procedure PrintQuoteWithSegmentScope(_QuoteHeader: Record "NS_Job Quote Header"; _UseSystemPrinter: Boolean);
    var
        _AttributeSetEntry: Record "NS_Job Quote Attribute Set Ent";
        _Buf: Record "NS_Job Quote Sel. Buf." temporary;
        _ItemCategory: Record "Item Category";
        _FeatureText: Record "NS_Job Quote Feature Text";
        _QuoteComment: Record "Comment Line";
        _QuoteLine: Record "NS_Job Quote Line";
        _Text000: Label 'Generally, quotes exceeding a system tolerance must be reviewed before the Status is set to Released.  The current status is %1.  Are you sure you want to print the document?';
        _QuoteLine2: Record "NS_Job Quote Line";
        _ScopeOfWork: Record "NS_Job Quote Scope of Work";
        _TermsConditions: Record NS_JobQuoteTermsConditions;
        _Proposal: Boolean;
        _CategoryCode: Code[10];
        _Total: Decimal;
        _TotalInclVAT: Decimal;
        _EntryNo: Integer;
        _Text001: Label 'Features';
        _QuoteDoc: Report "NS_Job Quote with SegmentScope";
        _Text002: Label 'The quote is set to print Sales Tax, but the document must be released first.';
        Attribute: Record "NS_Job Quote Attribute";
        FreightAmt: Decimal;
        EquipmentAmt: Decimal;
        InstallAmt: Decimal;
        BondAmt: Decimal;
        ServiceAmt: Decimal;
        _QuoteTaskLines: Record "Job Task";
        Segment: Record "NS_Job Takeoff Segments";
        TotalBySegment: Decimal;
        SegmentScopeOfWork: Record "NS_Job Quote Scope of Work";
        QuoteSetup: Record "Jobs Setup";
        NSQuoteStatus: enum "NS_Quote Status";  //PE-300.JS.1.0 29JULY2024
        NSQuoteStatusInt: Integer; //PE-300.JS.1.0 29JULY2024
                                   // >> Upgrade
        Ins: InStream;
    // << Upgrade
    begin
        CLEAR(_QuoteDoc);
        //PE-300.JS.1.0 29JULY2024
        Clear(NSQuoteStatusInt);
        NSQuoteStatus := NSQuoteStatus::Released;
        NSQuoteStatusInt := NSQuoteStatus.AsInteger();
        //PE-300.JS.1.0 29JULY2024
        _QuoteDoc.Initialize(_QuoteHeader);
        _Proposal := not _QuoteHeader."NS_Equipment Only";

        _Proposal := true;

        _QuoteDoc.SetProposal;

        // initialize recordset

        CLEAR(_Buf);
        _Buf.DELETEALL;
        if _UseSystemPrinter then
            _QuoteDoc.USEREQUESTPAGE(false);

        _Buf.RESET;
        if _Buf.FINDLAST then
            _EntryNo := _Buf."NS_Entry No.";

        _Buf.SETCURRENTKEY("NS_Quote No.", "NS_Created by");
        _Buf.SETRANGE("NS_Created by", USERID);
        _Buf.DELETEALL;
        _Buf.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");

        // set draft/"Internal Use Only"

        if _Proposal then
            //PE-300-DK.1.0 29May2024 Start
            //if _QuoteHeader.NS_Status < _QuoteHeader.NS_Status::Released then
            if _QuoteHeader."NS_Quote Status".AsInteger() < NSQuoteStatusInt then  //PE-300-DK.1.0 29May2024 29July2024
                //PE-300-DK.1.0 29May2024 End
                if not GUIALLOWED then
                    exit
                else
                    _QuoteDoc.SetDraft(true);

        // build dataset

        // Header Comments
        _QuoteComment.RESET;
        _QuoteComment.SETRANGE("No.", _QuoteHeader."NS_Quote No.");
        _QuoteComment.SETRANGE("Line No.", 0);
        //_QuoteComment.SETRANGE("Print On Quote",TRUE);
        _QuoteComment.SETFILTER(Comment, '<>%1', '');
        if _Proposal then
            if _QuoteComment.FINDSET(false) then begin
                with _Buf do begin
                    _EntryNo += 1;
                    INIT;
                    "NS_Entry No." := _EntryNo;
                    "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                    NS_Indentation := 10;
                    NS_Description := 'Comments';
                    "NS_Created by" := USERID;
                    _QuoteDoc.InsertTempBuf(_Buf);
                end;
                repeat
                    with _Buf do begin
                        _EntryNo += 1;
                        INIT;
                        "NS_Entry No." := _EntryNo;
                        "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                        NS_Indentation := 5;
                        NS_Description := COPYSTR(_QuoteComment.Comment, 1, MAXSTRLEN(NS_Description));
                        "NS_Created by" := USERID;
                        _QuoteDoc.InsertTempBuf(_Buf);
                    end;
                until _QuoteComment.NEXT = 0;
            end;

        // if no quote lines exist, ensure filters in place ...
        // first, line-specific scope-of-work recs are added to the print records, then
        // document-specific, outside the REPEAT..UNTIL loop for the lines
        /*_ScopeOfWork.SETRANGE("Quote No.",_QuoteHeader."Quote No.");
        _ScopeOfWork.SETRANGE("Quote Line No.",TRUE);
        _QuoteComment.SETRANGE("No.",_QuoteLine."Quote No.");
        //_QuoteComment.SETRANGE("Print On Quote",TRUE);
        _QuoteComment.SETFILTER(Comment,'<>%1','');*/

        // Headings
        with _Buf do begin
            _EntryNo += 1;
            INIT;
            "NS_Entry No." := _EntryNo;
            "NS_Quote No." := _QuoteHeader."NS_Quote No.";
            NS_Indentation := 55;
            NS_Description := '';
            "NS_Created by" := USERID;
            _QuoteDoc.InsertTempBuf(_Buf);
        end;

        _QuoteLine.RESET;
        _QuoteLine.SETCURRENTKEY("NS_Category Code", "NS_Quote Line No.");
        _QuoteLine.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        _QuoteLine.SETRANGE("NS_Attached to Line No.", 0);
        _QuoteLine.SETFILTER(NS_Type, '<>%1', _QuoteLine.NS_Type::Template);

        if _QuoteLine.FINDSET(false) then
            repeat

                // category heading

                if _Proposal then
                    if _CategoryCode <> _QuoteLine."NS_Category Code" then
                        with _Buf do begin
                            _CategoryCode := _QuoteLine."NS_Category Code";
                            if not _ItemCategory.GET(_CategoryCode) then
                                _ItemCategory.INIT;
                            _EntryNo += 1;
                            INIT;
                            "NS_Entry No." := _EntryNo;
                            "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                            NS_Indentation := 20;
                            NS_Description := _ItemCategory.Description;
                            "NS_Created by" := USERID;
                            _QuoteDoc.InsertTempBuf(_Buf);
                        end;

                // quote line

                with _Buf do begin
                    _EntryNo += 1;
                    INIT;
                    "NS_Entry No." := _EntryNo;
                    "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                    NS_Type := _QuoteLine.NS_Type;
                    "NS_No." := _QuoteLine."NS_No.";
                    if _QuoteLine."NS_No. 2" = '' then
                        "NS_No. 2" := _QuoteLine."NS_No."
                    else
                        "NS_No. 2" := _QuoteLine."NS_No. 2";
                    NS_Description := COPYSTR(_QuoteLine.NS_Description, 1, MAXSTRLEN(NS_Description));
                    NS_Quantity := _QuoteLine.NS_Quantity;
                    "NS_Unit of Measure Code" := _QuoteLine."NS_Unit of Measure Code";
                    if NS_Quantity <> 0 then
                        "NS_Total Price" := ROUND(_QuoteLine.NS_Amount / _QuoteLine.NS_Quantity, 0.01)
                    else
                        "NS_Total Price" := _QuoteLine."NS_Total Price";
                    NS_Amount := _QuoteLine.NS_Amount;
                    "NS_Amount Including VAT" := _QuoteLine."NS_Amount Including VAT";
                    "NS_Line Discount Amount" := _QuoteLine."NS_Line Discount Amount";
                    "NS_Line Discount %" := _QuoteLine."NS_Line Discount %";
                    "NS_Created by" := USERID;
                    _Total += NS_Amount;
                    _TotalInclVAT += "NS_Amount Including VAT";
                    if _QuoteHeader."NS_Lump Sum" then begin
                        "NS_Total Price" := 0;
                        NS_Amount := 0;
                    end;
                    _QuoteDoc.InsertTempBuf(_Buf);
                end;

                // "includes" section

                _QuoteLine2.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
                _QuoteLine2.SETRANGE("NS_Attached to Line No.", _QuoteLine."NS_Quote Line No.");
                if _QuoteLine2.FINDSET(false) then begin
                    with _Buf do begin
                        _EntryNo += 1;
                        INIT;
                        "NS_Entry No." := _EntryNo;
                        "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                        NS_Indentation := 10;
                        NS_Description := 'Includes';
                        "NS_Created by" := USERID;
                        _QuoteDoc.InsertTempBuf(_Buf);
                    end;
                    repeat
                        with _Buf do begin
                            _EntryNo += 1;
                            INIT;
                            "NS_Entry No." := _EntryNo;
                            "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                            NS_Indentation := 11;
                            NS_Type := _QuoteLine2.NS_Type;
                            "NS_No." := _QuoteLine2."NS_No.";
                            if _QuoteLine2."NS_No. 2" = '' then
                                "NS_No. 2" := _QuoteLine2."NS_No."
                            else
                                "NS_No. 2" := _QuoteLine2."NS_No. 2";
                            if _QuoteLine2."NS_No. 2" <> '' then
                                NS_Description := _QuoteLine2."NS_No. 2" + ' - ';
                            NS_Description := COPYSTR(NS_Description + _QuoteLine2.NS_Description, 1, MAXSTRLEN(NS_Description));
                            NS_Quantity := _QuoteLine2.NS_Quantity;
                            "NS_Unit of Measure Code" := _QuoteLine2."NS_Unit of Measure Code";
                            "NS_Created by" := USERID;
                            _QuoteDoc.insertTempBuf(_Buf);
                        end;
                    until _QuoteLine2.NEXT = 0;
                end;

                // attributes/configuration

                if _QuoteLine."NS_Attribute Set Entry No." <> 0 then begin
                    _AttributeSetEntry.SETRANGE("NS_Attribute Set ID", _QuoteLine."NS_Attribute Set Entry No.");
                    _AttributeSetEntry.SETFILTER("NS_Text Value", '<>%1', 'NO');
                    if _AttributeSetEntry.FINDSET(false) then begin
                        with _Buf do begin
                            _EntryNo += 1;
                            INIT;
                            "NS_Entry No." := _EntryNo;
                            "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                            NS_Indentation := 10;
                            NS_Description := 'Configuration';
                            "NS_Created by" := USERID;
                            _QuoteDoc.InsertTempBuf(_Buf);
                        end;
                        repeat
                            with _Buf do begin
                                _EntryNo += 1;
                                INIT;
                                "NS_Entry No." := _EntryNo;
                                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                                NS_Indentation := 5;
                                if Attribute.GET(_AttributeSetEntry."NS_Attribute Code") then;
                                if Attribute.NS_Description <> '' then
                                    NS_Description := COPYSTR(STRSUBSTNO('%1: %2'
                                                                   , Attribute.NS_Description
                                                                   , _AttributeSetEntry."NS_Text Value"), 1, MAXSTRLEN(NS_Description))
                                else
                                    NS_Description := COPYSTR(STRSUBSTNO('%1: %2'
                                                                   , Attribute.NS_Code
                                                                   , _AttributeSetEntry."NS_Text Value"), 1, MAXSTRLEN(NS_Description));
                                "NS_Created by" := USERID;
                                _QuoteDoc.InsertTempBuf(_Buf);
                            end;
                        until _AttributeSetEntry.NEXT = 0;
                    end;
                end;

                // add features

                _FeatureText.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
                _FeatureText.SETRANGE("NS_Quote Line No.", _QuoteLine."NS_Quote Line No.");
                if _FeatureText.FINDSET(false) then begin
                    with _Buf do begin
                        _EntryNo += 1;
                        INIT;
                        "NS_Entry No." := _EntryNo;
                        "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                        NS_Indentation := 10;
                        NS_Description := 'Features';
                        "NS_Created by" := USERID;
                        _QuoteDoc.InsertTempBuf(_Buf);
                    end;
                    repeat
                        with _Buf do begin
                            _EntryNo += 1;
                            INIT;
                            "NS_Entry No." := _EntryNo;
                            "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                            NS_Indentation := 5;
                            NS_Description := COPYSTR(_FeatureText."NS_Text Value", 1, MAXSTRLEN(NS_Description));
                            "NS_Created by" := USERID;
                            _QuoteDoc.InsertTempBuf(_Buf);
                        end;
                    until _FeatureText.NEXT = 0;
                end;

                // line specific scope of work

                /*_ScopeOfWork.SETRANGE("Quote No.",_QuoteHeader."Quote No.");
                _ScopeOfWork.SETRANGE("Quote Line No.",_QuoteLine."Quote Line No.");
                _ScopeOfWork.SETRANGE("Quote Line No.",TRUE);
                IF _Proposal THEN
                  IF _ScopeOfWork.FINDSET(FALSE) THEN BEGIN
                    WITH _Buf DO BEGIN
                      _EntryNo += 1;
                      INIT;
                      "Entry No." := _EntryNo;
                      "Quote No." := _QuoteHeader."Quote No.";
                      Indentation := 10;
                      Description := 'Scope of Work';
                      "Created by" := USERID;
                      _QuoteDoc.InsertTempBuf(_Buf);
                    END;
                    REPEAT
                      WITH _Buf DO BEGIN
                        _EntryNo += 1;
                        INIT;
                        "Entry No." := _EntryNo;
                        "Quote No." := _QuoteHeader."Quote No.";
                        Indentation := 5;
                        Description := COPYSTR(_ScopeOfWork."Text Value",1,MAXSTRLEN(Description));
                        "Created by" := USERID;
                        _QuoteDoc.InsertTempBuf(_Buf);
                      END;
                    UNTIL _ScopeOfWork.NEXT = 0;
                  END;*/

                // comments

                _QuoteComment.SETRANGE("No.", _QuoteLine."NS_Quote No.");
                _QuoteComment.SETRANGE("Line No.", _QuoteLine."NS_Quote Line No.");
                //_QuoteComment.SETRANGE("Print On Quote",TRUE);
                _QuoteComment.SETFILTER(Comment, '<>%1', '');
                if _Proposal then
                    if _QuoteComment.FINDSET(false) then begin
                        with _Buf do begin
                            _EntryNo += 1;
                            INIT;
                            "NS_Entry No." := _EntryNo;
                            "NS_No." := _QuoteHeader."NS_Quote No.";
                            NS_Indentation := 10;
                            NS_Description := 'Comments';
                            "NS_Created by" := USERID;
                            _QuoteDoc.InsertTempBuf(_Buf);
                        end;
                        repeat
                            with _Buf do begin
                                _EntryNo += 1;
                                INIT;
                                "NS_Entry No." := _EntryNo;
                                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                                NS_Indentation := 5;
                                NS_Description := COPYSTR(_QuoteComment.Comment, 1, MAXSTRLEN(NS_Description));
                                "NS_Created by" := USERID;
                                _QuoteDoc.InsertTempBuf(_Buf);
                            end;
                        until _QuoteComment.NEXT = 0;
                    end;

            until _QuoteLine.NEXT = 0;

        //Task Lines Start
        QuoteSetup.GET;

        _QuoteTaskLines.SETRANGE("Job Task Type", _QuoteTaskLines."Job Task Type"::"End-Total");
        _QuoteTaskLines.SETRANGE("Job No.", _QuoteHeader."NS_Job No.");
        _QuoteTaskLines.SETFILTER("Job Task No.", '<>%1', QuoteSetup."NS_Total Task No.");
        if _QuoteTaskLines.FINDSET(false, false) then
            repeat
                _QuoteTaskLines.CALCFIELDS("Schedule (Total Price)", "NS_Line Amount Incl. Tax");
                with _Buf do begin
                    _EntryNo += 1;
                    INIT;
                    "NS_Entry No." := _EntryNo;
                    "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                    NS_Type := _QuoteTaskLines."Job Task Type";
                    "NS_No." := _QuoteTaskLines."Job Task No.";
                    "NS_No. 2" := _QuoteTaskLines."Job Task No.";
                    NS_Description := COPYSTR(_QuoteTaskLines.Description, 1, MAXSTRLEN(NS_Description));
                    NS_Quantity := 0;
                    "NS_Total Price" := ROUND(_QuoteTaskLines."Schedule (Total Price)", 0.01);
                    NS_Amount := _QuoteTaskLines."Schedule (Total Price)";
                    "NS_Amount Including VAT" := _QuoteTaskLines."NS_Line Amount Incl. Tax";
                    "NS_Created by" := USERID;
                    _Total += NS_Amount;
                    _TotalInclVAT += "NS_Amount Including VAT";
                    if _QuoteHeader."NS_Lump Sum" then begin
                        "NS_Total Price" := 0;
                        NS_Amount := 0;
                    end;
                    _QuoteDoc.InsertTempBuf(_Buf);
                end;
            until _QuoteTaskLines.NEXT = 0;
        //Task Lines End

        //Moved this section down to get Segments to Print after Header line (indentation = 55)
        //Get Totals summarized by Segment
        if BySegment then begin
            Segment.RESET;
            Segment.SETRANGE("NS_Job No.", _QuoteHeader."NS_Quote No.");
            if Segment.FINDSET then
                repeat
                    Segment.CALCFIELDS("NS_Schedule (Total Price)");
                    with _Buf do begin
                        _EntryNo += 1;
                        INIT;
                        "NS_Entry No." := _EntryNo;
                        "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                        NS_Indentation := 777;
                        "NS_No." := Segment."NS_Segment Code";
                        NS_Name := Segment."NS_Segment Name";
                        if Segment."NS_Total Contract Price" <> 0 then
                            "NS_Total Price" := Segment."NS_Total Contract Price"
                        else
                            "NS_Total Price" := Segment."NS_Schedule (Total Price)";
                        TotalBySegment += "NS_Total Price";
                        "NS_Created by" := USERID;
                        NS_Quantity := Segment."NS_Work Units";
                        "NS_Unit of Measure Code" := Segment."NS_Work Unit of Measure";
                        _QuoteDoc.InsertTempBuf(_Buf);
                        SegmentScopeOfWork.RESET;
                        SegmentScopeOfWork.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
                        SegmentScopeOfWork.SETRANGE("NS_Segment Code", Segment."NS_Segment Code");
                        if SegmentScopeOfWork.FINDSET then
                            repeat
                                _EntryNo += 1;
                                INIT;
                                "NS_Entry No." := _EntryNo;
                                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                                NS_Indentation := 778;
                                "NS_No." := Segment."NS_Segment Code";
                                NS_Name := SegmentScopeOfWork.NS_Details;
                                "NS_Created by" := USERID;
                                _QuoteDoc.InsertTempBuf(_Buf);
                            until SegmentScopeOfWork.NEXT = 0;
                    end;
                until Segment.NEXT = 0;
            if TotalBySegment <> 0 then begin
                with _Buf do begin
                    _EntryNo += 1;
                    INIT;
                    "NS_Entry No." := _EntryNo;
                    "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                    NS_Indentation := 777;
                    NS_Name := 'GRAND TOTAL';
                    "NS_Total Price" := TotalBySegment;
                    _QuoteDoc.InsertTempBuf(_Buf);
                end;
            end;
        end;

        // document total
        // For adding space between total and lines

        with _Buf do begin
            _EntryNo += 1;
            INIT;
            "NS_Entry No." := _EntryNo;
            "NS_Quote No." := _QuoteHeader."NS_Quote No.";
            NS_Indentation := 5;
            NS_Description := '                ';
            "NS_Created by" := USERID;
            _QuoteDoc.InsertTempBuf(_Buf);
        end;

        // Equipment Subtotal
        EquipmentAmt := GetSubtotals(_QuoteHeader, 2);
        if EquipmentAmt <> 0 then begin
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 34;
                NS_Amount := _Total;
                "NS_Amount Including VAT" := _TotalInclVAT;
                "NS_Equipment Subtotal" := EquipmentAmt;
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
        end;


        // For Sales Tax to print after equipment subtotal
        with _Buf do begin
            _EntryNo += 1;
            INIT;
            "NS_Entry No." := _EntryNo;
            "NS_Quote No." := _QuoteHeader."NS_Quote No.";
            NS_Indentation := 39;
            NS_Amount := _Total;
            "NS_Amount Including VAT" := _TotalInclVAT;
            "NS_Created by" := USERID;
            _QuoteDoc.InsertTempBuf(_Buf);
        end;


        // Freight Subtotal
        FreightAmt := GetSubtotals(_QuoteHeader, 1);
        if FreightAmt <> 0 then begin
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 35;
                NS_Amount := _Total;
                "NS_Amount Including VAT" := _TotalInclVAT;
                NS_Freight := FreightAmt;
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
        end;

        // Installation Subtotal
        InstallAmt := GetSubtotals(_QuoteHeader, 3);
        if InstallAmt <> 0 then begin
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 36;
                NS_Amount := _Total;
                "NS_Amount Including VAT" := _TotalInclVAT;
                "NS_Installation Subtotal" := InstallAmt;
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
        end;


        // Service Subtotal
        ServiceAmt := GetSubtotals(_QuoteHeader, 5);
        if ServiceAmt <> 0 then begin
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 38;
                NS_Amount := _Total;
                "NS_Amount Including VAT" := _TotalInclVAT;
                "NS_Service Subtotal" := ServiceAmt;
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
        end;

        BondAmt := GetSubtotals(_QuoteHeader, 4);
        if BondAmt <> 0 then begin
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 37;
                NS_Amount := _Total;
                "NS_Amount Including VAT" := _TotalInclVAT;
                "NS_Bonds Subtotal" := BondAmt;
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
        end;

        with _Buf do begin
            _EntryNo += 1;
            INIT;
            "NS_Entry No." := _EntryNo;
            "NS_Quote No." := _QuoteHeader."NS_Quote No.";
            NS_Indentation := 25;
            NS_Amount := _Total;
            "NS_Amount Including VAT" := _TotalInclVAT;
            "NS_Created by" := USERID;
            _QuoteDoc.InsertTempBuf(_Buf);
        end;


        if not _QuoteHeader."NS_Print Sales Tax" then begin
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 40;
                NS_Description := 'This document does not reflect any applicable sales tax.';
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
        end;


        // document specific scope of work

        _ScopeOfWork.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        if BySegment then begin
            if not _ScopeOfWork.ISEMPTY then begin
                with _Buf do begin
                    _EntryNo += 1;
                    INIT;
                    "NS_Entry No." := _EntryNo;
                    "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                    NS_Indentation := 30;
                    NS_Description := 'SCOPE OF WORK';
                    "NS_Created by" := USERID;
                    _QuoteDoc.InsertTempBuf(_Buf);
                end;
            end;

            if _ScopeOfWork.FINDSET then
                repeat
                    with _Buf do begin
                        _EntryNo += 1;
                        INIT;
                        "NS_No." := _ScopeOfWork."NS_Segment Code";
                        NS_Name := _ScopeOfWork."NS_Segment Name";
                        "NS_Entry No." := _EntryNo;
                        "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                        NS_Indentation := 26;
                        NS_Description := COPYSTR(_ScopeOfWork.NS_Description, 1, MAXSTRLEN(NS_Description)) + ' ' +
                                        COPYSTR(_ScopeOfWork."NS_Description 2", 1, MAXSTRLEN(NS_Description));
                        "NS_Created by" := USERID;
                        _QuoteDoc.InsertTempBuf(_Buf);
                    end;
                until _ScopeOfWork.NEXT = 0;
        end else begin
            if _Proposal then
                if _ScopeOfWork.FINDSET(false) then begin
                    with _Buf do begin
                        _EntryNo += 1;
                        INIT;
                        "NS_Entry No." := _EntryNo;
                        "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                        NS_Indentation := 30;
                        NS_Description := 'SCOPE OF WORK';
                        "NS_Created by" := USERID;
                        _QuoteDoc.InsertTempBuf(_Buf);
                    end;
                    repeat
                        with _Buf do begin
                            _EntryNo += 1;
                            INIT;
                            "NS_Entry No." := _EntryNo;
                            "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                            NS_Indentation := 8;
                            NS_Description := COPYSTR(_ScopeOfWork.NS_Description, 1, MAXSTRLEN(NS_Description)) +
                                           COPYSTR(_ScopeOfWork."NS_Description 2", 1, MAXSTRLEN(NS_Description));
                            "NS_Created by" := USERID;
                            _QuoteDoc.InsertTempBuf(_Buf);
                        end;
                    until _ScopeOfWork.NEXT = 0;
                end;
        end;

        // terms & conditions

        if _Proposal then
            if _TermsConditions.FINDSET(false) then begin
                with _Buf do begin
                    _EntryNo += 1;
                    INIT;
                    "NS_Entry No." := _EntryNo;
                    "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                    NS_Indentation := 30;
                    NS_Description := 'TERMS & CONDITIONS';
                    "NS_Created by" := USERID;
                    _QuoteDoc.InsertTempBuf(_Buf);
                end;
                repeat
                    with _Buf do begin
                        _EntryNo += 1;
                        INIT;
                        "NS_Entry No." := _EntryNo;
                        "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                        NS_Indentation := 5;
                        NS_Description := COPYSTR(_TermsConditions."NS_Text Value", 1, MAXSTRLEN(NS_Description));
                        "NS_Created by" := USERID;
                        _QuoteDoc.InsertTempBuf(_Buf);
                    end;
                until _TermsConditions.NEXT = 0;
            end;

        // acceptance

        if _Proposal then begin
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 5;
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 30;
                NS_Description := 'ACCEPTANCE';
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 5;
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 5;
                NS_Description := 'This proposal, when accepted by the purchaser, and final approval of ' +
                               'Seller''s Official Officer, will constitute a bona fide contract ' +
                               'between us, subject to all terms and conditions on the reverse side.';
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 5;
                NS_Description := 'It is expressly agreed that there are no promises, agreements or ' +
                               'understandings, oral or written, not specified in this proposal.';
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 5;
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 5;
                NS_Description := 'Company Name _____________________________________________________________';
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 5;
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 5;
                NS_Description := 'Signature ______________________________________________ Date _______________';
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 5;
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 5;
                NS_Description := 'Print Name _________________________________________________________________';
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 5;
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 5;
                NS_Description := 'Print Title __________________________________________________________________';
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
        end;

        // run the report

        COMMIT;
        _QuoteDoc.SetBySegment(BySegment);
        _QuoteDoc.RUN;

        _Buf.RESET;
        _Buf.SETCURRENTKEY("NS_Quote No.", "NS_Created by");
        _Buf.SETRANGE("NS_Created by", USERID);
        _Buf.DELETEALL;

    end;

    procedure NS_PrintQuote(_QuoteHeader: Record "NS_Job Quote Header"; _UseSystemPrinter: Boolean);
    var
        _AttributeSetEntry: Record "NS_Job Quote Attribute Set Ent";
        _Buf: Record "NS_Job Quote Sel. Buf." temporary;
        _ItemCategory: Record "Item Category";
        _FeatureText: Record "NS_Job Quote Feature Text";
        _QuoteComment: Record "Comment Line";
        _QuoteLine: Record "NS_Job Quote Line";
        _Text000: Label 'Generally, quotes exceeding a system tolerance must be reviewed before the Status is set to Released.  The current status is %1.  Are you sure you want to print the document?';
        _QuoteLine2: Record "NS_Job Quote Line";
        _ScopeOfWork: Record "NS_Job Quote Scope of Work";
        _TermsConditions: Record NS_JobQuoteTermsConditions;
        _Proposal: Boolean;
        _CategoryCode: Code[10];
        _Total: Decimal;
        _TotalInclVAT: Decimal;
        _EntryNo: Integer;
        _Text001: Label 'Features';
        _QuoteDoc: Report "NS_Job Quote/Proposal";
        _Text002: Label 'The quote is set to print Sales Tax, but the document must be released first.';
        Attribute: Record "NS_Job Quote Attribute";
        FreightAmt: Decimal;
        EquipmentAmt: Decimal;
        InstallAmt: Decimal;
        BondAmt: Decimal;
        ServiceAmt: Decimal;
        _QuoteTaskLines: Record "Job Task";
        Segment: Record "NS_Job Takeoff Segments";
        TotalBySegment: Decimal;
        QuoteSetup: Record "Jobs Setup";
        NSQuoteStatus: enum "NS_Quote Status";  //PE-300.JS.1.0 29JULY2024
        NSQuoteStatusInt: Integer; //PE-300.JS.1.0 29JULY2024        
    begin
        CLEAR(_QuoteDoc);
        //PE-300.JS.1.0 29JULY2024
        Clear(NSQuoteStatusInt);
        NSQuoteStatus := NSQuoteStatus::Released;
        NSQuoteStatusInt := NSQuoteStatus.AsInteger();
        //PE-300.JS.1.0 29JULY2024        
        _QuoteDoc.Initialize(_QuoteHeader);
        _Proposal := not _QuoteHeader."NS_Equipment Only";

        _Proposal := true;

        _QuoteDoc.SetProposal;

        /*IF _QuoteHeader."Use Tax Liable" <> _QuoteHeader."Use Tax Liable"::Yes THEN
          IF _QuoteHeader."Print Sales Tax" THEN
            IF _QuoteHeader.Status < _QuoteHeader.Status::Released THEN
              ERROR(_Text002);*/

        // initialize recordset

        CLEAR(_Buf);
        _Buf.DELETEALL;
        if _UseSystemPrinter then
            _QuoteDoc.USEREQUESTPAGE(false);

        _Buf.RESET;
        if _Buf.FINDLAST then
            _EntryNo := _Buf."NS_Entry No.";

        _Buf.SETCURRENTKEY("NS_Quote No.", "NS_Created by");
        _Buf.SETRANGE("NS_Created by", USERID);
        _Buf.DELETEALL;
        _Buf.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");

        // set draft/"Internal Use Only"

        if _Proposal then
            //PE-300-DK.1.0 29May2024 Start
            //if _QuoteHeader.NS_Status < _QuoteHeader.NS_Status::Released then
            if _QuoteHeader."NS_Quote Status".AsInteger() < NSQuoteStatusInt then  //PE-300.JS.1.0 29July2024
                //PE-300-DK.1.0 29May2024 End
                if not GUIALLOWED then
                    exit
                else
                    _QuoteDoc.SetDraft(true);

        // build dataset

        // Header Comments
        _QuoteComment.RESET;
        _QuoteComment.SETRANGE("No.", _QuoteHeader."NS_Quote No.");
        _QuoteComment.SETRANGE("Line No.", 0);
        //_QuoteComment.SETRANGE("Print On Quote",TRUE);
        _QuoteComment.SETFILTER(Comment, '<>%1', '');
        if _Proposal then
            if _QuoteComment.FINDSET(false) then begin
                with _Buf do begin
                    _EntryNo += 1;
                    INIT;
                    "NS_Entry No." := _EntryNo;
                    "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                    NS_Indentation := 10;
                    NS_Description := 'Comments';
                    "NS_Created by" := USERID;
                    _QuoteDoc.InsertTempBuf(_Buf);
                end;
                repeat
                    with _Buf do begin
                        _EntryNo += 1;
                        INIT;
                        "NS_Entry No." := _EntryNo;
                        "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                        NS_Indentation := 5;
                        NS_Description := COPYSTR(_QuoteComment.Comment, 1, MAXSTRLEN(NS_Description));
                        "NS_Created by" := USERID;
                        _QuoteDoc.InsertTempBuf(_Buf);
                    end;
                until _QuoteComment.NEXT = 0;
            end;

        // if no quote lines exist, ensure filters in place ...
        // first, line-specific scope-of-work recs are added to the print records, then
        // document-specific, outside the REPEAT..UNTIL loop for the lines

        // Headings
        with _Buf do begin
            _EntryNo += 1;
            INIT;
            "NS_Entry No." := _EntryNo;
            "NS_Quote No." := _QuoteHeader."NS_Quote No.";
            NS_Indentation := 55;
            NS_Description := '';
            "NS_Created by" := USERID;
            _QuoteDoc.InsertTempBuf(_Buf);
        end;

        _QuoteLine.RESET;
        _QuoteLine.SETCURRENTKEY("NS_Category Code", "NS_Quote Line No.");
        _QuoteLine.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        _QuoteLine.SETRANGE("NS_Attached to Line No.", 0);
        _QuoteLine.SETFILTER(NS_Type, '<>%1', _QuoteLine.NS_Type::Template);

        if _QuoteLine.FINDSET(false) then
            repeat

                // category heading

                if _Proposal then
                    if _CategoryCode <> _QuoteLine."NS_Category Code" then
                        with _Buf do begin
                            _CategoryCode := _QuoteLine."NS_Category Code";
                            if not _ItemCategory.GET(_CategoryCode) then
                                _ItemCategory.INIT;
                            _EntryNo += 1;
                            INIT;
                            "NS_Entry No." := _EntryNo;
                            "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                            NS_Indentation := 20;
                            NS_Description := _ItemCategory.Description;
                            "NS_Created by" := USERID;
                            _QuoteDoc.InsertTempBuf(_Buf);
                        end;

                // quote line

                with _Buf do begin
                    _EntryNo += 1;
                    INIT;
                    "NS_Entry No." := _EntryNo;
                    "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                    NS_Type := _QuoteLine.NS_Type;
                    "NS_No." := _QuoteLine."NS_No.";
                    if _QuoteLine."NS_No. 2" = '' then
                        "NS_No. 2" := _QuoteLine."NS_No."
                    else
                        "NS_No. 2" := _QuoteLine."NS_No. 2";
                    NS_Description := COPYSTR(_QuoteLine.NS_Description, 1, MAXSTRLEN(NS_Description));
                    NS_Quantity := _QuoteLine.NS_Quantity;
                    "NS_Unit of Measure Code" := _QuoteLine."NS_Unit of Measure Code";
                    if NS_Quantity <> 0 then
                        "NS_Total Price" := ROUND(_QuoteLine.NS_Amount / _QuoteLine.NS_Quantity, 0.01)
                    else
                        "NS_Total Price" := _QuoteLine."NS_Total Price";
                    NS_Amount := _QuoteLine.NS_Amount;
                    "NS_Amount Including VAT" := _QuoteLine."NS_Amount Including VAT";
                    "NS_Line Discount Amount" := _QuoteLine."NS_Line Discount Amount";
                    "NS_Line Discount %" := _QuoteLine."NS_Line Discount %";
                    "NS_Created by" := USERID;
                    _Total += NS_Amount;
                    _TotalInclVAT += "NS_Amount Including VAT";
                    if _QuoteHeader."NS_Lump Sum" then begin
                        "NS_Total Price" := 0;
                        NS_Amount := 0;
                    end;
                    _QuoteDoc.InsertTempBuf(_Buf);
                end;

                // "includes" section

                _QuoteLine2.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
                _QuoteLine2.SETRANGE("NS_Attached to Line No.", _QuoteLine."NS_Quote Line No.");
                if _QuoteLine2.FINDSET(false) then begin
                    with _Buf do begin
                        _EntryNo += 1;
                        INIT;
                        "NS_Entry No." := _EntryNo;
                        "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                        NS_Indentation := 10;
                        NS_Description := 'Includes';
                        "NS_Created by" := USERID;
                        _QuoteDoc.InsertTempBuf(_Buf);
                    end;
                    repeat
                        with _Buf do begin
                            _EntryNo += 1;
                            INIT;
                            "NS_Entry No." := _EntryNo;
                            "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                            NS_Indentation := 11;
                            NS_Type := _QuoteLine2.NS_Type;
                            "NS_No." := _QuoteLine2."NS_No.";
                            if _QuoteLine2."NS_No. 2" = '' then
                                "NS_No. 2" := _QuoteLine2."NS_No."
                            else
                                "NS_No. 2" := _QuoteLine2."NS_No. 2";
                            if _QuoteLine2."NS_No. 2" <> '' then
                                NS_Description := _QuoteLine2."NS_No. 2" + ' - ';
                            NS_Description := COPYSTR(NS_Description + _QuoteLine2.NS_Description, 1, MAXSTRLEN(NS_Description));
                            NS_Quantity := _QuoteLine2.NS_Quantity;
                            "NS_Unit of Measure Code" := _QuoteLine2."NS_Unit of Measure Code";
                            "NS_Created by" := USERID;
                            _QuoteDoc.InsertTempBuf(_Buf);
                        end;
                    until _QuoteLine2.NEXT = 0;
                end;

                // attributes/configuration

                if _QuoteLine."NS_Attribute Set Entry No." <> 0 then begin
                    _AttributeSetEntry.SETRANGE("NS_Attribute Set ID", _QuoteLine."NS_Attribute Set Entry No.");
                    _AttributeSetEntry.SETFILTER("NS_Text Value", '<>%1', 'NO');
                    if _AttributeSetEntry.FINDSET(false) then begin
                        with _Buf do begin
                            _EntryNo += 1;
                            INIT;
                            "NS_Entry No." := _EntryNo;
                            "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                            NS_Indentation := 10;
                            NS_Description := 'Configuration';
                            "NS_Created by" := USERID;
                            _QuoteDoc.InsertTempBuf(_Buf);
                        end;
                        repeat
                            with _Buf do begin
                                _EntryNo += 1;
                                INIT;
                                "NS_Entry No." := _EntryNo;
                                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                                NS_Indentation := 5;
                                if Attribute.GET(_AttributeSetEntry."NS_Attribute Code") then;
                                if Attribute.NS_Description <> '' then
                                    NS_Description := COPYSTR(STRSUBSTNO('%1: %2'
                                                                   , Attribute.NS_Description
                                                                   , _AttributeSetEntry."NS_Text Value"), 1, MAXSTRLEN(NS_Description))
                                else
                                    NS_Description := COPYSTR(STRSUBSTNO('%1: %2'
                                                                   , Attribute.NS_Code
                                                                   , _AttributeSetEntry."NS_Text Value"), 1, MAXSTRLEN(NS_Description));
                                "NS_Created by" := USERID;
                                _QuoteDoc.InsertTempBuf(_Buf);
                            end;
                        until _AttributeSetEntry.NEXT = 0;
                    end;
                end;

                // add features

                _FeatureText.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
                _FeatureText.SETRANGE("NS_Quote Line No.", _QuoteLine."NS_Quote Line No.");
                if _FeatureText.FINDSET(false) then begin
                    with _Buf do begin
                        _EntryNo += 1;
                        INIT;
                        "NS_Entry No." := _EntryNo;
                        "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                        NS_Indentation := 10;
                        NS_Description := 'Features';
                        "NS_Created by" := USERID;
                        _QuoteDoc.InsertTempBuf(_Buf);
                    end;
                    repeat
                        with _Buf do begin
                            _EntryNo += 1;
                            INIT;
                            "NS_Entry No." := _EntryNo;
                            "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                            NS_Indentation := 5;
                            NS_Description := COPYSTR(_FeatureText."NS_Text Value", 1, MAXSTRLEN(NS_Description));
                            "NS_Created by" := USERID;
                            _QuoteDoc.InsertTempBuf(_Buf);
                        end;
                    until _FeatureText.NEXT = 0;
                end;

                // line specific scope of work

                /*_ScopeOfWork.SETRANGE("Quote No.",_QuoteHeader."Quote No.");
                _ScopeOfWork.SETRANGE("Quote Line No.",_QuoteLine."Quote Line No.");
                _ScopeOfWork.SETRANGE("Quote Line No.",TRUE);
                IF _Proposal THEN
                  IF _ScopeOfWork.FINDSET(FALSE) THEN BEGIN
                    WITH _Buf DO BEGIN
                      _EntryNo += 1;
                      INIT;
                      "Entry No." := _EntryNo;
                      "Quote No." := _QuoteHeader."Quote No.";
                      Indentation := 10;
                      Description := 'Scope of Work';
                      "Created by" := USERID;
                      _QuoteDoc.InsertTempBuf(_Buf);
                    END;
                    REPEAT
                      WITH _Buf DO BEGIN
                        _EntryNo += 1;
                        INIT;
                        "Entry No." := _EntryNo;
                        "Quote No." := _QuoteHeader."Quote No.";
                        Indentation := 5;
                        Description := COPYSTR(_ScopeOfWork."Text Value",1,MAXSTRLEN(Description));
                        "Created by" := USERID;
                        _QuoteDoc.InsertTempBuf(_Buf);
                      END;
                    UNTIL _ScopeOfWork.NEXT = 0;
                  END;*/

                // comments

                _QuoteComment.SETRANGE("No.", _QuoteLine."NS_Quote No.");
                _QuoteComment.SETRANGE("Line No.", _QuoteLine."NS_Quote Line No.");
                //_QuoteComment.SETRANGE("Print On Quote",TRUE);
                _QuoteComment.SETFILTER(Comment, '<>%1', '');
                if _Proposal then
                    if _QuoteComment.FINDSET(false) then begin
                        with _Buf do begin
                            _EntryNo += 1;
                            INIT;
                            "NS_Entry No." := _EntryNo;
                            "NS_No." := _QuoteHeader."NS_Quote No.";
                            NS_Indentation := 10;
                            NS_Description := 'Comments';
                            "NS_Created by" := USERID;
                            _QuoteDoc.InsertTempBuf(_Buf);
                        end;
                        repeat
                            with _Buf do begin
                                _EntryNo += 1;
                                INIT;
                                "NS_Entry No." := _EntryNo;
                                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                                NS_Indentation := 5;
                                NS_Description := COPYSTR(_QuoteComment.Comment, 1, MAXSTRLEN(NS_Description));
                                "NS_Created by" := USERID;
                                _QuoteDoc.InsertTempBuf(_Buf);
                            end;
                        until _QuoteComment.NEXT = 0;
                    end;

            until _QuoteLine.NEXT = 0;

        //Task Lines Start
        QuoteSetup.GET;

        _QuoteTaskLines.SETRANGE("Job Task Type", _QuoteTaskLines."Job Task Type"::"End-Total");
        _QuoteTaskLines.SETRANGE("Job No.", _QuoteHeader."NS_Job No.");
        _QuoteTaskLines.SETFILTER("Job Task No.", '<>%1', QuoteSetup."NS_Total Task No.");
        if _QuoteTaskLines.FINDSET(false, false) then
            repeat
                _QuoteTaskLines.CALCFIELDS("Schedule (Total Price)", "NS_Line Amount Incl. Tax");
                with _Buf do begin
                    _EntryNo += 1;
                    INIT;
                    "NS_Entry No." := _EntryNo;
                    "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                    NS_Type := _QuoteTaskLines."Job Task Type";
                    "NS_No." := _QuoteTaskLines."Job Task No.";
                    "NS_No. 2" := _QuoteTaskLines."Job Task No.";
                    NS_Description := COPYSTR(_QuoteTaskLines.Description, 1, MAXSTRLEN(NS_Description));
                    NS_Quantity := 0;
                    "NS_Total Price" := ROUND(_QuoteTaskLines."Schedule (Total Price)", 0.01);
                    NS_Amount := _QuoteTaskLines."Schedule (Total Price)";
                    "NS_Amount Including VAT" := _QuoteTaskLines."NS_Line Amount Incl. Tax";
                    "NS_Created by" := USERID;
                    _Total += NS_Amount;
                    _TotalInclVAT += "NS_Amount Including VAT";
                    if _QuoteHeader."NS_Lump Sum" then begin
                        "NS_Total Price" := 0;
                        NS_Amount := 0;
                    end;
                    _QuoteDoc.InsertTempBuf(_Buf);
                end;
            until _QuoteTaskLines.NEXT = 0;
        //Task Lines End

        //Moved this section down to get Segments to Print after Header line (indentation = 55)
        //Get Totals summarized by Segment
        if BySegment then begin
            Segment.RESET;
            Segment.SETRANGE("NS_Job No.", _QuoteHeader."NS_Quote No.");
            if Segment.FINDSET then
                repeat
                    Segment.CALCFIELDS("NS_Schedule (Total Price)");
                    with _Buf do begin
                        _EntryNo += 1;
                        INIT;
                        "NS_Entry No." := _EntryNo;
                        "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                        NS_Indentation := 777;
                        "NS_No." := Segment."NS_Segment Code";
                        NS_Name := Segment."NS_Segment Name";
                        if Segment."NS_Total Contract Price" <> 0 then
                            "NS_Total Price" := Segment."NS_Total Contract Price"
                        else
                            "NS_Total Price" := Segment."NS_Schedule (Total Price)";
                        TotalBySegment += "NS_Total Price";
                        "NS_Created by" := USERID;
                        _QuoteDoc.InsertTempBuf(_Buf);
                    end;
                until Segment.NEXT = 0;
            if TotalBySegment <> 0 then begin
                with _Buf do begin
                    _EntryNo += 1;
                    INIT;
                    "NS_Entry No." := _EntryNo;
                    "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                    NS_Indentation := 777;
                    NS_Name := 'GRAND TOTAL';
                    "NS_Total Price" := TotalBySegment;
                    _QuoteDoc.InsertTempBuf(_Buf);
                end;
            end;
        end;

        // document total
        // For adding space between total and lines

        with _Buf do begin
            _EntryNo += 1;
            INIT;
            "NS_Entry No." := _EntryNo;
            "NS_Quote No." := _QuoteHeader."NS_Quote No.";
            NS_Indentation := 5;
            NS_Description := '                ';
            "NS_Created by" := USERID;
            _QuoteDoc.InsertTempBuf(_Buf);
        end;

        // Equipment Subtotal
        EquipmentAmt := GetSubtotals(_QuoteHeader, 2);
        if EquipmentAmt <> 0 then begin
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 34;
                NS_Amount := _Total;
                "NS_Amount Including VAT" := _TotalInclVAT;
                "NS_Equipment Subtotal" := EquipmentAmt;
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
        end;


        // For Sales Tax to print after equipment subtotal
        with _Buf do begin
            _EntryNo += 1;
            INIT;
            "NS_Entry No." := _EntryNo;
            "NS_Quote No." := _QuoteHeader."NS_Quote No.";
            NS_Indentation := 39;
            NS_Amount := _Total;
            "NS_Amount Including VAT" := _TotalInclVAT;
            "NS_Created by" := USERID;
            _QuoteDoc.InsertTempBuf(_Buf);
        end;


        // Freight Subtotal
        FreightAmt := GetSubtotals(_QuoteHeader, 1);
        if FreightAmt <> 0 then begin
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 35;
                NS_Amount := _Total;
                "NS_Amount Including VAT" := _TotalInclVAT;
                NS_Freight := FreightAmt;
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
        end;

        // Installation Subtotal
        InstallAmt := GetSubtotals(_QuoteHeader, 3);
        if InstallAmt <> 0 then begin
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 36;
                NS_Amount := _Total;
                "NS_Amount Including VAT" := _TotalInclVAT;
                "NS_Installation Subtotal" := InstallAmt;
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
        end;


        // Service Subtotal
        ServiceAmt := GetSubtotals(_QuoteHeader, 5);
        if ServiceAmt <> 0 then begin
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 38;
                NS_Amount := _Total;
                "NS_Amount Including VAT" := _TotalInclVAT;
                "NS_Service Subtotal" := ServiceAmt;
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
        end;

        BondAmt := GetSubtotals(_QuoteHeader, 4);
        if BondAmt <> 0 then begin
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 37;
                NS_Amount := _Total;
                "NS_Amount Including VAT" := _TotalInclVAT;
                "NS_Bonds Subtotal" := BondAmt;
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
        end;

        with _Buf do begin
            _EntryNo += 1;
            INIT;
            "NS_Entry No." := _EntryNo;
            "NS_Quote No." := _QuoteHeader."NS_Quote No.";
            NS_Indentation := 25;
            NS_Amount := _Total;
            "NS_Amount Including VAT" := _TotalInclVAT;
            "NS_Created by" := USERID;
            _QuoteDoc.InsertTempBuf(_Buf);
        end;


        if not _QuoteHeader."NS_Print Sales Tax" then begin
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 40;
                NS_Description := 'This document does not reflect any applicable sales tax.';
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
        end;


        // document specific scope of work

        _ScopeOfWork.SETRANGE("NS_Quote Line No.", 0);
        _ScopeOfWork.SETRANGE("NS_Quote No.", _QuoteHeader."NS_Quote No.");
        if BySegment then begin
            if not _ScopeOfWork.ISEMPTY then begin
                with _Buf do begin
                    _EntryNo += 1;
                    INIT;
                    "NS_Entry No." := _EntryNo;
                    "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                    NS_Indentation := 30;
                    NS_Description := 'SCOPE OF WORK';
                    "NS_Created by" := USERID;
                    _QuoteDoc.InsertTempBuf(_Buf);
                end;
            end;
            Segment.RESET;
            Segment.SETRANGE("NS_Job No.", _QuoteHeader."NS_Quote No.");
            if Segment.FINDSET then
                repeat
                    _ScopeOfWork.SETRANGE("NS_Segment Code", Segment."NS_Segment Code");
                    if _ScopeOfWork.FINDSET then
                        repeat
                            with _Buf do begin
                                _EntryNo += 1;
                                INIT;
                                "NS_No." := _ScopeOfWork."NS_Segment Code";
                                NS_Name := Segment."NS_Segment Name";
                                "NS_Entry No." := _EntryNo;
                                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                                NS_Indentation := 26;
                                NS_Description := COPYSTR(_ScopeOfWork.NS_Description, 1, MAXSTRLEN(NS_Description)) +
                                                COPYSTR(_ScopeOfWork."NS_Description 2", 1, MAXSTRLEN(NS_Description));
                                "NS_Created by" := USERID;
                                _QuoteDoc.InsertTempBuf(_Buf);
                            end;
                        until _ScopeOfWork.NEXT = 0;
                until Segment.NEXT = 0;
        end else begin
            if _Proposal then
                if _ScopeOfWork.FINDSET(false) then begin
                    with _Buf do begin
                        _EntryNo += 1;
                        INIT;
                        "NS_Entry No." := _EntryNo;
                        "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                        NS_Indentation := 30;
                        NS_Description := 'SCOPE OF WORK';
                        "NS_Created by" := USERID;
                        _QuoteDoc.InsertTempBuf(_Buf);
                    end;
                    repeat
                        with _Buf do begin
                            _EntryNo += 1;
                            INIT;
                            "NS_Entry No." := _EntryNo;
                            "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                            NS_Indentation := 8;
                            NS_Description := COPYSTR(_ScopeOfWork.NS_Description, 1, MAXSTRLEN(NS_Description)) +
                                           COPYSTR(_ScopeOfWork."NS_Description 2", 1, MAXSTRLEN(NS_Description));
                            "NS_Created by" := USERID;
                            _QuoteDoc.InsertTempBuf(_Buf);
                        end;
                    until _ScopeOfWork.NEXT = 0;
                end;
        end;

        // terms & conditions

        if _Proposal then
            if _TermsConditions.FINDSET(false) then begin
                with _Buf do begin
                    _EntryNo += 1;
                    INIT;
                    "NS_Entry No." := _EntryNo;
                    "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                    NS_Indentation := 30;
                    NS_Description := 'TERMS & CONDITIONS';
                    "NS_Created by" := USERID;
                    _QuoteDoc.InsertTempBuf(_Buf);
                end;
                repeat
                    with _Buf do begin
                        _EntryNo += 1;
                        INIT;
                        "NS_Entry No." := _EntryNo;
                        "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                        NS_Indentation := 5;
                        NS_Description := COPYSTR(_TermsConditions."NS_Text Value", 1, MAXSTRLEN(NS_Description));
                        "NS_Created by" := USERID;
                        _QuoteDoc.InsertTempBuf(_Buf);
                    end;
                until _TermsConditions.NEXT = 0;
            end;

        // acceptance

        if _Proposal then begin
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 5;
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 30;
                NS_Description := 'ACCEPTANCE';
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 5;
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 5;
                NS_Description := 'This proposal, when accepted by the purchaser, and final approval of ' +
                               'Seller''s Official Officer, will constitute a bona fide contract ' +
                               'between us, subject to all terms and conditions on the reverse side.';
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 5;
                NS_Description := 'It is expressly agreed that there are no promises, agreements or ' +
                               'understandings, oral or written, not specified in this proposal.';
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 5;
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 5;
                NS_Description := 'Company Name _____________________________________________________________';
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 5;
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 5;
                NS_Description := 'Signature ______________________________________________ Date _______________';
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 5;
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 5;
                NS_Description := 'Print Name _________________________________________________________________';
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 5;
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
            with _Buf do begin
                _EntryNo += 1;
                INIT;
                "NS_Entry No." := _EntryNo;
                "NS_Quote No." := _QuoteHeader."NS_Quote No.";
                NS_Indentation := 5;
                NS_Description := 'Print Title __________________________________________________________________';
                "NS_Created by" := USERID;
                _QuoteDoc.InsertTempBuf(_Buf);
            end;
        end;

        // run the report

        COMMIT;
        _QuoteDoc.SetBySegment(BySegment);
        _QuoteDoc.RUN;

        _Buf.RESET;
        _Buf.SETCURRENTKEY("NS_Quote No.", "NS_Created by");
        _Buf.SETRANGE("NS_Created by", USERID);
        _Buf.DELETEALL;

    end;

    procedure NS_SetDisableJobTaskLoad(PassDisableJobTaskLoad: Boolean);
    begin
        DisableJobTaskLoad := PassDisableJobTaskLoad;
    end;

    local procedure NS_UpdateSegmentAmounts(var Rec: Record "NS_Job Takeoff Segments");
    var
        TotalPrice: Decimal;
    begin
        with Rec do begin
            CALCFIELDS("NS_Schedule (Total Cost)", "NS_Schedule (Total Price)");
            //PRJ-1104.AS.1.0 START Commented Code //PRJ-1104.JS.1.0 02FEB2022
            if "NS_Total Contract Price" = 0 then
                TotalPrice := "NS_Schedule (Total Price)"
            else
                TotalPrice := "NS_Total Contract Price";
            //PRJ-1104.AS.1.0 END Commented Code  //PRJ-1104.JS.1.0 02FEB2022
            //TotalPrice := "NS_Schedule (Total Price)";//PRJ-1104.AS.1.0 Added code line commented //PRJ-1104.JS.1.0 02FEB2022

            if TotalPrice <> 0 then begin
                if "NS_Schedule (Total Cost)" <> 0 then
                    "NS_Mark-up" := ((TotalPrice - "NS_Schedule (Total Cost)") / "NS_Schedule (Total Cost)") * 100;
                "NS_Gross Profit" := TotalPrice - "NS_Schedule (Total Cost)";
                "NS_Gross Profit Percent" := ("NS_Gross Profit" / TotalPrice) * 100;
            end else begin
                "NS_Mark-up" := 0;
                "NS_Gross Profit" := 0;
                "NS_Gross Profit Percent" := 0;
            end;
            MODIFY();
        end;
    end;

    local procedure NS_CopyQuoteJobTasksToJob(JobQuoteHeader: Record "NS_Job Quote Header"; Job: Record Job);
    var
        QuoteJobTask: Record "Job Task";
        JobTask: Record "Job Task";
    begin
        QuoteJobTask.SETRANGE("Job No.", JobQuoteHeader."NS_Quote No.");
        if QuoteJobTask.FINDSET then
            repeat
                JobTask.INIT;
                JobTask := QuoteJobTask;
                JobTask."Job No." := Job."No.";
                JobTask.INSERT;
            until QuoteJobTask.NEXT = 0;
    end;

    //PRJ-914.AS.1.0 - START
    local procedure NS_CopyQuoteJobTasksToJobChangeOrder(Updatejob: Record Job; Job: Record Job);
    var
        QuoteJobTask: Record "Job Task";
        JobTask: Record "Job Task";
    begin
        QuoteJobTask.SETRANGE("Job No.", Updatejob."No.");
        if QuoteJobTask.FINDSET then
            repeat
                JobTask.INIT;
                JobTask := QuoteJobTask;
                JobTask."Job No." := Job."No.";
                JobTask.INSERT;
            until QuoteJobTask.NEXT = 0;
    end;
    //PRJ-914.AS.1.0 - END

    local procedure NS_DeleteQuoteJobTasks(JobQuoteHeader: Record "NS_Job Quote Header");
    var
        QuoteJobTask: Record "Job Task";
    begin
        QuoteJobTask.SETRANGE("Job No.", JobQuoteHeader."NS_Quote No.");
        if QuoteJobTask.FINDSET then
            QuoteJobTask.DELETEALL;
    end;

    local procedure NS_CopyQuoteJPLToJob(JobQuoteHeader: Record "NS_Job Quote Header"; Job: Record Job);
    var
        QuoteJPL: Record "Job Planning Line";
        JPL: Record "Job Planning Line";
    begin
        QuoteJPL.SETRANGE("Job No.", JobQuoteHeader."NS_Quote No.");
        if QuoteJPL.FINDSET then
            repeat
                JPL.INIT;
                JPL := QuoteJPL;
                JPL."Job No." := Job."No.";
                JPL.INSERT;
            until QuoteJPL.NEXT = 0;
    end;

    //PRJ-914.AS.1.0 - START
    local procedure NS_CopyQuoteJPLToJobChangeOrder(UpdateJob: Record Job; Job: Record Job);
    var
        QuoteJPL: Record "Job Planning Line";
        JPL: Record "Job Planning Line";
    begin
        QuoteJPL.SETRANGE("Job No.", UpdateJob."No.");
        if QuoteJPL.FINDSET then
            repeat
                JPL.INIT;
                JPL := QuoteJPL;
                JPL."Job No." := Job."No.";
                JPL.INSERT;
            until QuoteJPL.NEXT = 0;
    end;
    //PRJ-914.AS.1.0 - END

    local procedure NS_DeleteQuoteJPL(JobQuoteHeader: Record "NS_Job Quote Header");
    var
        QuoteJPL: Record "Job Planning Line";
    begin
        QuoteJPL.SETRANGE("Job No.", JobQuoteHeader."NS_Quote No.");
        if QuoteJPL.FINDSET then
            QuoteJPL.DELETEALL;
    end;

    procedure NS_LoadAssemblyBOM(JobQuoteBOM: Record "NS_Job Quote Assembly BOM Line");
    var
        JobQuote: Record "NS_Job Quote Header";
        I: Integer;
        JPL: Record "Job Planning Line";
        TempJPL: Record "Job Planning Line" temporary;
        LineNo: Integer;
    begin
        if not JobQuote.GET(JobQuoteBOM."NS_Quote No.") then
            exit;

        TempJPL.DELETEALL;
        for I := 1 to JobQuoteBOM.NS_Quantity do
            NS_CreateBOMJobPlanningLines(TempJPL, JobQuoteBOM."NS_Quote No.", JobQuoteBOM."NS_No.");

        TempJPL.RESET;
        if TempJPL.FINDSET then
            repeat
                JPL.INIT;
                JPL := TempJPL;
                JPL.INSERT;
            until TempJPL.NEXT = 0;
    end;

    local procedure NS_CreateBOMJobPlanningLines(var TempJPL: Record "Job Planning Line" temporary; JobQuoteNo: Code[20]; BOMNo: Code[20]);
    var
        AssemblyBOMLine: Record "NS_Assembly BOM Line";
        JPL: Record "Job Planning Line";
        LineNoToUse: Integer;
        LineNoJPL: Integer;
        LineNoTempJPL: Integer;
    begin
        AssemblyBOMLine.SETRANGE("NS_Assemby BOM No.", BOMNo);
        if AssemblyBOMLine.FINDSET then
            repeat
                if AssemblyBOMLine.NS_Type = AssemblyBOMLine.NS_Type::BOM then
                    NS_CreateBOMJobPlanningLines(TempJPL, JobQuoteNo, AssemblyBOMLine."NS_No.")
                else begin
                    TempJPL.RESET;
                    TempJPL.SETCURRENTKEY(Type, "No.", "Job No.", "Job Task No.", "Usage Link", "System-Created Entry");
                    TempJPL.SETRANGE("Job No.", JobQuoteNo);
                    TempJPL.SETRANGE("No.", AssemblyBOMLine."NS_No.");
                    TempJPL.SETRANGE("Job Task No.", AssemblyBOMLine."NS_Job Task No.");
                    case AssemblyBOMLine.NS_Type of
                        AssemblyBOMLine.NS_Type::Item:
                            TempJPL.SETRANGE(Type, TempJPL.Type::Item);
                        AssemblyBOMLine.NS_Type::Resource:
                            TempJPL.SETRANGE(Type, TempJPL.Type::Resource);
                    end;

                    if not TempJPL.FINDFIRST then begin

                        //determine line no. to use
                        //Job No.,Job Task No.,Line No.
                        JPL.RESET;
                        JPL.SETRANGE("Job No.", JobQuoteNo);
                        JPL.SETRANGE("Job Task No.", AssemblyBOMLine."NS_Job Task No.");
                        if JPL.FINDLAST then
                            LineNoJPL := JPL."Line No." + 10000
                        else
                            LineNoJPL := 10000;

                        TempJPL.RESET;
                        TempJPL.SETRANGE("Job No.", JobQuoteNo);
                        TempJPL.SETRANGE("Job Task No.", AssemblyBOMLine."NS_Job Task No.");
                        if TempJPL.FINDLAST then
                            LineNoTempJPL := TempJPL."Line No." + 10000
                        else
                            LineNoTempJPL := 10000;

                        if LineNoTempJPL > LineNoJPL then
                            LineNoToUse := LineNoTempJPL
                        else
                            LineNoToUse := LineNoJPL;

                        TempJPL.INIT;
                        TempJPL."Job No." := JobQuoteNo;
                        TempJPL."Line No." := LineNoToUse;
                        TempJPL."NS_Quote No." := JobQuoteNo;
                        case AssemblyBOMLine.NS_Type of
                            AssemblyBOMLine.NS_Type::Item:
                                TempJPL.Type := TempJPL.Type::Item;
                            AssemblyBOMLine.NS_Type::Resource:
                                TempJPL.Type := TempJPL.Type::Resource;
                        end;
                        TempJPL.VALIDATE(Type);
                        TempJPL.VALIDATE("No.", AssemblyBOMLine."NS_No.");
                        TempJPL."Job Task No." := AssemblyBOMLine."NS_Job Task No.";
                        TempJPL.INSERT(true);
                    end;

                    TempJPL.Quantity += AssemblyBOMLine."NS_Quantity per";
                    TempJPL.VALIDATE(Quantity);
                    TempJPL.MODIFY;
                end;

            until AssemblyBOMLine.NEXT = 0;
    end;

    //PRJ-774.AS.1.0 - start Function to move JPL data to ArchiveJPL
    procedure NS_MovePlanninglinedatatoArchive(qQuoteHeader_L: Record "NS_Job Quote Header");
    var
        PlanLine_L: Record "Job Planning Line";
        ArchivePlanLine_L: Record "NS_Archived QuotePlanningLine";
    begin
        PlanLine_L.RESET;
        PlanLine_L.SETRANGE("Job No.", qQuoteHeader_L."NS_Job No.");
        if PlanLine_L.FINDSET then
            repeat
                ArchivePlanLine_L.INIT;
                ArchivePlanLine_L."NS_Line No." := PlanLine_L."Line No.";
                ArchivePlanLine_L."NS_Job No." := PlanLine_L."Job No.";
                ArchivePlanLine_L."NS_Planning Date" := PlanLine_L."Planning Date";
                ArchivePlanLine_L."NS_Document No." := PlanLine_L."Document No.";
                ArchivePlanLine_L.NS_Type := PlanLine_L.Type;
                ArchivePlanLine_L."NS_No." := PlanLine_L."No.";
                ArchivePlanLine_L.NS_Description := PlanLine_L.Description;
                ArchivePlanLine_L.NS_Quantity := PlanLine_L.Quantity;
                ArchivePlanLine_L."NS_Direct Unit Cost (LCY)" := PlanLine_L."Direct Unit Cost (LCY)";
                ArchivePlanLine_L."NS_Unit Cost (LCY)" := PlanLine_L."Unit Cost (LCY)";
                ArchivePlanLine_L."NS_Total Cost (LCY)" := PlanLine_L."Total Cost (LCY)";
                ArchivePlanLine_L."NS_Unit Price (LCY)" := PlanLine_L."Unit Price (LCY)";
                ArchivePlanLine_L."NS_Total Price (LCY)" := PlanLine_L."Total Price (LCY)";
                ArchivePlanLine_L."NS_Resource Group No." := PlanLine_L."Resource Group No.";
                ArchivePlanLine_L."NS_Unit of Measure Code" := PlanLine_L."Unit of Measure Code";
                ArchivePlanLine_L."NS_Location Code" := PlanLine_L."Location Code";
                ArchivePlanLine_L."NS_Last Date Modified" := PlanLine_L."Last Date Modified";
                ArchivePlanLine_L."NS_User ID" := PlanLine_L."User ID";
                ArchivePlanLine_L."NS_Work Type Code" := PlanLine_L."Work Type Code";
                ArchivePlanLine_L."NS_Customer Price Group" := PlanLine_L."Customer Price Group";
                ArchivePlanLine_L."NS_Country/Region Code" := PlanLine_L."Country/Region Code";
                ArchivePlanLine_L."NS_Gen. Bus. Posting Group" := PlanLine_L."Gen. Bus. Posting Group";
                ArchivePlanLine_L."NS_Gen. Prod. Posting Group" := PlanLine_L."Gen. Prod. Posting Group";
                ArchivePlanLine_L."NS_Document Date" := PlanLine_L."Document Date";
                ArchivePlanLine_L."NS_Job Task No." := PlanLine_L."Job Task No.";
                ArchivePlanLine_L."NS_Line Amount (LCY)" := PlanLine_L."Line Amount (LCY)";
                ArchivePlanLine_L."NS_Unit Cost" := PlanLine_L."Unit Cost";
                ArchivePlanLine_L."NS_Total Cost" := PlanLine_L."Total Cost";
                ArchivePlanLine_L."NS_Unit Price" := PlanLine_L."Unit Price";
                ArchivePlanLine_L."NS_Total Price" := PlanLine_L."Total Price";
                ArchivePlanLine_L."NS_Line Amount" := PlanLine_L."Line Amount";
                ArchivePlanLine_L."NS_Line Discount Amount" := PlanLine_L."Line Discount Amount";
                ArchivePlanLine_L."NS_Cost Factor" := PlanLine_L."Cost Factor";
                ArchivePlanLine_L."NS_Serial No." := PlanLine_L."Serial No.";
                ArchivePlanLine_L."NS_Lot No." := PlanLine_L."Lot No.";
                ArchivePlanLine_L."NS_Line Discount %" := PlanLine_L."Line Discount %";
                ArchivePlanLine_L."NS_Line Type" := PlanLine_L."Line Type";
                ArchivePlanLine_L."NS_Currency Code" := PlanLine_L."Currency Code";
                ArchivePlanLine_L."NS_Currency Date" := PlanLine_L."Currency Date";
                ArchivePlanLine_L."NS_Currency Factor" := PlanLine_L."Currency Factor";
                ArchivePlanLine_L."NS_Schedule Line" := PlanLine_L."Schedule Line";
                ArchivePlanLine_L."NS_Contract Line" := PlanLine_L."Contract Line";
                ArchivePlanLine_L."NS_Job Contract Entry No." := PlanLine_L."Job Contract Entry No.";
                ArchivePlanLine_L."NS_Invoiced Amount (LCY)" := PlanLine_L."Invoiced Amount (LCY)";
                ArchivePlanLine_L."NS_Invoiced Cost Amount (LCY)" := PlanLine_L."Invoiced Cost Amount (LCY)";
                ArchivePlanLine_L."NS_VAT Unit Price" := PlanLine_L."VAT Unit Price";
                ArchivePlanLine_L."NS_VAT Line Discount Amount" := PlanLine_L."Line Discount Amount";
                ArchivePlanLine_L."NS_VAT Line Amount" := PlanLine_L."VAT Line Amount";
                ArchivePlanLine_L."NS_VAT %" := PlanLine_L."VAT %";
                ArchivePlanLine_L."NS_Description 2" := PlanLine_L."Description 2";
                ArchivePlanLine_L."NS_Job Ledger Entry No." := PlanLine_L."Job Ledger Entry No.";
                ArchivePlanLine_L.NS_Status := PlanLine_L.Status;
                ArchivePlanLine_L."NS_Ledger Entry Type" := PlanLine_L."Ledger Entry Type";
                ArchivePlanLine_L."NS_Ledger Entry No." := PlanLine_L."Ledger Entry No.";
                ArchivePlanLine_L."NS_System-Created Entry" := PlanLine_L."System-Created Entry";
                ArchivePlanLine_L."NS_Usage Link" := PlanLine_L."Usage Link";
                ArchivePlanLine_L."NS_Remaining Qty." := PlanLine_L."Remaining Qty.";
                ArchivePlanLine_L."NS_Remaining Qty. (Base)" := PlanLine_L."Remaining Qty. (Base)";
                ArchivePlanLine_L."NS_Remaining Total Cost" := PlanLine_L."Remaining Total Cost";
                ArchivePlanLine_L."NS_Remaining Total Cost (LCY)" := PlanLine_L."Remaining Total Cost (LCY)";
                ArchivePlanLine_L."NS_Remaining Line Amount" := PlanLine_L."Remaining Line Amount";
                ArchivePlanLine_L."NS_Remaining Line Amount (LCY)" := PlanLine_L."Remaining Line Amount (LCY)";
                ArchivePlanLine_L."NS_Qty. Posted" := PlanLine_L."Qty. Posted";
                ArchivePlanLine_L."NS_Qty. to Transfer to Journal" := PlanLine_L."Qty. to Transfer to Journal";
                ArchivePlanLine_L."NS_Posted Total Cost" := PlanLine_L."Posted Total Cost";
                ArchivePlanLine_L."NS_Posted Total Cost (LCY)" := PlanLine_L."Posted Total Cost (LCY)";
                ArchivePlanLine_L."NS_Posted Line Amount" := PlanLine_L."Posted Line Amount";
                ArchivePlanLine_L."NS_Posted Line Amount (LCY)" := PlanLine_L."Posted Line Amount (LCY)";
                ArchivePlanLine_L."NS_Qty. Transferred to Invoice" := PlanLine_L."Qty. Transferred to Invoice";
                ArchivePlanLine_L."NS_Qty. to Transfer to Invoice" := PlanLine_L."Qty. to Transfer to Invoice";
                ArchivePlanLine_L."NS_Qty. Invoiced" := PlanLine_L."Qty. Invoiced";
                ArchivePlanLine_L."NS_Qty. to Invoice" := PlanLine_L."Qty. to Invoice";
                ArchivePlanLine_L."NS_Reserved Quantity" := PlanLine_L."Reserved Quantity";
                ArchivePlanLine_L."NS_Reserved Qty. (Base)" := PlanLine_L."Reserved Qty. (Base)";
                ArchivePlanLine_L.NS_Reserve := PlanLine_L.Reserve;
                ArchivePlanLine_L.NS_Planned := PlanLine_L.Planned;
                ArchivePlanLine_L."NS_Variant Code" := PlanLine_L."Variant Code";
                ArchivePlanLine_L."NS_Bin Code" := PlanLine_L."Bin Code";
                ArchivePlanLine_L."NS_Qty. per Unit of Measure" := PlanLine_L."Qty. per Unit of Measure";
                ArchivePlanLine_L."NS_Quantity (Base)" := PlanLine_L."Quantity (Base)";
                ArchivePlanLine_L."NS_Requested Delivery Date" := PlanLine_L."Requested Delivery Date";
                ArchivePlanLine_L."NS_Promised Delivery Date" := PlanLine_L."Promised Delivery Date";
                ArchivePlanLine_L."NS_Planned Delivery Date" := PlanLine_L."Planned Delivery Date";
                ArchivePlanLine_L."NS_Service Order No." := PlanLine_L."Service Order No.";
                ArchivePlanLine_L."NS_Cost Category" := PlanLine_L."NS_Cost Category";
                ArchivePlanLine_L."NS_Revenue Category" := PlanLine_L."NS_Revenue Category";
                ArchivePlanLine_L."NS_Cost Factor Set By Category" := PlanLine_L."NS_Cost Factor Set By Category";
                ArchivePlanLine_L."NS_Shortcut Dimension 1 Code" := PlanLine_L."NS_Shortcut Dimension 1 Code";
                ArchivePlanLine_L."NS_Shortcut Dimension 2 Code" := PlanLine_L."NS_Shortcut Dimension 2 Code";
                ArchivePlanLine_L."NS_Activity Code" := PlanLine_L."NS_Activity Code";
                ArchivePlanLine_L."NS_Process Code" := PlanLine_L."NS_Process Code";
                ArchivePlanLine_L."NS_Operation Code" := PlanLine_L."NS_Operation Code";
                ArchivePlanLine_L."NS_Section Code" := PlanLine_L."NS_Section Code";
                ArchivePlanLine_L."NS_Work Units" := PlanLine_L."NS_Work Units";
                ArchivePlanLine_L."NS_Work Unit of Measure" := PlanLine_L."NS_Work Unit of Measure";
                ArchivePlanLine_L."NS_Skill Class" := PlanLine_L."NS_Skill Class";
                ArchivePlanLine_L."NS_Entry Type" := PlanLine_L."NS_Entry Type";
                ArchivePlanLine_L.NS_Adjustment := PlanLine_L."NS_Adjustment";
                ArchivePlanLine_L."NS_Rate Type" := PlanLine_L."NS_Rate Type";
                ArchivePlanLine_L."NS_Rate Type Value" := PlanLine_L."NS_Rate Type Value";
                ArchivePlanLine_L."NS_Not To Exceed" := PlanLine_L."NS_Not To Exceed";
                ArchivePlanLine_L."NS_Subcontract No." := PlanLine_L."NS_Subcontract No.";
                ArchivePlanLine_L."NS_Subcontract Line No." := PlanLine_L."NS_Subcontract Line No.";
                ArchivePlanLine_L."NS_Progress Billing Method" := PlanLine_L."NS_Progress Billing Method";
                ArchivePlanLine_L."NS_Progress Payment Method" := PlanLine_L."NS_Progress Payment Method";
                ArchivePlanLine_L.NS_TempNo := PlanLine_L.NS_TempNo;
                ArchivePlanLine_L.NS_TempLocation := PlanLine_L.NS_TempLocation;
                ArchivePlanLine_L.NS_TempVariant := PlanLine_L.NS_TempVariant;
                ArchivePlanLine_L.NS_TempUM := PlanLine_L.NS_TempUM;
                ArchivePlanLine_L.NS_TempWorkType := PlanLine_L.NS_TempWorkType;
                ArchivePlanLine_L.NS_TempSkillClass := PlanLine_L.NS_TempSkillClass;
                ArchivePlanLine_L.NS_Welding := PlanLine_L.NS_Welding;
                ArchivePlanLine_L."NS_Size of Weld" := PlanLine_L."NS_Size of Weld";
                ArchivePlanLine_L."NS_Weld Time (Hours)" := PlanLine_L."NS_Weld Time (Hours)";
                ArchivePlanLine_L."NS_No. 2" := PlanLine_L."NS_No. 2";
                ArchivePlanLine_L."NS_Quote No." := PlanLine_L."NS_Quote No.";
                ArchivePlanLine_L."NS_Quote Line No." := PlanLine_L."NS_Quote Line No.";
                ArchivePlanLine_L."NS_Purchase Order No." := PlanLine_L."NS_Purchase Order No.";
                ArchivePlanLine_L."NS_Use Tax SKU" := PlanLine_L."NS_Use Tax SKU";
                ArchivePlanLine_L."NS_Use Tax Amount" := PlanLine_L."NS_Use Tax Amount";
                ArchivePlanLine_L."NS_Vendor No." := PlanLine_L."NS_Vendor No.";
                ArchivePlanLine_L."NS_Vendor Quote No." := PlanLine_L."NS_Vendor Quote No.";
                ArchivePlanLine_L."NS_Manufacturer Code" := PlanLine_L."NS_Manufacturer Code";
                ArchivePlanLine_L."NS_Defaulted Entry" := PlanLine_L."NS_Defaulted Entry";
                ArchivePlanLine_L."NS_Gross Profit" := PlanLine_L."NS_Gross Profit";
                ArchivePlanLine_L."NS_Total Number of Welds" := PlanLine_L."NS_Total Number of Welds";
                ArchivePlanLine_L."NS_Gross Profit Percentage" := PlanLine_L."NS_Gross Profit Percentage";
                ArchivePlanLine_L."NS_Original Total Price" := PlanLine_L."NS_Original Total Price";
                ArchivePlanLine_L."NS_Original Total Price (LCY)" := PlanLine_L."NS_Original Total Price (LCY)";
                ArchivePlanLine_L."NS_Original Quantity" := PlanLine_L."NS_Original Quantity";
                ArchivePlanLine_L."NS_Item Not Found" := PlanLine_L."NS_Item Not Found";
                ArchivePlanLine_L."NS_Segment Type" := PlanLine_L."NS_Segment Type";
                ArchivePlanLine_L."NS_Segment Code" := PlanLine_L."NS_Segment Code";
                ArchivePlanLine_L."NS_Segment Name" := PlanLine_L."NS_Segment Name";
                ArchivePlanLine_L."NS_Matrix Updated" := PlanLine_L."NS_Matrix Updated";
                ArchivePlanLine_L."NS_Progress Billing Line" := PlanLine_L."NS_Progress Billing Line";
                ArchivePlanLine_L."NS_Dimension Set ID" := PlanLine_L."NS_Dimension Set ID";
                ArchivePlanLine_L."NS_Retention Ledger Code" := PlanLine_L."NS_Retention Ledger Code";
                ArchivePlanLine_L."NS_Line Amount Incl. Tax" := PlanLine_L."NS_Line Amount Incl. Tax";
                ArchivePlanLine_L.NS_Revision := qQuoteHeader_L.NS_Revision;
                ArchivePlanLine_L.INSERT;
            until PlanLine_L.NEXT = 0;
    end;
    //PRJ-774.AS.1.0 - end
    // >> Upgrade
    [IntegrationEvent(false, false)]
    local procedure OnAfterNS_CreateRevisionJQ(var qQuoteHeader: Record "NS_Job Quote Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterNS_OnDeleteQuote(var _QuoteHeader: Record "NS_Job Quote Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure NS_OnInsertQuote1(var _QuoteHeader: Record "NS_Job Quote Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure NS_OnInsertQuote2(var _QuoteHeader: Record "NS_Job Quote Header"; var _UserSetup: Record "User Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure NS_OnInsertQuote3(var _QuoteHeader: Record "NS_Job Quote Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeNS_ShowDocDim(var _QuoteHeader: Record "NS_Job Quote Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure NS_ValidateShortcutDimCode1(var _QuoteHeader: Record "NS_Job Quote Header"; var _ShortcutDimCode: Code[20]; var _FieldNumber: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure NS_CreateQuoteJob1(var QuoteJob: Record Job; var lJobQuote: Record "NS_Job Quote Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure NS_ModifyQuoteJob1(var QuoteJob: Record Job; var JobQuote: Record "NS_Job Quote Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure NS_LoadFromJobTmplOnBeforeInsert(var QuoteTaskLine: Record "Job Task"; var SeqNo: integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure NS_OnValidateBillToCustomerOnBefore(_QuoteHeader: Record "NS_Job Quote Header"; var IsHandled: boolean)
    begin

    end;
    // << Upgrade

    //PRJ-914.AS.1.0 20OCT2021 START Created New Function
    LOCAL PROCEDURE NS_GetNextChangeOrderNo(PassJobNo: Code[20]; PassJobSeparator: Text[10]): Code[20];
    VAR
        JobRec: Record 167;
        NS_JobSetup: Record "Jobs Setup";  //PE-246.HS.1.0 1Feb2024 
    BEGIN
        if NS_JobSetup.Get() then; //PE-246.HS.1.0 1Feb2024 
        if (NS_JobSetup."NS_Change Ordr NumberingFormat" = '') then begin   //PE-246.HS.1.0 1Feb2024 
            JobRec.RESET;
            Job.SETFILTER("No.", '%1', PassJobNo + PassJobSeparator + '*');
            IF Job.FINDLAST THEN BEGIN
                EXIT(INCSTR(Job."No."));
            END ELSE
                EXIT(PassJobNo + PassJobSeparator + '001');
        end  //PE-246.HS.1.0 1Feb2024 

        //PE-246.HS.1.0 1Feb2024 Start
        else begin
            JobRec.RESET;
            Job.SETFILTER("No.", '%1', PassJobNo + PassJobSeparator + '*');
            IF Job.FINDLAST THEN BEGIN
                EXIT(INCSTR(Job."No."));
            END ELSE
                EXIT(PassJobNo + PassJobSeparator + NS_JobSetup."NS_Change Ordr NumberingFormat");
        end;
        //PE-246.HS.1.0 1Feb2024 End
    END;
    //PRJ-914.AS.1.0 20OCT2021 END
    //PRJ-1487.NK.1.0 01Jul2022 Start
    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        JobQuoteHead: Record "NS_Job Quote Header";
    begin
        case DocumentAttachment."Table ID" of
            DATABASE::"NS_Job Quote Header":
                begin
                    RecRef.Open(DATABASE::"NS_Job Quote Header");
                    if JobQuoteHead.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(JobQuoteHead);
                end;
        end;
    end;
    //PRJCTPR-342.DK.2.0 Start
    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure OnBeforeDrillDownJob(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        JobQuoteHead: Record "NS_Job Quote Header";
    begin
        case DocumentAttachment."Table ID" of
            DATABASE::Job:
                begin
                    RecRef.Open(DATABASE::"NS_Job Quote Header");
                    if JobQuoteHead.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(JobQuoteHead);
                end;
        end;
    end;
    //PRJCTPR-342.DK.2.0 End
    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef; var FlowFieldsEditable: Boolean)
    var
        FieldRef1: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            database::"NS_Job Quote Header":
                begin
                    FieldRef1 := RecRef.Field(11);
                    RecNo := FieldRef1.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
    end;
    //PRJ-1487.NK.1.0 01Jul2022 End
    //PRJCTPR-342.DK.2.0 Start
    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure NS_OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::"NS_Job Quote Header":
                begin
                    FieldRef := RecRef.Field(11);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;
    end;
    //PRJCTPR-342.DK.2.0 End
}

