page 14021304 NS_RevenueRecognitionSummary
{
    //CTSI-274.AM.1.0 Added New page 
    //PRJ-830.AS.1.0 06AUG2021 Removed NS Captions from fields
    //PRJ-1041.AS.1.0 Added Dimensions button to shows dimensions flowed from Job Table
    //PRJ-1098.NK.0.0 18Feb2022 |Add Two Fields
    //PRJ-1385.RM.1.0 12May2022 | Added fields' caption
    //PRJ-1385.RM.2.0 18May2022 | Added caption  
    //PRJ-1413.NK.1.0 23May2022 | Add Code
    //PRJ-1434.JS.1.0 06JUN2022 | Add condition
    //PRJ-1463.NK.0.0 17Jun2022 | Add Fields
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = NS_RevenueRecSummaryTab;
    Caption = 'Revenue Recognition Summary Details';
    // Editable = Editbool;
    //PRJ-588.AS.1.0 04MAY2021 Arranged field columns
    //PRJ-983.GK.1.0 14Oct2021 | Added new caption.
    //FGH-16.SK.1.0 | 13JAN2022 | Added code and field for support of Rev rec customisation
    //PRJ-1131.NK.1.0 11Jan2022 | Removed with statement
    //FGH-16.JS.1.0 | 24FEB2022
    //PRJ-1227.JS.1.0 02MAR2022 | Correect code
    //PRJ-1355.JS.1.0 18MAY2022 | Correct Code

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; REC."NS_Entry No.")
                {
                    Caption = 'Entry No.';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = All;
                }
                field("Posting Date"; REC."NS_Posting Date")
                {
                    Caption = 'Posting Date';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = All;
                }
                field("Entry Type"; REC."NS_Entry Type")
                {
                    Caption = 'Entry Type';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = All;
                }
                field("Job No."; REC."NS_Job No.")
                {
                    Caption = 'Job No.';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = All;
                }
                //PE-174.AS.1.0 16NOV2023 START
                field("NS_TCE Override"; Rec."NS_TCE Override")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        revrecsumRec: Record NS_RevenueRecSummaryTab;

                    begin
                        //PE-174.AS.5.0 START ADD
                        //PE-174.JS.1.0 31Jan2024 start
                        if (Rec."NS_POC Method" <> Rec."NS_POC Method"::"NS_Job forecast") and
                            (Rec."NS_POC Method" <> Rec."NS_POC Method"::NS_BudgettoActualCost) then
                            Error('"POC Method" must be "Job Forecast" or "Budget To Actual Cost" on job card.');
                        //PE-174.JS.1.0 31Jan2024 end
                        //PE-174.AS.5.0 END ADD

                        //PE-174.AS.5.0 START COMMENT
                        // //PE-174.AS.1.0 21NOV2023 START
                        // if (Rec."NS_Entry Type" = Rec."NS_Entry Type"::Finance) then
                        //     Error('You cannot override the Finance entry for new TCE calculation');
                        // //PE-174.AS.1.0 21NOV2023 END
                        //PE-174.AS.5.0 END COMMENT

                        if revrecsumRec.Get(Rec."NS_New TCE Ref") then
                            Error('New TCE Ref" No. already exist for "Entry No. %1', Rec."NS_New TCE Ref");


                        if rec."NS_TCE Override" = false then
                            Rec."NS_New TCE Ref" := 0;


                        if rec."NS_TCE Override" = true THEN
                            // if (Rec."NS_Entry Type" = Rec."NS_Entry Type"::JFW) and (Rec.NS_Voided = FALSE) then begin //PE-174.AS.5.0 COMMENT

                            if (Rec.NS_Voided = FALSE) then begin//PE-174.AS.5.0 ADD
                                Rec.NS_CopyRevRecLinesForOverRide(Rec);//PE-174.AS.1.0 16NOV2023 Added Function NS_CopyRevRecLinesForOverRide()
                                CurrPage.Update(false);
                            end;
                    end;
                }
                field("NS_PrevEntry Type"; Rec."NS_PrevEntry Type")
                {
                    Caption = 'Previous Entry Type';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("NS_Ref No."; Rec."NS_Ref No.")
                {
                    ApplicationArea = All;
                }
                field("NS_New TCE Ref"; Rec."NS_New TCE Ref")
                {
                    ApplicationArea = All;
                }
                field("NS_TCE Over-ridden"; Rec."NS_TCE Over-ridden")
                {
                    ApplicationArea = All;
                }
                //PE-174.AS.1.0 16NOV2023 END
                field("Job Description"; REC."NS_Job Description")
                {
                    Caption = 'Job Description';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = all;
                }
                field("Current Contract"; REC."NS_Current Contract")
                {
                    Caption = 'Current Contract';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = All;
                }
                field("Billings to Date"; Rec."NS_Billings to Date") //PRJ-1131.NK.1.0
                {
                    Caption = 'Billings to Date';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = all;
                    Description = 'PRJ-830.MS.1.0';
                }

                field("Actual Costs To Date"; REC."NS_Actual Costs To Date")
                {
                    Caption = 'Actual Costs To Date';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = All;
                }
                field("Period Costs"; REC."NS_Period Costs")
                {
                    Caption = 'Period Costs';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = All;
                }
                field("Current(TCE) Est. Cost at Completion"; REC."NS_Current(TCE) Est. Cost at Completion")
                {
                    ApplicationArea = All;
                    Caption = 'Current (TCE) Est. Cost at Completion';
                }
                field("POC %"; REC."NS_POC %")
                {
                    Caption = 'POC %';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = All;
                }
                //FGH-16.SK.1.0 Start
                //PRJ-1098.NK.0.0 19May2022 Start
                field("NS_JobTarget%"; Rec."NS_JobTarget%")
                {
                    ApplicationArea = all;
                    ToolTip = 'Job Target %';
                    Caption = 'Job Target %';
                    Visible = false; //PRJ-1463.NK.0.0 17Jun2022 
                }
                //PRJ-1098.NK.0.0 19May2022
                //PRJ-1463.NK.0.0 17Jun2022 Start
                field("NS_EstMarkup%"; Rec."NS_EstMarkup%")
                {
                    ApplicationArea = all;
                    ToolTip = 'Est. Markup %';
                    Caption = 'Est. Markup %';
                }
                field("NS_EstGrossProfit%"; Rec."NS_EstGrossProfit%")
                {
                    ApplicationArea = all;
                    ToolTip = 'Est. Gross Profit %';
                    Caption = 'Est. Gross Profit %';
                }
                //PRJ-1463.NK.0.0 17Jun2022 End
                field("NS_POC Method"; Rec."NS_POC Method")
                {
                    ApplicationArea = all;
                    Caption = 'POC Method';
                    ToolTip = 'Specifies the POC method that is applied on this JOB';
                    Editable = false;
                }
                //FGH-16.SK.1.0 End
                field("Gross Revenue"; REC."NS_Gross Revenue")//PRJ-588.AS.1.0 04MAY2021
                {
                    Caption = 'Gross Revenue';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = All;
                }
                field("Gross Profit"; REC."NS_Gross Profit")//PRJ-588.AS.1.0 04MAY2021
                {
                    Caption = 'Gross Profit';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = All;
                }
                field("Current GM %"; REC."NS_Current GM %")
                {
                    Caption = 'Current GM %';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = all;
                }
                field("Over Billings"; Rec."NS_Over Billings") //PRJ-1131.NK.1.0
                {
                    Caption = 'Over Billings';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = all;
                    Description = 'PRJ-830.MS.1.0';
                }
                field("Under Billings"; Rec."NS_Under Billings") //PRJ-1131.NK.1.0
                {
                    Caption = 'Under Billings';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = all;
                    Description = 'PRJ-830.MS.1.0';
                }
                field("Net Revenue"; REC."NS_Net Revenue")
                {
                    Caption = 'Net Revenue';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = All;
                }
                field("Net Profit"; REC."NS_Net Profit")
                {
                    Caption = 'Net Profit';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = all;
                }
                field(Voided; REC.NS_Voided)
                {
                    Caption = 'Voided';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Posted; REC.NS_Posted)
                {
                    Caption = 'Posted';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = all;
                    Editable = false;
                }
                // field("True-Up Posted"; "True-Up Posted")
                // {
                //     ApplicationArea = all;
                //     Editable = false;
                // } //CTSI-286 rollback
                field("Over/Under Billings Posted"; Rec."NS_Over/Under Billings Posted") //PRJ-1131.NK.1.0
                {
                    Caption = 'Over/Under Billings Posted';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = all;
                    Description = 'PRJ-830.MS.1.0';
                    Editable = false;
                }
                field("True-Up Value"; REC."NS_True-Up Value")
                {
                    //Caption = 'True-Up Value';//PRJ-830.AS.1.0 06AUG2021 //PRJ-983.GK.1.0 14Oct2021 | Comment Code
                    //   Caption = 'G/L Amt. Posted'; //PRJ-983.GK.1.0 14Oct2021| Add Code  //PRJ-1385.RM.1.0 Commented
                    // Caption = 'Net Revenue';//PRJ-1385.RM.1.0 Added caption commented
                    Caption = 'Net Revenue Posted';//PRJ-1385.RM.2.0 Added caption
                    ApplicationArea = all;
                    Editable = false;
                    Description = 'CTSI-286.MS.1.0';
                }
                field("Billing Amt. Posted"; Rec."NS_Billing Amt. Posted") //PRJ-1131.NK.1.0
                {
                    // Caption = 'Billing Amt. Posted';//PRJ-830.AS.1.0 06AUG2021  //PRJ-1385.RM.1.0 Commented
                    Caption = 'Over/Under Billing Posted'; //PRJ-1385.RM.1.0 Added caption
                    ApplicationArea = all;
                    Description = 'PRJ-830.MS.1.0';
                    Editable = false;
                }
                field("NS_Global Dimension 1 Code"; Rec."NS_Global Dimension 1 Code")//PRJ-950.AS.1.0
                {
                    CaptionClass = '1,1,1';
                    Caption = 'Global Dimension 1 Code';
                    ApplicationArea = all;
                    Description = '//PRJ-950.AS.1.0';
                    Editable = false;
                }
                field("NS_Global Dimension 2 Code"; Rec."NS_Global Dimension 2 Code")//PRJ-950.AS.1.0
                {
                    CaptionClass = '1,1,2';
                    Caption = 'Global Dimension 2 Code';
                    ApplicationArea = all;
                    Description = '//PRJ-950.AS.1.0';
                    Editable = false;
                }
                //PRJ-1098.NK.0.0 18Feb2022 Start
                field(NS_EntryFromBatchJob; Rec.NS_EntryFromBatchJob)
                {
                    ApplicationArea = all;
                    ToolTip = 'Entry From Batch Job';
                    Caption = 'Entry From Batch Job';
                }
                field(NS_UpdateFromBatchJob; Rec.NS_UpdateFromBatchJob)
                {
                    ApplicationArea = all;
                    ToolTip = 'Update from Batch Job';
                    Caption = 'Update from Batch Job';
                }
                field(NS_JFWBatchDocumentNo; Rec.NS_JFWBatchDocumentNo)
                {
                    ApplicationArea = all;
                    ToolTip = 'JFW Batch Document No.';
                    Caption = 'JFW Batch Document No.';
                }
                //PRJ-1098.NK.0.0 18Feb2022 End
                //PE-136.JS.1.0 03Aug2023 - Start
                field("NS_Reversed Gen. Posted"; Rec."NS_Reversed Gen. Posted")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reversed Gen. Posted field.';
                }
                field("NS_GenJnl Posted Doc. No."; Rec."NS_GenJnl Posted Doc. No.")
                {
                    ApplicationArea = All;
                    Caption = 'Gen. Jnl. Posted Document No.';
                    ToolTip = 'Specifies the value of the Gen. Jnl. Posted Document No. field.';
                }
                //PE-136.JS.1.0 03Aug2023 - end
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GenerategenJournal)
            {
                ApplicationArea = All;
                Caption = 'Generate General Journal';
                Image = GetEntries;
                Promoted = true;
                PromotedCategory = Process;
                //RunObject = report GenerateGeneralJournal;
                trigger OnAction()
                begin
                    if UserSetup.get(UserId) then
                        if UserSetup."NS_AccessTo Rev.RecognitionReport" then begin
                            GeneraleGenJournalRep.RunModal();
                            Clear(GeneraleGenJournalRep);
                        end else
                            Error('You are not authorized to Generate General Journal.');
                end;
            }
            //PRJ-1041.AS.1.0 START
            //PRJCTPR-109.NC.1.0 11May2023 Start
            action(GeneralJournall)
            {
                ApplicationArea = All;
                Caption = 'General Journal';
                ToolTip = 'It will open the General Journal Page with the same Revenue Recognition batch which is entered on the Job Setup on field Rev. Rec. G/L Journal Batch.';
                Image = TransferToGeneralJournal;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    NS_JobSetup: Record "Jobs Setup";
                    GenJnlManagement: Codeunit 230;
                    GenJnlBatch: Record "Gen. Journal Batch";
                begin
                    if NS_JobSetup.Get() then;
                    GenJnlBatch.Reset();
                    GenJnlBatch.SetRange(Name, NS_JobSetup."NS_Burden G/L Journal Batch Rev.");
                    if GenJnlBatch.FindFirst() then
                        GenJnlManagement.TemplateSelectionFromBatch(GenJnlBatch);
                end;
            }
            //PRJCTPR-109.NC.1.0 11May2023 End
            //FGH-16.SK.1.0 Start
            action(NS_CalculateRevRec)
            {
                ApplicationArea = All;
                Caption = 'Calculate Revenue Recognition';
                ToolTip = 'Calculation of Revenue Recognition on based of POC Method';
                Image = CalculateSimulation;
                Visible = false;//PRJ-1383.GK.1.0 02June2022
                trigger OnAction()
                var
                    RevRecSummary: Record NS_RevenueRecSummaryTab;
                    JobRec: Record Job;
                    JPL: Record "Job Planning Line";
                    ProjSummDetails: Record "NS_Percentage of Completion";
                    TotalBudget: Decimal;
                    DateFilterVar: Date;
                    BudgetedCostValue: Decimal;
                    GrossRevBefore: Decimal;
                    Window: Dialog;
                    TotalCount: Integer;
                    CurrRec: Integer;
                    PreviousJobNo: code[20];
                    ActualCostPrevious: Decimal;
                    PreviousPOCPercent: Decimal;   //PRJ-1227.JS.1.0 02MAR2022
                begin
                    Clear(TotalBudget);
                    Clear(DateFilterVar);
                    Clear(GrossRevBefore);
                    Clear(PreviousJobNo);
                    Clear(PreviousPOCPercent);
                    Clear(JPL);
                    Window.OPEN('Calculating Rev Rec... @1@@@@@@@@@@'
                                + 'Job No.:             #2######\');
                    RevRecSummary.Reset();
                    //RevRecSummary.SetCurrentKey("NS_Posting Date", "NS_Job No.");  //FGH-16.JS.1.0 24FEB2022 line commented
                    RevRecSummary.SetCurrentKey("NS_Job No.", "NS_Posting Date");  //FGH-16.JS.1.0 24FEB2022 line added
                    RevRecSummary.SetRange(NS_Voided, false);  //PRJ-1355.JS.1.0 18MAY2022
                    RevRecSummary.SetFilter("NS_POC Method", '<>%1', RevRecSummary."NS_POC Method"::" ");   //PRJ-1355.JS.1.0 18MAY2022                    
                    // RevRecSummary.SetRange(NS_Posted, false);
                    TotalCount := RevRecSummary.Count;
                    if RevRecSummary.FindSet() then
                        repeat
                            if RevRecSummary."NS_Job No." <> PreviousJobNo then begin
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

                            Window.Update(2, RevRecSummary."NS_Job No.");
                            If JobRec.get(RevRecSummary."NS_Job No.") then
                                case JobRec."NS_POC Method" of
                                    NS_POCMethod::"NS_Gross Margin%":
                                        //    Total Actual Cost to Date = $100,000/ (1 - 8.00 %= 9.2); 100,000 /0.92= $108,695.00; 
                                        //    Then Gross Revenue is $108,695.00. 
                                        begin
                                            //PRJ-1355.JS.1.0 18MAY2022 - Start
                                            If ((RevRecSummary.NS_Posted = false) and (RevRecSummary."NS_Over/Under Billings Posted" = false)
                                            and (RevRecSummary.NS_Voided = false)) then begin
                                                RevRecSummary."NS_Gross Revenue" := (RevRecSummary."NS_Actual Costs To Date" / ((1 - JobRec."NS_POC Method Value" / 100)));
                                                RevRecSummary."NS_Current GM %" := JobRec."NS_POC Method Value";
                                                RevRecSummary."NS_Gross Profit" := (RevRecSummary."NS_Gross Revenue" * RevRecSummary."NS_Current GM %") / 100;
                                            end;
                                            //PRJ-1355.JS.1.0 18MAY2022 - end
                                        end;
                                    NS_POCMethod::"NS_Manual Job%":
                                        //Gross Revenue = Current Contract * Manual Job% (value entered by the user in Job card) 
                                        begin
                                            //PRJ-1227.JS.1.0 02MAR2022 - Start
                                            If ((RevRecSummary.NS_Posted = false) and (RevRecSummary."NS_Over/Under Billings Posted" = false)
                                            and (RevRecSummary.NS_Voided = false)) then begin
                                                //PRJ-1227.JS.1.0 02MAR2022 - end
                                                RevRecSummary."NS_POC %" := JobRec."NS_Actual Percent Complete";
                                                RevRecSummary."NS_Gross Revenue" := (RevRecSummary."NS_Current Contract" * JobRec."NS_Actual Percent Complete") / 100;
                                                RevRecSummary."NS_Gross Profit" := RevRecSummary."NS_Gross Revenue" - RevRecSummary."NS_Actual Costs To Date";
                                                if RevRecSummary."NS_Gross Revenue" <> 0 then //PRJ-1098.NK.1.0 13May2022
                                                    RevRecSummary."NS_Current GM %" := (RevRecSummary."NS_Gross Profit" / RevRecSummary."NS_Gross Revenue") * 100;
                                            end;
                                        end;
                                    NS_POCMethod::"NS_Markup%":
                                        //Gross Revenue = (Actual Cost * 20%) + Actual Costs To Date 
                                        begin
                                            //PRJ-1355.JS.1.0 18MAY2022 - Start
                                            If ((RevRecSummary.NS_Posted = false) and (RevRecSummary."NS_Over/Under Billings Posted" = false)
                                            and (RevRecSummary.NS_Voided = false)) then begin
                                                RevRecSummary."NS_Gross Revenue" := (RevRecSummary."NS_Actual Costs To Date" * JobRec."NS_POC Method Value") / 100 + RevRecSummary."NS_Actual Costs To Date";
                                                RevRecSummary."NS_Gross Profit" := RevRecSummary."NS_Gross Revenue" - RevRecSummary."NS_Actual Costs To Date";
                                                if RevRecSummary."NS_Gross Revenue" <> 0 then //PRJ-1098.NK.1.0 13May2022
                                                    RevRecSummary."NS_Current GM %" := (RevRecSummary."NS_Gross Profit" / RevRecSummary."NS_Gross Revenue") * 100;
                                            end;
                                            //PRJ-1355.JS.1.0 18MAY2022 - end
                                        end;
                                    NS_POCMethod::"NS_Units Complete":
                                        begin
                                            //POC = (5000/25000) * 100 = 20% (This value gets updated in the POC% field in the Revenue Recognition Summary Details page for the selected line) 

                                            //Subsequently, Gross Revenue = POC% * Current Contract
                                            //PRJ-1227.JS.1.0 02MAR2022 - Start
                                            If ((RevRecSummary.NS_Posted = false) and (RevRecSummary."NS_Over/Under Billings Posted" = false)
                                            and (RevRecSummary.NS_Voided = false)) then begin
                                                //PRJ-1227.JS.1.0 02MAR2022 - end
                                                RevRecSummary."NS_POC %" := (JobRec."NS_Actual Units Complete" / JobRec."NS_Total Units") * 100;
                                                RevRecSummary."NS_Gross Revenue" := (RevRecSummary."NS_POC %" * RevRecSummary."NS_Current Contract") / 100;
                                                RevRecSummary."NS_Gross Profit" := RevRecSummary."NS_Gross Revenue" - RevRecSummary."NS_Actual Costs To Date";
                                                if RevRecSummary."NS_Gross Revenue" <> 0 then //PRJ-1098.NK.1.0 13May2022
                                                    RevRecSummary."NS_Current GM %" := (RevRecSummary."NS_Gross Profit" / RevRecSummary."NS_Gross Revenue") * 100;
                                            end;
                                            PreviousPOCPercent := 0;
                                            PreviousPOCPercent := RevRecSummary."NS_POC %";
                                            //PRJ-1227.JS.1.0 02MAR2022 - line added
                                        end;
                                    NS_POCMethod::NS_BudgettoActualCost:
                                        begin
                                            //PRJ-1355.JS.1.0 18MAY2022 - Start
                                            If ((RevRecSummary.NS_Posted = false) and (RevRecSummary."NS_Over/Under Billings Posted" = false)
                                            and (RevRecSummary.NS_Voided = false)) then begin
                                                ProjSummDetails.Reset();
                                                ProjSummDetails.SetRange("NS_Job No.", Rec."NS_Job No.");
                                                ProjSummDetails.SetRange("NS_Posting Date", Rec."NS_Posting Date");
                                                IF ProjSummDetails.FindLast() then
                                                    BudgetedCostValue := ProjSummDetails."NS_Total Budgeted Costs";
                                                IF BudgetedCostValue <> 0 then
                                                    RevRecSummary."NS_POC %" := (RevRecSummary."NS_Actual Costs To Date" / BudgetedCostValue) * 100;
                                                RevRecSummary."NS_Gross Revenue" := (RevRecSummary."NS_Current Contract" * RevRecSummary."NS_POC %") / 100; //SK
                                                RevRecSummary."NS_Gross Profit" := RevRecSummary."NS_Gross Revenue" - RevRecSummary."NS_Actual Costs To Date";
                                                if RevRecSummary."NS_Gross Revenue" <> 0 then
                                                    RevRecSummary."NS_Current GM %" := (RevRecSummary."NS_Gross Profit" / RevRecSummary."NS_Gross Revenue") * 100;
                                            end;
                                            //PRJ-1355.JS.1.0 18MAY2022 - end
                                        end;
                                end;

                            ////TODAY
                            if RevRecSummary."NS_Billings to Date" > RevRecSummary."NS_Gross Revenue" then begin
                                RevRecSummary."NS_Over Billings" := RevRecSummary."NS_Billings to Date" - RevRecSummary."NS_Gross Revenue";
                                RevRecSummary."NS_Under Billings" := 0;
                            end;

                            if RevRecSummary."NS_Billings to Date" < RevRecSummary."NS_Gross Revenue" then begin
                                RevRecSummary."NS_Under Billings" := RevRecSummary."NS_Gross Revenue" - RevRecSummary."NS_Billings to Date";
                                RevRecSummary."NS_Over Billings" := 0;
                            end;
                            //PRJ-1434.JS.1.0 06JUN2022 - Start
                            if RevRecSummary."NS_Billings to Date" = RevRecSummary."NS_Gross Revenue" then begin
                                RevRecSummary."NS_Under Billings" := 0;
                                RevRecSummary."NS_Over Billings" := 0;
                            end;
                            //PRJ-1434.JS.1.0 06JUN2022 - end
                            RevRecSummary."NS_Net Revenue" := RevRecSummary."NS_Gross Revenue" - GrossRevBefore;
                            RevRecSummary."NS_Period Costs" := RevRecSummary."NS_Actual Costs To Date" - ActualCostPrevious;
                            RevRecSummary."NS_Net Profit" := RevRecSummary."NS_Net Revenue" - RevRecSummary."NS_Period Costs";

                            GrossRevBefore := RevRecSummary."NS_Gross Revenue";
                            ActualCostPrevious := RevRecSummary."NS_Actual Costs To Date";
                            PreviousJobNo := RevRecSummary."NS_Job No.";
                            ////TODAY
                            //PRJ-1413.NK.1.0 23May2022 Start
                            if RevRecSummary.NS_EntryFromBatchJob then
                                RevRecSummary."NS_Entry Type" := RevRecSummary."NS_Entry Type"::Batch
                            else
                                //PRJ-1413.NK.1.0 23May2022 end
                                RevRecSummary."NS_Entry Type" := RevRecSummary."NS_Entry Type"::Finance;
                            //PRJ-1227.JS.1.0 02MAR2022 - Start
                            //If NOT RevRecSummary.NS_Posted then   
                            //If (NOT RevRecSummary.NS_Posted OR RevRecSummary."NS_Over/Under Billings Posted"
                            //        OR RevRecSummary.NS_Voided) then
                            If ((RevRecSummary.NS_Posted = false) and (RevRecSummary."NS_Over/Under Billings Posted" = false)
                            and (RevRecSummary.NS_Voided = false)) then
                                //PRJ-1227.JS.1.0 02MAR2022 - end        
                                RevRecSummary.Modify();
                        until RevRecSummary.Next() = 0;

                    Window.Close();
                    CurrPage.Update(false);   //PRJ-1434.JS.1.0 06JUN2022
                end;
            }
            //FGH-16.SK.1.0 End
            //PRJ-1383.GK.1.0 02June2022 start
            action(NS_CalculateRevRec1)
            {
                ApplicationArea = All;
                Caption = 'Calculate Revenue Recognition';
                ToolTip = 'Calculation of Revenue Recognition on based of POC Method';
                Image = CalculateSimulation;
                trigger OnAction()

                begin
                    Rec.NS_NewTCERefVoid();//PE-174.AS.3.0
                    CurrPage.Update(false);//PE-174.AS.3.0

                    Commit();//PE-174.AS.3.0
                    Report.RunModal(14021486, true, false, Rec);
                end;
            }
            //PRJ-1383.GK.1.0 02June2022 end

            action(Dimensions)
            {
                ApplicationArea = All;
                Caption = 'Dimensions';
                Image = Dimensions;
                ShortCutKey = 'Shift+Ctrl+D';
                ToolTip = 'View Dimensions';

                trigger OnAction();
                begin
                    Rec.NS_ShowDocDim(); //PRJ-1131.NK.1.0
                    CurrPage.SAVERECORD();
                end;
            }
            //PRJ-1041.AS.1.0 END
        }
    }
    trigger OnOpenPage()
    var
    begin
        if UserSetup.get(UserId) then
            if UserSetup."NS_AccessTo Rev.RecognitionReport" then
                CurrPage.Editable := true
            else
                CurrPage.Editable := false;
    end;

    //PRJ-1383.GK.1.0 02June2022 start
    /// <summary>
    /// GetRecords.
    /// </summary>
    /// <param name="VAR RevRecSum">Record NS_RevenueRecSummaryTab.</param>
    procedure GetRecords(VAR RevRecSum: Record NS_RevenueRecSummaryTab)
    begin
        CurrPage.SetSelectionFilter(Rec);
        RevRecSum.COPY(Rec);
        RevRecSum.MARKEDONLY(TRUE);
        IF RevRecSum.COUNT = 0 THEN BEGIN
            RevRecSum.COPY(Rec);
            RevRecSum.MARK(TRUE);
        END;
        RevRecSum.MARKEDONLY(FALSE);
    end;
    //PRJ-1383.GK.1.0 02June2022 end

    trigger OnModifyRecord(): Boolean
    begin
        //PE-174.AS.5.0 COMMENT START
        // //PE-174.AS.1.0 21NOV2023 START
        // if (Rec."NS_Entry Type" = Rec."NS_Entry Type"::JFW) and (Rec."NS_NEW TCE Ref" <> 0) then
        //     Error('You cannot modify because this entry is having Refrence Entry No.');
        // //PE-174.AS.1.0 21NOV2023 END
        //PE-174.AS.5.0 COMMENT END


        //PE-174.AS.5.0 START ADD
        if (Rec."NS_NEW TCE Ref" <> 0) then
            Error('You cannot modify because this entry is having Refrence Entry No.');
        //PE-174.AS.5.0 END ADD
    end;


    var
        myInt: Integer;
        UserSetup: Record "User Setup";
        EditBool: Boolean;
        GeneraleGenJournalRep: Report NS_GenerateGeneralJournal;
}