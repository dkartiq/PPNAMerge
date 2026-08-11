/// <summary>
/// Report NS_Calculate Revenue Recognition (ID 14021486).
/// </summary>
/// 
//PRJ-1383.GK.1.0 02June2022
//PRJ-1434.JS.1.0 07JUN2022 | Add condition
report 14021486 "NS_CalculateRevenueRecognition"
{
    // UsageCategory = Lists; //PRJCTPR-405.DK.1.0 24July2024
    //ApplicationArea = All;
    Caption = 'Calculate Revenue Recognition';
    ProcessingOnly = true;

    dataset
    {
        dataitem(CalcRevRec; NS_RevenueRecSummaryTab)
        {
            DataItemTableView = sorting("NS_Job No.") order(ascending) where(NS_Voided = filter(false), "NS_POC Method" = filter(<> " "));
            trigger OnPreDataItem()
            begin
                if JobNo <> '' then
                    SetFilter("NS_Job No.", JobNo);
                //PRJ-1734.GK.1.0 07Dec2022 start
                Clear(GrossRevBefore);
                Clear(PreviousJobNo);
                Clear(ActualCostPrevious);
                //PRJ-1734.GK.1.0 07Dec2022 end

            end;

            trigger OnAfterGetRecord()
            var
                //CalcRevRec: Record NS_RevenueRecSummaryTab;
                JobRec: Record Job;
                JPL: Record "Job Planning Line";
                ProjSummDetails: Record "NS_Percentage of Completion";
                TotalBudget: Decimal;
                DateFilterVar: Date;
                BudgetedCostValue: Decimal;
                //GrossRevBefore: Decimal;//PRJ-1734.GK.1.0 07Dec2022-comment
                Window: Dialog;
                TotalCount: Integer;
                CurrRec: Integer;
                //PRJ-1734.GK.1.0 07Dec2022 start-Comment
                //PreviousJobNo: code[20];
                //ActualCostPrevious: Decimal;
                //PRJ-1734.GK.1.0 07Dec2022 end
                PreviousPOCPercent: Decimal;
                jobstprec: Record "Jobs Setup";//PE-189.AS.1.0
            begin
                Clear(TotalBudget);
                Clear(DateFilterVar);
                //PRJ-1734.GK.1.0 07Dec2022 start-Comment
                // Clear(GrossRevBefore);
                // Clear(PreviousJobNo);
                //PRJ-1734.GK.1.0 07Dec2022 end
                Clear(PreviousPOCPercent);
                Clear(EntryTypeOptions);//PE-174.AS.2.0 21NOV2023 
                Clear(JPL);
                Window.OPEN('Calculating Rev Rec... @1@@@@@@@@@@'
                            + 'Job No.:             #2######\');
                TotalCount := CalcRevRec.Count;
                if CalcRevRec."NS_Job No." <> PreviousJobNo then begin
                    GrossRevBefore := 0;
                    ActualCostPrevious := 0;
                end;
                Sleep(250);
                CurrRec += 1;
                IF TotalCount <= 100 THEN
                    Window.UPDATE(1, (CurrRec / TotalCount * 10000) DIV 1)
                ELSE
                    IF CurrRec MOD (TotalCount DIV 100) = 0 THEN
                        Window.UPDATE(1, (CurrRec / TotalCount * 10000) DIV 1);

                Window.Update(2, CalcRevRec."NS_Job No.");
                If JobRec.get(CalcRevRec."NS_Job No.") then
                    case JobRec."NS_POC Method" of
                        NS_POCMethod::"NS_Gross Margin%":
                            //    Total Actual Cost to Date = $100,000/ (1 - 8.00 %= 9.2); 100,000 /0.92= $108,695.00; 
                            //    Then Gross Revenue is $108,695.00. 
                            begin
                                If ((CalcRevRec.NS_Posted = false) and (CalcRevRec."NS_Over/Under Billings Posted" = false)
                                and (CalcRevRec.NS_Voided = false)) then begin
                                    CalcRevRec."NS_Gross Revenue" := (CalcRevRec."NS_Actual Costs To Date" / ((1 - JobRec."NS_POC Method Value" / 100)));
                                    CalcRevRec."NS_Current GM %" := JobRec."NS_POC Method Value";
                                    CalcRevRec."NS_Gross Profit" := (CalcRevRec."NS_Gross Revenue" * CalcRevRec."NS_Current GM %") / 100;
                                end;
                            end;
                        NS_POCMethod::"NS_Manual Job%":
                            //Gross Revenue = Current Contract * Manual Job% (value entered by the user in Job card) 
                            begin
                                If ((CalcRevRec.NS_Posted = false) and (CalcRevRec."NS_Over/Under Billings Posted" = false)
                                and (CalcRevRec.NS_Voided = false)) then begin
                                    CalcRevRec."NS_POC %" := JobRec."NS_Actual Percent Complete";
                                    CalcRevRec."NS_Gross Revenue" := (CalcRevRec."NS_Current Contract" * JobRec."NS_Actual Percent Complete") / 100;
                                    CalcRevRec."NS_Gross Profit" := CalcRevRec."NS_Gross Revenue" - CalcRevRec."NS_Actual Costs To Date";
                                    if CalcRevRec."NS_Gross Revenue" <> 0 then
                                        CalcRevRec."NS_Current GM %" := (CalcRevRec."NS_Gross Profit" / CalcRevRec."NS_Gross Revenue") * 100;
                                end;
                            end;
                        NS_POCMethod::"NS_Markup%":
                            //Gross Revenue = (Actual Cost * 20%) + Actual Costs To Date 
                            begin
                                If ((CalcRevRec.NS_Posted = false) and (CalcRevRec."NS_Over/Under Billings Posted" = false)
                                and (CalcRevRec.NS_Voided = false)) then begin
                                    CalcRevRec."NS_Gross Revenue" := (CalcRevRec."NS_Actual Costs To Date" * JobRec."NS_POC Method Value") / 100 + CalcRevRec."NS_Actual Costs To Date";
                                    CalcRevRec."NS_Gross Profit" := CalcRevRec."NS_Gross Revenue" - CalcRevRec."NS_Actual Costs To Date";
                                    if CalcRevRec."NS_Gross Revenue" <> 0 then
                                        CalcRevRec."NS_Current GM %" := (CalcRevRec."NS_Gross Profit" / CalcRevRec."NS_Gross Revenue") * 100;
                                end;
                            end;
                        NS_POCMethod::"NS_Units Complete":
                            begin
                                //POC = (5000/25000) * 100 = 20% (This value gets updated in the POC% field in the Revenue Recognition Summary Details page for the selected line) 

                                //Subsequently, Gross Revenue = POC% * Current Contract
                                If ((CalcRevRec.NS_Posted = false) and (CalcRevRec."NS_Over/Under Billings Posted" = false)
                                and (CalcRevRec.NS_Voided = false)) then begin
                                    CalcRevRec."NS_POC %" := (JobRec."NS_Actual Units Complete" / JobRec."NS_Total Units") * 100;
                                    CalcRevRec."NS_Gross Revenue" := (CalcRevRec."NS_POC %" * CalcRevRec."NS_Current Contract") / 100;
                                    CalcRevRec."NS_Gross Profit" := CalcRevRec."NS_Gross Revenue" - CalcRevRec."NS_Actual Costs To Date";
                                    if CalcRevRec."NS_Gross Revenue" <> 0 then
                                        CalcRevRec."NS_Current GM %" := (CalcRevRec."NS_Gross Profit" / CalcRevRec."NS_Gross Revenue") * 100;
                                end;
                                PreviousPOCPercent := 0;
                                PreviousPOCPercent := CalcRevRec."NS_POC %";
                            end;
                        NS_POCMethod::NS_BudgettoActualCost:
                            begin
                                //PE-174.JS.1.0 02FEB2024 - Start
                                // If ((CalcRevRec.NS_Posted = false) and (CalcRevRec."NS_Over/Under Billings Posted" = false)
                                // and (CalcRevRec.NS_Voided = false)) then begin
                                //     ProjSummDetails.Reset();
                                //     ProjSummDetails.SetRange("NS_Job No.", CalcRevRec."NS_Job No.");//PRJ-1383 Replace Rec to CalcRevRec
                                //     ProjSummDetails.SetRange("NS_Posting Date", CalcRevRec."NS_Posting Date"); //PRJ-1383 Replace Rec to CalcRevRec
                                //     IF ProjSummDetails.FindLast() then
                                //         BudgetedCostValue := ProjSummDetails."NS_Total Budgeted Costs";
                                //     IF BudgetedCostValue <> 0 then
                                //         CalcRevRec."NS_POC %" := (CalcRevRec."NS_Actual Costs To Date" / BudgetedCostValue) * 100;
                                //     CalcRevRec."NS_Gross Revenue" := (CalcRevRec."NS_Current Contract" * CalcRevRec."NS_POC %") / 100;
                                //     CalcRevRec."NS_Gross Profit" := CalcRevRec."NS_Gross Revenue" - CalcRevRec."NS_Actual Costs To Date";
                                //     if CalcRevRec."NS_Gross Revenue" <> 0 then
                                //         CalcRevRec."NS_Current GM %" := (CalcRevRec."NS_Gross Profit" / CalcRevRec."NS_Gross Revenue") * 100;
                                // end;
                                If ((CalcRevRec.NS_Posted = false) and (CalcRevRec."NS_Over/Under Billings Posted" = false)
                                and (CalcRevRec.NS_Voided = false)) then begin

                                    if jobstprec.get() then;
                                    if CalcRevRec."NS_TCE Over-ridden" = true then
                                        if CalcRevRec."NS_Current(TCE) Est. Cost at Completion" <> 0 then
                                            CalcRevRec."NS_POC %" := round((CalcRevRec."NS_Actual Costs To Date" / CalcRevRec."NS_Current(TCE) Est. Cost at Completion") * 100, jobstprec."NS_Forecast Amount Rounding");
                                    if CalcRevRec."NS_POC %" > 100 then
                                        CalcRevRec."NS_Gross Revenue" := CalcRevRec."NS_Current Contract"
                                    else
                                        if CalcRevRec."NS_POC %" < 0 then
                                            CalcRevRec."NS_Gross Revenue" := 0
                                        else
                                            CalcRevRec."NS_Gross Revenue" := round(CalcRevRec."NS_Current Contract" * CalcRevRec."NS_POC %" / 100, jobstprec."NS_Forecast Amount Rounding");//PE-183.AS.2.0 ADD

                                    CalcRevRec."NS_Gross Profit" := CalcRevRec."NS_Gross Revenue" - CalcRevRec."NS_Actual Costs To Date";
                                    if CalcRevRec."NS_Gross Revenue" <> 0 then begin
                                        CalcRevRec."NS_Current GM %" := Round((CalcRevRec."NS_Gross Profit" / CalcRevRec."NS_Gross Revenue") * 100, jobstprec."NS_Forecast Amount Rounding");//PE-183.AS.2.0 ADD

                                        IF CalcRevRec."NS_Current GM %" > 100 then
                                            CalcRevRec."NS_Current GM %" := 100;
                                        IF CalcRevRec."NS_Current GM %" < 0 then
                                            CalcRevRec."NS_Current GM %" := 0;
                                    end;
                                end;
                                //PE-174.JS.1.0 02FEB2024 - end                                
                            end;
                        //PE-189.AS.1.0 START
                        NS_POCMethod::"NS_Job forecast":
                            begin
                                If ((CalcRevRec.NS_Posted = false) and (CalcRevRec."NS_Over/Under Billings Posted" = false)
                                and (CalcRevRec.NS_Voided = false)) then begin
                                    //CalcRevRec."NS_Gross Revenue" := (CalcRevRec."NS_Current Contract" * CalcRevRec."NS_POC %") / 100;//PE-183.AS.2.0 COMMENT
                                    if jobstprec.get() then;

                                    //PE-174.AS.5.0 START
                                    if CalcRevRec."NS_TCE Over-ridden" = true then
                                        if CalcRevRec."NS_Current(TCE) Est. Cost at Completion" <> 0 then
                                            CalcRevRec."NS_POC %" := round((CalcRevRec."NS_Actual Costs To Date" / CalcRevRec."NS_Current(TCE) Est. Cost at Completion") * 100, jobstprec."NS_Forecast Amount Rounding");
                                    //PE-174.AS.5.0 END

                                    //PE-189.AS.3.0 START
                                    if CalcRevRec."NS_POC %" > 100 then
                                        CalcRevRec."NS_Gross Revenue" := CalcRevRec."NS_Current Contract"
                                    else
                                        if CalcRevRec."NS_POC %" < 0 then
                                            CalcRevRec."NS_Gross Revenue" := 0
                                        //PE-189.AS.3.0 END
                                        else
                                            CalcRevRec."NS_Gross Revenue" := round(CalcRevRec."NS_Current Contract" * CalcRevRec."NS_POC %" / 100, jobstprec."NS_Forecast Amount Rounding");//PE-183.AS.2.0 ADD

                                    CalcRevRec."NS_Gross Profit" := CalcRevRec."NS_Gross Revenue" - CalcRevRec."NS_Actual Costs To Date";
                                    if CalcRevRec."NS_Gross Revenue" <> 0 then begin
                                        CalcRevRec."NS_Current GM %" := Round((CalcRevRec."NS_Gross Profit" / CalcRevRec."NS_Gross Revenue") * 100, jobstprec."NS_Forecast Amount Rounding");//PE-183.AS.2.0 ADD

                                        IF CalcRevRec."NS_Current GM %" > 100 then
                                            CalcRevRec."NS_Current GM %" := 100;
                                        IF CalcRevRec."NS_Current GM %" < 0 then
                                            CalcRevRec."NS_Current GM %" := 0;

                                    end;
                                end;
                            end;
                    //PE-189.AS.1.0 END
                    end;

                ////TODAY
                if CalcRevRec."NS_Billings to Date" > CalcRevRec."NS_Gross Revenue" then begin
                    CalcRevRec."NS_Over Billings" := CalcRevRec."NS_Billings to Date" - CalcRevRec."NS_Gross Revenue";
                    CalcRevRec."NS_Under Billings" := 0;
                end;

                if CalcRevRec."NS_Billings to Date" < CalcRevRec."NS_Gross Revenue" then begin
                    CalcRevRec."NS_Under Billings" := CalcRevRec."NS_Gross Revenue" - CalcRevRec."NS_Billings to Date";
                    CalcRevRec."NS_Over Billings" := 0;
                end;

                //PRJ-1434.JS.1.0 07JUN2022 - Start
                if CalcRevRec."NS_Billings to Date" = CalcRevRec."NS_Gross Revenue" then begin
                    CalcRevRec."NS_Under Billings" := 0;
                    CalcRevRec."NS_Over Billings" := 0;
                end;
                //PRJ-1434.JS.1.0 07JUN2022 - end

                CalcRevRec."NS_Net Revenue" := CalcRevRec."NS_Gross Revenue" - GrossRevBefore;

                if CalcRevRec."NS_TCE Over-ridden" = false then//PE-174.AS.3.0
                    CalcRevRec."NS_Period Costs" := CalcRevRec."NS_Actual Costs To Date" - ActualCostPrevious;
                CalcRevRec."NS_Net Profit" := CalcRevRec."NS_Net Revenue" - CalcRevRec."NS_Period Costs";

                GrossRevBefore := CalcRevRec."NS_Gross Revenue";


                ActualCostPrevious := CalcRevRec."NS_Actual Costs To Date";
                PreviousJobNo := CalcRevRec."NS_Job No.";

                //PE-174.AS.2.0 21NOV2023 start
                if CalcRevRec."NS_Entry Type" = CalcRevRec."NS_Entry Type"::JFW then
                    EntryTypeOptions := CalcRevRec."NS_Entry Type"::JFW;
                if CalcRevRec."NS_Entry Type" = CalcRevRec."NS_Entry Type"::Finance then
                    EntryTypeOptions := CalcRevRec."NS_Entry Type"::Finance;
                if CalcRevRec."NS_Entry Type" = CalcRevRec."NS_Entry Type"::Batch then
                    EntryTypeOptions := CalcRevRec."NS_Entry Type"::Batch;
                //PE-174.AS.2.0 21NOV2023 end

                //PE-174.AS.4.0 22NOV2023 start
                if CalcRevRec."NS_Entry Type" = CalcRevRec."NS_Entry Type"::JFW then
                    CalcRevRec."NS_PrevEntry Type" := CalcRevRec."NS_PrevEntry Type"::JFW;
                if CalcRevRec."NS_Entry Type" = CalcRevRec."NS_Entry Type"::Finance then
                    CalcRevRec."NS_PrevEntry Type" := CalcRevRec."NS_PrevEntry Type"::Finance;
                if CalcRevRec."NS_Entry Type" = CalcRevRec."NS_Entry Type"::Batch then
                    CalcRevRec."NS_PrevEntry Type" := CalcRevRec."NS_PrevEntry Type"::Batch;
                //PE-174.AS.4.0 22NOV2023 end

                ////TODAY
                if CalcRevRec.NS_EntryFromBatchJob then
                    CalcRevRec."NS_Entry Type" := CalcRevRec."NS_Entry Type"::Batch
                else
                    CalcRevRec."NS_Entry Type" := CalcRevRec."NS_Entry Type"::Finance;

                If ((CalcRevRec.NS_Posted = false) and (CalcRevRec."NS_Over/Under Billings Posted" = false)
                                and (CalcRevRec.NS_Voided = false)) then
                    CalcRevRec.Modify();

                Window.Close();

            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(General)
                {
                    field(JobNo; JobNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Job No.';
                        trigger OnLookup(var Texts: Text): Boolean
                        var
                            RevRecSummaryDetails: Record NS_RevenueRecSummaryTab;
                            RevRecSummaryDetailsList: Page NS_RevenueRecognitionSummary;
                        begin
                            RevRecSummaryDetailsList.SETTABLEVIEW(RevRecSummaryDetails);
                            RevRecSummaryDetailsList.LOOKUPMODE(TRUE);
                            IF RevRecSummaryDetailsList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                //RevRecSummaryDetailsList.GETRECORD(RevRecSummaryDetails);
                                RevRecSummaryDetailsList.GetRecords(RevRecSummaryDetails);
                                RevRecSummaryDetails.MARKEDONLY(TRUE);
                                IF RevRecSummaryDetails.FINDSET THEN BEGIN
                                    CLEAR(JobNo);
                                    REPEAT
                                        IF JobNo = '' THEN
                                            JobNo := RevRecSummaryDetails."NS_Job No."
                                        ELSE
                                            JobNo := (JobNo + '|' + RevRecSummaryDetails."NS_Job No.");
                                    UNTIL RevRecSummaryDetails.NEXT <= 0;

                                END;
                            end;
                        end;

                    }
                }
            }
        }


    }
    var
        JobNo: Code[1024];
        //PRJ-1734.GK.1.0 07Dec2022 start
        PreviousJobNo: code[20];
        ActualCostPrevious: Decimal;
        GrossRevBefore: Decimal;
        //PRJ-1734.GK.1.0 07Dec2022 end

        EntryTypeOptions: Option ,Finance,JFW,Batch;//PE-174.AS.2.0 21NOV2023 
}