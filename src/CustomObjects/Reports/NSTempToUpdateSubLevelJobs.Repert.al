report 14021397 "NS_Update Sub Level Job"
{

    //PRJ-1015.JS.1.0 10Oct2021 New Batch report

    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Update Sub Level Job number form Job to Job Ledger Entry';
    //Permissions = 

    dataset
    {
        dataitem("Job Ledger Entry"; "Job Ledger Entry")
        {
            DataItemTableView = SORTING("Job No.");
            trigger OnAfterGetRecord()
            var
            begin
                if jobRec.Get("Job Ledger Entry"."Job No.") then begin
                    "Job Ledger Entry"."NS_Sub-Level to Job No." := jobRec."NS_Sub-Level to Job No.";
                    "Job Ledger Entry".Modify();
                end;
            end;

            trigger OnPreDataItem()
            begin
            end;

        }
        dataitem("Job Planning Line"; "Job Planning Line")
        {
            DataItemTableView = SORTING("Job No.");
            trigger OnAfterGetRecord()
            var
            begin
                if jobRec.Get("Job Planning Line"."Job No.") then begin
                    "Job Planning Line"."NS_Sub-Level to Job No." := jobRec."NS_Sub-Level to Job No.";
                    "Job Planning Line".Modify();
                end;
            end;

            trigger OnPreDataItem()
            begin
            end;

        }
        dataitem("NS_Job Include Sub Levels"; "NS_Job Include Sub Levels")
        {
            DataItemTableView = SORTING("NS_Job No.");
            trigger OnAfterGetRecord()
            var
            begin
                if jobRec.Get("NS_Job Include Sub Levels"."NS_Job No.") then begin
                    "NS_Job Include Sub Levels"."NS_Job Class" := jobRec."NS_Job Class";
                    "NS_Job Include Sub Levels".Modify();
                end;
            end;

            trigger OnPreDataItem()
            begin
            end;

        }
        dataitem("NS_Percentage of Completion"; "NS_Percentage of Completion")
        {
            DataItemTableView = sorting("NS_Job No.");
            trigger OnAfterGetRecord()
            var
            begin
                //JobNoFilterText := '@*'+'PR2062'+'*';
                "NS_Percentage of Completion".DeleteAll();
            end;

            trigger OnPreDataItem()
            begin
            end;

        }
        dataitem(NS_RevenueRecSummaryTab; NS_RevenueRecSummaryTab)
        {
            DataItemTableView = sorting("NS_Entry No.");
            trigger OnAfterGetRecord()
            var
            begin
                NS_RevenueRecSummaryTab.DeleteAll();
            end;

            trigger OnPreDataItem()
            begin
            end;
        }

        dataitem("NS_Job Forecast"; "NS_Job Forecast")
        {
            DataItemTableView = sorting("NS_Job No.");
            trigger OnAfterGetRecord()
            var
            begin
                "NS_Job Forecast".DeleteAll();
            end;

            trigger OnPreDataItem()
            begin
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

                    // }
                }
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
        Message('Successfully Updated Update Sub Level Job number form Job to Job Ledger Entry');
    end;

    trigger OnPreReport()
    var
    begin
    end;

    var
        jobRec: Record Job;
}