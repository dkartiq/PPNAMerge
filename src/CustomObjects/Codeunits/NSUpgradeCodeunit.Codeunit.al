codeunit 14021315 NS_UpgradeCodeunit
{
    //PRJ-867.AS.1.0 New Upgrade codeunit to transfer field Sales person code data to field Sales person code New in tables Job Quote Header, Job Quote Header Archive 
    Subtype = Upgrade;


    trigger OnUpgradePerCompany()
    var
        NSJobQuoteHdr: Record "NS_Job Quote Header";//PRJ-867.AS.1.0
        NSJobQuoteHdrArchve: Record "NS_Job Quote Header Archive";//PRJ-867.AS.1.0
        NSJLEReportBuffer: Record "NS_Job LedgerEntryReportBuffer";//PRJ-831.AS.2.0 13OCT2021
        NSLockJobPlaningLine: Record "NS_Locked Job Planning Line";//PRJ-831.AS.2.0 13OCT2021
        NSJobs: Record Job;//PRJ-831.AS.2.0 13OCT2021
    begin
        // Code to perform company related table upgrade tasks
        //PRJ-867.AS.1.0 - start
        if NSJobQuoteHdr.FindSet() then
            repeat
                if (NSJobQuoteHdr."NS_Salesperson Code" <> '') and (NSJobQuoteHdr."NS_Salesperson Code New" = '') then
                    NSJobQuoteHdr."NS_Salesperson Code New" := NSJobQuoteHdr."NS_Salesperson Code";

                if (NSJobQuoteHdr."NS_Job Posting Group" <> '') and (NSJobQuoteHdr."NS_Job Posting Group New" = '') then //PRJ-993.AS.1.0
                    NSJobQuoteHdr."NS_Job Posting Group New" := NSJobQuoteHdr."NS_Job Posting Group";//PRJ-993.AS.1.0

                NSJobQuoteHdr.Modify();
            until NSJobQuoteHdr.Next() = 0;

        if NSJobQuoteHdrArchve.FindSet() then
            repeat
                if (NSJobQuoteHdrArchve."NS_Salesperson Code" <> '') and (NSJobQuoteHdrArchve."NS_Salesperson Code New" = '') then
                    NSJobQuoteHdrArchve."NS_Salesperson Code New" := NSJobQuoteHdrArchve."NS_Salesperson Code";

                if (NSJobQuoteHdrArchve."NS_Job Posting Group" <> '') and (NSJobQuoteHdrArchve."NS_Job Posting Group New" = '') then //PRJ-993.AS.1.0
                    NSJobQuoteHdrArchve."NS_Job Posting Group New" := NSJobQuoteHdrArchve."NS_Job Posting Group";//PRJ-993.AS.1.0

                NSJobQuoteHdrArchve.Modify();
            until NSJobQuoteHdrArchve.Next() = 0;
        //PRJ-867.AS.1.0 - end


        //PRJ-831.AS.2.0 13OCT2021 - start
        if NSJobs.FindSet() then
            repeat
                if (NSJobs."NS_Gen. Bus. Posting Group" <> '') and (NSJobs."NS_Gen. Bus. Posting Group New" = '') then
                    NSJobs."NS_Gen. Bus. Posting Group New" := NSJobs."NS_Gen. Bus. Posting Group";

                if (NSJobs."NS_Gen. Prod. Posting Group" <> '') and (NSJobs."NS_Gen. Prod. Posting Group New" = '') then
                    NSJobs."NS_Gen. Prod. Posting Group New" := NSJobs."NS_Gen. Prod. Posting Group";
                NSJobs.Modify();
            until NSJobs.Next() = 0;


        if NSLockJobPlaningLine.FindSet() then
            repeat
                if (NSLockJobPlaningLine."NS_Gen. Bus. Posting Group" <> '') and (NSLockJobPlaningLine."NS_Gen. Bus. Posting Group New" = '') then
                    NSLockJobPlaningLine."NS_Gen. Bus. Posting Group New" := NSLockJobPlaningLine."NS_Gen. Bus. Posting Group";

                if (NSLockJobPlaningLine."NS_Gen. Prod. Posting Group" <> '') and (NSLockJobPlaningLine."NS_Gen. Prod. Posting Group New" = '') then
                    NSLockJobPlaningLine."NS_Gen. Prod. Posting Group New" := NSLockJobPlaningLine."NS_Gen. Prod. Posting Group";
                NSLockJobPlaningLine.Modify();
            until NSLockJobPlaningLine.Next() = 0;


        if NSJLEReportBuffer.FindSet() then
            repeat
                if (NSJLEReportBuffer."NS_Gen. Bus. Posting Group" <> '') and (NSJLEReportBuffer."NS_Gen. Bus. Posting Group New" = '') then
                    NSJLEReportBuffer."NS_Gen. Bus. Posting Group New" := NSJLEReportBuffer."NS_Gen. Bus. Posting Group";

                if (NSJLEReportBuffer."NS_Gen. Prod. Posting Group" <> '') and (NSJLEReportBuffer."NS_Gen. Prod. Posting Group New" = '') then
                    NSJLEReportBuffer."NS_Gen. Prod. Posting Group New" := NSJLEReportBuffer."NS_Gen. Prod. Posting Group";
                NSJLEReportBuffer.Modify();
            until NSJLEReportBuffer.Next() = 0;
        //PRJ-831.AS.2.0 13OCT2021 - end

    end;

}