report 14021381 "NS_Job Journal Labor - Test"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-84.SK.1.0 Added report to search
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSJob Journal Labor - Test.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    Caption = ' Job Job Journal - Test';//PE-141.NK.1.0 03Aug2023 updated name

    dataset
    {
        dataitem("Job Journal Batch"; "Job Journal Batch")
        {
            DataItemTableView = SORTING("Journal Template Name", Name);
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Journal Template Name", Name;
            column(Job_Journal_Batch_Name; Name)
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                PrintOnlyIfDetail = true;
                column(COMPANYNAME; COMPANYNAME)
                {
                }
                column(Job_Journal_Batch___Journal_Template_Name_; "Job Journal Batch"."Journal Template Name")
                {
                }
                column(Job_Journal_Batch__Name; "Job Journal Batch".Name)
                {
                }
                column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
                {
                }
                column(CurrReport_PAGENO; CurrReport.PAGENO)
                {
                }
                column(Job_Journal_Line__TABLECAPTION__________JobJnlLineFilter; "Job Journal Line".TABLECAPTION + ': ' + JobJnlLineFilter)
                {
                }
                column(JobJnlLineFilter; JobJnlLineFilter)
                {
                }
                column(Job_Journal_Batch___Journal_Template_Name_Caption; Job_Journal_Batch___Journal_Template_Name_CaptionLbl)
                {
                }
                column(Job_Journal_Batch__NameCaption; Job_Journal_Batch__NameCaptionLbl)
                {
                }
                column(Job_Journal___TestCaption; Job_Journal___TestCaptionLbl)
                {
                }
                column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Job_Journal_Line__Line_Amount_Caption; "Job Journal Line".FIELDCAPTION("Line Amount"))
                {
                }
                column(Job_Journal_Line__Unit_Price_Caption; "Job Journal Line".FIELDCAPTION("Unit Price"))
                {
                }
                column(Job_Journal_Line__Total_Cost__LCY__Caption; "Job Journal Line".FIELDCAPTION("Total Cost (LCY)"))
                {
                }
                column(Job_Journal_Line__Unit_Cost__LCY__Caption; "Job Journal Line".FIELDCAPTION("Unit Cost (LCY)"))
                {
                }
                column(Job_Journal_Line__Work_Type_Code_Caption; "Job Journal Line".FIELDCAPTION("Work Type Code"))
                {
                }
                column(Job_Journal_Line__Unit_of_Measure_Code_Caption; "Job Journal Line".FIELDCAPTION("Unit of Measure Code"))
                {
                }
                column(Job_Journal_Line_QuantityCaption; "Job Journal Line".FIELDCAPTION(Quantity))
                {
                }
                column(Job_Journal_Line__No__Caption; "Job Journal Line".FIELDCAPTION("No."))
                {
                }
                column(Job_Journal_Line__Document_No__Caption; "Job Journal Line".FIELDCAPTION("Document No."))
                {
                }
                column(Job_Journal_Line_TypeCaption; "Job Journal Line".FIELDCAPTION(Type))
                {
                }
                column(Job_Journal_Line__Job_No__Caption; "Job Journal Line".FIELDCAPTION("Job No."))
                {
                }
                column(Job_Journal_Line__Posting_Date_Caption; Job_Journal_Line__Posting_Date_CaptionLbl)
                {
                }
                column(Job_Journal_Line_JobTaskNo_Caption; "Job Journal Line".FIELDCAPTION("Job Task No."))
                {
                }
                column(Job_Journal_Line_Description_Caption; "Job Journal Line".FIELDCAPTION(Description))
                {
                }
                column(Job_Journal_Line_GenBusPostingGroup_Caption; "Job Journal Line".FIELDCAPTION("Gen. Bus. Posting Group"))
                {
                }
                column(Job_Journal_Line_GenProdPostingGroup_Caption; "Job Journal Line".FIELDCAPTION("Gen. Prod. Posting Group"))
                {
                }
                column(Job_Journal_Line_JobCostCategory_Caption; "Job Journal Line".FIELDCAPTION("NS_Job Cost Category"))
                {
                }
                //PE-68 Dk.1.0 10April2023 Start
                // column(Job_Journal_Line_SkillClass_Caption; "Job Journal Line".FIELDCAPTION("NS_Skill Class"))
                // {
                // }
                column(Job_Journal_Line_SkillClass_Caption; "Job Journal Line".FIELDCAPTION("NS_Skill Class New"))
                {
                }
                //PE-68 Dk.1.0 10April2023 End
                column(Job_Journal_Line_PayrollBurdenAmount_Caption; "Job Journal Line".FIELDCAPTION("NS_Payroll Burden Amount"))
                {
                }
                column(Job_Journal_Line_BurdenJobCostCategory_Caption; "Job Journal Line".FIELDCAPTION("NS_Burden Job Cost Category"))
                {
                }
                column(Job_Journal_Line_WorkUnits_Caption; "Job Journal Line".FIELDCAPTION("NS_Work Units"))
                {
                }
                column(Job_Journal_Line_WorkUnitUOM_Caption; "Job Journal Line".FIELDCAPTION("NS_Work Unit of Measure"))
                {
                }
                dataitem("Job Journal Line"; "Job Journal Line")
                {
                    DataItemLink = "Journal Template Name" = FIELD("Journal Template Name"), "Journal Batch Name" = FIELD(Name);
                    DataItemLinkReference = "Job Journal Batch";
                    DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", Type, "No.", "Unit of Measure Code", "Work Type Code");
                    RequestFilterFields = "Posting Date";
                    column(Job_Journal_Line__Line_Amount_; "Line Amount")
                    {
                    }
                    column(Job_Journal_Line__Unit_Price_; "Unit Price")
                    {
                    }
                    column(Job_Journal_Line__Total_Cost__LCY__; "Total Cost (LCY)")
                    {
                    }
                    column(Job_Journal_Line__Unit_Cost__LCY__; "Unit Cost (LCY)")
                    {
                    }
                    column(Job_Journal_Line__Work_Type_Code_; "Work Type Code")
                    {
                    }
                    column(Job_Journal_Line__Unit_of_Measure_Code_; "Unit of Measure Code")
                    {
                    }
                    column(Job_Journal_Line_Quantity; Quantity)
                    {
                    }
                    column(Job_Journal_Line__No__; "No.")
                    {
                    }
                    column(Job_Journal_Line_Type; Type)
                    {
                    }
                    column(Job_Journal_Line__Document_No__; "Document No.")
                    {
                    }
                    column(Job_Journal_Line__Job_No__; "Job No.")
                    {
                    }
                    column(Job_Journal_Line__Posting_Date_; FORMAT("Posting Date"))
                    {
                    }
                    column(Job_Journal_Line_Journal_Template_Name; "Journal Template Name")
                    {
                    }
                    column(Job_Journal_Line_Line_No_; "Line No.")
                    {
                    }
                    column(Job_Journal_Line_JobTaskNo; "Job Task No.")
                    {
                    }
                    column(Job_Journal_Line_Description; Description)
                    {
                    }
                    column(Job_Journal_Line_GenBusPostingGroup; "Gen. Bus. Posting Group")
                    {
                    }
                    column(Job_Journal_Line_GenProdPostingGroup; "Gen. Prod. Posting Group")
                    {
                    }
                    column(Job_Journal_Line_JobCostCategory; "NS_Job Cost Category")
                    {
                    }
                    //PE-68.Dk.1.0 10April2023 Start
                    // column(Job_Journal_Line_SkillClass; "NS_Skill Class")
                    // {
                    // }
                    column(Job_Journal_Line_SkillClass; "NS_Skill Class New")
                    {
                    }
                    //PE-68.Dk.1.0 10April2023 End
                    column(Job_Journal_Line_PayrollBurdenAmount; "NS_Payroll Burden Amount")
                    {
                    }
                    column(Job_Journal_Line_BurdenJobCostCategory; "NS_Burden Job Cost Category")
                    {
                    }
                    column(Job_Journal_Line_WorkUnits; "NS_Work Units")
                    {
                    }
                    column(Job_Journal_Line_WorkUnitUOM; "NS_Work Unit of Measure")
                    {
                    }
                    column(TotalQuantity_Employee; JobJournalLine2.Quantity)
                    {
                    }
                    column(TotalCostLCY_Employee; JobJournalLine2."Total Cost (LCY)")
                    {
                    }
                    column(TotalPayrollBurdenAmt_Employee; JobJournalLine2."NS_Payroll Burden Amount")
                    {
                    }
                    column(TotalWorkUnits_Employee; JobJournalLine2."NS_Work Units")
                    {
                    }
                    column(TotalQuantity_REPORT; JobJournalLine3.Quantity)
                    {
                    }
                    column(TotalCostLCY_REPORT; JobJournalLine3."Total Cost (LCY)")
                    {
                    }
                    column(TotalPayrollBurdenAmt_REPORT; JobJournalLine3."NS_Payroll Burden Amount")
                    {
                    }
                    column(TotalWorkUnits_REPORT; JobJournalLine3."NS_Work Units")
                    {
                    }
                    dataitem(DimensionLoop; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                        column(DimText; DimText)
                        {
                        }
                        column(ShowDimensionLoop1; Number = 1)
                        {
                        }
                        column(ShowDimensionLoop2; Number > 1)
                        {
                        }
                        column(DimensionsCaption; DimensionsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord();
                        begin
                            if Number = 1 then begin
                                if not DimSetEntry.FINDSET() then
                                    CurrReport.BREAK;
                            end else
                                if not Continue then
                                    CurrReport.BREAK;

                            CLEAR(DimText);
                            Continue := false;
                            repeat
                                OldDimText := DimText;
                                if DimText = '' then
                                    DimText := STRSUBSTNO('%1 - %2', DimSetEntry."Dimension Code", DimSetEntry."Dimension Value Code")
                                else
                                    DimText :=
                                      STRSUBSTNO(
                                        '%1; %2 - %3', DimText, DimSetEntry."Dimension Code", DimSetEntry."Dimension Value Code");
                                if STRLEN(DimText) > MAXSTRLEN(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                end;
                            until DimSetEntry.NEXT = 0;
                        end;

                        trigger OnPreDataItem();
                        begin
                            if not ShowDim then
                                CurrReport.BREAK;
                            DimSetEntry.SETRANGE("Dimension Set ID", "Job Journal Line"."Dimension Set ID");
                        end;
                    }
                    dataitem(ErrorLoop; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(ErrorText_Number_; ErrorText[Number])
                        {
                        }
                        column(ErrorText_Number_Caption; ErrorText_Number_CaptionLbl)
                        {
                        }

                        trigger OnPostDataItem();
                        begin
                            ErrorCounter := 0;
                        end;

                        trigger OnPreDataItem();
                        begin
                            SETRANGE(Number, 1, ErrorCounter);
                        end;
                    }

                    trigger OnAfterGetRecord();
                    var
                        InvtPeriodEndDate: Date;
                    begin
                        if EmptyLine then
                            exit;

                        MakeRecurringTexts("Job Journal Line");

                        if "Job No." = '' then
                            AddError(STRSUBSTNO(Text001_lbl, FIELDCAPTION("Job No.")))
                        else

                            if not Job.GET("Job No.") then
                                AddError(STRSUBSTNO(Text002_lbl, "Job No."))
                            else begin
                                if Job.Blocked.AsInteger() > Job.Blocked::" ".AsInteger() then
                                    AddError(STRSUBSTNO(Text003_lbl, Job.FIELDCAPTION(Blocked), Job.Blocked, "Job No."));
                            end;
                        if "Job No." <> '' then
                            if "Job Task No." = '' then
                                AddError(STRSUBSTNO(Text001_lbl, FIELDCAPTION("Job Task No.")))
                            else begin
                                if not JT.GET("Job No.", "Job Task No.") then
                                    AddError(STRSUBSTNO(Text015, JT.TABLECAPTION, "Job Task No."))
                            end;

                        if Type <> Type::"G/L Account" then
                            if "Gen. Prod. Posting Group" = '' then
                                AddError(STRSUBSTNO(Text001_lbl, FIELDCAPTION("Gen. Prod. Posting Group")))
                            else
                                if not GenPostingSetup.GET("Gen. Bus. Posting Group", "Gen. Prod. Posting Group") then
                                    AddError(
                                      STRSUBSTNO(
                                        Text004_lbl, GenPostingSetup.TABLECAPTION,
                                        "Gen. Bus. Posting Group", "Gen. Prod. Posting Group"));

                        if "Document No." = '' then
                            AddError(STRSUBSTNO(Text001_lbl, FIELDCAPTION("Document No.")));

                        if "No." = '' then
                            AddError(STRSUBSTNO(Text001_lbl, FIELDCAPTION("No.")))
                        else
                            case Type of
                                Type::Resource:
                                    if not Res.GET("No.") then
                                        AddError(STRSUBSTNO(Text005_lbl, "No."))
                                    else
                                        if Res.Blocked then
                                            AddError(STRSUBSTNO(Text006_lbl, Res.FIELDCAPTION(Blocked), false, "No."));
                                Type::Item:
                                    if not Item.GET("No.") then
                                        AddError(STRSUBSTNO(Text007_lbl, "No."))
                                    else
                                        if Item.Blocked then
                                            AddError(STRSUBSTNO(Text008_lbl, Item.FIELDCAPTION(Blocked), false, "No."));
                                Type::"G/L Account":
                                    ;
                            end;

                        CheckRecurringLine("Job Journal Line");

                        if "Posting Date" = 0D then
                            AddError(STRSUBSTNO(Text001_lbl, FIELDCAPTION("Posting Date")))
                        else begin
                            if "Posting Date" <> NORMALDATE("Posting Date") then
                                AddError(STRSUBSTNO(Text009_lbl, FIELDCAPTION("Posting Date")));

                            if "Job Journal Batch"."No. Series" <> '' then
                                if NoSeries."Date Order" and ("Posting Date" < LastPostingDate) then
                                    AddError(Text010_lbl);
                            LastPostingDate := "Posting Date";

                            if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then begin
                                if USERID <> '' then
                                    if UserSetup.GET(USERID) then begin
                                        AllowPostingFrom := UserSetup."Allow Posting From";
                                        AllowPostingTo := UserSetup."Allow Posting To";
                                    end;
                                if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then begin
                                    GLSetup.GET;
                                    AllowPostingFrom := GLSetup."Allow Posting From";
                                    AllowPostingTo := GLSetup."Allow Posting To";
                                end;
                                if AllowPostingTo = 0D then
                                    AllowPostingTo := 99991231D;
                            end;
                            if ("Posting Date" < AllowPostingFrom) or ("Posting Date" > AllowPostingTo) then
                                AddError(STRSUBSTNO(Text011, FORMAT("Posting Date")))
                            else
                                if Type = Type::Item then begin
                                    InvtPeriodEndDate := "Posting Date";
                                    if not InvtPeriod.IsValidDate(InvtPeriodEndDate) then
                                        AddError(STRSUBSTNO(Text011, FORMAT("Posting Date")))
                                end;
                        end;

                        if "Document Date" <> 0D then
                            if "Document Date" <> NORMALDATE("Document Date") then
                                AddError(STRSUBSTNO(Text009_lbl, FIELDCAPTION("Document Date")));

                        if "Job Journal Batch"."No. Series" <> '' then begin
                            if LastDocNo <> '' then
                                if ("Document No." <> LastDocNo) and ("Document No." <> INCSTR(LastDocNo)) then
                                    AddError(Text012);
                            LastDocNo := "Document No.";
                        end;

                        if not DimMgt.CheckDimIDComb("Dimension Set ID") then
                            AddError(DimMgt.GetDimCombErr);

                        TableID[1] := DATABASE::Job;
                        No[1] := "Job No.";
                        TableID[2] := DimMgt.TypeToTableID2(Type);
                        No[2] := "No.";
                        TableID[3] := DATABASE::"Resource Group";
                        No[3] := "Resource Group No.";
                        if not DimMgt.CheckDimValuePosting(TableID, No, "Dimension Set ID") then
                            AddError(DimMgt.GetDimValuePostingErr);

                        // Manually accumulate Employee level totals
                        JobJournalLine2.SETRANGE("Journal Template Name", "Job Journal Line"."Journal Template Name");
                        JobJournalLine2.SETRANGE("Journal Batch Name", "Job Journal Line"."Journal Batch Name");
                        JobJournalLine2.SETRANGE("No.", "Job Journal Line"."No.");
                        JobJournalLine2.CALCSUMS(Quantity, "Total Cost (LCY)", "NS_Payroll Burden Amount", "NS_Work Units");

                        // Manually accumulate REPORT totals
                        JobJournalLine3.SETRANGE("Journal Template Name", "Job Journal Line"."Journal Template Name");
                        JobJournalLine3.SETRANGE("Journal Batch Name", "Job Journal Line"."Journal Batch Name");
                        JobJournalLine3.CALCSUMS(Quantity, "Total Cost (LCY)", "NS_Payroll Burden Amount", "NS_Work Units");
                    end;

                    trigger OnPreDataItem();
                    begin
                        JobJnlTemplate.GET("Job Journal Batch"."Journal Template Name");
                        if JobJnlTemplate.Recurring then begin
                            if GETFILTER("Posting Date") <> '' then
                                AddError(
                                  STRSUBSTNO(
                                    Text000_lbl, FIELDCAPTION("Posting Date")));
                            SETRANGE("Posting Date", 0D, WORKDATE);
                            if GETFILTER("Expiration Date") <> '' then
                                AddError(
                                  STRSUBSTNO(
                                    Text000_lbl, FIELDCAPTION("Expiration Date")));
                            SETFILTER("Expiration Date", '%1 | %2..', 0D, WORKDATE);
                        end;

                        CurrReport.CREATETOTALS("Total Cost", "Total Price", Quantity, "Total Cost (LCY)", "Line Amount", "NS_Payroll Burden Amount", "NS_Work Units");

                        if "Job Journal Batch"."No. Series" <> '' then
                            NoSeries.GET("Job Journal Batch"."No. Series");
                        LastPostingDate := 0D;
                        LastDocNo := '';
                    end;
                }
            }

            trigger OnAfterGetRecord();
            begin
                CurrReport.PAGENO := 1;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ShowDim; ShowDim)
                    {
                        Caption = 'Show Dimensions';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        JobJnlLineFilter := "Job Journal Line".GETFILTERS;
    end;

    var
        Text000_lbl: Label '%1 cannot be filtered when you post recurring journals.';
        Text001_lbl: Label '%1 must be specified.';
        Text002_lbl: Label 'Job %1 does not exist.';
        Text003_lbl: Label '%1 must not be %2 for job %3.';
        Text004_lbl: Label '%1 %2 %3 does not exist.';
        Text005_lbl: Label 'Resource %1 does not exist.';
        Text006_lbl: Label '%1 must be %2 for resource %3.';
        Text007_lbl: Label 'Item %1 does not exist.';
        Text008_lbl: Label '%1 must be %2 for item %3.';
        Text009_lbl: Label '%1 must not be a closing date.';
        Text010_lbl: Label 'The lines are not listed according to posting date because they were not entered in that order.';
        Text011: Label '%1 is not within your allowed range of posting dates.';
        Text012: Label 'There is a gap in the number series.';
        Text013: Label '%1 cannot be specified.';
        Text014: Label '<Month Text>';
        UserSetup: Record "User Setup";
        GLSetup: Record "General Ledger Setup";
        AccountingPeriod: Record "Accounting Period";
        Job: Record Job;
        JT: Record "Job Task";
        Res: Record Resource;
        Item: Record Item;
        JobJnlTemplate: Record "Job Journal Template";
        GenPostingSetup: Record "General Posting Setup";
        NoSeries: Record "No. Series";
        DimSetEntry: Record "Dimension Set Entry";
        InvtPeriod: Record "Inventory Period";
        DimMgt: Codeunit 408;
        JobJournalLine2: Record "Job Journal Line";
        JobJournalLine3: Record "Job Journal Line";
        AllowPostingFrom: Date;
        AllowPostingTo: Date;
        Day: Integer;
        Week: Integer;
        Month: Integer;
        MonthText: Text[30];
        ErrorCounter: Integer;
        ErrorText: array[50] of Text[250];
        JobJnlLineFilter: Text[250];
        LastPostingDate: Date;
        LastDocNo: Code[20];
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        DimText: Text[120];
        OldDimText: Text[120];
        ShowDim: Boolean;
        Continue: Boolean;
        Text015: Label '%1 %2 does not exist.';
        Job_Journal_Batch___Journal_Template_Name_CaptionLbl: Label 'Journal Template';
        Job_Journal_Batch__NameCaptionLbl: Label 'Journal Batch';
        Job_Journal___TestCaptionLbl: Label 'Job Journal - Test';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Job_Journal_Line__Posting_Date_CaptionLbl: Label 'Posting Date';
        DimensionsCaptionLbl: Label 'Dimensions';
        ErrorText_Number_CaptionLbl: Label 'Warning!';
        TotalQuantity_Employee: Decimal;
        TotalCostLCY_Employee: Decimal;
        TotalPayrollBurdenAmt_Employee: Decimal;
        TotalWorkUnits_Employee: Decimal;
        TotalQuantity_REPORT: Decimal;
        TotalCostLCY_REPORT: Decimal;
        TotalPayrollBurdenAmt_REPORT: Decimal;
        TotalWorkUnits_REPORT: Decimal;

    local procedure CheckRecurringLine(JobJnlLine2: Record "Job Journal Line");
    begin
        with JobJnlLine2 do
            if JobJnlTemplate.Recurring then begin
                if "Recurring Method" = 0 then
                    AddError(STRSUBSTNO(Text001_lbl, FIELDCAPTION("Recurring Method")));
                if FORMAT("Recurring Frequency") = '' then
                    AddError(STRSUBSTNO(Text001_lbl, FIELDCAPTION("Recurring Frequency")));
                if "Recurring Method" = "Recurring Method"::Variable then
                    if Quantity = 0 then
                        AddError(STRSUBSTNO(Text001_Lbl, FIELDCAPTION(Quantity)));
            end else begin
                if "Recurring Method" <> 0 then
                    AddError(STRSUBSTNO(Text013, FIELDCAPTION("Recurring Method")));
                if FORMAT("Recurring Frequency") <> '' then
                    AddError(STRSUBSTNO(Text013, FIELDCAPTION("Recurring Frequency")));
            end;
    end;

    local procedure MakeRecurringTexts(var JobJnlLine2: Record "Job Journal Line");
    begin
        with JobJnlLine2 do
            if ("Posting Date" <> 0D) and ("No." <> '') and ("Recurring Method" <> 0) then begin
                Day := DATE2DMY("Posting Date", 1);
                Week := DATE2DWY("Posting Date", 2);
                Month := DATE2DMY("Posting Date", 2);
                MonthText := FORMAT("Posting Date", 0, Text014);
                AccountingPeriod.SETRANGE("Starting Date", 0D, "Posting Date");
                if not AccountingPeriod.FINDLAST then
                    AccountingPeriod.Name := '';
                "Document No." :=
                  DELCHR(PADSTR(STRSUBSTNO("Document No.", Day, Week, Month, MonthText, AccountingPeriod.Name),
                      MAXSTRLEN("Document No.")), '>');
                Description :=
                  DELCHR(PADSTR(STRSUBSTNO(Description, Day, Week, Month, MonthText, AccountingPeriod.Name),
                      MAXSTRLEN(Description)), '>');
            end;
    end;

    local procedure AddError(Text: Text[250]);
    begin
        ErrorCounter := ErrorCounter + 1;
        ErrorText[ErrorCounter] := Text;
    end;

    procedure InitializeRequest(NewShowDim: Boolean);
    begin
        ShowDim := NewShowDim;
    end;
}

