report 14021169 "NS_Get Job Usage"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com

    //SMPL - Renamed report from - Get Job Usage to NS_Get Job Usage

    Caption = 'Get Job Usage';
    Permissions = TableData "Job Ledger Entry" = rimd;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Job Ledger Entry"; "Job Ledger Entry")
        {
            DataItemTableView = SORTING("Job No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Job Cost Category", "Entry Type", "Posting Date") WHERE("Entry Type" = CONST(Usage));
            RequestFilterFields = "Job No.", "Posting Date";

            trigger OnAfterGetRecord();
            var
                JobPlanningLine: Record "Job Planning Line";
                Item: Record Item;
                GLSetup: Record "General Ledger Setup";
                FoundCost: Boolean;
                FoundPrice: Boolean;
            begin
                Counter := Counter + 1;
                DimEntryNo := DimEntryNo + 10000;
                Window.UPDATE(1, Counter);

                if "Job No." <> Job."No." then
                    Job.GET("Job No.");

                if (Job."Bill-to Customer No." <> SalesHeader."Bill-to Customer No.") and
                   (Job."Bill-to Customer No." <> SalesHeader."Sell-to Customer No.")
                then
                    exit;

                JobPostingBuffer."Job No." := "Job No.";
                JobPostingBuffer."Posting Group Type" := Type;
                JobPostingBuffer."NS_Job Task No." := "Job Ledger Entry"."Job Task No.";//PRJ-603.AS.1.0 13APRIL2021
                JobPostingBuffer."No." := "No.";
                JobPostingBuffer."Unit of Measure Code" := "Unit of Measure Code";
                JobPostingBuffer."Work Type Code" := "Work Type Code";
                JobPostingBuffer."Global Dimension 1 Code" := "Global Dimension 1 Code";
                JobPostingBuffer."Global Dimension 2 Code" := "Global Dimension 2 Code";
                JobPostingBuffer."Dimension Set ID" := "Dimension Set ID";
                JobPostingBuffer."Applies-to ID" := FORMAT("Entry No.");
                JobPostingBuffer."Dimension Entry No." := DimEntryNo;
                JobPostingBuffer."Variant Code" := "Variant Code";
                if TaskFromTransaction then begin
                    if SummarizeByActivity then
                        JobPostingBuffer."NS_Activity Code" := "NS_Activity Code";
                    if SummarizeByProcess then
                        JobPostingBuffer."NS_Process Code" := "NS_Process Code";
                    if SummarizeByOperation then
                        JobPostingBuffer."NS_Operation Code" := "NS_Operation Code";
                    if (not SummarizeByActivity) and
                       (not SummarizeByProcess) and
                       (not SummarizeByOperation) then begin
                        JobPostingBuffer."NS_Activity Code" := "NS_Activity Code";
                        JobPostingBuffer."NS_Process Code" := "NS_Process Code";
                        JobPostingBuffer."NS_Operation Code" := "NS_Operation Code";
                    end;
                end;

                JobPostingBuffer."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                JobPostingBuffer."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";


                FoundCost := true;
                FoundPrice := true;

                if "Total Cost (LCY)" = 0 then begin
                    FoundCost := false;
                    JobPlanningLine.RESET;
                    JobPlanningLine.SETCURRENTKEY("Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                                  "NS_Cost Category", Type, "No.", "Variant Code");
                    JobPlanningLine.SETRANGE("Job No.", "Job No.");
                    JobPlanningLine.SETRANGE("NS_Entry Type", JobPlanningLine."NS_Entry Type"::Cost);
                    if "NS_Activity Code" > '' then
                        JobPlanningLine.SETRANGE("NS_Activity Code", "NS_Activity Code");
                    if "NS_Process Code" > '' then
                        JobPlanningLine.SETRANGE("NS_Process Code", "NS_Process Code");
                    if "NS_Operation Code" > '' then
                        JobPlanningLine.SETRANGE("NS_Operation Code", "NS_Operation Code");
                    JobPlanningLine.SETRANGE("NS_Cost Category", "NS_Job Cost Category");
                    JobPlanningLine.SETRANGE(Type, Type);
                    JobPlanningLine.SETRANGE("No.", "No.");
                    JobPlanningLine.SETRANGE("Variant Code", "Variant Code");
                    if JobPlanningLine.FINDFIRST then begin
                        "Unit Cost" := JobPlanningLine."Unit Cost";
                        "Unit Cost (LCY)" := JobPlanningLine."Unit Cost (LCY)";
                        FoundCost := true;
                    end;

                    if (not FoundCost) and ("NS_Operation Code" > '') then begin
                        JobPlanningLine.SETRANGE("NS_Operation Code");
                        if JobPlanningLine.FINDFIRST then begin
                            "Unit Cost" := JobPlanningLine."Unit Cost";
                            "Unit Cost (LCY)" := JobPlanningLine."Unit Cost (LCY)";
                            FoundCost := true;
                        end;
                    end;

                    if (not FoundCost) and ("NS_Process Code" > '') then begin
                        JobPlanningLine.SETRANGE("NS_Process Code");
                        if JobPlanningLine.FINDFIRST then begin
                            "Unit Cost" := JobPlanningLine."Unit Cost";
                            "Unit Cost (LCY)" := JobPlanningLine."Unit Cost (LCY)";
                            FoundCost := true;
                        end;
                    end;

                    if (not FoundCost) and ("NS_Activity Code" > '') then begin
                        JobPlanningLine.SETRANGE("NS_Activity Code");
                        if JobPlanningLine.FINDFIRST then begin
                            "Unit Cost" := JobPlanningLine."Unit Cost";
                            "Unit Cost (LCY)" := JobPlanningLine."Unit Cost (LCY)";
                            FoundCost := true;
                        end;
                    end;

                    if (not FoundCost) and (Type = Type::Item) and (Item.GET("No.")) then begin
                        "Unit Cost" := Item."Unit Cost";
                        "Unit Cost (LCY)" := Item."Unit Cost";
                        FoundCost := true;
                    end;

                    if FoundCost then begin
                        GLSetup.GET;
                        "Total Cost (LCY)" := ROUND("Unit Cost (LCY)" * Quantity, GLSetup."Amount Rounding Precision");
                    end;

                end;

                if "Total Price (LCY)" = 0 then begin
                    //Look for the price in the cost planning records
                    FoundPrice := false;
                    JobPlanningLine.RESET;
                    JobPlanningLine.SETCURRENTKEY("Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                                  "NS_Cost Category", Type, "No.", "Variant Code");
                    JobPlanningLine.SETRANGE("Job No.", "Job No.");
                    JobPlanningLine.SETRANGE("NS_Entry Type", JobPlanningLine."NS_Entry Type"::Cost);
                    if "NS_Activity Code" > '' then
                        JobPlanningLine.SETRANGE("NS_Activity Code", "NS_Activity Code");
                    if "NS_Process Code" > '' then
                        JobPlanningLine.SETRANGE("NS_Process Code", "NS_Process Code");
                    if "NS_Operation Code" > '' then
                        JobPlanningLine.SETRANGE("NS_Operation Code", "NS_Operation Code");
                    JobPlanningLine.SETRANGE("NS_Cost Category", "NS_Job Cost Category");
                    JobPlanningLine.SETRANGE(Type, Type);
                    JobPlanningLine.SETRANGE("No.", "No.");
                    if "Variant Code" > '' then
                        JobPlanningLine.SETRANGE("Variant Code", "Variant Code");
                    if JobPlanningLine.FINDFIRST then begin
                        "Unit Price" := JobPlanningLine."Unit Price";
                        "Unit Price (LCY)" := JobPlanningLine."Unit Price (LCY)";
                        FoundPrice := true;
                    end;

                    if (not FoundPrice) and ("NS_Operation Code" > '') then begin
                        JobPlanningLine.SETRANGE("NS_Operation Code");
                        if JobPlanningLine.FINDFIRST then begin
                            "Unit Price" := JobPlanningLine."Unit Price";
                            "Unit Price (LCY)" := JobPlanningLine."Unit Price (LCY)";
                            FoundPrice := true;
                        end;
                    end;

                    if (not FoundPrice) and ("NS_Process Code" > '') then begin
                        JobPlanningLine.SETRANGE("NS_Process Code");
                        if JobPlanningLine.FINDFIRST then begin
                            "Unit Price" := JobPlanningLine."Unit Price";
                            "Unit Price (LCY)" := JobPlanningLine."Unit Price (LCY)";
                            FoundPrice := true;
                        end;
                    end;

                    if (not FoundPrice) and ("NS_Activity Code" > '') then begin
                        JobPlanningLine.SETRANGE("NS_Activity Code");
                        if JobPlanningLine.FINDFIRST then begin
                            "Unit Price" := JobPlanningLine."Unit Price";
                            "Unit Price (LCY)" := JobPlanningLine."Unit Price (LCY)";
                            FoundPrice := true;
                        end;
                    end;

                    if (not FoundPrice) and (Type = Type::Item) and (Item.GET("No.")) then begin
                        "Unit Price" := Item."Unit Price";
                        "Unit Price (LCY)" := Item."Unit Price";
                        FoundPrice := true;
                    end;

                    if FoundPrice then begin
                        GLSetup.GET;
                        "Total Price (LCY)" := ROUND("Unit Price (LCY)" * Quantity, GLSetup."Amount Rounding Precision");
                    end;
                end;

                UpdateJobPostingBuffer(Quantity, "Total Cost (LCY)", "Total Price (LCY)", JobPostingBuffer);

                if "Total Price" > 0 then
                    JobLedgEntrySign := '+'
                else
                    JobLedgEntrySign := '-';

                MODIFY;
            end;

            trigger OnPreDataItem();
            begin
                CurrentSalesLine.LOCKTABLE;
                if not CurrentSalesLine.FINDLAST then begin
                    CurrentSalesLine."Document Type" := CurrentSalesLine.GETRANGEMIN("Document Type");
                    CurrentSalesLine."Document No." := CurrentSalesLine.GETRANGEMIN("Document No.");
                    CurrentSalesLine."Line No." := 10000;
                end;

                JobPostingBuffer.DELETEALL;
                DimBuf.DELETEALL;
                GetGLSetup;
                Window.OPEN(Text000);
                Counter := 0;

                SalesHeader.GET(CurrentSalesLine."Document Type", CurrentSalesLine."Document No.");
                if (SalesHeader."NS_Job No." <> '') and (GETFILTER("Job No.") = '') then
                    SETRANGE("Job No.", SalesHeader."NS_Job No.");

                if RECORDLEVELLOCKING then
                    LOCKTABLE;
            end;
        }
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord();
            begin
                FinalizeJobPostingBuffer(JobLedgEntry);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        TaskFromTransaction := true;
    end;

    var
        Job: Record Job;
        JobLedgEntry: Record "Job Ledger Entry";
        JobPostingGr: Record "Job Posting Group";
        JobActivity: Record "NS_Job Activity";
        JobProcess: Record "NS_Job Process";
        JobOperation: Record "NS_Job Operation";
        CurrentSalesLine: Record "Sales Line";
        SalesLine: Record "Sales Line";
        CurrExchRate: Record "Currency Exchange Rate";
        JobPostingBuffer: Record "Job Posting Buffer" temporary;
        GLAcc: Record "G/L Account";
        DimBuf: Record "Dimension Buffer";
        GLSetup: Record "General Ledger Setup";
        SalesHeader: Record "Sales Header";
        Currency: Record Currency;
        JobLedgEntrySign: Code[10];
        Counter: Integer;
        Window: Dialog;
        DimEntryNo: Integer;
        GLSetupRead: Boolean;
        SummarizeByActivity: Boolean;
        SummarizeByProcess: Boolean;
        SummarizeByOperation: Boolean;
        TaskFromTransaction: Boolean;
        Text000: Label 'Processing Job Ledger Entries #1######';

    local procedure UpdateJobPostingBuffer(Counter: Decimal; TotalTotalCost: Decimal; TotalTotalPrice: Decimal; var JobPostingBuffer: Record "Job Posting Buffer");
    begin
        if JobPostingBuffer.FIND then begin
            JobPostingBuffer.Quantity := JobPostingBuffer.Quantity + Counter;
            JobPostingBuffer."Total Cost" := JobPostingBuffer."Total Cost" + TotalTotalCost;
            JobPostingBuffer."Total Price" := JobPostingBuffer."Total Price" + TotalTotalPrice;
            JobPostingBuffer.MODIFY;
        end else begin
            JobPostingBuffer.Quantity := Counter;
            JobPostingBuffer."Total Cost" := TotalTotalCost;
            JobPostingBuffer."Total Price" := TotalTotalPrice;
            JobPostingBuffer.INSERT;
        end;
    end;

    local procedure FinalizeJobPostingBuffer(JobLedgEntry2: Record "Job Ledger Entry");
    var
        JobCostCat: Record "NS_Job Cost Category";
        JobTask: Record "Job Task";
    begin
        with JobPostingBuffer do begin
            if not FINDSET then
                exit;
            repeat
                GetGLSetup;
                if Quantity <> 0 then begin
                    SalesLine.INIT;
                    case "Posting Group Type" of
                        "Posting Group Type"::Resource:
                            SalesLine.Type := SalesLine.Type::Resource;
                        "Posting Group Type"::Item:
                            SalesLine.Type := SalesLine.Type::Item;
                        "Posting Group Type"::"G/L Account":
                            SalesLine.Type := SalesLine.Type::"G/L Account";
                    end;
                    if "Posting Group Type" = "Posting Group Type"::"G/L Account" then begin
                        Job.GET("Job No.");
                        if JobActivity.GET(JobActivity.NS_Type::Cost,
                                           JobLedgEntry."NS_Activity Code") then
                            ;
                        if JobProcess.GET(JobProcess.NS_Type::Cost,
                                          JobLedgEntry."NS_Activity Code",
                                          JobLedgEntry."NS_Process Code") then
                            ;
                        if JobOperation.GET(JobActivity.NS_Type::Cost,
                                           JobLedgEntry."NS_Activity Code",
                                           JobLedgEntry."NS_Operation Code") then
                            ;
                        if JobPostingGr.GET(Job."NS_Job Type") then begin
                            JobPostingGr.TESTFIELD("Recognized Sales Account");
                            SalesLine."No." := JobPostingGr."Recognized Sales Account";
                        end;
                    end else
                        SalesLine."No." := "No.";
                    SalesLine."Document Type" := CurrentSalesLine."Document Type";
                    SalesLine."Document No." := CurrentSalesLine."Document No.";
                    CurrentSalesLine."Line No." := CurrentSalesLine."Line No." + 10000;
                    SalesLine."Line No." := CurrentSalesLine."Line No.";
                    SalesLine.VALIDATE("No.");
                    if SalesLine.Type = SalesLine.Type::Item then
                        SalesLine.VALIDATE("Variant Code", "Variant Code");
                    if "Posting Group Type" = "Posting Group Type"::"G/L Account" then begin
                        GLAcc.GET("No.");
                        SalesLine.Description := GLAcc.Name;
                    end;
                    SalesLine."Work Type Code" := "Work Type Code";
                    SalesLine.VALIDATE("Unit of Measure Code", "Unit of Measure Code");
                    SalesLine."Unit Price" :=
                      ROUND("Total Price" / Quantity, GLSetup."Unit-Amount Rounding Precision");
                    if SalesHeader."Currency Code" <> '' then begin
                        Currency.GET(SalesHeader."Currency Code");
                        SalesHeader.TESTFIELD("Currency Factor");
                        SalesLine."Unit Price" :=
                          ROUND(
                            CurrExchRate.ExchangeAmtLCYToFCY(
                              WORKDATE, SalesHeader."Currency Code",
                              SalesLine."Unit Price", SalesHeader."Currency Factor"), Currency."Unit-Amount Rounding Precision");
                    end;
                    SalesLine.VALIDATE(
                      "Unit Cost (LCY)",
                      ROUND("Total Cost" / Quantity, GLSetup."Unit-Amount Rounding Precision"));
                    SalesLine.VALIDATE(Quantity, Quantity);
                    SalesLine."Job No." := "Job No.";
                    SalesLine."Job Task No." := "NS_Job Task No.";//PRJ-603.AS.1.0 13APRIL2021
                    SalesLine."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                    SalesLine."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                    SalesLine."Dimension Set ID" := "Dimension Set ID";
                    //PRJ-603.AS.1.0 14APRIL2021 - START COMMENT
                    /*case true of
                        "NS_Operation Code" > '':
                            SalesLine."Job Task No." := Job.APOToJobTaskNo(JobLedgEntry2."NS_Activity Code",
                                                                           JobLedgEntry2."NS_Process Code",
                                                                           JobLedgEntry2."NS_Operation Code", '');//PRJ-688.AM.1.0
                        "NS_Process Code" > '':
                            SalesLine."Job Task No." := Job.APOToJobTaskNo(JobLedgEntry2."NS_Activity Code",
                                                                           JobLedgEntry2."NS_Process Code", '', '');//PRJ-688.AM.1.0
                        "NS_Activity Code" > '':
                            SalesLine."Job Task No." := Job.APOToJobTaskNo(JobLedgEntry2."NS_Activity Code", '', '', '');//PRJ-688.AM.1.0
                    end;*/
                    //PRJ-603.AS.1.0 14APRIL2021 - END COMMENT
                    if "Total Price" > 0 then begin
                        JobLedgEntrySign := '+';
                    end else begin
                        JobLedgEntrySign := '-';
                    end;

                    if SalesLine."NS_Job Cost Category" = '' then begin
                        JobCostCat.RESET;
                        JobCostCat.SETCURRENTKEY("NS_Activity Code");
                        JobCostCat.SETRANGE("NS_Activity Code", JobLedgEntry2."NS_Activity Code");
                        if JobCostCat.FINDFIRST then
                            SalesLine."NS_Job Cost Category" := JobCostCat.NS_Code;
                    end;

                    if SalesLine."Gen. Bus. Posting Group" = '' then
                        SalesLine."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                    if SalesLine."Gen. Prod. Posting Group" = '' then
                        SalesLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
                    if SalesLine.Type = SalesLine.Type::"G/L Account" then begin
                        if SalesLine."No." = '' then
                            if JobTask.GET(SalesLine."Job No.", SalesLine."Job Task No.") then
                                if JobTask."Job Posting Group" <> '' then
                                    if JobPostingGr.GET(JobTask."Job Posting Group") then
                                        SalesLine."No." := JobPostingGr."Recognized Sales Account";
                        if SalesLine."No." = '' then
                            if Job.GET(SalesLine."Job No.") then
                                if Job."Job Posting Group" <> '' then
                                    if JobPostingGr.GET(Job."Job Posting Group") then
                                        SalesLine."No." := JobPostingGr."Recognized Sales Account";
                    end;

                    SalesLine.INSERT;
                end;
            until NEXT = 0;

            DELETEALL;
        end;
    end;

    procedure SetCurrentSalesLine(var CurrentSalesLine2: Record "Sales Line");
    begin
        CurrentSalesLine.SETRANGE("Document Type", CurrentSalesLine2.GETRANGEMIN("Document Type"));
        CurrentSalesLine.SETRANGE("Document No.", CurrentSalesLine2.GETRANGEMIN("Document No."));
    end;

    local procedure GetGLSetup();
    begin
        if not GLSetupRead then
            GLSetup.GET;
        GLSetupRead := true;
    end;
}

