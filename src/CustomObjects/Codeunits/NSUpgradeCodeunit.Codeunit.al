codeunit 14021315 NS_UpgradeCodeunit
{
    //PRJ-867.AS.1.0 New Upgrade codeunit to transfer field Sales person code data to field Sales person code New in tables Job Quote Header, Job Quote Header Archive 
    //PRJ-1074.AS.1.0 28DEC2021 : Done code to transfer values of field "NS_Resource Name" to field "NS_Resource Name New", as we are obseleting old field in "NS_TimeSheetLineCustom","Time Sheet Line" Table
    //PRJ-1258.JS.1.0 23MAR2022 
    //PE-68.Dk.1.0 10April2023 : Done code to transfer values of field "NS_Skill Class Code" to field "NS_Skill Class Code New" , as we are obseleting old field in "NS_JobResourcePrice","Job Resource Price" Table

    Subtype = Upgrade;
    Permissions = tabledata "NS_PPClientLicenseInformation" = rimd;//PE-259.AT


    trigger OnUpgradePerCompany()
    var
        NSJobQuoteHdr: Record "NS_Job Quote Header";//PRJ-867.AS.1.0
        NSJobQuoteHdrArchve: Record "NS_Job Quote Header Archive";//PRJ-867.AS.1.0
        NSJLEReportBuffer: Record "NS_Job LedgerEntryReportBuffer";//PRJ-831.AS.2.0 13OCT2021
        NSLockJobPlaningLine: Record "NS_Locked Job Planning Line";//PRJ-831.AS.2.0 13OCT2021
        NSJobs: Record Job;//PRJ-831.AS.2.0 13OCT2021
        NSTimesheetLineRec: Record NS_TimeSheetLineCustom; //PRJ-1074.AS.1.0 28DEC2021
        NSTimesheetLineStd: Record "Time Sheet Line";//PRJ-1074.AS.1.0 28DEC2021
        TsheetHdr: Record "Time Sheet Header";//PRJ-1074.AS.1.0 28DEC2021
        TsheetLineArchve: Record "NS_TimeSheetLineCustom Archive";//PRJ-1074.AS.1.0 28DEC2021
        PurchLineRec: Record "Purchase Line";//PRJ-1221.AS.1.0 25FEB2022
        SalesLineRec: Record "Sales Line";//PRJ-1221.AS.1.0 25FEB2022
        //PE-317 AT.1.0 25June2024 Start
        // jtasklines: Record "Job Task";//PRJ-1264.AS.1.0
        // NJob: Record job;//PRJ-1264.AS.1.0
        // Activity: Code[10];//PRJ-1264.AS.1.0
        // NProcess: Code[10];//PRJ-1264.AS.1.0
        // Operation: Code[10];//PRJ-1264.AS.1.0
        // Section: Code[10];//PRJ-1264.AS.1.0
        // JobActivity: Record "NS_Job Activity";//PRJ-1264.AS.1.0
        // JobProcess: Record "NS_Job Process";//PRJ-1264.AS.1.0
        // JobOperation: Record "NS_Job Operation";//PRJ-1264.AS.1.0
        // JobSection: Record NS_Sections;//PRJ-1264.AS.1.0
        //PE-317 AT.1.0 25June2024 End
        LockJobPlaningLine: Record "NS_Locked Job Planning Line"; //PRJ-1420.NK.1.0 30May2022
        NSProgressPaymentLine: Record "NS_Progress Payment Line";//PRJ-1623.GK.1.0 08Sept2022
        JobSetupRec: Record "Jobs Setup";//PRJ-1684.AS.1.0
        ResourcePrice: Record "Job Resource Price"; //PE-68.Dk.1.0 10April2023
                                                    //PRJ-1237.JS.1.0 18APR2022 - end
                                                    //PE-68.Dk.1.0 10April2023 Start
        JobLedgerEntry: Record "Job Ledger Entry";
        TimeSheetDetail: Record "Time Sheet Detail";
        JobJournalLine: Record "Job Journal Line";
        NS_TimeSheetLineCustom: Record "NS_TimeSheetLineCustom";
        NSEmployeeWageRate: Record "NS_Employee Wage Rate";
        NSTimeSheetLineCustom: Record "NS_TimeSheetLineCustom";
    //PE-68.Dk.1.0  10April2023 End
    //PE-317 AT.1.0 25June2024 Start
    //PE-211.AS start
    /*
    jbrec: Record job;
    PHorder: Record "Purchase Header";
    dailyjbrec: Record "NS_Daily Job Log";
    TSlineCustom: Record NS_TimeSheetLineCustom;
    PBhdr: Record "NS_Progress Billing Header";
    subcon: Record NS_Subcontract;
    PosCrMemo: Record "Purch. Cr. Memo Hdr.";
    PosInv: Record "Purch. Inv. Header";
    */
    //PE-211.AS end
    //PE-317 AT.1.0 25June2024 End
    begin
        // Code to perform company related table upgrade tasks
        //PRJ-867.AS.1.0 - start
        //PE-277.NC.1.0 27Mar2024 Start Block
        // if NSJobQuoteHdr.FindSet() then
        //     repeat
        //         if (NSJobQuoteHdr."NS_Salesperson Code" <> '') and (NSJobQuoteHdr."NS_Salesperson Code New" = '') then
        //             NSJobQuoteHdr."NS_Salesperson Code New" := NSJobQuoteHdr."NS_Salesperson Code";

        //         if (NSJobQuoteHdr."NS_Job Posting Group" <> '') and (NSJobQuoteHdr."NS_Job Posting Group New" = '') then //PRJ-993.AS.1.0
        //             NSJobQuoteHdr."NS_Job Posting Group New" := NSJobQuoteHdr."NS_Job Posting Group";//PRJ-993.AS.1.0

        //         NSJobQuoteHdr.Modify();
        //     until NSJobQuoteHdr.Next() = 0;

        // if NSJobQuoteHdrArchve.FindSet() then
        //     repeat
        //         if (NSJobQuoteHdrArchve."NS_Salesperson Code" <> '') and (NSJobQuoteHdrArchve."NS_Salesperson Code New" = '') then
        //             NSJobQuoteHdrArchve."NS_Salesperson Code New" := NSJobQuoteHdrArchve."NS_Salesperson Code";

        //         if (NSJobQuoteHdrArchve."NS_Job Posting Group" <> '') and (NSJobQuoteHdrArchve."NS_Job Posting Group New" = '') then //PRJ-993.AS.1.0
        //             NSJobQuoteHdrArchve."NS_Job Posting Group New" := NSJobQuoteHdrArchve."NS_Job Posting Group";//PRJ-993.AS.1.0

        //         NSJobQuoteHdrArchve.Modify();
        //     until NSJobQuoteHdrArchve.Next() = 0;
        //PE-277.NC.1.0 27Mar2024 End Block
        //PRJ-867.AS.1.0 - end
        //PE-300.JS.1.0 - Start
        NSJobQuoteHdr.Reset();
        NSJobQuoteHdr.Setrange("NS_Status Updated", false);
        if NSJobQuoteHdr.FindSet() then begin
            NSJobQuoteHdr.modifyAll("NS_Quote Status", NSJobQuoteHdr.NS_Status);
            NSJobQuoteHdr.modifyAll("NS_Status Updated", true);

        end;


        NSJobQuoteHdr.Reset();
        NSJobQuoteHdr.Setrange("NS_Updated Prob. To Close", false);
        if NSJobQuoteHdr.FindSet() then begin
            NSJobQuoteHdr.ModifyAll("NS_QuotePro to Close", NSJobQuoteHdr."NS_Probability to Close");
            NSJobQuoteHdr.modifyAll("NS_Updated Prob. To Close", true);
        end;
        //PE-300.JS.1.0 - End

        //PRJ-831.AS.2.0 13OCT2021 - start

        //PRJCTPR-298.JS.1.0 16JAN2024 - Start
        // if NSJobs.FindSet() then
        //     repeat
        //         if (NSJobs."NS_Gen. Bus. Posting Group" <> '') and (NSJobs."NS_Gen. Bus. Posting Group New" = '') then
        //             NSJobs."NS_Gen. Bus. Posting Group New" := NSJobs."NS_Gen. Bus. Posting Group";

        //         if (NSJobs."NS_Gen. Prod. Posting Group" <> '') and (NSJobs."NS_Gen. Prod. Posting Group New" = '') then
        //             NSJobs."NS_Gen. Prod. Posting Group New" := NSJobs."NS_Gen. Prod. Posting Group";
        //         NSJobs.Modify();
        //     until NSJobs.Next() = 0;


        NSJobs.Reset();
        NSJobs.SetFilter("NS_Gen. Bus. Posting Group", '<>%1', '');
        NSJobs.SetFilter("NS_Gen. Bus. Posting Group New", '%1', '');
        if NSJobs.FindSet() then
            NSJobs.ModifyAll("NS_Gen. Bus. Posting Group New", NSJobs."NS_Gen. Bus. Posting Group");

        NSJobs.Reset();
        NSJobs.SetFilter("NS_Gen. Prod. Posting Group", '<>%1', '');
        NSJobs.SetFilter("NS_Gen. Prod. Posting Group New", '%1', '');
        if NSJobs.FindSet() then
            NSJobs.ModifyAll("NS_Gen. Prod. Posting Group New", NSJobs."NS_Gen. Prod. Posting Group");


        //PRJCTPR-298.JS.1.0 16JAN2024 - Start
        // NSJobs.Reset();
        // NSJobs.SetFilter("NS_Job Type", '<>%1', '');
        // NSJobs.SetFilter("NS_Job Type New", '%1', '');
        // if NSJobs.FindSet() then
        //     NSJobs.ModifyAll("NS_Job Type New", NSJobs."NS_Job Type");

        // NSJobs.Reset();
        // NSJobs.SetFilter("NS_Tax Group Code", '<>%1', '');
        // NSJobs.SetFilter("NS_Tax Group Code New", '%1', '');
        // if NSJobs.FindSet() then
        //     NSJobs.ModifyAll("NS_Tax Group Code New", NSJobs."NS_Tax Group Code");
        //PRJCTPR-298.JS.1.0 16JAN2024 - end
        //PRJCTPR-298.JS COMMENT END
        //PE-277.NC.1.0 27Mar2024 Start Block
        // if NSLockJobPlaningLine.FindSet() then
        //     repeat
        //         if (NSLockJobPlaningLine."NS_Gen. Bus. Posting Group" <> '') and (NSLockJobPlaningLine."NS_Gen. Bus. Posting Group New" = '') then
        //             NSLockJobPlaningLine."NS_Gen. Bus. Posting Group New" := NSLockJobPlaningLine."NS_Gen. Bus. Posting Group";

        //         if (NSLockJobPlaningLine."NS_Gen. Prod. Posting Group" <> '') and (NSLockJobPlaningLine."NS_Gen. Prod. Posting Group New" = '') then
        //             NSLockJobPlaningLine."NS_Gen. Prod. Posting Group New" := NSLockJobPlaningLine."NS_Gen. Prod. Posting Group";
        //         NSLockJobPlaningLine.Modify();
        //     until NSLockJobPlaningLine.Next() = 0;


        // if NSJLEReportBuffer.FindSet() then
        //     repeat
        //         if (NSJLEReportBuffer."NS_Gen. Bus. Posting Group" <> '') and (NSJLEReportBuffer."NS_Gen. Bus. Posting Group New" = '') then
        //             NSJLEReportBuffer."NS_Gen. Bus. Posting Group New" := NSJLEReportBuffer."NS_Gen. Bus. Posting Group";

        //         if (NSJLEReportBuffer."NS_Gen. Prod. Posting Group" <> '') and (NSJLEReportBuffer."NS_Gen. Prod. Posting Group New" = '') then
        //             NSJLEReportBuffer."NS_Gen. Prod. Posting Group New" := NSJLEReportBuffer."NS_Gen. Prod. Posting Group";
        //         NSJLEReportBuffer.Modify();
        //     until NSJLEReportBuffer.Next() = 0;
        //PE-277.NC.1.0 27Mar2024 End Block
        //PRJ-831.AS.2.0 13OCT2021 - end

        //PRJ-1074.AS.1.0 28DEC2021 - Start
        //PE-277.NC.1.0 27Mar2024 Start Block
        // if NSTimesheetLineRec.FindSet() then
        //     repeat
        //         if (NSTimesheetLineRec."NS_Resource Name" <> '') and (NSTimesheetLineRec."NS_Resource Name New" = '') then
        //             NSTimesheetLineRec."NS_Resource Name New" := NSTimesheetLineRec."NS_Resource Name";
        //         NSTimesheetLineRec.Modify();
        //     until NSTimesheetLineRec.Next() = 0;

        // if NSTimesheetLineStd.FindSet() then
        //     repeat
        //         if (NSTimesheetLineStd."NS_Resource Name" <> '') and (NSTimesheetLineStd."NS_Resource Name New" = '') then
        //             NSTimesheetLineStd."NS_Resource Name New" := NSTimesheetLineStd."NS_Resource Name";
        //         NSTimesheetLineStd.Modify();
        //     until NSTimesheetLineStd.Next() = 0;

        // if TsheetHdr.FindSet() then
        //     repeat
        //         //PRJ-1258.JS.1.0 23MAR2022 - Start
        //         if ((TsheetHdr."NS_Resource Name" <> '') and (TsheetHdr."NS_Resource Name New" = '')) then begin
        //             TsheetHdr."NS_Resource Name New" := TsheetHdr."NS_Resource Name";
        //             TsheetHdr.Modify();
        //         end;
        //     //PRJ-1258.JS.1.0 23MAR2022 - end
        //     until TsheetHdr.Next() = 0;

        // if TsheetLineArchve.FindSet() then
        //     repeat
        //         //PRJ-1258.JS.1.0 23MAR2022 - start
        //         if ((TsheetLineArchve."NS_Resource Name" <> '') and (TsheetLineArchve."NS_Resource Name New" = '')) then begin
        //             TsheetLineArchve."NS_Resource Name New" := TsheetLineArchve."NS_Resource Name";
        //             TsheetLineArchve.Modify();
        //         end;
        //     //PRJ-1258.JS.1.0 23MAR2022 - end
        //     until TsheetLineArchve.Next() = 0;
        //PE-277.NC.1.0 27Mar2024 End Block
        //PRJ-1074.AS.1.0 28DEC2021 - End

        //PRJ-1221.AS.1.0 25FEB2022 START
        PurchLineRec.Reset();
        if PurchLineRec.FindSet() then
            repeat
                //PRJ-1258.JS.1.0 23MAR2022 - start
                if ((PurchLineRec."Cross-Reference No." <> '') and (PurchLineRec."Item Reference No." = '')) then begin
                    PurchLineRec."Item Reference No." := PurchLineRec."Cross-Reference No.";
                    PurchLineRec.Modify();
                end;
            //PRJ-1258.JS.1.0 23MAR2022 - end
            until PurchLineRec.Next() = 0;
        //PRJ-1221.AS.1.0 25FEB2022 END

        //PRJ-1221.AS.1.0 25FEB2022 START
        SalesLineRec.Reset();
        if SalesLineRec.FindSet() then
            repeat
                //PRJ-1258.JS.1.0 23MAR2022 - start
                if ((SalesLineRec."Cross-Reference No." <> '') and (SalesLineRec."Item Reference No." = '')) then begin
                    SalesLineRec."Item Reference No." := SalesLineRec."Cross-Reference No.";
                    SalesLineRec.Modify();
                end;
            //PRJ-1258.JS.1.0 23MAR2022 - end
            until SalesLineRec.Next() = 0;
        //PRJ-1221.AS.1.0 25FEB2022 END

        //PRJ-1264.AS.1.0 start
        //PE-317 AT.1.0 25June2024 Start //Below commanted code move on Report 14021485 "NS_Unit Cost Prod report"
        /*
        //PE-277.NC.1.0 27Mar2024 Start Block
        // jtasklines.Reset();
        // if jtasklines.FindSet() then
        //     repeat
        //         // Clear(Activity);
        //         // Clear(NProcess);
        //         // Clear(Operation);
        //         // Clear(Section);
        //         NJob.NS_JobTaskNoToAPo(jtasklines."Job Task No.", Activity, NProcess, Operation, Section);//PRJ-1264.AS.1.0            
        //         IF JobActivity.GET(JobActivity.NS_Type::Cost, Activity) THEN;
        //         IF JobProcess.GET(JobProcess.NS_Type::Cost, Activity, NProcess) THEN;
        //         IF JobOperation.get(JobOperation.NS_Type::Cost, Activity, NProcess, Operation) THEN;
        //         IF JobSection.get(JobSection.NS_Type::Cost, Activity, NProcess, Operation, Section) THEN;

        //         if NProcess <> '' then BEGIN
        //             NProcess := NProcess;
        //         end else begin
        //             NProcess := '';

        //         end;
        //         if Operation <> '' then BEGIN
        //             Operation := Operation;
        //         end else BEGIN
        //             Operation := '';
        //         end;

        //         if Section <> '' then BEGIN
        //             Section := Section;
        //         end else BEGIN
        //             Section := '';
        //         end;

        //         jtasklines.NS_Act := Activity;
        //         jtasklines.NS_Proc := NProcess;
        //         jtasklines.NS_Opr := Operation;
        //         jtasklines.NS_Sec := Section;
        //         jtasklines.Modify();
        //     until jtasklines.Next() = 0;
        //PE-277.NC.1.0 27Mar2024 End Block
        //PE-317 AT.1.0 25June2024 End
         */
        //PRJ-1264.AS.1.0 end
        //PRJ-1420.NK.1.0 30May2022 Start
        LockJobPlaningLine.Reset();
        LockJobPlaningLine.SetFilter(NS_Description, '<>%1', '');
        if LockJobPlaningLine.FindSet() then
            repeat
                if LockJobPlaningLine.NS_DescriptionNew = '' then begin
                    LockJobPlaningLine.NS_DescriptionNew := LockJobPlaningLine.NS_Description;
                    LockJobPlaningLine.Modify();
                end;
            until LockJobPlaningLine.Next() = 0;
        //PRJ-1420.NK.1.0 30May2022 End
        //PRJ-1623.GK.1.0 08Sept2022 start
        NSProgressPaymentLine.Reset();
        NSProgressPaymentLine.SetFilter("NS_No. Description New", '%1', ''); //PRJCTPR-137.NK.1.0 21Jun2023
        if NSProgressPaymentLine.FindSet() then
            repeat
                NSProgressPaymentLine."NS_No. Description New" := NSProgressPaymentLine."NS_No. Description";
                //NSProgressPaymentLine."NS_Task Description New" := NSProgressPaymentLine."NS_Task Description"; //PRJCTPR-137.NK.1.0 21Jun2023 Block
                NSProgressPaymentLine.Modify();
            until NSProgressPaymentLine.Next() = 0;
        //PRJCTPR-137.NK.1.0 21Jun2023 Start
        NSProgressPaymentLine.Reset();
        NSProgressPaymentLine.SetFilter("NS_Task Description New", '%1', '');
        if NSProgressPaymentLine.FindSet() then
            repeat
                NSProgressPaymentLine."NS_Task Description New" := NSProgressPaymentLine."NS_Task Description";
                NSProgressPaymentLine.Modify();
            until NSProgressPaymentLine.Next() = 0;
        //PRJCTPR-137.NK.1.0 21Jun2023 End
        //PRJ-1623.GK.1.0 08Sept2022 end


        //PRJ-1684.AS.1.0 START
        IF JobSetupRec.Get() then begin
            if (JobSetupRec."NS_Prog. Bill Gen. ProdPostGr." <> '') and (JobSetupRec."NS_ProgBillGenProdPostGr New" = '') then
                JobSetupRec."NS_ProgBillGenProdPostGr New" := JobSetupRec."NS_Prog. Bill Gen. ProdPostGr.";

            //PE-233.AS.1.0 ADD START
            if (JobSetupRec."NS_Prog Pay Gen. Prod. PostGr." <> '') and (JobSetupRec."NS_Prog Pay Gen.ProdPostGr.New" = '') then
                JobSetupRec."NS_Prog Pay Gen.ProdPostGr.New" := JobSetupRec."NS_Prog Pay Gen. Prod. PostGr.";
            //PE-233.AS.1.0 ADD END
            JobSetupRec.Modify();
        end;
        //PRJ-1684.AS.1.0 END

        //PE-68.Dk.1.0 10April2023 Start
        ResourcePrice.Reset();
        if ResourcePrice.FindSet() then begin
            repeat
                if ResourcePrice."NS_Skill Class Code" <> '' then begin
                    ResourcePrice."NS_Skill Class Code New" := ResourcePrice."NS_Skill Class Code";
                    ResourcePrice.Modify();
                end;
            until ResourcePrice.Next() = 0;
        end;
        JobLedgerEntry.Reset();
        if JobLedgerEntry.FindSet() then begin
            repeat
                if JobLedgerEntry."NS_Skill Class" <> '' then begin
                    JobLedgerEntry."NS_Skill Class New" := JobLedgerEntry."NS_Skill Class";
                    JobLedgerEntry.Modify();
                end;
                if JobLedgerEntry."NS_Skill Code" <> '' then begin
                    JobLedgerEntry."NS_Skill Code New" := JobLedgerEntry."NS_Skill Code";
                    JobLedgerEntry.Modify();
                end;
            until JobLedgerEntry.Next() = 0;
        end;
        NSTimesheetLineStd.Reset();
        if NSTimesheetLineStd.FindSet() then begin
            repeat
                if NSTimesheetLineStd."NS_Skill Class" <> '' then begin
                    NSTimesheetLineStd."NS_Skill Class New" := NSTimesheetLineStd."NS_Skill Class";
                end;
                if NSTimesheetLineStd."NS_Skill Code" <> '' then begin
                    NSTimesheetLineStd."NS_Skill Code New" := NSTimesheetLineStd."NS_Skill Code";
                end;
            until NSTimesheetLineStd.Next() = 0;
            NSTimesheetLineStd.Modify();
        end;
        TimeSheetDetail.Reset();
        if TimeSheetDetail.FindSet() then begin
            repeat
                if TimeSheetDetail."NS_Skill Code" <> '' then begin
                    TimeSheetDetail."NS_Skill Code New" := TimeSheetDetail."NS_Skill Code";
                    TimeSheetDetail.Modify();
                end;
            until TimeSheetDetail.Next() = 0;
        end;
        JobJournalLine.Reset();
        if JobJournalLine.FindSet() then begin
            repeat
                if JobJournalLine."NS_Skill Class" <> '' then
                    JobJournalLine."NS_Skill Class New" := JobJournalLine."NS_Skill Class";
                if JobJournalLine."NS_Skill Code" <> '' then
                    JobJournalLine."NS_Skill Code New" := JobJournalLine."NS_Skill Code";
            until JobJournalLine.Next() = 0;
            JobJournalLine.Modify();
        end;
        NS_TimeSheetLineCustom.Reset();
        if NS_TimeSheetLineCustom.FindSet() then begin
            repeat
                if NS_TimeSheetLineCustom."NS_Skill Code" <> '' then begin
                    NS_TimeSheetLineCustom."NS_Skill Code New" := NS_TimeSheetLineCustom."NS_Skill Code";
                    NS_TimeSheetLineCustom.Modify();
                end
            until NS_TimeSheetLineCustom.Next() = 0;
        end;
        NSEmployeeWageRate.Reset();
        if NSEmployeeWageRate.FindSet() then begin
            repeat
                if NSEmployeeWageRate."NS_Skill Class" <> '' then begin
                    NSEmployeeWageRate."NS_Skill Class New" := NSEmployeeWageRate."NS_Skill Class";
                    NSEmployeeWageRate.Modify();
                end;
            until NSEmployeeWageRate.Next() = 0;
        end;
        NSTimeSheetLineCustom.Reset();
        if NSTimeSheetLineCustom.FindSet() then begin
            repeat
                if NSTimeSheetLineCustom."NS_Skill Code" <> '' then begin
                    NSTimeSheetLineCustom."NS_Skill Code New" := NSTimeSheetLineCustom."NS_Skill Code";
                    NSTimeSheetLineCustom.Modify();
                end;
            until NSTimeSheetLineCustom.Next() = 0;
        end;
        //PE-86.NC.1.0 10Aug2023 End
        //PE-317 AT.1.0 25June2024 Start //Below Commented code move to Field Manger Role Center Page Under the action Update Field Manager's button 
        //PE-211.AS start
        /*
        PHorder.Reset();
        PHorder.SetFilter("NS_Job No.", '<>%1', '');
        if PHorder.FindSet() then
            repeat
                if jbrec.get(PHorder."NS_Job No.") then begin
                    PHorder."NS_Field Manager" := jbrec."NS_Field Manager";
                    PHorder.Modify();
                end;
            until PHorder.Next() = 0;

        PosCrMemo.Reset();
        PosCrMemo.SetFilter("NS_Job No.", '<>%1', '');
        if PosCrMemo.FindSet() then
            repeat
                if jbrec.get(PosCrMemo."NS_Job No.") then begin
                    PosCrMemo."NS_Field Manager" := jbrec."NS_Field Manager";
                    PosCrMemo.Modify();
                end;
            until PosCrMemo.Next() = 0;

        PosInv.Reset();
        PosInv.SetFilter("NS_Job No.", '<>%1', '');
        if PosInv.FindSet() then
            repeat
                if jbrec.get(PosInv."NS_Job No.") then begin
                    PosInv."NS_Field Manager" := jbrec."NS_Field Manager";
                    PosInv.Modify();
                end;
            until PosInv.Next() = 0;

        dailyjbrec.Reset();
        dailyjbrec.SetFilter("NS_Job No.", '<>%1', '');
        if dailyjbrec.FindSet() then
            repeat
                if jbrec.get(dailyjbrec."NS_Job No.") then begin
                    dailyjbrec."NS_Field Manager" := jbrec."NS_Field Manager";
                    dailyjbrec.Modify();
                end;
            until dailyjbrec.Next() = 0;

        TSlineCustom.Reset();
        TSlineCustom.SetFilter("NS_Job No.", '<>%1', '');
        if TSlineCustom.FindSet() then
            repeat
                if jbrec.get(TSlineCustom."NS_Job No.") then begin
                    TSlineCustom."NS_Field Manager" := jbrec."NS_Field Manager";
                    TSlineCustom.Modify();
                end;
            until TSlineCustom.Next() = 0;

        PBhdr.Reset();
        PBhdr.SetFilter("NS_Job No.", '<>%1', '');
        if PBhdr.FindSet() then
            repeat
                if jbrec.get(PBhdr."NS_Job No.") then begin
                    PBhdr."NS_Field Manager" := jbrec."NS_Field Manager";
                    PBhdr.Modify();
                end;
            until PBhdr.Next() = 0;

        subcon.Reset();
        subcon.SetFilter("NS_Job No.", '<>%1', '');
        if subcon.FindSet() then
            repeat
                if jbrec.get(subcon."NS_Job No.") then begin
                    subcon."NS_Field Manager" := jbrec."NS_Field Manager";
                    subcon.Modify();
                end;
            until subcon.Next() = 0;
        //PE-211.AS end
        */
    end;
    //PE-317 AT.1.0 25June2024 End
    //  end;

}