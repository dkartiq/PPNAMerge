/// <summary>
/// Page NS_Job Task All Levels List (ID 14021333).
/// </summary>
page 14021334 "NS_Job Task All Levels List1"
{
    //PRJ-1184.JS.1.0 New Page
    //PRJ-1493.AS.1.0 Added this new page with all none of use code remove from page 14021333 "NS_Job Task All Levels List"
    PageType = List;
    Caption = 'Job Tasks All Levels';
    DataCaptionFields = "Job No.";
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Job Task";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Job Task No."; Rec."Job Task No.")
                {
                    ToolTip = 'Specifies the number of the related job task.';
                    ApplicationArea = Jobs;
                    Style = Strong;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a description of the job task. You can enter anything that is meaningful in describing the task. The description is copied and used in descriptions on the job planning line.';
                }
                field("Job Task Type"; Rec."Job Task Type")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the purpose of the account. Newly created accounts are automatically assigned the Posting account type, but you can change this. Choose the field to select one of the following five options:';
                }
                field(Totaling; Rec.Totaling)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies an interval or a list of job task numbers.';
                }
                field("Schedule (Total Cost)"; Rec."Schedule (Total Cost)")
                {
                    //PRJCTPR-11.GK.1.0 20Apr2023 start
                    //Caption = 'Budget';
                    Caption = 'Budget, Job Level';
                    //PRJCTPR-11.GK.1.0 20Apr2023 end
                    Editable = false;
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies, in the local currency, the total budgeted cost for the job task during the time period in the Planning Date Filter field.';
                }
                field("Change Orders"; Rec."NS_Change Orders")
                {
                    //PRJCTPR-11.GK.1.0 20Apr2023 start
                    //Caption = 'Budget Sub Levels';
                    Caption = 'Budget, SubLevel';
                    //PRJCTPR-11.GK.1.0 20Apr2023 end
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Change Orders';
                    trigger OnDrillDown()
                    var
                        JobNo: Text[2048];
                        StrLength: Integer;
                    begin
                        Clear(JobNo);
                        Clear(JobNoFilter);
                        JobNoFilter := '@*' + format(Rec."Job No.") + '*';
                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);//PRJCTPR-11.GK.1.0 20Apr2023
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);//PRJCTPR-11.GK.1.0 20Apr2023
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);//PRJCTPR-11.GK.1.0 20Apr2023
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);//PRJCTPR-11.GK.1.0 20Apr2023
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        IF JobNo <> '' then
                            if Rec."Job Task Type" = rec."Job Task Type"::Posting then begin
                                StrLength := StrLen(JobNo);
                                JobNo := CopyStr(JobNo, 1, StrLength - 1);

                                JobPlanningLineRec.Reset();
                                JobPlanningLineRec.SetFilter("Job No.", JobNo);
                                JobPlanningLineRec.SetRange("Job Task No.", Rec."Job Task No.");//PRJCTPR-398 AT.01 29June2024
                                JobPlanningLineRec.SetFilter("Line Type", '%1..%2', JobPlanningLineRec."Line Type"::Budget, JobPlanningLineRec."Line Type"::"Both Budget and Billable");
                                JobPlanningLineRec.setrange("Schedule Line", true);
                                if JobPlanningLineRec.FindSet() then
                                    Page.Run(Page::"Job Planning Lines", JobPlanningLineRec);
                            end else
                                if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
                                    StrLength := StrLen(JobNo);
                                    JobNo := CopyStr(JobNo, 1, StrLength - 1);

                                    JobPlanningLineRec.Reset();
                                    JobPlanningLineRec.SetFilter("Job No.", JobNo);
                                    JobPlanningLineRec.SetRange("Job Task No.", Rec."Job Task No.");//PRJCTPR-398 AT.01 29June2024
                                    JobPlanningLineRec.SetFilter("Line Type", '%1..%2', JobPlanningLineRec."Line Type"::Budget, JobPlanningLineRec."Line Type"::"Both Budget and Billable");
                                    JobPlanningLineRec.setrange("Schedule Line", true);
                                    JobPlanningLineRec.SetFilter("Job Task No.", Rec.Totaling);
                                    if JobPlanningLineRec.FindSet() then
                                        Page.Run(Page::"Job Planning Lines", JobPlanningLineRec);
                                end else
                                    if (Rec."Job Task Type" = rec."Job Task Type"::Total) then begin
                                        StrLength := StrLen(JobNo);
                                        JobNo := CopyStr(JobNo, 1, StrLength - 1);

                                        JobPlanningLineRec.Reset();
                                        JobPlanningLineRec.SetFilter("Job No.", JobNo);
                                        JobPlanningLineRec.SetFilter("Job Task No.", Rec.Totaling);//Prjctpr-398 AT 01.03July2024
                                        JobPlanningLineRec.SetFilter("Line Type", '%1..%2', JobPlanningLineRec."Line Type"::Budget, JobPlanningLineRec."Line Type"::"Both Budget and Billable");
                                        JobPlanningLineRec.setrange("Schedule Line", true);
                                        if JobPlanningLineRec.FindSet() then
                                            Page.Run(Page::"Job Planning Lines", JobPlanningLineRec);
                                    end;
                    end;


                }
                field("Net Budget"; Rec."NS_Net Budget")
                {
                    //PRJCTPR-11.GK.1.0 20Apr2023 start
                    //Caption = 'Net Budget';
                    Caption = 'Budget, Total';
                    //PRJCTPR-11.GK.1.0 20Apr2023 end
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Net Budget';

                }

                field("Usage (Total Cost)"; Rec."Usage (Total Cost)")
                {
                    //PRJCTPR-11.GK.1.0 20Apr2023 start
                    //Caption = 'Actual Cost';
                    Caption = 'Actual, Job Level';
                    //PRJCTPR-11.GK.1.0 20Apr2023 end
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Usage (Total Cost)';
                }
                field("NS_Usage TotCost SubLevel"; rec."NS_Usage TotCost Change Order")
                {
                    //PRJCTPR-11.GK.1.0 20Apr2023 start
                    //Caption = 'Sub Level (Actual Cost)';
                    Caption = 'Actual, SubLevel ';
                    //PRJCTPR-11.GK.1.0 20Apr2023 end
                    Editable = false;
                    ToolTip = 'Specifies the value of the Usage (Total Cost) Sub levels field.';
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        NSJobLedgerEntry: Record "Job Ledger Entry";
                        JobNo: Text[2048];
                        StrLength: Integer;
                    begin
                        Clear(JobNo);
                        Clear(JobNoFilter);
                        JobNoFilter := '@*' + format(Rec."Job No.") + '*';
                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);//PRJCTPR-11.GK.1.0 20Apr2023
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);//PRJCTPR-11.GK.1.0 20Apr2023
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);//PRJCTPR-11.GK.1.0 20Apr2023
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);//PRJCTPR-11.GK.1.0 20Apr2023
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        IF JobNo <> '' then
                            if (rec."Job Task Type" = rec."Job Task Type"::Posting) then begin
                                StrLength := StrLen(JobNo);
                                JobNo := CopyStr(JobNo, 1, StrLength - 1);

                                NSJobLedgerEntry.Reset();
                                NSJobLedgerEntry.SetFilter("Job No.", JobNo);
                                NSJobLedgerEntry.SetFilter("Job Task No.", '%1', Rec."Job Task No.");
                                NSJobLedgerEntry.SetFilter("Entry Type", '%1', NSJobLedgerEntry."Entry Type"::Usage);
                                NSJobLedgerEntry.SetFilter(quantity, '<>%1', 0);
                                if NSJobLedgerEntry.FindSet() then
                                    Page.Run(Page::"Job Ledger Entries", NSJobLedgerEntry);
                            end else
                                if (rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
                                    StrLength := StrLen(JobNo);
                                    JobNo := CopyStr(JobNo, 1, StrLength - 1);
                                    NSJobLedgerEntry.Reset();
                                    NSJobLedgerEntry.SetFilter("Job No.", JobNo);
                                    NSJobLedgerEntry.SetFilter("Entry Type", '%1', NSJobLedgerEntry."Entry Type"::Usage);
                                    NSJobLedgerEntry.SetFilter("Job Task No.", Rec.Totaling);
                                    NSJobLedgerEntry.SetFilter(quantity, '<>%1', 0);
                                    if NSJobLedgerEntry.FindSet() then
                                        Page.Run(Page::"Job Ledger Entries", NSJobLedgerEntry);
                                end else
                                    if (rec."Job Task Type" = rec."Job Task Type"::Total) then begin
                                        StrLength := StrLen(JobNo);
                                        JobNo := CopyStr(JobNo, 1, StrLength - 1);
                                        NSJobLedgerEntry.Reset();
                                        NSJobLedgerEntry.SetFilter("Job No.", JobNo);
                                        NSJobLedgerEntry.SetFilter("Job Task No.", Rec.Totaling);//PE-29.DK.1.0 12May2023
                                        NSJobLedgerEntry.SetFilter("Entry Type", '%1', NSJobLedgerEntry."Entry Type"::Usage);
                                        NSJobLedgerEntry.SetFilter(quantity, '<>%1', 0);
                                        if NSJobLedgerEntry.FindSet() then
                                            Page.Run(Page::"Job Ledger Entries", NSJobLedgerEntry);
                                    end;

                    end;
                }
                field("NS_Usage TotCost Sub Levels"; Rec."NS_Usage Total Actual Cost")
                {
                    //PRJCTPR-11.GK.1.0 20Apr2023 start
                    //Caption = 'Net (Actual Cost';
                    Caption = 'Actual, Total';
                    //PRJCTPR-11.GK.1.0 20Apr2023 end
                    ToolTip = 'Specifies the value of the Usage (Total Cost) Sub Levels field.';
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Contract (Total Cost)"; Rec."Contract (Total Price)")
                {
                    //PRJCTPR-11.GK.1.0 20Apr2023 start
                    //Caption = 'Contract Price';
                    Caption = 'Contract, Job Level';
                    //PRJCTPR-11.GK.1.0 20Apr2023 end
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Contract (Total Price)';
                }

                field("Contract (Total Price)"; rec."NS_Contract Price Sub Levels")
                {
                    //PRJCTPR-11.GK.1.0 20Apr2023 start
                    //Caption = 'Sub level (Contract Price)';
                    Caption = 'Contract, SubLevel ';
                    //PRJCTPR-11.GK.1.0 20Apr2023 end
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Contract (Total Price) Sub Levels';
                    trigger OnDrillDown()
                    var
                        JobNo: Text[2048];
                        StrLength: Integer;
                    begin
                        Clear(JobNo);
                        Clear(JobNoFilter);
                        JobNoFilter := '@*' + format(Rec."Job No.") + '*';
                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);//PRJCTPR-11.GK.1.0 20Apr2023
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);//PRJCTPR-11.GK.1.0 20Apr2023
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);//PRJCTPR-11.GK.1.0 20Apr2023
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);//PRJCTPR-11.GK.1.0 20Apr2023
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        IF JobNo <> '' then
                            if Rec."Job Task Type" = rec."Job Task Type"::Posting then begin
                                StrLength := StrLen(JobNo);
                                JobNo := CopyStr(JobNo, 1, StrLength - 1);

                                JobPlanningLineRec.Reset();
                                JobPlanningLineRec.SetFilter("Job No.", JobNo);
                                JobPlanningLineRec.SetRange("Job Task No.", Rec."Job Task No.");
                                JobPlanningLineRec.SetFilter("Line Type", '%1|%2', JobPlanningLineRec."Line Type"::Billable, JobPlanningLineRec."Line Type"::"Both Budget and Billable");
                                // JobPlanningLineRec.setrange("Schedule Line", false);//Prjctpr-398 AT 01.03July2024
                                if JobPlanningLineRec.FindSet() then
                                    Page.Run(Page::"Job Planning Lines", JobPlanningLineRec);
                            end else
                                if (rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
                                    StrLength := StrLen(JobNo);
                                    JobNo := CopyStr(JobNo, 1, StrLength - 1);

                                    JobPlanningLineRec.Reset();
                                    JobPlanningLineRec.SetFilter("Job No.", JobNo);
                                    JobPlanningLineRec.SetFilter("Line Type", '%1|%2', JobPlanningLineRec."Line Type"::Billable, JobPlanningLineRec."Line Type"::"Both Budget and Billable");
                                    JobPlanningLineRec.SetFilter("Job Task No.", Rec.Totaling);
                                    //JobPlanningLineRec.setrange("Schedule Line", false);//Prjctpr-398 AT 01.03July2024
                                    if JobPlanningLineRec.FindSet() then
                                        Page.Run(Page::"Job Planning Lines", JobPlanningLineRec);
                                end else
                                    if (rec."Job Task Type" = rec."Job Task Type"::Total) then begin
                                        StrLength := StrLen(JobNo);
                                        JobNo := CopyStr(JobNo, 1, StrLength - 1);

                                        JobPlanningLineRec.Reset();
                                        JobPlanningLineRec.SetFilter("Job No.", JobNo);
                                        JobPlanningLineRec.SetFilter("Job Task No.", Rec.Totaling);//Prjctpr-398 AT 01.03July2024
                                        JobPlanningLineRec.SetFilter("Line Type", '%1|%2', JobPlanningLineRec."Line Type"::Billable, JobPlanningLineRec."Line Type"::"Both Budget and Billable");
                                        // JobPlanningLineRec.setrange("Schedule Line", false);//Prjctpr-398 AT 01.03July2024
                                        if JobPlanningLineRec.FindSet() then
                                            Page.Run(Page::"Job Planning Lines", JobPlanningLineRec);
                                    end;

                    end;

                }

                field("NS_Net Total Contract Price"; Rec."NS_Net Total Contract Price")
                {
                    ApplicationArea = all;
                    Caption = 'Contract, Total ';//PRJCTPR-11.GK.1.0 20Apr2023
                    ToolTip = 'Specifies the Net Total Contract Price';
                    Editable = false;
                }
                field("Contract (Invoiced Price)"; Rec."Contract (Invoiced Price)")
                {
                    //PRJCTPR-11.GK.1.0 20Apr2023 start
                    //Caption = 'Invoiced Price';
                    Caption = 'Billing, Job Level ';
                    //PRJCTPR-11.GK.1.0 20Apr2023 end
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Contract (Invoiced Price)';
                }
                field("NS_Invoiced Price Sub Levels"; Rec."NS_Invoiced Price Sub Levels")
                {
                    //PE-29.GK.1.0 20Apr2023 start
                    //Caption = 'Sub Level (Invoiced Price)';
                    Caption = 'Billing, SubLevel ';
                    ToolTip = 'Specifies the value of the Sub Level (Invoiced Price) field.';
                    ApplicationArea = All;
                    // trigger OnDrillDown()
                    // var
                    //     NSJobLedgerEntry: Record "Job Ledger Entry";
                    //     JobNo: Text[2048];
                    //     StrLength: Integer;
                    // begin
                    //     Clear(JobNo);
                    //     Clear(JobNoFilter);
                    //     JobNoFilter := '@*' + format(Rec."Job No.") + '*';
                    //     JobRec.Reset();
                    //     JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);//PRJCTPR-11.GK.1.0 20Apr2023
                    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
                    //     if JobRec.FindSet() then
                    //         repeat
                    //             JobNo += JobRec."No." + '|';
                    //         until JobRec.Next() = 0;

                    //     JobRec.Reset();
                    //     JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);//PRJCTPR-11.GK.1.0 20Apr2023
                    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
                    //     if JobRec.FindSet() then
                    //         repeat
                    //             JobNo += JobRec."No." + '|';
                    //         until JobRec.Next() = 0;

                    //     JobRec.Reset();
                    //     JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);//PRJCTPR-11.GK.1.0 20Apr2023
                    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
                    //     if JobRec.FindSet() then
                    //         repeat
                    //             JobNo += JobRec."No." + '|';
                    //         until JobRec.Next() = 0;

                    //     JobRec.Reset();
                    //     JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);//PRJCTPR-11.GK.1.0 20Apr2023
                    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
                    //     if JobRec.FindSet() then
                    //         repeat
                    //             JobNo += JobRec."No." + '|';
                    //         until JobRec.Next() = 0;

                    //     IF JobNo <> '' then
                    //         if rec."Job Task Type" = rec."Job Task Type"::Posting then begin
                    //             StrLength := StrLen(JobNo);
                    //             JobNo := CopyStr(JobNo, 1, StrLength - 1);

                    //             NSJobLedgerEntry.Reset();
                    //             NSJobLedgerEntry.SetFilter("Job No.", JobNo);
                    //             NSJobLedgerEntry.SetFilter("Job Task No.", '%1', Rec."Job Task No.");
                    //             NSJobLedgerEntry.SetFilter("Entry Type", '%1', NSJobLedgerEntry."Entry Type"::Sale);
                    //             NSJobLedgerEntry.SetFilter(quantity, '<>%1', 0);
                    //             if NSJobLedgerEntry.FindSet() then
                    //                 Page.Run(Page::"Job Ledger Entries", NSJobLedgerEntry);
                    //         end else
                    //             if (rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
                    //                 StrLength := StrLen(JobNo);
                    //                 JobNo := CopyStr(JobNo, 1, StrLength - 1);
                    //                 NSJobLedgerEntry.Reset();
                    //                 NSJobLedgerEntry.SetFilter("Job No.", JobNo);
                    //                 NSJobLedgerEntry.SetFilter("Entry Type", '%1', NSJobLedgerEntry."Entry Type"::Sale);
                    //                 NSJobLedgerEntry.SetFilter("Job Task No.", Rec.Totaling);
                    //                 NSJobLedgerEntry.SetFilter(quantity, '<>%1', 0);
                    //                 if NSJobLedgerEntry.FindSet() then
                    //                     Page.Run(Page::"Job Ledger Entries", NSJobLedgerEntry);
                    //             end else
                    //                 if (rec."Job Task Type" = rec."Job Task Type"::Total) then begin
                    //                     StrLength := StrLen(JobNo);
                    //                     JobNo := CopyStr(JobNo, 1, StrLength - 1);
                    //                     NSJobLedgerEntry.Reset();
                    //                     NSJobLedgerEntry.SetFilter("Job No.", JobNo);
                    //                     NSJobLedgerEntry.SetFilter("Entry Type", '%1', NSJobLedgerEntry."Entry Type"::Sale);
                    //                     NSJobLedgerEntry.SetFilter(quantity, '<>%1', 0);
                    //                     if NSJobLedgerEntry.FindSet() then
                    //                         Page.Run(Page::"Job Ledger Entries", NSJobLedgerEntry);
                    //                 end;

                    // end;
                    trigger OnDrillDown()
                    var
                        NSJobLedgerEntry: Record "Job Ledger Entry";
                        JobNo: Text;
                        StrLength: Integer;
                    begin
                        Clear(JobNo);
                        Clear(JobNoFilter);
                        JobNoFilter := '@*' + format(Rec."Job No.") + '*';
                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        IF JobNo <> '' then
                            if rec."Job Task Type" = rec."Job Task Type"::Posting then begin
                                StrLength := StrLen(JobNo);
                                JobNo := CopyStr(JobNo, 1, StrLength - 1);

                                NSJobLedgerEntry.Reset();
                                NSJobLedgerEntry.SetFilter("Job No.", JobNo);
                                NSJobLedgerEntry.SetFilter("Job Task No.", '%1', Rec."Job Task No.");
                                NSJobLedgerEntry.SetFilter("Entry Type", '%1', NSJobLedgerEntry."Entry Type"::Sale);
                                NSJobLedgerEntry.SetFilter(quantity, '<>%1', 0);
                                if NSJobLedgerEntry.FindSet() then
                                    Page.Run(Page::"Job Ledger Entries", NSJobLedgerEntry);
                            end else
                                if (rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
                                    StrLength := StrLen(JobNo);
                                    JobNo := CopyStr(JobNo, 1, StrLength - 1);
                                    NSJobLedgerEntry.Reset();
                                    NSJobLedgerEntry.SetFilter("Job No.", JobNo);
                                    NSJobLedgerEntry.SetFilter("Entry Type", '%1', NSJobLedgerEntry."Entry Type"::Sale);
                                    NSJobLedgerEntry.SetFilter("Job Task No.", Rec.Totaling);
                                    NSJobLedgerEntry.SetFilter(quantity, '<>%1', 0);
                                    if NSJobLedgerEntry.FindSet() then
                                        Page.Run(Page::"Job Ledger Entries", NSJobLedgerEntry);
                                end else
                                    if (rec."Job Task Type" = rec."Job Task Type"::Total) then begin
                                        StrLength := StrLen(JobNo);
                                        JobNo := CopyStr(JobNo, 1, StrLength - 1);
                                        NSJobLedgerEntry.Reset();
                                        NSJobLedgerEntry.SetFilter("Job No.", JobNo);
                                        NSJobLedgerEntry.SetFilter("Job Task No.", Rec.Totaling);//Prjctpr-398 AT.01 03July2024
                                        NSJobLedgerEntry.SetFilter("Entry Type", '%1', NSJobLedgerEntry."Entry Type"::Sale);
                                        NSJobLedgerEntry.SetFilter(quantity, '<>%1', 0);
                                        if NSJobLedgerEntry.FindSet() then
                                            Page.Run(Page::"Job Ledger Entries", NSJobLedgerEntry);
                                    end;
                    end;

                    //PE-29.GK.1.0 20Apr2023 end
                }
                field("NS_Net Invoiced Price"; Rec."NS_Net Invoiced Price")
                {
                    //PRJCTPR-11.GK.1.0 20Apr2023 start
                    //Caption = 'Net Invoiced Price';
                    Caption = 'Billing, Total ';
                    //PRJCTPR-11.GK.1.0 20Apr2023 end
                    ToolTip = 'Specifies the value of the Net Invoiced Price field.';
                    ApplicationArea = All;
                }
                field("Unbilled Revenue"; Rec."NS_Unbilled Revenue")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Unbilled Revenue';
                    Visible = false;
                }
                field("NS_Unbilled Revenue New"; Rec."NS_Unbilled Revenue New")
                {
                    Caption = 'Unbilled Revenue';
                    ToolTip = 'Specifies the value of the Unbilled Revenue field.';
                    ApplicationArea = All;
                }

                field("Remaining (Total Cost)"; Rec."Remaining (Total Cost)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Remaining (Total Cost)';
                    Visible = false;
                    Editable = false;
                }
                field("NS_Remaining (Total Cost) New"; Rec."NS_Remaining (Total Cost) New")
                {
                    //PRJCTPR-11.GK.1.0 20Apr2023 start
                    //Caption = 'Remaning Total Cost';
                    Caption = 'Remaining, Total Cost';
                    //PRJCTPR-11.GK.1.0 20Apr2023 end
                    ToolTip = 'Specifies the value of the Remaining (Total Cost) field.';
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Remaining (Total Price)"; Rec."Remaining (Total Price)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Remaining (Total Price)';
                    Visible = false;
                    Editable = false;

                }
                field("Committed Costs"; Rec."NS_Committed Costs")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Committed Costs';
                    Editable = false;
                    Visible = false;

                }
                field("NS_Committed Costs Master Job"; Rec."NS_Committed Costs Master Job")
                {
                    //PRJCTPR-11.GK.1.0 20Apr2023 start
                    //Caption = 'Commited Cost';
                    Caption = 'Committed Cost, Job Level ';
                    //PRJCTPR-11.GK.1.0 20Apr2023 end
                    ToolTip = 'Specifies the value of the Committed Costs field.';
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        JobNo: Text[2048];
                        StrLength: Integer;
                    begin
                        IF Rec."Job No." <> '' then
                            if rec."Job Task Type" = rec."Job Task Type"::Posting then begin
                                PurchaseLine.Reset();
                                PurchaseLine.SetFilter("Document Type", '%1|%2', PurchaseLine."Document Type"::Order, PurchaseLine."Document Type"::Invoice);
                                PurchaseLine.SetFilter("Job No.", Rec."Job No.");
                                PurchaseLine.SetRange("Job Task No.", Rec."Job Task No.");
                                PurchaseLine.SetFilter("NS_Committed Quantity", '<>%1', 0);
                                if PurchaseLine.FindSet() then
                                    Page.Run(Page::"Purchase Lines", PurchaseLine);
                            end else
                                if (rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
                                    PurchaseLine.Reset();
                                    PurchaseLine.SetFilter("Document Type", '%1|%2', PurchaseLine."Document Type"::Order, PurchaseLine."Document Type"::Invoice);
                                    PurchaseLine.SetFilter("Job No.", rec."Job No.");
                                    PurchaseLine.SetFilter("Job Task No.", rec.Totaling);
                                    PurchaseLine.SetFilter("NS_Committed Quantity", '<>%1', 0);
                                    if PurchaseLine.FindSet() then
                                        Page.Run(Page::"Purchase Lines", PurchaseLine);
                                end else
                                    if (rec."Job Task Type" = rec."Job Task Type"::Total) then begin
                                        PurchaseLine.Reset();
                                        PurchaseLine.SetFilter("Document Type", '%1|%2', PurchaseLine."Document Type"::Order, PurchaseLine."Document Type"::Invoice);
                                        PurchaseLine.SetFilter("Job No.", rec."Job No.");
                                        PurchaseLine.SetFilter("Job Task No.", rec.Totaling);//Prjctpr-398 AT 01.03july2024
                                        PurchaseLine.SetFilter("NS_Committed Quantity", '<>%1', 0);
                                        if PurchaseLine.FindSet() then
                                            Page.Run(Page::"Purchase Lines", PurchaseLine);
                                    end;

                    end;

                }
                field("NS_Committed Costs Sub levels"; Rec."NS_Committed Costs Sub levels")
                {
                    //PRJCTPR-11.GK.1.0 20Apr2023 start
                    //Caption = 'Commited Cost Sub levels';
                    Caption = 'Committed Cost, SubLevel ';
                    //PRJCTPR-11.GK.1.0 20Apr2023 end
                    ToolTip = 'Specifies the value of the Sub Levels (Committed Costs) field.';
                    ApplicationArea = All;
                    Editable = false;
                    trigger OnDrillDown()
                    var
                        JobNo: Text[2048];
                        StrLength: Integer;
                    begin
                        //PRJCTPR-11.GK.1.0 20Apr2023 start
                        // Clear(JobNoFilter);

                        // JobNoFilter := format(Rec."Job No.");
                        // Clear(JobNo);
                        // JobRec.Reset();
                        // JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        // JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
                        // if JobRec.FindSet() then
                        //     repeat
                        //         JobNo += JobRec."No." + '|';
                        //     until JobRec.Next() = 0;

                        // JobRec.Reset();
                        // JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        // JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
                        // if JobRec.FindSet() then
                        //     repeat
                        //         JobNo += JobRec."No." + '|';
                        //     until JobRec.Next() = 0;

                        // JobRec.Reset();
                        // JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        // JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
                        // if JobRec.FindSet() then
                        //     repeat
                        //         JobNo += JobRec."No." + '|';
                        //     until JobRec.Next() = 0;

                        // JobRec.Reset();
                        // JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        // JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
                        // if JobRec.FindSet() then
                        //     repeat
                        //         JobNo += JobRec."No." + '|';
                        //     until JobRec.Next() = 0;

                        // //JobNo += Rec."Job No." + '|';

                        // IF JobNo <> '' then
                        //     if rec."Job Task Type" = rec."Job Task Type"::Posting then begin
                        //         StrLength := StrLen(JobNo);
                        //         JobNo := CopyStr(JobNo, 1, StrLength - 1);

                        //         PurchaseLine.Reset();
                        //         PurchaseLine.SetFilter("Document Type", '%1|%2', PurchaseLine."Document Type"::Order, PurchaseLine."Document Type"::Invoice);
                        //         PurchaseLine.SetFilter("Job No.", JobNo);
                        //         PurchaseLine.SetRange("Job Task No.", Rec."Job Task No.");
                        //         PurchaseLine.SetFilter("NS_Committed Quantity", '<>%1', 0);
                        //         if PurchaseLine.FindSet() then
                        //             Page.Run(Page::"Purchase Lines", PurchaseLine);
                        //     end else
                        //         if (rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
                        //             StrLength := StrLen(JobNo);
                        //             JobNo := CopyStr(JobNo, 1, StrLength - 1);

                        //             PurchaseLine.Reset();
                        //             PurchaseLine.SetFilter("Document Type", '%1|%2', PurchaseLine."Document Type"::Order, PurchaseLine."Document Type"::Invoice);
                        //             PurchaseLine.SetFilter("Job No.", JobNo);
                        //             PurchaseLine.SetFilter("Job Task No.", Rec.Totaling);
                        //             PurchaseLine.SetFilter("NS_Committed Quantity", '<>%1', 0);
                        //             if PurchaseLine.FindSet() then
                        //                 Page.Run(Page::"Purchase Lines", PurchaseLine);
                        //         end else
                        //             if (rec."Job Task Type" = rec."Job Task Type"::Total) then begin
                        //                 StrLength := StrLen(JobNo);
                        //                 JobNo := CopyStr(JobNo, 1, StrLength - 1);

                        //                 PurchaseLine.Reset();
                        //                 PurchaseLine.SetFilter("Document Type", '%1|%2', PurchaseLine."Document Type"::Order, PurchaseLine."Document Type"::Invoice);
                        //                 PurchaseLine.SetFilter("Job No.", JobNo);
                        //                 PurchaseLine.SetFilter("NS_Committed Quantity", '<>%1', 0);
                        //                 if PurchaseLine.FindSet() then
                        //                     Page.Run(Page::"Purchase Lines", PurchaseLine);
                        //             end;
                        Clear(JobNoFilter);

                        JobNoFilter := format(Rec."Job No.");
                        Clear(JobNo);
                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        IF JobNo <> '' then
                            if rec."Job Task Type" = rec."Job Task Type"::Posting then begin
                                StrLength := StrLen(JobNo);
                                JobNo := CopyStr(JobNo, 1, StrLength - 1);

                                PurchaseLine.Reset();
                                PurchaseLine.SetFilter("Document Type", '%1|%2', PurchaseLine."Document Type"::Order, PurchaseLine."Document Type"::Invoice);
                                PurchaseLine.SetFilter("Job No.", JobNo);
                                PurchaseLine.SetRange("Job Task No.", Rec."Job Task No.");
                                PurchaseLine.SetFilter("NS_Committed Quantity", '<>%1', 0);
                                if PurchaseLine.FindSet() then
                                    Page.Run(Page::"Purchase Lines", PurchaseLine);
                            end else
                                if (rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
                                    StrLength := StrLen(JobNo);
                                    JobNo := CopyStr(JobNo, 1, StrLength - 1);

                                    PurchaseLine.Reset();
                                    PurchaseLine.SetFilter("Document Type", '%1|%2', PurchaseLine."Document Type"::Order, PurchaseLine."Document Type"::Invoice);
                                    PurchaseLine.SetFilter("Job No.", JobNo);
                                    PurchaseLine.SetFilter("Job Task No.", Rec.Totaling);
                                    PurchaseLine.SetFilter("NS_Committed Quantity", '<>%1', 0);
                                    if PurchaseLine.FindSet() then
                                        Page.Run(Page::"Purchase Lines", PurchaseLine);
                                end else
                                    if (rec."Job Task Type" = rec."Job Task Type"::Total) then begin
                                        StrLength := StrLen(JobNo);
                                        JobNo := CopyStr(JobNo, 1, StrLength - 1);

                                        PurchaseLine.Reset();
                                        PurchaseLine.SetFilter("Document Type", '%1|%2', PurchaseLine."Document Type"::Order, PurchaseLine."Document Type"::Invoice);
                                        PurchaseLine.SetFilter("Job No.", JobNo);
                                        PurchaseLine.SetFilter("Job Task No.", rec.Totaling);//Prjctpr-398 AT 01.03july2024
                                        PurchaseLine.SetFilter("NS_Committed Quantity", '<>%1', 0);
                                        if PurchaseLine.FindSet() then
                                            Page.Run(Page::"Purchase Lines", PurchaseLine);
                                    end;

                        //PRJCTPR-11.GK.1.0 20Apr2023 end

                    end;
                }
                field("NS_Net Committed Costs"; Rec."NS_Net Committed Costs")
                {
                    //PRJCTPR-11.GK.1.0 20Apr2023 start
                    //Caption = 'Net Commited Cost';
                    Caption = 'Committed Cost, Total ';
                    //PRJCTPR-11.GK.1.0 20Apr2023 end
                    ToolTip = 'Specifies the value of the Net Committed Costs field.';
                    ApplicationArea = All;
                }
                field("Subcontract Value"; Rec."NS_Subcontract Value")
                {
                    //PRJCTPR-11.GK.1.0 20Apr2023 start
                    //Caption = 'Subcontract';
                    Caption = 'Subcontract Cost, Job Level ';
                    //PRJCTPR-11.GK.1.0 20Apr2023 end
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Subcontract Value';
                    trigger OnDrillDown()
                    var
                        JobNo: Text[2048];
                        StrLength: Integer;
                    begin
                        IF rec."Job No." <> '' then
                            if Rec."Job Task Type" = rec."Job Task Type"::Posting then begin
                                SubcontractLine.Reset();
                                SubcontractLine.SetFilter("NS_Job No.", Rec."Job No.");
                                SubcontractLine.SetRange("NS_Job Task No.", Rec."Job Task No.");
                                SubcontractLine.Setfilter(NS_Quantity, '<>%1', 0);
                                if SubcontractLine.FindSet() then
                                    Page.Run(Page::"NS_Subcontract Lines", SubcontractLine);
                            end else
                                if (rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
                                    SubcontractLine.Reset();
                                    SubcontractLine.SetFilter("NS_Job No.", Rec."Job No.");
                                    SubcontractLine.SetFilter("NS_Job Task No.", rec.Totaling);
                                    SubcontractLine.Setfilter(NS_Quantity, '<>%1', 0);
                                    if SubcontractLine.FindSet() then
                                        Page.Run(Page::"NS_Subcontract Lines", SubcontractLine);
                                end else
                                    if (rec."Job Task Type" = rec."Job Task Type"::Total) then begin
                                        SubcontractLine.Reset();
                                        SubcontractLine.SetFilter("NS_Job No.", Rec."Job No.");
                                        SubcontractLine.SetFilter("NS_Job Task No.", rec.Totaling); //Prjctpr-398 AT 01.03july2024
                                        SubcontractLine.Setfilter(NS_Quantity, '<>%1', 0);
                                        if SubcontractLine.FindSet() then
                                            Page.Run(Page::"NS_Subcontract Lines", SubcontractLine);
                                    end;
                    end;
                }
                field("NS_Subcon. Value Sub Levels"; rec."NS_Subcon. Value Sub Levels")
                {
                    //PRJCTPR-11.GK.1.0 20Apr2023 start
                    //Caption = 'Subcontract Value Sub Levels';
                    Caption = 'Subcontract Cost, SubLevel ';
                    //PRJCTPR-11.GK.1.0 20Apr2023 end
                    Editable = false;
                    ToolTip = 'Specifies the Subcontract Value Sub Level Jobs';
                    ApplicationArea = all;

                    trigger OnDrillDown()
                    var
                        JobNo: Text[2048];
                        StrLength: Integer;
                    begin
                        Clear(JobNoFilter);
                        JobNoFilter := '@*' + format(Rec."Job No.") + '*';
                        Clear(JobNo);
                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;
                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        IF JobNo <> '' then
                            if Rec."Job Task Type" = rec."Job Task Type"::Posting then begin
                                StrLength := StrLen(JobNo);
                                JobNo := CopyStr(JobNo, 1, StrLength - 1);
                                SubcontractLine.Reset();
                                SubcontractLine.SetFilter("NS_Job No.", JobNo);
                                SubcontractLine.SetRange("NS_Job Task No.", Rec."Job Task No.");
                                SubcontractLine.Setfilter(NS_Quantity, '<>%1', 0);
                                if SubcontractLine.FindSet() then
                                    Page.Run(Page::"NS_Subcontract Lines", SubcontractLine);
                            end else
                                if (rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
                                    StrLength := StrLen(JobNo);
                                    JobNo := CopyStr(JobNo, 1, StrLength - 1);
                                    SubcontractLine.Reset();
                                    SubcontractLine.SetFilter("NS_Job No.", JobNo);
                                    SubcontractLine.SetFilter("NS_Job Task No.", Rec.Totaling);
                                    SubcontractLine.Setfilter(NS_Quantity, '<>%1', 0);
                                    if SubcontractLine.FindSet() then
                                        Page.Run(Page::"NS_Subcontract Lines", SubcontractLine);
                                end else
                                    if (rec."Job Task Type" = rec."Job Task Type"::Total) then begin
                                        StrLength := StrLen(JobNo);
                                        JobNo := CopyStr(JobNo, 1, StrLength - 1);
                                        SubcontractLine.Reset();
                                        SubcontractLine.SetFilter("NS_Job No.", JobNo);
                                        SubcontractLine.SetFilter("NS_Job Task No.", Rec.Totaling);//Prjctpr-398 AT 01.03July2024
                                        SubcontractLine.Setfilter(NS_Quantity, '<>%1', 0);
                                        if SubcontractLine.FindSet() then
                                            Page.Run(Page::"NS_Subcontract Lines", SubcontractLine);
                                    end;
                    end;

                }
                field("NS_Net Subcontract Value"; rec."NS_Net Subcontract Value")
                {
                    //PRJCTPR-11.GK.1.0 20Apr2023 start
                    //Caption = 'Net Subcontract Value';
                    Caption = 'Subcontract Cost, Total ';
                    //PRJCTPR-11.GK.1.0 20Apr2023 end
                    Editable = false;
                    ToolTip = 'Specifies the Subcontract Value Sub Level Jobs';
                    ApplicationArea = all;
                }
                //PE-193.PS.3.0 27Dec2023 Start
                field("NS_Change Request Budget"; Rec."NS_Change Request Budget")
                {
                    ApplicationArea = all;
                    // trigger OnDrillDown()
                    // var
                    //     NS_ChangeorderNo: text;
                    //     StrLength: Integer;
                    // begin

                    // Clear(JobNoFilter);
                    // JobNoFilter := '@*' + format(Rec."Job No.") + '*';
                    // Clear(NS_ChangeorderNo);
                    // JobRec.Reset();
                    // JobRec.Setfilter("NS_Change Request to Job No.", '%1', JobNoFilter);
                    // JobRec.SetFilter("NS_Manager Job Status", '<>1', JobRec."NS_Manager Job Status"::Completed);
                    // JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Request");
                    // if JobRec.FindSet() then
                    //     repeat
                    //         NS_ChangeorderNo += JobRec."No." + '|';
                    //     until JobRec.Next() = 0;

                    //  IF NS_ChangeorderNo <> '' then
                    // if Rec."Job Task Type" = rec."Job Task Type"::Posting then begin
                    //     StrLength := StrLen(NS_ChangeorderNo);
                    //     NS_ChangeorderNo := CopyStr(NS_ChangeorderNo, 1, StrLength - 1);
                    //     JobPlanningLineRec.Reset();
                    //     JobPlanningLineRec.SetFilter("Job No.", NS_ChangeorderNo);
                    //     JobPlanningLineRec.SetRange("Job Task No.", Rec."Job Task No.");
                    //     JobPlanningLineRec.Setfilter(Quantity, '<>%1', 0);
                    //     if JobPlanningLineRec.FindSet() then
                    //         Page.Run(Page::"Job Planning Lines", JobPlanningLineRec);
                    // end else
                    //     if (rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
                    //         StrLength := StrLen(NS_ChangeorderNo);
                    //         NS_ChangeorderNo := CopyStr(NS_ChangeorderNo, 1, StrLength - 1);
                    //         JobPlanningLineRec.Reset();
                    //         JobPlanningLineRec.SetFilter("Job No.", NS_ChangeorderNo);
                    //         JobPlanningLineRec.SetFilter("Job Task No.", Rec.Totaling);
                    //         JobPlanningLineRec.Setfilter(Quantity, '<>%1', 0);
                    //         if JobPlanningLineRec.FindSet() then
                    //             Page.Run(Page::"Job Planning Lines", JobPlanningLineRec);
                    //     end else
                    //         if (rec."Job Task Type" = rec."Job Task Type"::Total) then begin
                    //             StrLength := StrLen(NS_ChangeorderNo);
                    //             NS_ChangeorderNo := CopyStr(NS_ChangeorderNo, 1, StrLength - 1);
                    //             JobPlanningLineRec.Reset();
                    //             JobPlanningLineRec.SetFilter("Job No.", NS_ChangeorderNo);
                    //             JobPlanningLineRec.Setfilter(Quantity, '<>%1', 0);
                    //             if JobPlanningLineRec.FindSet() then
                    //                 Page.Run(Page::"Job Planning Lines", JobPlanningLineRec);
                    //End;
                    // end;
                }
                field("NS_Change Request Billable"; Rec."NS_Change Request Billable")
                {
                    ApplicationArea = all;
                }
                //PE-193.PS.3.0 27Dec2023 End

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }
    trigger OnOpenPage()
    var
    begin

    end;
    //PE-29.Dk.1.0 Start 10May2023
    trigger OnAfterGetRecord()
    // var
    //     JobNo: Text[2048];
    //     StrLength: Integer;
    // begin
    //     Clear(TotalTaskNo);
    //     JobTaskrec_1.Reset();
    //     JobTaskrec_1.SetRange("Job No.", Rec."Job No.");
    //     JobTaskrec_1.SetRange("Job Task Type", JobTaskrec_1."Job Task Type"::Total);
    //     IF JobTaskrec_1.FindLast() then
    //         TotalTaskNo := JobTaskrec_1."Job Task No.";

    //     //Change Orders-        
    //     Clear(JobNo);
    //     Clear(JobNoFilter);
    //     JobNoFilter := '@*' + Format(Rec."Job No.") + '*';
    //     JobRec.Reset();
    //     JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     JobRec.Reset();
    //     JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     JobRec.Reset();
    //     JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     JobRec.Reset();
    //     JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     IF JobNo <> '' then
    //         if (Rec."Job Task Type" = rec."Job Task Type"::Posting) OR (Rec."Job Task Type" = rec."Job Task Type"::Total) OR (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
    //             StrLength := StrLen(JobNo);
    //             JobNo := CopyStr(JobNo, 1, StrLength - 1);

    //             JobPlanningLineRec.Reset();
    //             JobPlanningLineRec.SetFilter("Job No.", JobNo);
    //             JobPlanningLineRec.SetRange("Job Task No.", Rec."Job Task No.");
    //             JobPlanningLineRec.SetFilter("Line Type", '%1..%2', JobPlanningLineRec."Line Type"::Budget, JobPlanningLineRec."Line Type"::"Both Budget and Billable");
    //             JobPlanningLineRec.setrange("Schedule Line", true);
    //             JobPlanningLineRec.CalcSums("Total Cost (LCY)");
    //             Rec."NS_Change Orders" := JobPlanningLineRec."Total Cost (LCY)";
    //         end;


    //     if (Rec."Job Task Type" = rec."Job Task Type"::"Begin-Total") or (Rec."Job Task Type" = rec."Job Task Type"::Heading) then
    //         Rec."NS_Change Orders" := 0;

    //     if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") OR (Rec."Job Task Type" = rec."Job Task Type"::Total) then begin
    //         JTL.Reset();
    //         JTL.SetRange("Job No.", JobNo);
    //         JTL.SetFilter("Job Task No.", Rec."Job Task No.");
    //         if JTL.FindSet() then
    //             repeat
    //                 JTL.CalcFields("Schedule (Total Cost)");
    //                 Rec."NS_Change Orders" += JTL."Schedule (Total Cost)";
    //             until JTL.Next() = 0;
    //     end;
    //     Rec.Modify();

    //     //Net Budget
    //     Rec."NS_Net Budget" := Rec."Schedule (Total Cost)" + Rec."NS_Change Orders";
    //     Rec.Modify();

    //     //Committed Cost
    //     Clear(JobNoFilter);
    //     JobNoFilter := '@*' + Format(Rec."Job No.") + '*';
    //     Clear(JobNo);
    //     JobRec.Reset();
    //     JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     JobRec.Reset();
    //     JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     JobRec.Reset();
    //     JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     JobRec.Reset();
    //     JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     JobNo += Rec."Job No." + '|';

    //     IF JobNo <> '' then
    //         if Rec."Job Task Type" = Rec."Job Task Type"::Posting then begin
    //             StrLength := StrLen(JobNo);
    //             JobNo := CopyStr(JobNo, 1, StrLength - 1);

    //             PurchaseLine.Reset();
    //             PurchaseLine.SetFilter("Document Type", '%1|%2', PurchaseLine."Document Type"::Order, PurchaseLine."Document Type"::Invoice);
    //             PurchaseLine.SetFilter("Job No.", JobNo);
    //             PurchaseLine.SetRange("Job Task No.", Rec."Job Task No.");
    //             PurchaseLine.SetFilter("NS_Committed Quantity", '<>%1', 0);
    //             if PurchaseLine.FindSet() then begin
    //                 PurchaseLine.CalcSums("NS_Committed Amount");
    //                 Rec."NS_Committed Costs" := PurchaseLine."NS_Committed Amount";
    //             end;
    //         end else begin
    //             StrLength := StrLen(JobNo);
    //             JobNo := CopyStr(JobNo, 1, StrLength - 1);

    //             PurchaseLine.Reset();
    //             PurchaseLine.SetFilter("Document Type", '%1|%2', PurchaseLine."Document Type"::Order, PurchaseLine."Document Type"::Invoice);
    //             PurchaseLine.SetFilter("Job No.", JobNo);
    //             PurchaseLine.SetFilter("NS_Committed Quantity", '<>%1', 0);
    //             if PurchaseLine.FindSet() then begin
    //                 PurchaseLine.CalcSums("NS_Committed Amount");
    //                 Rec."NS_Committed Costs" := PurchaseLine."NS_Committed Amount";
    //             end;
    //         end;
    //     Rec.Modify();

    //     //get Subcontract value master Job
    //     SubConTrct := 0;
    //     subconttl := 0;
    //     IF rec."Job No." <> '' then
    //         if rec."Job Task Type" = Rec."Job Task Type"::Posting then begin
    //             SubcontractLine.Reset();
    //             SubcontractLine.SetFilter("NS_Job No.", rec."Job No.");
    //             SubcontractLine.SetRange("NS_Job Task No.", Rec."Job Task No.");
    //             SubcontractLine.Setfilter(NS_Quantity, '<>%1', 0);
    //             SubcontractLine.CalcSums("NS_Total Cost");
    //             Rec."NS_Subcontract Value" := SubcontractLine."NS_Total Cost";
    //         end;

    //     if (Rec."Job Task Type" = rec."Job Task Type"::"Begin-Total") or (Rec."Job Task Type" = rec."Job Task Type"::Heading) then begin
    //         Rec."NS_Subcontract Value" := 0;
    //         Rec.Modify();
    //     end;

    //     if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin

    //         JTL.Reset();
    //         JTL.SetRange("Job No.", Rec."Job No.");
    //         JTL.SetFilter("Job Task No.", Rec.Totaling);
    //         if JTL.FindSet() then
    //             repeat
    //                 Rec."NS_Subcontract Value" := 0;
    //                 Rec.Modify();
    //             until JTL.Next() = 0;
    //     end;

    //     if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
    //         JTL.Reset();
    //         JTL.SetRange("Job No.", Rec."Job No.");
    //         JTL.SetFilter("Job Task No.", Rec.Totaling);
    //         if JTL.FindSet() then
    //             repeat
    //                 SubConTrct += JTL."NS_Subcontract Value";
    //             until JTL.Next() = 0;

    //         Rec."NS_Subcontract Value" := SubConTrct;

    //     end;


    //     if (Rec."Job Task Type" = rec."Job Task Type"::Total) then
    //         Rec."NS_Subcontract Value" := 0;

    //     if (Rec."Job Task Type" = rec."Job Task Type"::Total) then begin
    //         JTL.Reset();
    //         JTL.SetRange("Job No.", Rec."Job No.");
    //         JTL.SetRange("Job Task Type", JTL."Job Task Type"::"End-Total");
    //         if JTL.FindSet() then
    //             repeat
    //                 subconttl += JTL."NS_Subcontract Value";
    //             until JTL.Next() = 0;

    //         Rec."NS_Subcontract Value" := subconttl;
    //     end;

    //     Rec.Modify();

    //     //Add Usage Actual Cost for sub levels-Start
    //     Clear(JobNo);
    //     Clear(JobNoFilter);
    //     JobNoFilter := '@*' + Format(Rec."Job No.") + '*';
    //     JobRec.Reset();
    //     JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     JobRec.Reset();
    //     JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     JobRec.Reset();
    //     JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     JobRec.Reset();
    //     JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     IF JobNo <> '' then
    //         if (Rec."Job Task Type" = rec."Job Task Type"::Posting) OR (Rec."Job Task Type" = rec."Job Task Type"::Total) OR (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
    //             StrLength := StrLen(JobNo);
    //             JobNo := CopyStr(JobNo, 1, StrLength - 1);

    //             NSJobLedgerEntry2.Reset();
    //             NSJobLedgerEntry2.SetFilter("Job No.", JobNo);
    //             NSJobLedgerEntry2.SetFilter("Job Task No.", '%1', Rec."Job Task No.");
    //             NSJobLedgerEntry2.SetFilter("Entry Type", '%1', NSJobLedgerEntry2."Entry Type"::Usage);
    //             NSJobLedgerEntry2.SetFilter(quantity, '<>%1', 0);
    //             NSJobLedgerEntry2.CalcSums("Total Cost (LCY)");
    //             Rec."NS_Usage TotCost Change Order" := NSJobLedgerEntry2."Total Cost (LCY)";
    //         end;

    //     if (Rec."Job Task Type" = rec."Job Task Type"::"Begin-Total") or (Rec."Job Task Type" = rec."Job Task Type"::Heading) then
    //         Rec."NS_Usage TotCost Change Order" := 0;

    //     if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") OR (Rec."Job Task Type" = rec."Job Task Type"::Total) then begin
    //         JTL.Reset();
    //         JTL.SetRange("Job No.", JobNo);
    //         JTL.SetFilter("Job Task No.", Rec."Job Task No.");
    //         if JTL.FindSet() then
    //             repeat
    //                 JTL.CalcFields("Usage (Total Cost)");
    //                 Rec."NS_Usage TotCost Change Order" += JTL."Usage (Total Cost)";
    //             until JTL.Next() = 0;
    //     end;

    //     rec."NS_Usage Total Actual Cost" := Rec."Usage (Total Cost)" + Rec."NS_Usage TotCost Change Order";
    //     Rec.Modify();

    //     //Sub Levels Jobs Contract Price start
    //     Clear(JobNo);
    //     Clear(JobNoFilter);
    //     JobNoFilter := '@*' + Format(Rec."Job No.") + '*';
    //     JobRec.Reset();
    //     JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     JobRec.Reset();
    //     JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     JobRec.Reset();
    //     JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     JobRec.Reset();
    //     JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     ContractPriceSublvl := 0;
    //     ContrctPriceSublvlEndTTL := 0;
    //     IF JobNo <> '' then
    //         if Rec."Job Task Type" = rec."Job Task Type"::Posting then begin
    //             StrLength := StrLen(JobNo);
    //             JobNo := CopyStr(JobNo, 1, StrLength - 1);

    //             JobPlanningLineRec.Reset();
    //             JobPlanningLineRec.SetFilter("Job No.", JobNo);
    //             JobPlanningLineRec.SetRange("Job Task No.", Rec."Job Task No.");
    //             JobPlanningLineRec.SetFilter("Line Type", '%1|%2', JobPlanningLineRec."Line Type"::Billable, JobPlanningLineRec."Line Type"::"Both Budget and Billable");
    //             JobPlanningLineRec.setrange("Schedule Line", false);
    //             JobPlanningLineRec.CalcSums("Total Price (LCY)");
    //             rec."NS_Contract Price Sub Levels" := JobPlanningLineRec."Total Price (LCY)";
    //             Rec.Modify();
    //         end;

    //     if (Rec."Job Task Type" = rec."Job Task Type"::"Begin-Total") or (Rec."Job Task Type" = rec."Job Task Type"::Heading) then
    //         Rec."NS_Contract Price Sub Levels" := 0;

    //     if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin

    //         StrLength := StrLen(JobNo);
    //         JobNo := CopyStr(JobNo, 1, StrLength - 1);

    //         JTL.Reset();
    //         JTL.SetRange("Job No.", JobNo);
    //         JTL.SetFilter("Job Task No.", Rec.Totaling);
    //         if JTL.FindSet() then
    //             repeat
    //                 Rec."NS_Contract Price Sub Levels" := 0;
    //                 Rec.Modify();
    //             until JTL.Next() = 0;
    //     end;

    //     if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
    //         StrLength := StrLen(JobNo);
    //         JobNo := CopyStr(JobNo, 1, StrLength - 1);

    //         JTL.Reset();
    //         JTL.SetRange("Job No.", Rec."Job No.");
    //         JTL.SetFilter("Job Task No.", Rec.Totaling);
    //         if JTL.FindSet() then
    //             repeat
    //                 ContrctPriceSublvlEndTTL += JTL."NS_Contract Price Sub Levels";
    //             until JTL.Next() = 0;

    //         Rec."NS_Contract Price Sub Levels" := ContrctPriceSublvlEndTTL;
    //         Rec.Modify();

    //     end;

    //     if (Rec."Job Task Type" = Rec."Job Task Type"::Total) and (Rec.Totaling <> '') then begin//PRJ-1493.2.0
    //         JTL.Reset();
    //         JTL.SetFilter("Job No.", Rec."Job No.");
    //         JTL.SetRange("Job Task Type", JTL."Job Task Type"::Posting);
    //         if JTL.FindSet() then begin
    //             repeat
    //                 ContractPriceSublvl += JTL."NS_Contract Price Sub Levels";
    //             until JTL.Next() = 0;

    //             Rec."NS_Contract Price Sub Levels" := ContractPriceSublvl;
    //             Rec.Modify();
    //         end;
    //     end
    //     else
    //         if (Rec."Job Task Type" = Rec."Job Task Type"::Total) and (Rec.Totaling = '') then//PRJ-1493.2.0
    //             Rec."NS_Contract Price Sub Levels" := 0;

    //     rec."NS_Net Total Contract Price" := Rec."Contract (Total Price)" + Rec."NS_Contract Price Sub Levels";
    //     Rec.Modify();
    //     //Sub Levels Jobs Contract Price end

    //     //Sub level Invoices Amount - start
    //     Clear(JobNo);
    //     Clear(JobNoFilter);
    //     JobNoFilter := '@*' + format(Rec."Job No.") + '*';
    //     JobRec.Reset();
    //     JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     JobRec.Reset();
    //     JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     JobRec.Reset();
    //     JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     JobRec.Reset();
    //     JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     IF JobNo <> '' then
    //         if (Rec."Job Task Type" = rec."Job Task Type"::Posting) OR (Rec."Job Task Type" = rec."Job Task Type"::Total) OR (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
    //             StrLength := StrLen(JobNo);
    //             JobNo := CopyStr(JobNo, 1, StrLength - 1);

    //             NSJobLedgerEntry2.Reset();
    //             NSJobLedgerEntry2.SetFilter("Job No.", JobNo);
    //             NSJobLedgerEntry2.SetFilter("Job Task No.", '%1', Rec."Job Task No.");
    //             NSJobLedgerEntry2.SetFilter("Entry Type", '%1', NSJobLedgerEntry2."Entry Type"::Sale);
    //             NSJobLedgerEntry2.SetFilter(quantity, '<>%1', 0);
    //             NSJobLedgerEntry2.CalcSums("Total Price (LCY)");
    //             rec."NS_Invoiced Price Sub Levels" := ABS(NSJobLedgerEntry2."Total Price (LCY)");
    //         end;

    //     if (Rec."Job Task Type" = rec."Job Task Type"::"Begin-Total") or (Rec."Job Task Type" = rec."Job Task Type"::Heading) then
    //         Rec."NS_Invoiced Price Sub Levels" := 0;

    //     if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") OR (Rec."Job Task Type" = rec."Job Task Type"::Total) then begin
    //         JTL.Reset();
    //         JTL.SetRange("Job No.", JobNo);
    //         JTL.SetFilter("Job Task No.", Rec."Job Task No.");
    //         if JTL.FindSet() then
    //             repeat
    //                 JTL.CalcFields("Contract (Invoiced Price)");
    //                 Rec."NS_Invoiced Price Sub Levels" += JTL."Contract (Invoiced Price)";
    //             until JTL.Next() = 0;
    //     end;

    //     Rec."NS_Net Invoiced Price" := rec."NS_Invoiced Price Sub Levels" + ABS(Rec."Contract (Invoiced Price)");
    //     Rec.Modify();
    //     Rec."NS_Unbilled Revenue New" := rec."NS_Net Total Contract Price" - Rec."NS_Net Invoiced Price";
    //     Rec."NS_Remaining (Total Cost) New" := rec."NS_Net Budget" - Rec."NS_Usage Total Actual Cost";
    //     Rec.Modify();

    //     //Calculate commited cost sub levels-start
    //     ValMasterJob := 0;
    //     ValMasterJobTotal := 0;
    //     IF rec."Job No." <> '' then
    //         if (Rec."Job Task Type" = rec."Job Task Type"::Posting) OR (Rec."Job Task Type" = rec."Job Task Type"::Total) OR (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
    //             PurchaseLine.Reset();
    //             PurchaseLine.SetFilter("Document Type", '%1|%2', PurchaseLine."Document Type"::Order, PurchaseLine."Document Type"::Invoice);
    //             PurchaseLine.SetFilter("Job No.", Rec."Job No.");
    //             PurchaseLine.SetRange("Job Task No.", Rec."Job Task No.");
    //             PurchaseLine.SetFilter("NS_Committed Quantity", '<>%1', 0);
    //             PurchaseLine.CalcSums("NS_Committed Amount");
    //             rec."NS_Committed Costs Master Job" := PurchaseLine."NS_Committed Amount";
    //         end;


    //     if (Rec."Job Task Type" = rec."Job Task Type"::"Begin-Total") or (Rec."Job Task Type" = rec."Job Task Type"::Heading) then begin
    //         Rec."NS_Committed Costs Master Job" := 0;
    //         Rec.Modify();
    //     end;

    //     if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
    //         JTL.Reset();
    //         JTL.SetRange("Job No.", Rec."Job No.");
    //         JTL.SetFilter("Job Task No.", Rec.Totaling);
    //         if JTL.FindSet() then
    //             repeat
    //                 Rec."NS_Committed Costs Master Job" := 0;
    //                 Rec.Modify();
    //             until JTL.Next() = 0;
    //     end;

    //     if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
    //         JTL.Reset();
    //         JTL.SetRange("Job No.", Rec."Job No.");
    //         JTL.SetFilter("Job Task No.", Rec.Totaling);
    //         if JTL.FindSet() then
    //             repeat
    //                 ValMasterJob += JTL."NS_Committed Costs Master Job";
    //             until JTL.Next() = 0;

    //         Rec."NS_Committed Costs Master Job" := ValMasterJob;

    //     end;

    //     if (Rec."Job Task Type" = rec."Job Task Type"::Total) then
    //         Rec."NS_Committed Costs Master Job" := 0;

    //     if (Rec."Job Task Type" = rec."Job Task Type"::Total) then begin
    //         JTL.Reset();
    //         JTL.SetRange("Job No.", Rec."Job No.");
    //         JTL.SetRange("Job Task Type", JTL."Job Task Type"::"End-Total");
    //         if JTL.FindSet() then
    //             repeat
    //                 ValMasterJobTotal += JTL."NS_Committed Costs Master Job";
    //             until JTL.Next() = 0;

    //         Rec."NS_Committed Costs Master Job" := ValMasterJobTotal;
    //     end;


    //     Clear(JobNoFilter);
    //     ComittCostSubLevelVAl := 0;
    //     JobNoFilter := '@*' + format(Rec."Job No.") + '*';
    //     Clear(JobNo);
    //     JobRec.Reset();
    //     JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     JobRec.Reset();
    //     JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     JobRec.Reset();
    //     JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     JobRec.Reset();
    //     JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     IF JobNo <> '' then
    //         if (Rec."Job Task Type" = rec."Job Task Type"::Posting) then begin
    //             StrLength := StrLen(JobNo);
    //             JobNo := CopyStr(JobNo, 1, StrLength - 1);

    //             PurchaseLine.Reset();
    //             PurchaseLine.SetFilter("Document Type", '%1|%2', PurchaseLine."Document Type"::Order, PurchaseLine."Document Type"::Invoice);
    //             PurchaseLine.SetFilter("Job No.", JobNo);
    //             PurchaseLine.SetRange("Job Task No.", Rec."Job Task No.");
    //             PurchaseLine.SetFilter("NS_Committed Quantity", '<>%1', 0);
    //             PurchaseLine.CalcSums("NS_Committed Amount");
    //             rec."NS_Committed Costs Sub levels" := PurchaseLine."NS_Committed Amount";
    //         end;

    //     if (Rec."Job Task Type" = rec."Job Task Type"::"Begin-Total") or (Rec."Job Task Type" = rec."Job Task Type"::Heading) then
    //         Rec."NS_Committed Costs Sub levels" := 0;

    //     if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin

    //         StrLength := StrLen(JobNo);
    //         JobNo := CopyStr(JobNo, 1, StrLength - 1);

    //         JTL.Reset();
    //         JTL.SetRange("Job No.", JobNo);
    //         JTL.SetFilter("Job Task No.", Rec.Totaling);
    //         if JTL.FindSet() then
    //             repeat
    //                 Rec."NS_Committed Costs Sub levels" := 0;
    //                 Rec.Modify();
    //             until JTL.Next() = 0;
    //     end;

    //     if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
    //         StrLength := StrLen(JobNo);
    //         JobNo := CopyStr(JobNo, 1, StrLength - 1);

    //         JTL.Reset();
    //         JTL.SetRange("Job No.", Rec."Job No.");
    //         JTL.SetFilter("Job Task No.", Rec.Totaling);
    //         if JTL.FindSet() then
    //             repeat
    //                 ComittCostSubLevelVAl += JTL."NS_Committed Costs Sub levels";
    //             until JTL.Next() = 0;

    //         Rec."NS_Committed Costs Sub levels" := ComittCostSubLevelVAl;
    //         Rec.Modify();

    //     end;

    //     if (Rec."Job Task Type" = Rec."Job Task Type"::Total) then begin
    //         StrLength := StrLen(JobNo);
    //         JobNo := CopyStr(JobNo, 1, StrLength - 1);
    //         CommittedCostTTL := 0;
    //         JTL.Reset();
    //         JTL.SetFilter("Job No.", Rec."Job No.");
    //         JTL.SetRange("Job Task Type", JTL."Job Task Type"::Posting);
    //         if JTL.FindSet() then begin
    //             repeat
    //                 CommittedCostTTL += ABS(JTL."NS_Committed Costs Sub levels");
    //             until JTL.Next() = 0;

    //             Rec."NS_Committed Costs Sub levels" := CommittedCostTTL;
    //             Rec.Modify();
    //         end;
    //     end;

    //     rec."NS_Net Committed Costs" := rec."NS_Committed Costs Master Job" + rec."NS_Committed Costs Sub levels";
    //     Rec.Modify();
    //     //Calculate commited cost sub levels-end

    //     //Calculate Sub Levels Subcontract cost - start
    //     Clear(JobNoFilter);
    //     JobNoFilter := '@*' + format(Rec."Job No.") + '*';
    //     Clear(JobNo);
    //     JobRec.Reset();
    //     JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     JobRec.Reset();
    //     JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     JobRec.Reset();
    //     JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     JobRec.Reset();
    //     JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
    //     JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed); //PRJCTPR-11.GK.1.0 20Apr2023
    //     JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
    //     if JobRec.FindSet() then
    //         repeat
    //             JobNo += JobRec."No." + '|';
    //         until JobRec.Next() = 0;

    //     SubConSubLevelTTL := 0;
    //     SubConSubLevelEndTTL := 0;

    //     IF JobNo <> '' then
    //         if (Rec."Job Task Type" = rec."Job Task Type"::Posting) then begin
    //             StrLength := StrLen(JobNo);
    //             JobNo := CopyStr(JobNo, 1, StrLength - 1);
    //             SubcontractLine.Reset();
    //             SubcontractLine.SetFilter("NS_Job No.", JobNo);
    //             SubcontractLine.SetRange("NS_Job Task No.", Rec."Job Task No.");
    //             SubcontractLine.Setfilter(NS_Quantity, '<>%1', 0);
    //             SubcontractLine.CalcSums("NS_Total Cost");
    //             Rec."NS_Subcon. Value Sub Levels" := SubcontractLine."NS_Total Cost";
    //         end;


    //     if (Rec."Job Task Type" = rec."Job Task Type"::"Begin-Total") or (Rec."Job Task Type" = rec."Job Task Type"::Heading) then
    //         Rec."NS_Subcon. Value Sub Levels" := 0;

    //     if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin

    //         StrLength := StrLen(JobNo);
    //         JobNo := CopyStr(JobNo, 1, StrLength - 1);

    //         JTL.Reset();
    //         JTL.SetRange("Job No.", JobNo);
    //         JTL.SetFilter("Job Task No.", Rec.Totaling);
    //         if JTL.FindSet() then
    //             repeat
    //                 Rec."NS_Subcon. Value Sub Levels" := 0;
    //                 Rec.Modify();
    //             until JTL.Next() = 0;
    //     end;

    //     if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
    //         StrLength := StrLen(JobNo);
    //         JobNo := CopyStr(JobNo, 1, StrLength - 1);

    //         JTL.Reset();
    //         JTL.SetRange("Job No.", Rec."Job No.");
    //         JTL.SetFilter("Job Task No.", Rec.Totaling);
    //         if JTL.FindSet() then
    //             repeat
    //                 SubConSubLevelEndTTL += JTL."NS_Subcon. Value Sub Levels";
    //             until JTL.Next() = 0;

    //         Rec."NS_Subcon. Value Sub Levels" := SubConSubLevelEndTTL;
    //         Rec.Modify();

    //     end;

    //     if (Rec."Job Task Type" = Rec."Job Task Type"::Total) then begin
    //         JTL.Reset();
    //         JTL.SetFilter("Job No.", Rec."Job No.");
    //         JTL.SetRange("Job Task Type", JTL."Job Task Type"::Posting);
    //         if JTL.FindSet() then begin
    //             repeat
    //                 SubConSubLevelTTL += JTL."NS_Subcon. Value Sub Levels";
    //             until JTL.Next() = 0;

    //             Rec."NS_Subcon. Value Sub Levels" := SubConSubLevelTTL;
    //             Rec.Modify();
    //         end;
    //     end;

    //     rec."NS_Net Subcontract Value" := rec."NS_Subcontract Value" + rec."NS_Subcon. Value Sub Levels";
    //     rec.Modify();
    //     //Calculate Sub Levels Subcontract cost - start

    //     Commit();
    // end;
    var
        JobNo: Text;
        StrLength: Integer;
        NS_ChangeorderNo: Text; //PE-193.PS.3.0 03Jan2024
    begin
        //PRJ-1748.SD.1.0 - Start
        Clear(JobNo);
        Clear(JobNoFilter);
        JobNoFilter := '@*' + Format(Rec."Job No.") + '*';
        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        if JobRec.IsEmpty then begin
            Rec."NS_Change Orders" := 0;
            Rec."NS_Usage TotCost Change Order" := 0;
            Rec."NS_Contract Price Sub Levels" := 0;
            Rec."NS_Invoiced Price Sub Levels" := 0;
            Rec."NS_Committed Costs Sub levels" := 0;
            Rec."NS_Subcon. Value Sub Levels" := 0;
            Rec."NS_Change Request Billable" := 0; //PE-193.PS.3.0 10Jan2024
            Rec."NS_Change Request Budget" := 0;//PE-193.PS.3.0 10Jan2024
            Rec.Modify();
        end;
        //PRJ-1748.SD.1.0 - End

        Clear(TotalTaskNo);
        JobTaskrec_1.Reset();
        JobTaskrec_1.SetRange("Job No.", Rec."Job No.");
        JobTaskrec_1.SetRange("Job Task Type", JobTaskrec_1."Job Task Type"::Total);
        IF JobTaskrec_1.FindLast() then
            TotalTaskNo := JobTaskrec_1."Job Task No.";

        //Change Orders-        
        Clear(JobNo);
        Clear(JobNoFilter);
        JobNoFilter := '@*' + Format(Rec."Job No.") + '*';
        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        IF JobNo <> '' then begin
            if (Rec."Job Task Type" = rec."Job Task Type"::Posting) OR (Rec."Job Task Type" = rec."Job Task Type"::Total) OR (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
                Rec."NS_Change Orders" := 0;
                StrLength := StrLen(JobNo);
                if StrLength <> 0 then
                    JobNo := CopyStr(JobNo, 1, StrLength - 1);

                if JobNo <> '' then begin
                    JobPlanningLineRec.Reset();
                    JobPlanningLineRec.SetFilter("Job No.", JobNo);
                    JobPlanningLineRec.SetRange("Job Task No.", Rec."Job Task No.");
                    JobPlanningLineRec.SetFilter("Line Type", '%1..%2', JobPlanningLineRec."Line Type"::Budget, JobPlanningLineRec."Line Type"::"Both Budget and Billable");
                    JobPlanningLineRec.setrange("Schedule Line", true);
                    JobPlanningLineRec.CalcSums("Total Cost (LCY)");
                    Rec."NS_Change Orders" := JobPlanningLineRec."Total Cost (LCY)";
                end;
            end;
        end
        else
            Rec."NS_Change Orders" := 0;


        if (Rec."Job Task Type" = Rec."Job Task Type"::"Begin-Total") or (Rec."Job Task Type" = rec."Job Task Type"::Heading) then
            Rec."NS_Change Orders" := 0;

        if (Rec."Job Task Type" = Rec."Job Task Type"::"End-Total") OR (Rec."Job Task Type" = rec."Job Task Type"::Total) then begin
            Rec."NS_Change Orders" := 0;
            JTL.Reset();
            JTL.SetFilter("Job No.", JobNo);
            JTL.SetFilter("Job Task No.", Rec."Job Task No.");
            if JTL.FindSet() then
                repeat
                    JTL.CalcFields("Schedule (Total Cost)");
                    Rec."NS_Change Orders" += JTL."Schedule (Total Cost)";
                until JTL.Next() = 0;

            if JobNo = '' then
                Rec."NS_Change Orders" := 0;
        end;
        Rec.Modify();

        //Net Budget
        Rec."NS_Net Budget" := Rec."Schedule (Total Cost)" + Rec."NS_Change Orders";
        Rec.Modify();

        //Committed Cost
        Clear(JobNoFilter);
        JobNoFilter := '@*' + Format(Rec."Job No.") + '*';
        Clear(JobNo);
        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobNo += Rec."Job No." + '|';

        IF JobNo <> '' then begin
            if Rec."Job Task Type" = Rec."Job Task Type"::Posting then begin
                StrLength := StrLen(JobNo);
                JobNo := CopyStr(JobNo, 1, StrLength - 1);

                PurchaseLine.Reset();
                PurchaseLine.SetFilter("Document Type", '%1|%2', PurchaseLine."Document Type"::Order, PurchaseLine."Document Type"::Invoice);
                PurchaseLine.SetFilter("Job No.", JobNo);
                PurchaseLine.SetRange("Job Task No.", Rec."Job Task No.");
                PurchaseLine.SetFilter("NS_Committed Quantity", '<>%1', 0);
                if PurchaseLine.FindSet() then begin
                    PurchaseLine.CalcSums("NS_Committed Amount");
                    Rec."NS_Committed Costs" := PurchaseLine."NS_Committed Amount";
                end;
            end else begin
                StrLength := StrLen(JobNo);
                JobNo := CopyStr(JobNo, 1, StrLength - 1);

                PurchaseLine.Reset();
                PurchaseLine.SetFilter("Document Type", '%1|%2', PurchaseLine."Document Type"::Order, PurchaseLine."Document Type"::Invoice);
                PurchaseLine.SetFilter("Job No.", JobNo);
                PurchaseLine.SetFilter("NS_Committed Quantity", '<>%1', 0);
                if PurchaseLine.FindSet() then begin
                    PurchaseLine.CalcSums("NS_Committed Amount");
                    Rec."NS_Committed Costs" := PurchaseLine."NS_Committed Amount";
                end;
            end;
            Rec.Modify();
        end else
            Rec."NS_Committed Costs" := 0;

        //Get Subcontract value master Job
        SubConTrct := 0;
        subconttl := 0;
        IF Rec."Job No." <> '' then
            if Rec."Job Task Type" = Rec."Job Task Type"::Posting then begin
                SubcontractLine.Reset();
                SubcontractLine.SetFilter("NS_Job No.", rec."Job No.");
                SubcontractLine.SetRange("NS_Job Task No.", Rec."Job Task No.");
                SubcontractLine.Setfilter(NS_Quantity, '<>%1', 0);
                SubcontractLine.CalcSums("NS_Total Cost");
                Rec."NS_Subcontract Value" := SubcontractLine."NS_Total Cost";
            end;

        if (Rec."Job Task Type" = rec."Job Task Type"::"Begin-Total") or (Rec."Job Task Type" = rec."Job Task Type"::Heading) then begin
            Rec."NS_Subcontract Value" := 0;
            Rec.Modify();
        end;

        if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin

            JTL.Reset();
            JTL.SetFilter("Job No.", Rec."Job No.");
            JTL.SetFilter("Job Task No.", Rec.Totaling);
            if JTL.FindSet() then
                repeat
                    Rec."NS_Subcontract Value" := 0;
                    Rec.Modify();
                until JTL.Next() = 0;
        end;

        if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
            JTL.Reset();
            JTL.SetFilter("Job No.", Rec."Job No.");
            JTL.SetFilter("Job Task No.", Rec.Totaling);
            if JTL.FindSet() then
                repeat
                    SubConTrct += JTL."NS_Subcontract Value";
                until JTL.Next() = 0;

            Rec."NS_Subcontract Value" := SubConTrct;
        end;

        if (Rec."Job Task Type" = rec."Job Task Type"::Total) then
            Rec."NS_Subcontract Value" := 0;

        if (Rec."Job Task Type" = rec."Job Task Type"::Total) then begin
            JTL.Reset();
            JTL.SetRange("Job No.", Rec."Job No.");
            JTL.SetFilter("Job Task No.", Rec.Totaling);
            JTL.SetRange("Job Task Type", JTL."Job Task Type"::Posting);
            if JTL.FindSet() then
                repeat
                    subconttl += JTL."NS_Subcontract Value";
                until JTL.Next() = 0;

            Rec."NS_Subcontract Value" := subconttl;
        end;
        Rec.Modify();

        //Add Usage Actual Cost for sub levels-Start
        Clear(JobNo);
        Clear(JobNoFilter);
        JobNoFilter := '@*' + Format(Rec."Job No.") + '*';
        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        IF JobNo <> '' then begin
            if (Rec."Job Task Type" = rec."Job Task Type"::Posting) OR (Rec."Job Task Type" = rec."Job Task Type"::Total) OR (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
                StrLength := StrLen(JobNo);
                if StrLength <> 0 then
                    JobNo := CopyStr(JobNo, 1, StrLength - 1);

                if JobNo <> '' then begin
                    NSJobLedgerEntry2.Reset();
                    NSJobLedgerEntry2.SetFilter("Job No.", JobNo);
                    NSJobLedgerEntry2.SetFilter("Job Task No.", '%1', Rec."Job Task No.");
                    NSJobLedgerEntry2.SetFilter("Entry Type", '%1', NSJobLedgerEntry2."Entry Type"::Usage);
                    NSJobLedgerEntry2.SetFilter(quantity, '<>%1', 0);
                    NSJobLedgerEntry2.CalcSums("Total Cost (LCY)");
                    Rec."NS_Usage TotCost Change Order" := NSJobLedgerEntry2."Total Cost (LCY)";
                end;
            end else
                Rec."NS_Usage TotCost Change Order" := 0;
        end;

        if (Rec."Job Task Type" = rec."Job Task Type"::"Begin-Total") or (Rec."Job Task Type" = rec."Job Task Type"::Heading) then
            Rec."NS_Usage TotCost Change Order" := 0;

        if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") OR (Rec."Job Task Type" = rec."Job Task Type"::Total) then begin
            Rec."NS_Usage TotCost Change Order" := 0;
            JTL.Reset();
            JTL.SetFilter("Job No.", JobNo);
            JTL.SetFilter("Job Task No.", Rec."Job Task No.");
            if JTL.FindSet() then
                repeat
                    JTL.CalcFields("Usage (Total Cost)");
                    Rec."NS_Usage TotCost Change Order" += JTL."Usage (Total Cost)";
                until JTL.Next() = 0;

            if JobNo = '' then
                Rec."NS_Usage TotCost Change Order" := 0;
        end;

        if JobNo = '' then
            Rec."NS_Usage TotCost Change Order" := 0;

        rec."NS_Usage Total Actual Cost" := Rec."Usage (Total Cost)" + Rec."NS_Usage TotCost Change Order";
        Rec.Modify();

        //Sub Levels Jobs Contract Price start
        Clear(JobNo);
        Clear(JobNoFilter);
        JobNoFilter := '@*' + Format(Rec."Job No.") + '*';
        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        ContractPriceSublvl := 0;
        ContrctPriceSublvlEndTTL := 0;
        IF JobNo <> '' then begin
            if Rec."Job Task Type" = rec."Job Task Type"::Posting then begin
                StrLength := StrLen(JobNo);
                if StrLength <> 0 then
                    JobNo := CopyStr(JobNo, 1, StrLength - 1);
                Clear(rec."NS_Contract Price Sub Levels");//Prjctpr-398 AT 01.03July2024
                JobPlanningLineRec.Reset();
                JobPlanningLineRec.SetFilter("Job No.", JobNo);
                JobPlanningLineRec.SetRange("Job Task No.", Rec."Job Task No.");
                JobPlanningLineRec.SetFilter("Line Type", '%1|%2', JobPlanningLineRec."Line Type"::Billable, JobPlanningLineRec."Line Type"::"Both Budget and Billable");
                //Prjctpr-398 AT 01.03July2024 start
                if JobPlanningLineRec.FindSet() then
                    repeat
                        // JobPlanningLineRec.setrange("Schedule Line", false);
                        //JobPlanningLineRec.CalcSums("Total Price (LCY)");
                        // rec."NS_Contract Price Sub Levels" := JobPlanningLineRec."Total Price (LCY)";////Prjctpr-398 AT 01.03July2024
                        rec."NS_Contract Price Sub Levels" += JobPlanningLineRec."Line Amount (LCY)";////Prjctpr-398 AT 01.03July2024
                    until JobPlanningLineRec.Next() = 0;
                //Prjctpr-398 AT 01.03July2024 end                                                                       //Prjctpr-398 AT 01.03July2024 
                Rec.Modify();
            end;
        end else
            Rec."NS_Contract Price Sub Levels" := 0;

        if (Rec."Job Task Type" = rec."Job Task Type"::"Begin-Total") or (Rec."Job Task Type" = rec."Job Task Type"::Heading) then
            Rec."NS_Contract Price Sub Levels" := 0;

        if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
            StrLength := StrLen(JobNo);
            if StrLength <> 0 then
                JobNo := CopyStr(JobNo, 1, StrLength - 1);

            JTL.Reset();
            JTL.SetFilter("Job No.", JobNo);
            JTL.SetFilter("Job Task No.", Rec.Totaling);
            if JTL.FindSet() then
                repeat
                    Rec."NS_Contract Price Sub Levels" := 0;
                    Rec.Modify();
                until JTL.Next() = 0;
        end;

        if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
            StrLength := StrLen(JobNo);
            if StrLength <> 0 then
                JobNo := CopyStr(JobNo, 1, StrLength - 1);

            JTL.Reset();
            JTL.SetFilter("Job No.", Rec."Job No.");
            JTL.SetFilter("Job Task No.", Rec.Totaling);
            if JTL.FindSet() then
                repeat
                    ContrctPriceSublvlEndTTL += JTL."NS_Contract Price Sub Levels";
                until JTL.Next() = 0;

            Rec."NS_Contract Price Sub Levels" := ContrctPriceSublvlEndTTL;
            Rec.Modify();
        end;

        if (Rec."Job Task Type" = Rec."Job Task Type"::Total) and (Rec.Totaling <> '') then begin
            JTL.Reset();
            JTL.SetFilter("Job No.", Rec."Job No.");
            JTL.SetFilter("Job Task No.", Rec.Totaling);
            JTL.SetRange("Job Task Type", JTL."Job Task Type"::Posting);
            if JTL.FindSet() then begin
                repeat
                    ContractPriceSublvl += JTL."NS_Contract Price Sub Levels";
                until JTL.Next() = 0;

                Rec."NS_Contract Price Sub Levels" := ContractPriceSublvl;
                Rec.Modify();
            end;
        end
        else
            if (Rec."Job Task Type" = Rec."Job Task Type"::Total) and (Rec.Totaling = '') then
                Rec."NS_Contract Price Sub Levels" := 0;

        rec."NS_Net Total Contract Price" := Rec."Contract (Total Price)" + Rec."NS_Contract Price Sub Levels";
        Rec.Modify();
        //Sub Levels Jobs Contract Price end

        //Sub level Invoices Amount - start
        Clear(JobNo);
        Clear(JobNoFilter);
        JobNoFilter := '@*' + format(Rec."Job No.") + '*';
        JobRec.Reset();
        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        IF JobNo <> '' then begin
            if (Rec."Job Task Type" = rec."Job Task Type"::Posting) OR (Rec."Job Task Type" = rec."Job Task Type"::Total) OR (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
                StrLength := StrLen(JobNo);
                if StrLength <> 0 then
                    JobNo := CopyStr(JobNo, 1, StrLength - 1);
                if JobNo <> '' then begin
                    NSJobLedgerEntry2.Reset();
                    NSJobLedgerEntry2.SetFilter("Job No.", JobNo);
                    NSJobLedgerEntry2.SetFilter("Job Task No.", '%1', Rec."Job Task No.");
                    NSJobLedgerEntry2.SetFilter("Entry Type", '%1', NSJobLedgerEntry2."Entry Type"::Sale);
                    NSJobLedgerEntry2.SetFilter(quantity, '<>%1', 0);
                    NSJobLedgerEntry2.CalcSums("Total Price (LCY)");
                    rec."NS_Invoiced Price Sub Levels" := ABS(NSJobLedgerEntry2."Total Price (LCY)");
                end;
            end;
        end else
            Rec."NS_Invoiced Price Sub Levels" := 0;

        if (Rec."Job Task Type" = rec."Job Task Type"::"Begin-Total") or (Rec."Job Task Type" = rec."Job Task Type"::Heading) then
            Rec."NS_Invoiced Price Sub Levels" := 0;

        if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") or (Rec."Job Task Type" = rec."Job Task Type"::Total) then begin
            Rec."NS_Invoiced Price Sub Levels" := 0;
            JTL.Reset();
            JTL.SetFilter("Job No.", JobNo);
            JTL.SetFilter("Job Task No.", Rec.Totaling);
            JTL.SetFilter("Job Task No.", Rec."Job Task No.");
            if JTL.FindSet() then
                repeat
                    JTL.CalcFields("Contract (Invoiced Price)");
                    Rec."NS_Invoiced Price Sub Levels" += JTL."Contract (Invoiced Price)";
                until JTL.Next() = 0;

            if JobNo = '' then
                Rec."NS_Invoiced Price Sub Levels" := 0;
        end;
        //PE-29.DK.1.0 Start commenting Line due to Increase the value on "NS_Invoiced Price Sub Levels"
        // if Rec."Job Task Type" = Rec."Job Task Type"::Total then begin
        //     JTL.Reset();
        //     JTL.SetFilter("Job No.", JobNo);
        //     JTL.SetFilter("Job Task No.", Rec.Totaling);
        //     JTL.SetFilter("Job Task No.", Rec."Job Task No.");
        //      if JTL.FindSet() then
        //          repeat
        //             JTL.CalcFields("Contract (Invoiced Price)");
        //             Rec."NS_Invoiced Price Sub Levels" += JTL."Contract (Invoiced Price)";
        //         until JTL.Next() = 0;
        //     if JobNo = '' then
        //         Rec."NS_Invoiced Price Sub Levels" := 0;
        // end;
        //PE-29.DK.1.0  commenting End
        if JobNo = '' then
            Rec."NS_Invoiced Price Sub Levels" := 0;

        Rec."NS_Net Invoiced Price" := rec."NS_Invoiced Price Sub Levels" + ABS(Rec."Contract (Invoiced Price)");
        Rec.Modify();
        Rec."NS_Unbilled Revenue New" := rec."NS_Net Total Contract Price" - Rec."NS_Net Invoiced Price";
        Rec."NS_Remaining (Total Cost) New" := rec."NS_Net Budget" - Rec."NS_Usage Total Actual Cost";
        Rec.Modify();

        //Calculate Committed Cost Sub Levels-Start
        ValMasterJob := 0;
        ValMasterJobTotal := 0;
        ComitAmtOrderInvoice := 0;
        IF rec."Job No." <> '' then
            if (Rec."Job Task Type" = rec."Job Task Type"::Posting) OR (Rec."Job Task Type" = rec."Job Task Type"::Total) OR (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
                PurchaseLine.Reset();
                PurchaseLine.SetFilter("Document Type", '%1|%2', PurchaseLine."Document Type"::Order, PurchaseLine."Document Type"::Invoice);
                PurchaseLine.SetFilter("Job No.", Rec."Job No.");
                PurchaseLine.SetRange("Job Task No.", Rec."Job Task No.");
                PurchaseLine.SetFilter("NS_Committed Quantity", '<>%1', 0);
                PurchaseLine.CalcSums("NS_Committed Amount");
                ComitAmtOrderInvoice := PurchaseLine."NS_Committed Amount";
                PurchaseLine.Reset();
                PurchaseLine.SetFilter("Document Type", '%1|%2', PurchaseLine."Document Type"::"Credit Memo", PurchaseLine."Document Type"::"Return Order");
                PurchaseLine.SetFilter("Job No.", Rec."Job No.");
                PurchaseLine.SetRange("Job Task No.", Rec."Job Task No.");
                PurchaseLine.SetFilter("NS_Committed Quantity", '<>%1', 0);
                PurchaseLine.CalcSums("NS_Committed Amount");
                rec."NS_Committed Costs Master Job" := ComitAmtOrderInvoice - PurchaseLine."NS_Committed Amount";

            end;


        if (Rec."Job Task Type" = rec."Job Task Type"::"Begin-Total") or (Rec."Job Task Type" = rec."Job Task Type"::Heading) then begin
            Rec."NS_Committed Costs Master Job" := 0;
            Rec.Modify();
        end;

        if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
            JTL.Reset();
            JTL.SetFilter("Job No.", Rec."Job No.");
            JTL.SetFilter("Job Task No.", Rec.Totaling);
            if JTL.FindSet() then
                repeat
                    Rec."NS_Committed Costs Master Job" := 0;
                    Rec.Modify();
                until JTL.Next() = 0;
        end;

        if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
            JTL.Reset();
            JTL.SetFilter("Job No.", Rec."Job No.");
            JTL.SetFilter("Job Task No.", Rec.Totaling);
            if JTL.FindSet() then
                repeat
                    ValMasterJob += JTL."NS_Committed Costs Master Job";
                until JTL.Next() = 0;
            Rec."NS_Committed Costs Master Job" := ValMasterJob;

        end;

        if (Rec."Job Task Type" = rec."Job Task Type"::Total) then
            Rec."NS_Committed Costs Master Job" := 0;

        if (Rec."Job Task Type" = rec."Job Task Type"::Total) then begin

            // StrLength := StrLen(JobNo);
            // if StrLength <> 0 then
            //     JobNo := CopyStr(JobNo, 1, StrLength - 1);

            JTL.Reset();
            JTL.SetFilter("Job No.", Rec."Job No.");
            JTL.SetFilter("Job Task No.", Rec.Totaling);
            JTL.SetRange("Job Task Type", JTL."Job Task Type"::Posting);
            if JTL.FindSet() then
                repeat
                    ValMasterJobTotal += JTL."NS_Committed Costs Master Job";
                until JTL.Next() = 0;

            Rec."NS_Committed Costs Master Job" := ValMasterJobTotal;
        end;

        Clear(JobNoFilter);
        ComittCostSubLevelVAl := 0;
        JobNoFilter := '@*' + format(Rec."Job No.") + '*';
        Clear(JobNo);
        JobRec.Reset();
        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        IF JobNo <> '' then begin
            if (Rec."Job Task Type" = rec."Job Task Type"::Posting) then begin
                StrLength := StrLen(JobNo);
                if StrLength <> 0 then
                    JobNo := CopyStr(JobNo, 1, StrLength - 1);
                CommittedAmount := 0;
                PurchaseLine.Reset();
                PurchaseLine.SetFilter("Document Type", '%1|%2', PurchaseLine."Document Type"::Order, PurchaseLine."Document Type"::Invoice);
                PurchaseLine.SetFilter("Job No.", JobNo);
                PurchaseLine.SetRange("Job Task No.", Rec."Job Task No.");
                PurchaseLine.SetFilter("NS_Committed Quantity", '<>%1', 0);
                PurchaseLine.CalcSums("NS_Committed Amount");
                CommittedAmount := PurchaseLine."NS_Committed Amount";

                //FGH-67
                PurchaseLine.Reset();
                PurchaseLine.SetFilter("Document Type", '%1|%2', PurchaseLine."Document Type"::"Credit Memo", PurchaseLine."Document Type"::"Return Order");
                PurchaseLine.SetFilter("Job No.", JobNo);
                PurchaseLine.SetRange("Job Task No.", Rec."Job Task No.");
                PurchaseLine.SetFilter("NS_Committed Quantity", '<>%1', 0);
                PurchaseLine.CalcSums("NS_Committed Amount");
                rec."NS_Committed Costs Sub levels" := CommittedAmount - PurchaseLine."NS_Committed Amount";
            end;
        end else
            Rec."NS_Committed Costs Sub levels" := 0;

        if (Rec."Job Task Type" = rec."Job Task Type"::"Begin-Total") or (Rec."Job Task Type" = rec."Job Task Type"::Heading) then
            Rec."NS_Committed Costs Sub levels" := 0;

        if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin

            StrLength := StrLen(JobNo);
            if StrLength <> 0 then
                JobNo := CopyStr(JobNo, 1, StrLength - 1);

            JTL.Reset();
            JTL.SetFilter("Job No.", JobNo);
            JTL.SetFilter("Job Task No.", Rec.Totaling);
            if JTL.FindSet() then
                repeat
                    Rec."NS_Committed Costs Sub levels" := 0;
                    Rec.Modify();
                until JTL.Next() = 0;
        end;

        if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
            StrLength := StrLen(JobNo);
            if StrLength <> 0 then
                JobNo := CopyStr(JobNo, 1, StrLength - 1);

            JTL.Reset();
            JTL.SetFilter("Job No.", Rec."Job No.");
            JTL.SetFilter("Job Task No.", Rec.Totaling);
            if JTL.FindSet() then
                repeat
                    ComittCostSubLevelVAl += JTL."NS_Committed Costs Sub levels";
                until JTL.Next() = 0;

            Rec."NS_Committed Costs Sub levels" := ComittCostSubLevelVAl;
            Rec.Modify();
        end;

        if (Rec."Job Task Type" = Rec."Job Task Type"::Total) then begin
            CommittedCostTTL := 0;
            JTL.Reset();
            JTL.SetFilter("Job No.", Rec."Job No.");
            JTL.SetFilter("Job Task No.", Rec.Totaling);
            JTL.SetRange("Job Task Type", JTL."Job Task Type"::Posting);
            if JTL.FindSet() then begin
                repeat
                    CommittedCostTTL += (JTL."NS_Committed Costs Sub levels");
                until JTL.Next() = 0;
                Rec."NS_Committed Costs Sub levels" := CommittedCostTTL;
                Rec.Modify();
            end;
        end;

        rec."NS_Net Committed Costs" := rec."NS_Committed Costs Master Job" + rec."NS_Committed Costs Sub levels";
        Rec.Modify();
        //Calculate commited cost sub levels-end

        //Calculate Sub Levels Subcontract cost - start
        Clear(JobNoFilter);
        JobNoFilter := '@*' + format(Rec."Job No.") + '*';
        Clear(JobNo);
        JobRec.Reset();
        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        SubConSubLevelTTL := 0;
        SubConSubLevelEndTTL := 0;

        IF JobNo <> '' then begin
            if (Rec."Job Task Type" = rec."Job Task Type"::Posting) then begin
                StrLength := StrLen(JobNo);
                if StrLength <> 0 then
                    JobNo := CopyStr(JobNo, 1, StrLength - 1);
                SubcontractLine.Reset();
                SubcontractLine.SetFilter("NS_Job No.", JobNo);
                SubcontractLine.SetRange("NS_Job Task No.", Rec."Job Task No.");
                SubcontractLine.Setfilter(NS_Quantity, '<>%1', 0);
                SubcontractLine.CalcSums("NS_Total Cost");
                Rec."NS_Subcon. Value Sub Levels" := SubcontractLine."NS_Total Cost";
            end;
        end else
            Rec."NS_Subcon. Value Sub Levels" := 0;

        if (Rec."Job Task Type" = rec."Job Task Type"::"Begin-Total") or (Rec."Job Task Type" = rec."Job Task Type"::Heading) then
            Rec."NS_Subcon. Value Sub Levels" := 0;

        if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
            StrLength := StrLen(JobNo);
            if StrLength <> 0 then
                JobNo := CopyStr(JobNo, 1, StrLength - 1);

            JTL.Reset();
            JTL.SetFilter("Job No.", JobNo);
            JTL.SetFilter("Job Task No.", Rec.Totaling);
            if JTL.FindSet() then
                repeat
                    Rec."NS_Subcon. Value Sub Levels" := 0;
                    Rec.Modify();
                until JTL.Next() = 0;
        end;

        if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
            StrLength := StrLen(JobNo);
            if StrLength <> 0 then
                JobNo := CopyStr(JobNo, 1, StrLength - 1);

            JTL.Reset();
            JTL.SetFilter("Job No.", Rec."Job No.");
            JTL.SetFilter("Job Task No.", Rec.Totaling);
            if JTL.FindSet() then
                repeat
                    SubConSubLevelEndTTL += JTL."NS_Subcon. Value Sub Levels";
                until JTL.Next() = 0;
            Rec."NS_Subcon. Value Sub Levels" := SubConSubLevelEndTTL;
            Rec.Modify();

        end;

        if (Rec."Job Task Type" = Rec."Job Task Type"::Total) then begin
            JTL.Reset();
            JTL.SetFilter("Job No.", Rec."Job No.");
            JTL.SetFilter("Job Task No.", Rec.Totaling);
            JTL.SetRange("Job Task Type", JTL."Job Task Type"::Posting);
            if JTL.FindSet() then begin
                repeat
                    SubConSubLevelTTL += JTL."NS_Subcon. Value Sub Levels";
                until JTL.Next() = 0;

                Rec."NS_Subcon. Value Sub Levels" := SubConSubLevelTTL;
                Rec.Modify();
            end;
        end;

        rec."NS_Net Subcontract Value" := rec."NS_Subcontract Value" + rec."NS_Subcon. Value Sub Levels";
        rec.Modify();

        //PRJCTPR-305.PS.1.0 03Jan2024 Start
        Rec."NS_Change Request Budget" := 0;
        Rec."NS_Change Request Billable" := 0;
        Rec.Modify();
        NS_EndTotalCost := 0;
        NS_EndTotalPrice := 0;

        Clear(JobNoFilter);
        JobNoFilter := '@*' + format(Rec."Job No.") + '*';
        Clear(NS_ChangeorderNo);
        JobRec.Reset();
        JobRec.Setfilter("NS_Change Request to Job No.", '%1', JobNoFilter);
        JobRec.SetFilter(Status, '%1|%2', JobRec.Status::Open, JobRec.Status::Planning);
        JobRec.SetFilter("NS_Manager Job Status", '<>%1', JobRec."NS_Manager Job Status"::Completed);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Request");
        if JobRec.FindSet() then
            repeat
                NS_ChangeorderNo += JobRec."No." + '|';
            until JobRec.Next() = 0;
        StrLength := StrLen(NS_ChangeorderNo);
        if StrLength <> 0 then
            NS_ChangeorderNo := CopyStr(NS_ChangeorderNo, 1, StrLength - 1);
        if NS_ChangeorderNo <> '' then begin
            JobPlanningLineRec.Reset();
            JobPlanningLineRec.setfilter("Job No.", NS_ChangeorderNo);
            JobPlanningLineRec.SetRange("Job Task No.", Rec."Job Task No.");
            if JobPlanningLineRec.FindSet() then begin
                JobPlanningLineRec.CalcSums("Total Cost (LCY)");
                JobPlanningLineRec.CalcSums("Total Price (LCY)");
                Rec."NS_Change Request Budget" := JobPlanningLineRec."Total Cost (LCY)";
                Rec."NS_Change Request Billable" := JobPlanningLineRec."Total Price (LCY)";
                NS_EndTotalCost := JobPlanningLineRec."Total Cost (LCY)";
                NS_EndTotalPrice := JobPlanningLineRec."Total Price (LCY)";
                Rec.Modify();
            end;
        End;

        if (Rec."Job Task Type" = rec."Job Task Type"::"Begin-Total") or (Rec."Job Task Type" = rec."Job Task Type"::Heading) then begin
            Rec."NS_Change Request Budget" := 0;
            Rec."NS_Change Request Billable" := 0;
            Rec.Modify();
        end;


        if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
            if StrLength <> 0 then
                NS_ChangeorderNo := CopyStr(NS_ChangeorderNo, 1, StrLength - 1);


            JTL.Reset();
            JTL.SetFilter("Job No.", NS_ChangeorderNo);
            JTL.setfilter("Job Task No.", Rec.Totaling);
            if JTL.FindSet() then
                repeat
                    Rec."NS_Change Request Budget" := 0;
                    Rec."NS_Change Request Billable" := 0;
                    Rec.Modify();
                until JTL.Next() = 0;
        end;



        if (Rec."Job Task Type" = rec."Job Task Type"::"End-Total") then begin
            if StrLength <> 0 then
                NS_ChangeorderNo := CopyStr(NS_ChangeorderNo, 1, StrLength - 1);

            NS_TotalCost := 0;
            NS_TotalPrice := 0;

            JTL.Reset();
            JTL.SetFilter("Job No.", Rec."Job No.");
            JTL.SetFilter("Job Task No.", Rec.Totaling);
            if JTL.FindSet() then begin
                repeat
                    NS_TotalCost += JTL."NS_Change Request Budget";
                    NS_TotalPrice += JTL."NS_Change Request Billable";
                until JTL.Next() = 0;
                Rec."NS_Change Request Budget" := NS_TotalCost;
                Rec."NS_Change Request Billable" := NS_TotalPrice;
                Rec.Modify();
            End;
        end;



        if (Rec."Job Task Type" = Rec."Job Task Type"::Total) and (Rec.Totaling <> '') then begin
            NS_EndTotalCost := 0;
            NS_EndTotalPrice := 0;
            JTL.Reset();
            JTL.setfilter("Job No.", Rec."Job No.");
            JTL.setfilter("Job Task No.", Rec.Totaling);
            JTL.SetRange("Job Task Type", JTL."Job Task Type"::Posting);
            if JTL.FindSet() then begin
                repeat
                    NS_EndTotalCost += JTL."NS_Change Request Budget";
                    NS_EndTotalPrice += JTL."NS_Change Request Billable";
                until JTL.Next() = 0;

                Rec."NS_Change Request Budget" := NS_EndTotalCost;
                Rec."NS_Change Request Billable" := NS_EndTotalPrice;
                Rec.Modify();
            end;
        end;


        //PRJCTPR-305.PS.1.0 03Jan2024 End 

        //Calculate Sub Levels Subcontract cost - start

        // if Rec."NS_Net Budget" > (Rec."NS_Usage Total Actual Cost" + Rec."NS_Net Committed Costs") then begin
        //     Rec."Projected Cost" := Rec."NS_Net Budget";
        //     Rec.Modify()
        // end else begin
        //     Rec."Projected Cost" := (Rec."NS_Usage Total Actual Cost" + Rec."NS_Net Committed Costs");
        //     Rec.Modify();
        // end;

        // JobForecast.Reset();
        // JobForecast.SetRange("NS_Job No.", Rec."Job No.");
        // JobForecast.SetRange("NS_Job Task No.", Rec."Job Task No.");
        // if JobForecast.FindFirst() then
        //     repeat
        //         Rec."Forecast Cost to Complete" := JobForecast."NS_Forecasted Completed Cost";
        //         Rec.Modify();
        //     until JobForecast.Next() = 0;

        // if Rec."Forecast Cost to Complete" > Rec."Projected Cost" then begin
        //     Rec."Total Projected Cost" := Rec."Forecast Cost to Complete";
        //     Rec.Modify();
        // end else begin
        //     Rec."Total Projected Cost" := Rec."Projected Cost";
        //     Rec.Modify();
        // end;

        Commit();

    end;
    //PE-29.Dk.1.0 End 10May2023
    var

        JobRec: Record Job;
        //PRJCTPR-305.PS.1.0 23Feb2024 Start
        NS_ChangeorderJobRec: Record Job;// PE-193.PS.3.0 03Jan2023
        NS_TotalCost: Decimal;
        NS_TotalPrice: Decimal;
        NS_EndTotalCost: Decimal;
        NS_EndTotalPrice: Decimal;
        //PRJCTPR-305.PS.1.0 23Feb2024 End 

        JobForecast: Record "NS_Job Forecast";//PE-29.Dk.1.0
        JobPlanningLineRec: Record "Job Planning Line";
        JobTaskrec: Record "Job Task";
        JobLedgerEntry: Record "Job Ledger Entry";
        JobPlnLineTemp: Record "Job Planning Line" temporary;
        JobTaskrec_1: Record "Job Task";
        PurchaseLine: Record "Purchase Line";
        SubcontractLine: Record "NS_Subcontract Lines";
        NSJobLedgerEntry2: Record "Job Ledger Entry";
        UsageCostSublevel: Decimal;
        UsageCostMaster: Decimal;
        BillableTotalCostSublevel: Decimal;
        BillableTotalCostMaster: Decimal;
        BillInvPriceMaster: Decimal;
        BillInvPriceSublevel: Decimal;
        RemTotalcostMaster: Decimal;
        RemTotalCostsublevel: Decimal;
        RemTotalPriceMaster: Decimal;
        RemTotalPriceSublevel: Decimal;
        ChangeOrdersVar: Decimal;
        ReallocationVar: Decimal;
        NetBudgetVar: Decimal;

        myInt: Integer;
        NewJobNo: Code[30];


        JTL: Record "Job Task";
        ComittCostSubLevelVAl: Decimal;

        CommittedCostTTL: Decimal;
        ValMasterJob: Decimal;
        ValMasterJobTotal: Decimal;
        SubConTrct: Decimal;
        subconttl: Decimal;
        SubConSubLevelTTL: Decimal;
        SubConSubLevelEndTTL: Decimal;
        ContractPriceSublvl: Decimal;
        ContrctPriceSublvlEndTTL: Decimal;
        TotalTaskNo: Code[50];
        JobNoFilter: Code[30];
        ComitAmtOrderInvoice: Decimal;
        CommittedAmount: Decimal;


    /// <summary>
    /// CalculateAllCustomFields.
    /// </summary>
    /// <param name="Rec">Record "Job Task".</param>
    procedure CalculateAllCustomFields(Rec: Record "Job Task")
    begin

    end;
}