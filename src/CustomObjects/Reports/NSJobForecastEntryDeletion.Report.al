report 14021389 "NS_Job Forecast Entry Deletion"
////CTSI-203.AM.1.0 Create new report
/// PRJ-547.N.S.1.0  Add confirm message to delete the Forecast entry
//PRJ-659.RS.1.0 1July21 | NS_�should�be�removed�from�every�page�rest�mention�the�page�ID�and�Name.
//PRJ.1039.JS.1.0 14Dec2021 | Add Code to delete sublevel jobs

{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Job Forecast Entry Deletion';//PRJ-659.RS.1.0 1July21 Caption Added

    dataset
    {
        dataitem(Job; Job)
        {

            DataItemTableView = SORTING("No.") ORDER(Ascending);
            RequestFilterFields = "No.", "NS_Gen. Bus. Posting Group New", NS_Manager;//PRJ-831.AS.1.0 12OCT2021 Replaced Job Table field Gen Bus Posting Grp with Gen Bus Posting Grp New
            dataitem("NS_Job Forecast"; "NS_Job Forecast")
            {
                DataItemTableView = SORTING("NS_Job No.");
                DataItemLink = "NS_Job No." = field("No.");
                trigger OnAfterGetRecord()
                var
                    NSJobTaskRec: Record "Job Task";  //PE-287.JS.1.0 07MAY2024 
                    NSRevRecSummDetailEntry: Record NS_RevenueRecSummaryTab;   //PE-295.JS.1.0 12JUN2024                   
                begin
                    //PE-295.JS.1.0 12JUN2024-Start
                    Clear(NSNoofRevRecPostedEntries);
                    if NSUserSetup.get(UserId) then;
                    NSNoofRevRecPostedEntries := NSGetRevRecPostedEntries("NS_Job Forecast"."NS_Job No.");
                    if NSNoofRevRecPostedEntries > 0 then begin
                        if Confirm(NSRecRecDeletionLabel, true, "NS_Job Forecast"."NS_Job No.") then begin
                            if Confirm('Are you sure to delete forecast and rev. rec. open entries for project no. %1? Note that deleting forecast details will not remove the posted rev. rec. entries.', true, "NS_Job Forecast"."NS_Job No.") then begin
                                if NSUserSetup."NS_Allow To Delete Rev. Rec" = false then
                                    error('You do not have access to delete the job forecast having posted Revenue Recognition entries.');
                                //PE-295.JS.1.0 12JUN2024-end
                                //PE-287.JS.1.0 07MAY2024-Start
                                NSJobTaskRec.Reset();
                                NSJobTaskRec.setrange("Job No.", "NS_Job Forecast"."NS_Job No.");
                                NSJobTaskRec.Setfilter("Job Task Type", '%1|%2', NSJobTaskRec."Job Task Type"::Posting, NSJobTaskRec."Job Task Type"::Total);
                                if NSJobTaskRec.FindSet() then begin
                                    NSJobTaskRec.ModifyAll("NS_JFW Forecast Completed Cost", 0);
                                    if NSOverrideForcstCompCostonJTL = true then
                                        NSJobTaskRec.ModifyAll(NS_ForecastedCompCostOverride, 0);
                                end;
                                //PE-287.JS.1.0 07MAY2024-end
                                NSRevRecSummDetailEntry.Reset();
                                NSRevRecSummDetailEntry.SetRange("NS_Job No.", "NS_Job Forecast"."NS_Job No.");
                                NSRevRecSummDetailEntry.SetRange(NS_Posted, false);
                                if NSRevRecSummDetailEntry.FindSet() then
                                    repeat
                                        if NSRevRecSummDetailEntry."NS_Over/Under Billings Posted" = false then
                                            NSRevRecSummDetailEntry.Delete();
                                    until NSRevRecSummDetailEntry.Next() = 0;
                                "NS_Job Forecast".DeleteAll();
                                NSRecRecDeletionConfirmBool := true;
                                //PE-295.JS.1.0 12JUN2024-Start
                            end else begin
                                NSRecRecDeletionConfirmBool := false;
                                Error('');
                            end;
                        end else begin
                            NSRecRecDeletionConfirmBool := false;
                            Error('');
                        end;
                    end else begin
                        NSJobTaskRec.Reset();
                        NSJobTaskRec.setrange("Job No.", "NS_Job Forecast"."NS_Job No.");
                        NSJobTaskRec.Setfilter("Job Task Type", '%1|%2', NSJobTaskRec."Job Task Type"::Posting, NSJobTaskRec."Job Task Type"::Total);
                        if NSJobTaskRec.FindSet() then begin
                            NSJobTaskRec.ModifyAll("NS_JFW Forecast Completed Cost", 0);
                            if NSOverrideForcstCompCostonJTL = true then
                                NSJobTaskRec.ModifyAll(NS_ForecastedCompCostOverride, 0);
                        end;
                        NSRevRecSummDetailEntry.Reset();
                        NSRevRecSummDetailEntry.SetRange("NS_Job No.", "NS_Job Forecast"."NS_Job No.");
                        if NSRevRecSummDetailEntry.FindSet() then
                            NSRevRecSummDetailEntry.DeleteAll();
                        "NS_Job Forecast".DeleteAll();
                        NSRecRecDeletionConfirmBool := true;
                    end;
                    //PE-295.JS.1.0 12JUN2024-end
                end;

            }
            //PRJ-547.AS.1.0 22FEB2021 - START
            dataitem("NS_Percentage of Completion"; "NS_Percentage of Completion")
            {
                DataItemTableView = SORTING("NS_Job No.");
                DataItemLink = "NS_Job No." = field("No.");
                trigger OnAfterGetRecord()
                var
                begin
                    "NS_Percentage of Completion".DeleteAll();
                end;

            }
            //PRJ-547.AS.1.0 22FEB2021 - END

            //PRJ-1039.JS.1.0 14Dec2021-Start
            dataitem(Integer; Integer)
            {

                DataItemTableView = where(Number = CONST(1));

                trigger OnAfterGetRecord()
                var
                    NS_Jobs: Record Job;
                    NS_jobs2: Record Job;
                    NS_jobForecast: Record "NS_Job Forecast";
                    NS_PercentOfCompletion: Record "NS_Percentage of Completion";
                    NS_SubJobFilter: Code[20];
                begin
                    if NSRecRecDeletionConfirmBool = true then begin //PE-295.JS.1.0 12JUN2024 line added
                        NS_SubJobFilter := '';
                        NS_SubJobFilter := '@*' + format(JobNumberFilter) + '*';
                        if Integer.Number = 1 then
                            If NS_Jobs.get(Job."No.") then
                                if NS_Jobs."NS_Include Sub Levels" = true then begin
                                    NS_jobs2.Reset();
                                    NS_jobs2.SetFilter("NS_Sub-Level to Job No.", '%1', NS_SubJobFilter);
                                    if NS_jobs2.FindSet() then begin
                                        NS_jobForecast.Reset();
                                        NS_jobForecast.Setrange("NS_Job No.", NS_jobs2."NS_Sub-Level to Job No.");
                                        If NS_jobForecast.FindSet() then
                                            NS_jobForecast.DeleteAll();

                                        NS_PercentOfCompletion.Reset();
                                        NS_PercentOfCompletion.SetRange("NS_Job No.", NS_jobs2."NS_Sub-Level to Job No.");
                                        IF NS_PercentOfCompletion.FindSet() then
                                            NS_PercentOfCompletion.DeleteAll();
                                    end;
                                end;
                    end; //PE-295.JS.1.0 12JUN2024 line added
                end;

            }
            //PRJ-1039.JS.1.0 14Dec2021-end

            //PRJ-1039.JS.1.0 14Dec2021-Start
            trigger OnPreDataItem()
            var
            begin
                JobNumberFilter := '';
                JobNumberFilter := Job.GetFilter(Job."No.");
            end;
            //PRJ-1039.JS.1.0 14Dec2021-end
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                //PE-287.JS.1.0 08MAY2024-Start
                group(NSForecast)
                {
                    Caption = 'Forecast';
                    field(NSOverrideForcstCompCostonJTL; NSOverrideForcstCompCostonJTL)
                    {
                        ApplicationArea = All;
                        Caption = 'Override Forecasted Completed Cost on JTL';
                        ToolTip = 'Enable this to remove the "Override Forecasted Completed Cost" values from the job task lines for selected jobs.';
                    }
                }
                //PE-287.JS.1.0 08MAY2024-end
            }
        }


        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    trigger OnPostReport()
    var
    begin
        if Confirmbool = true then
            Message('"Job Forecast Entries", "Project Summary Details" & "Revenue Recognition Summary Details" entries have been deleted'); //PRJ-547.AS.1.0 22FEB2021 //PE-295.JS.1.0 12JUN2024
    end;

    //PRJ-547.AS.1.0 22FEB2021 - start
    trigger OnPreReport()
    var
    begin
        if not CONFIRM('Do you want to delete Job Forecast Entries, Project Summary Details, and Rev. Rec. Summary Details?', true) then begin
            Confirmbool := false;
            //exit;  //PE-295.JS.1.0 13JUN2024 line commited
            Error('');  //PE-295.JS.1.0 13JUN2024 line added
        end
        else
            Confirmbool := true;
    end;
    //PRJ-547.AS.1.0 22FEB2021 - end

    //PE-287.JS.1.0 08MAY2024-Start
    trigger OnInitReport()
    begin
        NSOverrideForcstCompCostonJTL := false;
    end;
    //PE-287.JS.1.0 08MAY2024-end

    var
        myInt: Integer;
        NSUserSetup: Record "User Setup"; //PE-295.JS.1.0 12JUN2024
        Confirmbool: Boolean;
        JobNumberFilter: Code[20];    //PRJ-1039.JS.1.0  14Dec2021
        NSOverrideForcstCompCostonJTL: Boolean; //PE-287.JS.1.0 08MAY2024
        NSNoofRevRecPostedEntries: Integer; //PE-287.JS.1.0 08MAY2024
        NSRecRecDeletionConfirmBool: Boolean; //PE-295.JS.1.0 12JUN2024
        NSRecRecDeletionLabel: Label 'Project %1 has related posted revenue recognition summary details. Do you still want to remove the forecast details for the same? Note that deleting forecast details will not remove the posted rev. rec. entries.'; //PE-295.JS.1.0 12JUN2024

    local procedure NSGetRevRecPostedEntries(NSJobNo: code[20]) NSRecRecNoOfEntries: Integer
    var
        NSRevRecSummaryDetails: Record "NS_RevenueRecSummaryTab";  //PE-295.JS.1.0 12JUN2024 
    begin
        clear(NSRecRecNoOfEntries);
        NSRevRecSummaryDetails.Reset();
        NSRevRecSummaryDetails.SetRange("NS_Job No.", NSJobNo);
        NSRevRecSummaryDetails.SetRange(NS_Posted, true);
        if NSRevRecSummaryDetails.FindSet() then
            NSRecRecNoOfEntries := NSRevRecSummaryDetails.Count();

        NSRevRecSummaryDetails.Reset();
        NSRevRecSummaryDetails.SetRange("NS_Job No.", NSJobNo);
        NSRevRecSummaryDetails.SetRange("NS_Over/Under Billings Posted", true);
        if NSRevRecSummaryDetails.FindSet() then
            NSRecRecNoOfEntries := NSRecRecNoOfEntries + NSRevRecSummaryDetails.Count();

        exit(NSRecRecNoOfEntries);
    end;
}