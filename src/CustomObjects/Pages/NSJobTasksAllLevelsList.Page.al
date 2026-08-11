/// <summary>
/// Page NS_Job Task All Levels List (ID 14021333).
/// </summary>
page 14021333 "NS_Job Task All Levels List"
{
    //PRJ-1184.JS.1.0 New Page
    PageType = List;
    Caption = 'Job Tasks All Levels';
    DataCaptionFields = "Job No.";
    //ApplicationArea = All;//PRJ-1493.AS.1.0 commented
    //UsageCategory = Administration;//PRJ-1493.AS.1.0 commented
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
                    Caption = 'Budget';
                    Editable = false;
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies, in the local currency, the total budgeted cost for the job task during the time period in the Planning Date Filter field.';
                }
                field("Change Orders"; Rec."NS_Change Orders")
                {
                    Caption = 'Budget Sub Levels';
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
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
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
                                JobPlanningLineRec.SetFilter("Line Type", '%1..%2', JobPlanningLineRec."Line Type"::Budget, JobPlanningLineRec."Line Type"::"Both Budget and Billable");
                                JobPlanningLineRec.setrange("Schedule Line", true);
                                if JobPlanningLineRec.FindSet() then
                                    Page.Run(Page::"Job Planning Lines", JobPlanningLineRec);
                            end else begin
                                StrLength := StrLen(JobNo);
                                JobNo := CopyStr(JobNo, 1, StrLength - 1);

                                JobPlanningLineRec.Reset();
                                JobPlanningLineRec.SetFilter("Job No.", JobNo);
                                JobPlanningLineRec.SetFilter("Line Type", '%1..%2', JobPlanningLineRec."Line Type"::Budget, JobPlanningLineRec."Line Type"::"Both Budget and Billable");
                                JobPlanningLineRec.setrange("Schedule Line", true);
                                if JobPlanningLineRec.FindSet() then
                                    Page.Run(Page::"Job Planning Lines", JobPlanningLineRec);
                            end;
                    end;

                }
                field("Net Budget"; Rec."NS_Net Budget")
                {
                    Caption = 'Net Budget';
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Net Budget';

                }

                field("Usage (Total Cost)"; Rec."Usage (Total Cost)")
                {
                    Caption = 'Actual Cost';
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Usage (Total Cost)';
                }
                field("NS_Usage TotCost SubLevel"; rec."NS_Usage TotCost Change Order")
                {
                    Caption = 'Sub Level (Actual Cost)';
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
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
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
                                NSJobLedgerEntry.SetFilter("Entry Type", '%1', NSJobLedgerEntry."Entry Type"::Usage);
                                NSJobLedgerEntry.SetFilter(quantity, '<>%1', 0);
                                if NSJobLedgerEntry.FindSet() then
                                    Page.Run(Page::"Job Ledger Entries", NSJobLedgerEntry);
                            end else begin
                                StrLength := StrLen(JobNo);
                                JobNo := CopyStr(JobNo, 1, StrLength - 1);
                                NSJobLedgerEntry.Reset();
                                NSJobLedgerEntry.SetFilter("Job No.", JobNo);
                                NSJobLedgerEntry.SetFilter("Entry Type", '%1', NSJobLedgerEntry."Entry Type"::Usage);
                                NSJobLedgerEntry.SetFilter(quantity, '<>%1', 0);
                                if NSJobLedgerEntry.FindSet() then
                                    Page.Run(Page::"Job Ledger Entries", NSJobLedgerEntry);
                            end;

                    end;
                }
                field("NS_Usage TotCost Sub Levels"; Rec."NS_Usage Total Actual Cost")
                {
                    Caption = 'Net (Actual Cost';
                    ToolTip = 'Specifies the value of the Usage (Total Cost) Sub Levels field.';
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Contract (Total Cost)"; Rec."Contract (Total Price)")
                {
                    Caption = 'Contract Price';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Contract (Total Price)';
                }

                field("Contract (Total Price)"; rec."NS_Contract Price Sub Levels")
                {
                    Caption = 'Sub level (Contract Price)';
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
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
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
                                JobPlanningLineRec.SetFilter("Line Type", '%1..%2', JobPlanningLineRec."Line Type"::Billable, JobPlanningLineRec."Line Type"::"Both Budget and Billable");
                                JobPlanningLineRec.setrange("Schedule Line", false);
                                if JobPlanningLineRec.FindSet() then
                                    Page.Run(Page::"Job Planning Lines", JobPlanningLineRec);
                            end else begin
                                StrLength := StrLen(JobNo);
                                JobNo := CopyStr(JobNo, 1, StrLength - 1);

                                JobPlanningLineRec.Reset();
                                JobPlanningLineRec.SetFilter("Job No.", JobNo);
                                JobPlanningLineRec.SetFilter("Line Type", '%1..%2', JobPlanningLineRec."Line Type"::Billable, JobPlanningLineRec."Line Type"::"Both Budget and Billable");
                                JobPlanningLineRec.setrange("Schedule Line", false);
                                if JobPlanningLineRec.FindSet() then
                                    Page.Run(Page::"Job Planning Lines", JobPlanningLineRec);
                            end;

                    end;

                }

                field("NS_Net Total Contract Price"; Rec."NS_Net Total Contract Price")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Net Total Contract Price';
                    Editable = false;
                }
                field("Contract (Invoiced Price)"; Rec."Contract (Invoiced Price)")
                {
                    Caption = 'Invoiced Price';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Contract (Invoiced Price)';
                }
                field("NS_Invoiced Price Sub Levels"; Rec."NS_Invoiced Price Sub Levels")
                {
                    Caption = 'Sub Level (Invoiced Price)';
                    ToolTip = 'Specifies the value of the Sub Level (Invoiced Price) field.';
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
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
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
                            end else begin
                                StrLength := StrLen(JobNo);
                                JobNo := CopyStr(JobNo, 1, StrLength - 1);
                                NSJobLedgerEntry.Reset();
                                NSJobLedgerEntry.SetFilter("Job No.", JobNo);
                                NSJobLedgerEntry.SetFilter("Entry Type", '%1', NSJobLedgerEntry."Entry Type"::Sale);
                                NSJobLedgerEntry.SetFilter(quantity, '<>%1', 0);
                                if NSJobLedgerEntry.FindSet() then
                                    Page.Run(Page::"Job Ledger Entries", NSJobLedgerEntry);
                            end;

                    end;

                }
                field("NS_Net Invoiced Price"; Rec."NS_Net Invoiced Price")
                {
                    Caption = 'Net Invoiced Price';
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
                    Caption = 'Remaning Total Cost';
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
                    Caption = 'Commited Cost';
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
                            end else begin
                                PurchaseLine.Reset();
                                PurchaseLine.SetFilter("Document Type", '%1|%2', PurchaseLine."Document Type"::Order, PurchaseLine."Document Type"::Invoice);
                                PurchaseLine.SetFilter("Job No.", rec."Job No.");
                                PurchaseLine.SetFilter("NS_Committed Quantity", '<>%1', 0);
                                if PurchaseLine.FindSet() then
                                    Page.Run(Page::"Purchase Lines", PurchaseLine);
                            end;

                    end;

                }
                field("NS_Committed Costs Sub levels"; Rec."NS_Committed Costs Sub levels")
                {
                    Caption = 'Commited Cost Sub levels';
                    ToolTip = 'Specifies the value of the Sub Levels (Committed Costs) field.';
                    ApplicationArea = All;
                    Editable = false;
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
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobNo += Rec."Job No." + '|';

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
                            end else begin
                                StrLength := StrLen(JobNo);
                                JobNo := CopyStr(JobNo, 1, StrLength - 1);

                                PurchaseLine.Reset();
                                PurchaseLine.SetFilter("Document Type", '%1|%2', PurchaseLine."Document Type"::Order, PurchaseLine."Document Type"::Invoice);
                                PurchaseLine.SetFilter("Job No.", JobNo);
                                PurchaseLine.SetFilter("NS_Committed Quantity", '<>%1', 0);
                                if PurchaseLine.FindSet() then
                                    Page.Run(Page::"Purchase Lines", PurchaseLine);
                            end;

                    end;
                }
                field("NS_Net Committed Costs"; Rec."NS_Net Committed Costs")
                {
                    Caption = 'Net Commited Cost';
                    ToolTip = 'Specifies the value of the Net Committed Costs field.';
                    ApplicationArea = All;
                }
                field("Subcontract Value"; Rec."NS_Subcontract Value")
                {
                    Caption = 'Subcontract';
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
                            end else begin
                                SubcontractLine.Reset();
                                SubcontractLine.SetFilter("NS_Job No.", Rec."Job No.");
                                SubcontractLine.Setfilter(NS_Quantity, '<>%1', 0);
                                if SubcontractLine.FindSet() then
                                    Page.Run(Page::"NS_Subcontract Lines", SubcontractLine);
                            end;
                    end;
                }
                field("NS_Subcon. Value Sub Levels"; rec."NS_Subcon. Value Sub Levels")
                {
                    Caption = 'Subcontract Value Sub Levels';
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
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;
                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
                        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
                        if JobRec.FindSet() then
                            repeat
                                JobNo += JobRec."No." + '|';
                            until JobRec.Next() = 0;

                        JobRec.Reset();
                        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
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
                            end else begin
                                StrLength := StrLen(JobNo);
                                JobNo := CopyStr(JobNo, 1, StrLength - 1);
                                SubcontractLine.Reset();
                                SubcontractLine.SetFilter("NS_Job No.", JobNo);
                                SubcontractLine.Setfilter(NS_Quantity, '<>%1', 0);
                                if SubcontractLine.FindSet() then
                                    Page.Run(Page::"NS_Subcontract Lines", SubcontractLine);
                            end;
                    end;

                }
                field("NS_Net Subcontract Value"; rec."NS_Net Subcontract Value")
                {
                    Caption = 'Net Subcontract Value';
                    Editable = false;
                    ToolTip = 'Specifies the Subcontract Value Sub Level Jobs';
                    ApplicationArea = all;
                }

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
        // JobTaskrec.Reset();
        // JobTaskrec.SetRange("Job No.", Rec."Job No.");
        // IF JobTaskrec.FindSet() then begin
        //     JobTaskrec."Change Orders" := 0;
        //     JobTaskrec.Reallocations := 0;
        //     JobTaskrec."Contract (Total Cost) New" := 0;
        //     JobTaskrec."Usage (Total Cost) New" := 0;
        //     JobTaskrec."Contract (Invoiced Price) New" := 0;
        //     JobTaskrec."Remaining (Total Cost) New" := 0;
        //     JobTaskrec."Remaining (Total Price) New" := 0;
        //     JobTaskrec.ModifyAll("Change Orders", 0);
        //     JobTaskrec.ModifyAll(Reallocations, 0);
        //     JobTaskrec.ModifyAll("Usage (Total Cost) New", 0);
        //     JobTaskrec.ModifyAll("Contract (Total Cost) New", 0);
        //     JobTaskrec.ModifyAll("Contract (Invoiced Price) New", 0);
        //     JobTaskrec.ModifyAll("Remaining (Total Cost) New", 0);
        //     JobTaskrec.ModifyAll("Remaining (Total Price) New", 0);
        // end;
    end;


    trigger OnAfterGetRecord()
    var
        JobNo: Text[2048];
        StrLength: Integer;
    begin
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
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
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
                JobPlanningLineRec.SetFilter("Line Type", '%1..%2', JobPlanningLineRec."Line Type"::Budget, JobPlanningLineRec."Line Type"::"Both Budget and Billable");
                JobPlanningLineRec.setrange("Schedule Line", true);
                if JobPlanningLineRec.FindSet() then begin
                    JobPlanningLineRec.CalcSums("Total Cost (LCY)");
                    Rec."NS_Change Orders" := JobPlanningLineRec."Total Cost (LCY)";
                end else
                    IF Rec."Job Task No." <> TotalTaskNo then
                        Rec."NS_Change Orders" := 0;
            end else begin
                StrLength := StrLen(JobNo);
                JobNo := CopyStr(JobNo, 1, StrLength - 1);

                JobPlanningLineRec.Reset();
                JobPlanningLineRec.SetFilter("Job No.", JobNo);
                JobPlanningLineRec.SetFilter("Line Type", '%1..%2', JobPlanningLineRec."Line Type"::Budget, JobPlanningLineRec."Line Type"::"Both Budget and Billable");
                JobPlanningLineRec.setrange("Schedule Line", true);
                if JobPlanningLineRec.FindSet() then begin
                    JobPlanningLineRec.CalcSums("Total Cost (LCY)");
                    Rec."NS_Change Orders" := JobPlanningLineRec."Total Cost (LCY)";
                end else
                    IF Rec."Job Task No." <> TotalTaskNo then
                        Rec."NS_Change Orders" := 0;
            end;
        Rec.Modify();

        //Net Budget
        Rec.CalcFields("Schedule (Total Cost)");
        Rec."NS_Net Budget" := Rec."Schedule (Total Cost)" + Rec."NS_Change Orders";
        Rec.Modify();

        //Committed Cost
        Clear(JobNoFilter);
        JobNoFilter := '@*' + Format(Rec."Job No.") + '*';
        Clear(JobNo);
        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobNo += Rec."Job No." + '|';

        IF JobNo <> '' then
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

        //get Subcontract value master Job        
        IF rec."Job No." <> '' then
            if rec."Job Task Type" = Rec."Job Task Type"::Posting then begin
                SubcontractLine.Reset();
                SubcontractLine.SetFilter("NS_Job No.", rec."Job No.");
                SubcontractLine.SetRange("NS_Job Task No.", Rec."Job Task No.");
                SubcontractLine.Setfilter(NS_Quantity, '<>%1', 0);
                if SubcontractLine.FindSet() then begin
                    SubcontractLine.CalcSums("NS_Total Cost");
                    Rec."NS_Subcontract Value" := SubcontractLine."NS_Total Cost";
                end;
            end else begin
                SubcontractLine.Reset();
                SubcontractLine.SetFilter("NS_Job No.", rec."Job No.");
                SubcontractLine.Setfilter(NS_Quantity, '<>%1', 0);
                if SubcontractLine.FindSet() then begin
                    SubcontractLine.CalcSums("NS_Total Cost");
                    Rec."NS_Subcontract Value" := SubcontractLine."NS_Total Cost";
                end;
            end;
        Rec.Modify();

        //Add Usage Actual Cost for sub levels-Start
        Clear(JobNo);
        Clear(JobNoFilter);
        JobNoFilter := '@*' + Format(Rec."Job No.") + '*';
        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        IF JobNo <> '' then
            if rec."Job Task Type" = rec."Job Task Type"::Posting then begin
                StrLength := StrLen(JobNo);
                JobNo := CopyStr(JobNo, 1, StrLength - 1);

                NSJobLedgerEntry2.Reset();
                NSJobLedgerEntry2.SetFilter("Job No.", JobNo);
                NSJobLedgerEntry2.SetFilter("Job Task No.", '%1', Rec."Job Task No.");
                NSJobLedgerEntry2.SetFilter("Entry Type", '%1', NSJobLedgerEntry2."Entry Type"::Usage);
                NSJobLedgerEntry2.SetFilter(quantity, '<>%1', 0);
                if NSJobLedgerEntry2.FindSet() then begin
                    NSJobLedgerEntry2.CalcSums("Total Cost (LCY)");
                    Rec."NS_Usage TotCost Change Order" := NSJobLedgerEntry2."Total Cost (LCY)";
                end;
            end else begin
                StrLength := StrLen(JobNo);
                JobNo := CopyStr(JobNo, 1, StrLength - 1);

                NSJobLedgerEntry2.Reset();
                NSJobLedgerEntry2.SetFilter("Job No.", JobNo);
                NSJobLedgerEntry2.SetFilter("Entry Type", '%1', NSJobLedgerEntry2."Entry Type"::Usage);
                NSJobLedgerEntry2.SetFilter(quantity, '<>%1', 0);
                if NSJobLedgerEntry2.FindSet() then begin
                    NSJobLedgerEntry2.CalcSums("Total Cost (LCY)");
                    Rec."NS_Usage TotCost Change Order" := NSJobLedgerEntry2."Total Cost (LCY)";
                end;
            end;
        Rec.CalcFields("Usage (Total Cost)");
        rec."NS_Usage Total Actual Cost" := Rec."Usage (Total Cost)" + Rec."NS_Usage TotCost Change Order";
        Rec.Modify();

        //Sub Levels Jobs Contract Price start
        Clear(JobNo);
        Clear(JobNoFilter);
        JobNoFilter := '@*' + Format(Rec."Job No.") + '*';
        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
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
                JobPlanningLineRec.SetFilter("Line Type", '%1..%2', JobPlanningLineRec."Line Type"::Billable, JobPlanningLineRec."Line Type"::"Both Budget and Billable");
                JobPlanningLineRec.setrange("Schedule Line", false);
                if JobPlanningLineRec.FindSet() then begin
                    JobPlanningLineRec.CalcSums("Total Price (LCY)");
                    rec."NS_Contract Price Sub Levels" := JobPlanningLineRec."Total Price (LCY)";
                end;
            end else begin
                StrLength := StrLen(JobNo);
                JobNo := CopyStr(JobNo, 1, StrLength - 1);

                JobPlanningLineRec.Reset();
                JobPlanningLineRec.SetFilter("Job No.", JobNo);
                JobPlanningLineRec.SetFilter("Line Type", '%1..%2', JobPlanningLineRec."Line Type"::Billable, JobPlanningLineRec."Line Type"::"Both Budget and Billable");
                JobPlanningLineRec.setrange("Schedule Line", false);
                if JobPlanningLineRec.FindSet() then begin
                    JobPlanningLineRec.CalcSums("Total Price (LCY)");
                    rec."NS_Contract Price Sub Levels" := JobPlanningLineRec."Total Price (LCY)";
                end;
            end;
        Rec.Modify();
        Rec.CalcFields("Contract (Total Price)");
        rec."NS_Net Total Contract Price" := Rec."Contract (Total Price)" + Rec."NS_Contract Price Sub Levels";
        Rec.Modify();
        //Sub Levels Jobs Contract Price end

        //Sub level Invoices Amount - start
        Clear(JobNo);
        Clear(JobNoFilter);
        JobNoFilter := '@*' + format(Rec."Job No.") + '*';
        JobRec.Reset();
        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        IF JobNo <> '' then
            if rec."Job Task Type" = rec."Job Task Type"::Posting then begin
                StrLength := StrLen(JobNo);
                JobNo := CopyStr(JobNo, 1, StrLength - 1);

                NSJobLedgerEntry2.Reset();
                NSJobLedgerEntry2.SetFilter("Job No.", JobNo);
                NSJobLedgerEntry2.SetFilter("Job Task No.", '%1', Rec."Job Task No.");
                NSJobLedgerEntry2.SetFilter("Entry Type", '%1', NSJobLedgerEntry2."Entry Type"::Sale);
                NSJobLedgerEntry2.SetFilter(quantity, '<>%1', 0);
                if NSJobLedgerEntry2.FindSet() then begin
                    NSJobLedgerEntry2.CalcSums("Total Price (LCY)");
                    rec."NS_Invoiced Price Sub Levels" := ABS(NSJobLedgerEntry2."Total Price (LCY)");
                end;
            end else begin
                StrLength := StrLen(JobNo);
                JobNo := CopyStr(JobNo, 1, StrLength - 1);

                NSJobLedgerEntry2.Reset();
                NSJobLedgerEntry2.SetFilter("Job No.", JobNo);
                NSJobLedgerEntry2.SetFilter("Entry Type", '%1', NSJobLedgerEntry2."Entry Type"::Sale);
                NSJobLedgerEntry2.SetFilter(quantity, '<>%1', 0);
                if NSJobLedgerEntry2.FindSet() then begin
                    NSJobLedgerEntry2.CalcSums("Total Price (LCY)");
                    rec."NS_Invoiced Price Sub Levels" := ABS(NSJobLedgerEntry2."Total Price (LCY)");
                end;
            end;
        rec.CalcFields("Contract (Invoiced Price)");
        Rec."NS_Net Invoiced Price" := rec."NS_Invoiced Price Sub Levels" + ABS(Rec."Contract (Invoiced Price)");
        Rec.Modify();
        Rec."NS_Unbilled Revenue New" := rec."NS_Net Total Contract Price" - Rec."NS_Net Invoiced Price";
        Rec."NS_Remaining (Total Cost) New" := rec."NS_Net Budget" - Rec."NS_Usage Total Actual Cost";
        Rec.Modify();

        //Calculate commited cost sub levels-start
        IF rec."Job No." <> '' then
            if rec."Job Task Type" = rec."Job Task Type"::Posting then begin
                PurchaseLine.Reset();
                PurchaseLine.SetFilter("Document Type", '%1|%2', PurchaseLine."Document Type"::Order, PurchaseLine."Document Type"::Invoice);
                PurchaseLine.SetFilter("Job No.", Rec."Job No.");
                PurchaseLine.SetRange("Job Task No.", Rec."Job Task No.");
                PurchaseLine.SetFilter("NS_Committed Quantity", '<>%1', 0);
                if PurchaseLine.FindSet() then begin
                    PurchaseLine.CalcSums("NS_Committed Amount");
                    rec."NS_Committed Costs Master Job" := PurchaseLine."NS_Committed Amount";
                end;
            end else begin
                PurchaseLine.Reset();
                PurchaseLine.SetFilter("Document Type", '%1|%2', PurchaseLine."Document Type"::Order, PurchaseLine."Document Type"::Invoice);
                PurchaseLine.SetFilter("Job No.", Rec."Job No.");
                PurchaseLine.SetFilter("NS_Committed Quantity", '<>%1', 0);
                if PurchaseLine.FindSet() then begin
                    PurchaseLine.CalcSums("NS_Committed Amount");
                    rec."NS_Committed Costs Master Job" := PurchaseLine."NS_Committed Amount";
                end;
            end;


        Clear(JobNoFilter);
        JobNoFilter := '@*' + format(Rec."Job No.") + '*';
        Clear(JobNo);
        JobRec.Reset();
        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Work Order");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
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
                if PurchaseLine.FindSet() then begin
                    PurchaseLine.CalcSums("NS_Committed Amount");
                    rec."NS_Committed Costs Sub levels" := PurchaseLine."NS_Committed Amount";
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
                    rec."NS_Committed Costs Sub levels" := PurchaseLine."NS_Committed Amount";
                end;
            end;
        Rec.Modify();
        rec."NS_Net Committed Costs" := rec."NS_Committed Costs Master Job" + rec."NS_Committed Costs Sub levels";
        Rec.Modify();
        //Calculate commited cost sub levels-end

        //Calculate Sub Levels Subcontract cost - start
        Clear(JobNoFilter);
        JobNoFilter := '@*' + format(Rec."Job No.") + '*';
        Clear(JobNo);
        JobRec.Reset();
        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Extra Work");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::"Change Order");
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        JobRec.SetRange("NS_Job Class", JobRec."NS_Job Class"::SubJob);
        if JobRec.FindSet() then
            repeat
                JobNo += JobRec."No." + '|';
            until JobRec.Next() = 0;

        JobRec.Reset();
        JobRec.Setfilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
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
                if SubcontractLine.FindSet() then begin
                    SubcontractLine.CalcSums("NS_Total Cost");
                    Rec."NS_Subcon. Value Sub Levels" := SubcontractLine."NS_Total Cost";
                end else
                    Rec."NS_Subcon. Value Sub Levels" := 0;
            end else begin
                StrLength := StrLen(JobNo);
                JobNo := CopyStr(JobNo, 1, StrLength - 1);
                SubcontractLine.Reset();
                SubcontractLine.SetFilter("NS_Job No.", JobNo);
                SubcontractLine.Setfilter(NS_Quantity, '<>%1', 0);
                if SubcontractLine.FindSet() then begin
                    SubcontractLine.CalcSums("NS_Total Cost");
                    Rec."NS_Subcon. Value Sub Levels" := SubcontractLine."NS_Total Cost";
                end else
                    Rec."NS_Subcon. Value Sub Levels" := 0;
            end;
        rec.Modify();
        rec."NS_Net Subcontract Value" := rec."NS_Subcontract Value" + rec."NS_Subcon. Value Sub Levels";
        rec.Modify();
        //Calculate Sub Levels Subcontract cost - start

        Commit();
    end;

    var

        JobRec: Record Job;
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
        TotalTaskNo: Code[50];
        NewJobNo: Code[30];
        JobNoFilter: Code[30];


    /// <summary>
    /// CalculateAllCustomFields.
    /// </summary>
    /// <param name="Rec">Record "Job Task".</param>
    procedure CalculateAllCustomFields(Rec: Record "Job Task")
    begin

    end;
}