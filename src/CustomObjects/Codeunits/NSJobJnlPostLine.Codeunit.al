codeunit 14021119 "NS_Job Jnl.-Post Line"
{
    // version NAVW113.00,PPNA11.00,SPLN

    // SPLN1.00 2019-01-28 Created
    //   Functions copied from codeunit 1012
    //PRJ-93.SK.1.0 Added code 
    //PRJ-246.MS.1.0 added code	 
    //PRJ-233.TY.1.0 - 19APRIL2020 -Commented Code
    //PRJ-357.MS.1.0 new code added when we post PO then error comes of 0 no. line does not exist
    //TM-10.AM.1.0 added code for segment
    //PRJ-458.MS.1.0 added code for use tax and burden amt.
    //PRJ-772.JS.1.0 28July2021 | Write code fatch crew time sheet values in job journal line & 
    //PRJ-772.JS.1.0 28July2021 | to update Crew time sheet lines during job journal posting
    //PRJ-841.JS.1.0 16Aug2021 | Code Added
    //PRJ-842.JS.1.0 16Aug2021 | Code Added
    //PRJ-866.JS.1.0 18Aug2021 | code change as per the requirement for apply usage links
    //PRJ-1015.JS.1.0 10Oct2021 | Add code to flow Sub Leve to Job Number
    //PRJ-1295.NK.1.0 12Apr2022 | Add Code
    //PRJ-1436.JS.1.0 07JUN2022 | Add condition
    //PRJ-1436.VC.1.0 08JUL2022 | Corrected the condition written by JS.
    //PE-247.HS.1.0 6Feb2024 | Added code

    Permissions = TableData "Job Ledger Entry" = imd,
                  TableData "Job Register" = imd,
                  TableData "Value Entry" = rimd;
    TableNo = "Job Journal Line";
    SingleInstance = true;






    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Jnl.-Post Line", 'OnBeforeCreateJobRegister', '', false, false)]
    local procedure NS_EnsureLCYandNONLCYValuesAreComplete(var JobJournalLine: Record "Job Journal Line")
    var
        NS_JobsSetup: Record "Jobs Setup";
        Text14021100: Label 'There must be a cost category for job %1 on line %2';
        Text14021101: Label 'There must be a revenue category for job %1 on line %2';
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        //ProjectPro - start
        NS_JobsSetup.GET;
        //ProjectPro - end

        //CTSI-254
        if (NS_JobsSetup."NS_Burden G/L Journal Batch" = JobJournalLine."Journal Batch Name") then begin
            if NS_JobsSetup."NS_Default Job Task No." <> '' then begin
                if NS_JobsSetup."NS_Default Job Task No." <> JobJournalLine."Job Task No." then
                    Error('Job Task No. seleted does not match with define Job Task No. in Job Setup for Job No. %1', JobJournalLine."Job No.");//CTSI-254
            end;
        end;
        //CTSI-254

        //ProjectPro - start
        //Check for required category entries
        IF NS_JobsSetup."NS_Cost Category Required" THEN BEGIN
            IF JobJournalLine."Entry Type" IN [JobJournalLine."Entry Type"::Usage, JobJournalLine."Entry Type"::NS_Release] THEN
                IF (JobJournalLine."Job No." > '') AND (JobJournalLine."NS_Job Cost Category" = '') AND (JobJournalLine.Type <> JobJournalLine.Type::NS_Ledger) THEN
                    ERROR(Text14021100, JobJournalLine."Job No.", JobJournalLine."Line No.");
        END;

        IF NS_JobsSetup."NS_Revenue Category Required" THEN BEGIN
            IF JobJournalLine."Entry Type" IN [JobJournalLine."Entry Type"::Sale, JobJournalLine."Entry Type"::NS_Earn] THEN
                IF (JobJournalLine."Job No." > '') AND (JobJournalLine."NS_Job Revenue Category" = '') AND (JobJournalLine.Type <> JobJournalLine.Type::NS_Ledger) THEN
                    ERROR(Text14021101, JobJournalLine."Job No.", JobJournalLine."Line No.");
        END;
        //Ensure that LCY and non-LCY values are all complete
        IF JobJournalLine."Currency Code" <> '' THEN
            Currency.GET(JobJournalLine."Currency Code");
        IF (JobJournalLine."Unit Cost (LCY)" <> 0) AND (JobJournalLine."Unit Cost" = 0) THEN
            IF JobJournalLine."Currency Code" <> '' THEN
                JobJournalLine."Unit Cost" := ROUND(CurrExchRate.ExchangeAmtLCYToFCY(JobJournalLine."Posting Date",
                                     JobJournalLine."Currency Code", JobJournalLine."Unit Cost (LCY)",
                                     CurrExchRate.ExchangeRate(JobJournalLine."Posting Date", JobJournalLine."Currency Code")),
                                     Currency."Amount Rounding Precision")
            ELSE
                JobJournalLine."Unit Cost" := JobJournalLine."Unit Cost (LCY)";
        IF (JobJournalLine."Total Cost (LCY)" <> 0) AND (JobJournalLine."Total Cost" = 0) THEN
            IF JobJournalLine."Currency Code" <> '' THEN
                JobJournalLine."Total Cost" := ROUND(CurrExchRate.ExchangeAmtLCYToFCY(JobJournalLine."Posting Date",
                                      JobJournalLine."Currency Code", JobJournalLine."Total Cost (LCY)",
                                      CurrExchRate.ExchangeRate(JobJournalLine."Posting Date", JobJournalLine."Currency Code")),
                                      Currency."Amount Rounding Precision")
            ELSE
                JobJournalLine."Total Cost" := JobJournalLine."Total Cost (LCY)";

        IF (JobJournalLine."Unit Price (LCY)" <> 0) AND (JobJournalLine."Unit Price" = 0) THEN
            IF JobJournalLine."Currency Code" <> '' THEN
                JobJournalLine."Unit Price" := ROUND(CurrExchRate.ExchangeAmtLCYToFCY(JobJournalLine."Posting Date",
                                      JobJournalLine."Currency Code", JobJournalLine."Unit Price (LCY)",
                                      CurrExchRate.ExchangeRate(JobJournalLine."Posting Date", JobJournalLine."Currency Code")),
                                      Currency."Amount Rounding Precision")
            ELSE
                JobJournalLine."Unit Price" := JobJournalLine."Unit Price (LCY)";

        IF (JobJournalLine."Total Price (LCY)" <> 0) AND (JobJournalLine."Total Price" = 0) THEN
            IF JobJournalLine."Currency Code" <> '' THEN
                JobJournalLine."Total Price" := ROUND(CurrExchRate.ExchangeAmtLCYToFCY(JobJournalLine."Posting Date",
                                       JobJournalLine."Currency Code", JobJournalLine."Total Price (LCY)",
                                       CurrExchRate.ExchangeRate(JobJournalLine."Posting Date", JobJournalLine."Currency Code")),
                                       Currency."Amount Rounding Precision")
            ELSE
                JobJournalLine."Total Price" := JobJournalLine."Total Price (LCY)";

        IF (JobJournalLine."Line Amount (LCY)" <> 0) AND (JobJournalLine."Line Amount" = 0) THEN
            IF JobJournalLine."Currency Code" <> '' THEN
                JobJournalLine."Line Amount" := ROUND(CurrExchRate.ExchangeAmtLCYToFCY(JobJournalLine."Posting Date",
                                       JobJournalLine."Currency Code", JobJournalLine."Line Amount (LCY)",
                                       CurrExchRate.ExchangeRate(JobJournalLine."Posting Date", JobJournalLine."Currency Code")),
                                       Currency."Amount Rounding Precision")
            ELSE
                JobJournalLine."Line Amount" := JobJournalLine."Line Amount (LCY)";

        IF (JobJournalLine."Line Discount Amount (LCY)" <> 0) AND (JobJournalLine."Line Discount Amount" = 0) THEN
            IF JobJournalLine."Currency Code" <> '' THEN
                JobJournalLine."Line Discount Amount" := ROUND(CurrExchRate.ExchangeAmtLCYToFCY(JobJournalLine."Posting Date",
                                                JobJournalLine."Currency Code", JobJournalLine."Line Discount Amount (LCY)",
                                                CurrExchRate.ExchangeRate(JobJournalLine."Posting Date", JobJournalLine."Currency Code")),
                                                Currency."Amount Rounding Precision")
            ELSE
                JobJournalLine."Line Discount Amount" := JobJournalLine."Line Discount Amount (LCY)";

        //Crosscheck back
        IF (JobJournalLine."Unit Cost" <> 0) AND (JobJournalLine."Unit Cost (LCY)" = 0) THEN
            IF JobJournalLine."Currency Code" <> '' THEN
                JobJournalLine."Unit Cost (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(JobJournalLine."Posting Date",
                                           JobJournalLine."Currency Code", JobJournalLine."Unit Cost",
                                           CurrExchRate.ExchangeRate(JobJournalLine."Posting Date", JobJournalLine."Currency Code")),
                                           Currency."Amount Rounding Precision")
            ELSE
                JobJournalLine."Unit Cost (LCY)" := JobJournalLine."Unit Cost";

        IF (JobJournalLine."Total Cost" <> 0) AND (JobJournalLine."Total Cost (LCY)" = 0) THEN
            IF JobJournalLine."Currency Code" <> '' THEN
                JobJournalLine."Total Cost (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(JobJournalLine."Posting Date",
                                            JobJournalLine."Currency Code", JobJournalLine."Total Cost",
                                            CurrExchRate.ExchangeRate(JobJournalLine."Posting Date", JobJournalLine."Currency Code")),
                                            Currency."Amount Rounding Precision")
            ELSE
                JobJournalLine."Total Cost (LCY)" := JobJournalLine."Total Cost";

        IF (JobJournalLine."Unit Price" <> 0) AND (JobJournalLine."Unit Price (LCY)" = 0) THEN
            IF JobJournalLine."Currency Code" <> '' THEN
                JobJournalLine."Unit Price (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(JobJournalLine."Posting Date",
                                            JobJournalLine."Currency Code", JobJournalLine."Unit Price",
                                            CurrExchRate.ExchangeRate(JobJournalLine."Posting Date", JobJournalLine."Currency Code")),
                                            Currency."Amount Rounding Precision")
            ELSE
                JobJournalLine."Unit Price (LCY)" := JobJournalLine."Unit Price";

        IF (JobJournalLine."Total Price" <> 0) AND (JobJournalLine."Total Price (LCY)" = 0) THEN
            IF JobJournalLine."Currency Code" <> '' THEN
                JobJournalLine."Total Price (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(JobJournalLine."Posting Date",
                                             JobJournalLine."Currency Code", JobJournalLine."Total Price",
                                             CurrExchRate.ExchangeRate(JobJournalLine."Posting Date", JobJournalLine."Currency Code")),
                                             Currency."Amount Rounding Precision")
            ELSE
                JobJournalLine."Total Price (LCY)" := JobJournalLine."Total Price";

        IF (JobJournalLine."Line Amount" <> 0) AND (JobJournalLine."Line Amount (LCY)" = 0) THEN
            IF JobJournalLine."Currency Code" <> '' THEN
                JobJournalLine."Line Amount (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(JobJournalLine."Posting Date",
                                             JobJournalLine."Currency Code", JobJournalLine."Line Amount",
                                             CurrExchRate.ExchangeRate(JobJournalLine."Posting Date", JobJournalLine."Currency Code")),
                                             Currency."Amount Rounding Precision")
            ELSE
                JobJournalLine."Line Amount (LCY)" := JobJournalLine."Line Amount";

        IF (JobJournalLine."Line Discount Amount" <> 0) AND (JobJournalLine."Line Discount Amount (LCY)" = 0) THEN
            IF JobJournalLine."Currency Code" <> '' THEN
                JobJournalLine."Line Discount Amount (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(JobJournalLine."Posting Date",
                                                      JobJournalLine."Currency Code", JobJournalLine."Line Discount Amount (LCY)",
                                                      CurrExchRate.ExchangeRate(JobJournalLine."Posting Date", JobJournalLine."Currency Code")),
                                                      Currency."Amount Rounding Precision")
            ELSE
                JobJournalLine."Line Discount Amount (LCY)" := JobJournalLine."Line Discount Amount";
        //ProjectPro - end


    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Jnl.-Post Line", 'OnBeforePostResource', '', false, false)]
    local procedure NS_C12OnBeforePostResource(var EntryNo: Integer; var IsHandled: Boolean; var JobJnlLine2: Record "Job Journal Line"; var JobJournalLine: Record "Job Journal Line")
    var
        ResJnlLine: Record "Res. Journal Line";
        ResLedgEntry: Record "Res. Ledger Entry";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        NS_JobsSetup: Record "Jobs Setup";
    begin
        //PRJ-1170.NK.1.0 Start
        //with ResJnlLine do begin
        NS_JobsSetup.Get(); //PRJ-1295.NK.1.0 12Apr2022
        ResJnlLine.Init();
        ResJnlLine.CopyFromJobJnlLine(JobJnlLine2);
        ResLedgEntry.LockTable();
        //ProjectPro - start
        IF NOT JobJournalLine."Job Posting Only" THEN
            IF JobJnlLine2."Entry Type" = JobJnlLine2."Entry Type"::Usage THEN
                //ProjectPro - end
                ResJnlPostLine.RunWithCheck(ResJnlLine);
        JobJnlLine2."Resource Group No." := ResJnlLine."Resource Group No.";
        EntryNo := NS_CreateJobLedgEntry(JobJnlLine2);
        //ProjectPro - start
        // IF (JobJnlLine2."Journal Batch Name" = 'PAYROLL') THEN //PE-247.HS.1.0 6Feb2024 Commented
        // IF NS_JobsSetup."NS_Post Job Labor to G/L" THEN  //PE-247.HS.1.0 6Feb2024 Commented

        //PE-247.HS.1.0 6Feb2024 Start
        IF NS_JobsSetup."NS_Enable Job Labor to G/L" THEN begin
            if JobJnlLine2."Journal Batch Name" = NS_JobsSetup."NS_Labor Job Journal Batch" then
                NS_PostLaborToGL(JobJournalLine);
            //PE-247.HS.1.0 6Feb2024 End
        end;
        //ProjectPro - end
        IsHandled := true;
        //end;
        //PRJ-1170.NK.1.0 End
    end;


    //PPAL-46.SK.1.0 Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Jnl.-Post Line", 'OnBeforeCreateJobLedgEntryFromPostItem', '', False, false)]
    local procedure NS_C1012OnBeforeCreateJobLedgEntryFromPostItem(var IsHandled: Boolean; var JobJournalLine: Record "Job Journal Line"; var ValueEntry: Record "Value Entry")
    var
        InvStp: Record "Inventory Setup";//PRJCTPR-198.AS.1.0
    begin
        if InvStp.Get() then;//PRJCTPR-198.AS.1.0

        if InvStp.NS_AllowZeroCostJLE = false then begin //PRJCTPR-198.AS.1.0 Added old code inside begin..end
            IF (JobJournalLine."Total Cost (LCY)" <> 0) OR (JobJournalLine."Total Price (LCY)" <> 0) then
                IsHandled := false
            else
                IsHandled := True;
        end;
    End;
    //PPAL-46.SK.1.0 End

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Jnl.-Post Line", 'OnPostItemOnBeforeAssignItemJnlLine', '', false, false)]
    local procedure NS_C1012OnPostItemOnBeforeAssignItemJnlLine(var ItemJnlLine: Record "Item Journal Line"; var JobJournalLine2: Record "Job Journal Line")
    begin
        ItemJnlLine.NS_Category := JobJournalLine2."NS_Job Cost Category";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Jnl.-Post Line", 'OnBeforeUpdateJobJnlLineAmount', '', false, false)]
    local procedure NS_C1012OnBeforeUpdateJobJnlLineAmount(var RemainingQtyToTrack: Decimal; var IsHandled: Boolean)
    begin
        IF RemainingQtyToTrack <> 0 then
            IsHandled := false
        else
            IsHandled := true;
    end;

    procedure NS_CreateJobLedgEntry(JobJnlLine2: Record "Job Journal Line"): Integer
    var
        ResLedgEntry: Record "Res. Ledger Entry";
        JobLedgEntry: Record "Job Ledger Entry";
        JobPlanningLine: Record "Job Planning Line";
        Job: Record Job;
        NSCrewTimeSheetLine: Record NS_TimeSheetLineCustom;    //PRJ-772.JS.1.0 27July2021
        NSCrewTimeCustHdr: Record NS_TimesheetHdrCustom;       //PRJ-772.JS.1.0 27July2021
        TimeSheetDetail: Record "Time Sheet Detail";          //PRJ-772.JS.1.0 28July2021
        JobTransferLine: Codeunit "Job Transfer Line";
        JobLinkUsage: Codeunit "Job Link Usage";
        JobLedgEntryNo: Integer;
        IsHandled: Boolean;
        JobSetup: Record "Jobs Setup";//CTSI-254
        JobPostLine: Codeunit "Job Post-Line";
        ParaMeterOfEvent: Codeunit "NS_Parameters for Events";//PRJ-458
        Licdate: date;//PRJ-516
        NoOfDays: Text;//PRJ-516
        EnvInfoCU: Codeunit "Environment Information";//PRJ-516
        NS_JobsSetup: Record "Jobs Setup";//PRJ-623.MS.1.0
        BurdenPercent: Decimal;//PRJ-623.MS.1.0
        JobTask: Record "Job Task";//PRJ-623.MS.1.0
        GLSetup: Record "General Ledger Setup";//PRJ-623.MS.1.0  
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

        //CTSI-254 start
        if JobSetup.get then;
        if (JobSetup."NS_Default Job Task No." <> '') or (JobSetup."NS_Default Job Task No. Rev." <> '') then begin
            if ((JobSetup."NS_Default Job Task No." = JobJnlLine2."Job Task No.")
                                            and (JobSetup."NS_Burden G/L Journal Batch" = JobJnlLine2."Journal Batch Name"))
                                            or ((JobSetup."NS_Default Job Task No. Rev." = JobJnlLine2."Job Task No.")
                                            and (JobSetup."NS_Burden G/L Journal Batch Rev." = JobJnlLine2."Journal Batch Name")) then
                exit;
        end;
        //CTSI-254 end

        NS_SetCurrency(JobJnlLine2);

        JobLedgEntry.Init();
        JobTransferLine.FromJnlLineToLedgEntry(JobJnlLine2, JobLedgEntry);

        if JobLedgEntry."Entry Type" = JobLedgEntry."Entry Type"::Sale then begin
            JobLedgEntry.Quantity := -JobJnlLine2.Quantity;
            JobLedgEntry."Quantity (Base)" := -JobJnlLine2."Quantity (Base)";
            JobLedgEntry."Total Cost (LCY)" := -JobJnlLine2."Total Cost (LCY)";
            JobLedgEntry."Total Cost" := -JobJnlLine2."Total Cost";
            JobLedgEntry."Total Price (LCY)" := -JobJnlLine2."Total Price (LCY)";
            JobLedgEntry."Total Price" := -JobJnlLine2."Total Price";
            JobLedgEntry."Line Amount (LCY)" := -JobJnlLine2."Line Amount (LCY)";
            JobLedgEntry."Line Amount" := -JobJnlLine2."Line Amount";
            JobLedgEntry."Line Discount Amount (LCY)" := -JobJnlLine2."Line Discount Amount (LCY)";
            JobLedgEntry."Line Discount Amount" := -JobJnlLine2."Line Discount Amount";
            JobLedgEntry."NS_Segment Code" := JobJnlLine2."NS_Segment Code";//TM-10.AM.1.0
        end else begin
            JobLedgEntry.Quantity := JobJnlLine2.Quantity;
            JobLedgEntry."Quantity (Base)" := JobJnlLine2."Quantity (Base)";
            //PRJ-1436.VC.1.0 08JUL2022 - Start Commented
            // JobLedgEntry."Total Cost (LCY)" := JobJnlLine2."Total Cost (LCY)";
            // JobLedgEntry."Total Cost" := JobJnlLine2."Total Cost";
            //PRJ-1436.VC.1.0 08JUL2022 - End
            //PRJ-1436.VC.1.0 08JUL2022 - Start
            if JobJnlLine2."NS_Payroll Burden Amount" = 0 then begin
                JobLedgEntry."Total Cost (LCY)" := JobJnlLine2."Total Cost (LCY)";
                JobLedgEntry."Total Cost" := JobJnlLine2."Total Cost";
            end else begin
                JobLedgEntry."Total Cost (LCY)" := JobJnlLine2."Total Cost (LCY)" + JobJnlLine2."NS_Payroll Burden Amount";
                //PRJ-1436.VC.1.0 13JUL2022 - Start
                //JobLedgEntry."Total Cost" := JobJnlLine2."Total Cost";              
                JobLedgEntry."Total Cost" := JobJnlLine2."Total Cost" + JobJnlLine2."NS_Payroll Burden Amount";
                //PRJ-1436.VC.1.0 13JUL2022 - End
            end;
            //PRJ-1436.VC.1.0 08JUL2022 - End
            JobLedgEntry."Total Price (LCY)" := JobJnlLine2."Total Price (LCY)";
            JobLedgEntry."Total Price" := JobJnlLine2."Total Price";
            JobLedgEntry."Line Amount (LCY)" := JobJnlLine2."Line Amount (LCY)";
            JobLedgEntry."Line Amount" := JobJnlLine2."Line Amount";
            JobLedgEntry."Line Discount Amount (LCY)" := JobJnlLine2."Line Discount Amount (LCY)";
            JobLedgEntry."Line Discount Amount" := JobJnlLine2."Line Discount Amount";
        end;

        JobLedgEntry."Additional-Currency Total Cost" := -JobLedgEntry."Additional-Currency Total Cost";
        JobLedgEntry."Add.-Currency Total Price" := -JobLedgEntry."Add.-Currency Total Price";
        JobLedgEntry."Add.-Currency Line Amount" := -JobLedgEntry."Add.-Currency Line Amount";

        JobLedgEntry."Entry No." := GlobalNextEntryNo;
        JobLedgEntry."No. Series" := JobJnlLine2."Posting No. Series";
        JobLedgEntry."Original Unit Cost (LCY)" := JobLedgEntry."Unit Cost (LCY)";
        JobLedgEntry."Original Total Cost (LCY)" := JobLedgEntry."Total Cost (LCY)";
        JobLedgEntry."Original Unit Cost" := JobLedgEntry."Unit Cost";
        JobLedgEntry."Original Total Cost" := JobLedgEntry."Total Cost";
        JobLedgEntry."Original Total Cost (ACY)" := JobLedgEntry."Additional-Currency Total Cost";
        JobLedgEntry."Dimension Set ID" := JobJnlLine2."Dimension Set ID";

        //PRJ-772.AS.1.0 - START
        JobLedgEntry."NS_Crew Code" := JobJnlLine2."NS_Crew Code";
        JobLedgEntry."NS_Crew Name" := JobJnlLine2."NS_Crew Name";
        JobLedgEntry."NS_Crew Time Sheet Line" := JobJnlLine2."NS_Crew Time Sheet Line";
        JobLedgEntry."NS_Crew Time Sheet Ref. No." := JobJnlLine2."NS_Crew Time Sheet Ref. No.";
        //PRJ-772.AS.1.0 - END
        JobLedgEntry."NS_Crew Time Unique Line ID" := JobJnlLine2."NS_Crew Time Unique Line ID"; //PRJ-772.JS.1.0 26July2021
        JobLedgEntry."NS_Segment Code" := JobJnlLine2."NS_Segment Code";   //PRJ-842.JS.1.0 16Aug2021
                                                                           //PE-68 Dk.1.0 10April2023 Start
                                                                           // JobLedgEntry."NS_Skill Code" := JobJnlLine2."NS_Skill Code";   //PRJ-841.JS.1.0 16Aug2021-Start 
        JobLedgEntry."NS_Skill Code New" := JobJnlLine2."NS_Skill Code New";
        //PE-68 Dk.1.0 10April2023 End
        //PRJ-1015.JS.1.0 10Oct2021 -Start
        If Job.get(JobJnlLine2."Job No.") then
            JobLedgEntry."NS_Sub-Level to Job No." := Job."NS_Sub-Level to Job No.";
        //PRJ-1015.JS.1.0 10Oct2021 -end           

        with JobJnlLine2 do
            case Type of
                Type::Resource:
                    if "Entry Type" = "Entry Type"::Usage then
                        if ResLedgEntry.FindLast then begin
                            JobLedgEntry."Ledger Entry Type" := JobLedgEntry."Ledger Entry Type"::Resource;
                            JobLedgEntry."Ledger Entry No." := ResLedgEntry."Entry No.";
                        end;
                Type::Item:
                    begin
                        JobLedgEntry."Ledger Entry Type" := "Ledger Entry Type"::Item;
                        JobLedgEntry."Ledger Entry No." := "Ledger Entry No.";
                        JobLedgEntry.CopyTrackingFromJobJnlLine(JobJnlLine2);
                    end;
            end;


        if JobLedgEntry."Entry Type" = JobLedgEntry."Entry Type"::Sale then
            JobLedgEntry.CopyTrackingFromJobJnlLine(JobJnlLine2);

        //PRJ-772.JS.1.0 28July2021-Start
        If JobJnlLine2."NS_Crew Time Sheet Ref. No." <> '' then begin
            TimeSheetDetail.Reset();
            TimeSheetDetail.SetRange("NS_Crew Time Sheet Ref. No.", JobJnlLine2."NS_Crew Time Sheet Ref. No.");
            TimeSheetDetail.SetRange("Job No.", JobJnlLine2."Job No.");
            TimeSheetDetail.SetRange("Job Task No.", JobJnlLine2."Job Task No.");
            TimeSheetDetail.SetRange("NS_Crew Code", JobJnlLine2."NS_Crew Code");
            TimeSheetDetail.SetRange("Resource No.", JobJnlLine2."No.");
            TimeSheetDetail.SetRange("NS_Crew Time Sheet Date", JobJnlLine2."NS_Crew Time Sheet Date");
            TimeSheetDetail.SetRange("NS_Work Type Code", JobJnlLine2."Work Type Code");  //PE-346.JS.1.0 30July2024
            TimeSheetDetail.SetRange("NS_Crew Time Unique Line ID", JobJnlLine2."NS_Crew Time Unique Line ID");  //PE-346.JS.1.0 30July2024
            IF TimeSheetDetail.FindFirst() then begin
                NSCrewTimeSheetLine.Reset();
                NSCrewTimeSheetLine.SetRange("NS_TimeSheetNo.", TimeSheetDetail."NS_Crew Time Sheet Ref. No.");
                NSCrewTimeSheetLine.SetRange("NS_Job No.", TimeSheetDetail."Job No.");
                NSCrewTimeSheetLine.SetRange("NS_Job Task No.", TimeSheetDetail."Job Task No.");
                NSCrewTimeSheetLine.SetRange("NS_Crew Code", TimeSheetDetail."NS_Crew Code");
                NSCrewTimeSheetLine.SetRange("NS_Resource No.", TimeSheetDetail."Resource No.");
                NSCrewTimeSheetLine.SetRange("NS_Working Date", TimeSheetDetail."NS_Crew Time Sheet Date");
                NSCrewTimeSheetLine.SetRange("NS_Unique Line ID", TimeSheetDetail."NS_Crew Time Unique Line ID");
                IF NSCrewTimeSheetLine.FindFirst() then begin
                    NSCrewTimeSheetLine.NS_Status := NSCrewTimeSheetLine.NS_Status::Posted;
                    NSCrewTimeSheetLine.Modify();
                    NSCrewTimeCustHdr.Get(NSCrewTimeSheetLine."NS_TimeSheetNo.");
                    NSCrewTimeCustHdr.NS_Status := NSCrewTimeCustHdr.NS_Status::Posted;
                    NSCrewTimeCustHdr.Modify();
                end;
            end;
        end;
        // //PRJ-772.JS.1.0 28July2021-End            

        //PRJ-623.MS.1.0  start
        IF (JobLedgEntry."Entry Type" = JobLedgEntry."Entry Type"::Usage) and (JobLedgEntry.Type = JobLedgEntry.Type::Resource) THEN BEGIN
            if Job.get(JobLedgEntry."Job No.") then;
            BurdenPercent := JobTask.NS_GetTaskBurdenPercent(Job, JobLedgEntry."Job Task No.") / 100;
            NS_JobsSetup.GET;
            IF NS_JobsSetup."NS_Calculate Indirect Burden" THEN
                JobLedgEntry."NS_Burden Amount" := ROUND(JobLedgEntry."Total Cost (LCY)" * BurdenPercent, GLSetup."Amount Rounding Precision");
            JobLedgEntry."NS_Burden Type" := Job."NS_Indirect Burden Type";

        END;
        //PRJ-623.MS.1.0 end 
        OnBeforeJobLedgEntryInsert(JobLedgEntry); //PRJ-1410.GK.1.0 19May2022
        JobLedgEntry.Insert(true);

        JobReg."To Entry No." := GlobalNextEntryNo;
        JobReg.Modify();

        JobLedgEntryNo := JobLedgEntry."Entry No.";
        IsHandled := false;
        if not IsHandled then
            if JobLedgEntry."Entry Type" = JobLedgEntry."Entry Type"::Usage then begin
                // Usage Link should be applied if it is enabled for the job,
                // if a Job Planning Line number is defined or if it is enabled for a Job Planning Line.
                Job.Get(JobLedgEntry."Job No.");
                if Job."Apply Usage Link" or
                   (JobJnlLine2."Job Planning Line No." <> 0) or
                   JobLinkUsage.FindMatchingJobPlanningLine(JobPlanningLine, JobLedgEntry)
                then
                    JobLinkUsage.ApplyUsage(JobLedgEntry, JobJnlLine2)
                else
                    JobPostLine.InsertPlLineFromLedgEntry(JobLedgEntry)
            end;
        //ProjectPro - start
        IF JobJnlLine2."NS_Subcontract No." > '' THEN
            NS_PostSubcontract(JobJnlLine2, JobLedgEntry);
        //ProjectPro - end
        GlobalNextEntryNo := GlobalNextEntryNo + 1;

        exit(JobLedgEntryNo);
    end;


    procedure NS_SetCurrency(JobJnlLine: Record "Job Journal Line")
    Var
        Currency: Record Currency;
    begin
        if JobJnlLine."Currency Code" = '' then begin
            Clear(Currency);
            Currency.InitRoundingPrecision
        end else begin
            Currency.Get(JobJnlLine."Currency Code");
            Currency.TestField("Amount Rounding Precision");
            Currency.TestField("Unit-Amount Rounding Precision");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Jnl.-Post Line", 'OnBeforeCheckJob', '', false, false)]
    local procedure NS_C1012SavingNextEntryNoAndJobReg(var JobRegister: Record "Job Register"; var NextEntryNo: Integer)
    begin
        GlobalNextEntryNo := NextEntryNo;
        JobReg := JobRegister;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Jnl.-Post Line", 'OnBeforeItemPosting', '', false, false)]
    local procedure NS_C1012OnBeforeItemPosting(var JobJournalLine: Record "Job Journal Line"; var IsHandled: Boolean)
    begin

        IF JobJournalLine.NS_Staged then
            // IsHandled := true; //comment by PE-154.NK.1.0 as this functinality needs to update in case of Staged also
            IsHandled := false; //PE-154.NK.1.0 start 07Sept2023

    end;

    local procedure NS_PostLaborToGL(PassJobJnlLine: Record "Job Journal Line")
    var
        GenJnlLine: Record "Gen. Journal Line";
        Job: Record Job;
        JnlTemplate: Code[10];
        BatchName: Code[10];
        LineNum: Integer;
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
        LaborToJobAcct: Code[20];
        LaborToJobOffset: Code[20];
        NS_JobsSetup: Record "Jobs Setup";
        GenJnlPostCU: Codeunit "Gen. Jnl.-Post Line";//PE-247.HS.1.0
        GenJnlLinePost: Record "Gen. Journal Line";//PE-247.HS.1.0
    begin
        // JnlTemplate := 'GENERAL'; //PE-247.HS.1.0 6Feb2024 Commented
        NS_JobsSetup.Get;
        BatchName := NS_JobsSetup."NS_Labor to Job Batch Name";
        JnlTemplate := NS_JobsSetup."NS_Labor G/L Journal Template";  //PE-247.HS.1.0 6Feb2024
        LaborToJobAcct := NS_JobsSetup."NS_LaborAllocated toJob -Debit";
        LaborToJobOffset := NS_JobsSetup."NS_Labor to JobOffset - Credit";
        GenJnlLine.Reset;
        GenJnlLine.SetRange("Journal Template Name", JnlTemplate);
        GenJnlLine.SetRange("Journal Batch Name", BatchName);
        if GenJnlLine.FindLast then
            LineNum := GenJnlLine."Line No."
        else
            LineNum := 0;
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name" := JnlTemplate;
        GenJnlLine."Journal Batch Name" := BatchName;
        LineNum += 10000;
        GenJnlLine."Line No." := LineNum;
        GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
        GenJnlLine.Validate("Account No.", LaborToJobAcct);
        GenJnlLine.Validate("Posting Date", PassJobJnlLine."Posting Date");
        GenJnlLine."Document No." := PassJobJnlLine."Document No.";
        GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
        GenJnlLine.Validate("Bal. Account No.", LaborToJobOffset);
        GenJnlLine.Validate("Currency Code", PassJobJnlLine."Currency Code");
        //PRJ-1436.VC.1.0 08JUL2022 - Commented Start
        // //PRJ-1436.JS.1.0 07JUN2022 - Start
        // if PassJobJnlLine."NS_Burden Amount" = 0 then
        //     GenJnlLine.Validate(Amount, PassJobJnlLine."Total Cost")
        // else
        //     GenJnlLine.Validate(Amount, PassJobJnlLine."Total Cost" + PassJobJnlLine."NS_Burden Amount");
        // //PRJ-1436.JS.1.0 07JUN2022 - end
        //PRJ-1436.VC.1.0 08JUL2022 - Commented End
        //PRJ-1436.VC.1.0 08JUL2022 - Start
        if PassJobJnlLine."NS_Payroll Burden Amount" = 0 then
            GenJnlLine.Validate(Amount, PassJobJnlLine."Total Cost")
        else
            GenJnlLine.Validate(Amount, PassJobJnlLine."Total Cost" + PassJobJnlLine."NS_Payroll Burden Amount");
        //PRJ-1436.VC.1.0 08JUL2022 - end    
        GenJnlLine.Validate("Source Code", 'GENJNL');
        GenJnlLine.Validate("Job No.", PassJobJnlLine."Job No.");
        GenJnlLine.Validate("Job Task No.", PassJobJnlLine."Job Task No.");
        GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::Settlement;
        //GenJnlLine."VAT Calculation Type" := GenJnlLine."VAT Calculation Type"::"Sales Tax"; //PRJ-1295.NK.1.0 12Apr2022 Block
        GenJnlLine."Job Quantity" := PassJobJnlLine.Quantity;
        GenJnlLine.Insert(true);
        //GenJnlPost.Run(GenJnlLinePost); //PE-247.HS.1.0 comment
        //PE-247.HS.1.0 6Feb2024 Start
        if NS_JobsSetup."NS_Post Job Labor to G/L" then begin
            GenJnlLinePost.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
            GenJnlLinePost.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
            GenJnlLinePost.SetRange("Document No.", GenJnlLine."Document No.");
            if GenJnlLinePost.FindSet() then
                GenJnlPost.Run(GenJnlLinePost);
        end;
        //PE-247.HS.1.0 6Feb2024  End

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Jnl.-Post Line", 'OnAfterRunCode', '', False, False)]
    local procedure NS_C1012ModifyJobMatPlan(var JobJournalLine: Record "Job Journal Line")
    var
        SourceCodeSetupRec: Record "Source Code Setup"; //PRJ-444.MS.1.0V17 12Jan2021
        JobMatPlan: Record "NS_Job Material Planning";
        NS_ILE: Record "Item Ledger Entry"; //PE-146.NK.1.0 16Aug2023
    begin
        SourceCodeSetupRec.get; //PRJ-444.MS.1.0V17 12Jan2021

        With JobJournalLine Do Begin
            //ProjectPro - start
            //   IF Type = Type::Item THEN BEGIN 
            IF (JobJournalLine.Type = JobJournalLine.Type::Item) and (JobJournalLine.NS_Staged = true) THEN BEGIN//PE-146.NK.1.0 Start 16Aug2023 added and condition of staged
                IF "NS_Purch. Receipt Doc. No." = '' THEN BEGIN
                    if SourceCodeSetupRec."Adjust Cost" <> "Source Code" then begin //PRJ-444.MS.1.0V17 12Jan2021 Added code in this condition - start
                        JobMatPlan.RESET;
                        JobMatPlan.SETRANGE("NS_Worksheet Job No.", "Job No.");
                        JobMatPlan.SETRANGE("NS_Document No.", "Document No.");
                        JobMatPlan.SETRANGE("NS_Part No.", "No.");
                        IF JobMatPlan.FINDFIRST THEN BEGIN
                            JobMatPlan."NS_Inventory Qty. Staged" += Quantity;
                            JobMatPlan."NS_Total Quantity Staged" += JobJournalLine.Quantity; //PE-146.NK.1.0 start 18Aug2023
                            JobMatPlan.MODIFY;
                        END;
                    END;//PRJ-444.MS.1.0V17 12Jan2021 Added code in this condition - end
                END;
            END;

        End;
        //PE-146.NK.1.0 start 16Aug2023
        IF (JobJournalLine.Type = JobJournalLine.Type::Item) THEN BEGIN//PE-146.NK.1.0 Start 16Aug2023 added and condition of staged
            IF JobJournalLine."NS_Purch. Receipt Doc. No." = '' THEN BEGIN
                if SourceCodeSetupRec."Adjust Cost" <> JobJournalLine."Source Code" then begin //PRJ-444.MS.1.0V17 12Jan2021 Added code in this condition - start
                    JobMatPlan.RESET();
                    JobMatPlan.SETRANGE("NS_Worksheet Job No.", JobJournalLine."Job No.");
                    JobMatPlan.SETRANGE("NS_Document No.", JobJournalLine."Document No.");
                    JobMatPlan.SETRANGE("NS_Part No.", JobJournalLine."No.");
                    IF JobMatPlan.FINDFIRST() THEN BEGIN
                        NS_ILE.Reset();
                        NS_ILE.SetRange("Item No.", JobMatPlan."NS_Part No.");
                        NS_ILE.CALCSUMS(Quantity);
                        if JobJournalLine.NS_Staged = true then
                            JobMatPlan."NS_Inv. Avail" := NS_ILE.Quantity;
                        JobMatPlan.Modify();
                    END;
                END;
            END;
        END;
        IF (JobJournalLine.Type = JobJournalLine.Type::Item) and (JobJournalLine.NS_Staged = false) THEN BEGIN
            JobMatPlan.RESET();
            JobMatPlan.SETRANGE("NS_Worksheet Job No.", JobJournalLine."Job No.");
            JobMatPlan.SETRANGE("NS_Document No.", JobJournalLine."Document No.");
            JobMatPlan.SETRANGE("NS_Part No.", JobJournalLine."No.");
            IF JobMatPlan.FINDFIRST() THEN BEGIN
                NS_ILE.Reset();
                NS_ILE.SetRange("Item No.", JobMatPlan."NS_Part No.");
                NS_ILE.CALCSUMS(Quantity);
                JobMatPlan."NS_Inv. Avail" := NS_ILE.Quantity;
                JobMatPlan.Modify();
            END;
        END;
        //PE-146.NK.1.0 end 16Aug2023
        //ProjectPro - end
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Jnl.-Post Line", 'OnBeforeJobLedgEntryInsert', '', False, false)]
    local procedure NS_C1012SettingUpBurden(JobJournalLine: Record "Job Journal Line"; var JobLedgerEntry: Record "Job Ledger Entry")
    var
        NS_JobsSetup: Record "Jobs Setup";
        BurdenPercent: Decimal;
        JobTask: Record "Job Task";
        Job: Record Job;
        CurrExchRate: Record "Currency Exchange Rate";
        Currency: Record Currency;
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get();
        IF JobTask.Get(JobJournalLine."Job No.", JobJournalLine."Job Task No.") then;
        IF Job.get(JobJournalLine."Job No.") then;
        //ProjectPro - start
        //PRJ-623.MS.1.0 Code comment
        //JobLedgerEntry."Unit Price (LCY)" := JobJournalLine."Unit Price (LCY)";
        //JobLedgerEntry."Unit Price" := JobJournalLine."Unit Price";
        //IF JobJournalLine."Job Posting Only" THEN BEGIN
        //    JobLedgerEntry."Ledger Entry Type" := 0;
        //    JobLedgerEntry."Ledger Entry No." := 0;
        //END;
        //PRJ-623.MS.1.0 Code comment
        IF JobLedgerEntry."Entry Type" = JobLedgerEntry."Entry Type"::Usage THEN BEGIN
            BurdenPercent := JobTask.NS_GetTaskBurdenPercent(Job, JobLedgerEntry."Job Task No.") / 100;
            NS_JobsSetup.GET;
            IF NS_JobsSetup."NS_Calculate Indirect Burden" THEN
                JobLedgerEntry."NS_Burden Amount" := ROUND(JobLedgerEntry."Total Cost (LCY)" * BurdenPercent, GLSetup."Amount Rounding Precision");
            JobLedgerEntry."NS_Burden Type" := Job."NS_Indirect Burden Type";
            //PRJ-623.MS.1.0 Code comment
            //IF JobLedgerEntry."Currency Code" <> '' THEN
            //     JobLedgerEntry."Total Cost" := ROUND(CurrExchRate.ExchangeAmtLCYToFCY(JobLedgerEntry."Posting Date",
            //                                        JobLedgerEntry."Currency Code", JobLedgerEntry."Total Cost (LCY)",
            //                                        CurrExchRate.ExchangeRate(JobLedgerEntry."Posting Date", JobLedgerEntry."Currency Code")),
            //                                        Currency."Amount Rounding Precision")
            // ELSE
            //     JobLedgerEntry."Total Cost" := JobLedgerEntry."Total Cost (LCY)";
            //PRJ-623.MS.1.0 Code comment
        END;
        //ProjectPro - end
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Jnl.-Post Line", 'OnAfterJobLedgEntryInsert', '', False, False)]
    local procedure NS_C1012ModifyPostingDateOnJob(JobJournalLine: Record "Job Journal Line"; var JobLedgerEntry: Record "Job Ledger Entry")
    var
        NS_Job: Record Job;
    begin
        //ProjectPro - start
        NS_Job.GET(JobLedgerEntry."Job No.");
        NS_Job."NS_Job Posting Date" := TODAY;
        NS_Job.MODIFY;
        //ProjectPro - end
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Jnl.-Post Line", 'OnBeforeApplyUsageLink', '', false, false)]
    local procedure NS_C1012OnBeforeApplyUsageLink(var IsHandled: Boolean; var JobJournalLine: Record "Job Journal Line"; var JobLedgerEntry: Record "Job Ledger Entry")
    Var
        JobLocal: Record Job;
        JobPlanningLine: Record "Job Planning Line";
        JobSetup: Record "Jobs Setup";       //PRJ-866.JS.1.0 19Aug2021
        JobLinkUsage: Codeunit "Job Link Usage";
        JobPostLine: Codeunit "Job Post-Line";
    begin
        //IF (JobLedgerEntry."Entry Type" = JobLedgerEntry."Entry Type"::Usage) AND (JobLedgerEntry."NS_Subcontract No." = '') THEN BEGIN   //PRJ-866.JS.1.0 Commented
        IF (JobLedgerEntry."Entry Type" = JobLedgerEntry."Entry Type"::Usage) then begin    //PRJ-866.JS.1.0 Add Line
            // Usage Link should be applied if it is enabled for the job,
            // if a Job Planning Line number is defined or if it is enabled for a Job Planning Line.
            JobLocal.Get(JobLedgerEntry."Job No.");
            if JobLocal."Apply Usage Link" or
               (JobJournalLine."Job Planning Line No." <> 0) or
               JobLinkUsage.FindMatchingJobPlanningLine(JobPlanningLine, JobLedgerEntry)
            then
                JobLinkUsage.ApplyUsage(JobLedgerEntry, JobJournalLine)

            else
                JobPostLine.InsertPlLineFromLedgEntry(JobLedgerEntry);
        End;

        IsHandled := true;
        //ProjectPro - start
        IF JobJournalLine."NS_Subcontract No." > '' THEN
            NS_PostSubcontract(JobJournalLine, JobLedgerEntry);
        //ProjectPro - end
    end;

    procedure NS_PostSubcontract(JobJnlLine2: Record "Job Journal Line"; JobLedgEntry: record "Job Ledger Entry")
    var
        NS_Subcontract: Record NS_Subcontract;
        NS_SubcontractLedgEntry: Record "NS_Subcontract Ledger Entry";
        NS_SubcontractReg: Record "NS_Subcontract Register";
        NS_SubcontractRegisterInitialized: Boolean;
        NS_NextSubcontractEntryNo: Integer;
    begin
        //ProjectPro - start
        with NS_SubcontractLedgEntry do begin
            NS_Subcontract.Get(JobJnlLine2."NS_Subcontract No.");
            NS_Subcontract.TestField(NS_Status, NS_Subcontract.NS_Status::Order);

            if not NS_SubcontractRegisterInitialized then begin
                if "NS_Entry No." = 0 then begin
                    LockTable;
                    if FindLast then
                        NS_NextSubcontractEntryNo := "NS_Entry No.";
                    NS_NextSubcontractEntryNo += 1;
                end;

                if JobJnlLine2."Document Date" = 0D then
                    JobJnlLine2."Document Date" := JobJnlLine2."Posting Date";

                if NS_SubcontractReg."NS_No." = 0 then begin
                    NS_SubcontractReg.LockTable;
                    if (not NS_SubcontractReg.FindLast) or (NS_SubcontractReg."NS_To Entry No." <> 0) then begin
                        NS_SubcontractReg.Init;
                        NS_SubcontractReg."NS_No." := NS_SubcontractReg."NS_No." + 1;
                        NS_SubcontractReg."NS_From Entry No." := NS_NextSubcontractEntryNo;
                        NS_SubcontractReg."NS_To Entry No." := NS_NextSubcontractEntryNo;
                        NS_SubcontractReg."NS_Creation Date" := Today;
                        NS_SubcontractReg."NS_Source Code" := "NS_Source Code";
                        NS_SubcontractReg."NS_Journal Batch Name" := "NS_Journal Batch Name";
                        NS_SubcontractReg."NS_User ID" := UserId;
                        NS_SubcontractReg.Insert;
                    end;
                end;
                NS_SubcontractReg."NS_To Entry No." := NS_NextSubcontractEntryNo;
                NS_SubcontractReg.Modify;
                NS_SubcontractRegisterInitialized := true;
            end;

            Init;
            "NS_Entry No." := NS_NextSubcontractEntryNo;
            "NS_Subcontract No." := JobJnlLine2."NS_Subcontract No.";
            "NS_Posting Date" := JobJnlLine2."Posting Date";
            "NS_Document No." := JobJnlLine2."Document No.";
            NS_Type := JobJnlLine2.Type;
            "NS_No." := JobJnlLine2."No.";
            NS_Description := JobJnlLine2.Description;

            case JobJnlLine2."Entry Type" of
                JobJnlLine2."Entry Type"::Usage:
                    begin
                        "NS_Entry Type" := "NS_Entry Type"::Purchase;
                        NS_Quantity := -JobJnlLine2.Quantity;
                        "NS_Quantity (Base)" := -JobJnlLine2."Quantity (Base)";
                    end;
                JobJnlLine2."Entry Type"::NS_Payment,
                JobJnlLine2."Entry Type"::Sale:
                    begin
                        "NS_Entry Type" := "NS_Entry Type"::Payment;
                        NS_Quantity := JobJnlLine2.Quantity;
                        "NS_Quantity (Base)" := JobJnlLine2."Quantity (Base)";
                    end;
            end;

            //If this is a purchase then reverse the quantities
            if "NS_Entry Type" = "NS_Entry Type"::Purchase then begin
                NS_Quantity := -NS_Quantity;
                "NS_Quantity (Base)" := -"NS_Quantity (Base)";
            end;

            "NS_Direct Unit Cost (LCY)" := JobJnlLine2."Direct Unit Cost (LCY)";
            "NS_Unit Cost (LCY)" := JobJnlLine2."Unit Cost (LCY)";
            "NS_Unit of Measure Code" := JobJnlLine2."Unit of Measure Code";
            "NS_Location Code" := JobJnlLine2."Location Code";
            "NS_Job Posting Group" := JobJnlLine2."Posting Group";
            "NS_Global Dimension 1 Code" := JobJnlLine2."Shortcut Dimension 1 Code";
            "NS_Global Dimension 2 Code" := JobJnlLine2."Shortcut Dimension 2 Code";
            "NS_Retention Ledger Code" := JobJnlLine2."NS_Retention Ledger Code";
            "NS_Dimension Set ID" := JobJnlLine2."Dimension Set ID";
            "NS_Work Type Code" := JobJnlLine2."Work Type Code";
            "NS_User ID" := UserId;
            "NS_Source Code" := JobJnlLine2."Source Code";
            NS_Positive := JobJnlLine2."Total Cost (LCY)" > 0;
            "NS_Journal Batch Name" := JobJnlLine2."Journal Batch Name";
            "NS_Reason Code" := JobJnlLine2."Reason Code";
            "NS_Transaction Type" := JobJnlLine2."Transaction Type";
            "NS_Transport Method" := JobJnlLine2."Transport Method";
            "NS_Country/Region Code" := JobJnlLine2."Country/Region Code";
            "NS_Entry/Exit Point" := JobJnlLine2."Entry/Exit Point";
            "NS_Document Date" := JobJnlLine2."Document Date";
            "NS_External Document No." := JobJnlLine2."External Document No.";
            NS_Area := JobJnlLine2.Area;
            "NS_Transaction Specification" := JobJnlLine2."Transaction Specification";
            "NS_No. Series" := JobLedgEntry."No. Series";
            NS_AdditionalCurrencyTotalCost := JobJnlLine2."Source Currency Total Cost";
            "NS_Add.-Currency Total Price" := JobJnlLine2."Source Currency Total Price";
            "NS_Add.-Currency Line Amount" := JobJnlLine2."Source Currency Line Amount";
            "NS_Job Task No." := JobJnlLine2."Job Task No.";
            "NS_Line Amount (LCY)" := JobJnlLine2."Line Amount (LCY)";
            "NS_Unit Cost" := JobJnlLine2."Unit Cost";
            "NS_Total Cost" := JobJnlLine2."Total Cost";
            "NS_Total Cost (LCY)" := JobJnlLine2."Total Cost (LCY)";
            "NS_Unit Price" := JobJnlLine2."Unit Price";
            "NS_Total Price" := -JobJnlLine2."Total Price";
            "NS_Line Amount" := JobJnlLine2."Line Amount";
            "NS_Line Discount Amount" := JobJnlLine2."Line Discount Amount";
            "NS_Line Discount Amount (LCY)" := JobJnlLine2."Line Discount Amount (LCY)";
            "NS_Currency Code" := JobJnlLine2."Currency Code";
            "NS_Currency Factor" := JobJnlLine2."Currency Factor";
            "NS_Ledger Entry Type" := JobLedgEntry."Ledger Entry Type";
            "NS_Ledger Entry No." := JobLedgEntry."Entry No.";
            "NS_Serial No." := JobLedgEntry."Serial No.";
            "NS_Lot No." := JobLedgEntry."Lot No.";
            "NS_Line Discount %" := JobJnlLine2."Line Discount %";
            "NS_Line Type" := JobJnlLine2."Line Type";
            "NS_Variant Code" := JobJnlLine2."Variant Code";
            "NS_Bin Code" := JobJnlLine2."Bin Code";
            "NS_Qty. per Unit of Measure" := JobJnlLine2."Qty. per Unit of Measure";
            "NS_Qty. per Unit of Measure" := JobJnlLine2."Qty. per Unit of Measure";
            "NS_Job No." := JobJnlLine2."Job No.";
            "NS_Job Cost Category" := JobJnlLine2."NS_Job Cost Category";
            NS_Subcontract.NS_JobTaskNoToAPO("NS_Job Task No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code");
            "NS_Work Units" := JobJnlLine2."NS_Work Units";
            "NS_Work Unit of Measure" := JobJnlLine2."NS_Work Unit of Measure";
            "NS_Job Ledger Entry No." := JobLedgEntry."Entry No.";
            Insert;

            NS_NextSubcontractEntryNo += 1;
        end;
        //ProjectPro - end
    end;
    //PRJ-1410.GK.1.0 19May2022 - start
    [IntegrationEvent(false, false)]
    local procedure OnBeforeJobLedgEntryInsert(var JobLedgerEntry: Record "Job Ledger Entry")
    begin
    end;
    //PRJ-1410.GK.1.0 19May2022 - end
    //PE-253.PS.1.0 21Feb2024 Start

    [EventSubscriber(ObjectType::Table, 169, 'OnAfterInsertEvent', '', false, false)]
    local procedure NSInsertJobLedgerEntriesbefore(var Rec: Record "Job Ledger Entry")
    var

        NS_DailyJobLog: Record "NS_Daily Job Log Sub.";
    begin
        NS_DailyJobLog.Reset();
        NS_DailyJobLog.SetRange("Documnet Job No.", Rec."Job No.");
        NS_DailyJobLog.SetRange("NS_Job Tasks", Rec."Job Task No.");
        NS_DailyJobLog.SetRange("Documnet No.", Rec."Document No.");
        if NS_DailyJobLog.FindSet() then begin
            repeat
                NS_DailyJobLog.NS_PostedJobJournal := true;
                NS_DailyJobLog.Modify();
            until NS_DailyJobLog.Next = 0;

        end;
    End;
    //PE-253.PS.1.0 21Feb2024 End 

    Var
        GlobalNextEntryNo: Integer;
        JobReg: Record "Job Register";


    [IntegrationEvent(false, false)]
    local procedure OnCheckPPLicenseExpire()
    begin
    end;

}
