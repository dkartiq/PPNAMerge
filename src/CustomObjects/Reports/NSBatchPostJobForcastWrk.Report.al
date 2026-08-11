report 14021294 "NS_Batch Post Job Forcast Wrk"
//PRJ-1098.NK.0.0 11Feb2022 New Report
//PRJ-1413.NK.0.0 23May2022 Flow entry Type
//PRJ-1434.JS.1.0 06JUN2022 | Add condition
//PRJ-1463.NK.0.0 17Jun2022 | Add Code
//PE-196.HS.1.0 19Oct2023 | Add code
{
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Batch Posting of Job Forecast Worksheets';
    ProcessingOnly = true;


    dataset
    {

        dataitem(Job; Job)
        {
            DataItemTableView = sorting("No.") WHERE("NS_POC Method" = FILTER(<> 0), Status = filter(Open), "NS_Revenue Recognized" = const(false)); //PRJ-1098.NK.0.0 18May2022// //PRJCTPR-330.PS.2.0 18April2024
            RequestFilterFields = "Global Dimension 1 Code", "Global Dimension 2 Code"; //PRJCTPR-330.PS.2.0 17April2024
            trigger OnPreDataItem()
            var
            begin
                //PRJCTPR-330.PS.3.0 19April2024 Start
                if NS_JobNo <> '' then begin
                    Job.SetRange("No.", NS_JobNo);
                    if Job.Find() then;
                end;



                //PRJCTPR-330.PS.3.0 19April2024 End 
                if not SelectAll then
                    if ((BudgettoActualCost = false) and (JobForecast = false) and (ManualJob = false) and (UnitsComplete = false) and (Markup = false) and (GrossMargin = false)) then
                        Error('Sorry! Please select any POC Method');
                if DocNo = '' then
                    Error('Sorry! Please select Document No.');
                NSBPJFCWT.LockTable();
                NSBPJFCWT.DeleteAll();
                // NSPercentofComp.Reset();
                // NSPercentofComp.SetRange(NS_EntryFromBatchJob, true);
                // if NSPercentofComp.FindFirst() then
                //     NSPercentofComp.DeleteAll();
                // NSRevRecSumTab.Reset();
                // NSRevRecSumTab.SetRange(NS_EntryFromBatchJob, true);
                // if NSRevRecSumTab.FindFirst() then
                //     NSRevRecSumTab.DeleteAll();
                //PE-162.PS.1.0 14Sep2023  Start
                if JobSetup.Get() then;
                NSAutoRunRevRecPOCBatch := JobSetup.NS_AutoRunRevRecPOCBatch;
                //PE-162.PS.1.0 14Sep2023 End
            end;

            trigger OnAfterGetRecord()
            var
                Jbstp: Record "Jobs Setup";//PE-189.AS.1.0
                jplrevenue: Record "Job Planning Line";//PE-189.AS.1.0
                NS_JPLRevRec: Record "Job Planning Line";//PRJCTPR-330.PS.3.0
                NS_JPLProjSummDtls: Record "Job Planning Line"; //PE-287.JS.1.0 07MAY2024
                NS_JobSetup: Record "Jobs Setup"; //PE-287.JS.1.0 07MAY2024 
                NS_Jobs: Record Job; //PE-287.JS.1.0 07MAY2024
                NS_JobTasks: Record "Job Task"; //PE-287.JS.1.0 07MAY2024
                NS_JobTasks2: Record "Job Task"; //PE-287.JS.1.0 07MAY2024
            begin
                if NS_JobSetup.Get() then;  //PE-287.JS.1.0 07MAY2024
                if NS_GetJobPlaningLine("No.") then begin
                    NSBPJFCWT2.Init();
                    NSBPJFCWT2."Job No." := job."No.";
                    NSBPJFCWT2."As of Date" := AsOnDate;
                    NSBPJFCWT2."Document No." := DocNo;
                    NSBPJFCWT2."Dept Code" := "Global Dimension 1 Code";
                    NSBPJFCWT2."Div Code" := "Global Dimension 2 Code";
                    NSBPJFCWT2."POC Method" := "NS_POC Method";
                    if ((SelectAll) or (NS_BudgettoActualCost()) or (NS_JobForecast()) or (NS_ManualJob()) or (NS_UnitsComplete()) or (NS_Markup()) or (NS_GrossMargin())) then
                        if NSBPJFCWT2.Insert() then begin
                            NSPercentofComp.Init();
                            job.calcfields("NS_Budgeted Price (LCY)");//FGH-163.SM.29022024 //PE-269.JS.1.0 05MAR2024
                            BalAsonDate := 0;
                            RevenueEarned := 0;
                            TotalBudgetRemaining := 0;
                            ForecastedCostRemaining := 0;
                            RevenueEarned := 0;
                            NSPercentofComp."NS_Entry No" := NS_FindLastEntryNo();
                            NSPercentofComp."NS_Job No." := job."No.";
                            NSPercentofComp."NS_Posting Date" := AsOnDate;
                            NSPercentofComp.NS_JFWBatchDocumentNo := DocNo;
                            NSPercentofComp.NS_EntryFromBatchJob := true;
                            Job.CalcFields("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");
                            NSPercentofComp.NS_TotalForecastCompletedCost := job."NS_Budgeted Cost (LCY)";
                            //PE-287.JS.1.0 07MAY2024-Start
                            //NSPercentofComp."NS_Total Budgeted Costs" := Job."NS_Budgeted Cost (LCY)";
                            NS_JPLProjSummDtls.Reset();
                            NS_JPLProjSummDtls.SETRANGE("Job No.", Job."No.");
                            NS_JPLProjSummDtls.SetFilter("Line Type", '%1|%2', NS_JPLProjSummDtls."Line Type"::Budget, NS_JPLProjSummDtls."Line Type"::"Both Budget and Billable");
                            if AsOnDate > 0D then begin
                                if NS_JobSetup."NS_Enab. Budg.on Contract Date" then
                                    NS_JPLProjSummDtls.SETFILTER("NS_Contract Forecast Date", '..%1', AsOnDate)  //PRJCTPR-390.JS.1.0 26JUN2024
                                else
                                    NS_JPLProjSummDtls.SETFILTER("Planning Date", '..%1', AsOnDate); //PRJCTPR-390.JS.1.0 26JUN2024
                            end;
                            NS_JPLProjSummDtls.CALCSUMS("Total Cost (LCY)", "Line Amount");
                            NSPercentofComp."NS_Total Budgeted Costs" := NS_JPLProjSummDtls."Total Cost (LCY)";

                            NS_JPLProjSummDtls.Reset();
                            NS_JPLProjSummDtls.SETRANGE("Job No.", Job."No.");
                            NS_JPLProjSummDtls.SetFilter("Line Type", '%1|%2', NS_JPLProjSummDtls."Line Type"::Billable, NS_JPLProjSummDtls."Line Type"::"Both Budget and Billable");
                            if AsOnDate > 0D then begin
                                if NS_JobSetup."NS_Enab. Budg.on Contract Date" then
                                    NS_JPLProjSummDtls.SETFILTER("NS_Contract Forecast Date", '..%1', AsOnDate)  //PRJCTPR-390.JS.1.0 26JUN2024
                                else
                                    NS_JPLProjSummDtls.SETFILTER("Planning Date", '..%1', AsOnDate);  //PRJCTPR-390.JS.1.0 26JUN2024
                            end;
                            //NSPercentofComp."NS_Total Contract Revenue" := job."NS_Budgeted Price (LCY)";
                            NS_JPLProjSummDtls.CALCSUMS("Line Amount (LCY)", "Line Amount");
                            NSPercentofComp."NS_Total Contract Revenue" := NS_JPLProjSummDtls."Line Amount (LCY)";
                            //PE-287.JS.1.0 07MAY2024-end

                            BalAsonDate := NS_CaclTotalCost(Job."No.");
                            ForecastedCostRemaining := job."NS_Budgeted Cost (LCY)" - BalAsonDate;
                            NSPercentofComp."NS_Forecasted Cost Remaining" := ForecastedCostRemaining;
                            NSPercentofComp."NS_Total Cost to Date" := BalAsonDate;
                            TotalBudgetRemaining := job."NS_Budgeted Cost (LCY)" - BalAsonDate;
                            NSPercentofComp."NS_Total Budget Remaining" := TotalBudgetRemaining;

                            if job."NS_Budgeted Cost (LCY)" <> 0 then begin
                                //PE-287.JS.1.0 07MAY2024-Start
                                //NSPercentofComp."NS_Job Percent Complete" := (BalAsonDate * 100) / job."NS_Budgeted Cost (LCY)";
                                NSPercentofComp."NS_Job Percent Complete" := Round((BalAsonDate * 100) / job."NS_Budgeted Cost (LCY)", NS_JobSetup."NS_Forecast Amount Rounding");
                                //PE-287.JS.1.0 07MAY2024-end
                                RevenueEarned := Round((((BalAsonDate * 100 / job."NS_Budgeted Cost (LCY)") * job."NS_Budgeted Price (LCY)") / 100), 1);
                                NSPercentofComp."NS_Revenue Earned" := RevenueEarned;
                            end;
                            NSPercentofComp."NS_Gross Margin" := RevenueEarned - BalAsonDate;
                            if RevenueEarned <> 0 then //PRJ-1098.NK.0.0 13May2022
                                NSPercentofComp."NS_Gross Margin Percent" := ((RevenueEarned - BalAsonDate) / RevenueEarned) * 100;
                            NSPercentofComp."NS_Net Cost Variance" := ForecastedCostRemaining - TotalBudgetRemaining;
                            NSPercentofComp.Insert();

                            NSRevRecSumTab.Init();
                            NSRevRecSumTab."NS_Entry No." := NS_RevRecSumTabEntryNo();
                            NSRevRecSumTab."NS_Job No." := Job."No.";
                            NSRevRecSumTab."NS_Job Description" := Job.Description;
                            NSRevRecSumTab."NS_Posting Date" := AsOnDate;
                            NSRevRecSumTab.NS_JFWBatchDocumentNo := DocNo;
                            //PE-196.HS.1.0 19Oct2023 START
                            NSRevRecSumTab."NS_Global Dimension 1 Code" := job."Global Dimension 1 Code";
                            NSRevRecSumTab."NS_Global Dimension 2 Code" := job."Global Dimension 2 Code";
                            NSRevRecSumTab."NS_Dimension Set ID" := NSRevRecSumTab.GetDimensionNoFromJob(Job."No.");
                            //PE-196.HS.1.0 19Oct2023 END
                            NSRevRecSumTab.NS_EntryFromBatchJob := true;
                            Job.CalcFields("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");
                            // NSRevRecSumTab."NS_Current Contract" := Job."NS_Budgeted Price (LCY)"; //PRJ-1098.NK.0.0 13May2022 //PE-189.AS.1.0 Comment

                            //PE-189.AS.1.0 START
                            if Jbstp.Get() then;
                            jplrevenue.Reset;
                            jplrevenue.SETRANGE("Job No.", Job."No.");
                            jplrevenue.SetFilter("Line Type", '%1|%2', jplrevenue."Line Type"::Billable, jplrevenue."Line Type"::"Both Budget and Billable");
                            if AsOnDate > 0D then begin
                                if Jbstp."NS_Enab. Budg.on Contract Date" then
                                    jplrevenue.SETFILTER("NS_Contract Forecast Date", '..%1', AsOnDate)  //PRJCTPR-390.JS.1.0 26JUN2024
                                else
                                    jplrevenue.SETFILTER("Planning Date", '..%1', AsOnDate);  //PRJCTPR-390.JS.1.0 26JUN2024
                            end;
                            jplrevenue.CALCSUMS("Line Amount (LCY)", "Line Amount");
                            NSRevRecSumTab."NS_Current Contract" := jplrevenue."Line Amount (LCY)";
                            //PE-189.AS.1.0 END

                            BalAsonDate := NS_CaclTotalCost(Job."No.");
                            NSRevRecSumTab."NS_Actual Costs To Date" := BalAsonDate;

                            //PRJCTPR-330.PS.3.0 18April2024 Start  
                            NS_JPLRevRec.Reset;
                            NS_JPLRevRec.SETRANGE("Job No.", Job."No.");
                            NS_JPLRevRec.SetFilter("Line Type", '%1|%2', jplrevenue."Line Type"::Budget, jplrevenue."Line Type"::"Both Budget and Billable");
                            if AsOnDate > 0D then begin
                                if Jbstp."NS_Enab. Budg.on Contract Date" then
                                    NS_JPLRevRec.SETFILTER("NS_Contract Forecast Date", '..%1', AsOnDate)  //PRJCTPR-390.JS.1.0 26JUN2024
                                else
                                    NS_JPLRevRec.SETFILTER("Planning Date", '..%1', AsOnDate);  //PRJCTPR-390.JS.1.0 26JUN2024
                            end;
                            //NSRevRecSumTab."NS_Current(TCE) Est. Cost at Completion" := job."NS_Budgeted Cost (LCY)";//PRJCTPR-330.PS.3.0 18April2024 Commented 
                            NS_JPLRevRec.CALCSUMS("Total Cost (LCY)", "Total Cost");
                            NSRevRecSumTab."NS_Current(TCE) Est. Cost at Completion" := NS_JPLRevRec."Total Cost (LCY)";
                            //PRJCTPR-330.PS.3.0 18April2024 Added
                            //PRJCTPR-330.PS.1.0 11April2024 Start

                            //PE-287.JS.1.0 01MAY2024-Start
                            if ((NS_UpdJFWForecastCompCostOnJT = true) and
                                ("NS_POC Method" = "NS_POC Method"::" ") or ("NS_POC Method" = "NS_POC Method"::"NS_Job forecast")) then begin
                                clear(NS_JFWForcaseCompCostTotal);
                                Clear(NS_ForcaseCompCostTotalFromJPL);
                                NS_JobTaskRec.Reset();
                                NS_JobTaskRec.SetRange("Job No.", "No.");
                                NS_JobTaskRec.SetRange("Job Task Type", "Job Task Type"::Posting);
                                NS_JobTaskRec.SetFilter("NS_JFW Forecast Completed Cost", '>%1', 0);
                                if NS_JobTaskRec.FindSet() then begin
                                    NS_JobTaskRec.CalcSums("NS_JFW Forecast Completed Cost");
                                    NS_JFWForcaseCompCostTotal := NS_JobTaskRec."NS_JFW Forecast Completed Cost";
                                end;
                                NS_JobTaskRec.Reset();
                                NS_JobTaskRec.SetRange("Job No.", "No.");
                                NS_JobTaskRec.SetRange("Job Task Type", "Job Task Type"::Posting);
                                NS_JobTaskRec.SetFilter("NS_JFW Forecast Completed Cost", '=%1', 0);
                                if NS_JobTaskRec.FindSet() then
                                    repeat
                                        NS_JPLRec.Reset();
                                        NS_JPLRec.SetRange("Job No.", NS_JobTaskRec."Job No.");
                                        NS_JPLRec.SetRange("Job Task No.", NS_JobTaskRec."Job Task No.");
                                        NS_JPLRec.SetFilter("Line Type", '<>%1', NS_JPLRec."Line Type"::Billable);
                                        if AsOnDate > 0D then begin
                                            if Jbstp."NS_Enab. Budg.on Contract Date" then
                                                NS_JPLRec.SETFILTER("NS_Contract Forecast Date", '..%1', AsOnDate)  //PRJCTPR-390.JS.1.0 26JUN2024
                                            else
                                                NS_JPLRec.SETFILTER("Planning Date", '..%1', AsOnDate);   //PRJCTPR-390.JS.1.0 26JUN2024
                                        end;
                                        if NS_JPLRec.FindSet() then begin
                                            NS_JPLRec.CalcSums("Total Cost (LCY)");
                                            NS_ForcaseCompCostTotalFromJPL += NS_JPLRec."Total Cost (LCY)";
                                        end;
                                    until NS_JobTaskRec.Next() = 0;                                
                                NSRevRecSumTab."NS_Current(TCE) Est. Cost at Completion" := 0;  //PRJCTPR-390.JS.1.0    
                                NSRevRecSumTab."NS_Current(TCE) Est. Cost at Completion" := NS_JFWForcaseCompCostTotal + NS_ForcaseCompCostTotalFromJPL;
                                NSPercentofComp.NS_TotalForecastCompletedCost := NSRevRecSumTab."NS_Current(TCE) Est. Cost at Completion";
                            end;
                            //PE-287.JS.1.0 01MAY2024-end
                            if NSPercentofComp.NS_TotalForecastCompletedCost <> 0 then
                                NSPercentofComp."NS_Job Percent Complete" := round((NSPercentofComp."NS_Total Cost to Date" / NSPercentofComp.NS_TotalForecastCompletedCost) * 100, Jbstp."NS_Forecast Amount Rounding");  //PE-287.JS.1.0 08MAY2024
                              //PRJCTPR-390.JS.1.0 - Start
                            NSPercentofComp."NS_Revenue Earned" := round((NSPercentofComp."NS_Total Contract Revenue" * NSPercentofComp."NS_Job Percent Complete") / 100, 0.01);
                            NSPercentofComp."NS_Gross Margin" := NSPercentofComp."NS_Revenue Earned" - BalAsonDate;
                            if NSPercentofComp."NS_Revenue Earned" <> 0 then
                                NSPercentofComp."NS_Gross Margin Percent" := Round((NSPercentofComp."NS_Gross Margin" / NSPercentofComp."NS_Revenue Earned") * 100, 0.01);
                            //PRJCTPR-390.JS.1.0 - end
                            //if job."NS_Budgeted Cost (LCY)" <> 0 then  //PE-287.JS.1.0 01MAY2024 line commented
                            // NSRevRecSumTab."NS_POC %" := (BalAsonDate * 100) / job."NS_Budgeted Cost (LCY)";//PE-189.AS.1.0 commented old
                            //NSRevRecSumTab."NS_POC %" := Round((BalAsonDate * 100) / job."NS_Budgeted Cost (LCY)", Jbstp."NS_Forecast Amount Rounding"); //PE-287.JS.1.0 08MAY2024 line commented
                            if NSRevRecSumTab."NS_Current(TCE) Est. Cost at Completion" <> 0 then
                                NSRevRecSumTab."NS_POC %" := Round((NSRevRecSumTab."NS_Actual Costs To Date" / NSRevRecSumTab."NS_Current(TCE) Est. Cost at Completion") * 100, Jbstp."NS_Forecast Amount Rounding"); //PE-287.JS.1.0 08MAY2024 line added

                            //PE-287.JS.1.0 01MAY2024-Start
                            if (NS_JFWForcaseCompCostTotal + NS_ForcaseCompCostTotalFromJPL) <> 0 then begin
                                NSRevRecSumTab."NS_POC %" := 0;
                                NSRevRecSumTab."NS_POC %" := Round((BalAsonDate * 100) / (NS_JFWForcaseCompCostTotal + NS_ForcaseCompCostTotalFromJPL), Jbstp."NS_Forecast Amount Rounding");
                            end;
                            //PE-299.JS.1.0 22MAY2024-Start                            
                            NSPercentofComp."NS_Total Forecasted Variance" := NSPercentofComp."NS_Total Budgeted Costs" -
                                NSPercentofComp.NS_TotalForecastCompletedCost;

                            NSPercentofComp."NS_Forecasted Cost Remaining" := NSPercentofComp.NS_TotalForecastCompletedCost -
                                    NSPercentofComp."NS_Total Cost to Date";
                            NSPercentofComp."NS_Net Cost Variance" := NSPercentofComp."NS_Total Budget Remaining" - NSPercentofComp."NS_Forecasted Cost Remaining";  //PRJCTPR-390.JS.1.0 26JUN2024        
                            //PE-299.JS.1.0 22MAY2024-end    
                            NSPercentofComp.Modify();
                            //PE-287.JS.1.0 01MAY2024-end

                            NSRevRecSumTab."NS_POC Method" := job."NS_POC Method";

                            //PRJCTPR-330.PS.1.0 11April2024 End 
                            //PE-287.JS.1.0 01MAY2024-Start Comment belwo code because of requirement change
                            //PE-270.AS.3.0 START
                            // if (job.NS_EnableOverrideForecastonJFW = FALSE) then begin
                            //     if NSRevRecSumTab."NS_POC Method" = NSRevRecSumTab."NS_POC Method"::"NS_Job forecast" then begin
                            //         Clear(OverrideBudgCost);

                            //         JTaskLines.Reset();
                            //         JTaskLines.SetCurrentKey("Job No.", "Job Task No.");
                            //         JTaskLines.SetRange("Job No.", job."No.");
                            //         JTaskLines.SETRANGE("Job Task Type", JTaskLines."Job Task Type"::Posting);
                            //         if JTaskLines.FindSet() then
                            //             repeat
                            //                 if JTaskLines.NS_ForecastedCompCostOverride <> 0 then
                            //                     OverrideBudgCost += JTaskLines.NS_ForecastedCompCostOverride
                            //                 else begin
                            //                     Clear(JPLTotalCostLCY);
                            //                     JPL.Reset();
                            //                     JPL.SetCurrentKey("Job No.", "Job Task No.");
                            //                     JPL.SetRange("Job No.", JTaskLines."Job No.");
                            //                     JPL.SetRange("Job Task No.", JTaskLines."Job Task No.");
                            //                     JPL.SetRange("Schedule Line", true);
                            //                     JPL.SetFilter("Line Type", '<>%1', JPL."Line Type"::Billable);
                            //                     JPL.Setfilter("Planning Date", '..%1', AsOnDate);
                            //                     if JPL.FindSet() then begin
                            //                         repeat
                            //                             JPLTotalCostLCY += JPL."Total Cost (LCY)";
                            //                         until JPL.Next() = 0;
                            //                         OverrideBudgCost += JPLTotalCostLCY;
                            //                     end;
                            //                 end;
                            //             until JTaskLines.Next() = 0;

                            //         if OverrideBudgCost <> 0 then
                            //             NSRevRecSumTab."NS_POC %" := Round((BalAsonDate * 100) / OverrideBudgCost, Jbstp."NS_Forecast Amount Rounding");
                            //     end;
                            // end;
                            //PE-270.AS.3.0 END
                            //PE-287.JS.1.0 01MAY2024-end

                            NSRevRecSumTab."NS_JobTarget%" := Job."NS_POC Method Value"; //PRJ-1098.NK.0.0 19May2022
                            //PRJ-1463.NK.0.0 17Jun2022 Start
                            if Job."NS_POC Method" = Job."NS_POC Method"::"NS_Markup%" then
                                NSRevRecSumTab."NS_EstMarkup%" := Job."NS_POC Method Value";
                            if Job."NS_POC Method" = Job."NS_POC Method"::"NS_Gross Margin%" then
                                NSRevRecSumTab."NS_EstGrossProfit%" := Job."NS_POC Method Value";
                            //PRJ-1463.NK.0.0 17Jun2022 End
                            NSRevRecSumTab."NS_Entry Type" := NSRevRecSumTab."NS_Entry Type"::Batch;  //PRJ-1413.NK.0.0 23May2022
                            NSRevRecSumTab."NS_Billings to Date" := ABS(NS_CalcBillingAmt(Job."No.")); //PRJ-1098.NK.0.0 18May2022 

                            //PE-162.PS.1.0 14Sep2023 Start Commented ++
                            //  NSRevRecSumTab."NS_Gross Revenue" := NSPercentofComp."NS_Revenue Earned";
                            // NSRevRecSumTab."NS_Gross Profit" := NSPercentofComp."NS_Gross Margin";
                            // NSRevRecSumTab."NS_Current GM %" := NSPercentofComp."NS_Gross Margin Percent";
                            //PE-162.PS.1.0 14Sep2023 End Commented --
                            Flag := true;
                            NSRevRecSumTab.Insert();  //PE-287.JS.1.0 07MAY2024
                        end;
                end;
                NS_CreateVoidedRevRecEntries(NSRevRecSumTab."NS_Posting Date", NSRevRecSumTab."NS_Job No."); //PRJCTPR-330.PS.3.0  18April2024
            end;


        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {

                    field("As on Date"; AsOnDate)
                    {
                        ApplicationArea = All;
                        Caption = 'As of Date';
                        ToolTip = 'As of Date';
                        Style = Strong;
                        StyleExpr = true;
                    }
                    field("JFW Batch Document No."; JFWBatchDocNo)
                    {
                        ApplicationArea = All;
                        Caption = 'JFW Batch Document No.';
                        ToolTip = 'JFW Batch Document No.';
                        Style = Strong;
                        StyleExpr = true;
                        trigger OnValidate()
                        begin
                            JobSetup.Get();
                            if not JFWBatchDocNo then
                                DocNo := ''
                            else
                                DocNo := NoSeriesMgt.GetNextNo(JobSetup."NS_JFW Batch Document No.", WorkDate(), true);


                        end;
                    }
                    field("Document No."; DocNo)
                    {
                        ApplicationArea = all;
                        Caption = 'Document No.';
                        ToolTip = 'Document No.';
                        Editable = not JFWBatchDocNo;
                        Style = Strong;
                        StyleExpr = true;

                    }
                    field("Batch Post Rev. Recognition"; BatchPostRevRecog)
                    {
                        ApplicationArea = All;
                        Visible = false;
                        Caption = 'Batch Post Rev. Recognition';
                        ToolTip = 'Batch Post Rev. Recognition';

                    }
                    field("Select All"; SelectAll)
                    {
                        ApplicationArea = All;
                        Caption = 'Select All';
                        ToolTip = 'Select All';
                        trigger OnValidate()
                        begin
                            if SelectAll then begin
                                BudgettoActualCost := true;
                                JobForecast := true;
                                ManualJob := true;
                                UnitsComplete := true;
                                Markup := true;
                                GrossMargin := true;
                            end else begin
                                BudgettoActualCost := false;
                                JobForecast := false;
                                ManualJob := false;
                                UnitsComplete := false;
                                Markup := false;
                                GrossMargin := false;
                            end;
                        end;
                    }
                    field("Budget to Actual Cost"; BudgettoActualCost)
                    {
                        ApplicationArea = All;
                        Caption = 'Budget to Actual Cost';
                        ToolTip = 'Budget to Actual Cost';
                        //PRJ-1098.NK.0.0 19May2022 Start
                        trigger OnValidate()
                        begin
                            if not BudgettoActualCost then
                                SelectAll := false;
                        end;
                        //PRJ-1098.NK.0.0 19May2022 End
                    }
                    field("Job Forecast"; JobForecast)
                    {
                        ApplicationArea = All;
                        Caption = 'Job Forecast';
                        ToolTip = 'Job Forecast';
                        //PRJ-1098.NK.0.0 19May2022 Start
                        trigger OnValidate()
                        begin
                            if not JobForecast then
                                SelectAll := false;
                        end;
                        //PRJ-1098.NK.0.0 19May2022 End
                    }
                    field("Manual Job %"; ManualJob)
                    {
                        ApplicationArea = All;
                        Caption = 'Manual Job %';
                        ToolTip = 'Manual Job %';
                        //PRJ-1098.NK.0.0 19May2022 Start
                        trigger OnValidate()
                        begin
                            if not ManualJob then
                                SelectAll := false;
                        end;
                        //PRJ-1098.NK.0.0 19May2022 End
                    }
                    field("Units Complete"; UnitsComplete)
                    {
                        ApplicationArea = All;
                        Caption = 'Units Complete';
                        ToolTip = 'Units Complete';
                        //PRJ-1098.NK.0.0 19May2022 Start
                        trigger OnValidate()
                        begin
                            if not UnitsComplete then
                                SelectAll := false;
                        end;
                        //PRJ-1098.NK.0.0 19May2022 End
                    }
                    field("Markup %"; Markup)
                    {
                        ApplicationArea = All;
                        Caption = 'Markup %';
                        ToolTip = 'Markup %';
                        //PRJ-1098.NK.0.0 19May2022 Start
                        trigger OnValidate()
                        begin
                            if not Markup then
                                SelectAll := false;
                        end;
                        //PRJ-1098.NK.0.0 19May2022 End
                    }
                    field("Gross Margin %"; GrossMargin)
                    {
                        ApplicationArea = All;
                        Caption = 'Gross Margin %';
                        ToolTip = 'Gross Margin %';
                        //PRJ-1098.NK.0.0 19May2022 Start
                        trigger OnValidate()
                        begin
                            if not GrossMargin then
                                SelectAll := false;
                        end;
                        //PRJ-1098.NK.0.0 19May2022 End
                    }
                    // PRJCTPR-330.PS.2.0 17April2024 Start
                    field(JobNo; NS_JobNo)
                    {

                        ApplicationArea = All;
                        Caption = 'Job No.';
                        ToolTip = 'Job No.';
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            myInt: Integer;
                            NS_LookupValidation: Record Job;
                        begin
                            Clear(NS_JobNo);
                            NS_Job.Reset();
                            NS_Job.SetRange(Status, NS_Job.Status::Open);
                            NS_Job.SetRange("NS_Revenue Recognized", false);
                            if PAGE.RunModal(0, NS_Job) = ACTION::LookupOK then begin
                                NS_JobNo := NS_Job."No.";
                                Job."No." := NS_Job."No.";
                                if NS_LookupValidation.Get(NS_JobNo) then begin
                                    if (NS_LookupValidation.Status <> NS_LookupValidation.Status::Open) Or (NS_LookupValidation."NS_Revenue Recognized" <> false) then
                                        Error('Please select a job with Status=Open and Revenue Recognized=False.');
                                end;
                            end;
                        end;

                        trigger OnValidate()
                        var
                            NSLocalJob: Record Job;
                        begin

                            if NSLocalJob.Get(NS_JobNo) then begin
                                if (NSLocalJob.Status <> NS_Job.Status::Open) Or (NSLocalJob."NS_Revenue Recognized" <> false) then
                                    Error('Please select a job with Status=Open and Revenue Recognized=False.');
                            end;




                        end;
                    }
                    // PRJCTPR-330.PS.2.0 17April2024 End 
                }
            }
        }
    }
    trigger OnPostReport()
    begin
        if JobsSetup.Get() then;
        if Flag then
            //if JobSetup.NS_AutoRunRevRecPOCBatch then //PE-162.PS.1.0 14Sep2023 Commented
            if NSAutoRunRevRecPOCBatch then //PE-162.PS.1.0 14Sep2023
                //PE-287.JS.1.0 13MAY2024-Start
                //NS_CalcRevRecognition();
                if NS_JobNo <> '' then
                    NS_CalcRevRecognitionWithJobFilter(NS_JobNo)
                else
                    NS_CalcRevRecognition()

        //PE-287.JS.1.0 13MAY2024-end
    end;

    trigger OnInitReport();
    begin
        AsOnDate := WORKDATE();
    end;
    //PRJCTPR-330.PS.3.0 19April2024 Start
    trigger OnPreReport()
    var
        NS_JobFilter: Record Job;
        NSJobNo: Integer;
        NSJobNo1: Code[20];
    begin
        NSJobNo1 := Job.GetFilter("No.");
        If NS_JobFilter.Get(NSJobNo1) then;
        if (NS_JobFilter.Status <> Job.Status::Open) or (NS_JobFilter."NS_Revenue Recognized" <> false) then
            Error('Please select a job with Status=Open and Revenue Recognized=False.');
    end;
    //PRJCTPR-330.PS.3.0 19April2024 End 

    var
        NSBPJFCWT: Record NS_BatchPostJobForcastWrkTemp;
        NSBPJFCWT2: Record NS_BatchPostJobForcastWrkTemp;
        NSPercentofComp: Record "NS_Percentage of Completion";
        NS_JobTaskRec: Record "Job Task";  //PE-287.JS.1.0 01MAY2024
        NS_JPLRec: Record "Job Planning Line";  //PE-287.JS.1.0 01MAY2024
        NS_JFWForcaseCompCostTotal: Decimal;  //PE-287.JS.1.0 01MAY2024
        NS_ForcaseCompCostTotalFromJPL: Decimal;  //PE-287.JS.1.0 01MAY2024
        AsOnDate: Date;
        DocNo: Code[20];
        BatchPostRevRecog: Boolean;
        SelectAll: Boolean;
        BudgettoActualCost: Boolean;
        JobForecast: Boolean;
        ManualJob: Boolean;
        UnitsComplete: Boolean;
        Markup: Boolean;
        Flag: Boolean;
        JobsSetup: Record "Jobs Setup";
        GrossMargin: Boolean;
        RecJob: Record Job;
        BalAsonDate: Decimal;
        JFWBatchDocNo: Boolean;
        JobSetup: Record "Jobs Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NSRevRecSumTab: Record NS_RevenueRecSummaryTab;
        ForecastedCostRemaining: Decimal;
        TotalBudgetRemaining: Decimal;
        RevenueEarned: Decimal;
        NSAutoRunRevRecPOCBatch: Boolean;//PE-162.PS.1.0 14Sep2023

        JTaskLines: Record "Job Task";//PE-270.AS.3.0
        OverrideBudgCost: Decimal;//PE-270.AS.3.0
        JPL: Record "Job Planning Line";//PE-270.AS.3.0q1`
        JPLTotalCostLCY: Decimal;//PE-270.AS.3.0
        NS_JobNo: Code[20]; // PRJCTPR-330.PS.2.0 17April2024
        NS_Job: Record Job; // PRJCTPR-330.PS.2.0 17April2024
    local procedure NS_GetJobPlaningLine(JobNo: Code[20]): Boolean;
    var
        JobPlaningLine: record "Job Planning Line";
    begin
        JobPlaningLine.Reset();
        JobPlaningLine.SetRange("Job No.", JobNo);
        JobPlaningLine.SetFilter("Planning Date", '..%1', AsOnDate);   //PRJCTPR-390.JS.1.0 26JUN2024
        if JobPlaningLine.FindFirst() then
            exit(true)
        else
            exit(false)
    end;


    local procedure NS_BudgettoActualCost(): Boolean;
    begin
        if BudgettoActualCost then begin
            RecJob.Reset();
            RecJob.SetRange("No.", Job."No.");
            RecJob.SetRange("NS_POC Method", RecJob."NS_POC Method"::NS_BudgettoActualCost);
            if RecJob.FindFirst() then
                exit(true)
            else
                exit(false);
        end;
    end;

    local procedure NS_JobForecast(): Boolean;
    begin
        if JobForecast then begin
            RecJob.Reset();
            RecJob.SetRange("No.", Job."No.");
            RecJob.SetRange("NS_POC Method", RecJob."NS_POC Method"::"NS_Job forecast");
            if RecJob.FindFirst() then
                exit(true)
            else
                exit(false);
        end;
    end;

    local procedure NS_ManualJob(): Boolean;
    begin
        if ManualJob then begin
            RecJob.Reset();
            RecJob.SetRange("No.", Job."No.");
            RecJob.SetRange("NS_POC Method", RecJob."NS_POC Method"::"NS_Manual Job%");
            if RecJob.FindFirst() then
                exit(true)
            else
                exit(false);
        end;
    end;

    local procedure NS_UnitsComplete(): Boolean;
    begin
        if UnitsComplete then begin
            RecJob.Reset();
            RecJob.SetRange("No.", Job."No.");
            RecJob.SetRange("NS_POC Method", RecJob."NS_POC Method"::"NS_Units Complete");
            if RecJob.FindFirst() then
                exit(true)
            else
                exit(false);
        end;
    end;

    local procedure NS_Markup(): Boolean;
    begin
        if Markup then begin
            RecJob.Reset();
            RecJob.SetRange("No.", Job."No.");
            RecJob.SetRange("NS_POC Method", RecJob."NS_POC Method"::"NS_Markup%");
            if RecJob.FindFirst() then
                exit(true)
            else
                exit(false);
        end;
    end;

    local procedure NS_GrossMargin(): Boolean;
    begin
        if GrossMargin then begin
            RecJob.Reset();
            RecJob.SetRange("No.", Job."No.");
            RecJob.SetRange("NS_POC Method", RecJob."NS_POC Method"::"NS_Gross Margin%");
            if RecJob.FindFirst() then
                exit(true)
            else
                exit(false);
        end;
    end;

    local procedure NS_FindLastEntryNo(): Integer;
    var
        NSPerofComp: Record "NS_Percentage of Completion";
    begin
        NSPerofComp.Reset();
        if NSPerofComp.FindLast() then
            exit(NSPerofComp."NS_Entry No" + 1)
        else
            exit(1);
    end;

    local procedure NS_RevRecSumTabEntryNo(): Integer;
    var
        NSRevRecSumTab: Record NS_RevenueRecSummaryTab;
    begin
        NSRevRecSumTab.Reset();
        if NSRevRecSumTab.FindLast() then
            exit(NSRevRecSumTab."NS_Entry No." + 1)
        else
            exit(1);
    end;

    local procedure NS_CaclTotalCost(NSJobNo: Code[20]): Decimal;
    var
        JobLedgerEntry: Record "Job Ledger Entry";
        TotCost: Decimal;
    begin
        TotCost := 0;
        JobLedgerEntry.Reset();
        JobLedgerEntry.SetRange("Job No.", NSJobNo);
        JobLedgerEntry.SetRange("Entry Type", JobLedgerEntry."Entry Type"::Usage);
        JobLedgerEntry.SetFilter("Posting Date", '%1..%2', 0D, AsOnDate);
        if JobLedgerEntry.FindSet() then begin
            JobLedgerEntry.CalcSums("Total Cost (LCY)");
            TotCost += JobLedgerEntry."Total Cost (LCY)";
        end;
        exit(TotCost);

    end;

    local procedure NS_CalcRevRecognition();
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
        PreviousPOCPercent: Decimal;
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
        RevRecSummary.SetCurrentKey("NS_Job No.", "NS_Posting Date");
        RevRecSummary.SetRange(NS_Voided, false);  //PRJ-1355.JS.1.0 18MAY2022
        RevRecSummary.SetFilter("NS_POC Method", '<>%1', RevRecSummary."NS_POC Method"::" ");   //PRJ-1355.JS.1.0 18MAY2022                    
        TotalCount := RevRecSummary.Count;
        if RevRecSummary.FindSet() then
            repeat
                if RevRecSummary."NS_Job No." <> PreviousJobNo then begin
                    GrossRevBefore := 0;
                    ActualCostPrevious := 0;
                end;
                Sleep(250);
                CurrRec += 1;

                if TotalCount <> 0 then begin  //PE-287.JS.1.0 13MAY2024 line added
                    IF TotalCount <= 100 THEN
                        Window.UPDATE(1, (CurrRec / TotalCount * 10000) DIV 1)
                    ELSE
                        IF CurrRec MOD (TotalCount DIV 100) = 0 THEN
                            Window.UPDATE(1, (CurrRec / TotalCount * 10000) DIV 1);
                end;  //PE-287.JS.1.0 13MAY2024 line added

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
                                    if JobRec."NS_Total Units" <> 0 then  //PE-287.JS.1.0 13MAY2024
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
                                    ProjSummDetails.SetRange("NS_Job No.", RevRecSummary."NS_Job No.");
                                    ProjSummDetails.SetRange("NS_Posting Date", RevRecSummary."NS_Posting Date");
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
                        //PRJCTPR-232.PS.1.0 07Dec2023 Start 
                        NS_POCMethod::"NS_Job forecast":
                            begin
                                If ((RevRecSummary.NS_Posted = false) and (RevRecSummary."NS_Over/Under Billings Posted" = false)
                                    and (RevRecSummary.NS_Voided = false)) then begin

                                    if RevRecSummary.NS_JFWBatchDocumentNo = '' then begin//PE-270.AS.3.0 Added Condition if..beginend START
                                        ProjSummDetails.Reset();
                                        ProjSummDetails.SetRange("NS_Job No.", RevRecSummary."NS_Job No.");
                                        ProjSummDetails.SetRange("NS_Posting Date", RevRecSummary."NS_Posting Date");
                                        IF ProjSummDetails.FindLast() then
                                            BudgetedCostValue := ProjSummDetails."NS_Total Budgeted Costs";
                                        IF BudgetedCostValue <> 0 then
                                            RevRecSummary."NS_POC %" := (RevRecSummary."NS_Actual Costs To Date" / BudgetedCostValue) * 100;
                                    end;//PE-270.AS.3.0 Added Condition END
                                    RevRecSummary."NS_Gross Revenue" := (RevRecSummary."NS_Current Contract" * RevRecSummary."NS_POC %") / 100; //SK
                                    RevRecSummary."NS_Gross Profit" := RevRecSummary."NS_Gross Revenue" - RevRecSummary."NS_Actual Costs To Date";
                                    if RevRecSummary."NS_Gross Revenue" <> 0 then
                                        RevRecSummary."NS_Current GM %" := (RevRecSummary."NS_Gross Profit" / RevRecSummary."NS_Gross Revenue") * 100;
                                end;
                            end;
                    //PRJCTPR-232.PS.1.0 07Dec2023 End 
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
    end;
    //PRJ-1098.NK.0.0 18May2022 Start
    local procedure NS_CalcBillingAmt(NSJobNo: code[20]): Decimal;
    var
        JobLedgerEntry: Record "Job Ledger Entry";
        TotalBilbleAmt: Decimal;
    begin
        TotalBilbleAmt := 0;
        JobLedgerEntry.Reset();
        JobLedgerEntry.SetRange("Job No.", NSJobNo);
        JobLedgerEntry.SetRange("Entry Type", JobLedgerEntry."Entry Type"::Sale);
        JobLedgerEntry.SetFilter("Posting Date", '%1..%2', 0D, AsOnDate);
        if JobLedgerEntry.FindSet() then begin
            JobLedgerEntry.CalcSums("Line Amount (LCY)");
            TotalBilbleAmt += JobLedgerEntry."Line Amount (LCY)";
        end;
        exit(TotalBilbleAmt);
    end;
    //PRJ-1098.NK.0.0 18May2022 End

    //PRJCTPR-330.PS.3.0  18April2024 Start

    procedure NS_CreateVoidedRevRecEntries(Var NSPostingDate: Date; NS_JobNo: Code[20])
    var
        RevenueRecSummaryTab: Record NS_RevenueRecSummaryTab;
        RevenueRecSummaryVoid: Record NS_RevenueRecSummaryTab;
        RevenueRecSummaryVoid1: Record NS_RevenueRecSummaryTab;
        RevenueRecSummaryTab_N: Record NS_RevenueRecSummaryTab;//PRJ-658
        GrosRevVar: Decimal;
        GrossProfitVar: Decimal;
        RevenueRecSummaryTab2: Record NS_RevenueRecSummaryTab;
        jobtbl: Record Job;//PE-160.AS.1.0 
        RecCount: Integer;
    begin
        RevenueRecSummaryVoid.Reset();
        RevenueRecSummaryVoid.SetCurrentKey("NS_Entry No.");
        RevenueRecSummaryVoid.SetRange("NS_Job No.", NS_JobNo);
        RevenueRecSummaryVoid.setfilter(NS_Posted, '%1', false);
        //RevenueRecSummaryVoid.SetFilter("True-Up Posted", '%1', false);//CTSI-286 rollback
        RevenueRecSummaryVoid.SetFilter(NS_Voided, '%1', false);
        RevenueRecSummaryVoid.Setrange("NS_Posting Date", NSRevRecSumTab."NS_Posting Date");
        RevenueRecSummaryVoid.SetFilter("NS_Entry Type", '%1|%2|%3', RevenueRecSummaryVoid."NS_Entry Type"::JFW, RevenueRecSummaryVoid."NS_Entry Type"::Finance, RevenueRecSummaryVoid."NS_Entry Type"::Batch); //PE-271.PS.1.0 19March2024 Added on Extra filter 
        if RevenueRecSummaryVoid.FindSet() then
            repeat
                // RevenueRecSummaryVoid1.SetRange("NS_Job No.", NS);
                // if RevenueRecSummaryVoid1.FindSet() then begin
                RecCount := RevenueRecSummaryVoid.Count;
                if RecCount > 1 then begin
                    RevenueRecSummaryVoid.NS_Voided := true;
                    RevenueRecSummaryVoid.Modify();
                end;
            //   end;
            until RevenueRecSummaryVoid.next = 0;
    end;

    //PRJCTPR-330.PS.3.0  18April2024 End

    //PE-287.JS.1.0 13MAY2024-Start
    local procedure NS_CalcRevRecognitionWithJobFilter(var NSPassJobNo: code[20]);
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
        PreviousPOCPercent: Decimal;
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
        RevRecSummary.SetCurrentKey("NS_Job No.", "NS_Posting Date");
        RevRecSummary.Setrange("NS_Job No.", NSPassJobNo);
        RevRecSummary.SetRange(NS_Voided, false);
        RevRecSummary.SetFilter("NS_POC Method", '<>%1', RevRecSummary."NS_POC Method"::" ");
        TotalCount := RevRecSummary.Count;
        if RevRecSummary.FindSet() then
            repeat
                if RevRecSummary."NS_Job No." <> PreviousJobNo then begin
                    GrossRevBefore := 0;
                    ActualCostPrevious := 0;
                end;
                Sleep(250);
                CurrRec += 1;
                if TotalCount <> 0 then begin
                    IF TotalCount <= 100 THEN
                        Window.UPDATE(1, (CurrRec / TotalCount * 10000) DIV 1)
                    ELSE
                        IF CurrRec MOD (TotalCount DIV 100) = 0 THEN
                            Window.UPDATE(1, (CurrRec / TotalCount * 10000) DIV 1);
                end;
                Window.Update(2, RevRecSummary."NS_Job No.");
                If JobRec.get(RevRecSummary."NS_Job No.") then
                    case JobRec."NS_POC Method" of
                        NS_POCMethod::"NS_Gross Margin%":
                            begin
                                If ((RevRecSummary.NS_Posted = false) and (RevRecSummary."NS_Over/Under Billings Posted" = false)
                                and (RevRecSummary.NS_Voided = false)) then begin
                                    RevRecSummary."NS_Gross Revenue" := (RevRecSummary."NS_Actual Costs To Date" / ((1 - JobRec."NS_POC Method Value" / 100)));
                                    RevRecSummary."NS_Current GM %" := JobRec."NS_POC Method Value";
                                    RevRecSummary."NS_Gross Profit" := (RevRecSummary."NS_Gross Revenue" * RevRecSummary."NS_Current GM %") / 100;
                                end;
                            end;
                        NS_POCMethod::"NS_Manual Job%":
                            begin
                                If ((RevRecSummary.NS_Posted = false) and (RevRecSummary."NS_Over/Under Billings Posted" = false)
                                and (RevRecSummary.NS_Voided = false)) then begin
                                    RevRecSummary."NS_POC %" := JobRec."NS_Actual Percent Complete";
                                    RevRecSummary."NS_Gross Revenue" := (RevRecSummary."NS_Current Contract" * JobRec."NS_Actual Percent Complete") / 100;
                                    RevRecSummary."NS_Gross Profit" := RevRecSummary."NS_Gross Revenue" - RevRecSummary."NS_Actual Costs To Date";
                                    if RevRecSummary."NS_Gross Revenue" <> 0 then
                                        RevRecSummary."NS_Current GM %" := (RevRecSummary."NS_Gross Profit" / RevRecSummary."NS_Gross Revenue") * 100;
                                end;
                            end;
                        NS_POCMethod::"NS_Markup%":
                            begin
                                If ((RevRecSummary.NS_Posted = false) and (RevRecSummary."NS_Over/Under Billings Posted" = false)
                                and (RevRecSummary.NS_Voided = false)) then begin
                                    RevRecSummary."NS_Gross Revenue" := (RevRecSummary."NS_Actual Costs To Date" * JobRec."NS_POC Method Value") / 100 + RevRecSummary."NS_Actual Costs To Date";
                                    RevRecSummary."NS_Gross Profit" := RevRecSummary."NS_Gross Revenue" - RevRecSummary."NS_Actual Costs To Date";
                                    if RevRecSummary."NS_Gross Revenue" <> 0 then
                                        RevRecSummary."NS_Current GM %" := (RevRecSummary."NS_Gross Profit" / RevRecSummary."NS_Gross Revenue") * 100;
                                end;
                            end;
                        NS_POCMethod::"NS_Units Complete":
                            begin
                                If ((RevRecSummary.NS_Posted = false) and (RevRecSummary."NS_Over/Under Billings Posted" = false)
                                and (RevRecSummary.NS_Voided = false)) then begin
                                    if JobRec."NS_Total Units" <> 0 then
                                        RevRecSummary."NS_POC %" := (JobRec."NS_Actual Units Complete" / JobRec."NS_Total Units") * 100;
                                    RevRecSummary."NS_Gross Revenue" := (RevRecSummary."NS_POC %" * RevRecSummary."NS_Current Contract") / 100;
                                    RevRecSummary."NS_Gross Profit" := RevRecSummary."NS_Gross Revenue" - RevRecSummary."NS_Actual Costs To Date";
                                    if RevRecSummary."NS_Gross Revenue" <> 0 then
                                        RevRecSummary."NS_Current GM %" := (RevRecSummary."NS_Gross Profit" / RevRecSummary."NS_Gross Revenue") * 100;
                                end;
                                PreviousPOCPercent := 0;
                                PreviousPOCPercent := RevRecSummary."NS_POC %";
                            end;
                        NS_POCMethod::NS_BudgettoActualCost:
                            begin
                                If ((RevRecSummary.NS_Posted = false) and (RevRecSummary."NS_Over/Under Billings Posted" = false)
                                and (RevRecSummary.NS_Voided = false)) then begin
                                    ProjSummDetails.Reset();
                                    ProjSummDetails.SetRange("NS_Job No.", RevRecSummary."NS_Job No.");
                                    ProjSummDetails.SetRange("NS_Posting Date", RevRecSummary."NS_Posting Date");
                                    IF ProjSummDetails.FindLast() then
                                        BudgetedCostValue := ProjSummDetails."NS_Total Budgeted Costs";
                                    IF BudgetedCostValue <> 0 then
                                        RevRecSummary."NS_POC %" := (RevRecSummary."NS_Actual Costs To Date" / BudgetedCostValue) * 100;
                                    RevRecSummary."NS_Gross Revenue" := (RevRecSummary."NS_Current Contract" * RevRecSummary."NS_POC %") / 100;
                                    RevRecSummary."NS_Gross Profit" := RevRecSummary."NS_Gross Revenue" - RevRecSummary."NS_Actual Costs To Date";
                                    if RevRecSummary."NS_Gross Revenue" <> 0 then
                                        RevRecSummary."NS_Current GM %" := (RevRecSummary."NS_Gross Profit" / RevRecSummary."NS_Gross Revenue") * 100;
                                end;
                            end;
                        NS_POCMethod::"NS_Job forecast":
                            begin
                                If ((RevRecSummary.NS_Posted = false) and (RevRecSummary."NS_Over/Under Billings Posted" = false)
                                    and (RevRecSummary.NS_Voided = false)) then begin

                                    if RevRecSummary.NS_JFWBatchDocumentNo = '' then begin
                                        ProjSummDetails.Reset();
                                        ProjSummDetails.SetRange("NS_Job No.", RevRecSummary."NS_Job No.");
                                        ProjSummDetails.SetRange("NS_Posting Date", RevRecSummary."NS_Posting Date");
                                        IF ProjSummDetails.FindLast() then
                                            BudgetedCostValue := ProjSummDetails."NS_Total Budgeted Costs";
                                        IF BudgetedCostValue <> 0 then
                                            RevRecSummary."NS_POC %" := (RevRecSummary."NS_Actual Costs To Date" / BudgetedCostValue) * 100;
                                    end;
                                    RevRecSummary."NS_Gross Revenue" := (RevRecSummary."NS_Current Contract" * RevRecSummary."NS_POC %") / 100;
                                    RevRecSummary."NS_Gross Profit" := RevRecSummary."NS_Gross Revenue" - RevRecSummary."NS_Actual Costs To Date";
                                    if RevRecSummary."NS_Gross Revenue" <> 0 then
                                        RevRecSummary."NS_Current GM %" := (RevRecSummary."NS_Gross Profit" / RevRecSummary."NS_Gross Revenue") * 100;
                                end;
                            end;
                    end;
                if RevRecSummary."NS_Billings to Date" > RevRecSummary."NS_Gross Revenue" then begin
                    RevRecSummary."NS_Over Billings" := RevRecSummary."NS_Billings to Date" - RevRecSummary."NS_Gross Revenue";
                    RevRecSummary."NS_Under Billings" := 0;
                end;
                if RevRecSummary."NS_Billings to Date" < RevRecSummary."NS_Gross Revenue" then begin
                    RevRecSummary."NS_Under Billings" := RevRecSummary."NS_Gross Revenue" - RevRecSummary."NS_Billings to Date";
                    RevRecSummary."NS_Over Billings" := 0;
                end;
                if RevRecSummary."NS_Billings to Date" = RevRecSummary."NS_Gross Revenue" then begin
                    RevRecSummary."NS_Under Billings" := 0;
                    RevRecSummary."NS_Over Billings" := 0;
                end;
                RevRecSummary."NS_Net Revenue" := RevRecSummary."NS_Gross Revenue" - GrossRevBefore;
                RevRecSummary."NS_Period Costs" := RevRecSummary."NS_Actual Costs To Date" - ActualCostPrevious;
                RevRecSummary."NS_Net Profit" := RevRecSummary."NS_Net Revenue" - RevRecSummary."NS_Period Costs";
                GrossRevBefore := RevRecSummary."NS_Gross Revenue";
                ActualCostPrevious := RevRecSummary."NS_Actual Costs To Date";
                PreviousJobNo := RevRecSummary."NS_Job No.";
                RevRecSummary."NS_Entry Type" := RevRecSummary."NS_Entry Type"::Finance;
                If ((RevRecSummary.NS_Posted = false) and (RevRecSummary."NS_Over/Under Billings Posted" = false)
                and (RevRecSummary.NS_Voided = false)) then
                    RevRecSummary.Modify();
            until RevRecSummary.Next() = 0;
        Window.Close();
    end;
    //PE-287.JS.1.0 13MAY2024-end

}